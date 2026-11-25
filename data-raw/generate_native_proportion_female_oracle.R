# Run in fresh R from the candidate root with the historical native checkout.
generate_native_proportion_female_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  generator <- file.path("data-raw", "generate_native_proportion_female_oracle.R")
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
  capture_case <- function(scalar) {
    name <- if (scalar) "ProportionFemale-scalar" else "ProportionFemale-per-age"
    progress(paste("generate observations", name))
    data <- source_case[["data"]] |>
      dplyr::mutate(uncertainty = dplyr::case_when(
        .data$type == "age_comp" ~ "~ dmultinom(prob = agecomp_proportion, size = 1000)",
        .data$type == "length_comp" ~ "~ dmultinom(prob = lengthcomp_proportion, size = 1000)",
        TRUE ~ .data$uncertainty
      ))
    female_values <- if (scalar) 0.37 else
      c(0.21, 0.28, 0.35, 0.43, 0.52, 0.62, 0.7, 0.76, 0.81, 0.78, 0.69, 0.57)
    female_rows <- source_case[["parameters"]] |>
      dplyr::filter(.data$module_name == "Population", .data$label == "proportion_female") |>
      dplyr::slice(rep(1L, length(female_values))) |>
      dplyr::mutate(age = if (scalar) NA_real_ else seq_len(12L),
        value = female_values, estimation_type = "constant")
    truth_parameters <- source_case[["parameters"]] |>
      dplyr::filter(!(.data$module_name == "Population" & .data$label == "proportion_female")) |>
      dplyr::bind_rows(female_rows)
    truth_input <- FIMS::initialize_fims(truth_parameters, FIMS::FIMSFrame(data), backend = "tmb")
    truth_fit <- FIMS::fit_fims(truth_input, optimize = FALSE, get_sd = FALSE)
    truth_report <- FIMS::get_obj(truth_fit)[["report"]](
      unname(unlist(truth_input[["parameters"]], use.names = FALSE))
    )
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
        .data$module_name == "Selectivity" & .data$label == "inflection_point" ~ .data$value + 0.12,
        .data$module_name == "Selectivity" & .data$label == "slope" ~ .data$value * 0.9,
        .data$module_name == "Fleet" & .data$label == "log_q" ~ .data$value + 0.04,
        .data$module_name == "Recruitment" & .data$label == "log_rzero" ~ .data$value - 0.04,
        TRUE ~ .data$value
      ))
    # Native registration exposes female-coordinate AD probes, but the fit
    # fixes these biology inputs to avoid unidentifiable sex-ratio scaling.
    native_parameters <- parameters |>
      dplyr::mutate(estimation_type = dplyr::if_else(
        .data$label == "proportion_female", "fixed_effects", .data$estimation_type))
    input <- FIMS::initialize_fims(native_parameters, FIMS::FIMSFrame(data), backend = "tmb")
    initial_fit <- FIMS::fit_fims(input, optimize = FALSE, get_sd = FALSE)
    metadata <- FIMS::get_estimates(initial_fit)
    native_female_metadata <- metadata |>
      dplyr::filter(.data$label == "proportion_female") |>
      dplyr::select(dplyr::all_of(c(keys, "module_id", "parameter_id", "input")))
    if (scalar) {
      metadata <- metadata |>
        dplyr::mutate(age = dplyr::if_else(.data$label == "proportion_female",
          NA_real_, .data$age))
    }
    all_fixed_names <- names(FIMS::get_obj(initial_fit)[["par"]])
    female_slots <- grep(".proportion_female.", all_fixed_names, fixed = TRUE)
    stopifnot(length(female_slots) == length(female_values))
    female_names <- strsplit(all_fixed_names[female_slots], ".", fixed = TRUE)
    female_ids <- purrr::map_int(female_names, \(parts) as.integer(parts[[4]]))
    female_locations <- match(female_ids, metadata[["parameter_id"]])
    stopifnot(!anyNA(female_locations),
      all(metadata[["label"]][female_locations] == "proportion_female"),
      isTRUE(all.equal(unname(metadata[["input"]][female_locations]), female_values,
        tolerance = 1e-14)))
    # Historical female JSON omits module_id; registered IDs identify its owner.
    metadata[["module_id"]][female_locations] <-
      purrr::map_int(female_names, \(parts) as.integer(parts[[2]]))
    original_map <- input[["map"]]
    fixed_map <- seq_along(input[["parameters"]][["p"]])
    fixed_map[female_slots] <- NA_integer_
    input[["map"]][["p"]] <- factor(fixed_map)
    objective <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
      map = input[["map"]], random = "re", DLL = "FIMS", silent = TRUE)
    names(objective[["par"]]) <- all_fixed_names[-female_slots]
    parameter_metadata <- function(parameter_names) {
      native_keys <- purrr::map_chr(strsplit(parameter_names, ".", fixed = TRUE),
        \(parts) paste(parts[1:4], collapse = "."))
      metadata_keys <- metadata |>
        dplyr::transmute(key = paste(
          .data$module_name, .data$module_id, .data$label, .data$parameter_id, sep = "."
        )) |>
        dplyr::pull(.data$key)
      locations <- match(native_keys, metadata_keys)
      if (anyNA(locations)) {
        stop("Unmatched native parameter metadata: ",
          paste(native_keys[is.na(locations)], collapse = ", "),
          "; female JSON keys: ",
          paste(metadata_keys[metadata[["label"]] == "proportion_female"], collapse = ", "))
      }
      rows <- metadata[locations, keys] |>
        dplyr::mutate(transform = "identity")
      stopifnot(!anyNA(rows[["module_name"]]))
      rows
    }
    fixed_count <- length(objective[["par"]])
    parameter_names <- c(names(objective[["par"]]),
      names(FIMS::get_random_names(input[["parameters"]][["re"]])))
    parameter_rows <- parameter_metadata(parameter_names) |>
      dplyr::mutate(estimation_type = c(rep("fixed_effects", fixed_count), rep("random_effects", 4L)))
    random_indices <- seq.int(fixed_count + 1L, length(parameter_names))
    stopifnot(fixed_count == 6L, length(random_indices) == 4L)
    joint <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
      map = input[["map"]], random = NULL, DLL = "FIMS", silent = TRUE)
    probe <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
      map = original_map, random = NULL, DLL = "FIMS", silent = TRUE)
    probe_names <- c(all_fixed_names,
      names(FIMS::get_random_names(input[["parameters"]][["re"]])))
    probe_rows <- parameter_metadata(probe_names)
    probe_order <- match(parameter_names, probe_names)
    stopifnot(length(probe[["par"]]) == 10L + length(female_values), !anyNA(probe_order))
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
        female_probe = list(parameters = unname(probe_values),
          gradient = as.numeric(probe[["gr"]](probe_values)), hessian = probe[["he"]](probe_values)))
    })
    counterfactual_values <- points[[1]][["female_probe"]][["parameters"]]
    changed_female <- if (scalar) 0.61 else rev(female_values)
    counterfactual_values[female_slots] <- changed_female
    counterfactual <- probe[["report"]](counterfactual_values)
    stopifnot(max(abs(unlist(counterfactual[["spawning_biomass"]]) -
      unlist(points[[1]][["report"]][["spawning_biomass"]]))) > 1)
    if (!scalar) {
      stopifnot(abs(counterfactual[["jnll"]] - points[[1]][["report"]][["jnll"]]) > 1e-2,
        max(abs(unlist(counterfactual[["expected_recruitment"]]) -
          unlist(points[[1]][["report"]][["expected_recruitment"]]))) > 1)
    }
    progress(paste("optimize", name))
    optimum <- stats::nlminb(objective[["par"]], fn, gr,
      control = list(iter.max = 400, eval.max = 1000))
    for (restart in seq_len(3L)) {
      if (optimum[["convergence"]] == 0L && max(abs(gr(optimum[["par"]]))) < 1e-4) break
      progress(paste(name, "restart", restart))
      optimum <- stats::nlminb(optimum[["par"]], fn, gr,
        control = list(iter.max = 400, eval.max = 1000))
    }
    gradient <- gr(optimum[["par"]])
    progress(paste(name, "convergence", optimum[["convergence"]], "gradient", max(abs(gradient))))
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
    stopifnot(nrow(covariance) == 10L, nrow(derived) == 2216L,
      all(is.finite(derived[["uncertainty"]])))
    list(name = name, data = data, parameters = parameters, priors = NULL,
      truth = list(parameters = truth_parameters, report = truth_report),
      proportion_female_length = length(female_values),
      native_female_metadata = native_female_metadata, female_probe_rows = probe_rows,
      female_counterfactual = list(values = changed_female, report = counterfactual),
      points = points, marginal = optimum[["objective"]], report = joint[["report"]](full),
      parameters_table = parameter_rows, covariance = covariance, derived = derived,
      optimum = optimum, max_gradient = max(abs(gradient)),
      joint_hessian = joint[["he"]](full), fixed_hessian = hessian,
      check_fixed_hessian = check_hessian)
  }
  cases <- purrr::map(c(TRUE, FALSE), capture_case)
  names(cases) <- purrr::map_chr(cases, \(case) case[["name"]])
  native_sources <- list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE)
  source_md5 <- tools::md5sum(native_sources)
  names(source_md5) <- basename(names(source_md5))
  result <- list(provenance = list(
    native_declared_revision = reference[["provenance"]][["revision"]],
    native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
    input_fixture_md5 = unname(tools::md5sum(fixture)), generator_md5 = unname(tools::md5sum(generator)),
    R = R.version.string, TMB = as.character(utils::packageVersion("TMB")),
    optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
    method = paste("Historical native scalar and nonuniform per-age proportion female.",
      "Native-generated observations; integer largest-remainder multinomial samples of 1000.",
      "Six identifiable selectivity/catchability/recruitment fixed effects, four coupled random effects.",
      "Female inputs held fixed through TMB map; scalar scaling cancels from recruitment likelihoods.",
      "Separate native joint tapes unlock female coordinates for derivative and feedback probes.",
      "Original female metadata preserved; missing module ID recovered from registered parameter IDs.",
      "Only the native scalar's probe join age is normalized from first age to NA.",
      "Native AD uncertainty and halved marginal Hessian step checks.",
      "No Julia evaluation, no native compilation, and no added priors.")), cases = cases)
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
  generate_native_proportion_female_oracle(arguments[[1]], arguments[[2]])
}
