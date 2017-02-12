/obj/machinery/door/proc/checkForMultipleDoors()
	if(!src.loc)
		return 0
	for(var/obj/machinery/door/D in src.loc)
		if(D.density)
			return 0
	return 1

/turf/simulated/wall/proc/checkForMultipleDoors()
	if(!src.loc)
		return 0
	for(var/obj/machinery/door/D in locate(src.x,src.y,src.z))
		if(D.density)
			return 0
	//There are no false wall checks because that would be fucking retarded
	return 1