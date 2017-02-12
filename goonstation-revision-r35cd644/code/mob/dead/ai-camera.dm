#define camera_range 4       //Range outside a single camera before static starts
#define camera_extra_range 3 //How much static-y extra range outside the normal range. After this its 100% static

/obj/camera_area
	name = ""
	alpha = 150
	anchored = 1
	density = 0
	opacity = 0
	icon = 'icons/mob/hud_common.dmi'
	icon_state = "dither100"
	layer = 45
	mouse_opacity = 0
	blend_mode = 2

/mob/living/intangible/aicamera
	icon = 'icons/mob/ai.dmi'
	icon_state = "a-eye"
	layer = NOLIGHT_EFFECTS_LAYER_BASE
	density = 0
	canmove = 1
	blinded = 0
	anchored = 1
	name = "camera view"
	var/obj/ai_static/ai_static
	var/list/prev_imgs = list()

/obj/ai_static
	name = ""
	alpha = 0
	anchored = 1
	density = 0
	opacity = 0
	icon = 'icons/mob/hud_common.dmi'
	icon_state = "static"
	screen_loc = "NORTH,WEST to SOUTH,EAST"
	layer = 50
	mouse_opacity = 0

/mob/living/intangible/aicamera/proc/sidesVisible(var/turf/location, var/list/covered)
	var/north = get_step(location, NORTH)
	var/south = get_step(location, SOUTH)
	var/east = get_step(location, EAST)
	var/west = get_step(location, WEST)

	var/oNorth = 0
	for(var/atom/A in north)
		if(A.opacity)
			oNorth = 1
			break

	var/oSouth = 0
	for(var/atom/A in south)
		if(A.opacity)
			oSouth = 1
			break

	var/oEast = 0
	for(var/atom/A in east)
		if(A.opacity)
			oEast = 1
			break

	var/oWest = 0
	for(var/atom/A in west)
		if(A.opacity)
			oWest = 1
			break

	var/ns = ((north in covered) && !oNorth) && ((south in covered) && !oSouth)
	var/ew = ((east in covered) && !oEast) && ((west in covered) && !oWest)

	return (ns || ew)

/mob/living/intangible/aicamera/proc/adjustStaticAlpha(var/newval)
	//animate(ai_static, alpha = (ai_static.alpha + newval)/2, time = 5)
	//animate(alpha = newval, time = 5)
	ai_static.alpha = newval
	if(newval >= 255)
		src.client.show_popup_menus = 0
		ai_static.mouse_opacity = 2
	else
		src.client.show_popup_menus = 1
		ai_static.mouse_opacity = 0
	return

/mob/living/intangible/aicamera/proc/adjustView()
	if(!src.client) return

	var/opaque = 0
	for(var/atom/A in src.loc)
		if(A.opacity)
			opaque = 1
			break

	var/list/covered = list() //list of all covered turfs.
	var/turf/closest = null   //closest covered turf

	for(var/obj/machinery/camera/C in cameras)
		if(get_dist(src, C) <= world.view * 2)

			var/def_lum = C.luminosity //Temporarily cranking up the camera luminosity because only mobs have see_in_dark. its either this or making cameras mobs.
			C.luminosity = world.view * 2 //Without this , camera range would decrease in darkness and thats silly. This shouldnt cause any visual artifacts as its reset right after the calculations

			for(var/turf/T in view(camera_range, C))

				var/skip = 0
				for(var/atom/A in T)
					if(A.opacity)
						skip = 1
						break

				if(T.opacity || skip) continue

				if(!closest || get_dist(src, T) < get_dist(src, closest))
					closest = T

				covered.Add(T)

			C.luminosity = def_lum

	src.client.images.Remove(prev_imgs)
	prev_imgs.Cut()

	for(var/turf/T in covered)
		prev_imgs.Add(T.camera_image)
		src << T.camera_image

	if((src.loc.opacity || opaque) && !sidesVisible(src, covered))
		adjustStaticAlpha(255)
		return

	if(closest)
		var/def_lum = closest.luminosity
		closest.luminosity = world.view * 2

		if( !(src in viewers(world.view, closest)) ) //The closest tile is actually behind a wall or something.
			adjustStaticAlpha(255)
			return

		closest.luminosity = def_lum

		if(!(src.loc in covered))
			if(get_dist(src, closest) < camera_extra_range)
				if(sidesVisible(src, covered))
					adjustStaticAlpha(0)
				else
					adjustStaticAlpha(round(255 / camera_extra_range) * get_dist(src, closest))
			else
				adjustStaticAlpha(255)
		else
			adjustStaticAlpha(0)
	else
		adjustStaticAlpha(255)

	return

/mob/living/intangible/aicamera/disposing()
	..()

/mob/living/intangible/aicamera/New()
	. = ..()
	src.invisibility = 0
	src.sight = 0
	src.see_invisible = 0
	ai_static = new(src)

/mob/living/intangible/aicamera/Login()
	..()
	if(!src.client)
		return
	src.client.screen += ai_static
	return

/mob/living/intangible/aicamera/Logout()
	..()
	src.client.screen -= ai_static
	return

/mob/living/intangible/aicamera/Life(datum/controller/process/mobs/parent)
	..(parent)
	adjustView()

/mob/living/intangible/aicamera/Move(var/turf/NewLoc, direct)
	..(NewLoc, direct)
	adjustView()
	return