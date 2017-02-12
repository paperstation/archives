/datum/subsystem/ticker
	name = "Ticker"
	wait = 20

/datum/subsystem/ticker/Initialize()
	set background = 1
	..()
	if(!ticker)
		ticker = new /datum/controller/gameticker()

	setupgenetics()
	setupfactions()

/datum/subsystem/ticker/fire()
	ticker.process()