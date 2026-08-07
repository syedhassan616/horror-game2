# 17 — Production Plan & Risk Register

---

## 17.1 Team

| Role | FTE | Primary ownership |
| --- | --- | --- |
| Creative Director | 1.0 | Pillars, tone, final calls, cross-discipline coherence |
| Lead Game Designer | 1.0 | Combat, progression, encounter tuning, difficulty curve |
| Narrative Director | 1.0 | Story Bible, all dialogue, character arcs, the Voice System |
| Senior Gameplay Programmer | 1.0 | Weave, bullet system, save/state, tooling |
| Gameplay Programmer | 1.0 | UI, dialogue runner, quests, accessibility |
| Combat Designer | 0.5 | Bullet patterns, boss phases, frame data |
| Pixel Artist (lead) | 1.0 | Characters, portraits, bosses |
| Pixel Artist (environment) | 1.0 | Tilesets, lighting passes, weather |
| Composer | 0.5 | 34 tracks, stem architecture |
| Sound Designer | 0.5 | ~900 SFX, mixing, reactive audio |
| UI/UX Designer | 0.5 | 13 screens, accessibility, onboarding |
| QA Lead | 0.5 | The eight QA tools, route proving, playtest programme |
| **Total** | **9.5 FTE** | over **18 months** |

Contract as needed: localisation (10 languages), additional QA in months 15–18,
platform port engineering (post-launch).

---

## 17.2 Schedule

| Phase | Months | Milestone gate |
| --- | --- | --- |
| **Pre-production** | 1–3 | Stages 2–11 documentation complete. **Vertical slice:** Wyndmarrow + the Tally, fully lit, fully scored, all five companion tether modes prototyped. **Gate: is the tether fun for 30 minutes?** If no, the project stops here. |
| **Production A — systems** | 4–7 | All 10 autoloads, weave system final, dialogue compiler + all 8 QA tools shipped. Enemy families 1–5. Regions 00–03 content-complete. |
| **Production B — content** | 8–13 | Regions 04–11. All 84 enemies. All 10 major bosses. 35 quests. First full-route playable. |
| **Production C — routes & secrets** | 14–15 | Act III wings, 5 endings, epilogue modules, superboss chain, NG+. **Content lock at month 15.** |
| **Alpha** | 16 | Feature-complete, all content in, known bugs tracked. External playtest #3. |
| **Beta / polish** | 17 | Bug fix, tuning, accessibility audit, localisation integration, perf pass |
| **Certification & launch** | 18 | Platform cert, marketing beats, day-one patch prep |

**Playtest programme:** 6 external rounds (months 3, 7, 10, 13, 16, 17), 12–20 players
each, at least 4 of whom in each round have **never played an RPG with a dodge phase**,
and at least 2 of whom use an accessibility feature as a daily necessity, not a test.

---

## 17.3 Milestone Definitions of Done

| Milestone | Done means |
| --- | --- |
| **Vertical slice** | 30 minutes, 60 FPS on a Steam Deck, one boss with both finishers, one region fully lit and scored, one companion per tether mode playable, one failable quest |
| **Alpha** | Every region walkable, every boss beatable both ways, all 5 endings reachable, Route Prover green, Flag Audit green |
| **Content lock** | No new rooms, quests, enemies, or words. Bug fixes and tuning only. |
| **Beta** | Zero P1 bugs, zero unfair deaths in the log, all accessibility features verified by external testers, all 10 localisations integrated |
| **Gold** | Perf Sentinel green on reference hardware for 100% of scenes; save migration verified across all patch versions |

---

## 17.4 Risk Register

| # | Risk | Likelihood | Impact | Mitigation |
| --- | --- | --- | --- | --- |
| R1 | **The tether isn't fun.** The entire game rests on one unproven mechanic. | Medium | **Fatal** | Vertical slice at month 3 is an explicit go/no-go gate. Prototype the tether in month 1, before any art or writing. If it fails, the project pivots or stops — not renegotiates. |
| R2 | **96,000 words is a novel.** Narrative is the critical path. | High | High | Narrative Director starts in month 1 on Stage 2. Dialogue compiler and coverage tooling ship in Production A so writing is never blocked on engineering. Word budget reviewed monthly with a hard per-region cap. |
| R3 | **Act III route-exclusive regions are a 35% content multiplier.** Classic scope killer. | High | High | Wings are deliberately *small* (5 rooms each) and reuse tilesets with new lighting and props. Cut order pre-agreed: DRIFT wing merges into the Undersleep before anything else is cut. |
| R4 | **2,000 bullets in GDScript.** | Medium | High | Flat-array bullet system built and benchmarked in month 2, before content depends on it. GDExtension fallback path scoped but not built. |
| R5 | **The Slack Tether set piece is unreadable** — players think it's a bug. | Medium | Medium | Playtest at round 2 with explicit instrumentation. The HUD `— NOBODY —` label and the audio SNAP exist specifically to make it legible as *authored*. |
| R6 | **Superboss chain is too obscure and nobody finds it** — or too obvious and it's not special. | Medium | Medium | Chain steps are individually satisfying content (each is a real quest). Playtest rounds 4–6 measure discovery rate; target 3–6% unaided within launch month, ~40% within 6 months via community. |
| R7 | **Music-as-consequence is expensive** — 180 stems and a permanence contract. | Medium | Medium | Stem architecture locked in Stage 8 before a note is written. Composer scores to the stem map, not to picture. |
| R8 | **Accessibility CARRY ME mode is treated as a late feature and ships badly.** | Medium | High | Built in Production A alongside the weave system, not after. It is a QA gate at every milestone, not a beta task. |
| R9 | **Tone failure** — the game reads as misery, or the comedy undercuts the grief. | Medium | High | Tone rules in §01.5 are review criteria, not guidance. Every region gets a "does the comedy hold the weight?" review with the full team. |
| R10 | **Undertale comparison dominates discourse** and the game is read as derivative. | High | Medium | Marketing leads with the tether and the two-body dodge in every asset. The originality table (docs/README) is public-facing. Press demo is the Slack Tether, which has no analogue. |
| R11 | **Localisation of Moth** breaks the quotation system. | Medium | Medium | Dialogue compiler links Moth lines to source lines at data level from day one (§15.7). Loc leads are briefed in month 3, not month 15. |
| R12 | **Save migration** breaks long-running replays post-launch. | Low | High | Versioned migrations from the first commit (§14.4.5). CI tests a 1.0 save through every subsequent version. |

---

## 17.5 Cut Order (agreed in advance)

If the schedule slips, this is the order in which content is cut. Agreeing it now
prevents the worst outcome: cutting whatever is most convenient in month 16.

1. NG+ exclusive region wing (*Archive of Refusals*) → defer to a free post-launch patch
2. DRIFT route's Act III wing → merges into the Undersleep
3. 6 optional puzzles, 9 Keepsakes
4. Optional boss **The Unread** → becomes a mini-boss
5. Cooking scenes 20–30 → reduce to 20
6. Region: **The Ash Garden** shrinks from 10 rooms to 6

**Never cut, under any circumstances:**
- Any of the 5 endings
- The superboss and its chain
- Any accessibility feature
- The music-permanence contract
- The Slack Tether set piece
- Any of the nine failable quests

These are the things the game is *for*. A smaller SECONDHEART that keeps them is a
better game than a bigger one that doesn't.

---

## 17.6 Success Criteria

| Metric | Target |
| --- | --- |
| Steam review score at 3 months | ≥ 95% positive |
| Median completion rate (any ending) | ≥ 55% (genre median ~30%) |
| Players reaching ≥2 endings | ≥ 25% |
| Superboss discovery within 6 months | ≥ 40% of completers |
| "Was the Assayer wrong?" survey split | 40–60% either way, ≥8% "I don't know" |
| Accessibility-mode completion rate | Within 10 points of default |
| Frame rate complaints | < 0.5% of reviews |
| Award consideration | IGF Grand Prize / Excellence in Narrative submissions; TGA Best Indie |

---

## 17.7 What Happens After Stage 1 Approval

Stages 2–11 run **in parallel where they can and in sequence where they must**:

```
Stage 2  Story Bible ─────────────┐
Stage 3  World Bible ─────────────┤
Stage 4  Character Bible ─────────┼──► Stage 6 Quest DB ──► Stage 7 Dialogue DB
Stage 5  Combat Systems ──────────┤                              │
Stage 8  Music Bible ─────────────┤                              │
Stage 9  Art Bible ───────────────┘                              │
Stage 10 Programming Architecture ───► Stage 11 Folder Structure ─┴──► Stage 12 Implementation
```

Stages 2, 3, and 4 are tightly coupled and should be reviewed together.
Stage 5 can begin immediately and independently — and **should**, because R1 says the
tether prototype is the thing that decides whether any of the rest is worth writing.
