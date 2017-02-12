/*
CONTAINS:
MATCHES
MATCHBOXES
CIGARETTES
CIG PACKET
ZIPPO
*/

///////////
//MATCHES//
///////////

/obj/item/weapon/match/process()
	while(src.lit == 1)
		src.smoketime--
		sleep(10)
		if(src.smoketime < 1)
			src.icon_state = "match_burnt"
			src.lit = -1
			return

/obj/item/weapon/match/dropped(mob/user as mob)
	if(src.lit == 1)
		src.lit = -1
		src.damtype = "brute"
		src.icon_state = "match_burnt"
		src.item_state = "cigoff"
		src.name = "Burnt match"
		src.desc = "A match that has been burnt"
		return ..()


/obj/item/weapon/storage/cigars
	name = "Cigar Box"
	desc = "A box full of cigars."
	icon = 'storage.dmi'
	icon_state = "cigarbox"
	can_hold = list("/obj/item/weapon/paper/rolling_paper")

/obj/item/weapon/storage/cigars/New()
	..()
	new /obj/item/clothing/mask/cigarette/cigar/cohiba( src )
	new /obj/item/clothing/mask/cigarette/cigar/cohiba( src )
	new /obj/item/clothing/mask/cigarette/cigar/cohiba( src )
	new /obj/item/clothing/mask/cigarette/cigar/havana( src )
	new /obj/item/clothing/mask/cigarette/cigar/havana( src )
	new /obj/item/clothing/mask/cigarette/cigar( src )
	new /obj/item/clothing/mask/cigarette/cigar( src )

/obj/item/weapon/storage/rollingpapers
	name = "Rolling Papers"
	desc = "A packet of rolling papers."
	icon = 'storage.dmi'
	icon_state = "rollingpapers"
	can_hold = list("/obj/item/weapon/paper/rolling_paper")

/obj/item/weapon/storage/rollingpapers/New()
	..()
	new /obj/item/weapon/paper/rolling_paper( src )
	new /obj/item/weapon/paper/rolling_paper( src )
	new /obj/item/weapon/paper/rolling_paper( src )
	new /obj/item/weapon/paper/rolling_paper( src )
	new /obj/item/weapon/paper/rolling_paper( src )
	new /obj/item/weapon/paper/rolling_paper( src )
	new /obj/item/weapon/paper/rolling_paper( src )

//matchboxes
/obj/item/weapon/storage/matchbox
	name = "matchbox"
	desc = "A box of matches."
	icon = 'storage.dmi'
	icon_state = "matchbox"
	can_hold = list("/obj/item/weapon/match")

/obj/item/weapon/storage/matchbox/New()
	..()
	new /obj/item/weapon/match( src )
	new /obj/item/weapon/match( src )
	new /obj/item/weapon/match( src )
	new /obj/item/weapon/match( src )
	new /obj/item/weapon/match( src )
	new /obj/item/weapon/match( src )
	new /obj/item/weapon/match( src )

/obj/item/weapon/storage/matchbox/attackby(obj/item/weapon/match/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/match) && W.lit == 0)
		W.lit = 1
		W.icon_state = "match_lit"
		W.process()
	W.update_icon()
	return

//cigboxes
/obj/item/weapon/storage/cigpack
	name = "Cigarette packet"
	desc = "A packet of cigarettes."
	icon = 'storage.dmi'
	icon_state = "cigpacket"
	can_hold = list("/obj/item/clothing/mask/cigarette")

/obj/item/weapon/storage/cigpack/New()
	..()
	new /obj/item/clothing/mask/cigarette( src )
	new /obj/item/clothing/mask/cigarette( src )
	new /obj/item/clothing/mask/cigarette( src )
	new /obj/item/clothing/mask/cigarette( src )
	new /obj/item/clothing/mask/cigarette( src )
	new /obj/item/clothing/mask/cigarette( src )
	new /obj/item/clothing/mask/cigarette( src )

//////////////
//CIGARETTES//
//////////////

/obj/item/clothing/mask/cigarette/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool)  && W:welding)
		if(src.lit == 0)
			src.lit = 1
			src.damtype = "fire"
			src.icon_state = "[icon_on]"
			src.item_state = "[icon_on]"
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] casually lights the [] with []. What a badass.", user.name, src.name, W.name), 1)
			score_cigssmoked++
			spawn() //start fires while it's lit
				src.process()
	else if(istype(W, /obj/item/weapon/zippo) && W:lit)
		if(src.lit == 0)
			src.lit = 1
			src.icon_state = "[icon_on]"
			src.item_state = "[icon_on]"
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red With a single flick of their wrist, [] smoothly lights their [] with their []. Damn they're cool.", user.name, src.name, W.name), 1)
			score_cigssmoked++
			spawn() //start fires while it's lit
				src.process()
	else if(istype(W, /obj/item/weapon/match) && W:lit)
		if(src.lit == 0)
			src.lit = 1
			src.icon_state = "[icon_on]"
			src.item_state = "[icon_on]"
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red With a single flick of their wrist, [] calmly lights their [] with their []. Damn they're cheap.", user.name, src.name, W.name), 1)
			score_cigssmoked++
			spawn() //start fires while it's lit
				src.process()
	if(istype(W, /obj/item/device/igniter))
		if(src.lit == 0)
			src.lit = 1
			src.damtype = "fire"
			src.icon_state = "[icon_on]"
			src.item_state = "[icon_on]"
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] plainly lights the [] with []. How exciting.", user.name, src.name, W.name), 1)
			for(var/mob/living/carbon/human/M in viewers(src, null))
				M.emote("yawn")
			score_cigssmoked++
			spawn() //start fires while it's lit
				src.process()


/obj/item/clothing/mask/cigarette/process()

	var/atom/lastHolder = null
	var/pufftimer = 50
	while(src.lit == 1)
		var/turf/location = src.loc
		var/atom/holder = loc
		var/isHeld = 0
		var/mob/M = null

		smoketime--

		if(istype(location, /mob/))
			M = location
			if(M.l_hand == src || M.r_hand == src || M.wear_mask == src)
				location = M.loc
		if(pufftimer == 50)
			M << "\blue You take a puff of the [name]."
			if(reagents)
				reagents.copy_to(M, 3)
			pufftimer--
			if(pufftimer == 0)
				pufftimer = 50
		if(src.smoketime < 1)
			var/obj/item/weapon/cigbutt/C = new /obj/item/weapon/cigbutt
			if(M != null)
				M << "\red Your [name] goes out."
				score_cigssmoked += 1
			C.icon_state = "[icon_butt]"
			C.loc = location
			del(src)
			return
		if (istype(location, /turf)) //start a fire if possible
			location.hotspot_expose(700, 5)
		if (ismob(holder))
			isHeld = 1
		else




			// note remove luminosity processing until can understand how to make this compatible
			// with the fire checks, etc.

			isHeld = 0
			if (lastHolder != null)
				//lastHolder.ul_SetLuminosity(0)
				lastHolder = null

		if (isHeld == 1)
			//if (holder != lastHolder && lastHolder != null)
				//lastHolder.ul_SetLuminosity(0)
			//holder.ul_SetLuminosity(1)
			lastHolder = holder

		//ul_SetLuminosity(1)
		sleep(10)

	if (lastHolder != null)
		//lastHolder.ul_SetLuminosity(0)
		lastHolder = null

	//ul_SetLuminosity(0)


/obj/item/clothing/mask/cigarette/dropped(mob/user as mob)
	if(src.lit == 1)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] calmly drops and treads on the lit cigarette, putting it out instantly.", user), 1)
		src.lit = -1
		src.damtype = "brute"
		src.icon_state = "[icon_butt]"
		src.item_state = "[icon_off]"
		src.name = "Cigarette butt"
		src.desc = "A cigarette butt."
		return ..()
	else
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] drops the []. Guess they've had enough for the day.", user, src), 1)
		return ..()

/////////
//ZIPPO//
/////////
#define ZIPPO_LUM 2

/obj/item/weapon/zippo/attack_self(mob/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!src.lit)
			src.lit = 1
			src.icon_state = "zippoon"
			src.item_state = "zippoon"
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red Without even breaking stride, [] flips open and lights the [] in one smooth movement.", user, src), 1)

			//user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)
			user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)
			spawn(0)
				process()
		else
			src.lit = 0
			src.icon_state = "zippo"
			src.item_state = "zippo"
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red You hear a quiet click, as [] shuts off the [] without even looking what they're doing. Wow.", user, src), 1)

			//user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
			user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
	else
		return ..()
	return


/obj/item/weapon/zippo/process()

	while(src.lit)
		var/turf/location = src.loc

		if(istype(location, /mob/))
			var/mob/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = M.loc
		if (istype(location, /turf))
			location.hotspot_expose(700, 5)
		sleep(10)


/obj/item/weapon/zippo/pickup(mob/user)
	if(lit)
		//src.ul_SetLuminosity(0)
		//user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)
		src.ul_SetLuminosity(0)
		user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)



/obj/item/weapon/zippo/dropped(mob/user)
	if(lit)
		//user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
		//src.ul_SetLuminosity(ZIPPO_LUM)
		user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
		src.ul_SetLuminosity(ZIPPO_LUM)