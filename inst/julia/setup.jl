using Pkg
using TOML

VERSION >= v"1.10" || error("FIMS requires Julia 1.10 or later.")
length(ARGS) == 3 || error("Supply the backend directory, R home and R shared library.")
backend, rhome, libr = ARGS
Pkg.develop(path = backend)
Pkg.add(["RCall", "Suppressor"])
# Project-scoped preferences avoid changing the R installation used by another
# environment sharing the same Julia depot.
open(joinpath(dirname(Base.active_project()), "LocalPreferences.toml"), "w") do io
  TOML.print(io, Dict("RCall" => Dict("Rhome" => rhome, "libR" => libr)))
end
Pkg.precompile(; strict = true)
using FIMSBackend
isdefined(FIMSBackend, :evaluate_model) || error("FIMSBackend did not load.")
