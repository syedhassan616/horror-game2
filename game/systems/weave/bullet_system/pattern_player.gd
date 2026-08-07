class_name PatternPlayer
extends RefCounted
## Interprets PatternResource into bullets. Patterns are data, never scripts —
## this is what makes 84 enemies plus 17 bosses affordable.
##
## Runs on a seeded RNG per encounter so any death is reproducible from a save plus
## an input log. That is how "unfair deaths" get debugged rather than argued about.

## Emitters. Six shapes cover the entire game's vocabulary.
enum Emitter { POINT, ARC, RING, LINE, SPIRAL, AIMED }

## Absolute floor. No difficulty, boss, or phase may spawn a lethal projectile with
## fewer visible tell frames than this. Violations are logged P1 by the Unfair Death
## tool, not filed as balance feedback.
const MIN_TELEGRAPH_FRAMES := 12

var rng := RandomNumberGenerator.new()

var _pool: BulletPool
var _steps: Array = []
var _step_index: int = 0
var _frames_until_next: int = 0
var _looping: bool = false
var _origin := Vector2.ZERO
var _target_provider: Callable
var _speed_scale: float = 1.0
var _spiral_offset: float = 0.0
var _active: bool = false


func _init(pool: BulletPool, seed_value: int = 0) -> void:
	_pool = pool
	rng.seed = seed_value


func play(steps: Array, origin: Vector2, target_provider: Callable,
		looping: bool = false, speed_scale: float = 1.0) -> void:
	_steps = steps
	_step_index = 0
	_frames_until_next = 0
	_origin = origin
	_target_provider = target_provider
	_looping = looping
	_speed_scale = speed_scale
	_spiral_offset = 0.0
	_active = not steps.is_empty()


func stop() -> void:
	_active = false


func is_active() -> bool:
	return _active


func tick(_delta: float) -> void:
	if not _active:
		return
	if _frames_until_next > 0:
		_frames_until_next -= 1
		return

	while _active and _frames_until_next <= 0:
		if _step_index >= _steps.size():
			if _looping:
				_step_index = 0
			else:
				_active = false
				return
		var step: Dictionary = _steps[_step_index]
		_emit(step)
		_frames_until_next = int(step.get("delay_frames", 30))
		_step_index += 1


func _emit(step: Dictionary) -> void:
	var emitter: int = step.get("emitter", Emitter.POINT)
	var count: int = step.get("count", 1)
	var spread: float = deg_to_rad(step.get("spread_deg", 0.0))
	var speed: float = step.get("speed", 60.0) * _speed_scale
	var accel: float = step.get("accel", 0.0)
	var curl: float = step.get("curl_deg_per_sec", 0.0)
	var t: int = step.get("bullet_type", BulletPool.Type.PELLET)
	var origin: Vector2 = step.get("origin", _origin)

	match emitter:
		Emitter.POINT:
			_pool.spawn(origin, Vector2.RIGHT.rotated(step.get("angle", 0.0)) * speed,
				t, accel, curl)

		Emitter.RING:
			for i in count:
				var a := TAU * float(i) / float(count)
				_pool.spawn(origin, Vector2.RIGHT.rotated(a) * speed, t, accel, curl)

		Emitter.ARC:
			var base: float = step.get("angle", 0.0)
			for i in count:
				var frac := 0.5 if count == 1 else float(i) / float(count - 1)
				var a: float = base - spread * 0.5 + spread * frac
				_pool.spawn(origin, Vector2.RIGHT.rotated(a) * speed, t, accel, curl)

		Emitter.LINE:
			var from: Vector2 = step.get("line_from", origin)
			var to: Vector2 = step.get("line_to", origin + Vector2(320, 0))
			var dir: Vector2 = step.get("line_dir", Vector2.DOWN)
			# One gap that moves one slot per volley — the player reads a sequence,
			# not a moment.
			var gap: int = step.get("gap_index", -1)
			for i in count:
				if i == gap:
					continue
				var frac := 0.0 if count == 1 else float(i) / float(count - 1)
				_pool.spawn(from.lerp(to, frac), dir.normalized() * speed, t, accel, curl)

		Emitter.SPIRAL:
			for i in count:
				var a := _spiral_offset + TAU * float(i) / float(count)
				_pool.spawn(origin, Vector2.RIGHT.rotated(a) * speed, t, accel, curl)
			_spiral_offset += deg_to_rad(step.get("spiral_step_deg", 11.0))

		Emitter.AIMED:
			# Aiming at the Ward rather than Self is the game's signature threat:
			# most players instinctively protect Self and have to be taught that the
			# Ward is a person.
			var target: Vector2 = origin + Vector2.DOWN * 100.0
			if _target_provider.is_valid():
				target = _target_provider.call(step.get("aim_at", &"self"))
			var to_target := (target - origin).normalized()
			for i in count:
				var frac := 0.5 if count == 1 else float(i) / float(count - 1)
				var a := to_target.angle() - spread * 0.5 + spread * frac
				_pool.spawn(origin, Vector2.RIGHT.rotated(a) * speed, t, accel, curl)
