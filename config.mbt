///|
/// Element profile switches modeled after DOMPurify `USE_PROFILES`.
pub(all) struct UseProfilesConfig {
  html : Bool
  svg : Bool
  svg_filters : Bool
  math_ml : Bool
}

///|
pub fn UseProfilesConfig::default() -> UseProfilesConfig {
  UseProfilesConfig::{
    html: false,
    svg: false,
    svg_filters: false,
    math_ml: false,
  }
}

///|
/// Custom element handling options.
pub(all) struct CustomElementHandling {
  tag_name_check : ((String) -> Bool)?
  attribute_name_check : ((String, String) -> Bool)?
  allow_customized_built_in_elements : Bool
}

///|
pub fn CustomElementHandling::default() -> CustomElementHandling {
  CustomElementHandling::{
    tag_name_check: None,
    attribute_name_check: None,
    allow_customized_built_in_elements: false,
  }
}

///|
/// Configuration for `sanitize`.
pub(all) struct Config {
  allowed_tags : Array[String]?
  allowed_attr : Array[String]?
  allowed_namespaces : Array[String]?
  add_tags : Array[String]?
  add_tag_check : ((String) -> Bool)?
  add_attr : Array[String]?
  add_attr_check : ((String, String) -> Bool)?
  add_data_uri_tags : Array[String]?
  add_uri_safe_attr : Array[String]?
  allow_aria_attr : Bool
  allow_data_attr : Bool
  allow_unknown_protocols : Bool
  allow_self_close_in_attr : Bool
  forbid_tags : Array[String]?
  forbid_attr : Array[String]?
  forbid_contents : Array[String]?
  add_forbid_contents : Array[String]?
  force_body : Bool
  keep_content : Bool
  namespace_uri : String
  parser_media_type : String
  safe_for_templates : Bool
  safe_for_xml : Bool
  sanitize_dom : Bool
  sanitize_named_props : Bool
  whole_document : Bool
  use_profiles : UseProfilesConfig?
  custom_element_handling : CustomElementHandling?
  allowed_uri_check : ((String) -> Bool)?
  html_integration_points : Array[String]?
  mathml_text_integration_points : Array[String]?
}

///|
pub fn Config::default() -> Config {
  Config::{
    allowed_tags: None,
    allowed_attr: None,
    allowed_namespaces: None,
    add_tags: None,
    add_tag_check: None,
    add_attr: None,
    add_attr_check: None,
    add_data_uri_tags: None,
    add_uri_safe_attr: None,
    allow_aria_attr: true,
    allow_data_attr: true,
    allow_unknown_protocols: false,
    allow_self_close_in_attr: true,
    forbid_tags: None,
    forbid_attr: None,
    forbid_contents: None,
    add_forbid_contents: None,
    force_body: false,
    keep_content: true,
    namespace_uri: namespace_html,
    parser_media_type: parser_media_type_html,
    safe_for_templates: false,
    safe_for_xml: true,
    sanitize_dom: true,
    sanitize_named_props: false,
    whole_document: false,
    use_profiles: None,
    custom_element_handling: None,
    allowed_uri_check: None,
    html_integration_points: None,
    mathml_text_integration_points: None,
  }
}
