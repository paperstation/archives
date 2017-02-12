/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/floor/attack_paw(user as mob)
	return src.attack_hand(user)

/turf/unsimulated/floor/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return


/turf/unsimulated/floor/water
	name = "water"
	icon = 'icons/misc/beach.dmi'
	icon_state = "water2"
	layer = 5

/turf/unsimulated/floor/asteroid
	name = "ground"
	icon_state = "asteroid1"

	New()
		icon_state = "asteroid[rand(0,12)]"

/turf/unsimulated/floor/ash
	name = "cave"
	icon_state = "blackash1"

	New()
		icon_state = "blackash[rand(1,3)]"

/turf/unsimulated/floor/grass
	name = "Grass"
	icon_state = "grass1"

	New()
		icon_state = "grass[rand(1,3)]"

/turf/unsimulated/floor/cobble
	name = "cobblestone"
	icon_state = "cobblestone1"

	New()
		icon_state = "cobblestone[rand(1,2)]"

