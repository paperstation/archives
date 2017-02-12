/obj/machinery/computer/security
	name = "Security Cameras"
	icon_state = "security"
	var/obj/machinery/camera/current = null
	var/network = "SS13"
	var/maplevel = 1
	desc = "A computer that allows one to connect to a security camera network and view camera images."

/obj/machinery/computer/security/wooden_tv
	name = "Security Cameras"
	icon_state = "security_det"

	small
		name = "Television"
		desc = "These channels seem to mostly be about robuddies. What is this, some kind of reality show?"
		network = "Zeta"
		icon_state = "security_tv"

		power_change()
			return

// -------------------- VR --------------------
/obj/machinery/computer/security/wooden_tv/small/virtual
	desc = "It's making you feel kinda twitchy for some reason."
	icon = 'icons/effects/VR.dmi'
// --------------------------------------------

/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	network = "thunder"
	density = 0

	power_change()
		return

/obj/machinery/computer/security/attack_hand(var/mob/user as mob)
	if (stat & (NOPOWER|BROKEN))
		return

	user.machine = src
	user.unlock_medal("Peeping Tom", 1)

	var/list/L = list()
	for (var/obj/machinery/camera/C in machines)
		L.Add(C)

	L = camera_sort(L)

	//var/list/D = list()
	//D["Cancel"] = "Cancel"

	user << output(null, "camera_console.camlist")
	for (var/obj/machinery/camera/C in L)
		if (C.network == src.network)
			. = "[C.c_tag][C.status ? null : " (Deactivated)"]"
			//D[.] = C
			user << output("<a href='byond://?src=\ref[src];camera=\ref[C]' style='display:block;'><div>[.]</div></a>", "camera_console.camlist")


	onclose(user, "camera_console", src)
	winset(user, "camera_console.exitbutton", "command=\".windowclose \ref[src]\"")
	winshow(user, "camera_console", 1)


/*
	var/t = input(user, "Which camera should you change to?") as null|anything in D

	if(!t)
		user.set_eye(null)
		user.machine = null
		return 0

	var/obj/machinery/camera/C = D[t]

	if (t == "Cancel")
		user.set_eye(null)
		user.machine = null
		return 0

	if ((get_dist(user, src) > 1 || user.machine != src || !user.sight_check(1) || !( user.canmove ) || !( C.status )) && (!istype(user, /mob/living/silicon/ai)))
		user.set_eye(null)
		return 0
	else
		src.current = C
		user.set_eye(C)
		use_power(50)

		spawn(5)
			attack_hand(user)
*/
/obj/machinery/computer/security/Topic(href, href_list)
	if (!usr)
		return

	if (href_list["close"])
		usr.set_eye(null)
		winshow(usr, "camera_console", 0)
		return

	else if (href_list["camera"])
		var/obj/machinery/camera/C = locate(href_list["camera"])
		if (!istype(C, /obj/machinery/camera))
			return

		if ((!istype(usr, /mob/living/silicon/ai)) && (get_dist(usr, src) > 1 || usr.machine != src || !usr.sight_check(1) || !( usr.canmove ) || !( C.status )))
			usr.set_eye(null)
			winshow(usr, "camera_console", 0)
			return

		else
			src.current = C
			usr.set_eye(C)
			use_power(50)

/obj/machinery/computer/security/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/screwdriver))
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				boutput(user, "<span style=\"color:blue\">The broken glass falls out.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				new /obj/item/raw_material/shard/glass( src.loc )
				var/obj/item/circuitboard/security/M = new /obj/item/circuitboard/security( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				boutput(user, "<span style=\"color:blue\">You disconnect the monitor.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				var/obj/item/circuitboard/security/M = new /obj/item/circuitboard/security( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	else
		src.attack_hand(user)
	return

proc/getr(col)
	return hex2num( copytext(col, 2,4))

proc/getg(col)
	return hex2num( copytext(col, 4,6))

proc/getb(col)
	return hex2num( copytext(col, 6))
