class_name Tether
extends RefCounted
## The Tether — the game's core mechanic.
##
## A line between Self and Ward that READS hostile fire rather than blocking it.
## Reading generates INSIGHT (the currency for peaceful resolution) and STRAIN
## (the counterweight that stops "hold TAUT forever" being optimal).
##
## The design in one sentence: sweeping the tether through danger is how you earn
## the resource for mercy, so pacifism costs nerve rather than patience.

enum State { SLACK, LIVE, TAUT, STRAINED, SNAPPED }

const SAMPLE_COUNT := 6
const SAMPLE_RADIUS := 3.0

const INSIGHT_MAX := 100.0
const STRAIN_MAX := 100.0
const STRAIN_STRAINED_THRESHOLD := 70.0

## Tether length as a fraction of max, per Combat Systems 5.0.4.
const SLACK_BAND := 0.40
const TAUT_BAND := 0.90
## Strain only accrues from length above this fraction.
const STRAIN_FREE_BAND := 0.75

const SNAP_DURATION := 3.0
const SNAP_DAMAGE := 8

## Insight multiplier per state, indexed by State.
const STATE_INSIGHT_MULT: Array[float] = [0.0, 1.0, 1.6, 0.5, 0.0]
## Strain multiplier per state.
const STATE_STRAIN_MULT: Array[float] = [0.0, 1.0, 2.0, 1.0, 0.0]

## A projectile that would strike Self within this many seconds doubles its yield.
## This is the whole design: you are paid for reading the shot that was about to
## kill you. Deliberately generous, because the player must be able to feel it.
const DANGER_WINDOW := 0.4
const DANGER_MULT := 2.0

var state: State = State.SLACK
var insight: float = 0.0
var strain: float = 0.0
var max_length: float = 64.0

## Set from the active CompanionProfile.
var insight_multiplier: float = 1.0
var strain_resist: float = 0.0

var _snap_timer: float = 0.0
var _samples := PackedVector2Array()
var _self_pos := Vector2.ZERO
var _ward_pos := Vector2.ZERO
var _self_radius: float = 2.0
## Insight earned this frame, needed by the strain equation.
var _insight_this_frame: float = 0.0


func _init() -> void:
	_samples.resize(SAMPLE_COUNT)


## Recompute sample points and the state band. Call before accrue().
func update_geometry(self_pos: Vector2, ward_pos: Vector2, delta: float) -> void:
	_self_pos = self_pos
	_ward_pos = ward_pos

	for i in SAMPLE_COUNT:
		# t in (0,1] — sample 0 sits just off Self so the tether cannot double-dip
		# on a bullet that is already hitting the core.
		var t := float(i + 1) / float(SAMPLE_COUNT)
		_samples[i] = self_pos.lerp(ward_pos, t)

	if state == State.SNAPPED:
		_snap_timer -= delta
		if _snap_timer <= 0.0:
			state = State.SLACK
			strain = 0.0
			EventBus.tether_state_changed.emit(State.SNAPPED, State.SLACK)
		return

	var frac := (self_pos.distance_to(ward_pos)) / max_length
	var prev := state

	if strain >= STRAIN_STRAINED_THRESHOLD:
		state = State.STRAINED
	elif frac < SLACK_BAND:
		state = State.SLACK
	elif frac < TAUT_BAND:
		state = State.LIVE
	else:
		state = State.TAUT

	if state != prev:
		EventBus.tether_state_changed.emit(prev, state)
		if state == State.STRAINED:
			EventBus.tether_strained.emit()


## Read the bullets the polyline touched. Returns Insight earned this frame.
##
## `read_indices` comes from Broadphase.query_polyline() and is already deduplicated —
## if it were not, a slack tether would out-earn a taut one and the economy inverts.
func accrue(pool: BulletPool, read_indices: PackedInt32Array, delta: float) -> float:
	_insight_this_frame = 0.0

	if state == State.SNAPPED:
		_decay_strain(delta)
		return 0.0

	var state_mult: float = STATE_INSIGHT_MULT[state]
	if state_mult > 0.0:
		for i in read_indices:
			var gain := pool.insight_base(i) * state_mult * insight_multiplier
			var dangerous := _would_hit_self(pool, i)
			if dangerous:
				gain *= DANGER_MULT
			_insight_this_frame += gain
			EventBus.insight_gained.emit(gain, dangerous)

		insight = minf(insight + _insight_this_frame, INSIGHT_MAX)

	_accrue_strain(delta)
	return _insight_this_frame


## Forward-integrate a bullet against Self's current position. A prediction, not a
## swept test — cheap, and generous in the player's favour, which is correct here.
func _would_hit_self(pool: BulletPool, i: int) -> bool:
	var rel := pool.position_of(i) - _self_pos
	var vel := pool.velocity_of(i)
	var speed_sq := vel.length_squared()
	if speed_sq < 1.0:
		return false

	# Time of closest approach along the bullet's path.
	var t := -rel.dot(vel) / speed_sq
	if t < 0.0 or t > DANGER_WINDOW:
		return false

	var closest := rel + vel * t
	return closest.length() <= _self_radius + SAMPLE_RADIUS


func _accrue_strain(delta: float) -> void:
	var frac := _self_pos.distance_to(_ward_pos) / max_length
	var length_term := maxf(0.0, frac - STRAIN_FREE_BAND) * 34.0
	var insight_term := (_insight_this_frame / maxf(delta, 0.0001)) * 0.6 * delta
	var gain := (length_term * delta * STATE_STRAIN_MULT[state]) + insight_term - (strain_resist * delta)

	if gain > 0.0:
		strain += gain
		if strain >= STRAIN_MAX:
			_snap()
	else:
		_decay_strain(delta)


func _decay_strain(delta: float) -> void:
	# Strain only decays while the player is not farming. This is what produces the
	# game's core rhythm: greed, tension, deliberate release.
	if _insight_this_frame <= 0.0 and (state == State.SLACK or state == State.LIVE):
		strain = maxf(0.0, strain - 12.0 * delta)


func _snap() -> void:
	var prev := state
	strain = STRAIN_MAX
	state = State.SNAPPED
	_snap_timer = SNAP_DURATION
	EventBus.tether_state_changed.emit(prev, State.SNAPPED)
	EventBus.tether_snapped.emit()


## Spend Insight. Returns false if the player cannot afford it.
func spend(amount: float) -> bool:
	if insight < amount:
		return false
	insight -= amount
	return true


## Clear Strain and restore the tether (the MEND action).
func mend() -> void:
	strain = 0.0
	if state == State.STRAINED:
		state = State.LIVE


func samples() -> PackedVector2Array:
	return _samples


func set_self_radius(r: float) -> void:
	_self_radius = r


func reset() -> void:
	insight = 0.0
	strain = 0.0
	state = State.SLACK
	_snap_timer = 0.0
