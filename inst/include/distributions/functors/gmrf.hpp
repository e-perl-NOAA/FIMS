/**
 * @file gmrf.hpp
 * @brief Implements the GMRF distribution functor used by FIMS for random
 * effects with a sparse precision matrix (TMB-only).
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */

#ifndef GMRF_HPP
#define GMRF_HPP

#include "density_components_base.hpp"
#include "precision_matrix_builder.hpp"
#include "../../common/def.hpp"

namespace fims_distributions {

/**
 * @brief Gaussian Markov Random Field (GMRF) density component (TMB-only).
 *
 * @details
 * Requires a precision-matrix builder that returns a sparse precision matrix Q.
 * Evaluates TMB's density::GMRF(Q) using centered values (observed - expected).
 */
template <typename Type>
struct GMRF : public DensityComponentBase<Type> {
  /**
   * @brief Provider that builds the sparse precision matrix Q.
   *
   * @details Required.
   */
  std::shared_ptr<PrecisionMatrixBuilderBase<Type>> precision_matrix_builder =
      nullptr;

  /** @brief Constructor. */
  GMRF() : DensityComponentBase<Type>() {}

  /** @brief Destructor. */
  virtual ~GMRF() {}

  /**
   * @brief Evaluates the GMRF log density.
   */
  virtual const Type evaluate() {
    const size_t n_x = this->get_n_x();

    this->lpdf_vec.resize(1);
    this->lpdf_vec[0] = static_cast<Type>(0);
    this->lpdf = static_cast<Type>(0);

    if (this->precision_matrix_builder == nullptr) {
      throw std::invalid_argument(
          "GMRF (TMB_MODEL): precision_matrix_builder must be set before evaluate().");
    }

    // Centered values (x - mu)
    vector<Type> centered_values(static_cast<int>(n_x));
    for (size_t i = 0; i < n_x; ++i) {
      centered_values(static_cast<int>(i)) =
          this->get_observed(i) - this->get_expected(i);
    }

    // Build sparse precision matrix Q
    Eigen::SparseMatrix<Type> Q =
        this->precision_matrix_builder->BuildPrecisionMatrixSparse();

    // Sanity check dimensions
    if (static_cast<size_t>(Q.rows()) != n_x || static_cast<size_t>(Q.cols()) != n_x) {
      throw std::invalid_argument(
          "GMRF (TMB_MODEL): precision matrix dimension mismatch. "
          "Got Q of size " + fims::to_string(static_cast<size_t>(Q.rows())) +
          " x " + fims::to_string(static_cast<size_t>(Q.cols())) +
          " but expected " + fims::to_string(n_x) + " x " + fims::to_string(n_x) + ".");
    }

    // Evaluate TMB GMRF
    this->lpdf = density::GMRF(Q)(centered_values);

    this->lpdf_vec[0] = this->lpdf;
    return this->lpdf;
  }
};

}  // namespace fims_distributions

#endif
