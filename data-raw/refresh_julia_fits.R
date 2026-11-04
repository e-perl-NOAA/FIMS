# Refresh the shipped examples without resimulating their input data.
# Run in a fresh R session from the package root after installing Julia.
pkgload::load_all(quiet = TRUE, helpers = FALSE)

data <- FIMS::FIMSFrame(FIMS::data_big)
input <- FIMS::initialize_fims(FIMS::parameters_big, data)
message("Evaluating the complete example at its original initial values.")
fit_big_unoptimized <- FIMS::fit_fims(input, optimize = FALSE)
estimates_big_unoptimized <- FIMS::get_estimates(fit_big_unoptimized)
# Refit the entire model from the previously published estimates, not from a
# restricted parameter subset or a replacement set of expected results.
keys <- c("module_name", "fleet", "label", "timing", "age", "length")
starting_estimates <- FIMS::estimates_big_optimized |>
  dplyr::filter(.data$estimation_type %in% c("fixed_effects", "random_effects")) |>
  dplyr::transmute(
    module_name = .data$module_name, fleet = .data$fleet, label = .data$label,
    timing = .data$year_i, age = .data$age, length = .data$length,
    value = .data$estimated
  )
stopifnot(
  all(is.finite(starting_estimates[["value"]])),
  nrow(starting_estimates) ==
    sum(FIMS::parameters_big[["estimation_type"]] %in% c("fixed_effects", "random_effects"))
)
starting_parameters <- FIMS::parameters_big |>
  dplyr::rows_update(starting_estimates, by = keys)
fit_big_optimized <- FIMS::initialize_fims(starting_parameters, data) |>
  FIMS::fit_fims(number_of_loops = 0)
stopifnot(
  FIMS::get_opt(fit_big_optimized)[["convergence"]] == 0L,
  FIMS::get_max_gradient(fit_big_optimized) < 1e-3,
  isTRUE(FIMS::get_sdreport(fit_big_optimized)[["pdHess"]])
)
estimates_big_optimized <- FIMS::get_estimates(fit_big_optimized)
save(fit_big_optimized, file = "data/fit_big_optimized.rda", compress = "xz")
save(estimates_big_optimized, file = "data/estimates_big_optimized.rda", compress = "xz")

internal <- new.env(parent = emptyenv())
load("R/sysdata.rda", envir = internal)
internal[["fit_big_unoptimized"]] <- fit_big_unoptimized
internal[["estimates_big_unoptimized"]] <- estimates_big_unoptimized
save(list = ls(internal), envir = internal, file = "R/sysdata.rda", compress = "xz")
