class_name SelfBody
extends Node2D
## The player's glyph. 4px collision core, honestly displayed.
##
## Frame data is authored in frames, not seconds (Combat Systems 5.0.3), because
## a dodge that is "about 0.1 seconds" is a dodge nobody can learn.

const CORE_RADIUS := 2.0          # 4x4 hitbox
const SPEED := 84.0
const RUN_SPEED := 168.0

## SWAP: the game's signature input. Input to first visible response must be <= 2
## frames, always. QA measures this every build; a regression is a P1 defect.
const SWAP_STARTUP := 1
const SWAP_IFRAMES := 6
const SWAP_COOLDOWN := 54

const PULL_COOLDOWN := 72
const INPUT_BUFFER := 6           # frames; 12 in accessibility

var hp: int = 20
var max_hp: int = 20
var invulnerable: bool = false

var _iframes_left: int = 0
var _swap_cd: int = 0
var _pull_cd: int = 0
## Buffered verb, consumed on the first frame it becomes legal.
var _buffered: StringName = &""
var _buffer_age: int = 0

var _velocity := Vector2.ZERO
var _bounds: Rect2


func setup(arena_bounds: Rect2, starting_hp: int) -> void:
	_bounds = arena_bounds
	max_hp = starting_hp
	hp = starting_hp


func tick(delta: float, input_dir: Vector2, running: bool) -> void:
	if _swap_cd > 0:
		_swap_cd -= 1
	if _pull_cd > 0:
		_pull_cd -= 1
	if _iframes_left > 0:
		_iframes_left -= 1
		invulnerable = _iframes_left > 0
	if _buffer_age > 0:
		_buffer_age -= 1
		if _buffer_age == 0:
			_buffered = &""

	var speed := RUN_SPEED if running else SPEED
	_velocity = input_dir.normalized() * speed
	position += _velocity * delta
	position = position.clamp(_bounds.position, _bounds.end)


## Queue a verb. Buffered for INPUT_BUFFER frames so a press one frame early
## still lands — the difference between "tight" and "unfair".
func buffer(verb: StringName) -> void:
	_buffered = verb
	_buffer_age = INPUT_BUFFER


func consume_buffer(verb: StringName) -> bool:
	if _buffered == verb:
		_buffered = &""
		_buffer_age = 0
		return true
	return false


func can_swap() -> bool:
	return _swap_cd <= 0


func can_pull() -> bool:
	return _pull_cd <= 0


## Exchange positions with the Ward. Grants i-frames, which are rendered as a hard
## white flash for exactly their duration: the player must always know whether the
## dodge landed. No ambiguity, ever.
func perform_swap(ward: Node2D, through_fire: bool) -> void:
	var tmp := position
	position = ward.position
	ward.position = tmp
	_swap_cd = SWAP_COOLDOWN
	_iframes_left = SWAP_IFRAMES
	invulnerable = true
	EventBus.swap_performed.emit(through_fire)


func start_pull_cooldown() -> void:
	_pull_cd = PULL_COOLDOWN


func take_damage(raw: int, defence: float) -> void:
	if invulnerable:
		return
	# Nothing is ever fully negated. A 60-HP Aven still dies in five hits at the end
	# of the game, which is the same number as at the start.
	var amount := maxi(1, int(floor(raw * (1.0 - minf(0.60, defence)))))
	hp = maxi(0, hp - amount)
	EventBus.self_damaged.emit(amount, hp)
	if hp == 0:
		EventBus.self_died.emit()


func heal(amount: int) -> void:
	hp = mini(max_hp, hp + amount)


func revive_for_retry() -> void:
	# Death returns the player to the Command Phase of the same encounter at 40% HP.
	# No progress is ever lost; difficulty comes from encounters, never re-traversal.
	hp = maxi(1, int(round(max_hp * 0.4)))
	_iframes_left = 0
	invulnerable = false
	_swap_cd = 0
	_pull_cd = 0
