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