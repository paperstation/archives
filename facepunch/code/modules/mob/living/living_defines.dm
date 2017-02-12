/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	//var/bruteloss = 0.0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	//var/fireloss = 0.0	//Burn damage caused by being way too hot, too cold or burnt.
	//var/halloss = 0		//Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.


	var/hallucination = 0 //Directly affects how long a mob will hallucinate for
	var/list/atom/hallucinations = list() //A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm

	var/list/surgeries = list()	//a list of surgery datums. generally empty, they're added when the player wants them.

	var/now_pushing = null
	var/cameraFollow = null


	//CHECK THESE
	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	//Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	var/incorporeal_move = 0 //0 is off, 1 is normal, 2 is for ninjas.

	var/t_plasma = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/tod = null // Time of death
	var/update_slimes = 1

	var/nutrition = 400.0
	var/cpr_time = 1.0//Carbon

	//New damage vars
	//There are 4 damage zones, head/arms/chest/legs, each one needs a brute and fire damage var
	//Brute is direct force, fire is chemical burns and temperature changes
	var/brute_head = 0
	var/fire_head = 0
	var/brute_arms = 0
	var/fire_arms = 0
	var/brute_chest = 0
	var/fire_chest = 0
	var/brute_legs = 0
	var/fire_legs = 0

	//These damage vars apply to the entire body
	var/oxy_damage = 0	//Oxygen depravation damage (no air in lungs)
	var/tox_damage = 0	//Toxic damage caused by being poisoned or radiated
	var/clone_damage = 0	//Genetic damage, very hard to heal.


	var/fatigue = 0

	var/brain_damage = 0	//'Retardation' damage, makes you unable to do certain things like use computers or talk properly.


	proc/eyecheck()
		return 0


	proc/earcheck()
		return 0
