// handles mobs
datum/controller/process/mobs
	var/tmp/list/detailed_count
	var/tmp/tick_counter
	var/list/mobs

	var/list/living = list()
	var/list/wraiths = list()
	var/list/adminghosts = list()

	setup()
		name = "Mob"
		schedule_interval = 20
		detailed_count = new
		src.mobs = global.mobs

	copyStateFrom(var/datum/controller/process/mobs/other)
		detailed_count = other.detailed_count

	doWork()
		var/currentTick = ticks

		src.mobs = global.mobs
		var/c
		
		for(var/mob/living/M in src.mobs)
			M.Life(src)
			if (!(c++ % 5))
				scheck(currentTick)

		for(var/mob/wraith/W in src.mobs)
			W.Life(src)
			scheck(currentTick)
		
		// For periodic antag overlay updates (Convair880).
		for (var/mob/dead/G in src.mobs)
			if (isadminghost(G))
				G:Life(src)
				scheck(currentTick)
				
		/*
		for(var/mob/living/M in src.mobs)
			tick_counter = world.timeofday

			M.Life(src)

			tick_counter = world.timeofday - tick_counter
			if (M && tick_counter > 0)
				detailed_count["[M.type]-[M.name]"] += tick_counter

			scheck(currentTick)

		// a r g h
		for (var/mob/wraith/W in src.mobs)
			W.Life(src)
			scheck(currentTick)
		*/
	tickDetail()
		if (detailed_count && detailed_count.len)
			var/stats = "<b>[name] ticks:</b><br>"
			var/count
			for (var/thing in detailed_count)
				count = detailed_count[thing]
				if (count > 4)
					stats += "[thing] used [count] ticks.<br>"
			boutput(usr, "<br>[stats]")
