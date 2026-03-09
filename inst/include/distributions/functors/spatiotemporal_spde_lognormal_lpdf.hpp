/**
 * @file spatiotemporal_spde_lognormal_lpdf.hpp
 * @brief Spatio-temporal SPDE (Matérn via SPDE FEM matrices) distribution
 * with AR1 evolution over time and lognormal observation likelihood.
 *
 * Computes the joint log-density of:
 *   1. A latent Gaussian random field omega(node, year) with
 *      SPDE Matérn precision Q = tau^2*(kappa^4*C0 + 2*kappa^2*C1 + C2)
 *      and AR1 temporal evolution: e_t = omega_t - rho*omega_{t-1}.
 *   2. Lognormal observations y_i with linear predictor
 *      eta_i = beta0 + (A * omega_{year_i})_i.
 *
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef FIMS_DISTRIBUTIONS_SPATIOTEMPORAL_SPDE_LOGNORMAL_LPDF_HPP
#define FIMS_DISTRIBUTIONS_SPATIOTEMPORAL_SPDE_LOGNORMAL_LPDF_HPP

#include "../../common/def.hpp"
#include "../../common/fims_vector.hpp"
#include "density_components_base.hpp"

namespace fims_distributions {

/**
 * @brief Spatio-temporal SPDE lognormal distribution.
 *
 * Implements a non-age-structured spatial DSEM-like model that combines:
 *   - A Matérn spatial covariance via SPDE FEM matrices (C0, C1, C2).
 *   - AR1 temporal evolution of the latent field omega.
 *   - Lognormal observation likelihood for positive data.
 *
 * The SPDE precision is Q = tau^2*(kappa^4*C0 + 2*kappa^2*C1 + C2).
 *
 * For t = 0:  omega_0 ~ GMRF(Q)  (stationary initial condition)
 * For t > 0:  omega_t | omega_{t-1} ~ GMRF(Q) with mean rho*omega_{t-1}
 *
 * Lognormal likelihood: log(y_i) ~ N(eta_i, sigma_obs^2) - log(y_i)
 *   where eta_i = beta0 + sum_k A[i,k] * omega[year_i * n_nodes + k]
 *
 * @tparam Type The numeric type (double for evaluation, AD<double> for
 * derivatives).
 */
template <typename Type>
struct SpatiotemporalSPDELognormal : public DensityComponentBase<Type> {
  /** @brief Number of mesh nodes. */
  int n_nodes = 0;
  /** @brief Number of years. */
  int n_years = 0;

  // SPDE matrix triplets (0-based row/col indices)
  /** @brief Row indices for C0 (mass matrix) sparse triplets. */
  std::vector<int> C0_i;
  /** @brief Column indices for C0 sparse triplets. */
  std::vector<int> C0_j;
  /** @brief Non-zero values of C0 (constant mesh property). */
  std::vector<double> C0_v;

  /** @brief Row indices for C1 (mixed) sparse triplets. */
  std::vector<int> C1_i;
  /** @brief Column indices for C1 sparse triplets. */
  std::vector<int> C1_j;
  /** @brief Non-zero values of C1 (constant mesh property). */
  std::vector<double> C1_v;

  /** @brief Row indices for C2 (stiffness) sparse triplets. */
  std::vector<int> C2_i;
  /** @brief Column indices for C2 sparse triplets. */
  std::vector<int> C2_j;
  /** @brief Non-zero values of C2 (constant mesh property). */
  std::vector<double> C2_v;

  // Projection matrix A triplets (rows=observations, cols=nodes, 0-based)
  /** @brief Row indices (observation index) for A sparse triplets. */
  std::vector<int> A_i;
  /** @brief Column indices (node index) for A sparse triplets. */
  std::vector<int> A_j;
  /** @brief Non-zero values of A (constant projection weights). */
  std::vector<double> A_v;

  // Observations (constants, not AD-differentiable)
  /** @brief Observed positive values (length n_obs). */
  std::vector<double> y_obs;
  /** @brief Year index (0-based) for each observation. */
  std::vector<int> obs_year_idx;

  // Random effects: latent field omega, indexed as omega[t * n_nodes + k]
  /** @brief Latent spatial field; size n_nodes * n_years. */
  fims::Vector<Type> omega;

  // Fixed effects parameters
  /** @brief Intercept on the log scale. */
  Type beta0 = static_cast<Type>(0.0);
  /** @brief AR1 correlation parameter (logit scale); rho = tanh(rho_logit). */
  Type rho_logit = static_cast<Type>(0.0);
  /** @brief Log SPDE range parameter; kappa = exp(log_kappa). */
  Type log_kappa = static_cast<Type>(0.0);
  /** @brief Log SPDE variance parameter; tau = exp(log_tau). */
  Type log_tau = static_cast<Type>(0.0);
  /** @brief Log observation standard deviation. */
  Type log_sigma_obs = static_cast<Type>(-1.0);

  /** @brief Total log-density (sum over SPDE prior and observation
   * likelihood). */
  Type lpdf = static_cast<Type>(0.0);

  /** @brief Constructor. */
  SpatiotemporalSPDELognormal() : DensityComponentBase<Type>() {}

  /** @brief Destructor. */
  virtual ~SpatiotemporalSPDELognormal() {}

  /**
   * @brief Evaluates the joint log-density: SPDE AR1 prior + lognormal
   * likelihood.
   *
   * @return The joint log-density (positive = more likely).
   */
  virtual const Type evaluate() {
    this->lpdf = static_cast<Type>(0.0);
    size_t n_obs = this->y_obs.size();
    this->report_lpdf_vec.resize(n_obs);
    std::fill(this->report_lpdf_vec.begin(), this->report_lpdf_vec.end(),
              static_cast<Type>(0.0));

#ifdef TMB_MODEL
    // Transform parameters
    Type kappa = fims_math::exp(log_kappa);
    Type tau = fims_math::exp(log_tau);
    Type rho = tanh(rho_logit);
    Type sigma_obs = fims_math::exp(log_sigma_obs);

    Type kappa2 = kappa * kappa;
    Type kappa4 = kappa2 * kappa2;
    Type tau2 = tau * tau;

    // Build sparse SPDE matrices from triplets
    // Use double-valued triplets for constant mesh matrices, then cast to Type
    Eigen::SparseMatrix<double> C0_d(n_nodes, n_nodes);
    Eigen::SparseMatrix<double> C1_d(n_nodes, n_nodes);
    Eigen::SparseMatrix<double> C2_d(n_nodes, n_nodes);
    {
      std::vector<Eigen::Triplet<double>> t0, t1, t2;
      t0.reserve(C0_i.size());
      t1.reserve(C1_i.size());
      t2.reserve(C2_i.size());
      for (size_t nz = 0; nz < C0_i.size(); nz++) {
        t0.push_back(Eigen::Triplet<double>(C0_i[nz], C0_j[nz], C0_v[nz]));
      }
      for (size_t nz = 0; nz < C1_i.size(); nz++) {
        t1.push_back(Eigen::Triplet<double>(C1_i[nz], C1_j[nz], C1_v[nz]));
      }
      for (size_t nz = 0; nz < C2_i.size(); nz++) {
        t2.push_back(Eigen::Triplet<double>(C2_i[nz], C2_j[nz], C2_v[nz]));
      }
      C0_d.setFromTriplets(t0.begin(), t0.end());
      C1_d.setFromTriplets(t1.begin(), t1.end());
      C2_d.setFromTriplets(t2.begin(), t2.end());
    }

    // Cast to Type for AD differentiation through kappa/tau
    Eigen::SparseMatrix<Type> C0 = C0_d.cast<Type>();
    Eigen::SparseMatrix<Type> C1 = C1_d.cast<Type>();
    Eigen::SparseMatrix<Type> C2 = C2_d.cast<Type>();

    // Build SPDE precision: Q = tau^2 * (kappa^4 * C0 + 2*kappa^2 * C1 + C2)
    Eigen::SparseMatrix<Type> Q =
        tau2 * (kappa4 * C0 + static_cast<Type>(2.0) * kappa2 * C1 + C2);
    Q.makeCompressed();

    // SPDE AR1 prior on omega
    // t=0: omega_0 ~ GMRF(Q)  (stationary initial condition)
    // t>0: (omega_t - rho*omega_{t-1}) ~ GMRF(Q)
    using density::GMRF;
    auto gmrf = GMRF(Q);

    for (int t = 0; t < n_years; t++) {
      // Extract omega_t as a TMB vector
      vector<Type> omega_t(n_nodes);
      for (int k = 0; k < n_nodes; k++) {
        omega_t(k) = this->omega[t * n_nodes + k];
      }

      if (t == 0) {
        // Stationary initial condition
        this->lpdf -= gmrf(omega_t);
      } else {
        // AR1 innovation: e_t = omega_t - rho * omega_{t-1}
        vector<Type> omega_prev(n_nodes);
        for (int k = 0; k < n_nodes; k++) {
          omega_prev(k) = this->omega[(t - 1) * n_nodes + k];
        }
        vector<Type> e_t = omega_t - rho * omega_prev;
        this->lpdf -= gmrf(e_t);
      }
    }

    // Lognormal observation likelihood
    // eta_i = beta0 + sum_k A[i,k] * omega[year_i * n_nodes + k]
    // Computed directly from A triplets for efficiency
    std::vector<Type> eta(n_obs, beta0);
    for (size_t nz = 0; nz < A_i.size(); nz++) {
      int obs_idx = A_i[nz];
      int node_k = A_j[nz];
      int year_t = obs_year_idx[static_cast<size_t>(obs_idx)];
      eta[static_cast<size_t>(obs_idx)] +=
          static_cast<Type>(A_v[nz]) * this->omega[year_t * n_nodes + node_k];
    }

    for (size_t i = 0; i < n_obs; i++) {
      if (this->y_obs[i] > 0.0) {
        Type y_i = static_cast<Type>(this->y_obs[i]);
        // Lognormal log-density: dnorm(log(y_i), eta_i, sigma) - log(y_i)
        // The Jacobian term -log(y_i) converts from the density of log(y_i)
        // to the density of y_i (change-of-variables).
        Type lpi = dnorm(log(y_i), eta[i], sigma_obs, true) - log(y_i);
        this->report_lpdf_vec[i] = lpi;
        this->lpdf += lpi;
      }
    }
#endif
    return this->lpdf;
  }
};

}  // namespace fims_distributions

#endif /* FIMS_DISTRIBUTIONS_SPATIOTEMPORAL_SPDE_LOGNORMAL_LPDF_HPP */
