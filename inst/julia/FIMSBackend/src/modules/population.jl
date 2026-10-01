module Population

using ..Recruitment: BevertonHolt, Ricker

export PopulationModel, step_population!

positive_guard(x) = x + oftype(x, sqrt(eps(Float64)))

Base.@kwdef mutable struct PopulationModel{T <: Real}
  ages::Vector{T}
  weights_at_age::Matrix{T}
  maturity_at_age::Matrix{T}
  proportion_female::Vector{T}
  numbers_at_age::Matrix{T}
  catch_numbers_at_age::Matrix{T}
  biomass::Vector{T}
  spawning_biomass::Vector{T}
  expected_recruitment::Vector{T}
  mortality_F::Matrix{T}
  mortality_M::Matrix{T}
  mortality_Z::Matrix{T}
  catch_expected::Vector{T}
  index_expected::Vector{T}
end

function step_population!(
  pop::PopulationModel{T},
  sel,
  rec,
  catch_data::AbstractDict
) where {T <: Real}
  n_years, n_ages = size(pop.numbers_at_age)
  @assert n_ages == length(pop.ages)

  fishing_mortality = Matrix{T}(catch_data[:fishing_mortality])
  catchability = T(get(catch_data, :catchability, one(T)))
  phi_0 = T(get(catch_data, :phi_0, one(T)))
  recruit_devs = T.(collect(get(catch_data, :log_recruit_devs, zeros(T, max(n_years - 1, 0)))))

  for year in 1:n_years
    pop.biomass[year] = zero(T)
    pop.spawning_biomass[year] = zero(T)
    pop.catch_expected[year] = zero(T)
    pop.index_expected[year] = zero(T)
    if year == 1
      pop.expected_recruitment[year] = pop.numbers_at_age[year, 1]
    end

    for age in 1:n_ages
      s = sel(pop.ages[age])
      pop.mortality_F[year, age] = fishing_mortality[year, age] * s
      pop.mortality_Z[year, age] = pop.mortality_F[year, age] + pop.mortality_M[year, age]

      if year > 1 && age == n_ages
        pop.numbers_at_age[year, age] =
          pop.numbers_at_age[year - 1, age - 1] * exp(-pop.mortality_Z[year - 1, age - 1]) +
          pop.numbers_at_age[year - 1, age] * exp(-pop.mortality_Z[year - 1, age])
      elseif year > 1 && age > 1
        pop.numbers_at_age[year, age] =
          pop.numbers_at_age[year - 1, age - 1] * exp(-pop.mortality_Z[year - 1, age - 1])
      end

      pop.biomass[year] += pop.numbers_at_age[year, age] * pop.weights_at_age[year, age]
      pop.spawning_biomass[year] +=
        pop.numbers_at_age[year, age] *
        pop.weights_at_age[year, age] *
        pop.maturity_at_age[year, age] *
        pop.proportion_female[age]

      total_mortality = positive_guard(pop.mortality_Z[year, age])
      harvest_fraction =
        pop.mortality_F[year, age] / total_mortality *
        (one(T) - exp(-pop.mortality_Z[year, age]))
      pop.catch_numbers_at_age[year, age] =
        pop.numbers_at_age[year, age] * harvest_fraction
      pop.catch_expected[year] +=
        pop.catch_numbers_at_age[year, age] * pop.weights_at_age[year, age]
      pop.index_expected[year] +=
        catchability * pop.numbers_at_age[year, age] * s * pop.weights_at_age[year, age]
    end

    if year < n_years
      expected_recruitment = rec(pop.spawning_biomass[year], phi_0)
      if year <= length(recruit_devs)
        expected_recruitment *= exp(recruit_devs[year])
      end
      pop.expected_recruitment[year + 1] = expected_recruitment
      pop.numbers_at_age[year + 1, 1] = expected_recruitment
    end
  end

  pop
end

end
