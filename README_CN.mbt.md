# moonbit-community/dom_sanitizer

一个用纯 MoonBit 编写的 HTML 清洗库，也支持清洗 HTML 中嵌入的 SVG 和 MathML。
它使用 `moonbit-community/html@0.2.4` 解析 HTML5 文档，可在 `wasm-gc`、`wasm`、
`js` 和 `native` 四个后端上运行。

构建本库和运行 `moon test` 无需 npm 包、浏览器、DOM 实现或 JavaScript FFI。
解析器在禁用脚本的模式下工作。清洗和序列化通过显式栈遍历库内部的树。

## 用法示例

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

## 配置

`Config`、`UseProfilesConfig` 和 `CustomElementHandling` 都实现了 `Default`。
`Config::default()` 沿用原有的策略和默认值。可配置标签和属性列表、预设配置
（profiles）、自定义元素、URI、内容保留、模板表达式和 DOM 名称。

清洗后默认返回正文内容。启用 `whole_document` 会返回文档根元素。
`force_body` 可以保留解析器原本会放入 head 的元素。

库公开了命名空间和媒体类型常量 `NAMESPACE_HTML`、`NAMESPACE_SVG`、
`NAMESPACE_MATHML`、`PARSER_MEDIA_TYPE_HTML` 和 `PARSER_MEDIA_TYPE_XHTML`。
如果媒体类型是 XHTML 或其他非 `text/html` 类型，根命名空间不是 HTML，或设置了
`allowed_uri_check`，清洗函数会调用 `abort`。`safe_for_xml` 控制清洗行为，
解析仍按 HTML5 规则进行。

## 清洗策略

清洗策略移植自 DOMPurify 3.3.3。见 [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES)。

库会保留样式。通过列表或回调添加标签和属性会扩大信任范围。预设配置会替换基础允许列表。
对于额外添加的标签和属性，列表和回调有一项允许即可。属性禁止规则优先。为兼容原有行为，
标签判定回调可以覆盖标签禁止规则，自定义元素处理器可以允许原本未知的名称。

每次调用都会重新构建清洗策略和遍历状态。DOM 和表单的保留名称来自固定的 jsdom 29.0.1
快照。`sanitize_named_props` 会给每个 `id` 和 `name` 加上前缀。

## 兼容性

测试套件保留了原有 218 个测试的所有断言，并补充了配置、解析、状态隔离和安全测试。
其中覆盖了两项已知差异。

- 对于 `<table>before<tr><td><b>x</table>after`，解析器把 `before` 放在表格前，
  与 Chromium 141 及其中运行的 DOMPurify 一致。jsdom 29.0.1 把它放到表格后。
  两种输出在重新解析后都通过了危险节点检查。该例外记录在 `scripts/cases.mjs` 中。
- HTML/MathML 集成点的自定义配置只对当前调用生效。下次调用省略的选项会使用默认值。

测试套件用稳定样本检查重复清洗的结果。`sanitize_named_props` 等选项每次调用都会
改写名称，因此把输出再清洗一次可能会得到不同的结果。

## 测试

以下命令检查并测试全部四个后端。

```sh
moon check --target all --deny-warn
moon test --target all
moon info && moon fmt
```

可选的对照测试使用 DOMPurify 3.3.3 和 jsdom 29.0.1。浏览器测试使用固定版本的
Playwright，并增加了 128 个输入变异用例。测试会拦截所有资源请求、检查 template
的内容，并在实际运行的 Chromium 文档中将每份输出重新解析三次。CI 在单独的任务中
运行浏览器测试。

```sh
npm ci
npm run test:reference
npx playwright install chromium
npm run test:browser
```

## 开发脚本

对照测试把生成的用例写入工作区之外的临时项目。运行 `node scripts/generate-policy.mjs`
可以重新生成策略数据和固定的 DOM 名称快照。运行 `node scripts/reference.mjs --record` 可以记录
配置测试用例。升级对照工具时，先检查策略和预期结果的变化，再采用新版本。
