
//BUG!!!: reactions on splashing etc cause errors because stuff gets deleted before it executes.
//		  Bandaid fix using spawn - very ugly, need to fix this.

///////////////////////////////Grenades
//Includes changes by Mord_Sith to allow for buildable cameras
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
		else if ((istype(W,/obj/item/weapon/reagent_containers/glass/beaker)||istype(W,/obj/item/weapon/reagent_containers/glass/dispenser)||istype(W,/obj/item/weapon/reagent_containers/pill)||istype(W,/obj/item/weapon/reagent_containers/food/condiment)||istype(W,/obj/item/weapon/reagent_containers/food/
		)||istype(W,/obj/item/weapon/reagent_containers/glass/large)||istype(W,/obj/item/weapon/reagent_containers/glass/bucket)||istype(W,/obj/item/weapon/reagent_containers/glass/bottle)) && stage == 1 && path != 2)
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

/* fuck ur shit u fucking retards why restore this
   fucking die
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (is_type_in_list(target, src.can_be_placed_into))
			return ..()
		if (!src.state && stage == 2 && !crit_fail)
			user << "\red You prime the grenade! 3 seconds!"
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
			*/

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		if (istype(W, /obj/item/weapon/weldingtool) && W:welding)
			if (src.det_time == 60)
				src.det_time = 30
				user.show_message("\blue You set the grenade for a 3 second detonation time.")  //TODO:
				src.desc = "It is set to detonate in 3 seconds."								//GET AN ACTUAL FUCKING VARIABLE TIMER FOR THIS [2s-10s]
			else																				//MAKE SURE YOU CAN DO THIS FOR PRESPAWNED 'NADES ALSO
				src.det_time = 60																//MAKE SURE THIS DOSEN'T CAUSE METAL FOAM TO MELT FACES AGAIN (!!)
				user.show_message("\blue You set the grenade for a 6 second detonation time.")
				src.desc = "It is set to detonate in 6 seconds."
		return

	attack_self(mob/user as mob)
		if (!src.state && stage == 2 && !crit_fail)
			user << "\red You prime the grenade! [det_time/10] seconds!"
			message_admins("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			log_game("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			src.state = 1
			src.icon_state = "chemg4"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn(30)
				explode()


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

/obj/item/weapon/chem_grenade/large
	name = "Large Chem Grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "large_grenade"
	allowed_containers = list("/obj/item/weapon/reagent_containers/")
	origin_tech = "combat=3;materials=3"
	affected_area = 4

/obj/item/weapon/chem_grenade/empgrenade
	name = "emp grenade"
	path = 1
	stage = 2
	icon = 'device.dmi'
	icon_state = "emp"
	item_state = "emp"
	origin_tech = "materials=2;magnets=3"

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("arprinium", 30)
		B2.reagents.add_reagent("plasma", 30)

		beakers += B1
		beakers += B2

/obj/item/weapon/chem_grenade/flashbang
	name = "flashbang"
	path = 1
	stage = 2
	icon = 'chemical.dmi'
	icon_state = "chemg"
	item_state = "flashbang"
	origin_tech = "materials=2;combat=1"
	affected_area = 7

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 30)
		B1.reagents.add_reagent("potassium", 15)
		B2.reagents.add_reagent("potassium", 15)
		B2.reagents.add_reagent("sulfur", 30)

		beakers += B1
		beakers += B2

/obj/item/weapon/chem_grenade/metalfoam
	name = "Metal-Foam Grenade"
	desc = "Used for emergency sealing of air breaches."
	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 6)
		B2.reagents.add_reagent("foaming_agent", 2)
		B2.reagents.add_reagent("pacid", 2)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/incendiary
	name = "Incendiary Grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 30)
		B1.reagents.add_reagent("plasma", 15)
		B2.reagents.add_reagent("plasma", 15)
		B2.reagents.add_reagent("acid", 30)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/cleaner
	name = "Cleaner Grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	stage = 2
	path = 1

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 40)
		B2.reagents.add_reagent("water", 40)
		B2.reagents.add_reagent("cleaner", 80)
		B1.reagents.add_reagent("cleaner", 80)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/water
	name = "Shine Grenade"
	desc = "A water grenade."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)

		//B1.reagents.add_reagent("water", 30)
		B1.reagents.add_reagent("cleaner", 30)

		beakers += B1
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/lube
	name = "Space Lube Grenade"
	desc = "For when you need to lube up REAL good."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)

		B1.reagents.add_reagent("lube", 30)

		beakers += B1
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/urine
	name = "Urine Grenade"
	desc = "An urine grenade."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)

		B1.reagents.add_reagent("urine", 30)

		beakers += B1
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/poo
	name = "poo grenade"
	desc = "A ShiTastic! brand biological warfare charge. Not very effective unless the target is squeamish."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("poo", 25)
		B2.reagents.add_reagent("poo", 25)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"

/obj/item/weapon/chem_grenade/poo2
	name = "poo grenade"
	desc = "A ShiTastic! brand biological warfare charge. Not very effective unless the target is squeamish."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("poo", 1)
		B1.reagents.add_reagent("fluorosurfactant", INFINITY)
		B2.reagents.add_reagent("water", INFINITY)

		beakers += B1
		beakers += B2
		icon_state = "chemg_locked"


/obj/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'chemical.dmi'
	icon_state = "null"
	anchored = 1
	density = 0

	New()
		var/datum/reagents/R = new/datum/reagents(15)
		reagents = R
		R.my_atom = src

/obj/item/weapon/gun/syringe
	name = "syringe gun"
	icon = 'gun.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 4.0
	var/list/syringes = new/list()
	var/max_syringes = 2
	m_amt = 2000

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\icon [src] Syringe gun:"
		usr << "\blue [syringes] / [max_syringes] Syringes."

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/weapon/reagent_containers/syringe))
			if(syringes.len < max_syringes)
				user.drop_item()
				I.loc = src
				syringes += I
				user << "\blue You put the syringe in the syringe gun."
				user << "\blue [syringes.len] / [max_syringes] Syringes."
			else
				usr << "\red The syringe gun cannot hold more syringes."

	afterattack(obj/target, mob/user , flag)
		if(!isturf(target.loc) || target == user) return

		if(syringes.len)
			spawn(0) fire_syringe(target,user)
		else
			usr << "\red The syringe gun is empty."

	proc
		fire_syringe(atom/target, mob/user)
			if (locate (/obj/table, src.loc))
				return
			else
				var/datum/disease/viruses = null
				var/turf/trg = get_turf(target)
				var/obj/syringe_gun_dummy/D = new/obj/syringe_gun_dummy(get_turf(src))
				var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]
				for(var/datum/reagent/blood/B in S.reagents.reagent_list)
					if(B.id == "blood")
						//world << "blood found transfering virus"
						for(var/datum/disease/V in B.data["viruses"])
							viruses = new V.type
						//	world << "Viruses contains [viruses]"
				S.reagents.trans_to(D, S.reagents.total_volume)
				syringes -= S
				del(S)
				D.icon_state = "syringeproj"
				D.name = "syringe"
				playsound(user.loc, 'syringeproj.ogg', 50, 1)

				for(var/i=0, i<6, i++)
					if(!D) break
					if(D.loc == trg) break
					step_towards(D,trg)

					for(var/mob/living/carbon/M in D.loc)
						if(!istype(M,/mob/living/carbon)) continue
						if(M == user) continue
						if(viruses)
							M.contract_disease(viruses)
							viruses = null
							//world << "desease spread"
						D.reagents.trans_to(M, 15, 1, 1)
						M.take_organ_damage(5)
					//	world << "syringe attack started"
						for(var/mob/O in viewers(world.view, D))
							O.show_message(text("\red [] was hit by the syringe!", M), 1)
					//	world << "syringe attack complete"
						del(D)
					if(D)
						for(var/atom/A in D.loc)
							if(A == user) continue
							if(A.density) del(D)

					sleep(1)

				if (D) spawn(10) del(D)

				return



/obj/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0
	flags = FPRINT
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/volume = 1000
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

	proc/process()
		if(isturf(src.loc))
			temperature_expose(null, src.loc:temperature, null)
		spawn(20) process()

	New()
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/reagent_dispensers/verb/set_APTFT
		process()
		..()

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "\blue [R.volume] units of [R.name]"
		else
			usr << "\blue Nothing."

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					new /obj/effects/water(src.loc)
					del(src)
					return
			if(3.0)
				if (prob(5))
					new /obj/effects/water(src.loc)
					del(src)
					return
			else
		return

	blob_act()
		if(prob(50))
			new /obj/effects/water(src.loc)
			del(src)
/*
	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		var/transfer_this_temp = exposed_temperature
		if(reagents.total_volume)
			for(var/datum/reagent/R in reagents.reagent_list)
				R.distribute_temperature_changes(transfer_this_temp)
*/
/obj/item/weapon/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'chemical.dmi'
	icon_state = null
	w_class = 1
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,25)
	var/volume = 50

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set src in range(0)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

//	process()
//		if(isturf(src.loc))
//			temperature_expose(null, src.loc:temperature, null)
//		spawn(20) process()

	New()
		..()
		if (!possible_transfer_amounts)
			src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src
		process()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		return
	attackby(obj/item/I as obj, mob/user as mob)
		return
	afterattack(obj/target, mob/user , flag)
		return

/*	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		var/transfer_this_temp = exposed_temperature
		if(reagents.total_volume)
			for(var/datum/reagent/R in reagents.reagent_list)
				R.distribute_temperature_changes(transfer_this_temp)
*/
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass
	name = " "
	desc = " "
	icon = 'chemical.dmi'
	icon_state = "null"
	item_state = "null"
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,25)
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/gulp_size = 5
	var/main_reagent

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/table,
		/obj/secure_closet,
		/obj/closet,
		/obj/item/weapon/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/item/weapon/chem_grenade,
		/obj/machinery/bot/medbot,
		/obj/machinery/computer/pandemic,
		/obj/machinery/computer/pandemic2,
		/obj/item/weapon/secstorage/ssafe,
		/obj/machinery/disposal/,
		/obj/machinery/Medicinereplicator,
		/obj/machinery/reagentgrinder
	//	/obj/machinery/hotplate
	//	/obj/machinery/coldplate
	)

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "\blue [R.volume] units of [R.name]"
		else
			usr << "\blue Nothing."

	proc/shatter(atom/target)
		if(reagents.total_volume)
			if(ismob(target))
				src.reagents.reaction(target, TOUCH)
			if(isturf(target))
				src.reagents.reaction(get_turf(target))
			if(isobj(target))
				src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		playsound(src.loc, "shatter", 40, 0)
		for(var/mob/O in viewers(world.view, src))
			O.show_message(text("\red The [] shatters!", src.name), 1)
		new /obj/decal/cleanable/generic(get_turf(src))
		new /obj/item/weapon/shard(get_turf(src))
		del(src)

	afterattack(obj/target, mob/user , flag)
		for(var/type in src.can_be_placed_into)
			if(istype(target, type))
				return
		if(istype(target, /obj/item/weapon/reagent_containers/hypospray))
			return

		if(is_type_in_list(target, src.can_be_placed_into))
			return

		if(ismob(target) && target.reagents && reagents.total_volume && user.a_intent == "hurt")
			user << "\blue You splash the solution onto [target]."
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] has been splashed with something by []!", target, user), 1)
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return

		else if(ismob(target) && target.reagents && reagents.total_volume && user.a_intent == "help")
			if(!reagents.total_volume || !reagents)
				user << "\red None of [src] left, oh no!"
				return

			if(target == user)
				target << "\blue You swallow a gulp from the [src]."
			//	M << "\blue You swallow a gulp from the [src], tastes like [R]."
				if(reagents.total_volume)
					reagents.reaction(target, INGEST)
					spawn(5)
						reagents.trans_to(target, gulp_size)

				playsound(target.loc,'drink.ogg', rand(10,50), 1)
				return
			else if(istype(target, /mob/living/carbon/human) )
				for(var/mob/O in viewers(world.view, user))
					O.show_message("\red [user] attempts to feed [target] [src].", 1)
				if(!do_mob(user, target)) return
				for(var/mob/O in viewers(world.view, user))
					O.show_message("\red [user] feeds [target] [src].", 1)
				var/mob/living/carbon/human/Quickfix = target
				Quickfix.attack_log += text("<font color='orange'>[world.time] - has been fed [src.name] by [user.name] ([user.ckey]) Reagents: \ref[reagents]</font>")
				user.attack_log += text("<font color='red'>[world.time] - has fed [Quickfix.name] by [Quickfix.name] ([Quickfix.ckey]) Reagents: \ref[reagents]</font>")
				reagents.reaction(target, INGEST)
				spawn(5)
					reagents.trans_to(target, gulp_size)
				playsound(target.loc,'drink.ogg', rand(10,50), 1)
				return


		else if((istype(target, /obj/closet)) || (istype(target, /obj/item/weapon/reagent_containers/syringe)) || (istype(target, /obj/crate)) || (istype(target, /obj/item/weapon/storage)) || (istype(target, /obj/machinery/chem_dispenser)) || (istype(target, /obj/item/weapon/secstorage)) || (istype(target, /obj/machinery/disease2/incubator)) || (istype(target, /obj/machinery/microscope))) //can_be_placed_into doesn't work quite well I guess
			return

		else if(istype(target, /obj/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

		else if(istype(target, /obj/decal/cleanable))
			var/obj/decal/cleanable/D = target
			if(D.decaltype)
				src.reagents.add_reagent(D.decaltype, 5)
				user << "\blue You scrape [D] up and add it to the [src]."
				del(D)

//		else if(istype(target, /obj/decal/cleanable/urine))
//			src.scrapereagent = "urine"
//			src.reagents.add_reagent(scrapereagent, 5)
//			user << "\blue You scrape [target] up and add it to the [src]."
//			del(target)

		//SOMEONE FUCKING FIX THIS
		//ARGH
		//YOU SPLASH THE SOLUTION ON EVERY MACHINE
		//YOU SPLASH THE SOLUTION ON THE SYRINGE
		//WHAT THE FUCL
		else if(reagents.total_volume)
			user << "\blue You splash the solution onto [target]."
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return

////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass. END
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Thermometer
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass/thermometer
	name = "thermometer"
	desc = "useful for finding the temperature of chemicals... or organisms"
	icon = 'chemical.dmi'
	icon_state = "thermeter"
	item_state = "null"
	volume = 1
	amount_per_transfer_from_this = 0
	possible_transfer_amounts = null
	flags = FPRINT | TABLEPASS
	var/accurate = 0
	var/approximator = 1
	var/rounded1 = null
	var/rounded2 = null

	debug
		accurate = 1

	New()
		..()
		reagents.add_reagent("mercury", 1)

	afterattack(atom/target, mob/user , flag)
		if(!accurate)
			approximator = pick(-3, -2, -1, 0, 1, 2, 3)
		else
			approximator = 0
		if(ismob(target))
			if(target:bodytemperature)
				rounded1 = round(target:bodytemperature - T0C, 1)
				rounded2 = round(target:bodytemperature * 1.8-459.67, 1)
				user << "\blue The [src.name] shows a temperature of around [rounded1 + approximator]&deg;C ([rounded2 + approximator] &deg;F) for [target]."
		if(isobj(target))
			if(target.reagents)
				if(target.reagents.total_volume)
					var/reagent_temp_counter = 0.0
					var/average_temp = 0.0
					for(var/datum/reagent/R in target.reagents.reagent_list)
						if(R.current_temp)
							reagent_temp_counter += R.current_temp
					average_temp = reagent_temp_counter / target.reagents.reagent_list.len
					user << "\blue The [src.name] shows a temperature of around [round(average_temp-T0C + approximator, 1)]&deg;C ([round(average_temp*1.8-459.67 + approximator, 1)] &deg;F) for [target]."
				else
					user << "\blue The [src.name] doesn't have anything of which to take a temperature."

////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////


//BONGS FOR BONGHITS
/obj/item/weapon/reagent_containers/bong
	name = "bong"
	desc = "A bong."
	icon = 'chemical.dmi'
	icon_state = "bong0"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(10,20,30,40,50)
	var/filled = 0
	var/main_reagent
	var/icon/bongc
	volume = 50


	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return
		if(filled)
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return
			if(ismob(target))
				if (target != user)
					return
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red <B>[] takes a bonghit from the []!</B>", user, src.name), 1)
				src.reagents.reaction(target, INGEST)
		return

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "bong0" || src.icon_state == "bongcolor")
				src.overlays -= bongc
				src.icon_state = "bongcolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				bongc = new/icon("icon" = 'chemical.dmi', "icon_state" = "bongcolormod")
				bongc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += bongc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "bong0"
//BONGS

////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/dropper
	name = "Dropper"
	desc = "A dropper. Transfers 1 unit."
	icon = 'chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1,2)
	var/filled = 0
	var/main_reagent
	var/icon/dropperc
	volume = 2


	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return

		if(filled)

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/weapon/reagent_containers/food)) //You can inject humans and food but you cant remove the shit.
				user << "\red You cannot directly fill this object."
				return

			if(ismob(target))
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red <B>[] drips something onto []!</B>", user, target), 1)
				src.reagents.reaction(target, TOUCH)

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution."
			filled = 0
			src.on_reagent_change()

		else

			if(!target.is_open_container() && !istype(target,/obj/reagent_dispensers))
				user << "\red You cannot directly remove reagents from [target]."
				return

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

			user << "\blue You fill the dropper with [trans] units of the solution."
			filled = 1
			src.on_reagent_change()

		return

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "dropper0" || src.icon_state == "droppercolor")
				src.overlays -= dropperc
				src.icon_state = "droppercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				dropperc = new/icon("icon" = 'chemical.dmi', "icon_state" = "droppercolormod")
				dropperc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += dropperc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "dropper0"


/obj/item/weapon/reagent_containers/robodropper
	name = "Industrial Dropper"
	desc = "A larger dropper. Transfers 10 units."
	icon = 'chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,3,4,5,6,7,8,9,10)
	volume = 10
	var/main_reagent
	var/filled = 0
	var/icon/dropperc


	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return

		if(filled)

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/weapon/reagent_containers/food)) //You can inject humans and food but you cant remove the shit.
				user << "\red You cannot directly fill this object."
				return

			if(ismob(target))
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red <B>[] drips something onto []!</B>", user, target), 1)
				src.reagents.reaction(target, TOUCH)

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution."
			filled = 0
			src.on_reagent_change()

		else

			if(!target.is_open_container() && !istype(target,/obj/reagent_dispensers))
				user << "\red You cannot directly remove reagents from [target]."
				return

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)
			user << "\blue You fill the dropper with [trans] units of the solution."
			filled = 1
			src.on_reagent_change()

		return

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "dropper0" || src.icon_state == "droppercolor")
				src.overlays -= dropperc
				src.icon_state = "droppercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				dropperc = new/icon("icon" = 'chemical.dmi', "icon_state" = "droppercolormod")
				dropperc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += dropperc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "dropper0"

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1

/obj/item/weapon/reagent_containers/syringe
	name = "Syringe"
	desc = "A syringe."
	icon = 'syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null //list(5,10,15)
	volume = 15
	var/mode = SYRINGE_DRAW
	var/main_reagent

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_self(mob/user as mob)
/*
		switch(mode)
			if(SYRINGE_DRAW)
				mode = SYRINGE_INJECT
			if(SYRINGE_INJECT)
				mode = SYRINGE_DRAW
*/
		mode = !mode
		update_icon()

	attack_hand()
		..()
		update_icon()

	attack_paw()
		return attack_hand()

	attackby(obj/item/I as obj, mob/user as mob)
		return

	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return

		switch(mode)
			if(SYRINGE_DRAW)

				if(reagents.total_volume >= reagents.maximum_volume)
					user << "\red The syringe is full."
					return

				if(ismob(target))//Blood!
					if(istype(src, /mob/living/carbon/metroid))
						user << "\red You are unable to locate any blood."
						return
					if(src.reagents.has_reagent("blood"))
						user << "\red There is already a blood sample in this syringe"
						return
					if(istype(target, /mob/living/carbon))//maybe just add a blood reagent to all mobs. Then you can suck them dry...With hundreds of syringes. Jolly good idea.
						var/amount = src.reagents.maximum_volume - src.reagents.total_volume
						var/mob/living/carbon/T = target
						var/datum/reagent/B = new /datum/reagent/blood
						if(!T.dna)
							usr << "You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum)"
							return
						B.holder = src
						B.volume = amount
						//set reagent data
						B.data["donor"] = T
						/*
						if(T.virus && T.virus.spread_type != SPECIAL)
							B.data["virus"] = new T.virus.type(0)
						*/


					//	if(T.changeling_level >= 1)
					//		if(!B.data["viruses"])
					//			B.data["viruses"] = list()
					//		var/datum/disease/the_thing/A = new /datum/disease/the_thing
					//		A.infectedby = T.key
					//		A.absorbed_dna = T.absorbed_dna
					//		A.oldname = T.name
					//		A.olddna = T.dna
					//		if(A in B.data["viruses"])
					//		else
					//			B.data["viruses"] += A

//					for(var/datum/disease/C in B.data["viruses"])
//						if(!istype(A, C))
//							B.data["viruses"] -= A
//							B.data["viruses"] += A

						for(var/datum/disease/D in T.viruses)
							if(!B.data["viruses"])
								B.data["viruses"] = list()
							var/datum/disease/C = D.getcopy(D)

							if(C in B.data["viruses"])
								del(C)
							else
								B.data["viruses"] += C

							//for(var/datum/disease/A in B.data["viruses"])
							//	if(A in ))
							//		B.data["viruses"] -= C
							//		B.data["viruses"] += C


						B.data["blood_DNA"] = copytext(T.dna.unique_enzymes,1,0)
						if(T.resistances&&T.resistances.len)
							B.data["resistances"] = T.resistances.Copy()
						if(istype(target, /mob/living/carbon/human))//I wish there was some hasproperty operation...
							var/mob/living/carbon/human/HT = target
							B.data["blood_type"] = copytext(HT.b_type,1,0)
						var/list/temp_chem = list()
						for(var/datum/reagent/R in target.reagents.reagent_list)
							temp_chem += R.name
							temp_chem[R.name] = R.volume
						B.data["trace_chem"] = list2params(temp_chem)
						//debug
			//			for(var/D in B.data)
			//				world << "Data [D] = [B.data[D]]"
						//debug
						src.reagents.reagent_list += B
						src.reagents.update_total()
						src.on_reagent_change()
						src.reagents.handle_reactions()
						user << "\blue You take a blood sample from [target]"
						target:blood = target:blood - 15
						for(var/mob/O in viewers(4, user))
							O.show_message("\red [user] takes a blood sample from [target].", 1)
				else //if not mob
					if(!target.reagents.total_volume)
						user << "\red [target] is empty."
						return

					if(!target.is_open_container() && !istype(target,/obj/reagent_dispensers))
						user << "\red You cannot directly remove reagents from this object."
						return

					var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

					user << "\blue You fill the syringe with [trans] units of the solution."
				if (reagents.total_volume >= reagents.maximum_volume)
					mode=!mode
					update_icon()

			if(SYRINGE_INJECT)
				if(!reagents.total_volume)
					user << "\red The Syringe is empty."
					return
				if(istype(target, /obj/item/weapon/implantcase/chem))
					return
				if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food))
					user << "\red You cannot directly fill this object."
					return
				if(target.reagents.total_volume >= target.reagents.maximum_volume)
					user << "\red [target] is full."
					return

				if(ismob(target) && target != user)
					for(var/mob/O in viewers(world.view, user))
						O.show_message(text("\red <B>[] is trying to inject []!</B>", user, target), 1)
					if(!do_mob(user, target)) return
					for(var/mob/O in viewers(world.view, user))
						O.show_message(text("\red [] injects [] with the syringe!", user, target), 1)
					src.reagents.reaction(target, INGEST)
				if(ismob(target) && target == user)
					src.reagents.reaction(target, INGEST)
				spawn(5)
					var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
					user << "\blue You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."
					if (reagents.total_volume >= reagents.maximum_volume && mode==SYRINGE_INJECT)
						mode = SYRINGE_DRAW
						update_icon()
				update_icon()
		return

	update_icon()
		var/rounded_vol = round(reagents.total_volume,5)
		var/overlay = rounded_vol * 10
		src.overlays = null
		if(ismob(loc))
			var/mode_t
			switch(mode)
				if (SYRINGE_DRAW)
					mode_t = "d"
				if (SYRINGE_INJECT)
					mode_t = "i"
			icon_state = "[mode_t][rounded_vol]"
			if(reagents.total_volume)
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/hypoc = new/icon("icon" = 'syringecolor.dmi', "icon_state" = "[overlay]")
				hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += hypoc
				src.main_reagent = ""
			else
				src.main_reagent = ""
				src.overlays = null
		else
			icon_state = "[rounded_vol]"
			if(reagents.total_volume)
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/hypoc = new/icon("icon" = 'syringecolor.dmi', "icon_state" = "[overlay]")
				hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += hypoc
				src.main_reagent = ""
			else
				src.main_reagent = ""
				src.overlays = null
		item_state = "syringe_[rounded_vol]"


////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'syringe.dmi'
	item_state = "hypo0"
	icon_state = "hypo"
	amount_per_transfer_from_this = 10
	volume = 30
	possible_transfer_amounts = null
	flags = FPRINT | ONBELT | TABLEPASS | OPENCONTAINER
	var/main_reagent
	var/obj/item/weapon/reagent_containers/glass/hyposprayvial = null
	var/vial = 1
	var/mode = 1
	var/icon/hypoc
	var/contains = "tricordrazine"
	origin_tech = "biotech=3"

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "hypo0" || src.icon_state == "hypocolor")
				src.overlays -= hypoc
				src.icon_state = "hypocolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
				hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += hypoc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "hypo0"

	attack_self(mob/user as mob)
		if(mode == 1)
			amount_per_transfer_from_this = 5
			mode ++
			onmodecheck()
			user << "\blue You switch to 5 unit bursts"
			return
		if(mode == 2)
			amount_per_transfer_from_this = 10
			mode ++
			onmodecheck()
			user << "\blue You switch to 10 unit bursts"
			return
		if(mode == 3)
			amount_per_transfer_from_this = 15
			mode ++
			onmodecheck()
			user << "\blue You switch to 15 unit bursts"
			return
		if(mode == 4)
			amount_per_transfer_from_this = 20
			mode ++
			onmodecheck()
			user << "\blue You switch to 20 unit bursts"
			return
		if(mode == 5)
			amount_per_transfer_from_this = 25
			mode ++
			onmodecheck()
			user << "\blue You switch to 25 unit bursts"
			return
		if(mode == 6)
			amount_per_transfer_from_this = 30
			mode ++
			onmodecheck()
			user << "\blue You switch to 30 unit bursts"
			return


/obj/item/weapon/reagent_containers/hypospray/proc/onmodecheck()
	if(mode >= 7)
		mode = 1

/obj/item/weapon/reagent_containers/hypospray/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/reagent_containers/hypospray/dna
	contains = "ryetalyn"

/obj/item/weapon/reagent_containers/hypospray/virology
	contains = "corophizine"



/obj/item/weapon/reagent_containers/hypospray/New()
	..()
	reagents.add_reagent(contains, 30) //uncomment this to make it start with stuff in
	spawn(5)
	src.icon_state = "hypocolor"
	src.main_reagent = src.reagents.get_master_reagent_reference()
	var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
	hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
	src.overlays += hypoc
	src.main_reagent = ""
	return


/obj/item/weapon/reagent_containers/hypospray/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	if (reagents.total_volume)
		for(var/mob/O in viewers(world.view, user))
			O.show_message(text("\red <B>[] is trying to shoot [] with a hypospray!</B>", user, M), 1)
		if(!do_mob(user, M)) return
		playsound(src.loc, 'spray_once.ogg', 120, 0)
		user << "\blue You shoot [M] with the hypospray."
		M << "\red You feel a tiny burst of air!"
		src.reagents.reaction(M, INGEST)
		if(M.reagents)
			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			user << "\blue [trans] units injected.  [reagents.total_volume] units remaining in the hypospray."
		update()
	else
		user << "\blue The hypospray is empty, refill the vial."
	return


/obj/item/weapon/reagent_containers/hypospray/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		update()
		if (vial == 0)
			user << "\red hypospray is empty. Can't eject vial."
			return
		else
			user << "\blue You eject the hypospray vial"
			var/obj/item/weapon/reagent_containers/glass/hyposprayvial/P = new/obj/item/weapon/reagent_containers/glass/hyposprayvial(user)
			src.hyposprayvial = null
			vial = 0
			if(user.hand)
				user.l_hand = P
			else
				user.r_hand = P
			P.layer = 20
			reagents.trans_to(P, reagents.total_volume)
			update()
			spawn(3)
			return
	else
		return ..()

/obj/item/weapon/reagent_containers/hypospray/proc/update()
	if (!(vial))
		if(reagents.total_volume)
			vial = 1
		if(src.hyposprayvial)
			vial = 1
	else if ((vial == 1) && (src.hyposprayvial == null))
		src.hyposprayvial = /obj/item/weapon/reagent_containers/glass/hyposprayvial
		return


/obj/item/weapon/reagent_containers/hypospray/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!istype(W, /obj/item/weapon/reagent_containers/glass/hyposprayvial))
		return
	if (vial == 1)
		user << "The [W] is already inserted."
		update()
		return
	src.hyposprayvial = W
	vial = 1
	user << "You insert [W]."
	src.updateUsrDialog()
	W.reagents.trans_to(src, W:reagents.total_volume)
	spawn(3)
	update()
	del(W)
	return




/obj/item/weapon/reagent_containers/glass/hyposprayvial
	name = "Hypospray Vial"
	desc = "A small vial that contains chemicals for a hypospray."
	icon = 'chemical.dmi'
	icon_state = "hypo0"
	item_state = "hypo"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	volume = 30
	var/icon/hypoc

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "hypo0" || src.icon_state == "hypocolor")
				src.overlays -= hypoc
				src.icon_state = "hypocolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
				hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += hypoc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "hypo0"


/obj/item/weapon/reagent_containers/glass/hyposprayvial/New()
	..()
	on_reagent_change()
////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.

	New()
		..()
		src.pixel_x = rand(-5.0, 5)						//Randomizes postion slightly.
		src.pixel_y = rand(-5.0, 5)

/obj/item/weapon/reagent_containers/food/snacks		//Food items that are eaten normally and don't leave anything behind.
	name = "snack"
	desc = "yummy"
	icon = 'food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/create_trash = 0
	var/istrash = 0
	var/canexpire = 1
	var/goodness = 100
	var/eatmessage
	var/list/random_icon_states = list()

	//Placeholder for effects that trigger on eating that aren't tied to reagents.
	proc/On_Consume()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		if(!reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
			user << "\red None of [src] left, oh no!"
			if(src.create_trash && !src.istrash)
				src.icon_state = "[src.icon_state]_trash"
				src.istrash = 1
			if(src.istrash)
				return 0
			del(src)
			score_foodeaten += 1
			return 0
		if(istype(M, /mob/living/carbon))
			if(M == user)								//If you're eating it yourself.
				var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
				if (fullness <= 50)
					M << "\red You hungrily chew out a piece of [src] and gobble it!"
				if (fullness > 50 && fullness <= 150)
					M << "\blue You hungrily begin to eat [src]."
				if (fullness > 150 && fullness <= 350)
					M << "\blue You take a bite of [src]."
				if (fullness > 350 && fullness <= 550)
					M << "\blue You unwillingly chew a bit of [src]."
				if (fullness > (550 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
					M << "\red You cannot force any more of [src] to go down your throat."
					return 0
			else
				if(!istype(M, /mob/living/carbon/metroid))		//If you're feeding it to someone else.
					var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
					if (fullness <= (550 * (1 + M.overeatduration / 1000)))
						for(var/mob/O in viewers(world.view, user))
							O.show_message("\red [user] attempts to feed [M] [src].", 1)
					else
						for(var/mob/O in viewers(world.view, user))
							O.show_message("\red [user] cannot force anymore of [src] down [M]'s throat.", 1)
							return 0

					if(!do_mob(user, M)) return

					M.attack_log += text("<font color='orange'>[world.time] - has been fed [src.name] by [user.name] ([user.ckey]) Reagents: \ref[reagents]</font>")
					user.attack_log += text("<font color='red'>[world.time] - has fed [M.name] by [M.name] ([M.ckey]) Reagents: \ref[reagents]</font>")

					for(var/mob/O in viewers(world.view, user))
						O.show_message("\red [user] feeds [M] [src].", 1)

				else
					user << "This creature does not seem to have a mouth!"
					return

			if(reagents)								//Handle ingestion of the reagent.
				if(reagents.total_volume)
					reagents.reaction(M, INGEST)
					spawn(5)
						if(reagents.total_volume > bitesize)
							/*
							 * I totally cannot understand what this code supposed to do.
							 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
							var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
							reagents.trans_to(M, temp_bitesize)
							*/
							reagents.trans_to(M, bitesize)
						else
							reagents.trans_to(M, reagents.total_volume)
						bitecount++
						On_Consume()
						if(!reagents.total_volume)
							if(M == user) user << "\red You finish eating [src]."
							else user << "\red [M] finishes eating [src]."
							if(src.create_trash && !src.istrash)
								src.icon_state = "[src.icon_state]_trash"
								src.istrash = 1
							if(src.istrash)
								return 0
							del(src)
				playsound(M.loc,'eatfood.ogg', rand(10,50), 1)
				return 1

		return 0

	attackby(obj/item/I as obj, mob/user as mob)
		return
	afterattack(obj/target, mob/user , flag)
		return

	examine()
		set src in view()
		..()
		if (!(usr in range(0)) && usr!=src.loc) return
		if (bitecount==0)
			return
		else if (bitecount==1)
			usr << "\blue \The [src] was bitten by someone!"
		else if (bitecount<=3)
			usr << "\blue \The [src] was bitten [bitecount] times!"
		else
			usr << "\blue \The [src] was bitten multiple times!"

	New()
		..()
		expirefood()
		checkgoodness()

	proc/checkgoodness()
		if (src.goodness >= 0)
			src.goodness--

		if(src.goodness == 100)
			src.eatmessage = "amazing"
		else if (src.goodness <= 90)
			src.eatmessage = "great"
		else if (src.goodness <= 70)
			src.eatmessage = "good"
		else if (src.goodness <= 50)
			src.eatmessage = "okay"
		else if (src.goodness <= 30)
			src.eatmessage = "alright"
		else if (src.goodness <= 20)
			src.eatmessage = "bad"
		else if (src.goodness <= 10)
			src.eatmessage = "horrible"
		else if (src.goodness == 1)
			src.eatmessage = "disgusting"
		spawn(300)
			checkgoodness() //check again, just in case

	proc/expirefood()
		if(istype(src.loc, /obj/crate/freezer))
			return
		if(istype(src.loc, /obj/secure_closet/fridge))
			return
		if(istype(src.loc, /obj/secure_closet/meat))
			return
		if(canexpire == 1)
			spawn(rand(50000,150000))
				src.desc = "<BR><font color=\"red\">It seems expired, yuck! You should probably throw this away.</font>"
				reagents.add_reagent("bad_bacteria", 5)
				src.overlays += icon('effects.dmi', "flies")
				canexpire = 0
		spawn(300)
			expirefood() //check again, just in case
/obj/item/weapon/reagent_containers/food/snacks
	var/slice_path
	var/slices_num
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		var/inaccurate = 0
		if( \
				istype(W, /obj/item/weapon/kitchenknife) || \
				istype(W, /obj/item/weapon/scalpel) || \
				istype(W, /obj/item/weapon/kitchen/utensil/knife) \
			)
		else if( \
				istype(W, /obj/item/weapon/circular_saw) || \
				istype(W, /obj/item/weapon/melee/energy/sword) && W:active || \
				istype(W, /obj/item/weapon/melee/energy/blade) || \
				istype(W, /obj/item/weapon/shovel) \
			)
			inaccurate = 1
			return
		else
			return 1
		if ( \
				!isturf(src.loc) || \
				!(locate(/obj/table) in src.loc) && \
				!(locate(/obj/machinery/optable) in src.loc) && \
				!(locate(/obj/item/weapon/tray) in src.loc) \
			)
			user << "\red You cannot slice [src] here! You need a table or at least a tray to do it."
			return 1
		var/slices_lost = 0
		if (!inaccurate)
			user.visible_message( \
				"\blue [user] slices \the [src]!", \
				"\blue You slice \the [src]!" \
			)
		else
			user.visible_message( \
				"\blue [user] inaccurately slices \the [src] with [W]!", \
				"\blue You inaccurately slice \the [src] with your [W]!" \
			)
			slices_lost = rand(1,min(1,round(slices_num/2)))
		var/reagents_per_slice = reagents.total_volume/slices_num
		for(var/i=1 to (slices_num-slices_lost))
			var/obj/slice = new slice_path (src.loc)
			reagents.trans_to(slice,reagents_per_slice)
		del(src)
		return


////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'drinks.dmi'
	var/opened = 0
	icon_state = null
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,25)
	var/create_trash = 0
	var/istrash = 0
	volume = 50

	on_reagent_change()
		if (gulp_size < 5) gulp_size = 5
		else gulp_size = max(round(reagents.total_volume / 5), 5)


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents
		var/fillevel = gulp_size
		src.opened = 1

		if(!R.total_volume || !R)
			user << "\red None of [src] left, oh no!"
			if(src.create_trash && !src.istrash)
				src.icon_state = "[src.icon_state]_trash"
				src.istrash = 1
			if(src.istrash)
				return 0
			return 0

		if(M == user)
			M << "\blue You swallow a gulp from the [src]."
		//	M << "\blue You swallow a gulp from the [src], tastes like [R]."
			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, gulp_size)

			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1
		else if( istype(M, /mob/living/carbon/human) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			M.attack_log += text("<font color='orange'>[world.time] - has been fed [src.name] by [user.name] ([user.ckey]) Reagents: \ref[reagents]</font>")
			user.attack_log += text("<font color='red'>[world.time] - has fed [M.name] by [M.name] ([M.ckey]) Reagents: \ref[reagents]</font>")


			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, gulp_size)

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = R.get_master_reagent_id()
				spawn(600)
					R.add_reagent(refill, fillevel)


			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1

		return 0

	attackby(obj/item/I as obj, mob/user as mob)
		return

	afterattack(obj/target, mob/user , flag)

		if(istype(target, /obj/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."
			src.opened = 1

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = reagents.get_master_reagent_id()
				spawn(600)
					reagents.add_reagent(refill, trans)

		return

	examine()
		set src in view()
		..()
		if (!(usr in range(0)) && usr!=src.loc) return
		if(src.opened)
			usr << "\blue The seal has been broken!"
		if(!reagents || reagents.total_volume==0)
			usr << "\blue \The [src] is empty!"
		else if (reagents.total_volume<src.volume/4)
			usr << "\blue \The [src] is almost empty!"
		else if (reagents.total_volume<src.volume/2)
			usr << "\blue \The [src] is half full!"
		else if (reagents.total_volume<src.volume/0.90)
			usr << "\blue \The [src] is almost full!"
		else
			usr << "\blue \The [src] is full!"

	proc/shatter(atom/target)
		if(reagents.total_volume)
			if(ismob(target))
				src.reagents.reaction(target, TOUCH)
			if(isturf(target))
				src.reagents.reaction(get_turf(target))
			if(isobj(target))
				src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		playsound(src.loc, "shatter", 40, 0)
		for(var/mob/O in viewers(world.view, src))
			O.show_message(text("\red The [] shatters!", src.name), 1)
		new /obj/decal/cleanable/generic(get_turf(src))
		new /obj/item/weapon/shard(get_turf(src))
		del(src)

////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "a pill."
	icon = 'chemical.dmi'
	icon_state = "pill"
	item_state = "pill"
	possible_transfer_amounts = null
	volume = 50
	var/main_reagent
	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "pill")
				src.icon_state = "pill"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "pill0")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "pill"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		if(M == user)
			M << "\blue You swallow [src]."
			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, reagents.total_volume)
					del(src)
			else
				del(src)
			return 1

		else if(istype(M, /mob/living) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to force [M] to swallow [src].", 1)

			if(!do_mob(user, M)) return

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] forces [M] to swallow [src].", 1)

			M.attack_log += text("<font color='orange'>[world.time] - has been fed [src] by [user.name] ([user.ckey]) Reagents: \ref[reagents]</font>")
			user.attack_log += text("<font color='red'>[world.time] - has fed [src] to [M.name] ([M.ckey]) Reagents: \ref[reagents]</font>")

			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, reagents.total_volume)
					del(src)
			else
				del(src)

			return 1

		return 0

	attackby(obj/item/I as obj, mob/user as mob)
		return

	afterattack(obj/target, mob/user , flag)

		if(target.is_open_container() == 1 && target.reagents)
			if(!target.reagents.total_volume)
				user << "\red [target] is empty. Cant dissolve pill."
				return
			user << "\blue You dissolve the pill in [target]"
			reagents.trans_to(target, reagents.total_volume)
			for(var/mob/O in viewers(2, user))
				O.show_message("\red [user] puts something in [target].", 1)
			spawn(5)
				del(src)

		return


/obj/item/weapon/reagent_containers/pill/long
	name = "pill"
	desc = "a pill."
	icon = 'chemical.dmi'
	icon_state = "pilllong"
	item_state = "pilllong"
	possible_transfer_amounts = null
	volume = 50
	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "pilllong")
				src.icon_state = "pilllong"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "pilllong0")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "pilllong"



////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Subtypes.
////////////////////////////////////////////////////////////////////////////////

//Glasses
/obj/item/weapon/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	volume = 70
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,50,70)
	flags = FPRINT | OPENCONTAINER

	attackby(var/obj/D, mob/user as mob)
		if(istype(D, /obj/item/device/prox_sensor))
			var/obj/item/weapon/bucket_sensor/B = new /obj/item/weapon/bucket_sensor
			B.loc = user
			if (user.r_hand == D)
				user.u_equip(D)
				user.r_hand = B
			else
				user.u_equip(D)
				user.l_hand = B
			B.layer = 20
			user << "You add the sensor to the bucket"
			del(D)
			del(src)

/obj/item/weapon/reagent_containers/glass/metroidcore
	name = "metroid core"
	desc = "A very slimy and tender part of a Metroid. They also legended to have \"magical powers\"."
	icon = 'surgery.dmi'
	icon_state = "metroid core"
	volume = 60
	possible_transfer_amounts = list(0) //hacky I know. The idea is it needs to be extracted with a syringe - Nernums
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	amount_per_transfer_from_this = 0
	flags = FPRINT | OPENCONTAINER



/obj/item/weapon/reagent_containers/glass/canister
	desc = "It's a canister. Mainly used for transporting fuel."
	name = "canister"
	icon = 'tank.dmi'
	icon_state = "canister0"
	item_state = "canister"
	m_amt = 300
	g_amt = 0
	w_class = 4.0
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60)
	volume = 120
	flags = FPRINT
	var/icon/bottlec

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "canister0" || src.icon_state == "canistercolor")
				src.overlays -= bottlec
				src.icon_state = "canistercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				bottlec = new/icon("icon" = 'chemical.dmi', "icon_state" = "canistercolormod")
				bottlec.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += bottlec
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "canister0"

/obj/item/weapon/reagent_containers/glass/dispenser
	name = "reagent glass"
	desc = "A reagent glass."
	icon = 'chemical.dmi'
	icon_state = "beaker"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	flags = FPRINT | TABLEPASS | OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/dispenser/surfactant
	name = "reagent glass (surfactant)"
	icon_state = "liquid"

	New()
		..()
		reagents.add_reagent("fluorosurfactant", 20)

/obj/item/weapon/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker. Can hold up to 50 units."
	icon = 'chemical.dmi'
	icon_state = "beaker0"
	item_state = "beaker"
	volume = 50
	possible_transfer_amounts = list(1,5,10,15,25,50)
	var/icon/beakerc

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "beaker0" || src.icon_state == "beakercolor")
				src.overlays -= beakerc
				src.icon_state = "beakercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "beakercolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "beaker0"

/obj/item/weapon/virusdish
	name = "Virus containment/growth dish"
	icon = 'items.dmi'
	icon_state = "implantcase-b"
	var/datum/disease/virus = null
	var/growth = 0
	var/info = 0
	var/analysed = 0


/obj/item/weapon/virusdish/attackby(var/obj/item/weapon/W as obj,var/mob/living/carbon/user as mob)
	if(istype(W,/obj/item/weapon/hand_labeler))
		return
	..()
	if(prob(10))
		user << "The dish shatters!"
		if(virus.spread_type == AIRBORNE)
			user.contract_disease(virus)
		del src

/obj/item/weapon/virusdish/examine()
	usr << "This is a virus containment dish"
	if(src.info)
		usr << "It has the following information about its contents"
		usr << src.info


/obj/item/weapon/reagent_containers/glass/beaker/testtube
	name = "Test Tube"
	desc = "A test tube. Can hold up to 15 units."
	icon = 'chemical.dmi'
	icon_state = "testtube0"
	item_state = "testtube"
	volume = 15
	amount_per_transfer_from_this = 5


	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "testtube0" || src.icon_state == "testtubecolor")
				src.overlays -= beakerc
				src.icon_state = "testtubecolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "testtubecolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "testtube0"


/obj/item/weapon/reagent_containers/glass/beaker/petri
	name = "petri dish"
	desc = "A petri dish. Can hold 1 unit."
	icon = 'chemical.dmi'
	icon_state = "petri0"
	item_state = "petri"
	layer = 3
	volume = 5
	amount_per_transfer_from_this = 1


	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "petri0" || src.icon_state == "petricolor")
				src.overlays -= beakerc
				src.icon_state = "petricolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "petricolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "petri0"

/obj/item/weapon/reagent_containers/glass/adminbus
	name = "adminbus beaker"
	desc = "Holy fuck, from where did you get this? Holds infinite amounts of chems."
	volume = INFINITY

/obj/item/weapon/reagent_containers/glass/blender_jug
	name = "Blender Jug"
	desc = "A blender jug, part of a blender."
	icon = 'kitchen.dmi'
	icon_state = "blender_jug_e"
	volume = 50

	on_reagent_change()
		switch(src.reagents.total_volume)
			if(0)
				icon_state = "blender_jug_e"
			if(1 to 75)
				icon_state = "blender_jug_h"
			if(76 to 100)
				icon_state = "blender_jug_f"

/obj/item/weapon/reagent_containers/glass/large
	name = "large reagent glass"
	desc = "A large reagent glass. Can hold up to 100 units."
	icon = 'chemical.dmi'
	icon_state = "beakerlarge"
	item_state = "beaker"
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30,50,75,100)
	var/icon/beakerlc

	on_reagent_change()
		if(reagents.total_volume)
			if(src.icon_state == "beakerlarge" || src.icon_state == "beakerlargecolor")
				src.overlays -= beakerlc
				src.icon_state = "beakerlargecolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerlc = new/icon("icon" = 'chemical.dmi', "icon_state" = "beakerlargecolormod")
				beakerlc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerlc
				src.main_reagent = ""
		else
			if(src.icon_state == "beakerlargecolor")
				src.main_reagent = ""
				src.overlays = null
				icon_state = "beakerlarge"

/obj/item/weapon/reagent_containers/glass/large/iv_bag
	name = "IV bag"
	desc = "A sterile plastic bag used for intravenous chemical dispersal. A clamp near the bottom regulates how fast solution gets transferred. It can be worn on the back for mobile administration."
	icon_state = "ivbag"
	item_state = "ivbag"
	volume = 50
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1,2,3,4,5,10)
	flags = FPRINT | TABLEPASS | OPENCONTAINER | ONBACK
	var/icon/ivbagc
	var/obj/item/weapon/surgicaltube/tube
	var/cannula = 0
	var/drip_timer = 5

	New()
		..()

	shatter(atom/target)
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		if(istype(W,/obj/item/weapon/surgicaltube))
			if(!tube)
				src.icon_state = "ivbag_surgicaltube"
				tube = W
				user.drop_item()
				W.loc = src
				user << "\blue You clamp the end of of the tubing around the [src.name]'s IV port!"
				if(W:cannula)
					overlays += image('chemical.dmi', "surgicaltube_cannula")
					cannula = 1
				on_reagent_change()
			else
				user << "\red There's already a tube hooked up to the [src.name]!"
		if (istype(W, /obj/item/weapon/reagent_containers/syringe) && !cannula)
			if(tube)
				cannula = 1
				tube.cannula = 1
				del(W)
				overlays += image('chemical.dmi', "surgicaltube_cannula")
				user << "\blue You use the end of the syringe to make a cannula for the surgical tube!"
			else
				user << "\red A surgical tube needs to be hooked up to this first!"

	on_reagent_change()
		if(reagents.total_volume)
			src.overlays -= ivbagc
			if(src.icon_state == "ivbag" || src.icon_state == "ivbagcolor")
				ivbagc = new/icon("icon" = 'chemical.dmi', "icon_state" = "ivbagcolormod")
			if(src.icon_state == "ivbag_surgicaltube" || src.icon_state == "ivbagcolor_surgicaltube")
				ivbagc = new/icon("icon" = 'chemical.dmi', "icon_state" = "ivbagcolormod_surgicaltube")
			src.main_reagent = src.reagents.get_master_reagent_reference()
			ivbagc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
			src.overlays += ivbagc
			src.main_reagent = ""
		else
			if(src.icon_state == "ivbagcolor")
				src.main_reagent = ""
				src.overlays -= ivbagc
				icon_state = "ivbag"
			if(src.icon_state == "ivbagcolor_surgicaltube")
				src.main_reagent = ""
				src.overlays -= ivbagc
				icon_state = "ivbag_surgicaltube"

	blood
		name = "blood pack"
		desc = "An intravenous bag filled with blood."
		amount_per_transfer_from_this = 3

		New()
			..()
			reagents.add_reagent("blood", 50)
			on_reagent_change()

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	icon_state = "bottle0"
	item_state = "bottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15)
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	volume = 30
	var/icon/bottlec

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "bottle0" || src.icon_state == "bottlecolor")
				src.overlays -= bottlec
				src.icon_state = "bottlecolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				bottlec = new/icon("icon" = 'chemical.dmi', "icon_state" = "bottlecolormod")
				bottlec.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += bottlec
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "bottle0"

/obj/item/weapon/reagent_containers/glass/bottle/small
	name = "bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	icon_state = "bottlesmall0"
	item_state = "bottlesmall"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15)
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	volume = 15

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "bottlesmall0" || src.icon_state == "bottlesmallcolor")
				src.overlays -= bottlec
				src.icon_state = "bottlesmallcolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				bottlec = new/icon("icon" = 'chemical.dmi', "icon_state" = "bottlesmallcolormod")
				bottlec.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += bottlec
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "bottlesmall0"

/obj/item/weapon/reagent_containers/glass/bottle/tricordrazine
	name = "Tricordrazine bottle"
	desc = "A small bottle. Contains Tricordrazine."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("tricordrazine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/ketaminol
	name = "CNS depressant"
	desc = "A small bottle of a strong central nervous system depressant. Contains 2-Cycloketaminol."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("ketaminol", 15)

/obj/item/weapon/reagent_containers/glass/bottle/kelotane
	name = "Kelotane bottle"
	desc = "A small bottle. Contains Kelotane."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("kelotane", 30)

/obj/item/weapon/reagent_containers/glass/bottle/corophizine
	name = "Corophizine bottle"
	desc = "A small bottle. Contains Corophizine - aids in disease recovery."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("corophizine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/chloromydride
	name = "Chloromydride bottle"
	desc = "A small bottle. Contains chloromydride - used to oxygenate blood."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("chloromydride", 30)


/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline
	name = "Inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("inaprovaline", 30)

/obj/item/weapon/reagent_containers/glass/bottle/hemoline
	name = "Hemoline bottle"
	desc = "A small bottle. Contains Hemoline - use it to clot blood."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("hemoline", 30)

/obj/item/weapon/reagent_containers/glass/bottle/heparin
	name = "Heparin bottle"
	desc = "A small bottle. Contains Heparin - use it to thin blood."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("heparin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "Toxin bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("toxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/nutriment
	name = "Nutriment bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("nutriment", 30)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "Cyanide bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("cyanide", 30)

/obj/item/weapon/reagent_containers/glass/bottle/jenkem
	name = "Jenkem bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("jenkem", 30)

/obj/item/weapon/reagent_containers/glass/bottle/fixer
	name = "Fixer bottle"
	desc = "A small bottle. Contains Fixer - use it to stop addictions."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("fixer", 10)

/obj/item/weapon/reagent_containers/glass/bottle/stabilizer
	name = "Chemical stabilizer bottle"
	desc = "A small bottle. Contains stabilizer."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("stabilizer", 30)

/obj/item/weapon/reagent_containers/glass/bottle/synaptizine
	name = "Synaptizine bottle"
	desc = "A small bottle. Contains synaptizine."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("synaptizine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/hulkazine
	name = "Hulkazine bottle"
	desc = "A small bottle. Contains Green."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("hulkazine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/sulfur
	name = "Sulfur bottle"
	desc = "A small bottle. Contains Sulfur."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("sulfur", 30)

/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "Sleep-toxin bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("stoxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate
	name = "Chloral Hydrate Bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("chloralhydrate", 10)		//Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/weapon/reagent_containers/glass/bottle/small/atropine
	name = "Atropine bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("atropine", 15)

/obj/item/weapon/reagent_containers/glass/bottle/small/epinephrine
	name = "Epinephrine bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("epinephrine", 15)

/obj/item/weapon/reagent_containers/glass/bottle/small/emetic
	name = "Emetic bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("emetic", 15)

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "Dylovene bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("anti_toxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/dexalin
	name = "Dexalin bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("dexalin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/spaceacillin
	name = "Spaceacillin bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("spaceacillin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "Ammonia bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("ammonia", 30)

/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("diethylamine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/gay
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/gay(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/flu_virion
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/flu(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/alzheimers
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/alzheimers(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/beesease
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/beesease(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/birdflu
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/birdflu(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/ebola
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/ebola(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/gastric_ejections
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/gastric_ejections(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/dna
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/dnaspread(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/gbs
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/gbs(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/inhalational_anthrax
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/inhalational_anthrax(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/plague
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/plague(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/robotic_transformation
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/robotic_transformation(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/swineflu
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/swineflu(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)


/obj/item/weapon/reagent_containers/glass/bottle/cold
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/cold(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/*
/obj/item/weapon/reagent_containers/glass/bottle/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/gbs
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data) -- No.
*/
/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/fake_gbs(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)
/*
/obj/item/weapon/reagent_containers/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."//Or simply - General BullShit
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)
*/

/obj/item/weapon/reagent_containers/glass/bottle/brainrot
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/brainrot(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/magnitis
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/magnitis(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)

/obj/item/weapon/reagent_containers/glass/bottle/baby
	name = "Pregnancy bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/baby(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)


/obj/item/weapon/reagent_containers/glass/bottle/wizarditis
	name = "Virus culture bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
//	icon_state = "bottle3"		var/obj/decal/cleanable/chemical/B = new /obj/decal/cleanable/chemical(T)
	New()
		..()
		var/datum/disease/F = new /datum/disease/wizarditis(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 1, data)


/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	name = "beaker"
	desc = "A beaker. Can hold up to 30 units."
	icon = 'chemical.dmi'
	icon_state = "beaker0"
	item_state = "beaker"

	New()
		..()
		reagents.add_reagent("cryoxadone", 30)

/obj/item/weapon/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = 4
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = FPRINT | CONDUCT | TABLEPASS | OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/golden_cup/tournament_26_06_2011
	desc = "A golden cup. It will be presented to a winner of tournament 26 june and name of the winner will be graved on it."

//Syringes
/obj/item/weapon/reagent_containers/syringe/robot
	name = "Syringe (mixed)"
	desc = "Contains inaprovaline & anti-toxins."
	New()
		..()
		reagents.add_reagent("inaprovaline", 7)
		reagents.add_reagent("anti_toxin", 8)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	New()
		..()
		reagents.add_reagent("inaprovaline", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	New()
		..()
		reagents.add_reagent("anti_toxin", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."
	New()
		..()
		reagents.add_reagent("spaceacillin", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/drugs
	New()
		..()
		reagents.add_reagent("space_drugs", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/psilocybin
	New()
		..()
		reagents.add_reagent("psilocybin", 15)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/jenkem
	New()
		..()
		reagents.add_reagent("jenkem", 15)
		update_icon()

/obj/item/weapon/reagent_containers/ld50_syringe/choral
	New()
		..()
		reagents.add_reagent("chloralhydrate", 50)
		update_icon()

////////////////////////////////////////////////////////////////////////////////
/// Concrete food moved to code/modules/food/food.dm
/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

/obj/item/weapon/reagent_containers/food/condiment	//Food items that aren't eaten normally and leave an empty container behind.
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'food.dmi'
	icon_state = "emptycondiment"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	volume = 50

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents

		if(!R || !R.total_volume)
			user << "\red None of [src] left, oh no!"
			return 0

		if(M == user)
			M << "\blue You swallow some of contents of the [src]."
			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, 10)

			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1
		else if( istype(M, /mob/living/carbon/human) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			M.attack_log += text("<font color='orange'>[world.time] - has been fed [src.name] by [user.name] ([user.ckey]) Reagents: \ref[reagents]</font>")
			user.attack_log += text("<font color='red'>[world.time] - has fed [src.name] by [M.name] ([M.ckey]) Reagents: \ref[reagents]</font>")


			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, 10)

			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1
		return 0

	attackby(obj/item/I as obj, mob/user as mob)
		return

	afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		//Something like a glass or a food item. Player probably wants to transfer TO it.
		else if(target.is_open_container() || istype(target, /obj/item/weapon/reagent_containers/food/snacks))
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red you can't add anymore to [target]."
				return
			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the condiment to [target]."

	on_reagent_change()
		if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall")
			return
		if(reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("ketchup")
					name = "Ketchup"
					desc = "You feel more American already."
					icon_state = "ketchup"
				if("capsaicin")
					name = "Hotsauce"
					desc = "You can almost TASTE the stomach ulcers now!"
					icon_state = "hotsauce"
				if("enzyme")
					name = "Universal Enzyme"
					desc = "Used in cooking various dishes."
					icon_state = "enzyme"
				if("soysauce")
					name = "Soy Sauce"
					desc = "A salty soy-based flavoring."
					icon_state = "soysauce"
				if("frostoil")
					name = "Coldsauce"
					desc = "Leaves the tongue numb in it's passage."
					icon_state = "coldsauce"
				if("sodiumchloride")
					name = "Salt Shaker"
					desc = "Salt. From space oceans, presumably."
					icon_state = "saltshaker"
				if("blackpepper")
					name = "Pepper Mill"
					desc = "Often used to flavor food or make people sneeze."
					icon_state = "peppermillsmall"
				if("cornoil")
					name = "Corn Oil"
					desc = "A delicious oil used in cooking. Made from corn."
					icon_state = "oliveoil"
				if("sugar")
					name = "Sugar"
					desc = "Tastey space sugar!"
				else
					name = "Misc Condiment Bottle"
					if (reagents.reagent_list.len==1)
						desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
					else
						desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
					icon_state = "mixedcondiments"
		else
			icon_state = "emptycondiment"
			name = "Condiment Bottle"
			desc = "An empty condiment bottle."
			return

/obj/item/weapon/reagent_containers/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"
	New()
		..()
		reagents.add_reagent("enzyme", 50)

/obj/item/weapon/reagent_containers/food/condiment/sugar
	New()
		..()
		reagents.add_reagent("sugar", 50)

/obj/item/weapon/reagent_containers/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "Salt Shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	New()
		..()
		reagents.add_reagent("sodiumchloride", 20)

/obj/item/weapon/reagent_containers/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	New()
		..()
		reagents.add_reagent("blackpepper", 20)


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "Space Milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	volume = 80
	New()
		..()
		reagents.add_reagent("milk", 80)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/water
	name = "Bottled Water"
	desc = "Water of sufficiently high quality that can be consumed or used with low risk of immediate or long term harm."
	icon_state = "water"
	New()
		..()
		reagents.add_reagent("water", 50)

/obj/item/weapon/reagent_containers/food/drinks/penismilk
	name = "Penis Milk"
	desc = "It's penis milk. Sticky and white goodness!"
	icon_state = "penismilk"
	New()
		..()
		reagents.add_reagent("cum", 50)
		src.pixel_x = rand(3.0, 3)
		src.pixel_y = rand(3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/chocolatemilk
	name = "Chocolate Milk"
	desc = "It's chocolate milk. Sticky and brown goodness!"
	icon_state = "chocolatemilk"
	New()
		..()
		reagents.add_reagent("poo", 50)
		src.pixel_x = rand(3.0, 3)
		src.pixel_y = rand(3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "SoyMilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	New()
		..()
		reagents.add_reagent("soymilk", 50)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("coffee", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "tea"
	New()
		..()
		reagents.add_reagent("tea", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("ice", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "tea"
	New()
		..()
		reagents.add_reagent("hot_coco", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	New()
		..()
		reagents.add_reagent("dry_ramen", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	New()
		..()
		reagents.add_reagent("cola", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/robust_cola
	name = "Robustmin's Cola"
	desc = "95% Caffeine, 5% Junk. It's what Robustmins live on."
	icon_state = "Robustmins_cola"
	New()
		..()
		reagents.add_reagent("Robustmins_cola", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/beer
	name = "Space Beer"
	desc = "Beer. In space."
	icon_state = "beer"
	New()
		..()
		reagents.add_reagent("beer", 28)
		reagents.add_reagent("ethanol", 2)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	New()
		..()
		reagents.add_reagent("ale", 28)
		reagents.add_reagent("ethanol", 2)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/space_mountain_wind
	name = "Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	New()
		..()
		reagents.add_reagent("spacemountainwind", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsably."
	icon_state = "thirteen_loko"
	New()
		..()
		reagents.add_reagent("thirteenloko", 24)
		reagents.add_reagent("ethanol", 6)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/dr_gibb
	name = "Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	New()
		..()
		reagents.add_reagent("dr_gibb", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/starkist
	name = "Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	New()
		..()
		reagents.add_reagent("cola", 15)
		reagents.add_reagent("orangejuice", 15)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	New()
		..()
		reagents.add_reagent("space_up", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)

/obj/item/weapon/reagent_containers/food/drinks/lemon_lime
	name = "Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	New()
		..()
		reagents.add_reagent("lemon_lime", 30)
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)


/obj/item/weapon/reagent_containers/food/drinks/papercup
	name = "Paper Cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	New()
		..()
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)
	on_reagent_change()
		if(reagents.total_volume)
			icon_state = "water_cup"
		else
			icon_state = "water_cup_e"

///////////////////////////////////////////////Alcohol bottles! -Agouri //////////////////////////
//Notes by Darem: Functionally identical to regular drinks. The only difference is that the default bottle size is 100.
/obj/item/weapon/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100

/obj/item/weapon/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	New()
		..()
		reagents.add_reagent("gin", 65)
		reagents.add_reagent("ethanol", 35)

/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	New()
		..()
		reagents.add_reagent("whiskey", 60)
		reagents.add_reagent("ethanol", 40)

/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	New()
		..()
		reagents.add_reagent("vodka", 50) //fucks sake nernums, vodka had the same abv as whiskey?
		reagents.add_reagent("ethanol", 50)

/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality Tequilla"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	New()
		..()
		reagents.add_reagent("tequilla", 60)
		reagents.add_reagent("ethanol", 40)

/obj/item/weapon/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequilla, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	New()
		..()
		reagents.add_reagent("patron", 60)
		reagents.add_reagent("ethanol", 40)

/obj/item/weapon/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	New()
		..()
		reagents.add_reagent("rum", 60)
		reagents.add_reagent("ethanol", 40)

/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	New()
		..()
		reagents.add_reagent("vermouth", 80)
		reagents.add_reagent("ethanol", 20)

/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	New()
		..()
		reagents.add_reagent("kahlua", 80)
		reagents.add_reagent("ethanol", 20)

/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	New()
		..()
		reagents.add_reagent("goldschlager", 60)
		reagents.add_reagent("ethanol", 40)

/obj/item/weapon/reagent_containers/food/drinks/bottle/robustersdelight
	name = "George Melons' Premium Robuster's Delight"
	desc = "The label reads; 'ARE YOU ROBUST ENOUGH TO DRINK THIS'"
	icon_state = "goldschlagerbottle"
	New()
		..()
		reagents.add_reagent("robustersdelight", 300)

/obj/item/weapon/reagent_containers/food/drinks/bottle/hngr_bourbon
	name = "Lotsemone(tm) Hand Grenade Bourbon"
	desc = "A small flask containing quality bourbon."
	icon_state = "flask"
	New()
		..()
		reagents.add_reagent("hngr_bourbon", 75)


/obj/item/weapon/reagent_containers/food/drinks/bottle/fortranfanta
	name = "ADMIMBUS brand FORTRAN Fanta"
	desc = "5% caffeine, 95% robustness. George Melons' personal favorite."
	icon_state = "flask"
	New()
		..()
		reagents.add_reagent("fortranfanta", 50)

/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	New()
		..()
		reagents.add_reagent("cognac", 60)
		reagents.add_reagent("ethanol", 40)
/obj/item/weapon/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	New()
		..()
		reagents.add_reagent("wine", 90)
		reagents.add_reagent("ethanol", 10)
//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	New()
		..()
		reagents.add_reagent("orangejuice", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	New()
		..()
		reagents.add_reagent("cream", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	New()
		..()
		reagents.add_reagent("tomatojuice", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	New()
		..()
		reagents.add_reagent("limejuice", 100)

/obj/item/weapon/reagent_containers/food/drinks/tonic
	name = "T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	New()
		..()
		reagents.add_reagent("tonic", 50)

/obj/item/weapon/reagent_containers/food/drinks/sodawater
	name = "Soda Water"
	desc = "A can of soda water. Why not make a scotch and soda?"
	icon_state = "sodawater"
	New()
		..()
		reagents.add_reagent("sodawater", 50)


//Pills
/obj/item/weapon/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	New()
		..()
		reagents.add_reagent("anti_toxin", 50)

/obj/item/weapon/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	New()
		..()
		reagents.add_reagent("toxin", 50)

/obj/item/weapon/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	New()
		..()
		reagents.add_reagent("cyanide", 50)

/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("robustersdelight", 50)

/obj/item/weapon/reagent_containers/pill/polyadrenalobin
	name = "Polyadrenalobin pill"
	desc = "Polyadrenalobin is designed to be a stimulant, it can aid in the revival of a patient who has died or is near death."
	New()
		..()
		reagents.add_reagent("polyadrenalobin", 50)

/obj/item/weapon/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("stoxin", 30)

/obj/item/weapon/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	New()
		..()
		reagents.add_reagent("kelotane", 30)

/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	New()
		..()
		reagents.add_reagent("inaprovaline", 50)

/obj/item/weapon/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	New()
		..()
		reagents.add_reagent("dexalin", 30)

/obj/item/weapon/reagent_containers/pill/orlistat
	name = "Orlistat pill"
	desc = "Anti-obseity Medicine."
	New()
		..()
		reagents.add_reagent("orlistat", 30)

/obj/item/weapon/reagent_containers/pill/sildenafil
	name = "Sildenafil pill"
	desc = "A drug used to treat erectile dysfunction and pulmonary arterial hypertension."
	New()
		..()
		reagents.add_reagent("sildenafil", 30)

/obj/item/weapon/reagent_containers/pill/fixer
	name = "Fixer pill"
	desc = "Helps end addictions."
	New()
		..()
		reagents.add_reagent("fixer", 10)

//Dispensers
/obj/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",1000)

/obj/reagent_dispensers/watertank/hicapacity
	name = "High-Capacity Watertank"
	desc = "A bulky tank that had an enormous amount of water bashed into it by crazed assistants."
	anchored = 1
	volume = 25000
	New()
		..()
		reagents.add_reagent("water",25000)

/obj/reagent_dispensers/watertank/drinkingfountain
	name = "water cooler"
	desc = "A water cooler"
	icon = 'objects.dmi'
	icon_state = "drinkingfountain"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0

	New()
		..()
		reagents.add_reagent("water",1000)

	attack_hand(var/mob/user as mob)
		user.show_message(text("\red you need a drinking glass!"))

/obj/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fueltank"
	icon = 'objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("fuel",1000)

/obj/reagent_dispensers/fueltank/big
	name = "High-Capacity Fueltank"
	desc = "A bulky tank that had an enormous amount of welding fuel bashed into it by crazed assistants covered in asbestos. "
	anchored = 1
	volume = 10000
	New()
		..()
		reagents.add_reagent("fuel",10000)

/obj/reagent_dispensers/foamtank
	name = "foamtank"
	desc = "A holding tank filled with fire-suppressing foam."
	icon = 'objects.dmi'
	icon_state = "foamtank"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("fluorosurfactant",1000)

/obj/reagent_dispensers/fueltank/blob_act()
	explosion(src.loc,0,1,5,7,10)
	if(src)
		del(src)

/obj/reagent_dispensers/fueltank/ex_act()
	explosion(src.loc,-1,0,2)
	if(src)
		del(src)

/obj/reagent_dispensers/fueltank/big/blob_act()
	explosion(src.loc,0,2,10,14,20)
	if(src)
		del(src)


/obj/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses drinking water"
	amount_per_transfer_from_this = 5
	icon = 'vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	New()
		..()
		reagents.add_reagent("water",500)

/obj/item/weapon/reagent_containers/glass/chemtank_portable
	name = "Portable Chemical Tank"
	desc = "Smaller and can be carried around, only stores half the amount as the original."
	icon = 'objects.dmi'
	icon_state = "chemtank_small"
	volume = 500
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,30,50,75,100,250,500)

/obj/reagent_dispensers/chemtank
	name = "Chemical Tank"
	desc = "May contain dangerous chemicals."
	icon = 'objects.dmi'
	icon_state = "chemtank"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,30,50,100)	//up to the big beaker, and not an unit further
													//just so we don't have to use bullshit per instance definitions
/obj/reagent_dispensers/chemtank/inaprovaline
	name = "Inaprovaline Tank"
	New()
		..()
		reagents.add_reagent("inaprovaline",1000)

/obj/reagent_dispensers/chemtank/antitoxin
	name = "Anti-Toxin Tank"
	New()
		..()
		reagents.add_reagent("anti_toxin",1000)

/obj/reagent_dispensers/chemtank/blood
	name = "Blood Tank"
	New()
		..()
		reagents.add_reagent("blood",1000)

/obj/reagent_dispensers/chemtank/pacid
	name = "Polytrinic Acid Tank"
	New()
		..()
		reagents.add_reagent("pacid",1000)

/obj/reagent_dispensers/chemtank/acid
	name = "Sulfuric Acid Tank"
	New()
		..()
		reagents.add_reagent("acid",1000)

/obj/reagent_dispensers/chemtank/water
	name = "Water Supply Tank"
	New()
		..()
		reagents.add_reagent("water",1000)

/obj/reagent_dispensers/chemtank/spacecleaner
	name = "Space Cleaner Tank"
	New()
		..()
		reagents.add_reagent("cleaner",1000)

/obj/reagent_dispensers/chemtank/plantbgone
	name = "Plant-B-Gone Tank"
	New()
		..()
		reagents.add_reagent("plantbgone",1000)

//bullshit tanks
/obj/reagent_dispensers/chemtank/radium
	name = "WARNING: Radium Tank"
	New()
		..()
		reagents.add_reagent("radium",1000)

/obj/reagent_dispensers/chemtank/thc
	name = "THC Tank"
	New()
		..()
		reagents.add_reagent("thc",1000)

/obj/reagent_dispensers/chemtank/orlistat
	name = "Orlistat Tank"
	New()
		..()
		reagents.add_reagent("orlistat",1000)

/obj/reagent_dispensers/chemtank/tobacco
	name = "Liquid Tobacco Tank"
	New()
		..()
		reagents.add_reagent("tobacco",1000)

/obj/reagent_dispensers/chemtank/nicotine
	name = "Nicotine Tank" //NICOTINE IS LIQUID BY DEFAULT, FUCKASSES
	New()
		..()
		reagents.add_reagent("nicotine",1000)

/obj/reagent_dispensers/chemtank/metroid
	name = "Metroid Jam Tank"
	New()
		..()
		reagents.add_reagent("metroid",1000)

/obj/reagent_dispensers/chemtank/sildenafil
	name = "Sildenafil Tank"
	New()
		..()
		reagents.add_reagent("sildenafil",1000)

/obj/reagent_dispensers/chemtank/zombiepowder
	name = "Zombie Powder Tank"
	New()
		..()
		reagents.add_reagent("zombiepowder",1000)

/obj/reagent_dispensers/chemtank/waste
	name = "Human Waste Tank"
	New()
		..()
		reagents.add_reagent("jenkem",1000)

/obj/reagent_dispensers/chemtank/spacedrugs
	name = "Space Drugs Tank"
	New()
		..()
		reagents.add_reagent("space_drugs",1000)
//end bullshit tanks

/obj/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("beer",1000)

/obj/reagent_dispensers/beerkeg/blob_act()
	explosion(src.loc,0,3,5,7,10)
	del(src)


//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "Shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 100

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "Captain's Flask"
	desc = "A metal flask belonging to the captain"
	icon_state = "flask"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the british flag emblazoned on it."
	icon_state = "britcup"
	volume = 30

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "drinking glass"
	desc = "Your standard drinking glass."
	amount_per_transfer_from_this = 10
	volume = 50
	icon = 'chemical.dmi'
	icon_state = "drinkglass0"
	item_state = "drinkglass"
	var/icon/beakerc
	var/main_reagent

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "drinkglass0" || src.icon_state == "drinkglasscolor")
				src.overlays -= beakerc
				src.icon_state = "drinkglasscolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "drinkglasscolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "drinkglass0"

/*		if(reagents.reagent_list.len > 1 )
			icon_state = "glass_brown"
			name = "Glass of Hooch"
			desc = "Two or more drinks, mixed together."
		else if(reagents.reagent_list.len == 1)
			for(var/datum/reagent/R in reagents.reagent_list)
				switch(R.id)
		if (reagents.reagent_list.len > 0)
			//mrid = R.get_master_reagent_id()
			switch(reagents.get_master_reagent_id())
				if("beer")
					icon_state = "beerglass"
					name = "Beer glass"
					desc = "A freezing pint of beer"
				if("beer2")
					icon_state = "beerglass"
					name = "Beer glass"
					desc = "A freezing pint of beer"
				if("ale")
					icon_state = "aleglass"
					name = "Ale glass"
					desc = "A freezing pint of delicious Ale"
				if("milk")
					icon_state = "glass_white"
					name = "Glass of milk"
					desc = "White and nutritious goodness!"
				if("cream")
					icon_state  = "glass_white"
					name = "Glass of cream"
					desc = "Ewwww..."
				if("chocolate")
					icon_state  = "chocolateglass"
					name = "Glass of chocolate"
					desc = "Tasty"
				if("lemon")
					icon_state  = "lemonglass"
					name = "Glass of lemon"
					desc = "Sour..."
				if("cola")
					icon_state  = "glass_brown"
					name = "Glass of Space Cola"
					desc = "A glass of refreshing Space Cola"
				if("orangejuice")
					icon_state = "glass_orange"
					name = "Glass of Orange juice"
					desc = "Vitamins! Yay!"
				if("tomatojuice")
					icon_state = "glass_red"
					name = "Glass of Tomato juice"
					desc = "Are you sure this is tomato juice?"
				if("blood")
					icon_state = "glass_red"
					name = "Glass of Tomato juice"
					desc = "Are you sure this is tomato juice?"
				if("limejuice")
					icon_state = "glass_green"
					name = "Glass of Lime juice"
					desc = "A glass of sweet-sour lime juice."
				if("whiskey")
					icon_state = "whiskeyglass"
					name = "Glass of whiskey"
					desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
				if("gin")
					icon_state = "ginvodkaglass"
					name = "Glass of gin"
					desc = "A crystal clear glass of Griffeater gin."
				if("vodka")
					icon_state = "ginvodkaglass"
					name = "Glass of vodka"
					desc = "The glass contain wodka. Xynta."
				if("goldschlager")
					icon_state = "ginvodkaglass"
					name = "Glass of goldschlager"
					desc = "100 proof that teen girls will drink anything with gold in it."
				if("wine")
					icon_state = "wineglass"
					name = "Glass of wine"
					desc = "A very classy looking drink."
				if("cognac")
					icon_state = "cognacglass"
					name = "Glass of cognac"
					desc = "Damn, you feel like some kind of French aristocrat just by holding this."
				if ("kahlua")
					icon_state = "kahluaglass"
					name = "Glass of RR coffee Liquor"
					desc = "DAMN, THIS THING LOOKS ROBUST"
				if("vermouth")
					icon_state = "vermouthglass"
					name = "Glass of Vermouth"
					desc = "You wonder why you're even drinking this straight."
				if("tequilla")
					icon_state = "tequillaglass"
					name = "Glass of Tequilla"
					desc = "Now all that's missing is the weird colored shades!"
				if("patron")
					icon_state = "patronglass"
					name = "Glass of Patron"
					desc = "Drinking patron in the bar, with all the subpar ladies."
				if("rum")
					icon_state = "rumglass"
					name = "Glass of Rum"
					desc = "Now you want to Pray for a pirate suit, don't you?"
				if("gintonic")
					icon_state = "gintonicglass"
					name = "Gin and Tonic"
					desc = "A mild but still great cocktail. Drink up, like a true Englishman."
				if("whiskeycola")
					icon_state = "whiskeycolaglass"
					name = "Whiskey Cola"
					desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
				if("whiterussian")
					icon_state = "whiterussianglass"
					name = "White Russian"
					desc = "A very nice looking drink. But that's just, like, your opinion, man."
				if("screwdrivercocktail")
					icon_state = "screwdriverglass"
					name = "Screwdriver"
					desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
				if("bloodymary")
					icon_state = "bloodymaryglass"
					name = "Bloody Mary"
					desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."
				if("martini")
					icon_state = "martiniglass"
					name = "Classic Martini"
					desc = "Damn, the bartender even stirred it, not shook it."
				if("vodkamartini")
					icon_state = "martiniglass"
					name = "Vodka martini"
					desc ="A bastardisation of the classic martini. Still great."
				if("gargleblaster")
					icon_state = "gargleblasterglass"
					name = "Pan-Galactic Gargle Blaster"
					desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
				if("bravebull")
					icon_state = "bravebullglass"
					name = "Brave Bull"
					desc = "Tequilla and Coffee liquor, brought together in a mouthwatering mixture. Drink up."
				if("tequillasunrise")
					icon_state = "tequillasunriseglass"
					name = "Tequilla Sunrise"
					desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."
				if("toxinsspecial")
					icon_state = "toxinsspecialglass"
					name = "Toxins Special"
					desc = "Whoah, this thing is on FIRE"
				if("beepskysmash")
					icon_state = "beepskysmashglass"
					name = "Beepsky Smash"
					desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
				if("doctorsdelight")
					icon_state = "doctorsdelightglass"
					name = "Doctor's Delight"
					desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
				if("manlydorf")
					icon_state = "manlydorfglass"
					name = "The Manly Dorf"
					desc = "A manly concotion made from Ale and Beer. Intended for true men only."
				if("irishcream")
					icon_state = "irishcreamglass"
					name = "Irish Cream"
					desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
				if("cubalibre")
					icon_state = "cubalibreglass"
					name = "Cuba Libre"
					desc = "A classic mix of rum and cola."
				if("irishcream")
					icon_state = "irishcreamglass"
					name = "Irish Cream"
					desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
				if("cubalibre")
					icon_state = "cubalibreglass"
					name = "Cuba Libre"
					desc = "A classic mix of rum and cola."
				if("b52")
					icon_state = "b52glass"
					name = "B-52"
					desc = "Kahlua, Irish Cream, and congac. You will get bombed."
				if("atomicbomb")
					icon_state = "atomicbombglass"
					name = "Atomic Bomb"
					desc = "Nanotrasen cannot take legal responsibility for your actions after imbibing."
				if("longislandicedtea")
					icon_state = "longislandicedteaglass"
					name = "Long Island Iced Tea"
					desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
				if("threemileisland")
					icon_state = "threemileislandglass"
					name = "Three Mile Island Ice Tea"
					desc = "A glass of this is sure to prevent a melt down."
				if("margarita")
					icon_state = "margaritaglass"
					name = "Margarita"
					desc = "On the rocks with salt on the rim. Arriba~!"
				if("blackrussian")
					icon_state = "blackrussianglass"
					name = "Black Russian"
					desc = "For the lactose-intolerant. Still as classy as a White Russian."
				if("vodkatonic")
					icon_state = "vodkatonicglass"
					name = "Vodka and Tonic"
					desc = "For when a gin and tonic isn't russian enough."
				if("manhattan")
					icon_state = "manhattanglass"
					name = "Manhattan"
					desc = "The Detective's undercover drink of choice. He never could stomach gin..."
				if("manhattan_proj")
					icon_state = "proj_manhattanglass"
					name = "Manhattan Project"
					desc = "A scienitst drink of choice, for thinking how to blow up the station."
				if("ginfizz")
					icon_state = "ginfizzglass"
					name = "Gin Fizz"
					desc = "Refreshingly lemony, deliciously dry."
				if("irishcoffee")
					icon_state = "irishcoffeeglass"
					name = "Irish Coffee"
					desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
				if("hooch")
					icon_state = "glass_brown2"
					name = "Hooch"
					desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
				if("whiskeysoda")
					icon_state = "whiskeysodaglass2"
					name = "Whiskey Soda"
					desc = "Ultimate refreshment."
				if("tonic")
					icon_state = "glass_clear"
					name = "Glass of Tonic Water"
					desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
				if("sodawater")
					icon_state = "glass_clear"
					name = "Glass of Soda Water"
					desc = "Soda water. Why not make a scotch and soda?"
				if("water")
					icon_state = "glass_clear"
					name = "Glass of Water"
					desc = "Are you really that boring?"
				if("spacemountainwind")
					icon_state = "Space_mountain_wind_glass"
					name = "Glass of Space Mountain Wind"
					desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."
				if("thirteenloko")
					icon_state = "thirteen_loko_glass"
					name = "Glass of Thirteen Loko"
					desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass"
				if("dr_gibb")
					icon_state = "dr_gibb_glass"
					name = "Glass of Dr. Gibb"
					desc = "Dr. Gibb. Not as dangerous as the name might imply."
				if("space_up")
					icon_state = "space-up_glass"
					name = "Glass of Space-up"
					desc = "Space-up. It helps keep your cool."
				if("moonshine")
					icon_state = "glass_clear"
					name = "Moonshine"
					desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
				if("soymilk")
					icon_state = "glass_white"
					name = "Glass of soy milk"
					desc = "White and nutritious soy goodness!"
				if("berryjuice")
					icon_state = "berryjuice"
					name = "Glass of berry juice"
					desc = "Berry juice. Or maybe its jam. Who cares?"
				if("poisonberryjuice")
					icon_state = "poisonberryjuice"
					name = "Glass of poison berry juice"
					desc = "A glass of deadly juice."
				if("carrotjuice")
					icon_state = "carrotjuice"
					name = "Glass of  carrot juice"
					desc = "It is just like a carrot but without crunching."
				if("banana")
					icon_state = "banana"
					name = "Glass of banana juice"
					desc = "The raw essence of a banana. HONK"
				if("bahama_mama")
					icon_state = "bahama_mama"
					name = "Bahama Mama"
					desc = "Tropic cocktail"
				if("sbiten")
					icon_state = "sbitenglass"
					name = "Sbiten"
					desc = "A spicy mix of Vodka and Spice. Very hot."
				if("red_mead")
					icon_state = "red_meadglass"
					name = "Red Mead"
					desc = "A True Vikings Beverage, though its color is strange."
				if("mead")
					icon_state = "meadglass"
					name = "Mead"
					desc = "A Vikings Beverage, though a cheap one."
				if("iced_beer")
					icon_state = "iced_beerglass"
					name = "Iced Beer"
					desc = "A beer so frosty, the air around it freezes."
				if("grog")
					icon_state = "grogglass"
					name = "Grog"
					desc = "A fine and cepa drink for Space."
				if("nuka_cola")
					icon_state = "nuka_colaglass"
					name = "Nuka Cola"
					desc = "A high quality Cola promised to make you jitter."
				if("soy_latte")
					icon_state = "soy_latte"
					name = "Soy Latte"
					desc = "A nice and refrshing beverage while you are reading."
				if("cafe_latte")
					icon_state = "cafe_latte"
					name = "Cafe Latte"
					desc = "A nice, strong and refreshing beverage while you are reading."
				if("acidspit")
					icon_state = "acidspitglass"
					name = "Acid Spit"
					desc = "A drink from Nanotrasen. Made from live aliens."
				if("amasec")
					icon_state = "amasecglass"
					name = "Amasec"
					desc = "Always handy before COMBAT!!!"
				if("neurotoxin")
					icon_state = "neurotoxinglass"
					name = "Neurotoxin"
					desc = "A drink that is guaranteed to knock you silly."
				if("hippiesdelight")
					icon_state = "hippiesdelightglass"
					name = "Hippiesdelight"
					desc = "A drink enjoyed by people during the 1960's."
				if("bananahonk")
					icon_state = "bananahonkglass"
					name = "Banana Honk"
					desc = "A drink from Clown Heaven."
				if("singulo")
					icon_state = "singulo"
					name = "Singulo"
					desc = "A blue-space beverage."
				else
					icon_state ="glass_brown"
					name = "Glass of ..what?"
					desc = "You can't really tell what this is."
		else
			icon_state = "glass_empty"
			name = "Drinking glass"
			desc = "Your standard drinking glass"
			return
*/

// for /obj/machinery/vending/sovietsoda

/obj/item/weapon/reagent_containers/food/drinks/wineglass
	name = "wine glass"
	desc = "Your standard drinking glass."
	amount_per_transfer_from_this = 10
	volume = 50
	icon = 'chemical.dmi'
	icon_state = "wineglass0"
	item_state = "wineglass"
	var/icon/beakerc
	var/main_reagent

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "wineglass0" || src.icon_state == "wineglasscolor")
				src.overlays -= beakerc
				src.icon_state = "wineglasscolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "wineglasscolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "wineglass0"



/obj/item/weapon/reagent_containers/food/drinks/largecocktail
	name = "Large Cocktail glass"
	desc = "Your large cocktail glass."
	amount_per_transfer_from_this = 10
	volume = 80
	icon = 'chemical.dmi'
	icon_state = "singulo0"
	item_state = "singulo"
	var/icon/beakerc
	var/main_reagent

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "singulo0" || src.icon_state == "singulocolor")
				src.overlays -= beakerc
				src.icon_state = "singulocolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "singulocolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "singulo0"

/obj/item/weapon/reagent_containers/food/drinks/cocktail
	name = "Cocktail glass"
	desc = "Your standard cocktail glass."
	amount_per_transfer_from_this = 10
	volume = 50
	icon = 'chemical.dmi'
	icon_state = "hell0"
	item_state = "hell"
	var/icon/beakerc
	var/main_reagent

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "hell0" || src.icon_state == "hellcolor")
				src.overlays -= beakerc
				src.icon_state = "hellcolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hellcolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "hell0"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda
	New()
		..()
		reagents.add_reagent("sodawater", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola
	New()
		..()
		reagents.add_reagent("cola", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/wineglass/wine
	New()
		..()
		reagents.add_reagent("wine", 50)
		on_reagent_change()

///jar

/obj/item/weapon/reagent_containers/food/drinks/jar
	name = "empty jar"
	desc = "A jar. You're not sure what it's supposed to hold."
	icon_state = "jar"
	item_state = "beaker"
	New()
		..()
		reagents.add_reagent("metroid", 50)

	on_reagent_change()
		if (reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("metroid")
					icon_state = "jar_metroid"
					name = "metroid jam"
					desc = "A jar of metroid jam. Delicious!"
				else
					icon_state ="jar_what"
					name = "jar of something"
					desc = "You can't really tell what this is."
		else
			icon_state = "jar"
			name = "empty jar"
			desc = "A jar. You're not sure what it's supposed to hold."
			return
