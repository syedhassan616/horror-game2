# SECONDHEART — Programming Architecture (Stage 10)

Expands GDD §14 into implementation specification. **Stage 12 implements this document**;
where the two differ, the code is authoritative and this document gets corrected.

---

## 10.1 The Five Architectural Laws

1. **Data over code.** Enemies, items, quests, dialogue, bosses, patterns are `Resource`
   files. Adding the 84th enemy must not require writing a script.
2. **Nine AI trunks, not eighty-four.** Behaviour is a family script + a data payload.
3. **The bullet system is a subsystem, not a node tree.** Flat arrays, pooled, one update
   pass, one draw call.
4. **All game state is one serializable object.** `GameState` is a single tree. Save =
   serialise it. **No state hides in nodes.**
5. **Signals up, calls down.** Systems never reach across the tree; `EventBus` carries
   cross-system events.

Law 4 is what makes 2.1M epilogue permutations tractable and QA's flag audit possible.
Law 3 is what makes 2,000 bullets possible in GDScript.

---

## 10.2 Autoloads

| Autoload | Responsibility | Depends on |
| --- | --- | --- |
| `EventBus` | Typed global signals. The only cross-system channel. | — |
| `GameState` | The entire save-able world | EventBus |
| `SaveManager` | Atomic serialise/deserialise, slots, autosave, migrations | GameState |
| `SceneRouter` | Transitions, room streaming, spawn resolution | GameState, EventBus |
| `AudioDirector` | Stem state, reactive mixing, the permanence ledger | GameState, EventBus |
| `DialogueRunner` | Executes dialogue resources; tone, interrupts, memory writes | GameState, EventBus |
| `ChoiceLedger` | Records choices; query API; **orphan-flag warnings in debug** | GameState |
| `InputRouter` | Remapping, device detect, buffering, accessibility transforms | — |
| `Localization` | String tables; all text externalised from day one | — |
| `DebugConsole` | Dev-only: jump to room, set flag, force route, replay boss | all |

**Load order is dependency order.** `EventBus` first, `DebugConsole` last.

---

## 10.3 The Weave — Module Map

```
systems/weave/
├── weave_controller.gd      # COMMAND ↔ WEAVE state machine
├── self_body.gd             # 4px core, SWAP/PULL/PLANT, i-frames
├── ward_body.gd             # behaviour injected by CompanionProfile
├── tether.gd                # 6 samples, state machine, Insight/Strain accounting
├── bullet_system/
│   ├── bullet_pool.gd       # flat arrays, 4096, zero in-frame allocation
│   ├── bullet_renderer.gd   # MultiMeshInstance2D, one draw call
│   ├── broadphase.gd        # uniform grid, 16px cells
│   └── pattern_player.gd    # interprets PatternResource
├── command_menu.gd          # 8 verbs
├── unknot_system.gd         # evidence, diagnosis, escalation
└── boss_director.gd         # phase resource interpreter
```

### The update loop

```gdscript
func _physics_process(delta: float) -> void:
    _pattern_player.tick(delta)                     # may append to pool
    _pool.integrate(delta)                          # position += velocity, one pass
    _broadphase.rebuild(_pool)                      # uniform grid, 16px cells
    var hit := _broadphase.query_point(_self.core_position, SELF_RADIUS)
    if hit >= 0 and not _self.invulnerable:
        _resolve_self_hit(hit)
    var reads := _broadphase.query_polyline(_tether.sample_points(), TETHER_RADIUS)
    _tether.accrue(reads, delta)                    # Insight + Strain in one place
    _pool.cull_offscreen()
```

### Why not Godot physics
`Area2D` per bullet costs ~4 µs of engine overhead each; at 2,000 that is 8 ms before any
game logic. **Bullets are data.**

### Measured performance — the 1.2 ms budget does not hold at 2,000

Stage 12 implemented this and benchmarked it (`game/tests/bench_runner.gd`). The original
1.2 ms target was an estimate; these are numbers.

| Bullets | integrate | grid rebuild | queries | **total** | vs budget |
| --- | --- | --- | --- | --- | --- |
| 500 | 0.15 | 0.19 | 0.04 | **0.38 ms** | ✅ |
| 1,000 | 0.30 | 0.38 | 0.05 | **0.72 ms** | ✅ |
| 2,000 | 0.58 | 0.73 | 0.08 | **1.38 ms** | ❌ 15% over |
| 4,000 | 1.19 | 1.51 | 0.14 | **2.85 ms** | ❌ |

*(Headless CPU timing on a cloud runner, which is likely faster than a Steam Deck. Treat
these as a floor, not a ceiling.)*

**Two optimisation findings worth keeping:**

1. **No function calls in per-bullet loops.** The grid rebuild originally called a
   `_cell_index()` helper per bullet. Inlining it took the rebuild from **1.73 ms → 0.73 ms**
   — GDScript call overhead dominated the actual arithmetic.
2. **Never write through a PackedArray alias.** Aliasing `pos_x` into a local to skip
   property lookups is safe for *reads* and silently catastrophic for *writes*:
   PackedArrays are copy-on-write, so writes detach into a private copy and every bullet
   freezes in place. The broadphase may alias because it only reads; `integrate()` must not.
   This is documented in the code because it costs an afternoon to rediscover.

**Consequence for the design.** 2,000 simultaneous bullets occurs in exactly one place in
the game — the First Ward's phase 7. Everything else tops out at 900. So:

- **The budget holds for ~99% of the game** with margin.
- **The superboss's final phase needs a decision** at the Production A gate: reduce its
  authored density to ~1,400, or move `integrate()` + `rebuild()` to GDExtension. The
  architecture already isolates both behind `BulletPool`/`Broadphase`, so the port is
  contained and does not touch gameplay code.
- **Revised budget: 1.6 ms**, taken from the reserved headroom (§10.9), pending that gate.

### The 120 Hz substep
The tether spring at `k=14` is unstable at a single 60 Hz Euler step — ANCHOR's rod mode
oscillates visibly. Two substeps per frame at fixed `h = 1/120` fixes it. This is a
correctness requirement, not a polish item.

---

## 10.4 Companion Abstraction

```gdscript
class_name CompanionProfile extends Resource
@export var id: StringName
@export var tether_mode: TetherMode      # SPRING/ROD/GHOST/THREAD/CURRENT/SIGNAL
@export var mass_multiplier: float
@export var insight_multiplier: float
@export var strain_resist: float
@export var collision_enabled: bool
@export var ward_act: WardActResource
@export var attune: AttuneResource
@export var motif_stem: StringName
@export var death_lines: Array[DialogueRef]
```

**Adding a companion = one resource + one WardAct + one Attune + art + stems. No engine
change.** This is what makes route-exclusive companions affordable.

---

## 10.5 GameState

```gdscript
class_name GameStateData extends Resource
@export var version: int = 1
@export var eight: Dictionary            # the 8 hidden values, 0..100
@export var flags: Dictionary            # StringName -> Variant
@export var quests: Dictionary           # id -> QuestState
@export var npcs: Dictionary             # id -> NPCState (memory, stage, severance)
@export var inventory: InventoryState
@export var party: PartyState
@export var music: MusicState            # incl. permanently_muted, silenced_voices
@export var world: WorldState            # bell_count, region states, route
@export var journal: JournalState
@export var voice: VoiceState            # tone counts, drift
@export var stats: RunStats              # incl. brute_forced_mercy
```

**Nothing outside this tree is saved.** A node holding state that matters is a bug, and
the Route Prover catches it by round-tripping a save mid-scene and asserting equality.

---

## 10.6 Dialogue

Custom `.sh` format → compiler → `DialogueResource`. Not an off-the-shelf plugin: the
tone-tag, interrupt, memory-write, quote-manifest, and Reading-query requirements are too
specific, and the CI coverage report is the point.

**Compiler outputs:** `.tres` per region · coverage report (fails CI) · loc manifest ·
tone histogram. Full spec in Stage 7.

---

## 10.7 The Eight & Readings

```gdscript
func read_player(npc: NPCProfile, eight: Dictionary) -> StringName:
    var score := 0.0
    for k in npc.reading_bias:
        score += eight[k] * npc.reading_bias[k]
    score += npc.memory_weight_for(GameState.flags)
    score += hearsay_score(npc.region, GameState)
    return npc.reading_table.bucket(score)
```

**Hearsay** is a scheduled job on region transition over a weighted directed graph
(Stage 4 §4.2). The March has weight 0.

---

## 10.8 Save & Migration

```
GameStateData → Dictionary → JSON → zstd → CRC32 → atomic write (tmp + rename)
                                                  → .bak of previous
```

**Versioned migrations from the first commit.** `migrations/v1_to_v2.gd` etc. A player who
starts on 1.0 must finish on 1.4 without losing a run. CI tests a 1.0 save through every
subsequent version.

**Saves are deliberately human-readable** (JSON in a container). Players will datamine
this game; the flags are named honestly and there is nothing in there we are embarrassed by.

---

## 10.9 Performance Budget

| Subsystem | Budget (ms) |
| --- | --- |
| Bullets: integrate + broadphase + collision | 1.6 *(measured; was 1.2 est.)* |
| Bullet render (one `MultiMesh` call) | 0.4 |
| 2D lighting + shadows (worst case) | 3.5 |
| Environment shaders | 1.8 |
| Tilemap + sprites | 2.0 |
| Post (LUT, grade, shafts, quantise, snap) | 2.2 |
| GDScript logic | 2.0 |
| Audio | 0.8 |
| **Headroom (reserved)** | **2.3** *(0.4 spent on the measured bullet cost)* |
| **Total** | **16.6 (60 FPS)** |

**Reference hardware: Intel UHD 620 / Steam Deck.**

---

## 10.10 QA Tooling — the eight

| Tool | Purpose | Gate |
| --- | --- | --- |
| **Flag Audit** | Static pass; fails on flags read <3 times across <2 acts | CI |
| **Route Prover** | Headless sim of all 3 routes → all 5 endings; no unreachable content, no softlocks | CI |
| **Music State Diff** | Dumps active stems per region per save; verifies no muted stem re-enables | CI |
| **Unfair Death Log** | Records 3 s of bullet state + inputs on death; P1 if killing shot had <12 f telegraph | Runtime |
| **Pattern Replayer** | Seeded RNG + input log → exact reproduction of any death | Dev |
| **Text Audit** | Duplicate lines, <3-word lines without `[BEAT]`, NPCs with <3 stages | CI |
| **Greyscale/CVD Gate** | Every room through 4 LUTs | Art review |
| **Perf Sentinel** | Per-scene frame-time regression on reference hardware | CI |

**Determinism:** boss patterns run on a seeded RNG per encounter, so a death is
reproducible from a save + input log. This is how "unfair deaths" get debugged rather than
argued about.
