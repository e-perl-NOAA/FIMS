test_that("initialize_fims defaults to self-contained Julia input without startup", {
  data <- FIMSFrame(data_big)
  parameters <- setup_default_parameters(data)
  testthat::local_mocked_bindings(
    initialize_julia_backend = function(...) stop("initialization must be lazy"),
    .package = "FIMS"
  )
  input <- initialize_fims(parameters, data)
  expect_identical(attr(input, "backend"), "julia")
  expect_named(input, c("parameters", "model"))
  expect_null(input[["model"]])
  expect_equal(input[["parameters"]], attr(input, "julia_input")[["parameters"]])
  expect_error(initialize_fims(parameters, data, backend = "tmb"), "retired")
  expect_error(initialize_fims(as.data.frame(parameters), data), "tibble")
  expect_error(initialize_fims(parameters, data_big), "FIMSFrame")
})
