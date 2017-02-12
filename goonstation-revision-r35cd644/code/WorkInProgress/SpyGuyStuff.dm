/*
Contents:
Skull of Souls
Tommyize proc
Donald Trumpet
SpyGUI
*/


//////////////////////////////
//The pretty darn mean skull
//That's nice to ghosts
//		Yay
////////////////////////////
/obj/item/soulskull
	name = "ominous skull"
	desc = "This skull gives you the heebie-jeebies."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "skull_ominous"
	var/being_mean = 0

	attack_hand(mob/M)
		if(!being_mean)
			..()
			M.show_text("<B><I>It burns...!</I></B>", "red")
			if(ishuman(M)) evil_act(M)
/* oops didn't quite think this through
	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/parts/robot_parts/leg))
			var/obj/machinery/bot/skullbot/B = new /obj/machinery/bot/skullbot
			B.icon = icon('icons/obj/aibots.dmi', "skullbot-ominous")
			B.name = "ominous skullbot"
			boutput(user, "<span style=\"color:blue\">You add [W] to [src]. That's neat.</span>")
			B.set_loc(get_turf(user))
			qdel(W)
			qdel(src)
			return
*/
	proc/evil_act(mob/living/carbon/human/H)

		var/list/mob/dead/observer/possible_targets = list()
		var/list/mob/dead/observer/priority_targets = list()


		if(ticker && ticker.mode) //Yes, I'm sure my runtimes will matter if the goddamn TICKER is gone.
			for(var/datum/mind/M in (ticker.mode.Agimmicks | ticker.mode.traitors)) //We want an EVIL ghost
				if(!M.dnr && M.current && isobserver(M.current) && M.current.client && M.special_role != "vampthrall" && M.special_role != "mindslave")
					priority_targets.Add(M.current)

		if(!priority_targets.len) //Okay, fine. Any ghost. *sigh
			for(var/mob/dead/observer/O in mobs)
				if(O && O.client && O.mind && !O.mind.dnr)
					possible_targets.Add(O)


		if(!priority_targets.len && !possible_targets.len) return //Gotta have a ghostie

		being_mean = 1
		H.canmove = 0
		H.drop_item(src)
		src.set_loc(H.loc)
		src.layer = EFFECTS_LAYER_4
		playsound(src.loc, 'sound/ambience/voidfx4.ogg', 40, 1)
		spawn(0) animate_levitate(src, -1)
		H.emote("scream")

		H.weakened = 10

		spawn(70)
			if(!H)
				being_mean = 0
				return
			H.emote("faint")
			H.paralysis = 10
			H.show_text("<I><font size=5>You feel your mind drifting away from your body!</font></I>", "red")

			playsound(src.loc, 'sound/effects/ghost.ogg', 50, 1)

			if(!H.mind)
				H.ghostize()
			else
				if(priority_targets.len) //Do we have an evil ghost?
					H.mind.swap_with(pick(priority_targets))
					H.show_text("<I><B>You hear a sinister voice in your head... \"I have brought you back to do evil once more!\"</B></I>")
				else if(possible_targets.len) //Do we have a plain ol' ghost?
					H.mind.swap_with(pick(possible_targets))
				else //How the fuck did we even get here??
					H.ghostize()

			spawn(15) playsound(src.loc, 'sound/effects/ghostlaugh.ogg', 70, 1)
			flick("skull_ominous_explode", src)
			sleep(30)
			qdel(src)

//////////////////////////////
//Tommyize
////////////////////////////
proc/Create_Tommyname()
	return pick("Toh", "Tho", "To") + pick("mmh", "mh", "mm", "m") + pick("i", "eh", "yh", "ee", "u") + " " + pick("Wa", "Wi", "Wu", "Wee", "We") + pick("z", "zh", "se", "seh") + pick("oo", "oh", "eeh", "au", "ay", "uu", "uh")

/mob/proc/tommyize()
	src.transforming = 1
	src.canmove = 0
	src.invisibility = 101
	for(var/obj/item/clothing/O in src)
		src.u_equip(O)
		if (O)
			O.set_loc(src.loc)
			O.dropped(src)
			O.layer = initial(O.layer)

	var/mob/living/carbon/human/tommy/T = new(src.loc)
	if(src.mind)
		src.mind.transfer_to(T)
	else
		T.key = src.key

	spawn(10)
		qdel(src)

/mob/living/carbon/human/proc/tommyize_reshape()
	//Set up the new appearance
	var/datum/appearanceHolder/AH = new
	AH.gender = "male"
	AH.customization_first = "Dreadlocks"
	AH.gender = "male"
	AH.s_tone = -15
	AH.owner = src
	AH.parentHolder = src.bioHolder

	src.gender = "male"
	src.real_name = Create_Tommyname()
	src.sound_list_laugh = list('sound/voice/tommy_hahahah.ogg', 'sound/voice/tommy_hahahaha.ogg')
	src.sound_list_scream = list('sound/voice/tommy_you-are-tearing-me-apart-lisauh.ogg', 'sound/voice/tommy_did-not-hit-hehr.ogg')
	src.sound_list_flap = list('sound/voice/tommy_weird-chicken-noise.ogg')

	for(var/obj/item/clothing/O in src)
		src.u_equip(O)
		if (O)
			if(istype(O, /obj/item/clothing/shoes/black) || istype(O, /obj/item/clothing/under/suit))
				O.cant_drop = 1
				O.cant_other_remove = 1
				O.cant_self_remove = 1
				continue

			O.set_loc(src.loc)
			O.dropped(src)
			O.layer = initial(O.layer)

	src.equip_if_possible(new /obj/item/clothing/shoes/black {cant_drop = 1; cant_other_remove = 1; cant_self_remove = 1} (src), slot_shoes)
	src.equip_if_possible(new /obj/item/clothing/under/suit {cant_drop = 1; cant_other_remove = 1; cant_self_remove = 1} (src), slot_w_uniform)
	src.equip_if_possible(new /obj/item/football(src), slot_in_backpack)

	src.sound_malescream = 'sound/voice/tommy_you-are-tearing-me-apart-lisauh.ogg'
	src.sound_fingersnap = 'sound/voice/tommy_did-not-hit-hehr.ogg'

	if(src.bioHolder)
		src.bioHolder.mobAppearance = AH
		src.bioHolder.AddEffect("accent_tommy")
	spawn(10)
		src.bioHolder.mobAppearance.UpdateMob()

//////////////////////////////
//Tommy gun
////////////////////////////

/datum/projectile/tommy
	name = "space-tommy disruption"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "random_thing"
//How much of a punch this has, tends to be seconds/damage before any resist
	power = 10
//How much ammo this costs
	cost = 10
//How fast the power goes away
	dissipation_rate = 1
//How many tiles till it starts to lose power
	dissipation_delay = 10
//Kill/Stun ratio
	ks_ratio = 0.0
//name of the projectile setting, used when you change a guns setting
	sname = "Tommify"
//file location for the sound you want it to play
	shot_sound = 'sound/voice/tommy_hauh.ogg'
//How many projectiles should be fired, each will cost the full cost
	shot_number = 1
//What is our damage type
	damage_type = 0
	//With what % do we hit mobs laying down
	hit_ground_chance = 10
	//Can we pass windows
	window_pass = 0

	on_hit(atom/hit)
		if(ishuman(hit))
			hit:tommyize_reshape()
			playsound(hit.loc, 'sound/voice/tommy_hey-everybody.ogg', 50, 1)
		else if(ismob(hit))
			hit:tommyize()
			playsound(hit.loc, 'sound/voice/tommy_hey-everybody.ogg', 50, 1)

///////////////////////////////////////Tommy Gun

/obj/item/gun/energy/tommy_gun
	name = "Tommy Gun"
	icon = 'icons/obj/gun.dmi'
	icon_state = "tommy1"
	m_amt = 4000
	rechargeable = 1
	force = 0.0
	desc = "It smells of cheap cologne and..."

	New()
		cell = new/obj/item/ammo/power_cell/high_power
		current_projectile = new/datum/projectile/tommy
		projectiles = list(new/datum/projectile/tommy)
		..()

	update_icon()
		return

	shoot(var/target,var/start,var/mob/user,var/POX,var/POY)
		for(var/mob/O in AIviewers(user, null))
			O.show_message("<span style=\"color:red\"><B>[user] fires the [src] at [target]!</B></span>", 1, "<span style=\"color:red\">You hear a loud crackling noise.</span>", 2)
		sleep(1)
		return ..(target, start, user)

	update_icon()
		if(cell)
			src.icon_state = "tommy[src.cell.charge > 0]"
			return

///////////////////////////////////////Analysis datum for the spectrometer

/datum/spectro_analysis

	proc/analyze_reagents(var/datum/reagents/R, var/check_recipes = 0)
		if(R && R.reagent_list && R.reagent_list.len)
			if(check_recipes)
				. = analyze_reagent_components(R.reagent_list)
			else
				. = analyze_reagent_list(R.reagent_list)



	//Analyze the recipe for each reagent id. If there's more than one id this will be a fucking mess.
	proc/analyze_reagent_components(var/list/reagent_ids)
		if(reagent_ids.len)
			var/output = list()
			for (var/id in reagent_ids)

				var/datum/chemical_reaction/recipe = chem_reactions_by_id[id]
				if(recipe && recipe.required_reagents && recipe.required_reagents.len)
					analyze_reagent_list(recipe.required_reagents, output)
				else
					for(var/i=0, i<rand(2,7), i++) //If it doesn't have a recipe, just spit out some random data
						analyze_single(output, md5(rand(100,100000)))

			return output

		return null

	//Calculates the result for every reagent ID in a list
	proc/analyze_reagent_list(var/list/reagent_ids, var/list/output)
		if(reagent_ids.len)
			if(!output) output = list()
			for(var/RID in reagent_ids)
				if(reagents_cache[RID])
					output = analyze_single(output, RID)
				else
					logTheThing("debug", null, null, "<B>SpyGuy/spectro:</B> attempted to analyze invalid reagent id: [RID]")

			return output

	//This is mainly a helper
	proc/analyze_single(var/list/base, var/id)
		var/hash = md5("AReally[id]ShittySalt")
		var/listPos = calc_start_point(hash)

		for(var/i=1, i <= lentext(hash), i+=2)
			var/block = copytext(hash, i, i+2)
			if (isnull(base["[listPos]"]))
				base["[listPos]"] = hex2num(block)
			else
				base["[listPos]"]  += hex2num(block)
			listPos += (hex2num(copytext(block,1,2)) + hex2num(copytext(block,2)))
		return base

	//So is this
	proc/calc_start_point(var/hash)
		for(var/i = 1; i <= lentext(hash); i++)
			var/temp = copytext(hash, i, i+1)
			temp = hex2num(temp)
			. += temp

		. = round(. * 1.5)

/////////////////////////////// Trigger

/obj/trigger
	name = "trigger"
	desc = "warning"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1
	invisibility = 101

	HasEntered(atom/movable/AM)
		..()
		on_trigger(AM)

	proc/on_trigger(var/atom/movable/triggerer)


/obj/trigger/critter //Wakes up all critters in an area
	name = "critter trigger"
	var/area/assigned_area = null

	on_trigger(atom/movable/triggerer)
		if(isliving(triggerer) || locate(/mob) in triggerer)
			if(!assigned_area) assigned_area = get_area(src)
			assigned_area.wake_critters()

/obj/trigger/throw
	name = "throw trigger"
	var/throw_dir = NORTH

	on_trigger(var/atom/movable/triggerer)
		if(isobserver(triggerer)) return
		var/atom/target = get_edge_target_turf(src, src.throw_dir)
		spawn(0)
			if (target)
				triggerer.throw_at(target, 50, 1)


////////////////////////////// Donald Trumpet
/datum/projectile/energy_bolt_v/trumpet
	name = "trumpet bolt"
	shot_sound = 'sound/items/dootdoot.ogg'

	on_hit(atom/hit)
		..()

		if(ishuman(hit))
			var/mob/living/carbon/human/H = hit
			if(!istype(H.head, /obj/item/clothing/head/wig))
				var/obj/item/clothing/head/wig/W = H.create_wig()
				H.bioHolder.mobAppearance.customization_first = "None"
				H.cust_one_state = customization_styles["None"]
				H.drop_from_slot(H.head)
				H.force_equip(W, H.slot_head)
				H.set_clothing_icon_dirty()

/obj/item/gun/energy/dtrumpet
	name = "Donald Trumpet"
	desc = "You can tell this gun has been fired!"
	icon = 'icons/obj/instruments.dmi'
	icon_state = "trumpet"
	New()
		cell = new/obj/item/ammo/power_cell/high_power
		current_projectile = new/datum/projectile/energy_bolt_v/trumpet
		projectiles = list(new/datum/projectile/energy_bolt_v/trumpet)
		..()

////////////////////////////// Power machine
/obj/machinery/power/debug_generator
	name = "mysterious petrol generator"
	desc = "Holds untold powers. Literally. Untold power. Get it? Power. Watts? Ok, fine. This thing spits out unlimited watt-volts!! There. I said it!"
	icon_state = "ggenoff"
	density = 1
	var/generating = 0
	New()
		..()
		//UnsubscribeProcess()
	attack_hand(mob/user)
		if(!user) return
		generating = (input("Select the amount of power this machine should generate (in MW))", "Playing with power") as num) * 1e6
		if(generating > 0)
			SubscribeToProcess()
			icon_state = "ggenoff"
		else
			UnsubscribeProcess()
			icon_state = "ggen"

	process()
		..()
		if(!generating) UnsubscribeProcess()
		add_avail(generating)

////////////////////////////// Spy GUI (ha ha ha ha)
/datum/spyGUI
	var/target_file = null
	var/desired_file = ""
	var/target_window = ""
	var/target_params = ""
	var/list/mob/subscribed_mobs = new
	var/list/mob/connecting = new
	var/datum/master = null

	var/max_retries = 5
	var/time_per_try = 2

	var/validate_user = 0

	New(var/filename, var/windowname, var/parameters, var/datum/master)
		..()
		target_window = windowname
		target_params = parameters
		target_file = grabResource(filename)
		desired_file = filename
		src.master = master

	proc/getFile()
		if(!target_file)
			target_file = grabResource(desired_file)
		return target_file


	proc/displayInterface(var/mob/target, var/initData)
		if((target in connecting))
			return
		connecting[target] = initData
		var/retries = max_retries
		var/extrasleep = 0
		target << browse(getFile(), "window=[target_window];[target_params]")
		onclose(target, target_window, src)

		do
			if(winexists(target, "[target_window].browser")) //Fuck if I know
				target << output("\ref[src]", "[target_window].browser:setRef")
			sleep(time_per_try + extrasleep++)
		while(retries-- > 0 && target in connecting) //Keep trying to send the UI update until it times out or they get it.

		if(target in connecting)
			connecting -= target
			target << browse(null, target_window)

	proc/unsubscribeTarget(var/mob/target, close=1)
		if(close)
			target << browse(null, target_window)
		subscribed_mobs -= target


	Topic(href, href_list)
		..()
		DEBUG("Received: [href]")
		if (href_list["ackref"] )
			var/D = connecting[usr]
			if(D)
				connecting -= usr
				subscribed_mobs |= usr
				sendData(usr, D, "setUIState")
			return
		if (href_list["close"])
			subscribed_mobs -= usr


		if(master != src)
			master.Topic(href, href_list) //Pass the href on

	proc/validateSubscriber(var/mob/sub)
		if(!sub.client) //If the subscriber lacks a client then rip they
			return 0

		if(!validate_user)
			return 1

		. = 1
		if(sub.stat) . = 0 //Not dead / unconscious
		if ( . && istype(master, /atom)) //Range check.
			. = (sub in range(1, master))

	proc/sendToSubscribers(var/data, var/handler)
		DEBUG("Sending: [data] to [handler ? handler : "-nothing-"]")
		for(var/mob/M in subscribed_mobs)
			if(validateSubscriber(M))
				sendData(M, data, handler)
			else
				unsubscribeTarget(M)

	proc/sendData(var/mob/target, var/data, var/handler)
		var/list/L = new
		L += handler
		L += data
		var/O = list2params(L)
		target << output(O, "[target_window].browser:receiveData")



#define STAT_STANDBY 0
#define STAT_MOVING 1
#define STAT_EXTENDED 2

#define DEFAULT_ANIMATION_TIME 10
////////////////////////////// Solar Panel thingamajig
/obj/solar_control
	name = "solar panel servo"
	desc = "This machine contains a neatly-folded solar panel, for use when the ship is at little risk of external impacts and low on power."
	//invisibility = 100
	icon = 'icons/obj/machines/nuclear.dmi'
	icon_state = "engineoff"
	var/extension_dir = WEST
	var/num_panels = 4
	var/panel_width = 2
	var/panel_length = 5
	var/panel_space = 1
	var/controller_padding = 1
	var/station_padding = 2

	var/status = 0

	var/list/atom/created_atoms = list()

	//TODO:
	//Pooling and reuse of components

////Debug verbs
/obj/solar_control/verb/extend()
	set src in range(1)
	set category = "Local"
	extend_panel()

/obj/solar_control/verb/retract()
	set src in range(1)
	set category = "Local"
	retract_panel()

/obj/solar_control/proc/extend_panel()
	if(status != STAT_STANDBY) return
	icon_state = "engineon"
	status = STAT_MOVING
	var/paneldir1 = turn(extension_dir, 90)
	var/paneldir2 = turn(extension_dir, -90)
	var/list/turf/panelturfs = list()
	var/turf/walker = get_turf(src)
	DEBUG("Extending panel at [showCoords(src.x, src.y, src.z)]. extension_dir: [extension_dir] ([dir2text(extension_dir)]), paneldir1: [paneldir1] ([dir2text(paneldir1)]), paneldir2: [paneldir2] ([dir2text(paneldir2)])")
	var/total_len = station_padding + controller_padding + (panel_space * (num_panels -1)) + num_panels * panel_width
	DEBUG("Determined total length of panel to be [total_len] tiles.")

	//Create the initial padding
	DEBUG("Creating stationside padding.")
	var/list/catwalk = list(/turf/simulated/floor/plating/airless/catwalk, /obj/grille/catwalk)
	for(var/i = 0; i < station_padding;i++)
		move_create_obj(catwalk, walker, extension_dir, extension_dir) //Then we walk outwards, creating stuff as we go along
		walker = get_step(walker,extension_dir)
		/*
		if(i == 0)
			spawn(0)
				move_create_obj(list(new /obj/lattice{icon_state="lattice-dir-b"}), walker, paneldir1, paneldir2 | extension_dir)
			move_create_obj(list(new /obj/lattice{icon_state="lattice-dir-b"}), walker, paneldir2, paneldir1 | turn(extension_dir, 180))
		*/

	DEBUG("Creating panel segments.")
	//Create the panels themselves
	for(var/i = 0; i < num_panels; i++)
		for(var/j = 0; j < (panel_space + panel_width);j++)
			move_create_obj(catwalk, walker, extension_dir, (j >= panel_space) ? paneldir1 : extension_dir)
			walker = get_step(walker, extension_dir)
			if(j >= panel_space) panelturfs += walker

	DEBUG("Creating controller padding")
	for(var/i = 0; i < controller_padding; i++)
		move_create_obj(catwalk, walker, extension_dir, extension_dir) //Then we walk outwards, creating stuff as we go along
		walker = get_step(walker,extension_dir)


	DEBUG("Creating solar panels")
	var/list/solar_list = list(/turf/simulated/floor/airless/solar, /obj/machinery/power/solar)
	for(var/turf/T in panelturfs)
		spawn(0)
			var/turf/w1 = T
			var/turf/w2 = T
			for(var/i = 0; i < panel_length; i++)
				spawn(-1)
					move_create_obj(solar_list, w1, paneldir1, paneldir1)
				w1 = get_step(w1, paneldir1)
				move_create_obj(solar_list, w2, paneldir2, paneldir2)
				w2 = get_step(w2, paneldir2)

	DEBUG("Creating solar controller")
	move_create_obj(list(/turf/simulated/floor/plating/airless, /obj/machinery/power/tracker), walker, extension_dir)
	walker = get_step(walker,extension_dir)
	spawn(0) move_create_obj(list(new /obj/lattice{icon_state="lattice-dir-b"}), walker, paneldir1, paneldir2)
	move_create_obj(list(new /obj/lattice{icon_state="lattice-dir-b"}), walker, paneldir2, paneldir1)

	status = STAT_EXTENDED
	icon_state = "engineoff"

/obj/solar_control/proc/retract_panel()
	if(status != STAT_EXTENDED) return
	status = STAT_MOVING

	var/list/atom/panels = get_panels()

	for(var/i = panels.len; i > 0; i--)
		var/list/atom/L = panels[i]
		for(var/atom/A in L)
			spawn(0)
				move_and_delete_object(A)
		sleep(DEFAULT_ANIMATION_TIME)

	while(created_atoms.len > 0)
		var/atom/A = created_atoms[created_atoms.len]
		created_atoms.len--
		if(istype(A, /turf))
			var/turf/T = A
			T.ReplaceWithSpace()
		else if(istype(A,/obj))
			move_and_delete_object(A)


	status = STAT_STANDBY


/obj/solar_control/proc/get_panels()
	var/list/atom/out = list()
	var/list/atom/temp

	out.len = panel_length //A list containing all the solar panels sorted on distance from centreline
	for(var/i = created_atoms.len; i > 0; i--)
		var/atom/A = created_atoms[i]
		if(istype(A, /obj/machinery/power/solar) || istype(A, /turf/simulated/floor/airless/solar))
			var/dist = get_dist_from_centreline(A)
			temp = out[dist]
			if(!temp)
				temp = list()
				out[dist] = temp
			temp += A

	return out

/obj/solar_control/proc/move_and_delete_object(var/obj/O, var/animtime = DEFAULT_ANIMATION_TIME)
//calculate new px / py
	if(istype(O, /turf))
		var/turf/T = O
		var/obj/movedummy/MD = unpool(/obj/movedummy)
		MD.mimic_turf(T.type, 0)
		MD.set_loc(T)
		T.ReplaceWithSpace()
		O = MD

	var/tdir = get_reciprocal(O)
	var/npx = 0
	if(tdir & (EAST | WEST))
		if(tdir & WEST)
			npx = -32
		else if(tdir & EAST)
			npx = 32
	var/npy = 0
	if(tdir & (NORTH | SOUTH))
		if(tdir & NORTH)
			npy = 32
		else if (tdir & SOUTH)
			npy = -32

	animate_slide(O, npx, npy, animtime)
	sleep(animtime)
	if(istype(O, /obj/movedummy))
		pool(O)
	else
		qdel(O)


/obj/solar_control/proc/move_create_obj(var/list/atom/to_create, var/turf/startturf, var/movedir, var/setdir=null, var/animtime = DEFAULT_ANIMATION_TIME)
	//calculate initial px / py
	var/ipx = 0
	if(movedir & (EAST | WEST))
		if(movedir & WEST)
			ipx = 32
		else if(movedir & EAST)
			ipx = -32
	var/ipy = 0
	if(movedir & (NORTH | SOUTH))
		if(movedir & NORTH)
			ipy = -32
		else if (movedir & SOUTH)
			ipy = 32


	DEBUG("Initial offsets calculated based on movedir: [movedir] ([dir2text(movedir)]) as ipx: [ipx], ipy: [ipy]")
	var/is_turf = 0
	var/turf/T = get_step(startturf, movedir)
	var/turf_type = null
	for(var/t_type in to_create)
		if(ispath(t_type, /turf))
			turf_type = t_type
			break
	spawn(0)
		for(var/t_type in to_create)
			var/obj/O
			is_turf = ispath(t_type, /turf) //If it's a turf we need some special handling.

			if(istype(t_type, /obj))
				O = t_type
			else if(ispath(t_type))
				if(!is_turf)
					O = new t_type(null)
				else
					var/obj/movedummy/MD = unpool(/obj/movedummy)
					MD.mimic_turf(t_type, animtime)
					O = MD

			else if(!ispath(t_type))
				CRASH("move_create_obj not provided with type")
			if(!is_turf)
				created_atoms += O
			O.pixel_x = ipx
			O.pixel_y = ipy
			if(setdir)
				O.dir = setdir
			O.set_loc(T)
			animate_slide(O, 0, 0, animtime, LINEAR_EASING)

	playsound(T, "sound/effects/airbridge_dpl.ogg", 50, 1)
	sleep(animtime)
	if(turf_type)
		DEBUG("Creating [turf_type] at [showCoords(T.x, T.y, T.z)]")
		var/turf/NT = new turf_type(T)
		if(setdir) NT.dir = setdir
		created_atoms += NT


//Helpers
/obj/solar_control/proc/get_reciprocal(var/atom/A)
	var/d = get_dir(A,src)
	d &= ~(extension_dir | turn(extension_dir, 180)) //Turn off the bits parallell to the extension_dir
	if(!d) d = turn(extension_dir, 180) //If this wound up turning off all the bits, the dir is on the extension line
	//Look, I'm Swedish, I don't know your goddamn mathwords
	return d

/obj/solar_control/proc/get_dist_from_centreline(var/atom/A) //Finds the distance from the closest point on the extension line
	if(extension_dir & (NORTH|SOUTH) )
		.= abs(A.x - src.x)
	else if ( extension_dir & (EAST|WEST) )
		.= abs(A.y - src.y)

	DEBUG("get_dist from [showCoords(A.x, A.y, A.z)] returned: [.]")


//The dummy object that imitates a turf
/obj/movedummy
	name = "Dummy object."
	invisibility = 101

/obj/movedummy/pooled()
	..()
	invisibility = 101

/obj/movedummy/proc/mimic_turf(var/turf_type, var/TTL)
	ASSERT(ispath(turf_type, /turf))
	var/turf/T = turf_type
	src.name = initial(T.name)
	src.desc = initial(T.desc)
	src.icon = initial(T.icon)
	src.icon_state = initial(T.icon_state)
	src.density = initial(T.density)
	src.opacity = initial(T.opacity)
	src.dir = initial(T.dir)
	src.layer = initial(T.layer)
	src.invisibility = 0
	if(TTL)
		spawn(TTL)
			pool(src)

#undef STAT_STANDBY
#undef STAT_MOVING
#undef STAT_EXTENDED
#undef DEFAULT_ANIMATION_TIME

//Aw heck