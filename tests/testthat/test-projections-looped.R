test_that("high-level Julia projections preserve missing data and fishing scenarios", {
  skip_if(Sys.getenv("FIMS_RUN_JULIA_INTEGRATION") != "true",
    "Set FIMS_RUN_JULIA_INTEGRATION=true to exercise real Julia projections.")
  raw <- data_big |>
    dplyr::filter(
      !.data$type %in% c("length_comp", "age_to_length_conversion"),
      dplyr::if_else(.data$type == "weight_at_age", .data$timing <= 6, .data$timing <= 3)
    ) |>
    dplyr::add_row(type = "catch", fleet = "fleet1", timing = 5,
      observed = -999, unit = "mt",
      uncertainty = "~ dlnorm(meanlog = log_catch_expected, sdlog = 0.1)")
  data <- FIMSFrame(raw)
  parameters <- setup_default_parameters(data) |>
    dplyr::mutate(estimation_type = "constant")
  reports <- lapply(c(0.1, 0.5), function(fishing_mortality) {
    scenario <- parameters |>
      dplyr::mutate(value = dplyr::if_else(
        .data$label == "log_Fmort" & .data$fleet == "fleet1" & .data$timing > 3,
        log(fishing_mortality), .data$value
      ))
    input <- initialize_fims(scenario, data)
    observed <- attr(input, "julia_input")[["data"]][["observed_catch"]]
    expect_true(all(observed[4:5, ] == -999))
    fit <- fit_fims(input, optimize = FALSE, get_sd = FALSE)
    report <- get_report(fit)
    expect_length(report[["biomass"]][[1]], 6L)
    expect_true(all(is.finite(report[["spawning_biomass"]][[1]])))
    simulated <- get_obj(fit)[["simulate"]]()
    expect_equal(simulated[["observed_catch"]][4:5, ], observed[4:5, ])
    clear()
    report
  })
  expect_gt(tail(reports[[1]][["spawning_biomass"]][[1]], 1),
    tail(reports[[2]][["spawning_biomass"]][[1]], 1))
  expect_lt(reports[[1]][["total_catch_numbers"]][[1]][[4]],
    reports[[2]][["total_catch_numbers"]][[1]][[4]])
})
