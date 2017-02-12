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
				D.deal_damage(10, WEAKEN)
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
				if(activator == user)
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
					D.apply_effect(10, WEAKEN, 1)
*/

//ITS NOT DONE YET
/obj/machinery/fermenter
	name = "Fermenter"
	desc = "Ferment wheat"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "incubator"
	var/active = 0
	var/fert = 0
	var/juice = 0
	var/fermen = 0
	var/fermentlevel = 0
	var/progress = 0
	var/sugar
	anchored = 1
	density = 1

	var/fermenting = 0
	var/wheatlevel = 0
	var/juicelevel = 0
	var/idealwheat = 0
	var/idealjuice = 0
	var/countdown = 0
	var/screen = 0
	//0 main menu
	//1 stats
	//2 input
	//3 mixer
	//4 timer
	//5 guide


	New()
		var/datum/reagents/R = new/datum/reagents(500)
		reagents = R
		R.my_atom = src
		idealwheat = rand(1,5)
		idealjuice = rand(1,6)
		processing_objects.Add(src)
/obj/machinery/fermenter/attackby(obj/W as obj, mob/user as mob)
	user << "You insert the [W.name]"
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/wheat))
		fert += rand(5,10)
		return
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/berries))
		juice += rand(1,8)
		return

///obj/item/weapon/reagent_containers/food/condiment/sugar

/obj/machinery/fermenter/process()
	if(fermen == 1)
		countdown--
		if(countdown <= 0)
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
			icon_state = "incubator"
			visible_message("The incubator shuts off")
			fermen = 0
		if(fermentlevel == 0)
			if(juice >= 1 && fert >= 1)
				if(juice >= juicelevel && fert >= wheatlevel)
					juice -= juicelevel
					fert -= wheatlevel
					fermenting = 1
			else if(fermenting)
				var/F = rand(1,5)
				progress += F
				if(prob(2))
					if(prob(25))
						fermentlevel++
						visible_message("The fermenter bubbles")
						progress += 1
						fermentlevel = 1
			else
				return

/obj/machinery/fermenter/attack_hand(mob/user as mob)
	var/dat = "<b>Fermenter</b><BR>"
	switch(screen)
		if(0)
			dat += "<A href='byond://?src=\ref[src];op=stats'>Inventory & Statistics</A><BR>"
			dat += "<br><A href='byond://?src=\ref[src];op=prod'>Production Menu</A><BR>"
			dat += "<br><A href='byond://?src=\ref[src];op=mix'>Mix Menu</A><BR>"
			dat += "<br><A href='byond://?src=\ref[src];op=guide'>Guide</A><BR>"
		if(1)
			dat += "<b>Ingredients</b>"
			dat += "Juice:[juice]<br>"
			dat += "Wheat:[fert]<br>"
			dat += "Sugar:[sugar]<br><br>"
			dat += "<b>Production</b>"
			dat += "<br>Current Progress: [progress]"
			dat += "<br>Fermenting Stage: [fermentlevel]"
			dat += "<br><A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
		if(2)
			dat += "<b>Input Control</b>"
			dat += "<br>Current Mix: [wheatlevel] <br>Wheat, [juicelevel] Juice"
			dat += "<br><A href='byond://?src=\ref[src];op=wheatinput'>Change Wheat Level</A>"
			dat += "<br><A href='byond://?src=\ref[src];op=juiceinput'>Change Juice Level</A>"
			dat += "<br><A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
		if(3)
			dat += "<b>Mixing</b>"
			dat += "<br><A href='byond://?src=\ref[src];op=timeset'>Set Fermenting time </A>(in seconds)"
			dat += "<br><A href='byond://?src=\ref[src];op=beginfert'>Begin Fermenting</A>"
			dat += "<br><A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
		if(4)
			dat += "Mixing"
			dat += "<br>Time remaining: [countdown]</br>"
			if(countdown == 0)
				dat+= "<b>Mixing Complete<b>"
				dat += "<br><A href='byond://?src=\ref[src];op=mm1'>Main Menu</A><br>"
		if(5)
			dat += "<b>How to Ferment</b></br>"
			dat += "<i>Penned by: Ez Et. Dohnyeht</br>"
			dat += "<b>Step #1</b>: Add Wheat and Berries.</br>"
			dat += "<b>Step #2</b>: Choose a Wheat and Juice input rate</br>"
			dat += "<b>Step #3</b>: Choose your time</br>"
			dat += "<b>Step #4</b>: Ferment</br>"
			dat += "</br></br>Your Wheat and Juice level will affect the ideal ratio of balance. The closer it is to the preset levels the better wine you will make. Your production value goes up the higher the time, of course it has a chance to reset"
			dat += "</br></br><i>You can improve the base wine to a premium wine by adding sugar, salt or beer.</i>"
			dat += "<br><A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
	user << browse(dat, "window=scroll")
	onclose(user, "scroll")
	return

/obj/machinery/fermenter/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		switch(href_list["op"])
			if ("mm")
				screen = 0

			if ("mm1")
				screen = 1
				var/obj/item/weapon/reagent_containers/glass/beaker/Z = new/obj/item/weapon/reagent_containers/glass/beaker
				Z.loc = src.loc
				if(idealwheat == wheatlevel && idealjuice == juicelevel && progress >= 400)
					Z.reagents.add_reagent("winehshitholyshit", 25)
					return
				if(idealwheat == wheatlevel && idealjuice == juicelevel || progress >= 100 && progress <= 200)
					Z.reagents.add_reagent("winepgood", 25)
					return
				if(progress <= 99)
					Z.reagents.add_reagent("winemeh", 25)
					return
			if ("stats")
				screen = 1

			if ("guide")
				screen = 5

			if ("prod")
				screen = 2


			if ("mix")
				screen = 3

			if ("beginfert")
				juice -= juicelevel
				fert -= wheatlevel
				screen = 4
				fermen = 1
				icon_state = "incubator_on"
				process()

			if ("timeset")
				countdown = input(usr, "Set time, in seconds.", "Time", 1) as num
				if(countdown <= 60)
					countdown = 60
				if(countdown >= 480)
					countdown = 480

			if ("wheatinput")
				wheatlevel = input(usr, "Set Wheat input.", "Wheat", 1) as num
				if(wheatlevel >= 6)
					wheatlevel = 5
			if ("juiceinput")
				juicelevel = input(usr, "Set Juice input.", "Juice", 1) as num
				if(juicelevel >= 7)
					juicelevel = 5
	updateUsrDialog()
///obj/item/weapon/reagent_containers/food/snacks/grown/wheat)

/*
/obj/structure/candybucket
	name = "Bucket"
	desc = "Holds candy."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "candy1"
	var/candy = 1
	var/id = 0
	attack_hand()
		if(candy)
			candy = 0
			icon_state = "candy0"
			var/wait = rand(50,300)
			spawn(wait)
			candy = 1
			icon_state = "candy0"
*/

/obj/structure/candybucket
	name = "Candy Bucket"
	desc = "Has tons of candy for you."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "candy1"
	var/candy = 1
	var/id = 0
	health = 10000000000000000000000
	max_health = 10000000000000000000000
	anchored = 1
	density = 1


	attackby(obj/W as obj, mob/user as mob)
		if(istype(W, /obj/item/candybucket))
			var/obj/item/candybucket/Z = W
			user << "You take candy out of the bucket!"
			if(candy)
				switch(id)
					if(1)
						if(Z.id1 == 0)
							Z.id1 = 1
							change()
					if(2)
						if(Z.id2 == 0)
							Z.id2 = 1
							change()
					if(3)
						if(Z.id3 == 0)
							Z.id3 = 1
							change()
					if(4)
						if(Z.id4 == 0)
							Z.id4 = 1
							change()
					if(5)
						if(Z.id5 == 0)
							Z.id5 = 1
							change()
				if(Z.id1 == 1 && Z.id2 == 1 && Z.id3 == 1 && Z.id4 == 1 && Z.id5 == 1)
					user << "You have visited all five places!"
					user.unlock_achievement("Trick or Treat")
					Z.icon_state = "candy1"
				else
					return

/obj/structure/candybucket/proc/change()
		candy = 0
		icon_state = "candy0"
		var/wait = rand(50,300)
		spawn(wait)
		candy = 1
		icon_state = "candy1"
	//	src.visible_message << "Takes the candy from the bucket."

/obj/item/candybucket
	name = "Candy Bucket"
	desc = "Holds candy."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "candy0"
	var/id1 = 0
	var/id2 = 0
	var/id3 = 0
	var/id4 = 0
	var/id5 = 0

/*
/obj/structure/mechfab
	name = "Mech Fabricator"
	desc = "Holds candy."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "candy0"

	New()
		for(typesof(/obj/)
			*/

/obj/machinery/pointgiver
	name = "Lucky Corp Point Rewarder"
	desc = "Lucky!"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "pointmachine"
	density = 1
	anchored = 1
	var/list/ckeys = list()
	damage_resistance = -1//-1 means it will never break

	attack_hand(mob/user)
		if(user.client)
			if(user.ckey in ckeys)
				user << "You already claimed this reward."
				return
			else
				ckeys += user.ckey
				user.client.givepoint()


/obj/item/token
	name = "Lucky Corp Point Rewarder"
	desc = "Lucky!"
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "token"

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