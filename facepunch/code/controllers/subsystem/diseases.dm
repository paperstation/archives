/datum/subsystem/diseases
	name = "Diseases"
	wait = 60

/datum/subsystem/diseases/fire()
	set background = 1
	var/i = 1
	while(i<=active_diseases.len)
		var/datum/disease/Disease = active_diseases[i]
		if(Disease)
			Disease.process()
			++i
			continue
		active_diseases.Cut(i,i+1)
