/mob/living/silicon/decoy/Life()
	if(src.stat == 2)
		return

	if (src.health <= config.health_threshold_dead && src.stat != 2)
		death()
		return
