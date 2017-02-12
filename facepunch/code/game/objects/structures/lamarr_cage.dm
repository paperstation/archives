/obj/structure/lamarr
	name = "Lab Cage"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "labcage1"
	desc = "A glass lab container for storing interesting creatures."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete Lamarr
	health = 30
	max_health = 30
	damage_resistance = 0
	var/occupied = 1
	var/destroyed = 0


	damage(var/amount, var/use_armor = 0)
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
		return


	ex_act(severity)
		damage(100)
		return


	update_icon()
		if(src.destroyed)
			src.icon_state = "labcageb[src.occupied]"
		else
			src.icon_state = "labcage[src.occupied]"
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		damaged_by(W, user)
		return


	attack_paw(mob/user as mob)
		return src.attack_hand(user)


	attack_hand(mob/user as mob)
		if (src.destroyed)
			return
		else
			usr << text("\blue You kick the lab cage.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] kicks the lab cage.", usr)
			damage(4)
			return


	destroy()
		if(src.destroyed)
			..()
			return
		destroyed = 1
		health = 10
		playsound(src, "shatter", 70, 1)
		if(occupied)
			var/obj/item/clothing/mask/facehugger/A = new /obj/item/clothing/mask/facehugger( src.loc )
			A.sterile = 1
			A.name = "Lamarr"
			occupied = 0
		update_icon()
		return