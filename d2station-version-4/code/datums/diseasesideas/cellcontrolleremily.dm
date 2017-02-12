/obj/machinery/computer/cellcontrol
	name = "Viral Monitoring Cell Controller"
	icon = 'computer.dmi'
	icon_state = "Cellcontrol"
	var/injected = 0
	var/Sterilized = 0
	var/locked = 0
	var/cellnumber = 0
	var/beaker = null
	var/lockedyesno = "Lock"
	var/id = 1.0
	var/id_tag
	var/panic = 0
/obj/machinery/computer/cellcontrol/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/cellcontrol/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)

/obj/machinery/computer/cellcontrol/attack_hand(var/mob/user as mob)
	var/dat ="<B>Quarantine Cell [cellnumber] Control</B><HR>"
	if(locked)
		dat += "<B>Cell is locked</B></font><BR>"
	if(!locked)
		dat += "<B>Cell is unlocked</B></font><BR>"
	if(!panic)
		dat += {"<A href='?src=\ref[src];vent=1'>Emergency Atmosphere Purge.</A><BR>"}
	if(panic)
		dat += {"<BR><A href='?src=\ref[src];vent=1'>Repressurize Atmosphere.</A><BR>"}
	dat += {"<BR><A href='?src=\ref[src];sterilize=1'>Sterilize Quarantine Cell</A><BR>
		<BR><A href='?src=\ref[src];lock=1'>[lockedyesno]</A><BR>
		<BR><A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=310x300")
	onclose(user, "computer")
	return

/obj/machinery/computer/cellcontrol/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["scan"])

		else if (href_list["vent"])
			for(var/obj/machinery/atmospherics/unary/vent_scrubber/L in oview(10,src))
				if (L.id_tag == src.id_tag)
					if(!panic)
						for(var/obj/machinery/door/airlock/glass/M in machines)
							if (M.id_tag == src.id_tag)
								if (M.locked == 0)
									if (M.density == 0)
										M.close()
									M.locked = 1
								M.icon_state = "door_vlock"
								locked = 1
						for(var/obj/machinery/atmospherics/unary/vent_pump/P in oview(10,src))
							if (P.id_tag == src.id_tag)
								P.on = 0
								P.icon_state = "off"
						L.on = 1
						L.scrubbing = 0
						L.panic = 1
						panic = 1
						L.volume_rate = 5000
						L.icon_state = "in"
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

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return