/proc/station_spin(var/times = 2, var/announce = 1)
	if(announce)
		command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert")
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				M << sound('sound/AI/granomalies.ogg')
	for(var/amount = times, amount > 0, amount--)
		if(amount > 100)//San check to make sure we dont get more 99999999 station spins
			amount = 100
		for(var/i = 8, i >= 1, i = i/2)
			for(var/mob/M in world)
				if(!M.client)
					continue
				M.client.dir = i
			sleep(4)
	return 1
