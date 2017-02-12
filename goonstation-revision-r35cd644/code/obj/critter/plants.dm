/obj/critter/maneater
	name = "man-eating plant"
	desc = "It looks hungry..."
	icon_state = "maneater"
	density = 1
	health = 30
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 0
	firevuln = 2
	brutevuln = 0.5
	butcherable = 1
	name_the_meat = 0
	meat_type = /obj/item/reagent_containers/food/snacks/salad
	generic = 0 // get this using the plant quality

	New()
		..()
		playsound(src.loc, pick("sound/voice/MEilive.ogg"), 45, 0)

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in hearers(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (iscarbon(C) && !src.atkcarbon) continue
			if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
			if (C.job == "Botanist") continue
			if (C.health < 0) continue
			if (C in src.friends) continue
			if (iscarbon(C) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> charges at [C.name]!</span>")
				playsound(src.loc, pick('sound/voice/MEhunger.ogg', 'sound/voice/MEraaargh.ogg', 'sound/voice/MEruncoward.ogg', 'sound/voice/MEbewarecoward.ogg'), 40, 0)
				src.task = "chasing"
				break
			else continue

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> slams into [M]!</span>")
		playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1, -1)
		M.stunned += rand(1,4)
		M.weakened += rand(1,4)

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> starts trying to eat [M]!</span>")
		spawn(70)
			if (get_dist(src, M) <= 1 && ((M:loc == target_lastloc)) && src.alive) // added a health check so dead maneaters stop eating people - cogwerks
				if(iscarbon(M))
					src.visible_message("<span class='combat'><B>[src]</B> ravenously wolfs down [M]!</span>")
					logTheThing("combat", M, null, "was devoured by [src] at [log_loc(src)].") // Some logging for instakill critters would be nice (Convair880).
					playsound(src.loc, "sound/items/eatfood.ogg", 30, 1, -2)
					M.death(1)
					var/atom/movable/overlay/animation = null
					M.transforming = 1
					M.canmove = 0
					M.icon = null
					M.invisibility = 101
					if(ishuman(M))
						animation = new(src.loc)
						animation.icon_state = "blank"
						animation.icon = 'icons/mob/mob.dmi'
						animation.master = src
					if (M.client)
						M.ghostize()
					qdel(M)

					sleeping = 2
					src.target = null
					src.task = "thinking"
					playsound(src.loc, pick("sound/misc/burp_alien.ogg"), 50, 0)
			else
				if(src.alive) // don't gnash teeth if dead
					src.visible_message("<span class='combat'><B>[src]</B> gnashes its teeth in fustration!</span>")
			src.attacking = 0

/obj/critter/killertomato
	name = "killer tomato"
	desc = "Today, Space Station 13 - tomorrow, THE WORLD!"
	icon_state = "ktomato"
	density = 1
	health = 15
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	firevuln = 2
	brutevuln = 2
	butcherable = 1
	name_the_meat = 0
	death_text = "%src% messily splatters into a puddle of tomato sauce!"
	meat_type = /obj/item/reagent_containers/food/snacks/plant/tomato/explosive
	generic = 0

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in hearers(src.seekrange,src))
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (iscarbon(C) && !src.atkcarbon) continue
			if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
			if (C.health < 0) continue
			if (C in src.friends) continue
			if (C.name == src.attacker) src.attack = 1
			if (iscarbon(C) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> charges at [C:name]!</span>")
				playsound(src.loc, pick('sound/voice/MEhunger.ogg', 'sound/voice/MEraaargh.ogg', 'sound/voice/MEruncoward.ogg', 'sound/voice/MEbewarecoward.ogg'), 40, 0)
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> viciously lunges at [M]!</span>")
		if (prob(20)) M.stunned += rand(1,3)
		random_brute_damage(M, rand(2,5))

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
		random_brute_damage(src.target, rand(1,2))
		spawn(10)
			src.attacking = 0

	CritterDeath()
		..()
		playsound(src.loc, "sound/effects/splat.ogg", 100, 1)
		var/obj/decal/cleanable/blood/B = new(src.loc)
		B.name = "ruined tomato"
		qdel (src)