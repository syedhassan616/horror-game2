# 15 — Content Manifest & Scope Ledger

The full countable inventory of SECONDHEART. This is the contract between design and
production: **anything not on this list is out of scope**, and anything on it is a
committed deliverable tracked in Stage 17's schedule.

---

## 15.1 Master Counts

| Content | Count | Spec'd in |
| --- | --- | --- |
| **Regions** | 14 (10 core + 2 route-exclusive Act III wings + 2 secret) | §03 |
| **Rooms** | ~180 | §03, Stage 3 |
| **Major characters** | 12 | §04 |
| **Named NPCs** | 46 | §04.3 |
| **Companions (playable Wards)** | 5 | §05.8 |
| **Enemy types** | 84 across 9 families | §08.7 |
| **Major bosses** | 10 | §08.2 |
| **Optional bosses** | 5 | §08.3 |
| **Secret bosses** | 2 (incl. the superboss) | §08.4, §08.6 |
| **Mini-bosses** | 11 (1/region) | §03, §08.5 |
| **Total boss encounters** | 28 (incl. Vellum ×4 and NG+ variants) | |
| **Side quests** | 35 (9 failable, 6 mutually exclusive pairs) | §09.2 |
| **Puzzles** | 71 (22 optional, 9 hidden) | §09.4 |
| **Items** | 118 (+84 Keepsakes) | §07.5 |
| **Skill nodes** | 34 + 4 hidden | §07.2 |
| **Movement upgrades** | 9 | §07.4 |
| **Endings** | 5 | §10 |
| **Epilogue modules** | 14 (≈2.1M readings, all hand-written) | §10.3 |
| **Achievements** | 78 | §16 |
| **Music tracks** | 34 | §11.3 |
| **Music stems** | ~180 | §11.4 |
| **SFX** | ~900 | §11.5 |
| **Words of dialogue** | ~78,000 | §15.3 |

---

## 15.2 Content-per-Region Ledger

| Region | Rooms | NPCs | Quests | Puzzles | Enemies | Mini | Boss | Keepsakes | Tracks |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| The Unclaimed | 8 | 1 | 0 | 3 | 3 | — | tutorial | 4 | 1 |
| Wyndmarrow | 22 | 9 | 5 | 8 | 8 | 1 | B1 | 6 | 3 |
| The Grieving Wood | 16 | 4 | 4 | 7 | 10 | 1 | B3 | 6 | 2 |
| Hushfell | 14 | 6 | 4 | 5 | 7 | 1 | Annike | 6 | 2 |
| The Salt Ledger | 18 | 5 | 4 | 8 | 9 | 1 | B4 | 6 | 2 |
| Verrick Loomworks | 20 | 7 | 5 | 9 | 12 | 1 | B5 | 6 | 2 |
| The Drowned Choir | 14 | 5 | 3 | 6 | 9 | 1 | B6 | 6 | 2 |
| Lamplight March | 16 | 12 | 6 | 4 | — | 1 | — | 6 | 2 |
| The Orrery | 15 | 4 | 3 | 8 | 8 | 1 | B7 | 6 | 2 |
| The Commonplace | 14 | 5 | 3 | 7 | 10 | 1 | B8 | 6 | 2 |
| The Ash Garden | 10 | 4 | 3 | 3 | 6 | 1 | B9 | 6 | 1 |
| The Assay | 8 | 2 | 0 | 2 | 4 | — | B10 | 4 | 2 |
| The Keeping | 3 | — | 1 | 1 | — | — | S2 | 4 | 1 |
| The Undersleep | 4 | — | 1 | 2 | — | — | S1 | 4 | 2 |
| **Act III wings** (route-exclusive) | 10 | 4 | 3 | 4 | 6 | 2 | — | 8 | 4 |
| **Totals** | **~192** | **68*** | **35** | **77†** | **92‡** | **13** | **17** | **84** | **30** |

\* NPC entries counted per-region; 46 unique (majors recur across regions).
† 77 placements of 71 distinct puzzles (6 puzzles recur with new content).
‡ 92 placements of 84 distinct enemy types.

---

## 15.3 Word Count Budget

| Category | Words | Notes |
| --- | --- | --- |
| Main story dialogue | 24,000 | Prologue → Finale, all acts |
| Companion conversations | 11,000 | Incl. 30 cooking scenes |
| Side quest dialogue | 14,000 | 35 quests × ~400 |
| NPC ambient (3+ stages × 46) | 9,000 | Zero filler — §04.3 |
| Boss dialogue (17 × multi-phase × routes) | 7,000 | |
| Enemy dialogue (84 × 3 lines + diagnoses) | 4,500 | |
| Item lore (118 + 84 Keepsakes) | 5,500 | |
| Journal / Register / strata / choir parts | 6,000 | Optional lore |
| Epilogue modules (14 modules × variants) | 8,000 | |
| NG+ overlays | 4,000 | |
| UI, system, accessibility, reference | 3,000 | |
| **Total** | **~96,000** | ~78,000 player-facing in a single playthrough |

For scale: a single playthrough reads roughly the length of a short novel; the full
corpus is roughly a long one. This is the largest single cost centre and the primary
schedule risk (§17.4).

---

## 15.4 Art Asset Manifest

| Asset class | Count | Per-unit |
| --- | --- | --- |
| Tilesets | 14 | ~180 tiles + normals + occluders + emissive each |
| Room lighting passes | ~192 | Hand-lit, no auto-lighting |
| Character sprites (majors) | 12 | 9 animation sets + normals |
| Character sprites (NPCs) | 46 | 4 sets + `severed` variant |
| Enemy sprites | 84 | 6 animations each = 504 animations |
| Boss sprites | 17 | 12–30 animations each ≈ 320 animations |
| Portraits | 58 | 8–14 expressions each ≈ 600 portrait frames |
| Aven portraits | 1 | 14 expressions × 5 tone variants = 70 |
| Bullet/VFX sets | 9 families | Shape-language constrained (§13.6) |
| UI screens | 13 | Fully animated, paper-metaphor |
| Cutscene art | 24 | Key moments, pixel-illustrated |
| Fonts | 3 | *Registry*, *Hand*, dyslexia-friendly alt |

---

## 15.5 Route Exclusivity Ledger

Required by §06.6.5 — proof that every route has content only it can see.

| Route | Exclusive regions | Exclusive bosses | Exclusive quests | Exclusive companion states | Exclusive tracks |
| --- | --- | --- | --- | --- | --- |
| **CARRY** | Ash Garden (full) | Both Armies, Annike (peaceful) | 6 | Moth authored; Vellum defected | 3 |
| **LEDGER** | The Rendering | The Rendering's Foreman; Vellum, Final Audit | 5 | Moth silent; Quill replaces Vellum | 3 |
| **DRIFT** | The Undersleep (early) | The Version Of You (early access) | 4 | Moth unwoven; Vellum promoted | 3 |

**Shared content:** ~65% by scene count. **Route-exclusive:** ~35%. A player who
finishes all three routes has seen ~92% of the game; the remaining 8% is the superboss
chain, NG+ exclusives, and three quests that are mutually exclusive *within* routes.

---

## 15.6 What Is Explicitly Out of Scope

Recorded so it can't creep back in:

| Cut | Why |
| --- | --- |
| Voice acting | 96k words × multiple routes; kills iteration and localisation. Babble is better for this game. |
| Open world / free roam | Pillar IV requires hand-authored consequence; an open world dilutes it |
| Crafting beyond cooking + the Loom | Systems for their own sake |
| Romance options | Would flatten "Ward" into "love interest" and break the core metaphor |
| Multiplayer / co-op | The tether is a one-player idea about carrying someone who can't carry back |
| Procedural content | Every scar must be authored |
| Mobile at launch | The tether needs two shoulder buttons |
| DLC planned pre-launch | The game has an ending. Several. |

---

## 15.7 Localisation Plan

- **All strings externalized from day one** (§14.3 `Localization`).
- Launch languages: **EN, FR, DE, ES-LATAM, PT-BR, JA, ZH-Hans, KO, RU, PL** (10).
- **Known hard problems, flagged now:**
  - The word *Ward* carries "guarded thing," "hospital ward," and "warding off" in
    English. Loc leads must choose a term per language *before* Stage 7 begins.
  - Moth's dialogue is quotations of other characters — every Moth line must be
    translated **as a quotation of that language's version of that character's line**.
    This requires the loc pipeline to link Moth lines to their source lines. Built into
    the dialogue compiler.
  - The Voice System's five tones must survive translation as *distinguishable
    registers*, not just word choice.
- Text expansion budget: **+35%** on all UI layouts (DE/RU worst case).
