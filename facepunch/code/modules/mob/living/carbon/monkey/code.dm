/obj/npcmonkeyspawner/New()
	var/mob/living/carbon/monkey/M = new /mob/living/carbon/monkey ( loc )
	M.ai_active = 1
	M.think()
	del(src)

/obj/npcmonkeyspawner/angry/New()
	var/mob/living/carbon/monkey/M = new /mob/living/carbon/monkey ( loc )
	M.ai_active = 1
	M.aggressiveness = 22
	M.think()
	del(src)

/obj/npcmonkeyspawner/special/New()
	var/mob/living/carbon/monkey/M = new/mob/living/carbon/monkey(loc)
	M.ai_active = 1
	M.think()
	del(src)

//Orders monkey to target a new mob
/mob/living/carbon/monkey/proc/helpme(mob/M as mob)
	target = M
	mainstate = 3


//The process proc
/mob/living/carbon/monkey/proc/think()
	//var/turf/T = get_turf(src)
	var/nolos = 0
	var/cantact = 0

	//emote("EMOTENAME")
	//var/count = 0
	//var/friend // His friend . real_name .
	//var/mainstate = 0
		// 0 = Idle
		// 1 = Targeting
		// 2 = Angry
		// 3 = Attacking
		// 4 = Moving out of Danger.
		// 5 = Run awayyy
		// 6 = Following
	//var/substate = 0
	//var/target = null // His target .
	//var/ai_active = 0 // Is the AI on or off?

	if (!ai_active) return
	if (monkeyizing) return

	if(stat || stunned || weakened || paralysis) cantact = 1
	if(!istype(src.loc,/turf)) cantact = 1//In a locker or something

	if(target && (mainstate == 2 || mainstate == 3))
		var/list/L = getline(get_turf(src), get_turf(target))
		for (var/turf/Trf as turf in L)
			if (Trf.density) nolos = 1
			for (var/atom/C in Trf)
				if(!istype(C,/mob/living) && C.density) // Somethings blocking our way
					nolos = 1

	switch(mainstate)
		if(0)//Idle, doing nothing, reset things
			if(target)
				target = null


			/*if((T.sl_gas || T.poison) && !special) // ahaha what a shitty workaround.
				mainstate = 4
				SaferTurf()
				spawn(5) //////////////////////////////////////!!!
					think()
				return*/

			var/mob/Temp
			var/TempHp = 100

			for(var/mob/living/M as mob in oview(world.view-3,src))
				//if(istype(M,/mob/living/carbon/monkey))	continue//They now attack everything but other monkeys
				if(!M.client || !istype(M,/mob/living/carbon/human)) continue//Prevents them from attacking not human things and braindeads
				if(M.health <= TempHp && !M.stat)
					Temp = M
					TempHp = M.health
			if((Temp && prob( ( (100 - TempHp) * 2) + aggressiveness )) || Temp && health < 90 + (aggressiveness / 2) )
				if(!istype(Temp, /mob/living))
					//spawn(5) //////////////////////////////////////!!!
					//	think()
					return
				mainstate = 1//Set to targeting
				target = Temp
			else
				if(!cantact && canmove)
					step_rand(src)

		if(1)//Looking for target

			if(!target || cantact || target:stat)
				mainstate = 0
				target = null
				//spawn(10)
				//	think()
				return

			for(var/mob/M as mob in oview(world.view,src))
				M << "\red The [src.name] stares at [target]"
			if (prob(10) && !special) emote("gnarl")
			mainstate = 2//Set to angry

		if(2)//Angry, moving to target
			if(!target)
				mainstate = 0
				//spawn(10)
				//	think()
				return

			if((get_dist(src,target) >= world.view - 2) && !cantact)
				visible_message("\red The [src.name] calms down.")
				target = null
				count = 0
				mainstate = 0
				//spawn(10)
				//	think()
				return

			if ((prob(33) || health < 50) && !cantact)
				if (prob(10) && !special) emote("paw")
				for(var/mob/living/carbon/monkey/M as mob in oview(world.view,src))
					if(istype(M,/mob/living/carbon/monkey))//Wooo type checks
						if(M.ai_active && !M.stat && M.canmove)
							M.helpme(target)//Telling the other monkeys to flip shit

			if (!nolos && canmove && !cantact)
				for(var/mob/M as mob in oview(world.view,src))
					M << "\red The [src.name] lunges at [target]."
				if (prob(10) && !special) emote("roar")
				//while(get_dist(src,target) > 2)
				step_towards(src,target)
					//sleep(2)

			mainstate = 3//Set attack

		if(3)//Attacking
			if(!target)
				count = 0
				mainstate = 0
				return

			if(((target:stat && prob(50-aggressiveness)) && !cantact) || count > 300 )//Giving up after a bit
				visible_message("\red The [src.name] loses interest in its target.")
				target = null
				count = 0
				mainstate = 0
				//spawn(10)
				//	think()
				return

			if(get_dist(src,target) > world.view + 2 && !cantact)
				visible_message("\red The [src.name] calms down.")
				target = null
				count = 0
				mainstate = 0
				//spawn(10)
				//	think()
				return

			if(get_dist(src,target) > 1 && !cantact && canmove)
				count++
				step_towards(src,target)

			/*if((T.sl_gas > 3000 || T.poison > 3000 ) && !special)//Breathing things here
				mainstate = 4
				SaferTurf()*/

			if(get_dist(src,target) == 2 && prob(50) && (!cantact && canmove))
				if(!nolos)
					visible_message("\red The [src.name] pounces [target].")
					//Add defense here
					target.deal_damage(3, WEAKEN, IMPACT, "chest")
					step_towards(src,target)
					step_towards(src,target)
				//	spawn(10)
				//		think()
					return

			if(get_dist(src,target) < 2 && (!cantact) )
				visible_message("\red The [src.name] bites [target].")
				target.deal_damage(rand(0,5), BRUTE, SLASH)

		if(4)
			if (prob(5) && !special) emote("whimper")
			/*if((T.sl_gas || T.poison || t_oxygen) && !special) no breathing things atm
				SaferTurf()
			else*/
			if(target) mainstate = 2
			if(!target) mainstate = 0

	//This is not very good and should likely run off of the MC, will try it like this for the moment.
	//spawn(10)
	//	think()
	return

/mob/living/carbon/monkey/proc/SaferTurf()
	return
	//This proc uses the donut atmos system and would have to be changed to work with the new one if we wanted them to bother with atmos things.
	/*
	var/turf/Current = get_turf(src)
	var/turf/Temp = Current
	var/turf/Check = Current
	var/blocked = 0
	var/cantact = 0

	if (stat || stunned || weakened || paralysis) cantact = 1

	if(Current.sl_gas && canmove && !cantact)
		Current = get_turf(src)
		Temp = Current
		Check = Current
		for(var/A in alldirs)
			Check = get_step(src, A)
			if(!istype(Check,/turf)) continue
			if (Check.sl_gas < Current.sl_gas && Check.sl_gas < Temp.sl_gas && !Check.density)
				blocked = 0
				for (var/atom/B in Check)
					if(B.density)
						blocked = 1
				if(!blocked)
					Temp = Check
		step_towards(src,Temp)

	if(Current.poison && canmove && !cantact)
		Current = get_turf(src)
		Temp = Current
		Check = Current
		for(var/A in alldirs)
			Check = get_step(src, A)
			if(!istype(Check,/turf)) continue
			if (Check.poison < Current.poison && Check.poison < Temp.poison && !Check.density)
				blocked = 0
				for (var/atom/B in Check)
					if(B.density)
						blocked = 1
				if(!blocked)
					Temp = Check
		step_towards(src,Temp)


	if(t_oxygen && canmove && !cantact)
		Current = get_turf(src)
		Temp = Current
		Check = Current
		for(var/A in alldirs)
			Check = get_step(src, A)
			if(!istype(Check,/turf)) continue
			if (Check.oxygen > Current.oxygen && Check.oxygen > Temp.oxygen && !Check.density)
				blocked = 0
				for (var/atom/B in Check)
					if(B.density)
						blocked = 1
				if(!blocked)
					Temp = Check
		step_towards(src,Temp)*/