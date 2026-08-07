# SECONDHEART — Character Bible (Stage 4)

Expands GDD §04 and Story Bible §03/§13 into full production dossiers.

| # | Document |
| --- | --- |
| 00 | Index & Schema *(this file)* |
| 01 | [The Companions — Tilly, Moth, Barro, Sennet, Rue](01-companions.md) |
| 02 | [The Antagonists — Vellum, Annike, the Cantor, the Assayer, the First Ward](02-antagonists.md) |
| 03 | [Supporting Cast & the 46 NPCs](03-supporting-and-npcs.md) |
| 04 | [Relationship Matrix & Memory System](04-relationships-and-memory.md) |

---

## 4.0.1 The Dossier Schema

Every major character is specified against **twelve fields**, all of which are production
inputs, not colour:

| Field | Consumed by |
| --- | --- |
| **History** | Writers (Stage 7) |
| **Goals** | Scene construction — what they want *today* |
| **Fears** | Branch authoring — what they'll avoid saying |
| **Personality** | Writers, animators |
| **Dialogue style** | Stage 7 + loc; includes a *tell* |
| **Relationships** | Memory system, hearsay propagation |
| **Arc** | Scene ordering, epilogue modules |
| **Favourite things** | Gift/cooking systems, item lore, small talk |
| **Battle mechanic** | Combat (Stage 5) |
| **Theme music** | Audio (Stage 8) |
| **Special animations** | Art (Stage 9) |
| **Voice/babble profile** | Sound design |

---

## 4.0.2 Babble Profiles

No voice acting (GDD §15.6). Every speaking character has a **phonetic babble profile** —
the game's substitute for a voice, and a real characterisation tool.

```
BabbleProfile:
  base_pitch      semitones from A3
  pitch_variance  ± semitones per syllable
  rate            syllables/sec
  consonant_mix   0.0 (all vowel, soft) → 1.0 (all consonant, clipped)
  sustain         syllable length ms
  timbre          sample bank
```

| Character | Pitch | Rate | Cons. | Timbre | Reads as |
| --- | --- | --- | --- | --- | --- |
| Aven | +2 | 4.0 | 0.45 | wood | Neutral; **shifts with tone drift** |
| Osk | −4 | 5.2 | 0.60 | reed | Fast, delighted, slightly clattery |
| Tilly | +9 | 6.0 | 0.75 | small bell | Clipped, quick, certain |
| Moth | — | 4.0 | — | **blend of all others** | Recomposed per line from the quoted speaker's profile |
| Barro | −6 | 4.4 | 0.55 | brass | Warm, rolling, wide variance |
| Rue | −2 | 4.8 | 0.70 | low woodwind | Clipped, dry, almost no variance |
| Sennet | 0 | 3.2 | 0.30 | sung vowel | Everything is nearly a note |
| Vellum | +1 | 5.5 | 0.85 | typewriter-adjacent | Precise, percussive, **degrades across four fights** |
| Annike | −1 | 3.6 | 0.40 | felted | Unhurried. Never once speeds up. |
| Edda | −3 | 3.8 | 0.50 | paper | Dry, even |
| The Cantor | −7 | 2.8 | 0.20 | choral | Speaks in the plural, sounds like it |
| The Assayer | −11 | 4.0 | 0.65 | struck metal + paper | **Zero variance.** Metronomic. |
| The First Ward | — | 1.2 | 0.10 | single sustained cello | Barely speech |

**Moth's profile is the sound-design showpiece:** each Moth line is rendered using the
babble profile of whoever is being quoted, so the player *hears* the attribution before
reading it.

**The severed variant.** Every NPC who can be severed has a second profile: **rate +8%,
variance −40%, consonant_mix +0.1.** Faster, flatter, crisper. It is barely perceptible in
isolation and unmistakable back-to-back, and it is the single most effective piece of
characterisation in the audio budget.

---

## 4.0.3 Expression Sheets

| Character | Expressions | Notes |
| --- | --- | --- |
| Aven | 14 × 5 tone variants = **70** | GDD §12.6 |
| Tilly | 12 | Incl. *"stops fighting to look at you"* (combat tell) |
| Moth | 6 | Fewer, because it does not have reactions — it has *arrangements* |
| Barro | 14 | Incl. the seam: a single frame where the smile is held one beat past its use |
| Rue | 11 | Incl. one used exactly once, in S-325 |
| Sennet | 9 | |
| Vellum | 13 | Four sets, one per fight, progressively less composed |
| Annike | 8 | She has a small range and it is deliberate |
| Edda | 7 | **Eyes never track.** All expression is mouth and brow. |
| The Cantor | 5 | |
| Merit / Assayer | 9 | 4 for the machine (which cannot emote and *has* states), 5 for the person in the shell |
| The First Ward | 3 | Waiting · Listening · Opening |
| **NPCs (46)** | 4 each + severed variant | 230 total |

**Total portrait frames: ~600** (GDD §15.4).

---

## 4.0.4 Casting Rules

1. **No character is defined by their relationship to Aven.** Every one has a life that
   predates the player and continues without them. Writers must be able to answer
   *"what were they doing last Tuesday?"* for any named character.
2. **Nobody is a mentor.** Edda comes closest and refuses the role explicitly.
3. **Nobody explains the plot.** The Assayer states facts when asked; everyone else has
   partial, biased, or wrong information, including the sympathetic ones.
4. **Every character is funny at least once**, including the Assayer and the First Ward.
   Humourlessness is not gravitas.
5. **No character arc resolves cleanly.** Eleven of the twelve majors end the game with
   something unfinished. The exception is Osk, whose arc is finished in minute six.
