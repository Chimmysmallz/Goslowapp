// check_story.js — finds broken links in the story BEFORE you publish.
// Usage (from the go-slow-source-kit folder):   node tools/check_story.js
// It reads web/index.html, finds the SCRIPT list, and checks that:
//   - every jump / choice / check points to a label that exists
//   - no label name is used twice
//   - every character and background used actually exists
//   - every flag the story checks is set somewhere
// "0 errors" means it is safe to publish. Warnings are worth a look but will not crash the game.
const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, '..', 'web', 'index.html');
const html = fs.readFileSync(file, 'utf8');

function grab(startToken, endToken) {
  const i = html.indexOf(startToken);
  if (i < 0) throw new Error('Could not find "' + startToken + '" in web/index.html');
  const j = html.indexOf(endToken, i);
  let seg = html.slice(i + startToken.length, j).trim();
  if (seg.endsWith(';')) seg = seg.slice(0, -1);
  return seg;
}

let SCRIPT;
try {
  SCRIPT = Function('"use strict"; return (' + grab('var SCRIPT=', 'var LAB=') + ');')();
} catch (e) {
  console.log('\n❌ The story list has a typing mistake (a missing comma, quote or bracket).');
  console.log('   Details: ' + e.message);
  console.log('   Tip: look at the line you edited last. Every {…} needs a comma after it, and text with an apostrophe must use "double quotes".\n');
  process.exit(1);
}

// character ids and background ids (read from the code, so new ones are picked up automatically)
const chIds = new Set();
const chBlock = html.slice(html.indexOf('var CH='), html.indexOf('var CH=') + 6000);
(chBlock.slice(0, chBlock.indexOf('};')).match(/(\w+)\s*:\s*\{\s*(img|emoji)\s*:/g) || []).forEach(m => chIds.add(m.split(':')[0].trim()));
const bgIds = new Set();
const bgStart = html.indexOf('var BG=');
const bgBlock = html.slice(bgStart, html.indexOf('}', bgStart));
(bgBlock.match(/(\w+)\s*:\s*'/g) || []).forEach(m => bgIds.add(m.split(':')[0].trim()));

const errors = [], warnings = [];
const labels = {}, targeted = new Set(), flagsSet = new Set(), flagsChecked = new Set();
const BUILTIN_FLAGS = ['standing','bond','clues','money','romance','evidence'];
BUILTIN_FLAGS.forEach(f => flagsSet.add(f));

SCRIPT.forEach((s, i) => {
  if ('label' in s) { if (labels[s.label] !== undefined) errors.push(`Label "${s.label}" is used twice (steps ${labels[s.label]} and ${i}).`); labels[s.label] = i; }
});
function needLabel(name, i, what) {
  targeted.add(name);
  if (labels[name] === undefined) errors.push(`Step ${i}: ${what} goes to "${name}", but no {label:'${name}'} exists.`);
}
function noteSets(o) { if (o) Object.keys(o).forEach(k => flagsSet.add(k)); }

SCRIPT.forEach((s, i) => {
  if ('jump' in s) needLabel(s.jump, i, 'jump');
  if ('check' in s) { flagsChecked.add(s.check); needLabel(s.yes, i, 'check (yes)'); needLabel(s.no, i, 'check (no)'); }
  if ('set' in s) noteSets(s.set);
  if ('choice' in s) {
    if (!Array.isArray(s.options) || !s.options.length) errors.push(`Step ${i}: choice "${s.choice}" has no options.`);
    else s.options.forEach((o, n) => { if (!o.t) errors.push(`Step ${i}: option ${n + 1} has no text (t).`); needLabel(o.to, i, `choice option "${o.t}"`); noteSets(o.set); });
  }
  ['say', 'enter', 'move', 'exit'].forEach(k => { if (k in s && chIds.size && !chIds.has(s[k])) errors.push(`Step ${i}: ${k} uses character "${s[k]}", which is not in the CH list.`); });
  if ('say' in s && !s.text) errors.push(`Step ${i}: say has no text.`);
  if ('bg' in s && bgIds.size && !bgIds.has(s.bg)) errors.push(`Step ${i}: background "${s.bg}" is not in the BG list.`);
  if ('enter' in s && !['left', 'center', 'right', 'l', 'c', 'r'].includes(s.slot) && s.slot !== undefined) warnings.push(`Step ${i}: unusual slot "${s.slot}".`);
});

flagsChecked.forEach(f => { if (!flagsSet.has(f)) warnings.push(`The story checks flag "${f}" but never sets it, so that check is always "no".`); });
Object.keys(labels).forEach(l => {
  const i = labels[l];
  const prev = SCRIPT[i - 1];
  const fallsInto = prev && !('jump' in prev) && !('choice' in prev) && !('check' in prev) && !('finale' in prev);
  if (!targeted.has(l) && !fallsInto) warnings.push(`Label "${l}" is never reached (nothing jumps to it).`);
});
if (!SCRIPT.some(s => 'finale' in s)) errors.push('There is no {finale:1} step, so the game can never end.');

const counts = {};
SCRIPT.forEach(s => { const k = Object.keys(s)[0]; counts[k] = (counts[k] || 0) + 1; });
console.log(`\nGo-Slow story check — ${SCRIPT.length} steps, ${Object.keys(labels).length} labels, ${counts.choice || 0} choices, ${counts.say || 0} spoken lines`);
console.log(`Characters found: ${[...chIds].join(', ')}`);
console.log(`Backgrounds found: ${[...bgIds].join(', ')}`);
warnings.forEach(w => console.log('⚠️  ' + w));
errors.forEach(e => console.log('❌ ' + e));
console.log(errors.length ? `\n${errors.length} error(s). Fix these before publishing.\n` : `\n✅ 0 errors — safe to publish.${warnings.length ? ' (' + warnings.length + ' warning(s) above are optional to fix.)' : ''}\n`);
process.exit(errors.length ? 1 : 0);
