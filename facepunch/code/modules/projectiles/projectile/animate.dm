/obj/item/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if((istype(target, /obj/item) || istype(target, /obj/structure)) && !is_type_in_list(target, protected_objects))
			var/obj/O = target
			new /mob/living/simple_animal/hostile/mimic/copy(O.loc, O, firer)
		return 1

/*
/obj/item/projectile/animate/Bump(var/atom/change)
	. = ..()
	if(istype(change, /obj/item) || istype(change, /obj/structure) && !is_type_in_list(change, protected_objects))
		var/obj/O = change
		new /mob/living/simple_animal/hostile/mimic/copy(O.loc, O, firer)*/
