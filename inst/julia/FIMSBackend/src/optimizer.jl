using ComponentArrays: ComponentArray, getaxes
using ForwardDiff: gradient, hessian
using LinearAlgebra: Symmetric, cholesky, diag, inv, logdet, pinv
using Optim: LBFGS, OnceDifferentiable, converged, iterations, minimum, minimizer, optimize

_primal_float(value::ForwardDiff.Dual) = _primal_float(ForwardDiff.value(value))
_primal_float(value::Real) = Float64(value)

function _flatten_init_params(init_params)
  if init_params isa ComponentArray
    return Float64.(collect(init_params)), init_params
  end

  if init_params isa NamedTuple
    params = ComponentArray(init_params)
    return Float64.(collect(params)), params
  end

  if init_params isa AbstractDict
    params = component_array_from_input(init_params, Dict())
    return Float64.(collect(params)), params
  end

  if init_params isa AbstractVector
    parameter_names = [Symbol("parameter_$index") for index in eachindex(init_params)]
    return Float64.(init_params), parameter_names
  end

  throw(ArgumentError("Unsupported initial parameter container for fit_model."))
end

function _named_component_array(x, parameter_layout)
  if parameter_layout isa ComponentArray
    return ComponentArray(x, getaxes(parameter_layout))
  end

  ComponentArray(NamedTuple{Tuple(parameter_layout)}(Tuple(x)))
end

function _result_dict(component)
  Dict(String(name) => getproperty(component, name) for name in propertynames(component))
end

function _compose_parameter_vector(x0, fixed_indices, fixed_values, random_indices, random_values)
  value_type = promote_type(eltype(x0), eltype(fixed_values), eltype(random_values))
  parameters = value_type.(x0)
  parameters[fixed_indices] .= fixed_values
  parameters[random_indices] .= random_values
  parameters
end

function _numerical_gradient(objective, x)
  result = similar(x)
  for index in eachindex(x)
    step = cbrt(eps(Float64)) * max(abs(x[index]), 1.0)
    upper = copy(x)
    lower = copy(x)
    upper[index] += step
    lower[index] -= step
    result[index] = (objective(upper) - objective(lower)) / (2 * step)
  end
  result
end

function _positive_definite_logdet(hessian_matrix)
  factorization = try
    cholesky(Symmetric(hessian_matrix))
  catch error
    throw(ArgumentError("Random-effect Hessian is not positive definite: $(sprint(showerror, error))"))
  end
  logdet(factorization)
end

function fit_model(init_params, data_dict, config = Dict())
  x0, parameter_layout = _flatten_init_params(init_params)
  parameter_names =
    parameter_layout isa ComponentArray ?
    String.(Symbol.(propertynames(parameter_layout))) :
    String.(parameter_layout)
  objective_config = merge(Dict(:parameter_names => parameter_names), Dict(config))

  fixed_mask = Bool.(collect(get(objective_config, :fixed_parameter_mask, trues(length(x0)))))
  random_mask = Bool.(collect(get(objective_config, :random_parameter_mask, falses(length(x0)))))
  length(fixed_mask) == length(x0) ||
    throw(ArgumentError("fixed_parameter_mask must match the initial parameter count."))
  length(random_mask) == length(x0) ||
    throw(ArgumentError("random_parameter_mask must match the initial parameter count."))
  any(fixed_mask .& random_mask) &&
    throw(ArgumentError("A parameter cannot be both fixed and random."))

  fixed_indices = findall(fixed_mask)
  random_indices = findall(random_mask)
  isempty(fixed_indices) && isempty(random_indices) &&
    throw(ArgumentError("The model has no fixed or random parameters to fit."))
  fixed_start = x0[fixed_indices]
  random_start = x0[random_indices]
  joint_objective = parameters ->
    evaluate_nll(_named_component_array(parameters, parameter_layout), data_dict, objective_config)

  function conditional_mode(fixed_values)
    if isempty(random_indices)
      parameters = _compose_parameter_vector(x0, fixed_indices, fixed_values, random_indices, Float64[])
      return (
        parameters = parameters,
        random_hessian = zeros(Float64, 0, 0),
        joint_nll = joint_objective(parameters),
        marginal_nll = joint_objective(parameters),
        converged = true,
        iterations = 0,
      )
    end

    random_objective = random_values -> begin
      parameters =
        _compose_parameter_vector(x0, fixed_indices, fixed_values, random_indices, random_values)
      joint_objective(parameters)
    end
    random_gradient! = (storage, random_values) ->
      copyto!(storage, gradient(random_objective, random_values))
    random_result = optimize(
      OnceDifferentiable(random_objective, random_gradient!, random_start),
      random_start,
      LBFGS(),
    )
    random_mode = minimizer(random_result)
    parameters =
      _compose_parameter_vector(x0, fixed_indices, fixed_values, random_indices, random_mode)
    random_hessian = hessian(random_objective, random_mode)
    marginal_nll =
      minimum(random_result) + 0.5 * _positive_definite_logdet(random_hessian) -
      0.5 * length(random_indices) * log(2π)
    (
      parameters = parameters,
      random_hessian = random_hessian,
      joint_nll = minimum(random_result),
      marginal_nll = marginal_nll,
      converged = converged(random_result),
      iterations = iterations(random_result),
    )
  end

  marginal_objective = fixed_values -> conditional_mode(fixed_values).marginal_nll
  outer_gradient! = (storage, fixed_values) -> begin
    values = if isempty(random_indices)
      gradient(marginal_objective, fixed_values)
    else
      _numerical_gradient(marginal_objective, fixed_values)
    end
    copyto!(storage, values)
  end

  outer_result = if isempty(fixed_indices)
    nothing
  else
    optimize(
      OnceDifferentiable(marginal_objective, outer_gradient!, fixed_start),
      fixed_start,
      LBFGS(),
    )
  end
  fixed_hat = _primal_float.(isnothing(outer_result) ? fixed_start : minimizer(outer_result))
  conditional_result = conditional_mode(fixed_hat)
  xhat = _primal_float.(conditional_result.parameters)
  estimate_components = _named_component_array(xhat, parameter_layout)
  evaluated_model = evaluate_model(estimate_components, data_dict, objective_config)

  joint_hessian = hessian(joint_objective, xhat)
  free_indices = vcat(fixed_indices, random_indices)
  free_hessian = Symmetric(joint_hessian[free_indices, free_indices])
  free_covariance = try
    inv(free_hessian)
  catch
    pinv(Matrix(free_hessian))
  end
  covariance = zeros(Float64, length(x0), length(x0))
  covariance[free_indices, free_indices] .= free_covariance
  variances = fill(NaN, length(x0))
  variances[free_indices] .= diag(free_covariance)
  standard_errors = map(variances) do variance
    isfinite(variance) && variance >= 0 ? sqrt(variance) : NaN
  end
  se_components = _named_component_array(standard_errors, parameter_layout)

  fit_gradient = zeros(Float64, length(x0))
  if !isempty(fixed_indices)
    fixed_gradient = if isempty(random_indices)
      gradient(marginal_objective, fixed_hat)
    else
      _numerical_gradient(marginal_objective, fixed_hat)
    end
    fit_gradient[fixed_indices] .= fixed_gradient
  end

  Dict(
    "estimates" => _result_dict(estimate_components),
    "fixed_parameters" => fixed_hat,
    "fixed_gradient" => fit_gradient[fixed_indices],
    "fixed_effect_count" => length(fixed_indices),
    "random_effect_count" => length(random_indices),
    "nll" => conditional_result.marginal_nll,
    "convergence" => isnothing(outer_result) ? conditional_result.converged : converged(outer_result),
    "convergence_code" =>
      isnothing(outer_result) ?
      (conditional_result.converged ? "random_effects_converged" : "random_effects_not_converged") :
      (converged(outer_result) ? "converged" : "not_converged"),
    "iterations" => isnothing(outer_result) ? conditional_result.iterations : iterations(outer_result),
    "gradient" => fit_gradient,
    "report" => evaluated_model["report"],
    "hessian" => joint_hessian,
    "covariance" => covariance,
    "standard_errors" => _result_dict(se_components),
  )
end
