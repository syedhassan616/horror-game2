class_name UnknotSystem
extends RefCounted
## UNKNOT — the non-violent resolution verb, and the most important system in the game.
##
## It makes peace a matter of attention and comprehension rather than patience.
## Undertale's ACT-then-SPARE loop can degrade into menu spamming; this cannot,
## because a wrong diagnosis costs the resource, escalates the enemy, and removes
## itself from the list.

const COST := 40.0
const COST_WITH_BEDSIDE_MANNER := 25.0

## Diagnoses the player has answered correctly, by enemy type. Knowledge is the
## pacifist route's progression system — not stats. The second Filing Error you
## meet Unknots in one action.
var known_diagnoses: Dictionary = {}       # enemy_id -> diagnosis_id
## Wrong answers already burned this encounter. Cleared on encounter end.
var _tried_this_encounter: Dictionary = {} # enemy_id -> Array[StringName]
## Whether a wrong answer has been given against this enemy in this encounter.
var _wrong_this_encounter: Dictionary = {}


func begin_encounter() -> void:
	_tried_this_encounter.clear()
	_wrong_this_encounter.clear()


## Options still available, in a stable order so a retry presents the same list.
func options_for(enemy: EnemyProfile) -> Array:
	var tried: Array = _tried_this_encounter.get(enemy.id, [])
	var out := []
	for d in enemy.diagnosis_pool:
		if d.id in tried:
			continue
		out.append(d)
	return out


## Returns true if the enemy is resolved peacefully.
func attempt(enemy: EnemyProfile, diagnosis_id: StringName, tether: Tether,
		cheap: bool = false) -> bool:
	var cost := COST_WITH_BEDSIDE_MANNER if cheap else COST
	if not tether.spend(cost):
		return false

	var correct := diagnosis_id == enemy.correct_diagnosis

	if correct:
		known_diagnoses[enemy.id] = diagnosis_id
		GameState.enemies_unknotted += 1
		GameState.adjust(&"mercy", 2)

		# The hidden superboss condition. The First Ward does not open for someone
		# who guessed at what people are holding. Set once, never cleared, never
		# mentioned anywhere in the game.
		if _wrong_this_encounter.get(enemy.id, false):
			GameState.brute_forced_mercy = true

		EventBus.unknot_attempted.emit(diagnosis_id, true)
		EventBus.enemy_resolved.emit(enemy.id, true)
		return true

	# Wrong: the Insight is spent, the option is gone, and the enemy escalates.
	# Brute force remains possible — expensive, and narratively acknowledged.
	if not _tried_this_encounter.has(enemy.id):
		_tried_this_encounter[enemy.id] = []
	_tried_this_encounter[enemy.id].append(diagnosis_id)
	_wrong_this_encounter[enemy.id] = true

	EventBus.unknot_attempted.emit(diagnosis_id, false)
	return false


## True if the player has already learned this enemy type and can resolve in one
## action without gathering evidence again.
func is_known(enemy: EnemyProfile) -> bool:
	return known_diagnoses.has(enemy.id)


## The Familiar skill node extends knowledge across a whole family rather than a type.
func is_known_by_family(enemy: EnemyProfile, familiar: bool) -> bool:
	if is_known(enemy):
		return true
	if not familiar:
		return false
	for id in known_diagnoses:
		if String(id).begins_with(String(enemy.family)):
			return true
	return false
