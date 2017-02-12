/datum/disease/gay
	name = "The Serious"
	max_stages = 1
	cure = "None"
	spread = "Airborne"
	affected_species = list("Human", "Monkey")
	affected_species2 = list(/mob/living/carbon/monkey, /mob/living/carbon/human)
	curable = 0
	var/list/phrases = list("This 'gay disease' stuff is kind of offensive, despite it being intended as tongue in cheek. ",\
	 "And the nazi uniform is A-Okay? Well, admittedly, the nazi uniform is so rarely brought out and jews are so rarely eliminated, but hey. Take it for what it is. Stupid in an amusing way as opposed to hateful.",\
	 "Yeah I think the gay disease crosses over into if not really offensive in its own right, too puerile to be very amusing. ",\
	 "Well, I'll give that at the very least you're even handed with the whole thing. And it certainly is offensive and I can quickly imagine some retard using it as a launching point for a tirade against homosexuality. I guess you just need to have a thick skin to deal with it. Well, that and I imagine it's going to go into nazi uniform land and not be used much after its induction as the magic wears thin.",\
	 "I don't think you really understand the nature of my objection. Someone doesn't have to use bigoted jokes as a starting point for a sincerely hateful screed in order for the jokes to be bad; a popular culture that treats homosexuality as an illness or as at best an amusing character flaw is itself a problem, and I don't think we should be contributing to that.It may seem a bit silly to apply such a grand view to a simple game like this, but on the other hand, these are precisely the sorts of things that we can readily affect.",\
	 "I get that you're pointing it out more as part of a trend than anything, but I don't personally see poking fun at the concept harmful itself. Though with the... eagerness of some of the people suggesting ideas, I can see how it can quickly become less \"Let's poke fun at a silly concept\" and \"HRF DRF FAGITS R FUNY CAUSE THEY WEK AND GAY\" Then again, in this case I do have an outsider's view and can only try and draw parallels here. ",\
	 "I didn't get the impression this here gay disease was implying all people that are gay have it or any of that. Just that it was a disease that made you stereotypically gay. Then again, I never gave much though to the sexuality of the characters in SS13. Maybe if you had a box you could change from heterosexual to homosexual, and by being homosexual you instantly had the gay disease, that comparison might work quite a bit better.",\
	 "This discussion had to come up at some point. There's a lot of racist humor that shows up in SS13. I know very little of it is earnest -- just people looking for shock laughs -- but on the internet comedy scale it's right at the bottom next to catch phrases. It also makes whoever said it look like they're fourteen and I have enough trouble already pretending I don't spend the majority of my gaming time with children.",\
	 "Piss and poop just seems meh, its not very funny at the moment, and its gonna get even less so fast, then its just going to be tedious with every new pubbie going \"HAI GUYS I SHAT MY PANTS LAWL\" every fucking round.",\
	 "You know if you actually wrote up a good definition of what is griefing and what is just criminal you'd have something to point to when people pissed and moaned at you and it might make stuff like shark week less necessary. \"hurf durf don;t grief!\" is stupid when you fight back against an admin or make an honest mistake.",\
	 "You're incredibly stupid. I'm not telling you to make a definition so everyone in this thread knows what griefing is. I'm telling you it would save admins a lot of arguing if they could say \"oh well you don't have an excuse because here's a good definition and i don't have to spend any time arguing with you because its already laid out!\"",\
	 "There you go, showing the forums you have no clue how to read. All I said was there should be a definition of what \"griefing\" is. No doubt you'll wave it off as being pedantic or \"LOL U TAEK GAME SERIOUS\" but your big bad list has nothing like that in it. Just arbitrary examples of things you don't want to happen. The portion of my post you bolded is qualifying the word \"griefing.\" Of course, I know you were rushing so quickly to copy and paste the rules this escaped you.",\
	 "I'm not really sure what you mean by this. I was just responding to how shitty he was talking to me. I don't know about you, but I don't really like it when people call me retarded. I have feelings. I guess, if anything, I was successfully trolled into calling him names back. And for the record I never thought I was that shitty of a player. I got banned for the second time ever tonight because I attacked someone who I thought was a revolutionary. You can keep swinging from his nuts if you want to though.",\
	 "You just act like a dick in general. If it bothers you that much to spend all of your free time on this game then why even do it? And I'm sorry I hurt your feelings back--I like your game and I like most of the admins who spend their time on it, for better or worse, because even when they do grief its pretty funny. My suggestion was a throw-away comment that you decided would be awesome to troll me over for some reason. I won't bother you anymore if you're going to be that butt hurt when someone makes a suggestion that might not be brilliant to you. That's probably why they're just suggestions and not binding commands on what you should do with YOUR GAME that you spend all your time on. Also, please show me where I have trolled you before.",\
	 "I can see how poo is funny if you're in grade school, but after that \"HE POOPED HIMSELF HAHAHA\" goes away. At least it should.",\
	 "Ugh, Honestly this whole poo argument just feels like the clown/bartender/janitor argument all over again, \"Why would a clown/bartender/janitor be on a space station?!\" for a few months, and then it gets to be the underused thing that only crazy people do")
	why_so_serious = 0
/datum/disease/gay/stage_act()
	..()
	if(affected_mob.stat >= 1)
		return

	if(affected_mob:w_uniform == null)
		var/area/partay = affected_mob.loc.loc
		if(partay.party || partay.name == "Space")
			return
		partay.party = 1
		partay.updateicon()
		partay.mouse_opacity = 0
		affected_mob.say(pick(phrases))

		spawn(100)
			partay.party = 0
			partay.updateicon()

		for(var/mob/M in partay)
			if(istype(M.virus, /datum/disease/gay && prob(5))) //cuts down on spam
				M.say(pick(phrases))




		if(prob(5))
			if(affected_mob:w_uniform != null)
				var/c = affected_mob:w_uniform
				if(c)
					affected_mob.u_equip(c)
					if(affected_mob.client)
						affected_mob.client.screen -= c
					if(c)
						c:loc = affected_mob.loc
						c:layer = initial(c:layer)
			if(prob(25))
				affected_mob.say("DEBATE ON")
			else if(prob(25))
				affected_mob.say(":gay:")

		if(prob(20))
			for(var/mob/M in range(2, affected_mob))
				if (M.virus != null && M.virus == /datum/disease/gay)
					if(affected_mob:w_uniform != null)
						var/c = affected_mob:w_uniform
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
					if(M:w_uniform != null)
						var/c = M:w_uniform
						M.u_equip(c)
						if(M.client)
							M.client.screen -= c
						if(M:w_uniform)
							c:loc = affected_mob.loc
					affected_mob.say("You're so thexy, [M]!")
					M.say("Nice chetht, [affected_mob]!")