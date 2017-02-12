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
	var/list/songs = list('')
	var/list/hacked_songs = list('')

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


/obj/machinery/power/jukebox/New()
