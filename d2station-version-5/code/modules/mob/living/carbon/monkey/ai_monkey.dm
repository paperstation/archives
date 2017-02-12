/mob/var/ai_active = 0

/mob/living/carbon/monkey/var/ai_movedelay = 10
/mob/living/carbon/monkey/var/ai_canmove = 1

/mob/living/carbon/monkey/var/ai_attackdelay = 12
/mob/living/carbon/monkey/var/ai_canattack = 1

/mob/living/carbon/monkey/var/ai_specialdelay = 40
/mob/living/carbon/monkey/var/ai_canspecial = 1

/mob/living/carbon/monkey/var/ai_obstacledelay = 10
/mob/living/carbon/monkey/var/ai_canobstacle = 1

/mob/living/carbon/monkey/var/ai_state = 0
/mob/var/ai_target = null

/mob/living/carbon/monkey/var/ai_frustration = 0
/mob/living/carbon/monkey/var/ai_throw = 0
/mob/living/carbon/monkey/var/list/ai_friends = new/list()
/mob/living/carbon/monkey/var/ai_friendtarget = null

//0 = Idle, 1 = Thinking(TBI), 2 = Attacking , 3 = Helping(TBI)
//Sadly, i have to use variables and spawn() because the worlds time vars wont work right.
//This will almost definitely make monkeys much laggier as there will always be multiple
//spawns per monkey active.

/mob/living/carbon/monkey/proc/ai_init()
	ai_active = 1
	ai_canspecial = 1
	ai_canattack = 1
	ai_canmove = 1
	ai_canobstacle = 1
	ai_loop()

/mob/living/carbon/monkey/proc/ai_loop()

	ai_active = 0
	return

	if(client)
		ai_active = 0
		return

	spawn(0)
		while (ai_active)

			if (stat == 2)
				ai_active = 0
				ai_target = null
				return

			if(ai_incapacitated())
				sleep(10)
				continue

			var/turf/simulated/T = get_turf(src)
			if((T.toxins > 500.0 || T.active_hotspot || T.oxygen < (MOLES_O2STANDARD/2) || T.carbon_dioxide > 7500.0) && !istype(get_turf(src), /turf/space) ) ai_avoid()
			ai_move()

			ai_action()
			sleep(1)


/mob/living/carbon/monkey/proc/ai_action()

	switch(ai_state)
		if(0)

			src.a_intent = "disarm"

			ai_target = null

			if(istype(src.loc, /obj/closet))
				src.ai_freeself()
				return

			ai_pickupweapon()
			ai_obstacle(1)
			ai_openclosets()

			var/tempmob = null

			for (var/mob/living/carbon/M in oview(7,src))

				if ( istype(M, /mob/living/carbon/monkey) || M.stat == 1 || M.stat == 2 || M == src) continue

				if (!tempmob) tempmob = M

				for(var/mob/living/carbon/L in oview(7,src))
					if (L.ai_target == tempmob && prob(66)) continue

				if (M.health < tempmob:health) tempmob = M

			if(tempmob)
				ai_target = tempmob
				ai_state = 2

		if(1)

			src.a_intent = "disarm"
			ai_frustration = 0
			ai_target = null
			ai_state = 0

		if(2)

			src.a_intent = "hurt"

			var/mob/living/carbon/target = ai_target

			if(!target || ai_target == src)
				ai_frustration = 0
				ai_target = null
				ai_state = 0

			var/valid = ai_validpath()
			var/distance = get_dist(src,ai_target)

			ai_obstacle(0)
			ai_openclosets()
			ai_pickupweapon()

			if(istype(src.loc, /obj/closet))
				src.ai_freeself()
				return

			//if (target in ai_friends) ai_friends -= target //We're no longer friends >:(

			if (ai_frustration >= 100)
				ai_frustration = 0
				ai_target = null
				ai_state = 0

			if(target.stat == 2 || distance > 7 || (target.stat == 1 && prob(25)) )
				ai_target = null
				ai_state = 0
				target = null
				for (var/mob/G in view(7,src))
					if (!G.client) continue
					G << "\red [src] loses interest."
				return

			if(distance <= 1 && ai_canattack && !ai_incapacitated() && ai_meleecheck())

				ai_canattack = 0
				spawn(ai_attackdelay) ai_canattack = 1

				if(!src.r_hand)
					target.attack_paw(src) //We're a monkey!
				else
					src.r_hand:attack(target, src) //With a weapon ...


			if(ai_canspecial)

				ai_canspecial = 0
				spawn(ai_specialdelay) ai_canspecial = 1

				if((prob(33) || ai_throw) && distance > 1 && ai_validpath() && src.r_hand)// && !istype(src.r_hand,/obj/item/weapon/gun)) MONKEYS ARE STUPID.
					var/obj/item/temp = src.r_hand
					temp.loc = src.loc
					src.r_hand = null
					temp.throw_at(target, 7, 1)
					for (var/mob/G in view(7,src))
						if (!G.client) continue
						G << "\red [src] throws the [temp] at [ai_target]."

				if( (distance == 3) && ai_validpath())
					if(valid)

						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] lunges at [ai_target]."

						if(((istype(target.r_hand, /obj/item/weapon/shield) || istype(target.l_hand, /obj/item/weapon/shield)) && prob(80)) || (istype(target.r_hand, /obj/item/weapon/shield) && istype(target.l_hand, /obj/item/weapon/shield) && prob(50)))
							if(src.buckled) return
							ai_target << "\blue You manage to block the attack with your shield."
							spawn(0)
								step_towards(src,ai_target)
								step_towards(src,ai_target)

						else if(istype(target.r_hand, /obj/item/weapon/reagent_containers/food/snacks/grown/banana) || istype(target.l_hand, /obj/item/weapon/reagent_containers/food/snacks/grown/banana))
							var/obj/item/weapon/reagent_containers/food/snacks/grown/banana/banananana
							if(istype(target.r_hand, /obj/item/weapon/reagent_containers/food/snacks/grown/banana)) banananana = target.r_hand
							else if(istype(target.l_hand, /obj/item/weapon/reagent_containers/food/snacks/grown/banana)) banananana = target.l_hand
							spawn(0)
								step_towards(src,ai_target)
								step_towards(src,ai_target)
							if (!banananana) return //fuck.
							for (var/mob/G in view(7,src))
								if (!G.client) continue
								G << "\blue [src] is distracted by the banana."
							del(banananana)
							src.stunned += 5 //Hahaha im so lazy

						else
							if(src.buckled) return
							if(ai_target:weakened < 2) ai_target:weakened += 2
							spawn(0)
								step_towards(src,ai_target)
								step_towards(src,ai_target)


/mob/living/carbon/monkey/proc/ai_move()
	if(ai_incapacitated() || !ai_canmove()) return
	if( ai_state == 0 && ai_canmove() ) step_rand(src)
	if( ai_state == 2 && ai_canmove() && get_dist(src,ai_target) > 1)
		if(!ai_validpath() && get_dist(src,ai_target) <= 1)
			dir = get_step_towards(src,ai_target)
			ai_obstacle()
		else
			step_towards(src,ai_target)

	ai_canmove = 0
	spawn(ai_movedelay) ai_canmove = 1

/mob/living/carbon/monkey/proc/ai_pickupweapon()

	var/obj/item/weapon/pickup

	for (var/obj/item/weapon/G in view(1,src))
		if(!istype(G.loc, /turf) || G.anchored) continue
		if(!src.r_hand && !pickup && G.force > 3)
			pickup = G
		else if(!src.r_hand && pickup && G.force > 3)
			if(G.force > pickup.force) pickup = G
		else if(src.r_hand && !pickup && G.force > 3)
			if(src:r_hand:force < G.force) pickup = G
		else if(src.r_hand && pickup && G.force > 3)
			if(pickup.force < G.force) pickup = G

	if(src.r_hand && pickup)
		src.r_hand:loc = get_turf(src)
		src.r_hand = null

	if(pickup && !src.r_hand)
		pickup.loc = src
		src.r_hand = pickup


/mob/living/carbon/monkey/proc/ai_avoid()
	if(ai_incapacitated()) return

	var/turf/simulated/T = get_turf(src)
	var/turf/simulated/tempturf = T
	var/tempdir = null
	var/turf/simulated/testturf = null

	if(T.active_hotspot)
		for (var/dir1 in list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST))
			testturf = get_step(T,dir1)
			if (testturf.active_hotspot < tempturf.active_hotspot)
				tempdir = dir1
				tempturf = testturf
	if(T.toxins > 5000.0)
		for (var/dir1 in list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST))
			testturf = get_step(T,dir1)
			if (testturf.toxins < tempturf.toxins)
				tempdir = dir1
				tempturf = testturf
	else if(T.carbon_dioxide > 5000.0)
		for (var/dir1 in list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST))
			testturf = get_step(T,dir1)
			if (testturf.carbon_dioxide < tempturf.carbon_dioxide)
				tempdir = dir1
				tempturf = testturf
	else if (T.oxygen < (MOLES_O2STANDARD/2))
		for (var/dir1 in list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST))
			testturf = get_step(T,dir1)
			if (testturf.oxygen > tempturf.oxygen)
				tempdir = dir1
				tempturf = testturf

	step(src,tempdir)


/mob/living/carbon/monkey/proc/ai_canmove()
	if(!istype(src.loc,/turf)) return 0
	else if(ai_canmove) return 1

/mob/living/carbon/monkey/proc/ai_incapacitated()
	if(stat || stunned || paralysis || eye_blind || weakened) return 1
	else return 0

/mob/living/carbon/monkey/proc/ai_validpath()

	if(!ai_target || !istype(src.loc,/turf)) return 0 //HOW DOES THIS EVEN HAPPEN?

	var/list/L = new/list()
	var/mob/living/target = ai_target

	L = getline(src,target)

	for (var/turf/T in L)
		if (T.density)
			ai_frustration += 3
			return 0
		for (var/obj/D in T)
			if (D.density && !istype(D, /obj/closet) && D.anchored)
				ai_frustration += 3
				return 0
			else if (istype(D, /obj/closet))
				if(D:opened == 0) return 0

	return 1

/mob/living/carbon/monkey/proc/ai_meleecheck() //Simple right now.
	var/targetturf = get_turf(ai_target)
	var/myturf = get_turf(src)

	if(!istype(src.loc,/turf)) return 0

	if(locate(/obj/machinery/door/window) in myturf)
		for (var/obj/machinery/door/window/W in myturf)
			if(!W.CheckExit(src,targetturf)) return 0

	if(locate(/obj/machinery/door/window) in targetturf)
		for (var/obj/machinery/door/window/W in targetturf)
			if(!W.CheckPass(src,targetturf)) return 0

	return 1

/mob/living/carbon/monkey/proc/ai_freeself()
	if(!istype(src.loc, /obj/closet)) return
	var/obj/closet/C = src.loc
	if (C.opened) //This shouldnt happen.
		C.close()
	else
		C.open()

/mob/living/carbon/monkey/proc/ai_obstacle(var/doorsonly)

	if(ai_incapacitated() || !ai_canobstacle) return

	var/acted = 0

	if(src.r_hand && !doorsonly) //So they dont smash windows while wandering around.
		if((locate(/obj/window) in get_step(src,dir))  && !acted)
			var/obj/window/W = (locate(/obj/window) in get_step(src,dir))
			W.attackby(src.r_hand, src)
			acted = 1
		else if((locate(/obj/window) in get_turf(src.loc))  && !acted)
			var/obj/window/W = (locate(/obj/window) in get_turf(src.loc))
			W.attackby(src.r_hand, src)
			acted = 1
		if((locate(/obj/grille) in get_step(src,dir))  && !acted)
			var/obj/grille/G = (locate(/obj/grille) in get_step(src,dir))
			if(!G.destroyed)
				G.attackby(src.r_hand, src)
				acted = 1

	if((locate(/obj/machinery/door) in get_step(src,dir)))
		var/obj/machinery/door/W = (locate(/obj/machinery/door) in get_step(src,dir))
		if(W.density) W.attack_paw(src)
	else if((locate(/obj/machinery/door) in get_turf(src.loc)))
		var/obj/machinery/door/W = (locate(/obj/machinery/door) in get_turf(src.loc))
		if(W.density) W.attack_paw(src)

	if(acted)
		ai_canobstacle = 0
		spawn(ai_obstacledelay) ai_canobstacle = 1

/mob/living/carbon/monkey/proc/ai_openclosets()
	if(ai_incapacitated()) return
	for(var/obj/closet/C in view(1,src)) C.open()
	for(var/obj/secure_closet/S in view(1,src))
		if(!S.opened && !S.locked) attack_paw(src)

/proc/toggleai(var/mob/M in mobz)
	if(!M.ai_active)
		M:ai_init()
	else
		M.ai_active = 0







//UNUSED STUFF BELOW

			/*
			if((target.weakened || target.stunned || target.paralysis) && istype(target.wear_mask, /obj/item/clothing/mask) && distance <= 1 && prob(75) && !ai_incapacitated())
				var/mask = target.wear_mask
				target.u_equip(mask)
				if (target.client)
					target.client.screen -= mask
				if (mask)
					mask:loc = target:loc
					mask:dropped(target)
					mask:layer = initial(mask:layer)
				for (var/mob/G in view(7,src))
					if (!G.client) continue
					G << "\red [src] rips off [ai_target]'s [mask]."

			else if ((target.weakened || target.stunned || target.paralysis) && target:wear_suit && distance <= 1 && prob(10) && !src.r_hand && !ai_incapacitated())
				var/suit = target:wear_suit
				target.u_equip(suit)
				if (target.client)
					target.client.screen -= suit
				if (suit)
					suit:loc = target:loc
					suit:dropped(target)
					suit:layer = initial(suit:layer)
				for (var/mob/G in view(7,src))
					if (!G.client) continue
					G << "\red [src] rips off [ai_target]'s [suit]."
			*/


