///|
priv enum CleanNode {
  Element(String, @html.Namespace, Array[(String, String)], Array[Int32])
  Text(String)
  Comment(String)
}

///|
priv struct CleanTree {
  nodes : Array[CleanNode]
  roots : Array[Int32]
}

///|
fn CleanTree::append(
  self : CleanTree,
  parent : Int32,
  node : CleanNode,
) -> Int32 {
  let id = self.nodes.length()
  self.nodes.push(node)
  if parent < 0 {
    self.roots.push(id)
  } else if self.nodes[parent] is Element(_, _, _, children) {
    children.push(id)
  }
  id
}

///|
priv struct Visit {
  source : Int32
  parent : Int32
  parent_tag : String
  parent_ns : @html.Namespace
}

///|
fn push_children(
  stack : Array[Visit],
  children : Array[Int32],
  parent : Int32,
  parent_tag : String,
  parent_ns : @html.Namespace,
) -> Unit {
  for i = children.length() - 1; i >= 0; i = i - 1 {
    stack.push({ source: children[i], parent, parent_tag, parent_ns, })
  }
}

///|
fn is_raw_text(tag : String, ns : @html.Namespace) -> Bool {
  ns == HTML &&
  tag
  is ("style"
  | "script"
  | "xmp"
  | "iframe"
  | "noembed"
  | "noframes"
  | "plaintext")
}

///|
fn is_void_html(tag : String, ns : @html.Namespace) -> Bool {
  ns == HTML &&
  tag
  is ("area"
  | "base"
  | "basefont"
  | "bgsound"
  | "link"
  | "meta"
  | "br"
  | "col"
  | "embed"
  | "hr"
  | "img"
  | "input"
  | "keygen"
  | "param"
  | "source"
  | "track"
  | "wbr")
}
