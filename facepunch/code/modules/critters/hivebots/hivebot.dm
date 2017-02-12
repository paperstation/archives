/obj/item/projectile/hivebotbullet
	force = DAMAGE_LOW
	damtype = BRUTE

	on_hit(var/atom/target, var/blocked = 0)
		if(blocked)
			return 0
		if(istype(target, /mob/living))
			var/mob/living/L = target
			if(force)
				L.deal_damage(force, damtype, forcetype)
		return 1


/obj/effect/critter/hivebot
	name = "Hivebot"
	desc = "A four-legged robot that attacks with it's claws and a basic ballistic weapon."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	health = 10
	max_health = 10
	aggressive = 1
	wanderer = 1
	opensdoors = 1
	can_target = ATKCARBON | ATKSIMPLE | ATKCRITTER | ATKMECH
	firevuln = 0.5
	brutevuln = 1
	seekrange = 8
	damage_resistance = 5
	melee_damage_lower = 2
	melee_damage_upper = 3
	angertext = "leaps at"
	attacktext = "claws"
	team = "HIVE"
	var/ranged = 0
	var/rapid = 0
	var/sound = 0
	proc
		Shoot(var/target, var/start, var/user, var/bullet = 0)
		OpenFire(var/thing)//bluh ill rename this later or somethin


	Die()
		if (!src.alive) return
		src.alive = 0
		walk_to(src,0)
		src.visible_message("<b>[src]</b> blows apart!")
		var/turf/Ts = get_turf(src)
		new /obj/effect/decal/cleanable/robot_debris(Ts)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		del(src)


	SetTarget(var/atom/target)
		target = target
		oldtarget_name = target.name
		if(ranged)
			OpenFire(target)
			return 1
		task = "chasing"
		return 1


	OpenFire(var/thing)
		src.target = thing
		src.oldtarget_name = thing:name
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> fires at [src.target]!", 1)

		var/tturf = get_turf(target)
		if(rapid)
			spawn(1)
				Shoot(tturf, src.loc, src)
			spawn(4)
				Shoot(tturf, src.loc, src)
			spawn(6)
				Shoot(tturf, src.loc, src)
		else
			Shoot(tturf, src.loc, src)

		sleep(12)
		seek_target()
		src.task = "thinking"
		return


	Shoot(var/target, var/start, var/user, var/bullet = 0)
		if(target == start)
			return

		var/obj/item/projectile/hivebotbullet/A = new /obj/item/projectile/hivebotbullet(user:loc)
		playsound(user, 'sound/weapons/hivebotgun.ogg', 100, 1)

		if(!A)	return

		if (!istype(target, /turf))
			del(A)
			return
		A.current = target
		A.yo = target:y - start:y
		A.xo = target:x - start:x
		spawn( 0 )
			A.process()
		return


/obj/effect/critter/hivebot/rapid
	desc = "A four-legged robot that attacks with a rapid-fire ballistic weapon!"
	ranged = 1
	rapid = 1

/obj/effect/critter/hivebot/strong
	name = "Strong Hivebot"
	desc = "A four-legged robot that looks very tough."
	health = 50
	damage_resistance = 10
	ranged = 1
	rapid = 1

/obj/effect/critter/hivebot/antiborg
	health = 20
	can_target = ATKCARBON | ATKSILICON | ATKSIMPLE | ATKCRITTER | ATKMECH
	ranged = 1
	rapid = 1


/obj/effect/critter/hivebot/laser
	name = "Advanced Hivebot"
	icon_state = "EngBot"
	health = 20
	ranged = 1
	rapid = 0
	var/shot_delay = 4
	var/shot_num = 0
	var/beam_type = "n_beam"
	var/delay = 30
	var/laser_damage = 2


	OpenFire(var/thing)
		src.target = thing
		src.oldtarget_name = thing:name

		Shoot(target, src.loc, src)

		sleep(12)
		seek_target()
		src.task = "thinking"
		return


	Shoot(var/target, var/start, var/user, var/bullet = 0)
		shot_num++
		if(target == start || shot_delay > shot_num )
			return
		shot_num = 0
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <b>[src]</b> fires at [src.target]!", 1)
		spawn(0)
			Beam(target,beam_type,'icons/effects/beam.dmi',20, 10, delay)
		if(prob(50))
			playsound(user, 'sound/weapons/marauder.ogg', 100, 1)
		else
			playsound(user, 'sound/weapons/hivebotlaser.ogg', 100, 1)
		//var/obj/item/projectile/hivebotbullet/A = new /obj/item/projectile/hivebotbullet(user:loc)
		if(istype(target,/mob/living))
			var/mob/living/mob = target
			mob.deal_damage(laser_damage, BURN, PIERCE)
		return


/obj/effect/critter/hivebot/tele//this still needs work
	name = "Beacon"
	desc = "Some odd beacon thing"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar-off"
	health = 100
	max_health = 100
	aggressive = 0
	wanderer = 0
	opensdoors = 0
	can_target = 0
	firevuln = 0.5
	brutevuln = 1
	seekrange = 2
	damage_resistance = 10

	var/bot_type = "norm"
	var/bot_amt = 10
	var/spawn_delay = 600
	var/turn_on = 0
	var/auto_spawn = 1
	proc
		warpbots()


	New()
		..()
		var/datum/effect/effect/system/harmless_smoke_spread/smoke = new /datum/effect/effect/system/harmless_smoke_spread()
		smoke.set_up(5, 0, src.loc)
		smoke.start()
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>The [src] warps in!</B>", 1)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
		if(auto_spawn)
			spawn(spawn_delay)
				turn_on = 1
				auto_spawn = 0


	warpbots()
		icon_state = "def_radar"
		for(var/mob/O in viewers(src, null))
			O.show_message("\red The [src] turns on!", 1)
		while(bot_amt > 0)
			bot_amt--
			switch(bot_type)
				if("norm")
					new /obj/effect/critter/hivebot(get_turf(src))
				if("rapid")
					new /obj/effect/critter/hivebot/rapid(get_turf(src))
		spawn(100)
			del(src)
		return


	process()
		if((health < (max_health/2)) && (!turn_on))
			if(prob(2))//Might be a bit low, will mess with it likely
				turn_on = 1
		if(turn_on == 1)
			warpbots()
			turn_on = 2
		..()

/obj/effect/critter/hivebot/tele/massive
	bot_type = "norm"
	bot_amt = 30
	auto_spawn = 0

/obj/effect/critter/hivebot/tele/rapid
	bot_type = "rapid"


/obj/effect/critter/hivebot/tele/strikeforce
	name = "Strikeforce Beacon"
	team = "HIVE"
	bot_amt = 8
	spawn_delay = 300

	warpbots()
		icon_state = "def_radar"
		for(var/mob/O in viewers(src, null))
			O.show_message("\red The [src] turns on!", 1)
		while(bot_amt > 0)
			bot_amt--
			var/obj/effect/critter/hivebot/H = new/obj/effect/critter/hivebot/rapid(get_turf(src))
			H.team = team
		var/obj/effect/critter/hivebot/H = new/obj/effect/critter/hivebot/laser(get_turf(src))
		H.team = team
		H = new/obj/effect/critter/hivebot/laser(get_turf(src))
		H.team = team
		spawn(100)
			del(src)
		return


/obj/effect/critter/hivebot/tele/strikeforce/red
	team = "OTHERHIVE"
