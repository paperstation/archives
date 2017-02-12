obj/machinery/recharger
	anchored = 1.0
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	name = "recharger"
	mats = 8
	desc = "An anchored minature recharging device, used to recharge small, hand-held objects that don't require much electrical charge."
	power_usage = 50

	var
		obj/item/gun/energy/charging = null
		obj/item/baton/charging2 = null
		obj/item/cargotele/charging3 = null
		obj/item/ammo/power_cell/charging4 = null

/obj/machinery/recharger/attackby(obj/item/G as obj, mob/user as mob)
	if (istype(user,/mob/living/silicon/robot)) return
	if (src.charging || src.charging2 || src.charging3 || src.charging4)
		return
	if (istype(G, /obj/item/gun/energy))
		var/obj/item/gun/energy/E = G
		if (!E.rechargeable) // Can't recharge the crossbow.
			user.show_text("This gun cannot be recharged manually.", "red")
			return
		user.drop_item()
		E.set_loc(src)
		src.charging = E

	else if (istype(G, /obj/item/baton))
		var/obj/item/baton/B = G
		if (B.uses_electricity != 0 && B.cell && istype(B.cell, /obj/item/ammo/power_cell))
			user.drop_item()
			B.set_loc(src)
			src.charging2 = B

	else if (istype(G, /obj/item/cargotele)||istype(G, /obj/item/mining_tool/power_pick)||istype(G, /obj/item/mining_tool/powerhammer))
		user.drop_item()
		G.set_loc(src)
		src.charging3 = G

	else if (istype(G, /obj/item/ammo/power_cell))
		user.drop_item()
		G.set_loc(src)
		src.charging4 = G

/obj/machinery/recharger/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if (src.charging)
		src.charging.update_icon()
		src.charging.set_loc(src.loc)
		src.charging = null
	if(src.charging2)
		src.charging2.update_icon()
		src.charging2.set_loc(src.loc)
		src.charging2 = null
	if(src.charging3)
		src.charging3.set_loc(src.loc)
		src.charging3 = null
	if(src.charging4)
		src.charging4.update_icon()
		src.charging4.set_loc(src.loc)
		src.charging4 = null

/obj/machinery/recharger/process()
	// what the fuck
	// why
	// why the fuck
	// why
	// WHY
	// WHYYYYYYYYYYYYYYYYYYYYYYYYYY?Y?Y?Y?Y?Y?Y?Y????!!?G?!G!?
	// WHO
	// WHO DID THIS
	// WHY DID YOU DO THIS
	// die
	if (src.charging)
		power_usage = 600
	else if (src.charging2 || src.charging3)
		power_usage = 250
	else if (src.charging4)
		power_usage = 500
	else
		power_usage = 50
	..()
	if(stat & NOPOWER)
		src.icon_state = "recharger0"
		return

	if((src.charging) && ! (stat & NOPOWER) )
		if (src.charging.cell)
			if(src.charging.cell.charge(20))
				src.icon_state = "recharger1"
				use_power(600)
			else
				src.icon_state = "recharger2"

	else if ((src.charging2) && ! (stat & NOPOWER) )
		if (src.charging2.cell)
			if(src.charging2.cell.charge(15))
				src.icon_state = "recharger1"
				use_power(500)
			else
				src.icon_state = "recharger2"

	else if ((src.charging3) && ! (stat & NOPOWER) )
		if (src.charging3.charges < src.charging3.maximum_charges)
			src.charging3.charges++
			src.icon_state = "recharger1"
			use_power(250)
		else
			src.icon_state = "recharger2"

	else if ((src.charging4) && ! (stat & NOPOWER) )
		if(src.charging4.charge(15))
			src.icon_state = "recharger1"
			use_power(500)
		else
			src.icon_state = "recharger2"

	else if (!(src.charging || src.charging2 || src.charging3 || src.charging4))
		src.icon_state = "recharger0"
