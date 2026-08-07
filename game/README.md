# SECONDHEART — Godot 4.3 Project

Two things are playable: **the Prologue** (the story, end to end) and **the Tether
harness** (the combat mechanic in isolation).

Neither has art or audio. That is not a placeholder for something prettier — the
point of building these first is to find out whether the scene and the mechanic
work *before* anyone spends eighteen months drawing them.

---

## Running it

Requires **Godot 4.3+**. No addons, no build step.

```bash
godot --path game                                             # THE PROLOGUE (default)
godot --path game res://scenes/weave/weave_test.tscn          # the tether harness

godot --headless --path game res://tests/test_scene.tscn        # 60 unit tests
godot --headless --path game res://tests/playthrough_scene.tscn # scripted Prologue run
godot --headless --path game res://tests/bench_scene.tscn       # bullet bench
```

## The Prologue

~10 minutes. You wake in a drawer, in an archive of hearts nobody came back for.
Walk right, read drawers, find Ledgerman Osk, talk to him twice.

| Input | Action |
| --- | --- |
| `WASD` / arrows | Walk |
| `E` | Interact |
| `Enter` / `E` | Advance dialogue |
| Click | Pick a dialogue option |

**Two drawers matter and the game never says which.** One is stamped `RESERVED`,
dated nine hundred years before you were born. One belongs to Ilsabet Vane, whose
husband declined to collect her — *"I'd only lose it again."*

Talk to Osk about his wife. Then keep talking to him. What happens next is the
whole game's argument, it takes ninety seconds, and nothing announces it.

---

## The Tether harness — controls

| Input | Action |
| --- | --- |
| `WASD` / arrows | Move Self |
| `Space` | **SWAP** — exchange Self and Ward, 6 i-frames |
| `Ctrl` | **PULL** — snap Ward to Self |
| `Alt` | **PLANT** — root the Ward |
| `Shift` | Run (Self moves at 168 px/s instead of 84) |
| `1`–`5` | Swap companion (Tilly / Moth / Barro / Sennet / Rue) |
| `S` | Trigger the Slack Tether set piece |
| `R` | Reset |

Press `1` then `2` back to back. Tilly's rigid rod and Moth's collisionless ghost are
the same button producing two different games — that is Pillar I, and it is the thing
to judge the prototype on.

---

## What is implemented

| System | File | Status |
| --- | --- | --- |
| **Dialogue parser** (.sh format) | `systems/dialogue/dialogue_parser.gd` | ✅ 14 tests |
| **Dialogue runner** | `autoload/dialogue_runner.gd` | ✅ playthrough-tested |
| **Dialogue UI** | `scenes/ui/dialogue_box.gd` | ✅ runs |
| **Overworld + interactables** | `systems/overworld/` | ✅ runs |
| **The Prologue** | `scenes/regions/unc/prologue.gd` | ✅ **playable** |
| Bullet pool (flat arrays, 4096) | `systems/weave/bullet_system/bullet_pool.gd` | ✅ tested + benched |
| Spatial grid | `systems/weave/bullet_system/broadphase.gd` | ✅ tested + benched |
| Pattern interpreter (6 emitters) | `systems/weave/bullet_system/pattern_player.gd` | ✅ runs |
| **The Tether** (Insight/Strain economy) | `systems/weave/tether.gd` | ✅ 13 tests |
| Self body (SWAP/PULL/buffering/i-frames) | `systems/weave/self_body.gd` | ✅ runs |
| Ward body (6 tether modes) | `systems/weave/ward_body.gd` | ✅ runs |
| Encounter state machine | `systems/weave/weave_controller.gd` | ✅ runs |
| UNKNOT (anti-spam contract) | `systems/weave/unknot_system.gd` | ✅ 9 tests |
| GameState + the Eight + routes | `autoload/game_state.gd` | ✅ 12 tests |
| Atomic saves + migrations | `autoload/save_manager.gd` | ✅ runs |
| EventBus | `autoload/event_bus.gd` | ✅ |
| Input router + accessibility hooks | `autoload/input_router.gd` | ✅ |
| Companion data (5 profiles) | `data/companions/companion_profile.gd` | ✅ |
| Enemy data + diagnoses | `data/enemies/enemy_profile.gd` | ✅ |

**Not yet built:** all art and audio, the command-phase menu, `MultiMeshInstance2D`
rendering, the boss director, quests, the other 14 regions, and ~95,000 of the
96,000 words. Those are Production A/B work.

---

## The tests exist for one reason

The Insight economy is the design. If a slack tether can out-earn a taut one, the
game's morality inverts and pacifism becomes the lazy option instead of the brave
one. Several tests guard exactly that, and they are the reason to run them on every
change:

- `SLACK yields zero insight`
- `TAUT must out-earn LIVE — greed is the design`
- `a shot that would have hit Self pays double`
- `polyline query deduplicates overlapping samples`
- `a burned option is removed from the list`
- `guessing sets the hidden superboss condition, silently`

---

## Performance

Benchmarked, not estimated. See `tests/bench_runner.gd`.

| Bullets | integrate | grid | queries | total |
| --- | --- | --- | --- | --- |
| 1,000 | 0.30 | 0.38 | 0.05 | **0.72 ms** |
| 2,000 | 0.58 | 0.73 | 0.08 | **1.38 ms** |

Two findings worth carrying forward, both documented in the code:

1. **No function calls in per-bullet loops.** Inlining one helper took the grid
   rebuild from 1.73 ms → 0.73 ms. GDScript call overhead dominated the arithmetic.
2. **Never write through a PackedArray alias.** Safe for reads, silently catastrophic
   for writes — copy-on-write detaches the alias and every bullet freezes in place.

2,000 bullets occurs once in the whole game (the First Ward's phase 7); everything
else tops out at 900. The GDExtension decision stays deferred to the Production A gate.
