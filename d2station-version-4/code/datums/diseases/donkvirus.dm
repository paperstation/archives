/datum/disease/donkvirus
	name = "Donk Virus"
	max_stages = 2
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Jenkem"
	cure_id = list("jenkem")
	cure_chance = 20
	affected_species = list("Human")
	affected_species2 = list(/mob/living/carbon/human)
	desc = "Subjects affected show the signs of wanting some donk pockets."
	severity = "Medium"
	why_so_serious = 1
/datum/disease/donkvirus/stage_act()
	..()
	switch(stage)
		if(2)
			//ticker.mode.equip_traitor(affected_mob)
			ticker.mode.traitors += affected_mob.mind
			affected_mob.mind.special_role = "traitor"

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = affected_mob.mind
			steal_objective.target_name = "nuclear authentication disk"
			steal_objective.steal_target = /obj/item/weapon/disk/nuclear
			steal_objective.explanation_text = "Steal a [steal_objective.target_name]."
			affected_mob.mind.objectives += steal_objective

			var/datum/objective/hijack/hijack_objective = new
			hijack_objective.owner = affected_mob.mind
			affected_mob.mind.objectives += hijack_objective

			affected_mob << "<B>You are the traitor.</B>"
			var/obj_count = 1
			for(var/datum/objective/OBJ in affected_mob.mind.objectives)
				affected_mob << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
				obj_count++
			new /obj/item/weapon/pinpointer(affected_mob.loc)
			stage = 0
	return