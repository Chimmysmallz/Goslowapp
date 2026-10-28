// build_singlefile.js — packs the whole game into ONE html file (art included),
// so you can send it to someone or open it with no internet.
// Usage:   node tools/build_singlefile.js
// Output:  dist/go-slow-offline.html
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const web = path.join(root, 'web');
let html = fs.readFileSync(path.join(web, 'index.html'), 'utf8');

let n = 0;
html = html.replace(/(["'(])art\/([\w.-]+\.(png|jpe?g|webp))/g, (m, q, file, ext) => {
  const p = path.join(web, 'art', file);
  if (!fs.existsSync(p)) { console.log('⚠️  Missing image: art/' + file); return m; }
  const mime = ext === 'png' ? 'image/png' : ext === 'webp' ? 'image/webp' : 'image/jpeg';
  n++;
  return q + 'data:' + mime + ';base64,' + fs.readFileSync(p).toString('base64');
});
// a single offline file cannot use the install/offline features, so switch them off quietly
html = html.replace('<link rel="manifest" href="manifest.json">', '');
html = html.replace("navigator.serviceWorker.register('sw.js')", "Promise.reject()");

fs.mkdirSync(path.join(root, 'dist'), { recursive: true });
const out = path.join(root, 'dist', 'go-slow-offline.html');
fs.writeFileSync(out, html);
console.log(`✅ Built dist/go-slow-offline.html (${Math.round(html.length / 1024)} KB, ${n} images packed in).`);
