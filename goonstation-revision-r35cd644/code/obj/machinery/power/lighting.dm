// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

/obj/item/light_parts
	name = "fixture parts"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-fixture"
	mats = 4

	var/installed_icon_state = "tube-empty"
	var/installed_base_state = "tube"
	desc = "Parts of a lighting fixture"
	var/fixture_type = /obj/machinery/light
	var/light_type = /obj/item/light/tube
	var/fitting = "tube"

// For metal sheets. Can't easily change an item's vars the way it's set up (Convair880).
/obj/item/light_parts/bulb
	icon_state = "bulb-fixture"
	fixture_type = /obj/machinery/light/small
	installed_icon_state = "bulb1"
	installed_base_state = "bulb"
	fitting = "bulb"
	light_type = /obj/item/light/bulb

/obj/item/light_parts/proc/copy_light(obj/machinery/light/target)
	installed_icon_state = target.icon_state
	installed_base_state = target.base_state
	light_type = target.light_type
	fixture_type = target.type
	fitting = target.fitting
	if (fitting == "tube")
		icon_state = "tube-fixture"
	else
		icon_state = "bulb-fixture"

// the standard tube light fixture

/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = EFFECTS_LAYER_UNDER_1  					// They were appearing under mobs which is a little weird - Ostaf
	var/on = 0					// 1 if on, 0 if off
	var/brightness = 1.6			// luminosity when on, also used in power calculation
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN

	var/obj/item/light/light_type = /obj/item/light/tube		// the type of the inserted light item
	var/light_name = "light tube"				// the name of the inserted light item

	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/wallmounted = 1
	var/rigged = 0				// true if rigged to explode
	var/mob/rigger = null // mob responsible for the explosion
	power_usage = 0
	power_channel = LIGHT
	var/removable_bulb = 1
	var/datum/light/point/light

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness = 1.2
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	light_name = "light bulb"

/obj/machinery/light/emergency
	icon_state = "ebulb1"
	base_state = "ebulb"
	fitting = "bulb"
	brightness = 1
	desc = "A small light used to illuminate in emergencies."
	light_type = /obj/item/light/bulb/emergency
	light_name = "emergency light bulb"
	on = 0
	removable_bulb = 0

	exitsign
		name = "illuminated exit sign"
		desc = "This sign points the way to the escape shuttle."
		brightness = 1.3

/obj/machinery/light/runway_light
	name = "runway light"
	desc = "A small light used to guide pods into hangars."
	icon_state = "runway10"
	base_state = "runway1"
	fitting = "bulb"
	brightness = 0.5
	light_type = /obj/item/light/bulb
	light_name = "light bulb"
	on = 1
	wallmounted = 0
	removable_bulb = 0

	delay2
		icon_state = "runway20"
		base_state = "runway2"
	delay3
		icon_state = "runway30"
		base_state = "runway3"
	delay4
		icon_state = "runway40"
		base_state = "runway4"
	delay5
		icon_state = "runway50"
		base_state = "runway5"

/obj/machinery/light/beacon
	name = "tripod light"
	desc = "A large portable light tripod."
	density = 1
	anchored = 1
	icon_state = "tripod1"
	base_state = "tripod"
	fitting = "bulb"
	wallmounted = 0
	brightness = 1.5
	light_type = /obj/item/light/big_bulb
	light_name = "beacon bulb"
	power_usage = 0

	attackby(obj/item/W, mob/user)

		if (istype(user, /mob/living/silicon))
			return

		if (istype(W, /obj/item/wrench))

			add_fingerprint(user)
			src.anchored = !src.anchored

			if (!src.anchored)
				boutput(user, "<span style=\"color:red\">[src] can now be moved.</span>")
				src.on = 0
			else
				boutput(user, "<span style=\"color:red\">[src] is now secured.</span>")
				src.on = 1

			update()

		else
			return ..()

	has_power()
		return src.anchored


// the desk lamp
/obj/machinery/light/lamp
	name = "desk lamp"
	icon_state = "lamp1"
	base_state = "lamp"
	fitting = "bulb"
	brightness = 1
	desc = "A desk lamp"
	light_type = /obj/item/light/bulb
	light_name = "light bulb"
	wallmounted = 0

	var/switchon = 0		// independent switching for lamps - not controlled by area lightswitch

// green-shaded desk lamp
/obj/machinery/light/lamp/green
	icon_state = "green1"
	base_state = "green"
	desc = "A green-shaded desk lamp"
	light_name = "green light bulb"

	New()
		..()
		light.set_color(0.45, 0.85, 0.25)

// green-shaded desk lamp
/obj/machinery/light/lamp/lava
	name = "lava lamp"
	icon_state = "lava_lamp1"
	base_state = "lava_lamp"
	desc = "An ancient relic from a simpler, more funky time."
	New()
		..()
		light.set_color(0.85, 0.45, 0.35)

// create a new lighting fixture
/obj/machinery/light/New()
	..()
	light = new
	light.set_brightness(brightness)
	light.set_color(initial(src.light_type.color_r), initial(src.light_type.color_g), initial(src.light_type.color_b))
	light.set_height(2.4)
	light.attach(src)
	spawn(1)
		update()

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update()

	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0

	// if the state changed, inc the switching counter
	if(src.light.enabled != on)
		switchcount++

		if (on)
			light.enable()
		else
			light.disable()

		// now check to see if the bulb is burned out
		if(status == LIGHT_OK)
			if(on && rigged)
				if (rigger)
					message_admins("[key_name(rigger)]'s rigged bulb exploded in [src.loc.loc], [showCoords(src.x, src.y, src.z)].")
					logTheThing("combat", rigger, null, "'s rigged bulb exploded in [rigger.loc.loc] ([showCoords(src.x, src.y, src.z)])")
				explode()
			if(on && prob( min(60, switchcount*switchcount*0.01) ) )
				status = LIGHT_BURNED
				icon_state = "[base_state]-burned"
				on = 0
				light.disable()
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(3, 1, src)
				s.start()


// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	spawn(0)
		update()

// examine verb
/obj/machinery/light/examine()
	set src in oview(1)
	set category = "Local"
	if(usr && !usr.stat)
		switch(status)
			if(LIGHT_OK)
				boutput(usr, "[desc] It is turned [on? "on" : "off"].")
			if(LIGHT_EMPTY)
				boutput(usr, "[desc] The [fitting] has been removed.")
			if(LIGHT_BURNED)
				boutput(usr, "[desc] The [fitting] is burnt out.")
			if(LIGHT_BROKEN)
				boutput(usr, "[desc] The [fitting] has been smashed.")



// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/attackby(obj/item/W, mob/user)

	//Wire TODO: Magtractor handling here

	if (issilicon(user))
		if (isghostdrone(user))
			return src.attack_hand(user)
		else
			return

	// attempt to insert light
	if(istype(W, /obj/item/light))
		if(status != LIGHT_EMPTY || status == LIGHT_BROKEN)
			src.add_fingerprint(user)
			var/obj/item/light/OL = new light_type()
			OL.name = light_name
			OL.status = status
			OL.rigged = rigged
			//rigged = 0
			OL.rigger = rigger
			rigger = null
			OL.color_r = src.light.r
			OL.color_g = src.light.g
			OL.color_b = src.light.b
			//user.put_in_hand_or_drop(OL)

			var/obj/item/light/L = W
			if(istype(L, light_type))
				light_name = L.name
				status = L.status
				boutput(user, "You insert the [L.name].")
				switchcount = L.switchcount
				rigged = L.rigged
				rigger = L.rigger
				light.set_color(L.color_r, L.color_g, L.color_b)
				user.u_equip(L)
				qdel(L)
				user.put_in_hand_or_drop(OL)
				OL.switchcount = switchcount
				switchcount = 0
				OL.update()
				on = has_power()
				update()
				if(on && rigged)
					if (rigger)
						message_admins("[key_name(rigger)]'s rigged bulb exploded in [src.loc.loc], [showCoords(src.x, src.y, src.z)].")
						logTheThing("combat", rigger, null, "'s rigged bulb exploded in [rigger.loc.loc] ([showCoords(src.x, src.y, src.z)])")
					explode()
			else
				boutput(user, "This type of light requires a [fitting].")
				return
		else
			src.add_fingerprint(user)
			var/obj/item/light/L = W
			if(istype(L, light_type))
				light_name = L.name
				status = L.status
				boutput(user, "You insert the [L.name].")
				switchcount = L.switchcount
				rigged = L.rigged
				rigger = L.rigger
				light.set_color(L.color_r, L.color_g, L.color_b)
				user.u_equip(L)
				qdel(L)

				on = has_power()
				update()
				if(on && rigged)
					if (rigger)
						message_admins("[key_name(rigger)]'s rigged bulb exploded in [src.loc.loc], [showCoords(src.x, src.y, src.z)].")
						logTheThing("combat", rigger, null, "'s rigged bulb exploded in [rigger.loc.loc] ([showCoords(src.x, src.y, src.z)])")
					explode()
			else
				boutput(user, "This type of light requires a [fitting].")
				return

		// attempt to break the light

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)


		if(prob(1+W.force * 5))

			boutput(user, "You hit the light, and it smashes!")
			for(var/mob/M in AIviewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				if(!user.bioHolder.HasEffect("resist_electric"))
					src.electrocute(user, 50, null, 20000)
			broken()


		else
			boutput(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/screwdriver))
			if (has_power())
				boutput(user, "That's not safe with the power on!")
				return
			else
				boutput(user, "You begin to unscrew the fixture from the wall...")
				playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
				if (!do_after(user, 20))
					return
				boutput(user, "You unscrew the fixture from the wall.")
				var/obj/item/light_parts/parts = new /obj/item/light_parts(get_turf(src))
				parts.copy_light(src)
				qdel(src)
				return

		boutput(user, "You stick \the [W.name] into the light socket!")
		if(has_power() && (W.flags & CONDUCT))
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(3, 1, src)
			s.start()
			if(!user.bioHolder.HasEffect("resist_electric"))
				src.electrocute(user, 75, null, 20000)


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/pow_stat = powered(LIGHT)
	if (pow_stat && wire_powered)
		return 1
	var/area/A = get_area(src)
	return A ? A.lightswitch && A.power_light : 0

// ai attack - do nothing

/obj/machinery/light/attack_ai(mob/user)
	return


// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		boutput(user, "There is no [fitting] in this light.")
		return

	// hey don't run around and steal all the emergency bolts you jerk
	if(!removable_bulb)
		boutput(user, "The bulb is firmly locked into place and cannot be removed.")
		return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))

			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves

				prot = (G.heat_transfer_coefficient < 0.5)	// *** TODO: better handling of glove heat protection
		else
			prot = 1

		if(prot > 0 || user.is_heat_resistant())
			boutput(user, "You remove the light [fitting]")
		else
			boutput(user, "You try to remove the light [fitting], but you burn your hand on it!")
			H.UpdateDamageIcon()
			H.TakeDamage(user.hand == 1 ? "l_arm" : "r_arm", 0, 5)
			H.updatehealth()
			return				// if burned, don't remove the light

	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/light/L = new light_type()
	L.name = light_name
	L.status = status
	L.rigged = rigged
	rigged = 0
	L.rigger = rigger
	rigger = null
	L.color_r = src.light.r
	L.color_g = src.light.g
	L.color_b = src.light.b
	user.put_in_hand_or_drop(L)

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0


	L.update()

	status = LIGHT_EMPTY
	update()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken()
	if(status == LIGHT_EMPTY || status == LIGHT_BROKEN)
		return

	if(status == LIGHT_OK || status == LIGHT_BURNED)
		playsound(src.loc, "sound/effects/Glasshit.ogg", 75, 1)
	if(on)
		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(3, 1, src)
		s.start()
	status = LIGHT_BROKEN
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(75))
				broken()
		if(3.0)
			if (prob(50))
				broken()
	return

//blob effect

/obj/machinery/light/blob_act(var/power)
	if(prob(power * 2.5))
		broken()


// timed process
// use power

#define LIGHTING_POWER_FACTOR 40 // Used to be 20 with the old src.brightness values (reduced drastically for the new lighting system).

/obj/machinery/light/process()
	if(on)
		..()
		var/thepower = src.brightness * LIGHTING_POWER_FACTOR
		use_power(thepower, LIGHT)
		if(rigged)
			if(prob(1))
				if (rigger)
					message_admins("[key_name(rigger)]'s rigged bulb exploded in [src.loc.loc], [showCoords(src.x, src.y, src.z)].")
					logTheThing("combat", rigger, null, "'s rigged bulb exploded in [rigger.loc.loc] ([showCoords(src.x, src.y, src.z)])")
				explode()
				rigged = 0
				rigger = null
			else if(prob(2))
				if (rigger)
					message_admins("[key_name(rigger)]'s rigged bulb tried to explode but failed in [src.loc.loc], [showCoords(src.x, src.y, src.z)].")
					logTheThing("combat", rigger, null, "'s rigged bulb tried to explode but failed in [rigger.loc.loc] ([showCoords(src.x, src.y, src.z)])")
				rigged = 0
				rigger = null
// called when area power state changes

/obj/machinery/light/power_change()
	if(src.loc) //TODO fix the dispose proc for this so that when it is sent into the delete queue it doesn't try and exec this
		var/area/A = get_area(src)
		seton(A.lightswitch && A.power_light)

// called when on fire

/obj/machinery/light/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(reagents) reagents.temperature_reagents(exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(src, T, 0, 1, 2, 2)
		sleep(1)
		qdel(src)


// special handling for emergency lights
// called when area power state changes
// override since emergency lights do not use area lightswitch

/obj/machinery/light/emergency/power_change()
	var/area/A = get_area(src)
	if (A)
		seton(!A.power_light)


// special handling for desk lamps


// if attack with hand, only "grab" attacks are an attempt to remove bulb
// otherwise, switch the lamp on/off

/obj/machinery/light/lamp/attack_hand(mob/user)

	if(user.a_intent == INTENT_GRAB)
		..()	// do standard hand attack
	else
		switchon = !switchon
		boutput(user, "You switch [switchon ? "on" : "off"] the [name].")
		seton(switchon && powered(LIGHT))

// called when area power state changes
// override since lamp does not use area lightswitch

/obj/machinery/light/lamp/power_change()
	var/area/A = get_area(src)
	seton(switchon && A.power_light)

// returns whether this lamp has power
// true if area has power and lamp switch is on

/obj/machinery/light/lamp/has_power()
	var/area/A = get_area(src)
	return switchon && A.power_light






// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	flags = FPRINT | TABLEPASS
	force = 2
	throwforce = 5
	w_class = 2
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	m_amt = 60
	var/rigged = 0		// true if rigged to explode
	var/mob/rigger = null // mob responsible
	mats = 1
	var/color_r = 1
	var/color_g = 1
	var/color_b = 1

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	g_amt = 200
	color_r = 0.95
	color_g = 0.95
	color_b = 1

	red
		name = "red light tube"
		desc = "Fancy."
		color_r = 0.95
		color_g = 0.2
		color_b = 0.2
	yellow
		name = "yellow light tube"
		desc = "Fancy."
		color_r = 0.95
		color_g = 0.95
		color_b = 0.2
	green
		name = "green light tube"
		desc = "Fancy."
		color_r = 0.2
		color_g = 0.95
		color_b = 0.2
	cyan
		name = "cyan light tube"
		desc = "Fancy."
		color_r = 0.2
		color_g = 0.95
		color_b = 0.95
	blue
		name = "blue light tube"
		desc = "Fancy."
		color_r = 0.2
		color_g = 0.2
		color_b = 0.95
	purple
		name = "purple light tube"
		desc = "Fancy."
		color_r = 0.95
		color_g = 0.2
		color_b = 0.95
	blacklight
		name = "black light tube"
		desc = "Fancy."
		icon_state = "btube" // this isn't working for some reason
		base_state = "btube"
		color_r = 0.3
		color_g = 0
		color_r = 0.9
// the smaller bulb light fixture

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	g_amt = 100
	color_r = 1
	color_g = 1
	color_b = 0.9

	red
		name = "red light bulb"
		desc = "Fancy."
		color_r = 0.95
		color_g = 0.2
		color_b = 0.2
	yellow
		name = "yellow light bulb"
		desc = "Fancy."
		color_r = 0.95
		color_g = 0.95
		color_b = 0.2
	green
		name = "green light bulb"
		desc = "Fancy."
		color_r = 0.2
		color_g = 0.95
		color_b = 0.2
	cyan
		name = "cyan light bulb"
		desc = "Fancy."
		color_r = 0.2
		color_g = 0.95
		color_b = 0.95
	blue
		name = "blue light bulb"
		desc = "Fancy."
		color_r = 0.2
		color_g = 0.2
		color_b = 0.95
	purple
		name = "purple light bulb"
		desc = "Fancy."
		color_r = 0.95
		color_g = 0.2
		color_b = 0.95
	blacklight
		name = "black light bulb"
		desc = "Fancy."
		color_r = 0.3
		color_g = 0
		color_r = 0.9
	emergency
		name = "emergency light bulb"
		desc = "A frosted red bulb."
		icon_state = "ebulb"
		base_state = "ebulb"
		color_r = 1
		color_g = 0.2
		color_b = 0.2

/obj/item/light/big_bulb
	name = "beacon bulb"
	desc = "An immense replacement light bulb."
	icon_state = "tbulb"
	base_state = "tbulb"
	item_state = "contvapour"
	g_amt = 250
	color_r = 1
	color_g = 1
	color_b = 1

// update the icon state and description of the light
/obj/item/light
	proc/update()
		switch(status)
			if(LIGHT_OK)
				icon_state = base_state
				desc = "A replacement [name]."
			if(LIGHT_BURNED)
				icon_state = "[base_state]-burned"
				desc = "A burnt-out [name]."
			if(LIGHT_BROKEN)
				icon_state = "[base_state]-broken"
				desc = "A broken [name]."


/obj/item/light/New()
	..()
	update()


// attack bulb/tube with object
// if a syringe, can inject plasma to make it explode
/obj/item/light/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I

		boutput(user, "You inject the solution into the [src].")

		if(S.reagents.has_reagent("plasma", 1))
			message_admins("[key_name(user)] rigged [src] to explode in [user.loc.loc], [showCoords(user.x, user.y, user.z)].")
			logTheThing("combat", user, null, "rigged [src] to explode in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
			rigged = 1
			rigger = user

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/light/afterattack(atom/target, mob/user)
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != "harm")
		return

	if(status == LIGHT_OK || status == LIGHT_BURNED)
		boutput(user, "The [name] shatters!")
		status = LIGHT_BROKEN
		force = 5
		playsound(src.loc, "sound/effects/Glasshit.ogg", 75, 1)
		update()

/obj/machinery/light/get_power_wire()
	if (wallmounted)
		var/obj/cable/C = null
		for (var/obj/cable/candidate in get_turf(src))
			if (candidate.d1 == dir || candidate.d2 == dir)
				C = candidate
				break
		return C
	else
		return ..()
