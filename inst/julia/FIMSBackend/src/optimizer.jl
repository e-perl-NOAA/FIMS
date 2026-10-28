using ComponentArrays: ComponentArray, getaxes
using ForwardDiff: gradient, hessian
using LinearAlgebra: Symmetric, cholesky, diag, inv, isposdef, logdet, pinv
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

function _numerical_hessian(objective, x)
  hessian_matrix = Matrix{Float64}(undef, length(x), length(x))
  steps = eps(Float64)^(1 / 4) .* max.(abs.(x), 1.0)
  objective_value = Float64(objective(x))
  for row in eachindex(x)
    upper = copy(x)
    lower = copy(x)
    upper[row] += steps[row]
    lower[row] -= steps[row]
    hessian_matrix[row, row] =
      (Float64(objective(upper)) - 2 * objective_value + Float64(objective(lower))) /
      steps[row]^2
    for column in 1:(row - 1)
      upper_upper = copy(x)
      upper_lower = copy(x)
      lower_upper = copy(x)
      lower_lower = copy(x)
      upper_upper[row] += steps[row]
      upper_upper[column] += steps[column]
      upper_lower[row] += steps[row]
      upper_lower[column] -= steps[column]
      lower_upper[row] -= steps[row]
      lower_upper[column] += steps[column]
      lower_lower[row] -= steps[row]
      lower_lower[column] -= steps[column]
      value =
        (
          Float64(objective(upper_upper)) -
          Float64(objective(upper_lower)) -
          Float64(objective(lower_upper)) +
          Float64(objective(lower_lower))
        ) / (4 * steps[row] * steps[column])
      hessian_matrix[row, column] = value
      hessian_matrix[column, row] = value
    end
  end
  hessian_matrix
end

function _positive_definite_logdet(hessian_matrix)
  factorization = try
    cholesky(Symmetric(hessian_matrix))
  catch error
    throw(ArgumentError("Random-effect Hessian is not positive definite: $(sprint(showerror, error))"))
  end
  logdet(factorization)
end

function _report_standard_errors(
  parameters,
  parameter_layout,
  data_dict,
  config,
  covariance,
)
  report = evaluate_model(_named_component_array(parameters, parameter_layout), data_dict, config)["report"]
  report_standard_error_fields = Set([
    "agecomp_expected",
    "agecomp_proportion",
    "biomass",
    "catch_expected_by_fleet",
    "catch_numbers_by_fleet",
    "catch_numbers_at_age_by_fleet",
    "catch_numbers_at_length_by_fleet",
    "catch_weight_by_fleet",
    "catch_weight_at_age_by_fleet",
    "expected_recruitment",
    "index_expected_by_fleet",
    "index_numbers_by_fleet",
    "index_numbers_at_age_by_fleet",
    "index_numbers_at_length_by_fleet",
    "index_weight_by_fleet",
    "index_weight_at_age_by_fleet",
    "lengthcomp_expected",
    "lengthcomp_proportion",
    "log_catch_expected_by_fleet",
    "log_index_expected_by_fleet",
    "mortality_F",
    "mortality_M",
    "mortality_Z",
    "numbers_at_age",
    "proportion_mature_at_age",
    "spawning_biomass",
    "spawning_biomass_ratio",
    "sum_selectivity",
    "total_catch_numbers",
    "total_catch_weight",
    "unfished_biomass",
    "unfished_numbers_at_age",
    "unfished_spawning_biomass",
  ])
  report_names = sort!(
    String[
      name for (name, value) in report if
      name in report_standard_error_fields &&
      (value isa Real || (value isa AbstractArray && eltype(value) <: Real))
    ],
  )
  isempty(report_names) && return Dict{String, Any}()

  report_lengths = map(report_names) do name
    value = report[name]
    value isa Real ? 1 : length(value)
  end
  flatten_reports = parameters -> begin
    evaluated_report =
      evaluate_model(_named_component_array(parameters, parameter_layout), data_dict, config)["report"]
    vcat(
      (
        evaluated_report[name] isa Real ?
        [evaluated_report[name]] :
        vec(evaluated_report[name])
        for name in report_names
      )...,
    )
  end
  report_jacobian = ForwardDiff.jacobian(flatten_reports, parameters)
  weighted_jacobian = report_jacobian * covariance
  report_variances = vec(sum(weighted_jacobian .* report_jacobian, dims = 2))
  report_standard_errors = map(report_variances) do variance
    isfinite(variance) && variance >= 0 ? sqrt(variance) : NaN
  end

  output = Dict{String, Any}()
  report_values = Float64[]
  report_value_names = String[]
  offset = 1
  for (name, length) in zip(report_names, report_lengths)
    value = report[name]
    standard_errors = report_standard_errors[offset:(offset + length - 1)]
    output[name] = value isa Real ? only(standard_errors) : reshape(standard_errors, size(value))
    values = value isa Real ? [value] : vec(value)
    append!(report_values, values)
    if length == 1
      push!(report_value_names, name)
    else
      append!(report_value_names, ["$name[$index]" for index in 1:length])
    end
    offset += length
  end
  report_covariance =
    Bool(get(config, :compute_report_covariance, false)) ?
    report_jacobian * covariance * report_jacobian' :
    nothing
  (
    standard_errors = output,
    standard_errors_flat = report_standard_errors,
    values = report_values,
    value_names = report_value_names,
    covariance = report_covariance,
  )
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
  compute_standard_errors = Bool(get(objective_config, :compute_standard_errors, true))
  fixed_hessian = if isempty(fixed_indices)
    zeros(Float64, 0, 0)
  elseif isempty(random_indices)
    Matrix(Symmetric(joint_hessian[fixed_indices, fixed_indices]))
  elseif compute_standard_errors
    _numerical_hessian(marginal_objective, fixed_hat)
  else
    Matrix(Symmetric(joint_hessian[fixed_indices, fixed_indices]))
  end
  fixed_covariance = try
    inv(Symmetric(fixed_hessian))
  catch
    pinv(fixed_hessian)
  end
  conditional_random_covariance = if isempty(random_indices)
    zeros(Float64, 0, 0)
  else
    random_hessian = Symmetric(joint_hessian[random_indices, random_indices])
    try
      inv(random_hessian)
    catch
      pinv(Matrix(random_hessian))
    end
  end
  random_fixed_sensitivity =
    isempty(random_indices) || isempty(fixed_indices) ?
    zeros(Float64, length(random_indices), length(fixed_indices)) :
    -conditional_random_covariance * joint_hessian[random_indices, fixed_indices]
  random_covariance =
    conditional_random_covariance +
    random_fixed_sensitivity * fixed_covariance * random_fixed_sensitivity'
  covariance = zeros(Float64, length(x0), length(x0))
  covariance[fixed_indices, fixed_indices] .= fixed_covariance
  covariance[random_indices, random_indices] .= random_covariance
  if !isempty(fixed_indices) && !isempty(random_indices)
    covariance[random_indices, fixed_indices] .= random_fixed_sensitivity * fixed_covariance
    covariance[fixed_indices, random_indices] .=
      covariance[random_indices, fixed_indices]'
  end
  variances = fill(NaN, length(x0))
  variances[fixed_indices] .= diag(fixed_covariance)
  variances[random_indices] .= diag(random_covariance)
  standard_errors = map(variances) do variance
    isfinite(variance) && variance >= 0 ? sqrt(variance) : NaN
  end
  if !compute_standard_errors
    fill!(standard_errors, NaN)
  end
  se_components = _named_component_array(standard_errors, parameter_layout)
  report_uncertainty =
    compute_standard_errors ?
    _report_standard_errors(xhat, parameter_layout, data_dict, objective_config, covariance) :
    (
      standard_errors = Dict{String, Any}(),
      standard_errors_flat = Float64[],
      values = Float64[],
      value_names = String[],
      covariance = nothing,
    )

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
    "report_standard_errors" => report_uncertainty.standard_errors,
    "report_standard_errors_flat" => report_uncertainty.standard_errors_flat,
    "report_values" => report_uncertainty.values,
    "report_value_names" => report_uncertainty.value_names,
    "report_covariance" => report_uncertainty.covariance,
    "pd_hessian" => isempty(fixed_indices) || isposdef(Symmetric(fixed_hessian)),
    "hessian" => joint_hessian,
    "fixed_hessian" => fixed_hessian,
    "covariance" => covariance,
    "standard_errors" => _result_dict(se_components),
  )
end
