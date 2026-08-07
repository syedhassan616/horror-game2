# 03 — Boss Phase Tables

All 17 bosses, phase by phase. `T` = telegraph frames. Density = max simultaneous.

---

## B1 · THE TALLY — Act I, WYN-06

**Resource:** THE COUNT (0→90). Dodged projectiles **+1**. Tether-read projectiles **−1**.
At 90 the audit concludes and the fight is lost. **The only way through is to stop
avoiding.**

| Phase | HP | Patterns | T | Density | Dialogue |
| --- | --- | --- | --- | --- | --- |
| 1 Counting | 100–66% | `CLR.Queue`, `BLW.Peal` | 24 | 60 | States its authority |
| 2 Recounting | 65–33% | +`CLR.Alphabetical`, tempo +12% | 20 | 110 | Asks who rang bell 44 |
| 3 Certifying | 32–0% | +`CLR.Cross-Reference`, counts **villagers** | 18 | 160 | Names actual Wyndmarrow NPCs |
| **Rage** | <15% | **Stops firing.** Counts aloud, accelerating. Empty screen. | — | 0 | Numbers only |

**UNKNOT** *"an instruction it doesn't understand"* — show it a rung-for bell.
**Alternate:** arrive at Bell Count 90 → it certifies and leaves. Achievement #33.
**Loss state is not death:** the audit concludes, eleven more villagers are severed, and
the game continues. **The only unwinnable-by-attrition fight that does not reload.**

---

## B3 · BRIARSOME — GRV-09 *(optional)*

**Mechanic:** ROOTS. Obstacles persist **across phases**, shrinking the arena permanently.

| Phase | HP | Patterns | Arena | Notes |
| --- | --- | --- | --- | --- |
| 1 | 100–60% | `RTB.Thicket`, `RTB.Understory` | 320×180 | |
| 2 | 59–25% | +`RTB.Deep Root` | ~260×150 | Digging enabled mid-fight |
| 3 | 24–0% | +aimed `Weight` | ~180×110 | Corridor |
| Rage | <10% | Roots grow **toward** Self | ~120×90 | |

**UNKNOT** requires **Root Reading during combat** — dig the buried object while dodging.
It is a child's shoe.

---

## B4 · THE TENTH STRATUM — SLT-12

**Mechanic:** PRECOGNITION. Telegraphs 240f early **in the wrong place**, then fires where
you will be. Counter: commit to a position and hold it.

| Phase | Band | Physics | Patterns |
| --- | --- | --- | --- |
| 1 · Yr 903 | Surface | Normal | `SLT.Precognition` |
| 2 · Yr 744 | −1 | Wind drift | +`SLT.Strata` |
| 3 · Yr 401 | −2 | **Zero gravity** *(the year the Orrery broke)* | +`ORB.Apogee` |
| 4 · Yr 5 | −3 | Heavy | +`CLR.Queue` — the first Quiet's patterns, unchanged |
| Rage | — | **Stops telegraphing** | All four, simultaneously |

**Phase 4 is the game's quietest horror:** the year-5 patterns are *identical* to the
tutorial's, because the machine has never changed.

---

## B5 · VELLUM, SECOND AUDIT — VRK-15

**Mechanic:** MIRROR TETHER. Vellum's tether replays Aven's movement from 42f ago.

| Phase | HP | Patterns | Mirror lag | Notes |
| --- | --- | --- | --- | --- |
| 1 | 100–70% | `LMK.Warp`/`Weft`, `CLR.Duplicate` | 42f, perfect | Formal, funny |
| 2 | 69–40% | +aimed bolts | 42f | **THE SLACK TETHER fires at 55%** |
| 3 | 39–0% | +`CLR.Cross-Reference` | 48f, **hesitation frames** | He has seen it |

**The Slack Tether** (S-252): scripted at 55% HP, no cutscene, no pause. Companion severed;
HUD reads `— NOBODY —`. **Survivable; kills most players once.**

**Moth exception:** severance returns `NO PROCEDURE`. Fight ends in an argument with a form.
**Rue exception:** returns `NO ACTION REQUIRED` — the Act II catch (§10 of Story Bible).

---

## B6 · THE CANTOR — CHR-08

**No HP bar. Forty voices.** Each SEVER silences one **permanently on the save file.**

| Phase | Voices | Patterns | Notes |
| --- | --- | --- | --- |
| 1 | 40–30 | `SNK.Harmony` ×4 pairs | Merging taught |
| 2 | 29–15 | +`SNK.Undertow` | **Skipped entirely if Sennet was Unknotted** |
| 3 | 14–1 | +aimed beams | Remaining voices sing *louder* to cover gaps |
| Rage | ≤5 | Everything | The harmony breaks. It is audibly wrong. |

**UNKNOT** *"a part for someone"* — requires having counted the seats (Quest 25).
Convincing voices to stop willingly requires knowing their individual stories, gathered in
the overworld beforehand. **The pacifist clear takes ~3× longer and needs prep work.**

---

## B7 · THE ORRERY'S KEEPER — ORR-10

| Phase | Islands | Gravity | Patterns |
| --- | --- | --- | --- |
| 1 | 1 | Down | `ORB.Apogee` |
| 2 | 2 | Independent per island | +`ORB.Reparent` |
| 3 | 3 | Player re-parents mid-fight | +`RING` volleys that re-path on flip |
| 4 | 3 | **Arena inverted.** Controls are NOT flipped. | All |

---

## B8 · THE UNREAD — CMN-09 *(optional)*
Solid only while in the player's facing cone. Attacks originate from where you aren't.
Four phases, escalating `UNR.Footnote` accumulation.
**UNKNOT:** *"a readership."* Read one page aloud. Any page.

## B9 · BOTH ARMIES — ASH-08 *(optional)*
**No aggression whatsoever.** It is walking home. Stopping it is the fight. Damage is
possible and yields nothing. **The only meaningful outcome is UNKNOT**, which requires
saying the one thing that turns an army around: Corrin Vane's name.

## Mini-bosses (11)
The Ringer (WYN, audio-only, dark arena) · The Understory (GRV, splits on mercy) ·
The Three-Day Wait (HSH, **survive 180s without acting**; any action restarts) ·
The Dune Registrar's Queue (SLT) · Quality Control (VRK, rejects you as defective) ·
The Undertow (CHR) · The Coupling (MAR, moving train) · Apogee (ORR) ·
The Marginalia (CMN) · The Walk Home (ASH) · Vellum First Audit (WYN).

---

## B10 · THE ASSAYER — ASY-04/05

**Arena narrows one shelf-width per phase.** By phase 5 it is the width of the tether.

| Phase | HP | Mechanic | T | Density |
| --- | --- | --- | --- | --- |
| **1 Intake** | 100–80% | Asks intake questions; **player's answers select phase 2's pattern set** | 24 | 200 |
| **2 Assessment** | 79–55% | **Equipped weapon's ring shape becomes its attack geometry** | 18 | 340 |
| **3 Precedent** | 54–30% | Replays 3 defeated bosses in miniature, **in the way you beat them** | 18 | 400 |
| **4 Efficiency** *(rage)* | 29–5% | No anger. **Stops leaving gaps.** 90s of total silence. | **12** | 900 |
| **5 Merit** | <5% | **No attacks.** The shell opens. `SEVER` still works. | — | 0 |

**Phase 3's selection:** the three bosses are chosen as most-recently-defeated, and their
miniatures use the player's *own* resolution style — a merciful player fights merciful
ghosts that try to Unknot *them*.

**Alternate:** arrive with Wrath ≤ 5 → phase 1 is skipped; it files Aven as *not a threat*
and opens at phase 2 with an apology.

---

## S1 · THE VERSION OF YOU THAT DIDN'T GO — UND-04

Fights with the player's **exact build and skill tree**, mirroring the last 30 seconds of
inputs, recorded live. It improves as the player improves.

**Beatable only by playing differently than you have played all game.** Five phases;
each phase raises the mirror fidelity. Phase 5 mirrors at 6-frame lag.

**On NG+ it mirrors the *previous run's* build**, not the current one.

---

## S2 · THE FIRST WARD — KEP-02

**Difficulty target: harder than the Assayer. 25–50 attempts for a skilled player.**
**7 phases, no checkpoints, ~14 minutes clean. Arena: one door-width, infinitely tall.**

| Phase | Family | Patterns | T | Density | Music |
| --- | --- | --- | --- | --- | --- |
| 1 Waiting | Hourglass · The Long Minute · Counting the Grain | 3 | 24 | 300 | Cello alone |
| 2 Listening | Footsteps That Aren't · Every Door in the House · The Latch | 3 | 20 | 500 | +hinge |
| 3 Hoping | One More Hour · It's the Weather · He Wouldn't | 3 | 18 | 700 | |
| 4 Bargaining | Terms · Small Print · Continued Regard | 3 | 18 | 900 | |
| 5 Refusing | Not Past Me · The Threshold · Nine Hundred | 3 | 16 | 1,200 | |
| 6 Remembering | The Gap in Her Teeth · How He Held a Cup · What He Said Last | 3 | 14 | 1,400 | **+41-voice choir** |
| 7 Opening | Waiting Again ×3 · The Handle Turns · It Isn't Him · **Please Check** | 6 | **12** | **2,000** | Full |

**24 patterns.** Phase 7's rage is not aggression — **it stops defending the door and asks
you to check outside.** You cannot. The pattern set becomes pleading.

**SEVER finisher:** works, has always worked. 40 seconds. The worst thing in the game.
**UNKNOT:** *"a door."* The action is **to stop playing.** 60 seconds of zero input, then
the door opens from the other side.

**NG+:** +6 patterns, family *"Nine Hundred and One."*

---

## Boss Law Compliance Matrix

| Boss | New mechanic | Arena argues | Rage = character | Both finishers | Reactive dialogue | Unique cutscene | Alternate outcome |
| --- | --- | --- | --- | --- | --- | --- | --- |
| B1 Tally | ✅ Count | ✅ Bells as platforms | ✅ Counts aloud | ✅ | ✅ | ✅ | ✅ Compliant |
| B3 Briarsome | ✅ Shrinking | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ Flee |
| B4 Tenth Stratum | ✅ Precognition | ✅ Time bands | ✅ Stops telegraphing | ✅ | ✅ | ✅ | ✅ Stamp |
| B5 Vellum | ✅ Mirror | ✅ Gantry | ✅ Hesitation | ✅ | ✅ | ✅ | ✅ Moth |
| B6 Cantor | ✅ Voices=HP | ✅ Amphitheatre | ✅ Louder | ✅ | ✅ | ✅ | ✅ Sennet |
| B7 Keeper | ✅ Gravity | ✅ Orbits | ✅ Inversion | ✅ | ✅ | ✅ | ✅ |
| B8 Unread | ✅ Attention | ✅ Stacks | ✅ | ✅ | ✅ | ✅ | ✅ Read aloud |
| B9 Both Armies | ✅ No aggression | ✅ Battlefield | ✅ Walks faster | ✅ | ✅ | ✅ | ✅ Let go |
| B10 Assayer | ✅ Precedent | ✅ Narrowing | ✅ Efficiency | ✅ | ✅ | ✅ | ✅ Wrath ≤5 |
| Annike | ✅ Defence-only | ✅ Snowfield | n/a | ✅ | ✅ | ✅ | ✅ Refuse |
| 3-Day Wait | ✅ Inaction | ✅ Clock yard | n/a | ✅ | ✅ | ✅ | ✅ |
| S1 Version | ✅ Input mirror | ✅ Dream | ✅ | ✅ | ✅ | ✅ | ✅ |
| S2 First Ward | ✅ Wait to win | ✅ **A doorway** | ✅ Pleads | ✅ | ✅ | ✅ | ✅ |

**All 17 pass all seven Boss Law criteria** (GDD §08.1). No tag appears more than three
times; no two bosses share more than one tag.
