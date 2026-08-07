class_name OverworldPlayer
extends CharacterBody2D
## Aven, walking around. Deliberately simple: this is not where the game lives.
##
## Movement locks while dialogue is running. The player should never be able to
## walk out of the middle of a sentence — not because it would break anything, but
## because scenes in this game are meant to be sat in.

const SPEED := 56.0
const RUN_SPEED := 96.0
const ACCEL := 900.0
const FRICTION := 1200.0

var facing := Vector2.DOWN
var _nearby: Array[Interactable] = []


func _ready() -> void:
	if get_node_or_null("Shape") == null:
		var s := CollisionShape2D.new()
		var r := RectangleShape2D.new()
		r.size = Vector2(8, 8)
		s.shape = r
		s.name = "Shape"
		add_child(s)


func _physics_process(delta: float) -> void:
	if DialogueRunner.is_running:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_slide()
		return

	var dir := Vector2(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_up", &"move_down")
	).normalized()

	var speed := RUN_SPEED if Input.is_action_pressed(&"weave_run") else SPEED
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir * speed, ACCEL * delta)
		facing = dir
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if DialogueRunner.is_running:
		return
	if not event.is_action_pressed(&"interact"):
		return
	var target := _closest_interactable()
	if target != null:
		var node := target.interact()
		if node != &"":
			get_viewport().set_input_as_handled()


func register(i: Interactable) -> void:
	if i not in _nearby:
		_nearby.append(i)


func _closest_interactable() -> Interactable:
	var best: Interactable = null
	var best_d := INF
	for i in _nearby:
		if not i.can_interact():
			continue
		var d := global_position.distance_to(i.global_position)
		if d < best_d:
			best_d = d
			best = i
	return best


func _draw() -> void:
	# Placeholder art. Aven is the only warm thing on screen, which is accidentally
	# correct — in the Assay it is literally the rule.
	draw_rect(Rect2(-4, -6, 8, 12), Color(0.98, 0.85, 0.62))
	draw_rect(Rect2(-4, -6, 8, 12), Color(0.25, 0.2, 0.16), false, 1.0)
	# Facing pip, so the player can tell which way they are pointed.
	draw_circle(facing.normalized() * 7.0, 1.5, Color(0.98, 0.85, 0.62, 0.8))
