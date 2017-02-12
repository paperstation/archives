/**
 * Limb datums for arms. Describes all activity performed by the limb.
 * Currently, this is basically attack_hand().
 *
 * Also serves as a future holder for any other special limb activity.
 */

/datum/limb
	var/obj/item/parts/holder = null

	New(var/obj/item/parts/holder)
		src.holder = holder

	// !!CAUTION!! it is allowed to delete the target here
	// Mob is also passed as a convenience/redundancy.
	proc/attack_hand(atom/target, var/mob/user, var/reach)
		target.attack_hand(user)

	proc/harm(mob/living/carbon/human/target, var/mob/living/user)
		user.melee_attack_normal(target, 0, 0, DAMAGE_BLUNT)

	proc/help(mob/living/carbon/human/target, var/mob/living/user)
		user.do_help(target)

	proc/disarm(mob/living/carbon/human/target, var/mob/living/user)
		user.disarm(target)

	proc/grab(mob/living/carbon/human/target, var/mob/living/user)
		user.grab_other(target)

	proc/attack_range(atom/target, var/mob/user, params)
		return

	proc/is_on_cooldown()
		return 0

/datum/limb/hitscan
	var/brute = 5
	var/burn = 0
	var/cooldown = 30
	var/next_shot_at = 0
	var/image/default_obscurer

	attack_range(atom/target, var/mob/user, params)
		if (next_shot_at > ticker.round_elapsed_ticks)
			return
		user.visible_message("<b style='color:red'>[user] fires at [target] with the [holder.name]!</b>")
		playsound(user.loc, "sound/weapons/lasermed.ogg", 100, 1)
		next_shot_at = ticker.round_elapsed_ticks + cooldown
		if (ismob(target))
			var/mob/MT = target
			if (prob(30))
				user.visible_message("<span style='color:red'>The shot misses!</span>")
			else
				MT.TakeDamageAccountArmor(user.zone_sel ? user.zone_sel.selecting : "All", brute, burn, 0, burn ? DAMAGE_BURN : DAMAGE_BLUNT)
		spawn
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(3, 1, target)
			s.start()

	is_on_cooldown()
		if (ticker.round_elapsed_ticks < next_shot_at)
			return next_shot_at - ticker.round_elapsed_ticks
		return 0

/datum/limb/railgun
	var/cooldown = 50
	var/next_shot_at = 0
	var/image/default_obscurer
	is_on_cooldown()
		if (ticker.round_elapsed_ticks < next_shot_at)
			return next_shot_at - ticker.round_elapsed_ticks
		return 0

	attack_range(atom/target, var/mob/user, params)
		var/turf/start = user.loc
		if (!isturf(start))
			return
		target = get_turf(target)
		if (!target)
			return
		if (target == start)
			return
		if (next_shot_at > ticker.round_elapsed_ticks)
			return
		next_shot_at = ticker.round_elapsed_ticks + cooldown

		playsound(user, "sound/effects/mag_warp.ogg", 50, 1)
		spawn(rand(1,3)) // so it might miss, sometimes, maybe
			var/obj/target_r = new/obj/railgun_trg_dummy(target)

			playsound(user, "sound/weapons/railgun.ogg", 50, 1)
			user.dir = get_dir(user, target)

			var/list/affected = DrawLine(user, target_r, /obj/line_obj/railgun ,'icons/obj/projectiles.dmi',"WholeRailG",1,1,"HalfStartRailG","HalfEndRailG",OBJ_LAYER,1)

			for(var/obj/O in affected)
				O.anchored = 1 //Proc wont spawn the right object type so lets do that here.
				O.name = "Energy"
				var/turf/src_turf = O.loc
				for(var/obj/machinery/vehicle/A in src_turf)
					if(A == O || A == user) continue
					A.meteorhit(O)
				for(var/mob/living/M in src_turf)
					if(M == O || M == user) continue
					M.meteorhit(O)
				for(var/turf/T in src_turf)
					if(T == O) continue
					T.meteorhit(O)
				for(var/obj/machinery/colosseum_putt/A in src_turf)
					if (A == O || A == user) continue
					A.meteorhit(O)

			sleep(3)
			for (var/obj/O in affected)
				pool(O)

			if(istype(target_r, /obj/railgun_trg_dummy)) qdel(target_r)

/datum/limb/arcflash
	var/wattage = 15000
	var/cooldown = 60
	var/next_shot_at = 0
	var/image/default_obscurer
	is_on_cooldown()
		if (ticker.round_elapsed_ticks < next_shot_at)
			return next_shot_at - ticker.round_elapsed_ticks
		return 0

	attack_range(atom/target, var/mob/user, params)
		if (next_shot_at > ticker.round_elapsed_ticks)
			return
		next_shot_at = ticker.round_elapsed_ticks + cooldown
		arcFlashTurf(user, get_turf(target), 15000)

/datum/limb/gun
	var/datum/projectile/proj = null
	var/cooldown = 30
	var/reload_time = 200
	var/shots = 4
	var/current_shots = 0
	var/reloading_str = "reloading"
	var/reloaded_at = 0
	var/next_shot_at = 0
	var/image/default_obscurer

	attack_range(atom/target, var/mob/user, params)
		if (reloaded_at > ticker.round_elapsed_ticks && !current_shots)
			boutput(user, "<span style='color:red'>The [holder.name] is [reloading_str]!</span>")
			return
		else if (current_shots <= 0)
			current_shots = shots
		if (next_shot_at > ticker.round_elapsed_ticks)
			return
		if (current_shots > 0)
			current_shots--
			var/pox = text2num(params["icon-x"]) - 16
			var/poy = text2num(params["icon-y"]) - 16
			shoot_projectile_ST_pixel(user, proj, target, pox, poy)
			user.visible_message("<b style='color:red'>[user] fires at [target] with the [holder.name]!</b>")
			next_shot_at = ticker.round_elapsed_ticks + cooldown
			if (!current_shots)
				reloaded_at = ticker.round_elapsed_ticks + reload_time
		else
			reloaded_at = ticker.round_elapsed_ticks + reload_time

	is_on_cooldown()
		if (ticker.round_elapsed_ticks < reloaded_at)
			return reloaded_at - ticker.round_elapsed_ticks
		return 0

	arm38
		proj = new/datum/projectile/bullet/revolver_38
		shots = 3
		current_shots = 3
		cooldown = 30
		reload_time = 200

	abg
		proj = new/datum/projectile/bullet/abg
		shots = 6
		current_shots = 6
		cooldown = 30
		reload_time = 300

	phaser
		proj = new/datum/projectile/laser/light
		shots = 1
		current_shots = 1
		cooldown = 30
		reload_time = 30

	cutter
		proj = new/datum/projectile/laser/drill/cutter
		shots = 1
		current_shots = 1
		cooldown = 30
		reload_time = 30

	artillery
		proj = new/datum/projectile/bullet/autocannon
		shots = 1
		current_shots = 1
		cooldown = 50
		reload_time = 50

	disruptor
		proj = new/datum/projectile/disruptor/high
		shots = 1
		current_shots = 1
		cooldown = 40
		reload_time = 40

	glitch
		proj = new/datum/projectile/bullet/glitch
		shots = 1
		current_shots = 1
		cooldown = 40
		reload_time = 40

	fire_elemental
		proj = new/datum/projectile/bullet/flare
		shots = 1
		current_shots = 1
		cooldown = 40
		reload_time = 40

/datum/limb/mouth
	attack_hand(atom/target, var/mob/user, var/reach)
		if (ismob(target))
			..()

		if (istype(target, /obj/item))
			var/obj/item/potentially_food = target
			if (potentially_food.edible)
				potentially_food.Eat(user, user, 1)

	help(mob/target, var/mob/user)
		return

	disarm(mob/target, var/mob/user)
		return

	grab(mob/target, var/mob/user)
		return

	harm(mob/target, var/mob/user)
		if (!user || !target)
			return 0

		if (!target.melee_attack_test(user))
			return

		if (prob(80) || target.stunned || target.weakened || target.paralysis || target.stat || target.restrained())
			var/obj/item/affecting = target.get_affecting(user)
			var/datum/attackResults/msgs = user.calculate_melee_attack(target, affecting, 3, 8, 0)
			user.attack_effects(target, affecting)
			msgs.base_attack_message = "<b><span style='color:red'>[user] bites [target]!</span></b>"
			msgs.played_sound = "sound/weapons/werewolf_attack1.ogg"
			msgs.flush(0)
			user.HealDamage("All", 2, 0)
		else
			user.visible_message("<b><span style='color:red'>[user] attempts to bite [target] but misses!</span></b>")

/datum/limb/item
	attack_hand(atom/target, var/mob/user, var/reach)
		if (holder && holder.remove_object && istype(holder.remove_object))
			target.attackby(holder.remove_object, user)
			if (target)
				holder.remove_object.afterattack(target, src, reach)

/datum/limb/bear
	attack_hand(atom/target, var/mob/living/user, var/reach)
		if (!holder)
			return

		if (!istype(user))
			target.attack_hand(user)
			return

		if (ismob(target))
			..()
			return

		if (isobj(target))
			switch (user.smash_through(target, list("window", "grille")))
				if (0)
					if (istype(target, /obj/item))
						boutput(user, "<span style=\"color:red\">You try to pick [target] up but it wiggles out of your hand. Opposable thumbs would be nice.</span>")
						return
					else if (istype(target, /obj/machinery))
						boutput(user, "<span style=\"color:red\">You're unlikely to be able to use [target]. You manage to scratch its surface though.</span>")
						return

				if (1)
					return

		..()
		return

	help(mob/target, var/mob/living/user)
		user.show_message("<span style=\"color:red\">Nope. Not going to work. You're more likely to kill them.</span>")

	disarm(mob/target, var/mob/living/user)
		logTheThing("combat", user, target, "mauls %target% with bear limbs (disarm intent) at [log_loc(user)].")
		user.visible_message("<span style=\"color:red\">[user] mauls [target] while trying to disarm them!</span>")
		harm(target, user, 1)

	grab(mob/target, var/mob/living/user)
		logTheThing("combat", user, target, "mauls %target% with bear limbs (grab intent) at [log_loc(user)].")
		user.visible_message("<span style=\"color:red\">[user] mauls [target] while trying to grab them!</span>")
		harm(target, user, 1)

	harm(mob/target, var/mob/living/user, var/no_logs = 0)
		if (no_logs != 1)
			logTheThing("combat", user, target, "mauls %target% with bear limbs at [log_loc(user)].")
		var/obj/item/affecting = target.get_affecting(user)
		var/datum/attackResults/msgs = user.calculate_melee_attack(target, affecting, 6, 10, 0)
		user.attack_effects(target, affecting)
		var/action = pick("maim", "maul", "mangle", "rip", "claw", "lacerate", "mutilate")
		msgs.base_attack_message = "<b><span style='color:red'>[user] [action]s [target] with their [src.holder]!</span></b>"
		msgs.played_sound = "sound/effects/bloody_stab.ogg"
		msgs.damage_type = DAMAGE_CUT
		msgs.flush(SUPPRESS_LOGS)
		if (prob(60))
			target.weakened += 2

/datum/limb/wendigo
	attack_hand(atom/target, var/mob/living/user, var/reach)
		if (!holder)
			return

		var/quality = src.holder.quality

		if (!istype(user))
			target.attack_hand(user)
			return

		if (isobj(target))
			switch (user.smash_through(target, list("window", "grille", "door")))
				if (0)
					if (istype(target, /obj/item/reagent_containers))
						if (prob(50 * quality))
							user.visible_message("<span style=\"color:red\">[user] accidentally crushes [target]!</span>", "<span style=\"color:red\">You accidentally crush the [target]!</span>")
							qdel(target)
							return
					else if (istype(target, /obj/item))
						if (prob(45))
							user.show_message("<span style=\"color:red\">[target] slips through your claws!</span>")
							return

				if (1)
					return

		..()
		return

	proc/accident(mob/target, mob/living/user)
		if (prob(25))
			logTheThing("combat", user, target, "accidentally harms %target% with wendigo limbs at [log_loc(user)].")
			user.visible_message("<span style=\"color:red\"><b>[user] accidentally claws [target] while trying to [user.a_intent] them!</b></span>", "<span style=\"color:red\"><b>You accidentally claw [target] while trying to [user.a_intent] them!</b></span>")
			harm(target, user, 1)
			return 1
		return 0

	help(mob/target, var/mob/living/user)
		if (accident(target, user))
			return
		else
			..()

	disarm(mob/target, var/mob/living/user)
		if (accident(target, user))
			return
		else
			..()

	grab(mob/target, var/mob/living/user)
		if (accident(target, user))
			return
		else
			..()

	harm(mob/target, var/mob/living/user, var/no_logs = 0)
		var/quality = src.holder.quality
		if (no_logs != 1)
			logTheThing("combat", user, target, "mauls %target% with wendigo limbs at [log_loc(user)].")
		var/obj/item/affecting = target.get_affecting(user)
		var/datum/attackResults/msgs = user.calculate_melee_attack(target, affecting, 6, 9, rand(5,9) * quality)
		user.attack_effects(target, affecting)
		var/action = pick("maim", "maul", "mangle", "rip", "claw", "lacerate", "mutilate")
		msgs.base_attack_message = "<b><span style='color:red'>[user] [action]s [target] with their [src.holder]!</span></b>"
		msgs.played_sound = "sound/effects/bloody_stab.ogg"
		msgs.damage_type = DAMAGE_CUT
		msgs.flush(SUPPRESS_LOGS)
		if (prob(35 * quality))
			target.weakened += 4 * quality

// A replacement for the awful custom_attack() overrides in mutantraces.dm, which consisted of two
// entire copies of pre-stamina melee attack code (Convair880).
/datum/limb/abomination
	var/weak = 0

	werewolf
		weak = 1 // Werewolf melee attacks are similar enough. Less repeated code.

	attack_hand(atom/target, var/mob/living/user, var/reach)
		if (!holder)
			return

		if (!istype(user))
			target.attack_hand(user)
			return

		if (istype(target, /obj/critter))
			var/obj/critter/victim = target

			if (src.weak == 1)
				spawn (0)
					step_away(victim, user, 15)

				playsound(user.loc, pick('sound/misc/werewolf_attack1.ogg', 'sound/misc/werewolf_attack2.ogg', 'sound/misc/werewolf_attack3.ogg'), 50, 1)
				spawn (1)
					if (user) playsound(user.loc, "sound/weapons/DSCLAW.ogg", 40, 1, -1)

				user.visible_message("<span style=\"color:red\"><B>[user] slashes viciously at [victim]!</B></span>")
				victim.health -= rand(4,8) * victim.brutevuln

			else
				var/turf/T = get_edge_target_turf(user, user.dir)

				if (prob(66) && T && isturf(T))
					user.visible_message("<span style=\"color:red\"><B>[user] savagely punches [victim], sending them flying!</B></span>")
					victim.health -= 6 * victim.brutevuln
					spawn (0)
						victim.throw_at(T, 10, 2)
				else
					user.visible_message("<span style=\"color:red\"><B>[user] punches [victim]!</span>")
					victim.health -= 4 * victim.brutevuln

				playsound(user.loc, "punch", 25, 1, -1)

			if (victim && victim.alive && victim.health <= 0)
				victim.CritterDeath()
			return

		if (isobj(target))
			switch (user.smash_through(target, list("window", "grille", "door")))
				if (0)
					target.attack_hand(user)
					return
				if (1)
					return

		if (ismob(target))
			if (issilicon(target))
				special_attack_silicon(target, user)
				return
			else
				..()
				return

		..()
		return

	grab(mob/target, var/mob/living/user)
		if (!holder)
			return

		if (!istype(user) || !ismob(target))
			target.attack_hand(user)
			return

		if (issilicon(target))
			special_attack_silicon(target, user)
			return

		user.grab_other(target, 1) // Use standard grab proc.

		// Werewolves and shamblers grab aggressively by default.
		var/obj/item/grab/GD = user.equipped()
		if (GD && istype(GD) && (GD.affecting && GD.affecting == target))
			target.stunned = max(2, target.stunned)
			GD.state = 1
			GD.update_icon()
			user.visible_message("<span style=\"color:red\">[user] grabs hold of [target] aggressively!</span>")

		return

	disarm(mob/target, var/mob/living/user)
		if (!holder)
			return

		if (!istype(user) || !ismob(target))
			target.attack_hand(user)
			return

		if (target.melee_attack_test(user, null, null, 1) != 1) // Target.lying check is in there.
			return

		if (issilicon(target))
			special_attack_silicon(target, user)
			return

		var/send_flying = 0 // 1: a little bit | 2: across the room
		var/obj/item/affecting = target.get_affecting(user)
		var/datum/attackResults/disarm/msgs = user.calculate_disarm_attack(target, affecting)

		if (!msgs || !istype(msgs))
			return

		if (src.weak == 1) // Werewolves get a guaranteed knockdown.
			if (!target.anchored && prob(50))
				send_flying = 1

			msgs.played_sound = 'sound/weapons/thudswoosh.ogg'
			user.werewolf_audio_effects(target, "disarm")
			msgs.base_attack_message = "<span style=\"color:red\"><B>[user] [pick("clocks", "strikes", "smashes")] [target] with a [pick("fierce", "fearsome", "supernatural", "wild", "beastly")] punch, forcing them to the ground!</B></span>"

			if (prob(35))
				msgs.damage_type = DAMAGE_CUT // Nasty claws!

			msgs.damage = rand(1,9)
			target.weakened += 2
			target.stuttering += 1

		else
			if (prob(25) && ishuman(target))
				var/mob/living/carbon/human/HH = target
				var/limb_name = "unknown limb"

				if (!HH || !ishuman(HH))
					..() // Something went very wrong, fall back to default disarm proc.
					return

				if (HH.l_hand)
					HH.sever_limb("l_arm")
					limb_name = "left arm"
				else if (HH.r_hand)
					HH.sever_limb("r_arm")
					limb_name = "right arm"
				else
					var/list/limbs = list("l_arm","r_arm","l_leg","r_leg")
					var/the_limb = pick(limbs)
					if (!HH.has_limb(the_limb))
						return 0
					HH.sever_limb(the_limb)
					switch (the_limb)
						if ("l_arm")
							limb_name = "left arm"
						if ("r_arm")
							limb_name = "right arm"
						if ("l_leg")
							limb_name = "left leg"
						if ("r_leg")
							limb_name = "right leg"

				if (prob(50) && HH.stat != 2)
					HH.emote("scream")

				msgs.played_sound = 'sound/effects/bloody_stab.ogg'
				msgs.base_attack_message = "<span style=\"color:red\"><B>[user] whips [HH] with the sharp edge of a chitinous tendril, shearing off their [limb_name]!</span>"
				msgs.damage_type = DAMAGE_CUT // We just lost a limb.

				msgs.damage = rand(1,5)
				HH.stunned += 2

			else
				if (!target.anchored && prob(30))
					send_flying = 1
				else
					target.drop_item() // Shamblers get a guaranteed disarm.

				msgs.played_sound = 'sound/weapons/thudswoosh.ogg'
				msgs.base_attack_message = "<span style=\"color:red\"><B>[user] shoves [target] with a [pick("powerful", "fearsome", "intimidating", "strong")] tendril[send_flying == 0 ? "" : ", forcing them to the ground"]!</B></span>"
				msgs.damage = rand(1,2)

		logTheThing("combat", user, target, "diarms %target% with [src.weak == 1 ? "werewolf" : "abomination"] arms at [log_loc(user)].")

		if (send_flying == 2)
			msgs.after_effects += /proc/wrestler_backfist
		else if (send_flying == 1)
			msgs.after_effects += /proc/wrestler_knockdown

		msgs.flush(SUPPRESS_LOGS)
		return

	harm(mob/target, var/mob/living/user)
		if (!holder)
			return

		if (!istype(user) || !ismob(target))
			target.attack_hand(user)
			return

		if (target.melee_attack_test(user) != 1)
			return

		if (issilicon(target))
			special_attack_silicon(target, user)
			return

		var/send_flying = 0 // 1: a little bit | 2: across the room
		var/obj/item/affecting = target.get_affecting(user)
		var/datum/attackResults/msgs = user.calculate_melee_attack(target, affecting)

		if (!msgs || !istype(msgs))
			return

		if (target.canmove && !target.anchored && !target.lying)
			if (prob(50))
				if (prob(60))
					target.stuttering += 2
					send_flying = 1
				else
					target.stuttering += 3
					send_flying = 2
			else
				target.stuttering += 1
				target.stunned += 1
		else
			target.stunned += 1
			target.stuttering += 1

		if (src.weak == 1)
			if (send_flying == 2)
				msgs.base_attack_message = "<span style=\"color:red\"><B>[user] delivers a supernatural punch, sending [target] flying!</b></span>"
			else
				if (prob(25))
					msgs.base_attack_message = "<span style=\"color:red\"><B>[user] mauls [target] viciously[send_flying == 0 ? "" : ", forcing them to the ground"]!</B></span>"
				else
					msgs.base_attack_message = "<span style=\"color:red\"><B>[user] slashes viciously at [target][send_flying == 0 ? "" : ", forcing them to the ground"]!</B></span>"
					target.add_fingerprint(user)

			if (prob(33) && target.stat != 2 && !issilicon(target))
				target.emote("scream")

			msgs.played_sound = 'sound/weapons/thudswoosh.ogg'
			user.werewolf_audio_effects(target, "swipe")
			msgs.damage = rand(8, 17)
			msgs.damage_type = DAMAGE_CUT // Nasty claws!

		else
			if (send_flying == 2)
				msgs.base_attack_message = "<span style=\"color:red\"><B>[user] delivers a savage blow, sending [target] flying!</b></span>"
			else
				msgs.base_attack_message = "<span style=\"color:red\"><B>[user] punches [target] with a [pick("powerful", "fearsome", "intimidating", "strong")] tendril[send_flying == 0 ? "" : ", forcing them to the ground"]!</B></span>"

			msgs.played_sound = 'sound/weapons/punch1.ogg'
			msgs.damage = rand(6, 13)
			msgs.damage_type = DAMAGE_BLUNT

		if (send_flying == 2)
			msgs.after_effects += /proc/wrestler_backfist
		else if (send_flying == 1)
			msgs.after_effects += /proc/wrestler_knockdown

		logTheThing("combat", user, target, "punches %target% with [src.weak == 1 ? "werewolf" : "abomination"] arms at [log_loc(user)].")
		user.attack_effects(target, affecting)
		msgs.flush(SUPPRESS_LOGS)
		return

// And why not (Convair880).
/datum/limb/predator
	attack_hand(atom/target, var/mob/living/user, var/reach)
		if (!holder)
			return

		if (!istype(user))
			target.attack_hand(user)
			return

		if (isobj(target))
			switch (user.smash_through(target, list("door")))
				if (0)
					target.attack_hand(user)
					return
				if (1)
					return

		..()
		return

	harm(mob/target, var/mob/living/user)
		if (!holder)
			return

		if (!istype(user) || !ismob(target))
			target.attack_hand(user)
			return

		if (ismob(target))
			user.melee_attack_normal(target, 5) // Slightly more powerful punches. This is bonus damage, not a multiplier.
			return

		..()
		return