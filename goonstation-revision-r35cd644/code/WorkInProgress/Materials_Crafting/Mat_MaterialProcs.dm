/*
triggerOnAttacked(var/obj/item/owner, var/mob/attacker, var/mob/attacked, var/atom/weapon)
triggerOnAttack(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
triggerOnLife(var/mob/M, var/obj/item/I)
triggerOnAdd(var/owner)
triggerChem(var/location, var/chem, var/amount)
triggerPickup(var/mob/M)
triggerDrop(var/mob/M)
triggerTemp(var/owner, var/temp)
triggerExp(var/owner, var/severity)/
triggerOnEntered(var/atom/owner, var/atom/entering)
*/


//!!!!!!!!!!!!!!!!!!!! THINGS LIKE GOLD SPARKLES ARE NOT REMOVED WHEN MATERIAL CHANGES!. MOVE THESE TO NEW APPEARANCE SYSTEM.

/datum/materialProc
	var/id = null
	var/max_generations = 2 //After how many material "generations" this trait disappears. -1 = does not disappear.
	var/desc = "" //Optional simple sentence that describes how the traits appears on the material. i.e. "It is shiny."

	proc/execute()
		return

/datum/materialProc/ethereal_add
	id = "ethereal_add"
	desc = "It is almost impossible to grasp."

	execute(var/atom/owner)
		owner.density = 0
		return

/datum/materialProc/wendigo_temp_onlife
	id = "wendigo_temp"
	desc = "It feels furry."

	execute(var/mob/M, var/obj/item/I)
		if(M)
			M.bodytemperature = 310
		return

/datum/materialProc/fail_explosive
	id = "fail_explosive"
	var/lastTrigger = 0
	var/trigger_chance = 100

	New(var/chance = 100)
		trigger_chance = chance
		..()

	execute(var/atom/location)
		if(world.time - lastTrigger < 100) return
		lastTrigger = world.time
		var/turf/tloc = get_turf(location)
		explosion(location, location, tloc, 1, 2, 3, 4, 1)
		location.visible_message("<span style=\"color:red\">[location] explodes!</span>")
		return

/datum/materialProc/generic_radiation_onenter
	id = "generic_radiation_onenter"
	desc = "It glows faintly."

	execute(var/atom/owner, var/atom/entering)
		if(ismob(entering))
			var/mob/M = entering
			M.irradiate(1)
		return

/datum/materialProc/generic_reagent_onattacked
	id = "generic_reagent_onattacked"
	var/trigger_chance = 100
	var/limit = 0
	var/limit_count = 0
	var/lastTrigger = 0
	var/trigger_delay = 0
	var/reagent_id = ""
	var/reagent_amount = 0

	New(var/reagid = "carbon", var/amt = 2, var/chance = 100, var/limit_t = 0, var/tdelay = 50)
		trigger_chance = chance
		limit = limit_t
		trigger_delay = tdelay
		reagent_id = reagid
		reagent_amount = amt
		..()

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked, var/atom/weapon)
		if(limit && limit_count >= limit) return
		if(world.time - lastTrigger < trigger_delay) return
		lastTrigger = world.time
		if(prob(trigger_chance))
			if(attacked.reagents)
				attacked.reagents.add_reagent(reagent_id, reagent_amount, null, T0C)
		return

/datum/materialProc/generic_explode_attack
	id = "generic_explode_attack"
	var/trigger_chance = 100
	var/explode_limit = 0
	var/explode_count = 0
	var/lastTrigger = 0

	desc = "It looks dangerously unstable."

	New(var/chance = 100, var/limit = 0)
		trigger_chance = chance
		explode_limit = limit
		..()

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
		if(explode_limit && explode_count >= explode_limit) return
		if(world.time - lastTrigger < 50) return
		lastTrigger = world.time
		if(prob(trigger_chance))
			explode_count++
			var/turf/tloc = get_turf(attacked)
			explosion(owner, tloc, 0, 1, 2, 3, 1)
			tloc.visible_message("<span style=\"color:red\">[owner] explodes!</span>")
			qdel(owner)
		return

/datum/materialProc/generic_fireflash
	id = "generic_fireflash"
	var/lastTrigger = 0

	execute(var/atom/location, var/temp)
		if(temp < T0C + 200)
			return
		if(world.time - lastTrigger < 1200) return
		lastTrigger = world.time
		fireflash(get_turf(location), 1)
		return

/datum/materialProc/generic_itchy_onlife
	id = "generic_itchy_onlife"
	desc = "It makes your hands itch."

	execute(var/mob/M, var/obj/item/I)
		if(prob(20)) M.emote(pick("twitch", "laugh", "sneeze", "cry"))
		if(prob(10))
			boutput(M, "<span style=\"color:blue\"><b>Something tickles!</b></span>")
			M.emote(pick("laugh", "giggle"))
		if(prob(8))
			M.visible_message("<span style=\"color:red\"><b>[M.name]</b> scratches at an itch.</span>")
			random_brute_damage(M, 1)
			M.stunned += rand(0,1)
			M.emote("grumble")
		if(prob(8))
			boutput(M, "<span style=\"color:red\"><b>So itchy!</b></span>")
			random_brute_damage(M, 2)
		if(prob(1))
			boutput(M, "<span style=\"color:red\"><b><font size='[rand(2,5)]'>AHHHHHH!</font></b></span>")
			random_brute_damage(M,5)
			M.weakened +=5
			M.make_jittery(6)
			M.visible_message("<span style=\"color:red\"><b>[M.name]</b> falls to the floor, scratching themselves violently!</span>")
			M.emote("scream")
		return

/datum/materialProc/generic_reagent_onattack_depleting
	id = "generic_reagent_onattack_depleting"
	var/reag_id = "carbon"
	var/reag_amt = 1
	var/reag_chance = 10
	var/charges_left = 10

	New(var/reagent_id = "carbon", var/amount = 1, var/chance = 10, var/charges = 10)
		reag_id = reagent_id
		reag_amt = amount
		reag_chance = chance
		charges_left = charges
		..()

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
		if(prob(reag_chance) && attacked && attacked.reagents)
			charges_left--
			attacked.reagents.add_reagent(reag_id, reag_amt, null, T0C)
			if(!charges_left)
				if(owner.material)
					owner.material.triggersOnAttack.Remove(src)
		return

/datum/materialProc/generic_reagent_onattack
	id = "generic_reagent_onattack"
	var/reag_id = "carbon"
	var/reag_amt = 1
	var/reag_chance = 10

	New(var/reagent_id = "carbon", var/amount = 1, var/chance = 10)
		reag_id = reagent_id
		reag_amt = amount
		reag_chance = chance
		..()

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
		if(prob(reag_chance) && attacked && attacked.reagents)
			attacked.reagents.add_reagent(reag_id, reag_amt, null, T0C)
		return

/datum/materialProc/generic_reagent_onlife
	id = "generic_reagent_onlife"
	var/reag_id = "carbon"
	var/reag_amt = 1

	New(var/reagent_id = "carbon", var/amount = 1)
		reag_id = reagent_id
		reag_amt = amount
		..()

	execute(var/mob/M, var/obj/item/I)
		if(M && M.reagents)
			M.reagents.add_reagent(reag_id, reag_amt, null, T0C)
		return

/datum/materialProc/generic_reagent_onlife_depleting
	id = "generic_reagent_onlife_depleting"
	var/reag_id = "carbon"
	var/reag_amt = 1
	var/max_volume = 0
	var/added = 0

	New(var/reagent_id = "carbon", var/amount = 1, var/maxadd = 50)
		reag_id = reagent_id
		reag_amt = amount
		max_volume = maxadd
		..()

	execute(var/mob/M, var/obj/item/I)
		if(M && M.reagents)
			M.reagents.add_reagent(reag_id, reag_amt, null, T0C)
			added += reag_amt
			if(added >= max_volume)
				if(I.material)
					I.material.triggersOnLife.Remove(src)
		return

/datum/materialProc/generic_explosive
	id = "generic_explosive"
	var/lastTrigger = 0

	execute(var/atom/location, var/temp)
		if(temp < T0C + 100)
			return
		if(world.time - lastTrigger < 100) return
		lastTrigger = world.time
		var/turf/tloc = get_turf(location)
		explosion(location, tloc, 1, 2, 3, 4, 1)
		location.visible_message("<span style=\"color:red\">[location] explodes!</span>")
		return

/datum/materialProc/flash_hit
	id = "flash_hit"
	var/last_trigger = 0
	desc = "Every now and then it produces some bright sparks."

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked, var/atom/weapon)
		if((world.time - last_trigger) >= 600)
			last_trigger = world.time
			attacked.visible_message("<span style=\"color:red\">[owner] emits a flash of light!</span>")
			for (var/mob/living/carbon/M in all_viewers(5, attacked))
				M.apply_flash(8, 0, 0, 0, 3)
		return

/datum/materialProc/smoke_hit
	id = "smoke_hit"
	desc = "Faint wisps of smoke rise from it."
	var/last_trigger = 0

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked, var/atom/weapon)
		if((world.time - last_trigger) >= 200)
			last_trigger = world.time
			attacked.visible_message("<span style=\"color:red\">[owner] emits a puff of smoke!</span>")
			for(var/turf/T in view(1, attacked))
				harmless_smoke_puff(get_turf(T))
		return

/datum/materialProc/gold_add
	id = "gold_add"
	desc = "It's very shiny."

	execute(var/location)
		if(!particleMaster.CheckSystemExists(/datum/particleSystem/sparkles, location))
			particleMaster.SpawnSystem(new /datum/particleSystem/sparkles(location))
		return

/datum/materialProc/telecrystal_entered
	id = "telecrystal_entered"

	execute(var/atom/owner, var/atom/movable/entering)
		if(prob(50) && owner && !isrestrictedz(owner.z))
			. = get_turf(pick(orange(2, owner)))
			if (isturf(.))
				entering.visible_message("<span style=\"color:red\">[entering] is warped away!</span>")
				boutput(entering, "<span style=\"color:red\">You suddenly teleport ...</span>")
				entering.set_loc(.)
		return

/datum/materialProc/telecrystal_life
	id = "telecrystal_life"

	execute(var/mob/M, var/obj/item/I)
		if(prob(5) && M && !isrestrictedz(M.z))
			. = get_turf(pick(orange(8, M)))
			if (isturf(.))
				M.visible_message("<span style=\"color:red\">[M] is warped away!</span>")
				boutput(M, "<span style=\"color:red\">You suddenly teleport ...</span>")
				M.set_loc(.)
		return

/datum/materialProc/plasmastone
	id = "plasmastone"

	execute(var/location) //exp and temp both have the location as first argument so i can use this for both.
		for (var/turf/simulated/floor/target in range(1,location))
			if(!target.blocks_air && target.air)
				if(target.parent)
					target.parent.suspend_group_processing()

				var/datum/gas_mixture/payload = unpool(/datum/gas_mixture)
				payload.toxins = 100
				target.air.merge(payload)
		return

/datum/materialProc/miracle_add
	id = "miracle_add"

	execute(var/location)
		animate_rainbow_glow(location)
		return

/datum/materialProc/cerenkite_add
	id = "cerenkite_add"

	execute(var/location)
		animate_flash_color_fill_inherit(location,"#1122EE",-1,40)
		return

/datum/materialProc/cerenkite_life
	id = "cerenkite_life"

	execute(var/mob/M, var/obj/item/I)
		M.irradiate(1)
		return

/datum/materialProc/cerenkite_pickup
	id = "cerenkite_pickup"

	execute(var/mob/M)
		M.irradiate(10)
		return

/datum/materialProc/erebite_flash
	id = "erebite_flash"

	execute(var/location)
		animate_flash_color_fill_inherit(location,"#FF7711",-1,10)
		return

/datum/materialProc/erebite_temp
	id = "erebite_temp"
	var/lastTrigger = 0

	execute(var/atom/location, var/temp)
		if(temp < T0C + 10) return
		if(world.time - lastTrigger < 100) return
		lastTrigger = world.time
		var/turf/tloc = get_turf(location)
		explosion(location, tloc, 0, 1, 2, 3, 1)
		location.visible_message("<span style=\"color:red\">[location] explodes!</span>")
		return

/datum/materialProc/erebite_exp
	id = "erebite_exp"
	var/lastTrigger = 0

	execute(var/atom/location, var/sev)
		if(world.time - lastTrigger < 100) return
		lastTrigger = world.time
		var/turf/tloc = get_turf(location)
		if(sev > 0 && sev < 4)
			location.visible_message("<span style=\"color:red\">[location] explodes!</span>")
			switch(sev)
				if(1)
					explosion(location, tloc, 0, 1, 2, 3, 1)
				if(2)
					explosion(location, tloc, -1, 0, 1, 2, 1)
				if(3)
					explosion(location, tloc, -1, -1, 0, 1, 1)
			qdel(location)
		return

//triggerOnAttack(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
/datum/materialProc/slippery_attack
	id = "slippery_attack"

	execute(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
		if (prob(20))
			boutput(attacker, "<span style=\"color:red\">[owner] slips right out of your hand!</span>")
			owner.loc = attacker.loc
			owner.dropped()
		return

/datum/materialProc/slippery_entered
	id = "slippery_entered"

	execute(var/atom/owner, var/atom/movable/entering)
		if (iscarbon(entering) && prob(75))
			var/mob/living/carbon/C = entering
			boutput(C, "You slip on the icy floor!")
			playsound(get_turf(owner), "sound/misc/slip.ogg", 30, 1)
			C.weakened += 2
		return

/datum/materialProc/ice_life
	id = "ice_life"
	desc = "It is slowly melting."

	execute(var/mob/M, var/obj/item/I)
		if (istype(M,/mob/living/carbon/))
			var/mob/living/carbon/C = M
			if (C.bodytemperature > 0)
				C.bodytemperature -= 2
			if (C.bodytemperature > 100 && prob(4))
				boutput(C, "Your [I] melts from your body heat!")
				qdel(I)
		return