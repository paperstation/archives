
/obj/item/toy/sword
	name = "toy sword"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword1"
	inhand_image_icon = 'icons/mob/inhand/hand_cswords.dmi'
	desc = "A sword made of cheap plastic. Contains a colored LED. Collect all five!"
	throwforce = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5
	contraband = 3
	stamina_damage = 1
	stamina_cost = 3
	stamina_crit_chance = 1
	var/sound_attackM1 = 'sound/weapons/male_toyattack.ogg'
	var/sound_attackM2 = 'sound/weapons/male_toyattack2.ogg'
	var/sound_attackF1 = 'sound/weapons/female_toyattack.ogg'
	var/sound_attackF2 = 'sound/weapons/female_toyattack2.ogg'

	New()
		..()
		var/selected_color = pick("R","O","Y","G","C","B","P","Pi","W")
		if (prob(1))
			selected_color = null
		icon_state = "sword1-[selected_color]"
		item_state = "sword1-[selected_color]"

	attack(target as mob, mob/user as mob)
		..()
		if (ishuman(user))
			var/mob/living/carbon/human/U = user
			if (U.gender == MALE)
				playsound(get_turf(U), pick(src.sound_attackM1, src.sound_attackM2), 100, 0, 0, U.get_age_pitch())
			else
				playsound(get_turf(U), pick(src.sound_attackF1, src.sound_attackF2), 100, 0, 0, U.get_age_pitch())

/obj/item/toy/figure
	name = "collectable figure"
	desc = "<b><span style=\"color:red\">WARNING:</span> CHOKING HAZARD</b> - Small parts. Not for children under 3 years."
	icon = 'icons/obj/figures.dmi'
	icon_state = "fig-"
	w_class = 1.0
	throwforce = 1
	throw_speed = 4
	throw_range = 7
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 1
	//mat_changename = 0
	rand_pos = 1
	var/datum/figure_info/info = null

	New(loc, var/datum/figure_info/newInfo)
		..()
		if (istype(newInfo))
			src.info = new newInfo(src)
		else if (!istype(src.info))
			var/datum/figure_info/randomInfo
			if (prob(10))
				randomInfo = pick(figure_high_rarity)
			else
				randomInfo = pick(figure_low_rarity)
			src.info = new randomInfo(src)
		src.name = "[src.info.name] figure"
		src.icon_state = "fig-[src.info.icon_state]"
		if (src.info.rare_varieties.len && prob(5))
			src.icon_state = "fig-[pick(src.info.rare_varieties)]"
		else if (src.info.varieties.len)
			src.icon_state = "fig-[pick(src.info.varieties)]"

		if (prob(1)) // rarely give a different material
			if (prob(1)) // VERY rarely give a super-fancy material
				var/list/rare_material_varieties = list("gold", "spacelag", "diamond", "ruby", "garnet", "topaz", "citrine", "peridot", "emerald", "jade", "aquamarine",
				"sapphire", "iolite", "amethyst", "alexandrite", "uqill", "uqillglass", "telecrystal", "miracle", "starstone", "flesh", "blob", "bone", "beeswax", "carbonfibre")
				src.setMaterial(getCachedMaterial(pick(rare_material_varieties)))
			else // silly basic "rare" varieties of things that should probably just be fancy paintjobs or plastics, but whoever made these things are idiots and just made them out of the actual stuff.  I guess.
				var/list/material_varieties = list("steel", "glass", "silver", "quartz", "rosequartz", "plasmaglass", "onyx", "jasper", "malachite", "lapislazuli")
				src.setMaterial(getCachedMaterial(pick(material_varieties)))

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] shoves [src] down their throat and chokes on it!</b></span>")
		user.take_oxygen_deprivation(175)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		qdel(src)
		return 1

	UpdateName()
		if (istype(src.info))
			src.name = "[name_prefix(null, 1)][src.info.name] figure[name_suffix(null, 1)]"
		else
			return ..()

var/list/figure_low_rarity = list(\
/datum/figure_info/assistant,\
/datum/figure_info/chef,\
/datum/figure_info/chaplain,\
/datum/figure_info/barman,\
/datum/figure_info/botanist,\
/datum/figure_info/janitor,\
/datum/figure_info/doctor,\
/datum/figure_info/geneticist,\
/datum/figure_info/roboticist,\
/datum/figure_info/scientist,\
/datum/figure_info/security,\
/datum/figure_info/detective,\
/datum/figure_info/engineer,\
/datum/figure_info/mechanic,\
/datum/figure_info/miner,\
/datum/figure_info/qm,\
/datum/figure_info/monkey)

var/list/figure_high_rarity = list(\
/datum/figure_info/captain,\
/datum/figure_info/hos,\
/datum/figure_info/hop,\
/datum/figure_info/md,\
/datum/figure_info/rd,\
/datum/figure_info/ce,\
/datum/figure_info/boxer,\
/datum/figure_info/lawyer,\
/datum/figure_info/barber,\
/datum/figure_info/mailman,\
/datum/figure_info/tourist,\
/datum/figure_info/vice,\
/datum/figure_info/clown,\
/datum/figure_info/traitor,\
/datum/figure_info/changeling,\
/datum/figure_info/nukeop,\
/datum/figure_info/wizard,\
/datum/figure_info/wraith,\
/datum/figure_info/cluwne,\
/datum/figure_info/macho,\
/datum/figure_info/cyborg,\
/datum/figure_info/ai,\
/datum/figure_info/blob,\
/datum/figure_info/werewolf,\
/datum/figure_info/omnitraitor,\
/datum/figure_info/shitty_bill,\
/datum/figure_info/don_glabs,\
/datum/figure_info/father_jack,\
/datum/figure_info/inspector,\
/datum/figure_info/coach,\
/datum/figure_info/sous_chef,\
/datum/figure_info/waiter,\
/datum/figure_info/apiarist,\
/datum/figure_info/journalist,\
/datum/figure_info/diplomat,\
/datum/figure_info/musician,\
/datum/figure_info/salesman,\
/datum/figure_info/union_rep,\
/datum/figure_info/vip,\
/datum/figure_info/actor,\
/datum/figure_info/regional_director,\
/datum/figure_info/pharmacist,\
/datum/figure_info/test_subject)

/datum/figure_info
	var/name = "staff assistant"
	var/icon_state = "assistant"
	var/list/varieties = list() // basic versions that should always be picked between (ex: hos hat/hos beret)
	var/list/rare_varieties = list() // rare versions to be picked sometimes
	var/list/alt_names = list()

	New()
		..()
		if (src.alt_names.len)
			src.name = pick(src.alt_names)

	assistant
		rare_varieties = list("assistant2")

	chef
		name = "chef"
		icon_state = "chef"

	chaplain
		name = "chaplain"
		icon_state = "chaplain"

	barman
		name = "barman"
		icon_state = "barman"

	botanist
		name = "botanist"
		icon_state = "botanist"

	janitor
		name = "janitor"
		icon_state = "janitor"

	clown
		name = "clown"
		icon_state = "clown"

	boxer
		name = "boxer"
		icon_state = "boxer"

	lawyer
		name = "lawyer"
		icon_state = "lawyer"

	barber
		name = "barber"
		icon_state = "barber"

	mailman
		name = "mailman"
		icon_state = "mailman"

	atmos
		name = "atmos technician"
		icon_state = "atmos"

	tourist
		name = "tourist"
		icon_state = "tourist"

	vice
		name = "vice officer"
		icon_state = "vice"

	inspector
		name = "inspector"
		icon_state = "inspector"

	coach
		name = "coach"
		icon_state = "coach"

	sous_chef
		name = "sous-chef"
		icon_state = "sous"

	waiter
		name = "waiter"
		icon_state = "waiter"

	apiarist
		name = "apiarist"
		icon_state = "apiarist"
		alt_names = list("apiarist", "apiculturalist")

	journalist
		name = "journalist"
		icon_state = "journalist"

	diplomat
		name = "diplomat"
		icon_state = "diplomat"
		varieties = list("diplomat", "diplomat2", "diplomat3", "diplomat4")
		alt_names = list("diplomat", "ambassador")

	musician
		name = "musician"
		icon_state = "musician"

	salesman
		name = "salesman"
		icon_state = "salesman"
		alt_names = list("salesman", "merchant")

	union_rep
		name = "union rep"
		icon_state = "union"
		alt_names = list("union rep", "assistants union rep", "cyborgs union rep", "security union rep", "doctors union rep", "engineers union rep", "miners union rep")

	vip
		name = "\improper VIP"
		icon_state = "vip"
		alt_names = list("senator", "president", "\improper CEO", "board member", "mayor", "vice-president", "governor")

	actor
		name = "\improper Hollywood actor"
		icon_state = "actor"

	regional_director
		name = "regional director"
		icon_state = "regd"

	pharmacist
		name = "pharmacist"
		icon_state = "pharma"

	test_subject
		name = "test subject"
		icon_state = "testsub"

	doctor
		name = "medical doctor"
		icon_state = "doctor"

	geneticist
		name = "geneticist"
		icon_state = "geneticist"

	roboticist
		name = "roboticist"
		icon_state = "roboticist"

	scientist
		name = "scientist"
		icon_state = "scientist"
		varieties = list("scientist", "scientist2")

	security
		name = "security officer"
		icon_state = "security"

	detective
		name = "detective"
		icon_state = "detective"

	engineer
		name = "engineer"
		icon_state = "engineer"

	mechanic
		name = "mechanic"
		icon_state = "mechanic"

	miner
		name = "miner"
		icon_state = "miner"
		rare_varieties = list("miner2")

	qm
		name = "quartermaster"
		icon_state = "qm"

	captain
		name = "captain"
		icon_state = "captain"
		rare_varieties = list("captain2")//, "captain3")

	hos
		name = "head of security"
		icon_state = "hos"

	hop
		name = "head of personnel"
		icon_state = "hop"

	md
		name = "medical director"
		icon_state = "md"

	rd
		name = "research director"
		icon_state = "rd"

	ce
		name = "chief engineer"
		icon_state = "ce"

	cyborg
		name = "cyborg"
		icon_state = "borg"
		rare_varieties = list("borg2", "borg3")

	ai
		name = "\improper AI"
		icon_state = "ai"

	traitor
		name = "traitor"
		icon_state = "traitor"

	changeling
		name = "shambling abomination"
		icon_state = "changeling"

	vampire
		name = "vampire"
		icon_state = "vampire"

	nukeop
		name = "syndicate operative"
		icon_state = "nukeop"

	wizard
		name = "wizard"
		icon_state = "wizard"
		rare_varieties = list("wizard2", "wizard3")

	wraith
		name = "wraith"
		icon_state = "wraith"

	blob
		name = "blob"
		icon_state = "blob"

	werewolf
		name = "werewolf"
		icon_state = "werewolf"

	omnitraitor
		name = "omnitraitor"
		icon_state = "omnitraitor"

	cluwne
		name = "cluwne"
		icon_state = "cluwne"

	macho
		name = "macho man"
		icon_state = "macho"
		New()
			..()
			src.name = pick("\improper M", "m") + pick("a", "ah", "ae") + pick("ch", "tch", "tz") + pick("o", "oh", "oe") + " " + pick("M","m") + pick("a","ae","e") + pick("n","nn")

	monkey
		name = "monkey"
		icon_state = "monkey"

	shitty_bill
		name = "\improper Shitty Bill"
		icon_state = "bill"

	don_glabs
		name = "\improper Donald \"Don\" Glabs"
		icon_state = "don"

	father_jack
		name = "\improper Father Jack"
		icon_state = "jack"

/obj/item/item_box/figure_capsule
	name = "capsule"
	desc = "A little plastic ball for keeping stuff in. Woah! We're truly in the future with technology like this."
	icon = 'icons/obj/figures.dmi'
	icon_state = "cap-y"
	contained_item = /obj/item/toy/figure
	item_amount = 1
	max_item_amount = 1
	//reusable = 0
	rand_pos = 1
	var/ccolor = "y"
	var/image/cap_image = null

	New()
		..()
		src.ccolor = pick("y", "r", "g", "b")
		src.update_icon()

	update_icon()
		if (src.icon_state != "cap-[src.ccolor]")
			src.icon_state = "cap-[src.ccolor]"
		if (!src.cap_image)
			src.cap_image = image(src.icon, "cap-cap[src.item_amount ? 1 : 0]")
		if (src.open)
			if (src.item_amount)
				src.cap_image.icon_state = "cap-fig"
				src.UpdateOverlays(src.cap_image, "cap")
			else
				src.UpdateOverlays(null, "cap")
		else
			src.cap_image.icon_state = "cap-cap[src.item_amount ? 1 : 0]"
			src.UpdateOverlays(src.cap_image, "cap")

/obj/machinery/vending/capsule
	name = "capsule machine"
	desc = "A little figure in every capsule, guaranteed*!"
	pay = 1
	vend_delay = 15
	icon = 'icons/obj/figures.dmi'
	icon_state = "machine1"
	icon_panel = "machine-panel"
	var/sound_vend = 'sound/machines/capsulebuy.ogg'
	var/image/capsule_image = null

	New()
		..()
		//Products
		product_list += new/datum/data/vending_product("/obj/item/item_box/figure_capsule", 26, cost=100)
		src.icon_state = "machine[rand(1,6)]"
		src.capsule_image = image(src.icon, "m_caps26")
		src.UpdateOverlays(src.capsule_image, "capsules")

	prevend_effect()
		playsound(src.loc, sound_vend, 80, 1)
		spawn(10)
			var/datum/data/vending_product/R = src.product_list[1]
			src.capsule_image.icon_state = "m_caps[R.product_amount]"
			src.UpdateOverlays(src.capsule_image, "capsules")

	powered()
		return

	use_power()
		return

	power_change()
		return
