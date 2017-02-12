
/* ================================================== */
/* -------------------- Balloons -------------------- */
/* ================================================== */

/obj/item/reagent_containers/balloon
	name = "balloon"
	desc = "Water balloon fights are a classic way to have fun in the summer. I don't know that chlorine trifluoride balloon fights hold the same appeal for most people."
	icon = 'icons/obj/balloon.dmi'
	icon_state = "balloon_white"
	inhand_image_icon = 'icons/mob/inhand/hand_balloon.dmi'
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	rc_flags = 0
	var/list/available_colors = list("white", "black", "red", "green", "blue", "orange", "pink", "yellow", "purple", "bee", "clown")
	var/balloon_color = "white"

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(40)
		reagents = R
		R.my_atom = src
		if (available_colors && available_colors.len > 0)
			balloon_color = pick(available_colors)
			update_icon()

	on_reagent_change(mob/user as mob)
		src.update_icon()
		src.burst_chance()
		if (user && ismob(user)) // I SWEAR TO GOD IF YOU GIVE ONE MORE RUNTIME I WILL JUST REWRITE THIS SHIT FROM THE GROUND UP
			user.update_inhands()
		else if (usr && ismob(usr))
			usr.update_inhands()
		else
			return

	proc/update_icon()
		if (src.reagents && src.reagents.total_volume > 0)
			if (src.reagents.has_reagent("helium"))
				src.icon_state = "balloon_[src.balloon_color]_inflated"
				src.item_state = "balloon_[src.balloon_color]_inflated"
			else
				src.icon_state = "balloon_[src.balloon_color]_full"
				src.item_state = "balloon_[src.balloon_color]_full"
		else
			src.icon_state = "balloon_[src.balloon_color]"
			src.item_state = "balloon_[src.balloon_color]"

	proc/burst_chance(mob/user as mob, var/ohshit)
		var/curse = pick("Fuck","Shit","Hell","Damn","Darn","Crap","Hellfarts","Pissdamn","Son of a-")
		if (!src.reagents)
			return
		if (!ohshit)
			ohshit = (src.reagents.total_volume / 30) * 33
		if (prob(ohshit))
			smash()
			if (user)
				user.visible_message("<span style=\"color:red\">[src] bursts in [user]'s hands!</span>", \
				"<span style=\"color:red\">[src] bursts in your hands! <b>[curse]!</b></span>")
			else if (usr)
				usr.visible_message("<span style=\"color:red\">[src] bursts in [usr]'s hands!</span>", \
				"<span style=\"color:red\">[src] bursts in your hands! <b>[curse]!</b></span>")
			else
				src.loc.visible_message("<span style=\"color:red\">[src] bursts!</span>")
			return
/*		if (src.reagents.total_volume > 30)
			if (prob(50))
				user.visible_message("<span style=\"color:red\">[src] is overfilled and bursts! <b>[curse]</b></span>")
				smash()
				return
*/
	attack_self(var/mob/user as mob)
		if (!istype(user, /mob/living/carbon/human))
			boutput(user, "<span style=\"color:blue\">You don't know what to do with the balloon.</span>")
			return
		var/mob/living/carbon/human/H = user

		var/list/actions = list()
		if (user.mind && user.mind.assigned_role == "Clown")
			actions += "Make balloon animal"
		if (src.reagents.total_volume > 0)
			actions += "Inhale"
		if (H.urine >= 2)
			actions += "Pee in it"
		if (!actions.len)
			user.show_text("You can't think of anything to do with [src].", "red")
			return

		var/action = input(user, "What do you want to do with the balloon?") as null|anything in actions

		switch (action)
			if ("Make balloon animal")
				if (src.reagents.total_volume > 0)
					user.visible_message("<b>[user]</b> fumbles with [src]!", \
					"<span style=\"color:red\">You fumble with [src]!</span>")
					src.burst_chance(user, 100)
					user.update_inhands()
				else
					if (user.losebreath)
						boutput(user, "<span style=\"color:red\">You need to catch your breath first!</span>")
						return
					var/list/animal_types = list("bee", "dog", "spider", "pie", "owl", "rockworm", "martian", "fermid", "fish")
					if (!animal_types || animal_types.len <= 0)
						user.show_text("You can't think of anything to make with [src].", "red")
						return
					var/animal = input(user, "What do you want to make?") as anything in animal_types
					if (!animal)
						user.show_text("You change your mind.")
						return
					var/fluff = pick("", "quickly ", "expertly ", "clumsily ", "somehow ", "slowly ", "carefully ")
					user.visible_message("<b>[user]</b> blows up [src] and [fluff]twists it into a[animal == "owl" ? "n" : ""] [animal]!", \
					"You blow up [src] and [fluff]twist it into a[animal == "owl" ? "n" : ""] [animal]!")
					var/obj/item/balloon_animal/A = new /obj/item/balloon_animal(get_turf(src.loc))
					A.name = "[animal]-shaped balloon"
					A.desc = "A little [animal], made out of a balloon! How spiffy!"
					A.icon_state = "animal-[animal]"
					switch (src.balloon_color)
						if ("white")
							A.color = "#FFFFFF"
						if ("clown")
							A.color = "#FFEDED"
						if ("black")
							A.color = "#333333"
						if ("red")
							A.color = "#FF0000"
						if ("green")
							A.color = "#00FF00"
						if ("blue")
							A.color = "#0000FF"
						if ("orange")
							A.color = "#FF6600"
						if ("pink")
							A.color = "#FF6EBB"
						if ("purple")
							A.color = "#AA00FF"
						if ("yellow")
							A.color = "#FFDD00"
						if ("bee")
							A.color = "#FFDD00"
					H.losebreath ++
					spawn(40)
						H.losebreath --
					qdel(src)

			if ("Inhale")
				H.visible_message("<span style=\"color:red\"><B>[H] inhales the contents of [src]!</B></span>",\
				"<span style=\"color:red\"><b>You inhale the contents of [src]!</b></span>")
				src.reagents.trans_to(H, 40)
				return

			if ("Pee in it")
				H.visible_message("<span style=\"color:red\"><B>[H] pees in [src]!</B></span>",\
				"<span style=\"color:red\"><b>You pee in [src]!</b></span>")
				playsound(H.loc, 'sound/misc/pourdrink.ogg', 50, 1)
				H.urine -= 2
				src.reagents.add_reagent("urine", 20)
				return

	afterattack(obj/target, mob/user)
		if (istype(target, /obj/reagent_dispensers) || (target.is_open_container() == -1 && target.reagents)) //A dispenser. Transfer FROM it TO us.
			if (!target.reagents.total_volume && target.reagents)
				user.show_text("[target] is empty.", "red")
				return
			if (reagents.total_volume >= reagents.maximum_volume)
				user.show_text("[src] is full.", "red")
				return
			var/transferamt = src.reagents.maximum_volume - src.reagents.total_volume
			var/trans = target.reagents.trans_to(src, transferamt)
			user.show_text("You fill [src] with [trans] units of the contents of [target].", "blue")

	ex_act(severity)
		src.smash()

	proc/smash(var/turf/T)
		if (src.reagents.total_volume < 10)
			return
		if (!T)
			T = src.loc
		src.reagents.reaction(T)
		if (ismob(T))
			T = get_turf(T)
		if (T)
			T.visible_message("<span style=\"color:red\">[src] bursts!</span>")
		playsound(T, 'sound/effects/splat.ogg', 100, 1)
		var/obj/decal/cleanable/balloon/decal = new /obj/decal/cleanable/balloon(T)
		decal.icon_state = "balloon_[src.balloon_color]_pop"
		qdel(src)

	throw_impact(var/turf/T)
		..()
		src.smash(T)

/obj/item/balloon_animal
	name = "balloon animal"
	desc = "A little animal, made out of a balloon! How spiffy!"
	icon = 'icons/obj/balloon.dmi'
	icon_state = "animal-bee"
	inhand_image_icon = 'icons/mob/inhand/hand_balloon.dmi'
	item_state = "balloon"
	w_class = 2
