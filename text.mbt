// Text and URI rules adapted from DOMPurify 3.3.3; see THIRD_PARTY_NOTICES.

///|
fn is_ascii_word(c : Char) -> Bool {
  c is ('a'..<='z' | 'A'..<='Z' | '0'..<='9' | '_')
}

///|
fn is_js_whitespace(c : Char) -> Bool {
  c
  is ('\u{0009}'..<='\u{000d}'
  | ' '
  | '\u{00a0}'
  | '\u{1680}'
  | '\u{2000}'..<='\u{200a}'
  | '\u{2028}'
  | '\u{2029}'
  | '\u{202f}'
  | '\u{205f}'
  | '\u{3000}'
  | '\u{feff}')
}

///|
fn trim_attribute(value : String) -> String {
  let chars = value.to_array()
  let mut start = 0
  let mut end = chars.length()
  while start < end && is_js_whitespace(chars[start]) {
    start += 1
  }
  while end > start && is_js_whitespace(chars[end - 1]) {
    end -= 1
  }
  String::from_array(chars[start:end])
}

///|
fn compact_uri(value : String) -> String {
  String::from_iter(
    value
    .iter()
    .filter(fn(c) {
      !(c
      is ('\u{0000}'..<='\u{0020}'
      | '\u{00a0}'
      | '\u{1680}'
      | '\u{180e}'
      | '\u{2000}'..<='\u{2029}'
      | '\u{205f}'
      | '\u{3000}'))
    }),
  )
}

///|
fn allowed_uri(value : String) -> Bool {
  if value.is_empty() {
    return false
  }
  if !(value[0] is ('a'..<='z' | 'A'..<='Z')) {
    return true
  }
  for i = 0; i < value.length(); i = i + 1 {
    if !(value[i] is ('a'..<='z' | 'A'..<='Z' | '+' | '.' | '-')) {
      if value[i] != ':' {
        return true
      }
      let scheme = value[:i].to_owned().to_lower()
      return scheme
        is ("http"
        | "https"
        | "ftp"
        | "ftps"
        | "mailto"
        | "tel"
        | "callto"
        | "sms"
        | "cid"
        | "xmpp"
        | "matrix")
    }
  }
  true
}

///|
fn script_or_data_uri(value : String) -> Bool {
  let lower = value.to_lower()
  if lower.has_prefix("data:") {
    return true
  }
  match value.split_once(":") {
    Some((scheme, _)) =>
      scheme.length() > 6 &&
      scheme.iter().all(is_ascii_word) &&
      scheme.to_owned().to_lower().has_suffix("script")
    None => false
  }
}

///|
fn template_pair(value : String, open : String, close : String) -> String {
  if value.has_prefix(open) {
    return " "
  }
  let value = match value.rev_find(close) {
    Some(index) => " " + value[index + close.length():].to_owned()
    None => value
  }
  match value.find(open) {
    Some(index) => value[:index].to_owned() + " "
    None => value
  }
}

///|
fn clean_template_text(value : String) -> String {
  let value = template_pair(template_pair(value, "{{", "}}"), "<%", "%>")
  match value.find("${") {
    Some(index) => value[:index].to_owned() + " "
    None => value
  }
}

///|
fn has_markup(value : String, include_bang~ : Bool) -> Bool {
  let mut after_open = false
  for c in value {
    if after_open &&
      (is_ascii_word(c) || c == '/' || (include_bang && c == '!')) {
      return true
    }
    after_open = c == '<'
  }
  false
}

///|
fn unsafe_xml_attribute(value : String) -> Bool {
  if value.contains("-->") || value.contains("--!>") || value.contains("]>") {
    return true
  }
  let lower = value.to_lower()
  [
    "style", "script", "title", "xmp", "textarea", "noscript", "iframe", "noembed",
    "noframes",
  ].any(fn(tag) { lower.contains("</" + tag) })
}

///|
fn is_xml_name_start(c : Char) -> Bool {
  c
  is (':'
  | '_'
  | 'A'..<='Z'
  | 'a'..<='z'
  | '\u{c0}'..<='\u{d6}'
  | '\u{d8}'..<='\u{f6}'
  | '\u{f8}'..<='\u{2ff}'
  | '\u{370}'..<='\u{37d}'
  | '\u{37f}'..<='\u{1fff}'
  | '\u{200c}'..<='\u{200d}'
  | '\u{2070}'..<='\u{218f}'
  | '\u{2c00}'..<='\u{2fef}'
  | '\u{3001}'..<='\u{d7ff}'
  | '\u{f900}'..<='\u{fdcf}'
  | '\u{fdf0}'..<='\u{fffd}'
  | '\u{10000}'..<='\u{effff}')
}

///|
fn valid_attribute_name(name : String) -> Bool {
  guard name.get_char(0) is Some(c) && is_xml_name_start(c) else {
    return false
  }
  name
  .iter()
  .all(fn(c) {
    is_xml_name_start(c) ||
    c
    is ('-'
    | '.'
    | '0'..<='9'
    | '\u{b7}'
    | '\u{0300}'..<='\u{036f}'
    | '\u{203f}'..<='\u{2040}')
  })
}
