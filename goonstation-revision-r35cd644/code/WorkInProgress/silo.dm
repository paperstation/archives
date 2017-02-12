/*/obj/silo_phantom
	color = "#404040"

/atom
	var/list/obj/silo_phantom/phantoms

	proc
		create_phantoms()
			src.phantom = new
			var/image/I = image(src)
			I.layer = src.layer * 0.01
			src.phantom.overlays += I

/turf/simulated/floor/phantom_test
	RL_Ignore = 1

	New()
		..()
		src.create_phantom()
		src.phantom.loc = locate(src.x+16, src.y, src.z)

	Entered(atom/movable/A, turf/OldLoc)
		..()
		if (istype(A, /obj/overlay/tile_effect))
			return
		if (!A.phantom)
			A.create_phantom()
		A.phantom.loc = locate(src.x+16, src.y, src.z)
		A.phantom.dir = A.dir

/turf/simulated/floor/phantom_test2
	RL_Ignore = 1
	icon = null*/

/obj/grille/catwalk/dubious
	name = "rusty catwalk"
	desc = "This one looks even less safe than usual."
	var/collapsing = 0

	New()
		health = rand(5, 10)
		update_icon()

	HasEntered(atom/movable/A)
		if (ismob(A))
			src.collapsing++
			spawn(10)
				collapse_timer()
				if (src.collapsing)
					playsound(src.loc, 'sound/ambience/creaking_metal.ogg', 25, 1)

	proc/collapse_timer()
		var/still_collapsing = 0
		for (var/mob/M in src.loc)
			src.collapsing++
			still_collapsing = 1
		if (!still_collapsing)
			src.collapsing--

		if (src.collapsing >= 5)
			playsound(src.loc, 'sound/effects/grillehit.ogg', 50, 1)
			for(var/mob/M in AIviewers(src, null))
				boutput(M, "[src] collapses!")
			qdel(src)

		if (src.collapsing)
			spawn(10)
				src.collapse_timer()
