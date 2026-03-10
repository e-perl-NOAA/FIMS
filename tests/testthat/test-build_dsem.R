test_that("`build_DSEM()` returns expected settings structure", {
  settings <- build_DSEM(
    sem = "recdevs1 <-> recdevs1, 0, sigmaR1, 1",
    family = "normal",
    all_vars = TRUE,
    estimate_projection = TRUE
  )

  expect_named(
    settings,
    c("sem", "family", "all_vars", "estimate_projection")
  )
  expect_equal(settings$all_vars, TRUE)
  expect_equal(settings$estimate_projection, TRUE)
})

test_that("`build_dsem_objects()` creates recdev columns and pads years", {
  frame <- FIMSFrame(data1)
  settings <- build_DSEM()
  env_data <- tibble::tibble(
    Year = c(get_start_year(frame), get_end_year(frame)),
    Temp = c(-1, 1)
  )

  result <- build_dsem_objects(
    dsem_settings = settings,
    data = frame,
    env_data = env_data,
    n_recdevs = 1
  )

  expect_named(result, c("dsem_settings", "dsem_data"))
  expect_true("recdevs1" %in% names(result$dsem_data))
  expect_equal(nrow(result$dsem_data), get_n_years(frame))
  expect_equal(length(result$dsem_settings$family), ncol(result$dsem_data))
  expect_equal(
    result$dsem_settings$sem,
    "recdevs1 <-> recdevs1, 0, sigmaR1, 1"
  )
})

test_that("`build_dsem_objects()` validates family length", {
  frame <- FIMSFrame(data1)
  settings <- build_DSEM(family = c("normal", "normal"))
  env_data <- tibble::tibble(
    Year = c(get_start_year(frame), get_end_year(frame)),
    Temp = c(1, 2)
  )
  expect_error(
    build_dsem_objects(
      dsem_settings = settings,
      data = frame,
      env_data = env_data,
      n_recdevs = 1
    ),
    "Length of .*family"
  )
})

test_that("`build_dsem_objects()` errors when env_data rows exceed model years", {
  frame <- FIMSFrame(data1)
  env_data <- tibble::tibble(Temp = seq_len(get_n_years(frame) + 1))
  expect_error(
    build_dsem_objects(
      dsem_settings = build_DSEM(),
      data = frame,
      env_data = env_data,
      n_recdevs = 1
    ),
    "more rows than model years"
  )
})
