# 03 — Aven & the Voice System

---

## 3.1 Who Aven Is

**Default name:** AVEN. Player-renameable, 12 characters, no filtering beyond profanity.

**Age:** early twenties, deliberately unspecified. **Pronouns:** they/them by default;
the player may set she/her or he/him at naming, and every line is authored to work in
all three without rewriting (a hard constraint on the dialogue compiler, §14).

**What the player knows at hour zero:** nothing.
**What the player knows at hour one:** Aven has two hearts and no idea whose the second
one is, and no Bearing, and a requisition slip.

### Aven is not a blank

The single most important writing rule for this character:

> **Aven has opinions, humour, and a temper. The player chooses which of those is
> loudest — not whether Aven has them.**

Aven is never silent, never speaks only in "...", and never functions as a mirror for
whoever they're talking to. Every scene has at minimum one Aven line that exists whether
or not the player chooses anything.

**Aven's baseline temperament** (before any player drift): watchful, dry, slow to speak,
quick to help, allergic to being thanked, and — because of §1.6 — **structurally lonely
in a way Aven has no vocabulary for**, because Aven has never had a Bearing and doesn't
know what everyone else is talking about when they describe it.

### The joke Aven doesn't get

Every Warded person in Vesselmere describes the Bearing the way people describe a colour.
Aven has never felt it. Through the whole game, NPCs say things like *"you know, like when
you can feel where they are"* and Aven says *"sure"* and the player watches Aven lie
about it eleven times before anyone notices. **Tilly notices first**, in Act II, and says
so out loud in the bluntest possible way, and it is the first time Aven's condition is
named by another person.

---

## 3.2 The Voice System

Dialogue choices are tagged by **tone**, not content. The same information gets conveyed
either way; what changes is how Aven is in the room.

| Tone | Register | What it says about Aven | Feeds |
| --- | --- | --- | --- |
| **WARM** | Open, generous, occasionally over-promises | Leads with care; assumes good faith | Compassion, Trust |
| **WRY** | Deflective humour, undercuts tension | Uses jokes as a load-bearing wall (see: Barro) | Curiosity, Trust |
| **BLUNT** | Says the true thing immediately | No cushioning; sometimes cruel by accident | Resolve, Wrath |
| **CAREFUL** | Hedged, precise, asks before assuming | Protects people from being cornered | Compassion, Fear |
| **QUIET** | Says less than the moment wants | Withholding; can read as depth or as absence | Curiosity, Fear |

### How drift works

```
tone_counts[t] += 1                          # per choice made
dominant   = argmax(tone_counts)
secondary  = second(tone_counts)
drift_pct  = tone_counts[dominant] / total
```

`drift_pct` gates cosmetic and dialogue changes at **35%**, **50%**, and **65%**.

| Drift | What changes |
| --- | --- |
| 35% | Portrait neutral expression shifts. Idle animation changes. |
| 50% | Walk cycle changes. Aven's *unchosen* baseline lines rewrite to the dominant register. NPC greeting variants unlock. |
| 65% | Companions comment on it, in character, once each. Two NPCs change their `reading_bias`. Aven's death-line responses change. |

**Nothing is locked by tone.** No ending, quest, or item requires a register. The Voice
System is characterisation with teeth, not a stat gate — the *Eight* are the gate, and
tone only nudges them.

### What each companion says at 65% drift

Authored once each, delivered without ceremony, never repeated:

- **Tilly / BLUNT:** *"You've got like a bell that won't stop. I'm not saying stop. I'm
  saying I can hear you from the other end of the village."*
- **Tilly / QUIET:** *"You do the thing where you don't say it and then it's my job to
  guess. I'm eleven."*
- **Moth / WARM:** *(in Osk's voice)* *"— you're very kind, and I'd like you to know I've
  noticed, because people don't —"* *(in its own, for one word)* *"...yes."*
- **Barro / WRY:** *"You're funny. You're funny the way I'm funny. Do you want to know
  what that is? That's a man holding a door shut with his shoulder."*
- **Rue / CAREFUL:** *"You keep asking permission to say things. I'm going to give you
  a standing yes and you're going to hate it."*
- **Sennet / BLUNT:** *"Good. Everyone here sings around things. Keep doing that."*

---

## 3.3 Aven's Arc

Four movements. Each is marked by a change in what Aven is *called* by the world.

### Movement I — **Inventory** (Prologue)
Aven is a filing error. Osk catalogues them, kindly, as an object. Aven's first line in
the game is an interruption of their own catalogue entry.
- **Wants:** out of the drawer.
- **Believes:** somebody will explain this.
- **Called:** *"the unclaimed."*

### Movement II — **Courier** (Act I)
Aven carries a requisition slip to a Registry that no longer processes them. Aven is
useful, transient, and asked for nothing. The first companion seats, and Aven discovers
that being carried by someone is a thing that can be done *to* them, and does not know
how to feel about it.
- **Wants:** to deliver the slip and be told what they are.
- **Believes:** there is a person responsible, and finding them fixes it.
- **Called:** *"the one with the paperwork."*

### Movement III — **Carrier** (Act II)
The middle of the game and the middle of Aven. Companions seat and unseat. Residue
accumulates. Aven starts finishing other people's sentences using other people's words —
and the player, who has been choosing tones for four hours, watches Aven become
*composite*.
- **Wants:** the vault. Everything back.
- **Believes:** it can be undone.
- **Called:** by name, for the first time, by four different people in four regions.
- **The turn:** the Slack Tether. Somebody is taken out of Aven mid-fight, and Aven
  learns what everyone else has been describing this whole time — the Bearing, going
  dark — except Aven never had one, so what Aven feels is a **absence of an absence**,
  and there is no word for it, and Aven tries to explain it twice and fails both times.

### Movement IV — **The One Who Decides** (Act III → Finale)
Aven discovers the heart they carry is Merit's, which means Aven has been the machine's
countermand mechanism since page one — not chosen, **filed**. Aven's final movement is
the refusal to be a mechanism.
- **Wants:** — *this is the point. The game stops telling the player what Aven wants and
  starts asking.*
- **Called:** nothing. In the Finale nobody says Aven's name at all, and the absence is
  deliberate and unremarked.

**The last line of the arc** is the Finale's decision itself, which is the only Aven line
in the entire game **with no tone tag** (GDD §02.2). Whatever the player picks, Aven says
it plainly, as themselves.

---

## 3.4 Portraits & Expressions

14 expressions × 5 tone variants = **70 portrait states** (GDD §12.6).

| # | Expression | Notes |
| --- | --- | --- |
| 1 | Neutral | The one that drifts most visibly |
| 2 | Listening | Used more than any other; the character is a listener |
| 3 | Amused | WRY variant is a smirk; WARM variant is an open laugh; QUIET variant is only the eyes |
| 4 | Tired | |
| 5 | Concerned | |
| 6 | Flat | The "I'm not going to react to that" face. BLUNT's default at 65%. |
| 7 | Startled | |
| 8 | Hurt | Physical |
| 9 | Hurt (other) | Emotional. Distinct art. Used 9 times in the game. |
| 10 | Angry | Rare. Six scenes. |
| 11 | Trying not to | The best one. Used in the Barro burn scene and three others. |
| 12 | Understanding | The UNKNOT face |
| 13 | Refusing | Finale-only, plus the First Ward |
| 14 | Open | Appears exactly twice: the Prologue's first frame, and whichever ending the player reaches. Bookend. |

---

## 3.5 What Aven Never Does

Hard rules for every writer on this project:

1. **Aven never narrates.** No internal monologue, no "I couldn't help but think." The
   player is not given Aven's interiority; they infer it, like a real person's.
2. **Aven never explains the world to the player.** Aven doesn't know it either.
3. **Aven never asks "what do you mean?"** to prompt exposition. If a term needs
   explaining, an NPC misuses it and someone corrects them.
4. **Aven is never surprised by lore twice.** Once Aven knows a thing, Aven knows it, and
   dialogue everywhere reflects it.
5. **Aven never speaks in themes** (GDD §02.7.3), and gets the fewest thematic lines of
   any character in the game — precisely three, all in the Finale.
6. **Aven's dialogue never apologises for the player's choices.** If the player was
   cruel, Aven was cruel. The game does not launder it.
