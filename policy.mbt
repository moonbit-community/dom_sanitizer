// Policy semantics adapted from DOMPurify 3.3.3; see THIRD_PARTY_NOTICES.

///|
priv struct Policy {
  config : Config
  tags : Set[String]
  attributes : Set[String]
  namespaces : Set[String]
  extra_tags : Set[String]
  extra_attributes : Set[String]
  forbid_tags : Set[String]
  forbid_attributes : Set[String]
  forbid_contents : Set[String]
  data_uri_tags : Set[String]
  uri_safe_attributes : Set[String]
  html_integration_points : Set[String]
  mathml_text_integration_points : Set[String]
  custom : CustomElementHandling
}

///|
fn name_set(names : Array[String]) -> Set[String] {
  Set::from_iter(names.iter().map(String::to_lower))
}

///|
fn configured_names(
  names : Array[String]?,
  defaults : Set[String],
) -> Set[String] {
  match names {
    Some(names) => name_set(names)
    None => defaults.copy()
  }
}

///|
fn Policy::new(config : Config) -> Policy {
  let mut tags = configured_names(
    config.allowed_tags,
    html_tags | svg_tags | svg_filter_tags | mathml_tags | Set(["#text"]),
  )
  let mut attributes = configured_names(
    config.allowed_attr,
    html_attributes | svg_attributes | mathml_attributes | xml_attributes,
  )
  if config.use_profiles is Some(profile) {
    tags = Set(["#text"])
    attributes = Set([])
    if profile.html {
      tags.union_in_place(html_tags)
      attributes.union_in_place(html_attributes)
    }
    if profile.svg {
      tags.union_in_place(svg_tags)
      attributes.union_in_place(svg_attributes)
      attributes.union_in_place(xml_attributes)
    }
    if profile.svg_filters {
      tags.union_in_place(svg_filter_tags)
      attributes.union_in_place(svg_attributes)
      attributes.union_in_place(xml_attributes)
    }
    if profile.math_ml {
      tags.union_in_place(mathml_tags)
      attributes.union_in_place(mathml_attributes)
      attributes.union_in_place(xml_attributes)
    }
  }
  let extra_tags = name_set(config.add_tags.unwrap_or([]))
  let extra_attributes = name_set(config.add_attr.unwrap_or([]))
  // When a predicate is supplied the wrapper combines the list and predicate
  // into one callback. That path has different precedence and URI semantics.
  if config.add_tag_check is None {
    tags.union_in_place(extra_tags)
  }
  if config.add_attr_check is None {
    attributes.union_in_place(extra_attributes)
  }
  if config.keep_content {
    tags.add("#text")
  }
  if config.whole_document {
    tags.union_in_place(Set(["html", "head", "body"]))
  }
  let forbid_tags = name_set(config.forbid_tags.unwrap_or([]))
  if tags.contains("table") {
    tags.add("tbody")
    forbid_tags.remove("tbody")
  }
  {
    config,
    tags,
    attributes,
    namespaces: Set(
      config.allowed_namespaces.unwrap_or([
        NAMESPACE_HTML,
        NAMESPACE_SVG,
        NAMESPACE_MATHML,
      ]),
    ),
    extra_tags,
    extra_attributes,
    forbid_tags,
    forbid_attributes: name_set(config.forbid_attr.unwrap_or([])),
    forbid_contents: configured_names(
      config.forbid_contents,
      default_forbid_contents,
    ) |
    name_set(config.add_forbid_contents.unwrap_or([])),
    data_uri_tags: default_data_uri_tags |
    name_set(config.add_data_uri_tags.unwrap_or([])),
    uri_safe_attributes: default_uri_safe_attributes |
    name_set(config.add_uri_safe_attr.unwrap_or([])),
    html_integration_points: configured_names(
      config.html_integration_points,
      Set(["annotation-xml"]),
    ),
    mathml_text_integration_points: configured_names(
      config.mathml_text_integration_points,
      Set(["mi", "mo", "mn", "ms", "mtext"]),
    ),
    custom: config.custom_element_handling.unwrap_or(
      CustomElementHandling::default(),
    ),
  }
}

///|
priv enum TagPermission {
  Allowed
  Custom
  Forbidden
} derive(Eq)

///|
fn Policy::tag_permission(self : Policy, tag : String) -> TagPermission {
  if self.config.add_tag_check is Some(check) &&
    (self.extra_tags.contains(tag) || check(tag)) {
    return Allowed
  }
  if self.forbid_tags.contains(tag) {
    return Forbidden
  }
  if self.tags.contains(tag) {
    return Allowed
  }
  if self.allows_custom_tag(tag) {
    Custom
  } else {
    Forbidden
  }
}

///|
fn Policy::allows_tag(self : Policy, tag : String) -> Bool {
  self.tag_permission(tag) != Forbidden
}

///|
fn Policy::allows_custom_tag(self : Policy, tag : String) -> Bool {
  is_custom_tag(tag) &&
  (match self.custom.tag_name_check {
    Some(check) => check(tag)
    None => false
  })
}

///|
fn is_custom_tag(tag : String) -> Bool {
  if tag == "annotation-xml" || tag.is_empty() || !(tag[0] is ('a'..<='z')) {
    return false
  }
  let mut dash = false
  let mut previous_dash = false
  for c in tag {
    if c == '-' {
      if previous_dash {
        return false
      }
      dash = true
      previous_dash = true
    } else if is_ascii_word(c) || c == '.' {
      previous_dash = false
    } else {
      return false
    }
  }
  dash && !previous_dash
}

///|
fn Policy::valid_namespace(
  self : Policy,
  tag : String,
  ns : @html.Namespace,
  parent_tag : String,
  parent_ns : @html.Namespace,
) -> Bool {
  let uri = match ns {
    HTML => NAMESPACE_HTML
    SVG => NAMESPACE_SVG
    MathML => NAMESPACE_MATHML
  }
  if !self.namespaces.contains(uri) {
    return false
  }
  match ns {
    SVG =>
      match parent_ns {
        HTML => tag == "svg"
        MathML =>
          tag == "svg" &&
          (
            parent_tag == "annotation-xml" ||
            self.mathml_text_integration_points.contains(parent_tag)
          )
        SVG =>
          svg_tags.contains(tag) ||
          svg_filter_tags.contains(tag) ||
          svg_disallowed_tags.contains(tag)
      }
    MathML =>
      match parent_ns {
        HTML => tag == "math"
        SVG =>
          tag == "math" && self.html_integration_points.contains(parent_tag)
        MathML =>
          mathml_tags.contains(tag) || mathml_disallowed_tags.contains(tag)
      }
    HTML => {
      if parent_ns == SVG && !self.html_integration_points.contains(parent_tag) {
        return false
      }
      if parent_ns == MathML &&
        !self.mathml_text_integration_points.contains(parent_tag) {
        return false
      }
      !mathml_tags.contains(tag) &&
      !mathml_disallowed_tags.contains(tag) &&
      (
        tag is ("title" | "style" | "font" | "a" | "script") ||
        (
          !svg_tags.contains(tag) &&
          !svg_filter_tags.contains(tag) &&
          !svg_disallowed_tags.contains(tag)
        )
      )
    }
  }
}
