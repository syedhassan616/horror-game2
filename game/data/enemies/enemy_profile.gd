class_name EnemyProfile
extends Resource
## An enemy is a data file plus one of nine family AI trunks.
##
## Nine trunks, not eighty-four scripts. Types differentiate through data — pattern
## sets, speeds, telegraph lengths, dialogue, diagnoses. This is the scope-control
## decision that makes the roster affordable for a small team.

@export var id: StringName = &""
@export var display_name: String = ""

@export_enum("clerical", "bellwork", "rootbound", "willing", "saltborne",
	"loomkin", "sunken", "orbital", "unread")
var family: String = "clerical"

@export var hp: int = 20
@export var defence: float = 0.0
@export var speed: float = 30.0

@export var patterns: Array[Resource] = []
## HP fractions at which the enemy advances a phase.
@export var phase_thresholds: PackedFloat32Array = PackedFloat32Array()

## Exactly two. Weaknesses are hints, not damage multipliers — they tell the player
## how to think about this creature.
@export var weaknesses: Array[StringName] = []

## 4-6 options, exactly one correct. Seeded by evidence the player actually gathered.
@export var diagnosis_pool: Array[Resource] = []
@export var correct_diagnosis: StringName = &""

## Three minimum. Written so the diagnosis is inferable without being stated.
@export var lines: Array[String] = []

@export var drop_common: StringName = &""
@export var drop_rare: StringName = &""      # 3%

@export var personality: String = ""

## Both are authored for all 84 types. A fade-out on an UNKNOT would undo the
## entire pacifist design, so there are 168 of these and no exceptions.
@export_multiline var resolve_scene_sever: String = ""
@export_multiline var resolve_scene_unknot: String = ""


static func filing_error() -> EnemyProfile:
	var e := EnemyProfile.new()
	e.id = &"clr_01_filing_error"
	e.display_name = "Filing Error"
	e.family = "clerical"
	e.hp = 12
	e.defence = 0.0
	e.speed = 30.0
	e.phase_thresholds = PackedFloat32Array([0.5])
	e.weaknesses = [&"sever_perfect_ring", &"bound"]
	e.correct_diagnosis = &"a_category_it_doesnt_fit"
	# Exactly one correct. The wrong options are plausible readings of the same
	# behaviour, not filler — a player who has not paid attention must be able to
	# pick any of them for a defensible reason.
	e.diagnosis_pool = [
		_diagnosis(&"a_grudge", "It is holding a grudge.", &"speak"),
		_diagnosis(&"a_place_in_a_queue", "It is holding a place in a queue.", &"pattern"),
		_diagnosis(&"a_category_it_doesnt_fit",
			"It is holding a category it doesn't fit.", &"floor_card"),
		_diagnosis(&"a_name", "It is holding a name.", &"speak"),
	]
	e.lines = [
		"Where does this go.",
		"This is not where this goes.",
		"Please.",
	]
	e.drop_common = &"index_card"
	e.drop_rare = &"blank_4c"
	e.personality = "Insistent, not hostile. Wants to be put somewhere."
	e.resolve_scene_unknot = """Aven writes it a category on a blank card.
It reads the card. It files itself, correctly, into a drawer it selects,
and closes the drawer from the inside.
It is the first thing in the game to thank the player."""
	e.resolve_scene_sever = """The cards fall. They stay fallen.
Osk picks them up. He does not comment."""
	return e


class Diagnosis extends Resource:
	@export var id: StringName = &""
	@export var text: String = ""
	## Which evidence source unlocks this option in the list: SPEAK, an attack
	## pattern, an overworld prop, a Journal entry, or Edda's READ.
	@export var evidence: StringName = &""


static func _diagnosis(id: StringName, text: String, evidence: StringName) -> Diagnosis:
	var d := Diagnosis.new()
	d.id = id
	d.text = text
	d.evidence = evidence
	return d
