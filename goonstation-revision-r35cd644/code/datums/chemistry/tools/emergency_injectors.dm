
/* =================================================== */
/* -------------------- Injectors -------------------- */
/* =================================================== */

/obj/item/reagent_containers/emergency_injector
	name = "emergency auto-injector"
	desc = "A small syringe-like thing that automatically injects its contents into someone."
	icon = 'icons/obj/chemical.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	item_state = "dnainjector"
	icon_state = "emerg_inj-orange"
	initial_volume = 10
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS
	rc_flags = RC_SCALE | RC_VISIBLE | RC_SPECTRO
	var/image/fluid_image
	var/empty = 0
	var/label = "orange" // colors available as of the moment: orange, red, blue, green, yellow, purple, black, white
	module_research = list("medicine" = 1, "science" = 1)
	module_research_type = /obj/item/reagent_containers/emergency_injector

	New()
		..()
		fluid_image = image(src.icon, "emerg_inj-fluid")

	on_reagent_change()
		src.update_icon()

	proc/update_icon()
		src.underlays = null
		if (reagents.total_volume)
			icon_state = "emerg_inj-[label]"
			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.underlays += src.fluid_image
		else
			icon_state = "emerg_inj-[label]0"

	attack(mob/M as mob, mob/user as mob)
		if (istype(M, /mob/living/carbon/human))
			if (src.empty || !src.reagents)
				boutput(user, "<span style=\"color:red\">There's nothing to inject, [src] has already been expended!</span>")
				return
			else
				if (!M.reagents)
					return
				logTheThing("combat", user, M, "injects %target% with [src] [log_reagents(src)]")
				src.reagents.trans_to(M, 10)
				user.visible_message("<span style=\"color:red\">[user] injects [M] with [src]!</span>", "<span style=\"color:red\">You inject [M] with [src]!</span>")
				playsound(M.loc, "sound/items/hypo.ogg", 40, 0)
				src.empty = 1
				return
		else
			boutput(user, "<span style=\"color:red\">You can only use [src] on people!</span>")
			return

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/emergency_injector/epinephrine
	name = "emergency auto-injector (epinephrine)"
	New()
		..()
		reagents.add_reagent("epinephrine", 10)

/obj/item/reagent_containers/emergency_injector/atropine
	name = "emergency auto-injector (atropine)"
	label = "red"
	New()
		..()
		reagents.add_reagent("atropine", 5)

/obj/item/reagent_containers/emergency_injector/charcoal
	name = "emergency auto-injector (charcoal)"
	label = "green"
	New()
		..()
		reagents.add_reagent("charcoal", 10)

/obj/item/reagent_containers/emergency_injector/saline
	name = "emergency auto-injector (saline-glucose)"
	label = "blue"
	New()
		..()
		reagents.add_reagent("saline", 10)

/obj/item/reagent_containers/emergency_injector/anti_rad
	name = "emergency auto-injector (potassium iodide)"
	label = "green"
	New()
		..()
		reagents.add_reagent("anti_rad", 10)

/obj/item/reagent_containers/emergency_injector/insulin
	name = "emergency auto-injector (insulin)"
	label = "yellow"
	New()
		..()
		reagents.add_reagent("insulin", 10)

/obj/item/reagent_containers/emergency_injector/calomel
	name = "emergency auto-injector (calomel)"
	label = "green"
	New()
		..()
		reagents.add_reagent("calomel", 5)

/obj/item/reagent_containers/emergency_injector/salicylic_acid
	name = "emergency auto-injector (salicylic acid)"
	label = "purple"
	New()
		..()
		reagents.add_reagent("salicylic_acid", 10)

/obj/item/reagent_containers/emergency_injector/spaceacillin
	name = "emergency auto-injector (spaceacillin)"
	label = "yellow"
	New()
		..()
		reagents.add_reagent("spaceacillin", 10)

/obj/item/reagent_containers/emergency_injector/antihistamine
	name = "emergency auto-injector (diphenhydramine)"
	label = "blue"
	New()
		..()
		reagents.add_reagent("antihistamine", 10)

/obj/item/reagent_containers/emergency_injector/salbutamol
	name = "emergency auto-injector (salbutamol)"
	label = "blue"
	New()
		..()
		reagents.add_reagent("salbutamol", 10)

/obj/item/reagent_containers/emergency_injector/mannitol
	name = "emergency auto-injector (mannitol)"
	label = "red"
	New()
		..()
		reagents.add_reagent("mannitol", 10)

/obj/item/reagent_containers/emergency_injector/mutadone
	name = "emergency auto-injector (mutadone)"
	label = "purple"
	New()
		..()
		reagents.add_reagent("mutadone", 10)

/obj/item/reagent_containers/emergency_injector/methamphetamine
	name = "emergency auto-injector (methamphetamine)"
	label = "white"
	New()
		..()
		reagents.add_reagent("methamphetamine", 10)

/obj/item/reagent_containers/emergency_injector/lexorin
	name = "emergency auto-injector (lexorin)"
	label = "blue"
	New()
		..()
		reagents.add_reagent("lexorin", 15)

/obj/item/reagent_containers/emergency_injector/synaptizine
	name = "emergency auto-injector (synaptizine)"
	label = "orange"
	New()
		..()
		reagents.add_reagent("synaptizine", 15)

/obj/item/reagent_containers/emergency_injector/random
	name = "emergency auto-injector (???)"
	label = "black"
	New()
		..()
		reagents.add_reagent("[pick("methamphetamine", "formaldehyde", "lipolicide", "pancuronium", "sulfonal", "morphine", "toxin", "bee", "LSD", "space_drugs", "THC", "mucus", "green_mucus")]", 10)

/obj/item/reagent_containers/emergency_injector/vr/epinephrine
	name = "emergency auto-injector (epinephrine)"
	label = "vr"
	New()
		..()
		reagents.add_reagent("epinephrine", 10)

/obj/item/reagent_containers/emergency_injector/vr/calomel
	name = "emergency auto-injector (calomel)"
	label = "vr2"
	New()
		..()
		reagents.add_reagent("calomel", 5)
