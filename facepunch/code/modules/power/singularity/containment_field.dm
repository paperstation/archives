//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/containment_field
	name = "Containment Field"
	desc = "An energy field."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "Contain_F"
	anchored = 1
	density = 0
	unacidable = 1
	use_power = USE_POWER_NONE
	luminosity = 4
	damage_resistance = -1
	var/obj/machinery/field_generator/FG1 = null
	var/obj/machinery/field_generator/FG2 = null
	var/hasShocked = 0 //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.


/obj/machinery/containment_field/Del()
	if(FG1 && !FG1.clean_up)
		FG1.cleanup()
	if(FG2 && !FG2.clean_up)
		FG2.cleanup()
	..()

/obj/machinery/containment_field/ex_act(var/strength)
	return 0

/obj/machinery/containment_field/meteorhit()
	return 0

/obj/machinery/containment_field/bullet_act(var/obj/item/projectile/Proj)
	return 0

/obj/machinery/containment_field/attack_hand(mob/user as mob)
	if(get_dist(src, user) > 1)
		return 0
	else
		shock(user)
		return 1


/obj/machinery/containment_field/HasProximity(atom/movable/AM as mob|obj)
	if(istype(AM,/mob/living/silicon) && prob(40))
		shock(AM)
		return 1
	if(istype(AM,/mob/living/carbon) && prob(50))
		shock(AM)
		return 1
	return 0


/obj/machinery/containment_field/proc/shock(mob/living/user as mob)
	if(hasShocked)
		return 0
	if(!FG1 || !FG2)
		del(src)
		return 0
	if(iscarbon(user))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, user.loc)
		s.start()

		hasShocked = 1
		var/shock_damage = min(rand(30,40),rand(30,40))
		user.burn_skin(shock_damage)
		user.unlock_achievement("You are Powerless")
		user.visible_message("\red [user.name] was shocked by the [src.name]!", \
			"\red <B>You feel a powerful shock course through your body sending you flying!</B>", \
			"\red You hear a heavy electrical crack")

		user.deal_damage(10, WEAKEN)

		var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
		user.throw_at(target, 200, 4)

		sleep(20)
		hasShocked = 0
		return

	else if(issilicon(user))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, user.loc)
		s.start()

		hasShocked = 1
		var/shock_damage = rand(15,30)
		user.deal_damage(shock_damage, BURN)
		user.visible_message("\red [user.name] was shocked by the [src.name]!", \
			"\red <B>Energy pulse detected, system damaged!</B>", \
			"\red You hear an electrical crack")

		sleep(20)
		hasShocked = 0
		return

	return


/obj/machinery/containment_field/proc/set_master(var/master1,var/master2)
	if(!master1 || !master2)
		return 0
	FG1 = master1
	FG2 = master2
	return 1
