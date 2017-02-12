/datum/event/radiation_storm
	announceWhen	= 5
	oneShot			= 1


/datum/event/radiation_storm/announce()
	command_alert("High levels of radiation detected near the station. Please report to the Med-bay if you feel strange.", "Anomaly Alert")
	world << sound('sound/AI/radiation.ogg')


/datum/event/radiation_storm/start()
	for(var/mob/living/carbon/C in living_mob_list)
		var/turf/T = get_turf(C)
		if(!T)			continue
		if(T.z != 1)	continue
		C.deal_damage(rand(15, 75), IRRADIATE, IRRADIATE)
		if(prob(5))
			C.deal_damage(rand(15, 50), IRRADIATE, IRRADIATE)
			if(prob(75))
				randmutb(C)
				domutcheck(C, null, 1)
			else
				randmutg(C)
				domutcheck(C, null, 1)