/**
 * @file precision_matrix_builder.hpp
 * @brief Declares helpers that assemble precision matrices for multivariate
 * random-effects models.
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef PRECISION_MATRIX_BUILDER_HPP
#define PRECISION_MATRIX_BUILDER_HPP

#include "density_components_base.hpp"
#include "../../common/def.hpp"

namespace fims_distributions {

/**
 * @brief Base class for objects that assemble a flattened precision matrix.
 *
 * @tparam Type Numeric type (double or TMB type).
 */
template <typename Type>
struct PrecisionMatrixBuilderBase {
  /** @brief Destructor. */
  virtual ~PrecisionMatrixBuilderBase() {}

  /**
   * @brief Assemble and return a flattened row-major precision matrix.
   */
  virtual fims::Vector<Type> BuildPrecisionMatrix() const = 0;
};

/**
 * @brief DSEM precision-matrix builder based on a RAM specification.
 *
 * @details This class only assembles the precision matrix (`Q`) and does not
 * evaluate a GMRF log density. That allows GMRF to consume a precomputed
 * precision matrix from DSEM (or other future builders).
 */
template <typename Type>
struct DSEMPrecisionMatrixBuilder : public PrecisionMatrixBuilderBase<Type> {
  /** @brief Number of time steps (`n_t`). */
  size_t n_time = 0;
  /** @brief Number of variables (`n_j`). */
  size_t n_variables = 0;

  /**
   * @brief RAM path type for each row.
   * 1 = rho path, 2 = gamma path.
   */
  fims::Vector<int> ram_type;
  /** @brief RAM source index (1-based in RAM input). */
  fims::Vector<int> ram_from;
  /** @brief RAM destination index (1-based in RAM input). */
  fims::Vector<int> ram_to;
  /**
   * @brief RAM beta index for estimated parameters.
   * If >= 1, uses `beta_z[ram_beta_index - 1]`; otherwise uses `ram_start`.
   */
  fims::Vector<int> ram_beta_index;
  /** @brief RAM fixed/start values. */
  fims::Vector<Type> ram_start;
  /** @brief Estimated RAM coefficients. */
  fims::Vector<Type> beta_z;

  /** @brief Constructor. */
  DSEMPrecisionMatrixBuilder() : PrecisionMatrixBuilderBase<Type>() {}

  /** @brief Destructor. */
  virtual ~DSEMPrecisionMatrixBuilder() {}

  /**
   * @brief Assemble `Q = (I-Rho)' * V^{-1} * (I-Rho)` with `V = Gamma' * Gamma`.
   */
  virtual fims::Vector<Type> BuildPrecisionMatrix() const {
    const size_t n_k = this->n_time * this->n_variables;
    if (n_k == 0) {
      throw std::invalid_argument(
          "DSEMPrecisionMatrixBuilder: n_time and n_variables must both be > 0.");
    }

    const size_t n_rows = this->ram_type.size();
    if (this->ram_from.size() != n_rows || this->ram_to.size() != n_rows ||
        this->ram_beta_index.size() != n_rows || this->ram_start.size() != n_rows) {
      throw std::invalid_argument(
          "DSEMPrecisionMatrixBuilder: RAM vectors must have equal lengths.");
    }

    fims::Vector<Type> rho(n_k * n_k, static_cast<Type>(0));
    fims::Vector<Type> gamma(n_k * n_k, static_cast<Type>(0));
    fims::Vector<Type> i_minus_rho(n_k * n_k, static_cast<Type>(0));

    for (size_t i = 0; i < n_k; ++i) {
      i_minus_rho[i * n_k + i] = static_cast<Type>(1);
    }

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
        rho[static_cast<size_t>(from) * n_k + static_cast<size_t>(to)] = value;
      } else if (this->ram_type[r] == 2) {
        gamma[static_cast<size_t>(from) * n_k + static_cast<size_t>(to)] = value;
      }
    }

    for (size_t i = 0; i < n_k; ++i) {
      for (size_t j = 0; j < n_k; ++j) {
        i_minus_rho[i * n_k + j] -= rho[i * n_k + j];
      }
    }

    fims::Vector<Type> gamma_t_gamma(n_k * n_k, static_cast<Type>(0));
    for (size_t i = 0; i < n_k; ++i) {
      for (size_t j = 0; j < n_k; ++j) {
        Type value = static_cast<Type>(0);
        for (size_t k = 0; k < n_k; ++k) {
          value += gamma[k * n_k + i] * gamma[k * n_k + j];
        }
        gamma_t_gamma[i * n_k + j] = value;
      }
    }

    fims::Vector<Type> v_inv = this->InvertDense(gamma_t_gamma, n_k);
    fims::Vector<Type> temp = this->DenseMatMul(v_inv, i_minus_rho, n_k);
    fims::Vector<Type> q = this->DenseMatMul(this->Transpose(i_minus_rho, n_k), temp, n_k);
    return q;
  }

 private:
  /**
   * @brief Dense matrix multiplication for row-major square matrices.
   */
  fims::Vector<Type> DenseMatMul(const fims::Vector<Type>& a,
                                 const fims::Vector<Type>& b,
                                 const size_t n) const {
    fims::Vector<Type> out(n * n, static_cast<Type>(0));
    for (size_t i = 0; i < n; ++i) {
      for (size_t j = 0; j < n; ++j) {
        Type value = static_cast<Type>(0);
        for (size_t k = 0; k < n; ++k) {
          value += a[i * n + k] * b[k * n + j];
        }
        out[i * n + j] = value;
      }
    }
    return out;
  }

  /**
   * @brief Dense matrix transpose for row-major square matrices.
   */
  fims::Vector<Type> Transpose(const fims::Vector<Type>& a, const size_t n) const {
    fims::Vector<Type> out(n * n, static_cast<Type>(0));
    for (size_t i = 0; i < n; ++i) {
      for (size_t j = 0; j < n; ++j) {
        out[j * n + i] = a[i * n + j];
      }
    }
    return out;
  }

  /**
   * @brief Invert dense row-major square matrix with Gauss-Jordan elimination.
   */
  fims::Vector<Type> InvertDense(const fims::Vector<Type>& a, const size_t n) const {
    fims::Vector<Type> aug(n * 2 * n, static_cast<Type>(0));

    for (size_t i = 0; i < n; ++i) {
      for (size_t j = 0; j < n; ++j) {
        aug[i * (2 * n) + j] = a[i * n + j];
      }
      aug[i * (2 * n) + (n + i)] = static_cast<Type>(1);
    }

    for (size_t col = 0; col < n; ++col) {
      size_t pivot = col;
      Type max_abs = fims_math::abs(aug[pivot * (2 * n) + col]);
      for (size_t row = col + 1; row < n; ++row) {
        const Type cand = fims_math::abs(aug[row * (2 * n) + col]);
        if (cand > max_abs) {
          max_abs = cand;
          pivot = row;
        }
      }
      if (max_abs == static_cast<Type>(0)) {
        throw std::invalid_argument(
            "DSEMPrecisionMatrixBuilder: matrix inversion failed (singular matrix).");
      }

      if (pivot != col) {
        for (size_t j = 0; j < 2 * n; ++j) {
          std::swap(aug[col * (2 * n) + j], aug[pivot * (2 * n) + j]);
        }
      }

      const Type pivot_val = aug[col * (2 * n) + col];
      for (size_t j = 0; j < 2 * n; ++j) {
        aug[col * (2 * n) + j] /= pivot_val;
      }

      for (size_t row = 0; row < n; ++row) {
        if (row == col) continue;
        const Type factor = aug[row * (2 * n) + col];
        for (size_t j = 0; j < 2 * n; ++j) {
          aug[row * (2 * n) + j] -= factor * aug[col * (2 * n) + j];
        }
      }
    }

    fims::Vector<Type> inv(n * n, static_cast<Type>(0));
    for (size_t i = 0; i < n; ++i) {
      for (size_t j = 0; j < n; ++j) {
        inv[i * n + j] = aug[i * (2 * n) + (n + j)];
      }
    }
    return inv;
  }
};

}  // namespace fims_distributions

#endif
