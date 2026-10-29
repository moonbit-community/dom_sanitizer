///|
test "parser scripting is disabled and template content is separate" {
  let doc = @html.parse("<div><template><img src=x onerror=x></template></div>")
  assert_eq(doc.scripting_enabled, false)
  let div = doc.get_children(doc.body_element)[0]
  let template = doc.get_children(div)[0]
  assert_eq(doc.get_children(template), [])
  let content = doc.get_template_content(template)
  let image = doc.get_children(content)[0]
  assert_true(doc.is_html_element(image, "img"))
  assert_eq(doc.get_attribute(image, "onerror"), Some("x"))
  assert_eq(
    sanitize("<div><template><img src=x onerror=x></template></div>"),
    "<div><template><img src=\"x\"></template></div>",
  )
}

///|
test "parser preserves foreign namespaces and qualified attributes" {
  let doc = @html.parse(
    "<svg><image xlink:href='javascript:x'/><foreignObject><p>x</p></foreignObject></svg>",
  )
  let svg = doc.get_children(doc.body_element)[0]
  let children = doc.get_children(svg)
  let image = children[0]
  assert_eq(doc.get_ns(image), Some(SVG))
  assert_eq(doc.get_attribute(image, "xlink href"), Some("javascript:x"))
  let p = doc.get_children(children[1])[0]
  assert_eq(doc.get_ns(p), Some(HTML))
}

///|
test "parser mXSS fixture retains information needed by namespace filtering" {
  let doc = @html.parse(
    "<math><mtext><table><mglyph><style><!--</style><img title='--><img src=1 onerror=x>'>",
  )
  let math = doc.get_children(doc.body_element)[0]
  let mtext = doc.get_children(math)[0]
  let children = doc.get_children(mtext)
  assert_eq(doc.get_tag_name(children[0]), Some("mglyph"))
  assert_eq(doc.get_ns(children[0]), Some(HTML))
  assert_eq(doc.get_tag_name(children[1]), Some("table"))
  assert_eq(
    sanitize(
      "<math><mtext><table><mglyph><style><!--</style><img title='--><img src=1 onerror=x>'>",
    ),
    "<math><mtext><table></table></mtext></math>",
  )
}
