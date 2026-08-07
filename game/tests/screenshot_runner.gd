extends Node
## Captures real frames of the Prologue to disk.
##
## Run under a virtual display:
##   xvfb-run -a godot --path game res://tests/screenshot_scene.tscn
##
## Exists so the scene can be reviewed by someone who has not installed the engine.
## It drives the Prologue's dialogue the way a player would and grabs the viewport
## at the moments that matter — including the severance, which is the one beat that
## has to be seen rather than described.

const OUT_DIR := "user://shots"
const SRC := "res://data/dialogue/src/prologue.sh"

var _res: DialogueResource
var _shot := 0
var _prologue: Node2D


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(OUT_DIR)
	var parser := DialogueParser.new()
	_res = parser.parse_file(SRC)

	_prologue = load("res://scenes/regions/unc/prologue.tscn").instantiate()
	add_child(_prologue)

	# The dialogue box lives inside the Prologue scene, so it is already listening.
	await get_tree().create_timer(1.6).timeout
	await _capture("01-the-aisle")

	# Aven's own drawer: RESERVED, dated nine hundred years before they were born.
	DialogueRunner.start(_res, &"drawer_reserved")
	await get_tree().create_timer(0.9).timeout
	await _capture("02-the-reserved-drawer")
	await _drain()

	# Osk, mid-work, delighted to have found a filing error that is a person.
	DialogueRunner.start(_res, &"osk_first")
	await get_tree().create_timer(0.9).timeout
	await _capture("03-osk")
	await _drain_to_choice()
	await _capture("04-tone-choices")
	DialogueRunner.advance(0)
	await _drain()

	# The mornings line lives behind a choice: three lines, then the player has to
	# actually ask. Walk to the choice, pick BLUNT, then step to the second line of
	# osk_why_not — that is the sentence the Commonplace puzzle asks about.
	DialogueRunner.start(_res, &"osk_marren")
	await _advance_lines(3)
	DialogueRunner.advance(1)                      # BLUNT — "Why not have it taken out?"
	await get_tree().create_timer(0.8).timeout
	DialogueRunner.advance()
	await get_tree().create_timer(1.4).timeout     # let the typewriter finish
	await _capture("05-the-mornings-line")
	await _drain()

	# S-006. The audio ducks completely, his posture improves, and he finishes the
	# sentence. Nothing else changes.
	DialogueRunner.start(_res, &"osk_the_sentence")
	await get_tree().create_timer(1.6).timeout
	await _capture("06-mid-sentence")
	DialogueRunner.advance()                       # -> the cue fires, then he resumes
	await get_tree().create_timer(1.8).timeout
	await _capture("07-after-the-severance")

	print("wrote %d frames to %s" % [_shot, ProjectSettings.globalize_path(OUT_DIR)])
	get_tree().quit(0)


func _advance_lines(n: int) -> void:
	for _i in n:
		await get_tree().create_timer(1.5).timeout
		DialogueRunner.advance()
	await get_tree().create_timer(0.7).timeout


func _drain() -> void:
	var guard := 0
	while DialogueRunner.is_running and guard < 40:
		guard += 1
		DialogueRunner.advance()
		await get_tree().process_frame
	await get_tree().process_frame


func _drain_to_choice() -> void:
	var guard := 0
	while DialogueRunner.is_running and guard < 40:
		guard += 1
		await get_tree().create_timer(0.35).timeout
		DialogueRunner.advance()
		if _has_visible_choices():
			return


func _has_visible_choices() -> bool:
	var box := _prologue.get_node_or_null("DialogueBox")
	if box == null:
		return false
	var choices := box.get_node_or_null("Panel/Choices")
	return choices != null and choices.get_child_count() > 0


func _capture(label: String) -> void:
	# Two frames, so the typewriter and any tween have actually drawn.
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	_shot += 1
	var path := "%s/%02d-%s.png" % [OUT_DIR, _shot, label]
	img.save_png(path)
	print("  captured %s" % path)
