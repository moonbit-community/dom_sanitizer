///|
test "panic XHTML is explicitly unsupported" {
  ignore(
    @dom_sanitizer.sanitize("<p>x</p>", config={
      ..@dom_sanitizer.Config::default(),
      parser_media_type: @dom_sanitizer.PARSER_MEDIA_TYPE_XHTML,
    }),
  )
}

///|
test "panic non HTML root is explicitly unsupported" {
  ignore(
    @dom_sanitizer.sanitize("<svg/>", config={
      ..@dom_sanitizer.Config::default(),
      namespace_uri: @dom_sanitizer.NAMESPACE_SVG,
    }),
  )
}

///|
test "panic MathML root is explicitly unsupported" {
  ignore(
    @dom_sanitizer.sanitize("<math/>", config={
      ..@dom_sanitizer.Config::default(),
      namespace_uri: @dom_sanitizer.NAMESPACE_MATHML,
    }),
  )
}

///|
test "panic URI callback remains explicitly unsupported" {
  ignore(
    @dom_sanitizer.sanitize("plain text", config={
      ..@dom_sanitizer.Config::default(),
      allowed_uri_check: Some(fn(_) { true }),
    }),
  )
}

///|
test "configuration and integration points never leak between calls" {
  let foreign = "<svg><foreignObject><p>x</p></foreignObject></svg>"
  let added = {
    ..@dom_sanitizer.Config::default(),
    add_tags: Some(["foreignobject"]),
    html_integration_points: Some(["foreignobject"]),
  }
  assert_eq(@dom_sanitizer.sanitize(foreign, config=added), foreign)
  assert_eq(
    @dom_sanitizer.sanitize(foreign, config={
      ..added,
      html_integration_points: None,
    }),
    "<svg><foreignObject></foreignObject></svg>",
  )
  let math = "<math><mtext><b>x</b></mtext></math>"
  assert_eq(
    @dom_sanitizer.sanitize(math, config={
      ..@dom_sanitizer.Config::default(),
      mathml_text_integration_points: Some([]),
    }),
    "<math><mtext></mtext></math>",
  )
  assert_eq(@dom_sanitizer.sanitize(math), math)
  let custom = "<x-box custom=\"ok\">x</x-box>"
  assert_eq(
    @dom_sanitizer.sanitize(custom, config={
      ..@dom_sanitizer.Config::default(),
      add_tag_check: Some(fn(tag) { tag == "x-box" }),
      add_attr_check: Some(fn(name, _) { name == "custom" }),
    }),
    custom,
  )
  assert_eq(@dom_sanitizer.sanitize(custom), "x")
  let tags = ["p"]
  let attributes : Array[String] = []
  ignore(
    @dom_sanitizer.sanitize("<table><tr><td>x</table>", config={
      ..@dom_sanitizer.Config::default(),
      allowed_tags: Some(tags),
      allowed_attr: Some(attributes),
    }),
  )
  assert_eq(tags, ["p"])
  assert_eq(attributes, [])
}

///|
test "stable safe samples are idempotent" {
  for
    input in [
      "<p onclick=x>Hello &amp; 世界<img src=x onerror=x></p>", "<table><tr><td>x</td></tr></table>",
      "<b><i>x</b>y</i>", "<div><template><img src=x onerror=x><template><script>x</script></template></template></div>",
      "<svg viewBox='0 0 1 1'><linearGradient/><text>&lt;x&gt;</text></svg>", "<math><mtext><b>x</b></mtext></math>",
      "<img src='jav&#x09;ascript:alert(1)'>", "<div><style><img src=x onerror=x></style></div>",
      "<math><mtext><table><mglyph><style><!--</style><img title='--><img src=1 onerror=alert(1)>'>",
      "<svg></p><style><a id='</style><img src=1 onerror=alert(1)>'>",
    ] {
    let safe = @dom_sanitizer.sanitize(input)
    assert_eq(@dom_sanitizer.sanitize(safe), safe)
  }
}

///|
test "deep input uses explicit sanitizer and serializer stacks" {
  let input = "<div>".repeat(800) +
    "<img src=x onerror=alert(1)>" +
    "</div>".repeat(800)
  let expected = "<div>".repeat(800) + "<img src=\"x\">" + "</div>".repeat(800)
  assert_eq(@dom_sanitizer.sanitize(input), expected)
}

///|
test "frameset cannot expose a detached cached body" {
  assert_eq(
    @dom_sanitizer.sanitize("<div> <frameset onload=x><frame src=x>"),
    "",
  )
  assert_eq(
    @dom_sanitizer.sanitize("<frameset><frame src=x>", config={
      ..@dom_sanitizer.Config::default(),
      whole_document: true,
    }),
    "<html><head></head></html>",
  )
}

///|
test "URI checks distinguish empty values from whitespace after template cleaning" {
  assert_eq(
    @dom_sanitizer.sanitize("<a href=''>x</a><a href='{{x}}'>y</a>", config={
      ..@dom_sanitizer.Config::default(),
      safe_for_templates: true,
    }),
    "<a href=\"\">x</a><a>y</a>",
  )
}

///|
test "callback order includes the body wrapper and skips URI safe data attributes" {
  let visited : Array[String] = []
  assert_eq(
    @dom_sanitizer.sanitize(
      "<body title='root'><div title='x' data-x='x'><b>x</b></div></body>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tag_check: Some(fn(tag) {
          visited.push("tag:" + tag)
          false
        }),
        add_attr_check: Some(fn(name, tag) {
          visited.push("attr:" + tag + ":" + name)
          false
        }),
      },
    ),
    "<div title=\"x\" data-x=\"x\"><b>x</b></div>",
  )
  assert_eq(visited, [
    "tag:body", "attr:body:title", "tag:div", "attr:div:title", "tag:b", "tag:#text",
  ])
}
