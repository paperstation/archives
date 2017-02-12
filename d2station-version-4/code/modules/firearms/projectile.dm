#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"


/obj/item/projectile
	name = "projectile"
	icon = 'projectiles.dmi'
	icon_state = "bullet"
	density = 1
	unacidable = 1	//Just to be sure.
	anchored = 0	// I'm not sure if it is a good idea. Bullets sucked to space and curve trajectories near singularity could be awesome. --rastaf0
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	mouse_opacity = 0
	var
		bumped = 0			//Prevents it from hitting more than one guy at once
		bump_at_ttile = 0	//Will the bullet stop and trigger after reaching the clicked tile?

		def_zone = ""		//Aiming at (left arm, right leg), Also this should be more random its hard to hit things sometimes
		mob/firer = null	//Who shot it
		suppressed = 0		//Attack message
		yo = null
		xo = null
		current = null			// Current tile
		turf/original = null	// Target tile

		damage = 10		//Damage dealt by projectile. This is used for machinery, critters, anything not under /mob heirarchy
		flag = "bullet"	//Defines what armor to use when it hits things.  Must be set to bullet, laser, taser, bomb, bio, or rad
		nodamage = 0	//Determines if the projectile will skip any damage inflictions

		list/mobdamage = list(BRUTE = 50, BURN = 0, TOX = 0, OXY = 0, CLONE = 0) //Determines what kind of damage it does to mobs
		list/effects = list("stun" = 0, "weak" = 0, "paralysis" = 0, "stutter" = 0, "drowsyness" = 0, "radiation" = 0, "eyeblur" = 0, "emp" = 0) // long list of effects a projectile can inflict on something. !!MUY FLEXIBLE!!~
		list/effectprob = list("stun" = 100, "weak" = 100, "paralysis" = 100, "stutter" = 100, "drowsyness" = 100, "radiation" = 100, "eyeblur" = 100, "emp" = 100) // Probability for an effect to execute
		list/effectmod = list("stun" = SET, "weak" = SET, "paralysis" = SET, "stutter" = SET, "drowsyness" = SET, "radiation" = SET, "eyeblur" = SET, "emp" = SET) // determines how the effect modifiers will effect a mob's variable


	Bump(atom/A as mob|obj|turf|area)


		if(bumped)return

		if(A == firer)
			loc = A.loc
			bumped = 0
			return // cannot shoot yourself // y did someone have it so you could
		//invisibility = 101
	//	bumped = 1
		if(firer && istype(A, /mob))
			var/mob/M = A
			if(!istype(A, /mob/living))
				loc = A.loc
				return // nope.avi
			if(prob(5))
				A << "\red You release your bodily fluids!"
				A:emote(pick("pee","poo","vomit","cum"))
			if(!suppressed)
				visible_message("\red [A.name] has been shot by [firer.name]!", "\blue You hear a [istype(src, /obj/item/projectile/beam) ? "gunshot" : "laser blast"]!")
			else
				M << "\red You've been shot!"
			if(istype(firer, /mob))
				M.attack_log += text("\[[]\] <b>[]/[]</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), firer, firer.ckey, M, M.ckey, src)
				firer.attack_log += text("\[[]\] <b>[]/[]</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), firer, firer.ckey, M, M.ckey, src)
			else
				M.attack_log += text("\[[]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), M, M.ckey, src)

		spawn(0)
			if(A)
				A.bullet_act(src, def_zone)
				if(istype(A,/turf))
					for(var/obj/O in A)
						O.bullet_act(src)
					for(var/mob/M in A)
						M.bullet_act(src, def_zone)

				if(istype(src, /obj/item/projectile/freeze))//These could likely be moved
					var/obj/item/projectile/freeze/F = src
					F.Freeze(A)
				else if(istype(src, /obj/item/projectile/plasma))
					var/obj/item/projectile/plasma/P = src
					P.Heat(A)
				else if(istype(src, /obj/item/projectile/phaser))
					var/obj/item/projectile/phaser/Q = src
					Q.effect_tiles(loc, Q.loaded_effect)
				else if(istype(src, /obj/item/projectile/ep90electrode))
					var/obj/item/projectile/ep90electrode/E = src
					if(E.aoe)
						E.stun_tiles(loc)
				else if(istype(src, /obj/item/projectile/concussivewave))
					if(istype(A, /atom/movable))
						if(!A:anchored)
							var/atom/T = get_step_away(A, src)
							A:throw_at(T, 1, 2)

				density = 0
				del(src)
		return



	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0)) return 1

		if(istype(mover, /obj/item/projectile))
			return prob(95)
		else
			return 1


	process()
		spawn while(src)
			if((!( current ) || loc == current))
				current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
			if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
				del(src)
				return
			step_towards(src, current)
			sleep(1)
			if(loc == original && bump_at_ttile)
				Bump(loc)
				sleep(1)
			if(!bumped && loc == original)
				for(var/mob/living/M in original)
					if(M)
						Bump(M)
						sleep(1)
					else
						Bump(loc)
						sleep(1)
		return
