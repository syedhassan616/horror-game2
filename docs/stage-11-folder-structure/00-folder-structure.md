# SECONDHEART — Folder Structure (Stage 11)

**The rule that keeps this clean:** `data/` contains no logic, `systems/` contains no
content. A designer ships a new enemy, quest, or boss without touching `systems/`. A
programmer refactors `systems/` without touching a word of writing.

---

## 11.1 The Tree

```
game/
├── project.godot
├── export_presets.cfg
├── .gitattributes                  # LFS: *.png *.aseprite *.wav *.ogg
│
├── autoload/                       # 10 autoloads, load order = dependency order
│   ├── event_bus.gd
│   ├── game_state.gd
│   ├── save_manager.gd
│   ├── scene_router.gd
│   ├── audio_director.gd
│   ├── dialogue_runner.gd
│   ├── choice_ledger.gd
│   ├── input_router.gd
│   ├── localization.gd
│   └── debug_console.gd
│
├── systems/                        # LOGIC ONLY. No content.
│   ├── weave/
│   │   ├── weave_controller.gd
│   │   ├── self_body.gd
│   │   ├── ward_body.gd
│   │   ├── tether.gd
│   │   ├── command_menu.gd
│   │   ├── unknot_system.gd
│   │   ├── boss_director.gd
│   │   └── bullet_system/
│   │       ├── bullet_pool.gd
│   │       ├── bullet_renderer.gd
│   │       ├── broadphase.gd
│   │       └── pattern_player.gd
│   ├── dialogue/
│   │   ├── dialogue_resource.gd
│   │   ├── dialogue_parser.gd
│   │   └── condition_evaluator.gd
│   ├── quest/
│   │   ├── quest_resource.gd
│   │   └── quest_tracker.gd
│   ├── save/
│   │   ├── game_state_data.gd
│   │   ├── serializer.gd
│   │   └── migrations/
│   │       └── v1_to_v2.gd
│   ├── audio/
│   │   ├── stem_map.gd
│   │   └── reactive_rule.gd
│   ├── choice/
│   │   ├── eight_values.gd
│   │   └── reading_table.gd
│   ├── world/
│   │   ├── region_state.gd
│   │   └── hearsay_graph.gd
│   └── accessibility/
│       ├── carry_me.gd             # automated dodging
│       └── puzzle_assist.gd
│
├── data/                           # CONTENT ONLY. No logic.
│   ├── companions/                 # 5 CompanionProfile
│   ├── enemies/
│   │   ├── clerical/               # 11
│   │   ├── bellwork/               # 8
│   │   ├── rootbound/              # 10
│   │   ├── willing/                # 7
│   │   ├── saltborne/              # 9
│   │   ├── loomkin/                # 12
│   │   ├── sunken/                 # 9
│   │   ├── orbital/                # 8
│   │   └── unread/                 # 10
│   ├── bosses/                     # 17 phase resources
│   ├── patterns/                   # 56 shared PatternResource
│   ├── items/                      # 118 + 84 keepsakes
│   ├── quests/                     # 35
│   ├── puzzles/                    # 71
│   ├── npcs/                       # 46 NPCProfile
│   ├── dialogue/
│   │   ├── src/                    # .sh source — THE WRITERS' FOLDER
│   │   │   ├── prologue.sh
│   │   │   ├── wyndmarrow.sh
│   │   │   └── ...
│   │   └── compiled/               # .tres, generated, gitignored
│   └── music/
│       ├── stem_maps/              # 34
│       └── reactive_rules/
│
├── scenes/
│   ├── regions/                    # 15 regions, ~192 rooms
│   │   ├── unc/ wyn/ grv/ hsh/ slt/ vrk/ chr/ mar/ orr/ cmn/ ash/ asy/ kep/ und/ ren/
│   ├── weave/                      # arena scenes
│   ├── ui/                         # 13 screens
│   └── cutscenes/
│
├── art/                            # LFS
│   ├── palettes/
│   ├── tilesets/                   # albedo + normal + emissive + occluder per region
│   ├── characters/
│   ├── portraits/
│   ├── enemies/
│   ├── bosses/
│   ├── vfx/
│   └── ui/
│
├── audio/                          # LFS
│   ├── music/stems/
│   ├── sfx/
│   ├── ambience/
│   └── babble/
│
├── shaders/                        # 16
├── fonts/                          # registry, hand, dyslexic-alt
├── localization/                   # 10 languages, CSV
│
├── tools/                          # editor plugins + the 8 QA tools
│   ├── dialogue_compiler/
│   ├── flag_audit/
│   ├── route_prover/
│   ├── music_state_diff/
│   ├── unfair_death_log/
│   ├── pattern_replayer/
│   ├── text_audit/
│   ├── cvd_gate/
│   ├── perf_sentinel/
│   └── aseprite_importer/
│
└── tests/
    ├── unit/                       # GUT
    └── integration/                # headless
```

---

## 11.2 Naming Conventions

| Thing | Convention | Example |
| --- | --- | --- |
| Scripts | `snake_case.gd` | `bullet_pool.gd` |
| Classes | `PascalCase` via `class_name` | `class_name BulletPool` |
| Scenes | `snake_case.tscn` | `wyn_04_tower_base.tscn` |
| Resources | `snake_case.tres` | `clr_01_filing_error.tres` |
| Rooms | `RGN-##` in the filename | `wyn_04_*`, `kep_02_*` |
| Enemies | `<family>_<nn>_<name>` | `lmk_09_slub.tres` |
| Signals | past tense | `companion_severed`, `stem_muted` |
| Flags | `noun_verb` or `noun_state` | `osk_severed`, `forge_open` |
| Booleans | `is_` / `has_` / `can_` | `is_invulnerable` |
| Private | leading underscore | `_pool`, `_rebuild_grid()` |

---

## 11.3 Git & LFS

```gitattributes
*.png      filter=lfs diff=lfs merge=lfs -text
*.aseprite filter=lfs diff=lfs merge=lfs -text
*.wav      filter=lfs diff=lfs merge=lfs -text
*.ogg      filter=lfs diff=lfs merge=lfs -text
*.sh       text eol=lf          # dialogue source stays diffable
*.tres     text eol=lf          # resources stay diffable and mergeable
```

**`.tres` stays text.** Godot resources merge badly but review *well*, and a designer
changing an enemy's HP should show up in a diff as one line.

**Gitignored:** `data/dialogue/compiled/`, `.godot/`, `export/`.

---

## 11.4 CI

```yaml
on: [pull_request]
jobs:
  verify:
    - godot --headless --import
    - godot --headless --script tools/dialogue_compiler/cli.gd
    - godot --headless --script tools/flag_audit/cli.gd        # fails on orphans
    - godot --headless --script tools/text_audit/cli.gd
    - godot --headless --script tools/route_prover/cli.gd      # 3 routes → 5 endings
    - godot --headless --script tools/music_state_diff/cli.gd
    - gut -gdir=res://tests -gexit
    - godot --headless --export-release "Linux/X11"
    - godot --headless --export-release "Windows Desktop"
    - godot --headless --export-release "macOS"
```

**Every PR runs the full gate.** The Route Prover is the slow one (~6 minutes) and it is
worth it: it is the only thing standing between us and an unreachable ending discovered
by a player.

---

## 11.5 Where Each Discipline Works

| Role | Folder | Never touches |
| --- | --- | --- |
| Narrative | `data/dialogue/src/`, `data/quests/`, `data/npcs/` | `systems/` |
| Combat design | `data/patterns/`, `data/enemies/`, `data/bosses/` | `systems/` |
| Environment art | `art/tilesets/`, `scenes/regions/` | `data/` |
| Character art | `art/characters/`, `art/portraits/`, `art/enemies/` | — |
| Audio | `audio/`, `data/music/` | `systems/audio/` |
| Programming | `systems/`, `autoload/`, `tools/`, `shaders/` | `data/` content |
| UX | `scenes/ui/`, `localization/` | — |
| QA | `tests/`, `tools/` | — |

**Two people should almost never be editing the same file.** The folder split is designed
around merge conflicts as much as around architecture.
