# 04 — World Systems

---

## 4.1 The World Map

**The map is a cross-section, not a plan view.** Regions sit at true depth. You always see
how far down the Keeping is and how far up the Assay is, and you are always in the middle.

```
                                    ▲  THE ASSAY  (ASY)
                                    │
                          THE ORRERY (ORR) ─── floating
                                    │
   HUSHFELL (HSH) ──── snowline ────┤
        │                           │
   WYNDMARROW (WYN) ─── hills ──────┼──── THE COMMONPLACE (CMN)
        │                           │
   THE GRIEVING WOOD (GRV) ─────────┤
        │                           │
   VERRICK LOOMWORKS (VRK) ─────────┼──── THE ASH GARDEN (ASH)
        │                           │
   THE SALT LEDGER (SLT) ── sea bed ┤
        │                           │
   THE DROWNED CHOIR (CHR) ─────────┤
        │                           │
   THE UNCLAIMED (UNC) ─────────────┘
        │
        ▼  ░░░░░░░░░░  (unlabelled void)  ░░░░░░░░░░
```

**The unlabelled void is visible from hour one.** It has no name, no marker, and no
interaction. It is the Keeping. **No dialogue mentions it until Act II.** Playtest round 1
confirmed players ask about it within twenty minutes and are told nothing.

**The Lamplight March** is not a fixed point. It is drawn as a small moving marker that
traverses the map in real time and its position is a real simulation value.

---

## 4.2 Travel

| Method | Unlock | Cost | Notes |
| --- | --- | --- | --- |
| **Walking** | — | Time | All regions are physically connected |
| **Bell travel** | First bell *rung* in a region, not region completion | Instant | 14 bells |
| **Calling the March** | Act II | In-game hours | Real trade in Act III's timed events |
| **The March's course** | Quest 30 | — | The player plots Act III's route order |

**Design intent:** the player unlocks fast travel by doing the region's *first warm thing*
(ringing a bell), not by finishing it. A player who rings and leaves can come back
instantly. A player who clears a region and never rings cannot.

Roughly 15% of playtesters missed this and the game does not fix it for them, because the
bells are the region's most prominent interactable and the lesson is cheap.

---

## 4.3 The Bell Count as a World System

`world.bell_count` is a single integer, initialised at 90, and it is the most-read value
in the game.

| System | How it reads the Bell Count |
| --- | --- |
| Wyndmarrow lighting | `TENDED / THINNING / COLD / KEPT` bands |
| *Ninety Bells* stems | Six bands, permanent muting |
| Pell's inventory | Loses one luxury item per 8 points lost |
| NPC greetings | 4 bands per NPC |
| Guisley's willingness | Quest 03 fails below 55 |
| The Tally's alternate | Requires 90 (achievement #33) |
| Every epilogue | Wyndmarrow module, 4 variants |
| The final shot | The number is **read aloud** |

**It can only go down.** There is no mechanic that raises it, in any route, ever. The one
apparent exception — casting the 91st bell (Quest 01) — adds a bell to the *frame*, not to
the count, and Tilly says so.

---

## 4.4 Weather & Time

**Time of day** is per-region and mostly fixed — regions have an authored hour, because a
day/night cycle across 192 hand-lit rooms is unaffordable and would dilute the palettes.

| Region | Hour | Changes |
| --- | --- | --- |
| Wyndmarrow | Golden hour | → overcast permanently below Bell Count 78; rain in Act III |
| Hushfell | Flat white noon | Whiteout during the boss |
| Salt Ledger | Late afternoon | Storms |
| Verrick | Perpetual artificial | Vent schedule |
| Drowned Choir | Filtered surface light | Deepens as voices are silenced |
| March | Whatever's outside | Real parallax by map position |
| Orrery | Starlight | None |
| Commonplace | Lamplit dusk | None |
| Ash Garden | Overcast | Ash density by flowers picked |
| Assay | None | Falling forms |

**Weather systems in code:** 6 (mist, rain, snow-accumulation, ash-fall, salt-storm,
underwater-current). Each is a shader + particle system + audio bed + a gameplay hook.
**None is decorative** — every one has at least one puzzle or traversal consequence.

---

## 4.5 Environmental Storytelling — the Method

Beyond the 20 absences (§00.5), the world tells its story through four repeatable
techniques. These are the **house style** and every environment artist works to them.

### 1. Maintenance as emotion
Whether something is *kept up* says who still cares. Repointed stone, trimmed lamps,
swept steps, washed cups. **The `KEPT` lighting state** is this technique's purest form:
everything clean, everything minimum.

### 2. Volume as history
Quantity tells time. 300 teacups. 61,400 on a plate. 41 seats. 200 complaints. 90 chalk
marks. Numbers in this game are always *countable on screen* — if the text says 41, the
room has 41.

### 3. The one thing out of place
Every region has exactly one object that violates its palette (the forbidden colour) and
one object that violates its logic (the keyholeless door). Both are in plain sight. Both
are never pointed at.

### 4. Absence, composed
Not ruin — **arrangement.** A chair pushed in. Laundry still out. A place set. The
difference between "nobody lives here" and "somebody who lives here stopped needing this"
is the entire art direction of the game.

---

## 4.6 Region Interlock & Gating

| Gate | Mechanism | Opens |
| --- | --- | --- |
| Act I → Act II | `flag:tally_resolved` | The March |
| Act II regions | None — free order | SLT / VRK / CHR any sequence |
| Act II → Act III | Eight checkpoint | Route resolves; Act III regions differ |
| Movement upgrades | 9 verbs (GDD §07.4) | Retroactive optional content in 8 earlier regions |
| The Keeping | 9-step chain + hidden restraint condition | KEP |
| The Undersleep | Quest 28 (or DRIFT) | UND |

**Backtracking respect:** the Journal auto-flags rooms containing content the player
could not reach with their then-current verbs. The map shows a small mark. **It never
says what the content is.**

---

## 4.7 Region Build Order (production)

Sequenced so that the riskiest systems are proven first and the vertical slice is real.

| Wave | Regions | Why this order |
| --- | --- | --- |
| **Slice** (mo. 1–3) | WYN | Proves lighting, weather, stem-reactive music, one boss, one companion |
| **Wave 1** (mo. 4–7) | UNC, GRV, HSH | Tutorial + two contrasting moods; Root Reading; the Willing family |
| **Wave 2** (mo. 8–11) | MAR, SLT, VRK | The hub, then the two heaviest systems (storms, verticality) |
| **Wave 3** (mo. 11–13) | CHR, ORR | The two highest-risk technical regions: diegetic audio, gravity solver |
| **Wave 4** (mo. 13–15) | CMN, ASH, REN, ASY | Late regions reuse established tech |
| **Wave 5** (mo. 14–15) | KEP, UND | Small, bespoke, high-impact. Built last, cut never. |

**KEP and UND are three and four rooms.** They are the cheapest regions in the game and
carry the superboss, the Hidden Ending gate, and the emotional payload of the entire
project. This is deliberate: **the most important content in SECONDHEART is also the least
expensive to build**, which is what makes the cut order in GDD §17.5 honest.
