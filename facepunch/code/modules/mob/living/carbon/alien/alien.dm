#define HEAT_DAMAGE_LEVEL_1 4 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 8 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 16 //Amount of damage applied when your body temperature passes the 1000K point

/mob/living/carbon/alien
	name = "alien"
	voice_name = "alien"
	voice_message = "hisses"
	say_message = "hisses"
	icon = 'icons/mob/alien.dmi'
	gender = NEUTER
	dna = null

	var/heal_rate_reduced = 0

	var/storedPlasma = 250
	var/max_plasma = 500

	alien_talk_understand = 1

	var/obj/item/weapon/card/id/wear_id = null // Fix for station bounced radios -- Skie
	var/has_fine_manipulation = 0

	var/move_delay_add = 0 // movement delay to add

	status_flags = CANPARALYSE|CANPUSH
	var/heal_rate = 10
	var/plasma_rate = 5//How fast plasma is built up

	var/oxygen_alert = 0
	var/toxins_alert = 0
	var/fire_alert = 0
	var/temperature_alert = 0
	var/temperature_resistance = T0C+75

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		..()
		regenerate_icons()
		return

/mob/living/carbon/alien/proc/adjustPlasma(amount)
	storedPlasma = min(max(storedPlasma + amount,0),max_plasma) //upper limit of max_plasma, lower limit of 0
	return

/mob/living/carbon/alien/proc/getPlasma()
	return storedPlasma

/mob/living/carbon/alien/eyecheck()
	return 2

/mob/living/carbon/alien/update_health()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	//toxloss isn't used for aliens, its actually used as alien powers!!
	health = maxHealth - oxy_damage - get_fire_loss() - get_brute_loss() - clone_damage
	if(!stat && heal_rate_reduced)
		heal_rate_reduced = 0//No longer in crit, reset this


/mob/living/carbon/alien/proc/handle_environment(var/datum/gas_mixture/environment)
	//If there are alien weeds on the ground then heal if needed or give some toxins
	if((locate(/obj/effect/alien/weeds) in loc))
		adjustPlasma(plasma_rate)
		if(stat || resting)
			if(oxy_damage >= heal_rate)//So we dont keep healing 1-2 oxyloss when in crit and never heal anything else
				deal_damage(-heal_rate, OXY)
			else if(get_brute_loss())
				deal_damage(-heal_rate, BRUTE)
			else if(get_fire_loss())
				deal_damage(-heal_rate, BURN)
			if(health < 0 && !heal_rate_reduced)//Knocked into crit
				heal_rate_reduced = 1
				heal_rate = max(0, heal_rate - 5)//Reduce healing by 5 each time knocked into crit


	if(!environment)
		return
	var/loc_temp = T0C
	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		loc_temp =  M.return_temperature()
	else if(istype(get_turf(src), /turf/space))
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.temperature
	else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		loc_temp = loc:air_contents.temperature
	else
		loc_temp = environment.temperature

	//world << "Loc temp: [loc_temp] - Body temp: [bodytemperature] - Fireloss: [getFireLoss()] - Fire protection: [heat_protection] - Location: [loc] - src: [src]"

	// Aliens are now weak to fire.

	//After then, it reacts to the surrounding atmosphere based on your thermal protection
	if(loc_temp > bodytemperature)
		//Place is hotter than we are
		var/thermal_protection = 0.5 //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < 1)
			bodytemperature += (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_DIVISOR)
	else
		bodytemperature += 1 * ((loc_temp - bodytemperature) / BODYTEMP_DIVISOR)
	//	bodytemperature -= max((loc_temp - bodytemperature / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature > 360.15)
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 1)
		switch(bodytemperature)
			if(360 to 400)
				deal_damage(HEAT_DAMAGE_LEVEL_1, BURN)
				fire_alert = max(fire_alert, 2)
			if(400 to 1000)
				deal_damage(HEAT_DAMAGE_LEVEL_2, BURN)
				fire_alert = max(fire_alert, 2)
			if(1000 to INFINITY)
				deal_damage(HEAT_DAMAGE_LEVEL_3, BURN)
				fire_alert = max(fire_alert, 2)
	return


/mob/living/carbon/alien/proc/handle_mutations_and_radiation()
	return


/mob/living/carbon/alien/IsAdvancedToolUser()
	return has_fine_manipulation


/mob/living/carbon/alien/Process_Spaceslipping()
	return 0 // Don't slip in space.


/mob/living/carbon/alien/Stat()
	statpanel("Status")
	stat(null, "Intent: [a_intent]")
	stat(null, "Move Mode: [m_intent]")

	..()

	if (client.statpanel == "Status")
		stat(null, "Plasma Stored: [getPlasma()]/[max_plasma]")

	if(emergency_shuttle)
		if(emergency_shuttle.online && emergency_shuttle.location < 2)
			var/timeleft = emergency_shuttle.timeleft()
			if (timeleft)
				stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")


/mob/living/carbon/alien/getDNA()
	return null


/mob/living/carbon/alien/setDNA()
	return

/*----------------------------------------
Proc: AddInfectionImages()
Des: Gives the client of the alien an image on each infected mob.
----------------------------------------*/
/mob/living/carbon/alien/proc/AddInfectionImages()
	if (client)
		for (var/mob/living/C in mob_list)
			if(C.status_flags & XENO_HOST)
				var/obj/item/alien_embryo/A = locate() in C
				var/I = image('icons/mob/alien.dmi', loc = C, icon_state = "infected[A.stage]")
				client.images += I
	return


/*----------------------------------------
Proc: RemoveInfectionImages()
Des: Removes all infected images from the alien.
----------------------------------------*/
/mob/living/carbon/alien/proc/RemoveInfectionImages()
	if (client)
		for(var/image/I in client.images)
			if(dd_hasprefix_case(I.icon_state, "infected"))
				del(I)
	return

#undef HEAT_DAMAGE_LEVEL_1
#undef HEAT_DAMAGE_LEVEL_2
#undef HEAT_DAMAGE_LEVEL_3
