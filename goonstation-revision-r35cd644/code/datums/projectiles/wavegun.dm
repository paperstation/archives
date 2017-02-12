/datum/projectile/wavegun
	name = "energy wave"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "wave"
//How much of a punch this has, tends to be seconds/damage before any resist
	power = 5
//How much ammo this costs
	cost = 25
//How fast the power goes away
	dissipation_rate = 1
//How many tiles till it starts to lose power
	dissipation_delay = 10
//Kill/Stun ratio
	ks_ratio = 0.0
//name of the projectile setting, used when you change a guns setting
	sname = "single shot wave"
//file location for the sound you want it to play
	shot_sound = 'sound/weapons/rocket.ogg'
//How many projectiles should be fired, each will cost the full cost
	shot_number = 1
//What is our damage type
/*
kinetic - raw power
piercing - punches though things
slashing - cuts things
energy - energy
burning - hot
radioactive - rips apart cells or some shit
toxic - poisons
*/
	damage_type = D_ENERGY
	//With what % do we hit mobs laying down
	hit_ground_chance = 0
	//Can we pass windows
	window_pass = 0

//Any special things when it hits shit?
	on_hit(atom/hit)
		if(istype(hit,/obj/window))
			if(prob(80))
				hit:smash()
		return

/datum/projectile/wavegun/burst
	shot_number = 3
	cost = 75
	ks_ratio = 0.0
	damage_type = D_ENERGY
	sname = "burst wave"


/datum/projectile/wavegun/paralyze
	shot_number = 1
	power = 80
	ks_ratio = 0.0
	cost = 45
	damage_type = D_ENERGY
	sname = "paralysis wave"



