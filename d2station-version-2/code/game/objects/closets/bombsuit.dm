/obj/closet/bombcloset/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/bomb_suit( src )
	new /obj/item/clothing/under/color/black( src )
	new /obj/item/clothing/shoes/black( src )
	new /obj/item/clothing/head/bomb_hood( src )

/obj/closet/bombclosetsecurity/New()
	..()
	sleep(2)
	new /obj/item/clothing/suit/bomb_suit/security( src )
	new /obj/item/clothing/under/color/red( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/head/bomb_hood/security( src )
