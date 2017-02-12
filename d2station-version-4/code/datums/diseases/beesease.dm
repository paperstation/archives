/datum/disease/beesease
	name = "Beesease"
	max_stages = 5
	spread = "Contact" //ie shot bees
	affected_species = list("Human","Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	cure = "Spaceacillin and Tricordrazine"
	cure_id = list("tricordrazine","spaceacillin")
	curable = 1
	cure_chance = 30
	why_so_serious = 5
/datum/disease/beesease/stage_act()
	..()
	var/mob/living/carbon/C = affected_mob
	switch(stage)
		if(1)
			if(prob(2))
				affected_mob << "\red You feel like something is moving inside of you"
		if(2) //also changes say, see say.dm
			if(prob(2))
				affected_mob << "\red You feel like something is moving inside of you"
			if(prob(2))
				affected_mob << "\red BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
		if(3)
			if(prob(1))
				affected_mob << "\red You feel something shoot out your nose"
				new /obj/livestock/spessbee/infectious
				affected_mob.bruteloss += 2
			if(prob(2))
				affected_mob << "\red BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
		//Should give the bee spit verb
		if(4)
			if(prob(1))
				affected_mob << "\red BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				affected_mob.bruteloss += 8
			if(prob(1))
				affected_mob << "\red BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				affected_mob.bruteloss += 4
			if(prob(1))
				affected_mob << "\red You feel like something is moving inside of you"
			if(C.health <= 0)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				spawn(1)
				C.gib()
		//Plus bees now spit randomly
		if(5)
			if(prob(1))
				affected_mob << "\red BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				affected_mob.bruteloss += 8
			if(prob(1))
				affected_mob << "\red BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(4)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				affected_mob.bruteloss += 4
			if(prob(1))
				affected_mob << "\red You can't stop the pain, you can't stop the buzzing"
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				affected_mob.bruteloss += 8

			if(C.health <= 0)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				sleep(1)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				new /obj/livestock/spessbee/infectious(affected_mob.loc)
				spawn(1)
				C.gib()
		//Plus if you die, you explode into bees
//	return

//Started working on it, but am too lazy to finish it today -- Urist