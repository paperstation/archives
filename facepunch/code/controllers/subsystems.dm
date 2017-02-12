/datum/subsystem
	var/name
	var/can_fire = 1
	var/wait = 20
	var/next_fire = 0
	var/cpu = 0
	var/cost = 0
	var/times_fired = 0

/datum/subsystem/proc/fire()

/datum/subsystem/proc/Initialize()
	world << "<font color='red'><b>Initializing [name]</b></font>"
	if(!wait)
		master_controller.subsystems -= src	//so it doesn't process