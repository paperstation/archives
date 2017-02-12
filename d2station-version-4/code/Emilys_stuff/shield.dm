/obj/machinery/shield
		name = "shield"
		desc = "An energy shield."
		icon = 'effects.dmi'
		icon_state = "shieldsparklesblank"
		density = 0
		opacity = 0
		anchored = 1
		unacidable = 1
		var/marker = null
		var/shieldsstrong = 1
		var/incorrect_items = list()
		var/list/emitterz = list()
/*/obj/machinery/shield/process()
	for(var/obj/machinery/shielding/emitter/emitter in range(10, src))
		emitterz += emitter
		if(Shields.on)
			if(emitterz.len > 0)
				density = 1
				icon_state = "shieldsparkles[shieldsstrong]"
				return
			else
				density = 0
				icon_state = "shieldsparklesblank"
*/
/obj/machinery/shield/proc/update()
	if(Shields.charge < Shields.max_charge / 3)
		shieldsstrong = 0
	else
		shieldsstrong = 1

	icon_state = "shieldsparkles[shieldsstrong]"

/obj/machinery/shield/meteorhit(obj/O as obj)
	icon_state = "shieldsparkles0"
	for(var/obj/machinery/shield/S in range(1, src))
		S.icon_state = "shieldsparkles0"
//		world << "[SB.shield_Integrity] / [SB.deployed_shields.len]"
		Shields.UsePower(600000)
		sleep(15)
//		if(prob(10))
//			del(src)
		return


/obj/machinery/shield/CanPass(mob/living/carbon/human/A, turf/T)
	if (istype(A, /mob/living/carbon/human))
		var/list/items = A.get_contents()
		for(var/obj/I in items)
			if(is_type_in_list(I, src.incorrect_items))
				return 0
	if (src.allowed(A))
		return 1
	return ..()


/obj/machinery/shield/ex_act(severity)
	for(var/obj/machinery/shielding/capacitor/cap in machines)
		switch(severity)
			if(1.0)
				Shields.UsePower(500000)
			if(2.0)
				Shields.UsePower(300000)
			if(3.0)
				Shields.UsePower(200000)
		return

