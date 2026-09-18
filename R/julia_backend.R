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

  if (!requireNamespace("JuliaCall", quietly = TRUE)) {
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
#' @return A list representation of the data object.
#' @noRd
as_julia_fims_data <- function(data) {
  list(
    data = as.data.frame(get_data(data)),
    fleets = get_fleets(data),
    n_years = get_n_years(data),
    ages = get_ages(data),
    n_ages = get_n_ages(data),
    lengths = get_lengths(data),
    n_lengths = get_n_lengths(data),
    start_year = get_start_year(data),
    end_year = get_end_year(data)
  )
}

#' Prepare a Julia backend input bundle
#'
#' @param parameters Parameter tibble.
#' @param data A `FIMSFrame` object.
#' @return A list with Julia-ready `data` and `parameters` entries.
#' @noRd
prepare_julia_backend_input <- function(parameters, data) {
  list(
    data = as_julia_fims_data(data),
    parameters = as.data.frame(parameters)
  )
}
