
/obj/item/sticker
	name = "sticker"
	desc = "You stick it on something, then that thing is even better, because it has a little sparkly unicorn stuck to it, or whatever."
	flags = FPRINT | TABLEPASS
	icon = 'icons/misc/stickers.dmi'
	icon_state = "bounds"
	w_class = 1.0
	force = 0
	throwforce = 0
	var/list/random_icons = list()

	New()
		if (islist(src.random_icons) && src.random_icons.len)
			src.icon_state = pick(src.random_icons)
		pixel_y = rand(-8, 8)
		pixel_x = rand(-8, 8)

	afterattack(var/atom/A as mob|obj|turf, var/mob/user as mob, reach, params)
		if (!A)
			return
		if (isarea(A) || istype(A, /obj/item/item_box))
			return
		user.tri_message("<b>[user]</b> sticks [src] to [A]!",\
		user, "You stick [src] to [user == A ? "yourself" : "[A]"]!",\
		A, "[user == A ? "You stick" : "<b>[user]</b> sticks"] [src] to you[user == A ? "rself" : null]!")
		var/image/sticker = image('icons/misc/stickers.dmi', src.icon_state)
		sticker.layer = EFFECTS_LAYER_BASE // I swear to fuckin god stop being under CLOTHES you SHIT
		sticker.icon_state = src.icon_state
		var/pox = src.pixel_x
		var/poy = src.pixel_y
		DEBUG("pox [pox] poy [poy]")
		if (params)
			if (islist(params) && params["icon-y"] && params["icon-x"])
				pox = text2num(params["icon-x"]) - 16 //round(A.bound_width/2)
				poy = text2num(params["icon-y"]) - 16 //round(A.bound_height/2)
				DEBUG("pox [pox] poy [poy]")
		//pox = minmax(-round(A.bound_width/2), pox, round(A.bound_width/2))
		//poy = minmax(-round(A.bound_height/2), pox, round(A.bound_height/2))
		sticker.pixel_x = pox
		sticker.pixel_y = poy
		A.UpdateOverlays(sticker, "sticker[world.timeofday]")
		qdel(src)

	attack()
		return

/obj/item/sticker/gold_star
	name = "gold star sticker"
	desc = "For when you wanna show someone that they've really accomplished something great."
	icon_state = "gold_star"

/obj/item/sticker/banana
	name = "banana sticker"
	desc = "Wait, can't you just buy your own?"
	icon_state = "banana"
	random_icons = list("banana", "bananas")

/obj/item/sticker/clover
	name = "clover sticker"
	icon_state = "clover"

/obj/item/sticker/umbrella
	name = "umbrella sticker"
	icon_state = "umbrella"

/obj/item/sticker/skull
	name = "skull sticker"
	icon_state = "skull"

/obj/item/sticker/no
	name = "\"no\" sticker"
	icon_state = "no"

/obj/item/sticker/left_arrow
	name = "left arrow sticker"
	icon_state = "Larrow"

/obj/item/sticker/right_arrow
	name = "right arrow sticker"
	icon_state = "Rarrow"

/obj/item/sticker/heart
	name = "heart sticker"
	icon_state = "heart"
	random_icons = list("heart", "rheart")

/obj/item/sticker/moon
	name = "moon sticker"
	icon_state = "moon"

/obj/item/sticker/smile
	name = "smile sticker"
	icon_state = "smile"
	random_icons = list("smile", "smile2")

/obj/item/sticker/frown
	name = "frown sticker"
	icon_state = "frown"
	random_icons = list("frown", "frown2")

/obj/item/sticker/balloon
	name = "red balloon sticker"
	icon_state = "balloon"

/obj/item/sticker/rainbow
	name = "rainbow sticker"
	icon_state = "rainbow"

/obj/item/sticker/horseshoe
	name = "horseshoe sticker"
	icon_state = "horseshoe"

/obj/item/sticker/ribbon
	name = "award ribbon"
	desc = "You're an award winner! You came in, uh... Well it looks like this doesn't say what place you came in, or what it's for. That's weird. But hey, it's an award for something! Maybe it was for being the #1 Farter, or maybe the #8 Ukelele Soloist. Truly, with an award as vague as this, you could be anything!"
	icon_state = "no_place"
	var/placement = "Award-Winning"

	afterattack(var/atom/A as mob|obj|turf, var/mob/user as mob)
		..()
		if (!A)
			return
		if (!src.placement)
			return
		A.name_prefix(src.placement)
		A.UpdateName()
		qdel(src)

	first_place
		name = "\improper 1st place award ribbon"
		desc = "You're an award winner! First place! For what? Doesn't matter! You're #1! Woo!"
		icon_state = "1st_place"
		placement = "1st-Place"

	second_place
		name = "\improper 2nd place award ribbon"
		desc = "It's like you intend to be a disappointment and a failure. Were you even trying at all?"
		icon_state = "2nd_place"
		placement = "2nd-Place"

	third_place
		name = "\improper 3rd place award ribbon"
		desc = "Not best, not second best, but still worth mentioning, kinda. That's you! Congrats!"
		icon_state = "3rd_place"
		placement = "3rd-Place"

	participant
		name = "participation ribbon"
		desc = "You showed up, which is really the hardest part. With accreditations like this award ribbon, you've proven you can do anything."
		placement = "Participant"
