/mob/living/carbon/alien/humanoid/runner
	name = "alien runner"
	caste = "r"
	maxHealth = 60
	health = 60
	max_plasma = 150
	icon_state = "alienr_s"
	plasma_rate = 5
	pass_flags = PASSTABLE


	New()
		if(name == "alien runner")
			name = text("alien runner ([rand(1, 1000)])")
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
					if(60 to INFINITY)
						healths.icon_state = "health0"
					if(45 to 60)
						healths.icon_state = "health1"
					if(30 to 45)
						healths.icon_state = "health2"
					if(15 to 30)
						healths.icon_state = "health3"
					if(0 to 15)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
		return

	movement_delay()
		return (-2 + move_delay_add + config.alien_delay)