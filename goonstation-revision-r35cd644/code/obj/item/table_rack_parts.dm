/*
CONTAINS:
TABLE PARTS
REINFORCED TABLE PARTS
RACK PARTS
*/

// TABLE PARTS
/obj/item/table_parts
	name = "table parts"
	icon = 'icons/obj/metal.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "table_parts"
	flags = FPRINT | TABLEPASS| CONDUCT
	desc = "A collection of parts that can be used to create a table."
	var/reinforced = 0
	stamina_damage = 35
	stamina_cost = 35
	stamina_crit_chance = 10

/obj/item/table_parts/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/wrench))
		var/atom/A = new /obj/item/sheet( src.loc )
		if(src.material)
			A.setMaterial(src.material)
		else
			var/datum/material/M = getCachedMaterial("steel")
			A.setMaterial(M)
		//SN src = null
		qdel(src)

/obj/item/table_parts/attack_self(mob/user as mob)
	var/obj/table/newTable = null
	if (reinforced)
		newTable = new /obj/table/reinforced/auto(get_turf(user))
	else
		newTable = new /obj/table/auto(get_turf(user))

	if (src.material)
		newTable.setMaterial(src.material)

	newTable.add_fingerprint(user)
	logTheThing("station", user, null, "builds a table (<b>Material:</b> [newTable.material && newTable.material.mat_id ? "[newTable.material.mat_id]" : "*UNKNOWN*"]) at [log_loc(user)].")
	user.u_equip(src)
	qdel(src)
	return
/*
	var/dat = {"<center>Assemble Table</center><hr>
<table border='1'>
<tr><td><A href='?src=\ref[src];dir=NORTHWEST'>NW</A></td><td><A href='?src=\ref[src];dir=NORTH'>N</A></td><td><A href='?src=\ref[src];dir=NORTHEAST'>NE</A></td></tr>
<tr><td><A href='?src=\ref[src];dir=WEST'>W</A></td><td><A href='?src=\ref[src];dir=CENTER'>O</A></td><td><A href='?src=\ref[src];dir=EAST'>E</A></td></tr>
<tr><td><A href='?src=\ref[src];dir=SOUTHWEST'>SW</A></td><td><A href='?src=\ref[src];dir=SOUTH'>S</A></td><td><A href='?src=\ref[src];dir=SOUTHEAST'>SE</A></td></tr>
"}
	user << browse(dat,"window=assembletable;size=160x160;can_close=1")

	src.add_fingerprint(user)
	return
*/
/obj/item/table_parts/Topic(href, href_list)
	..()
	if (usr.stat|| usr.restrained())
		return

	if (src.loc == usr)
		if (href_list["dir"])
			var/obj/table/newTable = null
			if (reinforced)
				newTable = new /obj/table/reinforced( get_turf(usr) )
			else
				newTable = new /obj/table( get_turf(usr) )

			if (src.material)
				newTable.setMaterial(src.material)

			if (href_list["dir"] == "CENTER")
				newTable.icon_state = "[reinforced ? "reinf_" : ""]table"
			else
				newTable.icon_state = "[reinforced ? "reinf_" : ""]tabledir"
				newTable.dir = text2dir(href_list["dir"])

			newTable.add_fingerprint(usr)
			logTheThing("station", usr, null, "builds a table (<b>Material:</b> [newTable.material && newTable.material.mat_id ? "[newTable.material.mat_id]" : "*UNKNOWN*"]) at [log_loc(usr)].")
			usr << browse(null, "window=assembletable")
			qdel(src)
			return
	else
		usr << browse(null, "window=assembletable")
	return

/*
	var/state = input(user, "What type of table?", "Assembling Table", null) in list( "sides", "corners", "alone" )
	var/direct = SOUTH
	var/i_state
	if(state == "alone")
		i_state = "table"
	else if (state == "corners")
		direct = input(user, "Direction?", "Assembling Table", null) in list( "NORTHWEST", "NORTHEAST", "SOUTHWEST", "SOUTHEAST" )
		i_state = "tabledir"
	else if (state == "sides")
		direct = input(user, "Direction?", "Assembling Table", null) in list( "NORTH", "EAST", "SOUTH", "WEST" )
		i_state = "tabledir"
	var/obj/table/T = new /obj/table( user.loc )
	logTheThing("station", user, null, "builds a table (<b>Material:</b> [T.material && T.material.mat_id ? : "[T.material.mat_id]" : "*UNKNOWN*"]) at [log_loc(user)].")
	T.icon_state = i_state
	T.dir = text2dir(direct)
	T.add_fingerprint(user)
	qdel(src)
	return
*/

// REINFORCED TABLE PARTS
/obj/item/table_parts/reinforced
	name = "reinforced table parts"
	icon = 'icons/obj/metal.dmi'
	icon_state = "reinf_tableparts"
	flags = FPRINT | TABLEPASS| CONDUCT
	desc = "A collection of parts that can be used to make a reinforced table."
	reinforced = 1
	stamina_damage = 40
	stamina_cost = 40
	stamina_crit_chance = 15

/obj/item/table_parts/reinforced/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/wrench))
		var/obj/item/sheet/A = new /obj/item/sheet(get_turf(src))
		if(src.material)
			A.setMaterial(src.material)
			A.set_reinforcement(src.material)
			// will have to come back to this later
		else
			var/datum/material/M = getCachedMaterial("steel")
			A.setMaterial(M)
			A.set_reinforcement(M)
		user.u_equip(src)
		qdel(src)

// RACK PARTS
/obj/item/rack_parts
	name = "rack parts"
	icon = 'icons/obj/metal.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "rack_parts"
	flags = FPRINT | TABLEPASS| CONDUCT
	desc = "A collection of parts that can be used to make a rack."
	stamina_damage = 25
	stamina_cost = 25
	stamina_crit_chance = 15

/obj/item/rack_parts/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/wrench))
		var/obj/item/sheet/A = new /obj/item/sheet(get_turf(src))
		if(src.material)
			A.setMaterial(src.material)
		else
			var/datum/material/M = getCachedMaterial("steel")
			A.setMaterial(M)
		qdel(src)
		return
	return

/obj/item/rack_parts/attack_self(mob/user as mob)
	var/obj/rack/R = new /obj/rack( user.loc )
	if(src.material)
		R.setMaterial(src.material)
	else
		var/datum/material/M = getCachedMaterial("steel")
		R.setMaterial(M)
	logTheThing("station", user, null, "builds a rack (<b>Material:</b> [R.material && R.material.mat_id ? "[R.material.mat_id]" : "*UNKNOWN*"]) at [log_loc(user)].")
	R.add_fingerprint(user)
	user.u_equip(src)
	qdel(src)
	return