# 14 — Technical Architecture (Godot 4.x)

> Full class diagrams, resource schemas, and the complete folder tree are
> **Stage 10 (Programming Architecture)** and **Stage 11 (Folder Structure)**.
> This chapter fixes the engineering decisions that constrain everything else.

---

## 14.1 Engine & Language Decisions

| Decision | Choice | Rationale |
| --- | --- | --- |
| Engine | **Godot 4.3+** (4.x, forward-compatible) | 2D lighting, `TileMapLayer`, resource system, and an export pipeline that hits every target platform |
| Primary language | **GDScript** | Iteration speed dominates for a content-heavy narrative RPG; the team is small |
| Hot-path language | **C# or GDExtension (C++)** for the bullet system only, *if profiling requires it* | Deferred decision. GDScript with pooled, flat-array bullets is expected to hold 2,000 simultaneous projectiles at 60 FPS; we do not pay a language tax until proven necessary. |
| Renderer | **Forward+** (desktop), **Mobile** renderer for Switch/Deck validation | 2D lights + normal maps require Forward+ features on desktop |
| Physics | **None for bullets.** Custom broadphase (uniform grid) | Godot's physics server is wrong for 2,000 bullets. Bullets are data, not nodes. |
| Middleware | **FMOD** (fallback: `AudioStreamInteractive`) | Stem-based reactive score (§11.4). Decision gate at Stage 8. |
| Version control | Git + **Git LFS** for art/audio | |
| CI | GitHub Actions: headless import, unit tests, export to 3 platforms, flag-audit, per PR | |

---

## 14.2 Architectural Principles

1. **Data over code.** Enemies, items, quests, dialogue, and bosses are **Resources**
   (`.tres`), authored in the editor or generated from spreadsheets. Adding the 84th
   enemy must not require writing a script.
2. **Nine AI trunks, not eighty-four.** Enemy behaviour is a family script + a data
   payload (§08.7). Same for bosses: one `BossDirector` interpreting a phase resource.
3. **The bullet system is a subsystem, not a node tree.** Flat `PackedFloat32Array`s,
   pooled, updated in one pass, drawn with `MultiMeshInstance2D`.
4. **All game state is one serializable object.** `GameState` is a single resource tree.
   Save = serialize it. No state hides in nodes. This is what makes 2.1M epilogue
   permutations tractable and what makes QA's flag audit possible.
5. **Signals up, calls down.** Systems never reach across the tree. A global `EventBus`
   autoload carries cross-system events.
6. **Determinism where it matters.** Boss patterns run on a seeded RNG per encounter so
   a death can be reproduced from a save + input log. This is how we debug "unfair
   deaths" (§05.11).

---

## 14.3 Autoloads (the spine)

| Autoload | Responsibility |
| --- | --- |
| `EventBus` | Global typed signals. The only cross-system communication channel. |
| `GameState` | The entire save-able world: the Eight, flags, quests, inventory, NPC memory, music state, route, Bell Count |
| `SaveManager` | Atomic serialize/deserialize, slots, autosave rotation, migration between save versions |
| `SceneRouter` | Scene transitions, room streaming, spawn-point resolution, transition FX |
| `AudioDirector` | Stem state, reactive mixing, transitions, the music-consequence ledger (§11.6) |
| `DialogueRunner` | Executes dialogue resources; tone tags, interrupts, memory writes, history log |
| `ChoiceLedger` | Records every choice; provides the query API for downstream content; **emits an orphan-flag warning in debug builds** |
| `InputRouter` | Remapping, device detection, buffering, accessibility input transforms |
| `Localization` | String tables; all text is externalized from day one |
| `DebugConsole` | Dev-only: jump to any room, set any flag, force any route, replay any boss |

---

## 14.4 Core Systems

### 14.4.1 The Weave (combat) — module map

```
res://systems/weave/
├── weave_controller.gd        # phase state machine: COMMAND ↔ WEAVE
├── self_body.gd               # player glyph, 4px core, SWAP/PULL/PLANT
├── ward_body.gd               # companion glyph; behaviour injected by CompanionProfile
├── tether.gd                  # 6 sample points, state machine, Insight/Strain accounting
├── bullet_system/
│   ├── bullet_pool.gd         # flat arrays, 4096 capacity, zero allocation in-frame
│   ├── bullet_renderer.gd     # MultiMeshInstance2D, one draw call
│   ├── broadphase.gd          # uniform grid, 16px cells
│   └── pattern_player.gd      # interprets PatternResource
├── command_menu.gd            # 8 verbs
├── unknot_system.gd           # evidence gathering, diagnosis menu, escalation
└── boss_director.gd           # phase resource interpreter, dialogue hooks, rage triggers
```

**The bullet update loop** — one function, no per-bullet nodes:

```gdscript
func _physics_process(delta: float) -> void:
    _pattern_player.tick(delta)                 # may append to pool
    _pool.integrate(delta)                      # position += velocity, one pass
    _broadphase.rebuild(_pool)                  # uniform grid, 16px cells
    var hits := _broadphase.query_point(_self.core_position, SELF_RADIUS)
    if hits.size() > 0 and not _self.invulnerable:
        _resolve_self_hit(hits[0])
    var reads := _broadphase.query_polyline(_tether.sample_points(), TETHER_RADIUS)
    _tether.accrue(reads, delta)                # Insight + Strain in one place
    _pool.cull_offscreen()
```

Everything expensive is one pass over flat memory. Target: **2,000 bullets, ≤1.2ms/frame.**

### 14.4.2 Companion abstraction

```gdscript
class_name CompanionProfile extends Resource
@export var id: StringName
@export var tether_mode: TetherMode        # SPRING / ROD / GHOST / THREAD / CURRENT / SIGNAL
@export var mass_multiplier: float
@export var insight_multiplier: float
@export var strain_resist: float
@export var collision_enabled: bool
@export var ward_act: WardActResource
@export var attune: AttuneResource
@export var motif_stem: StringName          # which L3 variation the AudioDirector plays
@export var death_lines: Array[DialogueRef] # per act × 3 variants
```

Adding a companion = authoring one resource + one WardAct + one Attune + art + stems.
**No engine change.** This is what makes route-exclusive companions affordable.

### 14.4.3 Dialogue

- Custom format compiled to a Resource. Not an off-the-shelf plugin — the tone-tag,
  interrupt, memory-write, and Reading-query requirements are too specific.
- Syntax sketch:

```
@node halden_act3_returned
  @require flag:wife_returned  reading:halden >= warm
  HALDEN [tired] "You're the one who did it."
  HALDEN "I've been trying to work out how to thank someone for a thing I —"
  [INTERRUPT] AVEN [careful] "You don't have to."
  HALDEN "No. I do. That's the whole — that's what came back."
  @write halden.memory += thanked_aven
  @choice
    -> WARM  "Is she home?"        @goto halden_wife_home
    -> QUIET "..."                 @goto halden_silence  @eight compassion+2
    -> BLUNT "Was it worth it?"    @goto halden_worth    @eight resolve+2 trust-1
```

- **Every line carries a speaker, an expression, and an optional tone tag.** Every
  choice can write to the Eight, to flags, and to NPC memory.
- The compiler emits a **coverage report**: unreachable nodes, orphan flags, and choices
  with no downstream read — enforcing §06.6.2 at build time.

### 14.4.4 The Eight & the Reading system

```gdscript
class_name EightValues extends Resource
# compassion trust curiosity fear hope resolve mercy wrath : int 0..100

class_name NPCProfile extends Resource
@export var reading_bias: Dictionary       # {&"wrath": 1.8, &"mercy": -0.4}
@export var reading_table: ReadingTable    # score bands → StringName buckets
@export var memory_weight: float
@export var hearsay_delay_regions: int     # how long news takes to reach them
```

Hearsay propagation is a scheduled job on region transition — a small directed graph of
regions with travel-time weights. The March has weight 0 (it moves; it hears first).

### 14.4.5 Save & migration

- `GameState` → dictionary → JSON → zstd → CRC → atomic write.
- **Versioned migrations** from day one: `migrations/v1_to_v2.gd` etc. A player who
  starts on patch 1.0 must finish on 1.4 without losing a run. This is a launch-quality
  requirement for a game we expect people to replay for months.

---

## 14.5 Performance Budget (per frame, 60 FPS = 16.6ms)

| Subsystem | Budget | Notes |
| --- | --- | --- |
| Bullet integrate + broadphase + collision | 1.2 ms | 2,000 bullets |
| Bullet render | 0.4 ms | Single `MultiMesh` draw call |
| 2D lighting + shadows | 3.5 ms | Worst case: Grieving Wood, 9 lights + occluders |
| Environment shaders (wind, water, ash) | 1.8 ms | |
| Tilemap + sprites | 2.0 ms | |
| Post (LUT, grade, god-rays, pixel snap) | 2.2 ms | |
| GDScript game logic | 2.0 ms | |
| Audio | 0.8 ms | |
| **Headroom** | **2.7 ms** | Reserved. Not spent without a review. |

**Reference hardware:** Intel UHD 620 / Steam Deck. If the Deck holds 60, everything
holds 60.

---

## 14.6 Testing & QA Tooling

| Tool | Purpose |
| --- | --- |
| **Flag Audit** | Static pass over dialogue + quest resources; fails CI on any flag written but read <3 times across <2 acts (§06.6.2) |
| **Route Prover** | Headless simulation that drives all three routes to all five endings; asserts no unreachable content and no softlocks |
| **Music State Diff** | Dumps active stems per region per save; verifies no muted stem is ever re-enabled (§11.6) |
| **Unfair Death Log** | On death, records the last 3s of bullet state + input; P1 triage if the killing projectile had <12 frames of telegraph |
| **Pattern Replayer** | Seeded RNG + input log → exact reproduction of any death |
| **Text Audit** | Flags any line appearing in >1 place, any line under 3 words without a `[BEAT]` tag, and any NPC with <3 conversation stages |
| **Greyscale/CVD Gate** | Renders every room through 4 LUTs; art review blocks on failure |
| **Perf Sentinel** | Per-scene frame-time regression tracking in CI on reference hardware |

---

## 14.7 Folder Structure (top level — full tree in Stage 11)

```
secondheart/
├── project.godot
├── autoload/            # 10 autoloads (§14.3)
├── systems/
│   ├── weave/           # combat
│   ├── dialogue/        # runner + compiler
│   ├── quest/
│   ├── save/
│   ├── audio/
│   ├── choice/
│   └── accessibility/
├── data/                # ALL content as .tres — no content in code
│   ├── enemies/         # 84, grouped by 9 families
│   ├── bosses/          # 17 phase resources
│   ├── companions/      # 5 CompanionProfiles
│   ├── items/           # 118 items
│   ├── quests/          # 35
│   ├── dialogue/        # per region, compiled from .sh source files
│   ├── npcs/            # 46 NPCProfiles
│   ├── patterns/        # bullet patterns, shared library
│   └── music/           # stem maps + reactive rules
├── scenes/
│   ├── regions/         # 14 regions, ~180 rooms
│   ├── ui/
│   ├── weave/
│   └── cutscenes/
├── art/                 # LFS
├── audio/               # LFS
├── shaders/
├── localization/
├── tools/               # editor plugins, the 8 QA tools, spreadsheet importers
└── tests/               # GUT unit tests + headless integration
```

**The rule that keeps this clean:** `data/` contains no logic and `systems/` contains no
content. A designer can ship a new enemy, quest, or boss without touching `systems/`,
and a programmer can refactor `systems/` without touching a word of writing.
