/datum/disease/squirts
	name = "The Squirts"
	max_stages = 5
	spread = "Airborne"
	cure = "Unknown"
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	why_so_serious = 0
/datum/disease/squirts/stage_act()
	..()

	switch (src.stage)
		if (2)
			if (prob(3))
				affected_mob.emote("shiver")

		if (3)
			if (prob(3))
				affected_mob.emote("shiver")
				new /obj/decal/cleanable/blood/splatter(affected_mob.loc)

		if (4)
			if (prob(3))
				affected_mob.emote("shiver")
				new /obj/decal/cleanable/blood/splatter(affected_mob.loc)
			else if (prob(3))
				affected_mob.emote("twitch")
				new /obj/decal/cleanable/blood(affected_mob.loc)

		if (5)
			if (prob(3))
				affected_mob.emote("twitch")
				new /obj/decal/cleanable/blood(affected_mob.loc)
				affected_mob.toxloss += 1
				affected_mob.updatehealth()
