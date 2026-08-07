class_name Interactable
extends Area2D
## Anything the player can press E on.
##
## No floating markers, no exclamation points (Art Bible §9.0.7 rule 4) — an
## interactable is readable because it is lit and animated. In the prototype,
## which has no art, it pulses instead. The accessibility high-contrast toggle is
## what adds outlines, not the default presentation.

@export var dialogue_node: StringName = &""
## Optional: a different node once this flag is set. How NPCs remember.
@export var repeat_node: StringName = &""
@export var require_flag: StringName = &""
@export var label: String = ""

signal interacted(node_id: StringName)

var _player_inside: bool = false
var _used: bool = false


func _ready() -> void:
	body_entered.connect(func(_b): _player_inside = true)
	body_exited.connect(func(_b): _player_inside = false)
	if get_node_or_null("Shape") == null:
		var s := CollisionShape2D.new()
		var r := RectangleShape2D.new()
		r.size = Vector2(20, 20)
		s.shape = r
		s.name = "Shape"
		add_child(s)


func can_interact() -> bool:
	if not _player_inside:
		return false
	if require_flag != &"" and not GameState.has_flag(require_flag):
		return false
	return true


func interact() -> StringName:
	if not can_interact():
		return &""
	var node := dialogue_node
	if _used and repeat_node != &"":
		node = repeat_node
	_used = true
	interacted.emit(node)
	return node


func is_player_inside() -> bool:
	return _player_inside
