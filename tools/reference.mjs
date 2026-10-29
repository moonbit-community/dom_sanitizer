import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { JSDOM } from 'jsdom';
import createDOMPurify from 'dompurify';
import { cases } from './cases.mjs';

const window = new JSDOM('').window;
const purifier = createDOMPurify(window);
if (purifier.version !== '3.3.3' || JSON.parse(fs.readFileSync('node_modules/jsdom/package.json')).version !== '29.0.1') {
  throw new Error('Reference requires DOMPurify 3.3.3 and jsdom 29.0.1');
}
const callbacks = {
  custom_tag: { js: tag => tag === 'x-box', moon: 'fn(tag) { tag == "x-box" }' },
  all_tags: { js: _tag => true, moon: 'fn(_tag) { true }' },
  custom_attr: { js: (attr, tag) => attr === 'custom' && (tag === 'p' || tag === 'x-box'), moon: 'fn(attr, tag) { attr == "custom" && (tag == "p" || tag == "x-box") }' },
};
const optional = new Set(['allowed_tags', 'allowed_attr', 'allowed_namespaces', 'add_tags', 'add_attr', 'add_data_uri_tags', 'add_uri_safe_attr', 'forbid_tags', 'forbid_attr', 'forbid_contents', 'add_forbid_contents', 'html_integration_points', 'mathml_text_integration_points']);
const q = s => JSON.stringify(s).replace(/\\u([\da-fA-F]{4})/g, '\\u{$1}');
const decode = s => JSON.parse(s.replace(/\\u\{([\da-fA-F]+)\}/g, (_, n) => JSON.stringify(String.fromCodePoint(parseInt(n,16))).slice(1,-1)).replace(/[\u0000-\u001f]/g, c => JSON.stringify(c).slice(1,-1)));
function moonConfig(config) {
  const fields = Object.entries(config).map(([key, value]) => {
    if (optional.has(key)) return `${key}: Some([${value.map(q).join(', ')}])`;
    if (key.endsWith('_check')) return `${key}: Some(${callbacks[value].moon})`;
    if (key === 'use_profiles' || key === 'custom_element_handling') {
      const type = key === 'use_profiles' ? 'UseProfilesConfig' : 'CustomElementHandling';
      const spread = Object.keys(value).length === (key === 'use_profiles' ? 4 : 3) ? '' : `..@dom_sanitizer.${type}::default(), `;
      return `${key}: Some({ ${spread}${Object.entries(value).map(([k,v]) => k.endsWith('_check') ? `${k}: Some(${callbacks[v].moon})` : `${k}: ${v}`).join(', ')} })`;
    }
    return `${key}: ${JSON.stringify(value)}`;
  });
  return fields.length ? `{ ..@dom_sanitizer.Config::default(), ${fields.join(', ')} }` : '@dom_sanitizer.Config::default()';
}
function jsConfig(config) {
  const result = {};
  for (const [key, value] of Object.entries(config)) {
    if (key === 'add_tag_check' || key === 'add_attr_check') continue;
    if (key === 'use_profiles') result.USE_PROFILES = Object.fromEntries(Object.entries(value).map(([k,v]) => [({svg_filters:'svgFilters',math_ml:'mathMl'})[k] || k,v]));
    else if (key === 'custom_element_handling') result.CUSTOM_ELEMENT_HANDLING = Object.fromEntries(Object.entries(value).map(([k,v]) => [({tag_name_check:'tagNameCheck',attribute_name_check:'attributeNameCheck',allow_customized_built_in_elements:'allowCustomizedBuiltInElements'})[k], k.endsWith('_check') ? callbacks[v].js : v]));
    else if (key.endsWith('_integration_points')) result[key.toUpperCase()] = Object.fromEntries(value.map(v => [v.toLowerCase(),true]));
    else result[key.toUpperCase()] = value;
  }
  for (const [check, list, key] of [['add_tag_check','add_tags','ADD_TAGS'], ['add_attr_check','add_attr','ADD_ATTR']]) {
    if (config[check]) result[key] = (name, tag) => (config[list] || []).some(v => v.toLowerCase() === name.toLowerCase()) || callbacks[config[check]].js(name, tag);
  }
  return result;
}

if (process.argv.includes('--record')) {
  const source = '// Recorded against DOMPurify 3.3.3 / jsdom 29.0.1 before the pure MoonBit migration.\n// Inputs, configuration mappings and documented exceptions: tools/cases.mjs.\n\n' + cases.map(c => `///|\ntest ${q(c.name)} {\n${c.difference ? `  // ${c.difference}\n` : ''}  assert_eq(@dom_sanitizer.sanitize(${q(c.input)}, config=${moonConfig(c.config)}), ${q(c.expected_moon ?? createDOMPurify(window).sanitize(c.input, jsConfig(c.config)))})\n}\n`).join('\n');
  fs.writeFileSync('configuration_test.mbt', source);
  console.log(`Recorded ${cases.length} configuration cases.`);
} else {
  // Include every original attack fixture without rewriting its assertions.
  const original = fs.readFileSync('dom_sanitizer_test.mbt', 'utf8');
  for (const match of original.matchAll(/test(?: ("(?:[^"\\]|\\.)*"))? \{\s*let payload = ("(?:[^"\\]|\\.)*")/g)) {
    cases.push({ name: match[1] ? decode(match[1]) : `original fixture at offset ${match.index}`, input: decode(match[2]), config: {} });
  }
  if (process.argv.includes('--browser')) {
    const { mutationCases } = await import('./browser.mjs');
    cases.push(...mutationCases());
  }
  // Generate in an isolated copy so concurrent builds, interrupted runs and
  // editor test discovery never see transient fixtures in the working tree.
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'dom-sanitizer-reference-'));
  const fixture = 'reference_output_test.mbt';
  let output;
  try {
    for (const name of fs.readdirSync('.')) {
      if ((name.endsWith('.mbt') && !name.endsWith('_test.mbt') && !name.endsWith('_wbtest.mbt')) || name === 'moon.mod' || name === 'moon.pkg') fs.copyFileSync(name, path.join(directory, name));
    }
    fs.cpSync('.mooncakes', path.join(directory,'.mooncakes'), {recursive:true});
    fs.writeFileSync(path.join(directory,fixture), cases.map((c,i) => `///|\ntest ${q('reference ' + i)} {\n  println("REFERENCE:${i}:" + @dom_sanitizer.sanitize(${q(c.input)}, config=${moonConfig(c.config)}).escape())\n}\n`).join('\n'));
    const run = spawnSync('moon', ['test', '--target', 'js', fixture], {cwd:directory, encoding:'utf8', maxBuffer: 16 * 1024 * 1024});
    if (run.status !== 0) throw new Error(run.stdout + run.stderr);
    output = run.stdout;
  } finally { fs.rmSync(directory, {recursive:true, force:true}); }
  let count = 0;
  const differences = [];
  const accepted = [];
  const results = [];
  for (const match of output.matchAll(/^REFERENCE:(\d+):(.*)$/gm)) {
    const c = cases[Number(match[1])];
    const actual = decode(match[2]);
    const expected = createDOMPurify(window).sanitize(c.input, jsConfig(c.config));
    results.push({...c, actual, reference:expected});
    if (!c.property_test && actual !== expected) {
      if (c.expected_moon === actual) accepted.push({name:c.name, reason:c.difference, actual, expected});
      else differences.push({name:c.name, input:c.input, actual, expected});
    }
    count++;
  }
  if (count !== cases.length) throw new Error(`Missing outputs: ${count}/${cases.length}`);
  console.log(JSON.stringify({cases:count, accepted, differences}, null, 2));
  if (differences.length) process.exitCode = 1;
  if (process.argv.includes('--browser')) {
    const { verifyBrowser } = await import('./browser.mjs');
    await verifyBrowser(results);
  }
}
window.close();
