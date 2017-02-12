#define SOLID 1
#define LIQUID 2
#define GAS 3

//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

var/list/booster_enzyme_reagents_to_check = list("charcoal","synaptizine","stypic_powder","teporone","salbutamol","methamphetamine","omnizine","perfluorodecalin","ryetalin","hydronalin","penteticacid","oculine","epinephrine","mannitol","synthflesh")

datum
	reagent
		var/name = "Reagent"
		var/id = "reagent"
		var/description = ""
		var/datum/reagents/holder = null
		var/list/pathogen_nutrition = null
		var/reagent_state = SOLID
		var/data = null
		var/volume = 0
		///Fluids now have colors
		var/transparency = 150
		var/fluid_r = 0
		var/fluid_b = 0
		var/fluid_g = 255
		var/addiction_prob = 0
		var/dispersal = 4 // The range at which this disperses from a grenade. Should be lower for heavier particles (and powerful stuff).
		var/volatility = 0 // Volatility determines effectiveness in pipebomb. This is 0 for a bad additive, otherwise a positive number whose square is added to explosion power.
		var/reacting = 0 // fuck off chemist spam
		var/overdose = 0 // if reagents are at or above this in a mob, it's an overdose - if double this, it's a major overdose
		var/depletion_rate = 0.4 // this much goes away per tick
		var/penetrates_skin = 0 //if this reagent can enter the bloodstream through simple touch.
		var/touch_modifier = 1 //If this does penetrate skin, how much should be transferred by default (assuming naked dude)? 1 = transfer full amount, 0.5 = transfer half, etc.
		var/taste = "uninteresting"
		var/value = 1 // how many credits this is worth per unit
		var/thirst_value = 0
		var/hygiene_value = 0
		var/blob_damage = 0 // If this is a poison, it may be useful for poisoning the blob.

		disposing()
			holder = null
			..()

		pooled()
			..()
			transparency = initial(transparency)
			fluid_r = initial(fluid_r)
			fluid_b = initial(fluid_b)
			fluid_g = initial(fluid_g)
			holder = null
			data = null
			volume = 0
			reacting = 0


		proc/on_add()
			return

		proc/on_remove()
			return

		proc/grenade_effects(var/obj/grenade, var/atom/A)
			return

		proc/reaction_temperature(exposed_temperature, exposed_volume) //By default we do nothing.
			return

		proc/reaction_blob(var/obj/blob/B, var/volume)
			if (!blob_damage)
				return
			B.take_damage(blob_damage, volume, "poison")

		proc/reaction_mob(var/mob/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
			var/datum/reagent/self = src					  //of the reagent to the mob on TOUCHING it.
			switch(method)
				if(TOUCH)
					if (penetrates_skin)
						var/modifier = touch_modifier
						for(var/obj/item/clothing/C in M.get_equipped_items())
							modifier -= (1 - C.permeability_coefficient)/4

						if(M.reagents)
							M.reagents.add_reagent(self.id,self.volume*modifier,self.data)

					if (ishuman(M) && hygiene_value)
						var/mob/living/carbon/human/H = M
						if (H.sims)
							if ((hygiene_value > 0 && !(H.wear_suit || H.w_uniform)) || hygiene_value < 0)
								H.sims.affectMotive("hygiene", volume * hygiene_value)

				if(INGEST)
					var/datum/ailment_data/addiction/AD = M.addicted_to_reagent(src)
					var/addProb = addiction_prob
					if(istype(M, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = M
						if(H.traitHolder.hasTrait("strongwilled"))
							addProb = round(addProb / 2)
					if(prob(addProb) && ishuman(M) && !AD)
						// i would set up a proc for this but this is the only place that adds addictions
						boutput(M, "<span style=\"color:red\"><B>You suddenly feel invigorated and guilty...</B></span>")
						AD = new
						AD.associated_reagent = src.name
						AD.last_reagent_dose = world.timeofday
						AD.name = "[src.name] addiction"
						AD.affected_mob = M
						M.ailments += AD
					else if (AD)
						boutput(M, "<span style=\"color:blue\"><B>You feel slightly better, but for how long?</B></span>")
						AD.last_reagent_dose = world.timeofday
						AD.stage = 1
					if (ishuman(M) && thirst_value)
						var/mob/living/carbon/human/H = M
						if (H.sims)
							H.sims.affectMotive("thirst", volume * thirst_value)
			if(M.material)
				M.material.triggerChem(M, src, volume)
			for(var/atom/A in M)
				if(A.material) A.material.triggerChem(A, src, volume)
			src = null
			return

		proc/reaction_obj(var/obj/O, var/volume) //By default we transfer a small part of the reagent to the object
			src = null						//if it can hold reagents. nope!
			if(O.material)
				O.material.triggerChem(O, src, volume)
			//if(O.reagents)
			//	O.reagents.add_reagent(id,volume/3)
			return

		proc/reaction_turf(var/turf/T, var/volume)
			src = null
			if(T.material)
				T.material.triggerChem(T, src, volume)
			return

		proc/on_mob_life(var/mob/M)
			if (!M || !M.reagents)
				return
			if (!holder)
				holder = M.reagents
			var/deplRate = depletion_rate
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.traitHolder.hasTrait("slowmetabolism"))
					deplRate /= 2
			holder.remove_reagent(src.id, deplRate) //By default it slowly disappears.

			if(M && overdose > 0) check_overdose(M)
			//if(M && M.stat == 2 && src.id != "montaguone" && src.id != "montaguone_extra") M.reagents.del_reagent(src.id) // no more puking corpses and such
			return

		proc/on_plant_life(var/obj/machinery/plantpot/P)
			if (!P) return

		proc/check_overdose(var/mob/M)
			if (!M || !M.reagents)
				return
			if (!holder)
				holder = M.reagents
			var/amount = holder.get_reagent_amount(src.id)
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.traitHolder.hasTrait("chemresist"))
					amount *= 0.65
			if (amount >= src.overdose * 2)
				return do_overdose(2, M)
			else if (amount >= src.overdose)
				return do_overdose(1, M)

		proc/do_overdose(var/severity, var/mob/M)
			// if there's ever stuff that all drug overdoses should do, put it here
			// for now all this is used for is to determine which overdose effect will happen
			// and allow the individual effects' scale to be adjusted by severity in one spot
			if (ismob(severity)) return //Wire: Fix for shitty fucking byond mixing up vars
			var/effect = rand(1, 100) - severity
			if (effect <= 8)
				M.take_toxin_damage(severity)
			return effect

		proc/on_transfer(var/datum/reagents/source, var/datum/reagents/target, var/trans_amt)
			// NOTE: When this proc is invoked, the volume of the reagent will equal the total volume of this reagent.
			// Thus:
			// - the amount of this reagent in source before transfer = src.volume
			// - the amount of this reagent in target after transfer = trans_amt
			// - the amount of this reagent in source after transfer = src.volume - trans_amt
			return


		// reagent state helper procs

		proc/is_solid()
			return reagent_state == SOLID

		proc/is_liquid()
			return reagent_state == LIQUID

		proc/is_gas()
			return reagent_state == GAS

		proc/physical_shock(var/force)
			return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////



		/*helldrug
			name = "cthonium"
			id = "chtonium"
			description = "***CLASSIFIED. ULTRAVIOLET-CLASS ANOMALOUS MATERIAL. INFORMATION REGARDING THIS REAGENT IS ABOVE YOUR PAY GRADE. QUARANTINE THE SAMPLE IMMEDIATELY AND REPORT THIS INCIDENT TO YOUR HEAD OF SECURITY***"
			reagent_state = LIQUID
			fluid_r = 250
			fluid_b = 250
			fluid_g = 0
			transparency = 40

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 5)
					if(!locate(/turf/unsimulated/floor/void) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /turf/unsimulated/floor/void(T)

		//	When finished, exposure to or consumption of this drug should basically duplicate the
		//	player. send their active body to a horrible hellvoid. back on the station,
		//	replace them with a crunch-critter transposed mob? or just a Transposed Particle Field,
		//	that might be easier
		*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////