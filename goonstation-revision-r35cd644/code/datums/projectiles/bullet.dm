/datum/projectile/bullet
//How much of a punch this has, tends to be seconds/damage before any resist
	power = 45
//How much ammo this costs
	cost = 1
//How fast the power goes away
	dissipation_rate = 5
//How many tiles till it starts to lose power
	dissipation_delay = 5
//Kill/Stun ratio
	ks_ratio = 1.0
//name of the projectile setting, used when you change a guns setting
	sname = "single shot"
//file location for the sound you want it to play
	shot_sound = 'sound/weapons/Gunshot.ogg'
//How many projectiles should be fired, each will cost the full cost
	shot_number = 1

	// caliber list: update as needed
	// 0.22 pistol / zipgun
	// 0.308 - rifles
	// 0.357 - revolver
	// 0.38 - detective
	// 0.41 - derringer
	// 0.72 - shotgun shell, 12ga
	// 1.57 - grenade shell, 40mm
	// 1.58 - RPG-7 (Tube is 40mm too, though warheads are usually larger in diameter.)

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
	damage_type = D_KINETIC
// blood system damage type - DAMAGE_STAB, DAMAGE_CUT, DAMAGE_BLUNT
	hit_type = DAMAGE_CUT
	//With what % do we hit mobs laying down
	hit_ground_chance = 33
	//Can we pass windows
	window_pass = 0
	implanted = /obj/item/implant/projectile
	// we create this overlay on walls when we hit them
	icon_turf_hit = "bhole"

//Any special things when it hits shit?
	on_hit(atom/hit, direction, projectile)
		if (ishuman(hit) && src.hit_type)
			take_bleeding_damage(hit, null, round(src.power / 3), src.hit_type) // oh god no why was the first var set to src what was I thinking
		return // BULLETS CANNOT BLEED, HAINE

/datum/projectile/bullet/bullet_22
	name = "bullet"
	power = 35
	shot_sound = 'sound/machines/click.ogg'
	damage_type = D_KINETIC
	hit_type = DAMAGE_CUT
	implanted = /obj/item/implant/projectile/bullet_22
	casing = /obj/item/casing/small
	caliber = 0.22
	icon_turf_hit = "bhole-small"
	silentshot = 1 // It's supposed to be a stealth weapon, right (Convair880)?

/datum/projectile/bullet/custom
	name = "bullet"
	power = 1
	damage_type = D_KINETIC
	hit_type = DAMAGE_CUT
	implanted = /obj/item/implant/projectile/bullet_22
	casing = /obj/item/casing/small
	caliber = 0.22
	icon_turf_hit = "bhole-small"

/datum/projectile/bullet/revolver_357
	name = "bullet"
	power = 60 // okay this can be made worse again now that crit isn't naptime
	damage_type = D_KINETIC
	hit_type = DAMAGE_CUT
	implanted = /obj/item/implant/projectile/bullet_357
	caliber = 0.357
	icon_turf_hit = "bhole-small"
	casing = /obj/item/casing/medium

/datum/projectile/bullet/revolver_357/AP
	power = 50
	damage_type = D_PIERCING
	hit_type = DAMAGE_STAB
	implanted = /obj/item/implant/projectile/bullet_357AP

/datum/projectile/bullet/staple
	name = "staple"
	power = 5
	damage_type = D_KINETIC // don't staple through armor
	hit_type = DAMAGE_BLUNT
	implanted = /obj/item/implant/projectile/staple // HEH
	shot_sound = 'sound/effects/snap.ogg'
	icon_turf_hit = "bhole-staple"
	casing = null

/datum/projectile/bullet/revolver_38
	name = "bullet"
	power = 35
	ks_ratio = 1.0
	implanted = /obj/item/implant/projectile/bullet_38
	caliber = 0.38
	icon_turf_hit = "bhole-small"
	casing = /obj/item/casing/medium

/datum/projectile/bullet/revolver_38/AP//traitor det revolver
	power = 50
	implanted = /obj/item/implant/projectile/bullet_38AP
	damage_type = D_PIERCING
	hit_type = DAMAGE_STAB

/datum/projectile/bullet/rifle_3006
	name = "bullet"
	power = 125
	damage_type = D_PIERCING
	hit_type = DAMAGE_STAB
	implanted = /obj/item/implant/projectile/bullet_308
	shot_sound = 'sound/weapons/railgun.ogg'
	dissipation_delay = 10
	casing = /obj/item/casing/rifle
	caliber = 0.308
	icon_turf_hit = "bhole-small"

	on_hit(atom/hit, dirflag)
		if(ishuman(hit))
			var/mob/living/carbon/human/M = hit
			if(power > 40)
				M.stunned += 3
				M.weakened += 2
			if(power > 80)
				var/turf/target = get_edge_target_turf(M, dirflag)
				spawn(0)
					M.throw_at(target, 2, 2)
			if (src.hit_type)
				take_bleeding_damage(hit, null, round(src.power / 3), src.hit_type)

/datum/projectile/bullet/tranq_dart
	name = "dart"
	power = 10
	icon = 'icons/obj/chemical.dmi'
	icon_state = "syringeproj"
	damage_type = D_TOXIC
	hit_type = DAMAGE_BLUNT
	implanted = /obj/item/implant/projectile/dart
	shot_sound = 'sound/effects/syringeproj.ogg'
	dissipation_delay = 10
	caliber = 0.308
	reagent_payload = "haloperidol"
	casing = /obj/item/casing/rifle

	syndicate
		reagent_payload = "sodium_thiopental" // HEH

	anti_mutant
		reagent_payload = "mutadone" // HAH



/datum/projectile/bullet/revolver_38/stunners//energy bullet things so he can actually stun something
	name = "stun bullet"
	power = 20
	ks_ratio = 0.0
	damage_type = D_ENERGY // FUCK YOU.
	hit_type = null
	icon_turf_hit = null // stun bullets shouldn't actually enter walls should they?

	on_hit(atom/hit) // adding this so these work like taser shots I guess, if this sucks feel free to remove it
		if (ishuman(hit))
			var/mob/living/carbon/human/H = hit
			H.slowed = max(2, H.slowed)
			H.change_misstep_chance(5)
			H.emote("twitch_v")
		return

	on_pointblank(var/obj/projectile/P, var/mob/living/M)
		stun_bullet_hit(P, M)

/datum/projectile/bullet/derringer
	name = "bullet"
	shot_sound = 'sound/weapons/derringer.ogg'
	power = 125
	dissipation_delay = 1
	dissipation_rate = 25
	damage_type = D_PIERCING
	hit_type = DAMAGE_STAB
	implanted = /obj/item/implant/projectile/bullet_41
	ks_ratio = 1.0
	caliber = 0.41
	icon_turf_hit = "bhole"
	casing = /obj/item/casing/derringer

	on_hit(atom/hit)
		if(ismob(hit) && hasvar(hit, "stunned"))
			hit:stunned += 5
		if (ishuman(hit))
			if (src.hit_type)
				take_bleeding_damage(hit, null, round(src.power / 3), src.hit_type)
		return

/datum/projectile/bullet/a12
	name = "buckshot"
	shot_sound = 'sound/weapons/shotgunshot.ogg'
	power = 80
	ks_ratio = 1.0
	dissipation_delay = 3//2
	dissipation_rate = 20
	damage_type = D_KINETIC
	hit_type = DAMAGE_BLUNT
	caliber = 0.72 // roughly
	icon_turf_hit = "bhole"
	implanted = /obj/item/implant/projectile/bullet_12ga
	casing = /obj/item/casing/shotgun_red

	on_hit(atom/hit, dirflag)
		if (ishuman(hit))
			var/mob/living/carbon/human/M = hit
			if(power > 30)
				M.stunned += 5
				M.weakened += 5
			if(power > 70)
				var/turf/target = get_edge_target_turf(M, dirflag)
				spawn(0)
					if(!M.stat) M.emote("scream")
					M.throw_at(target, 6, 2)
			if (src.hit_type)
				take_bleeding_damage(hit, null, round(src.power / 3), src.hit_type)

/datum/projectile/bullet/aex
	name = "explosive slug"
	shot_sound = 'sound/weapons/shotgunshot.ogg'
	power = 50
	ks_ratio = 1.0
	dissipation_delay = 6
	dissipation_rate = 10
	implanted = null
	damage_type = D_KINETIC
	hit_type = DAMAGE_BLUNT
	caliber = 0.72
	icon_turf_hit = "bhole"
	casing = /obj/item/casing/shotgun_orange

	on_hit(atom/hit)
		explosion_new(null, get_turf(hit), 1)

/datum/projectile/bullet/abg
	name = "rubber slug"
	shot_sound = 'sound/weapons/shotgunshot.ogg'
	power = 24
	ks_ratio = 0.2
	dissipation_rate = 4
	dissipation_delay = 3
	implanted = null
	damage_type = D_KINETIC
	hit_type = DAMAGE_BLUNT
	caliber = 0.72
	icon_turf_hit = "bhole"
	casing = /obj/item/casing/shotgun_blue

	on_hit(atom/hit, dirflag)
		if (ishuman(hit))
			var/mob/living/carbon/human/M = hit
			if(power >= 16)
				var/turf/target = get_edge_target_turf(M, dirflag)
				spawn(0)
					if(!M.stat) M.emote("scream")
					M.throw_at(target, 3, 2)
			//if (src.hit_type)
				//take_bleeding_damage(hit, null, round(src.power / 3), src.hit_type)

/datum/projectile/bullet/ak47
	name = "bullet" // why the fuck was this called magazine, you're not firing goddamn magazines at people
	shot_sound = 'sound/weapons/ak47shot.ogg'
	power = 50
	cost = 3
	ks_ratio = 1.0
	damage_type = D_KINETIC
	hit_type = DAMAGE_CUT
	shot_number = 3
	caliber = 0.308
	icon_turf_hit = "bhole-small"
	implanted = /obj/item/implant/projectile/bullet_308 // close enough, what the fuck ever
	casing = /obj/item/casing/rifle


/datum/projectile/bullet/vbullet
	name = "virtual bullet"
	shot_sound = 'sound/weapons/Gunshot.ogg'
	power = 10
	cost = 1
	ks_ratio = 1.0
	damage_type = D_KINETIC
	hit_type = DAMAGE_CUT
	implanted = null
	casing = null
	icon_turf_hit = null

/datum/projectile/bullet/flare
	name = "flare"
	shot_sound = 'sound/weapons/flaregun.ogg'
	power = 20
	cost = 1
	ks_ratio = 1.0
	damage_type = D_BURNING
	hit_type = null
	brightness = 1
	color_red = 1
	color_green = 0.3
	color_blue = 0
	icon_state = "flare"
	implanted = null
	caliber = 0.72 // 12 guage
	icon_turf_hit = "bhole"
	casing = /obj/item/casing/shotgun_orange

	on_hit(atom/hit)
		if (isliving(hit))
			fireflash(get_turf(hit), 0)
		else if (isturf(hit))
			fireflash(hit, 0)
		else
			fireflash(get_turf(hit), 0)

/datum/projectile/bullet/flare/UFO
	name = "heat beam"
	window_pass = 1
	icon_state = "plasma"
	casing = null

/datum/projectile/bullet/shrapnel // cogwerks: for explosions
	name = "shrapnel"
	power = 10
	damage_type = D_PIERCING
	hit_type = DAMAGE_CUT
	window_pass = 0
	icon = 'icons/obj/scrap.dmi'
	icon_state = "2metal0"
	casing = null
	icon_turf_hit = "bhole-staple"

/datum/projectile/bullet/autocannon
	name = "HE grenade"
	window_pass = 0
	icon_state = "40mmR"
	damage_type = D_KINETIC
	hit_type = DAMAGE_BLUNT
	power = 25
	dissipation_delay = 30
	cost = 1
	shot_sound = 'sound/weapons/rocket.ogg'
	ks_ratio = 1.0
	caliber = 1.57 // 40mm grenade shell
	icon_turf_hit = "bhole-large"
	casing = /obj/item/casing/grenade

	on_hit(atom/hit)
		explosion_new(null, get_turf(hit), 15)

	plasma_orb
		name = "fusion orb"
		damage_type = D_BURNING
		hit_type = null
		icon_state = "fusionorb"
		implanted = null
		brightness = 0.8
		color_red = 1
		color_green = 0.6
		color_blue = 0.2
		power = 50
		shot_sound = 'sound/machines/engine_alert3.ogg'
		icon_turf_hit = null
		casing = null

	huge
		icon_state = "400mm"
		power = 100
		caliber = 15.7
		icon_turf_hit = "bhole-large"

		on_hit(atom/hit)
			explosion_new(null, get_turf(hit), 80)

	seeker
		name = "drone-seeking grenade"
		var/max_turn_rate = 20
		precalculated = 0

		on_launch(var/obj/projectile/P)
			var/obj/critter/gunbot/drone/D = locate() in range(15, P)
			if (D)
				P.data = D

		tick(var/obj/projectile/P)
			if (!P)
				return
			if (!P.loc)
				return
			if (!P.data)
				return
			var/obj/D = P.data
			if (!istype(D))
				return
			var/turf/T = get_turf(D)
			var/turf/S = get_turf(P)

			if (!T || !S)
				return

			var/STx = T.x - S.x
			var/STy = T.y - S.y
			var/STlen = STx * STx + STy * STy
			if (!STlen)
				return
			STlen = sqrt(STlen)
			STx /= STlen
			STy /= STlen
			var/dot = STx * P.xo + STy * P.yo
			var/det = STx * P.yo - STy * P.xo
			var/sign = -1
			if (det <= 0)
				sign = 1

			var/relang = arccos(dot)
			P.rotateDirection(max(-max_turn_rate, min(max_turn_rate, sign * relang)))

// Ported from old, non-gun RPG-7 object class (Convair880).
/datum/projectile/bullet/rpg
	name = "MPRT rocket"
	window_pass = 0
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "rpg_rocket"
	damage_type = D_KINETIC
	hit_type = DAMAGE_BLUNT
	power = 40
	dissipation_delay = 30
	cost = 1
	shot_sound = 'sound/weapons/rocket.ogg'
	ks_ratio = 1.0
	caliber = 1.58
	icon_turf_hit = "bhole-large"

	on_hit(atom/hit)
		var/turf/T = get_turf(hit)
		if (T)
			for (var/mob/living/carbon/human/M in view(hit, 2))
				if (istype(M.wear_suit, /obj/item/clothing/suit/armor))
					boutput(M, "<span style=\"color:red\">Your armor blocks the shrapnel!</span>")
					M.TakeDamage("chest", 5, 0)
				else
					M.TakeDamage("chest", 15, 0)
					var/obj/item/implant/projectile/shrapnel/implanted = new /obj/item/implant/projectile/shrapnel(M)
					implanted.owner = M
					M.implant += implanted
					implanted.implanted(M, null, 2)
					boutput(M, "<span style=\"color:red\">You are struck by shrapnel!</span>")
					if (!M.stat)
						M.emote("scream")

			T.hotspot_expose(700,125)
			explosion_new(null, T, 30, 0.5)
		return

/obj/smokeDummy
	name = ""
	desc = ""
	invisibility = 101
	anchored = 1
	density = 0
	opacity = 0
	var/list/affected = list()

	disposing()
		remove()
		return ..()

	Del()
		remove()
		return ..()

	New(var/atom/sloc)
		if(!sloc) return
		src.loc = sloc
		for(var/mob/M in src.loc)
			Crossed(M)
		return ..()

	proc/remove()
		for(var/mob/M in affected)
			if(M:hasOverlayComposition(/datum/overlayComposition/smoke))
				M:removeOverlayComposition(/datum/overlayComposition/smoke)
				M:updateOverlaysClient(M:client)
		affected.Cut()
		return

	Crossed(atom/movable/O)
		if(ismob(O) && prob(30))
			if(ishuman(O))
				var/mob/living/carbon/human/M = O
				if (M.internal != null && M.wear_mask && (M.wear_mask.c_flags & MASKINTERNALS))
				else
					O:emote("cough")
					O:stunned += 1

		if(ismob(O) && O:client)
			if (!isobserver(O) && !iswraith(O) && !isintangible(O)) // fuck you stop affecting ghosts FUCK YOU
				if(!O:hasOverlayComposition(/datum/overlayComposition/smoke))
					O:addOverlayComposition(/datum/overlayComposition/smoke)
					O:updateOverlaysClient(O:client)
				affected.Add(O)
		return ..()

	Uncrossed(atom/movable/O)
		if(ismob(O) && O:client)
			if (!isobserver(O) && !iswraith(O) && !isintangible(O)) // FUCK YOU
				if(!(locate(/obj/smokeDummy) in O.loc))
					if(O:hasOverlayComposition(/datum/overlayComposition/smoke))
						O:removeOverlayComposition(/datum/overlayComposition/smoke)
						O:updateOverlaysClient(O:client)
				affected.Remove(O)
		return ..()

/datum/projectile/bullet/smoke
	name = "smoke grenade"
	window_pass = 0
	icon_state = "40mmB"
	damage_type = D_KINETIC
	power = 25
	dissipation_delay = 10
	cost = 1
	shot_sound = 'sound/weapons/rocket.ogg'
	ks_ratio = 1.0
	caliber = 1.57 // 40mm grenade shell
	icon_turf_hit = "bhole-large"
	casing = /obj/item/casing/grenade

	var/list/smokeLocs = list()
	var/smokeLength = 300

	proc/startSmoke(atom/hit, dirflag, atom/projectile)
		/*var/turf/trgloc = get_turf(projectile)
		var/list/affected = block(locate(trgloc.x - 3,trgloc.y - 3,trgloc.z), locate(trgloc.x + 3,trgloc.y + 3,trgloc.z))
		if(!affected.len) return
		var/list/centerview = view(world.view, trgloc)
		for(var/atom/A in affected)
			if(!(A in centerview)) continue
			var/obj/smokeDummy/D = new(A)
			smokeLocs.Add(D)
			spawn(smokeLength) qdel(D)
		particleMaster.SpawnSystem(new/datum/particleSystem/areaSmoke("#ffffff", smokeLength, trgloc))
		return*/

		// I'm so tired of overlays freezing my client, sorry. Get rid of the old smoke call here once
		// the performance and issues of full-screen overlays have been resolved, I guess (Convair880).
		var/turf/T = get_turf(projectile)
		if (T && isturf(T))
			var/datum/effects/system/bad_smoke_spread/S = new /datum/effects/system/bad_smoke_spread/(T)
			if (S)
				S.set_up(20, 0, T)
				S.start()
		return

	on_hit(atom/hit, dirflag, atom/projectile)
		startSmoke(hit, dirflag, projectile)
		return

/datum/projectile/bullet/glitch
	name = "bullet"
	window_pass = 1
	icon_state = "glitchproj"
	damage_type = D_KINETIC
	hit_type = null
	power = 30
	dissipation_delay = 12
	cost = 1
	shot_sound = 'sound/effects/glitchshot.ogg'
	ks_ratio = 1.0
	casing = null
	icon_turf_hit = null

	New()
		..()
		src.name = pick("weird", "puzzling", "odd", "strange", "baffling", "creepy", "unusual", "confusing", "discombobulating") + " bullet"
		src.name = corruptText(src.name, 66)

	on_hit(atom/hit)
		hit.icon_state = pick(icon_states(hit.icon))

		for(var/atom/a in hit)
			a.icon_state = pick(icon_states(a.icon))

		playsound(hit, "sound/machines/glitch3.ogg", 50, 1)

/datum/projectile/bullet/glitch/gun
	power = 1

/datum/projectile/bullet/rod // for the coilgun
	name = "metal rod"
	power = 50
	damage_type = D_KINETIC
	hit_type = DAMAGE_STAB
	window_pass = 0
	icon_state = "rod_1"
	dissipation_delay = 25
	caliber = 1.0
	shot_sound = 'sound/weapons/ACgun2.ogg'
	casing = null
	icon_turf_hit = "bhole-large"

	on_hit(atom/hit)
		explosion_new(null, get_turf(hit), 5)