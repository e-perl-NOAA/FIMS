simulate_julia_observations <- function(data, config, report, complete = FALSE) {
  if (!is.logical(complete) || length(complete) != 1L || is.na(complete)) {
    cli::cli_abort("{.arg complete} must be TRUE or FALSE.")
  }
  simulated <- list()
  for (stream in c("catch", "index")) {
    observed_name <- paste0("observed_", stream)
    observed <- data[[observed_name]]
    if (is.null(observed)) {
      next
    }
    expected <- as_julia_backend_matrix(report[[paste0(stream, "_expected_by_fleet")]])
    if (!identical(dim(expected), dim(observed))) {
      cli::cli_abort("Simulation expected {stream} dimensions do not match the input data.")
    }
    families <- rep_len(config[[paste0(stream, "_distribution")]], length(observed))
    sigma <- rep_len(config[[paste0(stream, "_sigma")]], length(observed))
    values <- observed
    present <- is.finite(observed) & observed != -999
    for (index in which(present)) {
      family <- tolower(families[[index]])
      values[[index]] <- switch(family,
        dnorm = stats::rnorm(1L, expected[[index]], sigma[[index]]),
        dlnorm = stats::rlnorm(1L, log(expected[[index]]), sigma[[index]]),
        cli::cli_abort("Unsupported simulation family: {family}.")
      )
    }
    simulated[[observed_name]] <- values
  }
  for (stream in c("age", "length")) {
    observed_name <- paste0("observed_", stream, "_comp")
    observed <- data[[observed_name]]
    if (is.null(observed)) {
      next
    }
    probabilities <- report[[paste0(stream, "comp_proportion")]]
    probability_values <- as_julia_backend_numeric(probabilities)
    if (length(probability_values) != length(observed)) {
      cli::cli_abort("Simulation expected {stream} composition dimensions do not match the input data.")
    }
    probabilities <- array(probability_values, dim = dim(observed))
    values <- observed
    for (fleet in seq_len(dim(observed)[[3]])) {
      for (year in seq_len(dim(observed)[[1]])) {
        counts <- observed[year, , fleet]
        if (any(!is.finite(counts) | counts == -999)) {
          next
        }
        # Likelihoods allow fractional effective counts; simulations require an
        # integer sample size and round the row total, as R's rmultinom does.
        values[year, , fleet] <- as.numeric(stats::rmultinom(
          1L,
          size = round(sum(counts)), prob = probabilities[year, , fleet]
        ))
      }
    }
    simulated[[observed_name]] <- values
  }
  if (complete) c(report, simulated) else simulated
}

#' Summarize model uncertainty
#'
#' @param object A result returned by [get_sdreport()].
#' @param select One or more of `"fixed"`, `"random"`, and `"report"`.
#' @param ... Unused.
#' @return A matrix with columns `Estimate` and `Std. Error`.
#' @export
summary.FIMSSdreport <- function(object, select = c("fixed", "random", "report"), ...) {
  select <- match.arg(select, c("fixed", "random", "report"), several.ok = TRUE)
  sections <- lapply(select, function(section) {
    values <- switch(section,
      fixed = object[["par.fixed"]],
      random = object[["par.random"]],
      report = object[["value"]]
    )
    errors <- switch(section,
      fixed = sqrt(diag(object[["cov.fixed"]])),
      random = sqrt(object[["diag.cov.random"]]),
      report = object[["sd"]]
    )
    result <- cbind(Estimate = as.numeric(values), "Std. Error" = as.numeric(errors))
    rownames(result) <- names(values)
    result
  })
  do.call(rbind, sections)
}
