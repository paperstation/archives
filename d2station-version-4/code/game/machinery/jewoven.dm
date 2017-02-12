#define BOLTED 32

/obj/machinery/jewoven
	anchored = 0
	density = 1
	icon = 'atmos.dmi'
	icon_state = "jewoven0"
	name = "NaziTech Air-Oven"
	desc = "A NaziTech brand space heater, with a Space SS guarantee of setting whichever room you put it in on fire."
	var/obj/item/weapon/cell/cell
	var/on = 0
	var/open = 0
	var/set_temperature = 1488		// in celsius, add T0C for kelvin
	var/heating_power = 6000000

	flags = FPRINT


	New()
		..()
		cell = new(src)
		cell.charge = 50000
		cell.maxcharge = 50000
		update_icon()
		return

	update_icon()
		if(open)
			icon_state = "jewoven-open"
		else
			icon_state = "jewoven[on]"
		return

	examine()
		set src in oview(12)
		if (!( usr ))
			return
		usr << "This is \icon[src] \an [src.name]."
		usr << src.desc

		usr << "The heater is [on ? "on" : "off"] and the hatch is [open ? "open" : "closed"]."
		if(open)
			usr << "The power cell is [cell ? "installed" : "missing"]."
		else
			usr << "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"
		return


	attackby(obj/item/I, mob/user)
		if(istype(I, /obj/item/weapon/cell))
			if(open)
				if(cell)
					user << "There is already a power cell inside."
					return
				else
					// insert cell
					var/obj/item/weapon/cell/C = usr.equipped()
					if(istype(C))
						user.drop_item()
						cell = C
						C.loc = src
						C.add_fingerprint(usr)

						user.visible_message("\blue [user] inserts a power cell into [src].", "\blue You insert the power cell into [src].")
			else
				user << "The hatch must be open to insert a power cell."
				return
		else if(istype(I, /obj/item/weapon/screwdriver))
			open = !open
			user.visible_message("\blue [user] [open ? "opens" : "closes"] the hatch on the [src].", "\blue You [open ? "open" : "close"] the hatch on the [src].")
			on = 0 //just in case...
			update_icon()
			if(!open && user.machine == src)
				user << browse(null, "window=jewoven")
				user.machine = null
		else if(istype(I, /obj/item/weapon/wrench))
			if(stat & BOLTED)
				if(on)
					user << "\red You need to deactivate the heater first!"
					return
				else
					playsound(src.loc, 'Ratchet.ogg', 50, 1)
					if(do_after(user, 20))
						stat &= ~BOLTED
						anchored = 0
						user << "\blue You unbolt the heater from the floor."
					return
			else
				playsound(src.loc, 'Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					stat |= BOLTED
					anchored = 1
					user << "\blue You bolt the heater to the floor."
				return
		else if (open == 1)
			user << "\red The machine does not take kindly to it's insides being bashed with a wrench. It promptly extends a mechanical hand and slaps you."
			var/mob/living/carbon/human/H = user
			var/datum/organ/external/affecting = H.organs["head"]
			affecting.take_damage(10, 0)
			H.stunned = 8
			H.weakened = 5
			H.UpdateDamage()
			H.UpdateDamageIcon()
			H.brainloss = (H.brainloss + 2)
		else
			..()
		return

	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		if (open == 1)

			var/dat
			dat = "Power cell: "
			if(cell)
				dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
			else
				dat += "<A href='byond://?src=\ref[src];op=cellinstall'>Removed</A><BR>"

			dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

			dat += "Set Temperature: "

			dat += "<A href='?src=\ref[src];op=temp;val=-5000'>-</A>"

			dat += " [set_temperature]&deg;C "
			dat += "<A href='?src=\ref[src];op=temp;val=5000'>+</A><BR>"

			user.machine = src
			user << browse("<HEAD><link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><TITLE>NaziTech Air-Oven Control Panel:</TITLE></HEAD><TT>[dat]</TT>", "window=jewoven")
			onclose(user, "jewoven")

		else if (anchored == 1)
			on = !on
			user.visible_message("\blue [user] switches [on ? "on" : "off"] the [src].","\blue You switch [on ? "on" : "off"] the [src].")
			update_icon()
		else if ((anchored == 0) && (open == 0))
			user << "\red You need to bolt the heater to the floor first!"
		return

/*	var/obj/item/weapon/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			if (GM.client)
				GM.client.perspective = EYE_PERSPECTIVE
				GM.client.eye = src
			GM.loc = src
			or (var/mob/C in viewers(src))
				C.show_message("\red [GM.name] has been placed in the [src] by [user].", 3)
			del(G)

	insertjew(mob/target, mob/user)
		if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai) || user.restrained() || user.stunned || user.weakened)
			return

		var/msg

		if(target == user && !user.stat)	// if insert self, then climbed in
												// must be awake
			msg = "[user.name] climbs into the [src]."
			user << "You climb into the [src]."
		else if(target != user && !user.restrained())
			msg = "[user.name] stuffs [target.name] into the [src]!"
			user << "You stuff [target.name] into the [src]!"
		else
			return
		if (target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		target.loc = src

		for (var/mob/C in viewers(src))
			if(C == user)
				continue
			C.show_message(msg, 3)
		timeleft = 5
		update()
		return

	// can breathe normally in the oven
	alter_health()
		return get_turf(src)

	// attempt to move while inside
	relaymove(mob/user as mob)
		if(user.stat || src.on) //can't leave when being genocided and/or drugged
			return
		src.go_out(user)
		return

	// leave the oven
	proc/go_out(mob/user)

		if (user.client)
			user.client.eye = user.client.mob
			user.client.perspective = MOB_PERSPECTIVE
		user.loc = src.loc
		update()
		return
*/

	Topic(href, href_list)
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			usr.machine = src

			switch(href_list["op"])

				if("temp")
					var/value = text2num(href_list["val"])

					// limit to 1488-25000 degC
					set_temperature = dd_range(1488, 25000, set_temperature + value)

				if("cellremove")
					if(open && cell && !usr.equipped())
						cell.loc = usr
						cell.layer = 20
						if(usr.hand)
							usr.l_hand = cell
						else
							usr.r_hand = cell

						cell.add_fingerprint(usr)
						cell.updateicon()
						cell = null

						usr.visible_message("\blue [usr] removes the power cell from \the [src].", "\blue You remove the power cell from \the [src].")


				if("cellinstall")
					if(open && !cell)
						var/obj/item/weapon/cell/C = usr.equipped()
						if(istype(C))
							usr.drop_item()
							cell = C
							C.loc = src
							C.add_fingerprint(usr)

							usr.visible_message("\blue [usr] inserts a power cell into \the [src].", "\blue You insert the power cell into \the [src].")

			updateDialog()
		else
			usr << browse(null, "window=jewoven")
			usr.machine = null
		return



	process()
		if(on)
			if(cell && cell.charge > 0)

				var/turf/simulated/L = loc
				if(istype(L))
					var/datum/gas_mixture/env = L.return_air()
					if(env.temperature < (set_temperature+T0C))

						var/transfer_moles = 0.25 * env.total_moles()

						var/datum/gas_mixture/removed = env.remove(transfer_moles)

						//world << "got [transfer_moles] moles at [removed.temperature]"

						if(removed)

							var/heat_capacity = removed.heat_capacity()
							//world << "heating ([heat_capacity])"
							if(heat_capacity == 0 || heat_capacity == null) // Added check to avoid divide by zero (oshi-) runtime errors -- TLE
								heat_capacity = 1
							removed.temperature = min((removed.temperature*heat_capacity + heating_power)/heat_capacity, 1000) // Added min() check to try and avoid wacky superheating issues in low gas scenarios -- TLE
							cell.use(50) //a wi- nazi scientist did it

							//world << "now at [removed.temperature]"

						env.merge(removed)

						//world << "turf now at [env.temperature]"


			else
				on = 0
				update_icon()


		return

/*	genocide(atom/A, mob/user as mob)
	if(genociding) //a bit of a hack to make sure a single jew isn't cremated 2000 times
		return
	else if((contents) && (on))
		genociding = 1
		for (var/mob/living/M in contents) //by design, only mobs are to put in here, but this is just to be damn specific
			M:stunned = 100 //You really don't want to place this inside the loop.
			spawn(1)
				for(var/i=1 to 10)
					sleep(10)
					M.take_overall_damage(0,30)
					if ((M:stat !=2) && (prob(30)))
						M.emote("scream")
				new /obj/decal/ash(src.loc)
				for (var/obj/item/W in M)
					if (prob(10))
						W.loc = src.loc
				M:death(1)
				M:ghostize()
				del(M)
				genociding = 0
				playsound(src.loc, 'ding.ogg', 50, 1)
				for (var/mob/M in viewers(src))
					M:show_message("\red The [src] roars, \"One parasite successfully removed. Sieg Heil!\".", 5)
	return

so i decided to comment the actual furnace stuff until i'm bored enough to make it work properly (probably never)
enjoy a glorified space heater instead --soyuz
*/

#undef BOLTED