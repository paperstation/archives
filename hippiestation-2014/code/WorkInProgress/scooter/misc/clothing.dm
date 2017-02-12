/obj/item/clothing/suit/space/tele
	name = "Shit-storm 5000"
	desc = "Cool."
	var/canfire = 1
	var/list/obj/item/ammo = list()
	var/list/mob/ammo2 = list()
	var/switcher = 0
	icon_action_button = "action_blasto"
	action_button_name = "FIRE EVERYTHING"


/obj/item/clothing/suit/space/tele/proc/blastogrenadeo(mob/user as mob)
	if(canfire)
		playsound(usr.loc, 'sound/weapons/cannon.ogg', 100, 1)
		for(var/obj/V in usr.loc)
			var/atom/throw_target = get_edge_target_turf(usr, get_dir(usr, get_step_away(usr, usr)))
			V.throw_at(throw_target, 200, 4)
/obj/item/clothing/suit/space/tele/ui_action_click()
	if( src in usr )
		blastogrenadeo()







/obj/item/clothing/suit/space/disposal
	name = "Disposal Cannon"
	desc = "Cool."

	var/canfire = 1
	var/list/obj/item/ammo = list()
	var/list/mob/ammo2 = list()
	var/switcher = 0
	icon_action_button = "action_blasto"
	action_button_name = "Fire everything."

	attack_self()
		switch(switcher)
			if(0)
				usr << "Firing mobs"
				switcher = 1
			if(1)
				switcher = 0
				usr << "Firing objects"

	proc/fire()
		for(var/obj/V in src)
			if(V)
				var/obj/A = pick(V)
				A.loc = usr.loc
				A.dir = usr.dir
				Path_set(A, list(usr.dir),  0, 6,  1, 0)
/obj/item/clothing/suit/space/disposal/proc/blastogrenadeo(mob/user as mob)
	if(canfire)
		switch(switcher)
			if(0)
				playsound(usr.loc, 'sound/weapons/cannon.ogg', 100, 1)
				for(var/obj/V in usr.loc)
					var/obj/C = pick(V)
					var/atom/throw_target = get_edge_target_turf(usr, get_dir(usr, get_step_away(usr, usr)))
					C.throw_at(throw_target, 200, 4)
			if(1)
				playsound(usr.loc, 'sound/weapons/cannon.ogg', 100, 1)
				for(var/mob/V in usr.loc)
					var/mob/C = pick(V)
					var/atom/throw_target = get_edge_target_turf(usr, get_dir(usr, get_step_away(usr, usr)))
					C.throw_at(throw_target, 400, 4)
/obj/item/clothing/suit/space/disposal/ui_action_click()
	if( loc == usr )
		blastogrenadeo()