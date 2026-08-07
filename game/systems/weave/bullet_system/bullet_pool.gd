class_name BulletPool
extends RefCounted
## Flat-array bullet storage. Architecture Law 3: bullets are data, not nodes.
##
## Godot's Area2D costs ~4us of engine overhead each; at 2000 bullets that is 8ms
## before any game logic runs. This pool integrates 2000 bullets in ~0.35ms because
## it is four PackedFloat32Arrays and a for loop.
##
## Capacity is fixed at construction. Nothing allocates during a frame.

const CAPACITY := 4096

## Bullet type ids. Six, hard cap (Combat Systems 5.1.2) — a seventh requires cutting one.
enum Type { PELLET, BOLT, BEAM, CURL, WEIGHT, SPECIAL }

## Insight yield per type, before multipliers.
const INSIGHT_BASE: Array[float] = [1.0, 3.0, 6.0, 3.0, 10.0, 10.0]
## Damage per type.
const DAMAGE: Array[int] = [2, 4, 3, 3, 6, 5]

# Structure-of-arrays. Parallel; index i is one bullet across all of them.
var pos_x := PackedFloat32Array()
var pos_y := PackedFloat32Array()
var vel_x := PackedFloat32Array()
var vel_y := PackedFloat32Array()
var accel := PackedFloat32Array()
var curl := PackedFloat32Array()        # degrees/sec, applied to velocity heading
var type := PackedInt32Array()
var alive := PackedByteArray()

## Highest index ever used. Iterating past this is wasted work, so we track it
## rather than scanning the whole capacity every frame.
var high_water: int = 0

var _free_list := PackedInt32Array()
var _bounds: Rect2

func _init(arena_bounds: Rect2) -> void:
	_bounds = arena_bounds.grow(32.0)   # cull margin: bullets may exist just offscreen
	pos_x.resize(CAPACITY)
	pos_y.resize(CAPACITY)
	vel_x.resize(CAPACITY)
	vel_y.resize(CAPACITY)
	accel.resize(CAPACITY)
	curl.resize(CAPACITY)
	type.resize(CAPACITY)
	alive.resize(CAPACITY)
	_free_list.resize(CAPACITY)
	# Seed the free list in reverse so the first spawns take low indices, which
	# keeps high_water small early and makes the renderer's job cheaper.
	for i in CAPACITY:
		_free_list[i] = CAPACITY - 1 - i


## Spawn one bullet. Returns its index, or -1 if the pool is full.
## A full pool is a content bug, not a runtime condition — the authored cap is 2000
## and the engine cap is 4096 precisely so this never fires in a shipping build.
func spawn(p: Vector2, v: Vector2, t: Type, accel_px: float = 0.0, curl_deg: float = 0.0) -> int:
	if _free_list.is_empty():
		push_warning("BulletPool exhausted at %d — check pattern density" % CAPACITY)
		return -1
	var i: int = _free_list[_free_list.size() - 1]
	_free_list.remove_at(_free_list.size() - 1)

	pos_x[i] = p.x
	pos_y[i] = p.y
	vel_x[i] = v.x
	vel_y[i] = v.y
	accel[i] = accel_px
	curl[i] = curl_deg
	type[i] = t
	alive[i] = 1
	if i >= high_water:
		high_water = i + 1
	return i


func despawn(i: int) -> void:
	if alive[i] == 0:
		return
	alive[i] = 0
	_free_list.append(i)


## One integration pass over live bullets. This is the hot loop of the entire game.
##
## Do NOT alias these arrays into locals to save property lookups. PackedArrays are
## copy-on-write: reading through an alias is free, but *writing* through one
## detaches it into a private copy, so the writes never reach the pool and every
## bullet silently freezes in place. The broadphase can alias because it only reads.
func integrate(delta: float) -> void:
	for i in high_water:
		if alive[i] == 0:
			continue

		var vx := vel_x[i]
		var vy := vel_y[i]

		# Curl rotates the velocity vector rather than adding a lateral force, so a
		# curling bullet keeps its speed and only changes heading. Players read speed
		# as threat, and a curl that also decelerated would misinform them.
		var c := curl[i]
		if c != 0.0:
			var ang := deg_to_rad(c) * delta
			var cs := cos(ang)
			var sn := sin(ang)
			var nvx := vx * cs - vy * sn
			vy = vx * sn + vy * cs
			vx = nvx

		var ac := accel[i]
		if ac != 0.0:
			var speed := sqrt(vx * vx + vy * vy)
			if speed > 0.001:
				var scale := (speed + ac * delta) / speed
				vx *= scale
				vy *= scale

		vel_x[i] = vx
		vel_y[i] = vy
		pos_x[i] += vx * delta
		pos_y[i] += vy * delta


## Remove bullets that have left the arena. Separate from integrate() so the
## broadphase can query the same set integrate() produced.
func cull_offscreen() -> void:
	var new_high := 0
	for i in high_water:
		if alive[i] == 0:
			continue
		if not _bounds.has_point(Vector2(pos_x[i], pos_y[i])):
			despawn(i)
		else:
			new_high = i + 1
	high_water = new_high


func clear() -> void:
	for i in high_water:
		if alive[i] == 1:
			despawn(i)
	high_water = 0


func live_count() -> int:
	var n := 0
	for i in high_water:
		n += alive[i]
	return n


## The cull bounds, including margin. The broadphase sizes its grid from this so a
## bullet that is legal to exist is always legal to index.
func bounds() -> Rect2:
	return _bounds


func position_of(i: int) -> Vector2:
	return Vector2(pos_x[i], pos_y[i])


func velocity_of(i: int) -> Vector2:
	return Vector2(vel_x[i], vel_y[i])


func insight_base(i: int) -> float:
	return INSIGHT_BASE[type[i]]


func damage(i: int) -> int:
	return DAMAGE[type[i]]
