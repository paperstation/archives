datum/mind
	var/key
	var/mob/current
	var/mob/virtual

	var/memory
	var/last_memory_time = 0 //Give a small delay when adding memories to prevent spam. It could happen!
	var/miranda // sec's miranda rights thingy.
	var/last_miranda_time = 0 // this is different than last_memory_time, this is when the rights were last SAID, not last CHANGED

	var/violated_hippocratic_oath = 0

	var/assigned_role
	var/special_role
	var/late_special_role = 0
	var/random_event_special_role = 0

	// This used for dead/released/etc mindslaves and rogue robots we still want them to show up
	// in the game over stats. It's a list because former mindslaves could also end up as an emagged
	// cyborg or something. Use strings here, just like special_role (Convair880).
	var/list/former_antagonist_roles = list()

	var/list/datum/objective/objectives = list()
	var/is_target = 0
	var/list/purchased_traitor_items = list()
	var/list/traitor_crate_items = list()

	var/datum/gang/gang = null //Associate a leader with their gang.

	//Ability holders.
	var/datum/abilityHolder/changeling/is_changeling = 0
	var/datum/abilityHolder/wizard/is_wizard = 0
	var/datum/abilityHolder/vampire/is_vampire = 0

	var/list/intrinsic_verbs = list()

	// For mindslave/vampthrall/spyslave master references, which are now tracked by ckey.
	// Mob references are not very reliable and did cause trouble with automated mindslave status removal
	// The relevant code snippets call a ckey -> mob reference lookup proc where necessary,
	// namely whois_ckey_to_mob_reference(mob.mind.master) (Convair880).
	var/master = null

	var/dnr = 0

	var/luck = 50 // todo:
	var/sanity = 100 // implement dis

	var/handwriting = null

	var/obj/item/organ/brain/brain

	New(mob/M)
		..()
		if (M)
			current = M
			key = M.key
			src.handwriting = pick(handwriting_styles)

	proc/transfer_to(mob/new_character)
		if (!new_character)
			return

		if (current)
			current.mind = null

		new_character.mind = src
		current = new_character

		new_character.key = key

		//if (is_changeling)
		//	new_character.make_changeling()

		for (var/intrinsic_verb in intrinsic_verbs)
			new_character.verbs += intrinsic_verb

	proc/swap_with(mob/target)
		var/datum/mind/other_mind = target.mind
		var/mob/my_old_mob = current

		if (other_mind)	//They have a mind so we can do this nicely
			if (isobserver(current))
				current:delete_on_logout = 0
			if (isobserver(target))
				target:delete_on_logout = 0

			var/mob/temp = new/mob(src.current.loc) //We need to put whoever we're swapping with somewhere
			other_mind.transfer_to(temp)			//So now we put them there
			src.transfer_to(target)					//Then I go into their head
			other_mind.transfer_to(my_old_mob)		//And they go into my old one
			qdel(temp)								//Not needed any more

		else if (!target.client && !target.key) 	//They didn't have a mind and didn't have an associated player, AKA up for grabs
			src.transfer_to(target)

		else	//The Ugly Way
			if (isobserver(current))
				current:delete_on_logout = 0
			if (isobserver(target))
				target:delete_on_logout = 0

			var/mob/temp = new/mob(src.current.loc) //We need to put whoever we're swapping with somewhere
			temp.key = target.key					//So now we put them there
			src.transfer_to(target)					//Then I go into their head
			my_old_mob.key = temp.key
			qdel(temp)								//Not needed any more

		if (isobserver(current))
			current:delete_on_logout = 1
		if (isobserver(target))
			target:delete_on_logout = 1

	proc/store_memory(new_text)
		memory += "[new_text]<BR>"

	proc/show_memory(mob/recipient)
		var/output = "<B>[current.real_name]'s Memory</B><HR>"
		output += memory

		if (objectives.len>0)
			output += "<HR><B>Objectives:</B>"

			var/obj_count = 1
			for (var/datum/objective/objective in objectives)
				output += "<B>Objective #[obj_count]</B>: [objective.explanation_text]<br>"
				obj_count++

		// Added (Convair880).
		if (recipient.mind.master)
			var/mob/mymaster = whois_ckey_to_mob_reference(recipient.mind.master)
			if (mymaster)
				output+= "<br><b>Your master:</b> [mymaster.real_name]"

		recipient << browse(output,"window=memory")

	proc/set_miranda(new_text)
		miranda = new_text

	proc/show_miranda(mob/recipient)
		var/output = "<B>[current.real_name]'s Miranda Rights</B><HR>[miranda]"

		recipient << browse(output,"window=miranda")

	Del()
		logTheThing("debug", null, null, "<b>Mind</b> Mind for \[[src.key ? src.key : "NO KEY"]] deleted!")
		..()