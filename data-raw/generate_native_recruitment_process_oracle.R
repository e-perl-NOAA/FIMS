# Run in fresh R from the candidate root with the historical native checkout.
generate_native_recruitment_process_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  generator <- file.path("data-raw", "generate_native_recruitment_process_oracle.R")
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
  ricker_parameters <- source_case[["parameters"]] |>
    dplyr::mutate(module_type = dplyr::if_else(
      .data$module_name == "Recruitment", "Ricker", .data$module_type))
  ricker_error <- tryCatch({
    FIMS::initialize_fims(ricker_parameters, FIMS::FIMSFrame(source_case[["data"]]),
      backend = "tmb")
    stop("Unexpected historical Ricker support.")
  }, error = conditionMessage)
  stopifnot(grepl("RickerRecruitment.*not found", ricker_error),
    !any(grepl("Ricker", getNamespaceExports("FIMS"))))
  original_process_distribution <- FIMS::initialize_process_distribution
  native_process_family <- "Dnorm"
  # The historical high-level initializer hard-codes gaussian(). Select its
  # existing native constructor explicitly; do not edit historical sources.
  process_distribution <- function(module, par, family = NULL, sd) {
    original_process_distribution(module, par,
      family = if (native_process_family == "Dlnorm") FIMS::lognormal() else stats::gaussian(),
      sd = sd)
  }
  utils::assignInNamespace("initialize_process_distribution", process_distribution, ns = "FIMS")
  on.exit(utils::assignInNamespace("initialize_process_distribution",
    original_process_distribution, ns = "FIMS"), add = TRUE)
  keys <- c("module_name", "fleet", "label", "year_i", "age", "length")
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
  capture_case <- function(mode, family) {
    native_process_family <<- family
    name <- paste("Recruitment", mode, family, sep = "-")
    progress(paste("generate observations", name))
    data <- source_case[["data"]] |>
      dplyr::mutate(uncertainty = dplyr::case_when(
        .data$type == "age_comp" ~ "~ dmultinom(prob = agecomp_proportion, size = 1000)",
        .data$type == "length_comp" ~ "~ dmultinom(prob = lengthcomp_proportion, size = 1000)",
        TRUE ~ .data$uncertainty))
    truth_parameters <- source_case[["parameters"]] |>
      dplyr::mutate(
        value = dplyr::case_when(
          .data$label == "log_devs" & mode == "log_r" ~ log(1e6) + c(0.12, -0.08, 0.05, 0.18)[match(.data$timing, 2:5)],
          .data$label == "log_devs" & family == "Dlnorm" ~ c(0.72, 1.08, 0.84, 1.16)[match(.data$timing, 2:5)],
          .data$label == "log_rzero" & mode == "log_r" & family == "Dlnorm" ~ log(12),
          .data$label == "log_sd" ~ log(0.25),
          TRUE ~ .data$value),
        distribution = dplyr::if_else(.data$module_name == "Recruitment" &
          .data$label %in% c("log_devs", "log_sd"), family, as.character(.data$distribution)),
        label = dplyr::if_else(.data$label == "log_devs", mode, .data$label))
    truth_input <- FIMS::initialize_fims(truth_parameters, FIMS::FIMSFrame(data), backend = "tmb")
    truth_fit <- FIMS::fit_fims(truth_input, optimize = FALSE, get_sd = FALSE)
    truth_report <- FIMS::get_obj(truth_fit)[["report"]](
      unname(unlist(truth_input[["parameters"]], use.names = FALSE)))
    fleets <- c("fleet1", "survey1")
    for (fleet_index in seq_along(fleets)) {
      for (specification in list(c("age_comp", "agecomp_expected", "age"),
        c("length_comp", "lengthcomp_expected", "length"))) {
        rows <- which(data[["fleet"]] == fleets[[fleet_index]] &
          data[["type"]] == specification[[1]])
        rows <- rows[order(data[["timing"]][rows], data[[specification[[3]]]][rows])]
        probabilities <- as.numeric(truth_report[[specification[[2]]]][[fleet_index]])
        bins <- length(unique(data[[specification[[3]]]][rows]))
        stopifnot(length(rows) == length(probabilities))
        data[["observed"]][rows] <- purrr::map(
          split(probabilities, rep(seq_len(length(rows) / bins), each = bins)), counts
        ) |> unlist(use.names = FALSE)
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
        .data$label %in% c("log_q", "log_rzero") ~ .data$value + 0.04,
        TRUE ~ .data$value))
    input <- FIMS::initialize_fims(parameters, FIMS::FIMSFrame(data), backend = "tmb")
    initial_fit <- FIMS::fit_fims(input, optimize = FALSE, get_sd = FALSE)
    objective <- FIMS::get_obj(initial_fit)
    metadata <- FIMS::get_estimates(initial_fit)
    fixed_count <- length(objective[["par"]])
    parameter_names <- c(names(objective[["par"]]),
      names(FIMS::get_random_names(input[["parameters"]][["re"]])))
    native_process_metadata <- metadata |>
      dplyr::filter(.data$module_name == "Recruitment")
    if (mode == "log_r") {
      # Historical JSON omits log_r. Registered coordinates and checked input
      # values recover ownership; numerical outputs still come from native AD.
      registered <- strsplit(tail(parameter_names, 4L), ".", fixed = TRUE)
      process_rows <- parameters |>
        dplyr::filter(.data$module_name == "Recruitment", .data$label == "log_r") |>
        dplyr::arrange(.data$timing)
      stopifnot(all(purrr::map_chr(registered, \(parts) parts[[3]]) == "log_r"))
      value_check <- all.equal(unname(unlist(input[["parameters"]][["re"]])),
        unname(process_rows[["value"]]), tolerance = 1e-14)
      if (!isTRUE(value_check)) stop("Native log_r registration: ", paste(value_check, collapse = ";"))
      metadata <- dplyr::bind_rows(metadata, process_rows |>
        dplyr::mutate(module_id = purrr::map_int(registered, \(parts) as.integer(parts[[2]])),
          parameter_id = purrr::map_int(registered, \(parts) as.integer(parts[[4]])),
          year_i = .data$timing, input = .data$value))
    }
    native_keys <- purrr::map_chr(strsplit(parameter_names, ".", fixed = TRUE),
      \(parts) paste(parts[1:4], collapse = "."))
    metadata_keys <- metadata |>
      dplyr::transmute(key = paste(.data$module_name, .data$module_id,
        .data$label, .data$parameter_id, sep = ".")) |> dplyr::pull(.data$key)
    if (anyNA(match(native_keys, metadata_keys))) {
      stop("Unmatched native keys: ", paste(native_keys[is.na(match(native_keys, metadata_keys))],
        collapse = ","), "; recruitment metadata: ",
        paste(metadata_keys[metadata[["module_name"]] == "Recruitment"], collapse = ","))
    }
    parameter_rows <- metadata[match(native_keys, metadata_keys), keys] |>
      dplyr::mutate(estimation_type = c(rep("fixed_effects", fixed_count),
        rep("random_effects", 4L)), transform = "identity")
    random_indices <- seq.int(fixed_count + 1L, length(parameter_names))
    stopifnot(fixed_count == 6L, length(random_indices) == 4L,
      !anyNA(parameter_rows[["module_name"]]))
    joint <- TMB::MakeADFun(data = list(), parameters = input[["parameters"]],
      map = input[["map"]], random = NULL, DLL = "FIMS", silent = TRUE)
    observation_nll <- function(report) {
      rows <- data |>
        dplyr::filter(.data$type %in% c("catch", "index", "age_comp", "length_comp")) |>
        dplyr::arrange(.data$fleet, .data$type, .data$timing, .data$age, .data$length)
      purrr::map_dfr(split(rows, interaction(rows[["fleet"]], rows[["type"]],
        rows[["timing"]], drop = TRUE)), function(group) {
        fleet <- match(group[["fleet"]][[1]], fleets)
        type <- group[["type"]][[1]]
        year <- group[["timing"]][[1]]
        label <- switch(type, age_comp = "agecomp_expected", length_comp = "lengthcomp_expected",
          paste0(type, "_expected"))
        parsed <- FIMS:::parse_data_distribution(group[["uncertainty"]])
        if (type %in% c("catch", "index")) {
          expected <- report[[label]][[fleet]][[year]]
          lpdf <- if (parsed[["family"]][[1]] == "dnorm") {
            stats::dnorm(group[["observed"]], expected, unlist(parsed[["sd"]]), log = TRUE)
          } else {
            stats::dlnorm(group[["observed"]], log(expected), unlist(parsed[["sdlog"]]), log = TRUE)
          }
        } else {
          expected <- matrix(report[[label]][[fleet]], ncol = nrow(group), byrow = TRUE)[year, ]
          lpdf <- stats::dmultinom(round(group[["observed"]] * 1000), prob = expected, log = TRUE)
        }
        tibble::tibble(fleet = fleets[[fleet]], label = label, nll = -as.numeric(lpdf))
      }) |> dplyr::summarize(nll = sum(.data$nll), .by = c("fleet", "label"))
    }
    process_nll <- function(full, report) {
      values <- full[random_indices]
      expected <- if (mode == "log_devs") rep(0, 4L) else {
        fixed_values <- stats::setNames(full[seq_len(fixed_count)],
          parameter_rows[["label"]][seq_len(fixed_count)])
        steep <- 0.2 + 0.8 * stats::plogis(
          truth_parameters[["value"]][truth_parameters[["label"]] == "logit_steep"])
        rzero <- exp(fixed_values[["log_rzero"]])
        phi_0 <- unname(unlist(report[["unfished_spawning_biomass"]]))[[1]] / rzero
        spawners <- unname(unlist(report[["spawning_biomass"]]))[1:4]
        log(0.8 * rzero * steep * spawners /
          (0.2 * phi_0 * rzero * (1 - steep) + spawners * (steep - 0.2)))
      }
      # Native random-effect lognormal evaluates log(values), without a Jacobian.
      density_values <- if (family == "Dlnorm") log(values) else values
      nll <- -sum(stats::dnorm(density_values, expected, 0.25, log = TRUE))
      observation_components <- observation_nll(report)
      native_nll <- report[["jnll"]] - sum(observation_components[["nll"]])
      if (abs(nll - native_nll) >= 1e-8) {
        stop(name, " process reconstruction: R=", nll, ", native=",
          native_nll, ", values=", paste(values, collapse = ","),
          ", expected=", paste(expected, collapse = ","),
          ", native scales=", paste(metadata[["input"]][metadata[["label"]] == "log_sd"],
            collapse = ","))
      }
      stopifnot(isTRUE(all.equal(sort(as.numeric(report[["nll_components"]])),
        sort(c(nll, observation_components[["nll"]])), tolerance = 1e-8)))
      list(values = values, expected = expected, sd = 0.25, nll = nll,
        observation_components = observation_components)
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
      stopifnot(max(abs(gradient)) > 1e-2,
        max(abs(joint[["gr"]](full)[random_indices])) < 1e-6,
        abs(marginal - joint[["fn"]](full) -
          sum(log(diag(chol(curvature[random_indices, random_indices])))) +
          length(random_indices) * log(2 * pi) / 2) < 1e-8)
      list(fixed = fixed, marginal = marginal, gradient = gradient, report = report,
        parameters = full, joint_hessian = curvature,
        joint_gradient = as.numeric(joint[["gr"]](full)), process = process_nll(full, report))
    })
    progress(paste("optimize", name))
    optimum <- stats::nlminb(objective[["par"]], fn, gr,
      control = list(iter.max = 400, eval.max = 1000))
    for (restart in seq_len(3L)) {
      if (optimum[["convergence"]] == 0L && max(abs(gr(optimum[["par"]]))) < 1e-4) break
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
    report <- joint[["report"]](full)
    parameter_rows[["estimated"]] <- full
    parameter_rows[["uncertainty"]] <- sqrt(diag(covariance))
    report_summary <- summary(uncertainty, "report")
    report_rows <- tibble::tibble(label = rownames(report_summary),
      estimate = report_summary[, "Estimate"], uncertainty = report_summary[, "Std. Error"]) |>
      dplyr::group_by(.data$label) |> dplyr::mutate(oracle_id = dplyr::row_number()) |>
      dplyr::ungroup()
    derived <- metadata |> dplyr::filter(.data$estimation_type == "derived_quantity") |>
      dplyr::select(dplyr::all_of(keys)) |> dplyr::group_by(.data$label) |>
      dplyr::mutate(oracle_id = dplyr::row_number()) |> dplyr::ungroup() |>
      dplyr::left_join(report_rows, by = c("label", "oracle_id"), relationship = "one-to-one") |>
      dplyr::select(-dplyr::all_of("oracle_id"))
    stopifnot(nrow(covariance) == 10L, all(is.finite(derived[["uncertainty"]])))
    list(name = name, data = data, parameters = parameters, priors = NULL,
      truth = list(parameters = truth_parameters, report = truth_report),
      recruitment_process = list(mode = mode, family = tolower(family)),
      native_process_metadata = native_process_metadata,
      process = process_nll(full, report), points = points, marginal = optimum[["objective"]],
      report = report, parameters_table = parameter_rows, covariance = covariance,
      derived = derived, optimum = optimum, max_gradient = max(abs(gradient)),
      joint_hessian = joint[["he"]](full), fixed_hessian = hessian,
      check_fixed_hessian = check_hessian)
  }
  specifications <- tidyr::expand_grid(mode = c("log_devs", "log_r"),
    family = c("Dnorm", "Dlnorm"))
  cases <- purrr::pmap(specifications, capture_case)
  names(cases) <- purrr::map_chr(cases, \(case) case[["name"]])
  native_sources <- list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE)
  source_md5 <- tools::md5sum(native_sources)
  names(source_md5) <- basename(names(source_md5))
  result <- list(provenance = list(
    native_declared_revision = reference[["provenance"]][["revision"]],
    native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
    input_fixture_md5 = unname(tools::md5sum(fixture)),
    generator_md5 = unname(tools::md5sum(generator)), R = R.version.string,
    TMB = as.character(utils::packageVersion("TMB")), ricker_error = ricker_error,
    optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
    method = paste("Historical native normal/lognormal log_devs/log_r processes.",
      "Native-generated observations with integer multinomial size 1000.",
      "Six fixed and four random effects; complete covariance and report uncertainty.",
      "Native random-effect lognormal has no Jacobian; independent R density reconstruction.",
      "Historical initialize_modules hard-codes gaussian: harness explicitly selects",
      "the existing native Dlnorm constructor without changing native sources.",
      "No Julia evaluation, native compilation or added priors.")), cases = cases)
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
  generate_native_recruitment_process_oracle(arguments[[1]], arguments[[2]])
}
