/mob/var/suiciding = 0
var/suicide_list = new/list()

/obj/proc/suicide(var/mob/user)
	return

/mob/living/carbon/human/proc/force_suicide()
	logTheThing("combat", src, null, "commits suicide")

	if (!src.stat)
		suicide_list += src.ckey
	if (src.client) // fix for "Cannot modify null.suicide"
		src.client.suicide = 1
	src.suiciding = 1
	src.unlock_medal("Damned", 1)

	//i'll just chuck this one in here i guess
	if (src.on_chair)
		src.visible_message("<span style=\"color:red\"><b>[src] jumps off of the chair straight onto \his head!</b></span>")
		src.TakeDamage("head", 200, 0)
		src.updatehealth()
		spawn(100)
			if (src)
				src.suiciding = 0

		src.pixel_y = 0
		src.anchored = 0
		src.on_chair = 0
		src.buckled = null
		return

	if (src.wear_mask && !istype(src.wear_mask,/obj/item/clothing/mask/cursedclown_hat)) //can't stare into the cluwne mask's eyes while wearing it...
		if(src.wear_mask.suicide(src))
			return

	if (src.w_uniform)
		if(src.w_uniform.suicide(src))
			return

	if (!src.restrained() && !src.paralysis && !src.stunned)
		if (src.l_hand)
			if (src.l_hand.suicide(src))
				return

		if (src.r_hand)
			if (src.r_hand.suicide(src))
				return

		for (var/obj/O in orange(1,src))
			if (O.suicide(src))
				return
/*
	for (var/obj/pool_springboard/O in orange(1,src))
		if(O.suicide(src))
			return

	for (var/obj/machinery/O in orange(1,src))
		if(O.suicide(src))
			return

	for (var/obj/critter/O in orange(1,src))
		if(O.suicide(src))
			return

	for (var/obj/table/O in orange(1,src))
		if(O.suicide(src))
			return

	for (var/obj/reagent_dispensers/O in orange(1,src))
		if(O.suicide(src))
			return
*/
	//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
	src.visible_message("<span style=\"color:red\"><b>[src] is holding \his breath. It looks like \he's trying to commit suicide.</b></span>")
	src.take_oxygen_deprivation(175)
	src.updatehealth()
	spawn(200) //in case they get revived by cryo chamber or something stupid like that, let them suicide again in 20 seconds
		src.suiciding = 0
	return

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (src.stat == 2)
		boutput(src, "You're already dead!")
		return

	if (!ticker)
		boutput(src, "You can't commit suicide before the game starts!")
		return
/*
//prevent a suicide if the person is infected with the headspider disease.
	for (var/datum/ailment/V in src.ailments)
		if (istype(V, /datum/ailment/parasite/headspider) || istype(V, /datum/ailment/parasite/alien_embryo))
			boutput(src, "You can't muster the willpower. Something is preventing you from doing it.")
			return
*/

	if (suiciding)
		boutput(src, "You're already committing suicide! Be patient!")
		return

	if (!suicide_allowed)
		boutput(src, "You find yourself unable to go through with killing yourself!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if (confirm == "Yes")
		src.suiciding = 1
		src.unkillable = 0 //Get owned, nerd!
		src.force_suicide()
		return
	else
		// if they cancelled the prompt
		suiciding = 0
		return

/* will fix this later
		else if (method == "extinguisher")
			viewers(src) << "<span style=\"color:red\"><b>[src] puts the nozzle of the extinguisher into \his mouth and squeezes the handle.</b></span>"
			var/succeeds = 0
			for(var/obj/item/extinguisher/E in src.l_hand)
				if(E.safety == 0 && E.reagents && E.reagents.total_volume >= 5)
					succeeds = 1
					E.reagents.remove_any(5)
			if(!succeeds)
				for(var/obj/item/extinguisher/E in src.r_hand)
					if(E.safety == 0 && E.reagents && E.reagents.total_volume >= 5)
						succeeds = 1
						E.reagents.remove_any(5)
			if(succeeds) src.gib()
			else
				viewers(src) << "<span style=\"color:red\"><b>Nothing happens!</b></span>"
				spawn(50)
					suiciding = 0*/

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (src.stat == 2)
		boutput(src, "You're already dead!")
		return

	if (suiciding)
		boutput(src, "You're already committing suicide! Be patient!")
		return

	if (!suicide_allowed)
		boutput(src, "You find yourself unable to go through with killing yourself!")
		return

	suiciding = 1
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		src.client.suicide = 1
		usr.visible_message("<span style=\"color:red\"><b>[src] is powering down. It looks like \he's trying to commit suicide.</b></span>")
		src.unlock_medal("Damned", 1)
		//put em at -175
		//src.death_timer = 15 // this shit ain't really workin so bandaid fix for now
		//src.updatehealth()
		spawn(30)
			src.death()
		spawn(200)
			suiciding = 0
		return
	suiciding = 0

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (src.stat == 2)
		boutput(src, "You're already dead!")
		return

	if (suiciding)
		boutput(src, "You're already committing suicide! Be patient!")
		return

	if (!suicide_allowed)
		boutput(src, "You find yourself unable to go through with killing yourself!")
		return


	suiciding = 1
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if (confirm == "Yes")
		src.client.suicide = 1
		var/mob/living/silicon/robot/R = src
		R.unlock_medal("Damned", 1)
		usr.visible_message("<span style=\"color:red\"><b>[src] disconnects all its joint moorings!</b></span>")
		R.part_chest.set_loc(src.loc)
		R.part_chest = null
		spawn(200)
			R.suiciding = 0
		return
	suiciding = 0
