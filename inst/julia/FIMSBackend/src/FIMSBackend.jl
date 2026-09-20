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

const BACKEND_STATE = Dict{Symbol, Any}(
  :data => nothing,
  :parameters => nothing,
)

function set_backend_input!(data_dict, parameters)
  BACKEND_STATE[:data] = data_dict
  BACKEND_STATE[:parameters] = parameters
  nothing
end

export BevertonHolt,
  BACKEND_STATE,
  DoubleLogisticSelectivity,
  Logistic3DSelectivity,
  LogisticSelectivity,
  PopulationModel,
  Ricker,
  evaluate_nll,
  fit_model,
  set_backend_input!,
  step_population!

end
