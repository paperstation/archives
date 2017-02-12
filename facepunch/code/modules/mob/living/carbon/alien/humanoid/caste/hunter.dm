/mob/living/carbon/alien/humanoid/hunter
	name = "alien hunter"
	caste = "h"
	maxHealth = 150
	health = 150
	max_plasma = 150
	icon_state = "alienh_s"
	plasma_rate = 5


	New()
		if(name == "alien hunter")
			name = text("alien hunter ([rand(1, 1000)])")
		real_name = name
		..()
		return


	handle_regular_hud_updates()
		..()
		if(healths)
			if(stat == 2)
				healths.icon_state = "health6"
			else
				switch(health)
					if(150 to INFINITY)
						healths.icon_state = "health0"
					if(100 to 150)
						healths.icon_state = "health1"
					if(50 to 100)
						healths.icon_state = "health2"
					if(25 to 50)
						healths.icon_state = "health3"
					if(0 to 25)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
		return

	movement_delay()
		return (-1 + move_delay_add + config.alien_delay)


	verb/evolve_runner()
		set name = "Evolve (150)"
		set desc = "Become a smaller, more agile alien more capable of getting hosts for the hive"
		set category = "Alien"

		if(powerc(150))
			adjustPlasma(-150)
			src << "\green You begin to evolve!"
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
			var/mob/living/carbon/alien/humanoid/runner/new_xeno = new (loc)
			mind.transfer_to(new_xeno)
			del(src)
		return
