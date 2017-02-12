/datum/subsystem/pipenets
	name = "Pipenets"
	wait = 60

/datum/subsystem/pipenets/Initialize()
	set background = 1
	..()
	for(var/obj/machinery/atmospherics/M in machines)
		M.build_network()

	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

/datum/subsystem/pipenets/fire()
	set background = 1

	var/i = 1
	while(i<=pipe_networks.len)
		var/datum/pipe_network/Network = pipe_networks[i]
		if(Network)
			Network.process()
			++i
			continue
		pipe_networks.Cut(i,i+1)
