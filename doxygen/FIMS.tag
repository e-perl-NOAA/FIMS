<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.9.8">
  <compound kind="file">
    <name>data_object.hpp</name>
    <path>inst/include/common/</path>
    <filename>data__object_8hpp.html</filename>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">model_object.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">fims_vector.hpp</includes>
    <class kind="struct">fims_data_object::DataObject</class>
  </compound>
  <compound kind="file">
    <name>def.hpp</name>
    <path>inst/include/common/</path>
    <filename>def_8hpp.html</filename>
    <class kind="struct">fims::LogEntry</class>
    <class kind="class">fims::FIMSLog</class>
    <member kind="define">
      <type>#define</type>
      <name>FIMS_INFO_LOG</name>
      <anchorfile>def_8hpp.html</anchorfile>
      <anchor>a2b168389ac8c99d4f1bcdae5a9532c65</anchor>
      <arglist>(MESSAGE)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>FIMS_WARNING_LOG</name>
      <anchorfile>def_8hpp.html</anchorfile>
      <anchor>a1f743e7dd7460099a9580e3f24ced6df</anchor>
      <arglist>(MESSAGE)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>FIMS_ERROR_LOG</name>
      <anchorfile>def_8hpp.html</anchorfile>
      <anchor>ae4ff8b8279af8e71e4459d586b695ebd</anchor>
      <arglist>(MESSAGE)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>FIMS_STR</name>
      <anchorfile>def_8hpp.html</anchorfile>
      <anchor>ac5d50460624b44c727e53d30026fb9c6</anchor>
      <arglist>(s)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>fims_math.hpp</name>
    <path>inst/include/common/</path>
    <filename>fims__math_8hpp.html</filename>
    <includes id="interface_8hpp" name="interface.hpp" local="yes" import="no" module="no" objc="no">../interface/interface.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">fims_vector.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fims_vector.hpp</name>
    <path>inst/include/common/</path>
    <filename>fims__vector_8hpp.html</filename>
    <includes id="interface_8hpp" name="interface.hpp" local="yes" import="no" module="no" objc="no">../interface/interface.hpp</includes>
    <class kind="class">fims::Vector</class>
    <member kind="function">
      <type>std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>fims__vector_8hpp.html</anchorfile>
      <anchor>a0a2ff2cf3094fe2663aa632b327d89d9</anchor>
      <arglist>(std::ostream &amp;out, const fims::Vector&lt; Type &gt; &amp;v)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>information.hpp</name>
    <path>inst/include/common/</path>
    <filename>information_8hpp.html</filename>
    <includes id="distributions_8hpp" name="distributions.hpp" local="yes" import="no" module="no" objc="no">../distributions/distributions.hpp</includes>
    <includes id="fishery__model__base_8hpp" name="fishery_model_base.hpp" local="yes" import="no" module="no" objc="no">../models/functors/fishery_model_base.hpp</includes>
    <includes id="fleet_8hpp" name="fleet.hpp" local="yes" import="no" module="no" objc="no">../population_dynamics/fleet/fleet.hpp</includes>
    <includes id="growth_8hpp" name="growth.hpp" local="yes" import="no" module="no" objc="no">../population_dynamics/growth/growth.hpp</includes>
    <includes id="population_8hpp" name="population.hpp" local="yes" import="no" module="no" objc="no">../population_dynamics/population/population.hpp</includes>
    <includes id="recruitment_8hpp" name="recruitment.hpp" local="yes" import="no" module="no" objc="no">../population_dynamics/recruitment/recruitment.hpp</includes>
    <includes id="selectivity_8hpp" name="selectivity.hpp" local="yes" import="no" module="no" objc="no">../population_dynamics/selectivity/selectivity.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">fims_vector.hpp</includes>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">model_object.hpp</includes>
    <class kind="class">fims_info::Information</class>
  </compound>
  <compound kind="file">
    <name>model.hpp</name>
    <path>inst/include/common/</path>
    <filename>model_8hpp.html</filename>
    <includes id="information_8hpp" name="information.hpp" local="yes" import="no" module="no" objc="no">information.hpp</includes>
    <class kind="class">fims_model::Model</class>
  </compound>
  <compound kind="file">
    <name>model_object.hpp</name>
    <path>inst/include/common/</path>
    <filename>model__object_8hpp.html</filename>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">fims_vector.hpp</includes>
    <class kind="struct">fims_model_object::FIMSObject</class>
  </compound>
  <compound kind="file">
    <name>distributions.hpp</name>
    <path>inst/include/distributions/</path>
    <filename>distributions_8hpp.html</filename>
    <includes id="density__components__base_8hpp" name="density_components_base.hpp" local="yes" import="no" module="no" objc="no">functors/density_components_base.hpp</includes>
    <includes id="lognormal__lpdf_8hpp" name="lognormal_lpdf.hpp" local="yes" import="no" module="no" objc="no">functors/lognormal_lpdf.hpp</includes>
    <includes id="multinomial__lpmf_8hpp" name="multinomial_lpmf.hpp" local="yes" import="no" module="no" objc="no">functors/multinomial_lpmf.hpp</includes>
    <includes id="normal__lpdf_8hpp" name="normal_lpdf.hpp" local="yes" import="no" module="no" objc="no">functors/normal_lpdf.hpp</includes>
  </compound>
  <compound kind="file">
    <name>density_components_base.hpp</name>
    <path>inst/include/distributions/functors/</path>
    <filename>density__components__base_8hpp.html</filename>
    <includes id="data__object_8hpp" name="data_object.hpp" local="yes" import="no" module="no" objc="no">../../common/data_object.hpp</includes>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">../../common/model_object.hpp</includes>
    <includes id="interface_8hpp" name="interface.hpp" local="yes" import="no" module="no" objc="no">../../interface/interface.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_vector.hpp</includes>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_math.hpp</includes>
    <class kind="struct">fims_distributions::DensityComponentBase</class>
  </compound>
  <compound kind="file">
    <name>lognormal_lpdf.hpp</name>
    <path>inst/include/distributions/functors/</path>
    <filename>lognormal__lpdf_8hpp.html</filename>
    <includes id="density__components__base_8hpp" name="density_components_base.hpp" local="yes" import="no" module="no" objc="no">density_components_base.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_vector.hpp</includes>
    <class kind="struct">fims_distributions::LogNormalLPDF</class>
  </compound>
  <compound kind="file">
    <name>multinomial_lpmf.hpp</name>
    <path>inst/include/distributions/functors/</path>
    <filename>multinomial__lpmf_8hpp.html</filename>
    <includes id="density__components__base_8hpp" name="density_components_base.hpp" local="yes" import="no" module="no" objc="no">density_components_base.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_vector.hpp</includes>
    <class kind="struct">fims_distributions::MultinomialLPMF</class>
  </compound>
  <compound kind="file">
    <name>normal_lpdf.hpp</name>
    <path>inst/include/distributions/functors/</path>
    <filename>normal__lpdf_8hpp.html</filename>
    <includes id="def_8hpp" name="def.hpp" local="yes" import="no" module="no" objc="no">../../common/def.hpp</includes>
    <includes id="density__components__base_8hpp" name="density_components_base.hpp" local="yes" import="no" module="no" objc="no">density_components_base.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_vector.hpp</includes>
    <class kind="struct">fims_distributions::NormalLPDF</class>
  </compound>
  <compound kind="file">
    <name>interface.hpp</name>
    <path>inst/include/interface/</path>
    <filename>interface_8hpp.html</filename>
    <member kind="define">
      <type>#define</type>
      <name>FIMS_SIMULATE_F</name>
      <anchorfile>interface_8hpp.html</anchorfile>
      <anchor>a0158a5245bc111acb0ea4bde25080b03</anchor>
      <arglist>(F)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>FIMS_REPORT_F</name>
      <anchorfile>interface_8hpp.html</anchorfile>
      <anchor>a71e625ad904d0f072536840e13e5e04c</anchor>
      <arglist>(name, F)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>ADREPORT_F</name>
      <anchorfile>interface_8hpp.html</anchorfile>
      <anchor>a1a40ff5b437e7736dc7acb15c899ea96</anchor>
      <arglist>(name, F)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_interface.hpp</name>
    <path>inst/include/interface/rcpp/</path>
    <filename>rcpp__interface_8hpp.html</filename>
    <includes id="model_8hpp" name="model.hpp" local="yes" import="no" module="no" objc="no">../../common/model.hpp</includes>
    <includes id="fims__json_8hpp" name="fims_json.hpp" local="yes" import="no" module="no" objc="no">../../utilities/fims_json.hpp</includes>
    <includes id="rcpp__data_8hpp" name="rcpp_data.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_data.hpp</includes>
    <includes id="rcpp__distribution_8hpp" name="rcpp_distribution.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_distribution.hpp</includes>
    <includes id="rcpp__fleet_8hpp" name="rcpp_fleet.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_fleet.hpp</includes>
    <includes id="rcpp__growth_8hpp" name="rcpp_growth.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_growth.hpp</includes>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_interface_base.hpp</includes>
    <includes id="rcpp__maturity_8hpp" name="rcpp_maturity.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_maturity.hpp</includes>
    <includes id="rcpp__models_8hpp" name="rcpp_models.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_models.hpp</includes>
    <includes id="rcpp__natural__mortality_8hpp" name="rcpp_natural_mortality.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_natural_mortality.hpp</includes>
    <includes id="rcpp__population_8hpp" name="rcpp_population.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_population.hpp</includes>
    <includes id="rcpp__recruitment_8hpp" name="rcpp_recruitment.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_recruitment.hpp</includes>
    <includes id="rcpp__selectivity_8hpp" name="rcpp_selectivity.hpp" local="yes" import="no" module="no" objc="no">rcpp_objects/rcpp_selectivity.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>init_logging</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>ad8bf2ebe714bdb6a1e216ed7d9efa7a3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>CreateTMBModel</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a1d0c303c2c44fcb296368608a5f2ff1a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_fixed_parameters</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>aecc723970498500fa938ca77a1502e25</anchor>
      <arglist>(Rcpp::NumericVector par)</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::NumericVector</type>
      <name>get_fixed_parameters_vector</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>accd5cf41c12b933a40a5d3808cee44a5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_random_parameters</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a602703ef3357097ff34a6751fd13c3f5</anchor>
      <arglist>(Rcpp::NumericVector par)</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::NumericVector</type>
      <name>get_random_parameters_vector</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>ace395771e2a80c98b2ae2e3da4d141dc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::List</type>
      <name>get_parameter_names</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a82e3a00b5981f857ed79cd594f70bf0e</anchor>
      <arglist>(Rcpp::List pars)</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::List</type>
      <name>get_random_names</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>af9adbb18f4b688138a54a189ff3b36e1</anchor>
      <arglist>(Rcpp::List pars)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>clear_internal</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a9f5a235582e7cc0f29e3431fc89ef10d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>clear</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>ac8bb3912a3ce86b15842e79d0b421204</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_log</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a924e08ad8be03c00824757641ed43619</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_log_errors</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a7665d61cdec92aa03255c2cd09633cc8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_log_warnings</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a1143b71f2fae1d0fdc570a326f2ae84e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_log_info</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a2c59f540047725fab06de92844d9e243</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>write_log</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>ad2abfffed726ee7fcbf89f0ec216fe62</anchor>
      <arglist>(bool write)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_log_path</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a0b21c940ec97b43420185f5c0cada013</anchor>
      <arglist>(const std::string &amp;path)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_log_throw_on_error</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a8307f81a8310f0c70a7bf7bc5b4aa5ea</anchor>
      <arglist>(bool throw_on_error)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>log_info</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>abb302b24e64ea5019d869cbab4a6e17f</anchor>
      <arglist>(std::string log_entry)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>log_warning</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a78b2e675893b5a855befac2d0932d927</anchor>
      <arglist>(std::string log_entry)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>escapeQuotes</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a14b639ccdb08205804ff4bfef6641f02</anchor>
      <arglist>(const std::string &amp;input)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>log_error</name>
      <anchorfile>rcpp__interface_8hpp.html</anchorfile>
      <anchor>a3d5c2c9072a935ebf9b36ac49cc63ef6</anchor>
      <arglist>(std::string log_entry)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_data.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__data_8hpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <includes id="information_8hpp" name="information.hpp" local="yes" import="no" module="no" objc="no">common/information.hpp</includes>
    <class kind="class">DataInterfaceBase</class>
    <class kind="class">AgeCompDataInterface</class>
    <class kind="class">LengthCompDataInterface</class>
    <class kind="class">IndexDataInterface</class>
    <class kind="class">LandingsDataInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_distribution.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__distribution_8hpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <includes id="distributions_8hpp" name="distributions.hpp" local="yes" import="no" module="no" objc="no">../../../distributions/distributions.hpp</includes>
    <class kind="class">DistributionsInterfaceBase</class>
    <class kind="class">DnormDistributionsInterface</class>
    <class kind="class">DlnormDistributionsInterface</class>
    <class kind="class">DmultinomDistributionsInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_fleet.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__fleet_8hpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <includes id="fleet_8hpp" name="fleet.hpp" local="yes" import="no" module="no" objc="no">../../../population_dynamics/fleet/fleet.hpp</includes>
    <class kind="class">FleetInterfaceBase</class>
    <class kind="class">FleetInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_growth.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__growth_8hpp.html</filename>
    <includes id="growth_8hpp" name="growth.hpp" local="yes" import="no" module="no" objc="no">../../../population_dynamics/growth/growth.hpp</includes>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <class kind="class">GrowthInterfaceBase</class>
    <class kind="class">EWAAGrowthInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_interface_base.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__interface__base_8hpp.html</filename>
    <includes id="information_8hpp" name="information.hpp" local="yes" import="no" module="no" objc="no">common/information.hpp</includes>
    <includes id="interface_8hpp" name="interface.hpp" local="yes" import="no" module="no" objc="no">../../interface.hpp</includes>
    <includes id="rcpp__shared__primitive_8hpp" name="rcpp_shared_primitive.hpp" local="yes" import="no" module="no" objc="no">rcpp_shared_primitive.hpp</includes>
    <class kind="class">Parameter</class>
    <class kind="class">ParameterVector</class>
    <class kind="class">RealVector</class>
    <class kind="class">FIMSRcppInterfaceBase</class>
    <member kind="function">
      <type>double</type>
      <name>sanitize_val</name>
      <anchorfile>rcpp__interface__base_8hpp.html</anchorfile>
      <anchor>a18721bca590fa172ea797a55c6ae10e3</anchor>
      <arglist>(double x)</arglist>
    </member>
    <member kind="function">
      <type>std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>rcpp__interface__base_8hpp.html</anchorfile>
      <anchor>a0bd065ea931f82a169ebf53822c29d57</anchor>
      <arglist>(std::ostream &amp;out, const Parameter &amp;p)</arglist>
    </member>
    <member kind="function">
      <type>std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>rcpp__interface__base_8hpp.html</anchorfile>
      <anchor>aa89b8163b657a51e656e119c1af6153f</anchor>
      <arglist>(std::ostream &amp;out, ParameterVector &amp;v)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_math.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__math_8hpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">common/fims_math.hpp</includes>
    <member kind="function">
      <type>double</type>
      <name>logit_rcpp</name>
      <anchorfile>rcpp__math_8hpp.html</anchorfile>
      <anchor>a878867e80d467b75259d7ddf9ddad155</anchor>
      <arglist>(double a, double b, double x)</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>inv_logit_rcpp</name>
      <anchorfile>rcpp__math_8hpp.html</anchorfile>
      <anchor>a0dcf7ea8e6cc6ace6061766f7209b20c</anchor>
      <arglist>(double a, double b, double logit_x)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_maturity.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__maturity_8hpp.html</filename>
    <includes id="maturity_8hpp" name="maturity.hpp" local="yes" import="no" module="no" objc="no">../../../population_dynamics/maturity/maturity.hpp</includes>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <class kind="class">MaturityInterfaceBase</class>
    <class kind="class">LogisticMaturityInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_models.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__models_8hpp.html</filename>
    <includes id="def_8hpp" name="def.hpp" local="yes" import="no" module="no" objc="no">common/def.hpp</includes>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <includes id="fisheries__models_8hpp" name="fisheries_models.hpp" local="yes" import="no" module="no" objc="no">../../../models/fisheries_models.hpp</includes>
    <includes id="model_8hpp" name="model.hpp" local="yes" import="no" module="no" objc="no">common/model.hpp</includes>
    <includes id="fims__json_8hpp" name="fims_json.hpp" local="yes" import="no" module="no" objc="no">../../../utilities/fims_json.hpp</includes>
    <includes id="rcpp__population_8hpp" name="rcpp_population.hpp" local="yes" import="no" module="no" objc="no">rcpp_population.hpp</includes>
    <includes id="rcpp__fleet_8hpp" name="rcpp_fleet.hpp" local="yes" import="no" module="no" objc="no">rcpp_fleet.hpp</includes>
    <includes id="rcpp__growth_8hpp" name="rcpp_growth.hpp" local="yes" import="no" module="no" objc="no">rcpp_growth.hpp</includes>
    <includes id="rcpp__distribution_8hpp" name="rcpp_distribution.hpp" local="yes" import="no" module="no" objc="no">rcpp_distribution.hpp</includes>
    <includes id="rcpp__data_8hpp" name="rcpp_data.hpp" local="yes" import="no" module="no" objc="no">rcpp_data.hpp</includes>
    <includes id="rcpp__maturity_8hpp" name="rcpp_maturity.hpp" local="yes" import="no" module="no" objc="no">rcpp_maturity.hpp</includes>
    <includes id="rcpp__recruitment_8hpp" name="rcpp_recruitment.hpp" local="yes" import="no" module="no" objc="no">rcpp_recruitment.hpp</includes>
    <includes id="rcpp__selectivity_8hpp" name="rcpp_selectivity.hpp" local="yes" import="no" module="no" objc="no">rcpp_selectivity.hpp</includes>
    <class kind="class">FisheryModelInterfaceBase</class>
    <class kind="class">CatchAtAgeInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_natural_mortality.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__natural__mortality_8hpp.html</filename>
  </compound>
  <compound kind="file">
    <name>rcpp_population.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__population_8hpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <includes id="population_8hpp" name="population.hpp" local="yes" import="no" module="no" objc="no">../../../population_dynamics/population/population.hpp</includes>
    <class kind="class">PopulationInterfaceBase</class>
    <class kind="class">PopulationInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_recruitment.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__recruitment_8hpp.html</filename>
    <includes id="recruitment_8hpp" name="recruitment.hpp" local="yes" import="no" module="no" objc="no">../../../population_dynamics/recruitment/recruitment.hpp</includes>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <class kind="class">RecruitmentInterfaceBase</class>
    <class kind="class">BevertonHoltRecruitmentInterface</class>
    <class kind="class">LogDevsRecruitmentInterface</class>
    <class kind="class">LogRRecruitmentInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_selectivity.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__selectivity_8hpp.html</filename>
    <includes id="selectivity_8hpp" name="selectivity.hpp" local="yes" import="no" module="no" objc="no">../../../population_dynamics/selectivity/selectivity.hpp</includes>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">rcpp_interface_base.hpp</includes>
    <class kind="class">SelectivityInterfaceBase</class>
    <class kind="class">LogisticSelectivityInterface</class>
    <class kind="class">DoubleLogisticSelectivityInterface</class>
  </compound>
  <compound kind="file">
    <name>rcpp_shared_primitive.hpp</name>
    <path>inst/include/interface/rcpp/rcpp_objects/</path>
    <filename>rcpp__shared__primitive_8hpp.html</filename>
    <class kind="class">SharedInt</class>
    <class kind="class">SharedReal</class>
    <class kind="class">SharedString</class>
    <class kind="class">SharedBoolean</class>
    <member kind="typedef">
      <type>SharedInt</type>
      <name>fims_int</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a7a3a24a8e169b1e0070317b543e927fd</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SharedReal</type>
      <name>fims_double</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a23aef349e639b6b4235ed6f4525902b9</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SharedString</type>
      <name>fims_string</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>ad417724f0f3a22c2c03d4efdee760f74</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>SharedBoolean</type>
      <name>fims_bool</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a2776e3cef942893bbeeb300f2c7126eb</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator+</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a422a4670f4c19eae83e608e849d7694b</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator-</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a00f0fc40ef1733b6bdca13d317fb90b9</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator*</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>aa47045d26d6c104ed2efe76c8bbb2422</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator/</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a8c9435923aa8f19b42ab4d1dc662796c</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>aa705a61e951b104cd8f08a03917e0bfd</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>accad4119a60d6376ef13ccd0ef388ea0</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a61621b0f9e096ada92994b0cdab98cf5</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a86b74fed45bf4b4fb5c3b020e4cdfb3a</anchor>
      <arglist>(const int &amp;lhs, const SharedInt &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator+</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a2349c3c62cac570c72495a1203d9e1e8</anchor>
      <arglist>(const double &amp;lhs, const SharedReal &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator-</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>af1b36bcfc2992ef26d6e7aed083c4668</anchor>
      <arglist>(const double &amp;lhs, const SharedReal &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator*</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>afc6ce10541843f3f469086b414da0664</anchor>
      <arglist>(const double &amp;lhs, const SharedReal &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator/</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>ac7f8b831f320a7d7a3eaaeefdff29f7a</anchor>
      <arglist>(const double &amp;lhs, const SharedReal &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a91a73014b3356292d85d089a018b94bc</anchor>
      <arglist>(const bool &amp;lhs, const SharedBoolean &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>aa082af628cd1530b6b13d3c2fe9b6775</anchor>
      <arglist>(const bool &amp;lhs, const SharedBoolean &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a2fe41b60285ef4fb2762cb04b28d01ea</anchor>
      <arglist>(const bool &amp;lhs, const SharedBoolean &amp;rhs)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>rcpp__shared__primitive_8hpp.html</anchorfile>
      <anchor>a08e15f76b24c75497507635546136fd9</anchor>
      <arglist>(const bool &amp;lhs, const SharedBoolean &amp;rhs)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>init_tmb.hpp</name>
    <path>inst/include/interface/TMB/</path>
    <filename>init__tmb_8hpp.html</filename>
    <member kind="function">
      <type>SEXP</type>
      <name>_rcpp_module_boot_fims</name>
      <anchorfile>init__tmb_8hpp.html</anchorfile>
      <anchor>ab00dfa917c09fa552d226ebbb99e7c21</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>__attribute__</name>
      <anchorfile>init__tmb_8hpp.html</anchorfile>
      <anchor>a96c639830534f129df46f7129a9848af</anchor>
      <arglist>((visibility(&quot;default&quot;))) void R_init_FIMS(DllInfo *dll)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>TMB.h</name>
    <path>inst/include/interface/TMB/</path>
    <filename>TMB_8h.html</filename>
    <member kind="define">
      <type>#define</type>
      <name>TMB_H</name>
      <anchorfile>TMB_8h.html</anchorfile>
      <anchor>a1c070b5395e09d7be73adfaa64c2c0bb</anchor>
      <arglist></arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>WITH_LIBTMB</name>
      <anchorfile>TMB_8h.html</anchorfile>
      <anchor>a284a3c52326ee2f4337f13213cd5e004</anchor>
      <arglist></arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>CSKIP</name>
      <anchorfile>TMB_8h.html</anchorfile>
      <anchor>a1ee517ce7b0b2d35d05411d2888c2cd0</anchor>
      <arglist>(...)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>IF_TMB_PRECOMPILE</name>
      <anchorfile>TMB_8h.html</anchorfile>
      <anchor>aa3ddf8dd595d2a42e37ffbb159f0af10</anchor>
      <arglist>(...)</arglist>
    </member>
    <member kind="define">
      <type>#define</type>
      <name>TMB_EXTERN</name>
      <anchorfile>TMB_8h.html</anchorfile>
      <anchor>a148f6b931612eca11ce455b94b2a498b</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>fisheries_models.hpp</name>
    <path>inst/include/models/</path>
    <filename>fisheries__models_8hpp.html</filename>
    <includes id="catch__at__age_8hpp" name="catch_at_age.hpp" local="yes" import="no" module="no" objc="no">functors/catch_at_age.hpp</includes>
  </compound>
  <compound kind="file">
    <name>catch_at_age.hpp</name>
    <path>inst/include/models/functors/</path>
    <filename>catch__at__age_8hpp.html</filename>
    <includes id="fishery__model__base_8hpp" name="fishery_model_base.hpp" local="yes" import="no" module="no" objc="no">fishery_model_base.hpp</includes>
    <class kind="class">fims_popdy::CatchAtAge</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>fishery_model_base.hpp</name>
    <path>inst/include/models/functors/</path>
    <filename>fishery__model__base_8hpp.html</filename>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">../../common/model_object.hpp</includes>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_math.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_vector.hpp</includes>
    <includes id="population_8hpp" name="population.hpp" local="yes" import="no" module="no" objc="no">../../population_dynamics/population/population.hpp</includes>
    <class kind="struct">fims_popdy::DimensionInfo</class>
    <class kind="class">fims_popdy::FisheryModelBase</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>fleet.hpp</name>
    <path>inst/include/population_dynamics/fleet/</path>
    <filename>fleet_8hpp.html</filename>
    <includes id="data__object_8hpp" name="data_object.hpp" local="yes" import="no" module="no" objc="no">../../common/data_object.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../../common/fims_vector.hpp</includes>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">../../common/model_object.hpp</includes>
    <includes id="distributions_8hpp" name="distributions.hpp" local="yes" import="no" module="no" objc="no">../../distributions/distributions.hpp</includes>
    <includes id="selectivity_8hpp" name="selectivity.hpp" local="yes" import="no" module="no" objc="no">../selectivity/selectivity.hpp</includes>
    <class kind="struct">fims_popdy::Fleet</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>ewaa.hpp</name>
    <path>inst/include/population_dynamics/growth/functors/</path>
    <filename>ewaa_8hpp.html</filename>
    <includes id="growth__base_8hpp" name="growth_base.hpp" local="yes" import="no" module="no" objc="no">growth_base.hpp</includes>
    <class kind="struct">fims_popdy::EWAAGrowth</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>growth_base.hpp</name>
    <path>inst/include/population_dynamics/growth/functors/</path>
    <filename>growth__base_8hpp.html</filename>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">common/model_object.hpp</includes>
    <class kind="struct">fims_popdy::GrowthBase</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>growth.hpp</name>
    <path>inst/include/population_dynamics/growth/</path>
    <filename>growth_8hpp.html</filename>
    <includes id="ewaa_8hpp" name="ewaa.hpp" local="yes" import="no" module="no" objc="no">functors/ewaa.hpp</includes>
    <includes id="growth__base_8hpp" name="growth_base.hpp" local="yes" import="no" module="no" objc="no">functors/growth_base.hpp</includes>
  </compound>
  <compound kind="file">
    <name>maturity_base.hpp</name>
    <path>inst/include/population_dynamics/maturity/functors/</path>
    <filename>maturity__base_8hpp.html</filename>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">common/model_object.hpp</includes>
    <class kind="struct">fims_popdy::MaturityBase</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>maturity.hpp</name>
    <path>inst/include/population_dynamics/maturity/</path>
    <filename>maturity_8hpp.html</filename>
    <includes id="maturity_2functors_2logistic_8hpp" name="logistic.hpp" local="yes" import="no" module="no" objc="no">functors/logistic.hpp</includes>
    <includes id="maturity__base_8hpp" name="maturity_base.hpp" local="yes" import="no" module="no" objc="no">functors/maturity_base.hpp</includes>
  </compound>
  <compound kind="file">
    <name>population.hpp</name>
    <path>inst/include/population_dynamics/population/</path>
    <filename>population_8hpp.html</filename>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">../../common/model_object.hpp</includes>
    <includes id="fleet_8hpp" name="fleet.hpp" local="yes" import="no" module="no" objc="no">../fleet/fleet.hpp</includes>
    <includes id="growth_8hpp" name="growth.hpp" local="yes" import="no" module="no" objc="no">../growth/growth.hpp</includes>
    <includes id="recruitment_8hpp" name="recruitment.hpp" local="yes" import="no" module="no" objc="no">../recruitment/recruitment.hpp</includes>
    <includes id="interface_8hpp" name="interface.hpp" local="yes" import="no" module="no" objc="no">../../interface/interface.hpp</includes>
    <includes id="maturity_8hpp" name="maturity.hpp" local="yes" import="no" module="no" objc="no">../maturity/maturity.hpp</includes>
    <class kind="struct">fims_popdy::Population</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>subpopulation.hpp</name>
    <path>inst/include/population_dynamics/population/</path>
    <filename>subpopulation_8hpp.html</filename>
    <class kind="class">fims_popdy::Subpopulation</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>log_devs.hpp</name>
    <path>inst/include/population_dynamics/recruitment/functors/</path>
    <filename>log__devs_8hpp.html</filename>
    <includes id="recruitment__base_8hpp" name="recruitment_base.hpp" local="yes" import="no" module="no" objc="no">recruitment_base.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <class kind="struct">fims_popdy::LogDevs</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>log_r.hpp</name>
    <path>inst/include/population_dynamics/recruitment/functors/</path>
    <filename>log__r_8hpp.html</filename>
    <includes id="recruitment__base_8hpp" name="recruitment_base.hpp" local="yes" import="no" module="no" objc="no">recruitment_base.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <class kind="struct">fims_popdy::LogR</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>recruitment_base.hpp</name>
    <path>inst/include/population_dynamics/recruitment/functors/</path>
    <filename>recruitment__base_8hpp.html</filename>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">common/fims_math.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">common/model_object.hpp</includes>
    <class kind="struct">fims_popdy::RecruitmentBase</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>sr_beverton_holt.hpp</name>
    <path>inst/include/population_dynamics/recruitment/functors/</path>
    <filename>sr__beverton__holt_8hpp.html</filename>
    <includes id="recruitment__base_8hpp" name="recruitment_base.hpp" local="yes" import="no" module="no" objc="no">recruitment_base.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <class kind="struct">fims_popdy::SRBevertonHolt</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>recruitment.hpp</name>
    <path>inst/include/population_dynamics/recruitment/</path>
    <filename>recruitment_8hpp.html</filename>
    <includes id="recruitment__base_8hpp" name="recruitment_base.hpp" local="yes" import="no" module="no" objc="no">functors/recruitment_base.hpp</includes>
    <includes id="sr__beverton__holt_8hpp" name="sr_beverton_holt.hpp" local="yes" import="no" module="no" objc="no">functors/sr_beverton_holt.hpp</includes>
    <includes id="log__devs_8hpp" name="log_devs.hpp" local="yes" import="no" module="no" objc="no">functors/log_devs.hpp</includes>
    <includes id="log__r_8hpp" name="log_r.hpp" local="yes" import="no" module="no" objc="no">functors/log_r.hpp</includes>
  </compound>
  <compound kind="file">
    <name>double_logistic.hpp</name>
    <path>inst/include/population_dynamics/selectivity/functors/</path>
    <filename>double__logistic_8hpp.html</filename>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">common/fims_math.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <includes id="selectivity__base_8hpp" name="selectivity_base.hpp" local="yes" import="no" module="no" objc="no">selectivity_base.hpp</includes>
    <class kind="struct">fims_popdy::DoubleLogisticSelectivity</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>logistic.hpp</name>
    <path>inst/include/population_dynamics/maturity/functors/</path>
    <filename>maturity_2functors_2logistic_8hpp.html</filename>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">common/fims_math.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <includes id="maturity__base_8hpp" name="maturity_base.hpp" local="yes" import="no" module="no" objc="no">maturity_base.hpp</includes>
    <class kind="struct">fims_popdy::LogisticMaturity</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>logistic.hpp</name>
    <path>inst/include/population_dynamics/selectivity/functors/</path>
    <filename>selectivity_2functors_2logistic_8hpp.html</filename>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">common/fims_math.hpp</includes>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">common/fims_vector.hpp</includes>
    <includes id="selectivity__base_8hpp" name="selectivity_base.hpp" local="yes" import="no" module="no" objc="no">selectivity_base.hpp</includes>
    <class kind="struct">fims_popdy::LogisticSelectivity</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>selectivity_base.hpp</name>
    <path>inst/include/population_dynamics/selectivity/functors/</path>
    <filename>selectivity__base_8hpp.html</filename>
    <includes id="model__object_8hpp" name="model_object.hpp" local="yes" import="no" module="no" objc="no">common/model_object.hpp</includes>
    <class kind="struct">fims_popdy::SelectivityBase</class>
    <namespace>fims_popdy</namespace>
  </compound>
  <compound kind="file">
    <name>selectivity.hpp</name>
    <path>inst/include/population_dynamics/selectivity/</path>
    <filename>selectivity_8hpp.html</filename>
    <includes id="double__logistic_8hpp" name="double_logistic.hpp" local="yes" import="no" module="no" objc="no">functors/double_logistic.hpp</includes>
    <includes id="selectivity_2functors_2logistic_8hpp" name="logistic.hpp" local="yes" import="no" module="no" objc="no">functors/logistic.hpp</includes>
    <includes id="selectivity__base_8hpp" name="selectivity_base.hpp" local="yes" import="no" module="no" objc="no">functors/selectivity_base.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fims_json.hpp</name>
    <path>inst/include/utilities/</path>
    <filename>fims__json_8hpp.html</filename>
    <class kind="class">fims::JsonValue</class>
    <class kind="class">fims::JsonParser</class>
  </compound>
  <compound kind="file">
    <name>data_object.cpp</name>
    <path>src/</path>
    <filename>data__object_8cpp.html</filename>
    <includes id="data__object_8hpp" name="data_object.hpp" local="yes" import="no" module="no" objc="no">../inst/include/common/data_object.hpp</includes>
  </compound>
  <compound kind="file">
    <name>def.cpp</name>
    <path>src/</path>
    <filename>def_8cpp.html</filename>
    <includes id="def_8hpp" name="def.hpp" local="yes" import="no" module="no" objc="no">../inst/include/common/def.hpp</includes>
  </compound>
  <compound kind="file">
    <name>distributions.cpp</name>
    <path>src/</path>
    <filename>distributions_8cpp.html</filename>
    <includes id="distributions_8hpp" name="distributions.hpp" local="yes" import="no" module="no" objc="no">../inst/include/distributions/distributions.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fims_json.cpp</name>
    <path>src/</path>
    <filename>fims__json_8cpp.html</filename>
    <includes id="fims__json_8hpp" name="fims_json.hpp" local="yes" import="no" module="no" objc="no">../inst/include/utilities/fims_json.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fims_math.cpp</name>
    <path>src/</path>
    <filename>fims__math_8cpp.html</filename>
    <includes id="fims__math_8hpp" name="fims_math.hpp" local="yes" import="no" module="no" objc="no">../inst/include/common/fims_math.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fims_modules.cpp</name>
    <path>src/</path>
    <filename>fims__modules_8cpp.html</filename>
  </compound>
  <compound kind="file">
    <name>fims_vector.cpp</name>
    <path>src/</path>
    <filename>fims__vector_8cpp.html</filename>
    <includes id="fims__vector_8hpp" name="fims_vector.hpp" local="yes" import="no" module="no" objc="no">../inst/include/common/fims_vector.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fisheries_models.cpp</name>
    <path>src/</path>
    <filename>fisheries__models_8cpp.html</filename>
    <includes id="fisheries__models_8hpp" name="fisheries_models.hpp" local="yes" import="no" module="no" objc="no">../inst/include/models/fisheries_models.hpp</includes>
  </compound>
  <compound kind="file">
    <name>fleet.cpp</name>
    <path>src/</path>
    <filename>fleet_8cpp.html</filename>
    <includes id="fleet_8hpp" name="fleet.hpp" local="yes" import="no" module="no" objc="no">../inst/include/population_dynamics/fleet/fleet.hpp</includes>
  </compound>
  <compound kind="file">
    <name>growth.cpp</name>
    <path>src/</path>
    <filename>growth_8cpp.html</filename>
    <includes id="growth_8hpp" name="growth.hpp" local="yes" import="no" module="no" objc="no">../inst/include/population_dynamics/growth/growth.hpp</includes>
  </compound>
  <compound kind="file">
    <name>information.cpp</name>
    <path>src/</path>
    <filename>information_8cpp.html</filename>
    <includes id="information_8hpp" name="information.hpp" local="yes" import="no" module="no" objc="no">../inst/include/common/information.hpp</includes>
  </compound>
  <compound kind="file">
    <name>interface.cpp</name>
    <path>src/</path>
    <filename>interface_8cpp.html</filename>
    <includes id="interface_8hpp" name="interface.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/interface.hpp</includes>
  </compound>
  <compound kind="file">
    <name>maturity.cpp</name>
    <path>src/</path>
    <filename>maturity_8cpp.html</filename>
    <includes id="maturity_8hpp" name="maturity.hpp" local="yes" import="no" module="no" objc="no">../inst/include/population_dynamics/maturity/maturity.hpp</includes>
  </compound>
  <compound kind="file">
    <name>model.cpp</name>
    <path>src/</path>
    <filename>model_8cpp.html</filename>
    <includes id="model_8hpp" name="model.hpp" local="yes" import="no" module="no" objc="no">../inst/include/common/model.hpp</includes>
  </compound>
  <compound kind="file">
    <name>population.cpp</name>
    <path>src/</path>
    <filename>population_8cpp.html</filename>
    <includes id="population_8hpp" name="population.hpp" local="yes" import="no" module="no" objc="no">../inst/include/population_dynamics/population/population.hpp</includes>
  </compound>
  <compound kind="file">
    <name>rcpp_data.cpp</name>
    <path>src/</path>
    <filename>rcpp__data_8cpp.html</filename>
    <includes id="rcpp__data_8hpp" name="rcpp_data.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_data.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_data</name>
      <anchorfile>rcpp__data_8cpp.html</anchorfile>
      <anchor>a42633b155364e08f66e421141a6094fe</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_distribution.cpp</name>
    <path>src/</path>
    <filename>rcpp__distribution_8cpp.html</filename>
    <includes id="rcpp__distribution_8hpp" name="rcpp_distribution.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_distribution.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_distributions</name>
      <anchorfile>rcpp__distribution_8cpp.html</anchorfile>
      <anchor>ae8d0a4da7edc84d14351aee560580023</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_fleet.cpp</name>
    <path>src/</path>
    <filename>rcpp__fleet_8cpp.html</filename>
    <includes id="rcpp__fleet_8hpp" name="rcpp_fleet.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_fleet.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_fleet</name>
      <anchorfile>rcpp__fleet_8cpp.html</anchorfile>
      <anchor>a34be2362a4846d2704fd67b440a397c6</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_functions.cpp</name>
    <path>src/</path>
    <filename>rcpp__functions_8cpp.html</filename>
    <includes id="rcpp__interface_8hpp" name="rcpp_interface.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_interface.hpp</includes>
    <includes id="rcpp__math_8hpp" name="rcpp_math.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_math.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_functions</name>
      <anchorfile>rcpp__functions_8cpp.html</anchorfile>
      <anchor>a33ddb25b30e800b3cbd7ba2201d180d2</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_growth.cpp</name>
    <path>src/</path>
    <filename>rcpp__growth_8cpp.html</filename>
    <includes id="rcpp__growth_8hpp" name="rcpp_growth.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_growth.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_growth</name>
      <anchorfile>rcpp__growth_8cpp.html</anchorfile>
      <anchor>a92b910d0f730346c4a5c2d7bfece24a5</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_interface_base.cpp</name>
    <path>src/</path>
    <filename>rcpp__interface__base_8cpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_interface_base.hpp</includes>
  </compound>
  <compound kind="file">
    <name>rcpp_maturity.cpp</name>
    <path>src/</path>
    <filename>rcpp__maturity_8cpp.html</filename>
    <includes id="rcpp__maturity_8hpp" name="rcpp_maturity.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_maturity.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_maturity</name>
      <anchorfile>rcpp__maturity_8cpp.html</anchorfile>
      <anchor>a773a7aa8219bb89dbb2f762c3b55a769</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_models.cpp</name>
    <path>src/</path>
    <filename>rcpp__models_8cpp.html</filename>
    <includes id="rcpp__models_8hpp" name="rcpp_models.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_models.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_fishery_models</name>
      <anchorfile>rcpp__models_8cpp.html</anchorfile>
      <anchor>ab4e3bedc47120961dc7b6f6a836b9dd1</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_natural_mortality.cpp</name>
    <path>src/</path>
    <filename>rcpp__natural__mortality_8cpp.html</filename>
    <includes id="rcpp__natural__mortality_8hpp" name="rcpp_natural_mortality.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_natural_mortality.hpp</includes>
  </compound>
  <compound kind="file">
    <name>rcpp_parameter.cpp</name>
    <path>src/</path>
    <filename>rcpp__parameter_8cpp.html</filename>
    <includes id="rcpp__interface__base_8hpp" name="rcpp_interface_base.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_interface_base.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_parameter</name>
      <anchorfile>rcpp__parameter_8cpp.html</anchorfile>
      <anchor>a06caf19387bb844186093aa04b7d3159</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>register_vectors</name>
      <anchorfile>rcpp__parameter_8cpp.html</anchorfile>
      <anchor>aedc20697f0e4349d2624d2780dc6673e</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_population.cpp</name>
    <path>src/</path>
    <filename>rcpp__population_8cpp.html</filename>
    <includes id="rcpp__population_8hpp" name="rcpp_population.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_population.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_population</name>
      <anchorfile>rcpp__population_8cpp.html</anchorfile>
      <anchor>a63e6c7f23783af6ea5728c118203730e</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_recruitment.cpp</name>
    <path>src/</path>
    <filename>rcpp__recruitment_8cpp.html</filename>
    <includes id="rcpp__recruitment_8hpp" name="rcpp_recruitment.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_recruitment.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_recruitment</name>
      <anchorfile>rcpp__recruitment_8cpp.html</anchorfile>
      <anchor>aceb941db40a811bc39d0bd65e9c230c5</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_selectivity.cpp</name>
    <path>src/</path>
    <filename>rcpp__selectivity_8cpp.html</filename>
    <includes id="rcpp__selectivity_8hpp" name="rcpp_selectivity.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_selectivity.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_selectivity</name>
      <anchorfile>rcpp__selectivity_8cpp.html</anchorfile>
      <anchor>a3405e23536afe4e0bcac20dd30537767</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>rcpp_shared_primitive.cpp</name>
    <path>src/</path>
    <filename>rcpp__shared__primitive_8cpp.html</filename>
    <includes id="rcpp__shared__primitive_8hpp" name="rcpp_shared_primitive.hpp" local="yes" import="no" module="no" objc="no">../inst/include/interface/rcpp/rcpp_objects/rcpp_shared_primitive.hpp</includes>
    <member kind="function">
      <type>void</type>
      <name>register_shared</name>
      <anchorfile>rcpp__shared__primitive_8cpp.html</anchorfile>
      <anchor>a3ac07e427da47af922ccfdf1730d193d</anchor>
      <arglist>(Rcpp::Module &amp;m)</arglist>
    </member>
  </compound>
  <compound kind="file">
    <name>recruitment.cpp</name>
    <path>src/</path>
    <filename>recruitment_8cpp.html</filename>
    <includes id="recruitment_8hpp" name="recruitment.hpp" local="yes" import="no" module="no" objc="no">../inst/include/population_dynamics/recruitment/recruitment.hpp</includes>
  </compound>
  <compound kind="file">
    <name>selectivity.cpp</name>
    <path>src/</path>
    <filename>selectivity_8cpp.html</filename>
    <includes id="selectivity_8hpp" name="selectivity.hpp" local="yes" import="no" module="no" objc="no">../inst/include/population_dynamics/selectivity/selectivity.hpp</includes>
  </compound>
  <compound kind="file">
    <name>TMB.cpp</name>
    <path>src/</path>
    <filename>TMB_8cpp.html</filename>
    <includes id="TMB_8h" name="TMB.h" local="yes" import="no" module="no" objc="no">../inst/include/interface/TMB/TMB.h</includes>
  </compound>
  <compound kind="class">
    <name>AgeCompDataInterface</name>
    <filename>classAgeCompDataInterface.html</filename>
    <base>DataInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>AgeCompDataInterface</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>aba9ad86a36f62bfe24adcc1e763b3e06</anchor>
      <arglist>(int ymax=0, int amax=0)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>AgeCompDataInterface</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a9cf58a72f2ea4653decd173df026840c</anchor>
      <arglist>(const AgeCompDataInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~AgeCompDataInterface</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a166f71a43a8c71e567bf8acb1d426d13</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a958c311a4133ca6866cb1b0622665948</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a2ff550b84e84b05fac80726c92944ba6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims_int</type>
      <name>amax</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a2aafb99b2f77dc32fa4772c637f3da16</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims_int</type>
      <name>ymax</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>ac072cfaa15008250fb4179b478eeab71</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>age_comp_data</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a8bf0c270b8e5f9c313a396420be73ed5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>uncertainty</name>
      <anchorfile>classAgeCompDataInterface.html</anchorfile>
      <anchor>a0581df6d887e1f986485a5ce9dad5127</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>BevertonHoltRecruitmentInterface</name>
    <filename>classBevertonHoltRecruitmentInterface.html</filename>
    <base>RecruitmentInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>BevertonHoltRecruitmentInterface</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>ae1bcd12bfe35ca1a70652f2118038fc5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>BevertonHoltRecruitmentInterface</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a806ad8496224971001a73770621abd17</anchor>
      <arglist>(const BevertonHoltRecruitmentInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~BevertonHoltRecruitmentInterface</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a6d47815b9315d537e414e8036bb10fd6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>aca73a10cce5316257a27744622cd4e13</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetRecruitmentProcessID</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a7e3cebb66c555d04c11e4d0ff2067de9</anchor>
      <arglist>(uint32_t process_id)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate_mean</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>af3f0a12d062eda9b4082994d0675e5e6</anchor>
      <arglist>(double spawners, double phi_0)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate_process</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a96c43dd3f7213fd1e054bf3de2f829d9</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a4e183cccdd0aac1162b621b663b2848a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a3fe268ea362772d045c4fe7618bcf8fc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_years</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a45c0aa26cd15b8c364a6a0fae7eaee7f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>logit_steep</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a3bed47b44fe4d76bd83cbe5ab656d5c3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_rzero</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a926b4044a3612a96d7d4a8ad482a0a14</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_devs</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a17e12fbcc067297e0c04e0c0b06c0226</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_r</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a8ebfb6ef34a93eef9143f181ca3cf7f3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_expected_recruitment</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>afb0dbdf4bf03b40220120f5bf27addb3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims_double</type>
      <name>estimated_logit_steep</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>ad6571c3071fbf8bc78d197180fc5eb2e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims_double</type>
      <name>estimated_log_rzero</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>a45acebd04427172c6029ea391f2ffcb2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>estimated_log_devs</name>
      <anchorfile>classBevertonHoltRecruitmentInterface.html</anchorfile>
      <anchor>aba2cd8724255cb55b9d341927471bd60</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims_popdy::CatchAtAge</name>
    <filename>classfims__popdy_1_1CatchAtAge.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::FisheryModelBase</base>
    <member kind="typedef">
      <type>std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt;::iterator</type>
      <name>derived_quantities_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a1149caa64c7cb14a93af4f87a3a01149</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>fleet_derived_quantities_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a98f3ae923dc0c7ab2f7f171b1e8873c9</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, fims::Vector&lt; size_t &gt; &gt; &gt;::iterator</type>
      <name>fleet_derived_quantities_dims_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>ad07ed62aee3a3421b83651cc53958d9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>population_derived_quantities_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a9a5f5b81f887323b99d648956c2f5add</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, fims::Vector&lt; size_t &gt; &gt; &gt;::iterator</type>
      <name>population_derived_quantities_dims_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a39033cb8a870b03026ed01fb3d2683f1</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>fleet_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a3c704d5d6890765f3e0582928c786add</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt;::iterator</type>
      <name>dq_iterator</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a0970c0c3a324482decf4ce64eacef293</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>CatchAtAge</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a7830c8f82e8a6158f83d4a765379ddf3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>CatchAtAge</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a6c621a6bc7cada49166db5fc96f32726</anchor>
      <arglist>(const CatchAtAge &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~CatchAtAge</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a670f526cd413fda8214e14e9cebcc18b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Initialize</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a1aa9b74e3ec96502d6b74c0b659c278c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Prepare</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>af0d27bcf828a778e839f3a8658c52135</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>AddPopulation</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>ac0b5da9501f105543cdd50f067d11da5</anchor>
      <arglist>(uint32_t id)</arglist>
    </member>
    <member kind="function">
      <type>std::set&lt; uint32_t &gt; &amp;</type>
      <name>GetPopulationIds</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a382a4867d21c9d9bf78534e3f4a29217</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &gt; &amp;</type>
      <name>GetPopulations</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>aca027997da78686a12f60bd6f26f40ea</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateInitialNumbersAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>aef21eca36133b6a5769ec676050a73d2</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateNumbersAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a9e5877ce7cc9b2093b14f0e5c5895674</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t i_agem1_yearm1, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateUnfishedNumbersAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a2876a340cab1830aff6110b8739d7e01</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t i_agem1_yearm1, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateMortality</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>addf4f18252cba85c7b770a215d828f02</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateBiomass</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a2a20ec050477f0e1c4de7780459f9aec</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateUnfishedBiomass</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a96fd50ab465e1028eb608d05bf3e5137</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateSpawningBiomass</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a739bfeeb1135d24fda13ea87d7ba7c4c</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateUnfishedSpawningBiomass</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a8f410d2daae27b9aaaf7c6a32f57ab49</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateSpawningBiomassRatio</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a037e412d2183c0a23ad3410f6b222ef1</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t year)</arglist>
    </member>
    <member kind="function">
      <type>Type</type>
      <name>CalculateSBPR0</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a15b4b7b778b0812fa9ea81e81571a877</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateRecruitment</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>ab3f51eeed2e951400a81fbd8c32b458e</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t i_dev)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateMaturityAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a996fba214e1f3601324ec06ed924d09b</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateLandings</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>ad8e81e9a6d6f819a2c3fb78367ecfea4</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateLandingsWeightAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>ac1003ebcd348e09e945cb4f55fce4ae9</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateLandingsNumbersAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>aa01ecd33d4d19d03cc4b31b3049f87d9</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateIndex</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a901059284bb502abd0f6a8f9252a275d</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateIndexNumbersAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>adfbcd55d8179b561d3d4e788fa63e661</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t i_age_year, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CalculateIndexWeightAA</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a498396134f360e7243f0eb5605360a20</anchor>
      <arglist>(std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &amp;population, size_t year, size_t age)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>evaluate_age_comp</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a4b7f463cdd464efc2c056a5b8328cec8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>evaluate_length_comp</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a6270771e42f11407eb87b099087b1b55</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>evaluate_index</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>afd9d2e41729f03ac80fd1d449bb6d8f9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>evaluate_landings</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>ab529865b281351f69678c6fe31df1607</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Evaluate</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a84c67ee2edf996a8f3cf736801a6eeb6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Report</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>abf6dab88981668c7bf763590fa2ad43d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>name_m</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a85beced6c3db3298b38f5d9e6c95472e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; std::string, fims::Vector&lt; fims::Vector&lt; Type &gt; &gt; &gt;</type>
      <name>report_vectors</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a30de85a9a907124a9a57243eccaa2a23</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type &gt;</type>
      <name>ages</name>
      <anchorfile>classfims__popdy_1_1CatchAtAge.html</anchorfile>
      <anchor>a25dc53adfee64cb0e8526e776e15bb0a</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>CatchAtAgeInterface</name>
    <filename>classCatchAtAgeInterface.html</filename>
    <base>FisheryModelInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>CatchAtAgeInterface</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a2f40337bf1b5afb9117f630cb014bdfc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>CatchAtAgeInterface</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>aaf96c4d0495946bba753752bd9a36e4f</anchor>
      <arglist>(const CatchAtAgeInterface &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>AddPopulation</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a29e9d0477888fd0520a23121641f6a52</anchor>
      <arglist>(uint32_t id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>DoReporting</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a34b10a041e691c72d7ac5cacc2411a73</anchor>
      <arglist>(bool report)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsReporting</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>ababc562cfa4f58d4ca39be9cd2967256</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a7bdfe469de81b88c082b37fe36dab1d6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a2db07cca50b03739a4fb0872a7e95c4b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>population_to_json</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>aa60e84b3fd7627c4bfd45ba172c051f1</anchor>
      <arglist>(PopulationInterface *population_interface)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>derived_quantity_to_json</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a2d23ba483f90d70ed3c7068539ecd912</anchor>
      <arglist>(std::map&lt; std::string, fims::Vector&lt; double &gt; &gt;::iterator it, const fims_popdy::DimensionInfo &amp;dim_info)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>derived_quantities_component_to_json</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a9b3d2ac87f0322e9b45b7be4bde8d504</anchor>
      <arglist>(std::map&lt; std::string, fims::Vector&lt; double &gt; &gt; &amp;dqs, std::map&lt; std::string, fims_popdy::DimensionInfo &gt; &amp;dim_info)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>fleet_to_json</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a8f08bf8a25a002f967b9ef4db74947b3</anchor>
      <arglist>(FleetInterface *fleet_interface)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classCatchAtAgeInterface.html</anchorfile>
      <anchor>a1c4ce93749a4b7a8375f077b3d134657</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>DataInterfaceBase</name>
    <filename>classDataInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>DataInterfaceBase</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a440fbc882d52e8239332127f1ec041d3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DataInterfaceBase</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>aca0d8514b86ff19f3fc63cd922d603b8</anchor>
      <arglist>(const DataInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~DataInterfaceBase</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a3bf54a43965ae51e7a881f359fa0019b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a8d30820bf47a4312f6d51c45f395d9e6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>add_to_fims_tmb</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a330a22bd2b5488b310024342338933c5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>Rcpp::NumericVector</type>
      <name>observed_data</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>af9ee39d3918b797fd8f5b59b73865530</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>Rcpp::NumericVector</type>
      <name>uncertainty</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a92113c5294f746f9131970607842bc45</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a88e19c1bbcc54def5095ce57143ad484</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>a66892533bbb1380c43244b07c7308b9e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; DataInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classDataInterfaceBase.html</anchorfile>
      <anchor>acbb666ccdcabb73835493ff6071ccc40</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_data_object::DataObject</name>
    <filename>structfims__data__object_1_1DataObject.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>DataObject</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a6c63a636143aa724ed44992ff3866464</anchor>
      <arglist>(size_t imax)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DataObject</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a9564db3e53b2c512b80342c6ae62c46d</anchor>
      <arglist>(size_t imax, size_t jmax)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DataObject</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a22b405d140971c50550a83156e0b0739</anchor>
      <arglist>(size_t imax, size_t jmax, size_t kmax)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DataObject</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a93307f3a1c9995c39a9ca51a03d50b65</anchor>
      <arglist>(size_t imax, size_t jmax, size_t kmax, size_t lmax)</arglist>
    </member>
    <member kind="function">
      <type>Type</type>
      <name>operator()</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a110dbc634a3560a541f21fa91d429d97</anchor>
      <arglist>(size_t i)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>at</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>ac44900b410e637e18c24678fad12d219</anchor>
      <arglist>(size_t i)</arglist>
    </member>
    <member kind="function">
      <type>const Type</type>
      <name>operator()</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a1fa44b2485782c682eb55d0d75274eef</anchor>
      <arglist>(size_t i, size_t j)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>at</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>af32508fb6358cfa20084fc474a8f3620</anchor>
      <arglist>(size_t i, size_t j)</arglist>
    </member>
    <member kind="function">
      <type>const Type</type>
      <name>operator()</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a407cf5ac3501eff0826d02a57aaaae47</anchor>
      <arglist>(size_t i, size_t j, size_t k)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>at</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a076ab26a6bca0d65aa81da0f14e87b56</anchor>
      <arglist>(size_t i, size_t j, size_t k)</arglist>
    </member>
    <member kind="function">
      <type>const Type</type>
      <name>operator()</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>aacca2ceb7aebd125c99fb0f1a3bd3944</anchor>
      <arglist>(size_t i, size_t j, size_t k, size_t l)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>at</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>ab4927a82082045cacff09ee6360d331a</anchor>
      <arglist>(size_t i, size_t j, size_t k, size_t l)</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_dimensions</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a001b4ac56042f5ea32a25d8c20e8757b</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_imax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a1542f52040fa2542afe713448e03b304</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_jmax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a5470cadac16a5928af44aca733013257</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_kmax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>ac87263c8c75eecbe2093f2b425092861</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_lmax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a607113d81db404f0b1eebff11bffce61</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>data</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a5a70057baf089c02b03f8c53890d3cf0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>uncertainty</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a2f8a5e4b6a6b203cd1c3539dff660019</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>dimensions</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>ad407ca752c73714b8852b894b3a76026</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>imax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a7056b3ea27c50c5a3e86575bc81b826c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>jmax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>adeac7e86caf7ed8b6bd891eff87abeb6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>kmax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a1f224a8a381eddc0286f044dc087c686</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>lmax</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a0f1903e29547d7e716c6a6c3300b2480</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>Type</type>
      <name>na_value</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>a64125aaf71ef4e1ab18ec4a1d6a64b7e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__data__object_1_1DataObject.html</anchorfile>
      <anchor>aebbddd354e62e177e1043fb71f1f5707</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_distributions::DensityComponentBase</name>
    <filename>structfims__distributions_1_1DensityComponentBase.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type>Type &amp;</type>
      <name>get_observed</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a88ad0c85be4d5d6abedab5641ee03c03</anchor>
      <arglist>(size_t i)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>get_observed</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>afa63be85af143b368f5ea90e36d361da</anchor>
      <arglist>(size_t i, size_t j)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>get_expected</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a1a4855d5255ca42c1fb52e57fe98c41d</anchor>
      <arglist>(size_t i)</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_n_x</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a870507987f001041dee9f41b3c8b41c4</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_n_expected</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a81ffea453315dd49adc2c44ebed7eef3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DensityComponentBase</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a7a2908958732ab755caccc7a65b0a514</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a7b7536012f1fca930b11f7035aee8940</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>input_type</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a8be921f03a3ddd61dc806116d1bead9e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt;</type>
      <name>data_observed_values</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>ac743ea47274d4a25195bee99f15aef72</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>expected_values</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>aaad587f3651db4acddf855ca8d217c5d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt; *</type>
      <name>re</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a8b75239aac8c9ca8911e68c54ac9d73d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt; *</type>
      <name>re_expected_values</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>ab95f7bcda5a96b40d1d5ea6e127f54c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt; *</type>
      <name>data_expected_values</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a73823b1bb84414a939e3eec101dfdd1d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; fims::Vector&lt; Type &gt; * &gt;</type>
      <name>priors</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>af0f9cbf31816b7d9a3c30ec6129d099a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>observed_values</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a09691bc1d7f187758b589cfbf3da10e9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>expected_mean</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>afb97e4ee7b75a1bea37fa7671a3e2498</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>use_mean</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a05e0ce908ecb58f7a24cd519ab6c45b8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>Type</type>
      <name>lpdf</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a57bd8cad0df41793f3b00dd5cdc73f80</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>observed_data_id_m</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>ae7d5d01278616316479ac9e6714a9b7f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>lpdf_vec</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a08bb15b9414a58a745546eb53a683474</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>osa_flag</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a2c61d62adbd802dcac6a689db3ef7b9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>simulate_flag</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a1890ac36bc9150d388a6976965423a83</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; uint32_t &gt;</type>
      <name>key</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>a0232bd6e20b7b48685534e3d804178ac</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__distributions_1_1DensityComponentBase.html</anchorfile>
      <anchor>ac79ada5bd797d484865d437202dbc7bc</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::DimensionInfo</name>
    <filename>structfims__popdy_1_1DimensionInfo.html</filename>
    <member kind="function">
      <type></type>
      <name>DimensionInfo</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>a460fe99e6af190d53e8fd2747b65729e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DimensionInfo</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>aa65299e9f98b5499639c88fc5645d0ca</anchor>
      <arglist>(const std::string &amp;name, const fims::Vector&lt; int &gt; &amp;dims, const fims::Vector&lt; std::string &gt; &amp;dim_names)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DimensionInfo</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>a6b4d850fa2c23bf5e88ab4e550eac263</anchor>
      <arglist>(const DimensionInfo &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>DimensionInfo &amp;</type>
      <name>operator=</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>aad4487ae10ebae7f4f9f1ff120f0cf99</anchor>
      <arglist>(const DimensionInfo &amp;other)</arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>name</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>a32f714baf402d3afb686e860ac4cd78d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>ndims</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>a7f807a516506e8358ba3ffa4aa1e6fcc</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; int &gt;</type>
      <name>dims</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>a273540d1f3d941e7b7fbb03adc4a09f1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; std::string &gt;</type>
      <name>dim_names</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>ad9b1efaf1acb13caa7f62728d03f70d3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; double &gt;</type>
      <name>se_values_m</name>
      <anchorfile>structfims__popdy_1_1DimensionInfo.html</anchorfile>
      <anchor>a80f1d3b5124c10c8b7091cdc6b9ead3b</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>DistributionsInterfaceBase</name>
    <filename>classDistributionsInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>DistributionsInterfaceBase</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>afd3dd648eca4947c794973ef184e6b70</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DistributionsInterfaceBase</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a5024a4a0e2bc922354f5af0df9976f77</anchor>
      <arglist>(const DistributionsInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~DistributionsInterfaceBase</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a058951fc7d22a7a9a1e6f61bf287d7a9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>ac2c9fafbff23443ff4b5d9a9bee56c08</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_distribution_links</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>ae8e42238a8b6e6cffbfbd9ac5a04d821</anchor>
      <arglist>(std::string input_type, Rcpp::IntegerVector ids)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_distribution_mean</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>ae5ee1ee2b9d117aecc7396e442b48b2f</anchor>
      <arglist>(double input_value)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_observed_data</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a0071e40d5d56d8b1a2e5bf3c65edb45f</anchor>
      <arglist>(int observed_data_id)</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a09877510b57140479092bcacb0843703</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id_m</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a59f4650de07c713946705e940bd1b5cd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; std::vector&lt; uint32_t &gt; &gt;</type>
      <name>key_m</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a3b021b76b77b2dc31b529875de79fdc3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>input_type_m</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>af64d56001f37f47acef0684814d50a5a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>use_mean_m</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>ad3be554775b37d5cb817af2c50e0fc60</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>interface_observed_data_id_m</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>ae0bcce99577896f4a18c7f1099cd6145</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>lpdf_value</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>a0364a4456745755b92c13378f688c517</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>af2f7855cea3e05c6b3db1984dbf9b499</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; DistributionsInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classDistributionsInterfaceBase.html</anchorfile>
      <anchor>af5a8c17c32f4f64e86f88611e1afc323</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>DlnormDistributionsInterface</name>
    <filename>classDlnormDistributionsInterface.html</filename>
    <base>DistributionsInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>DlnormDistributionsInterface</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a3084fde7dbe5abb05e1c4ae037e827ba</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DlnormDistributionsInterface</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a19950a0800c244cd43e08890961b7d9e</anchor>
      <arglist>(const DlnormDistributionsInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~DlnormDistributionsInterface</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>ae2e9cf0837f5e99d5deb3bde99862c63</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a411957c11ce877c2ed02cc4819e90275</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_observed_data</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>aa23722eca1575ce5d84d97d38c2432af</anchor>
      <arglist>(int observed_data_id)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_distribution_links</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a10ac2011304c6eacd70aa65d6d57510c</anchor>
      <arglist>(std::string input_type, Rcpp::IntegerVector ids)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a68777a22e7fe70b95ad7738f682a5284</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>ab36f839177897079f1accf827a25487d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a36b83f73e6bef702b5435cd3471e92ee</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>observed_values</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a731a805f4d075d438135d3a4ba4414a4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>expected_values</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a34ff4c41bc72eab179e3a8b617354cba</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_sd</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>a8491faa65e18ae6abadc989775ae7309</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>lpdf_vec</name>
      <anchorfile>classDlnormDistributionsInterface.html</anchorfile>
      <anchor>afd3831940b1df9108e630c5380a678eb</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>DmultinomDistributionsInterface</name>
    <filename>classDmultinomDistributionsInterface.html</filename>
    <base>DistributionsInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>DmultinomDistributionsInterface</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>ac1ed630a79958943010b5d8dd43b3a18</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DmultinomDistributionsInterface</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>ad48984336af39c73d6590461d0666692</anchor>
      <arglist>(const DmultinomDistributionsInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~DmultinomDistributionsInterface</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>af710dc2d861240117e99fbdb2ab78567</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a40dc05d944bab718c046a56b8496fc48</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_observed_data</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a95323ebe970b12b73749d824d61d16ea</anchor>
      <arglist>(int observed_data_id)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_distribution_links</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a0731b55cd8a154646af138990737cade</anchor>
      <arglist>(std::string input_type, Rcpp::IntegerVector ids)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_note</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a84a0bde120a6307cf02fcfdc38f3866e</anchor>
      <arglist>(std::string note)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a77bbdfb9f8849ca0288a76a88d1fdf2b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>finalize</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a74fa4981d0698447ac7a1bd7f4916b8d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>ac41624db2ed049445240e0b83793ae21</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>observed_values</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a7b5ce66ecb2d70d00f29a195e6bf0dbd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>expected_values</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a63619adb012ab0dd45742eb125654b06</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>dims</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>aa8dd20f0a80e26733c7e70ca27fab55d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>lpdf_vec</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>aceae16a92080ad46edfbc5062d69792a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>notes</name>
      <anchorfile>classDmultinomDistributionsInterface.html</anchorfile>
      <anchor>a126a9417e1c95bd2261ad41fbfdce06e</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>DnormDistributionsInterface</name>
    <filename>classDnormDistributionsInterface.html</filename>
    <base>DistributionsInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>DnormDistributionsInterface</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a32d211998d5283f1898688d2b8914ac9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>DnormDistributionsInterface</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a1ca0066f5d382c960a2006c4f79fdaea</anchor>
      <arglist>(const DnormDistributionsInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~DnormDistributionsInterface</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a449e7a2acd6b4a125f0ec13fff3e35eb</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>af9d46a592495997817ca5eb2276aac29</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_observed_data</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>ab2234ef63d314d70a9367053042c23a0</anchor>
      <arglist>(int observed_data_id)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_distribution_mean</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>abe721b78cee521cf61f350f1523749ec</anchor>
      <arglist>(double input_value)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>set_distribution_links</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>ae5d27b7117db5c5308eff738689f43e4</anchor>
      <arglist>(std::string input_type, Rcpp::IntegerVector ids)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a51741d62c5fef4c1ba89d6f9a40584aa</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a99391c0d44d07389f8f0d692d0008649</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a3ac41c008229d455fc81b9893decd3a7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>observed_values</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>ab3fd79651ea01148c9e231e2a61ecfd5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>expected_values</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a52b505e82789482f43f8be3462cf73d0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>expected_mean</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a2a9c2c77c88f5130b7bfffc2422e0d63</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_sd</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>adaaca1b7c950e10ab4be5ca3ba25e0a6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>lpdf_vec</name>
      <anchorfile>classDnormDistributionsInterface.html</anchorfile>
      <anchor>a4e19322d31fc600f83b3a4fbbb393768</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::DoubleLogisticSelectivity</name>
    <filename>structfims__popdy_1_1DoubleLogisticSelectivity.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::SelectivityBase</base>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1DoubleLogisticSelectivity.html</anchorfile>
      <anchor>aede0b00bd179b32cce3c4f4a72eb8906</anchor>
      <arglist>(const Type &amp;x)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1DoubleLogisticSelectivity.html</anchorfile>
      <anchor>a1e7bb5aec1ea0f33d34a45a21668504f</anchor>
      <arglist>(const Type &amp;x, size_t pos)</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>inflection_point_asc</name>
      <anchorfile>structfims__popdy_1_1DoubleLogisticSelectivity.html</anchorfile>
      <anchor>a348cb4cb039f38b306ddbc333f1beeb2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>slope_asc</name>
      <anchorfile>structfims__popdy_1_1DoubleLogisticSelectivity.html</anchorfile>
      <anchor>aa0d98542e054ce41349747abcbedff13</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>inflection_point_desc</name>
      <anchorfile>structfims__popdy_1_1DoubleLogisticSelectivity.html</anchorfile>
      <anchor>ad3895399f362da4ac9ec11cb33f47b9e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>slope_desc</name>
      <anchorfile>structfims__popdy_1_1DoubleLogisticSelectivity.html</anchorfile>
      <anchor>ac4c70f550f23d0a4cd97c402f6e3fff3</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>DoubleLogisticSelectivityInterface</name>
    <filename>classDoubleLogisticSelectivityInterface.html</filename>
    <base>SelectivityInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>DoubleLogisticSelectivityInterface</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a3a1319f3bec34a62e106839824fb0454</anchor>
      <arglist>(const DoubleLogisticSelectivityInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a59dc01d2779fd81152156a19dae62fcf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a46f7ef01f5c8e07568d38499a9f66245</anchor>
      <arglist>(double x)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>ae35e641acb050c1311154539e16ecdf3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a99e6d2a07db1738ad10e33b7c786a881</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>inflection_point_asc</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a47c30330966f4c4be60d469ff7d01d60</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>slope_asc</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a4571cc0b0713c0f9a8c5078dbe5b1033</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>inflection_point_desc</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a2a61582c3d83f94ddc17f5ddb01e8e89</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>slope_desc</name>
      <anchorfile>classDoubleLogisticSelectivityInterface.html</anchorfile>
      <anchor>a11333991775c1771dcdbb80704a90972</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::EWAAGrowth</name>
    <filename>structfims__popdy_1_1EWAAGrowth.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::GrowthBase</base>
    <member kind="typedef">
      <type>std::map&lt; double, double &gt;::iterator</type>
      <name>weight_iterator</name>
      <anchorfile>structfims__popdy_1_1EWAAGrowth.html</anchorfile>
      <anchor>a9790142135568ea1e69c6666f44ae090</anchor>
      <arglist></arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1EWAAGrowth.html</anchorfile>
      <anchor>ad8e729b359f20643ad7f13991e99e96e</anchor>
      <arglist>(int year, const double &amp;a)</arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; int, std::map&lt; double, double &gt; &gt;</type>
      <name>ewaa</name>
      <anchorfile>structfims__popdy_1_1EWAAGrowth.html</anchorfile>
      <anchor>a3c54ad644b0fd385ddca9779cacec767</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>EWAAGrowthInterface</name>
    <filename>classEWAAGrowthInterface.html</filename>
    <base>GrowthInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>EWAAGrowthInterface</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>ac9de3808eb2091d3fff3379539c366ea</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>EWAAGrowthInterface</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a8aaa96ddc471e7afcad97443c8141f3f</anchor>
      <arglist>(const EWAAGrowthInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~EWAAGrowthInterface</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a0635d9ac538ed986785ec6e89134a1c1</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a4724c0195fe5e66c957fed02eee23ce2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; int, std::map&lt; double, double &gt; &gt;</type>
      <name>make_map</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a91aeea13acd1864aef72e811e9647fc9</anchor>
      <arglist>(RealVector ages, RealVector weights, SharedInt n_years)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a79ab161d68d4d2c5b2854cb43775483c</anchor>
      <arglist>(double age)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>ae879683aa137986bded7572f0d4d4095</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>weights</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>ab8265890b9f73d9f75f80c0eb81f561f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>ages</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a73a4b7c681da31c863f48f4f6898f892</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_years</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a236087f14388a6d2e5b9da1558d67947</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; std::map&lt; int, std::map&lt; double, double &gt; &gt; &gt;</type>
      <name>ewaa</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a44df5d1ffc87ef519cd894f678f3ae96</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>initialized</name>
      <anchorfile>classEWAAGrowthInterface.html</anchorfile>
      <anchor>a9cc2d5f9d01adeacf478f938be9c688a</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims::FIMSLog</name>
    <filename>classfims_1_1FIMSLog.html</filename>
    <member kind="function">
      <type></type>
      <name>FIMSLog</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>aa766eb84784fa15a905bec91f03ba920</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~FIMSLog</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>ad32e96778496a16f9a943f405c3956a9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::filesystem::path</type>
      <name>getAbsolutePathWithoutDotDot</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>ad7154dafdf1833d73313bed1820ad858</anchor>
      <arglist>(const std::filesystem::path &amp;relativePath)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_path</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>acdbdf84d23788e3088e664361b1cba8b</anchor>
      <arglist>(std::string path)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_path</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a7376991d4437a576854c8d291b87624e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>info_message</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>aec8a86ce4a58393a028983d55d8e38bf</anchor>
      <arglist>(std::string str, int line, const char *file, const char *func)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>error_message</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a18a705c8e1094b56390a7dd9f441d724</anchor>
      <arglist>(std::string str, int line, const char *file, const char *func)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>warning_message</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a3d2755bc4efa212c6c5c975f16132376</anchor>
      <arglist>(std::string str, int line, const char *file, const char *func)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_log</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a3d041abb4f0e14f6e37828e06483d274</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_errors</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>abd24b5080409560f74311cc0e4f22748</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_warnings</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a705132e231e03b37e6a47d6538439856</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_info</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>afb81bfc20f758956b47d44b4cf454d4d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_error_count</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>aec60cfc5ad2b61d46557991af9bb3d4a</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>get_warning_count</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a3f29deca2e719527af53ef5c77e3548e</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>clear</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a1bd3de73d5a5a6727e3f2b3bd8d4c43c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>write_on_exit</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a1f92030e24364caa377ca4ba1174a1be</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>throw_on_error</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a26d3d3b190fb352e3c4d8cd03c57397f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::shared_ptr&lt; FIMSLog &gt;</type>
      <name>fims_log</name>
      <anchorfile>classfims_1_1FIMSLog.html</anchorfile>
      <anchor>a942fd5b6d134573af288c0a986831ffd</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_model_object::FIMSObject</name>
    <filename>structfims__model__object_1_1FIMSObject.html</filename>
    <templarg>typename Type</templarg>
    <member kind="function">
      <type>uint32_t</type>
      <name>GetId</name>
      <anchorfile>structfims__model__object_1_1FIMSObject.html</anchorfile>
      <anchor>a7f1a6d1474f8ad7d8b460ce889ee6ebd</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>CheckDimensions</name>
      <anchorfile>structfims__model__object_1_1FIMSObject.html</anchorfile>
      <anchor>a81239daf538745bbb96c56f627edc781</anchor>
      <arglist>(size_t actual, size_t expected)</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>structfims__model__object_1_1FIMSObject.html</anchorfile>
      <anchor>a3922946642efc5ec4309149f1e0b188a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type * &gt;</type>
      <name>parameters</name>
      <anchorfile>structfims__model__object_1_1FIMSObject.html</anchorfile>
      <anchor>ac625a90f1af6d01d8c476d0a1ecb5343</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type * &gt;</type>
      <name>random_effects_parameters</name>
      <anchorfile>structfims__model__object_1_1FIMSObject.html</anchorfile>
      <anchor>a9d8ddb11af5bb51a811f7d4c855f49b3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type * &gt;</type>
      <name>fixed_effects_parameters</name>
      <anchorfile>structfims__model__object_1_1FIMSObject.html</anchorfile>
      <anchor>aca6a96ab8e6a4cca573daa5f52e71c67</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>FIMSRcppInterfaceBase</name>
    <filename>classFIMSRcppInterfaceBase.html</filename>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>add_to_fims_tmb</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>a9183d9379777d8be70ab66af1a07f94c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>abdfb6b47bd4ea86042f84590236036d7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>aa97acd77c0c4d2e193c67cd0662d803c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>value_to_string</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>a46e0ce655ef707a6c66e863aa4f0b374</anchor>
      <arglist>(double value)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>make_dimensions</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>a1fa6e0deb883a921fe70b328cdd30fee</anchor>
      <arglist>(uint32_t start, uint32_t end, uint32_t rep=1)</arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>finalized</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>a44e4e3b1dd18103bf79ccb30a76f5933</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::vector&lt; std::shared_ptr&lt; FIMSRcppInterfaceBase &gt; &gt;</type>
      <name>fims_interface_objects</name>
      <anchorfile>classFIMSRcppInterfaceBase.html</anchorfile>
      <anchor>a66ae9ad9c0adae77184eefa59e283c5e</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims_popdy::FisheryModelBase</name>
    <filename>classfims__popdy_1_1FisheryModelBase.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>fleet_iterator</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a80ec8af64c49e7da16332427f4964382</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt; &gt;</type>
      <name>DerivedQuantitiesMap</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a1c7499d26ff106bb6a49e06bfb389fdf</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>DerivedQuantitiesMap::iterator</type>
      <name>DerivedQuantitiesMapIterator</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a06dfbb97663ee69d7eb30823dfdbd481</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, DimensionInfo &gt; &gt;</type>
      <name>DimensionInfoMap</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a5d46305b9a669a2e848c260e48380e16</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>FisheryModelBase</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a0e02fc17d15175fae2381ff6be0a05a9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>FisheryModelBase</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a294b383d2ffbbfead3a45550f705d6a9</anchor>
      <arglist>(const FisheryModelBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~FisheryModelBase</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a5e4291cd1b6aa8835e005299659053a7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, DimensionInfo &gt; &gt; &amp;</type>
      <name>GetFleetDimensionInfo</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>ae08a3a60d70f76854d53a4c5feac3db8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; uint32_t, std::map&lt; std::string, DimensionInfo &gt; &gt; &amp;</type>
      <name>GetPopulationDimensionInfo</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a75833099950f2296ffb1bec7342e5833</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>DerivedQuantitiesMap &amp;</type>
      <name>GetFleetDerivedQuantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a4572a21c5fbcbe2e53a282c4aeed36dc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>DerivedQuantitiesMap &amp;</type>
      <name>GetPopulationDerivedQuantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a983f8cfc4b5d370a2c79cec270734fda</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt; &amp;</type>
      <name>GetFleetDerivedQuantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a4baf2334e5a8320f46dddbb10ed66240</anchor>
      <arglist>(uint32_t fleet_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>InitializeFleetDerivedQuantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a490871dc32791518446e9ae8945e7975</anchor>
      <arglist>(uint32_t fleet_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>InitializePopulationDerivedQuantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a417287180a5d40eb17282a190c3ac8db</anchor>
      <arglist>(uint32_t population_id)</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; std::string, fims::Vector&lt; Type &gt; &gt; &amp;</type>
      <name>GetPopulationDerivedQuantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a4f154744d1e34692b7db06fd43fed8c9</anchor>
      <arglist>(uint32_t population_id)</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; std::string, DimensionInfo &gt; &amp;</type>
      <name>GetFleetDimensionInfo</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a5ea0d2740b2cac0ec4d54401fbd52c8c</anchor>
      <arglist>(uint32_t fleet_id)</arglist>
    </member>
    <member kind="function">
      <type>std::map&lt; std::string, DimensionInfo &gt; &amp;</type>
      <name>GetPopulationDimensionInfo</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a526ba6a0d8c53287ef6a78bf832b5139</anchor>
      <arglist>(uint32_t population_id)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Initialize</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a5bd00f10b732406c5b11919d62cc87ab</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Prepare</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>ae9f5db1ab4ec1337f4221a4cd2ad67c9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>ResetVector</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>ab755a0916428375053ade26191ff76a0</anchor>
      <arglist>(fims::Vector&lt; Type &gt; &amp;v, Type value=0.0)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Evaluate</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a259bb2cc579b7b7710a0b5573968383c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>Report</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>abeb7bd84d2c45be018cc41549eeb65d5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>uint32_t</type>
      <name>GetId</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a051594cf3073d2221962833733167ff3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>model_type_m</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a447bcdf764fc22206d311aa7e36e5c8f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::set&lt; uint32_t &gt;</type>
      <name>population_ids</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a4a544df4aaafba610711af17a8327a4b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &gt;</type>
      <name>populations</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a20d760548c290700f2148e911727b22d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; &gt;</type>
      <name>fleets</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a0613bad21950ad03cf6e8a97077ee667</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; DerivedQuantitiesMap &gt;</type>
      <name>fleet_derived_quantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a8e6c66b78cf5afc3c6508ae383d33bc4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; DerivedQuantitiesMap &gt;</type>
      <name>population_derived_quantities</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a573b075bdd228855c49527a4efd9fc05</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; DimensionInfoMap &gt;</type>
      <name>fleet_dimension_info</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a8e6b0921b0c4800371e4833ccc52c7be</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; DimensionInfoMap &gt;</type>
      <name>population_dimension_info</name>
      <anchorfile>classfims__popdy_1_1FisheryModelBase.html</anchorfile>
      <anchor>a0272c60bb2e8298ca55e35ce0af5e4db</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>FisheryModelInterfaceBase</name>
    <filename>classFisheryModelInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>FisheryModelInterfaceBase</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>a8b382c1cc43d0343d8da46487f4c9693</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>FisheryModelInterfaceBase</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>a1ce395c6660095f11411431fdd570995</anchor>
      <arglist>(const FisheryModelInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~FisheryModelInterfaceBase</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>afc875cceae839ade097b065a0dfdf930</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>acda4ae1beacd1cd075898b5b09c1ed81</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>a57c422df7fa5a40495e1fe21496c4830</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::NumericVector</type>
      <name>get_fixed_parameters_vector</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>ae94f8778da8069e63f29c1d0a05d2cfd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::NumericVector</type>
      <name>get_random_parameters_vector</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>ae4965acc6bcbeb26494532bfd0dabfd8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>sum</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>ae01554532f799c6c579bcda39f91e8fa</anchor>
      <arglist>(const std::valarray&lt; double &gt; &amp;v)</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>sum</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>afe39cc9103addb408671a6b4969daa37</anchor>
      <arglist>(const std::vector&lt; double &gt; &amp;v)</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>min</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>a04bf9092ad891e8286e2e2ce55108ffa</anchor>
      <arglist>(const std::valarray&lt; double &gt; &amp;v)</arglist>
    </member>
    <member kind="function">
      <type>std::valarray&lt; double &gt;</type>
      <name>fabs</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>ab9e041df1e1cb721164cca2ac5d2d5db</anchor>
      <arglist>(const std::valarray&lt; double &gt; &amp;v)</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>ab21552139e7bd8abfa512bcd1871ab53</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>a2cd6b6f28ac371e5f2729667f17fb958</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; FisheryModelInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>ad5438699ad902dd1d9d9f3b086fb08f9</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef" protection="protected">
      <type>std::set&lt; uint32_t &gt;::iterator</type>
      <name>population_id_iterator</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>aa585905560a011a2f76044e8072e478f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="protected">
      <type>std::shared_ptr&lt; std::set&lt; uint32_t &gt; &gt;</type>
      <name>population_ids</name>
      <anchorfile>classFisheryModelInterfaceBase.html</anchorfile>
      <anchor>aed724f1826987211b33db52450ca5441</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::Fleet</name>
    <filename>structfims__popdy_1_1Fleet.html</filename>
    <templarg>class Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>Fleet</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a1aaf947b159a58a5d23d78e55c34a4fd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~Fleet</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a8daf372e70483efaeba014d5ebf7500b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Prepare</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a889b7e1e0b2aa9f4a3114d3d6f8ad577</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_years</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a6391035016ec648ac6c3d2891dc6fb25</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_ages</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a8d3723853194985d3cc6645bb8fa206d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_lengths</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>af145559ff2e9e95609c6520f912163f6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>fleet_selectivity_id_m</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a3bfbbc0bf021aa8f6f2730d42027d17d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; SelectivityBase&lt; Type &gt; &gt;</type>
      <name>selectivity</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a260427acb5128fa3303459de353c048c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>fleet_observed_landings_data_id_m</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>accf7e5aec5b184c87b9f6e9d022a5348</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt;</type>
      <name>observed_landings_data</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>abcc5c15bc181b12eaa72a50a0dc912ca</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>observed_landings_units</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a04ae2b0b588d2a3bbe9bc841ca6ff51a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>fleet_observed_index_data_id_m</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>ab8fa4db5de7dba45fece778e182d4e27</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt;</type>
      <name>observed_index_data</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a6c6fde31050e3ea49f38ecbc694ffff6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>observed_index_units</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>affcc5764fce7eba009ba13845dedc962</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>fleet_observed_agecomp_data_id_m</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a650c1f21f4efce9a78472408e4abd2d2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt;</type>
      <name>observed_agecomp_data</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a4eacf98c97dedaf93c7d7fec4107eace</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>fleet_observed_lengthcomp_data_id_m</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a33da0d3b4445a9407bd1d22ba1c7e31f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt;</type>
      <name>observed_lengthcomp_data</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>aa04ae98c8bab390e30431c8d046958c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_Fmort</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>ac572ee8c2fc48c99544ed01ae284c6e7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_q</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a1e49af4939f8a9f32d76b354a4cf7581</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>Fmort</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a78cadc41e2e95ece2282873ad8e3b2b4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>q</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a9dbf02a91350fb062adc9ded0a89c66e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>age_to_length_conversion</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>ab0ba9edd8d93288939648869c2ab6996</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__popdy_1_1Fleet.html</anchorfile>
      <anchor>a278d9ec006b19fdaccec3ea13ea1e1b2</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>FleetInterface</name>
    <filename>classFleetInterface.html</filename>
    <base>FleetInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>FleetInterface</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>ac16abdc18e1ddf84b8800d5837bb0357</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>FleetInterface</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a5627fd6de3d7234b2d76f46d695242db</anchor>
      <arglist>(const FleetInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~FleetInterface</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a6d7f6b4fc08c0e53c1b0f1930d6b4920</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a67ead41b510f7960a99a7a8697fb3cdd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetName</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>aa1b261a5a03404b70ce472b4ee0cc29d</anchor>
      <arglist>(const std::string &amp;name)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>GetName</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>aa63cef53874620f9fd792b6584c7f5ee</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetObservedAgeCompDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a65787e7d01a48ca147b01764a636b6c7</anchor>
      <arglist>(int observed_agecomp_data_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetObservedLengthCompDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a5d11ca742f04a2f7208c42ac6081c1b5</anchor>
      <arglist>(int observed_lengthcomp_data_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetObservedIndexDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>adac98c8e4fb6dd1d8414e24631a7ef72</anchor>
      <arglist>(int observed_index_data_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetObservedLandingsDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>adacbc3bfc477835bfa6cb948165cb41a</anchor>
      <arglist>(int observed_landings_data_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetSelectivityID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a68504064f7c1df03061c8611c9bdf329</anchor>
      <arglist>(int selectivity_id)</arglist>
    </member>
    <member kind="function">
      <type>uint32_t</type>
      <name>GetSelectivityID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a3bcb379f52ba814e2187e526c6bc0cdc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetObservedAgeCompDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a628a33214ac8082f1a91803ddc09ad8e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetObservedLengthCompDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a83770b2a8aca2878095bc985bd2cc481</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetObservedIndexDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a49ed6935eaaa190bb63ec97f9e81d045</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetObservedLandingsDataID</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>af989767c7a2dfee6cf569eda2abc0300</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a614a5a7742d8f05de4fb917998306baa</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>name</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a8c3947a5383186df7855801fd2fdd9fe</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_ages</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a9eee035642a547b13da5f925202a57dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_lengths</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>ac901b65d1568df1aaa3d906ba5150bd3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_years</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a2491c7cb0730f82cb5d7723ae4e4f386</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>observed_landings_units</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a7de5e192bbaea9af8571be9e3a528d6a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>observed_index_units</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>adace9cb3a219aee6d248ae4e444b5c11</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_q</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a6cd303d699e4b0fdf9340af4b3126a3a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_Fmort</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a848e00d1125012b1072f72160843cd2d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_landings_expected</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a4ea2ebd360c633c37666731573489ef1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_index_expected</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a178ce2f344af25e89f7aaa8a1d349077</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>agecomp_expected</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a0749fc3615237bec9f5afcef202b306e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>lengthcomp_expected</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a4f650bbc4f05b893557e31a2abc37f2e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>agecomp_proportion</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a27af06606822e93d4ca831b5de058ee7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>lengthcomp_proportion</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>af7072b48780ec7245124c965f69672fe</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>age_to_length_conversion</name>
      <anchorfile>classFleetInterface.html</anchorfile>
      <anchor>a0a08ed1016f607eeb1c93d873ecd1cf3</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>FleetInterfaceBase</name>
    <filename>classFleetInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>FleetInterfaceBase</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>a2605a9fcabeabe26b41e773ea502a22f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>FleetInterfaceBase</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>ac9b1c7f3becc53284f7d6e977979e414</anchor>
      <arglist>(const FleetInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~FleetInterfaceBase</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>a7077a1aba597110640aa3e67ff6e75f5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>ac5958e50afcac92d1ed137748860ced8</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>a65f53edf247ffd853afb80ff0d615494</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>a0c53dd713a9d01a8ba69172f1442a73f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; FleetInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classFleetInterfaceBase.html</anchorfile>
      <anchor>ad6ee1e07ed0468fcfa875a70e7a2eaa5</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::GrowthBase</name>
    <filename>structfims__popdy_1_1GrowthBase.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>GrowthBase</name>
      <anchorfile>structfims__popdy_1_1GrowthBase.html</anchorfile>
      <anchor>a0352b6934eea814c055d7fdbc81efa14</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1GrowthBase.html</anchorfile>
      <anchor>a955f3f4ab3f30dfa2e6d6f884becfab6</anchor>
      <arglist>(int year, const double &amp;a)=0</arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__popdy_1_1GrowthBase.html</anchorfile>
      <anchor>a016bebc606785d9be69f454def1b2855</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>GrowthInterfaceBase</name>
    <filename>classGrowthInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>GrowthInterfaceBase</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>ad85e41235e30d0c04aad6817ef81be12</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>GrowthInterfaceBase</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>a6b3aead008a2230892a64a51c804b4bf</anchor>
      <arglist>(const GrowthInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~GrowthInterfaceBase</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>ad3342351e04d570f9d4a4d29d2548de8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>afbc10434dde3a23d19f74af494fff34c</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>a358cd72faf0e5bd0a9bf38ba0fddf146</anchor>
      <arglist>(double age)=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>aedcf584aed8f0401ebb0b2bb99c3394a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>ac76907326cf02002a0c370c4d3cd13b2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; GrowthInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classGrowthInterfaceBase.html</anchorfile>
      <anchor>a00165d43c39a23fa524d96fbb6f3f32f</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>IndexDataInterface</name>
    <filename>classIndexDataInterface.html</filename>
    <base>DataInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>IndexDataInterface</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>a3cf28fb4c8210b1829f0cf0db42593dd</anchor>
      <arglist>(int ymax=0)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>IndexDataInterface</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>ac8ed27e2d5cbe5a924c5479c96bb850e</anchor>
      <arglist>(const IndexDataInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~IndexDataInterface</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>a90e264b9bf1d857264196ec85477a786</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>ad739a24893879a34146fa1d8bb217d00</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>a1ad722d8f82198700a3dd72f9d11613c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims_int</type>
      <name>ymax</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>a2a5d036232d8031664908e6f2a7ba027</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>index_data</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>a7d1976a7500b57c1de6b4886c1d37581</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>uncertainty</name>
      <anchorfile>classIndexDataInterface.html</anchorfile>
      <anchor>ab5c23fa0684e53cb39a1293fa7eda105</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims_info::Information</name>
    <filename>classfims__info_1_1Information.html</filename>
    <templarg>typename Type</templarg>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>data_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a18535d2c0c99b9616aed2d891c45fb9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>recruitment_models_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a7b3b33b46cbb65c847ad47e50ef17c98</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>recruitment_process_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>accc31564a8057bebc1b0013d72498b24</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::SelectivityBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>selectivity_models_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ad6b814e85fe0f43684f775cb46eb808a</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::GrowthBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>growth_models_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a097b77c0c18c6e4bccac2950a20604ca</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::MaturityBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>maturity_models_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ae05182ea1e481f936b81e0eb2b3d46b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>fleet_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a4600849d863f485cd353a55dae321d54</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>population_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a59798203b69a6288904fed2c867fb95d</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_distributions::DensityComponentBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>density_components_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>aa0ab5ab8f6374ddc30987f978c8f1fac</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::unordered_map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::FisheryModelBase&lt; Type &gt; &gt; &gt;::iterator</type>
      <name>model_map_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a9626f44ca9843b5b443519b933438a8f</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::unordered_map&lt; uint32_t, fims::Vector&lt; Type &gt; * &gt;::iterator</type>
      <name>variable_map_iterator</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ad368f0de6ac26ced1ae33721a89772b5</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Clear</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a8b9e6bc88cfee7e80b360eea2d2853b5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>State</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ae8eae11b55e1c570310b064348b3d586</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>RegisterParameter</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a59f18d95d8425246661e3513cecdc0a2</anchor>
      <arglist>(Type &amp;p)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>RegisterRandomEffect</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a638e4deb58e190b72db9fb6225325b79</anchor>
      <arglist>(Type &amp;re)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>RegisterParameterName</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ad8957d597804821e05f7c710c8ac5d76</anchor>
      <arglist>(std::string p_name)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>RegisterRandomEffectName</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a17b83c06fd67ff15f52c851426de5f41</anchor>
      <arglist>(std::string re_name)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetupPriors</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ad07784f2c8952afd95d5bdffa6d5dcff</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetupRandomEffects</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a0c86d113a211bc07a12ed569d8c68c1b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetupData</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>adacf560208a607b69e46d503f76fec14</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetFleetLandingsData</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a1b5343821495e628e1cf91f1d4316a9c</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; f)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetFleetIndexData</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a21cdc88c62adecae565dc8d092445c3b</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; f)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetAgeCompositionData</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>aa5ba1172e68e3de66dbadbbaa1ed5c11</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; f)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetLengthCompositionData</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a51c74194eb52450d2a0256c80187b75d</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; f)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetFleetSelectivityModel</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a573d4dea26550f00973bf8b1186d9d5d</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; f)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetRecruitment</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a668558a0e718a108fb7976c1da5583c6</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; p)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetRecruitmentProcess</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a7da455d8f48af95add1a75bf1b495f8a</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; p)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetGrowth</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a25c05134865b8f7a2ff4dc53a02d47f4</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; p)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetMaturity</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a43f5f387c501dde13948832e4d856df9</anchor>
      <arglist>(bool &amp;valid_model, std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; p)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CreateFleetObjects</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>abc3b88b939a39ab003021f11ad9e88c1</anchor>
      <arglist>(bool &amp;valid_model)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetDataObjects</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a4a1c03ce871c9a8c2e300aaeda49ff38</anchor>
      <arglist>(bool &amp;valid_model)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CreatePopulationObjects</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a4dfbfb078010da333e1be823deccc76f</anchor>
      <arglist>(bool &amp;valid_model)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>CreateModelingObjects</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>aea88d0c494b23532c09dbd73ad632602</anchor>
      <arglist>(bool &amp;valid_model)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>CreateModel</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a87a3d2d9a1575dbba625398e7cadd904</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>GetNages</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a6f0c12f547444da4af4068bdc79efafe</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetNages</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a6e14a55eaacbc681d65b112e978ec35d</anchor>
      <arglist>(size_t n_ages)</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>GetNyears</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ad35271c481119df45a855ac00f1957fb</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetNyears</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a7778e9861c1a7ebde61d9d46f2429224</anchor>
      <arglist>(size_t n_years)</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; Type * &gt; &amp;</type>
      <name>GetParameters</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>acc18255fcff0c2823763f8c894856aee</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; Type * &gt; &amp;</type>
      <name>GetFixedEffectsParameters</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a1898b705511747d5d21415cb6633e9f9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; Type * &gt; &amp;</type>
      <name>GetRandomEffectsParameters</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ac9ff87a4ab5063bf366c18a8e67b900c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>CheckModel</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a7fa2c6cc68de26e26b6c1085600675bc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static std::shared_ptr&lt; Information&lt; Type &gt; &gt;</type>
      <name>GetInstance</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>aea0008a9935a78fe17f5ec217ac4c621</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_years</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a4bba008c429f6c2b43ab2248899f012a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_ages</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a91fe02769f34b8f3571b20d300c6b7d5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type * &gt;</type>
      <name>parameters</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ab32f7d2e0f24b8c8f651a1cdf99cac17</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type * &gt;</type>
      <name>random_effects_parameters</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a1a1aab0813d3722c93487db9ca0ef168</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; Type * &gt;</type>
      <name>fixed_effects_parameters</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>af95752279c137c15f9cb0ceb03327f02</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; std::string &gt;</type>
      <name>parameter_names</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ac1fbb03c15a0c6ca3d634b8761804823</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; std::string &gt;</type>
      <name>random_effects_names</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>acae6ee10137877bb3a4d3f353bd2b49a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_data_object::DataObject&lt; Type &gt; &gt; &gt;</type>
      <name>data_objects</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>afe718e2553694ba44247477ee0d187e9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt; &gt;</type>
      <name>recruitment_models</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>af84f12390187dbdf6864fdf5d052b499</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt; &gt;</type>
      <name>recruitment_process_models</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a2ef86120762c7b017f3db7edbb929364</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::SelectivityBase&lt; Type &gt; &gt; &gt;</type>
      <name>selectivity_models</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a85b08dfc5ad664cb9a655fab6285952c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::GrowthBase&lt; Type &gt; &gt; &gt;</type>
      <name>growth_models</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a4edd9876dd8d49da388487ec26b5ada6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::MaturityBase&lt; Type &gt; &gt; &gt;</type>
      <name>maturity_models</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>ac266167f6ac429cc29ea8846c3da8781</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; &gt;</type>
      <name>fleets</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a4d544f7e8c08032dd12ef14961e40822</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::Population&lt; Type &gt; &gt; &gt;</type>
      <name>populations</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a13bc1ac7074aeb44f7ceb0d2b9bb8531</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::map&lt; uint32_t, std::shared_ptr&lt; fims_distributions::DensityComponentBase&lt; Type &gt; &gt; &gt;</type>
      <name>density_components</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a628c455233e9564933cbd8c6f0ce1589</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::unordered_map&lt; uint32_t, std::shared_ptr&lt; fims_popdy::FisheryModelBase&lt; Type &gt; &gt; &gt;</type>
      <name>models_map</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a14847edc29ac248e9dcaf194d824112b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::unordered_map&lt; uint32_t, fims::Vector&lt; Type &gt; * &gt;</type>
      <name>variable_map</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>a715d5d15c75f2d2067e1715bf6744b46</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::shared_ptr&lt; Information&lt; Type &gt; &gt;</type>
      <name>fims_information</name>
      <anchorfile>classfims__info_1_1Information.html</anchorfile>
      <anchor>af21bebe91662251ada5ac37feaac1af5</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims::JsonParser</name>
    <filename>classfims_1_1JsonParser.html</filename>
    <member kind="function">
      <type>JsonValue</type>
      <name>Parse</name>
      <anchorfile>classfims_1_1JsonParser.html</anchorfile>
      <anchor>a7b1ee7df3bdbac4c23a282e308ab4f9f</anchor>
      <arglist>(const std::string &amp;json)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>WriteToFile</name>
      <anchorfile>classfims_1_1JsonParser.html</anchorfile>
      <anchor>a55f6f9bca8044fd53600d0aeb7f9c027</anchor>
      <arglist>(const std::string &amp;filename, JsonValue jsonValue)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Show</name>
      <anchorfile>classfims_1_1JsonParser.html</anchorfile>
      <anchor>a443c839ec331593e450b57285e7ab59a</anchor>
      <arglist>(JsonValue jsonValue)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static std::string</type>
      <name>removeWhitespace</name>
      <anchorfile>classfims_1_1JsonParser.html</anchorfile>
      <anchor>aa376edce137153ad7db370db5f0750d4</anchor>
      <arglist>(const std::string &amp;input)</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static std::string</type>
      <name>PrettyFormatJSON</name>
      <anchorfile>classfims_1_1JsonParser.html</anchorfile>
      <anchor>a5dc54b2cbbf6e2089d91fc696d8e1ab2</anchor>
      <arglist>(const std::string &amp;json)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims::JsonValue</name>
    <filename>classfims_1_1JsonValue.html</filename>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a11e289892b986b0e6c111474b8f37cbf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>ad466d26c56af3b6e6cbd31466e54ff81</anchor>
      <arglist>(int num)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a3f0e877e32d8bbc4213a022dbd403fd6</anchor>
      <arglist>(double num)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>ab905365bc5c8291f0e5509bcdc08ab7e</anchor>
      <arglist>(const std::string &amp;str)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a098e3d06382f388202efa1dc8ef0928b</anchor>
      <arglist>(bool b)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a3d034e3577f33cb18b0e975d5d374951</anchor>
      <arglist>(const JsonObject &amp;obj)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>JsonValue</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a18fa8c13f30854452f43abc225c88fb0</anchor>
      <arglist>(const JsonArray &amp;arr)</arglist>
    </member>
    <member kind="function">
      <type>JsonValueType</type>
      <name>GetType</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>acd1a10bbe8ccf212442dc7caea990763</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>GetInt</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a69c7f9549dab59eb43ff4a776a7470a9</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>GetDouble</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a29b4a7dcd57dc99d7194ed0b4979f01a</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>const std::string &amp;</type>
      <name>GetString</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a31946cee61877ffe6efbf88c727a0ddc</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>GetBool</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a83c0ba9f846e4a64e9d7f203b0c11872</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>JsonObject &amp;</type>
      <name>GetObject</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a760c6575b78ae3bcbad52fcd1629925c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>JsonArray &amp;</type>
      <name>GetArray</name>
      <anchorfile>classfims_1_1JsonValue.html</anchorfile>
      <anchor>a30e0ca57aa5820d85c6b2ef666a932c1</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>LandingsDataInterface</name>
    <filename>classLandingsDataInterface.html</filename>
    <base>DataInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>LandingsDataInterface</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>a0814b0193b6849e94e1712cc4db3262f</anchor>
      <arglist>(int ymax=0)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>LandingsDataInterface</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>a344fb48c4ba5933d089b673dfffda7e1</anchor>
      <arglist>(const LandingsDataInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LandingsDataInterface</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>aeb648b22a0a7c0abf5bd69da997be9d2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>adc39e4546ced028273e3a3458ba12dd6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>a6664332e0918bb63b119f8717c647458</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims_int</type>
      <name>ymax</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>ae8d2c28575e5ec9ea4e19f00b616e42b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>landings_data</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>abe79cd4da811b671ccd435b1d240217c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>uncertainty</name>
      <anchorfile>classLandingsDataInterface.html</anchorfile>
      <anchor>a5c5715ca2a7d892c083164cd0fce3877</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>LengthCompDataInterface</name>
    <filename>classLengthCompDataInterface.html</filename>
    <base>DataInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>LengthCompDataInterface</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>ad7647c7018724e74a87b2b864ab998f7</anchor>
      <arglist>(int ymax=0, int lmax=0)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>LengthCompDataInterface</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>a6632040728788692dce0b13e368322d9</anchor>
      <arglist>(const LengthCompDataInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LengthCompDataInterface</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>a949bcdec10a0339dddce1583208d5709</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>af03c0e63519aa1dc71970b3fcc0cfd15</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>adbd93e1f4c9087f10b3b32975cd10bd8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims_int</type>
      <name>lmax</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>a095ebd07583f6f0ec1e07e5061b7ab01</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims_int</type>
      <name>ymax</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>a37b67ff89cdbdb44b5e33c8b703936cd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>length_comp_data</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>a2d28fff23ed0ac1d9775010b7041f3e8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>uncertainty</name>
      <anchorfile>classLengthCompDataInterface.html</anchorfile>
      <anchor>a75ca791884cc4c07a9434439a99389ee</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::LogDevs</name>
    <filename>structfims__popdy_1_1LogDevs.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::RecruitmentBase</base>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate_process</name>
      <anchorfile>structfims__popdy_1_1LogDevs.html</anchorfile>
      <anchor>a783fb17bfcfcb15ad1e26a4c34bceff5</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate_mean</name>
      <anchorfile>structfims__popdy_1_1LogDevs.html</anchorfile>
      <anchor>ac3cc0ac53d044d164207d9f90595cd58</anchor>
      <arglist>(const Type &amp;spawners, const Type &amp;phi_0)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>LogDevsRecruitmentInterface</name>
    <filename>classLogDevsRecruitmentInterface.html</filename>
    <base>RecruitmentInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>LogDevsRecruitmentInterface</name>
      <anchorfile>classLogDevsRecruitmentInterface.html</anchorfile>
      <anchor>ad289255c3fc5b9d10fc7f76d6ca274a4</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LogDevsRecruitmentInterface</name>
      <anchorfile>classLogDevsRecruitmentInterface.html</anchorfile>
      <anchor>aa64e1facfe46a48f9a2ec25792ca7794</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classLogDevsRecruitmentInterface.html</anchorfile>
      <anchor>a6fc28f680373a23cb13cad45b963cf09</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate_mean</name>
      <anchorfile>classLogDevsRecruitmentInterface.html</anchorfile>
      <anchor>a70f2926d3f7061922e12459dffbfd541</anchor>
      <arglist>(double spawners, double phi_0)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate_process</name>
      <anchorfile>classLogDevsRecruitmentInterface.html</anchorfile>
      <anchor>acff514b8c8a196743bc6dbec6fe5a545</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims::LogEntry</name>
    <filename>structfims_1_1LogEntry.html</filename>
    <member kind="function">
      <type>std::string</type>
      <name>to_string</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>aee0d15582045e8395516d02721fc1983</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>timestamp</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>aecbb278a89207626d3b379f1bce9fffc</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>message</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>a700eef36069cb58bdbfd77b0dd1dd857</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>level</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>a49a87a4cf5f4216cb5885d8d34e951e3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>rank</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>a2db0d4c1a68442562f1a33d845ed89ad</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>user</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>af918075584df32b11182b0406b84fd48</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>wd</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>a035f661c2f0a1c9d0b0f50b1ff01c394</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>file</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>a443d1be9aed07b8284c32dfbb2a389e0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>routine</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>a47814f40499111f33bed9fa4da6fa619</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>line</name>
      <anchorfile>structfims_1_1LogEntry.html</anchorfile>
      <anchor>aeacc914a42611260101bfd09c0935bb4</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::LogisticMaturity</name>
    <filename>structfims__popdy_1_1LogisticMaturity.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::MaturityBase</base>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1LogisticMaturity.html</anchorfile>
      <anchor>a8d2cd51bc769e5d6be77e26309d15f1e</anchor>
      <arglist>(const Type &amp;x)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1LogisticMaturity.html</anchorfile>
      <anchor>ab72445a1475fb37ee56e1ae81790446c</anchor>
      <arglist>(const Type &amp;x, size_t pos)</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>inflection_point</name>
      <anchorfile>structfims__popdy_1_1LogisticMaturity.html</anchorfile>
      <anchor>a632a5415a6e57c5ff977e8c844f95d94</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>slope</name>
      <anchorfile>structfims__popdy_1_1LogisticMaturity.html</anchorfile>
      <anchor>a093279afe623d32412bd1b0a2beb8c84</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>LogisticMaturityInterface</name>
    <filename>classLogisticMaturityInterface.html</filename>
    <base>MaturityInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>LogisticMaturityInterface</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>a89b0780b678c15b88ca676caf01dfa04</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>LogisticMaturityInterface</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>ab8f3bf35c6aa55a9f079018ccccc3f6f</anchor>
      <arglist>(const LogisticMaturityInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LogisticMaturityInterface</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>a2245dc534cabb81b42e07890dedbca99</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>a9c9ab0ceda4ae98e6335e8a31b6ab6a0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>aed4a368f3a145c633711bfd5a3ae2d7a</anchor>
      <arglist>(double x)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>aa714a1ef8cd5d36f545b9e4f5c71aac5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>ad239da2246abb3476ff179540fad8d7c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>inflection_point</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>a896a2d21435c89d6e97254c40ae08a63</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>slope</name>
      <anchorfile>classLogisticMaturityInterface.html</anchorfile>
      <anchor>a70646d633dee4a9a6c8a594cd6832e9e</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::LogisticSelectivity</name>
    <filename>structfims__popdy_1_1LogisticSelectivity.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::SelectivityBase</base>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1LogisticSelectivity.html</anchorfile>
      <anchor>a7e5e73a7689cefb1949cb844d12307b8</anchor>
      <arglist>(const Type &amp;x)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1LogisticSelectivity.html</anchorfile>
      <anchor>a9abf9caf9ba8c003ebb2dfa9c2184207</anchor>
      <arglist>(const Type &amp;x, size_t pos)</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>inflection_point</name>
      <anchorfile>structfims__popdy_1_1LogisticSelectivity.html</anchorfile>
      <anchor>ac4f5ab8f67acd93af04f1b3c771498c1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>slope</name>
      <anchorfile>structfims__popdy_1_1LogisticSelectivity.html</anchorfile>
      <anchor>a47d008ca4b862abca4f361d68b07d4f0</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>LogisticSelectivityInterface</name>
    <filename>classLogisticSelectivityInterface.html</filename>
    <base>SelectivityInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>LogisticSelectivityInterface</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>a57f551a449cc26dcf381e2b0e8f3d2ef</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>LogisticSelectivityInterface</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>ae07cf9f4ee9e36dbcec67e1182697dc0</anchor>
      <arglist>(const LogisticSelectivityInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LogisticSelectivityInterface</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>aacfebc2a55c5343c67a6800f19291013</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>ab293bd02d59b6672317a3b3b6b979fb3</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>af10a57e448b0a9c9a5394ce5f8da6ee1</anchor>
      <arglist>(double x)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>a2dc07a0b7520cb94533279312ca6a944</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>to_json</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>a6868e2168d5ebb91931548e9a3b508bc</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>inflection_point</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>a561e7e782ff948a2ab666095640b4232</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>slope</name>
      <anchorfile>classLogisticSelectivityInterface.html</anchorfile>
      <anchor>ad68100be3ce5eddf84819939c5c7785c</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_distributions::LogNormalLPDF</name>
    <filename>structfims__distributions_1_1LogNormalLPDF.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_distributions::DensityComponentBase</base>
    <member kind="function">
      <type></type>
      <name>LogNormalLPDF</name>
      <anchorfile>structfims__distributions_1_1LogNormalLPDF.html</anchorfile>
      <anchor>aa46c0ae62bfe3b2ca3f2ea08f9acb37e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LogNormalLPDF</name>
      <anchorfile>structfims__distributions_1_1LogNormalLPDF.html</anchorfile>
      <anchor>a4ed2110fd6e2c78e57f2f9889f0e8a08</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__distributions_1_1LogNormalLPDF.html</anchorfile>
      <anchor>aee168050b533cc95002f3abbf630b794</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_sd</name>
      <anchorfile>structfims__distributions_1_1LogNormalLPDF.html</anchorfile>
      <anchor>aea80107bf9db2b49b192f1698b4552c9</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::LogR</name>
    <filename>structfims__popdy_1_1LogR.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::RecruitmentBase</base>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate_process</name>
      <anchorfile>structfims__popdy_1_1LogR.html</anchorfile>
      <anchor>a0b9d9b3728dc66e879babb02f3088a4d</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate_mean</name>
      <anchorfile>structfims__popdy_1_1LogR.html</anchorfile>
      <anchor>aaa0dc8c7d1e2cef1e7c060e2f93ffdb3</anchor>
      <arglist>(const Type &amp;spawners, const Type &amp;phi_0)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>LogRRecruitmentInterface</name>
    <filename>classLogRRecruitmentInterface.html</filename>
    <base>RecruitmentInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>LogRRecruitmentInterface</name>
      <anchorfile>classLogRRecruitmentInterface.html</anchorfile>
      <anchor>a3b23a4787cb360d698427a9a817113f7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~LogRRecruitmentInterface</name>
      <anchorfile>classLogRRecruitmentInterface.html</anchorfile>
      <anchor>a26490dd59b6f9c7ed0c90b20412ddc94</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classLogRRecruitmentInterface.html</anchorfile>
      <anchor>aaa5bd2d6921649de76afc16041dd7c9f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate_mean</name>
      <anchorfile>classLogRRecruitmentInterface.html</anchorfile>
      <anchor>a9a3ab83ec68ece6090bf6a67542e83c5</anchor>
      <arglist>(double spawners, double phi_0)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>evaluate_process</name>
      <anchorfile>classLogRRecruitmentInterface.html</anchorfile>
      <anchor>a5a5bc58cf80f5f18d61046eb633886a3</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::MaturityBase</name>
    <filename>structfims__popdy_1_1MaturityBase.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>MaturityBase</name>
      <anchorfile>structfims__popdy_1_1MaturityBase.html</anchorfile>
      <anchor>aba833b4d42149ff56e3f4c8c28333d7a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1MaturityBase.html</anchorfile>
      <anchor>a787fb48e92d430f9cd5d3314ee98988d</anchor>
      <arglist>(const Type &amp;x)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1MaturityBase.html</anchorfile>
      <anchor>aba3eea1491daf97d6ccd3c66c7cb87c1</anchor>
      <arglist>(const Type &amp;x, size_t pos)=0</arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__popdy_1_1MaturityBase.html</anchorfile>
      <anchor>a79295ed14ac51d968fd4776feaab9caa</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>MaturityInterfaceBase</name>
    <filename>classMaturityInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>MaturityInterfaceBase</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>ae8ca26cc171f8b471deb6259704cfc18</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>MaturityInterfaceBase</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>ab191c30895c8dca3458e1e7f6a94e8c9</anchor>
      <arglist>(const MaturityInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~MaturityInterfaceBase</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>a88de1cb811b86b2f2811f03973d258b6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>a99f01074cb3839a04da28bd338956c5d</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>a1652288f0784bcc4cbf6359d4a94a705</anchor>
      <arglist>(double x)=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>a9e437596bb8a8805a1106e850def8bbf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>af28b36002fd4e5e21e8515df10be733a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; MaturityInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classMaturityInterfaceBase.html</anchorfile>
      <anchor>a9cda7708394b18d2ed2cef1ad1303c74</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims_model::Model</name>
    <filename>classfims__model_1_1Model.html</filename>
    <templarg>typename Type</templarg>
    <member kind="function">
      <type></type>
      <name>Model</name>
      <anchorfile>classfims__model_1_1Model.html</anchorfile>
      <anchor>a4538641e7f150147bf85aa0d4515e03d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>~Model</name>
      <anchorfile>classfims__model_1_1Model.html</anchorfile>
      <anchor>a893676693cfab4577c8f6458680d417b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const Type</type>
      <name>Evaluate</name>
      <anchorfile>classfims__model_1_1Model.html</anchorfile>
      <anchor>ad90b8d1d3de83cd359cca7982518f28d</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static std::shared_ptr&lt; Model&lt; Type &gt; &gt;</type>
      <name>GetInstance</name>
      <anchorfile>classfims__model_1_1Model.html</anchorfile>
      <anchor>aa1648bf1cc5adc5cacc43b0dbc7fb7aa</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_info::Information&lt; Type &gt; &gt;</type>
      <name>fims_information</name>
      <anchorfile>classfims__model_1_1Model.html</anchorfile>
      <anchor>addfa06809f60c7b5ef64c03c4cd204a9</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::shared_ptr&lt; Model&lt; Type &gt; &gt;</type>
      <name>fims_model</name>
      <anchorfile>classfims__model_1_1Model.html</anchorfile>
      <anchor>a9b1e4383331085750c40db5bbc5590e6</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_distributions::MultinomialLPMF</name>
    <filename>structfims__distributions_1_1MultinomialLPMF.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_distributions::DensityComponentBase</base>
    <member kind="function">
      <type></type>
      <name>MultinomialLPMF</name>
      <anchorfile>structfims__distributions_1_1MultinomialLPMF.html</anchorfile>
      <anchor>ab31b77abbda5863a2d6fd43cefb27b7e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~MultinomialLPMF</name>
      <anchorfile>structfims__distributions_1_1MultinomialLPMF.html</anchorfile>
      <anchor>a19cf1504c3524fed2381c092431115b7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__distributions_1_1MultinomialLPMF.html</anchorfile>
      <anchor>a12da6014205d15deb9768985f56da979</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; size_t &gt;</type>
      <name>dims</name>
      <anchorfile>structfims__distributions_1_1MultinomialLPMF.html</anchorfile>
      <anchor>a8f53d2cb377f00bdc112f4ca704da24d</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_distributions::NormalLPDF</name>
    <filename>structfims__distributions_1_1NormalLPDF.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_distributions::DensityComponentBase</base>
    <member kind="function">
      <type></type>
      <name>NormalLPDF</name>
      <anchorfile>structfims__distributions_1_1NormalLPDF.html</anchorfile>
      <anchor>a232feebfe9cb238f1f11fae46417a615</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~NormalLPDF</name>
      <anchorfile>structfims__distributions_1_1NormalLPDF.html</anchorfile>
      <anchor>aad56aa8133d0db1a265532955c061b65</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__distributions_1_1NormalLPDF.html</anchorfile>
      <anchor>aafca7eccc439ba541a4c7b3b29e03f3e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_sd</name>
      <anchorfile>structfims__distributions_1_1NormalLPDF.html</anchorfile>
      <anchor>a7e078bc3da7752330c22385a23ae1aa6</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>Parameter</name>
    <filename>classParameter.html</filename>
    <member kind="function">
      <type></type>
      <name>Parameter</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a1483d6d96dfe3a94348a1d929298afdb</anchor>
      <arglist>(double value, std::string estimation_type)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Parameter</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>ad3f5d861da24673d97bd1bd206b0b89a</anchor>
      <arglist>(const Parameter &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>Parameter &amp;</type>
      <name>operator=</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a20780b7aa78715d6d98dd0163307b723</anchor>
      <arglist>(const Parameter &amp;right)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Parameter</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a0daabd9177ee8c2e46af55347279ef5d</anchor>
      <arglist>(double value)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Parameter</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a5ba93ca36c3261d3850e67f92717c2f5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id_m</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>aaa48a69ea9e425a8942ce9536ad5ccdf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>initial_value_m</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a0c506852f8ea3ca7b5b2e8ec596337e8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>final_value_m</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a801f5573fedaf0530ecd90530323446f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>estimation_type_m</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>a839d8bf94d52f664af583c61ab9a4284</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classParameter.html</anchorfile>
      <anchor>ab6fd89214b154be99b8ebfe759507b02</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>ParameterVector</name>
    <filename>classParameterVector.html</filename>
    <member kind="function">
      <type></type>
      <name>ParameterVector</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>ada1e51ddf6e484390cedd92f5efae84f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ParameterVector</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a65c888cbb2dc1af915d8e778c7a896f9</anchor>
      <arglist>(const ParameterVector &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ParameterVector</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a05db115fafbe61b9dced91b794b36657</anchor>
      <arglist>(size_t size)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ParameterVector</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a1d7389c5c25377ee8806789e4cffc672</anchor>
      <arglist>(Rcpp::NumericVector x, size_t size)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ParameterVector</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a629cd4f1a62ea863d994225a66506357</anchor>
      <arglist>(const fims::Vector&lt; double &gt; &amp;v)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~ParameterVector</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>ae426de8e835ed4e670e8a38a5fdc7c64</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a8059836883b50a02abd1f6c26991a53e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>Parameter &amp;</type>
      <name>operator[]</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>ab50a6d8fc19e86fb7799fc46b750301c</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function">
      <type>SEXP</type>
      <name>at</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a58b8a06fb3070e59c179db2180ddb465</anchor>
      <arglist>(R_xlen_t pos)</arglist>
    </member>
    <member kind="function">
      <type>Parameter &amp;</type>
      <name>get</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>ac21d6482b5d3a8992a9cd7a48b7482a4</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>ad78418fdc00b6b9fd5f914c3021bde7a</anchor>
      <arglist>(size_t pos, const Parameter &amp;p)</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>size</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a1bc24e4c8af66ffef1b8aa88bb41a137</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>resize</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a098cdfbbf65f58ee93ffc76090a80e92</anchor>
      <arglist>(size_t size)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_all_estimable</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>af5723210fad2e222c33912e811934f44</anchor>
      <arglist>(bool estimable)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_all_random</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a074e8b3737ef4fb2dfb3bde9a176e7fd</anchor>
      <arglist>(bool random)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>fill</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a9296d749eab1b882116aca96e07154d5</anchor>
      <arglist>(double value)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>show</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a0657ff7f5f27848156ba8dd11cf2de11</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; std::vector&lt; Parameter &gt; &gt;</type>
      <name>storage_m</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>ae05fb87cd78344afb0dcfd9f2ade7791</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id_m</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a4412bae06d6d32142d19c42a60b9da0a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classParameterVector.html</anchorfile>
      <anchor>a34f937ef52028cececebec0d8df1cc06</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::Population</name>
    <filename>structfims__popdy_1_1Population.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>Population</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ad7fa5749fe5de3b9937d462d2e13743c</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_years</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ab1524985ebc9a71830cba0011fda5a99</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_ages</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ab75b45c42bd6b111a7318594a2bc3505</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>size_t</type>
      <name>n_fleets</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a28124afe84e69d245741d9ec6b584ddf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_init_naa</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>af2e49be95ab9db4d7d071ff3291305a7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_M</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a3fb02df8e3851a4d956c94e47d01b8f8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>proportion_female</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ae47bb5ebf7a3f1b14f69b9cfd7ad8ecf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_f_multiplier</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a7bc51d900bbe6d3f8a58dbd6034c2340</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>spawning_biomass_ratio</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a8eb044da00071f31ce522bb55359358e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>M</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ade6aeb9c5d0f96985c1b4409112e2d1c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>f_multiplier</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ab28151c31aea3b0cf9fac5e95b0c0220</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; double &gt;</type>
      <name>ages</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a23a683cac81c7ed67ac6a13cf129dfde</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; double &gt;</type>
      <name>years</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>aee3ec924970cafa0d544102eaf79c9db</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>recruitment_id</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a935b36af9b2596470bd0ab1f15f9973a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt;</type>
      <name>recruitment</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a962dbda1d550245a364674b7b0aefc53</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>growth_id</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a2a54f5e84ea887a65239dfcaba9ae489</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_popdy::GrowthBase&lt; Type &gt; &gt;</type>
      <name>growth</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>af6896d708c89dcaa07fbff37bb001b39</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>maturity_id</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ab2f55811906e85cdf288856d27f0f39d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_popdy::MaturityBase&lt; Type &gt; &gt;</type>
      <name>maturity</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a64989d39a34788e394cbe461bf49f3e2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::set&lt; uint32_t &gt;</type>
      <name>fleet_ids</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>ad3088db5680dac891e0b4f972fa925a4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; std::shared_ptr&lt; fims_popdy::Fleet&lt; Type &gt; &gt; &gt;</type>
      <name>fleets</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>a6eaaea0428208feb8fdb2a71a2f86557</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__popdy_1_1Population.html</anchorfile>
      <anchor>aab0a108938ebdc50d667d9049711b00e</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>PopulationInterface</name>
    <filename>classPopulationInterface.html</filename>
    <base>PopulationInterfaceBase</base>
    <member kind="typedef">
      <type>std::set&lt; uint32_t &gt;::iterator</type>
      <name>fleet_ids_iterator</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a024799b9a4485c5e56d0fca686e817a1</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>PopulationInterface</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a126aece2fb1dd8a54bbe31e5209df29a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>PopulationInterface</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>ad3370361e40e678c881fa6a671f38eee</anchor>
      <arglist>(const PopulationInterface &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~PopulationInterface</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a8a7d5144ac7974ec4887becf308a35eb</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a22cac116e4d291877015209dec5180e0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetName</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a5f36825cd3bd625457e984131568decb</anchor>
      <arglist>(const std::string &amp;name)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>GetName</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a633cf3880396e386fc0af6a3e8a2c2fa</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetMaturityID</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a2ff1be8c6c4dcd417913fe9899acf135</anchor>
      <arglist>(uint32_t maturity_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetGrowthID</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>ab1a30c8d1e2f2f1f6a98f522068d8e62</anchor>
      <arglist>(uint32_t growth_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>SetRecruitmentID</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>afe4f3922a8d7e4c0b503189926015ea0</anchor>
      <arglist>(uint32_t recruitment_id)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>AddFleet</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>ab2b4d1d1f792e7ce542511b03c428ea6</anchor>
      <arglist>(uint32_t fleet_id)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>finalize</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>ae3eb4069c7432b3a68726e3041ed33eb</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_ages</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a3a509125c0f19ac0813dfce7b8af2a7a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_fleets</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>aeba786600f5febd7147a9d53eb735f08</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; std::set&lt; uint32_t &gt; &gt;</type>
      <name>fleet_ids</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a0402c6e36b1987376d293e44aae2eeaa</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_years</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a568394717d8996d0d5583b6747879773</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>n_lengths</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a9615845b6d1784f250b4d075589d8b79</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>maturity_id</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a40c59e0eaf40f3c24c2d9865bef8d477</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>growth_id</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>aba1d29d268236d84ec5642f631a41210</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>recruitment_id</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>ac29b9cd4342fce77b72213d7a448bdf6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>recruitment_err_id</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a876ce3ce52884649b59f30d7df7ebf91</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_M</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a8a222b08450ff853868b39fe41307ecb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>spawning_biomass_ratio</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a0d33157a0c157383f07134def687f735</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_f_multiplier</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a4166c4d7d755fc43ebdf1b08d9d080d0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>ParameterVector</type>
      <name>log_init_naa</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a3592fdc543e9839dbee7fa814ca15f7b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>RealVector</type>
      <name>ages</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a72bb9d21b9f124ce5d9fba3020597c84</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedString</type>
      <name>name</name>
      <anchorfile>classPopulationInterface.html</anchorfile>
      <anchor>a35eeac59ec9c91677c936c68d292eadc</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>PopulationInterfaceBase</name>
    <filename>classPopulationInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>PopulationInterfaceBase</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a36e9d5a5ba67b71b8d19f601b274e169</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>PopulationInterfaceBase</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a8da6876c8471284f8e27718ac03c0c3c</anchor>
      <arglist>(const PopulationInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~PopulationInterfaceBase</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a048977a840e86eeb67419f3fbfc8f602</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a64cca7f79a91fea9a52fbc082c59f472</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a52bc457332deb78a632d94d94764a2e5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedBoolean</type>
      <name>initialize_catch_at_age</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>af9942742d184f03d04c5cad7450f3710</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedBoolean</type>
      <name>initialize_surplus_production</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a4e7c559357eccf753f43be733efa7ca5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>a9bc8bd7e05701019860160b95e75514c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; PopulationInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classPopulationInterfaceBase.html</anchorfile>
      <anchor>af946ea9804f101c1c15d88649eab9f19</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>RealVector</name>
    <filename>classRealVector.html</filename>
    <member kind="function">
      <type></type>
      <name>RealVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>af212860c92b4a4f45d121444821ca37e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>RealVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a326889d7c33c06805d7d0a9dfc42749f</anchor>
      <arglist>(const RealVector &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>RealVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a3cfb57b8f5e9b9052543522b66598b4d</anchor>
      <arglist>(size_t size)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>RealVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>ace6825ef7204a3d29bd96d15d32f6284</anchor>
      <arglist>(Rcpp::NumericVector x, size_t size)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>RealVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>ae0957dfa0de31a0c820730fd50821ff0</anchor>
      <arglist>(const fims::Vector&lt; double &gt; &amp;v)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~RealVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a22d7d0d15cf8e641a3d9d2d7d93e77f7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>RealVector &amp;</type>
      <name>operator=</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a61c3a746f9ae5dd982de90714587ddb0</anchor>
      <arglist>(const Rcpp::NumericVector &amp;v)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>ac0c8f645298395adcdc2f2fb8d107850</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>fromRVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>af10a68970b31bca3cb35b84c591f4197</anchor>
      <arglist>(const Rcpp::NumericVector &amp;orig)</arglist>
    </member>
    <member kind="function">
      <type>Rcpp::NumericVector</type>
      <name>toRVector</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>aa539dff2c10c08e77d47f6f8cb24fc5a</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>double &amp;</type>
      <name>operator[]</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>adbfffaca9dbf119d3e358337f43afbf5</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function">
      <type>SEXP</type>
      <name>at</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>ad373336678a162fd01be6b0623b347d1</anchor>
      <arglist>(R_xlen_t pos)</arglist>
    </member>
    <member kind="function">
      <type>double &amp;</type>
      <name>get</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a0e46c7faa2e62d0aa4f4f793054a183a</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a3a5eab6c7f3472ebb242a9e2af70acbd</anchor>
      <arglist>(size_t pos, const double &amp;p)</arglist>
    </member>
    <member kind="function">
      <type>size_t</type>
      <name>size</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a2317543f5dc4e05b8dd870dd29bf1f1b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>resize</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a56c89a02cdc713619a20e68563545be8</anchor>
      <arglist>(size_t size)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>fill</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a90c21e5db9c0004200652892364cc523</anchor>
      <arglist>(double value)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>show</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>ae38975617b724f5371c650022f0ecfd0</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; std::vector&lt; double &gt; &gt;</type>
      <name>storage_m</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a60f12148f4f54adbf68fc515db662e89</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id_m</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>a73e5a7e1d665326e2cd8c70fb9eb4620</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classRealVector.html</anchorfile>
      <anchor>aabf9e04bfa3b2c86fa26a5cee1af24dc</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::RecruitmentBase</name>
    <filename>structfims__popdy_1_1RecruitmentBase.html</filename>
    <templarg>class Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>RecruitmentBase</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>ae0fef4d2bbcdfd8b80936bdf5d0dbe81</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>Prepare</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a66e5676c8b301c0bde423b89aff8b1cf</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate_mean</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>abcd395d01ccbcbc4d4784ad2a27a923e</anchor>
      <arglist>(const Type &amp;spawners, const Type &amp;phi_0)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate_process</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a049cd0eed9fae58a904da5dc27888db6</anchor>
      <arglist>(size_t pos)=0</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>PrepareConstrainedDeviations</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a5b5b378ec529600bf29803017641d042</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_recruit_devs</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>af1151687013ce34c91144260da6ed8c6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>constrain_deviations</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a89cb23e1edcad304e74ded6bc97fe220</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_rzero</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a0c07fb1ecfbe727ccf2659585597c56d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_r</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a904e8b0d97eb1e74384291749d2bcf80</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>log_expected_recruitment</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a98f6e270306d419a6fa8f3c46152986c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>estimate_log_recruit_devs</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a847ffa3b1acbb5b5fe44d6816e67cd1b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int</type>
      <name>process_id</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>aa7ca260969bb979cf0e954213b5df2c2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt;</type>
      <name>process</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>ab2f2bf3011857f26ae17f8b30809863f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::shared_ptr&lt; fims_popdy::RecruitmentBase&lt; Type &gt; &gt;</type>
      <name>recruitment</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>acf427056522e39bbc0d714473c4789ce</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__popdy_1_1RecruitmentBase.html</anchorfile>
      <anchor>a537c92c88e8b006c2b6c58a91516e6a9</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>RecruitmentInterfaceBase</name>
    <filename>classRecruitmentInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>RecruitmentInterfaceBase</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>ad2cdb57b7cb0fa9bab4a3f036821872e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>RecruitmentInterfaceBase</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>abf7ea0b8463165a8d17bb3505a4f3cd7</anchor>
      <arglist>(const RecruitmentInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~RecruitmentInterfaceBase</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>a619e3736e9b4049638639647b453bca8</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>a4bc18067795f5503eecc72ef13a9802a</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual double</type>
      <name>evaluate_mean</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>a4e5d162cdccf2170b58aae94ef6d71de</anchor>
      <arglist>(double spawners, double phi_0)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual double</type>
      <name>evaluate_process</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>a0f093ef54561e11fadb92ca96ab5624e</anchor>
      <arglist>(size_t pos)=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>a3edf8070f5555b4868b429f7ef1b41be</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>SharedInt</type>
      <name>process_id</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>ab533fcbe6e70ffa1f460795a05e2e8f8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>add97b934e6c02e4c768d71d2d50bc2fd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; RecruitmentInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classRecruitmentInterfaceBase.html</anchorfile>
      <anchor>aff07edc4797149ef6d47fd0453705992</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::SelectivityBase</name>
    <filename>structfims__popdy_1_1SelectivityBase.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_model_object::FIMSObject</base>
    <member kind="function">
      <type></type>
      <name>SelectivityBase</name>
      <anchorfile>structfims__popdy_1_1SelectivityBase.html</anchorfile>
      <anchor>a811f8a606e34435ac6799136b2d5c1fa</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1SelectivityBase.html</anchorfile>
      <anchor>a20ba68f42b5725792c9d5279fee9d69c</anchor>
      <arglist>(const Type &amp;x)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual const Type</type>
      <name>evaluate</name>
      <anchorfile>structfims__popdy_1_1SelectivityBase.html</anchorfile>
      <anchor>a0301114a39dc669b995569293e6a7e5f</anchor>
      <arglist>(const Type &amp;x, size_t pos)=0</arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>structfims__popdy_1_1SelectivityBase.html</anchorfile>
      <anchor>a68336d55728d966508e52189c7a70db8</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>SelectivityInterfaceBase</name>
    <filename>classSelectivityInterfaceBase.html</filename>
    <base>FIMSRcppInterfaceBase</base>
    <member kind="function">
      <type></type>
      <name>SelectivityInterfaceBase</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>a400cc2a4a07f5b2faeb162e0460cdb0e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SelectivityInterfaceBase</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>aa5f9b8006461f22d74fc1a0f58336530</anchor>
      <arglist>(const SelectivityInterfaceBase &amp;other)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual</type>
      <name>~SelectivityInterfaceBase</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>a109aa1dea96e11fac9bdaa82b4688d62</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual uint32_t</type>
      <name>get_id</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>a4bfb14efaa2304eb7b1828dba443edb3</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual double</type>
      <name>evaluate</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>ad0ba72196e6a15591504a3f4c774d189</anchor>
      <arglist>(double x)=0</arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>id</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>ad75482256de49ee97eb312ac8fa6fb17</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static uint32_t</type>
      <name>id_g</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>ad00e0a11844faa3aba5950ee634354fb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" static="yes">
      <type>static std::map&lt; uint32_t, std::shared_ptr&lt; SelectivityInterfaceBase &gt; &gt;</type>
      <name>live_objects</name>
      <anchorfile>classSelectivityInterfaceBase.html</anchorfile>
      <anchor>af1f01fe30078f84182958682e05a15a9</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>SharedBoolean</name>
    <filename>classSharedBoolean.html</filename>
    <member kind="function">
      <type></type>
      <name>SharedBoolean</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>ae2484c0af01b96f9c4a07019b0b54500</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedBoolean</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a1b40cf8675248cf767cdf3855ac6068f</anchor>
      <arglist>(bool val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedBoolean</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a668a15075fd5c294a24afae90242f293</anchor>
      <arglist>(const SharedBoolean &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedBoolean &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a927766d991dc5c5e954fec59c5d0aa0b</anchor>
      <arglist>(const SharedBoolean &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedBoolean &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a79248875981d3036155623e571b52230</anchor>
      <arglist>(const bool &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedBoolean</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a007e521a52dee22933b89a0fc75765d8</anchor>
      <arglist>(SharedBoolean &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>SharedBoolean &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>ab5ebf547dd141ba0d6e582c63e74506e</anchor>
      <arglist>(SharedBoolean &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>get</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>ab8616ea19b6bc2c6f9b1fbb22f4adc95</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a9c3be0e9259ef7ac613b433c3001292d</anchor>
      <arglist>(bool val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>operator bool</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a18729f0ece4defe8f94c479196c521f5</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator*</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>af0069caf4a06003c422518f5c1f05d41</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>aa898e2f92d2da4ec105c2c69fffec622</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const bool *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a7a1d91b38c825363b4d0f37b65d0f85d</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator==</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a94dcfd6590ef018d246fd3b3b4f09ca0</anchor>
      <arglist>(const SharedBoolean &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator!=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a92c84aa51faeef11c0ba1aac6a0175ef</anchor>
      <arglist>(const SharedBoolean &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a5d996d8892869465cbeac737834bafc8</anchor>
      <arglist>(const SharedBoolean &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>adac52b11b590d9eedfbd011e54ff088d</anchor>
      <arglist>(const SharedBoolean &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>aa0c78d77d0f9243c8633716e89568571</anchor>
      <arglist>(const SharedBoolean &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a82ed7e4f3565622949ba762393d46645</anchor>
      <arglist>(const SharedBoolean &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator==</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>aa5cf7a0255dbd50221018885d503ae8f</anchor>
      <arglist>(const bool &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator!=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a0c064738978baa4731092865ec7fe810</anchor>
      <arglist>(const bool &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a445eaf5818d0c01f1c1f982c2729c11d</anchor>
      <arglist>(const bool &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>ab81fcfac57e617947cf91d548fdca71b</anchor>
      <arglist>(const bool &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>aeac9e6e6c02a46aabedb506266d0b023</anchor>
      <arglist>(const bool &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>a44246bc74472d77f222d9bfbd75275a3</anchor>
      <arglist>(const bool &amp;other) const</arglist>
    </member>
    <member kind="friend">
      <type>friend std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>classSharedBoolean.html</anchorfile>
      <anchor>ac7366f21aa30767933e4cbfbc31c3f92</anchor>
      <arglist>(std::ostream &amp;os, const SharedBoolean &amp;sp)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>SharedInt</name>
    <filename>classSharedInt.html</filename>
    <member kind="function">
      <type></type>
      <name>SharedInt</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a0d594f5123a1c7c56afc5a6c0212f46e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedInt</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a937a0d44ac64bc8a6788a544d9e557c2</anchor>
      <arglist>(int val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedInt</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ad1159abb40b7b3670dbbd7701953c5a0</anchor>
      <arglist>(const SharedInt &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a6018133dd228462923ae06fce4a38fd1</anchor>
      <arglist>(const SharedInt &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a6f071baf24da7ba61eb5ab5c808ece86</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedInt</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a973b5727d040f4275d5e99b920cb1c17</anchor>
      <arglist>(SharedInt &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a598f96b41170c64d880009c8f5c962e7</anchor>
      <arglist>(SharedInt &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>af28e2836f0d8c54c59e9f296b854a60d</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a060e4b331fda3805917b2f18d502506f</anchor>
      <arglist>(int val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>operator int</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ac355d1cf28d6154f93a63fc1357ae4a1</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>operator*</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a33034dd6a3ee41c7b737b4adb9c0f53f</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>int *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a091fcbfcbf149eb916d3fcd9ce275117</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const int *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a4a9042c1242e3d25a488abfb6594ba3a</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator++</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a1d18bbc687606e45358345c37c5aaf7e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator++</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a35bf012394f355a84ff9c2e0a63087ac</anchor>
      <arglist>(int)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator--</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a103657a4ba26b8da377fd622de352d57</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator--</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a8b77c18b5e1abefbae88c2adb267d23a</anchor>
      <arglist>(int)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator+</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a4f1273231de08f1ff2ef09fdcfc7724f</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator-</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a9ddc485628375d77eb8b1039a1102f06</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator*</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a1c96cb8f8cb2c7c96472702d6976c457</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator/</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a050e9f188fe488590a76951ad3157b41</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator+</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a9bb64abf46b4da2b5037f3e991af233d</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator-</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ab0f5f0ac5e77feef2dde98eeb55f0218</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator*</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a70e2c6ba5b2dd9aa43235f606a3988e0</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt</type>
      <name>operator/</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a5c5fbba18c56beb934657c44f2916807</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator+=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a824ea71b75bf38d0f77ae051dc35c05e</anchor>
      <arglist>(const SharedInt &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator-=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a5cb8635fa51395681618989ce7a38287</anchor>
      <arglist>(const SharedInt &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator*=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a264bbe02f4e9f6deba1611f0d32e1d25</anchor>
      <arglist>(const SharedInt &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator/=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>afc217508710a435a9165e59c2f187882</anchor>
      <arglist>(const SharedInt &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator+=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>aa8837ca886f022b9b33226fe5255f4df</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator-=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a6aa169cfbf2f9d2994d0014b1d68e3e0</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator*=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a23bb99efbe2e3d65903d1b2bc92542ac</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedInt &amp;</type>
      <name>operator/=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a352e5d9db0fd565dcf17fa90fe54c436</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator==</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a950a539fbccf92df7baf6c5d076eb191</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator!=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a12b49a06cfa2592d64bf0e81b055aec9</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>aabc289db7c00ad9ab5ae6d65dd31d371</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a96b2999d0255f90fc70a6cc2f29a5d40</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a3cd12d8539cc0fac8227feb46ceefebc</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ac5c2baaa62262349271681f6da1d3d17</anchor>
      <arglist>(const SharedInt &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator==</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ab5dfd22e8a3c91f54dde40c00886a07f</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator!=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a3041becadd022aa9c13ba14889423b87</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ad067837a30afaa0b17b28aa9b444bba3</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a9ddb0f8b3a3c57d0fbc95e7b92f75125</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>aab333f89784bb4d64c5b2cca3c57799c</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>a7a6c7ed8deb9b81e40d80988b79f62cc</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="friend">
      <type>friend std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>classSharedInt.html</anchorfile>
      <anchor>ab22daad26a59adbfcaa8cef5fc4a9e7e</anchor>
      <arglist>(std::ostream &amp;os, const SharedInt &amp;sp)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>SharedReal</name>
    <filename>classSharedReal.html</filename>
    <member kind="function">
      <type></type>
      <name>SharedReal</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a7c7ff90ad66e189f87ef960ed92db9aa</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedReal</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>ae33e28e15fedf7fbaaf00e4e5df0c955</anchor>
      <arglist>(int val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedReal</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>ab8c379ac3de82f88bef026e8faafaabd</anchor>
      <arglist>(const SharedReal &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a99fba932a18bbbae9636435f7a709ba6</anchor>
      <arglist>(const SharedReal &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a097afbbcb6aa192d9915208eb7b30847</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedReal</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>aaed684a4623305a32f7bc639407915ff</anchor>
      <arglist>(SharedReal &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a572d3a05dfc9f7e33223968ba1d14843</anchor>
      <arglist>(SharedReal &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>get</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>aa8f38a240ca8077f542a4a40feb5dfa5</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a21e68e76bc23a5e1f5989a94553e8c8c</anchor>
      <arglist>(int val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>operator int</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a72fccf69775cf0ee72b7d030cf20f459</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>int</type>
      <name>operator*</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a6fa65a1797de01a4ed3f1c17a297f03d</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>int *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a231cc4a3697a5dc74ff14013798cd376</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const int *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a651cacebfc417faba7b4da1c94dd515c</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator++</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a97962ea3a0b5e52b1d5b8bf7939a3d50</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator++</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a5489c1d8d3128671bc89b685a9611254</anchor>
      <arglist>(int)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator--</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a7553bb2dac690dbca45854a99ceb71c2</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator--</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>acd99844ccd200971d9fbbc3ebc04c95b</anchor>
      <arglist>(int)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator+</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a0a8dec1541c1ff8cd6ee6bc3b4fed0db</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator-</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a419f17ccda90b09be2ed6cafab81eeaa</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator*</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a913af863e85991b07c4dcf6737e3f66c</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator/</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a7aaf5a8c9208306d6d03f7be91064f4f</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator+</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>ae950bf60d77ada0bff9080f2bee9d3b5</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator-</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a71348415f445d9a34044568fa802e3c9</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator*</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a3734072fe7e23fd75032ed0415f1c512</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal</type>
      <name>operator/</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a953b4668cc6eabadb5db92c294fa8f8e</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator+=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a67a9b97cee17f1240b6b2b99d10c68cf</anchor>
      <arglist>(const SharedReal &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator-=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a5cff409c7cbcaa04c670f17d5f64eb8b</anchor>
      <arglist>(const SharedReal &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator*=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a2bef72075dbb22643acc3d5e0365e888</anchor>
      <arglist>(const SharedReal &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator/=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a8383ec17320cf6ee8a97de2acc369351</anchor>
      <arglist>(const SharedReal &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator+=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a1e234a5b453ad971f60065437915251a</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator-=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a8afae7923c2c088fc6546769430e70a8</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator*=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a360d65ca4cebc25b0af0a358aa933ad1</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedReal &amp;</type>
      <name>operator/=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a25b34654e8aa2d3c384aebbcfd2a7f7b</anchor>
      <arglist>(const int &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator==</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>ad85f22c1c7876f5a4f0c48d11b9d9c5c</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator!=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a4c79cdfa7cf3ae8f0f455567d4eea230</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>afcce29f9d176c19bed365f8ff60574ca</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a52ce6bd83814f074b9e352ef15720e46</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a6b93223dfba022bb5ed8249ff5eb18bb</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a169d30289a6a210fab83b48750bc3207</anchor>
      <arglist>(const SharedReal &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator==</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a32faa91fe7410cce60e0c5e8c5c50398</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator!=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>aa887566e3319cb2ddeb38a90b0d826ae</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>ac2e94071b205420167310485afad749d</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&lt;=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>abfeb66418f6cd9d47b428e8616980a5e</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>abc4e7f7d9df79ec003130a4822f6919e</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>operator&gt;=</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a1b092b6a5a59dc63e491a59a1a66a00c</anchor>
      <arglist>(const int &amp;other) const</arglist>
    </member>
    <member kind="friend">
      <type>friend std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>classSharedReal.html</anchorfile>
      <anchor>a848880871389d5f0ea5ed14467f8a7c1</anchor>
      <arglist>(std::ostream &amp;os, const SharedReal &amp;sp)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>SharedString</name>
    <filename>classSharedString.html</filename>
    <member kind="function">
      <type></type>
      <name>SharedString</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>af58b073e8b05be2ad32abdfb9588d982</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedString</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>aa45c93322d7100c462f0b1f526cdb461</anchor>
      <arglist>(std::string val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedString</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a9fe121568256581a611f8d06c38244ff</anchor>
      <arglist>(const SharedString &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedString &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>ab560028c3d852c68c69c2c3748e64794</anchor>
      <arglist>(const SharedString &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>SharedString &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>ac966c6d58b78ac307c05179bd27402ad</anchor>
      <arglist>(const std::string &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SharedString</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a768413537eb0c588da611a4bd3c42a5a</anchor>
      <arglist>(SharedString &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>SharedString &amp;</type>
      <name>operator=</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a55dd0becbb7cbba6b45ab555984349ff</anchor>
      <arglist>(SharedString &amp;&amp;other) noexcept</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a8076060b3bbe15d1c3dfd0ec2046ac87</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>ac69831cd7059e0008072fceb38e451a6</anchor>
      <arglist>(std::string val)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>operator std::string</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a038cb4515842977e53f34b742531bf71</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>operator*</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>ad3fa2eeb73713c582bc49c54567f72a3</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>std::string *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a8c63c5195caee222a908064dc75e5fb9</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const std::string *</type>
      <name>operator-&gt;</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>a50ecaac059213e7c416305978b8d2750</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="friend">
      <type>friend std::ostream &amp;</type>
      <name>operator&lt;&lt;</name>
      <anchorfile>classSharedString.html</anchorfile>
      <anchor>aa50279173d4b0de1dadd8b75700be061</anchor>
      <arglist>(std::ostream &amp;os, const SharedString &amp;sp)</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>fims_popdy::SRBevertonHolt</name>
    <filename>structfims__popdy_1_1SRBevertonHolt.html</filename>
    <templarg>typename Type</templarg>
    <base>fims_popdy::RecruitmentBase</base>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate_mean</name>
      <anchorfile>structfims__popdy_1_1SRBevertonHolt.html</anchorfile>
      <anchor>ad668df4ac02082db095bc86068a2c639</anchor>
      <arglist>(const Type &amp;spawners, const Type &amp;phi_0)</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual const Type</type>
      <name>evaluate_process</name>
      <anchorfile>structfims__popdy_1_1SRBevertonHolt.html</anchorfile>
      <anchor>ac1881bd68c7990ff9b0b47904e72a2b6</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="variable">
      <type>fims::Vector&lt; Type &gt;</type>
      <name>logit_steep</name>
      <anchorfile>structfims__popdy_1_1SRBevertonHolt.html</anchorfile>
      <anchor>a98823e945f50662f448b55159b390bd4</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>fims_popdy::Subpopulation</name>
    <filename>classfims__popdy_1_1Subpopulation.html</filename>
    <templarg>typename Type</templarg>
  </compound>
  <compound kind="class">
    <name>fims::Vector</name>
    <filename>classfims_1_1Vector.html</filename>
    <templarg>typename Type</templarg>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::value_type</type>
      <name>value_type</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a5292f6654fee6c143adf4b694958bd6d</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::allocator_type</type>
      <name>allocator_type</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ab120f87c3bf405a86ed96bf78fba7045</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::size_type</type>
      <name>size_type</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aef3c72aa69c97bdc441da6254a2aa310</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::difference_type</type>
      <name>difference_type</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ad9d16e530b0a67d301311031ecd0bf11</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::reference</type>
      <name>reference</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a2c822b39eaad468f2e61cca61956fb85</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::const_reference</type>
      <name>const_reference</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a73039a864dc3260fad2f479436f07634</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::pointer</type>
      <name>pointer</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a0c83eba16209dbed7640508d23762f9b</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::const_pointer</type>
      <name>const_pointer</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ae030f216c0277d6d6db26612dfda61a7</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::iterator</type>
      <name>iterator</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ae325d4168cdf392083868a65da5057ec</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::const_iterator</type>
      <name>const_iterator</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a1599f71fde1e54967526c394774c521a</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::reverse_iterator</type>
      <name>reverse_iterator</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>afb654ff466fb19c85e9d325c1cffcf05</anchor>
      <arglist></arglist>
    </member>
    <member kind="typedef">
      <type>std::vector&lt; Type &gt;::const_reverse_iterator</type>
      <name>const_reverse_iterator</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a222ede0334a583819b9013335be15dd9</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Vector</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ac0b39ccdfdbac0c50f67c9e5553031c1</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Vector</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a7ddfcfcac8e0f9968ca1419ac0279f63</anchor>
      <arglist>(size_t size, const Type &amp;value=Type())</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Vector</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a23fbf3f78788d14bc1654746c40933ab</anchor>
      <arglist>(const Vector&lt; Type &gt; &amp;other)</arglist>
    </member>
    <member kind="function">
      <type>Vector &amp;</type>
      <name>operator=</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>addf83740127696a31cf8a5c4c75fffb1</anchor>
      <arglist>(const Vector &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Vector</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aea2a681e87739cbbec207566241179ce</anchor>
      <arglist>(const std::vector&lt; Type &gt; &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>Vector</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a3f1f102d2ed4e398c9c955cfd853e98b</anchor>
      <arglist>(std::initializer_list&lt; Type &gt; init)</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>operator[]</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ac4a01f5a939399c068281857077c9b0c</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function">
      <type>const Type &amp;</type>
      <name>operator[]</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a80d84335fdb8a8455507d4ac1e5bc1fa</anchor>
      <arglist>(size_t n) const</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>at</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a58841d94f2a24b2fe00c3f584a0b025d</anchor>
      <arglist>(size_t n)</arglist>
    </member>
    <member kind="function">
      <type>const Type &amp;</type>
      <name>at</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a1e36dcc06238b3e33fd3aae205a56bb1</anchor>
      <arglist>(size_t n) const</arglist>
    </member>
    <member kind="function">
      <type>Type &amp;</type>
      <name>get_force_scalar</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a70bfdc38a54b251b3d5dbebdb06df49d</anchor>
      <arglist>(size_t pos)</arglist>
    </member>
    <member kind="function">
      <type>reference</type>
      <name>front</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a50b58c7402c75b14d1dfbfba85e08bbd</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const_reference</type>
      <name>front</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a20686856d7e697c8245400c5fe793aa9</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>reference</type>
      <name>back</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a7f08d9194dc3ee3f8935e23d9bc93068</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const_reference</type>
      <name>back</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>af333496eac4dd104766cda659d1858c5</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>pointer</type>
      <name>data</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a7e1dc8a5671358ba56f52b5fa4c0598e</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const_pointer</type>
      <name>data</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>abb8aa693fa992b944d17fd144ca4c40a</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>begin</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a299d04fd9a11b46933f4802b7a7a8341</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>end</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a2ccdf3d56b12fa0d175a4f9e8ad1f2d7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>reverse_iterator</type>
      <name>rbegin</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ab4cab34b7f946e3db28befa6ee590e2f</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>reverse_iterator</type>
      <name>rend</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a1b420e6d1d0898afb90b127a06bb11e6</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>const_reverse_iterator</type>
      <name>rbegin</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aa9e587a5f579f6901af405f1af903046</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>const_reverse_iterator</type>
      <name>rend</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a864f6aaa6466ce9ea6723e6decd880df</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>empty</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a5d90390d8f99e15cadd1eadc0560733b</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>size_type</type>
      <name>size</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>abe2abae6275f702ce15a62f6a63c7062</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>size_type</type>
      <name>max_size</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a15d40df5b4ef663486d9d712130dc6d7</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>reserve</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a254cc7fdb1dc247fae2216726cc720e7</anchor>
      <arglist>(size_type cap)</arglist>
    </member>
    <member kind="function">
      <type>size_type</type>
      <name>capacity</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a4199a5050a85e9bd6e530f5af1846514</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>shrink_to_fit</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a37fe09f5a2b8f57272cc0638548c7345</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>clear</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aee67983e5dafc3b081d3777220cb3c99</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>insert</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ab0ee9390e43439d6ef5bc8f391095dbc</anchor>
      <arglist>(const_iterator pos, const Type &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>insert</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>afc9e14ef1b8158f976a13d35df4461e5</anchor>
      <arglist>(const_iterator pos, size_type count, const Type &amp;value)</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>insert</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a5c11e84813c979560191675f1a5c9765</anchor>
      <arglist>(const_iterator pos, InputIt first, InputIt last)</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>insert</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>ab2101bfe7a6335797302aeebf1dd40f2</anchor>
      <arglist>(const_iterator pos, std::initializer_list&lt; Type &gt; ilist)</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>emplace</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a0cb72bf01bf35d5bd49ad88b463391ce</anchor>
      <arglist>(const_iterator pos, Args &amp;&amp;...args)</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>erase</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a6877cca7b037e6a62996d2c8b558d9db</anchor>
      <arglist>(iterator pos)</arglist>
    </member>
    <member kind="function">
      <type>iterator</type>
      <name>erase</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aa90013801ef54eec40e5863a69fcb53a</anchor>
      <arglist>(iterator first, iterator last)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>push_back</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a5ae1e430317d5068b40ef3a5a95fd2d3</anchor>
      <arglist>(const Type &amp;&amp;value)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>emplace_back</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a4bf81241924aa961c559adbddc7dac3d</anchor>
      <arglist>(Args &amp;&amp;...args)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>pop_back</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a8b76bd813c4883eb26c9ad1d8de3bcc7</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>resize</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a971eba3d10861eaabaf2b0252182fed9</anchor>
      <arglist>(size_t s)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>swap</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a5631f6d0649ac37b28a95a8e64be66a2</anchor>
      <arglist>(Vector &amp;other)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>operator std::vector&lt; Type &gt;</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aa1957de9c634fc29f5760137832d0d45</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; Type &gt;</type>
      <name>to_std</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a9e37062fc7adc07d64f29b648c08d4d9</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; Type &gt;</type>
      <name>to_tmb</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>aa55c883b29afa5bc59134bd00f785fc1</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>get_tag</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>a511709eee676fd7defff0b4460400370</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>set_tag</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>acb0fdd380d9f6fcadd354aa52509ee8d</anchor>
      <arglist>(const std::string &amp;tag)</arglist>
    </member>
    <member kind="friend" protection="private">
      <type>friend bool</type>
      <name>operator==</name>
      <anchorfile>classfims_1_1Vector.html</anchorfile>
      <anchor>afb4f20f0ebbb355ba7b9a3bcdec6286e</anchor>
      <arglist>(const fims::Vector&lt; T &gt; &amp;lhs, const fims::Vector&lt; T &gt; &amp;rhs)</arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>fims_popdy</name>
    <filename>namespacefims__popdy.html</filename>
    <class kind="class">fims_popdy::CatchAtAge</class>
    <class kind="struct">fims_popdy::DimensionInfo</class>
    <class kind="struct">fims_popdy::DoubleLogisticSelectivity</class>
    <class kind="struct">fims_popdy::EWAAGrowth</class>
    <class kind="class">fims_popdy::FisheryModelBase</class>
    <class kind="struct">fims_popdy::Fleet</class>
    <class kind="struct">fims_popdy::GrowthBase</class>
    <class kind="struct">fims_popdy::LogDevs</class>
    <class kind="struct">fims_popdy::LogisticMaturity</class>
    <class kind="struct">fims_popdy::LogisticSelectivity</class>
    <class kind="struct">fims_popdy::LogR</class>
    <class kind="struct">fims_popdy::MaturityBase</class>
    <class kind="struct">fims_popdy::Population</class>
    <class kind="struct">fims_popdy::RecruitmentBase</class>
    <class kind="struct">fims_popdy::SelectivityBase</class>
    <class kind="struct">fims_popdy::SRBevertonHolt</class>
    <class kind="class">fims_popdy::Subpopulation</class>
  </compound>
  <compound kind="page">
    <name>glossary</name>
    <title>Glossary</title>
    <filename>glossary.html</filename>
  </compound>
  <compound kind="page">
    <name>md_inst_2include_2README</name>
    <title>C++ Directory Structure</title>
    <filename>md_inst_2include_2README.html</filename>
  </compound>
  <compound kind="page">
    <name>index</name>
    <title>FIMS</title>
    <filename>index.html</filename>
    <docanchor file="index.html">md_inst_2include_2common_2MAIN</docanchor>
  </compound>
</tagfile>
