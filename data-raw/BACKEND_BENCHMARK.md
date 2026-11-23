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

These implementation changes do not close P3: a new complete one-cold/
three-warm full-model run must pass the native comparisons and retain measured
phase and snapshot costs. The previous incomplete attempt remains below.

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

## P3 incomplete attempt and diagnosis: 2026-11-23

**P3 remains blocked.** The cold Julia fit passed the full native numerical
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
