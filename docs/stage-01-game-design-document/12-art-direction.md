# 12 — Art Direction & Rendering

> Full sprite sheets, palette swatches, tileset specs and animation frame counts are
> **Stage 9 (Art Bible)**. This chapter fixes the visual language and the render pipeline.

---

## 12.1 The Look in One Line

> **16-bit pixel art lit like a modern game** — hand-authored sprites at a strict pixel
> grid, rendered through normal-mapped 2D lighting, volumetric shafts, and real-time
> shadow casting, so that a 32×32 sprite has a warm side and a cold side.

The reference feeling is a **lamplit interior at dusk**: the pixels are honest and
chunky, and the light falling across them is not.

---

## 12.2 Technical Art Specification

| Property | Value | Rationale |
| --- | --- | --- |
| **Internal resolution** | 480 × 270 | 16:9, integer-scales to 1920×1080 (×4) and 2560×1440 (×5⅓ → letterbox or ×5 + border) |
| **Pixel grid** | Strict. All sprites authored on-grid, no sub-pixel sprite art | |
| **Camera** | **Sub-pixel smooth** with a pixel-snapping post pass | Smooth camera + snapped sprites = no shimmer, no jitter. The single most important rendering decision. |
| **Character sprite** | 32 × 40 px (Aven), 24–96 px (NPCs/enemies), bosses up to 240 px | |
| **Tile size** | 16 × 16 | |
| **Palette** | 64-colour master, region sub-palettes of 20–28 | Cohesion without monotony |
| **Colour depth** | Sprites authored in palette; **lighting works in full colour** and is quantised back to a 5-bit-per-channel LUT at the end of the frame | Preserves the pixel-art feel while allowing real lighting |
| **Animation** | 8–14 fps for characters (deliberately below render rate), 60 fps for effects/bullets | Chunky characters, smooth danger — the visual language of the whole game |
| **Target frame rate** | 60 FPS locked | Non-negotiable (§05.11) |

---

## 12.3 Lighting Model

Godot 4's 2D lighting (`PointLight2D`, `DirectionalLight2D`, `LightOccluder2D`) plus
custom shaders.

| Feature | Implementation |
| --- | --- |
| **Normal maps** | Every character sprite and every tileset ships a hand-painted normal map. This is what makes 16-bit art read as three-dimensional under a moving lamp. |
| **Dynamic shadows** | `LightOccluder2D` on all solid geometry + characters. Shadows are **soft, coloured, and directional**, never black — shadow colour is a per-region palette entry. |
| **Volumetric shafts** | Screen-space god-ray shader, masked by occluders. Heavy in the Grieving Wood and Commonplace, absent in the Orrery (which has no atmosphere and therefore no shafts — a deliberate visual shock). |
| **Emissive palette** | A dedicated emissive channel per tileset. Lamps, bell-metal, choir voices, and the tether all self-illuminate. |
| **Colour grading** | Per-region LUT, blended on transition, and **route-shifted** — the LEDGER route desaturates every LUT by 12% over Act III without ever announcing it. |
| **The tether's light** | The tether is a real light source that casts real shadows. In dark rooms you navigate by the line between you and the person you're carrying. This image is the entire game. |

---

## 12.4 Environment Animation & Weather

Every region is *moving* before the player does anything.

| System | Regions | Notes |
| --- | --- | --- |
| **Parallax** | All | 5–7 layers, depth-sorted, with per-layer wind offsets |
| **Wind** | Wyndmarrow, Grieving Wood, Ash Garden | Vertex-displacement shader on foliage, driven by a global wind field that also drives the audio. **Wind gusts are synced to the music's bar lines.** |
| **Rain** | Wyndmarrow (Act III), Verrick (indoor condensation) | Layered, with splash decals and puddle reflections |
| **Snow** | Hushfell | **Accumulates.** Footprints persist and fill in over ~90 seconds. Snow depth is a real per-tile value. |
| **Ash-fall** | Ash Garden | Settles on the player sprite as an additive overlay; brushes off on RUN |
| **Salt-storms** | Salt Ledger | Scour and **reveal** — the region's layout genuinely changes after each storm |
| **Caustics & current** | Drowned Choir | Underwater refraction shader; current visibly pushes particles and the player |
| **Falling paper** | The Assay, Commonplace | Individually readable forms. Each is a real severance record pulled from a 900-entry table. |
| **Steam & heat shimmer** | Verrick, Salt Ledger | Scheduled vents the player can learn and exploit |
| **Ambient life** | All | Birds, insects, laundry, smoke, distant figures. **Ambient population is silhouettes only** — anything you can talk to is a real NPC (§04.3). |

---

## 12.5 Region Palettes

Each region gets a 20–28 colour sub-palette pulled from the 64-colour master, plus a
**forbidden colour** — one hue that never appears in that region, so its single
appearance is an event.

| Region | Palette | Forbidden colour | Its one appearance |
| --- | --- | --- | --- |
| The Unclaimed | Indigo, bone, one sodium amber | Green | The reserved stamp on Aven's drawer |
| Wyndmarrow | Ochre, wet slate, moss, brass | Pure white | Odile's laundry, always out, always clean |
| Grieving Wood | Nine greens, loam brown | Red | A bell-rope on a fresh sapling |
| Hushfell | White, pale blue, charcoal | Warm yellow | The kitchen window, seen from outside |
| Salt Ledger | Bleached white, rust, violet horizon | Blue | Water, once, in a dig site, and it's a mirage |
| Verrick | Copper, bruised purple, sodium | Sky blue | Dov's shopping list paper |
| Drowned Choir | Teal, gold leaf, silt | Any warm hue | The surface, from below, at the end |
| Lamplight March | Warm lamp + whatever's outside | Black | The twelfth car's interior |
| The Orrery | Space blue, brass, verdigris | Skin tones | The Untethered's hands |
| The Commonplace | Amber, oxblood, dust | Cold light | The page Edda won't touch |
| Ash Garden | Grey + wrong flowers | Grey (in the flowers) | The one you don't recognise, which is grey |
| The Assay | Paper white, ink black | **All colour** | Aven. You are the only colour in the frame. |
| The Keeping | Every palette at once | — | — |

---

## 12.6 Character Art

| Asset | Spec |
| --- | --- |
| **Aven** | 32×40. **14 expressions** × 5 tone-drift variants (portrait art changes as the Voice System drifts — a `BLUNT` Aven's neutral face is different by Act III). 9 animation sets. |
| **Portraits** | 96×96, drawn at pixel level, 2-frame blink + 3-frame mouth cycle. Every major has 8–14 expressions. |
| **Companions** | Full overworld sprite, portrait set, combat Ward glyph, ATTUNE animation, victory animation, **and an idle-when-Aven-is-hurt animation** (§04) |
| **NPCs (46)** | Overworld sprite + portrait + `severed` variant. The severed variant is **not** grey or dead-eyed — it is the *same face, slightly better posture, marginally more relaxed.* Playtests find this far more disturbing than a corpse palette. |
| **Enemies (84)** | 6 animations each: idle, telegraph, attack, hurt, unknot-resolve, sever-resolve. **Unknot and Sever resolutions are different animations for all 84.** |
| **Bosses (17)** | 12–30 animations each; multi-part rigged sprites for phase transitions |

---

## 12.7 Visual Storytelling Rules

1. **The camera never knows it's a sad scene.** No push-ins, no slow zooms on faces, no
   letterboxing for drama. The camera behaves identically in the funniest and worst
   moments in the game.
2. **Absence is drawn.** Every dead or severed NPC leaves a *composed* environmental
   trace: an empty chair pushed in, a set table, a bell with no rope, a bed made too
   neatly. 20 authored absence set-dressings.
3. **Light is character.** Warm light means someone is maintaining it. When Wyndmarrow
   loses hope, nobody trims the lamps, and the region gets darker for reasons the
   player can reconstruct.
4. **No UI in the world.** No floating markers, no glowing interactables by default, no
   exclamation points. Interactables are readable because they are *lit* and *animated*.
   (An accessibility toggle adds outlines — §13.)
5. **The tether is always the brightest thing on screen** during combat, including
   during the Assayer's fight, where everything else is white paper.

---

## 12.8 UI Art Language

- **Everything is paper.** Menus are forms, stamps, index cards, and ledger rules.
  The inventory is a filing drawer. The skill tree is a woven cloth. The map is a
  cross-section drawn in ink with visible corrections.
- **Animated menus:** panels slide as sheets of paper, stamped rather than clicked;
  the pause menu is a form being filled in.
- **Typography:** two authored pixel fonts — *Registry* (a clerical serif, for UI and
  system text) and *Hand* (for anything a character wrote). Moth speaks in **Hand, in
  someone else's handwriting**, with attribution in small caps.
- **The HUD is minimal:** Self HP as a heart-pip row, Breath as a thin arc, Insight as a
  gold fill *on the tether itself*, and Strain as a red thread *along the tether*. Two
  of the four critical resources are displayed **inside the play field, on the thing
  you are already looking at.**

---

## 12.9 Art Production Pipeline

| Stage | Tool | Output |
| --- | --- | --- |
| Palette + style keys | Aseprite | 64-colour master, 13 sub-palettes, 3 style-key paintings per region |
| Tilesets | Aseprite → Godot TileSet | 16px, auto-tile terrain sets, per-tile occluder + normal + emissive |
| Characters | Aseprite | Sprite + normal map + occluder polygon, exported via a custom `.aseprite` importer |
| VFX | Aseprite + Godot particles | Bullet art is 60fps procedural; environmental particles are Godot-native |
| Lighting pass | In-engine | Every room is lit by hand. No auto-lighting. ~180 rooms. |
| Review gate | — | Every room must be legible in **greyscale** and in **all three colourblind LUTs** before sign-off |

**The greyscale gate** is how we guarantee the colourblind support in §13 is real rather
than a filter bolted on at the end: if a room reads in greyscale, it reads for everyone.
