using ComponentArrays: ComponentArray
using ForwardDiff: gradient, hessian
using LinearAlgebra: diag, inv
using Optim: LBFGS, NewtonTrustRegion, OnceDifferentiable, converged, iterations, minimum, minimizer, optimize, termination_status

function _flatten_init_params(init_params)
  if init_params isa ComponentArray
    return collect(init_params), Symbol.(propertynames(init_params))
  end

  if init_params isa NamedTuple
    params = ComponentArray(init_params)
    return collect(params), Symbol.(propertynames(params))
  end

  if init_params isa AbstractDict
    parameter_pairs = collect(pairs(init_params))
    parameter_names = Symbol.(first.(parameter_pairs))
    values = last.(parameter_pairs)
    return Float64.(values), parameter_names
  end

  if init_params isa AbstractVector
    return Float64.(init_params), Symbol.(string.("parameter_", eachindex(init_params)))
  end

  throw(ArgumentError("Unsupported initial parameter container for fit_model."))
end

function _named_component_array(x, parameter_names)
  ComponentArray(NamedTuple{Tuple(parameter_names)}(Tuple(x)))
end

function fit_model(init_params, data_dict, config = Dict())
  x0, parameter_names = _flatten_init_params(init_params)
  objective_config = merge(Dict(:parameter_names => String.(parameter_names)), Dict(config))

  objective = x -> evaluate_nll(_named_component_array(x, parameter_names), data_dict, objective_config)
  gradient! = (storage, x) -> copyto!(storage, gradient(objective, x))

  method = get(config, :optimizer, :lbfgs) == :newton ? NewtonTrustRegion() : LBFGS()
  objective_function = OnceDifferentiable(objective, gradient!, x0)
  result = optimize(objective_function, x0, method)

  xhat = minimizer(result)
  hessian_matrix = hessian(objective, xhat)
  covariance = try
    inv(hessian_matrix)
  catch
    fill(eltype(hessian_matrix)(NaN), size(hessian_matrix))
  end
  standard_errors = if any(isnan, covariance)
    fill(eltype(hessian_matrix)(NaN), length(parameter_names))
  else
    sqrt.(abs.(diag(covariance)))
  end

  Dict(
    "estimates" => Dict(String(name) => value for (name, value) in zip(parameter_names, xhat)),
    "nll" => minimum(result),
    "convergence" => converged(result),
    "convergence_code" => string(termination_status(result)),
    "iterations" => iterations(result),
    "gradient" => gradient(objective, xhat),
    "hessian" => hessian_matrix,
    "covariance" => covariance,
    "standard_errors" => Dict(String(name) => value for (name, value) in zip(parameter_names, standard_errors)),
  )
end
