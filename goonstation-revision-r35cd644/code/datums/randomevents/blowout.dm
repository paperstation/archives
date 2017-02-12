/datum/random_event/major/blowout
	name = "Radioactive Blowout"
	required_elapsed_round_time = 24000 // 40m
	var/space_color = "#ff4646"

	event_effect()
		..()
		var/timetoreachsec = rand(1,9)
		var/timetoreach = rand(30,60)
		var/actualtime = timetoreach * 10 + timetoreachsec

		for (var/mob/N in mobs) // why N?  why not M?
			N.flash(30)
		var/sound/siren = sound('sound/misc/airraid_loop.ogg')
		siren.repeat = 1
		siren.channel = 5
		world << siren
		command_alert("Extreme levels of radiation detected approaching the station. All personnel have [timetoreach].[timetoreachsec] seconds to enter a maintenance tunnel or radiation safezone. Maintenance doors have temporarily had their access requirements removed. This is not a test.", "Anomaly Alert")

		for (var/obj/machinery/door/airlock/A in world)
			if (A.z != 1)
				break
			if (!(istype(A, /obj/machinery/door/airlock/maintenance) || istype(A, /obj/machinery/door/airlock/pyro/maintenance) || istype(A, /obj/machinery/door/airlock/gannets/maintenance) || istype(A, /obj/machinery/door/airlock/gannets/glass/maintenance)))
				continue
			A.req_access = null

		sleep(actualtime)

		for (var/area/A in world)
			if (A.z != 1)
				break
			if (A.do_not_irradiate)
				continue
			else
				if (!A.irradiated)
					A.irradiated = 1
				for (var/turf/T in A)
					if (rand(0,1000) < 5 && T.z == 1 && istype(T,/turf/simulated/floor))
						Artifact_Spawn(T)
					else
						continue

		siren.repeat = 0
		siren.channel = 5

		for (var/mob/N in mobs)
			N.flash(30)
		for (var/turf/space/S in world)
			if (S.z == 1)
				S.color = src.space_color
			else
				break
		world << siren

		sleep(4)

		blowout = 1

		var/sound/blowoutsound = sound('sound/misc/blowout.ogg')
		blowoutsound.repeat = 0
		blowoutsound.channel = 5
		world << blowoutsound
		boutput(world, "<span style=\"color:red\"><B>WARNING</B>: Mass radiation has struck [station_name()]. Do not leave safety until all radiation alerts have been cleared.</span>")

		for (var/mob/M in mobs)
			spawn(0)
				shake_camera(M, 840, 2)

		sleep(rand(900,1200)) // drsingh lowered these by popular request.
		command_alert("Radiation levels lowering stationwide. ETA 60 seconds until all areas are safe.", "Anomaly Alert")

		sleep(rand(250,500)) // drsingh lowered these by popular request
		command_alert("All radiation alerts onboard [station_name()] have been cleared. You may now leave the tunnels freely. Maintenance doors will regain their normal access requirements shortly.", "All Clear")

		for (var/area/A in world)
			if (A.z != 1)
				break
			if (!A.permarads)
				A.irradiated = 0

		blowout = 0

		for (var/turf/space/S in world)
			if (S.z == 1)
				S.color = null
			else
				break
		for (var/mob/N in mobs)
			N.flash(30)

		sleep(rand(250,500))

		for (var/obj/machinery/door/airlock/A in world)
			if (A.z != 1)
				break
			if (!(istype(A, /obj/machinery/door/airlock/maintenance) || istype(A, /obj/machinery/door/airlock/pyro/maintenance) || istype(A, /obj/machinery/door/airlock/gannets/maintenance) || istype(A, /obj/machinery/door/airlock/gannets/glass/maintenance)))
				continue
			A.req_access = list(access_maint_tunnels)