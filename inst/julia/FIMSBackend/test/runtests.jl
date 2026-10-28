using FIMSBackend
using Test
using ComponentArrays: ComponentArray
using ForwardDiff: derivative
using SpecialFunctions: erf

@testset "age-specific selectivity" begin
  ages = [1.0, 2.0, 3.0]
  parameters = ComponentArray((
    logit_sel_at_age = [
      log(1 / 3) log(3);
      0.0 log(1 / 3);
      log(3) 0.0;
    ],
  ))
  model_config = Dict(:selectivity_types => ["AgeSpecific", "AgeSpecific"])
  first_fleet = FIMSBackend.build_selectivity(parameters, model_config, 1, ages)
  second_fleet = FIMSBackend.build_selectivity(parameters, model_config, 2, ages)

  @test [first_fleet(age) for age in ages] ≈ [0.25, 0.5, 0.75]
  @test [second_fleet(age) for age in ages] ≈ [0.75, 0.25, 0.5]
  @test_throws ArgumentError first_fleet(4.0)
  @test derivative(
    value -> FIMSBackend.AgeSpecificSelectivity([value], [1.0])(1.0),
    0.0,
  ) ≈ 0.25
end

@testset "age-specific selectivity supports scalar and year-specific parameters" begin
  ages = [1.0, 2.0]
  scalar = FIMSBackend.AgeSpecificSelectivity([0.0], ages, 2)
  @test [scalar(age, year) for year in 1:2 for age in ages] ≈ fill(0.5, 4)

  yearly = FIMSBackend.AgeSpecificSelectivity(
    [log(1 / 3), log(3), log(3), log(1 / 3)],
    ages,
    2,
  )
  @test [yearly(age, 1) for age in ages] ≈ [0.25, 0.75]
  @test [yearly(age, 2) for age in ages] ≈ [0.75, 0.25]
  @test_throws ArgumentError yearly(1.0, 3)
  @test_throws ArgumentError FIMSBackend.AgeSpecificSelectivity(
    [0.0, 1.0, 2.0],
    ages,
    2,
  )
end

@testset "spawning biomass per recruit" begin
  natural_mortality = [0.1, 0.2, 0.3]
  weights_at_age = repeat(reshape([2.0, 4.0, 8.0], 1, 3), 2, 1)
  maturity_at_age = repeat(reshape([0.5, 0.75, 1.0], 1, 3), 2, 1)
  proportion_female = [1.0, 0.5, 0.5]
  population = PopulationModel(
    ages = [1.0, 2.0, 3.0],
    weights_at_age = weights_at_age,
    maturity_at_age = maturity_at_age,
    proportion_female = proportion_female,
    numbers_at_age = zeros(2, 3),
    catch_numbers_at_age = zeros(2, 3),
    biomass = zeros(2),
    spawning_biomass = zeros(2),
    expected_recruitment = zeros(2),
    mortality_F = zeros(2, 3),
    mortality_M = repeat(reshape(natural_mortality, 1, 3), 2, 1),
    mortality_Z = zeros(2, 3),
    catch_expected = zeros(2),
    index_expected = zeros(2),
    catch_numbers_at_age_by_fleet = zeros(2, 3, 1),
    index_numbers_at_age_by_fleet = zeros(2, 3, 1),
    catch_expected_by_fleet = zeros(2, 1),
    index_expected_by_fleet = zeros(2, 1),
  )
  numbers_per_recruit = [
    1.0,
    exp(-natural_mortality[1]),
    exp(-natural_mortality[1] - natural_mortality[2]) /
      (1 - exp(-natural_mortality[3])),
  ]
  expected_phi_0 = sum(
    numbers_per_recruit .* proportion_female .* maturity_at_age[1, :] .* weights_at_age[1, :]
  )

  @test FIMSBackend.Population.spawning_biomass_per_recruit(population) ≈ expected_phi_0

  observed_phi_0 = Ref(0.0)
  step_population!(
    population,
    nothing,
    (spawners, phi_0) -> begin
      observed_phi_0[] = phi_0
      zero(phi_0)
    end,
    Dict(
      :fishing_mortality => zeros(2, 1),
      :fleet_selectivity => zeros(2, 3, 1),
    ),
  )
  @test observed_phi_0[] ≈ expected_phi_0
end

@testset "multi-fleet catch, index, age, and length streams" begin
  parameter_values = (
    inflection_point = [2.0, 2.0],
    slope = [1.0, 1.0],
    inflection_point_asc = [2.0, 2.0],
    slope_asc = [1.0, 1.0],
    inflection_point_desc = [4.0, 4.0],
    slope_desc = [1.0, 1.0],
    log_rzero = log(1000.0),
    logit_steep = 0.0,
    log_devs = [0.0],
    log_r = log.([500.0]),
    log_init_naa = log.([1000.0, 800.0, 600.0]),
    log_M = fill(log(0.2), 2, 3),
    log_Fmort = [log(0.1) -200.0; log(0.1) -200.0],
    log_q = [0.0, log(2.0)],
  )
  parameters = ComponentArray(parameter_values)
  vonb_parameters = ComponentArray(
    merge(
      parameter_values,
      (
        growth_log_mean_length_young = log(275.0),
        growth_log_mean_length_old = log(725.0),
        growth_log_coefficient = log(0.18),
        growth_reference_age_young = 1.0,
        growth_reference_age_old = 3.0,
        growth_log_length_weight_a = log(2.5e-11),
        growth_log_length_weight_b = log(3.0),
        growth_log_length_sd_at_young = log(28.0),
        growth_log_length_sd_at_old = log(73.0),
      ),
    ),
  )
  delta_method_parameters = ComponentArray(
    merge(
      parameter_values,
      (
        growth_log_mean_length_young = log(275.0),
        growth_log_mean_length_old = log(725.0),
        growth_log_coefficient = log(0.18),
        growth_reference_age_young = 1.0,
        growth_reference_age_old = 3.0,
        growth_log_length_weight_a = log(2.5e-11),
        growth_log_length_weight_b = log(3.0),
        growth_log_sd_mean_length_young = log(12.0),
        growth_log_sd_mean_length_old = log(20.0),
        growth_log_sd_growth_coefficient = log(0.03),
        growth_mean_length_young_mean_length_old_logit_corr = 0.2,
        growth_mean_length_young_growth_coefficient_logit_corr = -0.3,
        growth_mean_length_old_growth_coefficient_logit_corr = 0.1,
      ),
    ),
  )
  maturity_parameters = ComponentArray(
    merge(
      parameter_values,
      (maturity_inflection_point = 2.0, maturity_slope = 1.0),
    ),
  )
  data = Dict(
    :fleets => ["fish", "survey"],
    :fleet_has_catch => [true, false],
    :fleet_has_index => [false, true],
    :n_years => 2,
    :n_ages => 3,
    :n_lengths => 2,
    :ages => [1.0, 2.0, 3.0],
    :lengths => [10.0, 20.0],
    :weights_at_age => repeat(reshape([1.0, 2.0, 3.0], 1, 3), 2, 1),
    :maturity_at_age => repeat(reshape([0.0, 0.5, 1.0], 1, 3), 2, 1),
    :proportion_female => ones(3),
    :observed_catch => [100.0 -999.0; 90.0 -999.0],
    :observed_index => [-999.0 500.0; -999.0 450.0],
    :observed_age_comp => cat(
      [10.0 20.0 30.0; 12.0 22.0 28.0],
      fill(-999.0, 2, 3),
      dims = 3,
    ),
    :observed_length_comp => cat(
      [20.0 40.0; 22.0 38.0],
      fill(-999.0, 2, 2),
      dims = 3,
    ),
    :age_to_length_conversion => [0.9 0.1; 0.5 0.5; 0.1 0.9],
  )
  config = Dict(
    :selectivity_types => ["Logistic", "Logistic"],
    :recruitment => :beverton_holt,
    :recruitment_process_active => true,
    :recruitment_process_distribution => "dnorm",
    :recruitment_process_mode => "log_devs",
    :catch_sigma => 0.1,
    :index_sigma => 0.1,
    :parameter_names => String.(propertynames(parameters)),
  )

  result = evaluate_model(parameters, data, config)
  report = result["report"]
  vonb_result = evaluate_model(
    vonb_parameters,
    data,
    merge(config, Dict(:growth_model_type => "VonBertalanffySchnute")),
  )
  delta_method_result = evaluate_model(
    delta_method_parameters,
    data,
    merge(config, Dict(:growth_model_type => "VonBertalanffySchnute")),
  )
  maturity_result = evaluate_model(maturity_parameters, data, config)
  age_specific_parameters = ComponentArray(
    merge(
      parameter_values,
      (
        logit_sel_at_age = [
          log(1 / 3) log(3);
          0.0 log(1 / 3);
          log(3) 0.0;
        ],
      ),
    ),
  )
  age_specific_result = evaluate_model(
    age_specific_parameters,
    data,
    merge(config, Dict(:selectivity_types => ["AgeSpecific", "AgeSpecific"])),
  )
  year_specific_parameters = ComponentArray(
    merge(
      parameter_values,
      (
        logit_sel_at_age = [
          log(1 / 3),
          0.0,
          log(3),
          log(3),
          0.0,
          log(1 / 3),
          log(3),
          log(1 / 3),
          0.0,
        ],
      ),
    ),
  )
  year_specific_result = evaluate_model(
    year_specific_parameters,
    data,
    merge(
      config,
      Dict(
        :selectivity_types => ["AgeSpecific", "AgeSpecific"],
        :selectivity_parameter_offsets => [1, 7],
        :selectivity_parameter_lengths => [6, 3],
      ),
    ),
  )
  no_process_result = evaluate_model(
    parameters,
    data,
    merge(config, Dict(:recruitment_process_active => false)),
  )
  normal_prior_result = evaluate_model(
    parameters,
    data,
    merge(
      config,
      Dict(
        :parameter_prior_components => ["slope"],
        :parameter_prior_indices => [1],
        :parameter_prior_distributions => ["dnorm"],
        :parameter_prior_means => [1.5],
        :parameter_prior_sds => [3.0],
      ),
    ),
  )
  lognormal_prior_result = evaluate_model(
    parameters,
    data,
    merge(
      config,
      Dict(
        :parameter_prior_components => ["slope"],
        :parameter_prior_indices => [1],
        :parameter_prior_distributions => ["dlnorm"],
        :parameter_prior_means => [0.2],
        :parameter_prior_sds => [0.5],
      ),
    ),
  )

  @test isfinite(result["nll"])
  expected_maturity = 1.0 ./ (1.0 .+ exp.(-([1.0, 2.0, 3.0] .- 2.0)))
  @test maturity_result["report"]["proportion_mature_at_age"] ≈
    repeat(reshape(expected_maturity, 1, :), 2, 1)
  @test maturity_result["nll"] != result["nll"]
  @test age_specific_result["report"]["sum_selectivity"][1, :] ≈ [1.0, 0.75, 1.25]
  @test year_specific_result["report"]["sum_selectivity"][1, :] ≈ [1.0, 0.75, 1.25]
  @test year_specific_result["report"]["sum_selectivity"][2, :] ≈ [1.5, 0.75, 0.75]
  expected_lengths = [
    275.0 +
    (725.0 - 275.0) *
    (1.0 - exp(-0.18 * (age - 1.0))) /
    (1.0 - exp(-0.18 * (3.0 - 1.0))) for age in data[:ages]
  ]
  @test vonb_result["report"]["mean_length_at_age"] ≈
    repeat(reshape(expected_lengths, 1, :), 2, 1)
  @test vonb_result["report"]["weights_at_age"] ≈
    repeat(reshape(2.5e-11 .* expected_lengths .^ 3.0, 1, :), 2, 1)
  @test all(
    isapprox.(sum(vonb_result["report"]["age_to_length_conversion"], dims = 2), 1.0)
  )
  observed_length_edges = FIMSBackend.growth_observation_edges(data[:lengths])
  @test observed_length_edges == [5.0, 15.0, 25.0]
  @test FIMSBackend.growth_population_size_edges(observed_length_edges) ==
    collect(5.0:26.0)
  size_edges = collect(5.0:26.0)
  fleet_edges = [5.0, 15.0, 26.0]
  expected_conversion = zeros(3, 2)
  for age_index in 1:3
    mean_length = vonb_result["report"]["mean_length_at_age"][1, age_index]
    sd_length = vonb_result["report"]["sd_length_at_age"][1, age_index]
    cdf(edge) = 0.5 * (1 + erf((edge - mean_length) / (sd_length * sqrt(2))))
    size_probabilities = zeros(length(size_edges) - 1)
    size_probabilities[1] = cdf(size_edges[2])
    for bin_index in 2:(length(size_probabilities) - 1)
      size_probabilities[bin_index] =
        cdf(size_edges[bin_index + 1]) - cdf(size_edges[bin_index])
    end
    size_probabilities[end] = cdf(2 * mean_length - size_edges[end - 1])
    size_probabilities .+= 1e-12
    size_probabilities ./= sum(size_probabilities)
    for length_index in 1:2
      for size_index in eachindex(size_probabilities)
        overlap = max(
          0.0,
          min(fleet_edges[length_index + 1], size_edges[size_index + 1]) -
          max(fleet_edges[length_index], size_edges[size_index]),
        )
        expected_conversion[age_index, length_index] +=
          size_probabilities[size_index] * overlap /
          (size_edges[size_index + 1] - size_edges[size_index])
      end
    end
    expected_conversion[age_index, :] .+= 1e-12
    expected_conversion[age_index, :] ./= sum(expected_conversion[age_index, :])
  end
  @test vonb_result["report"]["age_to_length_conversion"] ≈ expected_conversion
  fleet_specific_data = merge(
    data,
    Dict(
      :n_lengths => 3,
      :lengths => [10.0, 20.0, 30.0],
      :lengths_by_fleet => [10.0 20.0; 20.0 30.0; 0.0 0.0],
      :n_lengths_by_fleet => [2, 2],
      :observed_length_comp => cat(
        [20.0 40.0 0.0; 22.0 38.0 0.0],
        [0.0 30.0 50.0; 0.0 34.0 46.0],
        dims = 3,
      ),
    ),
  )
  fleet_specific_result = evaluate_model(
    vonb_parameters,
    fleet_specific_data,
    merge(config, Dict(:growth_model_type => "VonBertalanffySchnute")),
  )
  fleet_specific_conversion =
    fleet_specific_result["report"]["age_to_length_conversion"]
  @test size(fleet_specific_conversion) == (3, 3, 2)
  @test all(isapprox.(sum(fleet_specific_conversion, dims = 2), 1.0))
  @test all(fleet_specific_conversion[:, 3, 1] .== 0)
  @test all(fleet_specific_conversion[:, 1, 2] .== 0)
  @test isfinite(fleet_specific_result["nll"])
  changed_length_comp = copy(fleet_specific_data[:observed_length_comp])
  changed_length_comp[1, 1, 1] += 10
  changed_composition_result = evaluate_model(
    vonb_parameters,
    merge(fleet_specific_data, Dict(:observed_length_comp => changed_length_comp)),
    merge(config, Dict(:growth_model_type => "VonBertalanffySchnute")),
  )
  @test changed_composition_result["nll"] != fleet_specific_result["nll"]
  @test isfinite(vonb_result["nll"])
  delta_sd = delta_method_result["report"]["sd_length_at_age"]
  @test all(isfinite, delta_sd)
  @test all(delta_sd .> 0)
  @test delta_sd != vonb_result["report"]["sd_length_at_age"]
  @test isfinite(delta_method_result["nll"])
  reference_log_lengths = [log(275.0), log(725.0), log(0.18)]
  mean_length_at_age = function (log_lengths, age)
    mean_young = exp(log_lengths[1])
    mean_old = exp(log_lengths[2])
    coefficient = exp(log_lengths[3])
    numerator = 1 - exp(-coefficient * (age - 1.0))
    denominator = 1 - exp(-coefficient * (3.0 - 1.0))
    mean_young + (mean_old - mean_young) * numerator / denominator
  end
  log_length_at_age = (log_lengths, age) -> log(mean_length_at_age(log_lengths, age))
  correlation(value) = 2 / (1 + exp(-value)) - 1
  covariance_young_old = correlation(0.2) * 12.0 * 20.0
  covariance_young_coefficient = correlation(-0.3) * 12.0 * 0.03
  covariance_old_coefficient = correlation(0.1) * 20.0 * 0.03
  variance_young = 12.0^2
  variance_old = 20.0^2
  variance_coefficient = 0.03^2
  growth_covariance = [
    variance_young covariance_young_old covariance_young_coefficient
    covariance_young_old variance_old covariance_old_coefficient
    covariance_young_coefficient covariance_old_coefficient variance_coefficient
  ]
  function finite_difference_gradient(age)
    gradient = zeros(3)
    for parameter_index in 1:3
      offset = zeros(3)
      offset[parameter_index] = 1e-5
      gradient[parameter_index] =
        (
          log_length_at_age(reference_log_lengths .+ offset, age) -
          log_length_at_age(reference_log_lengths .- offset, age)
        ) / 2e-5
    end
    gradient
  end
  expected_delta_sd = [
    mean_length_at_age(reference_log_lengths, age) *
    sqrt(max(
      sum(
        finite_difference_gradient(age) .*
        (growth_covariance * finite_difference_gradient(age))
      ),
      0.0,
    )) for age in data[:ages]
  ]
  @test delta_sd[1, :] ≈ expected_delta_sd atol = 1e-5
  @test_throws ArgumentError evaluate_model(
    ComponentArray(
      merge(
        parameter_values,
        (
          growth_log_mean_length_young = log(275.0),
          growth_log_mean_length_old = log(725.0),
          growth_log_coefficient = log(0.18),
          growth_reference_age_young = 1.0,
          growth_reference_age_old = 3.0,
          growth_log_length_weight_a = log(2.5e-11),
          growth_log_length_weight_b = log(3.0),
          growth_log_sd_mean_length_young = log(12.0),
        ),
      ),
    ),
    data,
    merge(config, Dict(:growth_model_type => "VonBertalanffySchnute")),
  )
  @test isfinite(
    derivative(log(12.0)) do log_sd_young
      differentiated_parameters = ComponentArray(
        merge(
          parameter_values,
          (
            growth_log_mean_length_young = log(275.0),
            growth_log_mean_length_old = log(725.0),
            growth_log_coefficient = log(0.18),
            growth_reference_age_young = 1.0,
            growth_reference_age_old = 3.0,
            growth_log_length_weight_a = log(2.5e-11),
            growth_log_length_weight_b = log(3.0),
            growth_log_sd_mean_length_young = log_sd_young,
            growth_log_sd_mean_length_old = log(20.0),
            growth_log_sd_growth_coefficient = log(0.03),
            growth_mean_length_young_mean_length_old_logit_corr = 0.2,
            growth_mean_length_young_growth_coefficient_logit_corr = -0.3,
            growth_mean_length_old_growth_coefficient_logit_corr = 0.1,
          ),
        ),
      )
      evaluate_nll(
        differentiated_parameters,
        data,
        merge(config, Dict(:growth_model_type => "VonBertalanffySchnute")),
      )
    end,
  )
  vonb_config = merge(config, Dict(:growth_model_type => "VonBertalanffySchnute"))
  @test isfinite(
    derivative(log(275.0)) do log_mean_length_young
      differentiated_parameters = ComponentArray(
        merge(
          parameter_values,
          (
            growth_log_mean_length_young = log_mean_length_young,
            growth_log_mean_length_old = log(725.0),
            growth_log_coefficient = log(0.18),
            growth_reference_age_young = 1.0,
            growth_reference_age_old = 3.0,
            growth_log_length_weight_a = log(2.5e-11),
            growth_log_length_weight_b = log(3.0),
            growth_log_length_sd_at_young = log(28.0),
            growth_log_length_sd_at_old = log(73.0),
          ),
        ),
      )
      evaluate_nll(differentiated_parameters, data, vonb_config)
    end,
  )
  @test normal_prior_result["nll"] - result["nll"] ≈
    0.5 * log(2π) + log(3.0) + (1.0 - 1.5)^2 / (2 * 3.0^2)
  @test normal_prior_result["report"]["parameter_prior_nll"] ≈
    0.5 * log(2π) + log(3.0) + (1.0 - 1.5)^2 / (2 * 3.0^2)
  @test lognormal_prior_result["nll"] - result["nll"] ≈
    0.5 * log(2π) + log(0.5) + log(1.0) + (log(1.0) - 0.2)^2 / (2 * 0.5^2)
  @test isapprox(result["nll"] - no_process_result["nll"], 0.5 * log(2π); atol = 1e-8)
  log_r_result = evaluate_model(
    parameters,
    data,
    merge(config, Dict(:recruitment_process_mode => "log_r")),
  )
  log_r_no_process_result = evaluate_model(
    parameters,
    data,
    merge(
      config,
      Dict(:recruitment_process_active => false, :recruitment_process_mode => "log_r"),
    ),
  )
  @test log_r_result["report"]["expected_recruitment"][2] ≈ 500.0
  expected_phi_0 =
    0.5 * exp(-0.2) * 2.0 +
    3.0 * exp(-0.4) / (1.0 - exp(-0.2))
  steepness = 0.6
  spawning_biomass = log_r_no_process_result["report"]["spawning_biomass"][1]
  mean_recruitment =
    0.8 * 1000.0 * steepness * spawning_biomass /
    (
      0.2 * expected_phi_0 * 1000.0 * (1.0 - steepness + sqrt(eps(Float64))) +
        spawning_biomass * (steepness - 0.2)
    )
  expected_process_nll =
    0.5 * log(2π) + (log(500.0) - log(mean_recruitment))^2 / 2.0
  @test isapprox(
    log_r_result["nll"] - log_r_no_process_result["nll"],
    expected_process_nll;
    atol = 1e-8,
  )
  lognormal_process_result = evaluate_model(
    parameters,
    data,
    merge(
      config,
      Dict(
        :recruitment_process_distribution => "dlnorm",
        :recruitment_process_mode => "log_r",
      ),
    ),
  )
  expected_lognormal_process_nll = FIMSBackend.lognormal_random_effect_nll(
    [log(500.0)],
    [log(mean_recruitment)],
    1.0,
  )
  @test isapprox(
    lognormal_process_result["nll"] - log_r_no_process_result["nll"],
    expected_lognormal_process_nll;
    atol = 1e-8,
  )
  @test_throws ArgumentError FIMSBackend.lognormal_random_effect_nll([-0.1], [0.0], 1.0)
  @test size(report["catch_expected_by_fleet"]) == (2, 2)
  @test size(report["index_expected_by_fleet"]) == (2, 2)
  @test size(report["catch_numbers_at_age_by_fleet"]) == (2, 3, 2)
  @test size(report["mortality_F"]) == (2, 3)
  @test size(report["mortality_M"]) == (2, 3)
  @test size(report["mortality_Z"]) == (2, 3)
  @test size(report["sum_selectivity"]) == (2, 3)
  @test size(report["catch_weight_at_age_by_fleet"]) == (2, 3, 2)
  @test size(report["index_weight_at_age_by_fleet"]) == (2, 3, 2)
  @test report["mortality_Z"] ≈ report["mortality_F"] + report["mortality_M"]
  @test report["total_catch_numbers"] ≈ vec(sum(report["catch_numbers_by_fleet"], dims = 2))
  @test report["total_catch_weight"] ≈ vec(sum(report["catch_expected_by_fleet"], dims = 2))
  @test size(report["agecomp_expected"]) == (2, 3, 2)
  @test size(report["lengthcomp_expected"]) == (2, 2, 2)
  @test all(isapprox(value, 1.0; atol = 1e-10) for value in sum(report["agecomp_expected"], dims = 2))
  @test all(isapprox(value, 1.0; atol = 1e-10) for value in sum(report["lengthcomp_expected"], dims = 2))
  @test all(report["index_expected_by_fleet"][:, 2] .> report["index_expected_by_fleet"][:, 1])
  @test_throws ArgumentError evaluate_model(
    parameters,
    data,
    merge(config, Dict(:selectivity_types => ["Logistic3D", "Logistic"])),
  )
  @test_throws ArgumentError evaluate_model(
    parameters,
    data,
    merge(config, Dict(:recruitment => :unsupported)),
  )

  fixed_mask = falses(length(parameters))
  random_mask = falses(length(parameters))
  fixed_mask[13] = true
  random_mask[15] = true
  fit_config = merge(
    config,
    Dict(
      :fixed_parameter_mask => fixed_mask,
      :random_parameter_mask => random_mask,
      :parameter_prior_components => ["log_rzero"],
      :parameter_prior_indices => [1],
      :parameter_prior_distributions => ["dnorm"],
      :parameter_prior_means => [log(1000.0)],
      :parameter_prior_sds => [1.5],
    ),
  )
  fit_result = fit_model(parameters, data, fit_config)
  @test fit_result["fixed_effect_count"] == 1
  @test fit_result["random_effect_count"] == 1
  @test isfinite(fit_result["nll"])
  @test length(fit_result["fixed_gradient"]) == 1
end

@testset "multinomial likelihood includes the sampling coefficient" begin
  observed = [1.0 1.0; -999.0 -999.0]
  expected = [0.25 0.75; 0.5 0.5]
  @test isapprox(FIMSBackend.multinomial_nll(observed, expected), -log(2 * 0.25 * 0.75); atol = 1e-7)
end

@testset "normal data likelihood" begin
  expected_nll = 0.5 * log(2π) + log(0.5) + 2.0
  @test isapprox(FIMSBackend.normal_nll([2.0], [1.0], 0.5), expected_nll; atol = 1e-10)
  @test isapprox(
    FIMSBackend.data_likelihood_nll([2.0], [1.0], 0.5, "dnorm"),
    expected_nll;
    atol = 1e-10,
  )
  @test_throws ArgumentError FIMSBackend.normal_nll([1.0], [1.0], 0.0)
  @test_throws ArgumentError FIMSBackend.lognormal_nll([1.0], [1.0], -0.1)
  @test_throws ArgumentError FIMSBackend.data_likelihood_nll([1.0], [1.0], 0.1, "dmultinom")
end

@testset "lognormal data likelihood does not drop out-of-support observations" begin
  @test isinf(FIMSBackend.lognormal_nll([0.0], [1.0], 0.5))
  @test isinf(FIMSBackend.lognormal_nll([-1.0], [1.0], 0.5))
  @test isinf(FIMSBackend.lognormal_nll([1.0], [0.0], 0.5))
  @test FIMSBackend.lognormal_nll([-999.0], [1.0], 0.5) == 0.0
end

@testset "lognormal recruitment process follows random-effect semantics" begin
  expected = [0.25, 0.5]
  observed = [2.0, 4.0]
  sigma = [0.5, 1.0]
  expected_nll = FIMSBackend.normal_nll(log.(observed), expected, sigma)

  @test isapprox(
    FIMSBackend.lognormal_random_effect_nll(observed, expected, sigma),
    expected_nll;
    atol = 1e-10,
  )
  @test_throws ArgumentError FIMSBackend.lognormal_random_effect_nll([1.0], [0.0], 0.0)
  @test_throws DimensionMismatch FIMSBackend.lognormal_random_effect_nll([1.0], [0.0], [0.5, 1.0])
end

@testset "data likelihood supports family by observation" begin
  observed = [2.0 2.0]
  expected = [1.0 1.0]
  sigma = [0.5 0.5]
  families = ["dnorm" "dlnorm"]
  expected_nll =
    FIMSBackend.normal_nll([2.0], [1.0], 0.5) +
    FIMSBackend.lognormal_nll([2.0], [1.0], 0.5)

  @test isapprox(
    FIMSBackend.data_likelihood_nll(observed, expected, sigma, families),
    expected_nll;
    atol = 1e-10,
  )
  @test_throws DimensionMismatch FIMSBackend.data_likelihood_nll(
    observed,
    expected,
    sigma,
    ["dnorm"],
  )
end

@testset "data likelihood supports observation-specific uncertainty" begin
  observed = [2.0 3.0; 4.0 -999.0]
  expected = [1.0 1.0; 2.0 2.0]
  sigma = [0.5 1.0; 2.0 3.0]
  manual_nll = sum(
    0.5 * log(2π) + log(sigma[index]) +
    ((observed[index] - expected[index])^2) / (2 * sigma[index]^2)
    for index in eachindex(observed) if observed[index] != -999
  )

  @test isapprox(FIMSBackend.normal_nll(observed, expected, sigma), manual_nll; atol = 1e-10)
  @test_throws DimensionMismatch FIMSBackend.normal_nll(observed, expected, ones(3))
end

@testset "recruitment process accepts observation-specific standard deviations" begin
  parameters = ComponentArray((
    inflection_point = [2.0],
    slope = [1.0],
    inflection_point_asc = [2.0],
    slope_asc = [1.0],
    inflection_point_desc = [4.0],
    slope_desc = [1.0],
    log_rzero = log(1000.0),
    logit_steep = 0.0,
    log_devs = [0.0, 0.0],
    log_r = [0.0, 0.0],
    log_sd = log.([0.5, 1.0]),
    log_init_naa = log.([1000.0, 500.0]),
    log_M = fill(log(0.2), 3, 2),
    log_Fmort = fill(-200.0, 3, 1),
    log_q = [0.0],
  ))
  data = Dict(
    :fleets => ["fish"],
    :n_years => 3,
    :n_ages => 2,
    :n_lengths => 1,
    :ages => [1.0, 2.0],
    :lengths => [10.0],
    :weights_at_age => repeat(reshape([1.0, 2.0], 1, 2), 3, 1),
    :maturity_at_age => repeat(reshape([0.0, 1.0], 1, 2), 3, 1),
    :proportion_female => ones(2),
  )
  config = Dict(
    :selectivity_types => ["Logistic"],
    :recruitment => :beverton_holt,
    :recruitment_process_active => true,
    :recruitment_process_distribution => "dnorm",
    :recruitment_process_mode => "log_devs",
  )
  with_process = evaluate_model(parameters, data, config)["nll"]
  without_process = evaluate_model(
    parameters,
    data,
    merge(config, Dict(:recruitment_process_active => false)),
  )["nll"]
  expected_process = FIMSBackend.normal_nll([0.0, 0.0], [0.0, 0.0], [0.5, 1.0])

  @test isapprox(with_process - without_process, expected_process; atol = 1e-10)
end
