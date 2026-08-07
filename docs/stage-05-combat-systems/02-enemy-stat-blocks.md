# 02 — Enemy Stat Blocks: 84 Types, 9 Families

**Nine AI trunks, not eighty-four.** Behaviour is a family script; types differentiate
through data. This is the scope-control decision that makes the roster affordable
(GDD §08.7).

---

## 5.2.1 The Schema

```gdscript
class_name EnemyProfile extends Resource
@export var id: StringName
@export var family: StringName            # one of 9 → selects AI trunk
@export var hp: int
@export var defence: float
@export var speed: float
@export var patterns: Array[PatternResource]
@export var phase_thresholds: Array[float]      # HP fractions
@export var weaknesses: Array[StringName]       # exactly 2
@export var diagnosis_pool: Array[Diagnosis]    # 4-6, exactly 1 correct
@export var lines: Array[DialogueRef]           # ≥3
@export var drop_common: ItemRef
@export var drop_rare: ItemRef                  # 3%
@export var personality: StringName
@export var resolve_scene_sever: DialogueRef    # bespoke
@export var resolve_scene_unknot: DialogueRef   # bespoke
```

**Every one of the 84 has both resolution scenes authored.** That is 168 short scenes and
it is non-negotiable — a fade-out on an UNKNOT would undo the entire pacifist design.

---

## 5.2.2 Family Trunks

| # | Family | Types | AI trunk behaviour | Personality axis |
| --- | --- | --- | --- | --- |
| 1 | **Clerical** | 11 | Grid-locked movement, fixed cycle, never improvises. Retreats to a "correct" position when displaced. | Officious, apologetic |
| 2 | **Bellwork** | 8 | Fires on musical beat. Telegraph is audio-primary. Stationary. | Mournful |
| 3 | **Rootbound** | 10 | Territorial. Defines a zone and defends it. Never pursues past it. | Protective, wordless |
| 4 | **Willing** | 7 | **Never attacks unprovoked.** Withdraws. Fires only in the frame after damage. | Serene |
| 5 | **Saltborne** | 9 | Precognitive: telegraphs at t−240f against predicted position. Slow. | Patient, bureaucratic |
| 6 | **Loomkin** | 12 | Fixed-period machine cycles. Fast. Fully learnable. | Industrious, blank |
| 7 | **Sunken** | 9 | **Combine when adjacent** (<40px): two merge into a third pattern. | Musical, insistent |
| 8 | **Orbital** | 8 | Momentum-driven; no direct control of own position. | Detached |
| 9 | **Unread** | 10 | Solid/vulnerable only while in the player's facing cone. | Desperate to be noticed |

**Distinguishability gate (QA):** with sprites hidden, a playtester must be able to
distinguish any two members of the same family **by behaviour alone.** Run per family
before content lock.

---

## 5.2.3 Sample Stat Blocks

Representative entries at production standard. Full 84 in `data/enemies/`.

### CLR-01 · FILING ERROR *(tutorial)*
```
Family    Clerical        HP 12    Def 0.0    Speed 30
Patterns  CLR.Queue (p1) · CLR.Alphabetical (p2)
Phases    [0.5]
Weak to   SEVER perfect-ring · BOUND
Diagnosis  ✗ a grudge · ✗ a place in a queue · ✓ a category it doesn't fit · ✗ a name
Drop       Index Card (common) · Blank 4-C (rare, 3%)
Personality  Insistent, not hostile. Wants to be put somewhere.
Lines      "Where does this go." / "This is not where this goes." / "Please."
UNKNOT     Aven writes it a category. It files itself. The scene is 20 seconds and it is
           the first time the player is thanked by something they were fighting.
SEVER      The cards fall. They stay fallen. Osk picks them up. He doesn't comment.
```

### BLW-04 · CRACKED PEAL
```
Family    Bellwork        HP 34    Def 0.1    Speed 0
Patterns  BLW.Peal · BLW.Cracked (p2) · BLW.Muffled (p3)
Phases    [0.66, 0.33]
Weak to   Sound-matched SPEAK · ANCHOR block
Diagnosis  ✗ a note · ✓ a mistake it made once · ✗ a ringer · ✗ the hour · ✗ a name
Drop       Bell-metal shard · Guisley's Tuning Fork (rare)
Personality  A bell that rang wrong at a funeral and has not stopped apologising.
UNKNOT     Aven rings it correctly, once. It stops. It is not grateful; it is finished.
```

### WLG-02 · COOLING-OFF
```
Family    Willing         HP 40    Def 0.3    Speed 44
Patterns  WLG.Withdraw only
Phases    none
Weak to   —  (it has no offence to counter)
Diagnosis  ✓ three days · ✗ a decision · ✗ a form · ✗ a person
Drop       Register Page · The Third Day (rare)
Personality  Politely leaving. Will not fight. Fires only if struck.
Note       A player can walk past every Willing enemy in Hushfell. ~30% do.
           `flag:hushfell_peaceful` is read in three places.
```

### SLT-06 · TENTH PRECIPITATE
```
Family    Saltborne       HP 88    Def 0.2    Speed 18
Patterns  SLT.Precognition · SLT.Strata (p2) · CLR.Duplicate (p3, reskinned)
Phases    [0.7, 0.35]
Weak to   Standing still · Salt Sight
Diagnosis  ✗ a memory · ✗ a place · ✓ a date · ✗ a debt · ✗ a name
Drop       Strata core · Sediment From A Year That Hasn't Happened (rare)
Personality  Not alive. Not hostile. Sediment with a schedule.
UNKNOT     Aven shows it the filing stamp. The date is wrong by six months. It comes
           apart with something like relief.
```

### LMK-09 · SLUB
```
Family    Loomkin         HP 52    Def 0.15   Speed 96
Patterns  LMK.Warp · LMK.Weft · LMK.Slub (every 7th cycle)
Phases    [0.5]
Weak to   BOUND (Barro) · perfect-ring on the 7th cycle
Diagnosis  ✗ a quota · ✓ an irregularity it can't report · ✗ thread · ✗ a shift
Drop       Thread · Correct Tension (rare — the game's best passive accessory)
Personality  A flaw that has become aware it is a flaw.
```

### SNK-05 · DESCANT
```
Family    Sunken          HP 30    Def 0.1    Speed 52
Patterns  SNK.Harmony (merges with any adjacent Sunken) · SNK.Undertow
Phases    none
Weak to   Isolation (separate it) · Held Breath
Diagnosis  ✗ a note · ✗ a part · ✓ someone else's mistake · ✗ water · ✗ a name
Drop       Choir part · The Fourth Part (rare)
Personality  Arranging around a wrong note. Every day. Out of love.
Note       Killing a Descant permanently thins CHR's ambient mix. Same rule as the boss.
```

### UNR-03 · FOOTNOTE
```
Family    Unread          HP 8     Def 0.0    Speed 22
Patterns  UNR.Footnote (accumulating) · UNR.Unobserved
Phases    none
Weak to   Being looked at · READ
Diagnosis  ✓ a readership · ✗ a citation · ✗ a page · ✗ an author
Drop       Page · Marginalia (rare)
Personality  Small, slow, ignorable, and it accumulates all fight.
Design     The player *can* ignore Footnotes entirely. By minute four there are forty.
```

---

## 5.2.4 Full Roster Index

| Family | IDs | Regions | Notes |
| --- | --- | --- | --- |
| Clerical | CLR-01…11 | UNC, ASY, REN | Includes Overdue Notice, Duplicate, Addendum, Erratum, Query |
| Bellwork | BLW-01…08 | WYN | Includes Tolling, Muffled, Sallie, Half-Muffled |
| Rootbound | RTB-01…10 | GRV, ASH | Includes Keepsake, Understory, Deep Root, Sapling |
| Willing | WLG-01…07 | HSH | Includes Candidate, Cooling-Off, Register Page, Kettle |
| Saltborne | SLT-01…09 | SLT | Includes Strata, Queue, Precipitate, Drift |
| Loomkin | LMK-01…12 | VRK | Includes Warp, Weft, Slub, Shuttle, Quality Control |
| Sunken | SNK-01…09 | CHR | Includes Part, Descant, Undertow, Held Breath |
| Orbital | ORB-01…08 | ORR | Includes Apogee, Perigee, Untethered, Armature |
| Unread | UNR-01…10 | CMN, ASH | Includes Marginalia, Footnote, Erratum, Blank |

**84 types. 92 placements.** Eight types appear in two regions with different data
(different patterns, different diagnosis, different lines) — they are the same creature
in a different situation, which is worldbuilding, not reuse.

---

## 5.2.5 NG+ Late Variants

18 types gain a `Late` variant on NG+ (GDD §10.5): same family, patterns drawn from the
**back half** of the pattern pool, dialogue rewritten.

**The Clerical family's NG+ change is the flagship:** they file *you*, by name, using the
player's chosen name, in their attack telegraphs. `CLR.Alphabetical` spells it.
