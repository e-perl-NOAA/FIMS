using ComponentArrays: ComponentArray
using .Population: PopulationModel, step_population!
using .Recruitment: BevertonHolt, Ricker
using .Selectivity: DoubleLogisticSelectivity, LogisticSelectivity

function component_array_from_input(parameters_vector, model_config)
  if parameters_vector isa ComponentArray
    return parameters_vector
  end

  if parameters_vector isa NamedTuple
    return ComponentArray(parameters_vector)
  end

  if parameters_vector isa AbstractDict
    names_tuple = Tuple(Symbol.(collect(keys(parameters_vector))))
    values_tuple = Tuple(collect(values(parameters_vector)))
    return ComponentArray(NamedTuple{names_tuple}(values_tuple))
  end

  if parameters_vector isa AbstractVector
    parameter_names = Symbol.(get(model_config, :parameter_names, String[]))
    length(parameter_names) == length(parameters_vector) ||
      throw(ArgumentError("parameter_names must match parameters_vector length."))
    return ComponentArray(NamedTuple{Tuple(parameter_names)}(Tuple(parameters_vector)))
  end

  throw(ArgumentError("Unsupported parameter container for Julia FIMS backend."))
end

function build_selectivity(params, model_config)
  selectivity_type = get(model_config, :selectivity, :logistic)

  if selectivity_type == :double_logistic
    return DoubleLogisticSelectivity(
      params.inflection_point_asc,
      params.slope_asc,
      params.inflection_point_desc,
      params.slope_desc,
    )
  end

  LogisticSelectivity(params.inflection_point, params.slope)
end

function build_recruitment(params, model_config)
  recruitment_type = get(model_config, :recruitment, :beverton_holt)

  if recruitment_type == :ricker
    return Ricker(params.logit_steep, params.log_rzero)
  end

  BevertonHolt(params.logit_steep, params.log_rzero)
end

function build_population_model(params, data_dict)
  T = promote_type(
    eltype(data_dict[:ages]),
    eltype(data_dict[:weights_at_age]),
    eltype(data_dict[:maturity_at_age]),
  )
  numbers_at_age = Matrix{T}(undef, data_dict[:n_years], data_dict[:n_ages])
  numbers_at_age .= zero(T)
  numbers_at_age[1, :] .= exp.(Vector{T}(params.log_init_naa))

  PopulationModel(
    ages = Vector{T}(data_dict[:ages]),
    weights_at_age = Matrix{T}(data_dict[:weights_at_age]),
    maturity_at_age = Matrix{T}(data_dict[:maturity_at_age]),
    proportion_female = Vector{T}(get(data_dict, :proportion_female, ones(T, data_dict[:n_ages]))),
    numbers_at_age = numbers_at_age,
    biomass = zeros(T, data_dict[:n_years]),
    spawning_biomass = zeros(T, data_dict[:n_years]),
    expected_recruitment = zeros(T, data_dict[:n_years]),
    mortality_F = zeros(T, data_dict[:n_years], data_dict[:n_ages]),
    mortality_M = Matrix{T}(exp.(reshape(Vector{T}(params.log_M), data_dict[:n_years], data_dict[:n_ages]))),
    mortality_Z = zeros(T, data_dict[:n_years], data_dict[:n_ages]),
    catch_expected = zeros(T, data_dict[:n_years]),
    index_expected = zeros(T, data_dict[:n_years]),
  )
end

lognormal_nll(observed, expected, sigma) =
  sum(
    0.5 * log(2π) + log(sigma) + log(obs) +
      ((log(obs) - log(exp_val))^2) / (2 * sigma^2)
    for (obs, exp_val) in zip(observed, expected) if isfinite(obs) && obs > 0 && exp_val > 0
  )

function multinomial_nll(observed::AbstractMatrix, expected::AbstractMatrix)
  total = zero(promote_type(eltype(observed), eltype(expected)))

  for row in axes(observed, 1)
    obs_row = observed[row, :]
    if any(!isfinite, obs_row)
      continue
    end

    row_sum = sum(view(expected, row, :))
    if row_sum <= 0
      continue
    end

    probs = view(expected, row, :) ./ row_sum
    total -= sum(obs_row .* log.(max.(probs, eps(eltype(probs)))))
  end

  total
end

function evaluate_nll(parameters_vector, data_dict, model_config)
  params = component_array_from_input(parameters_vector, model_config)
  selectivity = build_selectivity(params, model_config)
  recruitment = build_recruitment(params, model_config)
  population = build_population_model(params, data_dict)

  fishing_mortality = reshape(exp.(Vector(params.log_Fmort)), data_dict[:n_years], data_dict[:n_ages])
  catchability = hasproperty(params, :log_q) ? exp(params.log_q) : one(eltype(population.ages))
  recruit_devs = hasproperty(params, :log_devs) ? Vector(params.log_devs) : zeros(eltype(population.ages), max(data_dict[:n_years] - 1, 0))

  step_population!(
    population,
    selectivity,
    recruitment,
    Dict(
      :fishing_mortality => fishing_mortality,
      :catchability => catchability,
      :phi_0 => get(data_dict, :phi_0, one(eltype(population.ages))),
      :log_recruit_devs => recruit_devs,
    ),
  )

  total_nll = zero(eltype(population.ages))

  if haskey(data_dict, :observed_catch)
    sigma_catch = get(model_config, :catch_sigma, eltype(population.ages)(0.1))
    total_nll += lognormal_nll(Vector(data_dict[:observed_catch]), population.catch_expected, sigma_catch)
  end

  if haskey(data_dict, :observed_index)
    sigma_index = get(model_config, :index_sigma, eltype(population.ages)(0.1))
    total_nll += lognormal_nll(Vector(data_dict[:observed_index]), population.index_expected, sigma_index)
  end

  if haskey(data_dict, :observed_age_comp)
    expected_age_comp = copy(population.numbers_at_age)
    for row in axes(expected_age_comp, 1)
      total_numbers = sum(view(expected_age_comp, row, :))
      if total_numbers > 0
        expected_age_comp[row, :] .= view(expected_age_comp, row, :) ./ total_numbers
      end
    end

    total_nll += multinomial_nll(
      Matrix(data_dict[:observed_age_comp]),
      expected_age_comp,
    )
  end

  if hasproperty(params, :log_devs)
    recruit_sd = get(model_config, :recruitment_deviation_sd, one(eltype(recruit_devs)))
    total_nll += sum(0.5 * log(2π) + log(recruit_sd) + (dev^2) / (2 * recruit_sd^2) for dev in params.log_devs)
  end

  total_nll
end
