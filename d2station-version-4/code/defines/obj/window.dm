/obj/window
	name = "window"
	icon = 'structures.dmi'
	desc = "A window."
	density = 1
	var/health = 14.0
	var/ini_dir = null
	var/state = 0
	var/reinf = 0
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER

// Prefab windows to make it easy...



// Basic

/obj/window/basic
	icon_state = "window"

/obj/window/basic/north
	dir = NORTH

/obj/window/basic/east
	dir = EAST

/obj/window/basic/west
	dir = WEST

/obj/window/basic/south
	dir = SOUTH

/obj/window/basic/northwest
	dir = NORTHWEST

/obj/window/basic/northeast
	dir = NORTHEAST

/obj/window/basic/southwest
	dir = SOUTHWEST

/obj/window/basic/southeast
	dir = SOUTHEAST

// Reinforced

/obj/window/reinforced
	reinf = 1
	icon_state = "rwindow"
	name = "reinforced window"

/obj/window/reinforced/north
	dir = NORTH

/obj/window/reinforced/east
	dir = EAST

/obj/window/reinforced/west
	dir = WEST

/obj/window/reinforced/south
	dir = SOUTH

/obj/window/reinforced/northwest
	dir = NORTHWEST

/obj/window/reinforced/northeast
	dir = NORTHEAST

/obj/window/reinforced/southwest
	dir = SOUTHWEST

/obj/window/reinforced/southeast
	dir = SOUTHEAST

/obj/window/vacuum
	health = 150
	icon_state = "vwindow"
	name = "vacuum window"

/obj/window/vacuum/north
	dir = NORTH

/obj/window/vacuum/east
	dir = EAST

/obj/window/vacuum/west
	dir = WEST


/obj/window/vacuum/south
	dir = SOUTH


/obj/window/vacuum/northwest
	dir = NORTHWEST


/obj/window/vacuum/northeast
	dir = NORTHEAST


/obj/window/vacuum/southwest
	dir = SOUTHWEST


/obj/window/vacuum/southeast
	dir = SOUTHEAST

/obj/window/fence
	health = 300
	icon_state = "fence"
	name = "fence"

/obj/window/fence/north
	dir = NORTH

/obj/window/fence/east
	dir = EAST

/obj/window/fence/west
	dir = WEST


/obj/window/fence/south
	dir = SOUTH


/obj/window/fence/northwest
	dir = NORTHWEST


/obj/window/fence/northeast
	dir = NORTHEAST


/obj/window/fence/southwest
	dir = SOUTHWEST


/obj/window/fence/southeast
	dir = SOUTHEAST


/obj/window/reinforced/tinted
	name = "tinted window"
	icon_state = "twindow"
	opacity = 1

/obj/window/reinforced/tinted/frosted
	icon_state = "fwindow"
	name = "frosted window"

// One-way windows

/obj/window/basic/oneway/
	name = "mirrored window"
	icon_state = "mwindow"
	health = 30
	var/reversed = 0

/obj/window/basic/oneway/north
	dir = NORTH

/obj/window/basic/oneway/east
	dir = EAST

/obj/window/basic/oneway/west
	dir = WEST

/obj/window/basic/oneway/south
	dir = SOUTH

/*/obj/window/basic/oneway/reversed
	name = "mirrored window"
	icon_state = "mwindow"
	health = 30
	reversed = 1

/obj/window/basic/oneway/reversed/north
	dir = NORTH

/obj/window/basic/oneway/reversed/east
	dir = EAST

/obj/window/basic/oneway/reversed/west
	dir = WEST

/obj/window/basic/oneway/reversed/south
	dir = SOUTH*/

// Pod

/obj/window_shuttle
	name = "window"
	icon = 'shuttle.dmi'
	icon_state = "window_white1"
	var/source_icon_state = "window_white"
	var/glass = 1.0
	var/broken = 0
	desc = "A thick window secured into its frame."
	anchored = 1
	density = 1
	var/health = 60
	flags = null

