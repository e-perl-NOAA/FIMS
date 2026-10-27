# Julia backend helpers ----

# Environment used to memoize Julia backend initialization.
.fims_julia_backend_state <- new.env(parent = emptyenv())
.fims_julia_backend_state$initialized <- FALSE

#' Get the installed Julia backend path
#'
#' @param libname Library path passed from `.onLoad()`.
#' @param pkgname Package name passed from `.onLoad()`.
#' @return A character scalar containing the Julia backend path.
#' @noRd
julia_backend_package_path <- function(libname = NULL, pkgname = "FIMS") {
  installed_root <- tryCatch(
    system.file(package = pkgname),
    error = function(...) ""
  )

  if (!is.null(libname) && !is.null(pkgname)) {
    candidate_paths <- c(
      file.path(installed_root, "julia", "FIMSBackend"),
      file.path(installed_root, "inst", "julia", "FIMSBackend"),
      file.path(libname, pkgname, "julia", "FIMSBackend"),
      file.path(libname, pkgname, "inst", "julia", "FIMSBackend")
    )
    existing_path <- candidate_paths[dir.exists(candidate_paths)][1]

    if (!is.na(existing_path)) {
      return(existing_path)
    }

    return(candidate_paths[[1]])
  }

  candidate_paths <- c(
    file.path(installed_root, "julia", "FIMSBackend"),
    file.path(installed_root, "inst", "julia", "FIMSBackend"),
    system.file("julia", "FIMSBackend", package = pkgname)
  )
  existing_path <- candidate_paths[dir.exists(candidate_paths)][1]

  if (!is.na(existing_path)) {
    return(existing_path)
  }

  candidate_paths[[1]]
}

#' Get the Julia backend module file
#'
#' @param libname Library path passed from `.onLoad()`.
#' @param pkgname Package name passed from `.onLoad()`.
#' @return A character scalar containing the Julia module file path.
#' @noRd
julia_backend_module_path <- function(libname = NULL, pkgname = "FIMS") {
  file.path(
    julia_backend_package_path(libname = libname, pkgname = pkgname),
    "src",
    "FIMSBackend.jl"
  )
}

#' Initialize the Julia backend
#'
#' @param libname Library path passed from `.onLoad()`.
#' @param pkgname Package name passed from `.onLoad()`.
#' @return Invisibly returns `TRUE` when Julia is initialized, or `FALSE` when Julia is disabled by option.
#' @details JuliaCall installs Julia when it is unavailable. Initialization errors are reported to the caller.
#' @noRd
initialize_julia_backend <- function(libname = NULL, pkgname = "FIMS") {
  if (.fims_julia_backend_state$initialized) {
    return(invisible(TRUE))
  }

  if (isTRUE(getOption("FIMS.disable_julia", FALSE))) {
    return(invisible(FALSE))
  }

  module_path <- julia_backend_module_path(libname = libname, pkgname = pkgname)
  package_path <- julia_backend_package_path(libname = libname, pkgname = pkgname)

  if (!file.exists(module_path) || !dir.exists(package_path)) {
    cli::cli_abort(c(
      "The Julia backend files are missing from the installed FIMS package.",
      "i" = "Reinstall FIMS from a complete package source before fitting Julia-backed models."
    ))
  }

  tryCatch(
    {
      JuliaCall::julia_setup(installJulia = TRUE, version = "latest")
      JuliaCall::julia_command("using Pkg")
      JuliaCall::julia_command(
        sprintf('Pkg.activate(raw"%s")', normalizePath(package_path, "/"))
      )
      JuliaCall::julia_command("Pkg.instantiate()")
      JuliaCall::julia_command(
        sprintf("Base.include(Main, raw\"%s\")", normalizePath(module_path, "/"))
      )
      JuliaCall::julia_command("using .FIMSBackend")
    },
    error = function(error) {
      cli::cli_abort(c(
        "Julia backend initialization failed.",
        "i" = "JuliaCall could not install or start Julia, resolve FIMSBackend dependencies, or load the backend.",
        "i" = "Underlying error: {conditionMessage(error)}"
      ))
    }
  )

  .fims_julia_backend_state$initialized <- TRUE
  invisible(TRUE)
}

#' Convert a FIMSFrame to a Julia-friendly list
#'
#' @param data A `FIMSFrame` object.
#' @param parameters Parameter tibble used to derive model-ready arrays.
#' @return A list representation of the data object.
#' @noRd
as_julia_fims_data <- function(data, parameters) {
  n_years <- get_n_years(data)
  n_ages <- get_n_ages(data)
  ages <- get_ages(data)
  fleets <- get_fleets(data)
  fleet_data <- get_data(data)
  raw_data <- as.data.frame(fleet_data)
  growth_types <- parameters |>
    dplyr::filter(.data$module_name == "Growth") |>
    dplyr::pull(.data$module_type) |>
    unique() |>
    stats::na.omit()
  is_vonb_growth <- "VonBertalanffySchnute" %in% growth_types
  lengths <- if (is_vonb_growth && any(raw_data$type == "length_comp")) {
    sort(unique(raw_data$length[raw_data$type == "length_comp"]))
  } else {
    get_lengths(data)
  }
  n_lengths <- length(lengths)
  if (is_vonb_growth && any(raw_data$type == "length_comp")) {
    length_bins_by_fleet <- raw_data |>
      dplyr::filter(.data$type == "length_comp") |>
      dplyr::group_by(.data$fleet) |>
      dplyr::summarise(
        bins = list(sort(unique(.data$length))),
        .groups = "drop"
      ) |>
      dplyr::pull(.data$bins)
    if (length(length_bins_by_fleet) > 1L &&
      !all(vapply(
        length_bins_by_fleet[-1],
        identical,
        logical(1),
        length_bins_by_fleet[[1]]
      ))) {
      cli::cli_abort(
        "Julia backend currently requires matching length-composition bins across fleets for VonBertalanffySchnute growth."
      )
    }
  }

  year_index <- function(year) as.integer(year - get_start_year(data) + 1L)
  age_index <- function(age) match(age, ages)
  length_index <- function(length) match(length, lengths)
  stream_rows <- function(data_type, fleet) {
    raw_data |>
      dplyr::filter(
        .data$type == .env$data_type,
        .data$fleet == .env$fleet
      ) |>
      dplyr::arrange(.data$timing, .data$age, .data$length)
  }
  fill_stream <- function(data_type, n_bins) {
    stream_data <- array(
      -999,
      dim = c(n_years, n_bins, length(fleets)),
      dimnames = list(NULL, NULL, fleets)
    )
    for (fleet_index in seq_along(fleets)) {
      rows <- stream_rows(data_type, fleets[[fleet_index]])
      if (nrow(rows) == 0) {
        next
      }

      bin_index <- if (data_type == "age_comp") {
        age_index(rows[["age"]])
      } else {
        length_index(rows[["length"]])
      }
      positions <- cbind(year_index(rows[["timing"]]), bin_index)
      if (anyNA(positions) || any(positions < 1L) ||
        any(positions[, 1] > n_years) || any(positions[, 2] > n_bins)) {
        cli::cli_abort(
          "Julia backend serialization found {data_type} observations outside the modeled year or bin range."
        )
      }
      observed <- if (data_type == "age_comp") {
        model_age_comp(data, fleets[[fleet_index]])
      } else {
        model_length_comp(data, fleets[[fleet_index]])
      }
      stream_data[, , fleet_index][positions] <- observed
    }
    stream_data
  }

  maturity_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Maturity", .data$label %in% c("inflection_point", "slope")) |>
    dplyr::select(.data$label, .data$value)
  maturity_inflection <- maturity_parameters |>
    dplyr::filter(.data$label == "inflection_point") |>
    dplyr::pull(.data$value) |>
    {\(x) if (length(x) > 0) x[[1]] else 0}()
  maturity_slope <- maturity_parameters |>
    dplyr::filter(.data$label == "slope") |>
    dplyr::pull(.data$value) |>
    {\(x) if (length(x) > 0) x[[1]] else 1}()
  maturity_by_age <- 1 / (1 + exp(-maturity_slope * (ages - maturity_inflection)))

  proportion_female <- parameters |>
    dplyr::filter(.data$module_name == "Population", .data$label == "proportion_female") |>
    dplyr::pull(.data$value)
  proportion_female <- if (length(proportion_female) == 0) {
    rep(0.5, n_ages)
  } else if (length(proportion_female) == 1) {
    rep(proportion_female, n_ages)
  } else if (length(proportion_female) == n_ages) {
    proportion_female
  } else {
    cli::cli_abort(
      "Julia backend serialization requires {.var proportion_female} to have length 1 or {.val {n_ages}}, but found length {.val {length(proportion_female)}}."
    )
  }

  weights_at_age <- if (is_vonb_growth) {
    rep(1, n_years * n_ages)
  } else {
    model_weight_at_age(data)
  }
  weights_at_age <- if (length(weights_at_age) == n_ages) {
    matrix(rep(weights_at_age, times = n_years), nrow = n_years, byrow = TRUE)
  } else if (length(weights_at_age) >= n_years * n_ages) {
    matrix(weights_at_age[seq_len(n_years * n_ages)], nrow = n_years, byrow = TRUE)
  } else {
    cli::cli_abort(
      "Julia backend serialization requires weight-at-age values for each modeled year-age cell or one full age vector."
    )
  }

  julia_data <- list(
    data = raw_data,
    fleets = fleets,
    n_years = n_years,
    ages = ages,
    n_ages = n_ages,
    lengths = lengths,
    fleet_has_catch = vapply(fleets, \(fleet) any(raw_data$type == "catch" & raw_data$fleet == fleet), logical(1)),
    fleet_has_index = vapply(fleets, \(fleet) any(raw_data$type == "index" & raw_data$fleet == fleet), logical(1)),
    n_lengths = n_lengths,
    start_year = get_start_year(data),
    end_year = get_end_year(data),
    weights_at_age = weights_at_age,
    maturity_at_age = matrix(rep(maturity_by_age, times = n_years), nrow = n_years, byrow = TRUE),
    proportion_female = proportion_female
  )

  if (any(julia_data[["fleet_has_catch"]])) {
    observed_catch <- matrix(-999, nrow = n_years, ncol = length(fleets))
    for (fleet_index in which(julia_data[["fleet_has_catch"]])) {
      rows <- stream_rows("catch", fleets[[fleet_index]])
      positions <- year_index(rows[["timing"]])
      if (anyNA(positions) || any(positions < 1L | positions > n_years)) {
        cli::cli_abort("Julia backend serialization found catch observations outside the modeled year range.")
      }
      observed_catch[positions, fleet_index] <- rows[["observed"]]
    }
    julia_data[["observed_catch"]] <- observed_catch
  }

  if (any(julia_data[["fleet_has_index"]])) {
    observed_index <- matrix(-999, nrow = n_years, ncol = length(fleets))
    for (fleet_index in which(julia_data[["fleet_has_index"]])) {
      rows <- stream_rows("index", fleets[[fleet_index]])
      positions <- year_index(rows[["timing"]])
      if (anyNA(positions) || any(positions < 1L | positions > n_years)) {
        cli::cli_abort("Julia backend serialization found index observations outside the modeled year range.")
      }
      observed_index[positions, fleet_index] <- rows[["observed"]]
    }
    julia_data[["observed_index"]] <- observed_index
  }

  if (any(raw_data$type == "age_comp")) {
    julia_data[["observed_age_comp"]] <- fill_stream("age_comp", n_ages)
  }

  if (any(raw_data$type == "length_comp")) {
    julia_data[["observed_length_comp"]] <- fill_stream("length_comp", n_lengths)
  }

  if (!is_vonb_growth && any(raw_data$type == "age_to_length_conversion")) {
    julia_data[["age_to_length_conversion"]] <- matrix(
      model_age_to_length_conversion(data),
      nrow = n_ages,
      byrow = TRUE
    )
  }

  julia_data
}

#' Convert the current parameter tibble to a Julia-friendly list
#'
#' @param parameters Parameter tibble.
#' @param data A `FIMSFrame` object.
#' @return A named list matching the current Julia backend scaffold.
#' @noRd
as_julia_fims_parameters <- function(parameters, data) {
  fleets <- get_fleets(data)
  n_years <- get_n_years(data)
  n_ages <- get_n_ages(data)
  recruitment_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Recruitment")
  population_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Population")
  maturity_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Maturity")
  growth_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Growth")
  growth_type <- growth_parameters |>
    dplyr::pull(.data$module_type) |>
    unique() |>
    stats::na.omit()

  values_for <- function(parameter_data, label, default = numeric()) {
    rows <- parameter_data |>
      dplyr::filter(.data$label == .env$label) |>
      dplyr::arrange(dplyr::across(dplyr::any_of(c("timing", "age"))))
    if (nrow(rows) == 0) {
      return(default)
    }
    rows[["value"]]
  }
  fleet_parameter <- function(fleet, label, default = numeric()) {
    parameters |>
      dplyr::filter(
        .data$module_name %in% c("Fleet", "Selectivity"),
        .data$fleet == .env$fleet,
        .data$label == .env$label
      ) |>
      dplyr::arrange(.data$timing, .data$age) |>
      dplyr::pull(.data$value) |>
      {\(x) if (length(x) == 0) default else x}()
  }
  parameter_matrix <- function(parameter_data, label, default, by_age = FALSE) {
    matrix_values <- matrix(default, nrow = n_years, ncol = n_ages)
    rows <- parameter_data |>
      dplyr::filter(.data$label == .env$label)
    if (nrow(rows) == 0) {
      return(matrix_values)
    }
    year_index <- rows[["timing"]] - get_start_year(data) + 1L
    age_index <- if (by_age && "age" %in% names(rows)) {
      match(rows[["age"]], get_ages(data))
    } else {
      rep(NA_integer_, nrow(rows))
    }
    if (by_age && any(!is.na(rows[["age"]]) & is.na(age_index))) {
      cli::cli_abort("Parameter {.val {label}} contains an age outside the modeled range.")
    }
    for (row_index in seq_len(nrow(rows))) {
      if (is.na(year_index[[row_index]]) && !is.na(age_index[[row_index]])) {
        matrix_values[, age_index[[row_index]]] <- rows[["value"]][[row_index]]
        next
      }
      if (is.na(year_index[[row_index]])) {
        matrix_values[,] <- rows[["value"]][[row_index]]
        next
      }
      if (year_index[[row_index]] < 1L || year_index[[row_index]] > n_years) {
        cli::cli_abort("Parameter {.val {label}} contains a year outside the modeled range.")
      }
      if (is.na(age_index[[row_index]])) {
        matrix_values[year_index[[row_index]], ] <- rows[["value"]][[row_index]]
      } else {
        matrix_values[year_index[[row_index]], age_index[[row_index]]] <- rows[["value"]][[row_index]]
      }
    }
    matrix_values
  }

  log_fmort <- matrix(-200, nrow = n_years, ncol = length(fleets))
  log_q <- numeric(length(fleets))
  inflection_point <- slope <- inflection_point_asc <- slope_asc <-
    inflection_point_desc <- slope_desc <- numeric(length(fleets))
  selectivity_type <- character(length(fleets))
  for (fleet_index in seq_along(fleets)) {
    fleet <- fleets[[fleet_index]]
    fleet_fmort <- fleet_parameter(fleet, "log_Fmort", rep(-200, n_years))
    log_fmort[, fleet_index] <- rep(fleet_fmort, length.out = n_years)
    log_q[[fleet_index]] <- fleet_parameter(fleet, "log_q", 0)[[1]]
    selectivity_parameters <- parameters |>
      dplyr::filter(.data$module_name == "Selectivity", .data$fleet == .env$fleet)
    inflection_point[[fleet_index]] <- values_for(selectivity_parameters, "inflection_point", 2)[[1]]
    slope[[fleet_index]] <- values_for(selectivity_parameters, "slope", 1)[[1]]
    inflection_point_asc[[fleet_index]] <- values_for(selectivity_parameters, "inflection_point_asc", 2)[[1]]
    slope_asc[[fleet_index]] <- values_for(selectivity_parameters, "slope_asc", 1)[[1]]
    inflection_point_desc[[fleet_index]] <- values_for(selectivity_parameters, "inflection_point_desc", 4)[[1]]
    slope_desc[[fleet_index]] <- values_for(selectivity_parameters, "slope_desc", 1)[[1]]
    selectivity_type[[fleet_index]] <- parameters |>
      dplyr::filter(.data$module_name == "Selectivity", .data$fleet == .env$fleet) |>
      dplyr::pull(.data$module_type) |>
      unique() |>
      {\(x) if (length(x) == 0) "Logistic" else x[[1]]}()
  }

  julia_parameters <- list(
    inflection_point = inflection_point,
    slope = slope,
    inflection_point_asc = inflection_point_asc,
    slope_asc = slope_asc,
    inflection_point_desc = inflection_point_desc,
    slope_desc = slope_desc,
    log_rzero = values_for(recruitment_parameters, "log_rzero", log(1e6))[[1]],
    logit_steep = values_for(recruitment_parameters, "logit_steep", 0)[[1]],
    log_devs = values_for(recruitment_parameters, "log_devs", rep(0, max(n_years - 1, 0))),
    log_r = values_for(recruitment_parameters, "log_r", rep(0, max(n_years - 1, 0))),
    log_sd = values_for(recruitment_parameters, "log_sd", 0),
    log_init_naa = values_for(population_parameters, "log_init_naa", rep(log(1e6), n_ages)),
    log_M = parameter_matrix(population_parameters, "log_M", log(0.2), by_age = TRUE),
    log_Fmort = log_fmort,
    log_q = log_q,
    maturity_inflection_point = values_for(
      maturity_parameters,
      "inflection_point",
      0
    )[[1]],
    maturity_slope = values_for(maturity_parameters, "slope", 1)[[1]]
  )
  if ("VonBertalanffySchnute" %in% growth_type) {
    growth_values <- function(label, default) {
      rows <- growth_parameters |>
        dplyr::filter(.data$label == .env$label) |>
        dplyr::arrange(dplyr::across(dplyr::any_of(c("timing", "age"))))
      if (nrow(rows) == 0L) {
        return(default)
      }
      rows[["value"]]
    }
    growth_scalar <- function(label, default) {
      values <- growth_values(label, default)
      if (length(values) != 1L || !is.finite(values[[1]])) {
        cli::cli_abort(
          "Julia backend requires one finite value for VonBertalanffySchnute parameter {.val {label}}."
        )
      }
      values[[1]]
    }
    delta_method_labels <- c(
      "log_sd_mean_length_young",
      "log_sd_mean_length_old",
      "log_sd_growth_coefficient",
      "mean_length_young_mean_length_old_logit_corr",
      "mean_length_young_growth_coefficient_logit_corr",
      "mean_length_old_growth_coefficient_logit_corr"
    )
    delta_method_rows <- growth_parameters |>
      dplyr::filter(.data$label %in% delta_method_labels)
    has_delta_method <- nrow(delta_method_rows) > 0L
    has_interpolation_sd <- any(
      growth_parameters[["label"]] == "length_at_age_sd_at_reference_ages"
    )
    if (has_delta_method && has_interpolation_sd) {
      cli::cli_abort(
        "Provide either reference-age SD values or delta-method parameters for VonBertalanffySchnute growth, but not both."
      )
    }
    if (has_delta_method) {
      delta_method_values <- lapply(delta_method_labels, \(label) {
        growth_scalar(label, NA_real_)
      })
      if (any(!is.finite(vapply(delta_method_values, identity, numeric(1))))) {
        cli::cli_abort(
          "VonBertalanffySchnute delta-method parameters must each have one finite value."
        )
      }
      delta_method_sds <- exp(unlist(delta_method_values[seq_len(3L)]))
      if (any(!is.finite(delta_method_sds)) || any(delta_method_sds <= 0)) {
        cli::cli_abort(
          "VonBertalanffySchnute delta-method standard deviations must be positive and finite on the natural scale."
        )
      }
    } else {
      length_sd <- growth_values("length_at_age_sd_at_reference_ages", c(3, 7))
      if (length(length_sd) != 2L || any(!is.finite(length_sd)) || any(length_sd <= 0)) {
        cli::cli_abort(
          "Julia backend requires exactly two positive reference-age length SD values for VonBertalanffySchnute growth."
        )
      }
    }
    scalar_values <- c(
      growth_scalar("mean_length_young", 275),
      growth_scalar("mean_length_old", 725),
      growth_scalar("growth_coefficient", 0.18),
      growth_scalar("reference_age_for_length_young", 0),
      growth_scalar("reference_age_for_length_old", max(get_ages(data))),
      growth_scalar("length_weight_a", 2.5e-11),
      growth_scalar("length_weight_b", 3)
    )
    positive_values <- scalar_values[c(1L, 2L, 3L, 6L, 7L)]
    if (any(positive_values <= 0)) {
      cli::cli_abort(
        "Julia backend requires positive VonBertalanffySchnute lengths, growth coefficient, and length-weight parameters."
      )
    }
    if (scalar_values[[5]] <= scalar_values[[4]]) {
      cli::cli_abort(
        "VonBertalanffySchnute reference_age_for_length_old must exceed reference_age_for_length_young."
      )
    }
    julia_parameters <- c(julia_parameters, list(
      growth_log_mean_length_young = log(growth_scalar("mean_length_young", 275)),
      growth_log_mean_length_old = log(growth_scalar("mean_length_old", 725)),
      growth_log_coefficient = log(growth_scalar("growth_coefficient", 0.18)),
      growth_reference_age_young = growth_scalar("reference_age_for_length_young", 0),
      growth_reference_age_old = growth_scalar("reference_age_for_length_old", max(get_ages(data))),
      growth_log_length_weight_a = log(growth_scalar("length_weight_a", 2.5e-11)),
      growth_log_length_weight_b = log(growth_scalar("length_weight_b", 3))
    ))
    if (has_delta_method) {
      julia_parameters <- c(julia_parameters, list(
        growth_log_sd_mean_length_young = growth_scalar("log_sd_mean_length_young", NA_real_),
        growth_log_sd_mean_length_old = growth_scalar("log_sd_mean_length_old", NA_real_),
        growth_log_sd_growth_coefficient = growth_scalar("log_sd_growth_coefficient", NA_real_),
        growth_mean_length_young_mean_length_old_logit_corr =
          growth_scalar("mean_length_young_mean_length_old_logit_corr", NA_real_),
        growth_mean_length_young_growth_coefficient_logit_corr =
          growth_scalar("mean_length_young_growth_coefficient_logit_corr", NA_real_),
        growth_mean_length_old_growth_coefficient_logit_corr =
          growth_scalar("mean_length_old_growth_coefficient_logit_corr", NA_real_)
      ))
    } else {
      julia_parameters <- c(julia_parameters, list(
        growth_log_length_sd_at_young = log(length_sd[[1]]),
        growth_log_length_sd_at_old = log(length_sd[[2]])
      ))
    }
  }
  julia_parameters
}

#' Assign prepared Julia input into the Julia session
#'
#' @param julia_input Prepared Julia input list.
#' @return Invisibly returns `TRUE` when assignments are attempted.
#' @noRd
assign_julia_backend_input <- function(julia_input) {
  JuliaCall::julia_call(
    "FIMSBackend.set_backend_input!",
    julia_input[["data"]],
    julia_input[["parameters"]]
  )
  invisible(TRUE)
}

#' Prepare a Julia backend input bundle
#'
#' @param parameters Parameter tibble.
#' @param data A `FIMSFrame` object.
#' @return A list with Julia-ready `data` and `parameters` entries.
#' @noRd
prepare_julia_backend_input <- function(parameters, data) {
  list(
    data = as_julia_fims_data(data = data, parameters = parameters),
    parameters = as_julia_fims_parameters(parameters = parameters, data = data)
  )
}

#' Convert parameter priors to Julia component locations
#'
#' @param priors A tibble describing prior distributions on parameter rows.
#' @param parameters Parameter tibble.
#' @param data A `FIMSFrame` object.
#' @return A list describing prior targets and distributions.
#' @noRd
as_julia_fims_priors <- function(priors, parameters, data) {
  empty_priors <- list(
    parameter_prior_components = character(),
    parameter_prior_indices = integer(),
    parameter_prior_distributions = character(),
    parameter_prior_means = numeric(),
    parameter_prior_sds = numeric()
  )
  if (is.null(priors)) {
    return(empty_priors)
  }
  if (!tibble::is_tibble(priors)) {
    cli::cli_abort("{.var priors} must be a tibble.")
  }

  required_columns <- c(
    "module_name", "fleet", "label", "timing", "age",
    "distribution", "mean", "sd"
  )
  missing_columns <- setdiff(required_columns, names(priors))
  if (length(missing_columns) > 0L) {
    cli::cli_abort(
      "{.var priors} is missing required columns: {.val {missing_columns}}."
    )
  }
  if (nrow(priors) == 0L) {
    return(empty_priors)
  }
  if (anyNA(priors[["module_name"]]) || anyNA(priors[["label"]]) ||
    anyNA(priors[["distribution"]])) {
    cli::cli_abort(
      "{.var module_name}, {.var label}, and {.var distribution} cannot be missing in {.var priors}."
    )
  }
  if (!is.numeric(priors[["mean"]]) || any(!is.finite(priors[["mean"]]))) {
    cli::cli_abort("{.var mean} in {.var priors} must contain finite numeric values.")
  }
  if (!is.numeric(priors[["sd"]]) || any(!is.finite(priors[["sd"]]) | priors[["sd"]] <= 0)) {
    cli::cli_abort(
      "{.var sd} in {.var priors} must contain finite positive numeric values."
    )
  }

  distributions <- tolower(priors[["distribution"]])
  unsupported_distributions <- setdiff(unique(distributions), c("dnorm", "dlnorm"))
  if (length(unsupported_distributions) > 0L) {
    cli::cli_abort(
      "Julia parameter priors support only {.val Dnorm} and {.val Dlnorm}; found {.val {unsupported_distributions}}."
    )
  }

  parameter_keys <- c("module_name", "fleet", "label", "timing", "age")
  target_rows <- vector("list", nrow(priors))
  for (prior_index in seq_len(nrow(priors))) {
    matches <- rep(TRUE, nrow(parameters))
    for (key in parameter_keys) {
      expected <- priors[[key]][[prior_index]]
      observed <- parameters[[key]]
      matches <- matches & if (is.na(expected)) {
        is.na(observed)
      } else {
        !is.na(observed) & observed == expected
      }
    }
    target_rows[[prior_index]] <- parameters[matches, , drop = FALSE]
    if (nrow(target_rows[[prior_index]]) != 1L) {
      cli::cli_abort(
        "Prior row {.val {prior_index}} must identify exactly one parameter row; found {.val {nrow(target_rows[[prior_index]])}}."
      )
    }
  }

  component_names <- character(nrow(priors))
  component_indices <- integer(nrow(priors))
  fleet_names <- get_fleets(data)
  n_years <- get_n_years(data)
  start_year <- get_start_year(data)
  ages <- get_ages(data)

  parameter_row_matches <- function(rows, target) {
    matches <- rep(TRUE, nrow(rows))
    for (key in parameter_keys) {
      expected <- target[[key]][[1]]
      observed <- rows[[key]]
      matches <- matches & if (is.na(expected)) {
        is.na(observed)
      } else {
        !is.na(observed) & observed == expected
      }
    }
    which(matches)
  }

  for (prior_index in seq_len(nrow(priors))) {
    target <- target_rows[[prior_index]]
    module_name <- target[["module_name"]][[1]]
    label <- target[["label"]][[1]]
    fleet <- target[["fleet"]][[1]]
    component_names[[prior_index]] <- label

    if (module_name == "Selectivity" || module_name == "Fleet") {
      fleet_index <- match(fleet, fleet_names)
      if (is.na(fleet_index)) {
        cli::cli_abort("Prior row {.val {prior_index}} refers to an unknown fleet.")
      }
      if (module_name == "Selectivity") {
        supported_labels <- c(
          "inflection_point", "slope", "inflection_point_asc", "slope_asc",
          "inflection_point_desc", "slope_desc"
        )
        if (!label %in% supported_labels) {
          cli::cli_abort("Julia cannot apply a prior to Selectivity parameter {.val {label}}.")
        }
        component_indices[[prior_index]] <- fleet_index
      } else if (label == "log_q") {
        component_indices[[prior_index]] <- fleet_index
      } else if (label == "log_Fmort") {
        timing <- target[["timing"]][[1]]
        year_index <- as.integer(timing - start_year + 1L)
        if (is.na(year_index) || year_index < 1L || year_index > n_years) {
          cli::cli_abort(
            "A prior on Fleet {.val log_Fmort} requires a modeled {.field timing}."
          )
        }
        component_indices[[prior_index]] <- year_index + (fleet_index - 1L) * n_years
      } else {
        cli::cli_abort("Julia cannot apply a prior to Fleet parameter {.val {label}}.")
      }
    } else if (module_name == "Recruitment") {
      related_rows <- parameters |>
        dplyr::filter(.data$module_name == "Recruitment", .data$label == .env$label) |>
        dplyr::arrange(dplyr::across(dplyr::any_of(c("timing", "age"))))
      target_position <- parameter_row_matches(related_rows, target)
      component_indices[[prior_index]] <- target_position[[1]]
    } else if (module_name == "Population" && label == "log_init_naa") {
      related_rows <- parameters |>
        dplyr::filter(.data$module_name == "Population", .data$label == "log_init_naa") |>
        dplyr::arrange(dplyr::across(dplyr::any_of(c("timing", "age"))))
      target_position <- parameter_row_matches(related_rows, target)
      component_indices[[prior_index]] <- target_position[[1]]
    } else if (module_name == "Population" && label == "log_M") {
      year_index <- as.integer(target[["timing"]][[1]] - start_year + 1L)
      age_index <- match(target[["age"]][[1]], ages)
      if (is.na(year_index) || year_index < 1L || year_index > n_years ||
        is.na(age_index)) {
        cli::cli_abort(
          "A prior on Population {.val log_M} requires a modeled {.field timing} and {.field age}."
        )
      }
      component_indices[[prior_index]] <- year_index + (age_index - 1L) * n_years
    } else {
      cli::cli_abort(
        "Julia cannot apply a prior to parameter {.val {module_name}/{label}}."
      )
    }
  }

  target_ids <- paste(component_names, component_indices, sep = "::")
  if (anyDuplicated(target_ids)) {
    cli::cli_abort("Each Julia parameter can have at most one prior.")
  }

  list(
    parameter_prior_components = component_names,
    parameter_prior_indices = component_indices,
    parameter_prior_distributions = distributions,
    parameter_prior_means = priors[["mean"]],
    parameter_prior_sds = priors[["sd"]]
  )
}

#' Build Julia backend model configuration
#'
#' @param parameters Parameter tibble.
#' @param data A `FIMSFrame` object.
#' @param priors Optional tibble of prior distributions keyed to parameter rows.
#' @return A named list of Julia backend configuration values.
#' @noRd
as_julia_fims_model_config <- function(parameters, data, priors = NULL) {
  fleet_data <- get_data(data)
  has_legacy_prior_metadata <- any(
    parameters[["distribution_type"]] == "prior",
    na.rm = TRUE
  )
  if (has_legacy_prior_metadata && is.null(priors)) {
    cli::cli_abort(
      "Julia parameter priors must be supplied with the {.arg priors} argument; {.field distribution_type} metadata does not identify prior targets or parameters."
    )
  }
  julia_priors <- as_julia_fims_priors(priors, parameters, data)

  extract_data_likelihood <- function(data_type, default = 0.1) {
    rows <- fleet_data |>
      dplyr::filter(.data$type == .env$data_type)
    sigma <- matrix(default, nrow = get_n_years(data), ncol = length(get_fleets(data)))
    family_by_cell <- matrix("dlnorm", nrow = get_n_years(data), ncol = length(get_fleets(data)))
    families <- character()

    for (row_index in seq_len(nrow(rows))) {
      uncertainty <- rows[["uncertainty"]][[row_index]]
      if (is.na(uncertainty)) {
        next
      }

      parsed <- parse_data_distribution(uncertainty)
      family <- parsed[["family"]][[1]]
      families <- c(families, family)
      scale_parameter <- switch(family,
        dnorm = "sd",
        dlnorm = "sdlog",
        cli::cli_abort(
          "Julia backend does not support {.val {family}} for {.val {data_type}} observations."
        )
      )
      scale_expression <- parsed[[scale_parameter]][[1]]
      scale_value <- tryCatch(
        eval(scale_expression),
        error = function(error) {
          cli::cli_abort(
            "Could not evaluate {.val {scale_parameter}} for {.val {data_type}} observations: {conditionMessage(error)}"
          )
        }
      )
      if (!is.numeric(scale_value) || length(scale_value) != 1L ||
        !is.finite(scale_value) || scale_value <= 0) {
        cli::cli_abort(
          "Julia backend requires a finite positive {.val {scale_parameter}} for {.val {data_type}} observations."
        )
      }

      year <- as.integer(rows[["timing"]][[row_index]] - get_start_year(data) + 1L)
      fleet <- match(rows[["fleet"]][[row_index]], get_fleets(data))
      if (is.na(year) || year < 1L || year > get_n_years(data) || is.na(fleet)) {
        cli::cli_abort(
          "Julia backend could not map {.val {data_type}} uncertainty to a modeled year and fleet."
        )
      }
      sigma[year, fleet] <- scale_value
      family_by_cell[year, fleet] <- family
    }

    unique_families <- unique(families)
    list(
      family = if (length(unique_families) <= 1L && all(!is.na(rows[["uncertainty"]]))) {
        if (length(unique_families) == 0L) "dlnorm" else unique_families[[1]]
      } else {
        family_by_cell
      },
      sigma = sigma
    )
  }

  catch_likelihood <- extract_data_likelihood("catch")
  index_likelihood <- extract_data_likelihood("index")
  for (composition_type in c("age_comp", "length_comp")) {
    composition_rows <- fleet_data |>
      dplyr::filter(.data$type == .env$composition_type)
    if (nrow(composition_rows) == 0L) {
      next
    }

    composition_families <- composition_rows[["uncertainty"]] |>
      stats::na.omit() |>
      parse_data_distribution() |>
      purrr::pluck("family") |>
      unique()
    unsupported_families <- setdiff(composition_families, "dmultinom")
    if (length(unsupported_families) > 0L) {
      cli::cli_abort(
        "Julia backend supports only {.val dmultinom} for {.val {composition_type}} data; found {.val {unsupported_families}}."
      )
    }
  }

  supported_module_types <- list(
    Selectivity = c("Logistic", "DoubleLogistic"),
    Maturity = "Logistic",
    Growth = c("EWAA", "VonBertalanffySchnute")
  )
  for (module_name in names(supported_module_types)) {
    module_types <- parameters |>
      dplyr::filter(.data$module_name == .env$module_name) |>
      dplyr::pull(.data$module_type) |>
      unique() |>
      stats::na.omit()
    unsupported_types <- setdiff(module_types, supported_module_types[[module_name]])
    if (length(unsupported_types) > 0L) {
      cli::cli_abort(
        "Julia backend does not support {.val {module_name}} module type {.val {unsupported_types}}."
      )
    }
  }
  growth_types <- parameters |>
    dplyr::filter(.data$module_name == "Growth") |>
    dplyr::pull(.data$module_type) |>
    unique() |>
    stats::na.omit()
  if (length(growth_types) > 1L) {
    cli::cli_abort("Julia backend requires one Growth module type per model.")
  }
  growth_type <- if (length(growth_types) == 0L) "EWAA" else growth_types[[1]]
  growth_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Growth")
  growth_sd_rows <- growth_parameters |>
    dplyr::filter(.data$label == "length_at_age_sd_at_reference_ages") |>
    dplyr::arrange(.data$age)
  if (growth_type == "VonBertalanffySchnute") {
    required_growth_labels <- c(
      "mean_length_young",
      "mean_length_old",
      "growth_coefficient",
      "reference_age_for_length_young",
      "reference_age_for_length_old",
      "length_weight_a",
      "length_weight_b"
    )
    missing_growth_labels <- setdiff(required_growth_labels, growth_parameters[["label"]])
    if (length(missing_growth_labels) > 0L) {
      cli::cli_abort(
        "VonBertalanffySchnute growth is missing parameters: {toString(missing_growth_labels)}."
      )
    }
    delta_method_labels <- c(
      "log_sd_mean_length_young",
      "log_sd_mean_length_old",
      "log_sd_growth_coefficient",
      "mean_length_young_mean_length_old_logit_corr",
      "mean_length_young_growth_coefficient_logit_corr",
      "mean_length_old_growth_coefficient_logit_corr"
    )
    delta_method_rows <- growth_parameters |>
      dplyr::filter(.data$label %in% delta_method_labels)
    has_interpolation_sd <- nrow(growth_sd_rows) > 0L
    has_delta_method <- nrow(delta_method_rows) > 0L
    if (has_interpolation_sd == has_delta_method) {
      cli::cli_abort(
        "VonBertalanffySchnute growth requires either two reference-age SD values or all six delta-method parameters, but not both."
      )
    }
    if (has_interpolation_sd &&
      (nrow(growth_sd_rows) != 2L || any(!is.finite(growth_sd_rows[["value"]])) ||
        any(growth_sd_rows[["value"]] <= 0))) {
      cli::cli_abort(
        "Julia backend requires exactly two positive reference-age length SD values for VonBertalanffySchnute growth."
      )
    }
    if (has_delta_method &&
      (!setequal(delta_method_rows[["label"]], delta_method_labels) ||
        anyDuplicated(delta_method_rows[["label"]]) ||
        any(!is.finite(delta_method_rows[["value"]])))) {
      cli::cli_abort(
        "VonBertalanffySchnute delta-method variability requires one finite value for each of the six uncertainty parameters."
      )
    }
  }

  recruitment_type <- "beverton_holt"
  if ("Ricker" %in% parameters[["module_type"]]) {
    recruitment_type <- "ricker"
  }
  recruitment_process_parameters <- parameters |>
    dplyr::filter(
      .data$module_name == "Recruitment",
      .data$label %in% c("log_devs", "log_r")
    )
  recruitment_process_mode <- if ("log_devs" %in% recruitment_process_parameters[["label"]]) {
    "log_devs"
  } else if ("log_r" %in% recruitment_process_parameters[["label"]]) {
    "log_r"
  } else {
    "log_devs"
  }
  recruitment_process_rows <- recruitment_process_parameters |>
    dplyr::filter(
      .data$label == .env$recruitment_process_mode,
      .data$distribution_type == "process",
      !is.na(.data$distribution)
    )
  recruitment_process_mode_rows <- recruitment_process_parameters |>
    dplyr::filter(.data$label == .env$recruitment_process_mode)
  has_recruitment_process_metadata <- recruitment_process_mode_rows |>
    dplyr::summarise(
      has_metadata = any(.data$distribution_type == "process", na.rm = TRUE) ||
        any(!is.na(.data$distribution))
    ) |>
    dplyr::pull(.data$has_metadata)
  if (has_recruitment_process_metadata &&
    nrow(recruitment_process_rows) != nrow(recruitment_process_mode_rows)) {
    cli::cli_abort(
      "Recruitment process metadata must specify a distribution for every {.val {recruitment_process_mode}} parameter."
    )
  }
  recruitment_process_families <- unique(tolower(recruitment_process_rows[["distribution"]]))
  if (length(recruitment_process_families) > 1L) {
    cli::cli_abort("Julia backend cannot combine multiple recruitment process distributions.")
  }
  recruitment_process_distribution <- if (length(recruitment_process_families) == 0L) {
    NA_character_
  } else {
    family <- recruitment_process_families[[1]]
    if (!family %in% c("dnorm", "dlnorm")) {
      cli::cli_abort(
        "Julia backend supports only {.val Dnorm} and {.val Dlnorm} recruitment process distributions."
      )
    }
    family
  }

  rows_for <- function(module_name, label, fleet = NULL) {
    rows <- parameters |>
      dplyr::filter(
        .data$module_name == .env$module_name,
        .data$label == .env$label
      )
    if (!is.null(fleet)) {
      rows <- rows |>
        dplyr::filter(.data$fleet == .env$fleet)
    }
    rows |>
      dplyr::arrange(dplyr::across(dplyr::any_of(c("timing", "age"))))
  }
  estimate_mask <- function(rows, type = "fixed_effects") {
    if (nrow(rows) == 0) {
      return(logical())
    }
    !is.na(rows[["estimation_type"]]) & rows[["estimation_type"]] == type
  }
  matrix_estimate_mask <- function(rows, type, by_age) {
    result <- matrix(FALSE, nrow = get_n_years(data), ncol = get_n_ages(data))
    for (row_index in seq_len(nrow(rows))) {
      years <- if (is.na(rows[["timing"]][[row_index]])) {
        seq_len(get_n_years(data))
      } else {
        as.integer(rows[["timing"]][[row_index]] - get_start_year(data) + 1L)
      }
      ages <- if (by_age && !is.na(rows[["age"]][[row_index]])) {
        match(rows[["age"]][[row_index]], get_ages(data))
      } else {
        seq_len(get_n_ages(data))
      }
      result[years, ages] <- estimate_mask(rows[row_index, , drop = FALSE], type)
    }
    result
  }

  selectivity_masks <- function(label, type) {
    vapply(
      get_fleets(data),
      \(fleet) estimate_mask(rows_for("Selectivity", label, fleet), type) |>
        {\(x) if (length(x) == 0) FALSE else x[[1]]}(),
      logical(1)
    )
  }
  maturity_parameter_mask <- function(label, type) {
    values <- estimate_mask(rows_for("Maturity", label), type)
    if (length(values) == 0) FALSE else values[[1]]
  }
  growth_parameter_mask <- function(label, type) {
    estimate_mask(rows_for("Growth", label), type)
  }
  recruitment_parameter_mask <- function(label, type, default = FALSE) {
    values <- estimate_mask(rows_for("Recruitment", label), type)
    if (length(values) == 0) default else if (label == "log_sd") values else values[[1]]
  }
  log_dev_rows <- rows_for("Recruitment", "log_devs")
  log_r_rows <- rows_for("Recruitment", "log_r")
  log_sd_rows <- rows_for("Recruitment", "log_sd")
  if (nrow(log_sd_rows) > 0L &&
    !nrow(log_sd_rows) %in% c(1L, max(get_n_years(data) - 1L, 0L))) {
    cli::cli_abort(
      "Recruitment {.val log_sd} must contain one value or one value per modeled recruitment deviation."
    )
  }
  log_m_rows <- rows_for("Population", "log_M")
  log_init_rows <- rows_for("Population", "log_init_naa")
  fleet_parameter_matrix_mask <- function(label, type) {
    result <- matrix(FALSE, nrow = get_n_years(data), ncol = length(get_fleets(data)))
    for (fleet_index in seq_along(get_fleets(data))) {
      rows <- rows_for("Fleet", label, get_fleets(data)[[fleet_index]])
      for (row_index in seq_len(nrow(rows))) {
        year <- rows[["timing"]][[row_index]] - get_start_year(data) + 1L
        if (is.na(year)) {
          result[, fleet_index] <- estimate_mask(rows[row_index, , drop = FALSE], type)[[1]]
        } else if (year >= 1L && year <= get_n_years(data)) {
          result[year, fleet_index] <- estimate_mask(rows[row_index, , drop = FALSE], type)[[1]]
        } else {
          cli::cli_abort("Parameter {.val {label}} contains a year outside the modeled range.")
        }
      }
    }
    result
  }
  fleet_vector_mask <- function(label, type) {
    vapply(
      get_fleets(data),
      \(fleet) {
        values <- estimate_mask(rows_for("Fleet", label, fleet), type)
        if (length(values) == 0) FALSE else values[[1]]
      },
      logical(1)
    )
  }
  parameter_mask <- function(type) {
    result <- c(
      selectivity_masks("inflection_point", type),
      selectivity_masks("slope", type),
      selectivity_masks("inflection_point_asc", type),
      selectivity_masks("slope_asc", type),
      selectivity_masks("inflection_point_desc", type),
      selectivity_masks("slope_desc", type),
      recruitment_parameter_mask("log_rzero", type),
      recruitment_parameter_mask("logit_steep", type),
      if (nrow(log_dev_rows) == 0L) rep(FALSE, max(get_n_years(data) - 1L, 0L)) else estimate_mask(log_dev_rows, type),
      if (nrow(log_r_rows) == 0L) rep(FALSE, max(get_n_years(data) - 1L, 0L)) else estimate_mask(log_r_rows, type),
      recruitment_parameter_mask("log_sd", type),
      estimate_mask(log_init_rows, type),
      as.vector(matrix_estimate_mask(log_m_rows, type, by_age = TRUE)),
      as.vector(fleet_parameter_matrix_mask("log_Fmort", type)),
      fleet_vector_mask("log_q", type),
      maturity_parameter_mask("inflection_point", type),
      maturity_parameter_mask("slope", type)
    )
    if (growth_type == "VonBertalanffySchnute") {
      result <- c(
        result,
        growth_parameter_mask("mean_length_young", type),
        growth_parameter_mask("mean_length_old", type),
        growth_parameter_mask("growth_coefficient", type),
        growth_parameter_mask("reference_age_for_length_young", type),
        growth_parameter_mask("reference_age_for_length_old", type),
        growth_parameter_mask("length_weight_a", type),
        growth_parameter_mask("length_weight_b", type),
        if (any(growth_parameters[["label"]] %in% c(
          "log_sd_mean_length_young",
          "log_sd_mean_length_old",
          "log_sd_growth_coefficient",
          "mean_length_young_mean_length_old_logit_corr",
          "mean_length_young_growth_coefficient_logit_corr",
          "mean_length_old_growth_coefficient_logit_corr"
        ))) {
          unlist(lapply(
            c(
              "log_sd_mean_length_young",
              "log_sd_mean_length_old",
              "log_sd_growth_coefficient",
              "mean_length_young_mean_length_old_logit_corr",
              "mean_length_young_growth_coefficient_logit_corr",
              "mean_length_old_growth_coefficient_logit_corr"
            ),
            growth_parameter_mask,
            type = type
          ), use.names = FALSE)
        } else {
          growth_parameter_mask("length_at_age_sd_at_reference_ages", type)
        }
      )
    }
    result
  }
  fixed_parameter_mask <- parameter_mask("fixed_effects")
  random_parameter_mask <- parameter_mask("random_effects")

  c(list(
    fleet_names = get_fleets(data),
    selectivity_types = parameters |>
      dplyr::filter(.data$module_name == "Selectivity") |>
      dplyr::distinct(.data$fleet, .data$module_type) |>
      dplyr::right_join(
        tibble::tibble(fleet = get_fleets(data)),
        by = "fleet"
      ) |>
      dplyr::arrange(match(.data$fleet, get_fleets(data))) |>
      dplyr::pull(.data$module_type) |>
      {\(x) dplyr::coalesce(x, "Logistic")}(),
    recruitment = recruitment_type,
    growth_model_type = growth_type,
    recruitment_process_active = !is.na(recruitment_process_distribution),
    recruitment_process_mode = recruitment_process_mode,
    recruitment_process_distribution = recruitment_process_distribution,
    catch_distribution = catch_likelihood[["family"]],
    catch_sigma = catch_likelihood[["sigma"]],
    index_distribution = index_likelihood[["family"]],
    index_sigma = index_likelihood[["sigma"]],
    recruitment_deviation_sd = 1,
    recruitment_has_random_devs = any(estimate_mask(log_dev_rows, "random_effects")),
    parameter_names = names(as_julia_fims_parameters(parameters = parameters, data = data)),
    fixed_parameter_mask = fixed_parameter_mask,
    random_parameter_mask = random_parameter_mask
  ), julia_priors)
}

#' Run the Julia backend optimizer
#'
#' @param julia_input Prepared Julia input list.
#' @param model_config Julia backend configuration list.
#' @return A Julia result dictionary converted to an R list.
#' @noRd
fit_julia_backend_model <- function(julia_input, model_config) {
  JuliaCall::julia_call(
    "FIMSBackend.fit_model",
    julia_input[["parameters"]],
    julia_input[["data"]],
    model_config
  )
}

#' Evaluate the Julia backend without optimization
#'
#' @param julia_input Prepared Julia input list.
#' @param model_config Julia backend configuration list.
#' @return A Julia report dictionary converted to an R list.
#' @noRd
evaluate_julia_backend_model <- function(julia_input, model_config) {
  JuliaCall::julia_call(
    "FIMSBackend.evaluate_model",
    julia_input[["parameters"]],
    julia_input[["data"]],
    model_config
  )
}
