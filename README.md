# HOLLOWLIGHT — *A Descent in Six Lamps*

A browser horror game. No engine, no build step, no dependencies, no asset files.
Open `index.html` and it runs.

> In November 1911 the mining village of **Grimhollow** went dark in a single night.
> Nine hundred people. No bodies. The harbourmaster's final entry reads:
> *"The lamps have gone out and we cannot find the man who lights them."*
>
> You are **Wren Halloway**, hollow-mapper, sent to chart the mine before the cliff
> takes it. You carry your grandfather's lantern. **Do not let it go out.**

---

## Running it

Double-click `index.html`. That's it — everything is loaded with classic `<script>`
tags precisely so the game works from `file://` without a server.

There is also **`hollowlight-single-file.html`** — the identical game with the CSS and
all seven scripts inlined into one file. Handy for handing in, emailing, or dropping
onto a host that only takes a single page. Rebuild it after any edit with:

```bash
python3 build-single-file.py
```

If you'd rather serve it:

```bash
cd hollowlight
python3 -m http.server 8080     # then open http://localhost:8080
```

Tested in Chromium/Chrome, Firefox and Safari. Needs a keyboard.
Headphones strongly recommended — a lot of the game is information you receive by ear.

---

## Controls

| Key | Action |
| --- | --- |
| `W A S D` / arrows | Move |
| `Shift` | Run — fast, and very loud |
| `Ctrl` | Creep — slow, near-silent |
| `Q` | Hold breath — silent while standing still |
| `E` | Interact |
| `L` | Lantern on / off |
| `F` | Flare (hold) — drives them back, burns oil fast |
| `R` | Recorder — use at a resonance point |
| `Tab` | Field Journal |
| `Esc` | Pause |

Full explanations are on the **How to Play** screen and in the in-game Journal.

---

## The three systems

**Oil.** Your lantern is a clock. Light burns oil, flaring burns it fast, and at zero
the lantern dies. Street lamps refill it, bleed off Dread, and are where the game saves.

**Dread.** Standing in the dark raises it, being hunted raises it, and lamplight lowers it.
Past halfway the picture starts lying to you: chromatic smear, whispers, figures that
aren't there. Let it top out and Grimhollow adds you to its ledger.

**Sound.** The Wick Children are blind and hunt entirely by ear. Running is a shout;
gravel and standing water are worse. Creeping is quiet, and holding your breath while
standing still is silent. A flare drives one off. Nothing in this game kills.

---

## Puzzles

Four, and **every answer is written down somewhere in the world**. Nothing needs guessing,
and every document you read is kept forever in the Journal. If you'd rather not, the
Hint button on each puzzle escalates from method → nudge → answer.

| Puzzle | Where | Its answer lives in |
| --- | --- | --- |
| The Yard Gate | Ch. 1 | the oil return book, ordered by the brass plate |
| Ottoline's Music Box | Ch. 2 | the nursery rhyme, written out in numbers |
| The Sluice Valves | Ch. 3 | the enamel working instructions (a linked-toggle lock) |
| The Seam-Lamps | Ch. 4 | chalk that is only visible under the Echo |

Six chalk **sigils** are hidden across the five chapters, one per chapter and two in
the last. All six unlock the third ending.

---

## Accessibility & comfort

All under **Settings & Accessibility**, none of it a difficulty penalty:

- Master volume, screen brightness, text size, text speed (up to instant)
- **Reduce flashing** — removes lightning strobes and the flare bloom
- **Reduce camera shake** — stops the screen breathing at high Dread
- **Hallucinations off** — high Dread stops spawning figures
- **Audio subtitles** — every significant sound is captioned on screen
- **Mercy mode** — double oil life, half Dread rate, more grab forgiveness. Story and puzzles unchanged.
- **Puzzle hints** — on by default

The interface deliberately uses a high-legibility system sans stack everywhere text
must be *read*. Serif is used only for display titles.

---

## How it's built

```
index.html          markup + all screens
css/game.css        interface
js/audio.js         Web Audio synthesis — every sound in the game
js/lighting.js      2D shadow casting
js/story.js         characters, documents, dialogue, endings
js/world.js         chapter maps, object legends, chapter scripts
js/entities.js      Wick Children AI, particles, actor rendering
js/puzzles.js       the four puzzles
js/game.js          loop, input, rendering pipeline, systems, UI

build-single-file.py            inlines everything into one page
hollowlight-single-file.html    the generated single-page build
```

**Lighting.** Every light builds a *visibility polygon* each frame: cast a ray at every
wall corner (plus a hair either side, which is what snaps shadow edges cleanly past
corners), plus a ring of rays to round off the falloff. Sort the hits by angle and you
have the exact silhouette of everything that light can see. Clip a radial gradient to
that polygon and doorways throw real shafts. Wall geometry is reduced to a minimal
segment set first — colinear runs are merged, so a 40-tile corridor costs 2 segments.

**Render pipeline.** The static layer (floors, walls, ambient occlusion, grime) is
pre-rendered once per chapter to a map-sized offscreen canvas, so surface detail is
free. Actors draw over it. A light buffer is filled with the chapter's ambient
darkness, every light paints additively into it, and the buffer is `multiply`-composited
over the scene. Because multiply can only darken, **all textures and actors are authored
at full brightness** — darkness is the lightmap's job. Emissive things (flames, Ottoline,
the flare) are added afterwards so they survive the multiply.

**Audio.** There are no audio files. The drone is two detuned saws through a breathing
low-pass; the heartbeat is a pitch-swept sine pair whose rate tracks Dread; footsteps are
filtered noise bursts keyed to the surface you're standing on; the whispers are noise
through a band-pass with a wandering formant, which is worse than actual words. The
music box is a sine plus inharmonic partials, struck.

**Wick Children.** They have no sight at all. Their entire world is a per-frame list of
noise events with positions and loudness, and they path with BFS over the tile grid.
That's deliberate: it means you always understand exactly why you were caught, which is
the difference between tense and unfair.

**Maps** are ASCII. An object's position *is* its character's position in the grid, so
no coordinate is ever counted by hand — see the legend at the top of `js/world.js`.

### Debug handle

```js
HOLLOWLIGHT.jump(2)           // load chapter 3
HOLLOWLIGHT.puzzle('valves')  // open a puzzle directly
HOLLOWLIGHT.unlockAll()       // unlock chapter select
HOLLOWLIGHT.state.player.oil  // poke at live state
```

---

## Inspirations, gratefully

The oil that runs out and the sanity that doesn't come back — *Amnesia: The Dark Descent*.
A town that is a confession — *Silent Hill 2*. Light as the only weapon — *Alan Wake*.
Documents that are the real story — *SOMA*, *Gone Home*. The corridor that is never the
same corridor twice — *P.T.* A blind thing that hears you breathe — *Alien: Isolation*.
A recorder that sees the dead — *Fatal Frame*.

## Content notice

Darkness, sustained tension, sudden loud sounds, brief flashing light, and a story about
grief and a drowned child. Every one of those can be reduced or turned off in Settings.
