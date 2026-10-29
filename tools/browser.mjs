import { chromium } from 'playwright';

export function mutationCases() {
  const contexts = [
    ['', ''], ['<div>', '</div>'], ['<table>', '</table>'],
    ['<table><tr><td>', '</td></tr></table>'], ['<svg>', '</svg>'],
    ['<svg><desc>', '</desc></svg>'], ['<math><mtext>', '</mtext></math>'],
    ['<div><template>', '</template></div>'],
  ];
  const payloads = [
    '<img src=x onerror=alert(1)>', '<a href="jav&#x09;ascript:alert(1)">x</a>',
    '<svg><g onload=alert(1)><a xlink:href="javascript:alert(1)">x</a></g></svg>',
    '<math><mtext><table><mglyph><style><!--</style><img title="--><img src=1 onerror=alert(1)>">',
    '<svg></p><style><a id="</style><img src=1 onerror=alert(1)>">',
    '<noscript><p title="</noscript><img src=x onerror=alert(1)>">',
    '<textarea>&lt;/textarea&gt;&lt;img src=x onerror=alert(1)&gt;</textarea>',
    '<style><img src=x onerror=alert(1)></style>',
    '<template><svg><script>alert(1)</script></svg><img onerror=alert(1)></template>',
    '<svg><foreignObject><math><mi><img src=x onerror=alert(1)></mi></math></foreignObject></svg>',
    '<math><annotation-xml encoding="text/html"><svg><style><!--</style><img onerror=alert(1)></svg></annotation-xml></math>',
    '<svg><style>&lt;img src=x onerror=alert(1)&gt;</style></svg>',
    '<a href="java&#x200b;script:alert(1)">x</a><img src="data:image/png;base64,eA==">',
    '<!--><img src=x onerror=alert(1)>--><p title="--!><img src=x onerror=alert(1)>">x</p>',
    '<select><option><style></select><img src=x onerror=alert(1)>',
    '<svg><a><animate attributeName="href" values="javascript:alert(1)"/></a></svg>',
  ];
  return contexts.flatMap(([open,close],i) => payloads.map((payload,j) => ({
    name:`browser mutation ${i}/${j}`, input:open + payload + close, config:{}, property_test:true,
  })));
}

export async function verifyBrowser(cases) {
  const browser = await chromium.launch({headless:true});
  try {
    const page = await browser.newPage();
    // All fixtures are untrusted. Block resources, even after insertion into a
    // live document. No cookies, user pages or external services are involved.
    await page.route('**/*', route => route.abort());
    await page.addScriptTag({path:'node_modules/dompurify/dist/purify.min.js'});
    const failures = await page.evaluate(cases => {
      const failures = [];
      const unsafeTags = new Set(['script','iframe','object','embed','base','link','meta','frameset','frame']);
      const uriAttrs = new Set(['href','xlink:href','src','action','formaction','background','poster']);
      const inspect = (root, name) => {
        const stack = [root];
        while (stack.length) {
          const node = stack.pop();
          if (node.nodeType === 1) {
            if (unsafeTags.has(node.localName.toLowerCase())) failures.push(`${name}: forbidden ${node.localName}`);
            for (const attr of node.attributes) {
              const lower = attr.name.toLowerCase();
              const value = attr.value.replace(/[\u0000-\u0020\u00a0\u1680\u180e\u2000-\u2029\u205f\u3000]/g,'');
              if (/^on/i.test(lower) || lower === 'srcdoc') failures.push(`${name}: active attribute ${attr.name}`);
              if (uriAttrs.has(lower) && /^(?:javascript|vbscript):/i.test(value)) failures.push(`${name}: active URI ${attr.value}`);
              if (lower === 'attributename' && /href/i.test(value)) failures.push(`${name}: animated href`);
            }
            if (node.localName === 'template' && node.content) stack.push(node.content);
          }
          stack.push(...node.childNodes);
        }
      };
      window.alert = () => failures.push('An alert executed during browser insertion');
      for (const c of cases) {
        // Independently confirm the only accepted oracle difference.
        if (c.expected_moon) {
          if (window.DOMPurify.sanitize(c.input) !== c.actual) failures.push(`${c.name}: browser oracle disagreement`);
          inspect(new DOMParser().parseFromString(c.reference,'text/html'), `${c.name} jsdom alternative`);
        }
        inspect(new DOMParser().parseFromString(c.actual,'text/html'), c.name);
        let serialized = c.actual;
        for (let round=0; round<3; round++) {
          const container = document.createElement('div');
          container.innerHTML = serialized;
          document.body.replaceChildren(container);
          inspect(container, `${c.name} round ${round}`);
          serialized = container.innerHTML;
        }
      }
      document.body.replaceChildren();
      return failures;
    }, cases);
    if (failures.length) throw new Error(JSON.stringify(failures, null, 2));
    console.log(`Chromium ${browser.version()}: ${cases.length} outputs passed document parsing, template inspection and three live fragment reparses.`);
  } finally { await browser.close(); }
}
