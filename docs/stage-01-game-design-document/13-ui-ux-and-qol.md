# 13 — UI/UX, Accessibility & Quality of Life

---

## 13.1 UX Principles

1. **Critical combat information lives inside the play field.** Insight is drawn on the
   tether; Strain is drawn on the tether. The player never breaks eye contact with the
   thing that will kill them.
2. **The interface is diegetic.** Every screen is an object in Vesselmere — a form, a
   drawer, a chart, a cloth. This is not decoration; it means the UI can *carry lore*
   and *react to state* (your inventory drawer gets a `REVIEWED` stamp after Act II).
3. **Never explain twice.** Every mechanic is taught once, physically, in a safe room,
   and then trusted. A "Reference" page in the pause menu exists for everything, always.
4. **Nothing is buried.** Any information the player might want mid-session — quest
   giver's exact words, a conversation from three hours ago, what an item does — is
   ≤2 inputs away.
5. **Respect the player's time absolutely.** No unskippable anything. No forced walking
   sections that repeat. All cutscenes skippable on replay, all *individually*, with
   position memory.

---

## 13.2 Screen Inventory

| Screen | Metaphor | Contents |
| --- | --- | --- |
| **Title** | A bell in a frame | Continue / New / Chapter Select (post-clear) / Options / Extras. Changes permanently after first completion. |
| **HUD** | Nothing — near-invisible | Heart-pips, Breath arc, objective ribbon (fades after 6s), companion badge |
| **Pause** | A form being filled in | Journal, Inventory, Weave (skills), Party, Map, Options, Reference, Save |
| **Journal** | A field notebook | 4 tabs: Places · People · Things People Said · Questions. Full-text search after Osk's Filing. |
| **Inventory** | A filing drawer | Sort by: recency / rarity / type / **weight of the thing it reminds you of** (a joke sort that is also a real lore index) |
| **Weave** | A woven cloth on a frame | Skill tree; free respec at any bell |
| **Party** | Portraits on a coupling chart | Companion select, relationship state, their current opinion of you in *their words*, not a bar |
| **Map** | Ink cross-section with visible corrections | Region map + world cross-section. Fast-travel bells. Unreachable-content flags. |
| **Quest Log** | A stack of notes in NPCs' handwriting | Each quest is the *quest-giver's own phrasing*, not a system summary. Sorted by region. |
| **Dialogue History** | A transcript with margins | Scrollback of the entire session, searchable, **exportable to a text file** |
| **Reference** | A printed manual insert | Every mechanic, every verb, every status, always available |
| **Options** | A form in five sections | Controls · Display · Audio · Accessibility · Gameplay |
| **Extras** *(post-clear)* | A shelf | Music player (34 tracks + stem soloing), art gallery, endings archive, boss rematch |

---

## 13.3 Controls

**Full remapping** for keyboard, mouse, and every controller face/shoulder/stick input,
including chords, with per-profile saves and a **reset-to-default** that cannot be
accidentally triggered.

| Action | Keyboard | Gamepad | Notes |
| --- | --- | --- | --- |
| Move | WASD / Arrows | Left stick / D-pad | 8-way with analogue precision |
| Interact / Confirm | E / Enter | A | |
| Cancel / Back | Q / Esc | B | |
| SWAP | Space | A *(combat)* | The critical input. Also bindable to a trigger. |
| PULL | Shift | RB / R1 | |
| PLANT | Ctrl | LB / L1 | Hold or toggle (option) |
| Run | Shift | Right trigger | Overworld |
| Journal | Tab | Y | |
| Quick-item | 1–4 | D-pad | |
| Pause | Esc | Start | |
| Dialogue history | H | Right stick click | |

**Controller support:** Xbox, PlayStation (with correct glyphs), Switch Pro, Steam Deck,
and generic XInput/DirectInput. Glyphs auto-detect and are also manually overridable.
Hot-swap mid-session without a reconnect prompt.

---

## 13.4 Save System

| Feature | Spec |
| --- | --- |
| **Manual slots** | 12, named, with a screenshot, region, playtime, act, and a one-line "last thing that happened" |
| **Autosave** | 3 rotating slots, on: room transition, quest state change, pre-boss, post-boss, choice resolution. Never overwrites a manual slot. |
| **Bell saves** | Every fast-travel bell is a manual save point *and* heals — the game's rest point |
| **Save integrity** | Atomic write (temp + rename), CRC, and a `.bak` of the previous state. A corrupt save falls back rather than failing. |
| **Chapter select** | Post-clear. Any act, with a curated state, for ending-hunting. |
| **NG+** | §10.5 |
| **Cloud** | Steam Cloud; deterministic slot naming; conflict resolution shows both saves' metadata and lets the player choose |
| **Save file transparency** | Saves are JSON-in-a-container, *deliberately human-readable*. Players will datamine this game; the flags are named honestly and there is nothing in there we're embarrassed by. |

---

## 13.5 Quality of Life

| Feature | Detail |
| --- | --- |
| **Fast travel** | Per-region bells, unlocked on first ring, not on completion |
| **Quest log** | In the giver's words; no auto-markers by default |
| **Map** | Room-accurate, auto-filled, marks unreachable content, marks unread drawers/trees/strata |
| **Dialogue history** | Full session scrollback + export |
| **Inventory sorting** | 4 sorts + favourites + a compare view |
| **Auto-run toggle** | Overworld |
| **Instant respawn** | Death returns you to the Command Phase, not a menu |
| **Encounter re-entry** | Bosses can be re-fought from the Extras shelf without affecting save state |
| **Skip-on-replay** | Every cutscene individually skippable once seen, with resume-position |
| **Text speed** | 5 speeds + instant; independent for dialogue and system text |
| **Photo mode** | Free camera, hide-HUD, palette-swap, and a *frame* option that stamps the shot like a Registry document |
| **Playtime honesty** | The clock counts real time, including menus and idling. It is not gamified. |

---

## 13.6 Accessibility

Accessibility is a **design pillar commitment**, not a settings page. The stated goal:
**every player can reach every ending, every boss, and every secret.**

### Visual

| Feature | Detail |
| --- | --- |
| **Colourblind modes** | Protanopia, deuteranopia, tritanopia LUTs, plus a **monochrome+shape** mode. Every room passes the greyscale gate (§12.9). |
| **Projectile shape language** | All hostile projectiles are distinguishable by **silhouette and motion**, never colour alone. This is a hard art constraint, checked per enemy. |
| **UI scale** | 75%–200%, independent for HUD, dialogue, and menus |
| **Font options** | Both pixel fonts + an **OpenDyslexic-compatible** alternative + adjustable letter/line spacing |
| **High-contrast mode** | Outlines all interactables, enemies, and hazards |
| **Screen shake / flash** | Independently disableable. Flash intensity slider. **No content is gated behind a flashing sequence.** |
| **Motion** | Parallax reduction, particle density slider, camera smoothing toggle |

### Auditory

| Feature | Detail |
| --- | --- |
| **Full subtitles** | Including all non-speech audio (`[a bell, three streets away]`), speaker-coloured, with a background opacity slider |
| **Visual sound cues** | Optional on-screen directional indicators for off-screen audio telegraphs — the Ringer fight is fully playable deaf |
| **Independent mixers** | Music / SFX / ambience / UI / babble-voices, each 0–100 |
| **Mono audio** | Full downmix option |

### Motor

| Feature | Detail |
| --- | --- |
| **Full remapping** | Including one-handed layouts (two shipped presets: left-hand and right-hand) |
| **Hold→toggle** | Every hold input can be made a toggle, individually |
| **Input buffering** | 6-frame buffer on all combat verbs, adjustable to 12 |
| **Auto-SWAP assist** | Optional: SWAP fires automatically on a lethal frame, once per 3s |
| **CARRY ME mode** | Dodging fully automated. The Weave phase plays itself competently while the player watches, reads, and makes Command Phase decisions. **All 17 bosses, all 5 endings, all secrets remain reachable.** Not framed as easy mode — it is a different input contract and the achievement list does not distinguish. |

### Cognitive

| Feature | Detail |
| --- | --- |
| **Puzzle Assist** | Three levels: hint / strong hint / solve. Available on all 71 puzzles. No content or achievement is lost. |
| **Diagnosis Assist** | Optional: incorrect UNKNOT options are greyed rather than hidden |
| **Quest markers** | Off by default, fully available in options |
| **Reading time** | Auto-advance off by default; no timed dialogue anywhere in the game |
| **Reference** | Full mechanic glossary, always ≤2 inputs away |

### Content

| Feature | Detail |
| --- | --- |
| **Content notice** | On first launch and in options: this game deals with grief, terminal illness, assisted memory-loss, and the death of a child (referenced, not depicted). Specific, non-vague, skippable. |
| **Scene list** | An options-menu list of the game's heaviest scenes with the *act* they occur in, so a player can prepare. No plot spoilers. |
| **Photosensitivity** | No sequence in the game exceeds 3 flashes/second at default settings; the Assayer's phase-4 transition has a documented alternate. |

---

## 13.7 Onboarding

| Beat | Where | Taught |
| --- | --- | --- |
| Move, interact, read | Unclaimed, first 3 rooms | No text prompts — an NPC does the thing first |
| The tether exists | Osk lends his Ward | One line, then a safe room |
| SWAP | Tutorial fight, phase 1 | A wall with one gap, on the far side |
| Insight & UNKNOT | Tutorial fight, phase 2 | The Filing Error's diagnosis is on a card on the floor |
| Strain | Tutorial fight, phase 3 | The game lets you SNAP once, safely, and Osk comments |
| SEVER | **Never taught.** | It is in the menu from the first fight and the game never mentions it. Players find it themselves, which is the point. |

**The onboarding thesis:** the game teaches mercy explicitly and violence not at all,
and it still expects most first-time players to attack something in the first ten
minutes. That gap is the beginning of the argument.
