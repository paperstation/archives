var/datum/mining_controller/mining_controls

var/list/asteroid_blocked_turfs = list()
var/turf_spawn_edge_limit = 5

/datum/mining_controller
	var/list/ore_types_common = list()
	var/list/ore_types_uncommon = list()
	var/list/ore_types_rare = list()
	var/list/events = list()
	// magnet vars
	var/turf/magnetic_center = null
	var/area/mining/magnet/magnet_area = null
	var/list/magnet_shields = list()
	var/max_magnet_spawn_size = 7
	var/min_magnet_spawn_size = 4
	var/list/mining_encounters_common = list()
	var/list/mining_encounters_uncommon = list()
	var/list/mining_encounters_rare = list()
	var/list/small_encounters = list()

	var/list/magnet_do_not_erase = list(/obj/securearea,/obj/forcefield/mining,/obj/grille/catwalk)

	New()
		..()
		for (var/X in typesof(/datum/ore) - /datum/ore - /datum/ore/event)
			var/datum/ore/O = new X
			ore_types_common += O

		for (var/X in typesof(/datum/mining_encounter) - /datum/mining_encounter)
			var/datum/mining_encounter/MC = new X
			mining_encounters_common += MC

		for (var/datum/ore/O in src.ore_types_common)
			if (istype(O, /datum/ore/event/))
				events += O
				ore_types_common -= O
			if (O.rarity_tier == 2)
				ore_types_uncommon += O
				ore_types_common -= O
			else if (O.rarity_tier == 3)
				ore_types_rare += O
				ore_types_common -= O
			O.set_up()

		for (var/datum/mining_encounter/MC in mining_encounters_common)
			if (MC.rarity_tier == 3)
				mining_encounters_rare += MC
				mining_encounters_common -= MC
			else if (MC.rarity_tier == 2)
				mining_encounters_uncommon += MC
				mining_encounters_common -= MC
			else if (MC.rarity_tier == -1)
				small_encounters += MC
				mining_encounters_common -= MC
			else if (MC.rarity_tier != 1)
				mining_encounters_common -= MC
				qdel(MC)

		for (var/obj/landmark/magnet_center/MC in world)
			magnetic_center = get_turf(MC)
			magnet_area = get_area(MC)
			MC.dispose()
			break

		for (var/obj/landmark/magnet_shield/MS in world)
			var/obj/forcefield/mining/S = new /obj/forcefield/mining(get_turf(MS))
			magnet_shields += S
			MS.dispose()

	proc/get_ore_from_string(var/string)
		if (!istext(string))
			return
		for (var/datum/ore/O in ore_types_common + ore_types_uncommon + ore_types_rare)
			if (O.name == string)
				return O
		return null

	proc/get_ore_from_path(var/path)
		if (!ispath(path))
			return
		for (var/datum/ore/O in ore_types_common + ore_types_uncommon + ore_types_rare)
			if (O.type == path)
				return O
		return null

	proc/select_encounter(var/rarity_mod)
		if (!isnum(rarity_mod))
			rarity_mod = 0
		var/chosen = RarityClassRoll(100,rarity_mod,list(95,70))

		var/list/category = mining_controls.mining_encounters_common
		switch(chosen)
			if (2)
				category = mining_controls.mining_encounters_uncommon
			if (3)
				category = mining_controls.mining_encounters_rare

		if (category.len < 1)
			category = mining_controls.mining_encounters_common

		return pick(category)

	proc/select_small_encounter(var/rarity_mod)
		return pick(small_encounters)

/area/mining/magnet
	name = "Magnet Area"
	icon_state = "purple"
	RL_Lighting = 0
	requires_power = 0
	luminosity = 1

	proc/check_for_unacceptable_content()
		for (var/mob/living/L in src.contents)
			return 1
		for (var/obj/machinery/vehicle in src.contents)
			return 1
		return 0

/obj/forcefield/mining
	name = "magnetic forcefield"
	desc = "A powerful field used by the mining magnet to attract minerals."
	icon = 'icons/misc/old_or_unused.dmi'
	icon_state = "noise6"
	color = "#BF12DE"
	alpha = 175
	opacity = 0
	density = 0
	invisibility = 101
	anchored = 1

/// *** MISC *** ///

/proc/getOreQualityName(var/quality)
	switch(quality)
		if(-INFINITY to -101)
			return "worthless"
		if(-100 to -51)
			return "terrible"
		if(-50 to -41)
			return "awful"
		if(-40 to -31)
			return "bad"
		if(-30 to -21)
			return "low-grade"
		if(-20 to -11)
			return "poor"
		if(-10 to -1)
			return "impure"
		if(0)
			return ""
		if(1 to 10)
			return "decent"
		if(11 to 20)
			return "fine"
		if(21 to 30)
			return "good"
		if(31 to 40)
			return "high-quality"
		if(41 to 50)
			return "excellent"
		if(51 to 60)
			return "fantastic"
		if(61 to 70)
			return "amazing"
		if(71 to 80)
			return "incredible"
		if(81 to 90)
			return "supreme"
		if(91 to 100)
			return "pure"
		if(101 to INFINITY)
			return "perfect"
		else
			return "strange"
	return

/proc/getGemQualityName(var/quality)
	switch(quality)
		if(-INFINITY to -101)
			return "worthless"
		if(-100 to -51)
			return "awful"
		if(-50 to -41)
			return "shattered"
		if(-40 to -31)
			return "broken"
		if(-30 to -21)
			return "cracked"
		if(-20 to -11)
			return "flawed"
		if(-10 to -1)
			return "dull"
		if(0)
			return ""
		if(1 to 10)
			return "pretty"
		if(11 to 20)
			return "shiny"
		if(21 to 30)
			return "gleaming"
		if(31 to 40)
			return "sparkling"
		if(41 to 50)
			return "glittering"
		if(51 to 60)
			return "beautiful"
		if(61 to 70)
			return "lustrous"
		if(71 to 80)
			return "iridescent"
		if(81 to 90)
			return "radiant"
		if(91 to 100)
			return "pristine"
		if(101 to INFINITY)
			return "perfect"
		else
			return "strange"
	return