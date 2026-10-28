# Developers: ----

# This file defines the parent class of FIMSFit and its potential children. The
# class is an S4 class with accessors and validators but no setters. For more
# details on how to create an S4 class in FIMS please see R/fimsframe.R

# TODO: ----

# TODO: Fix "no metadata object found to revise superClass" in sdreportOrList
# TODO: Write more validity checks for FIMSFit
# TODO: Better document the return of [get_estimates()], i.e., columns
# TODO: Make a helper function to add lower and upper CI for users in estimates

# methods::setClass: ----

# Need to use an S3 class for the following S4 class
methods::setOldClass(Classes = "package_version")
methods::setOldClass(Classes = "difftime")
methods::setOldClass(Classes = "sdreport")
# Join sdreport and list into a class in case the sdreport is not created
methods::setClassUnion("sdreportOrList", members = c("sdreport", "list"))

methods::setClass(
  Class = "FIMSFit",
  slots = c(
    input = "list",
    obj = "list",
    opt = "list",
    max_gradient = "numeric",
    gradient = "numeric",
    report = "list",
    sdreport = "sdreportOrList",
    number_of_parameters = "integer",
    run_time = "difftime",
    version = "package_version",
    model_output = "character"
  )
)

# methods::setMethod: printers ----
# TODO: add `get_report`, `get_opt`, etc. to the list of available slots in show()?
methods::setMethod(
  f = "show",
  signature = "FIMSFit",
  definition = function(object) {
    cli::cli_inform(c(
      "i" = "The object is of the class FIMSFit v.{get_version(object)}",
      "i" = "The slots can be accessed using {.fn get_*} functions, e.g.,",
      "*" = "{.fn get_model_output}",
      "*" = "{.fn get_obj}",
      "*" = "{.fn get_version}",
      "i" = "The following slots are available: {methods::slotNames(object)}.",
      "i" = "Use {.fn print} to see a summary of the fit."
    ))
  }
)

methods::setMethod(
  f = "print",
  signature = "FIMSFit",
  definition = function(x) {
    rt <- as.numeric(x@run_time[["time_total"]], units = "secs")
    ru <- "seconds"
    if (rt > 60 * 60 * 24) {
      rt <- rt / (60 * 60 * 24)
      ru <- "days"
    } else if (rt > 60 * 60) {
      rt <- rt / (60 * 60)
      ru <- "hours"
    } else if (rt > 60) {
      rt <- rt / 60
      ru <- "minutes"
    }

    number_of_parameters <- paste(
      names(x@number_of_parameters),
      x@number_of_parameters,
      sep = "="
    )
    total_parameters <- sum(x@number_of_parameters)
    all_parameters_info <- c(number_of_parameters, paste(
      "total",
      total_parameters,
      sep = "="
    ))
    div_digit <- cli::cli_div(theme = list(.val = list(digits = 5)))
    terminal_ssb <- sapply(
      x@report[["spawning_biomass"]],
      function(y) utils::tail(y, 1)
    )
    cli::cli_inform(c(
      "i" = "FIMS model version: {.val {x@version}}",
      "i" = "Total run time was {.val {rt}} {ru}",
      "i" = "Number of parameters: {all_parameters_info}",
      "i" = "Maximum gradient= {.val {x@max_gradient}}",
      "i" = "Negative log likelihood (NLL):",
      "*" = "Marginal NLL= {.val {x@opt$objective}}",
      "*" = "Total NLL= {.val {x@report$jnll}}",
      "i" = "Terminal SB= {.val {terminal_ssb}}"
    ))
    cli::cli_end(div_digit)
  }
)

# methods::setMethod: accessors ----

# Accessor functions for a FIMSFit object
# 1 methods::setGeneric() per slot but potentially >1 methods::setMethod() per methods::setGeneric()

#' Get a slot in a FIMSFit object
#'
#' There is an accessor function for each slot in the S4 class `FIMSFit`, where
#' the function is named `get_*()` and the star can be replaced with the slot
#' name, e.g., [get_input()]. These accessor functions are the preferred way
#' to access objects stored in the available slots.
#'
#' @param x Output returned from [fit_fims()].
#' @name get_FIMSFit
#' @seealso
#' * [fit_fims()]
#' * [setup_default_parameters()]
NULL

#' @return
#' [get_input()] returns the list that was used to fit the FIMS model, which
#' is the returned object from [setup_default_parameters()].
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_input", function(x) standardGeneric("get_input"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_input", "FIMSFit", function(x) x@input)

#' @return
#' [get_report()] returns the TMB report, where anything that is flagged as
#' reportable in the C++ code is returned.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_report", function(x) standardGeneric("get_report"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_report", "FIMSFit", function(x) x@report)

#' @return
#' [get_obj()] returns the output from [TMB::MakeADFun()].
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_obj", function(x) standardGeneric("get_obj"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_obj", "FIMSFit", function(x) x@obj)

#' @return
#' [get_opt()] returns the output from [nlminb()], which is the minimizer used
#' in [fit_fims()].
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_opt", function(x) standardGeneric("get_opt"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_opt", "FIMSFit", function(x) x@opt)

#' @return
#' [get_max_gradient()] returns the maximum gradient found when optimizing the
#' model.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_max_gradient", function(x) standardGeneric("get_max_gradient"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_max_gradient", "FIMSFit", function(x) x@max_gradient)

#' @return
#' [get_gradient()] returns the per-parameter gradient vector at the MLE as
#' stored during fitting. Unlike calling `get_obj(x)[["gr"]](get_opt(x)[["par"]])`
#' this function is safe to call after [clear()] because it reads
#' from a stored R vector rather than the compiled C++ objective function.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_gradient", function(x) standardGeneric("get_gradient"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_gradient", "FIMSFit", function(x) x@gradient)

#' @return
#' [get_sdreport()] returns the list from [TMB::sdreport()].
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_sdreport", function(x) standardGeneric("get_sdreport"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_sdreport", "FIMSFit", function(x) x@sdreport)

#' @return
#' [get_estimates()] returns a tibble of parameter values and their
#' uncertainties from a fitted model. The `year_i` column is a position that
#' starts at 1, and the `age` and `length` columns are the ages and length bins
#' from the data. `age` is `NA` if populations have different ages, and both
#' are `NA` for fits saved before they were added to the output.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_estimates", function(x) standardGeneric("get_estimates"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod(
  "get_estimates",
  "FIMSFit",
  function(x) {
    if (is_julia_backend_input(get_input(x))) {
      return(get_input(x)[["julia_estimates"]])
    }

    # Helper function
    add_unique_id <- function(data) {
      dplyr::group_by(data, .data$label) |>
        dplyr::mutate(
          unique_id = paste(
            .data$label,
            dplyr::if_else(
              is.na(.data$parameter_id),
              seq_len(dplyr::n()),
              .data$parameter_id
            ),
            sep = "_"
          )
        ) |>
        dplyr::ungroup()
    }
    # Extract the core TMB components (object, sdreport, optimization result)
    # from the fit object.
    obj <- get_obj(x)
    sdreport <- get_sdreport(x)
    opt <- get_opt(x)
    parameter_names <- get_obj(x)[["par"]] |>
      names()

    # Reshape the TMB output into a standardized data frame.
    # This serves as the "expected" result to compare against.
    tmb_output <- reshape_tmb_estimates(
      obj = obj,
      sdreport = sdreport,
      opt = opt,
      parameter_names = parameter_names,
      precomputed_gradient = get_gradient(x)
    ) |>
      add_unique_id()

    # Extract the model_output, which contains the JSON-like structure.
    model_output <- get_model_output(x)
    # Reshape the output from the JSON structure into a data frame.
    json_output <- reshape_json_estimates(model_output) |>
      add_unique_id()

    # Join the two outputs on parameter_id to compare and consolidate information.
    estimates <- dplyr::left_join(
      # There are more rows in json_estimates than tmb_estimates
      x = json_output,
      y = tmb_output |>
        dplyr::select(dplyr::all_of(c("unique_id", "uncertainty", "log_like_cv", "gradient"))),
      by = c("unique_id")
    ) |>
      dplyr::select(-dplyr::all_of("unique_id")) |>
      dplyr::relocate(dplyr::all_of("uncertainty"), .after = dplyr::all_of("estimation_type"))
  }
)

#' @return
#' [get_number_of_parameters()] returns a vector of integers specifying the
#' number of fixed-effect parameters and the number of random-effect parameters
#' in the model.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric(
  "get_number_of_parameters",
  function(x) standardGeneric("get_number_of_parameters")
)
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod(
  "get_number_of_parameters",
  "FIMSFit",
  function(x) x@number_of_parameters
)

#' @return
#' [get_run_time()] returns the amount of time it took to run the model in
#' seconds as a `difftime` object.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_run_time", function(x) standardGeneric("get_run_time"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_run_time", "FIMSFit", function(x) x@run_time)

#' @return
#' [get_version()] returns the `package_version` of FIMS that was used to fit
#' the model.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_version", function(x) standardGeneric("get_version"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_version", "FIMSFit", function(x) x@version)

#' @return
#' [get_model_output()] returns the finalized FIMS output as a JSON list.
#' @export
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setGeneric("get_model_output", function(x) standardGeneric("get_model_output"))
#' @rdname get_FIMSFit
#' @keywords fit_fims
methods::setMethod("get_model_output", "FIMSFit", function(x) x@model_output)

# methods::setValidity ----

methods::setValidity(
  Class = "FIMSFit",
  method = function(object) {
    errors <- character()

    if (is_julia_backend_input(object@input)) {
      return(TRUE)
    }

    # Check that obj is from TMB::MakeADFun()
    TMB_MakeADFun_names <- c(
      "par", "fn", "gr", "he", "hessian", "method", "retape", "env", "report",
      "simulate"
    )
    if (!setequal(names(object@obj), TMB_MakeADFun_names)) {
      errors <- c(
        errors,
        "obj must be a list returned from TMB::MakeADFun() but it does not
        appear to be so because it does not have the standard names."
      )
    }

    # Return
    if (length(errors) == 0) {
      return(TRUE)
    } else {
      return(errors)
    }
  }
)

# methods::setMethod: is.FIMSFit ----

#' Check if an object is of class FIMSFit
#'
#' @param x Returned list from [fit_fims()].
#' @keywords fit_fims
#' @export
is.FIMSFit <- function(x) {
  inherits(x, "FIMSFit")
}

# Internal helpers for Julia-backed fits ----

is_julia_backend_input <- function(x) {
  identical(attr(x, "backend"), "julia")
}

as_julia_backend_numeric <- function(x) {
  as.numeric(unlist(x, recursive = TRUE, use.names = FALSE))
}

as_julia_backend_matrix <- function(x, nrow = NULL, byrow = TRUE) {
  if (is.matrix(x)) {
    return(x)
  }

  values <- as_julia_backend_numeric(x)
  if (is.null(nrow)) {
    return(matrix(values, nrow = 1))
  }

  matrix(values, nrow = nrow, byrow = byrow)
}

build_julia_backend_report <- function(julia_input, fit_result) {
  report <- fit_result[["report"]]
  data <- julia_input[["data"]]
  parameters <- julia_input[["parameters"]]

  list(
    numbers_at_age = list(as.numeric(t(as_julia_backend_matrix(
      report[["numbers_at_age"]],
      nrow = data[["n_years"]]
    )))),
    catch_numbers_at_age = list(as.numeric(t(as_julia_backend_matrix(
      report[["catch_numbers_at_age"]],
      nrow = data[["n_years"]]
    )))),
    biomass = list(as_julia_backend_numeric(report[["biomass"]])),
    spawning_biomass = list(as_julia_backend_numeric(report[["spawning_biomass"]])),
    expected_recruitment = list(as_julia_backend_numeric(report[["expected_recruitment"]])),
    mortality_F = list(as.numeric(t(as.matrix(report[["mortality_F"]])))),
    mortality_M = list(as.numeric(t(as.matrix(report[["mortality_M"]])))),
    mortality_Z = list(as.numeric(t(as.matrix(report[["mortality_Z"]])))),
    proportion_mature_at_age = list(as.numeric(t(as.matrix(report[["proportion_mature_at_age"]])))),
    weight_at_age = list(as.numeric(t(as.matrix(report[["weights_at_age"]])))),
    mean_length_at_age = if (is.null(report[["mean_length_at_age"]])) {
      NULL
    } else {
      list(as.numeric(t(as.matrix(report[["mean_length_at_age"]]))))
    },
    sd_length_at_age = if (is.null(report[["sd_length_at_age"]])) {
      NULL
    } else {
      list(as.numeric(t(as.matrix(report[["sd_length_at_age"]]))))
    },
    age_to_length_conversion = if (is.null(report[["age_to_length_conversion"]])) {
      NULL
    } else {
      list(as.array(report[["age_to_length_conversion"]]))
    },
    sum_selectivity = list(as.numeric(t(as.matrix(report[["sum_selectivity"]])))),
    log_recruit_dev = list(as_julia_backend_numeric(parameters[["log_devs"]])),
    log_r = list(as_julia_backend_numeric(parameters[["log_r"]])),
    catch_expected = list(as_julia_backend_numeric(report[["catch_expected"]])),
    index_expected = list(as_julia_backend_numeric(report[["index_expected"]])),
    total_catch_numbers = list(as_julia_backend_numeric(report[["total_catch_numbers"]])),
    total_catch_weight = list(as_julia_backend_numeric(report[["total_catch_weight"]])),
    catch_expected_by_fleet = list(as.array(report[["catch_expected_by_fleet"]])),
    index_expected_by_fleet = list(as.array(report[["index_expected_by_fleet"]])),
    catch_numbers_at_age_by_fleet = list(as.array(report[["catch_numbers_at_age_by_fleet"]])),
    index_numbers_at_age_by_fleet = list(as.array(report[["index_numbers_at_age_by_fleet"]])),
    catch_numbers_by_fleet = list(as.array(report[["catch_numbers_by_fleet"]])),
    index_numbers_by_fleet = list(as.array(report[["index_numbers_by_fleet"]])),
    catch_weight_at_age_by_fleet = list(as.array(report[["catch_weight_at_age_by_fleet"]])),
    index_weight_at_age_by_fleet = list(as.array(report[["index_weight_at_age_by_fleet"]])),
    agecomp_expected = list(as.numeric(t(as.matrix(report[["agecomp_expected"]][, , 1])))),
    agecomp_expected_by_fleet = list(as.array(report[["agecomp_expected"]])),
    lengthcomp_expected_by_fleet = list(as.array(report[["lengthcomp_expected"]])),
    jnll = as.numeric(fit_result[["nll"]])
  )
}

flatten_julia_parameter_rows <- function(parameter_info, estimates, standard_errors) {
  if (is.null(parameter_info) || !tibble::is_tibble(parameter_info)) {
    return(tibble::tibble())
  }

  growth_component_map <- c(
    growth_log_mean_length_young = "mean_length_young",
    growth_log_mean_length_old = "mean_length_old",
    growth_log_coefficient = "growth_coefficient",
    growth_reference_age_young = "reference_age_for_length_young",
    growth_reference_age_old = "reference_age_for_length_old",
    growth_log_length_weight_a = "length_weight_a",
    growth_log_length_weight_b = "length_weight_b",
    growth_log_length_sd_at_young = "length_at_age_sd_at_reference_ages",
    growth_log_length_sd_at_old = "length_at_age_sd_at_reference_ages",
    growth_log_sd_mean_length_young = "log_sd_mean_length_young",
    growth_log_sd_mean_length_old = "log_sd_mean_length_old",
    growth_log_sd_growth_coefficient = "log_sd_growth_coefficient",
    growth_mean_length_young_mean_length_old_logit_corr =
      "mean_length_young_mean_length_old_logit_corr",
    growth_mean_length_young_growth_coefficient_logit_corr =
      "mean_length_young_growth_coefficient_logit_corr",
    growth_mean_length_old_growth_coefficient_logit_corr =
      "mean_length_old_growth_coefficient_logit_corr"
  )
  growth_components_on_natural_scale <- c(
    "growth_log_mean_length_young",
    "growth_log_mean_length_old",
    "growth_log_coefficient",
    "growth_log_length_weight_a",
    "growth_log_length_weight_b",
    "growth_log_length_sd_at_young",
    "growth_log_length_sd_at_old"
  )
  component_labels <- c(
    stats::setNames(
      setdiff(names(estimates), names(growth_component_map)),
      setdiff(names(estimates), names(growth_component_map))
    ),
    growth_component_map
  )
  component_labels <- component_labels[
    component_labels %in% unique(parameter_info[["label"]])
  ]
  mapped_labels <- unique(unname(component_labels))
  if (length(mapped_labels) == 0L) {
    return(tibble::tibble())
  }

  purrr::map_dfr(mapped_labels, function(label_name) {
    rows <- parameter_info |>
      dplyr::filter(.data$label == .env$label_name)
    if (identical(label_name, "length_at_age_sd_at_reference_ages")) {
      rows <- rows |>
        dplyr::arrange(.data$age)
    } else if (identical(label_name, "logit_sel_at_age")) {
      fleet_order <- unique(rows[["fleet"]])
      rows <- rows |>
        dplyr::arrange(
          match(.data$fleet, .env$fleet_order),
          .data$timing,
          .data$age
        )
    }
    component_names <- names(component_labels)[component_labels == label_name]
    if (identical(label_name, "length_at_age_sd_at_reference_ages") &&
      all(c(
        "growth_log_length_sd_at_young",
        "growth_log_length_sd_at_old"
      ) %in% component_names)) {
      component_names <- c(
        "growth_log_length_sd_at_young",
        "growth_log_length_sd_at_old"
      )
    }
    estimate_values <- unlist(lapply(component_names, function(component_name) {
      values <- if (component_name %in% names(estimates)) {
        as_julia_backend_numeric(estimates[[component_name]])
      } else {
        numeric()
      }
      if (component_name %in% growth_components_on_natural_scale) exp(values) else values
    }), use.names = FALSE)
    se_values <- unlist(lapply(component_names, function(component_name) {
      if (is.null(standard_errors[[component_name]])) {
        return(rep(NA_real_, length(estimates[[component_name]])))
      }
      values <- as_julia_backend_numeric(standard_errors[[component_name]])
      if (component_name %in% growth_components_on_natural_scale) {
        values <- exp(as_julia_backend_numeric(estimates[[component_name]])) * values
      }
      values
    }), use.names = FALSE)
    if (identical(label_name, "log_M") && length(component_names) == 1L &&
      is.matrix(estimates[[component_names[[1]]]])) {
      estimate_values <- as.numeric(t(estimates[[component_names[[1]]]]))
      se_values <- if (!is.null(standard_errors[[component_names[[1]]]])) {
        as.numeric(t(standard_errors[[component_names[[1]]]]))
      } else {
        rep(NA_real_, length(estimate_values))
      }
    }
    if (length(se_values) == 0L) {
      se_values <- rep(NA_real_, length(estimate_values))
    }

    if (nrow(rows) == 0 || length(estimate_values) != nrow(rows)) {
      return(tibble::tibble())
    }

    module_ids <- if ("module_id" %in% names(rows)) {
      dplyr::coalesce(as.integer(rows[["module_id"]]), 1L)
    } else {
      rep(1L, nrow(rows))
    }

    rows |>
      dplyr::mutate(
        module_id = module_ids,
        parameter_id = dplyr::row_number(),
        type = "parameter",
        type_id = dplyr::row_number(),
        input = .data$value,
        estimated = estimate_values,
        expected = NA_real_,
        observed = NA_real_,
        distribution = NA_character_,
        input_type = .data$estimation_type,
        lpdf = NA_real_,
        likelihood = NA_real_,
        log_sd = NA_real_,
        uncertainty = se_values,
        gradient = NA_real_
      )
  })
}

make_julia_matrix_estimate_rows <- function(label,
                                            matrix_values,
                                            module_name = "Population",
                                            module_id = 1L,
                                            estimation_type = "derived_quantity",
                                            fleet = NA_character_,
                                            distribution = NA_character_,
                                            observed_matrix = NULL,
                                            uncertainty = NA_real_) {
  matrix_values <- as.matrix(matrix_values)
  observed_values <- if (is.null(observed_matrix)) {
    rep(NA_real_, length(matrix_values))
  } else {
    as.numeric(t(as.matrix(observed_matrix)))
  }

  tibble::tibble(
    module_name = module_name,
    module_id = as.integer(module_id),
    module_type = module_name,
    label = label,
    type = "derived_quantity",
    type_id = seq_along(as.numeric(t(matrix_values))),
    parameter_id = NA_integer_,
    fleet = fleet,
    year_i = rep(seq_len(nrow(matrix_values)), each = ncol(matrix_values)),
    age_i = rep(seq_len(ncol(matrix_values)), times = nrow(matrix_values)),
    input = NA_real_,
    estimated = as.numeric(t(matrix_values)),
    expected = if (all(is.na(observed_values))) NA_real_ else as.numeric(t(matrix_values)),
    observed = observed_values,
    estimation_type = estimation_type,
    distribution = distribution,
    input_type = estimation_type,
    lpdf = NA_real_,
    likelihood = NA_real_,
    log_sd = NA_real_,
    uncertainty = uncertainty,
    gradient = NA_real_
  )
}

make_julia_vector_estimate_rows <- function(label,
                                            vector_values,
                                            module_name = "Population",
                                            module_id = 1L,
                                            estimation_type = "derived_quantity",
                                            fleet = NA_character_,
                                            distribution = NA_character_,
                                            observed_values = NULL,
                                            uncertainty = NA_real_) {
  vector_values <- as.numeric(vector_values)
  observed_values <- if (is.null(observed_values)) {
    rep(NA_real_, length(vector_values))
  } else {
    as.numeric(observed_values)
  }

  tibble::tibble(
    module_name = module_name,
    module_id = as.integer(module_id),
    module_type = module_name,
    label = label,
    type = "derived_quantity",
    type_id = seq_along(vector_values),
    parameter_id = NA_integer_,
    fleet = fleet,
    year_i = seq_along(vector_values),
    input = NA_real_,
    estimated = vector_values,
    expected = if (all(is.na(observed_values))) NA_real_ else vector_values,
    observed = observed_values,
    estimation_type = estimation_type,
    distribution = distribution,
    input_type = estimation_type,
    lpdf = NA_real_,
    likelihood = NA_real_,
    log_sd = NA_real_,
    uncertainty = uncertainty,
    gradient = NA_real_
  )
}

build_julia_backend_estimates <- function(input, fit_result, report) {
  julia_input <- attr(input, "julia_input")
  parameter_info <- attr(input, "parameter_info")
  estimates <- fit_result[["estimates"]]
  standard_errors <- fit_result[["standard_errors"]]
  data <- julia_input[["data"]]
  raw_data <- data[["data"]]

  parameter_rows <- flatten_julia_parameter_rows(
    parameter_info = parameter_info,
    estimates = estimates,
    standard_errors = standard_errors
  )

  output <- list(
    parameter_rows,
    make_julia_matrix_estimate_rows(
      label = "numbers_at_age",
      matrix_values = matrix(
        report[["numbers_at_age"]][[1]],
        nrow = data[["n_years"]],
        byrow = TRUE
      )
    ),
    make_julia_vector_estimate_rows(
      label = "biomass",
      vector_values = report[["biomass"]][[1]]
    ),
    make_julia_vector_estimate_rows(
      label = "spawning_biomass",
      vector_values = report[["spawning_biomass"]][[1]]
    ),
    make_julia_vector_estimate_rows(
      label = "expected_recruitment",
      vector_values = report[["expected_recruitment"]][[1]]
    ),
    make_julia_matrix_estimate_rows(
      label = "mortality_F",
      matrix_values = matrix(report[["mortality_F"]][[1]], nrow = data[["n_years"]], byrow = TRUE)
    ),
    make_julia_matrix_estimate_rows(
      label = "mortality_M",
      matrix_values = matrix(report[["mortality_M"]][[1]], nrow = data[["n_years"]], byrow = TRUE)
    ),
    make_julia_matrix_estimate_rows(
      label = "mortality_Z",
      matrix_values = matrix(report[["mortality_Z"]][[1]], nrow = data[["n_years"]], byrow = TRUE)
    ),
    make_julia_matrix_estimate_rows(
      label = "proportion_mature_at_age",
      matrix_values = matrix(report[["proportion_mature_at_age"]][[1]], nrow = data[["n_years"]], byrow = TRUE)
    ),
    make_julia_matrix_estimate_rows(
      label = "weight_at_age",
      matrix_values = matrix(report[["weight_at_age"]][[1]], nrow = data[["n_years"]], byrow = TRUE)
    ),
    make_julia_matrix_estimate_rows(
      label = "sum_selectivity",
      matrix_values = matrix(report[["sum_selectivity"]][[1]], nrow = data[["n_years"]], byrow = TRUE)
    ),
    make_julia_vector_estimate_rows(
      label = "total_catch_numbers",
      vector_values = report[["total_catch_numbers"]][[1]]
    ),
    make_julia_vector_estimate_rows(
      label = "total_catch_weight",
      vector_values = report[["total_catch_weight"]][[1]]
    )
  )
  for (growth_label in c("mean_length_at_age", "sd_length_at_age")) {
    if (!is.null(report[[growth_label]])) {
      output[[length(output) + 1]] <- make_julia_matrix_estimate_rows(
        label = growth_label,
        matrix_values = matrix(report[[growth_label]][[1]], nrow = data[["n_years"]], byrow = TRUE)
      )
    }
  }

  fleet_names <- data[["fleets"]]
  for (fleet_index in seq_along(fleet_names)) {
    fleet_name <- fleet_names[[fleet_index]]
    if (!is.null(data[["observed_catch"]]) &&
      any(raw_data$type == "catch" & raw_data$fleet == fleet_name)) {
      output[[length(output) + 1]] <- make_julia_matrix_estimate_rows(
        label = "catch_numbers_at_age",
        matrix_values = report[["catch_numbers_at_age_by_fleet"]][[1]][, , fleet_index],
        module_name = "Fleet",
        module_id = as.integer(fleet_index),
        fleet = fleet_name
      )
      output[[length(output) + 1]] <- make_julia_vector_estimate_rows(
        label = "catch_expected",
        vector_values = report[["catch_expected_by_fleet"]][[1]][, fleet_index],
        module_name = "Fleet",
        module_id = as.integer(fleet_index),
        fleet = fleet_name,
        distribution = "dlnorm",
        observed_values = data[["observed_catch"]][, fleet_index]
      )
    }

    if (!is.null(data[["observed_index"]]) &&
      any(raw_data$type == "index" & raw_data$fleet == fleet_name)) {
      output[[length(output) + 1]] <- make_julia_vector_estimate_rows(
        label = "index_expected",
        vector_values = report[["index_expected_by_fleet"]][[1]][, fleet_index],
        module_name = "Fleet",
        module_id = as.integer(fleet_index),
        fleet = fleet_name,
        distribution = "dlnorm",
        observed_values = data[["observed_index"]][, fleet_index]
      )
    }

    if (!is.null(data[["observed_age_comp"]]) &&
      any(raw_data$type == "age_comp" & raw_data$fleet == fleet_name)) {
      output[[length(output) + 1]] <- make_julia_matrix_estimate_rows(
        label = "agecomp_expected",
        matrix_values = report[["agecomp_expected_by_fleet"]][[1]][, , fleet_index],
        module_name = "Fleet",
        module_id = as.integer(fleet_index),
        fleet = fleet_name,
        distribution = "dmultinom",
        observed_matrix = data[["observed_age_comp"]][, , fleet_index]
      )
    }

    if (!is.null(data[["observed_length_comp"]]) &&
      any(raw_data$type == "length_comp" & raw_data$fleet == fleet_name)) {
      output[[length(output) + 1]] <- make_julia_matrix_estimate_rows(
        label = "lengthcomp_expected",
        matrix_values = report[["lengthcomp_expected_by_fleet"]][[1]][, , fleet_index],
        module_name = "Fleet",
        module_id = as.integer(fleet_index),
        fleet = fleet_name,
        distribution = "dmultinom",
        observed_matrix = data[["observed_length_comp"]][, , fleet_index]
      )
    }
  }

  dplyr::bind_rows(output)
}

build_julia_backend_stub_obj <- function(parameters, report, fit_result) {
  parameter_vector <- purrr::flatten_dbl(parameters)
  gradient_vector <- if (!is.null(fit_result[["fixed_gradient"]])) {
    as.numeric(fit_result[["fixed_gradient"]])
  } else if (!is.null(fit_result[["gradient"]])) {
    as.numeric(fit_result[["gradient"]])
  } else {
    rep(NA_real_, length(parameter_vector))
  }
  hessian_matrix <- if (!is.null(fit_result[["hessian"]])) {
    as.matrix(fit_result[["hessian"]])
  } else {
    diag(length(parameter_vector))
  }

  report_function <- function(...) report
  par_list_function <- function(...) list(re = numeric())

  list(
    par = stats::setNames(parameter_vector, names(parameter_vector)),
    fn = function(...) as.numeric(fit_result[["nll"]]),
    gr = function(...) gradient_vector,
    he = function(...) hessian_matrix,
    hessian = function(...) hessian_matrix,
    method = "JuliaCall",
    retape = function(...) NULL,
    env = list(
      last.par.best = parameter_vector,
      parameters = list(p = parameter_vector, re = numeric()),
      parList = par_list_function,
      random = character()
    ),
    report = report_function,
    simulate = function(...) NULL
  )
}

# Constructors ----

#' Class constructors for class `FIMSFit` and associated child classes
#'
#' Create an object with the class of `FIMSFit` after running a FIMS model. This
#' is typically done within [fit_fims()] but it can be create manually by the
#' user if they have used their own bespoke code to fit a FIMS model.
#'
#' @inheritParams fit_fims
#' @param obj An object returned from [TMB::MakeADFun()].
#' @param opt An object returned from an optimizer, typically from
#'   [stats::nlminb()], used to fit a TMB model.
#' @param sdreport An object of the `sdreport` class as returned from
#'   [TMB::sdreport()].
#' @param run_time A vector of at least length one, where all entries are of the
#'   `timediff` class and at least one is named "time_total". This information
#'   is available in [fit_fims()] and added to this argument internally but if
#'   you are a power user you can calculate the time it took to run your model
#'   by subtracting two [Sys.time()] objects.
#' @param version The version of FIMS that was used to optimize the model. If
#'   [fit_fims()] was not used to optimize the model, then the default is to
#'   use the current version of the package that is loaded.
#'
#' @return
#' An object with an S4 class of `FIMSFit` is returned. The object will have the
#' following slots:
#'   \describe{
#'     \item{\code{input}:}{
#'       A list containing the model setup in the same form it was passed.
#'     }
#'     \item{\code{obj}:}{
#'       A list returned from [TMB::MakeADFun()] in the same form it was passed.
#'     }
#'     \item{\code{opt}:}{
#'       A list containing the optimized model in the same form it was passed.
#'     }
#'     \item{\code{max_gradient}:}{
#'       The maximum gradient found when optimizing the model. The default is
#'       `NA`, which means that the model was not optimized.
#'     }
#'     \item{\code{report}:}{
#'       A list containing the model report from `obj[["report"]]()`.
#'     }
#'     \item{\code{sdreport}:}{
#'       An object with the `sdreport` class containing the output from
#'       `TMB::sdreport(obj)`.
#'     }
#'     \item{\code{run_time}:}{
#'       The length of time it took to run the model if it was optimized.
#'     }
#'     \item{\code{version}:}{
#'       The package version of FIMS used to fit the model or at least the
#'       version used to create this output, which will not always be the same
#'       if you are running this function yourself.
#'     }
#'     \item{\code{model_output}:}{
#'       The FIMS model output as a JSON string.
#'     }
#'   }
#' @keywords fit_fims
#' @export
FIMSFit <- function(
  input,
  obj,
  opt = list(),
  sdreport = list(),
  run_time = c("time_total" = as.difftime(0, units = "secs")),
  version = utils::packageVersion("FIMS")
) {
  if (is_julia_backend_input(input)) {
    optimized_parameters <- if (length(opt) > 0 && !is.null(opt[["par"]])) {
      opt[["par"]]
    } else {
      purrr::flatten_dbl(attr(input, "julia_input")[["parameters"]])
    }
    fixed_effect_count <- as.integer(
      input[["julia_fixed_parameter_count"]] %||% length(optimized_parameters)
    )
    gradient_vector <- if (!is.null(obj[["gr"]])) {
      as.numeric(obj[["gr"]](optimized_parameters))
    } else {
      rep(NA_real_, fixed_effect_count)
    }
    max_gradient <- if (length(gradient_vector) > 0 && any(is.finite(gradient_vector))) {
      max(abs(gradient_vector), na.rm = TRUE)
    } else {
      NA_real_
    }
    if (is.null(input[["julia_estimates"]])) {
      input[["julia_estimates"]] <- tibble::tibble()
    }

    return(methods::new(
      "FIMSFit",
      input = input,
      obj = obj,
      opt = opt,
      max_gradient = max_gradient,
      gradient = gradient_vector,
      report = obj[["report"]](),
      sdreport = sdreport,
      number_of_parameters = c(
        fixed_effects = fixed_effect_count,
          random_effects = as.integer(input[["julia_random_parameter_count"]] %||% 0L)
      ),
      run_time = run_time,
      version = version,
      model_output = jsonlite::toJSON(list(backend = "julia"), auto_unbox = TRUE)
    ))
  }

  # Determine the number of parameters
  n_total <- length(obj[["env"]][["last.par.best"]])
  n_fixed_effects <- length(obj[["par"]])
  n_random_effects <- length(obj[["env"]]$parList()[["re"]])
  number_of_parameters <- c(
    fixed_effects = n_fixed_effects,
    random_effects = n_random_effects
  )
  rm(n_total, n_fixed_effects, n_random_effects)

  # Compute the full per-parameter gradient vector once at construction time.
  # max_gradient is derived from it so obj$gr() is only ever called here.
  # Storing gradient_vec in the FIMSFit slot means get_estimates() and the
  # broom methods (tidy, augment, glance) can read from x@gradient instead of
  # calling obj$gr() again - which segfaults after clear() frees C++ memory.
  # as.numeric() is required because TMB's obj$gr() returns a matrix (1xn)
  # in some call patterns, which would fail the "numeric" slot type check.
  gradient_vector <- if (length(opt) > 0) {
    as.numeric(obj[["gr"]](opt[["par"]]))
  } else {
    rep(NA_real_, length(obj[["par"]]))
  }
  max_gradient <- if (length(opt) > 0) max(abs(gradient_vector)) else NA_real_

  # Rename parameters instead of "p"
  parameter_names <- names(get_parameter_names(obj[["par"]]))
  names(obj[["par"]]) <- parameter_names
  random_effects_names <- names(get_random_names(obj[["env"]]$parList()[["re"]]))

  # Get the report
  report <- if (length(opt) == 0) {
    obj[["report"]](obj[["env"]][["last.par.best"]])
  } else {
    obj[["report"]]()
  }

  if (length(sdreport) > 0) {
    # rename the sdreport
    names(sdreport[["par.fixed"]]) <- parameter_names
    dimnames(sdreport[["cov.fixed"]]) <- list(parameter_names, parameter_names)
    # Skipped when there are no random effects or some are mapped off
    if (length(sdreport[["par.random"]]) > 0 &&
      length(random_effects_names) == length(sdreport[["par.random"]])) {
      names(sdreport[["par.random"]]) <- random_effects_names
    }
  }

  model_output <- input[["model"]]$get_output()


  fit <- methods::new(
    "FIMSFit",
    input = input,
    obj = obj,
    opt = opt,
    max_gradient = max_gradient,
    gradient = gradient_vector,
    report = report,
    sdreport = sdreport,
    number_of_parameters = number_of_parameters,
    run_time = run_time,
    version = version,
    model_output = model_output
  )
  fit
}

#' Fit a FIMS model (BETA)
#'
#' @param input Input list as returned by [initialize_fims()].
#' @param get_sd A boolean specifying if the [TMB::sdreport()] should be
#'   calculated?
#' @param save_sd A logical, with the default `TRUE`, indicating whether the
#'   sdreport is returned in the output. If `FALSE`, the slot for the report
#'   will be empty.
#' @param number_of_loops A positive integer specifying the number of
#'   iterations of the optimizer that will be performed to improve the
#'   gradient. The default is three, leading to four total optimization steps.
#' @param optimize Optimize (TRUE, default) or (FALSE) build and return
#'   a list containing the obj and report slot.
#' @param number_of_newton_steps The number of Newton steps using the inverse
#'   Hessian to do after optimization. Not yet implemented.
#' @param control A list of optimizer settings passed to [stats::nlminb()]. The
#'   the default is a list of length three with `eval.max = 1000`,
#'   `iter.max = 10000`, and `trace = 0`.
#' @param filename Character string giving a file name to save the fitted
#'   object as an RDS object. Defaults to 'fit.RDS', and a value of NULL
#'   indicates not to save it. If specified, it must end in .RDS. The file is
#'   written to folder given by `input[["path"]]`. Not yet implemented.
#' @param getReportCovariance A logical passed to [TMB::sdreport()], with the
#'   default `FALSE`. Standard errors of all parameters and derived quantities
#'   are calculated either way. If `TRUE`, the full covariance matrix of the
#'   derived quantities is also calculated and stored as `cov` in the
#'   `sdreport`; it grows with the square of the number of derived quantities
#'   and can use several GB of memory. If `FALSE`, `cov` is `NA`.
#' @return
#' An object of class `FIMSFit` is returned, where the structure is the same
#' regardless if `optimize = TRUE` or not. Uncertainty information is only
#' included in the `estimates` slot if `get_sd = TRUE`.
#' @seealso
#' * [FIMSFit()]
#' @details This function is a beta version still and subject to change
#'   without warning.
#' @keywords fit_fims
#' @export
fit_fims <- function(input,
                     get_sd = TRUE,
                     save_sd = TRUE,
                     number_of_loops = 3,
                     optimize = TRUE,
                     number_of_newton_steps = 0,
                     control = list(
                       eval.max = 10000,
                       iter.max = 10000,
                       trace = 0
                     ),
                     filename = NULL,
                     getReportCovariance = FALSE) {
                       if (is_julia_backend_input(input)) {
                         if (!initialize_julia_backend()) {
                           cli::cli_abort(c(
                             "Julia backend initialization failed before fitting.",
                             "i" = "Ensure Julia is installed and that {.pkg JuliaCall} can load {.pkg FIMSBackend}."
                           ))
                         }

                         julia_input <- attr(input, "julia_input")
                         julia_model_config <- attr(input, "julia_model_config")
                         assign_julia_backend_input(julia_input)

                         t0 <- Sys.time()
                         fit_result <- if (optimize) {
                           fit_julia_backend_model(
                             julia_input = julia_input,
                             model_config = julia_model_config
                           )
                         } else {
                           evaluated <- evaluate_julia_backend_model(
                             julia_input = julia_input,
                             model_config = julia_model_config
                           )
                           parameter_template <- julia_input[["parameters"]]
                           list(
                             estimates = parameter_template,
                             standard_errors = purrr::map(parameter_template, \(x) rep(NA_real_, length(as_julia_backend_numeric(x)))),
                             gradient = rep(NA_real_, length(purrr::flatten_dbl(parameter_template))),
                             fixed_gradient = rep(NA_real_, sum(julia_model_config[["fixed_parameter_mask"]])),
                             fixed_effect_count = sum(julia_model_config[["fixed_parameter_mask"]]),
                             random_effect_count = sum(julia_model_config[["random_parameter_mask"]]),
                             hessian = diag(length(purrr::flatten_dbl(parameter_template))),
                             nll = evaluated[["nll"]],
                             report = evaluated[["report"]],
                             convergence = TRUE,
                             convergence_code = "not_optimized",
                             iterations = 0L
                           )
                         }
                         time_optimization <- Sys.time() - t0

                         report <- build_julia_backend_report(
                           julia_input = julia_input,
                           fit_result = fit_result
                         )
                         input[["julia_estimates"]] <- build_julia_backend_estimates(
                           input = input,
                           fit_result = fit_result,
                           report = report
                         )

                         optimized_parameters <- if (!is.null(fit_result[["fixed_parameters"]])) {
                           as.numeric(fit_result[["fixed_parameters"]])
                         } else {
                           purrr::flatten_dbl(fit_result[["estimates"]])
                         }
                         input[["julia_fixed_parameter_count"]] <-
                           fit_result[["fixed_effect_count"]] %||% length(optimized_parameters)
                         input[["julia_random_parameter_count"]] <-
                           fit_result[["random_effect_count"]] %||% 0L

                         obj <- build_julia_backend_stub_obj(
                           parameters = if (!is.null(fit_result[["estimates"]])) fit_result[["estimates"]] else julia_input[["parameters"]],
                           report = report,
                           fit_result = fit_result
                         )

                         run_time <- c(
                           time_optimization = time_optimization,
                           time_sdreport = as.difftime(0, units = "secs"),
                           time_total = Sys.time() - t0
                         )
                         fit <- FIMSFit(
                           input = input,
                           obj = obj,
                           opt = if (optimize) {
                             list(
                               par = optimized_parameters,
                               fixed_effect_count = input[["julia_fixed_parameter_count"]],
                               random_effect_count = input[["julia_random_parameter_count"]],
                               objective = as.numeric(fit_result[["nll"]]),
                               convergence = if (isTRUE(fit_result[["convergence"]])) 0L else 1L,
                               message = fit_result[["convergence_code"]]
                             )
                           } else {
                             list()
                           },
                           sdreport = list(),
                           run_time = run_time
                         )
                         if (optimize) {
                           print(fit)
                         }
                         return(fit)
                       }

  require_fims_cpp_backend(
    context = cli::format_inline("Fitting the default TMB backend via {.fun fit_fims}"),
    guidance = c(
      "i" = "Fit Julia-backed models with input created using {.code backend = \"julia\"}."
    )
  )

  # See issue 455 of sdmTMB to see what should be used.
  # https://github.com/pbs-assess/sdmTMB/issues/455
  # NOTE: When we add implementation for newton step we need to
  # review the above github issue to make sure we maintain continuity
  # between outputs as last.par may not equal last.par.best due to
  # the smallest newton gradient solution not matching the smallest
  # likelihood value. This can cause sanity issues in output reporting.
  if (number_of_newton_steps > 0) {
    cli::cli_abort(c(
      "x" = "Newton steps are not implemented yet.",
      "i" = "Use {.code number_of_newton_steps = 0}. To improve the gradient,
      increase {.arg number_of_loops} instead."
    ))
  }
  if (number_of_loops < 0) {
    cli::cli_abort("number_of_loops ({.par {number_of_loops}}) must be >= 0.")
  }
  # If the estimation_type of all parameters is constant, FIMS will abort if
  # optimize is set to TRUE
  if (optimize == TRUE & all(purrr::map_vec(input[["parameters"]], length) == 0)) {
    cli::cli_abort("FIMS must have at least one parameter to optimize.")
  }

  obj <- TMB::MakeADFun(
    data = list(),
    parameters = input$parameters,
    map = input$map,
    random = "re",
    DLL = "FIMS",
    silent = TRUE
  )
  if (!optimize) {
    initial_fit <- FIMSFit(
      input = input,
      obj = obj,
      run_time = c("time_total" = as.difftime(0, units = "secs"))
    )
    return(initial_fit)
  }
  if (!is_fims_verbose()) {
    control$trace <- 0
  }
  ## optimize and compare
  cli::cli_inform(c("v" = "Starting optimization ..."))
  t0 <- Sys.time()
  opt <- try_nlminb(
    object = obj,
    control_list = control,
    starting_values = obj[["par"]]
  )

  if (is.null(opt)) {
    failed_nlminb_object <- return_failed_nlminb(obj)
    failed_fit <- fit <- FIMSFit(
      input = input,
      obj = obj,
      opt = failed_nlminb_object[["opt"]],
      sdreport = list(),
      run_time = failed_nlminb_object[["run_time"]]
    )
    return(failed_fit)
  }

  gradient <- as.numeric(obj[["gr"]](opt[["par"]]))
  maxgrad0 <- maxgrad <- max(abs(gradient))
  if (number_of_loops > 0) {
    cli::cli_inform(c(
      "i" = "Restarting optimizer {number_of_loops} time{?s} to improve
            gradient."
    ))
    # control$trace is reset to zero regardless of verbosity because the
    # differences in values printed out using control$trace will be
    # negligible between these different runs and is not worth printing
    control$trace <- 0
    for (ii in 1:number_of_loops) {
      opt <- try_nlminb(
        object = obj,
        control_list = control,
        starting_values = opt[["par"]]
      )
      # Handle hard failures where try_nlminb did not return a list
      if (is.null(opt)) {
        cli::cli_inform(message = c(
          "!" = "{.fn nlminb} failed during loop {ii}.",
          "i" = "The model successfully converged before this loop.",
          "i" = "The failed results are being returned."
        ))
        failed_nlminb_object <- return_failed_nlminb(obj)
        failed_fit <- fit <- FIMSFit(
          input = input,
          obj = obj,
          opt = failed_nlminb_object[["opt"]],
          sdreport = list(),
          run_time = failed_nlminb_object[["run_time"]]
        )
        return(failed_fit)
      }
      gradient <- as.numeric(obj[["gr"]](opt[["par"]]))
      maxgrad <- max(abs(gradient))
    }
    div_digit <- cli::cli_div(theme = list(.val = list(digits = 5)))
    cli::cli_inform(c(
      "i" = "Maximum gradient went from {.val {maxgrad0}} to
            {.val {maxgrad}} after {number_of_loops} steps."
    ))
    cli::cli_end(div_digit)
  }
  time_optimization <- Sys.time() - t0
  cli::cli_inform(c("v" = "Finished optimization"))

  # Named here while the C++ Information object is still populated; TMB names
  # every fixed effect "p" and every random effect "re"
  parameter_names <- names(get_parameter_names(obj[["par"]]))
  random_effects_names <- if (length(obj[["env"]][["random"]]) > 0) {
    names(get_random_names(obj[["env"]]$parList()[["re"]]))
  }
  check_mle_convergence(
    input,
    obj,
    opt,
    maxgrad,
    gradient = gradient,
    parameter_names = parameter_names
  )

  FIMS::set_fixed(opt[["par"]])

  time_sdreport <- NA
  if (get_sd) {
    t2 <- Sys.time()
    sdreport <- TMB::sdreport(
      obj,
      getReportCovariance = getReportCovariance
    )
    cli::cli_inform(c("v" = "Finished sdreport"))
    time_sdreport <- Sys.time() - t2
    check_sdreport_convergence(
      input,
      obj,
      opt,
      sdreport,
      parameter_names = parameter_names,
      random_effects_names = random_effects_names
    )
  } else {
    sdreport <- list()
    time_sdreport <- as.difftime(0, units = "secs")
  }

  run_time <- c(
    time_optimization = time_optimization,
    time_sdreport = time_sdreport,
    time_total = Sys.time() - t0
  )
  fit <- FIMSFit(
    input = input,
    obj = obj,
    opt = opt,
    sdreport = sdreport,
    run_time = run_time
  )
  print(fit)
  if (!is.null(filename)) {
    cli::cli_warn(c(
      "i" = "Saving output to file is not yet implemented."
    ))
    # saveRDS(fit, file=file.path(input[["path"]], filename))
  }
  return(fit)
}

# we create an as.list method for this new FIMSFit
methods::setMethod("as.list", signature(x = "FIMSFit"), function(x) {
  mapply(
    function(y) {
      # apply as.list if the slot is again an user-defined object
      # therefore, as.list gets applied recursively
      if (inherits(slot(x, y), "FIMSFit")) {
        as.list(slot(x, y))
      } else {
        # otherwise just return the slot
        slot(x, y)
      }
    },
    slotNames(class(x)),
    SIMPLIFY = FALSE
  )
})

# Helper function used within fit_fims
try_nlminb <- function(object, control_list, starting_values) {
  optimized <- tryCatch(
    {
      with(
        object,
        nlminb(
          start = starting_values,
          objective = fn,
          gradient = gr,
          control = control_list
        )
      )
    },
    error = function(e) {
      cli::cli_rule(left = "{.fun stats::nlminb} failure details")
      NULL
    }
  )

  # Handle soft failures where nlminb returns an object but the objective
  # value is not finite (e.g., Inf or NaN). In such cases, convergence and
  # message fields may be unreliable, so treat this as a failure and trigger
  # the fallback logic by setting opt to NULL.
  if (!is.null(optimized) && !is.finite(optimized[["objective"]])) {
    cli::cli_warn(c(
      "x" = "Optimization with {.fun stats::nlminb} returned a non-finite
      objective value."
    ))
    return(NULL)
  }

  return(optimized)
}

return_failed_nlminb <- function(object) {
  failed_nlminb_message <- c(
    "x" = "{.fun fit_fims} did not lead to a converged model.",
    "i" = "The resulting coefficients, probability values, or predictions are
    not accurate or stable and should not be used for management.",
    "i" = "A {.cls FIMSFit} object containing partial results is returned.",
    "i" = "Type the name of the variable you assigned it (e.g.,
           {.code fit <- ...}) to inspect the model inputs and configuration.
           Additionally, try running {.code FIMS::fit_fims(optimize = FALSE)}
           and inspecting the output through {.code get_report(fit)} or by
           viewing the tabular output from {.code View(get_estimates(fit))}."
  )
  cli::cli_warn(message = failed_nlminb_message)
  # Construct a fallback optimizer result with consistent structure, i.e.,
  # convergence = 1L indicates non-convergence
  return(list(
    run_time = c(
      time_optimization = as.difftime(0, units = "secs"),
      time_sdreport = as.difftime(0, units = "secs"),
      time_total = as.difftime(0, units = "secs")
    ),
    opt = list(
      par = object[["par"]],
      objective = NA_real_,
      convergence = 1L,
      message = "Optimization failed"
    )
  ))
}
