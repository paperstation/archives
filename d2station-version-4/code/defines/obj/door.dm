

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'doorint.dmi'
	icon_state = "door1"
	opacity = 1
	density = 1
	layer = 3.1
	var/secondsElectrified = 0
	var/visible = 1
	var/p_open = 0
	var/operating = 0
	anchored = 1
	var/autoclose = 0
	var/transparent = 0
	var/id
	var/ishouse


/obj/machinery/door/filler_object
	name = ""
	icon_state = ""


/obj/machinery/door/filler_object/proc/refresh()
	for(var/obj/machinery/door/airlock/glass_large/A)
		if(A.density == 1)
			src.density = 1
		if(A.density == 0)
			src.density = 0

/obj/machinery/door/firedoor
	name = "Firelock"
	desc = "Disable Alarm"
	icon = 'Doorfire.dmi'
	icon_state = "door0"
	var/blocked = null
	opacity = 0
	density = 0
	var/nextstate = null

/obj/machinery/door/firedoor/border_only
	name = "Firelock"
	desc = "Disable Alarm."
	icon = 'door_fire2.dmi'
	icon_state = "door0"

/obj/machinery/forcefield
	name = "Material Screening Field"
	icon = 'forcefield.dmi'
	icon_state = "canpass_field"
	anchored = 1
	var/id = 1.0
	var/list/incorrect_items = list()
	//Uses req_access_txt to determine ID passage

/obj/machinery/forcefield/security
	req_access_txt = 1

/obj/machinery/forcefield/gun
	incorrect_items = list(/obj/item/weapon/gun)

/obj/machinery/door/poddoor
	name = "Podlock"
	desc = "Why it no open!!!"
	icon = 'rapid_pdoor.dmi'
	icon_state = "pdoor1"


/obj/machinery/door/poddoor/shuttles
	name = "Shuttle Podlock"
	icon = 'rapid_pdoorshuttle.dmi'
	icon_state = "pdoor1"

/obj/machinery/door/poddoor/shuttlesdark
	name = "Shuttle Podlock"
	icon = 'rapid_pdoorshuttle1.dmi'
	icon_state = "pdoor1"

/obj/machinery/door/poddoor/two_tile_hor
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	icon = '1x2blast_hor.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(src,EAST))
		f1.density = density
		f2.density = density
		f1.ul_SetOpacity(opacity)
		f2.ul_SetOpacity(opacity)

	Del()
		del f1
		del f2
		..()

/obj/machinery/door/poddoor/two_tile_ver
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	icon = '1x2blast_vert.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(src,NORTH))
		f1.density = density
		f2.density = density
		f1.ul_SetOpacity(opacity)
		f2.ul_SetOpacity(opacity)

	Del()
		del f1
		del f2
		..()

/obj/machinery/door/poddoor/four_tile_hor
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	var/obj/machinery/door/poddoor/filler_object/f3
	var/obj/machinery/door/poddoor/filler_object/f4
	icon = '1x4blast_hor.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(f1,EAST))
		f3 = new/obj/machinery/door/poddoor/filler_object (get_step(f2,EAST))
		f4 = new/obj/machinery/door/poddoor/filler_object (get_step(f3,EAST))
		f1.density = density
		f2.density = density
		f3.density = density
		f4.density = density
		f1.ul_SetOpacity(opacity)
		f2.ul_SetOpacity(opacity)
		f4.ul_SetOpacity(opacity)
		f3.ul_SetOpacity(opacity)

	Del()
		del f1
		del f2
		del f3
		del f4
		..()

/obj/machinery/door/poddoor/four_tile_ver
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	var/obj/machinery/door/poddoor/filler_object/f3
	var/obj/machinery/door/poddoor/filler_object/f4
	icon = '1x4blast_vert.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (src.loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(f1,NORTH))
		f3 = new/obj/machinery/door/poddoor/filler_object (get_step(f2,NORTH))
		f4 = new/obj/machinery/door/poddoor/filler_object (get_step(f3,NORTH))
		f1.density = density
		f2.density = density
		f3.density = density
		f4.density = density
		f1.ul_SetOpacity(opacity)
		f2.ul_SetOpacity(opacity)
		f4.ul_SetOpacity(opacity)
		f3.ul_SetOpacity(opacity)

	Del()
		del f1
		del f2
		del f3
		del f4
		..()

/obj/machinery/door/poddoor/filler_object
	name = ""
	icon_state = ""

/obj/machinery/door/window
	name = "interior door"
	desc = "A door made from a window."
	icon = 'windoor.dmi'
	icon_state = "left"
	var/base_state = "left"
	var wood = 0
	visible = 0.0
	flags = ON_BORDER
	opacity = 0
	health = 100

/obj/machinery/door/window/wood
	name = "interior door"
	desc = "A wooden swinging door."
	icon = 'windoorwood.dmi'
	health = 175 //wood IRL is indeed sturdier than glass, get off my case. - Nernums

/obj/machinery/door/window/brigdoor
	name = "Brig Door"
	desc = "A stronger door made from window."
	icon = 'windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"

	health = 150


/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"


/obj/machinery/door/window/wood/northleft
	dir = NORTH

/obj/machinery/door/window/wood/eastleft
	dir = EAST

/obj/machinery/door/window/wood/westleft
	dir = WEST

/obj/machinery/door/window/wood/southleft
	dir = SOUTH

/obj/machinery/door/window/wood/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/wood/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/wood/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/wood/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"


/obj/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

