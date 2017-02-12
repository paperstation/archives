//Contains Fire / Explosion / Implosion related reagents.
datum
	reagent
		combustible/
			name = "fire stuff"

		combustible/napalm //This is used for the smoke/napalm reaction.
			name = "phlogiston"
			id = "napalm"
			description = "It appears to be liquid fire."
			reagent_state = LIQUID
			fluid_r = 250
			fluid_b = 0
			fluid_g = 175
			volatility = 1
			transparency = 175
			var/temp_fire = 4000
			var/temp_deviance = 1000
			var/size_divisor = 40
			var/mob_burning = 33
			hygiene_value = 1 // with purging fire

			reaction_turf(var/turf/T, var/volume)
				if (!holder) //Wire: Fix for Cannot read null.total_temperature
					return
				if(holder.total_temperature <= T0C - 50) return //Too cold. Doesnt work.
				var/SD = size_divisor
				src = null
				var/radius = min(max(0,volume/SD),8)
				fireflash_sm(T, radius, rand(temp_fire - temp_deviance, temp_fire + temp_deviance), 500)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				if (!holder) //Wire: Fix for Cannot read null.total_temperature
					return
				if(holder.total_temperature <= T0C - 50) return
				var/MB = mob_burning
				src = null
				var/mob/living/L = M
				if(istype(L))
					L.update_burning(MB)
				if (method == INGEST)
					M.TakeDamage("All", 0, min(max(15, volume_passed * 3), 45), 0, DAMAGE_BURN)
					boutput(M, "<span style=\"color:red\">It burns!</span>")
					M.emote("scream")
				return

			on_mob_life(var/mob/M)
				if (!holder) //Wire: Fix for Cannot read null.total_temperature
					return
				if(holder.total_temperature <= T0C - 50) return
				if(!M) M = holder.my_atom
				var/mob/living/L = M
				if(istype(L))
					L.update_burning(2)
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("fire",8)
				P.growth -= 12

		combustible/napalm/firedust
			name = "phlogiston dust"
			id = "firedust"
			description = "And this is solid fire. However that works."
			dispersal = 4
			temp_fire = 1500
			temp_deviance = 500
			transparency = 255
			size_divisor = 80
			mob_burning = 15

		combustible/napalm_goo  // adapated from weldfuel
			name = "napalm"
			id = "napalm_goo"
			description = "A highly flammable jellied fuel."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_b = 50
			fluid_g = 100
			transparency = 150

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature > T0C + 100)
					var/radius = min(max(0,volume*0.15),8)
					fireflash_sm(get_turf(holder.my_atom), radius, rand(3000, 6000), 500)
					if(holder)
						holder.del_reagent(id)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!T.reagents) T.create_reagents(volume)
				T.reagents.add_reagent("napalm", volume, null)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH)
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.update_burning(70)
						if(!M.stat)
							M.emote("scream")
				return

			on_mob_life(var/mob/M)

				var/mob/living/L = M
				if(istype(L) && L.burning)
					L.update_burning(10)
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",1)

		combustible/kerosene
			name = "kerosene"
			id = "kerosene"
			description = "A substance widely applied as fuel for aviation vehicles and solvent for metal alloys (when heated)."
			reagent_state = LIQUID
			fluid_r = 250
			fluid_g = 250
			fluid_b = 250
			transparency = 255

			reaction_obj(var/obj/O, var/volume)
				if (!holder)
					return
				if (volume >= 5 && holder.total_temperature >= T0C + 400 && (istype(O, /obj/steel_beams) || (O.material && O.material.mat_id == "steel")))
					O.visible_message("<span style='color:red'>[O] melts!</span>")
					qdel(O)

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature > T0C + 600)
					var/radius = min(max(0,volume*0.15),8)
					var/list/affected = fireflash_sm(get_turf(holder.my_atom), radius, rand(3000, 6000), 500)
					for (var/turf/T in affected)
						for (var/obj/steel_beams/O in T)
							O.visible_message("<span style='color:red'>[O] melts!</span>")
							qdel(O)
					if(holder)
						holder.del_reagent(id)
				return

			reaction_turf(var/turf/simulated/T, var/volume)
				if (!holder)
					return
				if (!istype(T) || volume < 5 || holder.total_temperature < T0C + 400)
					return
				if (T.material && T.material.mat_id == "steel")
					T.visible_message("<span style='color:red'>[T] melts!</span>")
					T.ex_act(2)

		combustible/thermite
			name = "thermite"
			id = "thermite"
			description = "Thermite burns at an incredibly high temperature. Can be used to melt walls."
			reagent_state = SOLID
			fluid_r = 85
			fluid_g = 0
			fluid_b = 0
			transparency = 255

			reaction_temperature(exposed_temperature, exposed_volume)
				var/turf/simulated/A = holder.my_atom
				if(!istype(A)) return

				if(exposed_temperature >= T0C + 100)
					var/datum/reagents/Holder = holder
					var/Id = id
					var/Volume = volume
					src = null
					Holder.del_reagent(Id)
					fireflash_sm(A, 0, rand(20000, 25000) + Volume * 2500, 0, 0, 1) // Bypasses the RNG roll to melt walls (Convair880).

					/*var/turf/simulated/floor/F = A.ReplaceWithFloor()
					F.to_plating()
					F.burn_tile()*/
					return

				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH)
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.set_burning(100)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(istype(T, /turf/simulated))
					if(!T.reagents) T.create_reagents(volume)
					T.reagents.add_reagent("thermite", volume, null)
					T.overlays = null
					T.overlays = image('icons/effects/effects.dmi',icon_state = "thermite")
					if (T.active_hotspot)
						T.reagents.temperature_reagents(T.active_hotspot.temperature, T.active_hotspot.volume, 10, 300)
				return


		combustible/smokepowder
			name = "smoke powder"
			id = "smokepowder"
			description = "Produces smoke when heated."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 230
			var/ignited = 0

			pooled()
				..()
				ignited = 0

			reaction_temperature(exposed_temperature, exposed_volume) //ugh fuck this proc seriously
				if(exposed_temperature > T0C + 100 && !ignited)

					// Instant foam and smoke reactions are handled in Chemistry-Holder.dm (Convair880).
					var/turf/T = get_turf(holder.my_atom)
					var/mob/our_user = null
					var/our_fingerprints = null

					// Sadly, we don't automatically get a mob reference under most circumstances.
					// If there's an existing lookup proc and/or better solution, I haven't found it yet.
					// If everything else fails, maybe there are fingerprints on the container for us to check though?
					if (ismob(holder.my_atom)) // Our mob, the container.
						our_user = holder.my_atom
					else if (holder && holder.my_atom && (ismob(holder.my_atom.loc))) // Backpacks etc.
						our_user = holder.my_atom.loc
					else
						our_user = usr
						if (holder.my_atom.fingerprintslast) // Our container. You don't necessarily have to pick it up to transfer stuff.
							our_fingerprints = holder.my_atom.fingerprintslast
						else if (holder.my_atom.loc.fingerprintslast) // Backpacks etc.
							our_fingerprints = holder.my_atom.loc.fingerprintslast

					//DEBUG("Heat-triggered smoke powder reaction: our user is [our_user ? "[our_user]" : "*null*"].[our_fingerprints ? " Fingerprints: [our_fingerprints]" : ""]")
					if (our_user && ismob(our_user))
						logTheThing("combat", our_user, null, "Heat-triggered [src.name] chemical reaction [log_reagents(holder.my_atom)] at [T ? "[log_loc(T)]" : "null"].")
					else
						logTheThing("combat", our_user, null, "Heat-triggered [src.name] chemical reaction [log_reagents(holder.my_atom)] at [T ? "[log_loc(T)]" : "null"].[our_fingerprints ? " Container last touched by: [our_fingerprints]." : ""]")

					ignited = 1
					smoke_reaction(holder, min(round(volume / 5) + 1, 4), get_turf(holder.my_atom))

		combustible/sonicpowder
			name = "hootingium"
			id = "sonicpowder"
			description = "Produces a loud bang when heated."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 230
			penetrates_skin = 1 // coat them with it?
			var/no_fluff = 0

			reaction_temperature(exposed_temperature, exposed_volume)
				if(reacting) return
				if(exposed_temperature > T0C + 100)
					reacting = 1
					var/location = get_turf(holder.my_atom)
					var/hootmode = prob(5)

					if (src.no_fluff == 0)
						if (hootmode)
							playsound(location, "sound/misc/hoot.ogg", 100, 1)
						else
							playsound(location, "sound/weapons/flashbang.ogg", 25, 1)

					for (var/mob/living/M in all_hearers(world.view, location))
						if (issilicon(M) || isintangible(M))
							continue

						if (src.no_fluff == 0)
							if (!M.ears_protected_from_sound())
								boutput(M, "<span style=\"color:red\"><b>[hootmode ? "HOOT" : "BANG"]</b></span>")
							else
								continue

						var/checkdist = get_dist(M, location)
						var/weak = max(0, holder.get_reagent_amount(id) * 0.2 * (3 - checkdist))
						var/misstep = 40
						var/ear_damage = max(0, holder.get_reagent_amount(id) * 0.2 * (3 - checkdist))
						var/ear_tempdeaf = max(0, holder.get_reagent_amount(id) * 0.2 * (5 - checkdist)) //annoying and unfun so reduced dramatically

						M.apply_sonic_stun(weak, 0, misstep, 0, 0, ear_damage, ear_tempdeaf)

					for (var/mob/living/silicon/S in all_hearers(world.view, location))
						if (src.no_fluff == 0)
							if (!S.ears_protected_from_sound())
								boutput(S, "<span style=\"color:red\"><b>[hootmode ? "HOOT" : "BANG"]</b></span>")
							else
								continue

						var/checkdist = get_dist(S, location)
						var/C_weak = max(0, holder.get_reagent_amount(id) * 0.2 * (3 - checkdist))

						S.apply_sonic_stun(C_weak, 0)

					holder.del_reagent(id)

			on_mob_life(var/mob/M) // fuck you jerk chemists (todo: a thing to self-harm borgs too, maybe ex_act(3) to the holder? I D K
				if(!M) M = holder.my_atom
				if(prob(70))
					M.take_brain_damage(1)
				..(M)
				return

		combustible/sonicpowder/nofluff
			name = "hootingium"
			id = "sonicpowder_nofluff"
			no_fluff = 1

// Don't forget to update Reagents-Recipes.dm too, we have duplicate code for sonic and flash powder there (Convair880).

		combustible/flashpowder
			name = "flash powder"
			id = "flashpowder"
			description = "Produces a bright flash of light when heated."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 230
			penetrates_skin = 1 // coat them with it?

			reaction_temperature(exposed_temperature, exposed_volume)
				if(reacting) return // fix for a potential game crashing exploit with smokes
				if(exposed_temperature > T0C + 100)
					reacting = 1
					var/location = get_turf(holder.my_atom)
					var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
					s.set_up(2, 1, location)
					s.start()

					for (var/mob/living/M in all_viewers(5, location))
						if (issilicon(M) || isintangible(M))
							continue

						var/dist = get_dist(M, location)
						var/stunned = max(0, holder.get_reagent_amount(id) * (3 - dist) * 0.1)
						var/eye_damage = max(0, holder.get_reagent_amount(id) * (2 - dist) * 0.1)
						var/eye_blurry = max(0, holder.get_reagent_amount(id) * (5 - dist) * 0.2)

						M.apply_flash(60, 0, max(0, stunned), 0, max(0, eye_blurry), max(0, eye_damage))

					for (var/mob/living/silicon/M in all_viewers(world.view, location))
						var/checkdist = get_dist(M, location)
						var/C_weakened = max(0, holder.get_reagent_amount(id) * (3 - checkdist) * 0.1)
						var/C_stunned = max(0, holder.get_reagent_amount(id) * (5 - checkdist) * 0.1)

						M.apply_flash(30, max(0, C_weakened), max(0, C_stunned))

					holder.del_reagent(id)

		//explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)

/*		combustible/merculite
			name = "Merculite"
			id = "merculite"
			description = "Highly flammable and explosive compound. Very sticky."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_g = 125
			fluid_b = 75
			transparency = 175

			reaction_temperature(exposed_temperature, exposed_volume)
				if(temperature > 330)
					var/extra_range = round(min(max((((temperature - T0C) / 10) - 6),0),3)) //Usually 0. Unless someone somehow manages to heat this without it exploding.
					var/max_range = round(min(max((volume / 10),1),8),1) + extra_range
					var/heavy_range = round(max((max_range / 2),1))
					var/devastation_range = min(max(extra_range, 1),3)
					explosion(get_turf(holder.my_atom), devastation_range, heavy_range, max_range, max_range)
					holder.del_reagent(id)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				if(!O.reagents) O.create_reagents(50)
				O.reagents.add_reagent("merculite", 3, null)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!T.reagents) T.create_reagents(50)
				T.reagents.add_reagent("merculite", 3, null)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH)
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.set_burning(100)
				return */

		combustible/infernite // COGWERKS CHEM REVISION PROJECT. this could be Chlorine Triflouride, a really mean thing
			name = "chlorine triflouride"
			id = "infernite"
			description = "An extremely volatile substance, handle with the utmost care."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 200
			fluid_b = 200
			volatility = 1.5
			transparency = 175
			depletion_rate = 4
			dispersal = 2
			hygiene_value = 2 // with purging fire

			/*reaction_temperature(exposed_temperature, exposed_volume)
				if(temperature > T0C + 15)
					fireflash(get_turf(holder.my_atom), min(max(0,volume/10),3))
					holder.del_reagent(id)
				return*/

			reaction_obj(var/obj/O, var/volume)
				src = null
				if (isnull(O)) return
				if(istype(O, /obj/item))
					var/obj/item/I = O
					if(!I.burn_possible)
						I.burn_possible = 1
					if(!I.health)
						I.health = 10
					if(!I.burn_output)
						I.burn_output = 1200
					if(!I.burning)
						if(!isnull(I)) // just in case
							I.combust()
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				//if(!T.reagents) T.create_reagents(50)
				//T.reagents.add_reagent("infernite", 5, null)
				if (volume < 3)
					return
				var/radius = min((volume - 3) * 0.15, 3)
				fireflash_sm(T, radius, 4500 + volume * 500, 350)

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH || method == INGEST)
					var/mob/living/L = M
					if(istype(L))
						L.update_burning(50)
				if (method == INGEST)
					M.TakeDamage("All", 0, min(max(30, volume * 6), 90), 0, DAMAGE_BURN)
					boutput(M, "<span style=\"color:red\">It burns!</span>")
					M.emote("scream")
				return

			on_mob_life(var/mob/M)

				var/mob/living/L = M
				if(istype(L) && L.burning)
					L.update_burning(5)
				..(M)

		combustible/foof // this doesn't work yet
			name = "FOOF"
			id = "foof"
			description = "Dioxygen Diflouride, a ludicrously powerful oxidizer. Run away."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 200
			fluid_b = 200
			transparency = 175
			depletion_rate = 1.2

			/*reaction_temperature(exposed_temperature, exposed_volume)
				if(temperature > T0C + 15)
					fireflash(get_turf(holder.my_atom), min(max(0,volume/10),3))
					holder.del_reagent(id)
				return*/

			/*reaction_obj(var/obj/O, var/volume)
				src = null
				if (O && ispath(O, /obj/item))
					var/obj/item/I = O
					if(!I.burning)
						I.combust()
				return*/

			reaction_turf(var/turf/T, var/volume)
				src = null
				//if(!T.reagents) T.create_reagents(50)
				//T.reagents.add_reagent("infernite", 5, null)
				tfireflash(T, min(max(0,volume/10),8), 7000)
				if(!istype(T, /turf/space))
					spawn(max(10, rand(20))) // let's burn right the fuck through the floor
						switch(volume)
							if(0 to 15)
								if(prob(15))
									T.visible_message("<span style=\"color:red\">[T] melts!</span>")
									T.ex_act(2)
							if(16 to INFINITY)
								T.visible_message("<span style=\"color:red\">[T] melts!</span>")
								T.ex_act(2)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH || method == INGEST)
					var/mob/living/L = M
					if(istype(L))
						L.update_burning(90)
				if (method == INGEST)
					M.TakeDamage("All", 0, min(max(30, volume * 6), 90), 0, DAMAGE_BURN)
					boutput(M, "<span style=\"color:red\">It burns!</span>")
					M.emote("scream")
				return

			on_mob_life(var/mob/M)

				var/mob/living/L = M
				if(istype(L))
					L.update_burning(50)
				..(M)

		combustible/thalmerite // COGWERKS CHEM REVISION PROJECT. pretty much a magic chem, can leave alone
			name = "pyrosium"
			id = "thalmerite"
			description = "This strange compound seems to slowly heat up all by itself. Very sticky."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 200
			fluid_b = 150
			transparency = 150

			reaction_temperature(exposed_temperature, exposed_volume)
				if(holder.total_temperature >= 1000) holder.del_reagent(id)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				if (O)
					if(!O.reagents)
						O.create_reagents(50)
					O.reagents.add_reagent("thalmerite", 5, null)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (T)
					if(!T.reagents)
						T.create_reagents(50)
					T.reagents.add_reagent("thalmerite", 5, null)
				return

		combustible/argine
			name = "argine"
			id = "argine"
			description = "This strange material seems to ignite & explode on low temperatures."
			reagent_state = LIQUID
			fluid_r = 50
			fluid_g = 200
			fluid_b = 200
			transparency = 200

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature < T0C)
					if(holder)
						explosion(holder.my_atom, get_turf(holder.my_atom), 2, 3, 4, 1)
						holder.del_reagent(id)
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				return
			reaction_turf(var/turf/T, var/volume)
				src = null
				return

		combustible/sorium
			name = "sorium"
			id = "sorium"
			description = "Flammable material that causes a powerful shockwave on detonation."
			reagent_state = LIQUID
			fluid_r = 90
			fluid_g = 100
			fluid_b = 200
			transparency = 200

			reaction_temperature(exposed_temperature, exposed_volume)
				if(src.reacting)
					return
				if(exposed_temperature > T0C + 200)
					src.reacting = 1
					var/atom/source = get_turf(holder.my_atom)
					new/obj/decal/shockwave(source)
					playsound(source, "sound/weapons/flashbang.ogg", 25, 1)
					for(var/atom/movable/M in view(2 + (volume > 30 ? 1:0), source))
						if(M.anchored || M == source || M.throwing) continue
						spawn(0) M.throw_at(get_edge_cheap(source, get_dir(source, M)), 20 + round(volume * 2), 1 + round(volume / 10))
					if (holder)
						holder.del_reagent(id)
				return

			//Comment this out if you notice a lot of crashes. (It's probably a really bad idea to have this in)
			reaction_turf(var/turf/T, var/volume)
				if(prob(75)) return
				var/datum/reagent/us = src
				src = null
				if(!T.reagents) T.create_reagents(50)
				T.reagents.add_reagent(us.id, 5, null)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				return

		combustible/liquiddarkmatter
			name = "liquid dark matter"
			id = "ldmatter"
			description = "What has science done ... It's concentrated dark matter in liquid form. And i thought you needed plutonic quarks for that."
			reagent_state = LIQUID
			fluid_r = 33
			fluid_g = 0
			fluid_b = 33
			value = 6 // 3 1 1 1

			reaction_temperature(exposed_temperature, exposed_volume)
				if(src.reacting)
					return
				if(exposed_temperature > T0C + 200)
					src.reacting = 1
					ldmatter_reaction(holder, volume, id)
				return

			//Comment this out if you notice a lot of crashes. (It's probably a really bad idea to have this in)
			reaction_turf(var/turf/T, var/volume)
				if(prob(75)) return

				var/datum/reagent/us = src
				src = null
				if(!T.reagents) T.create_reagents(50)
				T.reagents.add_reagent(us.id, 5, null)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				return

		combustible/something
			name = "something"
			id = "something"
			description = "What is this thing?  None of the normal tests have been able to determine what exactly this is, just that it is benign."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 100
			fluid_b = 100
			transparency = 250

		combustible/fuel // COGWERKS CHEM REVISION PROJECT. treat like acetylene or similar basic hydrocarbons for other reactions
			name = "welding fuel"
			id = "fuel"
			description = "A highly flammable blend of basic hydrocarbons, mostly Acetylene. Useful for both welding and organic chemistry, and can be fortified into a heavier oil."
			reagent_state = LIQUID
			volatility = 1
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 230

			var/max_radius = 7
			var/min_radius = 0
			var/volume_radius_modifier = -0.15
			var/volume_radius_multiplier = 0.09
			var/explosion_threshold = 100
			var/min_explosion_radius = 0
			var/max_explosion_radius = 4
			var/volume_explosion_radius_multiplier = 0.005
			var/volume_explosion_radius_modifier = 0
			var/combustion_temp = T0C + 200

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature > combustion_temp)
					if(volume < 1)
						if (holder)
							holder.del_reagent(id)
						return
					var/turf = get_turf(holder.my_atom)
					var/radius = min(max(min_radius, volume * volume_radius_multiplier + volume_radius_modifier), max_radius)
					fireflash_sm(turf, radius, 2200 + radius * 250, radius * 50)
					if(holder && volume >= explosion_threshold)
						if(holder.my_atom)
							holder.my_atom.visible_message("<span style=\"color:red\"><b>[holder.my_atom] explodes!</b></span>")
							// Added log entries (Convair880).
							message_admins("Fuel tank explosion ([holder.my_atom], reagent type: [id]) at [log_loc(holder.my_atom)]. Last touched by: [holder.my_atom.fingerprintslast ? "[holder.my_atom.fingerprintslast]" : "*null*"].")
							logTheThing("bombing", holder.my_atom.fingerprintslast, null, "Fuel tank explosion ([holder.my_atom], reagent type: [id]) at [log_loc(holder.my_atom)]. Last touched by: [holder.my_atom.fingerprintslast ? "[holder.my_atom.fingerprintslast]" : "*null*"].")
						var/boomrange = min(max(min_explosion_radius, round(volume * volume_explosion_radius_multiplier + volume_explosion_radius_modifier)), max_explosion_radius)
						explosion(holder.my_atom, turf, -1,-1,boomrange,1)
					if (holder)
						holder.del_reagent(id)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!T.reagents) T.create_reagents(50)
				T.reagents.add_reagent("fuel", volume, null)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == TOUCH)
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.update_burning(30)
				return

			on_mob_life(var/mob/M)

				var/mob/living/L = M
				if(istype(L) && L.burning)
					L.update_burning(2)
				..(M)

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison", 1)

			epichlorohydrin
				name = "epichlorohydrin"
				id = "epichlorohydrin"
				description = "A highly reactive, flammable, mildly toxic compound."
				reagent_state = LIQUID
				fluid_r = 220
				fluid_g = 220
				fluid_b = 255
				transparency = 128
				max_radius = 4
				min_radius = 0
				combustion_temp = T0C + 385
				volume_radius_multiplier = 0.05
				explosion_threshold = 1000
				volume_explosion_radius_modifier = -4.5

		// cogwerks - gunpowder test. IS THIS A TERRIBLE GODDAMN IDEA? PROBABLY

		combustible/blackpowder
			name = "black powder"
			id = "blackpowder"
			description = "A dangerous explosive material."
			reagent_state = SOLID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			volatility = 2.5
			transparency = 255
			depletion_rate = 0.05
			penetrates_skin = 1 // think of it as just being all over them i guess

			reaction_temperature(exposed_temperature, exposed_volume)
				if(src.reacting)
					return
				if(exposed_temperature > T0C + 200)
					src.reacting = 1
					var/location = get_turf(holder.my_atom)
					var/our_amt = holder.get_reagent_amount(src.id)
					var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
					s.set_up(2, 1, location)
					s.start()
					spawn(rand(5,15))
						if(!holder || !holder.my_atom) return // runtime error fix
						switch(our_amt)
							if(0 to 20)
								holder.my_atom.visible_message("<b>The black powder ignites!</b>")
								var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
								smoke.set_up(1, 0, location)
								smoke.start()
								explosion(holder.my_atom, location, -1, -1, pick(0,1), 1)
								holder.del_reagent(id)
							if(21 to 80)
								holder.my_atom.visible_message("<b>[holder.my_atom] flares up!</b>")
								fireflash(location,0)
								explosion(holder.my_atom, location, -1, -1, 1, 2)
								holder.del_reagent(id)
							if(81 to 160)
								holder.my_atom.visible_message("<span style=\"color:red\"><b>[holder.my_atom] explodes!</b></span>")
								explosion(holder.my_atom, location, -1, 1, 2, 3)
								holder.del_reagent(id)
							if(161 to 300)
								holder.my_atom.visible_message("<span style=\"color:red\"><b>[holder.my_atom] violently explodes!</b></span>")
								explosion(holder.my_atom, location, 1, 3, 6, 8)
								holder.del_reagent(id)
							if(301 to INFINITY)
								holder.my_atom.visible_message("<span style=\"color:red\"><b>[holder.my_atom] detonates in a huge blast!</b></span>")
								explosion(holder.my_atom, location, 3, 6, 12, 15)
								holder.del_reagent(id)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space))
					if(volume >= 5)
						if(!locate(/obj/decal/cleanable/dirt) in T)
							var/obj/decal/cleanable/dirt/D = new /obj/decal/cleanable/dirt(T)
							D.name = "black powder"
							D.desc = "Uh oh. Someone better clean this up!"
							if(!D.reagents) D.create_reagents(10)
							D.reagents.add_reagent("blackpowder", 5, null)
				return

		combustible/nitrogentriiodide
			//This is the parent and should not be spawned
			name = "Nitrogen Triiodide"
			id = "nitrotri_parent"
			description = "A chemical that is stable when in liquid form, but becomes extremely volatile when dry."
			reagent_state = LIQUID
			penetrates_skin = 1
			volatility = 1
			fluid_r = 48
			fluid_g = 22
			fluid_b = 64
			var/is_dry = 0

			pooled()
				..()
				is_dry = 0

			unpooled()
				..()
				bang()

			New()
				bang()

			proc/bang()
				if(holder && holder.my_atom)
					holder.my_atom.visible_message("<b>The powder detonates!</b>")

					var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
					smoke.set_up(1, 0, holder.my_atom.loc)
					smoke.start()

					var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
					s.set_up(5, 1, holder.my_atom.loc, ,"#cb5e97")
					s.start()

					var/max_dev = min(round(1 * (volume/300)), 1)
					var/max_heavy = min(round(3 * (volume/300)), 3)
					var/max_light = min(round(6 * (volume/300)), 6)
					var/max_flash = min(round(9 * (volume/300)), 9)

					explosion(holder.my_atom, holder.my_atom.loc, max_dev, max_heavy, max_light, max_flash)

					var/datum/reagents/H = holder
					spawn(0)
						src = null
						H.del_reagent("nitrotri_wet")
						H.del_reagent("nitrotri_dry")
						H.del_reagent("nitrotri_parent")

			proc/dry()
				if(is_dry) return
				is_dry = 1
				var/datum/reagents/H = holder
				var/vol = volume
				if(!H)
					return

				src = null
				H.del_reagent(reagent="nitrotri_wet")
				H.add_reagent(reagent="nitrotri_dry", amount=vol, donotreact=1)


			reaction_turf(var/turf/T, var/volume)
				src = null
				if(!istype(T, /turf/space) && volume >= 5 && !locate(/obj/decal/cleanable/nitrotriiodide) in T)
					return new /obj/decal/cleanable/nitrotriiodide(T)

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature > T0C + 100) //Fastest way to dry this. Also the most terrible idea.
					dry()

		combustible/nitrogentriiodide/wet
			id = "nitrotri_wet"
			volatility = 1

			New()
				spawn(200 + rand(10, 600) * rand(1, 4)) //Random time until it becomes HIGHLY VOLATILE
					dry()


			unpooled()
				spawn(200 + rand(10, 600) * rand(1, 4)) //Random time until it becomes HIGHLY VOLATILE
					dry()



		combustible/nitrogentriiodide/dry
			id = "nitrotri_dry"
			volatility = 2.5
			description = "A chemical that is stable when in liquid form, but becomes extremely volatile when dry. This is dry. Uh oh."
			is_dry = 1
			reagent_state = SOLID

			New()
				spawn(10 * rand(11,600)) //At least 11 seconds, at most 10 minutes
					bang()

			unpooled()
				spawn(10 * rand(11,600)) //At least 11 seconds, at most 10 minutes
					bang()

			reaction_turf(var/turf/T, var/volume)
				var/obj/decal/cleanable/nitrotriiodide/NT = ..()
				if(NT)
					NT.Dry() 	//Welp
					NT.bang()	//What did you expect would happen when splashing THE HIGHLY VOLATILE POWDER on the floor

			reaction_temperature(exposed_temperature, exposed_volume)
				bang()