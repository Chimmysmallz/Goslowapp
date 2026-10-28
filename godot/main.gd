# main.gd - the story engine + UI (built in code). Attach to a Control node.
# Handles: bg, phase, clear, setday, enter, move, exit, say, narrate,
#          choice, label, jump, set, check, board, interlude, finale.
extends Control

const SLOT := {"left": 0.27, "center": 0.5, "right": 0.73}
const ART := "res://art/"

var ip := 0
var day := 1
var flags := {}
var mode := "pause"        # pause | line | choice | board | inter | end
var labels := {}
var chars := {}            # id -> TextureRect
var board_sel := []

var bg: TextureRect
var char_layer: Control
var hud: Label
var dbox: Panel
var dname: Label
var dtext: Label
var portrait: TextureRect
var choicebox: VBoxContainer
var banner: Label
var board_box: VBoxContainer
var overlay: Panel
var over_label: Label
var over_btn: Button

func _ready() -> void:
    _build_ui()
    for k in Story.SCRIPT.size():
        var s = Story.SCRIPT[k]
        if s.has("label"):
            labels[s["label"]] = k
    flags = {"money": 40000}      # everything else defaults to 0 on read
    _update_hud()
    run()

func _build_ui() -> void:
    set_anchors_preset(Control.PRESET_FULL_RECT)

    bg = TextureRect.new()
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(bg)

    char_layer = Control.new()
    char_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
    char_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(char_layer)

    hud = Label.new()
    hud.position = Vector2(12, 8)
    hud.add_theme_font_size_override("font_size", 16)
    add_child(hud)

    dbox = Panel.new()
    dbox.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
    dbox.offset_top = -175
    dbox.offset_left = 16
    dbox.offset_right = -16
    dbox.offset_bottom = -16
    add_child(dbox)

    portrait = TextureRect.new()
    portrait.size = Vector2(64, 64)
    portrait.position = Vector2(12, 12)
    portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    dbox.add_child(portrait)

    var vb = VBoxContainer.new()
    vb.set_anchors_preset(Control.PRESET_FULL_RECT)
    vb.offset_left = 88
    vb.offset_top = 12
    vb.offset_right = -14
    vb.offset_bottom = -12
    dbox.add_child(vb)

    dname = Label.new()
    dname.add_theme_font_size_override("font_size", 20)
    vb.add_child(dname)

    dtext = Label.new()
    dtext.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    dtext.add_theme_font_size_override("font_size", 22)
    vb.add_child(dtext)

    choicebox = VBoxContainer.new()
    choicebox.set_anchors_preset(Control.PRESET_CENTER)
    choicebox.offset_left = -185
    choicebox.offset_right = 185
    choicebox.add_theme_constant_override("separation", 10)
    choicebox.visible = false
    add_child(choicebox)

    board_box = VBoxContainer.new()
    board_box.set_anchors_preset(Control.PRESET_CENTER)
    board_box.offset_left = -185
    board_box.offset_right = 185
    board_box.add_theme_constant_override("separation", 10)
    board_box.visible = false
    add_child(board_box)

    banner = Label.new()
    banner.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    banner.add_theme_font_size_override("font_size", 28)
    banner.visible = false
    add_child(banner)

    overlay = Panel.new()
    overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
    overlay.visible = false
    add_child(overlay)
    over_label = Label.new()
    over_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    over_label.offset_bottom = -90
    over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    over_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    over_label.add_theme_font_size_override("font_size", 22)
    overlay.add_child(over_label)
    over_btn = Button.new()
    over_btn.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
    over_btn.offset_top = -70
    over_btn.offset_left = -110
    over_btn.offset_right = 110
    over_btn.pressed.connect(_on_over_btn)
    overlay.add_child(over_btn)

func _update_hud() -> void:
    hud.text = "Day %d" % day

func _input(event) -> void:
    if mode != "line":
        return
    if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
        ip += 1
        mode = "pause"
        run()

func run() -> void:
    while ip < Story.SCRIPT.size():
        var s = Story.SCRIPT[ip]
        if s.has("label"):
            ip += 1
        elif s.has("set"):
            _apply_set(s["set"]); ip += 1
        elif s.has("jump"):
            ip = labels[s["jump"]]
        elif s.has("check"):
            var v = int(flags.get(s["check"], 0))
            var passed := false
            if s.has("gte"): passed = v >= s["gte"]
            elif s.has("lte"): passed = v <= s["lte"]
            elif s.has("lt"): passed = v < s["lt"]
            elif s.has("gt"): passed = v > s["gt"]
            elif s.has("eq"): passed = v == s["eq"]
            else: passed = v != 0
            ip = labels[s["yes"]] if passed else labels[s["no"]]
        elif s.has("setday"):
            day = int(s["setday"]); _update_hud(); ip += 1
        elif s.has("clear"):
            _clear_chars(); ip += 1
        elif s.has("bg"):
            _set_bg(s["bg"]); ip += 1
        elif s.has("phase"):
            ip += 1
            await _show_banner(s["phase"])
        elif s.has("enter"):
            _do_enter(s); ip += 1
            await get_tree().create_timer(0.7).timeout
        elif s.has("move"):
            _do_move(s); ip += 1
            await get_tree().create_timer(0.6).timeout
        elif s.has("exit"):
            _do_exit(s); ip += 1
            await get_tree().create_timer(0.55).timeout
        elif s.has("say"):
            _show_line(s["say"], s["text"]); mode = "line"; return
        elif s.has("narrate"):
            _show_narrate(s["narrate"]); mode = "line"; return
        elif s.has("choice"):
            _show_choice(s); mode = "choice"; return
        elif s.has("board"):
            _show_board(); return
        elif s.has("interlude"):
            _show_interlude(s["interlude"]); return
        elif s.has("finale"):
            _show_finale(); return
        else:
            ip += 1

func _apply_set(o: Dictionary) -> void:
    for k in o:
        flags[k] = int(flags.get(k, 0)) + o[k]

func _vw() -> float: return get_viewport_rect().size.x
func _vh() -> float: return get_viewport_rect().size.y

func _set_bg(key: String) -> void:
    var path = ART + String(Story.BGS.get(key, ""))
    if ResourceLoader.exists(path):
        bg.texture = load(path)

func _target_x(slot: String, w: float) -> float:
    return _vw() * SLOT[slot] - w / 2.0

func _do_enter(s: Dictionary) -> void:
    var id = s["enter"]
    var tr: TextureRect
    if chars.has(id):
        tr = chars[id]
    else:
        tr = TextureRect.new()
        var path = ART + String(Story.CHARS[id]["img"])
        if ResourceLoader.exists(path):
            tr.texture = load(path)
        tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
        var h = _vh() * 0.62
        tr.size = Vector2(h * 0.55, h)
        tr.position.y = _vh() * 0.82 - h
        var from_x = -0.45 if s.get("from", "left") == "left" else 1.4
        tr.position.x = _vw() * from_x
        char_layer.add_child(tr)
        chars[id] = tr
    create_tween().tween_property(tr, "position:x", _target_x(s["slot"], tr.size.x), 0.6)

func _do_move(s: Dictionary) -> void:
    if chars.has(s["move"]):
        var tr = chars[s["move"]]
        create_tween().tween_property(tr, "position:x", _target_x(s["slot"], tr.size.x), 0.55)

func _do_exit(s: Dictionary) -> void:
    if chars.has(s["exit"]):
        var tr = chars[s["exit"]]
        var to_x = -0.5 if s.get("to", "right") == "left" else 1.4
        var tw = create_tween()
        tw.tween_property(tr, "position:x", _vw() * to_x, 0.5)
        tw.tween_callback(tr.queue_free)
        chars.erase(s["exit"])

func _clear_chars() -> void:
    for id in chars:
        chars[id].queue_free()
    chars = {}

func _highlight(who) -> void:
    for id in chars:
        chars[id].modulate = Color(1, 1, 1) if id == who else Color(0.6, 0.6, 0.6)

func _show_line(who: String, text: String) -> void:
    var c = Story.CHARS[who]
    dbox.visible = true
    dname.text = c["name"]
    dname.add_theme_color_override("font_color", Color(c["color"]))
    dtext.text = text
    var path = ART + String(c["img"])
    portrait.visible = true
    portrait.texture = load(path) if ResourceLoader.exists(path) else null
    _highlight(who)

func _show_narrate(text: String) -> void:
    dbox.visible = true
    dname.text = ""
    portrait.visible = false
    dtext.text = text
    _highlight("")

func _show_choice(s: Dictionary) -> void:
    dbox.visible = false
    for c in choicebox.get_children():
        c.queue_free()
    var prompt = Label.new()
    prompt.text = s["choice"]
    prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    prompt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    choicebox.add_child(prompt)
    for opt in s["options"]:
        var btn = Button.new()
        btn.text = opt["t"]
        btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        btn.pressed.connect(_on_choice.bind(opt))
        choicebox.add_child(btn)
    choicebox.visible = true

func _on_choice(opt: Dictionary) -> void:
    choicebox.visible = false
    if opt.has("set"):
        _apply_set(opt["set"])
    ip = labels[opt["to"]]
    mode = "pause"
    run()

func _show_banner(text: String) -> void:
    banner.text = text
    banner.visible = true
    await get_tree().create_timer(1.2).timeout
    banner.visible = false

# ---- evidence board: tap the two clues that name the same suspect ----
func _show_board() -> void:
    mode = "board"
    board_sel = []
    dbox.visible = false
    _highlight("")
    for c in board_box.get_children():
        c.queue_free()
    var prompt = Label.new()
    prompt.text = "Tap the TWO clues that point to the same suspect."
    prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    board_box.add_child(prompt)
    for k in ["c1", "c2", "c3"]:
        if int(flags.get(k, 0)) > 0:
            var btn = Button.new()
            btn.text = Story.CLUES[k]["t"]
            btn.toggle_mode = true
            btn.pressed.connect(_on_board_pick.bind(k))
            board_box.add_child(btn)
    board_box.visible = true

func _on_board_pick(k) -> void:
    if k in board_sel:
        board_sel.erase(k)
    elif board_sel.size() < 2:
        board_sel.append(k)
    if board_sel.size() == 2:
        if "c2" in board_sel and "c3" in board_sel:
            board_box.visible = false
            ip += 1
            mode = "pause"
            run()
        else:
            board_sel = []
            for b in board_box.get_children():
                if b is Button:
                    b.button_pressed = false

# ---- day-transition card ----
func _show_interlude(o: Dictionary) -> void:
    mode = "inter"
    dbox.visible = false
    _highlight("")
    over_label.text = String(o.get("h", "")) + "\n\n" + String(o.get("title", ""))
    over_btn.text = "Continue"
    overlay.visible = true

# ---- month finale ----
func _show_finale() -> void:
    mode = "end"
    dbox.visible = false
    _highlight("")
    var head := ""
    var job := ""
    var myst := ""
    if int(flags.get("m_hero", 0)) > 0:
        head = "You brought her down."; job = "Promoted - a rising star"; myst = "The MD empire: exposed"
    elif int(flags.get("m_justice", 0)) > 0:
        head = "You handed it to the law."; job = "A witness for the state"; myst = "Justice, slow but coming"
    elif int(flags.get("m_join", 0)) > 0:
        head = "You took a seat at the top."; job = "One of them now"; myst = "The rot rolls on, with you in it"
    elif int(flags.get("m_complicit", 0)) > 0:
        head = "Your own signature trapped you."; job = "Employed, and owned"; myst = "Silenced"
    elif int(flags.get("m_walk", 0)) > 0:
        head = "You walked away - alive."; job = "Free, unfamous"; myst = "The rot remains"
    else:
        head = "She crushed you and the truth."; job = "Broken, for now"; myst = "The MD walks free"
    var rom := "Flying solo"
    if (int(flags.get("loveAda", 0)) > 0 or int(flags.get("loveTunde", 0)) > 0) and int(flags.get("romance", 0)) >= 2:
        rom = "Together with " + ("Ada" if int(flags.get("loveAda", 0)) > 0 else "Tunde")
    elif int(flags.get("loveAda", 0)) > 0:
        rom = "A spark with Ada"
    elif int(flags.get("loveTunde", 0)) > 0:
        rom = "A spark with Tunde"
    over_label.text = "END OF THE MONTH\n\n" + head + "\n\n" + job + "\n" + myst + "\n" + rom
    over_btn.text = "Play again"
    overlay.visible = true

func _on_over_btn() -> void:
    if mode == "end":
        get_tree().reload_current_scene()
    else:
        overlay.visible = false
        ip += 1
        mode = "pause"
        run()
