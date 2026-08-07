extends Node
## Scripted playthrough of the Prologue.
##
## Run:  godot --headless --path game res://tests/playthrough_scene.tscn
##
## "It boots" is not "it is playable". This drives DialogueRunner through the whole
## Prologue the way a player would — reading drawers, talking to Osk, choosing tones,
## surviving the severance — and asserts the state the player should end up in.
## It is the closest thing to a Route Prover (Architecture 10.10) that exists yet.

const SRC := "res://data/dialogue/src/prologue.sh"
const MAX_STEPS := 400

var _res: DialogueResource
var _pending_choices: Array = []
var _lines: Array[String] = []
var _passed: int = 0
var _failed: int = 0


func _ready() -> void:
	print("SECONDHEART — Prologue playthrough\n")

	var parser := DialogueParser.new()
	_res = parser.parse_file(SRC)
	if not parser.errors.is_empty():
		for e in parser.errors:
			print("   parse error: %s" % e)
		_failed += 1

	DialogueRunner.line_shown.connect(func(spk, _ex, txt, _int):
		_lines.append("%s: %s" % [spk, txt]))
	DialogueRunner.choices_offered.connect(func(opts): _pending_choices = opts)
	DialogueRunner.beat.connect(func(): pass)
	DialogueRunner.cue_fired.connect(func(c): _lines.append("[cue] %s" % c))

	GameState.reset()

	# ── the player's route through the Prologue ──────────────────────────────
	_play(&"drawer_reserved", [])                 # F01: the reserved stamp
	_play(&"drawer_ilsabet", [])                  # F26: "I'd only lose it again"
	_play(&"osk_first", [0])                      # WRY
	_play(&"osk_marren", [0])                     # WARM — "Who was she?"
	_play(&"osk_the_sentence", [3])               # QUIET, after the severance
	_play(&"osk_requisition", [])

	# ── assertions ───────────────────────────────────────────────────────────
	_check(GameState.has_flag(&"read_reserved"), "read the RESERVED drawer (F01)")
	_check(GameState.has_flag(&"read_ilsabet"), "read Ilsabet Vane's drawer (F26)")
	_check(GameState.has_flag(&"met_osk"), "met Osk")
	_check(GameState.has_flag(&"heard_osk_mornings"),
		"heard the mornings line — the Commonplace puzzle's answer is now logged")
	_check(GameState.has_flag(&"osk_severed"), "Osk was severed mid-sentence")
	_check(GameState.has_flag(&"has_requisition"), "left with requisition 12-B/1441")

	_check(GameState.tone_counts.size() > 0, "tone choices were recorded")
	_check(GameState.tone_drift() > 0.0, "Aven's voice has begun to drift")

	# The severance must not be replayable — @once, or the thesis scene cheapens.
	var before := _lines.size()
	DialogueRunner.start(_res, &"osk_the_sentence")
	_check(_lines.size() == before, "S-006 cannot replay (@once honoured)")

	# The transcript exists and is exportable.
	_check(DialogueRunner.export_history().length() > 200,
		"a full transcript was captured for export")

	# Osk after severance: facts, habits, courtesy — never longing or regret.
	var forbidden := ["I miss", "I wish", "I loved her", "I'm sorry", "I want"]
	var violations: Array[String] = []
	for l in _lines:
		if not l.begins_with("OSK"):
			continue
		for f in forbidden:
			if l.contains(f):
				violations.append(l)
	_check(violations.is_empty(),
		"severed Osk expresses no preference, longing or regret %s" % [violations])

	print("\n── transcript ──")
	for l in _lines:
		print("   " + l)

	print("\n──────────────────────────────")
	print("%d passed, %d failed" % [_passed, _failed])
	get_tree().quit(1 if _failed > 0 else 0)


## Drive one dialogue node to completion, answering choices from `picks`.
func _play(node: StringName, picks: Array) -> void:
	if not DialogueRunner.start(_res, node):
		print("   (node %s did not start — requirements unmet or @once)" % node)
		return
	var pick_i := 0
	var steps := 0
	while DialogueRunner.is_running and steps < MAX_STEPS:
		steps += 1
		if not _pending_choices.is_empty():
			var choice: int = picks[pick_i] if pick_i < picks.size() else 0
			_pending_choices = []
			pick_i += 1
			DialogueRunner.advance(choice)
			# A choice that loops back to its own menu (as Osk's post-severance
			# options do) would spin forever; one pass through is enough.
			if pick_i > picks.size():
				DialogueRunner.advance(-2)
				break
		else:
			DialogueRunner.advance()
	if steps >= MAX_STEPS:
		print("   WARNING: %s hit the step cap — possible dialogue loop" % node)


func _check(cond: bool, label: String) -> void:
	if cond:
		_passed += 1
		print("   ok   %s" % label)
	else:
		_failed += 1
		print("   FAIL %s" % label)
