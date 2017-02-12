/turf/simulated/wall
	..()
	var/health = 500

/turf/simulated/wall/hitby(AM as mob|obj)
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src.loc, 'Genhit.ogg', 50, 1)
	src.health = max(0, src.health - tforce)
	update_health()
	..()
	return

/turf/simulated/wall/proc/update_health()
	if (health <= 0)
		src.density = 0
		dismantle_wall()
		return

/turf/structure/girder
	..()
	var/health = 100

/turf/structure/girder/hitby(AM as mob|obj)
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src.loc, 'Genhit.ogg', 40, 1)
	src.health = max(0, src.health - tforce)
	update_health()
	..()
	return

/turf/structure/girder/proc/update_health()
	if (health <= 0)
		src.density = 0
		new /obj/item/stack/sheet/metal(src)
		spawn(5)
			del(src)
		return