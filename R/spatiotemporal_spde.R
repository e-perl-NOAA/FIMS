#' @title Spatio-temporal SPDE lognormal distribution helpers
#'
#' @description
#' Helper functions for working with the spatio-temporal SPDE lognormal
#' distribution in FIMS. These functions simplify the construction and
#' configuration of `SpatiotemporalSPDE` objects from R.
#'
#' The spatio-temporal model combines:
#'   - A Matérn spatial covariance via SPDE FEM matrices (C0, C1, C2).
#'   - AR1 temporal evolution of the latent field \eqn{\omega}.
#'   - A lognormal observation likelihood.
#'
#' @name spatiotemporal_spde
NULL

#' Convert a sparse matrix to 0-based triplet lists
#'
#' @description
#' Converts a sparse matrix (class `dgCMatrix`, `dCMatrix`, or any matrix
#' coercible to `dgCMatrix`) to a list of 0-based row-indices, column-indices,
#' and non-zero values suitable for passing to a `SpatiotemporalSPDE` object.
#'
#' @param mat A sparse matrix (coercible to `Matrix::dgCMatrix`).
#'
#' @return A named list with elements:
#'   \describe{
#'     \item{`i`}{Integer vector of 0-based row indices.}
#'     \item{`j`}{Integer vector of 0-based column indices.}
#'     \item{`v`}{Numeric vector of non-zero values.}
#'   }
#'
#' @examples
#' \dontrun{
#' library(Matrix)
#' M <- Matrix::sparseMatrix(i = c(1, 2, 3), j = c(1, 2, 3),
#'                           x = c(1, 2, 3), dims = c(3, 3))
#' trips <- sparse_to_triplets(M)
#' }
#'
#' @export
sparse_to_triplets <- function(mat) {
  if (!requireNamespace("Matrix", quietly = TRUE)) {
    stop("Package 'Matrix' is required for sparse_to_triplets(). ",
         "Install it with: install.packages('Matrix')", call. = FALSE)
  }
  if (!inherits(mat, "dgCMatrix")) {
    mat <- methods::as(mat, "dgCMatrix")
  }
  # Matrix::summary returns triplet form with 1-based indices
  sm <- Matrix::summary(mat)
  list(
    i = as.numeric(sm$i - 1L),  # 0-based
    j = as.numeric(sm$j - 1L),  # 0-based
    v = as.numeric(sm$x)
  )
}

#' Create and configure a SpatiotemporalSPDE distribution object
#'
#' @description
#' Constructs and configures a `SpatiotemporalSPDE` Rcpp interface object for
#' use with FIMS. Sets up the SPDE matrices, projection matrix, observations,
#' and parameter initial values.
#'
#' After calling this function, pass the returned object to
#' `CreateTMBModel()` (which is called automatically when all FIMS objects
#' have been configured).
#'
#' @param n_nodes Integer. Number of mesh nodes.
#' @param n_years Integer. Number of years.
#' @param C0_triplets List with elements `i`, `j`, `v` (0-based triplets for
#'   the mass matrix C0). Use [sparse_to_triplets()] to generate from a sparse
#'   matrix.
#' @param C1_triplets List with elements `i`, `j`, `v` (0-based triplets for
#'   the mixed stiffness matrix C1).
#' @param C2_triplets List with elements `i`, `j`, `v` (0-based triplets for
#'   the stiffness matrix C2).
#' @param A_triplets List with elements `i`, `j`, `v` (0-based triplets for
#'   the projection matrix A, dimensions n_obs x n_nodes).
#' @param y_obs Numeric vector of positive observed values (length n_obs).
#' @param obs_year_idx Integer vector of 0-based year indices for each
#'   observation (length n_obs).
#' @param beta0_init Initial value for the log-scale intercept. Default `0`.
#' @param rho_logit_init Initial value for the AR1 correlation (logit scale).
#'   Default `0` (corresponds to rho = 0 = no temporal correlation).
#' @param log_kappa_init Initial value for log(kappa). Default `0`.
#' @param log_tau_init Initial value for log(tau). Default `0`.
#' @param log_sigma_obs_init Initial value for log(sigma_obs). Default
#'   `log(0.3)`.
#' @param estimate_beta0 Logical. Whether to estimate beta0. Default `TRUE`.
#' @param estimate_rho Logical. Whether to estimate rho (rho_logit). Default
#'   `TRUE`.
#' @param estimate_log_kappa Logical. Whether to estimate log_kappa. Default
#'   `FALSE` (treat as fixed constant).
#' @param estimate_log_tau Logical. Whether to estimate log_tau. Default
#'   `FALSE` (treat as fixed constant).
#' @param estimate_log_sigma_obs Logical. Whether to estimate log_sigma_obs.
#'   Default `TRUE`.
#' @param omega_init Numeric scalar or vector. Initial values for the latent
#'   field omega (length n_nodes * n_years). Default `0`.
#'
#' @return A `SpatiotemporalSPDE` Rcpp interface object, already registered
#'   in FIMS's internal object list.
#'
#' @examples
#' \dontrun{
#' library(Matrix)
#' library(fmesher)
#' # Build a simple mesh
#' loc <- matrix(c(0, 0, 1, 0, 0.5, 1), ncol = 2, byrow = TRUE)
#' mesh <- fmesher::fm_mesh_2d(loc = loc, max.edge = 2)
#' spde <- fmesher::fm_fem(mesh)
#' A <- fmesher::fm_basis(mesh, loc = loc)
#'
#' y <- c(1.5, 2.0, 1.8, 1.3, 1.7, 2.1)
#' year_idx <- c(0L, 0L, 0L, 1L, 1L, 1L)
#'
#' spde_obj <- create_spatiotemporal_spde(
#'   n_nodes = mesh$n,
#'   n_years = 2L,
#'   C0_triplets = sparse_to_triplets(spde$c0),
#'   C1_triplets = sparse_to_triplets(spde$g1),
#'   C2_triplets = sparse_to_triplets(spde$g2),
#'   A_triplets  = sparse_to_triplets(A),
#'   y_obs       = y,
#'   obs_year_idx = year_idx
#' )
#' CreateTMBModel()
#' }
#'
#' @export
create_spatiotemporal_spde <- function(
    n_nodes,
    n_years,
    C0_triplets,
    C1_triplets,
    C2_triplets,
    A_triplets,
    y_obs,
    obs_year_idx,
    beta0_init = 0,
    rho_logit_init = 0,
    log_kappa_init = 0,
    log_tau_init = 0,
    log_sigma_obs_init = log(0.3),
    estimate_beta0 = TRUE,
    estimate_rho = TRUE,
    estimate_log_kappa = FALSE,
    estimate_log_tau = FALSE,
    estimate_log_sigma_obs = TRUE,
    omega_init = 0) {

  spde <- methods::new(SpatiotemporalSPDE)

  # Dimensions
  spde$n_nodes <- as.integer(n_nodes)
  spde$n_years <- as.integer(n_years)

  # SPDE matrix triplets
  spde$C0_i <- as.numeric(C0_triplets$i)
  spde$C0_j <- as.numeric(C0_triplets$j)
  spde$C0_v <- as.numeric(C0_triplets$v)

  spde$C1_i <- as.numeric(C1_triplets$i)
  spde$C1_j <- as.numeric(C1_triplets$j)
  spde$C1_v <- as.numeric(C1_triplets$v)

  spde$C2_i <- as.numeric(C2_triplets$i)
  spde$C2_j <- as.numeric(C2_triplets$j)
  spde$C2_v <- as.numeric(C2_triplets$v)

  # Projection matrix A
  spde$A_i <- as.numeric(A_triplets$i)
  spde$A_j <- as.numeric(A_triplets$j)
  spde$A_v <- as.numeric(A_triplets$v)

  # Observations
  spde$y_obs       <- as.numeric(y_obs)
  spde$obs_year_idx <- as.numeric(obs_year_idx)

  # Fixed-effect parameters
  spde$beta0[1]$value          <- beta0_init
  spde$rho_logit[1]$value      <- rho_logit_init
  spde$log_kappa[1]$value      <- log_kappa_init
  spde$log_tau[1]$value        <- log_tau_init
  spde$log_sigma_obs[1]$value  <- log_sigma_obs_init

  spde$beta0[1]$estimation_type <-
    if (estimate_beta0) "fixed_effects" else "constant"
  spde$rho_logit[1]$estimation_type <-
    if (estimate_rho) "fixed_effects" else "constant"
  spde$log_kappa[1]$estimation_type <-
    if (estimate_log_kappa) "fixed_effects" else "constant"
  spde$log_tau[1]$estimation_type <-
    if (estimate_log_tau) "fixed_effects" else "constant"
  spde$log_sigma_obs[1]$estimation_type <-
    if (estimate_log_sigma_obs) "fixed_effects" else "constant"

  # Random effects: omega
  n_omega <- as.integer(n_nodes) * as.integer(n_years)
  omega_vals <- rep(as.numeric(omega_init), length.out = n_omega)
  spde$omega$resize(n_omega)
  for (k in seq_len(n_omega)) {
    spde$omega[k]$value           <- omega_vals[k]
    spde$omega[k]$estimation_type <- "random_effects"
  }

  invisible(spde)
}
