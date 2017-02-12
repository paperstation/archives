// W I P
// contains: mars area remake stuff

#define MARS_IS_LIVE

/turf/unsimulated/floor/setpieces/martian
	name = "martian dust"
	desc = "Someone would've probably paid big money to get a sample of this fifty years ago."
	icon = 'icons/turf/floors.dmi'
	icon_state = "mars1"
	carbon_dioxide = 500
	nitrogen = 0
	oxygen = 0
	temperature = 100
	RL_Ignore = 0
	var/rocks = 1

	New()
		..()
		if(src.rocks)
			icon_state = "[pick("mars1","mars1","mars1","mars2","mars3")]"

/turf/unsimulated/floor/setpieces/martian/cliff
	icon_state = "mars_cliff1"
	density = 1
	rocks = 0

/turf/unsimulated/floor/setpieces/martian/highway
	icon_state = "marshighw1"
	desc = "highway"
	rocks = 0

/turf/unsimulated/wall/setpieces/martian
	name = "martian rock"
	desc = "Hey, it's not red at all!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "mars"
	blocks_air = 1
	opacity = 1
	density = 1
	RL_Ignore = 0

/obj/decal/fakeobjects/mule_xl
	name = "Mulebot XL"
	desc = "If you thought getting run over by a mulebot was bad, get a load of his big brother! No pun intended."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "mule-xl"
	pixel_x = -16

/obj/decal/fakeobjects/mars_billboard
	name = "Billboard"
	desc = "A billboard for some backwater planetary outpost. How old is this?"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "mars_sign1"
	anchored = 1
	density = 0
	pixel_x = -32

/obj/decal/cleanable/dirt/mars
	name = "dirt"
	desc = "That isn't any old pile of dirt, it's martian dirt!"
	density = 0
	anchored = 1
	icon = 'icons/misc/worlds.dmi'
	icon_state = "mars_dirt"
