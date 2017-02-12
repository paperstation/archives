/obj/machinery/jammer
	name = "Runtimer"
	desc = "This is not a cat."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "coiloff"
	var/activator = null
	var/on = 0
	var/count
	var/countorig = 4//for editing
	var/charges = 4
	health = 350
	anchored = 1
	density = 1
	process()
		if(on)
			for(var/mob/living/D in viewers(7,src))
				if(D == activator)
					continue
				D.apply_effect(10, WEAKEN, 1)	//s should likely check armor
				count--

				if(count <= 0)
					on = 0
					icon_state = "coiloff"
	attack_hand(var/mob/living/user as mob)
		if(!on)
			if(!activator)
				activator = user
				user << "You bind your DNA to the machine. Use it again to use one of its [charges]."
			else
				if(charges <= 0)
					return
				on = 1
				icon_state = "coilon"
				count = countorig
				empulse(src, 5, 1)
/*

			for(var/mob/living/D in viewers(7,src))
				if(activator in D)continue
					src.anchored = 1
					D.apply_effect(10, STUN, 1)//This should likely check armor
					D.apply_effect(10, WEAKEN, 1)	*/



/obj/item/device/bug
	name = "Bug"
	desc = "Listen in on things."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "coiloff"