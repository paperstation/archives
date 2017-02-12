/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/

#define SIMS_DETAILED_SCOREKEEPING

//
/area
	var/active = 0 //True if a dude is here (DOES NOT APPLY TO THE "SPACE" AREA)
	var/list/population = list() //Who is here (ditto)
	var/fire = null
	var/atmos = 1
	var/poweralm = 1
	var/party = null
	var/skip_sims = 0
	var/sims_score = 100
	var/virtual = 0
	level = null
	name = "Space"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = EFFECTS_LAYER_BASE
	mouse_opacity = 0
	mat_changename = 0
	mat_changedesc = 0
	var/lightswitch = 1
	var/may_eat_here_in_restricted_z = 0

	var/eject = null

	var/requires_power = 1
	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/irradiated = 0 // space blowouts use this, should always be 0
	var/permarads = 0 // Blowouts don't set irradiated on this area back to zero.
	var/do_not_irradiate = 1 // don't irradiate this place!!
	// Definitely DO NOT var-edit areas in the map editor because it apparently causes individual tiles
	// to become detached from the parent area. Example: APCs belonging to medbay or whatever that are in
	// adjacent maintenance tunnels, not in the same room they're powering. If you set the d_n_i flag,
	// it will render them useless.

	var/corrupted = 0 // wizard round objective thingy

	var/datum/gang/gang_owners = null // gang that owns this area in gang mode
	var/gang_base = 0 // is this a gang's base (uncaptureable)?
	var/being_captured = null // for gang mode

	var/no_air = null
	var/filler_turf				// if set, replacewithspace in this area instead replaces with this turf type

	var/teleport_blocked = 0 //Cannot teleport into this area without some explicit set_loc thing.

	var/workplace = 0 //Do people work here?

	var/list/obj/critter/registered_critters = list()
	var/waking_critters = 0

	var/music = null
	var/sound = 'sound/ambience/ambigen1.ogg'
	var/sound_group = null
	var/sound_environment = 1 //default environment for sounds - see sound datum vars documentation for the presets.

	Entered(var/atom/movable/A)
		if ((isliving(A) || iswraith(A)) || locate(/mob) in A)
			//world.log << "[src] entered by [A]"
			//Just...deal with this
			var/list/enteringMobs = new
			var/mob/M
			if (ismob(A))
				M = A
				enteringMobs += M
			else if (locate(/mob) in A)
				for (var/mob/insideM in A) //Only 1 layer deep. Will this cause issues? Hrm.
					M = insideM
					enteringMobs += M

			//If any mobs are entering, within a thing or otherwise
			if (enteringMobs.len > 0)
				for (var/mob/enteringM in enteringMobs) //each dumb mob
					//Wake up a bunch of lazy darn critters
					if (isliving(enteringM))
						wake_critters()

					//If it's a real fuckin player
					if (enteringM.ckey && enteringM.client && enteringM.mind)
						if (src.name != "Space") //Who cares about making space active gosh
							if (!(enteringM.mind in src.population))
								src.population += enteringM.mind
							if (!src.active)
								src.active = 1

						//Dumb fucking medal fuck
						if (src.name == "Space" && istype(A, /obj/vehicle/segway))
							enteringM.unlock_medal("Jimi Heselden", 1)

						//Handle ambient sound
						src.pickAmbience()
						if (prob(35))
							enteringM.playAmbience(src)

		..()

	Exited(var/atom/movable/A)
		if ((isliving(A) || iswraith(A)) || locate(/mob) in A)
			//world.log << "[src] exited by [A]"
			//Deal with this too
			var/list/exitingMobs = new
			var/mob/M
			if (ismob(A))
				M = A
				exitingMobs += M
			else if (locate(/mob) in A)
				for (var/mob/insideM in A)
					M = insideM
					exitingMobs += M

			if (exitingMobs.len > 0)
				for (var/mob/exitingM in exitingMobs)
					if (exitingM.ckey && exitingM.client && exitingM.mind)
						if (src.name != "Space")
							if (exitingM.mind in src.population)
								src.population -= exitingM.mind
							if (src.active && src.population.len == 0) //Only if this area is now empty
								src.active = 0

						//Put whatever you want here. See Entering above.

		..()

	proc/find_middle(var/mustbeinside = 1)
		var/minx = 300
		var/miny = 300
		var/maxx = 0
		var/maxy = 0
		var/minz = 100
		var/hasturfs = 0
		for (var/turf/T in src)
			if (minx > T.x)
				minx = T.x
			if (miny > T.y)
				miny = T.y
			if (maxx < T.x)
				maxx = T.x
			if (maxy < T.y)
				maxy = T.y
			if (minz > T.z)
				minz = T.z
			hasturfs = 1
		if (!hasturfs)
			return 0
		var/midx = round((minx + maxx) / 2)
		var/midy = round((miny + maxy) / 2)
		var/midz = minz
		var/turf/R = locate(midx, midy, midz)
		if (mustbeinside)
			if (!(R in src))
				return null
		return R

	proc/build_sims_score()
		if (name == "Space" || type == /area || skip_sims)
			return
		sims_score = 100
		for (var/turf/T in src)
			var/penalty = 0
			var/list/loose_items = list()
			for (var/obj/O in T)
				if (istype(O, /obj/item))
					penalty += 4
					loose_items += O
				if (istype(O, /obj/decal/cleanable))
					sims_score -= 6
			if ((locate(/obj/table) in T) || (locate(/obj/rack) in T))
				continue
			else
				sims_score -= penalty
		sims_score = max(sims_score, 0)

	proc/wake_critters()
		if(waking_critters || !registered_critters.len) return
		waking_critters = 1
		for(var/obj/critter/C in src.registered_critters)
			C.wake_from_hibernation()
		waking_critters = 0

	proc/calculate_area_value()
		var/value = 0
		for (var/turf/simulated/floor/F in src.contents)
			if (F.broken || F.burnt || F.icon_state == "plating")
				continue
			value++

		for (var/obj/machinery/M in src.contents)
			if (M.stat & BROKEN || M.stat & NOPOWER)
				continue
			value++

		return value

	proc/pickAmbience()
		switch(src.name)
			if ("Chapel") sound = pick('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')
			if ("Morgue") sound = pick('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')
			//if ("Engine Control") sound = pick(ambience_engine)
			//if ("Atmospherics") sound = pick(ambience_atmospherics)
			//if ("Computer Core") sound = pick(ambience_computer)
			//if ("Engineering Power Room") sound = pick(ambience_power)
			if ("Ice Moon") sound = pick('sound/ambience/coldwind1.ogg', 'sound/ambience/coldwind2.ogg', 'sound/ambience/coldwind3.ogg')
			if ("Biodome North") sound = pick('sound/ambience/biodome1.ogg', 'sound/ambience/biodome2.ogg', 'sound/ambience/biodome3.ogg', 'sound/ambience/biodome4.ogg')
			if ("Biodome South") sound = pick('sound/ambience/biodome1.ogg', 'sound/ambience/biodome2.ogg', 'sound/ambience/biodome3.ogg', 'sound/ambience/biodome4.ogg')
			if ("Caves") sound = pick('sound/ambience/cave1.ogg', 'sound/ambience/cave2.ogg', 'sound/ambience/cave3.ogg', 'sound/ambience/cave4.ogg', 'sound/ambience/cave5.ogg')
			if ("Glacial Abyss") sound = pick('sound/ambience/glacier1.ogg','sound/ambience/glacier2.ogg', 'sound/ambience/glacier3.ogg', 'sound/ambience/glacier4.ogg', 'sound/ambience/glacier5.ogg', 'sound/ambience/glacier6.ogg')
			else sound = pick(ambience_general)

/area/cavetiny
	name = "Caves"
	icon_state = "purple"
	skip_sims = 1
	sims_score = 50
	RL_Lighting = 1
	sound_environment = 8
	teleport_blocked = 1

/area/area_that_kills_you_if_you_enter_it //People entering VR or exiting VR with stupid exploits are jerks.
	name = "Invisible energy field that will kill you if you step into it"
	skip_sims = 1
	sims_score = 0
	icon_state = "death"
	requires_power = 0
	teleport_blocked = 1

	Entered(atom/movable/O)
		..()
		if (isliving(O))
			var/mob/living/jerk = O
			jerk.stat = 2
			src.do_gib(jerk)
		else if (isobj(O))
			for (var/mob/living/hiding_jerk in O)
				hiding_jerk.stat = 2
				src.do_gib(hiding_jerk)
		return

	proc/do_gib(var/mob/living/L)
		if (!istype(L))
			return
		L.gib()

/area/area_that_kills_you_if_you_enter_it/firegib
	do_gib(var/mob/living/L)
		if (!istype(L))
			return
		L.firegib()

/area/build_zone // currently for z4 just so people don't teleport in there randomly
	name = "Build Space"
	icon_state = "death"
	skip_sims = 1
	sims_score = 25
	requires_power = 0
	teleport_blocked = 1

/area/shuttle/escape/transit
	icon_state = "eshuttle_transit"
	sound_group = "eshuttle_transit"
	var/warp_dir = "north" // fuck you

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if (ismob(Obj))
			var/mob/M = Obj
			if (src.warp_dir == "north" || src.warp_dir == "south")
				M.addOverlayComposition(/datum/overlayComposition/shuttle_warp)
			else
				M.addOverlayComposition(/datum/overlayComposition/shuttle_warp/ew)

	Exited(atom/movable/Obj)
		..()
		if (ismob(Obj))
			var/mob/M = Obj
			M.removeOverlayComposition(/datum/overlayComposition/shuttle_warp)

/area/shuttle/escape/transit/ew
	warp_dir = EAST

/area/shuttle_transit_space
	name = "Wormhole"
	icon_state = "shuttle_transit_space_n"
	teleport_blocked = 1
	var/throw_dir = "north" // goddamnit

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if (ismob(Obj))
			var/mob/M = Obj
			if (src.throw_dir == "north" || src.throw_dir == "south")
				M.addOverlayComposition(/datum/overlayComposition/shuttle_warp)
			else
				M.addOverlayComposition(/datum/overlayComposition/shuttle_warp/ew)
		if (!isobserver(Obj) && !isintangible(Obj) && !iswraith(Obj))
			var/atom/target = get_edge_target_turf(src, src.throw_dir)
			spawn(0)
				if (target && Obj)
					Obj.throw_at(target, 1, 1)

	Exited(atom/movable/Obj)
		..()
		if (ismob(Obj))
			var/mob/M = Obj
			M.removeOverlayComposition(/datum/overlayComposition/shuttle_warp)

/area/shuttle_transit_space/south
	icon_state = "shuttle_transit_space_s"
	throw_dir = "south"
/area/shuttle_transit_space/east
	icon_state = "shuttle_transit_space_e"
	throw_dir = "east"
/area/shuttle_transit_space/west
	icon_state = "shuttle_transit_space_w"
	throw_dir = "west"

/area/shuttle_particle_spawn
	icon_state = "shuttle_transit_stars_n"
	teleport_blocked = 1
	var/star_dir = null // particle system defaults to northbound stars

/area/shuttle_particle_spawn/south
	icon_state = "shuttle_transit_stars_s"
	star_dir = "_s"

/area/shuttle_particle_spawn/east
	icon_state = "shuttle_transit_stars_e"
	star_dir = "_e"

/area/shuttle_particle_spawn/west
	icon_state = "shuttle_transit_stars_w"
	star_dir = "_w"

/area/shuttle_sound_spawn
	icon_state = "shuttle_transit_sound"
	teleport_blocked = 1

/*/area/factory
	name = "Derelict Robot Factory"
	icon_state = "start"

/area/factory/core
	name = "Aged Computer Core"
	icon_state = "ai"

/area/old_outpost
	name = "Derelict Outpost"
	icon_state = "yellow"
	sound_environment = 12

/area/old_outpost/engine
	name = "Outpost Engine"
	icon_state = "dk_yellow"
	sound_environment = 10

/area/old_outpost/control
	name = "Outpost Control"
	icon_state = "purple"

/area/old_outpost/medical
	name = "VR Research"
	icon_state = "medresearch"
	sound_environment = 3

/area/old_outpost/study
	name = "Outpost Study"
	icon_state = "green"
	sound_environment = 4

/area/old_outpost/teleporter
	name = "Outpost Teleporter"
	icon_state = "teleporter"
	sound_environment = 2*/

/////////////////// cogwerks- arctic derelict

/area/upper_arctic
	filler_turf = "/turf/unsimulated/floor/arctic/snow"
	sound_environment = 8
	skip_sims = 1
	sims_score = 30
	sound_group = "ice_moon"

/area/upper_arctic/pod1
	name = "Outpost Theta Pod One"
	icon_state = "green"
	sound_environment = 3
	skip_sims = 1
	sims_score = 30

/area/lower_arctic/pod1
	name = "Outpost Theta Pod One"
	icon_state = "green"
	sound_environment = 3
	skip_sims = 1
	sims_score = 30

/area/upper_arctic/pod2
	name = "Outpost Theta Pod Two"
	icon_state = "purple"
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/upper_arctic/hall
	name = "Outpost Theta Connecting Hall"
	icon_state = "yellow"
	sound_environment = 12
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/upper_arctic/comms
	name = "Communications Hut"
	icon_state = "storage"
	sound_environment = 2
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/upper_arctic/mining
	name = "Glacier Access"
	icon_state = "dk_yellow"
	sound_environment = 2
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/lower_arctic/mining
	name = "Glacier Access"
	icon_state = "dk_yellow"
	sound_environment = 2
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/upper_arctic/exterior
	sound_environment = 15
	skip_sims = 1
	sims_score = 30
	New()
		..()
		overlays += image(icon = 'icons/turf/areas.dmi', icon_state = "snowverlay", layer = EFFECTS_LAYER_BASE)

/area/upper_arctic/exterior/surface
	name = "Ice Moon Surface"
	icon_state = "white"
	filler_turf = "/turf/unsimulated/floor/arctic/abyss"
	skip_sims = 1
	sims_score = 30

/area/upper_arctic/exterior/abyss
	name = "Ice Moon Abyss"
	icon_state = "dk_yellow"
	filler_turf = "/turf/unsimulated/floor/arctic/snow"
	skip_sims = 1
	sims_score = 30

/area/lower_arctic
	icon_state = "dk_yellow"
	sound_group = "ice_moon"

/area/lower_arctic/lower
	name = "Glacial Abyss"
	icon_state = "purple"
	filler_turf = "/turf/unsimulated/floor/arctic/snow/ice"
	sound_environment = 8
	skip_sims = 1
	sims_score = 30

/area/precursor // stole this code from the void definition
	name = "Peculiar Structure"
	icon_state = "dk_yellow"
	filler_turf = "/turf/unsimulated/floor/setpieces/bluefloor"
	var/sound/mysound = null
	sound_environment = 5
	skip_sims = 1
	sims_score = 30

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/precursorambi.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE
		spawn(10) process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		var/sound/S = null
		var/sound_delay = 0
		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)
			if (ticker.current_state == GAME_STATE_PLAYING)
				if(prob(10))
					S = sound(file=pick('sound/ambience/precursorfx1.ogg','sound/ambience/precursorfx2.ogg','sound/ambience/precursorfx3.ogg','sound/ambience/precursorfx4.ogg'), volume=50)
					sound_delay = rand(0, 50)
				else
					S = null
					continue

				for(var/mob/living/carbon/human/H in src)
					if(H.client)
						mysound.status = SOUND_UPDATE
						H << mysound
						if(S)
							spawn(sound_delay)
								H << S

	pit
		name = "Ominous Pit"
		icon_state = "purple"
		filler_turf = "/turf/unsimulated/floor/setpieces/bluefloor/pit" // this might fuck something up but it might also be hilarious
		sound_environment = 24
		sound_group = "ominouspit"
		skip_sims = 1
		sims_score = 300

///////////////////// keelin / cogwerks - caves and biodome areas

/area/crater
	name = "Crater"
	icon_state = "yellow"
	RL_Lighting = 1
	sound_environment = 18
	skip_sims = 1
	sims_score = 30
	sound_group = "biodome"

/area/crater/biodome
	name = "Botanical Research Biodome"
	icon_state = "green"
	RL_Lighting = 1
	sound_environment = 1
	skip_sims = 1
	sims_score = 30

	north
		name = "Biodome North"
		sound_environment = 7

	south
		name = "Biodome South"
		sound_environment = 7

	entry
		name = "Biodome Entrance"
		icon_state = "shuttle"
		sound_environment = 3

	research
		name = "Biodome Research Core"
		icon_state = "toxlab"
		sound_environment = 2

	crew
		name = "Biodome Staff Wing"
		icon_state = "crewquarters"
		sound_environment = 2

	maint
		name = "Biodome Maintenance Wing"
		icon_state = "yellow"
		sound_environment = 3

/area/crater/cave
	name = "Caves"
	icon_state = "purple"
	RL_Lighting = 1
	sound_environment = 8
	skip_sims = 1
	sims_score = 30

/area/crater/cave/lower
	name = "Lower Caves"
	icon_state = "purple"
	RL_Lighting = 1
	skip_sims = 1
	sims_score = 30

////////////////////// cogwerks - solar lounge

/area/solarium
	name = "Solarium"
	icon_state = "yellow"
	RL_Lighting = 1
	sound_environment = 5
	may_eat_here_in_restricted_z = 1
	skip_sims = 1
	sims_score = 100
	sound_group = "solarium"

////////////////////// cogwerks - HELL

/area/hell
	name = "????"
	icon_state = "security"
	filler_turf = "/turf/unsimulated/floor/setpieces/bloodfloor"
	sound_environment = 25
	skip_sims = 1
	sims_score = 0

////////////////////// cogwerks - crypt place

/area/crypt
	sound_group = "crypt"

/area/crypt/graveyard
	name = "Graveyard"
	icon_state = "green"
	RL_Lighting = 1
	filler_turf = "/turf/unsimulated/dirt"
	var/sound/mysound = null
	sound_environment = 15
	skip_sims = 1
	sims_score = 0

	New()
		..()

		overlays += image(icon = 'icons/turf/areas.dmi', icon_state = "rain_overlay", layer = EFFECTS_LAYER_BASE)


		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/rain.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE
		spawn(10) process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		var/sound/S = null
		var/sound_delay = 0
		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)
			if (ticker.current_state == GAME_STATE_PLAYING)
				if(prob(10))
					S = sound(file=pick('sound/ambience/rain_fx1.ogg','sound/ambience/coldwind1.ogg','sound/ambience/coldwind2.ogg','sound/ambience/coldwind3.ogg','sound/ambience/lavamoon_exterior_fx2.ogg', 'sound/voice/Zgroan1.ogg', 'sound/voice/Zgroan2.ogg', 'sound/voice/Zgroan3.ogg', 'sound/voice/Zgroan4.ogg', 'sound/misc/werewolf_howl.ogg'), volume=50)
					sound_delay = rand(0, 50)
				else
					S = null
					continue

				for(var/mob/living/carbon/human/H in src)
					if(H.client)
						mysound.status = SOUND_UPDATE
						H << mysound
						if(S)
							spawn(sound_delay)
								H << S

/area/crypt/graveyard/swamp
	name = "Spooky Swamp"
	icon_state = "red"
	skip_sims = 1
	sims_score = 30

/area/crypt/mausoleum
	name = "Mausoleum"
	icon_state = "purple"
	RL_Lighting = 1
	sound_environment = 5
	skip_sims = 1
	sims_score = 0

/area/catacombs
	name = "Catacombs"
	icon_state = "purple"
	RL_Lighting = 1
	sound_environment = 13
	skip_sims = 1
	sims_score = 0
	sound_group = "catacombs"

/area/adventure
	name = "Adventure Zone"
	icon_state = "purple"
	RL_Lighting = 1
	sound_environment = 31
	skip_sims = 1
	sims_score = 30
	virtual = 1

//Spacejunk
/area/h7
	name = "Hemera VII"
	icon_state = "yellow"
	sound_environment = 12
	teleport_blocked = 1
	skip_sims = 1
	sims_score = 30

/area/h7/computer_core
	name = "Aged Computer Core"
	icon_state = "ai"
	sound_environment = 3
	skip_sims = 1
	sims_score = 30

/area/h7/control
	name = "Control Room"
	icon_state = "purple"
	sound_environment = 3
	skip_sims = 1
	sims_score = 30

/area/h7/lab
	name = "Anomalous Materials Laboratory"
	icon_state = "toxlab"
	sound_environment = 10
	skip_sims = 1
	sims_score = 30

/area/h7/crew
	name = "Living Quarters"
	icon_state = "crewquarters"
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/h7/storage
	name = "Equipment Storage"
	icon_state = "storage"
	sound_environment = 2
	skip_sims = 1
	sims_score = 30

/area/h7/asteroid
	name = "Shattered Asteroid"
	icon_state = "green"
	skip_sims = 1
	sims_score = 30

/area/space_hive
	name = "Space Bee Hive"
	icon_state = "yellow"
	RL_Lighting = 1
	sound_environment = 20
	teleport_blocked = 1
	skip_sims = 1
	sims_score = 100

/area/helldrone
	name = "Drone Corpse"
	icon_state = "red"
	sound_environment = 3
	teleport_blocked = 1
	skip_sims = 1
	sims_score = 50

/area/helldrone/core
	name = "Drone Computer Core"
	icon_state = "ai"
	skip_sims = 1
	sims_score = 30

/area/station
	do_not_irradiate = 0

/area/station/engine
	sound_environment = 10
	workplace = 1
//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.

/area/shuttle //DO NOT TURN THE RL_Lighting STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
#ifdef HALLOWEEN
	alpha = 128
	icon = 'icons/effects/dark.dmi'
#else
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0
#endif
	sound_environment = 2

/area/shuttle/arrival
	name = "Arrival Shuttle"


/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/escape
	name = "Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	icon_state = "shuttle"
	sound_group = "centcom"

/area/shuttle/prison/
	name = "Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

/area/shuttle/brig/station
	icon_state = "shuttle"

/area/shuttle/brig/prison
	icon_state = "shuttle2"

/area/shuttle/brig/outpost
	icon_state = "shuttle3"

/area/shuttle/research/station
	icon_state = "shuttle"

/area/shuttle/research/outpost
	icon_state = "shuttle2"

/area/shuttle/attack2/prison
	icon_state = "shuttle2"

/area/shuttle/mining/station
	icon_state = "shuttle"

/area/shuttle/mining/space
	icon_state = "shuttle2"

/area/shuttle/icebase_elevator/upper
	icon_state = "shuttle"
	filler_turf = "/turf/simulated/floor/arctic/abyss"
	RL_Lighting = 1
	sound_group = "ice_moon"

/area/shuttle/icebase_elevator/lower
	icon_state = "shuttle2"
	filler_turf = "/turf/simulated/floor/arctic/snow/ice"
	RL_Lighting = 1
	sound_group = "ice_moon"

/area/shuttle/biodome_elevator/upper
	icon_state = "shuttle"
	RL_Lighting = 1
	name = "Elevator"

/area/shuttle/biodome_elevator/lower
	icon_state = "shuttle2"
	RL_Lighting = 1
	name = "Elevator"

/area/recovery_shuttle
	icon_state = "shuttle2"
	name = "Recovery Shuttle"

/area/shuttle/merchant_shuttle
	icon_state = "shuttle2"
	name = "Merchant Shuttle"
	teleport_blocked = 1

/area/shuttle/merchant_shuttle/left_centcom

/area/shuttle/merchant_shuttle/right_centcom

/area/shuttle/merchant_shuttle/left_station
	icon_state = "shuttle2"

/area/shuttle/merchant_shuttle/right_station
	icon_state = "shuttle2"

/*
/area/prison/arrival_airlock
	name = "Asylum Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "Warden's Office"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Asylum Staff Quarters"
	icon_state = "security"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "Asylum Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Asylum Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/office
	name = "Asylum Offices"
	icon_state = "purple"

/area/prison/office/checkpoint
	name = "Nurse's Station"

/area/prison/medical
	name = "Asylum Operating Theatre"
	icon_state = "medbay"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"*/

/area/prison/cell_block/wards
	name = "Asylum Wards"
	icon_state = "brig"
	requires_power = 0

/*/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"
*/

/area/sim
	name = "Sim"
	icon_state = "purple"
	luminosity = 1
	RL_Lighting = 0
	requires_power = 0
	virtual = 1
	skip_sims = 1
	sims_score = 100
	sound_group = "vr"

/area/sim/gunsim
	name = "Gun Sim"
	icon_state = "gunsim"
	virtual = 1

/area/sim/area1
	name = "Vspace area 1"
	icon_state = "simA1"
	virtual = 1

/area/sim/a1entry
	name = "Vspace area 1 Entry"
	icon_state = "simA1E"
	virtual = 1

/area/sim/area2
	name = "Vspace area 2"
	icon_state = "simA2"
	virtual = 1

/area/sim/a2entry
	name = "Vspace area 2 Entry"
	icon_state = "simA2E"
	virtual = 1

//

/area/station/wreckage
	name = "Twisted Wreckage"
	icon_state = "donutbridge"
	sound_environment = 14
	do_not_irradiate = 1

/area/crunch
	name = "somewhere"
	icon_state = "purple"
	filler_turf = "/turf/simulated/floor/void"
	sound_environment = 21
	skip_sims = 1
	sims_score = 15
	sound_group = "void"

/area/someplace
	name = "some place"
	icon_state = "purple"
	filler_turf = "/turf/simulated/floor/void"
	var/sound/mysound = null
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0
	skip_sims = 1
	sims_score = 15

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/ambisomeplace.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 122
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

/area/someplacehot
	name = "some place"
	icon_state = "atmos"
	filler_turf = "/turf/simulated/floor/void"
	var/sound/mysound = null
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0
	skip_sims = 1
	sims_score = 15

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/ambifire.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 121
		S.volume = 75
		S.priority = 255
		S.status = SOUND_UPDATE

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			Obj:addOverlayComposition(/datum/overlayComposition/heat)

		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			Obj:removeOverlayComposition(/datum/overlayComposition/heat)

		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound
		return

/area/martian_trader
	name ="Martian Trade Outpost"
	sound_environment = 8

/area/abandonedmedicalship
	name = "Abandoned Medical ship"
	icon_state = "yellow"

/area/abandonedoutpostthing
	name = "Abandoned Outpost"
	icon_state = "yellow"

/area/abandonedmedicalship/robot_trader
	name ="Robot Trade Outpost"
	icon_state ="green"
	sound_environment = 3

/area/bee_trader
	name ="Bombini's Ship"
	icon_state ="green"
	sound_environment = 2

/area/sim/bball
	name = "B-Ball Court"
	icon_state="vr"
	virtual = 1

/area/fermid_hive
	name = "Fermid Hive"
	icon_state = "purple"

/area/centcom
	name = "Centcom"
	icon_state = "purple"
	requires_power = 0
	sound_environment = 4
	teleport_blocked = 1
	sound_group = "centcom"

/area/wtc
	name = "Mysterious Facility"
	icon_state = "purple"
	requires_power = 0
	sound_environment = 4
	teleport_blocked = 1

/area/station/atmos
	name = "Atmospherics"
	icon_state = "atmos"
	sound_environment = 10
	workplace = 1
	do_not_irradiate = 1

/area/station/atmos/hookups_starboard
	name = "Starboard Air Hookups"
	icon_state = "atmos"
	sound_environment = 3

/area/station/atmos/hookups_port
	name = "Port Air Hookups"
	icon_state = "atmos"
	sound_environment = 3

/area/station/maintenance/
	name = "Maintenance"
	icon_state = "maintcentral"
	sound_environment = 12
	workplace = 1
	do_not_irradiate = 1

/area/station/maintenance/fpmaint
	name = "Fore Port Maintenance"
	icon_state = "fpmaint"

/area/station/maintenance/fsmaint
	name = "Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/station/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/station/maintenance/apmaint
	name = "Aft Port Maintenance"
	icon_state = "apmaint"

/area/station/maintenance/maintcentral
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/station/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/station/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/station/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/station/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/station/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/station/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/station/maintenance/aftsolar
	name = "Aft Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/station/maintenance/inner
	name = "Inner Maintenance"
	icon_state = "imaint"

/area/station/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/station/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/station/hallway/
	name = "Hallway"
	icon_state = "hallC"
	sound_environment = 10

/area/station/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/station/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/station/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/station/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/station/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/station/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/station/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"
	workplace = 1
	do_not_irradiate = 1

/area/station/hallway/secondary/construction2
	name = "Secondary Construction Area"
	icon_state = "construction"
	workplace = 1
	do_not_irradiate = 1

/area/station/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

/area/station/hallway/secondary/shuttle
	name = "Shuttle Bay"
	icon_state = "shuttle3"

/area/station/mailroom
	name = "Mailroom"
	icon_state = "mail"
	sound_environment = 2
	workplace = 1

/area/station/artifact
	name = "Artifact Lab"
	icon_state = "artifact"
	sound_environment = 2
	workplace = 1

/area/station/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"
	sound_environment = 4

/area/station/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"
	sound_environment = 3

/area/station/crew_quarters/stockex
	name = "Stock Exchange"
	icon_state = "yellow"
	sound_environment = 0

/area/station/crew_quarters/arcade
	name = "Arcade"
	icon_state = "yellow"
	sound_environment = 1

/area/station/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"
	sound_environment = 2

/area/station/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "captain"
	sound_environment = 4

/area/station/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"
	sound_environment = 0

/area/station/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"
	sound_environment = 3

/area/station/com_dish/comdish
	name = "Communications Dish"
	icon_state = "yellow"
	RL_Lighting = 0 // ????

/area/station/com_dish/auxdish
	name = "Auxilary Communications Dish"
	icon_state = "yellow"
	RL_Lighting = 0

/area/station/crew_quarters/bar
	name= "Bar"
	icon_state = "bar"
	sound_environment = 0

/area/station/crew_quarters/heads
	name = "Head of Personnel's Office"
	icon_state = "HOP"
	sound_environment = 4

/area/station/crew_quarters/hor
	name = "Research Director's Office"
	icon_state = "RD"
	sound_environment = 4

/area/station/crew_quarters/quarters
	name = "Crew Lounge"
	icon_state = "purple"
	sound_environment = 2

/area/station/crew_quarters/quartersA
	name = "Crew Quarters A"
	icon_state = "crewquarters"
	sound_environment = 3

/area/station/crew_quarters/quartersB
	name = "Crew Quarters B"
	icon_state = "crewquarters"
	sound_environment = 3

/area/station/crew_quarters/toilets
	name = "Toilets"
	icon_state = "toilets"
	sound_environment = 3

/area/station/crew_quarters/showers
	name = "Shower Room"
	icon_state = "showers"
	sound_environment = 3

/area/station/crew_quarters/pool
	name = "Pool Room"
	icon_state = "showers"
	sound_environment = 0

/area/station/crew_quarters/observatory
	name = "Observatory"
	icon_state = "observatory"
	sound_environment = 2

/area/station/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"
	sound_environment = 0

/area/station/crew_quarters/juryroom
	name = "Jury Room"
	icon_state = "juryroom"
	sound_environment = 0

/area/station/crew_quarters/barber_shop
	name = "Barber Shop"
	icon_state= "yellow"
	sound_environment = 2

/area/station/crew_quarters/market
	name = "Public Market"
	icon_state = "yellow"
	sound_environment = 0

/area/station/crew_quarters/garden
	name = "Public Garden"
	icon_state = "park"

/area/station/engine/engineering
	name = "Engineering"
	icon_state = "engineering"
	sound_environment = 12

/area/station/engine/ptl
	name = "Power Transmission Laser"
	icon_state = "ptl"
	sound_environment = 12

/area/mining/miningoutpost
	name = "Mining Outpost"
	icon_state = "engine"

/area/station/engine/storage
	name = "Engineering Storage"
	icon_state = "engine_hallway"

/area/station/engine/shield_gen
	name = "Engineering Shield Generator"
	icon_state = "engine_monitoring"

/area/station/engine/shields
	name = "Engineering Shields"
	icon_state = "engine_monitoring"

/area/station/engine/elect
	name = "Mechanic's Lab"
	icon_state = "mechanics"

/area/station/engine/power
	name = "Engineering Power Room"
	icon_state = "showers"
	sound_environment = 5

/area/station/engine/eva
	name = "Engineering EVA"
	icon_state = "showers"

/area/station/engine/core
	name = "Thermo-Electric Generator"
	icon_state = "teg" // sometimes you just gotta make an icon the way it is because that's what your heart tells you to do, even if it looks like something a cartoon for toddlers would reject for looking too stupid
	sound_environment = 10

/area/station/engine/hotloop
	name = "Hot Loop"
	icon_state = "red"

/area/station/engine/coldloop
	name = "Cold Loop"
	icon_state = "purple"

/area/station/engine/gas
	name = "Engineering Gas Storage"
	icon_state = "storage"
	sound_environment = 3

/area/station/engine/inner
	name = "Inner Engineering"
	icon_state = "yellow"

/area/station/engine/substation
	icon_state = "purple"
	sound_environment = 3

/area/station/engine/substation/pylon
	name = "Electrical Substation"
	do_not_irradiate = 1

/area/station/engine/substation/port
	name = "Port Electrical Substation"
	do_not_irradiate = 1

/area/station/engine/substation/starboard
	name = "Starboard Electrical Substation"
	do_not_irradiate = 1

/area/station/engine/substation/fore
	name = "Fore Electrical Substation"
	do_not_irradiate = 1

/area/station/engine/proto
	name = "Prototype Engine"
	icon_state = "prototype_engine"

/area/station/engine/thermo
	name = "Thermoelectric generator"
	icon_state = "prototype_engine"

/area/station/engine/proto_gangway
	name = "Prototype Gangway"
	icon_state = "green"
	luminosity = 1
	RL_Lighting = 0
	requires_power = 0

/area/mining
	name = "Mining Outpost"
	icon_state = "engine"
	workplace = 1

/area/mining/power
	name = "Outpost Power Room"
	icon_state = "showers"
	sound_environment = 3

/area/mining/manufacturing
	name = "Outpost Manufacturing Room"
	icon_state = "storage"
	sound_environment = 12

/area/mining/quarters
	name = "Outpost Miner's Quarters"
	icon_state = "locker"
	sound_environment = 2

/area/mining/comms
	name = "Outpost Comms Room"
	icon_state = "yellow"
	sound_environment = 2

/area/mining/dock
	name = "Outpost Shuttle Dock"
	icon_state = "storage"
	sound_environment = 10

/area/mining/exit_west
	name = "Outpost West Airlock"
	icon_state = "maintcentral"
	sound_environment = 12

/area/mining/exit_east
	name = "Outpost East Airlock"
	icon_state = "maintcentral"
	sound_environment = 12

/area/mining/exit_south
	name = "Outpost South Airlock"
	icon_state = "maintcentral"
	sound_environment = 12

/area/mining/magnet_control
	name = "Mining Outpost Magnet Control"
	icon_state = "miningp"

/area/mining/refinery
	name = "Mining Outpost Refinery"
	icon_state = "yellow"

/area/station/hangar
	name = "Hangar"
	icon_state = "purple"
	sound_environment = 10

/area/station/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"
	sound_environment = 3
	workplace = 1

/area/syndicate_teleporter
	name = "Syndicate Teleporter"
	icon_state = "teleporter"
	music = "signal"
	requires_power = 0
	teleport_blocked = 1
	do_not_irradiate = 1

/area/sim/tdome
	name = "Thunderdome"
	icon_state = "medbay"
	requires_power = 0
	sound_environment = 9
	virtual = 1

/area/sim/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"
	sound_environment = 9

/area/sim/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"
	sound_environment = 9

/area/sim/tdome/tdomea
	name = "Thunderdome (Admin.)"
	icon_state = "purple"
	sound_environment = 9

/area/sim/tdome/tdomes
	name = "Thunderdome (Spectator)"
	icon_state = "purple"
	sound_environment = 9

/area/station/medical
	name = "Medical area"
	icon_state = "medbay"
	workplace = 1

/area/station/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'sound/machines/signal.ogg'
	sound_environment = 3

/area/station/medical/medbay/lobby
	name = "Medbay Lobby"
	icon_state = "medbay_lobby"

/area/station/medical/medbay/surgery
	name = "Medbay Operating Theater"
	icon_state = "medbay_surgery"

/area/station/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/station/medical/research
	name = "Medical Research"
	icon_state = "medresearch"
	sound_environment = 3

/area/station/medical/head
	name = "Medical Director's Office"
	icon_state = "MD"
	sound_environment = 1

/area/station/medical/cdc
	name = "Pathology Research"
	icon_state = "medcdc"
	sound_environment = 5

/area/station/medical/dome
	name = "Monkey Dome"
	icon_state = "green"
	sound_environment = 3

/area/station/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	sound_environment = 3

/area/station/medical/crematorium
	name = "Crematorium"
	icon_state = "morgue"
	sound_environment = 3

/area/station/medical/medbooth
	name = "Medical Booth"
	icon_state = "medbooth"
	sound_environment = 3

/area/station/security
	teleport_blocked = 1
	workplace = 1

/area/station/security/main
	name = "Security"
	icon_state = "security"
	sound_environment = 2

/area/station/security/brig
	name = "Brig"
	icon_state = "brigcell"
	sound_environment = 3

/area/station/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"
	sound_environment = 2

	arrivals
		name = "Arrivals Checkpoint"
	escape
		name = "Escape Hallway Checkpoint"
	customs
		name = "Customs Checkpoint"
	sec_foyer
		name = "Security Foyer Checkpoint"
	podbay
		name = "Pod Bay Checkpoint"
	chapel
		name = "Chapel Checkpoint"
	cargo
		name = "Cargo Checkpoint"
	port
		name = "Port Hallway Checkpoint"
	starboard
		name = "Starboard Hallway Checkpoint"

/area/station/security/armory
	name = "Armory"
	icon_state = "armory"
	sound_environment = 2

/area/station/security/prison
	name = "Prison Station"
	icon_state = "brig"
	sound_environment = 2

/area/station/security/secwing
	name = "Security Wing"
	icon_state = "brig"
	sound_environment = 2

/area/station/security/detectives_office
	name = "Detective's Office"
	icon_state = "detective"
	sound_environment = 4
	workplace = 0 //He lives here

/area/station/security/hos
	name = "Head of Security's Office"
	icon_state = "HOS"
	sound_environment = 4
	workplace = 0 //As does the hos

/area/station/solar
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0
	workplace = 1
	do_not_irradiate = 1

/area/station/solar/fore
	name = "Fore Solar Array"
	icon_state = "yellow"

/area/station/solar/aft
	name = "Aft Solar Array"
	icon_state = "panelsA"

/area/station/solar/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"

/area/station/solar/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/station/solar/small_backup1
	name = "Emergency Solar Array 1"
	icon_state = "yellow"

/area/station/solar/small_backup2
	name = "Emergency Solar Array 2"
	icon_state = "yellow"

/area/station/solar/small_backup3
	name = "Emergency Solar Array 3"
	icon_state = "yellow"

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0
	sound_environment = 2
	teleport_blocked = 1
	sound_group = "syndicate_station"

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	sound_environment = 4
	teleport_blocked = 1

/area/station/quartermaster/office
	name = "Quartermaster's Office"
	icon_state = "quartoffice"
	sound_environment = 10

/area/station/quartermaster/storage
	name = "Quartermaster's Storage"
	icon_state = "quartstorage"
	sound_environment = 2
	do_not_irradiate = 1

/area/station/quartermaster
	name = "Quartermasters"
	icon_state = "quart"
	workplace = 1

/area/station/janitor
	name = "Janitor's Office"
	icon_state = "janitor"
	sound_environment = 3
	workplace = 1

/area/station/janitor/supply
	name = "Janitor's Supply Closet"
	icon_state = "janitor"
	sound_environment = 3
	workplace = 1

/area/station/chemistry
	name = "Chemistry"
	icon_state = "chem"
	sound_environment = 3
	workplace = 1

/area/station/testchamber
	name = "Test Chamber"
	icon_state = "yellow"
	sound_environment = 5
	workplace = 1
	do_not_irradiate = 1

/area/station/science
	//name = "Research Outpost Zeta"
	name = "Research Sector"
	icon_state = "purple"
	sound_environment = 3
	workplace = 1

/area/station/science/gen_storage
	name = "Research Storage"
	icon_state = "genstorage"
	do_not_irradiate = 1

/area/station/science/bot_storage
	name = "Robot Depot"
	icon_state = "toxstorage"

/area/station/science/teleporter
	name = "Science Teleporter"
	icon_state = "telelab"

/area/station/science/research_director
	name = "Research Director's Office"
	icon_state = "toxlab"
	workplace = 0

/area/station/science/lab
	name = "Toxin Lab"
	icon_state = "toxlab"

/area/station/science/storage
	name = "Toxin Storage"
	icon_state = "toxstorage"
	do_not_irradiate = 1

/area/station/science/laser
	name = "Optics Lab"
	icon_state = "yellow"

/area/station/science/spectral
	name = "Spectral Studies Lab"
	icon_state = "purple"

/area/station/science/construction
	name = "Research Sector Construction Area"
	icon_state = "yellow"
	do_not_irradiate = 1


/area/station/test_area
	name = "Toxin Test Area"
	icon_state = "toxtest"
	virtual = 1
	sound_group = "toxtest"
	RL_Lighting = 0

/area/station/chapel/main
	name = "Chapel"
	icon_state = "chapel"
	sound_environment = 7

/area/station/chapel/main/main

/area/station/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"
	sound_environment = 11

/area/station/storage
	name = "Storage Area"
	icon_state = "storage"
	workplace = 1

/area/station/storage/tools
	name = "Tool Storage"
	icon_state = "storage"
	sound_environment = 3

/area/station/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"
	sound_environment = 3

/area/station/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/station/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/station/storage/eva
	name = "EVA Storage"
	icon_state = "eva"
	sound_environment = 3

/area/station/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/station/storage/emergencyinternals
	name = "Emergency Internals"
	icon_state = "yellow"

/area/station/storage/emergency
	name = "Emergency Storage A"
	icon_state = "emergencystorage"

/area/station/storage/emergency2
	name = "Emergency Storage B"
	icon_state = "emergencystorage"

/area/station/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"
	do_not_irradiate = 1

/area/station/storage/warehouse
	name = "Central Warehouse"
	icon_state = "red"
	sound_environment = 18

/area/station/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"
	teleport_blocked = 1

/area/iss
	name = "Derelict Space Station"
	icon_state = "derelict"

/area/abandonedship
	name = "Abandoned ship"
	icon_state = "yellow"

/area/salyut
	name = "Soviet derelict"
	icon_state = "yellow"

/*
/area/derelict
	name = "Derelict Station"
	icon_state = "derelict"
	sound_environment = 21

/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Control Room"
	icon_state = "bridge"

/area/derelict/bridge/access
	name = "Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Ruined Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/smuggler

/area/derelict/smuggler/power
	name = "Power center"
	icon_state = "engine"

/area/derelict/smuggler/cargo
	name = "Cargo sorting"
	icon_state = "storage"

/area/derelict/smuggler/control
	name = "Control room"
	icon_state = "bridge"*/


// cogmap new areas ///////////

/area/station/crew_quarters/clown
	name = "Non-Area"
	icon_state = "storage"
	do_not_irradiate = 1

/area/station/crew_quarters/catering
	name = "Catering Storage"
	icon_state = "storage"
	do_not_irradiate = 1

/area/station/crew_quarters/bathroom
	name = "Bathroom"
	icon_state = "showers"

/area/station/security/beepsky
	name = "Beepsky's House"
	icon_state = "storage"
	do_not_irradiate = 1

/area/station/crew_quarters/jazz
	name = "Jazz Lounge"
	icon_state = "purple"

/area/station/crew_quarters/info
	name = "Information Office"
	icon_state = "purple"

/area/station/hangar/main
	name = "Pod Bay"
	icon_state = "storage"
	sound_environment = 10

/area/station/hangar/sec
	name = "Secure Dock"
	icon_state = "storage"

/area/station/hangar/catering
	name = "Catering Dock"
	icon_state = "storage"

/area/station/hangar/engine
	name = "Engineering Dock"
	icon_state = "storage"

/area/station/hangar/qm
	name = "Cargo Dock"
	icon_state = "storage"

/area/station/hangar
	name = "Hangar"
	icon_state = "storage"
	workplace = 1
	do_not_irradiate = 1

/area/station/hangar/arrivals
	name = "Arrivals Dock"
	icon_state = "storage"

/area/station/hangar/escape
	name = "Escape Dock"
	icon_state = "storage"

/area/mining/hangar/
	name = "Mining Dock"
	icon_state = "storage"
	sound_environment = 10
	workplace = 1

/area/station/hangar/science
	name = "Research Dock"
	icon_state = "storage"
	teleport_blocked = 1

/area/listeningpost
	name = "Listening Post"
	icon_state = "brig"
	teleport_blocked = 1
	do_not_irradiate = 1

/area/listeningpost/power
	name = "Listening Post Control Room"
	icon_state = "engineering"

/area/listeningpost/solars
	name = "Listening Post Solar Array"
	icon_state = "yellow"
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0

/area/tech_outpost
	name = "Tech Outpost"
	icon_state = "storage"

/area/drone
	name = "Drone Assembly Outpost"
	icon_state = "red"
	sound_environment = 10
	sound_group = "drone_factory"

/area/drone/zone

/area/drone/crew_quarters
	name = "Crew Quarters"
	icon_state = "showers"
	sound_environment = 4

/area/drone/engineering
	name = "Engineering"
	icon_state = "yellow"
	sound_environment = 5

/area/drone/office
	name = "Design Office"
	icon_state = "purple"

/area/drone/assembly
	name = "Assembly Floor"
	icon_state = "storage"

/area/diner
	sound_environment = 12

/area/diner/hangar
	name = "Diner Parking"
	icon_state = "storage"

/area/diner/kitchen
	name = "Diner Kitchen"
	icon_state = "purple"

/area/diner/dining
	name = "Diner Seating Area"
	icon_state = "yellow"

/area/diner/bathroom
	name = "Diner Bathroom"
	icon_state = "showers"

///////////////////////////////

/area/station/ai_monitored
	name = "AI Monitored Area"
	var/obj/machinery/camera/motion/motioncamera = null
	workplace = 1

/area/station/ai_monitored/New()
	..()
	// locate and store the motioncamera
	spawn (20) // spawn on a delay to let turfs/objs load
		for (var/obj/machinery/camera/motion/M in src)
			motioncamera = M
			return
	return

/area/station/ai_monitored/Entered(atom/movable/O)
	..()
	if (istype(O, /mob) && motioncamera)
		motioncamera.newTarget(O)
//
/area/station/ai_monitored/Exited(atom/movable/O)
	..()
	if (istype(O, /mob) && motioncamera)
		motioncamera.lostTarget(O)

/area/station/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"
	sound_environment = 12

/area/station/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"
	sound_environment = 12

/area/station/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"
	sound_environment = 12

/area/station/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"
	sound_environment = 12

/area/station/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"
	sound_environment = 12

/area/station/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"
	sound_environment = 12

/area/station/turret_protected/AIbasecore1
	name = "AI Core 1"
	icon_state = "AIt"
	sound_environment = 12

/area/station/turret_protected/AIbaseoutside
	name = "AI outside"
	icon_state = "AIt"
	requires_power = 0
	sound_environment = 12

/area/station/turret_protected/AIbasecore2
	name = "AI Core 2"
	icon_state = "AIt"
	sound_environment = 12

/area/station/turret_protected/Zeta
	name = "Computer Core"
	icon_state = "AIt"
	sound_environment = 12

/area/station/turret_protected/armory
	name = "Armory"
	icon_state = "red"
	sound_environment = 12

/area/mining/mainasteroid
	name = "Main Asteroid"
	icon_state = "green"
	RL_Lighting = 0

/area/russian
	name = "Kosmicheskoi Stantsii 13"
	icon_state = "green"
	sound_environment = 13

/area/russian/radiation
	name = "Kosmicheskoi Stantsii 13"
	icon_state = "yellow"
	permarads = 1

/area/station/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"
	workplace = 1

/area/station/hydroponics/lobby
	name = "Hydroponics Lobby"
	icon_state = "green"

/area/station/owlery
	name = "Owlery"
	icon_state = "yellow"
	sound_environment = 15
	do_not_irradiate = 1

/area/station/routingdepot
	name = "Routing Depot"
	icon_state = "depot"
	sound_environment = 13
	do_not_irradiate = 1

	catering
		name = "Cafeteria Router"

	eva
		name = "EVA Router"

	engine
		name = "Engine Router"

	medsci
		name = "Med-Sci Router"

	security
		name = "Security Router"

	airbridge
		name = "Airbridge Router"
// ===

/area/New()
	src.icon = 'icons/effects/alert.dmi'
	src.layer = EFFECTS_LAYER_BASE
//Halloween is all about darkspace
	if(name == "Space")			// override defaults for space
		requires_power = 0
#ifdef HALLOWEEN
		alpha = 128
		icon = 'icons/effects/dark.dmi'
#endif

	if(!requires_power)
		power_light = 1
		power_equip = 1
		power_environ = 1
	else
		luminosity = 0


	/*spawn(5)
		for(var/turf/T in src)		// count the number of turfs (for lighting calc)
			if(no_air)
				T.oxygen = 0		// remove air if so specified for this area
				T.n2 = 0
				T.res_vars()

	*/


	spawn(15)
		src.power_change()		// all machines set to current power level, also updates lighting icon

/*
/proc/get_area(area/A)
	while (A)
		if (istype(A, /area))
			return A

		A = A.loc
	return null
*/

/area/proc/poweralert(var/state, var/source)
	if (state != poweralm)
		poweralm = state
		var/list/cameras = list()
		for (var/obj/machinery/camera/C in orange(source, 7))
			cameras += C
		for (var/mob/living/silicon/aiPlayer in mobs)
			if (state == 1)
				aiPlayer.cancelAlarm("Power", src, source)
			else
				aiPlayer.triggerAlarm("Power", src, cameras, source)
	return


/area/proc/firealert()
	if(src.name == "Space") //no fire alarms in space
		return
	if (!( src.fire ))
		src.fire = 1
		src.updateicon()
		src.mouse_opacity = 0
		var/list/cameras = list()
		for (var/obj/machinery/camera/C in src)
			cameras += C
		for (var/mob/living/silicon/ai/aiPlayer in mobs)
			aiPlayer.triggerAlarm("Fire", src, cameras, src)
		for (var/obj/machinery/computer/atmosphere/alerts/a in machines)
			a.triggerAlarm("Fire", src, cameras, src)
	return

/area/proc/firereset()
	if (src.fire)
		src.fire = 0
		src.mouse_opacity = 0
		src.updateicon()

		for (var/mob/living/silicon/ai/aiPlayer in mobs)
			aiPlayer.cancelAlarm("Fire", src, src)
		for (var/obj/machinery/computer/atmosphere/alerts/a in machines)
			a.cancelAlarm("Fire", src, src)
	return

/area/proc/areacorrupt()
	if(src.name == "Space")
		return
	if (!( src.corrupted ))
		src.corrupted = 1
		src.updateicon()
		src.mouse_opacity = 0

		for (var/turf/simulated/floor/T in src)
			total_corrupted_terrain++

	return

/area/proc/areauncorrupt()
	if(src.name == "Space")
		return
	if (src.corrupted)
		src.corrupted = 0
		src.updateicon()
		src.mouse_opacity = 0

		for (var/turf/simulated/floor/T in src)
			total_corrupted_terrain = max(0, total_corrupted_terrain - 1)

	return

/area/proc/partyalert()
	if(src.name == "Space") //no parties in space!!!
		return
	if (!( src.party ))
		src.party = 1
		src.updateicon()
		src.mouse_opacity = 0
	return

/area/proc/partyreset()
	if (src.party)
		src.party = 0
		src.mouse_opacity = 0
		src.updateicon()
		for(var/obj/machinery/door/firedoor/D in src)
			D.set_open()

/area/proc/updateicon()
	if ((fire || eject || party) && power_environ)
		if(fire && !eject && !party)
//			icon_state = "blue"
			icon_state = null
		else if(!fire && eject && !party)
			icon_state = "red"
		else if(party && !fire && !eject)
			icon_state = "party"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null
	if (corrupted) icon_state = "corrupt"


// pantsfix
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
#define TOTAL 4

/area/proc/powered(var/chan)		// return true if the area has power to given channel

	if(!requires_power)
		return 1
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ
	return 0

// called when power status changes

/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()

	updateicon()

/area/proc/usage(var/chan)

	switch(chan)
		if(LIGHT)
			. = used_light
		if(EQUIP)
			. = used_equip
		if(ENVIRON)
			. = used_environ
		if(TOTAL)
			. = used_light + used_equip + used_environ

/area/proc/clear_usage()

	used_equip = 0
	used_light = 0
	used_environ = 0

/area/proc/use_power(var/amount, var/chan)

	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

/area/station/turret_protected
	name = "Turret Protected Area"
	var/list/obj/machinery/turret/turret_list = list()
	var/obj/machinery/camera/motion/motioncamera = null

/area/station/turret_protected/New()
	..()
	// locate and store the motioncamera
	spawn (20) // spawn on a delay to let turfs/objs load
		for (var/obj/machinery/camera/motion/M in src)
			motioncamera = M
			return
	return


/area/station/turret_protected/Entered(O)
	..()
	if (istype(O, /mob/living))
		if(!istype(O, /mob/living/silicon))
			if (motioncamera)
				motioncamera.newTarget(O)
			popUpTurrets()
	return 1

/area/station/turret_protected/Exited(O)
	..()
	if (istype(O, /mob/living))
		if (!istype(O, /mob/living/silicon))
			if(motioncamera)
				motioncamera.lostTarget(O)
			//popDownTurrets()
	return 1

/area/station/turret_protected/proc/popDownTurrets()
	for (var/obj/machinery/turret/aTurret in src.turret_list)
		aTurret.popDown()

/area/station/turret_protected/proc/popUpTurrets()
	for (var/obj/machinery/turret/aTurret in src.turret_list)
		aTurret.popUp()