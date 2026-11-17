# Refresh the shipped examples without resimulating their input data.
# Run in a fresh R session from the package root after installing Julia.
# Set FIMS_JULIA_PROFILE to select the sampling-profile output file.
# Its .progress companion records phase boundaries during the fit. Sampling
# output is formatted on exit, never concurrently with JuliaCall computation.
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
profile_path <- Sys.getenv("FIMS_JULIA_PROFILE", unset = "julia-fit-profile.txt")
starting_input <- FIMS::initialize_fims(starting_parameters, data)
config <- attr(starting_input, "julia_model_config")
config[["diagnostic_file"]] <- paste0(profile_path, ".progress")
attr(starting_input, "julia_model_config") <- config
writeLines("epoch_seconds phase", config[["diagnostic_file"]])
message("Fitting the complete example with Julia sampling profiling.")
message("Live phase timings: ", config[["diagnostic_file"]])
message("The sampling profile will be saved on exit at: ", profile_path)
JuliaCall::julia_command("begin
  using Profile
  function fims_write_fit_profile(path, data, buffer_full)
    temporary_path = path * \".tmp\"
    open(temporary_path, \"w\") do io
      println(io, \"Profile buffer full: \", buffer_full)
      Profile.print(IOContext(io, :displaysize => (100, 240)), data;
        format = :flat, sortedby = :count, C = true)
    end
    mv(temporary_path, path; force = true)
    nothing
  end
  function fims_start_fit_profile()
    Profile.clear()
    Profile.init(n = 10_000_000, delay = 0.1)
    Profile.start_timer()
    nothing
  end
  function fims_stop_fit_profile(path)
    Profile.stop_timer()
    fims_write_fit_profile(path, Profile.fetch(), Profile.is_buffer_full())
    nothing
  end
end
")
JuliaCall::julia_call("fims_start_fit_profile")
fit_start <- proc.time()
fit_big_optimized <- tryCatch(
  FIMS::fit_fims(starting_input, number_of_loops = 0),
  finally = {
    JuliaCall::julia_call("fims_stop_fit_profile", profile_path)
    message("Fit elapsed time: ", round((proc.time() - fit_start)[["elapsed"]], 1), " seconds.")
    message("Julia profile written to: ", profile_path)
  }
)
stopifnot(
  FIMS::get_opt(fit_big_optimized)[["convergence"]] == 0L,
  FIMS::get_max_gradient(fit_big_optimized) < 1e-3,
  isTRUE(FIMS::get_sdreport(fit_big_optimized)[["pdHess"]])
)
attr(fit_big_optimized@input, "julia_model_config")[["diagnostic_file"]] <- NULL
environment(FIMS::get_obj(fit_big_optimized)[["fn"]])[["model_config"]][["diagnostic_file"]] <- NULL
estimates_big_optimized <- FIMS::get_estimates(fit_big_optimized)
save(fit_big_optimized, file = "data/fit_big_optimized.rda", compress = "xz")
save(estimates_big_optimized, file = "data/estimates_big_optimized.rda", compress = "xz")

internal <- new.env(parent = emptyenv())
load("R/sysdata.rda", envir = internal)
internal[["fit_big_unoptimized"]] <- fit_big_unoptimized
internal[["estimates_big_unoptimized"]] <- estimates_big_unoptimized
save(list = ls(internal), envir = internal, file = "R/sysdata.rda", compress = "xz")
