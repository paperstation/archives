/obj/item/latexballon
	name = "Latex glove"
	desc = "" //todo
	icon_state = "latexballon"
	item_state = "lgloves"
	force = 0
	w_class = 1.0
	var/state
	var/datum/gas_mixture/air_contents = null

	proc/blow(obj/item/weapon/tank/tank)
		if (icon_state == "latexballon_bursted")
			return
		src.air_contents = tank.remove_air_volume(3)
		icon_state = "latexballon_blow"
		item_state = "latexballon"
		return


	proc/burst()
		if (!air_contents)
			return
		playsound(src, 'sound/weapons/Gunshot.ogg', 100, 1)
		icon_state = "latexballon_bursted"
		item_state = "lgloves"
		loc.assume_air(air_contents)
		return


	ex_act(severity)
		burst()
		switch(severity)
			if (1)
				del(src)
			if (2)
				if (prob(50))
					del(src)
		return


	bullet_act()
		burst()
		return


	temperature_expose(datum/gas_mixture/air, temperature, volume)
		if(temperature > T0C+100)
			burst()
		return


	attackby(obj/item/W as obj, mob/user as mob)
		if(W.force > 4)
			burst()
		return