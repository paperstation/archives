/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effects/sparks
	name = "sparks"
	icon_state = "sparks"
	var/amount = 6.0
	anchored = 1.0
	mouse_opacity = 0

/obj/effects/sparks/unpooled(var/poolname)
	..(poolname)
	spawn(5)
		playsound(src.loc, "sparks", 100, 1)
		var/turf/T = src.loc
		if (istype(T, /turf))
			T.hotspot_expose(1000,100)
	return

/obj/effects/sparks/disposing()
	var/turf/T = get_turf(src)
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	..()

/obj/effects/sparks/Move()
	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	return