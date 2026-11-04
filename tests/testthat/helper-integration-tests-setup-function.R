# Helper file for FIMS R tests----
# This file contains multiple functions that are used to set up and run
# FIMS models with the high-level R interface. The functions are sourced by
# devtools::load_all().

# FIMS dmultinorm function ----
#' FIMS dmultinom()
#' This function matches the dmultinom() function in TMB and differs from R
#' by NOT rounding obs to the nearest integer. The function is evaluated in
#' log space and returns the log probability mass function.
#'
#' @param x A vector of length K of numeric values.
#' @param p A numeric non-negative vector of length K, specifying the probability
#' for the K classes; must sum 1.
#'
#' @return The log of the probability mass function for the multinomial.
FIMS_dmultinom <- function(x, p) {
  xp1 <- x + 1
  log_pmf <- lgamma(sum(x) + 1) - sum(lgamma(xp1)) + sum(x * log(p))
  return(log_pmf)
}


setup_and_run_FIMS_with_wrappers <- function(iter_id,
                                             om_input_list,
                                             om_output_list,
                                             em_input_list,
                                             estimation_mode = TRUE,
                                             random_effects = FALSE,
                                             modified_parameters,
                                             map = list()) {
  # Load operating model data for the current iteration
  om_input <- om_input_list[[iter_id]]
  om_output <- om_output_list[[iter_id]]
  em_input <- em_input_list[[iter_id]]

  # Clear any previous FIMS settings
  clear()

  data <- FIMS::FIMSFrame(data_big)
  if (tibble::is_tibble(modified_parameters)) {
    parameters <- modified_parameters
  } else {
    parameters <- modified_parameters[[iter_id]]
  }

  # The model will not always run when log_q is very small.
  # We will need to make sure log_q is the true value for deterministic runs but
  # then reset to log(1.0) for estimation runs.
  if (estimation_mode == TRUE) {
    parameters <- parameters |>
      dplyr::mutate(
        value = dplyr::if_else(
          fleet == "survey1" & label == "log_q",
          log(1.0),
          value
        )
      )
  }

  parameter_list <- initialize_fims(
    parameters = parameters,
    data = data
  )

  fit <- fit_fims(input = parameter_list, optimize = estimation_mode)

  clear()
  # Return the results as a list
  return(fit)
}
