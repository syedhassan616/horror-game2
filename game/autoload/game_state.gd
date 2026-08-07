extends Node
## GameState — the entire save-able world (Architecture Law 4).
##
## Nothing outside this tree is saved. A node holding state that matters is a bug,
## and the Route Prover catches it by round-tripping a save mid-scene and asserting
## equality. This is what makes 2.1M epilogue permutations tractable.

const SAVE_VERSION := 1

## The Eight. No value is "good" — every one has authored costs. Never shown as a
## number, never shown as a bar, never summed into an alignment.
const EIGHT_KEYS: Array[StringName] = [
	&"compassion", &"trust", &"curiosity", &"fear",
	&"hope", &"resolve", &"mercy", &"wrath",
]
const EIGHT_START := 20
const EIGHT_MIN := 0
const EIGHT_MAX := 100

var version: int = SAVE_VERSION
var eight: Dictionary = {}
var flags: Dictionary = {}
var quests: Dictionary = {}
var npcs: Dictionary = {}
var journal_questions: Array[StringName] = []

## World state. bell_count only ever goes down — there is no mechanic in any route
## that raises it. The 91st bell adds a frame, not a mark, and Tilly says so.
var bell_count: int = 90
var route: StringName = &""            # carry | ledger | drift, resolved at Act II
var act: int = 0

## Music permanence. No ending, no NG+, no quest reverses a lost stem.
var permanently_muted: Dictionary = {}
var silenced_voices: Array[StringName] = []

## Voice System: tone counts drive Aven's drift, not a stat gate.
var tone_counts: Dictionary = {}

## Run statistics. brute_forced_mercy is the hidden superboss condition — set once
## if the player ever succeeds at UNKNOT after a wrong diagnosis in the same
## encounter, never cleared, never mentioned anywhere in the game.
var brute_forced_mercy: bool = false
var enemies_severed: int = 0
var enemies_unknotted: int = 0


func _ready() -> void:
	reset()


func reset() -> void:
	eight.clear()
	for k in EIGHT_KEYS:
		eight[k] = EIGHT_START
	flags.clear()
	quests.clear()
	npcs.clear()
	journal_questions.clear()
	permanently_muted.clear()
	silenced_voices.clear()
	tone_counts.clear()
	bell_count = 90
	route = &""
	act = 0
	brute_forced_mercy = false
	enemies_severed = 0
	enemies_unknotted = 0


# --- The Eight --------------------------------------------------------------

func adjust(key: StringName, delta: int) -> void:
	assert(eight.has(key), "Unknown value: %s" % key)
	eight[key] = clampi(eight[key] + delta, EIGHT_MIN, EIGHT_MAX)
	EventBus.eight_changed.emit(key, eight[key])


func value(key: StringName) -> int:
	return eight.get(key, EIGHT_START)


## Natural decay toward the baseline for anything not reinforced, applied per act.
func decay_toward_baseline() -> void:
	for k in EIGHT_KEYS:
		var v: int = eight[k]
		if v > EIGHT_START:
			eight[k] = v - 1
		elif v < EIGHT_START:
			eight[k] = v + 1


# --- Flags ------------------------------------------------------------------

func set_flag(flag: StringName, v: Variant = true) -> void:
	flags[flag] = v
	EventBus.flag_written.emit(flag, v)


func has_flag(flag: StringName) -> bool:
	return flags.get(flag, false) == true


# --- World ------------------------------------------------------------------

## The Bell Count is a read-only-downward world value. It is the most-read number in
## the game: lighting bands, music stems, shop inventory, NPC greetings, Guisley's
## willingness, the Tally's alternate, every epilogue, and the final spoken line.
func lose_bells(n: int) -> void:
	bell_count = maxi(0, bell_count - n)
	EventBus.bell_count_changed.emit(bell_count)


func mute_stem_permanently(stem_id: StringName) -> void:
	permanently_muted[stem_id] = true
	EventBus.stem_muted_permanently.emit(stem_id)


func silence_voice(singer_id: StringName) -> void:
	if singer_id in silenced_voices:
		return
	silenced_voices.append(singer_id)
	EventBus.choir_voice_silenced.emit(singer_id)


# --- Voice System -----------------------------------------------------------

func record_tone(tone: StringName) -> void:
	tone_counts[tone] = tone_counts.get(tone, 0) + 1


func dominant_tone() -> StringName:
	var best: StringName = &""
	var best_n := -1
	for t in tone_counts:
		if tone_counts[t] > best_n:
			best_n = tone_counts[t]
			best = t
	return best


func tone_drift() -> float:
	var total := 0
	for t in tone_counts:
		total += tone_counts[t]
	if total == 0:
		return 0.0
	return float(tone_counts.get(dominant_tone(), 0)) / float(total)


# --- Route ------------------------------------------------------------------

## Routes are emergent from the Eight, resolved at checkpoints — there is no
## "pacifist run" flag the player can see or set.
func resolve_route() -> StringName:
	var mercy := value(&"mercy")
	var wrath := value(&"wrath")
	var hope := value(&"hope")

	if mercy >= 55 and wrath < 30 and hope >= 55:
		route = &"carry"
	elif wrath >= 50:
		route = &"ledger"
	else:
		route = &"drift"
	return route


# --- Serialisation ----------------------------------------------------------

func to_dict() -> Dictionary:
	return {
		"version": version,
		"eight": eight.duplicate(),
		"flags": flags.duplicate(),
		"quests": quests.duplicate(),
		"npcs": npcs.duplicate(),
		"journal_questions": journal_questions.duplicate(),
		"bell_count": bell_count,
		"route": String(route),
		"act": act,
		"permanently_muted": permanently_muted.duplicate(),
		"silenced_voices": silenced_voices.duplicate(),
		"tone_counts": tone_counts.duplicate(),
		"brute_forced_mercy": brute_forced_mercy,
		"enemies_severed": enemies_severed,
		"enemies_unknotted": enemies_unknotted,
	}


func from_dict(d: Dictionary) -> void:
	version = d.get("version", SAVE_VERSION)
	eight = d.get("eight", {}).duplicate()
	flags = d.get("flags", {}).duplicate()
	quests = d.get("quests", {}).duplicate()
	npcs = d.get("npcs", {}).duplicate()
	journal_questions.assign(d.get("journal_questions", []))
	bell_count = d.get("bell_count", 90)
	route = StringName(d.get("route", ""))
	act = d.get("act", 0)
	permanently_muted = d.get("permanently_muted", {}).duplicate()
	silenced_voices.assign(d.get("silenced_voices", []))
	tone_counts = d.get("tone_counts", {}).duplicate()
	brute_forced_mercy = d.get("brute_forced_mercy", false)
	enemies_severed = d.get("enemies_severed", 0)
	enemies_unknotted = d.get("enemies_unknotted", 0)
