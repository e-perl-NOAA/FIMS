using ComponentArrays: ComponentArray, getaxes
using ForwardDiff: gradient, hessian
using LinearAlgebra: Symmetric, diag, inv, pinv
using Optim: LBFGS, NewtonTrustRegion, OnceDifferentiable, converged, iterations, minimum, minimizer, optimize, termination_status

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
    return Float64.(init_params), Symbol.(string.("parameter_", eachindex(init_params)))
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

function fit_model(init_params, data_dict, config = Dict())
  x0, parameter_layout = _flatten_init_params(init_params)
  parameter_names =
    parameter_layout isa ComponentArray ?
    String.(Symbol.(propertynames(parameter_layout))) :
    String.(parameter_layout)
  objective_config = merge(Dict(:parameter_names => parameter_names), Dict(config))

  objective = x -> evaluate_nll(_named_component_array(x, parameter_layout), data_dict, objective_config)
  gradient! = (storage, x) -> copyto!(storage, gradient(objective, x))

  method = get(config, :optimizer, :lbfgs) == :newton ? NewtonTrustRegion() : LBFGS()
  objective_function = OnceDifferentiable(objective, gradient!, x0)
  result = optimize(objective_function, x0, method)

  xhat = minimizer(result)
  estimate_components = _named_component_array(xhat, parameter_layout)
  hessian_matrix = hessian(objective, xhat)
  covariance = try
    inv(Symmetric(hessian_matrix))
  catch
    pinv(Matrix(hessian_matrix))
  end
  variances = diag(covariance)
  standard_errors = similar(variances)
  for index in eachindex(variances)
    standard_errors[index] =
      variances[index] >= 0 ? sqrt(variances[index]) : oftype(variances[index], NaN)
  end
  se_components = _named_component_array(standard_errors, parameter_layout)

  Dict(
    "estimates" =>
      if parameter_layout isa ComponentArray
        _result_dict(estimate_components)
      else
        Dict(String(name) => value for (name, value) in zip(parameter_layout, xhat))
      end,
    "nll" => minimum(result),
    "convergence" => converged(result),
    "convergence_code" => string(termination_status(result)),
    "iterations" => iterations(result),
    "gradient" => gradient(objective, xhat),
    "hessian" => hessian_matrix,
    "covariance" => covariance,
    "standard_errors" =>
      if parameter_layout isa ComponentArray
        _result_dict(se_components)
      else
        Dict(String(name) => value for (name, value) in zip(parameter_layout, standard_errors))
      end,
  )
end
