/datum/random_event/major/solarflare
	name = "Solar Flare"
	centcom_headline = "Incoming Solar Flare"
	centcom_message = "A Solar Flare will soon pass by the station. Communications may be affected."

	event_effect(var/source)
		..()
		sleep(rand(50,100))
		solar_flare = 1
		sleep(rand(900,1800))
		solar_flare = 0
		if (random_events.announce_events)
			command_alert("The Solar Flare has safely passed [station_name()]. Communications should be restored to normal.", "All Clear")
		else
			message_admins("<span style=\"color:blue\">Random Radio/Flare Event ceasing.</span>")