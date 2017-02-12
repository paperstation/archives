
//BUG!!!: reactions on splashing etc cause errors because stuff gets deleted before it executes.
//		  Bandaid fix using spawn - very ugly, need to fix this.

///////////////////////////////Grenades
/obj/item/weapon/chem_grenade
	name = "metal casing"
	icon_state = "chemg1"
	icon = 'chemical.dmi'
	item_state = "flashbang"
	w_class = 2.0
	force = 2.0
	var/stage = 0
	var/state = 0
	var/list/beakers = new/list()
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
		if(istype(W,/obj/item/assembly/time_ignite) && !stage)
			user << "\blue You add [W] to the metal casing."
			playsound(src.loc, 'Screwdriver2.ogg', 25, -3)
			del(W) //Okay so we're not really adding anything here. cheating.
			icon_state = "chemg2"
			name = "unsecured grenade"
			stage = 1
		else if(istype(W,/obj/item/weapon/screwdriver) && stage == 1)
			if(beakers.len)
				user << "\blue You lock the assembly."
				playsound(src.loc, 'Screwdriver.ogg', 25, -3)
				name = "grenade"
				icon_state = "chemg3"
				stage = 2
			else
				user << "\red You need to add at least one beaker before locking the assembly."
		else if ((istype(W,/obj/item/weapon/reagent_containers/glass/beaker) || istype(W, /obj/item/weapon/reagent_containers/glass/dispenser)) && stage == 1)
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

	/*afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(src.can_be_placed_into.Find(target.type))			//Attempting to fix grenades arming themselves when you stick them on a table etc. - Mattr3ss
			return ..()
		if (!src.state && stage == 2)
			user << "\red You prime the grenade! 3 seconds!"
			message_admins("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
			src.state = 1
			src.icon_state = "chemg4"
			playsound(src.loc, 'armbomb.ogg', 75, 1, -3)
			spawn(30)
				explode()
			user.drop_item()
			var/t = (isturf(target) ? target : target.loc)
			walk_towards(src, t, 3)*/

	attack_self(mob/user as mob)
		if (!src.state && stage == 2)
			user << "\red You prime the grenade! 3 seconds!"
			message_admins("[key_name_admin(user)] used a chemistry grenade ([src.name]).")
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
			var/has_reagents = 0
			for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
				if(G.reagents.total_volume) has_reagents = 1

			if(!has_reagents)
				playsound(src.loc, 'Screwdriver2.ogg', 50, 1)
				state = 0
				return

			playsound(src.loc, 'bamf.ogg', 50, 1)

			for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
				G.reagents.trans_to(src, G.reagents.total_volume)

			if(src.reagents.total_volume) //The possible reactions didnt use up all reagents.
				var/datum/effects/system/steam_spread/steam = new /datum/effects/system/steam_spread()
				steam.set_up(10, 0, get_turf(src))
				steam.attach(src)
				steam.start()

				for(var/atom/A in view(3, src.loc))
					if( A == src ) continue
					src.reagents.reaction(A, 1, 10)


			invisibility = 100 //Why am i doing this?
			spawn(50)		   //To make sure all reagents can work
				del(src)	   //correctly before deleting the grenade.

/obj/item/weapon/chem_grenade/metalfoam
	name = "Metal-Foam Grenade"
	desc = "Used for emergency sealing of air breaches."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("aluminium", 30)
		B2.reagents.add_reagent("foaming_agent", 10)
		B2.reagents.add_reagent("pacid", 10)

		beakers += B1
		beakers += B2

/obj/item/weapon/chem_grenade/incendiary
	name = "Incendiary Grenade"
	desc = "Used for clearing rooms of living things."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("aluminium", 25)
		B2.reagents.add_reagent("plasma", 25)
		B2.reagents.add_reagent("acid", 25)

		beakers += B1
		beakers += B2

/obj/item/weapon/chem_grenade/cleaner
	name = "Cleaner Grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 30)
		B2.reagents.add_reagent("water", 10)
		B2.reagents.add_reagent("cleaner", 10)

		beakers += B1
		beakers += B2

/obj/item/weapon/chem_grenade/extinguishfoam
	name = "Extinguisher Grenade"
	desc = "An extinguisher grenade, filled with foam to put out fire quicker than usual."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 30)
		B2.reagents.add_reagent("fluorosurfactant", 30)

		beakers += B1
		beakers += B2

/*/obj/item/weapon/chem_grenade/water
	name = "Water Grenade"
	desc = "A water grenade."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)

		B1.reagents.add_reagent("water", 30)

		beakers += B1


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

/obj/item/weapon/chem_grenade/poo
	name = "poo grenade"
	desc = "A ShiTastic! brand biological warfare charge. Not very effective unless the target is squeamish."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("poo", 10)
		B1.reagents.add_reagent("potassium", 10)
		B2.reagents.add_reagent("sugar", 10)
		B2.reagents.add_reagent("phosphorus", 10)

		beakers += B1
		beakers += B2*/

///////////////////////////////Grenades

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
	var/max_syringes = 1
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
				var/turf/trg = get_turf(target)
				var/obj/syringe_gun_dummy/D = new/obj/syringe_gun_dummy(get_turf(src))
				var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]
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
						D.reagents.trans_to(M, 15)
						for(var/mob/O in viewers(world.view, D))
							O.show_message(text("\red [] was hit by the syringe!", M), 1)

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

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/reagent_dispensers/verb/set_APTFT
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



/obj/item/weapon/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'chemical.dmi'
	icon_state = null
	w_class = 1
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,25)
	var/volume = 30

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set src in range(0)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

	New()
		..()
		if (!possible_transfer_amounts)
			src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src

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
		/obj/item/weapon/secstorage/ssafe,
		/obj/machinery/disposal/
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
			O.show_message(text("\red The [] shatters!", src), 1)
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

		if(ismob(target) && target.reagents && reagents.total_volume)
			user << "\blue You splash the solution onto [target]."
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] has been splashed with something by []!", target, user), 1)
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return

		else if((istype(target, /obj/item/device/Tricorder)) || (istype(target, /obj/closet)) || (istype(target, /obj/item/weapon/reagent_containers/syringe)) || (istype(target, /obj/crate)) || (istype(target, /obj/item/weapon/storage)) || (istype(target, /obj/machinery/chem_dispenser)) || (istype(target, /obj/machinery/Medicinereplicator))) //can_be_placed_into doesn't work quite well I guess
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
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/dropper
	name = "Dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	var/filled = 0
	var/main_reagent
	volume = 5


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
			if (src.icon_state == "dropper0")
				src.icon_state = "droppercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/dropperc = new/icon("icon" = 'chemical.dmi', "icon_state" = "droppercolormod")
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
			if (src.icon_state == "dropper0")
				src.icon_state = "droppercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/dropperc = new/icon("icon" = 'chemical.dmi', "icon_state" = "droppercolormod")
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
						if(T.virus && T.virus.spread_type != SPECIAL)
							B.data["virus"] = new T.virus.type(0)
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
						//for(var/D in B.data)
						//	world << "Data [D] = [B.data[D]]"
						//debug
						src.reagents.reagent_list += B
						src.reagents.update_total()
						src.on_reagent_change()
						src.reagents.handle_reactions()
						user << "\blue You take a blood sample from [target]"
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

		return

	update_icon()
		var/rounded_vol = round(reagents.total_volume,5)
		if(ismob(loc))
			var/mode_t
			switch(mode)
				if (SYRINGE_DRAW)
					mode_t = "d"
				if (SYRINGE_INJECT)
					mode_t = "i"
			icon_state = "[mode_t][rounded_vol]"
		else
			icon_state = "[rounded_vol]"
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
	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "hypo0")
				src.icon_state = "hypocolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
				hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += hypoc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "hypo0"

/obj/item/weapon/reagent_containers/hypospray/attack_paw(mob/user as mob)
	return src.attack_hand(user)


/obj/item/weapon/reagent_containers/hypospray/New()
	..()
	reagents.add_reagent("tricordrazine", 30) //uncomment this to make it start with stuff in
	update()
	return

/obj/item/weapon/reagent_containers/hypospray/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	if (reagents.total_volume)
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
	if (vial == 1)
		user << "The [W] is already inserted."
		update()
		return
	if (istype(W, /obj/item/weapon/reagent_containers/glass/hyposprayvial))
		src.hyposprayvial = W
		vial = 1
		user << "You insert [W]."
		src.updateUsrDialog()
		W.reagents.trans_to(src, W:reagents.total_volume)
		user << "You insert [W]."
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

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "hypo0")
				src.icon_state = "hypocolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
				hypoc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += hypoc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "hypo0"


/obj/item/weapon/reagent_containers/glass/hyposprayvial/New()
	..()

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

	proc/On_Consume()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return
	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents
		if(!R.total_volume || !R)
			user << "\red None of [src] left, oh no!"
			if(src.create_trash && !src.istrash)
				src.icon_state = "[src.icon_state]_trash"
				src.istrash = 1
			if(src.istrash)
				return
			return 0
		if(istype(M, /mob/living/carbon/human))
			if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/poo))
				if((!user.zone_sel.selecting == "head") || (!user.zone_sel.selecting == "eyes") || (!user.zone_sel.selecting == "mouth"))
					if(M:wear_suit) M:wear_suit.add_poo()
					if(M:w_uniform) M:w_uniform.add_poo()
					if(M:shoes) M:shoes.add_poo()
					if(M:gloves) M:gloves.add_poo()
					if(M:head) M:head.add_poo()
					user << "You smear the poo all over [M]!"
					M << "[user] smears poo all over you! Eww!"
					del(src)
					return
			if(M == user)								//If you're eating it yourself.
				var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
				if (fullness <= 50)
					M << "\red You hungrily chew out a piece of [src] and gobble it!"
				if (fullness > 50 && fullness <= 150)
					M << "\blue You hungrily begin to eat [src]."
				if (fullness > 150 && fullness <= 350)
					M << "\blue You take a bite of [src]."
				if (fullness > 410 && fullness <= 550)
					M << "\blue You are full."
					return 0
				/*if (fullness > (550 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
					M << "\red You cannot force any more of [src] to go down your throat."
					return 0*/
			else										//If you're feeding it to someone else.
				var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
				if (fullness <= (550 * (1 + M.overeatduration / 1000)))
					for(var/mob/O in viewers(world.view, user))
						O.show_message("\red [user] attempts to feed [M] [src].", 1)
				else
					for(var/mob/O in viewers(world.view, user))
						O.show_message("\red [user] cannot force anymore of [src] down [M]'s throat.", 1)
						return 0

				if(!do_mob(user, M)) return

				M.attack_log += text("[] <b>[]/[]</b> feeds <b>[]/[]</b> with <b>[]</b>", world.time, user, user.client, M, M.client, src)
				user.attack_log += text("[] <b>[]/[]</b> feeds <b>[]/[]</b> with <b>[]</b>", world.time, user, user.client, M, M.client, src)

				for(var/mob/O in viewers(world.view, user))
					O.show_message("\red [user] feeds [M] [src].", 1)
			if(reagents)								//Handle ingestion of the reagent.
				if(reagents.total_volume)
					reagents.reaction(M, INGEST)
					spawn(5)
						if(reagents.total_volume > bitesize)
							var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
							reagents.trans_to(M, temp_bitesize)
						else
							reagents.trans_to(M, reagents.total_volume)
						bitecount++
						if(!R.total_volume || !R)
							user << "\red None of [src] left, oh no!"
							if(src.create_trash && !src.istrash)
								src.icon_state = "[src.icon_state]_trash"
								src.istrash = 1
							if(src.istrash)
								return
							return
						if(M == user)
							user << "\red You finish eating [src]."
							//user << "\blue It tastes [src.eatmessage]!"
						else
							user << "\red [M] finishes eating [src]."
						On_Consume()
						spawn(1)
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
			spawn(rand(15000,50000))
				src.desc = "<BR><font color=\"red\">It seems expired, yuck! You should probably throw this away.</font>"
				reagents.add_reagent("bad_bacteria", 5)
				src.overlays += icon('effects.dmi', "flies")
				canexpire = 0
		spawn(300)
			expirefood() //check again, just in case

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

		if(!R.total_volume || !R)
			user << "\red None of [src] left, oh no!"
			if(src.create_trash && !src.istrash)
				src.icon_state = "[src.icon_state]_trash"
				src.istrash = 1
			if(src.istrash)
				return
			return 0
		if(M == user)
			M << "\blue You swallow a gulp of [src]."
			if(reagents.total_volume)
				reagents.reaction(M, INGEST)
				spawn(5)
					reagents.trans_to(M, gulp_size)

			playsound(M.loc,'drink.ogg', rand(10,50), 1)
			return 1
		else if( istype(M, /mob/living) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

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
				if(src.create_trash && !src.istrash)
					src.icon_state = "[src.icon_state]_trash"
					src.istrash = 1
				if(src.istrash)
					return
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

/obj/item/weapon/reagent_containers/glass/canister
	desc = "It's a canister. Mainly used for transporting fuel."
	name = "canister"
	icon = 'tank.dmi'
	icon_state = "canister"
	item_state = "canister"
	m_amt = 300
	g_amt = 0
	w_class = 4.0

	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60)
	volume = 120
	flags = FPRINT

/obj/item/weapon/reagent_containers/glass/dispenser
	name = "reagent glass"
	desc = "A reagent glass."
	icon = 'chemical.dmi'
	icon_state = "beaker"
	amount_per_transfer_from_this = 10
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

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "beaker0")
				src.icon_state = "beakercolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/beakerc = new/icon("icon" = 'chemical.dmi', "icon_state" = "beakercolormod")
				beakerc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "beaker0"



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
	desc = "A large reagent glass."
	icon = 'chemical.dmi'
	icon_state = "beakerlarge"
	item_state = "beaker"
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30,50)

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "beakerlarge")
				src.icon_state = "beakerlargecolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/beakerlc = new/icon("icon" = 'chemical.dmi', "icon_state" = "beakerlargecolormod")
				beakerlc.Blend(rgb(src.main_reagent:color_r, src.main_reagent:color_g, src.main_reagent:color_b), ICON_ADD)
				src.overlays += beakerlc
				src.main_reagent = ""
		else
			src.main_reagent = ""
			src.overlays = null
			icon_state = "beakerlarge"

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

	on_reagent_change()
		if(reagents.total_volume)
			if (src.icon_state == "bottle0")
				src.icon_state = "bottlecolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/bottlec = new/icon("icon" = 'chemical.dmi', "icon_state" = "bottlecolormod")
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
			if (src.icon_state == "bottlesmall0")
				src.icon_state = "bottlesmallcolor"
				src.main_reagent = src.reagents.get_master_reagent_reference()
				var/icon/bottlec = new/icon("icon" = 'chemical.dmi', "icon_state" = "bottlesmallcolormod")
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
	desc = "A small bottle. Contains Corophizine."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("corophizine", 30)

/obj/item/weapon/reagent_containers/glass/bottle/chloromydride
	name = "Chloromydride bottle"
	desc = "A small bottle. Contains chloromydride."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("chloromydride", 30)


/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("inaprovaline", 30)


/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("toxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'

	New()
		..()
		reagents.add_reagent("cyanide", 30)

/obj/item/weapon/reagent_containers/glass/bottle/jenkem
	name = "jenkem bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'


	New()
		..()
		reagents.add_reagent("jenkem", 30)

/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "sleep-toxin bottle"
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
		reagents.add_reagent("chloralhydrate", 15)		//Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "anti-toxin bottle"
	desc = "A small bottle."
	icon = 'chemical.dmi'
	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("anti_toxin", 30)

/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
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

/obj/item/weapon/reagent_containers/glass/bottle/flu_virion
	name = "Flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/flu(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/bird_flu_virion
	name = "Bird flu virion culture bottle"
	desc = "A small bottle. Contains bird flu virion culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/birdflu(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/swine_flu_virion
	name = "Swine flu virion culture bottle"
	desc = "A small bottle. Contains swine flu virion culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/swineflu(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/cold
	name = "Common cold culture bottle"
	desc = "A small bottle. Contains common cold virion culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/cold(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/biomorph
	name = "biomorph"
	desc = "biomorph."//Or simply - General BullShit
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5

	New()
		..()
		reagents.add_reagent("biomorph", 30)


/obj/item/weapon/reagent_containers/glass/bottle/beesease
	name = "Beesease culture bottle"
	desc = "A small bottle. Contains Beesease an extremely dangerous new viral agent."//Or simply - General BullShit
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/beesease(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/fake_gbs(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/plague
	name = "Plague culture bottle"
	desc = "A small bottle. Contains a small dosage of Black Death."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/plague(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/gayvirus
	name = "Gay Virus culture bottle"
	desc = "A small bottle. Contains a small dosage of Gay Virus."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/gay(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/tvirus
	name = "Tyrant Virus culture bottle"
	desc = "A small bottle. Contains a small dosage of Tyrant Virus."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/tvirus(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/donkvirus
	name = "Donk Virus culture bottle"
	desc = "A small bottle. Contains a small dosage of Donk Virus."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/donkvirus(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/mochashakah
	name = "Monaco Shake culture bottle"
	desc = "A small bottle. Contains a small dosage of Monaco Shake."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/mochashakah(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)



/obj/item/weapon/reagent_containers/glass/bottle/startrekkin
	name = "Monaco Shake culture bottle"
	desc = "A small bottle. Contains a small dosage of Monaco Shake."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/startrekkin(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/clowningaround
	name = "Clowning around culture bottle"
	desc = "A small bottle. Contains a small dosage of clowning around."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/clowning_around(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/birdflu
	name = "Bird Flu culture bottle"
	desc = "A small bottle. Contains a small dosage of Bird Flu."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/birdflu(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/swineflu
	name = "Swine Flu culture bottle"
	desc = "A small bottle. Contains a small dosage of Swine Flu."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/swineflu(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/alzheimers
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains a small dosage of Brainrot."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/alzheimers(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/inhalational_anthrax
	name = "Inhalational Anthrax culture bottle"
	desc = "A small bottle. Contains a small dosage of Inhalational Anthrax."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/inhalational_anthrax(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/ebola
	name = "Ebola culture bottle"
	desc = "A small bottle. Contains a small dosage of Ebola."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/ebola(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/brainrot
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/brainrot(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/magnitis
	name = "Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/magnitis(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/wizarditis
	name = "Wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	icon = 'chemical.dmi'

	amount_per_transfer_from_this = 5
	New()
		..()
		var/datum/disease/F = new /datum/disease/wizarditis(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	name = "beaker"
	desc = "A beaker. Can hold up to 30 units."
	icon = 'chemical.dmi'
	icon_state = "beaker0"
	item_state = "beaker"

	New()
		..()
		reagents.add_reagent("cryoxadone", 30)

/obj/item/weapon/reagent_containers/glass/virusdish
	name = "Virus containment/growth dish"
	icon = 'items.dmi'
	icon_state = "petridish"
	var/datum/disease2/disease/virus2 = null
	var/growth = 0
	var/info = 0
	var/analysed = 0

/obj/item/weapon/reagent_containers/glass/virusdish/attackby(var/obj/item/weapon/W as obj,var/mob/living/carbon/user as mob)
	if(istype(W,/obj/item/weapon/hand_labeler))
		return
	..()
	if(prob(50))
		user << "The dish shatters"
//		if(virus2.infectionchance > 0)
//			infect_virus2(user,virus2)
		del src

/obj/item/weapon/reagent_containers/glass/virusdish/examine()
	usr << "This is a virus containment dish"
	if(src.info)
		usr << "It has the following information about its contents"
		usr << src.info


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

//CIGARETTES BY ERIKAT

/obj/item/weapon/reagent_containers/cigs/
	name = "rolling paper"
	desc = "Rolling paper for a cigarette."
	icon = 'items.dmi'
	icon_state = "rollingpaper"
	throw_speed = 0.5
	volume = 15
	item_state = "cigoff"
	w_class = 1
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/vchange = 0
	var/lit = 0
	var/lastHolder = null
	var/smoketime = 400
	New()
		..()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

	on_reagent_change()
		if (reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("tobacco")
					if(src.lit == 1)
						icon_state = "cigon"
					else
						icon_state = "cigoff"
					name = "tobacco cigarette"
					desc = "A tobacco, contains nasty addictive stuff."
				if("thc")
					if(src.lit == 1)
						icon_state = "cigon"
					else
						icon_state = "cigoff"
					name = "marijuana cigarette"
					desc = "A marijuana cigarette."
				else
					if(src.lit == 1)
						icon_state = "cigon"
					else
						icon_state = "cigoff"
					name = "cigarette"
					desc = "A cigarette"
		else
			icon_state = "rollingpaper"
			name = "rolling paper"
			desc = "Rolling paper for a cigarette."
			return


/obj/item/weapon/reagent_containers/cigs/attack(mob/M as mob, mob/user as mob)
	if(src.lit == 1)
		if (!( istype(M, /mob) ))
			return
		if (reagents.total_volume)
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [M] takes a puff from [src].", 3)
			src.smoketime--
			src.reagents.reaction(M, INGEST)
			if(M.reagents)
				reagents.trans_to(M, 3)
				if(reagents.total_volume <= 0)
					src.smoketime = 1
		return
	else
		M << "\red You try to take a puff from [src] but realise it's not lit!"

//ALL THE CIGARETTE VARIATIONS AS OF NOW

/obj/item/weapon/reagent_containers/cigs/cigarette
	name = "tobacco cigarette"
	desc = "A tobacco, contains nasty addictive stuff."
	New()
		..()
		reagents.add_reagent("tobacco", 13)
		reagents.add_reagent("nicotine", 2)

/obj/item/weapon/reagent_containers/cigs/cannabis
	name = "marijuana cigarette"
	desc = "A marijuana cigarette."
	New()
		..()
		reagents.add_reagent("thc", 15)


/obj/item/weapon/reagent_containers/cigs/medicalcannabis
	name = "medical marijuana cigarette"
	desc = "A medical marijuana cigarette."
	New()
		..()
		reagents.add_reagent("thc", 5)
		reagents.add_reagent("inaprovaline", 5)
		reagents.add_reagent("spaceacillin", 5)

//END CIGARETTES BY ERIKAT

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effects besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effects (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Man, that shit looks good. I bet it's got nougat. Fuck."
	icon_state = "candy"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 8)

/obj/item/weapon/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriment", 7)
		reagents.add_reagent("sprinkles", 1)
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "frosted donut"
			src.bitesize = 2
			reagents.add_reagent("nutriment", 2)
			reagents.add_reagent("sprinkles", 1)

/obj/item/weapon/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

	proc/eggsplat(atom/target)
		new /obj/decal/cleanable/eggsplat(get_turf(src))
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/flour
	name = "flour"
	desc = "Some flour"
	icon_state = "flour"
	New()
		..()
		reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/doughball
	name = "dough blob"
	desc = "The result of combining some water with some flour. Not that good for you, as-is."
	icon_state = "doughball"
	New()
		..()
		reagents.add_reagent("toxin", 2)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/breaddoughball
	name = "bread dough blob"
	desc = "The result of combining some water with some flour, with an egg. Not that good for you, as-is."
	icon_state = "doughball"
	New()
		..()
		reagents.add_reagent("toxin", 2)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/pizzadough
	name = "flattened dough"
	desc = "The first step in the creation of a pizza."
	icon_state = "pizzadough"
	var/sauce = 0
	var/cheese = 0
	var/meat = 0
	var/xenomeat = 0
	New()
		..()
		reagents.add_reagent("toxin", 2)
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/doughball/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/kitchen/rollingpin))
		new /obj/item/weapon/reagent_containers/food/snacks/pizzadough(get_turf(src))
		user << "\blue You flatten out the dough to make a pizza base!"
		del(src)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/egg))
		new /obj/item/weapon/reagent_containers/food/snacks/breaddoughball(get_turf(src))
		user << "\blue You mix an egg into the dough. This is the proper dough for breaded foodstuffs."
		del(W)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/pizzadough/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/tomato))
		del(src)
		src.name = "decorated pizza dough"
		src.overlays += icon('food.dmi', "pizzadough_sauce")
		user << "\blue You smother the pizza dough with a good helping of tomato sauce."
		src.sauce = 1
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/cheesewedge) && src.sauce == 1)
		src.cheese = 1
		src.overlays += icon('food.dmi', "pizzadough_cheese")
		user << "\blue You sprinkle chunks of the cheese wedge onto the pizza."
		src.cheese = 1
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/humanmeat) && src.sauce == 1 && src.cheese == 1 || istype(W, /obj/item/weapon/reagent_containers/food/snacks/monkeymeat) && src.sauce == 1 && src.cheese == 1)
		src.meat = 1
		src.overlays += icon('food.dmi', "pizzadough_meat")
		user << "\blue You lay chunks of the meat onto the pizza."
		src.meat = 1
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/xenomeat) && src.sauce == 1 && src.cheese == 1)
		src.xenomeat = 1
		src.overlays += icon('food.dmi', "pizzadough_xenomeat")
		user << "\blue You lay chunks of the meat onto the pizza."
		src.xenomeat = 1


/obj/item/weapon/reagent_containers/food/snacks/undecoratedpizza
	name = "cooked pizza dough"
	desc = "Might as well just have a tortilla. Sheesh."
	icon_state = "pizzadough_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 5)

/obj/item/weapon/reagent_containers/food/snacks/saucepizza
	name = "sauce pizza"
	desc = "Toppings? Who needs 'em!"
	icon_state = "saucepizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/cheesepizza
	name = "cheese pizza"
	desc = "A rather plain, yet elegant pizza."
	icon_state = "cheese_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 13)

/obj/item/weapon/reagent_containers/food/snacks/meatpizza
	name = "meat pizza"
	desc = "A traditional pizza featuring both red meat, and cheese."
	icon_state = "meat_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 14)

/obj/item/weapon/reagent_containers/food/snacks/xenomeatpizza
	name = "xeno-meat pizza"
	desc = "A pizza fulfilling the needs of the adventurous meat connoisseur."
	icon_state = "xenomeat_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 14)

/obj/item/weapon/reagent_containers/food/snacks/meatloverspizza
	name = "mixed-meat pizza"
	desc = "The choice pizza of the station's meat lovers."
	icon_state = "meatlovers_pizza_cooked"
	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/weapon/reagent_containers/food/snacks/humanmeat
	name = "-meat"
	desc = "A slab of meat"
	icon_state = "meat"
	var/subjectname = ""
	var/subjectjob = null
	New()
		..()
		reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/faggot
	name = "faggot"
	desc = "A great meal all round. Not a cord of wood."
	icon_state = "faggot"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	name = "donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 7)
	var/warm = 0
	proc/cooltime() //Not working, derp?
		if (src.warm)
			spawn( 4200 )
				src.warm = 0
				src.reagents.del_reagent("tricordrazine")
				src.name = "donk-pocket"
		return

/obj/item/weapon/reagent_containers/food/snacks/humanburger
	name = "-burger"
	var/hname = ""
	var/job = null
	desc = "A bloody burger."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriment", 13)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/assburger
	name = "assburger"
	desc = "This burger gives off an air of awkwardness."
	icon_state = "assburger"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/poo
	name = "poo"
	desc = "It's a poo..."
	icon = 'poop.dmi'
	icon_state = "poop2"
	item_state = "poop"
	random_icon_states = list("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")
	New()
		..()
		icon_state = pick(random_icon_states)
		reagents.add_reagent("poo", 6)
		reagents.add_reagent("nutriment", 6)
		bitesize = 3

	proc/poosplat(atom/target)
		if(reagents.total_volume)
			if(ismob(target))
				src.reagents.reaction(target, TOUCH)
			if(isturf(target))
				src.reagents.reaction(get_turf(target))
			if(isobj(target))
				src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		playsound(src.loc, "squish.ogg", 40, 1)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/faileddish
	name = "Failed Dish"
	desc = "I can't even tell what somebody tried to cook to make this..."
	icon_state = "faileddish"
	New()
		..()
		reagents.add_reagent("poo", 1)
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	var/herp = 0
	New()
		..()
		reagents.add_reagent("nutriment", 11)
		bitesize = 1
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/weapon/kitchen/utensil/fork))
			if (W.icon_state == "forkloaded")
				user << "\red You already have omelette on your fork."
				return
			W.icon = 'kitchen.dmi'
			W.icon_state = "forkloaded"
			if (herp)
				world << "[user] takes a piece of omelette with their fork!"
			else
				viewers(3,user) << "[user] takes a piece of omelette with their fork!"
			reagents.remove_reagent("nutriment", 1)
			if (reagents.total_volume <= 0)
				del(src)



/obj/item/weapon/reagent_containers/food/snacks/omeletteforkload
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
/obj/item/weapon/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("nanites", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like mechanical poison. Beep."
	icon_state = "roburger"
	volume = 100
	New()
		..()
		reagents.add_reagent("nanites", 100)
		bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic."
	icon_state = "xburger"
	New()
		..()
		reagents.add_reagent("xenomicrobes", 10)
		reagents.add_reagent("nutriment", 6)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/monkeymeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	New()
		..()
		reagents.add_reagent("nutriment", 7)

/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("carpotoxin", 3)

/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/pie
	name = "custard pie"
	desc = "It smells delicious. You just want to plant your face in it."
	icon_state = "pie"
	New()
		..()
		reagents.add_reagent("nutriment", 12)

/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	New()
		..()
		reagents.add_reagent("nutriment", 13)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/jellydonut
	name = "Jelly Donut"
	desc = "Oh so gooey on the inside."
	icon_state = "donut1" //Placeholder until I stop being lazy. ie. Never. -- Darem
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("sprinkles", 3)
		bitesize = 2
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("sprinkles", 3)
			bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/pudding_pop
	name = "pudding pop"
	desc = "A pudding-flavored popsicle."
	icon_state = "puddingpop"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 7)

/obj/item/weapon/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotcake
	name = "Carrot Cake"
	desc = "Delicious and nutritious!"
	icon_state = "carrotcake"
	New()
		..()
		reagents.add_reagent("nutriment", 15)
		reagents.add_reagent("imidazoline", 10)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the [src]! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes!"
	icon_state = "carrotcake_slice"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("imidazoline", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the [src]! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	New()
		..()
		reagents.add_reagent("nutriment", 25)
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the [src]! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/plaincakeslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/humeatpie
	name = "Meat-pie"
	var/hname = ""
	var/job = null
	icon_state = "meatpie"
	desc = "A delicious meatpie."
	New()
		..()
		reagents.add_reagent("nutriment", 15)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/momeatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "A delicious meatpie."
	New()
		..()
		reagents.add_reagent("nutriment", 13)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A deliciously caustic-looking meatpie."
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 4
		reagents.add_reagent("xenomicrobes", 12)

/obj/item/weapon/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("xenomicrobes", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chaosdonut
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "Frosted Chaos Donut"
		var/temp_chaos = pick(1, 2, 3)
		if(temp_chaos == 1)
			reagents.add_reagent("capsaicin", 3)
		else if(temp_chaos == 2)
			reagents.add_reagent("frostoil", 3)
		else if(temp_chaos == 3)
			reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/humankabob
	name = "-kabob"
	var/hname = ""
	var/job = null
	icon_state = "kabob"
	desc = "A delicious kabob"
	New()
		..()
		reagents.add_reagent("nutriment", 9)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "A delicious kabob"
	New()
		..()
		reagents.add_reagent("nutriment", 7)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 7)

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	New()
		..()
		reagents.add_reagent("sugar", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	New()
		..()
		reagents.add_reagent("nutriment", 7)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("syndicream", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc"
	icon_state = "fries"
	New()
		..()
		reagents.add_reagent("nutriment", 13)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	New()
		..()
		reagents.add_reagent("nutriment", 13)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	New()
		..()
		reagents.add_reagent("nutriment", 7)
//		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
//		var/list/data = list("virus"= F)
//		reagents.add_reagent("blood", 4, data)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "It's taste defies language."
	icon_state = "mimeburger"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("carpotoxin", 3)
		reagents.add_reagent("capsaicin", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/popcorn
	name = "Popcorn" //not a typo
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 0.1 //this snack is supposed to be eating during looooong time.

/obj/item/weapon/reagent_containers/food/snacks/fishburger
	name = "Carpburger"
	desc = "Nanotracen: wasting rare ingridients for fastfood since 2548"
	icon_state = "fishburger"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

/obj/item/weapon/reagent_containers/food/snacks/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the meatbread! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice (src.loc)
			del(src)
			return
		if(istype(W, /obj/item/weapon/circular_saw))
			W.visible_message(" \red <B>You spastically slice the meatbread with your [W]! </B>", 1)
			for(var/i=0,i<3,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman. Extra Heretical."
	icon_state = "xenomeatbread"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("xenomicrobes", 35)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the xenomeatbread! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice (src.loc)
			del(src)
			return
		if(istype(W, /obj/item/weapon/circular_saw))
			W.visible_message(" \red <B>You spastically slice the xenomeatbread with your [W]! </B>", 1)
			for(var/i=0,i<3,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("xenomicrobes", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "tofubread" //filler sprite till there is a banana bread sprite
	New()
		..()
		reagents.add_reagent("banana", 20)
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the banana bread! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/bananabreadslice (src.loc)
			del(src)
			return
		if(istype(W, /obj/item/weapon/circular_saw))
			W.visible_message(" \red <B>You inaccurately slice the banana bread with your [W]! </B>", 1)
			for(var/i=0,i<3,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/bananabreadslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	name = "banana-nut bread slice"
	desc = "A slice of delicious Banana bread."
	icon_state = "tofubreadslice" //Filler sprite
	New()
		..()
		reagents.add_reagent("banana", 7)
		reagents.add_reagent("nutriment", 7)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegans. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /*|| /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B>You slice the tofubread! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice (src.loc)
			del(src)
			return
		if(istype(W, /obj/item/weapon/circular_saw))
			W.visible_message(" \red <B>You spastically slice the tofubread with your [W]! </B>", 1)
			for(var/i=0,i<3,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	New()
		..()
		reagents.add_reagent("nutriment", 25)
		bitesize = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/kitchenknife /* || /obj/item/weapon/scalpel*/))
			W.visible_message(" \red <B> You slice the cheese! </B>", 1)
			for(var/i=0,i<5,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/cheesewedge (src.loc)
			del(src)
			return
		if(istype(W, /obj/item/weapon/circular_saw))
			W.visible_message(" \red <B>You spastically slice the cheese with your [W]! </B>", 1)
			for(var/i=0,i<3,i++)
				new /obj/item/weapon/reagent_containers/food/snacks/cheesewedge (src.loc)
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/banana
	name = "Banana"
	desc = "A banana."
	icon = 'items.dmi'
	icon_state = "banana"
	item_state = "banana"
	On_Consume()
		var/mob/M = usr
		var/obj/item/weapon/bananapeel/W = new /obj/item/weapon/bananapeel( M )
		M << "\blue You peel the banana."
		M.put_in_hand(W)
		W.add_fingerprint(M)
	New()
		..()
		reagents.add_reagent("banana", 5)
		bitesize = 5
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

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
		else if( istype(M, /mob/living) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

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
	New()
		..()
		reagents.add_reagent("milk", 50)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "SoyMilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	New()
		..()
		reagents.add_reagent("soymilk", 50)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("coffee", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("ice", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "tea"
	New()
		..()
		reagents.add_reagent("h_chocolate", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your shcool years."
	icon_state = "coffee"
	New()
		..()
		reagents.add_reagent("dry_ramen", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/cola
	name = "Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	New()
		..()
		reagents.add_reagent("cola", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Long Moo Tea"
	desc = "The perfect tea for those who enjoy life's simple pleasures."
	icon_state = "tea"
	New()
		..()
		reagents.add_reagent("tea", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/beer
	name = "Space Beer"
	desc = "Beer. In space."
	icon_state = "beer"
	create_trash = 1
	New()
		..()
		reagents.add_reagent("beer", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	New()
		..()
		reagents.add_reagent("ale", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/space_mountain_wind
	name = "Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	New()
		..()
		reagents.add_reagent("spacemountainwind", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/thirteenloko
	name = "Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsably."
	icon_state = "thirteen_loko"
	New()
		..()
		reagents.add_reagent("thirteenloko", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/dr_gibb
	name = "Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	New()
		..()
		reagents.add_reagent("dr_gibb", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/starkist
	name = "Star-kist"
	desc = "The taste of a star in liquid form."
	icon_state = "starkist"
	New()
		..()
		reagents.add_reagent("cola", 15)
		reagents.add_reagent("orangejuice", 15)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/space_up
	name = "Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	New()
		..()
		reagents.add_reagent("space_up", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/sillycup
	name = "Paper Cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	New()
		..()
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)
	on_reagent_change()
		if(reagents.total_volume)
			icon_state = "water_cup"
		else
			icon_state = "water_cup_e"

///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
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
		reagents.add_reagent("gin", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Whiskey"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	New()
		..()
		reagents.add_reagent("whiskey", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka
	name = "Russian Standard Vodka"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	New()
		..()
		reagents.add_reagent("vodka", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality Tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	New()
		..()
		reagents.add_reagent("tequilla", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/rum
	name = "Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	New()
		..()
		reagents.add_reagent("rum", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	New()
		..()
		reagents.add_reagent("vermouth", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liquour"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	New()
		..()
		reagents.add_reagent("kahlua", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	New()
		..()
		reagents.add_reagent("cognac", 100)

/obj/item/weapon/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	New()
		..()
		reagents.add_reagent("wine", 100)

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

	New()
		..()
		reagents.add_reagent("anti_toxin", 50)

/obj/item/weapon/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."

	New()
		..()
		reagents.add_reagent("toxin", 50)

/obj/item/weapon/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."

	New()
		..()
		reagents.add_reagent("cyanide", 50)

/obj/item/weapon/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."


	New()
		..()
		reagents.add_reagent("stoxin", 30)

/obj/item/weapon/reagent_containers/pill/dexalinp
	name = "Dexalin-P pill"
	desc = "Very effective for patients who have suffered major oxygen deprivation."


	New()
		..()
		reagents.add_reagent("dexalinp", 30)

/obj/item/weapon/reagent_containers/pill/space_drugs
	name = "Space Drugs pill"
	desc = "Very addictive and enjoyable drug. Illegal in most systems."


	New()
		..()
		reagents.add_reagent("space_drugs", 30)

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
		reagents.add_reagent("orlistat", 30)

/obj/item/weapon/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."


	New()
		..()
		reagents.add_reagent("kelotane", 30)

/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."


	New()
		..()
		reagents.add_reagent("inaprovaline", 30)

/obj/item/weapon/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."


	New()
		..()
		reagents.add_reagent("dexalin", 30)

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

/obj/reagent_dispensers/foamtank
	name = "foamtank"
	desc = "A foamtank"
	icon = 'objects.dmi'
	icon_state = "foamtank"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("fluorosurfactant",1000)

/obj/reagent_dispensers/watertank/drinkingfountain
	name = "water cooler"
	desc = "A water cooler"
	icon = 'objects.dmi'
	icon_state = "drinkingfountain"
	amount_per_transfer_from_this = 10
	anchored = 1

	New()
		..()
		reagents.add_reagent("water",1000)

	attack_hand(var/mob/user as mob)
		user.show_message(text("\red you need a drinking glass"))

/obj/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fueltank"
	icon = 'objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("fuel",1000)

/obj/reagent_dispensers/fueltank/blob_act()
	explosion(src.loc,0,1,5,7,10)
	if(src)
		del(src)

/obj/reagent_dispensers/fueltank/ex_act()
	explosion(src.loc,-1,0,2)
	if(src)
		del(src)

/obj/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink"
	amount_per_transfer_from_this = 5
	icon = 'vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	New()
		..()
		anchored = 1
		reagents.add_reagent("water",500)


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

/obj/reagent_dispensers/radiumcanister
	name = "radium canister"
	desc = "A large drum of radium"
	icon = 'atmos.dmi'
	icon_state = "radium"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("radium",1000)


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

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 10
	volume = 50

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
			O.show_message(text("\red The [] shatters!", src), 1)
		new /obj/decal/cleanable/generic(get_turf(src))
		new /obj/item/weapon/shard(get_turf(src))
		del(src)

	on_reagent_change()
/*		if(reagents.reagent_list.len > 1 )
			icon_state = "glass_brown"
			name = "Glass of Hooch"
			desc = "Two or more drinks, mixed together."
		else if(reagents.reagent_list.len == 1)
			for(var/datum/reagent/R in reagents.reagent_list)
				switch(R.id)*/
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
					desc = "Damn, the barman even stirred it, not shook it."
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
				if("longislandicedtea")
					icon_state = "longislandicedteaglass"
					name = "Long Island Iced Tea"
					desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
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
					name = "Glass berry joice"
					desc = "Berry juice. Or maybe its jam. Who knows?"
				else
					icon_state ="glass_brown"
					name = "Glass of ..what?"
					desc = "You can't really tell what this is."
		else
			icon_state = "glass_empty"
			name = "Drinking glass"
			desc = "Your standard drinking glass"
			return

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
