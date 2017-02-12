/datum/random_event/major/black_hole
	name = "Black Hole"
	centcom_headline = "Gravitational Anomaly"
	centcom_message = "Severe gravitational distortion detected on the station. Personnel should evacuate any areas affected by suspicious phenomenae."
	required_elapsed_round_time = 24000 // 45m
	message_delay = 30 // 3 seconds
	customization_available = 1
	var/bhole_delay = 50 // 5 seconds
	var/sound/bhole_spawn = 'sound/machines/satcrash.ogg'
	var/sound/bhole_warning = 'sound/ambience/creaking_metal.ogg'
#if defined(MAP_OVERRIDE_DESTINY)
	disabled = 1
#endif

	event_effect(var/source,var/turf/T,var/delay,var/duration)
		..()

		if (!istype(T,/turf/))
			T = pick(blobstart)

		message_admins("Black Hole will appear in [T.loc]")
		playsound(T, bhole_warning, 100, 0, 5, 0.5)
		for (var/mob/M in range(7,T))
			boutput(M, "<span style=\"color:red\">The air grows heavy and thick. Something feels terribly wrong.</span>")
			shake_camera(M, 5, 1)
		for (var/turf/TF in range(3,T))
			animate_shake(TF,5,1 * get_dist(TF,T),1 * get_dist(TF,T))
		particleMaster.SpawnSystem(new /datum/particleSystem/bhole_warning(T))

		var/delay_time = 0
		if (delay < 0)
			delay_time = bhole_delay
		else
			delay_time = delay

		var/bhole_duration = 0
		if (duration < 1)
			bhole_duration = rand(50,300)
		else
			bhole_duration = duration

		spawn(delay_time)
			playsound(T, bhole_spawn, 100, 0, 3, 0.8)
			new /obj/bhole(T,bhole_duration)

	admin_call(var/source)
		if (..())
			return
		var/turf/T = null
		var/locinput = alert(usr,"Where do you want the black hole to spawn?.","Black Hole","My Current Tile","Random Location")
		if (locinput == "My Current Tile")
			T = get_turf(usr)
		else
			T = pick(blobstart)

		var/warninput = input(usr,"How long between the warning and the black hole spawning? (10 = 1 second, Negative number to cancel)","Black Hole") as num
		if (warninput < 0)
			return
		var/durinput = input(usr,"How long does the black hole stick around? (10 = 1 second, Negative number to cancel)","Black Hole") as num
		if (durinput < 0)
			return

		src.event_effect(source,T,warninput,durinput)
		return

/obj/bhole
	name = "black hole"
	icon = 'icons/effects/160x160.dmi'
	desc = "FUCK FUCK FUCK AAAHHH"
	icon_state = "bhole"
	opacity = 0
	density = 0
	anchored = 1
	pixel_x = -64
	pixel_y = -64
	var/move_prob = 12
	New(var/loc,duration, move_prob = -1)
		if (duration < 1)
			duration = rand(50,300)

		if(move_prob > -1 ) src.move_prob = move_prob

		spawn(duration)
			qdel(src)
		spawn(0)
			src.life()

	Bumped(atom/A)
		if (istype(A,/mob/living))
			A:gib()
		else if(isobj(A))
			var/obj/O = A
			O.ex_act(1)
			if(O)
				qdel(O)

	proc/life()
		for (var/atom/X in range(7,src))
			if (X == src)
				continue
			if(isobj(X))
				var/obj/O = X
				var/pull_prob = 0
				var/hit_strength = 0
				var/distance = get_dist(src,O)
				switch(distance)
					if (-INFINITY to 0)
						src.Bumped(O)
						continue
					if (1 to 2)
						pull_prob = 100
						hit_strength = 1
					if (3 to 4)
						pull_prob = 75
						hit_strength = 2
					if (5 to 6)
						pull_prob = 50
						hit_strength = 3
					if (6 to 7)
						pull_prob = 25

				if (O.anchored)
					if (prob(pull_prob))
						O.anchored = 0
				if (prob(pull_prob))
					step_towards(O,src)
					if (hit_strength)
						O.ex_act(hit_strength)

			if (ismob(X))
				var/mob/M = X
				step_towards(M,src)
				if (get_dist(src, M) <= 0)
					src.Bumped(M)

			if (isturf(X))
				var/turf/T = X
				var/shred_prob = 0
				var/distance = get_dist(src,T)
				switch(distance)
					if (-INFINITY to 0)
						T.ReplaceWithSpace()
					if (1 to 3)
						shred_prob = 90
					if (4 to 6)
						shred_prob = 40
					if (6 to 7)
						shred_prob = 10
				if (prob(shred_prob))
					shred_terrain(T)

		if(prob(move_prob))
			step(src,pick(cardinal))

		spawn(15)
			life()

	proc/shred_terrain(var/turf/simulated/T)
		if (!T)
			return

		if(istype(T,/turf/simulated/floor))
			var/turf/simulated/floor/F = T
			if(!F.broken)
				if(prob(80))
					var/obj/item/tile/TILE = new /obj/item/tile(F)
					if (F.material)
						TILE.setMaterial(F.material)
					else
						var/datum/material/M = getCachedMaterial("steel")
						TILE.setMaterial(M)
					F.break_tile_to_plating(1)
				else
					F.break_tile(1)
			else
				F.ReplaceWithSpace()

		else if (istype(T,/turf/simulated/wall))
			var/atom/A = new /obj/structure/girder/reinforced(T)
			var/atom/B = new /obj/item/raw_material/scrap_metal(T)
			if(T.material)
				A.setMaterial(T.material)
				B.setMaterial(T.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				A.setMaterial(M)
				B.setMaterial(M)

			T.ReplaceWithFloor()

		else
			return

// Particle FX

