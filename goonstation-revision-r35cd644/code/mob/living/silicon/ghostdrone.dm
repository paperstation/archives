#define DRONE_LUM 2

/mob/living/silicon/ghostdrone
	icon = 'icons/mob/ghost_drone.dmi'
	icon_state = "drone-dead"

	max_health = 10 //weak as fuk
	density = 0 //no bumping into people, basically
	robot_talk_understand = 0 //we arent proper robots

	sound_fart = 'sound/misc/poo2_robot.ogg'
	flags = NODRIFT

	punchMessage = "whaps"
	kickMessage = "bonks"

	var/datum/hud/ghostdrone/hud
	var/obj/item/cell/cell
	var/obj/item/device/radio/radio = null

	var/obj/item/active_tool = null
	var/list/obj/item/tools = list()

	//state tracking
	var/faceColor
	var/faceType
	var/charging = 0
	var/newDrone = 0

	var/jetpack = 1 //fuck whoever made this
	var/datum/effects/system/ion_trail_follow/ion_trail = null
	var/jeton = 0

	var/datum/light/light

	//gimmicky things
	var/obj/item/clothing/head/hat = null
	var/obj/item/clothing/suit/bedsheet/bedsheet = null

	var/removeStunEffects = 0
	var/hasStunEffects = 0


	New()
		..()
		ghost_drones += src
		name = "Drone [rand(1,9)]*[rand(10,99)]"
		real_name = name
		hud = new(src)
		src.attach_hud(hud)

		var/obj/item/cell/cerenkite/charged/CELL = new /obj/item/cell/cerenkite/charged(src)
		src.cell = CELL

		light = new /datum/light/point
		light.set_brightness(0.5)
		light.attach(src)

		src.health = src.max_health
		src.botcard.access = list(access_maint_tunnels)
		src.radio = new /obj/item/device/radio(src)
		src.ears = src.radio
		//src.zone_sel = new(src)
		//src.attach_hud(zone_sel)
		src.ion_trail = new /datum/effects/system/ion_trail_follow()
		src.ion_trail.set_up(src)

		//Attach shit to tools
		src.tools = list(
			new /obj/item/magtractor(src),
			new /obj/item/rcd(src),
			new /obj/item/crowbar(src),
			new /obj/item/screwdriver(src),
			new /obj/item/device/t_scanner(src),
			new /obj/item/device/multitool(src),
			new /obj/item/electronics/soldering(src),
			new /obj/item/wrench(src),
			new /obj/item/weldingtool(src),
			new /obj/item/wirecutters(src),
			new /obj/item/device/flashlight(src),
		)

		//Make all the tools un-drop-able (to closets/tables etc)
		for (var/obj/item/O in src.tools)
			O.cant_drop = 1

		spawn(0)
			out(src, "<b>Use \"say ; (message)\" to speak to fellow drones through the spooky power of spirits within machines.</b>")
			src.show_laws_drone()

	Life(datum/controller/process/mobs/parent)
		set invisibility = 0

		if (..(parent))
			return

		if (src.transforming)
			return

		for (var/obj/item/I in src)
			if (!I.material) continue
			I.material.triggerOnLife(src, I)

		if (src.stat != 2) //alive
			use_power()

			if (src.stat != 2) //still alive after power usage
				if (src.paralysis || src.stunned || src.weakened) //Stunned etc.
					if (src.stat == 0) src.lastgasp() // calling lastgasp() here because we just got knocked out
					src.stat = 1
					if (src.get_eye_blurry())
						src.change_eye_blurry(-1)
					if (src.dizziness)
						dizziness--
					if (src.stunned > 0)
						src.stunned--
						if (src.stunned <= 0)
							src.removeStunEffects = 1
						src.setStunnedEffects()
					if (src.weakened > 0)
						src.weakened--
					if (src.paralysis > 0)
						src.paralysis--
						src.blinded = 1
					else src.blinded = 0

				if (hud)
					hud.update_environment()
					hud.update_health()
					hud.update_tools()

				if (src.client)
					src.updateStatic()
					src.updateOverlaysClient(src.client)
					src.antagonist_overlay_refresh(0, 0)

		if (src.observers.len)
			for (var/mob/x in src.observers)
				if (x.client)
					src.updateOverlaysClient(x.client)

	proc/updateStatic()
		if (!src.client)
			return
		src.client.images.Remove(mob_static_icons)
		for (var/image/I in mob_static_icons)
			if (!I || !I.loc || !src)
				continue
			if (I.loc.invisibility && I.loc != src.loc)
				continue
			else
				src.client.images.Add(I)

	death(gibbed)
		logTheThing("combat", src, null, "was destroyed at [log_loc(src)].")
		src.stat = 2
		ghost_drones -= src
		if (src.client)
			src.client.images.Remove(mob_static_icons)

			var/mob/dead/observer/ghost = src.ghostize()
			ghost.icon = 'icons/mob/ghost_drone.dmi'
			ghost.icon_state = "drone-ghost"

			//This stuff is hacky but I don't feel like messing with observer New code so fuck it
			if (!src.oldmob) //Prevents re-entering a ghostdrone corpse
				ghost.verbs -= /mob/dead/observer/proc/reenter_corpse
			ghost.name = (src.oldname ? src.oldname : src.real_name)
			ghost.real_name = (src.oldname ? src.oldname : src.real_name)

		//So the drone cant pick up an item and then die, sending the item ~to the void~
		var/obj/item/magtractor/mag = locate(/obj/item/magtractor) in src.tools
		var/obj/item/magHeld = mag.holding ? mag.holding : null
		if (magHeld) magHeld.set_loc(get_turf(src))

		if (gibbed)
			src.visible_message("<span class='combat'>[src.name] explodes in a shower of lost hopes and dreams.</span>")
			var/turf/T = get_ranged_target_turf(src, pick(alldirs), 3)
			if (magHeld) magHeld.throw_at(T, 3, 1) //flying...anything
			if (src.hat) src.takeoffHat(pick(alldirs)) //flying hats
			if (src.bedsheet) //flying bedsheets
				bedsheet.set_loc(get_turf(src))
				bedsheet.throw_at(T, 3, 1)
			..(1)
		else
			src.lastgasp()
			var/msg
			switch(rand(1,3))
				if (1)
					msg = "[src.name] [pick("falls", "crashes", "sinks")] to the ground, ghost-less."
				if (2)
					msg = "The spirit powering [src.name] packs up and leaves."
				if (3)
					msg = "[src.name]'s scream's gain echo and lose their electronic modulation as it's soul is ripped monstrously from the cold metal body it once inhabited."

			src.visible_message("<span class='combat'>[msg]</span>")
			if (src.hat) src.takeoffHat()
			src.updateSprite()
			..()

	dispose()
		..()
		if (src in ghost_drones)
			ghost_drones -= src
		if (src in available_ghostdrones)
			available_ghostdrones -= src

	Del()
		if (src in ghost_drones)
			ghost_drones -= src
		if (src in available_ghostdrones)
			available_ghostdrones -= src
		..()

	//Apparently leaving this on made the parent updatehealth set health to max_health in all cases, because there's no such thing as bruteloss and
	// so on with this mob
	updatehealth()
		return

	full_heal()
		var/before = src.stat
		..()
		if (before == 2 && src.stat < 2) //if we were dead, and now arent
			src.updateSprite()

	TakeDamage(zone, brute, burn)
		if (src.nodamage) return //godmode
		src.health -= max(0, brute)
		if (src.stat != 2 && src.health <= 0) //u ded
			if (brute >= src.max_health)
				src.gib()
			else
				death()
		return

	examine()
		..()
		var/msg = "*---------*<br>"

		if (src.stat == 2)
			msg += "<span style'color:red'>It looks dead and lifeless</span><br>"
			msg += "*---------*"
			return out(usr, msg)

		msg += "<span style='color: blue;'>"
		if (src.active_tool)
			msg += "[src] is holding a little [bicon(src.active_tool)] [src.active_tool]"
			if (istype(src.active_tool, /obj/item/magtractor) && src.active_tool:holding)
				msg += ", containing \an [src.active_tool:holding]"
			msg += "<br>"
		msg += "[src] has a power charge of [bicon(src.cell)] [src.cell.charge]/[src.cell.maxcharge]<br>"
		msg += "</span>"

		if (src.health < src.max_health)
			if (src.health < (src.max_health / 2))
				msg += "<span style='color:red'>It's rather badly damaged. It probably needs some wiring replaced inside.</span><br>"
			else
				msg += "<span style='color:red'>It's a bit damaged. It looks like it needs some welding done.</span><br>"

		msg += "*---------*"
		out(usr, msg)

	Login()
		..()
		if (src.stat == 0)
			src.visible_message("<span style='color: blue'>[src.name] comes online.</span>", "<span style='color: blue'>You come online!</span>")
			src.updateSprite()

	Logout()
		..()
		src.updateSprite()

	proc/setStunnedEffects()
		if (!src.stunned || src.removeStunEffects)
			src.setFace(src.faceType, src.faceColor)
			src.UpdateOverlays(null, "dizzy")
			src.removeStunEffects = 0
			src.hasStunEffects = 0
			return

		else if (!src.hasStunEffects)
			var/image/myFace = src.SafeGetOverlayImage("face", src.icon, "drone-dizzy", MOB_OVERLAY_BASE)
			if (myFace)
				if (myFace.color != src.faceColor)
					myFace.color = src.faceColor
				src.UpdateOverlays(myFace, "face")

			var/image/dizzyStars = src.SafeGetOverlayImage("dizzy", src.icon, "dizzy", MOB_OVERLAY_BASE+1)
			if (dizzyStars)
				src.UpdateOverlays(dizzyStars, "dizzy")
			src.hasStunEffects = 1

	//Change that faaaaace
	proc/setFace(type = "happy", color = "#7fc5ed")
		if (src.charging || src.stunned) //Save state but don't apply changes if charging or stunned
			src.faceType = type
			src.faceColor = color
			return 1

		if (src.bedsheet) //No overlays or lumin for drones under a sheet
			UpdateOverlays(null, "face")
			src.icon_state = "g_drone-[type]"
			return 1

		/*var/image/newFace = GetOverlayImage("face")
		var/forceNew = 0
		if (!newFace)
			forceNew = 1
			newFace = image(src.icon, "drone-[type]")
		newFace.layer = MOB_OVERLAY_BASE

		if (type != src.faceType) //Type is new
			src.faceType = type
			newFace.icon_state = "drone-[type]"*/

		var/image/newFace = src.SafeGetOverlayImage("face", src.icon, "drone-[type]", MOB_OVERLAY_BASE)
		if (!newFace) // this should never be the case but let's be careful anyway!!
			src.faceType = type
			src.faceColor = color
			return 1

		if (color != src.faceColor || newFace.color != color)//forceNew) //Color is new
			src.faceColor = color
			newFace.color = color
			updateHoverDiscs(color) //ok we're also gonna color hoverdiscs too because hell yeah kickin rad

		if (length(color) == 7) //Set our luminosity color, if valid
			var/colors = GetColors(src.faceColor)
			colors[1] = colors[1] / 255
			colors[2] = colors[2] / 255
			colors[3] = colors[3] / 255
			light.set_color(colors[1], colors[2], colors[3])

		light.enable()
		UpdateOverlays(newFace, "face")
		return 1

	proc/setFaceDialog()
		var/newFace = input(usr, "Select your faceplate", "Drone", src.faceType) as null|anything in list("Happy", "Sad", "Mad")
		if (!newFace) return 0
		var/newColor = input(usr, "Select your faceplate color", "Drone", src.faceColor) as null|color
		if (!newFace && !newColor) return 0
		newFace = (newFace ? lowertext(newFace) : src.faceType)
		newColor = (newColor ? newColor : src.faceColor)
		src.setFace(type = newFace, color = newColor)
		return 1

	proc/updateHoverDiscs(color = "#7fc5ed")
		var/image/newHover = GetOverlayImage("hoverDiscs")
		if (!newHover) newHover = image('icons/effects/effects.dmi', "hoverdiscs")

		newHover.color = color
		newHover.pixel_y = -5
		newHover.layer = MOB_EFFECT_LAYER

		UpdateOverlays(newHover, "hoverDiscs")
		return 1

	proc/updateSprite()
		if (stat == 2 || !src.client || src.charging || src.newDrone)
			light.disable()
			if (!src.bedsheet)
				if (src.newDrone)
					src.icon_state = "drone-idle"
				else if (src.charging)
					src.icon_state = "drone-charging"
				else // dead or no client
					src.icon_state = "drone-dead"
			else
				src.icon_state = "g_drone-dead"
			if (src.stat != 2)
				light.set_color(0.94, 0.88, 0.12) //yellow
				light.enable()
/*			if (stat == 2 || !src.client)
				if (src.bedsheet)
					src.icon_state = "g_drone-dead"
				else
					src.icon_state = "drone-dead"
			else //Being charged or newdrone
				if (!src.bedsheet) //Until we get a bedsheet charging icon
					if (src.charging)
						src.icon_state = "drone-charging"
					else if (src.newDrone)
						src.icon_state = "drone-idle"

				light.set_color(0.94, 0.88, 0.12) //yellow
				light.enable()
*/
			UpdateOverlays(null, "face")
			UpdateOverlays(null, "hoverDiscs")
			animate(src) //stop bumble animation
		else if (src.client)
			//New drone stuff
			if (!src.faceType)
				src.setFace(type = "happy", color = "#7fc5ed") //defaults

			if (src.health >= 0)
				animate_bumble(src, floatspeed = 15, Y1 = 2, Y2 = -2) //yayyyyy bumble anim
				if (src.bedsheet)
					src.icon_state = "g_drone-[faceType]"
				else
					src.icon_state = "drone"

				//damage states to go here

	hand_attack(atom/target, params)
		//A thing to stop drones interacting with pick-up-able things by default
		if (target && istype(target, /obj/item))
			var/obj/item/I = target
			if (!I.anchored)
				return 0

		..()

	click(atom/target, params)
		if (params["alt"])
			target.examine() // in theory, usr should be us, this is shit though
			return

		if (src.in_point_mode)
			src.point(target)
			src.toggle_point_mode()
			return

		var/obj/item/item = target
		if (istype(item) && item == src.equipped())
			if (!disable_next_click && world.time < src.next_click)
				return
			item.attack_self(src)
			return

		if (params["ctrl"])
			var/atom/movable/movable = target
			if (istype(movable))
				movable.pull()
			return

		if (get_dist(src, target) > 0) // temporary fix for cyborgs turning by clicking
			dir = get_dir(src, target)

		var/obj/item/W = src.equipped()
		//if (W.useInnerItem && W.contents.len > 0)
		//	W = pick(W.contents)

		if ((!disable_next_click || ismob(target) || (target && target.flags & USEDELAY) || (W && W.flags & USEDELAY)) && world.time < src.next_click)
			return src.next_click - world.time

		var/reach = can_reach(src, target)
		if (reach || (W && (W.flags & EXTRADELAY))) //Fuck you, magic number prickjerk
			if (!disable_next_click || ismob(target))
				src.next_click = world.time + 10
			if (W && istype(W))
				weapon_attack(target, W, reach, params)
			else if (!W)
				hand_attack(target, params)
		else if (!reach && W)
			if (!disable_next_click || ismob(target))
				src.next_click = world.time + 10
			var/pixelable = isturf(target)
			if (!pixelable)
				if (istype(target, /atom/movable) && isturf(target:loc))
					pixelable = 1
			if (pixelable)
				W.pixelaction(target, params, src, 0)
		else if (!W)
			hand_range_attack(target, params)

	Stat()
		..()
		if(src.cell)
			stat("Charge Left:", "[src.cell.charge]/[src.cell.maxcharge]")
		else
			stat("No Cell Inserted!")

	Bump(atom/movable/AM as mob|obj, yes)
		spawn( 0 )
			if ((!( yes ) || src.now_pushing))
				return
			src.now_pushing = 1
			if(ismob(AM))
				var/mob/tmob = AM
				if(istype(tmob, /mob/living/carbon/human) && tmob.bioHolder && tmob.bioHolder.HasEffect("fat"))
					if(prob(20))
						for(var/mob/M in viewers(src, null))
							if(M.client)
								boutput(M, "<span style=\"color:red\"><B>[src] fails to push [tmob]'s fat ass out of the way.</B></span>")
						src.now_pushing = 0
						src.unlock_medal("That's no moon, that's a GOURMAND!", 1)
						return
			src.now_pushing = 0
			//..()
			if (!istype(AM, /atom/movable))
				return
			if (!src.now_pushing)
				src.now_pushing = 1
				if (!AM.anchored)
					var/t = get_dir(src, AM)
					step(AM, t)
				src.now_pushing = null
			if(AM)
				AM.last_bumped = world.timeofday
				AM.Bumped(src)
			return
		return

	//Four very important procs follow
	proc/putonHat(obj/item/clothing/head/W as obj, mob/user as mob)
		src.hat = W
		W.set_loc(src)

		UpdateOverlays(null, "hat")
		var/image/hatImage = image(icon = W.icon, icon_state = W.icon_state, layer = MOB_OVERLAY_BASE)
		hatImage.pixel_y = 5
		hatImage.transform *= 0.85
		hatImage.layer = EFFECTS_LAYER_4
		UpdateOverlays(hatImage, "hat")
		return 1

	proc/takeoffHat(forcedDir = null)
		UpdateOverlays(null, "hat")
		src.hat.set_loc(get_turf(src))
		if (forcedDir)
			var/turf/T = get_ranged_target_turf(src, forcedDir, 3)
			src.hat.throw_at(T, 3, 1)

		src.hat = null
		return 1

	proc/putonSheet(obj/item/clothing/suit/bedsheet/W as obj, mob/user as mob)
		W.set_loc(src)
		src.bedsheet = W
		src.setFace(type = faceType, color = faceColor) //removes face overlay and lumin (also sets icon)
		return 1

	proc/takeoffSheet()
		src.bedsheet.set_loc(get_turf(src))
		src.bedsheet = null
		if (src.stat == 0) //alive
			src.setFace(type = faceType, color = faceColor) //to re-init face overlay and lumin
			src.icon_state = "drone"
		else //dead
			src.icon_state = "drone-dead"
		return 1

	attackby(obj/item/W as obj, mob/user as mob)
		if (src.stat != 0) return
		if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WELD = W
			if (user.a_intent == INTENT_HARM)
				if (WELD.welding)
					user.visible_message("<span style=\"color:red\"><b>[user] burns [src] with [W]!</b></span>")
					damage_heat(WELD.force)
				else
					user.visible_message("<span style=\"color:red\"><b>[user] beats [src] with [W]!</b></span>")
					damage_blunt(WELD.force)
			else
				if (src.health >= src.max_health)
					boutput(user, "<span style=\"color:red\">It isn't damaged!</span>")
					return
				if (get_x_percentage_of_y(src.health,src.max_health) < 33)
					boutput(user, "<span style=\"color:red\">You need to use wire to fix the cabling first.</span>")
					return
				if (WELD.get_fuel() > 1)
					src.health = max(1,min(src.health + 10,src.max_health))
					WELD.use_fuel(1)
					playsound(src.loc, "sound/items/Welder.ogg", 50, 1)
					user.visible_message("<b>[user]</b> uses [WELD] to repair some of [src]'s damage.")
					if (src.health == src.max_health)
						boutput(user, "<span style=\"color:blue\"><b>[src] looks fully repaired!</b></span>")
				else
					boutput(user, "<span style=\"color:red\">You need more welding fuel!</span>")

		else if (istype(W,/obj/item/cable_coil/))
			if (src.health >= src.max_health)
				boutput(user, "<span style=\"color:red\">It isn't damaged!</span>")
				return
			var/obj/item/cable_coil/C = W
			if (get_x_percentage_of_y(src.health,src.max_health) >= 33)
				boutput(usr, "<span style=\"color:red\">The cabling looks fine. Use a welder to repair the rest of the damage.</span>")
				return
			C.use(1)
			src.health = max(1,min(src.health + 10,src.max_health))
			user.visible_message("<b>[user]</b> uses [C] to repair some of [src]'s cabling.")
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			if (src.health >= 50)
				boutput(user, "<span style=\"color:blue\">The wiring is fully repaired. Now you need to weld the external plating.</span>")

		else if (istype(W, /obj/item/clothing/head))
			if(src.hat)
				boutput(user, "<span style=\"color:red\">[src] is already wearing a hat!</span>")
				return

			user.drop_item()
			src.putonHat(W, user)
			if (user == src)

			else
				user.visible_message("<b>[user]</b> gently places a hat on [src]!", "You gently place a hat on [src]!")
			return

		else if (istype(W, /obj/item/clothing/suit/bedsheet))
			if (src.bedsheet)
				boutput(user, "<span style=\"color:red\">There is already a sheet draped over [src]! Two sheets would be ridiculous!</span>")
				return

			user.drop_item()
			src.putonSheet(W, user)
			user.visible_message("<b>[user]</b> drapes a sheet over [src]!", "You cover [src] with a sheet!")
			return

		else
			return ..(W, user)

	attack_hand(mob/user)
		if(!user.stat)
			switch(user.a_intent)
				if(INTENT_HELP) //Friend person
					playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -2)
					user.visible_message("<span style=\"color:blue\">[user] gives [src] a [pick_string("descriptors.txt", "borg_pat")] pat on the [pick("back", "head", "shoulder")].</span>")
				if(INTENT_DISARM) //Shove
					spawn(0) playsound(src.loc, 'sound/weapons/punchmiss.ogg', 40, 1)
					user.visible_message("<span style=\"color:red\"><B>[user] shoves [src]! [prob(40) ? pick_string("descriptors.txt", "jerks") : null]</B></span>")
					if (src.hat)
						user.visible_message("<b>[user]</b> knocks \the [src.hat] off [src]!", "You knock the hat off [src]!")
						src.takeoffHat()
					else if (src.bedsheet)
						user.visible_message("<b>[user]</b> pulls the sheet off [src]!", "You pull the sheet off [src]!")
						src.takeoffSheet()
				if(INTENT_GRAB) //Shake
					playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 30, 1, -2)
					user.visible_message("<span style=\"color:red\">[user] shakes [src] [pick_string("descriptors.txt", "borg_shake")]!</span>")
				if(INTENT_HARM) //Dumbo
					playsound(src.loc, 'sound/effects/metal_bang.ogg', 60, 1)
					user.visible_message("<span style=\"color:red\"><B>[user] punches [src]! What [pick_string("descriptors.txt", "borg_punch")]!</span>", "<span style=\"color:red\"><B>You punch [src]![prob(20) ? " Turns out they were made of metal!" : null] Ouch!</B></span>")
					random_brute_damage(user, rand(2,5))
					if(prob(10)) user.show_text("Your hand hurts...", "red")

			add_fingerprint(user)

	weapon_attack(atom/target, obj/item/W, reach, params)
		//Prevents drones attacking other people hahahaaaaaaa
		if (isliving(target) && !isghostdrone(target))
			out(src, "<span class='combat bold'>Your internal law subroutines kick in and prevent you from using [W] on [target]!</span>")
			return
		else
			..(target, W, reach, params)

	proc/store_active_tool()
		if (!src.active_tool)
			return
		src.active_tool.dropped(src) // Handle light datums and the like.
		src.active_tool = null
		hud.set_active_tool(0)
		hud.update_tools()

	equipped()
		if (!active_tool)
			return null
		return active_tool

	proc/uneq_slot()
		if (src.active_tool)
			if (istype(src.active_tool, /obj/item/magtractor) && src.active_tool:holding)
				actions.stopId("magpickerhold", src)
			if (isitem(src.active_tool))
				src.active_tool.dropped(src) // Handle light datums and the like.
		src.active_tool = null
		hud.set_active_tool(null)
		hud.update_tools()
		hud.update_equipment()

	proc/use_power()
		if (src.cell)
			if(src.cell.charge <= 0)
				if (src.stat == 0)
					out(src, "<span class='combat bold'>You have run out of power!</span>")
					death()
			else if (src.cell.charge <= 100)
				src.active_tool = null

				uneq_slot()
				src.cell.use(1)
			else
				var/power_use_tally = 2
				if (src.active_tool)
					power_use_tally += 3
					if (istype(src.active_tool, /obj/item/magtractor) && src.active_tool:highpower)
						power_use_tally += 15
				src.cell.use(power_use_tally)
				src.blinded = 0
				src.stat = 0
		else //This basically should never happen with ghostdrones
			if (src.stat == 0)
				death()

		src.hud.update_charge()

	Move(a, b, flag)
		if (src.buckled) return

		if (src.restrained()) src.pulling = null

		var/t7 = 1
		if (src.restrained())
			for(var/mob/M in range(src, 1))
				if ((M.pulling == src && M.stat == 0 && !( M.restrained() ))) t7 = null
		if ((t7 && (src.pulling && ((get_dist(src, src.pulling) <= 1 || src.pulling.loc == src.loc) && (src.client && src.client.moving)))))
			var/turf/T = src.loc
			. = ..()

			if (src.pulling && src.pulling.loc)
				if(!( isturf(src.pulling.loc) ))
					src.pulling = null
					return
				else
					if(Debug)
						diary <<"src.pulling disappeared? at [__LINE__] in mob.dm - src.pulling = [src.pulling]"
						diary <<"REPORT THIS"

			if(src.pulling && src.pulling.anchored)
				src.pulling = null
				return

			if (!src.restrained())
				var/diag = get_dir(src, src.pulling)
				if ((diag - 1) & diag)
				else diag = null

				if ((get_dist(src, src.pulling) > 1 || diag))
					if (ismob(src.pulling))
						var/mob/M = src.pulling
						var/ok = 1
						if (locate(/obj/item/grab, M.grabbed_by))
							if (prob(75))
								var/obj/item/grab/G = pick(M.grabbed_by)
								if (istype(G, /obj/item/grab))
									for(var/mob/O in viewers(M, null))
										O.show_message(text("<span style=\"color:red\">[G.affecting] has been pulled from [G.assailant]'s grip by [src]</span>"), 1)
									qdel(G)
							else
								ok = 0
							if (locate(/obj/item/grab, M.grabbed_by.len))
								ok = 0
						if (ok)
							var/t = M.pulling
							M.pulling = null
							step(src.pulling, get_dir(src.pulling.loc, T))
							if (istype(src.pulling, /mob/living))
								var/mob/living/some_idiot = src.pulling
								if (some_idiot.buckled && !some_idiot.buckled.anchored)
									step(some_idiot.buckled, get_dir(some_idiot.buckled.loc, T))
							M.pulling = t
					else
						if (src.pulling)
							step(src.pulling, get_dir(src.pulling.loc, T))
							if (istype(src.pulling, /mob/living))
								var/mob/living/some_idiot = src.pulling
								if (some_idiot.buckled && !some_idiot.buckled.anchored)
									step(some_idiot.buckled, get_dir(some_idiot.buckled.loc, T))
		else
			src.pulling = null
			hud.update_pulling()
			. = ..()

		if (src.s_active && !(s_active.master in src))
			src.detach_hud(src.s_active)
			src.s_active = null

	drop_item_v()
		return

	emote(var/act, var/voluntary = 1)
		var/param = null
		if (findtext(act, " ", 1, null))
			var/t1 = findtext(act, " ", 1, null)
			param = copytext(act, t1 + 1, length(act) + 1)
			act = copytext(act, 1, t1)

		var/m_type = 1
		var/m_anim = 0
		var/message

		switch(lowertext(act))
			if ("help")
				src.show_text("To use emotes, simply enter \"*(emote)\" as the entire content of a say message. Certain emotes can be targeted at other characters - to do this, enter \"*emote (name of character)\" without the brackets.")
				src.show_text("For a list of all emotes, use *list. For a list of basic emotes, use *listbasic. For a list of emotes that can be targeted, use *listtarget.")

			if ("list")
				src.show_text("Basic emotes:")
				src.show_text("clap, flap, aflap, twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")
				src.show_text("Targetable emotes:")
				src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, point")

			if ("listbasic")
				src.show_text("clap, flap, aflap, twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")

			if ("listtarget")
				src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, point")

			if ("salute","bow","hug","wave","glare","stare","look","leer","nod")
				// visible targeted emotes
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (!M)
						param = null

					act = lowertext(act)
					if (param)
						switch(act)
							if ("bow","wave","nod")
								message = "<B>[src]</B> [act]s to [param]."
							if ("glare","stare","look","leer")
								message = "<B>[src]</B> [act]s at [param]."
							else
								message = "<B>[src]</B> [act]s [param]."
					else
						switch(act)
							if ("hug")
								message = "<B>[src]</b> [act]s itself."
							else
								message = "<B>[src]</b> [act]s."
				else
					message = "<B>[src]</B> struggles to move."
				m_type = 1

			if ("point")
				if (!src.restrained())
					var/mob/M = null
					if (param)
						for (var/atom/A as mob|obj|turf|area in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break

					if (!M)
						message = "<B>[src]</B> points."
					else
						src.point(M)

					if (M)
						message = "<B>[src]</B> points to [M]."
					else
				m_type = 1

			if ("panic","freakout")
				if (!src.restrained())
					message = "<B>[src]</B> enters a state of hysterical panic!"
				else
					message = "<B>[src]</B> starts writhing around in manic terror!"
				m_type = 1

			if ("clap")
				if (!src.restrained())
					message = "<B>[src]</B> claps."
					m_type = 2

			if ("flap")
				if (!src.restrained())
					message = "<B>[src]</B> flaps its wings."
					m_type = 2

			if ("aflap")
				if (!src.restrained())
					message = "<B>[src]</B> flaps its wings ANGRILY!"
					m_type = 2

			if ("custom")
				var/input = sanitize(input("Choose an emote to display."))
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

			if ("customv")
				if (!param)
					return
				message = "<b>[src]</b> [param]"
				m_type = 1

			if ("customh")
				if (!param)
					return
				message = "<b>[src]</b> [param]"
				m_type = 2

			if ("smile","grin","smirk","frown","scowl","grimace","sulk","pout","blink","nod","shrug","think","ponder","contemplate")
				// basic visible single-word emotes
				message = "<B>[src]</B> [act]s."
				m_type = 1

			if ("flipout")
				message = "<B>[src]</B> flips the fuck out!"
				m_type = 1

			if ("rage","fury","angry")
				message = "<B>[src]</B> becomes utterly furious!"
				m_type = 1

			if ("twitch")
				message = "<B>[src]</B> twitches."
				m_type = 1
				spawn(0)
					var/old_x = src.pixel_x
					var/old_y = src.pixel_y
					src.pixel_x += rand(-2,2)
					src.pixel_y += rand(-1,1)
					sleep(2)
					src.pixel_x = old_x
					src.pixel_y = old_y

			if ("twitch_v","twitch_s")
				message = "<B>[src]</B> twitches violently."
				m_type = 1
				spawn(0)
					var/old_x = src.pixel_x
					var/old_y = src.pixel_y
					src.pixel_x += rand(-3,3)
					src.pixel_y += rand(-1,1)
					sleep(2)
					src.pixel_x = old_x
					src.pixel_y = old_y

			if ("birdwell", "burp")
				if (src.emote_check(voluntary, 50))
					message = "<B>[src]</B> birdwells."
					playsound(src.loc, "sound/vox/birdwell.ogg", 50, 1)

			if ("scream")
				if (src.emote_check(voluntary, 50))
					if (narrator_mode)
						playsound(src.loc, 'sound/vox/scream.ogg', 50, 1, 0, src.get_age_pitch())
					else
						playsound(get_turf(src), src.sound_scream, 80, 0, 0, src.get_age_pitch())
					message = "<b>[src]</b> screams!"

			if ("johnny")
				var/M
				if (param)
					M = adminscrub(param)
				if (!M)
					param = null
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows its name out in smoke."
					m_type = 2

			if ("flip")
				if (src.emote_check(voluntary, 50))
					if (narrator_mode)
						playsound(src.loc, pick('sound/vox/deeoo.ogg', 'sound/vox/dadeda.ogg'), 50, 1)
					else
						playsound(src.loc, pick(src.sound_flip1, src.sound_flip2), 50, 1)
					message = "<B>[src]</B> does a flip!"
					m_anim = 1
					if (prob(50))
						animate_spin(src, "R", 1, 0)
					else
						animate_spin(src, "L", 1, 0)

					for (var/mob/living/M in view(1, null))
						if (M == src)
							continue
						message = "<B>[src]</B> beep-bops at [M]."
						break

			if ("fart")
				if (src.emote_check(voluntary))
					m_type = 2
					var/fart_on_other = 0
					for (var/mob/living/M in src.loc)
						if (M == src || !M.lying)
							continue
						message = "<span style=\"color:red\"><B>[src]</B> farts in [M]'s face!</span>"
						fart_on_other = 1
						break
					if (!fart_on_other)
						switch (rand(1, 48))
							if (1) message = "<B>[src]</B> lets out a girly little 'toot' from his fart synthesizer."
							if (2) message = "<B>[src]</B> farts loudly!"
							if (3) message = "<B>[src]</B> lets one rip!"
							if (4) message = "<B>[src]</B> farts! It sounds wet and smells like rotten eggs."
							if (5) message = "<B>[src]</B> farts robustly!"
							if (6) message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."
							if (7) message = "<B>[src]</B> queefed out his metal ass!"
							if (8) message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."
							if (9) message = "<B>[src]</B> farts a ten second long fart."
							if (10) message = "<B>[src]</B> groans and moans, farting like the world depended on it."
							if (11) message = "<B>[src]</B> breaks wind!"
							if (12) message = "<B>[src]</B> synthesizes a farting sound."
							if (13) message = "<B>[src]</B> generates an audible discharge of intestinal gas."
							if (14) message = "<span style=\"color:red\"><B>[src]</B> is a farting motherfucker!!!</span>"
							if (15) message = "<span style=\"color:red\"><B>[src]</B> suffers from flatulence!</span>"
							if (16) message = "<B>[src]</B> releases flatus."
							if (17) message = "<B>[src]</B> releases gas generated in his digestive tract, his stomach and his intestines. <span style=\"color:red\"><B>It stinks way bad!</B></span>"
							if (18) message = "<B>[src]</B> farts like your mom used to!"
							if (19) message = "<B>[src]</B> farts. It smells like Soylent Surprise!"
							if (20) message = "<B>[src]</B> farts. It smells like pizza!"
							if (21) message = "<B>[src]</B> farts. It smells like George Melons' perfume!"
							if (22) message = "<B>[src]</B> farts. It smells like atmos in here now!"
							if (23) message = "<B>[src]</B> farts. It smells like medbay in here now!"
							if (24) message = "<B>[src]</B> farts. It smells like the bridge in here now!"
							if (25) message = "<B>[src]</B> farts like a pubby!"
							if (26) message = "<B>[src]</B> farts like a goone!"
							if (27) message = "<B>[src]</B> farts so hard he's certain poop came out with it, but dares not find out."
							if (28) message = "<B>[src]</B> farts delicately."
							if (29) message = "<B>[src]</B> farts timidly."
							if (30) message = "<B>[src]</B> farts very, very quietly. The stench is OVERPOWERING."
							if (31) message = "<B>[src]</B> farts and says, \"Mmm! Delightful aroma!\""
							if (32) message = "<B>[src]</B> farts and says, \"Mmm! Sexy!\""
							if (33) message = "<B>[src]</B> farts and fondles his own buttocks."
							if (34) message = "<B>[src]</B> farts and fondles YOUR buttocks."
							if (35) message = "<B>[src]</B> fart in he own mouth. A shameful [src]."
							if (36) message = "<B>[src]</B> farts out pure plasma! <span style=\"color:red\"><B>FUCK!</B></span>"
							if (37) message = "<B>[src]</B> farts out pure oxygen. What the fuck did he eat?"
							if (38) message = "<B>[src]</B> breaks wind noisily!"
							if (39) message = "<B>[src]</B> releases gas with the power of the gods! The very station trembles!!"
							if (40) message = "<B>[src] <span style=\"color:red\">f</span><span style=\"color:blue\">a</span>r<span style=\"color:red\">t</span><span style=\"color:blue\">s</span>!</B>"
							if (41) message = "<B>[src] shat his pants!</B>"
							if (42) message = "<B>[src] shat his pants!</B> Oh, no, that was just a really nasty fart."
							if (43) message = "<B>[src]</B> is a flatulent whore."
							if (44) message = "<B>[src]</B> likes the smell of his own farts."
							if (45) message = "<B>[src]</B> doesnt wipe after he poops."
							if (46) message = "<B>[src]</B> farts! Now he smells like Tiny Turtle."
							if (47) message = "<B>[src]</B> burps! He farted out of his mouth!! That's Showtime's style, baby."
							if (48) message = "<B>[src]</B> laughs! His breath smells like a fart."

					if (narrator_mode)
						playsound(src.loc, 'sound/vox/fart.ogg', 50, 1)
					else
						playsound(src.loc, src.sound_fart, 50, 1)
#ifdef DATALOGGER
					game_stats.Increment("farts")
#endif
			else
				src.show_text("Invalid Emote: [act]")
				return

		if ((message && src.stat == 0))
			logTheThing("say", src, null, "EMOTE: [message]")
			if (m_type & 1)
				for (var/mob/living/silicon/ghostdrone/O in viewers(src, null))
					O.show_message(message, m_type)
			else
				for (var/mob/living/silicon/ghostdrone/O in hearers(src, null))
					O.show_message(message, m_type)

			if (m_anim) //restart our passive animation
				spawn(10)
					animate_bumble(src, floatspeed = 15, Y1 = 2, Y2 = -2)

		return

	/*
	//No hearing any other talk ok
	say_understands(mob/other, forced_language)
		if (istype(other, /mob/living/silicon/ghostdrone))
			return 1
		else
			return 0
	*/

	say_quote(message)
		var/speechverb = pick("beeps", "boops", "buzzes", "bloops", "transmits")
		return "[speechverb], \"[message]\""

	proc/nohear_message()
		return pick("beeps", "boops", "warbles incomprehensibly", "beeps sadly", "beeeeeeeeeps")

	proc/drone_talk(message)
		message = html_encode(src.say_quote(message))
		var/rendered = "<span class='game ghostdronesay'>"
		rendered += "<span class='name' data-ctx='\ref[src.mind]'>[src.name]</span> "
		rendered += "<span class='message'>[message]</span>"
		rendered += "</span>"

		var/nohear = "<span class='game say'><span class='name' data-ctx='\ref[src.mind]'>[src.name]</span> <span class='message'>[nohear_message()]</span></span>"

		for (var/mob/M in mobs)
			if (istype(M, /mob/new_player))
				continue

			if (M.client && (M in hearers(src) || M.client.holder))
				var/thisR = rendered
				if (istype(M, /mob/living/silicon/ghostdrone) || M.client.holder)
					if (M.client.holder && src.mind)
						thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"
				else
					thisR = nohear

				M.show_message(thisR, 2)

	proc/drone_broadcast(message)
		message = html_encode(src.say_quote(message))
		var/rendered = "<span class='game ghostdronesay broadcast'>"
		rendered += "<span class='prefix'>DRONE:</span> "
		rendered += "<span class='name text-normal' data-ctx='\ref[src.mind]'>[src.name]</span> "
		rendered += "<span class='message'>[message]</span>"
		rendered += "</span>"

		var/nohear = "<span class='game say'><span class='name' data-ctx='\ref[src.mind]'>[src.name]</span> <span class='message'>[nohear_message()]</span></span>"

		for (var/mob/M in mobs)
			if (istype(M, /mob/new_player))
				continue

			if (M.client)
				var/thisR = rendered
				if (istype(M, /mob/living/silicon/ghostdrone) || M.client.holder)
					if (M.client.holder && src.mind)
						thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"
					M.show_message(thisR, 2)
				else if (M in hearers(src))
					thisR = nohear
					M.show_message(thisR, 2)

	say(message = "")
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
		if (!message)
			return

		if (src.client && src.client.ismuted())
			boutput(src, "You are currently muted and may not speak.")
			return

		if (src.stat == 2)
			return src.say_dead(message)

		// emotes
		if (dd_hasprefix(message, "*") && !src.stat)
			return src.emote(copytext(message, 2),1)

		UpdateOverlays(speech_bubble, "speech_bubble")
		spawn(15)
			UpdateOverlays(null, "speech_bubble")

		var/broadcast = 0
		if (length(message) >= 2)
			if (dd_hasprefix(message, ";"))
				message = trim(copytext(message, 2, MAX_MESSAGE_LEN))
				broadcast = 1

		if (broadcast)
			return src.drone_broadcast(message)
		else
			return src.drone_talk(message)

	proc/show_laws_drone() //A new proc because it's handled very differently from normal laws
		//custom laws detailing just how much the drone cannot hurt people or grief or whatever
		//var/laws = "<span class='bold' style='color: blue;'>"
		//laws += "Your laws:<br>"
		//laws += "1. Avoid interaction with any living or silicon lifeforms where possible. except where the lifeform is also a drone.<br>"
		//laws += "2. Maintain, repair and improve the station wherever possible.<br>"
		//laws += "</span>"
		var/laws = {"<span class='bold' style='color:blue'>Your laws:<br>
		1. Avoid interaction with any living or silicon lifeforms where possible, with the exception of other drones.<br>
		2. Do not willingly damage the station in any shape or form.<br>
		3. Maintain, repair and improve the station.<br></span>"}
		out(src, laws)
		return

	verb/cmd_show_laws()
		set category = "Drone Commands"
		set name = "Show Laws"

		src.show_laws_drone()
		return

	bullet_act(var/obj/projectile/P)
		var/dmgtype = 0 // 0 for brute, 1 for burn
		var/dmgmult = 1.2
		switch (P.proj_data.damage_type)
			if(D_PIERCING)
				dmgmult = 2
			if(D_SLASHING)
				dmgmult = 0.6
			if(D_ENERGY)
				dmgtype = 1
			if(D_BURNING)
				dmgtype = 1
				dmgmult = 0.75
			if(D_RADIOACTIVE)
				dmgtype = 1
				dmgmult = 0.2
			if(D_TOXIC)
				dmgmult = 0

		log_shot(P,src)
		src.visible_message("<span style=\"color:red\"><b>[src]</b> is struck by [P]!</span>")
		var/damage = (P.power / 3) * dmgmult

		if (src.hat) //For hats getting shot off
			UpdateOverlays(null, "hat")
			src.hat.set_loc(get_turf(src))
			//get target turf
			var/x = round(P.xo * 4)
			var/y = round(P.yo * 4)
			var/turf/target = get_offset_target_turf(src, x, y)

			src.visible_message("<span class='combat'>[src]'s [src.hat] goes flying!</span>")
			src.takeoffHat(target)

		if (damage < 1)
			return

		if(src.material) src.material.triggerOnAttacked(src, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))
		for(var/atom/A in src)
			if(A.material)
				A.material.triggerOnAttacked(A, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))

		if (!dmgtype) //brute only
			src.TakeDamage("All", damage)

	//Items being dropped ONTO this mob
	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		return

	canRideMailchutes()
		return 1

	restrained()
		return 0

	emag_act(var/mob/user, var/obj/item/card/emag/E)

	ex_act(severity)

	blob_act(var/power)

	emp_act()

	meteorhit(obj/O as obj)

	temperature_expose(null, temp, volume)
		if(src.material)
			src.material.triggerTemp(src, temp)

		for(var/atom/A in src.contents)
			if(A.material)
				A.material.triggerTemp(A, temp)

	get_static_image()
		return

/proc/droneize(target = null, pickNew = 1)
	if (!target) return 0

	var/mob/M
	if (istype(target, /client))
		var/client/C = target
		if (!C.mob) return 0
		M = C.mob

	if (istype(target, /datum/mind))
		var/datum/mind/Mind = target
		if (!Mind.current) return 0
		M = Mind.current

	if (ismob(target))
		M = target

	if (M.transforming) return 0

	var/mob/living/silicon/ghostdrone/G
	if (pickNew && islist(available_ghostdrones) && available_ghostdrones.len)
		for (var/mob/living/silicon/ghostdrone/T in available_ghostdrones)
			if (T.newDrone)
				G = T
				break
			else // why are you in this list
				available_ghostdrones -= T
		if (!G)
			//no free drones to spare
			return 0
		else
			available_ghostdrones -= G
			G.newDrone = 0
	else
		G = new /mob/living/silicon/ghostdrone(M.loc)
		G.set_loc(M.loc)

	if (ishuman(target))
		M.unequip_all()
		for(var/t in M.organs) qdel(M.organs[text("[t]")])

	M.transforming = 1
	M.canmove = 0
	M.icon = null
	M.invisibility = 101

	if (isobserver(M) && M:corpse)
		G.oldmob = M:corpse

	if (M.client)
		G.lastKnownIP = M.client.address
		M.client.mob = G

	if (M.ghost)
		if (M.ghost.mind)
			M.ghost.mind.transfer_to(G)
	else if (M.mind)
		M.mind.transfer_to(G)

/*	var/msg = "Your laws:<br>"
	msg += "<B>1. Do not interfere, harm, or interact in any way with living or previously living lifeforms.</B><br>"
	msg += "<B>2. Do not willingly damage the station in any shape or form.</B><br>"
	msg += "<B>3. Assist in repairs to the station and expansion plans.</B><br>"
	msg += "Use \"say ; (message)\" to speak to fellow drones through the spooky power of spirits within machines."

	G.show_laws_drone()
*/
	var/msg = "<span class='bold' style='color:red;font-size:150%'>You have become a drone!</span>"
	boutput(G, msg)

	G.job = "Ghostdrone"
	G.mind.assigned_role = "Ghostdrone"
	G.mind.dnr = 1
	G.oldname = M.real_name

	qdel(M)
	return G
