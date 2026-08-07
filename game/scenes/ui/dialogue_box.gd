extends CanvasLayer
## Renders whatever DialogueRunner is saying. Owns *how*, never *what*.
##
## Everything is paper (Art Bible §9.0.7): the box is a filed card, confirm is a
## stamp. No portraits yet — those are Stage 9 art — so the speaker is a name plate.

const CHARS_PER_SEC := 45.0
const BEAT_SECONDS := 0.7

@onready var _panel: ColorRect = $Panel
@onready var _name: Label = $Panel/Name
@onready var _text: Label = $Panel/Text
@onready var _prompt: Label = $Panel/Prompt
@onready var _choices: VBoxContainer = $Panel/Choices

var _full_text: String = ""
var _revealed: float = 0.0
var _typing: bool = false
var _awaiting_choice: bool = false
var _beat_timer: float = 0.0


func _ready() -> void:
	visible = false
	DialogueRunner.line_shown.connect(_on_line)
	DialogueRunner.choices_offered.connect(_on_choices)
	DialogueRunner.beat.connect(_on_beat)
	DialogueRunner.finished.connect(_on_finished)


func _on_line(speaker: String, expression: String, text: String, interrupt: bool) -> void:
	visible = true
	_clear_choices()
	_awaiting_choice = false

	var plate := speaker
	if expression != "":
		plate = "%s  (%s)" % [speaker, expression]
	# An interrupt barges in; the previous speaker's line stays truncated behind it.
	if interrupt:
		plate = "— " + plate
	_name.text = plate

	_full_text = text
	_revealed = 0.0
	_typing = true
	_text.text = ""
	_prompt.visible = false


func _on_beat() -> void:
	visible = true
	_clear_choices()
	_name.text = ""
	_text.text = ""
	_prompt.visible = false
	_typing = false
	_beat_timer = BEAT_SECONDS


func _on_choices(options: Array) -> void:
	visible = true
	_typing = false
	_text.text = _full_text
	_prompt.visible = false
	_awaiting_choice = true
	_clear_choices()

	for i in options.size():
		var opt: Dictionary = options[i]
		var b := Button.new()
		b.text = "%s  %s" % [opt.get("tone", "").rpad(8), opt.get("label", "")]
		b.add_theme_font_size_override("font_size", 8)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.focus_mode = Control.FOCUS_ALL
		b.pressed.connect(_on_choice_pressed.bind(i))
		_choices.add_child(b)
	if _choices.get_child_count() > 0:
		_choices.get_child(0).grab_focus()


func _on_choice_pressed(i: int) -> void:
	_awaiting_choice = false
	_clear_choices()
	DialogueRunner.advance(i)


func _on_finished() -> void:
	visible = false
	_clear_choices()


func _clear_choices() -> void:
	for c in _choices.get_children():
		c.queue_free()


func _process(delta: float) -> void:
	if _beat_timer > 0.0:
		_beat_timer -= delta
		if _beat_timer <= 0.0:
			DialogueRunner.advance()
		return

	if _typing:
		_revealed += CHARS_PER_SEC * delta
		var n := int(_revealed)
		if n >= _full_text.length():
			_text.text = _full_text
			_typing = false
			_prompt.visible = true
		else:
			_text.text = _full_text.substr(0, n)


func _unhandled_input(event: InputEvent) -> void:
	if not visible or _awaiting_choice:
		return
	if event.is_action_pressed(&"interact") or (event is InputEventKey
			and event.pressed and not event.echo and event.keycode == KEY_ENTER):
		if _typing:
			# First press completes the line rather than skipping it — never punish
			# a player for reading faster than the typewriter.
			_revealed = _full_text.length()
			_text.text = _full_text
			_typing = false
			_prompt.visible = true
		else:
			DialogueRunner.advance()
		get_viewport().set_input_as_handled()
