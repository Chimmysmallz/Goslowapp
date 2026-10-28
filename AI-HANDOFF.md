# AI hand-off: paste everything below into any AI assistant

---

I am working on **Go-Slow**, a mobile interactive story game (Episode / Choices style) set in Lagos. The player survives one month at an office job: commute chaos, an HR officer, a corruption mystery that climbs to the company MD, a romance with Ada or Tunde, and a loyal friend, Chidi, who pays a price for helping. Tone: warm, funny, tense when it matters, with natural Nigerian Pidgin in dialogue.

**Tech:** one plain HTML file, `web/index.html`, with vanilla JavaScript and no frameworks or build step. Images are in `web/art/`. It is a PWA (`web/manifest.json`, `web/sw.js`) published to GitHub Pages from the `web/` folder. There is also a Godot 4 port in `godot/` (`main.gd` engine, `story.gd` data).

**How the story is stored:** a JavaScript array `var SCRIPT=[ ... ]` inside `web/index.html`. The engine (`function run()`) reads it step by step. Step types:

- `{phase:'TEXT'}` scene banner. Text containing `WEEK 2`, `WEEK 3` or `WEEK 4` triggers a Week Complete celebration.
- `{clear:1}` remove all characters. `{bg:'office'}` change background.
- `{enter:'id', slot:'left|center|right', from:'left|right'}`, `{move:'id', slot:'...'}`, `{exit:'id', to:'left|right'}`
- `{say:'id', text:"..."}` dialogue. `{narrate:"..."}` narration.
- `{choice:"prompt", options:[{t:"option text", to:'label', set:{flag:1}}, ...]}`
- `{label:'name'}` (names must be unique), `{jump:'name'}`
- `{set:{flag:number}}` values are ADDED to the current value (new flags start at 0).
- `{check:'flag', gte|lte|gt|lt|eq: n, yes:'label', no:'label'}` (no comparator means "not zero").
- `{setday:n}`, `{board:1}` evidence board, `{interlude:{h:'...', title:'...'}}`, `{finale:1}` ending screen.

**Characters (ids):** `you` (player; name and look chosen at start), `bello` (Mrs. Bello, HR), `chidi` (desk-mate and friend), `oga` (boss), `ada` (Finance, love interest), `tunde` (Security, love interest), `emeka` (rival), `auditor` (corrupt auditor), `nkechi` (journalist), `md` (Chief Mrs. Balogun, the MD), `conductor` (danfo conductor, emoji only). Defined in `var CH={`.

**Backgrounds (ids):** `office`, `street`, `bukka`, `lounge`, `carpark`, `boardroom`, `restaurant`. Defined in `var BG={`. Music mood per background in `function bgMood` (`day`, `warm`, `tense`, `bright`).

**Important flags:** `standing`, `bond`, `clues`, `money`, `romance`, `evidence`, `c1` `c2` `c3` (clues), `loveAda`, `loveTunde`, `deepBond`, `allyChidi`, `solved`, `access`, `framed`, `trustNkechi`, `moleChidi`, `chidiBrave`. Endings: `m_hero`, `m_justice`, `m_join`, `m_complicit`, `m_walk` (none set = crushed). Ending text is in `function showFinale`. Reward pop-ups for flags are in `function applySet`.

**Rules when you write story for me:**
1. Give me steps in exactly the format above, ready to paste, each ending with a comma.
2. Use double quotes for any text that contains an apostrophe.
3. Every branch must end with a `jump` to a label (or the finale). Never leave a branch falling through into another scene.
4. Use new, unique label names (prefix them, for example `m2w1_`), and tell me exactly where to paste the block.
5. If you add a new flag, tell me where it is set and where it is checked.
6. Keep the dialogue grounded in everyday Lagos life, and keep romance tasteful. All characters are adults.
7. After I paste your code I run `node tools/check_story.js`, which reports broken labels and typing mistakes.

My request:
