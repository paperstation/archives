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
		var/data = null
		var/volume = 0
		var/color_r = 0
		var/color_g = 0
		var/color_b = 0
		var/nutriment_factor = 0
		var/medical = 0
		proc
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
				var/datum/reagent/self = src
				src = null										  //of the reagent to the mob on TOUCHING it.
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
				var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
				var/icon/spillc = new/icon("icon" = 'effects.dmi', "icon_state" = "chemicalspill")
				spillc.Blend(rgb(src.color_r, src.color_g, src.color_b), ICON_ADD)
				B.overlays += spillc
				src = null
				return

			on_mob_life(var/mob/M)
				holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
				return

			on_move(var/mob/M)
				return

			on_update(var/atom/A)
				return

		metroid
			name = "Metroid Jam"
			id = "metroid"
			description = "A green semi-liquid produced from one of the deadliest lifeforms in existence."
			reagent_state = LIQUID
			color_r = 0
			color_g = 72
			color_b = 0
			on_mob_life(var/mob/M)
				if(prob(10))
					M << "You don't feel too good."
					M.toxloss+=20
				else if(prob(40))
					M:heal_organ_damage(5,0)
				..()



		blood
			data = new/list("donor"=null,"virus"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null)
			name = "Blood"
			id = "blood"
			reagent_state = LIQUID
			color_r = 105
			color_g = 0
			color_b = 0
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(M.virus) return //to prevent the healing of some serious shit with common cold injection.
				var/datum/reagent/blood/self = src
				src = null
				if(self.data["virus"])
					var/datum/disease/V = self.data["virus"]
					if(M.resistances.Find(V.type)) return
					if(method == TOUCH)//respect all protective clothing...
						M.contract_disease(V)
					else //injected
						M.contract_disease(V, 1, 0)
				return


			reaction_turf(var/turf/T, var/volume)//splash the blood all over the place
				var/datum/reagent/blood/self = src
				src = null
				if(!istype(T, /turf/simulated/)) return
				var/datum/disease/D = self.data["virus"]
				if(istype(self.data["donor"], /mob/living/carbon/human) || !self.data["donor"])
					var/turf/simulated/source2 = T
					var/list/objsonturf = range(0,T)
					var/i
					for(i=1, i<=objsonturf.len, i++)
						if(istype(objsonturf[i],/obj/decal/cleanable/blood))
							return
					var/obj/decal/cleanable/blood/blood_prop = new /obj/decal/cleanable/blood(source2)
					blood_prop.blood_DNA = self.data["blood_DNA"]
					blood_prop.blood_type = self.data["blood_type"]
					if(D)
						blood_prop.virus = new D.type
						blood_prop.virus.holder = blood_prop
					if(istype(T, /turf/simulated/floor) && D)
						blood_prop.virus.spread_type = CONTACT_FEET
					else if (D)
						blood_prop.virus.spread_type = CONTACT_HANDS

				else if(istype(self.data["donor"], /mob/living/carbon/monkey))
					var/turf/simulated/source1 = T
					var/obj/decal/cleanable/blood/blood_prop = new /obj/decal/cleanable/blood(source1)
					blood_prop.blood_DNA = self.data["blood_DNA"]
					if(D)
						blood_prop.virus = new D.type
						blood_prop.virus.holder = blood_prop
					if(istype(T, /turf/simulated/floor))
						blood_prop.virus.spread_type = CONTACT_FEET
					else
						blood_prop.virus.spread_type = CONTACT_HANDS

				else if(istype(self.data["donor"], /mob/living/carbon/alien))
					var/turf/simulated/source2 = T
					var/obj/decal/cleanable/xenoblood/blood_prop = new /obj/decal/cleanable/xenoblood(source2)
					if(D)
						blood_prop.virus = new D.type
						blood_prop.virus.holder = blood_prop
					if(istype(T, /turf/simulated/floor))
						blood_prop.virus.spread_type = CONTACT_FEET
					else
						blood_prop.virus.spread_type = CONTACT_HANDS
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
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				var/datum/reagent/vaccine/self = src
				src = null
				if(self.data&&method == INGEST)
					if(M.virus && M.virus.type == self.data)
						M.virus.cure()
					else if(!(self.data in M.resistances))
						M.resistances += self.data
				return

		poo
			name = "poo"
			id = "poo"
			description = "It's poo."
			reagent_state = LIQUID
			color_r = 64
			color_g = 32
			color_b = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom

				..()
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon/human))
					if(M:wear_suit) M:wear_suit.add_poo()
					if(M:w_uniform) M:w_uniform.add_poo()
					if(M:shoes) M:shoes.add_poo()
					if(M:gloves) M:gloves.add_poo()
					if(M:head) M:head.add_poo()
				if(method==INGEST)
					if(prob(20))
						M.contract_disease(new /datum/disease/gastric_ejections)
						M:toxloss += 0.1
						holder.remove_reagent(src.id, 0.2)

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/poo(T)

		urine
			name = "urine"
			id = "urine"
			description = "It's pee."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 102
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss -= 0.3
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/urine(T)

		cum
			name = "cum"
			id = "cum"
			description = "It's cum."
			reagent_state = LIQUID
			color_r = 255
			color_g = 255
			color_b = 102
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:health += 0.1
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/cum(T)

		jenkem
			name = "jenkem"
			id = "jenkem"
			description = "A bathtub drug made from human excrement."
			reagent_state = LIQUID
			color_r = 153
			color_g = 97
			color_b = 34
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:brainloss += 2
				M.druggy = max(M.druggy, 10)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(7)) M:emote(pick("twitch","drool","moan","giggle"))
				if(prob(5))
					M.contract_disease(new /datum/disease/gastric_ejections)
				holder.remove_reagent(src.id, 0.2)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/poo(T)

		vomit
			name = "Vomit"
			id = "vomit"
			description = "Vomit, usually produced when someone gets drunk as hell."
			reagent_state = LIQUID
			color_r = 153
			color_g = 97
			color_b = 34
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(5))
					M.contract_disease(new /datum/disease/gastric_ejections)
				holder.remove_reagent(src.id, 0.2)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/vomit(T)

		bad_bacteria
			name = "Bacteria"
			id = "bad_bacteria"
			description = "May cause food poisoning."
			reagent_state = LIQUID
			color_r = 153
			color_g = 97
			color_b = 34
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(5))
					M.contract_disease(new /datum/disease/gastric_ejections)
				holder.remove_reagent(src.id, 0.2)
				return

		water
			name = "Water"
			id = "water"
			description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
			reagent_state = LIQUID
			color_r = 179
			color_g = 255
			color_b = 255
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 3)
					if(T:wet >= 1) return
					T:wet = 1
					if(T:wet_overlay)
						T:overlays -= T:wet_overlay
						T:wet_overlay = null
					T:wet_overlay = image('water.dmi',T,"wet_floor")
					T:overlays += T:wet_overlay

					spawn(800)
						if(T:wet >= 2) return
						T:wet = 0
						if(T:wet_overlay)
							T:overlays -= T:wet_overlay
							T:wet_overlay = null

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

		lube
			name = "Space Lube"
			id = "lube"
			description = "A substance introduced between two moving surfaces to reduce the friction and wear between them."
			reagent_state = LIQUID
			color_r = 90
			color_g = 210
			color_b = 250
			reaction_turf(var/turf/T, var/volume)
				if (!istype(T, /turf/space))
					src = null
					if(T:wet >= 2) return
					T:wet = 2
					spawn(800)
						T:wet = 0
						if(T:wet_overlay)
							T:overlays -= T:wet_overlay
							T:wet_overlay = null

					return

			on_mob_life(var/mob/M)

		bilk
			name = "Bilk"
			id = "bilk"
			description = "Beer mixed with milk."
			reagent_state = LIQUID
			color_r = 197
			color_g = 148
			color_b = 35

		anti_toxin
			name = "Dylovene"
			id = "anti_toxin"
			description = "Dylovene is a broad-spectrum antitoxin."
			medical = 1
			reagent_state = LIQUID
			color_r = 11
			color_g = 67
			color_b = 97
			on_mob_life(var/mob/M)
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss += 1.5
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss += 1
				M:oxyloss += 1
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red []'s mouth starts to foam!", M), 1)
				..()
				return

		apitoxin
			name = "Apitoxin"
			id = "apitoxin"
			description = "Apitoxin, or honey bee venom, is a bitter colorless liquid. The active portion of the venom is a complex mixture of proteins, which causes local inflammation and acts as an anticoagulant. The venom is produced in the abdomen of worker bees from a mixture of acidic and basic secretions."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 15)
						M.eye_blurry = max(M.eye_blurry, 10)
						M:toxloss += 0.1
					if(15 to 25)
						M:drowsyness  = max(M:drowsyness, 20)
						M:toxloss += 0.2
					if(25 to INFINITY)
						M:toxloss += 0.4
						M:paralysis = max(M:paralysis, 20)
						M:drowsyness  = max(M:drowsyness, 30)
				data++
				..()
				return

		stoxin
			name = "Sleep Toxin"
			id = "stoxin"
			description = "An effective hypnotic used to treat insomnia."
			medical = 1
			reagent_state = LIQUID
			color_r = 99
			color_g = 193
			color_b = 143
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
				data++
				..()
				return

		inaprovaline
			name = "Inaprovaline"
			id = "inaprovaline"
			description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
			medical = 1
			reagent_state = LIQUID
			color_r = 19
			color_g = 117
			color_b = 25
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 1)
					M.losebreath = max(1, M.losebreath-5)
					M.updatehealth()
				holder.remove_reagent(src.id, 0.2)
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 	1)
					M.losebreath = max(-30, M.losebreath-80)
					M:oxyloss = max(M:oxyloss-10, 0)
					M.updatehealth()
				holder.remove_reagent(src.id, 0.2)
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
				M.updatehealth()
				holder.remove_reagent(src.id, 0.2)


		cytoglobin
			name = "Cytoglobin"
			id = "cytoglobin"
			description = "Cytoglobin is an extremely powerful drug that could be used to treat viral infections and cure most ailments."
			medical = 1
			reagent_state = LIQUID
			color_r = 234
			color_g = 163
			color_b = 55
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature = max(310, M.bodytemperature-10)
				else if(M.bodytemperature > 311)
					M.bodytemperature = min(310, M.bodytemperature+10)
				M.losebreath = max(-5, M.losebreath-50)
				M:oxyloss = max(-5, M.oxyloss-0.1)
				M:bruteloss = max(-5, M.bruteloss-0.1)
				M:fireloss = max(-5, M.fireloss-0.1)
				M:toxloss = max(-5, M.toxloss-0.1)
				if(M:paralysis) M:paralysis--
				if(M:stunned) M:stunned--
				if(M:weakened) M:weakened--
				M.updatehealth()
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature = max(310, M.bodytemperature-10)
				else if(M.bodytemperature > 311)
					M.bodytemperature = min(310, M.bodytemperature+10)
				M.losebreath = max(-15, M.losebreath-21)
				M:oxyloss = max(-2, M.oxyloss-0.1)
				M:bruteloss = max(-2, M.bruteloss-0.1)
				M:fireloss = max(-2, M.fireloss-0.1)
				M:toxloss = max(-2, M.toxloss-0.1)
				if(M:paralysis) M:paralysis--
				if(M:stunned) M:stunned--
				if(M:weakened) M:weakened--
				M.updatehealth()
				holder.remove_reagent(src.id, 0.2)

		polyadrenalobin
			name = "Polyadrenalobin"
			id = "polyadrenalobin"
			description = "Polyadrenalobin is designed to be a stimulant, it can aid in the revival of a patient who has died or is near death."
			medical = 1
			reagent_state = LIQUID
			color_r = 189
			color_g = 4
			color_b = 92
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					for(var/A in H.organs)
						var/datum/organ/external/affecting = null
						if(!H.organs[A])    continue
						affecting = H.organs[A]
						if(!istype(affecting, /datum/organ/external))    continue
						affecting.heal_damage(1000, 1000)
				if((M.health < -200) && (!(M.stat > 1)))
					M.health += 0.1
					M.oxyloss = -15
					M.updatehealth()
				else if((M.stat == 0) && (!(M.health < -200)))
					M.health += 0.1
					M.oxyloss = -15
					M.updatehealth()
					M:brainloss = 0.5

				else if ((M.stat > 1) && (!(M.health < -200)))
					sleep(50)
					M.stat=0
					M.oxyloss = -15
					M.health += 0.1
					M:brainloss = 1
					M.updatehealth()
				else if ((M.stat > 1) && (M.health < -200))
					sleep(100)
					M.stat=0
					M.oxyloss = -75
					M.health += 0.1
					M:brainloss = 10
					M.updatehealth()
				else
					M.oxyloss = -15
					M.health += 0.1
					if(M.stat)
						M.stat=0
						sleep(20)
					M.updatehealth()
					return
				holder.remove_reagent(src.id, 0.2)



		kayolane
			name = "Kayolane"
			id = "kayolane"
			description = "Kayolane is a sedative which causes unconsciousness for several hours."
			medical = 1
			reagent_state = LIQUID
			color_r = 192
			color_g = 198
			color_b = 94
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
		biomorph
			name = "Biomorphic Serum"
			id = "biomorph"
			description = "Biomorphic Serum was thought to be greatest advancement to human kind, it gave people physic abilities; The problem was, when it was tested on a group, 99% of the group had adverse reations and died."
			medical = 1
			reagent_state = LIQUID
			color_r = 105
			color_g = 0
			color_b = 0
			var/safe = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(1))
					if (!(M.mutations & 1))
						M.mutations |= 1
				M.make_dizzy(1)
				if(!M.confused) M.confused = 1
				M.confused = max(M.confused, 20)
				M.bodytemperature += 10
				M.radiation++
				M:toxloss++
				M:bruteloss++
				M.losebreath++
				M:fireloss++
				holder.remove_reagent(src.id, 0.05)
				..()

		space_drugs
			name = "Space drugs"
			id = "space_drugs"
			description = "An illegal chemical compound used as drug."
			reagent_state = LIQUID
			color_r = 250
			color_g = 255
			color_b = 250
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.druggy = max(M.druggy, 15)
				if(M.canmove) step(M, pick(cardinal))
				if(prob(7)) M:emote(pick("twitch","drool","moan","giggle"))
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
			on_mob_life(var/mob/M)
				M.druggy = max(M.druggy, 5)
				if(prob(50)) M.health += 20
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
			on_mob_life(var/mob/M)
				if(prob(1)) M.health -= 0.01
				if(prob(1)) M:nicotineaddiction = 1
				if(prob(2)) M:emote(pick("cough"))
				if(prob(20)) M:nicsmoketime = 0
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
			on_mob_life(var/mob/M)
				M:horny = 1
				M:toxloss += 0.03
				holder.remove_reagent(src.id, 0.2)
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


		synthblood
			name = "Synthblood"
			id = "synthblood"
			description = "A synthesized replica of human blood with added nutrients for viral culturing."
			reagent_state = LIQUID
			color_r = 105
			color_g = 0
			color_b = 0
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

		copper
			name = "Copper"
			id = "copper"
			description = "A highly ductile metal."
			color_r = 188
			color_g = 126
			color_b = 33

		nitrogen
			name = "Nitrogen"
			id = "nitrogen"
			description = "A colorless, odorless, tasteless gas."
			reagent_state = GAS
			color_r = 133
			color_g = 236
			color_b = 255

		hydrogen
			name = "Hydrogen"
			id = "hydrogen"
			description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
			reagent_state = GAS
			color_r = 133
			color_g = 236
			color_b = 255

		potassium
			name = "Potassium"
			id = "potassium"
			description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
			reagent_state = SOLID
			color_r = 249
			color_g = 249
			color_b = 249

		mercury
			name = "Mercury"
			id = "mercury"
			description = "A chemical element."
			reagent_state = LIQUID
			color_r = 170
			color_g = 170
			color_b = 170
			on_mob_life(var/mob/M)
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

		carbon
			name = "Carbon"
			id = "carbon"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 90
			color_g = 90
			color_b = 90
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/dirt(T)

		chlorine
			name = "Chlorine"
			id = "chlorine"
			description = "A chemical element."
			reagent_state = GAS
			color_r = 225
			color_g = 227
			color_b = 125
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:bruteloss++
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
			on_mob_life(var/mob.M)
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

		phosphorus
			name = "Phosphorus"
			id = "phosphorus"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 106
			color_g = 53
			color_b = 53

		lithium
			name = "Lithium"
			id = "lithium"
			description = "A chemical element."
			reagent_state = SOLID
			color_r = 206
			color_g = 204
			color_b = 193
			on_mob_life(var/mob/M)
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

		acid
			name = "Sulphuric acid"
			id = "acid"
			description = "A strong mineral acid with the molecular formula H2SO4."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss++
				M:fireloss++
				..()
				return
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M:wear_mask)
							del (M:wear_mask)
							M << "\red Your mask melts away but protects you from the acid!"
							return
						if(M:head)
							del (M:head)
							M << "\red Your helmet melts into uselessness but protects you from the acid!"
							return

					if(prob(75))
						var/datum/organ/external/affecting = M:organs["head"]
						if(affecting)
							affecting.take_damage(25, 0)
							M:UpdateDamage()
							M:UpdateDamageIcon()
							M:emote("scream")
							M << "\red Your face has become disfigured!"
							M.real_name = "Unknown"
					else
						M:bruteloss += 15
				else
					M:bruteloss += 15

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item) && prob(40))
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss++
				M:fireloss++
				..()
				return
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M:wear_mask)
							del (M:wear_mask)
							M << "\red Your mask melts away!"
							return
						if(M:head)
							del (M:head)
							M << "\red Your helmet melts into uselessness!"
							return
						var/datum/organ/external/affecting = M:organs["head"]
						if(affecting)
							affecting.take_damage(75, 0)
							M:UpdateDamage()
							M:UpdateDamageIcon()
							M:emote("scream")
							M << "\red Your face has become disfigured!"
							M.real_name = "Unknown"
					else
						M:bruteloss += 15
				else
					if(istype(M, /mob/living/carbon/human))
						var/datum/organ/external/affecting = M:organs["head"]
						if(affecting)
							affecting.take_damage(75, 0)
							M:UpdateDamage()
							M:UpdateDamageIcon()
							M:emote("scream")
							M << "\red Your face has become disfigured!"
							M.real_name = "Unknown"
					else
						M:bruteloss += 15

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in viewers(5, O))
						M << "\red \the [O] melts."
					del(O)

		sacid
			name = "Salicylic Acid"
			id = "sacid"
			description = "A liquid compound that aids tissue development. It can be used to help complete unfinished personnel regeration at low tempuratures."
			reagent_state = LIQUID
			color_r = 235
			color_g = 156
			color_b = 10
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					if(M:cloneloss) M:cloneloss = max(0, M:cloneloss-3)
					if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-1)
					if(M:bruteloss && prob(40)) M:heal_organ_damage(1,0)
					if(M:fireloss) M:fireloss = max(0, M:fireloss-2)
				..()
				return

		glycerol
			name = "Glycerol"
			id = "glycerol"
			description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
			reagent_state = LIQUID
			color_r = 227
			color_g = 225
			color_b = 130

		nitroglycerin
			name = "Nitroglycerin"
			id = "nitroglycerin"
			description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255

		radium
			name = "Radium"
			id = "radium"
			description = "Radium is an alkaline earth metal. It is extremely radioactive."
			reagent_state = SOLID
			color_r = 0
			color_g = 255
			color_b = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.radiation += 3
				..()
				return
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/greenglow(T)

		unstablefuel
			name = "Unstable Fuel"
			id = "unstablefuel"
			description = "Extremely unstable mutated form of fuel."
			reagent_state = LIQUID
			color_r = 166
			color_g = 255
			color_b = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.radiation += 12
				var/datum/effects/system/reagents_explosion/e = new()
				e.set_up(round (1, 1), M.loc, 0, 0)
				e.start()
				holder.remove_reagent(src.id, 10)
				return
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					new /obj/decal/cleanable/greenglow(T)
					new /obj/decal/cleanable/greenglow(T)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 20
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				var/datum/effects/system/reagents_explosion/e = new()
				e.set_up(round (3, 1), T.loc, 0, 0)
				e.start()


		ryetalyn
			name = "Ryetalyn"
			id = "ryetalyn"
			description = "Ryetalyn can cure most genetic abnomalities."
			medical = 1
			reagent_state = SOLID
			color_r = 210
			color_g = 211
			color_b = 201
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.mutations = 0
				M.disabilities = 0
				M.sdisabilities = 0
				..()
				return

		thermite
			name = "Thermite"
			id = "thermite"
			description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
			reagent_state = SOLID
			color_r = 146
			color_g = 120
			color_b = 95
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(istype(T, /turf/simulated/wall))
					T:thermite = 1
					T.overlays = null
					T.overlays = image('effects.dmi',icon_state = "thermite")
				return

		mutagen
			name = "Unstable mutagen"
			id = "mutagen"
			description = "Might cause unpredictable mutations. Keep away from children."
			reagent_state = LIQUID
			color_r = 83
			color_g = 138
			color_b = 60
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
			on_mob_life(var/mob/M)
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
			on_mob_life(var/mob/M)
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
/*
			on_mob_life(var/mob/M)
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

		aluminium
			name = "Aluminium"
			id = "aluminium"
			description = "A silvery white and ductile member of the boron group of chemical elements."
			reagent_state = SOLID
			color_r = 207
			color_g = 207
			color_b = 207

		silicon
			name = "Silicon"
			id = "silicon"
			description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
			reagent_state = SOLID
			color_r = 223
			color_g = 213
			color_b = 179

		fuel
			name = "Welding fuel"
			id = "fuel"
			description = "Required for welders. Flamable."
			reagent_state = LIQUID
			color_r = 214
			color_g = 205
			color_b = 101
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
			on_mob_life(var/mob/M)
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
			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				M.clean_blood()
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


		plantbgone
			name = "Plant-B-Gone"
			id = "plantbgone"
			description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
			reagent_state = LIQUID
			color_r = 227
			color_g = 94
			color_b = 224
			/* Don't know if this is necessary.
			on_mob_life(var/mob/living/carbon/M)
				if(!M) M = holder.my_atom
				M:toxloss += 3.0
				..()
				return
			*/
			reaction_obj(var/obj/O, var/volume)
		//		if(istype(O,/obj/plant/vine/))
		//			O:life -= rand(15,35) // Kills vines nicely // Not tested as vines don't work in R41
				if(istype(O,/obj/alien/weeds/))
					O:health -= rand(15,35) // Kills alien weeds pretty fast
					O:healthcheck()
				// Damage that is done to growing plants is separately
				// at code/game/machinery/hydroponics at obj/item/hydroponics

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/living/carbon))
					if(!M.wear_mask) // If not wearing a mask
						M:toxloss += 2 // 4 toxic damage per application, doubled for some reason
						//if(prob(10))
							//M.make_dizzy(1) doesn't seem to do anything


		plasma
			name = "Plasma"
			id = "plasma"
			description = "Plasma in its liquid form."
			reagent_state = LIQUID
			color_r = 227
			color_g = 144
			color_b = 0
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("inaprovaline"))
					holder.remove_reagent("inaprovaline", 2)
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

		leporazine
			name = "Leporazine"
			id = "leporazine"
			description = "Leporazine can be use to stabilize an individuals' body temperature."
			medical = 1
			reagent_state = LIQUID
			color_r = 18
			color_g = 218
			color_b = 158
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 310)
					M.bodytemperature = max(310, M.bodytemperature-10)
				else if(M.bodytemperature > 311)
					M.bodytemperature = min(310, M.bodytemperature+10)
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
			on_mob_life(var/mob/M)
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(33)) M.bruteloss++
				holder.remove_reagent(src.id, 0.3)
				..()
				return

		kelotane
			name = "Kelotane"
			id = "kelotane"
			description = "Kelotane is a drug used to treat burns."
			medical = 1
			reagent_state = LIQUID
			color_r = 129
			color_g = 201
			color_b = 150
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:heal_organ_damage(0,2)
				..()
				return

		dexalin
			name = "Dexalin"
			id = "dexalin"
			description = "Dexalin is used in the treatment of oxygen deprivation."
			medical = 1
			reagent_state = LIQUID
			color_r = 237
			color_g = 90
			color_b = 90
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:oxyloss = max(M:oxyloss-2, 0)
				..()
				return

		dexalinp
			name = "Dexalin Plus"
			id = "dexalinp"
			description = "Dexalin Plus is used in the treatment of oxygen deprivation. Its highly effective."
			medical = 1
			reagent_state = LIQUID
			color_r = 208
			color_g = 74
			color_b = 74
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:oxyloss = 0
				..()
				return

		tricordrazine
			name = "Tricordrazine"
			id = "tricordrazine"
			description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
			medical = 1
			reagent_state = LIQUID
			color_r = 120
			color_g = 166
			color_b = 36
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(10)) M:oxyloss--
				if(M:bruteloss && prob(10)) M:heal_organ_damage(1,0)
				if(M:fireloss && prob(10)) M:heal_organ_damage(0,1)
				if(M:toxloss && prob(10)) M:toxloss--
				..()
				return

		wizordrazine //OP reagent for wizards
			name = "Wizordrazine"
			id = "wizordrazine"
			description = "I don't have to explain shit about Wizordrazine, its magic."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:cloneloss) M:cloneloss = max(0, M:cloneloss-3)
				if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-3)
				M:heal_organ_damage(3,3)
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
				M:brainloss = max(M:brainloss-3 , 0)
				M.disabilities = 0
				M.sdisabilities = 0
				if(M:toxloss) M:toxloss = max(0, M:toxloss-3)
				..()
				return

		synaptizine
			name = "Synaptizine"
			id = "synaptizine"
			description = "Synaptizine is used to treat neuroleptic shock. Can be used to help remove disabling symptoms such as paralysis."
			medical = 1
			reagent_state = LIQUID
			color_r = 242
			color_g = 13
			color_b = 156
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-5, 0)
				if(M:paralysis) M:paralysis--
				if(M:stunned) M:stunned--
				if(M:weakened) M:weakened--
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:jitteriness = max(M:jitteriness-5,0)
				if(prob(80)) M:brainloss++
				if(prob(50)) M:drowsyness = max(M:drowsyness, 3)
				if(prob(10)) M:emote("drool")
				..()
				return

		adminordrazine //An OP chemical for admins
			name = "Adminordrazine"
			id = "adminordrazine"
			description = "I don't have to explain shit about adminordrazine, its magic."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:cloneloss) M:cloneloss = max(0, M:cloneloss-5)
				if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-5)
				M:heal_organ_damage(5,5)
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
				M:brainloss = max(M:brainloss-5 , 0)
				M.disabilities = 0
				M.sdisabilities = 0
				M:eye_blurry = max(M:eye_blurry-5 , 0)
				M:eye_blind = max(M:eye_blind-5 , 0)
				M:disabilities &= ~1
				M:sdisabilities &= ~1
				if(M:toxloss) M:toxloss = max(0, M:toxloss-5)
				..()
				return

		hyronalin
			name = "Hyronalin"
			id = "hyronalin"
			description = "Hyronalin is a medicinal drug used to counter the effects of radiation poisoning."
			medical = 1
			reagent_state = LIQUID
			color_r = 169
			color_g = 189
			color_b = 108
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:radiation && prob(80)) M:radiation--
				..()
				return

		alkysine
			name = "Alkysine"
			id = "alkysine"
			description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
			medical = 1
			reagent_state = LIQUID
			color_r = 236
			color_g = 179
			color_b = 128
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:brainloss = max(M:brainloss-3 , 0)
				..()
				return

		ketaminol
			name = "2-Cycloketaminol"
			id = "ketaminol"
			description = "A secundary alcohol with a CNS-depressing effect. Can cause a quick death if used in large dosages."
			reagent_state = LIQUID
			color_r = 128
			color_g = 128
			color_b = 128
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1 to 5)
						if(data == 1)
							M << "\red Reality begings to snap away."
							M << "\red You feel weak."
						M.eye_blurry = max(M.eye_blurry, 10)
						if(prob(5)) M:emote("twitch")
						data++
						..()
					if(5 to 10)
						M:drowsyness  = max(M:drowsyness, 20)
						M:paralysis = max(M:paralysis, 20)
						M.eye_blurry = max(M.eye_blurry, 20)

						data++
						..()
					if(10 to 25)
						M:drowsyness  = max(M:drowsyness, 30)
						M:paralysis = max(M:paralysis, 30)
						M.eye_blurry = max(M.eye_blurry, 30)

						data++
						..()
					if(25 to INFINITY)
						if(data == 25)
						//	M << "\red You feel your life fading away."
							M:emote("twitch")
							data++
						M:paralysis = max(M:paralysis, 30)
						M:drowsyness  = max(M:drowsyness, 20)
						M:oxyloss += 5
				return

		zaldy
			name = "Zaldy"
			id = "zaldy"
			description = "An illegal formula that causes blindness when it enters the body."
			reagent_state = LIQUID
			color_r = 64
			color_g = 64
			color_b = 64
			on_mob_life(var/mob/M)
				if(M:eye_blind == null || M:eye_blind == 0) //Doesn't work if they're already blind
					M << "\red Your eyes sting!"
					M:emote("scream")
					M:eye_blind = max(M:eye_blind, 100) //HUGELY OP, feel free to scroll that number down a ton
				..()
				return


		imidazoline
			name = "Imidazoline"
			id = "imidazoline"
			description = "Heals eye damage"
			medical = 1
			reagent_state = LIQUID
			color_r = 189
			color_g = 197
			color_b = 202
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:eye_blurry = max(M:eye_blurry-5 , 0)
				M:eye_blind = max(M:eye_blind-5 , 0)
				M:disabilities &= ~1
//				M:sdisabilities &= ~1		Replaced by eye surgery
				..()
				return

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
			medical = 1
			reagent_state = LIQUID
			color_r = 109
			color_g = 31
			color_b = 31
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-3,0)
				if(M:toxloss && prob(50)) M:toxloss--
				if(prob(15)) M:bruteloss++
				..()
				return

		bicaridine
			name = "Bicaridine"
			id = "bicaridine"
			description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
			medical = 1
			reagent_state = LIQUID
			color_r = 28
			color_g = 72
			color_b = 128
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:heal_organ_damage(2,0)
				..()
				return

		hyperzine
			name = "Hyperzine"
			id = "hyperzine"
			description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
			medical = 1
			reagent_state = LIQUID
			color_r = 183
			color_g = 96
			color_b = 143
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(5)) M:emote(pick("twitch","blink_r","shiver"))
				if(prob(20)) M:horny = 1
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		cryoxadone
			name = "Cryoxadone"
			id = "cryoxadone"
			description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
			medical = 1
			reagent_state = LIQUID
			color_r = 0
			color_g = 0
			color_b = 255
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					if(M:oxyloss) M:oxyloss = max(0, M:oxyloss-3)
					if(M:bruteloss && prob(40)) M:heal_organ_damage(1,0)
					if(M:toxloss) M:toxloss = max(0, M:toxloss-3)
				..()
				return

		spaceacillin
			name = "Spaceacillin"
			id = "spaceacillin"
			description = "An all-purpose antiviral agent."
			medical = 1
			reagent_state = LIQUID
			color_r = 78
			color_g = 121
			color_b = 34
			on_mob_life(var/mob/M)//no more mr. panacea
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
			on_mob_life(var/mob/M)
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:oxyloss += 0.5
				M:toxloss += 0.5
				M:weakened = max(M:weakened, 10)
				M:silent = max(M:silent, 10)
				..()
				return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////

		nanites
			name = "Nanomachines"
			id = "nanites"
			description = "Microscopic construction robots."
			reagent_state = LIQUID
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if( (prob(10) && method==TOUCH) || method==INGEST)
					M.contract_disease(new /datum/disease/robotic_transformation(0),1)

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

/* Why is this defined twice?
		nicotine
			name = "Nicotine"
			id = "nicotine"
			description = "A highly addictive stimulant extracted from the tobacco plant."
			reagent_state = LIQUID
*/
		ethanol
			name = "Ethanol"
			id = "ethanol"
			description = "A well-known alcohol with a variety of applications."
			reagent_state = LIQUID
			color_r = 133
			color_g = 236
			color_b = 255
			on_mob_life(var/mob/M)
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
				..()
				return

		ammonia
			name = "Ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."
			reagent_state = GAS
			color_r = 133
			color_g = 236
			color_b = 255

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID
			color_r = 188
			color_g = 224
			color_b = 231

		ethylredoxrazine						// FUCK YOU, ALCOHOL
			name = "Ethylredoxrazine"
			id = "ethylredoxrazine"
			description = "A powerfuld oxidizer that reacts with ethanol."
			reagent_state = SOLID
			color_r = 145
			color_g = 187
			color_b = 140
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.dizziness = 0
				M:drowsyness = 0
				M:stuttering = 0
				M:confused = 0
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1)
						M:confused += 2
						M:drowsyness += 2
					if(2 to 50)
						M:sleeping += 1
					if(51 to INFINITY)
						M:sleeping += 1
						M:toxloss += (data - 50)
				data++
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1)
						M:confused += 2
						M:drowsyness += 2
					if(2 to 50)
						M:sleeping += 1
					if(51 to INFINITY)
						M:sleeping += 1
						M:toxloss += (data - 50)
				data++
				..()
				return


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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(50)) M:heal_organ_damage(1,0)
				M:nutrition += nutriment_factor	// For hunger and fatness

				if (M.nutrition > 650)
					M.nutrition = rand (250, 400)
					M.weakened += rand(2, 10)
					M.jitteriness += rand(0, 5)
					M.dizziness = max (0, (M.dizziness - rand(0, 15)))
					M.druggy = max (0, (M.druggy - rand(0, 15)))
					M.toxloss = max (0, (M.toxloss - rand(5, 15)))
					M.updatehealth()

				..()
				return

		soysauce
			name = "Soysauce"
			id = "soysauce"
			description = "A salty sauce made from the soy plant."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM
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

		ketchup
			name = "Ketchup"
			id = "ketchup"
			description = "Ketchup, catsup, whatever. It's tomato paste."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			color_r = 224
			color_g = 52
			color_b = 52

		capsaicin
			name = "Capsaicin Oil"
			id = "capsaicin"
			description = "This is what makes chilis hot."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			color_r = 208
			color_g = 79
			color_b = 23
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:bodytemperature += 5
				if(prob(40)) M:fireloss++
				..()
				return

		oleoresincapsicum
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

		frostoil
			name = "Frost Oil"
			id = "frostoil"
			description = "A special oil that noticably chills the body. Extraced from Icepeppers."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			color_r = 85
			color_g = 193
			color_b = 213
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				if(M.flaming)
					M.flaming -= 5
				if(prob(40)) M:fireloss++
				..()
				return

		sodiumchloride
			name = "Table Salt"
			id = "sodiumchloride"
			description = "A salt made of sodium chloride. Commonly used to season food."
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 252
			color_g = 252
			color_b = 252

		blackpepper
			name = "Black Pepper"
			id = "blackpepper"
			description = "A power ground from peppercorns. *AAAACHOOO*"
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 30
			color_g = 30
			color_b = 30

		amatoxin
			name = "Amatoxin"
			id = "amatoxin"
			description = "A powerful poison derived from certain species of mushroom."
			color_r = 185
			color_g = 177
			color_b = 151
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		psilocybin
			name = "Psilocybin"
			id = "psilocybin"
			description = "A strong psycotropic derived from certain species of mushroom."
			on_mob_life(var/mob/M)
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
						M.druggy = max(M.druggy, 31)
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
			on_mob_life(var/mob/M)
				M:nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective"))
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
			on_mob_life(var/mob/M)
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
			on_mob_life(var/mob/M)
				M:nutrition += nutriment_factor
				..()
				return
			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 3)
					if(T:wet >= 1) return
					T:wet = 1
					if(T:wet_overlay)
						T:overlays -= T:wet_overlay
						T:wet_overlay = null
					T:wet_overlay = image('water.dmi',T,"wet_floor")
					T:overlays += T:wet_overlay

					spawn(800)
						if(T:wet >= 2) return
						T:wet = 0
						if(T:wet_overlay)
							T:overlays -= T:wet_overlay
							T:wet_overlay = null
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
			description = "A universal enzyme used in the preperation of certain chemicals and foods."
			reagent_state = LIQUID
			color_r = 187
			color_g = 226
			color_b = 29

		berryjuice
			name = "Berry Juice"
			id = "berryjuice"
			description = "A delicious blend of several different kinds of berries."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 179
			color_g = 23
			color_b = 155
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				..()
				return

		banana
			name = "Essence of Banana"
			id = "banana"
			description = "The raw essence of a banana. HONK"
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color_r = 227
			color_g = 239
			color_b = 3

		dry_ramen
			name = "Dry Ramen"
			id = "dry_ramen"
			description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
			reagent_state = SOLID
			color_r = 239
			color_g = 228
			color_b = 176
			on_mob_life(var/mob/M)
				..()
				M:nutrition += 1
				return

		hot_ramen
			name = "Hot Ramen"
			id = "hot_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in space school."
			reagent_state = LIQUID
			color_r = 239
			color_g = 228
			color_b = 176
			on_mob_life(var/mob/M)
				..()
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+10)
				M:nutrition += 5
				return

		hell_ramen
			name = "Hell Ramen"
			id = "hell_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in space school."
			reagent_state = LIQUID
			color_r = 239
			color_g = 228
			color_b = 176
			on_mob_life(var/mob/M)
				..()
				M:bodytemperature += 10
				M:nutrition += 5
				return

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
		milk
			name = "Milk"
			id = "milk"
			description = "An opaque white liquid produced by the mammary glands of mammals."
			reagent_state = LIQUID
			color_r = 249
			color_g = 249
			color_b = 245
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:bruteloss && prob(10)) M:heal_organ_damage(1,0)
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
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:bruteloss && prob(10)) M:heal_organ_damage(1,0)
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
			on_mob_life(var/mob/M)
				..()
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				M.bodytemperature = min(310, M.bodytemperature+5) //310 is the normal bodytemp. 310.055
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
			on_mob_life(var/mob/M)
				..()
				M.dizziness = max(0,M.dizziness-2)
				M:drowsyness = max(0,M:drowsyness-1)
				M:sleeping = 0
				if(M:toxloss && prob(50))
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
			on_mob_life(var/mob/M)
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
			on_mob_life(var/mob/M)
				..()
				M.dizziness = max(0,M.dizziness-2)
				M:drowsyness = max(0,M:drowsyness-1)
				M:sleeping = 0
				if(M:toxloss && prob(50)) M:toxloss--
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature-5)
				return

		h_chocolate
			name = "Hot Chocolate"
			id = "h_chocolate"
			description = "Made with love! And coco beans."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				..()
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				return

		space_cola
			name = "Cola"
			id = "cola"
			description = "A refreshing beverage."
			reagent_state = LIQUID
			color_r = 83
			color_g = 60
			color_b = 36
			on_mob_life(var/mob/M)
				M:drowsyness = max(0,M:drowsyness-5)
				M.bodytemperature = max(310, M.bodytemperature-5) //310 is the normal bodytemp. 310.055
				..()
				return

		spacemountainwind
			name = "Space Mountain Wind"
			id = "spacemountainwind"
			description = "Blows right through you like a space wind."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M:drowsyness = max(0,M:drowsyness-7)
				M:sleeping = 0
				M.bodytemperature = max(310, M.bodytemperature-5)
				M.make_jittery(5)
				..()
				return

		thirteenloko
			name = "Thirteen Loko"
			id = "thirteenloko"
			description = "A potent mixture of caffeine and alcohol."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M:drowsyness = max(0,M:drowsyness-7)
				M:sleeping = 0
				M.bodytemperature = max(310, M.bodytemperature-5)
				M.make_jittery(5)
				if(!data) data = 1
				data++
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
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
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M:drowsyness = max(0,M:drowsyness-6)
				M.bodytemperature = max(310, M.bodytemperature-5) //310 is the normal bodytemp. 310.055
				..()
				return

		space_up
			name = "Space-Up"
			id = "space_up"
			description = "Tastes like a hull breach in your mouth."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M.bodytemperature = max(310, M.bodytemperature-8) //310 is the normal bodytemp. 310.055
				..()
				return

		beer
			name = "Beer"
			id = "beer"
			description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 3
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 2
				..()
				return

		whiskey
			name = "Whiskey"
			id = "whiskey"
			description = "A superb and well-aged single-malt whiskey. Damn."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(5)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		specialwhiskey
			name = "Special Blend Whiskey"
			id = "specialwhiskey"
			description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(7)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return


		gin
			name = "Gin"
			id = "gin"
			description = "It's gin. In space. I say, good sir."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-1,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		rum
			name = "Rum"
			id = "rum"
			description = "Yohoho and all that."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vodka
			name = "Vodka"
			id = "vodka"
			description = "Number one drink AND fueling choice for Russians worldwide."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(5)
				M:jitteriness = max(M:jitteriness-6,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		tequilla
			name = "Tequila"
			id = "tequilla"
			description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-4,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vermouth
			name = "Vermouth"
			id = "vermouth"
			description = "You suddenly feel a craving for a martini..."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-4,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		wine
			name = "Wine"
			id = "wine"
			description = "An premium alchoholic beverage made from distilled grape juice."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(2)
				if(data >= 65 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 145 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		tonic
			name = "Tonic Water"
			id = "tonic"
			description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				M.bodytemperature = min(310, M.bodytemperature-5)
				..()
				return

		orangejuice
			name = "Orange juice"
			id = "orangejuice"
			description = "Both delicious AND rich in Vitamin C, what more do you need?"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(30)) M:oxyloss--
				if(M:bruteloss && prob(30)) M:heal_organ_damage(1,0)
				if(M:fireloss && prob(30)) M:heal_organ_damage(0,1)
				if(M:toxloss && prob(30)) M:toxloss--
				..()
				return

		tomatojuice
			name = "Tomato Juice"
			id = "tomatojuice"
			description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(20)) M:oxyloss--
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				if(M:fireloss && prob(20)) M:heal_organ_damage(0,1)
				if(M:toxloss && prob(20)) M:toxloss--
				..()
				return

		limejuice
			name = "Lime Juice"
			id = "limejuice"
			description = "The sweet-sour juice of limes."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(20)) M:oxyloss--
				if(M:bruteloss && prob(20)) M:heal_organ_damage(1,0)
				if(M:fireloss && prob(20)) M:heal_organ_damage(0,1)
				if(M:toxloss && prob(20)) M:toxloss--
				..()
				return


		kahlua
			name = "Kahlua"
			id = "kahlua"
			description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0//Copy-paste from Coffee, derp
				M.make_jittery(5)
				..()
				return


		cognac
			name = "Cognac"
			id = "cognac"
			description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		cream
			name = "Cream"
			id = "cream"
			description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
			reagent_state = LIQUID

		hooch
			name = "Hooch"
			id = "hooch"
			description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(6)
				M:jitteriness = max(M:jitteriness-10,0)
				if(data >= 35 && data <90)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 5
				else if(data >= 90 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		ale
			name = "Ale"
			id = "ale"
			description = "A dark alchoholic beverage made by malted barley and yeast."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		sodawater
			name = "Soda Water"
			id = "sodawater"
			description = "A can of club soda. Why not make a scotch and soda?"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M.dizziness = max(0,M.dizziness-5)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				M.bodytemperature = min(310, M.bodytemperature-5)
				..()
				return

		ice
			name = "Ice"
			id = "ice"
			description = "Frozen water, your dentist wouldn't like you chewing this."
			reagent_state = SOLID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				..()
				return

/////////////////////////////////////////////////////////////////cocktail entities//////////////////////////////////////////////


		gintonic
			name = "Gin and Tonic"
			id = "gintonic"
			description = "An all time classic, mild cocktail."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <135)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		cuba_libre
			name = "Cuba Libre"
			id = "cubalibre"
			description = "Rum, mixed with cola. Viva la revolution."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <135)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		whiskey_cola
			name = "Whiskey Cola"
			id = "whiskeycola"
			description = "Whiskey, mixed with cola. Surprisingly refreshing."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		martini
			name = "Classic Martini"
			id = "martini"
			description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vodkamartini
			name = "Vodka Martini"
			id = "vodkamartini"
			description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 135 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		white_russian
			name = "White Russian"
			id = "whiterussian"
			description = "That's just, like, your opinion, man..."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-4,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		screwdrivercocktail
			name = "Screwdriver"
			id = "screwdrivercocktail"
			description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		bloody_mary
			name = "Bloody Mary"
			id = "bloodymary"
			description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		gargle_blaster
			name = "Pan-Galactic Gargle Blaster"
			id = "gargleblaster"
			description = "Whoah, this stuff looks volatile!"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(6)
				M:jitteriness = max(M:jitteriness-9,0)
				if(data >= 15 && data <45)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 45 && prob(50) && data <55)
					M.confused = max(M:confused+3,0)
				else if(data >=55)
					M.druggy = max(M.druggy, 55)
				..()
				return

		brave_bull
			name = "Brave Bull"
			id = "bravebull"
			description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <145)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 145 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		tequilla_sunrise
			name = "Tequilla Sunrise"
			id = "tequillasunrise"
			description = "Tequilla and orange juice. Much like a Screwdriver, only Mexican~"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		toxins_special
			name = "Toxins Special"
			id = "toxinsspecial"
			description = "This thing is FLAMING!. CALL THE DAMN SHUTTLE!"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				M.bodytemperature = min(330, M.bodytemperature+15) //310 is the normal bodytemp. 310.055
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		beepsky_smash
			name = "Beepsky Smash"
			id = "beepskysmash"
			description = "Deny drinking this and prepare for THE LAW."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				spawn(5)
				M.stunned = 2
				if(!data) data = 1
				data += 3
				M.make_dizzy(6)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		doctor_delight
			name = "The Doctor's Delight"
			id = "doctorsdelight"
			description = "A gulp a day keeps the MediBot away. That's probably for the best."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(50)) M:oxyloss -= 2
				if(M:bruteloss && prob(60)) M:heal_organ_damage(2,0)
				if(M:fireloss && prob(50)) M:heal_organ_damage(0,2)
				if(M:toxloss && prob(50)) M:toxloss -= 2
				if(M.dizziness !=0) M.dizziness = max(0,M.dizziness-15)
				if(M.confused !=0) M.confused = max(0,M.confused - 5)
				..()
				return

		irish_cream
			name = "Irish Cream"
			id = "irishcream"
			description = "Whiskey-imbued cream, what else would you expect from the Irish."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <145)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 145 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		manly_dorf
			name = "The Manly Dorf"
			id = "manlydorf"
			description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(5)
				M:jitteriness = max(M:jitteriness-4,0)
				if(data >= 35 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		longislandicedtea
			name = "Long Island Iced Tea"
			id = "longislandicedtea"
			description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(1)
				M:jitteriness = max(M:jitteriness-1,0)
				if(data >= 55 && data <165)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 165 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		moonshine
			name = "Moonshine"
			id = "moonshine"
			description = "You've really hit rock bottom now... your liver packed its bags and left last night."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(5)
				M:jitteriness = max(M:jitteriness-4,0)
				if(data >= 30 && data <60)
					if (!M.stuttering) M:stuttering = 1
					M.stuttering += 4
				else if(data >= 60 && prob(40))
					M.confused = max(M:confused+5,0)
				..()
				return

		b52
			name = "B-52"
			id = "b52"
			description = "Coffee, Irish Cream, and congac. You will get bombed."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(6)
				M:jitteriness = max(M:jitteriness-5,0)
				if(data >= 25 && data <90)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 90 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		irishcoffee
			name = "Irish Coffee"
			id = "irishcoffee"
			description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(3)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <150)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 150 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		margarita
			name = "Margarita"
			id = "margarita"
			description = "On the rocks with salt on the rim. Arriba~!"
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(2)
				M:jitteriness = max(M:jitteriness-2,0)
				if(data >= 55 && data <150)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 150 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		black_russian
			name = "Black Russian"
			id = "blackrussian"
			description = "For the lactose-intolerant. Still as classy as a White Russian."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		manhattan
			name = "Manhattan"
			id = "manhattan"
			description = "The Detective's undercover drink of choice. He never could stomach gin..."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		whiskeysoda
			name = "Whiskey Soda"
			id = "whiskeysoda"
			description = "Ultimate refreshment."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		vodkatonic
			name = "Vodka and Tonic"
			id = "vodkatonic"
			description = "For when a gin and tonic isn't russian enough."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 55 && data <115)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 115 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return

		ginfizz
			name = "Gin Fizz"
			id = "ginfizz"
			description = "Refreshingly lemony, deliciously dry."
			reagent_state = LIQUID
			on_mob_life(var/mob/M)
				if(!data) data = 1
				data += 3
				M.make_dizzy(4)
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 45 && data <125)
					if (!M.stuttering) M.stuttering = 1
					M.stuttering += 3
				else if(data >= 125 && prob(33))
					M.confused = max(M:confused+2,0)
				..()
				return
