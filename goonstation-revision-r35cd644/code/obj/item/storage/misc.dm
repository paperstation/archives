
/obj/item/storage/box/mousetraps
	name = "\improper Pest-B-Gon Mousetraps box"
	desc = "WARNING: Keep out of reach of children."
	icon_state = "mousetraps"
	spawn_contents = list(/obj/item/mousetrap = 7)

/obj/item/storage/box/nerd_kit
	name = "tabletop gaming kit"
	desc = "It's the famous carmine box starter set for Syndicates & Stations, Fifth Edition."
	icon_state = "nerdkit"
	item_state = "box_red"
	spawn_contents = list(/obj/item/paper/book/monster_manual,\
	/obj/item/dice,\
	/obj/item/dice/d4,\
	/obj/item/dice/d12,\
	/obj/item/dice/d20,\
	/obj/item/dice/d100)

/obj/item/storage/box/balloonbox
	name = "balloon box"
	icon_state = "balloons"
	desc = "A box filled with an assortment of colored balloons."
	spawn_contents = list(/obj/item/reagent_containers/balloon = 7)

/obj/item/storage/box/crayon
	name = "crayon box"
	icon_state = "crayon_box-temp"
	desc = "Don't go outside the lines. You don't wanna know what happens to you if you do."
	spawn_contents = list(/obj/item/pen/crayon/random = 7)

/obj/item/storage/box/marker
	name = "marker box"
	icon_state = "marker_box-temp"
	desc = "Don't go outside the lines. You don't wanna know what happens to you if you do."
	spawn_contents = list(/obj/item/pen/marker/random = 7)

/obj/item/storage/wall/emergency
	name = "emergency supplies"
	desc = "A wall-mounted storage container that has a few emergency supplies in it."
	icon_state = "miniO2"

	make_my_stuff()
		..()
		if (prob(40))
			new /obj/item/storage/toolbox/emergency(src)
		if (prob(33))
			new /obj/item/clothing/suit/space/emerg(src)
			new /obj/item/clothing/head/emerg(src)
		if (prob(10))
			new /obj/item/storage/firstaid/oxygen(src)
		if (prob(10))
			new /obj/item/tank/air(src)
		if (prob(2))
			new /obj/item/tank/oxygen(src)
		if (prob(2))
			new /obj/item/clothing/mask/gas/emergency(src)
		for (var/i=rand(2,3), i>0, i--)
			if (prob(33))
				new /obj/item/tank/emergency_oxygen(src)
			if (prob(40))
				new /obj/item/clothing/mask/breath(src)

/*		switch (pickweight(list("small" = 10, "mask" = 10, "tank" = 5, "both" = 20, "nothing" = 1)))
			if ("small")
				new /obj/item/tank/emergency_oxygen(src)
				new /obj/item/tank/emergency_oxygen(src)
			if ("mask")
				new /obj/item/clothing/mask/breath(src)
			if ("tank")
				new /obj/item/tank/air(src)
			if ("both")
				new /obj/item/tank/emergency_oxygen(src)
				new /obj/item/clothing/mask/breath(src)
			if ("nothing")
				return
*/
/obj/item/storage/wall/fire
	name = "firefighting supplies"
	desc = "A wall-mounted storage container that has a few firefighting supplies in it."
	icon_state = "minifire"

	make_my_stuff()
		..()
		if (prob(80))
			new /obj/item/extinguisher(src)
		if (prob(30))
			new /obj/item/clothing/suit/fire(src)
			new /obj/item/clothing/mask/gas/emergency(src)
		if (prob(10))
			new /obj/item/storage/firstaid/fire(src)
		if (prob(5))
			new /obj/item/storage/toolbox/emergency(src)
