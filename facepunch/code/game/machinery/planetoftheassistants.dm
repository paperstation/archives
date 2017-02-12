/obj/machinery/shoecollector
	name = "Shoe Collector"
	desc = "I'm going to steal all your stuff!"
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o1"


/obj/machinery/shoecollector/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/clothing/shoes/green/pota))
		user << "You recycle some of the shoes you found."
		user.drop_item(W)
		new/obj/item/token(src.loc)
		del(W)