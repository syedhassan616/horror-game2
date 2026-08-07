# SECONDHEART — Prologue: The Unclaimed
# Story Bible §04. Scene IDs map to S-001..S-009.
#
# Writing rules enforced here:
#   - Osk never stops working during a scene.
#   - After the severance he may express facts, habits and courtesy. Never a
#     preference, a longing, or a regret. He is not sad. He is gone.
#   - No character states a theme.

# ─────────────────────────────────────────────────────────── S-003 first contact

@node osk_first
  @once
  OSK [busy] "Oh, marvellous. Marvellous. Stand still a moment — no, turn — right. Right. You're not stock."
  OSK "You're *in* stock. You're not *of* stock. Do you see the distinction? It's a lovely one. I've got a form for it and I've never once used it."
  @choice
    -> WRY "Congratulations." osk_r_wry
    -> CAREFUL "Should I be somewhere else?" osk_r_careful
    -> BLUNT "Where am I?" osk_r_blunt
    -> QUIET "..." osk_r_quiet

@node osk_r_wry
  OSK "Don't. I've had nineteen years of my own jokes and they've all landed better than that."
  @goto osk_catalogue

@node osk_r_careful
  OSK "You should be *catalogued*, is what you should be."
  @goto osk_catalogue

@node osk_r_blunt
  OSK "The Unclaimed. Aisle nine hundred, which is where we put the ones nobody came back for."
  OSK [BEAT] "That's not a comment on you. It's a shelf."
  @goto osk_catalogue

@node osk_r_quiet
  OSK [BEAT] "Mm. Well. You'll talk when you've something worth the air."
  @goto osk_catalogue

@node osk_catalogue
  OSK "Come on. Bring the drawer number, there's a good — no, leave the drawer. Just the number."
  @write flag:met_osk
  @end

# ───────────────────────────────────────────────────── S-004 the thing about Marren
# The line the Commonplace memory puzzle asks about, six hours later. Logged,
# never highlighted.

@node osk_marren
  @require flag:met_osk
  @once
  OSK "Eleven years. Everyone gets very careful around you, after. They talk to you like you're a shelf that might come down."
  OSK "The trick is jobs. Small ones, back to back, with a next one. You'll notice I've re-shelved this aisle three times."
  OSK [BEAT] "I'm aware it's three times."
  @choice
    -> WARM "Who was she?" osk_who
    -> BLUNT "Why not have it taken out?" osk_why_not
    -> CAREFUL "Does it help? The jobs." osk_why_not
    -> QUIET "..." osk_why_not

@node osk_who
  OSK "Marren. She had a *cruel* laugh. Marvellous woman."
  OSK "She'd have found the re-shelving very funny. She'd have counted."
  @goto osk_why_not

@node osk_why_not
  OSK "Because then I'd have eleven years of a very nice woman and no idea why I kept them."
  OSK [BEAT] "You want to know the honest answer? It hurts in the mornings and I've got nothing else of hers."
  @write flag:heard_osk_mornings
  @end

# ───────────────────────────────────────────────────────────── S-005 the fight

@node filing_error_intro
  @once
  OSK "Ah — that'll be aisle nine oh two. It's been going for a week."
  OSK "Here — take Marren a minute. She's very good in a crisis. Was. Is. The grammar gets away from you."
  @cue tether.grant_marren
  @end

@node filing_error_snap
  OSK "Ah — don't stretch her. She'll go. She always went."
  @end

@node filing_error_unknot
  @once
  OSK "Well now. Look at that."
  OSK "It didn't want stopping. It wanted *filing*. There's a difference and nobody ever asks."
  @write flag:unknotted_first
  @end

@node filing_error_sever
  @once
  OSK [BEAT] "Right."
  OSK "I'll pick those up."
  @write flag:severed_first
  @end

# ───────────────────────────────────────────── S-006 THE SENTENCE (the thesis)
# 90 seconds. No music. No camera move. The audio ducks completely for 36 frames.

@node osk_the_sentence
  @once
  OSK [busy] "— so what I'll do is, I'll take the 4-C, which is for a person in stock, and I'll cross-reference it against a 9, which is for stock that's got no bearer,"
  OSK "and honestly nobody's ever needed both at once so I'll be inventing a bit of it, which, between us, is the best part of the —"
  @cue sever.world
  OSK [neutral] "— which is the best part of the job. Sorry. Where was I."
  @write flag:osk_severed
  @goto osk_after

@node osk_after
  @choice
    -> WARM "You loved her." osk_a_warm
    -> BLUNT "They just took her out of you." osk_a_blunt
    -> CAREFUL "Do you want to sit down?" osk_a_careful
    -> QUIET "..." osk_a_quiet
    -> WRY "...Right. Two r's." osk_a_wry

@node osk_a_warm
  OSK "I did! That's right."
  OSK [BEAT] "Is that on the form?"
  @goto osk_after

@node osk_a_blunt
  OSK [helpful] "Took what, sorry?"
  @goto osk_after

@node osk_a_careful
  OSK "I've got aisle nine hundred to do."
  @goto osk_after

@node osk_a_quiet
  [BEAT]
  OSK "Right."
  OSK "Well — I'll get on."
  @goto osk_after

@node osk_a_wry
  OSK [pleased] "Thank you. You're a great help."
  @goto osk_after

# ─────────────────────────────────────────────────────────── S-009 the requisition

@node osk_requisition
  @require flag:osk_severed
  @once
  OSK "Right — an unclaimed heart should be walked up to the Registry, and that's Wyndmarrow, and that's two days on the north stair."
  OSK "Take the slip. They'll know what it is even if I don't."
  OSK [BEAT] "And listen — whoever you've got in there. Don't stretch them."
  @write flag:has_requisition
  @end

# ─────────────────────────────────────────────────────────────── drawers (S-002)

@node drawer_generic
  AVEN [listening] "A drawer. A card. Two lines of somebody."
  @end

@node drawer_ilsabet
  @once
  AVEN [listening] "ENTRY 12 — ILSABET VANE. Bearer deceased Year 3, Rot. Carried: her husband."
  AVEN "Husband declined collection. Husband's stated reason: \"I'd only lose it again.\""
  @write flag:read_ilsabet
  @end

@node drawer_reserved
  @once
  AVEN [listening] "ENTRY 1,441 — RESERVED. Do not shelve. Do not return. Do not open before instruction."
  AVEN [BEAT] "— M.V., Year 6."
  @write flag:read_reserved
  @end
