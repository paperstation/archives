/datum/projectile/laser
	name = "laser"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "laser"

	virtual
		icon_state = "laser_virtual"

//How much of a punch this has, tends to be seconds/damage before any resist
	power = 60
//How much ammo this costs
	cost = 25
//How fast the power goes away
	dissipation_rate = 5
//How many tiles till it starts to lose power
	dissipation_delay = 6
//Kill/Stun ratio
	ks_ratio = 1.0
//name of the projectile setting, used when you change a guns setting
	sname = "laser"
//file location for the sound you want it to play
	shot_sound = 'sound/weapons/Taser.ogg'
//How many projectiles should be fired, each will cost the full cost
	shot_number = 1
//What is our damage type
/*
kinetic - raw power
piercing - punches though things
slashing - cuts things
energy - energy (stun)
laser - energy (laser)
burning - hot
radioactive - rips apart cells or some shit
toxic - poisons
*/
	damage_type = D_ENERGY // cogwerks - changed from piercing
	//With what % do we hit mobs laying down
	hit_ground_chance = 90
	//Can we pass windows
	window_pass = 1
	brightness = 0.8
	color_red = 1
	color_green = 0
	color_blue = 0
	icon_turf_hit = "burn1"

//Any special things when it hits shit?
	on_hit(atom/hit)
		return

/datum/projectile/laser/quad
	name = "4 lasers"
	icon_state = "laser"
	power = 240
	cost = 100
	dissipation_rate = 250
	dissipation_delay = 0

	on_launch(var/obj/projectile/P)
		if (!P)
			return
		var/datum/projectile/laser/L = new()
		var/turf/PT = get_turf(P)
		var/obj/projectile/P1 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
		P1.rotateDirection(60)
		P1.launch()
		var/obj/projectile/P2 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
		P2.rotateDirection(20)
		P2.launch()
		var/obj/projectile/P3 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
		P3.rotateDirection(-20)
		P3.launch()
		var/obj/projectile/P4 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
		P4.rotateDirection(-60)
		P4.launch()
		P.die()

/datum/projectile/laser/heavy
	name = "heavy laser"
	icon_state = "u_laser"
	power = 80
	cost = 50
	dissipation_delay = 10
	sname = "heavy laser"
	shot_sound = 'sound/weapons/Laser.ogg'
	color_red = 0
	color_green = 0
	color_blue = 1

/datum/projectile/laser/asslaser // heh
	name = "assault laser"
	icon_state = "u_laser"
	power = 75
	cost = 65
	dissipation_delay = 5
	dissipation_rate = 10
	sname = "assault laser"
	shot_sound = 'sound/weapons/Laser.ogg'
	color_red = 0
	color_green = 0
	color_blue = 1

	on_hit(atom/hit)
		if (isliving(hit))
			fireflash(get_turf(hit), 0)
		else if (isturf(hit))
			fireflash(hit, 0)
			spawn(1)
				if(prob(40) && istype(hit, /turf/simulated))
					hit.meteorhit(src)
		else
			fireflash(get_turf(hit), 0)

/datum/projectile/laser/light // for the drones
	name = "phaser bolt"
	icon_state = "phaser_heavy"
	power = 20
	cost = 25
	sname = "phaser bolt"
	dissipation_delay = 5
	shot_sound = 'sound/weapons/laserlight.ogg'
	color_red = 1
	color_green = 0
	color_blue = 0

	longrange
		icon_state = "red_bolt"
		dissipation_delay = 10
		shot_sound = 'sound/weapons/laser_b.ogg'

	split
		dissipation_rate = 100
		power = 120
		dissipation_delay = 2

		on_launch(var/obj/projectile/P)
			if (!P)
				return
			var/datum/projectile/laser/light/L = new()
			L.power = 40
			var/turf/PT = get_turf(P)
			var/obj/projectile/P1 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
			P1.launch()
			var/obj/projectile/P2 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
			P2.rotateDirection(30)
			P2.launch()
			var/obj/projectile/P3 = initialize_projectile(PT, L, P.xo, P.yo, P.shooter)
			P3.rotateDirection(-30)
			P3.launch()
			P.die()

	curver
		tick(var/obj/projectile/P)
			if (!P)
				return
			P.rotateDirection(20)

	upgradeable
		icon_state = "phaser_light"
		var/datum/projectile/laser/light/launched = new/datum/projectile/laser/light
		var/count = 1

		on_launch(var/obj/projectile/P)
			launched.power = power
			launched.icon_state = icon_state
			if (count > 1)
				var/turf/PT = get_turf(P)
				if (count == 2)
					var/obj/projectile/P1 = initialize_projectile(PT, launched, P.xo, P.yo, P.shooter)
					P1.rotateDirection(30)
					var/obj/projectile/P2 = initialize_projectile(PT, launched, P.xo, P.yo, P.shooter)
					P2.rotateDirection(-30)
					P1.launch()
					P2.launch()
				else
					var/cangle = -60
					var/angle_step = 120 / (count - 1)
					for (var/i = 0, i < count, i++)
						var/obj/projectile/PN = initialize_projectile(PT, launched, P.xo, P.yo, P.shooter)
						if (cangle != 0)
							PN.rotateDirection(cangle)
						PN.launch()
						cangle += angle_step
				P.die()

		proc/update_icon()
			if (power >= 75)
				icon_state = "phaser_ultra"
			else if (power >= 50)
				icon_state = "phaser_heavy"
			else if (power >= 35)
				icon_state = "phaser_med"
			else
				icon_state = "phaser_light"

/datum/projectile/laser/glitter // for the russian pod
	name = "prismatic laser"
	icon_state = "eyebeam"
	power = 35
	cost = 35
	sname = "phaser bolt"
	dissipation_delay = 10
	shot_sound = 'sound/weapons/TaserOLD.ogg'
	color_red = 1
	color_green = 0
	color_blue = 1
	icon_turf_hit = "burn2"

/datum/projectile/laser/precursor // for precursor traps
	name = "energy bolt"
	icon_state = "disrupt"
	power = 30
	cost = 30
	sname = "energy bolt"
	dissipation_delay = 10
	shot_sound = 'sound/weapons/LaserOLD.ogg'
	color_red = 0.1
	color_green = 0.3
	color_blue = 1
	ks_ratio = 0.8

/datum/projectile/laser/pred //mostly just a reskin
	icon_state = "phaser_med"
	name = "plasma bolt"
	sname = "plasma bolt"
	shot_sound = 'sound/weapons/snipershot.ogg'
	dissipation_delay = 8
	dissipation_rate = 5
	cost = 50
	power = 35
	color_red = 0.4
	color_green = 0.5
	color_blue = 0.7

// These are for custom antique laser guns repaired with high-quality components.
// See displaycase.dm for details (Convair880).
/datum/projectile/laser/old
	icon = 'icons/obj/gun.dmi'
	icon_state = "proj_thermal"
	name = "pulse laser"
	sname = "pulse laser"
	shot_sound = 'sound/weapons/snipershot.ogg'
	dissipation_delay = 7.5
	dissipation_rate = 8
	cost = 40
	power = 70
	color_red = 1
	color_green = 0.3
	color_blue = 0

/datum/projectile/laser/old_burst
	icon = 'icons/obj/gun.dmi'
	icon_state = "proj_sing"
	name = "burst laser"
	sname = "burst laser"
	shot_sound = 'sound/weapons/snipershot.ogg'
	shot_number = 3
	cost = 100
	power = 35
	color_red = 0.4
	color_green = 0
	color_blue = 0.7

// cogwerks- mining laser, first attempt

/datum/projectile/laser/mining
	name = "Plasma Cutter Bolt"
	icon_state = "40mmgatling"
	power = 40
	cost = 40
	dissipation_delay = 1
	dissipation_rate = 8
	sname = "mining laser"
	shot_sound = 'sound/weapons/rocket.ogg'
	damage_type = D_BURNING
	brightness = 0.8
	window_pass = 0
	color_red = 0.9
	color_green = 0.6
	color_blue = 0

	on_hit(atom/hit)
		if (istype(hit, /turf/simulated/wall/asteroid))
			var/turf/simulated/wall/asteroid/T = hit
			if (power <= 0)
				return
			T.damage_asteroid(round(power / 10))
			//if(prob(60)) // raised again
			//	T.destroy_asteroid(1)
			//else
			//	T.weaken_asteroid()

/datum/projectile/laser/drill
	name = "drill bit"
	window_pass = 0
	icon_state = ""
	damage_type = D_SLASHING
	power = 35
	cost = 1
	brightness = 0
	sname = "drill bit"
	shot_sound = 'sound/machines/engine_grump1.ogg'
	dissipation_delay = 1
	dissipation_rate = 35
	icon_turf_hit = null

	on_hit(atom/hit)
		//playsound(hit.loc, "sound/machines/engine_grump1.ogg", 45, 1)
		if (istype(hit, /turf/simulated/wall/asteroid))
			var/turf/simulated/wall/asteroid/T = hit
			if (power <= 0)
				return
			T.damage_asteroid(round(power / 10))
			//if(prob(60)) // raised again
			//	T.destroy_asteroid(1)
			//else
			//	T.weaken_asteroid()
		if (ishuman(hit))
			var/mob/living/carbon/human/M = hit
			playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
			take_bleeding_damage(M, null, 1, DAMAGE_STAB)

	cutter
		name = "cutter blade"
		power = 30
		dissipation_rate = 30
		sname = "scrap cutter"
