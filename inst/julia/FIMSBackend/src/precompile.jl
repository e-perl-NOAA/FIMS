using PrecompileTools: @compile_workload, @setup_workload

function _precompile_model_input(n_years, n_ages)
  n_fleets = 2
  n_lengths = 3
  parameters = ComponentArray((
    inflection_point = fill(2.0, n_fleets),
    slope = ones(n_fleets),
    inflection_point_asc = fill(2.0, n_fleets),
    slope_asc = ones(n_fleets),
    inflection_point_desc = fill(4.0, n_fleets),
    slope_desc = ones(n_fleets),
    log_rzero = log(1000.0),
    logit_steep = 0.0,
    log_devs = zeros(n_years - 1),
    log_r = zeros(n_years - 1),
    log_sd = log(0.01),
    log_init_naa = log.(1000.0 .* exp.(-0.2 .* (0:(n_ages - 1)))),
    log_M = fill(log(0.2), n_years, n_ages),
    proportion_female = 0.5,
    log_Fmort = fill(log(0.1), n_years, n_fleets),
    log_q = zeros(n_fleets),
    maturity_inflection_point = 2.0,
    maturity_slope = 1.0,
  ))
  data = Dict{Symbol, Any}(
    :fleets => ["fish", "survey"], :n_years => n_years,
    :n_ages => n_ages, :ages => collect(1:n_ages),
    :n_lengths => n_lengths, :lengths => [10.0, 20.0, 30.0],
    :fleet_has_catch => BitVector([true, false]), :fleet_has_index => BitVector([false, true]),
    :fleet_has_age_comp => trues(n_fleets), :fleet_has_length_comp => trues(n_fleets),
    :start_year => 1, :end_year => n_years,
    :weights_at_age => repeat(reshape(collect(1.0:n_ages), 1, :), n_years, 1),
    :maturity_at_age => fill(0.5, n_years, n_ages),
    :proportion_female => fill(0.5, n_ages),
    :observed_catch => fill(100.0, n_years, n_fleets),
    :observed_index => fill(1000.0, n_years, n_fleets),
    :observed_age_comp => fill(1.0, n_years, n_ages, n_fleets),
    :observed_length_comp => fill(1.0, n_years, n_lengths, n_fleets),
    :age_to_length_conversion => fill(1 / n_lengths, n_ages, n_lengths),
  )
  config = Dict{Symbol, Any}(
    :fleet_names => ["fish", "survey"],
    :selectivity_types => ["Logistic", "Logistic"],
    :recruitment => "beverton_holt", :growth_model_type => "EWAA",
    :recruitment_process_active => true, :recruitment_process_mode => "log_devs",
    :recruitment_process_distribution => "dnorm",
    :catch_distribution => "dlnorm", :catch_sigma => fill(0.1, n_years, n_fleets),
    :index_distribution => "dlnorm", :index_sigma => fill(0.1, n_years, n_fleets),
    :selectivity_parameter_offsets => ones(Int, n_fleets),
    :selectivity_parameter_lengths => zeros(Int, n_fleets),
    :recruitment_deviation_sd => 1.0, :recruitment_has_random_devs => true,
    :parameter_names => String.(collect(propertynames(parameters))),
    :parameter_prior_components => String[], :parameter_prior_indices => Int[],
    :parameter_prior_distributions => String[], :parameter_prior_means => Float64[],
    :parameter_prior_sds => Float64[], :parameter_prior_transforms => String[],
  )
  parameters, data, config
end

@setup_workload begin
  # Train derivative chunk widths, not a particular assessment's data or dimensions.
  parameters, data, config = _precompile_model_input(17, 4)
  initial = collect(parameters)
  indices = ComponentArray(collect(eachindex(initial)), getaxes(parameters))
  random_indices = collect(indices.log_devs)
  fixed_indices = setdiff(collect(eachindex(initial)), random_indices)
  joint = _prepared_joint_objective(parameters, data, config)
  options = _optimizer_options(Dict(:optimizer_max_iterations => 100))
  small_parameters, small_data, small_config = _precompile_model_input(3, 3)
  small_indices = ComponentArray(collect(eachindex(small_parameters)), getaxes(small_parameters))
  small_config[:fixed_parameter_mask] = falses(length(small_parameters))
  small_config[:fixed_parameter_mask][small_indices.log_q] .= true
  small_config[:random_parameter_mask] = falses(length(small_parameters))
  small_config[:random_parameter_mask][first(small_indices.log_devs)] = true
  small_config[:optimizer_max_iterations] = 100
  small_config[:optimizer_max_evaluations] = 1000
  small_config[:diagnostic_file] = tempname()
  @compile_workload begin
    for width in 1:min(ForwardDiff.DEFAULT_CHUNK_THRESHOLD, 16)
      random = random_indices[1:width]
      mode = _conditional_mode(
        initial, fixed_indices[1:2], initial[fixed_indices[1:2]],
        random, joint, options,
      )
      _conditional_mode(
        mode.parameters, fixed_indices[1:2], initial[fixed_indices[1:2]],
        random, joint, options; preconditioner = cholesky(Symmetric(mode.random_hessian)),
      )
      active = _active_joint_objective(initial, fixed_indices[1:width], joint)
      hessian(active, initial[fixed_indices[1:width]])
    end
    random = random_indices[1:4]
    mode = _conditional_mode(
      initial, fixed_indices[1:2], initial[fixed_indices[1:2]], random, joint, options,
    )
    for width in 1:16
      _laplace_gradient(
        joint, mode.parameters, fixed_indices[1:width], random;
        random_hessian = mode.random_hessian,
      )
    end
    _report_standard_errors(
      initial, parameters, data, config, Matrix{Float64}(I, length(initial), length(initial)),
      fixed_indices[1:min(ForwardDiff.DEFAULT_CHUNK_THRESHOLD, 16)],
    )
    fit_model(small_parameters, small_data, small_config)
  end
  rm(small_config[:diagnostic_file])
end
