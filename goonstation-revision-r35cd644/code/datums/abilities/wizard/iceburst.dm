/datum/targetable/spell/iceburst
	name = "Ice Burst"
	desc = "Launches freezing bolts at nearby foes."
	icon_state = "iceburst"
	targeted = 0
	cooldown = 200
	requires_robes = 1
	offensive = 1

	cast()
		if(!holder)
			return
		var/count = 0
		var/count2 = 0
		var/moblimit = 3

		for(var/mob/living/M as mob in oview())
			if(M.stat == 2) continue
			count2++
		if(!count2)
			boutput(holder.owner, "Noone is in range!")
			return 1

		holder.owner.say("NYTH ERRIN")
		playsound(holder.owner.loc, "sound/voice/wizard/IceburstLoud.ogg", 50, 0, -1)
		if(!holder.owner.wizard_spellpower())
			boutput(holder.owner, "<span style=\"color:red\">Your spell is weak without a staff to focus it!</span>")

		for (var/mob/living/M as mob in oview())
			if(M.stat == 2) continue
			if (ishuman(M))
				if (M.bioHolder.HasEffect("training_chaplain"))
					boutput(holder.owner, "<span style=\"color:red\">[M] has divine protection! The spell refuses to target \him!</span>")
					continue
			if (iswizard(M) && M.wizard_spellpower())
				boutput(holder.owner, "<span style=\"color:red\">[M] has arcane protection! The spell refuses to target \him!</span>")
				continue

			playsound(holder.owner.loc, "sound/effects/mag_iceburstlaunch.ogg", 25, 1, -1)
			if ((!holder.owner.wizard_spellpower() && count >= 1) || (count >= moblimit)) break
			count++
			spawn(0)
				var/obj/overlay/A = new /obj/overlay( holder.owner.loc )
				A.icon_state = "icem"
				A.icon = 'icons/obj/wizard.dmi'
				A.name = "ice bolt"
				A.anchored = 0
				A.density = 0
				A.layer = MOB_EFFECT_LAYER
				//A.sd_SetLuminosity(3)
				//A.sd_SetColor(0, 0.1, 0.8)
				var/i
				for(i=0, i<20, i++)
					if (holder.owner.wizard_spellpower())
						if (!locate(/obj/decal/icefloor) in A.loc)
							var/obj/decal/icefloor/B = new /obj/decal/icefloor(A.loc)
							//B.sd_SetLuminosity(1)
							//B.sd_SetColor(0, 0.1, 0.8)
							spawn(200)
								qdel (B)
					step_to(A,M,0)
					if (get_dist(A,M) == 0)
						boutput(M, text("<span style=\"color:blue\">You are chilled by a burst of magical ice!</span>"))
						M.visible_message("<span style=\"color:red\">[M] is struck by magical ice!</span>")
						playsound(holder.owner.loc, "sound/effects/mag_iceburstimpact.ogg", 25, 1, -1)
						M.bodytemperature = 0
						M.lastattacker = holder.owner
						M.lastattackertime = world.time
						qdel(A)
						if(prob(40))
							M.visible_message("<span style=\"color:red\">[M] is frozen solid!</span>")
							new /obj/icecube(M.loc, M)
						return
					sleep(5)
				qdel(A)

// /obj/decal/icefloor moved to decal.dm

/obj/icecube
	name = "ice cube"
	desc = "That is a surprisingly large ice cube."
	icon = 'icons/effects/effects.dmi'
	icon_state = "icecube"
	density = 1
	layer = EFFECTS_LAYER_BASE
	var/health = 10
	var/steam_on_death = 1

	New(loc, mob/iced as mob)
		..()
		if(iced && !isAI(iced) && !istype(iced, /mob/living/intangible/blob_overmind))
			if(istype(iced.loc, /obj/icecube)) //Already in a cube?
				qdel(src)
				return

			iced.set_loc(src)

			src.underlays += iced
			boutput(iced, "<span style=\"color:red\">You are trapped within [src]!</span>") // since this is used in at least two places to trap people in things other than ice cubes
		src.health *= (rand(10,20)/10)
		return

	relaymove(mob/user as mob)
		if (user.stat)
			return

		if(prob(25))
			src.health--
			if(src.health <= 0)
				qdel(src)
		return

	attack_hand(mob/user as mob)
		user.visible_message("<span class='combat'><b>[user]</b> kicks [src]!</span>", "<span style=\"color:blue\">You kick [src].</span>")

		src.health -= 2
		if(src.health <= 0)
			qdel(src)
		return

	bullet_act(var/obj/projectile/P)
		var/damage = 0
		damage = round(((P.power/2)*P.proj_data.ks_ratio), 1.0)
		if (damage < 1)
			return

		if(src.material) src.material.triggerOnAttacked(src, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter) )
		for(var/atom/A in src)
			if(A.material)
				A.material.triggerOnAttacked(A, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))

		switch(P.proj_data.damage_type)
			if(D_KINETIC)
				src.health -= (damage*2)
			if(D_PIERCING)
				src.health -= (damage/2)
			if(D_ENERGY)
				src.health -= (damage/4)

		if(src.health <= 0)
			qdel(src)

		return

	attackby(obj/item/W as obj, mob/user as mob)
		src.health -= W.force
		if(src.health <= 0)
			qdel(src)
			return
		..()
		return

	disposing()
		for(var/atom/movable/AM in src)
			if(ismob(AM))
				var/mob/M = AM
				M.visible_message("<span style=\"color:red\"><b>[M]</b> breaks out of [src]!</span>","<span style=\"color:red\">You break out of [src]!</span>")
			AM.set_loc(src.loc)

		if (steam_on_death)
			if (!(locate(/datum/effects/system/steam_spread) in src.loc))
				var/datum/effects/system/steam_spread/steam = unpool(/datum/effects/system/steam_spread)
				steam.set_up(10, 0, get_turf(src))
				steam.attach(src)
				steam.start()

		..()
		return
