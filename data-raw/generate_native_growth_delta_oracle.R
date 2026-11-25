# Run in fresh R from the candidate root with the historical native checkout.
generate_native_growth_delta_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  generator <- file.path("data-raw", "generate_native_growth_delta_oracle.R")
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
  variability_labels <- c(
    "log_sd_mean_length_young", "log_sd_mean_length_old", "log_sd_growth_coefficient",
    "mean_length_young_mean_length_old_logit_corr",
    "mean_length_young_growth_coefficient_logit_corr",
    "mean_length_old_growth_coefficient_logit_corr"
  )
  positive_labels <- c("mean_length_young", "mean_length_old", "growth_coefficient")
  data <- source_case[["data"]] |>
    dplyr::mutate(uncertainty = dplyr::case_when(
      .data$type == "age_comp" ~ "~ dmultinom(prob = agecomp_proportion, size = 1000)",
      .data$type == "length_comp" ~ "~ dmultinom(prob = lengthcomp_proportion, size = 1000)",
      TRUE ~ .data$uncertainty
    ))
  stopifnot(!any(data[["type"]] == "age_to_length_conversion"))
  delta_rows <- source_case[["parameters"]] |>
    dplyr::filter(.data$module_name == "Growth") |>
    dplyr::slice(rep(1L, 6L)) |>
    dplyr::mutate(label = variability_labels,
      value = c(log(0.11), log(0.1), log(0.32), 0.3, -0.25, 0.2),
      age = NA_real_, estimation_type = c(rep("fixed_effects", 3L), rep("constant", 3L)))
  truth_parameters <- source_case[["parameters"]] |>
    dplyr::filter(.data$label != "length_at_age_sd_at_reference_ages") |>
    dplyr::mutate(estimation_type = dplyr::if_else(
      .data$module_name == "Selectivity", "constant", .data$estimation_type)) |>
    dplyr::bind_rows(delta_rows)
  progress("generate native delta-method observations")
  truth_input <- FIMS::initialize_fims(truth_parameters, FIMS::FIMSFrame(data), backend = "tmb")
  truth_input[["model"]]$ReportAgeToLengthConversionDerivedTensor(TRUE)
  truth_fit <- FIMS::fit_fims(truth_input, optimize = FALSE, get_sd = FALSE)
  truth_report <- FIMS::get_obj(truth_fit)[["report"]](
    unname(unlist(truth_input[["parameters"]], use.names = FALSE))
  )
  stopifnot(all(unlist(truth_report[["age_to_length_conversion_derived_used"]]) == 1))
  stopifnot(all(lengths(truth_report[["age_to_length_conversion_derived"]]) == 5L * 12L * 23L))
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
  fleets <- c("fleet1", "survey1")
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
    dplyr::mutate(value = dplyr::case_when(
      .data$module_name == "Growth" & .data$label == "mean_length_young" ~ .data$value * 1.03,
      .data$module_name == "Growth" & .data$label == "mean_length_old" ~ .data$value * 0.98,
      .data$module_name == "Growth" & .data$label == "growth_coefficient" ~ .data$value * 0.93,
      .data$label %in% variability_labels[1:3] ~ .data$value + 0.07,
      TRUE ~ .data$value
    ))
  # Register correlations for an independent six-coordinate derivative probe;
  # fix them through TMB's map in the identifiable optimization.
  native_parameters <- parameters |>
    dplyr::mutate(estimation_type = dplyr::if_else(
      .data$label %in% variability_labels[4:6], "fixed_effects", .data$estimation_type))
  input <- FIMS::initialize_fims(native_parameters, FIMS::FIMSFrame(data), backend = "tmb")
  input[["model"]]$ReportAgeToLengthConversionDerivedTensor(TRUE)
  initial_fit <- FIMS::fit_fims(input, optimize = FALSE, get_sd = FALSE)
  metadata <- FIMS::get_estimates(initial_fit)
  all_fixed_names <- names(FIMS::get_obj(initial_fit)[["par"]])
  original_map <- input[["map"]]
  correlation_slots <- grep("logit_corr", all_fixed_names, fixed = TRUE)
  stopifnot(length(correlation_slots) == 3L)
  fixed_map <- seq_along(input[["parameters"]][["p"]])
  fixed_map[correlation_slots] <- NA_integer_
  input[["map"]][["p"]] <- factor(fixed_map)
  objective <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
    map = input[["map"]], random = "re", DLL = "FIMS", silent = TRUE)
  names(objective[["par"]]) <- all_fixed_names[-correlation_slots]
  parameter_metadata <- function(parameter_names) {
    native_keys <- purrr::map_chr(strsplit(parameter_names, ".", fixed = TRUE),
      \(parts) paste(parts[1:4], collapse = "."))
    metadata_keys <- metadata |>
      dplyr::transmute(key = paste(
        .data$module_name, .data$module_id, .data$label, .data$parameter_id, sep = "."
      )) |>
      dplyr::pull(.data$key)
    rows <- metadata[match(native_keys, metadata_keys), keys] |>
      dplyr::mutate(transform = dplyr::if_else(
        .data$module_name == "Growth" & .data$label %in% positive_labels, "exp", "identity"
      ))
    stopifnot(!anyNA(rows[["module_name"]]))
    rows
  }
  fixed_count <- length(objective[["par"]])
  parameter_names <- c(names(objective[["par"]]),
    names(FIMS::get_random_names(input[["parameters"]][["re"]])))
  parameter_rows <- parameter_metadata(parameter_names) |>
    dplyr::mutate(estimation_type = c(rep("fixed_effects", fixed_count), rep("random_effects", 4L)))
  random_indices <- seq.int(fixed_count + 1L, length(parameter_names))
  stopifnot(fixed_count == 8L, length(random_indices) == 4L)
  joint <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
    map = input[["map"]], random = NULL, DLL = "FIMS", silent = TRUE)
  probe <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
    map = original_map, random = NULL, DLL = "FIMS", silent = TRUE)
  probe_names <- c(all_fixed_names,
    names(FIMS::get_random_names(input[["parameters"]][["re"]])))
  probe_rows <- parameter_metadata(probe_names)
  probe_order <- match(parameter_names, probe_names)
  stopifnot(length(probe[["par"]]) == 15L, !anyNA(probe_order))
  fn <- objective[["fn"]]
  gr <- \(fixed) as.numeric(objective[["gr"]](fixed))
  points <- purrr::map(c(0, 0.01), function(shift) {
    fixed <- unname(objective[["par"]]) + shift
    marginal <- fn(fixed)
    gradient <- gr(fixed)
    full <- unname(objective[["env"]][["last.par"]])
    curvature <- joint[["he"]](full)
    report <- joint[["report"]](full)
    probe_values <- probe[["par"]]
    probe_values[probe_order] <- full
    stopifnot(max(abs(gradient)) > 1e-2,
      max(abs(joint[["gr"]](full)[random_indices])) < 1e-6,
      abs(probe[["fn"]](probe_values) - joint[["fn"]](full)) < 1e-10,
      abs(marginal - joint[["fn"]](full) -
        sum(log(diag(chol(curvature[random_indices, random_indices])))) +
        length(random_indices) * log(2 * pi) / 2) < 1e-8)
    list(fixed = fixed, marginal = marginal, gradient = gradient, report = report,
      parameters = full, joint_hessian = curvature,
      joint_gradient = as.numeric(joint[["gr"]](full)),
      variability_probe = list(parameters = unname(probe_values),
        gradient = as.numeric(probe[["gr"]](probe_values)), hessian = probe[["he"]](probe_values)))
  })
  progress("optimize VonBertalanffySchnute-delta")
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
  transformed <- parameter_rows[["transform"]] == "exp"
  parameter_rows[["estimated"]] <- full
  parameter_rows[["estimated"]][transformed] <- exp(full[transformed])
  jacobian <- ifelse(transformed, exp(full), 1)
  parameter_rows[["uncertainty"]] <- sqrt(diag(covariance)) * jacobian
  growth_indices <- which(parameter_rows[["module_name"]] == "Growth")
  natural_values <- exp(full[growth_indices])
  natural_covariance <- diag(natural_values) %*% covariance[growth_indices, growth_indices] %*%
    diag(natural_values)
  natural_growth <- parameter_rows[growth_indices, keys] |>
    dplyr::mutate(estimated = natural_values, uncertainty = sqrt(diag(natural_covariance)))
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
  progress(paste("growth effects", length(growth_indices), "report rows", nrow(derived),
    "minimum covariance eigenvalue", min(eigen(covariance, symmetric = TRUE, only.values = TRUE)[["values"]])))
  stopifnot(nrow(covariance) == 12L, length(growth_indices) == 6L,
    all(is.finite(derived[["uncertainty"]])), all(natural_growth[["uncertainty"]] > 0))
  native_sources <- list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE)
  source_md5 <- tools::md5sum(native_sources)
  names(source_md5) <- basename(names(source_md5))
  result <- list(provenance = list(
    native_declared_revision = reference[["provenance"]][["revision"]],
    native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
    input_fixture_md5 = unname(tools::md5sum(fixture)), generator_md5 = unname(tools::md5sum(generator)),
    R = R.version.string, TMB = as.character(utils::packageVersion("TMB")),
    optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
    method = paste("Historical native six-parameter delta-method growth variability.",
      "Historical optional derived conversion tensor reporting explicitly enabled.",
      "Native-generated observations; integer largest-remainder multinomial samples of 1000.",
      "Three growth means/coefficient and three log SDs estimated, with catchability,",
      "recruitment level and four coupled random effects; no added priors.",
      "Nonzero correlations registered but fixed by native TMB map during fitting;",
      "a second native joint tape unlocks all six variability coordinates for AD probes.",
      "Natural-scale growth covariance uses native working-scale covariance and exact exp Jacobians.",
      "No Julia evaluation, no native compilation; marginal covariance checked with halved steps.")),
    cases = list("VonBertalanffySchnute-delta" = list(
      name = "VonBertalanffySchnute-delta", data = data, parameters = parameters, priors = NULL,
      truth = list(parameters = truth_parameters, report = truth_report),
      growth_variability = "delta", variability_probe_rows = probe_rows,
      natural_growth = natural_growth, natural_growth_covariance = unname(natural_covariance),
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
  generate_native_growth_delta_oracle(arguments[[1]], arguments[[2]])
}
