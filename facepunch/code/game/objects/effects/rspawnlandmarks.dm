//Lets cut down on powergaming k? Also dynamic shit


/obj/effect/landmark/rspawn/New() //rspawn spawner, selects a random subclass and disappears
	if(prob(15))
		var/list/options = typesof(/obj/effect/landmark/rspawn)
		var/PICK= options[rand(1,options.len)]
		new PICK(src.loc)
		del(src)
	else
		del(src)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/rspawn/coin/New()
	new /obj/item/weapon/coin/silver(src.loc)
	del(src)

/obj/effect/landmark/rspawn/bhh/New()
	new /obj/item/clothing/head/hardhat/dblue(src.loc)
	del(src)

/obj/effect/landmark/rspawn/doubletrouble/New()
	new /obj/item/weapon/tank/emergency_oxygen/double
	del(src)

/obj/effect/landmark/rspawn/lampitem/New()
	new /obj/item/device/flashlight/lamp(src.loc)
	del(src)

/obj/effect/landmark/rspawn/fanyassistant/New()
	new /obj/item/clothing/under/rank/vice(src.loc)
	del(src)

/obj/effect/landmark/rspawn/syndicatetrash/New()
	new /obj/item/trash/syndi_cakes(src.loc)
	del(src)

/obj/effect/landmark/rspawn/mechan/New()
	new /obj/item/weapon/storage/toolbox/mechanical(src.loc)
	del(src)

/obj/effect/landmark/rspawn/emerg/New()
	new /obj/item/weapon/storage/toolbox/emergency(src.loc)
	del(src)

/obj/effect/landmark/rspawn/elect/New()
	new /obj/item/weapon/storage/toolbox/electrical(src.loc)
	del(src)

/obj/effect/landmark/rspawn/soppaper/New()
	new /obj/item/weapon/paper/sop(src.loc)
	del(src)

/obj/effect/landmark/rspawn/rcrowbar/New()
	new /obj/item/weapon/crowbar(src.loc)
	del(src)

/obj/effect/landmark/rspawn/multitool/New()
	new /obj/item/device/multitool(src.loc)
	del(src)

/obj/effect/landmark/rspawn/bible/New()
	new /obj/item/weapon/storage/bible(src.loc)
	del(src)

/obj/effect/landmark/rspawn/koffee/New()
	new /obj/item/weapon/reagent_containers/food/drinks/coffee(src.loc)
	del(src)
//
/obj/effect/landmark/rspawn/buckit/New()
	new /obj/item/weapon/reagent_containers/glass/bucket(src.loc)
	del(src)

/obj/effect/landmark/rspawn/dohnutbox/New()
	new /obj/item/weapon/storage/fancy/donut_box(src.loc)
	del(src)

/obj/effect/landmark/rspawn/pj/New()
	new /obj/item/clothing/under/pj/blue(src.loc)
	del(src)


/obj/effect/landmark/rspawn/soap/New()
	new /obj/item/weapon/soap(src.loc)
	del(src)

/obj/effect/landmark/rspawn/satchewal/New()
	new /obj/item/weapon/storage/backpack/satchel/withwallet(src.loc)
	del(src)

/obj/effect/landmark/rspawn/satchel/New()
	new /obj/item/weapon/storage/backpack/satchel(src.loc)
	del(src)

/obj/effect/landmark/rspawn/lighter/New()
	new /obj/item/weapon/lighter/random(src.loc)
	del(src)

/obj/effect/landmark/rspawn/assx/New()
	new /obj/item/weapon/reagent_containers/pill/inspectionitesplacebo(src.loc)
	del(src)

/obj/effect/landmark/rspawn/stoxin2/New()
	new /obj/item/weapon/reagent_containers/pill/stoxin2(src.loc)
	del(src)

/obj/effect/landmark/rspawn/cap/New()
	new /obj/item/clothing/head/collectable/flatcap(src.loc)
	del(src)

/obj/effect/landmark/rspawn/phat/New()
	new /obj/item/clothing/head/collectable/paper(src.loc)
	del(src)

/obj/effect/landmark/rspawn/blueshoe/New()
	new /obj/item/clothing/shoes/blue(src.loc)
	del(src)

/obj/effect/landmark/rspawn/emptymag/New()
	new /obj/item/ammo_magazine/a762/empty(src.loc)
	del(src)

/obj/effect/landmark/rspawn/oxygen/New()
	new /obj/item/weapon/tank/emergency_oxygen(src.loc)
	del(src)

/obj/effect/landmark/rspawn/bb/New()
	new /obj/item/weapon/broken_bottle(src.loc)
	del(src)

/obj/effect/landmark/rspawn/exting/New()
	new /obj/item/weapon/extinguisher/mini(src.loc)
	del(src)

/obj/effect/landmark/rspawn/weld/New()
	new /obj/item/weapon/weldingtool/largetank(src.loc)
	del(src)

/obj/effect/landmark/rspawn/smoke/New()
	new /obj/item/weapon/grenade/smokebomb(src.loc)
	del(src)

/obj/effect/landmark/rspawn/food/New()
	var/list/options = typesof(/obj/item/weapon/reagent_containers/food)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	del(src)

/obj/effect/landmark/rspawn/books/New()
	var/list/options = typesof(/obj/item/weapon/book/manual)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	del(src)

/obj/effect/landmark/rspawn/circuit/New()
	var/list/options = typesof(/obj/item/weapon/circuitboard)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	del(src)


/obj/effect/landmark/rspawn/dosh/New()
	var/list/options = typesof(/obj/item/weapon/spacecash)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	del(src)
/obj/effect/landmark/rspawn/boxes/New()
	var/list/options = typesof(/obj/item/weapon/storage/box)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	del(src)


/obj/effect/landmark/rspawn/weld/New()
	var/list/options = typesof(/obj/item/weapon/weldingtool)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	del(src)
