/obj/storage/crate
	name = "crate"
	desc = "A small, cuboid object with a hinged top and empty interior."
	is_short = 1
	icon_state = "crate"
	icon_closed = "crate"
	icon_opened = "crateopen"
	icon_welded = "welded-crate"
	soundproofing = 3
	throwforce = 50 //ouch
	can_flip_bust = 1

/obj/storage/crate/internals
	name = "internals crate"
	desc = "An internals crate."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/storage/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "medicalcrate"
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/storage/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate for the storage of the RCD."
	spawn_contents = list(/obj/item/rcd_ammo = 5,
	/obj/item/rcd)

/obj/storage/crate/abcumarker
	name = "\improper ABCU-Marker crate"
	desc = "A crate for ABCU marker devices."
	spawn_contents = list(/obj/item/blueprint_marker = 5)

/obj/storage/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	icon_opened = "freezeropen"
	icon_closed = "freezer"

/obj/storage/crate/biohazard
	name = "biohazard crate"
	desc = "A crate for biohazardous materials."
	icon_state = "biohazardcrate"
	icon_opened = "biohazardcrateopen"
	icon_closed = "biohazardcrate"

	cdc
		name = "CDC pathogen sample crate"
		desc = "A crate for sending pathogen or blood samples to the CDC for analysis."

/obj/storage/crate/freezer/milk
	spawn_contents = list(/obj/item/reagent_containers/food/drinks/milk = 10, \
	/obj/item/gun/russianrevolver)

/obj/storage/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/storage/crate/bin/lostandfound
	name = "\improper Lost and Found bin"
	desc = "Theoretically, items that are lost by a person are placed here so that the person may come and find them. This never happens."
	spawn_contents = list(/obj/item/gnomechompski)

/obj/storage/crate/adventure
	name = "adventure crate"
	desc = "Only distantly related to the adventure closet."
	spawn_contents = list(/obj/item/device/radio/headset/multifreq = 4,
	/obj/item/device/audio_log = 2,
	/obj/item/audio_tape = 4,
	/obj/item/camera_test = 2,
	/obj/item/device/flashlight = 2,
	/obj/item/paper/book/critter_compendium,
	/obj/item/reagent_containers/food/drinks/milk,
	/obj/item/reagent_containers/food/snacks/sandwich/pb,
	/obj/item/paper/note_from_mom)

/obj/storage/crate/materials
	name = "building materials crate"
	spawn_contents = list(/obj/item/sheet/steel/fullstack,
	/obj/item/sheet/glass/fullstack)

/obj/storage/crate/furnacefuel
	name = "furnace fuel crate"
	desc = "A crate with fuel for a furnace."
	spawn_contents = list(/obj/item/raw_material/char = 30)

/obj/storage/crate/robotics_supplies
	name = "robotics supplies crate"
	desc = "A crate containing supplies for Robotics."
	spawn_contents = list(/obj/item/sheet/steel/fullstack = 3,
	/obj/item/sheet/glass/fullstack,
	/obj/item/cell/supercell = 4,
	/obj/item/cable_coil = 2)

/obj/storage/crate/robotics_supplies_borg
	name = "robotics supplies crate"
	desc = "A crate containing supplies for Robotics and an extra set of cyborg parts."
	spawn_contents = list(/obj/item/sheet/steel/fullstack = 3,
	/obj/item/sheet/glass/fullstack,
	/obj/item/ai_interface,
	/obj/item/parts/robot_parts/robot_frame,
	/obj/item/parts/robot_parts/leg/left,
	/obj/item/parts/robot_parts/leg/right,
	/obj/item/parts/robot_parts/arm/left,
	/obj/item/parts/robot_parts/arm/right,
	/obj/item/parts/robot_parts/chest,
	/obj/item/parts/robot_parts/head,
	/obj/item/cell/supercell = 4,
	/obj/item/cable_coil = 2)

/obj/storage/crate/clown
	desc = "A small, cuboid object with a hinged top and empty interior. It looks a little funny."
	spawn_contents = list(/obj/item/clothing/under/misc/clown/fancy,
	/obj/item/clothing/under/misc/clown,
	/obj/item/clothing/shoes/clown_shoes,
	/obj/item/clothing/mask/clown_hat,
	/obj/item/storage/box/balloonbox)

/obj/storage/crate/materials
	name = "building materials crate"
	spawn_contents = list(/obj/item/sheet/steel/fullstack,
	/obj/item/sheet/glass/fullstack)

/*
 *	SPOOKY haunted crate!
 */

/obj/storage/crate/haunted
	icon = 'icons/misc/halloween.dmi'
	icon_state = "crate"
	var/triggered = 0

	make_my_stuff()
		..()
		if(prob(60))
			new /obj/critter/spirit( src )

	open()
		..()
		if(!triggered)
			triggered = 1
			gibs(src.loc)
			return

/obj/storage/crate/syndicate_surplus
	var/ready = 0
	New()
		spawn(20)
			if (!ready)
				spawn_items()

	proc/spawn_items(var/mob/owner)
		ready = 1
		var/telecrystals = 0
		var/list/possible_items = list()

		if (islist(syndi_buylist_cache))
			for (var/datum/syndicate_buylist/S in syndi_buylist_cache)
				var/blocked = 0
				if (ticker && ticker.mode && S.blockedmode && islist(S.blockedmode) && S.blockedmode.len)
					for (var/V in S.blockedmode)
						if (ispath(V) && istype(ticker.mode, V))
							blocked = 1
							break

				if (blocked == 0 && !S.not_in_crates)
					possible_items += S

		if (islist(possible_items) && possible_items.len)
			while(telecrystals < 18)
				var/datum/syndicate_buylist/item_datum = pick(possible_items)
				if(telecrystals + item_datum.cost > 24) continue
				var/obj/item/I = new item_datum.item(src)
				if (owner)
					item_datum.run_on_spawn(I, owner)
					if (owner.mind)
						owner.mind.traitor_crate_items += item_datum
				telecrystals += item_datum.cost
