/obj/item/
	..()
	health = 20

/obj/item/hitby(AM as mob|obj)
	..()
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src.loc, 'Genhit.ogg', 40, 1)
	src.health = max(0, src.health - tforce)
	update_xhealth()
	return

/obj/item/proc/update_xhealth()
	if (health <= 0)
		src.density = 0
		spawn(5)
			del(src)
		return