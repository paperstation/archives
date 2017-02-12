
obj/multiz/ladder
        name = "Ladder"
        anchored = 1
        density = 1
        var/up = 1 // 1 = up, 0 = down
        icon = 'findone.dmi'
        icon_state = "ladder"

obj/multiz/ladder/attack_hand(var/mob/M)
	if(up)
		var/z = src.z
		z += 1
		var/turf/T = locate(src.x,src.y,z)
		M.Move(T)
	else
		var/z = src.z
		z -= 1
		var/turf/T = locate(src.x,src.y,z)
		M.Move(T)
obj/multiz/ladder/New()
	..()
	if(up)
		icon_state = "ladderup"
		return
	else
		icon_state = "ladderdown"
		return
	return



//HEAD'S LADDER CODE:
/*
obj/multiz/ladder
    name = "Ladder"
    var/up = 1 // 1 = up 0 = down
    icon = 'findone.dmi'
    icon_state = "ladder"

    obj/multiz/ladder/attack_hand(var/mob/M)
    if(up)
        var/z = src.z
        z += 1
        var/turf/T = locate(src.x,src.y,z)
        if(!T.density)
            M.Move(T)
    else
        var/z = src.z
        z -= 1
        var/turf/T = locate(src.x,src.y,z)
        if(!T.density)
            M.Move(T)

obj/multiz/ladder/attackby(var/W, var/mob/M)
    return attack_hand(M)

obj/multiz/ladder/New()
    ..()
    if(up)
        icon_state = "ladderup"
        return
    else
        icon_state = "ladderdown"
        return
*/