/*
CONTAINS:

Deployable items
Barricades
*/

//Barricades, maybe there will be a metal one later...
/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "This space is blocked off by a wooden barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"
	anchored = 1.0
	density = 1.0
	health = 50
	max_health = 50

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/stack/sheet/wood))
			if (src.health < src.max_health)
				visible_message("\red [user] begins to repair the [src]!")
				if(do_after(user,20))
					src.health = src.max_health
					W:use(1)
					visible_message("\red [user] repairs the [src]!")
					return
			else
				return
			return
		else
			switch(W.damtype)
				if(BURN)
					src.health -= W.force * 1
				if(BRUTE)
					src.health -= W.force * 0.75
				else
			if (src.health <= 0)
				visible_message("\red <B>The barricade is smashed apart!</B>")
				new /obj/item/stack/sheet/wood(get_turf(src))
				new /obj/item/stack/sheet/wood(get_turf(src))
				new /obj/item/stack/sheet/wood(get_turf(src))
				del(src)
			..()

	ex_act(severity)
		switch(severity)
			if(1.0)
				visible_message("\red <B>The barricade is blown apart!</B>")
				del(src)
				return
			if(2.0)
				src.health -= 25
				if (src.health <= 0)
					visible_message("\red <B>The barricade is blown apart!</B>")
					new /obj/item/stack/sheet/wood(get_turf(src))
					new /obj/item/stack/sheet/wood(get_turf(src))
					new /obj/item/stack/sheet/wood(get_turf(src))
					del(src)
				return

	meteorhit()
		visible_message("\red <B>The barricade is smashed apart!</B>")
		new /obj/item/stack/sheet/wood(get_turf(src))
		new /obj/item/stack/sheet/wood(get_turf(src))
		new /obj/item/stack/sheet/wood(get_turf(src))
		del(src)
		return

	blob_act()
		src.health -= 25
		if (src.health <= 0)
			visible_message("\red <B>The blob eats through the barricade!</B>")
			del(src)
		return

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
		if(air_group || (height==0))
			return 1
		if(istype(mover) && mover.checkpass(PASSTABLE))
			return 1
		else
			return 0


//Actual Deployable stuff
/obj/structure/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'


/obj/structure/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrier0"
	anchored = 0
	density = 1.0
	damage_resistance = 5

	var/locked = 0
	var/emagged = 0
	#ifdef NEWMAP
	req_access = list(access_security_area)
	#else
	req_access = list(access_security)
	#endif


	New()
		..()
		src.icon_state = "barrier[src.locked]"
		return


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(user.a_intent == "hurt")
			..()
			return
		if (istype(W, /obj/item/weapon/card/id/))
			if (src.allowed(user))
				if	(src.emagged < 2.0)
					src.locked = !src.locked
					src.anchored = !src.anchored
					src.icon_state = "barrier[src.locked]"
					if ((src.locked == 1.0) && (src.emagged < 2.0))
						user << "Barrier lock toggled on."
						return
					else if ((src.locked == 0.0) && (src.emagged < 2.0))
						user << "Barrier lock toggled off."
						return
				else
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, src)
					s.start()
					visible_message("\red BZZzZZzZZzZT")
					return
			return
		else if (istype(W, /obj/item/weapon/card/emag))
			if (src.emagged == 0)
				src.emagged = 1
				src.req_access = null
				user << "You break the ID authentication lock on the [src]."
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message("\red BZZzZZzZZzZT")
				return
			else if (src.emagged == 1)
				src.emagged = 2
				user << "You short out the anchoring mechanism on the [src]."
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message("\red BZZzZZzZZzZT")
				return
		else if (istype(W, /obj/item/weapon/wrench))
			if (src.health < src.max_health)
				src.health = src.max_health
				src.emagged = 0
				visible_message("\red [user] repairs the [src]!")
				return
			else if (src.emagged > 0)
				src.emagged = 0
				visible_message("\red [user] repairs the [src]!")
				return
			return
		else
			..()
		return


	emp_act(severity)
		if(prob(50/severity))
			locked = !locked
			anchored = !anchored
			icon_state = "barrier[src.locked]"
		..()


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
		if(air_group || (height==0))
			return 1
		if(istype(mover) && mover.checkpass(PASSTABLE))
			return 1
		else
			return 0


	destroy()
		visible_message("\red <B>[src] blows apart!</B>")
		var/turf/Tsec = get_turf(src)

		new /obj/item/stack/rods(Tsec)

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

		explosion(src.loc,-1,-1,0)
		if(src)
			del(src)
		return