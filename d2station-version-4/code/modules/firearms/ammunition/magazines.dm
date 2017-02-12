/obj/item/ammo_magazine/a75//Still needs to be gone through
	name = "magazine (6.1mm)"
	icon_state = "gyro"
	calibre = "6.1"
	max_ammo = 8
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/a75(src)
		update_icon()

/obj/item/ammo_magazine/fiveseven
	name = "magazine (5.7x28mm)"
	icon_state = "5_7"
	calibre = "5.7"
	max_ammo = 20
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/c57(src)
		update_icon()

/obj/item/ammo_magazine/c45
	name = "magazine (.45)"
	icon_state = "45mag"
	calibre = "11.4"
	max_ammo = 22
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/c45(src)
		update_icon()

/obj/item/ammo_magazine/c50ae
	name = "magazine (.50AE)"
	icon_state = "50AE"
	calibre = "12.7"
	max_ammo = 7
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/c50ae(src)
		update_icon()

/obj/item/ammo_magazine/c9mm
	name = "magazine (9mm)"
	icon_state = "9mm"
	calibre = "9.0"
	max_ammo = 10
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/c9mm(src)
		update_icon()

/obj/item/ammo_magazine/c9mmext
	name = "extended magazine (9mm)"
	icon_state = "9mmext"
	calibre = "9.0"
	max_ammo = 20
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/c9mm(src)
		update_icon()

/obj/item/ammo_magazine/c9mmdrum	//Holy shit overpowered
	name = "drum magazine (9mm)"
	icon_state = "9mmdrum"
	calibre = "9.0"
	max_ammo = 50
	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new /obj/item/ammo_casing/c9mm(src)
		update_icon()

	update_icon()
		if(stored_ammo.len > 0)
			icon_state = text("[initial(icon_state)]-1")	//Don't need to make 50 icon states
		else
			icon_state = initial(icon_state)
		desc = text("There are [] round\s left!", stored_ammo.len)

/obj/item/ammo_magazine/energy
	name = "energy magazine"
	icon_state = "disruptormag"
	calibre = "energy"
	var/charge = 0
	var/maxcharge = 1000
	origin_tech = "powerstorage=1"

	New()
		give(maxcharge)

	// use power
	proc/use(var/amount)
		charge = max(0, charge-amount)
		update_icon()

	// charge power
	proc/give(var/amount)
		var/power_used = min(maxcharge-charge,amount)
		charge += power_used
		update_icon()
		return power_used

	update_icon()
		overlays = null
		var/ratio = charge / maxcharge
		ratio = round(ratio, 0.20) * 100
		overlays += image("icon" = 'ammo.dmi', "icon_state" = text("[][]", initial(icon_state), ratio))

/obj/item/ammo_magazine/energy/crap
	maxcharge = 500

/obj/item/ammo_magazine/energy/high
	maxcharge = 10000

/obj/item/ammo_magazine/energy/super
	maxcharge = 20000
	origin_tech = "powerstorage=2"

/obj/item/ammo_magazine/energy/hyper
	maxcharge = 30000
	origin_tech = "powerstorage=3"

/obj/item/ammo_magazine/energy/infinite
	maxcharge = 30000
	origin_tech = "powerstorage=4"
	use()
		return

/obj/item/ammo_magazine/energy/ep90
	name = "E-P90 magazine"
	icon_state = "ep90mag"
	calibre = "ep90"
	maxcharge = 2000