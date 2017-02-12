/mob/living/simple_animal/hostile/russian
	name = "Russian"
	desc = "For the Motherland!"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes the"
	response_disarm = "shoves the"
	response_harm = "hits the"
	speed = -1
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "punches"
	a_intent = "harm"
	var/corpse = /obj/effect/landmark/mobcorpse/russian
	var/weapon1 = /obj/item/weapon/kitchenknife
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "russian"
	status_flags = CANPUSH


/mob/living/simple_animal/hostile/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"
	corpse = /obj/effect/landmark/mobcorpse/russian/ranged
	weapon1 = /obj/item/weapon/gun/projectile/mateba
	ranged = 1
	projectiletype = /obj/item/projectile/bullet
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = /obj/item/ammo_casing/a357


/mob/living/simple_animal/hostile/russian/Die()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	del src
	return


// Here Austupaio rips off the Russians to make Assistant Mobs.


/mob/living/simple_animal/hostile/assistant
	name = "Assistant"
	desc = "Greytide!"
	icon_state = "assistant"
	icon_living = "assistant"
	icon_dead = "assistant_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 7
	response_help = "tickles the"
	response_disarm = "feebly pushes at the"
	response_harm = "punches the"
	speed = -1
	stop_automated_movement_when_pulled = 0
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "slaps"
	a_intent = "harm"
	var/corpse = /obj/effect/landmark/mobcorpse/assistant
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "russian"
	status_flags = CANPUSH

/mob/living/simple_animal/hostile/assistant/toolbox_assistant
	name = "Toolbox Assistant"
	icon_state = "toolbox_assistant"
	icon_living = "toolbox_assistant"
	icon_dead = "toolbox_assistant_dead"
	turns_per_move = 9
	maxHealth = 75
	health = 75
	harm_intent_damage = 4
	melee_damage_lower = 10
	melee_damage_upper = 25
	attacktext = "toolboxes"
	var/weapon1 = /obj/item/weapon/storage/toolbox/mechanical