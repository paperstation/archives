/datum/round_event_control/bloodflea_invasion
	name = "Bloodflea Invasion"
	typepath = /datum/round_event/bloodflea_invasion
	weight = 10
	max_occurences = 20

/datum/round_event/bloodflea_invasion
	announceWhen = 60

	var/fleas = 3
	var/spawns = 6

/datum/round_event/bloodflea_invasion/announce()
	command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
	for(var/mob/M in player_list)
		M << sound('sound/AI/aliens.ogg')

/datum/round_event/bloodflea_invasion/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/local_vent/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded)
			vents += temp_vent

	for(var/i=0, i<spawns, ++i)
		var/obj/vent = pick_n_take(vents)
		if(!vent) break
		for(var/j=0, j<fleas, ++j)
			new /mob/living/simple_animal/hostile/space_funeral/bloodflea(vent.loc)