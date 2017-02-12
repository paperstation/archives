//This subsystem controls powernets, power usage and power generation.
//Simply add any atom to the list SSpower.members and override the default process_power() proc.
//Note: /obj/machinery/power are automatically added to SSpower.members

var/datum/subsystem/power/SSpower

/datum/subsystem/power
	name = "Power"
	wait = 100

	var/defer_powernet_rebuild = 0

	var/list/processing = list()
	var/list/powernets = list()
	var/list/smes = list()
	var/list/apcs = list()

/datum/subsystem/power/New()
	if(SSpower != src)
		SSpower = src

/datum/subsystem/power/Initialize()
	set background = 1
	..()
	makepowernets()
	fire()		//This is to get the lists pruned and APC areas initialized before we spawn players.

/datum/subsystem/power/fire()
	set background = 1

	var/seconds = wait / 10

	for(var/datum/powernet/Powernet in powernets)
		Powernet.reset()

	for(var/obj/machinery/power/smes/S in smes)		//smes distribute as much as they can
		S.distribute_power(seconds)

	if(apcs.len)
		for(var/obj/machinery/power/apc/APC in apcs)
			APC.distribute_power(seconds)
		apcs += apcs[1]
		apcs.Cut(1,2)

	if(smes.len)
		for(var/obj/machinery/power/smes/S in smes)
			S.charge(seconds)
		for(var/obj/machinery/power/smes/S in smes)		//smes reclaim any unused power
			S.reclaim_unused_power()
		smes += smes[1]
		smes.Cut(1,2)

	var/i = 1
	while(i <= processing.len)
		var/atom/M = processing[i]
		if(M && M.process_power(seconds) != PROCESS_KILL) //handles power consumption/production
			++i
			continue
		processing.Cut(i, i+1)




/*
   process_power(seconds)
      This proc is used to generate and/or consume power.
      The seconds argument is passed automatically from the power subsystem.
      It represents the number of seconds between calls, and is used as a multiplier to scale power usage,
      so that slowing or speeding up the subsystem doesn't affect the rate of power use/generation.

      By default:
	      For machines:
	      	>machine is auto-added to the members list
	      	>if use_power == USE_POWER_NONE, machine will be removed from the list

	      For all other atoms:
	      	>You must add it to the members list yourself
	      	>You must override the proc yourself
*/

/atom/proc/process_power()
	return PROCESS_KILL

/obj/machinery/process_power(seconds)
	if(!idle_power_usage && !active_power_usage)
		return PROCESS_KILL
	switch(use_power)
		if(USE_POWER_NONE)
			return 1
		if(USE_POWER_IDLE)
			if(!powered(power_channel))
				return 0
			use_power(idle_power_usage * seconds, power_channel)
		else
			if(!powered(power_channel))
				return 0
			use_power(active_power_usage * seconds, power_channel)
	return 1


/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines/terminals

	var/newload = 0
	var/load = 0

	var/newavail = 0
	var/avail = 0

/datum/powernet/Del()
	SSpower.powernets -= src
	..()

/datum/powernet/proc/reset()
	load = newload
	newload = 0

	avail = newavail
	newavail = 0

