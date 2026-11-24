# Matched native/Julia backend benchmark

This developer harness implements migration checklist **P1**. It does not
establish full-fit numerical or performance acceptance merely by running its
smoke case. The production package remains Julia-only.

## Prerequisites

Use the candidate checkout and its existing R dependencies, `pkgload`, and an
explicit Julia executable. Keep an independently built historical native
checkout/export at revision `1e5a64a8` outside the candidate. It must load
successfully with `pkgload::load_all(compile = FALSE)` in this R version.
Do not restore native dependencies or sources to the candidate package.

The preserved Windows oracle DLL has MD5
`7791104ab1295dcec1725062eb5f1f0a`. The harness verifies that checksum by
default. An independently rebuilt historical DLL requires
`--native-dll-md5 <actual checksum>`; retain its build/source provenance with
the results. An exported native source tree need not contain `.git`: its
declared fixture provenance, loaded DLL checksum, and actual R-source
checksums are recorded separately rather than inventing a verified Git HEAD.

Run from the candidate repository root. Assign these paths for the machine:

```powershell
$Rscript = 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe'
$Julia = 'C:\path\to\julia.exe'
$NativeSource = 'C:\benchmarks\native-oracle'
```

## Commands

Bounded real smoke, including one cold and one warm fit per backend:

```powershell
& $Rscript --vanilla data-raw\benchmark_backends.R --case smoke --native-source $NativeSource --julia $Julia --output C:\benchmarks\smoke-new --warm-runs 1 --iter-max 400 --eval-max 1000 --restarts 3 --snapshot-seconds 30
```

The single matched full-model command, including one cold and three warm fits
per backend, is:

```powershell
& $Rscript --vanilla data-raw\benchmark_backends.R --case full --native-source $NativeSource --julia $Julia --output C:\benchmarks\full-new --warm-runs 3 --restarts 3
```

For checklist P2 and P3, preserve a native-only baseline and then reuse it
without running native again:

```powershell
& $Rscript --vanilla data-raw\benchmark_backends.R --case full --backend native --native-source $NativeSource --output C:\benchmarks\native-new --warm-runs 3 --restarts 3
& $Rscript --vanilla data-raw\benchmark_backends.R --case full --backend julia --julia $Julia --reference C:\benchmarks\native-new --output C:\benchmarks\julia-new --warm-runs 3 --restarts 3
```

Use the same case, iteration/evaluation limits, restarts, and warm-run count
for reference and candidate. Different input/checksum or missing reference
trials fail comparison. Choose a **new output directory** for every command;
existing evidence is never overwritten. Full fits are expensive: the default
timeout is 7,200 seconds **per child process**, including all warm repetitions
in that process, not per individual fit. Set `--timeout-seconds` explicitly
only when a longer run is intended.

Other numeric options are `--iter-max` and `--eval-max` (both default 10,000),
`--restarts` (default 0), `--warm-runs` (default 3, permits 0), and
`--snapshot-seconds` (default 30). Unknown/duplicate/malformed options fail.

## Identical workload and acceptance

The controller writes one pointer-free `input.rds`, which every worker checks
before loading. It contains the same data, full-precision parameter table,
fixed/random masks, constants, priors, controls, restarts, gradient threshold,
and requested derived-family set. Both cases currently use **no additional
priors**; they do not constitute a gate for other prior families.

The full case uses `native-full-model-oracle.rds` and independently saved
full-precision native estimates as starts, with **49 fixed and 29 random**
parameters. The smoke case uses the existing two-fleet `EWAA-joint`
configuration, with **six fixed and four random** parameters. Existing unused
placeholder rows/values are preserved; active starting values must be finite.
Every trial rebuilds from that shared input, not the previous fitted result.
The actual backend-serialized starts are checked against the shared table.

Every successful timing requires optimizer convergence code zero, a finite
fixed-effect gradient with maximum absolute value below `1e-3`,
positive-definite uncertainty, the complete active-parameter covariance, all
parameter SEs, and all **32 applicable derived-report SE families**.
Both backends request uncertainty with report SEs, not the much larger
derived-report covariance matrix. The historical native `TMB::sdreport` is
traced to enable `getJointPrecision` in its normal, first uncertainty pass;
uncertainty is **not rerun** just to extract the complete covariance.
Native estimates/SEs come from raw summaries, not rounded JSON output.

For paired/reference runs, compare joint and marginal objectives (`1e-6`),
optimized estimates, parameter SEs, the complete covariance, derived values,
and derived SEs (`1e-4`), using the existing optimized-fit tolerances.
Parameter/derived metadata keys determine alignment, not incidental ordering.
Each warm trial is compared with the corresponding native warm trial.
Convergence and gradient acceptance must pass independently on both sides.
The harness does not compare optimizer iteration counts or require identical
optimization algorithms. Julia-only derived rows (such as
`spawning_biomass_ratio`) are retained separately in `additional_derived`,
not mislabeled as covered by the native 32-family comparison.

## Timing boundaries

Each backend has separate R **prepare** and **run** child processes; native
and Julia FIMS namespaces are never mixed. The children source the explicitly
selected package checkout, so an older installed FIMS cannot silently replace
the candidate. BLAS/OpenMP/Julia thread environment variables are set to one.

- `preparation.json` records package loading and, for Julia, `setup_julia()`
  dependency/bridge preparation. Native uses a preexisting DLL; its build time
  is explicitly **not measured**, not reported as zero. Existing dependency
  caches are reused; this is not a clean-depot Julia installation benchmark.
- `julia/package-preparation.toml` retains the last successful standalone
  setup's dependency-resolution, package-precompilation and backend-loading
  elapsed times. This preserves the representative derivative workload's
  original preparation cost even when the later benchmark prepare process
  reuses that cache. Preparation is not free: an unprepared first fit pays it.
- `run-environment.json` records package/bridge load/setup time in the fresh
  run process. The first cold fit still pays its own model JIT compilation.
- `cold/timing.json` includes `cold_process_to_result_seconds`, starting before
  R process launch and ending after fitting, uncertainty, extraction,
  validation, and profiler finalization. Startup is not hidden in a warm fit.
- Every trial records initialization, complete `fit_fims()` work, extraction/
  validation, profiler setup/finalization, and full trial wall time. Julia
  additionally reports synchronous snapshot-writing time. Cold process wall
  time already includes these components; do not add them a second time.
- Warm repetitions stay in the same backend process but use fresh model
  inputs. Explicit garbage collection occurs **between** trials, outside
  their timers. Full cold-process elapsed time includes earlier process work.

These are **instrumented timings**. R sampling is enabled for both backends;
Julia additionally collects Julia stack samples and writes safe-point
snapshots. Recorded snapshot-writing time is not a complete calibration of
profiling overhead and is not subtracted from elapsed time. Use consistent
settings, an otherwise quiet host, and the complete distribution for later
performance decisions. A smoke runtime is never the full-fit performance
release gate.

## Live diagnostics and output

While a worker is running, inspect its backend `progress.tsv` and, for Julia,
the trial's `optimizer.progress` plus `julia-profile` directory:

- Numbered `snapshot-000001.txt`, etc. are retained independently, and
  `latest.txt` provides the latest completed sampling window.
- `snapshots.tsv` records stage, timestamp, raw sample entries, and write cost.
  Windows are cleared after persistence to bound sampling-buffer use; a full
  buffer fails explicitly rather than silently dropping samples.
- `compilation.tsv` records cumulative compilation, recompilation and GC
  seconds at every checkpoint, independently of the snapshot interval.
  Recompilation is a subset of compilation; these counters and snapshot
  writing overlap elapsed phase times. Do not sum or subtract them when
  deciding complete cold/warm acceptance.
- Julia frames retain function, file, line, and sample counts, but omit typed
  method signatures when rendering. Formatting deeply nested differentiation
  signatures can dominate the measured fit; snapshot costs remain recorded.
- Snapshots run **synchronously on the optimizer's Julia task** at the first
  checkpoint after the requested interval, plus start/completion snapshots.
  Long non-yielding JIT/AD operations can delay them: the interval is not a
  hard real-time guarantee. This avoids unsafe R calls from background tasks.
- `Rprof.out` captures R call stacks, not internal C++ instruction stacks.
  Worker stdout/stderr is retained in `<backend>-<phase>.log`; on Windows
  redirection can lock that log until process exit. The separately flushed
  progress/snapshot files are the live diagnostics.

The output root contains `config.rds`, `input.rds`, and `protocol.json`
(checksums/workload), phase logs, and `summary.json` only after successful
workers and required numerical comparisons. Backend directories contain
environment/provenance JSON, `preparation.json`, `progress.tsv`, `status.json`,
and `cold`/`warm-N` trial directories. Each successful trial includes
`timing.json` and pointer-free `result.rds` with full-precision estimates,
starts, covariance, gradients, reports, and derived values/SEs.
The Julia run also preserves its actual active Project/Manifest and BLAS
configuration/thread count, not just the Julia version.

`summary.json` deliberately reports `performance_parity_established: false`:
the harness verifies outputs, not the P6 runtime acceptance decision.
A worker failure/timeout or comparison failure produces a nonzero controller
exit and `failure.json`; already written diagnostics/results remain available.
There is no success-shaped fallback for a nonconverged or invalid fit.

For an intentional convergence-failure smoke, use `--backend native`,
`--warm-runs 0`, `--iter-max 1`, `--eval-max 1`, and `--restarts 0` with a
fresh output directory. It must fail rather than record a successful timing.

The checked-in [P1 smoke evidence](backend-benchmark-smoke.json) records the
bounded real run and failure checks. It is not a P2/P3 full-model benchmark.

## P2 native full-model baseline: 2026-11-17

The [baseline record](benchmarks/native-full-2026-11-17/baseline.json) retains
the complete distribution, environment/source fingerprints, phase costs,
R-level profile summaries, and artifact checksums. The adjacent `input.rds`
and four `native/<trial>/result.rds` files are byte-for-byte copies of the
full-precision native harness outputs, not regenerated Julia expectations.
The native phase timestamps are retained as `native/progress.tsv`.

Captured against candidate `b83f908f`, using the full native-only command
above: 49 fixed/29 random parameters, no added priors, controls 10000/10000,
three restarts, one cold trial, and three fresh-input warm repetitions.
All four trials converged with maximum absolute fixed gradient
`0.000359420286652812`, valid uncertainty, complete positive-definite
78-by-78 covariance, and 32 derived-SE families covering 13,091 rows.
Warm outputs also matched the cold output at the existing comparison
tolerances. Each trial performed four optimization passes and one uncertainty
pass; uncertainty was not rerun for extraction.

| Trial | Initialize (s) | `fit_fims` (s) | Optimization (s) | Uncertainty (s) | Extract/validate (s) | Trial wall (s) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | 14.35 | 178.81 | 9.04 | 167.74 | 5.79 | 198.98 |
| warm-1 | 15.36 | 178.47 | 9.09 | 166.99 | 5.98 | 199.86 |
| warm-2 | 14.36 | 168.00 | 9.07 | 157.20 | 5.28 | 187.67 |
| warm-3 | 13.35 | 166.17 | 8.78 | 155.50 | 4.89 | 184.42 |

Cold **process launch to result** was **209.17 seconds**; its 198.98-second
trial wall time excludes preceding process/package startup. Warm trial wall
time had median **187.67 seconds**, mean **190.65 seconds**, and range
**184.42-199.86 seconds**. Optimization and uncertainty are components of
`fit_fims`, not additional costs to add to it.

Environment: Windows 11 x64, R 4.6.2, TMB 1.9.21, Intel i7-1365U, Balanced
power plan, and single-thread environment settings. This was an interactive
workstation, not an exclusive timing host; preflight CPU load ranged from
19% to 43%. No other FIMS jobs or concurrent agent builds/tests/model fits
were launched during collection. Retain the distribution and these conditions
for P3/P6 rather than treating the fastest trial as universal performance.
Raw local session artifact `p2-native-full-01` additionally retains the
complete logs and R profiles; native sampling data was readable during
uncertainty calculation.

Use the committed archive directly for P3, without relying on local session
paths or rerunning the native baseline:

```powershell
& $Rscript --vanilla data-raw\benchmark_backends.R --case full --backend julia --julia $Julia --reference data-raw\benchmarks\native-full-2026-11-17 --output C:\benchmarks\julia-p3-new --warm-runs 3 --restarts 3
```

P2 establishes the native baseline only. No fresh Julia full-fit comparison
or performance-parity decision is implied.

## P3 recovery implementation

The recovery keeps the matched inputs, three restarts, optimizer tolerances,
exact derivatives, full uncertainty, and two-hour process budget unchanged.
Live Julia snapshots omit expensive typed method signatures, not sampled
frames. The outer objective and gradient reuse a conditional-mode result only
at an identical fixed-parameter point; changing the point invalidates it.
Uncertainty perturbations retain their separate fitted-mode initializations.
Outer L-BFGS retains `max(10, min(number_of_fixed_parameters, 50))` curvature
pairs, rather than always ten, to accommodate coupled fixed effects without
unbounded history. Random-effect optimization is unchanged.
For coupled fixed/random fits, the initial conditional-mode joint Hessian
also supplies a fixed-effect Schur-complement preconditioner, reused across
outer restarts. It changes search directions, not the exact Laplace objective,
gradients, or final uncertainty. Non-positive-definite or non-finite profiled
curvature disables only this preconditioner with an explicit warning; it is
never substituted for an inferential covariance.

Run the backend regressions and developer-profiler checks together with:

```powershell
& $Julia --project=inst\julia\FIMSBackend -e 'using Pkg; Pkg.test(); include(raw"data-raw\test_benchmark_profile.jl")'
```

Implementation alone does not close P3: a complete one-cold/three-warm
full-model run must pass the native comparisons and retain measured phase
and snapshot costs. The completed run and earlier incomplete attempts are
preserved below.

The [first recovery record](benchmarks/julia-full-recovery-2026-11-23-incomplete/comparison.json)
preserves a passing cold fit and one passing warm fit at `65ff6f58`, before
curvature preconditioning. Cold process-to-result fell to 2,302.61 seconds;
the warm trial took 2,157.16 seconds. Outer optimization required 170 exact
marginal gradients rather than 321, with one conditional solve per evaluated
point instead of two. Cold snapshot writing fell to 296.74 seconds and warm
snapshot writing took 44.35 seconds. Both trials passed all native numerical
comparisons, but this was still too slow for four fits within two hours.
The partial second warm fit was stopped and its raw progress retained locally;
this recovery record is explicitly incomplete, not a P3 success. The shared
host had only 0.43 GiB free memory at one observation, so these are not isolated
paired performance measurements.

## P3 completed matched full-model gate: 2026-11-23

The [comparison record](benchmarks/julia-full-2026-11-23/comparison.json)
archives candidate `7b6da71c`, all four full-precision Julia results, identical
P2 input, phase timestamps, snapshot indices, numerical differences by
family, source/dependency provenance, and artifact checksums. The Julia-only
full command above used the committed native P2 reference, three restarts,
controls 10000/10000, 30-second safe-point snapshots, and the unchanged
7,200-second run-process cap. All four fits completed within that cap.

Each fit converged with maximum absolute fixed gradient
`9.70785316717349e-10` and valid uncertainty. Existing native comparisons
passed for joint/marginal objectives, all 78 estimates and parameter SEs,
complete positive-definite 78-by-78 covariance, and all 32 applicable
derived-SE families / 13,091 rows. Starts reproduced input MD5
`ad075166d27afabb8dbe224aa73b84c6` and were identical between trials.
All warm outputs also passed comparisons against the cold Julia result.
Independent read-back checks repeated these comparisons, covariance
Cholesky decompositions, portable/pointer-free scans, snapshot-write sums,
and artifact checksums.

| Trial | `fit_fims` (s) | Optimization (s) | Joint Hessian (s) | Marginal Hessian (s) | Report SEs (s) | Trial wall (s) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| cold | 1188.00 | 231.16 | 19.69 | 830.70 | 28.81 | 1209.99 |
| warm-1 | 966.60 | 99.95 | 3.42 | 853.56 | 0.16 | 995.91 |
| warm-2 | 771.73 | 82.77 | 2.18 | 683.77 | 0.07 | 790.36 |
| warm-3 | 552.61 | 33.93 | 1.52 | 512.03 | 0.12 | 558.92 |

Cold **process launch to result** was **1,235.13 seconds (20.59 minutes)**,
including preceding process/package startup. Warm trial wall median was
**790.36 seconds (13.17 minutes)**, mean 781.73, standard deviation 218.62,
and range 558.92-995.91 seconds. The machine-readable record also retains
initialization, fitted-mode/report evaluation, covariance assembly, final
gradient, extraction, and profiler setup/finalization costs. Phase values
are components of `fit_fims`, not extra costs to add to it.

The initial joint-curvature preconditioner was enabled in every trial,
costing 21.72 seconds cold and 3.64/3.20/1.06 seconds warm, inside the
optimization phase. Outer optimization required **11 exact gradients and
eight conditional solves** per trial, versus 170/170 in the first recovery.
The marginal Hessian still required **98 full exact gradients and conditional
solves** per trial. This is now the dominant measured remaining cost, not
an omitted uncertainty pass.

Live profiling retained 34/32/26/19 snapshots. Snapshot writing took
117.08 seconds cold and 23.15/15.01/7.01 seconds warm, already included
in the timings. Sampling snapshots were inspected before process exit;
the raw local artifact `p3-julia-full-03` retains full profiles/logs and
the actual active Julia Project/Manifest.

Environment: Windows 11 x64, R 4.6.2, Julia 1.10.10, Intel i7-1365U,
Balanced power, one BLAS/Julia thread. Preflight CPU load was 33% with
4,420,616 KiB free memory. This was the same shared interactive workstation
as P2, on a different date, not an isolated or interleaved timing pair.
No competing agent builds, tests, or model fits ran during collection.
Actual bridge dependencies included Optim 1.13.3, ForwardDiff 0.10.39,
ComponentArrays 0.15.50, Functors 0.5.5, and StatsBase 0.34.14.
The wide distribution is retained rather than selecting the fastest trial.

**P3 is complete; performance acceptance is not.** Julia's warm median is
**4.21 times** the native median of 187.67 seconds. P4/P5 remain available
for measured uncertainty/derivative improvements, and P6 stays unchecked.

## P4 paired uncertainty-curvature benchmark

The candidate reuses the fitted joint Hessian's random-effect block to
precondition the conditional solves used by the marginal uncertainty
Hessian. The factorization is prepared once. Each perturbed point still
optimizes its conditional mode and recomputes its own exact random curvature
and Laplace gradient; fitted curvature is not substituted for perturbed
curvature or inferential covariance. Optimizer tolerances, fixed starts,
outer optimization, finite-difference steps, and the 98 perturbations are
unchanged. Unavailable fitted curvature disables only preconditioning with
an explicit warning.

Preserve the P3 backend before measuring, using a new export directory:

```powershell
git archive --format=zip --output=C:\benchmarks\p4-baseline.zip 47e3ff97 inst\julia\FIMSBackend
Expand-Archive -LiteralPath C:\benchmarks\p4-baseline.zip -DestinationPath C:\benchmarks\p4-baseline
$Baseline = 'C:\benchmarks\p4-baseline\inst\julia\FIMSBackend'
$env:JULIA_HOME = Split-Path $Julia
$env:JULIA_BINDIR = $env:JULIA_HOME
& $Rscript --vanilla data-raw\benchmark_uncertainty_preconditioner.R probe $Baseline C:\benchmarks\p4-probe-new
& $Rscript --vanilla data-raw\benchmark_uncertainty_preconditioner.R fits $Baseline C:\benchmarks\p4-fits-new
```

Both commands enforce a 7,200-second worker cap and refuse output-directory
reuse. They load the independently exported old Julia module and the
candidate in one real Julia process, with identical data and single-thread
settings. They do not mix historical native and Julia R namespaces.
The `probe` command checks both signs of all 49 uncertainty coordinates
against the P3 fitted point, alternating baseline/candidate order and
verifying modes, objectives, and complete perturbed gradients. It records
conditional-solve time, iterations, allocations, and gradient time.
The `fits` command performs one excluded cold warm-up per implementation,
then three warm complete-fit pairs in AB/BA/AB order, comparing objectives,
estimates, full covariance, Hessians, parameter SEs, and report values/SEs.

Complete-fit paired timers cover `FIMSBackend.fit_model`, including all
optimization and uncertainty work, on both sides. They exclude R
initialization, adapters/extraction and between-trial garbage collection;
they are not mislabeled as high-level R process-to-result timings. Live
phase records and compact sampling snapshots remain enabled for both
implementations. Preserve all pairs, source hashes and profiling costs.
Repeat the separate high-level full benchmark against P2 to verify actual
R workflow parity on the changed candidate. A faster isolated solve alone
does not close P4 or the P6 release gate.

### P4 completed conditional-solve improvement: 2026-11-23

Measured candidate `b6faa47b` against the immutable P3 Julia export
`47e3ff97`. All six exported source files were checked against their Git
blobs. The [portable evidence record](benchmarks/uncertainty-curvature-2026-11-23/comparison.json)
includes source/driver fingerprints, dependency versions, the full-precision
98-pair probe and eight complete Julia fits, four separate real R full-fit
results, phase records, snapshot indices and verified artifact checksums.
Raw local artifacts `p4-perturbed-gradients-02`, `p4-paired-fits-01` and
`p4-julia-full-01` retain full sampling snapshots/logs and active dependency
Project/Manifest files. The probe preceded the implementation commit; its
runtime source hashes match the committed candidate. Later changes added
a failure-path test and driver provenance metadata, not numerical changes.

All 98 perturbed modes and complete gradients matched; maximum absolute
gradient difference was `1.61546e-9` (required below `1e-6`).
All candidate solves were faster. Median iterations fell from 17 to 2,
median solve time from 0.809876 to 0.227025 seconds, and median allocated
bytes from 1,320,014,952 to 575,881,480. The median paired time ratio was
0.292588 (70.7% less solve time); these are conditional solves, not full fits.
Coupled/permuted-order analytic checks, explicit failure propagation,
all 260 backend assertions and 216 fresh real configuration comparisons
also passed.

| Warm pair order | Baseline full fit (s) | Candidate full fit (s) | Candidate/baseline | Baseline/candidate uncertainty solves (s) |
| --- | ---: | ---: | ---: | ---: |
| AB | 269.4923 | 232.1094 | 0.861284 | 62.038 / 19.214 |
| BA | 277.4701 | 236.6728 | 0.852967 | 60.521 / 19.130 |
| AB | 296.7172 | 264.1884 | 0.890371 | 61.962 / 20.815 |

These are complete Julia `fit_model` timers with the boundaries above.
All three pairs improved, with a median paired reduction of **13.9%**.
The uncertainty-solve column sums all 98 exact conditional solves inside
each marginal Hessian. Complete-fit allocated memory fell from about
615.54 to 548.80 GiB per warm fit (cumulative allocations, not resident RAM).
All paired objectives, estimates, covariance, fixed Hessians, parameter SEs
and report values/SEs matched at unchanged tolerances.
Excluded first-call warm-ups took 417.17 seconds baseline and 287.76 seconds
candidate; these share a process and are not separate cold-process timings.
Warm paired snapshot writes took 1.65-2.11 seconds, included without
subtraction.

The separate real R command was the existing full benchmark, not the paired
Julia timer:

```powershell
& $Rscript --vanilla data-raw\benchmark_backends.R --case full --backend julia --julia $Julia --reference data-raw\benchmarks\native-full-2026-11-17 --output C:\benchmarks\p4-r-full-new --warm-runs 3 --restarts 3
```

Preparation took 3.83 seconds separately. Cold process-to-result took
**371.14 seconds**, cold trial wall 357.81 seconds; warm trial walls were
**222.58, 225.86 and 229.97 seconds** (median 225.86, mean 226.14).
All four fresh fits passed independent native objectives, all 78
estimates/parameter SEs, positive-definite complete 78-by-78 covariance,
and 32 required report-SE families (13,091 rows). Maximum fixed gradient
was `9.70785316717349e-10`; starts, input checksum, controls 10000/10000,
three restarts and the original 7,200-second worker cap were unchanged.
Cold snapshot writes took 29.19 seconds; warm writes took 1.58-1.92 seconds,
included in elapsed times.

Environment: Windows 11 x64, R 4.6.2, Julia 1.10.10, Intel i7-1365U,
Balanced power, one Julia/BLAS thread. Actual dependencies were Optim
1.13.3, ForwardDiff 0.10.39, ComponentArrays 0.15.50, Functors 0.5.5 and
StatsBase 0.34.14. Preflight before the high-level R run recorded 15% CPU
load and 2,897,964 KiB free memory. This was a shared interactive
workstation, not an exclusive timing host; no competing agent builds,
tests or model fits were launched during collection.

**P4 is complete, not P6.** The current high-level warm median is still
1.20 times P2's 187.67 seconds, and cold startup is slower. P2 and the
current R run were on different dates. Likewise, the larger historical
P3-to-P4 absolute timing drop is not an isolated measurement of this change;
the interleaved pairs above establish its complete-fit improvement.
The median R warm trial still spends 193.15 seconds in the marginal
uncertainty Hessian: 18.19 in conditional solves, 39.86 in cross-curvature
and 133.09 in exact third-derivative traces (nested timings, not extra
costs to add to the parent). P5 targets that remaining trace bottleneck.

## P5 paired exact Laplace-gradient benchmark

The `gradients` mode of the same developer driver measures complete exact
Laplace gradients against an immutable P4 export. Each pair uses identical
conditional modes and random Hessians. Timers include cross-curvature,
mode sensitivity and the exact third-derivative trace, but exclude the
conditional solve symmetrically. Phase timestamps separate cross-curvature
from trace cost; live profiling remains enabled.

```powershell
git archive --format=zip --output=C:\benchmarks\p5-baseline.zip 7ed8e41d inst\julia\FIMSBackend
Expand-Archive -LiteralPath C:\benchmarks\p5-baseline.zip -DestinationPath C:\benchmarks\p5-baseline
$Baseline = 'C:\benchmarks\p5-baseline\inst\julia\FIMSBackend'
$env:JULIA_HOME = Split-Path $Julia
$env:JULIA_BINDIR = $env:JULIA_HOME
& $Rscript --vanilla data-raw\benchmark_uncertainty_preconditioner.R gradients $Baseline C:\benchmarks\p5-gradients-new
```

One first-use call per implementation is recorded separately, including
Julia's cumulative compilation/recompilation timer deltas, elapsed time,
allocations and GC. Eight subsequent alternating-order warm pairs repeat
the fitted point and centered-step perturbations at fixed coordinates 1,
25 and 49. All 49 gradient components must agree within `1e-6`; actual
modes and Hessians must be identical within `1e-12`. Both implementations
run in one process under the unchanged 7,200-second cap. Larger directional
Hessian batches were investigated but did not show a reliable warm benefit;
the candidate changes only the trace gradient's differentiation chunk cap
from 4 to 16. ForwardDiff chooses a balanced actual chunk no larger than
the cap (49 fixed effects use width 13 instead of 4), reducing repeated
model traversals from 13 to four per random direction. Exact derivatives,
directions, starts, mode sensitivity and numerical tolerances are unchanged.
Cross-curvature retains its original chunk cap.

### P5 completed exact-trace improvement: 2026-11-24

Measured candidate `834eca70` against the immutable P4 export `7ed8e41d`.
All six exported Julia source files matched their Git blobs. The
[portable evidence record](benchmarks/laplace-trace-2026-11-24/comparison.json)
preserves full-precision gradient pairs/modes/Hessians, four fresh real R
full-fit results, source/driver/dependency fingerprints, phase timestamps,
snapshot indices and verified archive checksums. Local `p5-gradients-01`
and `p5-julia-full-01` retain complete profiles, logs and dependency files.

All eight warm pairs matched every gradient component exactly (required
maximum absolute difference below `1e-6`), with identical conditional modes
and random Hessians. Trace time improved in all eight pairs: median paired
ratio **0.666584**, a **33.3% reduction**; median trace time was
1.1725 to 0.7830 seconds. Complete-gradient time includes cross-curvature
and implicit-mode sensitivity, not only the improved trace:

| Warm pair | Baseline full gradient (s) | Candidate full gradient (s) | Candidate/baseline |
| --- | ---: | ---: | ---: |
| 1 | 1.650859 | 1.151837 | 0.697720 |
| 2 | 1.503440 | 1.174563 | 0.781250 |
| 3 | 1.522917 | 1.180440 | 0.775118 |
| 4 | 1.550039 | 1.157714 | 0.746893 |
| 5 | 1.564808 | 1.155167 | 0.738217 |
| 6 | 1.582405 | 1.130984 | 0.714725 |
| 7 | 1.522488 | 1.642696 | 1.078955 |
| 8 | 1.531160 | 1.119603 | 0.731212 |

Median paired full-gradient reduction was **25.7%**; seven of eight pairs
were faster. Pair 7 is retained without exclusion: candidate GC took
0.542 seconds versus baseline 0.099 seconds. Median full-gradient elapsed
time was 1.5406 to 1.1564 seconds. Every warm call allocated baseline
4,690,159,680 versus candidate 4,144,413,120 bytes, **11.6% less** cumulative
allocation, not a resident-memory estimate.

First-use baseline/candidate gradients took 23.4547/16.0717 seconds and
allocated 6.120/5.570 GB; measured cumulative compilation deltas were
13.5109/14.7566 seconds, recompilation 0.0252/0 seconds. First-use trace
timings were 9.058/10.482 seconds: the larger trace chunks do not promise
less compilation. First-use calls share a process and are not separate
cold-process comparisons. Warm compilation/recompilation deltas were zero.
All timings include profiling/GC without subtraction; trace intervals are
nested within the complete gradient and must not be added to it.

All 263 backend assertions and 216 fresh real configuration comparisons
passed, including coupled/permuted-order analytic modes/gradients and a
mode-sensitivity oracle with 18 fixed effects, exceeding the new cap.
The unchanged full R command against P2 also completed one cold and three
fresh original-input warm fits with controls 10000/10000, three restarts,
single-thread settings and the 7,200-second run-worker cap. All four passed
native objectives, 78 estimates/parameter SEs, complete positive-definite
78-by-78 covariance and all 32 report-SE families (13,091 rows).
Maximum absolute fixed gradient was `9.70785316717349e-10`.

**These full-fit measurements do not establish a speedup or close P6.**
Preparation took 2.72 seconds separately. Cold process-to-result was
966.02 seconds, cold trial wall 954.17 seconds; warm trial walls were
638.78/618.55/641.87 seconds (median 638.78). They are substantially slower
than P4's historical timings and are retained honestly. During this run,
the shared interactive workstation developed memory pressure: free
physical memory was observed at 386,684 KiB with 74% CPU load; a later
observation recorded 1,297,624 KiB and 60% CPU load. Preflight had recorded
3,411,664 KiB and 18% CPU load. No competing agent builds, tests or model
fits were launched. These are observations, not proof attributing the
entire slowdown to host load; the noninterleaved P4/P5 full runs cannot
isolate a causal code-performance difference.

Warm marginal-Hessian phases took 524.55/510.54/532.87 seconds, including
trace phases of 302.14/299.19/312.21 seconds. Warm profile writes took
11.74-12.96 seconds, cold writes 149.97 seconds, included without subtraction.
Keep P6 open for a final controlled complete-fit gate; do not extrapolate
native-speed acceptance from the paired gradient improvement.

Environment: Windows 11 x64, R 4.6.2, Julia 1.10.10, Intel i7-1365U,
Balanced power, one Julia/BLAS thread. Actual dependencies remained Optim
1.13.3, ForwardDiff 0.10.39, ComponentArrays 0.15.50, Functors 0.5.5 and
StatsBase 0.34.14. P5 is complete at its measured exact-gradient scope;
the migration and complete-fit performance gate are not complete.

## P6 final performance attempt, not passed: 2026-11-24

The final candidate `569e01ef`, containing the P4/P5 improvements, was
measured against a fresh run of the preserved native oracle, not merely
against P2's historical timing. The native DLL and all recorded native
source hashes matched P2 exactly. The existing command was:

```powershell
& $Rscript --vanilla data-raw\benchmark_backends.R --case full --backend both --native-source C:\benchmarks\native-oracle --julia $Julia --output C:\benchmarks\p6-matched-new --warm-runs 3 --restarts 3
```

The native source must be the independently preserved, already-built
`1e5a64a8` oracle with its verified DLL, not a restored production backend.
The [portable P6 record](benchmarks/final-performance-2026-11-24/comparison.json)
contains all eight complete fitted outputs, original input, source and
dependency fingerprints, native/Julia phase records, snapshot indices and
continuous aggregate host telemetry. Adjacent artifacts are checksummed.
Local `p6-matched-full-01` retains full raw logs/profiles and Julia's actual
Project/Manifest. No remote CI was inspected.

All eight 49-fixed/29-random fits converged. The four fresh native/Julia
comparisons passed joint/marginal objectives, all 78 estimates/parameter
SEs, complete positive-definite 78-by-78 covariance and 32 common report-SE
families (13,091 rows), at the unchanged tolerances. Cold-versus-warm
numerical repetitions passed separately within each backend. Actual
full-precision starting values matched between backends and every trial;
input MD5 remained `ad075166d27afabb8dbe224aa73b84c6`.
Maximum absolute fixed gradients were `0.000359420286652812` native and
`9.70785316717349e-10` Julia, both below `1e-3`.

| Complete-fit measurement | Native (s) | Julia (s) | Julia/native |
| --- | ---: | ---: | ---: |
| Cold process-to-result | 251.86 | 408.97 | 1.62 |
| Cold trial wall | 240.01 | 392.99 | 1.64 |
| Warm trial 1 | 126.78 | 329.44 | 2.60 |
| Warm trial 2 | 103.20 | 323.99 | 3.14 |
| Warm trial 3 | 111.39 | 335.28 | 3.01 |
| Warm median | 111.39 | 329.44 | 2.96 |

Warm means were 113.79 seconds native and 329.57 Julia; standard deviations
11.97 and 5.65 seconds. Preparation was separate: native loading/verification
18.97 seconds, Julia setup 3.78 seconds. Native used the preexisting DLL;
native compilation was not timed. Trial-wall timings include initialization,
complete optimization/uncertainty, extraction/validation and profiling.
Cold process-to-result additionally includes process/package/bridge startup
and JIT. No profiling, startup or uncertainty cost was subtracted and no
unrequested exception was granted.

**P6 failed both cold and warm runtime thresholds and remains unchecked.**
The ordinal warm-trial ratios above are not interleaved timing pairs.
Native ran its four-trial batch before Julia's batch on the same shared
interactive workstation. A read-only controller recorded aggregate CPU
load, available physical memory and active benchmark stage about every
30 seconds in `host.tsv`, with per-trial summaries in the evidence record.
Host conditions differed: Julia warm trials had median free memory
944,506/1,073,052/1,112,238 KiB, compared with native
1,630,902/1,809,000/1,825,100 KiB. Median CPU load was
18.5%/18%/17.5% Julia versus 58%/45%/49% native. These samples include each
backend's own load; they do not prove external contention caused the gap.
This is not an isolated causal speed ratio. No concurrent agent builds,
tests or model fits were launched, host settings were not changed and
unrelated processes were not stopped.

| Warm trial 1 phase (nested where indicated) | Native (s) | Julia (s) |
| --- | ---: | ---: |
| Initialization | 18.89 | 11.27 |
| Complete fit call | 105.05 | 317.89 |
| Optimization, including requested passes | 10.60 | 48.88 |
| Marginal uncertainty Hessian (Julia) / uncertainty pass (native) | 91.83 | 262.17 |
| Julia conditional solves within marginal Hessian | N/A | 31.04 |
| Julia cross-curvature within marginal Hessian | N/A | 74.43 |
| Julia exact third-derivative traces within marginal Hessian | N/A | 153.63 |
| Extraction/validation | 2.80 | 0.03 |

The Julia columns for solves/cross-curvature/traces are nested, not extra
costs to add to their parent. Native's uncertainty pass and Julia's
marginal Hessian are not identical internal boundaries; both complete-fit
timers nevertheless include every required covariance/report-SE operation.
Julia still evaluates 98 complete exact gradients/conditional solves
for its centered marginal Hessian. The median Julia warm trial spends
about 80% of total wall time in this phase. Warm snapshot writes took
3.35-3.53 seconds; cold writes took 33.21 seconds, included in all timings.
Profiler formatting alone does not explain or close the remaining gap.

The next performance work should target repeated exact marginal-curvature
calculations, with independent coupled-effect/full-perturbation numerical
checks and paired complete-fit measurements before retrying P6. Preserve
the current gate failure: do not infer acceptance from the earlier faster
gradient probes, omit uncertainty, substitute saved-fit results, or relax
controls/tolerances. A reserved/quieter timing host would improve
attribution, not establish that the current candidate meets the requirement.

Environment: Windows 11 x64, R 4.6.2, Julia 1.10.10, Intel i7-1365U,
Balanced power and one BLAS/Julia thread. Dependency versions remained
Optim 1.13.3, ForwardDiff 0.10.39, ComponentArrays 0.15.50, Functors 0.5.5
and StatsBase 0.34.14. The original 7,200-second worker cap, controls
10000/10000, three restarts and every required native report-SE family
were retained.

## P6 recovery: prepared typed objective, 2026-11-24

Candidate `8f8d46fe` prepares deterministic-key typed data/configuration once
per fitted or live objective, instead of repeatedly normalizing heterogeneous
dictionaries during differentiated evaluations. Population inputs retain
their concrete types; retrieving the parameter element type no longer copies
the entire vector. Parameters, conditional modes, exact derivatives and all
uncertainty/report calculations remain live. Public evaluators still normalize
their inputs. No controls, finite-difference steps or tolerances changed.

The [paired recovery record](benchmarks/prepared-objective-2026-11-24/comparison.json)
preserves all eight full-precision Julia fits, phase timestamps, snapshot
indices, compilation/GC/allocation costs and source/dependency fingerprints.
The six baseline source blobs were checked against Git `f9593222`.
The existing paired `fits` command used that immutable backend export:

```powershell
& $Rscript --vanilla data-raw\benchmark_uncertainty_preconditioner.R fits C:\benchmarks\p6-baseline\inst\julia\FIMSBackend C:\benchmarks\p6-prepared-pairs-new
```

| Warm pair order | Baseline full fit (s) | Candidate full fit (s) | Candidate/baseline |
| --- | ---: | ---: | ---: |
| AB | 303.0247 | 151.5629 | 0.500167 |
| BA | 295.6359 | 152.0910 | 0.514454 |
| AB | 304.2899 | 154.9326 | 0.509161 |

The median paired complete-fit reduction was **49.1%**; all three pairs
improved. Warm medians were 303.0247 seconds baseline and 152.0910 candidate.
Cumulative allocations fell **40.7%**, from about 529.24 to 314.09 GB per
warm fit, not resident memory. Warm compilation/recompilation timer deltas
were zero. Every pair passed unchanged objective, estimate, complete covariance,
fixed-Hessian, parameter-SE and report-value/SE comparisons. All eight fits
converged with positive-definite active 78-by-78 covariance and fixed gradients
below `1e-3`. The 271 backend assertions and 216 fresh real configuration
comparisons also passed.

These are complete Julia `fit_model` timers, including optimization,
uncertainty, GC and live profiling, but excluding high-level R initialization,
adapters/extraction and between-trial GC symmetrically. Both implementations
share a process. Excluded first-use calls took 530.65 seconds baseline and
347.66 candidate, including measured compilation of 144.95/127.03 seconds;
they are **not independent cold-process measurements**. Each warm fit still
performed 98 conditional solves and exact perturbed gradients. Marginal-Hessian
phases fell from 260.68/258.45/266.31 to 132.12/133.00/135.20 seconds.
Warm profile writes took 2.77-3.35 seconds baseline and 1.00-1.12 candidate,
included without subtraction.

Raw local artifact `p6-prepared-pairs-01` retains full profiles/logs and the
active Julia Project/Manifest. Windows x64, R 4.6.2, Julia 1.10.10,
single-thread settings and the original 7,200-second worker cap were retained.
The paired improvement does **not** close P6: acceptance still requires the
separate full R native/Julia protocol, including cold process-to-result and
warm complete-fit thresholds. The original failed P6 evidence above is unchanged.

### Prepared-objective full acceptance attempt: 2026-11-24

The unchanged separate-process `--backend both` protocol on `8f8d46fe`
completed all eight fits. All four fresh native/Julia numerical comparisons,
cold-versus-warm repetitions, identical full-precision starts, complete
positive-definite 78-by-78 covariance and 32 native report-SE families passed.
Controls, restarts, outputs and the 7,200-second worker cap were unchanged.
The [complete acceptance record](benchmarks/prepared-objective-full-2026-11-24/comparison.json)
retains all results, phases, source/dependency hashes and continuous host
telemetry; local `p6-prepared-full-01` retains full raw profiles/logs.

| Complete-fit measurement | Native (s) | Julia (s) |
| --- | ---: | ---: |
| Cold process-to-result | 192.89 | 372.03 |
| Cold trial wall | 182.33 | 359.50 |
| Warm trial 1 | 179.48 | 159.25 |
| Warm trial 2 | 179.75 | 170.82 |
| Warm trial 3 | 179.63 | 201.43 |
| Warm median | 179.63 | 170.82 |

The warm median threshold was met (ratio **0.950955**), but the cold threshold
failed (ratio **1.928736**). **P6 remains unchecked.** All trials, including
the slower third warm Julia fit, are retained. The shared workstation was not
isolated; native ran before Julia, not in interleaved pairs. Available memory
declined during Julia's batch. Missing CPU samples remain explicitly missing
in the archive rather than being imputed. No host settings or unrelated
processes were changed and no competing agent model fits/tests/builds ran.

Cold Julia optimization took 121.09 seconds and marginal uncertainty 148.79;
warm optimization took 19.18-22.96 seconds and marginal uncertainty
117.45-162.72. Cold profile writes consumed 48.22 seconds, warm writes
1.16-1.74, all included without subtraction. The first-use paired measurements
above also identify substantial compilation cost. Further work must reduce
first-use compilation and differentiated computation rather than exempt
startup or move unreported work outside the timer.

### Rejected constant-component experiment: 2026-11-24

Candidate `ef809dd1` preserved inactive parameter components outside nested
AD using typed parameter readers, kept constant population weights/maturity
in their original numeric types, and supported mixed numeric recruitment/
selectivity inputs. It passed 281 backend assertions, 216 fresh real
configuration comparisons and every complete-fit numerical comparison.
Nevertheless it was **reverted**, not retained as a cold-start fix.
The [rejected experiment record](benchmarks/constant-components-2026-11-24/comparison.json)
preserves all eight full-precision fits, phase/snapshot indices, fingerprints
and compilation/GC/allocation costs against immutable `8f8d46fe`.

| Warm pair order | Prepared baseline (s) | Experiment (s) | Experiment/baseline |
| --- | ---: | ---: | ---: |
| AB | 179.5743 | 181.3128 | 1.009682 |
| BA | 184.7227 | 166.9131 | 0.903587 |
| AB | 177.5042 | 165.4516 | 0.932100 |

The median paired warm reduction was 6.8%, with one regression. Cumulative
allocations fell about 7.2%, from 314.09 to 291.50 GB per warm fit.
However shared-process first-use elapsed increased from **325.91 to 352.26
seconds**, and measured compilation from **122.20 to 136.73 seconds**.
These are not independent cold-process measurements, but provide no evidence
that this additional complexity addresses the outstanding cold-start gap.
All timings include live profiling; no work or slower trials were excluded.
Raw local artifact `p6-constant-pairs-01` retains full profiles/logs and the
active Project/Manifest. All six baseline source blobs matched Git.

Production backend source and tests were restored byte-for-byte to accepted
`8f8d46fe`, whose separate-process acceptance record above remains applicable.
Its 271 backend assertions and 216 real configuration comparisons remain the
retained implementation's results; the discarded candidate's additional
assertions are not counted as production coverage. **P6 was still open at
this stage.** The next investigation isolated first-use compilation and report/
profiler startup costs before choosing the precompilation recovery below.
The rejected experiment remains discarded; preparation costs must not be hidden.

## P6 completed: precompiled full-fit gate, 2026-11-24

Measured implementation **`be1af3e5`** passes the specified prepared-dependency
cold-process and warm-median gates, retaining complete native numerical parity.
This closes **P6**, not the overall migration or all-platform performance.

### Attribution and implementation

The [preceding attribution record](benchmarks/cold-attribution-2026-11-24/comparison.json)
uses the unchanged accepted prepared-objective backend (`8f8d46fe`) in one
fresh R process, with a cold and original-start warm full fit. Both pass the
independent native numerical comparison. Cold process-to-result was 448.10
seconds; trial walls were 423.12 cold and 182.22 warm. Measured compilation
was **154.96 seconds cold / zero warm**, and snapshot writing 60.45/1.39 seconds.
Compilation, GC, observer writing and phase elapsed overlap; this is not a
disjoint attribution or a fresh native performance comparison.

The recovery adds PrecompileTools 1.2.1 to cache representative exact derivative
workloads in ordinary Julia package images. Training uses synthetic 17-year/
four-age and three-year/three-age inputs, not the measured full assessment's
30 years, 12 ages and 23 length bins. It exercises conditional solves, joint
Hessians, exact Laplace trace chunk widths, report Jacobians and a bounded fit.
No fitted values, native outputs, uncertainty results or benchmark-specific
production branches are cached.

Private scalar/report function barriers keep layout-specific closure types
out of nested ForwardDiff tags, and the numerical kernel receives named
parameter fields without dimension-specific ComponentArray axes. Unused
optimizer metadata is removed only from the prepared numerical context.
Logistic/DoubleLogistic selectivity is reused across years; year-specific
AgeSpecific evaluation is retained. Fishing-rate exponentials are reused
across ages, and supplied spawning biomass per recruit avoids eager duplicate
calculation. Parameters, conditional modes, exact derivatives and all
uncertainty/report work remain live.

The standard Julia `Pkg.test()` run passed **275 assertions**, including
independent coupled/permuted-order derivative oracles and context independence
across dimensions. The existing real R-to-Julia joint-configuration test
passed **216 comparisons**, including parametric growth and priors. These are
real numerical checks, not mocked bridge evidence.

### Complete final protocol and result

The final command was the unchanged full `--backend both --warm-runs 3
--restarts 3` command above, with a new output directory. Input checksum
`ad075166d27afabb8dbe224aa73b84c6`, controls 10000/10000, 49 fixed/29 random
effects, single-thread settings, tolerances, full covariance/report SEs,
live profiling and the 7,200-second worker cap were unchanged. Native sources
and DLL still match the independent P2 oracle. No startup or uncertainty
exemption was applied.

The [passing acceptance record](benchmarks/precompiled-full-2026-11-24/comparison.json)
retains all eight full-precision results, input, host samples, phase records,
snapshot indices, compilation counters, preparation costs and checksums.
All eight fits converged with maximum absolute fixed gradient below `1e-3`,
positive-definite 78-by-78 covariance and all 32 required report-SE families
(13,091 rows). All four native/Julia comparisons and cold/warm repetitions
passed; original full-precision starts were identical.

| Complete elapsed measure, seconds | Native | Julia |
| --- | ---: | ---: |
| Cold process launch to validated result | 448.54 | 260.60 |
| Cold trial wall | 418.92 | 210.64 |
| Warm-1 wall | 435.84 | 172.89 |
| Warm-2 wall | 387.78 | 108.18 |
| Warm-3 wall | 387.34 | 92.08 |
| Warm median | 387.78 | 108.18 |
| Warm mean | 403.65 | 124.38 |
| Warm sample standard deviation | 27.88 | 42.77 |

Both measured ratios are at most one: cold **0.580989**, warm median
**0.278973**. Julia cold compilation was **28.61 seconds**, with zero
compilation/recompilation in all three warm fits. Each fit still performed
all **98** uncertainty conditional solves/exact marginal gradients.
Marginal-Hessian elapsed was 134.91 seconds cold and
139.64/78.00/74.93 warm; included snapshot writing was
17.99 seconds cold and 5.49/2.19/1.32 warm. No observer costs were subtracted.

### Preparation cost and interpretation

`julia/package-preparation.toml` preserves the actual preceding standalone
preparation, not just the later cached prepare wrapper: **738.66 seconds**
total, comprising dependency resolution **8.90**, precompilation **717.19**
and backend loading **12.57** seconds. Existing dependencies were reused;
this is not a clean-depot install timing. A separate bounds-checking Julia
test environment also spent about 866 seconds preparing its own image.
An unprepared first fit pays preparation; `setup_julia()` makes that work
explicit before analysis. Backend updates can invalidate the cache.

These are **qualified shared-host measurements**, not an isolated causal
72% warm speedup or a guarantee for other workloads/platforms. Native ran
first; host load varied substantially, some CPU samples were unavailable,
and native elapsed times were slower than earlier attempts. Native warm
CPU medians were approximately 66%; Julia observations were variable and
incomplete. Missing samples and every slower trial are retained, not imputed
or discarded. No concurrent agent builds/tests/model fits were launched and
no unrelated host processes/settings were changed. A reserved/interleaved
study would provide stronger causal attribution, but no such claim is made.

The actual source hashes, covariance Cholesky decompositions, starts,
numerical comparisons, profile-write sums, monotonically increasing counters
and portable artifact checksums were independently rechecked. Raw local
artifact `p6-precompiled-full-01` retains full sampling windows, logs and
the active bridge Project/Manifest. Windows x64, R 4.6.2, Julia 1.10.10,
Optim 1.13.3, ForwardDiff 0.10.39, ComponentArrays 0.15.50,
Functors 0.5.5, StatsBase 0.34.14 and PrecompileTools 1.2.1.
The next ready checklist item is **N1**.

## P3 incomplete attempt and diagnosis: 2026-11-23

**This earlier attempt did not complete P3.** The cold Julia fit passed the full native numerical
comparison, but no warm fit completed. After the user chose to retain the
two-hour process cap and diagnose the slowdown, the partial first warm fit
was stopped. There was no timeout extension or successful controller summary.
No optimization controls, numerical methods, or comparison tolerances changed.

The [attempt record](benchmarks/julia-full-2026-11-23-incomplete/attempt.json)
retains the passing cold result, per-family differences, environment/source
fingerprints, phase costs, and artifact checksums. Adjacent `input.rds` and
`julia/cold/result.rds` are byte-for-byte copies of the actual harness
outputs. Completed cold and partial warm phase/snapshot indexes are retained.
Raw local artifact `p3-julia-full-01` additionally preserves the full profiles,
dependency environment, and logs. These are **partial evidence**, not the
four-fit P3 deliverable.

The run used candidate `3767cc54`, the same R/Julia versions and hardware as
the preceding smoke/native work, the exact P2 input checksum
`ad075166d27afabb8dbe224aa73b84c6`, controls 10000/10000, three restarts,
and 30-second safe-point snapshots. The cold fit converged with maximum
absolute fixed gradient `9.581246067033161e-9`; all 78 estimates/parameter
SEs, complete positive-definite 78-by-78 covariance, joint/marginal objectives,
and 32 derived-SE families (13,091 rows) passed existing native comparisons.
The actual serialized starting values also matched native exactly.

Cold process launch to result took **6,161.14 seconds (102.69 minutes)**.
The trial itself took 6,102.37 seconds, including 6,026.57 seconds inside
`fit_fims`. Synchronously rendering/writing 109 sampling snapshots consumed
**2,629.05 seconds (43.82 minutes)**. Median snapshot write time was 20.21
seconds; the maximum was 89.04 seconds. A requested 30-second sampling window
does not make that formatting overhead negligible.

| Cold Julia stage | Elapsed seconds | Approximate overlapping snapshot-write seconds |
| --- | ---: | ---: |
| Outer optimization, including restarts | 3,870.61 | 1,422.96 |
| Fitted random mode and model report | 6.78 | 0 |
| Joint uncertainty Hessian | 33.52 | 0 |
| Marginal uncertainty Hessian | 1,898.72 | 1,010.01 |
| Covariance assembly | 8.94 | 0 |
| Report SEs | 109.56 | 73.08 |
| Final gradient | 56.81 | 41.24 |

These are checkpoint intervals, not a disjoint CPU-time attribution. They
include synchronous observer costs at their boundaries; some profiler,
bridge, initialization, and extraction work falls outside the listed stages.
Do not add nested derivative timings to their parent stage, or subtract
snapshot times and call the remainder an unprofiled benchmark.

The diagnosis identifies three concrete costs:

1. **The profiler has a large observer effect.** Sampling stops before
   `Profile.print`, so its costly formatting/writes do not appear in the sampled
   hot stacks. They are explicitly measured in `snapshots.tsv`. Reduce
   synchronous rendering cost before another expensive timing collection,
   while preserving usable during-run snapshots.
2. **Optimization repeats expensive work near the native solution.** It
   performed 321 full marginal-gradient evaluations and 642 conditional-mode
   solves, despite starting at independent native fitted values. The first
   maximum fixed gradient was about `7.58e-4`; the last was about `9.58e-9`.
   The objective and gradient callbacks each perform their own conditional
   solve from the original random starts. Investigate reuse at *identical*
   fixed points and improved optimizer conditioning, without loosening
   convergence or changing starts.
3. **Uncertainty multiplies the derivative workload.** The 49-column centered
   Hessian calculation requires 98 additional complete marginal gradients
   and conditional solves. Each exact Laplace gradient uses 13 fixed-variable
   chunks and 29 random-curvature directional terms per chunk. Live profile
   windows show nested ForwardDiff under `_laplace_gradient` and
   `_numerical_gradient_hessian`; sampled self-time also includes Julia
   dispatch/type lookup and allocation/GC helpers. This is repeated model/
   derivative work, not simply Julia startup.

Host conditions also deteriorated: observed CPU load rose from 2% before the
run to as high as 100%, with free memory observed near 0.7 GiB. No competing
agent builds/tests/model fits were launched, but this interactive workstation
was not an isolated timing host. P2 and P3 ran on different dates, not in
interleaved pairs. The instrumented cold result therefore demonstrates a
serious measurement/performance problem, not an unbiased cold/warm speed
ratio or a prediction of the unmeasured warm distribution.
