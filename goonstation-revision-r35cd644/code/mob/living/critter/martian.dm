/mob/living/critter/martian
	name = "martian"
	real_name = "martian"
	desc = "Genocidal monsters from Mars."
	density = 1
	icon_state = "martian"
	icon_state_dead = "martian-dead"
	custom_gib_handler = /proc/gibs
	say_language = "martian"
	voice_name = "martian"
	blood_id = "iron" // alchemy - mars = iron
	hand_count = 1
	can_throw = 1
	can_grab = 1
	can_disarm = 1
	can_help = 1
	speechverb_say = "screeches"
	speechverb_exclaim = "screeches"
	speechverb_ask = "screeches"
	speechverb_gasp = "screeches"
	speechverb_stammer = "screeches"

	understands_language(var/langname)
		if (langname == say_language || langname == "martian")
			return 1
		return 0

	setup_equipment_slots()
		equipment += new /datum/equipmentHolder/ears(src)
		equipment += new /datum/equipmentHolder/head(src)

	setup_hands()
		..()
		var/datum/handHolder/HH = hands[1]
		HH.name = "tentacles"

	setup_healths()
		add_hh_flesh(-35, 35, 0.5)
		add_hh_flesh_burn(-35, 35, 1)
		add_health_holder(/datum/healthHolder/toxin)
		add_health_holder(/datum/healthHolder/suffocation)
		var/datum/healthHolder/Brain = add_health_holder(/datum/healthHolder/brain)
		Brain.maximum_value = 0
		Brain.value = 0
		Brain.minimum_value = -250
		Brain.depletion_threshold = -100
		Brain.last_value = 0

	New()
		..()
		abilityHolder.addAbility(/datum/targetable/critter/psyblast/martian)
		abilityHolder.addAbility(/datum/targetable/critter/teleport)

	say(message, involuntary = 0)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

		..(message)

		if (involuntary || message == "" || stat)
			return
		if (dd_hasprefix(message, "*"))
			return
		else if (dd_hasprefix(message, ":lh") || dd_hasprefix(message, ":rh") || dd_hasprefix(message, ":in"))
			message = copytext(message, 4)
		else if (dd_hasprefix(message, ":"))
			message = copytext(message, 3)
		else if (dd_hasprefix(message, ";"))
			message = copytext(message, 2)

		for (var/mob/living/critter/martian/M in mobs)
			if (M.client && !M.stat)
				boutput(M, "<span style='color:#E89235'><b>[src.real_name]</b> telepathically messages, \"[message]\"</span>")


	warrior
		name = "martian warrior"
		real_name = "martian warrior"
		icon_state = "martianW"
		icon_state_dead = "martianW-dead"
		hand_count = 2

		setup_hands()
			..()
			var/datum/handHolder/HH = hands[1]
			HH.icon_state = "handl"
			HH.limb_name = "left tentacles"

			HH = hands[2]
			HH.name = "right tentacles"
			HH.suffix = "-R"
			HH.icon_state = "handr"
			HH.limb_name = "right tentacles"

	soldier
		name = "martian soldier"
		real_name = "martian soldier"
		icon_state = "martianS"
		icon_state_dead = "martianS-dead"
		hand_count = 2

		setup_hands()
			..()

			var/datum/handHolder/HH = hands[2]
			HH.limb = new /datum/limb/hitscan
			HH.name = "Martian Psychokinetic Blaster"
			HH.icon = 'icons/mob/critter_ui.dmi'
			HH.icon_state = "hand_martian"
			HH.limb_name = "Martian Psychokinetic Blaster"
			HH.can_hold_items = 0
			HH.can_attack = 0
			HH.can_range_attack = 1

			HH = hands[1]
			HH.name = "right tentacles"
			HH.suffix = "-R"
			HH.icon_state = "handr"
			HH.limb_name = "right tentacles"

	mutant
		name = "martian mutant"
		real_name = "martian mutant"
		icon_state = "martianP"
		icon_state_dead = "martianP-dead"

		New()
			..()
			abilityHolder.addAbility(/datum/targetable/critter/gibstare)
