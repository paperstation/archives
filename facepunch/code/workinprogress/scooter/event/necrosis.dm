/proc/necrosis()
	if(ticker.mode.traitors.len > 0)
		for(var/datum/mind/traitors in ticker.mode.traitors)
			var/mob/living/M = traitors.current
			if(M)
				var/mob/living/Z = pick(M)
				Z.revive()
				Z.physeffect |= DECOMP
/proc/necrosiseventstart()
	NecrosisTratiors()
	if(ticker.mode.traitors.len > 0)
		for(var/datum/mind/traitors in ticker.mode.traitors)
			var/mob/living/M = traitors.current
			if(M)
				new /mob/proc/ritual (M)
				M.mutations |= NOCLONE
				M << "Your soul has been fractured and is trapped in purgatory. Your fate is tied with the fate of several 'friends' who share the same fate"
				M << "You will only survive if all of your friends are alive. If a 'friend' dies, you can remove the soul out of someone to bring the dead person back. However doing so however causes degeneration to the person revived which will slowly kill them unless they absorb a soul."
				M << "Unluckily for you and your 'friends' you were followed and the crew has been tipped off and give equipment to stop you..."
/mob/proc/ritual()
	set category = "Ritual"
	set name = "Soul Removal"

	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		src << "<span class='warning'>You must grab your target to remove their soul.</span>"
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		src << "<span class='warning'>[T] is not a human.</span>"
		return

	if(NOCLONE in T.mutations)
		src << "<span class='warning'>This creature has no soul!</span>"
		return

	if(!G.killing)
		src << "<span class='warning'>You must have a tighter grip.</span>"
		return

	if(!T.stat == 1)
		src << "<span class='warning'>Your target must be dead to bring back a friend!</span>"
		return

	else
		src << "<span class='notice'>You start to absorb [T]'s soul!</span>"
		if(!do_mob(src, T)||!do_after(src, 30)) return
		src << "<span class='notice'>You have absorbed a soul!</span>"
		T << "<span class='danger'>You have had your soul sucked out!</span>"
		T.mutations |= NOCLONE
		necrosis()

/obj/item/device/event/detector
	name = "Necrosis Detector"
	desc = "Used to find decayed flesh."
	icon_state = "timer"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	var/on = 0
	var/detected = 0
	var/number
	attack_self(mob/user as mob)
		if(!on)
			on = 1
			for(var/mob/living/M in viewers(src, 7))
				if(M.physeffect == DECOMP)
					continue
				number += 1
			if(detected >= 1)
				user << "Necrotic tissue detected in this area"
			else
				user << "No necrotic tissue detected in this area"
			number = 0
			spawn(250)
				on = 0







/proc/NecrosisTratiors()
	var/datum/game_mode/traitor/temp = new

	if(config.protect_roles_from_antagonist)
		temp.restricted_jobs += temp.protected_jobs

	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H = null

	for(var/mob/living/carbon/human/applicant in player_list)
		if(applicant.client.prefs.be_special & BE_TRAITOR)
			if(!applicant.stat)
				if(applicant.mind)
					if (!applicant.mind.special_role)
						if(!jobban_isbanned(applicant, "traitor") && !jobban_isbanned(applicant, "Syndicate"))
							if(!(applicant.job in temp.restricted_jobs))
								candidates += applicant

	if(candidates.len)
		var/numTratiors = min(candidates.len, 3)

		for(var/i = 0, i<numTratiors, i++)
			H = pick(candidates)
			H.mind.make_necrosisTratior()
			candidates.Remove(H)

		return 1


	return 0


