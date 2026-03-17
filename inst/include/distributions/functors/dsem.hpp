/**
 * @file dsem.hpp
 * @brief Dynamic structural equation model (DSEM) likelihood component.
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef FIMS_DISTRIBUTIONS_DSEM_HPP
#define FIMS_DISTRIBUTIONS_DSEM_HPP

#include <Eigen/IterativeLinearSolvers>

#include "density_components_base.hpp"

namespace fims_distributions {

/**
 * @brief DSEM likelihood and latent process contribution.
 *
 * @details This module follows the sparse precision-matrix implementation used
 * in Rceattle for integrating dsem-style latent dynamics and observation
 * families into the joint negative log-likelihood.
 *
 * Why this is a header (`.hpp`) in FIMS:
 * - FIMS likelihood components are templated (`Type`) so they can be compiled
 *   for both ordinary doubles and automatic-differentiation types.
 * - Templated definitions must be visible at compile/instantiation time, so the
 *   full implementation is kept in a header instead of split into a `.cpp`.
 * - Rceattle's `.cpp` organization is tied to a single TMB model translation
 *   unit, while FIMS composes many reusable modules from headers.
 */
template <typename Type>
struct DSEMLikelihood : public DensityComponentBase<Type> {
  // Runtime options from dsem/tmb inputs.
  // options[0] controls whether x_tj is already transformed or needs mapping.
  // options[1] controls optional marginal-variance scaling.
  fims::Vector<Type> options;
  // Flattened RAM triplets/quads that define SEM links.
  // Stored as rows of: [ram_type, row_k, col_k, parameter_index].
  fims::Vector<Type> RAM;
  size_t RAM_n_rows = 0;
  // Default/fixed RAM values used when no estimable beta_z parameter is mapped.
  fims::Vector<Type> RAMstart;
  // Observation family code per variable j (fixed, normal, bernoulli, ...).
  fims::Vector<Type> familycode_j;
  // Observed data stacked by variable-major k = j*n_t + t indexing.
  fims::Vector<Type> y_tj;
  size_t n_t = 0;
  size_t n_j = 0;

  // DSEM parameters.
  fims::Vector<Type> beta_z;
  fims::Vector<Type> lnsigma_j;
  fims::Vector<Type> mu_j;
  fims::Vector<Type> delta0_j;
  // Latent state vector (random effects in typical configurations).
  fims::Vector<Type> x_tj;

  // Report outputs for downstream summaries/debugging.
  fims::Vector<Type> z_tj_report;
  Type jnll_dsem = static_cast<Type>(0.0);
  Type jnll_gmrf_dsem = static_cast<Type>(0.0);

  inline size_t k_index(size_t t, size_t j) const { return j * n_t + t; }

  virtual const Type evaluate() {
    using namespace density;

    if (this->n_t == 0 || this->n_j == 0) {
      return static_cast<Type>(0.0);
    }

    const int n_k = static_cast<int>(this->n_t * this->n_j);
    auto sparse_to_dense = [](const Eigen::SparseMatrix<Type> &sparse_matrix) {
      matrix<Type> dense_matrix(sparse_matrix.rows(), sparse_matrix.cols());
      dense_matrix.setZero();
      for (int k = 0; k < sparse_matrix.outerSize(); ++k) {
        for (typename Eigen::SparseMatrix<Type>::InnerIterator it(sparse_matrix, k);
             it; ++it) {
          dense_matrix(it.row(), it.col()) = it.value();
        }
      }
      return dense_matrix;
    };
    auto solve_linear_system = [&](const Eigen::SparseMatrix<Type> &lhs_matrix,
                                   const matrix<Type> &rhs_matrix) {
      Eigen::BiCGSTAB<Eigen::SparseMatrix<Type>> solver;
      solver.compute(lhs_matrix);
      if (solver.info() != Eigen::Success) {
        FIMS_WARNING_LOG(
            "DSEMLikelihood sparse solve decomposition failed; results may be "
            "unreliable.");
      }
      matrix<Type> solution = solver.solve(rhs_matrix);
      if (solver.info() != Eigen::Success) {
        FIMS_WARNING_LOG(
            "DSEMLikelihood sparse solve iteration failed for one or more RHS "
            "columns; results may be unreliable.");
      }
      return solution;
    };

    matrix<Type> loglik_tj_dsem(this->n_t, this->n_j);
    loglik_tj_dsem.setZero();
    vector<Type> sigma_j(this->n_j);
    for (size_t j = 0; j < this->n_j; j++) {
      sigma_j(j) = exp(this->lnsigma_j.get_force_scalar(j));
    }

    Eigen::SparseMatrix<Type> Rho_kk(n_k, n_k);
    Eigen::SparseMatrix<Type> Gamma_kk(n_k, n_k);
    Eigen::SparseMatrix<Type> I_kk(n_k, n_k);
    Rho_kk.setZero();
    Gamma_kk.setZero();
    I_kk.setIdentity();

    for (size_t r = 0; r < this->RAM_n_rows; r++) {
      const size_t row = r * 4;
      const int ram_type = CppAD::Integer(this->RAM[row + 0]);
      const int i = CppAD::Integer(this->RAM[row + 1]) - 1;
      const int j = CppAD::Integer(this->RAM[row + 2]) - 1;
      const int pidx = CppAD::Integer(this->RAM[row + 3]);

      Type tmp = this->RAMstart[r];
      if (pidx >= 1 && static_cast<size_t>(pidx) <= this->beta_z.size()) {
        tmp = this->beta_z[pidx - 1];
      }
      if (ram_type == 1) {
        // Directed path (->) contributes to autoregressive/transition structure.
        Rho_kk.coeffRef(i, j) = tmp;
      } else if (ram_type == 2) {
        // Variance/covariance path (<->) contributes to process covariance.
        Gamma_kk.coeffRef(i, j) = tmp;
      }
    }
    Eigen::SparseMatrix<Type> IminusRho_kk = I_kk - Rho_kk;

    // Rescale matrices when options(1) is 1 or 2 (constant marginal variance).
    if (this->options.size() > 1 &&
        ((CppAD::Integer(this->options[1]) == 1) ||
         (CppAD::Integer(this->options[1]) == 2))) {
      matrix<Type> I_dense(n_k, n_k);
      I_dense.setIdentity();
      matrix<Type> invIminusRho_dense =
          solve_linear_system(IminusRho_kk, I_dense);
      matrix<Type> squared_invIminusRho_dense =
          invIminusRho_dense.cwiseProduct(invIminusRho_dense);
      Eigen::ColPivHouseholderQR<matrix<Type>> invsq_solver(
          squared_invIminusRho_dense);

      if (CppAD::Integer(this->options[1]) == 1) {
        matrix<Type> ones_k1(n_k, 1);
        ones_k1.setOnes();
        Eigen::SparseMatrix<Type> squared_Gamma_kk =
            Gamma_kk.cwiseProduct(Gamma_kk);
        matrix<Type> sigma2_k1 = squared_Gamma_kk.transpose() * ones_k1;
        matrix<Type> margvar_k1 = invsq_solver.solve(sigma2_k1);

        Eigen::SparseMatrix<Type> invmargsd_kk(n_k, n_k);
        Eigen::SparseMatrix<Type> invsigma_kk(n_k, n_k);
        for (int k = 0; k < n_k; k++) {
          invmargsd_kk.coeffRef(k, k) = pow(margvar_k1(k, 0), -0.5);
          invsigma_kk.coeffRef(k, k) = pow(sigma2_k1(k, 0), -0.5);
        }
        IminusRho_kk = invmargsd_kk * IminusRho_kk;
        Gamma_kk = invsigma_kk * Gamma_kk;
      } else {
        matrix<Type> targetvar_k1(n_k, 1);
        for (int k = 0; k < n_k; k++) {
          targetvar_k1(k, 0) =
              Gamma_kk.coeffRef(k, k) * Gamma_kk.coeffRef(k, k);
        }
        matrix<Type> margvar_k1 = invsq_solver.solve(targetvar_k1);
        for (int k = 0; k < n_k; k++) {
          Gamma_kk.coeffRef(k, k) = pow(margvar_k1(k, 0), 0.5);
        }
      }
    }

    vector<Type> delta_k(n_k);
    delta_k.setZero();
    if (this->delta0_j.size() > 0) {
      // delta0_j are initial-condition offsets at t = 1 for each series j.
      // They are propagated through (I - Rho)^-1 to create full-state offsets.
      matrix<Type> delta0_k1(n_k, 1);
      delta0_k1.setZero();
      for (size_t j = 0; j < this->n_j; j++) {
        size_t k = j * this->n_t;
        delta0_k1(k, 0) = this->delta0_j.get_force_scalar(j);
      }
      matrix<Type> x = solve_linear_system(IminusRho_kk, delta0_k1);
      for (int k = 0; k < n_k; k++) {
        delta_k(k) = x(k, 0);
      }
    }

    array<Type> xhat_tj(this->n_t, this->n_j);
    array<Type> delta_tj(this->n_t, this->n_j);
    array<Type> x_array(this->n_t, this->n_j);
    for (size_t j = 0; j < this->n_j; j++) {
      for (size_t t = 0; t < this->n_t; t++) {
        const size_t k = this->k_index(t, j);
        xhat_tj(t, j) = this->mu_j.get_force_scalar(j);
        delta_tj(t, j) = delta_k(static_cast<int>(k));
        x_array(t, j) = this->x_tj.get_force_scalar(k);
      }
    }

    array<Type> z_tj(this->n_t, this->n_j);
    if (this->options.size() > 0 && CppAD::Integer(this->options[0]) == 0) {
      // Standard mode: x_tj is on the data scale and receives a sparse GMRF
      // prior with precision Q = (I-Rho)' V^-1 (I-Rho).
      Eigen::SparseMatrix<Type> V_kk = Gamma_kk.transpose() * Gamma_kk;
      matrix<Type> V_dense(n_k, n_k);
      V_dense.setZero();
      for (int k = 0; k < V_kk.outerSize(); ++k) {
        for (typename Eigen::SparseMatrix<Type>::InnerIterator it(V_kk, k); it;
             ++it) {
          V_dense(it.row(), it.col()) = it.value();
        }
      }
      matrix<Type> Vinv_kk = atomic::matinv(V_dense);
      Eigen::SparseMatrix<Type> Vinv2_kk(n_k, n_k);
      for (int i = 0; i < n_k; i++) {
        for (int j = 0; j < n_k; j++) {
          if (Vinv_kk(i, j) != static_cast<Type>(0.0)) {
            Vinv2_kk.coeffRef(i, j) = Vinv_kk(i, j);
          }
        }
      }
      Eigen::SparseMatrix<Type> Q_kk =
          IminusRho_kk.transpose() * Vinv2_kk * IminusRho_kk;

      this->jnll_gmrf_dsem = GMRF(Q_kk)(x_array - xhat_tj - delta_tj);
      z_tj = x_array;
    } else {
      // Alternative mode: x_tj is standardized, so apply identity GMRF prior
      // first and then transform into z_tj via Gamma and (I-Rho)^-1.
      this->jnll_gmrf_dsem = GMRF(I_kk)(x_array);
      matrix<Type> z_k1(n_k, 1);
      for (size_t j = 0; j < this->n_j; j++) {
        for (size_t t = 0; t < this->n_t; t++) {
          z_k1(this->k_index(t, j), 0) = x_array(t, j);
        }
      }
      matrix<Type> z2_k1 = Gamma_kk * z_k1;
      matrix<Type> z3_k1 = solve_linear_system(IminusRho_kk, z2_k1);
      for (size_t j = 0; j < this->n_j; j++) {
        for (size_t t = 0; t < this->n_t; t++) {
          z_tj(t, j) = z3_k1(this->k_index(t, j), 0);
        }
      }
      z_tj += xhat_tj + delta_tj;
    }

    array<Type> mu_tj(this->n_t, this->n_j);
    for (size_t t = 0; t < this->n_t; t++) {
      for (size_t j = 0; j < this->n_j; j++) {
        const size_t k = this->k_index(t, j);
        const int family = CppAD::Integer(this->familycode_j.get_force_scalar(j));
        const Type y = this->y_tj.get_force_scalar(k);

        if (family == 0) {
          // "fixed": observed value is treated as latent mean (no data density).
          mu_tj(t, j) = z_tj(t, j);
        } else if (family == 1) {
          // Gaussian response on identity scale.
          mu_tj(t, j) = z_tj(t, j);
          if (!R_IsNA(asDouble(y))) {
            loglik_tj_dsem(t, j) = dnorm(y, mu_tj(t, j), sigma_j(j), true);
          }
        } else if (family == 2) {
          // Bernoulli response on logit scale.
          mu_tj(t, j) = invlogit(z_tj(t, j));
          if (!R_IsNA(asDouble(y))) {
            loglik_tj_dsem(t, j) = dbinom(y, Type(1.0), mu_tj(t, j), true);
          }
        } else if (family == 3) {
          // Poisson response on log scale.
          mu_tj(t, j) = exp(z_tj(t, j));
          if (!R_IsNA(asDouble(y))) {
            loglik_tj_dsem(t, j) = dpois(y, mu_tj(t, j), true);
          }
        } else if (family == 4) {
          // Gamma response with log-linked mean and sigma-driven shape/scale.
          mu_tj(t, j) = exp(z_tj(t, j));
          if (!R_IsNA(asDouble(y))) {
            loglik_tj_dsem(t, j) = dgamma(y, pow(sigma_j(j), -2),
                                          mu_tj(t, j) * pow(sigma_j(j), 2), true);
          }
        }
      }
    }

    this->jnll_dsem = -loglik_tj_dsem.sum() + this->jnll_gmrf_dsem;
    this->z_tj_report.resize(this->n_t * this->n_j);
    for (size_t j = 0; j < this->n_j; j++) {
      for (size_t t = 0; t < this->n_t; t++) {
        this->z_tj_report[this->k_index(t, j)] = z_tj(t, j);
      }
    }
    // FIMS density components return log-density. Here jnll_dsem is a positive
    // negative log-likelihood, so we pre-negate to return log-density.
    return -this->jnll_dsem;
  }
};

}  // namespace fims_distributions

#endif
