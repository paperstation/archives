/mob/living/simple_animal/eel
	name = "spess eel"
	desc = "A cute tiny eel."
	icon = 'icons/mob/critter.dmi'
	icon_state = "eel"
	icon_living = "eel"
	icon_dead = "lizard-dead"
	speak_emote = list("hisses")
	health = 100
	maxHealth = 100
	attacktext = "bites"
	attacktext = "bites"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/hasShocked = 0 //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.


	Process_Spacemove(var/check_drift = 0)
		return 1


	HasProximity(atom/movable/AM as mob|obj)
		if(health <= 0)
			return 0
		if(istype(AM,/mob/living/silicon) && prob(40))
			shock(AM)
			return 1
		if(istype(AM,/mob/living/carbon) && prob(50))
			shock(AM)
			return 1
		return 0


	proc/shock(mob/living/user as mob)
		if(hasShocked)
			return 0
		if(iscarbon(user))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, user.loc)
			s.start()

			hasShocked = 1

			user.visible_message("\red [user.name] was shocked by the [src.name]!", \
				"\red <B>You feel a powerful shock course through your body sending you flying!</B>", \
				"\red You hear a heavy electrical crack")

			user.burn_skin(melee_damage_upper)
			user.deal_damage(2, WEAKEN)
			var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
			user.throw_at(target, 200, 4)

			spawn(20)
				hasShocked = 0
			return

		else if(issilicon(user))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, user.loc)
			s.start()

			hasShocked = 1
			user.deal_damage(melee_damage_upper, BURN)
			user.visible_message("\red [user.name] was shocked by the [src.name]!", \
				"\red <B>Energy pulse detected, system damaged!</B>", \
				"\red You hear an electrical crack")
			user.deal_damage(2, WEAKEN)

			spawn(20)
				hasShocked = 0
			return

		return