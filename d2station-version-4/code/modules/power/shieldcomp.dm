/obj/machinery/computer/Shields
	name = "Shields Control Computer"
	icon = 'computer.dmi'
	icon_state = "shields_down"

/obj/machinery/computer/Shields/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/Shields/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)

/obj/machinery/computer/Shields/attack_hand(var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER)) return

	interact(user)

/obj/machinery/computer/Shields/proc/interact(mob/user)
	var/dat = "<B>Shield Control System</B><HR>"
	if(Shields)
		var/charge
		for(var/obj/machinery/shielding/capacitor/S in machines)
			charge = round((100 / S.maxcharge) * S.charge)
		dat += "<B><BR>Capacitor Charge:</B> [charge]% </font><BR>"
		dat += {"<A href='?src=\ref[src];on1=1'>[Shields.on ? "Offline" : "Online"]</A><BR>"}
	dat += {"<br><A href='?src=\ref[src];rf=1'>Refresh</A><BR>"}
	dat += {"<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=330x500")
	onclose(user, "computer")
	return 1
/obj/machinery/computer/Shields/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["on1"])
			if(!Shields.on)
				Shields.startshields()
				UpdateIcon()
			else
				Shields.stopshields()
				UpdateIcon()

	src.updateUsrDialog()
	return 1


/obj/machinery/computer/Shields/proc/UpdateIcon()
	if (Shields.on)
		icon_state = "shields_up"
	else
		icon_state = "shields_down"



