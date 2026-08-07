# SECONDHEART — World Bible (Stage 3)

**Authority:** subordinate to the GDD (Stage 1) and Story Bible (Stage 2).

Expands GDD §03 into room-level production spec. Where Stage 1 said *what a region is*
and Stage 2 said *what happens in it*, this document says **how it is built.**

| # | Document |
| --- | --- |
| 00 | Index & Conventions *(this file)* |
| 01 | [Regions I — The Unclaimed → Hushfell](01-regions-prologue-act-one.md) |
| 02 | [Regions II — Salt Ledger → Lamplight March](02-regions-act-two.md) |
| 03 | [Regions III — Orrery → The Undersleep](03-regions-act-three-and-secret.md) |
| 04 | [World Systems — map, travel, environmental storytelling](04-world-systems.md) |

---

## 3.0.1 Room Notation

Every room in the game carries an ID: `RGN-##`, e.g. `WYN-04`.

```
WYN-04  THE TOWER BASE
Size      2×1 screens (960×270)          Lights  4 (1 key, 2 fill, 1 emissive)
Exits     N→WYN-05 · S→WYN-03 · E→WYN-11(locked until flag:tilly_joined)
Contains  Tilly (schedule A) · bell rope puzzle P-WYN-2 · Keepsake K-WYN-03
Occluders 14                              Weather  mist (valley pool)
Scenes    S-102, S-111
Notes     The rope arrangement must read as engineered, not decorative.
```

**Region prefixes:** UNC · WYN · GRV · HSH · SLT · VRK · CHR · MAR · ORR · CMN · ASH ·
ASY · KEP · UND · REN *(LEDGER-exclusive)*.

---

## 3.0.2 Room Budget

**192 rooms total.** Distribution per GDD §15.2. Per-room build cost is not uniform:

| Class | Count | Build cost | Definition |
| --- | --- | --- | --- |
| **Corridor** | 61 | 0.5 day | Traversal, 0–1 interactables, no NPC |
| **Chamber** | 78 | 1.5 days | NPCs, interactables, ≥1 authored beat |
| **Set piece** | 38 | 4 days | Puzzle, mini-boss, or scripted scene |
| **Arena** | 15 | 6 days | Boss fights; bespoke geometry and lighting |

Total ≈ **410 room-days**, two environment artists ≈ **10 months**. This is the number
that sets Production B's length (GDD §17.2) and it has no slack in it.

---

## 3.0.3 The Four Constants — Build Requirements

Every settlement region must contain, as buildable objects:

| Constant | Build requirement |
| --- | --- |
| **A bell** | Interactable, rings, is a save point + fast-travel node, has an authored tone in the region's key |
| **A keyholeless door** | Visible from a main traversal path. Never in an optional room. Never highlighted. Interactable with a unique "there is no keyhole" response that is *different in every region.* |
| **A Registry post** | Shop or quest board. Stocks the region's route-reactive inventory. |
| **A severed person who doesn't mind** | Full NPC with a `severed` portrait, three conversation stages, and a specific reason they are content |

QA checks all four per region. A region missing one does not pass art review.

---

## 3.0.4 Lighting Conventions

Per GDD §12.3. Region-level rules:

- **Key light** is always motivated by a visible source. No ambient key.
- **Shadow colour** is a per-region palette entry, never black.
- **The tether is the brightest object in any combat arena**, including the Assay.
- **Warm light means someone is maintaining it.** Regions lose warmth as their state
  degrades — this is a lighting change, not a palette swap, and it is driven by world
  state (Bell Count, voices silenced, NPC deaths).

**The degradation ladder** — each region defines 4 lighting states:

| State | Trigger | Change |
| --- | --- | --- |
| `TENDED` | Default | Full warm key, all practicals lit |
| `THINNING` | First loss | 20% of practicals unlit. Nobody has trimmed them. |
| `COLD` | Half | Key light motivated only by sky. Interiors go blue. |
| `KEPT` | Total loss | Everything clean, tidy, and lit at minimum. **Not ruined — maintained by people who no longer see the point of more than minimum.** |

`KEPT` is the most important art state in the game. It is not desolation; it is
competence without warmth, and it must never look like a ruin.

---

## 3.0.5 Environmental Storytelling Catalogue

GDD §12.7.2 requires 20 authored "absence" set-dressings. Full list, with room:

| # | Absence | Room | Reads as |
| --- | --- | --- | --- |
| 1 | A chair pushed in, at a table set for two | WYN-07 (Halden's) | He tidies now |
| 2 | Laundry, out, clean, never brought in | WYN-09 (Odile's) | She still does it. It means nothing to her. |
| 3 | A bell frame with no bell | WYN-04 | Quest 01 failed |
| 4 | A rope wound round a fresh sapling | GRV-08 | Odile's keepsake |
| 5 | Forty keepsakes in a barrow, unburied | GRV-02 | The Sexton stopped |
| 6 | Three hundred teacups, washed, stacked | HSH-05 | The rite's volume |
| 7 | A kitchen window, warm, seen from outside | HSH-01 | The forbidden colour |
| 8 | A dig site, clean and sorted, no digger | SLT-11 | The Dune Registrar |
| 9 | A complaints box, bolted, full | VRK-09 | Quest 21 |
| 10 | A shopping list in a coat pocket | VRK-14 | Dov |
| 11 | A loom running with no operator, correctly | VRK-06 | The night shift that stopped |
| 12 | Forty-one stone seats, forty occupied | CHR-07 | The 41st part |
| 13 | A sealed car with a house inside it | MAR-12 | Rue |
| 14 | A place set in the mess car, nobody sits | MAR-04 | Whoever the player lost |
| 15 | An island orbiting nothing | ORR-09 | Corrin Vane |
| 16 | An empty shelf, dusted, labelled, label blank | CMN-11 | Merit's page |
| 17 | Weapons stacked neatly, rusted into shape | ASH-03 | Both armies went home |
| 18 | A wooden chair, worn smooth on the arms | ASY-06 | Merit sat there |
| 19 | A drawer stamped RESERVED | UNC-03 | Aven |
| 20 | A door, open one inch, from the other side | KEP-02 | Entry 2 |

**Rule:** none of these is ever pointed at. No camera move, no glow, no interact prompt
beyond the standard. Nine of the twenty have no interaction at all — they are only
scenery, and players find them or don't.
