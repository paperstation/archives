datum/controller/process/chemistry
	var/tmp/datum/updateQueue/chemistryUpdateQueue

	setup()
		name = "Chemistry"
		schedule_interval = 10
		chemistryUpdateQueue = new

	doWork()
		for(var/datum/d in active_reagent_holders)
			d:process_reactions()
			scheck()
