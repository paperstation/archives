/datum/targetable/spell/fireball
	name = "Fireball"
	desc = "Launches an explosive fireball at the target."
	icon_state = "fireball"
	targeted = 1
	target_anything = 1
	cooldown = 200
	requires_robes = 1
	offensive = 1
	sticky = 1

	cast(atom/target)
		holder.owner.say("MHOL HOTTOV")
		playsound(holder.owner.loc, "sound/voice/wizard/FireballLoud.ogg", 50, 0, -1)

		var/obj/overlay/A = new /obj/overlay(holder.owner.loc)
		playsound(holder.owner.loc, "sound/effects/mag_fireballlaunch.ogg", 25, 1, -1)
		A.icon_state = "fireball"
		A.icon = 'icons/obj/wizard.dmi'
		A.name = "a fireball"
		A.anchored = 0
		A.density = 0
		A.flags |= TABLEPASS
		A.fingerprintslast = "[holder.owner.key]"
		//A.sd_SetLuminosity(4)
		//A.sd_SetColor(0.95, 0.25, 0)
		spawn(0)
			for(var/i = 0, i < 100, i++)
				step_to(A, target, 0)
				if (get_dist(A, target) <= 1)
					var/mob/M = target
					if (istype(M))
						if (ishuman(M))
							if (M.bioHolder.HasEffect("training_chaplain"))
								boutput(holder.owner, "<span style=\"color:red\">[M] has divine protection from magic.</span>")
								M.visible_message("<span style=\"color:red\">The fireball strikes [M] with no effect whatsoever!</span>")
								playsound(M.loc, "sound/effects/bamf.ogg", 25, 1, -1)
								qdel(A)
								return
							if (iswizard(M) && M.wizard_spellpower())
								M.visible_message("<span style=\"color:red\">The fireball poofs into harmless smoke as it strikes [M]!</span>")
								playsound(M.loc, "sound/effects/bamf.ogg", 25, 1, -1)
								qdel(A)
								return
					var/turf/T = get_turf(target)
					if (holder.owner.wizard_spellpower())
						if (istype(M))
							random_brute_damage(M, 25)
							M.lastattacker = holder.owner
							M.lastattackertime = world.time
							M.TakeDamage("chest", 0, 20, 0, DAMAGE_BURN)
						for(var/mob/living/L in range(2, T))
							spawn(0)
								L.weakened += 5
								step(L,get_dir(T, L))
								spawn(5)
									if (target)
										step(L,get_dir(T, L))
								spawn(10)
									if (target)
										step(L,get_dir(T, L))
						if (target)
							explosion(A, T, -1, -1, 2, 2)
							fireflash(T, 1)
						qdel(A)
						return
					else
						boutput(holder.owner, "<span style=\"color:red\">Your spell is weak without a staff to focus it!</span>")
						if (istype(M))
							M.weakened += 5
							M.lastattacker = holder.owner
							M.lastattackertime = world.time
							random_brute_damage(M, 10)
							M.TakeDamage("chest", 0, 10, 0, DAMAGE_BURN)
						else
							explosion(A, T, -1, -1, 1, 1)
						fireflash(T,0)
						playsound(T, "sound/effects/bamf.ogg", 25, 1, -1)
						target.visible_message("<span style=\"color:red\">[target] is struck by the fireball!</span>")
						qdel(A)
				sleep(2)
			qdel(A)
