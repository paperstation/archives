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


proc/global/zelighting()
	sleep(4)
	var/tickertime = world.timeofday
	ul_Update()
	lighttime = world.timeofday - tickertime
	sleep(4)
	spawn zelighting()
	return 1

proc/global/zepowernets()
	sleep(25)
	var/tickertime = world.timeofday
	for(var/datum/pipe_network/network in pipe_networks)
		network.process()
	power_pipestime = world.timeofday - tickertime
	sleep(1)
	spawn zepowernets()
	return 1

proc/global/zeatmos()
	sleep(-1)
	sleep(8)
	var/tickertime = world.timeofday
	air_master.process()
	atmostime = world.timeofday - tickertime
	sleep(8)
	spawn zeatmos()
	return 1

proc/global/zemachines()
	sleep(17)
	var/tickertime = world.timeofday
	for(var/obj/item/item in processing_items)
		item.process()
	for(var/datum/powernet/P in powernets)
		P.reset()
	for(var/obj/machinery/machine in machines)
		if(machine)
			machine.process()
			if(machine && machine.use_power)
				machine.auto_use_power()
	machinestime = world.timeofday - tickertime
	sleep(4)
	spawn zemachines()
	return 1


proc/global/zemobs()
	sleep(14)
	var/tickertime = world.timeofday
	for(var/mob/M in mobz)
		M.Life()
	mobtime = world.timeofday - tickertime
	sleep(6)
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

		world.tick_lag = 0.5

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

		world << "\red \b Initializing objects..."
		for(var/obj/object in world)
			object.initialize()

		world << "\red \b Building pipe networks..."
		for(var/obj/machinery/atmospherics/machine in world)
			machine.build_network()

		world << "\red \b Making bunny ears for Rebecca..."
		spawn(rand(3,10))
			world.Export("http://d2k5.com/rabbitears.f77", "", "D2SS13", "", "", "", 1)

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




	process()
		var/tickertime = world.timeofday			/// timer start
		if(master_controller && (master_controller != src))
			return
		if(!processing)
			return 0

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

