# 🚌 GO-SLOW — Survive a Month in Lagos

**Go-Slow** is a mobile interactive story game. You play a young office worker trying to survive one month in Lagos: the danfo at 7:40 AM, an HR officer counting your late days, rent due on Friday, and a quiet corruption trail that climbs all the way to the company MD. Every choice you make is remembered. Your friends, your romance, your job and your bank balance all decide how the month ends.

It plays in any phone browser, installs to the home screen on Android and iPhone, works offline, and has a Godot 4 version for building a native app.

> **Play it:** `https://YOUR-USERNAME.github.io/go-slow/` (replace with your link once GitHub Pages is switched on, see [Publishing](#4-publishing-the-game-on-github-pages))

---

## Contents

1. [What the game is](#1-what-the-game-is)
2. [What is in this repository](#2-what-is-in-this-repository)
3. [Getting set up](#3-getting-set-up)
4. [Publishing the game on GitHub Pages](#4-publishing-the-game-on-github-pages)
5. [Testing on your phone](#5-testing-on-your-phone)
6. [The everyday update routine](#6-the-everyday-update-routine)
7. [How the story is written](#7-how-the-story-is-written)
8. [Characters, backgrounds, music and screens](#8-characters-backgrounds-music-and-screens)
9. [The helper tools](#9-the-helper-tools)
10. [Installing as an app and making an Android APK](#10-installing-as-an-app-and-making-an-android-apk)
11. [The Godot version](#11-the-godot-version)
12. [Getting help from an AI assistant](#12-getting-help-from-an-ai-assistant)
13. [Troubleshooting](#13-troubleshooting)
14. [Known issues and roadmap](#14-known-issues-and-roadmap)
15. [Credits and licence](#15-credits-and-licence)
16. [Security and privacy](#16-security-and-privacy)

---

## 1. What the game is

| | |
|---|---|
| **Genre** | Interactive story (in the style of Episode and Choices) with life-sim pressure |
| **Platform** | Mobile web (portrait). Installable on Android and iPhone. Godot 4 port included. |
| **Length** | One month: 4 weeks, 753 story steps, 23 choices, 6 main endings, 4 romance outcomes |
| **Cast** | 11 characters: you, Mrs. Bello (HR), Chidi, the Oga, Ada, Tunde, Emeka, the Auditor, Nkechi, Chief Mrs. Balogun (the MD), and Conductor Baba |
| **Version** | 1.0.1 (October 2026) |
| **Age** | Recommended 13+ (corruption, threats, an off-screen attack, adult romance kept tasteful) |

### The story in four weeks
- **Week 1 — Late Again.** A danfo ride, an HR query, lunch with Chidi, a rooftop evening with Ada or Tunde, and the first clues on the evidence board. It ends with a Friday reckoning in the boardroom.
- **Week 2 — The Trail Goes Higher.** Nkechi, a journalist, gets in touch, and the money trail leads to Chief Mrs. Balogun.
- **Week 3 — Someone Talks.** Somebody leaks, Chidi pays a price for helping you, and danger comes to your door.
- **Week 4 — The Reckoning.** Expose her, testify, join her, or walk away.

### What the player sees
- A main menu with New Game, Continue, How to Play, Characters, Settings and About
- Character creation: type your name and pick one of three looks
- Animated characters who walk in, react (a shake when angry, a bounce when happy) and dim when they are not speaking
- Typewriter dialogue, choice cards, and reward pop-ups such as "🔎 Clue found!" and "❤️ Bond up"
- Mood music that changes with the scene (day, warm, tense, celebration), plus sound effects
- A live top bar showing day, standing, clues and money, with a progress bar across the month
- An evidence board puzzle, "Week Complete" celebrations with confetti, and an end-of-month summary
- Automatic saving, with Continue on the main menu

### What the player's choices change
| Flag | Meaning |
|---|---|
| `standing` | How the office sees you. Low standing brings queries and threats of the sack. |
| `bond` | Your friendship with Chidi. It decides whether he betrays you or stands by you. |
| `clues`, `c1` `c2` `c3`, `evidence` | Your progress on the mystery. Without enough of these you cannot win. |
| `money` | Starts at ₦40,000. Rent is ₦120,000. The bribe looks very tempting when you are short. |
| `loveAda` / `loveTunde`, `romance`, `deepBond` | Your romance and how deep it goes. |
| `allyChidi`, `allyPartner`, `trustNkechi` | Who will stand with you at the end. |

---

## 2. What is in this repository

```
go-slow/
├── README.md               ← this guide
├── AI-HANDOFF.md           ← paste into any AI assistant so it understands the project
├── ART-STYLE.md            ← how to make new art that matches the game
├── CHANGELOG.md            ← a record of each update
├── LICENSE                 ← all rights reserved
├── PRIVACY.md              ← privacy notice for players
├── .gitignore
├── .github/workflows/
│   └── publish.yml         ← checks the story, then publishes web/ to GitHub Pages
├── .github/dependabot.yml  ← weekly check for security updates to the publishing steps
├── web/                    ← THE GAME (this is what gets published)
│   ├── index.html          ← story, screens, engine, music: all in one readable file
│   ├── manifest.json       ← lets phones install it as an app
│   ├── sw.js               ← offline support (raise the version on every update)
│   ├── icon-192.png, icon-512.png
│   └── art/                ← characters (.png) and backgrounds (.jpg)
├── tools/
│   ├── check_story.js      ← finds broken links and typing mistakes in the story
│   ├── simulate.js         ← plays the month thousands of times and reports endings
│   ├── build_singlefile.js ← packs the game into one offline file
│   └── export_godot.js     ← copies the story into the Godot version
├── godot/                  ← Godot 4 project (native app route)
├── art-source/             ← full-size original artwork and a cast reference sheet
└── docs/                   ← Game Design Document, story flow map, Game Bible
```

**Only `web/` is published.** Everything else is for you: tools, source art and documents.

---

## 3. Getting set up

### Free tools to install
| Tool | Why you need it | Where |
|---|---|---|
| **Visual Studio Code** | Edit the game | code.visualstudio.com |
| **Live Server** (VS Code extension) | Preview the game in your browser with one click | Inside VS Code: Extensions → search "Live Server" |
| **Node.js (LTS)** | Runs the helper tools | nodejs.org |
| **GitHub account** | Stores every version and publishes the game | github.com |
| **GitHub Desktop** | Uploads your changes without typing commands | desktop.github.com |
| **Google Chrome** | Testing | google.com/chrome |

Use a **personal email address** for your GitHub account so the game stays yours, separate from any work account.

### Putting the files on GitHub (first time)

**Option 1: GitHub Desktop (recommended)**
1. Unzip this folder somewhere easy, for example `Documents\go-slow`.
2. Open GitHub Desktop and sign in.
3. **File → Add local repository** → choose the `go-slow` folder. When it says this is not a repository yet, click **create a repository**.
4. Click **Publish repository**. **Untick "Keep this code private"**, because GitHub Pages is free only for public repositories.

**Option 2: The GitHub website**
1. On github.com, click **New repository**, name it `go-slow`, choose **Public**, and click **Create repository**.
2. Click **uploading an existing file**.
3. Open the unzipped `go-slow` folder, select **everything inside it**, and drag it onto the page. Then click **Commit changes**.
4. Check that the `.github` folder arrived. On a Mac, folders that start with a dot are hidden, so press **Cmd + Shift + .** in Finder to show them before dragging. If it is missing, create the file by hand: **Add file → Create new file**, type `.github/workflows/publish.yml` as the name, and paste in the contents of that file.

> The website accepts up to 100 files per upload. This repository has fewer than 100, so one upload is enough.

---

## 4. Publishing the game on GitHub Pages

1. In your repository on github.com, go to **Settings → Pages**.
2. Under **Build and deployment → Source**, choose **GitHub Actions**.
3. Open the **Actions** tab. A run called **Publish game** appears. If it does not start on its own, click **Publish game → Run workflow**.
4. When it shows a green tick, your game is live at:
   **`https://YOUR-USERNAME.github.io/go-slow/`**
5. Back in **Settings → Pages**, make sure **Enforce HTTPS** is ticked. (It is usually on and greyed out for `github.io` addresses, which means it is already enforced.)

From then on, **every change you push publishes itself**. Before publishing, the workflow runs the story checker. If the story has a broken link or a typing mistake, it **stops and keeps the old version live**, so players never see a broken game. Click the failed run in the Actions tab to see the exact problem.

---

## 5. Testing on your phone

### With your published link
Open your GitHub Pages link in **Safari** (iPhone) or **Chrome** (Android). Saving, Continue and offline play all work.

### Before you publish: from your computer over Wi-Fi
This needs no account and no internet upload.
1. In VS Code, open **Terminal → New Terminal** and run:
   ```
   npx http-server web -p 8080
   ```
   (or, if you have Python: `cd web` then `python -m http.server 8080`)
2. Find your computer's address: run `ipconfig` (Windows) or `ifconfig` (Mac) and look for an address like `192.168.0.105`.
3. Connect your phone to the **same Wi-Fi** (or the same hotspot) and open `http://192.168.0.105:8080`.
4. If Windows shows a firewall pop-up, click **Allow** for private networks.

### What to check on a phone
- Text is easy to read, buttons are easy to tap, and the dialogue box does not cover faces.
- Sound plays (turn off the silent switch on iPhone).
- Save: play a few scenes, tap **☰**, close the browser, reopen, and press **Continue**.
- Rotate the phone and check that nothing breaks.

---

## 6. The everyday update routine

1. Open the `go-slow` folder in VS Code.
2. Edit `web/index.html`.
3. Preview it: right-click `web/index.html` → **Open with Live Server**. In Chrome, press **F12** and click the phone icon to see it at phone size.
4. Run the checks in the VS Code terminal:
   ```
   node tools/check_story.js
   node tools/simulate.js
   ```
5. Open `web/sw.js` and raise the version: `goslow-v2` becomes `goslow-v3`. **If you skip this, phones that installed the game may keep showing the old version.**
6. Add one line to `CHANGELOG.md`.
7. In GitHub Desktop, write a short summary (for example "Added Week 2 market scene"), click **Commit to main**, then **Push origin**.
8. About one minute later, the live game is updated.

**To undo a mistake:** before you push, right-click the file in GitHub Desktop's **Changes** list and choose **Discard changes**. After you push, open the **History** tab, right-click the commit and choose **Revert changes in commit**. Nothing is ever lost.

---

## 7. How the story is written

The whole story lives in `web/index.html`. Press **Ctrl+F** and search for **`var SCRIPT=[`**. It is a list of steps that the game reads from top to bottom. Each step is one `{...}` followed by a comma.

### Every step type

| Step | What it does | Example |
|---|---|---|
| `phase` | A big banner announcing a new scene. A phase that contains `WEEK 2`, `WEEK 3` or `WEEK 4` triggers the Week Complete celebration. | `{phase:'💼 THE OFFICE · 8:19 AM'},` |
| `clear` | Removes all characters from the screen | `{clear:1},` |
| `bg` | Changes the background | `{bg:'office'},` |
| `enter` | A character walks in. `slot`: `left`, `center` or `right`. `from`: `left` or `right`. | `{enter:'chidi', slot:'right', from:'right'},` |
| `move` | Moves a character to another slot | `{move:'you', slot:'center'},` |
| `exit` | A character walks out | `{exit:'bello', to:'right'},` |
| `say` | A character speaks | `{say:'chidi', text:"Guy, you look tired."},` |
| `narrate` | Narration in italics, with no speaker | `{narrate:"The light goes off. Again."},` |
| `choice` | The player chooses. Each option has text `t`, a destination `to`, and an optional `set`. | see the example below |
| `label` | A named place in the story. Every name must be unique. | `{label:'lunch'},` |
| `jump` | Goes straight to a label | `{jump:'lunch'},` |
| `set` | Changes flags. Numbers are **added** to the current value. | `{set:{bond:1, money:-5000}},` |
| `check` | Looks at a flag and branches | `{check:'bond', gte:1, yes:'trusts', no:'wary'},` |
| `setday` | Changes the day shown at the top | `{setday:2},` |
| `board` | Opens the evidence board puzzle | `{board:1},` |
| `interlude` | A full-screen title card with a Continue button | `{interlude:{h:'WEEK 2', title:'The Trail Goes Higher'}},` |
| `finale` | Shows the end-of-month screen | `{finale:1},` |

**Comparisons for `check`:** `gte` (at least), `lte` (at most), `gt` (more than), `lt` (less than), `eq` (exactly). With none of these, the check asks "is this flag anything other than zero?".

### Five rules that prevent almost every mistake
1. Every step ends with a comma: `{say:'you', text:"Hi."},`
2. If the text contains an apostrophe (`don't`, `I'm`), wrap it in **double quotes**.
3. Character and background ids are always lower case: `'chidi'`, not `'Chidi'`.
4. Every branch must finish with a `jump` (or the `finale`). Otherwise it runs straight into the next scene by accident.
5. Run `node tools/check_story.js` after every edit.

Pidgin and emoji are fine anywhere in the text: `text:"Abeg, no vex 🙏🏾"`.

### Example: a choice that pays off weeks later
```js
{say:'chidi', text:"Lend me ₦5,000 till Friday? Na emergency."},
{choice:"Chidi needs money.", options:[
  {t:"“Take it, my guy.”",      to:'lend',   set:{money:-5000, bond:1, lentChidi:1}},
  {t:"“I am broke too, sorry.”", to:'nolend'}
]},
{label:'lend'},   {say:'chidi', text:"You are a real one. I will not forget."}, {jump:'afterLoan'},
{label:'nolend'}, {say:'chidi', text:"No wahala. I understand."},              {jump:'afterLoan'},
{label:'afterLoan'},
```
Then, in a later week:
```js
{check:'lentChidi', yes:'chidiRepays', no:'skipRepay'},
{label:'chidiRepays'}, {say:'chidi', text:"Here is your ₦5,000. Plus something extra."}, {set:{money:7000}}, {jump:'skipRepay'},
{label:'skipRepay'},
```
That is the whole idea behind choices that carry across weeks: **`set` a flag now, `check` it later.** New flags need no setup. The first `set` creates them, starting from zero.

### Endings
The ending screen is built in `function showFinale`. It looks for one of these flags, in this order: `m_hero`, `m_justice`, `m_join`, `m_complicit`, `m_walk`. If none is set, the player is "crushed". The romance line uses `deepBond`, `romance`, `loveAda` and `loveTunde`. To change the ending text, edit the lines in `showFinale`.

### Reward pop-ups
Pop-ups appear automatically when these flags go up: `c1` `c2` `c3`, `money`, `bond`, `standing`, `evidence`, `romance`, `loveAda`, `loveTunde`, `deepBond`, `allyChidi`. To add one for a new flag, find `function applySet` and copy one of its `else if` lines.

---

## 8. Characters, backgrounds, music and screens

| To change… | Search `web/index.html` for… |
|---|---|
| A character's display name or name colour | `var CH={` |
| Character bios on the Characters screen | `var CAST=` |
| The three looks in character creation | `var LOOKS=` |
| Backgrounds | `var BG={` |
| Which music mood a background uses | `function bgMood` (moods: `day`, `warm`, `tense`, `bright`) |
| The music (speed and chords) | `var MOODS=` |
| Starting money and the other starting flags | `function resetFlags` |
| Rent amount | `RENT=` |
| Evidence board cards | `var CLUES=` |
| How to Play text | `id="guideov"` |
| About text and version number | `id="aboutov"` |
| Which words make characters shake or bounce | `function _emote` |
| Default text speed (lower is faster) | `TYPE_SPEED=` |
| Colours (danfo yellow and others) | `:root{` at the top of the file |

### Adding a new character
1. Make a full-body PNG with a transparent background, **360 × 540 px** (see `ART-STYLE.md`).
2. Save it as `web/art/kemi.png`.
3. In `var CH={`, add: `kemi:{img:'art/kemi.png', name:'Kemi', color:'#a3e635'},`
4. Optionally, add her to `var CAST=` so she appears on the Characters screen.
5. Use her in the story: `{enter:'kemi', slot:'right', from:'right'}, {say:'kemi', text:"Hello!"},`
6. Add `"art/kemi.png"` to the file list in `web/sw.js` and raise its version number.

A character without a picture also works. It shows an emoji in the speech bubble instead: `conductor:{emoji:'🚌', name:'Conductor Baba', color:'#7CFFA0'}`.

### Adding a new background
1. A landscape JPG, about **920 × 613 px**, saved as `web/art/market.jpg`.
2. In `var BG={`, add `market:'art/market.jpg',`
3. Optionally, give it a music mood in `function bgMood`.
4. Add it to `web/sw.js` and raise the version.

---

## 9. The helper tools

Run these from the `go-slow` folder in the VS Code terminal. They need Node.js and nothing else.

| Command | What it does |
|---|---|
| `node tools/check_story.js` | Checks every jump, choice and check points to a real label, every character and background exists, and the story has no typing mistakes. **"0 errors" means safe to publish.** |
| `node tools/simulate.js` | Plays the month 2,000 times with random choices and reports average length, how often each ending happens, and any lines nobody can reach. Add a number for more runs: `node tools/simulate.js 20000`. |
| `node tools/build_singlefile.js` | Builds `dist/go-slow-offline.html`, one file with all the art packed inside, to send to someone directly. (Saving does not work when that file is opened straight from a phone's storage.) |
| `node tools/export_godot.js` | Copies the latest story from `web/index.html` into `godot/story.gd`, so both versions match. |

---

## 10. Installing as an app and making an Android APK

### Home screen install (no app store)
- **iPhone:** open your GitHub Pages link in **Safari** → **Share** → **Add to Home Screen**.
- **Android:** open the link in **Chrome** → **⋮** → **Install app** or **Add to Home screen**.

It opens full-screen with the yellow danfo icon and works offline after the first visit.

### Android APK (free, using PWABuilder)
1. Make sure the game is live on GitHub Pages.
2. Go to **pwabuilder.com**, paste your GitHub Pages link and click **Start**.
3. Click **Package for stores → Android → Generate package**, then download the zip.
4. Inside the zip, the `.apk` file can be copied to your phone and installed. (Allow "Install unknown apps" for your file manager when asked.)
5. The zip also contains a **signing key** and its password. **Keep these safe**, for example in a password manager. You need the same key for every future update if you publish on the Google Play Store.

### Native route
For a true native app built in Godot, see [section 11](#11-the-godot-version).

---

## 11. The Godot version

The `godot/` folder is a Godot 4 project that runs the same story with the same engine logic. Godot is free at godotengine.org.

1. Run `node tools/export_godot.js` so `godot/story.gd` has the latest story.
2. Open Godot 4 → **Import** → choose `godot/project.godot` → **Import & Edit**.
3. Press **F5** to play.

`story.gd` holds the data (characters, backgrounds, clues and all 753 story steps). `main.gd` is the engine and builds the screen in code. `godot/README.md` has the details, including exporting an Android APK from Godot (this needs the Android SDK and Java JDK 17).

The Godot version is a starter port. It has the full story but not yet the web version's menus, music or animations.

---

## 12. Getting help from an AI assistant

Open **`AI-HANDOFF.md`**, copy all of it, and paste it into any AI assistant (GitHub Copilot inside VS Code, ChatGPT, Gemini and others). It explains the project, the story format and the rules. Then type your request, for example:

> Write a Week 2 scene where Ada introduces me to her mother at a Sunday lunch. Give her two choices that change `deepBond`.

**Always run `node tools/check_story.js`** on anything an AI writes before you publish.

For art, `ART-STYLE.md` has ready-made prompts and the exact sizes, plus a description of every existing character.

---

## 13. Troubleshooting

| Problem | Fix |
|---|---|
| Black screen after an edit | Run `node tools/check_story.js`. It nearly always points to a missing comma or quote near your last edit. |
| The publish failed on GitHub | Open the **Actions** tab, click the failed run, and open "Check the story for broken links". It names the step and the problem. The old version stays live meanwhile. |
| My change does not show on my phone | Raise the version in `web/sw.js`, push again, then fully close and reopen the app or browser tab. |
| A picture is missing | File names must match exactly, including capital letters and `.png` / `.jpg`. GitHub is case-sensitive. |
| No GitHub Pages link | Check that the repository is **public** and that **Settings → Pages → Source** is set to **GitHub Actions**. |
| Continue does not appear | Saving needs a web link (GitHub Pages, Live Server or the Wi-Fi method). It does not work when a file is opened straight from phone storage. |
| No sound on iPhone | Turn off the silent switch. Sound starts after your first tap, as browsers require. |
| `node` is not recognised | Restart VS Code after installing Node.js. If it still fails, restart the computer. |
| The phone cannot reach the Wi-Fi test address | Both devices must be on the same network. Allow the firewall pop-up on Windows, and check the address with `ipconfig`. |

---

## 14. Known issues and roadmap

### Known issues (found by `tools/simulate.js`)
- **The "spark" romance outcome cannot be reached.** Players who start a romance either reach "together" or "deep bond", or end up "solo".
- **Two lines are never shown** (story steps 410 and 684). Both need a branch that leads to them.
- **The month is short.** A typical run is about 67 lines and 16 choices, roughly 10 minutes with animations.
- **The best ending is rare.** Whistleblower comes up in about 5% of random runs, so players need clearer hints about how to earn it.
- **Character art is soft on large phone screens.** The full-size originals are in `art-source/` and can be re-exported at a higher resolution.

### Roadmap
1. Fix the issues above.
2. **Daily-life layer:** commute choice, NEPA and generator, rent and landlord trouble, flooding (ground floor) and roof leaks (top floor), and two or three playable mini-moments such as cooking jollof or haggling at the market.
3. **Replay value:** an endings gallery, skipping text you have already read, and a shareable ending card.
4. **Comfort:** text size setting, a dialogue history screen, and more than one save slot.
5. **Month 2:** a new case that continues from how Month 1 ended.
6. **Publish on itch.io** (upload a zip of the contents of `web/` as an HTML game, viewport 440 × 860) and add simple visitor stats to see where players stop.

---

## 15. Credits and licence

Created by **Chiamaka Nwabulue**.

Story, design and code © 2026 Chiamaka Nwabulue. All rights reserved. See `LICENSE`.

Artwork was generated with AI image tools and edited for the game. Music and sound effects are generated live in the browser, so there are no audio files.

---

## 16. Security and privacy

Go-Slow was checked on 28 October 2026 against two common pre-launch checklists: a 20-point app security list and a 7-point Nigerian data-protection (NDPC) list.

### Why most of the security list does not apply
Go-Slow is a **static game**. There is no server, no database, no login, no payments, no file uploads and no outside services. Everything runs in the player's browser, and the only thing stored is a small saved game on the player's own device. Items such as API keys, database keys, row-level security, server-side auth, session cookies, password hashing, login rate limits, bot protection, database queries, file uploads and API responses have nothing to protect.

### What is in place
| Protection | How |
|---|---|
| No secrets in the code | Scanned: no keys, tokens, passwords, emails or private data in any file. Pictures and documents carry no hidden personal metadata. |
| Safe handling of what players type | The character name is cleaned (16 characters, no `<` `>` or control characters) and shown as plain text everywhere. |
| Saved games cannot be used to break the game | A saved game is checked before loading. A damaged or edited save starts a fresh game instead. |
| Browser security rules | A Content Security Policy in `web/index.html` blocks outside scripts, outside connections, plug-ins and form posting, and upgrades any web address to HTTPS. A no-referrer rule stops the game leaking its address to other sites. |
| HTTPS | Enforced by GitHub Pages for `github.io` addresses. |
| Dependencies | The game uses **no outside libraries**. The tools use only what comes with Node.js. Dependabot checks the publishing steps weekly. |
| Safe publishing | The story checker runs before every publish, and the publish stops if it fails. |
| Privacy | No accounts, ads, analytics, cookies, outside fonts or tracking. See `PRIVACY.md` and the About screen in the game. |

### Rules to keep it this way
1. **Never paste a key, password or token** into any file in this repository. Anything pushed to a public repository is public, even after you delete it.
2. **Do not add outside fonts, analytics or ad scripts.** If you ever must, update the Content Security Policy at the top of `web/index.html`, update `PRIVACY.md`, and add a cookie/consent notice if the new service uses cookies or tracking.
3. **Anything a player types must be shown with `textContent`, or passed through `esc()`** before it goes into `innerHTML`.
4. **If you add accounts, emails, payments or an online leaderboard later,** the whole picture changes. You will need server-side checks, a real privacy policy, consent for any marketing emails (with an unsubscribe link), clear renewal and refund terms for any subscription, and age checks if children might sign up. Get a proper review at that point.

This is a technical check, not legal advice.

