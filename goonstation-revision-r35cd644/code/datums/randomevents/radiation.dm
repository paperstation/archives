/proc/create_radwave(var/turf/pulseloc, var/rads_amt, var/sound/pulse_sound)
	particleMaster.SpawnSystem(new /datum/particleSystem/radevent_warning(pulseloc))
	spawn(30)
		for(var/mob/living/carbon/M in view(5,pulseloc))
			M.irradiate(rads_amt)
			animate_flash_color_fill(M,"#00FF00",1,3)
			if (prob(25) && M.bioHolder)
				if (prob(75))
					M.bioHolder.RandomEffect("bad")
				else
					M.bioHolder.RandomEffect("good")
		for (var/turf/T in view(5,pulseloc))
			animate_flash_color_fill(T,"#00FF00",1,5)
		playsound(pulseloc, pulse_sound, 100, 1, 3, 0.8)
		particleMaster.SpawnSystem(new /datum/particleSystem/radevent_pulse(pulseloc))

/datum/random_event/major/radiation
	name = "Radiation Storm"
	centcom_headline = "Radiation Storm"
	centcom_message = "A radioactive storm is approaching the station. Personnel should evacuate any areas affected by suspicious phenomenae."
	customization_available = 1
	var/sound/pulse_sound = 'sound/weapons/ACgun2.ogg'

	event_effect(var/source,var/pulse_amt,var/pulse_delay,var/rads_amt)
		..()
		var/turf/pulseloc = null

		if (!isnum(pulse_amt))
			pulse_amt = rand(50,100)
		if (!isnum(pulse_delay))
			pulse_delay = rand(1,15)
		if (!isnum(rads_amt))
			rads_amt = rand(30,60)

		for (var/pulses = pulse_amt, pulses > 0, pulses--)
			pulseloc = pick(wormholeturfs)
			create_radwave(pulseloc, rads_amt, pulse_sound)
			sleep(pulse_delay)

	admin_call(var/source)
		if (..())
			return

		var/amtinput = input(usr,"How many pulses? (<1 to cancel)","Radiation Storm") as num
		if (amtinput < 1)
			return
		var/delinput = input(usr,"Delay between pulses? (10 = 1 second, negative number to cancel)","Radiation Storm") as num
		if (delinput < 0)
			return
		var/radinput = input(usr,"How much radiation for getting caught in a pulse? (negative number to cancel)","Radiation Storm") as num
		if (radinput < 0)
			return

		src.event_effect(source,amtinput,delinput,radinput)
		return

/datum/random_event/special/mutation
	name = "Radiation Wave"
	centcom_headline = "Radiation Wave"
	centcom_message = "A large wave of radiation is approaching the station. Personnel should use caution when traversing the station and seek medical attention if they experience any side effects from the wave."

	event_effect(var/source)
		..()
		spawn(rand(100, 300))
		for (var/mob/living/carbon/human/H in mobs)
			if (H.stat == 2)
				continue
			if (prob(10))
				H.bioHolder.RandomEffect("good")
			else
				H.bioHolder.RandomEffect("bad")
			H << sound('sound/ambience/lavamoon_interior_fx5.ogg')
