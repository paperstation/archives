/atom/movable/verb/pull()
	set name = "Pull"
	set category = "IC"
	set src in oview(1)

	usr.start_pulling(src)
	return

/atom/proc/point()
/*	set name = "Point To"
	set category = "Object"
	set src in oview()
	src = null*/

	var/atom/this = src//detach proc from src
	src = null//tbh I am not sure what this is doing
	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(usr.status_flags & FAKEDEATH)
		return

	var/tile = get_turf(this)
	if(!tile)
		return

	var/P = new /obj/effect/decal/point(tile)
	spawn(20)
		if(P)	del(P)

	usr.visible_message("<b>[usr]</b> points to [this]")
