// Tree policy adapted from DOMPurify 3.3.3; see THIRD_PARTY_NOTICES.

///|
fn has_fallback_close(value : String) -> Bool {
  let lower = value.to_lower()
  lower.contains("</noscript") ||
  lower.contains("</noembed") ||
  lower.contains("</noframes")
}

///|
fn unsafe_fallback_content(
  doc : @html.Document,
  element : @html.Element,
) -> Bool {
  // Look for fallback closing tags in serialized child markup. Escaped text in
  // ordinary HTML/SVG/MathML contexts is not markup. Walk template contents too.
  let stack : Array[(Int32, Bool)] = []
  let raw = is_raw_text(element.tag_name, element.ns)
  for id in element.children {
    stack.push((id, raw))
  }
  while stack.pop() is Some((id, raw)) {
    match doc.get_node(id) {
      Some(TextNode(text)) => if raw && has_fallback_close(text) { return true }
      Some(CommentNode(text)) => if has_fallback_close(text) { return true }
      Some(ElementNode(child)) => {
        if has_fallback_close("</" + child.tag_name) {
          return true
        }
        if child.attributes.any(fn(attr) { has_fallback_close(attr.1) }) {
          return true
        }
        let children = if child.ns == HTML && child.tag_name == "template" {
          doc.get_children(child.template_content)
        } else {
          child.children
        }
        let raw = is_raw_text(child.tag_name, child.ns)
        for id in children {
          stack.push((id, raw))
        }
      }
      _ => ()
    }
  }
  false
}

///|
fn unsafe_element_text(doc : @html.Document, element : @html.Element) -> Bool {
  // Equivalent to checking innerHTML and textContent on elements without an
  // element child. Text in non-raw contexts is escaped by the serializer.
  if element.children.any(fn(id) { doc.get_element(id) is Some(_) }) {
    return false
  }
  let text = StringBuilder()
  let mut serialized_markup = false
  for id in element.children {
    match doc.get_node(id) {
      Some(TextNode(value)) => {
        text.write_string(value)
        if is_raw_text(element.tag_name, element.ns) &&
          has_markup(value, include_bang=true) {
          serialized_markup = true
        }
      }
      Some(CommentNode(_)) => serialized_markup = true
      _ => ()
    }
  }
  serialized_markup && has_markup(text.to_string(), include_bang=true)
}

///|
fn sanitize_tree(
  doc : @html.Document,
  policy : Policy,
  leading : String,
) -> CleanTree {
  let tree : CleanTree = { nodes: [], roots: [], }
  let stack : Array[Visit] = []
  // A frameset can detach the parser's cached body_element. Only select a body
  // that is still a direct child of the document's html element.
  let mut root = doc.document_element
  if !policy.config.whole_document {
    root = -1
    for id in doc.get_children(doc.document_element) {
      if doc.is_html_element(id, "body") {
        root = id
        break
      }
    }
  }
  if root < 0 {
    return tree
  }
  if policy.config.whole_document {
    stack.push({
      source: root,
      parent: -1,
      parent_tag: "template",
      parent_ns: HTML,
    })
  } else {
    // The body wrapper is not emitted, but callbacks still observe it, as they
    // do with DOMPurify's NodeIterator rooted at the body.
    if doc.get_element(root) is Some(body) {
      if !policy.config.safe_for_xml || !unsafe_element_text(doc, body) {
        ignore(policy.allows_tag("body"))
      }
      ignore(policy.clean_attributes("body", body))
    }
    if !leading.is_empty() && policy.allows_tag("#text") {
      let _ = tree.append(-1, Text(leading))
    }
    let children = doc.get_children(root)
    // FORCE_BODY inserts a sentinel that starts the body's insertion mode.
    let skip = if policy.config.force_body { 1 } else { 0 }
    for i = children.length() - 1; i >= skip; i = i - 1 {
      stack.push({
        source: children[i],
        parent: -1,
        parent_tag: "body",
        parent_ns: HTML,
      })
    }
  }
  while stack.pop() is Some(visit) {
    match doc.get_node(visit.source) {
      Some(TextNode(value)) =>
        if policy.allows_tag("#text") {
          let value = if policy.config.safe_for_templates {
            clean_template_text(value)
          } else {
            value
          }
          let _ = tree.append(visit.parent, Text(value))
        }
      Some(CommentNode(value)) =>
        if (
            !policy.config.safe_for_xml ||
            !has_markup(value, include_bang=false)
          ) &&
          policy.allows_tag("#comment") {
          let _ = tree.append(visit.parent, Comment(value))
        }
      Some(ElementNode(element)) => {
        let tag = element.tag_name.to_lower()
        if policy.config.safe_for_xml && unsafe_element_text(doc, element) {
          ignore(policy.clean_attributes(tag, element))
          continue
        }
        let permission = policy.tag_permission(tag)
        if permission == Forbidden {
          if policy.config.keep_content && !policy.forbid_contents.contains(tag) {
            // A template's ordinary child list is empty. Its content must not
            // escape when the template itself is removed.
            push_children(
              stack,
              element.children,
              visit.parent,
              visit.parent_tag,
              visit.parent_ns,
            )
          }
          ignore(policy.clean_attributes(tag, element))
          continue
        }
        // The custom-element hook explicitly opts into otherwise unknown names,
        // including foreign names, matching the reference policy's early return.
        if permission != Custom &&
          !policy.valid_namespace(
            tag,
            element.ns,
            visit.parent_tag,
            visit.parent_ns,
          ) {
          ignore(policy.clean_attributes(tag, element))
          continue
        }
        if tag is ("noscript" | "noembed" | "noframes") {
          if unsafe_fallback_content(doc, element) {
            ignore(policy.clean_attributes(tag, element))
            continue
          }
        }
        let attributes = policy.clean_attributes(tag, element)
        let parent = tree.append(
          visit.parent,
          Element(element.tag_name, element.ns, attributes, []),
        )
        if element.ns == HTML &&
          tag == "body" &&
          !leading.is_empty() &&
          policy.allows_tag("#text") {
          let _ = tree.append(parent, Text(leading))
        }
        let children = if element.ns == HTML && tag == "template" {
          doc.get_children(element.template_content)
        } else {
          element.children
        }
        // DOMPurify's whole-document FORCE_BODY mode removes html.firstChild
        // (head), leaving the sentinel for ordinary policy filtering.
        let skip = if policy.config.force_body &&
          policy.config.whole_document &&
          visit.source == root {
          1
        } else {
          0
        }
        for i = children.length() - 1; i >= skip; i = i - 1 {
          stack.push({
            source: children[i],
            parent,
            parent_tag: tag,
            parent_ns: element.ns,
          })
        }
      }
      _ => () // Doctypes are handled separately; processing instructions are dropped.
    }
  }
  tree
}

///|
fn sanitize_html(input : String, config : Config) -> String {
  if config.parser_media_type != PARSER_MEDIA_TYPE_HTML {
    abort("dom_sanitizer supports only text/html; XHTML is not supported")
  }
  if config.namespace_uri != NAMESPACE_HTML {
    abort("dom_sanitizer supports only an HTML root namespace")
  }
  if config.allowed_uri_check is Some(_) {
    abort("Config.allowed_uri_check is not supported")
  }
  if !config.whole_document &&
    !config.safe_for_templates &&
    !input.contains("<") {
    return input
  }
  let policy = Policy::new(config)
  let mut leading = ""
  if !config.force_body {
    let mut length = 0
    while length < input.length() && input[length] is ('\r' | '\n' | '\t' | ' ') {
      length += 1
    }
    leading = input[:length].to_owned()
  }
  let source = if config.force_body {
    "<remove></remove>" + input
  } else {
    input
  }
  // `parse` uses the full document algorithm with scripting disabled.
  let doc = @html.parse(source)
  let tree = sanitize_tree(doc, policy, leading)
  let mut result = tree.serialize()
  if config.whole_document && policy.tags.contains("!doctype") {
    for id in doc.get_children(0) {
      if doc.get_node(id) is Some(DocumentTypeNode(name~, ..)) &&
        name.to_lower() == "html" {
        result = "<!DOCTYPE " + name + ">\n" + result
        break
      }
    }
  }
  if config.safe_for_templates {
    clean_template_text(result)
  } else {
    result
  }
}
