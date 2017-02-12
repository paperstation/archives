//This only assumes that the mob has a body and face with at least one eye, and one mouth.
//Things like airguitar can be done without arms, and the flap thing makes so little sense it's a keeper.
//Intended to be called by a higher up emote proc if the requested emote isn't in the custom emotes.

/mob/living/carbon/emote(var/act,var/m_type=1,var/message = null)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = is_muzzled()
	//var/m_type = 1

	switch(act)//Even carbon organisms want it alphabetically ordered..
		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings ANGRILY!"
				m_type = 2

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

		if ("blush")
			message = "<B>[src]</B> blushes."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
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

		if ("burp")
			playsound(src.loc, 'sound/misc/burp.ogg', 50, 0, 3)
			message = "<B>[src]</B> burps."
			m_type = 2

		if ("choke")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a strong noise."
				m_type = 2

		if ("chuckle")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2

		if ("cough")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a strong noise."
				m_type = 2

		if ("deathgasp")
			message = "<B>[src]</B> seizes up and falls limp, \his eyes dead and lifeless..."
			m_type = 1

		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings."
				m_type = 2

		if ("gasp")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("giggle")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("laugh")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a noise."

		if ("nod")
			message = "<B>[src]</B> nods."
			m_type = 1

		if ("scream")
			message = "<B>[src]</B> screams!"
			m_type = 2

		if ("shake")
			message = "<B>[src]</B> shakes \his head."
			m_type = 1

		if ("sneeze")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a strange noise."
				m_type = 2

		if ("sigh")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> sighs."
				m_type = 2

		if ("sniff")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("whimper")
			if (!muzzled)
				..(act)
			else
				message = "<B>[src]</B> makes a weak noise."
				m_type = 2

		if ("wink")
			message = "<B>[src]</B> winks."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				..(act)

		if ("fart")// you get the idea, working out the syntax for how to add more fart messages is a nobrainer (dont be retarded)
			var/obj/item/clothing/head/butt/B = null
			B = locate() in src.internal_organs
			if(!B)
				src << "\red You don't have a butt!"
				return
			for(var/mob/M in range(0))
				if(M != src)
					visible_message("\red <b>[src]</b> farts in <b>[M]</b>'s face!")
				else
					continue
			message = "<B>[src]</B> [pick(
			"rears up and lets loose a fart of tremendous magnitude!",
			"farts!",
			"toots.",
			"harvests methane from uranus at mach 3!",
			"assists global warming!",
			"farts and waves their hand dismissively.",
			"farts and pretends nothing happened.",
			"is a <b>farting</b> motherfucker!",
			"<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>")]"
			playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
			src.nutrition -= 25
			if(prob(12))
				B = locate() in src.internal_organs
				if(B)
					src.internal_organs -= B
					new /obj/item/clothing/head/butt(src.loc)
					new /obj/effect/decal/cleanable/blood(src.loc)
				for(var/mob/living/M in range(0))
					if(M != src)
						visible_message("\red <b>[src]</b>'s ass hits <b>[M]</b> in the face!", "\red Your ass smacks <b>[M]</b> in the face!")
						M.apply_damage(15,"brute","head")
				visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")

			for(var/obj/item/weapon/storage/book/bible/CUL8 in range(0))
				var/obj/effect/lightning/L = new /obj/effect/lightning()
				L.loc = get_turf(src.loc)
				L.layer = src.layer+1
				L.icon_state = "lightning"
				playsound(CUL8,'sound/effects/thunder.ogg',90,1)
				spawn(10)
					src.gib()
					spawn(10)
						del(L)

//		if ("poo") //lolno

		if("superfart") //how to remove ass
			var/obj/item/clothing/head/butt/B = null
			B = locate() in src.internal_organs
			if(!B)
				src << "\red You don't have a butt!"
				return
			else if(B)
				src.internal_organs -= B
			//src.butt = null
			src.nutrition -= 500
			playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
			spawn(1)
				playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
				spawn(1)
					playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
					spawn(1)
						playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
						spawn(1)
							playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
							spawn(1)
								playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
								spawn(1)
									playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
									spawn(1)
										playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
										spawn(1)
											playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
											spawn(1)
												playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
												spawn(5)
													playsound(src.loc, 'sound/misc/fartmassive.ogg', 75, 1, 5)
													new /obj/item/clothing/head/butt(src.loc)
													new /obj/effect/decal/cleanable/blood(src.loc)
													if(prob(76))
														for(var/mob/living/M in range(0))
															if(M != src)
																visible_message("\red <b>[src]</b>'s ass blasts <b>[M]</b> in the face!", "\red You ass blast <b>[M]</b>!")
																M.apply_damage(75,"brute","head")
															else
																continue
														visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")
													else if(prob(12))
														var/startx = 0
														var/starty = 0
														var/endy = 0
														var/endx = 0
														var/startside = pick(cardinal)

														switch(startside)
															if(NORTH)
																starty = src.loc
																startx = src.loc
																endy = 38
																endx = rand(41, 199)
															if(EAST)
																starty = src.loc
																startx = src.loc
																endy = rand(38, 187)
																endx = 41
															if(SOUTH)
																starty = src.loc
																startx = src.loc
																endy = 187
																endx = rand(41, 199)
															else
																starty = src.loc
																startx = src.loc
																endy = rand(38, 187)
																endx = 199

														//ASS BLAST USA
														visible_message("\red <b>[src]</b> blows their ass off with such force, they explode!", "\red Holy shit, your butt flies off into the galaxy!")
														usr.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
														new /obj/effect/immovablerod/butt(locate(startx, starty, 1), locate(endx, endy, 1))
														priority_announce("What the fuck was that?!", "General Alert")
													else if(prob(12))
														visible_message("\red <b>[src]</b> rips their ass apart in a massive explosion!", "\red Holy shit, your butt goes supernova!")
														explosion(src.loc,0,1,3,adminlog = 0,flame_range = 3)
														usr.gib()

													for(var/obj/item/weapon/storage/book/bible/CUL8 in range(0))
														var/obj/effect/lightning/L = new /obj/effect/lightning()
														L.loc = get_turf(src.loc)
														L.layer = src.layer+1
														L.icon_state = "lightning"
														playsound(CUL8,'sound/effects/thunder.ogg',90,1)
														spawn(10)
															src.gib()
															spawn(10)
															del(L)


		if ("help")
			src << "Help for emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, dance, deathgasp, drool, fart, flap, frown, gasp, giggle, glare-(none)/mob, grin, jump, laugh, look, me, nod, point-atom, scream, shake, sigh, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tremble, twitch, twitch_s, wave, whimper, wink, yawn"

		else
			..(act)





	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src.loc, null))
				O.show_message(message, m_type)
