// OMG SHOES

/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/item_shoes.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_feethand.dmi'
	wear_image_icon = 'icons/mob/feet.dmi'
	var/chained = 0
	compatible_species = list("human", "monkey")

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

		//cogwerks - burn vars
	burn_point = 400
	burn_output = 800
	burn_possible = 1
	health = 25
	cold_resistance = 5
	heat_resistance = 5

	var/step_sound = null

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/tank/air) || istype(W, /obj/item/tank/oxygen) || istype(W, /obj/item/tank/emergency_oxygen) || istype(W, /obj/item/tank/jetpack))
			var/uses = 0

			if(istype(W, /obj/item/tank/emergency_oxygen)) uses = 2
			else if(istype(W, /obj/item/tank/air)) uses = 4
			else if(istype(W, /obj/item/tank/oxygen)) uses = 4
			else if(istype(W, /obj/item/tank/jetpack)) uses = 6

			var/turf/T = get_turf(user)
			var/obj/item/clothing/shoes/rocket/R = new/obj/item/clothing/shoes/rocket(T)
			R.uses = uses
			boutput(user, "<span style=\"color:blue\">You haphazardly kludge together some rocket shoes.</span>")
			qdel(W)
			qdel(src)

/obj/item/clothing/shoes/rocket
	name = "rocket shoes"
	desc = "A gas tank taped to some shoes. Brilliant. They also look kind of silly."
	icon_state = "rocketshoes"
	protective_temperature = 0
	movement_speed_mod = 1
	var/uses = 6
	burn_possible = 0
	module_research = list("efficiency" = 10)

/obj/item/clothing/shoes/sonic
	name = "Sahnic the Bushpig's Shoes"
	icon_state = "red"
	desc = "Have got to go swiftly."
	var/soniclevel = 9.999
	var/soniclength = 50
	var/sonicbreak = 0
	movement_speed_mod = -10

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/sonic/abilities = list(/obj/ability_button/sonic)

/obj/ability_button/sonic
	name = "Activate Shoes"
	icon_state = "rocketshoes"

	Click()
		if(!the_item || !the_mob || !the_mob.canmove) return
		var/obj/item/clothing/shoes/sonic/R = the_item

		if(the_mob:shoes != the_item)
			boutput(the_mob, "<span style=\"color:red\">You must be wearing the shoes to use them.</span>")
			return

		playsound(get_turf(the_mob), "sound/effects/bamf.ogg", 100, 1)

		spawn(0)
			for(var/i=0, i<R.soniclength, i++)
				if(!the_mob) break
				new/obj/effect/smoketemp(the_mob.loc)
				if (!step(the_mob, the_mob.dir) && R.sonicbreak) break
				sleep(10 - R.soniclevel)

/obj/effect/smoketemp
	name = "smoke"
	density = 0
	anchored = 0
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"

	New(var/atom/locnew)
		src.set_loc(locnew)
		spawn(10)
			src.set_loc(null)

/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	desc = "These shoes somewhat protect you from fire."

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	icon_state = "brown"
	desc = "Brown shoes, camouflage on this kind of station."

/obj/item/clothing/shoes/red
	name = "red shoes"
	icon_state = "red"

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blu"

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	desc = "Shoes, now in prisoner orange! Can be made into shackles."

/obj/item/clothing/shoes/pink
	name = "pink shoes"
	icon_state = "pink"

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	if (src.chained)
		src.chained = null
		src.cant_self_remove = 0
		new /obj/item/handcuffs(get_turf(user))
		src.name = "orange shoes"
		src.icon_state = "orange"
		src.desc = "Shoes, now in prisoner orange! Can be made into shackles."
	return

/obj/item/clothing/shoes/orange/attackby(H as obj, loc)
	if (istype(H, /obj/item/handcuffs) && !src.chained)
		qdel(H)
		src.chained = 1
		src.cant_self_remove = 1
		src.name = "shackles"
		src.desc = "Used to restrain prisoners."
		src.icon_state = "orange1"
	return

/obj/item/clothing/shoes/magnetic
	name = "magnetic shoes"
	desc = "Keeps the wearer firmly anchored to the ground. Provided the ground is metal, of course."
	icon_state = "magboots"
	c_flags = NOSLIP
	permeability_coefficient = 0.05
	mats = 8
	burn_possible = 0
	module_research = list("efficiency" = 5, "engineering" = 5)

/obj/item/clothing/shoes/industrial
	name = "mechanised boots"
	desc = "Industrial-grade boots fitted with mechanised balancers and stabilisers to increase running speed under a heavy workload."
	icon_state = "indboots"
	permeability_coefficient = 0.05
	mats = 12
	movement_speed_mod = -3
	burn_possible = 0
	module_research = list("efficiency" = 5, "engineering" = 5, "mining" = 10)

/obj/item/clothing/shoes/white
	name = "white shoes"
	desc = "Protects you against biohazards that would enter your feet."
	icon_state = "white"
	permeability_coefficient = 0.25

/obj/item/clothing/shoes/galoshes
	name = "galoshes"
	desc = "Rubber boots that prevent slipping on wet surfaces."
	icon_state = "galoshes"
	c_flags = NOSLIP
	permeability_coefficient = 0.05

/obj/item/clothing/shoes/clown_shoes
	name = "clown shoes"
	desc = "Damn, thems some big shoes."
	icon_state = "clown"
	item_state = "clown_shoes"
	step_sound = "clownstep"
	module_research = list("audio" = 5)

/obj/item/clothing/shoes/flippers
	name = "flippers"
	desc = "A pair of rubber flippers that improves swimming ability when worn."
	icon_state = "flippers"
	permeability_coefficient = 0.05

/obj/item/clothing/shoes/moon
	name = "moon shoes"
	desc = "Recent developments in trampoline-miniaturization technology have made these little wonders possible."
	icon_state = "moonshoes"
	mats = 2

	equipped(var/mob/user, var/slot)
		user.visible_message("<b>[user]</b> starts hopping around!","You start hopping around.")
		src.moonloop(user)
		return

	unequipped(var/mob/user)
		user.pixel_y = 0
		..()
		return

	proc/moonloop(var/mob/user)
		spawn(0)
			while(user && !user.stat && user:shoes == src)
				if(user.pixel_y < 12)
					user.pixel_y += 3
					sleep(1)
				else
					user.pixel_y -= 6
					sleep(1)

			if(user)
				user.pixel_y = 0
		return

/obj/item/clothing/shoes/cowboy
	name = "Cowboy boots"
	icon_state = "cowboy"

/obj/item/clothing/shoes/sandal
	name = "magic sandals"
	desc = "They magically stop you from slipping on magical hazards. It's not the mesh on the underside that does that. It's MAGIC. Read a fucking book."
	icon_state = "wizard"
	c_flags = NOSLIP
	magical = 1

	handle_other_remove(var/mob/source, var/mob/living/carbon/human/target)
		. = ..()
		if (prob(75))
			source.show_message(text("<span style=\"color:red\">\The [src] writhes in your hands as though they are alive! They just barely wriggle out of your grip!</span>"), 1)
			. = 0

/obj/item/clothing/shoes/tourist
	name = "flip-flops"
	desc = "These cheap sandals don't look very comfortable."
	icon_state = "tourist"
	protective_temperature = 0
	heat_transfer_coefficient = 1
	permeability_coefficient = 1
	siemens_coefficient = 1

/obj/item/clothing/shoes/detective
	name = "worn boots"
	desc = "This pair of leather boots has seen better days."
	icon_state = "detective"

/obj/item/clothing/shoes/chef
	name = "chef's clogs"
	desc = "Sturdy shoes that minimize injury from falling objects or knives."
	icon_state = "chef"
	armor_value_melee = 1
	permeability_coefficient = 0.30

/obj/item/clothing/shoes/swat
	name = "military boots"
	desc = "Polished and very shiny military boots."
	icon_state = "swat"
	armor_value_melee = 1.5
	permeability_coefficient = 0.20
	protective_temperature = 1250
	heat_transfer_coefficient = 0.03