extends Node
## Headless test runner. Deliberately dependency-free.
##
## Run:  godot --headless --path game res://tests/test_scene.tscn
##
## It runs as a *scene*, not via --script, because Tether and UnknotSystem reference
## the EventBus and GameState autoloads. In --script mode Godot does not instantiate
## autoloads, so those classes fail to compile and every test against them silently
## reports "nonexistent function 'new'". Running as a scene is the only mode that
## exercises the code the way the game actually does.
##
## GUT is the eventual home for these (Architecture 10.10), but the tether's economy
## is the highest-risk thing in the project and needs tests that run on a bare engine
## from day one, with no addon to install first.

var _passed: int = 0
var _failed: int = 0


func _ready() -> void:
	print("SECONDHEART — test run\n")

	var suites: Array = [
		TetherTests.new(),
		BulletPoolTests.new(),
		BroadphaseTests.new(),
		GameStateTests.new(),
		UnknotTests.new(),
	]

	for suite in suites:
		suite.runner = self
		print("── %s" % suite.suite_name())
		suite.run()
		print("")

	print("──────────────────────────────")
	print("%d passed, %d failed" % [_passed, _failed])
	get_tree().quit(1 if _failed > 0 else 0)


func check(condition: bool, label: String) -> void:
	if condition:
		_passed += 1
		print("   ok   %s" % label)
	else:
		_failed += 1
		print("   FAIL %s" % label)


func check_eq(a: Variant, b: Variant, label: String) -> void:
	check(a == b, "%s  (got %s, want %s)" % [label, a, b])


func check_near(a: float, b: float, tol: float, label: String) -> void:
	check(absf(a - b) <= tol, "%s  (got %.4f, want %.4f)" % [label, a, b])


func check_gt(a: float, b: float, label: String) -> void:
	check(a > b, "%s  (%.4f should exceed %.4f)" % [label, a, b])


# ── Suites ──────────────────────────────────────────────────────────────────

class Suite:
	var runner: Object
	func suite_name() -> String: return "unnamed"
	func run() -> void: pass


class TetherTests extends Suite:
	const ARENA := Rect2(0, 0, 320, 180)

	func suite_name() -> String:
		return "Tether — the economy the pacifist route rests on"

	func _fresh() -> Array:
		var t := Tether.new()
		t.max_length = 64.0
		t.set_self_radius(2.0)
		return [t, BulletPool.new(ARENA)]

	func run() -> void:
		_test_state_bands()
		_test_slack_earns_nothing()
		_test_taut_outearns_live()
		_test_danger_multiplier()
		_test_insight_cap()
		_test_spend()
		_test_snap_blocks_earning()

	func _test_state_bands() -> void:
		var t: Tether = _fresh()[0]
		t.update_geometry(Vector2(100, 100), Vector2(120, 100), 0.016)
		runner.check_eq(t.state, Tether.State.SLACK, "20px of 64 is SLACK")
		t.update_geometry(Vector2(100, 100), Vector2(140, 100), 0.016)
		runner.check_eq(t.state, Tether.State.LIVE, "40px of 64 is LIVE")
		t.update_geometry(Vector2(100, 100), Vector2(160, 100), 0.016)
		runner.check_eq(t.state, Tether.State.TAUT, "60px of 64 is TAUT")

	func _test_slack_earns_nothing() -> void:
		# If this fails, hugging the Ward becomes optimal and the design collapses.
		var f := _fresh()
		var t: Tether = f[0]
		var pool: BulletPool = f[1]
		t.update_geometry(Vector2(100, 100), Vector2(110, 100), 0.016)
		var i := pool.spawn(Vector2(105, 100), Vector2(0, 30), BulletPool.Type.PELLET)
		runner.check_eq(t.accrue(pool, PackedInt32Array([i]), 0.016), 0.0,
			"SLACK yields zero insight")

	func _test_taut_outearns_live() -> void:
		var f := _fresh()
		var t: Tether = f[0]
		var pool: BulletPool = f[1]
		# Perpendicular travel so the danger multiplier does not confound the result.
		var idx := pool.spawn(Vector2(130, 100), Vector2(0, 200), BulletPool.Type.PELLET)
		var reads := PackedInt32Array([idx])

		t.update_geometry(Vector2(100, 100), Vector2(140, 100), 0.016)
		var live: float = t.accrue(pool, reads, 0.016)
		t.reset()
		t.update_geometry(Vector2(100, 100), Vector2(160, 100), 0.016)
		var taut: float = t.accrue(pool, reads, 0.016)

		runner.check_gt(taut, live, "TAUT must out-earn LIVE — greed is the design")

	func _test_danger_multiplier() -> void:
		# Peace is priced in nerve: reading the shot that was about to kill you pays double.
		var f := _fresh()
		var t: Tether = f[0]
		var pool: BulletPool = f[1]

		t.update_geometry(Vector2(100, 100), Vector2(150, 100), 0.016)
		var safe := pool.spawn(Vector2(125, 100), Vector2(0, 200), BulletPool.Type.PELLET)
		var safe_gain: float = t.accrue(pool, PackedInt32Array([safe]), 0.016)

		t.reset()
		t.update_geometry(Vector2(100, 100), Vector2(150, 100), 0.016)
		var deadly := pool.spawn(Vector2(125, 100), Vector2(-100, 0), BulletPool.Type.PELLET)
		var deadly_gain: float = t.accrue(pool, PackedInt32Array([deadly]), 0.016)

		runner.check_near(deadly_gain, safe_gain * Tether.DANGER_MULT, 0.01,
			"a shot that would have hit Self pays double")

	func _test_insight_cap() -> void:
		var f := _fresh()
		var t: Tether = f[0]
		var pool: BulletPool = f[1]
		t.insight = 98.0
		t.update_geometry(Vector2(100, 100), Vector2(160, 100), 0.016)
		var idx := pool.spawn(Vector2(130, 100), Vector2(0, 200), BulletPool.Type.WEIGHT)
		t.accrue(pool, PackedInt32Array([idx]), 0.016)
		runner.check_eq(t.insight, Tether.INSIGHT_MAX, "insight caps at 100")

	func _test_spend() -> void:
		var t: Tether = _fresh()[0]
		t.insight = 30.0
		runner.check(not t.spend(40.0), "cannot spend what you have not earned")
		runner.check_eq(t.insight, 30.0, "a refused spend costs nothing")
		t.insight = 60.0
		runner.check(t.spend(40.0), "an affordable spend succeeds")
		runner.check_near(t.insight, 20.0, 0.001, "spend deducts exactly")

	func _test_snap_blocks_earning() -> void:
		var f := _fresh()
		var t: Tether = f[0]
		var pool: BulletPool = f[1]
		t.strain = Tether.STRAIN_MAX
		t.update_geometry(Vector2(100, 100), Vector2(164, 100), 0.016)
		var idx := pool.spawn(Vector2(130, 100), Vector2(0, 200), BulletPool.Type.PELLET)
		for _i in 60:
			t.accrue(pool, PackedInt32Array([idx]), 0.016)
			if t.state == Tether.State.SNAPPED:
				break
		runner.check_eq(t.state, Tether.State.SNAPPED, "strain at 100 snaps the tether")
		runner.check_eq(t.accrue(pool, PackedInt32Array([idx]), 0.016), 0.0,
			"a snapped tether reads nothing")


class BulletPoolTests extends Suite:
	const ARENA := Rect2(0, 0, 320, 180)

	func suite_name() -> String:
		return "BulletPool — flat arrays, no per-frame allocation"

	func run() -> void:
		var pool := BulletPool.new(ARENA)

		var a := pool.spawn(Vector2(10, 10), Vector2(60, 0), BulletPool.Type.PELLET)
		runner.check(a >= 0, "spawn returns a valid index")
		runner.check_eq(pool.live_count(), 1, "one bullet live")

		pool.integrate(0.5)
		runner.check_near(pool.position_of(a).x, 40.0, 0.01, "integration moves by v*dt")

		pool.despawn(a)
		runner.check_eq(pool.live_count(), 0, "despawn frees the slot")

		# Index reuse: a despawned slot must come back, or long fights leak capacity.
		var b := pool.spawn(Vector2(0, 0), Vector2.ZERO, BulletPool.Type.PELLET)
		runner.check_eq(b, a, "freed indices are reused")

		# Culling.
		pool.clear()
		var c := pool.spawn(Vector2(300, 90), Vector2(400, 0), BulletPool.Type.PELLET)
		pool.integrate(1.0)
		pool.cull_offscreen()
		runner.check_eq(pool.live_count(), 0, "offscreen bullets are culled")
		runner.check(c >= 0, "cull path does not corrupt the pool")

		# Curl preserves speed — players read speed as threat, so a curl that also
		# decelerated would misinform them.
		pool.clear()
		var d := pool.spawn(Vector2(160, 90), Vector2(50, 0), BulletPool.Type.CURL, 0.0, 90.0)
		var before := pool.velocity_of(d).length()
		pool.integrate(0.25)
		runner.check_near(pool.velocity_of(d).length(), before, 0.01,
			"curl rotates heading without changing speed")

		# Capacity headroom: the authored cap is 2000, the engine cap 4096.
		pool.clear()
		for _i in 2000:
			pool.spawn(Vector2(160, 90), Vector2(0, 10), BulletPool.Type.PELLET)
		runner.check_eq(pool.live_count(), 2000, "2000 simultaneous bullets fit")


class BroadphaseTests extends Suite:
	const ARENA := Rect2(0, 0, 320, 180)

	func suite_name() -> String:
		return "Broadphase — uniform grid"

	func run() -> void:
		var pool := BulletPool.new(ARENA)
		var bp := Broadphase.new(pool)

		pool.spawn(Vector2(100, 100), Vector2.ZERO, BulletPool.Type.PELLET)
		bp.rebuild()

		runner.check(bp.query_point(Vector2(100, 100), 3.0) >= 0, "point query finds a hit")
		runner.check_eq(bp.query_point(Vector2(200, 100), 3.0), -1, "point query misses cleanly")

		# Deduplication is load-bearing: if a bullet between two adjacent samples were
		# read twice, a slack tether could out-earn a taut one and the economy inverts.
		pool.clear()
		pool.spawn(Vector2(100, 100), Vector2.ZERO, BulletPool.Type.PELLET)
		bp.rebuild()
		var samples := PackedVector2Array([
			Vector2(99, 100), Vector2(100, 100), Vector2(101, 100),
			Vector2(102, 100), Vector2(103, 100), Vector2(104, 100),
		])
		var reads := bp.query_polyline(samples, 3.0)
		runner.check_eq(reads.size(), 1, "polyline query deduplicates overlapping samples")


class GameStateTests extends Suite:
	func suite_name() -> String:
		return "GameState — serialisation and the Eight"

	func run() -> void:
		var gs := GameState
		gs.reset()
		runner.check_eq(gs.value(&"mercy"), 20, "the Eight start at 20")

		gs.adjust(&"mercy", 500)
		runner.check_eq(gs.value(&"mercy"), 100, "values clamp at 100")
		gs.adjust(&"mercy", -500)
		runner.check_eq(gs.value(&"mercy"), 0, "values clamp at 0")

		# The Bell Count only ever goes down. No route raises it.
		gs.reset()
		gs.lose_bells(11)
		runner.check_eq(gs.bell_count, 79, "bells are lost, never gained")

		# Route resolution is emergent from the Eight, never a flag the player sets.
		gs.reset()
		gs.adjust(&"mercy", 40); gs.adjust(&"hope", 40)
		runner.check_eq(gs.resolve_route(), &"carry", "high mercy + hope -> CARRY")
		gs.reset()
		gs.adjust(&"wrath", 40)
		runner.check_eq(gs.resolve_route(), &"ledger", "high wrath -> LEDGER")
		gs.reset()
		runner.check_eq(gs.resolve_route(), &"drift", "mixed -> DRIFT")

		# Round-trip. Architecture Law 4: nothing outside this tree is saved.
		gs.reset()
		gs.adjust(&"curiosity", 17)
		gs.set_flag(&"osk_severed")
		gs.lose_bells(4)
		gs.mute_stem_permanently(&"l3_tilly")
		gs.brute_forced_mercy = true
		var d: Dictionary = gs.to_dict()
		gs.reset()
		gs.from_dict(d)
		runner.check_eq(gs.value(&"curiosity"), 37, "round-trip preserves the Eight")
		runner.check(gs.has_flag(&"osk_severed"), "round-trip preserves flags")
		runner.check_eq(gs.bell_count, 86, "round-trip preserves the Bell Count")
		runner.check(gs.permanently_muted.has(&"l3_tilly"), "round-trip preserves muted stems")
		runner.check(gs.brute_forced_mercy, "round-trip preserves the hidden superboss condition")


class UnknotTests extends Suite:
	func suite_name() -> String:
		return "UNKNOT — the anti-spam contract"

	func run() -> void:
		var enemy := EnemyProfile.filing_error()
		var sys := UnknotSystem.new()
		var t := Tether.new()
		sys.begin_encounter()

		t.insight = 100.0
		runner.check(not sys.attempt(enemy, &"a_grudge", t),
			"a wrong diagnosis does not resolve the enemy")
		runner.check_near(t.insight, 60.0, 0.001, "a wrong diagnosis still costs the insight")

		# Brute force stays possible, but it is expensive and it is recorded.
		runner.check(sys.attempt(enemy, enemy.correct_diagnosis, t),
			"the correct diagnosis resolves the enemy")

		runner.check(GameState.brute_forced_mercy,
			"guessing sets the hidden superboss condition, silently")

		runner.check(sys.is_known(enemy),
			"a learned diagnosis is remembered — knowledge is the pacifist's progression")

		# Options must actually shrink within an encounter, or brute force is free.
		sys.begin_encounter()
		var total: int = enemy.diagnosis_pool.size()
		runner.check_gt(float(total), 0.0, "the enemy has a populated diagnosis pool")
		t.insight = 100.0
		sys.attempt(enemy, &"a_grudge", t)
		runner.check_eq(sys.options_for(enemy).size(), total - 1,
			"a burned option is removed from the list")

		# A fresh encounter forgets what was *tried*, not what was *learned*.
		sys.begin_encounter()
		runner.check_eq(sys.options_for(enemy).size(), total,
			"tried-options reset between encounters")
		runner.check(sys.is_known(enemy), "learned diagnoses survive the encounter")
