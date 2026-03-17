# DSEM in FIMS: First Steps Guide

This guide explains the DSEM additions in FIMS from a **first-time user** perspective.

---

## 1) What was added?

The DSEM integration now includes both:

- **R-side setup** (build settings, prepare data, create TMB inputs), and
- **C++ fitting path** (likelihood evaluation inside the FIMS objective function).

In practical terms, you can now pass a DSEM object to `initialize_fims()` and have it contribute to model fitting.

---

## 2) The high-level workflow

Use DSEM in FIMS with four steps:

1. Build and validate DSEM settings
2. Build DSEM-ready data and TMB inputs
3. Initialize FIMS with `dsem = ...`
4. Fit with `fit_fims()`

```r
library(FIMS)
data("data1")

data_4_model <- FIMSFrame(data1)

parameters <- data_4_model |>
  create_default_configurations() |>
  create_default_parameters(data = data_4_model)

dsem <- build_DSEM(
  sem = NULL,        # default IID SEM will be generated for recdevs
  family = "normal", # recycled to all DSEM columns
  all_vars = FALSE,
  estimate_projection = FALSE
)

dsem_obj <- build_dsem_objects(
  dsem_settings = dsem,
  data = data_4_model,
  env_data = data.frame(Year = 2000:2010, Temp = rnorm(11)),
  n_recdevs = 1
)

fit <- parameters |>
  initialize_fims(data = data_4_model, dsem = dsem_obj) |>
  fit_fims(optimize = TRUE)
```

---

## 3) What each object means

### `build_DSEM(...)`
Creates a simple settings list:

- `sem`: SEM text (`"var1 -> var2, lag, parameter_name, start_value"`)
- `family`: observation family per DSEM variable (`normal`, `bernoulli`, etc.)
- `all_vars`, `estimate_projection`: currently stored and passed along for future extensions

### `build_dsem_objects(...)`
Returns:

- `dsem_settings`: validated settings (with default SEM if needed)
- `dsem_data`: year-aligned data matrix used by DSEM
- `tmb_inputs`: low-level inputs consumed by the C++ DSEM module

`tmb_inputs` contains:

- `options`: controls for latent-state parameterization/scaling
- `RAM`, `RAMstart`: structural mapping and starting values
- `familycode_j`: numeric family codes used in C++
- `y_tj`: observed values by year (`t`) and variable (`j`)
- `parameters`: initial values for `beta_z`, `lnsigma_j`, `mu_j`, `delta0_j`, `x_tj`

---

## 4) What changed in C++ and why

### `inst/include/distributions/functors/dsem.hpp`
Adds `DSEMLikelihood`, which computes:

- latent process contribution (GMRF term), and
- observation likelihood contribution by family.

This is the core DSEM negative log-likelihood contribution added to the FIMS objective.

For first-time users, here is what the main blocks do:

- **Inputs and sizes**
  - `options`, `RAM`, `RAMstart`, `familycode_j`, `y_tj`, `n_t`, `n_j`
  - These come from `build_dsem_objects(...)$tmb_inputs`.
- **DSEM parameters**
  - `beta_z`, `lnsigma_j`, `mu_j`, `delta0_j`, `x_tj`
  - `x_tj` is typically treated as random effects (latent states).
- **`evaluate()` steps**
  1. Build sparse structural matrices from RAM:
     - `Rho_kk` for `->` paths
     - `Gamma_kk` for `<->` paths
  2. Build/invert `(I - Rho)` and optionally rescale for constant marginal variance.
  3. Build latent means/offsets (`mu_j`, `delta0_j`) and latent trajectories (`z_tj`).
  4. Add latent-process GMRF penalty (`jnll_gmrf_dsem`).
  5. Add observation likelihood by family code (`normal`, `bernoulli`, `poisson`, `gamma`, `fixed`).
  6. Return total DSEM log-density contribution (negative of jnll).

### `inst/include/interface/rcpp/rcpp_objects/rcpp_dsem.hpp`
Adds `DSEMDistributionInterface`, the bridge between R objects and the C++ likelihood module.

This class:

- receives `tmb_inputs` values from R,
- registers DSEM parameters / random effects with FIMS information objects, and
- inserts the DSEM density component into the model pipeline.

### Why FIMS uses `.hpp` here instead of an Rceattle-style `.cpp`

In FIMS, distribution components are built as reusable **templated** C++ modules.

- `DSEMLikelihood` is templated as `template <typename Type>`.
- FIMS instantiates this with multiple internal types (standard numeric and AD types).
- For C++ templates, full function definitions must be visible where instantiation happens.

That is why implementation is placed in a header (`dsem.hpp`) in FIMS.  
In contrast, Rceattle uses a monolithic TMB model `.cpp` translation unit pattern, so putting model code directly in `.cpp` is natural there.

### `R/initialize_modules.R`
`initialize_fims()` now accepts optional `dsem`.
When provided, it initializes the DSEM distribution before `CreateTMBModel()`, so DSEM is active during optimization.

---

## 5) Data and SEM rules to remember

- `data` must be a `FIMSFrame`.
- `n_recdevs` must be an integer `>= 1`.
- `env_data` may include `Year`; missing years are padded to model years.
- `family` must have length 1 or match `ncol(dsem_data)`.
- If `sem` is `NULL`, default IID recdev equations are generated.

---

## 6) If the `{dsem}` package is installed vs not installed

- **Installed**: FIMS uses `dsem::dsem(...)` internals to generate `tmb_inputs`.
- **Not installed**: FIMS uses an internal fallback parser/mapper for the same workflow.

This keeps user-facing usage stable while allowing robust operation across environments.
