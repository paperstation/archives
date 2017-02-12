/obj/item/weapon/storage/cock
	name = "penis"
	desc = "A very small item indeed."
	icon = 'belts.dmi'
	icon_state = "cock"
	item_state = "cock"
	can_hold = list(
		"/obj/item/clothing/mask/cigarette",
		"/obj/item/weapon/reagent_containers/pill",
		"/obj/item/weapon/reagent_containers/syringe"
	)
	flags = FPRINT | TABLEPASS | ONBELT

/obj/item/weapon/storage/cock/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP))
			return

		M.pulling = null
		M << "\blue You slipped on the [name]!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/item/weapon/storage/utilitybelt
	name = "utility belt"
	desc = "Can hold various tools."
	icon = 'belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		"/obj/item/weapon/crowbar",
		"/obj/item/weapon/screwdriver",
		"/obj/item/weapon/weldingtool",
		"/obj/item/weapon/wirecutters",
		"/obj/item/weapon/wrench",
		"/obj/item/device/multitool",
		"/obj/item/device/flashlight",
		"/obj/item/weapon/cable_coil",
		"/obj/item/device/t_scanner",
		"/obj/item/weapon/zippo",
		"/obj/item/weapon/storage/cigpack",
		"/obj/item/device/analyzer"
	)
	flags = FPRINT | TABLEPASS | ONBELT

/obj/item/weapon/storage/utilitybelt/full/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wrench(src)
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/weapon/cable_coil(src,30,pick("red","yellow"))

/obj/item/weapon/storage/utilitybelt/secbelt
	name = "security belt"
	desc = "Can hold various objects commonly used by the security force."
	icon_state = "secbelt"
	item_state = "sec"
	can_hold = list(
		"/obj/item/weapon/handcuffs",
		"/obj/item/ammo_casing",
		"/obj/item/ammo_magazine",
		"/obj/item/weapon/crowbar",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/gun/energy/laser",
		"/obj/item/weapon/gun/energy",
		"/obj/item/weapon/gun/projectile/mateba",
		"/obj/item/weapon/gun/projectile/detective",
		"/obj/item/device/flash",
		"/obj/item/weapon/chem_grenade/flashbang",
		"/obj/item/weapon/storage/cigpack",
		"/obj/item/weapon/zippo",
		"/obj/item/weapon/reagent_containers/food/snacks/donut",
		"/obj/item/weapon/reagent_containers/food/drinks/coffee",
		"/obj/item/device/taperecorder",
		"/obj/item/device/flashlight",
		"/obj/item/device/radio",
		"/obj/item/device/detective_scanner",
		"/obj/item/weapon/pepperspray"
	)
	flags = FPRINT | TABLEPASS | ONBELT

/obj/item/weapon/storage/utilitybelt/secbelt/full/New()
	..()
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/chem_grenade/flashbang(src)

/obj/item/weapon/storage/utilitybelt/medical
   name = "medical belt"
   desc = "Can hold various medical equipment."
   icon_state = "medicalbelt"
   item_state = "medical"
   can_hold = list(
		"/obj/item/device/healthanalyzer",
		"/obj/item/weapon/dnainjector",
		"/obj/item/weapon/reagent_containers/dropper",
		"/obj/item/weapon/reagent_containers/glass/beaker",
		"/obj/item/weapon/reagent_containers/glass/bottle",
		"/obj/item/weapon/reagent_containers/pill",
		"/obj/item/weapon/reagent_containers/syringe",
		"/obj/item/weapon/reagent_containers/glass/dispenser",
		"/obj/item/weapon/zippo",
		"/obj/item/weapon/storage/cigpack",
		"/obj/item/weapon/storage/pill_bottle",
		"/obj/item/stack/medical",
		"/obj/item/device/flashlight/pen",
		"/obj/item/weapon/storage/syringes"
	)
   flags = FPRINT | TABLEPASS | ONBELT

/obj/item/weapon/storage/backpack
	name = "satchel"
	desc = "You wear this over your shoulder and put items into it."
	icon_state = "backpack"
	w_class = 4.0
	flags = 259.0
	max_w_class = 3
	max_combined_w_class = 20
/*
/obj/item/weapon/storage/lbe
	name = "Load Bearing Equipment"
	desc = "You wear these on your thighs, they help carry heavy loads."
	icon_state = "backpack" //PLACEHOLDER
	w_class = 2.0
	max_combined_w_class = 17
*/
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "This is told to hold untold horrors of pills."
	icon_state = "pill_canister"
	icon = 'chemical.dmi'
	item_state = "contsolid"
	w_class = 2.0
	can_hold = list("/obj/item/weapon/reagent_containers/pill")
	New()
		..()
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/storage/dice
	name = "dice pack"
	desc = "Apparently this has dice in them."
	icon_state = "dicepack"
	item_state = "contsolid"
	w_class = 2.0
	can_hold = list("/obj/item/weapon/dice")

/obj/item/weapon/storage/recyclingbin
	name = "recycling bin"
	anchored = 1.0
	density = 1.0
	desc = "A regular trash can."
	icon = 'stationobjs.dmi'
	icon_state = "trashcan_regular"
	item_state = "syringe_kit"
	flags = 259.0

/obj/item/weapon/storage/box
	name = "Box"
	desc = "A nice looking box."
	icon_state = "box"
	item_state = "syringe_kit"

/obj/item/weapon/storage/survival_kit
	name = "Centcom Survival Kit"
	desc = "How nice of CentCom to provide us with some stuff to make our lives easier."
	icon_state = "box"
	item_state = "syringe_kit"

/obj/item/weapon/storage/survival_kit/engineer
	name = "Centcom Engineer Kit"

/obj/item/weapon/storage/pillbottlebox
	name = "pill bottles"
	desc = "A box of pill bottles."
	icon_state = "box"
	item_state = "syringe_kit"

/obj/item/weapon/storage/blankbox
	name = "blank shells"
	desc = "A box containing...stuff..."
	icon_state = "box"
	item_state = "syringe_kit"

/obj/item/weapon/storage/drinkingglasses
	name = "glassware box"
	desc = "A box containing...stuff..."
	icon_state = "glassware"
	item_state = "syringe_kit"

/obj/item/weapon/storage/paperbag
	name = "Paper bag"
	desc = "Contains food and other... 'materials'."
	icon_state = "paperbag"
	item_state = "syringe_kit"

/obj/item/weapon/storage/backpack/clown
	name = "Giggles Von Honkerton"
	desc = "The backpack made by Honk. Co."
	icon_state = "clownpack"

/obj/item/weapon/storage/backpack/medic
	name = "medic's satchel"
	desc = "The satchel used to keep with the sterile environment."
	icon_state = "medicalpack"

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "A very robust backpack."
	icon_state = "securitypack"

/obj/item/weapon/storage/backpack/satchel
	name = "Satchel"
	desc = "A very robust satchel to wear on your back."
	icon_state = "satchel"

/obj/item/weapon/storage/backpack/industrial
	name = "industrial satchel"
	desc = "A tough satchel for the daily grind"
	icon_state = "engiepack"

/obj/item/weapon/storage/briefcase
	name = "briefcase"
	desc = "Used by the lawyer to robust security in the court room."
	icon_state = "briefcase"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	max_w_class = 3
	max_combined_w_class = 16

/obj/item/weapon/storage/guncase/energygun
	name = "gun case - energy gun"
	icon_state = "guncase-energy"
	item_state = "nrggun-case"
	desc = "Contains the parts needed to assemble an energy gun."
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 4
	throw_speed = 1
	throw_range = 4
	w_class = 4.0

/obj/item/weapon/storage/disk_kit
	name = "data disks"
	desc = "For disks."
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/disk_kit/disks

/obj/item/weapon/storage/disk_kit/disks2

/obj/item/weapon/storage/fcard_kit
	name = "Fingerprint Cards"
	desc = "This contains cards which are used to take fingerprints."
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/firstaid
	name = "First-Aid"
	desc = "In case of a boo-boo."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	var/empty = 0

/obj/item/weapon/storage/firstaid/hypospray
	name = "Hypospray Vials"
	icon_state = "hypospray"

/obj/item/weapon/storage/firstaid/fire
	name = "Fire First Aid"
	desc = "A kit for when you 'accidently' set toxins on fire and burn yourself."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

/obj/item/weapon/storage/syringes
	name = "Syringes"
	desc = "A box full of syringes."
	desc = "A biohazard alert warning is printed on the box"
	icon_state = "syringe"
	w_class = 1.0
	max_w_class = 1

/obj/item/weapon/storage/firstaid/toxin
	name = "Toxin First Aid"
	desc = "Used to treat when you have a high amount of toxins in your body. Or atleast the box containing those things."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

/obj/item/weapon/storage/firstaid/o2
	name = "Oxygen Deprivation First Aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/weapon/storage/firstaid/addiction
	name = "Addiction First Aid"
	desc = "A small kit filled with medical supplies targeted for eliminating addiction."
	icon_state = "addiction"
	item_state = "firstaid-addiction"

/obj/item/weapon/storage/flashbang_kit
	desc = "A box full of flashbangs! There seems to have been a huge warning here, but there's a sticker saying 'Have fun!' placed on top of it!"
	name = "Flashbang kit"
	icon_state = "flashbang"
	item_state = "syringe_kit"

/obj/item/weapon/storage/emp_kit
	desc = "A box with 5 EMP grenades."
	name = "EMP grenades"
	icon_state = "flashbang"
	item_state = "syringe_kit"

/obj/item/weapon/storage/gl_kit
	name = "Prescription Glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
	item_state = "syringe_kit"

/obj/item/weapon/storage/handcuff_kit
	name = "Spare Handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"
	item_state = "syringe_kit"

/obj/item/weapon/storage/id_kit
	name = "Spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"
	item_state = "syringe_kit"

/obj/item/weapon/storage/lglo_kit
	name = "Latex Gloves"
	desc = "Contains white gloves."
	icon_state = "latex"
	item_state = "syringe_kit"

/obj/item/weapon/storage/injectbox
	name = "DNA-Injectors"
	desc = "This box contains injectors it seems."
	icon_state = "box"
	item_state = "syringe_kit"

/obj/item/weapon/storage/stma_kit
	name = "Sterile Masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterilemask"
	item_state = "syringe_kit"

/obj/item/weapon/storage/acma_kit
	name = "Acidproof Masks"
	desc = "This box seems to contain acidproof masks."
	icon_state = "sterilemask"
	item_state = "syringe_kit"

/obj/item/weapon/storage/trackimp_kit
	name = "Tracking Implant Kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/chemimp_kit
	name = "Chemical Implant Kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	origin_tech = "combat=1"

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

/obj/item/weapon/storage/toolbox/syndicate
	name = "Suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = "combat=1;syndicate=1"
	force = 7.0

/obj/item/weapon/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	var/mob/affecting = null
	var/deity_name = "Christ"

/obj/item/weapon/storage/bible/booze
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"

/obj/item/weapon/storage/mousetraps
	name = "Pest-B-Gon Mousetraps"
	desc = "WARNING: Keep out of reach of children."
	icon_state = "mousetraps"
	item_state = "syringe_kit"

/obj/item/weapon/storage/donkpocket_kit
	name = "Donk-Pockets"
	desc = "Remember to fully heat prior to serving.  Product will cool if not eaten within seven minutes."
	icon_state = "donk_kit"
	item_state = "syringe_kit"

/obj/item/weapon/storage/condimentbottles
	name = "Condiment Bottles"
	desc = "A box of empty condiment bottles."
	icon_state = "box"
	item_state = "syringe_kit"
