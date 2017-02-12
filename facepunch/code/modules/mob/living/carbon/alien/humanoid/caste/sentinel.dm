/mob/living/carbon/alien/humanoid/sentinel
	name = "alien sentinel"
	caste = "s"
	maxHealth = 125
	health = 125
	max_plasma = 250
	icon_state = "aliens_s"
	plasma_rate = 10


	New()
		if(name == "alien sentinel")
			name = text("alien sentinel ([rand(1, 1000)])")
		real_name = name
		verbs.Add(/mob/living/carbon/alien/humanoid/proc/corrosive_acid,/mob/living/carbon/alien/humanoid/proc/neurotoxin)
		..()
		return


	handle_regular_hud_updates()
		..()
		if(healths)
			if(stat == 2)
				healths.icon_state = "health6"
			else
				switch(health)
					if(125 to INFINITY)
						healths.icon_state = "health0"
					if(100 to 125)
						healths.icon_state = "health1"
					if(75 to 100)
						healths.icon_state = "health2"
					if(25 to 75)
						healths.icon_state = "health3"
					if(0 to 25)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
		return


	verb/evolve_praetorian()
		set name = "Evolve (250)"
		set desc = "Become a massive, slower alien more capable of defending the hive."
		set category = "Alien"

		if(!powerc(250))
			return
		adjustPlasma(-250)
		src << "\green You begin to evolve!"
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
		var/mob/living/carbon/alien/humanoid/praetorian/new_xeno = new (loc)
		mind.transfer_to(new_xeno)
		del(src)
		return
