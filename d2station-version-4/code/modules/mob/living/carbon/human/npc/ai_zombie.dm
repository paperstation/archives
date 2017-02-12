/mob/living/carbon/human/var/ai_laststep_zombie = 0
/mob/living/carbon/human/var/ai_state_zombie = 0
/mob/living/carbon/human/var/ai_threatened_zombie = 0
/mob/living/carbon/human/var/ai_move_zombiedelay = 6
/mob/living/carbon/human/var/ai_pounced_zombie = 0
/mob/living/carbon/human/var/ai_attacked_zombie = 0
/mob/living/carbon/human/var/ai_frustration_zombie = 0
/mob/living/carbon/human/var/ai_throw_zombie = 0
/mob/living/carbon/human/var/trollface = 6
/mob/living/carbon/human/var/mob/living/carbon/human/tempmob
/mob/living/carbon/human/var/ai_target_zombie
/mob/living/carbon/human/var/ai_active_zombie
var/global/list/mob/living/carbon/human/zombies = list()

//NOTE TO SELF: BYONDS TIMING FUNCTIONS ARE INACCURATE AS FUCK
//ADD HELP INTEND.

//0 = Passive, 1 = Getting angry, 2 = Attacking , 3 = Helping, 4 = Idle , 5 = Fleeing(??)

/mob/living/carbon/human/proc/ai_init_zombie()
	ai_active_zombie = 1
	ai_laststep_zombie = 0
	ai_state_zombie = 0
	ai_target_zombie = null
	ai_threatened_zombie = 0
	ai_move_zombiedelay = 1
	ai_attacked_zombie = 0
	ai_loop_zombie()
	trollface = rand(8,15)
	if(prob(1))
		trollface = rand(4,8)

/mob/living/carbon/human/proc/ai_loop_zombie()
	if(client)
		ai_active_zombie = 0
		return

	spawn(0)

		while (ai_active_zombie)
			zombies += src
			if (stat == 2)
				ai_active_zombie = 0
				ai_target_zombie = 0
				return

			if(ai_incapacitated_zombie())
				sleep(10)
				continue

			/*var/turf/simulated/T = get_turf(src)
			if(!istype(get_turf(src), /turf/space) && (T.toxins > 500.0 || T.active_hotspot || T.oxygen < (MOLES_O2STANDARD/2) || T.carbon_dioxide > 7500.0))
				if(istype(get_turf(src), /turf/space))
					ai_avoid()*/
			ai_move_zombie()

			ai_action_zombie()
			sleep(trollface)

/mob/living/carbon/human/proc/ai_action_zombie()

	switch(ai_state_zombie)
		if(0) //Life is good.
			src.zone_sel = new /obj/screen/zone_sel( null )
			src.zone_sel.selecting = pick("head","chest")
			src.a_intent = "disarm"
			if(istype(src.loc, /obj/closet))
				src.ai_freeself_zombie()
				return

			ai_pickupweapon_zombie()
			ai_obstacle_zombie(1)
			ai_openclosets_zombie()
			if(!zombiez_on)
				zombiez_on = 1
//			var/tempmob

//			for (var/mob/living/carbon/M in view(7,src))
//				if ((istype(M, /mob/living/carbon) && !istype(src, /mob/living/carbon/human/zombie)) || M.stat == 2 || !M.client || M.stat == 1 || M == src) continue
//				if (!tempmob) tempmob = M
//				for(var/mob/living/carbon/L in oview(7,src))
//					if (L.ai_target_zombie == tempmob && prob(66)) continue
//				if (M.health < tempmob:health) tempmob = M
			if(tempmob)
				ai_target_zombie = tempmob
				ai_state_zombie = 1
				ai_threatened_zombie = world.timeofday
			sleep(-1)

		if(1)	//WHATS THAT?

			if(istype(src.loc, /obj/closet))
				src.ai_freeself_zombie()
				return

			if (get_dist(src,ai_target_zombie) > 20)
				ai_target_zombie = null
				ai_state_zombie = 0
				ai_threatened_zombie = 0
				if(prob(5))
					src.say(pick("brrrannngggee", "imshhuuu drrrrnnnnghh", "rrggrrggggghhh"))
				return

			if ( (world.timeofday - ai_threatened_zombie) > 20 ) //Oh, it is on now! >:C
				ai_state_zombie = 2
				if(prob(5))
					src.say(pick("SSSCCHRRARAAAAAAAA!", "RAAAAAAAAAAAAAAAAAAAA!", "RRGGHHHRHHRHHGGHRRRRRRRR RAAEAAAAAAAAA"))
				return

		if(2)	//Gonna kick your ass.

			src.a_intent = "hurt"

			var/mob/living/carbon/target = ai_target_zombie

			if(!target || ai_target_zombie == src)
				ai_frustration_zombie = 0
				ai_target_zombie = null
				ai_state_zombie = 0

			var/valid = ai_validpath_zombie()
			var/distance = get_dist(src,ai_target_zombie)

			ai_obstacle_zombie(0)
			ai_openclosets_zombie()
			ai_pickupweapon_zombie()

			if(istype(src.loc, /obj/closet))
				src.ai_freeself_zombie()
				return

			if (ai_frustration_zombie >= 100)
				ai_obstacle_zombie(0)
				ai_obstacle_zombie(0)
				ai_obstacle_zombie(0)

			if (ai_frustration_zombie >= 500)
				ai_frustration_zombie = 0
				ai_target_zombie = null
				ai_state_zombie = 0

			if(target && (target.stat == 2 || distance > 20 || (!src.see_invisible && target.invisibility) || (target.stat == 1 && prob(2))))
				ai_target_zombie = null
				ai_state_zombie = 0
				if(prob(5))
					src.say(pick("hunnnnnng!", "imshhuuu drrrrnnnnghh", "rrggrrggggghhh")) // I hope a lot of people die thinking zombies are drunk. -Nernums
				for (var/mob/G in oviewers())
					if (!G.client) continue
					G << "\red [src] loses interest."
				return

			if((target.weakened || target.stunned || target.paralysis) && istype(target.wear_mask, /obj/item/clothing/mask) && distance <= 1 && prob(75) && !ai_incapacitated_zombie())
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
					G << "\red [src] rips off [ai_target_zombie]'s [mask]."

			else if ((target.weakened || target.stunned || target.paralysis) && target:wear_suit && distance <= 1 && prob(10) && !src.r_hand && !ai_incapacitated_zombie())
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
					G << "\red [src] rips off [ai_target_zombie]'s [suit]."

			else if ((target.weakened || target.stunned || target.paralysis) && distance <= 1 && prob(80) && !src.r_hand && !ai_incapacitated_zombie())
				if(istype(target, /mob/living/carbon/human))
					var/mob/living/carbon/human/fix = target
					if(fix.organ_manager.head == 1 && prob(1))
						fix:removePart(src.organ_manager.head)
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] rips off [ai_target_zombie]'s head!"
					if(fix.organ_manager.l_hand == 1 && prob(1))
						fix:removePart("hand_left")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] chews off [ai_target_zombie]'s hand."
					if(fix.organ_manager.r_hand == 1 && prob(1))
						fix:removePart("hand_right")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] chews off [ai_target_zombie]'s hand."
					if(fix.organ_manager.l_arm == 1 && prob(1))
						fix:removePart("arm_left")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] rips off [ai_target_zombie]'s arm."
					if(fix.organ_manager.r_arm == 1 && prob(1))
						fix:removePart("arm_right")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] rips off [ai_target_zombie]'s arm."
					if(fix.organ_manager.l_foot == 1 && prob(1))
						fix:removePart("foot_left")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] bites off [ai_target_zombie]'s foot."
					if(fix.organ_manager.r_foot == 1 && prob(1))
						fix:removePart("foot_right")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] bites off [ai_target_zombie]'s foot."
					if(fix.organ_manager.l_leg == 1 && prob(1))
						fix:removePart("leg_left")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] rips off [ai_target_zombie]'s leg."
					if(fix.organ_manager.r_leg == 1 && prob(1))
						fix:removePart("leg_right")
						for (var/mob/G in view(7,src))
							if (!G.client) continue
							G << "\red [src] rips off [ai_target_zombie]'s leg."
				if (target && target.client)
					target.reagents.add_reagent("toxin", 5.5)

				for (var/mob/G in view(7,src))
					if (!G.client) continue
					G << "\red [src] chews on [ai_target_zombie]."


			if(prob(75) && distance > 1 && (world.timeofday - ai_attacked_zombie) > 100 && ai_validpath_zombie() && ((istype(src.r_hand, /obj/item/weapon/gun/projectile) && src.r_hand:loaded:len) || (istype(src.r_hand, /obj/item/weapon/gun/energy) && src.r_hand:charges)))
				var/obj/item/weapon/gun/W = src.r_hand
				W.afterattack(target, src, 0)
				if(prob(5))
					switch(pick(1,2))
						if(1)
							hearers(src) << "<B>[src.name]</B> makes groaning noises."
						if(2)
							src.say(pick("RRRUGUGHGEERHHH!", "SCRRAAAAY!", "wnnn urr braaangee, [target.name]!", "SSREEEERREEEEEEEEEEEECREE, [target.name]!"))

			if((prob(33) || ai_throw_zombie) && distance > 1 && ai_validpath_zombie() && src.r_hand && !((istype(src.r_hand, /obj/item/weapon/gun/projectile) && src.r_hand:loaded:len) || (istype(src.r_hand, /obj/item/weapon/gun/energy) && src.r_hand:charges)))
				var/obj/item/temp = src.r_hand
				temp.loc = src.loc
				src.r_hand = null
				temp.throw_at(target, 7, 1)
				for (var/mob/G in view(7,src))
					if (!G.client) continue
					G << "\red [src] throws the [temp] at [ai_target_zombie]."

			if(distance <= 1 && (world.timeofday - ai_attacked_zombie) > 100 && !ai_incapacitated_zombie() && ai_meleecheck_zombie())
				var/obj/item/temp = src.r_hand
				if(prob(10))
					src.say(pick("oh onnii-chann~~ dont look, it is embarassing [target.name]!", " BREEAAAAA!", "GSGREEEHHHAEEEEEEE!!")) //I dare any of you to think of a more fitting line. - Nernums
				if(!src.r_hand)
					if(prob(25))
						if(target)
							target.reagents.add_reagent("stoxin", 1)
					//	target.attack_paw(src) // retards bite
					//	if(prob(50))
					//		target.turnedon = 0
						for(var/mob/O in viewers(ai_target_zombie, null))
							O.show_message(text("\red <B>[src.name] bites []!</B>", ai_target_zombie))
					else

						//target.attack_hand(src) //We're a human!
						if(target)
							target.reagents.add_reagent("stoxin", 0.5)
						//if(prob(50))
						//	target.turnedon = 0
						for(var/mob/O in viewers(ai_target_zombie, null))
							O.show_message(text("\red <B>[src.name] has punched []!</B>", ai_target_zombie))
				else
					if(target)
						target.attackby(src.r_hand, src) //With a weapon ...
					//if(prob(50))
					//	target.turnedon = 0
					for(var/mob/O in viewers(ai_target_zombie, null))
						O.show_message(text("\red <B>[] has been attacked with [][] </B>", ai_target_zombie, temp, (src ? text(" by [].", src) : ".")), 1)
					ai_target_zombie:attackby(src.r_hand, src)

			if( (distance == 3) && (world.timeofday - ai_pounced_zombie) > 180 && ai_validpath_zombie())
				if(valid)
					ai_pounced_zombie = world.timeofday
					for (var/mob/G in view(7,src))
						if (!G.client) continue
						G << "\red [src] lunges at [ai_target_zombie]."

					if(((istype(target.r_hand, /obj/item/weapon/shield) || istype(target.l_hand, /obj/item/weapon/shield)) && prob(80)) || (istype(target.r_hand, /obj/item/weapon/shield) && istype(target.l_hand, /obj/item/weapon/shield) && prob(50)))
						if(src.buckled) return
						ai_target_zombie << "\blue You manage to block the attack with your shield."
						spawn(0)
							step_towards(src,ai_target_zombie)
							step_towards(src,ai_target_zombie)
					else
						if(src.buckled) return
						if(ai_target_zombie:weakened < 2) ai_target_zombie:weakened += 2
						spawn(0)
							step_towards(src,ai_target_zombie)
							step_towards(src,ai_target_zombie)

/mob/living/carbon/human/proc/ai_move_zombie()
	if(ai_incapacitated_zombie() || !ai_canmove_zombie()) return
	if( ai_state_zombie == 0 && ai_canmove_zombie() ) step_rand(src)
	if( ai_state_zombie == 2 && ai_canmove_zombie() )
		if(!ai_validpath_zombie() && get_dist(src,ai_target_zombie) <= 1)
			dir = get_step_towards(src,ai_target_zombie)
			ai_obstacle_zombie() //Remove.
		else
			step_towards(src,ai_target_zombie)



/mob/living/carbon/human/proc/ai_pickupweapon_zombie()

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
/*
/mob/living/carbon/human/proc/ai_avoid(/*var/turf/simulated/T*/)
	if(ai_incapacitated_zombie()) return
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
	*/


/mob/living/carbon/human/proc/ai_canmove_zombie()
	if(!istype(src.loc,/turf)) return 0
	var/speed = (5 * ai_move_zombiedelay)
	if (!ai_laststep_zombie) ai_laststep_zombie = (world.timeofday - 5)
	if ((world.timeofday - ai_laststep_zombie) >= speed) return 1
	else return 0

/mob/living/carbon/human/proc/ai_incapacitated_zombie()
	if(stat || stunned || paralysis || eye_blind || weakened) return 1
	else return 0

/mob/living/carbon/human/proc/ai_validpath_zombie()

	var/list/L = new/list()

	var/mob/living/target = ai_target_zombie

	if(!istype(src.loc,/turf)) return 0

	if(!target) return 0 //WTF

	L = getline(src,target)

	for (var/turf/T in L)
		if (T.density)
			ai_frustration_zombie += 3
			return 0
		for (var/obj/D in T)
			if (D.density && !istype(D, /obj/closet) && D.anchored)
				ai_frustration_zombie += 3
				return 0
			else if (istype(D, /obj/closet))
				if(D:opened == 0) return 0

	return 1

/mob/living/carbon/human/proc/ai_meleecheck_zombie() //Simple right now.
	var/targetturf = get_turf(ai_target_zombie)
	var/myturf = get_turf(src)

	if(!istype(src.loc,/turf)) return 0

	if(locate(/obj/machinery/door/window) in myturf)
		for (var/obj/machinery/door/window/W in myturf)
			if(!W.CheckExit(src,targetturf)) return 0

	if(locate(/obj/machinery/door/window) in targetturf)
		for (var/obj/machinery/door/window/W in targetturf)
			if(!W.CheckPass(src,targetturf)) return 0

	return 1



/mob/living/carbon/human/proc/ai_freeself_zombie()
	if(!istype(src.loc, /obj/closet)) return
	var/obj/closet/C = src.loc
	if (C.opened)
		C.close()
		sleep(-1)
		C.open()
	else
		C.open()

/mob/living/carbon/human/proc/ai_obstacle_zombie(var/doorsonly)

	var/acted = 0

	if(ai_incapacitated_zombie()) return
	var/obj/organ/limb/arms/improvising = new /obj/organ/limb/arms
	var/obj/item/weapon/card/emag/improvising2 = new /obj/item/weapon/card/emag
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

	else if(!doorsonly) //So they dont smash windows while wandering around.

		if((locate(/obj/window) in get_step(src,dir))  && !acted)
			var/obj/window/W = (locate(/obj/window) in get_step(src,dir))
			W.attackby(improvising, src)
			acted = 1
		else if((locate(/obj/window) in get_turf(src.loc))  && !acted)
			var/obj/window/W = (locate(/obj/window) in get_turf(src.loc))
			W.attackby(improvising, src)
			acted = 1

		if((locate(/obj/grille) in get_step(src,dir))  && !acted)
			var/obj/grille/G = (locate(/obj/grille) in get_step(src,dir))
			if(!G.destroyed)
				G.attackby(improvising, src)
				acted = 1


	if((locate(/obj/machinery/door) in get_step(src,dir)))
		var/obj/machinery/door/W = (locate(/obj/machinery/door) in get_step(src,dir))
		if(W.density) W.attack_hand(src)
		sleep(4)
		if(W.density) W.attackby(improvising, src)
		if(W.density && prob(1)) W.attackby(improvising2, src)
	else if((locate(/obj/machinery/door) in get_turf(src.loc)))
		var/obj/machinery/door/W = (locate(/obj/machinery/door) in get_turf(src.loc))
		if(W.density) W.attack_hand(src)
		sleep(4)
		if(W.density) W.attackby(improvising, src)
		if(W.density && prob(1)) W.attackby(improvising2, src)
/mob/living/carbon/human/proc/ai_openclosets_zombie()
	if(ai_incapacitated_zombie()) return
	for(var/obj/closet/C in view(1,src)) C.open()
	for(var/obj/secure_closet/S in view(1,src))
		if(!S.opened && !S.locked) attack_hand(src)
