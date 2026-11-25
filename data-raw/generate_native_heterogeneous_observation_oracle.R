# Run in fresh R from the candidate root with the historical native checkout.
generate_native_heterogeneous_observation_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  generator <- file.path("data-raw", "generate_native_heterogeneous_observation_oracle.R")
  fixture <- file.path("tests", "testthat", "fixtures", "native-configuration-oracle.rds")
  reference <- readRDS(fixture)
  source_case <- reference[["cases"]][["VonBertalanffySchnute-joint-priors"]]
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
  bins <- list(fleet1 = seq(0, 1100, 100), survey1 = c(0, 150, 300, 450, 600, 750, 900, 1100))
  composition_rows <- purrr::imap_dfr(bins, function(lengths, fleet) {
    tidyr::expand_grid(timing = seq_len(5L), length = lengths) |>
      dplyr::mutate(type = "length_comp", fleet = fleet, age = NA_real_,
        observed = 1 / length(lengths), unit = "proportion",
        uncertainty = "~ dmultinom(prob = lengthcomp_proportion, size = 1000)")
  })
  extra_index <- source_case[["data"]] |>
    dplyr::filter(.data$type == "index") |>
    dplyr::mutate(fleet = "fleet1")
  data <- source_case[["data"]] |>
    dplyr::filter(.data$type != "length_comp",
      !(.data$type == "age_comp" & .data$fleet == "survey1")) |>
    dplyr::bind_rows(composition_rows, extra_index) |>
    dplyr::mutate(uncertainty = dplyr::case_when(
      .data$type == "age_comp" ~ "~ dmultinom(prob = agecomp_proportion, size = 1000)",
      .data$type == "catch" ~ "~ dnorm(mean = catch_expected, sd = 100)",
      .data$type == "index" & .data$fleet == "survey1" ~ "~ dnorm(mean = index_expected, sd = 100)",
      .data$type == "index" ~ "~ dlnorm(meanlog = log_index_expected, sdlog = 0.1)",
      TRUE ~ .data$uncertainty
    ))
  truth_parameters <- source_case[["parameters"]] |>
    dplyr::mutate(
      estimation_type = dplyr::case_when(
        .data$module_name == "Growth" ~ "constant",
        .data$module_name == "Fleet" & .data$label == "log_q" ~ "fixed_effects",
        TRUE ~ .data$estimation_type),
      value = dplyr::if_else(.data$module_name == "Fleet" & .data$fleet == "fleet1" &
        .data$label == "log_q", log(5e-7), .data$value))
  progress("generate native heterogeneous observations")
  truth_input <- FIMS::initialize_fims(truth_parameters, FIMS::FIMSFrame(data), backend = "tmb")
  truth_input[["model"]]$ReportAgeToLengthConversionDerivedTensor(TRUE)
  truth_fit <- FIMS::fit_fims(truth_input, optimize = FALSE, get_sd = FALSE)
  truth_report <- FIMS::get_obj(truth_fit)[["report"]](
    unname(unlist(truth_input[["parameters"]], use.names = FALSE))
  )
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
      if (!length(rows)) next
      rows <- rows[order(data[["timing"]][rows], data[[specification[[3]]]][rows])]
      probabilities <- as.numeric(truth_report[[specification[[2]]]][[fleet_index]])
      n_bins <- length(unique(data[[specification[[3]]]][rows]))
      stopifnot(length(rows) == length(probabilities))
      data[["observed"]][rows] <- purrr::map(
        split(probabilities, rep(seq_len(5L), each = n_bins)), counts
      ) |> unlist(use.names = FALSE)
    }
    for (type in c("catch", "index")) {
      rows <- which(data[["fleet"]] == fleets[[fleet_index]] & data[["type"]] == type)
      if (!length(rows)) next
      rows <- rows[order(data[["timing"]][rows])]
      expected <- as.numeric(truth_report[[paste0(type, "_expected")]][[fleet_index]])
      scales <- if (type == "index" && fleet_index == 1L) {
        c(0.06, 0.08, 0.1, 0.12, 0.14)
      } else {
        expected * c(0.025, 0.03, 0.035, 0.04, 0.045)
      }
      residual <- c(-0.2, 0.1, 0.25, -0.15, 0.05)
      lognormal <- type == "index" && fleet_index == 1L
      data[["observed"]][rows] <- if (lognormal) expected * exp(scales * residual) else
        expected + scales * residual
      data[["uncertainty"]][rows] <- if (lognormal) {
        paste0("~ dlnorm(meanlog = log_index_expected, sdlog = ", sprintf("%.17g", scales), ")")
      } else {
        paste0("~ dnorm(mean = ", type, "_expected, sd = ", sprintf("%.17g", scales), ")")
      }
    }
  }
  # Omitted cells and explicit -999 values exercise the same missing-data contract.
  data <- data |>
    dplyr::filter(
      !(.data$type == "catch" & .data$timing == 2L),
      !(.data$type == "age_comp" & .data$timing == 3L),
      !(.data$type == "length_comp" & .data$fleet == "fleet1" & .data$timing == 2L),
      !(.data$type == "length_comp" & .data$fleet == "survey1" & .data$timing == 4L)
    ) |>
    dplyr::mutate(
      observed = dplyr::case_when(
        .data$type == "index" & .data$fleet == "fleet1" & .data$timing == 3L ~ -999,
        .data$type == "index" & .data$fleet == "survey1" & .data$timing == 4L ~ -999,
        TRUE ~ .data$observed),
      uncertainty = dplyr::if_else(.data$type == "index" &
        (.data$observed == -999 | is.na(.data$observed)), NA_character_, .data$uncertainty))
  parameters <- truth_parameters |>
    dplyr::mutate(value = dplyr::case_when(
      .data$module_name == "Selectivity" & .data$label == "inflection_point" ~ .data$value + 0.12,
      .data$module_name == "Selectivity" & .data$label == "slope" ~ .data$value * 0.9,
      .data$module_name == "Fleet" & .data$label == "log_q" ~ .data$value + 0.04,
      .data$module_name == "Recruitment" & .data$label == "log_rzero" ~ .data$value - 0.04,
      TRUE ~ .data$value))
  frame <- FIMS::FIMSFrame(data)
  model_data <- FIMS::get_data(frame)
  input <- FIMS::initialize_fims(parameters, frame, backend = "tmb")
  input[["model"]]$ReportAgeToLengthConversionDerivedTensor(TRUE)
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
    )) |> dplyr::pull(.data$key)
  parameter_rows <- metadata[match(native_keys, metadata_keys), keys] |>
    dplyr::mutate(estimation_type = c(rep("fixed_effects", fixed_count), rep("random_effects", 4L)),
      transform = "identity")
  random_indices <- seq.int(fixed_count + 1L, length(parameter_names))
  stopifnot(fixed_count == 7L, length(random_indices) == 4L, !anyNA(parameter_rows[["module_name"]]))
  joint <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
    map = input[["map"]], random = NULL, DLL = "FIMS", silent = TRUE)
  observation_likelihood <- function(report) {
    rows <- model_data |>
      dplyr::filter(.data$type %in% c("catch", "index", "age_comp", "length_comp")) |>
      dplyr::arrange(match(.data$fleet, fleets), .data$type, .data$timing, .data$age, .data$length)
    purrr::map_dfr(split(rows, interaction(rows[["fleet"]], rows[["type"]], rows[["timing"]],
      drop = TRUE)), function(group) {
      fleet <- match(group[["fleet"]][[1]], fleets)
      type <- group[["type"]][[1]]
      year <- group[["timing"]][[1]]
      missing <- all(group[["observed"]] == -999)
      label <- switch(type, age_comp = "agecomp_expected", length_comp = "lengthcomp_expected",
        paste0(type, "_expected"))
      family <- if (missing) NA_character_ else
        FIMS:::parse_data_distribution(group[["uncertainty"]])[["family"]][[1]]
      if (missing) {
        lpdf <- 0
      } else if (type %in% c("catch", "index")) {
        expected <- report[[label]][[fleet]][[year]]
        parsed <- FIMS:::parse_data_distribution(group[["uncertainty"]])
        lpdf <- if (family == "dnorm") stats::dnorm(group[["observed"]], expected,
          unlist(parsed[["sd"]]), log = TRUE) else
          stats::dlnorm(group[["observed"]], log(expected), unlist(parsed[["sdlog"]]), log = TRUE)
      } else {
        n_bins <- nrow(group)
        expected <- matrix(report[[label]][[fleet]], ncol = n_bins, byrow = TRUE)[year, ]
        lpdf <- stats::dmultinom(round(group[["observed"]] * 1000), prob = expected, log = TRUE)
      }
      tibble::tibble(fleet = fleets[[fleet]], label = label, year_i = year,
        distribution = family, missing = missing, lpdf = as.numeric(lpdf))
    }) |>
      dplyr::arrange(match(.data$fleet, fleets), .data$label, .data$year_i)
  }
  check_likelihood <- function(report, rows, full) {
    observation_nll <- rows |>
      dplyr::summarize(nll = -sum(.data$lpdf), .by = c("fleet", "label"))
    process_nll <- -sum(stats::dnorm(full[random_indices], sd = exp(
      parameters[["value"]][parameters[["label"]] == "log_sd"]), log = TRUE))
    stopifnot(abs(report[["jnll"]] - sum(observation_nll[["nll"]]) - process_nll) < 1e-8,
      all(rows[["lpdf"]][rows[["missing"]]] == 0))
  }
  fn <- objective[["fn"]]
  gr <- \(fixed) as.numeric(objective[["gr"]](fixed))
  points <- purrr::map(c(0, 0.01), function(shift) {
    fixed <- unname(objective[["par"]]) + shift
    marginal <- fn(fixed)
    gradient <- gr(fixed)
    full <- unname(objective[["env"]][["last.par"]])
    curvature <- joint[["he"]](full)
    report <- joint[["report"]](full)
    likelihood <- observation_likelihood(report)
    check_likelihood(report, likelihood, full)
    stopifnot(max(abs(gradient)) > 1e-2,
      max(abs(joint[["gr"]](full)[random_indices])) < 1e-6,
      abs(marginal - joint[["fn"]](full) -
        sum(log(diag(chol(curvature[random_indices, random_indices])))) +
        length(random_indices) * log(2 * pi) / 2) < 1e-8)
    list(fixed = fixed, marginal = marginal, gradient = gradient, report = report,
      parameters = full, joint_hessian = curvature,
      joint_gradient = as.numeric(joint[["gr"]](full)), observation_likelihood = likelihood)
  })
  progress("optimize heterogeneous observations")
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
  report <- joint[["report"]](full)
  likelihood <- observation_likelihood(report)
  check_likelihood(report, likelihood, full)
  parameter_rows[["estimated"]] <- full
  parameter_rows[["uncertainty"]] <- sqrt(diag(covariance))
  report_summary <- summary(uncertainty, "report")
  report_rows <- tibble::tibble(label = rownames(report_summary),
    estimate = report_summary[, "Estimate"], uncertainty = report_summary[, "Std. Error"]) |>
    dplyr::group_by(.data$label) |> dplyr::mutate(oracle_id = dplyr::row_number()) |> dplyr::ungroup()
  derived <- metadata |>
    dplyr::filter(.data$estimation_type == "derived_quantity") |>
    dplyr::select(dplyr::all_of(keys)) |>
    dplyr::group_by(.data$label) |> dplyr::mutate(oracle_id = dplyr::row_number()) |>
    dplyr::ungroup() |>
    dplyr::left_join(report_rows, by = c("label", "oracle_id"), relationship = "one-to-one") |>
    dplyr::select(-dplyr::all_of("oracle_id"))
  stopifnot(nrow(covariance) == 11L, all(is.finite(derived[["uncertainty"]])),
    identical(lengths(report[["lengthcomp_expected"]]), c(60L, 40L)),
    length(unique(derived[["label"]])) == 32L)
  source_md5 <- tools::md5sum(list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE))
  names(source_md5) <- basename(names(source_md5))
  result <- list(provenance = list(
    native_declared_revision = reference[["provenance"]][["revision"]],
    native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
    input_fixture_md5 = unname(tools::md5sum(fixture)), generator_md5 = unname(tools::md5sum(generator)),
    R = R.version.string, TMB = as.character(utils::packageVersion("TMB")),
    optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
    method = paste("Historical native growth-derived heterogeneous observation reference.",
      "Unequal 12/8 length bins; fishing age/length and survey length-only coverage.",
      "Normal catch/survey index, lognormal fishing index; per-year scales.",
      "Native high-level support is one family per fleet/data stream, not mixed families within it.",
      "Omitted and explicit -999 observations; independent R row densities sum to native joint NLL.",
      "Seven identifiable fixed and four coupled random effects, full native AD uncertainty.",
      "Native Hessian checked at halved step; no Julia evaluation, compilation or added priors.")),
    cases = list("Heterogeneous-observations" = list(
      name = "Heterogeneous-observations", data = data, parameters = parameters, priors = NULL,
      truth = list(parameters = truth_parameters, report = truth_report),
      length_bins = bins, model_data = model_data, observation_likelihood = likelihood,
      points = points, marginal = optimum[["objective"]], report = report,
      parameters_table = parameter_rows, covariance = covariance, derived = derived,
      optimum = optimum, max_gradient = max(abs(gradient)), joint_hessian = joint[["he"]](full),
      fixed_hessian = hessian, check_fixed_hessian = check_hessian)))
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
  generate_native_heterogeneous_observation_oracle(arguments[[1]], arguments[[2]])
}
