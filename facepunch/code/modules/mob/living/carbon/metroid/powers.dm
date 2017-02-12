/mob/living/carbon/slime/verb/Feed()
	set category = "Slime"
	set desc = "This will let you feed on any valid creature in the surrounding area. This should also be used to halt the feeding process."
	if(Victim)
		Feedstop()
		return

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return

	var/list/choices = list()
	for(var/mob/living/C in view(1,src))
		if(C!=src && !istype(C,/mob/living/carbon/slime))
			choices += C

	var/mob/living/carbon/M = input(src,"Who do you wish to feed on?") in null|choices
	if(!M) return
	if(M in view(1, src))
		if(istype(src, /mob/living/carbon/brain) || istype(M, /mob/living/carbon/slime) || M.stat == 2)
			src << "<i>Invalid Target!</i>"
			return
		for(var/mob/living/carbon/slime/met in view())
			if(met.Victim == M && met != src)
				src << "<i>The [met.name] is already feeding on this subject...</i>"
				return
		src << "\blue <i>You latch onto the subject and begin feeding...</i>"
		M << "\red <b>The [src.name] has latched onto you!</b>"
		Feedon(M)
	return


/mob/living/carbon/slime/proc/Feedon(var/mob/living/carbon/M)
	Victim = M
	src.loc = M.loc
	canmove = 0
	anchored = 1
	var/lastnut = nutrition
	//if(M.client) M << "\red You legs become paralyzed!"
	if(istype(src, /mob/living/carbon/slime/adult))
		icon_state = "[colour] adult slime eat"
	else
		icon_state = "[colour] baby slime eat"

	while(Victim && stat != 2)
		// M.canmove = 0
		canmove = 0

		if(M in view(1, src))
			loc = M.loc

			if(prob(15) && M.client && istype(M, /mob/living/carbon))
				M << "\red [pick("You can feel your body becoming weak!", \
				"You feel like you're about to die!", \
				"You feel every part of your body screaming in agony!", \
				"A low, rolling pain passes through your body!", \
				"Your body feels as if it's falling apart!", \
				"You feel extremely weak!", \
				"A sharp, deep pain bathes every inch of your body!")]"

			if(istype(M, /mob/living/carbon))
				Victim.deal_damage(5, BURN, PIERCE)

				// Heal yourself
				deal_damage(-2, TOX)
				deal_damage(-2, OXY)
				deal_damage(-2, BRUTE)
				deal_damage(-2, BURN)
				deal_damage(-2, CLONE)

				nutrition += rand(10,25)
				if(nutrition >= lastnut + 50)
					if(prob(80))
						lastnut = nutrition
						powerlevel++
						if(powerlevel > 10)
							powerlevel = 10

				if(nutrition > 1200)
					nutrition = 1200

			if(Victim && Victim.health < 0)
				Victim.melt()
				break
			sleep(rand(15,45))

		else
			break

	if(stat == 2)
		if(!istype(src, /mob/living/carbon/slime/adult))
			icon_state = "[colour] baby slime dead"
	else
		if(istype(src, /mob/living/carbon/slime/adult))
			icon_state = "[colour] adult slime"
		else
			icon_state = "[colour] baby slime"

	canmove = 1
	anchored = 0

	if(M)
		if(M.health <= -70)
			M.canmove = 0
			if(!client)
				if(Victim && !rabid && !attacked)
					if(Victim.LAssailant && Victim.LAssailant != Victim)
						if(prob(50))
							if(!(Victim.LAssailant in Friends))
								Friends.Add(Victim.LAssailant) // no idea why i was using the |= operator

			if(M.client && istype(src, /mob/living/carbon/human))
				if(prob(85))
					rabid = 1 // UUUNNBGHHHH GONNA EAT JUUUUUU

			if(client) src << "<i>This subject does not have a strong enough life energy anymore...</i>"
		else
			M.canmove = 1

			if(client) src << "<i>I have stopped feeding...</i>"
	else
		if(client) src << "<i>I have stopped feeding...</i>"

	Victim = null

/mob/living/carbon/slime/proc/Feedstop()
	if(Victim)
		if(Victim.client) Victim << "[src] has let go of you!"
		Victim = null

/mob/living/carbon/slime/proc/UpdateFeed(var/mob/M)
	if(Victim)
		if(Victim == M)
			loc = M.loc // simple "attach to head" effect!


/mob/living/carbon/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return
	if(!istype(src, /mob/living/carbon/slime/adult))
		if(amount_grown >= 10)
			var/mob/living/carbon/slime/adult/new_slime = new adulttype(loc)
			new_slime.nutrition = nutrition
			new_slime.powerlevel = max(0, powerlevel-1)
			new_slime.a_intent = "hurt"
			new_slime.key = key
			new_slime.universal_speak = universal_speak
			new_slime << "<B>You are now an adult slime.</B>"
			del(src)
		else
			src << "<i>I am not ready to evolve yet...</i>"
	else
		src << "<i>I have already evolved...</i>"

/mob/living/carbon/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes. NOTE: this will KILL you, but you will be transferred into one of the babies."

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return

	if(istype(src, /mob/living/carbon/slime/adult))
		if(amount_grown >= 10)
			//if(input("Are you absolutely sure you want to reproduce? Your current body will cease to be, but your consciousness will be transferred into a produced slime.") in list("Yes","No")=="Yes")
			if(stat)
				src << "<i>I must be conscious to do this...</i>"
				return

			var/list/babies = list()
			var/new_powerlevel = round(powerlevel / 4)
			for(var/i=1,i<=4,i++)
				if(prob(80))
					var/mob/living/carbon/slime/M = new primarytype(loc)
					M.powerlevel = new_powerlevel
					if(i != 1) step_away(M,src)
					babies += M
				else
					var/mutations = pick("one","two","three","four")
					switch(mutations)
						if("one")
							var/mob/living/carbon/slime/M = new mutationone(loc)
							M.powerlevel = new_powerlevel
							if(i != 1) step_away(M,src)
							babies += M
						if("two")
							var/mob/living/carbon/slime/M = new mutationtwo(loc)
							M.powerlevel = new_powerlevel
							if(i != 1) step_away(M,src)
							babies += M
						if("three")
							var/mob/living/carbon/slime/M = new mutationthree(loc)
							M.powerlevel = new_powerlevel
							if(i != 1) step_away(M,src)
							babies += M
						if("four")
							var/mob/living/carbon/slime/M = new mutationfour(loc)
							M.powerlevel = new_powerlevel
							if(i != 1) step_away(M,src)
							babies += M

			var/mob/living/carbon/slime/new_slime = pick(babies)
			new_slime.a_intent = "hurt"
			new_slime.universal_speak = universal_speak
			new_slime.key = key

			new_slime << "<B>You are now a slime!</B>"
			del(src)
		else
			src << "<i>I am not ready to reproduce yet...</i>"
	else
		src << "<i>I am not old enough to reproduce yet...</i>"



/mob/living/carbon/slime/verb/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Slime"
	if(Victim)	return
	handle_ventcrawl()