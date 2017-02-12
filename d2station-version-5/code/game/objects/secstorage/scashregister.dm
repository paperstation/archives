/obj/item/weapon/secstorage/cashregister
	name = "cash register"
	icon = 'storage.dmi'
	icon_state = "cashregister"
	icon_open = "cashregister0"
	icon_locking = "cashregisterb"
	icon_sparking = "cashregisterspark"
	flags = FPRINT | TABLEPASS
	force = 8.0
	w_class = 4.0
	anchored = 1.0
	density = 0

/obj/item/weapon/secstorage/cashregister/attack_hand(mob/user as mob)
	return attack_self(user)