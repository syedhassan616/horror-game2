# 01 — Shaders, Lighting & VFX

---

## 9.1.1 The Render Chain

```
1. TileMapLayers + sprites          → albedo, normal, emissive (multi-channel canvas)
2. Light2D pass                     → normal-mapped diffuse + coloured shadows
3. Emissive composite               → self-illuminated pixels bypass lighting
4. Volumetric shafts                → screen-space, occluder-masked
5. Weather overlays                 → rain / snow / ash / caustics / heat
6. Region LUT grade                 → per-region colour, route-shifted
7. Palette quantise                 → 5-bit-per-channel snap
8. Pixel-snap resolve               → smooth camera → snapped output
9. UI layer                         → unquantised, unsnapped, always crisp
```

**Steps 7 and 8 are the whole trick.** Lighting works in **full colour**; the result is
quantised back to the palette at the end. This preserves the pixel-art read while allowing
a real coloured light to fall across a 32×40 sprite.

**The camera moves in sub-pixel increments; sprites snap.** Smooth camera + snapped sprites
= no shimmer, no jitter. Doing it the other way round is the most common failure in
lit pixel art and we do not do it.

---

## 9.1.2 Shader Inventory

| Shader | Type | Cost (ms) | Notes |
| --- | --- | --- | --- |
| `normal_lit_sprite` | CanvasItem | — | Base for all lit sprites |
| `emissive_composite` | CanvasItem | 0.2 | Bypasses lighting for Signal-ramp pixels |
| `volumetric_shaft` | Screen | 1.1 | Occluder-masked; heavy in GRV/CMN, **absent in ORR** |
| `foliage_wind` | Vertex | 0.4 | Global wind field; gusts bar-synced |
| `water_caustic` | Screen | 0.6 | CHR only |
| `water_refract` | Screen | 0.5 | CHR only |
| `heat_shimmer` | Screen | 0.3 | SLT, VRK |
| `salt_scour` | Screen | 0.4 | SLT storms |
| `ash_settle` | CanvasItem | 0.2 | Additive overlay on player sprite |
| `snow_depth` | TileMap | 0.3 | Per-tile accumulated depth |
| `puddle_reflect` | Screen | 0.5 | WYN Act III, VRK |
| `region_lut` | Screen | 0.4 | Per-region grade, blended on transition |
| `palette_quantise` | Screen | 0.3 | 5-bit snap |
| `pixel_snap` | Screen | 0.2 | Final resolve |
| `tether_glow` | CanvasItem | 0.2 | The tether's light + Insight/Strain fill |
| `strain_thread` | CanvasItem | 0.1 | Red thread along the tether |

**Worst-case region (Grieving Wood, 9 lights + shafts + wind):** 3.5 ms lighting +
1.8 ms environment = **5.3 ms**, inside the GDD §14.5 budget of 5.3 ms combined.

---

## 9.1.3 Lighting Setup Per Room

```
Room lighting manifest (authored per room)
  key_lights      : Array[LightDef]     # motivated, visible source required
  fill_lights     : Array[LightDef]
  emissive_masks  : Array[TileRange]
  shadow_colour   : Color               # region palette entry, NEVER black
  degradation     : {TENDED: [...], THINNING: [...], COLD: [...], KEPT: [...]}
  shaft_enabled   : bool
  shaft_angle     : float
```

**Every room authors all four degradation states.** In practice this is one light set with
four enable-masks and four intensity curves, not four hand-lit passes — but the *artist
checks all four*, and the review gate renders all four.

### Light counts per region (typical room)

| Region | Key | Fill | Emissive | Notes |
| --- | --- | --- | --- | --- |
| The Unclaimed | 1 sodium | 1 | Low | Alternating pools of warm/cold down the aisle |
| Wyndmarrow | 1 sky | 2–3 | Lamps, forge | Golden hour; goes overcast permanently below 78 |
| Grieving Wood | 1 canopy | 2 | Minimal | Heaviest shaft use |
| Hushfell | 1 sky (flat) | 1 | **Kitchen only** | Near-monochrome; the one warm room is the argument |
| Salt Ledger | 1 sun (hard) | 0 | None | Hardest shadows in the game |
| Verrick | 0 sky | 4–6 artificial | Heavy | Only region with strong artificial key |
| Drowned Choir | 1 surface shaft | 2 | Gold leaf, voices | Caustics |
| March | 2–3 practicals | 2 | Lamps | Warm interior vs scrolling exterior |
| Orrery | 1 starlight | 0 | Brass | **No shafts — no atmosphere** |
| Commonplace | 0 sky | Readers' lamps | Amber | Light sources are people's lamps |
| Ash Garden | 1 overcast | 1 | Flowers | Flat, wrong-coloured |
| The Assay | 1 flat | 0 | Falling forms | Aven is the only colour |
| The Keeping | **All region palettes at once** | — | Everything | Like light through a rose window |

---

## 9.1.4 The Tether's Rendering

The single most important visual in the game.

```glsl
// tether_glow.gdshader (excerpt)
// Rendered as a 6-segment polyline with per-segment width and colour.
// Insight fills from Self outward; Strain overlays as a thin inner thread.

uniform float insight;        // 0..1
uniform float strain;         // 0..1
uniform vec4  companion_tint; // per companion
uniform vec4  merit_tint;     // F02 — always present, always faint
```

**Three layers:**
1. **Base line** — companion tint, width 1.5 px, emissive.
2. **Insight fill** — Signal-gold, fills from Self outward as a proportion of 100.
3. **Strain thread** — Signal-red, 0.5 px, inside the base line, density rising with Strain.

**Plus a fourth, always:** a second, fainter line in **`merit_tint`** — a colour no
companion produces — visible in every fight from the tutorial onward (F02). It is never
mentioned. It is never brighter than −40% of the base. Players screenshot it in week one
and argue about it for months.

**The tether is a real `PointLight2D` along its length**, casting real shadows. In dark
rooms the player navigates by the light between themselves and the person they are
carrying, which is the entire game rendered as a lighting decision.

---

## 9.1.5 Bullet VFX

**60 fps, `MultiMeshInstance2D`, one draw call for up to 4,096.**

| Type | Mesh | Trail | Telegraph |
| --- | --- | --- | --- |
| Pellet | 4×4 quad | None | Emitter flash + scale pulse |
| Bolt | 8×3 quad | 3-frame ghost | Flash + directional streak |
| Beam | Stretched quad | — | **Ghost line** — thin, the exact future path |
| Curl | 5×5 quad | 6-frame arc | Dotted arc preview |
| Weight | 12×12 hex | None | **Ground shadow**, 24 frames |
| Special | Per boss | Per boss | Character animation windup |

**Shape language is colour-independent by mandate.** Verified in the monochrome+shape
accessibility pass — every type distinguishable by silhouette and motion alone.

---

## 9.1.6 The Review Gate

No room, sprite, or VFX set ships without passing all four:

| Pass | Check |
| --- | --- |
| **Greyscale** | Room is fully readable with all colour removed |
| **Protanopia LUT** | Readable |
| **Deuteranopia LUT** | Readable |
| **Tritanopia LUT** | Readable |

Plus, for combat content:

| Pass | Check |
| --- | --- |
| **Silhouette** | Every bullet type distinguishable with fill removed |
| **Still-frame safety** | A random frame from a recorded boss run contains a survivable path identifiable in <200 ms |
| **Telegraph audit** | No lethal projectile with <12 frames of visible tell |

**The greyscale gate blocks art review.** It is not a late-stage accessibility sweep; it
is a daily constraint on how rooms are lit, and it is the reason the colourblind support
is real.

---

## 9.1.7 Performance Guardrails

| Guardrail | Limit |
| --- | --- |
| Lights per room | 9 (soft), 12 (hard) |
| Occluders per room | 40 |
| Screen-space shaders active simultaneously | 4 |
| Particle systems per room | 3 |
| Bullets | 2,000 authored / 4,096 engine |
| Draw calls per frame | < 90 |

**Reference hardware: Intel UHD 620 / Steam Deck.** If the Deck holds 60 FPS, everything
does. Perf Sentinel tracks per-scene frame time in CI and fails on regression.

**The 2.7 ms headroom in the frame budget is reserved and is not spent without a review.**
