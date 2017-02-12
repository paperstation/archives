
/obj/effect/critter

	New(loc)
		spawn(0) process()//I really dont like this much but it seems to work well
		..(loc)


	process()
		set background = 1
		if (!src.alive)	return
		switch(task)
			if("thinking")
				src.target = null
				sleep(thinkspeed)
				walk_to(src,0)
				if(src.aggressive) seek_target()
				if(src.wanderer && !src.target) src.task = "wandering"
			if("chasing")
				if(src.frustration >= max_frustration)
					src.target = null
					src.last_found = world.time
					src.frustration = 0
					src.task = "thinking"
					walk_to(src,0)
				if(target)
					if (get_dist(src, src.target) <= 1)
						var/atom/movable/M = src.target
						ChaseAttack()
						src.task = "attacking"
						if(chasestate)
							icon_state = chasestate
						src.anchored = 1
						src.target_lastloc = M.loc
					else
						var/turf/olddist = get_dist(src, src.target)
						walk_to(src, src.target,1,chasespeed)
						if ((get_dist(src, src.target)) >= (olddist))
							src.frustration++
						else
							src.frustration = 0
						sleep(5)
				else src.task = "thinking"
			if("attacking")
				// see if he got away
				if((get_dist(src, src.target) > 1) || ((src.target:loc != src.target_lastloc)))
					src.anchored = 0
					src.task = "chasing"
					if(chasestate)
						icon_state = chasestate
				else
					if(get_dist(src, src.target) <= 1)
						var/mob/living/carbon/M = src.target
						if(!src.attacking)	RunAttack()
						if(!src.aggressive)
							src.task = "thinking"
							src.target = null
							src.anchored = 0
							src.last_found = world.time
							src.frustration = 0
							src.attacking = 0
						else
							if(M!=null)
								if(ismob(src.target))
									if(M.health < 0)
										src.task = "thinking"
										src.target = null
										src.anchored = 0
										src.last_found = world.time
										src.frustration = 0
										src.attacking = 0
					else
						src.anchored = 0
						src.attacking = 0
						src.task = "chasing"
						if(chasestate)
							icon_state = chasestate
			if("wandering")
				if(chasestate)
					icon_state = initial(icon_state)
				patrol_step()
				sleep(wanderspeed)
		spawn(8)
			process()
		return


	proc/patrol_step()
		var/moveto = locate(src.x + rand(-1,1),src.y + rand(-1, 1),src.z)
		if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/simulated/shuttle/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(src, moveto)
		if(src.aggressive) seek_target()
		steps += 1
		if (steps == rand(5,20)) src.task = "thinking"


	Bump(M as mob|obj)//TODO: Add access levels here
		spawn(0)
			if((istype(M, /obj/machinery/door)))
				if(src.opensdoors)
					M:open()
					src.frustration = 0
			else src.frustration ++
			if((istype(M, /mob/living/)) && (!src.anchored))
				src.loc = M:loc
				src.frustration = 0
			return
		return


	Bumped(M as mob|obj)
		spawn(0)
			var/turf/T = get_turf(src)
			M:loc = T


	proc/seek_target()
		//src.anchored = 0 Why was this here
		if(src.target)
			src.task = "chasing"
			return
		var/list/can_see = view(src.seekrange,src)
		if(ATKMOBS & can_target)
			for(var/mob/living/mob in can_see)
				// Ignore syndicates and traitors if specified
				if((can_target & AVOIDSYNDI) && mob.mind)
					var/datum/mind/synd_mind = mob.mind
					if(synd_mind.special_role)
						continue
				//If we just attacked that guy and stopped then look for someone else.
				if((mob.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
				//Dont attack dead things
				if(mob.health <= 0) continue

				if(ishuman(mob) && !(can_target & ATKHUMAN)) continue
				if(ismonkey(mob) && !(can_target & ATKMONKEY)) continue
				if(isalien(mob) && !(can_target & ATKALIEN)) continue
				if(istype(mob, /mob/living/silicon) && !(can_target & ATKSILICON)) continue
				if(istype(mob, /mob/living/simple_animal) && !(can_target & ATKSIMPLE)) continue
				SetTarget(mob)
				return

		//Then look for critters
		if(can_target & ATKCRITTER)
			for(var/obj/effect/critter/critter in can_see)
				if(critter == src) continue
				if(critter.health <= 0) continue
				if(!team || !critter.team) continue
				if(team == critter.team && !(can_target & ATKSAME))	continue
				SetTarget(critter)
				return

		//Lastly look for mechs
		if(can_target & ATKMECH)
			for(var/obj/mecha/mech in can_see)
				if(!mech.occupant) continue
				if(mech.health <= 0) continue
				SetTarget(mech)
				return
		return


	proc/ChaseAttack()
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[src]</B> [src.angertext] at [src.target]!", 1)
		return


	proc/RunAttack()
		src.attacking = 1
		src.visible_message("\red <B>[src]</B> [src.attacktext] [src.target]!")
		if(attack_sound)
			playsound(loc, attack_sound, 50, 1, -1)
		var/damage = rand(melee_damage_lower, melee_damage_upper)

		if(isliving(target))
			var/mob/living/L = target
			L.deal_damage(damage, BRUTE, IMPACT)
			if(attack_sound)
				playsound(loc, attack_sound, 50, 1, -1)

		if(isobj(target))
			if(istype(target, /obj/mecha))
				var/obj/mecha/mech = target
				mech.take_damage(damage, "brute")
			else if(istype(target, /obj/effect/critter))
				var/obj/effect/critter/critter = target
				critter.TakeDamage(damage)
			//else Needs to be redone
				//src.target:TakeDamage(damage)

		AfterAttack(target)
		spawn(attack_speed)
			src.attacking = 0
		return


	//Sets the arg as the current target and tells it to chase
	proc/SetTarget(var/atom/target)
		src.target = target
		src.oldtarget_name = target.name
		src.task = "chasing"
		return 1

/*TODO: Figure out how to handle special things like this dont really want to give it to every critter
/obj/effect/critter/proc/CritterTeleport(var/telerange, var/dospark, var/dosmoke)
	if (!src.alive) return
	var/list/randomturfs = new/list()
	for(var/turf/T in orange(src, telerange))
		if(istype(T, /turf/space) || T.density) continue
		randomturfs.Add(T)
	src.loc = pick(randomturfs)
	if (dospark)
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
	if (dosmoke)
		var/datum/effect/system/harmless_smoke_spread/smoke = new /datum/effect/system/harmless_smoke_spread()
		smoke.set_up(10, 0, src.loc)
		smoke.start()
	src.task = "thinking"
*/