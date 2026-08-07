class_name WardBody
extends Node2D
## The companion's glyph — the far end of the tether.
##
## Behaviour is injected from a CompanionProfile, so a companion is a data file
## plus art, not an engine change. This is what makes route-exclusive companions
## affordable (Architecture, 10.4).

enum Mode { SPRING, ROD, GHOST, THREAD, CURRENT, SIGNAL }

const REST_LENGTH := 24.0
const STIFFNESS := 14.0
const DAMPING := 0.55
## The spring is unstable at k=14 on a single 60Hz Euler step — ROD mode oscillates
## visibly. Two substeps at fixed h=1/120 fixes it. Correctness, not polish.
const SUBSTEPS := 2

var mode: Mode = Mode.SPRING
var mass_multiplier: float = 1.0
var collision_enabled: bool = true

var hp: int = 20
var slacked: bool = false

var _velocity := Vector2.ZERO
var _planted: bool = false
var _plant_frames: int = 0
var _slack_frames: int = 0
var _bounds: Rect2

const PLANT_MAX_FRAMES := 180      # 3s; 300 with the Deadweight node
const SLACK_DURATION := 480        # 8s


func setup(arena_bounds: Rect2, profile: CompanionProfile) -> void:
	_bounds = arena_bounds
	mode = profile.tether_mode as Mode
	mass_multiplier = profile.mass_multiplier
	collision_enabled = profile.collision_enabled
	hp = profile.ward_hp


func tick(delta: float, self_pos: Vector2, max_length: float) -> void:
	if _slack_frames > 0:
		_slack_frames -= 1
		if _slack_frames == 0:
			slacked = false

	if _planted:
		_plant_frames += 1
		if _plant_frames >= PLANT_MAX_FRAMES:
			unplant()
		return

	var h := delta / float(SUBSTEPS)
	for _i in SUBSTEPS:
		_integrate_spring(h, self_pos, max_length)

	position = position.clamp(_bounds.position, _bounds.end)


func _integrate_spring(h: float, self_pos: Vector2, max_length: float) -> void:
	var to_self := self_pos - position
	var dist := to_self.length()
	if dist < 0.001:
		return
	var dir := to_self / dist

	# ROD (Tilly's ANCHOR) is a rigid constraint, not a spring: it does not overshoot
	# and it drags. That is what makes her both the beginner's companion and the
	# expert's puzzle.
	if mode == Mode.ROD:
		if dist > max_length:
			position = self_pos - dir * max_length
			_velocity = Vector2.ZERO
		return

	var stretch := dist - REST_LENGTH
	var mass := mass_multiplier
	var force := dir * (STIFFNESS * stretch) - _velocity * (DAMPING * STIFFNESS)
	_velocity += (force / mass) * h
	position += _velocity * h

	# Hard clamp at max length regardless of mode — the tether is a length, not a
	# suggestion, and TAUT must mean something exact.
	var d2 := position.distance_to(self_pos)
	if d2 > max_length:
		position = self_pos - (self_pos - position).normalized() * max_length


func plant() -> bool:
	if _planted or slacked:
		return false
	_planted = true
	_plant_frames = 0
	_velocity = Vector2.ZERO
	return true


func unplant() -> void:
	_planted = false
	_plant_frames = 0


func is_planted() -> bool:
	return _planted


## Snap to Self (the PULL verb). Collapses the tether: used to escape TAUT,
## reposition, or reset before a pattern lands.
func pull_to(self_pos: Vector2) -> void:
	position = self_pos
	_velocity = Vector2.ZERO


func take_damage(amount: int) -> void:
	if slacked:
		return
	hp = maxi(0, hp - amount)
	if hp == 0:
		go_slack()


## A Ward at 0 HP does not die. It goes slack for 8 seconds. Companions are people;
## the game never kills one as a combat outcome.
func go_slack() -> void:
	slacked = true
	_slack_frames = SLACK_DURATION
	_planted = false
	EventBus.ward_slacked.emit()
