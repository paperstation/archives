//AutoScale procs for D2Station V5
//Line #225 in master_controller.dm for more info.
/turf/proc/xScale(var/xscale = 64, yscale = 64)
	var/icon/I = new(src.icon)
	I.Scale(xscale,yscale)
	src.icon = I
/obj/proc/xScale(var/xscale = 64, yscale = 64)
	var/icon/I = new(src.icon)
	I.Scale(xscale,yscale)
	src.icon = I
/mob/proc/xScale(var/xscale = 64, yscale = 64)
	var/icon/I = new(src.icon)
	I.Scale(xscale,yscale)
	src.icon = I

//AutoScale all items on spawn
/obj
	var/xscaled = 0
	..()

/mob/New()
	var/icon/I = new(src.icon)
	I.Scale(64,64)
	src.icon = I
	..()

/turf/New()
	var/icon/I = new(src.icon)
	I.Scale(64,64)
	src.icon = I
	..()