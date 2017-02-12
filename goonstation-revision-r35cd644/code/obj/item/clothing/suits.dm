// SUITS

/obj/item/clothing/suit
	name = "leather jacket"
	desc = "Made from real Space Bovine, but don't call it cowhide under penalty of Article 5.P3RG."
	icon = 'icons/obj/clothing/overcoats/item_suit.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit.dmi'
	icon_state = "ljacket"
	item_state = "ljacket"
	var/fire_resist = T0C+100
	var/over_hair = 0
	var/over_all = 0 // shows up over all other clothes/hair/etc on people
	flags = FPRINT | TABLEPASS
	armor_value_bullet = 1 // multiplier
	armor_value_melee = 2
	cold_resistance = 5
	heat_resistance = 5
	w_class = 3.0

/obj/item/clothing/suit/hoodie
	name = "hoodie"
	desc = "Nice and comfy on those cold space evenings."
	icon_state = "hoodie"
	item_state = "hoodie"
	cold_resistance = 10
	var/hood = 0

	attack_self(mob/user as mob)
		src.hood = !(src.hood)
		user.show_text("You flip [src]'s hood [src.hood ? "up" : "down"].")
		if (src.hood)
			src.over_hair = 1
			src.icon_state = "hoodie-up"
			src.item_state = "hoodie-up"
		else
			src.over_hair = 0
			src.icon_state = "hoodie"
			src.item_state = "hoodie"

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio_suit"
	item_state = "bio_suit"
	icon = 'icons/obj/clothing/overcoats/item_suit_hazard.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_hazard.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_hazard.dmi'
	var/armored = 0
	body_parts_covered = TORSO|LEGS|ARMS
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.30
	disease_resistance = 50
	cold_resistance = 15
	heat_resistance = 15
	armor_value_bullet = 1.5
	armor_value_melee = 2
	over_hair = 1

/obj/item/clothing/suit/bio_suit/attackby(obj/item/W, mob/user)
	var/turf/T = usr.loc
	if(istype(W, /obj/item/clothing/suit/armor/vest))
		boutput(usr, "<span style=\"color:blue\">You attach [W] to [src].</span>")
		if (istype(src, /obj/item/clothing/suit/bio_suit/paramedic))
			new/obj/item/clothing/suit/bio_suit/paramedic/armored(T)
		else
			new/obj/item/clothing/suit/bio_suit/armored(T)
		qdel(W)
		qdel(src)

/obj/item/clothing/suit/bio_suit/paramedic
	name = "paramedic suit"
	desc = "A protective padded suit for emergency response personnel. Offers limited thermal and biological protection."
	icon_state = "paramedic"
	item_state = "paramedic"

	permeability_coefficient = 0.1
	body_parts_covered = TORSO|LEGS|ARMS

	protective_temperature = 3000
	heat_transfer_coefficient = 0.05
	armor_value_bullet = 1.9
	armor_value_melee = 3
	over_hair = 0

/obj/item/clothing/suit/bio_suit/armored
	name = "armored bio suit"
	desc = "A suit that protects against biological contamination. Somebody slapped some armor onto the chest."
	icon_state = "armorbio"
	item_state = "armorbio"
	c_flags = ONESIZEFITSALL
	armor_value_bullet = 2.5
	armor_value_melee = 5

/obj/item/clothing/suit/bio_suit/armored/nt
	name = "\improper NT bio suit"
	desc = "An armored biosuit that protects against biological contamination and toolboxes."
	icon_state = "ntbio"
	item_state = "ntbio"
	c_flags = ONESIZEFITSALL
	armor_value_bullet = 2.5
	armor_value_melee = 5

/obj/item/clothing/suit/bio_suit/paramedic/armored
	name = "armored paramedic suit"
	desc = "A protective padded suit for emergency response personnel. Offers limited thermal and biological protection. Somebody slapped some armor onto the chest."
	icon_state = "para_armor"
	item_state = "paramedic"
	c_flags = ONESIZEFITSALL
	armor_value_bullet = 2.9
	armor_value_melee = 6

/obj/item/clothing/suit/space/suv
	name = "\improper SUV suit"
	desc = "Engineered to do some doohickey with radiation or something. Man this thing is cool."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "hev"
	item_state = "hev"
	radproof = 1
	c_flags = ONESIZEFITSALL | SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	armor_value_bullet = 3
	armor_value_melee = 5

/obj/item/clothing/suit/rad // re-added for Russian Station as there is a permarads area there!
	name = "\improper Class II radiation suit"
	desc = "An old Soviet radiation suit made of 100% space asbestos. It's good for you!"
	icon_state = "rad"
	item_state = "rad"
	icon = 'icons/obj/clothing/overcoats/item_suit_hazard.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_hazard.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_hazard.dmi'
	radproof = 1
	c_flags = ONESIZEFITSALL
	body_parts_covered = TORSO|LEGS|ARMS
	permeability_coefficient = 0.005
	heat_transfer_coefficient = 0.10
	movement_speed_mod = 0.6
	armor_value_bullet = 1.5
	armor_value_melee = 5
	over_hair = 1
	cold_resistance = 15
	heat_resistance = 30

/obj/item/clothing/suit/det_suit
	name = "coat"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det_suit"
	body_parts_covered = TORSO|LEGS|ARMS
	armor_value_bullet = 1.3
	armor_value_melee = 2

/obj/item/clothing/suit/det_suit/beepsky
	name = "worn jacket"
	desc = "This tattered jacket has seen better days."
	icon = 'icons/obj/clothing/overcoats/item_suit_armor.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_armor.dmi'
	icon_state = "ntarmor"
	armor_value_bullet = 1.3
	armor_value_melee = 2

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = TORSO|LEGS|ARMS

/obj/item/clothing/suit/chef
	name = "chef's coat"
	desc = "BuRK BuRK BuRK - Bork Bork Bork!"
	icon_state = "chef"
	item_state = "chef"
	body_parts_covered = TORSO|LEGS|ARMS
	heat_resistance = 10

/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A protective frontal garment designed to guard clothing against spills."
	icon_state = "sousapron"
	item_state = "sousapron"
	body_parts_covered = TORSO
	permeability_coefficient = 0.70

/obj/item/clothing/suit/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills and biohazards."
	icon_state = "labcoat"
	item_state = "labcoat"
	body_parts_covered = TORSO|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75
	cold_resistance = 15
	heat_resistance = 15

/obj/item/clothing/suit/labcoat/genetics
	name = "geneticist's labcoat"
	desc = "A protective laboratory coat with the green markings of a Geneticist."
	icon_state = "GNlabcoat"
	item_state = "GNlabcoat"

	april_fools
		icon_state = "GNlabcoat-alt"
		item_state = "GNlabcoat-alt"

/obj/item/clothing/suit/labcoat/robotics
	name = "roboticist's labcoat"
	desc = "A protective laboratory coat with the black markings of a Roboticist."
	icon_state = "ROlabcoat"
	item_state = "ROlabcoat"

	april_fools
		icon_state = "ROlabcoat-alt"
		item_state = "ROlabcoat-alt"

/obj/item/clothing/suit/labcoat/medical
	name = "doctor's labcoat"
	desc = "A protective laboratory coat with the red markings of a Medical Doctor."
	icon_state = "MDlabcoat"
	item_state = "MDlabcoat"

	april_fools
		icon_state = "MDlabcoat-alt"
		item_state = "MDlabcoat-alt"

/obj/item/clothing/suit/labcoat/science
	name = "scientist's labcoat"
	desc = "A protective laboratory coat with the purple markings of a Scientist."
	icon_state = "SCIlabcoat"
	item_state = "SCIlabcoat"

	april_fools
		icon_state = "SCIlabcoat-alt"
		item_state = "SCIlabcoat-alt"

/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
	desc = "A suit that totally restrains an individual."
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	body_parts_covered = TORSO|LEGS|ARMS
	cold_resistance = 20
	heat_resistance = 20

/obj/item/clothing/suit/wcoat
	name = "waistcoat"
	desc = "Style over abdominal protection."
	icon_state = "vest"
	item_state = "wcoat"
	magical = 1
	body_parts_covered = TORSO|ARMS
	cold_resistance = 10
	heat_resistance = 10

/obj/item/clothing/suit/bedsheet
	name = "bedsheet"
	desc = "A linen sheet used to cover yourself while you sleep. Preferably on a bed."
	icon_state = "bedsheet"
	item_state = "bedsheet"
	layer = MOB_LAYER
	throwforce = 1
	w_class = 1
	throw_speed = 2
	throw_range = 10
	c_flags = COVERSEYES | COVERSMOUTH
	body_parts_covered = TORSO|ARMS
	see_face = 0
	over_hair = 1
	over_all = 1
	var/eyeholes = 0 //Did we remember to cut eyes in the thing?
	var/cape = 0
	var/obj/stool/bed/Bed = null
	var/bcolor = null
	//cogwerks - burn vars
	burn_point = 450
	burn_output = 800
	burn_possible = 1
	health = 20
	cold_resistance = 10
	rand_pos = 0

	New()
		..()
		src.update_icon()
		src.setMaterial(getCachedMaterial("cotton"))

	attack_hand(mob/user as mob)
		if (src.Bed)
			src.Bed.untuck_sheet(user)
		src.Bed = null
		return ..()

	ex_act(severity)
		if (severity <= 2)
			if (src.Bed && src.Bed.Sheet == src)
				src.Bed.Sheet = null
			qdel(src)
			return
		return

	attack_self(mob/user as mob)
		add_fingerprint(user)
		var/choice = input(user, "What do you want to do with [src]?", "Selection") as null|anything in list("Place", "Rip up")
		if (!choice)
			return
		switch (choice)
			if ("Place")
				user.drop_item()
				src.layer = EFFECTS_LAYER_BASE-1
				return
			if ("Rip up")
				boutput(user, "You begin ripping up [src].")
				if (!do_after(user, 30))
					boutput(user, "<span style=\"color:red\">You were interrupted!</span>")
					return
				else
					for (var/i=3, i>0, i--)
						new /obj/item/material_piece/cloth/cottonfabric(get_turf(src))
					boutput(user, "You rip up [src].")
					user.u_equip(src)
					qdel(src)
					return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/wirecutters) || istype(W, /obj/item/scissors))
			var/list/actions = list("Make bandages")
			if (src.cape)
				actions += "Cut cable"
			else if (!src.eyeholes)
				actions += "Cut eyeholes"
			var/action = input(user, "What do you want to do with [src]?") as null|anything in actions
			if (!action)
				return
			switch (action)
				if ("Make bandages")
					boutput(user, "You begin cutting up [src].")
					if (!do_after(user, 30))
						boutput(user, "<span style=\"color:red\">You were interrupted!</span>")
						return
					else
						for (var/i=3, i>0, i--)
							new /obj/item/bandage(get_turf(src))
						playsound(src.loc, "sound/items/Scissor.ogg", 100, 1)
						boutput(user, "You cut [src] into bandages.")
						user.u_equip(src)
						qdel(src)
						return
				if ("Cut cable")
					src.cut_cape()
					playsound(src.loc, "sound/items/Scissor.ogg", 100, 1)
					boutput(user, "You cut the cable that's tying the bedsheet into a cape.")
					return
				if ("Cut eyeholes")
					src.cut_eyeholes()
					playsound(src.loc, "sound/items/Scissor.ogg", 100, 1)
					boutput(user, "You cut eyeholes in the bedsheet.")
					return

		else if (istype(W, /obj/item/cable_coil))
			if (src.cape)
				return ..()
			src.make_cape()
			boutput(user, "You tie the bedsheet into a cape.")
			return

		else
			return ..()

	proc/update_icon()
		if (src.cape)
			src.icon_state = "bedcape[src.bcolor ? "-[bcolor]" : null]"
			src.item_state = src.icon_state
			see_face = 1
			over_hair = 0
			over_all = 0
		else
			src.icon_state = "bedsheet[src.bcolor ? "-[bcolor]" : null][src.eyeholes ? "1" : null]"
			src.item_state = src.icon_state
			see_face = 0
			over_hair = 1
			over_all = 1

	proc/cut_eyeholes()
		if (src.cape || src.eyeholes)
			return
		if (src.Bed && src.Bed.loc == src.loc)
			src.Bed.untuck_sheet()
		src.Bed = null
		src.eyeholes = 1
		src.update_icon()
		desc = "It's a bedsheet with eye holes cut in it."

	proc/make_cape()
		if (src.cape)
			return
		if (src.Bed && src.Bed.loc == src.loc)
			src.Bed.untuck_sheet()
		src.Bed = null
		src.cape = 1
		src.update_icon()
		desc = "It's a bedsheet that's been tied into a cape."

	proc/cut_cape()
		if (!src.cape)
			return
		if (src.Bed && src.Bed.loc == src.loc)
			src.Bed.untuck_sheet()
		src.Bed = null
		src.cape = 0
		src.update_icon()
		desc = "A linen sheet used to cover yourself while you sleep. Preferably on a bed."

/obj/item/clothing/suit/bedsheet/red
	icon_state = "bedsheet-red"
	item_state = "bedsheet-red"
	bcolor = "red"

/obj/item/clothing/suit/bedsheet/orange
	icon_state = "bedsheet-orange"
	item_state = "bedsheet-orange"
	bcolor = "orange"

/obj/item/clothing/suit/bedsheet/yellow
	icon_state = "bedsheet-yellow"
	item_state = "bedsheet-yellow"
	bcolor = "yellow"

/obj/item/clothing/suit/bedsheet/green
	icon_state = "bedsheet-green"
	item_state = "bedsheet-green"
	bcolor = "green"

/obj/item/clothing/suit/bedsheet/blue
	icon_state = "bedsheet-blue"
	item_state = "bedsheet-blue"
	bcolor = "blue"

/obj/item/clothing/suit/bedsheet/pink
	icon_state = "bedsheet-pink"
	item_state = "bedsheet-pink"
	bcolor = "pink"

/obj/item/clothing/suit/bedsheet/black
	icon_state = "bedsheet-black"
	item_state = "bedsheet-black"
	bcolor = "black"

/obj/item/clothing/suit/bedsheet/hop
	icon_state = "bedsheet-hop"
	item_state = "bedsheet-hop"
	bcolor = "hop"

/obj/item/clothing/suit/bedsheet/captain
	icon_state = "bedsheet-captain"
	item_state = "bedsheet-captain"
	bcolor = "captain"

/obj/item/clothing/suit/bedsheet/royal
	icon_state = "bedsheet-royal"
	item_state = "bedsheet-royal"
	bcolor = "royal"

/obj/item/clothing/suit/bedsheet/psych
	icon_state = "bedsheet-psych"
	item_state = "bedsheet-psych"
	bcolor = "psych"

/obj/item/clothing/suit/bedsheet/random
	New()
		..()
		src.bcolor = pick("", "red", "orange", "yellow", "green", "blue", "pink", "black")
		src.update_icon()

/obj/item/clothing/suit/bedsheet/cape
	icon_state = "bedcape"
	item_state = "bedcape"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/red
	icon_state = "bedcape-red"
	item_state = "bedcape-red"
	bcolor = "red"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/orange
	icon_state = "bedcape-orange"
	item_state = "bedcape-orange"
	bcolor = "orange"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/yellow
	icon_state = "bedcape-yellow"
	item_state = "bedcape-yellow"
	bcolor = "yellow"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/green
	icon_state = "bedcape-green"
	item_state = "bedcape-green"
	bcolor = "green"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/blue
	icon_state = "bedcape-blue"
	item_state = "bedcape-blue"
	bcolor = "blue"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/pink
	icon_state = "bedcape-pink"
	item_state = "bedcape-pink"
	bcolor = "pink"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/black
	icon_state = "bedcape-black"
	item_state = "bedcape-black"
	bcolor = "black"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/hop
	icon_state = "bedcape-hop"
	item_state = "bedcape-hop"
	bcolor = "hop"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/captain
	icon_state = "bedcape-captain"
	item_state = "bedcape-captain"
	bcolor = "captain"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/royal
	icon_state = "bedcape-royal"
	item_state = "bedcape-royal"
	bcolor = "royal"
	cape = 1

/obj/item/clothing/suit/bedsheet/cape/psych
	icon_state = "bedcape-psych"
	item_state = "bedcape-psych"
	bcolor = "psych"
	cape = 1

// FIRE SUITS

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon = 'icons/obj/clothing/overcoats/item_suit_hazard.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_hazard.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_hazard.dmi'
	icon_state = "fire"
	item_state = "fire_suit"
	permeability_coefficient = 0.50
	body_parts_covered = TORSO|LEGS|ARMS
	cold_resistance = 20
	heat_resistance = 75

	protective_temperature = 4500
	heat_transfer_coefficient = 0.01
	armor_value_bullet = 1.5
	armor_value_melee = 3

/obj/item/clothing/suit/fire/armored
	name = "armored firesuit"
	desc = "A suit that protects against fire and heat. Somebody slapped some armor onto the chest."
	icon_state = "fire_armor"
	item_state = "fire_suit"
	armor_value_bullet = 2.5
	armor_value_melee = 6

/obj/item/clothing/suit/fire/attackby(obj/item/W, mob/user)
	var/turf/T = user.loc
	if (istype(W, /obj/item/clothing/suit/armor/vest))
		if (istype(src, /obj/item/clothing/suit/fire/heavy) || istype(src, /obj/item/clothing/suit/fire/old))
			return
		else
			new /obj/item/clothing/suit/fire/armored(T)
		boutput(user, "<span style=\"color:blue\">You attach [W] to [src].</span>")
		qdel(W)
		qdel(src)

/obj/item/clothing/suit/fire/heavy
	name = "heavy firesuit"
	desc = "A suit that protects against extreme fire and heat."
	icon_state = "thermal"
	item_state = "thermal"

	protective_temperature = 100000
	heat_transfer_coefficient = 0.001
	armor_value_bullet = 1.8
	armor_value_melee = 4

/obj/item/clothing/suit/fire/old
	name = "old firesuit"
	desc = "Just looking at this thing makes your eyes take burn damage."
	icon_state = "fire_old"
	item_state = "fire_old"

// SWEATERS

/obj/item/clothing/suit/sweater
	name = "diamond sweater"
	desc = "A pretty warm-looking knit sweater. This is one of those I.N. designer sweaters."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "sweater_blue"
	item_state = "sweater_blue"
	heat_transfer_coefficient = 0.25
	body_parts_covered = TORSO|ARMS
	cold_resistance = 20

	red
		name = "reindeer sweater"
		icon_state = "sweater_red"
		item_state = "sweater_red"

	green
		name = "snowflake sweater"
		icon_state = "sweater_green"
		item_state = "sweater_green"

	grandma
		name = "grandma sweater"
		icon_state = "sweater_green"
		item_state = "sweater_green"
		desc = "A pretty warm-looking knit sweater, made by your grandma.  Yes, YOUR grandma!  Even if you stole this from someone else."

		New()
			..()
			spawn(20)
				src.name = initial(src.name)
				src.material = new /datum/material/fabric/cloth/cotton ()


// SPACE SUITS

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments."
	icon = 'icons/obj/clothing/overcoats/item_suit_hazard.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_hazard.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_hazard.dmi'
	icon_state = "space"
	item_state = "s_suit"
	c_flags = SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02
	armor_value_bullet = 1.5
	armor_value_melee = 3
	disease_resistance = 50
	cold_resistance = 50
	heat_resistance = 20
	over_hair = 1

/obj/item/clothing/suit/space/emerg
	name = "emergency suit"
	desc = "A suit that protects against low pressure environments for a short time."
	icon_state = "emerg"
	item_state = "emerg"
	c_flags = SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	permeability_coefficient = 0.04
	protective_temperature = 800
	heat_transfer_coefficient = 0.025
	var/rip = 0

	snow // bleh whatever!!!
		name = "snow suit"
		desc = "A thick padded suit that protects against extreme cold temperatures."
		icon_state = "snowcoat"
		item_state = "snowcoat"
		rip = -1

/obj/item/clothing/suit/space/emerg/proc/ripcheck(var/mob/user)
	if(rip >= 14 && rip != -1 && prob(10))
		boutput(user, "<span style=\"color:red\">The emergency suit tears off!</span>")
		var/turf/T = src.loc
		if (ismob(T))
			T = T.loc
		src.set_loc(T)
		user.u_equip(src)
		spawn(5)
			qdel(src)

/obj/item/clothing/suit/space/captain
	name = "captain's space suit"
	desc = "A suit that protects against low pressure environments and is green."
	icon_state = "spacecap"
	item_state = "spacecap"

	blue
		icon_state = "spacecap-blue"
		item_state = "spacecap-blue"

	red
		icon_state = "spacecap-red"
		item_state = "spacecap-red"

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A suit that protects against low pressure environments. Issued to syndicate operatives."
	contraband = 3

/obj/item/clothing/suit/space/engineer
	name = "engineering space suit"
	desc = "An overly bulky space suit designed mainly for maintenance and mining."
	icon_state = "espace"
	item_state = "es_suit"

	april_fools
		icon_state = "espace-alt"
		item_state = "espace-alt"

/obj/item/clothing/suit/space/industrial
	name = "industrial space armor"
	desc = "Very heavy armour for prolonged industrial activity. Protects from radiation and explosions."
	icon_state = "indus"
	item_state = "indus"
	radproof = 1
	c_flags = SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	heat_transfer_coefficient = 0.02
	mats = 15
	armor_value_bullet = 1
	armor_value_melee = 2
	armor_value_explosion = 4
	cold_resistance = 75
	heat_resistance = 50

	syndicate
		name = "\improper Syndicate command armor"
		desc = "An armored space suit, not for your average expendable chumps. No sir."
		icon_state = "indusred"
		item_state = "indusred"

/obj/item/clothing/suit/cultist
	name = "cultist robe"
	desc = "The unholy vestments of a cultist."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "cultist"
	item_state = "cultist"
	see_face = 0
	magical = 1
	c_flags = COVERSEYES | COVERSMOUTH | SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	armor_value_bullet = 1.5
	armor_value_melee = 3

/obj/item/clothing/suit/cardboard_box
	name = "cardboard box"
	desc = "A pretty large box, made of cardboard. Looks a bit worn out."
	icon_state = "c_box"
	item_state = "c_box"
	density = 1
	see_face = 0
	over_hair = 1
	over_all = 1
	c_flags = COVERSEYES | COVERSMOUTH
	body_parts_covered = HEAD|TORSO|LEGS|ARMS
	movement_speed_mod = 0.7
	permeability_coefficient = 0.8
	heat_transfer_coefficient = 0.5
	armor_value_bullet = 1
	armor_value_melee = 1
	var/eyeholes = 0
	var/moustache = 0

	attack_hand(mob/user as mob)
		if (user.a_intent == INTENT_HARM)
			user.visible_message("<span style='color:blue'>[user] taps [src].</span>",\
			"<span style='color:blue'>You tap [src].</span>")
		else
			return ..()

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/wirecutters) || istype(W, /obj/item/scissors))
			if (src.eyeholes)
				user.show_text("\The [src] already has eyeholes cut out of it!", "red")
				return
			user.visible_message("<span style='color:blue'>[user] begins cutting eyeholes out of [src].</span>",\
			"<span style='color:blue'>You begin cutting eyeholes out of [src].</span>")
			if (!do_after(user, 20))
				user.show_text("You were interrupted!", "red")
				return
			playsound(get_turf(src), "sound/items/Scissor.ogg", 100, 1)
			user.visible_message("<span style='color:blue'>[user] cuts eyeholes out of [src].</span>",\
			"<span style='color:blue'>You cut eyeholes out of [src].</span>")
			src.eyeholes = 1
			src.icon_state = "[initial(src.icon_state)]e"
			return
		else if (istype(W, /obj/item/clothing/mask/moustache))
			src.moustache = 1
			src.UpdateOverlays(image(src.icon, "c_box-moustache"), "moustache")
			if (src.wear_image)
				src.wear_image.overlays += image(src.wear_image_icon, "c_box-moustache")
			user.visible_message("<span style='color:blue'>[user] adds [W] to [src]!</span>",\
			"<span style='color:blue'>You add [W] to [src]!</span>")
			user.u_equip(W)
			qdel(W)
			return
		else
			return ..()

/obj/item/clothing/suit/cardboard_box/head_surgeon
	name = "cardboard box - 'Head Surgeon'"
	desc = "The HS looks a lot different today!"
	icon_state = "c_box-HS"
	item_state = "c_box-HS"
	var/text2speech = 1

	New()
		..()
		if (prob(50))
			new /obj/machinery/bot/medbot/head_surgeon(src.loc)
			qdel(src)

	proc/speak(var/message)
		if (!message)
			return
		src.audible_message("<span class='game say'><span class='name'>[src]</span> [pick("rustles", "folds", "womps", "boxes", "foffs", "flaps")], \"[message]\"")
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

/obj/item/clothing/suit/cardboard_box/captain
	name = "cardboard box - 'Captain'"
	desc = "The Captain looks a lot different today!"
	icon_state = "c_box-cap"
	item_state = "c_box-cap"

/obj/item/clothing/suit/wizrobe
	name = "blue wizard robe"
	desc = "A traditional blue wizard's robe. It lacks all the stars and moons and stuff on it though."
	icon_state = "wizard"
	item_state = "wizard"
	magical = 1
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.01
	body_parts_covered = TORSO|LEGS|ARMS
	contraband = 4

	handle_other_remove(var/mob/source, var/mob/living/carbon/human/target)
		. = ..()
		if ( . &&prob(75))
			source.show_message(text("<span style=\"color:red\">\The [src] writhes in your hands as though it is alive! It just barely wriggles out of your grip!</span>"), 1)
			.  = 0

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A very fancy and elegant red robe with gold trim."
	icon_state = "wizardred"
	item_state = "wizardred"

/obj/item/clothing/suit/wizrobe/purple
	name = "purple wizard robe"
	desc = "A real nice robe and cape, in purple, with blue and yellow accents."
	icon_state = "wizardpurple"
	item_state = "wizardpurple"

/obj/item/clothing/suit/wizrobe/necro
	name = "necromancer robe"
	desc = "A ratty stinky black robe for wizards who are trying way too hard to be menacing."
	icon_state = "wizardnec"
	item_state = "wizardnec"
