

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -1
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "carp"

/mob/living/simple_animal/hostile/carp/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/FindTarget()
	. = ..()
	if(.)
		emote("nashes at [.]")


/mob/living/simple_animal/hostile/carp/alphacarp
	name = "alpha space carp"
	desc = "A massive ferocious, fang-bearing creature that resembles a fish.This specimen has more musculature and is darker in color than most."
	icon_state = "alphacarp"
	icon_living = "alphacarp"
	icon_dead = "alphacarp_dead"
	turns_per_move = 4
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "massages the"
	response_disarm = "prissily shoves aside the"
	response_harm = "slaps the"
	speed = -1
	maxHealth = 40
	health = 40

	harm_intent_damage = 7
	melee_damage_lower = 15
	melee_damage_upper = 22
	attacktext = "eviscerates"