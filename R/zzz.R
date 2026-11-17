#' Clear retained backend input
#'
#' Models and fitted objects own their inputs. Clearing the optional backend
#' scratch input does not invalidate existing fits, objectives or reports.
#' Julia is not started by this function.
#' @return Invisibly returns `NULL`.
#' @export
clear <- function() {
  if (isTRUE(.fims_julia_backend_state[["initialized"]])) {
    JuliaCall::julia_command("FIMSBackend.set_backend_input!(nothing, nothing)")
  }
  invisible(NULL)
}

#' Transform probabilities to and from the logit scale
#' @param a,b Numeric lower and upper bounds.
#' @param x A single numeric value to transform.
#' @return A single numeric value on the transformed scale.
#' @export
logit <- function(a, b, x) {
  if (any(lengths(list(a, b, x)) != 1L)) {
    cli::cli_abort("Expecting a single value for each of {.arg a}, {.arg b}, and {.arg x}.")
  }
  stats::qlogis((x - a) / (b - a))
}

#' @rdname logit
#' @export
inv_logit <- function(a, b, x) {
  if (any(lengths(list(a, b, x)) != 1L)) {
    cli::cli_abort("Expecting a single value for each of {.arg a}, {.arg b}, and {.arg x}.")
  }
  a + (b - a) * stats::plogis(x)
}
