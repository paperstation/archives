/obj/item/weapon/
	var/board_circuitry = 0
	var/board_trigger = 0
	var/board_heatsink = 0
	var/board_laserpointer = 0
	var/board_battery = 0
	var/barrel_coil = 0
	var/barrel_accel = 0
	var/housing_cboard = 0
	var/housing_coil = 0
	var/housing_energcoil = 0
	var/housing_accel = 0
	var/ishousingforlasergun = 0
	var/ishousingforplasmagun = 0
	var/ishousingforbulletgun = 0
	var/ishousingforenergygun = 0
	var/energygunelectronics = 0
	var/energygunhousing = 0
	var/energygunindicator = 0
	var/energygunbattery = 0
	var/energygungrip = 0

/obj/item/weapon/weaponassembly/underboard/attackby(obj/item/weapon/W as obj, mob/user as mob)		//Underboard, and the stuff that can go onto it. Might require soldiering later.
	if(!istype(W, /obj/item/weapon/cable_coil) && !src.board_circuitry)
		user << "\red This board needs some circuitry."
	else if(istype(W, /obj/item/weapon/cable_coil) && !src.board_circuitry)
		src.board_circuitry = 1
		src.overlays += icon('weapon_assembly.dmi', "underboard_wireoverlay")
	else if(istype(W, /obj/item/weapon/weaponassembly/trigger) && src.board_circuitry && !src.board_trigger)
		del(W)
		src.board_trigger = 1
		src.overlays += icon('weapon_assembly.dmi', "underboard_triggeroverlay")
	else if(istype(W, /obj/item/weapon/weaponassembly/battery) && src.board_circuitry && !src.board_battery)
		del(W)
		src.board_battery = 1
		src.overlays += icon('weapon_assembly.dmi', "underboard_batteryoverlay")
	else if(istype(W, /obj/item/weapon/weaponassembly/heatsink) && src.board_circuitry && !src.board_heatsink)
		del(W)
		src.board_heatsink = 1
		src.overlays += icon('weapon_assembly.dmi', "underboard_heatsinkoverlay")
	else if(istype(W, /obj/item/device/infra) && src.board_circuitry && !src.board_laserpointer)
		del(W)
		src.board_laserpointer = 1
		src.overlays += icon('weapon_assembly.dmi', "underboard_infraredoverlay")


/obj/item/weapon/weaponassembly/barrel/attackby(obj/item/weapon/W as obj, mob/user as mob)			//Smacking a barrel with a barrel mod
	if(istype(W, /obj/item/weapon/weaponassembly/plsm_accel) && !src.barrel_coil && !src.barrel_accel)
		src.icon_state = "accel_barrel"
		src.barrel_accel = 1
		del(W)
		user << "\blue You slide the accelerator over the barrel and fasten it in place."
	if(istype(W, /obj/item/weapon/weaponassembly/driving_coil) && !src.barrel_coil && !src.barrel_accel)
		src.icon_state = "coil_barrel"
		src.barrel_coil = 1
		del(W)
		user << "\blue You slide the coil over the barrel and fasten it in place."

/obj/item/weapon/weaponassembly/plsm_accel/attackby(obj/item/weapon/W as obj, mob/user as mob)			//Now for the other way around
	if(istype(W, /obj/item/weapon/weaponassembly/barrel) && !W.barrel_coil && !W.barrel_accel)
		W.icon_state = "accel_barrel"
		W.barrel_accel = 1
		del(src)
		user << "\blue You slide the barrel into the accelerator and fasten it in place."
/obj/item/weapon/weaponassembly/driving_coil/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weaponassembly/barrel) && !W.barrel_coil && !W.barrel_accel)
		W.icon_state = "coil_barrel"
		W.barrel_coil = 1
		del(src)
		user << "\blue You slide the barrel into the coil and fasten it in place."

/obj/item/weapon/weaponassembly/housing/attackby(obj/item/weapon/W as obj, mob/user as mob)				//Shoving the underboard into a housing
	if(istype(W, /obj/item/weapon/weaponassembly/underboard))
		if(W.board_laserpointer)
			src.ishousingforlasergun = 1
			src.housing_cboard = 1
			del(W)
			src.icon_state = "housing_cboard"
			user << "\blue You install the circuit board into a housing."
	if(istype(W, /obj/item/weapon/weaponassembly/underboard))
		src.housing_cboard = 1
		del(W)
		src.icon_state = "housing_cboard"
		user << "\blue You install the circuit board into a housing."
//	else
//		user << "\red The circuit board doesn't seem quite finished."

	if(istype(W, /obj/item/weapon/weaponassembly/barrel))												//Shoving barrels into the housing
		if(W.barrel_coil && src.housing_cboard)
			del(W)
			src.icon_state = "housing_coil"
			src.ishousingforbulletgun = 1
			user << "\blue You slide the modified barrel into the housing and fasten it."
	if(istype(W, /obj/item/weapon/weaponassembly/barrel))
		if(W.barrel_accel && src.housing_cboard)
			src.ishousingforplasmagun = 1
			del(W)
			src.icon_state = "housing_accel"
			user << "\blue You slide the modified barrel into the housing and fasten it."

	if(istype(W, /obj/item/weapon/weaponassembly/coil_energ) && src.housing_cboard == 1 && src.ishousingforbulletgun == 1)
		src.icon_state = "housing_coil_energ"
		del(W)
		src.housing_energcoil = 1
		user << "\blue You wire the coil energizer into the now-finished component housing."

	if(istype(W, /obj/item/weapon/weaponassembly/hsng_panels) && src.ishousingforlasergun == 1)			//Finalizing the housing with some paneling
		new /obj/item/weapon/gun/energy/laser(get_turf(src))
		del(W)
		del(src)

	if(istype(W, /obj/item/weapon/weaponassembly/hsng_panels) && src.ishousingforplasmagun == 1)
		new /obj/item/weapon/gun/energy/plasma/rifle(get_turf(src))
		del(W)
		del(src)

	if(istype(W, /obj/item/weapon/weaponassembly/hsng_panels) && src.housing_energcoil == 1)
		new /obj/item/weapon/gun/projectile/magnetrifle(get_turf(src))
		del(W)
		del(src)


// Energy gun

/obj/item/weapon/weaponassembly/fronthousing/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weaponassembly/backhousing))
		new /obj/item/weapon/weaponassembly/energhousing(get_turf(src))
		del(W)
		del(src)

/obj/item/weapon/weaponassembly/backhousing/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weaponassembly/fronthousing))
		new /obj/item/weapon/weaponassembly/energhousing(get_turf(src))
		del(W)
		del(src)

/obj/item/weapon/weaponassembly/electronics/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weaponassembly/battery) && !src.energygunbattery)
		src.overlays += icon('weapon_assembly.dmi', "energygunbattery_overlay")
		src.energygunbattery = 1
		del(W)
		user << "\blue You attach a battery to the electronics."
	if(istype(W, /obj/item/weapon/weaponassembly/energhousing) && !src.energygunhousing && src.energygunbattery)
		src.overlays += icon('weapon_assembly.dmi', "nrg-gun_assembledhousing")
		src.energygunhousing = 1
		del(W)
		user << "\blue You slide a housing over the electronics."
	if(istype(W, /obj/item/weapon/weaponassembly/grip) && src.energygunhousing && !src.energygungrip && !src.energygunindicator)
		src.overlays += icon('weapon_assembly.dmi', "nrg-gun_grip")
		src.energygungrip = 1
		del(W)
		user << "\blue You snap a weapon grip into the housing."
	if(istype(W, /obj/item/weapon/weaponassembly/indicator) && src.energygunhousing && !src.energygunindicator && !src.energygungrip && src.energygunbattery)
		src.overlays += icon('weapon_assembly.dmi', "nrg-gun_indicatoroverlay")
		src.energygunindicator = 1
		del(W)
		user << "\blue You wire the charge indicator into the housing."
	if(istype(W, /obj/item/weapon/weaponassembly/indicator) && src.energygunhousing && !src.energygunindicator && src.energygungrip && src.energygunbattery)
		src.overlays += icon('weapon_assembly.dmi', "nrg-gun_indicatoroverlay")
		src.energygunindicator = 1
		del(W)
		new /obj/item/weapon/gun/energy(get_turf(src))
		del(src)
		user << "\blue You wire the charge indicator into the housing, finishing the energy gun."
	if(istype(W, /obj/item/weapon/weaponassembly/grip) && src.energygunhousing && !src.energygungrip && src.energygunindicator)
		src.overlays += icon('weapon_assembly.dmi', "nrg-gun_grip")
		src.energygungrip = 1
		del(W)
		new /obj/item/weapon/gun/energy(get_turf(src))
		del(src)
		user << "\blue You snap a weapon grip into the housing, finishing the energy gun."


//	else
//		user << "\blue A battery needs to be hooked up to the electronics first."