# 04 — Relationship Matrix & Memory System

---

## 4.1 The Full Relationship Matrix

Rows = who holds the feeling. Columns = about whom.
**C** carries a Ward for · **c** did carry, now severed · **▲** protects · **▼** resents ·
**◆** professional obligation · **?** unresolved · **~** mutual unease

| | Aven | Tilly | Moth | Barro | Sennet | Rue | Vellum | Annike | Edda | Cantor | Merit | 1st Ward |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Aven** | — | ▲ | ▲? | ▲ | ▲ | ~ | ? | ▼? | ▲ | — | **C** | ? |
| **Tilly** | ▲▼ | — | ~ | — | — | ▼ | — | ▼ | — | — | — | — |
| **Moth** | ▲ | ~ | — | — | — | — | — | — | ~ | — | — | **?!** |
| **Barro** | ▲ | — | — | — | — | ◆ | ▼ | — | — | — | — | — |
| **Sennet** | ▲ | — | — | — | — | — | — | — | — | ▲▼ | — | — |
| **Rue** | ~ | ▲ | — | — | — | — | — | ◆ | — | — | ▼ | — |
| **Vellum** | **C** *(fight 4)* | — | ? | ◆ | — | ◆ | — | ◆ | — | ◆ | ◆ | — |
| **Annike** | ~ | — | — | — | — | ◆ | ◆ | — | — | ▼ | — | — |
| **Edda** | ▲ | — | ~ | — | — | — | — | — | — | — | ▼? | — |
| **Cantor** | ▼ | — | — | — | ▲ | — | ▼ | ▼ | — | — | ▼ | ? |
| **Merit** | ? | — | — | — | — | — | — | — | — | — | — | ▲ |

**Off-matrix but load-bearing:**
- Tilly **c** Odile · Halden **c** Odile · Barro **c** Dov · Osk **c** Marren
- Nell **C** Corrin *(Entry 1 → the First Ward)*
- Merit **c** Ilsabet · Merit **c** Corrin *(both severed by Merit's own hand or machine)*
- Ottoline ▲ Rue *(one-way, and she knows it's one-way)*

**The single most important cell:** `Aven → Merit = C`. Aven has carried Merit's heart
since before the game started and does not learn it until hour six. Every tether the
player has drawn for six hours has had Merit's colour in it (F02).

---

## 4.2 The Memory System

Every named NPC is an `NPCProfile` (GDD §14.4.4) carrying:

```gdscript
memory_flags       : Dictionary   # {&"saw_aven_sever": 3, &"was_helped": true, ...}
topic_memory       : Array        # last N topics, per-speaker
conversation_stage : int          # 0..n, monotonically advancing
reading_bias       : Dictionary   # weights over the Eight
hearsay_delay      : int          # regions of lag before news reaches them
severance_state    : enum         # whole / severed / synthetic
```

### Greeting selection

```gdscript
func select_greeting(npc, state) -> DialogueRef:
    var reading := npc.read_player(state.eight)        # "warm" / "wary" / "afraid" / ...
    var seen    := npc.memory_flags                     # personal, outweighs statistics
    var heard   := hearsay_for(npc.region, state)       # delayed by travel
    var stage   := npc.conversation_stage
    return npc.greetings.best_match(reading, seen, heard, stage)
```

**Three properties this produces, all deliberate:**

1. **Different NPCs read the same Aven differently in the same room.** Guisley weights
   Resolve and finds a high-Wrath Aven impressive. Tilly weights Mercy and is frightened
   of that same Aven, in that same scene.
2. **Hearsay propagates on a weighted region graph.** Kill someone in Verrick and the
   Salt Ledger does not know yet. **The March has weight 0** — it moves; it hears first.
   Players who exploit this (do the bad thing last) are being smart, not cheating.
3. **Personal memory beats statistics.** An NPC who *saw* one merciful act weights it
   above a hundred hidden points. This is what stops the system feeling like a
   spreadsheet: relationships are anecdotal.

### Hearsay graph

```
        MAR (weight 0 — always current)
       ╱  │  ╲
   WYN(1) VRK(1) SLT(2)
     │      │      │
   GRV(2) CHR(2) ORR(3)
     │             │
   HSH(3)        CMN(3)
                   │
                 ASH(4)
```
Weight = regions of lag. A deed in Wyndmarrow is unknown in Hushfell for 3 region
transitions.

---

## 4.3 Conversation Stages

**Nobody repeats a barked line.** Every NPC has ≥3 authored stages, advancing on:
- Act transitions
- Their own quest's state changes
- World-state bands (Bell Count, voices silenced, companion roster)
- `topic_memory` — asking about the same thing twice gets *"You asked me that"* content,
  authored per NPC, never a generic system line

**Stage exhaustion is authored, not blocked.** When an NPC runs out, they get a
**final-stage idle** — a single line that is in character and clearly terminal. Pell's is
*"I've told you everything I've got and half of what I haven't."*

---

## 4.4 Companion Interjections

Companions speak **during other people's scenes**. This is the game's primary vehicle for
making the party feel alive without cutscenes.

| Trigger | Example |
| --- | --- |
| NPC states a fact the companion knows is wrong | Tilly corrects a bell fact, out loud, in front of the bell-founder |
| Topic touches the companion's history | Barro goes quiet when severance is discussed casually |
| Player picks a tone the companion dislikes | Rue, after a BLUNT choice: *"…Right. Well. That's one way."* |
| Player picks a tone the companion likes | Sennet, after CAREFUL: nothing — he just stays in frame a beat longer |
| The scene mentions someone dead | Moth quotes them |

**Budget:** ~340 interjections. **Vouch** (skill node) adds one extra SPEAK option per
companion per encounter, sourced from these.

---

## 4.5 What Changes at 65% Tone Drift

Two NPCs change `reading_bias` permanently at 65% drift, and they are chosen to be
uncomfortable:

- **Guisley** (weights Resolve ×1.6) — a BLUNT Aven becomes someone he respects, and he
  offers the forge, and the superboss chain opens through approval the player may not
  have wanted.
- **Tilly** (weights Mercy ×1.8, Wrath ×−2.0) — a high-Wrath Aven she still follows,
  because she has nowhere else, and her interjections get shorter, and she stops
  correcting people.

**She stops correcting people.** That is the whole signal. It is never stated.

---

## 4.6 Open Items Closed From Stage 2 §13.7

| Item | Resolution |
| --- | --- |
| **Sennet's pre-choir life** | Joined at 19 by choice, for reasons he can no longer reconstruct. Best ear, least conviction. Full dossier §01. |
| **The Cantor's real name** | Exists; spoken **once**, on a Keeping inscription (KEP-01), never aloud. Stage 7 assigns the string. |
| **Ottoline's letter** | Drafted below. |
| **Tilly's rope arrangement** | Three-rope differential with a counterweighted sallie, allowing one ringer to strike two bells ~0.4s apart. **Requires a consultant sign-off before Stage 9 art.** Flagged as an open production dependency. |
| **Aven's three thematic lines** | Deferred to last, per §03.5.5. Locked out of Stage 7's first pass by design. |

### Ottoline's letter (draft, 41 words)

> *Captain —*
>
> *I've done the rota for the spring and I've done it two ways. One of them has you in it.*
>
> *I'm not asking you to tell me. I'm asking you to know that I've done it two ways.*
>
> *— Ottoline*

**Delivering it** gets her thanked and reassigned to the front car. Kindness as exile.
Rue does it without a flicker, and it is one of the cruellest things she does, and it is
entirely in character.
