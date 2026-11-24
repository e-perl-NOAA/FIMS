# Julia migration completion checklist

Baseline: `c9f23e83`, 2026-11-17. Applies to
[PR #19](https://github.com/e-perl-NOAA/FIMS/pull/19).
The migration is not complete.

## Contract for each "continue" request

1. Read this file and select at least one ready, unchecked item by its ID.
   Name that item before starting. The default next item is **N3**.
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
| Fresh configuration fits | Five bounded two-fleet reference cases pass 419 real-Julia comparisons, including joint growth/selectivity/catchability/recruitment, four random effects, and fixed priors plus priors on coupled recruitment random effects. |
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

- [x] **P3 - Capture fresh matched Julia full fits and compare all outputs.**
  **Depends on:** P1, P2.
  **Done when:** the same protocol produces at least one cold-process run and
  three warm full fits, and fresh results pass the full numerical comparisons
  against P2, including covariance and applicable derived-report SE families.
  Publish timings and an uncertainty/optimization phase-cost breakdown.
  This item can finish even if Julia is slower: it completes the reproducible
  measurement and fresh numerical gate, not the performance release gate.

  **Completed:** 2026-11-23; implementation commits `65ff6f58` and
  `7b6da71c`, measured candidate `7b6da71c`. The unchanged full Julia-only
  benchmark command completed one cold and three fresh-input warm fits
  within the original 7,200-second run-process cap. Controls 10000/10000,
  three restarts, single-thread settings, full-precision P2 starts/input
  checksum, exact Laplace derivatives, and comparison tolerances were
  unchanged. Windows x64, R 4.6.2, Julia 1.10.10.

  **Numerical result:** all four fits converged with maximum absolute fixed
  gradient `9.70785316717349e-10`. Each passed independent native joint/
  marginal objectives, all 78 estimates and parameter SEs, complete
  positive-definite 78-by-78 covariance, and all 32 applicable derived-SE
  families (13,091 rows). Full-precision starting values were identical
  across trials; repeated outputs also passed cold-versus-warm comparisons.
  Backend, coupled-curvature, profiler lifecycle, and 216 real configuration
  comparisons passed before the benchmark.

  **Measured result:** cold process launch to result was 1,235.13 seconds
  (20.59 minutes), with trial wall 1,209.99 seconds. Warm trial walls were
  995.91, 790.36, and 558.92 seconds: median 790.36 (13.17 minutes), mean
  781.73, range 558.92-995.91. Initial profiled joint-curvature
  preconditioning reduced outer work from the first recovery's 170 exact
  gradients/170 conditional solves to 11 gradients/eight solves per trial.
  Marginal uncertainty still requires 98 complete gradients/conditional
  solves; its phase took 830.70 seconds cold and 853.56/683.77/512.03 warm.
  Live snapshots remained available; writing took 117.08 seconds cold and
  23.15/15.01/7.01 warm, included in elapsed times without subtraction.

  **Evidence:** [portable full-precision results and comparison record](../data-raw/benchmarks/julia-full-2026-11-23/comparison.json),
  adjacent input, all four results, phase timestamps and snapshot indices,
  plus [command, environment and phase breakdown](../data-raw/BACKEND_BENCHMARK.md#p3-completed-matched-full-model-gate-2026-11-23).
  Checksums, pointer-free portability, covariance Cholesky decompositions,
  all comparisons and profile-write sums were independently rechecked.
  Raw local artifact `p3-julia-full-03` retains full profiles, logs, and the
  actual bridge Project/Manifest. Optim 1.13.3, ForwardDiff 0.10.39,
  ComponentArrays 0.15.50, Functors 0.5.5, StatsBase 0.34.14.

  **Performance is not accepted:** Julia's warm median is 4.21 times P2's
  187.67 seconds. Both were instrumented on the same shared workstation,
  not interleaved or isolated; the wide Julia distribution is retained.
  P4/P5 and especially P6 remain unchecked. The previous incomplete
  attempts below are historical evidence, not the basis for closing P3.

  **Recovery plan (2026-11-23):** keep the exact P2 workload, starting values,
  restarts, tolerances, and two-hour process budget. First remove expensive
  nested-type rendering from live profiles while preserving sampled function/
  file/line identity and counts. Reuse conditional results only for identical
  outer fixed points; retain a bounded, larger L-BFGS curvature history for
  coupled fixed effects. Verify cache invalidation, analytic derivatives,
  compact-profile lifecycle, and real native-oracle fits before rerunning
  the one-cold/three-warm full-model protocol. Archive all four numerical
  comparisons and phase timings before checking off P3; do not extend the
  cap or treat the earlier partial result as completion.

  **Recovery refinement:** the profiler/cache/history changes at `65ff6f58`
  passed real configuration regressions and preserved passing full cold and
  warm results, but the warm trial still took 2,157.16 seconds. The partial
  second warm trial was stopped rather than exceed the retained cap.
  [Both completed trials and phase costs](../data-raw/benchmarks/julia-full-recovery-2026-11-23-incomplete/comparison.json)
  are preserved. Precondition the remaining outer search with initial-mode
  profiled joint curvature; retain exact Laplace derivatives and full
  inferential uncertainty, verify the coupled-curvature oracle and real
  configurations, then repeat the complete protocol.

  **Blocked attempt:** 2026-11-23; evidence commit `a283b28c`, candidate
  `3767cc54`. The documented matched protocol completed one real cold Julia
  fit. All 78 estimates/parameter SEs, complete positive-definite 78-by-78
  covariance, joint/marginal objectives, and all 32 required report-SE
  families (13,091 rows) passed the existing native comparisons. Maximum
  absolute fixed gradient was `9.581246067033161e-9`; starts and input
  checksum matched P2 exactly. No controls or tolerances were relaxed.

  **Why that attempt did not complete P3:** cold process launch to result took 6,161.14
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
  environment, and logs. These are explicitly partial evidence; only the
  final four-fit record above closes P3.

- [x] **P4 - Remove a measured conditional-mode/curvature bottleneck.**
  **Depends on:** P3; conditional on its profiling showing this work is needed.
  **Done when:** one focused change reduces the measured uncertainty-stage
  conditional-solve/curvature cost. Consider using already available fitted
  curvature for initialization/preconditioning, but choose the implementation
  from evidence. Verify coupled random effects, parameter ordering, full-model
  perturbed gradients, and the fresh configuration gates. Demonstrate a
  repeatable improvement in paired, warmed measurements without shifting cost
  into a larger end-to-end regression. A code change alone does not close it.

  **Completed:** 2026-11-23; implementation/measured candidate `b6faa47b`,
  independently exported P3 Julia baseline `47e3ff97`. Reuse fitted random
  joint curvature only as an uncertainty L-BFGS preconditioner. Every
  perturbed mode, random Hessian and exact Laplace gradient is recomputed.
  Starts, optimizer controls/restarts, finite-difference steps, inferential
  covariance and comparison tolerances are unchanged; a failed preconditioned
  uncertainty solve now errors explicitly.

  **Verification:** 260 backend assertions, including coupled/permuted-order
  analytic modes/gradients and the nonconvergence failure path, plus 216
  fresh real R-to-Julia configuration comparisons passed. Both signs of all
  49 full-model uncertainty coordinates passed complete perturbed-gradient,
  mode and objective comparisons; maximum absolute gradient difference
  `1.61546e-9`. All 98 candidate solves were faster: median iterations 17
  to 2, median solve time 0.809876 to 0.227025 seconds, median paired time
  ratio 0.292588, and median allocated bytes 1.320 GB to 0.576 GB.

  **Repeatable full-fit result:** after one excluded cold warm-up per
  implementation, three AB/BA/AB warm pairs took baseline/candidate
  269.49/232.11, 277.47/236.67 and 296.72/264.19 seconds. All complete
  numerical comparisons passed, including full covariance and report SEs.
  The median paired complete-fit reduction was 13.9%; all three pairs
  improved (11.0%-14.7%). Their 98-solve uncertainty stage fell from
  62.04/60.52/61.96 to 19.21/19.13/20.82 seconds. These timers cover the
  entire Julia fit, including uncertainty, but exclude high-level R adapters
  symmetrically; no cost was shifted into an overall regression.

  **Fresh real R full gate:** the unchanged P1 command against P2 completed
  one cold and three original-input warm fits within the 7,200-second worker
  cap. All four passed native joint/marginal objectives, 78 estimates and
  parameter SEs, complete positive-definite 78-by-78 covariance, and 32
  derived-SE families (13,091 rows); maximum fixed gradient
  `9.70785316717349e-10`. Cold process-to-result was 371.14 seconds; warm
  trial walls were 222.58/225.86/229.97 seconds. Windows x64, R 4.6.2,
  Julia 1.10.10, single-thread settings, same shared interactive workstation.
  Timings include live profiling without subtraction.

  **Evidence:** [full-precision probe, paired-fit and real R results](../data-raw/benchmarks/uncertainty-curvature-2026-11-23/comparison.json)
  and [commands, timing boundaries and measured costs](../data-raw/BACKEND_BENCHMARK.md#p4-completed-conditional-solve-improvement-2026-11-23).
  Runtime hashes, all six preserved baseline source files against Git,
  portable artifacts and archive checksums were rechecked. Local artifacts
  `p4-perturbed-gradients-02`, `p4-paired-fits-01`, and `p4-julia-full-01`
  retain complete profiles, logs and dependency provenance. The probe was
  precommit; its runtime source hashes match `b6faa47b`.

  **P6 is still open:** fresh R warm median 225.86 seconds is 1.20 times
  P2's 187.67 seconds, and cold startup remains slower. Native and current
  Julia full runs were on different dates, not interleaved or isolated.
  Do not attribute the much larger historical P3-to-P4 timing drop solely
  to this change; the paired full-fit improvement above is the P4 evidence.
  The remaining third-derivative trace takes about 133 seconds per warm
  full fit and is the next P5 target.

- [x] **P5 - Remove a measured third-derivative trace bottleneck.**
  **Depends on:** P3; conditional on its profiling showing this work is needed.
  **Done when:** one focused improvement reduces the measured exact
  Laplace-gradient trace cost and improves paired warm full-gradient timings.
  Preserve mode sensitivity, analytic/coupled-effect oracles, and existing
  numerical tolerances. Record compilation, allocations, and execution costs;
  do not replace exact derivatives with an undisclosed approximation.

  **Completed:** 2026-11-24; implementation/measured candidate `834eca70`,
  independently exported P4 baseline `7ed8e41d`. Increase only the exact
  trace gradient's bounded differentiation cap from 4 to 16. For 49 fixed
  parameters, ForwardDiff balances to width 13, requiring four rather than
  13 model traversals per random direction. Cross-curvature retains cap 4.
  Exact directional contractions, mode sensitivity, convergence controls,
  perturbations and tolerances are unchanged; no new dependencies.

  **Paired result:** eight alternating-order warm full-gradient pairs at
  the fitted point and three uncertainty perturbations passed all 49
  components with maximum absolute difference zero. All eight trace
  timings improved; median paired trace reduction 33.3%, with median trace
  time 1.1725 to 0.7830 seconds. Complete Laplace gradients, including
  cross-curvature and sensitivity, improved by a median paired 25.7%;
  seven of eight pairs were faster. The slower pair is retained, including
  its higher GC time. Median full-gradient time was 1.5406 to 1.1564 seconds,
  and allocations fell from 4,690,159,680 to 4,144,413,120 bytes (11.6%).

  **Compilation:** first-use baseline/candidate gradients took 23.45/16.07
  seconds including measured compilation of 13.51/14.76 seconds. First-use
  trace timings were 9.06/10.48 seconds; larger chunks do not promise cheaper
  compilation. These are shared-process first-use calls, not independent
  cold processes. All warm compilation/recompilation deltas were zero;
  elapsed times include profiling and GC without subtraction.

  **Verification:** all 263 backend assertions passed, including analytic
  coupled/permuted-order checks and a mode-sensitivity oracle exceeding
  the new trace cap, plus 216 fresh real R-to-Julia configuration comparisons.
  Four fresh full R fits passed independent native joint/marginal objectives,
  all 78 estimates/parameter SEs, complete positive-definite 78-by-78
  covariance and all 32 required report-SE families (13,091 rows).
  Maximum fixed gradient was `9.70785316717349e-10`; original P2 starts,
  controls 10000/10000, three restarts and 7,200-second worker cap were retained.

  **Full-fit timing caveat:** cold process-to-result was 966.02 seconds;
  warm trial walls were 638.78/618.55/641.87 seconds. These slower actual
  timings are retained, not omitted or represented as a full-fit speedup.
  The shared workstation developed memory pressure: a during-run observation
  recorded 386,684 KiB free memory and 74% CPU load. No concurrent agent
  builds/tests/model fits were launched. P4/P5 full runs were not interleaved
  or isolated; these absolute differences do not isolate this code change.
  The paired gradient evidence above establishes P5's narrower improvement.
  **P6 remains unchecked**, requiring a controlled final complete-fit
  comparison rather than extrapolation from gradients.

  **Evidence:** [full-precision pairs, first-use costs and fresh full R results](../data-raw/benchmarks/laplace-trace-2026-11-24/comparison.json)
  and [commands/timing boundaries](../data-raw/BACKEND_BENCHMARK.md#p5-completed-exact-trace-improvement-2026-11-24).
  All six immutable baseline sources were checked against Git; candidate
  runtime hashes, portable archives and checksums were independently verified.
  Local artifacts `p5-gradients-01` and `p5-julia-full-01` retain full live
  profiles, logs and active dependency Project/Manifest. Windows x64,
  R 4.6.2, Julia 1.10.10, single Julia/BLAS thread.

- [x] **P6 - Pass the final matched full-fit performance gate.**
  **Depends on:** P2, P3 and any necessary performance fixes.
  **Done when:** repeat the matched protocol on the candidate containing the
  accepted fixes. Numerical gates still pass and Julia meets the user's
  complete-fit runtime requirement against native. Report cold and warm
  results separately and retain the complete timing distribution, not just
  the best run. Any exception for startup or uncertainty needs explicit user
  agreement. If it is slower, this stays unchecked and further bounded,
  evidence-based performance work is required.

  **Completed:** 2026-11-24, measured implementation `be1af3e5`. Representative
  PrecompileTools workloads cache derivative code across model dimensions;
  private function barriers keep model-layout types out of nested AD tags.
  Year-invariant selectivity and fishing-rate exponentials are evaluated once
  per applicable age or year/fleet, rather than repeatedly inside population
  loops. All parameter-dependent values, exact derivatives, conditional modes,
  covariance and report SEs remain live. The 275 backend assertions and 216
  fresh real R-to-Julia configuration comparisons passed.

  **Complete acceptance:** the unchanged one-cold/three-warm full protocol
  passed all eight numerical fits and all four independent comparisons,
  including original starts, joint/marginal objectives, 78 estimates/SEs,
  positive-definite 78-by-78 covariance and all 32 required report-SE families.
  Native source/DLL identity still matches P2. Controls 10000/10000, three
  restarts, single-thread settings, tolerances, profiling and the 7,200-second
  worker cap are unchanged. No startup or uncertainty exemption was applied.
  Cold process-to-result was **448.54 seconds native / 260.60 Julia**; warm
  walls were native **435.84/387.78/387.34** and Julia
  **172.89/108.18/92.08** seconds. Both measured thresholds passed:
  cold ratio **0.580989**, warm-median ratio **0.278973**.

  **Preparation and limitations:** standalone package preparation took
  **738.66 seconds**, including **717.19 seconds** precompilation with existing
  dependencies. An unprepared first fit pays this cost; it is retained
  separately under the original protocol, not treated as zero. Full-model
  compilation was **28.61 seconds cold / zero in every warm trial**.
  These sequential native-then-Julia batches used a shared Windows host:
  load varied substantially, some CPU samples were unavailable, and native
  timings were slower than earlier attempts. All observations are retained;
  the ratios are measured gate results, not isolated causal speedups or
  guarantees for other machines/configurations. Overall migration is still
  incomplete. Next ready item: **N1**.

  **Evidence:** [complete passing record, eight full-precision results and host telemetry](../data-raw/benchmarks/precompiled-full-2026-11-24/comparison.json),
  [preceding cold-cost attribution](../data-raw/benchmarks/cold-attribution-2026-11-24/comparison.json)
  and [commands, preparation and full timing boundaries](../data-raw/BACKEND_BENCHMARK.md#p6-completed-precompiled-full-fit-gate-2026-11-24).
  Runtime hashes, portable artifacts/checksums, all comparisons, covariance
  Cholesky decompositions, 98 uncertainty solves per fit, profile-write sums
  and cumulative compilation counters were independently verified. Local
  artifact `p6-precompiled-full-01` retains full profiles/logs and the active
  Julia Project/Manifest. Windows x64, R 4.6.2, Julia 1.10.10,
  PrecompileTools 1.2.1. Earlier failed attempts below remain historical evidence.

  **Verified recovery, not acceptance:** candidate `8f8d46fe` prepares typed
  objective data/configuration once and avoids input type erasure and a
  repeated parameter-vector copy. The 271 backend assertions and 216 fresh
  real configuration comparisons passed. Three AB/BA/AB warm complete-Julia-fit
  pairs against immutable `f9593222` took 303.02/151.56, 295.64/152.09 and
  304.29/154.93 seconds baseline/candidate: median paired reduction **49.1%**,
  with **40.7% fewer cumulative allocated bytes**. All complete numerical
  comparisons passed, including covariance, fixed Hessians and parameter/report
  SEs. All 98 uncertainty solves/exact gradients per fit remain. Warm compilation
  was zero; first-use JIT/GC and profiler costs are retained, not subtracted.
  [Full-precision paired evidence](../data-raw/benchmarks/prepared-objective-2026-11-24/comparison.json)
  and [boundaries/command](../data-raw/BACKEND_BENCHMARK.md#p6-recovery-prepared-typed-objective-2026-11-24)
  document that these shared-process Julia timers exclude high-level R adapters
  symmetrically and are not the cold/warm native acceptance gate.

  **Recovery acceptance attempt:** the fresh full `--backend both` protocol
  on `8f8d46fe` passed all eight numerical fits and all four independent
  comparisons. Warm walls were native 179.48/179.75/179.63 seconds and Julia
  159.25/170.82/201.43: medians 179.63/170.82, ratio 0.950955. Cold
  process-to-result was 192.89 seconds native and 372.03 Julia, ratio
  1.928736. **The cold threshold failed; P6 is not complete.** The slower
  third warm Julia trial and shared-host telemetry are retained.
  [Full recovery acceptance evidence](../data-raw/benchmarks/prepared-objective-full-2026-11-24/comparison.json)
  preserves all eight results, unchanged starts/controls/uncertainty outputs,
  source hashes and timing distributions. Native sources/DLL still match P2.

  **Rejected follow-up:** `ef809dd1` kept constant parameter components outside
  nested AD. Although all 281 candidate assertions, 216 real configurations and
  complete numerical pairs passed, shared-process first-use elapsed regressed
  325.91 to 352.26 seconds and compilation 122.20 to 136.73. Three warm pairs
  gave a modest median 6.8% reduction, with one regression. The experiment was
  reverted; production source/tests exactly match accepted `8f8d46fe`.
  [All rejected measurements](../data-raw/benchmarks/constant-components-2026-11-24/comparison.json)
  are retained. At that point, first-use compilation/report/profiler costs
  still needed isolation and no precompilation recovery had been accepted.
  The completed record above supersedes that status without relaxing the
  cold threshold.

  **Not passed:** 2026-11-24, measured candidate `569e01ef` (includes P4/P5).
  The existing full `--backend both` protocol completed one cold and three
  original-input warm fits per backend in separate processes on the same
  day. The preserved native source hashes and DLL exactly matched P2's
  independent `1e5a64a8` oracle. P2 input checksum, 49-fixed/29-random
  layout, controls 10000/10000, three restarts, all uncertainty/report
  outputs, single-thread settings and the 7,200-second worker cap were
  unchanged. No startup or uncertainty exemption was applied.

  **Numerical gate passed:** all eight fits converged with complete
  positive-definite 78-by-78 covariance and all 32 required report-SE
  families (13,091 rows). All four fresh native/Julia comparisons passed
  at existing tolerances, as did cold-versus-warm numerical repetitions.
  Actual full-precision starts matched across both backends and every
  trial. Maximum fixed gradients were `0.000359420286652812` native and
  `9.70785316717349e-10` Julia, both below `1e-3`.

  **Performance gate failed:** native warm trial walls were
  126.78/103.20/111.39 seconds (median 111.39); Julia warm walls were
  329.44/323.99/335.28 seconds (median 329.44), an observed **2.96 times**
  native. Cold process-to-result was 251.86 seconds native versus
  408.97 Julia (1.62 times). Both cold and warm thresholds failed;
  P6 remains unchecked. Preparation was measured separately, not hidden.

  **Conditions and diagnosis:** native ran before Julia in sequential
  batches, not interleaved or isolated. Continuous 30-second aggregate
  host telemetry is retained. The shared workstation had less available
  memory during Julia trials; these timings are an observed rejection,
  not a precise isolated causal speed ratio. No concurrent agent builds,
  tests or model fits were launched, and no unrelated processes were stopped.
  The median Julia warm trial spent 262.17 of 329.44 seconds in the
  marginal uncertainty Hessian, including 98 conditional solves (31.04
  seconds), cross-curvature (74.43) and exact third-derivative traces
  (153.63). The matched native trial's uncertainty stage took 91.83
  seconds. Julia warm snapshot writes took only 3.35-3.53 seconds,
  included without subtraction: profiler formatting alone cannot close
  this gap.

  **Next bounded work:** reduce repeated exact marginal-curvature work,
  verifying full perturbed gradients/covariance and paired complete-fit
  measurements before another P6 attempt. Retain the native oracle,
  original workload and tolerances; do not skip uncertainty, substitute
  saved fits, extend the process cap, or claim acceptance from gradient
  improvements. A quieter/reserved host would improve attribution but
  is not evidence that the present implementation passes.

  **Evidence:** [fresh native/Julia results, timing decision and host telemetry](../data-raw/benchmarks/final-performance-2026-11-24/comparison.json)
  and [command, distributions and phase breakdown](../data-raw/BACKEND_BENCHMARK.md#p6-final-performance-attempt-not-passed-2026-11-24).
  All eight full-precision results, input, phase timestamps and host
  samples are portable and checksummed. Runtime source hashes, starts,
  Cholesky decompositions, report families, native comparisons and profile
  write sums were independently verified. Local artifact
  `p6-matched-full-01` retains full logs/profiles/dependency provenance.
  Windows x64, R 4.6.2, Julia 1.10.10, Intel i7-1365U, Balanced power.

## N. Remaining representative configuration gates

These are gaps in **integrated independent numerical evidence**, not claims
that all the listed features are missing implementations. Existing tests
remain useful and must be reused.

- [x] **N1 - Capture an independent random-effect-prior reference.**
  **Depends on:** none; requires the preserved native oracle environment.
  **Done when:** a bounded model with multiple coupled random effects has
  an independent reference incorporating a prior inside the joint objective,
  conditional random-mode solve, and random Hessian/Laplace adjustment.
  Store nonoptimal points, optimized results, and uncertainty with a
  reproducible generator/provenance. Adding a prior only after native
  marginalization is invalid for this item.

  **Completed:** 2026-11-24, implementation/reference commit `0c6787b1`.
  The five-year/two-fleet EWAA reference estimates
  six fixed and four coupled recruitment random effects. Two cases preserve
  all six existing fixed-effect priors; one additionally targets `log_devs`
  in years 2 and 4 with identity-scale normal priors. Independent R densities,
  scores and curvature augment the historical native **joint** TMB tape
  before solving modes or calculating the Laplace adjustment.

  **Verification:** both cases retain two nonoptimal fixed points, conditional
  modes/scores, native/prior random Hessians, joint/marginal objectives,
  gradients/reports and optimized uncertainty. Complete 10-by-10 covariance is
  positive definite, with 32 report-SE families (2,216 rows). Fixed gradients
  are below `1e-3`; random-mode residuals are below `6e-13` at the optima.
  Native-curvature marginal scores agree with independently re-solved
  marginal-value differences to less than `9e-10`; halved derivative steps
  change Hessian entries by less than `1.3e-8`. The fixed-prior control also
  reproduces the existing native configuration reference. Adding the prior
  only after marginalization is explicitly disproved by a 4.3015342 objective
  discrepancy and a 0.180096 mode shift.

  **Reproduction and provenance:** two fresh native-only R processes generated
  byte-identical pointer-free fixtures, MD5 `d4d40b794b74d47a3eed6bfb948a8bbe`.
  The loaded historical DLL matches `7791104ab1295dcec1725062eb5f1f0a`;
  declared revision `1e5a64a8`, native R-source hashes, input/generator hashes,
  R 4.6.2, TMB 1.9.21 and optimizer controls are stored. The existing R backend
  regression file passes, including the 30 new R-only reference consistency
  assertions. N1 deliberately skipped real-Julia tests; N2 below supplies that
  separate comparison.
  No production backend changes, native compilation or Julia-generated
  expectations were introduced.

  **Evidence:** [reproducible generator](../data-raw/generate_native_random_prior_oracle.R),
  `tests/testthat/fixtures/native-random-prior-oracle.rds`,
  [method and regeneration commands](../tests/testthat/fixtures/native-backend-oracle.md#independent-random-effect-prior-reference-n1),
  and the fixture-consistency test in `tests/testthat/test-julia-backend.R`.
  Local logs `n1-generate-final.log`, `n1-reproduce.log` and
  `n1-r-backend-tests.log` retain execution details. N1 supplied the expectations
  for N2 below.

- [x] **N2 - Pass the real-Julia random-effect-prior gate.**
  **Depends on:** N1.
  **Done when:** a committed real-bridge regression passes the configuration
  gate against N1, including changed conditional modes and covariance.
  Verify prior targeting/scales and preserve any applicable fixed-effect
  priors. The existing uncoupled Gaussian and fixed-effect-prior checks alone
  do not close this item.

  **Completed:** 2026-11-24, regression/documentation commit `8a6cefed`.
  The existing real configuration test now compares N1's fixed-prior control
  and random-prior assessment alongside the three earlier reference cases.
  Both new cases estimate six fixed and four coupled recruitment random
  effects; all six fixed priors are preserved, and random priors target years
  2 and 4 on the identity log-deviation scale.

  **Verification:** a fresh R 4.6.2 process with explicitly selected Julia
  1.10.10, single-thread settings and `FIMS_RUN_JULIA_INTEGRATION=true`
  passed **419 assertions across five optimized fits and ten nonoptimal
  fixed points**, without failures, errors or skips. Comparisons include
  prior targeting/distributions/scales, independent joint scores,
  conditional modes, prior contributions, joint/marginal objectives and
  curvature, convergence, estimates, complete covariance and 32 derived-SE
  families. Removing only the random priors at the same augmented mode
  recovers native random curvature; paired cases match the native changes
  in modes, curvature and optimized covariance.

  **Integrity:** native fixture MD5 remains
  `d4d40b794b74d47a3eed6bfb948a8bbe`; no expectations were regenerated,
  tolerances relaxed, or production backend/performance controls changed.
  The full R backend regression file also passes separately with its five
  opt-in bridge tests skipped; those mocked/R-only checks are not counted as
  real numerical evidence. The existing real-integration CI paths include
  the expanded gate; no remote CI was monitored.

  **Evidence:** the test `real Julia joint configurations retain native
  gradients and uncertainty` in `tests/testthat/test-julia-backend.R`,
  the immutable N1 fixture, and
  [comparison details and local command](../tests/testthat/fixtures/native-backend-oracle.md#real-julia-comparison-n2).
  Local `n2-real-gate.R`, `n2-real-gate.log`,
  `n2-real-gate-results.rds` and `n2-r-backend-tests.log` retain the selected
  real run and separate R regression details. The next ready item is **N3**.

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
