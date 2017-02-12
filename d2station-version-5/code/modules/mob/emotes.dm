/mob/living/emote(var/act,var/m_type=1,var/message = null)
	var/param = null


	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	if (src.client && src.client.goon)
		cangoldemote = 1

	var/t_his = "its"
	var/t_him = "it"

	if (client && client.muted)
		return

	if(src.stat == 2)
		return

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	switch(act)
		if ("airguitar")
			if (!src.restrained())
				message = "<B>[src]</B> is strumming the air and headbanging like a safari chimp."
				m_type = 1

		if ("blink")
			message = "<B>[src]</B> blinks."
			m_type = 1

		if ("blink_r")
			message = "<B>[src]</B> blinks rapidly."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> bows to [param]."
				else
					message = "<B>[src]</B> bows."
			m_type = 1

		if ("custom")
			var/input = strip_html(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			input = sanitize(input)
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			message = "<B>[src]</B> [input]"

		if ("me")
			if(!(message))
				return
			else
				message = "<B>[src]</B> [message]"

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1

		if ("choke")
			if (!muzzled)
				message = "<B>[src]</B> chokes!"
				playsound(src.loc, 'choke.ogg', 40, 1)
				m_type = 2
			else
				message = "<B>[src]</B> makes a strong noise."
				playsound(src.loc, 'choke.ogg', 50, 1)
				m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2
		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings."
				m_type = 2

		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings ANGRILY!"
				m_type = 2

		if ("drool")
			message = "<B>[src]</B> drools."
			m_type = 1

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("chuckle")
			if (!muzzled)
				message = "<B>[src]</B> chuckles."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("twitch")
			message = "<B>[src]</B> twitches violently."
			playsound(src.loc, 'twitch.ogg', 40, 1)
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B> twitches."
			playsound(src.loc, 'twitch.ogg', 40, 1)
			m_type = 1

		if ("faint")
			message = "<B>[src]</B> faints."
			src.sleeping = 1
			m_type = 1

		if ("cough")
			if (!muzzled)
				if(src.reagents)
					var/obj/decal/D = new/obj/decal(get_turf(src))
					D.name = "chemicals"
					D.icon = 'chemical.dmi'
					D.icon_state = "sneezepuff"
					D.create_reagents(10)
					src.reagents.trans_to(D, 10)

					spawn(0)
						step(D, src.dir)
						D.reagents.reaction(get_turf(D))
						for(var/atom/T in get_turf(D))
							D.reagents.reaction(T)
						del(D)
				message = "<B>[src]</B> coughs!"
				playsound(src.loc, 'cough.ogg', 30, 1)
				m_type = 2
			else
				message = "<B>[src]</B> makes a strong noise."
				playsound(src.loc, 'cough.ogg', 35, 1)
				m_type = 2

		if ("frown")
			message = "<B>[src]</B> frowns."
			m_type = 1

		if ("nod")
			message = "<B>[src]</B> nods."
			m_type = 1

		if ("blush")
			message = "<B>[src]</B> blushes."
			m_type = 1

		if ("wave")
			message = "<B>[src]</B> waves."
			m_type = 1

		if ("gasp")
			if (!muzzled)
				message = "<B>[src]</B> gasps!"
				playsound(src.loc, 'gasp.ogg', 60, 1)
				m_type = 2
			else
				message = "<B>[src]</B> makes a weak noise."
				playsound(src.loc, 'gasp.ogg', 50, 1)
				m_type = 2

		if ("deathgasp")
			message = "<B>[src]</B> seizes up and falls limp, \his eyes dead and lifeless..."
			playsound(src.loc, 'gasp.ogg', 50, 1)
			m_type = 1

		if ("giggle")
			if (!muzzled)
				message = "<B>[src]</B> giggles."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> glares at [param]."
			else
				message = "<B>[src]</B> glares."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> stares at [param]."
			else
				message = "<B>[src]</B> stares."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> looks at [param]."
			else
				message = "<B>[src]</B> looks."
			m_type = 1

		if ("grin")
			message = "<B>[src]</B> grins."
			m_type = 1

		if ("cry")
			if (!muzzled)
				message = "<B>[src]</B> cries."
				m_type = 2
			else
				message = "<B>[src]</B> makes a weak noise. \He frowns."
				m_type = 2

		if ("sigh")
			if (!muzzled)
				message = "<B>[src]</B> sighs."
				m_type = 2
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("laugh")
			if (!muzzled)
				message = "<B>[src]</B> laughs."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("mumble")
			message = "<B>[src]</B> mumbles!"
			m_type = 2

		if ("grumble")
			if (!muzzled)
				message = "<B>[src]</B> grumbles!"
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("groan")
			if (!muzzled)
				message = "<B>[src]</B> groans!"
				m_type = 2
			else
				message = "<B>[src]</B> makes a loud noise."
				m_type = 2

		if ("moan")
			message = "<B>[src]</B> moans!"
			m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows his name out in smoke."
				m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "<B>[src]</B> points."
				else
					M.point()

				if (M)
					message = "<B>[src]</B> points to [M]."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> raises a hand."
			m_type = 1

		if ("shake")
			message = "<B>[src]</B> shakes \his head."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("smile")
			message = "<B>[src]</B> smiles."
			m_type = 1

		if ("shiver")
			message = "<B>[src]</B> shivers."
			m_type = 2

		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("tremble")
			message = "<B>[src]</B> trembles in fear!"
			m_type = 1

		if ("sneeze")
			if (!muzzled)
				if(src.reagents)
					var/obj/decal/D = new/obj/decal(get_turf(src))
					D.name = "chemicals"
					D.icon = 'chemical.dmi'
					D.icon_state = "sneezepuff"
					D.create_reagents(10)
					src.reagents.trans_to(D, 10)

					spawn(0)
						step(D, src.dir)
						D.reagents.reaction(get_turf(D))
						for(var/atom/T in get_turf(D))
							D.reagents.reaction(T)
						del(D)
				message = "<B>[src]</B> sneezes."
				m_type = 2
			else
				message = "<B>[src]</B> makes a strange noise."
				m_type = 2

		if ("sniff")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore")
			if (!muzzled)
				message = "<B>[src]</B> snores."
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("whimper")
			if (!muzzled)
				message = "<B>[src]</B> whimpers."
				m_type = 2
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("wink")
			message = "<B>[src]</B> winks."
			m_type = 1


		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> yawns."
				m_type = 2

		if ("collapse")
			if (!src.paralysis)
				src.paralysis += 2
			message = "<B>[src]</B> collapses!"
			m_type = 2

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					src << "\red You must specify who you want to hug, 'say *hug-Test Dummy' for example."

		if("winkat")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> winks at [M]."

		if("pinchat")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> pinches [M]'s ass."

		if("kiss")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> kisses [M]."
				else
					src << "\red You must specify who you want to kiss, 'say *kiss-Test Dummy' for example."

		if("milk")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M:gender == MALE)
						message = "<B>[src]</B> begins to milk [M] from his penis."

						spawn(30)
							if(M:s_tone < -80)
								var/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk/V = new/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk(M:loc)
								V.name = "[M:name]'s [V.name]"
							else
								var/obj/item/weapon/reagent_containers/food/drinks/penismilk/V = new/obj/item/weapon/reagent_containers/food/drinks/penismilk(M:loc)
								V.name = "[M:name]'s [V.name]"
					else if (M:gender == FEMALE)
						message = "<B>[src]</B> begins to milk [M] from her breasts."
						spawn(30)
							if(M:s_tone < -80)
								var/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk/V = new/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk(M:loc)
								V.name = "[M:name]'s [V.name]"
							else
								var/obj/item/weapon/reagent_containers/food/drinks/milk/V = new/obj/item/weapon/reagent_containers/food/drinks/milk(M:loc)
								V.name = "[M:name]'s [V.name]"
					else
						message = "<B>[src]</B> begins to milk [M] from their penis and breasts."
						spawn(30)
							if(M:s_tone < -80)
								var/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk/V = new/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk(M:loc)
								V.name = "[M:name]'s [V.name]"
							else
								var/obj/item/weapon/reagent_containers/food/drinks/soymilk/V = new/obj/item/weapon/reagent_containers/food/drinks/soymilk(M:loc)
								V.name = "[M:name]'s [V.name]"
				else
					src << "\red You must specify who you want to milk, 'say *milk-Test Dummy' for example."


		if("cuddle")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> cuddles [M]."
				else
					src << "\red You must specify who you want to cuddle, 'say *cuddle-Test Dummy' for example."


		if("snuggle")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> snuggles [M]."
				else
					src << "\red You must specify who you want to snuggle, 'say *snuggle-Test Dummy' for example."


		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if("brofist")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> brofists [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to brofist, and brofists \himself. Shameful."

		if ("scream")
			if (!muzzled)
				message = "<B>[src]</B> screams!"
				m_type = 2
			else
				message = "<B>[src]</B> makes a very loud noise."
				m_type = 2
//D2K5 Emotes

		if("superfart")
			if(src.butt_op_stage == 4.0)
				src << "\blue You don't have a butt!"
				return
			if (src.nutrition >= 250)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				emote("fart")
				sleep(1)
				if(!infinitebutt)
					src.butt_op_stage = 4.0
					src.nutrition -= 100
					m_type = 2
				src << "\blue Your butt falls off!"
				new /obj/item/clothing/head/butt(src.loc)
				new /obj/decal/cleanable/poo(src.loc)
				playsound(src.loc, 'superfart.ogg', 80, 0)
				for(var/mob/living/carbon/M in ohearers(6, src))
					if(istype(M, /mob/living/carbon/human))
						var/mob/H = M
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
				if(src.reagents)
					var/obj/decal/D = new/obj/decal(get_turf(src))
					D.name = "chemicals"
					D.icon = 'chemical.dmi'
					D.icon_state = "sneezepuff"
					D.create_reagents(3)
					src.reagents.trans_to(D, 3)

					spawn(0)
						step(D, turn(src.dir, 180))
						D.reagents.reaction(get_turf(D))
						for(var/atom/T in get_turf(D))
							D.reagents.reaction(T)
						del(D)
				switch(rand(1, 48))
					if(1)
						message = "<B>[src]</B> lets out a girly little 'toot' from \his butt."

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
						message = "<B>[src]</B> queefed out \his ass!"

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
						message = "<B>[src]</B> releases gas generated in \his digestive tract, \his stomach and \his intestines. \red<B>It stinks way bad!</B>"

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
						message = "<B>[src]</B> farts and fondles \his own buttocks."

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
						message = "<B>[src] shat \his pants!</B>"

					if(42)
						message = "<B>[src] shat \his pants!</B> Oh, no, that was just a really nasty fart."

					if(43)
						message = "<B>[src]</B> is a flatulent whore."

					if(44)
						message = "<B>[src]</B> likes the smell of \his own farts."

					if(45)
						message = "<B>[src]</B> doesnt wipe after he poops."

					if(46)
						message = "<B>[src]</B> farts! Now he smells like Tiny Turtle."

					if(47)
						message = "<B>[src]</B> burps! He farted out of \his mouth!! That's Showtime's style, baby."

					if(48)
						message = "<B>[src]</B> laughs! His breath smells like a fart."

				for(var/mob/M in viewers(src, null))
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
				if (src.w_uniform)
					message = "<B>[src]</B> poos in their uniform."
					playsound(src.loc, 'fart.ogg', 60, 1)
					playsound(src.loc, 'squishy.ogg', 40, 1)
					src.achievement_give("The Brown Medal", 65)
					src.nutrition -= 80
					m_type = 2
				else
					message = "<B>[src]</B> poos on the floor."
					playsound(src.loc, 'fart.ogg', 60, 1)
					playsound(src.loc, 'squishy.ogg', 40, 1)
					src.achievement_give("The Brown Medal", 65)
					var/turf/location = src.loc

					var/obj/decal/cleanable/poo/D = new/obj/decal/cleanable/poo(location)
					if(src.reagents)
						src.reagents.trans_to(D, 10)

					var/obj/item/weapon/reagent_containers/food/snacks/poo/V = new/obj/item/weapon/reagent_containers/food/snacks/poo(location)
					if(src.reagents)
						src.reagents.trans_to(V, 10)

					if(!infinitebutt)
						src.nutrition -= 80
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


		if("cum")
			if(src.nutrition <= 300)
				message = "<B>[src]</B> attempts to cum but nothing comes out."
			else
				if (src.w_uniform)
					if (src.gender == MALE)
						t_his = "his"
						t_him = "him"
					else if (src.gender == FEMALE)
						t_his = "her"
						t_him = "her"
					message = "<B>[src]</B> cums in [t_his] panties."
					src.nutrition -= 80
				else
					var/obj/decal/cleanable/urine/D = new/obj/decal/cleanable/cum(src.loc)
					if(src.reagents)
						src.reagents.trans_to(D, 10)
					message = "<B>[src]</B> cums on the floor."
					src.nutrition -= 80
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
										S.fields["mi_crim"] = "Public cumming"
										break


		if(("pee") || ("urinate") || ("piss"))
			if(!src.reagents)
				message = "<B>[src]</B> attempts to urinate but nothing comes out."
			else
				if (src.w_uniform)
					message = "<B>[src]</B> urinates in their uniform."
					src.nutrition -= 80
				else
					var/obj/decal/cleanable/urine/D = new/obj/decal/cleanable/urine(src.loc)
					if(src.reagents)
						src.reagents.trans_to(D, 10)
					message = "<B>[src]</B> urinates themselves."
					src.nutrition -= 80
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
					for(var/mob/M in viewers(src, null))
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
			if(!src.reagents || src.nutrition <= 300)
				message = "<B>[src]</B> attempts to vomit but nothing comes out."
			else
				var/obj/decal/cleanable/vomit/V = new/obj/decal/cleanable/vomit(src.loc)
				if(src.reagents)
					src.reagents.trans_to(V, 10)
				message = "<B>[src]</B> vomits on the floor."
				src.nutrition -= 80
				if(src.dizziness)
					src.dizziness -= rand(2,15)
				if(src.drowsyness)
					src.drowsyness -= rand(2,15)
				if(src.stuttering)
					src.stuttering -= rand(2,15)
				if(src.confused)
					src.confused -= rand(2,15)
			m_type = 1

		if("rape")
			if(emotetime > 0)
				src << "\red No more than one emote per 5 seconds please!"
				return
			else
				src.emotetime = 10
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
			if (!src.client.goon || !cangoldemote)
				return
			if (M)
				if (M:gender == MALE)
					t_his = "his"
					t_him = "him"
				else if (M:gender == FEMALE)
					t_his = "her"
					t_him = "her"

				//if (!M:stat || M:weakened != 0 || M:stunned != 0)
				//	usr << "\red [M] must be knocked down!"
				//	return

				if (src.gender == MALE)
					message = "<B>[src]</B>'s grabs [M] and pins [t_his] arms behind [t_his] back!"
				else if (src.gender == FEMALE)
					message = "<B>[src]</B>'s grabs [M] and pins [t_his] arms behind [t_his] back!"
				M:weakened = 4
				M:bruteloss++
				M:loc = src.loc
				spawn(0)
					src.moaning = 1
					M:panicing = 1
					//src.underwear = 0
					//M:underwear = 0
					M:stunned = 2
					moansounds()
					panicsounds()
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
							//src.underwear = 1
							//M:underwear = 1
							src.moaning = 0
							M:panicing = 0
							src.health++

							new /obj/decal/cleanable/cum(M:loc)
							var/obj/decal/cleanable/urine/D = new/obj/decal/cleanable/cum(src:loc)
							if(src.reagents)
								src.reagents.trans_to(D, 10)
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
			if(emotetime > 0)
				src << "\red No more than one emote per 5 seconds please!"
				return
			else
				src.emotetime = 10
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
			if (!src.client.goon || !cangoldemote)
				return
			if (M)
				if (M:gender == MALE)
					t_his = "his"
					t_him = "him"
				else if (M:gender == FEMALE)
					t_his = "her"
					t_him = "her"
				if (!istype(src.equipped(), /obj/item/weapon/grab))
					usr << "\red You must have a tight grip to have sex with [M]!"
					return
				if (M:w_uniform)
					src << "\red You must take off their uniform first!"
					return
				message = "<B>[src]</B>'s grabs [M] and pulls [t_him] close, starting to play with them sexually."
				M:weakened = 4
				M:loc = src.loc
				spawn(0)
					src.moaning = 1
					M:moaning = 1
					src.stunned = 2
					//src.underwear = 0
					//M:underwear = 0
					M:stunned = 2
					moansounds()
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
							src.moaning = 0
							M:moaning = 0
							//src.underwear = 1
							//M:underwear = 1
							M:bruteloss--
							M:health++
							src.bruteloss--
							src.health++
							for(var/mob/H in hearers(src, null))
								H.show_message(text("\blue [src] gasps and moans as they orgasm together, both dropping down to relaxation."))
							new /obj/decal/cleanable/cum(M:loc)
							var/obj/decal/cleanable/urine/D = new/obj/decal/cleanable/cum(src.loc)
							if(src.reagents)
								src.reagents.trans_to(D, 10)
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
			if(emotetime > 0)
				src << "\red No more than one emote per 5 seconds please!"
				return
			else
				src.emotetime = 10
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
			if (!src.client.goon || !cangoldemote)
				return
			if (M)
				src << "\red You attempt to masturbate onto [M]."
				if (src.gender == MALE)
					message = "<B>[src]</B>'s eyes glaze over as he expertly strokes his aroused prong."
				else if (src.gender == FEMALE)
					message = "<B>[src]</B> finger-fucks her pussy."
				spawn(0)
					src.moaning = 1
					//src.underwear = 0
					src.stunned = 2
					moansounds()
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
						var/obj/decal/cleanable/urine/D = new/obj/decal/cleanable/cum(M:loc)
						if(src.reagents)
							src.reagents.trans_to(D, 10)
						src.moaning = 0
						//src.underwear = 1
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
			else
				src << "\red You must specify what you want to orgasm onto, 'say *wank-wall' for example (any objects, including humans, will work)."

		if ("help")
			src << "blink, blink_r, blush, bow-(person), burp, choke, chuckle, clap, collapse, cough,\ncry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(person), kiss-(person), snuggle-(person), cuddle-(person), glare-(person),\ngrin, laugh, look-(person), moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(person), tremble, twitch, twitch_s, whimper,\nwink, yawn, fart, poo, pee, vomit, cum, milk-(person)"
		else
			src << "\blue Unusable emote '[act]'. Say *help for a list."

	if (message)
		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src.loc, null))
				O.show_message(message, m_type)

/mob/proc/moansounds()
	if(src.moaning)
		if (istype(src.equipped(), /obj/item/weapon/grab))
			if(prob(30)) src.emote(pick("moan","giggle","smile","gasp","blush","whimper"))
			spawn(10)
				moansounds()
		else
			src.moaning = 0

/mob/proc/panicsounds()
	if(src.panicing)
		if (istype(src.equipped(), /obj/item/weapon/grab))
			if(prob(30)) src.emote(pick("gasp","scream","choke","cry","shake","shiver"))
			spawn(10)
				panicsounds()
		else
			src.moaning = 0

/mob/verb/handshake()
	set name = "Shake hands with"
	set desc = "Shake hands with someone"
	set src in oview(1)
	usr.emote("handshake-[src.name]")

/mob/verb/brofist()
	set name = "Brofist"
	set desc = "Brofist someone"
	set src in oview(1)
	usr.emote("brofist-[src.name]")

/mob/verb/salute()
	set name = "Salute to"
	set desc = "Salute to someone"
	set src in oview(10)
	usr.emote("salute-[src.name]")

/mob/verb/glare()
	set name = "Glare at"
	set desc = "Glare at someone"
	set src in oview(10)
	usr.emote("glare-[src.name]")

/mob/verb/look()
	set name = "Look at"
	set desc = "Look at someone"
	set src in oview(10)
	usr.emote("look-[src.name]")

/mob/verb/stare()
	set name = "Stare at"
	set desc = "Stare at someone"
	set src in oview(10)
	usr.emote("stare-[src.name]")

/mob/verb/bow()
	set name = "Bow down to"
	set desc = "Bow down to someone"
	set src in oview(10)
	usr.emote("bow-[src.name]")

/mob/verb/hug()
	set name = "Hug"
	set desc = "Hug someone"
	set src in oview(1)
	usr.emote("hug-[src.name]")

/mob/verb/kiss()
	set name = "Kiss"
	set desc = "Kiss someone"
	set src in oview(1)
	usr.emote("kiss-[src.name]")

/mob/verb/cuddle()
	set name = "Cuddle"
	set desc = "Cuddle someone"
	set src in oview(1)
	usr.emote("cuddle-[src.name]")

/mob/verb/snuggle()
	set name = "Snuggle"
	set desc = "snuggle someone"
	set src in oview(1)
	usr.emote("snuggle-[src.name]")

/mob/verb/sex()
	set name = "Sex"
	set desc = "Attempt to have sex with a person"
	set src in oview(1)
	if(usr.client.goon)
		usr.emote("sex-[src.name]")
	else
		usr.emote("superfart")

/mob/verb/milk()
	set name = "Milk"
	set desc = "Attempt to milk a person"
	set src in oview(1)
	usr.emote("milk-[src.name]")

/mob/verb/rape()
	set name = "Rape"
	set desc = "Attempt to rape a person"
	set src in oview(1)
	if(usr.client.goon)
		usr.emote("rape-[src.name]")
	else
		usr.emote("superfart")

/atom/verb/wank()
	set name = "Masturbate Onto"
	set src in oview(1)

	if (!usr || !isturf(usr.loc))
		return
	else if (usr.stat != 0 || usr.restrained())
		return

	var/tile = get_turf(src)
	if (!tile)
		return
	if(usr.client.goon)
		usr.emote("wank-[src.name]")
	else
		usr.emote("superfart")