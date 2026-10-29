// Recorded against DOMPurify 3.3.3 / jsdom 29.0.1 before the pure MoonBit migration.
// Inputs, configuration mappings and documented exceptions: tools/cases.mjs.

///|
test "empty allowed tags retains text" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={ ..@dom_sanitizer.Config::default(), allowed_tags: Some([]), },
    ),
    "textboldcustom",
  )
}

///|
test "empty allowed tags and no content" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        allowed_tags: Some([]),
        keep_content: false,
      },
    ),
    "",
  )
}

///|
test "empty allowed attributes keeps data and aria" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={ ..@dom_sanitizer.Config::default(), allowed_attr: Some([]), },
    ),
    "<p data-x=\"1\" aria-label=\"label\">text<b>bold</b>custom</p>",
  )
}

///|
test "empty allowed attributes without data and aria" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        allowed_attr: Some([]),
        allow_data_attr: false,
        allow_aria_attr: false,
      },
    ),
    "<p>text<b>bold</b>custom</p>",
  )
}

///|
test "empty namespaces" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        allowed_namespaces: Some([]),
      },
    ),
    "",
  )
}

///|
test "case insensitive lists" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        allowed_tags: Some(["P", "B"]),
        allowed_attr: Some(["TITLE"]),
      },
    ),
    "<p title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b>custom</p>",
  )
}

///|
test "explicit text exclusion" {
  assert_eq(
    @dom_sanitizer.sanitize("<p>a<b>b</b>c</p>", config={
      ..@dom_sanitizer.Config::default(),
      allowed_tags: Some(["p", "b"]),
      keep_content: false,
    }),
    "<p><b></b></p>",
  )
}

///|
test "profiles override allow lists" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        allowed_tags: Some([]),
        allowed_attr: Some([]),
        use_profiles: Some({
          ..@dom_sanitizer.UseProfilesConfig::default(),
          html: true,
        }),
      },
    ),
    "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b>custom</p>",
  )
}

///|
test "empty profiles" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        use_profiles: Some({ ..@dom_sanitizer.UseProfilesConfig::default(), }),
      },
    ),
    "textboldcustom",
  )
}

///|
test "svg profile" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><circle cx=\"2\"/><filter><feGaussianBlur stdDeviation=\"2\"/></filter></svg><p>x</p>",
      config={
        ..@dom_sanitizer.Config::default(),
        use_profiles: Some({
          ..@dom_sanitizer.UseProfilesConfig::default(),
          svg: true,
        }),
      },
    ),
    "<svg><circle cx=\"2\"></circle><filter></filter></svg>x",
  )
}

///|
test "svg filters profile" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><filter><feGaussianBlur stdDeviation=\"2\"/></filter></svg>",
      config={
        ..@dom_sanitizer.Config::default(),
        use_profiles: Some({
          ..@dom_sanitizer.UseProfilesConfig::default(),
          svg_filters: true,
        }),
        add_tags: Some(["svg", "filter"]),
      },
    ),
    "<svg><filter><feGaussianBlur stdDeviation=\"2\"></feGaussianBlur></filter></svg>",
  )
}

///|
test "math profile" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<math><mi href=\"javascript:x\">x</mi><mo>+</mo><mn>2</mn></math>",
      config={
        ..@dom_sanitizer.Config::default(),
        use_profiles: Some({
          ..@dom_sanitizer.UseProfilesConfig::default(),
          math_ml: true,
        }),
      },
    ),
    "<math><mi>x</mi><mo>+</mo><mn>2</mn></math>",
  )
}

///|
test "all profiles" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p>x</p><svg><circle/></svg><math><mn>2</mn></math>",
      config={
        ..@dom_sanitizer.Config::default(),
        use_profiles: Some({
          html: true,
          svg: true,
          svg_filters: true,
          math_ml: true,
        }),
      },
    ),
    "<p>x</p><svg><circle></circle></svg><math><mn>2</mn></math>",
  )
}

///|
test "forbid overrides lists" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["x-box"]),
        forbid_tags: Some(["b", "x-box"]),
        add_attr: Some(["title"]),
        forbid_attr: Some(["title", "data-x", "aria-label"]),
      },
    ),
    "<p id=\"ok\">textboldcustom</p>",
  )
}

///|
test "tag predicate precedence" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config={
        ..@dom_sanitizer.Config::default(),
        forbid_tags: Some(["x-box"]),
        add_tag_check: Some(fn(tag) { tag == "x-box" }),
      },
    ),
    "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
  )
}

///|
test "tag list and predicate use or" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<x-box>a</x-box><x-other>b</x-other><x-no>c</x-no>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["X-OTHER"]),
        add_tag_check: Some(fn(tag) { tag == "x-box" }),
      },
    ),
    "<x-box>a</x-box><x-other>b</x-other>c",
  )
}

///|
test "attribute list validates URI" {
  assert_eq(
    @dom_sanitizer.sanitize("<p custom=\"javascript:x\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      add_attr: Some(["custom"]),
    }),
    "<p>x</p>",
  )
}

///|
test "attribute predicate accepts values" {
  assert_eq(
    @dom_sanitizer.sanitize("<p custom=\"javascript:x\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      add_attr_check: Some(fn(attr, tag) {
        attr == "custom" && (tag == "p" || tag == "x-box")
      }),
    }),
    "<p custom=\"javascript:x\">x</p>",
  )
}

///|
test "attribute list and predicate use or" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p custom=\"a\" extra=\"javascript:x\" nope=\"x\">x</p>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_attr: Some(["EXTRA"]),
        add_attr_check: Some(fn(attr, tag) {
          attr == "custom" && (tag == "p" || tag == "x-box")
        }),
      },
    ),
    "<p custom=\"a\" extra=\"javascript:x\">x</p>",
  )
}

///|
test "forbidden attributes override predicates" {
  assert_eq(
    @dom_sanitizer.sanitize("<p custom=\"a\" extra=\"x\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      add_attr: Some(["extra"]),
      add_attr_check: Some(fn(attr, tag) {
        attr == "custom" && (tag == "p" || tag == "x-box")
      }),
      forbid_attr: Some(["custom", "extra"]),
    }),
    "<p>x</p>",
  )
}

///|
test "custom tags and attributes" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<x-box custom=\"javascript:x\" extra=\"no\" onclick=\"x\"><b>yes</b></x-box>",
      config={
        ..@dom_sanitizer.Config::default(),
        custom_element_handling: Some({
          ..@dom_sanitizer.CustomElementHandling::default(),
          tag_name_check: Some(fn(tag) { tag == "x-box" }),
          attribute_name_check: Some(fn(attr, tag) {
            attr == "custom" && (tag == "p" || tag == "x-box")
          }),
        }),
      },
    ),
    "<x-box custom=\"javascript:x\"><b>yes</b></x-box>",
  )
}

///|
test "forbidden custom tag" {
  assert_eq(
    @dom_sanitizer.sanitize("<x-box custom=\"a\">yes</x-box>", config={
      ..@dom_sanitizer.Config::default(),
      custom_element_handling: Some({
        ..@dom_sanitizer.CustomElementHandling::default(),
        tag_name_check: Some(fn(tag) { tag == "x-box" }),
        attribute_name_check: Some(fn(attr, tag) {
          attr == "custom" && (tag == "p" || tag == "x-box")
        }),
      }),
      forbid_tags: Some(["x-box"]),
    }),
    "yes",
  )
}

///|
test "custom attribute cannot override forbid" {
  assert_eq(
    @dom_sanitizer.sanitize("<x-box custom=\"a\">yes</x-box>", config={
      ..@dom_sanitizer.Config::default(),
      custom_element_handling: Some({
        ..@dom_sanitizer.CustomElementHandling::default(),
        tag_name_check: Some(fn(tag) { tag == "x-box" }),
        attribute_name_check: Some(fn(attr, tag) {
          attr == "custom" && (tag == "p" || tag == "x-box")
        }),
      }),
      forbid_attr: Some(["custom"]),
    }),
    "<x-box>yes</x-box>",
  )
}

///|
test "customized builtins disabled" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div is=\"x-box\">ok</div>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<div is=\"\">ok</div>",
  )
}

///|
test "customized builtins enabled" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div is=\"x-box\">ok</div><div is=\"x-no\">no</div>",
      config={
        ..@dom_sanitizer.Config::default(),
        custom_element_handling: Some({
          ..@dom_sanitizer.CustomElementHandling::default(),
          tag_name_check: Some(fn(tag) { tag == "x-box" }),
          allow_customized_built_in_elements: true,
        }),
      },
    ),
    "<div is=\"x-box\">ok</div><div is=\"\">no</div>",
  )
}

///|
test "invalid custom names" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<x--box>a</x--box><annotation-xml>b</annotation-xml><x-box>c</x-box>",
      config={
        ..@dom_sanitizer.Config::default(),
        custom_element_handling: Some({
          ..@dom_sanitizer.CustomElementHandling::default(),
          tag_name_check: Some(fn(_tag) { true }),
        }),
      },
    ),
    "a<x-box>c</x-box>",
  )
}

///|
test "forbidden contents replacement" {
  assert_eq(
    @dom_sanitizer.sanitize("<x-box>a<b>b</b></x-box><script>c</script>", config={
      ..@dom_sanitizer.Config::default(),
      forbid_contents: Some([]),
    }),
    "a<b>b</b>c",
  )
}

///|
test "forbidden contents addition" {
  assert_eq(
    @dom_sanitizer.sanitize("<x-box>a<b>b</b></x-box><script>c</script>", config={
      ..@dom_sanitizer.Config::default(),
      add_forbid_contents: Some(["x-box"]),
    }),
    "",
  )
}

///|
test "keep content false" {
  assert_eq(
    @dom_sanitizer.sanitize("<x-box>a<b>b</b></x-box><p>c</p>", config={
      ..@dom_sanitizer.Config::default(),
      keep_content: false,
    }),
    "<p>c</p>",
  )
}

///|
test "forbid content only applies to removed tags" {
  assert_eq(
    @dom_sanitizer.sanitize("<div>a<b>b</b></div>", config={
      ..@dom_sanitizer.Config::default(),
      forbid_contents: Some(["div"]),
    }),
    "<div>a<b>b</b></div>",
  )
}

///|
test "table requires tbody" {
  assert_eq(
    @dom_sanitizer.sanitize("<table><tr><td>x</td></tr></table>", config={
      ..@dom_sanitizer.Config::default(),
      allowed_tags: Some(["table", "tr", "td"]),
      forbid_tags: Some(["tbody"]),
    }),
    "<table><tbody><tr><td>x</td></tr></tbody></table>",
  )
}

///|
test "leading whitespace" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "\r\n\t <p>x</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "\r\n\t <p>x</p>",
  )
}

///|
test "leading whitespace whole document" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "\n <html><head><title>x</title></head><body>y</body></html>",
      config={
        ..@dom_sanitizer.Config::default(),
        whole_document: true,
        add_tags: Some(["title"]),
      },
    ),
    "<html><head><title>x</title></head><body>\n y</body></html>",
  )
}

///|
test "head omitted" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<title>x</title><style>p{color:red}</style><p>y</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p>y</p>",
  )
}

///|
test "force body" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "\r\n <title>x</title><style>p{color:red}</style><p>y</p>",
      config={ ..@dom_sanitizer.Config::default(), force_body: true, },
    ),
    "\n <title>x</title><style>p{color:red}</style><p>y</p>",
  )
}

///|
test "whole document" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<!doctype html><html lang=\"en\"><head><title>x</title></head><body id=\"ok\">y</body></html>",
      config={ ..@dom_sanitizer.Config::default(), whole_document: true, },
    ),
    "<html lang=\"en\"><head><title>x</title></head><body id=\"ok\">y</body></html>",
  )
}

///|
test "whole document doctype" {
  assert_eq(
    @dom_sanitizer.sanitize("<!doctype html PUBLIC \"unsafe\"><p>x</p>", config={
      ..@dom_sanitizer.Config::default(),
      whole_document: true,
      add_tags: Some(["!doctype"]),
    }),
    "<!DOCTYPE html>\n<html><head></head><body><p>x</p></body></html>",
  )
}

///|
test "whole document invalid doctype" {
  assert_eq(
    @dom_sanitizer.sanitize("<!doctype svg><p>x</p>", config={
      ..@dom_sanitizer.Config::default(),
      whole_document: true,
      add_tags: Some(["!doctype"]),
    }),
    "<html><head></head><body><p>x</p></body></html>",
  )
}

///|
test "whole document force body" {
  assert_eq(
    @dom_sanitizer.sanitize("<title>x</title><p>y</p>", config={
      ..@dom_sanitizer.Config::default(),
      whole_document: true,
      force_body: true,
    }),
    "<html><body><title>x</title><p>y</p></body></html>",
  )
}

///|
test "empty whole document" {
  assert_eq(
    @dom_sanitizer.sanitize("", config={
      ..@dom_sanitizer.Config::default(),
      whole_document: true,
    }),
    "<html><head></head><body></body></html>",
  )
}

///|
test "plain text fast path" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "a &amp; b\r\n",
      config=@dom_sanitizer.Config::default(),
    ),
    "a &amp; b\r\n",
  )
}

///|
test "templates text and attributes" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p title=\"hi {{x}} tail\" data-x=\"y\">before {{x}} after</p><b><%= x %></b><i>${x}</i>",
      config={ ..@dom_sanitizer.Config::default(), safe_for_templates: true, },
    ),
    "<p title=\"  tail\">  after</p><b> </b><i> </i>",
  )
}

///|
test "templates closing markers" {
  assert_eq(
    @dom_sanitizer.sanitize("<p>a}}b</p><p>a%>b</p><p>a${b</p>", config={
      ..@dom_sanitizer.Config::default(),
      safe_for_templates: true,
    }),
    "<p> b</p><p> b</p><p>a </p>",
  )
}

///|
test "templates split across nodes" {
  assert_eq(
    @dom_sanitizer.sanitize("<p>{<b>{x}</b>}</p>", config={
      ..@dom_sanitizer.Config::default(),
      safe_for_templates: true,
    }),
    "<p>{<b>{x}</b>}</p>",
  )
}

///|
test "templates explicit data allowance" {
  assert_eq(
    @dom_sanitizer.sanitize("<p data-x=\"{{x}}\" data-y=\"safe\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      safe_for_templates: true,
      add_attr: Some(["data-x"]),
    }),
    "<p>x</p>",
  )
}

///|
test "templates plain text" {
  assert_eq(
    @dom_sanitizer.sanitize("{{x}}", config={
      ..@dom_sanitizer.Config::default(),
      safe_for_templates: true,
    }),
    " ",
  )
}

///|
test "self close attribute disallowed" {
  assert_eq(
    @dom_sanitizer.sanitize("<p title=\"a/>b\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      allow_self_close_in_attr: false,
    }),
    "<p>x</p>",
  )
}

///|
test "self close attribute default" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p title=\"a/>b\">x</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p title=\"a/>b\">x</p>",
  )
}

///|
test "xml dangerous attribute" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p title=\"a-->b\" class=\"</style>\">x</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p>x</p>",
  )
}

///|
test "xml safety disabled" {
  assert_eq(
    @dom_sanitizer.sanitize("<p title=\"a-->b\" class=\"</style>\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      safe_for_xml: false,
    }),
    "<p title=\"a-->b\" class=\"</style>\">x</p>",
  )
}

///|
test "reserved DOM names" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<form id=\"body\"><input name=\"submit\"><input name=\"parentNode\"><a id=\"constructor\">x</a></form>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<form><input><input><a>x</a></form>",
  )
}

///|
test "DOM names allowed explicitly" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<form id=\"body\"><input name=\"submit\"><input name=\"parentNode\"><a id=\"constructor\">x</a></form>",
      config={ ..@dom_sanitizer.Config::default(), sanitize_dom: false, },
    ),
    "<form id=\"body\"><input name=\"submit\"><input name=\"parentNode\"><a id=\"constructor\">x</a></form>",
  )
}

///|
test "named property prefix and attribute order" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"body\" name=\"submit\" title=\"hi\">x</p>",
      config={ ..@dom_sanitizer.Config::default(), sanitize_named_props: true, },
    ),
    "<p title=\"hi\" name=\"user-content-submit\" id=\"user-content-body\">x</p>",
  )
}

///|
test "attribute trimming value exception" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<input id=\" ok \" title=\" hi \" value=\" hi \"><a href=\"\r\nhttps://x\t\">x</a>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<input id=\"ok\" title=\"hi\" value=\" hi \"><a href=\"https://x\">x</a>",
  )
}

///|
test "URI entities and controls" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<a href=\"jav&#x09;ascript:alert(1)\">a</a><a href=\"&#106;avascript:x\">b</a><a href=\"jav&#x200B;ascript:x\">c</a>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<a>a</a><a>b</a><a>c</a>",
  )
}

///|
test "unknown URI blocked" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<a href=\"custom:abc\">x</a><a href=\"https://x\">y</a>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<a>x</a><a href=\"https://x\">y</a>",
  )
}

///|
test "unknown URI allowed" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<a href=\"custom:abc\">x</a><a href=\"vbscript:x\">y</a><a href=\"data:x\">z</a>",
      config={
        ..@dom_sanitizer.Config::default(),
        allow_unknown_protocols: true,
      },
    ),
    "<a href=\"custom:abc\">x</a><a>y</a><a>z</a>",
  )
}

///|
test "data URI extra tag" {
  assert_eq(
    @dom_sanitizer.sanitize("<a href=\"data:text/plain,x\">x</a>", config={
      ..@dom_sanitizer.Config::default(),
      add_data_uri_tags: Some(["a"]),
    }),
    "<a href=\"data:text/plain,x\">x</a>",
  )
}

///|
test "URI safe extra attribute" {
  assert_eq(
    @dom_sanitizer.sanitize("<p custom=\"javascript:x\">x</p>", config={
      ..@dom_sanitizer.Config::default(),
      add_attr: Some(["custom"]),
      add_uri_safe_attr: Some(["custom"]),
    }),
    "<p custom=\"javascript:x\">x</p>",
  )
}

///|
test "URI protocol edge cases" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<a href=\"1:abc\">a</a><a href=\"ab1:abc\">b</a><a href=\"ab+cd:x\">c</a><a href=\"matrix:x\">d</a><a href=\"\">e</a>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<a href=\"1:abc\">a</a><a href=\"ab1:abc\">b</a><a>c</a><a href=\"matrix:x\">d</a><a href=\"\">e</a>",
  )
}

///|
test "ARIA and data name validation" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p data-=\"x\" data-a.b=\"javascript:x\" aria-a_b=\"x\" aria-a.b=\"x\" data-中文=\"yes\">x</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p data-a.b=\"javascript:x\" aria-a_b=\"x\" data-中文=\"yes\">x</p>",
  )
}

///|
test "HTML namespace only" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p>a</p><svg><circle/></svg><math><mi>x</mi></math>",
      config={
        ..@dom_sanitizer.Config::default(),
        allowed_namespaces: Some(["http://www.w3.org/1999/xhtml"]),
      },
    ),
    "<p>a</p>",
  )
}

///|
test "svg integration point default" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><foreignObject><p>x</p></foreignObject></svg>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["foreignobject"]),
      },
    ),
    "<svg><foreignObject></foreignObject></svg>",
  )
}

///|
test "svg integration point configured" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><foreignObject><p>x</p></foreignObject></svg>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["foreignobject"]),
        html_integration_points: Some(["FOREIGNOBJECT"]),
      },
    ),
    "<svg><foreignObject><p>x</p></foreignObject></svg>",
  )
}

///|
test "math integration point disabled" {
  assert_eq(
    @dom_sanitizer.sanitize("<math><mtext><b>x</b></mtext></math>", config={
      ..@dom_sanitizer.Config::default(),
      mathml_text_integration_points: Some([]),
    }),
    "<math><mtext></mtext></math>",
  )
}

///|
test "math integration point default" {
  assert_eq(
    @dom_sanitizer.sanitize("<math><mtext><b>x</b></mtext></math>", config={
      ..@dom_sanitizer.Config::default(),
      mathml_text_integration_points: Some(["mi", "mo", "mn", "ms", "mtext"]),
    }),
    "<math><mtext><b>x</b></mtext></math>",
  )
}

///|
test "template content" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div><template><p onclick=\"x\">ok<script>x</script></p><template><img onerror=x src=x></template></template></div>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<div><template><p>ok</p><template><img src=\"x\"></template></template></div>",
  )
}

///|
test "template removed" {
  assert_eq(
    @dom_sanitizer.sanitize("<div><template><p>x</p></template>y</div>", config={
      ..@dom_sanitizer.Config::default(),
      forbid_tags: Some(["template"]),
      forbid_contents: Some([]),
    }),
    "<div>y</div>",
  )
}

///|
test "table repair" {
  // HTML table foster parenting; validated in Chromium 141
  assert_eq(
    @dom_sanitizer.sanitize(
      "<table>before<tr><td><b>x</table>after",
      config=@dom_sanitizer.Config::default(),
    ),
    "before<table><tbody><tr><td><b>x</b></td></tr></tbody></table>after",
  )
}

///|
test "formatting repair" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<b><i>x</b>y</i>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<b><i>x</i></b><i>y</i>",
  )
}

///|
test "foreign casing" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg viewBox=\"0 0 1 1\"><linearGradient gradientUnits=\"userSpaceOnUse\"/></svg>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<svg viewBox=\"0 0 1 1\"><linearGradient gradientUnits=\"userSpaceOnUse\"></linearGradient></svg>",
  )
}

///|
test "raw text and RCDATA" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div><style>a>b{content:\"&\"}</style><textarea>&lt;a&gt;&amp;</textarea></div>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<div><style>a>b{content:\"&\"}</style><textarea>&lt;a&gt;&amp;</textarea></div>",
  )
}

///|
test "XML mutation protection raw text" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div><style><img src=x onerror=x></style></div>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<div></div>",
  )
}

///|
test "foreign text escaping" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><text>&lt;&gt;&amp;&nbsp;</text></svg>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<svg><text>&lt;&gt;&amp;&nbsp;</text></svg>",
  )
}

///|
test "attribute escaping" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p title=\"&quot;&amp;&lt;&gt;&nbsp;\">&lt;&gt;&amp;&nbsp;😀</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p title=\"&quot;&amp;<>\">&lt;&gt;&amp;&nbsp;😀</p>",
  )
}

///|
test "animation attribute protection" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><animate attributeName=\"href\" values=\"x\"/><animate attributeName=\"x\" values=\"1;2\"/></svg>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["animate"]),
      },
    ),
    "<svg><animate values=\"x\"></animate><animate attributeName=\"x\" values=\"1;2\"></animate></svg>",
  )
}

///|
test "call isolation after callbacks" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b><x-box>custom</x-box></p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p id=\"ok\" title=\"hi\" data-x=\"1\" aria-label=\"label\">text<b>bold</b>custom</p>",
  )
}

///|
test "custom foreign elements" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><x-box custom=\"x\">safe</x-box></svg><x-box>yes</x-box>",
      config={
        ..@dom_sanitizer.Config::default(),
        custom_element_handling: Some({
          ..@dom_sanitizer.CustomElementHandling::default(),
          tag_name_check: Some(fn(tag) { tag == "x-box" }),
        }),
      },
    ),
    "<svg><x-box>safe</x-box></svg><x-box>yes</x-box>",
  )
}

///|
test "custom element namespace opt in" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<svg><x-box custom=\"x\">safe</x-box></svg><x-box>yes</x-box>",
      config={
        ..@dom_sanitizer.Config::default(),
        custom_element_handling: Some({
          ..@dom_sanitizer.CustomElementHandling::default(),
          tag_name_check: Some(fn(tag) { tag == "x-box" }),
        }),
        allowed_namespaces: Some([]),
      },
    ),
    "<x-box>yes</x-box>",
  )
}

///|
test "fallback element escaped text" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div><noscript>&lt;/noscript&gt;</noscript></div>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["noscript"]),
      },
    ),
    "<div><noscript>&lt;/noscript&gt;</noscript></div>",
  )
}

///|
test "fallback element unsafe serialized attribute" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div><noscript><p title=\"</noscript>\">x</p></noscript></div>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["noscript"]),
      },
    ),
    "<div></div>",
  )
}

///|
test "allowed harmless comments" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<div><!--ok--><!--<img src=x onerror=x>--></div>",
      config={
        ..@dom_sanitizer.Config::default(),
        add_tags: Some(["#comment"]),
      },
    ),
    "<div><!--ok--></div>",
  )
}

///|
test "supplementary data attribute names" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<p data-😀=\"x\">ok</p>",
      config=@dom_sanitizer.Config::default(),
    ),
    "<p data-😀=\"x\">ok</p>",
  )
}

///|
test "URI regexp only folds ASCII" {
  assert_eq(
    @dom_sanitizer.sanitize(
      "<a href=\"K:x\">a</a><a href=\"Kscript:x\">b</a><a href=\"JAVASCRIPT:x\">c</a>",
      config={
        ..@dom_sanitizer.Config::default(),
        allow_unknown_protocols: true,
      },
    ),
    "<a href=\"K:x\">a</a><a href=\"Kscript:x\">b</a><a>c</a>",
  )
}
