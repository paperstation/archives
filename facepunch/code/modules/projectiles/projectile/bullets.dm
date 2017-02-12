/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	force = 60
	damtype = BRUTE
	forcetype = PIERCE


	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			if(force)
				L.deal_damage(force, damtype, forcetype, def_zone)
		return 1


/obj/item/projectile/bullet/weakbullet
	force = DAMAGE_MED


	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
			L.deal_damage(5, WEAKEN, forcetype, def_zone)
		return 1



/obj/item/projectile/bullet/midbullet
	force = DAMAGE_EXTREME

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
			L.deal_damage(5, WEAKEN, forcetype, def_zone)
		return 1


/obj/item/projectile/bullet/midbullet2
	force = 25


/obj/item/projectile/bullet/a762
	force = DAMAGE_MED


/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	force = 40
	damtype = TOX


/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	force = DAMAGE_MED

	on_hit(var/atom/target, var/blocked = 0)
		..()
		explosion(target, -1, 0, 2)
		return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	force = DAMAGE_MED

	on_hit(var/atom/target, var/blocked = 0)
		..()
		explosion(target, -1, 0, 1)
		return 1


/obj/item/projectile/bullet/stunshot
	name = "stunshot"
	force = 10

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, WEAKEN, forcetype, def_zone)
			L.deal_damage(force, STUTTER, forcetype, def_zone)



/obj/item/projectile/bullet/cannonball
	name = "cannonball"
	icon_state = "cannon"
	force = DAMAGE_EXTREME

	on_hit(var/atom/target, var/blocked = 0)
		..()
		target.ex_act(2)
		return 1