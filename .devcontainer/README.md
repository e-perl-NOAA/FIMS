# FIMS development environments

The developer and user containers provide R and Julia 1.10. Open the repository
in VS Code Dev Containers or GitHub Codespaces and select either configuration.
The post-create command installs FIMS's R dependencies and prepares the Julia
bridge in a writable per-user cache. Initial setup requires internet access.

FIMS itself no longer needs a C++ compiler, Rtools, TMB, CMake, or Doxygen.
Third-party packages may still require system libraries when installed from
source; the Rocker image and R package feature handle those dependencies.

For a local installation, install R and Julia, install FIMS, then run
`FIMS::setup_julia()`. Set `JULIA_HOME` to Julia's bin directory if it is not on
PATH. Restart R after changing runtime versions.

Run R tests with `devtools::test()` and Julia tests with
`julia --project=inst/julia/FIMSBackend -e 'using Pkg; Pkg.test()'`.
Set `FIMS_RUN_JULIA_INTEGRATION=true` to include genuine R-to-Julia integration
tests. `RUN_SLOW_TESTS=true` additionally enables long-running estimation cases.
