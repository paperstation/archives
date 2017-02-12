/proc/pixel_everyone()
	boutput(world, "<span style=\"color:red\">Changing all human mobs - please wait a moment.</span>")
	sleep(10)
	for(var/mob/living/carbon/human/H in mobs)
		var/mob/living/carbon/human/pixel/P = new/mob/living/carbon/human/pixel(get_turf(H.loc))
		P.real_name = H.real_name
		P.client = H.client

/mob/living/carbon/human/pixel
	var/speed_normal = 4
	var/speed_run = 8

/mob/living/carbon/human/pixel/Move(location, direction)
	var/mob/living/carbon/human/mob = src

	if (mob.stat == 2)
		return
	if (mob.transforming)
		return
	if (src.buckled)
		return
	if (src.restrained())
		src.pulling = null

	var/move_speed = speed_normal
	switch(mob.m_intent)
		if("run")
			move_speed = speed_run
			if (mob.drowsyness > 0)
				move_speed -= 2
		if("face")
			mob.dir = direction
			return
		if("walk")
			move_speed = speed_normal
	move_speed = max(move_speed, 0)

	mob.dir = direction

	var/is_monkey = ismonkey(mob)
	if (locate(/obj/item/grab, locate(/obj/item/grab, mob.grabbed_by.len)))
		var/list/grabbing = list(  )
		if (istype(mob.l_hand, /obj/item/grab))
			var/obj/item/grab/G = mob.l_hand
			grabbing += G.affecting
		if (istype(mob.r_hand, /obj/item/grab))
			var/obj/item/grab/G = mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/grab/G in mob.grabbed_by)
			if (G.state == 0)
				if (!( grabbing.Find(G.assailant) ))
					qdel(G)
			else
				if (G.state == 1)
					//src.move_delay = world.time + 10
					if ((prob(25) && (!( is_monkey ) || prob(25))))
						mob.visible_message("<span style=\"color:red\">[mob] has broken free of [G.assailant]'s grip!</span>")
						qdel(G)
					else
						return
				else
					if (G.state == 2)
						//src.move_delay = world.time + 10
						if ((prob(5) && !( is_monkey ) || prob(25)))
							mob.visible_message("<span style=\"color:red\">[mob] has broken free of [G.assailant]'s headlock!</span>")
							qdel(G)
						else
							return

	if (!mob.canmove) return

	var/j_pack = 0
	if ((istype(mob.loc, /turf/space)))
		mob.dir = direction
		if(ishuman(mob))
			if(istype(mob:wear_suit, /obj/item/clothing/suit/space/emerg))
				var/obj/item/clothing/suit/space/emerg/E = mob:wear_suit
				if (E.rip != -1)
					E.rip ++
					E.ripcheck(mob)
		if (!( mob.restrained() ))
			var/list/our_oview = oview(1, mob)
			if (!( (locate(/obj/grille) in our_oview) || (locate(/turf/simulated) in our_oview) || (locate(/turf/unsimulated) in our_oview) || (locate(/obj/lattice) in our_oview) ))
				if (istype(mob.back, /obj/item/tank/jetpack))
					var/obj/item/tank/jetpack/J = mob.back
					j_pack = J.allow_thrust(0.01, mob)
					if(j_pack)
						mob.inertia_dir = 0
					if (!( j_pack ))
						return 0
				else
					return 0
		else
			return 0

	if (isturf(mob.loc))
		if(istype (mob, /mob/living/carbon/human/))
			var/mob/living/carbon/human/H = mob
			if (H.find_ailment_by_type(/datum/ailment/disease/vamplague))
				move_speed = max(move_speed - 2, 1)

		//src.move_delay += mob.movement_delay() REIMPLEMENT THIS !!!!!!!!!!!!

		if(mob.reagents)
			if(mob.reagents.has_reagent("methamphetamine")) move_speed += 2

		if (mob.restrained())
			for(var/mob/M in range(mob, 1))
				if (((M.pulling == mob && (!( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, mob.grabbed_by.len)))
					boutput(src, "<span style=\"color:blue\">You're restrained! You can't move!</span>")
					return 0

		if (locate(/obj/item/grab, mob))
			move_speed = max(move_speed - 4, 1)
			var/list/L = mob.ret_grab()
			if (istype(L, /list))
				if (L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
						var/turf/T = mob.loc
						. = ..()
						if (isturf(M.loc))
							var/diag = get_dir(mob, M)
							if ((diag - 1) & diag)
							else
								diag = null
							if ((get_dist(mob, M) > 1 || diag))
								M.inertia_dir = get_dir(M.loc, T)
								M.loc = src.loc
								M.step_x = src.step_x
								M.step_y = src.step_y
				else
					for(var/mob/M in L)
						spawn( 0 )
							M.loc = src.loc
							M.step_x = src.step_x
							M.step_y = src.step_y
							return
		else
			if(prob(mob.misstep_chance))
				direction = pick(NORTH, EAST, SOUTH, WEST)

			var/half_size = world.icon_size / 2 //Should be 16 right now. Just in case we go 64x64 or some shit.

			switch (direction)
				if(NORTH)
					if(src.step_y + move_speed >= world.icon_size)
						var/turf/trg = locate(src.x, src.y + 1, src.z)
						if(can_enter(src.loc, trg))
							src.loc.Exited(src, trg)
							src.loc.Entered(src, src.loc)
							src.y++
							animate_flash_color_fill(trg,"#FF0000",1,5)
							src.step_y = ((src.step_y + move_speed) - world.icon_size)
						else
							src.step_y = 29 //So we dont stand on the dense wall but rather in front of it.
					else
						src.step_y += move_speed
				if(SOUTH) //Works
					var/turf/trg = locate(src.x, src.y - 1, src.z)
					if(src.step_y - move_speed <= 0)
						if(can_enter(src.loc, trg))
							src.loc.Exited(src, trg)
							src.loc.Entered(src, src.loc)
							src.y--
							animate_flash_color_fill(trg,"#FF0000",1,5)
							src.step_y = world.icon_size + (src.step_y - move_speed)
						else
							src.step_y = 0
					else
						src.step_y -= move_speed
				if(EAST)
					var/turf/trg = locate(src.x + 1, src.y, src.z)
					if(src.step_x + move_speed >= half_size) //Based on center of chest
						if(can_enter(src.loc, trg))
							src.loc.Exited(src, trg)
							src.loc.Entered(src, src.loc)
							src.x++
							animate_flash_color_fill(trg,"#FF0000",1,5)
							src.step_x = 0 - ((src.step_x + move_speed) - half_size)
						else
							src.step_x = half_size
					else
						src.step_x += move_speed
				if(WEST)
					var/turf/trg = locate(src.x - 1, src.y, src.z)
					if(src.step_x - move_speed <= (0-half_size)) //Based on center of chest
						if(can_enter(src.loc, trg))
							src.loc.Exited(src, trg)
							src.loc.Entered(src, src.loc)
							src.x--
							animate_flash_color_fill(trg,"#FF0000",1,5)
							src.step_x = half_size - ((src.step_x - move_speed) + half_size)
						else
							src.step_x = 0 - half_size
					else
						src.step_x -= move_speed
		return
	// If the person is inside an object .
	else
		if (isobj(mob.loc) || ismob(mob.loc))
			var/atom/O = mob.loc
			if (mob.canmove)
				return O.relaymove(mob, direction)

/mob/living/carbon/human/pixel/proc/can_enter(var/turf/from_loc, var/turf/to_loc)
	if(!from_loc.Exit(src, to_loc))
		//boutput(world, "exit fail")
		return 0
	if(!to_loc.Enter(src, from_loc))
		//boutput(world, "enter fail")
		return 0
	return 1