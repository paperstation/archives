/obj/effect/decal/cleanable
	density = 0
	anchored = 1
	gender = PLURAL
	layer = 2.1//Just above turfs
	damage_resistance = -1//Cant beat it to death
	var/list/random_icon_states = list()

/obj/effect/decal/cleanable/New()
	if(random_icon_states && random_icon_states.len > 0)
		src.icon_state = pick(src.random_icon_states)
	..()