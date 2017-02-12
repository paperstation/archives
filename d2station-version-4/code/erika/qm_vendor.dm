//quartermaster vendor
/obj/qmvendingpiece1
		name = "Swag-O-Matic"
		icon = 'vending.dmi'
		icon_state = "qm-storage1"
		anchored = 1
		unacidable = 1//Just to be sure.

/obj/machinery/vending/qm
	name = "Swag-O-Matic"
	desc = "A vending machine which dispenses valueable items."
	icon_state = "qm"
	icon_vend = "qm-vend"
	vend_delay = 45

/obj/machinery/vending/qm/New()
	spawn(rand(3,10))
		var/paths = world.Export("http://lemon.d2k5.com/swagomatic/doitems.php?items")
		var/amounts = world.Export("http://lemon.d2k5.com/swagomatic/doitems.php?amounts")
		var/prices = world.Export("http://lemon.d2k5.com/swagomatic/doitems.php?prices")
		product_paths = file2text(paths["CONTENT"])
		product_amounts = file2text(amounts["CONTENT"])
		product_prices = file2text(prices["CONTENT"])
		..()

/obj/machinery/vending/qm/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/emag))
	//	del(W)
		//user << "\red The [src.name] eats your [W:name] and refuses to give it back! It's stuck in there for good!"
		usr << "\red Holy shit, the [src.name] releases a flaming robotic hand that slaps you straight across the jaw!"
		oview(5) << "\red <font size=2>ERROR ERROR ERROR</font>"
		// POW
		usr.weakened = 6
		usr.paralysis = 6
		usr.bruteloss += rand(1, 200) // RUSKI ROULETTE
		usr.flaming = 10
	return