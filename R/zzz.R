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
#' @param x A numeric vector.
#' @return A numeric vector on the transformed scale.
#' @export
logit <- function(x) stats::qlogis(x)

#' @rdname logit
#' @export
inv_logit <- function(x) stats::plogis(x)
