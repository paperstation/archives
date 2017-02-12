var/roundExplosions = 1

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
	if(!epicenter) return
	if(devastation_range > 30) devastation_range = 30
	if(heavy_impact_range > 30) heavy_impact_range = 30
	if(light_impact_range > 30) light_impact_range = 30
	spawn(0)
		defer_powernet_rebuild = 1
		if (!istype(epicenter, /turf))
			epicenter = get_turf(epicenter.loc)

		for(var/mob/M in mobz)
			if(M.client)
				if((devastation_range > 1) && (heavy_impact_range > 3) && (light_impact_range > 2))
					shake_camera(M, 30, 1)
					if(prob(40))
						M << sound('distantexplosion.ogg', volume=rand(70, 90))
					if(prob(40))
						M << sound('exp1.ogg', volume=5)
					if(prob(40))
						M << sound('exp2.ogg', volume=5)
					if(prob(40))
						M << sound('exp3.ogg', volume=5)
					if(prob(40))
						M << sound('exp4.ogg', volume=5)
					if(prob(40))
						M << sound('exp5.ogg', volume=5)
					if(prob(40))
						M << sound('exp6.ogg', volume=5)


		if((heavy_impact_range > 1) && (light_impact_range > 1))
			var/turf/location = epicenter.loc
			for(var/turf/simulated/floor/target_tile in range(0,location))
				if(target_tile.parent && target_tile.parent.group_processing)
					target_tile.parent.suspend_group_processing()

				var/datum/gas_mixture/napalm = new

				if(flash_range)
					napalm.toxins = light_impact_range
				else
					napalm.toxins = 0
				napalm.temperature = 400+T0C

				target_tile.assume_air(napalm)
				spawn (0) target_tile.hotspot_expose(700, 400)


		if(light_impact_range > 1)
			playsound(epicenter.loc, "explosion", 70, 1, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'bang.ogg', 100, 0, round(devastation_range*2,1) )

		if(heavy_impact_range > 3)
			playsound(epicenter.loc, 'explosion_big.ogg', 100, 1, round(devastation_range,1) )
			playsound(epicenter.loc, 'explosionfar.ogg', 100, 1, round(devastation_range,1) )
			playsound(epicenter.loc, "explosion", 100, 1, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'exp1.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'exp2.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'exp3.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'exp4.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'exp5.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'exp6.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'Glassbr1.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'Glassbr2.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'Glassbr3.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'robotgib.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'smoke.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'bolts.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'pipesteam.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'meteorimpact.ogg', 70, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'impact_metal.ogg', 100, 0, round(devastation_range,1) )
			if(prob(40))
				playsound(epicenter.loc, 'impact_metal2.ogg', 100, 0, round(devastation_range,1) )

		if (adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

		if(light_impact_range > 1)
			var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
			s.set_up(2, 1, epicenter)
			s.start()

			var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
			smoke.set_up(2, 0, epicenter)
			smoke.start()

		if(heavy_impact_range > 1)
			playsound(epicenter.loc, 'turbulence.ogg', 100, 1, round(devastation_range*2,1) )
			var/datum/effects/system/explosion/E = new/datum/effects/system/explosion()
			E.set_up(epicenter)
			E.start()

		if(prob(20))
			for(var/mob/living/carbon/human/Q in range(light_impact_range, epicenter))
				Q.removePart(pick("hand_right", "hand_left", "arm_right", "arm_left", "leg_right", "leg_left", "foot_right", "foot_left"))

		var/list/exTurfs = list()

		if(roundExplosions)
			for(var/turf/T in circlerange(epicenter,light_impact_range))
				exTurfs += T
		else
			for(var/turf/T in range(light_impact_range, epicenter))
				exTurfs += T

		for(var/turf/T in exTurfs)
			if(prob(10))
				var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
				s.set_up(1, 1, T)
				s.start()
			if(prob(10))
				var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
				smoke.set_up(1, 0, T)
				smoke.start()
			//LOL INFINITE EXPLOSION
			//explosion(T,1,4,8,8,1)
			var/distance = 0
			if(roundExplosions)
				distance = get_dist_euclidian(epicenter, T)
			else
				distance = get_dist(epicenter, T)
			if(distance < 0)
				distance = 0
			if(distance < devastation_range)
				for(var/atom/object in T.contents)
					object.ex_act(1)
				if(prob(5))
					T.ex_act(2)
				else
					T.ex_act(1)
			else if(distance < heavy_impact_range)
				for(var/atom/object in T.contents)
					object.ex_act(2)
				T.ex_act(2)
			else if (distance == heavy_impact_range)
				for(var/atom/object in T.contents)
					object.ex_act(2)
				if(prob(15) && devastation_range > 2 && heavy_impact_range > 2)
					secondaryexplosion(T, 1)
				else
					T.ex_act(2)
			else if(distance <= light_impact_range)
				for(var/atom/object in T.contents)
					object.ex_act(3)
				T.ex_act(3)
			for(var/mob/living/carbon/mob in T)
				flick("flash", mob:flash)

		defer_powernet_rebuild = 0
	return 1



proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		sleep(2)
		if(prob(50))
			tile.ex_act(2)
		if(prob(10))
			var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
			s.set_up(1, 1, tile)
			s.start()
		if(prob(10))
			var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
			smoke.set_up(1, 0, tile)
			smoke.start()