# Run in fresh R from the candidate root with the historical native checkout.
generate_native_double_logistic_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  generator <- file.path("data-raw", "generate_native_double_logistic_oracle.R")
  fixture <- file.path("tests", "testthat", "fixtures", "native-configuration-oracle.rds")
  reference <- readRDS(fixture)
  source_case <- reference[["cases"]][["EWAA-joint"]]
  progress <- function(message) {
    cat(message, "\n")
    cat(message, "\n", file = paste0(output, ".progress"), append = TRUE)
  }
  utils::Rprof(paste0(output, ".Rprof"), interval = 0.02)
  on.exit(utils::Rprof(NULL), add = TRUE)
  options(FIMS.disable_julia = TRUE)
  pkgload::load_all(native_source, compile = FALSE, quiet = TRUE, helpers = FALSE)
  dll <- getLoadedDLLs()[["FIMS"]][["path"]]
  stopifnot(identical(unname(tools::md5sum(dll)),
    reference[["provenance"]][["native_dll_md5"]]))
  keys <- c("module_name", "fleet", "label", "year_i", "age", "length")
  data <- source_case[["data"]]
  frame <- FIMS::FIMSFrame(data)
  selectivity <- dplyr::bind_rows(
    FIMS::setup_default_Selectivity(frame, "fleet1", "DoubleLogistic") |>
      dplyr::mutate(value = c(2.2, 1.3, 8.5, 0.8)),
    FIMS::setup_default_Selectivity(frame, "survey1", "DoubleLogistic") |>
      dplyr::mutate(value = c(3.1, 1.1, 9.7, 1.2))
  )
  truth_parameters <- source_case[["parameters"]] |>
    dplyr::filter(.data$module_name != "Selectivity") |>
    dplyr::bind_rows(selectivity)
  truth_input <- FIMS::initialize_fims(truth_parameters, frame, backend = "tmb")
  truth_fit <- FIMS::fit_fims(truth_input, optimize = FALSE, get_sd = FALSE)
  truth_objective <- FIMS::get_obj(truth_fit)
  truth_vector <- unname(unlist(truth_input[["parameters"]], use.names = FALSE))
  truth_report <- truth_objective[["report"]](truth_vector)
  # Deterministic native-generated observations, not a Julia self-consistency fit.
  # Largest-remainder allocation preserves integer multinomial sample sizes.
  counts <- function(probabilities, size = 200L) {
    expected <- size * probabilities / sum(probabilities)
    result <- floor(expected)
    remainder <- size - sum(result)
    if (remainder > 0) {
      indices <- order(expected - result, decreasing = TRUE)[seq_len(remainder)]
      result[indices] <- result[indices] + 1
    }
    result / size
  }
  fleets <- c("fleet1", "survey1")
  for (fleet_index in seq_along(fleets)) {
    fleet <- fleets[[fleet_index]]
    for (specification in list(
      c("age_comp", "agecomp_expected", "age"),
      c("length_comp", "lengthcomp_expected", "length")
    )) {
      rows <- which(data[["fleet"]] == fleet & data[["type"]] == specification[[1]])
      rows <- rows[order(data[["timing"]][rows], data[[specification[[3]]]][rows])]
      probabilities <- as.numeric(truth_report[[specification[[2]]]][[fleet_index]])
      stopifnot(length(rows) == length(probabilities))
      bins <- length(unique(data[[specification[[3]]]][rows]))
      data[["observed"]][rows] <- unlist(lapply(
        split(probabilities, rep(seq_len(length(rows) / bins), each = bins)), counts
      ), use.names = FALSE)
    }
    for (type in c("catch", "index")) {
      rows <- which(data[["fleet"]] == fleet & data[["type"]] == type)
      if (!length(rows)) next
      rows <- rows[order(data[["timing"]][rows])]
      data[["observed"]][rows] <-
        as.numeric(truth_report[[paste0(type, "_expected")]][[fleet_index]])
    }
  }
  parameters <- truth_parameters |>
    dplyr::mutate(value = dplyr::case_when(
      .data$module_name == "Selectivity" & .data$label == "inflection_point_asc" ~ .data$value + 0.2,
      .data$module_name == "Selectivity" & .data$label == "inflection_point_desc" ~ .data$value - 0.3,
      .data$module_name == "Selectivity" & .data$label %in% c("slope_asc", "slope_desc") ~ .data$value * 0.9,
      .default = .data$value
    ))
  progress("initialize DoubleLogistic-joint")
  input <- FIMS::initialize_fims(parameters, FIMS::FIMSFrame(data), backend = "tmb")
  initial_fit <- FIMS::fit_fims(input, optimize = FALSE, get_sd = FALSE)
  objective <- FIMS::get_obj(initial_fit)
  metadata <- FIMS::get_estimates(initial_fit)
  fixed_count <- length(objective[["par"]])
  parameter_names <- c(names(objective[["par"]]),
    names(FIMS::get_random_names(input[["parameters"]][["re"]])))
  native_keys <- purrr::map_chr(strsplit(parameter_names, ".", fixed = TRUE),
    \(parts) paste(parts[1:4], collapse = "."))
  metadata_keys <- metadata |>
    dplyr::transmute(key = paste(
      .data$module_name, .data$module_id, .data$label, .data$parameter_id, sep = "."
    )) |>
    dplyr::pull(.data$key)
  parameter_rows <- metadata[match(native_keys, metadata_keys), keys] |>
    dplyr::mutate(
      estimation_type = c(rep("fixed_effects", fixed_count),
        rep("random_effects", length(parameter_names) - fixed_count)),
      transform = "identity"
    )
  random_indices <- seq.int(fixed_count + 1L, length(parameter_names))
  stopifnot(fixed_count == 10L, length(random_indices) == 4L,
    !anyNA(parameter_rows[["module_name"]]))
  joint <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
    map = input[["map"]], random = NULL, DLL = "FIMS", silent = TRUE)
  fn <- objective[["fn"]]
  gr <- \(fixed) as.numeric(objective[["gr"]](fixed))
  points <- purrr::map(c(0, 0.01), function(shift) {
    fixed <- unname(objective[["par"]]) + shift
    marginal <- fn(fixed)
    gradient <- gr(fixed)
    full <- unname(objective[["env"]][["last.par"]])
    curvature <- joint[["he"]](full)
    report <- joint[["report"]](full)
    stopifnot(max(abs(gradient)) > 1e-2,
      max(abs(joint[["gr"]](full)[random_indices])) < 1e-6,
      abs(marginal - joint[["fn"]](full) -
        sum(log(diag(chol(curvature[random_indices, random_indices])))) +
        length(random_indices) * log(2 * pi) / 2) < 1e-8)
    list(fixed = fixed, marginal = marginal, gradient = gradient, report = report,
      parameters = full, joint_hessian = curvature,
      joint_gradient = as.numeric(joint[["gr"]](full)))
  })
  progress("optimize DoubleLogistic-joint")
  optimum <- stats::nlminb(objective[["par"]], fn, gr,
    control = list(iter.max = 400, eval.max = 1000))
  for (restart in seq_len(3L)) {
    if (optimum[["convergence"]] == 0L && max(abs(gr(optimum[["par"]]))) < 1e-4) break
    progress(paste("restart", restart))
    optimum <- stats::nlminb(optimum[["par"]], fn, gr,
      control = list(iter.max = 400, eval.max = 1000))
  }
  gradient <- gr(optimum[["par"]])
  progress(paste("convergence", optimum[["convergence"]], "gradient", max(abs(gradient))))
  stopifnot(optimum[["convergence"]] == 0L, max(abs(gradient)) < 1e-3)
  progress("uncertainty DoubleLogistic-joint")
  hessian <- stats::optimHess(optimum[["par"]], fn, gr,
    control = list(ndeps = rep(1e-4, fixed_count)))
  check_hessian <- stats::optimHess(optimum[["par"]], fn, gr,
    control = list(ndeps = rep(5e-5, fixed_count)))
  fixed_covariance <- chol2inv(chol(hessian))
  stopifnot(isTRUE(all.equal(fixed_covariance, chol2inv(chol(check_hessian)), tolerance = 1e-5)))
  uncertainty <- TMB::sdreport(objective, par.fixed = optimum[["par"]],
    hessian.fixed = hessian, getJointPrecision = TRUE, getReportCovariance = FALSE)
  stopifnot(uncertainty[["pdHess"]])
  covariance <- unname(as.matrix(solve(uncertainty[["jointPrecision"]])))
  chol(covariance)
  fn(optimum[["par"]])
  full <- unname(objective[["env"]][["last.par"]])
  report <- joint[["report"]](full)
  parameter_rows[["estimated"]] <- full
  parameter_rows[["uncertainty"]] <- sqrt(diag(covariance))
  report_summary <- summary(uncertainty, "report")
  report_rows <- tibble::tibble(label = rownames(report_summary),
    estimate = report_summary[, "Estimate"], uncertainty = report_summary[, "Std. Error"]) |>
    dplyr::group_by(.data$label) |>
    dplyr::mutate(oracle_id = dplyr::row_number()) |>
    dplyr::ungroup()
  derived <- metadata |>
    dplyr::filter(.data$estimation_type == "derived_quantity") |>
    dplyr::select(dplyr::all_of(keys)) |>
    dplyr::group_by(.data$label) |>
    dplyr::mutate(oracle_id = dplyr::row_number()) |>
    dplyr::ungroup() |>
    dplyr::left_join(report_rows, by = c("label", "oracle_id"), relationship = "one-to-one") |>
    dplyr::select(-dplyr::all_of("oracle_id"))
  stopifnot(nrow(covariance) == 14L, nrow(derived) == 2216L,
    all(is.finite(derived[["uncertainty"]])))
  for (fleet in fleets) {
    selected <- parameter_rows |>
      dplyr::filter(.data$module_name == "Selectivity", .data$fleet == .env$fleet)
    values <- stats::setNames(selected[["estimated"]], selected[["label"]])
    stopifnot(values[["inflection_point_asc"]] > 1, values[["inflection_point_asc"]] < 5,
      values[["inflection_point_desc"]] > 6, values[["inflection_point_desc"]] < 12,
      values[["slope_asc"]] > 0.2, values[["slope_desc"]] > 0.2,
      all(selected[["uncertainty"]] < 2))
  }
  joint_hessian <- joint[["he"]](full)
  off_diagonal <- joint_hessian[random_indices, random_indices]
  diag(off_diagonal) <- 0
  stopifnot(max(abs(off_diagonal)) > 1)
  native_sources <- list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE)
  source_md5 <- tools::md5sum(native_sources)
  names(source_md5) <- basename(names(source_md5))
  result <- list(
    provenance = list(native_declared_revision = reference[["provenance"]][["revision"]],
      native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
      input_fixture_md5 = unname(tools::md5sum(fixture)),
      generator_md5 = unname(tools::md5sum(generator)),
      R = R.version.string, TMB = as.character(utils::packageVersion("TMB")),
      optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
      method = paste("Historical native DoubleLogistic report generates deterministic observations.",
        "Integer multinomial counts use largest-remainder allocation at size 200.",
        "Fresh native Laplace optimization and native AD report uncertainty;",
        "fixed Hessian checked at halved numerical differentiation steps.",
        "No Julia evaluation, no native compilation, and no added priors.")),
    truth = list(parameters = truth_parameters, report = truth_report),
    cases = list("DoubleLogistic-joint" = list(
      name = "DoubleLogistic-joint", data = data, parameters = parameters, priors = NULL,
      points = points, marginal = optimum[["objective"]], report = report,
      parameters_table = parameter_rows, covariance = covariance, derived = derived,
      optimum = optimum, max_gradient = max(abs(gradient)),
      joint_hessian = joint_hessian, fixed_hessian = hessian,
      check_fixed_hessian = check_hessian))
  )
  portable <- function(value) {
    stopifnot(!typeof(value) %in% c("externalptr", "weakref", "environment", "closure"))
    if (is.character(value)) stopifnot(!any(grepl(
      "Users|AppData|copilot-worktrees", value, ignore.case = TRUE), na.rm = TRUE))
    if (is.list(value)) invisible(purrr::walk(value, portable))
    if (length(attributes(value))) invisible(purrr::walk(attributes(value), portable))
  }
  portable(result)
  saveRDS(result, output, compress = "xz")
  progress(paste("saved", basename(output)))
  invisible(result)
}

if (sys.nframe() == 0L) {
  arguments <- commandArgs(TRUE)
  if (length(arguments) != 2L) stop("Supply native checkout and NEW output RDS path.")
  generate_native_double_logistic_oracle(arguments[[1]], arguments[[2]])
}
