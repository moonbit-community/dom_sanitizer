# moonbit-community/dom_sanitizer

一个纯 MoonBit 实现的 HTML 清洗库，使用 `moonbit-community/html@0.2.2`
解析 HTML5 文档。支持包含嵌入式 SVG 和 MathML 的 HTML，可运行于 `wasm-gc`、
`wasm`、`js` 和 `native` 四个后端，默认目标为 `wasm-gc`。

构建本库和运行 `moon test` 均不需要 npm 包、浏览器、DOM 实现或 JavaScript FFI。
解析时禁用脚本，清洗和序列化使用私有树结构及显式遍历栈。

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

`Config`、`UseProfilesConfig` 和 `CustomElementHandling` 均实现 `Default`。
`Config::default()` 保留原有策略和默认值。配置选项涵盖标签及属性列表、预设配置
（profiles）、自定义元素、URI 处理、内容保留、模板表达式和 DOM 名称处理。
默认输出清洗后的正文内容；`whole_document` 返回文档根元素；`force_body`
可保留原本会被解析器放入 head 的元素。

命名空间和媒体类型常量以 `NAMESPACE_HTML`、`NAMESPACE_SVG`、`NAMESPACE_MATHML`、
`PARSER_MEDIA_TYPE_HTML` 和 `PARSER_MEDIA_TYPE_XHTML` 公开。
本版本对 XHTML（以及任何非 `text/html` 媒体类型）、非 HTML 根命名空间和
`allowed_uri_check` 明确调用 `abort` 终止。仍然支持 HTML 文档*内部*的 SVG
和 MathML。`safe_for_xml` 是清洗选项，不是 XML 解析器开关。

清洗策略移植自 DOMPurify 3.3.3，详见 [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES)。
与该策略一致，本库保留样式，显式添加的标签、属性和回调会扩展信任范围。
Profiles 会替换基础允许列表；通过列表和回调添加的规则按逻辑“或”组合。
属性禁止规则始终优先。为兼容原有行为，标签判定回调可以覆盖标签禁止规则，
自定义元素处理器可以显式允许原本未知的名称。每次调用都会重新构建策略和遍历状态。
DOM/form 保留名称来自固定的 jsdom 29.0.1 快照；`sanitize_named_props`
还会为每个 `id` 和 `name` 添加前缀。

兼容性验证保留了原有 218 个测试的全部断言，并增加了配置、解析器、状态隔离和安全测试。
目前记录了两项差异：

- 对于 `<table>before<tr><td><b>x</table>after`，解析器将 `before` 保留在表格前，
  而 jsdom 29.0.1 会将其移到表格后。Chromium 141 及其中运行的 DOMPurify
  与本实现的结果一致。两种输出均已重新解析并检查是否存在危险节点；
  该差异的精确例外记录在 `tools/cases.mjs` 中。
- HTML/MathML 集成点的自定义配置不再泄漏到后续调用。
  每次调用中省略的选项都会恢复为默认值。

已使用稳定样本验证重复清洗的结果。`sanitize_named_props` 等选项会按设计在每次调用时
变换名称，因此不保证所有情况下都具有幂等性。

运行跨后端测试套件：

```sh
moon check --target all --deny-warn
moon test --target all
moon info && moon fmt
```

可选的开发对照工具固定使用 DOMPurify 3.3.3 和 jsdom 29.0.1。浏览器测试套件还使用
固定版本的 Playwright，检查 template 内容，并在真实运行的 Chromium 文档中
对输出重新解析三次。该套件包含额外的 128 个输入变异用例，并阻止所有资源请求。
这些工具在独立的 CI 任务中运行；四个后端的 CI 任务均不安装 npm 依赖。

```sh
npm ci
npm run test:reference
npx playwright install chromium
npm run test:browser
```

对照测试用例在临时项目中生成，不修改工作区。可以运行
`node tools/generate-policy.mjs` 重新生成策略数据和固定的 DOM 名称快照，
运行 `node tools/reference.mjs --record` 记录配置测试用例。
采用新的对照工具版本前，应审查由此产生的策略或预期结果变化。
