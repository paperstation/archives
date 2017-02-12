/obj/laser
	name = "laser"
	desc = "Pew!"
	icon = 'icons/obj/projectiles.dmi'
	var/damage = 0.0
	var/range = 10.0
	var/mob/shooter = null //Who fired this?

/obj/laser/Bump()
	src.range--
	return

/obj/laser/Move()
	src.range--
	return

/atom/proc/laserhit(L as obj)
	return 1

