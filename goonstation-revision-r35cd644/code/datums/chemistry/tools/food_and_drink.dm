
/* ============================================== */
/* -------------------- Food -------------------- */
/* ============================================== */

/obj/item/reagent_containers/food
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	var/heal_amt = 0
	var/needfork = 0
	var/needspoon = 0
	var/food_color = "#FF0000" //Color for various food items
	var/custom_food = 1 //Can it be used to make custom food like for pizzas
	var/festivity = 0
	var/antloc = null
	var/doants = 1
	var/brewable = 0 // will hitting a still with it do anything?
	var/brew_result = null // what will it make if it's brewable?
	var/unlock_medal_when_eaten = null // Add medal name here in the format of e.g. "That tasted funny".
	rc_flags = 0

	New()
		..()
		spawn(50)
			antcheck()

	proc/on_table()
		if (!isturf(src.loc)) return 0
		for (var/atom/movable/M in src.loc) //Arguably more elegant than a million locates. I don't think locate works with derived classes.
			if (istype(M, /obj/table))
				return 1
		return 0

	proc/antcheck()
		if (!doants) return
		if (isturf(src.loc) && !on_table())
			if (antloc == src.loc)
				if (prob(15))
					if (!(locate(/obj/reagent_dispensers/ants) in antloc))
						doants = 0
						new/obj/reagent_dispensers/ants(antloc)
			else
				antloc = src.loc
		spawn((600 * 5))
			antcheck()

	proc/heal(var/mob/living/M)
		var/healing = src.heal_amt

		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.sims)
				H.sims.affectMotive("hunger", heal_amt * 4.5)
				H.sims.affectMotive("bladder", -heal_amt * 1.5)

		if (quality >= 5)
			boutput(M, "<span style=\"color:blue\">That tasted amazing!</span>")
			healing *= 2

			if (hascall(M, "add_stam_mod_regen"))
				if (M:add_stam_mod_regen("consumable_good", min(10,max(1,round(quality/4))) ) )
					spawn(4000) M:remove_stam_mod_regen("consumable_good")

		if (quality <= 0.5)
			boutput(M, "<span style=\"color:red\">Ugh! That tasted horrible!</span>")
			if (prob(20))
				M.contract_disease(/datum/ailment/disease/food_poisoning, null, null, 1) // path, name, strain, bypass resist
			healing = 0

			if (hascall(M, "add_stam_mod_regen"))
				if (M:add_stam_mod_regen("consumable_bad", -2))
					spawn(4000) M:remove_stam_mod_regen("consumable_bad")

		if (!isnull(src.unlock_medal_when_eaten))
			M.unlock_medal(src.unlock_medal_when_eaten, 1)

		var/cutOff = 55
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.traitHolder && H.traitHolder.hasTrait("survivalist"))
				cutOff = 10

		if (M.health < cutOff)
			boutput(M, "<span style=\"color:red\">Your injuries are too severe to heal by nourishment alone!</span>")
		else
			M.HealDamage("All", healing, healing)
			score_foodeaten++
			M.updatehealth()

/* ================================================ */
/* -------------------- Snacks -------------------- */
/* ================================================ */

/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	amount = 3
	heal_amt = 1
	initial_volume = 100
	festivity = 0
	rc_flags = 0
	edible = 1
	module_research = list("cuisine" = 6)
	module_research_type = /obj/item/reagent_containers/food/snacks
	rand_pos = 1

/*	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/shaker))
			var/obj/item/shaker/shaker = W
			src.reagents.add_reagent("[shaker.stuff]", 2)
			shaker.shakes ++
			boutput(user, "You put some [shaker.stuff] onto [src].")
		else return ..()
*/
	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (!src.Eat(M, user))
			return ..()

	Eat(var/mob/M as mob, var/mob/user, var/bypass_utensils = 0)
		if (!src.edible)
			return 0
		if (!src.amount)
			boutput(user, "<span style=\"color:red\">None of [src] left, oh no!</span>")
			user.u_equip(src)
			qdel(src)
			return 0
		if (iscarbon(M) || istype(M, /mob/living/critter))
			if (M == user)
				if (!bypass_utensils)
					if (src.needfork && !user.find_in_hands(/obj/item/kitchen/utensil/fork))
						boutput(M, "<span style=\"color:red\">You need a fork to eat [src]!</span>")
						M.visible_message("<span style=\"color:red\">[user] stares glumly at [src].</span>")
						return
					if (src.needspoon && !user.find_in_hands(/obj/item/kitchen/utensil/spoon))
						boutput(M, "<span style=\"color:red\">You need a spoon to eat [src]!</span>")
						M.visible_message("<span style=\"color:red\">[user] stares glumly at [src].</span>")
						return
				M.visible_message("<span style=\"color:blue\">[M] takes a bite of [src]!</span>",\
				"<span style=\"color:blue\">You take a bite of [src]!</span>")
				if (reagents && reagents.total_volume)
					reagents.reaction(M, INGEST)
					reagents.trans_to(M, reagents.total_volume/(src.amount ? src.amount : 1))
				src.amount--
				M.nutrition += src.heal_amt * 10
				src.heal(M)
				playsound(M.loc,"sound/items/eatfood.ogg", rand(10,50), 1)
				on_bite(M)
				if (src.festivity)
					modify_christmas_cheer(src.festivity)
				if (!src.amount)
					M.visible_message("<span style=\"color:red\">[M] finishes eating [src].</span>",\
					"<span style=\"color:red\">You finish eating [src].</span>")
					if (istype(src, /obj/item/reagent_containers/food/snacks/plant/) && prob(35))
						var/obj/item/reagent_containers/food/snacks/plant/P = src
						var/doseed = 1
						var/datum/plantgenes/SRCDNA = P.plantgenes
						if (HYPCheckCommut(SRCDNA,"Seedless")) doseed = 0
						if (doseed)
							var/datum/plant/stored = P.planttype
							if (istype(stored) && !stored.isgrass)
								var/obj/item/seed/S
								if (stored.unique_seed) S = new stored.unique_seed(user.loc)
								else S = new /obj/item/seed(user.loc,0)
								var/datum/plantgenes/DNA = P.plantgenes
								var/datum/plantgenes/PDNA = S.plantgenes
								S.generic_seed_setup(stored)
								HYPpassplantgenes(DNA,PDNA)
								if (stored.hybrid)
									var/datum/plant/hybrid = new /datum/plant(S)
									for (var/V in stored.vars)
										if (issaved(stored.vars[V]) && V != "holder")
											hybrid.vars[V] = stored.vars[V]
									S.planttype = hybrid
								user.visible_message("<span style=\"color:blue\"><b>[user]</b> spits out a seed.</span>",\
								"<span style=\"color:blue\">You spit out a seed.</span>")
					user.u_equip(src)
					on_finish(M)
					qdel(src)
				return 1
			else
				user.tri_message("<span style=\"color:red\"><b>[user]</b> tries to feed [M] [src]!</span>",\
				user, "<span style=\"color:red\">You try to feed [M] [src]!</span>",\
				M, "<span style=\"color:red\"><b>[user]</b> tries to feed you [src]!</span>")
				logTheThing("combat", user, M, "attempts to feed %target% [src] [log_reagents(src)] at [log_loc(user)].")

				if (!do_mob(user, M))
					if (user && ismob(user))
						user.show_text("You were interrupted!", "red")
					return

				user.tri_message("<span style=\"color:red\"><b>[user]</b> feeds [M] [src]!</span>",\
				user, "<span style=\"color:red\">You feed [M] [src]!</span>",\
				M, "<span style=\"color:red\"><b>[user]</b> feeds you [src]!</span>")
				logTheThing("combat", user, M, "feeds %target% [src] [log_reagents(src)] at [log_loc(user)].")

				if (reagents && reagents.total_volume)
					reagents.reaction(M, INGEST)
					reagents.trans_to(M, reagents.total_volume)
				on_bite(M)
				src.amount--
				M.nutrition += src.heal_amt * 10
				src.heal(M)
				playsound(M.loc, "sound/items/eatfood.ogg", rand(10,50), 1)
				if (!src.amount)
					M.visible_message("<span style=\"color:red\">[M] finishes eating [src].</span>",\
					"<span style=\"color:red\">You finish eating [src].</span>")
					user.u_equip(src)
					on_finish(M)
					qdel(src)
				return 1

// I don't know if this was used for something but it was breaking my important "shake salt and pepper onto things" feature
// so it's getting commented out until I get yelled at for breaking something
//	attackby(obj/item/I as obj, mob/user as mob)
//		return
	afterattack(obj/target, mob/user , flag)
		return


	proc/on_bite(mob/eater)
		return

	proc/on_finish(mob/eater)
		return

/* ================================================ */
/* -------------------- Drinks -------------------- */
/* ================================================ */

/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drink.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	icon_state = null
	flags = FPRINT | TABLEPASS | OPENCONTAINER | SUPPRESSATTACK
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	doants = 0

	New()
		..()
		update_gulp_size()

	proc/update_gulp_size()
		//gulp_size = round(reagents.total_volume / 5)
		//if (gulp_size < 5) gulp_size = 5
		return

	on_reagent_change()
		update_gulp_size()
		doants = src.reagents && src.reagents.total_volume > 0

	on_spin_emote(var/mob/living/carbon/human/user as mob)
		if (src.reagents && src.reagents.total_volume > 0)
			user.visible_message("<span style=\"color:red\"><b>[user] spills the contents of [src] all over [him_or_her(user)]self!</b></span>")
			src.reagents.reaction(get_turf(user), TOUCH)
			src.reagents.clear_reagents()

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (istype(src, /obj/item/reagent_containers/food/drinks/bottle))
			var/obj/item/reagent_containers/food/drinks/bottle/W = src
			if (W.broken)
				return

		if (!src.reagents || !src.reagents.total_volume)
			boutput(user, "<span style=\"color:red\">Nothing left in [src], oh no!</span>")
			return 0

		if (iscarbon(M) || iscritter(M))
			if (M == user)
				M.visible_message("<span style=\"color:blue\">[M] takes a sip from [src].</span>")
			else
				user.visible_message("<span style=\"color:red\">[user] attempts to force [M] to drink from [src].</span>")
				logTheThing("combat", user, M, "attempts to force %target% to drink from [src] [log_reagents(src)] at [log_loc(user)].")

				if (!do_mob(user, M))
					if (user && ismob(user))
						user.show_text("You were interrupted!", "red")
					return
				if (!src.reagents || !src.reagents.total_volume)
					boutput(user, "<span style=\"color:red\">Nothing left in [src], oh no!</span>")
					return
				user.visible_message("<span style=\"color:red\">[user] makes [M] drink from the [src].</span>")

			if (M.mind && M.mind.assigned_role == "Barman")
				var/reag_list = ""
				for (var/current_id in reagents.reagent_list)
					var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
					if (reagents.reagent_list.len > 1 && reagents.reagent_list[reagents.reagent_list.len] == current_id)
						reag_list += " and [current_reagent.name]"
						continue
					reag_list += ", [current_reagent.name]"
				reag_list = copytext(reag_list, 3)
				boutput(M, "<span style=\"color:blue\">Tastes like there might be some [reag_list] in this.</span>")
/*			else
				var/reag_list = ""

				for (var/current_id in reagents.reagent_list)
					var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
					reag_list += "[current_reagent.taste], "

				boutput(M, "<span style=\"color:blue\">You taste [reag_list]in this.</span>")
*/
			if (src.reagents.total_volume)
				logTheThing("combat", user, M, "[user == M ? "takes a sip from" : "makes %target% drink from"] [src] [log_reagents(src)] at [log_loc(user)].")
				src.reagents.reaction(M, INGEST, gulp_size)
				spawn (5)
					if (src && src.reagents && M && M.reagents)
						src.reagents.trans_to(M, min(reagents.total_volume, gulp_size))

			playsound(M.loc,"sound/items/drink.ogg", rand(10,50), 1)
			M.urine += 0.1

			return 1

		return 0

	afterattack(obj/target, mob/user , flag)
		if (istype(target, /obj/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if (!target.reagents.total_volume)
				boutput(user, "<span style=\"color:red\">[target] is empty.</span>")
				return

			if (reagents.total_volume >= reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			var/transferamt = src.reagents.maximum_volume - src.reagents.total_volume
			var/trans = target.reagents.trans_to(src, transferamt)
			boutput(user, "<span style=\"color:blue\">You fill [src] with [trans] units of the contents of [target].</span>")

		else if (target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if (!reagents.total_volume)
				boutput(user, "<span style=\"color:red\">[src] is empty.</span>")
				return

			if (target.reagents.total_volume >= target.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[target] is full.</span>")
				return

			logTheThing("combat", user, null, "transfers chemicals from [src] [log_reagents(src)] to [target] at [log_loc(user)].") // Brought in line with beakers (Convair880).
			var/trans = src.reagents.trans_to(target, 10)
			boutput(user, "<span style=\"color:blue\">You transfer [trans] units of the solution to [target].</span>")

		return

/* =============================================== */
/* -------------------- Bowls -------------------- */
/* =============================================== */

/obj/item/reagent_containers/food/drinks/bowl
	name = "bowl"
	desc = "A bowl is a common open-top container used in many cultures to serve food, and is also used for drinking and storing other items."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "bowl"
	item_state = "zippo"
	initial_volume = 50
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO

	var/image/fluid_image = null

	New()
		..()
		fluid_image = image('icons/obj/kitchen.dmi', "fluid")

	on_reagent_change()
		src.overlays = null
		if (reagents.total_volume)
			var/datum/color/average = reagents.get_average_color()
			fluid_image.color = average.to_rgba()
			src.overlays += src.fluid_image

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/cereal_box))
			var/obj/item/reagent_containers/food/snacks/cereal_box/cbox = W

			var/obj/newcereal = new /obj/item/reagent_containers/food/snacks/soup/cereal(get_turf(src), cbox.prize)
			cbox.prize = 0
			newcereal.reagents = src.reagents

			if (newcereal.reagents)
				newcereal.reagents.my_atom = newcereal
				src.reagents = null
			else
				newcereal.reagents = new /datum/reagents(50)
				newcereal.reagents.my_atom = newcereal

			newcereal.on_reagent_change()

			user.visible_message("<b>[user]</b> pours [cbox] into [src].", "You pour [cbox] into [src].")
			cbox.amount--
			if (cbox.amount < 1)
				boutput(user, "<span style=\"color:red\">You finish off the box!</span>")
				qdel(cbox)

			qdel(src)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/tortilla_chip))
			if (reagents.total_volume)
				boutput(user, "You dip [W] into the bowl.")
				reagents.trans_to(W, 10)
			else
				boutput(user, "<span style=\"color:red\">There's nothing in the bowl to dip!</span>")

		else
			..()

/* ======================================================= */
/* -------------------- Drink Bottles -------------------- */
/* ======================================================= */

/obj/item/reagent_containers/food/drinks/bottle
	name = "bottle"
	icon = 'icons/obj/bottle.dmi'
	icon_state = "bottle"
	desc = "A stylish bottle for the containment of liquids."
	var/label = "blank" // Look in bottle.dmi for the label names
	var/labeled = 0 // For writing on the things with a pen
	var/static/image/bottle_image = null
	var/unbreakable = 0
	var/broken = 0
	var/bottle_style = "clear"
	var/fluid_style = "bottle"
	var/shatter = 0
	initial_volume = 50
	g_amt = 60
	rc_flags = RC_VISIBLE | RC_FULLNESS | RC_SPECTRO

	New()
		..()
		src.update_icon()

	on_reagent_change()
		src.update_icon()

	suicide(var/mob/user as mob)
		if (src.broken)
			user.visible_message("<span style=\"color:red\"><b>[user] slashes \his own throat with [src]!</b></span>")
			blood_slash(user, 25)
			user.TakeDamage("head", 150, 0, 0, DAMAGE_CUT)
			user.updatehealth()
			spawn(100)
				if (user)
					user.suiciding = 0
			return 1
		else return ..()

	proc/update_icon()
		src.icon_state = null
		src.overlays = null
		if (src.broken)
			src.create_reagents(0)
			if (!bottle_image) bottle_image = image('icons/obj/bottle.dmi')
			icon_state = "broken-[bottle_style]"
			if (src.label)
				bottle_image.icon_state = "label-broken-[label]"
				src.overlays += bottle_image
		else
			if (!bottle_image) bottle_image = image('icons/obj/bottle.dmi')
			if (src.reagents && src.reagents.total_volume <= 0) //Fix for cannot read null/volume. Also FUCK YOU REAGENT CREATING FUCKBUG!
				icon_state = "bottle-[bottle_style]"
				if (src.label)
					bottle_image.icon_state = "label-[label]"
					src.overlays += bottle_image
			else
				bottle_image.icon_state = "fluid-[fluid_style]"
				bottle_image.layer = FLOAT_LAYER
				for (var/current_id in reagents.reagent_list)
					var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
					if (current_reagent.reagent_state !=LIQUID) continue
					bottle_image.color = rgb(current_reagent.fluid_r, current_reagent.fluid_g, current_reagent.fluid_b)
					bottle_image.alpha = current_reagent.transparency
					src.overlays += bottle_image
				bottle_image.color = initial(bottle_image.color)
				bottle_image.alpha = initial(bottle_image.alpha)
				bottle_image.layer = initial(bottle_image.layer)
				bottle_image.icon_state = "bottle-[bottle_style]"
				src.overlays += bottle_image
				if (src.label)
					bottle_image.icon_state = "label-[label]"
					src.overlays += bottle_image
			return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/pen) && !src.labeled)
			var/t = input(user, "Enter label", src.name, null) as null|text
			t = copytext(strip_html(t), 1, 24)
			if (!t)
				return
			if (!in_range(src, usr) && src.loc != usr)
				return

			src.name = t
			src.labeled = 1
		else
			..()
			return

	attack(target as mob, mob/user as mob)
		if (src.broken && !src.unbreakable)
			force = 5.0
			throwforce = 15.0
			throw_range = 5
			w_class = 2.0
			stamina_damage = 15
			stamina_cost = 15
			stamina_crit_chance = 50
			if (src.shatter >= rand(2,12))
				var/turf/U = user.loc
				user.visible_message("<span style=\"color:red\">[src] shatters completely!</span>")
				playsound(U, pick("sound/effects/Glassbr1.ogg","sound/effects/Glassbr2.ogg","sound/effects/Glassbr3.ogg"), 100, 1)
				new /obj/item/raw_material/shard/glass(U)
				qdel(src)
				if (prob (25))
					user.visible_message("<span style=\"color:red\">The broken shards of [src] slice up [user]'s hand!</span>")
					playsound(U, "sound/effects/splat.ogg", 50, 1)
					var/damage = rand(5,15)
					random_brute_damage(user, damage)
					take_bleeding_damage(user, damage)
			else
				src.shatter++
				user.visible_message("<span style=\"color:red\"><b>[user]</b> [pick("shanks","stabs","attacks")] [target] with the broken [src]!</span>")
				logTheThing("combat", user, target, "attacks %target% with a broken [src] at [log_loc(user)].")
				playsound(target, "sound/effects/bloody_stab.ogg", 60, 1)
				var/damage = rand(1,10)
				random_brute_damage(target, damage)
				take_bleeding_damage(target, damage)
		..()

/* ========================================================== */
/* -------------------- Drinking Glasses -------------------- */
/* ========================================================== */

/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "drinking glass"
	desc = "Caution - fragile."
	icon = 'icons/obj/drink.dmi'
	icon_state = "glass-drink"
	item_state = "drink_glass"
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO
	g_amt = 30
	var/glass_style = "drink"
	var/salted = 0
	var/wedge = null
	var/umbrella = null
	var/in_glass = null
	initial_volume = 50

	var/image/fluid_image

	New()
		..()
		fluid_image = image('icons/obj/drink.dmi', "fluid-[glass_style]")
		update_icon()

	on_reagent_change()
		src.update_icon()

	proc/update_icon()
		src.overlays = null
		if (src.reagents.total_volume == 0)
			icon_state = "glass-[glass_style]"
		if (src.reagents.total_volume > 0)
			icon_state = "glass-[glass_style]1"

			var/datum/color/average = reagents.get_average_color()
			if (!fluid_image)
				fluid_image = image('icons/obj/drink.dmi', "fluid-[glass_style]")
			fluid_image.color = average.to_rgba()
			src.overlays += src.fluid_image

		if (umbrella)
			var/umbrella_icon = icon('icons/obj/drink.dmi', "[glass_style]-umbrella[umbrella]")
			src.overlays += image("icon" = umbrella_icon, "layer" = FLOAT_LAYER - 1)
		if (in_glass)
			var/in_glass_icon = icon('icons/obj/drink.dmi', "[glass_style]-[in_glass]")
			src.overlays += image("icon" = in_glass_icon, "layer" = FLOAT_LAYER - 1)
		if (salted)
			var/salted_icon = icon('icons/obj/drink.dmi', "[glass_style]-salted")
			src.overlays += image("icon" = salted_icon, "layer" = FLOAT_LAYER)
		if (wedge)
			var/wedge_icon = icon('icons/obj/drink.dmi', "[glass_style]-[wedge]")
			src.overlays += image("icon" = wedge_icon, "layer" = FLOAT_LAYER + 1)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/raw_material/ice))
			if (src.reagents.total_volume >= (src.reagents.maximum_volume - 5))
				if (user.bioHolder.HasEffect("clumsy") && prob(50))
					user.visible_message("[user] adds [W] to [src].<br><span style=\"color:red\">[src] is too full and spills!</span>",\
					"You add [W] to [src].<br><span style=\"color:red\">[src] is too full and spills!</span>")
					src.reagents.reaction(get_turf(user), TOUCH, src.reagents.total_volume / 2)
					src.reagents.add_reagent("ice", 5, null, (T0C - 1))
					qdel(W)
					return
				else
					boutput(user, "<span style=\"color:red\">[src] is too full!</span>")
				return
			else
				user.visible_message("[user] adds [W] to [src].",\
				"You add [W] to [src].")
				src.reagents.add_reagent("ice", 5, null, (T0C - 1))
				qdel(W)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/plant/orange/wedge))
			if (src.wedge)
				boutput(user, "<span style=\"color:red\">You can't add another wedge to [src], that would just look silly!!</span>")
				return
			boutput(user, "<span style=\"color:blue\">You add [W] to the lip of [src].</span>")
			src.wedge = "orange"
			src.update_icon()
			qdel(W)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/plant/lime/wedge))
			if (src.wedge)
				boutput(user, "<span style=\"color:red\">You can't add another wedge to [src], that would just look silly!!</span>")
				return
			boutput(user, "<span style=\"color:blue\">You add [W] to the lip of [src].</span>")
			src.wedge = "lime"
			src.update_icon()
			qdel(W)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/plant/lemon/wedge))
			if (src.wedge)
				boutput(user, "<span style=\"color:red\">You can't add another wedge to [src], that would just look silly!!</span>")
				return
			boutput(user, "<span style=\"color:blue\">You add [W] to the lip of [src].</span>")
			src.wedge = "lemon"
			src.update_icon()
			qdel(W)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/plant/orange) && !istype(W, /obj/item/reagent_containers/food/snacks/plant/orange/wedge))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return
			boutput(user, "<span style=\"color:blue\">You squeeze [W] into [src].</span>")
			W.reagents.trans_to(src, W.reagents.total_volume)
			qdel(W)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/plant/lime) && !istype(W, /obj/item/reagent_containers/food/snacks/plant/lime/wedge))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return
			boutput(user, "<span style=\"color:blue\">You squeeze [W] into [src].</span>")
			W.reagents.trans_to(src, W.reagents.total_volume)
			qdel(W)

		else if (istype(W, /obj/item/reagent_containers/food/snacks/plant/lemon) && !istype(W, /obj/item/reagent_containers/food/snacks/plant/lemon/wedge))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return
			boutput(user, "<span style=\"color:blue\">You squeeze [W] into [src].</span>")
			W.reagents.trans_to(src, W.reagents.total_volume)
			qdel(W)

		else if (istype(W, /obj/item/cocktail_stuff))
			if (src.umbrella || src.in_glass)
				boutput(user, "<span style=\"color:red\">There's not enough room to put that in [src]!</span>")
				return
			boutput(user, "<span style=\"color:blue\">You add [W] to [src].</span>")
			if (istype(W, /obj/item/cocktail_stuff/drink_umbrella))
				var/obj/item/cocktail_stuff/drink_umbrella/C = W
				src.umbrella = "[C.umbrella_color]"
			else if (istype(W, /obj/item/cocktail_stuff/maraschino_cherry))
				src.in_glass = "cherry"
			else if (istype(W, /obj/item/cocktail_stuff/cocktail_olive))
				src.in_glass = "olive"
			else if (istype(W, /obj/item/cocktail_stuff/celery))
				src.in_glass = "celery"
			src.update_icon()
			qdel(W)
			return

		else if (istype(W, /obj/item/shaker/salt))
			var/obj/item/shaker/salt/S = W
			if (S.shakes >= 15)
				boutput(user, "<span style=\"color:red\">There isn't enough salt in here to salt the rim!</span>")
				return
			else
				boutput(user, "<span style=\"color:blue\">You salt the rim of [src].</span>")
				src.salted = 1
				src.update_icon()
				S.shakes ++
				return

		else if (istype(W, /obj/item/reagent_containers) && W.is_open_container() && W.reagents.has_reagent("salt"))
			if (src.salted)
				return
			else if (W.reagents.get_reagent_amount("salt") >= 5)
				boutput(user, "<span style=\"color:blue\">You salt the rim of [src].</span>")
				W.reagents.remove_reagent("salt", 5)
				src.salted = 1
				src.update_icon()
				return
			else
				boutput(user, "<span style=\"color:red\">There isn't enough salt in here to salt the rim!</span>")
				return

		else if (istype(W, /obj/item/reagent_containers/food/snacks/ingredient/egg))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			boutput(user, "<span style=\"color:blue\">You crack [W] into [src].</span>")

			W.reagents.trans_to(src, W.reagents.total_volume)
			qdel(W)

		else
			return ..()

	attack_self(var/mob/user as mob)
		if (!user && usr)
			user = usr
		else if (!user && !usr) // buh?
			return ..()

		if (!ishuman(user))
			boutput(user, "<span style=\"color:blue\">You don't know what to do with the glass.</span>")
			return
		var/mob/living/carbon/human/H = user
		var/list/actions = list()
		if ((H.sims && H.sims.getValue("bladder") <= 65) || (!H.sims && H.urine >= 2))
			actions += "pee in it"
		if (src.in_glass)
			actions += "eat the [src.in_glass]"
		if (src.wedge)
			actions += "eat the [src.wedge] wedge"
		if (!actions.len)
			boutput(user, "<span style=\"color:blue\">You can't think of anything to do with the glass.</span>")
			return

		var/action = input(user, "What do you want to do with the glass?") as null|anything in actions
		var/eat_message = "thing out"
		switch (action)
			if ("pee in it")
				if ((H.sims && H.sims.getValue("bladder") <= 65) || (!H.sims && H.urine >= 2))
					H.visible_message("<span style=\"color:red\"><B>[H] pees in [src]!</B></span>")
					playsound(get_turf(H), "sound/misc/pourdrink.ogg", 50, 1)
					if (!H.sims)
						H.urine -= 2
					else
						H.sims.affectMotive("bladder", 100)
					src.reagents.add_reagent("urine", 20)
				else
					boutput(H, "<span style=\"color:red\">You don't feel like you need to go.</span>")
				return

			if ("eat the cherry")
				eat_message = "maraschino cherry out"
				src.in_glass = null
			if ("eat the olive")
				eat_message = "olive out"
				src.in_glass = null
			if ("eat the celery")
				eat_message = "celery out"
				src.in_glass = null
			if ("eat the lemon wedge")
				eat_message = "lemon wedge off"
				H.reagents.add_reagent("juice_lemon", 5)
				src.wedge = null
			if ("eat the lime wedge")
				eat_message = "lime wedge off"
				H.reagents.add_reagent("juice_lime", 5)
				src.wedge = null
			if ("eat the orange wedge")
				eat_message = "orange wedge off"
				H.reagents.add_reagent("juice_orange", 5)
				src.wedge = null

		H.visible_message("<B>[H]</B> plucks the [eat_message] of [src] and eats it.")
		playsound(H.loc, "sound/items/eatfood.ogg", rand(10,50), 1)
		src.update_icon()
		return

	ex_act(severity)
		src.smash()

	proc/smash(var/turf/T)
		if (!T)
			T = src.loc
		src.reagents.reaction(T)
		if (ismob(T))
			T = get_turf(T)
		if (!T)
			qdel(src)
			return

		T.visible_message("<span style=\"color:red\">[src] shatters!</span>")
		playsound(T, pick("sound/effects/Glassbr1.ogg","sound/effects/Glassbr2.ogg","sound/effects/Glassbr3.ogg"), 100, 1)
		new /obj/item/raw_material/shard/glass(T)
		if (src.umbrella)
			var/obj/item/cocktail_stuff/drink_umbrella/C = new /obj/item/cocktail_stuff/drink_umbrella(T)
			C.umbrella_color = src.umbrella
			C.update_icon()
		if (src.in_glass)
			if (src.in_glass == "cherry")
				new /obj/item/cocktail_stuff/maraschino_cherry(T)
			if (src.in_glass == "olive")
				new /obj/item/cocktail_stuff/cocktail_olive(T)
			if (src.in_glass == "celery")
				new /obj/item/cocktail_stuff/celery(T)
		if (src.wedge)
			if (src.wedge == "lemon")
				new /obj/item/reagent_containers/food/snacks/plant/lemon/wedge(T)
			if (src.wedge == "lime")
				new /obj/item/reagent_containers/food/snacks/plant/lime/wedge(T)
			if (src.wedge == "orange")
				new /obj/item/reagent_containers/food/snacks/plant/orange/wedge(T)
		qdel(src)

	throw_impact(var/turf/T)
		..()
		src.smash(T)

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/food/drinks/drinkingglass/shot
	name = "shot glass"
	icon_state = "glass-shot"
	glass_style = "shot"
	amount_per_transfer_from_this = 15
	gulp_size = 15
	initial_volume = 15

/obj/item/reagent_containers/food/drinks/drinkingglass/wine
	name = "wine glass"
	icon_state = "glass-wine"
	glass_style = "wine"
	initial_volume = 30

/obj/item/reagent_containers/food/drinks/drinkingglass/cocktail
	name = "cocktail glass"
	icon_state = "glass-cocktail"
	glass_style = "cocktail"
	initial_volume = 20

/obj/item/reagent_containers/food/drinks/drinkingglass/flute
	name = "champagne flute"
	icon_state = "glass-flute"
	glass_style = "flute"
	initial_volume = 20

/* ============================================== */
/* -------------------- Misc -------------------- */
/* ============================================== */

/obj/item/reagent_containers/food/drinks/skull_chalice
	name = "skull chalice"
	desc = "A thing which you can drink fluids out of. Um. It's made from a skull. Considering how many holes are in skulls, this is perhaps a questionable design."
	icon_state = "skullchalice"
	item_state = "skullchalice"
	rc_flags = RC_SPECTRO

/obj/item/reagent_containers/food/drinks/mug
	name = "mug"
	desc = "A standard mug, for coffee or tea or whatever you wanna drink."
	icon_state = "mug"
	item_state = "mug"
	rc_flags = RC_SPECTRO

/obj/item/reagent_containers/food/drinks/mug/random_color
	New()
		..()
		src.color = random_saturated_hex_color(1)

/obj/item/reagent_containers/food/drinks/paper_cup
	name = "paper cup"
	desc = "A cup made of paper. It's not that complicated."
	icon_state = "paper_cup"
	item_state = "drink_glass"
	rc_flags = RC_SPECTRO
	initial_volume = 15

/obj/item/reagent_containers/food/drinks/pitcher
	name = "glass pitcher"
	desc = "A big container for holding a lot of liquid that you then serve to people. Probably alcohol, let's be honest."
	icon_state = "pitcher"
	item_state = "drink_glass"
	initial_volume = 120
	var/image/fluid_image

	New()
		..()
		fluid_image = image(src.icon, "fluid-pitcher")
		update_icon()

	on_reagent_change()
		src.update_icon()

	proc/update_icon()
		src.overlays = null
		if (src.reagents.total_volume == 0)
			icon_state = "pitcher"
		if (src.reagents.total_volume > 0)
			icon_state = "pitcher1"

			var/datum/color/average = reagents.get_average_color()
			if (!fluid_image)
				fluid_image = image(src.icon, "fluid-pitcher")
			fluid_image.color = average.to_rgba()
			src.overlays += src.fluid_image
