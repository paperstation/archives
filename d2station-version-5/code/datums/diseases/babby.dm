/datum/disease/baby
	name = "Pregnancy"
	max_stages = 5
	spread = "None"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_id = list("alcohol","tobacco","toxin","gargleblaster")
	cure_chance = 20
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	permeability_mod = 3//likely to infect
	why_so_serious = 5
/datum/disease/baby/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your stomach feels larger."
			if(prob(1))
				affected_mob << "\red Your muscles ache.."
		if(3)
			if(prob(1))
				affected_mob << "\red Your stomach hurts.."
			if(prob(1))
				affected_mob << "\red You feel weak."
		if(4)
			if(prob(2))
				affected_mob << "\red Your muscles ache."
				if(prob(20))
					affected_mob.take_organ_damage(1)
			if(prob(2))
				affected_mob << "\red Your stomach hurts."
				if(prob(20))
					affected_mob.bruteloss += 1
					affected_mob.updatehealth()
		if(5)
			affected_mob << "\red You feel something tearing its way out of your stomach..."
			for(var/mob/O in viewers(affected_mob, null))
				O.show_message(text("\red [] lays down pain!", affected_mob), 1)
			affected_mob.toxloss += 1
			affected_mob.updatehealth()
			affected_mob.stunned += 4
			affected_mob.weakened += 4
			affected_mob.bruteloss += 1
			affected_mob.updatehealth()
			var/obj/livestock/baby/B = new /obj/livestock/baby(affected_mob.loc)
			var/babygender = pick("boy","girl")
			var/babyname
			if(babygender == "boy")
				babyname = capitalize(pick(first_names_male) + " " + pick(last_names))
			else if(babygender == "girl")
				babyname = capitalize(pick(first_names_female) + " " + pick(last_names))
			var/new_baby = input(affected_mob, "You just had a baby! It's a [babygender]!", "Name change", babyname)

			if ( (length(new_baby) == 0) || (new_baby == "[babyname]") )
				new_baby = babyname

			if(new_baby)
				if (length(new_baby) >= 26)
					new_baby = copytext(new_baby, 1, 26)
					new_baby = dd_replacetext(new_baby, ">", "'")
			B.name = new_baby
			B.babygender = babygender
			del(src)