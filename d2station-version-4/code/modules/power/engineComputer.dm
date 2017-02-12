/obj/machinery/computer/enginecontrol
	name = "Main Engine Control Computer"
	icon = 'computer.dmi'
	icon_state = "power"
	var/injected = 0
	var/Sterilized = 0
	var/locked = 0
	var/cellnumber = 0
	var/beaker = null
	var/lockedyesno = "Lock"
	var/id = 1.0
	var/id_tag = "core1"
	var/id_tag2 = "core2"
	var/panic = 0
	var/venting1 = null
	var/venting2 = null
	var/Efficiency = 0
	var/co2level = 0
	var/frequency = 1439
	var/list/sensors = list()
	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection
	var/on1
	var/on2
	var/totalp
	var/igniter1 = "portcorechamber"
	var/igniter2 = "starboardcorechamber"

	receive_signal(datum/signal/signal)
		if(!signal || signal.encryption) return

		var/id_tag = signal.data["tag"]
		if(!id_tag || !sensors.Find(id_tag)) return

		sensor_information[id_tag] = signal.data

/obj/machinery/computer/enginecontrol/process()
	for(var/obj/machinery/power/generator/M in machines)
		totalp = round(M.lastgen *6)
		Efficiency = round(100 / 15500 * M.lastgen)
		src.updateDialog()

/obj/machinery/computer/enginecontrol/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/enginecontrol/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)

/obj/machinery/computer/enginecontrol/attack_hand(var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER)) return
	interact(user)

/obj/machinery/computer/enginecontrol/proc/interact(mob/user)
	var/dat = "<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><B>Main Engine Control</B><HR>"
	for(var/obj/machinery/door/poddoor/I in machines)
		if (I.name == "Port Chamber access")
			if	(I.density)
				venting1 = null
			else
				venting1 = 1

		if (I.name == "Starboard Chamber access")
			if	(I.density)
				venting2 = null
			else
				venting2 = 1

	if(!(totalp))
		dat += "<B><BR><font color=\"darkred\">Total Power: 0 Megawatts</B></font><BR>"
		dat += "<B><font color=\"darkred\">Engine Efficiency: at 0%</B></font><BR>"
	if(totalp)
		var/totaloutput = round(totalp / 100)
		dat += "<B><BR>Total Power: [totaloutput] Megawatts</B></font><BR>"
		dat += "<B>Engine Efficiency: [round(Efficiency, 0.1)]%</B></font><BR>"
		dat += "<br><B>Engine Core Control</B></font><BR><br>"
	for(var/obj/machinery/door/poddoor/B in machines)
		if (B.id == "portcoreaccess")
			if (B.name == "Port Chamber access")
				dat += "Core 1 Venting Doors:</font>"
				dat += {"<A href='?src=\ref[src];vent1=1'>[B.density ? "Closed" : "Open"]</A><BR>"}
	for(var/obj/machinery/atmospherics/mixer/R in machines)
		if (R.id == "corem1")
			dat += "Core 1 Mixer Status:</font>"
			dat += {"<A href='?src=\ref[src];mixer1=1'>[R.on ? "On" : "Off"]</A><BR>"}
//	dat += {"<A href='?src=\ref[src];ignite1'>Ignite Core 1</A><BR>"}
	for(var/obj/machinery/door/poddoor/A in machines)
		if (A.id == "starboardcoreaccess")
			if (A.name == "Starboard Chamber access")
				dat += "<br>Core 2 Venting Doors:</font>"
				dat += {"<A href='?src=\ref[src];vent2=1'>[A.density ? "Closed" : "Open"]</A><BR>"}
	for(var/obj/machinery/atmospherics/mixer/U in machines)
		if (U.id == "corem2")
			dat += "Core 2 Mixer Status:</font>"
			dat += {"<A href='?src=\ref[src];mixer2=1'>[U.on ? "On" : "Off"]</A><BR>"}
//	dat += {"<A href='?src=\ref[src];ignite2'>Ignite Core 2</A><BR>"}
	dat += {"<br><A href='?src=\ref[src];rf=1'>Refresh</A><BR>"}
	dat += {"<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=330x500")
	onclose(user, "computer")
	return 1

/obj/machinery/computer/enginecontrol/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["vent1"])
			for(var/obj/machinery/door/poddoor/M in machines)
				if (M.id == "portcoreaccess")
					if (M.density)
						spawn( 0 )
							M.open()
							src.updateDialog()
					else
						spawn( 0 )
							M.close()
							src.updateDialog()

		if (href_list["vent2"])
			for(var/obj/machinery/door/poddoor/M in machines)
				if (M.id == "starboardcoreaccess")
					if (M.density)
						spawn( 0 )
							M.open()
							src.updateDialog()
					else
						spawn( 0 )
							M.close()
							src.updateDialog()
		if (href_list["mixer1"])
			for(var/obj/machinery/atmospherics/mixer/M in machines)
				if (M.id == "corem1")
					if (M.on == 0)
						M.on = 1
						M.icon_state = "intact_[M.on?("on"):("off")]"
						src.updateDialog()
					else
						M.on = 0
						M.icon_state = "intact_[M.on?("on"):("off")]"
						src.updateDialog()
		if (href_list["mixer2"])
			for(var/obj/machinery/atmospherics/mixer/M in machines)
				if (M.id == "corem2")
					if (M.on == 0)
						M.on = 1
						src.updateDialog()
					else
						M.on = 0
						src.updateDialog()

/*		if (href_list["ignite1"])
			for(var/obj/machinery/sparker/M in machines)
				if (M.id == igniter1)
					spawn( 0 )
						M.ignite()

			for(var/obj/machinery/igniter/M in machines)
				if(M.id == igniter1)
					use_power(50)
					M.on = !( M.on )
					M.icon_state = text("igniter[]", M.on)

			sleep(50)

		if (href_list["ignite2"])
			for(var/obj/machinery/sparker/M in machines)
				if (M.id == igniter2)
					spawn( 0 )
						M.ignite()

			for(var/obj/machinery/igniter/M in machines)
				if(M.id == igniter2)
					use_power(50)
					M.on = !( M.on )
					M.icon_state = text("igniter[]", M.on)

			sleep(50)
*/
		if (href_list["rf"])
			src.updateDialog()


	src.updateUsrDialog()
	return 1



/*
					else
						for(var/obj/machinery/atmospherics/unary/vent_pump/P in oview(10,src))
							if (P.id_tag == src.id_tag)
								P.on = 1
								P.icon_state = "out"
						L.scrubbing = 1
						L.panic = 0
						panic = 0
						L.volume_rate = initial(L.volume_rate)
						L.icon_state = "on"
						for(var/obj/machinery/door/airlock/glass/M in machines)
							if (M.id_tag == src.id_tag)
								if (M.locked == 1)
									M.locked = 0
								M.icon_state = "door_closed"
								locked = 0

		else if (href_list["sterilize"])

			for(var/obj/machinery/decon_shower/L in oview(10,src))
				if (L.id_tag == src.id_tag)
					L.spray()
					playsound(src.loc, 'spray2.ogg', 50, 1, -6)

		else if (href_list["lock"])
			use_power(5)
			for(var/obj/machinery/door/airlock/glass/M in machines)
				if (M.id_tag == src.id_tag)
					if (M.locked == 0)
						if (M.density == 0)
							M.close()
						M.locked = 1
						M.icon_state = "door_locked"
						locked = 1
					else
						M.locked = 0
						M.icon_state = "door_closed"
						locked = 0

	var/dat = "<B>Main Engine Control</B><HR>"
		dat += "<B>Engine Efficiency is [Efficiency]</B></font><BR>"
		dat += "<br><B>Core 1</B></font><BR>"
		dat += "<B>Engine CO2 level is is</B></font><BR><br><br>"
		dat += "<br><B>Core 2</B></font><BR>"
		dat += "<B>Engine CO2 level is is</B></font><BR><br><br>"
		if(venting1)
			dat += {"<BR><A href='?src=\ref[src];vent=2'>Stop Venting Core 1</A><BR>"}
		else
			dat += {"<BR><A href='?src=\ref[src];vent=1'>Vent Core 1</A><BR>"}

		if(venting2)
			dat += {"<BR><A href='?src=\ref[src];vent=2'>Stop Venting Core 2</A><BR>"}
		else
			dat += {"<BR><A href='?src=\ref[src];vent=2'>Vent Core 2</A><BR>"}

		dat += {"<BR><A href='?src=\ref[src];lock=1'>Emergency Shutdown</A><BR>
		<BR><A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=310x300")
	onclose(user, "computer")
	return


*/