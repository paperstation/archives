
/obj/item/weapon/twohanded/singularityhammer
	name = "singularity hammer"
	desc = "The pinnacle of close combat technology, the hammer harnesses the power of a miniaturized singularity to deal crushing blows."
	icon_state = "mjollnir0"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BACK
	force = DAMAGE_LOW
	force_unwielded = DAMAGE_LOW
	force_wielded = DAMAGE_EXTREME
	w_class = 5
	var/charged = 5
	origin_tech = "combat=5, bluespace=4"



	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		if(charged < 5)
			charged++
		return

/obj/item/weapon/twohanded/singularityhammer/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return


/obj/item/weapon/twohanded/singularityhammer/proc/vortex(var/turf/pull as turf, mob/wielder as mob)
	for(var/atom/X in orange(5,pull))
		if(istype(X, /atom/movable))
			if(X == wielder) continue
			if(X && (!X:anchored))
				step_towards(X,pull)
				step_towards(X,pull)
				step_towards(X,pull)
			if(istype(X,/mob/living))
				var/mob/living/L = X
				L.deal_damage(1, WEAKEN)
	return



/obj/item/weapon/twohanded/singularityhammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	..()
	if(wielded)
		if(charged == 5)
			charged = 0
			if(istype(A, /mob/living/))
				var/mob/living/Z = A
				Z.deal_damage(20, BRUTE, IMPACT)
				Z.deal_damage(20, STUTTER)
			playsound(user, 'sound/weapons/marauder.ogg', 50, 1)
			var/turf/target = get_turf(A)
			vortex(target,user)


/obj/item/weapon/twohanded/mjollnir
	name = "Mjollnir"
	desc = "A weapon worthy of a god, able to strike with the force of a lightning bolt. It crackles with barely contained energy."
	icon_state = "mjollnir0"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BACK
	force = DAMAGE_LOW
	force_unwielded = DAMAGE_LOW
	force_wielded = DAMAGE_EXTREME
	w_class = 5
	//var/charged = 5
	origin_tech = "combat=5, power=5"


/*
	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		if(charged < 5)
			charged++
		return
*/
/obj/item/weapon/twohanded/mjollnir/proc/shock(mob/living/target as mob)
	var/datum/effect/effect/system/lightning_spread/s = new /datum/effect/effect/system/lightning_spread
	s.set_up(5, 1, target.loc)
	s.start()
	target.deal_damage(30, BURN, IMPACT)
	target.deal_damage(20, STUTTER)
	target.visible_message("\red [target.name] was shocked by the [src.name]!", \
		"\red <B>You feel a powerful shock course through your body sending you flying!</B>", \
		"\red You hear a heavy electrical crack")
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 200, 4)
	return


/obj/item/weapon/twohanded/mjollnir/attack(mob/living/M as mob, mob/user as mob)
	..()
	spawn(0)
	if(wielded)
		//if(charged == 5)
		//charged = 0
		playsound(src.loc, "sparks", 50, 1)
		if(istype(M, /mob/living))
			M.deal_damage(5, WEAKEN)
			shock(M)


/obj/item/weapon/twohanded/mjollnir/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return