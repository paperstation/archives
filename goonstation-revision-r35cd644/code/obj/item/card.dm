/*
CONTAINS:
DATA CARD
EMAG
ID CARD
GAUNTLET CARDS
*/

/obj/item/card
	name = "card"
	icon = 'icons/obj/card.dmi'
	icon_state = "id"
	wear_image_icon = 'icons/mob/mob.dmi'
	w_class = 1.0
	burn_type = 1
	stamina_damage = 1
	stamina_cost = 1
	var/list/files = list("tools" = 1)
	module_research_type = /obj/item/card

/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	layer = 6.0 // TODO fix layer
	is_syndicate = 1
	mats = 8
	module_research = list("malfunction" = 25)
	module_research_type = /obj/item/card/emag

	afterattack(var/atom/A, var/mob/user)
		if(!A || !user)
			return
		A.emag_act(user, src)

	attack()	//Fucking attack messages up in this joint.
		return

/obj/item/card/emag/fake
//delicious fake emag
	attack_hand(mob/user as mob)
		boutput(user, "<span class='combat'>Turns out that card was actually a kind of [pick("deadly chameleon","spiny anteater","sex toy that George Melons likes to use","Syndicate Top Trumps Card","bag of neckbeard shavings")] in disguise! It stabs you!</span>")
		user.paralysis = 8
		spawn(10)
			var/obj/storage/closet/C = new/obj/storage/closet(get_turf(user))
			user.set_loc(C)
			C.layer = OBJ_LAYER
			C.name = "an ordinary closet"
			C.desc = "What? It's just an ordinary closet."
			C.welded = 1

// ID CARDS

/obj/item/card/id
	name = "identification card"
	icon_state = "id"
	item_state = "card-id"
	desc = "A standardized NanoTrasen Identification Card. Ties into many systems station-wide."
	var/access = list()
	var/registered = null
	var/assignment = null
	var/title = null
	var/emagged = 0

	// YOU START WITH  NO  CREDITS
	// WOW
	var/money = 0.0
	var/pin = 0000

	//It's a..smart card.  Sure.
	var/datum/computer/file/cardfile = null
	desc = "An microchipped identification card that contains data that is scanned when attempting to access various doors and computers on the station."

	proc/update_name()
		name = "[src.registered]'s ID Card ([src.assignment])"

/obj/item/card/id/New()
	..()
	src.pin = rand(1000,9999)

/obj/item/card/id/command
	icon_state = "id_com"

/obj/item/card/id/security
	icon_state = "id_sec"

/obj/item/card/id/research
	icon_state = "id_res"

/obj/item/card/id/engineering
	icon_state = "id_eng"

/obj/item/card/id/civilian
	icon_state = "id_civ"

/obj/item/card/id/clown
	icon_state = "id_clown"
	desc = "Wait, this isn't even an ID Card. It's a piece of a Chips Ahoy wrapper with crayon scribbles on it. What the fuck?"

/obj/item/card/id/gold
	name = "identification card"
	icon_state = "gold"
	item_state = "gold_id"
	desc = "This card is important!"

/obj/item/card/id/blank_deluxe
	name = "Deluxe ID"
	icon_state = "gold"
	item_state = "gold_id"
	registered = "Member"
	assignment = "Member"

/obj/item/card/id/captains_spare
	name = "Captain's spare ID"
	icon_state = "gold"
	item_state = "gold_id"
	registered = "Captain"
	assignment = "Captain"
	New()
		access = get_access("Captain")
		..()

/obj/item/card/id/captains_spare/explosive
	pickup(mob/user)
		boutput(user, "<span style=\"color:red\">The ID-Card explodes.</span>")
		user.transforming = 1
		var/obj/overlay/O = new/obj/overlay(get_turf(user))
		O.anchored = 1
		O.name = "Explosion"
		O.layer = NOLIGHT_EFFECTS_LAYER_BASE
		O.pixel_x = -17
		O.icon = 'icons/effects/hugeexplosion.dmi'
		O.icon_state = "explosion"
		spawn(35) qdel(O)
		spawn(5) user.gib()

/obj/item/card/id/attack_self(mob/user as mob)
	user.visible_message("[user] shows you: [bicon(src)] [src.name]: assignment: [src.assignment]", "You show off your card: [bicon(src)] [src.name]: assignment: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/card/id/emag_act(var/mob/user, var/obj/item/card/emag/E)
	if (src.emagged)
		if (user && E)
			user.show_text("You run [E] over [src], but nothing seems to happen.", "red")
		return
	src.access = list() // clear what used to be there
	var/list/all_accesses = get_all_accesses()
	for (var/i = rand(2,25), i > 0, i--)
		var/new_access = pick(all_accesses)
		src.access += new_access
		all_accesses -= new_access
		if (istype(src, /obj/item/card/id/syndicate)) // Nuke ops unable to exit their station (Convair880).
			src.access += access_syndicate_shuttle
		DEBUG("[get_access_desc(new_access)] added to [src]")
	src.emagged = 1

/obj/item/card/id/verb/read()
	set src in usr

	boutput(usr, "[bicon(src)] [src.name]: The current assignment on the card is [src.assignment].")
	return

/obj/item/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate_shuttle)

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered)
		var/reg = copytext(src.sanitize_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name)), 1, 100)
		var/ass = copytext(src.sanitize_name(input(user, "What occupation would you like to put on this card?\n Note: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Staff Assistant"), 1), 1, 100)
		var/color = input(user, "What color should the ID's color band be?\nClick cancel to abort the forging process.") as null|anything in list("blue","red","green","purple","yellow","No band")
		switch (color)
			if ("No band")
				src.icon_state = "id"
			if ("blue")
				src.icon_state = "id_civ"
			if ("red")
				src.icon_state = "id_sec"
			if ("green")
				src.icon_state = "id_com"
			if ("purple")
				src.icon_state = "id_res"
			if ("yellow")
				src.icon_state = "id_eng"
			else
				return // Abort process.
		src.registered = reg
		src.assignment = ass
		src.name = "[src.registered]'s ID Card ([src.assignment])"
		boutput(user, "<span style=\"color:blue\">You successfully forge the ID card.</span>")
	else
		..()

/obj/item/card/id/syndicate/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/sourceCard = W
	if (istype(sourceCard))
		boutput(user, "You copy [sourceCard]'s accesses to [src].")
		src.access |= sourceCard.access
	else
		return ..()

/obj/item/card/id/syndicate/proc/sanitize_name(var/input, var/strip_bad_stuff_only = 0)
	input = strip_html(input, MAX_MESSAGE_LEN, 1)
	if (strip_bad_stuff_only)
		return input
	var/list/namecheck = dd_text2list(trim(input), " ")
	for(var/i = 1, i <= namecheck.len, i++)
		namecheck[i] = capitalize(namecheck[i])
	input = dd_list2text(namecheck, " ")
	return input

/obj/item/card/id/temporary
	name = "temporary identification card"
	icon_state = "id"
	item_state = "card-id"
	desc = "A temporary NanoTrasen Identification Card. Its access will be revoked once it expires."
	var/duration = 60 //seconds
	var/starting_access = list()
	var/timer = 0 //if 1, description shows time remaining
	var/end_time = 0

/obj/item/card/id/temporary/New()
	..()
	spawn(0) //to give time for duration and starting access to be set
		starting_access = access
		end_time = ticker.round_elapsed_ticks + duration*10
		spawn(duration * 10)
			if(access == starting_access) //don't delete access if it's modified with an ID computer
				access = list()

/obj/item/card/id/temporary/examine()
	..()
	if(usr.client && src.timer)
		boutput(usr, "A small display in the corner reads: \"Time remaining: [max(0,round((end_time-ticker.round_elapsed_ticks)/10))] seconds.\"")

/obj/item/card/id/gauntlet
	icon = 'icons/effects/VR.dmi'
	icon_state = "id_clown"
	New(var/L, var/mob/user)
		..()
		if (!user)
			registered = "???"
			assignment = "unknown phantom entity (no.. mob? this is awkward)"
		if (istype(user, /mob/living/carbon/human/virtual))
			var/mob/living/LI = user:body
			if (LI)
				registered = LI.real_name
			else
				registered = user.real_name
		else
			registered = user.real_name

		if (!user.client)
			assignment = "literal meat shield (no client)"
		else
			assignment = "loading arena matches..."
			tag = "gauntlet-id-[user.client.key]"
			queryGauntletMatches(1, user.client.key)
		name = "[registered]'s ID Card ([assignment])"

	proc/SetMatchCount(var/matches)
		switch (matches)
			if (-INFINITY to 0)
				icon_state = "id_clown"
				assignment = "Gauntlet Newbie ([matches] rounds played)"
			if (1 to 10)
				icon_state = "id_civ"
				assignment = "Rookie Gladiator ([matches] rounds played)"
			if (11 to 20)
				icon_state = "id_res"
				assignment = "Beginner Gladiator ([matches] rounds played)"
			if (21 to 35)
				icon_state = "id_eng"
				assignment = "Skilled Gladiator ([matches] rounds played)"
			if (36 to 55)
				icon_state = "id_sec"
				assignment = "Advanced Gladiator ([matches] rounds played)"
			if (56 to 75)
				icon_state = "id_com"
				assignment = "Expert Gladiator ([matches] rounds played)"
			if (76 to INFINITY)
				icon_state = "gold"
				assignment = "Legendary Gladiator ([matches] rounds played)"
			else
				assignment = "what the fuck ([matches] rounds played)"
		name = "[registered]'s ID Card ([assignment])"
