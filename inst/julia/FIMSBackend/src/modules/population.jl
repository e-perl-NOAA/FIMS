module Population

using ..Recruitment: BevertonHolt, Ricker

export PopulationModel, spawning_biomass_per_recruit, step_population!

positive_guard(x) = x + oftype(x, sqrt(eps(Float64)))

Base.@kwdef mutable struct PopulationModel{T <: Real, A <: Real, W <: Real, M <: Real}
  ages::Vector{A}
  weights_at_age::Matrix{W}
  maturity_at_age::Matrix{M}
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
  catch_numbers_at_age_by_fleet::Array{T, 3}
  index_numbers_at_age_by_fleet::Array{T, 3}
  catch_expected_by_fleet::Matrix{T}
  index_expected_by_fleet::Matrix{T}
end

function spawning_biomass_per_recruit(pop::PopulationModel{T}) where {T <: Real}
  n_ages = length(pop.ages)
  n_ages >= 2 || throw(ArgumentError("spawning biomass per recruit requires at least two ages."))

  numbers_per_recruit = fill(one(T), n_ages)
  for age in 2:(n_ages - 1)
    numbers_per_recruit[age] =
      numbers_per_recruit[age - 1] * exp(-pop.mortality_M[1, age - 1])
  end
  numbers_per_recruit[end] =
    numbers_per_recruit[end - 1] * exp(-pop.mortality_M[1, end - 1]) /
    (one(T) - exp(-pop.mortality_M[1, end]))

  sum(
    numbers_per_recruit[age] *
      pop.proportion_female[age] *
      pop.maturity_at_age[1, age] *
      pop.weights_at_age[1, age] for age in 1:n_ages
  )
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
  fleet_selectivity = Array{T, 3}(catch_data[:fleet_selectivity])
  catchability = T.(collect(get(catch_data, :catchability, ones(T, size(fishing_mortality, 2)))))
  phi_0 = T(get(catch_data, :phi_0, spawning_biomass_per_recruit(pop)))
  recruit_devs = T.(collect(get(catch_data, :log_recruit_devs, zeros(T, max(n_years - 1, 0)))))
  log_recruitment = T.(collect(get(catch_data, :log_recruitment, zeros(T, max(n_years - 1, 0)))))
  recruitment_mode = string(get(catch_data, :recruitment_mode, "log_devs"))
  n_fleets = size(fishing_mortality, 2)

  size(fleet_selectivity) == (n_years, n_ages, n_fleets) ||
    throw(ArgumentError("fleet_selectivity must have one year-age matrix per fleet."))
  length(catchability) == n_fleets ||
    throw(ArgumentError("catchability must provide one value per fleet."))
  recruitment_mode in ("log_devs", "log_r") ||
    throw(ArgumentError("recruitment_mode must be \"log_devs\" or \"log_r\"."))
  expected_process_length = max(n_years - 1, 0)
  length(recruitment_mode == "log_r" ? log_recruitment : recruit_devs) == expected_process_length ||
    throw(ArgumentError("Recruitment process values must provide one value per modeled recruitment year."))

  for year in 1:n_years
    pop.biomass[year] = zero(T)
    pop.spawning_biomass[year] = zero(T)
    pop.catch_expected[year] = zero(T)
    pop.index_expected[year] = zero(T)
    if year == 1
      pop.expected_recruitment[year] = pop.numbers_at_age[year, 1]
    end

    for age in 1:n_ages
      total_fishing_mortality = zero(T)
      for fleet in 1:n_fleets
        fleet_selectivity_value = fleet_selectivity[year, age, fleet]
        fleet_fishing_mortality = exp(fishing_mortality[year, fleet]) * fleet_selectivity_value
        total_fishing_mortality += fleet_fishing_mortality
      end
      pop.mortality_F[year, age] = total_fishing_mortality
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
      total_harvest_fraction = one(T) - exp(-pop.mortality_Z[year, age])
      for fleet in 1:n_fleets
        selectivity_value = fleet_selectivity[year, age, fleet]
        fleet_fishing_mortality =
          exp(fishing_mortality[year, fleet]) * selectivity_value
        catch_numbers =
          pop.numbers_at_age[year, age] *
          fleet_fishing_mortality / total_mortality * total_harvest_fraction
        pop.catch_numbers_at_age_by_fleet[year, age, fleet] = catch_numbers
        pop.index_numbers_at_age_by_fleet[year, age, fleet] =
          catchability[fleet] *
          pop.numbers_at_age[year, age] *
          selectivity_value
        pop.catch_expected_by_fleet[year, fleet] +=
          catch_numbers * pop.weights_at_age[year, age]
        pop.index_expected_by_fleet[year, fleet] +=
          pop.index_numbers_at_age_by_fleet[year, age, fleet] *
          pop.weights_at_age[year, age]
      end
      pop.catch_numbers_at_age[year, age] =
        sum(view(pop.catch_numbers_at_age_by_fleet, year, age, :))
      pop.catch_expected[year] = sum(view(pop.catch_expected_by_fleet, year, :))
      pop.index_expected[year] = sum(view(pop.index_expected_by_fleet, year, :))
    end

    if year < n_years
      mean_recruitment = rec(pop.spawning_biomass[year], phi_0)
      realized_recruitment = if recruitment_mode == "log_r"
        exp(log_recruitment[year])
      else
        mean_recruitment * exp(recruit_devs[year])
      end
      pop.expected_recruitment[year + 1] = realized_recruitment
      pop.numbers_at_age[year + 1, 1] = realized_recruitment
    end
  end

  pop
end

end
