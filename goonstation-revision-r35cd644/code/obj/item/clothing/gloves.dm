// NO GLOVES NO LOVES

var/list/glove_IDs = new/list() //Global list of all gloves. Identical to Cogwerk's forensic ID system (Convair880).

/obj/item/clothing/gloves
	name = "gloves"
	w_class = 2.0
	icon = 'icons/obj/clothing/item_gloves.dmi'
	wear_image_icon = 'icons/mob/hands.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_feethand.dmi'
	protective_temperature = 400
	heat_transfer_coefficient = 0.25
	siemens_coefficient = 0.50
	disease_resistance = 10
	var/uses = 0
	var/max_uses = 0 // If can_be_charged == 1, how many charges can these gloves store?
	var/stunready = 0
	var/weighted = 0
	var/atom/movable/overlay/overl = null

	var/hide_prints = 1 // Seems more efficient to do this with one global proc and a couple of vars (Convair880).
	var/scramble_prints = 0
	var/material_prints = null

	var/can_be_charged = 0 // Currently, there are provisions for icon state "yellow" only. You have to update this file and mob_procs.dm if you're wanna use other glove sprites (Convair880).

	var/glove_ID = null

	New()
		..() // your parents miss you
		spawn(20)
			src.glove_ID = src.CreateID()
			if (glove_IDs) // fix for Cannot execute null.Add(), maybe??
				glove_IDs.Add(src.glove_ID)
		return

	examine()
		..()
		if (src.stunready)
			boutput(usr, "It seems to have some wires attached to it.[src.max_uses > 0 ? " There are [src.uses]/[src.max_uses] charges left!" : ""]")
		return

	// reworked this proc a bit so it can't run more than 5 times, just in case
	proc/CreateID()
		var/newID = null
		for (var/i=5, i>0, i--)
			newID = GenID()
			if (glove_IDs && newID && !glove_IDs.Find(newID))
				return newID

	proc/GenID()
		var/newID = ""
		for (var/i=10, i>0, i--)
			newID += "[pick(numbersAndLetters)]"
		if (length(newID))
			return newID

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/cable_coil))
			if (!src.can_be_charged)
				user.show_text("The [src.name] cannot be electrically charged.", "red")
				return
			if (src.stunready)
				user.show_text("You don't need to add more wiring to the [src.name].", "red")
				return

			boutput(user, "<span style=\"color:blue\">You attach the wires to the [src.name].</span>")
			src.stunready = 1
			src.material_prints += ", electrically charged"
			W:amount--
			return

		if (istype(W, /obj/item/cell)) // Moved from cell.dm (Convair880).
			var/obj/item/cell/C = W

			if (C.charge < 2500)
				user.show_text("[C] needs more charge before you can do that.", "red")
				return
			if (!src.stunready)
				user.visible_message("<span style=\"color:red\"><b>[user]</b> shocks themselves while fumbling around with [C]!</span>", "<span style=\"color:red\">You shock yourself while fumbling around with [C]!</span>")
				C.zap(user)
				return

			if (src.can_be_charged)
				if (src.uses == src.max_uses)
					user.show_text("The gloves are already fully charged.", "red")
					return
				if (src.uses < 0)
					src.uses = 0
				src.uses = min(src.uses + 1, src.max_uses)
				C.use(2500)
				src.icon_state = "stun"
				src.item_state = "stun"
				C.updateicon()
				user.update_clothing() // Required to update the worn sprite (Convair880).
				user.visible_message("<span style=\"color:red\"><b>[user]</b> charges [his_or_her(user)] stun gloves.</span>", "<span style=\"color:blue\">The stun gloves now hold [src.uses]/[src.max_uses] charges!</span>")
			else
				user.visible_message("<span style=\"color:red\"><b>[user]</b> shocks themselves while fumbling around with [C]!</span>", "<span style=\"color:red\">You shock yourself while fumbling around with [C]!</span>")
				C.zap(user)
			return

		..()

	proc/damage_bonus()
		if (weighted)
			return 3
		return 0

	proc/distort_prints(var/prints as text, var/get_glove_ID = 1) // Ditto (Convair880).

		var/data = null

		if (!src.hide_prints)
			data += prints

		else

			if (src.scramble_prints)
				data += corruptText(prints, 20)
			// Known bug: occasionally breaks the format of the forensic scanner's readout. Dunno how to account for that yet (Convair880).

			else // Seems a bit redundant to return both (Convair880).

				if (src.material_prints)
					data += src.material_prints
				else
					data += "unknown fiber material"

		if (get_glove_ID)
			data += " (Glove ID: [src.glove_ID])" // Space is required for formatting (Convair880).

		return data

/obj/item/clothing/gloves/fingerless
	desc = "These gloves lack fingers."
	name = "Fingerless Gloves"
	icon_state = "fgloves"
	item_state = "finger-"
	hide_prints = 0

/obj/item/clothing/gloves/black
	desc = "These gloves are fire-resistant."
	name = "Black Gloves"
	icon_state = "black"
	item_state = "bgloves"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.01
	material_prints = "black leather fibers"

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/latex
	name = "Latex Gloves"
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.02
	desc = "Thin gloves that offer minimal protection."
	protective_temperature = 310
	heat_transfer_coefficient = 0.90
	scramble_prints = 1

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.30
	protective_temperature = 1100
	heat_transfer_coefficient = 0.05
	material_prints = "high-quality synthetic fibers"

/obj/item/clothing/gloves/stungloves/
	name = "Stungloves"
	desc = "These gloves are electrically charged."
	icon_state = "stun"
	item_state = "stun"
	siemens_coefficient = 0
	material_prints = "insulative fibers, electrically charged"
	stunready = 1
	can_be_charged = 1
	uses = 5
	max_uses = 5

/obj/item/clothing/gloves/yellow
	desc = "These gloves are electrically insulated."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	protective_temperature = 1000
	heat_transfer_coefficient = 0.01
	material_prints = "insulative fibers"
	can_be_charged = 1
	max_uses = 1

/obj/item/clothing/gloves/yellow/unsulated
	desc = "These gloves are not electrically insulated."
	name = "unsulated gloves"
	siemens_coefficient = 1
	protective_temperature = 10
	heat_transfer_coefficient = 1
	can_be_charged = 0
	max_uses = 0

/obj/item/clothing/gloves/boxing
	name = "Boxing Gloves"
	desc = "These gloves are for competitive boxing."
	icon_state = "boxinggloves"
	item_state = "bogloves"
	siemens_coefficient = 0.20
	protective_temperature = 310
	heat_transfer_coefficient = 0.25
	material_prints = "red leather fibers"

	get_desc(dist)
		if (src.weighted)
			. += "These things are pretty heavy!"

/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/horseshoe))
		if (src.weighted)
			boutput(user, "<span style='color:red'>You try to put [W] into [src], but there's already something in there!</span>")
			return
		boutput(user, "You slip the horseshoe inside one of the gloves.")
		src.weighted = 1
		qdel(W)
		/* no why are you deleting the gloves and making new ones, just change the desc and set the var on the existing ones, fuck
		var/obj/item/clothing/gloves/boxing_h/A = new /obj/item/clothing/gloves/boxing_h
		A.set_loc(user.loc)
		qdel(W)
		qdel(src)*/
	else
		return ..()

/obj/item/horseshoe //Heavy horseshoe for traitor boxers to put in their gloves
	name = "Heavy Horseshoe"
	desc = "An old horseshoe."
	icon = 'icons/obj/junk.dmi'
	icon_state = "horseshoe"
	force = 6.5
	throwforce = 25
	throw_speed = 3
	throw_range = 6
	w_class = 1.0
	flags = FPRINT | TABLEPASS | NOSHIELD

/obj/item/clothing/gloves/powergloves
	desc = "Now I'm playin' with power!"
	name = "power gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0

	protective_temperature = 1000
	heat_transfer_coefficient = 0.01
	material_prints = "insulative fibers and nanomachines"
	can_be_charged = 1 // Quite pointless, but could be useful as a last resort away from powered wires? Hell, it's a traitor item and can get the buff (Convair880).
	max_uses = 1

	var/spam_flag = 0

	proc/use_power(var/amount)
		var/turf/T = get_turf(src)
		var/area/A = T.loc
		if(!A || !isarea(A))
			return
		A.use_power(amount, ENVIRON)

	equipment_click(var/atom/target, var/atom/user)
		if(target == user || spam_flag || user:a_intent == INTENT_HELP || user:a_intent == INTENT_GRAB) return

		var/netnum = 0

		for(var/turf/T in range(1, user))
			for(var/obj/cable/C in T.contents) //Needed because cables have invisibility 101. Making them disappear from most LISTS.
				netnum = C.netnum
				break

		if(get_dist(user, target) > 1 && !user:equipped())

			if(!netnum)
				boutput(user, "<span style=\"color:red\">The gloves find no cable to draw power from.</span>")
				return

			spam_flag = 1
			spawn(40) spam_flag = 0

			use_power(50000)

			var/atom/last = user
			var/atom/target_r = target

			var/list/dummies = new/list()

			playsound(user, "sound/effects/elec_bigzap.ogg", 40, 1)

			if(isturf(target))
				target_r = new/obj/elec_trg_dummy(target)

			var/turf/currTurf = get_turf(target_r)
			currTurf.hotspot_expose(2000, 400)

			for(var/count=0, count<4, count++)

				var/list/affected = DrawLine(last, target_r, /obj/line_obj/elec ,'icons/obj/projectiles.dmi',"WholeLghtn",1,1,"HalfStartLghtn","HalfEndLghtn",OBJ_LAYER,1,PreloadedIcon='icons/effects/LghtLine.dmi')

				for(var/obj/O in affected)
					spawn(6) pool(O)

				if(istype(target_r, /obj/machinery/power/generatorTemp))
					var/obj/machinery/power/generatorTemp/gen = target_r
					gen.efficiency_controller += 5
					gen.grump += 5
					spawn(450)
						gen.efficiency_controller -= 5

				else if(istype(target_r, /mob/living)) //Probably unsafe.
					logTheThing("combat", user, target_r, "zaps %target% with power gloves")
					switch(user:a_intent)
						if("harm")
							src.electrocute(target_r, 100, netnum)
							break
						if("disarm")
							target_r:weakened += 3
							break

				var/list/next = new/list()
				for(var/atom/movable/M in orange(3, target_r))
					if(M == user || istype(M, /obj/line_obj/elec) || istype(M, /obj/elec_trg_dummy) || istype(M, /obj/overlay/tile_effect) || M.invisibility) continue
					next.Add(M)

				if(istype(target_r, /obj/elec_trg_dummy)) dummies.Add(target_r)

				last = target_r
				target_r = pick(next)
				target = target_r

			for(var/d in dummies)
				qdel(d)
