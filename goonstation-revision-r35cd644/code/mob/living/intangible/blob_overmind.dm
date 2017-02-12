#define eulers 2.7182818284

/mob/living/intangible/blob_overmind
	name = "Blob Overmind"
	real_name = "Blob Overmind"
	desc = "The disembodied consciousness of a big pile of goop."
	icon = 'icons/mob/mob.dmi'
	icon_state = "blob"
	layer = NOLIGHT_EFFECTS_LAYER_BASE
	density = 0
	canmove = 1
	blinded = 0
	anchored = 1
	var/datum/tutorial/blob/tutorial
	var/attack_power = 1
	var/bio_points = 0
	var/bio_points_max = 1
	var/bio_points_max_bonus = 5
	var/base_gen_rate = 1
	var/gen_rate_bonus = 0
	var/gen_rate_used = 0
	var/evo_points = 0
	var/next_evo_point = 25
	var/spread_upgrade = 0
	var/spread_mitigation = 0
	var/list/upgrades = list()
	var/list/available_upgrades = list()
	var/viewing_upgrades = 1
	var/help_mode = 0
	var/list/abilities = list()
	var/list/blobs = list()
	var/started = 0
	var/starter_buff = 1
	var/extra_nuclei = 0
	var/next_extra_nucleus = 100
	var/multi_spread = 0
	var/upgrading = 0
	var/upgrade_id = 1

	var/datum/blob_ability/shift_power = null
	var/datum/blob_ability/ctrl_power = null
	var/datum/blob_ability/alt_power = null
	var/list/lipids = list()
	var/list/nuclei = list()

	var/datum/material/my_material = null
	var/datum/material/initial_material = null

	proc/start_tutorial()
		if (tutorial)
			return
		tutorial = new(src)
		if (tutorial.tutorial_area)
			tutorial.Start()
		else
			boutput(src, "<span style=\"color:red\">Could not start tutorial! Please try again later or call Marquesas.</span>")
			tutorial = null
			return

	New()
		..()
		src.add_ability(/datum/blob_ability/plant_nucleus)
		src.add_ability(/datum/blob_ability/set_color)
		src.add_ability(/datum/blob_ability/tutorial)
		src.add_ability(/datum/blob_ability/help)
		src.invisibility = 10
		src.sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
		src.see_invisible = 15
		src.see_in_dark = SEE_DARK_FULL
		my_material = getCachedMaterial("blob")
		my_material.color = "#ffffff"
		initial_material = getCachedMaterial("blob")

	Move(NewLoc)
		if (tutorial)
			if (!tutorial.PerformAction("move", NewLoc))
				return 0
		if (isturf(NewLoc))
			if (istype(NewLoc, /turf/unsimulated/wall))
				return 0
		..()

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1

		if (started && (nuclei.len == 0 || blobs.len == 0))
			death()
			return

		if (src.client)
			src.antagonist_overlay_refresh(0, 0)

		if (blobs.len > 0)
			/**
			 * at 2175 blobs, blob points max will reach about 350. It will begin decreasing sharply after that
			 * This is a size penalty. Basically if the blob gets too damn big, the crew has some chance of
			 * fighting it back because it will run out of points.
			 */
			src.bio_points_max = BlobPointsBezierApproximation(round(blobs.len / 5)) + bio_points_max_bonus
		src.bio_points = max(0,min(src.bio_points + (base_gen_rate + gen_rate_bonus - gen_rate_used),src.bio_points_max))

		if (tutorial)
			if (!tutorial.PerformSilentAction("life", null))
				return

		if (starter_buff == 1)
			if (blobs.len >= 40)
				boutput(src, "<span style=\"color:red\"><b>You no longer have the starter assistance.</b></span>")
				starter_buff = 0

		if (blobs.len >= next_evo_point)
			next_evo_point += initial(next_evo_point)
			evo_points++
			boutput(src, "<span style=\"color:blue\"><b>You have expanded enough to earn one evo point! You will be granted another at size [next_evo_point]. Good luck!</b></span>")

		if (blobs.len >= next_extra_nucleus)
			next_extra_nucleus += initial(next_extra_nucleus)
			extra_nuclei++
			boutput(src, "<span style=\"color:blue\"><b>You have expanded enough to earn one extra nucleus! You will be granted another at size [next_extra_nucleus]. Good luck!</b></span>")

	death()
		boutput(src, "<span style=\"color:red\"><b>With no nuclei to bind it to your biomass, your consciousness slips away into nothingness...</b></span>")
		src.ghostize()
		spawn(0)
			qdel(src)

	Stat()
		..()
		stat(null, " ")
		stat("--Blob--", " ")
		stat("Bio Points:", "[bio_points]/[bio_points_max]")
		stat("Generation Rate:", "[base_gen_rate + gen_rate_bonus - gen_rate_used]/[base_gen_rate + gen_rate_bonus] BP")
		stat("Blob Size:", blobs.len)
		stat("Evo Points:", evo_points)
		stat("Next Evo Point at size:", next_evo_point)
		stat("Living nuclei:", nuclei.len)
		stat("Unplaced extra nuclei:", extra_nuclei)
		stat("Next Extra Nucleus at size:", next_extra_nucleus)

	Login()
		..()
		src.update_buttons()
		client.show_popup_menus = 0

	Logout()
		..()
		if (src.last_client)
			if (src.last_client.buildmode)
				if (src.last_client.buildmode.is_active)
					return
			src.last_client.show_popup_menus = 1

	MouseDrop()
		return

	MouseDrop_T()
		return

	meteorhit()
		return

	is_spacefaring()
		return 1

	click(atom/target, params)
		if (istype(target,/obj/screen/blob/))
			if (params["middle"])
				var/obj/screen/blob/B = target
				if (B.ability)
					B.ability.onUse()
					return
			..()
			return
		var/turf/T = get_turf(target)
		if (params["alt"] && istype(src.alt_power))
			src.alt_power.onUse(T)
			src.update_buttons()
			return
		else if (params["shift"] && istype(src.shift_power))
			src.shift_power.onUse(T)
			src.update_buttons()
			return
		else if (params["ctrl"] && istype(src.ctrl_power))
			src.ctrl_power.onUse(T)
			src.update_buttons()
			return
		else
			if (T && (!isrestrictedz(T.z) || (isrestrictedz(T.z) && restricted_z_allowed(src, T)) || src.tutorial || (src.client && src.client.holder)))
				if (src.tutorial)
					if (!tutorial.PerformAction("clickmove", T))
						return
				src.set_loc(T)
				return

			if (isrestrictedz(T.z) && !restricted_z_allowed(src, T) && !(src.client && src.client.holder))
				var/OS = observer_start.len ? pick(observer_start) : locate(1, 1, 1)
				if (OS)
					src.set_loc(OS)
				else
					src.z = 1

	say_understands() return 1
	can_use_hands()	return 0

	say(var/message)
		return ..(message)

	say_quote(var/text)
		var/speechverb = pick("wobbles", "wibbles", "jiggles", "wiggles", "undulates", "fidgets", "joggles", "twitches", "waggles", "trembles", "quivers")
		return "[speechverb], \"[text]\""

	proc/get_gen_rate()
		return base_gen_rate + gen_rate_bonus - gen_rate_used

	proc/onBlobHit(var/obj/blob/B, var/mob/M)
		return

	proc/onBlobDeath(var/obj/blob/B, var/mob/M)
		return

	proc/add_ability(var/ability_type)
		if (!ispath(ability_type))
			return
		var/datum/blob_ability/A = new ability_type
		A.owner = src
		src.abilities += A
		src.update_buttons()

	proc/add_upgrade(var/upgrade_type, var/skip_disabled = 0)
		if (!ispath(upgrade_type))
			return
		var/datum/blob_upgrade/A = new upgrade_type
		if (skip_disabled && A.initially_disabled)
			return
		A.owner = src
		src.available_upgrades += A
		src.update_buttons()

	proc/remove_ability(var/ability_type)
		if (!ispath(ability_type))
			return
		for (var/datum/blob_ability/A in src.abilities)
			if (A.type == ability_type)
				src.abilities -= A
				if (A == src.alt_power)
					src.alt_power = null
				if (A == src.ctrl_power)
					src.ctrl_power = null
				if (A == src.shift_power)
					src.shift_power = null
				qdel(A)
				return
		src.update_buttons()

	proc/get_ability(var/ability_type)
		if (!ispath(ability_type))
			return null
		for (var/datum/blob_ability/A in src.abilities)
			if (A.type == ability_type)
				return A
		return null

	proc/get_upgrade(var/upgrade_type)
		if (!ispath(upgrade_type))
			return null
		for (var/datum/blob_upgrade/A in src.available_upgrades)
			if (A.type == upgrade_type)
				return A
		return null

	proc/update_buttons()
		if(!src.client)
			return

		//src.client.screen -= src.item_abilities
		for(var/obj/screen/blob/B in src.client.screen)
			src.client.screen -= B

		var/pos_x = 1
		var/pos_y = 0

		for(var/datum/blob_ability/B in src.abilities)
			if (!istype(B.button))
				continue
			if (B.special_screen_loc)
				B.button.screen_loc = B.special_screen_loc
			else
				B.button.screen_loc = "NORTH-[pos_y],[pos_x]"
			B.button.overlays = list()
			if (B.cooldown_time > 0 && B.last_used > world.time)
				B.button.overlays += B.button.darkener
				B.button.overlays += B.button.cooldown
			if (B == src.shift_power)
				B.button.overlays += B.button.shift_highlight
			if (B == src.ctrl_power)
				B.button.overlays += B.button.ctrl_highlight
			if (B == src.alt_power)
				B.button.overlays += B.button.alt_highlight
			src.client.screen += B.button
			if (!B.special_screen_loc)
				pos_x++
				if(pos_x > 15)
					pos_x = 1
					pos_y++

		if (viewing_upgrades)
			pos_x = 0
			pos_y = 14

			for(var/datum/blob_upgrade/B in src.available_upgrades)
				if (!istype(B.button))
					continue
				//B.button.screen_loc = "SOUTH,[pos_x]:9"
				B.button.screen_loc = "WEST+[pos_x]:9,NORTH-[pos_y]"
				src.client.screen += B.button
				B.button.overlays = list()
				if (!B.check_requirements())
					B.button.overlays += B.button.darkener
				pos_x++
				if(pos_x > 15)
					pos_x = 0
					pos_y--

	proc/has_ability(var/ability_path)
		for (var/datum/blob_ability/B in src.abilities)
			if (B.type == ability_path)
				return 1
		return 0

	proc/has_upgrade(var/upgrade_path)
		for (var/datum/blob_upgrade/B in src.upgrades)
			if (B.type == upgrade_path)
				return 1
		return 0

	proc/BlobPointsBezierApproximation(var/t)
		// t = number of tiles occupied by the blob
		t = max(0, min(1000, t))
		var/points

		if (t < 514)
			points = t - ((t ** 2) / 4000) - (eulers ** ((t-252)/50)) + 1
		else if (t >= 514)
			// Oh dear, you seem to be too fucking big. Whoopsie daisies...
			// Marq update: gonna flatline this at 40 so big blobs aren't completely useless
			// The idea is not that we should be punishing big blobs, rather we should be making progress progressively difficult.
			points = max(40, 30000 / (t - 417) - 51)

		return round(max(0, points))

	proc/usePoints(var/amt, var/force = 1)
		if (bio_points < amt)
			var/needed = amt - bio_points
			if (lipids.len * 4 >= needed)
				while (bio_points < amt)
					if (!lipids.len)
						break
					var/obj/blob/lipid/L = pick(lipids)
					if (!istype(L))
						lipids -= L
						continue
					L.use()
		if (bio_points < amt)
			if (force)
				bio_points -= amt
			return 0
		bio_points -= amt
		return 1

	proc/hasPoints(var/amt)
		for (var/Q in lipids)
			if (!istype(Q, /obj/blob/lipid))
				lipids -= Q
		return bio_points + lipids.len * 4 >= amt

	projCanHit(datum/projectile/P)
		return 0

/obj/screen/blob
	var/datum/blob_ability/ability = null
	var/datum/blob_upgrade/upgrade = null
	var/image/ctrl_highlight = null
	var/image/shift_highlight = null
	var/image/alt_highlight = null
	var/image/cooldown = null
	var/image/darkener = null

	New()
		..()
		ctrl_highlight = image('icons/mob/blob_ui.dmi',"ctrl")
		shift_highlight = image('icons/mob/blob_ui.dmi',"shift")
		alt_highlight = image('icons/mob/blob_ui.dmi',"alt")
		cooldown = image('icons/mob/blob_ui.dmi',"cooldown")
		var/image/I = image('icons/mob/blob_ui.dmi',"darkener")
		I.alpha = 100
		darkener = I

	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		if (!istype(O,/obj/screen/blob/) || !istype(user,/mob/living/intangible/blob_overmind))
			return
		var/obj/screen/blob/source = O
		if (!istype(src.ability) || !istype(source.ability))
			boutput(user, "<span style=\"color:red\">You may only switch the places of ability buttons.</span>")
			return
		var/mob/living/intangible/blob_overmind/owner = user

		var/index_source = owner.abilities.Find(source.ability)
		var/index_target = owner.abilities.Find(src.ability)
		owner.abilities.Swap(index_source,index_target)
		owner.update_buttons()

	//Click(location,control,params)
	clicked(parameters)
		if (!istype(usr,/mob/living/intangible/blob_overmind))
			return

		var/mob/living/intangible/blob_overmind/user = usr

		if (!istype(user))
			return
		if (!istype(ability) && !istype(upgrade))
			return

		if (ability)
			if (!ability.helpable)
				ability.onUse()
				return

		if (upgrade)
			if ((parameters["shift"] || !user.help_mode) && upgrade.check_requirements())
				if (user.upgrading)
					return
				var/my_upgrade_id = user.upgrade_id
				user.upgrading = my_upgrade_id
				spawn (20)
					if (user.upgrading <= my_upgrade_id)
						user.upgrading = 0
					else
						sleep(20)
						user.upgrading = 0
				if (!upgrade.take_upgrade())
					upgrade.deduct_evo_points()
				user.update_buttons()
			else
				boutput(user, "<b>Upgrade:</b> [upgrade.name]")
				boutput(user, "[upgrade.desc]")
				boutput(user, "<b>Evo Point Cost:</b> [upgrade.evo_point_cost]")
				if (upgrade.check_requirements())
					boutput(user, "<span style=\"color:blue\">Shift-click on this icon to take the upgrade.</span>")
				else
					boutput(user, "<span style=\"color:red\">You cannot take this upgrade yet.</span>")
			return

		if (parameters["ctrl"] && ability.targeted)
			if (ability == user.alt_power || ability == user.shift_power)
				boutput(user, "<span style=\"color:red\">That ability is already bound to another key.</span>")
				return

			if (ability == user.ctrl_power)
				user.ctrl_power = null
				boutput(user, "<span style=\"color:blue\"><b>[ability.name] has been unbound from Ctrl-Click.</b></span>")
				user.update_buttons()
			else
				user.ctrl_power = ability
				boutput(user, "<span style=\"color:blue\"><b>[ability.name] is now bound to Ctrl-Click.</b></span>")

		else if (parameters["alt"] && ability.targeted)
			if (ability == user.shift_power || ability == user.ctrl_power)
				boutput(user, "<span style=\"color:red\">That ability is already bound to another key.</span>")
				return

			if (ability == user.alt_power)
				user.alt_power = null
				boutput(user, "<span style=\"color:blue\"><b>[ability.name] has been unbound from Alt-Click.</b></span>")
				user.update_buttons()
			else
				user.alt_power = ability
				boutput(user, "<span style=\"color:blue\"><b>[ability.name] is now bound to Alt-Click.</b></span>")

		else if (parameters["shift"] && ability.targeted)
			if (ability == user.alt_power || ability == user.ctrl_power)
				boutput(user, "<span style=\"color:red\">That ability is already bound to another key.</span>")
				return

			if (ability == user.shift_power)
				user.shift_power = null
				boutput(user, "<span style=\"color:blue\"><b>[ability.name] has been unbound from Shift-Click.</b></span>")
				user.update_buttons()
			else
				user.shift_power = ability
				boutput(user, "<span style=\"color:blue\"><b>[ability.name] is now bound to Shift-Click.</b></span>")

		else
			if (user.help_mode)
				boutput(user, "<span style=\"color:blue\"><b>This is your [ability.name] ability.</b></span>")
				boutput(user, "<span style=\"color:blue\">It costs [ability.bio_point_cost] bio points to use.</span>")
				if (istype(ability,/datum/blob_ability/build))
					var/datum/blob_ability/build/AB = ability
					boutput(user, "<span style=\"color:blue\">This is a building ability - you need to use it on a regular blob tile.</span>")
					if (AB.gen_rate_invest > 0)
						boutput(user, "<span style=\"color:blue\">This ability requires you to invest [AB.gen_rate_invest] of your BP generation rate in it. It will be returned when the cell is destroyed.</span>")
				boutput(user, "<span style=\"color:blue\">[ability.desc]</span>")
				boutput(user, "<span style=\"color:blue\">Hold down Shift, Ctrl or Alt while clicking the button to set it to that key.</span>")
				boutput(user, "<span style=\"color:blue\">You will then be able to use it freely by holding that button and left-clicking a tile.</span>")
				boutput(user, "<span style=\"color:blue\">Alternatively, you can click with your middle mouse button to use the ability on your current tile.</span>")
				boutput(user, "<span style=\"color:blue\">If you want to swap the places of two buttons on this bar, click and drag one to the position you want it to occupy.</span>")
			else
				ability.onUse()

		user.update_buttons()

	//WIRE TOOLTIPS
	MouseEntered(location, control, params)
		usr.client.tooltip.show(src, params, title = src.name, content = (src.desc ? src.desc : null), theme = "blob")

	MouseExited()
		usr.client.tooltip.hide()

/mob/proc/make_blob()
	if (!src.client && !src.mind)
		return null
	var/mob/living/intangible/blob_overmind/W = new/mob/living/intangible/blob_overmind(src)

	var/turf/T = get_turf(src)
	if (!(T && isturf(T)) || (isrestrictedz(T.z) && !(src.client && src.client.holder)))
		var/ASLoc = observer_start.len ? pick(observer_start) : locate(1, 1, 1)
		if (ASLoc)
			W.set_loc(ASLoc)
		else
			W.z = 1
	else
		W.set_loc(T)

	if (src.mind)
		src.mind.transfer_to(W)
	else
		var/key = src.client.key
		if (src.client)
			src.client.mob = W
		W.mind = new /datum/mind()
		W.mind.key = key
		W.mind.current = W
		ticker.minds += W.mind

	var/this = src
	src = null
	qdel(this)

	boutput(W, "<b>You are a blob! Grow in size and devour the station.</b>")
	boutput(W, "Your hivemind will cease to exist if your body is entirely destroyed.")
	boutput(W, "Use the question mark button in the lower right corner to get help on your abilities.")

	return W