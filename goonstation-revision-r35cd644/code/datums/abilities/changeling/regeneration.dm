/datum/targetable/changeling/stasis
	name = "Enter Regenerative Stasis"
	desc = "Enter a stasis, appearing to be completely dead for 45 seconds, while healing all injuries."
	icon_state = "stasis"
	human_only = 1
	cooldown = 450
	targeted = 0
	target_anything = 0
	can_use_in_container = 1

	cast(atom/target)
		if (..())
			return 1

		var/datum/abilityHolder/changeling/H = holder
		if (!istype(H))
			boutput(holder.owner, __red("That ability is incompatible with our abilities. We should report this to a coder."))
			return 1

		var/mob/living/carbon/human/C = holder.owner
		if (alert("Are we sure?","Enter Regenerative Stasis?","Yes","No") != "Yes")
			boutput(holder.owner, __blue("We change our mind."))
			return 1

		if(!H.in_fakedeath)
			boutput(holder.owner, __blue("Repairing our wounds."))
			logTheThing("combat", holder.owner, null, "enters regenerative stasis as a changeling [log_loc(holder.owner)].")
			var/list/implants = list()
			for (var/obj/item/implant/I in holder.owner) //Still preserving implants
				implants += I

			H.in_fakedeath = 1

			C.lying = 1
			C.canmove = 0
			C.set_clothing_icon_dirty()

			C.emote("deathgasp")

			spawn(cooldown)
				if (C && C.stat != 2)
					C.HealDamage("All", 1000, 1000)
					C.take_toxin_damage(-INFINITY)
					C.take_oxygen_deprivation(-INFINITY)
					C.paralysis = 0
					C.stunned = 0
					C.weakened = 0
					C.radiation = 0
					C.health = 100
					C.updatehealth()
					C.reagents.clear_reagents()
					C.lying = 0
					C.canmove = 1
					boutput(C, "<span style=\"color:blue\">We have regenerated.</span>")
					logTheThing("combat", C, null, "[C] finishes regenerative statis as a changeling [log_loc(C)].")
					C.visible_message(__red("<B>[C] appears to wake from the dead, having healed all wounds.</span>"))
					for(var/obj/item/implant/I in implants)
						if (istype(I, /obj/item/implant/projectile))
							boutput(C, "<span style=\"color:red\">\an [I] falls out of your abdomen.</span>")
							I.on_remove(C)
							C.implant.Remove(I)
							I.set_loc(C.loc)
							continue

				C.set_clothing_icon_dirty()
				H.in_fakedeath = 0
		return 0

/proc/changeling_super_heal_step(var/mob/living/carbon/human/healed)
	var/mob/living/carbon/human/C = healed
	var/list/implants = list()
	for (var/obj/item/implant/I in C) //Still preserving implants
		implants += I

	C.reagents.remove_any(10)

	if (!C.burning && C.stat != 2 && (C.health < 100 || !C.limbs.l_arm || !C.limbs.r_arm || !C.limbs.l_leg || !C.limbs.r_leg))
		if (C.health < 100)
			C.HealDamage("All", 10, 1)
			C.take_toxin_damage(-10)
			C.take_oxygen_deprivation(-10)
			if (C.blood_volume < 500)
				C.blood_volume += 10
				//changelings can get this somehow and it stops speed regen ever turning off otherwise
			boutput(C, "<span style=\"color:blue\">You feel your flesh knitting back together.</span>")
			for(var/obj/item/implant/I in implants)
				if (istype(I, /obj/item/implant/projectile))
					boutput(C, "<span style=\"color:red\">\an [I] falls out of your abdomen.</span>")
					I.on_remove(C)
					C.implant.Remove(I)
					I.set_loc(C.loc)
					continue

		if (!C.limbs.l_arm || !C.limbs.r_arm || !C.limbs.l_leg || !C.limbs.r_leg)
			if(!C.limbs.l_arm && prob(25))
				if (isabomination(C))
					C.limbs.l_arm = new /obj/item/parts/human_parts/arm/left/abomination(C)
				else
					C.limbs.l_arm = new /obj/item/parts/human_parts/arm/left(C)
				C.limbs.l_arm.holder = C
				C.limbs.l_arm:original_holder = C
				C.limbs.l_arm:set_skin_tone()
				C.visible_message("<span style=\"color:red\"><B> [C]'s left arm grows back!</span>")
				C.set_body_icon_dirty()

			if (!C.limbs.r_arm && prob(25))
				if (isabomination(C))
					C.limbs.r_arm = new /obj/item/parts/human_parts/arm/right/abomination(C)
				else
					C.limbs.r_arm = new /obj/item/parts/human_parts/arm/right(C)
				C.limbs.r_arm.holder = C
				C.limbs.r_arm:original_holder = C
				C.limbs.r_arm:set_skin_tone()
				C.visible_message("<span style=\"color:red\"><B> [C]'s right arm grows back!</span>")
				C.set_body_icon_dirty()

			if (!C.limbs.l_leg && prob(25))
				C.limbs.l_leg = new /obj/item/parts/human_parts/leg/left(C)
				C.limbs.l_leg.holder = C
				C.limbs.l_leg:original_holder = C
				C.limbs.l_leg:set_skin_tone()
				C.visible_message("<span style=\"color:red\"><B> [C]'s left leg grows back!</span>")
				C.set_body_icon_dirty()

			if (!C.limbs.r_leg && prob(25))
				C.limbs.r_leg = new /obj/item/parts/human_parts/leg/right(C)
				C.limbs.r_leg.holder = C
				C.limbs.r_leg:original_holder = C
				C.limbs.r_leg:set_skin_tone()
				C.visible_message("<span style=\"color:red\"><B> [C]'s right leg grows back!</span>")
				C.set_body_icon_dirty()

		if (prob(25)) C.visible_message("<span style=\"color:red\"><B>[C]'s flesh is moving and sliding around oddly!</B></span>")

/datum/targetable/changeling/regeneration
	name = "Speed Regeneration"
	desc = "Regenerate your health quickly and rather loudly."
	icon_state = "speedregen"
	human_only = 1
	cooldown = 900
	pointCost = 10
	targeted = 0
	target_anything = 0
	can_use_in_container = 1
	dont_lock_holder = 1
	ignore_holder_lock = 1

	cast(atom/target)
		if (..())
			return 1
		if (alert("Are we sure?","Speed Regenerate?","Yes","No") != "Yes")
			return 1
		var/mob/living/carbon/human/C = holder.owner
		if (!istype(C))
			boutput(holder.owner, __red("We have no idea what we are, but it's damn sure not compatible."))
			return 1
		boutput(holder.owner, __blue("Your skin begins reforming around your skeleton."))
		while(C.health < 100 || !C.limbs.l_arm || !C.limbs.r_arm || !C.limbs.l_leg || !C.limbs.r_leg)
			if(C.stat == 2)
				break
			sleep(30)
			changeling_super_heal_step(C)
