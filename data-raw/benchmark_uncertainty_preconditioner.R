# Developer tooling; see BACKEND_BENCHMARK.md for timing boundaries.
arguments <- commandArgs(trailingOnly = TRUE)
stopifnot(length(arguments) %in% c(3L, 4L))
worker <- length(arguments) == 4L && identical(arguments[[4]], "--worker")
mode <- arguments[[1]]
baseline <- normalizePath(arguments[[2]], mustWork = TRUE)
output <- arguments[[3]]
stopifnot(mode %in% c("probe", "fits"))
script <- normalizePath(sub("^--file=", "",
  commandArgs()[startsWith(commandArgs(), "--file=")]))
root <- normalizePath(file.path(dirname(script), ".."))
source(file.path(root, "data-raw", "benchmark_backends.R"))
if (!worker) {
  benchmark_require(!file.exists(output), "Output must be a new directory.")
  dir.create(output, recursive = TRUE)
  output <- normalizePath(output)
  executable <- file.path(R.home("bin"),
    if (.Platform[["OS.type"]] == "windows") "Rscript.exe" else "Rscript")
  status <- system2(executable, c("--vanilla", shQuote(script), mode,
    shQuote(baseline), shQuote(output), "--worker"),
    stdout = file.path(output, "worker.log"), stderr = file.path(output, "worker.log"),
    timeout = 7200L)
  benchmark_require(identical(as.integer(status), 0L),
    paste("P4 worker failed with status", status, "- see worker.log."))
  quit(status = 0L)
}
Sys.setenv(LC_ALL = "C", JULIA_NUM_THREADS = "1", OPENBLAS_NUM_THREADS = "1",
  OMP_NUM_THREADS = "1", MKL_NUM_THREADS = "1")
pkgload::load_all(root, compile = FALSE, quiet = TRUE, helpers = FALSE)
stopifnot(FIMS:::initialize_julia_backend())
JuliaCall::julia_call("include", file.path(root, "data-raw", "benchmark_profile.jl"))
JuliaCall::julia_call("include", file.path(root, "data-raw", "benchmark_uncertainty_preconditioner.jl"))
bundle <- readRDS(file.path(root, "data-raw", "benchmarks",
  "native-full-2026-11-17", "input.rds"))
reference <- readRDS(file.path(root, "data-raw", "benchmarks",
  "julia-full-2026-11-23", "julia", "cold", "result.rds"))[["result"]]
fitted <- reference[["parameters"]]
fitted_parameters <- dplyr::rows_update(bundle[["parameters"]],
  fitted |> dplyr::transmute(
    module_name = .data[["module_name"]], fleet = .data[["fleet"]],
    label = .data[["label"]], timing = .data[["year_i"]], age = .data[["age"]],
    length = .data[["length"]], value = .data[["estimated"]]
  ), by = c("module_name", "fleet", "label", "timing", "age", "length"))
FIMS::clear()
original_input <- FIMS::initialize_fims(bundle[["parameters"]],
  FIMS::FIMSFrame(bundle[["data"]]), priors = bundle[["priors"]])
fitted_input <- FIMS::initialize_fims(fitted_parameters,
  FIMS::FIMSFrame(bundle[["data"]]), priors = bundle[["priors"]])
config <- attr(original_input, "julia_model_config")
config[["optimizer_max_iterations"]] <- bundle[["control"]][["iter.max"]]
config[["optimizer_max_evaluations"]] <- bundle[["control"]][["eval.max"]]
config[["optimizer_restarts"]] <- bundle[["restarts"]]
config[["compute_standard_errors"]] <- TRUE
config[["compute_report_covariance"]] <- FALSE
JuliaCall::julia_call("FIMSUncertaintyBenchmark.prepare",
  file.path(baseline, "src", "FIMSBackend.jl"),
  attr(original_input, "julia_input")[["parameters"]],
  attr(fitted_input, "julia_input")[["parameters"]],
  attr(original_input, "julia_input")[["data"]], config)
metadata <- benchmark_metadata(root)
metadata[["julia_version"]] <- JuliaCall::julia_eval("string(VERSION)")
metadata[["julia_project"]] <- JuliaCall::julia_eval("Base.active_project()")
metadata[["julia_blas"]] <- JuliaCall::julia_eval("string(FIMSUncertaintyBenchmark.BLAS.get_config())")
metadata[["julia_blas_threads"]] <- JuliaCall::julia_eval("FIMSUncertaintyBenchmark.BLAS.get_num_threads()")
benchmark_require(metadata[["julia_blas_threads"]] == 1L, "Julia BLAS must use one thread.")
for (name in c("Project.toml", "Manifest.toml")) {
  benchmark_require(file.copy(file.path(dirname(metadata[["julia_project"]]), name),
    file.path(output, paste0("julia-", name))), paste("Cannot preserve", name))
}
baseline_files <- list.files(file.path(baseline, "src"), "\\.jl$",
  full.names = TRUE, recursive = TRUE)
baseline_hashes <- tools::md5sum(baseline_files)
names(baseline_hashes) <- substring(names(baseline_hashes), nchar(baseline) + 2L)
driver_files <- file.path(root, "data-raw", c("benchmark_uncertainty_preconditioner.R",
  "benchmark_uncertainty_preconditioner.jl", "benchmark_profile.jl"))
driver_hashes <- tools::md5sum(driver_files)
names(driver_hashes) <- basename(names(driver_hashes))
benchmark_json(list(
  mode = mode, environment = metadata,
  baseline_source_md5 = as.list(baseline_hashes),
  driver_md5 = as.list(driver_hashes),
  input_md5 = unname(tools::md5sum(file.path(root, "data-raw", "benchmarks",
    "native-full-2026-11-17", "input.rds"))),
  timeout_seconds = 7200L,
  scope = if (mode == "probe") "Paired complete-model conditional solves and perturbed gradients." else
    "Paired complete Julia fit_model calls, including optimization and all uncertainty/report work; R initialization/adapters excluded on both sides.",
  cold_trials_excluded_from_warm_comparison = TRUE
), file.path(output, "protocol.json"))
progress <- file.path(output, "progress.tsv")
writeLines("epoch_seconds\tstage", progress)
checkpoint <- function(stage) cat(sprintf("%.6f", as.numeric(Sys.time())), stage,
  sep = "\t", file = progress, append = TRUE, fill = TRUE)
run_profiled <- function(directory, action) {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  JuliaCall::julia_call("FIMSUncertaintyBenchmark.profile_start", file.path(directory, "julia-profile"))
  on.exit(JuliaCall::julia_call("FIMSUncertaintyBenchmark.profile_finish"), add = TRUE)
  action()
}
assert_close <- function(first, second, tolerance, label) {
  benchmark_require(isTRUE(all.equal(first, second, tolerance = tolerance,
    check.attributes = FALSE)), paste("P4 comparison failed:", label))
}
results <- list()
if (mode == "probe") {
  run_profiled(output, function() {
    prepared <- JuliaCall::julia_call("FIMSUncertaintyBenchmark.prepare_probe", file.path(output, "optimizer.progress"))
    assert_close(prepared[["marginal"]], reference[["marginal"]], 1e-8, "fitted reference point")
    for (backend in c("baseline", "candidate")) {
      checkpoint(paste0("warmup:", backend))
      JuliaCall::julia_call("FIMSUncertaintyBenchmark.probe", backend, 1L, 1L)
    }
    for (index in seq_len(49L)) {
      for (direction in c(-1L, 1L)) {
        order <- if ((index + as.integer(direction > 0L)) %% 2L)
          c("candidate", "baseline") else c("baseline", "candidate")
        pair <- list()
        for (backend in order) {
          checkpoint(paste("probe", index, direction, backend, sep = ":"))
          pair[[backend]] <- JuliaCall::julia_call(
            "FIMSUncertaintyBenchmark.probe", backend, index, direction)
        }
        results[[length(results) + 1L]] <- pair
        saveRDS(results, file.path(output, "results.rds"), version = 3)
        difference <- max(abs(pair[["baseline"]][["gradient"]] -
          pair[["candidate"]][["gradient"]]))
        benchmark_require(is.finite(difference) && difference < 1e-6,
          paste("Perturbed gradients differ at coordinate", index,
            "direction", direction, "maximum absolute difference:", difference))
        assert_close(pair[["baseline"]][["parameters"]], pair[["candidate"]][["parameters"]], 1e-8, "modes")
        assert_close(pair[["baseline"]][["marginal"]], pair[["candidate"]][["marginal"]], 1e-8, "marginal")
      }
    }
  })
} else {
  sequence <- c("baseline", "candidate",
    "baseline", "candidate", "candidate", "baseline", "baseline", "candidate")
  for (index in seq_along(sequence)) {
    backend <- sequence[[index]]
    name <- paste0(if (index <= 2L) "cold-" else "warm-", index, "-", backend)
    checkpoint(name)
    directory <- file.path(output, name)
    result <- run_profiled(directory, function() {
      JuliaCall::julia_call("FIMSUncertaintyBenchmark.full_fit", backend,
        file.path(directory, "optimizer.progress"))
    })
    result[["warmup"]] <- index <= 2L
    result[["trial"]] <- name
    results[[index]] <- result
    saveRDS(results, file.path(output, "results.rds"), version = 3)
    if (index %% 2L == 0L) {
      pair <- results[c(index - 1L, index)]
      for (field in c("nll", "joint_nll", "estimates", "covariance",
        "fixed_hessian", "standard_errors", "report_values", "report_standard_errors_flat")) {
        assert_close(pair[[1]][["fit"]][[field]], pair[[2]][["fit"]][[field]],
          if (field %in% c("nll", "joint_nll")) 1e-6 else 1e-4, field)
      }
    }
    gc()
    JuliaCall::julia_command("GC.gc()")
  }
}
benchmark_json(list(status = "complete", mode = mode, pairs = if (mode == "probe") 98L else 3L),
  file.path(output, "summary.json"))
checkpoint("complete")
