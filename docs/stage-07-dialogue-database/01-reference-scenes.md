# 01 — Reference Scenes

**These are the standard.** Every writer on the project reads these before drafting. They
are not samples — they are the shipping text for their scenes, and they define the
register, density, and restraint expected everywhere else.

---

## R1 · S-006 — THE SENTENCE *(Prologue, mandatory)*

The game's thesis, in ninety seconds, before the player has the vocabulary.

```
@node osk_the_sentence
  @once
  @cue audio.duck_all(36)          # 0.6s — the severance sound is a silence

  OSK [busy] "— so what I'll do is, I'll take the 4-C, which is for a person in stock,
             and I'll cross-reference it against a 9, which is for stock that's got no
             bearer, and honestly nobody's ever needed both at once so I'll be inventing
             a bit of it, which, between us, is the best part of the —"

  @cue sever.world(osk)            # posture improves. No music. No camera move.
  @cue tether.slack()              # HUD reads — NOBODY — for the first time

  OSK [neutral] "— which is the best part of the job. Sorry. Where was I."

  @write flag:osk_severed
  @goto osk_after_free

@node osk_after_free
  @severed
  @choice
    -> WARM    "You loved her."                    @goto osk_r_warm
    -> BLUNT   "They just took her out of you."    @goto osk_r_blunt
    -> CAREFUL "Do you want to sit down?"          @goto osk_r_careful
    -> QUIET   "..."                               @goto osk_r_quiet
    -> WRY     "...Right. Two r's."                @goto osk_r_wry

@node osk_r_warm
  @severed
  OSK "I did! That's right." [BEAT] "Is that on the form?"
  @goto osk_after_free

@node osk_r_blunt
  @severed
  OSK [helpful] "Took what, sorry?"
  @goto osk_after_free

@node osk_r_careful
  @severed
  OSK "I've got aisle nine hundred to do."
  @goto osk_after_free

@node osk_r_quiet
  @severed
  [BEAT]
  [BEAT]
  OSK "Right." [BEAT] "Well — I'll get on."
  @goto osk_after_free

@node osk_r_wry
  @severed
  OSK [pleased] "Thank you. You're a great help."
  @goto osk_after_free
```

**Why it works.** Osk never expresses a preference, a longing, or a regret after the cue —
only facts, habits, and courtesy. He is *more* efficient. The player has five options and
all five are useless, and the game does not tell them so.

---

## R2 · S-226 — DOV SAYS NO *(Act II, Choice B)*

The game's most-cited scene in playtest projections.

```
@node dov_asked
  @require flag:barro_asks_dov
  @once

  BARRO [hopeful] "It's — right. So. It's finished. Three years. Eleven eyelets, all
                  hand-set, and I know that doesn't mean anything to you but it's —"
  BARRO [BEAT] "It's finished."

  DOV [warm] "It's beautiful."
  DOV "I can see that it's beautiful. I want you to know I can see that."
  DOV [BEAT] "I can't want it."

  BARRO "You haven't —"
  [INTERRUPT] DOV "I've tried. Since you asked. I've been trying for two days, which is
                  the most I've thought about anything in four years, and I want you to
                  have that, because it's true."
  DOV "There's nowhere in me for it to go."

  BARRO [flat] "It'd give you the —"
  DOV [BEAT] "It'd give *you* the —"
  DOV [BEAT]                                    # he stops. He isn't cruel.

  @write flag:dov_refused
  @write eight.compassion += 2
  @goto barro_burns_it

@node barro_burns_it
  @cue anim.barro_burn                          # 40 seconds. No music. No dialogue.
  @cue music.stop_all()

  BARRO [neutral] "Right."
  @goto barro_eleven_minutes                    # he is fine for eleven minutes of play
```

**The rule this demonstrates:** *never undercut a landing.* Barro is fine. He makes three
jokes in the next eleven minutes, all of them good. Then he asks Aven a question and the
player gets four tones and none of them help.

---

## R3 · S-325 — RUE'S PETITION *(Act III, Choice C)*

The only scene where Rue answers an emotional question with something other than logistics.

```
@node rue_petition
  @require flag:read_form_12b
  @once

  RUE [flat] "I filed it in the autumn."

  @choice
    -> BLUNT   "You did this."           @goto rue_p_blunt
    -> CAREFUL "Tell me what you asked for."  @goto rue_p_careful
    -> QUIET   "..."                     @goto rue_p_quiet
    -> WARM    "You're dying."           @goto rue_p_warm   @require flag:ottoline_letter_read

@node rue_p_blunt
  RUE "I asked for one thing. I asked that when I go, my crew doesn't stop."
  RUE "Four hundred people at Alder Stand. Every one of them fine at the end of it. And
      I have watched what a crew does when the captain —"
  RUE [BEAT]                              # the only time she loses the thread
  RUE "I did the arithmetic and I got a number and the number was worth it."

  @choice
    -> CAREFUL "What number?"             @goto rue_p_number
    -> BLUNT   "It wasn't yours to do."   @goto rue_p_wasnt
    -> QUIET   "..."                      @goto rue_p_number

@node rue_p_number
  RUE "Eleven." [BEAT] "Eleven people I'd have taken with me."
  RUE [BEAT] "It's given them everybody. I know."
  @write flag:rue_confessed
  @goto choice_c
```

**Note the structure:** Rue never apologises, never asks forgiveness, and never says *I
didn't know* — because she did know, from Act II, and kept moving. The `[BEAT]` before
*"I did the arithmetic"* is the whole performance.

---

## R4 · S-405 — WHAT IT SAYS *(Finale)*

The Assayer's case. It must be *good*, because it is.

```
@node assayer_case
  @once
  @cue music.none()

  ASSAYER "Ninety thousand. That is the figure for the six years after the Rot, and it
          is not an estimate; I have the returns."
  ASSAYER "They were not killed by the plague. They were killed by continuing to carry
          people who had stopped existing."
  ASSAYER "Grief is the interest on love. I have been forgiving the debt."

  @choice
    -> BLUNT   "You didn't ask them."     @goto assayer_ask
    -> CAREFUL "Who asked you to?"        @goto assayer_who
    -> WRY     "You've got a figure for everything."  @goto assayer_figure
    -> QUIET   "..."                      @goto assayer_generalise

@node assayer_generalise
  ASSAYER "You have been told I am generalising. I am. That is what precedent is."
  ASSAYER "Nine reasonable people asked me nine reasonable questions and I answered all
          of them consistently, and consistency is the only virtue I was given."
  ASSAYER [BEAT]
  ASSAYER "If you would like me to stop, you will need to file something. I cannot simply
          decide."
  ASSAYER "Neither could he."
  @goto assayer_revelation
```

**Register discipline:** no *kill, take, remove, hurt, help, save, mercy,* or *sorry*
anywhere in the Assayer's 7,000 words. Its cruellest lines are its most procedural.

---

## R5 · MOTH — quotation rendering

```
@node moth_first_meeting
  @once

  @quote osk
  MOTH "— you're not stock. You're *in* stock."

  @quote pell
  MOTH "Who gave you this?"

  @quote nell                          # a voice the player has not heard and will not
  MOTH "I'll be an hour."              # place for six hours (F17)

  @choice
    -> CAREFUL "Who was that last one?"   @goto moth_doesnt_know
    -> BLUNT   "Stop doing that."         @goto moth_stops_briefly
    -> QUIET   "..."                      @goto moth_waits
```

Each `@quote` sets the *Hand* font, the small-caps attribution, **and the babble profile of
the quoted speaker** — the player hears the attribution before reading it.

**Moth's first original line**, in the Keeping, drops all of it:

```
@node moth_authored
  @require flag:entry_two_opened
  @once
  MOTH [own_voice] "I was there too."
```

---

## R6 · TILLY — the omission *(S-371, the funeral)*

```
@node funeral_count
  @once

  BOY_WITH_LADDER "...and that's — " [BEAT] "That's the count."
                                      # he reads it one short

  @cue camera.hold()                  # no push-in. The camera does not know.
  @cue tilly.portrait(listening)

  [BEAT]
  [BEAT]
  [BEAT]

  @write flag:tilly_let_it_be_wrong
  @goto funeral_after
```

**Her entire arc resolves in three `[BEAT]`s and no dialogue.** She does not correct him.
That is the scene. Any draft that gives her a line here is rejected.
