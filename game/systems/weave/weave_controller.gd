class_name WeaveController
extends Node2D
## The encounter state machine: COMMAND (paused, menu) <-> WEAVE (real-time, 60fps).
##
## Most games make the dodge phase a tax you pay between decisions. Here it is where
## you earn the currency for your best decisions: a conservative dodger can only
## afford violence; a greedy one can afford peace. The morality is priced in risk.

enum Phase { COMMAND, WEAVE, RESOLVING }

const ARENA := Rect2(0, 0, 320, 180)
const TETHER_READ_RADIUS := Tether.SAMPLE_RADIUS

@export var starting_hp: int = 20

var phase: Phase = Phase.COMMAND
var tether: Tether
var pool: BulletPool
var broadphase: Broadphase

var _self: SelfBody
var _ward: WardBody
var _companion: CompanionProfile
var _weave_frames_left: int = 0
var _defence: float = 0.0
var _difficulty_bullet_speed: float = 1.0


func _ready() -> void:
	pool = BulletPool.new(ARENA)
	broadphase = Broadphase.new(pool)
	tether = Tether.new()

	_self = SelfBody.new()
	_self.setup(ARENA, starting_hp)
	_self.position = ARENA.get_center() + Vector2(0, 40)
	add_child(_self)

	_ward = WardBody.new()
	add_child(_ward)

	set_companion(CompanionProfile.tilly())
	tether.set_self_radius(SelfBody.CORE_RADIUS)

	EventBus.self_died.connect(_on_self_died)


## Accessors for the two bodies. Systems outside the Weave read positions through
## these rather than walking the child list, so node order stays an implementation
## detail.
func self_position() -> Vector2:
	return _self.position


func ward_position() -> Vector2:
	return _ward.position


func self_body() -> SelfBody:
	return _self


func ward_body() -> WardBody:
	return _ward


func set_companion(profile: CompanionProfile) -> void:
	_companion = profile
	_ward.setup(ARENA, profile)
	_ward.position = _self.position - Vector2(0, WardBody.REST_LENGTH)
	tether.insight_multiplier = profile.insight_multiplier
	tether.strain_resist = profile.strain_resist


## The Slack Tether set piece: a companion is removed mid-fight, without a cutscene,
## and the fight does not pause. The HUD reads "— NOBODY —". Survivable; kills most
## players once. That death is the scene.
func sever_companion() -> void:
	if _companion == null:
		return
	var id := _companion.id
	EventBus.companion_severed.emit(id)
	EventBus.stem_muted_permanently.emit(_companion.motif_stem)

	_companion = null
	tether.insight_multiplier = 0.0
	tether.strain_resist = 0.0
	_ward.go_slack()


func enter_weave(duration_frames: int) -> void:
	phase = Phase.WEAVE
	_weave_frames_left = duration_frames


func enter_command() -> void:
	phase = Phase.COMMAND
	pool.clear()


func _physics_process(delta: float) -> void:
	if phase != Phase.WEAVE:
		return

	_tick_input(delta)

	# The hot loop. Order matters: integrate, then index, then query the same set.
	pool.integrate(delta)
	broadphase.rebuild()

	tether.update_geometry(_self.position, _ward.position, delta)

	var hit := broadphase.query_point(_self.position, SelfBody.CORE_RADIUS)
	if hit >= 0 and not _self.invulnerable:
		_self.take_damage(pool.damage(hit), _defence)
		pool.despawn(hit)

	if _companion != null and _companion.collision_enabled and not _ward.slacked:
		var ward_hit := broadphase.query_point(_ward.position, 4.0)
		if ward_hit >= 0:
			_ward.take_damage(pool.damage(ward_hit))
			pool.despawn(ward_hit)

	var reads := broadphase.query_polyline(tether.samples(), TETHER_READ_RADIUS)
	tether.accrue(pool, reads, delta)

	if tether.state == Tether.State.SNAPPED and tether.strain >= Tether.STRAIN_MAX:
		_self.take_damage(Tether.SNAP_DAMAGE, _defence)
		_ward.take_damage(Tether.SNAP_DAMAGE)

	pool.cull_offscreen()
	queue_redraw()

	_weave_frames_left -= 1
	if _weave_frames_left <= 0:
		enter_command()


func _tick_input(delta: float) -> void:
	var dir := Vector2(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_up", &"move_down")
	)
	var running := Input.is_action_pressed(&"weave_pull") == false and Input.is_key_pressed(KEY_SHIFT)

	if Input.is_action_just_pressed(&"weave_swap"):
		_self.buffer(&"swap")
	if Input.is_action_just_pressed(&"weave_pull"):
		_self.buffer(&"pull")

	# Buffered verbs are only consumed on a frame where they are legal, so a press
	# one frame early still lands. Consuming on an illegal frame would eat the input
	# and make the buffer worse than none.
	if _self.can_swap() and _self.consume_buffer(&"swap"):
		# "Through fire" drives the tutorial prompt and achievement #22 — it is how
		# the game notices the player has understood that SWAP is a dodge *through*
		# danger, not an escape from it.
		var through := broadphase.query_point(
			_self.position.lerp(_ward.position, 0.5), 8.0) >= 0
		_self.perform_swap(_ward, through)

	if _self.can_pull() and _self.consume_buffer(&"pull"):
		_ward.pull_to(_self.position)
		_self.start_pull_cooldown()

	if Input.is_action_pressed(&"weave_plant"):
		_ward.plant()
	elif _ward.is_planted():
		_ward.unplant()

	_self.tick(delta, dir, running)
	if not _ward.is_planted():
		_ward.tick(delta, _self.position, tether.max_length)


func _on_self_died() -> void:
	phase = Phase.RESOLVING
	pool.clear()
	# No game-over screen. Return to the Command Phase of this encounter with a
	# companion-specific line: your companion catching you.
	_self.revive_for_retry()
	enter_command()


func _draw() -> void:
	if phase != Phase.WEAVE:
		return

	# Tether: the brightest object in any arena, including the Assay.
	var tint := _tether_colour()
	draw_line(_self.position, _ward.position, tint, 1.5)

	# Insight fills from Self outward along the line.
	if tether.insight > 0.0:
		var t: float = tether.insight / Tether.INSIGHT_MAX
		draw_line(_self.position, _self.position.lerp(_ward.position, t),
			Color(1.0, 0.84, 0.4), 2.0)

	# Strain: a thin red thread inside the base line. Never a HUD bar — the player
	# reads their own risk by looking at the thing they are already looking at.
	if tether.strain > 0.0:
		var s: float = tether.strain / Tether.STRAIN_MAX
		draw_line(_self.position, _self.position.lerp(_ward.position, s),
			Color(0.9, 0.2, 0.2, 0.8), 0.5)

	# F02: a second, fainter line in a colour no companion produces. Present in every
	# fight from the tutorial onward. Never mentioned. It is Merit's.
	draw_line(_self.position, _ward.position, Color(0.55, 0.42, 0.75, 0.22), 0.75)

	# Bullets.
	for i in pool.high_water:
		if pool.alive[i] == 0:
			continue
		draw_circle(pool.position_of(i), 2.0, Color(0.95, 0.95, 0.92))

	# Self's core IS the hitbox, always honestly displayed.
	var core := Color(1, 1, 1) if _self.invulnerable else Color(1.0, 0.9, 0.6)
	draw_circle(_self.position, SelfBody.CORE_RADIUS, core)
	draw_circle(_ward.position, 4.0, Color(0.7, 0.85, 1.0, 0.9 if not _ward.slacked else 0.25))


func _tether_colour() -> Color:
	match tether.state:
		Tether.State.SLACK: return Color(0.4, 0.45, 0.5, 0.5)
		Tether.State.TAUT: return Color(1.0, 0.95, 0.7)
		Tether.State.STRAINED: return Color(0.9, 0.35, 0.3)
		Tether.State.SNAPPED: return Color(0.3, 0.1, 0.1, 0.3)
		_: return Color(0.85, 0.88, 0.9)
