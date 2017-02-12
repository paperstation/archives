
/obj/machinery/door/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 1421)
		if(prob(20))
			new/obj/item/stack/sheet/molten_glass( src.loc )
			new/obj/item/stack/rods( src.loc )
			for(var/mob/M in viewers(5, src))
				M << "\red \the [src] melts."
			del(src)

/obj/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 1421)
		if(prob(20))
			new/obj/item/stack/sheet/molten_glass( src.loc )
			new/obj/item/stack/rods( src.loc )
			del(src)


/turf/simulated/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 343)
		if(!haslayer)
			overlays += icon('templayers.dmi', "heat")
			haslayer = 1
	else if(exposed_temperature <= 283)
		if(!haslayer)
			overlays += icon('templayers.dmi', "cold")
			haslayer = 1
	else
		if(haslayer)
			overlays -= icon('templayers.dmi', "heat")
			overlays -= icon('templayers.dmi', "cold")
			haslayer = 0
	return ..()

/*
/obj/item/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 1421)
		if(prob(20))
			//var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item( src.loc )
			//I.desc = "Looks like this was \an [src] some time ago."
			new/obj/decal/cleanable/molten_item( src.loc )
			for(var/mob/M in viewers(5, src))
				M << "\red \the [src] melts."
			del(src)

/obj/stool/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 1821)
		if(prob(20))
			//var/obj/item/stack/sheet/molten_metal/I = new/obj/item/stack/sheet/molten_metal( src.loc )
			//I.desc = "Looks like this was \an [src] some time ago."
			new/obj/item/stack/sheet/molten_metal( src.loc )
			for(var/mob/M in viewers(5, src))
				M << "\red \the [src] melts."
			del(src)

/obj/machinery/computer/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 4330)
		if(prob(20))
			//var/obj/item/stack/sheet/molten_metal/I = new/obj/item/stack/sheet/molten_metal( src.loc )
			//I.desc = "Looks like this was \an [src] some time ago."
			new/obj/item/stack/sheet/molten_metal( src.loc )
			for(var/mob/M in viewers(5, src))
				M << "\red \the [src] melts."
			del(src)

//stops food from expiring in cold rooms
/obj/item/weapon/reagent_containers/food/snacks/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature < 300)
		src.canexpire = 0
	else
		src.canexpire = 1
*/

//All melting shit disabled.

/*
//Airlocks say whether they're hot or not
/obj/machinery/door/airlock/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 450)
		is_hot = 1
	else if(exposed_temperature < 250)
		is_cold = 1
	else
		is_cold = 0
		is_hot = 0
	..()*/