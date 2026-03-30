///|
/// HTML namespace constant used by `Config::namespace`.
pub let namespace_html = "http://www.w3.org/1999/xhtml"

///|
/// SVG namespace constant used by `Config::namespace`.
pub let namespace_svg = "http://www.w3.org/2000/svg"

///|
/// MathML namespace constant used by `Config::namespace`.
pub let namespace_mathml = "http://www.w3.org/1998/Math/MathML"

///|
/// Default HTML parser media type.
pub let parser_media_type_html = "text/html"

///|
/// XHTML parser media type.
pub let parser_media_type_xhtml = "application/xhtml+xml"

///|
/// Sanitize a dirty HTML string and return a safe HTML string.
///
/// This implementation delegates to DOMPurify and is limited to string
/// input/output on the JS target.
pub fn sanitize(input : String, config? : Config = Config::default()) -> String {
  sanitize_js(input, config)
}
