/datum/random_event/minor/pests
	name = "Pests"

	event_effect()
		..()
		var/list/EV = list()
		for(var/obj/landmark/S in world)
			if (S.name == "peststart")
				EV.Add(S.loc)
		if(!EV.len)
			return
		var/pestlandmark = pick(EV)
		var/masterspawnamount = rand(4,12)
		var/spawnamount = masterspawnamount
		var/type = rand(1,12)
		switch (type)
			if (1)
				while (spawnamount > 0)
					new /obj/critter/roach(pestlandmark)
					spawnamount -= 1
			if (2)
				while (spawnamount > 0)
					new /obj/critter/mouse(pestlandmark)
					spawnamount -= 1
			if (5)
				while (spawnamount > 0)
					new /obj/critter/spacebee(pestlandmark)
					spawnamount -= 1
		//pestlandmark.visible_message("A group of [type] emerges from their hidey-hole")