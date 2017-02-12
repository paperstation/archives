/datum/game_mode
	var/list/datum/mind/samurai = list()

/datum/game_mode/spooky
	name = "Samurai"
	config_tag = "samurai"
	restricted_jobs = list("Cyborg", "AI", "Captain", "Head of Personnel", "Chief Medical Officer", "Research Director", "Chief Engineer", "Head of Security") // Human / Minor roles only.
	var/list/target_list = list()
	required_players = 8
	required_enemies = 3
	recommended_enemies = 2
	var/finished = 0
	var/minions = 0
/datum/game_mode/spooky/announce()
	world << "<B>The current game mode is - Spooky Scary!</B>"



/*
/datum/game_mode/spooky/pre_setup()
	for(var/datum/mind/spooky in samurai)
		spooky.current.loc = pick(samuraistart)

	return 1
*/

/datum/game_mode/samurai/post_setup()
	for(var/datum/mind/samurai in samurai)
		forge_samurai_objectives(samurai)
		equip_samurai(samurai.current)
		greet_samurai(samurai)

	return


/datum/game_mode/spooky/can_start()//This could be better, will likely have to recode it later
	if(!..())
		return 0
	var/list/datum/mind/possible_samurais = get_players_for_role(BE_TRAITOR)
	if(possible_samurais.len==0)
		return 0
	var/datum/mind/samurais = pick(possible_samurais)
	samurai += samurais
	modePlayer += samurai
	samurai.assigned_role = "MODE" //So they aren't chosen for other jobs.
	samurai.special_role = "samurai"
	samurai.original = samurai.current
	if(samuraistart.len == 0)
		samurai.current << "<B>\red A starting location for you could not be found, please report this bug!</B>"
		return 0
	return 1







/datum/game_mode/proc/forge_samurai_objectives(var/datum/mind/samurai)
	switch(rand(1,100))
		if(1 to 30)

			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = samurai
			kill_objective.find_target()
			samurai.objectives += kill_objective

			var/datum/objective/sword/objective = new
			objective.owner = samurai
			objective.find_target()
			samurai.objectives += objective

			if (!(locate(/datum/objective/escape) in samurai.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = samurai
				samurai.objectives += escape_objective
		if(31 to 60)
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = samurai
			steal_objective.find_target()
			samurai.objectives += steal_objective

			var/datum/objective/soul/objective = new
			objective.owner = samurai
			objective.find_target()
			samurai.objectives += objective

			if (!(locate(/datum/objective/escape) in samurai.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = samurai
				samurai.objectives += escape_objective

		if(61 to 85)
			var/datum/objective/sword/kill_objective = new
			kill_objective.owner = samurai
			kill_objective.find_target()
			samurai.objectives += kill_objective

			var/datum/objective/soul/objective = new
			objective.owner = samurai
			objective.find_target()
			samurai.objectives += objective

			if (!(locate(/datum/objective/survive) in samurai.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = samurai
				samurai.objectives += survive_objective

		else
			if (!(locate(/datum/objective/hijack) in samurai.objectives))
				var/datum/objective/hijack/hijack_objective = new
				hijack_objective.owner = samurai
				samurai.objectives += hijack_objective


/datum/game_mode/proc/greet_samurai(var/datum/mind/samurai, var/you_are=1)
	if (you_are)
		samurai.current << "<B>\red You are the container of a samurai spirit!</B>"
	samurai.current << "When you die, your inner potential will emerge out of your body. Attack a human until they are down and then attack them again to take over their body and start your campaign!"
	samurai.current << "<B>You have been given the following task:</B>"

	var/obj_count = 1
	for(var/datum/objective/objective in samurai.objectives)
		samurai.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return


/datum/game_mode/proc/equip_samurai(mob/living/carbon/human/samurai_mob)
	if (!istype(samurai_mob))
		return

	new/obj/item/weapon/implant/samurai (samurai_mob.loc)


/datum/game_mode/spooky/check_finished()

	if(config.continous_rounds)
		return ..()

	var/samurai_alive = 0
	for(var/datum/mind/samurai in samurai)
		if(!istype(samurai.current,/mob/living/carbon))
			continue
		if(samurai.current.stat==2)
			continue
		samurai_alive++

	if (samurai_alive)
		return ..()
	else
		finished = 1
		return 1



















