//Contains medical reagents / drugs.
datum
	reagent
		medical/
			name = "medical thing"

		medical/lexorin // COGWERKS CHEM REVISION PROJECT. this is a totally pointless reagent
			name = "lexorin"
			id = "lexorin"
			description = "Lexorin temporarily stops respiration. Causes tissue damage."
			reagent_state = LIQUID
			fluid_r = 125
			fluid_g = 195
			fluid_b = 160
			transparency = 80
			depletion_rate = 0.2
			value = 3

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_toxin_damage(1)
				M.updatehealth()
				..(M)
				return

		medical/spaceacillin
			name = "spaceacillin"
			id = "spaceacillin"
			description = "An all-purpose antibiotic agent extracted from space fungus."
			reagent_state = LIQUID
			fluid_r = 10
			fluid_g = 180
			fluid_b = 120
			transparency = 255
			depletion_rate = 0.2
			value = 3 // 2c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				for(var/datum/ailment_data/disease/virus in M.ailments)
					if (virus.cure == "Antibiotics")
						virus.state = "Remissive"
				..(M)
				return

		medical/morphine // // COGWERKS CHEM REVISION PROJECT. roll the antihistamine effects into this?
			name = "morphine"
			id = "morphine"
			description = "A strong but highly addictive opiate painkiller with sedative side effects."
			reagent_state = LIQUID
			fluid_r = 169
			fluid_g = 251
			fluid_b = 251
			transparency = 30
			addiction_prob = 50
			overdose = 20
			var/counter = 1 //Data is conserved...so some jerkbag could inject a monkey with this, wait for data to build up, then extract some instant KO juice.  Dumb.
			var/remove_buff = 0
			value = 5

			pooled()
				..()
				counter = 1
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_bad", -5)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_bad")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!counter) counter = 1
				M.jitteriness = max(M.jitteriness-25,0)

				switch(counter++)
					if(1 to 15)
						if(prob(7)) M.emote("yawn")
					if(16 to 35)
						M.drowsyness  = max(M.drowsyness, 20)
					if(36 to INFINITY)
						M.paralysis = max(M.paralysis, 15)
						M.drowsyness  = max(M.drowsyness, 20)

				..(M)
				return

		medical/ether
			name = "ether"
			id = "ether"
			description = "A strong but highly addictive anesthetic and sedative."
			reagent_state = LIQUID
			fluid_r = 169
			fluid_g = 251
			fluid_b = 251
			transparency = 30
			addiction_prob = 50
			overdose = 20
			var/counter = 1 //Data is conserved...so some jerkbag could inject a monkey with this, wait for data to build up, then extract some instant KO juice.  Dumb.
			var/remove_buff = 0
			value = 5

			pooled()
				..()
				counter = 1
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_bad", -5)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_bad")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!counter) counter = 1
				M.jitteriness = max(M.jitteriness-25,0)

				switch(counter++)
					if(1 to 15)
						if(prob(7)) M.emote("yawn")
					if(16 to 35)
						M.drowsyness  = max(M.drowsyness, 20)
					if(36 to INFINITY)
						M.paralysis = max(M.paralysis, 15)
						M.drowsyness  = max(M.drowsyness, 20)

				..(M)
				return

		medical/teporone // COGWERKS CHEM REVISION PROJECT. marked for revision
			name = "teporone"
			id = "teporone"
			description = "This experimental plasma-based compound seems to regulate body temperature."
			reagent_state = LIQUID
			fluid_r = 210
			fluid_g = 100
			fluid_b = 225
			transparency = 200
			addiction_prob = 20
			overdose = 50
			value = 7 // 5c + 1c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.make_jittery(2)
				if(M.bodytemperature < M.base_body_temp)
					M.bodytemperature = max(M.base_body_temp, M.bodytemperature-10)
				else if(M.bodytemperature > 311)
					M.bodytemperature = min(M.base_body_temp, M.bodytemperature+10)
				..(M)
				return

		medical/salicylic_acid
			name = "salicylic acid"
			id = "salicylic_acid"
			description = "This is a is a standard salicylate pain reliever and fever reducer."
			reagent_state = LIQUID
			fluid_r = 210
			fluid_g = 210
			fluid_b = 210
			transparency = 200
			overdose = 25
			depletion_rate = 0.1
			value = 11 // 5c + 3c + 1c + 1c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(55))
					M.HealDamage("All", 2, 0)
					M.updatehealth()
				if(M.bodytemperature > M.base_body_temp)
					M.bodytemperature = min(M.base_body_temp, M.bodytemperature+10)
				..(M)
				return

		medical/calomel // COGWERKS CHEM REVISION PROJECT. marked for revision. should be a chelation agent
			name = "calomel"
			id = "calomel"
			description = "This potent purgative rids the body of impurities. It is highly toxic however and close supervision is required."
			reagent_state = LIQUID
			fluid_r = 25
			fluid_g = 200
			fluid_b = 50
			depletion_rate = 0.8
			transparency = 200
			value = 3 // 1c + 1c + heat

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom

				for(var/reagent_id in M.reagents.reagent_list)
					if(reagent_id != id)
						M.reagents.remove_reagent(reagent_id, 5)
				M.updatehealth()
				if(M.health > 20)
					M.take_toxin_damage(5)
					M.updatehealth()
				if(prob(6))
					M.visible_message("<span style=\"color:red\">[M] pukes all over \himself.</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(M.loc)
				if(prob(4))
					M.emote("piss")
				..(M)
				return

		/*medical/tricalomel // COGWERKS CHEM REVISION PROJECT. marked for revision. also a chelation agent
			name = "Tricalomel"
			id = "tricalomel"
			description = "Tricalomel can be used to remove most non-natural compounds from an organism. It is slightly toxic however and supervision is required."
			reagent_state = LIQUID
			fluid_r = 33
			fluid_g = 255
			fluid_b = 75
			depletion_rate = 0.8
			transparency = 200
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				..(M)
				for(var/reagent_id in M.reagents.reagent_list)
					if(reagent_id != id)
						M.reagents.remove_reagent(reagent_id, 6)
				M.updatehealth()
				if(M.health > 18)
					M.take_toxin_damage(2)
					M.updatehealth()
				return  */


		medical/yobihodazine // COGWERKS CHEM REVISION PROJECT. probably just a magic drug, i have no idea what this is supposed to be
			name = "yobihodazine"
			id = "yobihodazine"
			description = "A powerful outlawed compound capable of preventing vaccuum damage. Prolonged use leads to neurological damage."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 255
			addiction_prob = 20
			value = 13

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < M.base_body_temp)
					M.bodytemperature = max(M.base_body_temp, M.bodytemperature-10)
				else if(M.bodytemperature > M.base_body_temp)
					M.bodytemperature = min(M.base_body_temp, M.bodytemperature+10)
				M.take_oxygen_deprivation(-INFINITY)
				if(prob(20))
					M.take_brain_damage(1)
				M.updatehealth()
				..(M)
				return

		medical/synthflesh
			name = "synthetic flesh"
			id = "synthflesh"
			description = "A resorbable microfibrillar collagen and protein mixture that can rapidly heal injuries when applied topically."
			reagent_state = SOLID
			fluid_r = 255
			fluid_b = 235
			fluid_g = 235
			transparency = 255
			value = 9 // 6c + 2c + 1c

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return
				if(method == TOUCH)
					for(var/A in M.organs)
						var/obj/item/affecting = null
						if(!M.organs[A])    continue
						affecting = M.organs[A]
						if(!istype(affecting, /obj/item))
							continue
						affecting.heal_damage(volume_passed*1.5, volume_passed*1.5)
					if (istype(M, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = M
						if (H.bleeding)
							H.bleeding = 0
					boutput(M, "<span style=\"color:blue\">The synthetic flesh integrates itself into your wounds, healing you.</span>")
					M.UpdateDamageIcon()
					M.updatehealth()
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 5)
					if(!locate(/obj/decal/cleanable/blood/gibs) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/blood/gibs(T)
			/*reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item/parts/robot_parts/robot_frame))
					if (O.check_completion() && volume >= 20)
						O.replicant = 1
						O.overlays = null
						O.icon_state = "repli_suit"
						O.name = "Unfinished Replicant"
						for(var/mob/V in AIviewers(O, null)) V.show_message(text("<span style=\"color:red\">The solution molds itself around [].</span>", O), 1)
					else
						for(var/mob/V in AIviewers(O, null)) V.show_message(text("<span style=\"color:red\">The solution fails to cling to [].</span>", O), 1)*/


		medical/synaptizine // COGWERKS CHEM REVISION PROJECT. remove this, make epinephrine (epinephrine) do the same thing
			name = "synaptizine"
			id = "synaptizine"
			description = "Synaptizine is used to treat neuroleptic shock. Can be used to help remove disabling symptoms such as paralysis."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 0
			fluid_b = 255
			transparency = 175
			overdose = 40
			var/remove_buff = 0
			value = 7

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 2)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.drowsyness = max(M.drowsyness-5, 0)
				if(M.paralysis) M.paralysis--
				if(M.stunned) M.stunned--
				if(M.weakened) M.weakened--
				if(M.sleeping) M.sleeping = 0
				if(M.get_brain_damage() && prob(50)) M.take_brain_damage(-1)
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if( effect <= 1)
						M.visible_message("<span style=\"color:red\">[M.name] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					else if (effect <= 3) M.emote(pick("groan","moan"))
					if (effect <= 8)
						M.take_toxin_damage(1)
				else if (severity == 2)
					if( effect <= 2)
						M.visible_message("<span style=\"color:red\">[M.name] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					else if (effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> staggers and drools, their eyes bloodshot!</span>")
						M.dizziness += 8
						M.weakened += 4
					if (effect <= 15)
						M.take_toxin_damage(1)

		medical/omnizine // COGWERKS CHEM REVISION PROJECT. magic drug, ought to use plasma or something
			name = "omnizine"
			id = "omnizine"
			description = "Omnizine is a highly potent healing medication that can be used to treat a wide range of injuries."
			reagent_state = LIQUID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 40
			addiction_prob = 5
			depletion_rate = 0.2
			overdose = 30
			value = 22

			on_mob_life(var/mob/M)
				if(!M)
					M = holder.my_atom
				if(M.get_oxygen_deprivation())
					M.take_oxygen_deprivation(-1)
				if(M.get_toxin_damage())
					M.take_toxin_damage(-1)
				if(M.losebreath && prob(50))
					M.lose_breath(-1)
				M.HealDamage("All", 2, 2, 1)
				if (istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if (H.bleeding && prob(33))
						H.bleeding--
				M.updatehealth()
				//M.UpdateDamageIcon()
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1) //lesser
					M.stuttering += 1
					if(effect <= 1)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> suddenly cluches their gut!</span>")
						M.emote("scream")
						M.stunned += 4
						M.weakened += 4
					else if(effect <= 3)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> completely spaces out for a moment.</span>")
						M.change_misstep_chance(15)
					else if(effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> stumbles and staggers.</span>")
						M.dizziness += 5
						M.weakened += 3
					else if(effect <= 7)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> shakes uncontrollably.</span>")
						M.make_jittery(30)
				else if (severity == 2) // greater
					if(effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> suddenly cluches their gut!</span>")
						M.emote("scream")
						M.stunned += 7
						M.weakened += 7
					else if(effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> jerks bolt upright, then collapses!</span>")
						M.paralysis += 5
						M.weakened += 4
					else if(effect <= 8)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> stumbles and staggers.</span>")
						M.dizziness += 5
						M.weakened += 3

		medical/saline // COGWERKS CHEM REVISION PROJECT. magic drug, ought to use plasma or something
			name = "saline-glucose solution"
			id = "saline"
			description = "This saline and glucose solution can help stabilize critically injured patients and cleanse wounds."
			reagent_state = LIQUID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 40
			penetrates_skin = 1 // splashing saline on someones wounds would sorta help clean them
			depletion_rate = 0.15
			value = 5 // 3c + 1c + 1c

			on_mob_life(var/mob/M)
				if (!M)
					M = holder.my_atom
				if (prob(33))
					M.HealDamage("All", 2, 2)
				if (blood_system && ishuman(M) && prob(33))
					var/mob/living/carbon/human/H = M
					if (H.blood_volume < 500)
						H.blood_volume ++
				M.updatehealth()
				//M.UpdateDamageIcon()
				..(M)
				return

		medical/anti_rad // COGWERKS CHEM REVISION PROJECT. replace with potassum iodide
			name = "potassium iodide"
			id = "anti_rad"
			description = "Potassium Iodide is a medicinal drug used to counter the effects of radiation poisoning."
			reagent_state = LIQUID
			fluid_r = 20
			fluid_g = 255
			fluid_b = 60
			transparency = 40
			value = 2 // 1c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.radiation && prob(80))
					M.irradiate(-1)
				..(M)
				return

		medical/smelling_salt
			name = "ammonium bicarbonate"
			id = "smelling_salt"
			description = "Ammonium bicarbonate ."
			reagent_state = LIQUID
			fluid_r = 20
			fluid_g = 255
			fluid_b = 60
			transparency = 40
			value = 3
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.radiation && prob(80))
					M.irradiate(-1)
				..(M)
				return

		medical/oculine // COGWERKS CHEM REVISION PROJECT. probably a magic drug, maybe ought to involve atropine
			name = "oculine"
			id = "oculine"
			description = "Oculine is a combined eye and ear medication with antibiotic effects."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 111
			penetrates_skin = 1
			value = 26 // 18 5 3

			// I've added hearing damage here (Convair880).
			on_mob_life(var/mob/M)
				if (!M)
					M = holder.my_atom

				if (M.bioHolder)
					if (prob(50) && M.bioHolder.HasEffect("bad_eyesight"))
						M.bioHolder.RemoveEffect("bad_eyesight")
					if (prob(30) && M.bioHolder.HasEffect("blind"))
						M.bioHolder.RemoveEffect("blind")
					if (prob(30) && (M.get_ear_damage() && M.get_ear_damage() <= M.get_ear_damage_natural_healing_threshold()) && M.bioHolder.HasEffect("deaf"))
						M.bioHolder.RemoveEffect("deaf")

				if (M.get_eye_blurry())
					M.change_eye_blurry(-1)

				if (M.get_eye_damage() && prob(80)) // Permanent eye damage.
					M.take_eye_damage(-1)

				if (M.get_eye_damage(1) && prob(50)) // Temporary blindness.
					M.take_eye_damage(-0.5, 1)

				if (M.get_ear_damage() && prob(80)) // Permanent ear damage.
					M.take_ear_damage(-1)

				if (M.get_ear_damage(1) && prob(50)) // Temporary deafness.
					M.take_ear_damage(-0.5, 1)

				..(M)
				return

		medical/haloperidol // COGWERKS CHEM REVISION PROJECT. ought to be some sort of shitty illegal opiate or hypnotic drug
			name = "haloperidol"
			id = "haloperidol"
			description = "Haloperidol is a powerful antipsychotic and sedative. Will help control psychiatric problems, but may cause brain damage."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 220
			fluid_b = 255
			transparency = 255
			var/remove_buff = 0
			value = 8 // 2c + 3c + 1c + 1c + 1c

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_bad", -5)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_bad")
				return

			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				M.jitteriness = max(M.jitteriness-50,0)
				if (M.druggy > 0)
					M.druggy -= 3
					M.druggy = max(0, M.druggy)
				if(holder.has_reagent("LSD"))
					holder.remove_reagent("LSD", 5)
				if(holder.has_reagent("psilocybin"))
					holder.remove_reagent("psilocybin", 5)
				if(holder.has_reagent("crank"))
					holder.remove_reagent("crank", 5)
				if(holder.has_reagent("bathsalts"))
					holder.remove_reagent("bathsalts", 5)
				if(holder.has_reagent("THC"))
					holder.remove_reagent("THC", 5)
				if(holder.has_reagent("space_drugs"))
					holder.remove_reagent("space_drugs", 5)
				if(holder.has_reagent("catdrugs"))
					holder.remove_reagent("catdrugs", 5)
				if(holder.has_reagent("methamphetamine"))
					holder.remove_reagent("methamphetamine", 5)
				if(holder.has_reagent("epinephrine"))
					holder.remove_reagent("epinephrine", 5)
				if(holder.has_reagent("ephedrine"))
					holder.remove_reagent("ephedrine", 5)
				if(holder.has_reagent("stimulants"))
					holder.remove_reagent("stimulants", 3)
				if(prob(5))
					for(var/datum/ailment_data/disease/virus in M.ailments)
						if(istype(virus.master,/datum/ailment/disease/space_madness) || istype(virus.master,/datum/ailment/disease/berserker))
							M.cure_disease(virus)
				if(prob(20)) M.take_brain_damage(1)
				if(prob(50)) M.drowsyness = max(M.drowsyness, 3)
				if(prob(10)) M.emote("drool")
				..(M)
				return

		medical/epinephrine // COGWERKS CHEM REVISION PROJECT. Could be Epinephrine instead
			name = "epinephrine"
			id = "epinephrine"
			description = "Epinephrine is a potent neurotransmitter, used in medical emergencies to halt anaphylactic shock and prevent cardiac arrest."
			reagent_state = LIQUID
			fluid_r = 210
			fluid_g = 255
			fluid_b = 250
			depletion_rate = 0.2
			overdose = 20
			var/remove_buff = 0
			value = 17 // 5c + 5c + 4c + 1c + 1c + 1c

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 2)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.bodytemperature = min(M.base_body_temp, M.bodytemperature+5)
				if(prob(10))
					M.make_jittery(4)
				M.drowsyness = max(M.drowsyness-5, 0)
				if(M.paralysis && prob(20)) M.paralysis--
				if(M.stunned && prob(20)) M.stunned--
				if(M.weakened && prob(20)) M.weakened--
				if(M.sleeping && prob(5)) M.sleeping = 0
				if(M.get_brain_damage() && prob(5)) M.take_brain_damage(-1)
				if(holder.has_reagent("histamine"))
					holder.remove_reagent("histamine", 15)
				if(M.losebreath > 3)
					M.losebreath--
				if(M.get_oxygen_deprivation() > 35)
					M.take_oxygen_deprivation(-10)
				if(M.health < -10 && M.health > -65)
					if(M.get_toxin_damage())
						M.take_toxin_damage(-1)
					M.HealDamage("All", 1, 1, 1)
				M.updatehealth()
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if( effect <= 1)
						M.visible_message("<span style=\"color:red\">[M.name] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					else if (effect <= 3) M.emote(pick("groan","moan"))
					if (effect <= 8) M.emote("collapse")
				else if (severity == 2)
					if( effect <= 2)
						M.visible_message("<span style=\"color:red\">[M.name] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					else if (effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> staggers and drools, their eyes bloodshot!</span>")
						M.dizziness += 2
						M.weakened += 3
					if (effect <= 15) M.emote("collapse")

		medical/insulin // COGWERKS CHEM REVISION PROJECT. does Medbay have this? should be in the medical vendor
			name = "insulin"
			id = "insulin"
			description = "A hormone generated by the pancreas responsible for metabolizing carbohydrates and fat in the bloodstream."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 240
			transparency = 50
			value = 6

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("sugar"))
					holder.remove_reagent("sugar", 5)
				//if(holder.has_reagent("cholesterol")) //probably doesnt actually happen but whatever
					//holder.remove_reagent("cholesterol", 2)
				..(M)
				return

		medical/silver_sulfadiazine // COGWERKS CHEM REVISION PROJECT. marked for revision
			name = "silver sulfadiazine"
			id = "silver_sulfadiazine"
			description = "This antibacterial compound is used to treat burn victims."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 220
			fluid_b = 0
			transparency = 225
			depletion_rate = 3
			value = 6 // 2c + 1c + 1c + 1c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				// Please don't set this to 8 again, medical patches add their contents to the bloodstream too.
				// Consequently, a single patch would heal ~200 damage (Convair880).
				M.HealDamage("All", 0, 2)
				M.UpdateDamageIcon()
				M.updatehealth()
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if (!volume_passed)
					return
				if (!ishuman(M))
					return
				if (method == TOUCH)
					for(var/A in M.organs)
						var/obj/item/affecting = null
						if(!M.organs[A])    continue
						affecting = M.organs[A]
						if (!istype(affecting, /obj/item))
							continue
						affecting.heal_damage(0, volume_passed)
					boutput(M, "<span style=\"color:blue\">The silver sulfadiazine soothes your burns.</span>")
					M.UpdateDamageIcon()
					M.updatehealth()
				else if (method == INGEST)
					boutput(M, "<span style=\"color:red\">You feel sick...</span>")
					if (volume_passed > 0)
						M.take_toxin_damage(volume_passed/2)
					M.updatehealth()


		medical/mutadone // COGWERKS CHEM REVISION PROJECT. - marked for revision. Magic bullshit chem, ought to be related to mutagen somehow
			name = "mutadone"
			id = "mutadone"
			description = "Mutadone is an experimental bromide that can cure genetic abnomalities."
			reagent_state = SOLID
			fluid_r = 80
			fluid_g = 150
			fluid_b = 200
			transparency = 255
			value = 9 // 5 3 1

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bioHolder && M.bioHolder.effects && M.bioHolder.effects.len) //One per cycle. We're having superpowered hellbastards and this is their kryptonite.
					var/datum/bioEffect/B = M.bioHolder.effects[pick(M.bioHolder.effects)]
					if (B && B.curable_by_mutadone)
						M.bioHolder.RemoveEffect(B.id)
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				var/datum/plantgenes/DNA = P.plantgenes
				if (!prob(20) && P.growth > 5)
					P.growth -= 5
				if (DNA.growtime > 0 && prob(50))
					DNA.growtime--
				if (DNA.harvtime > 0 && prob(50))
					DNA.harvtime--
				if (DNA.harvests < 0 && prob(50))
					DNA.harvests++
				if (DNA.cropsize < 0 && prob(50))
					DNA.cropsize++
				if (DNA.potency < 0 && prob(50))
					DNA.potency++
				if (DNA.endurance < 0 && prob(50))
					DNA.endurance++

		medical/ephedrine // COGWERKS CHEM REVISION PROJECT. poor man's epinephrine
			name = "ephedrine"
			id = "ephedrine"
			description = "Ephedrine is a plant-derived stimulant."
			reagent_state = LIQUID
			fluid_r = 210
			fluid_g = 255
			fluid_b = 250
			depletion_rate = 0.3
			overdose = 35
			addiction_prob = 25
			value = 9 // 4c + 3c + 1c + 1c
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 2)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.bodytemperature = min(M.base_body_temp, M.bodytemperature+5)
				M.make_jittery(4)
				M.drowsyness = max(M.drowsyness-5, 0)
				if(M.paralysis) M.paralysis--
				if(M.stunned) M.stunned--
				if(M.weakened) M.weakened--
				if(M.losebreath > 3)
					M.losebreath = max(5, M.losebreath-1)
				if(M.get_oxygen_deprivation() > 75)
					M.take_oxygen_deprivation(-1)
				if ((M.health < 0) || (M.health > 0 && prob(33)))
					if (M.get_toxin_damage() && prob(25))
						M.take_toxin_damage(-1)
					M.HealDamage("All", 1, 1)
				M.updatehealth()
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if( effect <= 1)
						M.visible_message("<span style=\"color:red\">[M.name] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					else if (effect <= 3) M.emote(pick("groan","moan"))
					if (effect <= 8)
						M.take_toxin_damage(1)
				else if (severity == 2)
					if( effect <= 2)
						M.visible_message("<span style=\"color:red\">[M.name] suddenly and violently vomits!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					else if (effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> staggers and drools, their eyes bloodshot!</span>")
						M.dizziness += 8
						M.weakened += 4
					if (effect <= 15)
						M.take_toxin_damage(1)


		medical/penteticacid // COGWERKS CHEM REVISION PROJECT. should be a potent chelation agent, maybe roll this into tribenzocytazine as Pentetic Acid
			name = "pentetic acid"
			id = "penteticacid"
			description = "Pentetic Acid is an aggressive chelation agent. May cause tissue damage. Use with caution."
			reagent_state = LIQUID
			fluid_r = 230
			fluid_g = 255
			fluid_b = 240
			transparency = 255
			value = 16 // 7 2 4 1 1 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				for (var/reagent_id in M.reagents.reagent_list)
					if (reagent_id != id)
						M.reagents.remove_reagent(reagent_id, 4)
				M.irradiate(-7)
				if (M.get_toxin_damage() && prob(75))
					M.take_toxin_damage(-4)
					M.HealDamage("All", 0, 0, 2)
				if (prob(33))
					M.TakeDamage("chest", 1, 1, 0, DAMAGE_BLUNT)
				M.updatehealth()
				..(M)
				return

		medical/antihistamine
			name = "diphenhydramine"
			id = "antihistamine"
			description = "Anti-allergy medication. May cause drowsiness, do not operate heavy machinery while using this."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_b = 255
			fluid_g = 230
			transparency = 220
			addiction_prob = 10
			var/remove_buff = 0
			value = 10 // 4 3 1 1 1

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_bad", -3)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_bad")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.jitteriness = max(M.jitteriness-20,0)
				if(holder.has_reagent("histamine"))
					holder.remove_reagent("histamine", 3)
				if(holder.has_reagent("itching"))
					holder.remove_reagent("itching", 3)
				if(prob(7)) M.emote("yawn")
				if(prob(3))
					M.stunned += 2
					M.drowsyness++
					M.visible_message("<span style=\"color:blue\"><b>[M.name]<b> looks a bit dazed.</span>")
				..(M)
				return

		medical/stypic_powder // // COGWERKS CHEM REVISION PROJECT. marked for revision
			name = "styptic powder"
			id = "stypic_powder"
			description = "Styptic (aluminium sulfate) powder helps control bleeding and heal physical wounds."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 150
			fluid_b = 150
			transparency = 255
			depletion_rate = 3
			value = 6 // 3c + 1c + 1c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				// Please don't set this to 8 again, medical patches add their contents to the bloodstream too.
				// Consequently, a single patch would heal ~200 damage (Convair880).
				M.HealDamage("All", 2, 0)
				M.UpdateDamageIcon()
				M.updatehealth()
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M)) // fucking human shitfucks
					return
				if(method == TOUCH)
					M.HealDamage("All", volume_passed, 0)
					// M.HealBleeding(volume_passed) // At least implement your stuff properly first, thanks. Styptic also shouldn't be as good as synthflesh for healing bleeding.

					/*for(var/A in M.organs)
						var/obj/item/affecting = null
						if(!M.organs[A])    continue
						affecting = M.organs[A]
						if(!istype(affecting, /obj/item/organ))    continue
						affecting.heal_damage(volume_passed, 0)*/

					if (istype(M, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = M
						if (H.bleeding)
							H.bleeding = min(H.bleeding, rand(0,5))

					boutput(M, "<span style=\"color:blue\">The styptic powder stings like hell as it closes some of your wounds.</span>")
					M.emote("scream")
					M.UpdateDamageIcon()
					M.updatehealth()
				else if(method == INGEST)
					boutput(M, "<span style=\"color:red\">You feel gross!</span>")
					if (volume_passed > 0)
						M.take_toxin_damage(volume_passed/2)
					M.updatehealth()

		medical/cryoxadone // COGWERKS CHEM REVISION PROJECT. magic drug, but isn't working right correctly
			name = "cryoxadone"
			id = "cryoxadone"
			description = "A plasma mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 265K for it to metabolise correctly."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 200
			transparency = 255
			value = 12 // 5 3 3 1

			/*reaction_temperature(exposed_temperature, exposed_volume)
				var/myvol = volume

				if(exposed_temperature > T0C + 50) //Turns into omnizine. Derp.
					volume = 0
					holder.add_reagent("omnizine", myvol, null)

				return*/

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < M.base_body_temp - 45)
					if(M.get_oxygen_deprivation())
						M.take_oxygen_deprivation(-10)
					if(M.get_toxin_damage())
						M.take_toxin_damage(-3)
					M.HealDamage("All", 12, 12)

				M.updatehealth()
				if(prob(25)) M.UpdateDamageIcon() // gonna leave this one on for now, but only call it a quarter of the time
				..(M)

		medical/atropine // COGWERKS CHEM REVISION PROJECT. i dunno what the fuck this would be, probably something bad. maybe atropine?
			name = "atropine"
			id = "atropine"
			description = "Atropine is a potent cardiac resuscitant but it can causes confusion, dizzyness and hyperthermia."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 255
			depletion_rate = 0.2
			overdose = 25
			var/remove_buff = 0
			value = 18 // 5 4 5 3 1

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					remove_buff = holder.my_atom:add_stam_mod_max("consumable_good", 5)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
						holder.my_atom:remove_stam_mod_max("consumable_good")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.make_dizzy(1)
				M.change_misstep_chance(5)
				if(M.bodytemperature < M.base_body_temp)
					M.bodytemperature = max(M.base_body_temp + 10, M.bodytemperature-10)
				if(prob(4)) M.emote("collapse")
				if(M.losebreath > 5)
					M.losebreath = max(5, M.losebreath-5)
				if(M.get_oxygen_deprivation() > 65)
					M.take_oxygen_deprivation(-10)
				if(M.health < -25)
					if(M.get_toxin_damage())
						M.take_toxin_damage(-1)
					M.HealDamage("All", 3, 3)
				else if (M.health > -60)
					M.take_toxin_damage(1)
				if(M.reagents.has_reagent("sarin"))
					M.reagents.remove_reagent("sarin",20)
				M.updatehealth()
				..(M)
				return

		medical/salbutamol // COGWERKS CHEM REVISION PROJECT. marked for revision. Could be Dexamesathone
			name = "salbutamol"
			id = "salbutamol"
			description = "Salbutamol is a common bronchodilation medication for asthmatics. It may help with other breathing problems as well."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 255
			fluid_b = 255
			transparency = 255
			depletion_rate = 0.2
			value = 16 // 11 2 1 1 1

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_oxygen_deprivation(-6)
				if(M.losebreath)
					M.losebreath = max(0, M.losebreath-4)
				M.updatehealth()
				..(M)
				return

		medical/perfluorodecalin
			name = "perfluorodecalin"
			id = "perfluorodecalin"
			description = "This experimental perfluoronated solvent has applications in liquid breathing and tissue oxygenation. Use with caution."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 100
			fluid_b = 100
			transparency = 40
			addiction_prob = 20
			value = 6 // 3 1 1 heat

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_oxygen_deprivation(-25)
				if(src.volume >= 4) // stop killing dudes goddamn
					M.losebreath = max(6, M.losebreath)
				if(prob(33)) // has some slight healing properties due to tissue oxygenation
					M.HealDamage("All", 1, 1)
					M.updatehealth()
				M.updatehealth()
				..(M)
				return

		medical/mannitol
			name = "mannitol"
			id = "mannitol"
			description = "Mannitol is a sugar alcohol that can help alleviate cranial swelling."
			reagent_state = LIQUID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 255
			transparency = 240
			value = 3 // 1 1 1

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_brain_damage(-3)
				..(M)
				return

		medical/charcoal
			name = "charcoal"
			id = "charcoal"
			description = "Activated charcoal helps to absorb toxins."
			reagent_state = SOLID
			fluid_r = 0
			fluid_b = 0
			fluid_g = 0
			value = 5 // 3c + 1c + heat

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				for(var/reagent_id in M.reagents.reagent_list)
					if(reagent_id != id && prob(50)) // slow this down a bit
						M.reagents.remove_reagent(reagent_id, 1)
				M.take_toxin_damage(-1.5)
				M.HealDamage("All", 0, 0, 1)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				if(P.reagents.has_reagent("toxin"))
					P.reagents.remove_reagent("toxin", 2)
				if(P.reagents.has_reagent("toxic_slurry"))
					P.reagents.remove_reagent("toxic_slurry", 2)
				if(P.reagents.has_reagent("acid"))
					P.reagents.remove_reagent("acid", 2)
				if(P.reagents.has_reagent("plasma"))
					P.reagents.remove_reagent("plasma", 2)
				if(P.reagents.has_reagent("mercury"))
					P.reagents.remove_reagent("mercury", 2)
				if(P.reagents.has_reagent("fuel"))
					P.reagents.remove_reagent("fuel", 2)
				if(P.reagents.has_reagent("chlorine"))
					P.reagents.remove_reagent("chlorine", 2)
				if(P.reagents.has_reagent("radium"))
					P.reagents.remove_reagent("radium", 2)

		medical/antihol // COGWERKS CHEM REVISION PROJECT. maybe a diuretic or some sort of goofy common hangover cure
			name = "antihol"
			id = "antihol"
			description = "A medicine which quickly eliminates alcohol in the body."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_b = 180
			fluid_g = 200
			transparency = 220
			value = 6 // 5c + 1c

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("ethanol")) holder.remove_reagent("ethanol", 8)
				if (M.get_toxin_damage() <= 25)
					M.take_toxin_damage(-2)
					M.updatehealth()
				..(M)
				return
