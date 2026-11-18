# moonbit-community/dom_sanitizer

A pure MoonBit library for sanitizing HTML, including embedded SVG and MathML.
It uses `moonbit-community/html@0.2.4` to parse HTML5 and runs on `wasm-gc`,
`wasm`, `js`, and `native`.

You can build the library and run `moon test` without npm packages, a browser,
a DOM implementation, or JavaScript FFI. The parser runs with scripting
disabled. The sanitizer and serializer traverse a private tree using explicit
stacks.

## Examples

```mbt check
///|
test {
  let safe = @dom_sanitizer.sanitize(
    "<p onclick=\"alert(1)\">hi<script>alert(1)</script></p>",
  )
  inspect(safe, content="<p>hi</p>")
}
```

```mbt check
///|
test {
  let config = { ..@dom_sanitizer.Config::default(), safe_for_templates: true, }
  let safe = @dom_sanitizer.sanitize("<p>{{ user }}</p>", config~)
  inspect(safe, content="<p> </p>")
}
```

## Configuration

`Config`, `UseProfilesConfig`, and `CustomElementHandling` implement `Default`.
Use `Config::default()` for the original policy and defaults. Options cover tag
and attribute lists, profiles, custom elements, URI handling, content retention,
template expressions, and DOM names.

The sanitizer returns the cleaned body contents by default. Set `whole_document`
to return the document element. `force_body` keeps elements the parser would
otherwise put in the head.

The library exports namespace and media-type constants `NAMESPACE_HTML`,
`NAMESPACE_SVG`, `NAMESPACE_MATHML`, `PARSER_MEDIA_TYPE_HTML`, and
`PARSER_MEDIA_TYPE_XHTML`. The sanitizer aborts on XHTML or any media type other
than `text/html`, on a non-HTML root namespace, or when `allowed_uri_check` is
set. `safe_for_xml` controls sanitization. The parser still uses HTML5 rules.

## Sanitization policy

The library uses a port of the DOMPurify 3.3.3 policy. See
[THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES).

The sanitizer preserves styles. Adding tags or attributes through lists or
callbacks expands the set of trusted markup. Profiles replace the base allow
lists. A match in either the list or the callback adds the tag or attribute.
Attribute forbids take precedence. The legacy tag predicate can override a tag
forbid, and custom-element handlers can allow otherwise unknown names.

Each call rebuilds the policy and traversal state. Reserved DOM and form names
come from a fixed jsdom 29.0.1 snapshot. `sanitize_named_props` prefixes every
`id` and `name`.

## Compatibility

The suite keeps all assertions from the original 218 tests and adds tests for
configuration, parsing, state isolation, and security. It covers two known
differences.

- For `<table>before<tr><td><b>x</table>after`, the parser puts `before` ahead of
  the table, matching Chromium 141 and DOMPurify running in Chromium. In jsdom
  29.0.1 it appears after the table. Both outputs passed the check for dangerous
  nodes after reparsing. The exception is recorded in
  `scripts/cases.mjs`.
- HTML/MathML integration-point overrides apply to one call. Options omitted
  from the next call use their defaults.

The suite checks repeated sanitization on stable samples. Options such as
`sanitize_named_props` transform names on every call, so sanitizing the output
again can change it.

## Tests

Run the suite across all four backends.

```sh
moon check --target all --deny-warn
moon test --target all
moon info && moon fmt
```

The optional reference suite uses DOMPurify 3.3.3 and jsdom 29.0.1. The browser
suite uses a pinned Playwright version and adds 128 mutation cases. It blocks
all resource requests, inspects template contents, and reparses each output
three times in a live Chromium document. CI runs the browser suite in a separate
job.

```sh
npm ci
npm run test:reference
npx playwright install chromium
npm run test:browser
```

## Development scripts

The reference suite writes its fixtures to a temporary project outside the
working tree. To regenerate the policy data and the fixed DOM-name snapshot, run
`node scripts/generate-policy.mjs`. To record configuration fixtures, run
`node scripts/reference.mjs --record`. When upgrading the reference tools, review
changes to the policy and expected results before adopting the new versions.
