// simulate.js — plays the whole month thousands of times with random choices
// and reports how long a run is, which endings players reach, and any lines nobody ever sees.
// Usage:   node tools/simulate.js            (2,000 runs)
//          node tools/simulate.js 20000      (more runs = more accurate)
const fs = require('fs');
const path = require('path');

const N = parseInt(process.argv[2] || '2000', 10);
const html = fs.readFileSync(path.join(__dirname, '..', 'web', 'index.html'), 'utf8');
let seg = html.slice(html.indexOf('var SCRIPT=') + 11, html.indexOf('var LAB=')).trim().replace(/;$/, '');
const S = Function('"use strict"; return (' + seg + ');')();
const L = {}; S.forEach((s, i) => { if ('label' in s) L[s.label] = i; });
const rf = html.match(/function resetFlags\(\)\{\s*flags=(\{[^}]*\})/);
const base = rf ? Function('return ' + rf[1])() : { money: 40000 };

const res = {}, lines = [], choices = [], words = [], seen = new Set();
for (let r = 0; r < N; r++) {
  const f = { ...base }; let ip = 0, ln = 0, c = 0, w = 0, guard = 0;
  while (ip < S.length && guard++ < 5000) {
    const s = S[ip]; seen.add(ip);
    if ('set' in s) for (const k in s.set) f[k] = (f[k] || 0) + s.set[k];
    if ('jump' in s) { ip = L[s.jump]; continue; }
    if ('check' in s) {
      const v = f[s.check] || 0; let p;
      if ('gte' in s) p = v >= s.gte; else if ('lte' in s) p = v <= s.lte; else if ('gt' in s) p = v > s.gt;
      else if ('lt' in s) p = v < s.lt; else if ('eq' in s) p = v === s.eq; else p = !!v;
      ip = L[p ? s.yes : s.no]; continue;
    }
    if ('choice' in s) { c++; const o = s.options[Math.floor(Math.random() * s.options.length)]; if (o.set) for (const k in o.set) f[k] = (f[k] || 0) + o.set[k]; ip = L[o.to]; continue; }
    if ('say' in s) { ln++; w += s.text.split(/\s+/).length; }
    if ('narrate' in s) { ln++; w += s.narrate.split(/\s+/).length; }
    if ('finale' in s) break;
    ip++;
  }
  const end = ['m_hero', 'm_justice', 'm_join', 'm_complicit', 'm_walk'].find(k => f[k]) || 'crushed';
  const rom = f.deepBond && f.romance >= 2 ? 'deep bond' : ((f.loveAda || f.loveTunde) && f.romance >= 2 ? 'together' : (f.loveAda || f.loveTunde ? 'spark' : 'solo'));
  res['Ending: ' + end] = (res['Ending: ' + end] || 0) + 1;
  res['Romance: ' + rom] = (res['Romance: ' + rom] || 0) + 1;
  lines.push(ln); choices.push(c); words.push(w);
}
const avg = a => Math.round(a.reduce((x, y) => x + y, 0) / a.length);
console.log(`\nGo-Slow playtest — ${N} random runs`);
console.log(`Lines per run:   average ${avg(lines)} (shortest ${Math.min(...lines)}, longest ${Math.max(...lines)})`);
console.log(`Choices per run: average ${avg(choices)}`);
console.log(`Reading time:    about ${Math.round(avg(words) / 200)} minutes of text per run\n`);
Object.keys(res).sort().forEach(k => console.log(`${k.padEnd(28)} ${(100 * res[k] / N).toFixed(1)}%`));
const unseen = [];
S.forEach((s, i) => { if (('say' in s || 'narrate' in s) && !seen.has(i)) unseen.push(i); });
console.log(`\nLines never reached: ${unseen.length}${unseen.length ? ' (steps ' + unseen.join(', ') + ')' : ''}\n`);
