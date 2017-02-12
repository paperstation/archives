/datum/projectile/special
	name = "special"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "laser"
	power = 15
	cost = 25
	dissipation_rate = 1
	dissipation_delay = 0
	ks_ratio = 1.0
	sname = "laser"
	shot_sound = 'sound/weapons/Taser.ogg'
	shot_number = 1
	damage_type = D_SPECIAL
	hit_ground_chance = 50
	window_pass = 0

	on_hit(atom/hit, direction, projectile)
		return

/datum/projectile/special/acid
	name = "acid"
	icon_state = "radbolt"
	power = 45
	dissipation_rate = 30
	dissipation_delay = 10
	sname = "acid"

	on_hit(atom/hit, direction, var/obj/projectile/projectile)
		var/power = projectile.power
		hit.damage_corrosive(power)

	potent
		power = 100

	weak
		power = 15

/datum/projectile/special/ice
	name = "ice"
	icon_state = "ice"
	power = 120
	dissipation_rate = 10
	dissipation_delay = 3
	sname = "ice"

	on_hit(atom/hit, direction, var/obj/projectile/projectile)
		hit.damage_cold(projectile.power / 10)
		if (ishuman(hit))
			var/mob/living/L = hit
			L.bodytemperature -= projectile.power

/datum/projectile/special/shock_orb
	name = "energy sphere"
	icon = 'icons/obj/artifacts/puzzles.dmi'
	icon_state = "sphere"
	power = 75
	cost = 75
	sname = "energy bolt"
	dissipation_delay = 15
	shot_sound = 'sound/machines/ArtifactPre1.ogg'
	color_red = 0.1
	color_green = 0.3
	color_blue = 1
	ks_ratio = 0.8

	var/shock_range = 3
	var/wattage = 7500

	tick(var/obj/projectile/P)
		var/list/sfloors = list()
		for (var/turf/T in view(shock_range, P))
			if (!T.density)
				sfloors += T
		var/shocks = rand(1, 5)
		while (shocks && sfloors.len)
			shocks--
			var/turf/Q = pick(sfloors)
			arcFlashTurf(P, Q, wattage)
			sfloors -= Q

/datum/projectile/special/shock_orb/always_mob
	tick(var/obj/projectile/P)
		var/list/smobs = list()
		for (var/mob/M in view(shock_range, P))
			smobs += M
		var/shocks = rand(1, 5)
		while (shocks && smobs.len)
			shocks--
			var/mob/Q = pick(smobs)
			arcFlash(P, Q, wattage)
			smobs -= Q

/datum/projectile/special/midas
	name = "Touch of Midas"
	icon_state = "ice"
	power = 1
	dissipation_rate = 1
	dissipation_delay = 25
	sname = "ice"
	color_icon = "#aaff00"
	tick(var/obj/projectile/P)
		var/turf/T = get_turf(P)
		if (T)
			T.setMaterial(getCachedMaterial("gold"))

	on_hit(var/atom/A)
		A.setMaterial(getCachedMaterial("gold"))

/datum/projectile/special/volatile_goo
	name = "Volatile Goo"
	icon_state = "ice"
	power = 1
	dissipation_rate = 1
	dissipation_delay = 25
	sname = "ice"
	color_icon = "#ff0000"
	tick(var/obj/projectile/P)
		var/turf/T = get_turf(P)
		if (T)
			T.setMaterial(getCachedMaterial("erebite"))

	on_hit(var/atom/A)
		A.setMaterial(getCachedMaterial("erebite"))

