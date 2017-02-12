// The misc crap that used to clutter up item.dm and didn't fit elsewhere.

/obj/item/aplate
	name = "armor plates"
	desc = "A bunch of armor plates."
	icon = 'icons/obj/items.dmi'
	icon_state = "armorplate"
	amount = 1
	throwforce = 1
	force = 1
	w_class = 1

/obj/item/gears
	name = "gears"
	desc = "A bunch of gears. Not very useful like this."
	icon = 'icons/obj/items.dmi'
	icon_state = "gears"
	amount = 1
	throwforce = 1
	force = 1
	w_class = 1

/obj/item/lens
	name = "Lens"
	desc = "A lens of some sort. Not super useful on its own."
	icon = 'icons/obj/items.dmi'
	icon_state = "lens"
	amount = 1
	throwforce = 1
	force = 1
	w_class = 1
	var/clarity = 20 //probably somewhere between 0-100 ish
	var/focal_strength = 20 //1-100 ish

	onMaterialChanged()
		..()
		if (istype(src.material))
			clarity = 80 + initial(clarity) - ((src.material.alpha / 255) * 100)
			if(material.hasProperty(PROP_SCATTER)) focal_strength = 80 + initial(focal_strength) - (material.hasProperty(PROP_SCATTER) ? material.getProperty(PROP_SCATTER) : 15)
		return

/obj/item/coil
	desc = "A coil. Not really useful without additional components."
	icon = 'icons/obj/items.dmi'
	amount = 1

	small
		name = "small coil"
		icon_state = "small_coil"
		throwforce = 3
		force = 3
		w_class = 1

	large
		name = "large coil"
		icon_state = "large_coil"
		throwforce = 5
		force = 5
		w_class = 2

/obj/item/gnomechompski
	name = "Gnome Chompski"
	desc = "what"
	icon = 'icons/obj/junk.dmi'
	icon_state = "gnome"
	w_class = 4.0
	stamina_damage = 40
	stamina_cost = 40
	stamina_crit_chance = 5

/obj/item/c_tube
	name = "cardboard tube"
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	throwforce = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5
	desc = "A tube made of cardboard. Extremely non-threatening."
	w_class = 1.0
	stamina_damage = 1
	stamina_cost = 1

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] attempts to beat \himself to death with the cardboard tube, but fails!</b></span>")
		user.suiciding = 0
		return 1

/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'
	mats = 8

/obj/item/dummy
	name = "dummy"
	invisibility = 101.0
	anchored = 1.0
	flags = TABLEPASS
	burn_possible = 0

/*
/obj/item/flasks
	name = "flask"
	icon = 'icons/obj/Cryogenic2.dmi'
	var/oxygen = 0.0
	var/plasma = 0.0
	var/coolant = 0.0

/obj/item/flasks/coolant
	name = "light blue flask"
	icon_state = "coolant-c"
	coolant = 1000.0

/obj/item/flasks/oxygen
	name = "blue flask"
	icon_state = "oxygen-c"
	oxygen = 500.0

/obj/item/flasks/plasma
	name = "orange flask"
	icon_state = "plasma-c"
	plasma = 500.0
*/

/obj/item/rubber_chicken
	name = "Rubber Chicken"
	desc = "A rubber chicken, isn't that hilarious?"
	icon = 'icons/obj/items.dmi'
	icon_state = "rubber_chicken"
	item_state = "rubber_chicken"
	w_class = 2.0
	stamina_damage = 10
	stamina_cost = 10
	stamina_crit_chance = 3

/obj/item/module
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "electronic"
	flags = FPRINT|TABLEPASS|CONDUCT
	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."

/obj/item/module/id_auth
	name = "ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

/obj/item/module/cell_power
	name = "power cell regulator module"
	icon_state = "power_mod"
	desc = "A converter and regulator allowing the use of power cells."

/obj/item/module/cell_power
	name = "power cell charger module"
	icon_state = "power_mod"
	desc = "Charging circuits for power cells."

/obj/item/brick
	name = "brick"
	desc = "A ceramic building block."
	icon = 'icons/misc/aprilfools.dmi'
	icon_state = "brick"
	item_state = "brick"
	w_class = 1
	throwforce = 10
	rand_pos = 1
	stamina_damage = 40
	stamina_cost = 35
	stamina_crit_chance = 5

/obj/item/saxophone
	name = "saxophone"
	desc = "NEVER GONNA DANCE AGAIN, GUILTY FEET HAVE GOT NO RHYTHM"
	icon = 'icons/obj/instruments.dmi'
	icon_state = "sax" // temp
	item_state = "sax"
	w_class = 3
	force = 1
	throwforce = 5
	var/spam_flag = 0
	var/list/sounds_sax = list('sound/items/sax.ogg', 'sound/items/sax2.ogg','sound/items/sax3.ogg','sound/items/sax4.ogg','sound/items/sax5.ogg')
	stamina_damage = 10
	stamina_cost = 10
	stamina_crit_chance = 5
	module_research = list("audio" = 7, "metals" = 3)

/obj/item/saxophone/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 5)
		user.visible_message("<B>[user]</B> lays down a [pick("sexy", "sensuous", "libidinous","spicy","flirtatious","salacious","sizzling","carnal","hedonistic")] riff on \his saxophone!")
		playsound(get_turf(src), pick(src.sounds_sax), 50, 1)
		for (var/obj/critter/dog/george/G in range(user,6))
			if (prob(60))
				G.howl()
		src.add_fingerprint(user)
		spawn(100)
			spam_flag = 0
	return


/obj/item/bagpipe
	name = "bagpipe"
	desc = "Almost as much of a windbag as the Captain."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "bagpipe" // temp
	item_state = "bagpipe"
	w_class = 3
	force = 1
	throwforce = 5
	var/spam_flag = 0
	var/list/sounds_bagpipe = list('sound/items/bagpipe.ogg', 'sound/items/bagpipe2.ogg','sound/items/bagpipe3.ogg')
	stamina_damage = 10
	stamina_cost = 10
	stamina_crit_chance = 5
	module_research = list("audio" = 7, "metals" = 3)

/obj/item/bagpipe/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 5)
		user.visible_message("<B>[user]</B> plays a [pick("patriotic", "rowdy", "wee","grand","free","Glaswegian","sizzling","carnal","hedonistic")] tune on \his bagpipe!")
		playsound(get_turf(src), pick(src.sounds_bagpipe), 50, 1)
		for(var/obj/critter/dog/george/G in range(user,6))
			if (prob(60))
				G.howl()
		src.add_fingerprint(user)
		spawn(100)
			spam_flag = 0
	return

#define CHARGE_REQUIRED 10

/obj/item/fiddle
	name = "fiddle"
	icon = 'icons/obj/instruments.dmi'
	icon_state = "fiddle"
	item_state = "fiddle"
	w_class = 3
	var/charge = 0 //A certain level of UNHOLY ENERGY is required to knock out a soul, ok.
	var/fiddling = 0

	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)

		playsound(src.loc, "swing_hit", 50, 1, -1)
		..()

		satanic_home_run(M)

	attack_self(mob/user as mob) //Charge it by FIDDLING IN A SICK MANNER
		if (!fiddling)
			fiddling++
			user.visible_message("<B>[user]</B> lays down a [pick("devilish","hellish","satanic", "enviable")] tune on \his fiddle!")
			//playsound(src.loc, pick(src.sounds_fiddle), 50, 1)
			for(var/obj/critter/dog/george/G in range(user,6))
				if (prob(60))
					G.howl()
			src.add_fingerprint(user)
			spawn(100)
				fiddling = 0

	proc/satanic_home_run(var/mob/living/some_poor_fucker)
		if (!istype(some_poor_fucker) || !some_poor_fucker.mind || charge < CHARGE_REQUIRED)
			return

		charge = 0
		src.icon_state = "fiddle"
		. = get_edge_target_turf(usr, get_dir(usr, some_poor_fucker))
		var/mob/dead/observer/ghost_to_toss = some_poor_fucker.ghostize()
		var/obj/item/reagent_containers/food/snacks/ectoplasm/soul_stuff = new (some_poor_fucker.loc)


		if (istype(ghost_to_toss))
			ghost_to_toss.loc = soul_stuff

		soul_stuff.throw_at(., 10, 1)
		spawn (10)
			if (soul_stuff && ghost_to_toss)
				ghost_to_toss.loc = soul_stuff.loc

		some_poor_fucker.throw_at(., 1, 1)
		some_poor_fucker.weakened += 2

#undef CHARGE_REQUIRED

/obj/item/trumpet
	name = "trumpet"
	desc = "There can be only one first chair."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "trumpet"
	item_state = "trumpet"
	w_class = 3
	force = 1
	throwforce = 5
	var/spam_flag = 0
//	var/list/sounds_trumpet = list('sound/items/trumpet.ogg', 'sound/items/trumpet2.ogg','sound/items/trumpet3.ogg','sound/items/trumpet4.ogg','sound/items/trumpet5.ogg')
	stamina_damage = 10
	stamina_cost = 10
	stamina_crit_chance = 5
	module_research = list("audio" = 7, "metals" = 3)

	attack_self(mob/user as mob)
		if (spam_flag == 1)
			return
		else
			spam_flag = 1
			if (ishuman(user))
				var/mob/living/carbon/human/H = user
				if (H.sims)
					H.sims.affectMotive("fun", 5)
			user.visible_message("<B>[user]</B> plays a [pick("slick", "egotistical", "snazzy", "technical", "impressive")] [pick("riff", "jam", "bar", "tune")] on \his trumpet!")
//			playsound(src.loc, pick(src.sounds_trumpet), 50, 1)
			for(var/obj/critter/dog/george/G in range(user,6))
				if (prob(60))
					G.howl()
			src.add_fingerprint(user)
			spawn(100)
				spam_flag = 0
		return

/obj/item/trumpet/dootdoot
	name = "spooky trumpet"
	desc= "Talk dooty to me."
	icon_state = "doot"
	item_state = "doot"

/obj/item/trumpet/dootdoot/proc/dootize(var/mob/living/carbon/human/S)
	if (istype(S.mutantrace, /datum/mutantrace/skeleton))
		S.visible_message("<span style=\"color:blue\"><b>[S.name]</b> claks in appreciation!</span>")
		playsound(S.loc, "sound/items/Scissor.ogg", 50, 0)
		return
	else
		S.visible_message("<span style=\"color:red\"><b>[S.name]'s skeleton rips itself free upon hearing the song of its people!</b></span>")
		if (S.gender == "female")
			playsound(get_turf(S), 'sound/voice/female_fallscream.ogg', 50, 0)
		else
			playsound(get_turf(S), 'sound/voice/male_fallscream.ogg', 50, 0)
		playsound(get_turf(S), 'sound/effects/bubbles.ogg', 50, 0)
		playsound(get_turf(S), 'sound/misc/loudcrunch2.ogg', 50, 0)
		var/bdna = null // For forensics (Convair880).
		var/btype = null
		if (S.bioHolder.Uid && S.bioHolder.bloodType)
			bdna = S.bioHolder.Uid
			btype = S.bioHolder.bloodType
		gibs(S.loc, null, null, bdna, btype)

		S.set_mutantrace(/datum/mutantrace/skeleton)
		S.real_name = "[S.name]'s skeleton"
		S.name = S.real_name
		S.update_body()
		S.UpdateName()
		return


/obj/item/trumpet/dootdoot/attack_self(var/mob/living/carbon/human/user as mob)
	if (spam_flag == 1)
		boutput(user, "<span style=\"color:red\">The trumpet needs time to recharge its spooky strength!</span>")
		return
	else
		spam_flag = 1
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 200) //because come on this shit's hilarious
		user.visible_message("<B>[user]</B> doots a [pick("spooky", "scary", "boney", "creepy", "squawking", "squeaky", "low-quality", "compressed")] tune on \his trumpet!")
		playsound(get_turf(src), 'sound/items/dootdoot.ogg', 50, 1)
		for(var/obj/critter/dog/george/G in range(user,6))
			if (prob(60))
				G.howl()
		src.add_fingerprint(user)
		spawn (5)
		for(var/mob/living/carbon/L in viewers(user, null))
			if (L == user)
				continue
			else
				src.dootize(L)
		spawn(100)
			spam_flag = 0
	return

/obj/item/emeter
	name = "E-Meter"
	desc = "A device for measuring Body Thetan levels."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0"

	attack(mob/M as mob, mob/user as mob, def_zone)
		var/reading = rand(1,10)
		if (user == M)
			boutput(user, "[user]'s Thetan Level: 0")
			for(var/mob/O in viewers(user, null))
				O.show_message(text("<b>[]</b> takes a reading with the [].", user, src), 1)
			return
		else
			boutput(user, "[M]'s Thetan Level: [reading]")
			for(var/mob/O in viewers(user, null))
				O.show_message(text("<b>[]</b> takes a reading with the [].", user, src), 1)
			return
/*
/obj/head_surgeon
	name = "cardboard box - 'Head Surgeon'"
	desc = "The HS looks a lot different today!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "head_surgeon"
	density = 1
	var/text2speech = 1

	attack_hand(mob/user as mob)
		user.visible_message("<span style=\"color:blue\">[user] taps [src].</span>")

	New()
		..()
		if (prob(50))
			new /obj/machinery/bot/medbot/head_surgeon(src.loc)
			qdel(src)

	proc/speak(var/message)
		if (!message)
			return
		for (var/mob/O in hearers(src, null))
			O.show_message("<span class='game say'><span class='name'>[src]</span> [pick("rustles", "folds", "womps", "boxes", "foffs", "flaps")], \"[message]\"",2)
		if (src.text2speech)
			var/audio = dectalk("\[:nk\][message]")
			if (audio["audio"])
				for (var/mob/O in hearers(src, null))
					if (!O.client)
						continue
					ehjax.send(O.client, "browseroutput", list("dectalk" = audio["audio"]))
				return 1
			else
				return 0
		return

/obj/box_captain
	name = "cardboard box - 'Captain'"
	desc = "The Captain looks a lot different today!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "box_captain"

	attack_hand(mob/user as mob)
		user.visible_message("<span style=\"color:blue\">[user] taps [src].</span>")
*/
/obj/item/hell_horn
	name = "decrepit instrument"
	desc = "It appears to be a musical instrument of some sort."
	icon = 'icons/obj/artifacts/artifactsitem.dmi'
	icon_state = "eldritch-1" // temp
	inhand_image_icon = 'icons/mob/inhand/hand_general.dmi'
	item_state = "eldritch" // temp
	w_class = 3
	force = 1
	throwforce = 5
	var/spam_flag = 0
	var/pitch = 0
	module_research = list("audio" = 20, "eldritch" = 3)

/obj/item/hell_horn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1

		playsound(user, 'sound/effects/mag_pandroar.ogg', 100, 0)
		for (var/mob/M in view(user))
			if (M != user)
				M.change_misstep_chance(50)

		spawn(60)
			spam_flag = 0

/obj/item/rubber_hammer
	name = "rubber hammer"
	desc = "Looks like one of those fair toys."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "rubber_hammer"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 0

	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)

		playsound(src.loc, "sound/items/bikehorn.ogg", 50, 1, -1)
		for(var/mob/O in viewers(M))
			if (O.client)	O.show_message("<span style=\"color:red\"><B>[user] bonks [M] on the head with the rubber hammer!</B></span>", 1, "<span style=\"color:red\">You hear something squeak.</span>", 2)