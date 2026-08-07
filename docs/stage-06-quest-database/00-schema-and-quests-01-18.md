# SECONDHEART — Quest Database (Stage 6), Part 1

Expands GDD §09 into authoring-ready specification for all 35 side quests.

| # | Document |
| --- | --- |
| 00 | Schema & Quests 01–18 *(this file)* |
| 01 | [Quests 19–35](01-quests-19-35.md) |
| 02 | [Puzzle Database — 71 puzzles](02-puzzle-database.md) |

---

## 6.0.1 Quest Schema

```gdscript
class_name QuestResource extends Resource
@export var id: StringName
@export var giver: StringName
@export var region: StringName
@export var act_available: int
@export var act_expires: int              # -1 = never
@export var prerequisites: Array[Condition]
@export var excludes: Array[StringName]   # mutually exclusive quests
@export var stages: Array[QuestStage]
@export var outcomes: Array[QuestOutcome] # ≥2, each with downstream writes
@export var journal_text: String          # THE GIVER'S OWN WORDS, not a summary
@export var failable: bool
@export var reveals: StringName           # lore | character | both
```

**The journal rule.** `journal_text` is always the quest-giver's phrasing, verbatim,
never a system summary. The Journal reads:

> *"Guisley says he can't hold the ladle steady any more and he'd like to cast one more
> before he stops. He didn't say what he wants cast."*

not *"Help Guisley complete a bell."*

**Every quest declares ≥2 outcomes**, each writing at least one flag read in ≥3 places
across ≥2 acts (GDD §06.6.2). CI's Flag Audit fails the build on orphans.

---

## 6.0.2 The Zero-Fetch Rule

**No quest may be summarisable as "bring N of X."** Applied to all 35, no exceptions.

Where a quest *involves* an object, the object is never the difficulty — the difficulty is
a decision, a diagnosis, a piece of navigation, or a conversation. Guisley's casting needs
bell-metal, but acquiring it is one screen away and free; the quest is whether you let a
man ruin his hands finishing something.

---

## 6.0.3 Failure Authoring

**Nine quests can fail.** Failure is never a toast, never a red X, never a "QUEST FAILED"
banner. It is:

1. A change in the world (an empty frame, a cold forge, a person who is well now).
2. A Journal entry that **moves to the *Questions* tab, unanswered**.
3. At least one NPC who mentions it obliquely, once, and never again.

---

# The Quests

## WYNDMARROW

### Q01 · THE NINETY-FIRST BELL ⚠
```
Giver Tilly Brack · WYN-04 · Act I → III · Failable
Excludes  — · Reveals character
```
**Premise.** Tilly wants a bell cast for a villager who never had one. Guisley is out of
bell-metal and out of enthusiasm.

**Stages.** (1) Tilly asks. (2) Guisley refuses; his hands shake. (3) Find who the bell is
*for* — she won't say. (4) It is for **herself**, at eleven, two years early, so that when
she is old enough there will already be ninety-one and one silence will be proportionally
smaller. (5) Resolution.

**Outcomes.**
- **Cast it.** `flag:bell_91` — the frame is filled. Tower board shows 91/90, which is
  wrong, and nobody fixes it. Tilly's epilogue variant B.
- **Refuse / run out of time.** The frame hangs empty for the rest of the game
  (Absence #3). Tilly does not bring it up again.
- **Guisley dies first** (Q03 failure). Hard fail; forge cold.

**Journal.** *"Tilly wants a ninety-first bell. She won't say who for."*

### Q02 · WHAT HALDEN KEPT
```
Giver Halden Brack · WYN-07 · Act I → epilogue · Reveals both
```
**Premise.** Severed, sorting Odile's belongings into keep/discard with perfect logic and
no criteria. He asks Aven to generate criteria for him.

**Stages.** Eleven objects, presented one at a time. Each choice is logged individually.

**Outcomes.** There is no success state. The eleven decisions are stored as a bitfield and
**read in the RETURN epilogue**, where Halden — restored — goes looking for what was
discarded, and the game names them.

**The design point:** the player will discard the boring ones. The chipped cup is boring.

### Q03 · GUISLEY'S LAST CASTING ⚠★
```
Giver Guisley · WYN-10 · Act I → III · Failable · Superboss chain step 6
Requires  Hope ≥ 50 for the good outcome
```
**Premise.** He wants one last casting and cannot hold the ladle.

**Outcomes.**
- **Help him** (Aven pours). `flag:forge_open` — **required for the superboss chain.**
  He casts his second bell and does not ring it.
- **Do it for him** (Aven casts alone). Works. He is polite about it. `flag:forge_open`
  still set but Guisley's epilogue is diminished and he is not at the funeral.
- **Reach Act III without it.** Forge cold. **Superboss chain hard-blocked this run.**
  This is the game's single most punishing missable and it is deliberate.

### Q04 · HOUSE TWELVE
```
Giver — (environmental) · WYN-12 · Act I → III · Reveals lore (F03)
```
Spotless, occupied, no photographs. Nobody will say whose. Three visits across three acts:
Act I it is locked; Act II a light is on; Act III it is open and empty and the dust shows
where frames used to hang. **Rue's childhood home.** Connects to Q28.

### Q05 · THE ROTA ⇄
```
Giver Sella & Ord / the Herricks · WYN-14 · Act I · Excludes: itself (pick one)
```
Two families both claim the dawn ringing slot. Pure village pettiness — for two stages.
Stage 3 reveals **the Herricks need to be first because their bell is the one Odile
listens for**, and Odile, severed, still comes to the window at that specific minute, and
nobody has told Halden.

**Outcomes.** Sella & Ord get it / the Herricks get it / **Aven proposes they share, which
requires re-engineering the rope walk** (P-WYN-1) and is the only outcome with no loser.

---

## THE GRIEVING WOOD

### Q06 · THE SEXTON'S BACKLOG
Forty keepsakes waiting. He hums instead of explaining. Three conversations, and the third
only opens if Aven has buried one themselves. **He buried his own and cannot start again.**
Outcome: he resumes, or Aven takes over the backlog (a real, slow, forty-object task that
roughly 6% of players complete and which grants the *Sexton's Spade* relic).

### Q07 · TWO TREES, ONE ROOT
Two trees grown together; their owners were not speaking when they died. Separate them or
leave them. **Neither party consented to either.** No outcome is correct and the game
offers no guidance. Reveals: whether reconciliation counts if nobody agreed to it.

### Q08 · SOMETHING BURIED TWICE ⚠★
A grave with two keepsakes, one recent. It is **one of Moth's forty.** Identifying it names
one of the Wards Moth is made of — and Moth is present, and quotes the dead man, and does
not know why Aven has gone quiet.
**Fails permanently if Moth is unwoven first.** Journal question stays open forever.

### Q09 · IVO AND NAN ⇄
An elderly pair planting their own tree *early*, so it is grown by the time they need it.
They want help and an opinion. **The warmest scene in the game**, and the quietest argument
against Hushfell: they have chosen to prepare for grief rather than remove it.
**Excludes Q10's "argue Ossa out of it"** — the game will not let Aven use Ivo and Nan as
a rhetorical device without cost, and doing so makes Nan stop talking to Aven.

---

## HUSHFELL

### Q10 · OSSA'S THIRD DAY ⚠⇄
Third of three. She wants to talk about anything else.
**Outcomes.** Talk her out of it *(she is still feeling it in Act III, thanks Aven twice,
is not okay, does not blame them)* / let the day pass *(severed; well; asks if Aven is new
here)* / **sit with her and talk about nothing**, which requires four consecutive
non-topical dialogue choices and is the outcome 8% of players find.

### Q11 · BROTHER FEN CHANGES HIS MIND ⇄
Fifth withdrawal. Comic on the surface; Annike's patience underneath.
**Mutually exclusive with Q10** — Annike can take one candidate through in the window Aven
is present, and **neither the player nor any character is told this.**

### Q12 · THE KETTLE ROTA
Who makes tea for people about to be severed? A rota. It is very fair. It is discussed at
length. **The banality that makes the rite survivable for staff.** Zero stakes, four
minutes, and playtesters cite it as the moment Hushfell became real.

### Q13 · THE REGISTER OF WILLING ★
Read all 300 entries (~20 real minutes). Changes Annike's final scene. Achievement #45.

---

## THE SALT LEDGER

### Q14 · COOM'S LAST READING ⚠
He is going blind from reading salt and wants one more dig. The dig finishes his eyes.
**Outcomes.** Take him *(he completes it, is blind, is grateful; it is Aven's fault and
what he wanted)* / refuse *(he goes alone in Act III and does not come back)* / **read it
for him** *(requires Salt Sight mastery; he keeps his eyes and loses the thing he was)*.

### Q15 · THE CITY UNDER THE CITY
The Dune Registrar, sixty years alone, still stamping, content. **Deliberate mirror of the
First Ward, planted six hours early.** No fail state; he does not want rescuing.

### Q16 · FILED UNDER NOTHING ★
Requisition 12-B/1441 has no category. **Superboss chain step 5.** Yields the door-key
mould and the manifest line `TRANSFERRED — HOLDING`.

### Q17 · KELL AND KELL
Twin scavengers who are demonstrably not twins and both insist. **Two severed people who
chose to be family on purpose**, after, deliberately, as a decision rather than a feeling.
**The most hopeful quest in the game** and the only one that argues severance survivors
can build something new.

---

## VERRICK

### Q18 · FORTY-ONE DAYS ★
Why synthetic Wards fail on day 41. **F07 payoff:** they are not synthetic; Verrick is
recycling filed Wards out of the Keeping at past-half-life.
**Outcomes.** Report it *(the line stops; 900 severed people lose their partial Wards;
Idrisse is dismissed)* / say nothing *(it continues; the player knows)* / **tell Barro**
*(changes Q19's outcomes — he now knows his weave could work if he had fresh stock, and
where to get it)*.
