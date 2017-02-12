/*/obj/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 3000)
		if(prob(20))
			del(src)*/

/turf/simulated/wall/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 8000)
		if(prob(20))
			src.ex_act(1)
			dismantle_wall(1)

/turf/simulated/wall/r_wall/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return


/turf/simulated/floor/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 1000)
		if(prob(20))
			src.break_tile_to_plating()

/obj/item/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 2000)
		if(prob(20))
			new /obj/decal/ash( src.loc )
			del(src)