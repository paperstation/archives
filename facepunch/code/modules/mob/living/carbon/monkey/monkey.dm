/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	voice_message = "chimpers"
	say_message = "chimpers"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "monkey1"
	gender = NEUTER
	pass_flags = PASSTABLE
	update_icon = 0		///no need to call regenerate_icon

	var/obj/item/weapon/card/id/wear_id = null // Fix for station bounced radios -- Skie

	var/mob/living/target = null
	var/ai_active = 0//Just this will not make it do things, needs think called
	var/mainstate = 0//AI state
	var/special = 0//Infected supermonkey
	var/aggressiveness = 0//How likely are we to attack things
	var/count = 0//How many times we moved to try to do something


/mob/living/carbon/monkey/New()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	if(name == "monkey")
		name = text("monkey ([rand(1, 1000)])")
	real_name = name
	if (!(dna))
		if(gender == NEUTER)
			gender = pick(MALE, FEMALE)
		dna = new /datum/dna( null )
		dna.real_name = real_name
		dna.uni_identity = "00600200A00E0110148FC01300B009"
		dna.struc_enzymes = "0983E840344C39F4B059D5145FC5785DC6406A4BB8"
		dna.unique_enzymes = md5(name)
				//////////blah
		var/gendervar
		if (gender == MALE)
			gendervar = add_zero2(num2hex((rand(1,2049)),1), 3)
		else
			gendervar = add_zero2(num2hex((rand(2051,4094)),1), 3)
		dna.uni_identity += gendervar
		dna.uni_identity += "12C"
		dna.uni_identity += "4E2"
	..()
	return

/mob/living/carbon/monkey/movement_delay()
	var/tally = 0
	if(reagents)
		if(reagents.has_reagent("hyperzine")) return -1

		if(reagents.has_reagent("nuka_cola")) return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45) tally += (health_deficiency / 25)

	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75
	return tally+config.monkey_delay


/mob/living/carbon/monkey/Topic(href, href_list)
	..()
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)
	if ((href_list["item"] && !( usr.stat ) && !( usr.restrained() ) && in_range(src, usr) ))
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
		O.source = usr
		O.target = src
		O.item = usr.get_active_hand()
		O.s_loc = usr.loc
		O.t_loc = loc
		O.place = href_list["item"]
		requests += O
		spawn( 0 )
			O.process()
			return
	..()
	return

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M as mob)
	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.charge -= 2500
					deal_damage(5, WEAKEN)
					if(stuttering < 5)
						stuttering = 5
					visible_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>")
					return
				else
					M << "\red Not enough charge! "
					return

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if (M.a_intent == "hurt")
			if ((prob(75) && health > 0))
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has punched [name]!</B>", M), 1)

				playsound(loc, "punch", 25, 1, -1)
				if(prob(40))
					if(paralysis < 5)
						deal_damage(5, PARALYZE)
						visible_message("\red <B>[M] has knocked out [name]!</B>")
						return
				deal_damage(10, BRUTE, IMPACT, "chest")
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to punch [name]!</B>", M), 1)
		else
			if (M.a_intent == "grab")
				if (M == src)
					return

				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M, M, src )

				M.put_in_active_hand(G)

				grabbed_by += G
				G.synch()

				LAssailant = M

				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\red [] has grabbed [name] passively!", M), 1)
			else
				drop_item()
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has disarmed [name]!</B>", M), 1)
	return


/mob/living/carbon/monkey/Stat()
	..()
	statpanel("Status")
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))
	if(client && mind)
		if (client.statpanel == "Status")
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)
	return


/mob/living/carbon/monkey/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return

/mob/living/carbon/monkey/var/co2overloadtime = null
/mob/living/carbon/monkey/var/temperature_resistance = T0C+75


/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	if(!ticker)	return 0
	if(!ticker.mode.name == "monkey")	return 0
	return 1

