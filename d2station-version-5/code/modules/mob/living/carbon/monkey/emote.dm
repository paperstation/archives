/mob/living/carbon/monkey/emote(var/act)

	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)
	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	var/m_type = 1
	var/message

	var/t_his = "its"
	var/t_him = "it"
	var/canemote = 1

	switch(act)
		if("sign")
			if (!src.restrained())
				message = text("<B>The monkey</B> signs[].", (text2num(param) ? text(" the number []", text2num(param)) : null))
				m_type = 1
		if("scratch")
			if (!src.restrained())
				message = "<B>The [src.name]</B> scratches."
				m_type = 1
		if("whimper")
			if (!muzzled)
				message = "<B>The [src.name]</B> whimpers."
				m_type = 2
		if("roar")
			if (!muzzled)
				message = "<B>The [src.name]</B> roars."
				m_type = 2
		if("tail")
			message = "<B>The [src.name]</B> waves his tail."
			m_type = 1
		if("gasp")
			message = "<B>The [src.name]</B> gasps."
			m_type = 2
		if("shiver")
			message = "<B>The [src.name]</B> shivers."
			m_type = 2
		if("drool")
			message = "<B>The [src.name]</B> drools."
			m_type = 1
		if("paw")
			if (!src.restrained())
				message = "<B>The [src.name]</B> flails his paw."
				m_type = 1
		if("scretch")
			if (!muzzled)
				message = "<B>The [src.name]</B> scretches."
				m_type = 2
		if("choke")
			message = "<B>The [src.name]</B> chokes."
			m_type = 2
		if("moan")
			message = "<B>The [src.name]</B> moans!"
			m_type = 2
		if("nod")
			message = "<B>The [src.name]</B> nods his head."
			m_type = 1
		if("sit")
			message = "<B>The [src.name]</B> sits down."
			m_type = 1
		if("sway")
			message = "<B>The [src.name]</B> sways around dizzily."
			m_type = 1
		if("sulk")
			message = "<B>The [src.name]</B> sulks down sadly."
			m_type = 1
		if("twitch")
			message = "<B>The [src.name]</B> twitches violently."
			m_type = 1
		if("dance")
			if (!src.restrained())
				message = "<B>The [src.name]</B> dances around happily."
				m_type = 1
		if("roll")
			if (!src.restrained())
				message = "<B>The [src.name]</B> rolls."
				m_type = 1
		if("shake")
			message = "<B>The [src.name]</B> shakes his head."
			m_type = 1
		if("gnarl")
			if (!muzzled)
				message = "<B>The [src.name]</B> gnarls and shows his teeth.."
				m_type = 2
		if("jump")
			message = "<B>The [src.name]</B> jumps!"
			m_type = 1
		if("collapse")
			if (!src.paralysis)	src.paralysis += 2
			message = text("<B>[]</B> collapses!", src)
			m_type = 2
		if("deathgasp")
			message = "<b>The [src.name]</b> lets out a faint chimper as it collapses and stops moving..."
			m_type = 1
//D2K5 Emotes
		if("superfart")
			if(src.butt_op_stage == 4.0)
				src << "\blue You don't have a butt!"
				return
			if (src.nutrition >= 250)
				if(!infinitebutt)
					src.butt_op_stage = 4.0
					src.nutrition -= 100
					m_type = 2
				playsound(src.loc, 'fart.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'fart.ogg', 80, 1)
				src << "\blue Your butt falls off!"
				new /obj/item/clothing/head/butt(src.loc)
				new /obj/decal/cleanable/poo(src.loc)
				playsound(src.loc, 'superfart.ogg', 80, 0)
				for(var/mob/living/carbon/M in ohearers(6, src))
					if(istype(M, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = M
						if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
							continue
					M.stuttering += 10
					M.ear_deaf += 3
					M.weakened = 1
					if(prob(30))
						M.stunned = 3
						M.paralysis += 4
					else
						M.make_jittery(10)

		if("superwank")
			if(src.penis_op_stage == 4.0)
				src << "\blue You don't have a penis!"
				return
			if (src.nutrition >= 250)
				src.penis_op_stage = 4.0
				playsound(src.loc, 'squishy.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 65, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 70, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 75, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				sleep(1)
				playsound(src.loc, 'squishy.ogg', 80, 1)
				src << "\blue Your penis falls off!"
				new /obj/item/weapon/storage/cock(src.loc)
				new /obj/decal/cleanable/cum(src.loc)
				playsound(src.loc, 'supersquishy.ogg', 80, 0)
				for(var/mob/living/carbon/M in ohearers(6, src))
					M.weakened = 4
					M.stunned = 2
					new /obj/decal/cleanable/cum(M.loc)


		if("fart")
			if (src.nutrition >= 250)
				playsound(src.loc, 'fart.ogg', 65, 1)
				m_type = 2
				if(src.butt_op_stage == 4.0)
					src << "\blue You don't have a butt!"
					return
				switch(rand(1, 48))
					if(1)
						message = "<B>[src]</B> lets out a girly little 'toot' from his butt."

					if(2)
						message = "<B>[src]</B> farts loudly!"

					if(3)
						message = "<B>[src]</B> lets one rip!"

					if(4)
						message = "<B>[src]</B> farts! It sounds wet and smells like rotten eggs."

					if(5)
						message = "<B>[src]</B> farts robustly!"

					if(6)
						message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."

					if(7)
						message = "<B>[src]</B> queefed out his ass!"

					if(8)
						message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."

					if(9)
						message = "<B>[src]</B> farts a ten second long fart."

					if(10)
						message = "<B>[src]</B> groans and moans, farting like the world depended on it."

					if(11)
						message = "<B>[src]</B> breaks wind!"

					if(12)
						message = "<B>[src]</B> expels intestinal gas through the anus."

					if(13)
						message = "<B>[src]</B> release an audible discharge of intestinal gas."

					if(14)
						message = "\red <B>[src]</B> is a farting motherfucker!!!"

					if(15)
						message = "\red <B>[src]</B> suffers from flatulence!"

					if(16)
						message = "<B>[src]</B> releases flatus."

					if(17)
						message = "<B>[src]</B> releases gas generated in his digestive tract, his stomach and his intestines. \red<B>It stinks way bad!</B>"

					if(18)
						message = "<B>[src]</B> farts like your mom used to!"

					if(19)
						message = "<B>[src]</B> farts. It smells like Soylent Surprise!"

					if(20)
						message = "<B>[src]</B> farts. It smells like pizza!"

					if(21)
						message = "<B>[src]</B> farts. It smells like George Melons' perfume!"

					if(22)
						message = "<B>[src]</B> farts. It smells like atmos in here now!"

					if(23)
						message = "<B>[src]</B> farts. It smells like medbay in here now!"

					if(24)
						message = "<B>[src]</B> farts. It smells like the bridge in here now!"

					if(25)
						message = "<B>[src]</B> farts like a pubby!"

					if(26)
						message = "<B>[src]</B> farts like a goone!"

					if(27)
						message = "<B>[src]</B> farts so hard he's certain poop came out with it, but dares not find out."

					if(28)
						message = "<B>[src]</B> farts delicately."

					if(29)
						message = "<B>[src]</B> farts timidly."

					if(30)
						message = "<B>[src]</B> farts very, very quietly. The stench is OVERPOWERING."

					if(31)
						message = "<B>[src]</B> farts and says, \"Mmm! Delightful aroma!\""

					if(32)
						message = "<B>[src]</B> farts and says, \"Mmm! Sexy!\""

					if(33)
						message = "<B>[src]</B> farts and fondles his own buttocks."

					if(34)
						message = "<B>[src]</B> farts and fondles YOUR buttocks."

					if(35)
						message = "<B>[src]</B> fart in he own mouth. A shameful [src]."

					if(36)
						message = "<B>[src]</B> farts out pure plasma! \red<B>FUCK!</B>"
						src.achievement_give("Pure Plasma", 65)

					if(37)
						message = "<B>[src]</B> farts out pure oxygen. What the fuck did he eat?"

					if(38)
						message = "<B>[src]</B> breaks wind noisily!"

					if(39)
						message = "<B>[src]</B> releases gas with the power of the gods! The very station trembles!!"

					if(40)
						message = "<B>[src] \red f \blue a \black r \red t \blue s \black !</B>"

					if(41)
						message = "<B>[src] shat his pants!</B>"

					if(42)
						message = "<B>[src] shat his pants!</B> Oh, no, that was just a really nasty fart."

					if(43)
						message = "<B>[src]</B> is a flatulent whore."

					if(44)
						message = "<B>[src]</B> likes the smell of his own farts."

					if(45)
						message = "<B>[src]</B> doesnt wipe after he poops."

					if(46)
						message = "<B>[src]</B> farts! Now he smells like Tiny Turtle."

					if(47)
						message = "<B>[src]</B> burps! He farted out of his mouth!! That's Showtime's style, baby."

					if(48)
						message = "<B>[src]</B> laughs! His breath smells like a fart."

				for(var/mob/living/carbon/human/M in viewers(src, null))
					if(!M.stat && M.brainloss >= 60)
						spawn(10)
							if(prob(20))
								switch(pick(1,2,3))
									if(1)
										M.say("[M == src ? "i" : src.name] made a fart!!")
									if(2)
										M.emote("giggle")
									if(3)
										M.emote("clap")
				m_type = 2

		if(("poo") || ("poop") || ("shit") || ("crap"))
			if (src.nutrition <= 300)
				src.emote("fart")
				m_type = 2
			else
				message = "<B>[src]</B> poos on the floor."
				playsound(src.loc, 'fart.ogg', 60, 1)
				playsound(src.loc, 'squishy.ogg', 40, 1)
				src.achievement_give("The Brown Medal", 65)
				var/turf/location = src.loc

				new /obj/decal/cleanable/poo(location) //Places a stain of shit on the floor
				new /obj/item/weapon/reagent_containers/food/snacks/poo(location) //Spawns a turd

				if(!infinitebutt)
					src.nutrition = 250
					m_type = 2

				// check for being in sight of a working security camera
				if(seen_by_camera(src))
					// determine the name of the perp (goes by ID if wearing one)
					var/perpname = src.name
					if(src:wear_id && src:wear_id.registered)
						perpname = src:wear_id.registered
					// find the matching security record
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["name"] == perpname)
							for (var/datum/data/record/S in data_core.security)
								if (S.fields["id"] == R.fields["id"])
									// now add to rap sheet
									S.fields["criminal"] = "*Arrest*"
									S.fields["mi_crim"] = "Public defecation"
									break

		if(("pee") || ("urinate") || ("piss"))
			if(src.nutrition <= 300)
				message = "<B>[src]</B> attempts to urinate but nothing comes out."
			else
				new /obj/decal/cleanable/urine(src.loc)
				message = "<B>[src]</B> urinates themselves."
				src.nutrition = 250
				m_type = 1
			// check for being in sight of a working security camera
				if(seen_by_camera(src))
					// determine the name of the perp (goes by ID if wearing one)
					var/perpname = src.name
					if(src:wear_id && src:wear_id.registered)
						perpname = src:wear_id.registered
					// find the matching security record
					for(var/datum/data/record/R in data_core.general)
						if(R.fields["name"] == perpname)
							for (var/datum/data/record/S in data_core.security)
								if (S.fields["id"] == R.fields["id"])
									// now add to rap sheet
									S.fields["criminal"] = "*Arrest*"
									S.fields["mi_crim"] = "Public urination"
									break
				for(var/mob/living/carbon/human/M in viewers(src, null))
					if(!M.stat && M.brainloss >= 60)
						spawn(10)
							if(prob(20))
								switch(pick(1,2,3))
									if(1)
										M.say("[M == src ? "i" : src.name] made pee pee, heeheeheeeeeeee!")
									if(2)
										M.emote("giggle")
									if(3)
										M.emote("clap")

		if(("vomit") || ("puke") || ("throwup"))
			if(src.nutrition <= 300)
				message = "<B>[src]</B> attempts to vomit but nothing comes out."
			else
				new /obj/decal/cleanable/vomit(src.loc)
				message = "<B>[src]</B> vomits on the floor."
				src.nutrition = 250
			m_type = 1

		if("rape")
			if(src.penis_op_stage == 4.0)
				src << "\blue You don't have a penis!"
				return
			var/M = null
			if (param)
				for (var/mob/A in view(1, null))
					if (param == A.name)
						M = A
						break
			if(!canemote)
				return
			if (M == src)
				M = null
			if (!src.client.goon)
				return
			if (M)
				if (M:gender == MALE)
					t_his = "his"
					t_him = "him"
				else if (M:gender == FEMALE)
					t_his = "her"
					t_him = "her"

				if (!src.turnedon)
					usr << "\red You aren't horny enough to want to rape [M]."
					return

				if (M:turnedon)
					usr << "\red [M] also seems horny, perhaps you could have sex with them instead!"
					return

				if (!istype(src.equipped(), /obj/item/weapon/grab))
					usr << "\red You must have a tight grip to rape [M]!"
					return
				if (M:w_uniform)
					src << "\red You must take off their uniform first!"
					return
				src.turnedon = 0
				if (src.gender == MALE)
					message = "<B>[src]</B>'s grabs [M] and pins [t_his] arms behind [t_his] back!"
				else if (src.gender == FEMALE)
					message = "<B>[src]</B>'s grabs [M] and pins [t_his] arms behind [t_his] back!"
				M:weakened = 4
				M:bruteloss++
				M:loc = src.loc
				spawn(0)
					M:stunned = 2
					spawn(30)
						if (src.gender == MALE)
							switch(rand(1, 3))
								if(1)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\red [M] gasps for air as [src] grabs [t_him] and shoves his dripping erection unexpectedly between [t_his] lips."))
										spawn(5)
										H.show_message(text("\red [src] slowly fucks [M]'s upturned face, slamming his dick into [t_his] throat."))
								if(2)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\red [M] struggles as [src] grabs [t_him] and shoves his cock into [t_his] ass."))
										spawn(5)
										H.show_message(text("\red [src] slowly fucks [M]'s ass, slamming his dick hard and choking [t_him]."))
								if(3)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\red [M] struggles as [src] grabs [t_him] and shoves his fingers into [t_his] ass."))
										spawn(5)
										H.show_message(text("\red [src] slides his fingers in and out of [M]'s ass."))
						else if (src.gender == FEMALE)
							switch(rand(1, 3))
								if(1)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\red [src] smiles, and pulls [M] close, while they struggle to escape."))
										spawn(5)
										H.show_message(text("\red [src] slowly rubs [M]'s genitals while fingering her own."))
								if(2)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\red [M] panics as [src] grabs [t_him] and forces [t_him] to kneel."))
										spawn(5)
										H.show_message(text("\red [src] forces [M]'s face against her pussy, making [t_him] lick her dripping wet cunt."))
								if(3)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\red [M] struggles to get away as [src] grabs [t_him] and pushes [t_him] down."))
										spawn(5)
										H.show_message(text("\red [src] slides her fingers in and out of [M]'s ass."))
					spawn(0)
						if(do_after(src, 200))
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\red [src] gasps and moans as they orgasm on [M], pushing [M] down and leaving [t_him] there."))
							src.achievement_give("The Pope", 66)
							M:weakened = 15
							M:bruteloss++
							M:turnedon = 0
							src.health++
							src.turnedon = 0
							new /obj/decal/cleanable/cum(M:loc)
							new /obj/decal/cleanable/cum(src:loc)
							if (M:gender == FEMALE)
								M:contract_disease(new /datum/disease/baby,1)
							m_type = 1
						// check for being in sight of a working security camera
							if(seen_by_camera(src))
								// determine the name of the perp (goes by ID if wearing one)
								var/perpname = src.name
								if(src:wear_id && src:wear_id.registered)
									perpname = src:wear_id.registered
								// find the matching security record
								for(var/datum/data/record/R in data_core.general)
									if(R.fields["name"] == perpname)
										for (var/datum/data/record/S in data_core.security)
											if (S.fields["id"] == R.fields["id"])
												// now add to rap sheet
												S.fields["criminal"] = "*Arrest*"
												S.fields["mi_crim"] = "Rape"
												break
			else
				src << "\red You must specify who you want to rape, 'say *rape-Test Dummy' for example."


		if(("sex") || ("fuck") || ("caress"))
			if(src.penis_op_stage == 4.0)
				src << "\blue You don't have a penis!"
				return
			var/M = null
			if (param)
				for (var/mob/A in view(1, null))
					if (param == A.name)
						M = A
						break
			if (M == src)
				M = null
			if(!canemote)
				return
			if (!src.client.goon)
				return
			if (M)
				if (M:gender == MALE)
					t_his = "his"
					t_him = "him"
				else if (M:gender == FEMALE)
					t_his = "her"
					t_him = "her"
				if (!src.turnedon)
					usr << "\red You aren't horny enough to want to have sex with [M]!"
					return
				if (!M:turnedon)
					usr << "\red [M] isn't horny, you can't have sex with [t_him]!"
					return
				if (!istype(src.equipped(), /obj/item/weapon/grab))
					usr << "\red You must have a tight grip to have sex with [M]!"
					return
				if (M:w_uniform)
					src << "\red You must take off their uniform first!"
					return
				src.turnedon = 0
				M:turnedon = 0
				message = "<B>[src]</B>'s grabs [M] and pulls [t_him] close, starting to play with them sexually."
				M:weakened = 4
				M:loc = src.loc
				spawn(0)
					src.stunned = 2
					M:stunned = 2
					spawn(30)
						if (src.gender == MALE)
							switch(rand(1, 4))
								if(1)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [M] sucks [src]'s cock."))
								if(2)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [src] slowly fucks [M]'s ass, slamming his dick hard."))
								if(3)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [src] slides his fingers in and out of [M]'s ass."))
								if(4)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [src] begins to rub [M]'s genitals."))
						else if (src.gender == FEMALE)
							switch(rand(1, 4))
								if(1)

									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [src] gently rubs [M]'s genitals while fingering her pussy."))
								if(2)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [M] begins to lick [src]'s dripping pussy."))
								if(3)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [src] slides her fingers in and out of [M]'s ass."))
								if(4)
									for(var/mob/H in hearers(src, null))
										H.show_message(text("\blue [src] begins to rub [M]'s genitals."))
					spawn(0)
						if(do_after(src, 200))
							M:weakened = 15
							src.weakened = 12
							src.turnedon = 0
							M:turnedon = 0
							M:bruteloss--
							M:health++
							src.bruteloss--
							src.health++
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\blue [src] gasps and moans as they orgasm together, both dropping down to relaxation."))
							new /obj/decal/cleanable/cum(M:loc)
							new /obj/decal/cleanable/cum(src:loc)
							if (M:gender == FEMALE)
								M:contract_disease(new /datum/disease/baby,1)
							m_type = 1
							// check for being in sight of a working security camera
							if(seen_by_camera(src))
								// determine the name of the perp (goes by ID if wearing one)
								var/perpname = src.name
								if(src:wear_id && src:wear_id.registered)
									perpname = src:wear_id.registered
								// find the matching security record
								for(var/datum/data/record/R in data_core.general)
									if(R.fields["name"] == perpname)
										for (var/datum/data/record/S in data_core.security)
											if (S.fields["id"] == R.fields["id"])
												// now add to rap sheet
												S.fields["criminal"] = "*Arrest*"
												S.fields["mi_crim"] = "Public Sex"
												break
			else
				src << "\red You must specify who you want to have sex with, 'say *sex-Test Dummy' for example."


		if(("wank") || ("masturbate"))
			if(src.penis_op_stage == 4.0)
				src << "\blue You don't have a penis!"
				return
			var/M = null
			if (param)
				for (var/atom/A as mob|obj|turf|area in view(1, null))
					if (param == A.name)
						M = A
						break
			if (M == src)
				M = null
			if(!canemote)
				return
			if (!src.client.goon)
				return
			if (!src.turnedon)
				usr << "\red You aren't horny enough to masturbate."
				return
			if (M)
				src.turnedon = 0
				src << "\red You attempt to masturbate onto [M]."
				if (src.gender == MALE)
					message = "<B>[src]</B>'s eyes glaze over as he expertly strokes his aroused prong."
				else if (src.gender == FEMALE)
					message = "<B>[src]</B> finger-fucks her pussy."
				spawn(0)
					src.stunned = 2
					spawn(10)
						if (src.gender == MALE)
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\blue <B>[src]</B> groans and pauses, just barely stroking his dick."))
						else if (src.gender == FEMALE)
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\blue <B>[src]</B> slides two fingers deep into her cunt, reaching for the g-spot."))
					if(do_after(src, 150))
						if (src.gender == MALE)
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\blue <B>[src]</B> groans and shoots a watery spurt of semen onto [M]."))
						else if (src.gender == FEMALE)
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\blue With a shuddering moan, <B>[src]</B> draws out her orgasm onto [M], varying the speed of her finger movements to maximize the waves of pleasure."))
						new /obj/decal/cleanable/cum(M:loc)
						src.turnedon = 0
					m_type = 1
					// check for being in sight of a working security camera
					if(seen_by_camera(src))
						// determine the name of the perp (goes by ID if wearing one)
						var/perpname = src.name
						if(src:wear_id && src:wear_id.registered)
							perpname = src:wear_id.registered
						// find the matching security record
						for(var/datum/data/record/R in data_core.general)
							if(R.fields["name"] == perpname)
								for (var/datum/data/record/S in data_core.security)
									if (S.fields["id"] == R.fields["id"])
										// now add to rap sheet
										S.fields["criminal"] = "*Arrest*"
										S.fields["mi_crim"] = "Public masturbation"
										break
//D2K5 Emotes
		if("help")
			src << "choke, collapse, dance, deathgasp, drool, gasp, shiver, gnarl, jump, paw, moan, nod, roar, roll, scratch,\nscretch, shake, sign-#, sit, sulk, sway, tail, twitch, whimper"
		else
			src << text("Invalid Emote: []", act)
	if ((message && src.stat == 0))
		if (m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(703)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(746)
	return