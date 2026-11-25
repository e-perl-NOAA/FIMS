# Run in fresh R from the candidate root with the historical native checkout.
generate_native_yearly_selectivity_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  generator <- file.path("data-raw", "generate_native_yearly_selectivity_oracle.R")
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
  fleets <- c("fleet1", "survey1")
  data <- source_case[["data"]] |>
    dplyr::mutate(uncertainty = dplyr::case_when(
      .data$type == "age_comp" ~ "~ dmultinom(prob = agecomp_proportion, size = 1000)",
      .data$type == "length_comp" ~ "~ dmultinom(prob = lengthcomp_proportion, size = 1000)",
      TRUE ~ .data$uncertainty
    ))
  frame <- FIMS::FIMSFrame(data)
  base_values <- c(-1.6, -0.6, 0.4, 1.3, 1.8, stats::qlogis(0.9),
    1.5, 0.9, 0.25, -0.2, -0.8, -1.2)
  year_effects <- c(-0.3, 0.18, -0.12, 0.35, 0.05)
  fishing_rows <- purrr::map_dfr(seq_len(5L), function(year) {
    FIMS::setup_default_Selectivity(frame, "fleet1", "AgeSpecific") |>
      dplyr::mutate(
        timing = year,
        value = base_values + year_effects[[year]] * (13 - .data$age) / 12,
        estimation_type = dplyr::if_else(.data$age %in% c(2, 5, 9),
          "fixed_effects", "constant")
      )
  })
  survey_rows <- FIMS::setup_default_Selectivity(frame, "survey1", "AgeSpecific") |>
    dplyr::mutate(
      value = c(-1, -0.4, 0.2, 0.6, 1.2, stats::qlogis(0.9), 1.6, 1.1, 0.7, 0.15, -0.3, -0.9),
      estimation_type = dplyr::if_else(.data$age %in% c(2, 5, 9),
        "fixed_effects", "constant")
    )
  truth_parameters <- source_case[["parameters"]] |>
    dplyr::filter(.data$module_name != "Selectivity") |>
    dplyr::bind_rows(fishing_rows, survey_rows)
  progress("generate native year-by-age observations")
  truth_input <- FIMS::initialize_fims(truth_parameters, frame, backend = "tmb")
  truth_fit <- FIMS::fit_fims(truth_input, optimize = FALSE, get_sd = FALSE)
  truth_objective <- FIMS::get_obj(truth_fit)
  truth_vector <- unname(unlist(truth_input[["parameters"]], use.names = FALSE))
  truth_report <- truth_objective[["report"]](truth_vector)
  counts <- function(probabilities) {
    expected <- 1000 * probabilities / sum(probabilities)
    result <- floor(expected)
    remainder <- 1000 - sum(result)
    if (remainder > 0) {
      indices <- order(expected - result, decreasing = TRUE)[seq_len(remainder)]
      result[indices] <- result[indices] + 1
    }
    result / 1000
  }
  for (fleet_index in seq_along(fleets)) {
    for (specification in list(
      c("age_comp", "agecomp_expected", "age"),
      c("length_comp", "lengthcomp_expected", "length")
    )) {
      rows <- which(data[["fleet"]] == fleets[[fleet_index]] & data[["type"]] == specification[[1]])
      rows <- rows[order(data[["timing"]][rows], data[[specification[[3]]]][rows])]
      probabilities <- as.numeric(truth_report[[specification[[2]]]][[fleet_index]])
      bins <- length(unique(data[[specification[[3]]]][rows]))
      stopifnot(length(rows) == length(probabilities))
      data[["observed"]][rows] <- purrr::map(
        split(probabilities, rep(seq_len(length(rows) / bins), each = bins)), counts
      ) |>
        unlist(use.names = FALSE)
    }
    for (type in c("catch", "index")) {
      rows <- which(data[["fleet"]] == fleets[[fleet_index]] & data[["type"]] == type)
      if (!length(rows)) next
      rows <- rows[order(data[["timing"]][rows])]
      data[["observed"]][rows] <-
        as.numeric(truth_report[[paste0(type, "_expected")]][[fleet_index]])
    }
  }
  parameters <- truth_parameters |>
    dplyr::mutate(value = dplyr::if_else(
      .data$module_name == "Selectivity" & .data$estimation_type == "fixed_effects",
      .data$value + 0.15, .data$value
    ))
  progress("initialize AgeSpecific-year-by-age")
  input <- FIMS::initialize_fims(parameters, FIMS::FIMSFrame(data), backend = "tmb")
  initial_fit <- FIMS::fit_fims(input, optimize = FALSE, get_sd = FALSE)
  objective <- FIMS::get_obj(initial_fit)
  native_output <- jsonlite::fromJSON(FIMS::get_model_output(initial_fit), simplifyVector = FALSE)
  native_selectivity_metadata <- native_output[["selectivity"]]
  # Correct only native JSON's dimension declaration, not the numerical tape.
  # Its unmodified year-by-age header cannot be reshaped by the historical R API.
  stopifnot(length(native_output[["selectivity"]][[1]][["parameters"]][[1]][["values"]]) == 60L)
  native_output[["selectivity"]][[1]][["parameters"]][[1]][["dimensionality"]] <-
    list(header = list("n_years", "n_ages"), dimensions = list(5L, 12L))
  metadata <- FIMS:::reshape_json_estimates(
    jsonlite::toJSON(native_output, auto_unbox = TRUE, digits = NA, null = "null")
  )
  for (fleet in fleets) {
    locations <- which(metadata[["module_name"]] == "Selectivity" &
      !is.na(metadata[["fleet"]]) & metadata[["fleet"]] == fleet)
    rows <- parameters |>
      dplyr::filter(.data$module_name == "Selectivity", .data$fleet == .env$fleet)
    stopifnot(length(locations) == nrow(rows),
      isTRUE(all.equal(unname(metadata[["input"]][locations]),
        unname(rows[["value"]]), tolerance = 1e-5)))
    metadata[["year_i"]][locations] <- rows[["timing"]]
    metadata[["age"]][locations] <- rows[["age"]]
  }
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
    dplyr::mutate(estimation_type = c(rep("fixed_effects", fixed_count),
      rep("random_effects", 4L)), transform = "identity")
  random_indices <- seq.int(fixed_count + 1L, length(parameter_names))
  stopifnot(fixed_count == 20L, length(random_indices) == 4L,
    !anyNA(parameter_rows[["module_name"]]))
  selected_starts <- parameters |>
    dplyr::filter(.data$module_name == "Selectivity", .data$estimation_type == "fixed_effects") |>
    dplyr::pull(.data$value)
  stopifnot(isTRUE(all.equal(unname(objective[["par"]][seq_along(selected_starts)]),
    unname(selected_starts), tolerance = 1e-14)))
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
  progress("optimize AgeSpecific-year-by-age")
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
  progress("uncertainty AgeSpecific-year-by-age")
  hessian <- stats::optimHess(optimum[["par"]], fn, gr,
    control = list(ndeps = rep(1e-4, fixed_count)))
  check_hessian <- stats::optimHess(optimum[["par"]], fn, gr,
    control = list(ndeps = rep(5e-5, fixed_count)))
  stopifnot(isTRUE(all.equal(chol2inv(chol(hessian)),
    chol2inv(chol(check_hessian)), tolerance = 1e-5)))
  uncertainty <- TMB::sdreport(objective, par.fixed = optimum[["par"]],
    hessian.fixed = hessian, getJointPrecision = TRUE, getReportCovariance = FALSE)
  stopifnot(uncertainty[["pdHess"]])
  covariance <- unname(as.matrix(solve(uncertainty[["jointPrecision"]])))
  chol(covariance)
  fn(optimum[["par"]])
  full <- unname(objective[["env"]][["last.par"]])
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
  selected <- parameter_rows |>
    dplyr::filter(.data$module_name == "Selectivity")
  progress(paste("selectivity SE range", paste(range(selected[["uncertainty"]]), collapse = " ")))
  off_diagonal <- joint[["he"]](full)[random_indices, random_indices]
  diag(off_diagonal) <- 0
  stopifnot(nrow(covariance) == 24L, nrow(derived) == 2216L,
    all(is.finite(derived[["uncertainty"]])), max(abs(off_diagonal)) > 1,
    all(selected[["uncertainty"]] > 0 & selected[["uncertainty"]] < 1))
  native_sources <- list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE)
  source_md5 <- tools::md5sum(native_sources)
  names(source_md5) <- basename(names(source_md5))
  result <- list(provenance = list(
    native_declared_revision = reference[["provenance"]][["revision"]],
    native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
    input_fixture_md5 = unname(tools::md5sum(fixture)),
    generator_md5 = unname(tools::md5sum(generator)),
    R = R.version.string, TMB = as.character(utils::packageVersion("TMB")),
    optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
    method = paste("Historical native AgeSpecific year-by-age fishing and static survey vectors.",
      "Native-generated observations; integer largest-remainder multinomial samples of 1000.",
      "Ages 2, 5 and 9 estimated in each fishing year and the static survey.",
      "Other selectivity logits and fishing mortalities fixed to remove confounding.",
      "Only the malformed native JSON dimension header is corrected before metadata reshaping;",
      "the original selectivity JSON is preserved. Its rounded inputs are checked to 1e-5;",
      "registered active starts are checked at full precision to 1e-14.",
      "Semantic year/age coordinates recovered from native registered slots and checked inputs.",
      "Fresh native Laplace fits and native AD uncertainty; halved Hessian step checks.",
      "No Julia evaluation, no native compilation, and no added priors.")),
    native_selectivity_metadata = native_selectivity_metadata,
    cases = list("AgeSpecific-year-by-age" = list(
      name = "AgeSpecific-year-by-age", data = data, parameters = parameters, priors = NULL,
      truth = list(parameters = truth_parameters, report = truth_report),
      selectivity_lengths = c(60L, 12L),
      points = points, marginal = optimum[["objective"]], report = joint[["report"]](full),
      parameters_table = parameter_rows, covariance = covariance, derived = derived,
      optimum = optimum, max_gradient = max(abs(gradient)),
      joint_hessian = joint[["he"]](full), fixed_hessian = hessian,
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
  generate_native_yearly_selectivity_oracle(arguments[[1]], arguments[[2]])
}
