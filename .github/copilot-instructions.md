# GitHub Copilot Instructions for FIMS

These guidelines are meant to help Copilot generate suggestions that fit the structure and development practices used in FIMS.  
Copilot should treat the existing codebase, especially the `tests/` directory, as the main reference before suggesting any new patterns or structures.

## General Development Guidelines

- Always follow the existing Julia and R coding style used in the repo.
  - For R: follow the [tidyverse style guide](https://style.tidyverse.org). Use tidyverse-style syntax instead of base R, and use the pipe operator (`|>`) to connect code.
  - For Julia: follow the conventions in `inst/julia/FIMSBackend/src/`.
  - For variables: Use full, descriptive names whenever possible.
  - For R object fields: Use `[[ ]]` instead of `$` when extracting fields from an object.
- Do not introduce new structural patterns or large stylistic rewrites unless the issue specifically asks for them.
- Avoid adding new dependencies without discussion.
- Prefer clear and maintainable code over overly clever or complicated ones.
- If a change significantly affects behavior or structure, include a clear explanation and avoid it unless it meaningfully improves the performance or correctness.

## Scope and Change Discipline

- Keep AI-generated changes small and focused on the issue requirements.
- Do not mix formatting-only edits with functional changes.
- Avoid refactors that are not directly related to the given issue.

## Julia Backend and Model Structure

- Follow the existing parameter serialization, model configuration, and population/fleet evaluation patterns.
- Do not restructure model setup logic unless explicitly required.
- Maintain consistency between the Julia backend and the R bridge.
- Do not modify public interfaces without updating related tests and documentation.

## Julia Testing

Before generating or modifying Julia tests, review
`inst/julia/FIMSBackend/test/runtests.jl`.

- Run backend tests with `julia --project=inst/julia/FIMSBackend -e 'using Pkg; Pkg.test()'`.
- Reuse existing testsets and fixtures, including independent mathematical oracles.
- Keep saved historical native expectations independent of Julia results.
- Mocked bridge checks do not establish numerical parity or real R-to-Julia execution.
- Do not reintroduce native modules, Rcpp/TMB dependencies, or C++ build tooling.

## R Testing – testthat

Before generating or modifying R tests, review the `tests/testthat/` directory.

- New test files should follow the pattern:  
  `tests/testthat/test-function_name.R`.
- When creating new R tests, first suggest using  
  `FIMS:::use_testthat_template("function_name")`.
- Reuse existing helper functions and integration helpers where possible.
- Store reusable test data in `tests/testthat/fixtures/` following the current conventions.
- Treat existing test files as the reference instead of creating any new patterns.

## Logic and Behavioral Changes

- Any change to logic or behavior should include corresponding tests.
- If modifying JSON parsing, model configuration, or integration logic, ensure tests reflect the updated behavior.
- Avoid silent behavior changes without corresponding test updates.

## Documentation

- If functionality changes, update the relevant comments, Roxygen blocks, or other documentation as per the requirements.