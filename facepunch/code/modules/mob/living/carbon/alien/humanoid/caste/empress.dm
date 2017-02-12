/mob/living/carbon/alien/humanoid/queen/empress
	name = "alien empress"
	caste = "e"
	maxHealth = 1000
	health = 1000
	icon = 'icons/mob/alienempress.dmi'
	icon_state = "empress_s"
	status_flags = CANPARALYSE
	plasma_rate = 20
	pixel_x = -16
	universal_speak = 1//i wish there was a "can_understand_humans" var, but for now this works.


	New()
		..()
		verbs.Add(/mob/living/carbon/alien/humanoid/proc/corrosive_acid,/mob/living/carbon/alien/humanoid/proc/neurotoxin,/mob/living/carbon/alien/humanoid/proc/resin)
		verbs -= /mob/living/carbon/alien/verb/ventcrawl
		return


	update_icons()
		lying_prev = lying
		update_hud()
		overlays.Cut()
		if(lying)
			if(resting)					icon_state = "empress_sleep"
			else						icon_state = "empress_l"
			for(var/image/I in overlays_lying)
				overlays += I
		else
			icon_state = "empress_s"
			for(var/image/I in overlays_standing)
				overlays +=I

		if(healths)
			if(stat == 2)
				healths.icon_state = "health6"
			else
				switch(health)
					if(100 to INFINITY)
						healths.icon_state = "health0"
					if(750 to 1000)
						healths.icon_state = "health1"
					if(500 to 750)
						healths.icon_state = "health2"
					if(250 to 500)
						healths.icon_state = "health3"
					if(0 to 250)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
		return
