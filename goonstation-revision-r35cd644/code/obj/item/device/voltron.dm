/obj/dummy/voltron
	icon = null
	name = "Sparks"
	desc = "Dangerous looking sparks."
	anchored = 1
	density = 0
	opacity = 0
	var/can_move = 1
	var/speed = 1
	var/image/img = null
	var/list/cableimgs = new/list()
	var/mob/the_user = null
	//Prolonged use causes damage.
	New(mob/target, atom/location)
		src.set_loc(location)
		the_user = target
		target.set_loc(src)
		img = image('icons/effects/effects.dmi',src ,"energyorb")
		target << img
		spawn(0) check()

	remove_air(amount as num)
		var/datum/gas_mixture/Air = unpool(/datum/gas_mixture)
		Air.oxygen = amount
		Air.temperature = 310
		return Air

	proc/spawn_sparks()
		spawn(0)
			// Check spawn limits
			if(limiter.canISpawn(/obj/effects/sparks))
				var/obj/effects/sparks/O = unpool(/obj/effects/sparks)
				O.set_loc(src.loc)
				spawn(20) if (O) pool(O)

	relaymove(mob/user, direction)

		var/turf/new_loc = get_step(src, direction)

		if(can_move)
			var/list/allowed = new/list()

			for(var/obj/cable/C in src.loc)
				allowed += C.d1
				allowed += C.d2

			if(direction in allowed)

				if(!locate(/obj/cable) in new_loc) return

				if (prob(10)) spawn_sparks()

				src.set_loc(new_loc)
				can_move = 0
				spawn(speed) can_move = 1
		return

	disposing()
		the_user.client.images -= cableimgs
		the_user = null
		return ..()

	proc/check()

		while (!disposed)

			for(var/obj/item/I in src)
				I.set_loc(src.loc)

			the_user.client.images -= cableimgs

			cableimgs.Cut()
			for(var/obj/cable/C in range(3, src.loc))
				cableimgs += C.cableimg

			the_user.client.images += cableimgs

			sleep(10)

/obj/item/device/voltron
	name = "Voltron"
	desc = "Converts matter into energy and back. Needs to be used while standing on a cable."
	icon = 'icons/obj/device.dmi'
	icon_state = "voltron"
	item_state = "electronic"
	var/active = 0
	var/mob/target = null
	var/obj/dummy/voltron/D = null
	var/activating = 0
	var/on_cooldown = 0
	var/power = 100
	var/power_icon = ""
	module_research = list("devices" = 5, "energy" = 20, "miniaturization" = 20)

	New()
		handle_overlay()
		spawn(0)
			check()
		return ..()

	pickup()
		power_icon = ""
		handle_overlay()
		return ..()

	dropped()
		power_icon = ""
		handle_overlay()
		if(active)
			src.set_loc(get_turf(target))
			deactivate()
		return ..()

	proc/handle_overlay()
		var/rebuild_overlay = 0
		switch(power)
			if(0 to 20)
				if(power_icon != "volt1")
					power_icon = "volt1"
					rebuild_overlay = 1
			if(21 to 40)
				if(power_icon != "volt2")
					power_icon = "volt2"
					rebuild_overlay = 1
			if(41 to 60)
				if(power_icon != "volt3")
					power_icon = "volt3"
					rebuild_overlay = 1
			if(61 to 80)
				if(power_icon != "volt4")
					power_icon = "volt4"
					rebuild_overlay = 1
			if(81 to 100)
				if(power_icon != "volt5")
					power_icon = "volt5"
					rebuild_overlay = 1

		if(rebuild_overlay)
			overlays.Cut()
			overlays += image('icons/obj/device.dmi',src,power_icon)

	proc/check()
		while (!disposed)
			if(!active)
				if(power < 100) power += 0.35
				handle_overlay()
				sleep(10)
			else
				power = round(power)
				power--
				handle_overlay()
				if(power == 20)
					boutput(target, "<span style=\"color:red\">The [src] is dangerously low on power. Your energy pattern is destabilizing.</span>")
				if(power < 20)
					random_brute_damage(target, 4)
					target.updatehealth()
				if(power <= 0)
					boutput(target, "<span style=\"color:red\">The [src] is out of energy.</span>")
					var/mob/old_trg = target
					deactivate()
					old_trg.stunned = 20
				sleep(10)

	proc/deactivate()
		if(activating) return

		activating = 1

		on_cooldown = 1
		spawn(30) on_cooldown = 0

		var/atom/dummy = target.loc
		dummy.invisibility = 101

		playsound(src, "sound/effects/shielddown2.ogg", 40, 1)
		var/obj/overlay/O = new/obj/overlay(get_turf(target))
		O.name = "Energy"
		O.anchored = 1
		O.layer = MOB_EFFECT_LAYER
		target.transforming = 1
		O.icon = 'icons/effects/effects.dmi'
		O.icon_state = "energytwirlout"
		sleep(5)
		target.transforming = 0
		qdel(O)

		target.set_loc(get_turf(target))
		qdel(dummy)
		active = 0
		target = null
		activating = 0

	proc/activate()
		if(activating) return
		if(locate(/obj/cable) in get_turf(src))

			if(on_cooldown)
				boutput(usr, "<span style=\"color:red\">The [src] is still recharging.</span>")
				return

			activating = 1

			playsound(src, "sound/effects/singsuck.ogg", 40, 1)
			var/obj/overlay/O = new/obj/overlay(get_turf(usr))
			O.name = "Energy"
			O.anchored = 1
			O.layer = MOB_EFFECT_LAYER
			usr:transforming = 1
			O.icon = 'icons/effects/effects.dmi'
			O.icon_state = "energytwirlin"
			sleep(5)
			usr:transforming = 0
			qdel(O)

			D = new/obj/dummy/voltron(usr, get_turf(src))
			target = usr
			active = 1
			activating = 0
		else
			boutput(usr, "<span style=\"color:red\">This needs to be used while standing on a cable.</span>")

	attack_self(mob/user as mob)
		if(activating) return

		if(active)
			boutput(target, "<span style=\"color:blue\">You deactivate the [src].</span>")
			deactivate()
		else
			boutput(user, "<span style=\"color:blue\">You activate the [src].</span>")
			activate()
			power -= 5
			handle_overlay()
		return
