/var/list/screenOverlayLibrary = list()

/mob/var/list/screenoverlays = list()
//Please note that overlays are saved on a per mob basis.
//You need to make sure that they are updated (added to the client screen) in the life proc and on mob login. Or in other ways if not applicable.
//You also need to make sure they are removed in those proc and on logout and on ghosting
//For convenience i have tagged all related additions in other files with "ov1"

/mob/proc/addOverlayComposition(var/compType) //Adds composition type to active compositions on mob
	if(!ispath(compType))return
	if(!screenOverlayLibrary.Find(compType))return
	var/instance = screenOverlayLibrary[compType]
	if(screenoverlays.Find(instance))return //Only one instance per overlay Type. Keep this. Im serious. Else mobs will end up with 324598762 blind overlays
	screenoverlays.Add(instance)
	return

/mob/proc/removeOverlayComposition(var/compType) //Removes composition type from active compositions on mob
	if(!ispath(compType)) return
	if(!screenOverlayLibrary.Find(compType)) return
	var/instance = screenOverlayLibrary[compType]
	if(screenoverlays.Find(instance))
		screenoverlays.Remove(instance)
	return

/mob/proc/hasOverlayComposition(var/compType) //Does that mob have the overlay active?
	if(!ispath(compType)) return
	if(!screenOverlayLibrary.Find(compType)) return
	var/instance = screenOverlayLibrary[compType]
	return screenoverlays.Find(instance)

/mob/proc/updateOverlaysClient(var/client/CL) //Updates the overlays of current mob to given client
	removeOverlaysClient(CL)
	addOverlaysClient(CL)
	return

/mob/proc/addOverlaysClient(var/client/CL) //Adds the overlays of current mob to given client
	if(!CL) return
	for(var/datum/overlayComposition/C in screenoverlays)
		for(var/obj/screen/screenoverlay/S in C.instances)
			CL.screen += S

/mob/proc/removeOverlaysClient(var/client/CL) //Removes all overlays of given client
	if(!CL) return
	for(var/obj/screen/screenoverlay/S in CL.screen)
		CL.screen -= S

//Because dead mobs don't have a life loop
/mob/dead/addOverlayComposition()
	..()
	updateOverlaysClient(src.client)

/mob/dead/removeOverlayComposition()
	..()
	updateOverlaysClient(src.client)

/obj/screen/screenoverlay
	name = ""
	icon = 'icons/effects/overlays/cloudy.dmi'
	layer = HUD_LAYER_UNDER_2
	screen_loc = "1,1"

/datum/overlayDefinition
	var/d_icon = 'icons/effects/overlays/cloudy.dmi'
	var/d_icon_state = "cloudy"
	var/d_alpha = 255
	var/customization_third_color = "#ffffff"
	var/d_blend_mode = 1
	var/d_layer = HUD_LAYER_UNDER_2		//18 is just below the ui but above everything else.
	var/d_mouse_opacity = 0 //In case you want it to block clicks. For blindness and such.

//list of overlay composition stored on mob
//list is applied in life proc?! and login

/datum/overlayComposition
	var/list/definitions = list()
	var/list/instances = list()

	New()
		for(var/datum/overlayDefinition/D in definitions)
			var/obj/screen/screenoverlay/S = new()
			S.icon = D.d_icon
			S.icon_state = D.d_icon_state
			S.alpha = D.d_alpha
			S.color = D.customization_third_color
			S.blend_mode = D.d_blend_mode
			S.layer = D.d_layer
			S.mouse_opacity = D.d_mouse_opacity
			instances.Add(S)
		return ..()

	proc/removeFromMob(var/mob/M)
		return

	proc/addToMob(var/mob/M) //Do not allow more than once instance of any given type. There is a reason for this,
		return

// Debug stuff

/proc/removerlays()
	for(var/obj/screen/screenoverlay/F in world)
		del(F)

	return

/proc/overlaytest()
	var/numover = input(usr, "How many overlays?") as null|num
	if (!numover)
		return
	var/list/overlist = list()
	for(var/i=0, i<numover, i++)
		var/obj/screen/screenoverlay/O = createover(i)
		if(O) overlist.Add(O)

	boutput(usr, "<b><font color=\"gold\"> [overlist.len] overlays defined.</font></b>")

	if(overlist.len)
		for(var/obj/screen/screenoverlay/F in overlist)
			F.add_to_client(usr.client)

		switch(alert("Would you like to add these overlays to everyone?",,"Yes","No"))
			if("Yes")
				for(var/client/C)
					if(C == usr.client) continue
					for(var/obj/screen/screenoverlay/F in overlist)
						F.add_to_client(C)
			if("No")
				for(var/obj/screen/screenoverlay/F in overlist)
					usr.client.screen -= F
			 return

	return

/proc/createover(var/i)
/*
	var/obj/screen/screenoverlay/F = new()

	var/state = input(usr, "Icon state?","Overlay #[i]", "wiggle") in icon_states(icon('icons/effects/480x480.dmi'))
	var/blendm = input(usr, "Blend mode?","Overlay #[i] (1=normal,2=add,3=sub,4=mult)", 1) in list(1, 2, 3, 4)
	var/ialpha = input(usr, "Alpha?","Overlay #[i] (1-255 opaque)", 255) as num
	var/icolor = input(usr, "Color?","Overlay #[i] (hex)", "#ffffff")
	var/ilayer = input(usr, "Layer?","Overlay #[i]", HUD_LAYER_UNDER_2) as num

	if(length(state) && blendm && ialpha && length(icolor))
		F.icon_state = state
		F.blend_mode = blendm
		F.alpha = max(0, min(255, ialpha))
		F.color = icolor
		F.layer = ilayer

		return F
*/
	return null

// END Debug stuff

// Compositions below ...

/datum/overlayComposition/blinded
	New()
		var/datum/overlayDefinition/spot = new()
		spot.d_icon = 'icons/effects/overlays/knockout2.dmi'
		spot.d_icon_state = "knockout2"
		spot.d_blend_mode = 3 //sub
		spot.d_mouse_opacity = 1 //its gonna be use for blindness. Dont let them click stuff.
		definitions.Add(spot)

		var/datum/overlayDefinition/fluff = new()
		fluff.d_icon = 'icons/effects/overlays/meatysmall.dmi'
		fluff.d_icon_state = "meatysmall"
		fluff.d_blend_mode = 3 //sub
		fluff.customization_third_color = "#eeeeee"
		definitions.Add(fluff)

		return ..()

/datum/overlayComposition/flashed
	New()
		var/datum/overlayDefinition/beam = new()
		beam.d_icon = 'icons/effects/overlays/beamout.dmi'
		beam.d_icon_state = "beamout"
		beam.d_blend_mode = 2 //add
		beam.customization_third_color = "#eeeeee"
		definitions.Add(beam)

		var/datum/overlayDefinition/spot = new()
		spot.d_icon = 'icons/effects/overlays/meatysmall.dmi'
		spot.d_icon_state = "meatysmall"
		spot.d_blend_mode = 2 //add
		spot.customization_third_color = "#eeeeee"
		definitions.Add(spot)
		return ..()

/datum/overlayComposition/smoke
	New()
		var/datum/overlayDefinition/spot = new()
		spot.d_icon = 'icons/effects/overlays/knockout.dmi'
		spot.d_icon_state = "knockout"
		spot.d_blend_mode = 3 //sub
		spot.customization_third_color = "#eeeeee"
		definitions.Add(spot)

		var/datum/overlayDefinition/one = new()
		one.d_icon = 'icons/effects/overlays/cloudy.dmi'
		one.d_icon_state = "cloudy"
		one.d_blend_mode = 3 //sub
		one.customization_third_color = "#aaaaaa"
		definitions.Add(one)

		var/datum/overlayDefinition/two = new()
		two.d_icon = 'icons/effects/overlays/cloudy.dmi'
		two.d_icon_state = "cloudy"
		two.d_blend_mode = 2 //add
		two.customization_third_color = "#bbbbbb"
		definitions.Add(two)

		return ..()

/datum/overlayComposition/heat
	New()
		var/datum/overlayDefinition/part1 = new()
		part1.d_icon = 'icons/effects/overlays/meatysmall.dmi'
		part1.d_icon_state = "meatysmall"
		part1.d_blend_mode = 2
		part1.customization_third_color = "#ff0000"
		part1.d_alpha = 100
		definitions.Add(part1)

		var/datum/overlayDefinition/part2 = new()
		part2.d_icon = 'icons/effects/overlays/cloudy.dmi'
		part2.d_icon_state = "cloudy"
		part2.d_blend_mode = 2
		part2.customization_third_color = "#ffff00"
		part1.d_alpha = 100
		definitions.Add(part2)
		return ..()

/datum/overlayComposition/anima
	New()
		var/datum/overlayDefinition/zero = new()
		zero.d_icon = 'icons/effects/overlays/beamout.dmi'
		zero.d_icon_state = "beamout"
		zero.d_blend_mode = 4
		zero.customization_third_color = "#5C0E80"
		zero.d_alpha = 255
		definitions.Add(zero)
		return ..()

/datum/overlayComposition/triplemeth
	New()
		var/datum/overlayDefinition/zero = new()
		zero.d_icon = 'icons/effects/overlays/meatysmall.dmi'
		zero.d_icon_state = "meatysmall"
		zero.d_blend_mode = 2
		zero.customization_third_color = "#ff0000"
		zero.d_alpha = 75
		definitions.Add(zero)

		var/datum/overlayDefinition/one = new()
		one.d_icon = 'icons/effects/overlays/cloudy.dmi'
		one.d_icon_state = "cloudy"
		one.d_blend_mode = 2
		one.customization_third_color = "#00ff00"
		one.d_alpha = 75
		definitions.Add(one)

		var/datum/overlayDefinition/two = new()
		two.d_icon = 'icons/effects/overlays/beamout.dmi'
		two.d_icon_state = "beamout"
		two.d_blend_mode = 2
		two.customization_third_color = "#0000ff"
		two.d_alpha = 75
		definitions.Add(two)

		return ..()

/datum/overlayComposition/static_noise
	var/special_blend = BLEND_DEFAULT
	New()
		var/datum/overlayDefinition/zero = new()
		zero.d_icon = 'icons/effects/overlays/noise.dmi'
		zero.d_icon_state = "noise"
		zero.d_blend_mode = BLEND_DEFAULT
		zero.customization_third_color = "#bbbbbb"
		zero.d_mouse_opacity = 1
		definitions.Add(zero)

		return ..()

/datum/overlayComposition/static_noise/sub
	special_blend = BLEND_SUBTRACT

/datum/overlayComposition/blinded_r_eye
	New()
		var/datum/overlayDefinition/dither = new()
		dither.d_icon = 'icons/effects/overlays/Rtrans.dmi'
		dither.d_icon_state = "Rtrans"
		dither.d_blend_mode = 1
		//dither.d_mouse_opacity = 1
		definitions.Add(dither)

		var/datum/overlayDefinition/meaty = new()
		meaty.d_icon = 'icons/effects/overlays/meatyR.dmi'
		meaty.d_icon_state = "meatyR"
		meaty.d_blend_mode = 2
		meaty.d_alpha = 140
		meaty.customization_third_color = "#610306"
		definitions.Add(meaty)
		return ..()

/datum/overlayComposition/blinded_l_eye
	New()
		var/datum/overlayDefinition/dither = new()
		dither.d_icon = 'icons/effects/overlays/Ltrans.dmi'
		dither.d_icon_state = "Ltrans"
		dither.d_blend_mode = 1
		//dither.d_mouse_opacity = 1
		definitions.Add(dither)

		var/datum/overlayDefinition/meaty = new()
		meaty.d_icon = 'icons/effects/overlays/meatyL.dmi'
		meaty.d_icon_state = "meatyL"
		meaty.d_blend_mode = 2
		meaty.d_alpha = 140
		meaty.customization_third_color = "#610306"
		definitions.Add(meaty)

		return ..()

/datum/overlayComposition/shuttle_warp
	var/warp_dir = "warp"
	New()
		var/datum/overlayDefinition/warp = new()
		warp.d_icon = 'icons/effects/overlays/warp.dmi'
		warp.d_icon_state = src.warp_dir
		warp.d_blend_mode = 1
		warp.d_layer = TURF_LAYER-1
		definitions.Add(warp)

		return ..()

/datum/overlayComposition/shuttle_warp/ew
	warp_dir = "warp_ew"
