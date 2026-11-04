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
