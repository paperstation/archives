/turf
	icon = 'floors.dmi'
	var/intact = 1 //for floors, use is_plating(), is_steel_floor() and is_light_floor()

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
		haslayer = 0

		blocks_air = 0
		icon_old = null
		pathweight = 1
		explosionstrength = 1
		list/obj/machinery/network/wirelessap/wireless = list( )

	proc/is_plating()
		return 0
	proc/is_asteroid_floor()
		return 0
	proc/is_steel_floor()
		return 0
	proc/is_light_floor()
		return 0
	proc/is_grass_floor()
		return 0
	proc/return_siding_icon_state()
		return 0

/turf/New()
	turfs -= src
	turfs += src

/turf/space
	icon = 'space.dmi'
	name = "\proper space"
	icon_state = "placeholder"

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/space/New()
//	icon = 'space.dmi'
	icon_state = "[pick(1,2,3,4)]"
	..()

/turf/mars
	icon = 'mars.dmi'
	name = "mars"
	icon_state = "placeholder"

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/mars/New()
	icon = 'mars.dmi'
	icon_state = "[pick(1,2,3,4,5,6)]"
	..()
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

/turf/simulated/floor/plating/airless/transitspace/doublestrength
	doublestrength = 1

/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

/turf/simulated/wall/bumpwall_invis
	name = "floor"
	icon = 'floors.dmi'
	icon_state = "largetile2"
	opacity = 0
	density = 1

/turf/simulated/shuttle/wall/heatshield
	thermal_conductivity = 0
	opacity = 0
//	explosionstrength = 5
	name = "Heat Shielding"
	icon = 'walls.dmi'
	icon_state = "thermal"

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
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon_state = "r_wall"
	opacity = 1
	density = 1
	blocks_air = 1
	walltype = "rwall"

	var/d_state = 0


/turf/simulated/wall/alien_wall
	name = "Alien wall"
	desc = "A wall unlike anything you've seen before, unless you've watched a sci-fi movie."
	icon = 'alienwall.dmi'
	icon_state = "wall0"
	opacity = 1
	density = 1
	blocks_air = 1
	walltype = "wall"

	var/d_state = 0
/turf/simulated/wall/r_wall/Science
	icon_state = "scir0"
	walltype = "scir"
	thermal_conductivity = 0

/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'walls.dmi'
	opacity = 1
	density = 1
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall

	var/walltype = "wall"
/turf/simulated/wall/Researchstation
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'walls.dmi'
	icon_state = "sciwall2"
	opacity = 1
	density = 1
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall

	walltype = "sciwall"
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
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated
	intact = 1
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



/turf/simulated/wall/mineral
	icon = 'mineral_walls.dmi'
	walltype = "iron"

	var/oreAmount = 1
	var/hardness = 1

	New()
		..()
		name = "[walltype] wall"

	dismantle_wall(devastated = 0)
		if(!devastated)
			var/ore = text2path("/obj/item/weapon/ore/[walltype]")
			for(var/i = 1, i <= oreAmount, i++)
				new ore(src)
			ReplaceWithFloor()
		else
			ReplaceWithSpace()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/weapon/tgpickaxe))
			var/obj/item/weapon/tgpickaxe/digTool = W
			user << "You start digging the [name]."
			if(do_after(user,digTool.digspeed*hardness) && src)
				user << "You finished digging."
				dismantle_wall()
		else if(istype(W,/obj/item/weapon)) //not sure, can't not just weapons get passed to this proc?
			hardness -= W.force/100
			user << "You hit the [name] with your [W.name]!"
			CheckHardness()
		else
			attack_hand(user)
		return

	proc/CheckHardness()
		if(hardness <= 0)
			dismantle_wall()

/turf/simulated/wall/mineral/iron
	walltype = "iron"
	hardness = 3

/turf/simulated/wall/mineral/silver
	walltype = "silver"
	hardness = 3

/turf/simulated/wall/mineral/uranium
	walltype = "uranium"
	hardness = 3

	New()
		..()
		ul_SetLuminosity(3)

/turf/simulated/wall/mineral/gold
	walltype = "gold"

/turf/simulated/wall/mineral/sand
	walltype = "sand"
	hardness = 0.5

/turf/simulated/wall/mineral/transparent
	opacity = 0

/turf/simulated/wall/mineral/transparent/diamond
	walltype = "diamond"
	hardness = 10

/turf/simulated/wall/mineral/transparent/plasma
	walltype = "plasma"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/weapon/weldingtool))
			if(W:welding)
				return TemperatureAct(100)
		..()

	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if(exposed_temperature > 300)
			TemperatureAct(exposed_temperature)

	proc/TemperatureAct(temperature)
		for(var/turf/simulated/floor/target_tile in range(2,loc))
			if(target_tile.parent && target_tile.parent.group_processing)
				target_tile.parent.suspend_group_processing()

			var/datum/gas_mixture/napalm = new

			var/toxinsToDeduce = temperature/10

			napalm.toxins = toxinsToDeduce
			napalm.temperature = 400+T0C

			target_tile.assume_air(napalm)
			spawn (0) target_tile.hotspot_expose(temperature, 400)

			hardness -= toxinsToDeduce/100
			CheckHardness()