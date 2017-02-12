/obj/critter/headspider
	name = "headspider"
	desc = "Oh my god!"
	icon_state = "headspider"
	density = 1
	anchored = 0
	aggressive = 1
	atkcarbon = 1
	atksilicon = 0
	opensdoors = 1
	health = 80

	var/datum/abilityHolder/changeling/changeling = null
	var/datum/mind/owner = null

	examine()
		set src in view()
		..()
		if(!alive)
			boutput(usr, text("<span style=\"color:red\"><B>the disgusting creature is not moving</B></span>"))
		else if (src.health > 40)
			boutput(usr, text("<span style=\"color:red\"><B>the spindly-legged head looks healthy and strong</B></span>"))
		else
			boutput(usr, text("<span style=\"color:red\"><B>the ugly thing is missing several limbs</B></span>"))
		return

	filter_target(var/mob/living/C)
		//Don't want a dead mob, don't want a mob with the same mind as the owner
		return C.stat != 2 && (!owner || C.mind != owner)

	ChaseAttack(var/mob/M)
		if(attacking) return
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			src.visible_message("<font color='#FF0000'><B>\The [src]</B> leaps on [H.name]!</font>")
			H.weakened += rand(3,5)

	CritterAttack(var/mob/M)
		if(attacking) return
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			src.set_loc(H.loc)
			random_brute_damage(H, 10)
			src.set_loc(H.loc)
			src.visible_message("<font color='#FF0000'><B>\The [src]</B> crawls down [H.name]'s throat!</font>")
			H.paralysis = max(H.paralysis, 10)
			attacking = 1

			var/datum/ailment_data/parasite/HS = new /datum/ailment_data/parasite
			HS.master = get_disease_from_path(/datum/ailment/parasite/headspider)
			HS.affected_mob = H
			HS.source = owner
			var/datum/ailment/parasite/headspider/HSD = HS.master
			HSD.changeling = changeling
			H.ailments += HS

			if(owner)
				logTheThing("combat", owner.current ? owner.current : owner, H, "'s headspider enters %target% at [log_loc(src)].")


			qdel(src)
			return