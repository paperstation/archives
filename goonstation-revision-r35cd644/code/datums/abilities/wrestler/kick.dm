/datum/targetable/wrestler/kick
	name = "Kick"
	desc = "A powerful kick, sends people flying away from you. Also useful for escaping from bad situations."
	targeted = 1
	target_anything = 0
	target_nodamage_check = 1
	target_selection_check = 1
	max_range = 1
	cooldown = 300
	start_on_cooldown = 1
	pointCost = 0
	when_stunned = 1
	not_when_handcuffed = 0

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner

		if (!M || !target)
			return 1

		if (M == target)
			boutput(M, __red("Why would you want to wrestle yourself?"))
			return 1

		if (get_dist(M, target) > src.max_range)
			boutput(M, __red("[target] is too far away."))
			return 1

		M.emote("scream")
		M.emote("flip")
		M.dir = turn(M.dir, 90)

		for (var/mob/C in oviewers(M))
			shake_camera(C, 8, 3)

		M.visible_message("<span style=\"color:red\"><B>[M.name] [pick_string("wrestling_belt.txt", "kick")]-kicks [target]!</B></span>")
		random_brute_damage(target, 15)
		playsound(M.loc, "swing_hit", 60, 1)

		var/turf/T = get_edge_target_turf(M, get_dir(M, get_step_away(target, M)))
		if (T && isturf(T))
			spawn(0)
				target.throw_at(T, 3, 2)
				target.weakened++
				target.stunned += 2

		logTheThing("combat", M, target, "uses the kick wrestling move on %target% at [log_loc(M)].")
		return 0