# SECONDHEART — Music Bible (Stage 8)

Expands GDD §11 into composition-ready specification. The 34-track manifest with full
BPM/instrument/emotion/melody/progression/leitmotif data is in **GDD §11.3** and is not
duplicated here; this document adds what a composer needs to actually write.

| # | Document |
| --- | --- |
| 00 | Leitmotifs, Harmony & Stem Architecture *(this file)* |
| 01 | [Sound Design Bible](01-sound-design.md) |

---

## 8.0.1 The Four Leitmotifs — Notated

### L1 · "Where I Kept It"
```
B♭4 – A4 – F4 – E♭4 – D4      (in Gm / B♭ major ambiguity)
 1     7    5    4    3        scale degrees in B♭
```
A descending line that lands on **3**, one step short of resolution, and stops.

**The withholding rule.** In every Act I and Act II statement, **only the first four notes
play.** The D is absent. The motif states itself and fails to arrive, 40+ times, for four
hours.

| Statement | Where | Notes played |
| --- | --- | --- |
| Main theme | Title, menu | B♭ A F E♭ — |
| Village, forest, desert, snow, industrial, choir, hub | Acts I–II | 2–4 notes, fragmentary |
| **Somewhere To Put It Down** | The emotional theme, Act III | **All five, alone, unaccompanied** |
| The Ledger Line | Finale | All five, **retrograde**: D E♭ F A B♭ |
| Still Waiting | Superboss, 8:52 | The D, sustained 14 seconds, over the choir |
| Credits | End | All five, by the instrument of the player's dominant companion |

**The first complete statement is the emotional climax of the score**, and playtesters cry
before they consciously register why.

### L2 · "The Ledger Line"
```
7/8 ostinato, quarter notes, no swing, no dynamics
D – D – D – D – F – D – D    (repeat, ad infinitum)
```
Institutional, tireless, not evil. **Present from bar one of the game at −28 dB**, under
*Ninety Bells*, and nobody notices until Act II.

Because it is in 7/8 against everything else's 4/4 or 6/8, **it never lines up.** It
aligns with the choir exactly once, in the Assayer's phase 5.

### L3 · "Two Beats"
```
2-against-3, on any two instruments that shouldn't blend
Instrument A: ♩ ♩ ♩       (3 in the space)
Instrument B: ♩. ♩.       (2 in the space)
```
A heartbeat that has learned to be two heartbeats — literally the Ward's pulse running
behind the first heart's (Story Bible §1.1).

| Companion | Instrument pair |
| --- | --- |
| Tilly | Handbell + rope creak |
| Moth | Twelve voices, none sustained |
| Barro | Loom shuttle + music box |
| Sennet | Breath + water |
| Rue | Coupling strain + accordion |

**When a companion is severed, their L3 variation is removed from the entire soundtrack
for the rest of the save file.**

### L4 · "Still Waiting"
```
One note. Nine bars. Then a semitone.
```
44 BPM. Nine centuries in a semitone. Appears unaccompanied in exactly **six** places
before the superboss:

1. The Unclaimed, aisle 900, if the player stands still 40 seconds
2. Wyndmarrow, House Twelve, on entry
3. The Salt Ledger, the sorted dig site
4. The Drowned Choir, the 41st seat
5. The Orrery, the empty orbit
6. The Ash Garden, the flower you don't recognise

**Finding all six is a community project.** Nothing marks them.

---

## 8.0.2 Harmonic Language

| Element | Rule |
| --- | --- |
| **Tonal centre** | The score lives in **B♭ / Gm**. Regions modulate away and return. |
| **Cadences** | **Almost nothing resolves.** Region themes loop on VII or IV. |
| **The exception** | *A Kind Room* (Hushfell) is **I – vi – IV – I** — the only fully resolving progression in the game, and it plays in the building where people go to stop feeling things. This is the score's cruellest joke and it is never explained. |
| **Modes** | Village = mixolydian · Forest = dorian · Desert = phrygian · Snow = ionian *(see above)* · Industrial = aeolian riff · Choir = drifting modal · Orrery = polymetric, no functional harmony |
| **Meter** | 4/4 and 6/8 for the human world; **7/8 for anything the Assayer touches.** The Orrery's gear tick is 7/8 — the reveal that the machine's meter is *cosmic*, planted without a word. |
| **Tempo** | 44–132 BPM across the whole score. Nothing faster. The one 132 (Verrick) is a machine, not excitement. |

---

## 8.0.3 Stem Architecture

Every region theme is authored as **4–9 stems** with independent volume automation.
**~180 stems total.**

```
StemMap (resource)
  track_id        : StringName
  stems           : Array[StemDef]
  reactive_rules  : Array[ReactiveRule]

StemDef
  id, bus, base_db, fade_frames

ReactiveRule
  condition   : "bell_count < 65" | "companion == tilly" | "voices_silenced > 10" | ...
  action      : MUTE | UNMUTE | DUCK(db) | SWAP(stem_id)
  permanent   : bool          # if true, no rule may ever re-enable it
```

### The permanence contract

```gdscript
func mute_permanent(stem_id: StringName) -> void:
    GameState.music.permanently_muted[stem_id] = true
    # There is no unmute path. This is enforced by the AudioDirector, which
    # ignores UNMUTE actions targeting a permanently muted stem, and by the
    # Music State Diff CI tool, which fails the build on a re-enable.
```

**No ending, no NG+, no quest reverses a lost stem.** A player reaching the finale with a
five-instrument *Ninety Bells* hears a hollowed-out village, and there is no way to get
the instruments back, because there isn't in life either.

### Reaction table

| Reaction | Driver | Permanent |
| --- | --- | --- |
| Instrument loss | Each severed Wyndmarrow villager | **Yes** |
| Choir voice loss | Each SEVER on a Sunken enemy or the Cantor | **Yes** |
| Companion motif | Active companion → L3 variation | No |
| Companion loss | Severed companion → L3 removed everywhere | **Yes** |
| Route colour | Act II checkpoint | No (route-locked) |
| Tension | STRAIN → dissonant layer; SNAP → **all music cuts 24 frames** | No |
| Boss intensity | Cross-fade between 3 arrangements of the *same* track, never between tracks | No |

### Route colour

| Route | Treatment |
| --- | --- |
| CARRY | +warm string bed, +2 dB on all L3 stems |
| LEDGER | Reverb stripped to near-dry; a low sine at 42 Hz added under everything |
| DRIFT | Everything detuned 4 cents flat |

---

## 8.0.4 Transitions

- **Beat-synced, 1-bar tail.** No hard cuts anywhere except SNAP.
- Region→region: crossfade at the next bar line, with the incoming region's bell tone as
  the pivot.
- Overworld→combat: the region theme **does not stop.** It ducks 9 dB and the combat layer
  enters on top. The player never loses the place they are in.
- Combat→resolution: on UNKNOT, the combat layer **drops out on the beat** and the region
  theme comes back up. On SEVER, it stops on the *off*-beat, which is subtly wrong, and
  which nobody consciously notices.

---

## 8.0.5 The Drowned Choir — Diegetic Spec

The region's "soundtrack" is **41 `AudioStreamPlayer2D` nodes**, one per singer, positioned
at their seats.

```gdscript
# Silencing is destructive by design.
func silence_voice(singer_id: StringName) -> void:
    var node := choir.get_singer(singer_id)
    node.stream = null
    GameState.music.silenced_voices.append(singer_id)   # serialised; never removed
```

- The mix the player hears is a **spatial sum**, not a stereo bounce. Walking changes it.
- The 41st seat has a node with **no stream from the start.** It is in the scene. It is
  silent. It is the game's most-missed detail.
- **Players notice the thinner mix roughly 20 minutes after the boss**, in a different
  room, and the realisation is the design.

---

## 8.0.6 Middleware Decision

| Option | Verdict |
| --- | --- |
| **FMOD** | Preferred. Stem automation, parameter-driven mixing, beat-synced transitions, and profiling are all first-class. |
| **Godot `AudioStreamInteractive`** | Viable fallback. Handles beat-synced transitions and clip switching natively in 4.3+; stem-level automation must be hand-built on top of `AudioStreamPlayer` buses. |

**Decision gate: end of Production A (month 7).** The AudioDirector autoload is written
against an interface, not against FMOD, so the swap costs ~3 days either way. If the FMOD
licence or the Switch integration cost is unattractive at gate, we take the fallback and
lose nothing the design depends on.

---

## 8.0.7 Delivery Schedule

| Milestone | Deliverable |
| --- | --- |
| Month 3 (slice) | *Ninety Bells* complete with all 6 stems + *Audit* + *Catalogue* |
| Month 7 | All Act I + hub tracks; stem map locked for all 34 |
| Month 11 | All Act II tracks; the diegetic choir recorded (41 parts, one session) |
| Month 14 | All Act III + Finale |
| Month 15 | *Still Waiting* (9:40, one crescendo, no drop) — **written last, deliberately** |
| Month 16 | *A Tuesday in the Year Eleven* — one take, audible pedal, one wrong note left in |

**The 41-voice choir is a single session** with 41 singers, or 41 passes with fewer. Either
way it must be **41 distinct human beings' worth of variance**, because the mix's whole
effect is that each voice is *someone*.
