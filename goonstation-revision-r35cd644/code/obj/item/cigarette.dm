
/* ==================================================== */
/* -------------------- Cigarettes -------------------- */
/* ==================================================== */

/obj/item/clothing/mask/cigarette
	name = "cigarette"
	icon_state = "cigoff"
	item_state = "cigoff"
	force = 0
	damtype = "brute"
	throw_speed = 0.5
	w_class = 1
	armor_value_melee = 0
	cold_resistance = 0
	heat_resistance = 0
	var/lit = 0
	var/lastHolder = null
	var/exploding = 0 //Does it blow up when it goes out?
	var/flavor = null
	var/nic_free = 0
	rand_pos = 1

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(60)
		reagents = R
		R.my_atom = src
		if (src.exploding)
			if (src.flavor)
				R.add_reagent(src.flavor, 5)
			R.add_reagent("nicotine", 5)
			return
		else if (!src.nic_free)
			R.add_reagent("nicotine", 40)
			if (src.flavor)
				R.add_reagent(src.flavor, 20)
				return
		else if (src.flavor)
			R.add_reagent(src.flavor, 40)
			return

	afterattack(atom/target, mob/user, flag) // copied from the propuffs
		if (istype(target, /obj/item/reagent_containers/))
			user.visible_message("<span style=\"color:blue\"><b>[user]</b> crushes up the [src] in the [target].</span>",\
			"<span style=\"color:blue\">You crush up the [src] in the [target].</span>")
			src.reagents.trans_to(target, 5)
			qdel (src)
		else if (istype(target, /obj/item/match) && src.lit)
			target:light(user, "<span style=\"color:red\"><b>[user]</b> lights [target] with [src].</span>")
		else if (src.lit == 0 && istype(target, /obj/item) && target:burning)
			src.light(user, "<span style=\"color:red\"><b>[user]</b> lights the [src] with [target]. Goddamn.</span>")
			return
		else
			return ..()

	proc/light(var/mob/user as mob, var/message as text)
		if (src.lit == 0)
			src.lit = 1
			src.damtype = "fire"
			src.force = 3
			src.icon_state = "cigon"
			src.item_state = "cigon"
			if (user && message)
				user.visible_message(message) //user check to fix a shitton of runtime errors with the temp expose ignition method. welp. -cogwerks
			//spawn() //start fires while it's lit
				//src.process()
			if (!(src in processing_items))
				processing_items.Add(src) // we have a nice scheduler let's use that instead tia

	proc/put_out(var/mob/user as mob, var/message as text)
		if (src.lit == 1)
			src.lit = -1
			src.damtype = "brute"
			src.force = 0
			src.icon_state = "cigbutt"
			src.item_state = "cigoff"
			src.name = "cigarette butt"
			src.desc = "A cigarette butt."
			if (user && message)
				user.visible_message(message)
			if (src in processing_items)
				processing_items.Remove(src)

	temperature_expose(datum/gas_mixture/air, temperature, volume)
		if (src.lit == 0)
			if (temperature > T0C+200)
				src.visible_message("<span style=\"color:red\">The [src] ignites!</span>")
				src.light()

	ex_act(severity)
		if (src.lit == 0)
			src.visible_message("<span style=\"color:red\">The [src] ignites!</span>")
			src.light()

	attackby(obj/item/W as obj, mob/user as mob)
		if (src.lit == 0)
			if (istype(W, /obj/item/weldingtool) && W:welding)
				src.light(user, "<span style=\"color:red\"><b>[user]</b> casually lights the [src] with [W], what a badass.</span>")
				return
			else if (istype(W, /obj/item/clothing/head/cakehat) && W:on)
				src.light(user, "<span style=\"color:red\">Did [user] just light \his [src] with the [W]? Holy Shit.</span>")
				return
			else if (istype(W, /obj/item/device/igniter))
				src.light(user, "<span style=\"color:red\"><b>[user]</b> fumbles around with the [W]; a small flame erupts from the [src].</span>")
				return
			else if (istype(W, /obj/item/zippo) && W:lit)
				src.light(user, "<span style=\"color:red\">With a single flick of their wrist, [user] smoothly lights [src] with [W]. Damn they're cool.</span>")
				return
			else if ((istype(W, /obj/item/match) || istype(W, /obj/item/device/candle)) && W:lit)
				src.light(user, "<span style=\"color:red\"><b>[user]</b> lights [src] with [W].</span>")
				return
			else if (W.burning)
				src.light(user, "<span style=\"color:red\"><b>[user]</b> lights the [src] with [W]. Goddamn.</span>")
				return
			else
				return ..()
		else
			return ..() // CALL your GODDAMN PARENTS

	attack(atom/target, mob/user as mob)
		if (isliving(target))
			var/mob/living/M = target

			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				if (H.bleeding || (H.butt_op_stage == 4 && user.zone_sel.selecting == "chest"))
					if (!src.cautery_surgery(H, user, 5, src.lit))
						return ..()
			if (M.burning && src.lit == 0)
				if (M == user)
					src.light(user, "<span style=\"color:red\"><b>[user]</b> lights \his cigarette with \his OWN flaming body. That's dedication! Or crippling addiction.</span>")
				else
					src.light(user, "<span style=\"color:red\"><b>[user]</b> lights \his cigarette with [M]'s flaming body. That's cold, man. That's real cold.</span>")
			else
				..(target, user)
				if (src.lit == 1)
					src.put_out(user, "<span style=\"color:red\"><b>[user]</b> puts the [src] out on [target].</span>")
					if (ishuman(target))
						var/mob/living/carbon/human/chump = target
						if (!chump.stat)
							chump.emote("scream")

	process()
		var/atom/lastHolder = null

		//while (src.lit == 1)
		if (src.lit == 1)
			var/turf/location = src.loc
			var/atom/holder = loc
			var/isHeld = 0
			var/mob/M = null

			if (!src.exploding && prob(20)) // cigs shouldn't go out instantly dang
				if (ismob(location))
					M = location
					if(istype(M, /mob/living/carbon/human)) //HOLY DUPLICATE CODE BATMAN!!!
						var/mob/living/carbon/human/H = M
						if(H.traitHolder && H.traitHolder.hasTrait("smoker"))
							src.reagents.remove_any(1)
						else
							src.reagents.trans_to(M, 1)
							src.reagents.reaction(M, INGEST)
					else
						src.reagents.trans_to(M, 1)
						src.reagents.reaction(M, INGEST)
				else src.reagents.remove_any(1)

			else if (src.exploding)
				if (ismob(location))
					M = location
					if(istype(M, /mob/living/carbon/human)) //HOLY DUPLICATE CODE BATMAN!!!
						var/mob/living/carbon/human/H = M
						if(H.traitHolder && H.traitHolder.hasTrait("smoker"))
							src.reagents.remove_any(1)
						else
							src.reagents.trans_to(M, 1)
					else
						src.reagents.trans_to(M, 1)
				else if (src && src.reagents) //Wire: fix for Cannot execute null.remove any().
					src.reagents.remove_any(1)

			if (src.reagents.total_volume <= 0)
				if (src.exploding)
					src.lit = 0 //Let's not keep looping while we're busy blowing up, ok?
					spawn((20)+(rand(1,10)))
						var/turf/tlocation = get_turf(src.loc)
						if (tlocation)
							explosion(src, tlocation, 0, 1, 1, 2)
						else
							var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
							s.set_up(5, 1, src)
							s.start()
							playsound(src.loc, "sound/effects/Explosion1.ogg", 75, 1)
						src.visible_message("<span style=\"color:red\">The [src] explodes!</span>")

						// Added (Convair880).
						if (ismob(src.loc))
							logTheThing("bombing", null, src.loc, "A trick cigarette (held/equipped by %target%) explodes at [log_loc(src)].")
						else
							logTheThing("bombing", src.fingerprintslast, null, "A trick cigarette explodes at [log_loc(src)]. Last touched by [src.fingerprintslast ? "[src.fingerprintslast]" : "*null*"].")

						qdel(src)
					return
				else
					src.put_out(M, "<span style=\"color:red\"><b>[M]</b>'s [src] goes out.</span>")
					return
			//if (istype(location, /turf)) //start a fire if possible
			//	location.hotspot_expose(700, 5) // this doesn't seem to ever actually happen, gonna try a different setup - cogwerks
			var/turf/T = get_turf(src.loc)
			if (T)
				T.hotspot_expose(650,5)
			if (ismob(holder))
				isHeld = 1
			else
				isHeld = 0
				if (lastHolder != null)
					lastHolder = null

			if (isHeld == 1)
				lastHolder = holder
			//sleep(10)

		if (lastHolder != null)
			lastHolder = null

	dropped(mob/user as mob)
		if(!istype(src.loc, /turf)) return
		if (src.lit == 1 && !src.exploding && src.reagents.total_volume <= 20)
			src.put_out(user, "<span style=\"color:red\"><b>[user]</b> calmly drops and treads on the lit [src], putting it out instantly.</span>")
			return ..()
		else
			user.visible_message("<span style=\"color:red\"><b>[user]</b> drops the [src]. Guess they've had enough for the day.</span>")
			return ..()

/obj/item/clothing/mask/cigarette/nicofree
	name = "nicotine-free cigarette"
	desc = "Smoking without the crippling addiction and lung cancer! Warning: side effects may include loss of breath and inability to relax."
	nic_free = 1
	flavor = "capsaicin"

/obj/item/clothing/mask/cigarette/random
	desc = "A cigarette which seems to have been laced with something."

	New()
		if (all_functional_reagent_ids.len > 0)
			src.flavor = pick(all_functional_reagent_ids)
		else
			src.flavor = "nicotine"
		src.name = "[reagent_id_to_name(src.flavor)]-laced cigarette"
		..()

/obj/item/clothing/mask/cigarette/propuffs
	desc = "Pro Puffs - a new taste thrill in every cigarette."

	New()
		src.flavor = pick("silicate","antihol","mutadone","rum","mutagen","toxin","water_holy","fuel","salbutamol","haloperidol",
		"cryoxadone","cryostylane","omnizine","jenkem","vomit","carpet","charcoal","blood","cheese","bilk","atropine",
		"lexorin","teporone","mannitol","spaceacillin","saltpetre","anti_rad","insulin","gvomit","milk","colors","diluted_fliptonium",
		"something","honey_tea","tea","coffee","chocolate","guacamole","juice_pickle","vanilla","enriched_msg","egg","aranesp",
		"paper","bread","green_goop","black_goop")
		src.name = "[reagent_id_to_name(src.flavor)]-laced cigarette"
		..()

/obj/item/clothing/mask/cigarette/syndicate
	//desc = "It looks a little funny." //fucka you
	exploding = 1

// this was in the middle of plants_food_etc.dm
// WHY
/obj/item/clothing/mask/cigarette/custom
	desc = "There could be anything in this."
	flags = FPRINT|TABLEPASS|OPENCONTAINER

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(600)
		reagents = R
		R.my_atom = src

	is_open_container()
		return 1

/* ================================================= */
/* -------------------- Packets -------------------- */
/* ================================================= */

/obj/item/cigpacket
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	var/cigcount = 6
	var/cigtype = /obj/item/clothing/mask/cigarette
	var/package_style = "cigpacket"
	flags = ONBELT | TABLEPASS | FPRINT
	stamina_damage = 3
	stamina_cost = 3
	rand_pos = 1

/obj/item/cigpacket/nicofree
	name = "nicotine-free cigarette packet"
	desc = "All the perks of smoking without the addiction! Warning: Cigarettes use chemical compounds which may cause severe throat irritation."
	cigtype = /obj/item/clothing/mask/cigarette/nicofree
	icon_state = "cigpacket-b"
	package_style = "cigpacket-b"

/obj/item/cigpacket/propuffs
	name = "packet of Pro Puffs"
	desc = "A flavor surprise in each cigarette, lovingly wrapped in the finest papers."
	cigtype = /obj/item/clothing/mask/cigarette/propuffs
	icon_state = "cigpacket-r"
	package_style = "cigpacket-r"

/obj/item/cigpacket/random
	name = "odd cigarette packet"
	desc = "These don't seem to have a brand name on them."
	cigtype = /obj/item/clothing/mask/cigarette/random
	icon_state = "cigpacket-p"
	package_style = "cigpacket-p"

/obj/item/cigpacket/syndicate // cogwerks: made them more sneaky, removed the glaringly obvious name
// haine: these can just inherit the parent name and description vOv
	cigtype = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/cigpacket/proc/update_icon()
	src.overlays = null
	if (src.cigcount <= 0)
		src.icon_state = "[src.package_style]0"
		src.desc = "There aren't any cigs left, shit!"
	else
		src.icon_state = "[src.package_style]o"
		src.overlays += "cig[src.cigcount]"
	return

/* /obj/item/cigpacket/proc/update_icon() used to just be a return, with this directly below it.  ?????
/obj/item/cigpacket/update_icon()
	src.icon_state = "cigpacket[src.cigcount]"
	src.desc = "There are [src.cigcount] cigs\s left!"
	return
*/
/obj/item/cigpacket/attack_hand(mob/user as mob)
	if (user.find_in_hand(src))//r_hand == src || user.l_hand == src)
		if (src.cigcount == 0)
			user.show_text("You're out of cigs, shit! How you gonna get through the rest of the day?", "red")
			return
		else
			var/obj/item/clothing/mask/cigarette/W = new src.cigtype(user)
			user.put_in_hand_or_drop(W)
			if (src.cigcount != -1)
				src.cigcount--
		src.update_icon()
	else
		return ..()
	return

/obj/item/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1
	stamina_damage = 3
	stamina_cost = 3
	rand_pos = 1

/* ================================================== */
/* -------------------- Lighters -------------------- */
/* ================================================== */

/obj/item/matchbook
	name = "matchbook"
	desc = "A little bit of heavy paper with some matches in it, and a little strip to light them on."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbook"
	w_class = 1
	throwforce = 1
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 1
	burn_point = 220
	burn_output = 900
	burn_possible = 1
	health = 20
	var/match_amt = 6 // -1 for infinite
	rand_pos = 1

	get_desc(dist)
		if (src.match_amt == -1)
			. += "There's a whole lot of matches left."
		else if (src.match_amt >= 1)
			. += "There's [src.match_amt] match[s_es(src.match_amt, 1)] left."
		else
			. += "It's empty."

	attack_hand(mob/user as mob)
		if (user.find_in_hand(src))
			if (src.match_amt == 0)
				user.show_text("Looks like there's no matches left.", "red")
				return
			else
				var/obj/item/match/W = new /obj/item/match(user)
				user.put_in_hand_or_drop(W)
				if (src.match_amt != -1)
					src.match_amt --
			src.update_icon()
		else
			return ..()
		return

	afterattack(atom/target, mob/user as mob)
		if (istype(target, /obj/item/match))
			if (target:lit > 0)
				return
			if (target:lit == -1)
				user.show_text("You [pick("fumble", "fuss", "mess", "faff")] around with [target] and try to get it to light, but it's no use.", "red")
				return
			else if (prob(25))
				user.visible_message("<b>[user]</b> awkwardly strikes [src] on [target]. [target] breaks!",\
				"You awkwardly strike [src] on [target]. [target] breaks![prob(50) ? " [pick("Damn!", "Fuck!", "Shit!", "Crap!")]" : null]")
				playsound(user.loc, 'sound/items/matchstick_hit.ogg', 50, 1)
				target:put_out(user, 1)
				return
			else if (prob(10))
				user.visible_message("<b>[user]</b> awkwardly strikes [src] on [target]. A small flame sparks into life from the tip.",\
				"You awkwardly strike [src] on [target]. A small flame sparks into life from the tip.")
				target:light(user)
				return
			else
				user.visible_message("<b>[user]</b> awkwardly strikes [src] on [target]. Nothing happens.",\
				"You awkwardly strike [src] on [target]. Nothing happens.")
				playsound(user.loc, 'sound/items/matchstick_hit.ogg', 50, 1)
				return
		else
			return ..()

	attack()
		return

	proc/update_icon()
		if (src.match_amt == -1)
			src.icon_state = "matchbook6"
			return
		else
			src.icon_state = "matchbook[src.match_amt]"

/obj/item/match
	name = "match"
	desc = "A little stick of wood with phosphorus on the tip, for lighting fires, or making you very frustrated and not lighting fires. Either or."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match"
	w_class = 1
	throwforce = 1
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 1
	burn_point = 220
	burn_output = 600
	burn_possible = 1
	health = 10
	var/lit = 0 // -1 is burnt out/broken or otherwise unable to be lit
	var/light_mob = 0
	var/life_timer = 0
	rand_pos = 1
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(0.4)
		light.set_color(0.94, 0.69, 0.27)
		light.attach(src)
		src.life_timer = rand(15,25)

	pickup(mob/user)
		..()
		light.attach(user)

	dropped(mob/user)
		..()
		if (isturf(src.loc))
			src.put_out(user)
			user.visible_message("<span style=\"color:red\"><b>[user]</b> calmly drops and treads on the lit [src], putting it out instantly.</span>")
			return
		spawn(0)
			if (src.loc != user)
				light.attach(src)

	process()
		if (src.lit > 0)
			if (src.life_timer >= 0)
				life_timer--
			var/location = src.loc
			if (ismob(location))
				var/mob/M = location
				if (src.life_timer <= 0)
					src.put_out(M)
					if (M.find_in_hand(src))
						M.show_text("[src] burns your hand as the flame reaches the end of [src]!", "red")
						M.TakeDamage("All", 0, rand(1,5))
					return
			var/turf/T = get_turf(src.loc)
			if (T)
				T.hotspot_expose(600,5)
			if (src.life_timer <= 0)
				src.put_out()
				return
			//sleep(10)

	proc/light(var/mob/user as mob)
		src.lit = 1
		src.icon_state = "match-lit"

		playsound(user.loc, 'sound/items/matchstick_light.ogg', 50, 1)
		light.enable()

		if (!(src in processing_items))
			processing_items.Add(src)
		return

	proc/put_out(var/mob/user as mob, var/break_it = 0)
		src.lit = -1
		src.life_timer = 0
		if (break_it)
			src.icon_state = "match-broken"
			src.name = "broken match"
			if (user)
				playsound(user.loc, 'sound/items/crunch.ogg', 60, 1, 0, 2)
		else
			src.icon_state = "match-burnt"
			src.name = "burnt-out match"

		light.disable()

		if (src in processing_items)
			processing_items.Remove(src)
		return

	temperature_expose(datum/gas_mixture/air, temperature, volume)
		if (src.lit == 0)
			if (temperature > T0C+200)
				src.visible_message("<span style=\"color:red\">The [src] ignites!</span>")
				src.light()

	ex_act(severity)
		if (src.lit == 0)
			src.visible_message("<span style=\"color:red\">The [src] ignites!</span>")
			src.light()

	afterattack(atom/target, mob/user as mob)
		if (src.lit > 0)
			if (!ismob(target) && target.reagents)
				user.show_text("You heat [target].", "blue")
				target.reagents.temperature_reagents(1000,10)
				return
		else if (src.lit == -1)
			user.show_text("You [pick("fumble", "fuss", "mess", "faff")] around with [src] and try to get it to light, but it's no use.", "red")
			return
		else if (src.lit == 0)
			if (istype(target, /obj/item/match) && target:lit > 0)
				user.visible_message("<b>[user]</b> lights [src] with the flame from [target].",\
				"You light [src] with the flame from [target].")
				src.light(user)
				return
			else if (istype(target, /obj/item/clothing/mask/cigarette) && target:lit > 0)
				user.visible_message("<b>[user]</b> lights [src] with [target].",\
				"You light [src] with [target].")
				src.light(user)
				return
			else if (istype(target, /obj/item/matchbook))
				if (prob(10))
					user.visible_message("<b>[user]</b> strikes [src] on [target]. [src] breaks!",\
					"You strike [src] on [target]. [src] breaks![prob(50) ? " [pick("Damn!", "Fuck!", "Shit!", "Crap!")]" : null]")
					playsound(user.loc, 'sound/items/matchstick_hit.ogg', 50, 1)
					src.put_out(user, 1)
					return
				else if (prob(50))
					user.visible_message("<b>[user]</b> strikes [src] on [target]. A small flame sparks into life from the tip.",\
					"You strike [src] on [target]. A small flame sparks into life from the tip.")
					src.light(user)
					return
				else
					user.visible_message("<b>[user]</b> strikes [src] on [target]. Nothing happens.",\
					"You strike [src] on [target]. Nothing happens.")
					playsound(user.loc, 'sound/items/matchstick_hit.ogg', 50, 1)
					return
			else if (istype (target, /obj/item) && target:burning)
				user.visible_message("<b>[user]</b> lights [src] with the flame from [target].",\
				"You light [src] with the flame from [target].")
				src.light(user)
				return
			else
				if (prob(10))
					user.visible_message("<b>[user]</b> strikes [src] on [target]. A small flame sparks into life from the tip.[prob(50) ? " [pick("Damn", "Fuck", "Shit", "Wow")][pick("!", " that was cool!", " that was smooth!")]" : null]",\
					"You strike [src] on [target]. A small flame sparks into life from the tip.")
					src.light(user)
					return
				else if (prob(25))
					user.visible_message("<b>[user]</b> strikes [src] on [target]. [src] breaks!",\
					"You strike [src] on [target]. [src] breaks![prob(50) ? " [pick("Damn!", "Fuck!", "Shit!", "Crap!")]" : null]")
					playsound(user.loc, 'sound/items/matchstick_hit.ogg', 50, 1)
					src.put_out(user, 1)
					return
				else
					user.visible_message("<b>[user]</b> strikes [src] on [target]. Nothing happens.",\
					"You strike [src] on [target]. Nothing happens.[prob(50) ? " You feel awkward, though." : null]")
					playsound(user.loc, 'sound/items/matchstick_hit.ogg', 50, 1)
					return

	attack(mob/M as mob, mob/user as mob)
		if (ishuman(M))
			if (src.lit > 0)
				var/mob/living/carbon/human/fella = M
				if (fella.wear_mask && istype(fella.wear_mask, /obj/item/clothing/mask/cigarette))
					var/obj/item/clothing/mask/cigarette/smoke = fella.wear_mask // aaaaaaa
					smoke.light(user, "<span style=\"color:red\"><b>[user]</b> lights [fella]'s [smoke] with [src].</span>")
					fella.set_clothing_icon_dirty()
					return
				else if (fella.bleeding || (fella.butt_op_stage == 4 && user.zone_sel.selecting == "chest"))
					src.cautery_surgery(fella, user, 5, src.lit)
					return ..()
				else
					user.visible_message("<span style=\"color:red\"><b>[user]</b> puts out [src] on [fella]!</span>",\
					"<span style=\"color:red\">You put out [src] on [fella]!</span>")
					fella.TakeDamage("All", 0, rand(1,5))
					if (!fella.stat)
						fella.emote("scream")
					src.put_out(user)
					return
		else
			return ..()

	attack_self(mob/user)
		if (user.find_in_hand(src))
			if (src.lit > 0)
				user.visible_message("<b>[user]</b> [pick("licks [his_or_her(user)] finger and snuffs out [src].", "waves [src] around until it goes out.")]")
				src.put_out(user)
		else
			return ..()
		return

/obj/item/zippo
	name = "zippo lighter"
	desc = "A pretty nice lighter."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "zippo"
	item_state = "zippo"
	w_class = 1
	throwforce = 4
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 5
	var/lit = 0
	var/fuel = 30 // -1 means infinite fuel
	var/icon_closed = "zippo"
	var/icon_open = "zippoon"

	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(0.4)
		light.set_color(0.94, 0.69, 0.27)
		light.attach(src)

	pickup(mob/user)
		..()
		light.attach(user)

	dropped(mob/user)
		..()
		spawn(0)
			if (src.loc != user)
				light.attach(src)

	borg
		fuel = -1

	attack_self(mob/user)
		if (user.find_in_hand(src))
			if (!src.lit)
				if (fuel == 0)
					user.show_text("Out of fuel.", "red")
					return
				src.lit = 1
				src.icon_state = src.icon_open
				src.item_state = "zippoon"
				user.visible_message("<span style=\"color:red\">Without even breaking stride, [user] flips open and lights the [src] in one smooth movement.</span>")

				light.enable()

				if (!(src in processing_items))
					processing_items.Add(src)
			else
				src.lit = 0
				src.icon_state = src.icon_closed
				src.item_state = "zippo"
				user.visible_message("<span style=\"color:red\">You hear a quiet click, as [user] shuts off the [src] without even looking what they're doing. Wow.</span>")

				light.disable()

				if (src in processing_items)
					processing_items.Remove(src)
		else
			return ..()
		return

	afterattack(atom/target, mob/user as mob)
		if (!lit && istype(target, /obj/reagent_dispensers/fueltank))
			if (src.fuel == -1)
				user.show_text("You can't seem to find any way to add more fuel to [src]. It's probably fine.", "blue")
				return
			var/obj/reagent_dispensers/fueltank/O = target
			var/fuelamt = O.reagents.get_reagent_amount("fuel")
			if (fuelamt)
				var/removed = min(fuelamt, 50)
				O.reagents.remove_reagent("fuel", removed)
				fuel += removed
				user.show_text("[src] refueled.", "blue")
				playsound(user.loc, "sound/effects/zzzt.ogg", 50, 1, -6)
			else
				user.show_text("[O] is empty.", "red")
		if (!ismob(target) && target.reagents)
			user.show_text("You heat [target].", "blue")
			target.reagents.temperature_reagents(1500,10)
		if (ishuman(target))
			var/mob/living/carbon/human/fella = target

			if (user.zone_sel.selecting == "l_arm")
				if (fella.limbs.l_arm_bleed > 1)
					fella.TakeDamage("chest",0,10)
					fella.limbs.l_arm_bleed = max(0,fella.limbs.l_arm_bleed-5)
					if (fella.limbs.l_arm_bleed == 0)
						user.visible_message("<span style=\"color:red\">[user] completely cauterises [fella]'s left stump with [src]!</span>")
					else
						user.visible_message("<span style=\"color:red\">[user] partially cauterises [fella]'s left stump with [src]!</span>")
					return

			if (user.zone_sel.selecting == "r_arm")
				if (fella.limbs.r_arm_bleed > 1)
					fella.TakeDamage("chest",0,10)
					fella.limbs.r_arm_bleed = max(0,fella.limbs.r_arm_bleed-5)
					if (fella.limbs.r_arm_bleed == 0)
						user.visible_message("<span style=\"color:red\">[user] completely cauterises [fella]'s right stump with [src]!</span>")
					else
						user.visible_message("<span style=\"color:red\">[user] partially cauterises [fella]'s right stump with [src]!</span>")
					return

			if (fella.wear_mask && istype(fella.wear_mask, /obj/item/clothing/mask/cigarette))
				var/obj/item/clothing/mask/cigarette/smoke = fella.wear_mask // aaaaaaa
				smoke.light(user, "<span style=\"color:red\"><b>[user]</b> lights [fella]'s [smoke] with [src].</span>")
				fella.set_clothing_icon_dirty()
				return

			if (fella.bleeding || (fella.butt_op_stage == 4 && user.zone_sel.selecting == "chest"))
				if (!src.cautery_surgery(target, user, 10, src.lit))
					return ..()

			user.visible_message("<span style=\"color:red\"><b>[user]</b> waves [src] around in front of [fella]'s face! OoOo, are ya scared?![src.lit ? "" : " Too bad [src] is closed."]</span>")
			return

		else if (ismob(target))
			user.visible_message("<span style=\"color:red\"><b>[user]</b> waves [src] around in front of [target]'s face! OoOo, are ya scared?![src.lit ? "" : " Too bad [src] is closed."]</span>")
			return
		else
			return ..()

	process()
		if (src.lit)
			if (src.fuel >= 0)
				fuel--
			var/turf/location = src.loc
			if (ismob(location))
				var/mob/M = location
				if (M.find_in_hand(src))
					location = M.loc
			var/turf/T = get_turf(src.loc)
			if (T)
				T.hotspot_expose(700,5)
			if (fuel == 0)
				src.lit = 0
				src.icon_state = src.icon_closed
				src.item_state = "zippo"
				light.disable()

				if (src in processing_items)
					processing_items.Remove(src)
				return
			//sleep(10)

	suicide(var/mob/user as mob)
		if(!src.lit) return 0
		user.visible_message("<span style=\"color:red\"><b>[user] swallows the lit [src.name]!</b></span>")
		user.take_oxygen_deprivation(75)
		user.TakeDamage("chest", 0, 100)
		user.emote("scream")
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		qdel(src)
		return 1

/obj/item/zippo/gold
	name = "golden zippo lighter"
	icon_state = "gold_zippo"
	icon_closed = "gold_zippo"
	icon_open = "gold_zippoon"