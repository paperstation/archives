/obj/structure/displaycase
	name = "Display Case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	health = 30
	max_health = 30
	damage_resistance = 0
	damage_sound = 'sound/effects/Glasshit.ogg'
	var/occupied = 1
	var/destroyed = 0


	destroy()
		playsound(src, "shatter", 70, 1)
		..()
		return


	update_health()
		if(!destroyed && health < 10)
			destroyed = 1
			density = 0
			playsound(src, "shatter", 70, 1)
			new/obj/item/weapon/shard(src.loc)
			update_icon()
		if(occupied && health <= 0)
			occupied = 0
			new/obj/item/weapon/gun/energy/laser/captain(src.loc)
		..()
		return


	update_icon()
		if(src.destroyed)
			src.icon_state = "glassboxb[src.occupied]"
		else
			src.icon_state = "glassbox[src.occupied]"
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		damaged_by(W,user)
		return


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	attack_hand(mob/user as mob)
		if(src.destroyed && src.occupied)
			new /obj/item/weapon/gun/energy/laser/captain( src.loc )
			user << "\b You deactivate the hover field built into the case."
			src.occupied = 0
			src.add_fingerprint(user)
			update_icon()
		else
			visible_message("\red [user] kicks the display case.")
			damage(4)
			return


