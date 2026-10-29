# moonbit-community/dom_sanitizer

A pure MoonBit HTML sanitizer using `moonbit-community/html@0.2.2` for HTML5
document parsing. It supports HTML with embedded SVG and MathML on `wasm-gc`,
`wasm`, `js`, and `native`. The default target is `wasm-gc`.

Library builds and `moon test` need no npm packages, browser, DOM implementation,
or JavaScript FFI. Parsing runs with scripting disabled; sanitization and
serialization use private trees and explicit traversal stacks.

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

`Config::default()` retains the original policy and defaults. Options cover tag
and attribute lists, profiles, custom elements, URI handling, content retention,
template expressions, and DOM names. Default output contains the cleaned body
contents; `whole_document` returns the document element. `force_body` preserves
elements that the parser would otherwise place in the head.

The public `sanitize`, `Config`, related structs, and namespace/media-type
constants are unchanged. This release explicitly aborts for XHTML (or any media
type other than `text/html`), non-HTML root namespaces, and `allowed_uri_check`.
SVG and MathML remain supported *inside* an HTML document. `safe_for_xml` is a
sanitization option, not an XML parser switch.

The policy is ported from DOMPurify 3.3.3; see [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES).
As in that policy, styles are retained, and explicit extra tags, attributes, and
callbacks extend what is trusted. Profiles replace the base allow lists; list
and callback additions combine with OR. Attribute forbids always win. The
legacy tag predicate can override a tag forbid, and custom-element handlers
explicitly allow otherwise unknown names. Policy and traversal state are rebuilt
for each call. DOM/form reserved names come from a fixed jsdom 29.0.1
snapshot; `sanitize_named_props` additionally prefixes every `id` and `name`.

Compatibility is checked against the original 218 tests without changing their
assertions, plus configuration, parser, state-isolation, and security tests.
There are two documented differences:

- For `<table>before<tr><td><b>x</table>after`, the parser keeps `before` ahead of
  the table. jsdom 29.0.1 moves it after the table. Chromium 141 and DOMPurify
  running in Chromium agree with this implementation. Both outputs were checked
  for dangerous nodes after reparsing; the exact exception is recorded in
  `tools/cases.mjs`.
- HTML/MathML integration-point overrides no longer leak into later calls.
  An omitted option restores its default on each call.

Repeated sanitization is checked on stable samples. Options such as
`sanitize_named_props` intentionally transform names on every call, so universal
idempotence is not promised.

To run the portable suite:

```sh
moon check --target all --deny-warn
moon test --target all
moon info && moon fmt
```

The optional development oracle pins DOMPurify 3.3.3 and jsdom 29.0.1. The browser
suite also uses pinned Playwright, inspects template contents, and reparses
outputs in a live Chromium document three times. It includes 128 additional
mutation cases and blocks all resource requests. These tools run in a separate
CI job; the four backend jobs do not install npm dependencies.

```sh
npm ci
npm run test:reference
npx playwright install chromium
npm run test:browser
```

Reference fixtures are generated in a temporary project, leaving the working
tree untouched. The policy data and fixed DOM-name snapshot can be regenerated
with `node tools/generate-policy.mjs`; configuration fixtures can be recorded
with `node tools/reference.mjs --record`. Review any resulting policy or
expectation changes before accepting a new reference version.
