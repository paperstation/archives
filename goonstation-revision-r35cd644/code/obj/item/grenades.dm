/*
CONTAINS:
NON-CHEM GRENADES
GIMMICK BOMBS
BREACHING CHARGES
FIREWORKS
PIPE BOMBS + CONSTRUCTION
*/

////////////////////////////// Old-style grenades ///////////////////////////////////////

/obj/item/old_grenade
	desc = "You shouldn't be able to see this!"
	name = "old grenade"
	var/state = 0
	var/det_time = 30
	var/org_det_time = 30
	var/alt_det_time = 60
	w_class = 2.0
	icon = 'icons/obj/grenade.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	icon_state = "banana"
	item_state = "banana"
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT | EXTRADELAY
	is_syndicate = 0
	mats = 6
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 0
	var/sound_armed = null
	var/icon_state_armed = null
	var/not_in_mousetraps = 0

	attack_self(mob/user as mob)
		if (!isturf(user.loc))
			return
		if (!src.state)
			message_admins("Grenade ([src]) primed at [log_loc(src)] by [key_name(user)].")
			logTheThing("combat", user, null, "primes a grenade ([src.type]) at [log_loc(user)].")
			if (user && user.bioHolder.HasEffect("clumsy"))
				boutput(user, "<span style=\"color:red\">Huh? How does this thing work?!</span>")
				spawn(5)
					if (src) prime()
					return
			else
				boutput(user, "<span style=\"color:red\">You prime [src]! [det_time/10] seconds!</span>")
				src.state = 1
				src.icon_state = src.icon_state_armed
				playsound(src.loc, src.sound_armed, 75, 1, -3)
				src.add_fingerprint(user)
				spawn(src.det_time)
					if (src) prime()
					return
		return

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		if (get_dist(user, target) <= 1 || (!isturf(target) && !isturf(target.loc)) || !isturf(user.loc))
			return
		if (user.equipped() == src)
			if (!src.state)
				message_admins("Grenade ([src]) primed at [log_loc(src)] by [key_name(user)].")
				logTheThing("combat", user, null, "primes a grenade ([src.type]) at [log_loc(user)].")
				boutput(user, "<span style=\"color:red\">You prime [src]! [det_time/10] seconds!</span>")
				src.state = 1
				src.icon_state = src.icon_state_armed
				playsound(src.loc, src.sound_armed, 75, 1, -3)
				spawn(src.det_time)
					if (src) prime()
					return
			user.drop_item()
			src.throw_at(get_turf(target), 10, 3)
			src.add_fingerprint(user)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/screwdriver))
			if (src.det_time == src.org_det_time)
				src.det_time = src.alt_det_time
				user.show_message("<span style=\"color:blue\">You set [src] for a [det_time/10] second detonation time.</span>")
				src.desc = "It is set to detonate in [det_time/10] seconds."
			else
				src.det_time = src.org_det_time
				user.show_message("<span style=\"color:blue\">You set [src] for a [det_time/10] second detonation time.</span>")
				src.desc = "It is set to detonate in [det_time/10] seconds."
			src.add_fingerprint(user)
		return

	proc/prime() // Most grenades require a turf reference.
		var/turf/T = get_turf(src)
		if (!T || !isturf(T))
			return null
		else
			return T

/obj/item/old_grenade/banana
	desc = "It is set to detonate in 3 seconds."
	name = "banana grenade"
	det_time = 30
	org_det_time = 30
	alt_det_time = 60
	icon_state = "banana"
	item_state = "banana"
	is_syndicate = 1
	sound_armed = "sound/weapons/armbomb.ogg"
	icon_state_armed = "banana1"

	prime()
		var/turf/T = ..()
		if (T)
			playsound(T, "sound/weapons/flashbang.ogg", 25, 1)
			new /obj/item/bananapeel(T)
			for (var/i = 1; i<= 8; i= i*2)
				if (istype(get_turf(get_step(T,i)),/turf/simulated/floor))
					new /obj/item/bananapeel (get_step(T,i))
				else
					new /obj/item/bananapeel(T)
		qdel(src)
		return

/obj/item/old_grenade/gravaton
	desc = "It is set to detonate in 10 seconds."
	name = "gravaton grenade"
	det_time = 100
	org_det_time = 100
	alt_det_time = 60
	icon = 'icons/obj/device.dmi'
	icon_state = "emp"
	item_state = "emp"
	is_syndicate = 1
	mats = 12
	sound_armed = "sound/weapons/armbomb.ogg"
	icon_state_armed = "empar"

	prime()
		var/turf/T = ..()
		if (T)
			if (isrestrictedz(T.z))
				src.visible_message("<span style=\"color:red\">[src] buzzes for a moment, then self-destructs.</span>")
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(5, 1, T)
				s.start()
				qdel(src)
				return
			for (var/atom/X in orange(9, T))
				if (istype(X,/obj/machinery/containment_field))
					continue
				if (istype(X,/obj/machinery/field_generator))
					continue
				if (istype(X,/turf))
					continue
				if (!isarea(X))
					if (prob(50))
						step_towards(X,src)
		qdel(src)
		return

/obj/item/old_grenade/smoke
	desc = "It is set to detonate in 2 seconds."
	name = "smoke grenade"
	icon_state = "flashbang"
	det_time = 20.0
	org_det_time = 20
	alt_det_time = 60
	item_state = "flashbang"
	is_syndicate = 1
	sound_armed = "sound/weapons/armbomb.ogg"
	icon_state_armed = "flashbang1"
	var/datum/effects/system/bad_smoke_spread/smoke

	New()
		..()
		if (usr && usr.loc) //Wire: Fix for Cannot read null.loc
			src.smoke = new /datum/effects/system/bad_smoke_spread/
			src.smoke.attach(src)
			src.smoke.set_up(10, 0, usr.loc)

	prime()
		var/turf/T = ..()
		if (T)
			var/obj/item/old_grenade/smoke/mustard/M = null
			if (istype(src, /obj/item/old_grenade/smoke/mustard))
				M = src
			playsound(T, "sound/effects/smoke.ogg", 50, 1, -3)

			spawn (0)
				if (src)
					if (M && istype(M, /obj/item/old_grenade/smoke/mustard))
						M.mustard_gas.start()
					else
						src.smoke.start()

					sleep(10)
					if (M && istype(M, /obj/item/old_grenade/smoke/mustard))
						M.mustard_gas.start()
					else
						src.smoke.start()

					sleep(10)
					if (M && istype(M, /obj/item/old_grenade/smoke/mustard))
						M.mustard_gas.start()
					else
						src.smoke.start()

					sleep(10)
					if (M && istype(M, /obj/item/old_grenade/smoke/mustard))
						M.mustard_gas.start()
					else
						src.smoke.start()

					if (M && istype(M, /obj/item/old_grenade/smoke/mustard))
						qdel(M)
					else
						qdel(src)
		else
			qdel(src)
		return

/obj/item/old_grenade/smoke/mustard
	name = "mustard gas grenade"
	var/datum/effects/system/mustard_gas_spread/mustard_gas

	New()
		..()
		if (usr && usr.loc) //Wire: Fix for Cannot read null.loc
			src.mustard_gas = new /datum/effects/system/mustard_gas_spread/
			src.mustard_gas.attach(src)
			src.mustard_gas.set_up(5, 0, usr.loc)

/obj/item/old_grenade/sonic
	name = "sonic grenade"
	desc = "It is set to detonate in 3 seconds."
	icon_state = "flashbang"
	det_time = 30.0
	org_det_time = 30
	alt_det_time = 60
	item_state = "flashbang"
	is_syndicate = 1
	sound_armed = "sound/effects/screech.ogg"
	icon_state_armed = "flashbang1"

	prime()
		var/turf/T = ..()
		if (T)
			if (isrestrictedz(T.z) && !restricted_z_allowed(usr, T))
				src.visible_message("<span style=\"color:red\">[src] buzzes for a moment, then self-destructs.</span>")
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(5, 1, T)
				s.start()
				qdel(src)
				return

			playsound(T, "sound/weapons/flashbang.ogg", 25, 1)

			for (var/mob/living/M in hearers(8, T))
				var/loud = 16 / (get_dist(M, T) + 1)
				if (src.loc == M.loc || src.loc == M)
					loud = 16

				var/weak = loud / 3
				var/stun = loud
				var/damage = loud * 2
				var/tempdeaf = loud * 3

				M.apply_sonic_stun(weak, stun, 0, 0, 0, damage, tempdeaf)

			sonic_attack_environmental_effect(T, 8, list("window", "r_window", "displaycase", "glassware"))

		qdel(src)
		return

/obj/item/old_grenade/emp
	desc = "It is set to detonate in 5 seconds."
	name = "emp grenade"
	det_time = 50.0
	org_det_time = 50
	alt_det_time = 30
	icon = 'icons/obj/device.dmi'
	icon_state = "emp"
	item_state = "emp"
	is_syndicate = 1
	sound_armed = "sound/weapons/armbomb.ogg"
	icon_state_armed = "empar"

	prime()
		var/turf/T = ..()
		if (T)
			playsound(T, "sound/items/Welder2.ogg", 25, 1)
			T.hotspot_expose(700,125)

			var/grenade = src // detaching the proc - in theory
			src = null

			var/obj/overlay/pulse = new/obj/overlay(T)
			pulse.icon = 'icons/effects/effects.dmi'
			pulse.icon_state = "emppulse"
			pulse.name = "emp pulse"
			pulse.anchored = 1
			spawn (20)
				if (pulse) qdel(pulse)

			for (var/turf/tile in range(world.view-1, T))
				for (var/atom/O in tile.contents)
					O.emp_act()

			qdel(grenade)
		else
			qdel(src)
		return

/obj/item/old_grenade/moustache
	name = "moustache grenade"
	desc = "It is set to detonate in 3 seconds."
	det_time = 30.0
	org_det_time = 30
	alt_det_time = 60
	icon_state = "flashbang"
	item_state = "flashbang"
	is_syndicate = 1
	sound_armed = "sound/weapons/armbomb.ogg"
	icon_state_armed = "flashbang1"

	prime()
		var/turf/T = ..()
		if (T)
			for (var/mob/living/carbon/human/M in range(5, T))
				if (!(M.wear_mask && istype(M.wear_mask, /obj/item/clothing/mask/moustache)))
					for (var/obj/item/clothing/O in M)
						if (istype(O,/obj/item/clothing/mask))
							M.u_equip(O)
							if (O)
								O.set_loc(M.loc)
								O.dropped(M)
								O.layer = initial(O.layer)

					var/obj/item/clothing/mask/moustache/moustache = new /obj/item/clothing/mask/moustache(M)
					moustache.cant_self_remove = 1
					moustache.cant_other_remove = 1

					M.equip_if_possible(moustache, M.slot_wear_mask)
					M.set_clothing_icon_dirty()

			playsound(T, 'sound/effects/Explosion2.ogg', 100, 1)
			var/obj/effects/explosion/E = new /obj/effects/explosion(T)
			E.fingerprintslast = src.fingerprintslast

		qdel(src)
		return

/obj/item/old_grenade/light_gimmick
	name = "light grenade"
	icon_state = "lightgrenade"
	icon = 'icons/obj/weapons.dmi'
	desc = "It's a small cast-iron egg-shaped object, with the words \"Pick Me Up\" in gold in it."
	state = 0
	not_in_mousetraps = 1

	primed
		state = 1

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (get_dist(user, target) <= 1 || (!isturf(target) && !isturf(target.loc)) || !isturf(user.loc))
			return
		if (istype(target, /obj/item/storage)) return ..()
		if (src.state == 0)
			message_admins("Grenade ([src]) primed in [get_area(src)] [log_loc(src)] by [key_name(user)].")
			logTheThing("combat", user, null, "primes a grenade ([src.type]) at [log_loc(user)].")
			boutput(user, "<span style=\"color:red\">You pull the pin on [src]. You're not sure what that did, but you throw it anyway.</span>")
			src.state = 1
			src.add_fingerprint(user)
			user.drop_item()
			src.throw_at(get_turf(target), 10, 3)
		return

	attack_self(mob/user as mob)
		if (!isturf(user.loc))
			return
		if (src.state == 0)
			message_admins("Grenade ([src]) primed in [get_area(src)] [log_loc(src)] by [key_name(user)].")
			logTheThing("combat", user, null, "primes a grenade ([src.type]) at [log_loc(user)].")
			boutput(user, "<span style=\"color:red\">You pull the pin on [src]. You're not sure what that did. Maybe you should throw it?</span>")
			src.state = 1
		return

	attack_hand(mob/user as mob)
		if (src.state == 0)
			..()
		else
			spawn (1)
				playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)
				for (var/obj/item/W in user)
					if (istype(W,/obj/item/clothing))
						user.u_equip(W)
						if (W)
							W.set_loc(user.loc)
							W.dropped(user)
							W.layer = initial(user.layer)
					else if (istype(W,/obj/item/old_grenade/light_gimmick))
						user.u_equip(W)
						if (W)
							W.set_loc(user.loc)
							W.dropped(user)
							W.layer = HUD_LAYER
					else
						qdel(W)
				for (var/mob/N in viewers(user, null))
					if (get_dist(N, user) <= 6)
						N.flash(30)
				spawn(2)
					random_brute_damage(user, 200)
					spawn(1)
						logTheThing("combat", user, null, "was killed by touching a [src] at [log_loc(src)].")
						var/mob/dead/observer/newmob
						newmob = new/mob/dead/observer(user)
						user.client.mob = newmob
						user.mind.transfer_to(newmob)
						qdel(user)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return

////////////////////////// Gimmick bombs /////////////////////////////////

/obj/item/gimmickbomb/
	name = "Don't spawn this directly!"
	icon = 'icons/obj/grenade.dmi'
	icon_state = ""
	var/armed = 0
	var/sound_explode = 'sound/effects/Explosion2.ogg'
	var/sound_beep = 'sound/machines/twobeep.ogg'

	proc/detonate()
		playsound(src.loc, sound_explode, 100, 1)

		var/obj/effects/explosion/E = new /obj/effects/explosion(src.loc)
		E.fingerprintslast = src.fingerprintslast

		invisibility = 100
		spawn(150)
			qdel (src)

	proc/beep(i)
		var/k = i/2
		sleep(k*k)
		flick(icon_state+"_beep", src)
		src.playbeep(src.loc, i, src.sound_beep)
		if(i>=0)
			src.beep(i-1)
		else
			src.detonate()

	proc/arm(mob/usr as mob)
		usr.show_message("<span style=\"color:red\"><B>You have armed the [src.name]!</span>")
		for(var/mob/O in viewers(usr))
			if (O.client)
				O.show_message("<span style=\"color:red\"><B>[usr] has armed the [src.name]! Run!</B></span>", 1)

		spawn(0)
			src.beep(10)

	proc/playbeep(var/atom/source, i as num, sound)
		var/soundin = sound
		var/vol = 100

		var/sound/S = sound(soundin)
		S.frequency = 32000 + ((10-i)*4000)
		S.wait = 0 //No queue
		S.channel = 0 //Any channel
		S.volume = vol
		S.priority = 0

		for (var/mob/M in range(world.view, source))
			if (M.client)
				if(isturf(source))
					var/dx = source.x - M.x
					S.pan = max(-100, min(100, dx/8.0 * 100))
				M << S

	attack_self(mob/user as mob)
		if (usr.equipped() == src && !armed)
			src.arm(usr)
			armed = 1

/obj/item/gimmickbomb/owlgib
	name = "Owl Bomb"
	desc = "Owls. Owls everywhere"
	icon_state = "owlbomb"
	sound_beep = 'sound/misc/hoot.ogg'

	detonate()
		for(var/mob/living/carbon/human/M in range(5, src))
			spawn(0)
				M.owlgib()
		..()

/obj/item/gimmickbomb/owlclothes
	name = "Owl Bomb"
	desc = "Owls. Owls everywhere"
	icon_state = "owlbomb"
	sound_beep = 'sound/misc/hoot.ogg'

	detonate()
		for(var/mob/living/carbon/human/M in range(5, src))
			spawn(0)
				if (!(M.wear_mask && istype(M.wear_mask, /obj/item/clothing/mask/owl_mask)))
					for(var/obj/item/clothing/O in M)
						M.u_equip(O)
						if (O)
							O.set_loc(M.loc)
							O.dropped(M)
							O.layer = initial(O.layer)

					var/obj/item/clothing/under/gimmick/owl/owlsuit = new /obj/item/clothing/under/gimmick/owl(M)
					owlsuit.cant_self_remove = 1
					var/obj/item/clothing/mask/owl_mask/owlmask = new /obj/item/clothing/mask/owl_mask(M)
					owlmask.cant_self_remove = 1


					M.equip_if_possible(owlsuit, M.slot_w_uniform)
					M.equip_if_possible(owlmask, M.slot_wear_mask)
					M.set_clothing_icon_dirty()
		..()

/obj/item/gimmickbomb/butt
	name = "Butt Bomb"
	desc = "What a crappy grenade."
	icon_state = "fartbomb"
	sound_beep = 'sound/misc/poo2.ogg'
	sound_explode = 'sound/misc/superfart.ogg'

/obj/item/gimmickbomb/butt/prearmed
	armed = 1
	anchored = 1

	New()
		spawn(0)
			src.beep(10)
		return ..()

/obj/item/gimmickbomb/owlgib/prearmed
	armed = 1
	anchored = 1

	New()
		spawn(0)
			src.beep(10)
		return ..()

/obj/item/gimmickbomb/owlclothes/prearmed
	armed = 1
	anchored = 1

	New()
		spawn(0)
			src.beep(10)
		return ..()

/////////////////////////////// Fireworks ///////////////////////////////////////

/obj/item/firework
	name = "firework"
	desc = "BOOM!"
	icon = 'icons/obj/items.dmi'
	icon_state = "firework"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/det_time = 20
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 5

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (user.equipped() == src)
			if (user.bioHolder.HasEffect("clumsy"))
				boutput(user, "<span style=\"color:red\">Huh? How does this thing work?!</span>")
				spawn( 5 )
					boom()
					return
			else
				boutput(user, "<span style=\"color:red\">You prime the firework! [det_time/10] seconds!</span>")
				spawn( src.det_time )
					boom()
					return

	proc/boom()
		var/turf/location = get_turf(src.loc)
		if(location)
			if(prob(10))
				explosion(src, location, 0, 0, 1, 1)
			else
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(5, 1, src)
				s.start()
				playsound(src.loc, "sound/effects/Explosion1.ogg", 75, 1)
		src.visible_message("<span style=\"color:red\">The [src] explodes!</span>")

		qdel(src)

	attack_self(mob/user as mob)
		if (user.equipped() == src)
			if (user.bioHolder.HasEffect("clumsy"))
				boutput(user, "<span style=\"color:red\">Huh? How does this thing work?!</span>")
				spawn( 5 )
					boom()
					return
			else
				boutput(user, "<span style=\"color:red\">You prime the firework! [det_time/10] seconds!</span>")
				spawn( src.det_time )
					boom()
					return

//////////////////////// Breaching charges //////////////////////////////////

/obj/item/breaching_charge
	desc = "It is set to detonate in 5 seconds."
	name = "Breaching Charge"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "bcharge"
	var/state = null
	var/det_time = 50.0
	w_class = 2.0
	item_state = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	var/expl_devas = 0
	var/expl_heavy = 0
	var/expl_light = 1
	var/expl_flash = 2
	var/expl_range = 1
	desc = "A timed device that releases a relatively strong concussive force, strong enough to destroy rock and metal."
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 0

	attack_hand(var/mob/user)
		if (src.state)
			boutput(user, "<span style=\"color:red\">\The [src] is firmly anchored into place!</span>")
			return
		return ..()

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (user.equipped() == src)
			if (!src.state)
				if (user.bioHolder && user.bioHolder.HasEffect("clumsy"))
					boutput(user, "<span style=\"color:red\">Huh? How does this thing work?!</span>")
					logTheThing("combat", user, null, "accidentally triggers [src] (clumsy bioeffect) at [log_loc(user)].")
					spawn (5)
						user.u_equip(src)
						src.boom()
						return
				else
					boutput(user, "<span style=\"color:red\">You slap the charge on [target], [det_time/10] seconds!</span>")
					user.visible_message("<span style=\"color:red\">[user] has attached [src] to [target].</span>")
					src.icon_state = "bcharge2"
					user.u_equip(src)
					src.set_loc(get_turf(target))
					src.anchored = 1
					src.state = 1

					// Yes, please (Convair880).
					logTheThing("combat", user, null, "attaches a [src] to [target] at [log_loc(target)].")

					spawn (src.det_time)
						if (src)
							src.boom()
							if (target)
								if (istype(target, /obj/machinery))
									target.ex_act(1) // Reliably blasts through doors.
						return
		return

	proc/boom()
		if (!src || !istype(src))
			return

		var/turf/location = get_turf(src)
		if (location && istype(location))
			if (isrestrictedz(location.z))
				src.visible_message("<span style=\"color:red\">[src] buzzes for a moment, then self-destructs.</span>")
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(5, 1, location)
				s.start()
				qdel(src)
				return

			location.hotspot_expose(700, 125)

			explosion(src, location, src.expl_devas, src.expl_heavy, src.expl_light, src.expl_flash)

			// Breaching charges should be, you know, actually be decent at breaching walls and windows (Convair880).
			for (var/turf/simulated/wall/W in range(src.expl_range, location))
				if (W && istype(W))
					W.ReplaceWithFloor()
			for (var/obj/structure/girder/G in range(src.expl_range, location))
				if (G && istype(G))
					qdel(G)
			for (var/obj/window/WD in range(src.expl_range, location))
				if (WD && istype(WD) && prob(max(0, 100 - (WD.health / 3))))
					WD.smash()
			for (var/obj/grille/GR in range(src.expl_range, location))
				if (GR && istype(GR) && GR.ruined != 1)
					GR.ex_act(2)

		qdel(src)
		return

/obj/item/breaching_charge/NT
	name = "NanoTrasen Experimental EDF-7 Breaching Charge"
	expl_devas = 0
	expl_heavy = 1
	expl_light = 4
	expl_flash = 10
	expl_range = 2
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 0

/obj/item/breaching_charge/thermite
	name = "Thermite Breaching Charge"
	desc = "When applied to a wall, causes a thermite reaction which totally destroys it."
	flags = ONBELT
	w_class = 1
	expl_range = 2

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (user.equipped() == src)
			if (!src.state)
				if (user.bioHolder && user.bioHolder.HasEffect("clumsy"))
					boutput(user, "<span style=\"color:red\">Huh? How does this thing work?!</span>")
					logTheThing("combat", user, null, "accidentally triggers [src] (clumsy bioeffect) at [log_loc(user)].")
					spawn (5)
						user.u_equip(src)
						src.boom()
						return
				else
					boutput(user, "<span style=\"color:red\">You slap the charge on [target], [det_time/10] seconds!</span>")
					user.visible_message("<span style=\"color:red\">[user] has attached [src] to [target].</span>")
					src.icon_state = "bcharge2"
					user.u_equip(src)
					src.set_loc(get_turf(target))
					src.anchored = 1
					src.state = 1

					// Yes, please (Convair880).
					logTheThing("combat", user, null, "attaches a [src] to [target] at [log_loc(target)].")

					spawn (src.det_time)
						if (src)
							src.boom()
		return

	boom()
		if (!src || !istype(src))
			return

		var/turf/location = get_turf(src.loc)
		if (location && istype(location))
			if (isrestrictedz(location.z))
				src.visible_message("<span style=\"color:red\">[src] buzzes for a moment, then self-destructs.</span>")
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(5, 1, location)
				s.start()
				qdel(src)
				return

			playsound(location, "sound/effects/bamf.ogg", 50, 1)
			src.invisibility = 101

			for (var/turf/T in range(src.expl_range, location))
				if (!istype(T, /turf/simulated/wall) && !istype(T, /turf/simulated/floor))
					continue

				T.hotspot_expose(2000, 125)

				var/obj/overlay/O = new/obj/overlay(T)
				O.name = "Thermite"
				O.desc = "A searing wall of flames."
				O.icon = 'icons/effects/fire.dmi'
				O.anchored = 1
				O.layer = TURF_EFFECTS_LAYER
				O.color = "#ff9a3a"
				var/datum/light/point/light = new
				light.set_brightness(1)
				light.set_color(0.5, 0.3, 0.0)
				light.attach(O)

				if (istype(T,/turf/simulated/wall))
					O.density = 1
				else
					O.density = 0

				var/distance = get_dist(T, location)
				if (distance < 2)
					var/turf/simulated/floor/F = null

					if (istype(T, /turf/simulated/wall))
						var/turf/simulated/wall/W = T
						F = W.ReplaceWithFloor()
					else if (istype(T, /turf/simulated/floor/))
						F = T

					if (F && istype(F))
						F.to_plating()
						F.burn_tile()
						O.icon_state = "2"
				else
					O.icon_state = "1"
					if (istype(T, /turf/simulated/floor))
						var/turf/simulated/floor/F = T
						F.burn_tile()

			for (var/obj/structure/girder/G in range(src.expl_range, location))
				if (G && istype(G))
					qdel(G)
			for (var/obj/window/W in range(src.expl_range, location))
				if (W && istype(W))
					W.damage_heat(500)
			for (var/obj/grille/GR in range(src.expl_range, location))
				if (GR && istype(GR) && GR.ruined != 1)
					GR.damage_heat(500)

			for (var/mob/living/M in range(src.expl_range, location))
				var/damage = 30 / (get_dist(M, src) + 1)
				M.TakeDamage("chest", 0, damage)
				M.update_burning(damage)
				M.updatehealth()

			spawn (100)
				if (src)
					for (var/obj/overlay/O in range(src.expl_range, location))
						if (O.name == "Thermite")
							qdel(O)
					qdel(src)
		else
			qdel(src)

		return

//////////////////////////////////////////
// PIPE BOMBS (INCLUDES CONSTRUCTION)
//////////////////////////////////////////

/obj/item/pipebomb
	icon = 'icons/obj/assemblies.dmi'
	item_state = "r_hands"

/obj/item/pipebomb/frame
	name = "pipe frame"
	desc = "Two small pipes joined together with grooves cut into the side."
	icon_state = "Pipe_Frame"
	burn_possible = 0
	var/state = 1
	var/strength = 5

	attackby(obj/item/W, mob/user)
		if(istype(W, /obj/item/weldingtool) && state == 1)
			if(W:welding == 1)
				W:eyecheck(user)

				if (W:get_fuel() < 1)
					boutput(user, "<span style=\"color:blue\">You need more welding fuel to complete this task.</span>")
					return
				W:use_fuel(1)
				boutput(user, "<span style=\"color:blue\">You hollow out the pipe.</span>")
				src.state = 2
				icon_state = "Pipe_Hollow"
				desc = "Two small pipes joined together. The pipes are empty."

				if (material)
					name = "hollow [src.material.name] pipe frame"
				else
					name = "hollow pipe frame"


		if(istype(W, /obj/item/reagent_containers/) && state == 2)
			boutput(user, "<span style=\"color:blue\">You fill the pipe with 20 units of the reagents.</span>")
			src.state = 3
			var/avg_volatility = 0
			src.reagents = new /datum/reagents(20)
			src.reagents.my_atom = src
			W.reagents.trans_to(src, 20)
			for (var/id in src.reagents.reagent_list)
				var/datum/reagent/R = src.reagents.reagent_list[id]
				avg_volatility += R.volatility * R.volume / src.reagents.total_volume

			qdel(src.reagents)
			if (avg_volatility < 1) // B A D.
				src.strength = 0
			else
				src.strength *= avg_volatility

			icon_state = "Pipe_Filled"
			src.state = 3
			desc = "Two small pipes joined together. The pipes are filled."

			if (material)
				name = "filled [src.material.name] pipe frame"
			else
				name = "filled pipe frame"

		if(istype(W, /obj/item/cable_coil) && state == 3)
			boutput(user, "<span style=\"color:blue\">You link the cable, fuel and pipes.</span>")
			src.state = 4
			icon_state = "Pipe_Wired"

			if (material)
				name = "[src.material.name] pipe bomb frame"
			else
				name = "pipe bomb frame"

			desc = "Two small pipes joined together, filled with welding fuel and connected with a cable. It needs some kind of ignition switch."

		if(istype(W, /obj/item/assembly/time_ignite) && state == 4)
			boutput(user, "<span style=\"color:blue\">You connect the cable to the timer/igniter assembly.</span>")
			var/turf/T = get_turf(src)
			var/obj/item/pipebomb/bomb/A = new /obj/item/pipebomb/bomb(T)
			A.strength = src.strength
			if (material)
				A.setMaterial(src.material)
				src.material = null
			user.u_equip(W)
			qdel(W)
			qdel(src)
		else
			..()
			return

/obj/item/pipebomb/bomb
	name = "pipe bomb"
	desc = "An improvised explosive made primarily out of two pipes."
	icon_state = "Pipe_Timed"
	var/strength = 5
	var/armed = 0

	attack_self(mob/user as mob)
		if (armed)
			return
		boutput(user, "<span style=\"color:red\">You activate the pipe bomb! 5 seconds!</span>")
		armed = 1
		message_admins("[key_name(user)] arms a pipe bomb (power [strength]) in [user.loc.loc], [showCoords(user.x, user.y, user.z)].")
		logTheThing("combat", user, null, "arms a pipe bomb (power [strength]) in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
		spawn(50)
			do_explode()

	proc/do_explode()
		if (src.strength)
			if (src.material)
				var/strength_mult = 1
				if (findtext(material.mat_id, "erebite"))
					strength_mult = 2
				else if (findtext(material.mat_id, "plasmastone"))
					strength_mult = 1.25
				src.strength *= strength_mult
			src.blowthefuckup(src.strength)
		else
			visible_message("<span style=\"color:red\">[src] sparks and emits a small cloud of smoke, crumbling into a pile of dust.</span>")
			qdel(src)

/obj/item/pipebomb/bomb/syndicate
	name = "pipe bomb"
	desc = "An improvised explosive made primarily out of two pipes." // cogwerks - changed the name
	icon_state = "Pipe_Timed"
	strength = 32

/obj/proc/on_blowthefuckup(strength)
	if (src.material)
		src.material.triggerTemp(src, T0C + strength * 100)
		src.material.triggerExp(src, 1)

/obj/item/pipebomb/bomb/on_blowthefuckup(strength)
	..()

/obj/proc/blowthefuckup(var/strength = 1) // dropping this to object-level so that I can use it for other things
	var/T = get_turf(src)
	src.visible_message("<span style=\"color:red\">[src] explodes!</span>")
	var/sqstrength = sqrt(strength)
	var/shrapnel_range = 3 + sqstrength
	for (var/mob/living/carbon/human/M in view(T, shrapnel_range))
		if (istype(M.wear_suit, /obj/item/clothing/suit/armor))
			boutput(M, "<span style=\"color:red\"><b>Your armor blocks the shrapnel!</b></span>")
			M.TakeDamage("chest", 10, 0)
		else
			M.TakeDamage("chest", 15, 0)
			var/obj/item/implant/projectile/shrapnel/implanted = new /obj/item/implant/projectile/shrapnel(M)
			implanted.owner = M
			M.implant += implanted
			implanted.implanted(M, null, 25 * sqstrength)
			boutput(M, "<span style=\"color:red\"><b>You are struck by shrapnel!</b></span>")
			if (!M.stat)
				M.emote("scream")

	on_blowthefuckup(strength)

	explosion_new(src, T, strength, 1)
	qdel(src)

/mob/proc/blowthefuckup(var/strength = 1,var/visible_message = 1) // similar proc for mobs
	var/T = get_turf(src)
	if(visible_message) src.visible_message("<span style=\"color:red\">[src] explodes!</span>")
	var/sqstrength = sqrt(strength)
	var/shrapnel_range = 3 + sqstrength
	for (var/mob/living/carbon/human/M in view(T, shrapnel_range))
		if (M != src && istype(M.wear_suit, /obj/item/clothing/suit/armor))
			boutput(M, "<span style=\"color:red\"><b>Your armor blocks the chunks of [src.name]!</b></span>")
			M.TakeDamage("chest", 10, 0)
		else if(M != src)
			M.TakeDamage("chest", 15, 0)
			var/obj/item/implant/projectile/shrapnel/implanted = new /obj/item/implant/projectile/shrapnel(M)
			implanted.owner = M
			M.implant += implanted
			implanted.implanted(M, null, 25 * sqstrength)
			boutput(M, "<span style=\"color:red\"><b>You are struck by chunks of [src.name]!</b></span>")
			if (!M.stat)
				M.emote("scream")

	explosion_new(src, T, strength, 1)
	src.gib()