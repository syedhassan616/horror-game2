# 04 — Prologue: The Unclaimed

**Runtime:** ~20 minutes · **Scenes:** S-001 → S-012 · **Region:** The Unclaimed
**Cast:** Aven, Ledgerman Osk
**Job of this act:** teach the rules, teach the tether, and commit the game's thesis
crime in front of the player before they know what any of it means.

---

## 4.1 The Prologue's Contract

In twenty minutes the player must learn, without a tutorial box:

1. What a Ward is.
2. What severance looks like from outside — and that it is not death, not grief, not
   villainy, and much worse than any of them.
3. How to move, read, and dig through a room's contents.
4. The Tether: SWAP, PULL, PLANT, Insight, Strain, UNKNOT.
5. That `SEVER` is in the menu and nobody mentions it.
6. That Aven's drawer was **reserved**.

And it must end with the player liking Osk enough that his loss lands — in **under
fourteen minutes of screen time with him.**

---

## 4.2 Scene List

### S-001 THE DRAWER [MANDATORY]
```
Location   The Unclaimed — Aisle 900, drawer bank
Cast       Aven
Purpose    Open the game on an image, not an explanation
```
**Beats.**
1. Black. A drawer rolls open — the sound is filed, papery, unhurried.
2. First frame: Aven's portrait, expression **14 (Open)**. Held for three full seconds
   with no UI at all. *(The only other time this expression appears is the final ending.)*
3. The player has control. They are lying in a drawer. Getting out is the first input.
4. The aisle stretches in both directions. Sodium lamp overhead. Breath fogs.
5. **No objective text. No prompt.** The only interactable in range is the next drawer.

**Exit.** Player leaves the drawer. `flag:woke`

---

### S-002 SEVENTY DRAWERS [MANDATORY — partially optional]
```
Location   The Unclaimed — Aisles 898–901
Cast       Aven
Purpose    Teach reading; deliver 70 lives in two lines each; hide F01
```
Seventy readable drawers. Each contains a Ward and an index card. Each card is **two
lines**: a name and a reason nobody came.

> **ENTRY 44,102 — ORRIN CADE.** *Bearer deceased Year 881. Carried: her brother. Brother
> notified twice. Brother is listed at this address.*

> **ENTRY 51,880 — (NAME WITHHELD AT BEARER'S REQUEST).** *Held pending. Bearer's request
> was that we not say who she carried, which we have honoured, which means we cannot
> return it.*

> **ENTRY 12 — ILSABET VANE.** *Bearer deceased Year 3, Rot. Carried: her husband.
> Husband declined collection. Husband's stated reason: "I'd only lose it again."*

Reading **all seventy** grants the hidden skill node *Osk's Filing* (GDD §07.2) and
achievement #42. Most players read four.

**F01 — Aven's own drawer.** Returnable to at any time. Its card reads:

> **ENTRY 1,441 — RESERVED.** *Do not shelve. Do not return. Do not open before
> instruction. — M.V., Year 6*

Aven can read it. Aven says nothing about it. **No character mentions this card again
until the Finale.**

**Exit.** `count:drawers_read`

---

### S-003 LEDGERMAN OSK [MANDATORY]
```
Location   The Unclaimed — the sorting desk
Cast       Aven, Osk
Purpose    Establish Osk; establish the world's rules through a man doing his job
```
Osk is somewhere past seventy, deaf in his left ear, and mid-way through re-shelving an
aisle he has re-shelved twice before because he keeps finding it wrong.

He is not alarmed by a person climbing out of the stock.

**The scene's engine:** Osk is *delighted*. Aven is a filing error, and Osk has been
alone with a correct filing system for nineteen years.

> **OSK.** "Oh, marvellous. Marvellous. Stand still a moment — no, turn — right. Right.
> You're not stock."
> **OSK.** "You're *in* stock. You're not *of* stock. Do you see the distinction? It's
> a lovely one. I've got a form for it and I've never once used it."
> **AVEN** [WRY] "Congratulations."
> **AVEN** [CAREFUL] "Should I be somewhere else?"
> **AVEN** [BLUNT] "Where am I?"
> **AVEN** [QUIET] "..."
> **OSK.** "You should be *catalogued*, is what you should be. Come on. Bring the drawer
> number, there's a good — no, leave the drawer. Just the number."

**Exposition discipline.** Everything the player learns here arrives as Osk's *work
problem*, never as a lecture:
- What a Ward is → Osk has to write down which one Aven has, and can't, because the
  Bearing reads as *nothing*.
- The Bearing → Osk asks Aven to point at whoever they carry. Aven can't. Osk assumes
  Aven is being modest and then, slowly, doesn't.
- Severance → Osk mentions, in passing, that intake has been "brisk lately."

**Exit.** `flag:met_osk` · Journal *People* entry: OSK

---

### S-004 THE THING ABOUT MY WIFE [MANDATORY]
```
Location   The Unclaimed — the sorting desk, while Osk works
Cast       Aven, Osk
Purpose    Make the player like him in ninety seconds. Plant everything.
```
Osk talks while he files. He does not stop working during any of it.

He carries his wife, **Marren**, dead eleven years. He is *Unmoored* — the most dangerous
condition in Vesselmere (§1.7) — and knows it, and treats it as a manageable workplace
hazard.

> **OSK.** "Eleven years. Everyone gets very careful around you, after. They talk to you
> like you're a shelf that might come down."
> **OSK.** "The trick is jobs. Small ones, back to back, with a next one. You'll notice
> I've re-shelved this aisle three times. I'm aware it's three times."
> **OSK.** "She'd have found that very funny. She had a *cruel* laugh. Marvellous woman."

**The plant.** Aven can ask why he doesn't have it taken out. Osk's answer is the game's
whole argument, delivered in the first ten minutes by a man who will not remember saying
it:

> **OSK.** "Because then I'd have eleven years of a very nice woman and no idea why I
> kept them."
> **OSK.** "You want to know the honest answer? It hurts in the mornings and I've got
> nothing else of hers."

**This is the line the memory puzzle in the Commonplace asks about** (GDD §09.4). The
game logs it. It is never highlighted.

---

### S-005 THE FILING ERROR [MANDATORY — TUTORIAL COMBAT]
```
Location   The Unclaimed — Aisle 902, collapsed
Cast       Aven, Osk, a Filing Error
Purpose    Teach the Tether across three phases
```
A drawer bank has burst. Something has assembled itself out of misfiled index cards.
It is not hostile so much as **insistent** — it wants to be put somewhere and it does not
know where.

**Osk lends Aven his Ward.** He says it the way you'd hand someone a torch.

> **OSK.** "Here — take Marren a minute. She's very good in a crisis. Was. Is. The grammar
> gets away from you."

**Phase 1 — MOVE + SWAP.** A wall of drifting cards with one gap on the far side.
Going around takes eleven seconds. SWAP takes one. The game never says this.

**Phase 2 — Insight + UNKNOT.** The Filing Error's diagnosis card is on the floor of the
arena, readable mid-fight: `MISFILED — SUBJECT UNCLEAR`. UNKNOT options:
- *It is holding a grudge* ✗
- *It is holding a place in a queue* ✗
- **It is holding a category it doesn't fit** ✓
- *It is holding a name* ✗

**Phase 3 — Strain.** Scripted: the game lets the tether SNAP once, harmlessly, and Osk
comments rather than the UI doing it.

> **OSK.** "Ah — don't stretch her. She'll go. She always went."

**`SEVER` is in the menu from phase one. Nothing acknowledges it.** If the player uses
it, the Filing Error is destroyed, the cards fall, and **Osk goes quiet for the first
time.** He picks the cards up. He does not say anything about it. `flag:severed_first`
is set and read in eleven places across the game.

**Exit.** `flag:tutorial_complete` · Insight/Strain HUD unlocked

---

### S-006 THE SENTENCE [MANDATORY] ★ **THE THESIS SCENE**
```
Location   The Unclaimed — the sorting desk
Cast       Aven, Osk
Purpose    The game's argument, delivered in 90 seconds, before the player has vocabulary
Duration   0:90. No music. No camera move. No cut.
```

Osk is putting Marren back. He is mid-sentence about the paperwork he's finally going to
get to do.

> **OSK.** "— so what I'll do is, I'll take the 4-C, which is for a *person* in stock,
> and I'll cross-reference it against a 9, which is for stock that's got no bearer, and
> honestly nobody's ever needed both at once so I'll be inventing a bit of it, which,
> between us, is the best part of the —"

**The audio ducks. Completely. Ambience included. 0.6 seconds of nothing.**
*(The severance sound: a silence, not a sound. GDD §11.5. Used 19 times in the game.
This is the first.)*

Osk's posture improves.

> **OSK.** "— which is the best part of the job. Sorry. Where was I."

He finishes the form. He is efficient about it. He is *better* at it.

The player can talk to him. Everything is fine. He is warm, helpful, and completely
himself in every respect a witness could name. Aven can ask about Marren:

> **AVEN** [any tone] "Marren."
> **OSK.** "Marren. Yes — good, that's on the 9, I'll want the spelling. Two r's?"
> **AVEN** [BLUNT] "She's your wife."
> **OSK.** "She was, yes. Eleven years gone. Why — is she relevant to the filing?"

He asks it *helpfully*. He is trying to do a good job.

**The tether.** The player still has Marren's Ward seated — the fight only just ended.
It goes **slack** on screen, in the HUD, silently. The first `— NOBODY —` of the game,
four hours before the one that matters.

**Aven's options here are all bad and the game knows it.**
- WARM: *"You loved her."* — Osk: *"I did! That's right. Is that on the form?"*
- BLUNT: *"They just took her out of you."* — Osk, kindly: *"Took what, sorry?"*
- CAREFUL: *"Do you want to sit down?"* — Osk: *"I've got aisle nine hundred to do."*
- QUIET: *(silence)* — Osk waits, patiently, then goes back to work.
- WRY: *"...Right. Two r's."* — Osk: *"Thank you. You're a great help."*

**No music cue. No reaction shot. The camera does not know this is the scene.**

**Exit.** `flag:osk_severed` — read in **nine** places, including the Finale.

---

### S-007 AISLE NINE HUNDRED [OPTIONAL]
```
Purpose    Let the player sit in it
```
Osk re-shelves. He will do this indefinitely and cheerfully. The player can follow him
for as long as they like. He has eleven new ambient lines, all pleasant, none of which
reference anything before the severance. He offers Aven a boiled sweet.

There is nothing to do here. **Players stay an average of 2m40s.**

---

### S-008 THE DRAWER, AGAIN [OPTIONAL — F01 payoff setup]
Returning to Aven's own drawer now shows Osk has filed a card next to it, in his hand,
from before:

> *Not stock. Ask what it wants. — O.*

He does not remember writing it. He agrees it looks like his handwriting.

---

### S-009 THE REQUISITION [MANDATORY]
```
Location   The Unclaimed — the desk
Cast       Aven, Osk
Purpose    Exit the region with an object and a destination
```
Osk hands Aven a slip. He is proud of it. It is beautifully filled in.

> **OSK.** "Right — an unclaimed heart should be walked up to the Registry, and that's
> Wyndmarrow, and that's two days on the north stair. Take the slip. They'll know what
> it is even if I don't."
> **OSK.** "And listen — " *(he means it, warmly, and it costs him nothing)* — "whoever
> you've got in there. Don't stretch them."

**Requisition 12-B/1441** is the number the player follows for the next four hours.
It is Merit's reserved entry. Osk has, entirely by accident, handed Aven the thread.

**Exit.** `item:requisition_slip` · `flag:prologue_complete` · destination Wyndmarrow

---

### S-010 THE STAIR [MANDATORY]
A two-minute walk up. The first parallax. The first music with a melody
(*Catalogue* → transition → *Ninety Bells*, distant, and slightly wrong). The player
can look back down the stair; the sodium lamps go on for a very long way.

---

### S-011 & S-012 — RESERVED FOR NG+ [ROUTE: NG+]

On New Game+, two additional scenes exist inside the Prologue's runtime.

**S-011 — THE NINETY SECONDS.** The severance in S-006 can be prevented. It requires a
specific unmarked action within the first ninety seconds of the region: reading
**Entry 12 (Ilsabet Vane)** in S-002 and then telling Osk about it before he starts the
form. Osk, being the best filing clerk in Vesselmere, notices that a nine-hundred-year-old
reserved entry is *live* and files a **query** — and a query, in the Assayer's rule set,
suspends action pending clarification.

He is not severed. He is confused, and irritated, and alive in the way he was.

**S-012 — WHAT OSK KNOWS.** If S-011 succeeds, Osk appears in Act III. He has spent the
game reading. He is the only person in Vesselmere who has read the whole rule set, and
he has *opinions*, and one of them is the key to the ASSUME ending's best variant.

> **OSK** [Act III] "Nine hundred years of precedent and not one soul's read it end to
> end. I have. It took me the winter." *(beat)* "It's not a monster, you know. It's a
> filing system that's been asked nine reasonable questions."

---

## 4.3 Why This Prologue Works

| Requirement | How it's met |
| --- | --- |
| Teach without tutorial text | Every mechanic is Osk's work problem, not a prompt |
| Make the player like Osk fast | He is competent, funny, and openly managing his own grief in front of a stranger |
| Land the thesis before vocabulary exists | S-006 happens before the player knows the word "severance" |
| Avoid melodrama | Osk is *fine*. The player is not. The gap is the whole effect. |
| Plant the endgame | F01 (reserved drawer), F02 (tether colour), Merit's initials, and Requisition 1441 — all in twenty minutes, none flagged |
| Make `SEVER` the player's own discovery | It is never mentioned. Roughly 60% of playtesters used it on the Filing Error. |
