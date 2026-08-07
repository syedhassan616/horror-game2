extends Node
## Executes DialogueResources. The game's spine — every scene, quest and boss
## eventually routes through here.
##
## Emits rather than renders: the runner owns *what* is being said and the UI owns
## *how*. That split is what lets the dialogue history, the transcript export, and
## the accessibility text-speed settings all exist without the runner knowing.

signal line_shown(speaker: String, expression: String, text: String, interrupt: bool)
signal choices_offered(options: Array)
signal beat()
signal cue_fired(cue: String)
signal finished()

var is_running: bool = false

var _res: DialogueResource
var _node: StringName = &""
var _ops: Array = []
var _index: int = 0
var _seen_once: Dictionary = {}
## Full session scrollback. Exportable (Stage 7 §7.0.7) — people will quote this
## game, and making that easy is cheaper than watching them retype screenshots.
var _history: Array[Dictionary] = []


func start(res: DialogueResource, node: StringName) -> bool:
	if not res.has_node_id(node):
		push_error("DialogueRunner: no node '%s'" % node)
		return false
	if not _requirements_met(res, node):
		return false
	if node in res.once_nodes and _seen_once.get(node, false):
		return false

	_res = res
	_node = node
	_ops = res.ops(node)
	_index = 0
	is_running = true
	if node in res.once_nodes:
		_seen_once[node] = true
	_advance()
	return true


## Called by the UI when the player presses confirm on a line, or picks a choice.
func advance(choice_index: int = -1) -> void:
	if not is_running:
		return
	if choice_index >= 0:
		_apply_choice(choice_index)
		return
	_advance()


func _advance() -> void:
	while _index < _ops.size():
		var op: Dictionary = _ops[_index]
		_index += 1

		match op["op"]:
			DialogueResource.Op.LINE:
				_history.append(op)
				line_shown.emit(op["speaker"], op["expression"], op["text"],
					op.get("interrupt", false))
				return                                    # wait for player input

			DialogueResource.Op.CHOICE:
				choices_offered.emit(op["options"])
				return                                    # wait for player choice

			DialogueResource.Op.BEAT:
				beat.emit()
				return                                    # a held pause is a line

			DialogueResource.Op.CUE:
				cue_fired.emit(op["cue"])

			DialogueResource.Op.WRITE:
				_apply_write(op)

			DialogueResource.Op.EIGHT:
				GameState.adjust(op["key"], op["delta"])

			DialogueResource.Op.GOTO:
				_goto(op["target"])
				return

			DialogueResource.Op.END:
				_stop()
				return

	_stop()


func _apply_choice(i: int) -> void:
	# Find the choice op we are parked on.
	var op: Dictionary = _ops[_index - 1]
	if op["op"] != DialogueResource.Op.CHOICE:
		_advance()
		return
	var options: Array = op["options"]
	if i < 0 or i >= options.size():
		return
	var chosen: Dictionary = options[i]

	# Tone drives Aven's drift; it is characterisation with teeth, never a gate.
	if chosen.get("tone", "") != "":
		GameState.record_tone(StringName(chosen["tone"].to_lower()))
	for e in chosen.get("eight", []):
		GameState.adjust(e["key"], e["delta"])

	var target: StringName = chosen.get("target", &"")
	if target != &"":
		_goto(target)
	else:
		_advance()


func _goto(target: StringName) -> void:
	if not _res.has_node_id(target):
		push_error("DialogueRunner: @goto missing node '%s'" % target)
		_stop()
		return
	if not _requirements_met(_res, target):
		_stop()
		return
	_node = target
	_ops = _res.ops(target)
	_index = 0
	if target in _res.once_nodes:
		_seen_once[target] = true
	_advance()


func _apply_write(op: Dictionary) -> void:
	match op.get("kind", "flag"):
		"flag":
			GameState.set_flag(op["key"])
		"memory":
			var t: String = op["target"]
			var npc := t.split(".")[0]
			var mem: Dictionary = GameState.npcs.get(npc, {})
			var flags: Array = mem.get("memory", [])
			flags.append(op["value"])
			mem["memory"] = flags
			GameState.npcs[npc] = mem


func _requirements_met(res: DialogueResource, node: StringName) -> bool:
	for c in res.requires(node):
		if not _evaluate(c):
			return false
	return true


func _evaluate(c: Dictionary) -> bool:
	match c.get("kind", ""):
		"flag":
			return GameState.has_flag(c["key"])
		"compare":
			var lhs: Variant = _resolve(c["lhs"])
			var rhs: Variant = _resolve(c["rhs"])
			match c["op"]:
				">=": return lhs >= rhs
				"<=": return lhs <= rhs
				">": return lhs > rhs
				"<": return lhs < rhs
				"==": return lhs == rhs
	return true


func _resolve(token: String) -> Variant:
	token = token.strip_edges()
	if token.begins_with("eight."):
		return GameState.value(StringName(token.substr(6)))
	if token == "bell_count":
		return GameState.bell_count
	if token == "act":
		return GameState.act
	if token.is_valid_int():
		return int(token)
	return token


func _stop() -> void:
	is_running = false
	_node = &""
	_ops = []
	_index = 0
	finished.emit()


## The transcript, newest last. Speaker, expression and text — enough to reconstruct
## how the player played, not just what was said.
func history() -> Array[Dictionary]:
	return _history


func export_history() -> String:
	var out := PackedStringArray()
	for h in _history:
		var expr: String = h.get("expression", "")
		if expr != "":
			out.append("%s [%s]: %s" % [h["speaker"], expr, h["text"]])
		else:
			out.append("%s: %s" % [h["speaker"], h["text"]])
	return "\n".join(out)
