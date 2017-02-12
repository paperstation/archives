var/datum/subsystem/machines/SSmachines
/datum/subsystem/machines
	name = "Machines"
	wait = 20

	var/list/processing = list()

/datum/subsystem/machines/Initialize()
	set background = 1
	..()
	fire()

/datum/subsystem/machines/New()
	if(SSmachines != src)
		SSmachines = src

/datum/subsystem/machines/fire()
	set background = 1

	var/i = 1
	while(i <= processing.len)
		var/obj/machinery/Machine = processing[i]
		if(Machine)
			if(Machine.process() != PROCESS_KILL)
				++i
				continue
		processing.Cut(i,i+1)