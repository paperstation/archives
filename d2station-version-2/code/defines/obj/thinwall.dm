/obj/thinwall
	name = "wall"
	icon = 'structures.dmi'
	icon_state = "thinwall"
	desc = "Looks simply like a thin version of a metal wall."
	density = 0
	opacity = 1
	var/ini_dir = null
	var/state = 0
	var/health = 200
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER

/obj/thinwall/north
	dir = NORTH

/obj/thinwall/east
	dir = EAST

/obj/thinwall/west
	dir = WEST

/obj/thinwall/south
	dir = SOUTH