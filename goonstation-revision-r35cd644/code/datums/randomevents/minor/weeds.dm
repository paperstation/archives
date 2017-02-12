/datum/random_event/minor/weeds
	name = "Weed Growth"

	event_effect()
		..()
		// First get which plant pots are available for free growth and pick one
		var/list/available_plant_pots = list()
		var/obj/machinery/plantpot/target_plant_pot = null

		for (var/obj/machinery/plantpot/P in world)
			if (P.current || P.dead || P.weedproof)
				// If there's already a plant there or it blocks weeds, disqualify the pot
				continue
			available_plant_pots += P

		if (!available_plant_pots.len)
			// We couldn't get any pots at all, so just give up
			return
		target_plant_pot = pick(available_plant_pots)

		// Now we place a weed seed in the pot and generate a new plant from it
		var/obj/item/seed/WS = new(target_plant_pot)
		switch (rand(1,6))
			// Randomly select what kind of weed we want
			if (1) WS.planttype = new /datum/plant/fungus(target_plant_pot)
			if (2) WS.planttype = new /datum/plant/lasher(target_plant_pot)
			if (3) WS.planttype = new /datum/plant/creeper(target_plant_pot)
			if (4) WS.planttype = new /datum/plant/radweed(target_plant_pot)
			if (5) WS.planttype = new /datum/plant/slurrypod(target_plant_pot)
			if (6) WS.planttype = new /datum/plant/grass(target_plant_pot)
		// Now spawn the plant and clean up
		target_plant_pot.HYPnewplant(WS)
		spawn(5)
			qdel(WS)
		return