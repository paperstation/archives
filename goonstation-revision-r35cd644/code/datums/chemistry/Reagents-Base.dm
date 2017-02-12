//Contains base elements / reagents.
datum
	reagent
		aluminium
			name = "aluminium"
			id = "aluminium"
			description = "A silvery white and ductile member of the boron group of chemical elements."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255

		barium
			name = "barium"
			id = "barium"
			description = "A highly reactive element."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255

		bromine
			name = "bromine"
			id = "bromine"
			description = "A red-brown liquid element."
			reagent_state = LIQUID
			fluid_r = 150
			fluid_g = 50
			fluid_b = 50
			transparency = 50

		carbon
			name = "carbon"
			id = "carbon"
			description = "A chemical element critical to organic chemistry."
			reagent_state = SOLID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			hygiene_value = -0.5
			transparency = 255

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					if(volume >= 5)
						if(!locate(/obj/decal/cleanable/dirt) in T)
							new /obj/decal/cleanable/dirt(T)

		chlorine
			name = "chlorine"
			id = "chlorine"
			description = "A chemical element."
			reagent_state = GAS
			fluid_r = 220
			fluid_g = 255
			fluid_b = 160
			transparency = 60
			penetrates_skin = 1

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",3)

		chromium
			name = "chromium"
			id = "chromium"
			description = "A catalytic chemical element."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255
			penetrates_skin = 0

		copper
			name = "copper"
			id = "copper"
			description = "A chemical element."
			reagent_state = SOLID
			fluid_r = 184
			fluid_g = 115
			fluid_b = 51
			transparency = 255
			penetrates_skin = 0

		fluorine
			name = "fluorine"
			id = "fluorine"
			description = "A highly-reactive chemical element."
			reagent_state = GAS
			fluid_r = 255
			fluid_g = 215
			fluid_b = 160
			transparency = 60
			penetrates_skin = 1

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_toxin_damage(1) // buffin this because fluorine is horrible - adding a burn effect
				M.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",3)

		ethanol
			name = "ethanol"
			id = "ethanol"
			description = "A well-known alcohol with a variety of applications."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_b = 255
			fluid_g = 255
			transparency = 5
			addiction_prob = 4
			overdose = 100 // ethanol poisoning

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				var/mob/living/carbon/human/H = M

				if (!H.bioHolder.HasEffect("resist_alcohol"))
					if (holder.get_reagent_amount(src.id) >= 75)
						if(prob(10)) H.emote(pick("hiccup", "burp", "mumble", "grumble"))
						H.stuttering += 1
						if (H.canmove && isturf(H.loc) && prob(10))
							step(H, pick(cardinal))
						if (prob(20)) H.make_dizzy(rand(3,5))
					if (holder.get_reagent_amount(src.id) >= 125)
						if(prob(10)) H.emote(pick("hiccup", "burp"))
						if (prob(10)) H.stuttering += rand(1,10)
					if (holder.get_reagent_amount(src.id) >= 225)
						if(prob(10))
							H.emote(pick("hiccup", "burp"))
						if (prob(15))
							H.stuttering += rand(1,10)
						if (H.canmove && isturf(H.loc) && prob(8))
							step(H, pick(cardinal))
					if (holder.get_reagent_amount(src.id) >= 275)
						if(prob(10))
							H.emote(pick("hiccup", "fart", "mumble", "grumble"))
						H.stuttering += 1
						if (prob(33))
							H.change_eye_blurry(10, 50)
						if (H.canmove && isturf(H.loc) && prob(15))
							step(H, pick(cardinal))
						if(prob(4))
							H.change_misstep_chance(20)
						if(prob(6))
							H.visible_message("<span style=\"color:red\">[H] pukes all over \himself.</span>")
							playsound(H.loc, 'sound/effects/splat.ogg', 50, 1)
							new /obj/decal/cleanable/vomit(H.loc)
						if(prob(15))
							H.make_dizzy(5)
					if (holder.get_reagent_amount(src.id) >= 300)
						H.change_eye_blurry(10, 50)
						if(prob(6)) H.drowsyness += 5
						if(prob(5)) H.take_toxin_damage(rand(1,2))
					H.updatehealth()
				..(M)

			do_overdose(var/severity, var/mob/M)
				var/mob/living/carbon/human/H = M
				if (!istype(H) || !H.bioHolder.HasEffect("resist_alcohol"))
					..()

		hydrogen
			name = "hydrogen"
			id = "hydrogen"
			description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
			reagent_state = GAS
			fluid_r = 202
			fluid_g = 254
			fluid_b = 252
			transparency = 20

		iodine
			name = "iodine"
			id = "iodine"
			description = "A purple gaseous element."
			reagent_state = GAS
			fluid_r = 127
			fluid_g = 0
			fluid_b = 255
			transparency = 50

		iron
			name = "iron"
			id = "iron"
			description = "Pure iron is a metal."
			reagent_state = SOLID
			fluid_r = 145
			fluid_g = 135
			fluid_b = 135
			transparency = 255
			pathogen_nutrition = list("iron")

		lithium
			name = "lithium"
			id = "lithium"
			description = "A chemical element."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.canmove && isturf(M.loc))
					step(M, pick(cardinal))
				if(prob(5)) M.emote(pick("twitch","drool","moan"))
				..(M)
				return

		magnesium
			name = "magnesium"
			id = "magnesium"
			description = "A hot-burning chemical element."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 10)
					if (!locate(/obj/decal/cleanable/magnesiumpile) in T)
						new /obj/decal/cleanable/magnesiumpile(T)

		mercury
			name = "mercury"
			id = "mercury"
			description = "A chemical element."
			reagent_state = LIQUID
			fluid_r = 160
			fluid_g = 160
			fluid_b = 160
			transparency = 255
			penetrates_skin = 1
			touch_modifier = 0.2
			depletion_rate = 0.2

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(70))
					M.take_brain_damage(1)
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",1)

		nickel
			name = "nickel"
			id = "nickel"
			description = "Not actually a coin."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255

		nitrogen
			name = "nitrogen"
			id = "nitrogen"
			description = "A colorless, odorless, tasteless gas."
			reagent_state = GAS
			fluid_r = 202
			fluid_g = 254
			fluid_b = 252
			transparency = 20
			pathogen_nutrition = list("nitrogen")

		oxygen
			name = "oxygen"
			id = "oxygen"
			description = "A colorless, odorless gas."
			reagent_state = GAS
			fluid_r = 202
			fluid_g = 254
			fluid_b = 252
			transparency = 20

		phosphorus
			name = "phosphorus"
			id = "phosphorus"
			description = "A chemical element."
			reagent_state = SOLID
			fluid_r = 150
			fluid_g = 110
			fluid_b = 110
			transparency = 255

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(66))
					P.growth++

		plasma
			name = "plasma"
			id = "plasma"
			description = "The liquid phase of an unusual extraterrestrial compound."
			reagent_state = LIQUID

			fluid_r = 130
			fluid_g = 40
			fluid_b = 160
			transparency = 222

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature >= T0C + 100)
					fireflash(get_turf(holder.my_atom), min(max(0,volume/10),8))
					if(holder)
						holder.del_reagent(id)
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("epinephrine"))
					holder.remove_reagent("epinephrine", 2)
				M.take_toxin_damage(1)
				M.updatehealth()
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH)
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.update_burning(30)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				var/datum/plant/growing = P.current
				if (growing.growthmode != "plasmavore")
					P.HYPdamageplant("poison",2)

		platinum
			name = "platinum"
			id = "platinum"
			description = "Shiny."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255

		potassium
			name = "potassium"
			id = "potassium"
			description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
			reagent_state = SOLID
			fluid_r = 190
			fluid_g = 190
			fluid_b = 190
			transparency = 255

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(40))
					P.growth++
					P.health++

		silicon
			name = "silicon"
			id = "silicon"
			description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
			reagent_state = SOLID
			fluid_r = 120
			fluid_g = 140
			fluid_b = 150
			transparency = 255

		silver
			name = "silver"
			id = "silver"
			description = "A lustrous metallic element regarded as one of the precious metals."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 255
			taste = "metallic"

		sulfur
			name = "sulfur"
			id = "sulfur"
			description = "A chemical element."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 0
			transparency = 255

		sugar
			name = "sugar"
			id = "sugar"
			description = "This white, odorless, crystalline powder has a pleasing, sweet taste."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255
			overdose = 200
			pathogen_nutrition = list("sugar")
			taste = "sweet"
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
				M.make_jittery(2)
				M.drowsyness = max(M.drowsyness-5, 0)
				if(prob(50))
					if(M.paralysis) M.paralysis--
					if(M.stunned) M.stunned--
					if(M.weakened) M.weakened--
				if(prob(4))
					M.reagents.add_reagent("epinephrine", 1.2) // let's not metabolize into meth anymore
				//if(prob(2))
					//M.reagents.add_reagent("cholesterol", rand(1,3))
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				if(!M) M = holder.my_atom
				if (M:bioHolder && M:bioHolder.HasEffect("bee"))

					var/obj/item/reagent_containers/food/snacks/ingredient/honey/honey = new /obj/item/reagent_containers/food/snacks/ingredient/honey(get_turf(M))
					if (honey.reagents)
						honey.reagents.maximum_volume = 50

					honey.name = "human honey"
					honey.desc = "Uhhhh.  Uhhhhhhhhhhhhhhhhhhhh."
					M.reagents.trans_to(honey, 50)
					M.visible_message("<b>[M]</b> regurgitates a blob of honey! Gross!")
					playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
					M.reagents.del_reagent(src.id)

					var/beeMax = 15
					for (var/obj/critter/domestic_bee/responseBee in range(7, M))
						if (!responseBee.alive)
							continue

						if (beeMax-- < 0)
							break

						responseBee.visible_message("<b>[responseBee]</b> [ pick("looks confused.", "appears to undergo a metaphysical crisis.  What is human?  What is space bee?<br>Or it might just have gas.", "looks perplexed.", "bumbles in a confused way.", "holds out its forelegs, staring into its little bee-palms and wondering what is real.") ]")

				else
					if (!M.paralysis)
						boutput(M, "<span style=\"color:red\">You pass out from hyperglycemic shock!</span>")
						M.emote("collapse")
						M.paralysis += 3 * severity
						M.weakened += 4 * severity

					if (prob(8))
						M.take_toxin_damage(severity)
						M.updatehealth()

				return

		//WHY IS SWEET ***TEA*** A SUBTYPE OF SUGAR?!?!?!?!
			//Because it's REALLY sweet

		sugar/sweet_tea
			name = "sweet tea"
			id = "sweet_tea"
			description = "A solution of sugar and tea, popular in the American South.  Some people raise the sugar levels in it to the point of saturation and beyond."
			reagent_state = LIQUID
			fluid_r = 139
			fluid_g = 90
			fluid_b = 54
			transparency = 235
			thirst_value = 1

		helium
			name = "helium"
			id = "helium"
			description = "A chemical element."
			reagent_state = GAS
			fluid_r = 255
			fluid_g = 250
			fluid_b = 160
			transparency = 155
			data = null

			on_add(var/mob/M)
				if(!M) M = holder.my_atom
				if(M != /mob/living/carbon/human)
					return
				if(M.bioHolder && M.bioHolder.HasEffect("quiet_voice")) data = 1
				else data = 0
				if(data == 1)
					return
				else
					M.bioHolder.AddEffect("quiet_voice")
				return

			on_remove(var/mob/M)
				if(!M) M = holder.my_atom
				if(M != /mob/living/carbon/human)
					return
				if(M.bioHolder && M.bioHolder.HasEffect("quiet_voice") && data == 1)
					return
				else
					M.bioHolder.RemoveEffect("quiet_voice")
				return

		radium
			name = "radium"
			id = "radium"
			description = "Radium is an alkaline earth metal. It is highly radioactive."
			reagent_state = SOLID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 255
			penetrates_skin = 1
			touch_modifier = 0.5 //Half the dose lands on the floor
			blob_damage = 1

			New()
				..()
				if(prob(10))
					description += " Keep away from forums."

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.irradiate(4,1, 80)
				..(M)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space) && !(locate(/obj/decal/cleanable/greenglow) in T))
					new /obj/decal/cleanable/greenglow(T)

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(80)) P.HYPdamageplant("radiation",3)
				if (prob(16)) P.HYPmutateplant(1)

		sodium
			name = "sodium"
			id = "sodium"
			description = "A soft, silvery-white, highly reactive alkali metal."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 255
			pathogen_nutrition = list("sodium")

		uranium
			name = "uranium"
			id = "uranium"
			description = "A radioactive heavy metal commonly used for nuclear fission reactions."
			reagent_state = SOLID
			fluid_r = 40
			fluid_g = 40
			fluid_b = 40
			transparency = 255

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.irradiate(2,1)
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("radiation",2)
				if (prob(24)) P.HYPmutateplant(1)

		water
			name = "water"
			id = "water"
			description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
			reagent_state = LIQUID
			fluid_r = 10
			fluid_g = 254
			fluid_b = 254
			transparency = 50
			pathogen_nutrition = list("water")
			thirst_value = 3
			hygiene_value = 1.33
			taste = "bland"

			on_mob_life(var/mob/living/carbon/human/H)
				..()
				if (istype(H))
					if (H.sims)
						H.sims.affectMotive("bladder", -0.5)

			reaction_temperature(exposed_temperature, exposed_volume) //Just an example.
				if(exposed_temperature < T0C)
					var/prev_vol = volume
					volume = 0
					if(holder)
						holder.add_reagent("ice", prev_vol, null, (T0C - 1))
					if(holder)
						holder.del_reagent(id)
				else if (exposed_temperature > T0C && exposed_temperature <= T0C + 100 )
					name = "water"
					description = initial(description)
				else if (exposed_temperature > (T0C + 100) )
					name = "steam"
					description = "Water turned steam."
					if (holder.my_atom && holder.my_atom.is_open_container())
						//boil off
						var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
						smoke.set_up(1, 0, get_turf(holder.my_atom))
						smoke.start()

						holder.my_atom.visible_message("The water boils off.")
						holder.del_reagent(src.id)

				return

			reaction_turf(var/turf/target, var/volume)
				var/mytemp = holder.total_temperature
				src = null
				// drsingh attempted fix for undefined variable /turf/space/var/wet
				var/turf/simulated/T = target
				if (volume >= 3 && istype(T))
					if (istext(T.wet))
						T.wet = text2num(T.wet)
					if (T.wet >= 1) return

					if (mytemp <= (T0C - 150)) //Ice
						T.wet = 2
					else if (mytemp > (T0C + 100) )
						return //The steam. It does nothing!!!
					else
						T.wet = 1

					if (!T.wet_overlay)
						T.wet_overlay = image('icons/effects/water.dmi',T,"wet_floor")
					T.UpdateOverlays(T.wet_overlay, "wet_overlay")

					spawn(800)
						if (istype(T))
							T.wet = 0
							T.UpdateOverlays(null, "wet_overlay")

				var/obj/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot && T.air)
					var/datum/gas_mixture/lowertemp = T.remove_air( T.air.total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					hotspot.disposing() // have to call this now to force the lighting cleanup
					pool(hotspot)
				return

			reaction_obj(var/obj/item/O, var/volume)
				src = null
				if(istype(O) && prob(40))
					if(O.burning)
						O.burning = 0
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				..()
				src = null
				if(!volume)
					volume = 10
				if(method == TOUCH)
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.update_burning(-volume)
				return

		water/water_holy
			name = "holy water"
			id = "water_holy"
			description = "Blessed water, supposedly effective against evil."
			thirst_value = 2
			hygiene_value = 2
			value = 3 // 1 1 1

			reaction_mob(var/mob/target, var/method=TOUCH, var/volume)
				..()
				var/mob/living/carbon/human/M = target
				if(istype(M))
					if (isvampire(M))
						M.emote("scream")
						for(var/mob/O in AIviewers(M, null))
							O.show_message(text("<span style=\"color:red\"><b>[] begins to crisp and burn!</b></span>", M), 1)
						boutput(M, "<span style=\"color:red\">Holy Water! It burns!</span>")
						var/burndmg = volume * 1.25
						M.TakeDamage("chest", 0, burndmg, 0, DAMAGE_BURN)
						M.change_vampire_blood(-burndmg)
						M.updatehealth()
					else if (method == TOUCH)
						boutput(M, "<span style=\"color:blue\">You feel somewhat purified... but mostly just wet.</span>")
						M.take_brain_damage(-10)
						for (var/datum/ailment_data/disease/V in M.ailments)
							if(prob(1))
								M.cure_disease(V)
				if(method == TOUCH)
					var/mob/living/L = target
					if(istype(L) && L.burning)
						L.update_burning(-25)

		water/tonic
			name = "tonic water"
			id = "tonic"
			description = "Carbonated water with quinine for a bitter flavor. Protects against Space Malaria."
			reagent_state = LIQUID
			thirst_value = 1.5
			hygiene_value = 0.75
			taste = "bitter"

			reaction_temperature(exposed_temperature, exposed_volume) //Just an example.
				if(exposed_temperature <= T0C)
					name = "tonic ice"
					description = "Frozen water with quinine for a bitter flavor. That is, if you eat ice cubes.  Weirdo."
				else if (exposed_temperature > T0C + 100)
					name = "tonic steam"
					description = "Water turned steam. Steam that protects against Space Malaria."
					if (holder.my_atom && holder.my_atom.is_open_container())
						//boil off
						var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
						smoke.set_up(1, 0, get_turf(holder.my_atom))
						smoke.start()

						holder.my_atom.visible_message("The water boils off.")
						holder.del_reagent(src.id)
				else
					name = "Tonic water"
					description = "Carbonated water with quinine for a bitter flavor. Protects against Space Malaria."

		ice
			name = "ice"
			id = "ice"
			description = "It's frozen water. What did you expect?!"
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 250
			transparency = 200
			taste = "cold"

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature > T0C)
					var/prev_vol = volume
					volume = 0
					if(holder)
						holder.add_reagent("water", prev_vol, null, T0C + 1)
					if(holder)
						holder.del_reagent(id)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5 && !(locate(/obj/item/raw_material/ice) in T))
					new /obj/item/raw_material/ice(T)
				return

		phenol
			name = "phenol"
			id = "phenol"
			description = "Also known as carbolic acid, this is a useful building block in organic chemistry."
			reagent_state = SOLID
			fluid_r = 180
			fluid_g = 180
			fluid_b = 180
			transparency = 35
			value = 5 // 3c + 1c + 1c
