//Contains wacky space drugs
datum
	reagent
		drug/
			name = "some drug"

		drug/bathsalts
			name = "bath salts"
			id = "bathsalts"
			description = "Sometimes packaged as a refreshing bathwater additive, these crystals are definitely not for human consumption."
			reagent_state = SOLID
			fluid_r = 250
			fluid_g = 250
			fluid_b = 250
			transparency = 100
			addiction_prob = 80
			overdose = 20
			depletion_rate = 0.6
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 3)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/M) // commence bad times
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/K = M
					if (K.sims)
						K.sims.affectMotive("energy", 2)
						K.sims.affectMotive("fun", 1)
						K.sims.affectMotive("bladder", -0.5)
						K.sims.affectMotive("hunger", -1)
						K.sims.affectMotive("thirst", -2)
				var/mob/living/carbon/human/H = M
				var/check = rand(0,100)
				if (istype(H))
					if (check < 8 && H.cust_two_state != "tramp") // M.is_hobo = very yes
						H.cust_two_state = "tramp"
						H.set_face_icon_dirty()
						boutput(M, "<span style=\"color:red\"><b>You feel gruff!</b></span>")
						spawn(3)
							M.visible_message("<span style=\"color:red\"><b>[M.name]</b> has a wild look in their eyes!</span>")
					if(check < 60)
						if(H.paralysis) H.paralysis = 0
						if(H.stunned) H.stunned = 0
						if(H.weakened) H.weakened = 0
					if(check < 30)
						H.emote(pick("twitch", "twitch_s", "scream", "drool", "grumble", "mumble"))

				M.druggy = max(M.druggy, 15)
				if(check < 20)
					M.change_misstep_chance(10)
				// a really shitty form of traitor stimulants - you'll be tough to take down but nearly uncontrollable anyways and you won't heal the way stims do


				if(check < 8)
					M.reagents.add_reagent(pick("methamphetamine", "crank", "neurotoxin"), rand(1,5))
					M.visible_message("<span style=\"color:red\"><b>[M.name]</b> scratches at something under their skin!</span>")
					random_brute_damage(M, 5)
				else if (check < 16)
					switch(rand(1,2))
						if(1)
							if(prob(20))
								fake_attackEx(M, 'icons/misc/critter.dmi', "death", "death")
								boutput(M, "<span style=\"color:red\"><b>OH GOD LOOK OUT!!!</b>!</span>")
								M.emote("scream")
								M.playsound_local(M.loc, 'sound/effects/bell.ogg', 50, 1)
							else if(prob(50))
								fake_attackEx(M, 'icons/misc/critter.dmi', "mimicface", "smiling thing")
								boutput(M, "<span style=\"color:red\"><b>The smiling thing</b> laughs!</span>")
								M.playsound_local(M.loc, pick("sound/voice/cluwnelaugh1.ogg", "sound/voice/cluwnelaugh2.ogg", "sound/voice/cluwnelaugh3.ogg"), 50, 1)
							else
								M.playsound_local(M.loc, pick('sound/machines/ArtifactEld1.ogg', 'sound/machines/ArtifactEld2.ogg'), 50, 1)
								boutput(M, "<span style=\"color:red\"><b>You hear something strange behind you...</b></span>")
								var/ants = rand(1,3)
								for(var/i = 0, i < ants, i++)
									fake_attackEx(M, 'icons/effects/genetics.dmi', "epileptic", "stranger")
						if(2)
							var/halluc_state = null
							var/halluc_name = null
							switch(rand(1,5))
								if(1)
									halluc_state = "husk"
									halluc_name = pick("dad", "mom")
								if(2)
									halluc_state = "fire3"
									halluc_name = pick("vision of your future", "dad", "mom")
								if(3)
									halluc_state = "eaten"
									halluc_name = pick("???", "bad bad BAD")
								if(4)
									halluc_state = "decomp3"
									halluc_name = pick("result of your poor life decisions", "grampa")
								if(5)
									halluc_state = "fire2"
									halluc_name = pick("mom", "dad", "why are they burning WHY")
							fake_attackEx(M, 'icons/mob/human.dmi', halluc_state, halluc_name)
				else if(check < 24)
					boutput(M, "<span style=\"color:red\"><b>They're coming for you!</b></span>")
				else if(check < 28)
					boutput(M, "<span style=\"color:red\"><b>THEY'RE GONNA GET YOU!</b></span>")
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == INGEST)
					boutput(M, "<span style=\"color:red\"><font face='[pick("Curlz MT", "Comic Sans MS")]' size='[rand(4,6)]'>You feel FUCKED UP!!!!!!</font></span>")
					M.playsound_local(M.loc, 'sound/effects/heartbeat.ogg', 50, 1)
					M.emote("faint")
					//var/mob/living/carbon/human/H = M
					//if (istype(H))
					M.irradiate(5,1)
					M.take_toxin_damage(5)
					M.take_brain_damage(10)
					M.updatehealth()
				else
					boutput(M, "<span style=\"color:blue\">You feel a bit more salty than usual.</span>")
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> flails around like a lunatic!</span>")
						M.change_misstep_chance(25)
						M.make_jittery(10)
						M.emote("scream")
						M.reagents.add_reagent("salts1", 5)
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> eyes dilate!</span>")
						M.emote("twitch_s")
						M.take_toxin_damage(2)
						M.take_brain_damage(1)
						M.updatehealth()
						M.stunned += 3
						M.change_eye_blurry(7, 7)
						M.reagents.add_reagent("salts1", 5)
					else if (effect <= 7)
						M.emote("faint")
						M.reagents.add_reagent("salts1", 5)
				else if (severity == 2)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> eyes dilate!</span>")
						M.take_toxin_damage(2)
						M.take_brain_damage(1)
						M.updatehealth()
						M.stunned += 3
						M.change_eye_blurry(7, 7)
						M.reagents.add_reagent("salts1", 5)
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> convulses violently and falls to the floor!</span>")
						M.make_jittery(50)
						M.take_toxin_damage(2)
						M.take_brain_damage(1)
						M.updatehealth()
						M.weakened += 8
						M.emote("gasp")
						M.reagents.add_reagent("salts1", 5)
					else if (effect <= 7)
						M.emote("scream")
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> tears at their own skin!</span>")
						random_brute_damage(M, 5)
						M.reagents.add_reagent("salts1", 5)
						M.emote("twitch")


		drug/jenkem
			name = "jenkem"
			id = "jenkem"
			description = "Jenkem is a prison drug made from fermenting feces in a solution of urine. Extremely disgusting."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 70
			fluid_b = 0
			transparency = 255
			addiction_prob = 30
			value = 2 // 1 1  :I

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("energy", -1)
						H.sims.affectMotive("fun", 3)
						H.sims.affectMotive("bladder", -0.5)
						H.sims.affectMotive("thirst", -2)
				M.make_dizzy(5)
				if(prob(10))
					M.emote(pick("twitch","drool","moan"))
					M.take_toxin_damage(1)
					M.updatehealth()
				..(M)
				return

		drug/crank
			name = "crank" // sort of a shitty version of methamphetamine that can be made by assistants
			id = "crank"
			description = "A cheap and dirty stimulant drug, commonly used by space biker gangs."
			reagent_state = SOLID
			fluid_r = 250
			fluid_b = 0
			fluid_g = 200
			transparency = 40
			addiction_prob = 50
			overdose = 20
			value = 20 // 10 2 1 3 1 heat explosion :v

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("energy", 1)
						H.sims.affectMotive("fun", 0.25)
						H.sims.affectMotive("bladder", -0.25)
						H.sims.affectMotive("hunger", -0.5)
						H.sims.affectMotive("thirst", -0.5)
						H.sims.affectMotive("comfort", -0.25)
				if(M.paralysis) M.paralysis-=2
				if(M.stunned) M.stunned-=2
				if(M.weakened) M.weakened-=2
				if(prob(15)) M.emote(pick("twitch", "twitch_s", "grumble", "laugh"))
				if(prob(8))
					boutput(M, "<span style=\"color:blue\"><b>You feel great!</b></span>")
					M.reagents.add_reagent("methamphetamine", rand(1,2))
					M.emote(pick("laugh", "giggle"))
				if(prob(6))
					boutput(M, "<span style=\"color:blue\"><b>You feel warm.</b></span>")
					M.bodytemperature += rand(1,10)
				if(prob(4))
					boutput(M, "<span style=\"color:red\"><b>You feel kinda awful!</b></span>")
					M.take_toxin_damage(1)
					M.updatehealth()
					M.make_jittery(30)
					M.emote(pick("groan", "moan"))
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> looks confused!</span>")
						M.change_misstep_chance(20)
						M.make_jittery(20)
						M.emote("scream")
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> is all sweaty!</span>")
						M.bodytemperature += rand(5,30)
						M.take_brain_damage(1)
						M.take_toxin_damage(1)
						M.updatehealth()
						M.stunned += 2
					else if (effect <= 7)
						M.make_jittery(30)
						M.emote("grumble")
				else if (severity == 2)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> is sweating like a pig!</span>")
						M.bodytemperature += rand(20,100)
						M.take_toxin_damage(5)
						M.updatehealth()
						M.stunned += 3
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> starts tweaking the hell out!</span>")
						M.make_jittery(100)
						M.take_toxin_damage(2)
						M.take_brain_damage(8)
						M.updatehealth()
						M.weakened += 3
						M.change_misstep_chance(25)
						M.emote("scream")
						M.reagents.add_reagent("salts1", 5)
					else if (effect <= 7)
						M.emote("scream")
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> nervously scratches at their skin!</span>")
						M.make_jittery(10)
						random_brute_damage(M, 5)
						M.emote("twitch")

		drug/LSD
			name = "lysergic acid diethylamide"
			id = "LSD"
			description = "A highly potent hallucinogenic substance. Far out, maaaan."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 255
			transparency = 20
			value = 6 // 4 2

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 2)
						H.sims.affectMotive("thirst", -2)
				M.druggy = max(M.druggy, 15)
				// TODO. Write awesome hallucination algorithm!
//				if(M.canmove) step(M, pick(cardinal))
//				if(prob(7)) M.emote(pick("twitch","drool","moan","giggle"))
				if(prob(6))
					switch(rand(1,2))
						if(1)
							if(prob(50))
								fake_attack(M)
							else
								var/monkeys = rand(1,3)
								for(var/i = 0, i < monkeys, i++)
									fake_attackEx(M, 'icons/mob/monkey.dmi', "monkey1", "monkey ([rand(1, 1000)])")
						if(2)
							var/halluc_state = null
							var/halluc_name = null
							switch(rand(1,5))
								if(1)
									halluc_state = "pig"
									halluc_name = pick("pig", "DAT FUKKEN PIG")
								if(2)
									halluc_state = "spider"
									halluc_name = pick("giant black widow", "queen bitch spider", "OH FUCK A SPIDER")
								if(3)
									halluc_state = "dragon"
									halluc_name = pick("dragon", "Lord Cinderbottom", "SOME FUKKEN LIZARD THAT BREATHES FIRE")
								if(4)
									halluc_state = "slime"
									halluc_name = pick("red slime", "some gooey thing", "ANGRY CRIMSON POO")
								if(5)
									halluc_state = "shambler"
									halluc_name = pick("shambler", "strange creature", "OH GOD WHAT THE FUCK IS THAT THING?")
							fake_attackEx(M, 'icons/effects/hallucinations.dmi', halluc_state, halluc_name)
				if(prob(9))
					M.playsound_local(M.loc, pick("explosion", "punch", 'sound/vox/poo-vox.ogg', "clownstep", 'sound/weapons/armbomb.ogg', 'sound/weapons/Gunshot.ogg'), 50, 1)
				if(prob(8))
					boutput(M, "<b>You hear a voice in your head... <i>[pick(loggedsay)]</i></b>")
				..(M)
				return
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == INGEST)
					boutput(M, "<span style=\"color:red\"><font face='[pick("Arial", "Georgia", "Impact", "Mucida Console", "Symbol", "Tahoma", "Times New Roman", "Verdana")]' size='[rand(3,6)]'>Holy shit, you start tripping balls!</font></span>")
				return

		drug/space_drugs
			name = "space drugs"
			id = "space_drugs"
			description = "An illegal chemical compound used as a cheap drug."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_g = 185
			fluid_b = 230
			addiction_prob = 65
			depletion_rate = 0.2
			value = 3 // 1c + 1c + 1c

			reaction_temperature(exposed_temperature, exposed_volume)
				var/myvol = volume
				if(exposed_temperature > T0C + 400) //Turns into a neurotoxin.
					volume = 0
					holder.add_reagent("neurotoxin", myvol, null)
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 1)
						H.sims.affectMotive("thirst", -1)
				M.druggy = max(M.druggy, 15)
				if(M.canmove && isturf(M.loc))
					step(M, pick(cardinal))
				if(prob(7)) M.emote(pick("twitch","drool","moan","giggle"))
				..(M)
				return

		drug/THC
			name = "tetrahydrocannabinol"
			id = "THC"
			description = "A mild psychoactive chemical extracted from the cannabis plant."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 225
			fluid_b = 0
			transparency = 200
			value = 3

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 2.5)
						H.sims.affectMotive("hunger", -2)
						H.sims.affectMotive("thirst", -2)
						H.sims.affectMotive("comfort", 2.5)
				M.stuttering += rand(0,2)
				if(prob(5))
					M.emote(pick("laugh","giggle","smile"))
				if(prob(5))
					boutput(M, "[pick("You feel hungry.","Your stomach rumbles.","You feel cold.","You feel warm.")]")
				if(prob(4))
					M.change_misstep_chance(10)
				if (holder.get_reagent_amount(src.id) >= 50 && prob(25))
					if(prob(10))
						M.drowsyness = 10
				..(M)
				return

		drug/nicotine
			name = "nicotine"
			id = "nicotine"
			description = "A highly addictive stimulant extracted from the tobacco plant."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 190
			addiction_prob = 70
			overdose = 35 // raise if too low - trying to aim for one sleepypen load being problematic, two being deadlyish
			//var/counter = 1
			//note that nicotine is also horribly poisonous in concentrated form IRM - could be used as a poor-man's toxin?
			//just comment that out if you don't think it's any good.
			// Gonna try this out. Not good for you but won't horribly maim you from taking a quick puff of a cigarette - ISN
			var/remove_buff = 0
			value = 3

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 1)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/M)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 0.2)
				if(prob(50))
					M.make_jittery(5)
					if(M.paralysis) M.paralysis--
					if(M.stunned) M.stunned--
					if(M.weakened) M.weakened--

				if(src.volume > src.overdose)
					M.take_toxin_damage(1)
					M.updatehealth()
				..(M)

			//cogwerks - improved nicotine poisoning?
			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> looks nervous!</span>")
						M.change_misstep_chance(15)
						M.take_toxin_damage(2)
						M.make_jittery(10)
						M.emote("twitch")
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> is all sweaty!</span>")
						M.bodytemperature += rand(15,30)
						M.take_toxin_damage(3)
						M.updatehealth()
					else if (effect <= 7)
						M.take_toxin_damage(4)
						M.updatehealth()
						M.emote("twitch_v")
						M.make_jittery(10)
				else if (severity == 2)
					if (effect <= 2)
						M.emote("gasp")
						boutput(M, "<span style=\"color:red\"><b>You can't breathe!</b></span>")
						M.take_oxygen_deprivation(15)
						M.take_toxin_damage(3)
						M.updatehealth()
						M.stunned++
					else if (effect <= 4)
						boutput(M, "<span style=\"color:red\"><b>You feel terrible!</b></span>")
						M.emote("drool")
						M.make_jittery(10)
						M.take_toxin_damage(5)
						M.updatehealth()
						M.weakened++
						M.change_misstep_chance(33)
					else if (effect <= 7)
						M.emote("collapse")
						boutput(M, "<span style=\"color:red\"><b>Your heart is pounding!</b></span>")
						M << sound('sound/effects/heartbeat.ogg')
						M.paralysis = max(M.paralysis, 5)
						M.make_jittery(30)
						M.take_toxin_damage(6)
						M.take_oxygen_deprivation(20)
						M.updatehealth()

		drug/psilocybin
			name = "psilocybin"
			id = "psilocybin"
			description = "A powerful hallucinogenic chemical produced by certain mushrooms."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 230
			fluid_b = 200
			transparency = 200
			value = 3

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 1.5)
						H.sims.affectMotive("thirst", -2)
				M.druggy = max(M.druggy, 15)
				if(prob(8))
					boutput(M, "<b>You hear a voice in your head... <i>[pick(loggedsay)]</i></b>")
				if(prob(8))
					M.emote(pick("scream","cry","laugh","moan","shiver"))
				if(prob(3))
					switch (rand(1,3))
						if(1)
							boutput(M, "<B>The Emergency Shuttle has docked with the station! You have 3 minutes to board the Emergency Shuttle.</B>")
						if(2)
							boutput(M, "<span style=\"color:red\"><b>Restarting world!</b> </span><span style=\"color:blue\">Initiated by Administrator!</span>")
							spawn(20) M.playsound_local(M.loc, pick('sound/misc/NewRound.ogg', 'sound/misc/NewRound2.ogg', 'sound/misc/NewRound3.ogg', 'sound/misc/NewRound4.ogg'), 50, 1)
						if(3)
							switch (rand(1,4))
								if(1)
									boutput(M, "<span style=\"color:red\"><b>Unknown fires the revolver at [M]!</b></span>")
									M.playsound_local(M.loc, 'sound/weapons/Gunshot.ogg', 50, 1)
								if(2)
									boutput(M, "<span style=\"color:red\"><b>[M] has been attacked with the fire extinguisher by Unknown</b></span>")
									M.playsound_local(M.loc, 'sound/weapons/smash.ogg', 50, 1)
								if(3)
									boutput(M, "<span style=\"color:red\"><b>Unknown has punched [M]</b></span>")
									boutput(M, "<span style=\"color:red\"><b>Unknown has weakened [M]</b></span>")
									M.weakened += 10
									M.playsound_local(M.loc, 'sound/weapons/punch1.ogg', 50, 1)
								if(4)
									boutput(M, "<span style=\"color:red\"><b>[M] has been attacked with the taser gun by Unknown</b></span>")
									boutput(M, "<i>You can almost hear someone talking...</i>")
									M.paralysis = max(M.paralysis, 3)
				..(M)


		drug/krokodil
			name = "krokodil"
			id = "krokodil"
			description = "A sketchy homemade opiate, often used by disgruntled Cosmonauts."
			reagent_state = SOLID
			fluid_r = 0
			fluid_g = 100
			fluid_b = 180
			transparency = 250
			addiction_prob = 50
			overdose = 20

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 5)
						H.sims.affectMotive("hunger", -3)
						H.sims.affectMotive("thirst", -3)
				M.jitteriness -= 40
				if(prob(25)) M.take_brain_damage(1)
				if(prob(15)) M.emote(pick("smile", "grin", "yawn", "laugh", "drool"))
				if(prob(10))
					boutput(M, "<span style=\"color:blue\"><b>You feel pretty chill.</b></span>")
					M.bodytemperature--
					M.emote("smile")
				if(prob(5))
					boutput(M, "<span style=\"color:red\"><b>You feel too chill!</b></span>")
					M.emote(pick("yawn", "drool"))
					M.stunned++
					M.take_toxin_damage(1)
					M.take_brain_damage(1)
					M.bodytemperature -= 20
					M.updatehealth()
				if(prob(2))
					boutput(M, "<span style=\"color:red\"><b>Your skin feels all rough and dry.</b></span>")
					random_brute_damage(M, 2)
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> looks dazed!</span>")
						M.stunned += 3
						M.emote("drool")
					else if (effect <= 4)
						M.emote("shiver")
						M.bodytemperature -= 40
					else if (effect <= 7)
						boutput(M, "<span style=\"color:red\"><b>Your skin is cracking and bleeding!</b></span>")
						random_brute_damage(M, 5)
						M.take_toxin_damage(2)
						M.take_brain_damage(1)
						M.updatehealth()
						M.emote("cry")
				else if (severity == 2)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> sways and falls over!</span>")
						M.take_toxin_damage(3)
						M.take_brain_damage(3)
						M.updatehealth()
						M.weakened += 8
						M.emote("faint")
					else if (effect <= 4)
						if(ishuman(M))
							M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> skin is rotting away!</span>")
							random_brute_damage(M, 25)
							M.emote("scream")
							M.bioHolder.AddEffect("eaten") //grody. changed line in human.dm to use decomp1 now
							M.emote("faint")
					else if (effect <= 7)
						M.emote("shiver")
						M.bodytemperature -= 70

		drug/catdrugs
			name = "cat drugs"
			id = "catdrugs"
			description = "Uhhh..."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 0
			transparency = 20

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("fun", 1)
						H.sims.affectMotive("thirst", -1)
				M.druggy = max(M.druggy, 15)
				if(prob(11))
					M.visible_message("<span style=\"color:blue\"><b>[M.name]</b> hisses!</span>")
					playsound(M.loc, "sound/effects/cat_hiss.ogg", 50, 1)
				if(prob(9))
					M.visible_message("<span style=\"color:blue\"><b>[M.name]</b> meows! What the fuck?</span>")
					playsound(M.loc, "sound/effects/cat.ogg", 50, 1)
				if(prob(7))
					switch(rand(1,2))
						if(1)
							var/ghostcats = rand(1,3)
							for(var/i = 0, i < ghostcats, i++)
								fake_attackEx(M, 'icons/misc/critter.dmi', "cat-ghost", "ghost cat")
								M.playsound_local(M.loc, pick('sound/effects/cat.ogg', 'sound/effects/cat_hiss.ogg'), 50, 1)
						if(2)
							var/spazcats = rand(1,3)
							for(var/i = 0, i < spazcats, i++)
								fake_attackEx(M, 'icons/misc/critter.dmi', "cat1-spaz", "wild cat")
								M.playsound_local(M.loc, pick('sound/effects/cat.ogg', 'sound/effects/cat_hiss.ogg'), 50, 1)
				if(prob(20))
					M.playsound_local(M.loc, pick('sound/effects/cat.ogg', 'sound/effects/cat_hiss.ogg'), 50, 1)
				..(M)
				return
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == INGEST)
					M.playsound_local(M.loc, pick('sound/effects/cat.ogg', 'sound/effects/cat_hiss.ogg'), 50, 1)
					boutput(M, "<span style=\"color:red\"><font face='[pick("Arial", "Georgia", "Impact", "Mucida Console", "Symbol", "Tahoma", "Times New Roman", "Verdana")]' size='[rand(3,6)]'>Holy shit, you start tripping balls!</font></span>")
				return

		drug/triplemeth
			name = "triple meth"
			id = "triplemeth"
			description = "Hot damn ... i don't even ..."
			reagent_state = SOLID
			fluid_r = 250
			fluid_g = 250
			fluid_b = 250
			transparency = 220
			addiction_prob = 100
			overdose = 20
			depletion_rate = 0.2
			value = 39 // 13c * 3  :v

			on_add()
				return

			on_remove()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
					holder.my_atom:remove_stam_mod_regen("triplemeth")

				if(hascall(holder.my_atom,"removeOverlayComposition"))
					holder.my_atom:removeOverlayComposition(/datum/overlayComposition/triplemeth)

				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("energy", 5)
						H.sims.affectMotive("fun", 2.5)
						H.sims.affectMotive("bladder", -2.5)
						H.sims.affectMotive("hunger", -3)
						H.sims.affectMotive("thirst", -3)
						H.sims.affectMotive("comfort", -2)
				if(holder.has_reagent("methamphetamine")) return ..(M) //Since is created by a meth overdose, dont react while meth is in their system.

				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					holder.my_atom:add_stam_mod_regen("triplemeth", 1000)

				if(hascall(holder.my_atom,"addOverlayComposition"))
					holder.my_atom:addOverlayComposition(/datum/overlayComposition/triplemeth)

				if(prob(50)) M.emote(pick("twitch","blink_r","shiver"))
				M.make_jittery(5)
				M.make_dizzy(5)
				M.change_misstep_chance(15)
				M.take_brain_damage(1)
				if(M.paralysis) M.paralysis = 0
				if(M.stunned) M.stunned = 0
				if(M.weakened) M.weakened = 0
				if(M.sleeping) M.sleeping = 0
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if(holder.has_reagent("methamphetamine")) return ..(M) //Since is created by a meth overdose, dont react while meth is in their system.
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> can't seem to control their legs!</span>")
						M.change_misstep_chance(12)
						M.weakened += 4
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> hands flip out and flail everywhere!</span>")
						M.drop_item()
						M.hand = !M.hand
						M.drop_item()
						M.hand = !M.hand
					else if (effect <= 7)
						M.emote("laugh")
				else if (severity == 2)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> hands flip out and flail everywhere!</span>")
						M.drop_item()
						M.hand = !M.hand
						M.drop_item()
						M.hand = !M.hand
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> falls to the floor and flails uncontrollably!</span>")
						M.make_jittery(10)
						M.weakened += 10
					else if (effect <= 7)
						M.emote("laugh")

		drug/methamphetamine // // COGWERKS CHEM REVISION PROJECT. marked for revision
			name = "methamphetamine"
			id = "methamphetamine"
			description = "Methamphetamine is a highly effective and dangerous stimulant drug."
			reagent_state = SOLID
			fluid_r = 250
			fluid_g = 250
			fluid_b = 250
			transparency = 220
			addiction_prob = 60
			overdose = 20
			depletion_rate = 0.6
			value = 13 // 9c + 1c + 1c + 1c + heat
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 3)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")

				if(holder && ismob(holder.my_atom))
					holder.del_reagent("triplemeth")
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("energy", 3)
						H.sims.affectMotive("fun", 1)
						H.sims.affectMotive("bladder", -1)
						H.sims.affectMotive("hunger", -0.5)
						H.sims.affectMotive("thirst", -1)
						H.sims.affectMotive("comfort", -0.5)
				if(prob(5)) M.emote(pick("twitch","blink_r","shiver"))
				M.make_jittery(5)
				M.drowsyness = max(M.drowsyness-10, 0)
				if(M.paralysis) M.paralysis-=2.5
				if(M.stunned) M.stunned-=2.5
				if(M.weakened) M.weakened-=2.5
				if(M.sleeping) M.sleeping = 0
				if(prob(50))
					M.take_brain_damage(1)
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> can't seem to control their legs!</span>")
						M.change_misstep_chance(20)
						M.weakened += 4
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> hands flip out and flail everywhere!</span>")
						M.drop_item()
						M.hand = !M.hand
						M.drop_item()
						M.hand = !M.hand
					else if (effect <= 7)
						M.emote("laugh")
				else if (severity == 2)

					if(!holder.has_reagent("triplemeth", 10))
						holder.add_reagent("triplemeth", 10, null)

					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> hands flip out and flail everywhere!</span>")
						M.drop_item()
						M.hand = !M.hand
						M.drop_item()
						M.hand = !M.hand
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> falls to the floor and flails uncontrollably!</span>")
						M.make_jittery(10)
						M.weakened += 10
					else if (effect <= 7)
						M.emote("laugh")
