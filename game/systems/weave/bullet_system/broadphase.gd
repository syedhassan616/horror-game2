class_name Broadphase
extends RefCounted
## Fixed flat-array spatial grid over the bullet pool.
##
## Two queries per frame drive the entire combat design:
##   query_point    — did anything hit Self? (4px core)
##   query_polyline — what did the tether read? (6 samples, 3px each)
##
## Implementation note: this was originally a Dictionary of PackedInt32Arrays and it
## cost 2.24ms at 2000 bullets against a 1.2ms budget — GDScript Dictionary hashing
## and per-cell array growth dominated the frame. The arena is a known, small,
## fixed size (320x180 plus cull margin = 24x15 cells), so the grid is preallocated
## as two flat arrays and cleared with a native fill(). No hashing, no per-frame
## allocation. See tests/bench_runner.gd for the numbers.

const CELL := 16.0
## Per-cell capacity. Dense patterns cluster hard; overflow drops the *later*
## bullets from that cell's query, so this is sized well above observed peaks.
const MAX_PER_CELL := 96

var _cols: int
var _rows: int
var _origin: Vector2

var _counts := PackedInt32Array()
var _items := PackedInt32Array()

## O(1) dedupe for polyline queries without allocating a Dictionary each frame.
## A bullet is "already seen" if its stamp matches the current query id.
var _seen := PackedInt32Array()
var _query_id: int = 0

var _pool: BulletPool


func _init(pool: BulletPool) -> void:
	_pool = pool
	# Match the pool's cull bounds so a bullet that is legal to exist is legal to index.
	var bounds := pool.bounds()
	_origin = bounds.position
	_cols = int(ceil(bounds.size.x / CELL)) + 1
	_rows = int(ceil(bounds.size.y / CELL)) + 1

	_counts.resize(_cols * _rows)
	_items.resize(_cols * _rows * MAX_PER_CELL)
	_seen.resize(BulletPool.CAPACITY)
	_seen.fill(-1)


func _cell_index(p: Vector2) -> int:
	var cx := int((p.x - _origin.x) / CELL)
	var cy := int((p.y - _origin.y) / CELL)
	if cx < 0 or cy < 0 or cx >= _cols or cy >= _rows:
		return -1
	return cy * _cols + cx


func rebuild() -> void:
	# This loop runs once per bullet per frame and is the hottest code in the game.
	# Two things matter here and both are GDScript-specific:
	#   1. No function call inside the loop. Calling _cell_index() per bullet cost
	#      ~1ms at 2000 bullets on its own — call overhead dominated the actual work.
	#   2. Local aliases for the pool's packed arrays. Reaching through _pool.pos_x
	#      per access repeats a property lookup 3x per bullet; PackedArrays are
	#      copy-on-write, so aliasing for reads is free.
	# Measured effect of both: 1.73ms -> see tests/bench_runner.gd.
	_counts.fill(0)

	var alive := _pool.alive
	var px := _pool.pos_x
	var py := _pool.pos_y
	var ox := _origin.x
	var oy := _origin.y
	var cols := _cols
	var rows := _rows

	for i in _pool.high_water:
		if alive[i] == 0:
			continue
		var cx := int((px[i] - ox) / CELL)
		var cy := int((py[i] - oy) / CELL)
		if cx < 0 or cy < 0 or cx >= cols or cy >= rows:
			continue
		var c := cy * cols + cx
		var n := _counts[c]
		if n >= MAX_PER_CELL:
			continue
		_items[c * MAX_PER_CELL + n] = i
		_counts[c] = n + 1


## Return the index of the first bullet overlapping `p` within `radius`, or -1.
## First, not nearest: a hit is a hit, and Self dies to any of them.
func query_point(p: Vector2, radius: float) -> int:
	var r2 := radius * radius
	var min_x := int((p.x - radius - _origin.x) / CELL)
	var max_x := int((p.x + radius - _origin.x) / CELL)
	var min_y := int((p.y - radius - _origin.y) / CELL)
	var max_y := int((p.y + radius - _origin.y) / CELL)

	for cy in range(maxi(min_y, 0), mini(max_y, _rows - 1) + 1):
		var row := cy * _cols
		for cx in range(maxi(min_x, 0), mini(max_x, _cols - 1) + 1):
			var c := row + cx
			var n := _counts[c]
			var base := c * MAX_PER_CELL
			for k in n:
				var i := _items[base + k]
				var dx: float = _pool.pos_x[i] - p.x
				var dy: float = _pool.pos_y[i] - p.y
				if dx * dx + dy * dy <= r2:
					return i
	return -1


## Return every bullet index touched by the polyline's sample points.
##
## Deduplicated: a bullet sitting between two adjacent samples must not be read
## twice, or a slack tether would out-earn a taut one and the whole Insight economy
## inverts. Dedupe is a stamp compare, not a Dictionary — this runs every frame.
func query_polyline(samples: PackedVector2Array, radius: float) -> PackedInt32Array:
	var out := PackedInt32Array()
	var r2 := radius * radius
	_query_id += 1
	var qid := _query_id

	for s in samples:
		var min_x := int((s.x - radius - _origin.x) / CELL)
		var max_x := int((s.x + radius - _origin.x) / CELL)
		var min_y := int((s.y - radius - _origin.y) / CELL)
		var max_y := int((s.y + radius - _origin.y) / CELL)

		for cy in range(maxi(min_y, 0), mini(max_y, _rows - 1) + 1):
			var row := cy * _cols
			for cx in range(maxi(min_x, 0), mini(max_x, _cols - 1) + 1):
				var c := row + cx
				var n := _counts[c]
				var base := c * MAX_PER_CELL
				for k in n:
					var i := _items[base + k]
					if _seen[i] == qid:
						continue
					var dx: float = _pool.pos_x[i] - s.x
					var dy: float = _pool.pos_y[i] - s.y
					if dx * dx + dy * dy <= r2:
						_seen[i] = qid
						out.append(i)
	return out
