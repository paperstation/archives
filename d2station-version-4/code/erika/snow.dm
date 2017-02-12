//separate dm since hydro is getting bloated already

/obj/decal/cleanable/snow
	name = "snow"
	anchored = 1
	opacity = 0
	density = 0
	layer = 2
	icon = 'effects.dmi'
	icon_state = "snow"
	pixel_y = 0
	pixel_x = 0
	var/endurance = 30
	var/potency = 30
	var/delay = 100
	var/floor = 0
	var/yield = 3
	var/spreadChance = 80
	var/spreadIntoAdjacentChance = 60
	var/evolveChance = 6

/obj/decal/cleanable/snow/single
	spreadChance = 0

/obj/decal/cleanable/snow/New()
	set background = 1
	..()
	pixel_y = 0
	pixel_x = 0

	dir = CalcDir()

	if(!floor)
		switch(dir) //offset to make it be on the wall rather than on the floor
			if(NORTH)
				pixel_y = 32
			if(SOUTH)
				pixel_y = -32
			if(EAST)
				pixel_x = 32
			if(WEST)
				pixel_x = -32

	spawn(2) //allows the luminosity and spread rate to be affected by potency at the moment of creation
		spawn(delay)
			if(src)
				Spread()

/obj/decal/cleanable/snow/proc/Spread()
	set background = 1
	var/spreaded = 1

	while(spreaded)
		spreaded = 0

		for(var/i=1,i<=yield,i++)
			if(prob(spreadChance))
				var/list/possibleLocs = list()
				var/spreadsIntoAdjacent = 0

				if(prob(spreadIntoAdjacentChance))
					spreadsIntoAdjacent = 1

				for(var/turf/turf in view(3,src))
					if(turf.icon == "natureicons.dmi")
						if(!turf.density && !istype(turf,/turf/space))
							if(spreadsIntoAdjacent || !locate(/obj/decal/cleanable/snow) in view(1,turf))
								possibleLocs += turf

				if(!possibleLocs.len)
					break

				var/turf/newLoc = pick(possibleLocs)

				var/snowCount = 0 //hacky
				var/placeCount = 1
				for(var/obj/decal/cleanable/snow/snow in newLoc)
					snowCount++
				for(var/wallDir in cardinal)
					var/turf/isWall = get_step(newLoc,wallDir)
					if(isWall.density)
						placeCount++
				if(snowCount >= placeCount)
					continue

				var/obj/decal/cleanable/snow/child = new /obj/decal/cleanable/snow(newLoc)
				child.potency = potency
				child.yield = yield
				child.delay = delay
				child.endurance = endurance

				spreaded++

		if(prob(evolveChance)) //very low chance to evolve on its own
			potency += rand(4,6)

		sleep(delay)

/obj/decal/cleanable/snow/proc/CalcDir(turf/location = loc)
	set background = 1
	var/direction = 16

	for(var/wallDir in cardinal)
		var/turf/newTurf = get_step(location,wallDir)
		if(newTurf.density)
			direction |= wallDir

	for(var/obj/decal/cleanable/snow/snow in location)
		if(snow == src)
			continue
		if(snow.floor) //special
			direction &= ~16
		else
			direction &= ~snow.dir

	var/list/dirList = list()

	for(var/i=1,i<=16,i <<= 1)
		if(direction & i)
			dirList += i

	if(dirList.len)
		var/newDir = pick(dirList)
		if(newDir == 16)
			floor = 1
			newDir = 1
		return newDir

	floor = 1
	return 1

/obj/decal/cleanable/snow/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	endurance -= W.force
	CheckEndurance()

/obj/decal/cleanable/snow/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
		else
	return

/obj/decal/cleanable/snow/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		endurance -= 5
		CheckEndurance()

/obj/decal/cleanable/snow/proc/CheckEndurance()
	if(endurance <= 0)
		del(src)