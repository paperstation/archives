/obj/machinery/power/Reactor
	name = "Elerium Generator"
	desc = "A state of the art generator, may work with other ores other than Elerium, but this could be ill advised."
	icon = 'reactor.dmi'
	icon_state = "placeholder"
	anchored = 1
	density = 1
	var/active = 0
	var/fuel = 0
	var/maxfuel = 600
	var/genrate = 5000
	var/enrichment = 0
	var/risk = 0
	var/busy = 0

	process()
		if(stat & BROKEN) return
		if(src.active)
			if(src.fuel)
				if(prob(risk))
					stat = BROKEN
					flick("reactormelt", src)
					spawn(21)
					icon_state = "dead"
					return
				add_avail(src.genrate * src.enrichment)
				fuel--
			if(!src.fuel)
				for(var/mob/O in viewers(src, null)) O.show_message(text("\red [] runs out of fuel and shuts down!", src), 1)
				src.active = 0
				busy = 1
				if(icon_state != "placeholder1")
					flick("placeholder2", src) // fuck too tired to write this code night night byond.
				spawn(14)
				updateicon()
				busy = 0

	attack_hand(var/mob/user as mob)
		if(busy) return
		if (!src.fuel) user << "\red There is no fuel in the Reactor!"
		else
			src.active = !src.active
			user << "You switch [src.active ? "on" : "off"] the Reactor."
			if(src.active)// src.overlays += image('power.dmi', "placeholder1")
				busy = 1
				if(icon_state != "placeholder1")
					flick("placeholder2", src) // fuck too tired to write this code night night byond.
				spawn(14)
				updateicon()
				busy = 0
			else if(!src.active)
				busy = 1
				if(icon_state != "placeholder")
					flick("placeholder3", src)
				spawn(14)
				updateicon()
				busy = 0
	attackby(var/obj/item/weapon/ore/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/ore/char))
			src.fuel += 600
			enrichment = 1
			risk = 0
			del W
		else if (istype(W, /obj/item/weapon/ore/Elerium))
			src.fuel += 600
			enrichment = 1000
			risk = 0
			del W
		else if (istype(W, /obj/item/weapon/ore/cerenkite))
			src.fuel += 600
			enrichment = 50
			risk = 0
			del W
		else if(istype(W, /obj/item/weapon/ore/plasma))
			src.fuel += 600
			enrichment = 150
			risk = 1
			del W
		else if (istype(W, /obj/item/weapon/ore/uranium))
			src.fuel += 600
			enrichment = 250
			risk = 2
			del W
		else if(istype(W, /obj/item/weapon/ore/erebite))
			src.fuel += 600
			enrichment = 1750
			risk = 5
			del W
		else
			..()
			return
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"

	proc
		updateicon()
			if(!src.active)
				icon_state = "placeholder"
			if(src.active)
				icon_state = "placeholder1"
