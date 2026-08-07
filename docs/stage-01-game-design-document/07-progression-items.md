# 07 — Progression, Items & Economy

---

## 7.1 Progression Philosophy

**There is no XP and there are no levels.** Grinding is impossible by construction —
overworld enemies do not respawn, and there are exactly 84 enemy types with finite
placements.

Aven grows along four independent tracks:

| Track | Currency | Source | What it changes |
| --- | --- | --- | --- |
| **The Weave** (skill tree) | **Threads** | Boss resolutions, quest completions, Keepsakes | Skills, passives, tether properties |
| **Capacity** | — | Story milestones only | Self HP, Breath, tether max length |
| **Understanding** | — | Correct UNKNOT diagnoses | Faster resolutions, revealed diagnosis options |
| **Movement** | — | Region-gated upgrades | Overworld traversal, which gates optional content |

**Design intent:** a player who explores thoroughly is meaningfully stronger than one
who rushes — but the strength is *knowledge and options*, not numbers. A rushed
playthrough is harder to survive; it is never *slower*.

---

## 7.2 The Weave — Skill Tree

Three branches, 34 nodes, ~19 obtainable in one playthrough. Threads are scarce
(38 total in a completionist run; nodes cost 1–4). **Respec is free and unlimited** at
any bell — the tree is about expression, not about punishing experimentation.

### Branch: HOLD *(defence, tether control, Strain)*

| Node | Cost | Effect |
| --- | --- | --- |
| Slack Hand | 1 | Strain decay +40% |
| Long Reach | 2 | Tether max length +12 px |
| Second Wind | 2 | First SNAP each encounter deals no damage |
| Deadweight | 2 | PLANT can be held 5s instead of 3s |
| Steady Breath | 1 | Breath regen also occurs during TAUT |
| **Unbroken** | 4 | Tether cannot SNAP below 25% Self HP. *Capstone.* |
| Give | 3 | GUARD now grants Insight ×1.0 instead of ×0.5 |
| Weight Shift | 2 | SWAP cooldown −0.15s |
| Two Hands | 3 | PULL grants 4 i-frames |
| The Knot Holds | 2 | Ward cannot be SLACKed by damage below 12 |

### Branch: READ *(Insight, diagnosis, knowledge)*

| Node | Cost | Effect |
| --- | --- | --- |
| Close Attention | 1 | Insight +15% |
| Nerve | 2 | `danger_mult` window 0.4s → 0.55s |
| Shortlist | 2 | UNKNOT presents one fewer wrong option |
| Cross-Reference | 3 | Journal entries can be submitted as diagnosis evidence |
| Bedside Manner | 2 | Wrong diagnosis costs 25 Insight instead of 40 |
| **Edda's Ear** | 4 | READ reveals the correct diagnosis category (not the answer). *Capstone.* |
| Listen Twice | 2 | SPEAK options refresh once per encounter |
| Cheap Words | 1 | SPEAK-deep costs 10 instead of 15 |
| Familiar | 2 | Enemy families share diagnosis knowledge, not just types |
| Held Question | 3 | Insight persists between encounters in the same room, up to 25 |

### Branch: CARRY *(companions, offence, presence)*

| Node | Cost | Effect |
| --- | --- | --- |
| Shoulder | 1 | Ward HP +30% |
| Two Beats | 2 | ATTUNE costs 45 instead of 60 |
| Reprise | 3 | ATTUNE usable twice per boss encounter |
| Sharpen | 1 | SEVER damage +12% |
| Held Ring | 2 | SEVER timing window +20% |
| **Whole Company** | 4 | Swap companions **mid-encounter**, once. *Capstone. Route-defining.* |
| Handover | 2 | WARD ACT no longer ends on companion SLACK |
| Vouch | 2 | Companion's dialogue interjections unlock 1 extra SPEAK option each |
| Carry Me | 3 | On lethal damage, companion takes it instead (once per encounter, companion SLACKs) |
| Room For One More | 2 | +1 accessory slot |

### Hidden nodes (4, unlocked by action, not Threads)

| Node | Unlock |
| --- | --- |
| **Osk's Filing** | Read all 70 drawers in the Prologue. Journal auto-sorts and gains search. |
| **The Forty-First Part** | Never silence a single Drowned Choir voice. Moth's ATTUNE affects all enemies. |
| **Unpetitioned** | Reach Act III with Wrath ≤ 5. All UNKNOT costs −10. |
| **Still Waiting** | Defeat the First Ward. Tether never SNAPs. Carries to NG+. |

---

## 7.3 Capacity — Story-Gated Growth

| Milestone | Self HP | Breath | Tether max | Accessory slots |
| --- | --- | --- | --- | --- |
| Prologue | 20 | 10 | 64 px | 0 |
| Act I complete | 28 | 14 | 72 px | 1 |
| Act II midpoint | 36 | 18 | 80 px | 1 |
| Act II complete | 44 | 22 | 88 px | 2 |
| Act III midpoint | 52 | 26 | 96 px | 2 |
| Finale | 60 | 30 | 104 px | 3 |

Flat, predictable, and **identical on every route** — so encounter tuning is a single
curve and no route is accidentally easier.

---

## 7.4 Movement Upgrades

Each is a physical object with lore, granted or found, and each retroactively opens
optional content in *earlier* regions (metroidvania-lite backtracking, always optional).

| Upgrade | Where | Traversal verb | Opens |
| --- | --- | --- | --- |
| **Grandfather's Line** | Prologue | Tether-hook to marked anchors across gaps | Baseline |
| **Rope Sense** (Tilly) | Wyndmarrow | Walk rope-bridges and wires | 4 Wyndmarrow rooftops, 2 quests |
| **Root Reading** | Grieving Wood | Dig at trees; read what's buried | 20 trees, 1 door |
| **Held Breath** | Drowned Choir | Underwater traversal, timed | 3 regions' flooded sections |
| **Salt Sight** | Salt Ledger | See strata through the ground | 7 dig sites, 1 door |
| **Loomstep** (Barro) | Verrick | Cross gaps on a woven thread you place | 5 Verrick shafts, 1 door |
| **Attachment** | Orrery | Re-parent an island's gravity | Orrery entirely, 1 door |
| **READ** (Edda) | Commonplace | Sense emotional weight through walls | Every hidden room in the game |
| **The Twelfth Key** | March, Act III | Opens Rue's sealed car | The Undersleep |

**Backtracking is respected:** fast travel bells exist in every region, and the Journal
auto-flags rooms that contain content you couldn't reach with your then-current verbs.
No player should ever have to guess where to re-explore.

---

## 7.5 Item Schema

Every item, without exception, carries:

```
name · type · rarity · stats · description (mechanical) · lore (2–5 lines, in-world voice)
· location · route_availability · sell_value · set_membership
```

**Rarity tiers:** `Common · Kept · Marked · Willed · Unclaimed · Singular`
(named for how objects are inherited in Vesselmere — even the rarity system is worldbuilding).

### Categories & counts

| Category | Count | Notes |
| --- | --- | --- |
| **Weapons** (Aven's SEVER instrument) | 14 | Each changes the SEVER timing ring's *shape*, not just damage |
| **Armour** (Carry-coats) | 12 | Trade Self HP against tether length — a real build choice |
| **Accessories** | 26 | The build system. 1–3 slots. |
| **Relics** | 9 | One per region + Keeping. Passive, powerful, story-bearing. |
| **Consumables** | 22 | 8 are *social* items usable via SPEAK |
| **Key Items** | 18 | |
| **Hidden Items** | 11 | Requires READ or a puzzle |
| **Legendary (Singular)** | 6 | One-of-a-kind, route-exclusive |
| **Keepsakes (collectible)** | 84 | 6 per core region; each is one paragraph of somebody's life |

### Sample entries — the standard of writing expected

> **GUISLEY'S SECOND CASTING** — *Weapon · Willed · SEVER 14, ring: three-beat*
> *Mechanical:* The timing ring rings three times. Hitting all three deals 2.4× damage;
> missing any deals 0.4×. No partial credit.
> *Lore:* "The first casting cracked. He kept it in the shop for forty years so
> apprentices would know that the man who taught them had ruined a bell. This is the
> second. He never rang it. He said a bell you've made is a promise, and he'd already
> broken one."
> *Location:* Wyndmarrow, after *Guisley's Last Casting*, only if Guisley lives.

> **DOV'S SHOPPING LIST** — *Accessory · Singular · +0 to all stats*
> *Mechanical:* While equipped, Aven's death lines are replaced by Barro's. That's all
> it does. It is the most equipped item in playtest.
> *Lore:* "Eggs. The good bread not the other bread. Ask about the thing with the
> hinge. Love you — back by six."
> *Location:* Barro's coat pocket. He will not give it to you. He can leave it for you.

> **THE FORTY-FIRST PART** — *Relic · Singular*
> *Mechanical:* Insight gain +100% while the tether is SLACK. Inverts the core rule.
> *Lore:* "Forty-one seats. Forty singers. They left a part for whoever was coming. No
> one came. They sang the silence anyway, in tempo, for two hundred years, so that when
> someone finally arrived there would be a place already made."
> *Location:* Drowned Choir. Only if zero voices were silenced, on any route.

> **FORM 12-B, UNFILED** — *Key Item · Singular*
> *Lore:* "PETITION OF CONTINUED REGARD. Section 4: On behalf of another? ☒
> Relationship to subject(s): *Captain.* Reason for petition: *[the field is
> filled in and then crossed out, twice, and left blank]*"

---

## 7.6 Economy

- **Currency:** the **Mark** — a stamped ration token. Vesselmere never trusted coins;
  it trusts paperwork.
- **Total income across a completionist run:** ~4,200 Marks. Total cost of all
  purchasable goods: ~6,800. **You cannot buy everything.** Shopping is a choice.
- **No selling exploit:** items sell for 20% and shops have finite stock and finite
  Marks of their own. Merchants can be *bankrupted*, which is a quest.
- **Route-reactive shops:** high Wrath closes three shops permanently; high Compassion
  causes two shopkeepers to give you things and refuse payment, which costs *them*
  something the game later shows you.
- **Cooking** (March hub only): 24 recipes, made from region ingredients, each granting
  a buff *and* a scene. Cooking with a companion present is the primary vehicle for
  companion conversation content — 30 authored cooking scenes.

---

## 7.7 Collectibles & The Journal

| Collectible | Count | Purpose |
| --- | --- | --- |
| **Keepsakes** | 84 | A stranger's life in a paragraph. Plantable in the Grieving Wood, which grows a tree, which is readable. Full set = achievement + Ash Garden flower. |
| **Journal entries** | 120 | Auto-logged. Four sections: *Places · People · Things People Said · Questions*. |
| **Register pages** | 30 | Annike's records. Reading all 30 changes her final scene. |
| **Salt strata** | 18 | The nine-century history, in the wrong order, as a jigsaw. |
| **Choir parts** | 41 | Recordings. Playing all 41 in the March's music car is a puzzle and a superboss clue. |

**The Journal's "Questions" section** is the game's quiet masterstroke: it logs
questions Aven has asked and not yet had answered. It never resolves them for you. A
completionist finishes the game with three questions still open, and they are the right
three.
