extends Node
## Performance bench for the bullet subsystem.
##
## Run:  godot --headless --path game res://tests/bench_scene.tscn
##
## The GDScript-vs-GDExtension decision (Architecture 10.1) is deferred until
## profiling forces it. This is the profiling. The documented budget is 1.2ms for
## integrate + broadphase + collision at 2000 bullets; if that holds on the
## reference target we do not pay a language tax we do not need.

const ARENA := Rect2(0, 0, 320, 180)
const BUDGET_MS := 1.2
const FRAMES := 300


func _ready() -> void:
	print("SECONDHEART — bullet subsystem bench\n")
	for count in [500, 1000, 2000, 4000]:
		_bench(count)
	print("\nBudget: %.2f ms for integrate + broadphase + queries at 2000 bullets." % BUDGET_MS)
	print("Note: headless CPU timing only. Reference target is Intel UHD 620 / Steam Deck.")
	get_tree().quit(0)


func _bench(count: int) -> void:
	var pool := BulletPool.new(ARENA)
	var bp := Broadphase.new(pool)
	var tether := Tether.new()
	tether.max_length = 64.0
	tether.set_self_radius(2.0)

	# Fill the arena with slow bullets on varied headings so the grid buckets are
	# genuinely populated rather than all landing in one cell.
	var rng := RandomNumberGenerator.new()
	rng.seed = 1441
	for _i in count:
		var p := Vector2(rng.randf_range(0, 320), rng.randf_range(0, 180))
		var v := Vector2.RIGHT.rotated(rng.randf_range(0, TAU)) * rng.randf_range(8, 24)
		pool.spawn(p, v, BulletPool.Type.PELLET)

	var self_pos := ARENA.get_center()
	var ward_pos := self_pos + Vector2(0, 48)

	var total_us := 0
	var peak_us := 0
	var integrate_us := 0
	var rebuild_us := 0
	var query_us := 0
	for _f in FRAMES:
		var t0 := Time.get_ticks_usec()

		pool.integrate(1.0 / 60.0)
		var t1 := Time.get_ticks_usec()
		bp.rebuild()
		var t2 := Time.get_ticks_usec()
		tether.update_geometry(self_pos, ward_pos, 1.0 / 60.0)
		var _hit := bp.query_point(self_pos, 2.0)
		var reads := bp.query_polyline(tether.samples(), Tether.SAMPLE_RADIUS)
		tether.accrue(pool, reads, 1.0 / 60.0)
		var t3 := Time.get_ticks_usec()

		integrate_us += t1 - t0
		rebuild_us += t2 - t1
		query_us += t3 - t2
		var dt := t3 - t0
		total_us += dt
		peak_us = maxi(peak_us, dt)

		# Keep the population stable: respawn anything that drifted out so every
		# frame measures the same load.
		pool.cull_offscreen()
		while pool.live_count() < count:
			var p := Vector2(rng.randf_range(0, 320), rng.randf_range(0, 180))
			var v := Vector2.RIGHT.rotated(rng.randf_range(0, TAU)) * rng.randf_range(8, 24)
			if pool.spawn(p, v, BulletPool.Type.PELLET) < 0:
				break

	var avg_ms := (float(total_us) / float(FRAMES)) / 1000.0
	var peak_ms := float(peak_us) / 1000.0
	var verdict := "within budget" if (count < 2000 or avg_ms <= BUDGET_MS) else "OVER BUDGET"
	print("  %5d bullets   avg %6.3f ms   peak %6.3f ms   %s" % [
		count, avg_ms, peak_ms, verdict])
	print("            integrate %5.3f   grid %5.3f   queries %5.3f  (ms/frame)" % [
		(float(integrate_us) / FRAMES) / 1000.0,
		(float(rebuild_us) / FRAMES) / 1000.0,
		(float(query_us) / FRAMES) / 1000.0])
