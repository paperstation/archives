var/global/turf/ff_debug_turf = null
var/global/client/ff_debugger = null

/turf
	icon = 'icons/turf/floors.dmi'
	var/intact = 1
	var/allows_vehicles = 1

	var/tagged = 0 // Gang wars thing

	level = 1.0

	unsimulated
		var/can_replace_with_stuff = 0	//If ReplaceWith() actually does a thing or not.
		allows_vehicles = 0

	proc/set_dir(newdir)
		dir = newdir

	proc/burn_down()
		return

	proc/debug_fireflash_here()
		set name = "Debug Fireflash Here"
		set popup_menu = 1
		set category = null
		set desc = "Debug-print the effects of all fireflashes affecting this tile."
		ff_debug_turf = src
		ff_debugger = usr.client

		//Properties for open tiles (/floor)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/toxins = 0
	//var/water = 0

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C

	var/blocks_air = 0
	var/icon_old = null
	var/pathweight = 1
	var/pathable = 1

	var/image/camera_image = null

	onMaterialChanged()
		..()
		if(istype(src.material))
			if(initial(src.opacity))
				opacity = (src.material.alpha <= MATERIAL_ALPHA_OPACITY ? 0 : 1)

		blocks_air = material.hasProperty(PROP_PERMEABILITY) ? material.getProperty(PROP_PERMEABILITY) >= 33 : blocks_air
		return

	New()
		camera_image = image('icons/mob/hud_common.dmi',src,"dither100",45)
		camera_image.alpha = 50
		camera_image.color = "#00CC00"
		..()

	serialize(var/savefile/F, var/path, var/datum/sandbox/sandbox)
		F["[path].type"] << type
		serialize_icon(F, path, sandbox)
		F["[path].name"] << name
		F["[path].dir"] << dir
		F["[path].desc"] << desc
		F["[path].color"] << color
		F["[path].density"] << density
		F["[path].opacity"] << opacity
		F["[path].pixel_x"] << pixel_x
		F["[path].pixel_y"] << pixel_y

	deserialize(var/savefile/F, var/path, var/datum/sandbox/sandbox)
		deserialize_icon(F, path, sandbox)
		F["[path].name"] >> name
		F["[path].dir"] >> dir
		F["[path].desc"] >> desc
		F["[path].color"] >> color
		F["[path].density"] >> density
		F["[path].opacity"] >> opacity
		RL_SetOpacity(opacity)
		F["[path].pixel_x"] >> pixel_x
		F["[path].pixel_y"] >> pixel_y
		return DESERIALIZE_OK

/obj/overlay/tile_effect
	name = ""
	anchored = 1
	density = 0
	mouse_opacity = 0
	icon = 'icons/effects/ULIcons.dmi'
	icon_state = "etc"
	alpha = 255
	layer = TILE_EFFECT_OVERLAY_LAYER
	animate_movement = NO_STEPS // fix for things gliding around all weird

	// splitting these up for varediting
	multiply
		blend_mode = BLEND_MULTIPLY

	additive
		blend_mode = BLEND_ADD

	pooled(var/poolname)
		overlays.len = 0
		..()

	Move()
		return 0

	unpooled()
		..()
		var/area/ourArea = get_area(src)
		if (istype(ourArea) && !ourArea.RL_Lighting)
			alpha = 0
		else
			alpha = initial(alpha)

	New()
		..()
		var/area/ourArea = get_area(src)
		if (istype(ourArea) && !ourArea.RL_Lighting)
			alpha = 0
		else
			alpha = initial(alpha)

/obj/overlay/tile_gas_effect
	name = ""
	anchored = 1
	density = 0
	mouse_opacity = 0

	pooled(var/poolname)
		overlays.len = 0
		..()

	Move()
		return 0

/turf/unsimulated/meteorhit(obj/meteor as obj)
	return

/turf/unsimulated/ex_act(severity)
	return

/turf/space
	icon = 'icons/turf/space.dmi'
	name = "space"
	icon_state = "placeholder"
#ifndef HALLOWEEN
	RL_Ignore = 1
#endif
	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000
	pathable = 0
	mat_changename = 0
	mat_changedesc = 0

/turf/space/New()
	..()
	//icon = 'icons/turf/space.dmi'
	if (icon_state == "placeholder") icon_state = "[rand(1,25)]"
	if (icon_state == "aplaceholder") icon_state = "a[rand(1,10)]"
	if (icon_state == "dplaceholder") icon_state = pick("[rand(1,25)]", "a[rand(1,10)]")
	if (icon_state == "d2placeholder") icon_state = "near_blank"
	if (blowout == 1) icon_state = "blowout[rand(1,5)]"
	if (derelict_mode == 1)
		icon = 'icons/turf/floors.dmi'
		icon_state = "darkvoid"
		name = "void"
	if(buzztile == null && prob(1) && prob(1) && src.z == 1) //Dumb shit to trick nerds.
		buzztile = src
		icon_state = "wiggle"
		src.desc = "There appears to be a spatial disturbance in this area of space."
		new/obj/item/device/key/random(src)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

// override for space turfs, since they should never hide anything
/turf/space/ReplaceWithSpace()
	return

/turf/space/proc/process_cell()
	return

/*
/turf/seafloor
	icon = 'ocean.dmi'
	name = "seafloor"
	water = 138771
	temperature = T0C + 2 // average ocean temp on Earth is roughly 1-4 °C

	New()
		..()
		icon_state = "[rand(1,20)]"
		spawn(0)
			effect_overlay = new(src)
			effect_overlay.overlays.Add(w3master)
*/
/turf/simulated
	name = "station"
	var/wet = 0
	allows_vehicles = 0
	var/image/wet_overlay = null
	var/default_melt_cap = 30

	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

	attackby(var/obj/item/W, var/mob/user)
		if (istype(W, /obj/item/pen))
			var/obj/item/pen/P = W
			P.write_on_turf(src, user)
			return
		else
			return ..()

	onMaterialChanged()
		..()
		if(src.material && istype(src.material, /datum/material/metal/steel)) //hack hack hack
			src.color = null

/turf/simulated/floor/shuttlebay
	name = "shuttle bay plating"
	icon_state = "engine"
	allows_vehicles = 1

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

	allows_vehicles = 1

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB

/turf/simulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	thermal_conductivity = 0.040
	heat_capacity = 225000
	var/broken = 0
	var/burnt = 0

	New()
		..()
		var/obj/plan_marker/floor/P = locate() in src
		if (P)
			src.icon = P.icon
			src.icon_state = P.icon_state
			src.icon_old = P.icon_state
			allows_vehicles = P.allows_vehicles
			var/pdir = P.dir
			spawn(5)
				src.dir = pdir
			qdel(P)

	airless
		name = "airless floor"
		oxygen = 0.01
		nitrogen = 0.01
		temperature = TCMB

		New()
			..()
			name = "floor"


	airless/solar
		icon_state = "solarbase"

/turf/simulated/floor/wood
	name = "wood floor"
	icon_state = "wooden-2"

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	intact = 0

/turf/simulated/floor/plating/airless
	name = "airless plating"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB
	//RL_Ignore = 1
	allows_vehicles = 1

	New()
		..()
		name = "plating"

/turf/simulated/floor/plating/airless/shuttlebay
	name = "shuttle bay plating"
	icon_state = "engine"
	allows_vehicles = 1

/turf/simulated/floor/grid
	icon = 'icons/turf/floors.dmi'
	icon_state = "circuit"

/turf/simulated/floor/metalfoam
	icon = 'icons/turf/floors.dmi'
	icon_state = "metalfoam"
	var/metal = 1
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB
	intact = 0
	allows_vehicles = 1 // let the constructor pods move around on these

	desc = "A flimsy foamed metal floor."

/turf/simulated/floor/Vspace
	name = "Vspace"
	icon = 'icons/turf/floors.dmi'
	icon_state = "flashyblue"
	var/network = "none"
	var/network_ID = "none"
	RL_Ignore = 1

/turf/simulated/floor/Vspace/brig
	name = "Brig"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	network = "prison"

/turf/simulated/aprilfools/grass
	name = "grass"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass1"

/turf/simulated/aprilfools/dirt
	name = "dirt"
	icon = 'icons/turf/floors.dmi'
	icon_state = "sand1"

/turf/simulated/wall/r_wall
	name = "r wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "r_wall"
	opacity = 1
	density = 1
	pathable = 0
	var/d_state = 0
	explosion_resistance = 7
	health = 300

	onMaterialChanged()
		..()
		if(istype(src.material))
			health = material.hasProperty(PROP_TOUGHNESS) ? round(material.getProperty(PROP_TOUGHNESS) * 4.5) : health
			if(src.material.material_flags & MATERIAL_CRYSTAL)
				health /= 2
		return

/turf/simulated/wall/supernorn
	icon = 'icons/Testing/newicons/turf/NEWwalls.dmi'
	var/mod = "" // this is probably a stupid way to do this but i am real fuckin sleepy
	var/list/connect_images = list()
	var/connected_dirs = 0

	New()
		update_icon()
		for (var/turf/simulated/wall/supernorn/T in orange(1))
			T.update_icon()
		for (var/obj/machinery/door/supernorn/O in orange(1))
			O.update_icon()
		..()

	proc/update_icon()
		var/dirs = 0
		var/list/connect_dirs = list()
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (istype(T, /turf/simulated/wall/supernorn))
				dirs |= dir
				// they are reinforced, we are not
				if (istype(T, /turf/simulated/wall/supernorn/reinforced) && !istype(src, /turf/simulated/wall/supernorn/reinforced))
					connect_dirs |= dir
				// they are not reinforced, we are
				else if (!istype(T, /turf/simulated/wall/supernorn/reinforced) && istype(src, /turf/simulated/wall/supernorn/reinforced))
					connect_dirs |= dir
			else if ((locate(/obj/machinery/door) in T) || (locate(/obj/window/supernorn) in T)) // TODO: needs to check window dirs, which isnt possible atm
				dirs |= dir
				connect_dirs |= dir
		icon_state = "[mod][num2text(dirs)]"
		connected_dirs = dirs
		//overlays = null
		for (var/dir in cardinal) // we don't need to remove every overlay, just the relevant ones
			src.UpdateOverlays(null, "connect-[dir]")
		for (var/dir in connect_dirs)
			if (!src.connect_images["connect-[dir]"])
				src.connect_images["connect-[dir]"] = image(src.icon, "connect-[dir]")
			src.UpdateOverlays(src.connect_images["connect-[dir]"], "connect-[dir]")

/turf/simulated/wall/supernorn/reinforced
	name = "reinforced wall"
	health = 300
	mod = "R"
	icon_state = "mapwall_r"

/turf/simulated/aprilfools/brick_wall
	name = "brick wall"
	icon = 'icons/misc/aprilfools.dmi'
	icon_state = "brick_wall"
	opacity = 1
	density = 1
	pathable = 0
	var/d_state = 0

/turf/simulated/aprilfools/floor/concrete_floor
	name = "concrete floor"
	icon = 'icons/misc/aprilfools.dmi'
	icon_state = "concrete"

/turf/unsimulated/aprilfools/grass
	name = "grass"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass1"
	opacity = 0
	density = 0

/turf/unsimulated/aprilfools/dirt
	name = "dirt"
	icon = 'icons/turf/floors.dmi'
	icon_state = "sand1"
	opacity = 0
	density = 0

/turf/simulated/bar
	name = "bar"
	icon = 'icons/turf/floors.dmi'
	icon_state = "bar"

/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/carpet.dmi'
	icon_state = "red1"

/turf/simulated/floor/blob
	name = "blob floor"
	icon = 'icons/mob/blob.dmi'
	icon_state = "bridge"
	default_melt_cap = 80

	New()
		..()
		setMaterial(getCachedMaterial("blob"))

	proc/setOvermind(var/mob/living/intangible/blob_overmind/O)
		if (!material)
			setMaterial(getCachedMaterial("blob"))
		material.color = O.color
		color = O.color

	attackby(var/obj/item/W, var/mob/user)
		if (istype(W, /obj/item/weldingtool))
			visible_message("<b>[user] hits [src] with [W]!</b>")
			if (prob(25))
				ReplaceWithSpace()

	ex_act(severity)
		if (prob(33))
			..(max(severity - 1, 1))
		else
			..(severity)

	burn_tile()
		return

/turf/simulated/grimycarpet
	name = "grimy carpet"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grimy"

/turf/simulated/grass
	name = "grass"
	icon = 'icons/misc/worlds.dmi'
	icon_state = "grass"

/turf/simulated/wall
	name = "wall"
	desc = "Looks like a regular wall."
	icon = 'icons/turf/walls.dmi'
	opacity = 1
	density = 1
	blocks_air = 1
	pathable = 1
	var/health = 100
	var/list/proj_impacts = list()
	var/list/forensic_impacts = list()
	var/image/proj_image = null
	var/last_proj_update_time = null

	New()
		..()
		var/obj/plan_marker/wall/P = locate() in src
		if (P)
			src.icon = P.icon
			src.icon_state = P.icon_state
			var/pdir = P.dir
			var/pop = P.turf_op
			spawn(5)
				src.dir = pdir
				src.opacity = pop
			qdel(P)

	get_desc()
		if (islist(src.proj_impacts) && src.proj_impacts.len)
			var/shots_taken = 0
			for (var/i in src.proj_impacts)
				shots_taken ++
			. += "<br>[src] has [shots_taken] hole[s_es(shots_taken)] in it."

	onMaterialChanged()
		..()
		if(istype(src.material))
			health = material.hasProperty(PROP_TOUGHNESS) ? round(material.getProperty(PROP_TOUGHNESS) * 2.5) : health
			if(src.material.material_flags & MATERIAL_CRYSTAL)
				health /= 2
		return

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m steel wall
	explosion_resistance = 2

	proc/update_projectile_image(var/update_time)
		if (src.last_proj_update_time && (src.last_proj_update_time + 1) < ticker.round_elapsed_ticks)
			return
		if (!src.proj_image)
			src.proj_image = image('icons/obj/projectiles.dmi', "blank")
		//src.overlays -= src.proj_image
		src.proj_image.overlays = null
		for (var/image/i in src.proj_impacts)
			src.proj_image.overlays += i
		src.UpdateOverlays(src.proj_image, "projectiles")
		//src.overlays += src.proj_image

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

	meteorhit()
		return

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall"
	var/icon_style = "wall"
	opacity = 1
	density = 1
	blocks_air = 1
	pathable = 0

	New()
		..()
		spawn(60) // patch up some ugly corners in derelict mode
			if (derelict_mode)
				if (src.icon_state == "[src.icon_style]_space")
					src.icon_state = "[src.icon_style]_void"

		return

/turf/simulated/shuttle/wall/escape
	opacity = 0

/turf/simulated/shuttle/wall/corner
	icon_state = "wall_space"
	opacity = 0

/turf/simulated/shuttle/wall/destroyable // for the moveable shuttles, so you can sabotage the research shuttle or whatever
	var/health = 60

	proc/checkthatshit()
		if(src.health <= 0)
			qdel(src)

/turf/space/shuttle_transit
	icon_state = "tplaceholder"

	New()
		..()
		if (icon_state == "tplaceholder") icon_state = "near_blank"

/turf/simulated/shuttle/wall/cockpit
	icon = 'icons/effects/160x160.dmi'
	icon_state = "shuttlecock"
	layer = EFFECTS_LAYER_BASE
	pixel_x = -64
	pixel_y = -64
	opacity = 0


/turf/simulated/shuttle/wall/cockpit/window
	name = "wall"
	icon_state = "wall1"
	icon = 'icons/turf/shuttle.dmi'
	opacity = 0
	pixel_x = 0
	pixel_y = 0

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	RL_Ignore = 0 // cogwerks changed as a lazy fix for newmap- if this causes problems change back to 1

	/*Enter(var/atom/movable/A)
		if (density)
			return 0
		for (var/obj/O in src)
			if (O.CanPass(A, src, ))
				return 0
		. = ..()*/

/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1
	pathable = 0

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/unsimulated/bombvr
	name = "Virtual Floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "vrfloor"

/turf/unsimulated/wall/bombvr
	name = "Virtual Wall"
	icon = 'icons/turf/floors.dmi'
	icon_state = "vrwall"

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

/turf/New()
	..()
	if (density)
		pathable = 0
	for(var/atom/movable/AM as mob|obj in src)
		if (AM) // ????
			src.Entered(AM)
	return

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover)
		return 1

	var/turf/cturf = get_turf(mover)
	if (cturf == src)
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in cturf)
		if(obstacle == mover) continue
		if((obstacle.flags & ~ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in cturf)
		if(border_obstacle == mover) continue
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle == mover) continue
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, cturf, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(obstacle == mover) continue
		if(obstacle.flags & ~ON_BORDER)
			if(!mover)	return 0
			if(!obstacle.CanPass(mover, cturf, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

/turf/Exited(atom/movable/Obj, atom/newloc)
	var/i = 0
	/*
	if (ishuman(Obj))
		var/mob/living/carbon/human/H = Obj
		if (H.sims && (locate(/obj/pool) in src))
			for (var/obj/pool/P in src)
				if (P.name == "ladder")
					qdel(P)
					break
			for (var/obj/pool/P in src)
				P.density = 1
	*/


	for(var/atom/A as mob|obj|turf|area in range(1, src))
		// I Said No sanity check
		if(i >= 50)
			break
		i++
		if(A.loc == src) A.HasExited(Obj, newloc)
		A.ProximityLeave(Obj)

	var/area/Ar = loc
	if (!Ar.skip_sims)
		if (istype(Obj, /obj/item))
			if (!(locate(/obj/table) in src) && !(locate(/obj/rack in src)))
				Ar.sims_score = min(Ar.sims_score + 4, 100)

	return ..(Obj, newloc)

/turf/Entered(atom/movable/M as mob|obj, atom/OldLoc)
	if(ismob(M) && !istype(src, /turf/space))
		var/mob/tmob = M
		tmob.inertia_dir = 0
	///////////////////////////////////////////////////////////////////////////////////
	..()
	if(src.material) src.material.triggerOnEntered(src, M)

	var/area/Ar = loc
	if (!Ar.skip_sims)
		if (istype(M, /obj/item))
			if (!(locate(/obj/table) in src) && !(locate(/obj/rack in src)))
				Ar.sims_score = max(Ar.sims_score - 4, 0)

	if(prob(1) && ishuman(M))
		var/mob/living/carbon/human/tmob = M
		if (!tmob.lying && istype(tmob.shoes, /obj/item/clothing/shoes/clown_shoes))
			if(istype(tmob.head, /obj/item/clothing/head))
				if(tmob.head.type == /obj/item/clothing/head/helmet)
					boutput(tmob, "<span style=\"color:red\">You stumble and fall to the ground. Your oddly shaped head fits poorly in this helmet!</span>")
					tmob.paralysis = max(rand(5,10), tmob.paralysis)
					random_brute_damage(tmob, 15)
				else if(istype(tmob.head, /obj/item/clothing/head/helmet))//for all non sec helmets
					boutput(tmob, "<span style=\"color:red\">You stumble and fall to the ground. Thankfully, that helmet protected you.</span>")
					tmob.weakened = max(rand(2,4), tmob.weakened)
				else if(prob(70))
					boutput(tmob, "<span style=\"color:red\">You stumble and fall to the ground. Thankfully, that hat protected you.</span>")
					tmob.weakened = max(rand(2,4), tmob.weakened)
				else
					boutput(tmob, "<span style=\"color:red\">You stumble and hit your head.</span>")
					tmob.weakened = max(rand(3,5), tmob.weakened)
			else
				boutput(tmob, "<span style=\"color:red\">You stumble and hit your head.</span>")
				tmob.weakened = max(rand(3,10), tmob.weakened)
				tmob.stuttering = max(rand(0,3), tmob.stuttering)
	var/i = 0
	for(var/atom/A as mob|obj|turf|area in src)
		// I Said No sanity check
		if(i++ >= 50)
			break
		A.HasEntered(M, OldLoc)
	i = 0
	for(var/atom/A as mob|obj|turf|area in range(1, src))
		// I Said No sanity check
		if(i++ >= 50)
			break
		A.HasProximity(M, 1)

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)

/turf/unsimulated/ReplaceWith(var/what, force = 0)
	if (can_replace_with_stuff || force)
		return ..(what)
	return

/turf/proc/ReplaceWith(var/what)
	var/turf/simulated/new_turf
	var/old_dir = dir

	var/oldmat = src.material

	if (istype(src, /turf/simulated/floor))
		icon_old = icon_state // a hack but OH WELL, leagues better than before

	if (!src.RL_Ignore)
		var/area/old_loc = src.loc
		if(old_loc)
			old_loc.contents -= src.loc

	var/new_type = text2path(what)
	if (new_type)
		new_turf = new new_type( locate(src.x, src.y, src.z) )
		if (!isturf(new_turf))
			new_turf = new /turf/space( locate(src.x, src.y, src.z) )

	else switch(what)
		if ("Floor")
			new_turf = new /turf/simulated/floor( locate(src.x, src.y, src.z) )
		if ("MetalFoam")
			new_turf = new /turf/simulated/floor/metalfoam( locate(src.x, src.y, src.z) )
		if ("EngineFloor")
			new_turf = new /turf/simulated/floor/engine( locate(src.x, src.y, src.z) )
		if ("Grid")
			new_turf = new /turf/simulated/floor/grid( locate(src.x, src.y, src.z) )
		if ("RWall")
			if (map_setting)
				if (map_setting == "COG2")
					new_turf = new /turf/simulated/wall/auto/reinforced/supernorn( locate(src.x, src.y, src.z) )
				else if (map_setting == "DESTINY")
					new_turf = new /turf/simulated/wall/auto/reinforced/gannets( locate(src.x, src.y, src.z) )
				else
					new_turf = new /turf/simulated/wall/r_wall( locate(src.x, src.y, src.z) )
			else
				new_turf = new /turf/simulated/wall/r_wall( locate(src.x, src.y, src.z) )
		if ("Wall")
			if (map_setting)
				if (map_setting == "COG2")
					new_turf = new /turf/simulated/wall/auto/supernorn( locate(src.x, src.y, src.z) )
				else if (map_setting == "DESTINY")
					new_turf = new /turf/simulated/wall/auto/gannets( locate(src.x, src.y, src.z) )
				else
					new_turf = new /turf/simulated/wall( locate(src.x, src.y, src.z) )
			else
				new_turf = new /turf/simulated/wall( locate(src.x, src.y, src.z) )
		else
			new_turf = new /turf/space( locate(src.x, src.y, src.z) )

	if(oldmat && !istype(new_turf, /turf/space)) new_turf.setMaterial(oldmat)

	new_turf.icon_old = icon_old
	new_turf.dir = old_dir
	new_turf.levelupdate()

	return new_turf

/turf/proc/ReplaceWithFloor()
	var/turf/simulated/floor = ReplaceWith("Floor")
	if (icon_old)
		floor.icon_state = icon_old
	if (map_setting)
		if (map_setting == "COG2")
			for (var/turf/simulated/wall/auto/W in orange(1))
				W.update_icon()
			for (var/obj/window/auto/W in orange(1))
				W.update_icon()
		else if (map_setting == "DESTINY")
			for (var/turf/simulated/wall/auto/W in orange(1))
				W.update_icon()
	return floor

/turf/proc/ReplaceWithMetalFoam(var/mtype)
	var/turf/simulated/floor/metalfoam/floor = ReplaceWith("MetalFoam")
	if(icon_old)
		floor.icon_state = icon_old

	floor.metal = mtype
	floor.update_icon()

	return floor

/turf/proc/ReplaceWithEngineFloor()
	var/turf/simulated/floor = ReplaceWith("EngineFloor")
	if(icon_old)
		floor.icon_state = icon_old
	return floor

/turf/proc/ReplaceWithGrid()
	var/turf/simulated/floor = ReplaceWith("Grid")
	if(icon_old)
		floor.icon_state = icon_old
	return floor

/turf/simulated/Entered(atom/movable/A, atom/OL)
	if (iscarbon(A))
		var/mob/M = A
		if (M.lying)
			return ..()
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.shoes && H.shoes.step_sound)
				if (H.m_intent == "run")
					if (H.footstep >= 2)
						H.footstep = 0
					else
						H.footstep++
					if (H.footstep == 0)
						playsound(src, H.shoes.step_sound, 50, 1)
				else
					playsound(src, H.shoes.step_sound, 20, 1)
		if (!M.throwing)
			switch (src.wet)
				if (1)
					if (locate(/obj/item/clothing/under/towel) in src)
						M.inertia_dir = 0
						src.wet = 0
						return
					if (M.can_slip())
						M.pulling = null
						M.throwing = 1
						spawn(0) // this stops the entire server from crashing when SOMEONE (read: wonk) space lubes the entire station
							step(M, M.dir)
							M.throwing = 0
						boutput(M, "<span style=\"color:blue\">You slipped on the wet floor!</span>")
						playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
						M.stunned = 2
						M.weakened = 2
						M.unlock_medal("I just cleaned that!", 1)
					else
						M.inertia_dir = 0
						return
				if (2) //lube
					M.pulling = null
					M.throwing = 1
					spawn(0)
						step(M, M.dir)
						for (var/i = 4, i>0, i--)
							if (!isturf(M.loc) || !step(M, M.dir) || i == 1)
								M.throwing = 0
								break

					random_brute_damage(M, 5)
					boutput(M, "<span style=\"color:blue\">You slipped on the floor!</span>")
					playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
					M.weakened = 5

	..()

/turf/proc/ReplaceWithSpace()
	var/area/my_area = loc
	var/turf/floor
	if (my_area)
		if (my_area.filler_turf)
			floor = ReplaceWith(my_area.filler_turf)
		else
			floor = ReplaceWith("Space")
	else
		floor = ReplaceWith("Space")

	return floor

//This is for admin replacements (deletions) ONLY. I swear to god if any actual in-game code uses this I will be pissed - Wire
/turf/proc/ReplaceWithSpaceForce()
	var/area/my_area = loc
	var/turf/floor
	if (my_area)
		if (my_area.filler_turf)
			floor = ReplaceWith(my_area.filler_turf, 1)
		else
			floor = ReplaceWith("Space", 1)
	else
		floor = ReplaceWith("Space", 1)

	return floor

/turf/proc/ReplaceWithLattice()
	new /obj/lattice( locate(src.x, src.y, src.z) )
	return ReplaceWithSpace()

/turf/proc/ReplaceWithWall()
	return ReplaceWith("Wall")

/turf/proc/ReplaceWithRWall()
	return ReplaceWith("RWall")

/turf/simulated/wall/New()
	..()
	if(!ticker && istype(src.loc, /area/station/maintenance) && prob(7))
		new /obj/decal/cleanable/fungus(src)

// Made this a proc to avoid duplicate code (Convair880).
/turf/simulated/wall/proc/attach_light_fixture_parts(var/mob/user, var/obj/item/W)
	if (!user || !W || (W && !istype(W, /obj/item/light_parts/)))
		return

	// the wall is the target turf, the source is the turf where the user is standing
	var/obj/item/light_parts/parts = W
	var/turf/target = src
	var/turf/source = get_turf(user)

	// need to find the direction to orient the new light
	var/dir = 0

	// find the direction from the mob to the target wall
	for (var/d in cardinal)
		if (get_step(source,d) == target)
			dir = d
			break

	// if no direction was found, fail. need to be standing cardinal to the wall to put the fixture up
	if (!dir)
		return //..(parts, user)

	playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
	boutput(user, "You begin to attach the light fixture to [src]...")

	if (!do_after(user, 40))
		user.show_text("You were interrupted!", "red")
		return

	// if they didn't move, put it up
	boutput(user, "You attach the light fixture to [src].")

	var/obj/machinery/light/newlight = new parts.fixture_type(source)
	newlight.dir = dir
	newlight.icon_state = parts.installed_icon_state
	newlight.base_state = parts.installed_base_state
	newlight.fitting = parts.fitting
	newlight.status = 1 // LIGHT_EMPTY

	newlight.add_fingerprint(user)
	src.add_fingerprint(user)

	user.u_equip(parts)
	qdel(parts)
	return

/turf/simulated/wall/proc/take_hit(var/obj/item/I)
	if(src.material)
		if(I.material)
			if((I.material.getProperty(PROP_HARDNESS) ? I.material.getProperty(PROP_HARDNESS) : (I.throwing ? I.throwforce : I.force)) >= (src.material.getProperty(PROP_HARDNESS) ? src.material.getProperty(PROP_HARDNESS) : 60))
				src.health -= round((I.throwing ? I.throwforce : I.force) / 10)
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] hits [src] with [I]!</span>", "<span style=\"color:red\">You hit [src] with [I]!</span>")
			else
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] uselessly hits [src] with [I].</span>", "<span style=\"color:red\">You hit [src] with [I] but it takes no damage.</span>")
		else
			if((I.throwing ? I.throwforce : I.force) >= 80)
				src.health -= round((I.throwing ? I.throwforce : I.force) / 10)
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] hits [src] with [I]!</span>", "<span style=\"color:red\">You hit [src] with [I]!</span>")
			else
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] uselessly hits [src] with [I].</span>", "<span style=\"color:red\">You hit [src] with [I] but it takes no damage.</span>")
	else
		if(I.material)
			if((I.material.getProperty(PROP_HARDNESS) ? I.material.getProperty(PROP_HARDNESS) : (I.throwing ? I.throwforce : I.force)) >= 60)
				src.health -= round((I.throwing ? I.throwforce : I.force) / 10)
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] hits [src] with [I]!</span>", "<span style=\"color:red\">You hit [src] with [I]!</span>")
			else
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] uselessly hits [src] with [I].</span>", "<span style=\"color:red\">You hit [src] with [I] but it takes no damage.</span>")
		else
			if((I.throwing ? I.throwforce : I.force) >= 80)
				src.health -= round((I.throwing ? I.throwforce : I.force) / 10)
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] hits [src] with [I]!</span>", "<span style=\"color:red\">You hit [src] with [I]!</span>")
			else
				src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] uselessly hits [src] with [I].</span>", "<span style=\"color:red\">You hit [src] with [I] but it takes no damage.</span>")

	if(health <= 0)
		src.visible_message("<span style=\"color:red\">[usr ? usr : "Someone"] destroys [src]!</span>", "<span style=\"color:red\">You destroy [src]!</span>")
		dismantle_wall(1)
	return

/turf/simulated/wall/proc/dismantle_wall(devastated=0)
	if (istype(src, /turf/simulated/wall/r_wall) || istype(src, /turf/simulated/wall/auto/reinforced))
		if (!devastated)
			playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
			var/atom/A = new /obj/structure/girder/reinforced(src)
			var/obj/item/sheet/B = new /obj/item/sheet( src )
			if (src.material)
				A.setMaterial(src.material)
				B.setMaterial(src.material)
				B.set_reinforcement(src.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				A.setMaterial(M)
				B.setMaterial(M)
				B.set_reinforcement(M)
		else
			if (prob(50)) // pardon all these nested probabilities, just trying to vary the damage appearance a bit
				var/atom/A = new /obj/structure/girder/reinforced(src)
				if (src.material)
					A.setMaterial(src.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					A.setMaterial(M)

				if (prob(50))
					var/atom/B = new /obj/item/raw_material/scrap_metal(src)
					if (src.material)
						B.setMaterial(src.material)
					else
						var/datum/material/M = getCachedMaterial("steel")
						B.setMaterial(M)

			else if( prob(50))
				var/atom/A = new /obj/structure/girder(src)
				if (src.material)
					A.setMaterial(src.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					A.setMaterial(M)

	else
		if (!devastated)
			playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
			var/atom/A = new /obj/structure/girder(src)
			var/atom/B = new /obj/item/sheet( src )
			var/atom/C = new /obj/item/sheet( src )
			if (src.material)
				A.setMaterial(src.material)
				B.setMaterial(src.material)
				C.setMaterial(src.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				A.setMaterial(M)
				B.setMaterial(M)
				C.setMaterial(M)
		else
			if (prob(50))
				var/atom/A = new /obj/structure/girder/displaced(src)
				if (src.material)
					A.setMaterial(src.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					A.setMaterial(M)

			else if (prob(50))
				var/atom/B = new /obj/structure/girder(src)

				if (src.material)
					B.setMaterial(src.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					B.setMaterial(M)

				if (prob(50))
					var/atom/C = new /obj/item/raw_material/scrap_metal(src)
					if (src.material)
						C.setMaterial(src.material)
					else
						var/datum/material/M = getCachedMaterial("steel")
						C.setMaterial(M)

	var/atom/D = ReplaceWithFloor()
	if (src.material)
		D.setMaterial(src.material)
	else
		var/datum/material/M = getCachedMaterial("steel")
		D.setMaterial(M)

/turf/simulated/wall/burn_down()
	src.ReplaceWithFloor()

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1)
			src.ReplaceWithSpace()
			return
		if(2)
			if (prob(40))
				dismantle_wall(1)
		if(3)
			if (prob(66))
				dismantle_wall(1)
		else
	return

/turf/simulated/wall/blob_act(var/power)
	if(prob(power))
		dismantle_wall(1)

/turf/simulated/wall/attack_hand(mob/user as mob)
	if (user.bioHolder.HasEffect("hulk"))
		if (prob(40))
			boutput(usr, text("<span style=\"color:blue\">You smash through the [src.name].</span>"))
			dismantle_wall(1)
			return
		else
			boutput(usr, text("<span style=\"color:blue\">You punch the [src.name].</span>"))
			return

	if(src.material)
		var/fail = 0
		if(prob(src.material.getProperty(PROP_INSTABILITY))) fail = 1
		if(src.material.quality < 0) if(prob(abs(src.material.quality))) fail = 1

		if(fail)
			user.visible_message("<span style=\"color:red\">You punch the wall and it [getMatFailString(src.material.material_flags)]!</span>","<span style=\"color:red\">[user] punches the wall and it [getMatFailString(src.material.material_flags)]!</span>")
			playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
			del(src)
			return

	boutput(user, "<span style=\"color:blue\">You hit the [src.name] but nothing happens!</span>")
	playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
	return

/turf/simulated/wall/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/pen))
		var/obj/item/pen/P = W
		P.write_on_turf(src, user)
		return

	else if (istype(W, /obj/item/light_parts))
		src.attach_light_fixture_parts(user, W) // Made this a proc to avoid duplicate code (Convair880).
		return

	else if (istype(W, /obj/item/weldingtool) && W:welding)
		W:eyecheck(user)
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (W:get_fuel() < 5)
			boutput(user, "<span style=\"color:blue\">You need more welding fuel to complete this task.</span>")
			return
		W:use_fuel(5)

		boutput(user, "<span style=\"color:blue\">Now disassembling the outer wall plating.</span>")
		playsound(src.loc, "sound/items/Welder.ogg", 100, 1)

		sleep(100)


		if ((user.loc == T && user.equipped() == W))
			boutput(user, "<span style=\"color:blue\">You disassembled the outer wall plating.</span>")
			dismantle_wall()
		else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
			boutput(user, "<span style=\"color:blue\">You disassembled the outer wall plating.</span>")
			dismantle_wall()

//Spooky halloween key
	else if(istype(W,/obj/item/device/key/haunted))
		//Okay, create a temporary false wall.
		if(W:last_use && ((W:last_use + 300) >= world.time))
			boutput(user, "<span style=\"color:red\">The key won't fit in all the way!</span>")
			return
		user.visible_message("<span style=\"color:red\">[user] inserts [W] into [src]!</span>","<span style=\"color:red\">The key seems to phase into the wall.</span>")
		W:last_use = world.time
		blink(src)
		new /turf/simulated/wall/false_wall/temp(src)
		return

//grabsmash
	else if (istype(W, /obj/item/grab/))
		var/obj/item/grab/G = W
		if  (!grab_smash(G, user))
			return ..(W, user)
		else return

	else
		if(src.material)
			var/fail = 0
			if(prob(src.material.getProperty(PROP_INSTABILITY))) fail = 1
			if(src.material.quality < 0) if(prob(abs(src.material.quality))) fail = 1

			if(fail)
				user.visible_message("<span style=\"color:red\">You hit the wall and it [getMatFailString(src.material.material_flags)]!</span>","<span style=\"color:red\">[user] hits the wall and it [getMatFailString(src.material.material_flags)]!</span>")
				playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
				del(src)
				return

		src.take_hit(W)
		//return attack_hand(user)

/turf/simulated/wall/r_wall/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/pen))
		var/obj/item/pen/P = W
		P.write_on_turf(src, user)
		return

	else if (istype(W, /obj/item/light_parts))
		src.attach_light_fixture_parts(user, W) // Made this a proc to avoid duplicate code (Convair880).
		return

	else if (istype(W, /obj/item/weldingtool) && W:welding)
		W:eyecheck(user)
		var/turf/T = user.loc
		if (!( istype(T, /turf) ))
			return

		if (src.d_state == 2)
			boutput(user, "<span style=\"color:blue\">Slicing metal cover.</span>")
			playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
			sleep(60)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 3
				boutput(user, "<span style=\"color:blue\">You removed the metal cover.</span>")
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				src.d_state = 3
				boutput(user, "<span style=\"color:blue\">You removed the metal cover.</span>")

		else if (src.d_state == 5)
			boutput(user, "<span style=\"color:blue\">Removing support rods.</span>")
			playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 6
				var/atom/A = new /obj/item/rods( src )
				if (src.material)
					A.setMaterial(src.material)
				else
					A.setMaterial(getCachedMaterial("steel"))
				boutput(user, "<span style=\"color:blue\">You removed the support rods.</span>")
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				src.d_state = 6
				var/atom/A = new /obj/item/rods( src )
				if (src.material)
					A.setMaterial(src.material)
				else
					A.setMaterial(getCachedMaterial("steel"))
				boutput(user, "<span style=\"color:blue\">You removed the support rods.</span>")

	else if (istype(W, /obj/item/wrench))
		if (src.d_state == 4)
			var/turf/T = user.loc
			boutput(user, "<span style=\"color:blue\">Detaching support rods.</span>")
			playsound(src.loc, "sound/items/Ratchet.ogg", 100, 1)
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 5
				boutput(user, "<span style=\"color:blue\">You detach the support rods.</span>")
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				src.d_state = 5
				boutput(user, "<span style=\"color:blue\">You detach the support rods.</span>")

	else if (istype(W, /obj/item/wirecutters))
		if (src.d_state == 0)
			playsound(src.loc, "sound/items/Wirecutter.ogg", 100, 1)
			src.d_state = 1
			var/atom/A = new /obj/item/rods( src )
			if (src.material)
				A.setMaterial(src.material)
			else
				A.setMaterial(getCachedMaterial("steel"))

	else if (istype(W, /obj/item/screwdriver))
		if (src.d_state == 1)
			var/turf/T = user.loc
			playsound(src.loc, "sound/items/Screwdriver.ogg", 100, 1)
			boutput(user, "<span style=\"color:blue\">Removing support lines.</span>")
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 2
				boutput(user, "<span style=\"color:blue\">You removed the support lines.</span>")
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				src.d_state = 2
				boutput(user, "<span style=\"color:blue\">You removed the support lines.</span>")

	else if (istype(W, /obj/item/crowbar))

		if (src.d_state == 3)
			var/turf/T = user.loc
			boutput(user, "<span style=\"color:blue\">Prying cover off.</span>")
			playsound(src.loc, "sound/items/Crowbar.ogg", 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 4
				boutput(user, "<span style=\"color:blue\">You removed the cover.</span>")
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				src.d_state = 4
				boutput(user, "<span style=\"color:blue\">You removed the cover.</span>")

		else if (src.d_state == 6)
			var/turf/T = user.loc
			boutput(user, "<span style=\"color:blue\">Prying outer sheath off.</span>")
			playsound(src.loc, "sound/items/Crowbar.ogg", 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				boutput(user, "<span style=\"color:blue\">You removed the outer sheath.</span>")
				dismantle_wall()
				logTheThing("station", user, null, "dismantles a reinforced wall at [log_loc(user)].")
				return
			else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
				boutput(user, "<span style=\"color:blue\">You removed the outer sheath.</span>")
				dismantle_wall()
				logTheThing("station", user, null, "dismantles a reinforced wall at [log_loc(user)].")
				return

	//More spooky halloween key
	else if(istype(W,/obj/item/device/key/haunted))
		//Okay, create a temporary false wall.
		if(W:last_use && ((W:last_use + 300) >= world.time))
			boutput(user, "<span style=\"color:red\">The key won't fit in all the way!</span>")
			return
		user.visible_message("<span style=\"color:red\">[user] inserts [W] into [src]!</span>","<span style=\"color:red\">The key seems to phase into the wall.</span>")
		W:last_use = world.time
		blink(src)
		var/turf/simulated/wall/false_wall/temp/fakewall = new /turf/simulated/wall/false_wall/temp(src)
		fakewall.was_rwall = 1
		return

	else if ((istype(W, /obj/item/sheet)) && (src.d_state))
		var/obj/item/sheet/S = W
		var/turf/T = user.loc
		boutput(user, "<span style=\"color:blue\">Repairing wall.</span>")
		sleep(100)
		if ((user.loc == T && user.equipped() == S))
			src.d_state = 0
			src.icon_state = initial(src.icon_state)
			if(S.material)
				src.setMaterial(S.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				src.setMaterial(M)
			boutput(user, "<span style=\"color:blue\">You repaired the wall.</span>")
			if (S.amount > 1)
				S.amount--
			else
				qdel(W)
		else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
			src.d_state = 0
			src.icon_state = initial(src.icon_state)
			if(W.material) src.setMaterial(S.material)
			boutput(user, "<span style=\"color:blue\">You repaired the wall.</span>")
			if (S.amount > 1)
				S.amount--
			else
				qdel(W)

//grabsmash
	else if (istype(W, /obj/item/grab/))
		var/obj/item/grab/G = W
		if  (!grab_smash(G, user))
			return ..(W, user)
		else return

	if(istype(src, /turf/simulated/wall/r_wall) && src.d_state > 0)
		src.icon_state = "r_wall-[d_state]"

	if(src.material)
		var/fail = 0
		if(prob(src.material.getProperty(PROP_INSTABILITY))) fail = 1
		if(src.material.quality < 0) if(prob(abs(src.material.quality))) fail = 1

		if(fail)
			user.visible_message("<span style=\"color:red\">You hit the wall and it [getMatFailString(src.material.material_flags)]!</span>","<span style=\"color:red\">[user] hits the wall and it [getMatFailString(src.material.material_flags)]!</span>")
			playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
			del(src)
			return

	src.take_hit(W)
	//return attack_hand(user)


/turf/simulated/wall/meteorhit(obj/M as obj)
	dismantle_wall()
	return 0

/turf/simulated/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (!src.allows_vehicles && (istype(mover, /obj/machinery/vehicle)))
		if (!( locate(/obj/machinery/mass_driver, src) ))
			return 0
	return ..()

/turf/unsimulated/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (!src.allows_vehicles && (istype(mover, /obj/machinery/vehicle)))
		if (!( locate(/obj/machinery/mass_driver, src) ))
			return 0
	return ..()

/turf/simulated/floor/burn_down()
	src.ex_act(2)

/turf/simulated/floor/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ReplaceWithSpace()
		if(2.0)
			switch(pick(1,2;75,3))
				if (1)
					if(prob(33))
						var/obj/item/I = new /obj/item/raw_material/scrap_metal(src)
						if (src.material)
							I.setMaterial(src.material)
						else
							var/datum/material/M = getCachedMaterial("steel")
							I.setMaterial(M)
					src.ReplaceWithLattice()
				if(2)
					src.ReplaceWithSpace()
				if(3)
					if(prob(33))
						var/obj/item/I = new /obj/item/raw_material/scrap_metal(src)
						if (src.material)
							I.setMaterial(src.material)
						else
							var/datum/material/M = getCachedMaterial("steel")
							I.setMaterial(M)
					if(prob(80))
						src.break_tile_to_plating()
					else
						src.break_tile()
					src.hotspot_expose(1000,CELL_VOLUME)
		if(3.0)
			if (prob(50))
				src.break_tile()
				src.hotspot_expose(1000,CELL_VOLUME)
	return

/turf/simulated/floor/blob_act(var/power)
	return

/turf/simulated/floor/proc/update_icon()

/turf/simulated/attack_hand(mob/user as mob)
	if (src.density == 1)
		return
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (user.pulling.loc == user)
		user.pulling = null
		return
	var/turf/fuck_u = user.pulling.loc
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(M, get_dir(fuck_u, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(fuck_u, src))
	return

/turf/simulated/floor/engine/attackby(obj/item/C as obj, mob/user as mob)
	if (!C)
		return
	if (!user)
		return
	if (istype(C, /obj/item/pen))
		var/obj/item/pen/P = C
		P.write_on_turf(src, user)
		return
	else if (istype(C, /obj/item/wrench))
		boutput(user, "<span style=\"color:blue\">Removing rods...</span>")
		playsound(src.loc, "sound/items/Ratchet.ogg", 80, 1)
		if(do_after(user, 30))
			var/obj/R1 = new /obj/item/rods(src)
			var/obj/R2 = new /obj/item/rods(src)
			if (material)
				R1.setMaterial(material)
				R2.setMaterial(material)
			else
				R1.setMaterial(getCachedMaterial("steel"))
				R2.setMaterial(getCachedMaterial("steel"))
			ReplaceWithFloor()
			var/turf/simulated/floor/F = src
			F.to_plating()
			return

/turf/simulated/floor/proc/to_plating(var/force_break)
	if(!force_break)
		if(istype(src,/turf/simulated/floor/engine)) return
	if(!intact) return
	if (!icon_old)
		icon_old = icon_state
	src.icon_state = "plating"
	intact = 0
	broken = 0
	burnt = 0
	levelupdate()

/turf/simulated/floor/proc/dismantle_wall()//can get called due to people spamming weldingtools on walls
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(intact) to_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile(var/force_break)
	if(!force_break)
		if(istype(src,/turf/simulated/floor/engine)) return
		if(istype(src,/turf/simulated/floor/shuttlebay)) return

	if(broken) return
	if (!icon_old)
		icon_old = icon_state
	if(intact)
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		broken = 1
	else
		src.icon_state = "platingdmg[pick(1,2,3)]"
		broken = 1

/turf/simulated/floor/proc/burn_tile()
	if(broken || burnt) return
	if (!icon_old)
		icon_old = icon_state
	if(intact)
		src.icon_state = "floorscorched[pick(1,2)]"
	else
		src.icon_state = "panelscorched"
	burnt = 1

/turf/simulated/floor/engine/burn_tile()
	return

/turf/simulated/floor/shuttlebay/burn_tile()
	return

/turf/simulated/floor/proc/restore_tile()
	if(intact) return
	intact = 1
	broken = 0
	burnt = 0
	if(icon_old)
		icon_state = icon_old
	else
		icon_state = "floor"
	levelupdate()

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C, /obj/item/crowbar) && intact)
		if(broken || burnt)
			boutput(user, "<span style=\"color:red\">You remove the broken plating.</span>")
		else
			var/atom/A = new /obj/item/tile(src)
			if(src.material)
				A.setMaterial(src.material)
			else
				var/datum/material/M = getCachedMaterial("steel")
				A.setMaterial(M)

		to_plating()
		playsound(src.loc, "sound/items/Crowbar.ogg", 80, 1)

		return

	if (istype(C, /obj/item/pen))
		var/obj/item/pen/P = C
		P.write_on_turf(src, user)
		return

	if(istype(C, /obj/item/seed/grass) && intact)
		if(broken || burnt) boutput(user, "<span style=\"color:red\">The floor is too damaged to put space grass on.</span>")
		else if (src.icon_state == "grass1" || src.icon_state == "grass2" || src.icon_state == "grass3" || src.icon_state == "grass4")
			boutput(user, "<span style=\"color:red\">There's already some grass here.</span>")
		else
			boutput(user, "<span style=\"color:blue\">You scatter seeds on the ground.</span>")
			if (!icon_old)
				icon_old = icon_state
			var/randtime = rand(5,12)
			spawn(randtime * 10)
				var/rnpick = rand(1,4)
				src.icon_state = "grass[rnpick]"
				user.u_equip(C)
				if(C)
					C.dropped()
					qdel (C)
				return
		return

	if(istype(C, /obj/item/rods))
		if (!src.intact)
			if (C:amount >= 2)
				boutput(user, "<span style=\"color:blue\">Reinforcing the floor...</span>")
				if(do_after(user, 30))
					ReplaceWithEngineFloor()
					if (C)
						C:amount -= 2
						if (C:amount <= 0)
							qdel (C) //wtf
					if(C.material) src.setMaterial(C.material)
					playsound(src.loc, "sound/items/Deconstruct.ogg", 80, 1)
			else
				boutput(user, "<span style=\"color:red\">You need more rods.</span>")
		else
			boutput(user, "<span style=\"color:red\">You must remove the plating first.</span>")
		return

	if(istype(C, /obj/item/tile) && !intact)
		restore_tile()
		var/obj/item/tile/T = C
		if(C.material)
			src.setMaterial(C.material)
		playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1)

		if(!istype(src.material, /datum/material/metal/steel))
			logTheThing("station", user, null, "constructs a floor (<b>Material:</b>: [src.material && src.material.name ? "[src.material.name]" : "*UNKNOWN*"]) at [log_loc(src)].")

		if(--T.amount < 1)
			qdel(T)
			return

	if(istype(C, /obj/item/cable_coil))
		if(!intact)
			var/obj/item/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			boutput(user, "<span style=\"color:red\">You must remove the plating first.</span>")

//grabsmash??
	else if (istype(C, /obj/item/grab/))
		var/obj/item/grab/G = C
		if  (!grab_smash(G, user))
			return ..(C, user)
		else
			return

	else
		return attack_hand(user)

/turf/unsimulated/attack_hand(var/mob/user as mob)
	if (src.density == 1)
		return
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	var/turf/fuck_u = user.pulling.loc
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(M, get_dir(fuck_u, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(fuck_u, src))
	return

// imported from space.dm

/turf/space/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	var/turf/fuck_u = user.pulling.loc
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/t = M.pulling
		M.pulling = null
		step(M, get_dir(fuck_u, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(fuck_u, src))
	return

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/rods))
		boutput(user, "<span style=\"color:blue\">Constructing support lattice ...</span>")
		playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1)
		ReplaceWithLattice()
		if(C.material) src.setMaterial(C.material)
		C:amount--

		if (C:amount < 1)
			user.u_equip(C)
			qdel(C)
			return
		return

	if (istype(C, /obj/item/tile))
		if(locate(/obj/lattice, src))
			var/obj/lattice/L = locate(/obj/lattice, src)
			qdel(L)
			playsound(src.loc, "sound/weapons/Genhit.ogg", 50, 1)
			C:build(src)
			C:amount--
			if(C.material) src.setMaterial(C.material)
			if (C:amount < 1)
				user.u_equip(C)
				qdel(C)
				return
			return
		else
			boutput(user, "<span style=\"color:red\">The plating is going to need some support.</span>")
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if ((!(A) || src != A.loc || istype(null, /obj/projectile)))
		return

	if (!(A.last_move))
		return

//	if (locate(/obj/movable, src))
//		return 1

	if ((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1)))
		var/mob/M = A

		if ((!( M.handcuffed) && M.canmove))
			var/prob_slip = 5

			if (locate(/obj/grille, oview(1, M)) || locate(/obj/lattice, oview(1, M)) )
				if (!( M.l_hand ))
					prob_slip -= 3
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 1

				if (!( M.r_hand ))
					prob_slip -= 2
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 1
			else if (locate(/turf/unsimulated, oview(1, M)) || locate(/turf/simulated, oview(1, M)))
				if (!( M.l_hand ))
					prob_slip -= 2
				else if (M.l_hand.w_class <= 2)
					prob_slip -= 0.5

				if (!( M.r_hand ))
					prob_slip -= 1
				else if (M.r_hand.w_class <= 2)
					prob_slip -= 0.5
			prob_slip = round(prob_slip)
			if (prob_slip < 5) //next to something, but they might slip off
				if (prob(prob_slip) )
					boutput(M, "<span style=\"color:blue\"><B>You slipped!</B></span>")
					M.inertia_dir = M.last_move
					step(M, M.inertia_dir)
					return
				else
					M.inertia_dir = 0 //no inertia
			else //not by a wall or anything, they just keep going
				spawn(5)
					if (A && !( A.anchored ) && A.loc == src && !(A.flags & NODRIFT))

						var/pre_inertia_loc = M.loc

						if(M.inertia_dir) //they keep moving the same direction
							step(M, M.inertia_dir)
						else
							M.inertia_dir = M.last_move
							step(M, M.inertia_dir)

						if(M.loc == pre_inertia_loc) //something stopped them from moving
							M.inertia_dir = 0

		else //can't move, they just keep going (COPY PASTED CODE WOO)
			spawn(5)

				if ((A && !( A.anchored ) && A.loc == src))

					var/pre_inertia_loc = M.loc

					if(M.inertia_dir) //they keep moving the same direction
						step(M, M.inertia_dir)
					else
						M.inertia_dir = M.last_move
						step(M, M.inertia_dir)

					if(M.loc == pre_inertia_loc) //something stopped them from moving so cancel their inertia
						M.inertia_dir = 0

	if (src.x <= 1)
		edge_step(A, world.maxx- 2, 0)
	else if (A.x >= (world.maxx - 1))
		edge_step(A, 3, 0)
	else if (src.y <= 1)
		edge_step(A, 0, world.maxy - 2)
	else if (A.y >= (world.maxy - 1))
		edge_step(A, 0, 3)

/turf/proc/edge_step(var/atom/movable/A, var/newx, var/newy)
	var/zlevel = 3//(3,4)
	if (world.maxz < zlevel) // if there's less levels than the one we want to go to
		zlevel = 1 // just boot people back to z1 so the server doesn't lag to fucking death trying to place people on maps that don't exist
	if (istype(A, /obj/machinery/vehicle))
		var/obj/machinery/vehicle/V = A
		if (V.going_home)
			zlevel = 1
			V.going_home = 0
	if (istype(A, /obj/newmeteor))
		qdel(A)
		return
	A.z = zlevel
	if (newx)
		A.x = newx
	if (newy)
		A.y = newy
	spawn (0)
		if ((A && A.loc))
			A.loc.Entered(A)

//Vr turf is a jerk and pretends to be broken.
/turf/unsimulated/bombvr/ex_act(severity)
	switch(severity)
		if(1.0)
			src.icon_state = "vrspace"
		if(2.0)
			switch(pick(1;75,2))
				if(1)
					src.icon_state = "vrspace"
				if(2)
					if(prob(80))
						src.icon_state = "vrplating"

		if(3.0)
			if (prob(50))
				src.icon_state = "vrplating"
	return

/turf/unsimulated/wall/bombvr/ex_act(severity)
	switch(severity)
		if(1.0)
			opacity = 0
			density = 0
			src.icon_state = "vrspace"
		if(2.0)
			switch(pick(1;75,2))
				if(1)
					opacity = 0
					density = 0
					src.icon_state = "vrspace"
				if(2)
					if(prob(80))
						opacity = 0
						density = 0
						src.icon_state = "vrplating"

		if(3.0)
			if (prob(50))
				src.icon_state = "vrwallbroken"
				opacity = 0
	return


// WIP SHUTTLE DAMAGE STUFF

/turf/simulated/shuttle/wall/destroyable/ex_act(severity)
	switch(severity)
		if(1.0)
			src.health -= 40
			checkthatshit()
		if(2.0)
			src.health -= 20
			checkthatshit()
		if(3.0)
			src.health -= 5
			checkthatshit()

/turf/simulated/shuttle/wall/destroyable/meteorhit()
	src.health -= 20 // i guess this is good enough? maybe a rand argument would be better


// metal foam floors

/turf/simulated/floor/metalfoam/update_icon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironform"

/turf/simulated/floor/metalfoam/ex_act()
	ReplaceWithSpace()

/turf/simulated/floor/metalfoam/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0
	if(prob(75 - metal * 25))
		ReplaceWithSpace()
		boutput(user, "You easily smash through the foamed metal floor.")
	else
		boutput(user, "Your attack bounces off the foamed metal floor.")

////Martian Turf stuff//////////////
/turf/simulated/martian
	name = "martian"
	icon = 'icons/turf/martian.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

/turf/simulated/martian/floor
	name = "organic floor"
	icon_state = "floor1"

/turf/simulated/martian/wall
	name = "organic wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

	var/health = 40

	proc/checkhealth()
		if(src.health <= 0)
			gib(src.loc)
			ReplaceWithSpace()

/turf/simulated/martian/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.health -= 40
			checkhealth()
		if(2.0)
			src.health -= 20
			checkhealth()
		if(3.0)
			src.health -= 5
			checkhealth()

/turf/simulated/martian/wall/proc/gib(atom/location)
	if (!location) return

	var/obj/decal/cleanable/machine_debris/gib = null
	var/obj/decal/cleanable/blood/gibs/gib2 = null

	// NORTH
	gib = new /obj/decal/cleanable/machine_debris(location)
	if (prob(25))
		gib.icon_state = "gibup1"
	gib.streak(list(NORTH, NORTHEAST, NORTHWEST))

	// SOUTH
	gib2 = new /obj/decal/cleanable/blood/gibs(location)
	if (prob(25))
		gib2.icon_state = "gibdown1"
	gib2.streak(list(SOUTH, SOUTHEAST, SOUTHWEST))

	// RANDOM
	gib2 = new /obj/decal/cleanable/blood/gibs(location)
	gib2.streak(alldirs)
	sleep(-1)

// cogwerks: snow area

/turf/simulated/floor/arctic_elevator_shaft
	name = "elevator shaft"
	desc = "It looks like it goes down a long ways."
	icon_state = "void_gray"

	ex_act(severity)
		return

	Entered(atom/A as mob|obj)
		if (icefall.len)
			var/turf/T = pick(iceelefall)
			if (isturf(T))
				visible_message("<span style=\"color:red\">[A] falls down [src]!</span>")
				if (ismob(A))
					var/mob/M = A
					if(!M.stat && ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.gender == MALE) playsound(H.loc, "sound/voice/male_fallscream.ogg", 100, 0, 0, H.get_age_pitch())
						else playsound(H.loc, "sound/voice/female_fallscream.ogg", 100, 0, 0, H.get_age_pitch())
					random_brute_damage(M, 33)
					M.stunned += 10
				T.contents += A
				T.Entered(A)
				return
		else ..()

/turf/unsimulated/floor/arctic/snow
	name = "odd snow"
	desc = "Frozen carbon dioxide. Neat."
	icon_state = "grass_snow"
	carbon_dioxide = 100
	nitrogen = 0
	oxygen = 0
	temperature = 100
	RL_Ignore = 0

//okay these are getting messy as hell, i need to consolidate this shit later
/turf/unsimulated/floor/arctic/snow/ice
	name = "ice floor"
	desc = "A tunnel through the glacier. This doesn't seem to be water ice..."
	icon_state = "ice1"
	RL_Ignore = 0

	New()
		..()
		icon_state = "[pick("ice1","ice2","ice3","ice4","ice5","ice6")]"

/turf/unsimulated/floor/arctic/snow/lake
	name = "frozen lake"
	desc = "You can see the lake bubbling away under the ice. Neat."
	icon_state = "poolwaterfloor"
	RL_Ignore = 0


/turf/unsimulated/floor/arctic/plating
	name = "plating"
	desc = "It's freezing cold."
	icon_state = "plating"
	carbon_dioxide = 100
	nitrogen = 0
	oxygen = 0
	temperature = 100
	RL_Ignore = 0
	can_replace_with_stuff = 1

/turf/unsimulated/floor/arctic/abyss
	name = "deep abyss"
	desc = "You can't see the bottom."
	icon_state = "void_gray"
	carbon_dioxide = 100
	nitrogen = 0
	oxygen = 0
	temperature = 100
	RL_Ignore = 0
	pathable = 0
	can_replace_with_stuff = 1

	// this is the code for falling from abyss into ice caves
	// could maybe use an animation, or better text. perhaps a slide whistle ogg?
	Entered(atom/A as mob|obj)
		if (istype(A, /mob/dead))
			return ..()

		if (icefall.len)
			var/turf/T = pick(icefall)
			fall_to(T, A)
			return
		else ..()

/turf/unsimulated/floor/arctic/cliff
	name = "icy cliff"
	desc = "Looks dangerous."
	icon_state = "snow_cliff1"
	carbon_dioxide = 100
	nitrogen = 0
	oxygen = 0
	temperature = 100
	RL_Ignore = 0
	can_replace_with_stuff = 1

	New()
		..()
		icon_state = "[pick("snow_cliff1","snow_cliff2","snow_cliff3","snow_cliff4")]"

/turf/unsimulated/floor/arctic/cliff_outsidecorner
	name = "icy cliff"
	desc = "Looks dangerous."
	icon_state = "snow_corner"
	dir = 5
	carbon_dioxide = 100
	nitrogen = 0
	oxygen = 0
	temperature = 100
	RL_Ignore = 0
	can_replace_with_stuff = 1

/turf/unsimulated/wall/arctic/abyss
	name = "deep abyss"
	desc = "You can't see the bottom."
	icon_state = "void_gray"
	blocks_air = 1
	opacity = 1
	density = 1
	RL_Ignore = 0

/turf/unsimulated/wall/arctic/abyss
	name = "deep abyss"
	desc = "You can't see the bottom."
	icon_state = "void_gray"
	opacity = 1
	density = 1


//this also sucks and needs to be consolidated, just bugtesting right now
/turf/unsimulated/wall/arctic/abyss/ice
	name = "ice wall"
	desc = "You're inside a glacier. Wow."
	icon_state = "ice1"
	RL_Ignore = 0

	New()
		..()
		icon_state = "[pick("ice1","ice2","ice3","ice4","ice5","ice6")]"


// cogwerks - catwalk plating

/turf/simulated/floor/plating/airless/catwalk
	name = "catwalk support"
	icon_state = "catwalk"
	allows_vehicles = 1

/////////////////////// cogwerks - setpiece stuff

/turf/unsimulated/wall/setpieces
	icon = 'icons/misc/worlds.dmi'
	RL_Ignore = 0

	bloodwall
		name = "Bloody Wall"
		desc = "Gross."
		icon = 'icons/misc/meatland.dmi'
		icon_state = "bloodwall_1"

	leadwall
		name = "Shielded Wall"
		desc = "Seems pretty sturdy."
		icon_state = "leadwall"

		gray
			icon_state = "leadwall_gray"

		white
			name = "Microwave Power Transmitter"
			desc = "The outer shell of some large microwave array thing."
			icon_state = "leadwall_white"

	leadwindow
		name = "Shielded Window"
		desc = "Seems pretty sturdy."
		icon_state = "leadwindow_1"
		opacity = 0

		gray
			icon_state = "leadwindow_gray_1"

	rootwall
		name = "Overgrown Wall"
		desc = "This wall is covered in vines."
		icon_state = "rootwall"

	bluewall
		name = "blue wall"
		desc = "This doesn't look normal at all."
		icon_state = "bluewall"

	bluewall_glowing
		name = "glowing wall"
		desc = "It seems to be humming slightly. Huh."
		luminosity = 2
		icon_state = "bluewall_glow"
		can_replace_with_stuff = 1

		attackby(obj/item/W as obj, mob/user as mob)
			if (istype(W, /obj/item/device/key))
				playsound(src.loc, "sound/effects/mag_warp.ogg", 50, 1)
				src.visible_message("<span style=\"color:blue\"><b>[src] slides away!</b></span>")
				src.ReplaceWithSpace() // make sure the area override says otherwise - maybe this sucks

	hive
		name = "hive wall"
		desc = "Honeycomb's big, yeah yeah yeah."
		icon = 'icons/turf/walls.dmi'
		icon_state = "hive"

// -------------------- VR --------------------
/turf/unsimulated/floor/setpieces/gauntlet
	name = "Gauntlet Floor"
	desc = "Artist needs effort badly."
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntfloorDefault"

/turf/unsimulated/wall/setpieces/gauntlet
	name = "Gauntlet Wall"
	desc = "Is this retro? Thank god it's not team ninja."
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntwall"
// --------------------------------------------

/turf/proc/fall_to(var/turf/T, var/atom/A)
	if(istype(A, /obj/overlay/tile_effect)) //Ok enough light falling places. Fak.
		return
	if (isturf(T))
		visible_message("<span style=\"color:red\">[A] falls into [src]!</span>")
		if (ismob(A))
			var/mob/M = A
			if(!M.stat && ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.gender == MALE) playsound(H.loc, "sound/voice/male_fallscream.ogg", 100, 0, 0, H.get_age_pitch())
				else playsound(H.loc, "sound/voice/female_fallscream.ogg", 100, 0, 0, H.get_age_pitch())
			random_brute_damage(M, 50)
			M.paralysis += 5
			spawn(0)
				playsound(M.loc, pick('sound/effects/splat.ogg', 'sound/effects/fleshbr1.ogg'), 75, 1)
		T.contents += A
		T.Entered(A)
		return

/turf/unsimulated/floor/setpieces
	icon = 'icons/misc/worlds.dmi'
	RL_Ignore = 0

	ancient_pit
		name = "Broken Stairs"
		desc = "You can't see the bottom."
		icon_state = "black"

		Entered(atom/A as mob|obj)
			if (istype(A, /mob/dead) || (istype(A, /obj/critter) && A:flying))
				return ..()

			if (ancientfall.len)
				var/turf/T = pick(ancientfall)
				fall_to(T, A)
				return
			else ..()

		shaft
			name = "Elevator Shaft"

	bloodfloor
		name = "Bloody Floor"
		desc = "Yuck."
		icon_state = "bloodfloor_1"

	rootfloor
		name = "Overgrown Floor"
		desc = "This floor is covered in vines."
		icon_state = "rootfloor_1"

	oldfloor
		name = "Floor"
		desc = "Looks a bit different."
		icon_state = "old_floor1"

	bluefloor
		name = "Blue Floor"
		desc = "This floor looks awfully strange."
		icon_state = "bluefloor"

		pit
			name = "Ominous Pit"
			desc = "You can't see the bottom."
			icon_state = "deeps"

			Entered(atom/A as mob|obj)
				if (istype(A, /mob/dead))
					return ..()

				if (deepfall.len)
					var/turf/T = pick(deepfall)
					fall_to(T, A)
					return
				else ..()

	hivefloor
		name = "hive floor"
		desc = ""
		icon = 'icons/turf/floors.dmi'
		icon_state = "hive"

	swampgrass
		name = "reedy grass"
		desc = ""
		icon = 'icons/misc/worlds.dmi'
		icon_state = "swampgrass"

		New()
			..()
			dir = pick(1,2,4,8)
			return

	swampgrass_edging
		name = "reedy grass"
		desc = ""
		icon = 'icons/misc/worlds.dmi'
		icon_state = "swampgrass_edge"

////////////////////////////////////////////////

//stuff ripped out of keelinsstuff.dm
/turf/unsimulated/floor/pool
	name = "water"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "poolwaterfloor"

	New()
		..()
		dir = pick(NORTH,SOUTH)

/turf/simulated/pool
	name = "water"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "poolwaterfloor"

	New()
		..()
		dir = pick(NORTH,SOUTH)

/turf/unsimulated/grasstodirt
	name = "grass"
	icon = 'icons/misc/worlds.dmi'
	icon_state = "grasstodirt"

/turf/unsimulated/grass
	name = "grass"
	icon = 'icons/misc/worlds.dmi'
	icon_state = "grass"

/turf/unsimulated/dirt
	name = "Dirt"
	icon = 'icons/misc/worlds.dmi'
	icon_state = "dirt"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/shovel))
			if (src.icon_state == "dirt-dug")
				boutput(user, "<span style=\"color:red\">That is already dug up! Are you trying to dig through to China or something?  That would be even harder than usual, seeing as you are in space.</span>")
				return

			user.visible_message("<b>[user]</b> begins to dig!", "You begin to dig!")
			//todo: A digging sound effect.
			if (do_after(user, 40) && src.icon_state != "dirt-dug")
				src.icon_state = "dirt-dug"
				user.visible_message("<b>[user]</b> finishes digging.", "You finish digging.")
				for (var/obj/tombstone/grave in orange(src, 1))
					if (istype(grave) && !grave.robbed)
						grave.robbed = 1
						//idea: grave robber medal.
						if (grave.special)
							new grave.special (src)
						else
							switch (rand(1,5))
								if (1)
									new /obj/item/skull {desc = "A skull.  That was robbed.  From a grave.";} ( src )
								if (2)
									new /obj/item/plank {name = "rotted coffin wood"; desc = "Just your normal, everyday rotten wood.  That was robbed.  From a grave.";} ( src )
								if (3)
									new /obj/item/clothing/under/suit/pinstripe {name = "old pinstripe suit"; desc  = "A pinstripe suit.  That was stolen.  Off of a buried corpse.";} ( src )
						break

		else
			return ..()
