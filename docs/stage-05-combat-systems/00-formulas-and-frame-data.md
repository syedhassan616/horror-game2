# SECONDHEART — Combat Systems (Stage 5)

Expands GDD §05 and §08 into implementable specification. **All numbers here are the
tuning baseline** and are expected to move ±20% in Production A; the *relationships*
between them are the design and must not.

| # | Document |
| --- | --- |
| 00 | Formulas & Frame Data *(this file)* |
| 01 | [Pattern Library & Bullet Grammar](01-pattern-library.md) |
| 02 | [Enemy Stat Blocks — 84 types, 9 families](02-enemy-stat-blocks.md) |
| 03 | [Boss Phase Tables](03-boss-phase-tables.md) |

---

## 5.0.1 Units & Frame Budget

- **Logical resolution:** 480×270. **Arena default:** 320×180, centred.
- **All speeds in px/sec.** All durations in **frames at 60 FPS** unless marked `s`.
- One frame = 16.667 ms. **Nothing in combat is authored in seconds.**

---

## 5.0.2 Core Bodies

| Property | Self | Ward (base) |
| --- | --- | --- |
| Sprite | 6×6 | 8×8 |
| **True hitbox** | **4×4** (visible bright pip) | per companion |
| Base speed | 84 px/s | follows |
| Run speed | 168 px/s | follows |
| Accel / decel | 12 frames to full / 6 to stop | — |

**The hitbox is always honestly displayed.** The bright pip *is* the collision core. No
game in this genre should do otherwise and we will be judged on it.

### Tether spring (default, SPRING mode)

```
F = -k * (len - rest) * dir  -  c * v_rel
k    = 14.0        # stiffness
c    = 0.55        # damping
rest = 24 px
L    = 64 px       # max length, grows with Capacity (GDD §07.3)
```

Integrated with **semi-implicit Euler at a fixed 120 Hz substep** (2 substeps/frame) to
keep the spring stable at high `k`. This is a hard requirement: at 60 Hz single-step the
ANCHOR rod mode oscillates visibly.

---

## 5.0.3 The Five Verbs — Frame Data

| Verb | Startup | Active | Recovery | Cooldown | i-frames |
| --- | --- | --- | --- | --- | --- |
| **MOVE** | 0 | — | — | — | 0 |
| **SWAP** | **1** | 3 | 4 | 54 (0.9s) | **6** (frames 1–6) |
| **PULL** | 2 | 9 | 4 | 72 (1.2s) | 0 *(4 with `Two Hands`)* |
| **PLANT** | 3 | hold, max 180 | 6 | 30 | 0 |

**SWAP is the contract.** Input → first visible response ≤ **2 frames**. Measured every
build on reference hardware; a regression is a P1 defect, not a tuning note.

**i-frame visibility:** a hard white flash on Self for exactly the 6 active frames. The
player must always know whether the dodge landed. No ambiguity, ever.

**Buffering:** 6 frames on all verbs, adjustable to 12 in accessibility (GDD §13.6).

---

## 5.0.4 Tether States

| State | Condition | Insight mult | Strain mult | Visual |
| --- | --- | --- | --- | --- |
| `SLACK` | `len < 0.40L` | **0.0** | 0.0 | Dim, drooping |
| `LIVE` | `0.40L ≤ len < 0.90L` | 1.0 | 1.0 | Normal |
| `TAUT` | `0.90L ≤ len ≤ L` | **1.6** | **2.0** | Shimmer + rising tone |
| `STRAINED` | `strain ≥ 70` | 0.5 | 1.0 | Reddens; contact radius ×0.5; 1 chip dmg/s |
| `SNAPPED` | `strain = 100` | 0.0 | — | Breaks 180 frames; both take 8; **audio cuts 24 frames** |

### Contact sensing

The tether is **6 sample points** evenly spaced along the rendered line, each a circle of
radius **3 px**. Sample points are *not* a solid — bullets pass through and are **read**.

Exception: **ANCHOR + PLANT** converts the polyline into a swept capsule collider that
blocks. This is the only case where the tether has physical presence.

---

## 5.0.5 INSIGHT

```
insight_gain = base × tether_state_mult × companion_mult × danger_mult
```

| Term | Values |
| --- | --- |
| `base` | pellet 1 · bolt 3 · beam-tick 6 · special 10 |
| `tether_state_mult` | SLACK 0 · LIVE 1.0 · TAUT 1.6 · STRAINED 0.5 |
| `companion_mult` | Tilly 0.5 · Moth **2.0** · Barro 1.5 *(threads)* · Sennet 1.0 · Rue 1.0 / **3.0 unsafe lane** |
| `danger_mult` | **×2 if the projectile would have struck Self within 24 frames** |

**`danger_mult` is the entire design.** Peace is priced in nerve. The 24-frame window is
computed by forward-integrating the projectile against Self's *current* position and
velocity — it is a prediction, and it is deliberately generous, because the player must
be able to feel it.

**Cap 100. Does not persist between encounters** *(except `Held Question`: 25 carry within
a room).* **There is no way to grind it.**

### Spend table

| Action | Cost | Effect |
| --- | --- | --- |
| UNKNOT (correct) | 40 | Non-violent resolution |
| UNKNOT (wrong) | 40, lost | Enemy +1 phase; that option removed |
| SPEAK → deep | 15 | Reveals diagnosis evidence |
| ATTUNE | 60 *(45 with `Two Beats`)* | Companion special |
| MEND | 25 | Clear Strain, +10 Self HP |

---

## 5.0.6 STRAIN

```
strain_per_sec = max(0, (len/L - 0.75)) * 34
               + insight_gained_this_sec * 0.6
               - companion_strain_resist
strain_decay   = 12/sec   # while SLACK or LIVE and zero Insight gained this frame
```

| Companion | `strain_resist` |
| --- | --- |
| Tilly | 3.6 (the −30%) |
| Moth | 0.0 |
| Barro | 1.0 |
| Sennet | 1.5 |
| Rue | 0.0 |

**Displayed as a red thread along the tether**, never as a HUD bar. Two of the four
critical resources live inside the play field, on the object the player is already
watching (GDD §12.8).

**The rhythm this produces:** greed → tension → deliberate release. Farm hard for two
seconds, PULL, breathe. It is the same rhythm as the game's themes.

---

## 5.0.7 Health & Damage

| Stat | Value |
| --- | --- |
| Self HP | 20 → 60 across six story milestones (GDD §07.3) |
| Ward HP | Companion-specific; **0 HP = SLACK for 480 frames**, never death |
| Breath | 10 → 30; regen 1/s while LIVE *(also during TAUT with `Steady Breath`)* |
| Defence | Flat reduction, **hard cap 60%** |

```
damage_taken = max(1, floor(raw * (1 - min(0.60, defence)) * difficulty_mult))
```

**Minimum 1.** Nothing is ever fully negated — the player is always mortal, and a 60-HP
Aven still dies in 5 hits at the end of the game, which is the same number as at the start.

### SEVER

```
sever_damage = weapon_base * ring_multiplier * (1 + sharpen_nodes)
ring_multiplier:  perfect 2.0 · good 1.3 · ok 1.0 · miss 0.4
```
Ring shapes vary by weapon (14 weapons, GDD §07.5) — single, three-beat, sweeping,
inverted, and one that is *deliberately unreadable* and belongs to a Wrath-route weapon.

**Hitstop:** 4 frames on hit, 7 on perfect.

---

## 5.0.8 UNKNOT — the anti-spam spec

```gdscript
func present_diagnosis(enemy) -> Array[Diagnosis]:
    var pool := enemy.diagnosis_pool          # 4-6 options
    pool = pool.filter(func(d): return not d.already_tried_this_encounter)
    if player.has_node(&"shortlist"):  pool = drop_one_wrong(pool)
    if player.has_node(&"eddas_ear"):  pool = annotate_category(pool)
    return pool.shuffled_stable(encounter_seed)   # stable: same order on retry
```

**Rules:**
1. A wrong diagnosis **costs the Insight, escalates one phase, and removes that option.**
   Brute force is possible, expensive, and narratively acknowledged — the enemy says
   something about being misunderstood.
2. **Correct diagnosis is remembered per enemy *type*.** The second Filing Error you meet
   Unknots in one action. **Knowledge is the pacifist's progression system**, not stats.
3. `Familiar` (skill) extends this to whole families.
4. Evidence sources: SPEAK, attack patterns, overworld props, Journal entries, READ.
5. **Every one of the 84 types has a bespoke resolution scene.** No fade-outs.

**The hidden superboss condition** (GDD §08.6) tracks
`brute_forced_mercy = any(encounter where UNKNOT succeeded after ≥1 wrong in the same
encounter)`. Set once, never cleared, never mentioned.

---

## 5.0.9 Companion Tether Modes — full spec

| Mode | Physics | Insight | Special |
| --- | --- | --- | --- |
| **SPRING** *(default/none)* | k=14, c=0.55 | ×1.0 | — |
| **ANCHOR** (Tilly) | Rigid rod; mass ×3; PLANT → **swept capsule collider**, blocks projectiles and Self | ×0.5 blocked | `Hold the Line`: collider persists 180f after unplant |
| **GHOST** (Moth) | No Ward collision; tether ignores geometry | **×2.0** | `Borrowed`: mimics last enemy pattern harmlessly |
| **LOOM** (Barro) | Trail of 6 nodes, 240f lifetime; **closed polygon → `BOUND`** | ×1.5 on threads | `Reinforce`: loop lifetime 360f → 720f |
| **CURRENT** (Sennet) | Tether applies **impulse** to projectiles (deflect, not delete): `v += normal * 140 px/s` | ×1.0 | `Undertow`: reverses impulse sign |
| **SIGNAL** (Rue) | Paints safe lanes 90f ahead of each volley | ×1.0 safe / **×3.0 unsafe** | `Reroute`: repaint once mid-volley |

**Loop detection for LOOM** uses a cheap winding-number test over the 6 trail nodes plus
the live tether segment. A loop is valid if area > 400 px² and the enemy centroid is
inside. Runs once per 6 frames, not per frame.

### ATTUNE specials

| Companion | Effect | Duration |
| --- | --- | --- |
| Tilly — *Full Peal* | All projectiles −60% speed | 150f |
| Moth — *Everyone At Once* | Reveals one correct diagnosis option outright | — |
| Barro — *Forty-One Days* | **A second, player-controlled tether** | 480f |
| Sennet — *Held Breath* | Everything, including Self, at 40% speed | 360f |
| Rue — *Never Once Stopped* | Self unstoppable/unslowable; afterimage also reads bullets | 600f |

---

## 5.0.10 Difficulty Multipliers

| Mode | Bullet speed | Self hitbox | Insight | Telegraph | Extra patterns |
| --- | --- | --- | --- | --- | --- |
| Steady | ×0.80 | ×1.50 (6×6) | ×1.30 | +6f | — |
| **True** | ×1.00 | ×1.00 (4×4) | ×1.00 | — | — |
| Taut | ×1.15 | ×0.85 | ×1.00 | — | +1/boss |
| The Long Quiet | ×1.30 | ×0.70 | ×0.90 | −2f *(never below 12)* | +1 phase/boss |
| Carry Me | dodging automated | — | auto | — | — |

**The 12-frame telegraph floor is absolute.** No difficulty, no boss, no phase may spawn a
lethal projectile with fewer than 12 frames of visible tell. Violations are logged by the
Unfair Death tool and triaged P1.

Difficulty is changeable mid-fight from the pause menu, with **no penalty, no achievement
lockout, and no comment from the game.**

---

## 5.0.11 Death & Recovery

On Self HP 0:
1. 30 frames of hitstop, audio ducks.
2. Return to **Command Phase of the current encounter** — not a menu, not a reload.
3. Self HP restored to 40% max. Insight zeroed. Strain zeroed. Ward SLACK cleared.
4. **A companion-specific line**, authored per companion × per act × 3 variants = 60 lines.
5. No progress lost, ever. Difficulty comes from encounters, never re-traversal.

**The 60 death lines are a writing deliverable, not a system message.** Tilly's Act I set
begins *"Get up. That's not — get up, I've got the rope."*
