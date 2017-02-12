/datum/event/mystshuttle
	announceWhen	= 50
	oneShot			= 1
	var/shuttype
/datum/event/mystshuttle/announce()
	command_alert("An unmarked shuttle has appeared on or around [station_name()].", "Crazy Jims Shuttle Locating Service Alert")


/datum/event/mystshuttle/start()
	move_admin_shuttle()
