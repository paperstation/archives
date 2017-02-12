/mob/living/simple_animal/cult //This is the not hostile version
	name = "Cultist"
	desc = "A minion hellbent on summoning Nar-sie."
	icon = 'icons/mob/animal.dmi'
	health = 2000
	maxHealth = 2000
	attacktext = "slices"
	icon_state = "cult"
	icon_living = "cult"
	icon_dead = "cult_dead"
	response_help  = "pets"
	response_disarm = "kicks"
	response_harm   = "punches"
	speak_chance = 0
	turns_per_move = 0
	see_in_dark = 6
	stop_automated_movement_when_pulled = 0
	maxHealth = 20
	health = 20
	melee_damage_lower = 5
	melee_damage_upper = 5
	var/golemhealth = 50 //

/mob/living/simple_animal/hostile/cult
	name = "Cultist"
	desc = "A minion hellbent on summoning Nar-sie."
	icon = 'icons/mob/animal.dmi'
	health = 50
	maxHealth = 50
	attacktext = "slices"
	icon_state = "cult"
	icon_living = "cult"
	icon_dead = "cult_dead"
	response_help  = "pets"
	response_disarm = "kicks"
	response_harm   = "punches"
	speak_chance = 0
	turns_per_move = 0
	see_in_dark = 6
	stop_automated_movement_when_pulled = 0
	maxHealth = 20
	health = 20
	melee_damage_lower = 5
	melee_damage_upper = 5



/mob/living/simple_animal/hostile/syndiebot
	name = "Syndicate-Bot"
	desc = "Beep-boop."
	icon = 'icons/mob/animal.dmi'
	health = 50
	maxHealth = 50
	attacktext = "punches"
	icon_state = "syndiebot"
	icon_living = "syndiebot"
	icon_dead = "syndiebot"
	response_help  = "pets"
	response_disarm = "kicks"
	response_harm   = "punches"
	speak_chance = 0
	turns_per_move = 0
	see_in_dark = 6
	stop_automated_movement_when_pulled = 0
	maxHealth = 20
	health = 20
	melee_damage_lower = 5
	melee_damage_upper = 8


/mob/living/simple_animal/hostile/wargolem
	name = "Cult War Golem"
	desc = "What IS this thing?!?."
	icon = 'icons/mob/animal.dmi'
	health = 50
	maxHealth = 50
	attacktext = "smashes"
	icon_state = "cultgolem"
	icon_living = "cultgolem"
	icon_dead = "cultgolem_dead"
	response_help  = "pokes"
	response_disarm = "kicks"
	response_harm   = "punches"
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	stop_automated_movement_when_pulled = 0
	melee_damage_lower = 10
	melee_damage_upper = 15
	var/hasShocked = 0




/mob/living/simple_animal/hostile/wargolem/shocktrooper
	name = "Cult Shock Golem"
	desc = "Shocking, isn't he?"


	HasProximity(atom/movable/AM as mob|obj)
		if(health <= 0)
			return 0
		if(istype(AM,/mob/living/carbon) && prob(95))
			shock(AM)
			return 1
		return 0


	proc/shock(mob/living/user as mob)
		if(hasShocked)
			return 0
		if(iscarbon(user))
			hasShocked = 1
			user.visible_message("\red [user.name] was thrown by the [src.name]!", \
				"\red <B>You feel yourself flailing around as you are sent flying!</B>", \
				"\red You hear a loud thud")
			var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
			user.throw_at(target, 200, 4)

			spawn(30)
				hasShocked = 0
			return

		else if(issilicon(user))
			return
		return