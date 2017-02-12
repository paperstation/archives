// OMG SHOES

/obj/item/clothing/shoes
	name = "shoes"
	icon = 'shoes.dmi'

	body_parts_covered = FEET

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	armor = list(melee = 0, bullet = 0, laser = 2, taser = 2, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/black
	name = "Black Shoes"
	icon_state = "black"

/obj/item/clothing/shoes/brown
	name = "Brown Shoes"
	icon_state = "brown"

/obj/item/clothing/shoes/orange
	name = "Orange Shoes"
	icon_state = "orange"
	var/chained = 0

/obj/item/clothing/shoes/swat
	name = "SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50, taser = 25, bomb = 50, bio = 10, rad = 0)

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat"
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50, taser = 25, bomb = 50, bio = 10, rad = 0)
	flags = NOSLIP

/obj/item/clothing/shoes/space_ninja
	name = "ninja shoes"
	desc = "A pair of running shoes. Excellent for running and even better for smashing skulls."
	icon_state = "s-ninja"
	protective_temperature = 700
	permeability_coefficient = 0.01
	flags = NOSLIP
	armor = list(melee = 60, bullet = 50, laser = 30, taser = 15, bomb = 30, bio = 30, rad = 30)

/obj/item/clothing/shoes/white
	name = "White Shoes"
	icon_state = "white"
	permeability_coefficient = 0.25

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "Magic Shoes"
	icon_state = "black"

/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots"
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1

/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	protective_temperature = 800
	heat_transfer_coefficient = 0.01
	airflowprot = 1
	var/magpulse = 0
	flags = NOSLIP //disabled by default

/obj/item/clothing/shoes/workboots
	name = "work boots"
	icon_state = "workboots"
	item_state = "workboots"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.70

/obj/item/clothing/shoes/clown_shoes
	desc = "Damn, thems some big shoes."
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1

/obj/item/clothing/shoes/jackboots
	name = "Jackboots"
	desc = "Formerly owned by Officer Jack."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor = list(melee = 40, bullet = 30, laser = 20, taser = 15, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/shoes/touristsandal
	name = "socks and sandals"
	desc = "A favorite footwear combination for visitors to temperate climates."
	icon_state = "tourist"

/obj/item/clothing/shoes/fireboots
	desc = "Won't burn your feet on fire with these!"
	name = "fire boots"
	icon_state = "fireboots"
	item_state = "fireboots"
	protective_temperature = 800
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/skates
	desc = "Won't slip around on ice with these!"
	name = "skates"
	icon_state = "skates"
	item_state = "skates"

/obj/item/clothing/shoes/flippers
	desc = "You wouldn't be able to swim in that deep water without these!"
	name = "swimming flippers"
	icon_state = "flippers"
	item_state = "flippers"

/obj/item/clothing/shoes/screwballshoes
	name = "Screwball Super-toesies"
	icon_state = "screwballshoes"
	item_state = "screwballshoes"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.70
	armor = list(melee = 80, bullet = 60, laser = 50, taser = 25, bomb = 50, bio = 10, rad = 0)