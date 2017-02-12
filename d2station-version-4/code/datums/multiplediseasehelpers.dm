





datum
	reagents
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
						M.contract_disease(virus)

					else //injected
						M.contract_disease(virus, 1, 0)
						M.blood = M.blood + volume
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


