/*
/obj/machinery/slidedirector/New()

	..()

	switch(dir)
		if(NORTH)
			divert_to = WEST			// stuff will be moved to the west
			divert_from = NORTH			// if entering from the north
		if(SOUTH)
			divert_to = EAST
			divert_from = SOUTH
		if(EAST)
			divert_to = NORTH
			divert_from = WEST
		if(WEST)
			divert_to = SOUTH
			divert_from = EAST

*/
