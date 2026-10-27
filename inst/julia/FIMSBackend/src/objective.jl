using ComponentArrays: ComponentArray
using .Population: PopulationModel, spawning_biomass_per_recruit, step_population!
using .Recruitment: BevertonHolt, Ricker
using .Selectivity: DoubleLogisticSelectivity, LogisticSelectivity
using SpecialFunctions: erf, loggamma

normalize_keys(x) = x
normalize_keys(x::NamedTuple) = Dict(Symbol(key) => normalize_keys(value) for (key, value) in pairs(x))
normalize_key(key::Symbol) = key
normalize_key(key) = Symbol(key)
normalize_keys(x::AbstractDict) = Dict(normalize_key(key) => normalize_keys(value) for (key, value) in pairs(x))

has_component(params, name::Symbol) = name in propertynames(params)

get_component(params, name::Symbol, default) = has_component(params, name) ? params[name] : default

function component_array_from_input(parameters_vector, model_config)
  if parameters_vector isa ComponentArray
    return parameters_vector
  end

  if parameters_vector isa NamedTuple
    return ComponentArray(parameters_vector)
  end

  if parameters_vector isa AbstractDict
    normalized_parameters = normalize_keys(parameters_vector)
    configured_names = Symbol.(get(model_config, :parameter_names, String[]))
    parameter_keys =
      !isempty(configured_names) && all(haskey(normalized_parameters, key) for key in configured_names) ?
      configured_names : collect(keys(normalized_parameters))
    names_tuple = Tuple(parameter_keys)
    values_tuple = Tuple(normalized_parameters[key] for key in parameter_keys)
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

function build_selectivity(params, model_config, fleet_index)
  selectivity_types = get(model_config, :selectivity_types, String[])
  isempty(selectivity_types) || length(selectivity_types) >= fleet_index ||
    throw(ArgumentError("selectivity_types must provide one type for each fleet."))
  selectivity_type =
    isempty(selectivity_types) ? "Logistic" : string(selectivity_types[fleet_index])

  if selectivity_type == "DoubleLogistic"
    return DoubleLogisticSelectivity(
      params.inflection_point_asc[fleet_index],
      params.slope_asc[fleet_index],
      params.inflection_point_desc[fleet_index],
      params.slope_desc[fleet_index],
    )
  elseif selectivity_type == "Logistic"
    return LogisticSelectivity(params.inflection_point[fleet_index], params.slope[fleet_index])
  end

  throw(ArgumentError("Unsupported selectivity type: $selectivity_type"))
end

function build_recruitment(params, model_config)
  recruitment_type = get(model_config, :recruitment, :beverton_holt)

  if string(recruitment_type) in ("ricker", ":ricker")
    return Ricker(params.logit_steep, params.log_rzero)
  elseif string(recruitment_type) in ("beverton_holt", ":beverton_holt")
    return BevertonHolt(params.logit_steep, params.log_rzero)
  end

  throw(ArgumentError("Unsupported recruitment type: $recruitment_type"))
end

function growth_length_at_age(params, age)
  mean_length_young = exp(params.growth_log_mean_length_young)
  mean_length_old = exp(params.growth_log_mean_length_old)
  growth_coefficient = exp(params.growth_log_coefficient)
  reference_age_young = params.growth_reference_age_young
  reference_age_old = params.growth_reference_age_old
  if reference_age_young > 0 && age < reference_age_young
    return mean_length_young * max(age, zero(age)) / reference_age_young
  end
  denominator =
    one(growth_coefficient) -
    exp(-growth_coefficient * (reference_age_old - reference_age_young))
  safe_denominator = max(abs(denominator), oftype(denominator, 1e-8))
  numerator =
    one(growth_coefficient) -
    exp(-growth_coefficient * (age - reference_age_young))
  mean_length_young + (mean_length_old - mean_length_young) * numerator / safe_denominator
end

function build_growth_products(params, data_dict, model_config)
  growth_type = string(get(model_config, :growth_model_type, "EWAA"))
  if growth_type != "VonBertalanffySchnute"
    return (
      weights_at_age = Matrix(data_dict[:weights_at_age]),
      mean_length_at_age = nothing,
      sd_length_at_age = nothing,
      age_to_length_conversion = get(data_dict, :age_to_length_conversion, nothing),
    )
  end

  has_component(params, :growth_log_mean_length_young) ||
    throw(ArgumentError("VonBertalanffySchnute growth parameters are missing."))
  reference_age_young = params.growth_reference_age_young
  reference_age_old = params.growth_reference_age_old
  reference_age_old > reference_age_young ||
    throw(ArgumentError("Growth reference_age_for_length_old must exceed reference_age_for_length_young."))

  length_weight_a = exp(params.growth_log_length_weight_a)
  length_weight_b = exp(params.growth_log_length_weight_b)
  length_sd_young = exp(params.growth_log_length_sd_at_young)
  length_sd_old = exp(params.growth_log_length_sd_at_old)
  n_years = data_dict[:n_years]
  n_ages = data_dict[:n_ages]
  age_values = data_dict[:ages]
  mean_length = [growth_length_at_age(params, age) for age in age_values]
  reference_length_young = growth_length_at_age(params, reference_age_young)
  reference_length_old = growth_length_at_age(params, reference_age_old)
  length_delta = max(
    abs(reference_length_old - reference_length_young),
    oftype(reference_length_young, 1e-8),
  )
  length_sd_slope = (length_sd_old - length_sd_young) / length_delta
  sd_length = [
    max(
      length_sd_young + length_sd_slope * (length - reference_length_young),
      oftype(length, 1e-8),
    ) for length in mean_length
  ]
  weights_at_age = repeat(
    reshape(length_weight_a .* mean_length .^ length_weight_b, 1, n_ages),
    n_years,
    1,
  )
  age_to_length_conversion = nothing
  if data_dict[:n_lengths] > 0
    lengths = data_dict[:lengths]
    length_edges = [
      (lengths[index] + lengths[index + 1]) / 2 for index in 1:(length(lengths) - 1)
    ]
    age_to_length_conversion = zeros(
      promote_type(eltype(mean_length), eltype(sd_length)),
      n_ages,
      length(lengths),
    )
    for age_index in 1:n_ages
      sd = max(sd_length[age_index], oftype(sd_length[age_index], 1e-8))
      cdf(edge) =
        (one(sd) + erf((edge - mean_length[age_index]) / (sd * sqrt(oftype(sd, 2))))) / 2
      row = view(age_to_length_conversion, age_index, :)
      if length(lengths) == 1
        row[1] = one(sd)
      else
        row[1] = cdf(length_edges[1])
        for length_index in 2:(length(lengths) - 1)
          row[length_index] =
            cdf(length_edges[length_index]) - cdf(length_edges[length_index - 1])
        end
        row[end] = one(sd) - cdf(length_edges[end])
      end
      row .+= oftype(sd, 1e-12)
      row ./= sum(row)
    end
  end
  (
    weights_at_age = weights_at_age,
    mean_length_at_age = repeat(reshape(mean_length, 1, n_ages), n_years, 1),
    sd_length_at_age = repeat(reshape(sd_length, 1, n_ages), n_years, 1),
    age_to_length_conversion = age_to_length_conversion,
  )
end

function build_population_model(params, data_dict, weights_at_age)
  has_maturity_inflection = has_component(params, :maturity_inflection_point)
  has_maturity_slope = has_component(params, :maturity_slope)
  has_maturity_inflection == has_maturity_slope ||
    throw(ArgumentError("Maturity inflection point and slope must be provided together."))
  maturity_at_age = if has_maturity_inflection
    maturity_by_age = [
      one(params.maturity_slope) /
      (
        one(params.maturity_slope) +
        exp(-params.maturity_slope * (age - params.maturity_inflection_point))
      ) for age in data_dict[:ages]
    ]
    repeat(reshape(maturity_by_age, 1, :), data_dict[:n_years], 1)
  else
    Matrix(data_dict[:maturity_at_age])
  end
  T = promote_type(
    eltype(collect(params.log_init_naa)),
    eltype(data_dict[:ages]),
    eltype(weights_at_age),
    eltype(maturity_at_age),
    eltype(collect(params.log_Fmort)),
  )
  n_fleets = size(params.log_Fmort, 2)
  numbers_at_age = Matrix{T}(undef, data_dict[:n_years], data_dict[:n_ages])
  numbers_at_age .= zero(T)
  numbers_at_age[1, :] .= exp.(collect(params.log_init_naa))
  proportion_female = collect(get(data_dict, :proportion_female, ones(T, data_dict[:n_ages])))
  length(proportion_female) == data_dict[:n_ages] ||
    throw(ArgumentError("proportion_female must provide one value per age."))

  PopulationModel(
    ages = collect(data_dict[:ages]),
    weights_at_age = Matrix{T}(weights_at_age),
    maturity_at_age = Matrix{T}(maturity_at_age),
    proportion_female = T.(proportion_female),
    numbers_at_age = numbers_at_age,
    catch_numbers_at_age = zeros(T, data_dict[:n_years], data_dict[:n_ages]),
    biomass = zeros(T, data_dict[:n_years]),
    spawning_biomass = zeros(T, data_dict[:n_years]),
    expected_recruitment = zeros(T, data_dict[:n_years]),
    mortality_F = zeros(T, data_dict[:n_years], data_dict[:n_ages]),
    mortality_M = exp.(reshape(collect(params.log_M), data_dict[:n_years], data_dict[:n_ages])),
    mortality_Z = zeros(T, data_dict[:n_years], data_dict[:n_ages]),
    catch_expected = zeros(T, data_dict[:n_years]),
    index_expected = zeros(T, data_dict[:n_years]),
    catch_numbers_at_age_by_fleet = zeros(T, data_dict[:n_years], data_dict[:n_ages], n_fleets),
    index_numbers_at_age_by_fleet = zeros(T, data_dict[:n_years], data_dict[:n_ages], n_fleets),
    catch_expected_by_fleet = zeros(T, data_dict[:n_years], n_fleets),
    index_expected_by_fleet = zeros(T, data_dict[:n_years], n_fleets),
  )
end

sigma_element_type(sigma::Number) = typeof(sigma)
sigma_element_type(sigma) = eltype(sigma)
sigma_at(sigma::Number, index) = sigma
sigma_at(sigma, index) = sigma[index]

function validate_sigma(sigma)
  valid = sigma isa Number ?
    isfinite(sigma) && sigma > 0 :
    all(value -> isfinite(value) && value > 0, sigma)
  valid ||
    throw(ArgumentError("Observation uncertainty values must be finite and positive."))
end

function lognormal_nll(observed, expected, sigma)
  size(observed) == size(expected) ||
    throw(DimensionMismatch("Observed and expected data must have matching dimensions."))
  sigma isa Number || size(sigma) == size(observed) ||
    throw(DimensionMismatch("Observation uncertainty must be scalar or match the data dimensions."))
  validate_sigma(sigma)
  total = zero(promote_type(eltype(observed), eltype(expected), sigma_element_type(sigma)))
  for index in eachindex(observed, expected)
    obs = observed[index]
    exp_val = expected[index]
    sigma_value = sigma_at(sigma, index)
    if obs == -999
      continue
    elseif (isfinite(obs) && obs <= 0) || (isfinite(exp_val) && exp_val <= 0)
      total += oftype(total, Inf)
    else
      total +=
        0.5 * log(2π) + log(sigma_value) + log(obs) +
        ((log(obs) - log(exp_val))^2) / (2 * sigma_value^2)
    end
  end
  total
end

function normal_nll(observed, expected, sigma)
  size(observed) == size(expected) ||
    throw(DimensionMismatch("Observed and expected data must have matching dimensions."))
  sigma isa Number || size(sigma) == size(observed) ||
    throw(DimensionMismatch("Observation uncertainty must be scalar or match the data dimensions."))
  validate_sigma(sigma)
  total = zero(promote_type(eltype(observed), eltype(expected), sigma_element_type(sigma)))
  for index in eachindex(observed, expected)
    obs = observed[index]
    exp_val = expected[index]
    sigma_value = sigma_at(sigma, index)
    if isfinite(obs) && obs != -999 && isfinite(exp_val)
      total +=
        0.5 * log(2π) + log(sigma_value) + ((obs - exp_val)^2) / (2 * sigma_value^2)
    end
  end
  total
end

function lognormal_random_effect_nll(observed, expected, sigma)
  size(observed) == size(expected) ||
    throw(DimensionMismatch("Observed and expected recruitment values must have matching dimensions."))
  sigma isa Number || size(sigma) == size(observed) ||
    throw(DimensionMismatch("Recruitment uncertainty must be scalar or match the recruitment values."))
  validate_sigma(sigma)
  all(value -> isfinite(value) && value > 0, observed) ||
    throw(ArgumentError("Lognormal recruitment process values must be finite and positive."))
  normal_nll(log.(observed), expected, sigma)
end

function parameter_prior_nll(params, model_config)
  components = get(model_config, :parameter_prior_components, String[])
  indices = get(model_config, :parameter_prior_indices, Int[])
  distributions = get(model_config, :parameter_prior_distributions, String[])
  means = get(model_config, :parameter_prior_means, Float64[])
  standard_deviations = get(model_config, :parameter_prior_sds, Float64[])
  n_priors = length(components)
  all(length(values) == n_priors for values in (
    indices,
    distributions,
    means,
    standard_deviations,
  )) || throw(DimensionMismatch("Parameter prior fields must have matching lengths."))

  total = zero(eltype(collect(params)))
  for prior_index in 1:n_priors
    component_name = Symbol(components[prior_index])
    component = get_component(params, component_name, nothing)
    isnothing(component) &&
      throw(ArgumentError("Parameter prior refers to unknown component $(components[prior_index])."))
    component_values = component isa Number ? [component] : vec(component)
    component_index = indices[prior_index]
    1 <= component_index <= length(component_values) ||
      throw(BoundsError(component_values, component_index))
    value = component_values[component_index]
    mean = means[prior_index]
    standard_deviation = standard_deviations[prior_index]
    isfinite(standard_deviation) && standard_deviation > 0 ||
      throw(ArgumentError("Parameter prior standard deviations must be finite and positive."))

    distribution = lowercase(string(distributions[prior_index]))
    if distribution == "dnorm"
      total +=
        0.5 * log(2π) + log(standard_deviation) +
        ((value - mean)^2) / (2 * standard_deviation^2)
    elseif distribution == "dlnorm"
      if !isfinite(value) || value <= 0
        total += oftype(total, Inf)
      else
        total +=
          0.5 * log(2π) + log(standard_deviation) + log(value) +
          ((log(value) - mean)^2) / (2 * standard_deviation^2)
      end
    else
      throw(ArgumentError("Unsupported parameter prior distribution: $distribution"))
    end
  end
  total
end

function data_likelihood_nll(observed, expected, sigma, family)
  if family isa AbstractArray
    size(observed) == size(expected) ||
      throw(DimensionMismatch("Observed and expected data must have matching dimensions."))
    size(family) == size(observed) ||
      throw(DimensionMismatch("Likelihood families must match the data dimensions."))
    sigma isa Number || size(sigma) == size(observed) ||
      throw(DimensionMismatch("Observation uncertainty must be scalar or match the data dimensions."))
    total = zero(promote_type(eltype(observed), eltype(expected), sigma_element_type(sigma)))
    for index in eachindex(observed, expected, family)
      total += data_likelihood_nll(
        [observed[index]],
        [expected[index]],
        sigma_at(sigma, index),
        family[index],
      )
    end
    return total
  end

  normalized_family = lowercase(string(family))
  if normalized_family == "dnorm"
    return normal_nll(observed, expected, sigma)
  elseif normalized_family == "dlnorm"
    return lognormal_nll(observed, expected, sigma)
  end
  throw(ArgumentError("Unsupported data likelihood family: $family"))
end

function multinomial_nll(observed::AbstractMatrix, expected::AbstractMatrix)
  total = zero(promote_type(eltype(observed), eltype(expected)))
  probability_floor = oftype(total, sqrt(eps(Float64)))

  for row in axes(observed, 1)
    obs_row = observed[row, :]
    if any(x -> !isfinite(x) || x == -999, obs_row)
      continue
    end

    probs = view(expected, row, :)
    probability_sum = sum(probs)
    if probability_sum <= 0
      continue
    end

    normalized_probabilities = probs ./ probability_sum
    total -=
      loggamma(sum(obs_row) + 1) - sum(loggamma.(obs_row .+ 1)) +
      sum(obs_row .* log.(normalized_probabilities .+ probability_floor))
  end

  total
end

function expected_age_comp(population)
  expected = copy(population.catch_numbers_at_age)
  for row in axes(expected, 1)
    total_numbers = sum(view(expected, row, :))
    if total_numbers > 0
      expected[row, :] .= view(expected, row, :) ./ total_numbers
    end
  end
  expected
end

function evaluate_model(parameters_vector, data_dict, model_config)
  data_dict = normalize_keys(data_dict)
  params = component_array_from_input(parameters_vector, model_config)
  parameter_type = eltype(collect(params))
  n_fleets = length(data_dict[:fleets])
  fleet_selectivity = zeros(
    parameter_type,
    data_dict[:n_years],
    data_dict[:n_ages],
    n_fleets,
  )
  for fleet_index in 1:n_fleets
    selectivity = build_selectivity(params, model_config, fleet_index)
    for year in 1:data_dict[:n_years], age in 1:data_dict[:n_ages]
      fleet_selectivity[year, age, fleet_index] = selectivity(data_dict[:ages][age])
    end
  end
  recruitment = build_recruitment(params, model_config)
  growth_products = build_growth_products(params, data_dict, model_config)
  population = build_population_model(params, data_dict, growth_products.weights_at_age)

  fishing_mortality = Matrix(params.log_Fmort)
  catchability = exp.(collect(get_component(params, :log_q, zeros(parameter_type, n_fleets))))
  recruit_devs = get_component(
    params,
    :log_devs,
    zeros(parameter_type, max(data_dict[:n_years] - 1, 0))
  )
  log_recruitment = get_component(
    params,
    :log_r,
    zeros(parameter_type, max(data_dict[:n_years] - 1, 0))
  )
  recruitment_mode = string(get(model_config, :recruitment_process_mode, "log_devs"))
  phi_0 = get(data_dict, :phi_0, spawning_biomass_per_recruit(population))

  step_population!(
    population,
    nothing,
    recruitment,
    Dict(
      :fishing_mortality => fishing_mortality,
      :fleet_selectivity => fleet_selectivity,
      :catchability => catchability,
      :phi_0 => phi_0,
      :log_recruit_devs => recruit_devs,
      :log_recruitment => log_recruitment,
      :recruitment_mode => recruitment_mode,
    ),
  )

  total_nll = zero(parameter_type)

  if haskey(data_dict, :observed_catch) && !isempty(data_dict[:observed_catch])
    sigma_catch = get(model_config, :catch_sigma, parameter_type(0.1))
    catch_family = get(model_config, :catch_distribution, "dlnorm")
    total_nll += data_likelihood_nll(
      data_dict[:observed_catch],
      population.catch_expected_by_fleet,
      sigma_catch,
      catch_family,
    )
  end

  if haskey(data_dict, :observed_index) && !isempty(data_dict[:observed_index])
    sigma_index = get(model_config, :index_sigma, parameter_type(0.1))
    index_family = get(model_config, :index_distribution, "dlnorm")
    total_nll += data_likelihood_nll(
      data_dict[:observed_index],
      population.index_expected_by_fleet,
      sigma_index,
      index_family,
    )
  end

  age_comp_expected = zeros(parameter_type, data_dict[:n_years], data_dict[:n_ages], n_fleets)
  length_comp_expected = zeros(parameter_type, data_dict[:n_years], data_dict[:n_lengths], n_fleets)
  fleet_has_catch = get(data_dict, :fleet_has_catch, trues(n_fleets))
  for fleet_index in 1:n_fleets
    numbers_at_age = fleet_has_catch[fleet_index] ?
      view(population.catch_numbers_at_age_by_fleet, :, :, fleet_index) :
      view(population.index_numbers_at_age_by_fleet, :, :, fleet_index)
    for year in 1:data_dict[:n_years]
      total_numbers = sum(view(numbers_at_age, year, :))
      if total_numbers > 0
        age_comp_expected[year, :, fleet_index] .= numbers_at_age[year, :] ./ total_numbers
      end
      if !isnothing(growth_products.age_to_length_conversion)
        length_numbers =
          transpose(growth_products.age_to_length_conversion) * numbers_at_age[year, :]
        total_length_numbers = sum(length_numbers)
        if total_length_numbers > 0
          length_comp_expected[year, :, fleet_index] .= length_numbers ./ total_length_numbers
        end
      end
    end
  end

  if haskey(data_dict, :observed_age_comp) && !isempty(data_dict[:observed_age_comp])
    for fleet_index in 1:n_fleets
      total_nll += multinomial_nll(
        Matrix(data_dict[:observed_age_comp][:, :, fleet_index]),
        Matrix(age_comp_expected[:, :, fleet_index]),
      )
    end
  end

  if haskey(data_dict, :observed_length_comp) && !isempty(data_dict[:observed_length_comp])
    for fleet_index in 1:n_fleets
      total_nll += multinomial_nll(
        Matrix(data_dict[:observed_length_comp][:, :, fleet_index]),
        Matrix(length_comp_expected[:, :, fleet_index]),
      )
    end
  end

  catch_numbers_at_age_by_fleet = population.catch_numbers_at_age_by_fleet
  index_numbers_at_age_by_fleet = population.index_numbers_at_age_by_fleet
  catch_weight_at_age_by_fleet =
    catch_numbers_at_age_by_fleet .* reshape(data_dict[:weights_at_age], data_dict[:n_years], data_dict[:n_ages], 1)
  index_weight_at_age_by_fleet =
    index_numbers_at_age_by_fleet .* reshape(data_dict[:weights_at_age], data_dict[:n_years], data_dict[:n_ages], 1)
  catch_numbers_by_fleet = dropdims(sum(catch_numbers_at_age_by_fleet, dims = 2), dims = 2)
  index_numbers_by_fleet = dropdims(sum(index_numbers_at_age_by_fleet, dims = 2), dims = 2)

  has_recruitment_process_values =
    recruitment_mode == "log_r" ? has_component(params, :log_r) : has_component(params, :log_devs)
  if get(model_config, :recruitment_process_active, false) && has_recruitment_process_values
    process_family = lowercase(string(get(model_config, :recruitment_process_distribution, "dnorm")))
    process_family in ("dnorm", "dlnorm") ||
      throw(ArgumentError("Unsupported recruitment process distribution: $process_family"))
    process_nll = process_family == "dlnorm" ? lognormal_random_effect_nll : normal_nll
    recruit_sd =
      has_component(params, :log_sd) ?
      exp.(params.log_sd) :
      get(model_config, :recruitment_deviation_sd, one(eltype(recruit_devs)))
    if recruitment_mode == "log_r"
      expected_log_recruitment = [
        log(recruitment(population.spawning_biomass[year], phi_0)) for
        year in 1:(data_dict[:n_years] - 1)
      ]
      total_nll += process_nll(params.log_r, expected_log_recruitment, recruit_sd)
    else
      total_nll += process_nll(
        params.log_devs,
        zeros(parameter_type, length(params.log_devs)),
        recruit_sd,
      )
    end
  end

  prior_nll_value = parameter_prior_nll(params, model_config)
  total_nll += prior_nll_value

  Dict(
    "nll" => total_nll,
    "report" => Dict(
      "parameter_prior_nll" => prior_nll_value,
      "numbers_at_age" => population.numbers_at_age,
      "catch_numbers_at_age" => population.catch_numbers_at_age,
      "biomass" => population.biomass,
      "spawning_biomass" => population.spawning_biomass,
      "expected_recruitment" => population.expected_recruitment,
      "mortality_F" => population.mortality_F,
      "mortality_M" => population.mortality_M,
      "mortality_Z" => population.mortality_Z,
      "proportion_mature_at_age" => population.maturity_at_age,
      "weights_at_age" => population.weights_at_age,
      "mean_length_at_age" => growth_products.mean_length_at_age,
      "sd_length_at_age" => growth_products.sd_length_at_age,
      "age_to_length_conversion" => growth_products.age_to_length_conversion,
      "sum_selectivity" => dropdims(sum(fleet_selectivity, dims = 3), dims = 3),
      "catch_expected" => population.catch_expected,
      "index_expected" => population.index_expected,
      "total_catch_numbers" => vec(sum(catch_numbers_by_fleet, dims = 2)),
      "total_catch_weight" => population.catch_expected,
      "catch_expected_by_fleet" => population.catch_expected_by_fleet,
      "index_expected_by_fleet" => population.index_expected_by_fleet,
      "catch_numbers_by_fleet" => catch_numbers_by_fleet,
      "index_numbers_by_fleet" => index_numbers_by_fleet,
      "catch_weight_at_age_by_fleet" => catch_weight_at_age_by_fleet,
      "index_weight_at_age_by_fleet" => index_weight_at_age_by_fleet,
      "catch_numbers_at_age_by_fleet" => catch_numbers_at_age_by_fleet,
      "index_numbers_at_age_by_fleet" => index_numbers_at_age_by_fleet,
      "agecomp_expected" => age_comp_expected,
      "lengthcomp_expected" => length_comp_expected,
      "jnll" => total_nll,
    ),
  )
end

function evaluate_nll(parameters_vector, data_dict, model_config)
  evaluate_model(parameters_vector, data_dict, model_config)["nll"]
end
