/obj/item/plank
	name = "wooden plank"
	desc = "My best friend plank!"
	icon = 'icons/obj/hydroponics/hydromisc.dmi'
	icon_state = "plank"
	force = 4.0
		//cogwerks - burn vars
	burn_point = 400
	burn_output = 1500
	burn_possible = 1
	health = 50
	//
	stamina_damage = 40
	stamina_cost = 40
	stamina_crit_chance = 10

	attack_self()
		boutput(usr, "<span style=\"color:blue\">Now building wood wall. You'll need to stand still.</span>")
		var/turf/T = get_turf(usr)
		sleep(30)
		if(usr.loc == T)
			if(!locate(/obj/structure/woodwall) in T)
				var/obj/structure/woodwall/N = new /obj/structure/woodwall(T)
				N.builtby = usr.real_name
				qdel(src)
			boutput(usr, "<span style=\"color:red\">There's already a barricade here!</span>")
			return
		else
			return
