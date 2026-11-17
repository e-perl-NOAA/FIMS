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
