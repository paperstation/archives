/var/const/meteor_wave_delay = 625 //minimum wait between waves in tenths of seconds
//set to at least 100 unless you want evarr ruining every round

/var/const/meteors_in_wave = 50
/var/const/meteors_in_small_wave = 10

/proc/meteor_wave(var/number = meteors_in_wave)
	if(!ticker || wavesecret)
		return

	wavesecret = 1
	for(var/i = 0 to number)
		spawn(rand(10,100))
			spawn_meteor()
	spawn(meteor_wave_delay)
		wavesecret = 0

/proc/spawn_meteors(var/number = meteors_in_small_wave)
	for(var/i = 0; i < number; i++)
		spawn(0)
			spawn_meteor()


/proc/spawn_meteor()
	var/startx
	var/starty
	var/endx
	var/endy
	var/turf/pickedstart
	var/turf/pickedgoal

	for(var/attempt = 0, attempt < 4, attempt++)
		switch(pick(1,2,3,4))
			if(1) //NORTH
				starty = world.maxy-(TRANSITIONEDGE+1)
				startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
				endy = TRANSITIONEDGE
				endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
			if(2) //EAST
				starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
				startx = world.maxx-(TRANSITIONEDGE+1)
				endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
				endx = TRANSITIONEDGE
			if(3) //SOUTH
				starty = (TRANSITIONEDGE+1)
				startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
				endy = world.maxy-TRANSITIONEDGE
				endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
			if(4) //WEST
				starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
				startx = (TRANSITIONEDGE+1)
				endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
				endx = world.maxx-TRANSITIONEDGE
		pickedstart = locate(startx, starty, 1)
		pickedgoal = locate(endx, endy, 1)
		if(istype(pickedstart, /turf/space))//If we have selected a space tile then break the loop
			break

	var/obj/effect/meteor/M
	if(prob(10))
		M = new /obj/effect/meteor/big(pickedstart)
	else
		M = new /obj/effect/meteor(pickedstart)

	M.dest = pickedgoal
	spawn(0)
		walk_towards(M, M.dest, 1)
	return


/obj/effect/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "flaming"
	density = 1
	anchored = 1.0
	var/hits = 1
	var/dest
	pass_flags = PASSTABLE
	var/shake_chance = 50

	Bump(atom/A)
		spawn(0)
			if(prob(shake_chance))
				for(var/mob/M in range(6, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
						shake_camera(M, 3, 1)
			if(A)
				A.meteorhit(src)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
			hits--
			if(hits <= 0)
				//Prevent meteors from blowing up the singularity's containment.
				//Changing emitter and generator ex_act would result in them being bomb and C4 proof.
				if(prob(15))
					if(prob(5))
						explosion(src.loc, 2, 4, 6, 8, 0)
					else
						explosion(src.loc, 1, 2, 3, 4, 0)
				del(src)
		return


	ex_act(severity)
		del(src)
		return


/obj/effect/meteor/big
	name = "big meteor"
	hits = 5
	shake_chance = 80

/obj/effect/meteor/corgi
	name = "corgi"
	hits = 3
	shake_chance = 20