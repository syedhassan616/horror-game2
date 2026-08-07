# 08 — Bosses & Enemy Design

> Frame data, exact pattern geometry and per-phase tuning are **Stage 5**.
> This chapter fixes every boss's identity, mechanic, arena, phases, and endings.

---

## 8.1 The Boss Law

Every boss in SECONDHEART must satisfy **all seven** or it does not ship:

1. **A new mechanic** that no previous fight used, taught in its first 15 seconds
   without text.
2. **An arena that is itself an argument** — the shape of the room states the boss's
   thesis.
3. **A rage phase that is characterisation**, not a damage multiplier. (The Assayer's
   rage phase is *efficiency*. Tilly's mother's bell rings *faster*.)
4. **A finisher for both routes** — a distinct authored ending for SEVER and for UNKNOT.
5. **Multi-phase dialogue** that responds to how the player is playing, not just to HP.
6. **A cutscene the player can't get anywhere else** — entering or leaving.
7. **An alternate outcome** reachable by doing something unusual (fleeing, refusing to
   act, using a specific item, arriving with a specific companion).

**Anti-repetition audit:** QA maintains a *mechanic matrix* — 17 bosses × mechanic tags.
Any tag appearing more than twice triggers a redesign.

---

## 8.2 The Ten Major Bosses

### B1 · THE TALLY — *Act I, Wyndmarrow*
- **Story.** The Assayer's counting-drone, sent to verify Wyndmarrow's Bell Count. It is
  not attacking. It is *auditing*, and the audit is lethal because it counts you too.
- **Arena.** The bell tower interior — a vertical shaft with eleven bells at eleven
  heights. **Silent bells are solid platforms; ringing bells are not.**
- **New mechanic — THE COUNT.** A number in the corner. Every projectile you *dodge*
  increments it; every projectile your tether *reads* decrements it. **At 90 the Tally
  concludes its audit and the fight ends in failure.** The only way through is to stop
  avoiding and start engaging. It teaches the game's entire thesis in four minutes.
- **Phases.** 3. (Counting · Recounting, faster · Certifying, where it starts counting
  *villagers*.)
- **Rage.** It stops firing and simply counts aloud, faster and faster. Nothing on
  screen. Terrifying.
- **SEVER finisher.** The count is destroyed. Wyndmarrow's tower board goes blank
  forever, which the villagers find worse than a low number.
- **UNKNOT finisher.** Diagnosis: *"It is holding an instruction it doesn't understand."*
  You show it a bell rung by Tilly for her mother. It cannot classify a rung-for bell.
  It excuses itself. Politely.
- **Alternate.** Arrive with the Bell Count at 90 (requires ringing every bell yourself
  before the fight) and the Tally certifies the village and leaves without a fight.
  Achievement: *Fully Compliant.*
- **Theme.** *Audit* — 118 BPM, the village theme played on a single detuned handbell
  over a metronome that is 2 BPM fast.

### B2 · THE RINGER — *Act I, Wyndmarrow (mini-boss)*
A bell that has learned to grieve. Fights entirely by **sound**: attacks are visible
only as sound waves, and the arena is dark. Teaches audio-directional play, which the
whole game later assumes. Alternate: play the third bell's tone (learnable from Tilly)
and it stops.

### B3 · BRIARSOME — *Act I, Grieving Wood (optional major)*
A tree grown from a bond so large it became territorial. **New mechanic — ROOTS:** the
arena grows obstacles that permanently persist across phases, shrinking the field until
you are fighting in a corridor. UNKNOT requires digging up what's buried under it *mid
fight* (Root Reading in combat). The buried thing is a child's shoe. Both routes are
sad; only one is quiet.

### B4 · THE TENTH STRATUM — *Act II, Salt Ledger*
- **Story.** A creature made of a Quiet that hasn't happened yet — sediment from the
  future, which should be impossible, and is the game's first hard proof that the Long
  Quiet is *scheduled*.
- **Arena.** Horizontal strata bands. The arena scrolls **downward** through time; each
  band is a different century with different physics (one band has no gravity — the year
  the Orrery broke).
- **New mechanic — PRECOGNITION.** The boss telegraphs attacks **four seconds early** and
  in the *wrong place*, then executes them where you will be. The counter is to **commit
  to a position and stay**, which is the opposite of everything taught so far.
- **Phases.** 4, one per century.
- **Rage.** Stops telegraphing. Which is a relief, and then isn't.
- **UNKNOT.** *"It is holding a date."* You show it Form 12-B's filing stamp. The date
  is wrong by six months, and the creature — which is only sediment — comes apart with
  something like relief.

### B5 · VELLUM, SECOND AUDIT — *Act II, Verrick Loomworks*
- **The Slack Tether set piece.** Mid-fight, without a cutscene, the Assayer severs one
  of Aven's companions. Tether whitens, drops, HUD reads `— NOBODY —`. **The fight does
  not pause.** Vellum does. He looks at what he's just been party to, and his next
  attack has hesitation frames.
- **New mechanic — MIRROR TETHER.** Vellum has his own tether. It mimics your movement
  from 0.7s ago. Your own greed is used against you, and the counter is to *play against
  your own habits*.
- **Phases.** 3 + the severance interrupt.
- **Alternate.** If your companion at that moment is Moth, the severance **fails** —
  Moth is made of unclaimed Wards and has nothing to cut. Vellum has no procedure for
  this and the fight ends in an argument with a form.

### B6 · THE CANTOR — *Act II, Drowned Choir*
- **Arena.** Underwater. Held Breath is a live resource; surfacing to breathe costs you
  the tether's position.
- **New mechanic — VOICES AS HP.** The Cantor has no health bar. It has **forty voices.**
  Each SEVER silences one, permanently, for the whole save file. UNKNOT requires
  convincing voices to stop *willingly*, one at a time, which requires knowing their
  individual stories — gathered in the overworld beforehand.
- **The cruelty.** Nothing warns you that damage is permanent. The region's ambient mix
  is thinner for the rest of the game. Players notice around 20 minutes later.
- **Rage.** The remaining voices sing louder to cover the gaps.
- **UNKNOT.** *"It is holding a part for someone."* The 41st part. Answering correctly
  requires having counted the seats.

### B7 · THE ORRERY'S KEEPER — *Act III*
Fought across three islands with **independent gravity** — the player re-parents
islands mid-fight (Attachment verb) to change which way "down" is for the boss's
projectiles. Pure spatial mastery. Phases correspond to orbital positions; the fourth
phase happens with the arena *upside down*, and the game does not flip the controls,
which is the point.

### B8 · THE UNREAD — *Act III, Commonplace (optional major)*
Everything nobody ever looked at, in one body. **New mechanic — ATTENTION:** the boss
is only solid while you are *looking at it* (facing direction matters). Its attacks
come from where you aren't. UNKNOT: *"It is holding a readership."* You read one page
aloud. Any page. It has waited a very long time.

### B9 · BOTH ARMIES — *Act III, Ash Garden (optional major)*
A boss with **no aggression whatsoever.** It is walking home. The fight is *stopping* it
— and the game gives you every violent tool and no violent solution. Killing it is
possible and yields nothing: it was already leaving. The only meaningful outcome is
UNKNOT, which requires you to say the one thing that makes an army turn around. The
answer is in the Ash Garden's flower names, including the one you didn't recognise.

### B10 · THE ASSAYER — *Finale*
- **Arena.** The infinite ledger hall, which **narrows one shelf-width per phase.** By
  phase five, you are fighting in a corridor the width of the tether.
- **Phases (5).**
  1. **Intake** — it asks you questions. Your dialogue answers change phase 2's patterns.
  2. **Assessment** — it uses *your own build against you*: your equipped weapon's ring
     shape becomes its attack geometry.
  3. **Precedent** — it replays, in miniature, three bosses you already beat, *in the
     way you beat them.* A merciful player fights merciful ghosts.
  4. **Rage — Efficiency.** No anger. It simply stops leaving gaps. Bullet density
     doubles; telegraphs shorten to their minimum legal 12 frames. It says nothing at
     all for ninety seconds, and that silence is the loudest thing in the game.
  5. **Merit** — the machine's shell opens. Inside is a chair, and someone very small
     and very old who has not been looked at in nine hundred years. **This phase has no
     attacks.** You can still press SEVER. It will work.
- **SEVER finisher.** → BAD ending path (`SEVER`).
- **UNKNOT finisher.** Diagnosis: *"It is holding a debt it invented."* → opens the four
  final verbs.
- **Alternate.** Arrive with Wrath ≤ 5 and it does not fight at all in phase 1; it files
  you as *not a threat* and the fight starts at phase 2 with an apology.

---

## 8.3 The Five Optional Bosses

| Boss | Region | Hook | Reward |
| --- | --- | --- | --- |
| **BRIARSOME** | Grieving Wood | Arena permanently shrinks (see B3) | Relic: *The Shoe* |
| **SISTER ANNIKE** | Hushfell | **Never attacks.** Parries and argues. Winning by SEVER permanently closes the True Ending, unwarned. | Register pages 1–30 |
| **THE UNREAD** | Commonplace | Solid only while looked at (see B8) | Relic: *Marginalia* |
| **BOTH ARMIES** | Ash Garden | Cannot be meaningfully killed (see B9) | Relic: *The Stacked Weapons* |
| **THE THREE-DAY WAIT** | Hushfell | A fight against a clock — you must survive 180 real seconds without acting at all. Any action restarts it. | Achievement + Ossa's true scene |

---

## 8.4 The Two Secret Bosses

### S1 · THE VERSION OF YOU THAT DIDN'T GO — *the Undersleep*
Reached only via the March's twelfth car. An Aven who stayed in the drawer. Fights with
**your exact build, your exact skill tree, and a mirrored version of your last 30
seconds of inputs**, recorded live. It gets better as you get better. It is beatable
only by playing *differently than you have played all game* — which is, mechanically,
the Hidden Ending's thesis. Theme: *As You Remember It (Reprise)*.

### S2 · THE FIRST WARD — *the Keeping* — see §8.6.

---

## 8.5 Mid-Bosses & Recurring Antagonist

**Vellum is fought four times** (Act I mini, Act II major, Act III, Finale-adjacent).
See §04.7. Each fight uses the mirror-tether, but the mirror **degrades** as Vellum
becomes a worse auditor and a better person: fight 1 mirrors you at 0.7s delay
perfectly; fight 4 mirrors you at 1.4s delay and *sometimes doesn't fire.*

Eleven additional mini-bosses, one per region (§03).

---

## 8.6 THE SECRET SUPERBOSS — **THE FIRST WARD**

> *"He said he'd be an hour."*

**The concept.** The first second-heart that ever formed in Vesselmere, nine hundred
years ago, in the chest of a woman waiting at a door for a man who said he'd be an hour.
He was severed — the very first severance, Merit Vane's proof of concept, performed on
Merit's own child. The Ward outlived them both. It is still at the door. It has been
holding the position for nine centuries, and it will not let anything past, because if
he comes back she needs to be able to say she waited.

It is not evil. It is not even hostile, exactly. **You are between it and the door.**

### The unlock chain — designed to take the community weeks

Nine steps, cross-region, none signposted:

1. Find all **nine keyholeless doors** (F14) — one per region, all in plain sight all game.
2. Read all **41 choir parts** and notice the 41st is scored but silent (F08).
3. Play the 41 parts in the March's music car **in the order of the choir seats**, not
   the order collected. The 41st slot plays a **name**.
4. Cross-reference that name in the **Commonplace** using Edda's search — it appears in
   exactly one document: a Registry requisition from year 1.
5. Requisition names a **Salt Ledger stratum**. Dig it. It contains a door-key mould,
   not a key.
6. Cast the key at **Guisley's forge** in Wyndmarrow — requires Guisley alive, which
   requires *Guisley's Last Casting* completed, which requires Hope ≥ 50.
7. The key opens **none** of the nine doors. It opens the **tenth**, which is the drawer
   Aven woke up in, in the Prologue — reachable only via the March.
8. Inside: the **flower you didn't recognise** from the Ash Garden (F12), which is the
   name of Merit's child.
9. Carry it to any of the nine doors. All nine open at once. **The Keeping.**

**Plus one hidden condition the player is never told about:** you must have **never
Unknotted an enemy after a wrong diagnosis in the same encounter** — i.e., never brute-
forced a mercy. The First Ward does not open for someone who guessed at what people are
holding. Tracked from the first fight. Never mentioned. The community will find this
last, and it will be the best day on the forums.

### The fight

| Property | Value |
| --- | --- |
| **Difficulty** | Harder than the Assayer. Explicitly. Target: 25–50 attempts for a skilled player. |
| **Phases** | 7, no checkpoints, ~14 minutes clean |
| **Attack patterns** | **24 distinct patterns**, sorted below |
| **Arena** | A doorway. The entire arena is one door-width wide and infinitely tall. It never changes. Nine centuries of not moving. |
| **Rage** | Phase 7: it stops defending the door and *asks you to check outside.* You cannot. The pattern set becomes pleading. |
| **Music** | ***Still Waiting*** — 44 BPM, solo cello + a door-hinge sample used as percussion + a choir that enters only in phase 6, singing the 41st part. **9:40 long, one crescendo, no drop.** |

**The 24 patterns** (families of three, escalating):

*Waiting (1–3):* Hourglass · The Long Minute · Counting the Grain
*Listening (4–6):* Footsteps That Aren't · Every Door in the House · The Latch
*Hoping (7–9):* One More Hour · It's the Weather · He Wouldn't
*Bargaining (10–12):* Terms · Small Print · Continued Regard
*Refusing (13–15):* Not Past Me · The Threshold · Nine Hundred
*Remembering (16–18):* The Gap in Her Teeth · How He Held a Cup · What He Said Last
*Waiting Again (19–21):* Hourglass II · The Long Century · Counting the Grain, Faster
*Opening (22–24):* The Handle Turns · It Isn't Him · Please Check

**The finisher.** SEVER works. It has always worked; nine hundred years of nothing has
left it very tired. The SEVER ending of this fight is 40 seconds long and is the single
worst thing in the game.

**UNKNOT.** Diagnosis: *"It is holding a door."* There is no clever answer. You do not
tell it he isn't coming. **You wait with it.** The UNKNOT action here is to stop
playing — put the controller down. The game detects zero input for 60 seconds and then
the door opens, from the other side, and what comes through is not him and it is not
nothing.

### The special ending — **HUSH**

Defeating (either way) the First Ward unlocks the **Hidden Ending**, `HUSH`, available
only at the Finale and only to a player who has also refused the Assayer's four verbs
three times. See §10.5.

---

## 8.7 Enemy Roster — 84 Types, 9 Families

Every enemy type carries: **sprite set + 6 animations · 2 weaknesses · AI trunk ·
personality · 3+ dialogue lines · 1 common drop · 1 rare drop (3%) · 1 diagnosis.**

| # | Family | Types | AI trunk | Personality axis | Rare drop theme |
| --- | --- | --- | --- | --- | --- |
| 1 | **Clerical** (Filing Error, Misfiled Grief, Overdue Notice, Duplicate, Addendum…) | 11 | Grid-locked, orderly, predictable | Officious, apologetic | Forms |
| 2 | **Bellwork** (The Ringer's kin — Cracked Peal, Tolling, Muffled…) | 8 | Sound-telegraphed, rhythmic | Mournful | Bell-metal |
| 3 | **Rootbound** (Grieving Wood — Keepsake, Understory, Deep Root…) | 10 | Territorial, area-denial | Protective, wordless | Buried objects |
| 4 | **Willing** (Hushfell — Candidate, Cooling-Off, Register Page…) | 7 | **Do not attack unless attacked** | Serene | Register entries |
| 5 | **Saltborne** (Strata, Dune Registrar's Queue, Precipitate…) | 9 | Slow, precognitive, positional | Patient, bureaucratic | Strata cores |
| 6 | **Loomkin** (Verrick — Slub, Warp, Weft, Quality Control…) | 12 | Fast, mechanical, pattern-locked | Industrious, blank | Thread |
| 7 | **Sunken** (Drowned Choir — Part, Descant, Undertow…) | 9 | Harmonic; they *combine* when adjacent | Musical, insistent | Choir parts |
| 8 | **Orbital** (Orrery — Apogee, Perigee, Untethered…) | 8 | Gravity-driven, momentum-based | Detached | Orrery brass |
| 9 | **Unread** (Commonplace / Ash Garden — Marginalia, Footnote, Erratum, Ash…) | 10 | Attention-based, exists when observed | Desperate to be noticed | Pages |

**Family AI trunks** mean 9 behaviour scripts, not 84 — types differentiate through
data (pattern sets, speeds, telegraph lengths, dialogue). This is the scope-control
decision that makes 84 enemies achievable by a small team (§14, §17).

**No enemy is a reskin.** Every one of the 84 has its own diagnosis, its own three
lines, and its own reason for being where it is. QA's per-family review checks that a
player can distinguish any two members of the same family *by behaviour alone*, with
sprites hidden.
