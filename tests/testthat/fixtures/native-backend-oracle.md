# Historical native comparison oracle

`native-backend-oracle.rds` contains pointer-free results freshly evaluated
with the native implementation at `1e5a64a8`, before the Julia-only cutover.
Its provenance records the R version and native DLL checksum. It does not
contain a native objective, external pointer, or native module object.

The `deterministic` cases reproduce the former live comparison fixtures:
EWAA and VonBertalanffySchnute growth, each at two initial fishing-mortality
settings (log F shifts of 0 and 0.01). Recruitment random effects are treated
as fixed parameters for joint-objective comparisons.

The `optimized` cases estimate one catchability parameter, with or without
one recruitment random effect, under each growth model. They retain the
marginal objective, joint objective, estimates and standard errors.

To regenerate, use a separate checkout of the historical revision with its
working native backend and the fixture construction from that revision's
`tests/testthat/test-julia-backend.R`. Capture each native objective and report
after evaluation, and each optimized result after checking convergence and a
positive-definite Hessian. Do not generate replacement expectations using
Julia. The parameter tibbles and input data are included in the fixture.

R-to-Julia integration regressions retain the comparison tolerances: `1e-8`
for deterministic objectives/reports, `1e-6` for optimized objectives, and
`1e-4` for optimized estimates and standard errors. These narrow cases do not
prove parity for every model, prior, or estimation configuration. The former
native comparison job remains reproducible from the historical revision.

`native-full-model-oracle.rds` captures the full 49-fixed/29-random example
fit at that same revision. Parameter estimates are taken from the native
uncertainty report at full precision rather than the rounded native JSON. The
joint objective and reports were re-evaluated in the native backend at those
exact values, treating recruitment deviations as fixed. The Julia regression
evaluates the same point; it does not establish optimized-fit or uncertainty
parity.

`native-full-uncertainty-oracle.rds` independently refits that full example
in the historical native checkout, starting from its saved optimum. It retains
full-precision fixed/random estimates, the complete 78-effect covariance
obtained from TMB's joint precision, and native derived-report standard errors.
Native parameter IDs were recovered from the original full-precision mapping;
the independently refitted values agree with that mapping within `1.4e-7`.
The fixture contains only R values, not native pointers. The bundled Julia fit
is compared with this reference at the existing `1e-6` objective and `1e-4`
optimized-estimate/uncertainty tolerances. This saved-fit gate does not replace
the fresh real-bridge integration gates or prove all supported combinations.

`native-configuration-oracle.rds` adds five-year, two-fleet configurations:
joint selectivity, catchability and recruitment estimation with six fixed and
four random effects, with and without priors; and growth-derived
VonBertalanffySchnute length compositions with nine fixed and four random
effects. Constants and starting values use the independent full native fit
where applicable. Comparisons cover two nonoptimal marginal objectives,
gradients and conditional reports, optimized joint/marginal objectives,
parameter estimates, the complete covariance and 32 derived-report SE families.

The historical high-level native initializer does not accept `priors`.
For the two prior cases, the oracle adds independent R `stats::dnorm` and
`stats::dlnorm` log densities and analytic gradients to the native marginal
objective. These priors target fixed effects only, so native conditional
random modes are unchanged. Normal and lognormal families cover identity
and exponentiated growth parameters; no change-of-variables Jacobian is
added to a prior on a documented parameter scale. Density gradients were
checked by centered finite differences at both comparison points.
`TMB::sdreport()` receives the augmented marginal Hessian via `hessian.fixed`,
including its contribution to fixed/random covariance and report SEs.
Growth parameter estimates and SEs are converted from log optimization
coordinates to their documented natural scale by the delta method; the
stored covariance remains in optimization coordinates.

To regenerate these cases, use the historical native checkout and DLL
identified in the fixture provenance, the stored per-case data, parameter
tibbles and priors, and the independent R density calculations above.
Optimize with `nlminb` (400 iterations/1,000 evaluations per attempt and up
to three restarts), requiring convergence, gradient below `1e-3` and
positive-definite uncertainty. Evaluate both stored fixed-coordinate points.
Use `optimHess` on the augmented analytic gradient with step `1e-4` before
calling `sdreport(getJointPrecision = TRUE)`. Do not use Julia to generate
or repair these expectations. Random-effect priors and every supported
configuration are not established by this fixture.

## Independent random-effect-prior reference (N1)

`native-random-prior-oracle.rds` contains a fresh native-only reference for
the five-year, two-fleet EWAA assessment, with six jointly estimated fixed
effects and four coupled recruitment deviations. It reuses the existing
configuration fixture's input, full-precision starts, six fixed-effect priors
and semantic parameter mapping, not Julia outputs. Two cases retain the same
fixed priors: `EWAA-fixed-prior-control` and `EWAA-random-priors`.
The verified generator, fixture and consistency regression are committed at
`0c6787b1`.

The augmented case adds normal priors directly on `log_devs` for recruitment
years 2 and 4, with means -0.35/0.25 and standard deviations 0.12/0.18.
These are identity-scale densities on the documented log-deviation parameter.
Existing normal and lognormal fixed-effect priors remain unchanged.

The historical FIMS initializer still does not accept priors. Instead, the
generator builds its native TMB **joint** tape with `random = NULL`, preserving
the existing recruitment-process likelihood and parameter registration.
Independent R density values, analytic scores and analytic prior curvature
augment that joint objective **before** conditional random-mode solving.
Damped Newton solves use the augmented random Hessian and require small score
residuals. Near floating-point objective resolution, a step must improve the
score residual; failures are explicit. Laplace adjustment uses the augmented
random Hessian, not the original native marginal objective plus a prior.

Marginal gradients use the joint score, implicit mode sensitivity and
five-point derivatives of native random curvature. They are independently
checked against five-point differences of the fully re-solved marginal
objective. Marginal Hessians and covariance are checked with both 0.001 and
0.0005 steps. Fixed covariance, conditional random covariance, mode
sensitivity and fixed/random cross-covariance are retained explicitly.
Native TMB AD report Jacobians propagate that augmented full covariance;
`sdreport` is not allowed to redo unaugmented random integration.

Each case stores two genuinely nonoptimal fixed-coordinate evaluations,
conditional modes/scores, joint and marginal objectives, native/prior random
curvature, prior contributions, gradients and reports. Optimized results
include complete positive-definite 10-by-10 covariance, parameter SEs and
32 common derived-report SE families (2,216 rows). The fixed-prior control
also reproduces the existing native configuration reference at its original
comparison tolerances.
As in the earlier fixed-prior fixture, report `jnll` includes priors while
the original native `nll_components` remain native-only. Independent
`prior_nll_components` are stored separately; both sums recover the joint total.

At the first stored fixed point, the added random priors shift a mode by
0.180096 and change the random Hessian. The saved post-marginalization
counterexample differs from the correct marginal objective by 4.3015342.
The optimized fixed-prior control has marginal/joint objectives
556.044078457083/549.507462313124; the random-prior case has
573.877468171400/567.062505237120. Maximum fixed gradients are below `1e-3`;
optimized random scores are below `6e-13`. Point-gradient cross-check errors
are below `9e-10`, and halving both derivative steps changes marginal Hessian
entries by less than `1.3e-8`.

### Regeneration

Run in **fresh R from the candidate repository root**, with the separate
historical native checkout/DLL already prepared. No native compilation or
Julia initialization is performed:

```powershell
$Rscript = 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe'
$NativeSource = 'C:\benchmarks\native-oracle'
$env:OPENBLAS_NUM_THREADS = '1'
& $Rscript --vanilla data-raw\generate_native_random_prior_oracle.R $NativeSource C:\benchmarks\native-random-prior-new.rds
```

The output path must be new and its parent directory must exist. The generator
verifies the loaded native DLL against the original fixture, checks baseline
native Laplace agreement, prior scores/curvature, conditional convergence,
derivative step stability, covariance validity and the post-marginalization
counterexample before saving. Its provenance records declared native revision
`1e5a64a8`, loaded DLL MD5 `7791104ab1295dcec1725062eb5f1f0a`, native R-source
hashes, input/generator hashes, R 4.6.2, TMB 1.9.21 and optimizer controls
(400 iterations/1,000 evaluations, up to three restarts).

Two fresh runs on the preserved Windows native environment produced
byte-identical pointer-free RDS files, MD5
`d4d40b794b74d47a3eed6bfb948a8bbe`. The R-only fixture-consistency regression
checks independent prior scores, random curvature, Laplace placement and
covariance decomposition.

N1 captures independent expectations; no Julia results were used to construct
or repair this reference.

### Real-Julia comparison (N2)

For N2, the test `real Julia joint configurations retain native gradients and uncertainty`
included both cases alongside the three earlier configuration references.
Fresh real R 4.6.2/Julia 1.10.10 execution passed **419 assertions across five
optimized fits and ten nonoptimal fixed points**. No production changes,
reference regeneration or tolerance relaxations were needed; the native fixture
MD5 remains `d4d40b794b74d47a3eed6bfb948a8bbe`.

The added comparisons verify prior component indices, distributions, means,
SDs and identity scales, including the retained six fixed priors. They compare
conditional modes, per-prior contributions, joint/marginal values and scores,
joint and marginal curvature, complete covariance and all 32 common report-SE
families. At each nonoptimal point, an all-active joint evaluation checks
native scores augmented by independent analytic R prior scores. Removing only
random priors at the **same augmented mode** recovers the native random
curvature; the difference equals the independent prior Hessian. Paired cases
also compare the changed modes, random curvature and optimized covariance.

Enable `FIMS_RUN_JULIA_INTEGRATION=true` and select Julia explicitly with
`JULIA_HOME`/`JULIA_BINDIR`. The existing real-integration CI paths run this
expanded test. To run the backend regression file locally from the repository
root, with the bridge already prepared:

```powershell
$env:FIMS_RUN_JULIA_INTEGRATION = 'true'
$env:JULIA_HOME = 'C:\path\to\julia\bin'
$env:JULIA_BINDIR = $env:JULIA_HOME
$env:JULIA_NUM_THREADS = '1'
$env:OPENBLAS_NUM_THREADS = '1'
$env:OMP_NUM_THREADS = '1'
$env:MKL_NUM_THREADS = '1'
& 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe' --vanilla -e 'pkgload::load_all(compile=FALSE, quiet=TRUE, helpers=FALSE); testthat::test_file("tests/testthat/test-julia-backend.R", reporter="summary", load_helpers=FALSE, stop_on_failure=TRUE)'
```

That command runs the other opt-in bridge tests too. The N2 validation selected
only the named configuration test in a fresh process; the entire R regression
file also passed separately with opt-in bridge tests disabled. Mocked checks
were not counted toward the 419 real comparisons. N2 closes this bounded gate,
not all prior families or supported model combinations.

## Independent DoubleLogistic reference (N3)

`native-double-logistic-oracle.rds` adds a five-year, 12-age, two-fleet EWAA
assessment with **all eight DoubleLogistic parameters jointly estimated**,
plus survey catchability and recruitment level, and four coupled recruitment
random effects. Unlike a nearly Logistic fit with an unidentifiable descending
limb, both inflection points lie within the modeled ages. No added priors are
needed. Other parameters retain the bounded configuration reference's constants.

The generator `data-raw/generate_native_double_logistic_oracle.R` runs only
the historical native backend. Its known generating curves differ by fleet:
ascending inflection/slope and descending inflection/slope are
`2.2/1.3/8.5/0.8` for `fleet1` and `3.1/1.1/9.7/1.2` for `survey1`.
Native expected catch and index become deterministic observations;
native age/length composition probabilities become integer samples of 200
using largest-remainder allocation. The independent starting selectivity
parameters perturb both limbs away from those generating values.

Two genuinely nonoptimal fixed points, separated by 0.01 in each coordinate,
retain conditional modes, joint scores/Hessians, marginal gradients and all
conditional reports. Fresh native `nlminb` fitting (400 iterations/1,000
evaluations per attempt, up to three restarts) gives marginal/joint objectives
`445.695208967045/439.033294374469`, convergence zero and maximum marginal
gradient `0.000175849` or less. All eight fitted selectivity parameters are
within 0.1 of their generating values and have positive SEs below 0.3.
The complete 14-by-14 covariance is positive definite; native TMB AD report
Jacobians provide 2,216 derived rows across 32 SE families. Marginal covariance
is also checked with the numerical gradient-difference step halved from
`1e-4` to `5e-5`. Off-diagonal random curvature confirms coupled effects.

Provenance retains declared native revision `1e5a64a8`, native DLL MD5
`7791104ab1295dcec1725062eb5f1f0a`, native R-source hashes, input/generator hashes,
R 4.6.2, TMB 1.9.21 and optimizer controls. Two fresh native-only processes
generated byte-identical pointer-free fixtures, MD5
`5151032bb90d6dd116bbd1d61be24f16`. No Julia results constructed or repaired
the native expectations.

Regenerate from the candidate repository root using the separately prepared
historical checkout/DLL and a **new output path**:

```powershell
$env:OPENBLAS_NUM_THREADS = '1'
$env:OMP_NUM_THREADS = '1'
$env:MKL_NUM_THREADS = '1'
& 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe' --vanilla data-raw\generate_native_double_logistic_oracle.R C:\benchmarks\native-oracle C:\benchmarks\native-double-logistic-new.rds
```

The generator emits an R sampling profile and progress log alongside the new
output. It verifies convergence, conditional scores, Laplace adjustment,
covariance validity/stability and selectivity identifiability before saving.
The R-only fixture regression separately checks native synthetic observation
rounding/sample sizes, identifiable estimates, curvature and Laplace placement.

For N3, the expanded real bridge test passed **534 assertions across six optimized
fits and twelve nonoptimal points** in fresh R 4.6.2/Julia 1.10.10 execution
with single-thread settings. N3 adds comparisons of both fleets' parameter
ownership, joint/marginal values and gradients, conditional modes, joint and
marginal Hessians, complete covariance, derived estimates and all 32 report-SE
families. It uses the unchanged `1e-8` deterministic objective/report/mode,
`1e-6` nonoptimal derivative and optimized-objective, and `1e-4` optimized
estimate/curvature/covariance/SE tolerances. The opt-in command above includes
this case automatically, as do the existing real-integration CI paths.
No production changes were required. This bounded case closes N3, not every
selectivity/growth/prior combination or the overall migration.

## Independent static AgeSpecific references (N4)

`native-static-selectivity-oracle.rds` covers two five-year, 12-age,
two-fleet assessments with EWAA growth and four coupled recruitment random
effects. Native-generated catch/index observations and largest-remainder
multinomial samples of 200 provide identifiable, nonuniform age patterns
that differ between fleets. Starting selectivity logits are shifted by 0.15
from their generating values. No additional priors are used.

| Case | Fleet layouts | Estimated fixed effects | Full covariance |
| --- | --- | --- | --- |
| `AgeSpecific-per-age` | 12 per-age logits in each fleet | 22 selectivity logits, survey catchability, recruitment level | 28-by-28 |
| `AgeSpecific-scalar-mixed` | One unindexed fishing logit, 12 survey logits | One scalar and 11 age logits, survey catchability, recruitment level | 18-by-18 |

Each per-age vector fixes age 6 at selectivity 0.9 to anchor its scale,
including the survey's otherwise confounded selectivity/catchability scale.
Fishing mortalities and the remaining confounded effects stay fixed in both
cases; the scalar fishing selectivity remains estimable. All estimated
selectivity logits have finite, positive SEs below 1. The native marginal/
joint objectives are `477.170685289972/470.393919467990` for per-age and
`483.256036646988/476.016117476143` for scalar/mixed. Both converge with
maximum fixed gradients below `0.000162` and positive-definite covariance.

The reproducible generator `data-raw/generate_native_static_selectivity_oracle.R`
uses the preserved native DLL and R implementation, not Julia. Two nonoptimal
points per case retain marginal gradients, conditional modes, joint scores/
Hessians and reports. Native TMB AD report Jacobians provide 2,216 derived
rows across 32 SE families. Marginal covariance is checked with gradient
differencing steps `1e-4` and `5e-5`. Native declared revision, DLL/R-source
hashes, input/generator hashes, R 4.6.2, TMB 1.9.21 and optimizer controls
(400 iterations/1,000 evaluations per attempt, up to three restarts) are saved.
Two fresh native-only processes produce byte-identical pointer-free fixtures,
MD5 `7b6ffd6fc4411e10e2ba98ebf787f7aa`.

Regenerate from the candidate root with the separately prepared historical
checkout/DLL and a **new output path**:

```powershell
$env:OPENBLAS_NUM_THREADS = '1'
$env:OMP_NUM_THREADS = '1'
$env:MKL_NUM_THREADS = '1'
& 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe' --vanilla data-raw\generate_native_static_selectivity_oracle.R C:\benchmarks\native-oracle C:\benchmarks\native-static-selectivity-new.rds
```

Progress logs and an R sampling profile are emitted beside the output.
The R-only consistency test verifies scalar/per-age broadcasting against
native fishing mortality, anchored logits, valid/stable covariance,
conditional scores and Laplace placement.

The real configuration test reverses AgeSpecific fleet and age input rows
before initializing Julia. It checks canonical serialization, lengths/offsets,
fixed masks, fleet/age ownership, preserved anchors, conditional modes,
joint/marginal objectives and derivatives, full covariance, derived estimates
and all 32 report-SE families. This exposed and fixed R extraction using the
input tibble's fleet order instead of the serialized data fleet order; the
numerical objective, optimizer, covariance calculations and tolerances did
not change. Constant parameter SEs remain unavailable, not fitted uncertainty.

The native scalar output labels its single vector slot with the first modeled
age, although its input is unindexed and the native kernel broadcasts it.
The fixture retains that native metadata unchanged. Only the comparison key
is normalized to the original input's unindexed `age = NA`; no numeric native
expectations are changed or regenerated to agree with Julia.

Fresh real R 4.6.2/Julia 1.10.10 execution, with explicit Julia selection and
single-thread settings, passes **778 assertions across eight optimized fits
and sixteen nonoptimal points**, without failures, errors or skips. The full
R backend regression file also passes separately with its five opt-in bridge
tests skipped; its 18 new R-only fixture checks do not count as real-Julia
evidence. The opt-in command in the N2 section and existing integration CI
paths include both cases. N4 closes static layouts only; N5 below adds
year-by-age selectivity.

## Independent year-by-age AgeSpecific reference (N5)

`native-yearly-selectivity-oracle.rds` adds a five-year, 12-age assessment
with a **60-logit year-by-age fishing vector and 12-logit static survey vector**.
Ages 2, 5 and 9 are estimated in every fishing year and in the survey; other
logits and fishing mortalities remain fixed to remove confounding. Survey
catchability and recruitment level are also estimated, giving 20 fixed and
four coupled recruitment random effects. No additional priors are used.
The year and age patterns are nonuniform and differ between fleets.

The native-only generator `data-raw/generate_native_yearly_selectivity_oracle.R`
uses the preserved historical DLL and R implementation. Observations come
from the native truth report, with largest-remainder integer multinomial
samples and likelihood sample sizes of 1,000. Estimated logits start 0.15
away from truth. The native fit converges with maximum fixed gradient
`0.000138322621382`, marginal/joint objectives
`678.360261724154/668.838910940096`, and positive-definite 24-by-24 covariance
(smallest eigenvalue `0.000218174773060`). Estimated selectivity SEs range
from `0.06551` to `0.61269`.

The historical native numerical kernel supports year-by-age selectivity,
but its JSON declares only `n_ages = 12` for the 60-element fishing vector.
The historical high-level `get_estimates()` therefore cannot reshape it.
The generator preserves the original selectivity JSON in
`native_selectivity_metadata`, changes only the fishing vector's local
dimension descriptor to `[n_years, n_ages] = [5, 12]`, then invokes the
historical reshaper. Registered vector slots are matched to original canonical
input year/age coordinates. Native JSON inputs have six-significant-digit
serialization, so their metadata validation uses `1e-5`; registered active
starts are independently checked at full precision (`1e-14`). Neither native
numeric kernels nor any comparison tolerances are changed. All objective,
gradient, Hessian, covariance and report expectations come from native TMB,
never Julia.

The fixture retains two nonoptimal points with conditional modes, joint scores/
Hessians, marginal gradients and reports; optimized joint/marginal Hessians;
and native AD uncertainty for 2,216 report rows in 32 families. Halving the
gradient-differencing step from `1e-4` to `5e-5` verifies marginal covariance
stability. Provenance includes historical revision `1e5a64a8`, native DLL MD5
`7791104ab1295dcec1725062eb5f1f0a`, R-source, generator and input hashes,
R 4.6.2, TMB 1.9.21 and optimizer controls. Two fresh native-only processes
produce byte-identical pointer-free fixtures, MD5
`1e40ac6b0ac843135356d7c81d384f57`.

Regenerate from the candidate root with the prepared historical checkout/DLL
and a **new output path**:

```powershell
$env:LC_ALL = 'C'
$env:OPENBLAS_NUM_THREADS = '1'
$env:OMP_NUM_THREADS = '1'
$env:MKL_NUM_THREADS = '1'
& 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe' --vanilla data-raw\generate_native_yearly_selectivity_oracle.R C:\benchmarks\native-oracle C:\benchmarks\native-yearly-selectivity-new.rds
```

The R-only consistency test checks native fishing mortality against the
independent R calculation `plogis(year_age_logits) * exp(yearly_log_Fmort)`,
year/age slot ownership, original JSON metadata, covariance, conditional
scores and Laplace placement. Its 15 assertions are not real-bridge evidence.

The real configuration test reverses fleet, year and age input rows and checks
canonical 60/12 serialization, offsets 1/61, masks, constants, fitted parameter
ownership, conditional modes, objectives, joint/marginal derivatives and
complete covariance. Derived estimates and SEs are joined by module, fleet,
label, year, age and length, verifying all 32 families. Three deliberately
corrupted layouts (year/age transpose, swapped years, swapped fleet blocks)
must each change both joint objective and fishing mortality.

Fresh real R 4.6.2/Julia 1.10.10 execution with explicit Julia selection and
single-thread settings passes **906 assertions across nine optimized fits and
eighteen nonoptimal points**, with no failures, errors or skips. The full R
backend regression file also passes separately with its five opt-in bridge
tests skipped. Use the existing opt-in command in the N2 section; the same
integration CI paths include this new case. No production optimizer or
derivative code changed, so the existing P6 evidence is not invalidated;
this numerical gate is not a new performance measurement.

## Independent delta-method growth reference (N6)

The original `native-backend-oracle.rds` deterministic VonBertalanffySchnute
cases and `native-configuration-oracle.rds`'s
`VonBertalanffySchnute-joint-priors` case use **two-reference-age SD
interpolation**, with SD inputs 28 and 73 at ages 1 and 12. They do not
exercise the alternate six-parameter delta-method variability route.

`native-growth-delta-oracle.rds` adds that missing route using the historical
native kernel, DLL and R implementation. Its five-year, 12-age, two-fleet
assessment uses growth-derived age-to-length conversion, not a supplied
conversion matrix. Catch/index observations and integer largest-remainder
composition samples of 1,000 are generated by the native model; the
multinomial likelihood sample sizes are also 1,000. No added priors are used.

The variability inputs are three working-scale log SDs and three transformed
correlations. Generating SDs are `0.11`, `0.1` and `0.32`; correlation
coordinates are `0.3`, `-0.25` and `0.2`, transformed by
`2 * plogis(value) - 1`. The fit jointly estimates the two reference lengths,
growth coefficient and three log SDs, survey catchability and recruitment
level, with four coupled recruitment random effects: **eight fixed and four
random effects**, giving positive-definite 12-by-12 covariance. Other
confounded parameters remain fixed.

Correlations are held fixed in this identifiable fit, not claimed to have
been jointly estimated. The generator registers them in the historical
native model and fixes their slots using TMB's parameter map. A separate
native joint tape removes only those map restrictions, retaining all other
constants. At each of two nonoptimal points it captures the 15-coordinate
joint gradient and Hessian, including **all six variability coordinates**,
at the same conditional random mode. These expectations are independent of
Julia. The main tape also captures marginal gradients, conditional modes,
joint scores/Hessians and reports.

The native optimum has marginal/joint objectives
`701.357391022803/691.997087999145`, maximum fixed gradient
`0.000563030085652`, and smallest covariance eigenvalue
`0.00000191821819133`. Estimated reference lengths are about `274.742` and
`725.974`, the growth coefficient is `0.178152`, and variability SDs are
`0.109556`, `0.0969534` and `0.313316`. Native working-scale covariance is
transformed with exact exponential Jacobians to retain an independent
six-growth-parameter natural-scale covariance/SE reference. Marginal
covariance is stable when halving the differencing step from `1e-4` to
`5e-5`. Native TMB AD supplies 2,216 report rows in the 32 common report-SE
families, including both fleets' growth-derived length compositions.

The historical native model omits the potentially large derived conversion
tensor by default, even when it uses that conversion for likelihoods.
The generator explicitly calls its existing
`ReportAgeToLengthConversionDerivedTensor(TRUE)` method before building
each tape, capturing 1,380 conversion values per fleet for comparison.
This changes reporting only; native numerical kernels and likelihoods
are unmodified. The `$` calls in the generator invoke historical Rcpp
module methods, whose lookup is not supported by `[[`.

Two fresh native-only processes produce byte-identical pointer-free
fixtures, MD5 `6dcd43437232cc0d704618e74be6923a`. Provenance retains historical
revision `1e5a64a8`, native DLL MD5 `7791104ab1295dcec1725062eb5f1f0a`,
native R-source, input and generator hashes, R 4.6.2, TMB 1.9.21 and
optimizer controls (400 iterations/1,000 evaluations per attempt, up to
three restarts). Regenerate from the candidate root with the prepared
historical checkout/DLL and a **new output path**:

```powershell
$env:LC_ALL = 'C'
$env:OPENBLAS_NUM_THREADS = '1'
$env:OMP_NUM_THREADS = '1'
$env:MKL_NUM_THREADS = '1'
& 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe' --vanilla data-raw\generate_native_growth_delta_oracle.R C:\benchmarks\native-oracle C:\benchmarks\native-growth-delta-new.rds
```

The real configuration test retains the earlier interpolation case and adds
the delta-method case. It compares optimized/nonoptimal objectives,
conditional modes, marginal/joint derivatives, complete covariance,
natural-scale growth estimates/SEs/covariance and all 32 common report-SE
families. Growth mean/SD/weight reports, the full derived conversion tensors,
conversion-usage flags and each likelihood component are checked explicitly.
Additional joint probes compare native gradients and Hessians in all six
variability coordinates, including the three correlations held constant in
the fit. The R-only fixture checks distinguish both routes and verify
covariance, transforms, conditional scores and Laplace placement; they are
not real-bridge evidence.

Fresh real R 4.6.2/Julia 1.10.10 execution with explicit Julia selection and
single-thread settings passes **1,053 assertions across ten optimized fits
and twenty nonoptimal points**, with no failures, errors or skips. The full
R backend regression file passes separately with its five opt-in bridge
tests skipped, including 18 new R-only fixture assertions that are not
counted as real-Julia evidence. The existing opt-in command in the N2
section and real-integration CI paths include this case. No production
optimizer/derivative code or numerical tolerances changed; existing P6
evidence is not invalidated, and this numerical gate is not a new
performance measurement.

## Independent proportion-female references (N7)

`native-proportion-female-oracle.rds` contains two native-generated,
five-year, 12-age, two-fleet assessments. One uses scalar proportion female
`0.37`; the other uses the nonuniform age vector
`c(0.21, 0.28, 0.35, 0.43, 0.52, 0.62, 0.7, 0.76, 0.81, 0.78, 0.69, 0.57)`.
Native catch/index expectations and integer largest-remainder composition
samples of 1,000 supply observations; multinomial likelihood sizes are also
1,000. Both cases jointly estimate four Logistic selectivity parameters,
survey catchability and recruitment level, with four coupled recruitment
random deviations: **six fixed and four random effects**, without added priors.

Female inputs remain **constant** in these identifiable fits. A scalar
female proportion scales spawning biomass and unfished spawning biomass
per recruit equally, cancelling from Beverton-Holt recruitment and the
catch/index likelihoods. Estimating that scalar here would introduce an
unidentifiable direction. The generator registers female coordinates in
the native model, fixes them through TMB's map for fitting, and removes only
those restrictions on separate joint derivative tapes. At two nonoptimal
points it captures 11-coordinate scalar and 22-coordinate per-age joint
gradients and Hessians at the same conditional random modes. These probes
do not establish fitted female estimates or female-parameter uncertainty.

Counterfactual reports isolate the biology's effect while holding all other
parameters and conditional modes fixed. Replacing scalar `0.37` with `0.61`
rescales spawning biomass but leaves recruitment and likelihood unchanged.
Reversing the age vector changes spawning biomass, recruitment and joint
likelihood: its native first-point likelihood change is about `-0.012916`,
and its maximum recruitment change exceeds 11,700. Independent R formulas
also reconstruct spawning biomass, unfished spawning biomass per recruit,
and Beverton-Holt recruitment with the plus group and recruitment deviations
directly from native truth inputs/reports.

The scalar native optimum has marginal/joint objectives
`697.880647744499/688.530397929101`, maximum fixed gradient
`0.000153333421787`, and smallest covariance eigenvalue
`0.000232081095699`. The per-age optimum has objectives
`697.878492408535/688.529857198377`, maximum fixed gradient
`0.000215991755489`, and smallest covariance eigenvalue
`0.000232715060159`. Both 10-by-10 covariance matrices are positive definite,
and marginal covariance is stable when halving the Hessian differencing
step from `1e-4` to `5e-5`. Native TMB AD supplies 2,216 report rows in the
32 common report-SE families, including spawning and recruitment uncertainty.
Constants have no fitted parameter SEs.

Historical native female JSON metadata omits the module ID and labels the
scalar with the first age. The generator preserves those original rows.
For semantic joins only, it recovers module ownership from exact registered
parameter IDs/names after checking input values at `1e-14`, and normalizes
the scalar's probe age to `NA`. No native numerical kernels, registered
values, likelihoods, derivatives or uncertainty expectations are repaired.

Two fresh native-only processes produce byte-identical pointer-free
fixtures, MD5 `a6ce5d1a9b02e496e5c0b64c05e0218a`. Provenance retains historical
revision `1e5a64a8`, native DLL MD5 `7791104ab1295dcec1725062eb5f1f0a`,
native R-source/input hashes, generator MD5
`ea54f982121c1557ba964e9700e1c350`, R 4.6.2, TMB 1.9.21 and optimizer
controls (400 iterations/1,000 evaluations per attempt, up to three
restarts). Regenerate from the candidate root with the prepared historical
checkout/DLL and a **new output path**:

```powershell
$env:LC_ALL = 'C'
$env:OPENBLAS_NUM_THREADS = '1'
$env:OMP_NUM_THREADS = '1'
$env:MKL_NUM_THREADS = '1'
& 'C:\Program Files\R\R-4.6.2\bin\x64\Rscript.exe' --vanilla data-raw\generate_native_proportion_female_oracle.R C:\benchmarks\native-oracle C:\benchmarks\native-proportion-female-new.rds
```

The real configuration test reverses female input age rows before
initialization and verifies scalar/per-age ownership, exact values, fixed
masks and unavailable female parameter SEs. It compares joint/marginal
objectives, conditional modes, derivatives, complete covariance, derived
estimates and all 32 common report-SE families. Additional comparisons cover
unfished spawning biomass, spawning biomass ratios, likelihood components,
all female-coordinate joint derivatives, and the changed-input feedback
reports. The existing N2 opt-in command and real-integration CI paths
include both cases. R-only formula/fixture checks are not bridge evidence.

Fresh real R 4.6.2/Julia 1.10.10 execution with explicit Julia selection
and single-thread settings passes **1,331 assertions across twelve optimized
fits and twenty-four nonoptimal points**, with no failures, errors or skips.
The full R backend regression file passes separately with its five opt-in
bridge tests skipped, including 24 new R-only formula/fixture assertions
that are not counted as real-Julia evidence. No production optimizer/
derivative code or numerical tolerances changed; existing P6 evidence is
not invalidated. This numerical gate is not a new performance measurement.
