/**
 * @file gmrf.hpp
 * @brief Implements the GMRF distribution functor used by FIMS for random
 * effects with a precision matrix.
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */

#ifndef GMRF_HPP
#define GMRF_HPP

#include "density_components_base.hpp"
#include "../../common/def.hpp"

#ifdef TMB_MODEL
#include <Eigen/Sparse>
#endif

namespace fims_distributions {
/**
 * @copybrief gmrf.hpp
 *
 * @details This implementation uses [TMB's `density::GMRF()` utility](
 * https://kaskr.github.io/adcomp/classdensity_1_1GMRF__t.html) when compiled
 * with TMB (`TMB_MODEL`). The precision matrix is stored as a flattened,
 * row-major vector and expected to be linked during model setup.
 */
template <typename Type>
struct GMRF : public DensityComponentBase<Type> {
  /**
   * @brief Internal storage for the flattened precision matrix.
   */
  fims::Vector<Type> precision_matrix_values;

  /**
   * @brief Pointer to the flattened precision matrix (Q) in row-major order.
   */
  fims::Vector<Type>* precision_matrix_flat = NULL;

  /** @brief Constructor.
   */
  GMRF() : DensityComponentBase<Type>() {
    this->precision_matrix_flat = &(this->precision_matrix_values);
  }

  /** @brief Destructor.
   */
  virtual ~GMRF() {}

  /**
   * @brief Evaluates the GMRF log density.
   */
  virtual const Type evaluate() {
    size_t n_x = this->get_n_x();
    size_t n_expected = this->get_n_expected();
    this->lpdf_vec.resize(1);
    this->lpdf_vec[0] = static_cast<Type>(0);
    this->lpdf = static_cast<Type>(0);

    if (n_x != n_expected) {
      if (n_expected == 1) {
        n_expected = n_x;
      } else if (n_x > n_expected) {
        n_x = n_expected;
      }
    }

    if (this->precision_matrix_flat == NULL) {
      throw std::invalid_argument(
          "GMRF::precision_matrix_flat must be linked before evaluate().");
    }

    const size_t q_size = this->precision_matrix_flat->size();
    if (q_size != n_x * n_x) {
      throw std::invalid_argument(
          "GMRF precision matrix dimension mismatch. The precision matrix "
          "vector is of size " +
          fims::to_string(q_size) + " and expected " + fims::to_string(n_x) +
          " x " + fims::to_string(n_x) +
          ". Ensure the precision matrix matches the number of random "
          "effects.");
    }

#ifdef TMB_MODEL
    Eigen::SparseMatrix<Type> q(n_x, n_x);
    std::vector<Eigen::Triplet<Type>> q_triplets;
    q_triplets.reserve(q_size);
    vector<Type> centered_values(n_x);
    for (size_t i = 0; i < n_x; ++i) {
      centered_values(static_cast<int>(i)) =
          this->get_observed(i) - this->get_expected(i);
      for (size_t j = 0; j < n_x; ++j) {
        q_triplets.emplace_back(
            static_cast<int>(i), static_cast<int>(j),
            (*(this->precision_matrix_flat))[i * n_x + j]);
      }
    }
    q.setFromTriplets(q_triplets.begin(), q_triplets.end());
    this->lpdf = density::GMRF(q)(centered_values);
#else
    for (size_t i = 0; i < n_x; ++i) {
      const Type centered_i = this->get_observed(i) - this->get_expected(i);
      for (size_t j = 0; j < n_x; ++j) {
        const Type centered_j = this->get_observed(j) - this->get_expected(j);
        this->lpdf -= static_cast<Type>(0.5) * centered_i *
                      (*(this->precision_matrix_flat))[i * n_x + j] *
                      centered_j;
      }
    }
#endif
    this->lpdf_vec[0] = this->lpdf;
    return this->lpdf;
  }
};
}  // namespace fims_distributions

#endif
