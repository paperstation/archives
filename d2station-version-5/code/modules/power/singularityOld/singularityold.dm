/*////////////////////////////////////////////////
The Singularity Engine
By Mport
tbh this could likely be better and I did not use all that many comments on it.
However people seem to like it for some reason.
*/////////////////////////////////////////////////

/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen2/
	name = "Gravitational Singularity Generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'singularity2.dmi'
	icon_state = "TheSingGen2"
	anchored = 1
	density = 1


//////////////////////Singularity gen START
/obj/machinery/the_singularitygen2/New()
	..()

/obj/machinery/the_singularitygen2/process()
	var/checkpointC = 0
	for (var/obj/X in orange(3,src))
		if(istype(X, /obj/machinery/containment_field2))
			checkpointC ++
	if(checkpointC >= 20)
		var/turf/T = src.loc
		new /obj/machinery/the_singularity2/(T, 100)
		del(src)

/obj/machinery/the_singularitygen2/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		if(!anchored)
			anchored = 1
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			user << "You secure the [src.name] to the floor."
			src.anchored = 1
			return
		else if(anchored)
			anchored = 0
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			user << "You unsecure the [src.name]."
			src.anchored = 0
			return


/////SINGULARITY
/obj/machinery/the_singularity2/
	name = "Gravitational Singularity"
	desc = "A Gravitational Singularity."
	icon = '160x160.dmi'
	icon_state = "Singularity"
	anchored = 1
	density = 1
	var/active = 0
	var/energy = 10
	var/Dtime = null
	var/Wtime = 0
	var/dieot = 0
	var/selfmove = 1
	var/grav_pull = 3
	luminosity = 15

//////////////////////Singularity START

/obj/machinery/the_singularity2/New(loc, var/E = 100, var/Ti = null)
	src.energy = E
	pixel_x = -64
	pixel_y = -64
	event()
	if(Ti)
		src.Dtime = Ti
	..()


/obj/machinery/the_singularity2/process()
	eat()

	if(src.Dtime)//If its a temp singularity IE: an event
		if(Wtime != 0)
			if((src.Wtime + src.Dtime) <= world.time)
				src.Wtime = 0
				del(src)
		else
			src.Wtime = world.time

	if(dieot)
		if(energy <= 0)//slowly dies over time
			del(src)
		else
			energy -= 5

//	if(prob(15))//Chance for it to run a special event
//		event()
	if(active == 1)
		move()
		spawn(5)
			move()
	else
		var/checkpointC = 0
		for (var/obj/X in orange(3,src))
			if(istype(X, /obj/machinery/containment_field2))
				checkpointC ++
		if(checkpointC < 18)
			src.active = 1
			src.dieot = 1
			grav_pull = 8


/obj/machinery/the_singularity2/proc/eat()
	for (var/atom/X in orange(grav_pull,src))
		if(istype(X,/obj/machinery/the_singularity2))
			continue
		if(istype(X,/obj/machinery/containment_field2))
			continue
		if(istype(X,/obj/machinery/field_generator2))
			var/obj/machinery/field_generator2/F = X
			if(F.active)
				continue
		if(istype(X,/turf/space))
			continue
		if(!active)
			if(isturf(X,/turf/simulated/floor/engine))
				continue
		if(!isarea(X))
			switch(get_dist(src,X))
				if(2)
					src.Bumped(X)
				if(1)
					src.Bumped(X)
				if(0)
					src.Bumped(X)
				else if(!isturf(X))
					if(!X:anchored)
						step_towards(X,src)

/obj/machinery/the_singularity2/proc/move()
	var/direction_go = pick(1,2,4,8)
	if(locate(/obj/machinery/containment_field2) in get_step(src,NORTH))
		if(direction_go == 1)
			icon_state = "Singularity2"
			return
	if(locate(/obj/machinery/containment_field2) in get_step(src,SOUTH))
		if(direction_go == 2)
			icon_state = "Singularity2"
			return
	if(locate(/obj/machinery/containment_field2) in get_step(src,EAST))
		if(direction_go == 4)
			icon_state = "Singularity2"
			return
	if(locate(/obj/machinery/containment_field2) in get_step(src,WEST))
		if(direction_go == 8)
			icon_state = "Singularity2"
			return
	if(selfmove)
		spawn(0)
			icon_state = "Singularity2"
			step(src, direction_go)


/obj/machinery/the_singularity2/Bumped(atom/A)
	var/gain = 0

	if(istype(A,/obj/machinery/the_singularity2))
		return

	if(istype(A,/obj/machinery/the_singularity2))//Dont eat other sings
		return
	if (istype(A,/mob/living))//if its a mob
		gain = 20
		if(istype(A,/mob/living/carbon/human))
			if(A:mind)
				if(A:mind:assigned_role == "Station Engineer")
					gain = 100
		A:gib()

	else if(istype(A,/obj/))
		if(istype(A,/obj/machinery/containment_field2))
			return
		A:ex_act(1.0)
		if(A) del(A)
		gain = 2

	else if(isturf(A))
		if(isturf(/turf/space))
			return
		if(!active)
			if(isturf(A,/turf/simulated/floor/engine))
				return

		if(!istype(A,/turf/simulated/floor)&& (!isturf(/turf/space)))
			A:ReplaceWithFloor()
		if(istype(A,/turf/simulated/floor) && (!isturf(/turf/space)))
			A:ReplaceWithSpace()
			gain = 2
	src.energy += gain

/////////////////////////////////////////////Controls which "event" is called
/obj/machinery/the_singularity2/proc/event()
	var/numb = pick(1,2,3,4,5,6)
	switch(numb)
		if(1)//EMP
			Zzzzap()
			return
		if(2)//Eats the turfs around it
			if(prob(60))
				BHolerip()
			else
				event()
			return
		if(3)//tox damage all carbon mobs in area
			Toxmob()
			return
		if(4)//Stun mobs who lack optic scanners
			Mezzer()
			return
		else
			return


/obj/machinery/the_singularity2/proc/Toxmob()
	for(var/mob/living/carbon/M in orange(7, src))
		if(istype(M,/mob/living/carbon/human))
			if(M:wear_suit)
				return
		M.toxloss += 3
		M.radiation += 10
		M.updatehealth()
		M << "\red You feel odd."

/obj/machinery/the_singularity2/proc/Mezzer()
	for(var/mob/living/carbon/M in oviewers(8, src))
		if(istype(M,/mob/living/carbon/human))
			if(istype(M:glasses,/obj/item/clothing/glasses/meson))
				M << "\red You look directly into The [src.name], good thing you had your protective eyewear on!"
				return
		M << "\red You look directly into The [src.name] and feel weak."
		if (M:stunned < 3)
			M.stunned = 3
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] stares blankly at The []!</B>", M, src), 1)

/obj/machinery/the_singularity2/proc/BHolerip()
	for (var/atom/X in orange(6,src))
		if(isturf(X))
			if(!istype(X,/turf/space))
				switch(get_dist(src,X))
					if(4 to 5)
						if(prob(30))
							if(istype(X,/turf/simulated/floor) && !istype(X,/turf/simulated/floor/plating))
								if(!X:broken)
									if(prob(80))
										X:break_tile_to_plating()
									else
										X:break_tile()
							else if(istype(X,/turf/simulated/wall))
								new /obj/structure/girder/reinforced( X )
								X:ReplaceWithFloor()
							else
								X:ReplaceWithFloor()
	return

/obj/machinery/the_singularity2/proc/Zzzzap()///Pulled from wizard spells might edit later
	var/turf/myturf = get_turf(src)

	var/obj/overlay/pulse = new/obj/overlay ( myturf )
	pulse.icon = 'effects.dmi'
	pulse.icon_state = "emppulse"
	pulse.name = "emp pulse"
	pulse.anchored = 1
	spawn(20)
		del(pulse)

	for(var/mob/M in viewers(world.view-1, myturf))

		if(!istype(M, /mob/living)) continue
		if(M == usr) continue

		if (istype(M, /mob/living/silicon))
			M.fireloss += 25
			flick("noise", M:flash)
			M << "\red <B>*BZZZT*</B>"
			M << "\red Warning: Electromagnetic pulse detected."
			if(istype(M, /mob/living/silicon/ai))
				if (prob(30))
					switch(pick(1,2)) //Add Random laws.
						if(1)
							M:cancel_camera()
						if(2)
							M:ai_call_shuttle()
						if(3)
							M:lockdown()
			continue



	for(var/obj/machinery/A in range(world.view-1, myturf))
		A.use_power(7500)

		var/obj/overlay/pulse2 = new/obj/overlay ( A.loc )
		pulse2.icon = 'effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.dir = pick(cardinal)

		spawn(10)
			del(pulse2)

		if(istype(A, /obj/machinery/computer) && prob(20))
			A:set_broken()

		if(istype(A, /obj/machinery/firealarm) && prob(50))
			A:alarm()

		if(istype(A, /obj/machinery/power/smes))
			A:online = 0
			A:charging = 0
			A:output = 0
			A:charge -= 1e6
			if (A:charge < 0)
				A:charge = 0

		if(istype(A, /obj/machinery/power/apc))
			if(A:cell)
				A:cell:charge -= 1000
				if (A:cell:charge < 0)
					A:cell:charge = 0
			A:lighting = 0
			A:equipment = 0
			A:environ = 0

		if(istype(A, /obj/machinery/camera))
			A.icon_state = "cameraemp"
			A:network = null
			for(var/mob/living/silicon/ai/O in mobz)
				if (O.current == A)
					O.cancel_camera()
					O << "Your connection to the camera has been lost."

		if(istype(A, /obj/machinery/clonepod))
			A:malfunction()



////////CONTAINMENT FIELD

/obj/machinery/containment_field2
	name = "Containment Field"
	desc = "An energy field."
	icon = 'singularity2.dmi'
	icon_state = "Contain_F"
	anchored = 1
	density = 0
	var/active = 1
	var/power = 10
	var/delay = 5
	var/last_active
	var/mob/U
	var/obj/machinery/field_generator2/gen_primary
	var/obj/machinery/field_generator2/gen_secondary



//////////////Contaiment Field START


/obj/machinery/containment_field2/New(var/obj/machinery/field_generator2/A, var/obj/machinery/field_generator2/B)
	..()
	src.gen_primary = A
	src.gen_secondary = B
	spawn(1)
		src.ul_SetLuminosity(5)

/obj/machinery/containment_field2/attack_hand(mob/user as mob)
	return


/obj/machinery/containment_field2/process()
	if(isnull(gen_primary)||isnull(gen_secondary))
		del(src)
		return

	if(!(gen_primary.active)||!(gen_secondary.active))
		del(src)
		return

	if(prob(50))
		gen_primary.power -= 1
	else
		gen_secondary.power -= 1


/obj/machinery/containment_field2/proc/shock(mob/user as mob)
	if(isnull(gen_primary))
		del(src)
		return
	if(isnull(gen_secondary))
		del(src)
		return

	var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
	s.set_up(1, 1, user.loc)
	s.start()
	src.power = max(gen_primary.power,gen_secondary.power)
	var/prot = 1
	var/shock_damage = 0
	if(src.power > 200)
		shock_damage = min(rand(90,100),rand(70,100))*prot
	else if(src.power > 120)
		shock_damage = min(rand(50,90),rand(50,90))*prot
	else if(src.power > 80)
		shock_damage = min(rand(20,80),rand(20,80))*prot
	else if(src.power > 4)
		shock_damage = min(rand(20,70),rand(20,70))*prot
	else
		shock_damage = min(rand(10,60),rand(10,60))*prot

	user.fireloss += shock_damage
	user << "\red <B>You feel a powerful shock course through your body sending you flying!</B>"
	//user.unlock_medal("High Voltage", 1)

	if(user.stunned < shock_damage)	user.stunned = shock_damage
	if(user.weakened < 10*prot)	user.weakened = 10*prot
	var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
	user.throw_at(target, 200, 8)
	for(var/mob/M in viewers(src))
		if(M == user)	continue
		M.show_message("\red [user.name] was shocked by the [src.name]!", 3, "\red You hear a heavy electrical crack", 2)
	src.gen_primary.power -= 3
	src.gen_secondary.power -= 3
	return


/obj/machinery/containment_field2/HasProximity(atom/movable/AM as mob|obj)
	if(istype(AM,/mob/living/carbon) && prob(100))
		shock(AM)
		return



/////EMITTER
/obj/machinery/emitter2
	name = "Emitter"
	desc = "Shoots a high power laser when active"
	icon = 'singularity2.dmi'
	icon_state = "Emitter"
	anchored = 0
	density = 1
	req_access = list(access_engine)
	var/active = 0
	var/power = 20
	var/fire_delay = 100
	var/HP = 20
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0

	verb/rotate()
		set name = "Rotate"
		set category = "Object"
		set src in oview(1)

		if (src.anchored || usr:stat)
			usr << "It is fastened to the floor!"
			return 0
		src.dir = turn(src.dir, 90)
		return 1


	New()
		..()
		return


	update_icon()
		if (active && !(stat & (NOPOWER|BROKEN)))
			icon_state = "Emitter +a"
		else
			icon_state = "Emitter"


	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		if(state == 2)
			if(!src.locked || istype(user, /mob/living/silicon))
				if(src.active==1)
					src.active = 0
					user << "You turn off the [src]."
					src.use_power = 1
				else
					src.active = 1
					user << "You turn on the [src]."
					src.shot_number = 0
					src.fire_delay = 100
					src.use_power = 2
				update_icon()
			else
				user << "The controls are locked!"
		else
			user << "The [src] needs to be firmly secured to the floor first."
			return 1


	emp_act()//Emitters are hardened but still might have issues
		use_power(50)
		if(prob(1)&&prob(1))
			if(src.active)
				src.active = 0
				src.use_power = 1
		return 1


	process()
		if(stat & (NOPOWER|BROKEN))
			return
		if(src.state != 2)
			src.active = 0
			return
		if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))
			src.last_shot = world.time
			if(src.shot_number < 3)
				src.fire_delay = 2
				src.shot_number ++
			else
				src.fire_delay = rand(20,100)
				src.shot_number = 0
			use_power(1000)
			var/obj/item/projectile/beam/A = new /obj/item/projectile/beam( src.loc )
			A.icon_state = "u_laser"
			playsound(src.loc, 'emitter.ogg', 25, 1)
			if(prob(35))
				var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
			A.dir = src.dir
			if(src.dir == 1)//Up
				A.yo = 20
				A.xo = 0
			else if(src.dir == 2)//Down
				A.yo = -20
				A.xo = 0
			else if(src.dir == 4)//Right
				A.yo = 0
				A.xo = 20
			else if(src.dir == 8)//Left
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
			A.process()


	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/weapon/wrench))
			if(active)
				user << "Turn off the [src] first."
				return
			switch(state)
				if(0)
					state = 1
					playsound(src.loc, 'Ratchet.ogg', 75, 1)
					user.visible_message("[user.name] secures [src.name] to the floor.", \
						"You secure the external reinforcing bolts to the floor.", \
						"You hear ratchet")
					src.anchored = 1
				if(1)
					state = 0
					playsound(src.loc, 'Ratchet.ogg', 75, 1)
					user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
						"You undo the external reinforcing bolts.", \
						"You hear ratchet")
					src.anchored = 0
				if(2)
					user << "\red The [src.name] needs to be unwelded from the floor."
					return

		else if(istype(W, /obj/item/weapon/weldingtool) && W:welding)
			if(active)
				user << "Turn off the [src] first."
				return
			switch(state)
				if(0)
					user << "\red The [src.name] needs to be wrenched to the floor."
					return
				if(1)
					if (W:remove_fuel(0,user))
						W:welding = 2
						playsound(src.loc, 'Welder2.ogg', 50, 1)
						user.visible_message("[user.name] starts to weld the [src.name] to the floor.", \
							"You start to weld the [src] to the floor.", \
							"You hear welding")
						if (do_after(user,20))
							state = 2
							user << "You weld the [src] to the floor."
						W:welding = 1
					else
						user << "\blue You need more welding fuel to complete this task."
						return
				if(2)
					if (W:remove_fuel(0,user))
						W:welding = 2
						playsound(src.loc, 'Welder2.ogg', 50, 1)
						user.visible_message("[user.name] starts to cut the [src.name] free from the floor.", \
							"You start to cut the [src] free from the floor.", \
							"You hear welding")
						if (do_after(user,20))
							state = 1
							user << "You cut the [src] free from the floor."
						W:welding = 1
					else
						user << "\blue You need more welding fuel to complete this task."
						return
		else if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
			if (src.allowed(user))
				src.locked = !src.locked
				user << "Controls are now [src.locked ? "locked." : "unlocked."]"
			else
				user << "\red Access denied."
				return
		else
			..()
			return


	power_change()
		..()
		update_icon()

//////////////ARRAY


/obj/machinery/power/singularityold/collector_array2
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and plasma to produce power."
	icon = 'singularity2.dmi'
	icon_state = "ca"
	anchored = 1
	density = 1
	directwired = 1
	var/active = 0
	var/obj/item/weapon/tank/plasma/P = null
	var/obj/machinery/power/singularityold/collector_control2/CU = null


/////////////ARRAY START

/obj/machinery/power/singularityold/collector_array2/New()
	..()
	spawn(5)
		updateicon()


/obj/machinery/power/singularityold/collector_array2/proc/updateicon()

	if(stat & (NOPOWER|BROKEN))
		overlays = null
	if(P)
		overlays += image('singularity2.dmi', "ptank")
	else
		overlays = null
	overlays += image('singularity2.dmi', "on")
	if(P)
		overlays += image('singularity2.dmi', "ptank")

/obj/machinery/power/singularityold/collector_array2/power_change()
	updateicon()
	..()


/obj/machinery/power/singularityold/collector_array2/process()

	if(P)
		if(P.air_contents.toxins <= 0)
			src.active = 0
			icon_state = "ca_deactive"
			updateicon()
	else if(src.active == 1)
		src.active = 0
		icon_state = "ca_deactive"
		updateicon()
	..()

/obj/machinery/power/singularityold/collector_array2/attack_hand(mob/user as mob)
	if(src.anchored == 1)
		if(src.active==1)
			src.active = 0
			icon_state = "ca_deactive"
			CU.updatecons()
			user << "You turn off the collector array."
			return

		if(src.active==0)
			src.active = 1
			icon_state = "ca_active"
			CU.updatecons()
			user << "You turn on the collector array."
			return
	else
		src.add_fingerprint(user)
		user << "\red The collector needs to be secured to the floor first."
		return

/obj/machinery/power/singularityold/collector_array2/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/tank/plasma))
		if(src.anchored == 1)
			if(src.P)
				user << "\red There appears to already be a plasma tank loaded!"
				return
			src.P = W
			W.loc = src
			if (user.client)
				user.client.screen -= W
			user.u_equip(W)
			CU.updatecons()
			updateicon()
			return
		else
			user << "The collector needs to be secured to the floor first."
			return

	if(istype(W, /obj/item/weapon/crowbar))
		if(!P)
			return
		var/obj/item/weapon/tank/plasma/Z = src.P
		Z.loc = get_turf(src)
		Z.layer = initial(Z.layer)
		src.P = null
		CU.updatecons()
		updateicon()
		return

	if(istype(W, /obj/item/weapon/wrench))
		if(active)
			user << "\red Turn off the collector first."
			return

		else if(src.anchored == 0)
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			user << "You secure the collector reinforcing bolts to the floor."
			src.anchored = 1
			return

		else if(src.anchored == 1)
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			user << "You undo the external reinforcing bolts."
			src.anchored = 0
			return

	else
		src.add_fingerprint(user)
		user << "\red You hit the [src.name] with your [W.name]!"
		for(var/mob/M in viewers(src))
			if(M == user)	continue
			M.show_message("\red The [src.name] has been hit with the [W.name] by [user.name]!")


////////////CONTROL UNIT

/obj/machinery/power/singularityold/collector_control2
	name = "Radiation Collector Control"
	desc = "A device which uses Hawking Radiation and Plasma to produce power."
	icon = 'singularity2.dmi'
	icon_state = "cu"
	anchored = 1
	density = 1
	directwired = 1
	var/active = 0
	var/lastpower = 0
	var/obj/item/weapon/tank/plasma/P1 = null
	var/obj/item/weapon/tank/plasma/P2 = null
	var/obj/item/weapon/tank/plasma/P3 = null
	var/obj/item/weapon/tank/plasma/P4 = null
	var/obj/machinery/power/singularityold/collector_array2/CA1 = null
	var/obj/machinery/power/singularityold/collector_array2/CA2 = null
	var/obj/machinery/power/singularityold/collector_array2/CA3 = null
	var/obj/machinery/power/singularityold/collector_array2/CA4 = null
	var/obj/machinery/power/singularityold/collector_array2/CAN = null
	var/obj/machinery/power/singularityold/collector_array2/CAS = null
	var/obj/machinery/power/singularityold/collector_array2/CAE = null
	var/obj/machinery/power/singularityold/collector_array2/CAW = null
	var/obj/machinery/the_singularity2/S1 = null

////////////CONTROL UNIT START

/obj/machinery/power/singularityold/collector_control2/New()
	..()
	spawn(10)
		updatecons()

/obj/machinery/power/singularityold/collector_control2/proc/updatecons()

	CAN = locate(/obj/machinery/power/singularityold/collector_array2) in get_step(src,NORTH)
	CAS = locate(/obj/machinery/power/singularityold/collector_array2) in get_step(src,SOUTH)
	CAE = locate(/obj/machinery/power/singularityold/collector_array2) in get_step(src,EAST)
	CAW = locate(/obj/machinery/power/singularityold/collector_array2) in get_step(src,WEST)
	for(var/obj/machinery/the_singularity2/S in orange(12,src))
		S1 = S

	if(!isnull(CAN))
		CA1 = CAN
		CAN.CU = src
		if(CA1.P)
			P1 = CA1.P
	else
		CAN = null
	if(!isnull(CAS))
		CA3 = CAS
		CAS.CU = src
		if(CA3.P)
			P3 = CA3.P
	else
		CAS = null
	if(!isnull(CAW))
		CA4 = CAW
		CAW.CU = src
		if(CA4.P)
			P4 = CA4.P
	else
		CAW = null
	if(!isnull(CAE))
		CA2 = CAE
		CAE.CU = src
		if(CA2.P)
			P2 = CA2.P
	else
		CAE = null
	if(isnull(S1))
		S1 = null

	updateicon()
	spawn(600)
		updatecons()


/obj/machinery/power/singularityold/collector_control2/proc/updateicon()

	if(stat & (NOPOWER|BROKEN))
		overlays = null
	else
		overlays = null
	if(src.active == 0)
		return
	overlays += image('singularity2.dmi', "cu on")
	if((P1)&&(CA1.active != 0))
		overlays += image('singularity2.dmi', "cu 1 on")
	if((P2)&&(CA2.active != 0))
		overlays += image('singularity2.dmi', "cu 2 on")
	if((P3)&&(CA3.active != 0))
		overlays += image('singularity2.dmi', "cu 3 on")
	if((!P1)||(!P2)||(!P3))
		overlays += image('singularity2.dmi', "cu n error")
	if(S1)
		overlays += image('singularity2.dmi', "cu sing")
		if(!S1.active)
			overlays += image('singularity2.dmi', "cu conterr")


/obj/machinery/power/singularityold/collector_control2/power_change()
	updateicon()
	..()


/obj/machinery/power/singularityold/collector_control2/process()
	if(src.active == 1)
		var/power_a = 0
		var/power_s = 0
		var/power_p = 0

		if(!isnull(S1))
			power_s += S1.energy
		if(!isnull(P1))
			if(CA1.active != 0)
				power_p += P1.air_contents.toxins
				P1.air_contents.toxins -= 0.001
		if(!isnull(P2))
			if(CA2.active != 0)
				power_p += P2.air_contents.toxins
				P2.air_contents.toxins -= 0.001
		if(!isnull(P3))
			if(CA3.active != 0)
				power_p += P3.air_contents.toxins
				P3.air_contents.toxins -= 0.001
		if(!isnull(P4))
			if(CA4.active != 0)
				power_p += P4.air_contents.toxins
				P4.air_contents.toxins -= 0.001
		power_a = power_p*power_s*50
		src.lastpower = power_a
		add_avail(power_a)
	..()


/obj/machinery/power/singularityold/collector_control2/attack_hand(mob/user as mob)
	if(src.anchored==1)
		if(src.active==1)
			src.active = 0
			user << "You turn off the collector control."
			src.lastpower = 0
			updateicon()
			return

		if(src.active==0)
			src.active = 1
			user << "You turn on the collector control."
			updatecons()
			return
	else
		src.add_fingerprint(user)
		user << "\red The collector control needs to be secured to the floor first."
		return


/obj/machinery/power/singularityold/collector_control2/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/analyzer))
		user << "\blue The analyzer detects that [lastpower]W are being produced."

	if(istype(W, /obj/item/weapon/wrench))
		if(active)
			user << "\red Turn off the collector control first."
			return

		else if(src.anchored == 0)
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			user << "You secure the collector control to the floor."
			src.anchored = 1
			return

		else if(src.anchored == 1)
			playsound(src.loc, 'Ratchet.ogg', 75, 1)
			user << "You undo the collector control securing bolts."
			src.anchored = 0
			return

	else
		src.add_fingerprint(user)
		user << "\red You hit the [src.name] with your [W.name]!"
		for(var/mob/M in viewers(src))
			if(M == user)	continue
			M.show_message("\red The [src.name] has been hit with the [W.name] by [user.name]!")





/////FIELD GEN

/obj/machinery/field_generator2
	name = "Field Generator"
	desc = "Projects an energy field when active"
	icon = 'singularity2.dmi'
	icon_state = "Field_Gen"
	anchored = 0
	density = 1
	req_access = list(access_engine)
	var/Varedit_start = 0
	var/Varpower = 0
	var/active = 0
	var/power = 20
	var/max_power = 250
	var/state = 0
	var/steps = 0
	var/last_check = 0
	var/check_delay = 10
	var/recalc = 0
	var/locked = 0
	var/overlay = null


////FIELD GEN START

/obj/machinery/field_generator2/attack_hand(mob/user as mob)
	if(state >= 2)
		if(!src.locked)
			if(src.active >= 1)
	//			src.active = 0
	//			icon_state = "Field_Gen"
				user << "You are unable to turn off the field generator, wait till it powers down."
	//			src.cleanup()
			else
				src.active = 1
				src.overlays += icon('singularity2.dmi', "Field_Gen_overlay")
				user << "You turn on the field generator."
		else
			user << "The controls are locked!"
	else
		user << "The field generator needs to be firmly secured to the floor first."
	src.add_fingerprint(user)

/obj/machinery/field_generator2/attack_ai(mob/user as mob)
	if(state == 3)
		if(src.active >= 1)
			user << "You are unable to turn off the field generator, wait till it powers down."
		else
			src.active = 1
			src.overlays += icon('singularity2.dmi', "Field_Gen_overlay")
			user << "You turn on the field generator."
	else
		user << "The field generator needs to be firmly secured to the floor first."
	src.add_fingerprint(user)

/obj/machinery/field_generator2/New()
	..()
	return

/obj/machinery/field_generator2/process()
	if(!anchored)
		return
	if(src.Varedit_start == 1)
		if(src.active == 0)
			src.active = 1
			src.state = 3
			src.power = 250
			src.anchored = 1
			icon_state = "Field_Geneh"
			src.overlays += icon('singularity2.dmi', "Field_Gen_overlayeh")
		Varedit_start = 0

	if(src.active == 1)
		if(!src.state == 3)
			src.active = 0
			return
		spawn(1)
			setup_field(1)
		spawn(2)
			setup_field(2)
		spawn(3)
			setup_field(4)
		spawn(4)
			setup_field(8)
		src.active = 2
	if(src.power < 0)
		src.power = 0
	if(src.power > src.max_power)
		src.power = src.max_power
	if(src.active >= 1)
		src.power -= 1
		if(Varpower == 0)
			if(src.power <= 0)
				for(var/mob/M in viewers(src))
					M.show_message("\red The [src.name] shuts down due to lack of power!")
				src.overlays = null
				src.active = 0
				spawn(1)
					src.cleanup(1)
				spawn(1)
					src.cleanup(2)
				spawn(1)
					src.cleanup(4)
				spawn(1)
					src.cleanup(8)


/obj/machinery/field_generator2/proc/setup_field(var/NSEW = 0)
	var/turf/T = src.loc
	var/turf/T2 = src.loc
	var/obj/machinery/field_generator2/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	if(NSEW == 1)
		oNSEW = 2
	else if(NSEW == 2)
		oNSEW = 1
	else if(NSEW == 4)
		oNSEW = 8
	else if(NSEW == 8)
		oNSEW = 4

	for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/field_generator2) in T)
			G = (locate(/obj/machinery/field_generator2) in T)
			steps -= 1
			if(!G.active)
				return
			G.cleanup(oNSEW)
			break

	if(isnull(G))
		return

	T2 = src.loc

	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T2,get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/machinery/containment_field2/CF = new/obj/machinery/containment_field2/(src, G) //(ref to this gen, ref to connected gen)
		CF.loc = T
		CF.dir = field_dir


/obj/machinery/field_generator2/attackby(obj/item/W, mob/user)
	if(active)
		user << "The [src] needs to be off."
		return
	else if(istype(W, /obj/item/weapon/wrench))
		switch(state)
			if(0)
				state = 1
				playsound(src.loc, 'Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear ratchet")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear ratchet")
				src.anchored = 0
			if(2)
				user << "\red The [src.name] needs to be unwelded from the floor."
				return
	else if(istype(W, /obj/item/weapon/weldingtool) && W:welding)
		switch(state)
			if(0)
				user << "\red The [src.name] needs to be wrenched to the floor."
				return
			if(1)
				if (W:remove_fuel(0,user))
					W:welding = 2
					playsound(src.loc, 'Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld the [src.name] to the floor.", \
						"You start to weld the [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20))
						state = 2
						user << "You weld the field generator to the floor."
					W:welding = 1
				else
					return
			if(2)
				if (W:remove_fuel(0,user))
					W:welding = 2
					playsound(src.loc, 'Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut the [src.name] free from the floor.", \
						"You start to cut the [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20))
						state = 1
						user << "You cut the [src] free from the floor."
					W:welding = 2
				else
					return

/obj/machinery/field_generator2/bullet_act(var/obj/item/projectile/Proj)

	if(Proj.flag != "bullet")
		power += Proj.damage
		update_icon()
	else
		power -= Proj.damage
		update_icon()
	return


/obj/machinery/field_generator2/proc/cleanup(var/NSEW)
	var/obj/machinery/containment_field2/F
	var/obj/machinery/field_generator2/G
	var/turf/T = src.loc
	var/turf/T2 = src.loc

	for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/machinery/containment_field2) in T)
			F = (locate(/obj/machinery/containment_field2) in T)
			del(F)

		if(locate(/obj/machinery/field_generator2) in T)
			G = (locate(/obj/machinery/field_generator2) in T)
			if(!G.active)
				break

/obj/machinery/field_generator2/Del()
	src.cleanup(1)
	src.cleanup(2)
	src.cleanup(4)
	src.cleanup(8)
	..()

