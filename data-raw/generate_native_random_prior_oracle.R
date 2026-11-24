# Run in fresh R from the repository root; the native checkout stays external.
oracle_gradient <- function(objective, parameters, step = 1e-3) {
  purrr::map_dbl(seq_along(parameters), function(index) {
    evaluate <- function(offset) {
      point <- parameters
      point[[index]] <- point[[index]] + offset * step
      objective(point)
    }
    (evaluate(-2) - 8 * evaluate(-1) + 8 * evaluate(1) - evaluate(2)) / (12 * step)
  })
}

oracle_hessian <- function(gradient, parameters, step) {
  columns <- purrr::map(seq_along(parameters), function(index) {
    evaluate <- function(offset) {
      point <- parameters
      point[[index]] <- point[[index]] + offset * step
      gradient(point)
    }
    (evaluate(-2) - 8 * evaluate(-1) + 8 * evaluate(1) - evaluate(2)) / (12 * step)
  })
  value <- do.call(cbind, columns)
  (value + t(value)) / 2
}

generate_native_random_prior_oracle <- function(native_source, output) {
  stopifnot(!"FIMS" %in% loadedNamespaces(), !file.exists(output))
  fixture_path <- file.path("tests", "testthat", "fixtures", "native-configuration-oracle.rds")
  generator_path <- file.path("data-raw", "generate_native_random_prior_oracle.R")
  reference <- readRDS(fixture_path)
  reference_case <- reference[["cases"]][["EWAA-joint-priors"]]
  options(FIMS.disable_julia = TRUE)
  pkgload::load_all(native_source, compile = FALSE, quiet = TRUE, helpers = FALSE)
  dll <- getLoadedDLLs()[["FIMS"]][["path"]]
  stopifnot(identical(unname(tools::md5sum(dll)),
    reference[["provenance"]][["native_dll_md5"]]))
  input <- FIMS::initialize_fims(
    reference_case[["parameters"]], FIMS::FIMSFrame(reference_case[["data"]]), backend = "tmb"
  )
  initial_fit <- FIMS::fit_fims(input, optimize = FALSE, get_sd = FALSE)
  integrated <- FIMS::get_obj(initial_fit)
  native <- TMB::MakeADFun(
    data = list(), parameters = input[["parameters"]], map = input[["map"]],
    random = NULL, DLL = "FIMS", silent = TRUE
  )
  fixed_count <- length(integrated[["par"]])
  random_indices <- seq.int(fixed_count + 1L, length(native[["par"]]))
  fixed_indices <- seq_len(fixed_count)
  stopifnot(fixed_count == 6L, length(random_indices) == 4L)
  native_names <- c(names(integrated[["par"]]),
    names(FIMS::get_random_names(input[["parameters"]][["re"]])))
  metadata <- FIMS::get_estimates(initial_fit)
  native_keys <- purrr::map_chr(strsplit(native_names, ".", fixed = TRUE),
    \(parts) paste(parts[1:4], collapse = "."))
  metadata_keys <- metadata |>
    dplyr::transmute(key = paste(
      .data$module_name, .data$module_id, .data$label, .data$parameter_id, sep = "."
    )) |>
    dplyr::pull(.data$key)
  keys <- c("module_name", "fleet", "label", "year_i", "age", "length")
  parameter_rows <- metadata[match(native_keys, metadata_keys), keys] |>
    dplyr::mutate(
      estimation_type = c(rep("fixed_effects", fixed_count),
        rep("random_effects", length(random_indices))),
      transform = "identity"
    )
  stopifnot(!anyNA(parameter_rows[["module_name"]]),
    identical(parameter_rows, reference_case[["parameters_table"]][names(parameter_rows)]))
  initial <- unname(native[["par"]])
  native_marginal <- integrated[["fn"]](integrated[["par"]])
  native_mode <- integrated[["env"]][["last.par"]]
  native_curvature <- native[["he"]](native_mode)[random_indices, random_indices]
  native_laplace <- native[["fn"]](native_mode) +
    sum(log(diag(chol(native_curvature)))) - length(random_indices) * log(2 * pi) / 2
  stopifnot(abs(native_laplace - native_marginal) < 1e-8)

  random_priors <- tibble::tibble(
    module_name = "Recruitment", fleet = NA_character_, label = "log_devs",
    timing = c(2, 4), age = NA_real_, distribution = "dnorm",
    mean = c(-0.35, 0.25), sd = c(0.12, 0.18)
  )
  cases <- purrr::map(c(FALSE, TRUE), function(include_random_priors) {
    name <- if (include_random_priors) "EWAA-random-priors" else "EWAA-fixed-prior-control"
    message(name)
    priors <- if (include_random_priors) {
      dplyr::bind_rows(reference_case[["priors"]], random_priors)
    } else {
      reference_case[["priors"]]
    }
    locations <- parameter_rows |>
      dplyr::mutate(coordinate = dplyr::row_number()) |>
      dplyr::rename(timing = "year_i") |>
      dplyr::select(dplyr::all_of(c("module_name", "fleet", "label", "timing", "age", "coordinate")))
    indices <- priors |>
      dplyr::left_join(locations,
        by = c("module_name", "fleet", "label", "timing", "age"),
        relationship = "many-to-one") |>
      dplyr::pull(.data$coordinate)
    stopifnot(!anyNA(indices), !anyDuplicated(indices),
      all(priors[["distribution"]] %in% c("dnorm", "dlnorm")))
    prior <- function(parameters) {
      values <- parameters[indices]
      normal <- priors[["distribution"]] == "dnorm"
      mean <- priors[["mean"]]
      sd <- priors[["sd"]]
      components <- numeric(length(indices))
      first <- second <- numeric(length(parameters))
      components[normal] <- -stats::dnorm(values[normal], mean[normal], sd[normal], log = TRUE)
      components[!normal] <- -stats::dlnorm(values[!normal], mean[!normal], sd[!normal], log = TRUE)
      first[indices[normal]] <- (values[normal] - mean[normal]) / sd[normal]^2
      second[indices[normal]] <- 1 / sd[normal]^2
      log_residual <- log(values[!normal]) - mean[!normal]
      first[indices[!normal]] <- (1 + log_residual / sd[!normal]^2) / values[!normal]
      second[indices[!normal]] <-
        (1 / sd[!normal]^2 - 1 - log_residual / sd[!normal]^2) / values[!normal]^2
      list(components = components, value = sum(components), gradient = first, diagonal = second)
    }
    joint_fn <- \(parameters) native[["fn"]](parameters) + prior(parameters)[["value"]]
    joint_gr <- \(parameters) as.numeric(native[["gr"]](parameters)) + prior(parameters)[["gradient"]]
    joint_he <- \(parameters) native[["he"]](parameters) + diag(prior(parameters)[["diagonal"]])
    stopifnot(max(abs(oracle_gradient(\(x) prior(x)[["value"]], initial, 1e-4) -
      prior(initial)[["gradient"]])) < 1e-6,
      max(abs(oracle_hessian(\(x) prior(x)[["gradient"]], initial, 1e-4) -
        diag(prior(initial)[["diagonal"]]))) < 1e-6)

    conditional <- function(fixed) {
      parameters <- initial
      parameters[fixed_indices] <- fixed
      converged <- FALSE
      for (iteration in seq_len(100L)) {
        gradient <- joint_gr(parameters)[random_indices]
        full_curvature <- joint_he(parameters)
        curvature <- full_curvature[random_indices, random_indices]
        direction <- backsolve(chol(curvature),
          forwardsolve(t(chol(curvature)), gradient))
        if (max(abs(gradient)) < 1e-9 || max(abs(direction)) < 1e-12) {
          converged <- TRUE
          break
        }
        value <- joint_fn(parameters)
        fraction <- 1
        repeat {
          proposal <- parameters
          proposal[random_indices] <- parameters[random_indices] - fraction * direction
          proposed_value <- joint_fn(proposal)
          # Below objective resolution, require an improving score residual.
          resolved_score <- abs(proposed_value - value) <=
            8 * .Machine[["double.eps"]] * max(1, abs(value)) &&
            max(abs(joint_gr(proposal)[random_indices])) < max(abs(gradient))
          if (proposed_value <= value - 1e-4 * fraction * sum(gradient * direction) ||
            resolved_score) break
          fraction <- fraction / 2
          if (fraction < 2^-30) stop("Conditional Newton line search failed.")
        }
        parameters <- proposal
      }
      if (!converged) stop("Conditional mode did not converge: gradient=",
        format(max(abs(gradient)), digits = 12), ", step=",
        format(max(abs(direction)), digits = 12), ", fixed=", paste(fixed, collapse = ","))
      curvature <- joint_he(parameters)[random_indices, random_indices]
      stopifnot(max(abs(joint_gr(parameters)[random_indices])) < 1e-7)
      joint <- joint_fn(parameters)
      adjustment <- sum(log(diag(chol(curvature)))) - length(random_indices) * log(2 * pi) / 2
      list(parameters = parameters, joint = joint, marginal = joint + adjustment,
        laplace_adjustment = adjustment, random_hessian = curvature,
        joint_hessian = full_curvature, random_gradient = joint_gr(parameters)[random_indices],
        native_joint = native[["fn"]](parameters),
        native_gradient = as.numeric(native[["gr"]](parameters)),
        native_random_hessian = native[["he"]](parameters)[random_indices, random_indices],
        prior_random_hessian = diag(prior(parameters)[["diagonal"]][random_indices]))
    }
    marginal <- \(fixed) conditional(fixed)[["marginal"]]
    gradient <- function(fixed, step = 1e-3) {
      mode <- conditional(fixed)
      parameters <- mode[["parameters"]]
      inverse <- chol2inv(chol(mode[["random_hessian"]]))
      sensitivity <- -inverse %*% mode[["joint_hessian"]][random_indices, fixed_indices]
      directions <- rbind(diag(fixed_count), sensitivity)
      trace_gradient <- purrr::map_dbl(fixed_indices, function(index) {
        evaluate <- \(offset) joint_he(parameters + offset * step * directions[, index])[
          random_indices, random_indices
        ]
        derivative <- (evaluate(-2) - 8 * evaluate(-1) + 8 * evaluate(1) -
          evaluate(2)) / (12 * step)
        sum(inverse * t(derivative)) / 2
      })
      joint_gr(parameters)[fixed_indices] + trace_gradient
    }
    points <- purrr::map(reference_case[["points"]], function(point) {
      fixed <- point[["fixed"]]
      mode <- conditional(fixed)
      report <- native[["report"]](mode[["parameters"]])
      report[["jnll"]] <- mode[["joint"]]
      point_gradient <- gradient(fixed)
      half_gradient <- gradient(fixed, 5e-4)
      value_gradient <- oracle_gradient(marginal, fixed, 5e-4)
      stopifnot(max(abs(point_gradient - half_gradient)) < 1e-5,
        max(abs(point_gradient - value_gradient)) < 1e-5,
        max(abs(mode[["random_gradient"]])) < 1e-6)
      if (!include_random_priors) {
        stopifnot(abs(mode[["marginal"]] - point[["marginal"]]) < 1e-8,
          max(abs(point_gradient - point[["gradient"]])) < 1e-5)
      }
      c(list(fixed = fixed, gradient = point_gradient, report = report,
        half_step_gradient = half_gradient, marginal_difference_gradient = value_gradient,
        prior_nll_components = prior(mode[["parameters"]])[["components"]]), mode)
    })
    lower <- rep(-Inf, fixed_count)
    lower[indices[priors[["distribution"]] == "dlnorm"]] <- .Machine[["double.eps"]]
    optimum <- stats::nlminb(initial[fixed_indices], marginal, gradient, lower = lower,
      control = list(iter.max = 400, eval.max = 1000))
    for (restart in seq_len(3L)) {
      if (optimum[["convergence"]] == 0L && max(abs(gradient(optimum[["par"]]))) < 1e-4) break
      optimum <- stats::nlminb(optimum[["par"]], marginal, gradient, lower = lower,
        control = list(iter.max = 400, eval.max = 1000))
    }
    message("Convergence: ", optimum[["convergence"]], "; max gradient: ",
      format(max(abs(gradient(optimum[["par"]]))), digits = 8))
    stopifnot(optimum[["convergence"]] == 0L, max(abs(gradient(optimum[["par"]]))) < 1e-3)
    stopifnot(max(abs(gradient(optimum[["par"]]) -
      oracle_gradient(marginal, optimum[["par"]], 5e-4))) < 1e-5)
    mode <- conditional(optimum[["par"]])
    hessian <- oracle_hessian(gradient, optimum[["par"]], 1e-3)
    check_hessian <- oracle_hessian(
      \(fixed) gradient(fixed, 5e-4), optimum[["par"]], 5e-4
    )
    fixed_covariance <- chol2inv(chol(hessian))
    check_covariance <- chol2inv(chol(check_hessian))
    stopifnot(isTRUE(all.equal(fixed_covariance, check_covariance, tolerance = 1e-5)))
    joint_hessian <- joint_he(mode[["parameters"]])
    random_covariance <- chol2inv(chol(mode[["random_hessian"]]))
    sensitivity <- -random_covariance %*% joint_hessian[random_indices, fixed_indices]
    covariance <- rbind(
      cbind(fixed_covariance, fixed_covariance %*% t(sensitivity)),
      cbind(sensitivity %*% fixed_covariance,
        random_covariance + sensitivity %*% fixed_covariance %*% t(sensitivity))
    )
    chol(covariance)
    # No random flag here: propagate the augmented full covariance through the
    # native AD report Jacobian, not through an unaugmented native Laplace fit.
    sdreport <- TMB::sdreport(native, par.fixed = mode[["parameters"]],
      hessian.fixed = solve(covariance), getReportCovariance = FALSE)
    stopifnot(sdreport[["pdHess"]],
      isTRUE(all.equal(unname(sdreport[["cov.fixed"]]), unname(covariance), tolerance = 1e-10)))
    report_summary <- summary(sdreport, "report")
    report_rows <- tibble::tibble(label = rownames(report_summary),
      estimate = report_summary[, "Estimate"], uncertainty = report_summary[, "Std. Error"]) |>
      dplyr::group_by(.data$label) |>
      dplyr::mutate(oracle_id = dplyr::row_number()) |>
      dplyr::ungroup()
    derived <- reference_case[["derived"]] |>
      dplyr::select(dplyr::all_of(keys)) |>
      dplyr::group_by(.data$label) |>
      dplyr::mutate(oracle_id = dplyr::row_number()) |>
      dplyr::ungroup() |>
      dplyr::left_join(report_rows, by = c("label", "oracle_id"), relationship = "one-to-one") |>
      dplyr::select(-dplyr::all_of("oracle_id"))
    parameters_table <- parameter_rows |>
      dplyr::mutate(estimated = mode[["parameters"]], uncertainty = sqrt(diag(covariance)))
    stopifnot(nrow(derived) == 2216L, all(is.finite(derived[["uncertainty"]])))
    if (!include_random_priors) {
      stopifnot(abs(mode[["marginal"]] - reference_case[["marginal"]]) < 1e-6,
        isTRUE(all.equal(unname(covariance), reference_case[["covariance"]], tolerance = 1e-4)),
        isTRUE(all.equal(unname(derived[["uncertainty"]]),
          unname(reference_case[["derived"]][["uncertainty"]]), tolerance = 1e-4)))
    }
    report <- native[["report"]](mode[["parameters"]])
    report[["jnll"]] <- mode[["joint"]]
    list(name = name, data = reference_case[["data"]], parameters = reference_case[["parameters"]],
      priors = priors, prior_coordinates = indices, points = points,
      marginal = mode[["marginal"]], report = report, parameters_table = parameters_table,
      covariance = unname(covariance), derived = derived, optimum = optimum,
      conditional = mode, joint_hessian = joint_hessian, fixed_hessian = hessian,
      conditional_random_covariance = random_covariance, random_fixed_sensitivity = sensitivity,
      prior_nll_components = prior(mode[["parameters"]])[["components"]],
      max_gradient = max(abs(gradient(optimum[["par"]]))),
      derivative_check = list(step = 1e-3, check_step = 5e-4,
        fixed_hessian = check_hessian, fixed_covariance = check_covariance))
  })
  names(cases) <- purrr::map_chr(cases, \(case) case[["name"]])
  control <- cases[[1]][["points"]][[1]]
  augmented <- cases[[2]][["points"]][[1]]
  post_marginal_value <- control[["marginal"]] - sum(stats::dnorm(
    control[["parameters"]][utils::tail(cases[[2]][["prior_coordinates"]], nrow(random_priors))],
    random_priors[["mean"]], random_priors[["sd"]], log = TRUE
  ))
  off_diagonal <- augmented[["random_hessian"]]
  diag(off_diagonal) <- 0
  stopifnot(max(abs(off_diagonal)) > 1,
    max(abs(control[["parameters"]][random_indices] - augmented[["parameters"]][random_indices])) > 0.01,
    max(abs(control[["random_hessian"]] - augmented[["random_hessian"]])) > 1,
    abs(post_marginal_value - augmented[["marginal"]]) > 1e-3)
  native_sources <- list.files(file.path(native_source, "R"), "\\.R$", full.names = TRUE)
  source_md5 <- tools::md5sum(native_sources)
  names(source_md5) <- basename(names(source_md5))
  result <- list(provenance = list(
    native_declared_revision = reference[["provenance"]][["revision"]],
    native_dll_md5 = unname(tools::md5sum(dll)), native_R_source_md5 = as.list(source_md5),
    input_fixture_md5 = unname(tools::md5sum(fixture_path)),
    generator_md5 = unname(tools::md5sum(generator_path)),
    R = R.version.string, TMB = as.character(utils::packageVersion("TMB")),
    optimizer_control = list(iter.max = 400L, eval.max = 1000L, maximum_restarts = 3L),
    conditional_gradient_tolerance = 1e-9, conditional_step_tolerance = 1e-12,
    maximum_accepted_random_score = 1e-7,
    method = paste("Historical native joint AD tape with random=NULL, augmented before mode solving",
      "by independent R densities and analytic prior gradient/Hessian.",
      "Damped Newton conditional modes; exact augmented random Hessian/Laplace determinant.",
      "Implicit marginal scores use five-point derivatives of native random curvature;",
      "scores checked against marginal-value differences, and Hessians at halved steps.",
      "Native AD report Jacobians propagate full Laplace fixed/random covariance.",
      "No Julia evaluation and no native compilation.")),
    post_marginal_counterexample = list(
      fixed = control[["fixed"]], incorrect_marginal = post_marginal_value,
      correct_marginal = augmented[["marginal"]]), cases = cases)
  portable <- function(value) {
    stopifnot(!typeof(value) %in% c("externalptr", "weakref", "environment", "closure"))
    if (is.character(value)) stopifnot(!any(grepl(
      "Users|AppData|copilot-worktrees", value, ignore.case = TRUE), na.rm = TRUE))
    if (is.list(value)) invisible(purrr::walk(value, portable))
    if (length(attributes(value))) invisible(purrr::walk(attributes(value), portable))
  }
  portable(result)
  saveRDS(result, output, compress = "xz")
  message("Saved independently verified reference: ", output)
  invisible(result)
}

if (sys.nframe() == 0L) {
  arguments <- commandArgs(TRUE)
  if (length(arguments) != 2L) stop("Supply native checkout and NEW output RDS path.")
  generate_native_random_prior_oracle(arguments[[1]], arguments[[2]])
}
