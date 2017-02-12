// Observer

/mob/dead/observer
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = NOLIGHT_EFFECTS_LAYER_BASE
	density = 0
	canmove = 1
	blinded = 0
	anchored = 1	//  don't get pushed around
	var/mob/corpse = null	//	observer mode
	var/observe_round = 0
	var/health_shown = 0
	var/delete_on_logout = 1
	var/delete_on_logout_reset = 1
	var/obj/item/clothing/head/wig/wig = null

/mob/dead/observer/disposing()
	corpse = null
	..()

#define GHOST_LUM	1		// ghost luminosity

/mob/dead/observer/proc/apply_looks_of(var/client/C)
	if (!C.preferences)
		return
	var/datum/preferences/P = C.preferences

	if (!P.AH)
		return

	var/cust_one_state = customization_styles[P.AH.customization_first]
	var/cust_two_state = customization_styles[P.AH.customization_second]
	var/cust_three_state = customization_styles[P.AH.customization_third]

	var/image/hair = image('icons/mob/human_hair.dmi', cust_one_state)
	hair.color = P.AH.customization_first_color
	hair.alpha = 192
	overlays += hair

	wig = new
	wig.mat_changename = 0
	var/datum/material/wigmat = getCachedMaterial("ectofibre")
	wigmat.color = P.AH.customization_first_color
	wig.setMaterial(wigmat)
	wig.name = "ectofibre [name]'s hair"
	wig.icon = 'icons/mob/human_hair.dmi'
	wig.icon_state = cust_one_state
	wig.color = P.AH.customization_first_color
	wig.wear_image_icon = 'icons/mob/human_hair.dmi'
	wig.wear_image = image(wig.wear_image_icon, wig.icon_state)
	wig.wear_image.color = P.AH.customization_first_color


	var/image/beard = image('icons/mob/human_hair.dmi', cust_two_state)
	beard.color = P.AH.customization_second_color
	beard.alpha = 192
	overlays += beard

	var/image/detail = image('icons/mob/human_hair.dmi', cust_three_state)
	detail.color = P.AH.customization_third_color
	detail.alpha = 192
	overlays += detail

//#ifdef HALLOWEEN
/mob/dead/observer/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.icon_state != "doubleghost" && istype(mover, /obj/projectile))
		var/obj/projectile/proj = mover
		if (istype(proj.proj_data, /datum/projectile/energy_bolt_antighost))
			return 0

	return 1

/mob/dead/observer/bullet_act(var/obj/projectile/P)
	if (src.icon_state == "doubleghost")
		return

	src.icon_state = "doubleghost"
	src.visible_message("<span style=\"color:red\"><b>[src] is busted!</b></span>","<span style=\"color:red\">You are demateralized into a state of further death!</span>")
	src.corpse = null

	if (wig)
		wig.loc = src.loc
	new /obj/item/reagent_containers/food/snacks/ectoplasm(get_turf(src))
	overlays.len = 0
	log_shot(P,src)


//#endif

/mob/dead/observer/Life(datum/controller/process/mobs/parent)
	if (..(parent))
		return 1
	if (src.client) //ov1
		// overlays
		//src.updateOverlaysClient(src.client)
		src.antagonist_overlay_refresh(0, 0) // Observer Life() only runs for admin ghosts (Convair880).
	return

/mob/dead/observer/New(mob/corpse)
	. = ..()
	src.invisibility = 10
	src.sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	src.see_invisible = 16
	src.see_in_dark = SEE_DARK_FULL

	if(corpse && ismob(corpse))
		src.corpse = corpse
		src.set_loc(get_turf(corpse))
		src.real_name = corpse.real_name
		src.name = corpse.real_name
		src.verbs += /mob/dead/observer/proc/reenter_corpse
#ifdef HALLOWEEN
	src.sd_SetLuminosity(GHOST_LUM) // comment all of these back out after hallowe'en
#endif

/mob/living/verb/become_ghost()
	set src = usr
	set name = "Ghost"
	set category = "Commands"
	set desc = "Leave your lifeless body behind and become a ghost."

	if(src.stat != 2)
		if(prob(5))
			src.show_text("You strain really hard. I mean, like, really, REALLY hard but you still can't become a ghost!", "blue")
		else
			src.show_text("You're not dead yet!", "red")
		return
	src.ghostize()

/mob/proc/ghostize()
	if(src.key || src.client)
		var/mob/dead/observer/O = new/mob/dead/observer(src)
		if (isrestrictedz(O.z) && !restricted_z_allowed(O, get_turf(O)) && !(src.client && src.client.holder))
			var/OS = observer_start.len ? pick(observer_start) : locate(1, 1, 1)
			if (OS)
				O.set_loc(OS)
			else
				O.z = 1
		if (src.client && src.client.holder && src.stat !=2)
			O.stat = 0
		if(src.mind)
			src.mind.transfer_to(O)

		src.ghost = O
		return O
	return null

/mob/living/carbon/human/ghostize()
	var/mob/dead/observer/O = ..()
	if (!O)
		return null

	. = O

	var/image/hair = image('icons/mob/human_hair.dmi', cust_one_state)
	hair.color = src.bioHolder.mobAppearance.customization_first_color
	hair.alpha = 192
	O.overlays += hair

	var/image/beard = image('icons/mob/human_hair.dmi', src.cust_two_state)
	beard.color = src.bioHolder.mobAppearance.customization_second_color
	beard.alpha = 192
	O.overlays += beard

	var/image/detail = image('icons/mob/human_hair.dmi', src.cust_three_state)
	detail.color = src.bioHolder.mobAppearance.customization_third_color
	detail.alpha = 192
	O.overlays += detail

	O.wig = new
	O.wig.mat_changename = 0
	var/datum/material/wigmat = getCachedMaterial("ectofibre")
	wigmat.color = src.bioHolder.mobAppearance.customization_first_color
	O.wig.setMaterial(wigmat)
	O.wig.name = "[O.name]'s hair"
	O.wig.icon = 'icons/mob/human_hair.dmi'
	O.wig.icon_state = cust_one_state
	O.wig.color = src.bioHolder.mobAppearance.customization_first_color
	O.wig.wear_image_icon = 'icons/mob/human_hair.dmi'
	O.wig.wear_image = image(O.wig.wear_image_icon, O.wig.icon_state)
	O.wig.wear_image.color = src.bioHolder.mobAppearance.customization_first_color

	if (glasses)
		var/image/glass = image(glasses.wear_image_icon, glasses.icon_state)
		glass.color = glasses.color
		glass.alpha = glasses.alpha * 0.75
		O.overlays += glass

	return O

/mob/living/silicon/robot/ghostize()
	var/mob/dead/observer/O = ..()
	if (!O)
		return null

	O.icon_state = "borghost"
	return O

/mob/dead/observer/verb/show_health()
	set category = "Toggles"
	set name = "Toggle Health"
	client.images.Remove(health_mon_icons)
	if (!health_shown)
		health_shown = 1
		if(client && client.images)
			for(var/image/I in health_mon_icons)
				if (I && src && I.loc != src.loc)
					client.images.Add(I)
	else
		health_shown = 0

/mob/dead/observer/Logout()
	..()
	if(last_client)
		last_client.images.Remove(health_mon_icons)


	if(!src.key && delete_on_logout)
		qdel(src)
	return

/mob/dead/observer/Move(NewLoc, direct)
	if(!canmove) return

	if (NewLoc && isrestrictedz(src.z) && !restricted_z_allowed(src, NewLoc) && !(src.client && src.client.holder))
		var/OS = observer_start.len ? pick(observer_start) : locate(1, 1, 1)
		if (OS)
			src.set_loc(OS)
		else
			src.z = 1
		return

	if (!isturf(src.loc))
		src.set_loc(get_turf(src))
	if (NewLoc)
		dir = get_dir(loc, NewLoc)
		src.set_loc(NewLoc)
		return

	dir = direct
	if((direct & NORTH) && src.y < world.maxy)
		src.y++
	if((direct & SOUTH) && src.y > 1)
		src.y--
	if((direct & EAST) && src.x < world.maxx)
		src.x++
	if((direct & WEST) && src.x > 1)
		src.x--

/mob/dead/observer/can_use_hands()	return 0
/mob/dead/observer/is_active()		return 0

/mob/dead/observer/proc/reenter_corpse()
	set category = "Special Verbs"
	set name = "Re-enter Corpse"
	if(!corpse)
		alert("You don't have a corpse!")
		return
	if(src.client && src.client.holder && src.client.holder.state == 2)
		var/rank = src.client.holder.rank
		src.client.clear_admin_verbs()
		src.client.holder.state = 1
		src.client.update_admins(rank)
	if (src.mind)
		src.mind.transfer_to(corpse)
	qdel(src)

/mob/dead/observer/verb/dead_tele()
	set category = "Special Verbs"
	set name = "Teleport"
	set desc= "Teleport"
	if((usr.stat != 2) || !istype(usr, /mob/dead))
		boutput(usr, "Not when you're not dead!")
		return
	var/A

	A = input("Area to jump to", "BOOYEA", A) in teleareas
	var/area/thearea = teleareas[A]
	var/list/L = list()
	if (!istype(thearea))
		return

	for(var/turf/T in get_area_turfs(thearea.type))
		if (isrestrictedz(T.z)) //fffffuckk you
			continue
		L+=T
	usr.set_loc(pick(L))

/mob/dead/observer/proc/becomeDrone()
	set name = "Become Drone"
	set category = "Special Verbs"
	set desc = "Enter the queue to become a drone in the mortal realm"
	if((usr.stat != 2) || !istype(usr, /mob/dead))
		boutput(usr, "Not when you're not dead!")
		return

	//Wire TODO
	//Check queue participation
	//Enter into queue
	//set dnr
	//remember dialogs

/mob/dead/observer/say_understands(var/other)
	return 1

/mob/dead/observer/verb/observe()
	set name = "Observe"
	set category = "Special Verbs"

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	//prefix list with option for alphabetic sorting
	var/const/SORT = "* Sort alphabetically..."
	creatures.Add(SORT)

	// Same thing you could do with the old auth disk. The bomb is equally important
	// and should appear at the top of any unsorted list  (Convair880).
	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/nuclear))
		var/datum/game_mode/nuclear/N = ticker.mode
		if (N.the_bomb && istype(N.the_bomb, /obj/machinery/nuclearbomb/))
			var/name = "Nuclear bomb"
			if (name in names)
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = N.the_bomb

	for (var/obj/observable/O in world)
		var/name = O.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = O

	for (var/obj/item/ghostboard/GB in world)
		var/name = "Ouija board"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = GB

	for (var/obj/item/gnomechompski/G in world)
		var/name = "Gnome Chompski"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = G

	for (var/obj/cruiser_camera_dummy/CR in world)
		var/name = CR.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = CR

	for (var/obj/item/reagent_containers/food/snacks/prison_loaf/L in world)
		var/name = L.name
		if (name != "strangelet loaf")
			continue
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = L

	for (var/obj/machinery/bot/B in machines)
		var/name = "*[B.name]"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = B

	for (var/obj/item/storage/toolbox/memetic/HG in world)
		var/name = "His Grace"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = HG

	for(var/mob/M in sortmobs())
		if (!istype(M, /mob/living) && !istype(M, /mob/wraith))
			continue
		if (istype(M, /mob/living/carbon/human/secret))
			continue
		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if (M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if (istype(M, /mob/living) && M.stat == 2)
			name += " \[dead\]"
		creatures[name] = M

	/*for(var/mob/wraith/W in world)
		var/name = W.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if (W.real_name && W.real_name != W.name)
			name += " \[[W.real_name]\]"
		creatures[name] = W*/

	var/eye_name = null

	// DOESN'T SEEM TO ADD ANY FUNCTIONALITY SO HEY, WHY WAS THIS EVEN HERE
	// if (is_admin)
	//  	eye_name = input("Please, select a player!", "Admin Observe", null, null) as null|anything in creatures
	// else
	//  	eye_name = input("Please, select a player!", "Observe", null, null) as null|anything in creatures

	eye_name = input("Please, select a target!", "Observe", null, null) as null|anything in creatures

	//sort alphabetically if user so chooses
	if (eye_name == SORT)
		creatures.Remove(SORT)

		for(var/i = 1; i <= creatures.len; i++)
			for(var/j = i+1; j <= creatures.len; j++)
				if(sorttext(creatures[i], creatures[j]) == -1)
					creatures.Swap(i, j)

		//redisplay sorted list
		eye_name = input("Please, select a target!", "Observe (Sorted)", null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/atom/target = creatures[eye_name]

	var/mob/dead/target_observer/newobs = new(target)
	newobs.name = src.name
	newobs.real_name = src.real_name
	newobs.corpse = src.corpse
	newobs.my_ghost = src
	delete_on_logout_reset = delete_on_logout
	delete_on_logout = 0
	if (target.invisibility)
		newobs.see_invisible = target.invisibility
	if (src.corpse)
		corpse.ghost = newobs
	if (src.mind)
		mind.transfer_to(newobs)
	else if (src.client) //Wire: Fix for Cannot modify null.mob.
		src.client.mob = newobs
	set_loc(newobs)
