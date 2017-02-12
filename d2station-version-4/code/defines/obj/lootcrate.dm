/obj/crate/loot
	desc = "What could be inside?"
	name = "Abandoned Crate"
	icon_state = "securecrate"
	openicon = "securecrateopen"
	closedicon = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/code = null
	var/lastattempt = null
	var/attempts = 3
	locked = 1

	New()
		..()
		src.code = rand(1,10)
		overlays = null
		overlays += redlight
		var/loot = rand(1,22)
		switch(loot)
			if(1)
				new/obj/item/weapon/reagent_containers/food/drinks/bottle/rum(src)
				new/obj/item/weapon/reagent_containers/food/drinks/bottle/rum(src)
				new/obj/item/weapon/reagent_containers/food/drinks/bottle/rum(src)
				new/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla(src)
				new/obj/item/weapon/reagent_containers/food/snacks/grown/cannabisleaf(src)
				new/obj/item/weapon/reagent_containers/food/snacks/grown/cannabisleaf(src)
				new/obj/item/weapon/reagent_containers/food/snacks/grown/cannabisleaf(src)
			if(2)
				new/obj/item/weapon/storage/pill_bottle/antitox(src)
				new/obj/item/weapon/storage/pill_bottle/antitox(src)
				new/obj/item/weapon/storage/pill_bottle/inaprovaline(src)
				new/obj/item/weapon/storage/pill_bottle/kelotane(src)
				new/obj/item/weapon/storage/pill_bottle/orlistat(src)
				new/obj/item/weapon/storage/pill_bottle/sildenafil(src)
			if(3)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox/tubes(src)

			if(4)
				new/obj/item/weapon/zippo(src)

			if(5)
				new/obj/item/weapon/cell/crap(src)
				new/obj/item/weapon/cell/crap(src)
				new/obj/item/weapon/cell/crap(src)
				new/obj/item/weapon/cell/crap(src)
				new/obj/item/weapon/cell/crap(src)
				new/obj/item/weapon/cell/crap(src)
				new/obj/item/weapon/cell/crap(src)
			if(6)
				new/obj/item/clothing/shoes/jackboots(src)
			if(7)
				new/obj/item/clothing/mask/gas/voice(src)
			if(8)
				new/obj/item/weapon/reagent_containers/hypospray(src)
			if(9)
				new/obj/item/weapon/reagent_containers/pill/polyadrenalobin(src)
				new/obj/item/clothing/glasses/hud/telepathic(src)
				new/obj/item/clothing/glasses/hud/telepathic(src)
				new/obj/item/clothing/glasses/hud/telepathic(src)
			if(10)
				new/obj/item/weapon/storage/backpack/security(src)
			if(11)
				new/obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new/obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new/obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new/obj/item/weapon/reagent_containers/food/drinks/milk(src)
				new/obj/item/weapon/reagent_containers/food/drinks/milk(src)
				new/obj/item/weapon/reagent_containers/food/drinks/milk(src)
				new/obj/item/kitchen/egg_box(src)
				new/obj/item/kitchen/egg_box(src)
				new/obj/item/kitchen/egg_box(src)

			if(12)
				new/obj/item/clothing/head/helmet(src)
			if(13)
				new/obj/item/clothing/suit/armor/riot(src)
			if(14)
				new/obj/item/weapon/gun/energy/laser(src)
			if(15)
				new/obj/item/clothing/gloves/yellow(src)
			if(16)
				new/obj/item/weapon/storage/toolbox/electrical(src)
			if(17)
				new/obj/item/stack/sheet/metal(src)
			if(18)
				new/obj/item/weapon/storage/firstaid/regular(src)
				new/obj/item/weapon/storage/firstaid/fire(src)
				new/obj/item/weapon/storage/firstaid/toxin(src)
				new/obj/item/weapon/storage/firstaid/o2(src)
				new/obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
				new/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
				new/obj/item/weapon/reagent_containers/glass/bottle/stoxin(src)
				new/obj/item/weapon/storage/syringes(src)
			if(19)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox/tubes(src)
				new/obj/item/weapon/storage/lightbox(src)
				new/obj/item/weapon/storage/lightbox(src)
				new/obj/item/weapon/storage/lightbox(src)
			if(20)
				new/obj/item/weapon/cloaking_device(src)
				new/obj/item/weapon/cloaking_device(src)
			if(21)
				new/obj/machinery/bot/floorbot(src)
				new/obj/machinery/bot/floorbot(src)
				new/obj/machinery/bot/medbot(src)
				new/obj/machinery/bot/medbot(src)
				new/obj/item/weapon/tank/air(src)
				new/obj/item/weapon/tank/air(src)
				new/obj/item/weapon/tank/air(src)
				new/obj/item/weapon/tank/air(src)
				new/obj/item/clothing/mask/gas(src)
				new/obj/item/clothing/mask/gas(src)
				new/obj/item/clothing/mask/gas(src)
				new/obj/item/clothing/mask/gas(src)
			if(22)
				new /obj/critter/lizzzard(src)
				new /obj/critter/lizard(src)
				new /obj/critter/slipperydick(src)
				new /obj/critter/roach(src)
				new /obj/livestock/spessbee(src)


	attack_hand(mob/user as mob)
		if(locked)
			user << "\blue The crate is locked with a deca-code lock."
			var/input = input(usr, "Enter digit from 1 to 10.", "Deca-Code Lock", "") as num
			if (input == src.code)
				user << "\blue The crate unlocks!"
				overlays = null
				overlays += greenlight
				src.locked = 0
			else if (input == null || input > 10 || input < 1) user << "You leave the crate alone."
			else
				user << "\red A red light flashes."
				src.lastattempt = input
				src.attempts--
				if (src.attempts == 0)
					user << "\red The crate's anti-tamper system activates!"
					var/turf/T = get_turf(src.loc)
					explosion(T, -1, -1, 1, 1)
					del src
					return
		else return ..()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(locked)
			if (istype(W, /obj/item/weapon/card/emag))
				user << "\blue The crate unlocks!"
				overlays = null
				overlays += greenlight
				src.locked = 0
			if (istype(W, /obj/item/device/multitool))
				user << "DECA-CODE LOCK REPORT:"
				if (src.attempts == 1) user << "\red * Anti-Tamper Bomb will activate on next failed access attempt."
				else user << "* Anti-Tamper Bomb will activate after [src.attempts] failed access attempts."
				if (lastattempt == null)
					user << "* No attempt has been made to open the crate thus far."
					return
				// hot and cold
				if (src.code > src.lastattempt) user << "* Last access attempt lower than expected code."
				else user << "* Last access attempt higher than expected code."
			else ..()
		else ..()