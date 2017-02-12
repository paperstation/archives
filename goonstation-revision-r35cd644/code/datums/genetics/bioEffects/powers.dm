/datum/bioEffect/power
	name = "Cryokinesis"
	desc = "Allows the subject to control ice and cold."
	id = "cryokinesis"
	msgGain = "You notice a strange cold tingle in your fingertips."
	msgLose = "Your fingers feel warmer."
	effectType = effectTypePower
	cooldown = 600
	probability = 66
	blockCount = 3
	blockGaps = 2
	stability_loss = 10
	var/using = 0
	var/safety = 0
	var/power = 0
	var/ability_path = /datum/targetable/geneticsAbility/cryokinesis
	var/datum/targetable/geneticsAbility/ability = /datum/targetable/geneticsAbility/cryokinesis

	New()
		..()
		check_ability_owner()

	OnAdd()
		..()
		if (istype(owner,/mob/living/carbon/human/))
			var/mob/living/carbon/human/H = owner
			H.hud.update_ability_hotbar()
			check_ability_owner()
		return

	OnRemove()
		..()
		if (istype(owner,/mob/living/carbon/human/))
			var/mob/living/carbon/human/H = owner
			if (H.hud)
				H.hud.update_ability_hotbar()
		return

	proc/check_ability_owner()
		if (ispath(ability_path))
			var/datum/targetable/geneticsAbility/AB = new ability_path(src)
			ability = AB
			AB.linked_power = src
			spawn(0)
				AB.owner = src.owner

/datum/targetable/geneticsAbility/cryokinesis
	name = "Cryokinesis"
	desc = "Exert control over cold and ice."
	icon_state = "cryokinesis"
	targeted = 1
	target_anything = 1

	cast(atom/target)
		if (..())
			return 1

		var/turf/T = get_turf(target)

		target.visible_message("<span style=\"color:red\"><b>[owner]</b> points at [target]!</span>")
		playsound(target.loc, "sound/effects/bamf.ogg", 50, 0)
		particleMaster.SpawnSystem(new /datum/particleSystem/tele_wand(get_turf(target),"8x8snowflake","#88FFFF"))

		var/obj/decal/icefloor/B
		B = new /obj/decal/icefloor(T)
		spawn(800)
			B.dispose()

		if (linked_power.power)
			for (var/turf/TF in orange(1,T))
				B = new /obj/decal/icefloor(TF)
				spawn(800)
					B.dispose()

		for (var/mob/living/L in T.contents)
			if (L == owner && linked_power.safety)
				continue
			boutput(L, "<span style=\"color:blue\">You are struck by a burst of ice cold air!</span>")
			if(L.burning)
				L.set_burning(0)
			L.bodytemperature = 100
			if (linked_power.power)
				new /obj/icecube(get_turf(L), L)

		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/mattereater
	name = "Matter Eater"
	desc = "Allows the subject to eat just about anything without harm."
	id = "mattereater"
	msgGain = "You feel hungry."
	msgLose = "You don't feel quite so hungry anymore."
	cooldown = 300
	probability = 66
	blockCount = 4
	blockGaps = 2
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/mattereater
	var/target_path = "/obj/item/"

/datum/targetable/geneticsAbility/mattereater
	name = "Matter Eater"
	desc = "Eat just about anything!"
	icon_state = "mattereater"
	targeted = 0
	var/using = 0

	cast()
		if (..())
			return 1
		if (using)
			return 1
		using = 1

		var/datum/bioEffect/power/mattereater/ME = linked_power
		var/base_path = text2path("[ME.target_path]")
		if (!ispath(base_path))
			base_path = /obj/item/
		var/list/items = get_filtered_atoms_in_touch_range(owner,base_path)
		if (istype(owner.loc,/mob/) || istype(owner.loc,/obj/))
			for (var/atom/A in owner.loc.contents)
				if (istype(A,ME.target_path))
					items += A

		if (linked_power.power)
			items += get_filtered_atoms_in_touch_range(owner, /obj/the_server_ingame_whoa)
			//So people can still get the meat ending

		if (!items.len)
			boutput(usr, "/red You can't find anything nearby to eat.")
			using = 0
			return

		var/obj/the_item = input("Which item do you want to eat?","Matter Eater") as null|obj in items
		if (!the_item)
			using = 0
			return 1

		var/area/cur_area = get_area(owner)
		var/turf/cur_turf = get_turf(owner)
		if (isrestrictedz(cur_turf.z) && !cur_area.may_eat_here_in_restricted_z && (!owner.client || !owner.client.holder))
			owner.show_text("<span style=\"color:red\">Man, this place really did a number on your appetite. You can't bring yourself to eat anything here.</span>")
			using = 0
			return 1

		if (istype(the_item, /obj/the_server_ingame_whoa))
			var/obj/the_server_ingame_whoa/the_server = the_item
			the_server.eaten(owner)
			using = 0
			return
		owner.visible_message("<span style=\"color:red\">[owner] eats [the_item].</span>")
		playsound(owner.loc, "sound/items/eatfood.ogg", 50, 0)
		the_item.set_loc(owner)
		qdel(the_item)

		if (ishuman(owner))
			for(var/A in owner.organs)
				var/obj/item/affecting = null
				if (!owner.organs[A])    continue
				affecting = owner.organs[A]
				if (!istype(affecting, /obj/item))
					continue
				affecting.heal_damage(4, 0)
			owner.UpdateDamageIcon()
			owner.updatehealth()

		using = 0
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/jumpy
	name = "Jumpy"
	desc = "Allows the subject to leap great distances."
	id = "jumpy"
	msgGain = "Your leg muscles feel taut and strong."
	msgLose = "Your leg muscles shrink back to normal."
	cooldown = 30
	probability = 99
	blockCount = 4
	blockGaps = 2
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/jumpy

/datum/targetable/geneticsAbility/jumpy
	name = "Jumpy"
	desc = "Take a big leap forward."
	icon_state = "jumpy"
	targeted = 0

	cast()
		if (..())
			return 1

		if (istype(owner.loc,/mob/))
			boutput(usr, "<span style=\"color:red\">You can't jump right now!</span>")
			return 1

		var/jump_tiles = 10
		var/pixel_move = 8
		var/sleep_time = 1
		if (linked_power.power)
			jump_tiles = 20
			pixel_move = 16
			sleep_time = 0.5

		if (istype(owner.loc,/turf/))
			usr.visible_message("<span style=\"color:red\"><b>[owner]</b> takes a huge leap!</span>")
			playsound(owner.loc, "sound/weapons/thudswoosh.ogg", 50, 1)
			var/prevLayer = owner.layer
			owner.layer = EFFECTS_LAYER_BASE

			for(var/i=0, i < jump_tiles, i++)
				step(owner, owner.dir)
				if(i < jump_tiles / 2)
					owner.pixel_y += pixel_move
				else
					owner.pixel_y -= pixel_move
				sleep(sleep_time)

			usr.pixel_y = 0

			if (owner.bioHolder.HasEffect("fat") && prob(66) && !linked_power.safety)
				owner.visible_message("<span style=\"color:red\"><b>[owner]</b> crashes due to their heavy weight!</span>")
				playsound(usr.loc, "sound/effects/zhit.ogg", 50, 1)
				owner.weakened += 10
				owner.stunned += 5

			owner.layer = prevLayer

		if (istype(owner.loc,/obj/))
			var/obj/container = owner.loc
			boutput(owner, "<span style=\"color:red\">You leap and slam your head against the inside of [container]! Ouch!</span>")
			owner.paralysis += 3
			owner.weakened += 5
			container.visible_message("<span style=\"color:red\"><b>[owner.loc]</b> emits a loud thump and rattles a bit.</span>")
			playsound(owner.loc, "sound/effects/bang.ogg", 50, 1)
			var/wiggle = 6
			while(wiggle > 0)
				wiggle--
				container.pixel_x = rand(-3,3)
				container.pixel_y = rand(-3,3)
				sleep(1)
			container.pixel_x = 0
			container.pixel_y = 0

		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/polymorphism
	name = "Polymorphism"
	desc = "Enables the subject to reconfigure their appearance to mimic that of others."
	id = "polymorphism"
	msgGain = "You don't feel entirely like yourself somehow."
	msgLose = "You feel secure in your identity."
	cooldown = 1800
	probability = 66
	blockCount = 4
	blockGaps = 4
	stability_loss = 15
	ability_path = /datum/targetable/geneticsAbility/polymorphism

/datum/targetable/geneticsAbility/polymorphism
	name = "Polymorphism"
	desc = "Mimic the appearance of others."
	icon_state = "polymorphism"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1

		if (!istype(target,/mob/living/carbon/human))
			boutput(owner, "<span style=\"color:red\">[target] does not seem to be compatible with this ability.</span>")
			return 1
		if (target == owner)
			boutput(owner, "<span style=\"color:red\">While \"be yourself\" is pretty good advice, that would be taking it a bit too literally.</span>")
			return 1
		var/mob/living/carbon/human/H = target
		if (!H.bioHolder)
			boutput(owner, "<span style=\"color:red\">[target] does not seem to be compatible with this ability.</span>")
			return 1

		if (get_dist(H,owner) > 1 && !owner.bioHolder.HasEffect("telekinesis"))
			boutput(owner, "<span style=\"color:red\">You must be within touching distance of [target] for this to work.</span>")
			return 1

		playsound(owner.loc, "sound/effects/blobattack.ogg", 50, 1)
		owner.visible_message("<span style=\"color:red\"><b>[owner]</b> touches [target], then begins to shifts and contort!</span>")

		spawn(10)
			if(H && owner)
				playsound(owner.loc, "sound/effects/gib.ogg", 50, 1)
				owner.bioHolder.CopyOther(H.bioHolder, copyAppearance = 1, copyPool = 0, copyEffectBlocks = 0, copyActiveEffects = 0)
				owner.real_name = H.real_name
				owner.name = H.name

		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/telepathy
	name = "Telepathy"
	desc = "Allows the subject to project their thoughts into the minds of other organics."
	id = "telepathy"
	msgGain = "You can hear your own voice echoing in your mind."
	msgLose = "Your mental voice fades away."
	probability = 99
	blockCount = 4
	blockGaps = 2
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/telepathy

/datum/targetable/geneticsAbility/telepathy
	name = "Telepathy"
	desc = "Transmit psychic messages to others."
	icon_state = "telepathy"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/recipient = null
		if (istype(target,/mob/living/carbon/))
			recipient = target
		else if (ismob(target) && !istype(target,/mob/living/carbon/))
			boutput(owner, "<span style=\"color:red\">You can't transmit to [target] as they are too different from you mentally!</span>")
			return 1
		else
			var/turf/T = get_turf(target)
			for (var/mob/living/carbon/C in T.contents)
				recipient = C
				break

		if (!recipient)
			boutput(owner, "<span style=\"color:red\">There's nobody there to transmit a message to.</span>")
			return 1

		if (recipient.bioHolder.HasEffect("psy_resist"))
			boutput(owner, "<span style=\"color:red\">You can't contact [recipient.name]'s mind at all!</span>")
			return 1

		if(!recipient.client || recipient.stat)
			boutput(recipient, "<span style=\"color:red\">You can't seem to get through to [recipient.name] mentally.</span>")
			return 1

		var/msg = copytext( adminscrub(input(usr, "Message to [recipient.name]:","Telepathy") as text), 1, MAX_MESSAGE_LEN)
		if (!msg)
			return 1

		var/psyname = "A psychic voice"
		if (recipient.bioHolder.HasOneOfTheseEffects("telepathy","empath"))
			psyname = "[owner.name]"

		boutput(recipient, "<span style='color: #BD33D9'><b>[psyname]</b> echoes, \"<i>[msg]</i>\"</span>")
		boutput(owner, "<span style='color: #BD33D9'>You echo \"<i>[msg]</i>\" to <b>[recipient.name]</b>.</span>")

		logTheThing("telepathy", owner, recipient, "TELEPATHY to %target%: [msg]")

		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/empath
	name = "Empathic Thought"
	desc = "The subject becomes able to read the minds of others for certain information."
	id = "empath"
	msgGain = "You suddenly notice more about others than you did before."
	msgLose = "You no longer feel able to sense intentions."
	probability = 99
	blockCount = 3
	blockGaps = 2
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/empath

/datum/targetable/geneticsAbility/empath
	name = "Mind Reader"
	desc = "Read the minds of others for information."
	icon_state = "empath"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/read = null
		if (istype(target,/mob/living/carbon/))
			read = target
		else if (ismob(read) && !istype(target,/mob/living/carbon/))
			boutput(owner, "<span style=\"color:red\">You can't read the thoughts of [target] as they are too different from you mentally!</span>")
			return 1
		else
			var/turf/T = get_turf(target)
			for (var/mob/living/carbon/C in T.contents)
				read = C
				break

		if (!read)
			boutput(owner, "<span style=\"color:red\">There's nobody there to read the thoughts of.</span>")
			return 1

		if (read.bioHolder.HasEffect("psy_resist"))
			boutput(owner, "<span style=\"color:red\">You can't see into [read.name]'s mind at all!</span>")
			return 1

		if (read.stat == 2)
			boutput(owner, "<span style=\"color:red\">[read.name] is dead and cannot have their mind read.</span>")
			return
		if (read.health < 0)
			boutput(owner, "<span style=\"color:red\">[read.name] is dying, and their thoughts are too scrambled to read.</span>")
			return

		boutput(usr, "<span style=\"color:blue\">Mind Reading of [read.name]:</b></span>")
		var/pain_condition = read.health
		// lower health means more pain
		var/list/randomthoughts = list("what to have for lunch","the future","the past","money",
		"their hair","what to do next","their job","space","amusing things","sad things",
		"annoying things","happy things","something incoherent","something they did wrong")
		var/thoughts = "thinking about [pick(randomthoughts)]"
		if (read.burning)
			pain_condition -= 50
			thoughts = "preoccupied with the fire"
		if (read.radiation)
			pain_condition -= 25

		switch(pain_condition)
			if (81 to INFINITY)
				boutput(owner, "<span style=\"color:blue\"><b>Condition</b>: [read.name] feels good.</span>")
			if (61 to 80)
				boutput(owner, "<span style=\"color:blue\"><b>Condition</b>: [read.name] is suffering mild pain.</span>")
			if (41 to 60)
				boutput(owner, "<span style=\"color:blue\"><b>Condition</b>: [read.name] is suffering significant pain.</span>")
			if (21 to 40)
				boutput(owner, "<span style=\"color:blue\"><b>Condition</b>: [read.name] is suffering severe pain.</span>")
			else
				boutput(owner, "<span style=\"color:blue\"><b>Condition</b>: [read.name] is suffering excruciating pain.</span>")
				thoughts = "haunted by their own mortality"

		switch(read.a_intent)
			if (INTENT_HELP)
				boutput(owner, "<span style=\"color:blue\"><b>Mood</b>: You sense benevolent thoughts from [read.name].</span>")
			if (INTENT_DISARM)
				boutput(owner, "<span style=\"color:blue\"><b>Mood</b>: You sense cautious thoughts from [read.name].</span>")
			if (INTENT_GRAB)
				boutput(owner, "<span style=\"color:blue\"><b>Mood</b>: You sense hostile thoughts from [read.name].</span>")
			if (INTENT_HARM)
				boutput(owner, "<span style=\"color:blue\"><b>Mood</b>: You sense cruel thoughts from [read.name].</span>")
				for(var/mob/living/L in view(7,read))
					if (L == read)
						continue
					thoughts = "thinking about punching [L.name]"
					break
			else
				boutput(owner, "<span style=\"color:blue\"><b>Mood</b>: You sense strange thoughts from [read.name].</span>")

		if (istype(target,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = read
			boutput(owner, "<span style=\"color:blue\"><b>Numbers</b>: You sense the number [H.pin] is important to [H.name].</span>")
		boutput(owner, "<span style=\"color:blue\"><b>Thoughts</b>: [read.name] is currently [thoughts].</span>")

		if (read.bioHolder.HasEffect("empath"))
			boutput(read, "<span style=\"color:red\">You sense [owner.name] reading your mind.</span>")
		else if (read.bioHolder.HasEffect("training_chaplain"))
			boutput(read, "<span style=\"color:red\">You sense someone intruding upon your thoughts...</span>")
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/immolate
	name = "Incendiary Mitochondria"
	desc = "The subject becomes able to convert excess cellular energy into thermal energy."
	id = "immolate"
	msgGain = "You suddenly feel rather hot."
	msgLose = "You no longer feel uncomfortably hot."
	cooldown = 600
	probability = 66
	blockCount = 3
	blockGaps = 2
	stability_loss = 10
	ability_path = /datum/targetable/geneticsAbility/immolate

/datum/targetable/geneticsAbility/immolate
	name = "Immolate"
	desc = "Wreath yourself in burning flames."
	icon_state = "immolate"
	targeted = 0

	cast()
		if (..())
			return 1

		playsound(owner.loc, "sound/effects/mag_fireballlaunch.ogg", 50, 0)

		if (owner.bioHolder && (owner.bioHolder.HasEffect("fire_resist") || owner.bioHolder.HasEffect("thermal_resist")))
			owner.show_message("<span style=\"color:red\">Your body emits an odd burnt odor but you somehow cannot bring yourself to heat up. Huh.</span>")
			return

		if (linked_power.power)
			owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> erupts into a huge column of flames! Holy shit!</span>")
			fireflash_sm(get_turf(owner), 3, 7000, 2000)
		else
			owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> suddenly bursts into flames!</span>")
			owner.set_burning(100)
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/melt
	name = "Self Biomass Manipulation"
	desc = "The subject becomes able to transform the matter of their cells into a liquid state."
	id = "melt"
	msgGain = "You feel strange and jiggly."
	msgLose = "You feel more solid."
	cooldown = 1200
	probability = 66
	blockCount = 3
	blockGaps = 2
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/melt

/datum/targetable/geneticsAbility/melt
	name = "Dissolve"
	desc = "Transform yourself into a liquid state."
	icon_state = "melt"
	targeted = 0

	cast()
		if (..())
			return 1

		if (linked_power.safety && spell_invisibility(owner, 1, 0, 0, 1) == 1) // Dry run. Can we phaseshift?
			spell_invisibility(owner,50)
			playsound(owner.loc, "sound/effects/mag_phase.ogg", 25, 1, -1)
		else
			owner.visible_message("<span style=\"color:red\"><b>[owner.name]'s flesh melts right off! Holy shit!</b></span>")
			if (owner.gender == "female")
				playsound(owner.loc, "sound/voice/female_fallscream.ogg", 50, 0)
			else
				playsound(owner.loc, "sound/voice/male_fallscream.ogg", 50, 0)
			playsound(owner.loc, "sound/effects/bubbles.ogg", 50, 0)
			playsound(owner.loc, "sound/misc/loudcrunch2.ogg", 50, 0)
			if (istype(owner,/mob/living/carbon/human/))
				var/mob/living/carbon/human/H = owner
				H.skeletonize()

				var/bdna = null // For forensics (Convair880).
				var/btype = null
				if (H.bioHolder.Uid && H.bioHolder.bloodType)
					bdna = H.bioHolder.Uid
					btype = H.bioHolder.bloodType
				gibs(owner.loc, null, null, bdna, btype)

			else
				owner.gib()
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/superfart
	name = "High-Pressure Intestines"
	desc = "Vastly increases the gas capacity of the subject's digestive tract."
	id = "superfart"
	msgGain = "You feel bloated and gassy."
	msgLose = "You no longer feel gassy. What a relief!"
	cooldown = 900
	probability = 33
	blockCount = 4
	blockGaps = 3
	stability_loss = 15
	ability_path = /datum/targetable/geneticsAbility/superfart
	var/farting = 0

/datum/targetable/geneticsAbility/superfart
	name = "Superfart"
	desc = "Unleash a gigantic fart!"
	icon_state = "superfart"
	targeted = 0

	cast()
		if (..())
			return 1

		if (!farting_allowed)
			boutput(owner, "<span style=\"color:red\">Farting is disabled.</span>")
			return 1
		var/datum/bioEffect/power/superfart/SF = linked_power

		if (SF.farting)
			boutput(owner, "<span style=\"color:red\">You're already farting! Be patient!</span>")
			return 1

		owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> hunches down and grits their teeth!</span>")
		SF.farting = 1
		var/stun_time = 3
		var/fart_range = 6
		var/gib_user = 0
		var/throw_speed = 15
		var/throw_repeat = 3
		var/sound_volume = 50
		var/sound_repeat = 1
		var/fart_string = " unleashes a [pick("tremendous","gigantic","colossal")] fart!"

		if(linked_power.power)
			stun_time = 6
			fart_range = 12
			throw_speed = 30
			throw_repeat = 6
			sound_volume = 100
			sound_repeat = 3
			if (!linked_power.safety)
				gib_user = 1
				fart_string = "'s body is torn apart like a wet paper bag by [his_or_her(owner)] unbelievably powerful farting!"

		sleep(30)
		if (can_act(owner))
			owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b>[fart_string]</span>")
			while (sound_repeat > 0)
				sound_repeat--
				playsound(owner.loc, "sound/misc/superfart.ogg", sound_volume, 1)

			for(var/mob/living/V in range(get_turf(owner),fart_range))
				shake_camera(V,10,5)
				if (V == owner)
					continue
				boutput(V, "<span style=\"color:red\">You are sent flying!</span>")

				V.weakened += stun_time
				// why the hell was this set to 12 christ
				while (throw_repeat > 0)
					throw_repeat--
					step_away(V,get_turf(owner),throw_speed)

			 if(owner.bioHolder.HasEffect("toxic_farts"))
			 	for(var/turf/T in view(get_turf(owner),2))
			 		new /obj/effects/fart_cloud(owner,owner)

			SF.farting = 0
			if (gib_user)
				owner.gib()
				for (var/turf/T in range(owner,6))
					animate_shake(T,5,rand(3,8),rand(3,8))
		else
			boutput(owner, "<span style=\"color:red\">You were interrupted and couldn't fart! Rude!</span>")
			SF.farting = 0
			return 1

		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/eyebeams
	name = "Optic Energizer"
	desc = "Imbues the subject's eyes with the potential to project concentrated thermal energy."
	id = "eyebeams"
	msgGain = "Your eyes ache and burn."
	msgLose = "Your eyes stop aching."
	cooldown = 80
	probability = 33
	blockCount = 3
	blockGaps = 5
	stability_loss = 10
	ability_path = /datum/targetable/geneticsAbility/eyebeams
	var/projectile_path = "/datum/projectile/laser/eyebeams"

/datum/targetable/geneticsAbility/eyebeams
	name = "Eyebeams"
	desc = "Shoot lasers from your eyes."
	icon_state = "eyebeams"
	targeted = 1
	target_anything = 1

	cast(atom/target)
		if (..())
			return 1

		var/turf/T = get_turf(target)

		var/datum/bioEffect/power/eyebeams/EB = linked_power
		var/projectile_path = text2path("[EB.projectile_path]")
		if(linked_power.power)
			projectile_path = /datum/projectile/laser

		owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> shoots eye beams!</span>")
		var/datum/projectile/laser/eyebeams/PJ = new projectile_path
		shoot_projectile_ST(owner, PJ, T)

/datum/projectile/laser/eyebeams
	name = "optic laser"
	icon_state = "eyebeam"
	power = 20
	cost = 20
	sname = "phaser bolt"
	dissipation_delay = 5
	shot_sound = 'sound/weapons/TaserOLD.ogg'
	color_red = 1
	color_green = 0
	color_blue = 1

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/adrenaline
	name = "Adrenaline Rush"
	desc = "Enables the user to voluntarily empty glands of stimulants. May be dangerous with repeated use."
	id = "adrenaline"
	probability = 66
	blockCount = 4
	blockGaps = 4
	cooldown = 600
	msgGain = "You feel hype!"
	msgLose = "You don't feel so pumped anymore."
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/adrenaline

/datum/targetable/geneticsAbility/adrenaline
	name = "Adrenaline Rush"
	desc = "Infuse your bloodstream with stimulants."
	icon_state = "adrenaline"
	targeted = 0
	can_act_check = 0

	cast()
		if (..())
			return 1
		var/multiplier = 1
		if(linked_power.power)
			multiplier = 2
		if (owner.reagents)
			boutput(owner, "<span style=\"color:blue\">You get pumped up!</span>")
			owner.emote("scream")
			owner.reagents.add_reagent("epinephrine",20 * multiplier)
			owner.reagents.add_reagent("salicylic_acid",20 * multiplier)
			if(linked_power.safety)
				owner.reagents.add_reagent("methamphetamine",max(0,20 - owner.reagents.get_reagent_amount("methamphetamine")))
				owner.reagents.add_reagent("energydrink",max(0,5 - owner.reagents.get_reagent_amount("energydrink")))
			else
				owner.reagents.add_reagent("methamphetamine",20 * multiplier)
				owner.reagents.add_reagent("energydrink",5 * multiplier)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/midas
	name = "Midas Touch"
	desc = "Allows the subject to transmute materials at will."
	id = "midas"
	msgGain = "Your fingers sparkle and gleam."
	msgLose = "Your fingers return to normal."
	cooldown = 300
	probability = 99
	blockCount = 2
	blockGaps = 4
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/midas
	var/transmute_material = "gold"

/datum/targetable/geneticsAbility/midas
	name = "Midas Touch"
	desc = "Transmute an object to gold by touching it."
	icon_state = "midas"
	targeted = 0

	cast()
		if (..())
			return 1
		if(linked_power.using)
			return 1

		var/base_path = /obj/item/
		if (linked_power.power)
			base_path = /obj/

		var/list/items = get_filtered_atoms_in_touch_range(owner,base_path)
		if (!items.len)
			boutput(usr, "/red You can't find anything nearby to touch.")
			return 1

		linked_power.using = 1
		var/obj/the_item = input("Which item do you want to transmute?","Midas Touch") as null|obj in items
		if (!the_item)
			last_cast = 0
			linked_power.using = 0
			return 1

		if (!linked_power)
			owner.visible_message("[owner] touches [the_item].")
		else
			if (istype(linked_power,/datum/bioEffect/power/midas))
				var/datum/bioEffect/power/midas/linked = linked_power
				owner.visible_message("<span style=\"color:red\">[owner] touches [the_item], turning it to [linked.transmute_material]!</span>")
				the_item.setMaterial(getCachedMaterial(linked.transmute_material))
			else
				owner.visible_message("<span style=\"color:red\">[owner] touches [the_item], turning it to gold!</span>")
				the_item.setMaterial(getCachedMaterial("gold"))
		linked_power.using = 0
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// COMBINATION-ONLY EFFECTS BELOW

/datum/bioEffect/power/healing_touch
	name = "Healing Touch"
	desc = "Allows the subject to heal the wounds of others with a touch."
	id = "healing_touch"
	msgGain = "Your hands radiate a comforting aura."
	msgLose = "The aura around your hands dissipates."
	cooldown = 900
	occur_in_genepools = 0
	stability_loss = 10
	ability_path = /datum/targetable/geneticsAbility/healing_touch

/datum/targetable/geneticsAbility/healing_touch
	name = "Healing Touch"
	desc = "Soothe the wounds of others."
	icon_state = "healingtouch"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1

		if (get_dist(target,owner) > 1 && !owner.bioHolder.HasEffect("telekinesis"))
			boutput(usr, "<span style=\"color:red\">You need to be closer to do that.</span>")
			return 1

		if (!istype(target,/mob/living/carbon/))
			boutput(usr, "<span style=\"color:red\">This power won't work on that!</span>")
			return 1

		if (target == owner)
			boutput(usr, "<span style=\"color:red\">This power doesn't work when you touch yourself. Weirdo.</span>")
			return 1

		var/mob/living/carbon/C = target
		owner.visible_message("<span style=\"color:red\"><b>[owner] touches [C], enveloping them in a soft glow!</b></span>")
		boutput(C, "<span style=\"color:blue\">You feel your pain fading away.</span>")
		var/amount_to_heal = 25
		if (linked_power.power)
			amount_to_heal = 50
		C.HealDamage("All", amount_to_heal, amount_to_heal)
		C.take_toxin_damage(0 - amount_to_heal)
		C.take_oxygen_deprivation(0 - amount_to_heal)
		C.take_brain_damage(0 - amount_to_heal)
		return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/dimension_shift
	// cant get the scary shit to work so tOt for now
	name = "Dimension Shift"
	desc = "Phase out and hide in another dimension."
	id = "dimension_shift"
	msgGain = "You can see a faint blue light."
	msgLose = "The blue light fades away."
	cooldown = 900
	occur_in_genepools = 0
	stability_loss = 20
	ability_path = /datum/targetable/geneticsAbility/dimension_shift
	var/active = 0
	var/processing = 0
	var/atom/last_loc = null

/datum/targetable/geneticsAbility/dimension_shift
	name = "Dimension Shift"
	desc = "Hide in another dimension to avoid hazards."
	icon_state = "dimensionshift"
	targeted = 0
	cooldown = 900

	cast()
		if (..())
			return 1

		if (!istype(linked_power,/datum/bioEffect/power/dimension_shift))
			return 1
		var/datum/bioEffect/power/dimension_shift/P = linked_power

		if (!istype(owner.loc,/turf/) && !istype(owner.loc,/obj/dummy/spell_invis/))
			boutput(owner, "<span style=\"color:red\">That won't work here.</span>")
			return 1

		if (P.processing)
			return 1

		P.processing = 1

		if (!P.active)
			P.active = 1
			P.last_loc = owner.loc
			owner.visible_message("<span style=\"color:red\"><b>[owner] vanishes in a burst of blue light!</b></span>")
			playsound(owner.loc, "sound/effects/ghost2.ogg", 50, 0)
			animate(owner, color = "#0000FF", time = 5, easing = LINEAR_EASING)
			animate(alpha = 0, time = 5, easing = LINEAR_EASING)
			spawn(7)
				var/obj/dummy/spell_invis/invis_object = new /obj/dummy/spell_invis(get_turf(owner))
				invis_object.canmove = 0
				owner.set_loc(invis_object)
			P.processing = 0
			return 1
		else
			var/obj/dummy/spell_invis/invis_object
			if (istype(owner.loc,/obj/dummy/spell_invis/))
				invis_object = owner.loc
			owner.set_loc(P.last_loc)
			if (invis_object)
				qdel(invis_object)
			P.last_loc = null

			owner.visible_message("<span style=\"color:red\"><b>[owner] appears in a burst of blue light!</b></span>")
			playsound(owner.loc, "sound/effects/ghost2.ogg", 50, 0)
			spawn(7)
				animate(owner, alpha = 255, time = 5, easing = LINEAR_EASING)
				animate(color = "#FFFFFF", time = 5, easing = LINEAR_EASING)
				P.active = 0
			P.processing = 0

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/photokinesis
	name = "Photokinesis"
	desc = "Allows the subject to create a source of light."
	id = "photokinesis"
	msgGain = "Everything seems too dark!"
	msgLose = "It's too bright!"
	cooldown = 600
	occur_in_genepools = 0
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/photokinesis
	var/red = 0
	var/green = 0
	var/blue = 0

	New()
		..()
		red = rand(5,10) / 10
		green = rand(5,10) / 10
		blue = rand(5,10) / 10

/datum/targetable/geneticsAbility/photokinesis
	name = "Photokinesis"
	desc = "Create a strong source of light."
	icon_state = "photokinesis"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1
		if (!istype(linked_power,/datum/bioEffect/power/photokinesis/))
			return 1
		var/datum/bioEffect/power/photokinesis/P = linked_power

		var/turf/T = get_turf(target)
		owner.visible_message("<span style=\"color:red\"><b>[owner]</b> raises [his_or_her(owner)] hands into the air!</span>")
		playsound(owner.loc, "sound/effects/heavenly.ogg", 50, 0)
		var/strength = 7
		var/time = 300
		if (linked_power.power)
			strength = 13
			time = 600
		new /obj/photokinesis_light(T,P.red,P.green,P.blue,strength,time)

/obj/photokinesis_light
	name = ""
	desc = ""
	density = 0
	anchored = 1
	mouse_opacity = 0
	icon = null
	icon_state = null
	var/datum/light/light

	New(var/loc,var/color_R,var/color_G,var/color_B,var/strength = 7,var/time = 300)
		..()
		light = new /datum/light/point
		light.set_brightness(strength / 7)
		light.set_color(color_R, color_G, color_B)
		light.attach(src)
		light.enable()

		if (isnum(time))
			spawn(time)
				qdel(src)

	disposing()
		..()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/erebokinesis
	name = "Erebokinesis"
	desc = "Allows the subject to snuff out all light in an area."
	id = "erebokinesis"
	msgGain = "Everything seems too bright!"
	msgLose = "It's too dark!"
	cooldown = 600
	occur_in_genepools = 0
	stability_loss = 5
	ability_path = /datum/targetable/geneticsAbility/erebokinesis
	var/time = 0
	var/size = 0

	New()
		..()
		size = rand(2,4)
		time = rand(200,600)

/datum/targetable/geneticsAbility/erebokinesis
	name = "Erebokinesis"
	desc = "Create a field of darkness."
	icon_state = "erebokinesis"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1
		if (!istype(linked_power,/datum/bioEffect/power/erebokinesis/))
			return 1
		var/datum/bioEffect/power/erebokinesis/P = linked_power
		var/field_size = P.size
		var/field_time = P.time
		if (P.power)
			field_size *= 2
			field_time *= 2

		var/turf/T = get_turf(target)
		owner.visible_message("<span style=\"color:red\"><b>[owner]</b> raises [his_or_her(owner)] hands into the air!</span>")
		playsound(owner.loc, "sound/effects/chanting.ogg", 50, 0)
		new /obj/darkness_field(T,field_time)
		for(var/turf/TD in circular_range(T,field_size))
			new /obj/darkness_field(TD,field_time)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/fire_breath
	name = "Fire Breath"
	desc = "Allows the subject to exhale fire."
	id = "fire_breath"
	msgGain = "Your throat is burning!"
	msgLose = "Your throat feels a lot better now."
	cooldown = 600
	occur_in_genepools = 0
	stability_loss = 10
	ability_path = /datum/targetable/geneticsAbility/fire_breath
	var/temperature = 1200
	var/range = 4

/datum/targetable/geneticsAbility/fire_breath
	name = "Fire Breath"
	desc = "Huff and puff, and burn their house down!"
	icon_state = "firebreath"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1

		var/turf/T = get_turf(target)
		var/list/affected_turfs = getline(owner, T)
		var/datum/bioEffect/power/fire_breath/FB = linked_power
		var/range = FB.range
		var/temp = FB.temperature
		if (FB.power)
			range *= 2
			temp *= 4
		owner.visible_message("<span style=\"color:red\"><b>[owner] breathes fire!</b></span>")
		playsound(owner.loc, "sound/effects/mag_fireballlaunch.ogg", 50, 0)
		var/turf/currentturf
		var/turf/previousturf
		for(var/turf/F in affected_turfs)
			previousturf = currentturf
			currentturf = F
			if(currentturf.density || istype(currentturf, /turf/space))
				break
			if(previousturf && LinkBlocked(previousturf, currentturf))
				break
			if (F == get_turf(owner))
				continue
			if (get_dist(owner,F) > range)
				continue
			tfireflash(F,0.5,temp)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/brown_note
	name = "Brown Note"
	desc = "Allows the subject to emit noises that can cause involuntary flatus in others."
	id = "brown_note"
	msgGain = "You feel mischevious!"
	msgLose = "You want to behave yourself again."
	cooldown = 30
	blockCount = 1
	blockGaps = 3
	stability_loss = 15
	ability_path = /datum/targetable/geneticsAbility/brown_note

/datum/targetable/geneticsAbility/brown_note
	name = "Brown Note"
	desc = "Mess with others using the power of sound!"
	icon_state = "brownnote"
	targeted = 0

	cast()
		if (..())
			return 1
		owner.visible_message("<span style=\"color:red\"><b>[owner.name] makes a weird noise!</b></span>")
		playsound(owner.loc, 'sound/items/hellhorn_0.ogg', 50, 0)
		for (var/mob/living/L in range(7,owner))
			if (L.hearing_check(1))
				if(locate(/obj/item/storage/bible) in get_turf(L))
					owner.visible_message("<span style=\"color:red\"><b>A mysterious force smites [owner.name] for inciting blasphemy!</b></span>")
					owner.gib()
				else
					L.emote("fart")

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/telekinesis_drag
	name = "Telekinetic Pull"
	desc = "Allows the subject to influence physical objects through utilizing latent powers in their mind."
	id = "telekinesis_drag"
	effectType = effectTypePower
	probability = 8
	blockCount = 5
	blockGaps = 5
	reclaim_mats = 40
	msgGain = "You feel your consciousness expand outwards."
	msgLose = "Your conciousness closes inwards."
	stability_loss = 15
	ability_path = /datum/targetable/geneticsAbility/telekinesis

	OnMobDraw()
		if (disposed)
			return
		if (ishuman(owner))
			var/mob/living/carbon/human/H = owner
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "telekinesishead[H.bioHolder.HasEffect("fat") ? "fat" :""]", layer = MOB_LAYER)
		return

	OnAdd()
		..()
		if (ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.set_body_icon_dirty()

	OnRemove()
		..()
		if (ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.set_body_icon_dirty()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/telekinesis
	name = "Telekinesis"
	desc = "Allows the subject to influence physical objects through utilizing latent powers in their mind."
	id = "telekinesis_command"
	effectType = effectTypePower
	probability = 8
	blockCount = 5
	blockGaps = 5
	reclaim_mats = 40
	msgGain = "You feel your consciousness expand outwards."
	msgLose = "Your conciousness closes inwards."
	stability_loss = 30
	occur_in_genepools = 0
	ability_path = /datum/targetable/geneticsAbility/telekinesis

/datum/targetable/geneticsAbility/telekinesis
	name = "Telekinetic Throw"
	icon_state = "tk"
	desc = "Command a few objects to hurl themselves at the target location."
	targeted = 1
	target_anything = 1
	cooldown = 200

	cast(atom/T)
		var/list/thrown = list()
		var/current_prob = 100
		var/modifier = 0.4

		if (linked_power.power)
			modifier *= 2

		owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> makes a gesture at [T.name]!</span>")

		for (var/obj/O in view(7, owner))
			if (!O.anchored && isturf(O.loc))
				if (prob(current_prob))
					current_prob *= modifier // very steep. probably grabs 3 or 4 objects per cast -- much less effective than revenant command
					thrown += O
					animate_float(O)
		spawn(10)
			for (var/obj/O in thrown)
				O.throw_at(T, 32, 2)

		return 0

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/darkcloak
	name = "Cloak of Darkness"
	desc = "Enables the subject to bend low levels of light around themselves, creating a cloaking effect."
	id = "cloak_of_darkness"
	effectType = effectTypePower
	isBad = 0
	probability = 33
	blockGaps = 3
	blockCount = 3
	msgGain = "You begin to fade into the shadows."
	msgLose = "You become fully visible."
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 20
	cooldown = 0
	var/active = 0
	ability_path = /datum/targetable/geneticsAbility/darkcloak

	proc/cloak_decloak(var/which_way = 1)
		if (!src.owner || !isliving(src.owner))
			return

		var/mob/living/L = owner
		if (which_way == 1)
			L.invisibility = 1
			L.UpdateOverlays(overlay_image, id)
		else
			L.invisibility = 0
			L.UpdateOverlays(null, id)

		return

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse", layer = MOB_LIMB_LAYER)
			overlay_image.color = "#333333"
		..()
		owner.UpdateOverlays(null, id)

	OnRemove()
		..()
		src.cloak_decloak(2)
		return

	OnLife()
		if (isliving(owner))
			var/mob/living/L = owner
			var/turf/T = get_turf(L)

			if (T && isturf(T))
				var/area/A = get_area(T)
				if (istype(T, /turf/space) || (A && (istype(A, /area/shuttle/) || istype(A, /area/shuttle_transit_space) || A.name == "Space")))
					src.cloak_decloak(2)

				else
					if (T.RL_GetBrightness() < 0.2 && can_act(owner) && src.active)
						src.cloak_decloak(1)
					else
						src.cloak_decloak(2)
			else
				src.cloak_decloak(2)
		return

/datum/targetable/geneticsAbility/darkcloak
	name = "Cloak of Darkness"
	icon_state = "darkcloak"
	desc = "Activate or deactivate your cloak of darkness."
	targeted = 0
	cooldown = 0
	can_act_check = 0

	cast(atom/T)
		var/datum/bioEffect/power/darkcloak/DC = linked_power
		if (DC.active)
			boutput(usr, "You stop using your cloak of darkness.")
			DC.active = 0
		else
			boutput(usr, "You start using your cloak of darkness.")
			DC.active = 1
		return 0

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/chameleon
	name = "Chameleon"
	desc = "The subject becomes able to subtly alter light patterns to become invisible, as long as they remain still."
	id = "chameleon"
	effectType = effectTypePower
	probability = 33
	blockCount = 3
	blockGaps = 3
	msgGain = "You feel one with your surroundings."
	msgLose = "You feel oddly exposed."
	lockProb = 40
	lockedGaps = 1
	lockedDiff = 3
	lockedChars = list("G","C","A","T")
	lockedTries = 8
	stability_loss = 20
	cooldown = 0
	var/active = 0
	ability_path = /datum/targetable/geneticsAbility/chameleon

	OnAdd()
		if (ishuman(owner))
			overlay_image = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "aurapulse", layer = MOB_LIMB_LAYER)
		..()
		owner.UpdateOverlays(null, id)

	OnRemove()
		..()
		if (isliving(owner))
			var/mob/living/L = owner
			L.UpdateOverlays(null, id)
			L.invisibility = 0
		return

	OnLife()
		if(isliving(owner))
			var/mob/living/L = owner
			if ((world.timeofday - owner.l_move_time) >= 30 && can_act(owner) && src.active)
				L.UpdateOverlays(overlay_image, id)
				L.invisibility = 1
			else
				L.UpdateOverlays(null, id)
				L.invisibility = 0

/datum/targetable/geneticsAbility/chameleon
	name = "Chameleon"
	icon_state = "chameleon"
	desc = "Activate or deactivate your chameleon cloak."
	targeted = 0
	cooldown = 0
	can_act_check = 0

	cast(atom/T)
		var/datum/bioEffect/power/chameleon/CH = linked_power
		if (CH.active)
			boutput(usr, "You stop using your chameleon cloaking.")
			CH.active = 0
		else
			boutput(usr, "You start using your chameleon cloaking.")
			CH.active = 1
		return 0

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/bigpuke
	name = "Mass Emesis"
	desc = "Allows the subject to expel chemicals via the mouth."
	id = "bigpuke"
	msgGain = "You feel sick."
	msgLose = "You feel much better!"
	cooldown = 300
	occur_in_genepools = 0
	stability_loss = 10
	ability_path = /datum/targetable/geneticsAbility/bigpuke
	var/range = 3

/datum/targetable/geneticsAbility/bigpuke
	name = "Mass Emesis"
	desc = "BLAAAAAAAARFGHHHHHGHH"
	icon_state = "bigpuke"
	targeted = 1

	cast(atom/target)
		if (..())
			return 1

		var/turf/T = get_turf(target)
		var/list/affected_turfs = getline(owner, T)
		var/datum/bioEffect/power/bigpuke/BP = linked_power
		var/range = BP.range
		if (BP.power)
			range *= 2
		owner.visible_message("<span style=\"color:red\"><b>[owner] horfs up a huge stream of puke!</b></span>")
		logTheThing("combat", owner, target, "power-pukes [log_reagents(owner)] at [log_loc(owner)].")
		playsound(owner.loc, "sound/misc/meat_plop.ogg", 50, 0)
		owner.reagents.add_reagent("vomit",20)
		var/turf/currentturf
		var/turf/previousturf
		for(var/turf/F in affected_turfs)
			previousturf = currentturf
			currentturf = F
			if(currentturf.density || istype(currentturf, /turf/space))
				break
			if(previousturf && LinkBlocked(previousturf, currentturf))
				break
			if (F == get_turf(owner))
				continue
			if (get_dist(owner,F) > range)
				continue
			owner.reagents.reaction(F,TOUCH)
			for(var/mob/living/L in F.contents)
				owner.reagents.reaction(L,TOUCH)
			for(var/obj/O in F.contents)
				owner.reagents.reaction(O,TOUCH)
		owner.reagents.clear_reagents()
		return 0

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/bioEffect/power/ink
	name = "Ink Glands"
	desc = "Allows the subject to expel modified melanin."
	id = "inkglands"
	msgGain = "You feel artistic."
	msgLose = "You don't really feel artistic anymore."
	cooldown = 0
	occur_in_genepools = 0
	stability_loss = 2
	ability_path = /datum/targetable/geneticsAbility/ink
	var/color = "#888888"

	New()
		..()
		color = random_color_hex()

/datum/targetable/geneticsAbility/ink
	name = "Ink Glands"
	desc = "Spray colorful ink onto an object."
	icon_state = "ink"
	targeted = 0

	cast()
		if (..())
			return 1

		var/base_path = /obj
		var/list/items = get_filtered_atoms_in_touch_range(owner,base_path)
		if (!items.len)
			boutput(usr, "/red You can't find anything nearby to spray ink on.")
			return 1

		var/obj/the_item = input("Which item do you want to color?","Ink Glands") as null|obj in items
		if (!the_item)
			last_cast = 0
			return 1

		var/datum/bioEffect/power/ink/I = linked_power
		if (!linked_power)
			owner.visible_message("[owner] spits on [the_item]. Gross.")
		else
			owner.visible_message("<span style=\"color:red\">[owner] sprays ink onto [the_item]!</span>")
			the_item.color = I.color
		return 0

////////////////
// Admin Only //
////////////////

/datum/bioEffect/power/fade_out
	name = "Fading"
	desc = "Allows the subject to become visible or invisible at will."
	id = "fade"
	cooldown = 0
	occur_in_genepools = 0
	scanner_visibility = 0
	curable_by_mutadone = 0
	ability_path = /datum/targetable/geneticsAbility/fade

/datum/targetable/geneticsAbility/fade
	name = "Fade"
	desc = "Fade in and out. An admin power."
	icon_state = "template"
	targeted = 0
	can_act_check = 0
	var/active = 0
	var/fading = 0

	cast()
		if (..() || fading)
			return 1

		if (active)
			fading = 1
			animate(usr, time = 10, alpha = 0, easing = LINEAR_EASING)
			fading = 0
		else
			fading = 1
			animate(usr, time = 10, alpha = 255, easing = LINEAR_EASING)
			fading = 0