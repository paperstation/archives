/turf
	icon = 'floors.dmi'
	var/intact = 1

	level = 1.0

	var
		//Properties for open tiles (/floor)
		oxygen = 0
		carbon_dioxide = 0
		nitrogen = 0
		toxins = 0

		//Properties for airtight tiles (/wall)
		thermal_conductivity = 0.05
		heat_capacity = 1

		//Properties for both
		temperature = T20C

		blocks_air = 0
		icon_old = null
		pathweight = 1

/turf/space
	icon = 'space.dmi'
	name = "space"
	icon_state = "placeholder"

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/space/New()
	icon_state = "[pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25)]"
/*
/turf/space/suck
	icon = 'space.dmi'
	name = "space"
	icon_state = "placeholder"

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/space/suck/New()
	icon_state = "[pick(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25)]"
	pulltowards()

/turf/space/suck/proc/pulltowards()
	sleep(20)
	for(var/obj/M in orange(20,src))
		if(!M.anchored)
			var/i
			var/iter = rand(1,2)
			for(i=0,i<iter,i++)
				step_towards(M,src)
	sleep(20)
	pulltowards()
*/

/turf/simulated/floor/plating/airless/transitspace
	icon = 'space.dmi'
	name = "space"
	icon_state = "transitspace_fast"
	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000
	oxygen = 0.01
	nitrogen = 0.01
	var/doublestrength = 0

/turf/simulated/floor/plating/airless/transitspace/up
	icon_state = "transitspace_fast_up"

/turf/simulated/floor/plating/airless/transitspace/right
	icon_state = "transitspace_fast_right"

/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB


/turf/simulated/floor
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "floor"
	thermal_conductivity = 0.040
	heat_capacity = 225000
	desc = "You walk on it. If you're not walking on it you're likely either in space or on a segway, in either case, god help you."
	var/broken = 0
	var/burnt = 0

	airless
		name = "airless floor"
		oxygen = 0.01
		nitrogen = 0.01
		temperature = TCMB

		New()
			..()
			name = "floor"

	puzzlechamber
		name = "floor"
		icon_state = "largetile2"

	puzzlechamber/water
		name = "water"
		icon_state = "water"

	puzzlechamber/fire
		name = "fire floor"
		icon_state = "burning"

	puzzlechamber/ice
		name = "ice floor"
		icon_state = "icefloor"

	puzzlechamber/superconveyor
		name = "conveyor floor"
		icon_state = "superconveyor"

	puzzlechamber/newwall
		name = "floor"
		icon_state = "largetile2"

	puzzlechamber/itemthief
		name = "item confiscation field"
		icon_state = "itemthief"

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	intact = 0

/turf/simulated/floor/plating/airless
	name = "airless plating"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/simulated/floor/grid
	icon = 'floors.dmi'
	icon_state = "circuit"

/turf/simulated/wall/bumpwall_invis
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "largetile2"
	opacity = 0
	density = 1

/turf/simulated/wall/bumpwall_vis
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "bumpwall_vis"
	opacity = 0
	density = 1

/turf/simulated/wall/bumpwall_vis_false
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "bumpwall_vis"
	opacity = 0
	density = 1

/turf/simulated/wall/bumpwall_invis/Bumped(atom/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(M.client)
			src.icon = 'walls.dmi'
			src.icon_state = ""
			src.name = "wall"

/turf/simulated/wall/bumpwall_vis/Bumped(atom/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(M.client)
			src.icon = 'floors.dmi'
			src.icon_state = "largetile2"
			src.density = 0
			src.name = "floor"

/turf/simulated/wall/bumpwall_vis_false/Bumped(atom/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(M.client)
			src.icon = 'walls.dmi'
			src.icon_state = ""

/turf/simulated/wall/r_wall
	name = "r wall"
	icon = 'walls.dmi'
	icon_state = "r_wall"
	opacity = 1
	density = 1
	var/d_state = 0

/turf/simulated/wall
	name = "wall"
	icon = 'walls.dmi'
	opacity = 1
	density = 1
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/floor
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/wall
	name = "wall"
	icon = 'walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/proc
	AdjacentTurfs()
		var/L[] = new()
		for(var/turf/simulated/t in oview(src,1))
			if(!t.density)
				if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
					L.Add(t)
		return L
	Distance(turf/t)
		if(get_dist(src,t) == 1)
			var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
			cost *= (pathweight+t.pathweight)/2
			return cost
		else
			return get_dist(src,t)
	AdjacentTurfsSpace()
		var/L[] = new()
		for(var/turf/t in oview(src,1))
			if(!t.density)
				if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
					L.Add(t)
		return L
