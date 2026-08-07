# SECONDHEART — Game Design Document

**Version 1.0 — Stage 1 Deliverable**
**Studio:** Creative Direction / Lead Design / Narrative / Gameplay Eng. / Combat / Pixel Art / Music / Sound / UX / QA

---

## The Game in One Paragraph

In Vesselmere, when you love a person enough to carry them, a **second heart** grows
beside your own. It is called a **Ward**. For nine hundred years an ancient civic
machine called **the Assayer** has quietly severed Wards to spare people from grief —
and this winter it stopped being quiet. The severed do not forget. They remember the
name, the face, the exact sound of a laugh. They simply cannot find where they kept
the love. You are **Aven**, who wakes in a vault of unclaimed hearts with two hearts
beating and no idea whose the second one is. Across fourteen regions you gather
companions who each occupy that second heart — and each one changes how you move,
fight, and survive. The people you carry are, mechanically and literally, the reason
you are still alive.

---

## How to Read This Document

This GDD is the **master spec**. It is complete across every system — enough that a
professional indie team could break ground tomorrow — with the understanding that
Stages 2–10 explode individual sections into full production bibles (every line of
dialogue, every enemy stat block, every bar of music, every sprite sheet).

**Reading paths:**

| If you are… | Read, in order |
| --- | --- |
| **Publisher / Exec** | 01, 02, 10, 15, 17 |
| **Designer** | 01, 05, 06, 08, 09, 07 |
| **Programmer** | 05, 06, 14, 13 |
| **Narrative** | 02, 03, 04, 06, 10 |
| **Artist** | 12, 03, 13, 08 |
| **Audio** | 11, 02, 08 |
| **QA** | 06, 10, 15, 17 |
| **Everyone** | 01 |

---

## Glossary — Core Terms

These are load-bearing. They appear in code, UI, and dialogue with identical meaning.

| Term | Meaning |
| --- | --- |
| **Ward** | The second heart. Grows when a bond crosses the *carrying threshold*. |
| **Warded / Pairbound** | A person who has one. Socially: an adult, a full citizen. |
| **Severance** | The cutting of a Ward. Memory survives; *significance* does not. |
| **The Quiet** | A mass-severance event. The current one is the **Ninth Quiet**. |
| **The Assayer** | The machine that performs severance. Believes it is being merciful. |
| **Merit Vane** | The Assayer's name when it was a person. Nine hundred years dead. Sort of. |
| **The Keeping** | The vault where severed Wards are *stored*, not destroyed. Secret area. |
| **Tether** | The elastic line between Self and Ward in combat. The core mechanic. |
| **Self** | The player-controlled glyph. Fragile. Fast. |
| **Ward (combat)** | The companion glyph on the far end of the tether. Behaviour varies by companion. |
| **INSIGHT** | Resource earned by sweeping the tether through hostile fire. Spent on UNKNOT. |
| **STRAIN** | Penalty for over-farming INSIGHT or over-stretching the tether. |
| **UNKNOT** | The non-violent resolution verb. Requires correct diagnosis, not repetition. |
| **SEVER** | The attack verb. Deliberately the same word the Assayer uses. |
| **The Eight** | Compassion, Trust, Curiosity, Fear, Hope, Resolve, Mercy, Wrath. Hidden values. |
| **Reading** | How an NPC perceives you — derived from the Eight, filtered by that NPC's bias. |
| **The Long Quiet** | The final, permanent severance the Assayer is building toward. |

---

## Design Pillars — the four sentences everything answers to

1. **The people you carry are the reason you survive.** Companionship is not a
   cutscene; it is a movement verb. Every design decision must make the player feel
   the difference between two hearts and one.
2. **Peace is harder than violence, and worth it.** The pacifist route demands more
   mechanical skill, more attention, and more reading comprehension than the violent
   route. Never the reverse.
3. **Grief is not a villain.** The antagonist is a mercy that went too far. No
   character in this game is evil. The player must at least once think *"they might
   be right."*
4. **Every choice leaves a scar you can walk past.** Consequence is *environmental*
   and *permanent* before it is textual. You should be able to tell what a player did
   by walking through their world.

---

## Non-Negotiables (QA gate — a build ships only if all are true)

- 60 FPS locked during all bullet-hell phases on a 2017-class integrated GPU.
- Input-to-response latency ≤ 2 frames for SWAP, the game's most timing-critical verb.
- No line of dialogue exists purely to fill space. Every line advances character, lore,
  or a future event. QA maintains a **"cut this line" audit** per region.
- No choice, anywhere, produces zero downstream state change.
- Every death is legible: the player must be able to name the mistake that killed them.
- Full keyboard remapping, full controller support, and a no-dodge accessibility path
  that preserves *all* story and *all* endings.
