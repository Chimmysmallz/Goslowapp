// export_godot.js — copies the story from the web game into the Godot project,
// so both versions always tell the same story.
// Usage:   node tools/export_godot.js
// It rewrites only the SCRIPT part of godot/story.gd. Characters, backgrounds and
// clues at the top of story.gd are left as they are (edit those by hand if you add new ones).
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const html = fs.readFileSync(path.join(root, 'web', 'index.html'), 'utf8');
const i = html.indexOf('var SCRIPT=');
const j = html.indexOf('var LAB=', i);
let seg = html.slice(i + 'var SCRIPT='.length, j).trim();
if (seg.endsWith(';')) seg = seg.slice(0, -1);
const SCRIPT = Function('"use strict"; return (' + seg + ');')();

const storyPath = path.join(root, 'godot', 'story.gd');
const story = fs.readFileSync(storyPath, 'utf8');
const k = story.indexOf('const SCRIPT := [');
if (k < 0) throw new Error('Could not find "const SCRIPT := [" in godot/story.gd');
const head = story.slice(0, k);
const body = 'const SCRIPT := [\n' + SCRIPT.map(x => '    ' + JSON.stringify(x)).join(',\n') + '\n]\n';
fs.writeFileSync(storyPath, head + body);
console.log(`✅ Copied ${SCRIPT.length} story steps into godot/story.gd`);
