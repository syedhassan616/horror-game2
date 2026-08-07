extends Node2D
## THE UNCLAIMED — Prologue, playable.
##
## Story Bible §04. In twenty minutes this must teach what a Ward is, what
## severance looks like from outside, the tether, and that SEVER is in the menu
## and nobody mentions it — and it must end with the player liking Osk enough that
## losing him lands, in under fourteen minutes of screen time with him.
##
## Built entirely in code: there is no art yet, and waiting for art to test whether
## a scene works is how you find out too late that it doesn't.

const DIALOGUE_SRC := "res://data/dialogue/src/prologue.sh"

const AISLE_Y := 96.0
const DRAWER_COUNT := 12
const DRAWER_SPACING := 34.0

var _dialogue: DialogueResource
var _player: OverworldPlayer
var _hud: Label
var _dread_overlay: ColorRect

## Set when the severance cue fires. Everything about the region changes after.
var _post_severance: bool = false
var _duck_timer: float = 0.0


func _ready() -> void:
	_build_dialogue()
	_build_room()
	_build_hud()

	DialogueRunner.cue_fired.connect(_on_cue)
	DialogueRunner.finished.connect(_on_dialogue_finished)

	# S-001: the game opens on an image, not an explanation. Three seconds of
	# nothing before the player is given control or a single word of UI.
	await get_tree().create_timer(1.2).timeout
	_hud.visible = true


func _build_dialogue() -> void:
	var parser := DialogueParser.new()
	_dialogue = parser.parse_file(DIALOGUE_SRC)
	if not parser.errors.is_empty():
		for e in parser.errors:
			push_error("dialogue: %s" % e)


func _build_room() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(480, 270)
	bg.color = Color(0.055, 0.06, 0.10)          # indigo — the Unclaimed's palette
	bg.z_index = -20
	add_child(bg)

	# Sodium lamps, 40 units apart, so the player walks through alternating pools of
	# warm and cold. The game's first statement that light is maintained by somebody.
	for i in 5:
		var lamp := PointLight2D.new()
		lamp.position = Vector2(60 + i * 90, 40)
		lamp.color = Color(1.0, 0.78, 0.42)
		lamp.energy = 0.9
		lamp.texture_scale = 2.2
		lamp.texture = _radial_texture()
		add_child(lamp)

	_player = OverworldPlayer.new()
	_player.position = Vector2(40, AISLE_Y + 24)
	add_child(_player)

	# Drawers. Two of the twelve matter; the game does not say which.
	for i in DRAWER_COUNT:
		var x := 30 + i * DRAWER_SPACING
		var node_id := &"drawer_generic"
		var tint := Color(0.42, 0.45, 0.58)
		if i == 3:
			node_id = &"drawer_ilsabet"                # Entry 12 — F26
		elif i == 8:
			node_id = &"drawer_reserved"               # Entry 1441 — F01. Aven's.
			tint = Color(0.42, 0.58, 0.45)             # the forbidden colour, once
		_add_interactable(Vector2(x, AISLE_Y), node_id, tint, Vector2(24, 14))

	# Osk, at the sorting desk. He never stops working.
	_add_interactable(Vector2(400, AISLE_Y + 30), &"osk_first",
		Color(0.85, 0.72, 0.5), Vector2(14, 18), &"osk_marren")

	_dread_overlay = ColorRect.new()
	_dread_overlay.size = Vector2(480, 270)
	_dread_overlay.color = Color(0, 0, 0, 0)
	_dread_overlay.z_index = 50
	_dread_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_dread_overlay)


func _add_interactable(pos: Vector2, node_id: StringName, tint: Color,
		size: Vector2, repeat_id: StringName = &"") -> void:
	var it := Interactable.new()
	it.position = pos
	it.dialogue_node = node_id
	it.repeat_node = repeat_id
	add_child(it)

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size + Vector2(14, 14)             # generous interaction radius
	shape.shape = rect
	shape.name = "Shape"
	it.add_child(shape)

	var vis := ColorRect.new()
	vis.size = size
	vis.position = -size * 0.5
	vis.color = tint
	it.add_child(vis)

	it.interacted.connect(_on_interacted)
	_player.register(it)


func _on_interacted(node_id: StringName) -> void:
	DialogueRunner.start(_dialogue, node_id)


func _on_dialogue_finished() -> void:
	# Osk's severance is scheduled by the story, not by the player: it happens
	# mid-sentence, after they have spent enough time with him to like him.
	if GameState.has_flag(&"met_osk") and GameState.has_flag(&"heard_osk_mornings") \
			and not GameState.has_flag(&"osk_severed"):
		await get_tree().create_timer(0.8).timeout
		DialogueRunner.start(_dialogue, &"osk_the_sentence")


func _on_cue(cue: String) -> void:
	match cue:
		"sever.world":
			_sever()
		"tether.grant_marren":
			pass


## The severance sound is a silence, not a sound: 36 frames of total audio duck,
## ambience included. Used exactly 19 times in the whole game. This is the first.
func _sever() -> void:
	_post_severance = true
	_duck_timer = 0.6
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	EventBus.severance_occurred.emit(&"osk")
	GameState.set_flag(&"osk_severed")

	# The region does not darken and no music stings. Nothing announces it. The only
	# change is that the lamps stop being tended, and that takes a while to notice.
	var tween := create_tween()
	tween.tween_property(_dread_overlay, "color", Color(0, 0, 0.04, 0.22), 8.0)


func _process(delta: float) -> void:
	if _duck_timer > 0.0:
		_duck_timer -= delta
		if _duck_timer <= 0.0:
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	_update_hud()


func _build_hud() -> void:
	_hud = Label.new()
	_hud.position = Vector2(8, 6)
	_hud.add_theme_font_size_override("font_size", 8)
	_hud.add_theme_color_override("font_color", Color(0.62, 0.66, 0.78))
	_hud.visible = false
	var layer := CanvasLayer.new()
	layer.layer = 5
	layer.add_child(_hud)
	add_child(layer)


func _update_hud() -> void:
	if not _hud.visible:
		return
	var objective := "Find someone who can tell you what you are."
	if GameState.has_flag(&"osk_severed"):
		objective = "Walk the unclaimed heart to the Registry at Wyndmarrow."
	elif GameState.has_flag(&"met_osk"):
		objective = "Talk to Ledgerman Osk."
	_hud.text = "THE UNCLAIMED   ·   %s\nWASD move   E interact   Enter advance" % objective


## A soft radial gradient for the lamps, generated rather than imported so the
## prototype has no asset dependencies at all.
func _radial_texture() -> GradientTexture2D:
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(1, 1, 1, 0))
	var t := GradientTexture2D.new()
	t.gradient = g
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1.0, 0.5)
	t.width = 128
	t.height = 128
	return t
