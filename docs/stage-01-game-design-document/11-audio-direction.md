# 11 — Music & Sound Direction

> Full scores, stem maps, transition matrices and middleware routing are
> **Stage 8 (Music Bible)**. This chapter fixes the leitmotifs, the 34-track manifest
> with full musical specification, and the reactive-score architecture.

---

## 11.1 The Palette

SECONDHEART's soundtrack is **small-ensemble acoustic music with industrial
intrusions**. Nothing is orchestral-epic. The largest force heard in the game is 41
voices, and they are underwater.

**Core instruments** (present across the score): felted upright piano · cello · nylon
guitar · hammered dulcimer · handbells · celesta · clarinet · accordion · upright bass ·
brushed kit · glass harmonica · viola.

**Found-sound percussion** (the score's signature): paper rustle · typewriter · loom
shuttle · door hinge · bell-metal · coupling strain · breath.

**The rule:** every region's percussion is made from **objects that exist in that
region**. Verrick's kit is looms. The Assay's kit is typewriters and falling paper.
Wyndmarrow's is bell-metal and rope. This is why the soundtrack sounds like a *place*
and not like a genre.

---

## 11.2 The Four Leitmotifs

Everything in the score is built from these. They are stated, hidden, inverted, and
finally combined.

### **L1 — "Where I Kept It"** *(the main motif)*
Five notes, descending: **B♭ – A – F – E♭ – D**. A minor sixth that *doesn't resolve
down* to the tonic; it lands one step short and stops. The entire soundtrack is built
around a phrase that fails to arrive.
- **Appears:** main theme, credits, every emotional cue, and — inverted — in the
  Assayer's theme.
- **The trick:** the fifth note (D) is **withheld** in every Act I and II statement.
  The motif plays four notes and stops. The first complete five-note statement in the
  game is at the moment the player learns what Aven is carrying, and playtesters cry
  before they know why.

### **L2 — "The Ledger Line"** *(the Assayer)*
A metronomic ostinato: quarter notes, no swing, no dynamics, in **7/8** — so it never
quite lines up with anything else in the score. Institutional, tireless, not evil.
- **Appears:** anywhere bureaucracy touches. It is *under* the Wyndmarrow theme from the
  first bar of the game, at −28dB, and nobody notices until Act II.

### **L3 — "Two Beats"** *(the tether / companions)*
A syncopated double-pulse, **2-against-3**, played on any two instruments that shouldn't
blend. It is a heartbeat that has learned to be two heartbeats.
- **Each companion owns one variation:** Tilly (handbell + rope creak), Moth (twelve
  voices, none sustained), Barro (loom shuttle + music box), Sennet (breath + water),
  Rue (coupling strain + accordion).
- **When a companion is severed, their variation is removed from the entire soundtrack
  for the rest of the save file.**

### **L4 — "Still Waiting"** *(the First Ward)*
A single sustained note, 44 BPM, that changes **nothing** for nine bars and then moves
by a semitone. Nine centuries in a semitone.
- **Appears:** as one note, unaccompanied, in exactly six places across the game before
  the superboss. Finding all six is a community project.

---

## 11.3 The 34-Track Manifest

Every track specified as required: **BPM · instruments · emotion · melody style ·
progression · leitmotifs.**

### Required Core Tracks

| # | Track | BPM | Instruments | Emotion | Melody style | Progression | Leitmotifs |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 01 | **Where I Kept It** *(Main Theme)* | 72 | Felted piano, cello, distant handbell, tape hiss | Aching, unresolved, warm at the edges | Slow four-note statement of L1 with the fifth note absent; answered by cello a fourth below | i – VI – III – VII (never reaches the tonic; loops on VII) | **L1** (incomplete), L2 at −28dB |
| 02 | **A Place Already Made** *(Menu)* | 60 | Celesta, nylon guitar harmonics, room tone | Patient, hospitable, slightly sad | Two-bar celesta figure, never developed; guitar answers late | i – iv – i – iv, static | L1 fragment (2 notes) |
| 03 | **Ninety Bells** *(Village — Wyndmarrow)* | 96 | Hammered dulcimer, tin whistle, bodhrán, handbells, fiddle | Communal, bustling, *performing* okayness | Bright modal jig over a drone; the whistle line is L1 played *upward*, which is the village pretending | I – ♭VII – IV – I, then a bar of 5/4 that trips | L1 (inverted), L2 (buried), L3 (Tilly) |
| 04 | **What We Planted** *(Forest — Grieving Wood)* | 74 | Nylon guitar, bowed vibraphone, field-recorded wind, cello harmonics | Green, hushed, custodial | Guitar arpeggio in 6/8; melody enters only every third cycle, as if reluctant | i – III – VII – iv, cyclic, no cadence | L1 (3 notes, in the vibraphone) |
| 05 | **Everything Anyone Wrote Down** *(Desert — Salt Ledger)* | 88 | Hammered dulcimer, processed paper-rustle kit, bowed bass, shruti drone | Vast, dry, archival, patient | Long modal lines over an unchanging drone; phrases get *shorter* each cycle as if eroding | Drone on D throughout; melody moves i – ♭II – i (Phrygian) | L2 (in the paper percussion, exactly), L1 (once, at 4:10) |
| 06 | **A Kind Room** *(Snow — Hushfell)* | 58 | Felted piano, close-mic'd breath, one distant bell, clarinet | Gentle, unbearable, genuinely kind | Simple hymn-like piano; clarinet enters as a second voice and *agrees* with everything | I – vi – IV – I. **The only fully resolving progression in the game.** | L1 complete but in **major** — the game's cruellest musical joke |
| 07 | **Floor Nine** *(Industrial — Verrick Loomworks)* | 132 | Loom-shuttle percussion, detuned upright bass, brass stabs, **music box** | Driving, impersonal, one small human thing | Machine ostinato in 4; music box plays an unrelated lullaby *over* it in 3, never syncing | Modal, riff-based, i – i – i – ♭VI | L3 (Barro) in the music box; L2 in the shuttle |
| 08 | **The Forty-First Part** *(Drowned Choir)* | 52 | 41 voices, submerged reverb, no instruments | Sacred, drowned, held | Choral drone in 41 parts; **the 41st part is scored, notated, and silent** | Slow harmonic drift, i – ♭VII – ♭VI – ♭VII, no arrival | **L4** (the held note is the 41st part's rest) |
| 09 | **Never Once Stopped** *(March — hub)* | 108 | Accordion, upright bass, brushed kit, coupling-strain percussion, fiddle | Warm, competent, moving, tired | Rolling melody that hands off between accordion and fiddle mid-phrase, like a shift change | I – V – vi – IV, but the bar lengths are 4/4/4/**3** — it never quite settles | L3 (Rue), L1 (in the bass, 2 notes) |
| 10 | **Everything Holds Something** *(Orrery)* | 70 | Glass harmonica, pizzicato strings, gear-tick percussion in 7/8 | Weightless, mathematical, lonely | Interlocking pizzicato cells that rotate against each other; melody is emergent, never played | Polymetric: 7/8 gears against 4/4 melody, aligning every 28 bars | L2 (as the gear tick — the Assayer's meter, revealed as *cosmic*) |
| 11 | **Read by Weight** *(Ancient Ruins — the Commonplace)* | 66 | Harp, clarinet, bowed guitar, page-turn percussion | Dusty, reverent, enormous | **The melody is assembled from 8-bar fragments of every region theme the player has visited**, stitched in order of visit | Through-composed; no repeat | All four; the only track containing every leitmotif before the finale |
| 12 | **Nobody Fought Here** *(Ash Garden)* | 80 | Solo viola, prepared piano, military snare in the wrong key, ash-fall shaker | Desolate, tender, wrong | Viola plays a march that keeps *slowing to a walk* | Ambiguous tonality; the snare is a semitone off the viola for the entire track | L1 (as the march), L4 (final 20s) |
| 13 | **Somewhere To Put It Down** *(Emotional Theme)* | 64 | Solo cello, then piano, then everything | Grief, given room | **The first complete five-note statement of L1 in the game.** Stated once, alone, then harmonised by each companion's L3 variation in turn | i – VI – III – **i** (the resolution the main theme never gets) | **L1 complete**, all L3 variants |
| 14 | **Audit** *(Boss Theme 1 — the Tally)* | 118 | Single detuned handbell, metronome 2 BPM fast, dulcimer, clipped brass | Officious, mounting, absurd, frightening | The village theme's whistle line, played by a machine that doesn't understand phrasing — no breaths, no rubato | I – ♭VII – IV – I but each loop is **one beat shorter** | L2 dominant, L1 (village version) mangled |
| 15 | **A Clerk, Ascending** *(Boss Theme 2 — Vellum)* | 126 | Typewriter kit, staccato strings, clarinet, brass | Comic menace → panic → grief | 8-bar theme. **Transposed up one semitone per encounter (4 total)**; arrangement loses one instrument each time it rises | ii – V – i, textbook, executed perfectly, then increasingly not | L2 (his employer), L3 emerging in fight 3 — *Vellum grows a heart and the score shows it before the script does* |
| 16 | **The Ledger Line** *(Final Boss — the Assayer)* | 100 | Prepared piano, typewriter percussion, choir that never resolves, sub-bass | Calm, tireless, sorrowful, immense | L2's ostinato as the entire foundation; melodic material is **L1 played backwards** | 7/8 ostinato under a 4/4 choir; they align exactly once, in phase 5 | **L2** (theme), **L1 inverted**, L4 in phase 5 |
| 17 | **Still Waiting** *(Secret Boss — the First Ward)* | 44 | Solo cello, door-hinge percussion, 41-voice choir entering only at phase 6 | Devotion past the point of reason | One note. Nine bars. A semitone. Repeat, an octave up, forever | Almost none. **9:40 of a single crescendo with no drop.** | **L4** (whole track), L1's fifth note finally arriving at 8:52 |
| 18 | **Whatever Number You Earned** *(Credits)* | 84 | Full ensemble: every instrument in the game, one at a time, joining | Earned, unresolved, alive | Each region theme's opening phrase, in visit order, handed between instruments; L1 stated complete at the end by whichever instrument belongs to your dominant companion | Modulates up through every region's key, arriving home | **All four**, in counterpoint |

### Additional Tracks (16)

| # | Track | BPM | Use | Notes |
| --- | --- | --- | --- | --- |
| 19 | **Catalogue** | 62 | Prologue | Celesta + tape hiss + one held cello note that never changes for 4 minutes |
| 20 | **The Third Bell** | 96 | Wyndmarrow, night | *Ninety Bells* with everything removed except the bells |
| 21 | **Root Reading** | 68 | Grieving Wood, digging | Diegetic; the tree's own bond, played on whatever instrument suits the buried object |
| 22 | **The Register of Willing** | 54 | Hushfell interior | 300 entries as 300 piano notes, one per entry read |
| 23 | **The City Under the City** | 82 | Salt Ledger depths | *Everything Anyone Wrote Down* played backwards and slowed 40% |
| 24 | **Eleven Regulation Eyelets** | 132 | Barro's workshop | The music box alone, with the loom kit *muted but audible through a wall* |
| 25 | **Sennet Surfaces** | 52→96 | Choir quest resolution | Begins submerged, and the reverb *dries out* over 3 minutes as he rises |
| 26 | **Coupling Duty** | 108 | March, working | *Never Once Stopped* arranged for percussion only. Weirdly beloved in playtest. |
| 27 | **Apogee** | 70 | Orrery mini-boss | 7/8 gear tick with the melody in 5/4 |
| 28 | **The Marginalia** | 66 | Commonplace mini-boss | Every instrument plays a footnote to the last thing it played |
| 29 | **As You Remember It** | 60 | The Undersleep | Every region theme detuned **12 cents flat**, on music box. Uncanny, warm, wrong. |
| 30 | **The Version Of You** | 60 | Secret boss S1 | Your dominant companion's L3 variation, played by nobody — the instrument is *absent* and only the reverb of it remains |
| 31 | **Still Warm** | 54 | The Keeping | **All four leitmotifs simultaneously, in counterpoint, full ensemble.** The only time the score is large. |
| 32 | **The Flood** | 76 | KEEPING ending epilogue | 14 minutes; begins as chaos, resolves into a single communal melody nobody is leading |
| 33 | **Pending** | 100 | LEDGER ending epilogue | *The Ledger Line* with the choir removed, forever |
| 34 | **A Tuesday in the Year Eleven** | 56 | HUSH ending | Solo felted piano. One take. Audible pedal, audible breath, one wrong note left in. |

---

## 11.4 Reactive Score Architecture

The score is **stem-based**, not track-swapped. Every region theme is authored as 4–9
stems with independent volume automation driven by game state.

| Reaction | Driver | Example |
| --- | --- | --- |
| **Instrument loss** | Permanent world state | Each severed Wyndmarrow villager mutes one *Ninety Bells* stem, forever, on that save |
| **Companion motif** | Active companion | The L3 variation in the current region theme is always the companion you're carrying |
| **Route colour** | Act II checkpoint | CARRY adds a warm string bed; LEDGER strips reverb and adds a low sine; DRIFT detunes everything 4 cents |
| **Diegetic score** | The Drowned Choir | The region music *is* 41 NPCs. Silencing one removes a voice from the mix at the source. |
| **Tension** | Weave phase state | STRAIN raises a dissonant harmonic layer; SNAP cuts all music for 0.4s |
| **Emotional intensity** | Boss phase + player HP | Bosses cross-fade between three arrangements of the same track, never between tracks |

**Transition rule:** the score never hard-cuts except on a SNAP. All transitions are
beat-synced with a 1-bar tail. Middleware: **FMOD** (or Godot's `AudioStreamInteractive`
if the FMOD dependency is cut — decision deferred to Stage 14).

---

## 11.5 Sound Design

**The design brief: the player should be able to fight with their eyes closed and lose
gracefully.**

| Layer | Approach |
| --- | --- |
| **Projectiles** | Every enemy family has a distinct spawn timbre. Position is panned and pitched by distance from Self. Blind-playability is a stated (not fully achieved) target. |
| **Tether** | A continuous, quiet harmonic tone whose pitch rises with tether length. Players stop looking at the tether after two hours and start *hearing* it. This is the single best piece of sound design in the project. |
| **Strain** | A rope-fibre creak layered under the tether tone, entering at 40 Strain. |
| **SNAP** | A rope-and-heartbeat composite, deliberately unpleasant, mixed 4dB above everything. Designed to be hated. |
| **SWAP** | A soft inhale. Not a whoosh. The dodge sounds like a breath because the game is about breathing. |
| **Severance (world)** | A silence, not a sound. 0.6s of *total* audio duck, including ambience. Used exactly 19 times in the game. |
| **UI** | Paper. Every menu sound is paper — turning, stamping, filing, tearing. |
| **Footsteps** | 14 surface types × 3 gaits. Snow accumulates and the footstep changes as it does. |
| **Voice** | **No voice acting.** Characters have *phonetic babble* tuned per character (pitch, rate, consonant density). Moth's babble is a blend of every other character's. |

---

## 11.6 The Music-as-Consequence Contract

This is a Pillar IV commitment and it is expensive, so it is stated here as policy:

> **Music state is save-file-permanent and never restored.** No ending, no NG+, no
> quest reverses a lost stem. A player who reaches the finale with a five-instrument
> *Ninety Bells* hears a village that has been hollowed out, and there is no way to get
> the instruments back, because there isn't in life either.

QA gate: a "music state diff" tool that dumps active stems per region per save, used to
verify that no code path re-enables a muted stem.
