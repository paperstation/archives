/client/proc/atmosscan()
	set category = "Debug"
	set name = "Check Atmospheric Equipment"
	. = 0
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	for (var/area/A in areaz)
		for (var/obj/machinery/alarm/AA in A)
			if (A.master_air_alarm == null)
				usr << "[A] has air alarms but no master air alarm"
				.++
				break

	for (var/obj/machinery/atmospherics/plumbing in machines)
		if (plumbing.nodealert)
			usr << "Unconnected [plumbing] located at [plumbing.x],[plumbing.y],[plumbing.z] ([get_area(plumbing.loc)])"
			.++