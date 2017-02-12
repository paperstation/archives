/datum/event/comm_blackout
	announceWhen	= 50
	oneShot			= 1

/datum/event/comm_blackout/announce()
	command_alert("Space related runtimes detected on or around [station_name()]. Messages going to CentComm have been deactivated.", "Vital Alert")



/datum/event/comm_blackout/start()
	for(var/obj/machinery/computer/communications/A in world)
		if(A.z == 1)
			A.message_cooldown = 1
	for(var/obj/item/device/radio/intercom/A in world)
		if(A.z == 1)
			A.on = 0




/datum/event/mystshuttle
	announceWhen	= 50
	oneShot			= 1
	var/shuttype
/datum/event/mystshuttle/announce()
	command_alert("An unmarked shuttle has appeared on or around [station_name()].", "Crazy Jims Shuttle Locating Service Alert")


/datum/event/mystshuttle/start()
	move_admin_shuttle()
