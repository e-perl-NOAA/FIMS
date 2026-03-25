/**
 * @file precision_matrix_builder.hpp
 * @brief Declares helpers that assemble precision matrices for multivariate
 * random-effects models (TMB-only, sparse-Q interface).
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef PRECISION_MATRIX_BUILDER_HPP
#define PRECISION_MATRIX_BUILDER_HPP

#include "density_components_base.hpp"
#include "../../common/def.hpp"
#include <Eigen/Sparse>
#include <TMB.hpp>  // tmbutils::invertSparseMatrix, tmbutils::asSparseMatrix

namespace fims_distributions {

/**
 * @brief Base class for objects that assemble a sparse precision matrix Q.
 *
 * @tparam Type Numeric type (TMB type).
 */
template <typename Type>
struct PrecisionMatrixBuilderBase {
  virtual ~PrecisionMatrixBuilderBase() {}

  /**
   * @brief Assemble and return the precision matrix Q as an Eigen sparse matrix.
   *
   * @details Intended for direct use with TMB's density::GMRF(Q).
   */
  virtual Eigen::SparseMatrix<Type> BuildPrecisionMatrixSparse() const = 0;
};

/**
 * @brief DSEM precision-matrix builder based on a RAM specification.
 *
 * @details
 * Assembles:
 *   Q = (I - Rho)' * V^{-1} * (I - Rho)
 * with:
 *   V = Gamma' * Gamma
 *
 * This follows the sparse-building pattern used in Rceattle's DSEM implementation:
 * - Build Rho and Gamma as sparse
 * - Compute V as sparse
 * - Invert V using tmbutils::invertSparseMatrix (dense result)
 * - Convert dense inverse back to sparse via tmbutils::asSparseMatrix
 * - Assemble Q sparsely
 */
template <typename Type>
struct DSEMPrecisionMatrixBuilder : public PrecisionMatrixBuilderBase<Type> {
  size_t n_time = 0;
  size_t n_variables = 0;

  fims::Vector<int> ram_type;
  fims::Vector<int> ram_from;
  fims::Vector<int> ram_to;
  fims::Vector<int> ram_beta_index;
  fims::Vector<Type> ram_start;
  fims::Vector<Type> beta_z;

  DSEMPrecisionMatrixBuilder() : PrecisionMatrixBuilderBase<Type>() {}
  virtual ~DSEMPrecisionMatrixBuilder() {}

  virtual Eigen::SparseMatrix<Type> BuildPrecisionMatrixSparse() const override {
    const size_t n_k = this->n_time * this->n_variables;
    if (n_k == 0) {
      throw std::invalid_argument(
          "DSEMPrecisionMatrixBuilder: n_time and n_variables must both be > 0.");
    }

    const size_t n_rows = this->ram_type.size();
    if (this->ram_from.size() != n_rows || this->ram_to.size() != n_rows ||
        this->ram_beta_index.size() != n_rows ||
        this->ram_start.size() != n_rows) {
      throw std::invalid_argument(
          "DSEMPrecisionMatrixBuilder: RAM vectors must have equal lengths.");
    }

    Eigen::SparseMatrix<Type> Rho_kk(static_cast<int>(n_k), static_cast<int>(n_k));
    Eigen::SparseMatrix<Type> Gamma_kk(static_cast<int>(n_k), static_cast<int>(n_k));
    Eigen::SparseMatrix<Type> I_kk(static_cast<int>(n_k), static_cast<int>(n_k));
    Rho_kk.setZero();
    Gamma_kk.setZero();
    I_kk.setIdentity();

    for (size_t r = 0; r < n_rows; ++r) {
      const int from = this->ram_from[r] - 1;
      const int to = this->ram_to[r] - 1;
      if (from < 0 || to < 0 || static_cast<size_t>(from) >= n_k ||
          static_cast<size_t>(to) >= n_k) {
        throw std::invalid_argument(
            "DSEMPrecisionMatrixBuilder: RAM indices are out of bounds.");
      }

      Type value = this->ram_start[r];
      if (this->ram_beta_index[r] >= 1) {
        const size_t beta_idx = static_cast<size_t>(this->ram_beta_index[r] - 1);
        if (beta_idx >= this->beta_z.size()) {
          throw std::invalid_argument(
              "DSEMPrecisionMatrixBuilder: ram_beta_index points past beta_z.");
        }
        value = this->beta_z[beta_idx];
      }

      if (this->ram_type[r] == 1) {
        Rho_kk.coeffRef(from, to) = value;
      } else if (this->ram_type[r] == 2) {
        Gamma_kk.coeffRef(from, to) = value;
      }
    }

    Eigen::SparseMatrix<Type> IminusRho_kk = I_kk - Rho_kk;
    Eigen::SparseMatrix<Type> V_kk = Gamma_kk.transpose() * Gamma_kk;

    // invertSparseMatrix returns dense matrix<Type>
    matrix<Type> Vinv_dense = tmbutils::invertSparseMatrix(V_kk);

    // Convert dense inverse back to sparse using structural-zero detection
    Eigen::SparseMatrix<Type> Vinv_sparse = tmbutils::asSparseMatrix(Vinv_dense);

    Eigen::SparseMatrix<Type> Q_kk =
        IminusRho_kk.transpose() * Vinv_sparse * IminusRho_kk;

    return Q_kk;
  }
};

}  // namespace fims_distributions

#endif
