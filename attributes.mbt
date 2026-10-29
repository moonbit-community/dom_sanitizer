// Attribute policy adapted from DOMPurify 3.3.3; see THIRD_PARTY_NOTICES.

///|
fn data_attribute(name : String) -> Bool {
  name.has_prefix("data-") &&
  name.length() > 5 &&
  name[5:]
  .iter()
  // DOMPurify's non-Unicode regexp accepts each UTF-16 surrogate as well, so
  // supplementary characters are valid here too.
  .all(fn(c) { is_ascii_word(c) || c is ('-' | '.' | '\u{b7}'..<='\u{10ffff}') })
}

///|
fn aria_attribute(name : String) -> Bool {
  name.has_prefix("aria-") &&
  name.length() > 5 &&
  name[5:].iter().all(fn(c) { is_ascii_word(c) || c == '-' })
}

///|
fn Policy::allows_attribute(
  self : Policy,
  tag : String,
  name : String,
  value : String,
) -> Bool {
  if self.forbid_attributes.contains(name) {
    return false
  }
  if self.config.sanitize_dom &&
    name is ("id" | "name") &&
    reserved_dom_names.contains(value) {
    return false
  }
  if self.config.allow_data_attr &&
    !self.config.safe_for_templates &&
    data_attribute(name) {
    return true
  }
  if self.config.allow_aria_attr && aria_attribute(name) {
    return true
  }
  if self.config.add_attr_check is Some(check) &&
    (self.extra_attributes.contains(name) || check(name, tag)) {
    return true
  }
  if !self.attributes.contains(name) {
    if self.allows_custom_tag(tag) &&
      self.custom.attribute_name_check is Some(check) &&
      check(name, tag) {
      return true
    }
    return name == "is" &&
      self.custom.allow_customized_built_in_elements &&
      (match self.custom.tag_name_check {
        Some(check) => check(value)
        None => false
      })
  }
  if self.uri_safe_attributes.contains(name) {
    return true
  }
  let compact = compact_uri(value)
  allowed_uri(compact) ||
  (
    name is ("src" | "xlink:href" | "href") &&
    tag != "script" &&
    value.has_prefix("data:") &&
    self.data_uri_tags.contains(tag)
  ) ||
  (self.config.allow_unknown_protocols && !script_or_data_uri(compact)) ||
  value.is_empty()
}

///|
fn qualified_attribute(name : String, ns : @html.Namespace) -> String {
  // The parser's public tree stores adjusted foreign attributes as
  // "prefix localname" (the html5lib tree format), rather than "prefix:localname".
  if ns != HTML &&
    (
      name.has_prefix("xlink ") ||
      name.has_prefix("xml ") ||
      name.has_prefix("xmlns ")
    ) {
    name.replace_all(old=" ", new=":")
  } else {
    name
  }
}

///|
fn Policy::clean_attributes(
  self : Policy,
  tag : String,
  element : @html.Element,
) -> Array[(String, String)] {
  let attributes : Array[(String, String)?] = Array::make(
    element.attributes.length(),
    None,
  )
  let appended : Array[(String, String)] = []
  // Predicate invocation order and prefixed id/name ordering match DOMPurify.
  for i = element.attributes.length() - 1; i >= 0; i = i - 1 {
    let (parser_name, original) = element.attributes[i]
    let name = qualified_attribute(parser_name, element.ns)
    let lower = name.to_lower()
    let mut value = if name == "value" {
      original
    } else {
      trim_attribute(original)
    }
    let prefix = self.config.sanitize_named_props && lower is ("id" | "name")
    if prefix {
      value = "user-content-" + value
    }
    let mut keep = true
    if self.config.safe_for_xml && unsafe_xml_attribute(value) {
      keep = false
    } else if lower == "attributename" && value.contains("href") {
      keep = false
    } else if !self.config.allow_self_close_in_attr && value.contains("/>") {
      keep = false
    } else {
      if self.config.safe_for_templates {
        value = clean_template_text(value)
      }
      keep = self.allows_attribute(tag, lower, value)
      if value != original && !valid_attribute_name(name) {
        keep = false
      }
    }
    if keep {
      if prefix {
        appended.push((name, value))
      } else {
        attributes[i] = Some((name, value))
      }
    } else if lower == "is" {
      // HTML serialization retains an inert `is` marker on customized builtins.
      appended.push((name, ""))
    }
  }
  let result = attributes.iter().filter_map(fn(value) { value }).collect()
  result.append(appended)
  result
}
