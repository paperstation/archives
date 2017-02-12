/proc/bloodflea_invasion(var/fleas = 3, var/spawns = 6)
	//First gather up all the vents in the world that are not welded and on Z1
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/local_vent/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			vents += temp_vent

	//Now pick several vents and spawn fleas
	for(var/i=0, i<spawns, i++)
		if(!vents.len)
			break
		var/obj/vent = pick(vents)
		if(!vent)
			break
		for(var/j=0, j<fleas, j++)
			new/mob/living/simple_animal/hostile/space_funeral/bloodflea(vent.loc)
		vents -= vent


	spawn(rand(600, 1200)) //Delayed announcements to keep the crew on their toes.
		command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
		for(var/mob/M in player_list)
			M << sound('sound/AI/aliens.ogg')
	return 1