/mob/dead/observer/Life()
	if(show_antags && client)
		if(last_antag_update >= world.time)//Check the delay
			return
		last_antag_update = world.time + 3000 //5 minutes
		var/list/target_list = list()
		for(var/mob/living/target in mob_list)
			if(target.mind && (target.mind.special_role||issilicon(target)))//They need to have a mind.
				target_list += target
		if(target_list.len)//Everything else is handled by the ninja mask proc.
			assess_targets(target_list)



/mob/dead/observer/proc/assess_targets(list/target_list)//Taken from the ninja mask
	var/icon/tempHud = 'icons/mob/hud.dmi'
	for(var/image/I in client.images)
		switch(I.icon_state)
			if("hudtraitor")
				del(I)
			if("hudrevolutionary")
				del(I)
			if("hudheadrevolutionary")
				del(I)
			if("hudcultist")
				del(I)
			if("hudchangeling")
				del(I)
			if("hudwizard")
				del(I)
			if("hudalien")
				del(I)
			if("hudoperative")
				del(I)
			if("huddeathsquad")
				del(I)
			if("hudninja")
				del(I)
			if("hudunknown1")
				del(I)
			if("hudmalborg")
				del(I)
			if("hudmalai")
				del(I)
	for(var/mob/living/target in target_list)
		if(istype(target,/mob/living/carbon))
			switch(target.mind.special_role)
				if("traitor")
					client.images += image(tempHud,target,"hudtraitor")
				if("Revolutionary")
					client.images += image(tempHud,target,"hudrevolutionary")
				if("Head Revolutionary")
					client.images += image(tempHud,target,"hudheadrevolutionary")
				if("Cultist")
					client.images += image(tempHud,target,"hudcultist")
				if("Changeling")
					client.images += image(tempHud,target,"hudchangeling")
				if("Wizard","Fake Wizard")
					client.images += image(tempHud,target,"hudwizard")
				if("Hunter","Sentinel","Drone","Queen","Runner")
					client.images += image(tempHud,target,"hudalien")
				if("Syndicate")
					client.images += image(tempHud,target,"hudoperative")
				if("Death Commando")
					client.images += image(tempHud,target,"huddeathsquad")
				if("Space Ninja")
					client.images += image(tempHud,target,"hudninja")
				else//If we don't know what role they have but they have one.
					client.images += image(tempHud,target,"hudunknown1")
		if(istype(target,/mob/living/silicon))
			var/mob/living/silicon/silicon_target = target
			if(!silicon_target.laws || (silicon_target.laws&&(silicon_target.laws.zeroth)))
				if(isrobot(silicon_target))//Different icons for robutts and AI.
					client.images += image(tempHud,silicon_target,"hudmalborg")
				else
					client.images += image(tempHud,silicon_target,"hudmalai")
	return 1

