/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = 1
	opened = 0
	var/locked = 1
	var/broken = 0
	icon_opened = "secureopen"
	icon_closed = "secure"
	var/icon_locked = "secure1"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	health = 200


	can_open()
		if(!..())
			return 0
		if(src.locked)
			return 0
		return 1


	emp_act(severity)
		for(var/obj/O in src)
			O.emp_act(severity)
		if(!broken)
			if(prob(50/severity))
				src.locked = !src.locked
				src.update_icon()
		..()
		return


	proc/togglelock(mob/user as mob)
		if(!src.allowed(user))
			user << "<span class='notice'>Access Denied</span>"
			return
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				O << "<span class='notice'>The locker has been [locked ? null : "un"]locked by [user].</span>"
		update_icon()
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/card/emag) && !src.broken)
			broken = 1
			locked = 0
			desc = "It appears to be broken."
			flick(icon_broken, src)
			update_icon()
			for(var/mob/O in viewers(user, 3))
				O.show_message("<span class='warning'>The locker has been broken by [user] with an electromagnetic card!</span>", 1, "You hear a faint electrical spark.", 2)
			return
		if(!opened && !(istype(W, /obj/item/weapon/weldingtool) || istype(W, /obj/item/weapon/packageWrap)))
			//Closed and not a welder or wrapping paper which are dealt with by the parent proc then we should lock/unlock it
			togglelock(user)
			return
		..()
		return


	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		if(locked)
			togglelock(user)
			return
		..()
		return


	verb/verb_togglelock()
		set src in oview(1) // One square distance
		set category = "Object"
		set name = "Toggle Lock"

		if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
			return

		if(get_dist(usr, src) != 1)
			return

		if(src.broken)
			return

		if (ishuman(usr))
			if (!opened)
				togglelock(usr)
		else
			usr << "<span class='warning'>This mob type can't use this verb.</span>"
		return


	update_icon()
		overlays.Cut()
		if(opened)
			icon_state = icon_opened
			return
		if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			overlays += "welded"
		return

/obj/structure/closet/secure_closet/grineer_closet
	name = "Grineer locker"
	desc = "A big unlocked, alien locker."
	icon = 'icons/obj/warframe_objs.dmi'
	icon_state = "grineer_closet"
	icon_opened = "grineer_closet_open"
	icon_closed = "grineer_closet"
	icon_locked = "grineer_closet_locked"
	icon_broken = "grineer_closet"
	icon_off = "grineer_closet"
	locked = 0