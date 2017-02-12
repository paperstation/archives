
/*
FIRE ALARM
*/
/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	dir = 2
	var/detecting = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	var/last_process = 0
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone


	New(loc, dir, building)
		..()

		if(loc)
			src.loc = loc
		if(dir)
			src.dir = dir

		switch(dir)
			if(1)
				pixel_y = 24
			if(2)
				pixel_y = -24
			if(4)
				pixel_x = -24
			if(8)
				pixel_x = 24

		if(building)
			buildstage = 0
			wiresexposed = 1


		if(z == 1)
			if(security_level)
				src.overlays += image('icons/obj/monitors.dmi', "overlay_[get_security_level()]")
			else
				src.overlays += image('icons/obj/monitors.dmi', "overlay_green")

		update_icon()
		return


	update_icon()
		if(wiresexposed)
			switch(buildstage)
				if(2)
					icon_state="fire_b2"
				if(1)
					icon_state="fire_b1"
				if(0)
					icon_state="fire_b0"
			return

		if(stat & BROKEN)
			icon_state = "firex"
		else if(stat & NOPOWER)
			icon_state = "firep"
		else if(!src.detecting)
			icon_state = "fire1"
		else
			icon_state = "fire0"
		return


	temperature_expose(datum/gas_mixture/air, temperature, volume)
		if(src.detecting)
			if(temperature > T0C+200)
				src.alarm()			// added check of detector status here
		return


	attack_ai(mob/user as mob)
		return src.attack_hand(user)


	bullet_act(BLAH)
		return src.alarm()


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	emp_act(severity)
		if(prob(50/severity)) alarm()
		..()

	attackby(obj/item/W as obj, mob/user as mob)
		src.add_fingerprint(user)

		if (istype(W, /obj/item/weapon/screwdriver) && buildstage == 2)
			wiresexposed = !wiresexposed
			update_icon()
			return

		if(wiresexposed)
			switch(buildstage)
				if(2)
					if (istype(W, /obj/item/device/multitool))
						src.detecting = !( src.detecting )
						if (src.detecting)
							user.visible_message("\red [user] has reconnected [src]'s detecting unit!", "You have reconnected [src]'s detecting unit.")
						else
							user.visible_message("\red [user] has disconnected [src]'s detecting unit!", "You have disconnected [src]'s detecting unit.")

					else if (istype(W, /obj/item/weapon/wirecutters))
						buildstage = 1
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
						var/obj/item/weapon/cable_coil/coil = new /obj/item/weapon/cable_coil()
						coil.amount = 5
						coil.loc = user.loc
						user << "You cut the wires from \the [src]"
						update_icon()
				if(1)
					if(istype(W, /obj/item/weapon/cable_coil))
						var/obj/item/weapon/cable_coil/coil = W
						if(coil.amount < 5)
							user << "You need more cable for this!"
							return

						coil.amount -= 5
						if(!coil.amount)
							del(coil)

						buildstage = 2
						user << "You wire \the [src]!"
						update_icon()

					else if(istype(W, /obj/item/weapon/crowbar))
						user << "You pry out the circuit!"
						playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
						spawn(20)
							var/obj/item/weapon/firealarm_electronics/circuit = new /obj/item/weapon/firealarm_electronics()
							circuit.loc = user.loc
							buildstage = 0
							update_icon()
				if(0)
					if(istype(W, /obj/item/weapon/firealarm_electronics))
						user << "You insert the circuit!"
						del(W)
						buildstage = 1
						update_icon()

					else if(istype(W, /obj/item/weapon/wrench))
						user << "You remove the fire alarm assembly from the wall!"
						var/obj/item/firealarm_frame/frame = new /obj/item/firealarm_frame()
						frame.loc = user.loc
						playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
						del(src)
			return

		src.alarm()
		return


	process()
		if(stat & (NOPOWER|BROKEN))
			return

		if(src.timing)
			if(src.time > 0)
				src.time = src.time - ((world.timeofday - last_process)/10)
			else
				src.alarm()
				src.time = 0
				src.timing = 0
				processing_objects.Remove(src)
			src.updateDialog()
		last_process = world.timeofday
		return


	power_change()
		if(powered(ENVIRON))
			stat &= ~NOPOWER
			update_icon()
		else
			spawn(rand(0,15))
				stat |= NOPOWER
				update_icon()
		return


	attack_hand(mob/user as mob)
		if(user.stat || stat & (NOPOWER|BROKEN))
			return

		if (buildstage != 2)
			return

		user.set_machine(src)
		var/area/A = get_area(src.loc)
		if(!A) return
		var/d1
		var/d2
		if (istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon))
			if (A.fire)
				d1 = text("<A href='?src=\ref[];reset=1'>Reset - Lockdown</A>", src)
			else
				d1 = text("<A href='?src=\ref[];alarm=1'>Alarm - Lockdown</A>", src)
			if (src.timing)
				d2 = text("<A href='?src=\ref[];time=0'>Stop Time Lock</A>", src)
			else
				d2 = text("<A href='?src=\ref[];time=1'>Initiate Time Lock</A>", src)
			var/second = round(src.time) % 60
			var/minute = (round(src.time) - second) / 60
			var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>Fire alarm</B> [d1]\n<HR>The current alert level is: [get_security_level()]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
			user << browse(dat, "window=firealarm")
			onclose(user, "firealarm")
		else
			if (A.fire)
				d1 = text("<A href='?src=\ref[];reset=1'>[]</A>", src, stars("Reset - Lockdown"))
			else
				d1 = text("<A href='?src=\ref[];alarm=1'>[]</A>", src, stars("Alarm - Lockdown"))
			if (src.timing)
				d2 = text("<A href='?src=\ref[];time=0'>[]</A>", src, stars("Stop Time Lock"))
			else
				d2 = text("<A href='?src=\ref[];time=1'>[]</A>", src, stars("Initiate Time Lock"))
			var/second = round(src.time) % 60
			var/minute = (round(src.time) - second) / 60
			var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Fire alarm")]</B> [d1]\n<HR><b>The current alert level is: [stars(get_security_level())]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? text("[]:", minute) : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
			user << browse(dat, "window=firealarm")
			onclose(user, "firealarm")
		return


	Topic(href, href_list)
		..()
		if (usr.stat || stat & (BROKEN|NOPOWER))
			return

		if (buildstage != 2)
			return

		if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			usr.set_machine(src)
			if (href_list["reset"])
				src.reset()
			else if (href_list["alarm"])
				src.alarm()
			else if (href_list["time"])
				src.timing = text2num(href_list["time"])
				last_process = world.timeofday
				processing_objects.Add(src)
			else if (href_list["tp"])
				var/tp = text2num(href_list["tp"])
				src.time += tp
				src.time = min(max(round(src.time), 0), 120)

			src.updateUsrDialog()

			src.add_fingerprint(usr)
		else
			usr << browse(null, "window=firealarm")
			return
		return


	proc/reset()
		if(!src.detecting)
			return
		var/area/A = get_area(src.loc)
		if(!A) return
		for(var/area/RA in A.related)
			RA.firereset()
		update_icon()
		return


	proc/alarm()
		if(!src.detecting)
			return
		var/area/A = get_area(src.loc)
		if(!A) return
		for(var/area/RA in A.related)
			RA.firealert()
		update_icon()
		return



/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms
*/
/obj/item/weapon/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit used in constructing fire alarms. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = 2.0
	m_amt = 50
	g_amt = 50


/*
FIRE ALARM ITEM
Handheld fire alarm frame, for placing on walls
Code shamelessly copied from apc_frame
*/
/obj/item/firealarm_frame
	name = "fire alarm frame"
	desc = "Used for building Fire Alarms"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	flags = FPRINT | TABLEPASS| CONDUCT


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/wrench))
			new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
			del(src)
			return
		..()


	proc/try_build(turf/on_wall)
		if (get_dist(on_wall,usr)>1)
			return

		var/ndir = get_dir(on_wall,usr)
		if (!(ndir in cardinal))
			return

		var/turf/loc = get_turf(usr)
		var/area/A = loc.loc
		if (!istype(loc, /turf/simulated/floor))
			usr << "\red Fire Alarm cannot be placed on this spot."
			return
		if (A.requires_power == 0 || A.name == "Space")
			usr << "\red Fire Alarm cannot be placed in this area."
			return

		if(gotwallitem(loc, ndir))
			usr << "\red There's already an item on this wall!"
			return

		new /obj/machinery/firealarm(loc, ndir, 1)
		del(src)
		return