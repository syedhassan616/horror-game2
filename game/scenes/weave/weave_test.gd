extends Node2D
## Playable harness for the Tether — the month-1 prototype that decides whether the
## rest of the project is worth building (Risk R1, GDD 17.4).
##
## The go/no-go question this scene exists to answer: is the tether fun for
## thirty minutes? If not, the project pivots or stops. It is deliberately built
## before any art, writing, or region content.
##
## Controls: WASD move · Space SWAP · Ctrl PULL · Alt PLANT · 1-5 swap companion
##           R reset · S trigger the Slack Tether set piece

const COMPANIONS := [&"tilly", &"moth", &"barro", &"sennet", &"rue"]

var weave: WeaveController
var _pattern: PatternPlayer
var _hud: Label
var _companion_index: int = 0
var _elapsed: float = 0.0


func _ready() -> void:
	weave = WeaveController.new()
	weave.starting_hp = 20
	add_child(weave)

	_pattern = PatternPlayer.new(weave.pool, 1441)   # Merit's reserved entry number

	_hud = Label.new()
	_hud.position = Vector2(6, 190)
	_hud.add_theme_font_size_override("font_size", 8)
	add_child(_hud)

	weave.enter_weave(999999)
	_start_pattern()

	EventBus.tether_snapped.connect(func(): print("SNAP"))
	EventBus.companion_severed.connect(
		func(id): print("severed: %s — HUD reads — NOBODY —" % id))


func _start_pattern() -> void:
	# A demonstration set, not authored content: a ring, an aimed arc at the Ward,
	# and a walking gap in a line. Enough to feel whether sweeping the tether
	# through fire is satisfying.
	var steps := [
		{"emitter": PatternPlayer.Emitter.RING, "count": 14, "speed": 42.0,
		 "origin": Vector2(160, 20), "delay_frames": 48,
		 "bullet_type": BulletPool.Type.PELLET},
		{"emitter": PatternPlayer.Emitter.AIMED, "count": 5, "spread_deg": 34.0,
		 "speed": 70.0, "origin": Vector2(160, 20), "aim_at": &"ward",
		 "delay_frames": 42, "bullet_type": BulletPool.Type.BOLT},
		{"emitter": PatternPlayer.Emitter.LINE, "count": 12, "speed": 38.0,
		 "line_from": Vector2(8, 8), "line_to": Vector2(312, 8),
		 "line_dir": Vector2.DOWN, "gap_index": 5, "delay_frames": 54,
		 "bullet_type": BulletPool.Type.PELLET},
		{"emitter": PatternPlayer.Emitter.SPIRAL, "count": 6, "speed": 52.0,
		 "origin": Vector2(160, 20), "spiral_step_deg": 13.0, "delay_frames": 12,
		 "bullet_type": BulletPool.Type.CURL, "curl_deg_per_sec": 24.0},
	]
	_pattern.play(steps, Vector2(160, 20), _aim_target, true)


func _aim_target(which: StringName) -> Vector2:
	return weave.ward_position() if which == &"ward" else weave.self_position()


func _physics_process(delta: float) -> void:
	_elapsed += delta
	_pattern.tick(delta)
	_update_hud()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_R:
			weave.pool.clear()
			weave.tether.reset()
			_pattern.play([], Vector2.ZERO, _aim_target)
			_start_pattern()
		KEY_S:
			weave.sever_companion()
		KEY_1, KEY_2, KEY_3, KEY_4, KEY_5:
			_companion_index = event.keycode - KEY_1
			weave.set_companion(_profile(_companion_index))


func _profile(i: int) -> CompanionProfile:
	match COMPANIONS[i]:
		&"tilly": return CompanionProfile.tilly()
		&"moth": return CompanionProfile.moth()
		&"barro": return CompanionProfile.barro()
		&"sennet": return CompanionProfile.sennet()
		_: return CompanionProfile.rue()


func _update_hud() -> void:
	var t := weave.tether
	var state_names := ["SLACK", "LIVE", "TAUT", "STRAINED", "SNAPPED"]
	_hud.text = "%s   insight %3d/100   strain %3d/100   bullets %d   fps %d\n%s" % [
		state_names[t.state],
		int(t.insight),
		int(t.strain),
		weave.pool.live_count(),
		Engine.get_frames_per_second(),
		"companion: %s   [1-5 swap  S sever  R reset]" % COMPANIONS[_companion_index],
	]
