/obj/item/extinguisher
	name = "fire extinguisher"
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "fire_extinguisher0"
	var/last_use = 1.0
	var/safety = 1
	var/special = 0
	hitsound = 'sound/weapons/smash.ogg'
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT | OPENCONTAINER
	throwforce = 10
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 10.0
	item_state = "fire_extinguisher"
	m_amt = 90
	desc = "A portable container with a spray nozzle that contains specially mixed fire-fighting foam. The safety is removed, the nozzle pointed at the base of the fire, and the trigger squeezed to extinguish fire."
	stamina_damage = 15
	stamina_cost = 20
	stamina_crit_chance = 35
	module_research = list("tools" = 5, "science" = 1)
	rand_pos = 1

	virtual
		icon = 'icons/effects/VR.dmi'

/obj/item/extinguisher/New()
	..()
	var/datum/reagents/R = new/datum/reagents(75)
	reagents = R
	R.my_atom = src
	R.add_reagent("ff-foam", 75)

/obj/item/extinguisher/get_desc(dist)
	if (dist > 1)
		return
	if (!src.reagents)
		return "The handle is broken."
	return "Contains [src.reagents.total_volume] units."

/obj/item/extinguisher/afterattack(atom/target, mob/user , flag)
	//TODO; Add support for reagents in water.

	if (!src.reagents)
		boutput(user, "<span style=\"color:red\">Man, the handle broke off, you won't spray anything with this.</span>")

	if ( istype(target, /obj/reagent_dispensers) && get_dist(src,target) <= 1)
		var/obj/o = target
		o.reagents.trans_to(src, 75)
		boutput(user, "<span style=\"color:blue\">Extinguisher refilled...</span>")
		playsound(src.loc, "sound/effects/zzzt.ogg", 50, 1, -6)
		return

	if (!safety && !istype(target, /obj/item/storage) && !istype(target, /obj/item/storage/secure))
		if (src.reagents.total_volume < 1)
			boutput(user, "<span style=\"color:red\">The extinguisher is empty.</span>")
			return

		if (world.time < src.last_use + 20)
			return

		src.last_use = world.time


		if (src.reagents.has_reagent("infernite") && src.reagents.has_reagent("blackpowder")) // BAHAHAHAHA
			user.visible_message("<span style=\"color:red\">[src] violently bursts!</span>")
			user.drop_item()
			playsound(src.loc, "sound/effects/bang.ogg", 60, 1, -3)
			fireflash(src.loc, 0)
			explosion(src, src.loc, -1,0,1,1)
			new/obj/item/scrap(get_turf(user))
			if (ishuman(user))
				var/mob/living/carbon/human/M = user
				var/obj/item/implant/projectile/shrapnel/implanted = new /obj/item/implant/projectile/shrapnel(M)
				implanted.owner = M
				M.implant += implanted
				implanted.implanted(M, null, 4)
				boutput(M, "<span style=\"color:red\">You are struck by shrapnel!</span>")
				M.emote("scream")
			qdel(src)

		else if (src.reagents.has_reagent("infernite") || src.reagents.has_reagent("foof"))
			user.visible_message("<span style=\"color:red\">[src] ruptures!</span>")
			user.drop_item()
			playsound(src.loc, "sound/effects/bang.ogg", 60, 1, -3)
			fireflash(src.loc, 0)
			new/obj/item/scrap(get_turf(user))
			qdel(src)


		else if (src.reagents.has_reagent("vomit") || src.reagents.has_reagent("blackpowder") || src.reagents.has_reagent("blood") || src.reagents.has_reagent("gvomit") || src.reagents.has_reagent("carbon") || src.reagents.has_reagent("cryostylane") || src.reagents.has_reagent("chickensoup") || src.reagents.has_reagent("salt"))
			boutput(user, "<span style=\"color:red\">The nozzle is clogged!</span>")
			return

		else if (src.reagents.has_reagent("acid") || src.reagents.has_reagent("pacid") || src.reagents.has_reagent("napalm"))
			user.visible_message("<span style=\"color:red\">[src] melts!</span>")
			user.drop_item()
			new/obj/decal/cleanable/molten_item(get_turf(user))
			qdel(src)



		playsound(src.loc, "sound/effects/spray.ogg", 75, 1, -3)

		var/direction = get_dir(src,target)

		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T,T1,T2)

		logTheThing("combat", user, T, "sprays [src] at %target%, [log_reagents(src)] at [showCoords(user.x, user.y, user.z)] ([get_area(user)])")

		for (var/a=0, a<5, a++)
			spawn (0)
				if (disposed)
					return
				if (!src.reagents)
					return
				var/obj/effects/water/W = unpool(/obj/effects/water)
				if (!W) return
				W.set_loc( get_turf(src) )
				var/turf/my_target = pick(the_targets)
				var/datum/reagents/R = new/datum/reagents(5)
				src.reagents.trans_to_direct(R, 1)
				W.spray_at(my_target, R)

		if (istype(usr.loc, /turf/space))
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)

	else
		return ..()
	return

/obj/item/extinguisher/attack_self(mob/user as mob)
	if (safety)
		src.icon_state = "fire_extinguisher1"
		src.desc = "The safety is off."
		boutput(user, "The safety is off.")
		safety = 0
	else
		src.icon_state = "fire_extinguisher0"
		src.desc = "The safety is on."
		boutput(user, "The safety is on.")
		safety = 1
	return