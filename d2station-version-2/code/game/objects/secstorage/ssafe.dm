/obj/item/weapon/secstorage/ssafe
	name = "secure safe"
	icon = 'storage.dmi'
	icon_state = "safe"
	icon_open = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	flags = FPRINT | TABLEPASS
	force = 8.0
	w_class = 4.0
	anchored = 1.0
	density = 0

/obj/item/weapon/secstorage/ssafe/New()
	..()
	new /obj/item/weapon/paper(src)
	new /obj/item/weapon/pen(src)

/obj/item/weapon/secstorage/ssafe/attack_hand(mob/user as mob)
	return attack_self(user)


/obj/item/weapon/secstorage/ssafe/erika
	name = "Erika's safe"
	icon_state = "safe"
	icon_open = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	l_code = "15781"
	l_hacking = 0
	l_move_time = 1
	l_set = 1
	l_setshort = 0


	New()
		..()
		new /obj/item/clothing/head/kittyears(src)
		new /obj/item/clothing/under/rank/barskirt(src)
		new /obj/item/clothing/suit/labcoat(src)
		new /obj/item/clothing/shoes/brown(src)

/obj/item/weapon/secstorage/ssafe/rebecca
	name = "Rebecca's safe"
	icon_state = "safe"
	icon_open = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	l_code = "41341"
	l_hacking = 0
	l_move_time = 1
	l_set = 1
	l_setshort = 0

	New()
		..()
		new /obj/item/clothing/head/rabbitears(src)
		new /obj/item/clothing/under/blackskirt(src)
		new /obj/item/clothing/shoes/brown(src)

/obj/item/weapon/secstorage/ssafe/emily
	name = "Emily's safe"
	icon_state = "safe"
	icon_open = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	l_code = "31337"
	l_hacking = 0
	l_move_time = 1
	l_set = 1
	l_setshort = 0

/obj/item/weapon/secstorage/ssafe/nori
	name = "Nori's safe"
	icon_state = "safe"
	icon_open = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	l_code = "99518"
	l_hacking = 0
	l_move_time = 1
	l_set = 1
	l_setshort = 0