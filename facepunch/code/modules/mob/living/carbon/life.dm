/mob/living/carbon/Life()
/*
	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD)
		if(air_master.current_cycle%4==2 || failed_last_breath) 	//First, resolve location and get a breath
			breathe() 				//Only try to take a breath every 4 ticks, unless suffocating



*/
/mob/living/carbon/proc/breathe()
	if(reagents)
		if(reagents.has_reagent("lexorin")) return
	if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return

	var/datum/air_group/breath = null
	if(health < 0)//Dying means you cant breath it seems
		losebreath++

	if(losebreath>0)//Suffocating so do not take a breath
		losebreath--
		if(prob(10))//Gasp every couple of ticks
			spawn emote("gasp")
		handle_breath(breath)//Process the null breath
		return

	//First, check to see if we can breath due to internals
	breath = get_breath_from_internal(BREATH_VOLUME)
	//No internals means we check the air
	if(!breath)
		breath = loc.remove_air(BREATH_VOLUME)
		// Handle chem smoke effect
		if(istype(loc, /turf))
			handle_smoke()
	handle_breath(breath)
	//if(breath)//This is where you breath out and return gas to the air, we dont really need it to be that complex
	//	loc.assume_air(breath)
	return

//This proc is called by breath() and will check the area for chemsmoke
/mob/living/carbon/proc/handle_smoke()
	for(var/obj/effect/effect/chem_smoke/smoke in view(1, src))
		if(smoke.reagents.total_volume)
			smoke.reagents.reaction(src, INGEST)
			spawn(5)
				if(smoke)
					smoke.reagents.copy_to(src, 10) // I dunno, maybe the reagents enter the blood stream through the lungs?
			break // If they breathe in the nasty stuff once, no need to continue checking
	return 1

/mob/living/carbon/proc/handle_breath(datum/gas_mixture/breath)
	return

/mob/living/carbon/proc/get_breath_from_internal(volume_needed)
	return null