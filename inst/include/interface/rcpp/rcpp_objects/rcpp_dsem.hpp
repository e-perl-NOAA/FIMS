/**
 * @file rcpp_dsem.hpp
 * @brief Rcpp interface for DSEM distribution module.
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef FIMS_INTERFACE_RCPP_RCPP_OBJECTS_RCPP_DSEM_HPP
#define FIMS_INTERFACE_RCPP_RCPP_OBJECTS_RCPP_DSEM_HPP

#include "rcpp_distribution.hpp"

/**
 * @brief Rcpp interface for DSEM likelihood.
 */
class DSEMDistributionInterface : public DistributionsInterfaceBase {
 public:
  RealVector options;
  RealVector RAM;
  SharedInt RAM_n_rows = 0;
  ParameterVector RAMstart;
  RealVector familycode_j;
  ParameterVector y_tj;
  SharedInt n_t = 0;
  SharedInt n_j = 0;

  ParameterVector beta_z;
  ParameterVector lnsigma_j;
  ParameterVector mu_j;
  ParameterVector delta0_j;
  ParameterVector x_tj;

  RealVector z_tj_report;
  SharedReal jnll_dsem = 0;
  SharedReal jnll_gmrf_dsem = 0;

  DSEMDistributionInterface() : DistributionsInterfaceBase() {
    DistributionsInterfaceBase::live_objects[this->id_m] =
        std::make_shared<DSEMDistributionInterface>(*this);
    FIMSRcppInterfaceBase::fims_interface_objects.push_back(
        DistributionsInterfaceBase::live_objects[this->id_m]);
  }

  DSEMDistributionInterface(const DSEMDistributionInterface &other)
      : DistributionsInterfaceBase(other),
        options(other.options),
        RAM(other.RAM),
        RAM_n_rows(other.RAM_n_rows),
        RAMstart(other.RAMstart),
        familycode_j(other.familycode_j),
        y_tj(other.y_tj),
        n_t(other.n_t),
        n_j(other.n_j),
        beta_z(other.beta_z),
        lnsigma_j(other.lnsigma_j),
        mu_j(other.mu_j),
        delta0_j(other.delta0_j),
        x_tj(other.x_tj),
        z_tj_report(other.z_tj_report),
        jnll_dsem(other.jnll_dsem),
        jnll_gmrf_dsem(other.jnll_gmrf_dsem) {}

  virtual ~DSEMDistributionInterface() {}

  virtual uint32_t get_id() { return this->id_m; }

  virtual double evaluate() {
    // This mirrors existing Rcpp distribution interfaces by creating a local
    // double-typed functor for interactive R-side evaluation.
    fims_distributions::DSEMLikelihood<double> dsem;
    dsem.options.resize(this->options.size());
    for (size_t i = 0; i < this->options.size(); i++) dsem.options[i] = this->options[i];
    dsem.RAM.resize(this->RAM.size());
    for (size_t i = 0; i < this->RAM.size(); i++) dsem.RAM[i] = this->RAM[i];
    dsem.RAM_n_rows = this->RAM_n_rows;
    dsem.RAMstart.resize(this->RAMstart.size());
    for (size_t i = 0; i < this->RAMstart.size(); i++) {
      dsem.RAMstart[i] = this->RAMstart[i].initial_value_m;
    }
    dsem.familycode_j.resize(this->familycode_j.size());
    for (size_t i = 0; i < this->familycode_j.size(); i++) {
      dsem.familycode_j[i] = this->familycode_j[i];
    }
    dsem.y_tj.resize(this->y_tj.size());
    for (size_t i = 0; i < this->y_tj.size(); i++) dsem.y_tj[i] = this->y_tj[i].initial_value_m;
    dsem.n_t = this->n_t;
    dsem.n_j = this->n_j;

    dsem.beta_z.resize(this->beta_z.size());
    for (size_t i = 0; i < this->beta_z.size(); i++) dsem.beta_z[i] = this->beta_z[i].initial_value_m;
    dsem.lnsigma_j.resize(this->lnsigma_j.size());
    for (size_t i = 0; i < this->lnsigma_j.size(); i++) dsem.lnsigma_j[i] = this->lnsigma_j[i].initial_value_m;
    dsem.mu_j.resize(this->mu_j.size());
    for (size_t i = 0; i < this->mu_j.size(); i++) dsem.mu_j[i] = this->mu_j[i].initial_value_m;
    dsem.delta0_j.resize(this->delta0_j.size());
    for (size_t i = 0; i < this->delta0_j.size(); i++) dsem.delta0_j[i] = this->delta0_j[i].initial_value_m;
    dsem.x_tj.resize(this->x_tj.size());
    for (size_t i = 0; i < this->x_tj.size(); i++) dsem.x_tj[i] = this->x_tj[i].initial_value_m;

    return dsem.evaluate();
  }

  virtual void finalize() {
    if (this->finalized) {
      FIMS_WARNING_LOG("DSEM distribution " + fims::to_string(this->id_m) +
                       " has been finalized already.");
    }
    this->finalized = true;
    std::shared_ptr<fims_info::Information<double>> info =
        fims_info::Information<double>::GetInstance();
    auto it = info->density_components.find(this->id_m);
    if (it == info->density_components.end()) {
      FIMS_WARNING_LOG("DSEM distribution " + fims::to_string(this->id_m) +
                       " not found in Information.");
      return;
    }
    std::shared_ptr<fims_distributions::DSEMLikelihood<double>> dsem =
        std::dynamic_pointer_cast<fims_distributions::DSEMLikelihood<double>>(
            it->second);
    this->jnll_dsem.set(dsem->jnll_dsem);
    this->jnll_gmrf_dsem.set(dsem->jnll_gmrf_dsem);
    this->z_tj_report.resize(dsem->z_tj_report.size());
    for (size_t i = 0; i < dsem->z_tj_report.size(); i++) {
      this->z_tj_report[i] = dsem->z_tj_report[i];
    }
  }

  virtual std::string to_json() {
    std::stringstream ss;
    ss << "{\n";
    ss << " \"module_name\": \"density\",\n";
    ss << " \"module_id\": " << this->id_m << ",\n";
    ss << " \"module_type\": \"dsem\",\n";
    ss << " \"density_component\": {\n";
    ss << "  \"jnll_dsem\": " << this->jnll_dsem << ",\n";
    ss << "  \"jnll_gmrf_dsem\": " << this->jnll_gmrf_dsem << "\n";
    ss << " }}\n";
    return ss.str();
  }

#ifdef TMB_MODEL
  template <typename Type>
  bool add_to_fims_tmb_internal() {
    std::shared_ptr<fims_info::Information<Type>> info =
        fims_info::Information<Type>::GetInstance();

    std::shared_ptr<fims_distributions::DSEMLikelihood<Type>> distribution =
        std::make_shared<fims_distributions::DSEMLikelihood<Type>>();
    std::stringstream ss;

    distribution->id = this->id_m;
    distribution->input_type = "data";
    distribution->options.resize(this->options.size());
    for (size_t i = 0; i < this->options.size(); i++) {
      distribution->options[i] = this->options[i];
    }
    distribution->RAM.resize(this->RAM.size());
    for (size_t i = 0; i < this->RAM.size(); i++) {
      distribution->RAM[i] = this->RAM[i];
    }
    distribution->RAM_n_rows = this->RAM_n_rows;
    distribution->RAMstart.resize(this->RAMstart.size());
    for (size_t i = 0; i < this->RAMstart.size(); i++) {
      distribution->RAMstart[i] = this->RAMstart[i].initial_value_m;
    }
    distribution->familycode_j.resize(this->familycode_j.size());
    for (size_t i = 0; i < this->familycode_j.size(); i++) {
      distribution->familycode_j[i] = this->familycode_j[i];
    }
    distribution->y_tj.resize(this->y_tj.size());
    for (size_t i = 0; i < this->y_tj.size(); i++) {
      distribution->y_tj[i] = this->y_tj[i].initial_value_m;
    }
    distribution->n_t = this->n_t;
    distribution->n_j = this->n_j;

    distribution->beta_z.resize(this->beta_z.size());
    for (size_t i = 0; i < this->beta_z.size(); i++) {
      distribution->beta_z[i] = this->beta_z[i].initial_value_m;
      if (this->beta_z[i].estimation_type_m.get() == "fixed_effects") {
        ss.str("");
        ss << "dsem." << this->id_m << ".beta_z." << this->beta_z[i].id_m;
        info->RegisterParameterName(ss.str());
        info->RegisterParameter(distribution->beta_z[i]);
      }
    }
    distribution->lnsigma_j.resize(this->lnsigma_j.size());
    for (size_t i = 0; i < this->lnsigma_j.size(); i++) {
      distribution->lnsigma_j[i] = this->lnsigma_j[i].initial_value_m;
      if (this->lnsigma_j[i].estimation_type_m.get() == "fixed_effects") {
        ss.str("");
        ss << "dsem." << this->id_m << ".lnsigma_j." << this->lnsigma_j[i].id_m;
        info->RegisterParameterName(ss.str());
        info->RegisterParameter(distribution->lnsigma_j[i]);
      }
    }
    distribution->mu_j.resize(this->mu_j.size());
    for (size_t i = 0; i < this->mu_j.size(); i++) {
      distribution->mu_j[i] = this->mu_j[i].initial_value_m;
      if (this->mu_j[i].estimation_type_m.get() == "fixed_effects") {
        ss.str("");
        ss << "dsem." << this->id_m << ".mu_j." << this->mu_j[i].id_m;
        info->RegisterParameterName(ss.str());
        info->RegisterParameter(distribution->mu_j[i]);
      }
    }
    distribution->delta0_j.resize(this->delta0_j.size());
    for (size_t i = 0; i < this->delta0_j.size(); i++) {
      distribution->delta0_j[i] = this->delta0_j[i].initial_value_m;
      if (this->delta0_j[i].estimation_type_m.get() == "fixed_effects") {
        ss.str("");
        ss << "dsem." << this->id_m << ".delta0_j." << this->delta0_j[i].id_m;
        info->RegisterParameterName(ss.str());
        info->RegisterParameter(distribution->delta0_j[i]);
      }
    }
    distribution->x_tj.resize(this->x_tj.size());
    for (size_t i = 0; i < this->x_tj.size(); i++) {
      distribution->x_tj[i] = this->x_tj[i].initial_value_m;
      if (this->x_tj[i].estimation_type_m.get() == "random_effects") {
        ss.str("");
        ss << "dsem." << this->id_m << ".x_tj." << this->x_tj[i].id_m;
        info->RegisterRandomEffectName(ss.str());
        info->RegisterRandomEffect(distribution->x_tj[i]);
      } else if (this->x_tj[i].estimation_type_m.get() == "fixed_effects") {
        ss.str("");
        ss << "dsem." << this->id_m << ".x_tj." << this->x_tj[i].id_m;
        info->RegisterParameterName(ss.str());
        info->RegisterParameter(distribution->x_tj[i]);
      }
    }

    info->density_components[distribution->id] = distribution;
    return true;
  }

  virtual bool add_to_fims_tmb() {
    this->add_to_fims_tmb_internal<TMB_FIMS_REAL_TYPE>();
    this->add_to_fims_tmb_internal<TMBAD_FIMS_TYPE>();
    return true;
  }
#endif
};

#endif
