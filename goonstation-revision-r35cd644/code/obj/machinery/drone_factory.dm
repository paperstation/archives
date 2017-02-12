
/obj/machinery/drone_factory
	name = "Drone Factory"
	desc = "A slightly mysterious looking factory that spits out weird looking drones every so often. Why not."
	icon = 'icons/obj/manufacturer.dmi'
	icon_state = "fab"
	density = 1
	anchored = 1
	power_usage = 50
	var/nextBuild = 0
	var/buildInterval = 3000 //5 minutes in ticks
	var/obj/machinery/floorflusher/flusher

	New()
		..()
		src.nextBuild = world.timeofday + buildInterval
		//search nearby turfs for flusher
		spawn(0)
			//src.flusher = locate(/obj/machinery/floorflusher) in range(1, src)
			src.createDrone() //start the round off with a drone

	process()
		//power usage modifications here
		..()

		//deal with the counter for creating new drones
		if (nextBuild && world.timeofday >= nextBuild)
			src.createDrone()
			src.nextBuild = world.timeofday + buildInterval

	//Make a brand new drone!
	proc/createDrone()
		//Check output areas for a free spot
		var/emptySpot = 0
		for (var/obj/machinery/drone_recharger/factory/C in machines)
			if (!C.occupant)
				emptySpot = 1
				break

		if (!emptySpot) //No free chargers ohno
			//error out visibly, with sound
			world.log << "no empty spots"
			return

		var/mob/living/silicon/ghostdrone/G = new/mob/living/silicon/ghostdrone()
		G.newDrone = 1

		//do some beep boops for a successful build

		G.set_loc(get_turf(src))
		sleep(20) //2 seconds
		var/turf/T = get_step(src, EAST)
		G.set_loc(T)
		//G.throw_at(T, 1, 1)

		return 1

	ex_act(severity)

	blob_act(var/power)

	meteorhit()

	emp_act()

	bullet_act(var/obj/projectile/P)

	power_change()

	attack_hand(var/mob/user as mob)

	emag_act(var/mob/user, var/obj/item/card/emag/E)

	attackby(obj/item/W as obj, mob/user as mob)

