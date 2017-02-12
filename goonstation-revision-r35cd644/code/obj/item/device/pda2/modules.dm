//CONTENTS
//Module base.
//Flashlight module.
//T-ray scanner module.
//Computer 3 Emulator / Associated Bits

/obj/item/device/pda_module
	name = "PDA module"
	desc = "A piece of expansion circuitry for PDAs."
	icon = 'icons/obj/module.dmi'
	icon_state = "pdamod"
	w_class = 2.0
	mats = 4.0
	var/obj/item/device/pda2/host = null

	var/setup_use_menu_badge = 0  //Should we have a line in the main menu?
	var/setup_allow_os_config = 0 //Do we support a big config page?

	New()
		..()
		if(istype(src.loc, /obj/item/device/pda2))
			src.host = src.loc
			src.loc:module = src
		return

	Topic(href, href_list)
		if(!src.host || src.loc != src.host)
			return 1

		if ((!usr.contents.Find(src.host) && (!in_range(src.host, usr) || !istype(src.host.loc, /turf))) && (!istype(usr, /mob/living/silicon)))
			return 1

		if(usr.stat || usr.restrained())
			return 1

		src.host.add_fingerprint(usr)
		return 0

	disposing()
		host = null
		..()

	proc
		//Return string as part of PDA main menu, ie easy way to toggle a function.  One line!!
		return_menu_badge()
			return null

		relay_pickup(mob/user as mob)
			return

		relay_drop(mob/user as mob)
			return

		install(var/obj/item/device/pda2/pda)
			if(pda)
				pda.module = src
				src.host = pda
			return

		uninstall()
			if(src.host)
				src.host.module = null
				src.host = null
			return

/obj/item/device/pda_module/flashlight
	name = "flashlight module"
	desc = "A flashlight module for a PDA."
	icon_state = "pdamod_light"
	setup_use_menu_badge = 1
	var/on = 0 //Are we currently on?
	var/lumlevel = 0.5 //How bright are we?
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(lumlevel)
		light.set_color(1, 1, 1)

	relay_pickup(mob/user)
		..()
		light.attach(user)

	relay_drop(mob/user)
		..()
		spawn(0)
			if (src.host.loc != user)
				light.attach(src.host.loc)

	high_power
		name = "high-power flashlight module"
		lumlevel = 1

	return_menu_badge()
		var/text = "<a href='byond://?src=\ref[src];toggle=1'>[src.on ? "Disable" : "Enable"] Flashlight</a>"
		return text

	install(var/obj/item/device/pda2/pda)
		..()
		light.attach(pda)

	uninstall()
		light.disable()
		src.on = 0
		..()

	Topic(href, href_list)
		if(..())
			return

		if(href_list["toggle"])
			src.on = !src.on
			if (ismob(src.host.loc))
				light.attach(src.host.loc)
			if (src.on)
				light.enable()
			else
				light.disable()

		src.host.updateSelfDialog()
		return

/obj/item/device/pda_module/tray
	name = "t-ray scanner module"
	desc = "A terahertz-ray emitter and scanner built into a handy PDA module."
	icon_state = "pdamod_tscanner"
	setup_use_menu_badge = 1
	var/on = 0

	return_menu_badge()
		var/text = "<a href='byond://?src=\ref[src];toggle=1'>[src.on ? "Disable" : "Enable"] T-Scanner</a>"
		return text

	Topic(href, href_list)
		if(..())
			return

		if(href_list["toggle"])

			src.on = !src.on

			if(src.on && !(src in processing_items))
				processing_items.Add(src)

		src.host.updateSelfDialog()
		return

	uninstall()
		..()
		src.on = 0
		return

	process()
		if(!src.on || !src.host)
			processing_items.Remove(src)
			return

		for(var/turf/T in range(1, src.host.loc) )

			if(!T.intact)
				continue

			for(var/obj/O in T.contents)

				if(O.level != 1)
					continue

				if(O.invisibility == 101)
					O.invisibility = 0
					spawn(10)
						if(O)
							var/turf/U = O.loc
							if(!istype(U))
								return
							if(U.intact)
								O.invisibility = 101

			var/mob/living/M = locate() in T
			if(M && M.invisibility == 2)
				M.invisibility = 0
				spawn(2)
					if(M)
						M.invisibility = 2