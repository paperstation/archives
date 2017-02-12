/*////////////////////////////////////////////////
The Singularity Engine
By Mport
tbh this could likely be better and I did not use all that many comments on it.
However people seem to like it for some reason.
*/////////////////////////////////////////////////
/*
#define collector_control_range 12

/////SINGULARITY SPAWNER
/obj/machinery/singularity_oldgen/
	name = "Gravitational Singularity Generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 1
	density = 1


//////////////////////Singularity gen START

/obj/machinery/singularity_oldgen/process()
	var/turf/T = get_turf(src)
	if (singularity_is_surrounded(T))
		new /obj/machinery/singularity_old/(T, 100)
		del(src)

/obj/machinery/singularity_oldgen/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = !anchored
		playsound(src.loc, 'Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear ratchet")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear ratchet")
		return
	return ..()

/proc/singularity_is_surrounded(turf/T)
	var/checkpointC = 0
	for (var/obj/X in orange(3,T)) //TODO: do we need requirement to singularity be actually _surrounded_ by field?
		if(istype(X, /obj/machinery/containment_field) || istype(X, /obj/machinery/shieldwall))
			checkpointC ++
	return checkpointC >= 20
*/
/////SINGULARITY
/obj/machinery/singularity_old/
	name = "Gravitational Singularity"
	desc = "A Gravitational Singularity."
	icon = '160x160.dmi'
	icon_state = "Singularity"
	anchored = 1
	density = 1
	layer = 6
	unacidable = 1 //Don't comment this out.
	var
		active = 0
		energy = 10
		Dtime = null
		Wtime = 0
		dieot = 0
		selfmove = 1
		grav_pull = 6
		global/list/turf/simulated/unstrippable = list(\
		/turf/simulated/floor/engine, \
		/turf/simulated/floor/grid, \
		/turf/simulated/shuttle, \
		/turf/simulated/wall/asteroid
	)

	New(loc, var/E = 100, var/Ti = null)
		src.energy = E
		pixel_x = -64
		pixel_y = -64
		event()
		if(Ti)
			src.Dtime = Ti
		..()
		notify_collector_controller()

	attack_hand(mob/user as mob)
		return 1

	blob_act(severity)
		return

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0 to 3.0) //no way
				return
		return

	Del()
		//TODO: some animation
		notify_collector_controller()
		..()

	process()
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

		switch(energy)
			if(1000 to 1999)
				for(var/obj/machinery/field_generator/F in orange(5,src))
					F.turn_off()
				emp_area()
				BHolerip()
				Toxmob()
			if(2000 to INFINITY)
				explosion(src.loc, 4, 8, 15, 0)
				emp_area()
				Toxmob()
				src.ex_act(1) //if it survived the explosion

		if(prob(15))//Chance for it to run a special event
			event()
		var/turf/T = get_turf(src)
		var/is_surrounded = singularity_is_surrounded(T)
		if ( is_surrounded && active )
			src.active = 0
			src.dieot = 0
			notify_collector_controller()
			spawn(50)
				if (!active)
					grav_pull = 6
					icon_state = "Singularity"
		else if  ( is_surrounded==0 && active==0 )
			src.active = 1
			src.dieot = 1
			grav_pull = 8
			notify_collector_controller()
		if(active == 1)
			move()
			spawn(5)
				move()


	proc


		notify_collector_controller()
			var/oldsrc = src
			src = null //for spawn() working even after Del(), see byond documentation about sleep() -rastaf0
			for(var/obj/machinery/power/collector_control/myCC in orange(collector_control_range,oldsrc))
				spawn() myCC.updatecons()


		eat()
			for(var/atom/X in orange(consume_range,src))
				if(isarea(X))
					continue
				consume(X)
			for(var/atom/X in orange(grav_pull,src))
				if(isarea(X))
					continue
				if(is_type_in_list(X, uneatable))
					continue
				if(!isturf(X))
					if((!X:anchored && (!istype(X,/mob/living/carbon/human))) || (src.current_size >= 9) || (istype(X,/obj/decal/cleanable)))
						step_towards(X,src)
					else if(istype(X,/mob/living/carbon/human))
						var/mob/living/carbon/human/H = X
						if(istype(H.shoes,/obj/item/clothing/shoes/magboots))
							var/obj/item/clothing/shoes/magboots/M = H.shoes
							if(M.magpulse)
								continue
						step_towards(H,src)
			return

		move()
			var/direction_go = pick(cardinal)
			if(locate(/obj/machinery/containment_field) in get_step(src,direction_go) || \
					locate(/obj/machinery/shieldwall) in get_step(src,direction_go))
				icon_state = "Singularity"
				return
			if(selfmove)
				spawn(0)
					icon_state = "singularity_s5"
					step(src, direction_go)


		Bumped(atom/A)
			consume(A)
			return

		event()
			var/numb = pick(1,2,3,4,5,6)
			switch(numb)
				if(1)//EMP
					emp_area()
				if(2)//Eats the turfs around it
					if(prob(60))
						BHolerip()
					else
						event()
				if(3,4)//tox damage all carbon mobs in area
					Toxmob()
				if(5)//Stun mobs who lack optic scanners
					Mezzer()
				else
					//do nothing
					return


		Toxmob()
			var/toxrange = 7
			if (src.energy>100)
				toxrange+=round((src.energy-100)/100)
			var/toxloss = 3
			var/radiation = 10
			var/fireloss = 0
			if (src.energy>150)
				toxloss += ((src.energy-150)/50)*3
				radiation += ((src.energy-150)/50)*10
			if (src.energy>300)
				fireloss += ((src.energy-300)/50)*3
			for(var/mob/living/carbon/M in view(toxrange, src.loc))
				if(istype(M,/mob/living/carbon/human))
					if(M:wear_suit) //TODO: check for radiation protection
						return
				M.toxloss += toxloss
				M.radiation += radiation
				M.fireloss += fireloss
				M.updatehealth()
				M << "\red You feel odd."

		Mezzer()
			for(var/mob/living/carbon/M in oviewers(8, src))
				if(istype(M,/mob/living/carbon/human))
					if(istype(M:glasses,/obj/item/clothing/glasses/meson))
						M << "\blue You look directly into The [src.name], good thing you had your protective eyewear on!"
						return
				M << "\red You look directly into The [src.name] and feel weak."
				if (M:stunned < 3)
					M.stunned = 3
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red <B>[] stares blankly at The []!</B>", M, src), 1)

		is_strippable(turf/simulated/X)
			for(var/Type in unstrippable)
				if (istype(X,Type))
					return 0
			return 1

		BHolerip()
			for (var/turf/simulated/X in orange(5,src))
				if (!is_strippable(X))
					continue
				if (!prob(30))
					continue
				var/dist = get_dist(src,X)
				if ( (dist>=3 && dist<=5) )
					if (istype(X,/turf/simulated/floor) && !istype(X,/turf/simulated/floor/plating))
						if(!X:broken)
							if(prob(80))
								new/obj/item/stack/tile (X)
								X:break_tile_to_plating()
							else

								X:break_tile()
					else if(istype(X,/turf/simulated/wall))
						X:dismantle_wall()
					else
						X:ReplaceWithFloor()

		emp_area()
			empulse(src, 6, 8)

		pulse()
			for(var/obj/machinery/power/collector_array/R in orange(15,src))
				if(istype(R,/obj/machinery/power/collector_array))
					R.receive_pulse(energy)
			return