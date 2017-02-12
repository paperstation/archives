#define ITEM_ABILITIES_WRAP_AT 15

//There is no stunned etc. check when clicking the buttons.
//If you want one, code it. (the_mob var on the buttons).

//oh my god what the fuck is going on in this file jesus wow

////////////////////////////////////////////////////////////
/obj/item/extinguisher/abilities = list(/obj/ability_button/extinguisher_ab)

/obj/ability_button/extinguisher_ab
	name = "Extinguish"
	icon_state = "extab"

	execute_ability()
		var/obj/item/extinguisher/E = the_item
		if(!E.reagents || !E.reagents.total_volume || E.special) return

		if (E.reagents.has_reagent("vomit") || E.reagents.has_reagent("blackpowder") || E.reagents.has_reagent("blood") || E.reagents.has_reagent("gvomit") || E.reagents.has_reagent("carbon") || E.reagents.has_reagent("cryostylane") || E.reagents.has_reagent("chickensoup") || E.reagents.has_reagent("salt"))
			boutput(the_mob, "<span style=\"color:red\">The nozzle is clogged!</span>")
			return

		if (E.reagents.has_reagent("acid") || E.reagents.has_reagent("pacid") || E.reagents.has_reagent("napalm"))
			for(var/mob/O in AIviewers(the_mob, null)) O.show_message(text("<span style=\"color:red\">[] melts!</span>", E), 1)
			new/obj/decal/cleanable/molten_item(get_turf(the_mob))
			qdel(E)
			return

		for(var/mob/M in view(the_mob))
			boutput(M, "<span style=\"color:red\">[the_mob] prepares to spray the contents of the extinguisher all around \himself!</span>")

		E.special = 1
		the_mob.transforming = 1
		spawn(30) if (the_mob) the_mob.transforming = 0
		sleep(30)

		var/theturf
		var/list/spraybits = new/list()
		var/direction = NORTH
		if (the_mob)
			theturf = get_turf(the_mob)
		else
			theturf = get_turf(E)

		for(var/i=0, i<8, i++)
			var/obj/effects/spray/S = new/obj/effects/spray(theturf)
			spawn(150) qdel(S)
			S.dir = direction
			S.original_dir = direction
			direction = turn(direction,45)
			S.create_reagents(1000)
			E.reagents.copy_to(S.reagents)
			//var/icon/IC = icon(S.icon,S.icon_state)
			//IC.Blend(S.reagents.get_master_color(),ICON_MULTIPLY)
			//S.icon = IC
			spraybits += S
			spawn(0)
				S.reagents.reaction(theturf, TOUCH)
				for(var/atom/A in theturf)
					S.reagents.reaction(A, TOUCH)

		if (the_mob) playsound(the_mob, 'sound/effects/spray.ogg', 75, 1, 0)
		E.reagents.clear_reagents()

		sleep(5)
		E.special = 0

		spawn(0)
			for(var/i=0, i<3, i++)
				for(var/obj/effects/spray/SP in spraybits)
					SP.set_loc(get_step(SP.loc, SP.original_dir))
					SP.reagents.reaction(SP.loc, TOUCH)
					for(var/atom/A in SP.loc)
						SP.reagents.reaction(A, TOUCH)
					if(is_blocked_turf(SP.loc))
						spraybits -= SP
						qdel(SP)
				sleep(5)

	OnDrop()
		if (the_mob) the_mob.transforming = 0
////////////////////////////////////////////////////////////
/obj/item/clothing/head/helmet/welding/abilities = list(/obj/ability_button/mask_toggle)


/obj/ability_button/mask_toggle
	name = "Toggle Welding Mask"
	icon_state = "weldup"

	execute_ability()
		var/obj/item/clothing/head/helmet/welding/W = the_item
		if(W.up)
			W.up = !W.up
			W.see_face = !W.see_face
			W.icon_state = "welding"
			boutput(the_mob, "You flip the mask down.")
			the_mob.set_clothing_icon_dirty()
			icon_state = "weldup"
		else
			W.up = !W.up
			W.see_face = !W.see_face
			W.icon_state = "welding-up"
			boutput(the_mob, "You flip the mask up.")
			the_mob.set_clothing_icon_dirty()
			icon_state = "welddown"

/obj/item/tank/air/abilities = list(/obj/ability_button/tank_valve_toggle)
/obj/item/tank/oxygen/abilities = list(/obj/ability_button/tank_valve_toggle)
/obj/item/tank/emergency_oxygen/abilities = list(/obj/ability_button/tank_valve_toggle)

/obj/ability_button/tank_valve_toggle
	name = "Toggle Tank Valve"
	icon_state = "airoff"

	OnDrop() // since tanks close when dropped this should always start off
		icon_state = "airoff"
		..()

	execute_ability()
		var/obj/item/tank/T = the_item
		if (!T) return
		T.toggle_valve() // the tank valve toggle handles the icon updates since its also used by tank/Topic

/obj/item/clothing/shoes/rocket/abilities = list(/obj/ability_button/shoerocket)

/obj/ability_button/shoerocket
	name = "Activate Shoes"
	icon_state = "rocketshoes"
	var/explosion_chance = 3

	Click()
		if(!the_item || !the_mob || !the_mob.canmove) return
		var/obj/item/clothing/shoes/rocket/R = the_item

		if(the_mob:shoes != the_item)
			boutput(the_mob, "<span style=\"color:red\">You must be wearing the shoes to use them.</span>")
			return

		R.uses--

		if(R.uses < 0)
			the_item.name = "Empty Rocket Shoes"
			boutput(the_mob, "<span style=\"color:red\">Your Rocket Shoes are empty.</span>")
			R.abilities.Cut()
			qdel(src)
			return

		playsound(get_turf(the_mob), 'sound/effects/bamf.ogg', 100, 1)

		if(prob(explosion_chance))
			boutput(the_mob, "<span style=\"color:red\">The Rocket Shoes blow up</span>")
			explosion(src, get_turf(the_mob), -1, -1, 1, 1)
			qdel(the_item)
			qdel(src)
			return

		spawn(0)
			var/turf/curr = get_turf(the_mob)

			for(var/i=0, i<15, i++)
				curr = get_step(curr, the_mob.dir)

			the_mob.throw_unlimited = 1

			spawn(0)
				for(var/i=0, i<15, i++)
					var/obj/O = new/obj(get_turf(the_mob))
					O.density = 0
					O.name = "Smoke"
					O.anchored = 0
					O.opacity = 0
					O.icon = 'icons/effects/effects.dmi'
					O.icon_state = "smoke"
					O.dir = pick(alldirs)
					spawn(10) qdel(O)
					sleep(1)

			the_mob.throw_at(curr, 16, 3)


////////////////////////////////////////////////////////////
/obj/item/device/flashlight/abilities = list(/obj/ability_button/flashlight_toggle)

/obj/ability_button/flashlight_toggle
	name = "Toggle Flashlight"
	icon_state = "on"

	execute_ability()
		var/obj/item/device/flashlight/J = the_item
		J.attack_self(the_mob)
		if(J.on) icon_state = "off"
		else  icon_state = "on"
////////////////////////////////////////////////////////////
/obj/item/clothing/head/helmet/space/engineer/abilities = list(/obj/ability_button/flashlight_engiehelm)

/obj/ability_button/flashlight_engiehelm
	name = "Toggle Flashlight"
	icon_state = "on"

	execute_ability()
		var/obj/item/clothing/head/helmet/space/engineer/J = the_item
		J.flashlight_toggle(the_mob)
		if (J.on) src.icon_state = "off"
		else  src.icon_state = "on"
////////////////////////////////////////////////////////////
/obj/item/clothing/head/helmet/hardhat/abilities = list(/obj/ability_button/flashlight_hardhat)
/obj/ability_button/flashlight_hardhat
	name = "Toggle Flashlight"
	icon_state = "on"

	execute_ability()
		var/obj/item/clothing/head/helmet/hardhat/J = the_item
		J.flashlight_toggle(the_mob)
		if (J.on) src.icon_state = "off"
		else  src.icon_state = "on"
////////////////////////////////////////////////////////////
/obj/item/device/t_scanner/abilities = list(/obj/ability_button/tscanner_toggle)

/obj/ability_button/tscanner_toggle
	name = "Toggle T-Scanner"
	icon_state = "on"

	execute_ability()
		var/obj/item/device/t_scanner/J = the_item
		J.attack_self(the_mob)
		if(J.on) icon_state = "off"
		else  icon_state = "on"
////////////////////////////////////////////////////////////
/obj/item/tank/jetpack/abilities = list(/obj/ability_button/jetpack_toggle, /obj/ability_button/tank_valve_toggle)

/obj/ability_button/jetpack_toggle
	name = "Toggle jetpack"
	icon_state = "jeton"

	execute_ability()
		var/obj/item/tank/jetpack/J = the_item
		J.toggle()
		if(J.on) icon_state = "jetoff"
		else  icon_state = "jeton"
////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
/mob/var/list/item_abilities = new/list()
/mob/var/need_update_item_abilities = 0

/mob/proc/update_item_abilities()
	if(!src.client || !need_update_item_abilities) return

	need_update_item_abilities = 0
	//src.client.screen -= src.item_abilities
	for(var/obj/ability_button/B in src.client.screen)
		src.client.screen -= B

	if(src.stat) return

	if (istype(src,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = src
		H.hud.update_ability_hotbar()

	// shifted all the stuff down there over to the hud file human.dm

	//var/pos_x = 1
	//var/pos_y = 0

	//for(var/obj/ability_button/B2 in src.item_abilities)
	//	B2.screen_loc = "NORTH-[pos_y],[pos_x]"
	//	src.client.screen += B2
	//	pos_x++
	//	if(pos_x > ITEM_ABILITIES_WRAP_AT)
	//		pos_x = 1
	//		pos_y++

//////////////////////////////////////////////////////////////////////////////

////////////////////////// Base vars & procs /////////////////////////////////

//If you want an item to have abilities, you need to make sure
//you add the stuff in the new proc here to its new proc, should it have one.
//You also need to add the pickup / dropped stuff if the item has custom ones.
//In some cases you might be able to use ..() instead.

/obj/item/

	var/list/abilities = list("")
	var/list/ability_buttons = new/list()

	var/mob/the_mob = null

	New()
		for(var/A in abilities)
			if(!ispath(A,/obj/ability_button))
				abilities -= A
				continue
			var/obj/ability_button/NB = new A(src)
			ability_buttons += NB

		for(var/obj/ability_button/B in ability_buttons) B.the_item = src
//		if(ability_buttons.len > 0)
//			spawn(0) check_abilities()
		..()

	proc/clear_mob()
		for(var/obj/ability_button/B in ability_buttons)
			B.the_mob = null
		the_mob = null

	proc/set_mob(var/mob/M)
		if(!M) return
		for(var/obj/ability_button/B in ability_buttons)
			B.the_mob = M
		the_mob = M

	proc/show_buttons()
		if(!the_mob || !ability_buttons.len) return
		if(!the_mob.item_abilities.Find(ability_buttons[1]))
			the_mob.item_abilities.Add(ability_buttons)
			the_mob.need_update_item_abilities = 1
			the_mob.update_item_abilities()

	proc/hide_buttons()
		if(!the_mob) return
		the_mob.item_abilities.Remove(ability_buttons)
		the_mob.need_update_item_abilities = 1
		the_mob.update_item_abilities()
/*
	proc/check_abilities()
		if (!(src in heh))
			heh += src
			boutput(world, "heh len = [heh.len]")
		if(!the_mob)
			spawn(30) check_abilities()
			return

		if(!(src in the_mob.get_equipped_items()))
			hide_buttons()
		else
			if(istype(src,/obj/item/clothing/suit/wizrobe))
				clear_buttons()
			show_buttons()

		spawn(10) check_abilities()
*/
	proc/dropped(mob/user as mob)
		if(src.material) src.material.triggerDrop(user)
		for(var/obj/ability_button/B in ability_buttons)
			B.OnDrop()
		hide_buttons()
		clear_mob()
		return

	proc/pickup(mob/user)
		if(src.material) src.material.triggerPickup(user)
		set_mob(user)
		show_buttons()
		return

	proc/clear_buttons()
		if(!the_mob) return
		the_mob.item_abilities = list()

/obj/ability_button
	name = "baseButton"
	desc = ""
	icon = 'icons/misc/abilities.dmi'
	icon_state = "test"
	layer = HUD_LAYER

	var/obj/item/the_item = null
	var/mob/the_mob = null

	Click()
		if(ability_allowed())
			execute_ability()

	attackby()
		return

	attack_hand()
		return

	//WIRE TOOLTIPS
	MouseEntered(location, control, params)
		usr.client.tooltip.show(src, params, title = src.name, content = (src.desc ? src.desc : null))

	MouseExited()
		usr.client.tooltip.hide()

	proc/ability_allowed()
		if (!the_item)
			return 0
		if (!the_mob || !the_mob.canmove)
			return 0
		return 1

	proc/execute_ability()
		return

	proc/OnDrop()
		return
