/**
 * @file fims_modules.hpp
 * @brief Rcpp module definitions. Allows for the use of
 * methods::new() in R.
 * @copyright This file is part of the NOAA, National Marine Fisheries Service
 * Fisheries Integrated Modeling System project. See LICENSE in the source
 * folder for reuse information.
 */
#ifndef SRC_FIMS_MODULES_HPP
#define SRC_FIMS_MODULES_HPP

#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_data.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_fleet.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_growth.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_math.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_maturity.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_natural_mortality.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_population.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_recruitment.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_selectivity.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_distribution.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_spatiotemporal_spde.hpp"
#include "../inst/include/interface/rcpp/rcpp_objects/rcpp_interface_base.hpp"
#include "../inst/include/interface/rcpp/rcpp_interface.hpp"

RCPP_EXPOSED_CLASS(Parameter)
RCPP_EXPOSED_CLASS(ParameterVector)
RCPP_EXPOSED_CLASS(RealVector)
RCPP_EXPOSED_CLASS(SharedInt)
RCPP_EXPOSED_CLASS(SharedString)
RCPP_EXPOSED_CLASS(SharedReal)
RCPP_EXPOSED_CLASS(SharedBoolean)
RCPP_EXPOSED_CLASS(SpatiotemporalSPDEInterface)

/**
 * @brief Define fims C++ functions and classes exposed in R
 *
 * @details
 * The use of `RCPP_MODULE()` allows for exporting of specific C++ code to the
 * R environment, making it callable from R, i.e., providing declarative code
 * of what the module exposes to R.
 *
 * Each element included in the module should have a name, a pointer, and a
 * description separated by commas in that order. Elements can be functions or
 * classes. Within an element, both the name and the description should be
 * wrapped in quotes.
 *
 * The description is printed to the in R when users run `methods::show()` on
 * a function or class within the RCPP_MODULE, e.g., `methods::show(Parameter)`.
 * Thus, information in the description should either link to the relevant
 * doxygen documentation for the C++ class or function or exactly duplicate
 * what is written in the doxygen.
 *
 * Each of the functions included in this module should be exported by manually
 * exporting them in R/FIMS-package.R. Typically, R packages that use C++ would
 * take care a lot of this stuff automatically using `Rcpp::export` calls in the
 * C++ documentation but we cannot do that within FIMS because of how the
 * package is compiled.
 *
 */
RCPP_MODULE(fims) {
  Rcpp::function(
      "CreateTMBModel", &CreateTMBModel,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      // TODO: fix the naming mismatch
      "set_fixed", &set_fixed_parameters,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      // TODO: fix the naming mismatch
      "get_fixed", &get_fixed_parameters_vector,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      // TODO: fix the naming mismatch
      "set_random", &set_random_parameters,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      // TODO: fix the naming mismatch
      "get_random", &get_random_parameters_vector,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_parameter_names", &get_parameter_names,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_random_names", &get_random_names,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "clear", clear,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_log", get_log,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_log_errors", get_log_errors,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_log_warnings", get_log_warnings,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_log_info", get_log_info,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "get_log_module", get_log_module,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "write_log", write_log,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "set_log_path", set_log_path,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "init_logging", init_logging,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "set_log_throw_on_error", set_log_throw_on_error,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "log_info", log_info,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "log_warning", log_warning,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      "log_error", log_error,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      // TODO: fix the naming mismatch
      "logit", logit_rcpp,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");
  Rcpp::function(
      // TODO: fix the naming mismatch
      "inv_logit", inv_logit_rcpp,
      "See https://noaa-fims.github.io/doxygen/rcpp__interface_8hpp.html.");

  Rcpp::class_<Parameter>(
      "Parameter",
      "See https://noaa-fims.github.io/doxygen/classParameter.html.")
      .constructor()
      .constructor<double>()
      .constructor<Parameter>()
      .field("value", &Parameter::initial_value_m)
      .field("value", &Parameter::final_value_m)
      .field("min", &Parameter::min_m)
      .field("max", &Parameter::max_m)
      .field("id", &Parameter::id_m)
      .field("estimation_type", &Parameter::estimation_type_m);

  Rcpp::class_<ParameterVector>(
      "ParameterVector",
      "See https://noaa-fims.github.io/doxygen/classParameterVector.html.")
      .constructor()
      .constructor<size_t>()
      .constructor<Rcpp::NumericVector, size_t>()
      .method("get", &ParameterVector::get)
      .method("set", &ParameterVector::set)
      .method("show", &ParameterVector::show)
      .method("at", &ParameterVector::at)
      .method("size", &ParameterVector::size)
      .method("resize", &ParameterVector::resize)
      .method("set_all_estimable", &ParameterVector::set_all_estimable)
      .method("set_all_random", &ParameterVector::set_all_random)
      .method("fill", &ParameterVector::fill)
      .method("get_id", &ParameterVector::get_id);

  Rcpp::class_<RealVector>(
      "RealVector",
      "See https://noaa-fims.github.io/doxygen/classRealVector.html.")
      .constructor()
      .constructor<size_t>()
      .constructor<Rcpp::NumericVector, size_t>()
      .method("get", &RealVector::get)
      .method("set", &RealVector::set)
      .method("fromRVector", &RealVector::fromRVector)
      .method("toRVector", &RealVector::toRVector)
      .method("show", &RealVector::show)
      .method("at", &RealVector::at)
      .method("size", &RealVector::size)
      .method("resize", &RealVector::resize)
      .method("get_id", &RealVector::get_id);

  Rcpp::class_<SharedInt>(
      "SharedInt",
      "See https://noaa-fims.github.io/doxygen/classSharedInt.html.")
      .constructor()
      .constructor<int>()
      .method("get", &SharedInt::get)
      .method("set", &SharedInt::set);

  Rcpp::class_<SharedString>(
      "SharedString",
      "See https://noaa-fims.github.io/doxygen/classSharedString.html.")
      .constructor()
      .constructor<std::string>()
      .method("get", &SharedString::get)
      .method("set", &SharedString::set);

  Rcpp::class_<SharedBoolean>(
      "SharedBoolean",
      "See https://noaa-fims.github.io/doxygen/classSharedBoolean.html.")
      .constructor()
      .constructor<bool>()
      .method("get", &SharedBoolean::get)
      .method("set", &SharedBoolean::set);

  Rcpp::class_<SharedReal>(
      "SharedReal",
      "See https://noaa-fims.github.io/doxygen/classSharedReal.html.")
      .constructor()
      .constructor<double>()
      .method("get", &SharedReal::get)
      .method("set", &SharedReal::set);

  Rcpp::class_<BevertonHoltRecruitmentInterface>(
      "BevertonHoltRecruitment",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classBevertonHoltRecruitmentInterface.html.")
      .constructor()
      .field("logit_steep", &BevertonHoltRecruitmentInterface::logit_steep)
      .field("log_rzero", &BevertonHoltRecruitmentInterface::log_rzero)
      .field("log_devs", &BevertonHoltRecruitmentInterface::log_devs)
      .field("log_r", &BevertonHoltRecruitmentInterface::log_r)
      .field("log_expected_recruitment",
             &BevertonHoltRecruitmentInterface::log_expected_recruitment)
      .field("n_years", &BevertonHoltRecruitmentInterface::n_years)
      .method("get_id", &BevertonHoltRecruitmentInterface::get_id)
      .method("SetRecruitmentProcessID",
              &BevertonHoltRecruitmentInterface::SetRecruitmentProcessID)
      .method("evaluate_mean",
              &BevertonHoltRecruitmentInterface::evaluate_mean);

  Rcpp::class_<LogDevsRecruitmentInterface>(
      "LogDevsRecruitmentProcess",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classLogDevsRecruitmentInterface.html.")
      .constructor()
      .method("get_id", &LogDevsRecruitmentInterface::get_id)
      .method("evaluate_process",
              &LogDevsRecruitmentInterface::evaluate_process);

  Rcpp::class_<LogRRecruitmentInterface>(
      "LogRRecruitmentProcess",
      "See "
      "https://noaa-fims.github.io/doxygen/classLogRRecruitmentInterface.html.")
      .constructor()
      .method("get_id", &LogRRecruitmentInterface::get_id)
      .method("evaluate_process", &LogRRecruitmentInterface::evaluate_process);

  Rcpp::class_<FleetInterface>(
      "Fleet",
      "See https://noaa-fims.github.io/doxygen/classFleetInterface.html.")
      .constructor()
      .field("log_q", &FleetInterface::log_q)
      .field("log_Fmort", &FleetInterface::log_Fmort)
      .field("n_ages", &FleetInterface::n_ages)
      .field("n_years", &FleetInterface::n_years)
      .field("n_lengths", &FleetInterface::n_lengths)
      .field("observed_landings_units",
             &FleetInterface::observed_landings_units)
      .field("observed_index_units", &FleetInterface::observed_index_units)
      .field("index_expected", &FleetInterface::derived_index_expected)
      .field("landings_expected", &FleetInterface::derived_landings_expected)
      .field("log_index_expected", &FleetInterface::log_index_expected)
      .field("log_landings_expected", &FleetInterface::log_landings_expected)
      .field("agecomp_expected", &FleetInterface::agecomp_expected)
      .field("lengthcomp_expected", &FleetInterface::lengthcomp_expected)
      .field("agecomp_proportion", &FleetInterface::agecomp_proportion)
      .field("lengthcomp_proportion", &FleetInterface::lengthcomp_proportion)
      .field("age_to_length_conversion",
             &FleetInterface::age_to_length_conversion)
      .method("get_id", &FleetInterface::get_id)
      .method("SetName", &FleetInterface::SetName)
      .method("GetName", &FleetInterface::GetName)
      .method("SetObservedAgeCompDataID",
              &FleetInterface::SetObservedAgeCompDataID)
      .method("GetObservedAgeCompDataID",
              &FleetInterface::GetObservedAgeCompDataID)
      .method("SetObservedLengthCompDataID",
              &FleetInterface::SetObservedLengthCompDataID)
      .method("GetObservedLengthCompDataID",
              &FleetInterface::GetObservedLengthCompDataID)
      .method("SetObservedIndexDataID", &FleetInterface::SetObservedIndexDataID)
      .method("GetObservedIndexDataID", &FleetInterface::GetObservedIndexDataID)
      .method("SetObservedLandingsDataID",
              &FleetInterface::SetObservedLandingsDataID)
      .method("GetObservedLandingsDataID",
              &FleetInterface::GetObservedLandingsDataID)
      .method("SetSelectivityID", &FleetInterface::SetSelectivityID);

  Rcpp::class_<AgeCompDataInterface>(
      "AgeComp",
      "See https://noaa-fims.github.io/doxygen/classAgeCompDataInterface.html.")
      .constructor<int, int>()
      .field("age_comp_data", &AgeCompDataInterface::age_comp_data)
      .method("get_id", &AgeCompDataInterface::get_id);

  Rcpp::class_<LengthCompDataInterface>(
      "LengthComp",
      "See "
      "https://noaa-fims.github.io/doxygen/classLengthCompDataInterface.html.")
      .constructor<int, int>()
      .field("length_comp_data", &LengthCompDataInterface::length_comp_data)
      .method("get_id", &LengthCompDataInterface::get_id);

  Rcpp::class_<LandingsDataInterface>(
      "Landings",
      "See "
      "https://noaa-fims.github.io/doxygen/classLandingsDataInterface.html.")
      .constructor<int>()
      .field("landings_data", &LandingsDataInterface::landings_data)
      .method("get_id", &LandingsDataInterface::get_id);

  Rcpp::class_<IndexDataInterface>(
      "Index",
      "See https://noaa-fims.github.io/doxygen/classIndexDataInterface.html.")
      .constructor<int>()
      .field("index_data", &IndexDataInterface::index_data)
      .method("get_id", &IndexDataInterface::get_id);

  Rcpp::class_<PopulationInterface>(
      "Population",
      "See https://noaa-fims.github.io/doxygen/classPopulationInterface.html.")
      .constructor()
      .method("get_id", &PopulationInterface::get_id)
      .field("n_ages", &PopulationInterface::n_ages)
      .field("n_fleets", &PopulationInterface::n_fleets)
      .field("n_years", &PopulationInterface::n_years)
      .field("n_lengths", &PopulationInterface::n_lengths)
      .field("log_M", &PopulationInterface::log_M)
      .field("log_f_multiplier", &PopulationInterface::log_f_multiplier)
      .field("spawning_biomass_ratio",
             &PopulationInterface::spawning_biomass_ratio)
      .field("log_init_naa", &PopulationInterface::log_init_naa)
      .field("ages", &PopulationInterface::ages)
      .method("SetMaturityID", &PopulationInterface::SetMaturityID)
      .method("SetGrowthID", &PopulationInterface::SetGrowthID)
      .method("SetRecruitmentID", &PopulationInterface::SetRecruitmentID)
      .method("AddFleet", &PopulationInterface::AddFleet)
      .method("SetName", &PopulationInterface::SetName)
      .method("GetName", &PopulationInterface::GetName);

  Rcpp::class_<LogisticMaturityInterface>(
      "LogisticMaturity",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classLogisticMaturityInterface.html.")
      .constructor()
      .field("inflection_point", &LogisticMaturityInterface::inflection_point)
      .field("slope", &LogisticMaturityInterface::slope)
      .method("get_id", &LogisticMaturityInterface::get_id)
      .method("evaluate", &LogisticMaturityInterface::evaluate);

  Rcpp::class_<LogisticSelectivityInterface>(
      "LogisticSelectivity",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classLogisticSelectivityInterface.html.")
      .constructor()
      .field("inflection_point",
             &LogisticSelectivityInterface::inflection_point)
      .field("slope", &LogisticSelectivityInterface::slope)
      .method("get_id", &LogisticSelectivityInterface::get_id)
      .method("evaluate", &LogisticSelectivityInterface::evaluate);

  Rcpp::class_<DoubleLogisticSelectivityInterface>(
      "DoubleLogisticSelectivity",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classDoubleLogisticSelectivityInterface.html.")
      .constructor()
      .field("inflection_point_asc",
             &DoubleLogisticSelectivityInterface::inflection_point_asc)
      .field("slope_asc", &DoubleLogisticSelectivityInterface::slope_asc)
      .field("inflection_point_desc",
             &DoubleLogisticSelectivityInterface::inflection_point_desc)
      .field("slope_desc", &DoubleLogisticSelectivityInterface::slope_desc)
      .method("get_id", &DoubleLogisticSelectivityInterface::get_id)
      .method("evaluate", &DoubleLogisticSelectivityInterface::evaluate);

  Rcpp::class_<EWAAGrowthInterface>(
      "EWAAGrowth",
      "See https://noaa-fims.github.io/doxygen/classEWAAGrowthInterface.html.")
      .constructor()
      .field("ages", &EWAAGrowthInterface::ages, "Ages for each age class.")
      .field("weights", &EWAAGrowthInterface::weights,
             "Weights for each age class.")
      .method("get_id", &EWAAGrowthInterface::get_id)
      .method("evaluate", &EWAAGrowthInterface::evaluate);

  Rcpp::class_<DnormDistributionsInterface>(
      "DnormDistribution",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classDnormDistributionsInterface.html.")
      .constructor()
      .method("get_id", &DnormDistributionsInterface::get_id)
      .method("evaluate", &DnormDistributionsInterface::evaluate)
      .method("set_observed_data",
              &DnormDistributionsInterface::set_observed_data)
      .method("set_distribution_mean",
              &DnormDistributionsInterface::set_distribution_mean)
      .method("set_distribution_links",
              &DnormDistributionsInterface::set_distribution_links)
      .field("x", &DnormDistributionsInterface::x)
      .field("expected_values", &DnormDistributionsInterface::expected_values)
      .field("expected_mean", &DnormDistributionsInterface::expected_mean)
      .field("log_sd", &DnormDistributionsInterface::log_sd);

  Rcpp::class_<DlnormDistributionsInterface>(
      "DlnormDistribution",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classDlnormDistributionsInterface.html.")
      .constructor()
      .method("get_id", &DlnormDistributionsInterface::get_id)
      .method("evaluate", &DlnormDistributionsInterface::evaluate)
      .method("set_observed_data",
              &DlnormDistributionsInterface::set_observed_data)
      .method("set_distribution_links",
              &DlnormDistributionsInterface::set_distribution_links)
      .field("x", &DlnormDistributionsInterface::x)
      .field("expected_values", &DlnormDistributionsInterface::expected_values)
      .field("log_sd", &DlnormDistributionsInterface::log_sd);

  Rcpp::class_<DmultinomDistributionsInterface>(
      "DmultinomDistribution",
      "See "
      "https://noaa-fims.github.io/doxygen/"
      "classDmultinomDistributionsInterface.html.")
      .constructor()
      .method("get_id", &DmultinomDistributionsInterface::get_id)
      .method("evaluate", &DmultinomDistributionsInterface::evaluate)
      .method("set_observed_data",
              &DmultinomDistributionsInterface::set_observed_data)
      .method("set_distribution_links",
              &DmultinomDistributionsInterface::set_distribution_links)
      .method("set_note", &DmultinomDistributionsInterface::set_note)
      .field("x", &DmultinomDistributionsInterface::x)
      .field("expected_values",
             &DmultinomDistributionsInterface::expected_values)
      .field("dims", &DmultinomDistributionsInterface::dims);

  Rcpp::class_<CatchAtAgeInterface>(
      "CatchAtAge",
      "See https://noaa-fims.github.io/doxygen/classCatchAtAgeInterface.html.")
      .constructor()
      .method("AddPopulation", &CatchAtAgeInterface::AddPopulation)
      .method("get_output", &CatchAtAgeInterface::to_json)
      .method("GetReport", &CatchAtAgeInterface::get_report)
      .method("GetId", &CatchAtAgeInterface::get_id)
      .method("DoReporting", &CatchAtAgeInterface::DoReporting)
      .method("IsReporting", &CatchAtAgeInterface::IsReporting);

  Rcpp::class_<SpatiotemporalSPDEInterface>(
      "SpatiotemporalSPDE",
      "Spatio-temporal SPDE lognormal distribution. Combines a Matern SPDE "
      "prior on a latent field omega(node, year) with AR1 temporal evolution "
      "and a lognormal observation likelihood.")
      .constructor()
      .method("get_id", &SpatiotemporalSPDEInterface::get_id,
              "Returns the unique ID of this distribution interface.")
      .method("evaluate", &SpatiotemporalSPDEInterface::evaluate,
              "Evaluates the log-density using double arithmetic (no TMB).")
      .method("set_distribution_links",
              &SpatiotemporalSPDEInterface::set_distribution_links,
              "Not used; provided for interface compliance.")
      .field("n_nodes", &SpatiotemporalSPDEInterface::n_nodes,
             "Number of mesh nodes.")
      .field("n_years", &SpatiotemporalSPDEInterface::n_years,
             "Number of years.")
      .field("C0_i", &SpatiotemporalSPDEInterface::C0_i,
             "Row indices (0-based) for C0 sparse triplets.")
      .field("C0_j", &SpatiotemporalSPDEInterface::C0_j,
             "Column indices (0-based) for C0 sparse triplets.")
      .field("C0_v", &SpatiotemporalSPDEInterface::C0_v,
             "Non-zero values of C0.")
      .field("C1_i", &SpatiotemporalSPDEInterface::C1_i,
             "Row indices (0-based) for C1 sparse triplets.")
      .field("C1_j", &SpatiotemporalSPDEInterface::C1_j,
             "Column indices (0-based) for C1 sparse triplets.")
      .field("C1_v", &SpatiotemporalSPDEInterface::C1_v,
             "Non-zero values of C1.")
      .field("C2_i", &SpatiotemporalSPDEInterface::C2_i,
             "Row indices (0-based) for C2 sparse triplets.")
      .field("C2_j", &SpatiotemporalSPDEInterface::C2_j,
             "Column indices (0-based) for C2 sparse triplets.")
      .field("C2_v", &SpatiotemporalSPDEInterface::C2_v,
             "Non-zero values of C2.")
      .field("A_i", &SpatiotemporalSPDEInterface::A_i,
             "Row (observation) indices (0-based) for A sparse triplets.")
      .field("A_j", &SpatiotemporalSPDEInterface::A_j,
             "Column (node) indices (0-based) for A sparse triplets.")
      .field("A_v", &SpatiotemporalSPDEInterface::A_v,
             "Non-zero values of A (projection weights).")
      .field("y_obs", &SpatiotemporalSPDEInterface::y_obs,
             "Positive observed values (length n_obs).")
      .field("obs_year_idx", &SpatiotemporalSPDEInterface::obs_year_idx,
             "0-based year index for each observation.")
      .field("beta0", &SpatiotemporalSPDEInterface::beta0,
             "Intercept on the log scale (ParameterVector, 1 element).")
      .field("rho_logit", &SpatiotemporalSPDEInterface::rho_logit,
             "AR1 correlation logit-scale; rho = tanh(rho_logit).")
      .field("log_kappa", &SpatiotemporalSPDEInterface::log_kappa,
             "Log SPDE range parameter; kappa = exp(log_kappa).")
      .field("log_tau", &SpatiotemporalSPDEInterface::log_tau,
             "Log SPDE variance parameter; tau = exp(log_tau).")
      .field("log_sigma_obs", &SpatiotemporalSPDEInterface::log_sigma_obs,
             "Log observation standard deviation.")
      .field("omega", &SpatiotemporalSPDEInterface::omega,
             "Latent field (ParameterVector, n_nodes * n_years elements).")
      .field("lpdf_value", &SpatiotemporalSPDEInterface::lpdf_value,
             "Total log-density after model run.")
      .field("report_lpdf_vec", &SpatiotemporalSPDEInterface::report_lpdf_vec,
             "Per-observation log-density values after model run.");
}

#endif /* SRC_FIMS_MODULES_HPP */
