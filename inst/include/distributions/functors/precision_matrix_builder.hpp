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

#ifdef TMB_MODEL
#include <Eigen/Sparse>
#else
// Forward declaration keeps non-TMB builds from requiring Eigen/TMB headers
// while still allowing this template interface to compile.
namespace Eigen {
template <typename Scalar, int Options = 0, typename StorageIndex = int>
class SparseMatrix;
}  // namespace Eigen
#endif

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
 * - Invert V via a dense inverse helper
 * - Convert dense inverse back to sparse
 * - Assemble Q sparsely
 */
template <typename Type>
struct DSEMPrecisionMatrixBuilder : public PrecisionMatrixBuilderBase<Type> {
  /**
   * @brief One RAM path entry used to assemble Rho/Gamma.
   * @details
   * type: 1 = Rho path, 2 = Gamma path
   * from/to: 1-based indices into the expanded state vector
   * beta_index: 1-based index into beta_z; 0 means use start
   * start: default/fixed value when beta_index == 0
   */
  struct RAMPath {
    int type = 0;
    int from = 0;
    int to = 0;
    int beta_index = 0;
    Type start = Type(0);
  };

  size_t n_time = 0;
  size_t n_variables = 0;

  std::vector<RAMPath> paths;
  fims::Vector<Type> beta_z;

  DSEMPrecisionMatrixBuilder() : PrecisionMatrixBuilderBase<Type>() {}
  virtual ~DSEMPrecisionMatrixBuilder() {}

  virtual Eigen::SparseMatrix<Type> BuildPrecisionMatrixSparse() const override {
#ifndef TMB_MODEL
    throw std::invalid_argument(
        "DSEMPrecisionMatrixBuilder::BuildPrecisionMatrixSparse() requires "
        "compilation with TMB_MODEL defined. Ensure TMB_MODEL is enabled or "
        "use a non-TMB precision-matrix builder.");
#else
    const size_t n_k = this->n_time * this->n_variables;
    if (n_k == 0) {
      throw std::invalid_argument(
          "DSEMPrecisionMatrixBuilder: n_time and n_variables must both be > 0.");
    }

    const size_t n_rows = this->paths.size();

    Eigen::SparseMatrix<Type> Rho_kk(static_cast<int>(n_k), static_cast<int>(n_k));
    Eigen::SparseMatrix<Type> Gamma_kk(static_cast<int>(n_k), static_cast<int>(n_k));
    Eigen::SparseMatrix<Type> I_kk(static_cast<int>(n_k), static_cast<int>(n_k));
    Rho_kk.setZero();
    Gamma_kk.setZero();
    I_kk.setIdentity();

    for (size_t r = 0; r < n_rows; ++r) {
      const int from = this->paths[r].from - 1;
      const int to = this->paths[r].to - 1;
      if (from < 0 || to < 0 || static_cast<size_t>(from) >= n_k ||
          static_cast<size_t>(to) >= n_k) {
        throw std::invalid_argument(
            "DSEMPrecisionMatrixBuilder: RAM indices are out of bounds.");
      }

      Type value = this->paths[r].start;
      if (this->paths[r].beta_index >= 1) {
        const size_t beta_idx = static_cast<size_t>(this->paths[r].beta_index - 1);
        if (beta_idx >= this->beta_z.size()) {
          throw std::invalid_argument(
              "DSEMPrecisionMatrixBuilder: ram_beta_index points past beta_z.");
        }
        value = this->beta_z[beta_idx];
      }

      if (this->paths[r].type == 1) {
        Rho_kk.coeffRef(from, to) = value;
      } else if (this->paths[r].type == 2) {
        Gamma_kk.coeffRef(from, to) = value;
      }
    }

    Eigen::SparseMatrix<Type> IminusRho_kk = I_kk - Rho_kk;
    Eigen::SparseMatrix<Type> V_kk = Gamma_kk.transpose() * Gamma_kk;

    Eigen::Matrix<Type, Eigen::Dynamic, Eigen::Dynamic> Vinv_dense =
        fims_math::invertSparseMatrix(V_kk);
    Eigen::SparseMatrix<Type> Vinv_sparse = fims_math::asSparseMatrix(Vinv_dense);

    Eigen::SparseMatrix<Type> Q_kk =
        IminusRho_kk.transpose() * Vinv_sparse * IminusRho_kk;

    return Q_kk;
#endif
  }
};

}  // namespace fims_distributions

#endif
