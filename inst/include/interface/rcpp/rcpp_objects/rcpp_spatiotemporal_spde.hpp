/**
 * @file rcpp_spatiotemporal_spde.hpp
 * @brief Rcpp interface for the spatio-temporal SPDE lognormal distribution.
 * Allows the distribution to be created and configured from R via
 * `methods::new(SpatiotemporalSPDE)`.
 *
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef FIMS_INTERFACE_RCPP_RCPP_OBJECTS_RCPP_SPATIOTEMPORAL_SPDE_HPP
#define FIMS_INTERFACE_RCPP_RCPP_OBJECTS_RCPP_SPATIOTEMPORAL_SPDE_HPP

#include "../../../distributions/functors/spatiotemporal_spde_lognormal_lpdf.hpp"
#include "../../interface.hpp"
#include "rcpp_interface_base.hpp"

/**
 * @brief Rcpp interface for the spatio-temporal SPDE lognormal distribution.
 *
 * Exposes all fields needed to configure the distribution from R:
 *   - SPDE mesh matrices (C0, C1, C2) as 0-based sparse triplets.
 *   - Projection matrix A as 0-based sparse triplets.
 *   - Observations (y_obs) and their year indices (obs_year_idx).
 *   - Fixed-effect parameters: beta0, rho_logit, log_kappa, log_tau,
 *     log_sigma_obs.
 *   - Random-effect latent field: omega (n_nodes * n_years).
 *
 * Usage from R:
 * ```r
 * spde <- methods::new(SpatiotemporalSPDE)
 * spde$n_nodes <- 10L
 * spde$n_years <- 5L
 * spde$C0_i <- ...   # 0-based row indices
 * # ... (set all triplet fields and parameters)
 * spde$omega$resize(10 * 5)
 * for (i in 1:50) { spde$omega[i]$estimation_type <- "random_effects" }
 * spde$beta0[1]$estimation_type <- "fixed_effects"
 * # ... set all estimation types
 * CreateTMBModel()
 * ```
 */
class SpatiotemporalSPDEInterface : public DistributionsInterfaceBase {
 public:
  // ------------------------------------------------------------------
  // Dimension fields (SharedInt so copies share state with original)
  // ------------------------------------------------------------------
  /** @brief Number of mesh nodes. */
  SharedInt n_nodes;
  /** @brief Number of years. */
  SharedInt n_years;

  // ------------------------------------------------------------------
  // SPDE matrix triplets (0-based indices, R NumericVectors are
  // reference-counted so copies share underlying data)
  // ------------------------------------------------------------------
  /** @brief Row indices for C0 (mass matrix) sparse triplets. */
  Rcpp::NumericVector C0_i;
  /** @brief Column indices for C0 sparse triplets. */
  Rcpp::NumericVector C0_j;
  /** @brief Non-zero values of C0. */
  Rcpp::NumericVector C0_v;

  /** @brief Row indices for C1 (mixed stiffness) sparse triplets. */
  Rcpp::NumericVector C1_i;
  /** @brief Column indices for C1 sparse triplets. */
  Rcpp::NumericVector C1_j;
  /** @brief Non-zero values of C1. */
  Rcpp::NumericVector C1_v;

  /** @brief Row indices for C2 (stiffness) sparse triplets. */
  Rcpp::NumericVector C2_i;
  /** @brief Column indices for C2 sparse triplets. */
  Rcpp::NumericVector C2_j;
  /** @brief Non-zero values of C2. */
  Rcpp::NumericVector C2_v;

  // ------------------------------------------------------------------
  // Projection matrix A triplets (0-based; rows=observations,
  // cols=nodes)
  // ------------------------------------------------------------------
  /** @brief Row indices (observation index) for A sparse triplets. */
  Rcpp::NumericVector A_i;
  /** @brief Column indices (node index) for A sparse triplets. */
  Rcpp::NumericVector A_j;
  /** @brief Non-zero values of A (weights). */
  Rcpp::NumericVector A_v;

  // ------------------------------------------------------------------
  // Observations
  // ------------------------------------------------------------------
  /** @brief Positive observed values; length = total number of observations. */
  Rcpp::NumericVector y_obs;
  /** @brief 0-based year index for each observation. */
  Rcpp::NumericVector obs_year_idx;

  // ------------------------------------------------------------------
  // Fixed-effect parameters (ParameterVector uses shared_ptr storage)
  // ------------------------------------------------------------------
  /** @brief Intercept on the log scale (scalar, 1 element). */
  ParameterVector beta0;
  /** @brief AR1 correlation in logit scale; rho = tanh(rho_logit). */
  ParameterVector rho_logit;
  /** @brief Log SPDE range parameter; kappa = exp(log_kappa). */
  ParameterVector log_kappa;
  /** @brief Log SPDE variance parameter; tau = exp(log_tau). */
  ParameterVector log_tau;
  /** @brief Log observation standard deviation. */
  ParameterVector log_sigma_obs;

  // ------------------------------------------------------------------
  // Random effects
  // ------------------------------------------------------------------
  /** @brief Latent field omega; resize to n_nodes * n_years elements and set
   * estimation_type = "random_effects". */
  ParameterVector omega;

  // ------------------------------------------------------------------
  // Output (populated by finalize())
  // ------------------------------------------------------------------
  /** @brief Total log-density value after model run. */
  double lpdf_value = 0.0;
  /** @brief Per-observation log-density values. */
  RealVector report_lpdf_vec;

  // ------------------------------------------------------------------
  // Constructor / destructor
  // ------------------------------------------------------------------

  /** @brief Constructor: registers this object in fims_interface_objects. */
  SpatiotemporalSPDEInterface() : DistributionsInterfaceBase() {
    DistributionsInterfaceBase::live_objects[this->id_m] =
        std::make_shared<SpatiotemporalSPDEInterface>(*this);
    FIMSRcppInterfaceBase::fims_interface_objects.push_back(
        DistributionsInterfaceBase::live_objects[this->id_m]);
  }

  /** @brief Copy constructor (shares mutable state via shared_ptr fields). */
  SpatiotemporalSPDEInterface(const SpatiotemporalSPDEInterface &other)
      : DistributionsInterfaceBase(other),
        n_nodes(other.n_nodes),
        n_years(other.n_years),
        C0_i(other.C0_i),
        C0_j(other.C0_j),
        C0_v(other.C0_v),
        C1_i(other.C1_i),
        C1_j(other.C1_j),
        C1_v(other.C1_v),
        C2_i(other.C2_i),
        C2_j(other.C2_j),
        C2_v(other.C2_v),
        A_i(other.A_i),
        A_j(other.A_j),
        A_v(other.A_v),
        y_obs(other.y_obs),
        obs_year_idx(other.obs_year_idx),
        beta0(other.beta0),
        rho_logit(other.rho_logit),
        log_kappa(other.log_kappa),
        log_tau(other.log_tau),
        log_sigma_obs(other.log_sigma_obs),
        omega(other.omega),
        lpdf_value(other.lpdf_value),
        report_lpdf_vec(other.report_lpdf_vec) {}

  /** @brief Destructor. */
  virtual ~SpatiotemporalSPDEInterface() {}

  // ------------------------------------------------------------------
  // Required virtual interface methods
  // ------------------------------------------------------------------

  /** @brief Returns the unique ID of this distribution interface. */
  virtual uint32_t get_id() { return this->id_m; }

  /**
   * @brief Not used for this distribution (triplets and omega are set
   * directly). Provided for interface compliance.
   */
  virtual bool set_distribution_links(std::string input_type,
                                      Rcpp::IntegerVector ids) {
    this->input_type_m.set(input_type);
    return true;
  }

  /**
   * @brief Evaluate the distribution using double arithmetic (no TMB).
   *
   * Returns 0.0 when compiled without TMB_MODEL (test smoke-check only).
   * Use CreateTMBModel + TMB::MakeADFun for a proper NLL evaluation.
   */
  virtual double evaluate() {
    fims_distributions::SpatiotemporalSPDELognormal<double> dist;
    dist.n_nodes = this->n_nodes.get();
    dist.n_years = this->n_years.get();

    // Triplets: C0
    for (R_xlen_t k = 0; k < this->C0_i.size(); k++) {
      dist.C0_i.push_back(static_cast<int>(this->C0_i[k]));
      dist.C0_j.push_back(static_cast<int>(this->C0_j[k]));
      dist.C0_v.push_back(static_cast<double>(this->C0_v[k]));
    }

    // Triplets: C1
    for (R_xlen_t k = 0; k < this->C1_i.size(); k++) {
      dist.C1_i.push_back(static_cast<int>(this->C1_i[k]));
      dist.C1_j.push_back(static_cast<int>(this->C1_j[k]));
      dist.C1_v.push_back(static_cast<double>(this->C1_v[k]));
    }

    // Triplets: C2
    for (R_xlen_t k = 0; k < this->C2_i.size(); k++) {
      dist.C2_i.push_back(static_cast<int>(this->C2_i[k]));
      dist.C2_j.push_back(static_cast<int>(this->C2_j[k]));
      dist.C2_v.push_back(static_cast<double>(this->C2_v[k]));
    }

    // Triplets: A
    for (R_xlen_t k = 0; k < this->A_i.size(); k++) {
      dist.A_i.push_back(static_cast<int>(this->A_i[k]));
      dist.A_j.push_back(static_cast<int>(this->A_j[k]));
      dist.A_v.push_back(static_cast<double>(this->A_v[k]));
    }

    // Observations
    for (R_xlen_t k = 0; k < this->y_obs.size(); k++) {
      dist.y_obs.push_back(static_cast<double>(this->y_obs[k]));
      dist.obs_year_idx.push_back(static_cast<int>(this->obs_year_idx[k]));
    }

    size_t n_omega = this->omega.size();
    dist.omega.resize(n_omega);
    for (size_t k = 0; k < n_omega; k++) {
      dist.omega[k] = this->omega[k].initial_value_m;
    }

    dist.beta0 = this->beta0[0].initial_value_m;
    dist.rho_logit = this->rho_logit[0].initial_value_m;
    dist.log_kappa = this->log_kappa[0].initial_value_m;
    dist.log_tau = this->log_tau[0].initial_value_m;
    dist.log_sigma_obs = this->log_sigma_obs[0].initial_value_m;

    return dist.evaluate();
  }

  /**
   * @brief Extract results from Information back to this Rcpp object.
   */
  virtual void finalize() {
    if (this->finalized) {
      FIMS_WARNING_LOG("SpatiotemporalSPDE " + fims::to_string(this->id_m) +
                       " has been finalized already.");
    }
    this->finalized = true;

    std::shared_ptr<fims_info::Information<double>> info =
        fims_info::Information<double>::GetInstance();

    fims_info::Information<double>::density_components_iterator it =
        info->density_components.find(this->id_m);

    if (it == info->density_components.end()) {
      FIMS_WARNING_LOG("SpatiotemporalSPDE " + fims::to_string(this->id_m) +
                       " not found in Information.");
      return;
    }

    std::shared_ptr<fims_distributions::SpatiotemporalSPDELognormal<double>>
        dist = std::dynamic_pointer_cast<
            fims_distributions::SpatiotemporalSPDELognormal<double>>(
            it->second);

    if (dist == nullptr) {
      FIMS_WARNING_LOG("SpatiotemporalSPDE " + fims::to_string(this->id_m) +
                       " dynamic_pointer_cast failed.");
      return;
    }

    this->lpdf_value = dist->lpdf;

    size_t n_obs = dist->report_lpdf_vec.size();
    this->report_lpdf_vec = RealVector(n_obs);
    for (size_t i = 0; i < n_obs; i++) {
      this->report_lpdf_vec[static_cast<R_xlen_t>(i)] =
          dist->report_lpdf_vec[i];
    }

    // Update omega final values
    size_t n_omega = dist->omega.size();
    if (this->omega.size() != n_omega) {
      this->omega.resize(n_omega);
    }
    for (size_t k = 0; k < n_omega; k++) {
      this->omega[k].final_value_m = dist->omega[k];
    }

    // Update fixed-effect final values
    this->beta0[0].final_value_m = dist->beta0;
    this->rho_logit[0].final_value_m = dist->rho_logit;
    this->log_kappa[0].final_value_m = dist->log_kappa;
    this->log_tau[0].final_value_m = dist->log_tau;
    this->log_sigma_obs[0].final_value_m = dist->log_sigma_obs;
  }

  /**
   * @brief Converts this distribution's state to a JSON string.
   */
  virtual std::string to_json() {
    std::stringstream ss;
    ss << "{\n";
    ss << " \"module_name\": \"density\",\n";
    ss << " \"module_id\": " << this->id_m << ",\n";
    ss << " \"module_type\": \"spatiotemporal_spde_lognormal\",\n";
    ss << " \"input_type\": \"spatiotemporal\",\n";
    ss << " \"density_component\": {\n";
    ss << "  \"lpdf_value\": " << this->lpdf_value << ",\n";
    ss << "  \"n_nodes\": " << this->n_nodes.get() << ",\n";
    ss << "  \"n_years\": " << this->n_years.get() << "\n";
    ss << " }\n}\n";
    return ss.str();
  }

#ifdef TMB_MODEL
  /**
   * @brief Registers all parameters, random effects, and data in
   * Information<Type>, then adds the distribution to
   * Information<Type>::density_components.
   */
  template <typename Type>
  bool add_to_fims_tmb_internal() {
    std::shared_ptr<fims_info::Information<Type>> info =
        fims_info::Information<Type>::GetInstance();

    std::shared_ptr<fims_distributions::SpatiotemporalSPDELognormal<Type>>
        distribution = std::make_shared<
            fims_distributions::SpatiotemporalSPDELognormal<Type>>();

    distribution->id = this->id_m;
    distribution->input_type = "spatiotemporal";

    int nn = this->n_nodes.get();
    int ny = this->n_years.get();
    distribution->n_nodes = nn;
    distribution->n_years = ny;

    // --- SPDE triplets ---
    // C0
    distribution->C0_i.reserve(this->C0_i.size());
    distribution->C0_j.reserve(this->C0_j.size());
    distribution->C0_v.reserve(this->C0_v.size());
    for (R_xlen_t k = 0; k < this->C0_i.size(); k++) {
      distribution->C0_i.push_back(static_cast<int>(this->C0_i[k]));
      distribution->C0_j.push_back(static_cast<int>(this->C0_j[k]));
      distribution->C0_v.push_back(static_cast<double>(this->C0_v[k]));
    }
    // C1
    distribution->C1_i.reserve(this->C1_i.size());
    distribution->C1_j.reserve(this->C1_j.size());
    distribution->C1_v.reserve(this->C1_v.size());
    for (R_xlen_t k = 0; k < this->C1_i.size(); k++) {
      distribution->C1_i.push_back(static_cast<int>(this->C1_i[k]));
      distribution->C1_j.push_back(static_cast<int>(this->C1_j[k]));
      distribution->C1_v.push_back(static_cast<double>(this->C1_v[k]));
    }
    // C2
    distribution->C2_i.reserve(this->C2_i.size());
    distribution->C2_j.reserve(this->C2_j.size());
    distribution->C2_v.reserve(this->C2_v.size());
    for (R_xlen_t k = 0; k < this->C2_i.size(); k++) {
      distribution->C2_i.push_back(static_cast<int>(this->C2_i[k]));
      distribution->C2_j.push_back(static_cast<int>(this->C2_j[k]));
      distribution->C2_v.push_back(static_cast<double>(this->C2_v[k]));
    }

    // --- Projection matrix A triplets ---
    distribution->A_i.reserve(this->A_i.size());
    distribution->A_j.reserve(this->A_j.size());
    distribution->A_v.reserve(this->A_v.size());
    for (R_xlen_t k = 0; k < this->A_i.size(); k++) {
      distribution->A_i.push_back(static_cast<int>(this->A_i[k]));
      distribution->A_j.push_back(static_cast<int>(this->A_j[k]));
      distribution->A_v.push_back(static_cast<double>(this->A_v[k]));
    }

    // --- Observations ---
    size_t n_obs = static_cast<size_t>(this->y_obs.size());
    distribution->y_obs.reserve(n_obs);
    distribution->obs_year_idx.reserve(n_obs);
    for (size_t k = 0; k < n_obs; k++) {
      distribution->y_obs.push_back(
          static_cast<double>(this->y_obs[static_cast<R_xlen_t>(k)]));
      distribution->obs_year_idx.push_back(
          static_cast<int>(this->obs_year_idx[static_cast<R_xlen_t>(k)]));
    }

    // --- Random effects: omega ---
    size_t n_omega = static_cast<size_t>(nn * ny);
    distribution->omega.resize(n_omega);
    std::stringstream ss;
    for (size_t k = 0; k < n_omega; k++) {
      if (k < this->omega.size()) {
        distribution->omega[k] =
            static_cast<Type>(this->omega[k].initial_value_m);
      } else {
        distribution->omega[k] = static_cast<Type>(0.0);
      }
      ss.str("");
      ss << "spde." << this->id_m << ".omega." << k;
      info->RegisterRandomEffectName(ss.str());
      info->RegisterRandomEffect(distribution->omega[k]);
    }

    // --- Fixed effects ---
    // beta0
    distribution->beta0 = static_cast<Type>(this->beta0[0].initial_value_m);
    if (this->beta0[0].estimation_type_m.get() == "fixed_effects") {
      ss.str("");
      ss << "spde." << this->id_m << ".beta0";
      info->RegisterParameterName(ss.str());
      info->RegisterParameter(distribution->beta0);
    }

    // rho_logit
    distribution->rho_logit =
        static_cast<Type>(this->rho_logit[0].initial_value_m);
    if (this->rho_logit[0].estimation_type_m.get() == "fixed_effects") {
      ss.str("");
      ss << "spde." << this->id_m << ".rho_logit";
      info->RegisterParameterName(ss.str());
      info->RegisterParameter(distribution->rho_logit);
    }

    // log_kappa
    distribution->log_kappa =
        static_cast<Type>(this->log_kappa[0].initial_value_m);
    if (this->log_kappa[0].estimation_type_m.get() == "fixed_effects") {
      ss.str("");
      ss << "spde." << this->id_m << ".log_kappa";
      info->RegisterParameterName(ss.str());
      info->RegisterParameter(distribution->log_kappa);
    }

    // log_tau
    distribution->log_tau = static_cast<Type>(this->log_tau[0].initial_value_m);
    if (this->log_tau[0].estimation_type_m.get() == "fixed_effects") {
      ss.str("");
      ss << "spde." << this->id_m << ".log_tau";
      info->RegisterParameterName(ss.str());
      info->RegisterParameter(distribution->log_tau);
    }

    // log_sigma_obs
    distribution->log_sigma_obs =
        static_cast<Type>(this->log_sigma_obs[0].initial_value_m);
    if (this->log_sigma_obs[0].estimation_type_m.get() == "fixed_effects") {
      ss.str("");
      ss << "spde." << this->id_m << ".log_sigma_obs";
      info->RegisterParameterName(ss.str());
      info->RegisterParameter(distribution->log_sigma_obs);
    }

    info->density_components[distribution->id] = distribution;
    return true;
  }
#endif  // TMB_MODEL

  /** @brief Calls add_to_fims_tmb_internal for all required numeric types. */
  virtual bool add_to_fims_tmb() {
#ifdef TMB_MODEL
#ifdef TMBAD_FRAMEWORK
    this->add_to_fims_tmb_internal<TMB_FIMS_REAL_TYPE>();
    this->add_to_fims_tmb_internal<TMBAD_FIMS_TYPE>();
#else
    this->add_to_fims_tmb_internal<TMB_FIMS_REAL_TYPE>();
    this->add_to_fims_tmb_internal<TMB_FIMS_FIRST_ORDER>();
    this->add_to_fims_tmb_internal<TMB_FIMS_SECOND_ORDER>();
    this->add_to_fims_tmb_internal<TMB_FIMS_THIRD_ORDER>();
#endif
#endif  // TMB_MODEL
    return true;
  }
};

#endif /* FIMS_INTERFACE_RCPP_RCPP_OBJECTS_RCPP_SPATIOTEMPORAL_SPDE_HPP */
