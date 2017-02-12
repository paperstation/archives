/mob/living/simple_animal/hostile/retaliate/human/explorer
	name = "Space Explorer"
	desc = "I guess he is exploring space!"
	icon_state = "spaceexplorer"
	icon_living = "spaceexplorer"
	icon_dead = "spaceexplorer_dead"
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
	atmos_immune = 1
	faction = "Station"
	status_flags = CANPUSH
	ranged = 1
	var/weapon1
	var/weapon2
	rapid = 0
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	projectiletype = /obj/item/projectile/beam/pulse/heavy
	weapon1 = /obj/item/weapon/gun/energy/taser


/mob/living/simple_animal/hostile/retaliate/human/explorer/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!enemies.len && prob(1))
			say("I wonder what happened here")


/mob/living/simple_animal/hostile/retaliate/human/explorer/Move()
	..()
	if(!stat)
		if(locate(/obj/item) in loc)
			var/obj/item/SV = locate(/obj/item) in loc
			del(SV)
			if(prob(10))
				say("Better grab everything I can!")
			if(prob(10))
				say("This will go great in my collection!")
			if(prob(10))
				say("Be a space explorer they said; you'll pick up chicks they said. Pft alls I pick up is junk!")

		if(locate(/mob/living/simple_animal/chick) in loc)
			var/mob/living/simple_animal/chick/SV = locate(/mob/living/simple_animal/chick) in loc
			del(SV)
			say("I KNEW I COULD PICK UP CHICKS!")


/mob/living/simple_animal/hostile/retaliate/human/explorer/Retaliate()
	..()
	var/list/around = view(src, 7)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(!attack_same && M.faction != faction)
				enemies |= M
		else if(istype(A, /obj/mecha))
			var/obj/mecha/M = A
			if(M.occupant)
				enemies |= M
				enemies |= M.occupant

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(!attack_same && !H.attack_same && H.faction == faction)
			H.enemies |= enemies
	return 0

/mob/living/simple_animal/hostile/retaliate/human/explorer/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(!stat)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				DestroySurroundings()
				AttackTarget()

/mob/living/simple_animal/hostile/retaliate/human/explorer/OpenFire(target_mob)
	if(prob(48))
		projectilesound = 'sound/weapons/lasercannonfire.ogg'
		projectiletype = /obj/item/projectile/beam/pulse/heavy
	else
		projectilesound = 'sound/weapons/taser2.ogg'
		projectiletype = /obj/item/projectile/energy/electrode
	var/target = target_mob
	visible_message("\red <b>[src]</b> fires at [target]!", 1)

	var/tturf = get_turf(target)
	if(rapid)
		spawn(1)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(4)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(6)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
	else
		Shoot(tturf, src.loc, src)
		if(casingtype)
			new casingtype

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return


/mob/living/simple_animal/hostile/retaliate/human/explorer/Bump(obj/item/I as obj)
	if(istype(I,/obj/item/projectile/energy/electrode))
		target_mob = null
		stance = HOSTILE_STANCE_IDLE
		resting = 1
		icon_state = "spaceexplorer_dead"
		icon_living = "spaceexplorer_dead"
		sleep(500)
		icon_state = "spaceexplorer"
		icon_living = "spaceexplorer"
		resting = 0
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/retaliate/human/explorer/AttackTarget()

	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets()))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1




/mob/living/simple_animal/hostile/retaliate/human/scientist
	name = "Scientist"
	desc = "A creator of ASS-X"
	icon = 'icons/mob/animal.dmi'
	icon_state = "scientist"
	icon_living = "scientist"
	icon_dead = "scientist_dead"
	speak_chance = 0
	turns_per_move = 10
	response_help = "shoves the"
	response_disarm = "disarms the"
	response_harm = "hits the"
	speak = list("PROTECT THE RESEARCH!", "INCOMING!", "DIE!")
	emote_see = list("karate chops")
	speak_chance = 1
	a_intent = "harm"
	stop_automated_movement_when_pulled = 0
	maxHealth = 75
	health = 75
	speed = -1
	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "karate chops"
	attack_sound = 'sound/weapons/genhit1.ogg'

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 270
	maxbodytemp = 370
	temp_damage = 10
	unsuitable_atoms_damage = 10






/mob/living/simple_animal/hostile/retaliate/human/trader
	name = "Trader"
	icon_state = "spaceexplorer"
	icon_living = "spaceexplorer"
	icon_dead = "spaceexplorer_dead"
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
	speak_chance = 5
	a_intent = "harm"
	speak_chance = 5
	atmos_immune = 1
	faction = "Station"
	speak_emote = list("says")
	status_flags = CANPUSH
	ranged = 1
	var/weapon1
	var/weapon2
	rapid = 0
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	projectiletype = /obj/item/projectile/beam/pulse/heavy
	weapon1 = /obj/item/weapon/gun/energy/taser
	var/knows = 0
	var/retaliate = 0 //He hits me once shame one me; he hits me thrice he is doomed.
	var/obj/item/itemwant = null
	var/obj/item/itemgive = null
	var/itemwantname = null
	var/itemgivename = null


/mob/living/simple_animal/hostile/retaliate/human/trader/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!enemies.len && prob(10))
			say("Got a [itemwantname]? I'll give you a [itemgivename]!")

/mob/living/simple_animal/hostile/retaliate/human/trader/proc/stoutshako()
	switch(rand(1,11))		// WTS SHIT
		if(1 to 2 )
			var/obj/item/weapon/storage/toolbox/mechanical/P = new /obj/item/weapon/storage/toolbox/mechanical(src)
			itemwant = P
			itemwantname = P.name
		if(3 to 4)
			var/obj/item/weapon/hatchet/P = new /obj/item/weapon/hatchet(src)
			itemwant = P
			itemwantname = P.name
		if(5 to 5)
			var/obj/item/weapon/tank/oxygen/P = new /obj/item/weapon/tank/oxygen(src)
			itemwant = P
			itemwantname = P.name
		if(6 to 7)
			var/obj/item/device/violin/P = new /obj/item/device/violin(src)
			itemwant = P
			itemwantname = P.name
		if(8 to 9)
			var/obj/item/weapon/storage/firstaid/regular/P = new /obj/item/weapon/storage/firstaid/regular(src)
			itemwant = P
			itemwantname = P.name
		if(10 to 11)
			var/obj/item/weapon/wrench/P = new /obj/item/weapon/wrench(src)
			itemwant = P
			itemwantname = P.name

	switch(rand(1,11))		// WTB SHIT
		if(1 to 2 )
			var/obj/item/weapon/storage/toolbox/syndicate/P = new /obj/item/weapon/storage/toolbox/syndicate(src)
			itemgive = P
			itemgivename = P.name
		if(3 to 4)
			var/obj/item/weapon/storage/box/lunchbox/P = new /obj/item/weapon/storage/box/lunchbox(src)
			itemgive = P
			itemgivename = P.name
		if(5 to 5)
			var/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice/P = new /obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice(src)
			itemgive = P
			itemgivename = P.name
		if(6 to 7)
			var/obj/item/weapon/spacecash/c200/P = new /obj/item/weapon/spacecash/c200(src)
			itemgive = P
			itemgivename = P.name
		if(8 to 9)
			var/obj/item/weapon/melee/classic_baton/P = new /obj/item/weapon/melee/classic_baton(src)
			itemgive = P
			itemgivename = P.name
		if(10 to 11)
			var/obj/item/toy/katana/P = new /obj/item/toy/katana(src)
			P.name = "katana"
			itemgive = P
			itemgivename = P.name

/mob/living/simple_animal/hostile/retaliate/human/trader/New()
	stoutshako()//two refined

/mob/living/simple_animal/hostile/retaliate/human/trader/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I,itemwant))
		if(knows)
			say("Ok lets do this!")
			user.drop_item()
			del(I)
			itemgive.loc = src.loc
			stoutshako()
			knows = 0

		else
			src.say("You sure you want to go through with this? Give it to me and we will trade.")
			knows = 1
		return

/mob/living/simple_animal/hostile/retaliate/human/trader/attack_hand(mob/living/user as mob)
	say("Got a [itemwantname]? I'll give you a [itemgivename]!")
/*
/mob/living/simple_animal/hostile/retaliate/human/trader/Retaliate()
	if(retaliate == 0)
		src.say("HEY! Cut it out!")
		retaliate += 1
		return
	if(retaliate == 1)
		src.say("You have one more chance to stop!")
		retaliate += 1
		return
	if(retaliate >= 2)

		..()
		var/list/around = view(src, 7)

		for(var/atom/movable/A in around)
			if(A == src)
				continue
			if(isliving(A))
				var/mob/living/M = A
				if(!attack_same && M.faction != faction)
					enemies |= M
			else if(istype(A, /obj/mecha))
				var/obj/mecha/M = A
				if(M.occupant)
					enemies |= M
					enemies |= M.occupant

		for(var/mob/living/simple_animal/hostile/retaliate/H in around)
			if(!attack_same && !H.attack_same && H.faction == faction)
				H.enemies |= enemies
		return 0

/mob/living/simple_animal/hostile/retaliate/human/trader/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(!stat)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				DestroySurroundings()
				AttackTarget()

/mob/living/simple_animal/hostile/retaliate/human/trader/OpenFire(target_mob)
	if(prob(48))
		projectilesound = 'sound/weapons/lasercannonfire.ogg'
		projectiletype = /obj/item/projectile/beam/pulse/heavy
	else
		projectilesound = 'sound/weapons/taser2.ogg'
		projectiletype = /obj/item/projectile/energy/electrode
	var/target = target_mob
	visible_message("\red <b>[src]</b> fires at [target]!", 1)

	var/tturf = get_turf(target)
	if(rapid)
		spawn(1)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(4)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
		spawn(6)
			Shoot(tturf, src.loc, src)
			if(casingtype)
				new casingtype(get_turf(src))
	else
		Shoot(tturf, src.loc, src)
		if(casingtype)
			new casingtype

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return


/mob/living/simple_animal/hostile/retaliate/human/trader/Bump(obj/item/I as obj)
	if(istype(I,/obj/item/projectile/energy/electrode))
		target_mob = null
		stance = HOSTILE_STANCE_IDLE
		resting = 1
		icon_state = "spaceexplorer_dead"
		icon_living = "spaceexplorer_dead"
		sleep(500)
		icon_state = "spaceexplorer"
		icon_living = "spaceexplorer"
		resting = 0
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/retaliate/human/trader/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets()))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1



*/







/mob/living/simple_animal/hostile/retaliate/human/harmbaton
	name = "Officer Harmbaton"
	desc = "He will pacify you in death with handcuffs!"
	icon_state = "harmbaton"
	icon_living = "harmbaton"
	icon_dead = "harmbaton_dead"
	speak = list("I AM THE LAW!","If you are not my kin; you are for the cells!", "Stop right there traitorous scum!", "You will be pacified in death with handcuffs!")
	speak_chance = 3
	turns_per_move = 10
	see_in_dark = 30
	response_help  = "taps"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	faction = "syndicate"
	health = 100
	maxHealth = 100
	attacktext = "harmbatons"
	attack_sound = 'sound/weapons/genhit1.ogg'
	melee_damage_lower = 5
	melee_damage_upper = 15
	var/condition = 0 //So he says


/obj/item/projectile/energy/cuffs
	name = "handcuffs"
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"

	on_hit(var/atom/target, var/blocked = 0)
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/M = target
			M.handcuffed = new /obj/item/weapon/handcuffs(M)
			M.update_inv_handcuffed()	//update the handcuffs overlay
		return 1


/mob/living/simple_animal/hostile/retaliate/human/harmbaton/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!enemies.len && prob(1))
			condition = 1
			Retaliate()

		if(enemies.len && prob(1)) //A higher chance that most people because harmbatons
			enemies = list()
			condition = 0
			LoseTarget()
			src.visible_message("\blue [src] has a vacant braindead stare.")

/mob/living/simple_animal/hostile/retaliate/human/harmbaton/Retaliate()
	..()
	if(health >= 1)
	else
		return



//Down on the job? Harmbaton don't care
//Before you ask why there are multiple if statements when they could be more shortened; I have things planned for the future.
/mob/living/simple_animal/hostile/retaliate/human/harmbaton/Move()
	..()
	if(!stat)
		var/cuffing = 0
		if(locate(/mob/living/carbon/human) in loc)
			var/mob/living/carbon/human/SV = locate(/mob/living/carbon/human) in loc
			if(SV.stat == 2)
				if(cuffing)
					return
				cuffing = 1
				playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
				visible_message("\red <B>[src] is trying to put handcuffs on [SV.name]!</B>")
				spawn(60)
					if(get_dist(src, SV) <= 1)
						if(SV.handcuffed)
							return
						if(istype(SV,/mob/living/carbon))
							cuffing = 0
							SV.handcuffed = new /obj/item/weapon/handcuffs(SV)
							say("I pacify you in death!")
							SV.update_inv_handcuffed()	//update the handcuffs overlay
					else
						cuffing = 0
			if(SV.paralysis >= 1)
				if(cuffing)
					return
				cuffing = 1
				playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
				visible_message("\red <B>[src] is trying to put handcuffs on [SV.name]!</B>")
				spawn(60)
					if(get_dist(src, SV) <= 1)
						if(SV.handcuffed)
							return
						if(istype(SV,/mob/living/carbon))
							SV.handcuffed = new /obj/item/weapon/handcuffs(SV)
							say("Your under arrest! If you die you will be pacified in death!")
							SV.update_inv_handcuffed()	//update the handcuffs overlay
							cuffing = 0
					else
						cuffing = 0
			if(SV.resting == 1)
				if(cuffing)
					return
				cuffing = 1
				playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
				visible_message("\red <B>[src] is trying to put handcuffs on [SV.name]!</B>")
				spawn(60)
					if(get_dist(src, SV) <= 1)
						if(SV.handcuffed)
							return
						if(istype(SV,/mob/living/carbon))
							cuffing = 0
							SV.handcuffed = new /obj/item/weapon/handcuffs(SV)
							say("Lying on the job? Not on my watch!")
							SV.update_inv_handcuffed()	//update the handcuffs overlay
					else
						cuffing = 0



/mob/living/simple_animal/hostile/retaliate/human/harmbaton/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(12))
			L.deal_damage(3, WEAKEN)
			attack_sound = 'sound/weapons/Egloves.ogg'
		else
			attack_sound = 'sound/weapons/genhit1.ogg'
/*


			if(istype(src.target,/mob/living/carbon))
				if(!src.target.handcuffed && !src.arrest_type)
					playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					mode = SECBOT_ARREST
					visible_message("\red <B>[src] is trying to put handcuffs on [src.target]!</B>")

					spawn(60)
						if(get_dist(src, src.target) <= 1)
							if(src.target.handcuffed)
								return

							if(istype(src.target,/mob/living/carbon))
								target.handcuffed = new /obj/item/weapon/handcuffs(target)
								target.update_inv_handcuffed()	//update the handcuffs overlay

							mode = SECBOT_IDLE
							src.target = null
							src.anchored = 0
							src.last_found = world.time
							src.frustration = 0

							playsound(src.loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0)
		//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
		//					src.speak(arrest_message)
			else





*/






proc/Path_set(var/atom/movable/M, list/sequence, delay = 10, distance = 1, Rand_step_interval = 0, loop = 0)
	var/valid = list(NORTH, SOUTH, EAST, WEST, NORTHWEST, SOUTHEAST, NORTHEAST ,SOUTHWEST)
	var/list/path = list()
	var/list/rand_sequence = list()
	do
		rand_sequence = list(null)
		path = list(null)
		if(length(sequence) < 1)
			while(length(rand_sequence) <4)
				var/N = pick(NORTH, SOUTH, EAST, WEST)
				rand_sequence += N
				sleep(1)
		if(Rand_step_interval && delay <5)
			delay = 5
		if(length(sequence) < 1)
			for(var/P in rand_sequence)
				path += P
		else
			for(var/P in sequence)
				path += P

		for(var/D in path)
			if(D in valid)
				var/repeats = round(distance*32/M.step_size)
				while(repeats > 0)
					step(M, D)
					sleep(1)
					repeats --
			if(Rand_step_interval)
				sleep(rand(delay-5,delay+5))
			else
				sleep(delay)
	while(loop)



