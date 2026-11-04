#' Initialize a FIMS model
#'
#' Prepare a self-contained Julia model from the parameter tibble and data.
#' Julia is initialized lazily when the model is fitted. The former native
#' module API and `backend = "tmb"` have been retired.
#'
#' @param parameters Parameter tibble returned by [setup_default_parameters()].
#' @param data A [FIMSFrame()] object.
#' @param backend The model backend. Only `"julia"` is supported.
#' @param priors Optional prior tibble with `module_name`, `fleet`, `label`,
#'   `timing`, `age`, `distribution`, `mean`, and `sd`. Normal and lognormal
#'   priors are supported on the parameter's documented natural scale.
#' @return An input list for [fit_fims()], retaining its parameters, data,
#'   configuration and priors independently of other models.
#' @export
#' @examples
#' \dontrun{
#' data <- FIMSFrame(data_big)
#' input <- setup_default_parameters(data) |> initialize_fims(data)
#' fit <- fit_fims(input)
#' }
initialize_fims <- function(parameters, data, backend = "julia", priors = NULL) {
  if (length(backend) != 1L || is.na(backend) ||
    !identical(tolower(backend), "julia")) {
    cli::cli_abort(
      'The native backend has been retired. Use backend = "julia", or omit backend.'
    )
  }
  if (missing(parameters) || !tibble::is_tibble(parameters)) {
    cli::cli_abort("The {.var parameters} argument must be a tibble.")
  }
  if (!methods::is(data, "FIMSFrame")) {
    cli::cli_abort("{.arg data} must be a FIMSFrame object.")
  }
  valid_types <- c("constant", "fixed_effects", "random_effects")
  invalid_types <- setdiff(stats::na.omit(parameters[["estimation_type"]]), valid_types)
  if (length(invalid_types) > 0L) {
    cli::cli_abort("The estimation_type must be one of: {valid_types}. Invalid values: {invalid_types}.")
  }
  fleets <- unique(stats::na.omit(parameters[["fleet"]]))
  if (length(fleets) == 0L) {
    cli::cli_abort("No fleets found in parameters. Create parameters with setup_default_parameters().")
  }
  julia_input <- prepare_julia_backend_input(parameters, data)
  config <- as_julia_fims_model_config(parameters, data, priors)
  structure(
    list(parameters = julia_input[["parameters"]], model = NULL),
    backend = "julia",
    parameter_info = parameters,
    julia_input = julia_input,
    julia_model_config = config,
    julia_priors = priors
  )
}
