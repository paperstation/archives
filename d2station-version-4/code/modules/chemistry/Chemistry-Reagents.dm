#define SOLID 1
#define LIQUID 2
#define GAS 3

//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

datum
	reagent
		var/name = "Reagent"
		var/id = "reagent"
		var/description = ""
		var/datum/reagents/holder = null
		var/reagent_state = SOLID
		var/data = new/list("viruses"=null)
		var/volume = 0
		var/color_r = 0
		var/color_g = 0
		var/color_b = 0
		var/color_a = 255
		var/melting_temp = 273	//In degrees Kelvin
		var/boiling_temp = 373	//293K, 68.7F, or 20C is approximately room temperature on the station
		var/current_temp = 293	//For debugging and keeping track of a reagent's temperature
		var/nutriment_factor = 0
		var/medical = 0
		var/addictive = 0
		var/disease_pause = 0
		var/disease_heal = 0
		var/disease_slowing = 0

		//var/list/viruses = list()

		proc
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)	//By default we have a chance to transfer some
				var/datum/reagent/self = src						//of the reagent to the mob on TOUCHING it.
				src = null
				if(method == TOUCH)

					var/chance = 1
					for(var/obj/item/clothing/C in M.get_equipped_items())
						if(C.permeability_coefficient < chance) chance = C.permeability_coefficient
					chance = chance * 100

					if(prob(chance))
						if(M.reagents)
							M.reagents.add_reagent(self.id,self.volume/2)
				return

			reaction_obj(var/obj/O, var/volume) //By default we transfer a small part of the reagent to the object
				src = null						//if it can hold reagents. nope!
				//if(O.reagents)
				//	O.reagents.add_reagent(id,volume/3)
				return

			reaction_turf(var/turf/T, var/volume)
				var/icon/spillc
				var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
				if(reagent_state)
					if(reagent_state == SOLID)
						spillc = new/icon("icon" = 'effects.dmi', "icon_state" = "chemicalsolid")
					if(reagent_state == LIQUID)
						spillc = new/icon("icon" = 'effects.dmi', "icon_state" = "chemicalliquid")
					if(reagent_state == GAS)
						spillc = new/icon("icon" = 'effects.dmi', "icon_state" = "chemicalgas")
				spillc.Blend(rgb(src.color_r, src.color_g, src.color_b), ICON_ADD)
				B.overlays += spillc
				holder.my_atom.reagents.trans_to(B, holder.my_atom.reagents.total_volume)
				src = null
				return

			on_mob_life(var/mob/living/M as mob)
				holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
				return

			on_move(var/mob/M)
				return

			on_update(var/atom/A)
				return

/*			distribute_temperature_changes(enacted_temperature)
				var/enact_temp = enacted_temperature			//The amount of temperature change that will be spread out to the reagents
				var/temp_diff = 0
				for(var/datum/reagent/T in holder.reagent_list)
					temp_diff = abs(enact_temp - T.current_temp)
					if(temp_diff > 0.5)
						if(T.current_temp < enact_temp)
							T.current_temp += temp_diff / T.volume
						else
							T.current_temp -= temp_diff / T.volume
					T.check_phase_transition(current_temp)

			check_phase_transition(exposed_temperature)
				current_temp = exposed_temperature
				if(current_temp <= melting_temp)
					if(reagent_state != SOLID)
						reagent_state = SOLID
						for(var/mob/O in viewers(world.view, holder.my_atom.loc))
							O.show_message(text("\blue Something in the [] solidifies!", holder.my_atom.name), 1)
						return
				else if(current_temp < boiling_temp && current_temp > melting_temp)
					if(reagent_state != LIQUID)
						reagent_state = LIQUID
						for(var/mob/O in viewers(world.view, holder.my_atom.loc))
							O.show_message(text("\blue Something in the [] liquifies!", holder.my_atom.name), 1)
						return
				else if(current_temp >= boiling_temp)
					if(reagent_state != GAS)
						reagent_state = GAS
						for(var/mob/O in viewers(world.view, holder.my_atom.loc))
							O.show_message(text("\blue Something in the [] bubbles into vapour!", holder.my_atom.name), 1)
							playsound(get_turf(holder.my_atom), 'bubbles.ogg', 80, 1)
						return
				return
*/
		metroid
			name = "Metroid Jam"
			id = "metroid"
			description = "A green semi-liquid produced from one of the deadliest lifeforms in existence."
			reagent_state = LIQUID
			color_r = 0
			color_g = 72
			color_b = 0
			melting_temp = 277.44
			boiling_temp = 377.44
			on_mob_life(var/mob/living/M as mob)
				if(prob(10))
					M << "You don't feel too good."
					M.toxloss+=20
				else if(prob(40))
					M:heal_organ_damage(5,0)
				..()
				return


		blood
			data = new/list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null)
			name = "Blood"
			id = "blood"
			reagent_state = LIQUID
			color_r = 105
			color_g = 0
			color_b = 0
			melting_temp = 263
			boiling_temp = 363

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				var/datum/reagent/blood/self = src
				src = null
				if(!M) M = holder.my_atom
				for(var/datum/disease/D in self.data["viruses"])
					var/datum/disease/virus = new D.type
					if(method == TOUCH)
						M.contract_disease(virus, 0, 0)

					else //injected
						M.contract_disease(virus, 1, 0)

				/*
				if(self.data["virus"])
					var/datum/disease/V = self.data["virus"]
					if(M.resistances.Find(V.type)) return
					if(method == TOUCH)//respect all protective clothing...
						M.contract_disease(V)
					else //injected
						M.contract_disease(V, 1, 0)
				return
				*/
			on_mob_life(var/mob/M)
				M.blood = M.blood + volume
				volume = 0

			reaction_turf(var/turf/simulated/T, var/volume)//splash the blood all over the place
				if(!istype(T)) return
				var/datum/reagent/blood/self = src
				src = null
				//var/datum/disease/D = self.data["virus"]
				if(!self.data["donor"] || istype(self.data["donor"], /mob/living/carbon/human))
					var/obj/decal/cleanable/blood/blood_prop = locate() in T //find some blood here
					if(!blood_prop) //first blood!
						blood_prop = new(T)
						blood_prop.blood_DNA = self.data["blood_DNA"]
						blood_prop.blood_type = self.data["blood_type"]

					for(var/datum/disease/D in self.data["viruses"])
						var/datum/disease/newVirus = new D.type
						blood_prop.viruses += newVirus
						newVirus.holder = blood_prop

						// this makes it almost impossible for airborne diseases to spread
						// THIS SHIT HAS TO GO, SORRY!
						/*
						if(T.density==0)
							newVirus.spread_type = CONTACT_FEET
						else
							newVirus.spread_type = CONTACT_HANDS
						*/

				else if(istype(self.data["donor"], /mob/living/carbon/monkey))
					var/obj/decal/cleanable/blood/blood_prop = locate() in T
					if(!blood_prop)
						blood_prop = new(T)
						blood_prop.blood_DNA = self.data["blood_DNA"]
					for(var/datum/disease/D in self.data["viruses"])
						var/datum/disease/newVirus = new D.type
						blood_prop.viruses += newVirus
						newVirus.holder = blood_prop

						/*
						if(T.density==0)
							newVirus.spread_type = CONTACT_FEET
						else
							newVirus.spread_type = CONTACT_HANDS
						*/

				else if(istype(self.data["donor"], /mob/living/carbon/alien))
					var/obj/decal/cleanable/xenoblood/blood_prop = locate() in T
					if(!blood_prop)
						blood_prop = new(T)
						blood_prop.blood_DNA = self.data["blood_DNA"]
					for(var/datum/disease/D in self.data["viruses"])
						var/datum/disease/newVirus = new D.type
						blood_prop.viruses += newVirus
						newVirus.holder = blood_prop
						/*
						if(T.density==0)
							newVirus.spread_type = CONTACT_FEET
						else
							newVirus.spread_type = CONTACT_HANDS
						*/
				return

/* Must check the transfering of reagents and their data first. They all can point to one disease datum.

			Del()
				if(src.data["virus"])
					var/datum/disease/D = src.data["virus"]
					D.cure(0)
				..()
*/
		vaccine
			//data must contain virus type
			name = "Vaccine"
			id = "vaccine"
			reagent_state = LIQUID
			color_r = 222
			color_g = 105
			color_b = 105
			melting_temp = 263
			boiling_temp = 363
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				var/datum/reagent/vaccine/self = src
				src = null
				if(self.data&&method == INGEST)
					for(var/datum/disease/D in M.viruses)
						if(D.type == self.data)
							D.cure()
					M.resistances -= self.data
					M.resistances += self.data
				return
			on_mob_life(var/mob/M)
				var/datum/reagent/vaccine/self = src
				src = null
				for(var/datum/disease/D in M.viruses)
					if(D.type == self.data)
						D.cure()
					M.resistances -= self.data
					M.resistances += self.data
				return

		fakevaccine
			//data must contain virus type
			name = "Vaccine"
			id = "fakevaccine"
			reagent_state = LIQUID
			color_r = 222
			color_g = 105
			color_b = 105
			melting_temp = 263
			boiling_temp = 363
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 2
				..()
				return

		fakevaccine2
			//data must contain virus type
			name = "Vaccine"
			id = "fakevaccine2"
			reagent_state = LIQUID
			color_r = 222
			color_g = 105
			color_b = 105
			melting_temp = 263
			boiling_temp = 363
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:oxyloss += 0.5
				M:toxloss += 0.5
				M:weakened = max(M:weakened, 10)
				M:silent = max(M:silent, 10)
				..()
				return

		poo
			name = "poo"
			id = "poo"
			description = "It's poo."
			reagent_state = LIQUID
			color_r = 64
			color_g = 32
			color_b = 0
			melting_temp = 310
			boiling_temp = 430
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(20))
					M.contract_disease(new /datum/disease/gastric_ejections)
				M:toxloss += 0.1
				holder.remove_reagent(src.id, 0.2)
				..()
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon/human) && method==TOUCH)
					if(M:wear_suit) M:wear_suit.add_poo()
					if(M:w_uniform) M:w_uniform.add_poo()
					if(M:shoes) M:shoes.add_poo()
					if(M:gloves) M:gloves.add_poo()
					if(M:head) M:head.add_poo()
				//if(method==INGEST)
				//	if(prob(20))
					//	M.contract_disease(new /datum/disease/gastric_ejections)
					//	holder.add_reagent("gastricejections", 1)
					//	M:toxloss += 0.1
					//	holder.remove_reagent(src.id, 0.2)

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/poo(T)

		vomit
			name = "vomit"
			id = "vomit"
			description = "Vomit, usually produced when someone gets drunk as hell."
			reagent_state = LIQUID
			color_r = 153
			color_g = 97
			color_b = 34
			melting_temp = 270
			boiling_temp = 375
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(5))
					M:toxloss += 0.5
					M.contract_disease(new /datum/disease/gastric_ejections)
				holder.remove_reagent(src.id, 0.2)
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/vomit(T)

		egg
			name = "egg"
			id = "egg"
			description = "It's egg."
			reagent_state = LIQUID
			color_r = 64
			color_g = 32
			color_b = 0
			melting_temp = 310
			boiling_temp = 430
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom

				..()
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon/human) && method==TOUCH)
					if(M:wear_suit) M:wear_suit.add_egg()
					if(M:w_uniform) M:w_uniform.add_egg()
					if(M:shoes) M:shoes.add_egg()
					if(M:gloves) M:gloves.add_egg()
					if(M:head) M:head.add_egg()
				if(method==INGEST)
					if(prob(20))
						M.contract_disease(new /datum/disease/gastric_ejections) //we dont have salmonella, this is pretty similar though.
						M:toxloss += 0.1
						holder.remove_reagent(src.id, 0.2)

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/eggsplat(T)

		synthpoo
			name = "synthpoo"
			id = "synthpoo"
			description = "A synthetic replica of poo. Has the looks and the smell, but it just isn't the same."
			reagent_state = LIQUID
			color_r = 64
			color_g = 32
			color_b = 0
			melting_temp = 310
			boiling_temp = 430

		urine
			name = "urine"
			id = "urine"
			description = "It's pee."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 102
			melting_temp = 263
			boiling_temp = 363
			addictive = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss -= 0.3
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/urine(T)

		jenkem
			name = "jenkem"
			id = "jenkem"
			description = "A bathtub drug made from human excrement."
			reagent_state = LIQUID
			color_r = 153
			color_g = 97
			color_b = 34
			melting_temp = 280
			boiling_temp = 333
			addictive = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:brainloss += 2
				M.druggy = max(M.druggy, 10)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(7)) M:emote(pick("twitch","drool","moan","giggle"))
				if(prob(5))
					M.contract_disease(new /datum/disease/gastric_ejections)
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/poo(T)

		bad_bacteria
			name = "Bacteria"
			id = "bad_bacteria"
			description = "May cause food poisoning."
			reagent_state = LIQUID
			color_r = 153
			color_g = 97
			color_b = 34
			melting_temp = 273
			boiling_temp = 373
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(15))
					M.contract_disease(new /datum/disease/gastric_ejections)
				if(prob(20))
					if(prob(3))
						M.contract_disease(new /datum/disease/appendicitis)
				holder.remove_reagent(src.id, 0.2)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming -= 10

		water
			name = "Water"
			id = "water"
			description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
			reagent_state = LIQUID
			color_r = 179
			color_g = 255
			color_b = 255
			melting_temp = 273
			boiling_temp = 373
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M.druggy = max(0,M.druggy-2)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				..()
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(volume >= 3)
					if(T.wet >= 1) return
					T.wet = 1
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					T.wet_overlay = image('water.dmi',T,"wet_floor")
					T.overlays += T.wet_overlay

					spawn(800)
						if (!istype(T)) return
						if(T.wet >= 2) return
						T.wet = 0
						if(T.wet_overlay)
							T.overlays -= T.wet_overlay
							T.wet_overlay = null

				for(var/mob/living/carbon/metroid/M in T)
					M.toxloss+=rand(5,10)

				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot && !istype(T, /turf/space))
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/T = get_turf(O)
				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot && !istype(T, /turf/space))
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)
				if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/monkeycube))
					var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
					if(!cube.wrapped)
						cube.Expand()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				M.clean_blood()
				if(M.flaming)
					M.flaming -= 40
				if(istype(M, /mob/living/carbon))
					if(istype(M, /mob/living/carbon/human))
						if(M:pickeduppoo)
							M:pickeduppoo = 0
					var/mob/living/carbon/C = M
					if(C.r_hand)
						C.r_hand.clean_blood()
					if(C.l_hand)
						C.l_hand.clean_blood()
					if(C.wear_mask)
						C.wear_mask.clean_blood()
						C.wear_mask.clean_poo()
					if(istype(M, /mob/living/carbon/human))
						if(C:w_uniform)
							C:w_uniform.clean_blood()
							C:w_uniform.clean_poo()
						if(C:wear_suit)
							C:wear_suit.clean_blood()
							C:wear_suit.clean_poo()
						if(C:shoes)
							C:shoes.clean_blood()
							C:shoes.clean_poo()
						if(C:gloves)
							C:gloves.clean_blood()
							C:gloves.clean_poo()
						if(C:head)
							C:head.clean_blood()
							C:head.clean_poo()

		lube
			name = "Space Lube"
			id = "lube"
			description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
			reagent_state = LIQUID
			color_r = 90
			color_g = 210
			color_b = 250
			addictive = 1
			medical = 1
			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(T.wet >= 2) return
				T.wet = 2
				spawn(800)
					if (!istype(T)) return
					T.wet = 0
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					return

		anti_toxin
			name = "Anti-Toxin (Dylovene)"
			id = "anti_toxin"
			description = "Dylovene is a broad-spectrum antitoxin."
			reagent_state = LIQUID
			color_r = 11
			color_g = 67
			color_b = 97
			melting_temp = 263
			boiling_temp = 363
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-2, 0)
				if(holder.has_reagent("toxin"))
					holder.remove_reagent("toxin", 2)
				if(holder.has_reagent("stoxin"))
					holder.remove_reagent("stoxin", 2)
				if(holder.has_reagent("plasma"))
					holder.remove_reagent("plasma", 1)
				if(holder.has_reagent("acid"))
					holder.remove_reagent("acid", 1)
				if(holder.has_reagent("cyanide"))
					holder.remove_reagent("cyanide", 1)
				if(holder.has_reagent("amatoxin"))
					holder.remove_reagent("amatoxin", 2)
				if(holder.has_reagent("chloralhydrate"))
					holder.remove_reagent("chloralhydrate", 5)
				if(holder.has_reagent("carpotoxin"))
					holder.remove_reagent("carpotoxin", 1)
				if(holder.has_reagent("zombiepowder"))
					holder.remove_reagent("zombiepowder", 0.5)
				M:toxloss = max(M:toxloss-2,0)
				..()
				return
		toxin
			name = "Toxin"
			id = "toxin"
			description = "A Toxic chemical."
			reagent_state = LIQUID
			color_r = 167
			color_g = 127
			color_b = 72
			melting_temp = 255
			boiling_temp = 355
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 1.5
				..()
				return

		emetic
			name = "Emetic"
			id = "emetic"
			description = "A vomit inducing chemical."
			reagent_state = LIQUID
			color_r = 131
			color_g = 173
			color_b = 80
			melting_temp = 255
			boiling_temp = 355
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(prob(5))
					M:emote("vomit")
				..()
				return

		cyanide
			name = "Cyanide"
			id = "cyanide"
			description = "A highly toxic chemical."
			reagent_state = LIQUID
			color_r = 216
			color_g = 71
			color_b = 0
			melting_temp = 259.6
			boiling_temp = 299.11
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 3
				M:oxyloss += 3
				M:sleeping += 1
				..()
				return

		stoxin
			name = "Sleep Toxin"
			id = "stoxin"
			description = "An effective hypnotic used to treat insomnia."
			reagent_state = LIQUID
			color_r = 99
			color_g = 193
			color_b = 143
			melting_temp = 253
			boiling_temp = 375
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(15 to 25)
						M:drowsyness  = max(M:drowsyness, 20)
					if(25 to INFINITY)
						M:paralysis = max(M:paralysis, 20)
						M:drowsyness  = max(M:drowsyness, 30)
				data++
				..()
				return

/*		srejuvinate               No way to make it and what it does is already done by kayoloprovaline - keeping it in case anyone wants to use it later
			name = "Sleep Rejuvinate"
			id = "srejuv"
			description = "Puts people to sleep, and heals them."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 273
			boiling_temp = 375
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				if(M.losebreath >= 10)
					M.losebreath = max(10, M.losebreath-10)
				holder.remove_reagent(src.id, 0.2)
				switch(data)
					if(1 to 15)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(15 to 25)
						M:drowsyness  = max(M:drowsyness, 20)
					if(25 to INFINITY)
						M:sleeping = 1
						M:oxyloss = 0
						M:weakened = 0
						M:stunned = 0
						M:paralysis = 0
						M.dizziness = 0
						M:drowsyness = 0
						M:stuttering = 0
						M:confused = 0
						M:jitteriness = 0
				..()
				return
*/

		inaprovaline
			name = "Inaprovaline"
			id = "inaprovaline"
			description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
			reagent_state = LIQUID
			color_r = 19
			color_g = 117
			color_b = 25
			medical = 1
			disease_pause = 0
			disease_heal = 2
			disease_slowing = 1

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 10)
					M.losebreath = max(10, M.losebreath-5)
				holder.remove_reagent(src.id, 0.2)
				if(prob(10) && (M:blood_clot>1)) M:blood_clot--
				..()
				return

		hemoprovaline
			name = "Hemoprovaline"
			id = "hemoprovaline"
			description = "Hemoprovaline is inaprovaline with added Hemoline to facilitate blood clotting."
			reagent_state = LIQUID
			color_r = 79
			color_g = 117
			color_b = 25
			medical = 1
			disease_pause = 1
			disease_heal = 1
			disease_slowing = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 10)
					M.losebreath = max(10, M.losebreath-5)
				holder.remove_reagent(src.id, 0.2)
				if(M:blood < 300)
					M:blood+=2
				..()
				return

		hemoline
			name = "Hemoline"
			id = "hemoline"
			description = "A strong coagulant. Facilitates blood clotting."
			reagent_state = LIQUID
			color_r = 233
			color_g = 136
			color_b = 155
			medical = 1
			disease_pause = 1
			on_mob_life(var/mob/living/M as mob)
				switch(volume)
					if(1 to 5)
						M:blood_clot = max(4,M:blood_clot)
					if(5 to 10)
						M:blood_clot = max(5,M:blood_clot)
					if(10 to 15)
						M:blood_clot = max(6,M:blood_clot)
					if(15 to 20)
						M:blood_clot = max(7,M:blood_clot)
					if(20 to 25)
						M:blood_clot = max(8,M:blood_clot)
					if(25 to INFINITY)
						M:blood_clot = max(9,M:blood_clot)
				..()
				return

		heparin
			name = "Heparin"
			id = "heparin"
			description = "An anticoagulant. Lowers blood thickness. Negates the effect of Hemoline."
			reagent_state = LIQUID
			color_r = 122
			color_g = 128
			color_b = 128
			medical = 1
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(holder.has_reagent("hemoline"))
					holder.remove_reagent("hemoline", 5)
				switch(volume)
					if(1 to 5)
						M:blood_clot = min(6,M:blood_clot)
					if(5 to 10)
						M:blood_clot = min(5,M:blood_clot)
					if(10 to 15)
						M:blood_clot = min(4,M:blood_clot)
					if(15 to 20)
						M:blood_clot = min(3,M:blood_clot)
					if(20 to 25)
						M:blood_clot = min(2,M:blood_clot)
					if(25 to INFINITY)
						M:blood_clot = min(1,M:blood_clot)
				..()
				return

		epinephrine
			name = "Epinephrine"
			id = "epinephrine"
			description = "Epinephrine (also known as adrenaline) is a hormone and a neurotransmitter."
			reagent_state = LIQUID
			color_r = 196
			color_g = 122
			color_b = 122
			medical = 1
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.arrhythmia)
					if(M.arrhythmia < 3)
						M.arrhythmia = 3
						if(M.oxyloss > 0)
							M.oxyloss--
				else if(prob(5))
					M.thrombosis = 1
				return

		atropine
			name = "Atropine"
			id = "atropine"
			description = "Atropine is used to increase heart rate."
			reagent_state = LIQUID
			color_r = 206
			color_g = 222
			color_b = 113
			medical = 1
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.heartrate)
					M.heartrate++
					sleep(100)
				return

		chloromydride
			name = "Chloromydride"
			id = "chloromydride"
			description = "Chloromydride is an extremely strong cardiostimulant, generally used when inaprovaline is ineffective."
			reagent_state = LIQUID
			medical = 1
			color_r = 121
			color_g = 0
			color_b = 168
			addictive = 1
			medical = 1
			disease_pause = 1
			disease_heal = 2
			disease_slowing = 2
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 	1)
					M.losebreath = max(-30, M.losebreath-80)
					M:oxyloss = max(M:oxyloss-10, 0)
					//M.updatehealth()			var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		corophizine
			name = "Corophizine"
			id = "corophizine"
			description = "Corophizine is an all purpose anti viral drug, that is usually used as an aid to recovery."
			medical = 1
			reagent_state = LIQUID
			color_r = 168
			color_g = 29
			color_b = 87
			medical = 1
			disease_pause = 12
			disease_heal = 8
			disease_slowing = 8
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature = max(310, M.bodytemperature-10)
				else if(M.bodytemperature > 311)
					M.bodytemperature = min(310, M.bodytemperature+10)
				if(M.losebreath >= 1)
					M.losebreath = max(-1, M.losebreath-5)
				M:fireloss = max(M:fireloss-1,0)
				M:oxyloss = max(M:oxyloss-1,0)
				M:bruteloss = max(M:bruteloss-1,0)
				M:toxloss = max(M:toxloss-1,0)
		//		M.updatehealth()
				holder.remove_reagent(src.id, 0.2)
				..()
/*
		fixer
			name = "Fixer"
			id = "fixer"
			description = "Fixer helps to eliminate the effects of addiction."
			medical = 1
			reagent_state = LIQUID
			color_r = 186
			color_g = 239
			color_b = 126
			melting_temp = 247
			boiling_temp = 396
			on_mob_life(var/mob/M)
				for(var/datum/disease/D in M.ailment)
					if(D.type == /datum/disease/addiction)
						D.cure()
*/

		cytoglobin
			name = "Cytoglobin"
			id = "cytoglobin"
			description = "Cytoglobin is an extremely powerful drug that could be used to treat viral infections and cure most ailments."
			medical = 1
			reagent_state = LIQUID
			color_r = 234
			color_g = 163
			color_b = 55
			medical = 1
			melting_temp = 256
			boiling_temp = 382
			addictive = 10
			disease_pause = 6
			disease_heal = 4
			disease_slowing = 4
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature++
				else if(M.bodytemperature > 311)
					M.bodytemperature--
				M.losebreath = max(-5, M.losebreath-50)
				M:oxyloss = max(-5, M.oxyloss-0.1)
				M:bruteloss = max(-5, M.bruteloss-0.1)
				M:fireloss = max(-5, M.fireloss-0.1)
				M:toxloss = max(-5, M.toxloss-0.1)
				if(M:paralysis) M:paralysis--
				if(M:stunned) M:stunned--
				if(M:weakened) M:weakened--
	//			M.updatehealth()
				holder.remove_reagent(src.id, 0.2)

		mynoglobin
			name = "Mynoglobin"
			id = "mynoglobin"
			description = "Mynoglobin is the little brother of Cytoglobin, not chemically related, but sharing the same general ailments and viral protection."
			medical = 1
			reagent_state = LIQUID
			color_r = 28
			color_g = 183
			color_b = 152
			medical = 1
			melting_temp = 270
			boiling_temp = 378
			addictive = 10
			disease_pause = 3
			disease_heal = 2
			disease_slowing = 2
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature++
				else if(M.bodytemperature > 311)
					M.bodytemperature--
				M.losebreath = max(-15, M.losebreath-21)
				M:oxyloss = max(-2, M.oxyloss-0.1)
				M:bruteloss = max(-2, M.bruteloss-0.1)
				M:fireloss = max(-2, M.fireloss-0.1)
				M:toxloss = max(-2, M.toxloss-0.1)
				if(M:paralysis) M:paralysis--
				if(M:stunned) M:stunned--
				if(M:weakened) M:weakened--
		//		M.updatehealth()
				holder.remove_reagent(src.id, 0.2)

		polyadrenalobin //this is the only poly that works so i'm keeping this, everything else is broken
			name = "Polyadrenalobin"
			id = "polyadrenalobin"
			description = "Polyadrenalobin is designed to be a stimulant, it can aid in the revival of a patient who has died or is near death."
			medical = 1
			reagent_state = LIQUID
			color_r = 189
			color_g = 4
			color_b = 92
			medical = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(H.brain_op_stage == 4.0)
						return
					for(var/A in H.organs)
						var/datum/organ/external/affecting = null
						if(!H.organs[A])    continue
						affecting = H.organs[A]
						if(!istype(affecting, /datum/organ/external))    continue
						affecting.heal_damage(1000, 1000)
					sleep(10)
					if(M.oxyloss > 0)
						M.oxyloss--
					if(M.toxloss > 50)
						M.toxloss--
					if(M.fireloss > 50)
						M.fireloss--
					if(M.bruteloss > 50)
						M.bruteloss--
					if(M.cloneloss > 50)
						M.cloneloss--
				//	if(M.cloneloss > 1)
				//		M.blood_clot--
				//	if(M.blood < 175)
				//		M.blood++
				//	M.oxyloss--
				//	M.arrhythmia = 0
				//	M.thrombosis = 0
				//	M.heartrate = 80
					M.stat = 1
					M:bleeding--
					M:brainloss += 0.1
				holder.remove_reagent(src.id, 2)

		ketaminol
			name = "2-Cycloketaminol"
			id = "ketaminol"
			description = "A secondary alcohol with a CNS-depressing effect. Can cause a quick death if used in large dosages."
			reagent_state = LIQUID
			color_r = 128
			color_g = 128
			color_b = 128
			addictive = 5
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 5)
						if(data == 1)
							M << "\red Reality begins to snap away."
						if(data == 4)
							M << "\red You feel weak.."
						M.eye_blurry = max(M.eye_blurry, 10)
						if(prob(5)) M:emote("twitch")
						data++
						..()
					if(5 to 10)
						M:sleeping++;
						M:paralysis = max(M:paralysis, 20)
						M.eye_blurry = max(M.eye_blurry, 20)

						data++
						..()
					if(10 to 25)
						M:sleeping++;
						M:paralysis = max(M:paralysis, 30)
						M.eye_blurry = max(M.eye_blurry, 30)

						data++
						..()
					if(25 to INFINITY)
						if(data == 25)
							M:emote("twitch")
							data++
						M:paralysis = max(M:paralysis, 30)
						M:sleeping++;
						M:oxyloss += 4
				return

		kayolane
			name = "Kayolane"
			id = "kayolane"
			description = "Kayolane is a sedative which causes unconsciousness for several hours."
			medical = 1
			reagent_state = LIQUID
			color_r = 192
			color_g = 198
			color_b = 94
			melting_temp = 306
			boiling_temp = 344
			medical = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1)
						M:confused += 15
						M:drowsyness += 15
					if(2 to 50)
						M:sleeping += 1
					if(51 to INFINITY)
						M:sleeping += 1
						M:toxloss += (data - 50)
				data++
				..()


		kayoloprovaline
			name = "Kayoloprovaline"
			id = "kayoloprovaline"
			description = "A regenerative drug that induces a sleep state, during this sleep the body can recover faster."
			medical = 1
			reagent_state = LIQUID
			color_r = 140
			color_g = 203
			color_b = 234
			addictive = 15
			medical = 1
			disease_pause = 6
			disease_heal = 6
			disease_slowing = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.eye_blurry = max(M.eye_blurry, 10)
					if(15 to 25)
						M:drowsyness  = max(M:drowsyness, 20)
					if(25 to INFINITY)
						M:paralysis = max(M:paralysis, 20)
						M:drowsyness  = max(M:drowsyness, 30)
						M.losebreath = max(-5, M.losebreath-1)
						M:oxyloss = max(-1.5, M.oxyloss-0.1)
						M:bruteloss = max(-1.5, M.bruteloss-0.1)
						M:fireloss = max(-1.5, M.fireloss-0.1)
						M:toxloss = max(-1.5, M.toxloss-0.1)
						data++
				..()
				return

		hulkazine
			name = "Hulkazine"
			id = "hulkazine"
			description = "Hulkazine is a temporary Muscle Strengthener and Biomass Manipulator. Side Effects: Extreme Anger, Green Pigment"
			medical = 1
			reagent_state = LIQUID
			color_r = 106
			color_g = 252
			color_b = 18
			addictive = 1
			medical = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 2)
						if (M.mutations & 1) //this was set to tk for testing purposes, nothing worked hue.
							M.mutations &= 1

						//M.mutations &= 8
					if(3 to INFINITY)
						if (!(M.mutations & 1))
							M.mutations |= 1
					//	M.mutations |= 8
				//	if(51 to INFINITY)
				//		M:gib()
							data++
				..()
				return

		biomorph
			name = "Biomorphic Serum"
			id = "biomorph"
			description = "Biomorphic Serum was thought to be greatest advancement to human kind, it gave people psionic abilities; The problem was, when it was tested on a group, 99% of the group had adverse reactions and died."
			medical = 1
			reagent_state = LIQUID
			color_r = 105
			color_g = 0
			color_b = 0
			medical = 1
			var/safe = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(volume >= 5)
					if(prob(2))
						if (!(M.mutations & 1))
							M.mutations |= 1
					if(prob(2))
						if (!(M.mutations & 4096))
							M.mutations |= 4096
					M.make_dizzy(1)
					if(M.canmove) step(M, pick(cardinal)) //no walking for you, fuckass
					if(!M.confused) M.confused = 1
					M.confused = max(M.confused, 20)
					M.bodytemperature += 10
					M.radiation++
					M:toxloss++
					M:bruteloss++
					M.losebreath++
					M:fireloss++
				if (prob(1))
					if(!M:mutantrace)
						M:mutantrace = pick("dog", "sanic", "rabbit", "emokid", "vriska", "brony", "midget") // fireice is gonna love that one
				M.confused = max(M.confused, 20)
				M.bodytemperature += 10
				M.radiation++
				M:toxloss++
				M:bruteloss++
				M.losebreath++
				M:fireloss++
				holder.remove_reagent(src.id, 0.01)
				..()

		stabilizer
			name = "Chemical Stabilizer"
			id = "stabilizer"
			description = "A chemical, that in contact with highly explosive materials, stabilizes them and dissolves into harmless gases."
			reagent_state = LIQUID
			color_r = 0
			color_g = 255
			color_b = 0

		space_drugs
			name = "Space drugs"
			id = "space_drugs"
			description = "An illegal chemical compound used as drug."
			reagent_state = LIQUID
			color_r = 250
			color_g = 255
			color_b = 250
			addictive = 20
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 15)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(7)) M:emote(pick("twitch","drool","moan","giggle"))
				if(prob(5)) M:brainloss += 1
				M:toxloss += 1
				holder.remove_reagent(src.id, 0.2)
				return

		cardamine
			name = "Cardamine"
			id = "cardamine"
			description = "An illegal and highly addictive drug. Once exposed to the substance, it is required for one to ingest it regularly to prevent themselves from dying."
			reagent_state = LIQUID
			color_r = 145
			color_g = 255
			color_b = 117
			addictive = 70
			on_mob_life(var/mob/M)
				M.druggy = max(M.druggy, 5)
				if(prob(10)) M.health += 20
				if(prob(2)) M:emote(pick("twitch","drool","moan","giggle"))
				if(prob(50)) M.health -= 5
				return

		lanthinine
			name = "Lanthinine"
			id = "lanthinine"
			medical = 1
			description = "A drug that causes the patient to feel quite good. Heals some brute/burn damage as well."
			reagent_state = LIQUID
			color_r = 255
			color_g = 206
			color_b = 160
			addictive = 1
			medical = 1
			on_mob_life(var/mob/M)
				if(M:bruteloss && prob(20)) M:heal_organ_damage(3,0)
				if(M:fireloss && prob(10)) M:heal_organ_damage(0,2)
				M.druggy = max(M.druggy, 5)
				..()
				return

		tobacco
			name = "Tobacco"
			id = "tobacco"
			description = "An agricultural product processed from the leaves of plants in the genus Nicotiana."
			reagent_state = SOLID
			color_r = 205
			color_g = 214
			color_b = 158
			melting_temp = 600
			boiling_temp = 2022
			addictive = 0
			on_mob_life(var/mob/M)
				if(prob(1)) M.health += 0.01
				M:toxloss += 0.01
				if(prob(1)) M:emote(pick("cough"))
				M.dizziness = max(0,M.dizziness-1)
				M:drowsyness = max(0,M:drowsyness-2)
				M.bodytemperature = min(310, M.bodytemperature+5) //310 is the normal bodytemp. 310.055
				M.make_jittery(1)
				return

		nicotine
			name = "Nicotine"
			id = "nicotine"
			description = "An alkaloid found in the nightshade family of plants (Solanaceae) that constitutes approximately 0.6-3.0% of the dry weight of tobacco."
			reagent_state = SOLID
			color_r = 219
			color_g = 225
			color_b = 185
			melting_temp = 596
			boiling_temp = 2015
			addictive = 20
			on_mob_life(var/mob/M)
				if(prob(1)) M.health -= 0.01
				if(prob(1))
					if(prob(20)) M:emote(pick("cough")) //this happened way too fucking often before
				M:toxloss += 0.03
				holder.remove_reagent(src.id, 0.2)
				return

		sildenafil
			name = "Sildenafil"
			id = "sildenafil"
			description = "Sildenafil citrate, sold as Viagra, Revatio and under various other trade names, is a drug used to treat erectile dysfunction and pulmonary arterial hypertension (PAH)."
			reagent_state = SOLID
			color_r = 27
			color_g = 132
			color_b = 224
			melting_temp = 462
			boiling_temp = 945
			addictive = 0
			medical = 1
			on_mob_life(var/mob/M)
				switch(volume)
					if(1 to 5)
						M:bloodthickness = max(4,M:bloodthickness)
					if(5 to 10)
						M:bloodthickness = max(5,M:bloodthickness)
					if(10 to 15)
						M:bloodthickness = max(6,M:bloodthickness)
				M:turnedon = 1
				M:toxloss += 0.03
				holder.remove_reagent(src.id, 0.2)
				holder.remove_reagent(src.id, 0.2)
				return

		nitrogen
			name = "Nitrogen"
			id = "nitrogen"
			description = "A colorless, odorless, tasteless, and mostly inert diatomic gas at room temperature."
			reagent_state = GAS
			color_r = 220
			color_g = 231
			color_b = 231
			melting_temp = 63
			boiling_temp = 77.36
			reaction_turf(var/turf/T, var/volume)
				if(reagent_state == LIQUID)
					src = null
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature -=20
					lowertemp.react()
					T.assume_air(lowertemp)
					return
			reaction_obj(var/obj/O, var/volume)
				if(reagent_state == LIQUID)
					src = null
					var/turf/T = get_turf(O)
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature -=20
					lowertemp.react()
					T.assume_air(lowertemp)
					return
			on_mob_life(var/mob/M)
				if(reagent_state == LIQUID)
					M.bodytemperature -= 0.5
					return

		liquid_nitrogen
			name = "Liquid Nitrogen"
			id = "liquid_nitrogen"
			description = "Liquid nitrogen is nitrogen in a liquid state at a very low temperature. It is produced industrially by fractional distillation of liquid air."
			reagent_state = LIQUID
			color_r = 220
			color_g = 231
			color_b = 231
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
				lowertemp.temperature -=20
				lowertemp.react()
				T.assume_air(lowertemp)
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/T = get_turf(O)
				var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
				lowertemp.temperature -=20
				lowertemp.react()
				T.assume_air(lowertemp)
				return
			on_mob_life(var/mob/M)
				M.bodytemperature -= 0.5
				return

		cryostylane
			name = "cryostylane"
			id = "cryostylane"
			description = "Cryostylane is a chemical mostly used for chilling substances to freezing temperature while minimizing structural damage of the biological lifeform."
			reagent_state = LIQUID
			color_r = 220
			color_g = 231
			color_b = 231

			reaction_turf(var/turf/T, var/volume) //let's make it slippery as fuck
				T:wet = 2


		/*	reaction_obj(var/obj/O, var/volume) freeze objs and shit?
				src = null
				var/turf/T = get_turf(O)
				var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
				lowertemp.temperature -=20
				lowertemp.react()
				T.assume_air(lowertemp)
				return*/

			on_mob_life(var/mob/M)
				M.bodytemperature -= 1.5
				M.frozen = 5 // they're frozen as long as this is in...
				holder.remove_reagent(src.id, 1) // but it goes out fast (tweak this)
				return

		synthblood
			name = "Synthblood"
			id = "synthblood"
			description = "A synthesized replica of human blood with added nutrients for viral culturing."
			reagent_state = LIQUID
			color_r = 105
			color_g = 0
			color_b = 0
			melting_temp = 262
			boiling_temp = 362
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 1)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(2)) M:emote(pick("twitch","drool","moan","giggle"))
				holder.remove_reagent(src.id, 0.2)
				return
			reaction_turf(var/turf/T, var/volume)
				new /obj/decal/cleanable/blood(T.loc)

		silicate
			name = "Silicate"
			id = "silicate"
			description = "A compound that can be used to reinforce glass."
			reagent_state = LIQUID
			color_r = 211
			color_g = 211
			color_b = 211
			melting_temp = 1880
			boiling_temp = 2503
			reaction_obj(var/obj/O, var/volume)
				src = null
				if(istype(O,/obj/window))
					O:health = O:health * 2
					var/icon/I = icon(O.icon,O.icon_state,O.dir)
					I.SetIntensity(1.15,1.50,1.75)
					O.icon = I
				return

		oxygen
			name = "Oxygen"
			id = "oxygen"
			description = "A colorless, odorless gas."
			reagent_state = GAS
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 54.36
			boiling_temp = 90.20

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 2

		liquid_oxygen
			name = "Liquid Oxygen" //along with liquid nitrogen, going to be used for liquid air distillation later
			id = "liquid_oxygen"
			description = "Liquid oxygen is oxygen in a liquid state at a very low temperature. It is produced industrially by fractional distillation of liquid air."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
				lowertemp.temperature -=20
				lowertemp.react()
				T.assume_air(lowertemp)
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/T = get_turf(O)
				var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
				lowertemp.temperature -=20
				lowertemp.react()
				T.assume_air(lowertemp)
				return
			on_mob_life(var/mob/M)
				M.bodytemperature -= 0.5
				return

		copper
			name = "Copper"
			id = "copper"
			description = "A highly ductile metal."
			color_r = 188
			color_g = 126
			color_b = 33
			melting_temp = 1357.77
			boiling_temp = 2835

		hydrogen
			name = "Hydrogen"
			id = "hydrogen"
			description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
			reagent_state = GAS
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 14
			boiling_temp = 20.28

		potassium
			name = "Potassium"
			id = "potassium"
			description = "A soft, low-melting solid that can easily be cut with a knife. Reacts robustly with water."
			reagent_state = SOLID
			color_r = 249
			color_g = 249
			color_b = 249
			melting_temp = 336.53
			boiling_temp = 1032

		mercury
			name = "Mercury"
			id = "mercury"
			description = "A chemical element."
			reagent_state = LIQUID
			color_r = 170
			color_g = 170
			color_b = 170
			melting_temp = 234.32
			boiling_temp = 629.88
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.canmove) step(M, pick(cardinal))
				if(prob(5)) M:emote(pick("twitch","drool","moan"))
				..()
				return

		sulfur
			name = "Sulfur"
			id = "sulfur"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 236
			color_g = 243
			color_b = 97
			melting_temp = 388.36
			boiling_temp = 717.8

		carbon
			name = "Carbon"
			id = "carbon"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 90
			color_g = 90
			color_b = 90
			melting_temp = 3933
			boiling_temp = 4473
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/dirt(T)
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming -= 5

		chlorine
			name = "Chlorine"
			id = "chlorine"
			description = "A chemical element."
			reagent_state = GAS
			color_r = 225
			color_g = 227
			color_b = 125
			melting_temp = 171.6
			boiling_temp = 239.11
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.take_organ_damage(1, 0)
				..()
				return

		fluorine
			name = "Fluorine"
			id = "fluorine"
			description = "A highly-reactive chemical element."
			reagent_state = GAS
			color_r = 234
			color_g = 236
			color_b = 164
			melting_temp = 53.53
			boiling_temp = 85
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		sodium
			name = "Sodium"
			id = "sodium"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 255
			color_g = 255
			color_b = 255
			melting_temp = 370.87
			boiling_temp = 1156
			addictive = 1

		phosphorus
			name = "Phosphorus"
			id = "phosphorus"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 245
			color_g = 245
			color_b = 245
			melting_temp = 317.2
			boiling_temp = 553.5

		lithium
			name = "Lithium"
			id = "lithium"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 106
			color_g = 53
			color_b = 53
			melting_temp = 453.69
			boiling_temp = 1615

			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.canmove) step(M, pick(cardinal))
				if(prob(5)) M:emote(pick("twitch","drool","moan"))
				..()
				return

		sugar
			name = "Sugar"
			id = "sugar"
			description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
			reagent_state = SOLID
			color_r = 238
			color_g = 238
			color_b = 238
			melting_temp = 459
			boiling_temp = 99999 //Not applicable
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += 1
				..()
				return

		acid
			name = "Sulfuric acid"
			id = "acid"
			description = "A strong mineral acid with the molecular formula H2SO4."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 283
			boiling_temp = 610
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				M.take_organ_damage(0, 1)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M:wear_mask)
							var/W = M:wear_mask //don't bother assigning unless it's there to be assigned
							if(istype(W, /obj/item/clothing/mask/antiacid))
								M << "\red Your mask neutralizes the acid!"
								return
							else
								del (M:wear_mask)
								M << "\red Your mask melts away but protects you from the acid!"
								return
						if(M:head)
							del (M:head)
							M << "\red Your helmet melts into uselessness but protects you from the acid!"
							return
					if(istype(M, /mob/living/carbon/monkey))
						if(M:wear_mask)
							del (M:wear_mask)
							M << "\red Your mask melts away but protects you from the acid!"
							return

					if(prob(75) && istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						if(affecting)
							affecting.take_damage(25, 0)
							M:UpdateDamage()
							M:UpdateDamageIcon()
							M:emote("scream")
							M << "\red Your face has become disfigured!"
							M.real_name = "Unknown"
					else
						M.take_organ_damage(15)
				else
					M.take_organ_damage(15)

			reaction_obj(var/obj/O, var/volume)
				if((istype(O,/obj/item) || istype(O,/obj/glowshroom)) && prob(40))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)

		pacid
			name = "Polytrinic acid"
			id = "pacid"
			description = "Polytrinic acid is a an extremely corrosive chemical substance."
			reagent_state = LIQUID
			color_r = 205
			color_g = 255
			color_b = 155
			melting_temp = 265
			boiling_temp = 783
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				M.take_organ_damage(0, 1)
				if(holder.has_reagent("ethanol"))
					holder.remove_reagent("ethanol", 5)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M:wear_mask)
							var/W = M:wear_mask //don't bother assigning unless it's there to be assigned
							if(istype(W, /obj/item/clothing/mask/antiacid))
								var/fbbf07d1a = pick(1,103)
								if(fbbf07d1a >= 1 && fbbf07d1a <= 26)
									M << "\red Your mask neutralizes the acid!"
									return
								else if(fbbf07d1a >= 27 && fbbf07d1a <= 77)
									del (M:wear_mask)
									M << "\red Your mask melts into your face!"
									var/datum/organ/external/affecting = M:organs["head"]
									affecting.take_damage(75, 0)
									M:UpdateDamage()
									M:UpdateDamageIcon()
									M:emote("scream")
									M << "\red Your face has become disfigured!"
									M.real_name = "Unknown"
									return
								else if(fbbf07d1a >= 78 && fbbf07d1a <= 103)
									del (M:wear_mask)
									M << "\red Your mask melts away but protects you from the acid!"
									return
							else
								del (M:wear_mask)
								M << "\red Your mask melts away!"
								return
						if(M:head)
							del (M:head)
							M << "\red Your helmet melts into uselessness!"
							return
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(75, 0)
						M:UpdateDamage()
						M:UpdateDamageIcon()
						M:emote("scream")
						M << "\red Your face has become disfigured!"
						M.real_name = "Unknown"
					else
						if(istype(M, /mob/living/carbon/monkey) && M:wear_mask)
							del (M:wear_mask)
							M << "\red Your mask melts away but protects you from the acid!"
							return
						M.take_organ_damage(15)
				else
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(75, 0)
						M:UpdateDamage()
						M:UpdateDamageIcon()
						M:emote("scream")
						M << "\red Your face has become disfigured!"
						M.real_name = "Unknown"
					else
						M.take_organ_damage(15)

			reaction_obj(var/obj/O, var/volume)
				if((istype(O,/obj/item) || istype(O,/obj/glowshroom)))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)

		glycerol
			name = "Glycerol"
			id = "glycerol"
			description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
			reagent_state = LIQUID
			color_r = 227
			color_g = 225
			color_b = 130
			melting_temp = 291
			boiling_temp = 563

		s_napalm
			name = "Napalm"
			id = "s_napalm"
			description = "Petroleum jelly. Flammable."
			reagent_state = SOLID //prove me wrong
			color_r = 214
			color_g = 205
			color_b = 101
			melting_temp = 491
			boiling_temp = 963
			on_mob_life(var/mob/M)
				if(M.frozen) M.frozen = 0 //alright let's do this - defrost him first
				if(!M.flaming) M.flaming += 20 //set him on fire
				if(M.bodytemperature < 1500) M.bodytemperature = 1500 //set him on fire HARDER
				M.bodytemperature += 25 //keep burning!
				M.flaming += 5 //might as well add this

		nitroglycerin
			name = "Nitroglycerin"
			id = "nitroglycerin"
			description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 287
			boiling_temp = 328

		radium
			name = "Radium"
			id = "radium"
			description = "Radium is an alkaline earth metal. It is extremely radioactive."
			reagent_state = SOLID
			color_r = 202
			color_g = 202
			color_b = 202
			melting_temp = 973
			boiling_temp = 2010
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.radiation += 3
				..()
				return
		sacid
			name = "Salicylic Acid"
			id = "sacid"
			description = "A liquid compound that aids tissue development. It can be used to help complete unfinished personnel regeration at low tempuratures."
			reagent_state = LIQUID
			color_r = 235
			color_g = 156
			color_b = 10
			melting_temp = 432
			boiling_temp = 484
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					if(M:cloneloss) M:cloneloss = max(0, M:cloneloss-3)
					if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-1)
					if(M:bruteloss && prob(40)) M:heal_organ_damage(1,0)
					if(M:fireloss) M:fireloss = max(0, M:fireloss-2)
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/greenglow(T)
		ryetalyn
			name = "Ryetalyn"
			id = "ryetalyn"
			description = "Ryetalyn can cure all genetic abnomalities."
			reagent_state = SOLID
			color_r = 210
			color_g = 211
			color_b = 201
			melting_temp = 487
			boiling_temp = 600.6	//Make this decompose before hitting this temperature
			addictive = 1
			medical = 1
			disease_heal = 1
			disease_slowing = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.mutations = 0
				M.disabilities = 0
				M.sdisabilities = 0
				..()
				return

		ryetalynplus
			name = "Ryetalyn Plus"
			id = "ryetalynplus"
			description = "Ryetalyn, but it resets your mutantrace."
			reagent_state = SOLID
			color_r = 210
			color_g = 211
			color_b = 201
			melting_temp = 487
			boiling_temp = 600.6	//Make this decompose before hitting this temperature
			addictive = 1
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.mutations = 0
				M.disabilities = 0
				M.sdisabilities = 0
				if (M:mutantrace)
					M:mutantrace = null
				..()
				return

		pelihewanum
			name = "Pelihewanum"
			id = "pelihewanum"
			description = "Pelihewanum is the common name for what is currently accepted as the strongest base known to man. With a pH of over 200, even the strongest superacids can be easily neutralized with relatively low amounts used."
			color_r = 51
			color_g = 255
			color_b = 201
			melting_temp = 148
			boiling_temp = 866
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				M:fireloss++
				M.take_organ_damage(0, 1)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					M:fireloss += 15
					M.reagents.add_reagent("pelihewanum", 2) //PORE DRINKING! FUCK ALL Y'ALL
			reaction_obj(var/obj/O, var/volume)
				if((istype(O,/obj/item/clothing/mask/gas) && prob(max(volume*3, 75))))
					new /obj/item/clothing/mask/antiacid/gas(O.loc)
					del(O)
				else if((istype(O,/obj/item/clothing/mask/breath) && prob(max(volume*3, 75))))
					new /obj/item/clothing/mask/antiacid/breath(O.loc)
					del(O)
				else if((istype(O,/obj/item/clothing/mask/surgical) && prob(max(volume*3, 75))))
					new /obj/item/clothing/mask/antiacid/sterile(O.loc)
					del(O)
				else if((istype(O,/obj/item/clothing/mask/medical) && prob(max(volume*3, 75))))
					new /obj/item/clothing/mask/antiacid/medical(O.loc)
					del(O)
				else return

		thermite
			name = "Thermite"
			id = "thermite"
			description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
			reagent_state = SOLID
			color_r = 146
			color_g = 120
			color_b = 95
			melting_temp = 1233
			boiling_temp = 3092
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(istype(T, /turf/simulated/wall))
					T:thermite = 1
					T.overlays = null
					T.overlays = image('effects.dmi',icon_state = "thermite")
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 20
				if(M.frozen)
					M.frozen = 0

		mutagen
			name = "Unstable mutagen"
			id = "mutagen"
			description = "Might cause unpredictable mutations. Keep away from children."
			reagent_state = LIQUID
			color_r = 83
			color_g = 138
			color_b = 60
			melting_temp = 242
			boiling_temp = 396
			addictive = 1
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(33)) || method==INGEST)
					randmuti(M)
					if(prob(98))
						randmutb(M)
					else
						randmutg(M)
					domutcheck(M, null)
					updateappearance(M,M.dna.uni_identity)
				return
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.radiation += 3
				..()
				return

		sterilizine
			name = "Sterilizine"
			id = "sterilizine"
			description = "Sterilizes wounds in preparation for surgery."
			reagent_state = LIQUID
			color_r = 236
			color_g = 244
			color_b = 232
			melting_temp = 253
			boiling_temp = 353
			medical = 1
	/*		reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if (method==TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M.health >= -100 && M.health <= 0)
							M.crit_op_stage = 0.0
				if (method==INGEST)
					usr << "Well, that was stupid."
					M:toxloss += 3
				return
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
					M.radiation += 3
					..()
					return
	*/
		iron
			name = "Iron"
			id = "iron"
			description = "Pure iron is a metal."
			reagent_state = SOLID
			color_r = 95
			color_g = 95
			color_b = 95
			melting_temp = 1811
			boiling_temp = 3134
/*
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if((M.virus) && (prob(8) && (M.virus.name=="Magnitis")))
					if(M.virus.spread == "Airborne")
						M.virus.spread = "Remissive"
					M.virus.stage--
					if(M.virus.stage <= 0)
						M.resistances += M.virus.type
						M.virus = null
				holder.remove_reagent(src.id, 0.2)
				return
*/

		gold
			name = "Gold"
			id = "gold"
			description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
			reagent_state = SOLID
			color_r = 245
			color_g = 184
			color_b = 0
			melting_temp = 1337.33
			boiling_temp = 3129

		silver
			name = "Silver"
			id = "silver"
			description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
			reagent_state = SOLID
			color_r = 224
			color_g = 224
			color_b = 224
			melting_temp = 1234.93
			boiling_temp = 2435

		uranium
			name ="Uranium"
			id = "uranium"
			description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
			reagent_state = SOLID
			color_r = 255
			color_g = 255
			color_b = 255
			melting_temp = 1405
			boiling_temp = 4404
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.radiation += 1
				..()
				return


			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/greenglow(T)

		aluminum
			name = "Aluminum"
			id = "aluminum"
			description = "A silvery white and ductile member of the boron group of chemical elements."
			reagent_state = SOLID
			color_r = 207
			color_g = 207
			color_b = 207
			melting_temp = 933.47
			boiling_temp = 2792

		silicon
			name = "Silicon"
			id = "silicon"
			description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
			reagent_state = SOLID
			color_r = 223
			color_g = 213
			color_b = 179
			melting_temp = 1687
			boiling_temp = 3538

		potato
			name = "Liquid Potato"
			id = "potato"
			description = "It's liquid potato!"
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 179
			melting_temp = 102
			boiling_temp = 1503

		fuel
			name = "Welding fuel"
			id = "fuel"
			description = "Required for welders. Flammable."
			reagent_state = LIQUID
			color_r = 214
			color_g = 205
			color_b = 101
			melting_temp = 223
			boiling_temp = 338
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/the_turf = get_turf(O)
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 15
				napalm.trace_gases += fuel
				the_turf.assume_air(napalm)
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 15
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 20
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 1
				..()
				return

		space_cleaner
			name = "Space cleaner"
			id = "cleaner"
			description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
			reagent_state = LIQUID
			color_r = 168
			color_g = 219
			color_b = 219
			melting_temp = 270
			boiling_temp = 370
			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/decal/cleanable))
					del(O)
				else
					if (O)
						O.clean_blood()
			reaction_turf(var/turf/T, var/volume)
				T.overlays = null
				T.clean_blood()
				for(var/obj/decal/cleanable/C in src)
					del(C)

				for(var/mob/living/carbon/metroid/M in T)
					M.toxloss+=rand(5,20) //dirty, dirty metroids

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				M.clean_blood()
				if(M.flaming)
					M.flaming -= 5
				if(istype(M, /mob/living/carbon))
					var/mob/living/carbon/C = M
					if(C.r_hand)
						C.r_hand.clean_blood()
						C.r_hand.clean_egg()
						C.r_hand.clean_poo()
					if(C.l_hand)
						C.l_hand.clean_blood()
						C.l_hand.clean_egg()
						C.l_hand.clean_poo()
					if(C.wear_mask)
						C.wear_mask.clean_blood()
						C.wear_mask.clean_egg()
						C.wear_mask.clean_poo()
					if(istype(M, /mob/living/carbon/human))
						if(C:w_uniform)
							C:w_uniform.clean_blood()
							C:w_uniform.clean_egg()
							C:w_uniform.clean_poo()
						if(C:wear_suit)
							C:wear_suit.clean_blood()
							C:wear_suit.clean_egg()
							C:wear_suit.clean_poo()
						if(C:shoes)
							C:shoes.clean_blood()
							C:shoes.clean_egg()
							C:shoes.clean_poo()
						if(C:gloves)
							C:gloves.clean_blood()
							C:gloves.clean_egg()
							C:gloves.clean_poo()
						if(C:head)
							C:head.clean_blood()
							C:head.clean_egg()
							C:head.clean_poo()


		plantbgone
			name = "Plant-B-Gone"
			id = "plantbgone"
			description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
			reagent_state = LIQUID
			color_r = 227
			color_g = 94
			color_b = 224
			melting_temp = 268
			boiling_temp = 368
			on_mob_life(var/mob/living/carbon/M)
				if(!M) M = holder.my_atom
				M:toxloss += 0.3 //toxin divided by 5, seems legit
				..()
				return

			reaction_obj(var/obj/O, var/volume)
		//		if(istype(O,/obj/plant/vine/))
		//			O:life -= rand(15,35) // Kills vines nicely // Not tested as vines don't work in R41
				if(istype(O,/obj/alien/weeds/))
					O:health -= rand(15,35) // Kills alien weeds pretty fast
					O:healthcheck()
				else if(istype(O,/obj/glowshroom)) //even a small amount is enough to kill it
					del(O)
				// Damage that is done to growing plants is separately
				// at code/game/machinery/hydroponics at obj/item/hydroponics

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon))
					if(!M.wear_mask) // If not wearing a mask
						M:toxloss += 2 // 4 toxic damage per application, doubled for some reason
					if(istype(M,/mob/living/carbon/human) && M:mutantrace == "plant") //plantmen take a LOT of damage
						M:toxloss += 10
					if(istype(M,/mob/living/carbon/human) && M:mutantrace == "zombie") //plantmen take a LOT of damage
						return
						//if(prob(10))
							//M.make_dizzy(1) doesn't seem to do anything


		plasma
			name = "Plasma"
			id = "plasma"
			description = "Plasma in its liquid form."
			reagent_state = LIQUID
			color_r = 188
			color_g = 3
			color_b = 174
			melting_temp = 282.53
			boiling_temp = 414.11
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("inaprovaline"))
					holder.remove_reagent("inaprovaline", 2)
				M.druggy = max(0,M.druggy-2)
				M:toxloss++
				..()
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/the_turf = get_turf(O)
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 5
				napalm.trace_gases += fuel
				the_turf.assume_air(napalm)
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 5
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 10

		leporazine
			name = "Leporazine"
			id = "leporazine"
			description = "Leporazine can be used to stabilize an individuals body temperature."
			reagent_state = LIQUID
			color_r = 18
			color_g = 218
			color_b = 158
			melting_temp = 268
			boiling_temp = 370
			medical = 1
			disease_pause = 3
			disease_slowing = 2
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-20)
				else if(M.bodytemperature < 311)
					M.bodytemperature = min(310, M.bodytemperature+20)
				..()
				return

		cryptobiolin
			name = "Cryptobiolin"
			id = "cryptobiolin"
			description = "Cryptobiolin causes confusion and dizzyness."
			reagent_state = LIQUID
			color_r = 122
			color_g = 30
			color_b = 206
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.make_dizzy(1)
				if(!M.confused) M.confused = 1
				M.confused = max(M.confused, 20)
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		lexorin
			name = "Lexorin"
			id = "lexorin"
			description = "Lexorin temporarily stops respiration. Causes tissue damage."
			reagent_state = LIQUID
			color_r = 43
			color_g = 128
			color_b = 128
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(prob(33))
					M.take_organ_damage(1, 0)
				M:oxyloss += 3
				if(prob(20)) M:emote("gasp")
				..()
				return

		kelotane
			name = "Kelotane"
			id = "kelotane"
			description = "Kelotane is a drug used to treat burns."
			reagent_state = LIQUID
			color_r = 129
			color_g = 201
			color_b = 150
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				M:heal_organ_damage(0,2)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming -= 5

		dermaline
			name = "Dermaline"
			id = "dermaline"
			description = "Dermaline is the next step in burn medication. Works twice as well as kelotane and enables the body to restore even the most dire heat-damaged tissue."
			reagent_state = LIQUID
			color_r = 129
			color_g = 201
			color_b = 187
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
					return
				if(!M) M = holder.my_atom
				M:heal_organ_damage(0,3)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming -= 8

		dexalin
			name = "Dexalin"
			id = "dexalin"
			description = "Dexalin is used in the treatment of oxygen deprivation."
			reagent_state = LIQUID
			color_r = 237
			color_g = 90
			color_b = 90
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return  //See above, down and around. --Agouri
				if(!M) M = holder.my_atom
				M:oxyloss = max(M:oxyloss-2, 0)
				if(holder.has_reagent("lexorin"))
					holder.remove_reagent("lexorin", 2)
				if(M:blood < 250)
					M:blood+=2
				..()
				return

		dexalinp
			name = "Dexalin Plus"
			id = "dexalinp"
			description = "Dexalin Plus is used in the treatment of oxygen deprivation. Its highly effective."
			reagent_state = LIQUID
			color_r = 208
			color_g = 74
			color_b = 74
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				M:oxyloss = 0
				if(holder.has_reagent("lexorin"))
					holder.remove_reagent("lexorin", 2)
				if(M:blood < 300)
					M:blood+=2
				..()
				return

		tricordrazine
			name = "Tricordrazine"
			id = "tricordrazine"
			description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
			reagent_state = LIQUID
			color_r = 120
			color_g = 166
			color_b = 36
			medical = 1
			addictive = 1
			disease_pause = 1
			disease_heal = 1
			disease_slowing = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(40)) M:oxyloss--
				if(M:bruteloss && prob(40)) M:heal_organ_damage(1,0)
				if(M:fireloss && prob(40)) M:heal_organ_damage(0,1)
				if(M:toxloss && prob(40)) M:toxloss--
				M.druggy = max(0,M.druggy-2)
				..()
				return

		adminordrazine //An OP chemical for adminis
			name = "Adminordrazine"
			id = "adminordrazine"
			description = "It's magic. We don't have to explain it."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom ///This can even heal dead people.
				M:cloneloss = 0
				M:oxyloss = 0
				M:radiation = 0
				M:heal_organ_damage(5,5)
				if(M:toxloss) M:toxloss = max(0, M:toxloss-5)
				holder.isolate_reagent(src.id)  //i could do this, or spend an hour or so updating this chem with all the poisons we have
				M:brainloss = 0       //take a wild guess as to what i selected fucktards
				M.disabilities = 0
				M.sdisabilities = 0
				M:eye_blurry = 0
				M:eye_blind = 0
				M:disabilities &= ~1
				M:sdisabilities &= ~1
				M:weakened = 0
				M:stunned = 0
				M:paralysis = 0
				M:silent = 0
				M.dizziness = 0
				M:drowsyness = 0
				M:stuttering = 0
				M:confused = 0
				M:sleeping = 0
				M:jitteriness = 0
				M.stat = 1
				for(var/datum/disease/D in M.viruses)
					D.spread = "Remissive"
					D.stage--
					if(D.stage < 1)
						D.cure()
				..()
				return

		synaptizine
			name = "Synaptizine"
			id = "synaptizine"
			description = "Synaptizine is used to treat neuroleptic shock. Can be used to help remove disabling symptoms such as paralysis."
			reagent_state = LIQUID
			color_r = 242
			color_g = 13
			color_b = 156
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				switch(volume)
					if(1 to 29)
						M:drowsyness = max(M:drowsyness-5, 0)
						if(M:paralysis) M:paralysis--
						if(M:stunned) M:stunned--
						if(M:weakened) M:weakened--
					if (30 to 89)
						M:drowsyness = max(M:drowsyness-5, 0)
						M:paralysis = max(M:paralysis-3, 0)
						M:stunned = max(M:stunned-3, 0)
						M:weakened = max(M:weakened-3, 0)
						M:jitteriness = max(M:jitteriness+3, 30)
						if(M:sleeping) M:sleeping = 0
						if(prob(1)) M:emote(pick("twitch","blink_r","shiver"))
					if (90 to 199) //slowly entering overdose levels
						M:drowsyness = max(M:drowsyness-15, 0)
						M:paralysis = max(M:paralysis-7, 0)
						M:stunned = max(M:stunned-7, 0)
						M:weakened = max(M:weakened-7, 0)
						M:jitteriness = max(M:jitteriness+5, 60)
						if(M:sleeping) M:sleeping = 0
						M:toxloss = max(M:toxloss+2, 30)
						if(prob(3)) M:emote(pick("twitch","blink_r","shiver"))
						if(prob(5))
							M:brainloss++
							M << "\red You feel a strange burning in your head."
					if (200 to 299) //CRASH
						var/findingoriginalvarnamesishardguys = 0
						if (!findingoriginalvarnamesishardguys)
							M << "\red You hallucinate and find yourself falling down some stairs. You seem unable to stop falling."
							findingoriginalvarnamesishardguys = 1
						M:sleeping += 1
						M:toxloss += 4
						M:bruteloss += 0.1
						if (!M:bloodstopper) M:bloodstopper = 1
						M:stunned++
						M:paralysis++
					if (300 to INFINITY) //crashed harder than a jet into world trade center
						M:sleeping += 1
						M:toxloss += 4
						M:bruteloss += 0.1
						M:stunned++
						M:paralysis++
						if (prob(1))
							if (prob(1))
								M << "\blue You are unable to handle the energy inside you and burst into treats."
								new /obj/item/weapon/reagent_containers/food/snacks/candy(M.loc)
								M:gib()
				..()
				return

		impedrezene
			name = "Impedrezene"
			id = "impedrezene"
			description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
			reagent_state = LIQUID
			color_r = 151
			color_g = 189
			color_b = 189
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:jitteriness = max(M:jitteriness-5,0)
				if(prob(80)) M:brainloss++
				if(prob(50)) M:drowsyness = max(M:drowsyness, 3)
				if(prob(10)) M:emote("drool")
				..()
				return

		hyronalin
			name = "Hyronalin"
			id = "hyronalin"
			description = "Hyronalin is a medicinal drug used to counter the effects of radiation poisoning."
			reagent_state = LIQUID
			color_r = 169
			color_g = 189
			color_b = 108
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-3,0)
				..()
				return

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
			reagent_state = LIQUID
			color_r = 109
			color_g = 31
			color_b = 31
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return  //See above, down and around. --Agouri
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-7,0)
				if(M:toxloss) M:toxloss--
				if(prob(15))
					M.take_organ_damage(1, 0)
				..()
				return

		alkysine
			name = "Alkysine"
			id = "alkysine"
			description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
			reagent_state = LIQUID
			color_r = 236
			color_g = 179
			color_b = 128
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:brainloss = max(M:brainloss-3 , 0)
				..()
				return

		zaldy
			name = "Zaldy"
			id = "zaldy"
			description = "An illegal formula that causes blindness when it enters the body."
			reagent_state = LIQUID
			color_r = 64
			color_g = 64
			color_b = 64
			addictive = 1
			on_mob_life(var/mob/M)
				if(M:eye_blind == null || M:eye_blind == 0) //Doesn't work if they're already blind
					M << "\red Your eyes sting!"
					M:emote("scream")
					M:eye_blind = max(M:eye_blind, 100) //HUGELY OP, feel free to scroll that number down a ton

				..()
				return

		antdazoline
			name = "Antdazoline"
			id = "antdazoline"
			description = "Antdazoline causes temporary damage to the eyes."
			reagent_state = LIQUID
			color_r = 128
			color_g = 128
			color_b = 128
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:eye_blind = max(M:eye_blind, 100)
				..()
				return

		imidazoline
			name = "Imidazoline"
			id = "imidazoline"
			description = "Heals eye damage"
			reagent_state = LIQUID
			color_r = 189
			color_g = 197
			color_b = 202
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:eye_blurry = max(M:eye_blurry-5 , 0)
				M:eye_blind = max(M:eye_blind-5 , 0)
				M:disabilities &= ~1
//				M:sdisabilities &= ~1		Replaced by eye surgery
				..()
				return

		bicaridine
			name = "Bicaridine"
			id = "bicaridine"
			description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma and blood loss."
			reagent_state = LIQUID
			color_g = 72
			color_b = 128
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(M.stat == 2.0)
					return
				if(!M) M = holder.my_atom
				M:heal_organ_damage(2,0)
				if(prob(20) && (M:bloodthickness>1)) M:bloodthickness--
				if(M:blood < 250)
					M:blood+=2
				..()
				return

		hyperzine
			name = "Hyperzine"
			id = "hyperzine"
			description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
			reagent_state = LIQUID
			color_r = 183
			color_g = 96
			color_b = 143
			medical = 1
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(prob(5)) M:emote(pick("twitch","blink_r","shiver"))
				if(prob(1)) M:turnedon = 1
				holder.remove_reagent(src.id, 0.2)
				..()
				return


		cryoxadone
			name = "Cryoxadone"
			id = "cryoxadone"
			description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
			reagent_state = LIQUID
			color_r = 0
			color_g = 0
			color_b = 255
			medical = 1
			disease_pause = 10
			disease_heal = 10
			disease_slowing = 3
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					if(M:cloneloss) M:cloneloss = max(0, M:cloneloss-1)
					if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-3)
					M:heal_organ_damage(3,3)
					if(M:toxloss) M:toxloss = max(0, M:toxloss-3)
					if(prob(4) && M:bleeding > 0) M:bleeding--
				..()
				return

		clonexadone
			name = "Clonexadone"
			id = "clonexadone"
			description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' clones that get ejected early."
			reagent_state = LIQUID
			color_r = 255
			color_g = 0
			color_b = 0
			medical = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 370)
					if(M:cloneloss) M:cloneloss = max(0, M:cloneloss-3)
					if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-3)
					M:heal_organ_damage(3,3)
					if(M:toxloss) M:toxloss = max(0, M:toxloss-3)
				..()
				return

		spaceacillin
			name = "Spaceacillin"
			id = "spaceacillin"
			description = "An all-purpose antiviral agent."
			reagent_state = LIQUID
			color_r = 78
			color_g = 121
			color_b = 34
			medical = 1
			melting_temp = 250
			boiling_temp = 396
			addictive = 1
			disease_pause = 15
			disease_heal = 15
			disease_slowing = 5
			on_mob_life(var/mob/living/M as mob)//no more mr. panacea
				M.druggy = max(0,M.druggy-2)
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		carpotoxin
			name = "Carpotoxin"
			id = "carpotoxin"
			description = "A deadly neurotoxin produced by the dreaded spess carp."
			reagent_state = LIQUID
			color_r = 210
			color_g = 200
			color_b = 200
			melting_temp = 126.3
			boiling_temp = 373
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 2
				..()
				return

		zombiepowder
			name = "Zombie Powder"
			id = "zombiepowder"
			description = "A strong neurotoxin that puts the subject into a death-like state."
			color_r = 141
			color_g = 255
			color_b = 66
			melting_temp = 396.24
			boiling_temp = 567
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:oxyloss += 0.5
				M:toxloss += 0.5
				M:weakened = max(M:weakened, 10)
				M:silent = max(M:silent, 10)
				..()
				return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/*nanites
			name = "Nanomachines"
			id = "nanites"
			description = "Microscopic construction robots."
			reagent_state = LIQUID
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if( (prob(10) && method==TOUCH) || method==INGEST)
					M.contract_disease(new /datum/disease/robotic_transformation(0),1)*/

		xenomicrobes
			name = "Xenomicrobes"
			id = "xenomicrobes"
			description = "Microbes with an entirely alien cellular structure."
			reagent_state = LIQUID
			color_r = 64
			color_g = 100
			color_b = 11
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if( (prob(10) && method==TOUCH) || method==INGEST)
					M.contract_disease(new /datum/disease/xeno_transformation(0),1)

//foam precursor

		fluorosurfactant
			name = "Fluorosurfactant"
			id = "fluorosurfactant"
			description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
			reagent_state = LIQUID
			color_r = 196
			color_g = 196
			color_b = 185
			reaction_turf(var/turf/T, var/volume)
				src = null
				new /obj/decal/cleanable/foam(T)
				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot && !istype(T, /turf/space))
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/T = get_turf(O)
				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot && !istype(T, /turf/space))
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				M.clean_blood()
				if(M.flaming)
					M.flaming -= 40
				if(istype(M, /mob/living/carbon))
					if(istype(M, /mob/living/carbon/human))
						if(M:pickeduppoo)
							M:pickeduppoo = 0
					var/mob/living/carbon/C = M
					if(C.r_hand)
						C.r_hand.clean_blood()
					if(C.l_hand)
						C.l_hand.clean_blood()
					if(C.wear_mask)
						C.wear_mask.clean_blood()
						C.wear_mask.clean_poo()
					if(istype(M, /mob/living/carbon/human))
						if(C:w_uniform)
							C:w_uniform.clean_blood()
							C:w_uniform.clean_poo()
						if(C:wear_suit)
							C:wear_suit.clean_blood()
							C:wear_suit.clean_poo()
						if(C:shoes)
							C:shoes.clean_blood()
							C:shoes.clean_poo()
						if(C:gloves)
							C:gloves.clean_blood()
							C:gloves.clean_poo()
						if(C:head)
							C:head.clean_blood()
							C:head.clean_poo()

// metal foaming agent
// this is lithium hydride. Add other recipies (e.g. LiH + H2O -> LiOH + H2) eventually

		foaming_agent
			name = "Foaming agent"
			id = "foaming_agent"
			description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
			reagent_state = SOLID
			color_r = 136
			color_g = 137
			color_b = 116

		ethanol
			name = "Ethanol"
			id = "ethanol"
			description = "A well-known alcohol with a variety of applications."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 159
			boiling_temp = 351
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				M.make_dizzy(5)
				M:jitteriness = max(M:jitteriness-5,0)
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 4
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 3
				if(prob(15) && (M:blood_clot>1)) M:blood_clot--
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 5

		ammonia
			name = "Ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."
			reagent_state = GAS
			color_r = 133
			color_g = 236
			color_b = 255
			melting_temp = 195
			boiling_temp = 240

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID
			color_r = 188
			color_g = 224
			color_b = 231
			melting_temp = 223
			boiling_temp = 328.5

		ethylredoxrazine						// FUCK YOU, ALCOHOL
			name = "Ethylredoxrazine"
			id = "ethylredoxrazine"
			description = "A powerfuld oxidizer that reacts with ethanol."
			reagent_state = SOLID
			color_r = 145
			color_g = 187
			color_b = 140
			melting_temp = 523.6
			boiling_temp = 1005
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M:dizziness) // adding sanity checks because it somehow fucks you up otherwise -ds
					M:dizziness -= 2
				if(M:drowsyness)
					M:drowsyness -= 2
				if(M:stuttering)
					M:stuttering -= 2
				if(M:confused)
					M:confused -= 2
				..()
				return

		chloralhydrate							//Otherwise known as a "Mickey Finn"
			name = "Chloral Hydrate"
			id = "chloralhydrate"
			description = "A powerful sedative."
			reagent_state = SOLID
			color_r = 221
			color_g = 232
			color_b = 232
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:confused += 0.5
						M:drowsyness += 0.5
						M:bloodstopper = 0
					if(2 to 50)
						M:sleeping += 1
						M:bleeding = 0
						M:bloodstopper = 0
					if(51 to INFINITY)
						M:sleeping += 1
						M:toxloss += (data - 50)
						M:bloodstopper = 1
				..()
				return

		beer2							//copypasta of chloral hydrate, disguised as normal beer for use by emagged brobots
			name = "Beer"
			id = "beer2"
			description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
			reagent_state = LIQUID
			color_r = 128
			color_g = 64
			color_b = 0
			melting_temp = 330
			boiling_temp = 371
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1)
						M:confused += 0.5
						M:drowsyness += 0.5
					if(2 to 50)
						M:sleeping += 1
					if(51 to INFINITY)
						M:sleeping += 1
						M:toxloss += (data - 50)
				data++
				..()
				return

		red_dye
			name = "Red Dye"
			id = "red_dye"
			description = "A red dye. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 255
			color_g = 0
			color_b = 0
			melting_temp = 330 //copypasted from beer
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5 //seriously, don't drink 'dis
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		blue_dye
			name = "Blue Dye"
			id = "blue_dye"
			description = "A blue dye. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 0
			color_g = 0
			color_b = 255
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		green_dye
			name = "Green Dye"
			id = "green_dye"
			description = "A green dye. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 0
			color_g = 255
			color_b = 0
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		orange_dye
			name = "Orange Dye"
			id = "orange_dye"
			description = "An orange dye. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 255
			color_g = 195
			color_b = 15
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		yellow_dye
			name = "Yellow Dye"
			id = "yellow_dye"
			description = "A yellow dye. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 51
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		purple_dye
			name = "Purple Dye"
			id = "purple_dye"
			description = "A purple dye. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 153
			color_g = 51
			color_b = 255
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		black_dye
			name = "Ink"
			id = "black_dye"
			description = "A black dye usually found in pens. Somewhat toxic."
			reagent_state = LIQUID
			color_r = 0
			color_g = 0
			color_b = 0
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		white_dye
			name = "Bleach"
			id = "white_dye"
			description = "A toxic liquid that is also commonly used as a white dye."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 255
			melting_temp = 330
			boiling_temp = 371
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				data++
				switch(data)
					if(1)
						M:toxloss += 0.5
					if(2 to 50)
						M:toxloss += 0.01
					if(51 to INFINITY)
						M:toxloss += 0.002
				..()
				return

		rainbow_dye
			name = "Rainbow Dye"
			id = "rainbow_dye"
			description = "A dye that seemingly contains all the colors of the rainbow. Surprisingly, nontoxic."
			reagent_state = LIQUID
			color_r = 150
			color_g = 150
			color_b = 150
			melting_temp = 330
			boiling_temp = 371 //because it's derived straight from banana peels, making this toxic would take them straight into op as balls territory

		cum //DEAR GOD WHO REMOVED THIS
			name = "cum"
			id = "cum"
			description = "Penis milk."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 255
			melting_temp = 273
			boiling_temp = 373

			/* no fuck you we're not doing this with permanent cum
			on_mob_life(var/mob/living/M as mob)
				switch(volume)
					if(0 to 30) //basically, unless you use something that magically removes this from your system, you gunna get uncumsonstepped
						if (M:cumonstep !=0)
							M:cumonstep = 0
						else if (M:cumonstep !=1) //btw, these checks are in case some badmin turns someone's cumonstep to >1
							M:cumonstep = 1
						if(holder.has_reagent("cum")) //redundant, i know, but i don't want to step up the fuck's metabolism
							holder.remove_reagent("cum", 0.6) //because it would also force the other reagents to metabolize faster
				return
			*/

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/cum(T)

		dongoprazine
			name = "dongoprazine"
			id = "dongoprazine"
			description = "The fabled Dongoprazine is a chemical containing stem cells that restore a person's sexual organs if they were previously removed."
			reagent_state = LIQUID
			color_r = 255
			color_g = 170
			color_b = 170
			melting_temp = 273
			boiling_temp = 373
			on_mob_life(var/mob/living/M as mob)
				switch(volume)
					if(0 to 15)
						return
					if (15 to INFINITY)
						if (M:penis_op_stage !=0)
							M:penis_op_stage = 0
				return
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/item/weapon/storage/cock(T)

		arprinium
			name = "Arprinium"
			id = "arprinium"
			description = "An unstable compound of copper exhibiting extraordinary magnetic properties."
			reagent_state = SOLID
			color_r = 188
			color_g = 56
			color_b = 33
			melting_temp = 1357.77
			boiling_temp = 2835
			on_mob_life(var/mob/living/M as mob)
				M:radiation += (M:radiation+1)

/////////////////////////Food Reagents////////////////////////////
// Part of the food code. Nutriment is used instead of the old "heal_amt" code. Also is where all the food
// 	condiments, additives, and such go.
		nutriment
			name = "Nutriment"
			id = "nutriment"
			description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
			reagent_state = SOLID
			nutriment_factor = 15 * REAGENTS_METABOLISM
			color_r = 239
			color_g = 244
			color_b = 15
			melting_temp = 486
			boiling_temp = 99999	//Should decompose before hitting this temp
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(prob(50)) M:heal_organ_damage(1,0)
				M:nutrition += nutriment_factor	// For hunger and fatness
/*
				// If overeaten - vomit and fall down
				// Makes you feel bad but removes reagents and some effects
				// from your body
				if (M.nutrition > 650)
					M.nutrition = rand (250, 400)
					M.weakened += rand(2, 10)
					M.jitteriness += rand(0, 5)
					M.dizziness = max (0, (M.dizziness - rand(0, 15)))
					M.druggy = max (0, (M.druggy - rand(0, 15)))
					M.toxloss = max (0, (M.toxloss - rand(5, 15)))
					//M.updatehealth()			var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
*/
				..()
				return

		soysauce
			name = "Soysauce"
			id = "soysauce"
			description = "A salty sauce made from the soy plant."
			reagent_state = LIQUID
			color_r = 116
			color_g = 80
			color_b = 24

		orlistat
			name = "Orlistat"
			id = "orlistat"
			description = "An anti-obseity medicine."
			reagent_state = LIQUID
			color_r = 213
			color_g = 216
			color_b = 203
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:nutrition -= rand(1, 2)
				M:overeatduration -= rand(4, 10)
				M:bodytemperature += 1
				..()
				return
			nutriment_factor = 2 * REAGENTS_METABOLISM

		ketchup
			name = "Ketchup"
			id = "ketchup"
			description = "Ketchup, catsup, whatever. It's tomato paste."
			reagent_state = LIQUID
			color_r = 224
			color_g = 52
			color_b = 52
			nutriment_factor = 5 * REAGENTS_METABOLISM

		capsaicin
			name = "Capsaicin Oil"
			id = "capsaicin"
			description = "This is what makes chilis hot."
			reagent_state = LIQUID
			color_r = 208
			color_g = 79
			color_b = 23
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:bodytemperature += 5
				if(prob(40) && !istype(M, /mob/living/carbon/metroid))
					M.take_organ_damage(0, 1)
				holder.remove_reagent(src.id, 1)

		oleoresincapsicumn
			name = "Oleoresin Capsicum"
			id = "oleoresincapsicumn"
			description = "This is used in pepper sprays."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			color_r = 208
			color_g = 79
			color_b = 23
			on_mob_life(var/mob/M)
				M:eye_blurry = 4
				if(prob(10))
					M:eye_blind = 2
				M:stunned = 5
				if(prob(10))
					M:weakened = 4
				holder.remove_reagent(src.id, 1)



				return


				if(istype(M, /mob/living/carbon/metroid))
					M:bodytemperature += rand(5,20)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				M:eye_blurry = 4
				if(prob(10))
					M:eye_blind = 2
				M:stunned = 5
				if(prob(10))
					M:weakened = 4
				holder.remove_reagent(src.id, 1)



				return


				if(istype(M, /mob/living/carbon/metroid))
					M:bodytemperature += rand(5,20)
				..()
				return

		frostoil
			name = "Frost Oil"
			id = "frostoil"
			description = "A special oil that noticably chills the body. Extracted from Icepeppers."
			reagent_state = LIQUID
			color_r = 85
			color_g = 193
			color_b = 213
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				if(M.flaming)
					M.flaming -= 5
				if(prob(40))
					M.take_organ_damage(0, 1)
				if(prob(80) && istype(M, /mob/living/carbon/metroid))
					M.fireloss += rand(5,20)
					M << "\red You feel a terrible chill inside your body!"
				..()
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				for(var/mob/living/carbon/metroid/M in T)
					M.toxloss+=rand(15,30)

		sodiumchloride
			name = "Table Salt"
			id = "sodiumchloride"
			description = "A salt made of sodium chloride. Commonly used to season food."
			reagent_state = SOLID
			color_r = 252
			color_g = 252
			color_b = 252
			melting_temp = 370.87
			boiling_temp = 1156
			addictive = 1

		blackpepper
			name = "Black Pepper"
			id = "blackpepper"
			description = "A power ground from peppercorns. *AAAACHOOO*"
			reagent_state = SOLID
			color_r = 30
			color_g = 30
			color_b = 30
			melting_temp = 370.87
			boiling_temp = 1156

		coco
			name = "Coco Powder"
			id = "Coco Powder"
			description = "A fatty, bitter paste made from coco beans."
			reagent_state = SOLID
			color_r = 30
			color_g = 30
			color_b = 30
			melting_temp = 370.87
			boiling_temp = 588
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return

		hot_coco
			name = "Hot Chocolate"
			id = "hot_coco"
			description = "Made with love! And coco beans."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
			color_r = 30
			color_g = 30
			color_b = 30
			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				M:nutrition += nutriment_factor
				..()
				return

		amatoxin
			name = "Amatoxin"
			id = "amatoxin"
			description = "A powerful poison derived from certain species of mushroom."
			color_r = 185
			color_g = 177
			color_b = 151
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		psilocybin
			name = "Psilocybin"
			id = "psilocybin"
			description = "A strong psycotropic derived from certain species of mushroom."
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 30)
				if(!data) data = 1
				switch(data)
					if(1 to 5)
						if (!M:stuttering) M:stuttering = 1
						M.make_dizzy(5)
						if(prob(10)) M:emote(pick("twitch","giggle"))
					if(5 to 10)
						if (!M:stuttering) M:stuttering = 1
						M.make_jittery(10)
						M.make_dizzy(10)
						M.druggy = max(M.druggy, 35)
						if(prob(20)) M:emote(pick("twitch","giggle"))
					if (10 to INFINITY)
						if (!M:stuttering) M:stuttering = 1
						M.make_jittery(20)
						M.make_dizzy(20)
						M.druggy = max(M.druggy, 40)
						if(prob(30)) M:emote(pick("twitch","giggle"))
				holder.remove_reagent(src.id, 0.2)
				data++
				..()
				return

		opium
			name = "Opium"
			id = "opium"
			description = "Dried latex obtained from the opium poppy"
			color_r = 240
			color_g = 232
			color_b = 232
			addictive = 1
			on_mob_life(var/mob/M)
				M.druggy = max(M.druggy, 10)
				..()
				return

		thc
			name = "Tetrahydrocannabinol"
			id = "thc"
			description = "The main psychoactive substance found in the cannabis plant. There is no evidence to suggest that THC is physically addictive"
			color_r = 163
			color_g = 234
			color_b = 167
			addictive = 0
			on_mob_life(var/mob/M)
				M.druggy = max(M.druggy, 20)
				if(prob(14)) M:emote(pick("giggle","smile","laugh"))
				..()
				return

		sprinkles
			name = "Sprinkles"
			id = "sprinkles"
			description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 255
			color_g = 140
			color_b = 203
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden"))
					if(!M) M = holder.my_atom
					M:heal_organ_damage(1,1)
					M:nutrition += nutriment_factor
					..()
					return
				..()

		syndicream
			name = "Cream filling"
			id = "syndicream"
			description = "Delicious cream filling of a mysterious origin. Tastes criminally good."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 217
			color_g = 154
			color_b = 241
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.mind)
					if(M.mind.special_role)
						if(!M) M = holder.my_atom
						M:heal_organ_damage(1,1)
						M:nutrition += nutriment_factor
						..()
						return
				..()

		cornoil
			name = "Corn Oil"
			id = "cornoil"
			description = "An oil derived from various types of corn."
			reagent_state = LIQUID
			nutriment_factor = 20 * REAGENTS_METABOLISM
			color_r = 216
			color_g = 203
			color_b = 129
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return
			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(volume >= 3)
					if(T.wet >= 1) return
					T.wet = 1
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					T.wet_overlay = image('water.dmi',T,"wet_floor")
					T.overlays += T.wet_overlay

					spawn(800)
						if (!istype(T)) return
						if(T.wet >= 2) return
						T.wet = 0
						if(T.wet_overlay)
							T.overlays -= T.wet_overlay
							T.wet_overlay = null
				var/hotspot = (locate(/obj/hotspot) in T)
				if(hotspot)
					var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
					lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
					lowertemp.react()
					T.assume_air(lowertemp)
					del(hotspot)

		enzyme
			name = "Universal Enzyme"
			id = "enzyme"
			description = "A universal enzyme used in the preparation of certain chemicals and foods."
			reagent_state = LIQUID
			color_r = 187
			color_g = 226
			color_b = 29

		dry_ramen
			name = "Dry Ramen"
			id = "dry_ramen"
			description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
			reagent_state = SOLID
			color_r = 239
			color_g = 228
			color_b = 176
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return

		hot_ramen
			name = "Hot Ramen"
			id = "hot_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in school."
			reagent_state = LIQUID
			color_r = 239
			color_g = 228
			color_b = 176
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+10)
				..()
				return

		hell_ramen
			name = "Hell Ramen"
			id = "hell_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in school."
			reagent_state = LIQUID
			color_r = 239
			color_g = 228
			color_b = 176
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				M:bodytemperature += 10
				..()
				return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		orangejuice
			name = "Orange juice"
			id = "orangejuice"
			description = "Both delicious AND rich in Vitamin C, what more do you need?"
			reagent_state = LIQUID
			color_r = 255
			color_g = 184
			color_b = 41
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(30)) M:oxyloss--
				M:nutrition++
				..()
				return

		tomatojuice
			name = "Tomato Juice"
			id = "tomatojuice"
			description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
			reagent_state = LIQUID
			color_r = 255
			color_g = 127
			color_b = 102
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				if(M:fireloss && prob(20)) M:heal_organ_damage(0,1)
				M:nutrition++
				..()
				return

		limejuice
			name = "Lime Juice"
			id = "limejuice"
			description = "The sweet-sour juice of limes."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 153
			color_g = 255
			color_b = 102
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!M) M = holder.my_atom
				if(M:toxloss && prob(20)) M:toxloss--
				M:nutrition++
				..()
				return

		carrotjuice
			name = "Carrot juice"
			id = "carrotjuice"
			description = "It is just like a carrot but without crunching."
			reagent_state = LIQUID
			color_r = 255
			color_g = 184
			color_b = 41
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				M:eye_blurry = max(M:eye_blurry-1 , 0)
				M:eye_blind = max(M:eye_blind-1 , 0)
				if(!data) data = 1
				switch(data)
					if(1 to 20)
						//nothing
					if(21 to INFINITY)
						if (prob(data-10))
							M:disabilities &= ~1
				data++
				..()
				return

		berryjuice
			name = "Berry Juice"
			id = "berryjuice"
			description = "A delicious blend of several different kinds of berries."
			reagent_state = LIQUID
			color_r = 204
			color_g = 102
			color_b = 255
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				..()
				return

		poisonberryjuice
			name = "Poison Berry Juice"
			id = "poisonberryjuice"
			description = "A tasty juice blended from various kinds of very deadly and toxic berries."
			reagent_state = LIQUID
			color_r = 255
			color_g = 184
			color_b = 41
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				M:toxloss += 1
				..()
				return

		watermelonjuice
			name = "Watermelon Juice"
			id = "watermelonjuice"
			description = "Delicious juice made from watermelon."
			reagent_state = LIQUID
			color_r = 255
			color_g = 102
			color_b = 153
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				switch(volume)
					if(0 to 30)
						return
					if(30 to INFINITY)
						M:s_tone -= 1.5
						return

		lemonjuice
			name = "Lemon Juice"
			id = "lemonjuice"
			description = "This juice is VERY sour."
			reagent_state = LIQUID
			color_r = 230
			color_g = 255
			color_b = 102
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				..()
				return

		banana
			name = "Banana Juice"
			id = "banana"
			description = "The raw essence of a banana. HONK"
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 255
			color_g = 255
			color_b = 0
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Clown"))
					if(!M) M = holder.my_atom
					M:heal_organ_damage(1,1)
					..()
					return
				if(istype(M, /mob/living/carbon/monkey))
					if(!M) M = holder.my_atom
					M:heal_organ_damage(1,1)
					..()
					return
				..()
			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(T.wet >= 3) return
				T.wet = 3
				spawn(1200)
					if (!istype(T)) return
					T.wet = 0
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					return

		potato_juice
			name = "Potato Juice"
			id = "potato2"
			description = "Juice of the potato. Bleh."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 204
			nutriment_factor = 2 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				..()
				return

		milk
			name = "Milk"
			id = "milk"
			description = "An opaque white liquid produced by the mammary glands of mammals."
			reagent_state = LIQUID
			color_r = 249
			color_g = 249
			color_b = 245
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				M:nutrition++
				..()
				return

		soymilk
			name = "Soy Milk"
			id = "soymilk"
			description = "An opaque white liquid made from soybeans."
			reagent_state = LIQUID
			color_r = 249
			color_g = 249
			color_b = 245
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				M:nutrition++
				..()
				return

		albiniser
			name = "Albiniser"
			id = "albiniser"
			description = "A chemical which directly deactivates melatonin in a subjects body."
			reagent_state = LIQUID
			color_r = 255
			color_g = 102
			color_b = 153
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				switch(volume)
					if(0 to 15)
						M:toxloss += 0.01
					if(15 to INFINITY)
						M:s_tone += 5
						M:toxloss += 0.03
						return

		cream
			name = "Cream"
			id = "cream"
			description = "The fatty, still liquid part of milk. Why don't you mix this with some scotch, eh?"
			reagent_state = LIQUID
			color_r = 249
			color_g = 249
			color_b = 245
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				..()
				return

		coffee
			name = "Coffee"
			id = "coffee"
			description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
			reagent_state = LIQUID
			color_r = 91
			color_g = 46
			color_b = 0
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				M.make_jittery(5)
				..()
				return

		tea
			name = "Tea"
			id = "tea"
			description = "Tasty black tea, it has antioxidants, it's good for you!"
			reagent_state = LIQUID
			color_r = 60
			color_g = 30
			color_b = 0
			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-2)
				M:drowsyness = max(0,M:drowsyness-1)
				M:jitteriness = max(0,M:jitteriness-3)
				M:sleeping = 0
				if(M:toxloss && prob(20))
					M:toxloss--
				if (M.bodytemperature < 310)  //310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				..()
				return

		icecoffee
			name = "Iced Coffee"
			id = "icecoffee"
			description = "Coffee and ice, refreshing and cool."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature-5)
				M.make_jittery(5)
				..()
				return

		icetea
			name = "Iced Tea"
			id = "icetea"
			description = "No relation to a certain rap artist/ actor."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				..()
				M.dizziness = max(0,M.dizziness-2)
				M:drowsyness = max(0,M:drowsyness-1)
				M:sleeping = 0
				if(M:toxloss && prob(20))
					M:toxloss--
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature-5)
				return

		space_cola
			name = "Cola"
			id = "cola"
			description = "A refreshing beverage."
			reagent_state = LIQUID
			color_r = 83
			color_g = 60
			color_b = 36
			on_mob_life(var/mob/living/M as mob)
				M:drowsyness = max(0,M:drowsyness-5)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature-5)
				M:nutrition += 1
				..()
				return

		Robustmins_cola
			name = "Robustmin's Cola"
			id = "Robustmins_cola"
			description = "SO. MUCH. CAFFEINE"
			reagent_state = LIQUID
			color_r = 83
			color_g = 60
			color_b = 36
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				switch(volume)
					if(0 to 10) //The innocent part.
						if(volume < 5) //We deal damage here.
							if(data > 0)
								M << "\red Caffeine crash!"
								M:toxloss+=max(150,data)
								data = 0
						if(!data) //Put damage to at least one.
							M << "\green I FEEL FANTASTIC. AND I NEVER FELT AS GOOD AS HOW I DO RIGHT NOW."
							data = 1
						if(prob(10)) M:emote("twitch")
						if(data > 1 && volume > 8) //Give a message when the damage absorption stops.
							M << "\red You feel crap, better drink some more!"
							volume = 8
						M:bloodstopper = 0
						..()
					if(10 to 45) //Absorb damage.
						data+=(M:toxloss/2)
						M:toxloss=0
						data+=M:bruteloss
						M:bruteloss=0
						if(prob(10)) M:emote("twitch")
						if(prob(10)) M:emote("shiver")
						M:sleeping = 0
						M:bloodstopper = 1
						..()
					if(45 to INFINITY) //OVERDOSE
						M << "\red TOO. MUCH. ENERGY."
						M:gib()
				return

		nuka_cola
			name = "Nuka Cola"
			id = "nuka_cola"
			description = "Cola. Cola never changes."
			reagent_state = LIQUID
			color_r = 20
			color_g = 18
			color_b = 84
			on_mob_life(var/mob/living/M as mob)
				M.make_jittery(20)
				M.druggy = max(M.druggy, 30)
				M.dizziness +=5
				M:drowsyness = 0
				M:sleeping = 0
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature-5)
				M:nutrition += 1
				..()
				return

		spacemountainwind
			name = "Space Mountain Wind"
			id = "spacemountainwind"
			description = "Blows right through you like a space wind."
			reagent_state = LIQUID
			color_r = 18
			color_g = 84
			color_b = 20
			on_mob_life(var/mob/living/M as mob)
				M:drowsyness = max(0,M:drowsyness-7)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				M.make_jittery(5)
				M:nutrition += 1
				..()
				return

		thirteenloko
			name = "Thirteen Loko"
			id = "thirteenloko"
			description = "A potent mixture of caffeine and alcohol."
			color_r = 84
			color_g = 53
			color_b = 18
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				M:drowsyness = max(0,M:drowsyness-7)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				M.make_jittery(5)
				M:nutrition += 1
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 45 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		dr_gibb
			name = "Dr. Gibb"
			id = "dr_gibb"
			description = "A delicious blend of 42 different flavours"
			color_r = 84
			color_g = 18
			color_b = 38
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				M:drowsyness = max(0,M:drowsyness-6)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5) //310 is the normal bodytemp. 310.055
				M:nutrition += 1
				..()
				return

		space_up
			name = "Space-Up"
			id = "space_up"
			color_r = 40
			color_g = 18
			color_b = 84
			description = "Tastes like a hull breach in your mouth."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-8) //310 is the normal bodytemp. 310.055
				M:nutrition += 1
				..()
				return

		lemon_lime
			name = "Lemon Lime"
			description = "A tangy substance made of 0.5% natural citrus!"
			id = "lemon_lime"
			color_r = 114
			color_g = 242
			color_b = 82
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-8) //310 is the normal bodytemp. 310.055
				M:nutrition += 1
				..()
				return

		beer
			name = "Beer"
			id = "beer"
			description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
			reagent_state = LIQUID
			addictive = 1
			color_r = 56
			color_g = 31
			color_b = 10
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				M:nutrition += 2
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 0.5

				..()
				return

		whiskey
			name = "Whiskey"
			id = "whiskey"
			description = "A superb and well-aged single-malt whiskey. Damn."
			reagent_state = LIQUID
			addictive = 1
			color_r = 181
			color_g = 154
			color_b = 36
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		specialwhiskey
			name = "Special Blend Whiskey"
			id = "specialwhiskey"
			description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
			reagent_state = LIQUID
			addictive = 1
			color_r = 222
			color_g = 186
			color_b = 29
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return


		gin
			name = "Gin"
			id = "gin"
			description = "It's gin. In space. I say, good sir."
			reagent_state = LIQUID
			addictive = 1
			color_r = 105
			color_g = 202
			color_b = 255
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		rum
			name = "Rum"
			id = "rum"
			description = "Yohoho and all that."
			reagent_state = LIQUID
			addictive = 1
			color_r = 219
			color_g = 125
			color_b = 31
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vodka
			name = "Vodka"
			id = "vodka"
			description = "Number one drink AND fueling choice for Russians worldwide."
			reagent_state = LIQUID
			addictive = 1
			color_r = 235
			color_g = 243
			color_b = 245
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		tequilla
			name = "Tequila"
			id = "tequilla"
			description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
			reagent_state = LIQUID
			addictive = 1
			color_r = 255
			color_g = 226
			color_b = 130
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vermouth
			name = "Vermouth"
			id = "vermouth"
			description = "You suddenly feel a craving for a martini..."
			reagent_state = LIQUID
			addictive = 1
			color_r = 145
			color_g = 255
			color_b = 130
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		wine
			name = "Wine"
			id = "wine"
			description = "An premium alcoholic beverage made from distilled grape juice."
			reagent_state = LIQUID
			color_r = 94
			color_g = 24
			color_b = 24
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=2
				if(data >= 65 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 145 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		tonic
			name = "Tonic Water"
			id = "tonic"
			color_r = 228
			color_g = 243
			color_b = 245
			description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				..()
				return

		kahlua
			name = "Kahlua"
			id = "kahlua"
			description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
			reagent_state = LIQUID
			color_r = 46
			color_g = 23
			color_b = 4
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0//Copy-paste from Coffee, derp
				M.make_jittery(5)
				..()
				return

		cokahlua
			name = "Cokalua"
			id = "cokalua"
			description = "The preferred drink of Gunner Wells. Delicious."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
			color_r = 30
			color_g = 30
			color_b = 30
			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				M.make_jittery(5)
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				M:nutrition += nutriment_factor
				..()
				return

		cognac
			name = "Cognac"
			id = "cognac"
			description = "A sweet and strongly alcoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
			reagent_state = LIQUID
			addictive = 1
			color_r = 82
			color_g = 47
			color_b = 17
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 45 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		hooch
			name = "Hooch"
			id = "hooch"
			color_r = 82
			color_g = 52
			color_b = 26
			description = "Either someone's failure at cocktail making or attempt in alcohol production. In any case, do you really want to drink that?"
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=6
				if(data >= 35 && data <90)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 5
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 90 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		ale
			name = "Ale"
			id = "ale"
			color_r = 112
			color_g = 93
			color_b = 28
			description = "A dark alchoholic beverage made by malted barley and yeast."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		sodawater
			name = "Soda Water"
			id = "sodawater"
			description = "A can of club soda. Why not make a scotch and soda?"
			reagent_state = LIQUID
			color_r = 224
			color_g = 224
			color_b = 224
			on_mob_life(var/mob/living/M as mob)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				..()
				return

		ice
			name = "Ice"
			id = "ice"
			color_r = 204
			color_g = 254
			color_b = 255
			description = "Frozen water, your dentist wouldn't like you chewing this."
			reagent_state = SOLID
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				..()
				return

/////////////////////////////////////////////////////////////////cocktail entities//////////////////////////////////////////////

		bilk
			name = "Bilk"
			id = "bilk"
			color_r = 191
			color_g = 173
			color_b = 149
			description = "This appears to be beer mixed with milk. Disgusting."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(M:bruteloss && prob(10)) M:heal_organ_damage(1,0)
				M:nutrition += 2
				if(!data) data = 1
				data++
			//	M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 3
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 0.5
				..()
				return

		atomicbomb
			name = "Atomic Bomb"
			id = "atomicbomb"
			color_r = 79
			color_g = 184
			color_b = 70
			description = "Nuclear proliferation never tasted so good."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				M.druggy = max(M.druggy, 50)
				M.confused = max(M:confused+2,0)
				M:drowsyness += 0.5
				M.make_dizzy(10)
				if (!M.stuttering) M.stuttering = 1
				M.stuttering += 3
				if(!data) data = 1
				data++
				switch(data)
					if(51 to INFINITY)
						M:confused += 0.5
						M:drowsyness += 0.5
						M:sleeping += 1
				..()
				return

		threemileisland
			name = "Three Mile Island Iced Tea"
			id = "threemileisland"
			color_r = 161
			color_g = 99
			color_b = 82
			description = "Made for a woman, strong enough for a man."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				M.druggy = max(M.druggy, 50)
				if(data >= 35 && data <90)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 90)
					M.confused = max(M:confused+2,0)
				..()
				return

		goldschlager
			name = "Goldschlager"
			id = "goldschlager"
			color_r = 161
			color_g = 159
			color_b = 82
			description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		robustersdelight
			name = "Robuster's Delight"
			id = "robustersdelight"
			description = "An inhumanly strong drink intended only for a master robuster."
			reagent_state = LIQUID
			color_r = 8
			color_g = 0
			color_b = 255
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:confused += 5
				M:silent = max(M:silent, 1)
				if(!data) data = 1
				data++
				M:jitteriness += 25
				M.dizziness += 7
				M.bodytemperature = (M.bodytemperature+2)
				if(prob(50))
					if(prob(15))
						M.contract_disease(new /datum/disease/gastric_ejections) //everyone loves diseases
				if(prob(50))
					if(prob(5))
						M.contract_disease(new /datum/disease/rhumba_beat)
				if(prob(50))
					if(prob(50))
						M.contract_disease(new /datum/disease/fake_gbs)
				M.stuttering += 5
				M:weakened += 0.5
				M.druggy += 25
				if(data >= 35 && data <300)
					M:confused += 0.55
					M.bodytemperature += (M.bodytemperature+15) //SNOWBALL TIME, MOTHERFUCKERS
					if (!M:bruteloss) M:bruteloss = 0.5
					if (!M:toxloss) M:toxloss = 0.5
					if (!M:oxyloss) M:oxyloss = 0.5
					M:bruteloss += (M:bruteloss)
					M:toxloss += (M:toxloss)
					M:oxyloss += (M:oxyloss)
					M.stuttering += 7
					M.druggy = (M.druggy+0.5)
					M:nutrition = (M:nutrition+16) //so you get to experience the full joy of shitting yourself without passing out and all that
					if (prob(25))
						M:weakened++
					if (prob(1))
						M:brainloss = (M:brainloss+20)
						M << "\red An onimous laughter booms inside your head."
					if (prob(2))
						M << "\red You feel like your insides are being robusted!"
						M:bruteloss = (M:bruteloss+15)
						M:oxyloss = (M:oxyloss+15)
					if (prob(4))
						M <<(pick("\red You feel like there's a thousand toolboxes jumping around in your stomach...","\red It feels like Atmos in here.","\red You feel like robusting someone."))	//prob's so low until I get more lines in over time
					if (prob(1))
						if(prob(75))
							M:removePart(pick("M/arm_left","M/arm_right","M/leg_left","M/leg_right","M/foot_left","M/foot_right")) //so the head can't get blown off
					if(prob(50))
						M:emote(pick("twitch","scream","gasp","cough","pee","poo","pale","vomit","whimper","blink_r"))
						if(prob(25))
							M:emote("superfart")
					holder.remove_reagent(M, 0.08) //so you can drink precisely 20 units without combusting (4 sips)
					if(data >=300 && prob(75)) //if you're lucky enough...
						M.bodytemperature += (M.bodytemperature+425) //this sets your bodytemp to "shit i'm burning" levels if they weren't that high already
						if (!M.flaming) M.flaming += 25	//this actually sets you on fire
						M:fireloss += (M:fireloss+5) //to speed up the process
						if (prob(80))
							var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(M)
							M:equip_if_possible(clownmask, M:slot_wear_mask)
							clownmask.canremove = 0
							M << "\red A clown mask mysteriously appears on your face, as if mocking your lack of robustness."
							playsound(M.loc, 'bikehorn.ogg', 50, 1)
				..()
				return

		patron
			name = "Patron"
			id = "patron"
			description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
			reagent_state = LIQUID
			addictive = 1
			color_r = 199
			color_g = 190
			color_b = 139
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		gintonic
			name = "Gin and Tonic"
			id = "gintonic"
			description = "An all time classic, mild cocktail."
			color_r = 240
			color_g = 237
			color_b = 223
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <135)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
					M:confused += 0.5
					M:drowsyness += 0.5
				..()
				return

		cuba_libre
			name = "Cuba Libre"
			id = "cubalibre"
			color_r = 54
			color_g = 37
			color_b = 0
			description = "Rum, mixed with cola. Viva la revolution."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <135)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		fortran_fanta
			name = "FORTRAN Fanta"
			id = "fortranfanta"
			description = "5% caffeine, 95% robustness."
			reagent_state = LIQUID
			color_r = 222
			color_g = 227
			color_b = 86
			addictive = 16 //yes.
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:confused += 5
				M:silent = max(M:silent, 1)
				if(!data) data = 1
				data++
				M:jitteriness += 25
				M.dizziness += 7
				M.bodytemperature = (M.bodytemperature+2)
				M.contract_disease(new /datum/disease/gastric_ejections) //since this is the adminbus edition of the drink, i fully disregarded balancing things
				M.contract_disease(new /datum/disease/fake_gbs) //rhumba beat replaced with more common proc below
				M.stuttering += 5
				M:weakened += 15
				M.druggy += 25
				if(data >= 35 && data <36)
					playsound(M.loc, 'fartelise.it', 125)
					M << "\red Your intestines erupt into song!"
					if(data >= 37 && data <200)
						M:emote("superfart") //direct followup of fartelise
						M:confused += 0.55
						M.bodytemperature = (M.bodytemperature+15)
						M:bruteloss += (M:bruteloss+0.5)
						M:toxloss += (M:toxloss+1)
						M:oxyloss += (M:oxyloss+2)
						M.stuttering += 7
						M.druggy = (M.druggy+6.5)
						M:nutrition = (M:nutrition+45)
						if(prob(15))
							M:brainloss = (M:brainloss+20)
							M << "\red An onimous laughter booms inside your head."
						if(prob(15))
							M << "\red You feel like your insides are being robusted!"
							M:bruteloss = (M:bruteloss+15)
							M:oxyloss = (M:oxyloss+15)
						if(prob(50))
							M:removePart(pick("M/arm_left","M/arm_right","M/leg_left","M/leg_right","M/foot_left","M/foot_right")) //so the head can't get blown off
						if(prob(50))
							M:emote(pick("twitch","scream","gasp","cough","pee","poo","pale","vomit","whimper","blink_r"))
						if(data >=150)
							M.bodytemperature = (M.bodytemperature+425) //this sets your bodytemp to "shit i'm burning" levels if they weren't that high already
							M.flaming += 25	//this actually sets you on fire
							M:fireloss = (M:fireloss+5) //to speed up the process
							if (prob(80))
								var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(M)
								M:equip_if_possible(clownmask, M:slot_wear_mask)
								clownmask.canremove = 0 //this mainly to prevent cloning, i guess you could poly them back to life tho
								M << "\red A clown mask mysteriously appears on your face, as if mocking your lack of robustness."
								playsound(M.loc, 'bikehorn.ogg', 50, 1)
				..()
				return

		hngr_bourbon
			name = "Hand Grenade Bourbon"
			id = "hngr_bourbon"
			description = "This liquid is full of mystery."
			reagent_state = LIQUID
			color_r = 204
			color_g = 138
			color_b = 0
			on_mob_life(var/mob/living/M as mob)
				switch(volume)
					if(0 to 10)
						if(volume < 5)
							if(data > 0)
								M << "\red YOU REQUIRE ADDITIONAL BOURBON!"
								M:toxloss =(M:toxloss+rand(2,5))
								data = 0
						if(!data) //Put damage to at least one.
							M << "\green I FEEL FANTASTIC. AND I NEVER FELT AS GOOD AS HOW I DO RIGHT NOW."
							data = 1
						if(prob(10)) M:emote("twitch")
						if(data > 1 && volume > 8)
							M << "\red You feel like crap, better drink some more!"
							volume = 8
						M:bloodstopper = 0
						..()
					if(10 to 45) //
						data+=(M:toxloss/2)
						M:toxloss=0
						data+=M:bruteloss
						M:bruteloss=0
						if(prob(10)) M:emote("twitch")
						if(prob(10)) M:emote("shiver")
						M:sleeping = 0
						M:bloodstopper = 1
						if(prob(20))
							M:removePart(pick("M/arm_left","M/arm_right","M/leg_left","M/leg_right","M/foot_left","M/foot_right", "M/head"))
							playsound(M.loc, 'glock.ogg', 65, 1) //it just sounded best like this
							M.blood = (M.blood-5) //haha yes
						..()
						if(prob(5))
							M << "\red A peculiar ticking noise comes out of your stomach..."
							sleep 500
							M.gib()
				return

		whiskey_cola
			name = "Whiskey Cola"
			id = "whiskeycola"
			description = "Whiskey, mixed with cola. Surprisingly refreshing."
			reagent_state = LIQUID
			addictive = 1
			color_r = 56
			color_g = 26
			color_b = 4
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		martini
			name = "Classic Martini"
			id = "martini"
			description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
			reagent_state = LIQUID
			addictive = 1
			color_r = 214
			color_g = 255
			color_b = 246
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vodkamartini
			name = "Vodka Martini"
			id = "vodkamartini"
			description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
			reagent_state = LIQUID
			addictive = 1
			color_r = 214
			color_g = 255
			color_b = 253
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				if(data >= 45 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		white_russian
			name = "White Russian"
			id = "whiterussian"
			description = "That's just, like, your opinion, man..."
			reagent_state = LIQUID
			addictive = 1
			color_r = 245
			color_g = 255
			color_b = 254
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				//M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		gay_russian
			name = "Gay Russian"
			id = "gayrussian"
			description = "That's like, your opinion, girlfriend..."
			reagent_state = LIQUID
			addictive = 1
			color_r = 245
			color_g = 255
			color_b = 254
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
				//M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		screwdrivercocktail
			name = "Screwdriver"
			id = "screwdrivercocktail"
			description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
			reagent_state = LIQUID
			addictive = 1
			color_r = 230
			color_g = 210
			color_b = 85
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		bloody_mary
			name = "Bloody Mary"
			id = "bloodymary"
			color_r = 217
			color_g = 85
			color_b = 65
			description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		gargle_blaster
			name = "Pan-Galactic Gargle Blaster"
			id = "gargleblaster"
			description = "Whoah, this stuff looks volatile!"
			color_r = 65
			color_g = 217
			color_b = 161
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=6
				if(prob(10)) M:emote("scream")
				if(data >= 15 && data <45)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 45 && prob(50) && data <55)
					M.confused = max(M:confused+3,0)
				else if(data >=55)
					M.druggy = max(M.druggy, 55)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 5

		brave_bull
			name = "Brave Bull"
			id = "bravebull"
			color_r = 171
			color_g = 17
			color_b = 0
			description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <145)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 145 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		tequilla_sunrise
			name = "Tequilla Sunrise"
			id = "tequillasunrise"
			color_r = 212
			color_g = 161
			color_b = 66
			description = "Tequilla and orange juice. Much like a Screwdriver, only Mexican~"
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		toxins_special
			name = "Toxins Special"
			id = "toxinsspecial"
			color_r = 212
			color_g = 66
			color_b = 202
			description = "This thing is FLAMING!. CALL THE DAMN SHUTTLE!"
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 330)
					M.bodytemperature = min(330, M.bodytemperature+15) //310 is the normal bodytemp. 310.055
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 3

		beepsky_smash
			name = "Beepsky Smash"
			id = "beepskysmash"
			color_r = 196
			color_g = 196
			color_b = 196
			description = "Deny drinking this and prepare for THE LAW."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				M.stunned = 2
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		doctor_delight
			name = "The Doctor's Delight"
			id = "doctorsdelight"
			color_r = 113
			color_g = 255
			color_b = 18
			description = "A gulp a day keeps the MediBot away. That's probably for the best."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(50)) M:oxyloss -= 2
				if(M:bruteloss && prob(60)) M:heal_organ_damage(2,0)
				if(M:fireloss && prob(50)) M:heal_organ_damage(0,2)
				if(M:toxloss && prob(50)) M:toxloss -= 2
				if(M.dizziness !=0) M.dizziness = max(0,M.dizziness-15)
				if(M.confused !=0) M.confused = max(0,M.confused - 5)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming -= 3

		irish_cream
			name = "Irish Cream"
			id = "irishcream"
			color_r = 255
			color_g = 253
			color_b = 230
			description = "Whiskey-imbued cream, what else would you expect from the Irish."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 45 && data <145)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 145 && prob(33))
					M.confused = max(M:confused+2,0)
					M:confused += 0.5
					M:drowsyness += 0.5
				..()
				return

		manly_dorf
			name = "The Manly Dorf"
			id = "manlydorf"
			color_r = 33
			color_g = 31
			color_b = 5
			description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=5
				if(data >= 35 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		longislandicedtea
			name = "Long Island Iced Tea"
			id = "longislandicedtea"
			description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
			reagent_state = LIQUID
			addictive = 1
			color_r = 105
			color_g = 78
			color_b = 51
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		moonshine
			name = "Moonshine"
			id = "moonshine"
			color_r = 56
			color_g = 55
			color_b = 17
			description = "You've really hit rock bottom now... your liver packed its bags and left last night."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=5
				if(data >= 30 && data <60)
					if (!M.stuttering) M:stuttering = 1
					M.stuttering += 4
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 60 && prob(40))
					M.confused = max(M:confused+5,0)
				..()
				return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 3

		b52
			name = "B-52"
			id = "b52"
			color_r = 214
			color_g = 211
			color_b = 131
			description = "Coffee, Irish Cream, and cognac. You will get bombed."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 25 && data <90)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 90 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		irishcoffee
			name = "Irish Coffee"
			id = "irishcoffee"
			description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
			reagent_state = LIQUID
			addictive = 1
			color_r = 145
			color_g = 144
			color_b = 99
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <150)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 150 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		margarita
			name = "Margarita"
			id = "margarita"
			description = "On the rocks with salt on the rim. Arriba~!"
			color_r = 114
			color_g = 140
			color_b = 59
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 55 && data <150)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 150 && prob(33))
					M.confused = max(M:confused+2,0)
					M:confused += 0.5
					M:drowsyness += 0.5
				..()
				return

		black_russian
			name = "Black Russian"
			id = "blackrussian"
			color_r = 29
			color_g = 31
			color_b = 27
			description = "For the lactose-intolerant. Still as classy as a White Russian."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		manhattan
			name = "Manhattan"
			id = "manhattan"
			color_r = 33
			color_g = 22
			color_b = 13
			description = "The Detective's undercover drink of choice. He never could stomach gin..."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		manhattan_proj
			name = "Manhattan Project"
			id = "manhattan_proj"
			color_r = 32
			color_g = 13
			color_b = 33
			description = "A scientist drink of choice, for thinking how to blow up the station."
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				M.druggy = max(M.druggy, 30)
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		whiskeysoda
			name = "Whiskey Soda"
			id = "whiskeysoda"
			color_r = 212
			color_g = 210
			color_b = 123
			description = "Ultimate refreshment."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vodkatonic
			name = "Vodka and Tonic"
			id = "vodkatonic"
			color_r = 220
			color_g = 231
			color_b = 232
			description = "For when a gin and tonic isn't Russian enough."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
					M:confused += 0.5
					M:drowsyness += 0.5
				..()
				return

		ginfizz
			name = "Gin Fizz"
			id = "ginfizz"
			color_r = 235
			color_g = 237
			color_b = 204
			description = "Refreshingly lemony, deliciously dry."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=4
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
					M:confused += 0.5
					M:drowsyness += 0.5
				..()
				return

		bahama_mama
			name = "Bahama mama"
			id = "bahama_mama"
			description = "Tropic cocktail."
			reagent_state = LIQUID
			addictive = 1
			color_r = 217
			color_g = 237
			color_b = 204
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=3
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				..()
				return

		sbiten
			name = "Sbiten"
			id = "sbiten"
			description = "A spicy Vodka! Might be a little hot for the little guys!"
			reagent_state = LIQUID
			color_r = 212
			color_g = 180
			color_b = 180
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 360)
					M.bodytemperature = min(360, M.bodytemperature+50) //310 is the normal bodytemp. 310.055
				if(!data) data = 1
				data++
			//	M.dizziness +=6
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 6
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+5,5)
				..()
				return

		red_mead
			name = "Red Mead"
			id = "red_mead"
			description = "The true Viking drink! Even though it has a strange red color."
			reagent_state = LIQUID
			color_r = 204
			color_g = 24
			color_b = 24
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=5
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 4
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+4,4)
				..()
				return

		mead
			name = "Mead"
			id = "mead"
			description = "A Viking's drink, though a cheap one."
			reagent_state = LIQUID
			addictive = 1
			color_r = 191
			color_g = 145
			color_b = 92
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				M:nutrition += 2
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 0.5

				..()
				return

		iced_beer
			name = "Iced Beer"
			id = "iced_beer"
			color_r = 214
			color_g = 187
			color_b = 156
			description = "A beer which is so cold the air around it freezes."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if (M.bodytemperature < 270)
					M.bodytemperature = min(270, M.bodytemperature-40) //310 is the normal bodytemp. 310.055
				if(!data) data = 1
				data++
			//	M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				M:nutrition += 2
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 0.5

				..()
				return

		grog
			name = "Grog"
			id = "grog"
			description = "Watered down rum, Nanotrasen approves!"
			reagent_state = LIQUID
			addictive = 1
			color_r = 222
			color_g = 198
			color_b = 171
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
			//	M.dizziness +=2
				if(data >= 90 && data <250)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 2
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 250 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		soy_latte
			name = "Soy Latte"
			id = "soy_latte"
			color_r = 242
			color_g = 228
			color_b = 211
			description = "A nice and tasty beverage while you are reading your hippie books."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				..()
		//		M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				M.make_jittery(5)
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				M:nutrition++
				..()
				return

		cafe_latte
			name = "Cafe Latte"
			id = "cafe_latte"
			description = "A nice, strong and tasty beverage while you are reading."
			reagent_state = LIQUID
			color_r = 199
			color_g = 156
			color_b = 107
			on_mob_life(var/mob/living/M as mob)
				..()
		//		M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				M.make_jittery(5)
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				M:nutrition++
				..()
				return

		acid_spit
			name = "Acid Spit"
			id = "acidspit"
			color_r = 173
			color_g = 199
			color_b = 107
			description = "A drink by Nanotrasen. Made from live aliens."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
		//		M.dizziness +=10
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 10
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+10,0)
				..()
				return

		amasec
			name = "Amasec"
			id = "amasec"
			color_r = 199
			color_g = 107
			color_b = 138
			description = "Always before COMBAT!!!"
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				M.stunned = 4
				if(!data) data = 1
				data++
	//			M.dizziness +=4
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 4
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+5,0)
				..()
				return

		neurotoxin
			name = "Neurotoxin"
			id = "neurotoxin"
			color_r = 199
			color_g = 187
			color_b = 107
			description = "A strong neurotoxin that puts the subject into a death-like state."
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M:oxyloss += 0.5
				M:toxloss += 0.5
				M:weakened = max(M:weakened, 15)
				M:silent = max(M:silent, 15)
				if(!data) data = 1
				data++
	//			M.dizziness +=6
				if(data >= 15 && data <45)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 45 && prob(50) && data <55)
					M.confused = max(M:confused+3,0)
				else if(data >=55)
					M.druggy = max(M.druggy, 55)
				..()

				return


		hippies_delight
			name = "Hippies Delight"
			id = "hippiesdelight"
			description = "A drink enjoyed by people during the 1960's."
			color_r = 237
			color_g = 245
			color_b = 152
			reagent_state = LIQUID
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 50)
				if(!data) data = 1
				switch(data)
					if(1 to 5)
						if (!M:stuttering) M:stuttering = 1
						M.make_dizzy(10)
						if(prob(10)) M:emote(pick("twitch","giggle"))
					if(5 to 10)
						if (!M:stuttering) M:stuttering = 1
						M.make_jittery(20)
						M.make_dizzy(20)
						M:confused += 0.5
						M:drowsyness += 0.5
						M.druggy = max(M.druggy, 45)
						if(prob(20)) M:emote(pick("twitch","giggle"))
					if (10 to INFINITY)
						if (!M:stuttering) M:stuttering = 1
						M.make_jittery(40)
						M.make_dizzy(40)
						M.druggy = max(M.druggy, 60)
						if(prob(30)) M:emote(pick("twitch","giggle"))
				holder.remove_reagent(src.id, 0.2)
				data++
				..()
				return

		bananahonk
			name = "Banana Honk"
			id = "bananahonk"
			color_r = 255
			color_g = 255
			color_b = 0
			description = "A drink from Clown Heaven."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/living/M as mob)
				M:nutrition += nutriment_factor
				if(!data) data = 1
				data++
				if(istype(M, /mob/living/carbon/human) && M.job in list("Clown"))
					if(!M) M = holder.my_atom
					M:heal_organ_damage(1,1)
					M.dizziness +=5
					if(data >= 55 && data <165)
						if (!M.stuttering) M.stuttering = 1
						M.stuttering += 5
						M:confused += 0.5
						M:drowsyness += 0.5
					else if(data >= 165 && prob(33))
						M.confused = max(M:confused+5,0)
					..()
					return
				if(istype(M, /mob/living/carbon/monkey))
					if(!M) M = holder.my_atom
					M:heal_organ_damage(1,1)
					M.dizziness +=5
					if(data >= 55 && data <165)
						if (!M.stuttering) M.stuttering = 1
						M.stuttering += 5
					else if(data >= 165 && prob(33))
						M.confused = max(M:confused+5,0)
					..()
					return
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if(M.flaming)
					M.flaming += 10

		singulo
			name = "Singulo"
			id = "singulo"
			color_r = 174
			color_g = 0
			color_b = 255
			description = "A blue-space beverage!"
			reagent_state = LIQUID
			addictive = 1
			on_mob_life(var/mob/living/M as mob)
				if(!data) data = 1
				data++
		//		M.dizziness +=15
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 15
					M:confused += 0.5
					M:drowsyness += 0.5
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+15,15)
				..()
				return


