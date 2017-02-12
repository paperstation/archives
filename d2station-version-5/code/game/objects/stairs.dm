obj/multiz/stairs
        name = "UpStairs"
        anchored = 1
        density = 1
        var/up = 1 // 1 = up, 0 = down
        icon = 'findone.dmi'
        icon_state = "stairs"

obj/multiz/stairs/Bumped(mob/M as mob|obj)
        if(up)
                var/obj/O
                if(M.pulling)
                        O = M.pulling
                var/z = M.z
                z += 1
                var/turf/T = locate(src.x,src.y,z)
                M.Move(T)
                if(O)
                        O.loc = M.loc
                        M.pulling = O

        else
                var/obj/O
                if(M.pulling)
                        O = M.pulling
                var/z = M.z
                z -= 1
                var/turf/T = locate(src.x,src.y,z)
                M.Move(T)
                if (O)
                        O.loc = M.loc
                        M.pulling = O
obj/multiz/stairs/New()
	..()
	if(up)
		icon_state = "stairsup"
		return
	else
		icon_state = "stairsdown"
		return
	return