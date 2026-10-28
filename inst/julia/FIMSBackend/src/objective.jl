using ComponentArrays: ComponentArray
using .Population: PopulationModel, spawning_biomass_per_recruit, step_population!
using .Recruitment: BevertonHolt, Ricker
using .Selectivity: DoubleLogisticSelectivity, LogisticSelectivity
using SpecialFunctions: erf, loggamma

struct AgeSpecificSelectivity{T <: Real, A <: Real}
  logit_sel_at_age::Vector{T}
  ages::Vector{A}
  n_years::Int
  function AgeSpecificSelectivity(
    logit_sel_at_age::AbstractVector{T},
    ages::AbstractVector{A},
    n_years::Integer,
  ) where {T <: Real, A <: Real}
    n_years > 0 ||
      throw(ArgumentError("Age-specific selectivity requires at least one modeled year."))
    n_values = length(logit_sel_at_age)
    n_ages = length(ages)
    n_values in (1, n_ages, n_ages * n_years) ||
      throw(ArgumentError("Age-specific selectivity parameters must contain one value, one value per age, or one value per age and year."))
    new{T, A}(collect(logit_sel_at_age), collect(ages), Int(n_years))
  end
end

AgeSpecificSelectivity(logit_sel_at_age::AbstractVector, ages::AbstractVector) =
  AgeSpecificSelectivity(logit_sel_at_age, ages, 1)

function (selectivity::AgeSpecificSelectivity)(age::Real, year::Integer = 1)
  age_index = findfirst(==(age), selectivity.ages)
  isnothing(age_index) &&
    throw(ArgumentError("Age-specific selectivity received an age outside the modeled range."))
  n_values = length(selectivity.logit_sel_at_age)
  parameter_index = if n_values == 1
    1
  elseif n_values == length(selectivity.ages)
    age_index
  else
    1 <= year <= selectivity.n_years ||
      throw(ArgumentError("Age-specific selectivity received a year outside the modeled range."))
    (year - 1) * length(selectivity.ages) + age_index
  end
  logit_value = selectivity.logit_sel_at_age[parameter_index]
  one(logit_value) / (one(logit_value) + exp(-logit_value))
end

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

function build_selectivity(params, model_config, fleet_index, ages, n_years = 1)
  selectivity_types = get(model_config, :selectivity_types, String[])
  isempty(selectivity_types) || length(selectivity_types) >= fleet_index ||
    throw(ArgumentError("selectivity_types must provide one type for each fleet."))
  selectivity_type =
    isempty(selectivity_types) ? "Logistic" : string(selectivity_types[fleet_index])

  if selectivity_type == "AgeSpecific"
    has_component(params, :logit_sel_at_age) ||
      throw(ArgumentError("AgeSpecific selectivity parameters are missing."))
    selectivity_parameters = if params.logit_sel_at_age isa AbstractMatrix
      size(params.logit_sel_at_age) == (length(ages), length(selectivity_types)) ||
        throw(ArgumentError("AgeSpecific selectivity parameters must match the age and fleet dimensions."))
      collect(params.logit_sel_at_age[:, fleet_index])
    else
      parameter_lengths = get(model_config, :selectivity_parameter_lengths, Int[])
      parameter_offsets = get(model_config, :selectivity_parameter_offsets, Int[])
      length(parameter_lengths) >= fleet_index && length(parameter_offsets) >= fleet_index ||
        throw(ArgumentError("AgeSpecific selectivity parameter offsets and lengths must provide one entry per fleet."))
      parameter_length = parameter_lengths[fleet_index]
      parameter_offset = parameter_offsets[fleet_index]
      parameter_length > 0 ||
        throw(ArgumentError("AgeSpecific selectivity parameters are missing for this fleet."))
      parameter_offset >= 1 &&
        parameter_offset + parameter_length - 1 <= length(params.logit_sel_at_age) ||
        throw(ArgumentError("AgeSpecific selectivity parameter bounds are outside the parameter vector."))
      collect(params.logit_sel_at_age[parameter_offset:(parameter_offset + parameter_length - 1)])
    end
    return AgeSpecificSelectivity(selectivity_parameters, collect(ages), n_years)
  elseif selectivity_type == "DoubleLogistic"
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

function growth_delta_covariance(params)
  component_names = (
    :growth_log_sd_mean_length_young,
    :growth_log_sd_mean_length_old,
    :growth_log_sd_growth_coefficient,
    :growth_mean_length_young_mean_length_old_logit_corr,
    :growth_mean_length_young_growth_coefficient_logit_corr,
    :growth_mean_length_old_growth_coefficient_logit_corr,
  )
  all(has_component(params, name) for name in component_names) ||
    throw(ArgumentError("All six VonBertalanffySchnute delta-method parameters are required."))

  sd_young = exp(params.growth_log_sd_mean_length_young)
  sd_old = exp(params.growth_log_sd_mean_length_old)
  sd_coefficient = exp(params.growth_log_sd_growth_coefficient)
  correlation(value) = 2 / (one(value) + exp(-value)) - one(value)
  covariance_young_old =
    correlation(params.growth_mean_length_young_mean_length_old_logit_corr) *
    sd_young * sd_old
  covariance_young_coefficient =
    correlation(params.growth_mean_length_young_growth_coefficient_logit_corr) *
    sd_young * sd_coefficient
  covariance_old_coefficient =
    correlation(params.growth_mean_length_old_growth_coefficient_logit_corr) *
    sd_old * sd_coefficient
  variance_young = sd_young^2
  variance_old = sd_old^2
  variance_coefficient = sd_coefficient^2

  covariance_young_old^2 <= variance_young * variance_old ||
    throw(ArgumentError("Growth covariance between mean_length_young and mean_length_old is inconsistent with the supplied variances."))
  covariance_young_coefficient^2 <= variance_young * variance_coefficient ||
    throw(ArgumentError("Growth covariance between mean_length_young and growth_coefficient is inconsistent with the supplied variances."))
  covariance_old_coefficient^2 <= variance_old * variance_coefficient ||
    throw(ArgumentError("Growth covariance between mean_length_old and growth_coefficient is inconsistent with the supplied variances."))

  determinant =
    variance_young *
    (variance_old * variance_coefficient - covariance_old_coefficient^2) -
    covariance_young_old *
    (covariance_young_old * variance_coefficient -
     covariance_young_coefficient * covariance_old_coefficient) +
    covariance_young_coefficient *
    (covariance_young_old * covariance_old_coefficient -
     covariance_young_coefficient * variance_old)
  determinant >= zero(determinant) ||
    throw(ArgumentError("Growth parameter covariance matrix must be positive semi-definite."))

  (
    variance_young = variance_young,
    covariance_young_old = covariance_young_old,
    covariance_young_coefficient = covariance_young_coefficient,
    variance_old = variance_old,
    covariance_old_coefficient = covariance_old_coefficient,
    variance_coefficient = variance_coefficient,
  )
end

function growth_log_length_gradient(params, age)
  mean_length_young = exp(params.growth_log_mean_length_young)
  mean_length_old = exp(params.growth_log_mean_length_old)
  growth_coefficient = exp(params.growth_log_coefficient)
  reference_age_young = params.growth_reference_age_young
  reference_age_old = params.growth_reference_age_old
  mean_length = growth_length_at_age(params, age)
  safe_mean_length = max(mean_length, oftype(mean_length, 1e-8))

  if reference_age_young > 0 && age < reference_age_young
    ratio = max(age, zero(age)) / reference_age_young
    return (
      d_log_length_d_log_young = ratio * mean_length_young / safe_mean_length,
      d_log_length_d_log_old = zero(safe_mean_length),
      d_log_length_d_log_coefficient = zero(safe_mean_length),
    )
  end

  age_delta_young = age - reference_age_young
  age_delta_old = reference_age_old - reference_age_young
  exp_numerator = exp(-growth_coefficient * age_delta_young)
  exp_denominator = exp(-growth_coefficient * age_delta_old)
  numerator = one(exp_numerator) - exp_numerator
  denominator = one(exp_denominator) - exp_denominator
  safe_denominator = max(abs(denominator), oftype(denominator, 1e-8))
  ratio = numerator / safe_denominator
  d_length_d_young = one(ratio) - ratio
  d_length_d_old = ratio
  d_numerator_d_coefficient = age_delta_young * exp_numerator
  d_denominator_d_coefficient = age_delta_old * exp_denominator
  d_ratio_d_coefficient =
    (d_numerator_d_coefficient * safe_denominator -
     numerator * d_denominator_d_coefficient) / safe_denominator^2
  d_length_d_coefficient =
    (mean_length_old - mean_length_young) * d_ratio_d_coefficient

  (
    d_log_length_d_log_young =
      d_length_d_young * mean_length_young / safe_mean_length,
    d_log_length_d_log_old = d_length_d_old * mean_length_old / safe_mean_length,
    d_log_length_d_log_coefficient =
      d_length_d_coefficient * growth_coefficient / safe_mean_length,
  )
end

function growth_log_length_variance(params, age, covariance)
  gradient = growth_log_length_gradient(params, age)
  gradient.d_log_length_d_log_young^2 * covariance.variance_young +
  2 * gradient.d_log_length_d_log_young * gradient.d_log_length_d_log_old *
  covariance.covariance_young_old +
  2 * gradient.d_log_length_d_log_young * gradient.d_log_length_d_log_coefficient *
  covariance.covariance_young_coefficient +
  gradient.d_log_length_d_log_old^2 * covariance.variance_old +
  2 * gradient.d_log_length_d_log_old * gradient.d_log_length_d_log_coefficient *
  covariance.covariance_old_coefficient +
  gradient.d_log_length_d_log_coefficient^2 * covariance.variance_coefficient
end

function growth_observation_edges(lengths)
  length(lengths) >= 2 ||
    throw(ArgumentError("Growth-derived length conversion requires at least two length-bin centers."))
  all(diff(lengths) .> 0) ||
    throw(ArgumentError("Growth-derived length-bin centers must be strictly increasing."))

  edges = Vector{eltype(lengths)}(undef, length(lengths) + 1)
  edges[1] = lengths[1] - (lengths[2] - lengths[1]) / 2
  for index in 1:(length(lengths) - 1)
    edges[index + 1] = (lengths[index] + lengths[index + 1]) / 2
  end
  edges[end] = lengths[end] + (lengths[end] - lengths[end - 1]) / 2
  edges
end

function growth_population_size_edges(length_edges)
  lower_edge = first(length_edges)
  upper_edge = last(length_edges)
  regular_upper_edge = lower_edge
  span = upper_edge - lower_edge
  tolerance = 1e-12 * max(span, one(span))
  regular_bin_count = 0
  while regular_upper_edge < upper_edge - tolerance
    regular_bin_count += 1
    regular_upper_edge = lower_edge + regular_bin_count * one(lower_edge)
  end
  edges = [lower_edge + index * one(lower_edge) for index in 0:regular_bin_count]
  push!(edges, regular_upper_edge + one(lower_edge))
  edges
end

function growth_size_bin_probabilities(mean_length, sd_length, size_edges)
  n_bins = length(size_edges) - 1
  n_bins > 0 ||
    throw(ArgumentError("Growth-derived size grid must contain at least one bin."))
  n_bins == 1 && return [one(mean_length)]

  cdf(edge) =
    (one(mean_length) + erf((edge - mean_length) / (sd_length * sqrt(oftype(sd_length, 2))))) / 2
  probabilities = Vector{typeof(mean_length + sd_length)}(undef, n_bins)
  probabilities[1] = cdf(size_edges[2])
  for index in 2:(n_bins - 1)
    probabilities[index] = cdf(size_edges[index + 1]) - cdf(size_edges[index])
  end
  probabilities[end] = cdf(2 * mean_length - size_edges[end - 1])
  probabilities .+= oftype(mean_length, 1e-12)
  probabilities ./ sum(probabilities)
end

function growth_rebin_weights(source_edges, destination_edges)
  expanded_edges = copy(destination_edges)
  expanded_edges[1] = min(first(expanded_edges), first(source_edges))
  expanded_edges[end] = max(last(expanded_edges), last(source_edges))
  weights = zeros(Float64, length(expanded_edges) - 1, length(source_edges) - 1)
  for destination_index in 1:(length(expanded_edges) - 1)
    for source_index in 1:(length(source_edges) - 1)
      overlap = max(
        0.0,
        min(expanded_edges[destination_index + 1], source_edges[source_index + 1]) -
        max(expanded_edges[destination_index], source_edges[source_index]),
      )
      weights[destination_index, source_index] =
        overlap / (source_edges[source_index + 1] - source_edges[source_index])
    end
  end
  weights
end

function build_growth_products(params, data_dict, model_config)
  growth_type = string(get(model_config, :growth_model_type, "EWAA"))
  if growth_type != "VonBertalanffySchnute"
    return (
      weights_at_age = Matrix(data_dict[:weights_at_age]),
      mean_length_at_age = nothing,
      sd_length_at_age = nothing,
      age_to_length_conversion = get(data_dict, :age_to_length_conversion, nothing),
      growth_derived_mean_WAA = nothing,
      age_to_length_conversion_derived_used = falses(length(data_dict[:fleets])),
    )
  end

  has_component(params, :growth_log_mean_length_young) ||
    throw(ArgumentError("VonBertalanffySchnute growth parameters are missing."))
  interpolation_components = (
    :growth_log_length_sd_at_young,
    :growth_log_length_sd_at_old,
  )
  delta_components = (
    :growth_log_sd_mean_length_young,
    :growth_log_sd_mean_length_old,
    :growth_log_sd_growth_coefficient,
    :growth_mean_length_young_mean_length_old_logit_corr,
    :growth_mean_length_young_growth_coefficient_logit_corr,
    :growth_mean_length_old_growth_coefficient_logit_corr,
  )
  has_interpolation_sd = all(has_component(params, name) for name in interpolation_components)
  has_any_delta_component = any(has_component(params, name) for name in delta_components)
  has_delta_method = all(has_component(params, name) for name in delta_components)
  has_any_delta_component == has_delta_method ||
    throw(ArgumentError("All six VonBertalanffySchnute delta-method parameters are required."))
  has_interpolation_sd != has_delta_method ||
    throw(ArgumentError("Provide either reference-age SD values or all delta-method parameters for VonBertalanffySchnute growth, but not both."))
  covariance = has_delta_method ? growth_delta_covariance(params) : nothing
  reference_age_young = params.growth_reference_age_young
  reference_age_old = params.growth_reference_age_old
  reference_age_old > reference_age_young ||
    throw(ArgumentError("Growth reference_age_for_length_old must exceed reference_age_for_length_young."))

  length_weight_a = exp(params.growth_log_length_weight_a)
  length_weight_b = exp(params.growth_log_length_weight_b)
  length_sd_young = has_interpolation_sd ? exp(params.growth_log_length_sd_at_young) : nothing
  length_sd_old = has_interpolation_sd ? exp(params.growth_log_length_sd_at_old) : nothing
  n_years = data_dict[:n_years]
  n_ages = data_dict[:n_ages]
  age_values = data_dict[:ages]
  mean_length = [growth_length_at_age(params, age) for age in age_values]
  reference_length_young = growth_length_at_age(params, reference_age_young)
  reference_length_old = growth_length_at_age(params, reference_age_old)
  sd_length = if has_delta_method
    [
      max(
        length * sqrt(max(growth_log_length_variance(params, age, covariance), zero(length))),
        oftype(length, 1e-8),
      ) for (age, length) in zip(age_values, mean_length)
    ]
  else
    length_delta = max(
      abs(reference_length_old - reference_length_young),
      oftype(reference_length_young, 1e-8),
    )
    length_sd_slope = (length_sd_old - length_sd_young) / length_delta
    [
      max(
        length_sd_young + length_sd_slope * (length - reference_length_young),
        oftype(length, 1e-8),
      ) for length in mean_length
    ]
  end
  weights_at_age = repeat(
    reshape(length_weight_a .* mean_length .^ length_weight_b, 1, n_ages),
    n_years,
    1,
  )
  age_to_length_conversion = nothing
  if data_dict[:n_lengths] > 0
    lengths = data_dict[:lengths]
    has_fleet_lengths = haskey(data_dict, :lengths_by_fleet)
    has_fleet_length_counts = haskey(data_dict, :n_lengths_by_fleet)
    has_fleet_lengths == has_fleet_length_counts ||
      throw(ArgumentError("Fleet-specific length bins and their counts must be provided together."))
    has_fleet_length_bins = has_fleet_lengths && has_fleet_length_counts
    if has_fleet_length_bins
      fleet_lengths = Matrix(data_dict[:lengths_by_fleet])
      fleet_length_counts = Int.(data_dict[:n_lengths_by_fleet])
      n_fleets = length(data_dict[:fleets])
      size(fleet_lengths) == (length(lengths), n_fleets) ||
        throw(ArgumentError("Fleet-specific length bins must match the global length and fleet dimensions."))
      length(fleet_length_counts) == n_fleets ||
        throw(ArgumentError("Fleet-specific length-bin counts must match the number of fleets."))
      all((fleet_length_counts .>= 0) .& (fleet_length_counts .<= length(lengths))) ||
        throw(ArgumentError("Fleet-specific length-bin counts are outside the global length-bin range."))
      for fleet_index in 1:n_fleets
        n_fleet_lengths = fleet_length_counts[fleet_index]
        n_fleet_lengths == 0 && continue
        fleet_bins = fleet_lengths[1:n_fleet_lengths, fleet_index]
        all(isfinite, fleet_bins) && issorted(fleet_bins) && allunique(fleet_bins) ||
          throw(ArgumentError("Each fleet's length bins must be finite, sorted, and unique."))
        all(bin -> bin in lengths, fleet_bins) ||
          throw(ArgumentError("Fleet-specific length bins must be present in the global length-bin vector."))
      end
      shared_length_bins = all(1:n_fleets) do fleet_index
        n_fleet_lengths = fleet_length_counts[fleet_index]
        n_fleet_lengths == length(lengths) &&
          fleet_lengths[1:n_fleet_lengths, fleet_index] == lengths
      end
    else
      shared_length_bins = true
    end

    if shared_length_bins
      observation_edges = growth_observation_edges(lengths)
      size_edges = growth_population_size_edges(observation_edges)
      rebin_weights = growth_rebin_weights(size_edges, observation_edges)
      age_to_length_conversion = zeros(
        promote_type(eltype(mean_length), eltype(sd_length)),
        n_ages,
        length(lengths),
      )
      for age_index in 1:n_ages
        sd = max(sd_length[age_index], oftype(sd_length[age_index], 1e-8))
        population_probabilities = growth_size_bin_probabilities(
          mean_length[age_index],
          sd,
          size_edges,
        )
        row = rebin_weights * population_probabilities
        row .+= oftype(sd, 1e-12)
        row ./= sum(row)
        age_to_length_conversion[age_index, :] .= row
      end
    else
      age_to_length_conversion = zeros(
        promote_type(eltype(mean_length), eltype(sd_length)),
        n_ages,
        length(lengths),
        length(data_dict[:fleets]),
      )
      for fleet_index in eachindex(data_dict[:fleets])
        n_fleet_lengths = fleet_length_counts[fleet_index]
        n_fleet_lengths == 0 && continue
        fleet_bins = fleet_lengths[1:n_fleet_lengths, fleet_index]
        global_indices = Int[]
        for bin in fleet_bins
          global_index = findfirst(==(bin), lengths)
          isnothing(global_index) &&
            throw(ArgumentError("Fleet-specific length bins must be present in the global length-bin vector."))
          push!(global_indices, global_index)
        end
        observation_edges = growth_observation_edges(fleet_bins)
        size_edges = growth_population_size_edges(observation_edges)
        rebin_weights = growth_rebin_weights(size_edges, observation_edges)
        for age_index in 1:n_ages
          sd = max(sd_length[age_index], oftype(sd_length[age_index], 1e-8))
          population_probabilities = growth_size_bin_probabilities(
            mean_length[age_index],
            sd,
            size_edges,
          )
          row = rebin_weights * population_probabilities
          row .+= oftype(sd, 1e-12)
          row ./= sum(row)
          age_to_length_conversion[age_index, global_indices, fleet_index] .= row
        end
      end
    end
  end
  growth_derived_mean_WAA = if isnothing(age_to_length_conversion)
    nothing
  else
    n_fleets = length(data_dict[:fleets])
    fleet_length_counts = get(
      data_dict,
      :n_lengths_by_fleet,
      fill(data_dict[:n_lengths], n_fleets),
    )
    mean_weights = zeros(
      promote_type(eltype(mean_length), eltype(age_to_length_conversion)),
      n_years,
      n_ages,
      n_fleets,
    )
    for fleet_index in 1:n_fleets
      fleet_length_counts[fleet_index] == 0 && continue
      fleet_conversion = ndims(age_to_length_conversion) == 3 ?
        view(age_to_length_conversion, :, :, fleet_index) : age_to_length_conversion
      for year in 1:n_years, age_index in 1:n_ages
        mean_weights[year, age_index, fleet_index] = sum(
          fleet_conversion[age_index, length_index] *
          length_weight_a * data_dict[:lengths][length_index]^length_weight_b for
          length_index in eachindex(data_dict[:lengths])
        )
      end
    end
    mean_weights
  end
  age_to_length_conversion_derived_used = if isnothing(growth_derived_mean_WAA)
    falses(length(data_dict[:fleets]))
  else
    fleet_length_counts = get(
      data_dict,
      :n_lengths_by_fleet,
      fill(data_dict[:n_lengths], length(data_dict[:fleets])),
    )
    BitVector(fleet_length_counts .> 0)
  end
  (
    weights_at_age = weights_at_age,
    mean_length_at_age = repeat(reshape(mean_length, 1, n_ages), n_years, 1),
    sd_length_at_age = repeat(reshape(sd_length, 1, n_ages), n_years, 1),
    age_to_length_conversion = age_to_length_conversion,
    growth_derived_mean_WAA = growth_derived_mean_WAA,
    age_to_length_conversion_derived_used = age_to_length_conversion_derived_used,
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
  population_weights_at_age =
    extend_terminal_year(weights_at_age, data_dict[:n_years], "weights_at_age")
  population_maturity_at_age =
    extend_terminal_year(maturity_at_age, data_dict[:n_years], "maturity_at_age")
  T = promote_type(
    eltype(collect(params.log_init_naa)),
    eltype(data_dict[:ages]),
    eltype(population_weights_at_age),
    eltype(population_maturity_at_age),
    eltype(collect(params.log_Fmort)),
  )
  n_fleets = size(params.log_Fmort, 2)
  numbers_at_age = Matrix{T}(undef, data_dict[:n_years] + 1, data_dict[:n_ages])
  numbers_at_age .= zero(T)
  numbers_at_age[1, :] .= exp.(collect(params.log_init_naa))
  proportion_female = collect(get(data_dict, :proportion_female, ones(T, data_dict[:n_ages])))
  length(proportion_female) == data_dict[:n_ages] ||
    throw(ArgumentError("proportion_female must provide one value per age."))

  PopulationModel(
    ages = collect(data_dict[:ages]),
    weights_at_age = Matrix{T}(population_weights_at_age),
    maturity_at_age = Matrix{T}(population_maturity_at_age),
    proportion_female = T.(proportion_female),
    numbers_at_age = numbers_at_age,
    catch_numbers_at_age = zeros(T, data_dict[:n_years], data_dict[:n_ages]),
    biomass = zeros(T, data_dict[:n_years] + 1),
    spawning_biomass = zeros(T, data_dict[:n_years] + 1),
    expected_recruitment = zeros(T, data_dict[:n_years] + 1),
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

function extend_terminal_year(values::AbstractMatrix, n_years, field_name)
  size(values, 1) == n_years + 1 && return values
  size(values, 1) == n_years ||
    throw(DimensionMismatch("$field_name must have one row per modeled year, with an optional terminal row."))
  vcat(values, values[end:end, :])
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

function parameter_prior_nll_components(params, model_config)
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

  nll_components = eltype(collect(params))[]
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
      push!(nll_components,
        0.5 * log(2π) + log(standard_deviation) +
        ((value - mean)^2) / (2 * standard_deviation^2))
    elseif distribution == "dlnorm"
      if !isfinite(value) || value <= 0
        push!(nll_components, oftype(value, Inf))
      else
        push!(nll_components,
          0.5 * log(2π) + log(standard_deviation) + log(value) +
          ((log(value) - mean)^2) / (2 * standard_deviation^2))
      end
    else
      throw(ArgumentError("Unsupported parameter prior distribution: $distribution"))
    end
  end
  nll_components
end

function parameter_prior_nll(params, model_config)
  total = zero(eltype(collect(params)))
  for component in parameter_prior_nll_components(params, model_config)
    total += component
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
    selectivity = build_selectivity(
      params,
      model_config,
      fleet_index,
      data_dict[:ages],
      data_dict[:n_years],
    )
    for year in 1:data_dict[:n_years], age in 1:data_dict[:n_ages]
      age_value = data_dict[:ages][age]
      selectivity_value = if selectivity isa AgeSpecificSelectivity
        selectivity(age_value, year)
      else
        selectivity(age_value)
      end
      fleet_selectivity[year, age, fleet_index] = selectivity_value
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

  catch_nll_by_fleet = fill(zero(parameter_type), n_fleets)
  index_nll_by_fleet = fill(zero(parameter_type), n_fleets)
  fleet_likelihood_value(value, fleet_index) =
    value isa AbstractMatrix ? view(value, :, fleet_index) : value

  if haskey(data_dict, :observed_catch) && !isempty(data_dict[:observed_catch])
    sigma_catch = get(model_config, :catch_sigma, parameter_type(0.1))
    catch_family = get(model_config, :catch_distribution, "dlnorm")
    for fleet_index in 1:n_fleets
      catch_nll_by_fleet[fleet_index] = data_likelihood_nll(
        view(data_dict[:observed_catch], :, fleet_index),
        view(population.catch_expected_by_fleet, :, fleet_index),
        fleet_likelihood_value(sigma_catch, fleet_index),
        fleet_likelihood_value(catch_family, fleet_index),
      )
    end
  end

  if haskey(data_dict, :observed_index) && !isempty(data_dict[:observed_index])
    sigma_index = get(model_config, :index_sigma, parameter_type(0.1))
    index_family = get(model_config, :index_distribution, "dlnorm")
    for fleet_index in 1:n_fleets
      index_nll_by_fleet[fleet_index] = data_likelihood_nll(
        view(data_dict[:observed_index], :, fleet_index),
        view(population.index_expected_by_fleet, :, fleet_index),
        fleet_likelihood_value(sigma_index, fleet_index),
        fleet_likelihood_value(index_family, fleet_index),
      )
    end
  end

  age_comp_expected = zeros(parameter_type, data_dict[:n_years], data_dict[:n_ages], n_fleets)
  age_comp_proportion = zeros(parameter_type, data_dict[:n_years], data_dict[:n_ages], n_fleets)
  length_comp_expected = zeros(parameter_type, data_dict[:n_years], data_dict[:n_lengths], n_fleets)
  length_comp_proportion = zeros(parameter_type, data_dict[:n_years], data_dict[:n_lengths], n_fleets)
  age_comp_nll_by_fleet = fill(zero(parameter_type), n_fleets)
  length_comp_nll_by_fleet = fill(zero(parameter_type), n_fleets)
  fleet_has_catch = get(data_dict, :fleet_has_catch, trues(n_fleets))
  observed_age_comp = get(data_dict, :observed_age_comp, nothing)
  observed_length_comp = get(data_dict, :observed_length_comp, nothing)
  for fleet_index in 1:n_fleets
    has_observed_age_comp = !isnothing(observed_age_comp) &&
      any(value -> isfinite(value) && value != -999, view(observed_age_comp, :, :, fleet_index))
    has_observed_length_comp = !isnothing(observed_length_comp) &&
      any(value -> isfinite(value) && value != -999, view(observed_length_comp, :, :, fleet_index))
    numbers_at_age = fleet_has_catch[fleet_index] ?
      view(population.catch_numbers_at_age_by_fleet, :, :, fleet_index) :
      view(population.index_numbers_at_age_by_fleet, :, :, fleet_index)
    for year in 1:data_dict[:n_years]
      total_numbers = sum(view(numbers_at_age, year, :))
      if total_numbers > 0
        age_comp_proportion[year, :, fleet_index] .= numbers_at_age[year, :] ./ total_numbers
      end
      if !has_observed_age_comp
        age_comp_expected[year, :, fleet_index] .= numbers_at_age[year, :]
      else
        observed_row = view(observed_age_comp, year, :, fleet_index)
        sample_size = sum(value for value in observed_row if isfinite(value) && value != -999)
        age_comp_expected[year, :, fleet_index] .=
          age_comp_proportion[year, :, fleet_index] .* sample_size
      end
      if !isnothing(growth_products.age_to_length_conversion)
        conversion = growth_products.age_to_length_conversion
        fleet_conversion = ndims(conversion) == 3 ?
          view(conversion, :, :, fleet_index) : conversion
        length_numbers = transpose(fleet_conversion) * age_comp_proportion[year, :, fleet_index]
        total_length_numbers = sum(length_numbers)
        if total_length_numbers > 0
          length_comp_proportion[year, :, fleet_index] .= length_numbers ./ total_length_numbers
        end
        if !has_observed_length_comp
          length_comp_expected[year, :, fleet_index] .= length_comp_proportion[year, :, fleet_index]
        else
          observed_row = view(observed_length_comp, year, :, fleet_index)
          sample_size = sum(value for value in observed_row if isfinite(value) && value != -999)
          length_comp_expected[year, :, fleet_index] .=
            length_comp_proportion[year, :, fleet_index] .* sample_size
        end
      end
    end
  end

  if !isnothing(observed_age_comp) && !isempty(observed_age_comp)
    for fleet_index in 1:n_fleets
      age_comp_nll_by_fleet[fleet_index] = multinomial_nll(
        Matrix(observed_age_comp[:, :, fleet_index]),
        Matrix(age_comp_expected[:, :, fleet_index]),
      )
    end
  end

  if !isnothing(observed_length_comp) && !isempty(observed_length_comp)
    for fleet_index in 1:n_fleets
      length_comp_nll_by_fleet[fleet_index] = multinomial_nll(
        Matrix(observed_length_comp[:, :, fleet_index]),
        Matrix(length_comp_expected[:, :, fleet_index]),
      )
    end
  end

  catch_numbers_at_age_by_fleet = population.catch_numbers_at_age_by_fleet
  index_numbers_at_age_by_fleet = population.index_numbers_at_age_by_fleet
  modeled_weights_at_age =
    view(population.weights_at_age, 1:data_dict[:n_years], :)
  catch_weight_at_age_by_fleet =
    catch_numbers_at_age_by_fleet .* reshape(modeled_weights_at_age, data_dict[:n_years], data_dict[:n_ages], 1)
  index_weight_at_age_by_fleet =
    index_numbers_at_age_by_fleet .* reshape(modeled_weights_at_age, data_dict[:n_years], data_dict[:n_ages], 1)
  catch_numbers_by_fleet = dropdims(sum(catch_numbers_at_age_by_fleet, dims = 2), dims = 2)
  index_numbers_by_fleet = dropdims(sum(index_numbers_at_age_by_fleet, dims = 2), dims = 2)
  catch_weight_by_fleet = dropdims(sum(catch_weight_at_age_by_fleet, dims = 2), dims = 2)
  index_weight_by_fleet = dropdims(sum(index_weight_at_age_by_fleet, dims = 2), dims = 2)
  catch_numbers_at_length_by_fleet =
    zeros(parameter_type, data_dict[:n_years], data_dict[:n_lengths], n_fleets)
  index_numbers_at_length_by_fleet =
    zeros(parameter_type, data_dict[:n_years], data_dict[:n_lengths], n_fleets)
  if !isnothing(growth_products.age_to_length_conversion)
    conversion = growth_products.age_to_length_conversion
    for fleet_index in 1:n_fleets, year in 1:data_dict[:n_years]
      fleet_conversion = ndims(conversion) == 3 ?
        view(conversion, :, :, fleet_index) : conversion
      catch_numbers_at_length_by_fleet[year, :, fleet_index] .=
        transpose(fleet_conversion) * view(catch_numbers_at_age_by_fleet, year, :, fleet_index)
      index_numbers_at_length_by_fleet[year, :, fleet_index] .=
        transpose(fleet_conversion) * view(index_numbers_at_age_by_fleet, year, :, fleet_index)
    end
  end
  unfished_numbers_at_age =
    zeros(parameter_type, data_dict[:n_years] + 1, data_dict[:n_ages])
  log_unfished_recruitment =
    params.log_rzero isa Number ? params.log_rzero : first(params.log_rzero)
  unfished_recruitment = exp(log_unfished_recruitment)
  unfished_numbers_at_age[1, 1] = unfished_recruitment
  for age in 2:(data_dict[:n_ages] - 1)
    unfished_numbers_at_age[1, age] =
      unfished_numbers_at_age[1, age - 1] *
      exp(-population.mortality_M[1, age - 1])
  end
  if data_dict[:n_ages] > 1
    previous_age = data_dict[:n_ages] - 1
    plus_age = data_dict[:n_ages]
    survivors =
      unfished_numbers_at_age[1, previous_age] *
      exp(-population.mortality_M[1, previous_age])
    unfished_numbers_at_age[1, plus_age] =
      survivors / (one(parameter_type) - exp(-population.mortality_M[1, plus_age]))
  end
  for year in 2:(data_dict[:n_years] + 1)
    mortality_year = year - 1
    unfished_numbers_at_age[year, 1] = unfished_recruitment
    for age in 2:(data_dict[:n_ages] - 1)
      previous_age = age - 1
      unfished_numbers_at_age[year, age] =
        unfished_numbers_at_age[year - 1, previous_age] *
        exp(-population.mortality_M[mortality_year, previous_age])
    end
    if data_dict[:n_ages] > 1
      previous_age = data_dict[:n_ages] - 1
      plus_age = data_dict[:n_ages]
      survivors =
        unfished_numbers_at_age[year - 1, previous_age] *
        exp(-population.mortality_M[mortality_year, previous_age])
      unfished_numbers_at_age[year, plus_age] =
        survivors + unfished_numbers_at_age[year - 1, plus_age] *
        exp(-population.mortality_M[mortality_year, plus_age])
    end
  end
  unfished_biomass =
    vec(sum(unfished_numbers_at_age .* population.weights_at_age, dims = 2))
  unfished_spawning_biomass = vec(sum(
    unfished_numbers_at_age .* population.weights_at_age .* population.maturity_at_age .*
    reshape(population.proportion_female, 1, data_dict[:n_ages]),
    dims = 2,
  ))
  spawning_biomass_ratio = population.spawning_biomass ./ first(unfished_spawning_biomass)
  log_index_expected_by_fleet = log.(population.index_expected_by_fleet)
  log_catch_expected_by_fleet = log.(population.catch_expected_by_fleet)
  has_recruitment_process_values =
    recruitment_mode == "log_r" ? has_component(params, :log_r) : has_component(params, :log_devs)
  process_nll_value = zero(parameter_type)
  if get(model_config, :recruitment_process_active, false) && has_recruitment_process_values
    process_family = lowercase(string(get(model_config, :recruitment_process_distribution, "dnorm")))
    process_family in ("dnorm", "dlnorm") ||
      throw(ArgumentError("Unsupported recruitment process distribution: $process_family"))
    process_nll = process_family == "dlnorm" ? lognormal_random_effect_nll : normal_nll
    recruit_sd = if has_component(params, :log_sd)
      log_sd = params.log_sd
      if log_sd isa Number
        exp(log_sd)
      elseif length(log_sd) == 1
        exp(first(log_sd))
      else
        exp.(log_sd)
      end
    else
      get(model_config, :recruitment_deviation_sd, one(eltype(recruit_devs)))
    end
    if recruitment_mode == "log_r"
      expected_log_recruitment = [
        log(recruitment(population.spawning_biomass[year], phi_0)) for
        year in 1:(data_dict[:n_years] - 1)
      ]
      process_nll_value += process_nll(params.log_r, expected_log_recruitment, recruit_sd)
    else
      process_nll_value += process_nll(
        params.log_devs,
        zeros(parameter_type, length(params.log_devs)),
        recruit_sd,
      )
    end
  end

  prior_nll_components = parameter_prior_nll_components(params, model_config)
  prior_nll_value = sum(prior_nll_components; init = zero(parameter_type))
  nll_components = copy(prior_nll_components)
  if get(model_config, :recruitment_process_active, false) && has_recruitment_process_values
    push!(nll_components, process_nll_value)
  end
  fleet_has_catch = get(
    data_dict,
    :fleet_has_catch,
    haskey(data_dict, :observed_catch) ? [
      any(value -> isfinite(value) && value != -999, view(data_dict[:observed_catch], :, fleet_index)) for
      fleet_index in 1:n_fleets
    ] : falses(n_fleets),
  )
  fleet_has_index = get(
    data_dict,
    :fleet_has_index,
    haskey(data_dict, :observed_index) ? [
      any(value -> isfinite(value) && value != -999, view(data_dict[:observed_index], :, fleet_index)) for
      fleet_index in 1:n_fleets
    ] : falses(n_fleets),
  )
  fleet_has_age_comp = get(
    data_dict,
    :fleet_has_age_comp,
    isnothing(observed_age_comp) ? falses(n_fleets) : [
      any(value -> isfinite(value) && value != -999, view(observed_age_comp, :, :, fleet_index)) for
      fleet_index in 1:n_fleets
    ],
  )
  fleet_has_length_comp = get(
    data_dict,
    :fleet_has_length_comp,
    isnothing(observed_length_comp) ? falses(n_fleets) : [
      any(value -> isfinite(value) && value != -999, view(observed_length_comp, :, :, fleet_index)) for
      fleet_index in 1:n_fleets
    ],
  )
  for fleet_index in 1:n_fleets
    if haskey(data_dict, :observed_catch) && fleet_has_catch[fleet_index]
      push!(nll_components, catch_nll_by_fleet[fleet_index])
    end
    if haskey(data_dict, :observed_index) && fleet_has_index[fleet_index]
      push!(nll_components, index_nll_by_fleet[fleet_index])
    end
    if fleet_has_age_comp[fleet_index]
      push!(nll_components, age_comp_nll_by_fleet[fleet_index])
    end
    if fleet_has_length_comp[fleet_index]
      push!(nll_components, length_comp_nll_by_fleet[fleet_index])
    end
  end
  total_nll = sum(nll_components; init = zero(parameter_type))

  Dict(
    "nll" => total_nll,
    "report" => Dict(
      "parameter_prior_nll" => prior_nll_value,
      "nll_components" => nll_components,
      "numbers_at_age" => population.numbers_at_age,
      "catch_numbers_at_age" => population.catch_numbers_at_age,
      "biomass" => population.biomass,
      "spawning_biomass" => population.spawning_biomass,
      "expected_recruitment" => population.expected_recruitment,
      "mortality_F" => population.mortality_F,
      "mortality_M" => population.mortality_M,
      "mortality_Z" => population.mortality_Z,
      "proportion_mature_at_age" => population.maturity_at_age,
      "unfished_numbers_at_age" => unfished_numbers_at_age,
      "unfished_biomass" => unfished_biomass,
      "unfished_spawning_biomass" => unfished_spawning_biomass,
      "spawning_biomass_ratio" => spawning_biomass_ratio,
      "weights_at_age" => population.weights_at_age,
      "mean_length_at_age" => growth_products.mean_length_at_age,
      "sd_length_at_age" => growth_products.sd_length_at_age,
      "growth_derived_mean_WAA_by_fleet" => growth_products.growth_derived_mean_WAA,
      "age_to_length_conversion" => growth_products.age_to_length_conversion,
      "age_to_length_conversion_fixed" => get(data_dict, :age_to_length_conversion, nothing),
      "age_to_length_conversion_derived_used" =>
        growth_products.age_to_length_conversion_derived_used,
      "age_to_length_conversion_derived" => nothing,
      "sum_selectivity" => dropdims(sum(fleet_selectivity, dims = 3), dims = 3),
      "catch_expected" => population.catch_expected,
      "index_expected" => population.index_expected,
      "total_catch_numbers" => vec(sum(catch_numbers_by_fleet, dims = 2)),
      "total_catch_weight" => population.catch_expected,
      "catch_expected_by_fleet" => population.catch_expected_by_fleet,
      "index_expected_by_fleet" => population.index_expected_by_fleet,
      "catch_numbers_by_fleet" => catch_numbers_by_fleet,
      "index_numbers_by_fleet" => index_numbers_by_fleet,
      "catch_weight_by_fleet" => catch_weight_by_fleet,
      "index_weight_by_fleet" => index_weight_by_fleet,
      "catch_weight_at_age_by_fleet" => catch_weight_at_age_by_fleet,
      "index_weight_at_age_by_fleet" => index_weight_at_age_by_fleet,
      "catch_numbers_at_age_by_fleet" => catch_numbers_at_age_by_fleet,
      "index_numbers_at_age_by_fleet" => index_numbers_at_age_by_fleet,
      "catch_numbers_at_length_by_fleet" => catch_numbers_at_length_by_fleet,
      "index_numbers_at_length_by_fleet" => index_numbers_at_length_by_fleet,
      "agecomp_expected" => age_comp_expected,
      "agecomp_proportion" => age_comp_proportion,
      "lengthcomp_expected" => length_comp_expected,
      "lengthcomp_proportion" => length_comp_proportion,
      "log_index_expected_by_fleet" => log_index_expected_by_fleet,
      "log_catch_expected_by_fleet" => log_catch_expected_by_fleet,
      "jnll" => total_nll,
    ),
  )
end

function evaluate_nll(parameters_vector, data_dict, model_config)
  evaluate_model(parameters_vector, data_dict, model_config)["nll"]
end
