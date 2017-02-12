#define SOLID 1
#define LIQUID 2
#define GAS 3


	/*	These are here purely for reference of basic effects and how to write the code-Nernums

datum/reagent/anti_toxin
	name = "Anti-Toxin (Dylovene)"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color_r = 11
	color_g = 67
	color_b = 97
	melting_temp = 263
	boiling_temp = 363
	medical = 1
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		M:drowsyness = max(M:drowsyness-2, 0)
		if(holder.has_reagent("toxin"))
			holder.remove_reagent("toxin", 2)
		if(holder.has_reagent("stoxin"))
			holder.remove_reagent("stoxin", 2)
		if(holder.has_reagent("plasma"))
			holder.remove_reagent("plasma", 1)
		if(holder.has_reagent("acid"))
			holder.remove_reagent("acid", 1)
		if(holder.has_reagent("cyanide"))
			holder.remove_reagent("cyanide", 1)
		if(holder.has_reagent("amatoxin"))
			holder.remove_reagent("amatoxin", 2)
		if(holder.has_reagent("chloralhydrate"))
			holder.remove_reagent("chloralhydrate", 5)
		if(holder.has_reagent("carpotoxin"))
			holder.remove_reagent("carpotoxin", 1)
		if(holder.has_reagent("zombiepowder"))
			holder.remove_reagent("zombiepowder", 0.5)


		if(holder.has_reagent("s"))
			holder.remove_reagent("zombiepowder", 0.5)


		M:toxloss = max(M:toxloss-2,0)
		..()
		return
datum/reagent/stoxin
	name = "Sleep Toxin"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = LIQUID
	color_r = 99
	color_g = 193
	color_b = 143
	melting_temp = 253
	boiling_temp = 375
	medical = 1
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(!data) data = 1
		switch(data)
			if(1 to 15)
				M.eye_blurry = max(M.eye_blurry, 10)
			if(15 to 25)
				M:drowsyness  = max(M:drowsyness, 20)
			if(25 to INFINITY)
				M:paralysis = max(M:paralysis, 20)
				M:drowsyness  = max(M:drowsyness, 30)
		data++
		..()
		return

datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be used to stabilize an individuals body temperature."
	reagent_state = LIQUID
	color_r = 18
	color_g = 218
	color_b = 158
	melting_temp = 268
	boiling_temp = 370
	medical = 1
	disease_pause = 3
	disease_slowing = 2
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(M.bodytemperature > 310)
			M.bodytemperature = max(310, M.bodytemperature-20)
		else if(M.bodytemperature < 311)
			M.bodytemperature = min(310, M.bodytemperature+20)
		..()
		return
		*/

datum/reagent/nanites
	name = "Nanomachines"
	id = "nanites"
	description = "Microscopic construction robots."
	reagent_state = LIQUID
	color_r = 99
	color_g = 193
	color_b = 143
	melting_temp = 253
	boiling_temp = 375
	medical = 1
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(!data) data = 1
		M.updatehealth()
		switch(data)
			if(1 to 15)
				if(holder.has_reagent("copper"))
					holder.remove_reagent("nanites", 5)
				holder.add_reagent("nanites", 2)
			//	M.eye_blurry = max(M.eye_blurry, 10)
				if (prob(8))
					M << "Your joints feel stiff."
					M.take_organ_damage(1)
				if (prob(9))
					M << "\red Beep...boop.."
				if (prob(9))
					M << "\red Bop...beeep..."
				if (prob(3))
					M << "\red You feel stiff..."
			if(15 to 45)
				if(holder.has_reagent("copper"))
					holder.remove_reagent("nanites", 5)
				holder.add_reagent("nanites", 3)
			//	M:drowsyness  = max(M:drowsyness, 20)
				if (prob(8))
					M << "\red Your joints feel very stiff."
					M.take_organ_damage(1)
				if (prob(8))
					M.say(pick("Beep, boop", "beep, beep!", "Boop...bop", "100100010 1010101101 00101100101"))
				if (prob(10))
					M << "Your skin feels loose."
					M.take_organ_damage(5)
				if (prob(4))
					M << "\red You feel a stabbing pain in your head."
					M.paralysis += 2
				if (prob(4))
					M << "\red You can feel something move...inside."
			if(45 to 75)
				if(holder.has_reagent("copper"))
					holder.remove_reagent("nanites", 5)
				holder.add_reagent("nanites", 4)
			//	M:paralysis = max(M:paralysis, 20)
			//	M:drowsyness  = max(M:drowsyness, 30)
				if (prob(10))
					M << "\red Your skin feels very loose."
					M.take_organ_damage(8)
				if (prob(20))
					M.say(pick("beep, beep!", "Boop bop boop beep.", "kkkiiiill mmme", "I wwwaaannntt tttoo dddiiieeee..."))
				if (prob(8))
					M << "\red You can feel... something...inside you."
			if(75 to 100)
				if(holder.has_reagent("copper"))
					holder.remove_reagent("nanites", 5)
				holder.add_reagent("nanites", 5)
			//	M:drowsyness  = max(M:drowsyness, 20)
				M <<"\red Your skin feels as if it's about to burst off..."
				M.toxloss += 1
			//	M.updatehealth()
			//	M:Robotize()
			if(100 to INFINITY)
			//	holder.remove_reagent("nanites", 5)
				M:Robotize()//WHY DONT YOU WORK FOR THIS FUCK YOU GOD DAMN IT WHAT THE HELL
				//if(istype(M, /mob/living/carbon/human))
				//	spawn(10)
				//	M:Robotize()
		data++
		..()
		return


datum/reagent/babby
	name = "Preggers"
	id = "babby"
	description = "You done got knocked up."
	reagent_state = LIQUID
	color_r = 99
	color_g = 193
	color_b = 143
	melting_temp = 253
	boiling_temp = 375
	medical = 1
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(!data) data = 1
		M.updatehealth()
		switch(data)
			if(1 to 15)
				if(holder.has_reagent("ethanol"))
					holder.remove_reagent("babby", 5)
				holder.add_reagent("babby", 2)
				if(prob(1))
					M.emote("sneeze")
				if(prob(1))
					M.emote("cough")
				if(prob(1))
					M << "\red Your stomach feels larger."
				if(prob(1))
					M << "\red Your muscles ache.."
			if(15 to 45)
				if(holder.has_reagent("ethanol"))
					holder.remove_reagent("babby", 5)
				holder.add_reagent("babby", 2)
				if(prob(1))
					M << "\red Your stomach hurts.."
				if(prob(1))
					M << "\red You feel weak."
			if(45 to 75)
				if(holder.has_reagent("ethanol"))
					holder.remove_reagent("babby", 5)
				holder.add_reagent("babby", 2)
				if(prob(2))
					M << "\red Your muscles ache."
					if(prob(20))
						M.take_organ_damage(1)
				if(prob(2))
					M << "\red Your stomach hurts."
					if(prob(20))
						M.bruteloss += 1
						M.updatehealth()
			if(75 to INFINITY)
				M << "\red You feel something tearing its way out of your stomach..."
				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] lays down pain!", M), 1)
				M.toxloss += 1
				M.updatehealth()
				M.stunned += 4
				M.weakened += 4
				M.bruteloss += 1
				M.updatehealth()
				var/obj/livestock/baby/B = new /obj/livestock/baby(M.loc)
				var/babygender = pick("boy","girl")
				var/babyname
				if(babygender == "boy")
					babyname = capitalize(pick(first_names_male) + " " + pick(last_names))
				else if(babygender == "girl")
					babyname = capitalize(pick(first_names_female) + " " + pick(last_names))
				var/new_baby = input(M, "You just had a baby! It's a [babygender]!", "Name change", babyname)

				if ( (length(new_baby) == 0) || (new_baby == "[babyname]") )
					new_baby = babyname

				if(new_baby)
					if (length(new_baby) >= 26)
						new_baby = copytext(new_baby, 1, 26)
						new_baby = dd_replacetext(new_baby, ">", "'")
				B.name = new_baby
				B.babygender = babygender
				holder.remove_reagent("babby", 500)
				//del(src)
		data++
		..()
		return


datum/reagent/gastricejections
	name = "Gastric Ejections"
	id = "gastricejections"
	description = "You done ate poo poo."
	reagent_state = LIQUID
	color_r = 99
	color_g = 193
	color_b = 143
	melting_temp = 253
	boiling_temp = 375
	medical = 1
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(!data) data = 1
		M.updatehealth()
		switch(data)
			if(1 to 15)
				if(holder.has_reagent("spaceacillin"))
					holder.remove_reagent("gastricejections", 50)
				holder.add_reagent("gastricejections", 2)
				if(M.sleeping && prob(40))
					M << "\blue You feel better."
					holder.remove_reagent("gastricejections", 500)
					return
				else if (prob(6))
					M << "You feel your stomach rumble."
				else if (prob(5))
					M.emote("shiver")
			if(15 to 45)
				if(holder.has_reagent("spaceacillin"))
					holder.remove_reagent("gastricejections", 50)
				holder.add_reagent("gastricejections", 2)
				if(M.sleeping && prob(30))
					M << "\blue You feel better."
					M.virus = null
					return
				else if (prob(8))
					M.emote("shiver")
				else if(prob(5))
					new /obj/decal/cleanable/poo/drip(M.loc)
				else if (prob(10))
					playsound(M.loc, 'poo2.ogg', 50, 1)
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] lets out a foul-smelling fart!", M), 1)
						if(prob(5))
							new /obj/decal/cleanable/poo/drip(M.loc)
			if(45 to 75)
				if(holder.has_reagent("spaceacillin"))
					holder.remove_reagent("gastricejections", 50)
				holder.add_reagent("gastricejections", 2)
				if(M.sleeping && prob(20))
					M << "\blue You feel better."
					holder.remove_reagent("gastricejections", 500)
					return
				else if (prob(10))
					M.emote("groan")
				else if (prob(10))
					M.emote("vomit")
				else if (prob(8))
					playsound(M.loc, 'poo2.ogg', 50, 1)
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] farts, leaking diarrhea down their legs!", M), 1)
					new /obj/decal/cleanable/poo(M.loc)
				else if (prob(2))
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] keels over in pain!", M), 1)
					if(prob(5))
						new /obj/decal/cleanable/poo/drip(M.loc)
				else if(prob(5))
					new /obj/decal/cleanable/poo/drip(M.loc)
					M.toxloss += 1
					M.updatehealth()
					M.stunned += rand(1,3)
					M.weakened += rand(1,3)
			if(75 to INFINITY)
				if(holder.has_reagent("spaceacillin"))
					holder.remove_reagent("gastricejections", 50)
				if(M.sleeping && prob(15))
					M << "\blue You feel better."
					holder.remove_reagent("gastricejections", 5000) //dear lord, if someone gets it this high they deserve a special poo suit made just for them. - Nernums
					return
				else if (prob(8))
					playsound(M.loc, 'poo2.ogg', 50, 1)
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red []'s [] explodes violently with diarrhea!", M, pick("butt", "ass", "behind", "hindquarters")), 1)
					new /obj/decal/cleanable/poo(M.loc)
				else if (prob(2))
					for(var/mob/O in viewers(M, null))
						O.show_message(text("\red [] keels over in pain!", M), 1)
				else if(prob(5))
					new /obj/decal/cleanable/poo/drip(M.loc)
					M.toxloss += 1
					M.updatehealth()
					M.stunned += rand(2,4)
					M.weakened += rand(2,4)
				else if (prob(10))
					M.emote("vomit")
				//holder.remove_reagent("gastric_ejections", 500)
				//del(src)
		data++
		..()
		return