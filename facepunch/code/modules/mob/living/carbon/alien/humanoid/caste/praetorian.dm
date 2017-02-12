/mob/living/carbon/alien/humanoid/praetorian
	name = "alien praetorian"
	caste = "p"
	maxHealth = 300
	health = 300
	max_plasma = 300
	icon_state = "alienp_s"
	plasma_rate = 10


	New()
		if(name == "alien praetorian")
			name = text("alien praetorian ([rand(1, 1000)])")
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
					if(200 to INFINITY)
						healths.icon_state = "health0"
					if(150 to 200)
						healths.icon_state = "health1"
					if(100 to 150)
						healths.icon_state = "health2"
					if(50 to 100)
						healths.icon_state = "health3"
					if(0 to 50)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
		return

	movement_delay()
		return (2 + move_delay_add + config.alien_delay)


/mob/living/carbon/alien/humanoid/praetorian/large
	icon = 'icons/mob/praetorian.dmi'
	icon_state = "alienp_s"
	pixel_x = -16

	update_icons()
		lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
		update_hud()		//TODO: remove the need for this to be here
		overlays.Cut()
		if(lying)
			if(resting)					icon_state = "alienp_sleep"
			else						icon_state = "alienp_l"
			for(var/image/I in overlays_lying)
				overlays += I
		else
			icon_state = "alienp_s"
			for(var/image/I in overlays_standing)
				overlays += I

		if(healths)
			if(stat == 2)
				healths.icon_state = "health6"
			else
				switch(health)
					if(200 to INFINITY)
						healths.icon_state = "health0"
					if(150 to 200)
						healths.icon_state = "health1"
					if(100 to 150)
						healths.icon_state = "health2"
					if(50 to 100)
						healths.icon_state = "health3"
					if(0 to 50)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"