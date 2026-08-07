extends Node
## EventBus — the only cross-system communication channel (Architecture Law 5).
##
## Systems never reach across the scene tree. They emit here and listen here.
## Every signal is typed. Adding an untyped signal is a review rejection.

# --- Weave (combat) ---------------------------------------------------------

## Emitted when the tether's state machine changes band.
signal tether_state_changed(from: int, to: int)

## Emitted every frame the tether reads hostile fire. `amount` is post-multiplier.
signal insight_gained(amount: float, danger: bool)

## Emitted when strain crosses 70 (STRAINED) or reaches 100 (SNAPPED).
signal tether_strained()
signal tether_snapped()

## Emitted when SWAP resolves. Carries whether the swap crossed a live projectile,
## which the tutorial and the achievement tracker both listen for.
signal swap_performed(through_fire: bool)

signal self_damaged(amount: int, remaining: int)
signal self_died()
signal ward_slacked()

## Emitted when a companion is removed mid-encounter (the Slack Tether set piece).
## Listeners: HUD (shows "— NOBODY —"), AudioDirector (mutes the L3 stem permanently).
signal companion_severed(companion_id: StringName)

# --- Command phase ----------------------------------------------------------

signal command_chosen(verb: StringName)
signal unknot_attempted(diagnosis_id: StringName, correct: bool)
signal enemy_resolved(enemy_id: StringName, by_mercy: bool)

# --- World ------------------------------------------------------------------

signal bell_count_changed(new_count: int)
signal flag_written(flag: StringName, value: Variant)
signal eight_changed(key: StringName, new_value: int)

## Emitted 19 times in the whole game. AudioDirector ducks everything for 36 frames.
signal severance_occurred(subject_id: StringName)

# --- Audio ------------------------------------------------------------------

## Permanent stem loss. AudioDirector records it and never re-enables it.
signal stem_muted_permanently(stem_id: StringName)
signal choir_voice_silenced(singer_id: StringName)
