# 06 — Morality, Choice & Consequence

---

## 6.1 Why There Is No Good/Evil Meter

A single axis teaches the player to optimise. The moment a player can see "I am at 70%
Good," the game has become a slider and every choice becomes arithmetic.

SECONDHEART tracks **eight independent hidden values**, never shown as numbers, never
shown as a bar, and — critically — **no value is good.** High Compassion has costs. High
Resolve has costs. High Mercy gets people killed. There is no configuration of the Eight
that the game endorses.

---

## 6.2 The Eight

Each is `0–100`, starting at `20`, with a natural decay of `-1 per act` toward 20 for
any value not reinforced.

| Value | Raised by | Lowered by | What it unlocks | **What it costs** |
| --- | --- | --- | --- | --- |
| **Compassion** | Helping at personal cost, WARM tone, feeding people, non-lethal quest solutions | Ignoring pleas, taking payment for help | Companion trust events, 6 quests, the RETURN ending | NPCs bring you their problems. Some are traps. High Compassion makes you *exploitable*, and three quests punish it. |
| **Trust** | Believing NPCs without evidence, sharing information, keeping promises | Lying, catching NPCs in lies and saying so, CAREFUL tone spam | NPCs volunteer secrets; Rue's confession comes early | You believe Rue. You believe her right up until Act III. Low-Trust players catch her in Act II. |
| **Curiosity** | Reading everything, exploring optional rooms, asking follow-ups, cross-referencing the Journal | Skipping, refusing offered lore | The entire superboss chain; 40% of optional lore; the Hidden Ending | Curiosity opens doors that should stay shut. Two NPCs die because you asked. |
| **Fear** | Fleeing fights, GUARD spam, using Steady mode's retreat, avoiding the dark | Facing bosses without healing, entering optional areas | *Nothing.* Fear unlocks no content. It **changes** content — enemies telegraph longer, NPCs speak more gently, and two bosses are genuinely easier | High Fear closes the Hidden Ending and the superboss. The game never says so. |
| **Hope** | Believing severance is reversible, arguing with Annike, planting in the Grieving Wood, keeping the Bell Count | Endorsing severance, agreeing that it's kinder | The RETURN and OPEN endings; the March gains cars | Hope is *naïve*. Three quests fail because you hoped. One person dies. |
| **Resolve** | Finishing what you start, refusing to walk away, hard confrontations, BLUNT tone | Abandoning quests, retreating from Annike, deferring decisions | ASSUME ending; the superboss's second phase requires it | High Resolve makes Aven exhausting. Tilly, at Resolve>75, tells Aven they've become "like a bell that won't stop." |
| **Mercy** | UNKNOT resolutions, sparing bosses, non-lethal quest paths | SEVER kills, killing a named enemy, Annike's death | True ending path; Vellum's defection; every companion's best scene | Mercy has *consequences the game shows you*: two Unknotted enemies reappear in Act III having hurt someone. The game does not comment. |
| **Wrath** | SEVER kills, aggressive dialogue, destroying property, killing after a plea | Time (decays fastest), UNKNOTs | The SEVER ending; unique weapon tier; three bosses fear you and fight worse | Shops close. Companions leave. Two regions become hostile. The music loses instruments permanently. |

**These are not exclusive.** A player can be high Mercy *and* high Wrath — someone who
spares most things and kills specific things. The game has authored content for that
profile, and it is one of the most interesting reads in the game.

---

## 6.3 Readings — how NPCs perceive you

NPCs do not see the Eight. They compute a **Reading**: a weighted, biased impression.

```gdscript
func read_player(npc: NPCProfile, eight: Dictionary) -> String:
    var score := 0.0
    for k in npc.reading_bias:                      # e.g. {"wrath": 1.8, "mercy": -0.4}
        score += eight[k] * npc.reading_bias[k]
    score += npc.memory_weight(recent_flags)        # what they personally saw
    score += npc.hearsay_weight(region_rumour)      # what the region says about you
    return npc.reading_table.bucket(score)          # → "wary" / "warm" / "afraid" / ...
```

Three consequences that make this feel alive:

1. **Different NPCs read you differently at the same moment.** Guisley the bell-founder
   weights Resolve heavily and thinks a high-Wrath Aven is *impressive*. Tilly weights
   Mercy and is frightened of the same Aven, in the same room, in the same scene.
2. **Hearsay propagates by region and by travel time.** Kill someone in Verrick and the
   Salt Ledger doesn't know yet. The March, which moves, knows *first*. This is a real
   simulation, and players who exploit it (do the bad thing last) are being smart, not
   cheating.
3. **Memory beats statistics.** An NPC who personally saw you do one merciful thing
   weights it above a hundred hidden points. This is how the game avoids feeling like a
   spreadsheet: relationships are anecdotal.

---

## 6.4 The Choice Ledger — what permanently changes

**Design law: nothing in this game is cosmetic.** Every entry below is a real state
change with authored downstream content.

| Domain | How choices change it | Example |
| --- | --- | --- |
| **Dialogue** | Tone drift, Readings, memory flags, dead/severed speakers | Halden greets you 6 different ways depending on whether his wife was returned |
| **Towns** | Population, lighting, ambient audio, building states, time-of-day skybox | Wyndmarrow's golden hour becomes overcast permanently below Bell Count 78 |
| **Bosses** | Phase counts, pattern sets, dialogue, whether the fight happens at all | The Cantor skips phase 2 entirely if you Unknotted Sennet |
| **Companions** | Presence, tether verbs, ATTUNE availability, whether they speak to you | Moth can be permanently unwoven in Act II; you play 3 hours without GHOST |
| **Music** | Stems added/removed permanently per save (§11.6) | Every severed Wyndmarrow villager removes an instrument from *Ninety Bells* |
| **Quests** | 9 of 35 are failable; 6 mutually exclude others | Saving Ossa closes *Brother Fen Changes His Mind* |
| **Shops** | Inventory, prices, whether they open at all, whether they'll serve you | Pell stops stocking luxuries when she loses hope; a Wrath>60 Aven is refused service in three shops |
| **World map** | Regions added, sealed, or destroyed; the March gains/loses cars | The Ash Garden is inaccessible on the SEVER route; the Undersleep only exists if the twelfth car is opened |
| **Endings** | 5 endings + 14 epilogue variants | §10 |
| **NPC deaths** | 11 NPCs can die; 9 more can be severed | Each has an authored absence — an empty chair, a still-set table, an unrung bell |
| **Future encounters** | Enemies remember being spared or misdiagnosed | A misdiagnosed Understory returns in Act III, larger, with the diagnosis you got wrong written into its patterns |

---

## 6.5 The Three Hardest Choices

Designed so that no forum consensus can form. QA target: no option below 25% or above
45% of player selection.

### Choice A — *Hushfell's Rite* (Act I)
Shut down Annike's severance rite, endorse it, or leave without deciding.
- **Shut down:** 300 people who chose this are denied it. Candidate Ossa, who has been
  waiting three days to stop feeling her son's death, is still feeling it in Act III.
  She thanks you. She is not okay. Hope +, Resolve +, Compassion −.
- **Endorse:** Ossa is at peace. She does not know who you are when you return. Annike
  gains a new register page. The Hushfell theme gains a warm final chord — the only
  region theme that resolves. Mercy +, Hope −.
- **Walk away:** the rite continues, but Annike now knows someone was watching, and her
  Act III scene is the best writing in the game. Curiosity −, and the game quietly
  respects you.

### Choice B — *Barro Asks Dov* (Act II)
Barro's illegal hand-woven Ward is finished. Does he ask his severed husband if he
wants it?
- **Ask:** Dov says **no**, politely and kindly, because a severed person has no reason
  to want it. Barro burns three years of work in front of you. He is fine. He is not
  fine. This is the game's most-cited scene in playtests.
- **Don't ask, install it anyway:** it works. Dov comes back. Dov is *furious* — not
  about the crime, about the consent. Their marriage may not survive it. Wrath +, Hope +.
- **Turn Barro in:** unlocked only at Trust <30. Barro is executed. His floor keeps
  running. Idrisse never speaks to you again but does not stop you from working there,
  which is worse.

### Choice C — *Rue's Petition* (Act III)
You have the form. Rue is dying. Her crew doesn't know.
- **Tell the crew:** they mourn her *while she is alive*, which is the whole thing she
  filed the form to prevent. It is agonising and it is right. Unlocks her best epilogue.
- **Burn the form:** protects her, sustains the lie, and the Assayer's directive stands.
  Trust +, Hope −, and the Ninth Quiet continues on schedule.
- **Give the form to the Assayer as evidence:** legally rescinds the directive; the
  Ninth Quiet halts; **Rue is severed as the petitioner's remedy** and forgets her crew.
  She keeps captaining. She is very good at it. Nobody on board can look at her.

---

## 6.6 Anti-Patterns — explicitly forbidden

The following are banned at design review:

1. **"This choice changes nothing."** If a choice cannot be given a downstream
   consequence, it is deleted, not shipped as flavour.
2. **Choice-flags with a single check.** Every major flag must be read in **≥3 places
   across ≥2 acts.** QA runs a static analysis pass on flag reads and fails the build
   on orphans.
3. **Telegraphed morality.** No "⚠ This will have consequences" prompt. No music sting.
   No companion turning to look at you. The game does not tell you when it's watching,
   because it is always watching.
4. **Undo.** No confirm dialog on moral choices. Manual save exists; the game does not
   protect you from yourself.
5. **Optimal routes.** Every route must have at least one thing only it gets. QA
   maintains a **"route exclusivity ledger"** to prove it.

---

## 6.7 Route Architecture

There is no "pacifist run" flag. Routes are **emergent from the Eight**, resolved at
three checkpoint moments (end of Act I, end of Act II, entry to the Finale).

```
                     ┌── high Mercy, low Wrath, Hope ≥ 55 ──► CARRY route
                     │      (Act III: Orrery → Commonplace → Ash Garden)
   ACT II CHECKPOINT ┼── high Wrath, any Mercy ─────────────► LEDGER route
                     │      (Act III: Orrery → The Rendering → Ash Garden)
                     └── mixed / low both ──────────────────► DRIFT route
                            (Act III: Commonplace → Undersleep → Orrery)
```

**Act III is a different set of regions per route**, not the same regions with different
text. This is the primary replay driver and the largest single content cost in the
project (§15, §17) — and it is non-negotiable, because it is the difference between
"three endings" and "three games."
