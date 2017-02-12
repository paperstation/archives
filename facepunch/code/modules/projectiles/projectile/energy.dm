/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damtype = BURN
	force = 0


/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	damtype = FATIGUE
	force = 10

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, WEAKEN, forcetype, def_zone)
			L.deal_damage(force, STUTTER, forcetype, def_zone)


/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	force = 5
	damtype = CLONE
	forcetype = IRRADIATE

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
		return 1


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damtype = TOX
	force = 5

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
			L.deal_damage(force, WEAKEN, forcetype, def_zone)
			L.deal_damage(force, STUTTER, forcetype, def_zone)
		return 1


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	force = 5
	damtype = TOX

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
			L.deal_damage(force, WEAKEN, forcetype, def_zone)
			L.deal_damage(force, STUTTER, forcetype, def_zone)
		return 1


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	force = 10
	damtype = TOX
	forcetype = IMPACT

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			L.deal_damage(force, damtype, forcetype, def_zone)
			L.deal_damage(force, WEAKEN, forcetype, def_zone)
		return 1



/obj/item/projectile/energy/paintball
	name = "paintball"
	icon_state = "neurotoxin"
	force = 1
	damtype = BRUTE
	forcetype = IMPACT

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /turf/))
			target.color = color
		if(istype(target, /mob/))
			target.color = color
		if(istype(target, /obj/))
			target.color = color
		return 1

/obj/item/projectile/energy/paintball/red
	color = "red"
/obj/item/projectile/energy/paintball/green
	color = "green"