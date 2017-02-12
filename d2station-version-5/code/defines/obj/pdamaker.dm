///
/// This is the PDA maker for the head of Personnel
///
///
///
///





/obj/machinery/vending/PDACart
	name = "PDA Cartridge Creation Computer"
	desc = "You can use this to create new PDA cartridges"
	icon = 'computer.dmi'
	icon_state = "PDA"
	product_paths = "/obj/item/weapon/cartridge/captain;/obj/item/weapon/cartridge/ce;/obj/item/weapon/cartridge/clown;/obj/item/weapon/cartridge/cmo;/obj/item/weapon/cartridge/engineering;/obj/item/weapon/cartridge/head;/obj/item/weapon/cartridge/hop;/obj/item/weapon/cartridge/hos;/obj/item/weapon/cartridge/janitor;/obj/item/weapon/cartridge/medical;/obj/item/weapon/cartridge/quartermaster;/obj/item/weapon/cartridge/rd;/obj/item/weapon/cartridge/security;/obj/item/weapon/cartridge/signal/toxins"
	product_amounts = "5;5;5;5;5;5;5;5;5;5;5;5;5;5"
	product_prices = "0;0;0;0;0;0;0;0;0;0;0;0;0;0"
	product_hidden = "/obj/item/weapon/cartridge/syndicate"
	product_hideamt = "5"

/*
/obj/machinery/computer/PDACart/attack_hand(var/mob/user as mob)

	if (stat & (NOPOWER|BROKEN))
		return

	if(printing)
		return

	user.machine = src

	var/list/L = list()
	for (var/obj/item/weapon/cartridge/C)
		L.Add(C)

	var/t = input(user, "Which PDA cartridge should we print?") as null|anything in L

	if(!t)
		user.machine = null
		return 0
	if(t)
		var/product_path = L[t] as obj
		printing = 1
		user << "now printing"
		sleep(5)
		playsound(src.loc, 'vend.ogg', 40, 0)
		new product_path(get_turf(src))
		use_power(500)
		printing = null

	if (t == "Cancel")
		user.machine = null
		return 0
*/