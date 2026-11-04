#' Prepare the Julia runtime for FIMS
#'
#' Resolve and precompile FIMS and JuliaCall dependencies together in a writable
#' per-user environment, before embedding Julia in R. No files are written into
#' the installed R package. Internet access is needed on first setup.
#'
#' @param julia Path to the Julia executable. By default uses `JULIA_HOME`
#'   (Julia's `bin` directory) or `julia` on PATH. Install Julia 1.10 or later
#'   before running this function.
#' @return Invisibly returns the configured Julia project directory.
#' @export
setup_julia <- function(julia = NULL) {
  if (is.null(julia)) {
    julia <- .fims_julia_backend_state[["julia"]]
  }
  if (is.null(julia)) {
    home <- Sys.getenv("JULIA_HOME")
    julia <- if (nzchar(home)) {
      file.path(home, if (.Platform[["OS.type"]] == "windows") "julia.exe" else "julia")
    } else {
      unname(Sys.which("julia"))
    }
  }
  if (length(julia) != 1L || is.na(julia) || !nzchar(julia) ||
    !file.exists(julia) || dir.exists(julia)) {
    cli::cli_abort(c(
      "Julia is not available.",
      "i" = "Install Julia 1.10 or later, then set JULIA_HOME to its bin directory or call setup_julia(julia = <executable>)."
    ))
  }
  julia <- normalizePath(julia, winslash = "/", mustWork = TRUE)
  version_output <- system2(julia, c("--startup-file=no", "--version"),
    stdout = TRUE, stderr = TRUE
  )
  if (!is.null(attr(version_output, "status")) ||
    length(version_output) != 1L || !grepl("^julia version [0-9]+\\.[0-9]+", version_output)) {
    cli::cli_abort("The selected Julia executable could not report its version: {paste(version_output, collapse = '\\n')}")
  }
  version <- sub("^julia version ([0-9]+\\.[0-9]+\\.[0-9]+).*", "\\1", version_output)
  if (utils::compareVersion(version, "1.10.0") < 0L) {
    cli::cli_abort("FIMS requires Julia 1.10 or later; the selected runtime is {version}.")
  }
  backend <- normalizePath(julia_backend_package_path(), winslash = "/", mustWork = TRUE)
  script <- system.file("julia", "setup.jl", package = "FIMS")
  if (!nzchar(script)) {
    script <- file.path(dirname(backend), "setup.jl")
  }
  files <- c(
    file.path(backend, "Project.toml"), script,
    list.files(file.path(backend, "src"), pattern = "\\.jl$", recursive = TRUE, full.names = TRUE)
  )
  fingerprint <- paste(
    backend, R.home(), julia, version, paste(unname(tools::md5sum(files)), collapse = ""),
    sep = "\n"
  )
  fingerprint_file <- tempfile()
  on.exit(unlink(fingerprint_file), add = TRUE)
  writeLines(fingerprint, fingerprint_file)
  cache_key <- unname(tools::md5sum(fingerprint_file))
  project <- file.path(
    tools::R_user_dir("FIMS", "cache"), "julia",
    paste0(R.version[["major"]], ".", R.version[["minor"]]), cache_key
  )
  if (isTRUE(.fims_julia_backend_state[["initialized"]]) &&
    !identical(project, .fims_julia_backend_state[["project"]])) {
    cli::cli_abort("The Julia environment changed. Restart R before selecting a different runtime or backend.")
  }
  dir.create(project, recursive = TRUE, showWarnings = FALSE)
  marker <- file.path(project, "configured")
  configured <- file.exists(marker) &&
    identical(readLines(marker, warn = FALSE), strsplit(fingerprint, "\n", fixed = TRUE)[[1]])
  if (!configured) {
    if (isTRUE(.fims_julia_backend_state[["initialized"]])) {
      cli::cli_abort("The Julia environment changed. Restart R before preparing the updated backend.")
    }
    library <- if (.Platform[["OS.type"]] == "windows") {
      file.path(R.home("bin"), "R.dll")
    } else {
      file.path(R.home("lib"), if (Sys.info()[["sysname"]] == "Darwin") "libR.dylib" else "libR.so")
    }
    library <- normalizePath(library, winslash = "/", mustWork = TRUE)
    withr_env <- Sys.getenv(
      c("R_HOME", "JULIA_PKG_PRECOMPILE_AUTO", "JULIA_NUM_PRECOMPILE_TASKS"),
      unset = NA_character_
    )
    on.exit(
      {
        for (name in names(withr_env)) {
          if (is.na(withr_env[[name]])) {
            Sys.unsetenv(name)
          } else {
            do.call(Sys.setenv, stats::setNames(list(withr_env[[name]]), name))
          }
        }
      },
      add = TRUE
    )
    Sys.setenv(R_HOME = R.home(), JULIA_PKG_PRECOMPILE_AUTO = "0")
    if (is.na(withr_env[["JULIA_NUM_PRECOMPILE_TASKS"]])) {
      Sys.setenv(JULIA_NUM_PRECOMPILE_TASKS = "1")
    }
    status <- system2(julia, c(
      "--startup-file=no", shQuote(paste0("--project=", project)),
      shQuote(script), shQuote(backend), shQuote(normalizePath(R.home(), "/")),
      shQuote(library)
    ))
    if (!identical(status, 0L)) {
      cli::cli_abort("Julia dependency preparation failed (exit code {status}); see the Julia output above.")
    }
    writeLines(fingerprint, marker)
  }
  .fims_julia_backend_state[["julia"]] <- julia
  .fims_julia_backend_state[["project"]] <- project
  invisible(project)
}
