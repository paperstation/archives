
/* ================================================= */
/* -------------------- Patches -------------------- */
/* ================================================= */

/obj/item/reagent_containers/patch
	name = "patch"
	desc = "A small adhesive chemical pouch, for application to the skin."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "patch"
	var/image/fluid_image
	var/medical = 0
	var/borg = 0
	var/style = "patch"
	initial_volume = 40
	rc_flags = RC_SPECTRO		// only spectroscopic analysis
	module_research = list("medicine" = 1, "science" = 1)
	module_research_type = /obj/item/reagent_containers/patch
	var/in_use = 0

	New()
		..()
		fluid_image = image('icons/obj/chemical.dmi', "[src.style]-fluid")

	on_reagent_change()
		src.underlays = null
		if (reagents.total_volume)
			icon_state = "[src.style]1"
			if (medical == 1)
				icon_state = "[src.style]_med1"
			if (reagents.has_reagent("LSD",1))
				icon_state = "[src.style]_LSD"

			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.underlays += src.fluid_image

		else
			icon_state = "[src.style]"
			if (medical == 1)
				icon_state = "[src.style]_med"

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (src.medical == 1)
			if (user)
				user.show_text("The patch is sealed already.", "red")
			return 0
		else
			if (user && E)
				user.show_text("You press on the patch with [E]. The current from [E] closes the tamper-proof seal.", "blue")
			src.medical = 1
			return 1

	attackby(obj/item/W as obj, mob/user as mob)
		return

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob)
		if (src.in_use)
			//DEBUG("[src] in use")
			return

		if (src.borg == 1 && !issilicon(user))
			user.show_text("This item is not designed with organic users in mind.", "red")
			return

		// No src.reagents check here because empty patches can be used to counteract bleeding.
		src.in_use = 1

		if (iscarbon(M) || iscritter(M))
			if (M == user)
				M.show_text("You put [src] on your arm.", "blue")
			else
				if (medical == 0)
					user.visible_message("<span style=\"color:red\"><b>[user]</b> is trying to stick [src] to [M]'s arm!</span>",\
					"<span style=\"color:red\">You try to stick [src] to [M]'s arm!</span>")
					logTheThing("combat", user, M, "tries to apply a patch [log_reagents(src)] to %target% at [log_loc(user)].")

					if (!do_mob(user, M))
						if (user && ismob(user))
							user.show_text("You were interrupted!", "red")
						src.in_use = 0
						return
					// No src.reagents check here because empty patches can be used to counteract bleeding.

					user.visible_message("<span style=\"color:red\"><b>[user]</b> sticks [src] to [M]'s arm.</span>",\
					"<span style=\"color:red\">You stick [src] to [M]'s arm.</span>")

				else if (borg == 1)
					user.visible_message("<span style=\"color:blue\"><b>[user]</b> stamps [src] on [M].</span>",\
					"<span style=\"color:blue\">You stamp [src] on [M].</span>")
					if (user.mind && user.mind.objectives && M.health < 90) //might as well let people complete this even if they're borged
						for (var/datum/objective/crew/medicaldoctor/heal/H in user.mind.objectives)
							H.patchesused ++

				else
					user.visible_message("<span style=\"color:blue\"><b>[user]</b> applies [src] to [M].</span>",\
					"<span style=\"color:blue\">You apply [src] to [M].</span>")
					if (user.mind && user.mind.objectives && M.health < 90)
						for (var/datum/objective/crew/medicaldoctor/heal/H in user.mind.objectives)
							H.patchesused ++

			logTheThing("combat", user, M, "applies a patch to %target% [log_reagents(src)] at [log_loc(user)].")
			repair_bleeding_damage(M, 66, 1)

			if (reagents && reagents.total_volume)
				reagents.reaction(M, TOUCH)
				spawn(5)
					if (borg == 0)
						reagents.trans_to(M, reagents.total_volume/2) // Patches should primarily be for topically drugs (Convair880).
						src.in_use = 0
						qdel(src)
					else
						var/datum/reagents/R = new
						reagents.copy_to(R)
						R.trans_to(M, reagents.total_volume/2)
						src.in_use = 0

			else
				if (borg == 0)
					src.in_use = 0
					qdel(src)

			src.in_use = 0
			return 1

		src.in_use = 0
		return 0

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/patch/bruise
	name = "styptic powder patch"
	desc = "Heals brute damage wounding."
	medical = 1

	New()
		..()
		reagents.add_reagent("stypic_powder", 40)

/obj/item/reagent_containers/patch/bruise/medbot
	name = "tissue reapplication stamp"
	borg = 1

/obj/item/reagent_containers/patch/burn
	name = "silver sulfadiazine patch"
	desc = "Heals burn damage wounding."
	medical = 1

	New()
		..()
		reagents.add_reagent("silver_sulfadiazine", 40)

/obj/item/reagent_containers/patch/burn/medbot
	name = "post-incendary dermal repair stamp"
	borg = 1

/obj/item/reagent_containers/patch/synthflesh
	name = "synthflesh patch"
	desc = "Heals both brute and burn damage wounding."
	medical = 1

	New()
		..()
		reagents.add_reagent("synthflesh", 40)

/obj/item/reagent_containers/patch/synthflesh/medbot
	name = "skin soothing ultra-damage repair stamp"
	borg = 1

/obj/item/reagent_containers/patch/nicotine
	name = "nicotine patch"
	desc = "Satisfies the needs of nicotine addicts."

	New()
		..()
		reagents.add_reagent("nicotine", 10)

/obj/item/reagent_containers/patch/LSD
	name = "blotter"
	desc = "What is this?"
	icon_state = "patch_LSD"
	module_research = list("vice" = 10)

	New()
		..()
		reagents.add_reagent("LSD", 20)

	cyborg
		borg = 1

/obj/item/reagent_containers/patch/vr
	icon = 'icons/effects/VR.dmi'

	on_reagent_change()
		return

/obj/item/reagent_containers/patch/vr/bruise
	name = "healing patch"
	desc = "Heals brute damage wounding."
	icon_state = "patch_med-brute"
	medical = 1

	New()
		var/datum/reagents/R = new/datum/reagents(40)
		reagents = R
		R.my_atom = src
		R.add_reagent("stypic_powder", 20)

/obj/item/reagent_containers/patch/vr/burn
	name = "burn patch"
	desc = "Heals burn damage wounding."
	icon_state = "patch_med-burn"
	medical = 1

	New()
		var/datum/reagents/R = new/datum/reagents(40)
		reagents = R
		R.my_atom = src
		R.add_reagent("silver_sulfadiazine",20)

/* ====================================================== */
/* -------------------- Mini-Patches -------------------- */
/* ====================================================== */

/obj/item/reagent_containers/patch/mini // like normal patches but smaller and cuter!!!
	name = "mini-patch"
	icon_state = "minipatch"
	style = "minipatch"
	initial_volume = 20

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/patch/mini/bruise
	name = "healing mini-patch"
	desc = "Heals brute damage wounding."
	medical = 1

	New()
		..()
		reagents.add_reagent("stypic_powder", 20)

/obj/item/reagent_containers/patch/mini/burn
	name = "burn mini-patch"
	desc = "Heals burn damage wounding."
	medical = 1

	New()
		..()
		reagents.add_reagent("silver_sulfadiazine", 20)

/obj/item/reagent_containers/patch/mini/synthflesh
	name = "skin soothing ultra-damage repair mini-patch"
	desc = "Heals both brute and burn damage wounding."
	medical = 1

	New()
		..()
		reagents.add_reagent("synthflesh", 20)

/obj/item/patch_stack
	name = "Patch Stack"
	desc = "A stack, holding patches. The top patch can be used."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "patch_stack"
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	var/list/patches = list()

	proc/update_overlay()
		overlays.len = 0
		if (patches.len)
			var/obj/item/reagent_containers/patch/P = patches[patches.len]
			if (P)
				src.overlays += image(P.icon, P.icon_state)
				name = "[initial(src.name)] ([P.name]; [patches.len] patches)"
		else
			name = initial(src.name)

	examine()
		..()
		if (patches.len)
			var/obj/item/reagent_containers/patch/P = patches[patches.len]
			if (P)
				boutput(usr, "The topmost patch is a [P.name]; [patches.len] patch(es) on the stack.")
		else
			boutput(usr, "0 patches on the stack.")

	attackby(var/obj/item/W, var/mob/user)
		if (patches.len)
			var/obj/item/reagent_containers/patch/P = patches[patches.len]
			P.attackby(W, user)

	attack_self(var/mob/user)
		if (patches.len)
			var/obj/item/reagent_containers/patch/P = patches[patches.len]
			P.loc = user.loc
			patches -= P
			update_overlay()
			boutput(user, "<span style=\"color:blue\">You remove [P] from the stack.</span>")
		else
			boutput(user, "<span style=\"color:red\">There are no patches on the stack.</span>")

	attack() //Or you're gonna literally attack someone with it. *thwonk* style
		return

	afterattack(var/atom/movable/target, var/mob/user)
		if (istype(target, /obj/item/reagent_containers/patch))
			if (target.loc != src && (!isrobot(user) || target.loc != user))
				if (istype(target.loc, /mob))
					var/mob/U = target.loc
					U.u_equip(target)
				else if (istype(target.loc, /obj/item/storage))
					var/obj/item/storage/U = target.loc
					U.contents -= target
					if (U.hud)
						U.hud.update()
				target.loc = src
				patches += target
				update_overlay()
				boutput(user, "<span style=\"color:blue\">You add [target] to the stack.</span>")
		else if (ishuman(target))
			if (patches.len)
				var/obj/item/reagent_containers/patch/P = patches[patches.len]
				patches -= P
				var/mob/living/carbon/human/H = target
				P.attack(H, user)

				update_overlay()
				spawn(60)
					update_overlay()
