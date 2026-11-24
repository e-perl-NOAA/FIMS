# Developer tooling: source this file to inspect helpers; Rscript runs the CLI.
benchmark_require <- function(condition, message) {
  if (!isTRUE(condition)) {
    stop(message, call. = FALSE)
  }
}

benchmark_json <- function(value, path) {
  jsonlite::write_json(value, path, auto_unbox = TRUE, pretty = TRUE,
    null = "null", na = "null", digits = NA)
}

benchmark_parse <- function(arguments) {
  defaults <- list(
    case = "full", backend = "both", `warm-runs` = "3",
    `iter-max` = "10000", `eval-max` = "10000", restarts = "0",
    `snapshot-seconds` = "30", `timeout-seconds` = "7200"
  )
  allowed <- c(names(defaults), "native-source", "native-dll-md5",
    "julia", "output", "reference")
  benchmark_require(length(arguments) > 0L && length(arguments) %% 2L == 0L,
    "Arguments must be --name value pairs; see data-raw/BACKEND_BENCHMARK.md.")
  provided <- character()
  for (index in seq.int(1L, length(arguments), by = 2L)) {
    key <- sub("^--", "", arguments[[index]])
    benchmark_require(startsWith(arguments[[index]], "--") &&
      key %in% allowed && !key %in% provided, paste("Unknown or duplicate argument:", key))
    defaults[[key]] <- arguments[[index + 1L]]
    provided <- c(provided, key)
  }
  benchmark_require(defaults[["case"]] %in% c("full", "smoke"), "case must be full or smoke.")
  benchmark_require(defaults[["backend"]] %in% c("both", "native", "julia"),
    "backend must be both, native, or julia.")
  for (key in c("warm-runs", "iter-max", "eval-max", "restarts", "timeout-seconds")) {
    text <- defaults[[key]]
    benchmark_require(grepl("^[0-9]+$", text) &&
      as.numeric(text) <= .Machine[["integer.max"]], paste("Invalid integer:", key))
    defaults[[key]] <- as.integer(text)
  }
  benchmark_require(defaults[["iter-max"]] > 0L && defaults[["eval-max"]] > 0L &&
    defaults[["timeout-seconds"]] > 0L, "Iteration, evaluation and timeout limits must be positive.")
  defaults[["snapshot-seconds"]] <- as.numeric(defaults[["snapshot-seconds"]])
  benchmark_require(length(defaults[["snapshot-seconds"]]) == 1L &&
    is.finite(defaults[["snapshot-seconds"]]) && defaults[["snapshot-seconds"]] > 0,
    "snapshot-seconds must be positive and finite.")
  benchmark_require(!is.null(defaults[["output"]]), "--output is required.")
  if (defaults[["backend"]] != "julia") {
    benchmark_require(!is.null(defaults[["native-source"]]) &&
      dir.exists(defaults[["native-source"]]), "--native-source must identify a built historical checkout.")
    defaults[["native-source"]] <- normalizePath(defaults[["native-source"]])
  }
  if (defaults[["backend"]] != "native") {
    benchmark_require(!is.null(defaults[["julia"]]) && file.exists(defaults[["julia"]]),
      "--julia must identify the Julia executable explicitly.")
    defaults[["julia"]] <- normalizePath(defaults[["julia"]])
  }
  benchmark_require(defaults[["backend"]] != "julia" ||
    (!is.null(defaults[["reference"]]) && dir.exists(defaults[["reference"]])),
    "A Julia-only run requires --reference pointing to a native result directory.")
  defaults
}

benchmark_case <- function(root, name, options) {
  fixture <- function(file) readRDS(file.path(root, "tests", "testthat", "fixtures", file))
  provenance <- fixture("native-backend-oracle.rds")[["provenance"]]
  if (name == "full") {
    oracle <- fixture("native-full-model-oracle.rds")
    values <- oracle[["estimates"]] |>
      dplyr::transmute(
        module_name = .data[["module_name"]], fleet = .data[["fleet"]],
        label = .data[["label"]], timing = .data[["year_i"]],
        age = .data[["age"]], length = .data[["length"]], value = .data[["estimated"]]
      )
    parameters <- oracle[["parameters"]] |>
      dplyr::rows_update(values,
        by = c("module_name", "fleet", "label", "timing", "age", "length"))
    data <- oracle[["data"]]
    expected <- c(fixed_effects = 49L, random_effects = 29L)
  } else {
    case <- fixture("native-configuration-oracle.rds")[["cases"]][["EWAA-joint"]]
    parameters <- case[["parameters"]]
    data <- case[["data"]]
    expected <- c(fixed_effects = 6L, random_effects = 4L)
  }
  counts <- c(
    fixed_effects = sum(parameters[["estimation_type"]] %in% "fixed_effects"),
    random_effects = sum(parameters[["estimation_type"]] %in% "random_effects")
  )
  benchmark_require(identical(as.integer(counts), as.integer(expected)),
    "Fixture estimation masks do not match the benchmark specification.")
  active <- parameters[["estimation_type"]] %in% c("fixed_effects", "random_effects")
  benchmark_require(all(is.finite(parameters[["value"]][active])), "Active starting values must be finite.")
  list(
    schema = 1L, case = name, data = data, parameters = parameters, priors = NULL,
    counts = expected, control = list(
      iter.max = options[["iter-max"]], eval.max = options[["eval-max"]], trace = 0
    ), restarts = options[["restarts"]], max_gradient = 1e-3,
    required_derived = sort(unique(fixture("native-full-uncertainty-oracle.rds")[["derived"]][["label"]])),
    native_provenance = provenance
  )
}

benchmark_metadata <- function(source) {
  files <- c(list.files(file.path(source, "R"), "\\.[Rr]$", full.names = TRUE),
    list.files(file.path(source, "inst", "julia"), "\\.(jl|toml)$",
      recursive = TRUE, full.names = TRUE))
  files <- files[basename(files) != "Manifest.toml"]
  hashes <- tools::md5sum(files)
  names(hashes) <- substring(names(hashes), nchar(source) + 2L)
  revision <- NA_character_
  if (file.exists(file.path(source, ".git"))) {
    revision <- system2("git", c("-C", shQuote(source), "rev-parse", "HEAD"),
      stdout = TRUE, stderr = TRUE)
    benchmark_require(is.null(attr(revision, "status")), "Cannot read source revision.")
  }
  list(
    R = R.version.string, platform = R.version[["platform"]], system = as.list(Sys.info()),
    package_version = as.character(utils::packageVersion("FIMS")),
    source = source, revision = revision, source_md5 = as.list(hashes),
    session = capture.output(utils::sessionInfo()),
    threads = as.list(Sys.getenv(c("JULIA_NUM_THREADS", "OPENBLAS_NUM_THREADS",
      "OMP_NUM_THREADS", "MKL_NUM_THREADS")))
  )
}

benchmark_extract <- function(fit, input, backend, layout, bundle) {
  keys <- c("module_name", "fleet", "label", "year_i", "age", "length")
  metadata <- FIMS::get_estimates(fit)
  parameters <- metadata |>
    dplyr::filter(.data[["estimation_type"]] %in% c("fixed_effects", "random_effects"))
  report <- FIMS::get_report(fit)
  uncertainty <- FIMS::get_sdreport(fit)
  objective <- FIMS::get_obj(fit)
  gradient <- as.numeric(FIMS::get_gradient(fit))
  if (backend == "native") {
    fixed_names <- names(FIMS::get_parameter_names(objective[["par"]]))
    random_names <- names(FIMS::get_random_names(objective[["env"]][["parList"]]()[["re"]]))
    ids <- function(values) vapply(strsplit(values, ".", fixed = TRUE),
      function(parts) as.integer(parts[[4]]), integer(1))
    fixed_ids <- ids(fixed_names)
    random_ids <- ids(random_names)
    all_ids <- c(fixed_ids, random_ids)
    estimates <- c(summary(uncertainty, "fixed")[, "Estimate"],
      summary(uncertainty, "random")[, "Estimate"])
    errors <- c(summary(uncertainty, "fixed")[, "Std. Error"],
      summary(uncertainty, "random")[, "Std. Error"])
    index <- match(parameters[["parameter_id"]], all_ids)
    benchmark_require(!anyNA(index), "Cannot map native parameter IDs.")
    parameters[["estimated"]] <- unname(estimates[index])
    parameters[["uncertainty"]] <- unname(errors[index])
    parameters[["starting_value"]] <- c(layout[["p"]], layout[["re"]])[index]
    precision <- uncertainty[["jointPrecision"]]
    benchmark_require(!is.null(precision), "Native joint precision was not requested.")
    joint_ids <- integer(nrow(precision))
    joint_ids[rownames(precision) == "p"] <- fixed_ids
    joint_ids[rownames(precision) == "re"] <- random_ids
    benchmark_require(!anyDuplicated(joint_ids) && setequal(joint_ids, all_ids),
      "Native precision ordering is invalid.")
    indices <- match(parameters[["parameter_id"]], joint_ids)
    covariance <- as.matrix(solve(precision))[indices, indices, drop = FALSE]
    raw <- FIMS:::reshape_tmb_estimates(objective, uncertainty, FIMS::get_opt(fit),
      fixed_names, precomputed_gradient = gradient)
    identify <- function(rows) rows |>
      dplyr::group_by(.data[["label"]]) |>
      dplyr::mutate(oracle_id = dplyr::if_else(
        is.na(.data[["parameter_id"]]), dplyr::row_number(), .data[["parameter_id"]])) |>
      dplyr::ungroup()
    derived <- metadata |>
      identify() |>
      dplyr::filter(.data[["estimation_type"]] == "derived_quantity") |>
      dplyr::select(dplyr::all_of(c(keys, "oracle_id"))) |>
      dplyr::inner_join(
        identify(raw) |>
          dplyr::select(dplyr::all_of(c("label", "oracle_id", "estimate", "uncertainty"))),
        by = c("label", "oracle_id"), relationship = "one-to-one") |>
      dplyr::rename(estimated = "estimate") |>
      dplyr::select(-dplyr::all_of("oracle_id"))
  } else {
    result <- environment(objective[["fn"]])[["fit_result"]]
    indices <- parameters[["parameter_id"]]
    covariance <- result[["covariance"]][indices, indices, drop = FALSE]
    parameters[["starting_value"]] <- layout[["values"]][indices]
    derived <- metadata |>
      dplyr::filter(.data[["estimation_type"]] == "derived_quantity") |>
      dplyr::select(dplyr::all_of(c(keys, "estimated", "uncertainty")))
  }
  parameters <- parameters |>
    dplyr::select(dplyr::all_of(c(keys, "estimation_type", "estimated", "uncertainty", "starting_value")))
  counts <- FIMS::get_number_of_parameters(fit)
  benchmark_require(identical(as.integer(counts), as.integer(bundle[["counts"]])),
    "Backend estimated the wrong parameter counts.")
  benchmark_require(FIMS::get_opt(fit)[["convergence"]] == 0L,
    "Optimizer did not converge; this is not a successful timing.")
  benchmark_require(length(gradient) == counts[["fixed_effects"]] &&
    all(is.finite(gradient)) && max(abs(gradient)) < bundle[["max_gradient"]],
    "Fixed-effect gradient failed the common acceptance criterion.")
  benchmark_require(isTRUE(uncertainty[["pdHess"]]), "Uncertainty is not positive definite.")
  missing <- setdiff(bundle[["required_derived"]], unique(derived[["label"]]))
  benchmark_require(length(missing) == 0L,
    paste("Required derived-report SE families are missing:", paste(missing, collapse = ", ")))
  additional_derived <- derived |>
    dplyr::filter(!.data[["label"]] %in% bundle[["required_derived"]])
  derived <- derived |>
    dplyr::filter(.data[["label"]] %in% bundle[["required_derived"]])
  benchmark_require(all(is.finite(covariance)) && all(is.finite(parameters[["uncertainty"]])) &&
    all(is.finite(derived[["uncertainty"]])), "Required covariance/SEs are unavailable.")
  benchmark_require(all(is.finite(parameters[["estimated"]])) &&
    all(is.finite(derived[["estimated"]])) &&
    is.finite(FIMS::get_opt(fit)[["objective"]]) && is.finite(report[["jnll"]]),
    "Required estimates or objectives are nonfinite.")
  starts <- bundle[["parameters"]] |>
    dplyr::filter(.data[["estimation_type"]] %in% c("fixed_effects", "random_effects")) |>
    dplyr::rename(year_i = "timing") |>
    dplyr::select(dplyr::all_of(c(keys, "value")))
  matched <- dplyr::inner_join(parameters, starts, by = keys, relationship = "one-to-one")
  benchmark_require(nrow(matched) == nrow(parameters) &&
    identical(unname(matched[["starting_value"]]), unname(matched[["value"]])),
    "Backend did not consume the shared full-precision starting values.")
  list(
    parameters = parameters, covariance = unname(covariance), derived = derived,
    additional_derived = additional_derived,
    report = report, marginal = as.numeric(FIMS::get_opt(fit)[["objective"]]),
    joint = as.numeric(report[["jnll"]]), gradient = gradient,
    max_gradient = max(abs(gradient)), counts = counts, pd_hessian = TRUE,
    optimizer = FIMS::get_opt(fit)[c("convergence", "iterations", "evaluations", "message")]
  )
}

benchmark_worker <- function(config_path, backend, phase) {
  config <- readRDS(config_path)
  output <- file.path(config[["output"]], backend)
  dir.create(output, recursive = TRUE, showWarnings = FALSE)
  bundle_path <- file.path(config[["output"]], "input.rds")
  benchmark_require(identical(unname(tools::md5sum(bundle_path)), config[["input_md5"]]),
    "Shared benchmark input checksum changed.")
  bundle <- readRDS(bundle_path)
  source <- if (backend == "native") config[["native-source"]] else config[["root"]]
  options(FIMS.disable_julia = backend == "native")
  started <- proc.time()[["elapsed"]]
  pkgload::load_all(source, compile = FALSE, quiet = TRUE, helpers = FALSE)
  if (backend == "native") {
    dll <- getLoadedDLLs()[["FIMS"]][["path"]]
    expected <- config[["native-dll-md5"]]
    if (is.null(expected)) expected <- bundle[["native_provenance"]][["native_dll_md5"]]
    benchmark_require(identical(unname(tools::md5sum(dll)), expected),
      "Native DLL checksum differs: supply --native-dll-md5 for an independently built historical DLL.")
  } else {
    Sys.setenv(JULIA_HOME = dirname(config[["julia"]]), JULIA_BINDIR = dirname(config[["julia"]]))
    if (phase == "prepare") {
      project <- FIMS::setup_julia(julia = config[["julia"]])
      details <- file.path(project, "preparation.toml")
      benchmark_require(file.exists(details) &&
        file.copy(details, file.path(output, "package-preparation.toml")),
        "Cannot preserve Julia package preparation costs.")
    }
    if (phase == "run") {
      benchmark_require(FIMS:::initialize_julia_backend(), "Julia bridge initialization failed.")
      JuliaCall::julia_call("include", file.path(config[["root"]], "data-raw", "benchmark_profile.jl"))
    }
  }
  metadata <- benchmark_metadata(source)
  metadata[["native_declared_provenance"]] <- if (backend == "native") bundle[["native_provenance"]] else NULL
  if (backend == "native") metadata[["native_dll_md5"]] <- unname(tools::md5sum(dll))
  if (backend == "julia" && phase == "run") {
    JuliaCall::julia_command("using LinearAlgebra")
    metadata[["julia_version"]] <- JuliaCall::julia_eval("string(VERSION)")
    metadata[["julia_project"]] <- JuliaCall::julia_eval("Base.active_project()")
    metadata[["julia_blas"]] <- JuliaCall::julia_eval("string(BLAS.get_config())")
    metadata[["julia_blas_threads"]] <- JuliaCall::julia_eval("BLAS.get_num_threads()")
    benchmark_require(metadata[["julia_blas_threads"]] == 1L, "Julia BLAS must use one thread.")
    for (name in c("Project.toml", "Manifest.toml")) {
      benchmark_require(file.copy(
        file.path(dirname(metadata[["julia_project"]]), name),
        file.path(output, paste0("julia-", name))),
        paste("Cannot preserve Julia dependency environment:", name))
    }
  }
  metadata[["load_setup_seconds"]] <- proc.time()[["elapsed"]] - started
  benchmark_json(metadata, file.path(output, paste0(phase, "-environment.json")))
  if (phase == "prepare") {
    benchmark_json(list(status = "prepared", seconds = metadata[["load_setup_seconds"]],
      native_build = if (backend == "native") "preexisting DLL; build time not measured" else NULL),
      file.path(output, "preparation.json"))
    return(invisible(NULL))
  }
  progress <- file.path(output, "progress.tsv")
  writeLines("epoch_seconds\tstage", progress)
  checkpoint <- function(stage) cat(sprintf("%.6f", as.numeric(Sys.time())), stage, sep = "\t",
    file = progress, append = TRUE, fill = TRUE)
  assign("fims_benchmark_checkpoint", checkpoint, envir = .GlobalEnv)
  if (backend == "native") {
    trace("nlminb", where = asNamespace("stats"), print = FALSE,
      tracer = quote(.GlobalEnv[["fims_benchmark_checkpoint"]]("optimization:start")),
      exit = quote(.GlobalEnv[["fims_benchmark_checkpoint"]]("optimization:complete")))
    on.exit(untrace("nlminb", where = asNamespace("stats")), add = TRUE)
    trace("sdreport", where = asNamespace("TMB"), print = FALSE,
      tracer = quote({
        getJointPrecision <- TRUE
        .GlobalEnv[["fims_benchmark_checkpoint"]]("uncertainty:start")
      }), exit = quote(.GlobalEnv[["fims_benchmark_checkpoint"]]("uncertainty:complete")))
    on.exit(untrace("sdreport", where = asNamespace("TMB")), add = TRUE)
  }
  for (trial in seq_len(config[["warm-runs"]] + 1L)) {
    name <- if (trial == 1L) "cold" else paste0("warm-", trial - 1L)
    directory <- file.path(output, name)
    dir.create(directory)
    checkpoint(paste0(name, ":start"))
    trial_started <- proc.time()[["elapsed"]]
    profile <- NULL
    julia_profile_started <- FALSE
    profile_started <- proc.time()[["elapsed"]]
    utils::Rprof(file.path(directory, "Rprof.out"), interval = 0.02)
    profile_finalize_seconds <- NA_real_
    timed <- tryCatch({
      if (backend == "julia") {
        JuliaCall::julia_call("FIMSBenchmarkProfiler.start",
          file.path(directory, "julia-profile"), config[["snapshot-seconds"]])
        julia_profile_started <- TRUE
      }
      profile_setup_seconds <- proc.time()[["elapsed"]] - profile_started
      initialize_started <- proc.time()[["elapsed"]]
      FIMS::clear()
      input <- FIMS::initialize_fims(bundle[["parameters"]], FIMS::FIMSFrame(bundle[["data"]]),
        backend = if (backend == "native") "tmb" else "julia", priors = bundle[["priors"]])
      if (backend == "julia") {
        model_config <- attr(input, "julia_model_config")
        model_config[["diagnostic_file"]] <- file.path(directory, "optimizer.progress")
        attr(input, "julia_model_config") <- model_config
        layout <- JuliaCall::julia_call("FIMSBenchmarkProfiler.layout",
          attr(input, "julia_input")[["parameters"]], model_config)
      } else {
        layout <- input[["parameters"]]
      }
      initialize_seconds <- proc.time()[["elapsed"]] - initialize_started
      checkpoint(paste0(name, ":fit:start"))
      fit_started <- proc.time()[["elapsed"]]
      fit <- FIMS::fit_fims(input, get_sd = TRUE, save_sd = TRUE,
        number_of_loops = bundle[["restarts"]], control = bundle[["control"]],
        getReportCovariance = FALSE)
      fit_seconds <- proc.time()[["elapsed"]] - fit_started
      checkpoint(paste0(name, ":fit:complete"))
      extract_started <- proc.time()[["elapsed"]]
      result <- benchmark_extract(fit, input, backend, layout, bundle)
      extract_seconds <- proc.time()[["elapsed"]] - extract_started
      list(result = result, initialize_seconds = initialize_seconds,
        fit_seconds = fit_seconds, extract_seconds = extract_seconds)
    }, finally = {
      finalize_started <- proc.time()[["elapsed"]]
      tryCatch({
        if (julia_profile_started) profile <- JuliaCall::julia_call("FIMSBenchmarkProfiler.finish")
      }, finally = utils::Rprof(NULL))
      profile_finalize_seconds <- proc.time()[["elapsed"]] - finalize_started
    })
    timed[["profile_setup_seconds"]] <- profile_setup_seconds
    timed[["profile_finalize_seconds"]] <- profile_finalize_seconds
    timed[["trial_wall_seconds"]] <- proc.time()[["elapsed"]] - trial_started
    timed[["cold_process_to_result_seconds"]] <- if (trial == 1L) {
      as.numeric(Sys.time()) - config[["launched_epoch"]]
    } else NULL
    timed[["profile"]] <- profile
    timed[["input_md5"]] <- config[["input_md5"]]
    saveRDS(timed, file.path(directory, "result.rds"), version = 3)
    timing <- timed[setdiff(names(timed), "result")]
    benchmark_json(timing, file.path(directory, "timing.json"))
    checkpoint(paste0(name, ":complete"))
    rm(fit, input)
    gc()
  }
  benchmark_json(list(status = "complete", trials = config[["warm-runs"]] + 1L),
    file.path(output, "status.json"))
}

benchmark_compare <- function(native, julia) {
  benchmark_require(identical(native[["input_md5"]], julia[["input_md5"]]),
    "Cannot compare runs with different shared inputs or controls.")
  native <- native[["result"]]
  julia <- julia[["result"]]
  equal <- function(actual, expected, tolerance, label) {
    benchmark_require(isTRUE(all.equal(unname(actual), unname(expected),
      tolerance = tolerance, check.attributes = FALSE)), paste("Numerical comparison failed:", label))
  }
  equal(julia[["marginal"]], native[["marginal"]], 1e-6, "marginal objective")
  equal(julia[["joint"]], native[["joint"]], 1e-6, "joint objective")
  keys <- c("module_name", "fleet", "label", "year_i", "age", "length")
  indices <- native[["parameters"]] |>
    dplyr::mutate(native_index = dplyr::row_number()) |>
    dplyr::inner_join(julia[["parameters"]] |>
      dplyr::mutate(julia_index = dplyr::row_number()),
      by = keys, suffix = c("_native", "_julia"), relationship = "one-to-one")
  benchmark_require(nrow(indices) == nrow(native[["parameters"]]) &&
    nrow(indices) == nrow(julia[["parameters"]]), "Parameter keys do not match.")
  equal(indices[["estimated_julia"]], indices[["estimated_native"]], 1e-4, "estimates")
  equal(indices[["uncertainty_julia"]], indices[["uncertainty_native"]], 1e-4, "parameter SEs")
  equal(julia[["covariance"]][indices[["julia_index"]], indices[["julia_index"]], drop = FALSE],
    native[["covariance"]][indices[["native_index"]], indices[["native_index"]], drop = FALSE],
    1e-4, "complete covariance")
  derived <- dplyr::inner_join(native[["derived"]], julia[["derived"]],
    by = keys, suffix = c("_native", "_julia"), relationship = "one-to-one")
  benchmark_require(nrow(derived) == nrow(native[["derived"]]) &&
    nrow(derived) == nrow(julia[["derived"]]), "Derived quantity keys do not match.")
  for (label in unique(derived[["label"]])) {
    rows <- derived |> dplyr::filter(.data[["label"]] == .env[["label"]])
    equal(rows[["estimated_julia"]], rows[["estimated_native"]], 1e-4, paste(label, "values"))
    equal(rows[["uncertainty_julia"]], rows[["uncertainty_native"]], 1e-4, paste(label, "SEs"))
  }
  list(status = "passed", parameters = nrow(indices),
    derived_families = length(unique(derived[["label"]])), derived_rows = nrow(derived))
}

benchmark_main <- function(arguments, script) {
  config <- benchmark_parse(arguments)
  root <- normalizePath(file.path(dirname(script), ".."))
  benchmark_require(!file.exists(config[["output"]]), "Output must be a new directory; existing evidence is never overwritten.")
  dir.create(config[["output"]], recursive = TRUE)
  config[["output"]] <- normalizePath(config[["output"]])
  config[["root"]] <- root
  save_config <- file.path(config[["output"]], "config.rds")
  bundle <- benchmark_case(root, config[["case"]], config)
  saveRDS(bundle, file.path(config[["output"]], "input.rds"), version = 3)
  config[["input_md5"]] <- unname(tools::md5sum(file.path(config[["output"]], "input.rds")))
  benchmark_json(list(case = bundle[["case"]], counts = as.list(bundle[["counts"]]),
    priors = bundle[["priors"]], control = bundle[["control"]], restarts = bundle[["restarts"]],
    input_md5 = config[["input_md5"]], required_derived = bundle[["required_derived"]],
    harness_md5 = as.list(tools::md5sum(c(script,
      file.path(root, "data-raw", "benchmark_profile.jl"))))),
    file.path(config[["output"]], "protocol.json"))
  backends <- if (config[["backend"]] == "both") c("native", "julia") else config[["backend"]]
  Sys.setenv(LC_ALL = "C", JULIA_NUM_THREADS = "1", OPENBLAS_NUM_THREADS = "1",
    OMP_NUM_THREADS = "1", MKL_NUM_THREADS = "1")
  launch <- function(backend, phase) {
    config[["launched_epoch"]] <- as.numeric(Sys.time())
    saveRDS(config, save_config, version = 3)
    log <- file.path(config[["output"]], paste0(backend, "-", phase, ".log"))
    message("Launching ", backend, " ", phase, "; log: ", log)
    executable <- if (.Platform[["OS.type"]] == "windows") "Rscript.exe" else "Rscript"
    status <- system2(file.path(R.home("bin"), executable),
      c("--vanilla", shQuote(script), "--worker", shQuote(save_config), backend, phase),
      stdout = log, stderr = log, timeout = config[["timeout-seconds"]])
    benchmark_require(identical(as.integer(status), 0L),
      paste(backend, phase, "worker failed with exit status", status, "- see", log))
  }
  tryCatch({
    for (backend in backends) launch(backend, "prepare")
    for (backend in backends) launch(backend, "run")
    comparisons <- list()
    if (config[["backend"]] != "native") {
      reference <- if (config[["backend"]] == "both") config[["output"]] else config[["reference"]]
      trials <- "cold"
      if (config[["warm-runs"]] > 0L) {
        trials <- c(trials, paste0("warm-", seq_len(config[["warm-runs"]])))
      }
      for (name in trials) {
        native_path <- file.path(reference, "native", name, "result.rds")
        julia_path <- file.path(config[["output"]], "julia", name, "result.rds")
        benchmark_require(file.exists(native_path), paste("Missing matched reference:", native_path))
        comparisons[[name]] <- benchmark_compare(readRDS(native_path), readRDS(julia_path))
      }
    }
    benchmark_json(list(status = "complete", case = config[["case"]],
      comparisons = comparisons, performance_parity_established = FALSE),
      file.path(config[["output"]], "summary.json"))
  }, error = function(error) {
    benchmark_json(list(status = "failed", error = conditionMessage(error)),
      file.path(config[["output"]], "failure.json"))
    stop(error)
  })
  message("Completed benchmark protocol; inspect per-trial timing.json and summary.json.")
}

if (sys.nframe() == 0L) {
  arguments <- commandArgs(trailingOnly = TRUE)
  script <- normalizePath(sub("^--file=", "",
    commandArgs()[startsWith(commandArgs(), "--file=")]))
  if (length(arguments) > 0L && arguments[[1]] == "--worker") {
    benchmark_require(length(arguments) == 4L, "Internal worker arguments are invalid.")
    benchmark_worker(arguments[[2]], arguments[[3]], arguments[[4]])
  } else {
    benchmark_main(arguments, script)
  }
}
