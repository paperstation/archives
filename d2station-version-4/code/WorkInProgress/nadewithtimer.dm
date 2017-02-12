/obj/item/weapon/chem_grenade
	name = "Grenade Casing"
	icon_state = "chemg"
	icon = 'chemical.dmi'
	item_state = "flashbang"
	w_class = 2.0
	force = 2.0
	var/stage = 0
	var/state = 0
	var/path = 0
	var/motion = 0
	var/direct = "SOUTH"
	var/obj/item/weapon/circuitboard/circuit = null
	var/list/beakers = new/list()
	var/list/allowed_containers = list("/obj/item/weapon/reagent_containers/glass/beaker", "/obj/item/weapon/reagent_containers/glass/dispenser", "/obj/item/weapon/reagent_containers/glass/bottle", "/obj/item/weapon/reagent_containers/food/drinks/", "/obj/item/weapon/reagent_containers/food/condiment", "/obj/item/weapon/reagent_containers/pill", "/obj/item/weapon/reagent_containers/glass/bucket" )
	var/affected_area = 3
	var/det_time = 30.0
	var/timer_lock = 1
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY

	var/list/can_be_placed_into = list(
	/obj/machinery/chem_master/,
	/obj/table,
	/obj/secure_closet/,
	/obj/closet/,
	/obj/crate/,
	/obj/item/weapon/storage/,
	/obj/machinery/atmospherics/unary/cryo_cell,
	/obj/item/weapon/chem_grenade,
	/obj/machinery/bot/medbot,
	/obj/machinery/computer/pandemic,
	/obj/machinery/disposal/,
	/obj/item/weapon/secstorage/ssafe,
	/obj/item/weapon/mousetrap)

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/assembly/time_ignite) && !stage && path != 2)
			path = 1
			user << "\blue You add [W] to the metal casing."
			playsound(src.loc, 'Screwdriver2.ogg', 25, -3)
			del(W) //Okay so we're not really adding anything here. cheating.
			icon_state = initial(icon_state) +"_ass"
			name = "unsecured grenade"
			stage = 1
		else if(istype(W,/obj/item/weapon/screwdriver) && stage == 1 && path != 2)
			path = 1
			if(beakers.len)
				user << "\blue You lock the assembly."
				playsound(src.loc, 'Screwdriver.ogg', 25, -3)
				name = "grenade"
				icon_state = initial(icon_state) +"_locked"
				stage = 2
			else
				user << "\red You need to add at least one beaker before locking the assembly."
		else if ((istype(W,/obj/item/weapon/reagent_containers/glass/beaker)||istype(W,/obj/item/weapon/reagent_containers/glass/dispenser)||istype(W,/obj/item/weapon/reagent_containers/pill)||istype(W,/obj/item/weapon/reagent_containers/food/condiment)||istype(W,/obj/item/weapon/reagent_containers/food/drinks)||istype(W,/obj/item/weapon/reagent_containers/glass/bucket)||istype(W,/obj/item/weapon/reagent_containers/glass/bottle)) && stage == 1 && path != 2)
			path = 1
			if(beakers.len == 2)
				user << "\red The grenade can not hold more containers."
				return
			else
				if(W.reagents.total_volume)
					user << "\blue You add \the [W] to the assembly."
					user.drop_item()
					W.loc = src
					beakers += W
				else
					user << "\red \the [W] is empty."

		else if(path != 1)
			if(!istype(src.loc,/turf))
				user << "\red You need to put the canister on the ground to do that!"
			else
				switch(state)
					if(0)
						if(istype(W, /obj/item/weapon/wrench))
							playsound(src.loc, 'Ratchet.ogg', 50, 1)
							if(do_after(user, 20))
								user << "\blue You wrench the canister in place."
								src.name = "Camera Assembly"
								src.anchored = 1
								src.state = 1
								path = 2
					if(1)
						if(istype(W, /obj/item/weapon/wrench))
							playsound(src.loc, 'Ratchet.ogg', 50, 1)
							if(do_after(user, 20))
								user << "\blue You unfasten the canister."
								src.name = "Grenade Casing"
								src.anchored = 0
								src.state = 0
								path = 0
						if(istype(W, /obj/item/device/multitool))
							playsound(src.loc, 'Deconstruct.ogg', 50, 1)
							user << "\blue You place the electronics inside the canister."
							src.circuit = W
							user.drop_item()
							W.loc = src
						if(istype(W, /obj/item/weapon/screwdriver) && circuit)
							playsound(src.loc, 'Screwdriver.ogg', 50, 1)
							user << "\blue You screw the circuitry into place."
							src.state = 2
						if(istype(W, /obj/item/weapon/crowbar) && circuit)
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the circuitry."
							src.state = 1
							circuit.loc = src.loc
							src.circuit = null
					if(2)
						if(istype(W, /obj/item/weapon/screwdriver) && circuit)
							playsound(src.loc, 'Screwdriver.ogg', 50, 1)
							user << "\blue You unfasten the circuitry."
							src.state = 1
						if(istype(W, /obj/item/weapon/cable_coil))
							if(W:amount >= 1)
								playsound(src.loc, 'Deconstruct.ogg', 50, 1)
								if(do_after(user, 20))
									W:amount -= 1
									if(!W:amount) del(W)
									user << "\blue You add cabling to the canister."
									src.state = 3
					if(3)
						if(istype(W, /obj/item/weapon/wirecutters))
							playsound(src.loc, 'wirecutter.ogg', 50, 1)
							user << "\blue You remove the cabling."
							src.state = 2
							var/obj/item/weapon/cable_coil/A = new /obj/item/weapon/cable_coil( src.loc )
							A.amount = 1
						if(istype(W, /obj/item/device/radio/signaler))
							playsound(src.loc, 'Deconstruct.ogg', 50, 1)
							user << "\blue You attach the wireless signaller unit to the circutry."
							user.drop_item()
							W.loc = src
							src.state = 4
					if(4)
						if(istype(W, /obj/item/weapon/crowbar) && !motion)
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the remote signalling device."
							src.state = 3
							new /obj/item/device/radio/signaler( src.loc, 1 )
						if(istype(W, /obj/item/device/prox_sensor) && motion == 0)
//							if(W:amount >= 1)
							playsound(src.loc, 'Deconstruct.ogg', 50, 1)
//								W:use(1)
							user << "\blue You attach the proximity sensor."
							motion = 1
						if(istype(W, /obj/item/weapon/crowbar) && motion)
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the proximity sensor."
							new /obj/item/device/prox_sensor( src.loc, 1 )
							motion = 0
						if(istype(W, /obj/item/stack/sheet/glass))
							if(W:amount >= 1)
								playsound(src.loc, 'Deconstruct.ogg', 50, 1)
								if(do_after(user, 20))
									W:use(1)
									user << "\blue You put in the glass lens."
									src.state = 5
					if(5)
						if(istype(W, /obj/item/weapon/crowbar))
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the glass lens."
							src.state = 4
							new /obj/item/stack/sheet/glass( src.loc, 2 )
						if(istype(W, /obj/item/weapon/screwdriver))
							playsound(src.loc, 'Screwdriver.ogg', 50, 1)
							user << "\blue You connect the lense."
							var/B
							if(motion == 1)
								B = new /obj/machinery/camera/motion( src.loc )
							else
								B = new /obj/machinery/camera( src.loc )
							B:network = "SS13"
							B:network = input(usr, "To which network would you like to connect this camera?", "Set Network", "SS13")
							direct = input(user, "Direction?", "Assembling Camera", null) in list( "NORTH", "EAST", "SOUTH", "WEST" )
							B:dir = text2dir(direct)
							del(src)


	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (is_type_in_list(target, src.can_be_placed_into))
			return ..()
		if ((src.timer_lock == 0) && (stage == 2))
			user.machine = src
			var/dat = {"<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><B>Grenade Timer Controls</B><BR>
			Target time delay: <A href='?src=\ref[src];det_time1=50'>-</A> <A href='?src=\ref[src];det_time1=10'>-</A> <A href='?src=\ref[src];det_time1=5'>-</A> [det_time/10] seconds <A href='?src=\ref[src];det_time2=5'>+</A> <A href='?src=\ref[src];det_time2=10'>+</A> <A href='?src=\ref[src];det_time2=50'>+</A><BR>
			<HR>
			<A href='?src=\ref[user];mach_close=grentimer'>Close</A><BR>
			"}
			user << browse(dat, "window=grentimer;size=300x150")
			onclose(user, "grentimer")
			return
		if (!src.state && stage == 2 && !crit_fail)
			user << "\red You prime the grenade! [det_time/10] seconds!"
			message_admins("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			log_game("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			src.state = 1
			src.icon_state = initial(icon_state)+"_armed"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn(30)
				explode()
			user.drop_item()
			var/t = (isturf(target) ? target : target.loc)
			walk_towards(src, t, 3)
		else if(crit_fail)
			user << "\red This grenade is a dud and unusable!"

	Topic(href, href_list)
		if(usr.stat || usr.restrained()) return
		if (((get_dist(src, usr) <= 1) && istype(src.loc, /turf)))

			usr.machine = src

			if (href_list["dettime_add"])
				var/tdiff = text2num(href_list["det_time2"])
				if(tdiff)
					det_time += tdiff
				if(det_time < 10)
					det_time = 10
				if(det_time > 100)
					det_time = 100
			if (href_list["dettime_sub"])
				var/sdiff = text2num(href_list["det_time1"])
				if(sdiff)
					det_time -= sdiff
				if(det_time < 10)
					det_time = 10
				if(det_time > 100)
					det_time = 100
			src.updateUsrDialog()
			src.add_fingerprint(usr)
			update_icon()
		else
			usr << browse(null, "window=grentimer")
			return
		return

	attackby((istype(W, /obj/item/weapon/wirecutters)) as obj, mob/user as mob)
		if ((src.timer_lock == 0) && (stage == 2))
			src.timer_lock = 1
			playsound(src.loc, 'wirecutter.ogg', 50, 1)
			user << "\red Timer controls locked."
		else if ((src.timer_lock == 1) && (stage == 2))
			src.timer_lock = 0
			playsound(src.loc, 'wirecutter.ogg', 50, 1)
			user << "\red Timer controls unlocked."
		else return


	attack_self(mob/user as mob)
		if ((src.timer_lock == 0) && (stage == 2))
			user.machine = src
			var/dat = {"<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><B>Grenade Timer Controls</B><BR>
			Target time delay: <A href='?src=\ref[src];det_time1=50'>-</A> <A href='?src=\ref[src];det_time1=10'>-</A> <A href='?src=\ref[src];det_time1=5'>-</A> [det_time/10] seconds <A href='?src=\ref[src];det_time2=5'>+</A> <A href='?src=\ref[src];det_time2=10'>+</A> <A href='?src=\ref[src];det_time2=50'>+</A><BR>
			<HR>
			<A href='?src=\ref[user];mach_close=grentimer'>Close</A><BR>
			"}
			user << browse(dat, "window=grentimer;size=300x150")
			onclose(user, "grentimer")
			return
		else if (!src.state && stage == 2 && !crit_fail)
			user << "\red You prime the grenade! [det_time/10] seconds!"
			message_admins("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			log_game("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			src.state = 1
			src.icon_state = initial(icon_state)+"_armed"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn(det_time)
				explode()
		else if(crit_fail)
			user << "\red This grenade is a dud and unusable!"

	attack_hand()
		walk(src,0)
		return ..()
	attack_paw()
		return attack_hand()

	proc
		explode()
			if(reliability)
				var/has_reagents = 0
				for(var/obj/item/weapon/reagent_containers/G in beakers)
					if(G.reagents.total_volume) has_reagents = 1

				if(!has_reagents)
					playsound(src.loc, 'Screwdriver2.ogg', 50, 1)
					state = 0
					return

				playsound(src.loc, 'bamf.ogg', 50, 1)

				for(var/obj/item/weapon/reagent_containers/G in beakers)
					G.reagents.trans_to(src, G.reagents.total_volume)

				if(src.reagents.total_volume) //The possible reactions didnt use up all reagents.
					var/datum/effects/system/steam_spread/steam = new /datum/effects/system/steam_spread()
					steam.set_up(10, 0, get_turf(src))
					steam.attach(src)
					steam.start()

					for(var/atom/A in view(affected_area, src.loc))
						if( A == src ) continue
						src.reagents.reaction(A, 1, 10)


				invisibility = 100 //Why am i doing this?
				spawn(50)		   //To make sure all reagents can work
					del(src)	   //correctly before deleting the grenade.
			else
				icon_state = initial(icon_state) + "_locked"
				crit_fail = 1
				for(var/obj/item/weapon/reagent_containers/G in beakers)
					G.loc = get_turf(src.loc)


		/* Okay so what we want to get from this shitstorm o' code

			Using wirecutters on a finished 'nade will open it's
			timer controls, which can be used to edit the time
			between activation and explosion in a range going
			from 1s to 10s (10 ticks - 100 ticks)

			And in case anyone's wondering, I'm writing it for
			myself so I don't forget --soyuz */
