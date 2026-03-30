# moonbit-community/dom_sanitizer

A JS-target HTML sanitizer that delegates to DOMPurify.

When the JS runtime does not provide a DOM-capable `window`, the package falls
back to `jsdom`.

```moonbit check
///|
test {
  let safe = @dom_sanitizer.sanitize(
    "<p onclick=\"alert(1)\">hi<script>alert(1)</script></p>",
  )
  inspect(safe, content="<p>hi</p>")
}
```

```moonbit check
///|
test {
  let config = { ..@dom_sanitizer.Config::default(), safe_for_templates: true }
  let safe = @dom_sanitizer.sanitize("<p>{{ user }}</p>", config~)
  inspect(safe, content="<p> </p>")
}
```
