
/obj/item/device/shield/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The shield is now active."
		src.icon_state = "shield1"
	else
		user << "\blue The shield is now inactive."
		src.icon_state = "shield0"
	src.add_fingerprint(user)
	return

/obj/item/weapon/cloaking_device/attack_self(mob/user as mob)
	src.active = !( src.active )
	if ((src.active) && (power >= 1))
		user << "\blue The cloaking device is now active."
		src.icon_state = "shield1"
		drain(user)
	else
		user << "\blue The cloaking device is now inactive."
		src.icon_state = "shield0"
		drain(user)
	src.add_fingerprint(user)
	return


/obj/item/weapon/cloaking_device/emp_act(severity)
	active = 0
	icon_state = "shield0"
	..()