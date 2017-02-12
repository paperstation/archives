/mob/living/carbon/human/var/ai_laststep = 0
/mob/living/carbon/human/var/ai_state = 0
/mob/living/carbon/human/var/ai_threatened = 0
/mob/living/carbon/human/var/ai_movedelay = 6
/mob/living/carbon/human/var/ai_pounced = 0
/mob/living/carbon/human/var/ai_attacked = 0
/mob/living/carbon/human/var/ai_frustration = 0
/mob/living/carbon/human/var/ai_throw = 0

//NOTE TO SELF: BYONDS TIMING FUNCTIONS ARE INACCURATE AS FUCK
//ADD HELP INTEND.

//0 = Pasive, 1 = Getting angry, 2 = Attacking , 3 = Helping, 4 = Idle , 5 = Fleeing(??)

/mob/living/carbon/human/proc/ai_init()
	ai_active = 1
	ai_laststep = 0
	ai_state = 0
	ai_target = null
	ai_threatened = 0
	ai_movedelay = 1
	ai_attacked = 0
	ai_loop()

/mob/living/carbon/human/proc/ai_loop()
	if(client)
		ai_active = 0
		return

	spawn(0)

		while (ai_active)

			if (stat == 2)
				ai_active = 0
				ai_target = 0
				return

			if(ai_incapacitated())
				sleep(10)
				continue

			var/turf/simulated/T = get_turf(src)
			if(!istype(get_turf(src), /turf/space) && (T.toxins > 500.0 || T.active_hotspot || T.oxygen < (MOLES_O2STANDARD/2) || T.carbon_dioxide > 7500.0))
				if(istype(get_turf(src), /turf/space))
					ai_avoid()
			ai_move()

			ai_action()
			sleep(25)


/mob/living/carbon/human/proc/ai_action()

	switch(ai_state)
		if(0) //Life is good.

			src.a_intent = "disarm"
			if(istype(src.loc, /obj/closet))
				src.ai_freeself()
				return

			ai_pickupweapon()
			ai_obstacle(1)
			ai_openclosets()

			var/tempmob
			for (var/mob/living/carbon/M in view(7,src))
				if ((istype(M, /mob/living/carbon) && !istype(src, /mob/living/carbon/human/retard/violent)) || M.stat == 2 || !M.client || M.stat == 1 || M == src) continue
				if (!tempmob) tempmob = M
				for(var/mob/living/carbon/L in oview(7,src))
					if (L.ai_target == tempmob && prob(66)) continue
				if (M.health < tempmob:health) tempmob = M
			if(tempmob)
				ai_target = tempmob
				ai_state = 1
				ai_threatened = world.timeofday

		if(1)	//WHATS THAT?

			if(istype(src.loc, /obj/closet))
				src.ai_freeself()
				return

			if (get_dist(src,ai_target) > 6)
				ai_target = null
				ai_state = 0
				ai_threatened = 0
				return

			if ( (world.timeofday - ai_threatened) > 20 ) //Oh, it is on now! >:C
				ai_state = 2
				return

		if(2)	//Gonna kick your ass.

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

			if (ai_frustration >= 100)
				ai_frustration = 0
				ai_target = null
				ai_state = 0

			if(target.stat == 2 || distance > 7 || (!src.see_invisible && target.invisibility) || (target.stat == 1 && prob(25)))
				ai_target = null
				ai_state = 0
				src.say(pick("I'm bored!", "Screw this", "I lost 'em"))
				for (var/mob/G in oviewers())
					if (!G.client) continue
					G << "\red [src] loses interest."
				return

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

			if(prob(75) && distance > 1 && (world.timeofday - ai_attacked) > 100 && ai_validpath() && ((istype(src.r_hand, /obj/item/weapon/gun/revolver) && src.r_hand:bullets) || (istype(src.r_hand, /obj/item/weapon/gun/fiveseven) && src.r_hand:bullets) || (istype(src.r_hand, /obj/item/weapon/gun/energy) && src.r_hand:charges)))
				var/obj/item/weapon/gun/W = src.r_hand
				W.afterattack(target, src, 0)
				if(prob(10))
					switch(pick(1,2))
						if(1)
							hearers(src) << "<B>[src.name]</B> makes machine-gun noises with \his mouth."
						if(2)
							src.say(pick("BANG!", "POW!", "Eat lead, [target.name]!", "Suck it down, [target.name]!"))

			if((prob(33) || ai_throw) && distance > 1 && ai_validpath() && src.r_hand && !((istype(src.r_hand,/obj/item/weapon/gun/revolver) && src.r_hand:bullets) || (istype(src.r_hand, /obj/item/weapon/gun/fiveseven) && src.r_hand:bullets) || (istype(src.r_hand, /obj/item/weapon/gun/energy) && src.r_hand:charges)))
				var/obj/item/temp = src.r_hand
				temp.loc = src.loc
				src.r_hand = null
				temp.throw_at(target, 7, 1)
				for (var/mob/G in view(7,src))
					if (!G.client) continue
					G << "\red [src] throws the [temp] at [ai_target]."

			if(distance <= 1 && (world.timeofday - ai_attacked) > 100 && !ai_incapacitated() && ai_meleecheck())
				var/obj/item/temp = src.r_hand
				if(prob(10))
					src.say(pick("Fuck you [target.name]!", "You're [prob(10) ? "fucking " : ""]dead, [target.name]!", "I'm gonna kill you [target.name]!!"))
				if(!src.r_hand)
					if(prob(25))
						target.attack_paw(src) // retards bite
						for(var/mob/O in viewers(ai_target, null))
							O.show_message(text("\red <B>[src.name] bites []!</B>", ai_target))
					else
						target.attack_hand(src) //We're a human!
						for(var/mob/O in viewers(ai_target, null))
							O.show_message(text("\red <B>[src.name] has punched []!</B>", ai_target))
				else
					target.attackby(src.r_hand, src) //With a weapon ...
					for(var/mob/O in viewers(ai_target, null))
						O.show_message(text("\red <B>[] has been attacked with [][] </B>", ai_target, temp, (src ? text(" by [].", src) : ".")), 1)

			if( (distance == 3) && (world.timeofday - ai_pounced) > 180 && ai_validpath())
				if(valid)
					ai_pounced = world.timeofday
					for (var/mob/G in view(7,src))
						if (!G.client) continue
						G << "\red [src] lunges at [ai_target]."

					if(((istype(target.r_hand, /obj/item/weapon/shield) || istype(target.l_hand, /obj/item/weapon/shield)) && prob(80)) || (istype(target.r_hand, /obj/item/weapon/shield) && istype(target.l_hand, /obj/item/weapon/shield) && prob(50)))
						if(src.buckled) return
						ai_target << "\blue You manage to block the attack with your shield."
						spawn(0)
							step_towards(src,ai_target)
							step_towards(src,ai_target)
					else
						if(src.buckled) return
						if(ai_target:weakened < 2) ai_target:weakened += 2
						spawn(0)
							step_towards(src,ai_target)
							step_towards(src,ai_target)

/mob/living/carbon/human/proc/ai_move()
	if(ai_incapacitated() || !ai_canmove()) return
	if( ai_state == 0 && ai_canmove() ) step_rand(src)
	if( ai_state == 2 && ai_canmove() )
		if(!ai_validpath() && get_dist(src,ai_target) <= 1)
			dir = get_step_towards(src,ai_target)
			ai_obstacle() //Remove.
		else
			step_towards(src,ai_target)

/mob/living/carbon/human/proc/ai_pickupweapon()

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

/mob/living/carbon/human/proc/ai_botany()

	for (var/obj/machinery/hydroponics/H in view(7,src))
		if(H.waterlevel <= 20)
			ai_pickupbucket()
			if(!ai_validpath() && get_dist(src,H) <= 1)
				dir = get_step_towards(src,H)
				ai_obstacle() //Remove.
				if((get_dist(src,H) <= 1) && (istype(src.r_hand, /obj/item/weapon/reagent_containers/glass/bucket)))
					attack_hand(src)
			else
				step_towards(src,H)
			drop_item()



/mob/living/carbon/human/proc/ai_avoid(/*var/turf/simulated/T*/)
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
	if(T.toxins > 1.0)
		for (var/dir1 in list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST))
			testturf = get_step(T,dir1)
			if (testturf.toxins < tempturf.toxins)
				tempdir = dir1
				tempturf = testturf
	else if(T.carbon_dioxide > 20.0)
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


/mob/living/carbon/human/proc/ai_canmove()
	if(!istype(src.loc,/turf)) return 0
	var/speed = (5 * ai_movedelay)
	if (!ai_laststep) ai_laststep = (world.timeofday - 5)
	if ((world.timeofday - ai_laststep) >= speed) return 1
	else return 0

/mob/living/carbon/human/proc/ai_incapacitated()
	if(stat || stunned || paralysis || eye_blind || weakened) return 1
	else return 0

/mob/living/carbon/human/proc/ai_validpath()

	var/list/L = new/list()

	var/mob/living/target = ai_target

	if(!istype(src.loc,/turf)) return 0

	if(!target) return 0 //WTF

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

/mob/living/carbon/human/proc/ai_meleecheck() //Simple right now.
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



/mob/living/carbon/human/proc/ai_freeself()
	if(!istype(src.loc, /obj/closet)) return
	var/obj/closet/C = src.loc
	if (C.opened)
		C.close()
		sleep(5)
		C.open()
	else
		C.open()

/mob/living/carbon/human/proc/ai_obstacle(var/doorsonly)

	var/acted = 0

	if(ai_incapacitated()) return

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
		if(W.density) W.attack_hand(src)
	else if((locate(/obj/machinery/door) in get_turf(src.loc)))
		var/obj/machinery/door/W = (locate(/obj/machinery/door) in get_turf(src.loc))
		if(W.density) W.attack_hand(src)

/mob/living/carbon/human/proc/ai_openclosets()
	if(ai_incapacitated()) return
	for(var/obj/closet/C in view(1,src)) C.open()
	for(var/obj/secure_closet/S in view(1,src))
		if(!S.opened && !S.locked) attack_hand(src)

/mob/living/carbon/human/proc/ai_pickupbucket()

	var/obj/item/weapon/pickup

	for (var/obj/item/weapon/reagent_containers/glass/bucket/G in view(7,src))
		if(!istype(G.loc, /turf) || G.anchored) continue
		if(!src.r_hand && !pickup)
			pickup = G

	if(src.r_hand && pickup)
		src.r_hand:loc = get_turf(src)
		src.r_hand = null

	if(pickup && !src.r_hand)
		pickup.loc = src
		src.r_hand = pickup

	pickup.reagents.clear_reagents()
	pickup.reagents.add_reagent("water", 50)