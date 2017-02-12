/obj/item/shipcomponent/sensor
	name = "Standard Sensor System"
	desc = "Advanced scanning system for ships."
	power_used = 20
	system = "Sensors"
	var/ships = 0
	var/list/shiplist = list()
	var/lifeforms = 0
	var/list/lifelist = list()
	var/seekrange = 30
	var/sight = SEE_SELF
	var/see_in_dark = SEE_DARK_HUMAN + 3
	var/see_invisible = 2
	var/scanning = 0
	icon_state = "sensor"

	mob_deactivate(mob/M as mob)
		M.sight &= ~SEE_TURFS
		M.sight &= ~SEE_MOBS
		M.sight &= ~SEE_OBJS
		M.see_in_dark = initial(M.see_in_dark)
		M.see_invisible = 0

	opencomputer(mob/user as mob)
		if(user.loc != src.ship)
			return
		user.machine = src

		var/dat = "<TT><B>[src] Console</B><BR><HR><BR>"
		if(src.active)
			dat += {"<BR><A href='?src=\ref[src];scan=1'>Scan Area</A>"}
			dat += {"<HR><B>[ships] Ships Detected:</B><BR>"}
			if(shiplist.len)
				for(var/shipname in shiplist)
					dat += {"<HR>[shipname] | "}
			dat += {"<HR>[lifeforms] Lifeforms Detected:</B><BR>"}
			if(lifelist.len)
				for(var/lifename in lifelist)
					dat += {"[lifename] | "}
		else
			dat += {"<B><span style=\"color:red\">SYSTEM OFFLINE</span></B>"}
		user << browse(dat, "window=ship_sensor")
		onclose(user, "ship_sensor")
		return

	Topic(href, href_list)
		if(usr.stat || usr.restrained())
			return

		if (usr.loc == ship)
			usr.machine = src

			if (href_list["scan"] && !scanning)
				scan(usr)

			src.add_fingerprint(usr)
			for(var/mob/M in ship)
				if ((M.client && M.machine == src))
					src.opencomputer(M)
		else
			usr << browse(null, "window=ship_sensor")
			return
		return

	proc/dir_name(var/direction)
		switch (direction)
			if (1)
				return "north"
			if (2)
				return "south"
			if (4)
				return "east"
			if (8)
				return "west"
			if (5)
				return "northeast"
			if (6)
				return "southeast"
			if (9)
				return "northwest"
			if (10)
				return "southwest"

	proc/scan(mob/user as mob)
		scanning = 1
		lifeforms = 0
		ships = 0
		lifelist = list()
		shiplist = list()
		playsound(ship.loc, "sound/machines/signal.ogg", 50, 0)
		ship.visible_message("<b>[ship] begins a sensor sweep of the area.</b>")
		boutput(usr, "<span style=\"color:blue\">Scanning...</span>")
		sleep(30)
		boutput(usr, "<span style=\"color:blue\">Scan complete.</span>")
		for (var/mob/living/C in range(src.seekrange,ship.loc))
			if(C.stat != 2)
				lifeforms++
				lifelist += C.name
		for (var/obj/critter/C in range(src.seekrange,ship.loc))
			if(C.alive && !istype(C,/obj/critter/gunbot))
				lifeforms++
				lifelist += C.name
		for (var/obj/npc/C in range(src.seekrange,ship.loc))
			if(C.alive)
				lifeforms++
				lifelist += C.name
		for (var/obj/machinery/vehicle/V in range(src.seekrange,ship.loc))
			if(V != ship)
				ships++
				shiplist += "[V.name] [dir_name(get_dir(ship, V))]"
		for (var/obj/critter/gunbot/drone/V in range(src.seekrange,ship.loc))
			ships++
			shiplist += "[V.name] [dir_name(get_dir(ship, V))]"
		src.updateDialog()
		sleep(10)
		scanning = 0
		return


/obj/item/shipcomponent/sensor/ecto
	name = "Ecto-Sensor 900"
	desc = "The number one choice for reasearchers of the supernatural."
	see_invisible = 15
	power_used = 40

/obj/item/shipcomponent/sensor/mining
	name = "Conclave A-1984 Sensor System"
	desc = "Advanced geological meson scanners for ships."
	sight = SEE_TURFS
	power_used = 35

	scan(mob/user as mob)
		..()
		mining_scan(get_turf(user), user, 6)