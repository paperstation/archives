
/obj/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1.0

	ex_act()
		return

/obj/landmark/cruiser_entrance

/obj/landmark/alterations
	name = "alterations"

/obj/landmark/miniworld
	name = "worldsetup"
	var/id = 0

/obj/landmark/miniworld/w1

/obj/landmark/miniworld/w2

/obj/landmark/miniworld/w3

/obj/landmark/miniworld/w4


/obj/landmark/New()

	..()
	src.tag = "landmark*[src.name]"
	src.invisibility = 101

	if (name == "shuttle")
		shuttle_z = src.z
		qdel(src)
/*
	if (name == "airtunnel_stop")
		airtunnel_stop = src.x

	if (name == "airtunnel_start")
		airtunnel_start = src.x

	if (name == "airtunnel_bottom")
		airtunnel_bottom = src.y
*/
	if (name == "monkey")
		monkeystart += src.loc
		qdel(src)

	if (name == "start")
		newplayer_start += src.loc
		qdel(src)

	if (name == "wizard")
		wizardstart += src.loc
		qdel(src)

	if (name == "predator")
		predstart += src.loc
		qdel(src)

	if (name == "Syndicate-Spawn")
		syndicatestart += src.loc
		qdel(src)

	if (name == "SR Syndicate-Spawn")
		syndicatestart += src.loc
		qdel(src)

	if (name == "JoinLate")
		latejoin += src.loc
		qdel(src)

	if (name == "Observer-Start")
		observer_start += src.loc
		qdel(src)

	if (name == "shitty_bill")
		spawn(30)
			new /mob/living/carbon/human/biker(src.loc)
			qdel(src)

	if (name == "father_jack")
		spawn(30)
			new /mob/living/carbon/human/fatherjack(src.loc)
			qdel(src)

	if (name == "don_glab")
		spawn(30)
			new /mob/living/carbon/human/don_glab(src.loc)
			qdel(src)

	if (name == "monkeyspawn_normal")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey(src.loc)
			qdel(src)

	if (name == "monkeyspawn_albert")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/albert(src.loc)
			qdel(src)

	if (name == "monkeyspawn_rathen")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/mr_rathen(src.loc)
			qdel(src)

	if (name == "monkeyspawn_mrmuggles")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/mr_muggles(src.loc)
			qdel(src)

	if (name == "monkeyspawn_mrsmuggles")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/mrs_muggles(src.loc)
			qdel(src)

	if (name == "monkeyspawn_syndicate")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/von_braun(src.loc)
			qdel(src)

	if (name == "monkeyspawn_horse")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/horse(src.loc)
			qdel(src)

	if (name == "monkeyspawn_krimpus")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/krimpus(src.loc)
			qdel(src)

	if (name == "monkeyspawn_tanhony")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/tanhony(src.loc)
			qdel(src)

	if (name == "Clown")
		clownstart += src.loc
		//dispose()

	//prisoners
	if (name == "prisonwarp")
		prisonwarp += src.loc
		qdel(src)
	//if (name == "mazewarp")
	//	mazewarp += src.loc
	if (name == "tdome1")
		tdome1	+= src.loc
	if (name == "tdome2")
		tdome2 += src.loc
	//not prisoners
	if (name == "prisonsecuritywarp")
		prisonsecuritywarp += src.loc
		qdel(src)

	if (name == "blobstart")
		blobstart += src.loc
		qdel(src)
	if (name == "kudzustart")
		kudzustart += src.loc
		qdel(src)

	if (name == "telesci")
		telesci += src.loc
		qdel(src)

	if (name == "icefall")
		icefall += src.loc
		qdel(src)

	if (name == "deepfall")
		deepfall += src.loc
		qdel(src)

	if (name == "ancientfall")
		ancientfall += src.loc
		qdel(src)

	if (name == "iceelefall")
		iceelefall += src.loc
		qdel(src)

	if (name == "bioelefall")
		bioelefall += src.loc
		qdel(src)

	return 1

var/global/list/job_start_locations = list()

/obj/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

	New()
		..()
		src.tag = "start*[src.name]"
		if (job_start_locations)
			if (!islist(job_start_locations[src.name]))
				job_start_locations[src.name] = list(src)
			else
				job_start_locations[src.name] += src
		src.invisibility = 101
		return 1

/obj/landmark/start/latejoin
	name = "JoinLate"

/obj/landmark/tutorial_start
	name = "Tutorial Start Marker"

/obj/landmark/asteroid_spawn_blocker //Blocks the creation of an asteroid on this tile, as you would expect
	name = "asteroid blocker"
	icon_state = "x4"

/obj/landmark/magnet_center
	name = "magnet center"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/landmark/magnet_shield
	name = "magnet shield"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0
