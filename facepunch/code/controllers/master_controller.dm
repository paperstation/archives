//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

//Update: all core-systems are now placed inside subsystem datums. This makes them highly configurable and easy to work with.

var/global/datum/controller/game_controller/master_controller = new()

/datum/controller/game_controller
	var/processing_interval = 1	//The minimum length of time between MC ticks. The highest this can be without affecting schedules, is the GCD of all subsystem var/wait. Set to 0 to disable all processing.
	var/iteration = 0
	var/cost = 0
	var/last_thing_processed

	var/list/subsystems

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		if(istype(master_controller))
			Recover()
			del(master_controller)
		else
			//This both stores the subsystems, but also dictates the order in which they initialize
			subsystems = newlist(
				/datum/subsystem/jobs,
				/datum/subsystem/sun,
				/datum/subsystem/ticker,
				/datum/subsystem/objects,
				/datum/subsystem/power,
				/datum/subsystem/machines,
				/datum/subsystem/pipenets,
				/datum/subsystem/lighting,
				/datum/subsystem/air,
				/datum/subsystem/diseases,
				/datum/subsystem/mobs,
				/datum/subsystem/supply_shuttle,
				/datum/subsystem/vote
				)

		master_controller = src

	var/GCD
	for(var/datum/subsystem/SS in subsystems)
		GCD = Gcd(SS.wait, GCD)
	GCD = round(GCD)
	if(GCD)
		processing_interval = GCD

/datum/controller/game_controller/proc/setup()
	world << "<font color='red'><b>Initializing game...</b></font>"

	//createRandomZlevel() The tg gate system loading

	if(!emergency_shuttle)
		emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()

	if(!tip)
		tip = pick(tiplist)

	for(var/i=0, i<max_secret_rooms, i++)
		make_mining_asteroid_secret()

	//Eventually all this other setup stuff will be contained in subsystems and done in subsystem.Initialize()
	for(var/datum/subsystem/S in subsystems)
		S.Initialize()
		sleep(-1)

	world << "<font color='red'><b>Initializations complete!</b></font>"

	world.sleep_offline = 1

	if(config.fps > 0)	world.fps = config.fps

	ticker.pregame()

//used for smoothing out the cost values so they don't fluctuate wildly
#define MC_AVERAGE(average, current) (0.8*(average) + 0.2*(current))

/datum/controller/game_controller/proc/process()
	if(!Failsafe)	new /datum/controller/failsafe()
	spawn(0)
		set background = 1

		var/timer = world.time
		for(var/datum/subsystem/SS in subsystems)
			timer += processing_interval
			SS.next_fire = timer

		var/start_time

		while(1)	//far more efficient than recursively calling ourself
			if(processing_interval > 0)
				++iteration

				start_time = world.timeofday

				for(var/datum/subsystem/SS in subsystems)
					if(SS.next_fire <= world.time)
						if(SS.can_fire == 1)
							timer = world.timeofday
							last_thing_processed = SS.type
							SS.fire()
							SS.cpu = MC_AVERAGE(SS.cpu, world.cpu)
							SS.cost = MC_AVERAGE(SS.cost, world.timeofday - timer)
							++SS.times_fired
						SS.next_fire += SS.wait

				cost = MC_AVERAGE(cost, world.timeofday - start_time)

				sleep(processing_interval)
			else
				sleep(50)

#undef MC_AVERAGE


/datum/controller/game_controller/proc/Recover()
	var/msg = "## DEBUG: [time2text(world.timeofday)] MC restarted. Reports:\n"
	for(var/varname in master_controller.vars)
		switch(varname)
			if("tag","bestF","type","parent_type","vars")	continue
			else
				var/varval = master_controller.vars[varname]
				if(istype(varval,/datum))
					var/datum/D = varval
					msg += "\t [varname] = [D.type]\n"
				else
					msg += "\t [varname] = [varval]\n"
	world.log << msg

	subsystems = master_controller.subsystems