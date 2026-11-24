# FIMS (development version)

* The Julia-only cutover below is work in progress, not release-ready.
  Shipped optimized and internal example fits have been regenerated with
  Julia, including the complete 49-fixed/29-random example with convergence
  and positive-definite uncertainty. Its optimized estimates, full covariance
  and native derived-report standard errors pass saved native comparisons.
  Broader configuration coverage remains outstanding. A complete
  compiler-disabled R CMD check, including real Julia integration tests,
  vignettes and the PDF manual, passes on Windows.
  Release also requires full model fits, including uncertainty, to run no slower
  than native C++/TMB, preferably faster. This performance gate is not yet met.
  Comparisons must use matched data, starting parameters, estimation settings,
  convergence requirements and outputs, distinguishing startup/compilation
  costs from warm execution without weakening numerical parity.
* Julia is now the sole backend. The high-level R workflow remains available;
  low-level native modules, mutable parameter vectors, native logging, and
  native module-ID JSON have been retired. Saved native fits must be refitted.
* FIMS no longer ships C++ sources, headers, registration, native build tooling,
  or direct Rcpp/TMB dependencies. JuliaCall has its own compiled dependencies.
* `setup_julia()` prepares dependencies outside the embedded runtime in a
  writable user cache and configures RCall for the selected R installation.
* Beverton-Holt recruitment uses the native denominator without an added
  numerical offset.
* Laplace derivatives use exact directional trace contractions and capped
  automatic-differentiation batch sizes instead of differentiating a full
  random-effect Hessian. This reduces compilation and allocation costs without
  approximating the derivatives.
  Example-fit regeneration records live phase timings separately from the
  sampling profile saved on exit.
* Laplace gradients reuse the random-effect Hessian calculated at the same
  conditional mode, differentiating only the remaining fixed/random cross
  curvature. Alternating warm probes of this stage on the complete example
  reduced median time from 3.87 to 3.53 seconds and allocations from 5.32 to
  4.69 GB. These probes exclude conditional-mode optimization and startup;
  they do not establish end-to-end or native-versus-Julia performance parity.
  Uncertainty perturbations start their conditional optimizations from the
  fitted random effects rather than the original starting values.
* Outer objective/gradient evaluations reuse conditional modes only at
  identical fixed-parameter points. Outer L-BFGS retains a bounded 10-50
  curvature pairs for coupled fixed effects. Live benchmark profiles omit
  expensive typed method signatures while preserving sampled frame locations
  and counts. Complete-fit performance acceptance remains outstanding.
  Coupled fits precondition outer search directions with positive-definite
  profiled joint curvature at the initial conditional mode; exact Laplace
  derivatives and inferential covariance calculations are unchanged.
  Fresh matched cold and three warm full fits pass the native numerical
  gates. The P3 Julia warm median was 790.36 seconds versus native's 187.67;
  the complete-fit performance requirement is not yet met.
* Marginal-uncertainty conditional solves reuse fitted random-effect curvature
  as an L-BFGS preconditioner. Each perturbed mode, Hessian, and exact Laplace
  gradient is still recomputed; starts and convergence tolerances are
  unchanged. Nonconverged preconditioned uncertainty solves fail explicitly.
  Three paired warm complete fits improved 11%-15%, with full numerical
  comparisons passing. Four fresh real R full fits also pass the native
  gates; P4 warm median was 225.86 seconds against the historical native
  187.67 seconds. This intermediate result did not establish complete-fit
  performance acceptance.
* Exact Laplace trace differentiation uses a bounded chunk cap of 16;
  cross-curvature and other derivative calculations retain their cap of 4.
  The directional trace contraction and conditional-mode sensitivity are
  unchanged; this does not approximate third derivatives.
  Eight warm pairs show a median 33% trace-time reduction and 26% complete
  Laplace-gradient reduction, with identical gradients and 12% fewer
  allocations. Fresh full R fits preserve native numerical parity;
  these gradient measurements alone did not establish complete-fit acceptance.
* An initial P6 same-day full benchmark preserved numerical parity but did not
  pass performance acceptance: Julia/native warm medians were
  329.44/111.39 seconds and cold process-to-result 408.97/251.86 seconds.
  Runs used sequential batches on a shared workstation with continuous
  host telemetry; uncertainty remains the main measured Julia cost.
* Fitted and live Julia objectives prepare normalized, typed data/configuration
  once per objective instead of rebuilding dictionaries at every derivative
  evaluation. Population stepping preserves concrete input types internally
  while retaining dictionary inputs. Parameters and all mode/curvature
  calculations remain live; no parameter-dependent results are cached.
  Complete paired Julia fits improved by a median 49.1%. A fresh full
  native/Julia run met the warm-median threshold (170.82/179.63 seconds),
  but cold process-to-result remained slower (372.03/192.89 seconds).
  P6 stayed open after that attempt; a subsequent cold-regressing constant-component
  experiment was reverted and its measurements retained.
* Representative derivative precompilation reuses Julia package images across
  model dimensions; population evaluation also avoids repeated invariant
  selectivity and fishing-rate exponentials. The unchanged fresh full P6
  protocol now passes numerical, cold and warm-median gates: Julia/native
  cold process-to-result was 260.60/448.54 seconds and warm medians
  108.18/387.78 seconds. All trials and shared-host load variation are retained;
  these sequential measurements do not establish an isolated speedup.
  Package preparation cost 738.66 seconds with existing dependencies, including
  717.19 seconds precompilation, recorded separately rather than hidden.
  The overall migration remains incomplete.
* Julia estimate extraction keeps maturity and selectivity parameters separate
  when their labels overlap, and retains parameter year indices for refits.
  Estimate tables preserve their established columns, annotate age/length bins
  and fleet ownership, and retain fleet-derived quantities and parameter IDs.
  Distribution names and per-year multinomial log-likelihoods retain the
  established R output conventions, including zero likelihood for missing rows.
  Table metadata uses Julia parameter ordering and backend-independent types;
  unused, constant-zero native `log_f_multiplier` placeholders are omitted.
* Bounded `logit(a, b, x)` and `inv_logit(a, b, x)` transformations remain
  available without the native module.
* Objective derivatives avoid materializing report-only arrays. Full reports
  remain available for extraction and uncertainty calculations.
* Real Julia comparison gates now cover joint selectivity, catchability and
  recruitment estimation with four random effects, and joint parametric
  growth estimation with growth-derived length compositions. Independent
  native likelihoods plus R density oracles cover normal/lognormal fixed-effect
  priors and natural-scale growth transforms, including nonoptimal gradients,
  full covariance and 32 derived-report standard-error families.
* Growth-derived age-to-length conversion tensors are reported automatically;
  the retired mutable native report flag is no longer needed.
* Objective simulation uses R's RNG to draw observations conditional on
  parameters and random-effect modes. Uncertainty summaries no longer use TMB.
* Real Julia profile and retrospective regressions compare complete serial
  and two-worker results, including priors and worker cleanup. This bounded
  workflow coverage does not replace full-scale diagnostic runs. Workers need
  the current FIMS package installed, not just source-loaded in the parent.

# FIMS 0.11.0

## Bug Fixes

* *(CatchAtAge)* Build expected length comps from age comp proportions (#1751)
* *(devcontainer)* Add missing comma
* *(fims_likelihood)* Use module_name when selecting the profiled parameter (#1774)
* *(fimsfit)* Name random effects in the sdreport so their standard errors reach get_estimates() (#1773)
* *(get_estimates)* Adds random effect distribution parameters (#1771)
* *(information)* Drop density component links
* *(interface)* Register fleet log_q and maturity parameters in variable_map (#1793)
* *(json)* Keep whitespace inside strings and decode escapes
* *(model)* Clear the TMB objective function pointer after each evaluation (#1766)
* *(output)* Write fleet names and keep infinite values readable (#1770)
* *(selectivity)* Error on a logit_sel_at_age length that does not fit n_ages
* *(setup_default_parameters)* Use the geometric plus group for default initial numbers (#1787)
* *(test)* Update initial values for estimation tests
* *(No Category)* Docs: fix broken relative URLs in adding-new-module vignette
* *(No Category)* File paths were too long for windows

## Documentation

* *(mohns_rho)* Fix sign of Mohn's rho in documentation (#1772)
* *(No Category)* Adds more exploration/explanation to demo

## Features

* *(growth)* Size and growth infrastructure (#1697)
* *(selectivity)* Selectivity at age

## Performance

* *(fit_fims)* Skip the derived-quantity covariance in sdreport (#1775)

## Commit Statistics

- 20 commit(s) contributed to the release.
- 38 day(s) passed between the first and last commit.
- 20 commit(s) parsed as conventional.
- 15 linked issue/PR reference(s) detected in commits.
  - [#1748](https://github.com/NOAA-FIMS/FIMS/issues/1748) (referenced 3 time(s))
  - [#1764](https://github.com/NOAA-FIMS/FIMS/issues/1764) (referenced 2 time(s))
  - [#1556](https://github.com/NOAA-FIMS/FIMS/issues/1556) (referenced 1 time(s))
  - [#1697](https://github.com/NOAA-FIMS/FIMS/issues/1697) (referenced 1 time(s))
  - [#1739](https://github.com/NOAA-FIMS/FIMS/issues/1739) (referenced 1 time(s))
  - [#1751](https://github.com/NOAA-FIMS/FIMS/issues/1751) (referenced 1 time(s))
  - [#1766](https://github.com/NOAA-FIMS/FIMS/issues/1766) (referenced 1 time(s))
  - [#1770](https://github.com/NOAA-FIMS/FIMS/issues/1770) (referenced 1 time(s))
  - [#1771](https://github.com/NOAA-FIMS/FIMS/issues/1771) (referenced 1 time(s))
  - [#1772](https://github.com/NOAA-FIMS/FIMS/issues/1772) (referenced 1 time(s))
  - [#1773](https://github.com/NOAA-FIMS/FIMS/issues/1773) (referenced 1 time(s))
  - [#1774](https://github.com/NOAA-FIMS/FIMS/issues/1774) (referenced 1 time(s))
  - [#1775](https://github.com/NOAA-FIMS/FIMS/issues/1775) (referenced 1 time(s))
  - [#1787](https://github.com/NOAA-FIMS/FIMS/issues/1787) (referenced 1 time(s))
  - [#1793](https://github.com/NOAA-FIMS/FIMS/issues/1793) (referenced 1 time(s))
- 53 day(s) passed between releases.

# FIMS 0.10.0

* Use `setup_default_parameters()` to set up a model
* Specify uncertainty using a formula with a distribution and arguments
* Change time to timing in parameter tibble
* Change value to observed in FIMSFrame
* Rename `get_timing()` to `get_run_time()`
* Change landings to catch everywhere (R and C++)

# FIMS 0.9.4

* Adds likelihood profiles and retrospective diagnostic tools
* Adds priors on derived quantities
* Adds tidy output with yardstick
* Uses .data and .env for dplyr instead of globalVariable()
* Uses translational units to decrease RAM during compile
* Expose proportion_female as a scalar that can be set
* Fixes sanitizing values for JSON
* Fixes naming of phi_0
* Fixes inability to initialize a fleet with index and catch
* Breaking change: "name" to "fleet" in FIMSFrame
* Breaking change: "fleet_name" to "fleet" in output from `get_estimates()`

# FIMS 0.9.3

* Reduce verbose FIMS logging and refine messages
* Cleans up integration tests after switching log_devs to random effects
* Revert changes that eliminated compiler warnings because they were
  causing tests to fail but not R CMD check

# FIMS 0.9.2

* Fixes Rcpp creation of a new Parameter when the input is not valid

# FIMS 0.9.1

* Adds vignette on FIMSFrame and data_big
* Adds logging information to fims-demo and updates the logging vignette to be
  dynamic instead of relying on a saved image
* Adds a vignette on how to add new C++ modules to FIMS
* Adds WHAM-inspired convergence checks to FIMS models
* Relies on SparseNUTS for Bayesian test
* Refactors FIMSFrame plot method to provide a summary of the data

# FIMS 0.9.0

* Adds time-varying weight-at-age
* Adds time-varying selectivity
* Makes recruitment deviations random effects by default when using the wrapper
  functions
* Adds a glossary of mathematical symbols to the doxygen documentation
* Brings doxygen to the pkgdown site
* Fixes hidden bug in `dimension_folded_to_tibble()` in while loop
* Removes get_log_module
* Removes calculation of uncertainty within the C++ code
* Changed package data name to data_big and added helper data
* Changes `m_*()` functions to `model_*()`

# FIMS 0.8.1

* Fixes two bugs in `fit_fims` when getting random effect names and not wanting
  measurements of uncertainty
* Enhance the documentation by adding a Cheatsheet, updating the README,
  increasing information for some functions, added Rcpp training vignette,
  adding additional equations to doxygen

# FIMS 0.8.0

* Allow for projections based on fixed fishing mortality, catches, or in theory
  using priors on any parameter or derived quantity that you want such as
  the ratio of current spawning biomass to initial biomass.
* Fixes create_default_Population() to define age and years for log_M

# FIMS 0.7.1

* Fixes json output when there are non numeric values, infinity values, and -999
* Allows the output columns to be merged with reshape and dplyr when character
  values are combined with strings
* Fixes spawning biomass output in print method to report value
* Fixes get_output() when there is no sdreport with added argument do_sd_report

# FIMS 0.7.0

* Turns on the code for model families that allows for more model types in the
  future than just the catch-at-age model that is currently implemented through
  the use of FisheryModelBase, which is a unified parent class for all model
  families. Moved derived quantities (e.g., numbers at age, spawning biomass,
  catch at age) from Fleet and Population objects into FisheryModelBase.
  Refactored Population and Fleet classes to be trait only objects
* Converts nested list of lists used for model control to a tibble with one line
  per parameter that can be un-nested and nested.
* Increased the documentation of FIMS by using formulas in doxygen, building the
  doxygen on the NOAA-FIMS github.io site instead of its own web page, writing
  more information in the testing README, etc.
* Removes seasonality logic given it was not being used
* Removes date columns in input data in exchange for timing
* Uses {stockplotr} for the figures in the "fims-demo" vignette

# FIMS 0.6.3

* Fixes bugs in fims_math.hpp when using TMBad library to use the standard
  library functions (exp, log, cos, sqrt, pow) when necessary.

# FIMS 0.6.2

* Fixes bug where `unfished_biomass` was not initialized.
* Adds TMBad flag to windows Make file.

# FIMS 0.6.1

* Fixes FIMS log file where the user was not known on certain operating systems.

# FIMS 0.6.0

* Initializes backend code to support model families.
* Returns ungrouped tibble from `get_estimates()`.

# FIMS 0.5.3

* Fix json output to use full stop rather than underscore for names, a bug
  introduced in v0.5.0. Also fixes `reshape_tmb_estimates()` where the splits
  were incorrectly referenced because module_id comes before the label.

# FIMS 0.5.2

* Fixes constructor in ParameterVector to error if the size is too small.

# FIMS 0.5.1

* Fixes fix-pr-commands.yml permissions and to use the parent workflow.

# FIMS 0.5.0

* Implements random effects
* Adds fits tibble to output with `get_fits()`
* Switch to TMBad from CppAD
* Checks that length data has the correct dimension in R
* Adds SB to model output
* Adds README files to the C++ code
* Exports logit functions to R
* Adds capabilities in GitHub actions to document

# FIMS 0.4.0

* Allows for CPUE data and catch within a single fleet and changes the
  composition data to be separate from the catch. If there are catches, 
  compositions are based on F, if you have survey compositions those are scaled
  by q, and you can also have composition data without catch or CPUE and those
  match the population.
* Fixes bug in `finalize()` where variables were going out of scope by using a
  shared pointer and RealVector, which allows for estimates tibble to return
  more. Output is integrated between json and TMB using
  `reshape_tmb_estimates()`, `reshape_json_estimates()`, and
  `reshape_json_derived_quantities()`. ParameterVector are now set using
  `resize()` and `purrr::walk()` rather than `methods::new()`.
* Increases code coverage
  * Restructures R tests using `use_testthat_template()`
  * Starts to use Rcpp::Rcerr instead of Rcpp::Rcout
  * Skips parallel and distribution rcpp test
  * Adds `FIMS_dmultinom()` distribution to match TMB
* Fixes bug in `get_number_of_parameters()`.
* Uses static_cast<Type>([-0-9\.]+) to wrap constant variables.
* Fixes cmake_minimum_required to use a range and updates googletest version.
* Adds minimal fims-demo vignette.
* Removes unused estimated_log_M and estimated_log_init_naa from
  inst/include/interface/rcpp/rcpp_objects/rcpp_population.hpp.
* Adds gdb to the devcontainer.json file.
* Fixes broken model comparison project links.
* Adds dependabot.yml file to update GitHub actions.
* Combine `initialize_comp()` functions.

# FIMS 0.3.0.1

* Pluralism in cli was incorrect in FIMSFrame.
* Composition modules are initialized using the composition times the
  uncertainty, which was failing for -999 values because -999 * uncertainty
  does not equal -999 and was leading to the likelihood being evaluated.

# FIMS 0.3.0.0

* Fits to length data using an age-to-length-conversion matrix, `data1`
  includes the necessary information needed to fit to both ages and lengths.
* Adds C++ ParameterVector to allow for the estimation of time-varying
  parameters.
* Implements R wrapper functions to facilitate
  * creating the input model specifications with `create_default_*()`,
    `update_parameters()`, and `initialize_*()`;
  * adding -999 to the missing fleet, year, age, length, etc. combinations;
  * running the model with a user-supplied argument of n_of_loops, where the
    default is three, to restart the optimizer from the previous run of nlminb;
  * summarizing the output with the `FIMSFit()` function and class.
* Implements a switch for global verbosity within FIMS through the use
  of {cli} messages and warnings.
* Updates the logging system complete with a vignette about how to use it, the
  logging system can be used for both R and C++ errors, warnings, and
  information.
* Creates the initial infrastructure to implement random effects with density
  functions.
* Implements a helper function to get the parameter names from the
  C++ code and populate the results with those names.
* Makes lpdf_vec return 0 if data is missing.

# FIMS 0.2.0.0

* Added a `pkgdown` site for FIMS
* Add code cov tests and site link
* Remove recruitment bias correction and adjustment because we plan to use `TMB` (https://github.com/NOAA-FIMS/FIMS/issues/185)
* Improve logging coverage and separate logs into multiple files
* Put recruitment deviations on the log scale when input
* Report more values with standard errors
* Code cleanup, documentation, and consistency improvements
* Remove rapidjson dependence
* Add `start_year` and `end_year` as slots to FIMSFrame
* Make `log_obs_error` a vector
* Load the Rcpp module upon package install so components don't need to be prefaced by `fims$`
* Refactor vectors to use `fims::Vector` class
* Add Newton steps to FIMS integration test to improve convergence in integration test

# FIMS 0.1.0.0

* Added a `NEWS.md` file to track changes to the package.
