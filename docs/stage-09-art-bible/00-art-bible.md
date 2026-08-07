# SECONDHEART — Art Bible (Stage 9)

Expands GDD §12 into production specification.

| # | Document |
| --- | --- |
| 00 | Palette, Sprites & Pipeline *(this file)* |
| 01 | [Shaders, Lighting & VFX](01-shaders-and-lighting.md) |

---

## 9.0.1 The 64-Colour Master Palette

Structured, not arbitrary. Every region sub-palette draws from these ramps.

| Ramp | Steps | Purpose |
| --- | --- | --- |
| **Bone** | 6 | Paper, salt, snow, skin highlights — the game's white |
| **Ink** | 6 | Line, shadow core, the Assay's black |
| **Ochre** | 5 | Wyndmarrow, lamplight, brass |
| **Moss** | 5 | Grieving Wood mid-tones |
| **Deep Green** | 4 | Canopy, water depth |
| **Slate** | 5 | Stone, wet roofs, Hushfell charcoal |
| **Indigo** | 5 | The Unclaimed, night, shadow tint |
| **Teal** | 5 | Drowned Choir, caustics |
| **Copper** | 5 | Verrick, machinery, the Orrery's brass |
| **Rust** | 4 | Salt Ledger shadow, oxidation |
| **Violet** | 4 | Horizons, bruise tones |
| **Amber** | 5 | Commonplace, practicals, warmth |
| **Signal** | 5 | The tether, Insight gold, Strain red, i-frame white, emissive |

**The Signal ramp is reserved.** No environment or character art may use it. It exists so
that anything glowing in this game is *mechanically meaningful* — the player learns within
ten minutes that Signal colours mean "this concerns you."

**Region sub-palettes** are 20–28 colours drawn from these ramps, plus each region's
**forbidden colour**, which appears exactly once (GDD §12.5).

---

## 9.0.2 Sprite Specification

| Asset | Size | Frames | Extras |
| --- | --- | --- | --- |
| Aven | 32×40 | 9 animation sets | Normal map, occluder polygon |
| Companions | 32×40 | 9 sets each | + combat Ward glyph, ATTUNE anim, victory anim, hurt-Aven idle |
| NPCs | 24–40 | 4 sets | + `severed` variant |
| Enemies | 16–64 | **6 each** | idle, telegraph, attack, hurt, unknot-resolve, sever-resolve |
| Bosses | 48–240 | 12–30 each | Multi-part rigs for phase transitions |
| Portraits | 96×96 | 8–14 expressions | 2-frame blink, 3-frame mouth cycle |

**Animation frame rate: 8–14 fps for characters, 60 fps for effects and bullets.** Chunky
characters, smooth danger. This is the visual language of the whole game and it is not a
compromise — it is how the player's eye separates *people* from *threat*.

### The severed NPC variant

**Not grey. Not dead-eyed. Not slumped.**

| Change | Amount |
| --- | --- |
| Posture | Straighter by 1–2 px at the shoulder |
| Idle animation | 15% slower, 40% less variance |
| Blink rate | Regular. Perfectly regular. |
| Palette | **Unchanged** |
| Expression set | Same 4, but the "concerned" frame is replaced with a second "neutral" |

Playtesters find this far more disturbing than a corpse palette, and the reason is that
they cannot immediately say what changed.

---

## 9.0.3 Normal Maps

**Every character sprite and every tileset ships a hand-painted normal map.** This is what
makes 16-bit art read as three-dimensional under a moving lamp, and it is the single
largest per-asset cost in the art budget.

**Authoring:** painted in Aseprite as a separate layer group using a 6-colour normal
palette (up, down, left, right, toward, flat), then converted on import. Hand-painting
beats generated normals for pixel art by a wide margin and the conversion is scriptable.

**Cost:** +40% on character sprites, +25% on tilesets. Budgeted.

---

## 9.0.4 Tilesets

**14 tilesets, 16×16, ~180 tiles each.** Each tile carries four channels:

| Channel | Content |
| --- | --- |
| Albedo | The pixels |
| Normal | Hand-painted |
| Emissive | Self-illumination mask (lamps, bell-metal, choir voices, the tether) |
| Occluder | Polygon for `LightOccluder2D`, authored per tile |

**Auto-tile terrain sets** for each region's primary surfaces. Corner-match 47-tile
blobs where the surface warrants it; simpler 16-tile sets elsewhere.

---

## 9.0.5 The Lighting Pass

**~192 rooms, hand-lit. No auto-lighting.** This is 192 × ~0.5 days = **96 days** of a
lighting artist's time and it is the reason the game looks the way it does.

### Rules
1. **Key light is always motivated by a visible source.** If a room is lit, the player can
   point at what is lighting it.
2. **Shadows are coloured, never black.** Shadow colour is a per-region palette entry.
3. **Warm light means someone is maintaining it.** The four-state degradation ladder
   (`TENDED / THINNING / COLD / KEPT`, Stage 3 §00.4) is a *lighting* change, not a palette
   swap.
4. **The tether is the brightest object in any combat arena**, including the Assay, where
   everything else is white paper. It is a real light source casting real shadows.

### `KEPT` — the most important art state

Everything clean, tidy, and lit at **minimum**. Not ruined. Not abandoned. Maintained by
people who no longer see the point of more than minimum.

If a `KEPT` room looks like a ruin, the build is wrong. The reference is not a bombed
house; it is a very tidy hospital corridor at 3 a.m.

---

## 9.0.6 Environment Animation

| System | Technique |
| --- | --- |
| Parallax | 5–7 layers, depth-sorted, per-layer wind offset |
| Foliage wind | Vertex-displacement shader driven by a global wind field. **Gusts are synced to the music's bar lines.** |
| Rain | Layered sheets + splash decals + puddle reflection (screen-space) |
| Snow | Particle + **per-tile accumulated depth value**; footprints persist and fill over ~90 s |
| Ash | Particle + additive overlay on the player sprite, cleared on RUN |
| Salt-storm | Screen-space scour + **actual layout swap** on region transition |
| Caustics | Projected animated pattern + refraction offset |
| Steam | Scheduled emitters on a 22-frame-multiple loop, learnable |
| Falling paper | Instanced quads; **each one carries a real severance record** from a 900-entry table and is readable if the player stops |

**Nothing is decorative.** Every one of these has at least one puzzle or traversal
consequence (Stage 3 §04.4).

---

## 9.0.7 UI Art Language

**Everything is paper.**

| Screen | Object |
| --- | --- |
| Pause | A form being filled in |
| Inventory | A filing drawer |
| Weave (skills) | A woven cloth on a frame |
| Map | Ink cross-section with **visible corrections** |
| Quest log | A stack of notes in the givers' handwriting |
| Journal | A field notebook |
| Save | A drawer with a card in it |

**Menus animate as sheets of paper** — sliding, stamping, filing. Confirm is a stamp, not
a click.

### Typography
| Font | Use |
| --- | --- |
| **Registry** | Clerical serif. UI, system text, the Assayer, all forms. |
| **Hand** | Anything a character wrote. **Moth speaks in Hand, in someone else's handwriting**, with small-caps attribution. |
| **OpenDyslexic-compatible alt** | Accessibility, with adjustable letter and line spacing |

### HUD
Minimal, and **two of the four critical resources live inside the play field**:

| Resource | Where |
| --- | --- |
| Self HP | Heart-pip row, top-left |
| Breath | Thin arc under the pips |
| **Insight** | **Gold fill along the tether itself** |
| **Strain** | **Red thread along the tether itself** |

---

## 9.0.8 Pipeline

| Step | Tool | Output |
| --- | --- | --- |
| Palette + style keys | Aseprite | 64-colour master, 15 sub-palettes, 3 style-key paintings per region |
| Tilesets | Aseprite → custom importer → Godot `TileSet` | Albedo + normal + emissive + occluder |
| Characters | Aseprite | Sprite sheet + normal + occluder, via `.aseprite` importer |
| Bullets/VFX | Aseprite + Godot particles | 60 fps; bullets are `MultiMesh` quads |
| Lighting | In-engine, by hand | 192 rooms |
| **Review gate** | Custom tool | Every room rendered through **greyscale + 3 CVD LUTs**; art review blocks on failure |

**The greyscale gate** is how the colourblind support in GDD §13.6 is guaranteed real
rather than a filter bolted on at the end: **if a room reads in greyscale, it reads for
everyone.** No room ships without passing.

---

## 9.0.9 Asset Counts & Schedule

| Class | Count | Est. days |
| --- | --- | --- |
| Tilesets (14 × 180 tiles × 4 channels) | 14 | 140 |
| Room lighting passes | 192 | 96 |
| Major character sprites + normals | 12 | 72 |
| NPC sprites + severed variants | 46 | 92 |
| Enemy sprites (84 × 6 anims) | 504 anims | 126 |
| Boss sprites (17 × 12–30) | ~320 anims | 160 |
| Portraits (~600 frames) | 58 sets | 116 |
| Aven portraits (14 × 5) | 70 | 20 |
| UI screens | 13 | 39 |
| Cutscene illustrations | 24 | 48 |
| VFX sets | 9 families | 27 |
| **Total** | | **~936 days** |

**Two artists over 18 months ≈ 780 days.** The gap is closed by:
- Cutting cutscene illustrations from 24 to 16 (−16 days)
- Sharing tileset work with the environment artist's room-lighting time (overlap, −60)
- Contract support for enemy animation in months 9–13 (−80)

**This is the tightest budget in the project and it is flagged in the risk register.**
