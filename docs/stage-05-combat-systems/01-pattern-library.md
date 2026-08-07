# 01 — Pattern Library & Bullet Grammar

---

## 5.1.1 The Grammar

Patterns are **data**, authored as `PatternResource` and interpreted by `pattern_player.gd`.
No pattern is a script. This is what makes 84 enemies + 17 bosses affordable.

```gdscript
class_name PatternResource extends Resource
@export var steps: Array[PatternStep]
@export var loop: bool = false
@export var telegraph_frames: int = 18      # min 12, enforced
@export var seed_mode: int                  # FIXED / PER_ENCOUNTER / PER_PHASE

class_name PatternStep extends Resource
@export var emitter: EmitterShape           # POINT / ARC / LINE / RING / SPIRAL / AIMED / LANE
@export var count: int
@export var spread_deg: float
@export var speed: float                    # px/s
@export var accel: float
@export var curl_deg_per_sec: float         # for curving shots
@export var bullet_type: StringName         # pellet / bolt / beam / special
@export var delay_frames: int
@export var origin: OriginRef               # ENEMY / ARENA_EDGE / PLAYER_LAST / WARD_LAST
@export var sfx: StringName
```

### The six emitters

| Emitter | Shape | Reads as |
| --- | --- | --- |
| `POINT` | One bullet | Punctuation |
| `ARC` | N over `spread_deg` | A sweep you move through |
| `RING` | N over 360° | A space you leave |
| `LINE` | N along a wall | A gate with gaps |
| `SPIRAL` | N with rotating offset | A rhythm |
| `AIMED` | At Self / Ward / lane | A question about which body you value |

**`AIMED` at Ward is the game's signature threat**, because most players instinctively
protect Self and have to be taught that the Ward is a person.

---

## 5.1.2 Bullet Types & Shape Language

**Colour-independent by mandate** (GDD §13.6). Every type is distinguishable by
**silhouette and motion** alone. Verified in the monochrome+shape accessibility pass.

| Type | Silhouette | Motion | Base dmg | Insight base |
| --- | --- | --- | --- | --- |
| **Pellet** | Small circle | Straight, constant | 2 | 1 |
| **Bolt** | Elongated diamond | Fast, accelerating | 4 | 3 |
| **Beam** | Continuous bar | Static after telegraph, ticks | 3/tick | 6/tick |
| **Curl** | Comma/teardrop | Curving, `curl_deg_per_sec` | 3 | 3 |
| **Weight** | Large hexagon | Slow, unstoppable, pushes | 6 | 10 |
| **Special** | Per-boss bespoke | Per-boss | varies | 10 |

**Six types, hard cap.** A seventh requires cutting one. This constraint exists so the
player's visual vocabulary stays learnable across 84 enemies.

---

## 5.1.3 The Telegraph Contract

Every lethal projectile gets, at minimum:

1. **12 frames** of visible tell *(18 default, 24 for `Weight`)*.
2. A **positioned spawn sound** (GDD §11.5) — blind-playability is a stated target.
3. A tell that is **spatially where the danger will be**, not merely where the emitter is.

**Tell vocabulary:**

| Tell | Used for |
| --- | --- |
| Emitter flash + scale pulse | Pellet, Bolt |
| **Ghost line** (thin, the exact future path) | Beam, Lane |
| Ground shadow | Weight |
| Curl arc preview (dotted) | Curl |
| Character animation windup | All boss specials |

**The rule that governs QA:** *if a player dies and cannot name the tell they missed, the
pattern is a bug.* Logged as P1, not as balance feedback.

---

## 5.1.4 The Shared Pattern Library

56 named base patterns, reused with different data across the roster. Naming is
`FAMILY.Name`. A selection, showing the design intent:

### Clerical (orderly, grid-locked, predictable)
| Pattern | Shape | Teaches |
| --- | --- | --- |
| `CLR.Alphabetical` | LINE, left→right, one gap that moves one slot per volley | Read a sequence, not a moment |
| `CLR.Cross-Reference` | Two ARCs from opposite corners, intersecting | The intersection is safe. Counterintuitive. |
| `CLR.Duplicate` | Any previous pattern, replayed 30f later, offset 8px | Muscle memory is a trap |
| `CLR.Queue` | Slow column of pellets, single file, endless | Patience; also the first `Weight` tutorial |

### Bellwork (sound-telegraphed, rhythmic)
| `BLW.Peal` | RING on the beat, 4/4 | The music *is* the telegraph |
| `BLW.Muffled` | Same, but the tell is quieter and 4f later | Audio attention |
| `BLW.Cracked` | Peal with one bell out of time | The exception is the danger |

### Rootbound (territorial, area-denial)
| `RTB.Thicket` | Static `Weight` obstacles that persist across the phase | The arena shrinks |
| `RTB.Understory` | Swarm that splits when damaged, merges when ignored | Mercy has mechanics |

### Willing (do not attack unless attacked)
| `WLG.Withdraw` | Moves away; fires **only** in the frame after taking damage | The player generates the entire fight |

### Saltborne (slow, precognitive, positional)
| `SLT.Precognition` | Telegraphs 240f early, **in the wrong place**, then fires where you *will* be | Commit and stay. Inverts everything taught so far. |
| `SLT.Strata` | Horizontal bands that scroll; each band a different speed | |

### Loomkin (fast, mechanical, pattern-locked)
| `LMK.Warp` / `LMK.Weft` | Perpendicular LINEs on a 22f cycle | Reading a machine's period |
| `LMK.Slub` | Warp/Weft with one thread out of place, every 7th cycle | Exceptions in a system |

### Sunken (harmonic; combine when adjacent)
| `SNK.Harmony` | Two enemies' patterns **merge into a third** when within 40px | Positioning the *enemies* |
| `SNK.Undertow` | Constant directional current; all bullets and Self drift | |

### Orbital (gravity/momentum)
| `ORB.Apogee` | Bullets that slow, stop, reverse | Timing over dodging |
| `ORB.Reparent` | Arena gravity flips; existing bullets re-path | |

### Unread (attention-based)
| `UNR.Unobserved` | Only solid while facing them; attacks come from where you aren't | Facing as a resource |
| `UNR.Footnote` | Small, slow, ignorable — **and it accumulates all fight** | Ignoring has a cost |

---

## 5.1.5 Composition Rules

Bosses do not get bespoke patterns for every phase. They get **library patterns with
bespoke parameters plus 1–2 signature specials.** Ratio target: **70% library / 30%
bespoke** per boss.

**The anti-repetition matrix.** QA maintains 17 bosses × mechanic tags. Any tag appearing
>2 times triggers a redesign (GDD §08.1). Current tag distribution:

| Tag | Bosses using it |
| --- | --- |
| Arena geometry changes | Briarsome, the Assayer, the Orrery's Keeper |
| Resource other than HP | The Tally (count), the Cantor (voices), Three-Day Wait (time) |
| Player's own data used against them | Vellum (mirror), the Assayer (build + precedent), the Version Of You (inputs) |
| Cannot be won by damage | Annike, Both Armies, the Three-Day Wait |
| Permanent world consequence | The Cantor, the First Ward |
| Inverts a taught rule | The Tenth Stratum (commit, don't dodge), the Unread (facing) |

Each appears **≤3 times across 17 bosses**, and no two bosses share more than one tag.

---

## 5.1.6 Density & Readability Budget

| Context | Max simultaneous | Max lethal in one screen-quadrant |
| --- | --- | --- |
| Normal encounter | 120 | 30 |
| Major boss, phases 1–3 | 400 | 70 |
| Rage phase | 900 | 110 |
| The First Ward, phase 7 | **2,000** | 140 |

**The engine budget is 4,096** (Stage 10). The gap between 2,000 and 4,096 is headroom,
not permission.

**Readability rule:** at any instant, a still frame of the arena must contain a survivable
path that a player could identify in **under 200 ms**. Verified by a tool that samples
random frames from recorded boss runs and asks playtesters to point at safety.
