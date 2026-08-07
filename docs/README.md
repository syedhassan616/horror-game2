# SECONDHEART — Production Documentation

> *"I remember her name. I remember the gap in her teeth and the way she held a cup.
> I know that I loved her. I just can't find where I kept it."*
> — Halden Brack, Wyndmarrow, first recorded severance of the Ninth Quiet

**SECONDHEART** is an original 2D pixel-art RPG built in **Godot 4.x**, combining
turn-based command structure with a two-body bullet-hell dodging system called **the Tether**.

- **Main story:** 4–6 hours
- **Completionist:** 8–10 hours
- **Designed for 3+ full playthroughs** — routes diverge structurally, not cosmetically

---

## Documentation Stages

| Stage | Deliverable | Status |
| --- | --- | --- |
| **1** | **Game Design Document** (master) | ✅ Approved |
| **2** | **Story Bible** | ✅ **Delivered — awaiting approval** |
| 3 | World Bible | ⏸ Pending approval of Stage 2 |
| 4 | Character Bible | ⏸ |
| 5 | Combat Systems | ⏸ |
| 6 | Quest Database | ⏸ |
| 7 | Dialogue Database | ⏸ |
| 8 | Music Bible | ⏸ |
| 9 | Art Bible | ⏸ |
| 10 | Programming Architecture | ⏸ |
| 11 | Folder Structure | ⏸ |
| 12 | Implementation | ⏸ |

Each stage expands one section of the Stage 1 GDD into full production depth.
The GDD is the **single source of truth**; later bibles may add, but may not contradict.

---

## Stage 1 — Game Design Document

Read in order. [Start at the index →](stage-01-game-design-document/00-index.md)

| # | Document |
| --- | --- |
| 00 | [Index & Reading Guide](stage-01-game-design-document/00-index.md) |
| 01 | [Vision, Pillars & Competitive Position](stage-01-game-design-document/01-vision-and-pillars.md) |
| 02 | [Narrative Overview — Acts, Twists, Themes](stage-01-game-design-document/02-narrative-overview.md) |
| 03 | [World Overview — 14 Regions](stage-01-game-design-document/03-world-overview.md) |
| 04 | [Character Overview — 12 Majors + NPC Framework](stage-01-game-design-document/04-characters-overview.md) |
| 05 | [Core Combat — The Tether](stage-01-game-design-document/05-core-combat-tether.md) |
| 06 | [Morality, Choice & Consequence](stage-01-game-design-document/06-morality-and-choice.md) |
| 07 | [Progression, Items & Economy](stage-01-game-design-document/07-progression-items.md) |
| 08 | [Bosses & Enemy Design](stage-01-game-design-document/08-bosses-and-enemies.md) |
| 09 | [Side Quests & Puzzles](stage-01-game-design-document/09-quests-and-puzzles.md) |
| 10 | [Endings & New Game+](stage-01-game-design-document/10-endings-and-newgameplus.md) |
| 11 | [Music & Sound Direction](stage-01-game-design-document/11-audio-direction.md) |
| 12 | [Art Direction & Rendering](stage-01-game-design-document/12-art-direction.md) |
| 13 | [UI/UX, Accessibility & QoL](stage-01-game-design-document/13-ui-ux-and-qol.md) |
| 14 | [Technical Architecture (Godot 4.x)](stage-01-game-design-document/14-technical-architecture.md) |
| 15 | [Content Manifest & Scope Ledger](stage-01-game-design-document/15-content-manifest.md) |
| 16 | [Achievements (78)](stage-01-game-design-document/16-achievements.md) |
| 17 | [Production Plan & Risk Register](stage-01-game-design-document/17-production-plan.md) |

---

## Stage 2 — Story Bible

[Start at the index →](stage-02-story-bible/00-index.md)

| # | Document |
| --- | --- |
| 00 | [Index & Scene Notation](stage-02-story-bible/00-index.md) |
| 01 | [Cosmology & the Rules of the World](stage-02-story-bible/01-cosmology-and-rules.md) |
| 02 | [History & the Nine Quiets](stage-02-story-bible/02-history-and-the-nine-quiets.md) |
| 03 | [Aven & the Voice System](stage-02-story-bible/03-aven-and-the-voice-system.md) |
| 04 | [Prologue — The Unclaimed](stage-02-story-bible/04-prologue.md) |
| 05 | [Act I — The Ringing](stage-02-story-bible/05-act-one.md) |
| 06 | [Act II — The Ledger](stage-02-story-bible/06-act-two.md) |
| 07 | [Act III — Three Routes](stage-02-story-bible/07-act-three.md) |
| 08 | [Finale — The Assay](stage-02-story-bible/08-finale.md) |
| 09 | [Epilogues — All Five Endings](stage-02-story-bible/09-epilogues.md) |
| 10 | [The Three Petitions](stage-02-story-bible/10-the-three-petitions.md) |
| 11 | [Foreshadowing & Payoff Ledger](stage-02-story-bible/11-foreshadowing-and-payoffs.md) |
| 12 | [Themes & the Arguments](stage-02-story-bible/12-themes-and-arguments.md) |
| 13 | [Continuity Bible](stage-02-story-bible/13-continuity-bible.md) |

---

## Originality Statement

SECONDHEART shares a *genre lineage* with Undertale — turn-based framing, an
action-dodge defensive layer, a non-violent route, multiple endings — and shares
nothing else. No name, location, enemy, attack, musical motif, character, or line
of dialogue is derived from any existing work. Specific and deliberate divergences:

| Undertale does | SECONDHEART does |
| --- | --- |
| One soul in a box | **Two bodies on an elastic tether** — dodging is a two-hand spatial problem |
| Pacifism is mechanically *easier* | **Pacifism is the highest-skill path** — you must sweep the tether *through* danger to earn INSIGHT |
| Mercy is a button that appears | **UNKNOT** requires you to correctly identify what a creature is holding, from evidence |
| Party is narrative-only | **Every companion rewrites your movement verb set** — losing one removes an ability permanently |
| Meta-narrative about save files | **Meta-narrative about grief and memory** — the game never breaks the fourth wall |
| Violence is a route | **Violence is thematically identical to the villain's act** — your attack command is `SEVER` |
