/obj/item/weapon/bikehorn/HasEntered(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		M << "\red <B>You step on the bike horn!</B>"
		playsound(src.loc, 'bikehorn.ogg', 50, 1)
	..()