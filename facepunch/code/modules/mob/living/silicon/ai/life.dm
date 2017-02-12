/mob/living/silicon/ai/Life()
	if(stat == 2)
		return

	if(stat!=0)
		cameraFollow = null
		reset_view(null)
		unset_machine()

	update_health()
	clamp_values()
	if(src.malfhack)
		if (src.malfhack.aidisabled)
			src << "\red ERROR: APC access disabled, hack attempt canceled."
			src.malfhacking = 0
			src.malfhack = null


	if(health <= config.health_threshold_dead)
		death()
		return

	if(machine)
		if(!( src.machine.check_eye(src) ))
			src.reset_view(null)

	if(istype(loc, /obj/item))
		return//Intelacard does not use power

	var/turf/T = get_turf(src)
	var/area/home = get_area(src)
	if(!home || !T)	return//San check to make sure we have an area and turf
	if(home.master) home = home.master
	if(istype(T, /turf/space) || (home.requires_power && !home.power_equip))//Are we in space or is the power off
		deal_damage(2, OXY)
		if(!powerlossdetected)//Need to warn the user
			powerlossdetected = 1
			src << "\red<h2>You've lost power!</h2>"
		return
	home.use_power(1000, EQUIP)
	deal_damage(-1, OXY)//Slowly heal if damaged due to power loss
	if(powerlossdetected)
		powerlossdetected = 0
		src << "\blue<h2>Power has been restored!</h2>"
	return


/mob/living/silicon/ai/update_health()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		if(fire_res_on_core)
			health = 100 - oxy_damage - tox_damage - get_brute_loss()
		else
			health = 100 - oxy_damage - tox_damage - get_fire_loss() - get_brute_loss()


/mob/living/silicon/ai/proc/clamp_values()
	weakened = 0
	paralysis = 0
	sleeping = 0
	stuttering = 0
	return 1