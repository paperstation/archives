/obj/machinery/doorlock
	name = "door lock
	icon = "blahblahblah.dmi"
	icon_state = "****"
	var/active
	var/id

/obj/machinery/doorlock/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/doorlock/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/doorlock/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/device/detective_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/doorlock/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(5)
	icon_state = "doorctrl1"

		for(var/obj/machinery/door/airlock/M in machines)
			if (M.id == src.id)
				if (M.locked)
					spawn( 0 )
						M.locked = 0
						M.icon_state = "door_closed"
						return
				else
					spawn( 0 )
						if(!(M.density))
							M.close()
						M.locked = 0
						M.icon_state = "door_locked"

						return
						// this is how to lock the doors, you'll need to do access checks using M.required_access or whatever the var is.
						// and connect this upto the cables inside the doors
