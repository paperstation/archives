var/global/datum/controller/game_controller/master_controller //Set in world.New()
var/global/controllernum = "no"
var/global/controlleriteration = 0
var/global/list/airlocks = list()
var/global/list/doors = list()
var/global/thread1 = 0
var/global/lighttime = 0
var/global/atmostime = 0
var/global/machinestime = 0
var/global/mobtime = 0
var/global/power_pipestime = 0
//var/global/datum/controller/shields/Shields
//var/global/datum/zombiehavmund/Zombie_Hivemind = null
//var/global/zombiez_on = 0
var/global/list/mob/mobz = list()
var/global/list/active_diseases_low = list()
//var/global/zombiestime = 0
//var/global/spawn_zom_once = 0
var/global/obj/item/timecontroller/timecontroller
var/global/list/turf/turfs = list()
var/global/list/obj/landmark/landmarkz = list()
var/global/list/area/areaz = list()
var/global/mobson = 0
var/global/atmoson = 0

proc/global/zelighting()
	sleep(4)
	var/tickertime = world.timeofday
	ul_Update()
	lighttime = world.timeofday - tickertime
	sleep(4)
	spawn zelighting()
	return 1

proc/global/zepowernets()
	sleep(15)
	var/tickertime = world.timeofday
	for(var/datum/pipe_network/network in pipe_networks)
		network.process()
	power_pipestime = world.timeofday - tickertime
	sleep(1)
	spawn zepowernets()
	return 1

proc/global/zeatmos()
	sleep(-1)
	sleep(4)
	var/tickertime = world.timeofday
	start:
	if(mobson)
		sleep(1)
		goto start
	atmoson = 1
	air_master.process()
	atmoson = 0
	atmostime = world.timeofday - tickertime
	sleep(4)
	spawn zeatmos()
	return 1

proc/global/zemachines()
	sleep(8)
	var/tickertime = world.timeofday
	for(var/obj/machinery/machine in machines)
		if(machine)
			machine.process()
			if(machine && machine.use_power)
				machine.auto_use_power()
	machinestime = world.timeofday - tickertime
	sleep(1)
	tickertime = world.timeofday
	for(var/obj/item/item in processing_items)
		item.process()
	sleep(1)
	for(var/datum/powernet/P in powernets)
		P.reset()
	objecttime = world.timeofday - tickertime

	sleep(1)
	spawn zemachines()
	return 1


proc/global/zemobs()
	sleep(3)
	var/tickertime = world.timeofday
	start1:
	if(mobson)
		sleep(1)
		goto start1
	mobson = 1
	for(var/mob/M in mobz)
		M.Life()
	mobson = 0
	mobtime = world.timeofday - tickertime
	sleep(5)
	spawn zemobs()
	return 1

proc/global/Important_disease()
	sleep(13)
	var/tickertime = world.timeofday
	for(var/datum/disease/D in active_diseases)
		D.process()
	mobtime = world.timeofday - tickertime
	sleep(7)
	spawn Important_disease()
	return 1

proc/global/crap_disease()
	set background = 1
	sleep(16)
	var/tickertime = world.timeofday
	for(var/datum/disease/D in active_diseases_low)
		D.process()
	mobtime = world.timeofday - tickertime
	sleep(9)
	spawn crap_disease()
	return 1
///////////////////////////////////////////////////////////////////////////////Zombies////////////////////////////////////////////////////////
/*
proc/global/zezombies()
	sleep(-1)
	sleep(2)
	var/tickertime = world.timeofday
	Zombie_Hivemind.rebuild_targets()
	sleep(2)
	Zombie_Hivemind.targets()
	zombiestime = world.timeofday - tickertime
	if(zombiez_on)
		spawn zezombies()
	return 1
*/
///////////////////////////////////////////////////////////////////////////////Zombies////////////////////////////////////////////////////////




datum/controller/game_controller
	var/processing = 1

	proc
		setup()
		setup_objects()
		process()

	setup()
		if(master_controller && (master_controller != src))
			return
			//There can be only one!.
		/*if(!Zombie_Hivemind)
			Zombie_Hivemind = new /datum/zombiehavmund()
		*/

		if(!air_master)
			air_master = new /datum/controller/air_system()
			air_master.setup()
			air_master.process()
			ul_Update()
//		if(!Shields)
//			Shields	= new /datum/controller/shields()

		world.tick_lag = 0.3

		setup_objects()


		setupgenetics()

		//setupcorpses() Not used any more.
		syndicate_code_phrase = generate_code_phrase()//Sets up code phrase for traitors, for the round.
		syndicate_code_response = generate_code_phrase()

		emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()

		if(!ticker)
			ticker = new /datum/controller/gameticker()

		spawn
			ticker.pregame()

	setup_objects()
		world << "\red \b Aligning items to walls..."
		/*
		for(var/obj/align in world)
			if(istype(align, /obj/machinery/status_display) || istype(align, /obj/machinery/alarm) || istype(align, /obj/machinery/firealarm) || istype(align, /obj/sign) || istype(align, /obj/closet/oxygenwall) || istype(align, /obj/closet/extinguisher) || istype(align, /obj/machinery/camera) || istype(align, /obj/machinery/power/apc) || istype(align, /obj/machinery/door_control) || istype(align, /obj/machinery/embedded_controller) || istype(align, /obj/item/device/radio/intercom))
				if(align.dir == NORTH || align.dir == NORTHEAST || align.dir == NORTHWEST)
					align.pixel_y = -64
				if(align.dir == EAST)
					align.pixel_x = -64
				if(align.dir == SOUTH || align.dir == SOUTHEAST || align.dir == SOUTHWEST)
					align.pixel_y = 64
				if(align.dir == WEST)
					align.pixel_x = -64
		*/


		world << "\red \b Initializing objects..."
		for(var/obj/object in world)
			object.initialize()

		world << "\red \b Building pipe networks..."

/*
		world << "\red \b Activating shields.."
		Shield = new /datum/shieldnetwork()
		ShieldNetwork.makenetwork()
		setupnetwork()
*/

		world << "\red \b Randomizing item placement..."
		antimeta_randomchem()
		antimeta_junk()
		antimeta_food()
		antimeta_generaltools()
		antimeta_medicaltools()
		antimeta_medicalkits()
		antimeta_rnd()
		for(var/turf/T in world)
			turfs -= T
			turfs += T
		for(var/obj/machinery/M in world)
			machines -= M
			machines += M
		for(var/area/A in world)
			areaz -= A
			areaz += A
		for(var/mob/M in world)
			mobz -= M
			mobz += M
		world << "\red \b Indexes processed."
		world << "\red \b Initializations complete."
		zelighting()
		zepowernets()
		zemachines()
		zeatmos()
		zemobs()
		Important_disease()
		crap_disease()

		//Item AutoScale
		//world << "\red \b Processing floor icons..."
		//for(var/turf/floors in world)
		//	floors.xScale(64,64)
		//world << "\red \b Processing machine icons..."
		//for(var/obj/machinery/machine in world)
		//	machine.xScale(64,64)

	process()
		var/tickertime = world.timeofday			/// timer start
		if(master_controller && (master_controller != src))
			return
		if(!processing)
			return 0
		if(controlleriteration%150==1)
			for(var/mob/M in locate(/area/spawn))
				M.loc = pick(latejoin)
				log_admin("[M.name] has been detected in the spawn screen and was moved to a late join location")
			/*	if(zombiez_on && !spawn_zom_once)
			Zombie_Hivemind.rebuild_targets()
			sleep(5)
			zezombies()
			spawn_zom_once = 1
	*/
//		if (controlleriteration%30==1)
//			for(var/mob/M in mobz)
//				if(!M.client)continue
//				mobwithclient -= M
//				mobwithclient += M
			//world << "Processing"
//		Shields.UsePowerCheck()
		controllernum = "yes"
		spawn (100) controllernum = "no"
		controlleriteration++
		var/start_time = world.timeofday
		sun.calc_position()
		ticker.process()
		thread1 = world.timeofday - tickertime
		sleep(world.timeofday+13-start_time)
		spawn process()
		return 1

