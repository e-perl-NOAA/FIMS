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
#' @return Invisibly returns `TRUE` when Julia is initialized, otherwise `FALSE`.
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
    return(invisible(FALSE))
  }

  JuliaCall::julia_setup(installJulia = FALSE)
  JuliaCall::julia_command("using Pkg")
  JuliaCall::julia_command(
    sprintf('Pkg.activate(raw"%s")', normalizePath(package_path, winslash = "/"))
  )
  JuliaCall::julia_command(
    sprintf("Base.include(Main, raw\"%s\")", normalizePath(module_path, winslash = "/"))
  )
  JuliaCall::julia_command("using .FIMSBackend")

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

  assert_single_fleet <- function(data, data_type, description) {
    matched_fleets <- data |>
      dplyr::filter(.data$type == .env$data_type) |>
      dplyr::pull(.data$fleet) |>
      unique() |>
      stats::na.omit()

    if (length(matched_fleets) > 1) {
      cli::cli_abort(
        "The experimental Julia backend currently supports only one {description} fleet, but found: {matched_fleets}."
      )
    }

    matched_fleets
  }

  agecomp_fleet <- assert_single_fleet(fleet_data, "age_comp", "age-composition") |>
    {\(x) if (length(x) > 0) x[[1]] else NA_character_}()
  catch_fleet <- assert_single_fleet(fleet_data, "catch", "catch") |>
    {\(x) if (length(x) > 0) x[[1]] else NA_character_}()
  index_fleet <- assert_single_fleet(fleet_data, "index", "index") |>
    {\(x) if (length(x) > 0) x[[1]] else NA_character_}()

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
  } else {
    rep(proportion_female, length.out = n_ages)
  }

  weights_at_age <- model_weight_at_age(data)
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
    data = as.data.frame(fleet_data),
    fleets = fleets,
    n_years = n_years,
    ages = ages,
    n_ages = n_ages,
    lengths = get_lengths(data),
    n_lengths = get_n_lengths(data),
    start_year = get_start_year(data),
    end_year = get_end_year(data),
    weights_at_age = weights_at_age,
    maturity_at_age = matrix(rep(maturity_by_age, times = n_years), nrow = n_years, byrow = TRUE),
    proportion_female = proportion_female
  )

  if (!is.na(catch_fleet)) {
    julia_data[["observed_catch"]] <- model_catch(data, catch_fleet)
  }

  if (!is.na(index_fleet)) {
    julia_data[["observed_index"]] <- model_index(data, index_fleet)
  }

  if (!is.na(agecomp_fleet)) {
    julia_data[["observed_age_comp"]] <- matrix(
      model_age_comp(data, agecomp_fleet),
      nrow = n_years,
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
  fleet_data <- get_data(data)
  n_years <- get_n_years(data)
  n_ages <- get_n_ages(data)

  selectivity_fleet <- fleet_data |>
    dplyr::filter(.data$type == "catch") |>
    dplyr::pull(.data$fleet) |>
    unique() |>
    stats::na.omit() |>
    {\(x) if (length(x) > 0) x[[1]] else get_fleets(data)[[1]]}()

  catch_fleet_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Fleet", .data$fleet == selectivity_fleet)
  selectivity_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Selectivity", .data$fleet == selectivity_fleet)
  recruitment_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Recruitment")
  population_parameters <- parameters |>
    dplyr::filter(.data$module_name == "Population")

  value_or_default <- function(data, label, default = numeric()) {
    out <- data |>
      dplyr::filter(.data$label == .env$label) |>
      dplyr::pull(.data$value)
    if (length(out) == 0) default else out
  }

  log_fmort <- value_or_default(
    catch_fleet_parameters,
    "log_Fmort",
    rep(-3, n_years * n_ages)
  )
  log_m <- value_or_default(
    population_parameters,
    "log_M",
    rep(log(0.2), n_years * n_ages)
  )

  list(
    inflection_point = value_or_default(selectivity_parameters, "inflection_point", 2)[[1]],
    slope = value_or_default(selectivity_parameters, "slope", 1)[[1]],
    inflection_point_asc = value_or_default(selectivity_parameters, "inflection_point_asc", 2)[[1]],
    slope_asc = value_or_default(selectivity_parameters, "slope_asc", 1)[[1]],
    inflection_point_desc = value_or_default(selectivity_parameters, "inflection_point_desc", 4)[[1]],
    slope_desc = value_or_default(selectivity_parameters, "slope_desc", 1)[[1]],
    log_rzero = value_or_default(recruitment_parameters, "log_rzero", log(1e6))[[1]],
    logit_steep = value_or_default(recruitment_parameters, "logit_steep", 0)[[1]],
    log_devs = value_or_default(recruitment_parameters, "log_devs", rep(0, max(n_years - 1, 0))),
    log_init_naa = value_or_default(population_parameters, "log_init_naa", rep(log(1e6), n_ages)),
    log_M = rep(log_m, length.out = n_years * n_ages),
    log_Fmort = rep(log_fmort, length.out = n_years * n_ages),
    log_q = value_or_default(catch_fleet_parameters, "log_q", 0)[[1]]
  )
}

#' Assign prepared Julia input into the Julia session
#'
#' @param julia_input Prepared Julia input list.
#' @return Invisibly returns `TRUE` when assignments are attempted.
#' @noRd
assign_julia_backend_input <- function(julia_input) {
  JuliaCall::julia_assign("fims_data", julia_input[["data"]])
  JuliaCall::julia_assign("fims_parameters", julia_input[["parameters"]])
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
