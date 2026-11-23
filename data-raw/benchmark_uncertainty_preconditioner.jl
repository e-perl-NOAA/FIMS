module FIMSUncertaintyBenchmark

using FIMSBackend
using LinearAlgebra

# Keep the exported backend's imports in the installed package's dependency scope.
const Baseline = Core.eval(FIMSBackend, :(module UncertaintyBenchmarkBaseline end))

const problem = Ref{Any}(nothing)

function prepare(baseline_module, parameters, fitted_parameters, data, config)
  Base.include(Baseline, baseline_module)
  config = FIMSBackend.normalize_keys(config)
  initial, layout = FIMSBackend._flatten_init_params(parameters, config)
  fitted, _ = FIMSBackend._flatten_init_params(fitted_parameters, config)
  fixed = findall(Bool.(collect(config[:fixed_parameter_mask])))
  random = findall(Bool.(collect(config[:random_parameter_mask])))
  (length(fixed), length(random)) == (49, 29) || error("Expected the complete reference model.")
  joint = values -> FIMSBackend.evaluate_nll(
    FIMSBackend._named_component_array(values, layout), data, config,
  )
  problem[] = (
    parameters = parameters, fitted = fitted, data = data, config = config,
    fixed = fixed, random = random, joint = joint,
    options = FIMSBackend._optimizer_options(config),
  )
  nothing
end

function profile_start(directory, interval = 30)
  Main.FIMSBenchmarkProfiler.start(directory, interval)
  Baseline.FIMSBackend._optimizer_checkpoint_observer[] =
    FIMSBackend._optimizer_checkpoint_observer[]
  nothing
end

function profile_finish()
  Baseline.FIMSBackend._optimizer_checkpoint_observer[] = nothing
  Main.FIMSBenchmarkProfiler.finish()
end

function prepare_probe(progress)
  current = problem[]
  current.config[:diagnostic_file] = progress
  FIMSBackend._optimizer_checkpoint(progress, "probe_prepare:start")
  mode = FIMSBackend._conditional_mode(
    current.fitted, current.fixed, current.fitted[current.fixed], current.random,
    current.joint, current.options,
  )
  mode.converged || error("Reference conditional mode did not converge.")
  preconditioner = cholesky(Symmetric(mode.random_hessian))
  problem[] = merge(current, (mode = mode, preconditioner = preconditioner))
  FIMSBackend._optimizer_checkpoint(progress, "probe_prepare:complete")
  Dict("joint" => mode.joint_nll, "marginal" => mode.marginal_nll)
end

baseline_mode(current, values) = Baseline.FIMSBackend._conditional_mode(
  current.mode.parameters, current.fixed, values, current.random, current.joint, current.options,
)

candidate_mode(current, values) = FIMSBackend._conditional_mode(
  current.mode.parameters, current.fixed, values, current.random, current.joint, current.options;
  preconditioner = current.preconditioner,
)

function probe(backend, index, direction; compute_gradient = true)
  current = problem[]
  values = copy(current.mode.parameters[current.fixed])
  step = cbrt(eps(Float64)) * max(abs(values[index]), 1.0)
  values[index] += direction * step
  solve = backend == "baseline" ? baseline_mode :
    backend == "candidate" ? candidate_mode : error("Unknown backend.")
  path = current.config[:diagnostic_file]
  FIMSBackend._optimizer_checkpoint(path, "probe:$backend:$index:$direction:start")
  measured = @timed solve(current, values)
  measured.value.converged || error("Perturbed conditional mode did not converge.")
  differentiated = compute_gradient ? @timed(FIMSBackend._laplace_gradient(
    current.joint, measured.value.parameters, current.fixed, current.random;
    diagnostic_file = path, random_hessian = measured.value.random_hessian,
  )) : nothing
  FIMSBackend._optimizer_checkpoint(path, "probe:$backend:$index:$direction:complete")
  Dict(
    "backend" => backend, "index" => index, "direction" => direction,
    "seconds" => measured.time, "allocated_bytes" => Float64(measured.bytes),
    "gc_seconds" => measured.gctime, "iterations" => measured.value.iterations,
    "gradient" => compute_gradient ? differentiated.value : Float64[],
    "gradient_seconds" => compute_gradient ? differentiated.time : 0.0,
    "parameters" => measured.value.parameters,
    "joint" => measured.value.joint_nll, "marginal" => measured.value.marginal_nll,
  )
end

probe_modes(backend, index, direction) =
  probe(backend, index, direction; compute_gradient = false)

function full_fit(backend, progress)
  current = problem[]
  config = copy(current.config)
  config[:diagnostic_file] = progress
  fit = backend == "baseline" ? Baseline.FIMSBackend.fit_model :
    backend == "candidate" ? FIMSBackend.fit_model : error("Unknown backend.")
  measured = @timed fit(current.parameters, current.data, config)
  measured.value["convergence"] || error("Complete fit did not converge.")
  measured.value["pd_hessian"] || error("Complete fit uncertainty is not positive definite.")
  maximum(abs, measured.value["fixed_gradient"]) < 1e-3 ||
    error("Complete fit gradient exceeds the original threshold.")
  Dict(
    "backend" => backend, "seconds" => measured.time,
    "allocated_bytes" => Float64(measured.bytes), "gc_seconds" => measured.gctime,
    "fit" => measured.value,
  )
end

end
