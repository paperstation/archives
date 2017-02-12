/obj/structure/awaymission/mrbones/candle
	name = "Candle"
	desc = "TOO SPOOKY!!!"
	icon = 'icons/awaymissions/mrbones.dmi'
	icon_state = "candle"
	anchored = 1
	density = 1
	var/obj/effect/away/mrbones/lighting/linkedlight
	var/lightout = 0
/obj/structure/awaymission/mrbones/candle/New()
	linkedlight = new/obj/effect/away/mrbones/lighting
	linkedlight.loc = src
	linkedlight.C = src
/obj/structure/awaymission/mrbones/candle/HasProximity(atom/movable/AM as mob|obj)
	if(ishuman(AM))
		if(lightout == 0)
			linkedlight.changeloc()
			lightout = 1
		else
			return

/obj/effect/away/mrbones/lighting
	name = null
	layer = -100
	luminosity = 0
	anchored = 1
	density = 0
	var/obj/structure/awaymission/mrbones/candle/C

/obj/effect/away/mrbones/lighting/proc/changeloc()
	C.luminosity = 4
	spawn(100)
		loc = C
		C.luminosity = 0

/obj/structure/awaymission/mrbones/sign
	name = "SPOOKY CAVE"
	desc = "2SPOOKY 4 U"
	icon = 'icons/awaymissions/cave.dmi'

/obj/effect/away/mrbones/draw
	name = "Draw Bridge"
	desc = "Lavely helps you get past otherwise deadly lava."
	icon = 'icons/awaymissions/mrbones.dmi'
	icon_state = "draw"