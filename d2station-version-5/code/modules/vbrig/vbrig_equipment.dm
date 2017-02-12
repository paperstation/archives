/obj/machinery/vbrig
	name = "virtual space unit"
	icon = 'Cryogenic2.dmi'
	icon_state = "vbrig_0"
	density = 1
	var/occupied = 0 // So there won't be multiple persons trying to get into one sleeper
	var/mob/occupant = null
	var/port_id = "default"
	anchored = 1

/obj/machinery/vbrig/allow_drop()
	return 0

/obj/machinery/vbrig/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = loc
			A.blob_act()
		del(src)
	return

/obj/machinery/vbrig/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (occupant)
		user << "\blue <B>The [name] is already occupied!</B>"
		return
	for (var/mob/V in viewers(user))
		V.show_message("[user] starts putting [G.affecting.name] into the [name].", 3)
	if(do_after(user, 20) && !occupant)
		if(!G || !G.affecting) return
		var/mob/M = G.affecting
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		src.icon_state = "vbrig_1"
		for(var/obj/O in src)
			O.loc = loc
		src.add_fingerprint(user)
		del(G)
		return
	return

/obj/machinery/vbrig/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		else
	return

/obj/machinery/vbrig/proc/go_out()
	if (!src.occupant)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant.metabslow = 0
	src.occupant = null
	return

/obj/machinery/vbrig/verb/eject()
	set name = "Eject Virtual Space Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.icon_state = "vbrig_0"

	src.go_out()
	add_fingerprint(usr)

	occupied = 0
	return

/obj/machinery/vbrig/verb/move_inside()
	set name = "Enter Virtual Space Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (occupied)
		usr << "\blue <B>The [name] is already occupied!</B>"
		return
	for (var/mob/V in viewers(usr))
		occupied = 1
		V.show_message("[usr] starts climbing into the [name].", 3)
	if(do_after(usr, 20) && !occupied)
		usr.pulling = null
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
		usr.metabslow = 1
		src.occupant = usr
		src.icon_state = "vbrig_1"

		for(var/obj/O in src)
			del(O)
		src.add_fingerprint(usr)
		return
	else
		occupied = 0
	return







