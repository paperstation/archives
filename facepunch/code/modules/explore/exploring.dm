/proc/showgates()
	var/dat = "Gate Codes<BR>"
	for(var/obj/machinery/stargate/center/G in world)
		dat += "[G.id]: [G.code] <BR>"
	usr << browse(text("<HEAD><TITLE>Gates </TITLE></HEAD><TT>[]</TT>", dat), "window=gates")
	return


/obj/machinery/computer/gate
	name = "Gate Control Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "teleport"
	var/obj/machinery/stargate/center/gate = null
	var/dial = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 600


	New()
		..()
		spawn(10)
			//Might be a better way to link it but this works
			for(var/obj/machinery/stargate/center/C in orange(9,src))
				gate = C
				return
			if(!gate)
				stat |= BROKEN
		return


	emp_act(severity)
		return


	process()
		if(stat & (BROKEN|NOPOWER))
			return
		if(dial && gate)
			gate.dial(dial)
		dial = 0


	attack_ai(mob/user as mob)
		return src.attack_hand(user)


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	attack_hand(mob/user as mob)
		if(stat & (BROKEN|NOPOWER))
			return

		if(..())
			return
		var/dat = ""

		dat += "Gate Control System<BR>"
		if(!gate)
			dat+= "No linked gate detected<BR>"
		else
			dat += "Gate Status<BR>"
			dat += "ID:[gate.id], Code:[gate.code]<BR>"
			if(gate.active)
				dat += "Active, Linked Gate: ID:[gate.linked_gate.id], Code:[gate.linked_gate.code]<BR>"
				dat += "<A href='?src=\ref[src];stop=1;umob=\ref[user]'>Shutdown</A><BR>"
				if(gate.can_shutdown)
					dat += "<A href='?src=\ref[src];lock=1;umob=\ref[user]'>Apply Lock</A><BR>"
				else
					dat += "<A href='?src=\ref[src];unlock=1;umob=\ref[user]'>Release Lock</A><BR>"
			else
				dat += "Inactive<BR>"
				dat += "<A href='?src=\ref[src];start=1;umob=\ref[user]'>Dial Gate</A><BR>"

		user << browse(text("<HEAD><TITLE>Gate Control</TITLE></HEAD><TT>[]</TT>", dat), "window=gate_control")
		onclose(user, "gate_control")
		return


	Topic(href, href_list)
		if(..())
			return

		if(!gate)
			return

		if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			usr.machine = src

			var/mob/living/M = locate(href_list["umob"])
			if (href_list["stop"])
				if(gate.active)
					if(gate.shutdown_gate())
						M << "\green Gate shutdown!"
					else
						M << "\red Shutdown failed!"

			if(href_list["start"])
				if(gate.active)
					usr << "\red Shutdown gate before entering a new code!"
				else
					var/dialing_code = input(M,"Enter the code of a gate to connect to that gate.","Dial","0000000")
					var/working = gate.dial(dialing_code)
					if(!working)
						M << "\red Invalid Code!"
					else
						M << "\green Connected!"

			if(href_list["unlock"])
				gate.can_shutdown = 1
			if(href_list["lock"])
				gate.can_shutdown = 0

		src.updateUsrDialog()
		return


/* How to actually get the other codes needs to be redone
/obj/machinery/computer/satellite2
	name = "Satellite Control Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "teleport"
	use_power = USE_POWER_IDLE
	idle_power_usage = 400
	var/list/active_sats = new/list()
	//var/obj/machinery/communications_dish/Com_dish = 0
	var/tickcheck = 0
	//var/obj/machinery/power/data_terminal/Term = 0
	var/turned_on = 0
	//	var/obj/machinery/computer/satellite/S = null

/obj/machinery/computer/satellite2/New()
	..()
//	var/turf/T = get_turf(src)
//	spawn(5)
//		src.Term = locate(/obj/machinery/power/data_terminal) in T
//		if(!Term)
//			stat |= BROKEN


/obj/machinery/computer/satellite2/process()
	if(stat & (BROKEN|NOPOWER))
		return
	if((tickcheck >= 10))
		check_com()
		tickcheck = 0
	else
		tickcheck++
	return

/obj/machinery/computer/satellite2/proc/check_com()
	return turned_on
	/*
	if(!Term)
		stat |= BROKEN
		src.Com_dish = 0
		return 0
	for(var/obj/machinery/power/data_terminal/D in Term.powernet.nodes)
		if(D.master)
			if(istype(D.master,/obj/machinery/communications_dish))
				if(src.Com_dish == D.master)
					return 1
	src.Com_dish = 0
	return 0*/

/obj/machinery/computer/satellite2/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/satellite2/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/satellite2/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		user << "It is not working at the moment!"
		return

	if(..())
		return
	var/dat = ""

	dat += "Welcome to SatCon Remote Version 0.801 <BR>"
	dat += "---Com Status---------------------------<BR>"
	//if(!Com_dish)
	if(!turned_on)
		dat += "<A href='?src=\ref[src];scancom=1;'>Activate Computer</A><BR>"
	else
		dat += "Com Array Detected.<BR>"
		dat+= "-----------------------------------------<BR>"
		dat += "<A href='?src=\ref[src];scansat=1'>Scan for active Satellites</A><BR>"

		dat+= "---Active Satellites---------------------<BR>"
		for(var/obj/machinery/computer/satellite/A in active_sats)
			if(A.active)
				dat += "Satellite ID:[A.id] "
				dat += "<BR>"
				dat += "Located Gates <BR>"
				dat += "******************* <BR>"
				for(var/obj/machinery/stargate/center/gate in A.located_things)
					dat+= "Name:[gate.id] %Complete: [gate.known-1]/7 Code: [gate.code] <BR>"
				dat += "******************* <BR><BR>"

	if(!active_sats.len)
		dat+= "None Detected<BR>"

	user << browse(text("<HEAD><TITLE>Satellite Control Remote</TITLE></HEAD><TT>[]</TT>", dat), "window=sat_control")
	onclose(user, "sat_control")
	return

/obj/machinery/computer/satellite2/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if(href_list["scancom"])
			turned_on = 1
			src.attack_hand(usr)
			/*for(var/obj/machinery/power/data_terminal/D in Term.powernet.nodes)
				if(D.master)
					if(istype(D.master,/obj/machinery/communications_dish))
						var/obj/machinery/communications_dish/C = D.master
						src.Com_dish = C
						usr << "Array Located"
						src.attack_hand(usr)
						break*/

		if(href_list["scansat"])
			var/checking = check_com()
			if(checking)
				src.active_sats = new/list()
				for(var/obj/machinery/computer/satellite/Sat in world)
					if(Sat.active)
						src.active_sats.Add(Sat)
				src.attack_hand(usr)
	//src.add_fingerprint(usr)
	src.updateUsrDialog()
	attack_hand(usr)

	return


//Todo: Add plasma and more sat parts into this >plasma.temp faster it scans or something
/obj/machinery/computer/satellite
	name = "Satellite Mainframe"
	icon = 'icons/obj/computer.dmi'
	icon_state = "teleport"
	var/time_left = -1
	var/obj/machinery/stargate/center/current_scan = null
	var/list/located_things = new/list()
	var/active = 1//0=off,1=normal,2=scanning new gate, 3 = scanning a gate
	var/power_usage = 500
	var/id = ""

/obj/machinery/computer/satellite/New()
	for(var/M = 0, M < 7, M++)
		src.id += pick("1","2","3","4","5","6","7","8","a","b","c","d")
	..()

/obj/machinery/computer/satellite/process()
	if(stat & (BROKEN|NOPOWER))
		if(src.active >= 1)
			src.active = 0
		return
	if(!active)
		active = 1
	use_power(power_usage)

	if(time_left > 0)
		time_left --

	if(time_left == 0)
		switch(src.active)
			if(1)
				return
			if(2)
				if(current_scan)
					src.located_things.Add(current_scan)
					current_scan = null
					active = 1
			if(3)
				if(current_scan)
					process_object()
	return

/obj/machinery/computer/satellite/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/satellite/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/satellite/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	if(..())
		return
	var/dat = ""

	dat += "Welcome to SatCon Version 0.801 <BR>"
	dat += "-----------------------------------------<BR>"
	dat += "Current Scan Object<BR>"
	dat += "------------------<BR>"

	if(src.current_scan)
		if(src.active == 2)
			dat += "Scanning for a new gate... Time:[src.time_left]<BR>"

		else
			dat += "Name:[current_scan.id] %Complete: [current_scan.known-1]/7 <A href='?src=\ref[src];gate=\ref[current_scan];start=3'>Stop Scan</A> <BR>"
			dat += "Time:[time_left] Code: [current_scan.code]<BR>"

	else
		dat += "<A href='?src=\ref[src];gate=1'>Start New Scan</A><BR>"

	dat += "Located Gates <BR>"
	dat += "*******************<BR>"

	for(var/obj/machinery/stargate/center/gate in located_things)
		if(gate == current_scan)	continue
		dat+= "Name:[gate.id] %Complete: [gate.known-1]/7 Code: [gate.code] <BR>"
		if(gate.known != 100)
			dat += "<A href='?src=\ref[src];gate=\ref[gate];start=1'>Scan</A><BR>"
		else
			dat += "<BR>"
	dat += "*******************<BR>"

	user << browse(text("<HEAD><TITLE>Satellite Control</TITLE></HEAD><TT>[]</TT>", dat), "window=sat_control")
	onclose(user, "sat_control")
	return

/obj/machinery/computer/satellite/Topic(href, href_list)
	if(..())
		return
	if (((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))||(href_list["remote"]))
		usr.machine = src

		if (href_list["gate"])
			switch(href_list["gate"])
				if("1")
					src.active = 2
					locate_gate()
				else
					var/obj/machinery/stargate/center/gate = locate(href_list["gate"])
					if(gate)
						switch(href_list["start"])
							if("1")
								src.current_scan = gate
								src.time_left = 40
								src.active = 3
							else
								src.current_scan = null
								src.time_left = 0
								src.active = 1


	src.add_fingerprint(usr)
	//src.updateUsrDialog()
	attack_hand(usr)

	return

/obj/machinery/computer/satellite/proc/locate_gate()
	var/list/L = new/list()
	for(var/obj/machinery/stargate/center/gate in world)
		var/check = 0
		if(gate.station)	continue
		for(var/obj/machinery/stargate/center/scanned_item in located_things)
			if(gate == scanned_item)
				check = 1
				break
		if(check)	continue
		L.Add(gate)
	if(!L.len)	return
	var/P = pick(L)
	if(P)
		current_scan = P
		src.active = 2
		src.time_left = 80

/obj/machinery/computer/satellite/proc/process_object()
	if(prob(80)&&(src.current_scan.known<=8))//This should be changed later based upon power/plasma/something that makes it better that they can mess with
		src.current_scan.update_code()
		src.current_scan.known +=1
		time_left = 40
	if(src.current_scan.known >=8)
		src.current_scan = null
		src.current_scan.known +=1
		src.active = 1
	return

*/