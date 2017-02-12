/datum/event/radiation
	Lifetime = 10
	Announce()
		command_alert("The ship is now travelling through a radiation belt", "Medical Alert")

	Tick()
		for(var/mob/living/carbon/human/H in mobz)
			H.radiation += rand(1,5)
			if (prob(5))
				H.radiation += rand(3,5)
			if (prob(1))
				if (prob(75))
					randmutb(H)
					domutcheck(H,null,1)
				else
					randmutg(H)
					domutcheck(H,null,1)
		for(var/mob/living/carbon/monkey/M in mobz)
			M.radiation += rand(1,5)

	Die()
		command_alert("The ship has cleared the radiation belt", "Medical Alert")