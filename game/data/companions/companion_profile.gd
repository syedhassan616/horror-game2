class_name CompanionProfile
extends Resource
## A companion is a data file. Adding one requires no engine change.
##
## Each companion rewrites the player's movement verb set, which is why losing one
## mid-game removes a capability the player had built muscle memory around — grief
## delivered as motor confusion (GDD Pillar I).

@export var id: StringName = &""
@export var display_name: String = ""

## Selects the WardBody behaviour. See WardBody.Mode.
@export_enum("SPRING", "ROD", "GHOST", "THREAD", "CURRENT", "SIGNAL")
var tether_mode: int = 0

@export var ward_hp: int = 20
@export var mass_multiplier: float = 1.0
@export var insight_multiplier: float = 1.0
@export var strain_resist: float = 0.0
## GHOST (Moth) has no Ward collision — projectiles pass through the glyph, but the
## tether still reads them, at double yield. Highest Insight/sec, most fragile.
@export var collision_enabled: bool = true

## Which L3 "Two Beats" variation the AudioDirector plays in the current region
## theme. Removed permanently from the whole soundtrack if this companion is severed.
@export var motif_stem: StringName = &""

@export var ward_act_id: StringName = &""
@export var attune_id: StringName = &""
@export var attune_cost: float = 60.0

## Per act, three variants each. Delivered on player death as this companion
## catching you — never a game-over screen.
@export var death_lines: Array[String] = []


static func tilly() -> CompanionProfile:
	var p := CompanionProfile.new()
	p.id = &"tilly"
	p.display_name = "Tilly Brack"
	p.tether_mode = 1                  # ROD
	p.ward_hp = 34
	p.mass_multiplier = 3.0
	p.insight_multiplier = 0.5
	p.strain_resist = 3.6
	p.motif_stem = &"l3_tilly"
	p.ward_act_id = &"hold_the_line"
	p.attune_id = &"full_peal"
	p.death_lines = [
		"Get up. That's not — get up, I've got the rope.",
		"You're heavier than you look.",
		"That was my fault. I'll do it different.",
	]
	return p


static func moth() -> CompanionProfile:
	var p := CompanionProfile.new()
	p.id = &"moth"
	p.display_name = "Moth"
	p.tether_mode = 2                  # GHOST
	p.ward_hp = 12
	p.mass_multiplier = 0.6
	p.insight_multiplier = 2.0
	p.strain_resist = 0.0
	p.collision_enabled = false
	p.motif_stem = &"l3_moth"
	p.ward_act_id = &"borrowed"
	p.attune_id = &"everyone_at_once"
	# Moth's death lines are selected at runtime from the Journal's "Things People
	# Said" by emotional weight. On the fourth death in one encounter it quotes Aven.
	p.death_lines = []
	return p


static func barro() -> CompanionProfile:
	var p := CompanionProfile.new()
	p.id = &"barro"
	p.display_name = "Barro"
	p.tether_mode = 3                  # THREAD
	p.ward_hp = 26
	p.mass_multiplier = 1.2
	p.insight_multiplier = 1.5
	p.strain_resist = 1.0
	p.motif_stem = &"l3_barro"
	p.ward_act_id = &"reinforce"
	p.attune_id = &"forty_one_days"
	p.death_lines = [
		"Right — hold still, hold still, that's — no, that's fine, that'll hold.",
		"I've patched worse. I've patched worse on a Tuesday.",
		"...Sorry. Sorry. Give me a second.",
	]
	return p


static func sennet() -> CompanionProfile:
	var p := CompanionProfile.new()
	p.id = &"sennet"
	p.display_name = "Sennet"
	p.tether_mode = 4                  # CURRENT
	p.ward_hp = 22
	p.mass_multiplier = 0.9
	p.insight_multiplier = 1.0
	p.strain_resist = 1.5
	p.motif_stem = &"l3_sennet"
	p.ward_act_id = &"undertow"
	p.attune_id = &"held_breath"
	p.death_lines = ["Breathe."]
	return p


static func rue() -> CompanionProfile:
	var p := CompanionProfile.new()
	p.id = &"rue"
	p.display_name = "Captain Rue Alderman"
	p.tether_mode = 5                  # SIGNAL
	p.ward_hp = 28
	p.mass_multiplier = 1.0
	p.insight_multiplier = 1.0         # x3 in the unsafe lane, applied by SignalLane
	p.strain_resist = 0.0
	p.motif_stem = &"l3_rue"
	p.ward_act_id = &"reroute"
	p.attune_id = &"never_once_stopped"
	p.death_lines = [
		"Up. We're behind.",
		"That's a scheduling problem. I do those.",
		"Get up. ...Please.",
	]
	return p
