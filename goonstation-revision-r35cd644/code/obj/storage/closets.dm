/obj/storage/closet
	name = "closet"
	desc = "It's a closet! This one can be opened AND closed."
	soundproofing = 3
	can_flip_bust = 1

/obj/storage/closet/emergency
	name = "emergency supplies closet"
	desc = "It's a closet! This one can be opened AND closed. Comes prestocked with emergency equipment. <i>Hopefully</i>."
	icon_state = "emergency"
	icon_closed = "emergency"
	icon_opened = "emergency-open"

	make_my_stuff() // cogwerks: adjusted probabilities a bit
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
/obj/storage/closet/fire
	name = "firefighting supplies closet"
	desc = "It's a closet! This one can be opened AND closed. Comes prestocked with firefighting equipment. <i>Hopefully</i>."
	icon_state = "fire"
	icon_closed = "fire"
	icon_opened = "fire-open"

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

/obj/storage/closet/janitor
	name = "custodial supplies closet"
	desc = "It's a closet! This one can be opened AND closed. Comes with janitor's clothes and biohazard gear."
	spawn_contents = list(/obj/item/clothing/suit/bio_suit,\
	/obj/item/clothing/head/bio_hood,\
	/obj/item/clothing/under/rank/janitor = 2,\
	/obj/item/clothing/shoes/black = 2,\
	/obj/item/device/flashlight,\
	/obj/item/clothing/shoes/galoshes,\
	/obj/item/caution = 6)

/obj/storage/closet/law
	name = "\improper Legal closet"
	desc = "It's a closet! This one can be opened AND closed. Comes with lawyer apparel and items."
	spawn_contents = list(/obj/item/clothing/under/misc/lawyer/black,\
	/obj/item/clothing/under/misc/lawyer/red,\
	/obj/item/clothing/under/misc/lawyer,\
	/obj/item/clothing/shoes/brown = 2,\
	/obj/item/clothing/shoes/black,\
	/obj/item/storage/briefcase = 2)

/obj/storage/closet/coffin
	name = "coffin"
	desc = "A burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin-open"

/obj/storage/closet/biohazard
	name = "\improper Level 3 Biohazard Suit closet"
	desc = "It's a closet! This one can be opened AND closed. Comes prestocked with level 3 biohazard gear for emergencies."
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bio-open"
	spawn_contents = list(/obj/item/clothing/suit/bio_suit,\
	/obj/item/clothing/under/color/white,\
	/obj/item/clothing/shoes/white,\
	/obj/item/clothing/head/bio_hood)

/obj/storage/closet/syndicate
	name = "gear closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicate-open"

/obj/storage/closet/syndicate/personal
	desc = "Gear preperations closet."
	spawn_contents = list(/obj/item/tank/jetpack,\
	/obj/item/clothing/mask/breath,\
	/obj/item/clothing/under/misc/syndicate,\
#ifdef XMAS
	/obj/item/clothing/head/helmet/space/santahat,\
	/obj/item/clothing/suit/space/santa,\
#else
	/obj/item/clothing/head/helmet/space/syndicate,\
	/obj/item/clothing/suit/space/syndicate,\
#endif
	/obj/item/crowbar,\
	/obj/item/cell/supercell/charged,\
	/obj/item/device/multitool)

/obj/storage/closet/syndicate/nuclear
	desc = "Nuclear preperations closet."
	spawn_contents = list(/obj/item/storage/box/handcuff_kit,\
	/obj/item/storage/box/flashbang_kit,\
	/obj/item/pinpointer/nuke = 5,\
	/obj/item/device/pda2/syndicate)

/obj/storage/closet/syndicate/malf
	desc = "Gear preperations closet."
	spawn_contents = list(/obj/item/tank/jetpack,\
	/obj/item/clothing/mask/breath,\
	/obj/item/clothing/head/helmet/space/syndicate,\
	/obj/item/clothing/suit/space/syndicate,\
	/obj/item/crowbar,\
	/obj/item/cell,\
	/obj/item/device/multitool)

/obj/storage/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	anchored = 1

/* let us never forget this - haine
/obj/closet/thunderdome/New()
	..()
	sleep(2)*/

/obj/storage/closet/thunderdome/red
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicate-open"
	spawn_contents = list(/obj/item/clothing/under/jersey/red,\
	/obj/item/clothing/under/jersey/red,\
	/obj/item/clothing/shoes/black = 2,\
	/obj/item/knife_butcher/predspear = 2,\
	/obj/item/gun/energy/laser_gun/pred = 2,\
	/obj/item/stimpack = 2,\
	/obj/item/storage/belt/wrestling = 2)

/obj/storage/closet/thunderdome/green
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1-open"
	spawn_contents = list(/obj/item/clothing/under/jersey/green,\
	/obj/item/clothing/under/jersey/green,\
	/obj/item/clothing/shoes/black = 2,\
	/obj/item/knife_butcher/predspear = 2,\
	/obj/item/gun/energy/laser_gun/pred = 2,\
	/obj/item/stimpack = 2,\
	/obj/item/storage/belt/wrestling = 2)

/obj/storage/closet/electrical_supply
	name = "electrical supplies closet"
	desc = "Everything you would ever need to repair electrical systems. Well, almost."
	spawn_contents = list(/obj/item/storage/toolbox/electrical = 3,\
	/obj/item/device/multitool = 3)

/obj/storage/closet/welding_supply
	name = "welding supplies closet"
	desc = "A handy closet full of everything an aspiring apprentice welder could ever need."
	spawn_contents = list(/obj/item/clothing/head/helmet/welding = 3,\
	/obj/item/weldingtool = 3)

/obj/storage/closet/office
	name = "office supply closet"
	desc = "Various supplies for the modern office."
	make_my_stuff()
		..()
		var/obj/item/paper_bin/B1 = new /obj/item/paper_bin(src)
		B1.pixel_y = 6
		B1.pixel_x = -5

		var/obj/item/paper_bin/B2 = new /obj/item/paper_bin(src)
		B2.pixel_y = 6
		B2.pixel_x = 5

		new /obj/item/postit_stack(src)

		var/obj/item/pen/B3 = new /obj/item/pen(src)
		B3.pixel_y = 0
		B3.pixel_x = -4

		var/obj/item/storage/box/marker/B4 = new /obj/item/storage/box/marker(src)
		B4.pixel_y = 0
		B4.pixel_x = 0

		var/obj/item/storage/box/crayon/B5 = new /obj/item/storage/box/crayon(src)
		B5.pixel_y = 0
		B5.pixel_x = 4

		var/obj/item/staple_gun/B6 = new /obj/item/staple_gun(src)
		B6.pixel_y = -5
		B6.pixel_x = -4

		var/obj/item/scissors/B7 = new /obj/item/scissors(src)
		B7.pixel_y = -5
		B7.pixel_x = 4
