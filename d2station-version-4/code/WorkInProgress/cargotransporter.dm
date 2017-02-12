/obj/machinery/cargopad
	name = "Cargo Pad"
	desc = "Used to recieve objects transported by a Cargo Transporter."
	icon = 'objects.dmi'
	icon_state = "cpad"
	anchored = 1
	var/active = 1

	New()
		src.overlays += image('objects.dmi', "cpad-rec")

	attack_hand(var/mob/user as mob)
		if (src.active == 1)
			user << "You switch the reciever off."
			src.overlays = null
			src.active = 0
		else
			user << "You switch the reciever on."
			icon_state = "telepad"
			src.overlays += image('objects.dmi', "cpad-rec")
			src.active = 1

/obj/item/weapon/cargotele
	name = "Cargo Transporter"
	desc = "A device for teleporting crated goods. 10 charges remain."
	icon = 'mining.dmi'
	icon_state = "cargotele"
	var/charges = 10
	var/maximum_charges = 10.0
	var/robocharge = 250
	var/target = null
	w_class = 2
	flags = ONBELT
	origin_tech = "magnets=5;engineering=5;materials=2"
	//mats = 4		Strumpetplaya - Commented out as it is currently unsupported

	attack_self() // Fixed --melon
		if (src.charges < 1)
			usr << "\red The transporter is out of charge."
			return
		var/list/pads = list()
		for(var/obj/machinery/cargopad/A in machines)
			if (!A.active) continue
			// I suspect it's not consulting the user because it's a list of locations, I cant be sure though --- You're right, so I made this a list of pads.
			pads.Add(A)
		if (!pads.len) usr << "\red No recievers available."
		else
		//here i set up an empty var that can take any object, and tell it to look for absolutely anything in the list
			var/selection = input("Select Cargo Pad Location:", "Cargo Pads", null, null) as null|anything in pads
			if(!selection)
				return
			var/turf/T = get_turf(selection)
			//get the turf of the pad itself
			if (!T)
				usr << "\red Target not set!"
				return
			usr << "Target set to [T.loc]."
			//blammo! works!
			src.target = T

	proc/cargoteleport(var/obj/T, var/mob/user)
		if (!src.target)
			user << "\red You need to set a target first!"
			return
		if (src.charges < 1)
			user << "\red The transporter is out of charge."
			return
		if (istype(user,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			if (R.cell.charge < src.robocharge)
				user << "\red There is not enough charge left in your cell to use this."
				return
		user << "Teleporting [T]..."
		playsound(user.loc, 'click.ogg', 50, 1)
		if(do_after(user, 50))
			T.loc = src.target
			var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
			if (istype(user,/mob/living/silicon/robot))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= src.robocharge
			else
				src.charges -= 1
				src.desc = "A device for teleporting crated goods. [src.charges] charges remain."
				user << "[src.charges] charges remain."
		return