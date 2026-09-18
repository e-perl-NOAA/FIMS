module FIMSBackend

using ComponentArrays
using ForwardDiff
using Optim
using SparseArrays
using SuiteSparse

include("modules/selectivity.jl")
include("modules/recruitment.jl")
include("modules/population.jl")
include("objective.jl")
include("optimizer.jl")

using .Selectivity: DoubleLogisticSelectivity, Logistic3DSelectivity, LogisticSelectivity
using .Recruitment: BevertonHolt, Ricker
using .Population: PopulationModel, step_population!

export BevertonHolt,
  DoubleLogisticSelectivity,
  Logistic3DSelectivity,
  LogisticSelectivity,
  PopulationModel,
  Ricker,
  evaluate_nll,
  fit_model,
  step_population!

end
