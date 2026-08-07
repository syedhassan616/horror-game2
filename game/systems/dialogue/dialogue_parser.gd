class_name DialogueParser
extends RefCounted
## Parses the .sh dialogue format (Stage 7 §7.0.1) into a DialogueResource.
##
## The format is plain text and diffable on purpose: writers work in it without the
## editor open, and a reviewer can see a changed line as one line in a diff.
##
## Errors are collected rather than thrown. A malformed line should not take the
## whole script down — the compiler reports every problem in one pass, which is
## what makes the CI coverage report useful instead of whack-a-mole.

var errors: Array[String] = []

const TONES := ["WARM", "WRY", "BLUNT", "CAREFUL", "QUIET"]


func parse_file(path: String) -> DialogueResource:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		errors.append("cannot open %s" % path)
		return DialogueResource.new()
	return parse(f.get_as_text(), path)


func parse(text: String, source: String = "<string>") -> DialogueResource:
	var res := DialogueResource.new()
	var current: StringName = &""
	var line_no := 0

	for raw in text.split("\n"):
		line_no += 1
		var line := raw.strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue

		# ---- directives ----
		if line.begins_with("@node "):
			current = StringName(line.substr(6).strip_edges())
			res.nodes[current] = []
			res.requirements[current] = []
			continue

		if current == &"":
			errors.append("%s:%d: content before any @node" % [source, line_no])
			continue

		if line.begins_with("@require "):
			res.requirements[current].append(_parse_condition(line.substr(9), source, line_no))
			continue

		if line == "@once":
			res.once_nodes.append(current)
			continue

		if line.begins_with("@write "):
			res.nodes[current].append(_parse_write(line.substr(7)))
			continue

		if line.begins_with("@eight "):
			res.nodes[current].append(_parse_eight(line.substr(7)))
			continue

		if line.begins_with("@cue "):
			res.nodes[current].append({"op": DialogueResource.Op.CUE,
				"cue": line.substr(5).strip_edges()})
			continue

		if line.begins_with("@goto "):
			res.nodes[current].append({"op": DialogueResource.Op.GOTO,
				"target": StringName(line.substr(6).strip_edges())})
			continue

		if line == "@end":
			res.nodes[current].append({"op": DialogueResource.Op.END})
			continue

		if line == "@choice":
			res.nodes[current].append({"op": DialogueResource.Op.CHOICE, "options": []})
			continue

		# ---- choice option: "-> TONE "text" @goto x @eight k+n" ----
		if line.begins_with("->"):
			var opt := _parse_option(line.substr(2), source, line_no)
			var ops: Array = res.nodes[current]
			# Attach to the most recent CHOICE op.
			for i in range(ops.size() - 1, -1, -1):
				if ops[i]["op"] == DialogueResource.Op.CHOICE:
					ops[i]["options"].append(opt)
					break
			continue

		if line == "[BEAT]":
			res.nodes[current].append({"op": DialogueResource.Op.BEAT})
			continue

		# ---- a spoken line ----
		var spoken := _parse_line(line, source, line_no)
		if not spoken.is_empty():
			res.nodes[current].append(spoken)

	return res


## SPEAKER [expression] "text"   — optionally prefixed with [INTERRUPT]
func _parse_line(line: String, source: String, line_no: int) -> Dictionary:
	var interrupt := false
	if line.begins_with("[INTERRUPT]"):
		interrupt = true
		line = line.substr(11).strip_edges()

	var quote_start := line.find("\"")
	if quote_start < 0:
		errors.append("%s:%d: line has no quoted text: %s" % [source, line_no, line])
		return {}
	var quote_end := line.rfind("\"")
	if quote_end <= quote_start:
		errors.append("%s:%d: unterminated quote" % [source, line_no])
		return {}

	var head := line.substr(0, quote_start).strip_edges()
	# Unescape \" so a writer can quote inside a line — which they need constantly,
	# because half this script is people quoting forms at each other.
	var body := line.substr(quote_start + 1, quote_end - quote_start - 1).replace("\\\"", "\"")

	var expression := ""
	var b1 := head.find("[")
	if b1 >= 0:
		var b2 := head.find("]", b1)
		if b2 > b1:
			expression = head.substr(b1 + 1, b2 - b1 - 1)
			head = head.substr(0, b1).strip_edges()

	return {
		"op": DialogueResource.Op.LINE,
		"speaker": head,
		"expression": expression,
		"text": body,
		"interrupt": interrupt,
	}


## TONE "text" @goto target [@eight key+n ...]
func _parse_option(s: String, source: String, line_no: int) -> Dictionary:
	s = s.strip_edges()
	var tone := ""
	for t in TONES:
		if s.begins_with(t):
			tone = t
			s = s.substr(t.length()).strip_edges()
			break
	if tone == "":
		errors.append("%s:%d: choice has no tone tag" % [source, line_no])

	var q1 := s.find("\"")
	var q2 := s.find("\"", q1 + 1)
	if q1 < 0 or q2 < 0:
		errors.append("%s:%d: choice has no quoted text" % [source, line_no])
		return {}
	var label := s.substr(q1 + 1, q2 - q1 - 1)
	var rest := s.substr(q2 + 1)

	var target := &""
	var eight: Array = []
	for token in rest.split(" ", false):
		token = token.strip_edges()
		if token.begins_with("@goto"):
			continue
		if token.begins_with("@eight"):
			continue
		if target == &"" and not token.begins_with("@") and not token.contains("+") and not token.contains("-"):
			target = StringName(token)
		elif token.contains("+") or token.contains("-"):
			eight.append(_parse_eight(token))

	return {"tone": tone, "label": label, "target": target, "eight": eight}


## flag:name  |  eight.wrath >= 50  |  companion == tilly
func _parse_condition(s: String, _source: String, _line_no: int) -> Dictionary:
	s = s.strip_edges()
	if s.begins_with("flag:"):
		return {"kind": "flag", "key": StringName(s.substr(5).strip_edges())}
	for op in [">=", "<=", "==", ">", "<"]:
		var idx := s.find(op)
		if idx > 0:
			return {
				"kind": "compare",
				"lhs": s.substr(0, idx).strip_edges(),
				"op": op,
				"rhs": s.substr(idx + op.length()).strip_edges(),
			}
	return {"kind": "flag", "key": StringName(s)}


## flag:name  |  npc.memory += token
func _parse_write(s: String) -> Dictionary:
	s = s.strip_edges()
	if s.begins_with("flag:"):
		return {"op": DialogueResource.Op.WRITE, "kind": "flag",
			"key": StringName(s.substr(5).strip_edges())}
	var idx := s.find("+=")
	if idx > 0:
		return {"op": DialogueResource.Op.WRITE, "kind": "memory",
			"target": s.substr(0, idx).strip_edges(),
			"value": s.substr(idx + 2).strip_edges()}
	return {"op": DialogueResource.Op.WRITE, "kind": "flag", "key": StringName(s)}


## compassion+2  |  trust-1
func _parse_eight(s: String) -> Dictionary:
	s = s.strip_edges()
	var sign := 1
	var idx := s.find("+")
	if idx < 0:
		idx = s.find("-")
		sign = -1
	if idx < 0:
		return {"op": DialogueResource.Op.EIGHT, "key": StringName(s), "delta": 0}
	return {
		"op": DialogueResource.Op.EIGHT,
		"key": StringName(s.substr(0, idx).strip_edges()),
		"delta": sign * int(s.substr(idx + 1).strip_edges()),
	}
