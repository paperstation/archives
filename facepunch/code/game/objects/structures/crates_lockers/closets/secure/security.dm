/obj/structure/closet/secure_closet/captains
	name = "Captain's Locker"
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"
	#ifdef NEWMAP
	req_access = list(access_captain_area)
	#else
	req_access = list(access_captain)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/captain(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/weapon/cartridge/captain(src)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/clothing/gloves/captain(src)
		new /obj/item/weapon/gun/energy/gun(src)

		return



/obj/structure/closet/secure_closet/hop
	name = "Head of Personnel's Locker"
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"
	#ifdef NEWMAP
	req_access = list(access_hop_area)
	#else
	req_access = list(access_hop)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/under/rank/head_of_personnel(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/weapon/cartridge/hop(src)
		new /obj/item/device/radio/headset/heads/hop(src)
		new /obj/item/weapon/storage/box/ids(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/device/flash(src)
		return



/obj/structure/closet/secure_closet/hos
	name = "Head of Security's Locker"
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	#ifdef NEWMAP
	req_access = list(access_hos_area)
	#else
	req_access = list(access_hos)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/security(src)
		new /obj/item/clothing/under/rank/head_of_security/jensen(src)
		new /obj/item/clothing/suit/armor/hos/jensen(src)
		new /obj/item/clothing/head/helmet/HoS/dermal(src)
		new /obj/item/weapon/cartridge/hos(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/weapon/shield/riot(src)
		new /obj/item/weapon/storage/lockbox/loyalty(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/gun(src)
		return



/obj/structure/closet/secure_closet/warden
	name = "Warden's Locker"
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"
	#ifdef NEWMAP
	req_access = list(access_armory_area)
	#else
	req_access = list(access_armory)
	#endif


	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/security(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/under/rank/warden(src)
		new /obj/item/clothing/suit/armor/vest/warden(src)
		new /obj/item/clothing/head/helmet/warden(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		return



/obj/structure/closet/secure_closet/security
	name = "Security Officer's Locker"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	#ifdef NEWMAP
	req_access = list(access_sec_gear_area)
	#else
	req_access = list(access_security)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/security(src)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/grenade/flashbang(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		return


/obj/structure/closet/secure_closet/detective
	name = "Detective's Cabinet"
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"
	#ifdef NEWMAP
	req_access = list(access_detective_area)
	#else
	req_access = list(access_forensics_lockers)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/device/detective_scanner(src)
		new /obj/item/clothing/under/rank/vicedetective(src)
		new /obj/item/clothing/head/vicehat(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/under/det(src)
		new /obj/item/clothing/suit/det_suit(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/det_hat(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/ammo_magazine/c38(src)
		new /obj/item/ammo_magazine/c38(src)
		new /obj/item/weapon/gun/projectile/detective(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		return

/obj/structure/closet/secure_closet/detective/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/injection
	name = "Lethal Injections"
	#ifdef NEWMAP
	req_access = list(access_armory_area)
	#else
	req_access = list(access_armory)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
		return



/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
	anchored = 1
	var/id = null
	#ifdef NEWMAP
	req_access = list(access_cells_area)
	#else
	req_access = list(access_brig)
	#endif

	New()
		new /obj/item/clothing/under/color/orange( src )
		new /obj/item/clothing/shoes/orange( src )
		return


/obj/structure/closet/secure_closet/brig/cell_1
	name = "Cell 1 Locker"
	id = "Cell 1"

/obj/structure/closet/secure_closet/brig/cell_2
	name = "Cell 2 Locker"
	id = "Cell 2"

/obj/structure/closet/secure_closet/brig/cell_3
	name = "Cell 3 Locker"
	id = "Cell 3"

/obj/structure/closet/secure_closet/brig/cell_4
	name = "Cell 4 Locker"
	id = "Cell 4"

/obj/structure/closet/secure_closet/brig/cell_5
	name = "Cell 5 Locker"
	id = "Cell 5"


/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	#ifdef NEWMAP
	req_access = list(access_courtroom_area)
	#else
	req_access = list(access_court)
	#endif

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/paper/Court (src)
		new /obj/item/weapon/paper/Court (src)
		new /obj/item/weapon/paper/Court (src)
		new /obj/item/weapon/pen (src)
		new /obj/item/clothing/suit/judgerobe (src)
		new /obj/item/clothing/head/powdered_wig (src)
		new /obj/item/weapon/storage/briefcase(src)
		return
