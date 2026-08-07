# 05 — Core Combat: The Tether

> Full formulas, per-enemy stat blocks, frame data and pattern libraries are
> **Stage 5 (Combat Systems)**. This chapter is the complete mechanical specification
> of the core loop — enough to prototype from directly.

---

## 5.1 The One-Sentence Design

> **You pilot two linked bodies through bullet-hell, and the *line between them* is the
> tool that turns incoming violence into the resource for peace.**

Everything below is that sentence, elaborated.

---

## 5.2 The Encounter Shape

An encounter alternates two modes, as a turn-based RPG does — but the defensive half is
a full action-game phase, and both halves feed each other.

```
┌────────────────────────────────────────────────────────────────────┐
│  COMMAND PHASE  (paused, menu)                                     │
│  Aven chooses one: SEVER · GUARD · SKILL · ITEM · SPEAK · UNKNOT   │
│                    · WARD ACT · ATTUNE                             │
│                            │                                       │
│                            ▼                                       │
│  RESOLVE  → damage / dialogue / effect / diagnosis                  │
│                            │                                       │
│                            ▼                                       │
│  WEAVE PHASE  (real-time, 60 FPS, 6–14 seconds)                    │
│  Enemy attacks. You dodge with Self, position Ward, sweep tether.   │
│  Tether contacts generate INSIGHT. Overuse generates STRAIN.        │
│                            │                                       │
│                            └───────► back to COMMAND               │
└────────────────────────────────────────────────────────────────────┘
```

**Why this beats "menu then dodge":** in most games the dodge phase is a tax you pay
between decisions. Here the dodge phase is where you **earn the currency for your best
decisions**. The player who dodges conservatively can only afford violence. The player
who dodges *greedily* can afford peace. The morality of the game is priced in
mechanical risk.

---

## 5.3 The Weave Field

- **Arena:** a bounded field, default 320×180 px logical (16:9), scaling per boss.
  Bosses reshape, rotate, split, and occasionally *remove* the field.
- **Self:** 6×6 px hitbox, 4×4 px true collision core (visible as a bright pip — the
  hitbox is always honestly displayed). Speed 84 px/s, 168 px/s with `RUN` held.
- **Ward:** 8×8 px, behaviour per companion. Follows Self with a damped spring by
  default (stiffness `k=14`, damping `c=0.55`, max length `L=64 px`).
- **Tether:** a rendered line with **6 sample points**. Each sample point is a
  contact sensor of radius 3 px. The tether is *not* a solid — bullets pass through
  it and are **read**, not blocked (except under ANCHOR).

### Tether states

| State | Trigger | Effect |
| --- | --- | --- |
| `SLACK` | length < 40% max | No Insight gain. Ward drifts lazily. |
| `LIVE` | 40–90% max | Normal Insight gain. **The intended operating band.** |
| `TAUT` | 90–100% max | Insight ×1.6, Strain accrual ×2.0, visible tension shimmer + rising audio |
| `STRAINED` | Strain ≥ 70 | Tether reddens, contact radius −50%, Self takes 1 chip damage/sec |
| `SNAPPED` | Strain = 100 | Tether breaks for 3.0s. No Insight. Ward is inert. Both take 8 damage. Audio: a rope-and-heartbeat sound designed to be hated. |
| `SEVERED` | Scripted / boss mechanic | Companion is *gone*. Permanent for the encounter or the game. |

---

## 5.4 The Five Verbs of the Weave Phase

Every verb is bindable to a single button and works on a Steam Deck. This is the whole
action-game vocabulary — deliberately small, deliberately deep.

| Verb | Default (KB / Pad) | Description | Cooldown |
| --- | --- | --- | --- |
| **MOVE** | WASD / Left stick | Move Self. Ward follows by spring. | — |
| **SWAP** | Space / A | Instantly exchange Self and Ward positions. **6 i-frames.** The core dodge. | 0.9s |
| **PULL** | Shift / RB | Ward snaps to Self over 0.15s. Collapses the tether; used to reposition, escape TAUT, or reset. | 1.2s |
| **PLANT** | Ctrl / LB | Ward stops dead in world space; tether becomes rigid. Self can now orbit a fixed pivot. | Hold, 3s max |
| **SWEEP** | (emergent) | Not a button — the act of moving Self so the tether arcs through fire. The skill expression. | — |

**SWAP is the game's signature input.** It is a dodge, a traversal move, a positional
reset, and a rhythm. It must be ≤2 frames from input to visible response, always. It is
the one thing QA measures every build.

**The learning curve, deliberately staged:**
1. *Hours 0–0.5:* players move Self and ignore Ward. Survivable.
2. *Hour 0.5–1:* SWAP is taught as an escape. Players use it panically.
3. *Hour 1–2:* players discover SWAP *through* a bullet wall is faster than going around.
4. *Hour 2+:* players start deliberately positioning Ward *before* an attack so the
   post-SWAP position is safe. This is the moment the game clicks, and every boss from
   Act II assumes it.
5. *Hour 4+:* **tether-first play** — you stop thinking about where Self is and start
   thinking about where the *line* is.

---

## 5.5 INSIGHT — the pacifist currency

**Gain.** Each tether sample point that overlaps a hostile projectile grants Insight:

```
insight_gain = base(projectile) × tether_state_mult × companion_mult × danger_mult
```

| Factor | Values |
| --- | --- |
| `base` | 1 (pellet) · 3 (bolt) · 6 (beam tick) · 10 (special) |
| `tether_state_mult` | SLACK 0 · LIVE 1.0 · TAUT 1.6 · STRAINED 0.5 |
| `companion_mult` | Tilly 0.5 · Moth 2.0 · Barro 1.5 (threads) · Sennet 1.0 · Rue 1.0 (×3 in the *unsafe* lane) |
| `danger_mult` | ×1 normally, **×2 if the projectile would have hit Self within 0.4s** |

That last multiplier is the whole design. **You are rewarded for reading the tether
through the shot that was about to kill you.** Peace costs nerve.

**Cap.** Insight caps at 100 and does not persist between encounters. There is no
grinding it.

**Spend.**

| Spend | Cost | Effect |
| --- | --- | --- |
| **UNKNOT** (correct) | 40 | Resolves the enemy non-violently |
| **UNKNOT** (wrong diagnosis) | 40, lost | Enemy escalates one phase. Never softlocks — but it hurts. |
| **SPEAK → deep option** | 15 | Unlocks dialogue that reveals the enemy's knot |
| **ATTUNE** | 60 | Companion special (§5.8) |
| **MEND** | 25 | Clears Strain, restores 10 HP to Self |

---

## 5.6 STRAIN — the counterweight

Without a counterweight, the optimal play is "hold TAUT forever." Strain prevents this.

```
strain_per_sec = (tether_length_pct − 0.75) × 34   [only above 75% length]
               + insight_gained_this_sec × 0.6
               − companion_strain_resist
strain_decay   = 12/sec while tether is SLACK or LIVE and no Insight gained
```

Strain is displayed as a **thin line along the tether itself**, not a HUD bar — the
player reads their own risk by looking at the thing they're already looking at. UI
teaching rule: *never put critical combat information outside the play field.*

**The rhythm this produces:** greed → tension → deliberate release. Players learn to
farm hard for two seconds, then PULL and breathe. It is the same rhythm as the game's
themes: hold on, let go, hold on.

---

## 5.7 The Command Phase — Eight Verbs

| Verb | Function |
| --- | --- |
| **SEVER** | Attack. A timed-input ring (one press, precision-scaled damage). Always available, always effective. **Named to indict the player.** |
| **GUARD** | Halve incoming damage next Weave; +40% Strain resist; Insight gain ×0.5. The coward's tax. |
| **SKILL** | Aven's learned abilities (§07 skill tree). Costs **Breath** (Aven's MP). |
| **ITEM** | Consumables. One per turn. Some items are *social* (offering food is a legitimate combat action). |
| **SPEAK** | Free. 3–5 context options per enemy. **This is where diagnosis evidence comes from.** Not a repeated "act" — the option list shrinks as you exhaust it, and enemies react to *tone* (§06). |
| **UNKNOT** | Non-violent resolution. Costs 40 Insight. Opens a **diagnosis menu**. |
| **WARD ACT** | The companion's own action — unique per companion, changes their tether behaviour for one Weave phase |
| **ATTUNE** | 60 Insight. Companion special. Once per encounter. |

### UNKNOT in detail — the anti-spam design

When you UNKNOT, the game asks: *"What is it holding?"* and presents 4–6 options drawn
from a global pool, seeded by the evidence you have actually gathered.

- Evidence comes from: SPEAK options, the enemy's attack patterns (a creature that
  guards one corner of the arena is protecting something), overworld props, Journal
  entries, and Edda's **READ** ability.
- A **correct** diagnosis ends the fight with a short authored scene. Not a fade-out:
  every UNKNOT has bespoke text.
- A **wrong** diagnosis costs the Insight, escalates the enemy's phase, and — crucially —
  **removes that option from the list**, so brute force is possible but expensive and
  narratively acknowledged. The enemy says something about being misunderstood.
- Repeat encounters with the same enemy *type* remember your correct diagnosis: the
  second Filing Error you meet can be Unknotted in one action. **Knowledge is the
  progression system for the pacifist route** — not stats.

**This is the single most important system in the game.** It makes the peaceful route a
game of attention and comprehension rather than a game of patience.

---

## 5.8 Companions as Movement Verbs

| Companion | Tether physic | WARD ACT | ATTUNE (60 Insight) |
| --- | --- | --- | --- |
| **Tilly — ANCHOR** | Rigid rod, mass ×3, PLANT creates a solid blocking line | *Hold the Line* — blocking line persists 3s after unplant | **Full Peal** — every bell-tone in the arena rings; all projectiles slow 60% for 2.5s |
| **Moth — GHOST** | No collision, phases through geometry, Insight ×2 | *Borrowed* — Moth mimics the last enemy attack pattern back at the enemy, harmlessly, which several enemies find upsetting enough to stop | **Everyone At Once** — Moth speaks in 40 voices; enemy's next diagnosis option is revealed outright |
| **Barro — LOOM** | Persistent 4s thread trail; closed loops apply BOUND | *Reinforce* — next loop closed lasts 12s instead of 6s | **Forty-One Days** — weaves a temporary synthetic Ward: a second tether, player-controlled, for 8 seconds. The showpiece. |
| **Sennet — CURRENT** | Tether pushes projectiles aside instead of absorbing (deflect, not delete) | *Undertow* — reverses push direction | **Held Breath** — the arena floods; everything, including you, moves at 40% speed for 6s. Pure skill-expression tool. |
| **Rue — SIGNAL** | Paints safe lanes 1.5s ahead; unsafe-side Insight ×3 | *Reroute* — repaints the lane once, mid-volley | **Never Once Stopped** — Self cannot be stopped, staggered, or slowed for 10s and leaves an afterimage that also reads bullets |

**The design consequence:** swapping companions is not a stat change, it is **a
different game**. A player who has mastered Moth and is forced to fight with Tilly is a
beginner again for ninety seconds. Act II's Slack Tether weaponises this.

**Companion availability is route-driven.** In some routes you lose Moth permanently in
Act II. The game does not replace the ability. You play the rest of the game without it.

---

## 5.9 Damage, Health & Failure

| Stat | Notes |
| --- | --- |
| **Self HP** | Starts 20, tops out ~60. Deliberately low — 3–5 hits kills at any point in the game. |
| **Ward HP** | Companion-specific. Ward at 0 does not die — it goes `SLACK` for 8 seconds. |
| **Breath** | Aven's skill resource. Regenerates 1/sec while tether is LIVE. |
| **Defence** | Flat reduction, capped at 60%. Equipment matters but never trivialises. |

**On death:** the game returns you to the Command Phase of the current encounter, with
a short, *character-specific* line from your companion. Not a game-over screen — your
companion catching you. This is used ~40 times across a playthrough and each line is
authored per companion per act (5 companions × 4 acts × 3 variants = 60 lines).

**No permadeath, no lost progress, no punishment loop.** Difficulty comes from the
encounter, never from re-traversal.

---

## 5.10 Difficulty Options (§13 for full accessibility)

| Mode | Bullet speed | Self hitbox | Insight rate | Notes |
| --- | --- | --- | --- | --- |
| **Steady** | 80% | 150% | 130% | Recommended for story players |
| **True** | 100% | 100% | 100% | Default |
| **Taut** | 115% | 85% | 100% | Extra patterns on every boss |
| **The Long Quiet** | 130% | 70% | 90% | NG+ only. Bosses gain a 6th phase. |
| **Carry Me** *(accessibility)* | Dodging automated | — | Auto-earned | **All content, all endings, all bosses reachable.** Not "easy mode" — a different input contract. |

Difficulty is changeable **at any time from the pause menu**, mid-fight, with no
penalty, no achievement lockout, and no comment from the game. QA gate: no achievement,
ending, or secret is gated on difficulty.

---

## 5.11 Feel Specification (the 60 FPS contract)

Non-negotiable, verified per build on reference hardware:

| Property | Target |
| --- | --- |
| Frame rate during Weave | 60 FPS locked, 0 dropped frames over a 60s boss phase |
| SWAP input → first response frame | ≤ 2 frames (33ms) |
| SWAP i-frames | 6 frames, visible as a hard white flash — the player must always know if they got the dodge |
| Hitstop on SEVER | 4 frames on hit, 7 on a perfect ring |
| Screen shake | Amplitude ≤ 3px, always disableable, never during a dodge-critical pattern |
| Bullet spawn telegraph | Minimum 12 frames of visible tell before any lethal projectile |
| Audio latency | ≤ 20ms; every bullet spawn has a positioned sound (blind-playable patterns are a stated goal) |
| Colour-independence | Every projectile type distinguishable by **shape and motion**, not colour alone |

**The tell rule:** if a player dies and cannot name the tell they missed, the pattern is
a bug. QA logs "unfair deaths" as P1 defects, not balance feedback.
