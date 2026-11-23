# Julia migration completion checklist

Baseline: `c9f23e83`, 2026-11-17. Applies to
[PR #19](https://github.com/e-perl-NOAA/FIMS/pull/19).
The migration is not complete.

## Contract for each "continue" request

1. Read this file and select at least one ready, unchecked item by its ID.
   Name that item before starting. The default next item is **P3**.
2. Complete the whole item's "Done when" criteria in that work session.
   Starting a run, collecting an intermediate snapshot, writing a proposal,
   or completing one bullet of an item is not completion.
3. Check off the item only after its result is verified and persistent.
   Add a completion record under it: commit, verification command/environment,
   result, and location of the supporting fixture, benchmark results, or logs.
   Commit/push the checked-off checklist with the completed work.
4. Report the completed ID and its concrete result. Also identify the next
   ready item; do not describe an unfinished release gate as complete.

If later code changes invalidate an item's evidence, rerun its gate or reopen
it explicitly. An old passing run does not establish a newer candidate passes.

Each ordinary continuation must finish **at least one whole item**, not merely
make progress on a large category. Start with a bounded item that can actually
be finished, rather than launching several expensive investigations.
If an item is blocked, record the exact blocker and finish another independent,
ready item where possible. If all ready work is genuinely blocked, say so;
do not manufacture a completion. Do not subdivide a stalled item retroactively
just to claim a checked box.

An item found to be unnecessary needs an explicit `N/A` explanation and
supporting evidence. That disposition does not count as a completed work item
for a continuation.

## Already completed: do not relist as new work

| Area | Verified baseline |
| --- | --- |
| Backend cutover | Julia is the default/sole backend; FIMS native sources, headers, registration, and direct Rcpp/TMB build dependencies have been removed. Third-party dependencies such as JuliaCall still contain compiled code. |
| Examples | Bundled fitted examples have been regenerated using real Julia execution, including the complete 49-fixed/29-random example. |
| Full-model numerical reference | Saved full-model estimates, complete covariance, and 32 derived-report SE families pass independent native comparisons. This is not a fresh full-fit benchmark. |
| Fresh configuration fits | Three bounded two-fleet configurations pass 216 real-Julia comparisons, including joint growth/selectivity/catchability/recruitment, four random effects, and normal/lognormal fixed-effect priors. |
| R compatibility | Live objectives/gradients/Hessians/reports, uncertainty adapters, conditional observation simulation, extraction, and small projection checks exist. |
| Parallel diagnostics | Small single-fixed-effect profiles and retrospectives match between sequential and two-worker execution; current installed worker-package provenance was verified. |
| Windows installation/check | A complete compiler-disabled Windows package check, default vignettes, and PDF manual have passed. A final-candidate recheck is still required below. |
| Recent performance work | Same-mode random curvature is reused, and uncertainty solves start from fitted random modes. A warm Laplace-gradient stage improved from 3.87 to 3.53 seconds with fewer allocations. This does not establish full-fit performance parity. |

## Rules shared by all remaining work

- Preserve the historical native implementation at `1e5a64a8` and the
  independent fixtures. Never generate "native" expectations from Julia.
  Oracle generation belongs in a separate historical native process/checkout,
  not in a reintroduced production native backend.
- Existing comparison tolerances remain unchanged: deterministic objectives
  and reports `1e-8`, nonoptimal gradients `1e-6`, optimized objectives `1e-6`,
  and optimized estimates/covariance/SEs `1e-4`, as applicable to the existing
  tests. Keep stricter existing analytic checks. Fix discrepancies instead of
  weakening thresholds or changing reference values to agree with Julia.
- A **configuration gate** below means an independent, pointer-free reference
  with reproducible provenance plus a real R-to-Julia regression. Exercise two
  nonoptimal points and a fresh identifiable optimized fit. Check joint and
  marginal objectives, gradients, convergence, estimates, positive-definite
  uncertainty, complete active-parameter covariance, and applicable derived SEs.
  Reuse existing test files/helpers and document any structurally inapplicable
  check. Serialization-only, mocked, or saved-fit-only checks do not close it.
- Test representative supported combinations, not an unlimited Cartesian
  product. Do not add new models, public features, or dependencies without the
  required discussion. Do not silently narrow existing support to close a gate.
- Profile expensive runs from the beginning. Keep live phase/progress output
  and periodically persisted sampling snapshots accessible during a run,
  rather than writing the only useful profile at process exit.
- Install the candidate FIMS into an isolated library for multisession tests;
  verify workers use that version. A source-loaded parent can otherwise launch
  workers using an older installed package.
- Do not inspect/monitor remote CI after pushes without the user's explicit
  request. Creating this checklist is not that authorization. Platform items
  require actual host access or an explicitly authorized CI review.
- Do not merge the PR, publish a release, or declare the migration complete
  merely because an intermediate item passes.

## P. Full-fit performance and fresh full-model parity

The release requirement is **complete Julia fits, including uncertainty, no
slower than native C++/TMB, preferably faster**. A faster gradient or a saved
fit is not acceptance evidence.

- [x] **P1 - Build one reproducible matched full-fit benchmark harness.**
  **Depends on:** none.
  **Done when:** one documented command launches native and Julia in separate
  R processes using identical full-model data, full-precision starts, fixed/
  random masks, constants, priors, convergence requirements, and output/SE
  requirements. Include the 49-fixed/29-random reference model, all applicable
  derived SEs, environment metadata, live profiling, and machine-readable
  results. Separate first-use preparation, cold process/JIT, and warm execution;
  do not hide Julia startup costs. Run a bounded smoke case to prove both
  harness branches and failure propagation work. This item delivers the
  executable harness, not a claim of performance parity.

  **Completed:** 2026-11-17; implementation commit `1ef4e451`.
  The [benchmark instructions](../data-raw/BACKEND_BENCHMARK.md) provide
  the single full-model command, separate P2/P3 commands, timing boundaries,
  live diagnostics, and failure semantics.

  **Verification:** ran the documented real smoke protocol with one warm
  repetition, iteration/evaluation limits 400/1000, three restarts, and
  30-second safe-point snapshots on Windows x64, R 4.6.2, Julia 1.10.10,
  and one BLAS/Julia thread. Both cold and warm comparisons passed:
  ten active estimates/SEs, complete 10-by-10 covariance, joint/marginal
  objectives, and all 32 common derived-SE families (2,216 rows).
  Actual serialized starts matched the shared input. Full-case input
  construction separately verified 49 fixed/29 random parameters and
  the 32-family requirement; no full benchmark fit was run for P1.

  **Failure/live-profile checks:** a deliberately nonconverged native fit
  returned worker/controller exit 1; a one-second native preparation timeout
  returned worker exit 124/controller exit 1. Both retained `failure.json`
  without a success summary. Corrupted reference checksums/covariance and
  existing-output overwrite attempts were rejected. Five cold and two warm
  Julia snapshots were retained, including useful snapshots observed before
  process exit. Twenty focused Julia assertions passed, covering same-task
  observer execution/error propagation and coupled Laplace derivatives;
  profiler initialization-failure cleanup and final flushing also passed.

  **Evidence:** [portable smoke record](../data-raw/backend-benchmark-smoke.json);
  raw local session artifacts `p1-smoke-03`, `p1-expected-nonconvergence`,
  and `p1-expected-timeout` retain full-precision results, metadata, logs,
  and profiles. Smoke timings include profiling/JIT overhead and overlapping
  failure-check work; they are not P2/P3/P6 performance evidence.

- [x] **P2 - Capture the matched native full-fit timing baseline.**
  **Depends on:** P1.
  **Done when:** the harness records at least one cold-process run and three
  warm full fits in a consistent environment, with convergence, acceptable
  gradients, valid uncertainty, saved numerical outputs, and phase timings.
  Retain full-precision output and native provenance. An old 5.7-minute run
  with unmatched settings is not a substitute.

  **Completed:** 2026-11-17; evidence commit `8f3b383d`, captured against
  candidate `b83f908f`. Ran the documented native-only full-model command
  with one cold and three warm fits, controls 10000/10000, three restarts,
  unchanged full-precision starts, and no added priors. Environment:
  Windows 11 x64, R 4.6.2, TMB 1.9.21, Intel i7-1365U, Balanced power plan,
  and single-thread settings. The independently preserved native DLL
  fingerprint matched the `1e5a64a8` oracle provenance.

  **Result:** all four 49-fixed/29-random fits converged with maximum absolute
  fixed gradient `0.000359420286652812` (below `1e-3`), valid uncertainty,
  complete positive-definite 78-by-78 covariance, and all 32 required
  derived-SE families (13,091 rows). Warm numerical outputs matched cold
  at existing tolerances. Each trial had four optimization passes and one
  uncertainty pass; all profiles and phase markers were retained.

  **Timings:** cold process launch to result 209.17 seconds; cold trial wall
  198.98 seconds. Warm trial wall times were 199.86, 187.67, and 184.42
  seconds (median 187.67; mean 190.65), including initialization, fitting/
  uncertainty, extraction/validation, and profiling. The host was an
  interactive workstation, not an exclusive timing host; preflight CPU load
  ranged from 19% to 43%. No other FIMS jobs or concurrent agent builds,
  tests, or model fits were launched during collection.

  **Evidence:** [portable baseline record](../data-raw/benchmarks/native-full-2026-11-17/baseline.json)
  and [command/phase breakdown](../data-raw/BACKEND_BENCHMARK.md#p2-native-full-model-baseline-2026-11-17).
  The committed adjacent `input.rds`, four full-precision `result.rds` files,
  and native phase timestamps have verified checksums and no user-specific
  paths. P3 can use this directory directly as `--reference`; reconstructing
  its input reproduces checksum `ad075166d27afabb8dbe224aa73b84c6`.
  Raw local artifact `p2-native-full-01` additionally retains complete logs
  and profiles, including native sampling data observed during uncertainty.
  No fresh Julia full-fit comparison or performance-parity decision has
  been made.

- [ ] **P3 - Capture fresh matched Julia full fits and compare all outputs.**
  **Depends on:** P1, P2.
  **Done when:** the same protocol produces at least one cold-process run and
  three warm full fits, and fresh results pass the full numerical comparisons
  against P2, including covariance and applicable derived-report SE families.
  Publish timings and an uncertainty/optimization phase-cost breakdown.
  This item can finish even if Julia is slower: it completes the reproducible
  measurement and fresh numerical gate, not the performance release gate.

  **Blocked attempt:** 2026-11-23; evidence commit `a283b28c`, candidate
  `3767cc54`. The documented matched protocol completed one real cold Julia
  fit. All 78 estimates/parameter SEs, complete positive-definite 78-by-78
  covariance, joint/marginal objectives, and all 32 required report-SE
  families (13,091 rows) passed the existing native comparisons. Maximum
  absolute fixed gradient was `9.581246067033161e-9`; starts and input
  checksum matched P2 exactly. No controls or tolerances were relaxed.

  **Why this is not complete:** cold process launch to result took 6,161.14
  seconds (102.69 minutes). After the user chose to keep the two-hour cap,
  preserve completed results, and diagnose the slowdown, the partial first
  warm fit was stopped before the limit and process termination verified.
  Zero warm fits completed. There is no four-fit success summary, no warm
  timing distribution, and no P3 or performance-parity completion claim.

  **Measured diagnosis:** outer optimization took 3,870.61 seconds, with
  321 marginal-gradient evaluations and 642 conditional solves. Marginal
  uncertainty curvature took 1,898.72 seconds and required another 98 full
  marginal gradients/conditional solves. Synchronous formatting/writing of
  109 sampling snapshots consumed 2,629.05 seconds overall; this overlaps
  those phase costs and is absent from sampled hot stacks because sampling
  pauses during formatting. Host contention also rose substantially.
  First reduce profiler observer overhead, then investigate duplicated
  conditional solves/near-optimum optimizer work and exact derivative cost;
  preserve the original acceptance criteria when rerunning P3.

  **Preserved evidence:** [attempt record and per-family numerical differences](../data-raw/benchmarks/julia-full-2026-11-23-incomplete/attempt.json),
  adjacent full-precision input/cold result and completed/partial phase
  records, plus [phase/profile diagnosis](../data-raw/BACKEND_BENCHMARK.md#p3-incomplete-attempt-and-diagnosis-2026-11-23).
  Raw local artifact `p3-julia-full-01` retains the full profiles, dependency
  environment, and logs. These are explicitly partial evidence. P3 remains
  unchecked; P4/P5/P6 have not been completed or dispositioned.

- [ ] **P4 - Remove a measured conditional-mode/curvature bottleneck.**
  **Depends on:** P3; conditional on its profiling showing this work is needed.
  **Done when:** one focused change reduces the measured uncertainty-stage
  conditional-solve/curvature cost. Consider using already available fitted
  curvature for initialization/preconditioning, but choose the implementation
  from evidence. Verify coupled random effects, parameter ordering, full-model
  perturbed gradients, and the fresh configuration gates. Demonstrate a
  repeatable improvement in paired, warmed measurements without shifting cost
  into a larger end-to-end regression. A code change alone does not close it.

- [ ] **P5 - Remove a measured third-derivative trace bottleneck.**
  **Depends on:** P3; conditional on its profiling showing this work is needed.
  **Done when:** one focused improvement reduces the measured exact
  Laplace-gradient trace cost and improves paired warm full-gradient timings.
  Preserve mode sensitivity, analytic/coupled-effect oracles, and existing
  numerical tolerances. Record compilation, allocations, and execution costs;
  do not replace exact derivatives with an undisclosed approximation.

- [ ] **P6 - Pass the final matched full-fit performance gate.**
  **Depends on:** P2, P3 and any necessary performance fixes.
  **Done when:** repeat the matched protocol on the candidate containing the
  accepted fixes. Numerical gates still pass and Julia meets the user's
  complete-fit runtime requirement against native. Report cold and warm
  results separately and retain the complete timing distribution, not just
  the best run. Any exception for startup or uncertainty needs explicit user
  agreement. If it is slower, this stays unchecked and further bounded,
  evidence-based performance work is required.

## N. Remaining representative configuration gates

These are gaps in **integrated independent numerical evidence**, not claims
that all the listed features are missing implementations. Existing tests
remain useful and must be reused.

- [ ] **N1 - Capture an independent random-effect-prior reference.**
  **Depends on:** none; requires the preserved native oracle environment.
  **Done when:** a bounded model with multiple coupled random effects has
  an independent reference incorporating a prior inside the joint objective,
  conditional random-mode solve, and random Hessian/Laplace adjustment.
  Store nonoptimal points, optimized results, and uncertainty with a
  reproducible generator/provenance. Adding a prior only after native
  marginalization is invalid for this item.

- [ ] **N2 - Pass the real-Julia random-effect-prior gate.**
  **Depends on:** N1.
  **Done when:** a committed real-bridge regression passes the configuration
  gate against N1, including changed conditional modes and covariance.
  Verify prior targeting/scales and preserve any applicable fixed-effect
  priors. The existing uncoupled Gaussian and fixed-effect-prior checks alone
  do not close this item.

- [ ] **N3 - Pass a jointly estimated DoubleLogistic selectivity gate.**
  **Depends on:** none.
  **Done when:** a bounded multi-fleet case with identifiable ascending and
  descending selectivity parameters passes the configuration gate. Include
  more than one recruitment random effect; do not substitute a Logistic fit.

- [ ] **N4 - Pass the static AgeSpecific selectivity layout gate.**
  **Depends on:** none.
  **Done when:** the supported scalar and per-age layouts have independent
  real-bridge numerical coverage, including fleet ownership, serialization
  order, and report behavior. Include an identifiable optimized per-age case
  with uncertainty; keep confounded effects fixed or use documented priors.
  A standalone Julia logistic calculation is not sufficient.

- [ ] **N5 - Pass the year-by-age AgeSpecific selectivity layout gate.**
  **Depends on:** N4.
  **Done when:** a bounded year-varying case passes the configuration gate and
  detects swapped year/age/fleet indices. Include unequal selectivity layouts
  across two fleets and verify derived-report SE placement.

- [ ] **N6 - Close the alternate VonBertalanffySchnute variability gate.**
  **Depends on:** none.
  **Done when:** identify which variability route the current native fixtures
  cover, then add the missing integrated gate so both two-reference-age SD
  interpolation and six-parameter delta-method variability are covered.
  Exercise growth-derived length compositions, their likelihood/derivatives,
  natural-scale transforms, and uncertainty. Existing unit formulas or
  serialization tests alone do not close the missing route.

- [ ] **N7 - Pass scalar versus age-specific proportion-female parity.**
  **Depends on:** none.
  **Done when:** independent real-bridge comparisons exercise a nonuniform
  age vector as well as a scalar, using an identifiable jointly estimated
  subset. Verify spawning biomass, recruitment feedback, likelihoods,
  parameter mapping, and applicable uncertainty; do not compare only serialized
  vector lengths.

- [ ] **N8 - Pass a heterogeneous-fleet observation gate.**
  **Depends on:** none.
  **Done when:** a bounded case covers different fleet composition coverage/
  bins, missing observations, and supported normal/lognormal observation
  families at their supported per-cell granularity. Pass the configuration
  gate and verify zero missing-row likelihood contributions, composition
  shapes, fleet report quantities, and uncertainty alignment.

- [ ] **N9 - Close the recruitment-variant support gate.**
  **Depends on:** none.
  **Done when:** real independent comparisons cover supported normal and
  lognormal recruitment-process semantics with multiple random effects.
  Resolve the Ricker path currently selected by the R serializer and Julia
  objective: establish historical high-level support and numerical parity,
  or obtain an explicit resolution for a misleading/unsupported support claim.
  Do not silently route it through Beverton-Holt or count a standalone
  distribution identity as integrated recruitment parity.

## W. Larger real R workflows and opt-in tutorials

- [ ] **W1 - Complete a multi-parameter likelihood profile sequentially.**
  **Depends on:** the existing joint-configuration fixture.
  **Done when:** profile three values of one parameter while genuinely
  re-estimating other fixed effects and multiple random effects in a bounded
  joint model. Verify the profiled value is held fixed, nuisance estimates
  change, priors are retained, likelihood components sum correctly, and the
  profile optimum agrees with an independent reference within the grid's
  resolution. Save a reproducible regression and actual outputs.

- [ ] **W2 - Pass the same joint profile through two real R workers.**
  **Depends on:** W1.
  **Done when:** the complete profile output matches W1 at existing
  tolerances, both workers load the installed candidate, and worker cleanup/
  errors behave correctly. The already-passing single-fixed-effect/no-random-
  effect worker test does not close this larger reoptimization case.

- [ ] **W3 - Complete a full-model retrospective peel.**
  **Depends on:** P3, P6.
  **Done when:** run the reference model with zero and one terminal year
  removed through the high-level retrospective workflow. Compare the peeled
  fit to an independent native peel; verify shortened parameter/data layouts,
  objectives, convergence, valid uncertainty, priors where applicable, and
  estimate/year labels. Retain profiles and full-precision outputs.

- [ ] **W4 - Pass full-example projections under two fishing scenarios.**
  **Depends on:** P3.
  **Done when:** extend the full example by five forecast years and run two
  explicit fishing scenarios through the existing high-level workflow.
  Compare supported point forecasts to independent native results and verify
  missing forecast observations do not enter likelihoods, fleet quantities/
  array lengths are correct, and scenario effects have the expected direction.
  Do not introduce a new projection-uncertainty feature to close this item.

- [ ] **W5 - Close the real-fit simulation compatibility gate.**
  **Depends on:** none.
  **Done when:** compare the historical public simulation contract with the
  implemented conditional-observation contract, then add real-fit regressions
  for nonzero normal/lognormal variability, age/length multinomials,
  missingness, changed fixed parameters, `complete`, and R-seed reproducibility.
  Validate distributions with appropriate statistical checks, not identical
  cross-backend random draws. If historical compatibility requires sampling
  random effects or other unsupported behavior, implement it or obtain an
  explicit user-approved compatibility decision; documentation alone cannot
  silently waive it.

- [ ] **W6 - Execute all opt-in fitting chunks in `fims-demo.Rmd`.**
  **Depends on:** P6.
  **Done when:** with `FIMS_RUN_SLOW_VIGNETTES=true`, execute the initial-value,
  AgeSpecific, age-only, and length-only refits on the candidate. Verify fits,
  uncertainty where requested, output extraction, and figures; fix errors
  instead of disabling chunks. Retain per-fit progress/profile evidence.

- [ ] **W7 - Execute the opt-in parametric-growth tutorial.**
  **Depends on:** N6, P6.
  **Done when:** `fims-growth-vonb-schnute.Rmd` executes its real fitting path
  with `FIMS_RUN_SLOW_VIGNETTES=true`; the fit, growth/length outputs,
  uncertainty, and figures are valid. Record the actual runtime and profile.

- [ ] **W8 - Execute the opt-in diagnostics tutorial.**
  **Depends on:** W1, W2, W3, P6.
  **Done when:** `fims-diagnostics.Rmd` executes its actual model fits,
  profiles, retrospectives, and plotting chunks with the opt-in flag.
  Verify extracted outputs and numerical/convergence status; rendering a
  document with the expensive chunks skipped does not count.

- [ ] **W9 - Execute the opt-in projection tutorial.**
  **Depends on:** W4, P6.
  **Done when:** `fims-demo-projections.Rmd` executes its real model-fit and
  forecast-plotting chunks with the opt-in flag. Verify valid fitting outputs,
  forecast dimensions, missingness, and plotted scenarios; retain the run log.

## V. Platform and version compatibility

- [ ] **V1 - Make the claimed support matrix explicit and executable.**
  **Depends on:** none.
  **Done when:** document the representative OS/R/Julia combinations that
  will substantiate the existing claims: R `>= 4.2.0`, Julia 1.10 and later
  supported 1.x releases, and Windows/Linux/macOS. Add missing version-boundary
  CI jobs/commands, including R 4.2 and the current supported Julia 1.x release.
  Keep dependency preparation separate from compiler-disabled FIMS checks.
  Do not raise minimum versions or narrow support without user agreement.

- [ ] **V2 - Verify the Linux real bridge and compiler-disabled check.**
  **Depends on:** V1; authorized Linux execution/CI access.
  **Done when:** the candidate installs and completes real-bridge integration,
  native-oracle comparisons, worker diagnostics, and package checking on Linux
  with FIMS compilation disabled. Record exact versions, commit, job/log
  evidence, warnings/errors/skips, and any resolved platform defects.

- [ ] **V3 - Verify the macOS real bridge and compiler-disabled check.**
  **Depends on:** V1; authorized macOS execution/CI access.
  **Done when:** the equivalent candidate check and genuine integration/
  worker tests pass on macOS, with architecture and runtime versions recorded.
  A standalone Julia job or an uninspected workflow definition is not proof.

- [ ] **V4 - Pass the declared version-boundary bridge cases.**
  **Depends on:** V1; authorized execution on the declared matrix.
  **Done when:** the R 4.2 minimum and current supported Julia 1.x boundary
  cases run actual setup, fitting, live derivatives, uncertainty, and worker
  execution as specified by V1. Retain reproducible results. Windows R 4.6.2
  with Julia 1.10.10 does not prove these other combinations.

## R. Final candidate and release handoff

- [ ] **R1 - Pass the complete final-candidate Windows validation.**
  **Depends on:** all required code changes above; P6 and configuration/workflow
  gates must be complete.
  **Done when:** run the whole standalone Julia suite and full installed R
  regression suite with real integration enabled on the exact candidate.
  Run compiler-disabled source build/install and `R CMD check`, including
  default vignettes and the PDF manual, with zero errors/warnings/notes and
  every skip accounted for. Check absence of native FIMS sources/direct
  Rcpp/TMB dependencies and ensure no generated Manifest is accidentally
  committed. Preserve commands, versions, logs, and candidate commit.

- [ ] **R2 - Reconcile evidence and finish the migration handoff.**
  **Depends on:** all required P/N/W/V items and R1.
  **Done when:** every required item has traceable completion evidence;
  conditional/N/A items have justified dispositions; no failed gate is hidden.
  Update README, NEWS, setup/support documentation, and compatibility notes
  consistently, retaining native-oracle provenance, saved-native-fit refitting
  requirements, and intentional low-level API/JSON changes.
  Only then remove work-in-progress warnings and state exactly which validated
  migration scope is complete. Merging/releasing still requires a separate
  explicit user request.

## Suggested execution order

Start **P1 -> P2 -> P3**, then use the measured profile to choose P4/P5 as needed
and close P6. Independent N items and V1 are ready alternatives when a long run
or external platform access blocks the critical path. Complete W1/W2/W5 on
bounded real models before the expensive full-scale workflows and tutorials.
Finish V2-V4 with authorized platform evidence, then R1 and R2.

This order is not permission to end a continuation with only "a benchmark is
running." Pick and finish a whole ready item, and update this file accordingly.
