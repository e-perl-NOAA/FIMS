#' Build DSEM settings for FIMS workflows
#'
#' @description
#' Create a DSEM settings object that follows the same high-level interface used
#' in Rceattle while fitting into FIMS naming and workflow conventions.
#'
#' @param sem A character string containing the SEM specification. If `NULL`,
#'   users can generate an IID default SEM with [build_dsem_objects()].
#' @param family A character vector describing observation families for the DSEM
#'   variables. If length one, it is recycled over all DSEM columns.
#' @param all_vars A logical indicating whether all variables in the DSEM data
#'   are estimated in the likelihood.
#' @param estimate_projection A logical indicating whether latent variables are
#'   estimated for projection years.
#'
#' @return A named list with DSEM settings.
#' @export
build_DSEM <- function(
    sem = NULL,
    family = "normal",
    all_vars = FALSE,
    estimate_projection = FALSE
) {
  list(
    sem = sem,
    family = family,
    all_vars = all_vars,
    estimate_projection = estimate_projection
  )
}

#' Build DSEM data objects using FIMS data structures
#'
#' @description
#' Construct DSEM-ready data from a `FIMSFrame` object and optional environmental
#' covariates. This helper mirrors the data-shaping behavior used in Rceattle:
#' it pads years to the FIMS model range and prepends recruitment-deviation
#' placeholder columns (`recdevs*`).
#'
#' @param dsem_settings A list returned by [build_DSEM()].
#' @param data A `FIMSFrame` object used to determine model start and end years.
#' @param env_data An optional data frame of environmental covariates. If
#'   supplied, it may include a `Year` column; missing years are padded to the
#'   FIMS model range.
#' @param n_recdevs Number of `recdevs*` columns to prepend.
#'
#' @return A named list with `dsem_settings` and `dsem_data`.
#' @export
build_dsem_objects <- function(
    dsem_settings = NULL,
    data = NULL,
    env_data = NULL,
    n_recdevs = 1L
) {
  if (is.null(dsem_settings)) {
    dsem_settings <- build_DSEM()
  }
  if (!inherits(data, "FIMSFrame")) {
    cli::cli_abort("{.var data} must be a {.cls FIMSFrame} object.")
  }
  if (!is.numeric(n_recdevs) || length(n_recdevs) != 1 || n_recdevs < 1) {
    cli::cli_abort("{.var n_recdevs} must be a single integer >= 1.")
  }
  n_recdevs <- as.integer(n_recdevs)

  years <- seq.int(get_start_year(data), get_end_year(data))

  if (is.null(env_data)) {
    dsem_data <- tibble::tibble(Year = years)
  } else {
    if (!is.data.frame(env_data)) {
      cli::cli_abort("{.var env_data} must be a data frame when provided.")
    }
    if (!"Year" %in% names(env_data)) {
      env_data <- dplyr::mutate(env_data, Year = years[seq_len(nrow(env_data))])
    }
    dsem_data <- env_data |>
      dplyr::full_join(tibble::tibble(Year = years), by = "Year") |>
      dplyr::arrange(.data$Year)
  }

  dsem_data <- dplyr::select(dsem_data, -"Year")

  for (sp in seq(from = n_recdevs, to = 1L)) {
    dsem_data <- dsem_data |>
      dplyr::mutate(recdevs = NA_real_) |>
      dplyr::relocate(.data$recdevs)
    names(dsem_data)[1] <- paste0("recdevs", sp)
  }

  if (length(dsem_settings$family) == 1) {
    dsem_settings$family <- rep(dsem_settings$family, ncol(dsem_data))
  }
  if (length(dsem_settings$family) != ncol(dsem_data)) {
    cli::cli_abort(
      "Length of {.var family} in {.fn build_DSEM} must equal 1 or {.code ncol(dsem_data)}."
    )
  }

  if (is.null(dsem_settings$sem)) {
    sem <- character(0)
    for (sp in seq_len(n_recdevs)) {
      sem <- c(
        sem,
        paste0("recdevs", sp, " <-> recdevs", sp, ", 0, sigmaR", sp, ", 1\n")
      )
    }
    dsem_settings$sem <- paste0(sem, collapse = " ")
  }

  list(
    dsem_settings = dsem_settings,
    dsem_data = dsem_data
  )
}
