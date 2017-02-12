/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	variant = "black"
	desc = "A pair of black shoes."

	redcoat
		variant = "redcoat"	//Exists for washing machines. Is not different from black shoes in any way.

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"
	variant = "brown"

	captain
		variant = "captain"	//Exists for washing machines. Is not different from brown shoes in any way.
	hop
		variant = "hop"		//Exists for washing machines. Is not different from brown shoes in any way.
	ce
		variant = "chief"		//Exists for washing machines. Is not different from brown shoes in any way.
	rd
		variant = "director"	//Exists for washing machines. Is not different from brown shoes in any way.
	cmo
		variant = "medical"	//Exists for washing machines. Is not different from brown shoes in any way.
	cmo
		variant = "cargo"		//Exists for washing machines. Is not different from brown shoes in any way.

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"
	variant = "blue"

/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"
	variant = "green"

/obj/item/clothing/shoes/green/pota

/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"
	variant = "yellow"

/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"
	variant = "purple"

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	icon_state = "brown"
	variant = "brown"

/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"
	variant = "red"

/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "white"
	variant = "white"

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rain_bow"
	variant = "rainbow"

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	variant = "orange"

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	if (src.chained)
		src.chained = null
		src.slowdown = SHOES_SLOWDOWN
		new /obj/item/weapon/handcuffs( user.loc )
		src.icon_state = "orange"
	return

/obj/item/clothing/shoes/orange/attackby(H as obj, loc)
	..()
	if ((istype(H, /obj/item/weapon/handcuffs) && !( src.chained )))
		//H = null
		if (src.icon_state != "orange") return
		del(H)
		src.chained = 1
		src.slowdown = 15
		src.icon_state = "orange1"
	return