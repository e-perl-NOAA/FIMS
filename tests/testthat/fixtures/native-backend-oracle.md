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

**N1 captures independent expectations; it does not close N2.** No Julia
results were used to construct or repair this reference. A real-Julia bridge
comparison against both cases, including targeting/scales, changed modes,
curvature and uncertainty, is still required.
