# SECONDHEART — Dialogue Database (Stage 7)

**96,000 words is the largest deliverable in the project and the critical path (Risk R2).**
This stage specifies the *format, tooling, and standards* so writing is never blocked on
engineering, plus authored reference scenes at production standard.

| # | Document |
| --- | --- |
| 00 | Format & Compiler *(this file)* |
| 01 | [Reference Scenes — production standard](01-reference-scenes.md) |
| 02 | [Barks, Interjections & Systemic Lines](02-barks-and-systemic.md) |

---

## 7.0.1 The `.sh` Format *(SecondHeart dialogue)*

Plain text, diffable, writable without the editor open, compiled to `DialogueResource`.

```
@node halden_act3_returned
  @require flag:wife_returned
  @require reading:halden >= warm
  @once

  HALDEN [tired] "You're the one who did it."
  HALDEN "I've been trying to work out how to thank someone for a thing I —"
  [INTERRUPT] AVEN [careful] "You don't have to."
  HALDEN "No. I do. That's the whole — that's what came back."

  @write halden.memory += thanked_aven
  @write eight.compassion += 1

  @choice
    -> WARM   "Is she home?"          @goto halden_wife_home
    -> QUIET  "..."                   @goto halden_silence   @eight compassion+2
    -> BLUNT  "Was it worth it?"      @goto halden_worth     @eight resolve+2 trust-1
    -> [if flag:objects_discarded] CAREFUL "There were things I threw away."
                                      @goto halden_objects
```

### Directives

| Directive | Meaning |
| --- | --- |
| `@node <id>` | Addressable unit |
| `@require <cond>` | Gate. Multiple = AND. |
| `@once` | Fires once per save |
| `@write <path> <op>` | State mutation |
| `@goto` / `@end` | Flow |
| `@choice` | Player options; each tagged with a tone |
| `[INTERRUPT]` | Barges in; previous line renders truncated with a visible cut |
| `[BEAT]` | A held pause with no text — **counts as a line for the text audit** |
| `@quote <speaker>` | Moth only: renders in *Hand* font, small-caps attribution, **and uses that speaker's babble profile** |
| `@severed` | Marks a node as only valid for a severed speaker; compiler enforces the severed writing rule |

### Conditions
`flag:x` · `eight.wrath >= 50` · `reading:npc >= warm` · `companion == tilly` ·
`region_first_visited == chr` · `bell_count < 65` · `voices_silenced == 0` ·
`route == carry` · `act >= 3` · `topic_asked:x`

---

## 7.0.2 The Compiler

`tools/dialogue_compiler/` — a Godot editor plugin plus a headless CLI for CI.

**Outputs:**
1. `DialogueResource` `.tres` per region.
2. A **coverage report** that fails CI on:
   - Unreachable nodes.
   - **Orphan flags** — written but read <3 times across <2 acts (GDD §06.6.2).
   - Choices with no downstream read.
   - Any NPC with <3 conversation stages.
   - Any line appearing in >1 place (accidental duplication).
   - Any line under 3 words without a `[BEAT]` tag.
   - **`@severed` nodes containing a preference, longing, or regret** — a keyword-list
     check plus a manual review flag. This rule is the most-violated in drafts.
3. A **localisation manifest** linking every Moth line to its source line, so translators
   render Moth as a quotation of *that language's* version of the original (GDD §15.7).
4. A **tone histogram** per character, to catch a writer drifting a character's register.

---

## 7.0.3 Pronoun & Name Handling

Aven's name is player-set and pronouns are player-set (they/she/he). Every line must work
in all three **without rewriting** — a hard constraint on the writing, not a runtime
substitution hack.

```
{AVEN}        → player name
{THEY} {THEM} {THEIR} {THEIRS} {THEMSELF}   → capitalised variants auto-derived
{IS} {WAS} {HAS} {DOES}                     → verb agreement
```

**Writing rule:** prefer constructions that avoid the problem. *"You're the one who did
it"* beats *"{THEY} {IS} the one who did it."* The compiler warns when a line uses more
than two pronoun tokens, because that line is usually badly written.

---

## 7.0.4 Word Budget & Ownership

| Category | Words | Owner |
| --- | --- | --- |
| Main story | 24,000 | Narrative Director |
| Companion conversations + 30 cooking scenes | 11,000 | Narrative Director |
| Side quests (35) | 14,000 | Writer 2 |
| NPC ambient (46 × 3+ stages) | 9,000 | Writer 2 |
| Boss dialogue (17 × phases × routes) | 7,000 | Narrative Director |
| Enemy lines + 168 resolution scenes | 4,500 | Writer 3 |
| Item lore (118 + 84 Keepsakes) | 5,500 | Writer 3 |
| Journal / Register / strata / choir parts | 6,000 | Writer 3 |
| Epilogue modules | 8,000 | Narrative Director |
| NG+ overlays | 4,000 | Writer 2 |
| UI / system / accessibility / reference | 3,000 | UX |
| **Total** | **96,000** | |

**Single-author blocks** — content where register consistency matters more than throughput,
written by one person in one pass:
- The 70 Prologue drawers
- The 300 Register of Willing entries
- The 200 complaints
- The 84 Keepsakes
- The 41 choir parts

---

## 7.0.5 The Cut-This-Line Audit

GDD §00 requires that no line exist purely to fill space. QA maintains a per-region audit:

For every line, a reviewer answers: **does this build character, lore, or a future event?**
A line answering *none* is cut. A line answering *only one* needs a defence.

**Target: ≥70% of lines answer two or more.** Measured per region, reported at milestone.

---

## 7.0.6 Interrupt Rendering

`[INTERRUPT]` is character, not pacing. When it fires:
1. The interrupted line renders **truncated at the em-dash**, held for 8 frames.
2. The interrupting line appears **before** the previous box clears — briefly overlapping.
3. The interrupted speaker's portrait holds its expression for 12 frames after.

**Budget:** ~240 interrupts. Tilly accounts for 61 of them.

---

## 7.0.7 Dialogue History & Export

Full session scrollback, searchable, **exportable to a text file** (GDD §13.5). This is a
deliberate gift to the community — people will quote this game, and making it easy is
cheaper than watching them retype screenshots.

The export includes speaker, expression tag, and the player's chosen tone, so an exported
transcript records *how* the player played, not just what was said.
