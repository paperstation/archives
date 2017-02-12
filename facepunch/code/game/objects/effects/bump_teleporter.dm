var/list/obj/effect/bump_teleporter/BUMP_TELEPORTERS = list()

/obj/effect/bump_teleporter
	name = "bump-teleporter"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	var/id = null			//id of this bump_teleporter.
	var/id_target = null	//id of bump_teleporter which this moves you to.
	invisibility = 101 		//nope, can't see this
	anchored = 1
	density = 1
	opacity = 0

/obj/effect/bump_teleporter/New()
	..()
	BUMP_TELEPORTERS += src

/obj/effect/bump_teleporter/Del()
	BUMP_TELEPORTERS -= src
	..()

/obj/effect/bump_teleporter/Bumped(atom/user)
	if(!ismob(user))
		//user.loc = src.loc	//Stop at teleporter location
		return

	if(!id_target)
		//user.loc = src.loc	//Stop at teleporter location, there is nowhere to teleport to.
		return

	for(var/obj/effect/bump_teleporter/BT in BUMP_TELEPORTERS)
		if(BT.id == src.id_target)
			usr.loc = BT.loc	//Teleport to location with correct id.
			return

/obj/effect/bump_teleporter/show
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	name = "unstable rift"
	desc = "I guess it goes somewere?"
	invisibility = 0
	var/on = 0
	opacity = 0
	id = "away"
	id_target = "away1"


/obj/effect/bump_teleporter/show/Bumped(atom/user)
	if(!ismob(user))
		return

	if(!id_target)
		return

	for(var/obj/effect/bump_teleporter/BT in BUMP_TELEPORTERS)
		if(on)
			if(BT.id == src.id_target)
				var/mob/living/D = usr
				D.loc = BT.loc	//Teleport to location with correct id.
				playsound(D.loc, 'sound/effects/warp.ogg', 100, 1)
				playsound(loc, 'sound/effects/warp.ogg', 100, 1)
				return

/obj/effect/warpcontroller
	var/number = 5
	var/warpareas = 0
	New()
		while(number >= 1)
			var/turf/space/name = locate(/turf/space/) in world
			var/turf/space/D = pick(name)
			if(D.z != 6)
				if(D.z != 2)
					var/obj/effect/bump_teleporter/show/F = new/obj/effect/bump_teleporter/show
					F.loc = D.loc
					var/V = warpareas++
					F.id = "away[V]"
					F.id_target = "here[V]"
					world << "Rift created at [F.x][F.y][F.z] with [F.id] and [F.id_target]"
					number--
					return 1
		if(number <= 0)
			world << "Spawned areas"


/obj/effect/bump_teleporter/temp//Doesn't always exist
	New()
		..()
		if(prob(50))
			del(src)
		else
			BUMP_TELEPORTERS += src



/obj/effect/bump_teleporter/ship
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tele1"
	name = "entry"
	desc = "I guess it goes somewere?"
	invisibility = 0
	var/on = 1


/obj/effect/bump_teleporter/ship/Bumped(atom/user)//We always want them to be able to leave
	if(on)
		for(var/mob/living/simple_animal/starship/BT in world)
			usr.loc = BT.loc	//Teleport to location with correct id.
			return


/obj/effect/bump_teleporter/VR
	name = "Arena Entry"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tele1"