// returns 0 to 1
/proc/attenuate_for_location(var/atom/loc)
	var/attenuate = 1
	var/turf/T = get_turf(loc)
	if (istype(T, /turf/space))
		return 0 // in space nobody can hear you fart
	var/turf/simulated/sim_T = T
	if (istype(sim_T) && sim_T.air)
		attenuate *= sim_T.air.return_pressure() / ONE_ATMOSPHERE
		attenuate = min(1, max(0, attenuate))

	return attenuate

/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch)
	if (!limiter || !limiter.canISpawn(/sound))
		return
	var/area/source_location = get_area(source)
	vol *= attenuate_for_location(source)
	var/source_location_root = null
	if(source_location)
		source_location_root = get_top_ancestor(source_location, /area)

	var/sound/S = generate_sound(source, soundin, vol, vary, extrarange, pitch)
	if(S && source)
		var/mob/M
		for (M in mobs)
			var/turf/Mloc = get_turf(M)
			if(!isnull(Mloc) && M.client && source && Mloc.z == source.z)
				var/area/listener_location = get_area(Mloc)
				if(listener_location)
					var/listener_location_root = get_top_ancestor(listener_location, /area)
					if(listener_location_root != source_location_root && !(listener_location != /area && source_location != /area))
						//boutput(M, "You did not hear a [source] at [source_location]!")
						continue

					if(source_location && source_location.sound_group && source_location.sound_group != listener_location.sound_group)
						//boutput(M, "You did not hear a [source] at [source_location] due to the sound_group ([source_location.sound_group]) not matching yours ([listener_location.sound_group])")
						continue

					if(listener_location != source_location)
						//boutput(M, "You barely hear a [source] at [source_location]!")
						S.echo = list(0,0,0,0,0,0,-10000,1.0,1.5,1.0,0,1.0,0,0,0,0,1.0,7) //Sound is occluded
					else
						//boutput(M, "You hear a [source] at [source_location]!")
						S.echo = list(0,0,0,0,0,0,0,0.25,1.5,1.0,0,1.0,0,0,0,0,1.0,7)
				//if(get_dist(M, source) >= 30) return // hard attentuation i guess
				S.x = source.x - Mloc.x
				S.z = source.y - Mloc.y //Since sound coordinates are 3D, z for sound falls on y for the map.  BYOND.
				S.y = 0
				S.volume *= attenuate_for_location(Mloc)
				M << S
				S.volume = vol

		//pool(S)

/mob/proc/playsound_local(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch = 1)
	if(!src.client)
		return

	if (narrator_mode && soundin in list("punch", "swing_hit", "shatter", "explosion"))
		switch(soundin)
			if ("shatter") soundin = 'sound/vox/break.ogg'
			if ("explosion") soundin = list('sound/vox/explosion.ogg', 'sound/vox/explode.ogg')
			if ("swing_hit") soundin = 'sound/vox/hit.ogg'
			if ("punch") soundin = 'sound/vox/hit.ogg'
	else
		switch(soundin)
			if ("shatter") soundin = pick(sounds_shatter)
			if ("explosion") soundin = pick(sounds_explosion)
			if ("sparks") soundin = pick(sounds_sparks)
			if ("rustle") soundin = pick(sounds_rustle)
			if ("punch") soundin = pick(sounds_punch)
			if ("clownstep") soundin = pick(sounds_clown)
			if ("swing_hit") soundin = pick(sounds_hit)
			if ("warp") soundin = pick(sounds_warp)
	/*
	if (narrator_mode)
		sounds_punch = list(sound('sound/vox/hit.ogg'))
		sounds_hit = list(sound('sound/vox/hit.ogg'))
		sounds_shatter = list(sound('sound/vox/break.ogg'))
		sounds_explosion = list(sound('sound/vox/explode.ogg'), sound('sound/vox/explosion.ogg'))
	switch(soundin)
		if ("shatter") soundin = pick(sounds_shatter)
		if ("explosion") soundin = pick(sounds_explosion)
		if ("sparks") soundin = pick(sounds_sparks)
		if ("rustle") soundin = pick(sounds_rustle)
		if ("punch") soundin = pick(sounds_punch)
		if ("clownstep") soundin = pick(sounds_clown)
		if ("swing_hit") soundin = pick(sounds_hit)
		if ("warp") soundin = pick(sounds_warp)
	*/

	if(islist(soundin))
		soundin = pick(soundin)

	var/sound/S
	if(istext(soundin))
		S = unpool(/sound)
		S.file = csound(soundin)
		//DEBUG("Created sound [S.file] from csound - soundin is text([soundin])")
	else if (isfile(soundin))
		S = unpool(/sound)
		S.file = soundin// = sound(soundin)
		//DEBUG("Created sound [S.file] from file - soundin is file")
	else if (istype(soundin, /sound))
		S = soundin
		//DEBUG("Used input sound: [S.file]")

	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol * attenuate_for_location(src)
	S.priority = 5

	if (vary)
		S.frequency = rand(725, 1250) / 1000 * pitch
	else
		S.frequency = pitch

	if(isturf(source))
		var/dx = source.x - src.x
		S.pan = max(-100, min(100, dx/8.0 * 100))
	src << S
	//pool(S)


/proc/generate_sound(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch = 1)
	//Frequency stuff only works with 45kbps oggs.
	if (narrator_mode && soundin in list("punch", "swing_hit", "shatter", "explosion"))
		switch(soundin)
			if ("shatter") soundin = 'sound/vox/break.ogg'
			if ("explosion") soundin = list('sound/vox/explosion.ogg', 'sound/vox/explode.ogg')
			if ("swing_hit") soundin = 'sound/vox/hit.ogg'
			if ("punch") soundin = 'sound/vox/hit.ogg'
	else
		switch(soundin)
			if ("shatter") soundin = pick(sounds_shatter)
			if ("explosion") soundin = pick(sounds_explosion)
			if ("sparks") soundin = pick(sounds_sparks)
			if ("rustle") soundin = pick(sounds_rustle)
			if ("punch") soundin = pick(sounds_punch)
			if ("clownstep") soundin = pick(sounds_clown)
			if ("swing_hit") soundin = pick(sounds_hit)
			if ("warp") soundin = pick(sounds_warp)

	if(islist(soundin))
		soundin = pick(soundin)

	var/sound/S
	if(istext(soundin))
		S = unpool(/sound)
		S.file = csound(soundin)
		//DEBUG("Created sound [S.file] from csound - soundin is text([soundin])")
	else if (isfile(soundin))
		S = unpool(/sound)
		S.file = soundin// = sound(soundin)
		//DEBUG("Created sound [S.file] from file - soundin is file")
	else if (istype(soundin, /sound))
		S = soundin
		//DEBUG("Used input sound: [S.file]")

	/*
	var/sound/S
	if(istext(soundin))
		S = unpool(/sound)
		S.file = csound(soundin)
	else
		S = sound(soundin)

	*/
	S.falloff = (world.view + extrarange)/10
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	S.priority = 5
	S.environment = 0

	var/location = null
	if(source) //runtime error fix
		location = source.loc
	if(location != null && isturf(location))
		var/turf/T = location
		location = T.loc
	if(location != null && isarea(location))
		var/area/A = location
		S.environment = A.sound_environment


	if (vary)
		S.frequency = rand(725, 1250) / 1000 * pitch
	else
		S.frequency = pitch

	S.volume *= attenuate_for_location(source)

	return S

/mob/proc/playAmbience(area/A)
	if (!src.client.played)
		var/sound/S = sound(A.sound, repeat = 0, wait = 0, volume = 25, channel = 1)
		S.priority = 2
		S.volume *= attenuate_for_location(A)
		src << S
		src.client:played = 1
		spawn(600)
			if(src && src.client)
				src.client.played = 0

/// pool of precached sounds

/var/global/list/big_explosions = list(sound('sound/effects/Explosion1.ogg'),sound('sound/effects/Explosion2.ogg'),sound('sound/effects/explosion_new1.ogg'),sound('sound/effects/explosion_new2.ogg'),sound('sound/effects/explosion_new3.ogg'),sound('sound/effects/explosion_new4.ogg'))

/var/global/list/sounds_shatter = list(sound('sound/effects/Glassbr1.ogg'),sound('sound/effects/Glassbr2.ogg'),sound('sound/effects/Glassbr3.ogg'))
/var/global/list/sounds_explosion = list(sound('sound/effects/Explosion1.ogg'),sound('sound/effects/Explosion2.ogg'))
/var/global/list/sounds_sparks = list(sound('sound/effects/sparks1.ogg'),sound('sound/effects/sparks2.ogg'),sound('sound/effects/sparks3.ogg'),sound('sound/effects/sparks4.ogg'),sound('sound/effects/sparks5.ogg'),sound('sound/effects/sparks6.ogg'))
/var/global/list/sounds_rustle = list(sound('sound/misc/rustle1.ogg'),sound('sound/misc/rustle2.ogg'),sound('sound/misc/rustle3.ogg'),sound('sound/misc/rustle4.ogg'),sound('sound/misc/rustle5.ogg'))
/var/global/list/sounds_punch = list(sound('sound/weapons/punch1.ogg'),sound('sound/weapons/punch2.ogg'),sound('sound/weapons/punch3.ogg'),sound('sound/weapons/punch4.ogg'))
/var/global/list/sounds_clown = list(sound('sound/misc/clownstep1.ogg'),sound('sound/misc/clownstep2.ogg'))
/var/global/list/sounds_hit = list(sound('sound/weapons/genhit1.ogg'),sound('sound/weapons/genhit2.ogg'),sound('sound/weapons/genhit3.ogg'))
/var/global/list/sounds_warp = list(sound('sound/effects/warp1.ogg'),sound('sound/effects/warp2.ogg'))
/var/global/list/sounds_engine = list(sound('sound/machines/tractor_running2.ogg'),sound('sound/machines/tractor_running3.ogg'))

/var/global/list/sounds_enginegrump = list(sound('sound/machines/engine_grump1.ogg'),sound('sound/machines/engine_grump2.ogg'),sound('sound/machines/engine_grump3.ogg'),sound('sound/machines/engine_grump4.ogg'))

/var/global/list/ambience_general = list(sound('sound/ambience/ambigen1.ogg'),
			sound('sound/ambience/ambigen2.ogg'),
			sound('sound/ambience/ambigen3.ogg'),
			sound('sound/ambience/ambigen4.ogg'),
			sound('sound/ambience/ambigen5.ogg'),
			sound('sound/ambience/ambigen6.ogg'),
			sound('sound/ambience/ambigen7.ogg'),
			sound('sound/ambience/ambigen8.ogg'),
			sound('sound/ambience/ambigen9.ogg'),
			sound('sound/ambience/ambigen10.ogg'),
			sound('sound/ambience/ambigen11.ogg'),
			sound('sound/ambience/ambigen12.ogg'),
			sound('sound/ambience/ambigen14.ogg'))

/var/global/list/ambience_power = list(sound('sound/ambience/ambipower1.ogg'),sound('sound/ambience/ambipower2.ogg'))
/var/global/list/ambience_computer = list(sound('sound/ambience/ambicomp1.ogg'),sound('sound/ambience/ambicomp2.ogg'),sound('sound/ambience/ambicomp3.ogg'))
/var/global/list/ambience_atmospherics = list(sound('sound/ambience/ambiatm1.ogg'))
/var/global/list/ambience_engine = list(sound('sound/ambience/ambiatm1.ogg'))

/var/global/list/ghostly_sounds = list('sound/effects/ghostambi1.ogg', 'sound/effects/ghostambi2.ogg', 'sound/effects/ghostbreath.ogg', 'sound/effects/ghostlaugh.ogg', 'sound/effects/ghostvoice.ogg')

/**
 * Soundcache
 * NEVER use these sounds for modifying.
 * This should only be used for sounds that are played unaltered to the user.
 * @param text name the name of the sound that will be returned
 * @return sound
 */
/proc/csound(var/name)
	return soundCache[name]

sound
	Del()
		// Haha you cant delete me you fuck
		if(!qdeled)
			pool(src)
		else
			//Yes I can
			..()
		return

	unpooled()
		file = initial(file)
		repeat = initial(repeat)
		wait = initial(wait)
		channel = initial(channel)
		volume = initial(volume)
		frequency = initial(frequency)
		pan = initial(pan)
		priority = initial(priority)
		status = initial(status)
		x = initial(x)
		y = initial(y)
		z = initial(z)
		falloff = initial(falloff)
		environment = initial(environment)
		echo = initial(echo)

