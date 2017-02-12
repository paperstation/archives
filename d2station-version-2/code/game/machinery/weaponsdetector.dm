obj/machinery/weapon_sensor
	icon = 'stationobjs.dmi'
	icon_state = "weaponsdetect0"
	name = "Dangerous Item detector"

	anchored = 1
	var/state = 0

	var/id_tag
	var/frequency = 1439

/area/science/weaponscanner/
	var/clear = 1

/proc/lockdown()
	var/lockdown = 0
	if(lockdown == 1)
		return
	for(var/obj/machinery/door/airlock/glass/M in oview(20,src))
		if (M.id_tag == "wepout")
			M.locked = 0
			M.icon_state = "door_closed"


/proc/endlockdown()
	var/endlockdown = 0
	if(endlockdown == 1)
		return
	for(var/obj/machinery/door/airlock/glass/M in oview(20,src))
		if (M.id_tag == "wepout")
			M.locked = 1
			M.icon_state = "door_locked"



/area/science/weaponscanner/Entered(atom/movable/M as mob|obj)
	..()
	var/wep = 0
	if (istype(M, /obj/item/weapon/gun))
		if (clear == 0)
			return
		lockdown()
		clear = 0
	for (var/atom/O in M.contents) //I'm pretty sure this accounts for the maximum amount of container in container stacking. --NeoFite
		if (istype(O, /obj/item/weapon/storage) || istype(O, /obj/item/weapon/gift))
			for (var/obj/OO in O.contents)
				if (istype(OO, /obj/item/weapon/storage) || istype(OO, /obj/item/weapon/gift))
					for (var/obj/OOO in OO.contents)
						if (istype(OOO, /obj/item/weapon/gun))
							wep = 1
				if (istype(OO, /obj/item/weapon/gun))
					wep = 1
		if (istype(O, /obj/item/weapon/gun))
			wep = 1
		if (istype(O, /mob))
			var/mob/MM = O
			if(MM.check_contents_for(/obj/item/weapon/gun))
				wep = 1
	if (wep)
		if (clear == 0)
			return
		for(var/mob/P in viewers(M, null))
			P.show_message(text("\red <B>[] triggers the lockdown!</B>", M.name), 1)
			lockdown()
			clear = 0
	else
		for(var/mob/P in viewers(M, null))
			P.show_message(text("\red <B>You must remove the weapon</B>"), 1)
			return


/obj/machinery/door_control/lockdownreset
	name = "Remote Door Control"
	icon = 'stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control switch for a door."
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/door_control/lockdownreset/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_control/lockdownreset/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_control/lockdownreset/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/device/detective_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/door_control/lockdownreset/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(5)
	icon_state = "doorctrl1"
	endlockdown()
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"
	src.add_fingerprint(usr)
