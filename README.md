  <!-- badges: start -->
  [![FIMS status badge](https://noaa-fisheries-integrated-toolbox.r-universe.dev/badges/FIMS)](https://noaa-fisheries-integrated-toolbox.r-universe.dev/FIMS)
  [![R-CMD-check badge](https://github.com/NOAA-FIMS/FIMS/actions/workflows/call-r-cmd-check.yml/badge.svg?branch=main)](https://github.com/NOAA-FIMS/FIMS/actions/workflows/call-r-cmd-check.yml)
  [![Codecov test coverage](https://codecov.io/gh/NOAA-FIMS/FIMS/branch/main/graph/badge.svg)](https://app.codecov.io/gh/NOAA-FIMS/FIMS?branch=main)
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
  <!-- badges: end -->

# Overview

> **Cutover in progress:** this branch is not release-ready. Bundled examples
> have been regenerated with Julia, and a complete compiler-disabled
> `R CMD check` passes on Windows. Full-fit performance parity, remaining
> configuration and full-scale workflow coverage, and verification across
> supported platforms remain release gates. See `NEWS.md`.

The [Julia migration checklist](.github/JULIA_MIGRATION_CHECKLIST.md) tracks
the remaining work as bounded items with explicit completion criteria.
The [matched backend benchmark](data-raw/BACKEND_BENCHMARK.md) documents the
separate-process native/Julia harness and its cold/warm timing boundaries.

FIMS is an R package for fitting integrated statistical population-dynamics models to fishery data. Julia implements the population model, likelihood, automatic differentiation, optimization, and uncertainty calculations. The high-level R data, parameter, fitting, and diagnostic interfaces remain available.

If you are new to FIMS, the best place to start is the <a href="https://noaa-fims.github.io/FIMS/articles/fims-demo.html" target="_blank">"Introducing FIMS"</a> vignette.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/NOAA-FIMS/FIMS)

## Installation

A [precompiled version of the latest release](https://noaa-fisheries-integrated-toolbox.r-universe.dev/FIMS) is available from the instance of [R universe](https://noaa-fisheries-integrated-toolbox.r-universe.dev) hosted by NOAA Fisheries Integrated Toolbox. You can install the latest version from GitHub.

```r
# Install the pre-compiled version of the latest release
install.packages(
  "FIMS",
  repos = c(
    "https://noaa-fisheries-integrated-toolbox.r-universe.dev",
    "https://cloud.r-project.org"
  )
)

# Install from source, where you can specify the branch
pak::pak("NOAA-FIMS/FIMS@main")
```

Install [Julia 1.10 or later](https://julialang.org/downloads/), then run:

```r
library(FIMS)
# If Julia is not on PATH, supply its executable explicitly:
# setup_julia(julia = "C:/path/to/Julia/bin/julia.exe")
setup_julia()
```

First setup needs internet access and precompiles the backend and bridge together.
Dependencies are cached in `tools::R_user_dir("FIMS", "cache")`, not in the
installed package. FIMS has no C++ sources, LinkingTo dependencies, or native
compilation step; a compiler, Rtools, TMB, CMake, and Doxygen are not needed to
build FIMS itself. Some third-party R dependencies, including JuliaCall, have
their own compiled code; use binary packages where available.

## Cheatsheet

<a href="https://github.com/NOAA-FIMS/FIMS/blob/main/pkgdown/assets/fims-cheatsheet.pdf"><img src="https://raw.githubusercontent.com/noaa-fims/fims/main/pkgdown/assets/fims-cheatsheet-thumb.png" width="315" height="252"/></a>

## Usage

```r
library(FIMS)
# Load sample data
data("data_big")
# Prepare data for FIMS model
data_4_model <- FIMSFrame(data_big)
# Run the  model with optimization
fit <- setup_default_parameters(data = data_4_model) |>
  initialize_fims(data = data_4_model) |>
  fit_fims(optimize = TRUE)
# Clear memory post-run
clear()
```

## Troubleshooting

### Julia runtime and compatibility

`initialize_fims()` now defaults to Julia and prepares input without starting
the runtime. `fit_fims()` starts Julia on first use. `setup_julia()` lets you
prepare dependencies and diagnose installation separately. Set `JULIA_HOME` to
Julia's **bin directory** to select a runtime, or supply an executable to
`setup_julia()`. Restart R after changing Julia or R versions.

Setup runs in standalone Julia, binds RCall to the selected R installation
using project-scoped preferences,
and strictly precompiles dependencies before embedding Julia. This avoids
installing packages inside an embedded runtime and resolves shared dependencies
in one environment. Startup failures report the underlying error. On Linux,
FIMS loads Julia's bundled libunwind before starting JuliaCall.
First-time preparation precompiles one dependency at a time to limit memory
use; an explicit `JULIA_NUM_PRECOMPILE_TASKS` setting takes precedence.
Preparation also caches representative objective, Laplace-derivative and
report-derivative workloads using Julia's package images. This can take
several minutes after installation or a backend update; run `setup_julia()`
explicitly to perform that work before an analysis. It caches compiled code,
not fitted values or uncertainty results. New model layouts can still require
compilation. Without explicit preparation, the first fit also pays setup
costs. Benchmarks report one-time preparation separately from a fresh-process
first fit with dependencies already prepared.

### Migration and numerical guarantees

The low-level native API has been retired: native module constructors,
`CreateTMBModel()`, mutable parameter vectors, native logging, native distribution
initializers, and `get_fixed()`/`get_random()` are no longer available.
Use `FIMSFrame()`, `setup_default_parameters()`, `initialize_fims()`, and
`fit_fims()`. Refit saved native `FIMSFit` objects before extracting estimates.
The `get_model_output()` JSON now contains `backend`, `estimates`, and `report`;
the native module-ID JSON schema is retired.

Native-versus-Julia comparisons passed for deterministic EWAA and
VonBertalanffySchnute models, narrow catchability fits, and fresh joint
selectivity/catchability/recruitment fits with four random effects. Joint
parametric growth fits also exercise growth-derived length compositions and
normal/lognormal fixed-effect priors using independent native/R oracles.
The real configuration gate also passes independent references with normal
priors on two coupled recruitment log-deviation coordinates, preserving fixed
priors and comparing changed conditional modes, curvature, covariance and
derived-report uncertainty.
Joint DoubleLogistic fits now cover both ascending and descending limbs in two
fleets, with ten fixed and four coupled recruitment random effects. A
native-generated, identifiable reference passes nonoptimal and optimized
comparisons, including the complete covariance and 32 report-SE families.
Static AgeSpecific comparisons cover per-age vectors in both fleets and a
scalar/per-age mixed layout, including identifiable fits with anchored
selectivity, full covariance and report uncertainty. Parameter extraction
uses the serialized data fleet order even when input parameter rows are shuffled.
The saved complete 49-fixed/29-random fit passes native comparisons of estimates,
full covariance and 32 derived-report standard-error families; this saved-fit
check is not a fresh full-fit benchmark. A subsequent
[fresh complete-fit P6 gate](data-raw/BACKEND_BENCHMARK.md#p6-completed-precompiled-full-fit-gate-2026-11-24)
passed both prepared-dependency cold and warm-median thresholds against
fresh native runs. One-time package preparation is reported separately.
Those sequential shared-host measurements are not an isolated speedup or
a performance guarantee for other workloads/platforms. These checks do
not prove every supported combination; the migration remains incomplete.
The historical native implementation and comparison job remain available at
commit `1e5a64a8`; the Julia-only suite retains numerical and analytic regressions.
Do not interpret mocked bridge tests as numerical or real bridge evidence.

Julia retains the native growth smoothing and delta-method conventions. Catch
uses the continuous zero-mortality Baranov limit; multinomial likelihoods do not
perturb probabilities. Hessians must be finite and positive definite: invalid
curvature produces unavailable covariance, never pseudoinverses.
`get_sdreport()` exposes `uncertainty_status` and `pdHess`; its `summary()` method
does not require TMB. Convergence alone does not establish valid uncertainty.
`get_estimates()` includes one `type = "likelihood"` row per likelihood
component, with its log-likelihood in `lpdf`. Profiles include observation,
recruitment-process, and prior contributions without deduplicating equal values.

Curvature and report derivatives are evaluated only for estimable parameters;
constant-parameter rows and columns in the internal joint Hessian are `NaN`
(not calculated). Refits with all parameters held constant evaluate the model
without running an optimizer, allowing profiles of a single-parameter model.
Laplace gradients include the conditional random-mode sensitivity through
implicit differentiation. Marginal curvature uses centered differences of
these gradients rather than repeated finite differences of conditional fits.

Objective `simulate(par, complete = FALSE)` draws observations conditional on
fixed parameters and conditional random-effect modes, using R's RNG and
`set.seed()`. It preserves missing observations and rounds effective composition
sample sizes to integers. It does not sample random effects or priors.
`clear()` releases shared bridge input but does not invalidate existing fits.
Parallel diagnostics use separate R worker sessions rather than forks.
Install the current FIMS version before running them: `pkgload::load_all()` in
the parent session does not update an older package installed for workers.
They prepare dependencies before launching workers and retain the runtime
selected with `setup_julia(julia = ...)`.

If you encounter a :bug:, please file an [Issue](https://github.com/NOAA-FIMS/FIMS/issues) with a minimal reproducible example on GitHub.

If you are uncertain that you have actually encountered a :bug:, are looking for more information, or want to talk about some new ideas please use the [Discussion Board](https://github.com/orgs/NOAA-FIMS/discussions) to post your thoughts. Anyone interested in our project is welcome to join the discussions, this is a place for **all** members of the assessment and open-source software community to ask and answer questions, share updates, have open-ended conversations, and follow along. Please introduce yourself :wave: on the [Introduction Discussion](https://github.com/orgs/NOAA-FIMS/discussions/801).

More information can be found on the <a href = "https://noaa-fims.github.io" target = "_blank">NOAA-FIMS website</a>, particularly on <a href = "https://noaa-fims.github.io/blog/" target = "_blank">our blog</a>.

## NOAA Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an 'as is' basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

Software code created by U.S. Government employees is not subject to copyright in the United States (17 U.S.C. section 105). The United States/Department of Commerce reserve all rights to seek and obtain copyright protection in countries other than the United States for Software authored in its entirety by the Department of Commerce. To this end, the Department of Commerce hereby grants to Recipient a royalty-free, nonexclusive license to use, copy, and create derivative works of the Software outside of the United States.

****************************

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)
