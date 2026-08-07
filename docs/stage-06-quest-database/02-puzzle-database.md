# 02 — Puzzle Database: 71 Puzzles

**71 distinct puzzles, 77 placements.** 22 optional, 9 hidden entirely (no prompt, no
glow, no indication). All solvable without combat. All skippable via Puzzle Assist with
**zero content or achievement loss** (GDD §13.6).

---

## 6.2.1 Schema

```gdscript
class_name PuzzleResource extends Resource
@export var id: StringName                 # P-RGN-N
@export var type: StringName               # one of 10
@export var room: StringName
@export var optional: bool
@export var hidden: bool                   # no prompt at all
@export var assist_hint: String            # level 1
@export var assist_strong: String          # level 2
@export var assist_solution: String        # level 3
@export var teaches: StringName            # what verb/idea it trains
@export var gates: Array[StringName]       # content behind it
```

**Assist is authored per puzzle, three levels, in the world's voice** — never a system
message. Edda gives Commonplace hints. Tilly gives rope hints. The hint system is a
character.

---

## 6.2.2 Type Distribution

| Type | Count | Regions | Core idea |
| --- | --- | --- | --- |
| **Tether** | 12 | All | The combat verb used to traverse |
| **Environment** | 9 | WYN, VRK | Reshape a space to move something intangible |
| **Physics** | 8 | ORR, VRK | Mass, tension, gravity |
| **Logic** | 7 | SLT, CMN | Ordering and deduction |
| **NPC cooperation** | 7 | WYN, MAR, VRK | People as mechanisms, with opinions |
| **Music** | 6 | CHR, MAR | Pitch, sequence, and one deliberate silence |
| **Pattern recognition** | 6 | VRK, SLT | Read a system, predict its next state |
| **Memory** | 6 | CMN, UND, KEP | Recall from the actual playthrough |
| **Light** | 5 | GRV, CMN | Angle, shadow, growth |
| **Time** | 5 | HSH, ORR | Waiting as a mechanic |

**No type appears in more than two regions.** This is a hard constraint and it is what
stops the game developing a "puzzle feel" that overrides regional identity.

---

## 6.2.3 The Flagship Puzzles

### P-CMN-3 · WHAT OSK SAID *(Memory, mandatory)*
Edda asks what Osk said in the first ninety seconds of the game. Four options. The Journal
logged it (S-004); it was never highlighted.

- Correct: *"It hurts in the mornings and I've got nothing else of hers."*
- **No penalty for wrong. No reward for right.** Edda simply looks at you differently.
- **The room has no music.**
- Assist L3 quotes the Journal entry directly, which is the correct behaviour: the
  information was always available.

### P-CHR-2 · THE FORTY-ONE PARTS *(Music, optional, ★)*
Reproduce the choir's harmony with only the parts collected. **The missing part must be
left silent** — playing something in the 41st slot fails, and the failure message is the
Cantor saying *"No. That one is not ours to sing."*

Solving it in **seat order** rather than collection order speaks a name aloud. This is the
superboss chain's step 3 and the game gives no indication that order matters.

### P-SLT-1 · THE FILING ORDER *(Logic, optional)*
Reconstruct nine centuries from 18 out-of-sequence strata. Depth is the answer and the
player has been walking on it. **Solvable from 12 of the 18**, so a partial collection
still resolves — and the six missing ones are the ones that make it *personal* rather than
merely chronological.

### P-WYN-1 · THE DEAF QUARTER *(Environment + NPC cooperation, optional)*
Route a bell's sound to a quarter of the village that cannot hear it, using rope bridges,
reflector boards, and the cooperation of six villagers **who will each only act after
someone they trust has acted first.** The dependency graph is a real constraint problem
with three valid solutions.

**Its third solution** — rebuild the rope walk so both rota families ring simultaneously —
is the no-loser outcome of Q05.

### P-ORR-2 · THE LONG CHAIN *(Physics, mandatory)*
Tether islands in sequence so gravity propagates. A genuine constraint solver, not a
scripted toggle, **because players will build configurations we did not design** and the
physics must hold. Flagged in Stage 3 as the region's engineering risk.

### P-HSH-2 · THE THREE-DAY WAIT *(Time, optional — also a mini-boss)*
Survive 180 real seconds **without acting at all.** Any input restarts it. It is a puzzle
and a boss and a thematic statement, and it is the only content in the game that asks the
player to do nothing for three minutes — a rehearsal for the First Ward's UNKNOT and for
HUSH.

### P-KEP-1 · NINE DOORS *(Memory, hidden, ★)*
The chain's first step. Nine doors, nine regions, seen since minute fifteen. **No prompt
ever appears on any of them.** The Journal logs each under *Questions* automatically.

---

## 6.2.4 The Nine Hidden Puzzles

No prompt, no glow, no indication. Found by players who try things.

| ID | Region | What it is | Reward |
| --- | --- | --- | --- |
| P-UNC-3 | The Unclaimed | Read all 70 drawers | Skill node *Osk's Filing* |
| P-WYN-4 | Wyndmarrow | Ring all 90 bells yourself before the Tally | Tally alternate; ach. #33 |
| P-GRV-5 | Grieving Wood | Bury a Keepsake and read the tree it grows | *Sexton's Spade* |
| P-HSH-4 | Hushfell | Never fight a Willing enemy | `flag:hushfell_peaceful` |
| P-SLT-4 | Salt Ledger | Dig the same site in three different storm layouts | Strata 16–18 |
| P-VRK-5 | Verrick | Ride the steam schedule to the top of the shaft | 2 Keepsakes |
| P-CHR-4 | Drowned Choir | Silence zero voices for the whole region | Relic: *The Forty-First Part* |
| P-MAR-3 | March | Work a coupling shift nobody asked for | Ach. #69 |
| P-KEP-1 | (global) | Nine Doors | The Keeping |

---

## 6.2.5 Puzzle Assist Design

Three levels, all authored in character, available on all 71.

| Level | Content | Example (P-CMN-3, in Edda's voice) |
| --- | --- | --- |
| 1 · Hint | Points at the *kind* of thinking | *"You were told it. You weren't asked to remember it. Those are different, and only one of them is your fault."* |
| 2 · Strong | Points at the specific source | *"Your journal keeps what people said. Look under the first day."* |
| 3 · Solution | Gives it | *"He said it hurt in the mornings, and that he had nothing else of hers."* |

**No achievement, ending, item, or secret is gated on solving unaided**, including the
superboss chain. A player using Assist L3 on all 71 puzzles reaches 100% completion.

**This is a deliberate and slightly costly decision.** It means the nine hidden puzzles
are *findable* via Assist once the player knows they exist — and we accept that, because
the alternative is a completion ceiling that punishes cognitive difference.

---

## 6.2.6 Coverage Audit

| Metric | Value |
| --- | --- |
| Distinct puzzles | 71 |
| Placements | 77 |
| Optional | 22 |
| Hidden (no prompt) | 9 |
| Requiring combat | **0** |
| Skippable with no loss | **71** |
| Types appearing in >2 regions | **0** |
| Puzzles gating story progress | 11 |
| Puzzles gating optional content | 44 |
| Puzzles gating nothing (pure texture) | 16 |

**The sixteen that gate nothing** exist because a world where every puzzle is a lock is a
world made of locks. Q12's kettle rota is the model: zero stakes, four minutes, and
playtesters cite it as the moment the region became real.
