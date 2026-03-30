///|
#cfg(target="js")
#external
priv type JsValue

///|
#cfg(target="js")
fn[T] to_js_value(value : T) -> JsValue = "%identity"

///|
#cfg(target="js")
extern "js" fn js_object_new() -> JsValue = "() => ({})"

///|
#cfg(target="js")
extern "js" fn js_object_set(
  object : JsValue,
  key : String,
  value : JsValue,
) -> Unit = "(object, key, value) => { object[key] = value; }"

///|
#cfg(target="js")
extern "js" fn js_undefined() -> JsValue = "() => undefined"

///|
#cfg(target="js")
extern "js" fn js_lowercase_true_map(values : JsValue) -> JsValue =
  #| (values) => {
  #|   const object = {};
  #|   for (const value of values || []) {
  #|     if (value != null) object[String(value).toLowerCase()] = true;
  #|   }
  #|   return object;
  #| }

///|
#cfg(target="js")
extern "js" fn js_merge_add_tags(values : JsValue, check : JsValue) -> JsValue =
  #| (values, check) => {
  #|   const hasValues = Array.isArray(values);
  #|   const hasCheck = typeof check === 'function';
  #|   if (hasValues && hasCheck) {
  #|     const set = new Set(
  #|       values
  #|         .filter((value) => value != null)
  #|         .map((value) => String(value).toLowerCase()),
  #|     );
  #|     return (tagName) => set.has(String(tagName).toLowerCase()) || !!check(tagName);
  #|   }
  #|   if (hasCheck) return check;
  #|   return values;
  #| }

///|
#cfg(target="js")
extern "js" fn js_merge_add_attr(values : JsValue, check : JsValue) -> JsValue =
  #| (values, check) => {
  #|   const hasValues = Array.isArray(values);
  #|   const hasCheck = typeof check === 'function';
  #|   if (hasValues && hasCheck) {
  #|     const set = new Set(
  #|       values
  #|         .filter((value) => value != null)
  #|         .map((value) => String(value).toLowerCase()),
  #|     );
  #|     return (attributeName, tagName) =>
  #|       set.has(String(attributeName).toLowerCase()) || !!check(attributeName, tagName);
  #|   }
  #|   if (hasCheck) return check;
  #|   return values;
  #| }

///|
#cfg(target="js")
fn[T] has_value(value : T?) -> Bool {
  match value {
    Some(_) => true
    None => false
  }
}

///|
#cfg(target="js")
fn[T] optional_to_js_value(value : T?) -> JsValue {
  match value {
    Some(value) => to_js_value(value)
    None => js_undefined()
  }
}

///|
#cfg(target="js")
fn[T] set_optional_value(object : JsValue, key : String, value : T?) -> Unit {
  match value {
    Some(value) => js_object_set(object, key, to_js_value(value))
    None => ()
  }
}

///|
#cfg(target="js")
fn set_optional_lowercase_true_map(
  object : JsValue,
  key : String,
  value : Array[String]?,
) -> Unit {
  match value {
    Some(values) =>
      js_object_set(object, key, js_lowercase_true_map(to_js_value(values)))
    None => ()
  }
}

///|
#cfg(target="js")
fn ensure_dompurify_compatible(config : Config) -> Unit {
  match config.allowed_uri_check {
    Some(_) =>
      abort(
        "Config.allowed_uri_check is not supported when delegating to DOMPurify directly",
      )
    None => ()
  }
}

///|
#cfg(target="js")
fn config_to_js_value(config : Config) -> JsValue {
  ensure_dompurify_compatible(config)

  let object = js_object_new()

  js_object_set(object, "ALLOW_ARIA_ATTR", to_js_value(config.allow_aria_attr))
  js_object_set(object, "ALLOW_DATA_ATTR", to_js_value(config.allow_data_attr))
  js_object_set(
    object,
    "ALLOW_UNKNOWN_PROTOCOLS",
    to_js_value(config.allow_unknown_protocols),
  )
  js_object_set(
    object,
    "ALLOW_SELF_CLOSE_IN_ATTR",
    to_js_value(config.allow_self_close_in_attr),
  )
  js_object_set(object, "FORCE_BODY", to_js_value(config.force_body))
  js_object_set(object, "KEEP_CONTENT", to_js_value(config.keep_content))
  js_object_set(object, "NAMESPACE", to_js_value(config.namespace_uri))
  js_object_set(
    object,
    "PARSER_MEDIA_TYPE",
    to_js_value(config.parser_media_type),
  )
  js_object_set(
    object,
    "SAFE_FOR_TEMPLATES",
    to_js_value(config.safe_for_templates),
  )
  js_object_set(object, "SAFE_FOR_XML", to_js_value(config.safe_for_xml))
  js_object_set(object, "SANITIZE_DOM", to_js_value(config.sanitize_dom))
  js_object_set(
    object,
    "SANITIZE_NAMED_PROPS",
    to_js_value(config.sanitize_named_props),
  )
  js_object_set(object, "WHOLE_DOCUMENT", to_js_value(config.whole_document))

  set_optional_value(object, "ALLOWED_TAGS", config.allowed_tags)
  set_optional_value(object, "ALLOWED_ATTR", config.allowed_attr)
  set_optional_value(object, "ALLOWED_NAMESPACES", config.allowed_namespaces)
  set_optional_value(object, "ADD_DATA_URI_TAGS", config.add_data_uri_tags)
  set_optional_value(object, "ADD_URI_SAFE_ATTR", config.add_uri_safe_attr)
  set_optional_value(object, "FORBID_TAGS", config.forbid_tags)
  set_optional_value(object, "FORBID_ATTR", config.forbid_attr)
  set_optional_value(object, "FORBID_CONTENTS", config.forbid_contents)
  set_optional_value(object, "ADD_FORBID_CONTENTS", config.add_forbid_contents)
  set_optional_lowercase_true_map(
    object,
    "HTML_INTEGRATION_POINTS",
    config.html_integration_points,
  )
  set_optional_lowercase_true_map(
    object,
    "MATHML_TEXT_INTEGRATION_POINTS",
    config.mathml_text_integration_points,
  )

  if has_value(config.add_tags) || has_value(config.add_tag_check) {
    js_object_set(
      object,
      "ADD_TAGS",
      js_merge_add_tags(
        optional_to_js_value(config.add_tags),
        optional_to_js_value(config.add_tag_check),
      ),
    )
  }

  if has_value(config.add_attr) || has_value(config.add_attr_check) {
    js_object_set(
      object,
      "ADD_ATTR",
      js_merge_add_attr(
        optional_to_js_value(config.add_attr),
        optional_to_js_value(config.add_attr_check),
      ),
    )
  }

  match config.use_profiles {
    Some(use_profiles) => {
      let nested = js_object_new()
      js_object_set(nested, "html", to_js_value(use_profiles.html))
      js_object_set(nested, "svg", to_js_value(use_profiles.svg))
      js_object_set(nested, "svgFilters", to_js_value(use_profiles.svg_filters))
      js_object_set(nested, "mathMl", to_js_value(use_profiles.math_ml))
      js_object_set(object, "USE_PROFILES", nested)
    }
    None => ()
  }

  match config.custom_element_handling {
    Some(custom) => {
      let nested = js_object_new()
      set_optional_value(nested, "tagNameCheck", custom.tag_name_check)
      set_optional_value(
        nested,
        "attributeNameCheck",
        custom.attribute_name_check,
      )
      js_object_set(
        nested,
        "allowCustomizedBuiltInElements",
        to_js_value(custom.allow_customized_built_in_elements),
      )
      js_object_set(object, "CUSTOM_ELEMENT_HANDLING", nested)
    }
    None => ()
  }

  object
}

///|
#cfg(target="js")
extern "js" fn sanitize_ffi(input : String, config : JsValue) -> String =
  #| (function () {
  #|   let dompurify = null;
  #| 
  #|   function getHostWindow() {
  #|     if (typeof window !== 'undefined' && window.document) {
  #|       return window;
  #|     }
  #|     const { JSDOM } = require('jsdom');
  #|     return new JSDOM('').window;
  #|   }
  #| 
  #|   function getDOMPurify() {
  #|     if (dompurify && typeof dompurify.sanitize === 'function') {
  #|       return dompurify;
  #|     }
  #|     const root = getHostWindow();
  #|     const imported =
  #|       typeof require === 'function' ? require('dompurify') : root.DOMPurify;
  #|     dompurify =
  #|       typeof imported === 'function' && typeof imported.sanitize !== 'function'
  #|         ? imported(root)
  #|         : imported;
  #|     if (!dompurify || typeof dompurify.sanitize !== 'function') {
  #|       throw new Error(
  #|         'Failed to initialize DOMPurify with an available DOM host window.',
  #|       );
  #|     }
  #|     return dompurify;
  #|   }
  #| 
  #|   return (input, config) => getDOMPurify().sanitize(input, config);
  #| })()

///|
#cfg(target="js")
fn sanitize_js(input : String, config : Config) -> String {
  sanitize_ffi(input, config_to_js_value(config))
}

///|
#cfg(not(target="js"))
fn sanitize_js(_input : String, _config : Config) -> String {
  abort("dom_sanitizer only supports the JS target")
}
