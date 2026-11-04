test_that("clear does not start Julia or invalidate serialized model input", {
  withr::local_options(list(FIMS.disable_julia = TRUE))
  data <- FIMSFrame(data_big)
  input <- initialize_fims(setup_default_parameters(data), data)
  before <- attr(input, "julia_input")
  expect_no_warning(clear())
  expect_identical(attr(input, "julia_input"), before)
})
