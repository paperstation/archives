/datum/job/
	var/name = null
	var/initial_name = null
	var/linkcolor = "#000000"
	var/wages = 0
	var/limit = -1
	var/no_late_join = 0
	var/no_jobban_from_this_job = 0
	var/allow_traitors = 1
	var/cant_spawn_as_rev = 0 // For the revoltion game mode. See jobprocs.dm for notes etc (Convair880).
	var/requires_whitelist = 0
	var/assigned = 0
	var/high_priority_job = 0
	var/low_priority_job = 0
	var/cant_allocate_unwanted = 0
	var/recieves_miranda = 0
	var/announce_on_join = 0
	var/list/alt_names = list()
	var/slot_head = null
	var/slot_mask = null
	//var/slot_ears = null // swapping this back for now
	var/slot_ears = /obj/item/device/radio/headset // cogwerks experiment - removing default headsets
	var/slot_eyes = null
	var/slot_suit = null
	var/slot_jump = null
	var/slot_card = /obj/item/card/id
	var/slot_glov = null
	var/slot_foot = null
	var/slot_back = /obj/item/storage/backpack
	var/slot_belt = /obj/item/device/pda2
	var/slot_poc1 = null // Pay attention to size. Not everything is small enough to fit in jumpsuit pockets.
	var/slot_poc2 = null
	var/slot_lhan = null
	var/slot_rhan = null
	var/list/items_in_backpack = list() // stop giving everyone a free airtank gosh
	var/list/items_in_belt = list() // works the same as above but is for jobs that spawn with a belt that can hold things
	var/list/access = list(access_fuck_all) // Please define in global get_access() proc (access.dm), so it can also be used by bots etc.
	var/mob/living/mob_type = /mob/living/carbon/human

	var/change_name_on_spawn = 0

	New()
		..()
		initial_name = name

	proc/special_setup(var/mob/living/carbon/human/M)
		if (!M)
			return
		if (recieves_miranda)
			M.verbs += /mob/proc/recite_miranda
			M.verbs += /mob/proc/add_miranda
			if (!isnull(M.mind))
				M.mind.miranda = "You have the right to remain silent. Anything you say can and will be used against you in a NanoTrasen court of Space Law. You have the right to a rent-an-attorney. If you cannot afford one, a monkey in a suit and funny hat will be appointed to you."
		if (src.change_name_on_spawn)
			spawn(0)
				M.choose_name(3, src.name, M.real_name + " the " + src.name)

// Command Jobs

/datum/job/command
	linkcolor = "#00CC00"
	slot_card = /obj/item/card/id/command

/datum/job/command/captain
	name = "Captain"
	limit = 1
	wages = 1000
	high_priority_job = 1
	recieves_miranda = 1
	cant_spawn_as_rev = 1
	announce_on_join = 1
	slot_card = /obj/item/card/id/gold
	slot_belt = /obj/item/device/pda2/captain
	slot_jump = /obj/item/clothing/under/rank/captain
	slot_suit = /obj/item/clothing/suit/armor/captain
	slot_foot = /obj/item/clothing/shoes/swat
	slot_head = /obj/item/clothing/head/caphat
	slot_eyes = /obj/item/clothing/glasses/sunglasses
	slot_ears = /obj/item/device/radio/headset/command/captain
	slot_poc1 = /obj/item/disk/data/floppy/read_only/authentication

	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/box/id_kit,/obj/item/device/flash)

	New()
		..()
		src.access = get_all_accesses()

	derelict
		//name = "NT-SO Commander"
		name = null
		limit = 0
		slot_suit = /obj/item/clothing/suit/armor/centcomm
		slot_jump = /obj/item/clothing/under/misc/turds
		slot_head = /obj/item/clothing/head/centhat
		slot_belt = /obj/item/tank/emergency_oxygen
		slot_glov = /obj/item/clothing/gloves/fingerless
		slot_back = /obj/item/storage/backpack/NT
		slot_mask = /obj/item/clothing/mask/gas
		slot_eyes = /obj/item/clothing/glasses/thermal
		items_in_backpack = list(/obj/item/crowbar,/obj/item/device/flashlight,/obj/item/camera_test,/obj/item/gun/energy/egun)

		special_setup(var/mob/living/carbon/human/M)
			..()
			if (!M)
				return
			M.show_text("<b>Something has gone terribly wrong here! Search for survivors and escape together.</b>", "blue")

/datum/job/command/head_of_personnel
	name = "Head of Personnel"
	limit = 1
	wages = 750
	recieves_miranda = 1
	cant_spawn_as_rev = 1
#ifdef MAP_OVERRIDE_DESTINY
	announce_on_join = 1
#endif
	slot_belt = /obj/item/device/pda2/heads
	slot_jump = /obj/item/clothing/under/suit/hop
	slot_foot = /obj/item/clothing/shoes/brown
	slot_ears = /obj/item/device/radio/headset/command/hop
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/box/id_kit,/obj/item/device/flash)

	New()
		..()
		src.access = get_access("Head of Personnel")
		return

/datum/job/command/head_of_security
	name = "Head of Security"
	limit = 1
	wages = 750
	requires_whitelist = 1
	recieves_miranda = 1
	allow_traitors = 0
	cant_spawn_as_rev = 1
#ifdef MAP_OVERRIDE_DESTINY
	announce_on_join = 1
#endif
	slot_belt = /obj/item/gun/energy/taser_gun
	slot_poc1 = /obj/item/device/pda2/hos
	slot_jump = /obj/item/clothing/under/rank/head_of_securityold
	slot_suit = /obj/item/clothing/suit/armor/vest
	slot_foot = /obj/item/clothing/shoes/brown
	slot_head = /obj/item/clothing/head/helmet/HoS
	slot_ears = /obj/item/device/radio/headset/command/hos
	slot_eyes = /obj/item/clothing/glasses/sunglasses
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/box/security_starter_kit) // Don't make them spawn with a full backpack again, please.

	New()
		..()
		src.access = get_access("Head of Security")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("resist_alcohol")

	derelict
		name = null//"NT-SO Special Operative"
		limit = 0
		slot_suit = /obj/item/clothing/suit/armor/NT
		slot_jump = /obj/item/clothing/under/misc/turds
		slot_head = /obj/item/clothing/head/NTberet
		slot_belt = /obj/item/tank/emergency_oxygen
		slot_mask = /obj/item/clothing/mask/gas
		slot_glov = /obj/item/clothing/gloves/latex
		slot_back = /obj/item/storage/backpack/NT
		slot_eyes = /obj/item/clothing/glasses/thermal
		items_in_backpack = list(/obj/item/crowbar,/obj/item/device/flashlight,/obj/item/breaching_charge,/obj/item/breaching_charge,/obj/item/gun/energy/laser_gun/pred)

		special_setup(var/mob/living/carbon/human/M)
			..()
			if (!M)
				return
			M.show_text("<b>Something has gone terribly wrong here! Search for survivors and escape together.</b>", "blue")

/datum/job/command/chief_engineer
	name = "Chief Engineer"
	limit = 1
	wages = 750
	cant_spawn_as_rev = 1
#ifdef MAP_OVERRIDE_DESTINY
	announce_on_join = 1
#endif
	slot_belt = /obj/item/device/pda2/heads
	slot_glov = /obj/item/clothing/gloves/yellow
	slot_foot = /obj/item/clothing/shoes/brown
	slot_head = /obj/item/clothing/head/helmet/hardhat
	slot_eyes = /obj/item/clothing/glasses/meson
	slot_jump = /obj/item/clothing/under/rank/chief_engineer
	slot_ears = /obj/item/device/radio/headset/command/ce
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/device/flash)

	New()
		..()
		src.access = get_access("Chief Engineer")
		return

	derelict
		name = null//"Salvage Chief"
		limit = 0
		slot_suit = /obj/item/clothing/suit/space/industrial
		slot_foot = /obj/item/clothing/shoes/magnetic
		slot_head = /obj/item/clothing/head/helmet/space/industrial
		slot_belt = /obj/item/tank/emergency_oxygen
		slot_mask = /obj/item/clothing/mask/gas
		slot_eyes = /obj/item/clothing/glasses/thermal // mesons look fuckin weird in the dark
		items_in_backpack = list(/obj/item/crowbar,/obj/item/rcd,/obj/item/rcd_ammo,/obj/item/rcd_ammo,/obj/item/device/flashlight,/obj/item/cell/cerenkite)

		special_setup(var/mob/living/carbon/human/M)
			..()
			if (!M)
				return
			M.show_text("<b>Something has gone terribly wrong here! Search for survivors and escape together.</b>", "blue")

/datum/job/command/research_director
	name = "Research Director"
	limit = 1
	wages = 750
	cant_spawn_as_rev = 1
#ifdef MAP_OVERRIDE_DESTINY
	announce_on_join = 1
#endif
	slot_belt = /obj/item/device/pda2/research_director
	slot_foot = /obj/item/clothing/shoes/brown
	slot_jump = /obj/item/clothing/under/rank/research_director
	slot_suit = /obj/item/clothing/suit/labcoat
	slot_rhan = /obj/item/clipboard/with_pen
	slot_eyes = /obj/item/clothing/glasses/spectro
	slot_ears = /obj/item/device/radio/headset/command/rd
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/device/flash)

	New()
		..()
		src.access = get_access("Research Director")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return

		var/obj/critter/domestic_bee/heisenbee/heisenbee = locate() in range(M, 7)
		if (istype(heisenbee) && !heisenbee.beeMom)
			heisenbee.beeMom = M
			heisenbee.beeMomCkey = M.ckey

/datum/job/command/medical_director
	name = "Medical Director"
	limit = 1
	wages = 750
	cant_spawn_as_rev = 1
#ifdef MAP_OVERRIDE_DESTINY
	announce_on_join = 1
#endif
	slot_belt = /obj/item/device/pda2/medical_director
	slot_foot = /obj/item/clothing/shoes/brown
	slot_jump = /obj/item/clothing/under/rank/medical_director
	slot_suit = /obj/item/clothing/suit/labcoat
	slot_ears = /obj/item/device/radio/headset/command/md
	slot_eyes = /obj/item/clothing/glasses/healthgoggles/upgraded
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/device/flash)

	New()
		..()
		src.access = get_access("Medical Director")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_medical")

// Security Jobs

/datum/job/security
	linkcolor = "#FF0000"
	slot_card = /obj/item/card/id/security
	recieves_miranda = 1

/datum/job/security/security_officer
	name = "Security Officer"
	limit = 5
	wages = 250
	allow_traitors = 0
	cant_spawn_as_rev = 1
	slot_belt = /obj/item/device/pda2/security
	slot_jump = /obj/item/clothing/under/rank/security
	slot_suit = /obj/item/clothing/suit/armor/vest
	slot_head = /obj/item/clothing/head/helmet
	slot_foot = /obj/item/clothing/shoes/brown
	slot_ears =  /obj/item/device/radio/headset/security
	slot_eyes = /obj/item/clothing/glasses/sunglasses
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/box/security_starter_kit) // Don't make them spawn with a full backpack again, please.

	New()
		..()
		src.access = get_access("Security Officer")
		return

	derelict
		//name = "NT-SO Officer"
		name = null
		limit = 0
		slot_suit = /obj/item/clothing/suit/armor/NT_alt
		slot_jump = /obj/item/clothing/under/misc/turds
		slot_head = /obj/item/clothing/head/helmet/swat
		slot_glov = /obj/item/clothing/gloves/fingerless
		slot_back = /obj/item/storage/backpack/NT
		slot_belt = /obj/item/gun/energy/laser_gun
		slot_eyes = /obj/item/clothing/glasses/sunglasses
		items_in_backpack = list(/obj/item/crowbar,/obj/item/device/flashlight,/obj/item/baton,/obj/item/breaching_charge,/obj/item/breaching_charge)

		special_setup(var/mob/living/carbon/human/M)
			..()
			if (!M)
				return
			M.show_text("<b>Something has gone terribly wrong here! Search for survivors and escape together.</b>", "blue")

/datum/job/security/detective
	name = "Detective"
	limit = 1
	wages = 300
	//allow_traitors = 0
	cant_spawn_as_rev = 1
	slot_belt = /obj/item/device/pda2/forensic
	slot_jump = /obj/item/clothing/under/rank/det
	slot_foot = /obj/item/clothing/shoes/detective
	slot_head = /obj/item/clothing/head/det_hat
	slot_glov = /obj/item/clothing/gloves/black
	slot_suit = /obj/item/clothing/suit/det_suit
	slot_poc1 = /obj/item/zippo
	slot_ears = /obj/item/device/radio/headset/security
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/clothing/glasses/vr)

	New()
		..()
		src.access = get_access("Detective")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("resist_alcohol")

// Research Jobs

/datum/job/research
	linkcolor = "#9900FF"
	slot_card = /obj/item/card/id/research

/datum/job/research/geneticist
	name = "Geneticist"
	limit = 2
	wages = 400
	slot_belt = /obj/item/device/pda2/genetics
	slot_jump = /obj/item/clothing/under/rank/geneticist
	slot_foot = /obj/item/clothing/shoes/white
	slot_suit = /obj/item/clothing/suit/labcoat/genetics
	slot_ears = /obj/item/device/radio/headset/medical

	New()
		..()
		src.access = get_access("Geneticist")
		return

/datum/job/research/roboticist
	name = "Roboticist"
	limit = 2
	wages = 400
	slot_belt = /obj/item/device/pda2/medical/robotics
	slot_jump = /obj/item/clothing/under/rank/roboticist
	slot_foot = /obj/item/clothing/shoes/black
	slot_suit = /obj/item/clothing/suit/labcoat/robotics
	slot_glov = /obj/item/clothing/gloves/latex
	slot_lhan = /obj/item/storage/toolbox/mechanical
	slot_ears = /obj/item/device/radio/headset/medical
	items_in_backpack = list(/obj/item/crowbar)

	New()
		..()
		src.access = get_access("Roboticist")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_medical")

/datum/job/research/scientist
	name = "Scientist"
	limit = 5
	wages = 400
	slot_belt = /obj/item/device/pda2/toxins
	slot_jump = /obj/item/clothing/under/rank/scientist
	slot_suit = /obj/item/clothing/suit/labcoat
	slot_foot = /obj/item/clothing/shoes/white
	slot_mask = /obj/item/clothing/mask/gas
	slot_lhan = /obj/item/tank/air
	slot_ears = /obj/item/device/radio/headset/research
	slot_eyes = /obj/item/clothing/glasses/spectro

	New()
		..()
		src.access = get_access("Scientist")
		return

/datum/job/research/medical_doctor
	name = "Medical Doctor"
	limit = 5
	wages = 400
	slot_back = /obj/item/storage/backpack/medic
	slot_belt = /obj/item/device/pda2/medical
	slot_jump = /obj/item/clothing/under/rank/medical
	slot_suit = /obj/item/clothing/suit/labcoat
	slot_foot = /obj/item/clothing/shoes/red
	slot_lhan = /obj/item/storage/firstaid/regular/doctor_spawn
	slot_ears = /obj/item/device/radio/headset/medical
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/crowbar) // cogwerks: giving medics a guaranteed air tank, stealing it from roboticists (those fucks)

	New()
		..()
		src.access = get_access("Medical Doctor")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_medical")

	derelict
		//name = "Salvage Medic"
		name = null
		limit = 0
		slot_suit = /obj/item/clothing/suit/armor/vest
		slot_head = /obj/item/clothing/head/helmet/swat
		slot_belt = /obj/item/tank/emergency_oxygen
		slot_mask = /obj/item/clothing/mask/breath
		slot_eyes = /obj/item/clothing/glasses/healthgoggles
		slot_glov = /obj/item/clothing/gloves/latex
		items_in_backpack = list(/obj/item/crowbar,/obj/item/device/flashlight,/obj/item/storage/firstaid/regular,/obj/item/storage/firstaid/regular)

		special_setup(var/mob/living/carbon/human/M)
			..()
			if (!M) return
			M.show_text("<b>Something has gone terribly wrong here! Search for survivors and escape together.</b>", "blue")

// Engineering Jobs

/datum/job/engineering
	linkcolor = "#FF9900"
	slot_card = /obj/item/card/id/engineering

/datum/job/engineering/construction_worker
	name = "Construction Worker"
	allow_traitors = 0
	cant_spawn_as_rev = 1
	limit = 0
	wages = 0
	slot_belt = /obj/item/storage/belt/utility/prepared
	slot_jump = /obj/item/clothing/under/rank/engineer
	slot_foot = /obj/item/clothing/shoes/magnetic
	slot_glov = /obj/item/clothing/gloves/black
	slot_ears = /obj/item/device/radio/headset/engineer
	slot_rhan = /obj/item/tank/jetpack
	slot_eyes = /obj/item/clothing/glasses/construction
	slot_poc1 = /obj/item/room_marker
	slot_poc2 = /obj/item/room_planner
	slot_suit = /obj/item/clothing/suit/space/engineer
	slot_head = /obj/item/clothing/head/helmet/space/engineer
	slot_mask = /obj/item/clothing/mask/breath
	items_in_backpack = list(/obj/item/tank/emergency_oxygen, /obj/item/rcd/construction, /obj/item/rcd_ammo/big, /obj/item/rcd_ammo/big, /obj/item/material_shaper)

	New()
		..()
		src.access = get_access("Construction Worker")
		return


/datum/job/engineering/quartermaster
	name = "Quartermaster"
	limit = 3
	wages = 350
	slot_glov = /obj/item/clothing/gloves/black
	slot_foot = /obj/item/clothing/shoes/black
	slot_jump = /obj/item/clothing/under/rank/cargo
	slot_belt = /obj/item/device/pda2/quartermaster
	slot_ears = /obj/item/device/radio/headset/shipping

	New()
		..()
		src.access = get_access("Quartermaster")
		return

/datum/job/engineering/miner
	name = "Miner"
	limit = 3
	wages = 350
	slot_belt = /obj/item/device/pda2/mining
	slot_jump = /obj/item/clothing/under/rank/overalls
	slot_foot = /obj/item/clothing/shoes/orange
	slot_glov = /obj/item/clothing/gloves/black
	slot_ears = /obj/item/device/radio/headset/engineer
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/crowbar)

	New()
		..()
		src.access = get_access("Miner")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_miner")
		if (prob(20))
			M.bioHolder.AddEffect("dwarf") // heh

/datum/job/engineering/mechanic
	name = "Mechanic"
	limit = 2
	wages = 350

	slot_belt = /obj/item/device/pda2/mechanic
	slot_jump = /obj/item/clothing/under/rank/mechanic
	slot_foot = /obj/item/clothing/shoes/black
	slot_lhan = /obj/item/storage/toolbox/electrical/mechanic_spawn
	slot_glov = /obj/item/clothing/gloves/yellow
	slot_ears = /obj/item/device/radio/headset/engineer
	items_in_backpack = list(/obj/item/tank/emergency_oxygen)

	New()
		..()
		src.access = get_access("Mechanic")
		return

/datum/job/engineering/engineer
	name = "Engineer"
	limit = 3
	wages = 350
	slot_belt = /obj/item/device/pda2/engine
	slot_jump = /obj/item/clothing/under/rank/engineer
	slot_foot = /obj/item/clothing/shoes/orange
	slot_lhan = /obj/item/storage/toolbox/mechanical
	slot_glov = /obj/item/clothing/gloves/yellow
	slot_poc1 = /obj/item/device/t_scanner
	slot_ears = /obj/item/device/radio/headset/engineer
	items_in_backpack = list(/obj/item/tank/emergency_oxygen)

	New()
		..()
		src.access = get_access("Engineer")
		return

	derelict
		name = null//"Salvage Engineer"
		limit = 0
		slot_suit = /obj/item/clothing/suit/space/engineer
		slot_head = /obj/item/clothing/head/helmet/welding
		slot_belt = /obj/item/tank/emergency_oxygen
		slot_mask = /obj/item/clothing/mask/breath
		items_in_backpack = list(/obj/item/crowbar,/obj/item/device/flashlight,/obj/item/device/glowstick,/obj/item/gun/kinetic/flaregun,/obj/item/ammo/bullets/flare,/obj/item/cell/cerenkite)

		special_setup(var/mob/living/carbon/human/M)
			..()
			if (!M)
				return
			M.show_text("<b>Something has gone terribly wrong here! Search for survivors and escape together.</b>", "blue")

// Civilian Jobs

/datum/job/civilian
	linkcolor = "#0099FF"
	slot_card = /obj/item/card/id/civilian

/datum/job/civilian/chef
	name = "Chef"
	limit = 1
	wages = 200
	slot_belt = /obj/item/device/pda2/chef
	slot_jump = /obj/item/clothing/under/rank/chef
	slot_foot = /obj/item/clothing/shoes/chef
	slot_head = /obj/item/clothing/head/chefhat
	slot_suit = /obj/item/clothing/suit/chef
	slot_ears = /obj/item/device/radio/headset/civilian
	items_in_backpack = list(/obj/item/kitchen/rollingpin)

	New()
		..()
		src.access = get_access("Chef")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		if (prob(20))
			M.bioHolder.AddEffect("accent_swedish")

/datum/job/civilian/barman
	name = "Barman"
	limit = 1
	wages = 200
	slot_belt = /obj/item/device/pda2/barman
	slot_jump = /obj/item/clothing/under/rank/bartender
	slot_foot = /obj/item/clothing/shoes/black
	slot_suit = /obj/item/clothing/suit/armor/vest
	slot_ears = /obj/item/device/radio/headset/civilian
	items_in_backpack = list(/obj/item/gun/kinetic/riotgun)

	New()
		..()
		src.access = get_access("Barman")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("resist_alcohol")

/datum/job/civilian/botanist
	name = "Botanist"
	limit = 4
	wages = 200
	slot_belt = /obj/item/device/pda2/botanist
	slot_jump = /obj/item/clothing/under/rank/hydroponics
	slot_foot = /obj/item/clothing/shoes/brown
	slot_glov = /obj/item/clothing/gloves/black
	slot_ears = /obj/item/device/radio/headset/civilian

	New()
		..()
		src.access = get_access("Botanist")
		return

/datum/job/civilian/janitor
	name = "Janitor"
	limit = 1
	wages = 125
	slot_belt = /obj/item/device/pda2/janitor
	slot_jump = /obj/item/clothing/under/rank/janitor
	slot_foot = /obj/item/clothing/shoes/black
	slot_ears = /obj/item/device/radio/headset/civilian

	New()
		..()
		src.access = get_access("Janitor")
		return

/datum/job/civilian/chaplain
	name = "Chaplain"
	limit = 1
	wages = 100
	slot_jump = /obj/item/clothing/under/rank/chaplain
	slot_belt = /obj/item/device/pda2/chaplain
	slot_foot = /obj/item/clothing/shoes/black
	slot_ears = /obj/item/device/radio/headset/civilian

	New()
		..()
		src.access = get_access("Chaplain")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_chaplain")
		//M.verbs += /client/proc/sense_corruption
		//M.verbs += /client/proc/remove_corruption
		if (prob(15))
			M.see_invisible = 15

/datum/job/civilian/staff_assistant
	name = "Staff Assistant"
	wages = 50
	no_jobban_from_this_job = 1
	low_priority_job = 1
	cant_allocate_unwanted = 1
	slot_jump = /obj/item/clothing/under/rank
	slot_foot = /obj/item/clothing/shoes/black

	New()
		..()
		src.access = get_access("Staff Assistant")
		return

/datum/job/civilian/clown
	name = "Clown"
	wages = 1
	limit = 1
	linkcolor = "#FF99FF"
	slot_back = null
	slot_belt = /obj/item/storage/fanny/funny
	slot_mask = /obj/item/clothing/mask/clown_hat
	slot_jump = /obj/item/clothing/under/misc/clown
	slot_foot = /obj/item/clothing/shoes/clown_shoes
	slot_lhan = /obj/item/bikehorn
	slot_poc1 = /obj/item/device/pda2/clown
	slot_poc2 = /obj/item/reagent_containers/food/snacks/plant/banana
	slot_card = /obj/item/card/id/clown
	change_name_on_spawn = 1

	New()
		..()
		src.access = get_access("Clown")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("clumsy")
		if (prob(10))
			M.bioHolder.AddEffect("accent_comic")

// AI and Cyborgs

/datum/job/civilian/AI
	name = "AI"
	linkcolor = "#999999"
	limit = 1
	no_late_join = 1
	high_priority_job = 1
	allow_traitors = 0
	cant_spawn_as_rev = 1
	slot_ears = null
	slot_card = null
	slot_back = null
	slot_belt = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.AIize()

/datum/job/civilian/cyborg
	name = "Cyborg"
	linkcolor = "#999999"
	limit = 3
	no_late_join = 1
	allow_traitors = 0
	cant_spawn_as_rev = 1
	slot_ears = null
	slot_card = null
	slot_back = null
	slot_belt = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.Robotize_MK2()

// Special Cases

/datum/job/special/head_surgeon
	name = "Head Surgeon"
	linkcolor = "#00CC00"
	limit = 0
	wages = 750
	cant_spawn_as_rev = 1
	slot_card = /obj/item/card/id/command
	slot_belt = /obj/item/device/pda2/medical_director
	slot_foot = /obj/item/clothing/shoes/brown
	slot_jump = /obj/item/clothing/under/scrub/maroon
	slot_suit = /obj/item/clothing/suit/labcoat
	slot_ears = /obj/item/device/radio/headset/command/md
	slot_lhan = /obj/item/circular_saw
	slot_rhan = /obj/item/scalpel
	items_in_backpack = list(/obj/item/tank/emergency_oxygen)

	New()
		..()
		src.access = get_access("Head Surgeon")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_medical")

/datum/job/special/lawyer
	name = "Lawyer"
	linkcolor = "#FF0000"
	wages = 100
	limit = 0
	slot_jump = /obj/item/clothing/under/misc/lawyer
	slot_foot = /obj/item/clothing/shoes/black
	slot_lhan = /obj/item/storage/briefcase
	slot_ears = /obj/item/device/radio/headset/civilian

	New()
		..()
		src.access = get_access("Lawyer")
		return

/datum/job/special/vice_officer
	name = "Vice Officer"
	linkcolor = "#FF0000"
	limit = 0
	wages = 250
	allow_traitors = 0
	cant_spawn_as_rev = 1
	recieves_miranda = 1
	slot_belt = /obj/item/device/pda2/security
	slot_jump = /obj/item/clothing/under/misc/vice
	slot_foot = /obj/item/clothing/shoes/brown
	slot_ears =  /obj/item/device/radio/headset/security
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/box/security_starter_kit) // Don't make them spawn with a full backpack again, please.

	New()
		..()
		src.access = get_access("Vice Officer")
		return

/datum/job/special/forensic_technician
	name = "Forensic Technician"
	linkcolor = "#FF0000"
	limit = 0
	wages = 200
	cant_spawn_as_rev = 1
	slot_belt = /obj/item/device/pda2/security
	slot_jump = /obj/item/clothing/under/color/darkred
	slot_foot = /obj/item/clothing/shoes/black
	slot_glov = /obj/item/clothing/gloves/latex
	slot_ears = /obj/item/device/radio/headset/security
	slot_poc1 = /obj/item/device/detective_scanner
	items_in_backpack = list(/obj/item/tank/emergency_oxygen)

	New()
		..()
		src.access = get_access("Forensic Technician")
		return

/datum/job/special/toxins_researcher
	name = "Toxins Researcher"
	linkcolor = "#9900FF"
	limit = 0
	wages = 400
	slot_belt = /obj/item/device/pda2/toxins
	slot_jump = /obj/item/clothing/under/rank/scientist
	slot_foot = /obj/item/clothing/shoes/white
	slot_mask = /obj/item/clothing/mask/gas
	slot_lhan = /obj/item/tank/air
	slot_ears = /obj/item/device/radio/headset/research

	New()
		..()
		src.access = get_access("Toxins Researcher")
		return

/datum/job/special/chemist
	name = "Chemist"
	linkcolor = "#9900FF"
	limit = 0
	wages = 400
	slot_belt = /obj/item/device/pda2/toxins
	slot_jump = /obj/item/clothing/under/rank/scientist
	slot_foot = /obj/item/clothing/shoes/white
	slot_ears = /obj/item/device/radio/headset/research

	New()
		..()
		src.access = get_access("Chemist")
		return

/datum/job/special/research_assistant
	name = "Research Assistant"
	linkcolor = "#9900FF"
	limit = 0
	wages = 50
	low_priority_job = 1
	slot_jump = /obj/item/clothing/under/color/white
	slot_foot = /obj/item/clothing/shoes/white

	New()
		..()
		src.access = get_access("Research Assistant")
		return

/datum/job/special/medical_assistant
	name = "Medical Assistant"
	linkcolor = "#9900FF"
	limit = 0
	wages = 50
	low_priority_job = 1
	slot_jump = /obj/item/clothing/under/color/white
	slot_foot = /obj/item/clothing/shoes/white

	New()
		..()
		src.access = get_access("Medical Assistant")
		return

/datum/job/special/atmospheric_technician
	name = "Atmospheric Technician"
	linkcolor = "#FF9900"
	limit = 0
	wages = 350
	slot_belt = /obj/item/device/pda2/atmos
	slot_jump = /obj/item/clothing/under/misc/atmospheric_technician
	slot_foot = /obj/item/clothing/shoes/black
	slot_lhan = /obj/item/storage/toolbox/mechanical
	slot_poc1 = /obj/item/device/analyzer
	slot_ears = /obj/item/device/radio/headset/engineer
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/crowbar)

	New()
		..()
		src.access = get_access("Atmospheric Technician")
		return

/datum/job/special/tech_assistant
	name = "Technical Assistant"
	linkcolor = "#FF9900"
	limit = 0
	wages = 50
	low_priority_job = 1
	slot_jump = /obj/item/clothing/under/color/yellow
	slot_foot = /obj/item/clothing/shoes/brown

	New()
		..()
		src.access = get_access("Technical Assistant")
		return

/datum/job/special/boxer
	name = "Boxer"
	wages = 30
	limit = 0
	slot_jump = /obj/item/clothing/under/shorts
	slot_foot = /obj/item/clothing/shoes/black
	slot_glov = /obj/item/clothing/gloves/boxing

	New()
		..()
		src.access = get_access("Boxer")
		return

/datum/job/special/barber
	name = "Barber"
	wages = 30
	limit = 0
	slot_jump = /obj/item/clothing/under/misc/barber
	slot_foot = /obj/item/clothing/shoes/black
	slot_poc1 = /obj/item/scissors
	slot_poc2 = /obj/item/razor_blade

	New()
		..()
		src.access = get_access("Barber")
		return

/datum/job/special/mailman
	name = "Mailman"
	wages = 100
	limit = 0
	slot_jump = /obj/item/clothing/under/misc/mail
	slot_head = /obj/item/clothing/head/mailcap
	slot_foot = /obj/item/clothing/shoes/brown
	slot_back = /obj/item/storage/backpack/satchel
	slot_rhan = /obj/item/paper_bin
	slot_poc1 = /obj/item/stamp/
	slot_ears = /obj/item/device/radio/headset/civilian
	items_in_backpack = list(/obj/item/wrapping_paper, /obj/item/scissors)

	New()
		..()
		src.access = get_access("Mailman")
		return

/datum/job/special/tourist
	name = "Tourist"
	limit = 0
	linkcolor = "#FF99FF"
	slot_back = null
	slot_belt = /obj/item/storage/fanny
	slot_jump = /obj/item/clothing/under/misc/tourist
	slot_poc1 = /obj/item/camera_film
	slot_poc2 = /obj/item/spacecash/random/tourist // Exact amount is randomized.
	slot_foot = /obj/item/clothing/shoes/tourist
	slot_lhan = /obj/item/camera_test
	slot_rhan = /obj/item/storage/photo_album

/datum/job/special/space_cowboy
	name = "Space Cowboy"
	linkcolor = "#FF99FF"
	limit = 0
	wages = 100
	slot_jump = /obj/item/clothing/under/rank/det
	slot_belt = /obj/item/gun/kinetic/detectiverevolver
	slot_head = /obj/item/clothing/head/cowboy
	slot_mask = /obj/item/clothing/mask/cigarette/random
	slot_eyes = /obj/item/clothing/glasses/sunglasses
	slot_foot = /obj/item/clothing/shoes/cowboy
	slot_poc1 = /obj/item/cigpacket/random
	slot_poc2 = /obj/item/zippo/gold
	slot_lhan = /obj/item/whip
	slot_back = /obj/item/storage/backpack/satchel

	New()
		..()
		src.access = get_access("Space Cowboy")
		return

// randomizd gimmick jobs

/datum/job/special/random
	limit = 0
	//requires_whitelist = 1
	name = "Hollywood Actor"
	slot_foot = /obj/item/clothing/shoes/brown
	slot_jump = /obj/item/clothing/under/suit/purple
	change_name_on_spawn = 1

	New()
		..()
		if (prob(15))
			limit = 1
		if (src.alt_names.len)
			name = pick(src.alt_names)

/datum/job/special/random/vip
	name = "VIP"
	linkcolor = "#FF0000"
	slot_jump = /obj/item/clothing/under/suit
	slot_head = /obj/item/clothing/head/that
	slot_eyes = /obj/item/clothing/glasses/monocle
	slot_foot = /obj/item/clothing/shoes/black
	slot_lhan = /obj/item/storage/secure/sbriefcase
	items_in_backpack = list(/obj/item/baton/cane)
	alt_names = list("Senator", "President", "CEO", "Board Member", "Mayor", "Vice-President", "Governor")

	New()
		..()
		src.access = get_access("VIP")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return

		var/obj/item/storage/secure/sbriefcase/B = M.find_type_in_hand(/obj/item/storage/secure/sbriefcase)
		if (B && istype(B))
			new /obj/item/material_piece/gold(B)
			new /obj/item/material_piece/gold(B)

		return

/datum/job/special/random/inspector
	name = "Inspector"
	recieves_miranda = 1
	cant_spawn_as_rev = 1

	slot_belt = /obj/item/device/pda2/heads
	slot_jump = /obj/item/clothing/under/misc/lawyer/black // so they can slam tables
	slot_foot = /obj/item/clothing/shoes/brown
	slot_ears = /obj/item/device/radio/headset/command
	slot_head = /obj/item/clothing/head/NTberet
	slot_suit = /obj/item/clothing/suit/armor/NT
	slot_eyes = /obj/item/clothing/glasses/regular
	slot_lhan = /obj/item/storage/briefcase
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/device/flash)

	New()
		..()
		src.access = get_access("Inspector")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return

		var/obj/item/storage/briefcase/B = M.find_type_in_hand(/obj/item/storage/briefcase)
		if (B && istype(B))
			new /obj/item/whistle(B)
			new /obj/item/clipboard/with_pen(B)

		return

/datum/job/special/random/director
	name = "Regional Director"
	recieves_miranda = 1
	cant_spawn_as_rev = 1

	slot_belt = /obj/item/device/pda2/heads
	slot_jump = /obj/item/clothing/under/misc/NT
	slot_foot = /obj/item/clothing/shoes/brown
	slot_ears = /obj/item/device/radio/headset/command
	slot_head = /obj/item/clothing/head/NTberet
	slot_suit = /obj/item/clothing/suit/wcoat
	slot_eyes = /obj/item/clothing/glasses/sunglasses
	slot_lhan = /obj/item/clipboard/with_pen
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/device/flash)

	New()
		..()
		src.access = get_all_accesses()

/datum/job/special/random/diplomat
	name = "Diplomat"
	slot_lhan = /obj/item/storage/briefcase
	slot_jump = /obj/item/clothing/under/misc/lawyer
	slot_foot = /obj/item/clothing/shoes/brown
	alt_names = list("Diplomat", "Ambassador")
	cant_spawn_as_rev = 1

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		var/morph = pick(/datum/mutantrace/lizard,/datum/mutantrace/skeleton,/datum/mutantrace/ithillid,/datum/mutantrace/martian)
		M.set_mutantrace(morph)

/datum/job/special/random/testsubject
	name = "Test Subject"
	slot_jump = /obj/item/clothing/under/shorts

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.set_mutantrace(/datum/mutantrace/monkey)

/datum/job/special/random/musician
	name = "Musician"
	slot_jump = /obj/item/clothing/under/suit/pinstripe
	slot_head = /obj/item/clothing/head/flatcap
	slot_foot = /obj/item/clothing/shoes/brown
	items_in_backpack = list(/obj/item/saxophone,/obj/item/harmonica)

/datum/job/special/random/union
	name = "Union Rep"
	slot_jump = /obj/item/clothing/under/misc/lawyer
	slot_lhan = /obj/item/storage/briefcase
	slot_foot = /obj/item/clothing/shoes/brown
	alt_names = list("Assistants Union Rep", "Cyborgs Union Rep", "Union Rep", "Security Union Rep", "Doctors Union Rep", "Engineers Union Rep", "Miners Union Rep")

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return

		var/obj/item/storage/briefcase/B = M.find_type_in_hand(/obj/item/storage/briefcase)
		if (B && istype(B))
			new /obj/item/clipboard/with_pen(B)

		return

/datum/job/special/random/salesman
	name = "Salesman"
	slot_suit = /obj/item/clothing/suit/merchant
	slot_jump = /obj/item/clothing/under/gimmick/merchant
	slot_head = /obj/item/clothing/head/merchant_hat
	slot_lhan = /obj/item/storage/briefcase
	slot_foot = /obj/item/clothing/shoes/brown
	alt_names = list("Salesman", "Merchant")

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return

		var/obj/item/storage/briefcase/B = M.find_type_in_hand(/obj/item/storage/briefcase)
		if (B && istype(B))
			new /obj/item/material_piece/gold(B)
			new /obj/item/material_piece/gold(B)

		return

/datum/job/special/random/coach
	name = "Coach"
	slot_jump = /obj/item/clothing/under/jersey
	slot_suit = /obj/item/clothing/suit/armor/vest/macho
	slot_eyes = /obj/item/clothing/glasses/sunglasses
	slot_foot = /obj/item/clothing/shoes/white
	slot_poc1 = /obj/item/whistle
	slot_glov = /obj/item/clothing/gloves/boxing
	items_in_backpack = list(/obj/item/football,/obj/item/football,/obj/item/basketball,/obj/item/basketball)

/datum/job/special/random/journalist
	name = "Journalist"
	slot_jump = /obj/item/clothing/under/suit/red
	slot_head = /obj/item/clothing/head/fedora
	slot_lhan = /obj/item/storage/briefcase
	slot_poc1 = /obj/item/camera_test
	slot_foot = /obj/item/clothing/shoes/brown
	items_in_backpack = list(/obj/item/camera_film/large)

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return

		var/obj/item/storage/briefcase/B = M.find_type_in_hand(/obj/item/storage/briefcase)
		if (B && istype(B))
			new /obj/item/device/camera_viewer(B)
			new /obj/item/clothing/head/helmet/camera(B)
			new /obj/item/device/audio_log(B)
			new /obj/item/clipboard/with_pen(B)

		return

/datum/job/special/random/beekeeper
	name = "Apiculturist"
	wages = 250
	slot_jump = /obj/item/clothing/under/rank/beekeeper
	slot_suit = /obj/item/clothing/suit/bio_suit/beekeeper
	slot_head = /obj/item/clothing/head/bio_hood/beekeeper
	slot_poc1 = /obj/item/reagent_containers/food/snacks/beefood
	slot_foot = /obj/item/clothing/shoes/black
	slot_belt = /obj/item/device/pda2/botanist
	slot_foot = /obj/item/clothing/shoes/brown
	slot_glov = /obj/item/clothing/gloves/black
	slot_ears = /obj/item/device/radio/headset/civilian
	items_in_backpack = list(/obj/item/bee_egg_carton, /obj/item/bee_egg_carton, /obj/item/bee_egg_carton, /obj/item/reagent_containers/food/snacks/beefood, /obj/item/reagent_containers/food/snacks/beefood)
	alt_names = list("Apiculturist", "Apiarist")

	New()
		..()
		src.access = get_access("Apiculturist")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		if (prob(15))
			var/obj/critter/domestic_bee/bee = new(get_turf(M))
			bee.beeMom = M
			bee.beeMomCkey = M.ckey
			bee.name = pick_string("bee_names.txt", "beename")
			bee.name = dd_replacetext(bee.name, "larva", "bee")

/datum/job/special/random/souschef
	name = "Sous-Chef"
	wages = 125
	slot_belt = /obj/item/device/pda2/chef
	slot_jump = /obj/item/clothing/under/rank/chef
	slot_foot = /obj/item/clothing/shoes/chef
	slot_head = /obj/item/clothing/head/souschefhat
	slot_suit = /obj/item/clothing/suit/chef
	slot_ears = /obj/item/device/radio/headset/civilian

	New()
		..()
		src.access = get_access("Sous-Chef")
		return

/datum/job/special/random/waiter
	name = "Waiter"
	wages = 75
	slot_jump = /obj/item/clothing/under/rank/bartender
	slot_suit = /obj/item/clothing/suit/wcoat
	slot_foot = /obj/item/clothing/shoes/black
	slot_ears = /obj/item/device/radio/headset/civilian
	items_in_backpack = list(/obj/item/storage/box/glassbox,/obj/item/storage/box/cutlery)

	New()
		..()
		src.access = get_access("Waiter")
		return

/datum/job/special/random/pharmacist
	name = "Pharmacist"
	wages = 400
	slot_card = /obj/item/card/id/research
	slot_belt = /obj/item/device/pda2/medical
	slot_foot = /obj/item/clothing/shoes/brown
	slot_jump = /obj/item/clothing/under/shirt_pants
	slot_suit = /obj/item/clothing/suit/labcoat
	slot_ears = /obj/item/device/radio/headset/medical
	items_in_backpack = list(/obj/item/storage/box/beakerbox, /obj/item/storage/pill_bottle/cyberpunk)

	New()
		..()
		src.access = get_access("Pharmacist")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_medical")

/datum/job/special/syndicate_operative
	name = "Syndicate"
	limit = 0
	linkcolor = "#880000"
	slot_ears = null // So they don't get a default headset and stuff first.
	slot_card = null
	slot_glov = null
	slot_foot = null
	slot_back = null
	slot_belt = null

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
			M.real_name = "[syndicate_name()] Operative #[ticker.mode:agent_number]"
			ticker.mode:agent_number++
		else
			M.real_name = "Syndicate Agent"

		equip_syndicate(M)
		return

/datum/job/special/headminer
	name = "Head of Mining"
	limit = 0
	wages = 500
	linkcolor = "#00CC00"
	cant_spawn_as_rev = 1
	slot_card = /obj/item/card/id/command
	slot_belt = /obj/item/device/pda2/mining
	slot_jump = /obj/item/clothing/under/rank/overalls
	slot_foot = /obj/item/clothing/shoes/orange
	slot_glov = /obj/item/clothing/gloves/black
	slot_ears = /obj/item/device/radio/headset/command/ce
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/crowbar)

	New()
		..()
		src.access = get_access("Head of Mining")
		return

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.bioHolder.AddEffect("training_miner")
		if (prob(20))
			M.bioHolder.AddEffect("dwarf") // heh

/datum/job/special/machoman
	name = "Macho Man"
	linkcolor = "#9E0E4D"
	limit = 0
	slot_ears = null
	slot_card = null
	slot_back = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.machoize()

/datum/job/special/meatcube
	name = "Meatcube"
	linkcolor = "#FF0000"
	limit = 0
	allow_traitors = 0
	slot_ears = null
	slot_card = null
	slot_back = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.cubeize(INFINITY)

/datum/job/special/AI
	name = "AI"
	linkcolor = "#999999"
	limit = 0
	allow_traitors = 0
	cant_spawn_as_rev = 1
	slot_ears = null
	slot_card = null
	slot_back = null
	slot_belt = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.AIize()

/datum/job/special/cyborg
	name = "Cyborg"
	linkcolor = "#999999"
	limit = 0
	allow_traitors = 0
	cant_spawn_as_rev = 1
	slot_ears = null
	slot_card = null
	slot_back = null
	slot_belt = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		M.Robotize_MK2()

/datum/job/special/ghostdrone
	name = "Drone"
	linkcolor = "#999999"
	limit = 0
	allow_traitors = 0
	slot_ears = null
	slot_card = null
	slot_back = null
	items_in_backpack = list()

	special_setup(var/mob/living/carbon/human/M)
		..()
		if (!M)
			return
		droneize(M, 0)

/datum/job/daily //Special daily jobs

/datum/job/daily/sunday
	name = "Boxer"
	wages = 30
	limit = 2
	slot_jump = /obj/item/clothing/under/shorts
	slot_foot = /obj/item/clothing/shoes/black
	slot_glov = /obj/item/clothing/gloves/boxing

	New()
		..()
		src.access = get_access("Boxer")
		return

/datum/job/daily/monday
	name = "Lawyer"
	linkcolor = "#FF0000"
	wages = 100
	limit = 1
	slot_jump = /obj/item/clothing/under/misc/lawyer
	slot_foot = /obj/item/clothing/shoes/black
	slot_lhan = /obj/item/storage/briefcase
	slot_ears = /obj/item/device/radio/headset/civilian

	New()
		..()
		src.access = get_access("Lawyer")
		return

/datum/job/daily/tuesday
	name = "Barber"
	wages = 30
	limit = 1
	slot_jump = /obj/item/clothing/under/misc/barber
	slot_foot = /obj/item/clothing/shoes/black
	slot_poc1 = /obj/item/scissors
	slot_poc2 = /obj/item/razor_blade

	New()
		..()
		src.access = get_access("Barber")
		return

/datum/job/daily/wednesday
	name = "Mailman"
	wages = 100
	limit = 1
	slot_jump = /obj/item/clothing/under/misc/mail
	slot_head = /obj/item/clothing/head/mailcap
	slot_foot = /obj/item/clothing/shoes/brown
	slot_back = /obj/item/storage/backpack/satchel
	slot_rhan = /obj/item/paper_bin
	slot_poc1 = /obj/item/stamp/
	slot_ears = /obj/item/device/radio/headset/civilian
	items_in_backpack = list(/obj/item/wrapping_paper, /obj/item/scissors)

	New()
		..()
		src.access = get_access("Mailman")
		return

/datum/job/daily/thursday
	name = "Atmospheric Technician"
	linkcolor = "#FF9900"
	limit = 2
	wages = 350
	slot_belt = /obj/item/device/pda2/atmos
	slot_jump = /obj/item/clothing/under/misc/atmospheric_technician
	slot_foot = /obj/item/clothing/shoes/black
	slot_lhan = /obj/item/storage/toolbox/mechanical
	slot_poc1 = /obj/item/device/analyzer
	slot_ears = /obj/item/device/radio/headset/engineer
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/crowbar)

	New()
		..()
		src.access = get_access("Atmospheric Technician")
		return

/datum/job/daily/friday
	name = "Tourist"
	limit = 100
	linkcolor = "#FF99FF"
	slot_back = null
	slot_belt = /obj/item/storage/fanny
	slot_jump = /obj/item/clothing/under/misc/tourist
	slot_poc1 = /obj/item/camera_film
	slot_poc2 = /obj/item/spacecash/random/tourist // Exact amount is randomized.
	slot_foot = /obj/item/clothing/shoes/tourist
	slot_lhan = /obj/item/camera_test
	slot_rhan = /obj/item/storage/photo_album

/datum/job/daily/saturday
	name = "Vice Officer"
	linkcolor = "#FF0000"
	limit = 2
	wages = 250
	allow_traitors = 0
	cant_spawn_as_rev = 1
	recieves_miranda = 1
	slot_belt = /obj/item/device/pda2/security
	slot_jump = /obj/item/clothing/under/misc/vice
	slot_foot = /obj/item/clothing/shoes/brown
	slot_ears =  /obj/item/device/radio/headset/security
	items_in_backpack = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/box/security_starter_kit) // Don't make them spawn with a full backpack again, please.

	New()
		..()
		src.access = get_access("Vice Officer")
		return

/*---------------------------------------------------------------*/

/datum/job/created
	name = "Special Job"