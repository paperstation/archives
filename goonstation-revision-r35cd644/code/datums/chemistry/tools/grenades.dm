
/* ================================================== */
/* -------------------- Grenades -------------------- */
/* ================================================== */

/obj/item/chem_grenade
	name = "metal casing"
	icon_state = "chemg1"
	icon = 'icons/obj/chemical.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	item_state = "flashbang"
	w_class = 2.0
	force = 2.0
	var/stage = 0
	var/state = 0
	var/list/beakers = new/list()
	throw_speed = 4
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT | EXTRADELAY | NOSPLASH
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 0

	New()
		var/datum/reagents/R = new/datum/reagents(150000)
		reagents = R
		R.my_atom = src

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W,/obj/item/grenade_fuse) && !stage)
			boutput(user, "<span style=\"color:blue\">You add [W] to the metal casing.</span>")
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
			qdel(W) //Okay so we're not really adding anything here. cheating.
			icon_state = "chemg2"
			name = "unsecured grenade"
			stage = 1
		else if (istype(W,/obj/item/screwdriver) && stage == 1)
			if (beakers.len)
				boutput(user, "<span style=\"color:blue\">You lock the assembly.</span>")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
				name = "grenade"
				icon_state = "chemg3"
				stage = 2
			else
				boutput(user, "<span style=\"color:red\">You need to add at least one beaker before locking the assembly.</span>")
		else if (istype(W,/obj/item/reagent_containers/glass) && stage == 1)
			if (istype(W,/obj/item/reagent_containers/glass/beaker/large))
				boutput(user, "<span style=\"color:red\">This beaker is too large!</span>")
				return
			if (beakers.len == 2)
				boutput(user, "<span style=\"color:red\">The grenade can not hold more containers.</span>")
				return
			else
				if (W.reagents.total_volume)
					boutput(user, "<span style=\"color:blue\">You add \the [W] to the assembly.</span>")
					user.drop_item()
					W.set_loc(src)
					beakers += W
				else
					boutput(user, "<span style=\"color:red\">\the [W] is empty.</span>")
		else if (stage == 2 && (istype(W, /obj/item/assembly/rad_ignite) || istype(W, /obj/item/assembly/prox_ignite) || istype(W, /obj/item/assembly/time_ignite)))
			var/obj/item/assembly/S = W
			if (!S || !S:status)
				return
			boutput(user, "<span style=\"color:blue\">You attach the [src.name] to the [S.name]!</span>")
			logTheThing("bombing", user, null, "made a chemical bomb with a [S.name].")
			message_admins("[key_name(user)] made a chemical bomb with a [S.name].")

			var/obj/item/assembly/chem_bomb/R = new /obj/item/assembly/chem_bomb( user )
			R.attacher = key_name(user)

			switch(S:part1.type)
				if (/obj/item/device/timer)
					R.desc = "A very intricate igniter and timer assembly mounted to a chem grenade."
					R.name = "Timer/Igniter/Chem Grenade Assembly"
				if (/obj/item/device/prox_sensor)
					R.desc = "A very intricate igniter and proximity sensor electrical assembly mounted to a chem grenade."
					R.name = "Proximity/Igniter/Chem Grenade Assembly"
				if (/obj/item/device/radio/signaler)
					R.desc = "A very intricate igniter and signaller electrical assembly mounted to a chem grenade."
					R.name = "Radio/Igniter/Chem Grenade Assembly"

			R.triggering_device = S:part1
			R.c_state(0)
			S:part1.set_loc(R)
			S:part1.master = R
			R.igniter = S:part2
			R.igniter.status = 1
			S:part2.set_loc(R)
			S:part2.master = R
			S.layer = initial(S.layer)
			user.u_equip(S)
			user.put_in_hand_or_drop(R)
			src.master = R
			src.layer = initial(src.layer)
			user.u_equip(src)
			src.set_loc(R)
			R.payload = src
			S:part1 = null
			S:part2 = null
			//S = null
			qdel(S)

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if (get_dist(user, target) <= 1 || (!isturf(target) && !isturf(target.loc)) || !isturf(user.loc))
			return
		if (src.stage == 2 && (user.equipped() == src))
			if (!src.state)

				// Custom grenades only. Metal foam etc grenades cannot be modified (Convair880).
				var/log_reagents = null
				if (src.name == "grenade")
					for (var/obj/item/reagent_containers/glass/G in src.beakers)
						if (G.reagents.total_volume) log_reagents += "[log_reagents(G)] "
				message_admins("[log_reagents ? "Custom grenade" : "Grenade ([src])"] primed at [log_loc(src)] by [key_name(user)].")
				logTheThing("combat", user, null, "primes a [log_reagents ? "custom grenade" : "grenade ([src.type])"] at [log_loc(user)].[log_reagents ? " [log_reagents]" : ""]")

				boutput(user, "<span style=\"color:red\">You prime the grenade! 3 seconds!</span>")
				src.state = 1
				src.icon_state = "chemg4"
				playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
				spawn(30)
					if (src) explode()
			user.drop_item()
			src.throw_at(get_turf(target), 10, 3)

	attack_self(mob/user as mob)
		if (!src.state && stage == 2)
			if (!isturf(user.loc))
				return

			// Ditto (Convair880).
			var/log_reagents = null
			if (src.name == "grenade")
				for (var/obj/item/reagent_containers/glass/G in src.beakers)
					if (G.reagents.total_volume) log_reagents += "[log_reagents(G)] "
			message_admins("[log_reagents ? "Custom grenade" : "Grenade ([src])"] primed at [log_loc(src)] by [key_name(user)].")
			logTheThing("combat", user, null, "primes a [log_reagents ? "custom grenade" : "grenade ([src.type])"] at [log_loc(user)].[log_reagents ? " [log_reagents]" : ""]")

			boutput(user, "<span style=\"color:red\">You prime the grenade! 3 seconds!</span>")
			src.state = 1
			src.icon_state = "chemg4"
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
			spawn(30)
				if (src) explode()

	attack_hand()
		walk(src,0)
		return ..()

	proc
		explode()
			var/has_reagents = 0
			for (var/obj/item/reagent_containers/glass/G in beakers)
				if (G.reagents.total_volume) has_reagents = 1

			if (!has_reagents)
				playsound(src.loc, 'sound/items/Screwdriver2.ogg', 50, 1)
				state = 0
				return

			playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)

			for (var/obj/item/reagent_containers/glass/G in beakers)
				G.reagents.trans_to(src, G.reagents.total_volume)

			if (src.reagents.total_volume) //The possible reactions didnt use up all reagents.
				var/datum/effects/system/steam_spread/steam = unpool(/datum/effects/system/steam_spread)
				steam.set_up(10, 0, get_turf(src))
				steam.attach(src)
				steam.start()
				var/min_dispersal = src.reagents.get_dispersal()
				for (var/atom/A in range(min_dispersal, get_turf(src.loc)))
					if ( A == src ) continue
					src.reagents.grenade_effects(src, A)
					src.reagents.reaction(A, 1, 10)

			invisibility = 100 //Why am i doing this?
			if (src.master) src.master.invisibility = 100
			spawn(50)		   //To make sure all reagents can work
				if (src.master) qdel(src.master)
				if (src) qdel(src)	   //correctly before deleting the grenade.

/obj/item/grenade_fuse
	name = "grenade fuse"
	desc = "A fuse mechanism with a safety lever."
	icon = 'icons/obj/items.dmi'
	icon_state = "grenade_fuse"
	item_state = "pen"
	force = 0
	w_class = 1
	m_amt = 100

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

// Order matters. Water resp. the final smoke ingredient should always be the last reagent added to the beaker.
// If it's not, the foam resp. smoke reaction occurs prematurely without carrying the target reagents with them.

/obj/item/chem_grenade/metalfoam
	name = "metal foam grenade"
	desc = "Used for emergency sealing of air breaches."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("aluminium", 30)
		B2.reagents.add_reagent("fluorosurfactant", 10)
		B2.reagents.add_reagent("acid", 10)

		beakers += B1
		beakers += B2

/obj/item/chem_grenade/firefighting
	name = "fire fighting grenade"
	desc = "Can help to put out dangerous fires from a distance."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("ff-foam", 30)
		B2.reagents.add_reagent("ff-foam", 30)

		beakers += B1
		beakers += B2

/obj/item/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 30)
		B2.reagents.add_reagent("cleaner", 10)
		B2.reagents.add_reagent("water", 10)

		beakers += B1
		beakers += B2

/obj/item/chem_grenade/fcleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 10)
		B1.reagents.add_reagent("lube", 10)

		B2.reagents.add_reagent("pacid", 10) //The syndicate are sending the strong stuff now -Spy
		B2.reagents.add_reagent("water", 10)

		beakers += B1
		beakers += B2

/obj/item/chem_grenade/flashbang
	name = "flashbang"
	desc = "A standard stun grenade."
	icon_state = "chemg3"
	stage = 2
	is_syndicate = 1
	mats = 6

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("aluminium", 10)
		B1.reagents.add_reagent("potassium", 10)
		B1.reagents.add_reagent("cola", 10)
		B1.reagents.add_reagent("chlorine", 10)

		B2.reagents.add_reagent("sulfur", 10)
		B2.reagents.add_reagent("oxygen", 10)
		B2.reagents.add_reagent("phosphorus", 10)

		beakers += B1
		beakers += B2

/obj/item/chem_grenade/cryo
	name = "cryo grenade"
	desc = "An experimental non-lethal grenade using cryogenic technologies."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)

		B1.reagents.add_reagent("cryostylane", 35)

		beakers += B1

/obj/item/chem_grenade/incendiary
	name = "incendiary grenade"
	desc = "A rather volatile grenade that creates a small fire."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		B1.reagents.add_reagent("infernite", 20)
		beakers += B1

/obj/item/chem_grenade/very_incendiary
	name = "high range incendiary grenade"
	desc = "A rather volatile grenade that creates a large fire."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		B1.reagents.add_reagent("firedust", 20)
		beakers += B1

/obj/item/chem_grenade/very_incendiary/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/chem_grenade/shock
	name = "shock grenade"
	desc = "An arc flashing grenade that shocks everyone close by."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		B1.reagents.add_reagent("voltagen", 40)
		beakers += B1

/obj/item/chem_grenade/pepper
	name = "crowd dispersal grenade"
	desc = "An non-lethal grenade for use against protests, riots, vagrancy and loitering. Not to be used as a food additive."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("capsaicin", 25)
		B1.reagents.add_reagent("water",25)

		B2.reagents.add_reagent("fluorosurfactant", 25)

		beakers += B1
		beakers += B2

/obj/item/chem_grenade/sarin
	name = "sarin gas grenade"
	desc = "A smoke grenade containing an extremely lethal nerve agent. Use of this mixture constitutes a war crime, so... try not to leave any witnesses."
	icon_state = "chemg3"
	stage = 2

	New()
		..()
		var/obj/item/reagent_containers/glass/B1 = new(src)
		var/obj/item/reagent_containers/glass/B2 = new(src)

		B1.reagents.add_reagent("sarin", 25)
		B1.reagents.add_reagent("sugar",25)

		B2.reagents.add_reagent("phosphorus", 25)
		B2.reagents.add_reagent("potassium", 25)

		beakers += B1
		beakers += B2