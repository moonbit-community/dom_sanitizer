///|
/// HTML namespace constant used by `Config::namespace_uri`.
pub const NAMESPACE_HTML = "http://www.w3.org/1999/xhtml"

///|
/// SVG namespace constant. Embedded SVG is supported within an HTML root.
pub const NAMESPACE_SVG = "http://www.w3.org/2000/svg"

///|
/// MathML namespace constant. Embedded MathML is supported within an HTML root.
pub const NAMESPACE_MATHML = "http://www.w3.org/1998/Math/MathML"

///|
/// Default HTML parser media type.
pub const PARSER_MEDIA_TYPE_HTML = "text/html"

///|
/// XHTML parser media type.
pub const PARSER_MEDIA_TYPE_XHTML = "application/xhtml+xml"

///|
/// Sanitize a dirty HTML string and return a safe HTML string.
///
/// Parses HTML with scripting disabled and sanitizes HTML, SVG and MathML.
/// XHTML, non-HTML root namespaces and `allowed_uri_check` are unsupported
/// and abort explicitly. The implementation is shared by all four backends.
pub fn sanitize(input : String, config~ : Config = Config::default()) -> String {
  sanitize_html(input, config)
}
