/obj/item/weapon/extinguisher
	..()
	var/obj/item/loaded

/obj/item/weapon/extinguisher/attackby(var/obj/item/A as obj, mob/user as mob)
	if(!loaded)
		user.drop_item()
		A.loc = src
		loaded += A
		playsound(src.loc, 'pop.ogg', 50, 0)
		user << "\blue You load [A.name] into the [src.name]."
	else
		user << "\red There's already an item loaded into this fire extinguisher."
	return