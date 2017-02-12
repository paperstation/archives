/obj/item/ammo_box/c38
	name = "speed loader (.38)"
	icon_state = "38"
	New()
		for(var/i = 1, i <= 7, i++)
			stored_ammo += new /obj/item/ammo_casing/c38(src)
		update_icon()


/obj/item/ammo_box/cT38
	name = "speed loader (.38 taser round)"
	icon_state = "tase38"
	New()
		for(var/i = 1, i <= 6, i++)
			stored_ammo += new /obj/item/ammo_casing/cT38(src)
		update_icon()


/obj/item/ammo_box/a418
	name = "ammo box (.418)"
	icon_state = "418"
	New()
		for(var/i = 1, i <= 7, i++)
			stored_ammo += new /obj/item/ammo_casing/a418(src)
		update_icon()


/obj/item/ammo_box/a666
	name = "ammo box (.666)"
	icon_state = "666"
	New()
		for(var/i = 1, i <= 2, i++)
			stored_ammo += new /obj/item/ammo_casing/a666(src)
		update_icon()


/obj/item/ammo_box/c9mm
	name = "Ammunition Box (9mm)"
	icon_state = "9mm"
	origin_tech = "combat=3;materials=2"
	New()
		for(var/i = 1, i <= 30, i++)
			stored_ammo += new /obj/item/ammo_casing/c9mm(src)
		update_icon()

	update_icon()
		desc = text("There are [] round\s left!", stored_ammo.len)


/obj/item/ammo_box/c45
	name = "Ammunition Box (.45)"
	icon_state = "9mm"
	origin_tech = "combat=3;materials=2"
	New()
		for(var/i = 1, i <= 30, i++)
			stored_ammo += new /obj/item/ammo_casing/c45(src)
		update_icon()

	update_icon()
		desc = text("There are [] round\s left!", stored_ammo.len)

/obj/item/ammo_box/shotgun
	name = "ammo box (12gauge)"
	desc = "A box of 12 gauge shells"
	icon_state = "12g"

	New()
		for(var/i = 1, i <= 6, i++)
			stored_ammo += new /obj/item/ammo_casing/shotgun(src)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/ammo_box/shotgunbeanbag
	name = "ammo box (12gauge beanbag)"
	desc = "A box of 12 gauge beanbag shells"
	icon_state = "12b"
	m_amt = 25000

	New()
		for(var/i = 1, i <= 6, i++)
			stored_ammo += new /obj/item/ammo_casing/shotgun/beanbag(src)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/ammo_box/magnetpellet
	name = "Magnet Rifle round"
	icon_state = "magnet_round"
	origin_tech = "combat=3;materials=2"
	New()
		stored_ammo += new /obj/item/ammo_casing/magnetpellet(src)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

