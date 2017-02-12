/obj/closet/emcloset/New()
	..()

	if (prob(40))
		new /obj/item/weapon/storage/toolbox/emergency(src)

	if (prob(35))
		new /obj/item/weapon/storage/firstaid/oxydep/(src)

	switch (pickweight(list("small" = 30, "aid" = 25, "tank" = 27, "fire" = 15, "both" = 10, "nothing" = 4, "biohazard" = 3, "fireaxe" = 2, "delete" = 1)))
		if ("small")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)

		if ("aid")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/weapon/storage/pill_bottle/dexalinp(src)
			new /obj/item/weapon/crowbar(src)

		if ("tank")
			new /obj/item/weapon/tank/air(src)
			new /obj/item/clothing/mask/breath(src)

		if ("both")
			new /obj/item/weapon/tank/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)

		if ("nothing")
			// doot

		// teehee
		if ("delete")
			del(src)

		//If you want to re-add fire, just add "fire" = 15 to the pick list.
		if ("fire")
			new /obj/closet/firecloset(src.loc)
			del(src)
		if ("biohazard")
			new /obj/closet/l4closet(src.loc)
			del(src)
		if ("fireaxe")
			new /obj/closet/firecloset_withaxe(src.loc)
			del(src)
