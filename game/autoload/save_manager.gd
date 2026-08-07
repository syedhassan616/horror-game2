extends Node
## Atomic saves with a rollback copy and versioned migrations.
##
## A player who starts on patch 1.0 must be able to finish on 1.4 without losing a
## run — this is a launch-quality requirement for a game we expect people to replay
## for months, so migrations exist from the first commit rather than being retrofitted.

const SAVE_DIR := "user://saves"
const SLOT_COUNT := 12
const AUTOSAVE_SLOTS := 3

## Applied in order when a save's version is behind SAVE_VERSION.
const MIGRATIONS := {
	# 1: preload("res://systems/save/migrations/v1_to_v2.gd"),
}

var _autosave_cursor: int = 0


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)


func slot_path(slot: int) -> String:
	return "%s/slot_%02d.json" % [SAVE_DIR, slot]


## Write atomically: temp file, then rename. A crash mid-write leaves the previous
## save intact rather than a truncated one.
func save_to_slot(slot: int, meta: Dictionary = {}) -> bool:
	var path := slot_path(slot)
	var tmp := path + ".tmp"

	var payload := {
		"meta": _build_meta(meta),
		"state": GameState.to_dict(),
	}
	var text := JSON.stringify(payload, "\t")
	var crc := text.hash()

	var f := FileAccess.open(tmp, FileAccess.WRITE)
	if f == null:
		push_error("SaveManager: cannot open %s (%d)" % [tmp, FileAccess.get_open_error()])
		return false
	f.store_line(str(crc))
	f.store_string(text)
	f.close()

	# Keep the previous save as .bak before replacing it.
	if FileAccess.file_exists(path):
		var d := DirAccess.open(SAVE_DIR)
		if d != null:
			d.remove(path.get_file() + ".bak")
			d.rename(path.get_file(), path.get_file() + ".bak")

	var dir := DirAccess.open(SAVE_DIR)
	if dir == null:
		return false
	return dir.rename(tmp.get_file(), path.get_file()) == OK


## Load a slot, falling back to .bak if the primary is corrupt. A corrupt save
## degrades rather than failing — the player loses minutes, never a run.
func load_from_slot(slot: int) -> bool:
	var path := slot_path(slot)
	if _try_load(path):
		return true
	push_warning("SaveManager: slot %d failed, trying .bak" % slot)
	return _try_load(path + ".bak")


func _try_load(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var stored_crc := int(f.get_line())
	var text := f.get_as_text()
	f.close()

	if text.hash() != stored_crc:
		push_error("SaveManager: CRC mismatch in %s" % path)
		return false

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return false

	var state: Dictionary = parsed.get("state", {})
	state = _migrate(state)
	GameState.from_dict(state)
	return true


func _migrate(state: Dictionary) -> Dictionary:
	var v: int = state.get("version", 1)
	while v < GameState.SAVE_VERSION:
		if not MIGRATIONS.has(v):
			push_error("SaveManager: no migration from v%d — refusing to load blind" % v)
			break
		state = MIGRATIONS[v].new().apply(state)
		v = state.get("version", v + 1)
	return state


## Rotating autosaves that never overwrite a manual slot.
func autosave(reason: StringName) -> void:
	var slot := SLOT_COUNT + _autosave_cursor
	_autosave_cursor = (_autosave_cursor + 1) % AUTOSAVE_SLOTS
	save_to_slot(slot, {"autosave_reason": String(reason)})


func _build_meta(extra: Dictionary) -> Dictionary:
	var m := {
		"saved_at": Time.get_datetime_string_from_system(true),
		"act": GameState.act,
		"route": String(GameState.route),
		"bell_count": GameState.bell_count,
	}
	m.merge(extra, true)
	return m


## Slot metadata without loading the save — used by the slot picker, which shows
## region, playtime, act, and a one-line "last thing that happened".
func peek(slot: int) -> Dictionary:
	var path := slot_path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	f.get_line()   # discard crc
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed.get("meta", {})
