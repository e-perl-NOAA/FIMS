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
#' placeholder columns (`recdevs*`). When a default SEM is generated, equations
#' are concatenated with `"; "` separators.
#'
#' @param dsem_settings A list returned by [build_DSEM()].
#' @param data A `FIMSFrame` object used to determine model start and end years.
#' @param env_data An optional data frame of environmental covariates. If
#'   supplied, it may include a `Year` column; missing years are padded to the
#'   FIMS model range.
#' @param n_recdevs Number of `recdevs*` columns to prepend.
#'
#' @return A named list with `dsem_settings`, `dsem_data`, and `tmb_inputs`.
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
      if (nrow(env_data) > length(years)) {
        cli::cli_abort(
          "{.var env_data} has more rows than model years and no {.field Year} column."
        )
      }
      env_data <- dplyr::mutate(env_data, Year = years[seq_len(nrow(env_data))])
    }
    dsem_data <- env_data |>
      dplyr::full_join(tibble::tibble(Year = years), by = "Year") |>
      dplyr::arrange(.data$Year)
  }

  dsem_data <- dplyr::select(dsem_data, -"Year")

  recdev_cols <- paste0("recdevs", seq_len(n_recdevs))
  recdev_df <- as.data.frame(
    setNames(
      rep(list(rep(NA_real_, nrow(dsem_data))), n_recdevs),
      recdev_cols
    )
  )
  dsem_data <- dplyr::bind_cols(
    tibble::as_tibble(recdev_df),
    dsem_data
  )

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
        paste0("recdevs", sp, " <-> recdevs", sp, ", 0, sigmaR", sp, ", 1")
      )
    }
    dsem_settings$sem <- paste0(sem, collapse = "; ")
  }

  tmb_inputs <- if (requireNamespace("dsem", quietly = TRUE)) {
    .build_tmb_inputs_with_dsem(
      sem = dsem_settings$sem,
      dsem_data = dsem_data,
      family = dsem_settings$family
    )
  } else {
    .build_tmb_inputs_simple(
      sem = dsem_settings$sem,
      dsem_data = dsem_data,
      family = dsem_settings$family
    )
  }

  list(
    dsem_settings = dsem_settings,
    dsem_data = dsem_data,
    tmb_inputs = tmb_inputs
  )
}

#' @noRd
.parse_sem_lines <- function(sem) {
  lines <- unlist(strsplit(sem, ";|\n"))
  lines <- trimws(lines)
  lines <- lines[nzchar(lines)]
  out <- vector("list", length(lines))
  for (i in seq_along(lines)) {
    parts <- trimws(unlist(strsplit(lines[i], ",")))
    if (length(parts) != 4) {
      cli::cli_abort(
        "SEM parse error on line {i}: {.code {lines[i]}}. Each line must have 4 fields: relation, lag, parameter, start."
      )
    }
    rel <- trimws(parts[1])
    lag <- as.integer(trimws(parts[2]))
    par_name <- trimws(parts[3])
    start <- as.numeric(trimws(parts[4]))

    if (grepl("<->", rel, fixed = TRUE)) {
      vars <- trimws(unlist(strsplit(rel, "<->", fixed = TRUE)))
      op <- "<->"
    } else if (grepl("->", rel, fixed = TRUE)) {
      vars <- trimws(unlist(strsplit(rel, "->", fixed = TRUE)))
      op <- "->"
    } else {
      cli::cli_abort(
        "SEM relation parse error on line {i}: {.code {lines[i]}}. Relation must use `->` or `<->`."
      )
    }
    if (length(vars) != 2) {
      cli::cli_abort("SEM relation must include two variable names.")
    }
    out[[i]] <- list(
      first = vars[1],
      second = vars[2],
      op = op,
      lag = lag,
      param = par_name,
      start = start
    )
  }
  out
}

#' @noRd
.family_to_code <- function(family) {
  lut <- c(
    fixed = 0,
    normal = 1,
    bernoulli = 2,
    poisson = 3,
    gamma = 4
  )
  if (!all(family %in% names(lut))) {
    bad <- unique(family[!family %in% names(lut)])
    cli::cli_abort("Unsupported DSEM family values: {.code {bad}}")
  }
  unname(as.numeric(lut[family]))
}

#' @noRd
.build_tmb_inputs_simple <- function(sem, dsem_data, family) {
  terms <- .parse_sem_lines(sem)
  var_names <- colnames(dsem_data)
  n_t <- nrow(dsem_data)
  n_j <- ncol(dsem_data)
  var_idx <- stats::setNames(seq_len(n_j), var_names)

  param_lookup <- new.env(parent = emptyenv())
  param_lookup$names <- character(0)
  param_lookup$starts <- numeric(0)
  RAM <- matrix(0, nrow = 0, ncol = 4)
  RAMstart <- numeric(0)

  get_param_idx <- function(name, start) {
    idx <- match(name, param_lookup$names)
    if (is.na(idx)) {
      param_lookup$names <- c(param_lookup$names, name)
      param_lookup$starts <- c(param_lookup$starts, start)
      idx <- length(param_lookup$names)
    }
    idx
  }

  for (term in terms) {
    missing_vars <- c(
      if (!term$first %in% var_names) term$first,
      if (!term$second %in% var_names) term$second
    )
    if (length(missing_vars) > 0) {
      cli::cli_abort(
        "SEM variables must match DSEM data columns. Missing: {.code {missing_vars}}."
      )
    }
    pidx <- get_param_idx(term$param, term$start)
    from_j <- var_idx[[term$first]]
    to_j <- var_idx[[term$second]]

    if (identical(term$op, "->")) {
      for (t in seq_len(n_t)) {
        from_t <- t - term$lag
        if (from_t < 1 || from_t > n_t) next
        row_k <- (to_j - 1) * n_t + t
        col_k <- (from_j - 1) * n_t + from_t
        RAM <- rbind(RAM, c(1, row_k, col_k, pidx))
        RAMstart <- c(RAMstart, term$start)
      }
    } else {
      for (t in seq_len(n_t)) {
        row_k <- (to_j - 1) * n_t + t
        col_k <- (from_j - 1) * n_t + t
        RAM <- rbind(RAM, c(2, row_k, col_k, pidx))
        RAMstart <- c(RAMstart, term$start)
      }
    }
  }

  list(
    options = c(0, 0),
    RAM = RAM,
    RAMstart = RAMstart,
    familycode_j = .family_to_code(family),
    y_tj = as.matrix(dsem_data),
    parameters = list(
      beta_z = param_lookup$starts,
      lnsigma_j = rep(log(0.1), n_j),
      mu_j = rep(0, n_j),
      delta0_j = numeric(0),
      x_tj = matrix(0, nrow = n_t, ncol = n_j)
    ),
    map = NULL
  )
}

#' @noRd
.build_tmb_inputs_with_dsem <- function(sem, dsem_data, family) {
  dsem_control <- dsem::dsem_control(
    use_REML = FALSE,
    run_model = FALSE,
    quiet = TRUE,
    getJointPrecision = TRUE,
    newton_loops = 0
  )

  fit_dsem <- dsem::dsem(
    sem = sem,
    tsdata = stats::ts(dsem_data),
    family = family,
    control = dsem_control
  )

  list(
    options = fit_dsem$tmb_inputs$data$options,
    RAM = fit_dsem$tmb_inputs$data$RAM,
    RAMstart = fit_dsem$tmb_inputs$data$RAMstart,
    familycode_j = fit_dsem$tmb_inputs$data$familycode_j,
    y_tj = fit_dsem$tmb_inputs$data$y_tj,
    parameters = fit_dsem$tmb_inputs$parameters,
    map = fit_dsem$tmb_inputs$map
  )
}

#' @noRd
initialize_dsem_distribution <- function(dsem) {
  if (is.null(dsem$tmb_inputs)) {
    cli::cli_abort("The {.var dsem} object must include {.field tmb_inputs}.")
  }
  dsem_tmb <- dsem$tmb_inputs
  module <- methods::new(DSEMDistribution)

  module$options$resize(length(dsem_tmb$options))
  purrr::walk(seq_along(dsem_tmb$options), \(i) module$options$set(i - 1, dsem_tmb$options[i]))

  RAM <- as.matrix(dsem_tmb$RAM)
  ram_values <- as.vector(RAM)
  module$RAM_n_rows$set(nrow(RAM))
  module$RAM$resize(length(RAM))
  purrr::walk(seq_along(ram_values), \(i) module$RAM$set(i - 1, ram_values[i]))

  module$RAMstart$resize(length(dsem_tmb$RAMstart))
  purrr::walk(seq_along(dsem_tmb$RAMstart), \(i) module$RAMstart[i]$value <- dsem_tmb$RAMstart[i])
  module$RAMstart$set_all_estimable(FALSE)
  module$RAMstart$set_all_random(FALSE)

  module$familycode_j$resize(length(dsem_tmb$familycode_j))
  purrr::walk(seq_along(dsem_tmb$familycode_j), \(i) module$familycode_j$set(i - 1, dsem_tmb$familycode_j[i]))

  y_tj <- as.matrix(dsem_tmb$y_tj)
  y_values <- as.vector(y_tj)
  module$n_t$set(nrow(y_tj))
  module$n_j$set(ncol(y_tj))
  module$y_tj$resize(length(y_tj))
  purrr::walk(seq_along(y_values), \(i) module$y_tj[i]$value <- y_values[i])
  module$y_tj$set_all_estimable(FALSE)
  module$y_tj$set_all_random(FALSE)

  set_vec <- function(target, values, estimation_type = "fixed_effects") {
    target$resize(length(values))
    purrr::walk(seq_along(values), \(i) target[i]$value <- values[i])
    target$set_all_estimable(estimation_type != "constant")
    target$set_all_random(estimation_type == "random_effects")
  }

  set_vec(module$beta_z, dsem_tmb$parameters$beta_z, "fixed_effects")
  set_vec(module$lnsigma_j, dsem_tmb$parameters$lnsigma_j, "fixed_effects")
  set_vec(module$mu_j, dsem_tmb$parameters$mu_j, "fixed_effects")

  delta0_j <- dsem_tmb$parameters$delta0_j
  if (is.null(delta0_j)) delta0_j <- numeric(0)
  set_vec(module$delta0_j, delta0_j, "fixed_effects")

  set_vec(module$x_tj, as.vector(dsem_tmb$parameters$x_tj), "random_effects")

  module
}
