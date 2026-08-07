extends Node
## Remapping, device detection, buffering config, and accessibility input transforms.
##
## Every hold input can be made a toggle individually, and every verb is bindable to
## a single button that works on a Steam Deck — if a tether verb cannot be bound
## comfortably to a Deck, the verb is wrong. That is checked at combat design review,
## not at port time.

enum Device { KEYBOARD, XBOX, PLAYSTATION, SWITCH, GENERIC }

signal device_changed(device: Device)

const REBINDABLE: Array[StringName] = [
	&"move_up", &"move_down", &"move_left", &"move_right",
	&"weave_swap", &"weave_pull", &"weave_plant",
	&"interact", &"cancel", &"journal", &"pause",
]

var current_device: Device = Device.KEYBOARD

## Accessibility. 6 frames default, 12 for players who need it.
var input_buffer_frames: int = 6
## Per-action hold-to-toggle conversion.
var toggle_actions: Dictionary = {}
## Optional assist: fires SWAP automatically on a lethal frame, once per 3s.
var auto_swap_assist: bool = false
## CARRY ME — dodging fully automated. Not an easy mode: a different input contract.
## All 17 bosses, all 5 endings, all secrets remain reachable, and the achievement
## list does not distinguish.
var carry_me: bool = false

var _toggle_state: Dictionary = {}


func _input(event: InputEvent) -> void:
	var d := current_device
	if event is InputEventKey or event is InputEventMouse:
		d = Device.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		d = _detect_pad()
	if d != current_device:
		current_device = d
		device_changed.emit(d)


func _detect_pad() -> Device:
	var name := Input.get_joy_name(0).to_lower()
	if name.contains("xbox") or name.contains("xinput"):
		return Device.XBOX
	if name.contains("playstation") or name.contains("dualsense") or name.contains("dualshock"):
		return Device.PLAYSTATION
	if name.contains("switch") or name.contains("nintendo"):
		return Device.SWITCH
	return Device.GENERIC


## Read an action honouring its hold/toggle setting, so the rest of the game never
## has to care which mode the player chose.
func pressed(action: StringName) -> bool:
	if not toggle_actions.get(action, false):
		return Input.is_action_pressed(action)
	if Input.is_action_just_pressed(action):
		_toggle_state[action] = not _toggle_state.get(action, false)
	return _toggle_state.get(action, false)


func rebind(action: StringName, event: InputEvent) -> bool:
	if action not in REBINDABLE:
		push_warning("InputRouter: %s is not rebindable" % action)
		return false
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	return true


func reset_to_defaults() -> void:
	InputMap.load_from_project_settings()
	_toggle_state.clear()
