/mob/var/suiciding = 0
/var/global/suicides_dead = 0
/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == DEAD)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	/*if(!canmove || restrained())
		src << "You can't commit suicide whilst restrained!"
		return*/
	suiciding = 1
	suicides_dead += 1
	spawn(1200) //in case they get revived by cryo chamber or something stupid like that, let them suicide again in 2 minutes
		if(stat != DEAD)
			suiciding = 0
		return

	var/obj/item/held_item = get_active_hand()
	if(held_item && !restrained())
		var/damagetype = held_item.suicide_act(src)
		if(damagetype)
			var/damage_mod = 1
			switch(damagetype) //Sorry about the magic numbers.
							   //brute = 1, burn = 2, tox = 4, oxy = 8
				if(15) //4 damage types
					damage_mod = 4

				if(6, 11, 13, 14) //3 damage types
					damage_mod = 3

				if(3, 5, 7, 9, 10, 12) //2 damage types
					damage_mod = 2

				if(1, 2, 4, 8) //1 damage type
					damage_mod = 1

				else //This should not happen, but if it does, everything should still work
					damage_mod = 1

			//Do 175 damage divided by the number of damage types applied.
			if(damagetype & BRUTELOSS)
				deal_damage(175/damage_mod, BRUTE, null, "chest")

			if(damagetype & FIRELOSS)
				deal_damage(175/damage_mod, BURN, null, "chest")

			if(damagetype & TOXLOSS)
				deal_damage(175/damage_mod, TOX)

			if(damagetype & OXYLOSS)
				deal_damage(175/damage_mod, OXY)

			//If something went wrong then just kill them with oxyloss
			if(!(damagetype | BRUTELOSS) && !(damagetype | FIRELOSS) && !(damagetype | TOXLOSS) && !(damagetype | OXYLOSS))
				deal_damage(200, OXY)
			return


	viewers(src) << pick("\red <b>[src] is holding \his breath!</b>", \
						"\red <b>[src] snaps \his neck!</b>")
	deal_damage(max(175 - tox_damage - get_fire_loss() - get_brute_loss() - oxy_damage, 0), OXY)
	return


/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	suiciding = 1
	suicides_dead += 1
	viewers(loc) << "\red <b>[src]'s brain grows dull and lifeless.</b>"
	spawn(50)
		death(0)
		suiciding = 0
	return


/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		suicides_dead += 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] is holding \his breath.</b>"
		deal_damage(max(175 - tox_damage - get_fire_loss() - get_brute_loss() - oxy_damage, 0), OXY)


/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	suiciding = 1
	suicides_dead += 1
	viewers(src) << "\red <b>[src] powers down.</b>"
	//Kill them instantly
	deal_damage(max(maxHealth * 2 - tox_damage - get_fire_loss() - get_brute_loss() - oxy_damage, 0), OXY)
	return


/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	suiciding = 1
	suicides_dead += 1
	viewers(src) << "\red <b>[src] powers down.</b>"
	//Kill them instantly
	deal_damage(max(maxHealth * 2 - tox_damage - get_fire_loss() - get_brute_loss() - oxy_damage, 0), OXY)
	return


/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("REALLY kill yourself? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "No")
		return
	var/obj/item/device/paicard/card = loc
	card.removePersonality()
	suicides_dead += 1
	var/turf/T = get_turf(card.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue [src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"", 3, "\blue [src] bleeps electronically.", 2)
	death(0)
	return


/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	suiciding = 1
	suicides_dead += 1
	viewers(src) << "\red <b>[src] begins to thrash wildly!</b>"
	//Kill alens instantly due to healing
	deal_damage(max(200 - get_fire_loss() - get_brute_loss() - oxy_damage, 0), OXY)
	return


/mob/living/carbon/slime/verb/suicide()
	set hidden = 1
	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "No")
		return
	suiciding = 1
	suicides_dead += 1
	deal_damage(max(500 - tox_damage - get_fire_loss() - get_brute_loss() - oxy_damage, 0), OXY)
	return