
//Landmarks to setup critters
/obj/effect/landmark/miniworld
	name = "MiniWorldSpawn"
	var/mob_type = 0


/obj/effect/landmark/miniworld/w1/melee//The ship
	name = "SyndiSpawnMelee"
	mob_type = 1

/obj/effect/landmark/miniworld/w1/meleespace
	name = "SyndiSpawnMeleeSpace"
	mob_type = 2

/obj/effect/landmark/miniworld/w1/range
	name = "SyndiSpawnRange"
	mob_type = 3

/obj/effect/landmark/miniworld/w1/rangespace
	name = "SyndiSpawnRangeSpace"
	mob_type = 4



//Areas for the diff sats
/area/satellite1
	name = "Satellite #1"
	icon_state = "start"

/area/satellite2
	name = "Satellite #2"
	icon_state = "start"

/area/satellite3
	name = "Satellite #3"
	icon_state = "start"

/area/gatewaymissions/
	var/locationname = null

//Areas for the diff "worlds", todo: have these be build randomly at spawn
/area/gatewaymissions/world1
	name = "Unknown"
	icon_state = "purple"
	requires_power = 0

/area/gatewaymissions/world2//Plays sound in the background
	name = "Unknown"
	icon_state = "purple"
	requires_power = 0
	var/sound/mysound = null//Music code stolen from the beach
/*
	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/TheRideNeverEnds.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		process()


	Entered(atom/movable/Obj,atom/OldLoc)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return


	Exited(atom/movable/Obj)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound
	proc/process()
		set background = 1

		var/sound/S = null
		var/sound_delay = 0

		for(var/mob/living/carbon/human/H in src)
			if(H.client)
				mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S
		if(areamusictoggle)
			return
		spawn(60) .()
*/


var/areamusictoggle = 0
/proc/togglemusic()//this cant be undone
	areamusictoggle = 1//!areamusictoggle
	message_admins("Away mission music has been [areamusictoggle? "disabled":"enabled"], for the round")
	return 0
