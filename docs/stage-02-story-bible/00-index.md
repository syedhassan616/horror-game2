# SECONDHEART — Story Bible

**Version 1.0 — Stage 2 Deliverable**
**Authority:** Narrative Director. Subordinate to the Stage 1 GDD; may add, may not contradict.

---

## What This Document Is

The Stage 1 GDD fixed *what happens*. This bible fixes **why it happens, in what order,
to whom, and what it means** — scene by scene, branch by branch, with the canon rules
that make the world hold together under scrutiny.

It is written to be read by everyone, but it exists primarily so that:

- **Writers** (Stage 7) know every scene's purpose, cast, preconditions, and exit state.
- **Designers** know which scenes are load-bearing and must not be cut or reordered.
- **QA** can verify that every plant has a payoff on every route.
- **Loc** can see, in advance, which jokes and which griefs are language-dependent.

---

## Contents

| # | Document | For |
| --- | --- | --- |
| 01 | [Cosmology & the Rules of the World](01-cosmology-and-rules.md) | Everyone. Hard canon. |
| 02 | [History & the Nine Quiets](02-history-and-the-nine-quiets.md) | Writers, lore |
| 03 | [Aven & the Voice System](03-aven-and-the-voice-system.md) | Writers, UX |
| 04 | [Prologue — The Unclaimed](04-prologue.md) | All |
| 05 | [Act I — The Ringing](05-act-one.md) | All |
| 06 | [Act II — The Ledger](06-act-two.md) | All |
| 07 | [Act III — Three Routes](07-act-three.md) | All |
| 08 | [Finale — The Assay](08-finale.md) | All |
| 09 | [Epilogues — All Five Endings](09-epilogues.md) | All |
| 10 | [The Three Petitions](10-the-three-petitions.md) | The twist architecture |
| 11 | [Foreshadowing & Payoff Ledger](11-foreshadowing-and-payoffs.md) | QA, writers |
| 12 | [Themes & the Arguments](12-themes-and-arguments.md) | Writers |
| 13 | [Continuity Bible](13-continuity-bible.md) | Everyone. The rules. |

---

## Scene Notation

Every scene in Documents 04–09 uses this format:

```
S-102  THE ELEVENTH BELL                          [MANDATORY]
Location   Wyndmarrow — bell tower base
Cast       Aven, Tilly Brack
Requires   S-101 complete
Purpose    Establish the Bell Count; recruit Tilly; plant F03
Beats      1. ...
           2. ...
Exit       flag:tilly_met · Bell Count visible in HUD · Tilly joins as companion
Branches   —
```

- **[MANDATORY]** — cannot be missed on any route.
- **[OPTIONAL]** — findable, skippable, and its absence is authored (something is
  missing later, and the game does not point at it).
- **[ROUTE: X]** — exclusive to CARRY / LEDGER / DRIFT.
- **[FAILABLE]** — the scene can resolve into a worse state permanently.

**Scene budget:** 214 authored scenes. 118 mandatory, 71 optional, 25 route-exclusive.

---

## The Story in Five Sentences

1. Aven wakes in a vault of unclaimed hearts carrying a second heart nobody can account
   for, and watches a kind man be emptied out mid-sentence.
2. Following the paperwork, Aven learns that the machine severing the world's bonds is
   not malfunctioning — it is obeying three perfectly reasonable requests filed by three
   people who each loved somebody.
3. Everything the machine has ever taken is still intact, in a vault, and could be
   given back — along with all the grief that came with it.
4. The heart Aven has been carrying belongs to the machine, which was a person, who
   severed themselves first and hid their capacity to love where no one would look.
5. Aven decides what to do with it, and the world becomes whichever thing that was.

---

## The One Rule That Governs All Writing Here

> **Nobody in this story is doing the wrong thing for the wrong reason.**

Every antagonist, every betrayal, every atrocity in SECONDHEART traces back to a person
trying to spare somebody pain. If a scene requires a character to be cruel, careless, or
stupid to work, **the scene is wrong** and gets rewritten, not the character.

The single exception is bureaucratic momentum, which is not a person and is the actual
villain of the piece.
