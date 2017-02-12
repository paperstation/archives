/obj/machinery/
	..()
	var/health = 200

/obj/machinery/door/airlock
	..()
	health = 400

/obj/machinery/door/airlock/external
	..()
	health = 600

/obj/machinery/hitby(AM as mob|obj)
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src.loc, 'Genhit.ogg', 20, 1)
	src.health = max(0, src.health - tforce)
	update_health()
	..()
	return

/obj/machinery/proc/update_health()
	if (health <= 0)
		src.density = 0
		playsound(src.loc, 'Deconstruct.ogg', 100, 1)
		spawn(5)
			del(src)
		new /obj/item/stack/sheet/metal(src)
		if(prob(5))
			new /obj/item/stack/sheet/metal(src)
		if(prob(5))
			new /obj/item/stack/sheet/r_metal(src)
		if(prob(5))
			new /obj/item/stack/sheet/glass(src)
		return