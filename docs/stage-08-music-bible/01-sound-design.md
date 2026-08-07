# 01 — Sound Design Bible

**~900 SFX.** The brief: *the player should be able to fight with their eyes closed and
lose gracefully.*

---

## 8.1.1 The Signature Sounds

These five carry the game. Everything else supports them.

### 1. The tether tone
A continuous, quiet harmonic whose **pitch rises with tether length**.

```
freq = 220 Hz * (1 + 0.6 * (len / L))
gain = -26 dB + 8 dB * (len / L)
```
Players stop *looking* at the tether after about two hours and start *hearing* it. **This
is the single best piece of sound design in the project** and it should be prototyped in
month 1 alongside the tether itself, because if it doesn't work the HUD design changes.

### 2. Strain
A rope-fibre creak layered under the tether tone, entering at 40 Strain, rising in density
(not volume) to 100. It is *information*, not decoration — a player should be able to
hold TAUT with their eyes on the enemy.

### 3. SNAP
A composite of rope failure and a single heartbeat, mixed **4 dB above everything**, with
a 24-frame total music cut behind it. **Designed to be hated.** Playtest confirms players
change their behaviour to avoid hearing it, which is the entire purpose.

### 4. SWAP
**A soft inhale.** Not a whoosh, not a dash, not a teleport zap. The dodge sounds like a
breath because the game is about breathing, and because 6 frames of i-frames need a sound
that says *you held on*, not *you escaped*.

### 5. Severance (world)
**A silence, not a sound.** 0.6 seconds (36 frames) of *total* audio duck — SFX, music,
ambience, room tone, everything.

Used **exactly 19 times** in the game. The list is fixed and no additional use may be
added without Creative Director sign-off, because its power is entirely scarcity.

---

## 8.1.2 The Positioned-Audio Contract

**Every bullet spawn has a positioned sound.** Panned and pitched by distance and angle
from Self.

| Bullet type | Timbre | Pitch range |
| --- | --- | --- |
| Pellet | Short wooden tick | ±5 st by distance |
| Bolt | Sharp metallic zip | ±7 st |
| Beam | Sustained charge → release | fixed |
| Curl | Bowed swell | ±4 st |
| Weight | Low sub thud + air displacement | fixed |
| Special | Per-boss | — |

**Enemy family spawn timbres are distinct**, so a player can identify what is firing
without looking. This makes the Ringer fight (audio-only, dark arena) fully playable, and
makes every other fight *partially* playable by ear, which is the stated accessibility goal.

**Visual sound cues** (accessibility) render these as directional on-screen indicators —
the same information, the other way round.

---

## 8.1.3 Region Sound Palettes

Each region's percussion and ambience are built from **objects that exist in that region**
(GDD §11.1). This is why the score sounds like a place.

| Region | Percussion source | Ambience bed |
| --- | --- | --- |
| The Unclaimed | Drawer slides, card riffle | Tape hiss, distant HVAC-that-isn't |
| Wyndmarrow | Bell-metal, rope, peat | Wind, distant bells, livestock, children |
| Grieving Wood | Wood knock, leaf, spade | Canopy wind in waves, birds that stop when you approach |
| Hushfell | Kettle, cup, snow compression | **Near-silence.** Room tone and breath. |
| Salt Ledger | Salt pour, paper crush | Heat drone, wind with grit |
| Verrick | Loom shuttle, steam valve, chain | Machine floor, 60 Hz hum, distant shouting |
| Drowned Choir | Water, stone, held breath | Submerged pressure, 41 voices |
| Lamplight March | Coupling strain, wheel, lamp | Wheels, whatever biome is outside |
| The Orrery | Gear tick, brass ring | **Nothing.** True silence between sounds. |
| Commonplace | Page turn, spine crack, ladder | Paper-fall, distant readers |
| Ash Garden | Ash shaker, dry stem | Wind with no trees in it |
| The Assay | Typewriter, paper fall, stamp | Filing. Endless, orderly filing. |

**The Orrery's silence** is the most expensive sound design decision in the game: after
seven regions of dense ambience, a region with genuine gaps of nothing is physically
uncomfortable, and it is the point.

---

## 8.1.4 Babble Voices

No voice acting. Every speaking character has a phonetic babble profile (Stage 4 §4.0.2).

**Implementation:** a small syllable bank per timbre (12–20 samples), sequenced per
character glyph at the character's `rate`, pitched by `base_pitch ± variance`, gated by
`consonant_mix`.

**The severed variant** — rate +8%, variance −40%, consonant_mix +0.1 — is applied at
runtime to any speaker whose `severance_state == severed`. It is barely perceptible in
isolation and unmistakable back-to-back.

**Moth** renders each line using the babble profile of the **quoted** speaker, so
attribution is heard before it is read. This requires the dialogue compiler's quote
manifest (Stage 7 §7.0.2) and is the tightest audio/narrative coupling in the project.

---

## 8.1.5 Mix Architecture

| Bus | Contents | Player control |
| --- | --- | --- |
| Music | All stems | 0–100 |
| SFX | Combat, world, interaction | 0–100 |
| Ambience | Room tone, weather, crowd | 0–100 |
| UI | Menus (all paper sounds) | 0–100 |
| Babble | Character voices | 0–100 |
| **Master** | — | 0–100, + mono downmix |

**Ducking rules:**
- Dialogue → Music −6 dB, Ambience −3 dB
- SNAP → Music −∞ for 24 frames
- Severance → **everything** −∞ for 36 frames
- Boss rage phase → Ambience −12 dB (the world recedes)

**Headroom:** master peaks at −3 dBFS. No limiting on the music bus; the score's dynamic
range is part of the design and compressing it for loudness would flatten *A Kind Room*
into wallpaper.

---

## 8.1.6 Footsteps & Surfaces

**14 surface types × 3 gaits (creep / walk / run) × 4 variants = 168 samples.**

Surfaces: stone, wood, rope-bridge, peat, snow *(depth-variable)*, salt, metal grating,
factory floor, water-shallow, water-submerged, ash, paper, carpet, grass.

**Snow is depth-variable** — the sample set changes with accumulated depth, and footprints
persist and fill in over ~90 seconds. It is the only surface with state.

---

## 8.1.7 UI Sound

**Everything is paper.** Menu open is a page turn. Confirm is a stamp. Cancel is a page
returned to a stack. Error is a form rejected. Save is a drawer closing.

This is not a gimmick — it means the UI's sound is *diegetic to a world run by a Registry*,
and it means that in the Assay, where the environment is made of falling forms, the menus
and the world sound identical. Players who notice this report it as unsettling. It is meant
to be.

---

## 8.1.8 Blind-Playability Target

**Stated goal, not a guarantee.** We are aiming for:

| Content | Target |
| --- | --- |
| The Ringer (WYN mini-boss) | **Fully playable deaf and blind.** Audio-only telegraphs, dark arena. |
| All normal encounters | Survivable by ear at Steady difficulty |
| Major bosses | Partially — phase transitions and specials are audio-distinct |
| The First Ward | Not a target. It is a 7-phase superboss and we are honest about that. |

**Verification:** playtest rounds 4 and 6 include at least two testers who use audio cues
as a daily necessity, not as a test. Their findings are P1, not feedback.
