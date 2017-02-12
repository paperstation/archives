/obj/machinery/computer/jukebox
	name = "jukebox"
	desc = "It's a jukebox. Aaaaay."
	icon = 'jukebox.dmi'
	icon_state = "jukebox"
	icon_broken = "broken"
	icon_unpowered = "unpowered"
	var/playing = 0
	var/hacked = 0
	var/opened = 0
	var/current_song = null
	var/list/songs = list('badboys.mid', 'entertainer.mid', 'pokerface.mid', 'saints.mid')
	var/list/hacked_songs = list('fartelise.it', 'mozfart.it', 'ode_to_poo.it')

/obj/machinery/computer/jukebox/set_broken()
	src.icon_state = src.icon_broken
	src.stat |= BROKEN

/obj/machinery/computer/jukebox/process()
	if(stat & BROKEN || stat & NOPOWER)
		src.playing = 0
		src.current_song = null
		return

	if(playing)
		var/area/cur_area = src.loc.loc
		if(istype(cur_area) && cur_area.name != "Space")
			cur_area.music = src.current_song


/obj/machinery/computer/jukebox/proc/update_icon()
	src.overlays = null
	if(playing)
		if(hacked)
			src.overlays += icon('jukebox.dmi', "running_hacked")
		else
			src.overlays += icon('jukebox.dmi', "running")
	if(opened)
		src.overlays += icon('jukebox.dmi', "opened")

/obj/machinery/computer/jukebox/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return
	if(istype(user, /mob/living/silicon))
		return src.attack_hand(user)

	if(istype(W, /obj/item/weapon/screwdriver))
		opened = !opened
		user << "You [opened ? "open" : "close"] the front panel."
		update_icon()
	else if (istype(W, /obj/item/weapon/card/cryptographic_sequencer) && !hacked && opened)
		user << "You use [W] on [src]'s control panel."
		src.hacked = 1
		var/obj/effects/sparks/O = new /obj/effects/sparks( src.loc )
		O.amount = 1
		spawn(0)
			O.Life()

/obj/machinery/computer/jukebox/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/power/jukebox/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & BROKEN)
		return

	if(user.a_intent == "hurt")
		if(user.mutations & 16 && prob(50))
			for(var/mob/M in viewers(src, null))
				M.show_message("\red [] hits [src] the wrong way, breaking their hand.")
			M.bruteloss += 10
			return
		else if (istype(user, /mob/living/carbon/human) && user:brainloss >= 60 && prob(50))
			var/mob/living/carbon/human/H = user
			playsound(src.loc, 'Genhit.ogg', 25, 1, -1)
			if(!istype(H.head, /obj/item/clothing/head/helmet))
				for(var/mob/M in viewers(src, null))
					M << "\red [usr] headbutts [src]."
				var/datum/organ/external/affecting = H.organs["head"]
				affecting.take_damage(10, 0)
				H.stunned = 8
				H.weakened = 5
				H.UpdateDamage()
				H.UpdateDamageIcon()
			else
				for(var/mob/M in viewers(src, null))
					M << "\red [usr] headbutts [src]. Good thing they're wearing a helmet."
			return
		else
			if(prob(1) || (src.mutations & 8))
				playsound(src, "shatter", 50, 0)
				for(var/mob/M in viewers(src, null))
					M.show_message("\red [] smashes their fist into [src], destroying it completely."
				M.bruteloss += 5
				new /obj/item/weapon/shard( src.loc )
				var/obj/effects/sparks/O = new /obj/effects/sparks( src.loc )
				spawn(0)
					O.Life()
				set_broken()
				return
			else
				// SHIT GOES HERE, I'LL FINISH LATER