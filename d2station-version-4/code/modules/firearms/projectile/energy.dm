/obj/item/projectile/electrode
	name = "electrode"
	icon_state = "spark"
	flag = "taser"
	damage = 0
	nodamage = 1
	New()
		..()
		effects["stun"] += 20
		effects["weak"] += 20
		effects["stutter"] += 20
		effectprob["weak"] += 45

/obj/item/projectile/weakelectrode
	name = "electrode"
	icon_state = "spark"
	flag = "taser"
	damage = 0
	nodamage = 1
	New()
		..()
		effects["stun"] += 12
		effects["weak"] += 8
		effects["stutter"] += 8
		effectprob["weak"] += 22

/obj/item/projectile/ep90electrode
	name = "electrode"
	icon_state = "magnetpellet"
	flag = "taser"
	damage = 1
	mobdamage = list(BRUTE = 0, BURN = 1, TOX = 0, OXY = 0, CLONE = 0)
	var/aoe = 0
	New()
		..()
		effects["stun"] += 3
		effectmod["stun"] += ADD
		effects["weak"] += 1
		effectprob["weak"] += 10
		effects["stutter"] += 5

	proc/stun_tiles(turf/A)
		for (var/turf/stunturf in range(1,A))
			for(var/mob/living/carbon/M in stunturf)
				M.stunned += 4
				M.weakened += 2
			new /obj/effects/sparks(stunturf)
		del(src)
		return

/obj/item/projectile/bolt
	name = "bolt"
	icon_state = "cbbolt"
	flag = "taser"
	damage = 0
	nodamage = 1
	New()
		..()
		effects["weak"] = 10
		effects["stutter"] = 10

/obj/item/projectile/concussivewave
	name = "wave"
	icon_state = "concusswave"
	flag = "taser"
	damage = 0
	nodamage = 1
	New()
		..()
		effects["stun"] = 10
		effects["weak"] = 20
		effects["stutter"] = 5
		effectprob["weak"] = 75