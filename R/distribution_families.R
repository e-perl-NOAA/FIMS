#' Distribution families used in FIMS specifications
#'
#' @param link Name of the link function.
#' @return An object of class `family` with a family name and link functions.
#' @export
lognormal <- function(link = "log") {
  structure(c(list(family = "lognormal", link = link), stats::make.link(link)),
    class = "family"
  )
}

#' @rdname lognormal
#' @export
multinomial <- function(link = "logit") {
  structure(c(list(family = "multinomial", link = link), stats::make.link(link)),
    class = "family"
  )
}
