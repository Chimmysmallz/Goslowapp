# GO-SLOW - Godot 4 Starter Kit

This is a runnable Godot 4 port of your interactive-story engine. The whole game
is "a list of instructions + a small interpreter that plays them", so everything
you designed carries straight over.

## What is in here
- `main.gd`     - the engine + on-screen UI (built in code, so you do not have to
                  hand-build the scene tree).
- `story.gd`    - all the DATA: characters, backgrounds, clues, and the FULL
                  month story (all 753 steps, Weeks 1-4). Nothing to paste.
- `project.godot`, `main.tscn` - a ready Godot project.
- `art/`        - every character and background, plus the app icon.

## Run it (5 minutes)
1. Install **Godot 4.x** (free, godotengine.org).
2. Open Godot -> **Import** -> pick the `project.godot` in this folder -> **Import & Edit**.
3. Press **F5** (Play). If asked, choose `main.tscn` as the main scene.
4. Tap/click to advance dialogue; click a choice to branch.

If `main.tscn` ever fails to open, just make it yourself: New Scene -> add a
**Control** node as the root -> attach `main.gd` to it -> save as `main.tscn`.

## The full month is already in
`story.gd` contains the complete game - all four weeks, every branch, the
evidence board, and the six month endings. `main.gd` already handles every
instruction shape it uses: `bg`, `phase`, `clear`, `setday`, `enter`, `move`,
`exit`, `say`, `narrate`, `choice`, `label`, `jump`, `set`, `check`, `board`,
`interlude`, `finale`. To edit the story, just open `story.gd` and change lines.

## Add music
Drop `.ogg` files into an `audio/` folder, add an **AudioStreamPlayer** node, and
`play()` a track when a scene starts (switch tracks by mood: day / warm / tense).

## Save / load (optional)
Use a ConfigFile at `user://save.cfg` to store `ip` and `flags`, and restore them
on launch - same idea as the browser version.

## Export to Android (get an APK)
1. In Godot: **Editor -> Manage Export Templates -> Download**.
2. Install **Java JDK 17** and the **Android SDK** (via Android Studio).
3. **Project -> Export -> Add -> Android**, set the SDK/JDK/keystore paths
   (Godot shows a green tick when valid).
4. On your phone: enable **Developer options -> USB debugging**, plug in, and click
   the little Android **Run** icon (top-right) for one-click install - or **Export
   Project** to save an `.apk` you copy over.

Full details are in the main README.md, section "Android APK".

You built the whole design already. This is just the engine, in Godot. Go. 🚌
