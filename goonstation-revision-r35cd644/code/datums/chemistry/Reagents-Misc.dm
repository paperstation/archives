//Contains exotic or special reagents.
datum
	reagent
		nitroglycerin // Yes, this is a bad idea.
			name = "nitroglycerin"
			id = "nitroglycerin"
			description = "A miracle worker in treating cardiac failure. Very, very volatile and sensitive compound. Do not run while handling this. Do not throw this. Do not splash this."
			reagent_state = LIQUID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 255
			transparency = 128

			// power = SQRT(10V)
			// 0.1 -> 1
			// 0.2 -> 2
			// 0.9 -> 3
			// 1.6 -> 4
			// 10 -> 10
			// 250 -> 50
			// 1000 -> 100

			// brisance = LOG10(10V)
			// 1 -> 1
			// 10 -> 2
			// 100 -> 3
			// 1000 -> 4
			// ...

			// explosive properties
			// relatively inert as a solid (T <= 14°C)
			// rather explosive as a liquid (14 °C < T <= 50 °C)
			// explodes instantly as a gas (50 °C < T)

			proc/explode(var/turf/T, expl_reason, del_holder=1)
				message_admins("Nitroglycerin explosion (volume = [volume]) due to [expl_reason] at [showCoords(T.x, T.y, T.z)].")
				var/list/fh = holder.my_atom.fingerprintshidden
				var/context = "Fingerprints: [dd_list2text(fh)]"
				logTheThing("combat", usr, null, "is associated with a nitroglycerin explosion (volume = [volume]) due to [expl_reason] at [showCoords(T.x, T.y, T.z)]. Context: [context].")
				explosion_new(usr, T, sqrt(10 * volume), log(10 * volume, 10))
				holder.del_reagent("nitroglycerin")
				if (del_holder)
					qdel(holder.my_atom)

			reaction_temperature(exposed_temperature, exposed_volume)
				if (exposed_temperature <= T0C + 14)
					reagent_state = SOLID
				else if (exposed_temperature <= T0C + 50)
					if (reagent_state == SOLID)
						var/delta = exposed_temperature - holder.last_temp
						if (delta > 5 && prob(delta * 5))
							explode(get_turf(holder.my_atom), "rapid thawing")
							return
					reagent_state = LIQUID
				else
					explode(get_turf(holder.my_atom), "temperature change to gaseous form")

			reaction_turf(var/turf/T, var/volume)
				explode(T, "splash on turf")

			reaction_mob(var/mob/M, var/volume)
				explode(get_turf(M), "splash on [key_name(M)]")

			reaction_obj(var/obj/O, var/volume)
				explode(get_turf(O), "splash on [key_name(O)]")

			physical_shock(var/force)
				if (reagent_state == SOLID && force >= 4 && prob(force - (14 - holder.total_temperature) * 0.1))
					explode(get_turf(holder.my_atom), "physical trauma (force [force], usr: [key_name(usr)]) in solid state")
				else if (reagent_state == LIQUID && prob(force * 6))
					explode(get_turf(holder.my_atom), "physical trauma (force [force], usr: [key_name(usr)]) in liquid state")

			on_transfer(var/datum/reagents/source, var/datum/reagents/target, var/trans_volume)
				var/datum/reagent/nitroglycerin/target_ng = target.get_reagent("nitroglycerin")
				logTheThing("combat", usr, null, "caused physical shock to nitroglycerin by transferring [trans_volume]u from [source.my_atom] to [target.my_atom].")
				// mechanical dropper transfer (1u): solid at 14°C: 0%, liquid: 0%
				// classic dropper transfer (5u): solid at 14°C: 0% (due to min force cap), liquid: 20%
				// beaker transfer (10u): solid at -36°C: 0%, solid: 5%, liquid: 30%
				// the only safe way to transfer nitroglycerin is by freezing it
				// thenagain, it may explode when being thawed unless heated *very* slowly
				target_ng.physical_shock(round(0.45 * trans_volume))

		copper_nitrate
			name = "copper nitrate"
			id = "copper_nitrate"
			description = "An intermediary which sublimates at 180 °C."
			reagent_state = SOLID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 255
			transparency = 255

		glycerol
			name = "glycerol"
			id = "glycerol"
			description = "A sweet, non-toxic, viscous liquid. It is widely used as an additive."
			taste = "sweet"
			reagent_state = LIQUID
			fluid_r = 220
			fluid_g = 220
			fluid_b = 255
			transparency = 128

		aranesp
			name = "aranesp"
			id = "aranesp"
			description = "An illegal performance enhancing drug. Side effects might include chest pain, seizures, swelling, headache, fever... ... ..."
			fluid_r = 120
			fluid_g = 255
			fluid_b = 240
			transparency = 215
			value = 41 // 17 18 6

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					holder.my_atom:add_stam_mod_regen("aranesp", 15)
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					holder.my_atom:add_stam_mod_max("aranesp", 25)
				return

			on_remove()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
					holder.my_atom:remove_stam_mod_regen("aranesp")
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
					holder.my_atom:remove_stam_mod_max("aranesp")
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (prob(90))
					M.take_toxin_damage(1)
				if (prob(5)) M.emote(pick("twitch", "shake", "tremble","quiver", "twitch_v"))
				if (prob(8)) boutput(M, "<span style=\"color:blue\">You feel [pick("really buff", "on top of the world","like you're made of steel", "energized", "invigorated", "full of energy")]!</span>")
				if (prob(5))
					boutput(M, "<span style=\"color:red\">You cannot breathe!</span>")
					M.stunned++
					M.take_oxygen_deprivation(15)
					M.losebreath++
				..(M)
				return

		anti_fart
			name = "simethicone"
			id = "anti_fart"
			description = "This strange liquid seems to have no bubbles on the surface."
			reagent_state = LIQUID

		stimulants
			name = "stimulants"
			id = "stimulants"
			description = "A dangerous chemical cocktail that allows for seemingly superhuman feats for a short time ..."
			reagent_state = LIQUID
			fluid_r = 120
			fluid_g = 0
			fluid_b = 140
			transparency = 200
			value = 66 // vOv
			//addiction_prob = 25

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					holder.my_atom:add_stam_mod_regen("stims", 500)
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					holder.my_atom:add_stam_mod_max("stims", 500)
				return

			on_remove()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
					holder.my_atom:remove_stam_mod_regen("stims")
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
					holder.my_atom:remove_stam_mod_max("stims")
				return

			on_mob_life(var/mob/living/M)
				if (!M) M = holder.my_atom
				if (src.volume > 5)
					if (M.get_oxygen_deprivation())
						M.take_oxygen_deprivation(-5)
					if (M.get_toxin_damage())
						M.take_toxin_damage(-5)
					if (M.stunned)
						M.stunned = 0
					if (M.weakened)
						M.weakened = 0
					if (M.paralysis)
						M.paralysis = 0
					if (M.slowed)
						M.slowed = 0
					if (M.misstep_chance)
						M.change_misstep_chance(-INFINITY)
					M.HealDamage("All", 10, 10)
					M.dizziness = max(0,M.dizziness-10)
					M.drowsyness = max(0,M.drowsyness-10)
					M.sleeping = 0
				else
					M.take_toxin_damage(2)
					random_brute_damage(M, 1)
					if (prob(10))
						M.stunned += 3
				M.updatehealth()
				..(M)
				return

		hairgrownium //It..grows hair.  Not to be confused with the previous hair growth reagent, "wacky monkey cheeseonium"
			name = "hairgrownium"
			id = "hairgrownium"
			description = "A mysterious chemical purported to help grow hair. Often found on late-night TV infomercials."
			fluid_r = 100
			fluid_b = 100
			fluid_g = 255
			transparency = 205
			penetrates_skin = 1 // why wouldn't it, really
			value = 20 // 2 9 9

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				if (prob(10) && ishuman(M))
					var/mob/living/carbon/human/H = M
					switch(H.cust_one_state)
						if ("None","balding")
							H.cust_one_state = "cut"
						if ("cut","mohawk")
							H.cust_one_state = "short"
						if ("short")
							H.cust_one_state = "long"
						if ("long","emo")
							H.cust_one_state = "bedhead"
						if ("bedhead")
							H.cust_one_state = "dreads"
						if ("dreads")
							H.cust_one_state = "afro"
					if (H.gender == MALE)
						switch(H.cust_two_state)
							if ("None")
								H.cust_two_state = "chaplin"
							if ("chaplin","watson","selleck")
								H.cust_two_state = "vandyke"
							if ("vandyke","hip","neckbeard","gt","chin","hogan")
								H.cust_two_state = "fullbeard"
							if ("fullbeard")
								H.cust_two_state = "longbeard"

					H.set_face_icon_dirty()
				..(M)
				return

		super_hairgrownium //moustache madness
			name = "super hairgrownium"
			id = "super_hairgrownium"
			description = "A mysterious and powerful chemical purported to cause rapid hair growth."
			fluid_r = 100
			fluid_b = 100
			fluid_g = 255
			transparency = 205
			penetrates_skin = 1 // why wouldn't it, really
			value = 34 // 20 13 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				if (ishuman(M))
					var/somethingchanged = 0
					var/mob/living/carbon/human/H = M
					if (H.cust_one_state != "80s")
						H.cust_one_state = "80s"
						somethingchanged = 1
					if (H.gender == MALE && H.cust_two_state != "longbeard")
						H.cust_two_state = "longbeard"
						somethingchanged = 1
					H.set_face_icon_dirty()
					if (!(H.wear_mask && istype(H.wear_mask, /obj/item/clothing/mask/moustache)))
						somethingchanged = 1
						for (var/obj/item/clothing/O in H)
							if (istype(O,/obj/item/clothing/mask))
								H.u_equip(O)
								if (O)
									O.set_loc(H.loc)
									O.dropped(H)
									O.layer = initial(O.layer)

						var/obj/item/clothing/mask/moustache/moustache = new /obj/item/clothing/mask/moustache(H)
						H.equip_if_possible(moustache, H.slot_wear_mask)
						H.set_clothing_icon_dirty()
					if (somethingchanged) boutput(H, "<span style=\"color:red\">Hair bursts forth from every follicle on your head!</span>")
				..(M)
				return

		anima //This stuff is not done. Don't use it. Don't spoil it.
			name = "anima"
			id = "anima"
			description = "Anima ... The animating force of the universe."
			reagent_state = LIQUID
			fluid_r = 120
			fluid_g = 10
			fluid_b = 190
			transparency = 255
			depletion_rate = 0
			value = 539 // 2 3 28 6 500
			// last number: for 50u you take 100 points of health (assuming this is the first time it's been made by those people) so 2 points per 1u
			// that number is the value of those 2 points

			on_add()
				// Marq fix for cannot read null.my_atom
				if (!holder)
					return
				var/atom/A = holder.my_atom
				if (A)
					animate_flash_color_fill(A,"#5C0E80",-1, 10)

				if (hascall(holder.my_atom,"addOverlayComposition"))
					holder.my_atom:addOverlayComposition(/datum/overlayComposition/anima)

				if (ismob(A))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/swoosh, A))
						particleMaster.SpawnSystem(new /datum/particleSystem/swoosh/endless(A))
				return

			on_remove()
				var/atom/A = holder.my_atom
				if (A)
					animate_flash_color_fill(A,"#5C0E80", 1, 10)

				if (hascall(holder.my_atom,"removeOverlayComposition"))
					holder.my_atom:removeOverlayComposition(/datum/overlayComposition/anima)

				if (ismob(A))
					particleMaster.RemoveSystem(/datum/particleSystem/swoosh, A)

				return

			reaction_mob(var/mob/target, var/method=TOUCH, var/volume_passed)
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				if (volume < 5 || istype(O, /obj/critter) || istype(O, /obj/machinery/bot) || istype(O, /obj/decal) || O.anchored || O.invisibility) return
				O.visible_message("<span style=\"color:red\">The [O] comes to life!</span>")
				var/obj/critter/livingobj/L = new/obj/critter/livingobj(O.loc)
				O.loc = L
				L.name = "Living [O.name]"
				L.desc = "[O.desc]. It appears to be alive!"
				L.overlays += O
				L.health = rand(10, 150)
				L.atck_dmg = rand(1, 35)
				L.defensive = 1
				L.aggressive = pick(1,0)
				L.atkcarbon = pick(1,0)
				L.atksilicon = pick(1,0)
				L.opensdoors = pick(1,0)
				L.original_object = O
				animate_float(L, -1, 30)
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (prob(8))
					boutput(M, "<span style=\"color:red\">The voices ...</span>")
					M.playsound_local(M, pick(ghostly_sounds), 100, 1)

				return

		strange_reagent
			name = "strange reagent"
			id = "strange_reagent"
			description = "A glowing green fluid highly reminiscent of nuclear waste."
			reagent_state = LIQUID
			fluid_r = 160
			fluid_g = 232
			fluid_b = 94
			transparency = 255
			depletion_rate = 0.2
			value = 28 // 3 3 22

			reaction_mob(var/mob/target, var/method=TOUCH, var/volume_passed)
				src = null
				if (!volume_passed)
					return
				var/mob/living/carbon/M = target
				if (!istype(M))
					return
				if ((method == INGEST || (method == TOUCH && prob(25))) && (M.stat == 2))
					var/came_back_wrong = 0
					if (M.get_brute_damage() + M.get_burn_damage() >= 150)
						came_back_wrong = 1
					M.take_oxygen_deprivation(-INFINITY)
					M.take_toxin_damage(rand(0,15))
					M.TakeDamage("chest", rand(0,15), rand(0,15), 0, DAMAGE_CRUSH)
					M.updatehealth()
					M.stat = 0
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						if (H.ghost && H.ghost.mind && !(H.mind && H.mind.dnr)) // if they have dnr set don't bother shoving them back in their body
							H.ghost.show_text("<span style=\"color:red\"><B>You feel yourself being dragged out of the afterlife!</B></span>")
							H.ghost.mind.transfer_to(H)
							qdel(H.ghost)
						if (came_back_wrong || H.decomp_stage != 0 || (H.mind && H.mind.dnr)) //Wire: added the dnr condition here
							H.visible_message("<span style=\"color:red\"><B>[H]</B> starts convulsing violently!</span>")
							if (H.mind && H.mind.dnr)
								H.visible_message("<span style=\"color:red\"><b>[H]</b> seems to prefer the afterlife!</span>")
							H.make_jittery(1000)
							spawn(rand(20, 100))
								H.gib()
						else
							H.visible_message("<span style=\"color:red\">[H] seems to rise from the dead!</span>","<span style=\"color:red\">You feel hungry...</span>")
					else
						M.visible_message("<span style=\"color:red\">[M] seems to rise from the dead!</span>","<span style=\"color:red\">You feel hungry...</span>")
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				if (istype(O, /obj/critter))
					var/obj/critter/critter = O
					if (!critter.alive && critter.can_revive) //I should probably check for organic critters, but most robotic ones just blow up on death
						critter.health = initial(critter.health)
						critter.alive = 1
						critter.icon_state = initial(critter.icon_state)
						critter.density = initial(critter.density)
						critter.on_revive()
						critter.visible_message("<span style=\"color:red\">[critter] seems to rise from the dead!</span>")

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				if (prob(10))
					M.take_toxin_damage(2)
					random_brute_damage(M, 2)
					M.updatehealth()

				..(M)
				return

		carpet
			name = "carpet"
			id = "carpet"
			description = "A covering of thick fabric used on floors. This type looks particularly gross."
			reagent_state = LIQUID
			fluid_r = 112
			fluid_b = 69
			fluid_g = 19
			transparency = 255
			value = 4 // 2 2

			reaction_turf(var/turf/T, var/volume)
				if (T.icon == 'icons/turf/floors.dmi' && volume >= 5)
					spawn(15)
						T.icon_state = "grimy"
				src = null
				return

		fffoam
			name = "firefighting foam"
			id = "ff-foam"
			description = "Carbon Tetrachloride is a foam used for fire suppression."
			reagent_state = LIQUID
			fluid_r = 195
			fluid_g = 195
			fluid_b = 175
			transparency = 200
			value = 3 // 1 1 1

			reaction_temperature(exposed_temperature, exposed_volume)
				return

			reaction_turf(var/turf/target, var/volume)
				src = null
				var/obj/hotspot = (locate(/obj/hotspot) in target)
				if (hotspot)
					if (istype(target, /turf/simulated))
						var/turf/simulated/T = target
						if (T.air)
							var/datum/gas_mixture/lowertemp = T.remove_air( T.air.total_moles() )
							lowertemp.temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 200 //T0C - 100
							lowertemp.toxins = max(lowertemp.toxins-50,0)
							lowertemp.react()
							T.assume_air(lowertemp)
					hotspot.disposing() // have to call this now to force the lighting cleanup
					pool(hotspot)

				var/obj/fire_foam/F = (locate(/obj/fire_foam) in target)
				if (!F)
					F = unpool(/obj/fire_foam)
					F.set_loc(target)
					spawn(200)
						if (F && !F.disposed)
							pool(F)
				return

			reaction_obj(var/obj/item/O, var/volume)
				src = null
				if (istype(O) && prob(40))
					if (O.burning)
						O.burning = 0
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if (method == TOUCH)
					var/mob/living/L = M
					if (istype(L) && L.burning)
						L.update_burning(-50)
				return

		silicate
			name = "silicate"
			id = "silicate"
			description = "A compound that can be used to reinforce glass."
			reagent_state = LIQUID
			fluid_r = 38
			fluid_g = 128
			fluid_b = 191
			value = 3 // 1 1 1

			reaction_obj(var/obj/O, var/volume)
				src = null
				if (istype(O,/obj/window))
					var/obj/window/W = O

					// Silicate was broken. I fixed it (Convair880).
					var/max_reinforce = 500
					if (W.health >= max_reinforce)
						return
					var/do_reinforce = W.health * 2
					if ((W.health + do_reinforce) > max_reinforce)
						do_reinforce = max(0, (max_reinforce - W.health))
					W.health += do_reinforce
					W.health_max = W.health

					var/icon/I = icon(W.icon,W.icon_state,W.dir)
					I.SetIntensity(1.25,1.60,1.90)
					O.icon = I
				return

//foam precursor

		fluorosurfactant
			name = "fluorosurfactant"
			id = "fluorosurfactant"
			description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 255
			fluid_b = 255
			transparency = 30
			value = 5 // 3 1 1

		lube
			name = "space lube"
			id = "lube"
			description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_b = 245
			fluid_g = 255
			value = 3 // 1 1 1
			hygiene_value = 0.25

			reaction_turf(var/turf/target, var/volume)
				src = null
				var/turf/simulated/T = target
				if (istype(T))
					if (T.wet >= 2) return
					T.wet = 2
					spawn(800)
						if (istype(T))
							T.wet = 0
							T.UpdateOverlays(null, "wet_overlay")
				return


// metal foaming agent
// this is lithium hydride. Add other recipies (e.g. MiH + H2O -> MiOH + H2) eventually

// two different foaming agents is overly complicated imo - IM

		/*foaming_agent
			name = "foaming agent"
			id = "foaming_agent"
			description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
			reagent_state = SOLID
			fluid_r = 100
			fluid_g = 90
			fluid_b = 90
			transparency = 255*/

		ammonia
			name = "ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."
			reagent_state = GAS
			fluid_r = 255
			fluid_g = 255
			fluid_b = 180
			transparency = 75
			value = 2 // 1c + 1c
			hygiene_value = 0.25

			on_plant_life(var/obj/machinery/plantpot/P)
				P.growth += 4
				if (prob(66))
					P.health++
				P.reagents.remove_any(4)

		diethylamine
			name = "diethylamine"
			id = "diethylamine"
			description = "A secondary amine, useful as a plant nutrient and as building block for other compounds."
			reagent_state = LIQUID
			fluid_r = 60
			fluid_g = 50
			fluid_b = 0
			transparency = 255
			value = 4 // 2c + 1c + heat

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(66))
					P.growth+=2

		acetone
			name = "acetone"
			id = "acetone"
			description = "Pure 100% nail polish remover, also works as an industrial solvent."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 20
			value = 5 // 3c + 1c + 1c
			hygiene_value = 0.75

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.take_toxin_damage(1.5)
				..()
				return


		stabiliser
			name = "stabilising agent"
			id = "stabiliser"
			description = "A chemical that stabilises normally volatile compounds, preventing them from reacting immediately."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 0
			transparency = 255
			value = 3 // 1c + 1c + 1c

		ectoplasm
			name = "ectoplasm"
			id = "ectoplasm"
			description = "A bizarre gelatinous substance supposedly derived from ghosts."
			reagent_state = LIQUID
			fluid_r = 179
			fluid_g = 225
			fluid_b = 151
			transparency = 175
			value = 3

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				if ((holder.get_reagent_amount(src.id) >= 10) && prob(8))
					var/Message = rand(1,6)
					switch(Message)
						if (1)
							boutput(M, "<span style=\"color:red\">You shudder as if cold...</span>")
							M.emote("shiver")
						if (2)
							boutput(M, "<span style=\"color:red\">You feel something gliding across your back...</span>")
						if (3)
							boutput(M, "<span style=\"color:red\">Your eyes twitch, you feel like something you can't see is here...</span>")
						if (4)
							boutput(M, "<span style=\"color:red\">You notice something moving out of the corner of your eye, but nothing is there...</span>")
						if (5)
							boutput(M, "<span style=\"color:red\">You feel uneasy.</span>")
						if (6)
							boutput(M, "<span style=\"color:red\">You've got the heebie-jeebies.</span>")

					if (prob(1))
						for (var/obj/W in orange(5,M))
							if (prob(25) && !W.anchored)
								step_rand(W)
				..(M)

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 10)
					if (locate(/obj/item/reagent_containers/food/snacks/ectoplasm) in T) return
					new /obj/item/reagent_containers/food/snacks/ectoplasm(T)

		space_fungus
			name = "space fungus"
			id = "space_fungus"
			description = "Scrapings of some unknown fungus found growing on the station walls."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 125
			fluid_b = 40
			transparency = 255
			value = 2
			hygiene_value = -1

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				if (method == INGEST)
					var/ranchance = rand(1,10)
					if (ranchance == 1)
						boutput(M, "<span style=\"color:red\">You feel very sick.</span>")
						M.reagents.add_reagent("toxin", rand(1,5))
					else if (ranchance <= 5 && ranchance != 1)
						boutput(M, "<span style=\"color:red\">That tasted absolutely FOUL.</span>")
						M.contract_disease(/datum/ailment/disease/food_poisoning, null, null, 1) // path, name, strain, bypass resist
					else boutput(M, "<span style=\"color:red\">Yuck!</span>")
				return

		cryostylane
			name = "cryostylane"
			id = "cryostylane"
			description = "An incredibly cold substance.  Used in many high-demand cooling systems."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 220
			transparency = 200
			value = 3 // 1 1 1

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if (isobserver(M))
					return

				if (method == TOUCH)
					var/mob/living/L = M
					if (istype(L) && L.burning)
						L.set_burning(0)

				if (M.bioHolder)
					if (!M.is_cold_resistant())
						new /obj/icecube(get_turf(M), M)
				M.bodytemperature = 0
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (M.bodytemperature > 0)
					M.bodytemperature = max(M.bodytemperature-50,0)
				..(M)
				return

			reaction_turf(var/turf/target, var/volume)
				src = null
				if (volume >= 3)
					if (locate(/obj/decal/icefloor) in target) return
					var/obj/decal/icefloor/B = new /obj/decal/icefloor(target)
					spawn(800)
						B.dispose()

				var/obj/hotspot = (locate(/obj/hotspot) in target)
				if (hotspot)
					if (istype(target, /turf/simulated))
						var/turf/simulated/T = target
						var/datum/gas_mixture/lowertemp = T.remove_air( T.air.total_moles() )
						lowertemp.temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 200 //T0C - 100
						lowertemp.toxins = max(lowertemp.toxins-50,0)
						lowertemp.react()
						T.assume_air(lowertemp)
					hotspot.disposing() // have to call this now to force the lighting cleanup
					pool(hotspot)
				return

		booster_enzyme
			name = "booster enzyme"
			id = "booster_enzyme"
			description = "This booster enzyme helps the body to replicate beneficial chemicals."
			reagent_state = LIQUID
			fluid_r = 127
			fluid_g = 160
			fluid_b = 192
			transparency = 255

			on_mob_life(var/mob/M)

				for (var/i = 1, i <= booster_enzyme_reagents_to_check.len, i++)
					var/check_amount = holder.get_reagent_amount(booster_enzyme_reagents_to_check[i])
					if (check_amount && check_amount < 18)
						holder.add_reagent("[booster_enzyme_reagents_to_check[i]]", 2)
				..(M)
				return

		space_cleaner // COGWERKS CHEM REVISION PROJECT. ethanol, ammonia + water - treat like a shitty version of windex
			name = "space cleaner"
			id = "cleaner"
			description = "A compound used to clean things. It has a sharp, unpleasant odor." // cogwerks- THIS IS NOT BLEACH ARGHHHH
			reagent_state = LIQUID
			fluid_r = 110
			fluid_g = 220
			fluid_b = 220
			transparency = 150
			overdose = 5
			value = 4 // 2 1 1
			hygiene_value = 5

			reaction_obj(var/obj/O, var/volume)
				if (!isnull(O))
					O.clean_forensic()

			reaction_turf(var/turf/T, var/volume)
				T.clean_forensic()

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				M.clean_forensic()

		luminol // OOC. Weaseldood. oh that stuff from CSI, the glowy blue shit that they spray on blood
			name = "luminol"
			id = "luminol"
			description = "A chemical that can detect trace amounts of blood."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 204
			transparency = 150

			reaction_turf(var/turf/T, var/volume)
				for (var/obj/decal/bloodtrace/B in T)
					B.invisibility = 0
					spawn(300)
						B.invisibility = 101

		oil
			name = "oil"
			id = "oil"
			description = "A decent lubricant for machines. High in benzene, naptha and other hydrocarbons."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 0
			value = 3 // 1c + 1c + 1c

			reaction_temperature(exposed_temperature, exposed_volume)
				if (exposed_temperature > T0C + 600 && !src.reacting) // need this to be higher to make propylene possible
					src.reacting = 1
					var/location = get_turf(holder.my_atom)
					holder.my_atom.visible_message("<b>The oil burns!</b>")
					fireflash(location, min(max(0,volume/40),8))
					var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
					smoke.set_up(1, 0, location)
					smoke.start()
					if (holder)
						holder.add_reagent("ash", round(src.volume/2), null)
						holder.del_reagent(id)

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if (volume)
					if (method == TOUCH)
						if (istype(M, /mob/living/silicon/robot))
							var/mob/living/silicon/robot/R = M
							R.oil += volume * 2
							boutput(R, "<span style=\"color:blue\">Your joints and servos begin to run more smoothly.</span>")
						else boutput(M, "<span style=\"color:red\">You feel greasy and gross.</span>")

				return

			reaction_turf(var/turf/target, var/volume)
				var/turf/simulated/T = target
				if (istype(T) && T.wet) //Wire: fix for Undefined variable /turf/space/var/wet (&& T.wet)
					src = null
					if (T.wet >= 1) return
					T.wet = 1
					if (!locate(/obj/decal/cleanable/oil) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						switch(volume)
							if (5 to 19) new /obj/decal/cleanable/oil/streak(T)
							if (20 to INFINITY) new /obj/decal/cleanable/oil(T)
					spawn(200)
						T.wet = 0
						T.UpdateOverlays(null, "wet_overlay")

				return

			on_mob_life(var/mob/M)
				//if (prob(4)) // it's motor oil, you goof
					//M.reagents.add_reagent("cholesterol", rand(1,3))
				return

		capulettium
			name = "capulettium"
			id = "capulettium"
			description = "A rare drug that causes the user to appear dead for some time." //dead appearance handled in human.dm
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 145
			fluid_b = 110
			value = 6 // 4c + 1c + 1c
			var/counter = 1

			pooled()
				..()
				counter = 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				switch(counter++)
					if (1 to 5)
						M.change_eye_blurry(10, 10)
					if (6 to 10)
						M.drowsyness  = max(M.drowsyness, 10)
					if (11)
						M.paralysis = max(M.paralysis, 10)
						M.visible_message("<B>[M]</B> seizes up and falls limp, \his eyes dead and lifeless...")
						M.resting = 1
					if (12 to 60) // Capped at ~2 minutes, that is 60 cycles + 10 paralysis (normally wears off at one per cycle).
						M.paralysis = max(M.paralysis, 10)
					if (61 to INFINITY)
						M.change_eye_blurry(10, 10)

				M.updatehealth()
				..(M)

		capulettium_plus
			name = "capulettium plus"
			id = "capulettium_plus"
			description = "A rare and expensive drug that causes the user to appear dead for some time while they retain consciousness and vision." //dead appearance handled in human.dm
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 145
			fluid_b = 110
			value = 28 // 6c + 9c + 13c
			var/counter = 1

			pooled()
				..()
				counter = 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				if (counter == 10)
					M.resting = 1
					M.visible_message("<B>[M]</B> seizes up and falls limp, \his eyes dead and lifeless...")

				M.updatehealth()
				..(M)
/*
		montaguone
			name = "montaguone"
			id = "montaguone"
			description = "A rare drug that causes the dead to appear alive but unconscious for some time." //handled in human.dm
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 145
			fluid_b = 110

		montaguone_extra
			name = "montaguone extra"
			id = "montaguone_extra"
			description = "A rare and exhorbitantly expensive drug that causes the dead to appear alive and well for some time." //live appearance handled in human.dm
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 145
			fluid_b = 110
			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (M.stat == 2)
					if (!data) data = 1
					switch(data)
						if (1 to 10)
							if (prob(20)) M.emote("gasp")
						if (11)
							M.lying = 0
						if (12 to INFINITY)
							spawn(50)
								if (!M.reagents.has_reagent("montaguone_extra"))
									M.lying = 1
									M.emote("deathgasp")
					data++
					M.updatehealth()
				..(M)
*/
		life
			name = "life"
			id = "life"
			description = "Just a placeholder thing, you shouldn't be seeing this!"

		denatured_enzyme
			name = "denatured enzyme"
			id = "denatured_enzyme"
			description = "Heated beyond usefulness, this enzyme is now worthless."
			reagent_state = LIQUID
			fluid_r = 42
			fluid_g = 36
			fluid_b = 19
			transparency = 255

		// used to make fake initropidril
		eyeofnewt
			name = "eye of newt"
			id = "eyeofnewt"
			description = "A potent alchemic ingredient."
			reagent_state = LIQUID
			fluid_r = 10
			fluid_g = 10
			fluid_b = 50
			transparency = 50
		toeoffrog
			name = "toe of frog"
			id = "toeoffrog"
			description = "A potent alchemic ingredient."
			reagent_state = LIQUID
			fluid_r = 10
			fluid_g = 50
			fluid_b = 10
			transparency = 50
		woolofbat
			name = "wool of bat"
			id = "woolofbat"
			description = "A potent alchemic ingredient."
			reagent_state = LIQUID
			fluid_r = 10
			fluid_g = 10
			fluid_b = 10
			transparency = 50
		tongueofdog
			name = "tongue of dog"
			id = "tongueofdog"
			description = "A potent alchemic ingredient."
			reagent_state = LIQUID
			fluid_r = 50
			fluid_g = 10
			fluid_b = 10
			transparency = 50

		werewolf_serum_fake3
			name = "Werewolf Serum Precursor Gamma"
			id = "werewolf_part3"
			description = "A direct precursor to a special, targeted mutagen."
			reagent_state = LIQUID
			fluid_r = 143
			fluid_g = 35
			fluid_b = 103
			transparency = 10

		werewolf_serum_fake4
			name = "Imperfect Werewolf Serum"
			id = "werewolf_part4"
			description = "A flawed isomer of a special, targeted mutagen.  If only it were perfected..."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 255
			fluid_b = 240
			transparency = 200
			depletion_rate = 0.2

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				var/our_amt = holder.get_reagent_amount(src.id)
				if (prob(25))
					M.reagents.add_reagent("histamine", rand(5,10))
				if (our_amt < 5)
					M.take_toxin_damage(1)
					random_brute_damage(M, 1)
					M.updatehealth()
				else if (our_amt < 10)
					if (prob(8))
						M.visible_message("<span style=\"color:red\">[M] pukes all over \himself.</span>", "<span style=\"color:red\">You puke all over yourself!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					M.take_toxin_damage(2)
					random_brute_damage(M, 2)
					M.updatehealth()

				else if (prob(4))
					M.visible_message("<span style=\"color:red\"><B>[M]</B> starts convulsing violently!</span>", "You feel as if your body is tearing itself apart!")
					M.weakened = max(15, M.weakened)
					M.make_jittery(1000)
					spawn(rand(20, 100))
						var/turf/Mturf = get_turf(M)
						M.gib()
						new /obj/critter/dog/george (Mturf)
					return

				..(M)
				return

		sewage
			name = "sewage"
			id = "sewage"
			description = "Oh, wonderful."
			reagent_state = LIQUID
			fluid_r = 102
			fluid_g = 102
			fluid_b = 0
			transparency = 255

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if (method == INGEST)
					boutput(M, "<span style=\"color:red\">Aaaagh! It tastes fucking horrendous!</span>")
					spawn(10)
						M.visible_message("<span style=\"color:red\">[M] pukes violently!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
				else
					boutput(M, "<span style=\"color:red\">Oh god! It smells horrific! What the fuck IS this?!</span>")
					if (prob(50))
						spawn(10)
							M.visible_message("<span style=\"color:red\">[M] pukes violently!</span>")
							playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
							new /obj/decal/cleanable/vomit(M.loc)
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (prob(7))
					M.emote(pick("twitch","drool","moan"))
					M.take_toxin_damage(1)
				..(M)
				return

		ants
			name = "ants"
			id = "ants"
			description = "A sample of a lost breed of Space Ants (formicidae bastardium tyrannus), they are well-known for ravaging the living shit out of pretty much anything."
			reagent_state = SOLID
			fluid_r = 153
			fluid_g = 51
			fluid_b = 51
			transparency = 255
			value = 2

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if (ishuman(M))
					boutput(M, "<span style=\"color:red\"><b>OH SHIT ANTS!!!!</b></span>")
					M.emote("scream")
					random_brute_damage(M, 4)
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				random_brute_damage(M, 2)
				..(M)
				return

		spiders
			name = "spiders"
			id = "spiders"
			description = "A bunch of tiny little spiders, all crawling around in a big spidery blob."
			reagent_state = SOLID
			fluid_r = 22
			fluid_g = 5
			fluid_b = 5
			transparency = 255
			var/static/reaction_count = 0
			value = 13 // 11 2

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if (method == TOUCH)
					boutput(M, "<span style=\"color:red\"><b>OH [pick("SHIT", "FUCK", "GOD")] SPIDERS[pick("", " ON MY FACE", " EVERYWHERE")]![pick("", "!", "!!", "!!!", "!!!!")]</b></span>")
				if (method == INGEST)
					boutput(M, "<span style=\"color:red\"><b>OH [pick("SHIT", "FUCK", "GOD")] SPIDERS[pick("", " IN MY BLOOD", " IN MY VEINS")]![pick("", "!", "!!", "!!!", "!!!!")]</b></span>")
				M.emote("scream")
				random_brute_damage(M, 2)
				if (ishuman(M))
					if (!M:spiders)
						M:spiders = 1
						M:update_body()
				return

			reaction_turf(var/turf/T, var/volume)
				fucking_critter_bullshit_fuckcrap_limiter(reaction_count)
				var/turf/simulated/target = T
				if (istype(target) && volume >= 5)
					if (!locate(/obj/reagent_dispensers/spiders) in target)
						new /obj/reagent_dispensers/spiders(target)
						var/obj/critter/S
						if (prob(10))
							S = new /obj/critter/spider/baby(target)
						else if (prob(2))
							S = new /obj/critter/nicespider(target)
							S.name = "spider"
							S.density = 0
					else if (locate(/obj/reagent_dispensers/spiders) in target && !locate(/obj/critter) in target)
						var/obj/critter/S
						if (prob(25))
							S = new /obj/critter/spider/baby(target)
							if (prob(2))
								S.aggressive = 1
						else if (prob(5))
							S = new /obj/critter/nicespider(target)
							S.name = "spider"
							S.density = 0
						else if (prob(10))
							S = new /obj/critter/spider(target)
							if (prob(1))
								S.aggressive = 1
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				var/turf/T = get_turf(M)
				if (prob(50))
					random_brute_damage(M, 1)
				else if (prob(10))
					random_brute_damage(M, 2)
					M.emote(pick("twitch", "twitch_s", "grumble"))
					M.visible_message("<span style=\"color:red\"><b>[M]</b> [pick("scratches", "digs", "picks")] at [pick("something under their skin", "their skin")]!</span>",\
					"<span style=\"color:red\"><b>[pick("T", "It feels like t", "You feel like t", "Oh shit t", "Oh fuck t", "Oh god t")]here's something [pick("crawling", "wriggling", "scuttling", "skittering")] in your [pick("blood", "veins", "stomach")]!</b></span>")
				else if (prob(10))
					random_brute_damage(M, 5)
					M.emote("scream")
					M.emote("twitch")
					if (!M.weakened) M.weakened += 1
					M.visible_message("<span style=\"color:red\"><b>[M.name]</b> tears at their own skin!</span>",\
					"<span style=\"color:red\"><b>OH [pick("SHIT", "FUCK", "GOD")] GET THEM OUT![pick("", "!", "!!", "!!!", "!!!!")]</span>")
				else if (prob(10))
					if (!locate(/obj/decal/cleanable/vomit) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit/spiders(T)
						random_brute_damage(M, rand(4))
						M.visible_message("<span style=\"color:red\"><b>[M]</b> [pick("barfs", "hurls", "pukes", "vomits")] up some [pick("spiders", "weird black stuff", "strange black goop", "wriggling black goo")]![pick("", " Gross!", " Ew!", " Nasty!")]</span>",\
						"<span style=\"color:red\"><b>OH [pick("SHIT", "FUCK", "GOD")] YOU JUST [pick("BARFED", "HURLED", "PUKED", "VOMITED")] SPIDERS[pick("!", " FUCK THAT'S GROSS!", " SHIT THAT'S NASTY!", " OH GOD EW!")][pick("", "!", "!!", "!!!", "!!!!")]</b></span>")
						if (prob(33))
							var/obj/critter/spider/baby/S = new /obj/critter/spider/baby(M)
							if (prob(5))
								S.aggressive = 1
				..(M)
				return

		hugs
			name = "pure hugs"
			id = "hugs"
			description = "Hugs, in liquid form.  Yes, the concept of a hug.  As a liquid.  This makes sense in the future."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 151
			fluid_b = 185
			transparency = 250
			value = 11

		love
			name = "pure love"
			id = "love"
			description = "What is this emotion you humans call \"love?\"  Oh, it's this?  This is it? Huh, well okay then, thanks."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 131
			fluid_b = 165
			transparency = 250
			value = 13 // 11 2

			reaction_mob(var/mob/M)
				boutput(M, "<span style=\"color:blue\">You feel loved!</span>")
				return

			on_mob_life(var/mob/M)
				if (!M)
					M = holder.my_atom

				if (M.a_intent == INTENT_HARM)
					M.a_intent = INTENT_HELP

				if (prob(8))
					. = ""
					switch (rand(1, 5))
						if (1)
							. = "appreciated"
						if (2)
							. = "loved"
						if (3)
							. = "pretty good"
						if (4)
							. = "really nice"
						if (5)
							. = "pretty happy with yourself, even though things haven't always gone as well as they could"


					boutput(M, "<span style=\"color:blue\">You feel [.].</span>")

				else if (prob(100) && !M.restrained())//(prob(16))
					for (var/mob/living/hugTarget in orange(1,M))
						if (hugTarget == M)
							continue
						if (!hugTarget.stat)

							M.visible_message("<span style=\"color:red\">[M] [prob(5) ? "awkwardly side-" : ""]hugs [hugTarget]!</span>")

							break

				..(M)
				return

		colors
			name = "colorful reagent"
			id = "colors"
			description = "It's pure liquid colors. That's a thing now."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255
			hygiene_value = -0.5

			reaction_mob(var/mob/M, var/method = TOUCH, var/volume)
				if (method == INGEST)
					if (ishuman(M))
						M:blood_color = "#[num2hex(rand(0, 255))][num2hex(rand(0, 255))][num2hex(rand(0, 255))]"
				return

			reaction_obj(var/obj/O, var/volume)
				src = null
				O.color = rgb(rand(0,255),rand(0,255),rand(0,255))
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				T.color = rgb(rand(0,255),rand(0,255),rand(0,255))
				return

		shark_dna
			name = "space shark DNA"
			id = "shark_dna"
			description = "How this was obtained is anyone's guess."
			reagent_state = LIQUID
			fluid_r = 160
			fluid_g = 160
			fluid_b = 255
			transparency = 100
			value = 4

		packing_peanuts
			name = "packing peanuts"
			id = "packing_peanuts"
			description = "Those little white things you get when you order stuff in boxes. Not to be confused with ghost poop."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255
			value = 3

		wax
			name = "wax"
			id = "wax"
			description = "A lipid compound used in candles and for making haunted sculptures to terrorize Scooby Doo."
			reagent_state = SOLID
			fluid_r = 250
			fluid_g = 250
			fluid_b = 250
			transparency = 200
			value = 3

		pollen
			name = "pollenium"
			id = "pollen"
			description = "A pollen-derivative with a number of proteins and other nutrients vital to space bee health. Not palatable for humans, but at least Russian dissidents have never been killed with it."
			reagent_state = SOLID
			fluid_r = 191
			fluid_g = 191
			fluid_b = 61
			transparency = 255
			value = 3

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				if(method == INGEST)
					var/mob/living/carbon/human/H = M
					if (H.bioHolder && H.bioHolder.HasEffect("bee"))
						boutput(M, "<span style=\"color:blue\">That tasted amazing!</span>")
					else
						boutput(M, "<span style=\"color:red\">Ugh! Eating that was a terrible idea!</span>")
						M.stunned += 2
						M.weakened += 2

		martian_flesh
			name = "martian flesh"
			id = "martian_flesh"
			description = "Uhhhh...."
			reagent_state = SOLID
			fluid_r = 180
			fluid_g = 225
			fluid_b = 175
			transparency = 230
			value = 5

		black_goop
			name = "gross black goop"
			id = "black_goop"
			description = "You're not even sure what this is. It's pretty grody."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 255

		paper
			name = "paper"
			id = "paper"
			description = "Little flecks of paper, all torn up."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (!istype(T, /turf/space))
					if (volume >= 5)
						if (!locate(/obj/decal/cleanable/paper) in T)
							new /obj/decal/cleanable/paper(T)

		fliptonium
			name = "fliptonium"
			id = "fliptonium"
			description = "Do some flips!"
			reagent_state = LIQUID
			fluid_r = 209
			fluid_g = 31
			fluid_b = 117
			transparency = 175
			addiction_prob = 10
			overdose = 15
			depletion_rate = 0.2
			var/remove_buff = 0
			var/direction = null
			var/dir_lock = 0
			var/anim_lock = 0
			var/speed = 3

			pooled()
				..()
				remove_buff = 0
				direction = null
				dir_lock = 0
				anim_lock = 0
				speed = 3


			on_mob_life(var/mob/M)
				if (!M)
					M = holder.my_atom

				..(M)	//Rearranging to make it deplete as intended

				if (!istype(M,/mob/living/))
					return

				if (!data) data = 1
				else data++

				switch (data)
					if (1)
						anim_lock = 0
						speed = 3
					if (10)
						anim_lock = 0
						speed = 2.5
					if (20)
						anim_lock = 0
						speed = 2
					if (30)
						anim_lock = 0
						speed = 1.5
					if (40)
						anim_lock = 0
						speed = 1

				if (!dir_lock)
					direction = pick("L", "R")
					dir_lock = 1

				if (!anim_lock)
					animate_spin(M, direction, speed)
					anim_lock = 1

				M.make_jittery(2)
				M.drowsyness = max(M.drowsyness-6, 0)
				if (M.paralysis) M.paralysis-=1.5
				if (M.stunned) M.stunned-=1.5
				if (M.weakened) M.weakened-=1.5
				if (M.sleeping) M.sleeping = 0
				return

			reaction_mob(var/mob/M)
				var/dir_temp = pick("L", "R")
				var/speed_temp = text2num("[rand(1,6)].[rand(0,9)]")
				animate_spin(M, dir_temp, speed_temp)
				DEBUG("<span style=\"color:blue\"><b>Spun [M]: [dir_temp], [speed_temp]</b></span>") // <- What's this?

/*			reaction_obj(var/obj/O, var/volume)
				if (volume >= 10)
					var/dir_temp = pick("L", "R")
					var/speed_temp = text2num("[rand(1,6)].[rand(0,9)]")
					animate_spin(O, dir_temp, speed_temp)
					DEBUG("<span style=\"color:blue\"><b>Spun [O]: [dir_temp], [speed_temp]</b></span>")
*/
			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 2)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				if (istype(holder) && istype(holder.my_atom))
					animate(holder.my_atom)

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> can't seem to control their legs!</span>")
						M.change_misstep_chance(33)
						M.weakened += 2
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> hands flip out and flail everywhere!</span>")
						M.drop_item()
						M.hand = !M.hand
						M.drop_item()
						M.hand = !M.hand
					else if (effect <= 7)
						M.emote("laugh")
				else if (severity == 2)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]'s</b> hands flip out and flail everywhere!</span>")
						M.drop_item()
						M.hand = !M.hand
						M.drop_item()
						M.hand = !M.hand
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> falls to the floor and flails uncontrollably!</span>")
						M.make_jittery(5)
						M.weakened += 5
					else if (effect <= 7)
						M.emote("laugh")

		fliptonium/glowing_fliptonium
			name = "glowing fliptonium"
			id = "glowing_fliptonium"
			description = "There's something kinda weird about this stuff. Something off. Something... spooky."
			reagent_state = LIQUID
			fluid_r = 158
			fluid_g = 16
			fluid_b = 94
			transparency = 200
			addiction_prob = 20
			overdose = 11
			depletion_rate = 0.1

			on_mob_life(var/mob/M)
				if (!M)
					M = holder.my_atom

				..(M)

				if (!istype(M,/mob/living/))
					return

				if (!data) data = 1
				else data++

				switch (data)
					if (1)
						anim_lock = 0
						speed = 3
					if (5)
						anim_lock = 0
						speed = 2.5
					if (10)
						anim_lock = 0
						speed = 2
					if (15)
						anim_lock = 0
						speed = 1.5
					if (20)
						anim_lock = 0
						speed = 1
					if (25)
						anim_lock = 0
						speed = 0.9
					if (30)
						anim_lock = 0
						speed = 0.8
					if (35)
						anim_lock = 0
						speed = 0.7
					if (40)
						anim_lock = 0
						speed = 0.6
					if (45)
						anim_lock = 0
						speed = 0.5

				if (!dir_lock)
					direction = pick("L", "R")
					dir_lock = 1

				if (!anim_lock)
					animate_spin(M, direction, speed)
					anim_lock = 1

				M.make_jittery(4)
				M.drowsyness = max(M.drowsyness-12, 0)
				if (M.paralysis) M.paralysis-=3
				if (M.stunned) M.stunned-=3
				if (M.weakened) M.weakened-=3
				if (M.sleeping) M.sleeping = 0
				return

			reaction_mob(var/mob/M, var/method = TOUCH)
				if (method != TOUCH)
					return
				var/dir_temp = pick("L", "R")
				var/speed_temp = text2num("[rand(0,10)].[rand(0,9)]")
				animate_spin(M, dir_temp, speed_temp)

			reaction_obj(var/obj/O)
				var/dir_temp = pick("L", "R")
				var/speed_temp = text2num("[rand(0,10)].[rand(0,9)]")
				animate_spin(O, dir_temp, speed_temp)

			reaction_turf(var/turf/T) // oh god what am I doing this is such a bad idea
				var/dir_temp = pick("L", "R")
				var/speed_temp = text2num("[rand(0,10)].[rand(0,9)]")
				animate_spin(T, dir_temp, speed_temp)

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 4)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				if (istype(holder) && istype(holder.my_atom))
					animate(holder.my_atom)

		diluted_fliptonium
			name = "diluted fliptonium"
			id = "diluted_fliptonium"
			description = "You're a rude dude with a rude 'tude."
			reagent_state = LIQUID
			fluid_r = 245
			fluid_g = 12
			fluid_b = 74
			transparency = 150
			addiction_prob = 5
			overdose = 30
			depletion_rate = 0.1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (prob(10))
					var/list/mob/nerds = list()
					for (var/mob/living/some_idiot in oviewers(M, 7))
						nerds.Add(some_idiot)
					if (nerds && nerds.len)
						var/mob/some_idiot = pick(nerds)
						if (prob(50))
							M.visible_message("<B>[M]</B> flips off [some_idiot.name]!")
						else
							M.visible_message("<B>[M]</B> gives [some_idiot.name] the double deuce!")
				..(M)
				return

		fartonium // :effort:
			name = "fartonium"
			id = "fartonium"
			description = "Oh god it never ends, IT NEVER STOPS!"
			reagent_state = GAS
			fluid_r = 247
			fluid_g = 122
			fluid_b = 32
			transparency = 200

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				if (prob(66))
					M.emote("fart")

				if (M.reagents.has_reagent("anti_fart"))
					if (prob(25))
						boutput(M, "<span style=\"color:red\">[pick("Oh god, something doesn't feel right!", "<B>IT HURTS!</B>", "<B>FUCK!</B>", "Something is seriously wrong!", "<B>THE PAIN!</B>", "You feel like you're gunna die!")]</span>")
						random_brute_damage(M, 1)
					if (prob(10))
						M.emote("poo")
						random_brute_damage(M, 2)
					if (prob(5))
						M.emote("scream")
						random_brute_damage(M, 4)
				..(M)

// let us never forget the 3,267 parrot incident, the recipe for this just reacts instantly now
		flaptonium
			name = "flaptonium"
			id = "flaptonium"
			fluid_r = 100
			fluid_g = 200
			fluid_b = 255
			transparency = 255
			var/static/reaction_count = 0

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				var/turf/T = get_turf(M)
				createSomeBirds(T, volume)

			reaction_obj(var/obj/O, var/volume)
				var/turf/T = get_turf(O)
				createSomeBirds(T, volume)

			reaction_turf(var/turf/T, var/volume)
				createSomeBirds(T, volume)

			proc/createSomeBirds(var/turf/T as turf, var/volume)
				fucking_critter_bullshit_fuckcrap_limiter(reaction_count)
				if (!T)
					return
				if (volume < 5)
					return
				if (!locate(/obj/critter) in T && prob(20))
					var/obj/critter/parrot/P
					if (prob(1) && !already_a_dominic)
						P = new /obj/critter/parrot/eclectus/male(T)
						P.name = "Dominic"
						P.desc = "Who's a green chicken? It's him, the stinkosaurous rex, he's the green chicken! He's kissin', that bird is. He thought he could get away with it, but he was wrong."
						P.health = 100000
						already_a_dominic = 1
						return
					else
						P = new /obj/critter/parrot/random(T)

		glitter
			name = "glitter"
			id = "glitter"
			description = "Fabulous!"
			reagent_state = SOLID
			fluid_r = 230
			fluid_g = 230
			fluid_b = 240
			transparency = 245
			depletion_rate = 0.1
			penetrates_skin = 1

			on_add()
				var/atom/A = holder.my_atom
				if (ismob(A))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(A))
				if (isobj(A))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(A))

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (!istype(T, /turf/space))
					if (volume >= 5)
						if (!locate(/obj/decal/cleanable/glitter) in T)
							new /obj/decal/cleanable/glitter(T)

			on_remove()
				var/atom/A = holder.my_atom
				if (ismob(A))
					if (particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.RemoveSystem(/datum/particleSystem/glitter, A)
				if (isobj(A))
					if (particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.RemoveSystem(/datum/particleSystem/glitter, A)

/* STOP FUCKING MURDERING THE SERVER YOU SHITASS
			reaction_turf(var/turf/T)
				if (isturf(T) && !istype(T, /turf/space))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, T))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(T))

			reaction_obj(var/obj/O)
				if (isobj(O))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, O))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(O))
*/
			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (prob(10))
					M.visible_message("<span style=\"color:red\"><b>[M.name]</b> scratches at an itch.</span>")
					random_brute_damage(M, 1)
					M.emote("grumble")
				if (prob(5))
					boutput(M, "<span style=\"color:red\"><b>So itchy!</b></span>")
					random_brute_damage(M, 2)
				if (prob(1))
					M.reagents.add_reagent("histamine", 1)
				..(M)
				return

		glitter_harmless // no recipe, doesn't do any damage
			name = "glitter"
			id = "glitter_harmless"
			description = "Fabulous!"
			reagent_state = SOLID
			fluid_r = 230
			fluid_g = 230
			fluid_b = 240
			transparency = 245
			depletion_rate = 0.1
			penetrates_skin = 1

			on_add()
				var/atom/A = holder.my_atom
				if (ismob(A))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(A))
				if (isobj(A))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(A))

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (!istype(T, /turf/space))
					if (volume >= 5)
						if (!locate(/obj/decal/cleanable/glitter) in T)
							new /obj/decal/cleanable/glitter(T)

			on_remove()
				var/atom/A = holder.my_atom
				if (ismob(A))
					if (particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.RemoveSystem(/datum/particleSystem/glitter, A)
				if (isobj(A))
					if (particleMaster.CheckSystemExists(/datum/particleSystem/glitter, A))
						particleMaster.RemoveSystem(/datum/particleSystem/glitter, A)

/* NO
			reaction_turf(var/turf/T)
				if (isturf(T) && !istype(T, /turf/space))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, T))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(T))

			reaction_obj(var/obj/O)
				if (isobj(O))
					if (!particleMaster.CheckSystemExists(/datum/particleSystem/glitter, O))
						particleMaster.SpawnSystem(new /datum/particleSystem/glitter(O))
*/
		green_goop // lets you see ghosts while it's in you.  exists only for ectocooler to decay into atm
			name = "strange green goop"
			id = "green_goop"
			fluid_r = 11
			fluid_g =  255
			fluid_b = 1
			description = "A foul substance that seems to quiver oddly near certain spots."
			reagent_state = LIQUID
			depletion_rate = 0.8
			value = 3

		voltagen
			name = "voltagen"
			id = "voltagen"
			description = "Electricity in pure liquid form. However that works."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 128
			fluid_b = 255
			transparency = 230
			overdose = 20
			var/multiplier = 1
			var/grenade_handled = 0
			pooled()
				..()
				multiplier = 1
				grenade_handled = 0


			grenade_effects(var/obj/grenade, var/atom/A)
				if (istype(A, /mob/living))
					if (!grenade_handled)
						multiplier = 15
						grenade_handled = 1
					else
						multiplier /= 2
					arcFlash(grenade, A, 0)

			reaction_mob(var/mob/M, var/method = TOUCH)
				if (method == TOUCH && volume >= 5)
					M.shock(src.holder.my_atom, min(7500 * multiplier, volume * 100 * multiplier), "chest", 1, 1)

			reaction_temperature(exposed_temperature, exposed_volume)
				. = ..()
				if (reacting) return
				if (exposed_temperature > T0C + 100)
					reacting = 1
					var/count = 0
					for (var/mob/living/L in oview(5, holder.my_atom))
						count++
					for (var/mob/living/L in oview(5, holder.my_atom))
						arcFlash(holder.my_atom, L, min(75000 * multiplier / count, volume * 1000 * multiplier / count))

					holder.del_reagent(id)

			on_mob_life(mob/M)

				if (prob(10))
					var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
					s.set_up(5, 1, get_turf(M))
					s.start()
				..()

			do_overdose(var/severity, var/mob/M)
				if (prob(10))
					if (severity >= 2)
						M.shock(M, 100000, "chest", 1, 1)
						holder.remove_reagent(id, 20)
					else
						M.shock(M, 10000, "chest", 1, 1)
						holder.remove_reagent(id, 10)

		// haha fuck no I'm not porting this to the new lighting system
		/*lumen
			name = "lumen"
			id = "lumen"
			description = "A viscous liquid that seems to glow rather intensively. Perhaps applying this to things might lighten up places."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 230

			proc/calculate_glow_color()
				if (holder)
					return holder.get_average_color()
				return new /datum/color(fluid_r, fluid_g, fluid_b, transparency)

			reaction_turf(var/turf/T)
				if (locate(/obj/decal/glow) in T)
					return
				var/obj/decal/glow/G = new(T)
				var/datum/color/mycolor = calculate_glow_color()
				G.sd_SetColor(mycolor.r / 255.0, mycolor.g / 255.0, mycolor.b / 255.0)
				G.sd_SetLuminosity(3)
				spawn (rand(1500, 6000)) // 2.5-10 minutes
					qdel(G)

			reaction_obj(var/obj/O)
				var/datum/color/mycolor = calculate_glow_color()
				src = null
				if (!O)
					return
				if (!O.luminosity)
					O.sd_SetColor(mycolor.r / 255.0, mycolor.g / 255.0, mycolor.b / 255.0)
					O.sd_SetLuminosity(3)
					spawn (rand(3000, 12000)) // 5-20 minutes
						if (O)
							O.sd_SetLuminosity(0)*/

		///////////////////////////
		/// BOTANY REAGENTS ///////
		///////////////////////////

// stuff what's for plants and hydroponics

		weedkiller
			name = "atrazine"
			id = "weedkiller"
			description = "A herbicidal compound used for destroying unwanted plants."
			reagent_state = LIQUID
			fluid_r = 51
			fluid_g = 0
			fluid_b = 102
			transparency = 170
			hygiene_value = 0.3

			on_mob_life(var/mob/M) // cogwerks note. making atrazine toxic
				if (!M) M = holder.my_atom
				M.take_toxin_damage(2)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				var/datum/plant/growing = P.current
				if (growing.growthmode == "weed")
					P.HYPdamageplant("poison",2)
					P.growth -= 3

		ash
			name = "ash"
			id = "ash"
			description = "Ashes to ashes, dust to dust."
			reagent_state = SOLID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(80))
					P.growth++
				if (prob(80))
					P.health++

		potash
			name = "potash"
			id = "potash"
			description = "A white crystalline compound, useful for boosting crop yields."
			reagent_state = SOLID
			fluid_r = 240
			fluid_g = 240
			fluid_b = 240

			on_plant_life(var/obj/machinery/plantpot/P)
				/*if (prob(80))
					P.growth+=2
				if (prob(80))
					P.health+=2
				*/
				var/datum/plant/growing = P.current
				var/datum/plantgenes/DNA = P.plantgenes
				if (prob(24))
					DNA.cropsize++
				if (DNA.harvests > 1 && prob(24))
					DNA.harvests--
				if (growing.isgrass && prob(66) && P.growth > 2)
					P.growth -= 2
				if (prob(50))
					P.growth++
					P.health++


		plant_nutrients
			name = "saltpetre"
			id = "saltpetre"
			description = "Potassium nitrate, commonly used for fertilizer, cured meats and fireworks production."
			reagent_state = SOLID
			fluid_r = 240
			fluid_g = 240
			fluid_b = 240

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(80))
					P.growth+=3
				if (prob(80))
					P.health+=3
				var/datum/plantgenes/DNA = P.plantgenes
				if (prob(50)) DNA.potency++
				if (DNA.cropsize > 1 && prob(24)) DNA.cropsize--

		///////////////////////////
		/// BODILY FLUIDS /////////
		///////////////////////////

		blood
			name = "blood"
			id = "blood"
			description = "A substance found in many living creatures."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_b = 0
			fluid_g = 0
			transparency = 255
			value = 2
			var/list/pathogens = list()
			var/pathogens_processed = 0
			hygiene_value = -2

			pooled()
				..()
				pathogens.Cut()
				pathogens_processed = 0

/*			var
				blood_DNA = null
				blood_type = "O-"*/

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5)
					if (!locate(/obj/decal/cleanable/blood) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/blood(T)

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if (!volume_passed) return
				if (!ishuman(M)) return
				if (method == INGEST)
					if (M.mind)
						if (isvampire(M))
							var/datum/abilityHolder/vampire/V = M.get_ability_holder(/datum/abilityHolder/vampire)
							if (V && istype(V))
								// Blood as a reagent doesn't track DNA and blood type yet (or anymore).
								/*if (M.bioHolder && (src.blood_DNA == M.bioHolder.Uid))
									M.show_text("Injecting your own blood? Who are you kidding?", "red")
									return*/
								if (prob(33))
									boutput(M, "<span style=\"color:red\">Fresh blood would be better...</span>")
								var/bloodget = volume_passed / 3
								M.change_vampire_blood(bloodget, 1) // vamp_blood
								M.change_vampire_blood(bloodget, 0) // vamp_blood_remaining
								V.blood_tracking_output()
								V.check_for_unlocks()

/*					if (holder) // drinking blood shouldn't add it to your system
						holder.remove_reagent("blood", volume_passed)
*/

			on_mob_life(var/mob/M)
				// Let's assume that blood immediately mixes with the bloodstream of the mob.
				if (!pathogens_processed) //Only process pathogens once
					pathogens_processed = 1
					for (var/uid in src.pathogens)
						var/datum/pathogen/P = src.pathogens[uid]
						logTheThing("pathology", M, null, "metabolizing [src] containing pathogen [P].")
						M.infected(P)

				if (holder.has_reagent("dna_mutagen")) //If there's stable mutagen in the mix and it doesn't have data we gotta give it a chance to get some
					var/datum/reagent/SM = holder.get_reagent("dna_mutagen")
					if (SM.data) holder.del_reagent(src.id)
				else
					holder.del_reagent(src.id)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				var/datum/plant/growing = P.current
				if (growing.growthmode == "carnivore") P.growth += 3

			on_transfer(var/datum/reagents/source, var/datum/reagents/target, var/trans_amt)
				var/list/source_pathogens = source.aggregate_pathogens()
				var/list/target_pathogens = target.aggregate_pathogens()
				var/target_changed = 0
				for (var/uid in source_pathogens)
					if (!(uid in target_pathogens))
						target_pathogens += uid
						target_pathogens[uid] = source_pathogens[uid]
						target_changed = 1
				if (target_changed)
					for (var/reagent_id in pathogen_controller.pathogen_affected_reagents)
						if (target.has_reagent(reagent_id))
							var/datum/reagent/blood/B = target.get_reagent(reagent_id)
							if (!istype(B))
								continue
							B.pathogens = target_pathogens
				return

		blood/bloodc
			id = "bloodc"
			value = 3
			hygiene_value = -4

			reaction_temperature(exposed_temperature, exposed_volume)
				if (exposed_temperature > T0C + 50 && holder.my_atom)
					for (var/mob/O in AIviewers(get_turf(holder.my_atom), null))
						boutput(O, "<span style=\"color:red\">The blood tries to climb out of [holder.my_atom] before sizzling away!</span>")
					holder.del_reagent(id)
				return

		vomit
			name = "vomit"
			id = "vomit"
			description = "Looks like someone lost their lunch. And then collected it. Yuck."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_b = 80
			fluid_g = 255
			transparency = 255
			hygiene_value = -3

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5)
					if (!locate(/obj/decal/cleanable/vomit) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(T)

		gvomit
			name = "green vomit"
			id = "gvomit"
			description = "Whoa, that can't be natural. That's horrible."
			reagent_state = LIQUID
			fluid_r = 120
			fluid_b = 120
			fluid_g = 255
			transparency = 255
			value = 2
			hygiene_value = -5

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5)
					if (!locate(/obj/decal/cleanable/greenpuke) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/greenpuke(T)

		urine
			name = "urine"
			id = "urine"
			description = "Ewww."
			reagent_state = LIQUID
			fluid_r = 233
			fluid_g = 216
			fluid_b = 0
			transparency = 245
			hygiene_value = -3
			thirst_value = 0.5

			/*on_mob_life(var/mob/M) why
				for (var/datum/ailment_data/disease/virus in M.ailments)
					if (prob(10))
						M.resistances += virus.type
						M.ailments -= virus
						boutput(M, "<span style=\"color:blue\">You feel better</span>")
				..(M)
				return*/
			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5)
					if (!locate(/obj/decal/cleanable/urine) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/urine(T)

		triplepiss
			name = "triplepiss"
			id = "triplepiss"
			description = "Ewwwwwwwww."
			reagent_state = LIQUID
			fluid_r = 133
			fluid_g = 116
			fluid_b = 0
			transparency = 255
			hygiene_value = -10

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5)
					if (!locate(/obj/decal/cleanable/urine) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/urine(T)

		poo
			name = "compost"
			id = "poo"
			description = "Raw fertilizer used for gardening."
			reagent_state = SOLID
			fluid_r = 100
			fluid_g = 55
			fluid_b = 0
			transparency = 255
			hygiene_value = -5

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(66))
					P.health++

		big_bang_precursor
			name = "stable bose-einstein macro-condensate"
			id = "big_bang_precursor"
			description = "This is a strange viscous fluid that seems to have the properties of both a liquid and a gas."
			reagent_state = LIQUID
			fluid_r = 200
			fluid_g = 190
			fluid_b = 230
			transparency = 160

		big_bang
			name = "quark-gluon plasma"
			id = "big_bang"
			description = "Its... beautiful!"
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 240
			fluid_b = 250
			transparency = 255

			reaction_turf(var/turf/T, var_volume)
				src = null
				T.ex_act(1)

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				M.ex_act(1)

			reaction_obj(var/obj/O, var/volume)
				//if (!istype(O, /obj/effects/foam)
				//	&& !istype(O, /obj/item/reagent_containers)
				//	&& !istype(O, /obj/item/chem_grenade))
				O.ex_act(1)

			on_mob_life(var/mob/M)
				..(M)
				M.ex_act(1)

		cyclopentanol
			name = "cyclopentanol"
			id = "cyclopentanol"
			description = "A substance not particularly worth noting."
			reagent_state = LIQUID
			fluid_r = 10
			fluid_g = 254
			fluid_b = 254
			transparency = 50

		glue
			name = "glue"
			id = "glue"
			description = "Hopefully you weren't the kind of kid to eat this stuff."
			reagent_state = LIQUID
			fluid_r = 250
			fluid_g = 250
			fluid_b = 250
			transparency = 255

		magnesium_chloride
			name = "magnesium chloride"
			id = "magnesium_chloride"
			description = "A white powder that's capable of binding a high amount of ammonia while on room temperature."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255

		mg_nh3_cl
			name = "magnesium-ammonium chloride"
			id = "mg_nh3_cl"
			description = "A white powder binding a high amount of ammonia. The ammonia is released when the mixture is heated above 150 degrees celsius."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255

		reversium
			name = "reversium"
			id = "reversium"
			description = "A chemical element."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 250
			fluid_b = 160
			transparency = 155
			data = null

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				M.bioHolder.AddEffect("reversed_speech", timeleft = 180)

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.bioHolder.AddEffect("reversed_speech", timeleft = 180)
				..(M)
				return
