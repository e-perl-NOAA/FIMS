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
