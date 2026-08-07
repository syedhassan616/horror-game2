# 03 — Supporting Cast & the 46 NPCs

---

## 3.1 Osk, Edda, and the Two Who Aren't Antagonists

### LEDGERMAN OSK
Fourteen minutes of screen time and the highest emotional yield per line in the project.

- **History.** Nineteen years in the Unclaimed. Wife **Marren**, d. Year 892. *Unmoored*
  and managing it as a workplace hazard: *"The trick is jobs. Small ones, back to back,
  with a next one."*
- **Tell:** he never stops working during a scene. Not once, including his own severance.
- **Arc.** Complete in minute six. He is the only major character whose arc finishes, and
  it finishes by being taken from him. **NG+ gives the player the chance to prevent it**
  (S-011), and he returns in Act III as the only person alive who has read the entire rule
  set end to end.
- **Favourite things.** Forms nobody has used. Boiled sweets. A correctly cross-referenced
  pair. Marren's cruel laugh.

### EDDA GRIST
- **History.** Blind from birth; reads by the emotional weight of a page. Has read the
  whole Commonplace, which is every feeling anyone ever wrote down. Sixty years of it.
- **Refuses the mentor role explicitly:** *"You want me to tell you it means something.
  I catalogue. I don't appraise."*
- **Tell:** her eyes never track. All expression is mouth and brow (7 expressions, no eye
  frames).
- **The one page.** Merit's severance request. She will not touch it. Forcing her
  (Quest 33) changes her permanently and reduces her final scene to two lines.
- **Arc.** Archivist → the one page → the admission that a library ordered by emotional
  weight is not neutral and never was.

---

## 3.2 The 46 Named NPCs

Every one passes the three-question test (GDD §04.3) or is cut. Each has `memory_flags`,
≥3 conversation stages, a `severed` variant where applicable, a `reading_bias`, and a
time-of-day schedule.

### Wyndmarrow (9)
| NPC | Wants today | Knows | Changes when |
| --- | --- | --- | --- |
| **Halden Brack** | Criteria for keeping things | What Odile was like, in perfect detail | Odile returned; objects Aven discarded |
| **Odile Brack** *(severed)* | The bread to prove | Nothing she can use | — |
| **Marrow-Warden Pell** | The post to go out | Registry procedure; the reserved number is 900 years old | Bell Count → inventory |
| **Guisley** | Steady hands for one casting | Bell-metal, and that his first casting cracked | Dies if Quest 03 fails; forge goes cold |
| **The Boy With The Ladder** | To not be the one who rubs out marks | The count, before anyone | Bell Count bands |
| **Sella & Ord** *(rota family A)* | The dawn slot | Why they need to be first | Quest 05 |
| **The Herrick Family** *(rota family B)* | The dawn slot | Same, differently | Quest 05 |
| **Old Nan Wicke** | Someone to carry peat | Every silence in the village since 1899 | Bell Count |
| **The Deaf Quarter Three** | To ring anyway | That the sound doesn't reach them and never did | P-WYN-1 |

### The Grieving Wood (4)
The **Sexton** (hums instead of the sentence; buried his own) · **Ivo & Nan** (planting
their own tree early — the game's warmest scene, and its quietest argument against
Hushfell) · the **Understory Watcher** (never speaks; leaves things).

### Hushfell (6)
**Brother Fen** (withdrawn four times; comic relief; the reason the region is survivable) ·
**Candidate Ossa** (third day; funnier and more decided than Aven) · **Candidate Weir**
(day one; will be there all game) · **Sister Pell-Anne** (kettle rota, fiercely) ·
**The Cook** · **The Register Keeper** (has read all 300 and remembers each).

### The Salt Ledger (5)
**Saltwright Coom** (going blind reading; wants one more dig) · the **Dune Registrar**
(sixty years alone, still stamping, content — the First Ward's mirror, planted six hours
early) · **Kell and Kell** (two severed people who chose to be family on purpose; the most
hopeful scene in the game) · the **Storm-Watcher**.

### Verrick Loomworks (7)
**Barro** · **Dov** *(severed)* · **Foreman Idrisse** (knows everything, reports nothing;
*"Floor Nine hits quota"* is her entire answer and it is generous) · **Quill** (auditor's
apprentice; the pipeline that makes Vellums) · **Night Shift Two** (a loom running
correctly, unattended, and the woman who won't say why she left it) · **The Lift Operator**
· **Procurement**.

### The Drowned Choir (5)
**The Cantor** · **Sennet** · the **Chorister** *(severed, sings tunelessly, nobody has
told him)* · **Descant** (arranges around the wrong note, every day, out of love) ·
the **Fourth Part** (holds Sennet's line when he's away and hates it).

### Lamplight March (12)
**Rue** · **Deckhand Ottoline** (has worked out Rue is dying; wrote a letter she can't
deliver) · **Cook Marrow-Pot** (refuses to explain his name for four hours; the pot is
named after a person) · the **Signalwoman** (plots Act III) · **Coupling Crew ×3** ·
**Berth Steward** · **Stores** · **Lamp-Trimmer** (the only person in Vesselmere whose job
is keeping light warm — a walking statement of the art direction) · **Two Passengers**
who are not crew and never explain themselves.

### The Orrery / Commonplace / Ash Garden (8)
**Astronomer Vey** · the **Untethered** (the persuasive case for severance) · **Edda
Grist** · the **Reshelver** (never speaks; hands you books; is always right) ·
**Scholar Pim** (writing a history nobody will read) · the **Gardener** (was in the
battle; remembers walking home; two hundred years of unaccountable relief) · **Ferris**
(picking the flowers with his village's names so nobody else has to) · the **Cairn Keeper**.

---

## 3.3 The Anti-Filler Gate

**There are no one-line villagers.** Ambient population is silhouettes and crowd sprites
with no talk prompt. If it has a prompt, it has a name, a want, and three stages.

QA runs a per-region check:
```
for npc in region.npcs:
    assert npc.conversation_stages >= 3
    assert npc.want_today != ""
    assert npc.knows_unique_fact == true
    assert npc.reacts_to(bell_count | companion_loss | tone_drift)
```
A region fails art *and* narrative review on any assertion failure.

---

## 3.4 Death & Severance Ledger

**Eleven can die.** Guisley · Coom · Ossa *(severance, counted as death by epilogue logic)*
· Barro · Dov · Sennet · Ottoline · Annike · the Cantor · Vellum · Rue.

**Nine can be severed.** Osk *(mandatory except NG+)* · Odile · Halden *(both pre-game)* ·
Tilly · Sennet · Barro · the Chorister *(pre-game)* · Ossa · Fen.

**Every death and every severance has:**
1. An authored absence in the world (empty chair, unrung bell, still-set table).
2. A line in the relevant epilogue module.
3. A change in at least two other NPCs' `memory_flags`.
4. **No memorial dialogue from Aven.** Aven never eulogises. Other people do.

**The severed-character writing rule, restated because it is the most-violated in drafts:**

> A severed character may express **facts, habits, and courtesy.** They may never express
> a preference, a longing, or a regret. They are not sad, not hollow, and not diminished —
> they are pleasant, competent, and gone. If a line makes the player feel the severed
> character is suffering, the line is wrong and destroys the premise.
