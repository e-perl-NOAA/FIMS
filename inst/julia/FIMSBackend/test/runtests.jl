using FIMSBackend
using Test
using ComponentArrays: ComponentArray

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
  parameters = ComponentArray((
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
  ))
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
  no_process_result = evaluate_model(
    parameters,
    data,
    merge(config, Dict(:recruitment_process_active => false)),
  )

  @test isfinite(result["nll"])
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
