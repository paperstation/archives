/obj/effect/forcefield
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield"
	anchored = 1.0
	opacity = 0
	density = 1
	unacidable = 1
	health = 100
	max_health = 100

	bullet_act(var/obj/item/projectile/Proj, var/def_zone)
		var/turf/T = get_turf(src.loc)
		if(T)
			for(var/mob/M in T)
				Proj.on_hit(M,M.bullet_act(Proj, def_zone))
				return
		..()
		return


///////////Mimewalls///////////

/obj/effect/forcefield/mime
	icon_state = "mimewall"
	name = "invisible wall"
	desc = "You have a bad feeling about this."
	var/time = 300
	var/creation_time = 0

/obj/effect/forcefield/mime/New()
	..()
	creation_time = world.time + time
	processing_objects.Add(src)

/obj/effect/forcefield/mime/process()
	if(world.time < creation_time)
		return
	processing_objects.Remove(src)
	del(src)