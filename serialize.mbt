///|
fn write_escaped(
  builder : StringBuilder,
  value : String,
  attribute~ : Bool,
) -> Unit {
  for c in value {
    match c {
      '&' => builder.write_string("&amp;")
      '\u{a0}' => builder.write_string("&nbsp;")
      '"' if attribute => builder.write_string("&quot;")
      '<' if !attribute => builder.write_string("&lt;")
      '>' if !attribute => builder.write_string("&gt;")
      _ => builder.write_char(c)
    }
  }
}

///|
priv enum SerializeStep {
  Node(Int32, Bool)
  Close(String)
}

///|
fn CleanTree::serialize(self : CleanTree) -> String {
  let builder = StringBuilder()
  let stack : Array[SerializeStep] = []
  for i = self.roots.length() - 1; i >= 0; i = i - 1 {
    stack.push(Node(self.roots[i], false))
  }
  while stack.pop() is Some(step) {
    match step {
      Close(tag) =>
        builder..write_string("</")..write_string(tag).write_string(">")
      Node(id, raw) =>
        match self.nodes[id] {
          Text(value) =>
            if raw {
              builder.write_string(value)
            } else {
              write_escaped(builder, value, attribute=false)
            }
          Comment(value) =>
            builder
            ..write_string("<!--")
            ..write_string(value)
            .write_string("-->")
          Element(tag, ns, attributes, children) => {
            builder..write_string("<").write_string(tag)
            for (name, value) in attributes {
              builder..write_string(" ")..write_string(name).write_string("=\"")
              write_escaped(builder, value, attribute=true)
              builder.write_string("\"")
            }
            builder.write_string(">")
            if !is_void_html(tag, ns) {
              stack.push(Close(tag))
              let raw = is_raw_text(tag, ns)
              for i = children.length() - 1; i >= 0; i = i - 1 {
                stack.push(Node(children[i], raw))
              }
            }
          }
        }
    }
  }
  builder.to_string()
}
