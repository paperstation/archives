// human

/mob/living/carbon/human
	name = "human"
	voice_name = "human"
	icon = 'icons/mob/mob.dmi'
	icon_state = "blank"

	var/dump_contents_chance = 20
	var/last_move_trigger = 0

	var/image/health_mon = null

	var/pin = null
	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/under/w_uniform = null
//	var/obj/item/device/radio/w_radio = null
	var/obj/item/clothing/shoes/shoes = null
	var/obj/item/belt = null
	var/obj/item/clothing/gloves/gloves = null
	var/obj/item/clothing/glasses/glasses = null
	var/obj/item/clothing/head/head = null
	//var/obj/item/card/id/wear_id = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null

	var/image/body_standing = null
	var/image/fire_standing = null
	//var/image/face_standing = null
	var/image/hands_standing = null
	var/image/damage_standing = null
	var/image/head_damage_standing = null
	var/list/inhands_standing = list()

	var/image/image_eyes = null
	var/image/image_cust_one = null
	var/image/image_cust_two = null
	var/image/image_cust_three = null

	var/last_b_state = 1.0

	var/list/implant = list()
	var/list/implant_images = list()

	var/cust_one_state = "short"
	var/cust_two_state = "None"
	var/cust_three_state = "none"

	var/can_bleed = 1
	blood_id = "blood"
	var/blood_volume = 500
	var/blood_color = DEFAULT_BLOOD_COLOR
	var/bleeding = 0
	var/bleeding_internal = 0
	var/blood_absorption_rate = 1 // amount of blood to absorb from the reagent holder per Life()
	var/list/bandaged = list()
	var/being_staunched = 0 // is someone currently putting pressure on their wounds?

	var/datum/organHolder/organHolder
	var/ignore_organs = 0 // set to 1 to basically skip the handle_organs() proc

	var/on_chair = 0
	var/simple_examine = 0

	var/last_cluwne_noise = 0 // used in /proc/process_accents() to keep cluwnes from making constant fucking noise

	var/in_throw_mode = 0

	var/decomp_stage = 0 // 1 = bloat, 2 = decay, 3 = advanced decay, 4 = skeletonized
	var/next_decomp_time = 0

	var/datum/mutantrace/mutantrace = null
	var/mimic = 0

	var/emagged = 0 //What the hell is wrong with me?
	var/spiders = 0 // SPIDERS

	var/gunshot_residue = 0 // Fire a kinetic firearm and get forensic evidence all over you (Convair880).

	var/datum/hud/human/hud
	var/mini_health_hud = 0

	//The spooky UNKILLABLE MAN
	var/unkillable = 0

	// TODO: defensive/offensive stance intents for combat
	var/stance = "normal"

	var/mob/living/carbon/target = null
	var/ai_aggressive = 0
	var/ai_default_intent = INTENT_DISARM
	var/ai_calm_down = 0 // do we chill out after a while?
	var/ai_picking_pocket = 0

	max_health = 100

	//april fools stuff
	var/blinktimer = 0
	var/blinkstate = 0
	var/breathtimer = 0
	var/breathstate = 0

	var/datum/light/burning_light

	//dismemberment stuff
	var/datum/human_limbs/limbs = null

	var/static/image/human_image = image('icons/mob/human.dmi')
	var/static/image/human_head_image = image('icons/mob/human_head.dmi')
	var/static/image/human_untoned_image = image('icons/mob/human.dmi')
	var/static/image/human_decomp_image = image('icons/mob/human_decomp.dmi')
	var/static/image/human_untoned_decomp_image = image('icons/mob/human.dmi')
	var/static/image/undies_image = image('icons/mob/human_underwear.dmi') //, layer = MOB_UNDERWEAR_LAYER)
	var/static/image/bandage_image = image('icons/obj/surgery.dmi', "layer" = EFFECTS_LAYER_UNDER_1-1)
	var/static/image/blood_image = image('icons/effects/blood.dmi', "layer" = EFFECTS_LAYER_UNDER_1-1)
	var/static/image/handcuff_img = image('icons/mob/mob.dmi')
	var/static/image/shield_image = image('icons/mob/mob.dmi', "icon_state" = "shield")
	var/static/image/heart_image = image('icons/mob/human.dmi')
	var/static/image/heart_emagged_image = image('icons/mob/human.dmi', "layer" = EFFECTS_LAYER_UNDER_1-1)
	var/static/image/spider_image = image('icons/mob/human.dmi', "layer" = EFFECTS_LAYER_UNDER_1-1)

	var/static/image/juggle_image = image('icons/mob/human.dmi', "layer" = EFFECTS_LAYER_UNDER_1-1)
	var/list/juggling = list()
	var/can_juggle = 0

	// preloaded sounds moved up to /mob/living

	var/list/sound_list_scream = null
	var/list/sound_list_laugh = null
	var/list/sound_list_flap = null

	var/list/pathogens = list()
	var/list/immunities = list()

	var/datum/simsHolder/sims = null

	var/list/random_emotes = list("drool", "blink", "yawn", "burp", "twitch", "twitch_v",\
	"cough", "sneeze", "shiver", "shudder", "shake", "hiccup", "sigh", "flinch", "blink_r", "nosepick")

/mob/living/carbon/human/New()
	. = ..()

	image_eyes = image('icons/mob/human_hair.dmi', layer = MOB_FACE_LAYER)
	image_cust_one = image('icons/mob/human_hair.dmi', layer = MOB_HAIR_LAYER2)
	image_cust_two = image('icons/mob/human_hair.dmi', layer = MOB_HAIR_LAYER2)
	image_cust_three = image('icons/mob/human_hair.dmi', layer = MOB_HAIR_LAYER2)

	var/datum/reagents/R = new/datum/reagents(330)
	reagents = R
	R.my_atom = src

	hud = new(src)
	src.attach_hud(hud)
	src.zone_sel = new(src)
	src.attach_hud(zone_sel)
	src.stamina_bar = new(src)
	hud.add_object(src.stamina_bar, HUD_LAYER+1, "EAST-1, NORTH")

	if (global_sims_mode) // IF YOU ARE HERE TO DISABLE SIMS MODE, DO NOT TOUCH THIS. LOOK IN GLOBAL.DM
		if (map_setting == "DESTINY")
			sims = new /datum/simsHolder/destiny(src)
		else
			sims = new /datum/simsHolder/human(src)

	health_mon = image('icons/effects/healthgoggles.dmi',src,"100",10)
	health_mon_icons.Add(health_mon)

	burning_light = new /datum/light/point
	burning_light.attach(src)
	burning_light.set_color(0.94, 0.69, 0.27)

	src.organHolder = new(src)

	if (!bioHolder)
		bioHolder = new/datum/bioHolder(src)
	if (!abilityHolder)
		abilityHolder = new /datum/abilityHolder/composite(src)

	spawn (1)
		if (src.disposed)
			return

		src.limbs = new /datum/human_limbs(src)

		src.organs["chest"] = src.organHolder.chest
		src.organs["head"] = src.organHolder.head
		src.organs["l_arm"] = src.limbs.l_arm
		src.organs["r_arm"] = src.limbs.r_arm
		src.organs["l_leg"] = src.limbs.l_leg
		src.organs["r_leg"] = src.limbs.r_leg

		src.update_body()
		src.update_face()
		src.UpdateDamageIcon()

/datum/human_limbs
	var/mob/living/carbon/human/holder = null

	var/obj/item/parts/l_arm = null
	var/obj/item/parts/r_arm = null
	var/obj/item/parts/l_leg = null
	var/obj/item/parts/r_leg = null

	var/l_arm_bleed = 0
	var/r_arm_bleed = 0
	var/l_leg_bleed = 0
	var/r_leg_bleed = 0

	New(mob/new_holder)
		..()
		holder = new_holder
		if (holder) create()

	dispose()
		if (l_arm)
			l_arm.holder = null
		if (r_arm)
			r_arm.holder = null
		if (l_leg)
			l_leg.holder = null
		if (r_leg)
			r_leg.holder = null
		holder = null
		..()

	proc/create()
		if (!l_arm) l_arm = new /obj/item/parts/human_parts/arm/left(holder)
		if (!r_arm) r_arm = new /obj/item/parts/human_parts/arm/right(holder)
		if (!l_leg) l_leg = new /obj/item/parts/human_parts/leg/left(holder)
		if (!r_leg) r_leg = new /obj/item/parts/human_parts/leg/right(holder)

		spawn(50)
			if (holder && !l_arm || !r_arm || !l_leg || !r_leg)
				logTheThing("debug", holder, null, "<B>SpyGuy/Limbs:</B> [src] is missing limbs after creation for some reason - recreating.")
				create()
				if (holder)
					// fix for "Cannot execute null.update body()".when mob is deleted too quickly after creation
					holder.update_body()
					if (holder.client)
						holder.client.move_delay = world.time + 7
						//Fix for not being able to move after you got new limbs.

	proc/mend(var/howmany = 4)
		if (!holder)
			return

		if (!l_arm && howmany > 0)
			l_arm = new /obj/item/parts/human_parts/arm/left(holder)
			l_arm.holder = holder
			boutput(holder, "<span style=\"color:blue\">Your left arm regrows!</span>")
			l_arm:original_holder = holder
			l_arm:set_skin_tone()
			howmany--

		if (!r_arm && howmany > 0)
			r_arm = new /obj/item/parts/human_parts/arm/right(holder)
			r_arm.holder = holder
			boutput(holder, "<span style=\"color:blue\">Your right arm regrows!</span>")
			r_arm:original_holder = holder
			r_arm:set_skin_tone()
			howmany--

		if (!l_leg && howmany > 0)
			l_leg = new /obj/item/parts/human_parts/leg/left(holder)
			l_leg.holder = holder
			boutput(holder, "<span style=\"color:blue\">Your left leg regrows!</span>")
			l_leg:original_holder = holder
			l_leg:set_skin_tone()
			howmany--

		if (!r_leg && howmany > 0)
			r_leg = new /obj/item/parts/human_parts/leg/right(holder)
			r_leg.holder = holder
			boutput(holder, "<span style=\"color:blue\">Your right leg regrows!</span>")
			r_leg:original_holder = holder
			r_leg:set_skin_tone()
			howmany--

		if (holder.client) holder.client.move_delay = world.time + 7 //Fix for not being able to move after you got new limbs.

	proc/reset_stone() // reset skintone to whatever the holder's s_tone is
		if (l_arm && istype(l_arm, /obj/item/parts/human_parts))
			l_arm:set_skin_tone()
		if (r_arm && istype(r_arm, /obj/item/parts/human_parts))
			r_arm:set_skin_tone()
		if (l_leg && istype(l_leg, /obj/item/parts/human_parts))
			l_leg:set_skin_tone()
		if (r_leg && istype(r_leg, /obj/item/parts/human_parts))
			r_leg:set_skin_tone()

	proc/sever(var/target = "all", var/mob/user)
		if (!target)
			return 0
		if (istext(target))
			var/list/limbs_to_sever = list()
			switch (target)
				if ("all")
					limbs_to_sever += list(src.l_arm, src.r_arm, src.l_leg, src.r_leg)
				if ("both_arms")
					limbs_to_sever += list(src.l_arm, src.r_arm)
				if ("both_legs")
					limbs_to_sever += list(src.l_leg, src.r_leg)
				if ("l_arm")
					limbs_to_sever += list(src.l_arm)
				if ("r_arm")
					limbs_to_sever += list(src.r_arm)
				if ("l_leg")
					limbs_to_sever += list(src.l_leg)
				if ("r_leg")
					limbs_to_sever += list(src.r_leg)
			if (limbs_to_sever.len)
				for (var/obj/item/parts/P in limbs_to_sever)
					P.sever(user)
				return 1
		else if (istype(target, /obj/item/parts))
			var/obj/item/parts/P = target
			P.sever(user)
			return 1

	proc/replace_with(var/target, var/new_type, var/mob/user)
		if (!target || !new_type || !src.holder)
			return 0
		if (istext(target) && ispath(new_type))
			if (target == "both_arms" || target == "l_arm")
				if (ispath(new_type, /obj/item/parts/human_parts/arm) || ispath(new_type, /obj/item/parts/robot_parts/arm))
					qdel(src.l_arm)
					src.l_arm = new new_type(src.holder)
				else // need to make an item arm
					qdel(src.l_arm)
					src.l_arm = new /obj/item/parts/human_parts/arm/left/item(src.holder, new new_type(src.holder))
				src.holder.show_message("<span style=\"color:blue\"><b>Your left arm [pick("magically ", "weirdly ", "suddenly ", "grodily ", "")]becomes [src.l_arm]!</b></span>")
				if (user)
					logTheThing("admin", user, src.holder, "replaced %target%'s left arm with [new_type]")
				. ++

			if (target == "both_arms" || target == "r_arm")
				if (ispath(new_type, /obj/item/parts/human_parts/arm) || ispath(new_type, /obj/item/parts/robot_parts/arm))
					qdel(src.r_arm)
					src.r_arm = new new_type(src.holder)
				else // need to make an item arm
					qdel(src.r_arm)
					src.r_arm = new /obj/item/parts/human_parts/arm/right/item(src.holder, new new_type(src.holder))
				src.holder.show_message("<span style=\"color:blue\"><b>Your right arm [pick("magically ", "weirdly ", "suddenly ", "grodily ", "")]becomes [src.r_arm]!</b></span>")
				if (user)
					logTheThing("admin", user, src.holder, "replaced %target%'s right arm with [new_type]")
				. ++

			if (target == "both_legs" || target == "l_leg")
				if (ispath(new_type, /obj/item/parts/human_parts/leg) || ispath(new_type, /obj/item/parts/robot_parts/leg))
					qdel(src.l_leg)
					src.l_leg = new new_type(src.holder)
					src.holder.show_message("<span style=\"color:blue\"><b>Your left leg [pick("magically ", "weirdly ", "suddenly ", "grodily ", "")]becomes [src.l_leg]!</b></span>")
					if (user)
						logTheThing("admin", user, src.holder, "replaced %target%'s left leg with [new_type]")
					. ++

			if (target == "both_legs" || target == "r_leg")
				if (ispath(new_type, /obj/item/parts/human_parts/leg) || ispath(new_type, /obj/item/parts/robot_parts/leg))
					qdel(src.r_leg)
					src.r_leg = new new_type(src.holder)
					src.holder.show_message("<span style=\"color:blue\"><b>Your right leg [pick("magically ", "weirdly ", "suddenly ", "grodily ", "")]becomes [src.r_leg]!</b></span>")
					if (user)
						logTheThing("admin", user, src.holder, "replaced %target%'s right leg with [new_type]")
					. ++
			if (.)
				src.holder.set_body_icon_dirty()
			return
		return 0

/mob/living/carbon/human/proc/is_changeling()
	return get_ability_holder(/datum/abilityHolder/changeling)

/mob/living/carbon/human/proc/is_vampire()
	return get_ability_holder(/datum/abilityHolder/vampire)

/mob/living/carbon/human/disposing()
	if (mutantrace)
		mutantrace.dispose()
		mutantrace = null
	target = null
	if (limbs)
		limbs.dispose()
		limbs = null
	if (organHolder)
		organHolder.dispose()
		organHolder = null
	..()

// death

/mob/living/carbon/human/Del()
	for (var/obj/item/parts/HP in src)
		HP.holder = null
	for (var/obj/item/organ/O in src)
		O.donor = null
	for (var/obj/item/implant/I in src)
		I.implanted = null
		I.owner = null
		I.former_implantee = null
	..()

/mob/living/carbon/human/death(gibbed)
	if (src.stat == 2)
		return
	if (src.healths)
		src.healths.icon_state = "health5"

	if (health_mon)
		health_mon.icon_state = "-1"

	src.need_update_item_abilities = 1
	src.stat = 2
	src.dizziness = 0
	src.jitteriness = 0

	src.remove_ailments()

	for (var/obj/item/implant/health/H in src.implant)
		if (istype(H) && !H.reported_death)
			DEBUG("[src] calling to report death")
			H.death_alert()

#ifdef DATALOGGER
	game_stats.Increment("deaths")
#endif

	//The unkillable man just respawns nearby! Oh no!
	if (src.unkillable || src.spell_soulguard)
		if (src.unkillable && src.mind.dnr) //Unless they have dnr set in which case rip for good
			logTheThing("combat", src, null, "was about to be respawned (Unkillable) but had DNR set.")
			if (!gibbed)
				src.gib()
			boutput(src, "<span style=\"color:red\">The shield hisses and buzzes grumpily! It's almost as if you have some sort of option set that prevents you from coming back to life. Fancy that.</span>")
			var/obj/item/unkill_shield/U = new /obj/item/unkill_shield
			U.set_loc(src.loc)
		else
			logTheThing("combat", src, null, "respawns ([src.spell_soulguard ? "Soul Guard" : "Unkillable"])")
			src.unkillable_respawn()

	if(src.traitHolder.hasTrait("soggy"))
		src.unequip_all()
		src.gib()
		return

	//Zombies just rise again (after a delay)! Oh my!
	if (src.mutantrace && src.mutantrace.onDeath())
		return

	if (src.bioHolder && src.bioHolder.HasEffect("revenant"))
		var/datum/bioEffect/hidden/revenant/R = src.bioHolder.GetEffect("revenant")
		R.RevenantDeath()

	if (!gibbed)
		var/datum/abilityHolder/changeling/C = get_ability_holder(/datum/abilityHolder/changeling)
	//Changelings' heads pop off and crawl away - but only if they're not gibbed and have some spare DNA points. Oy vey!
		if (C)
			if (C.points >= 10)
				var/datum/mind/M = src.mind
				emote("deathgasp")
				src.visible_message("<span style=\"color:red\"><B>[src]</B> begins to grow another head!</span>")
				src.show_text("<b>We begin to grow a headspider...</b>", "blue")
				sleep(200)
				if (M && M.current)
					M.current.show_text("<b>We released a headspider, using up some of our DNA reserves.</b>", "blue")
				src.visible_message("<span style=\"color:red\"><B>[src]</B> grows a head, which sprouts legs and wanders off, looking for food!</span>")
				//make a headspider, have it crawl to find a host, give the host the disease, hand control to the player again afterwards
				var/obj/critter/headspider/HS = new /obj/critter/headspider(get_turf(src))
				C.points = max(0, C.points - 10) // This stuff isn't free, you know.
				HS.owner = M //In case we ghosted ourselves then the body won't hold the mind. Bad times.
				HS.changeling = C
				remove_ability_holder(/datum/abilityHolder/changeling/)
				spawn(0)
					if(src.client) src.ghostize()

				logTheThing("combat", src, null, "became a headspider at [log_loc(src)].")

				HS.process() //A little kickstart to get you out into the big world (and some chump), li'l guy! O7

				return

			else boutput(src, "You try to release a headspider but don't have enough DNA points (requires 10)!")

		emote("deathgasp") //let the world KNOW WE ARE DEAD

		if (!src.mutantrace) // wow fucking racist
			modify_christmas_cheer(-7)

		src.canmove = 0
		src.lying = 1
		var/h = src.hand
		src.hand = 0
		drop_item()
		src.hand = 1
		drop_item()
		src.set_clothing_icon_dirty()
		src.hand = h

		if (istype(src.wear_suit, /obj/item/clothing/suit/armor/suicide_bomb))
			var/obj/item/clothing/suit/armor/suicide_bomb/A = src.wear_suit
			A.trigger(src)

		src.next_decomp_time = world.time + rand(480,900)*10

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch

	if (src.mind) // I think this is kinda important (Convair880).
		if (src.mind.special_role == "mindslave")
			remove_mindslave_status(src, "mslave", "death")
		else if (src.mind.special_role == "vampthrall")
			remove_mindslave_status(src, "vthrall", "death")
		else if (src.mind.master)
			remove_mindslave_status(src, "otherslave", "death")
		mind.store_memory("Time of death: [tod]", 0)
	logTheThing("combat", src, null, "dies at [log_loc(src)].")
	//src.icon_state = "dead"

	if (!src.suiciding)
		if (emergency_shuttle.location == 1)
			src.unlock_medal("HUMANOID MUST NOT ESCAPE", 1)

		if (src.handcuffed)
			src.unlock_medal("Fell down the stairs", 1)

		if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
			var/datum/game_mode/revolution/R = ticker.mode
			if (src.mind && (src.mind in R.revolutionaries)) // maybe add a check to see if they've been de-revved?
				src.unlock_medal("Expendable", 1)

		if (src.burning > 66)
			src.unlock_medal("Black and Blue", 1)

	ticker.mode.check_win()

#ifdef RESTART_WHEN_ALL_DEAD
	var/cancel
	for (var/mob/M in mobs)
		if (M.client && !M.stat)
			cancel = 1
			break

	if (!cancel && !abandon_allowed)
		spawn (50)
			cancel = 0
			for (var/mob/M in mobs)
				if (M.client && !M.stat)
					cancel = 1
					break

			if (!cancel && !abandon_allowed)
				boutput(world, "<B>Everyone is dead! Resetting in 30 seconds!</B>")

				spawn (300)
					logTheThing("diary", null, null, "Rebooting because of no live players", "game")
					Reboot_server()
#endif
	return ..(gibbed)

//Unkillable respawn proc, also used by soulguard now
// Also for removing antagonist status. New mob required to get rid of old-style, mob-specific antagonist verbs (Convair880).
/mob/living/carbon/human/proc/unkillable_respawn(var/antag_removal = 0)
	if (!antag_removal && src.bioHolder && src.bioHolder.HasEffect("revenant"))
		return

	var/turf/reappear_turf = get_turf(src)
	if (!antag_removal)
		for (var/turf/simulated/floor/S in orange(7))
			if (S == reappear_turf) continue
			if (prob(50)) //Try to appear on a turf other than the one we die on.
				reappear_turf = S
				break

	if (!antag_removal && src.spell_soulguard)
		boutput(src, "<span style=\"color:blue\">Your Soulguard enchantment activates and saves you...</span>")
		reappear_turf = pick(wizardstart)

	////////////////Set up the new body./////////////////

	var/mob/living/carbon/human/newbody = new()
	newbody.set_loc(reappear_turf)

	newbody.real_name = src.real_name

	// These necessities (organs/limbs/inventory) are bad enough. I don't care about specific damage values etc.
	// Antag status removal doesn't happen very often (Convair880).
	if (antag_removal)
		transfer_mob_inventory(src, newbody, 1, 1, 1) // There's a spawn(20) in that proc.
		if (src.stat == 2)
			newbody.stat = 2

	if (!antag_removal) // We don't want changeling etc ability holders (Convair880).
		newbody.abilityHolder = src.abilityHolder
		if (newbody.abilityHolder)
			newbody.abilityHolder.transferOwnership(newbody)
	src.abilityHolder = null

	if (!antag_removal && src.unkillable) // Doesn't work properly for half the antagonist types anyway (Convair880).
		newbody.unkillable = 1

	if (src.bioHolder)
		newbody.bioHolder.CopyOther(src.bioHolder)
		if (!antag_removal && src.spell_soulguard)
			newbody.bioHolder.RemoveAllEffects()

	// Prone to causing runtimes, don't enable.
/*	if (src.mutantrace && !src.spell_soulguard)
		newbody.mutantrace = new src.mutantrace.type(newbody)*/

	if (src.mind) //Mind transfer also handles key transfer.
		if (antag_removal)
			// Ugly but necessary until I can figure out a better to do this or every antagonist has been moved to ability holders.
			// Transfering it directly to the new mob DOESN'T dispose of certain antagonist-specific verbs (Convair880).
			var/mob/dead/observer/O_temp = new/mob/dead/observer(src)
			src.mind.transfer_to(O_temp)
			O_temp.mind.transfer_to(newbody)
			qdel(O_temp)
		else
			src.mind.transfer_to(newbody)
	else //Oh welp, still need to move that key!
		newbody.key = src.key

	////////////Now play the degibbing animation and move them to the turf.////////////////

	if (!antag_removal)
		var/atom/movable/overlay/animation = new(reappear_turf)
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		animation.icon_state = "ungibbed"
		src.unkillable = 0 //Don't want this lying around to repeatedly die or whatever.
		src.spell_soulguard = 0 // clear this as well
		src = null //Detach this, what if we get deleted before the animation ends??
		spawn(7) //Length of animation.
			newbody.set_loc(animation.loc)
			qdel(animation)
	else
		src.unkillable = 0
		src.spell_soulguard = 0
		src.invisibility = 20
		spawn(22) // Has to at least match the organ/limb replacement stuff (Convair880).
			if (src) qdel(src)

	return

// emote

/mob/living/carbon/human/emote(var/act, var/voluntary = 0)
	var/param = null

	for (var/uid in src.pathogens)
		var/datum/pathogen/P = src.pathogens[uid]
		if (P.onemote(act))
			return

	if (!bioHolder) bioHolder = new/datum/bioHolder( src )

	if (src.bioHolder.HasEffect("revenant"))
		src.visible_message("<span style=\"color:red\">[src] makes [pick("a rude", "an eldritch", "a", "an eerie", "an otherworldly", "a netherly", "a spooky")] gesture!</span>")
		return

	if (findtext(act, " ", 1, null))
		var/t1 = findtext(act, " ", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	var/m_type = 1

	for (var/obj/item/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	var/message = null
	if (src.mutantrace)
		message = src.mutantrace.emote(act)
	if (!message)
		switch (lowertext(act))
			if ("custom")
				if (src.client)
					var/input = sanitize(html_encode(input("Choose an emote to display.")))
					var/input2 = input("Is this a visible or audible emote?") in list("Visible","Audible")
					if (input2 == "Visible") m_type = 1
					else if (input2 == "Audible") m_type = 2
					else
						alert("Unable to use this emote, must be either audible or visible.")
						return
					message = "<B>[src]</B> [input]"

			if ("customv")
				if (!param)
					return
				param = sanitize(html_encode(param))
				message = "<b>[src]</b> [param]"
				m_type = 1

			if ("customh")
				if (!param)
					return
				param = sanitize(html_encode(param))
				message = "<b>[src]</b> [param]"
				m_type = 2

			if ("me")
				if (!param)
					return
				param = sanitize(html_encode(param))
				message = "<b>[src]</b> [param]"
				m_type = 1 // default to visible

			if ("give")
				if (!src.restrained())
					if (!src.emote_check(voluntary, 50))
						return
					var/obj/item/thing = src.equipped()
					if (!thing)
						if (src.l_hand)
							thing = src.l_hand
						else if (src.r_hand)
							thing = src.r_hand

					if (thing)
						var/mob/living/carbon/human/H = null
						if (param)
							for (var/mob/living/carbon/human/M in view(1, src))
								if (ckey(param) == ckey(M.name))
									H = M
									break
						else
							var/list/possible_recipients = list()
							for (var/mob/living/carbon/human/M in view(1, src))
								possible_recipients += M
							if (possible_recipients.len)
								H = input(src, "Who would you like to hand your [thing] to?", "Choice") as null|anything in possible_recipients

						if (!istype(H))
							return

						if (alert(H, "[src] offers [his_or_her(src)] [thing] to you. Do you accept it?", "Choice", "Yes", "No") == "Yes")
							if (!thing || !H || !(get_dist(src, H) <= 1) || thing.loc != src || src.restrained())
								return
							if (src.bioHolder && src.bioHolder.HasEffect("clumsy") && prob(50))
								message = "<B>[src]</B> tries to hand [thing] to [H], but [src] drops it!"
								src.u_equip(thing)
								thing.set_loc(src.loc)
							else if (H.bioHolder && H.bioHolder.HasEffect("clumsy") && prob(50))
								message = "<B>[src]</B> tries to hand [thing] to [H], but [H] drops it!"
								src.u_equip(thing)
								thing.set_loc(H.loc)
							else if (H.put_in_hand(thing))
								message = "<B>[src]</B> hands [thing] to [H]."
								src.u_equip(thing)
								H.update_clothing()
							else
								message = "<B>[src]</B> tries to hand [thing] to [H], but [H]'s hands are full!"
						else
							src.show_text("[H] declines your offer.")
				else
					message = "<B>[src]</B> struggles to move."
				m_type = 1

			if ("help")
				src.show_text("To use emotes, simply enter 'me (emote)' in the input bar. Certain emotes can be targeted at other characters - to do this, enter 'me (emote) (name of character)' without the brackets.")
				src.show_text("For a list of all emotes, use 'me list'. For a list of basic emotes, use 'me listbasic'. For a list of emotes that can be targeted, use 'me listtarget'.")

			if ("listbasic")
				src.show_text("smile, grin, smirk, frown, scowl, grimace, sulk, pout, blink, drool, shrug, tremble, quiver, shiver, shudder, shake, \
				think, ponder, clap, flap, aflap, laugh, chuckle, giggle, chortle, guffaw, cough, hiccup, sigh, mumble, grumble, groan, moan, sneeze, \
				sniff, snore, whimper, yawn, choke, gasp, weep, sob, wail, whine, gurgle, gargle, blush, flinch, blink_r, eyebrow, shakehead, shakebutt, \
				pale, flipout, rage, shame, raisehand, crackknuckles, stretch, rude, cry, retch, raspberry, tantrum, gesticulate, wgesticulate, smug, \
				nosepick, flex, facepalm, panic, snap, airquote, twitch, twitch_v, faint, deathgasp, signal, wink, collapse, dance, scream, \
				burp, fart, monologue, contemplate, custom")

			if ("listtarget")
				src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, tweak, flipoff, doubleflip, shakefist, handshake, daps, slap, boggle")

			if ("suicide")
				src.show_text("Suicide is a command, not an emote.  Please type 'suicide' in the input bar at the bottom of the game window to kill yourself.", "red")

	//april fools start

			if ("inhale")
				if (!manualbreathing)
					src.show_text("You are already breathing!")
					return
				if (src.breathstate)
					src.show_text("You just breathed in, try breathing out next dummy!")
					return
				src.show_text("You breathe in.")
				src.breathtimer = 0
				src.breathstate = 1

			if ("exhale")
				if (!manualbreathing)
					src.show_text("You are already breathing!")
					return
				if (!src.breathstate)
					src.show_text("You just breathed out, try breathing in next silly!")
					return
				src.show_text("You breathe out.")
				src.breathstate = 0

			if ("closeeyes")
				if (!manualblinking)
					src.show_text("Why would you want to do that?")
					return
				if (src.blinkstate)
					src.show_text("You just closed your eyes, try opening them now dumbo!")
					return
				src.show_text("You close your eyes.")
				src.blinkstate = 1
				src.blinktimer = 0

			if ("openeyes")
				if (!manualblinking)
					src.show_text("Your eyes are already open!")
					return
				if (!src.blinkstate)
					src.show_text("Your eyes are already open, try closing them next moron!")
					return
				src.show_text("You open your eyes.")
				src.blinkstate = 0

	//april fools end

			if ("birdwell")
				if ((src.client && src.client.holder) && src.emote_check(voluntary, 50))
					message = "<B>[src]</B> birdwells."
					playsound(src.loc, "sound/vox/birdwell.ogg", 50, 1)
				else
					src.show_text("Unusable emote '[act]'. 'Me help' for a list.", "blue")
					return

			if ("uguu")
				if (istype(src.wear_mask, /obj/item/clothing/mask/anime) && !src.stat)

					message = "<B>[src]</B> uguus!"
					m_type = 2
					if (narrator_mode)
						playsound(get_turf(src), 'sound/vox/uguu.ogg', 80, 0, 0, src.get_age_pitch())
					else
						playsound(get_turf(src), 'sound/misc/uguu.ogg', 80, 0, 0, src.get_age_pitch())
					spawn(10)
						src.gib()
						new /obj/item/clothing/mask/anime(src.loc)
						return
				else
					src.show_text("You just don't feel kawaii enough to uguu right now!", "red")
					return

			if ("twirl", "spin", "juggle")
				if (!src.restrained())
					if (src.emote_check(voluntary, 25))
						m_type = 1

						// clown juggling
						if ((src.mind && src.mind.assigned_role == "Clown") || src.can_juggle)
							var/obj/item/thing = src.equipped()
							if (!thing)
								if (src.l_hand)
									thing = src.l_hand
								else if (src.r_hand)
									thing = src.r_hand
							if (thing)
								if (src.juggling())
									if (prob(src.juggling.len * 5)) // might drop stuff while already juggling things
										src.drop_juggle()
									else
										src.add_juggle(thing)
								else
									src.add_juggle(thing)
							else
								message = "<B>[src]</B> wiggles \his fingers a bit.[prob(10) ? " Weird." : null]"

						// everyone else
						else
							var/obj/item/thing = src.equipped()
							if (!thing)
								if (src.l_hand)
									thing = src.l_hand
								else if (src.r_hand)
									thing = src.r_hand
							if (thing)
								if ((src.bioHolder && src.bioHolder.HasEffect("clumsy") && prob(50)) || (src.reagents && prob(src.reagents.get_reagent_amount("ethanol") / 2)) || prob(5))
									message = "<B>[src]</B> [pick("spins", "twirls")] [thing] around in [his_or_her(src)] hand, and drops it right on the ground.[prob(10) ? " What an oaf." : null]"
									src.u_equip(thing)
									thing.set_loc(src.loc)
								else
									message = "<B>[src]</B> [pick("spins", "twirls")] [thing] around in [his_or_her(src)] hand."
									thing.on_spin_emote(src)
							else
								message = "<B>[src]</B> wiggles [his_or_her(src)] fingers a bit.[prob(10) ? " Weird." : null]"
				else
					message = "<B>[src]</B> struggles to move."

			if ("tip")
				if (!src.restrained() && !src.stat)
					if (istype(src.head, /obj/item/clothing/head/fedora))
						var/obj/item/clothing/head/fedora/hat = src.head
						message = "<B>[src]</B> tips \his [hat] and [pick("winks", "smiles", "grins", "smirks")].<br><B>[src]</B> [pick("says", "states", "articulates", "implies", "proclaims", "proclamates", "promulgates", "exclaims", "exclamates", "extols", "predicates")], &quot;M'lady.&quot;"
						spawn(10)
							hat.set_loc(src.loc)
							src.head = null
							src.gib()
					else if (istype(src.head, /obj/item/clothing/head) && !istype(src.head, /obj/item/clothing/head/fedora))
						src.show_text("This hat just isn't [pick("fancy", "suave", "manly", "sexerific", "majestic", "euphoric")] enough for that!", "red")
						return
					else
						src.show_text("You can't tip a hat you don't have!", "red")
						return

			if ("hatstomp", "stomphat")
				if (!src.restrained())
					var/obj/item/clothing/head/helmet/HoS/hat = src.find_type_in_hand(/obj/item/clothing/head/helmet/HoS)
					var/hat_or_beret = null
					var/already_stomped = null // store the picked phrase in here
					var/on_head = 0

					if (!hat) // if the find_type_in_hand() returned 0 earlier
						if (istype(src.head, /obj/item/clothing/head/helmet/HoS)) // maybe it's on our head?
							hat = src.head
							on_head = 1
						else // if not then never mind
							return
					if (hat.icon_state == "hosberet" || hat.icon_state == "hosberet-smash") // does it have one of the beret icons?
						hat_or_beret = "beret" // call it a beret
					else // otherwise?
						hat_or_beret = "hat" // call it a hat. this should cover cases where the hat somehow doesn't have either hosberet or hoscap
					if (hat.icon_state == "hosberet-smash" || hat.icon_state == "hoscap-smash") // has it been smashed already?
						already_stomped = pick(" That [hat_or_beret] has seen better days.", " That [hat_or_beret] is looking pretty shabby.", " How much more abuse can that [hat_or_beret] take?", " It looks kinda ripped up now.") // then add some extra flavor text

					// the actual messages are generated here
					if (on_head)
						message = "<B>[src]</B> yanks \his [hat_or_beret] off \his head, throws it on the floor and stomps on it![already_stomped]\
						<br><B>[src]</B> grumbles, \"<i>rasmn frasmn grmmn[prob(1) ? " dick dastardly" : null]</i>.\""
					else
						message = "<B>[src]</B> throws \his [hat_or_beret] on the floor and stomps on it![already_stomped]\
						<br><B>[src]</B> grumbles, \"<i>rasmn frasmn grmmn</i>.\""

					if (hat_or_beret == "beret")
						hat.icon_state = "hosberet-smash" // make sure it looks smushed!
					else
						hat.icon_state = "hoscap-smash"
					src.drop_from_slot(hat) // we're done here, drop that hat!

				else
					message = "<B>[src]</B> tries to move \his arm and grumbles."
				m_type = 1

			if ("handpuppet")
				message = "<b>[src]</b> throws their voice, badly, as they flap their thumb and index finger like some sort of lips.[prob(50) ? "  Perhaps they're off their meds?" : null]"
				m_type = 1

			if ("smile","grin","smirk","frown","scowl","grimace","sulk","pout","blink","drool","shrug","tremble","quiver","shiver","shudder","shake","think","ponder","contemplate","grump")
				// basic visible single-word emotes
				message = "<B>[src]</B> [act]s."
				m_type = 1

			if (":)")
				message = "<B>[src]</B> smiles."
				m_type = 1

			if (":(")
				message = "<B>[src]</B> frowns."
				m_type = 1

			if (":d", ">:)") // the switch is lowertext()ed so this is what :D would be
				message = "<B>[src]</B> grins."
				m_type = 1

			if ("d:", "dx") // same as above for D: and DX
				message = "<B>[src]</B> grimaces."
				m_type = 1

			if (">:(")
				message = "<B>[src]</B> scowls."
				m_type = 1

			if (":j")
				message = "<B>[src]</B> smirks."
				m_type = 1

			if (":i")
				message = "<B>[src]</B> grumps."
				m_type = 1

			if (":|")
				message = "<B>[src]</B> stares."
				m_type = 1

			if ("xd")
				message = "<B>[src]</B> laughs."
				m_type = 1

			if (":c")
				message = "<B>[src]</B> pouts."
				m_type = 1

			if ("clap")
				// basic visible single-word emotes - unusable while restrained
				if (!src.restrained())
					message = "<B>[src]</B> [lowertext(act)]s."
				else
					message = "<B>[src]</B> struggles to move."
				m_type = 1

			if ("cough","hiccup","sigh","mumble","grumble","groan","moan","sneeze","sniff","snore","whimper","yawn","choke","gasp","weep","sob","wail","whine","gurgle","gargle")
				// basic audible single-word emotes
				if (!muzzled)
					if (lowertext(act) == "sigh" && prob(1)) act = "singh" //1% chance to change sigh to singh. a bad joke for drsingh fans.
					message = "<B>[src]</B> [act]s."
				else
					message = "<B>[src]</B> tries to make a noise."
				m_type = 2

			if ("laugh","chuckle","giggle","chortle","guffaw","cackle")
				if (!muzzled)
					message = "<B>[src]</B> [act]s."
					if (src.sound_list_laugh && src.sound_list_laugh.len)
						playsound(src.loc, pick(src.sound_list_laugh), 80, 0, 0, src.get_age_pitch())
				else
					message = "<B>[src]</B> tries to make a noise."
				m_type = 2

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
								message = "<B>[src]</b> [act]s \himself."
							else
								message = "<B>[src]</b> [act]s."
				else
					message = "<B>[src]</B> struggles to move."
				m_type = 1

			// basic emotes that change the wording a bit

			if ("blush")
				message = "<B>[src]</B> blushes."
				m_type = 1

			if ("flinch")
				message = "<B>[src]</B> flinches."
				m_type = 1

			if ("blink_r")
				message = "<B>[src]</B> blinks rapidly."
				m_type = 1

			if ("eyebrow","raiseeyebrow")
				message = "<B>[src]</B> raises an eyebrow."
				m_type = 1

			if ("shakehead","smh")
				message = "<B>[src]</B> shakes \his head."
				m_type = 1

			if ("shakebutt","shakebooty","shakeass","twerk")
				message = "<B>[src]</B> shakes \his ass!"
				m_type = 1

				spawn (5)
					var/beeMax = 15
					for (var/obj/critter/domestic_bee/responseBee in range(5, src))
						if (!responseBee.alive)
							continue

						if (beeMax-- < 0)
							break

						if (prob(75))
							responseBee.visible_message("<b>[responseBee]</b> buzzes [pick("in a confused manner", "perplexedly", "in a perplexed manner")].")
						else
							responseBee.visible_message("<b>[responseBee]</b> can't understand [src]'s accent!")

			if ("pale")
				message = "<B>[src]</B> goes pale for a second."
				m_type = 1

			if ("flipout")
				message = "<B>[src]</B> flips the fuck out!"
				m_type = 1

			if ("rage","fury","angry")
				message = "<B>[src]</B> becomes utterly furious!"
				m_type = 1

			if ("shame","hanghead")
				message = "<B>[src]</B> hangs \his head in shame."
				m_type = 1

			// basic emotes with alternates for restraints

			if ("flap")
				if (!src.restrained())
					message = "<B>[src]</B> flaps \his arms!"
					if (src.sound_list_flap && src.sound_list_flap.len)
						playsound(src.loc, pick(src.sound_list_flap), 80, 0, 0, src.get_age_pitch())
				else
					message = "<B>[src]</B> writhes!"
				m_type = 1

			if ("aflap")
				if (!src.restrained())
					message = "<B>[src]</B> flaps \his arms ANGRILY!"
					if (src.sound_list_flap && src.sound_list_flap.len)
						playsound(src.loc, pick(src.sound_list_flap), 80, 0, 0, src.get_age_pitch())
				else
					message = "<B>[src]</B> writhes angrily!"
				m_type = 1

			if ("raisehand")
				if (!src.restrained()) message = "<B>[src]</B> raises a hand."
				else message = "<B>[src]</B> tries to move \his arm."
				m_type = 1

			if ("crackknuckles","knuckles")
				if (!src.restrained()) message = "<B>[src]</B> cracks \his knuckles."
				else message = "<B>[src]</B> irritably shuffles around."
				m_type = 1

			if ("stretch")
				if (!src.restrained()) message = "<B>[src]</B> stretches."
				else message = "<B>[src]</B> writhes around slowly."
				m_type = 1

			if ("rude")
				if (!src.restrained()) message = "<B>[src]</B> makes a rude gesture."
				else message = "<B>[src]</B> tries to move \his arm."
				m_type = 1

			if ("cry")
				if (!muzzled) message = "<B>[src]</B> cries."
				else message = "<B>[src]</B> makes an odd noise. A tear runs down \his face."
				m_type = 2

			if ("retch","gag")
				if (!muzzled) message = "<B>[src]</B> retches in disgust!"
				else message = "<B>[src]</B> makes a strange choking sound."
				m_type = 2

			if ("raspberry")
				if (!muzzled) message = "<B>[src]</B> blows a raspberry."
				else message = "<B>[src]</B> slobbers all over \himself."
				m_type = 2

			if ("tantrum")
				if (!src.restrained()) message = "<B>[src]</B> throws a tantrum!"
				else message = "<B>[src]</B> starts wriggling around furiously!"
				m_type = 1

			if ("gesticulate")
				if (!src.restrained()) message = "<B>[src]</B> gesticulates."
				else message = "<B>[src]</B> wriggles around a lot."
				m_type = 1

			if ("wgesticulate")
				if (!src.restrained()) message = "<B>[src]</B> gesticulates wildly."
				else message = "<B>[src]</B> enthusiastically wriggles around a lot!"
				m_type = 1

			if ("smug")
				if (!src.restrained()) message = "<B>[src]</B> folds \his arms and smirks broadly, making a self-satisfied \"heh\"."
				else message = "<B>[src]</B> shuffles a bit and smirks broadly, emitting a rather self-satisfied noise."
				m_type = 1

			if ("nosepick","picknose")
				if (!src.restrained()) message = "<B>[src]</B> picks \his nose."
				else message = "<B>[src]</B> sniffs and scrunches \his face up irritably."
				m_type = 1

			if ("flex","flexmuscles")
				if (!src.restrained())
					var/roboarms = src.limbs && istype(src.limbs.r_arm, /obj/item/parts/robot_parts) && istype(src.limbs.l_arm, /obj/item/parts/robot_parts)
					if (roboarms) message = "<B>[src]</B> flexes \his powerful robotic muscles."
					else message = "<B>[src]</B> flexes \his muscles."
				else message = "<B>[src]</B> tries to stretch \his arms."
				m_type = 1

			if ("facepalm")
				if (!src.restrained()) message = "<B>[src]</B> places \his hand on \his face in exasperation."
				else message = "<B>[src]</B> looks rather exasperated."
				m_type = 1

			if ("panic","freakout")
				if (!src.restrained()) message = "<B>[src]</B> enters a state of hysterical panic!"
				else message = "<B>[src]</B> starts writhing around in manic terror!"
				m_type = 1

			// targeted emotes

			if ("tweak","tweaknipples","tweaknips","nippletweak")
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(1, src))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (!M)
						param = null

					if (param)
						message = "<B>[src]</B> tweaks [param]'s nipples."
					else
						message = "<B>[src]</b> tweaks \his nipples."
				m_type = 1

			if ("flipoff","flipbird","middlefinger")
				m_type = 1
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (M) message = "<B>[src]</B> flips off [M]."
					else message = "<B>[src]</B> raises \his middle finger."
				else message = "<B>[src]</B> scowls and tries to move \his arm."

			if ("doubleflip","doubledeuce","doublebird","flip2")
				m_type = 1
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (M) message = "<B>[src]</B> gives [M] the double deuce!"
					else message = "<B>[src]</B> raises both of \his middle fingers."
				else message = "<B>[src]</B> scowls and tries to move \his arms."

			if ("boggle")
				m_type = 1
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (ckey(param) == ckey(A.name))
							M = A
							break
				if (M) message = "<B>[src]</B> boggles at [M]'s stupidity."
				else message = "<B>[src]</B> boggles at the stupidity of it all."

			if ("shakefist")
				m_type = 1
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (M) message = "<B>[src]</B> angrily shakes \his fist at [M]!"
					else message = "<B>[src]</B> angrily shakes \his fist!"
				else message = "<B>[src]</B> tries to move \his arm angrily!"

			if ("handshake","shakehand","shakehands")
				m_type = 1
				if (!src.restrained() && !src.r_hand)
					var/mob/M = null
					if (param)
						for (var/mob/A in view(1, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (M == src) M = null

					if (M)
						if (M.canmove && !M.r_hand && !M.restrained()) message = "<B>[src]</B> shakes hands with [M]."
						else message = "<B>[src]</B> holds out \his hand to [M]."

			if ("daps","dap")
				m_type = 1
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(1, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (M) message = "<B>[src]</B> gives daps to [M]."
					else message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."
				else message = "<B>[src]</B> wriggles around a bit."

			if ("slap","bitchslap","smack")
				m_type = 1
				if (!src.restrained())
					if (src.emote_check(voluntary))
						if (src.bioHolder.HasEffect("chime_snaps"))
							src.sound_snap = 'sound/misc/glass_step.ogg'
						var/M = null
						if (param)
							for (var/mob/A in view(1, null))
								if (ckey(param) == ckey(A.name))
									M = A
									break
						if (M) message = "<B>[src]</B> slaps [M] across the face! Ouch!"
						else
							message = "<B>[src]</B> slaps \himself!"
							src.TakeDamage("head", 0, 4, 0, DAMAGE_BURN)
						playsound(src.loc, src.sound_snap, 100, 1)
				else message = "<B>[src]</B> lurches forward strangely and aggressively!"

			// emotes that do STUFF! or are complex in some way i guess

			if ("snap","snapfingers","fingersnap","click","clickfingers")
				if (!src.restrained())
					if (src.emote_check(voluntary))
						if (src.bioHolder.HasEffect("chime_snaps"))
							src.sound_fingersnap = 'sound/machines/chime_5.ogg'
							src.sound_snap = 'sound/misc/glass_step.ogg'
						if (prob(5))
							message = "<font color=red><B>[src]</B> snaps \his fingers RIGHT OFF!</font>"
							/*
							if (src.bioHolder)
								src.bioHolder.AddEffect("[src.hand ? "left" : "right"]_arm")
							else
							*/
							random_brute_damage(src, 20)
							if (narrator_mode)
								playsound(src.loc, 'sound/vox/break.ogg', 100, 1)
							else
								playsound(src.loc, src.sound_snap, 100, 1)
						else
							message = "<B>[src]</B> snaps \his fingers."
							if (narrator_mode)
								playsound(src.loc, 'sound/vox/deeoo.ogg', 50, 1)
							else
								playsound(src.loc, src.sound_fingersnap, 50, 1)

			if ("airquote","airquotes")
				if (param)
					param = strip_html(param, 200)
					message = "<B>[src]</B> sneers, \"Ah yes, \"[param]\". We have dismissed that claim.\""
					m_type = 2
				else
					message = "<B>[src]</B> makes air quotes with \his fingers."
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

			if ("faint")
				message = "<B>[src]</B> faints."
				src.sleeping = 1
				m_type = 1

			if ("deathgasp")
				if (prob(15) && !src.is_changeling() && src.stat != 2) message = "<B>[src]</B> seizes up and falls limp, peeking out of one eye sneakily."
				else message = "<B>[src]</B> seizes up and falls limp, \his eyes dead and lifeless..."
				m_type = 1

			if ("johnny")
				var/M
				if (param) M = adminscrub(param)
				if (!M) param = null
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows \his name out in smoke."
					m_type = 2

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

			if ("signal")
				if (!src.restrained())
					var/t1 = min( max( round(text2num(param)), 1), 10)
					if (isnum(t1))
						if (t1 <= 5 && (!src.r_hand || !src.l_hand))
							message = "<B>[src]</B> raises [t1] finger\s."
						else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
							message = "<B>[src]</B> raises [t1] finger\s."
				m_type = 1

			if ("wink")
				for (var/obj/item/clothing/C in src.get_equipped_items())
					if ((locate(/obj/item/gun/kinetic/derringer) in C) != null)
						var/obj/item/gun/kinetic/derringer/D = (locate(/obj/item/gun/kinetic/derringer) in C)
						var/drophand = (src.hand == 0 ? slot_r_hand : slot_l_hand)
						drop_item()
						D.set_loc(src)
						equip_if_possible(D, drophand)
						src.visible_message("<span style=\"color:red\"><B>[src] pulls a derringer out of \the [C]!</B></span>")
						playsound(src.loc, "rustle", 60, 1)
						break

				message = "<B>[src]</B> winks."
				m_type = 1

			if ("collapse")
				if (!src.paralysis)
					src.paralysis += 2
				message = "<B>[src]</B> collapses!"
				m_type = 2

			if ("dance", "boogie")
				if (src.emote_check(voluntary, 50))
					if (iswizard(src) && prob(10))
						message = pick("<span style=\"color:red\"><B>[src]</B> breaks out the most unreal dance move you've ever seen!</span>", "<span style=\"color:red\"><B>[src]'s</B> dance move borders on the goddamn diabolical!</span>")
						src.say("GHET DAUN!")
						animate_flash_color_fill(src,"#5C0E80", 1, 10)
						animate_levitate(src, 1, 10)
						spawn(0) // some movement to make it look cooler
							for (var/i = 0, i < 10, i++)
								src.dir = turn(src.dir, 90)
								sleep(2)

						var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
						s.set_up(3, 1, src)
						s.start()

					else
						if (!src.restrained())

							// implement some special visual moves
							var/dancemove = rand(1,5)

							switch(dancemove)
								if (1)
									message = "<B>[src]</B> busts out some mad moves."
									spawn(0)
										for (var/i = 0, i < 4, i++)
											src.dir = turn(src.dir, 90)
											sleep(2)

								if (2)
									message = "<B>[src]</B> does the twist, like they did last summer."
									spawn(0)
										for (var/i = 0, i < 4, i++)
											src.dir = turn(src.dir, -90)
											sleep(2)

								if (3)
									message = "<B>[src]</B> moonwalks."
									spawn(0)
										for (var/i = 0, i < 4, i++)
											src.pixel_x+= 2
											sleep(2)
										for (var/i = 0, i < 4, i++)
											src.pixel_x-= 2
											sleep(2)

								if (4)
									message = "<B>[src]</B> boogies!"
									spawn(0)
										for (var/i = 0, i < 4, i++)
											src.pixel_x+= 2
											src.dir = turn(src.dir, 90)
											sleep(2)
										for (var/i = 0, i < 4, i++)
											src.pixel_x-= 2
											src.dir = turn(src.dir, 90)
											sleep(2)

								else
									message = pick("<B>[src]</B> gets on down.","<B>[src]</B> dances!", "<B>[src]</B> cranks out some dizzying windmills.")
									// expand this too, however much

								// todo: add context-sensitive break dancing and some other goofy shit


							spawn(5)
								var/beeMax = 15
								for (var/obj/critter/domestic_bee/responseBee in range(7, src))
									if (!responseBee.alive)
										continue

									if (beeMax-- < 0)
										break

									responseBee.dance_response()

							spawn(5)
								var/parrotMax = 15
								for (var/obj/critter/parrot/responseParrot in range(7, src))
									if (!responseParrot.alive)
										continue
									if (parrotMax-- < 0)
										break
									responseParrot.dance_response()

							if (src.reagents)
								if (src.reagents.has_reagent("ants") && src.reagents.has_reagent("mutagen"))
									var/ant_amt = src.reagents.get_reagent_amount("ants")
									var/mut_amt = src.reagents.get_reagent_amount("mutagen")
									src.reagents.del_reagent("ants")
									src.reagents.del_reagent("mutagen")
									src.reagents.add_reagent("spiders", ant_amt + mut_amt)
									boutput(src, "<span style=\"color:blue\">The ants arachnify.</span>")
									playsound(get_turf(src), "sound/effects/bubbles.ogg", 80, 1)

						else
							message = "<B>[src]</B> twitches feebly in time to music only they can hear."

			if ("flip")
				if (src.emote_check(voluntary, 50) && !src.shrunk)

					//TODO: space flipping
					//if ((!src.restrained()) && (!src.lying) && (istype(src.loc, /turf/space)))
					//	message = "<B>[src]</B> does a flip!"
					//	if (prob(50))
					//		animate(src, transform = turn(GetPooledMatrix(), 90), time = 1, loop = -1)
					//		animate(transform = turn(GetPooledMatrix(), 180), time = 1, loop = -1)
					//		animate(transform = turn(GetPooledMatrix(), 270), time = 1, loop = -1)
					//		animate(transform = turn(GetPooledMatrix(), 360), time = 1, loop = -1)
					//	else
					//		animate(src, transform = turn(GetPooledMatrix(), -90), time = 1, loop = -1)
					//		animate(transform = turn(GetPooledMatrix(), -180), time = 1, loop = -1)
					//		animate(transform = turn(GetPooledMatrix(), -270), time = 1, loop = -1)
					//		animate(transform = turn(GetPooledMatrix(), -360), time = 1, loop = -1)
					if (istype(src.loc,/obj/))
						var/obj/container = src.loc
						boutput(src, "<span style=\"color:red\">You leap and slam your head against the inside of [container]! Ouch!</span>")
						src.paralysis += 2
						src.weakened += 4
						container.visible_message("<span style=\"color:red\"><b>[container]</b> emits a loud thump and rattles a bit.</span>")
						playsound(src.loc, "sound/effects/bang.ogg", 50, 1)
						var/wiggle = 6
						while(wiggle > 0)
							wiggle--
							container.pixel_x = rand(-3,3)
							container.pixel_y = rand(-3,3)
							sleep(1)
						container.pixel_x = 0
						container.pixel_y = 0
						if (prob(33))
							if (istype(container, /obj/storage))
								var/obj/storage/C = container
								if (C.can_flip_bust == 1)
									boutput(src, "<span style=\"color:red\">[C] [pick("cracks","bends","shakes","groans")].</span>")
									C.bust_out()

					if (!iswrestler(src))
						if (src.stamina <= STAMINA_FLIP_COST || (src.stamina - STAMINA_FLIP_COST) <= 0)
							boutput(src, "<span style=\"color:red\">You fall over, panting and wheezing.</span>")
							message = "<span style=\"color:red\"><B>[src]</b> falls over, panting and wheezing.</span>"
							src.weakened += 2
							src.set_stamina(min(1, src.stamina))
							src.emote_allowed = 0
							goto showmessage

					for (var/mob/living/M in oview(3))
						if (M == src)
							continue
						if (src.on_chair == 1)
							var/found_chair = 0
							for (var/obj/stool/chair/C in src.loc.contents)
								found_chair = 1
							if (!found_chair)
								src.pixel_y = 0
								src.anchored = 0
								src.on_chair = 0
								src.buckled = null
								break
							if (!istype(usr.equipped(), /obj/item/grab))
								//src.set_loc(M.loc)
								src.pixel_y = 0
								src.buckled = null
								src.anchored = 0
								. = 1
								if (M && M.loc != src.loc) // just in case, so the user doesn't fall into nullspace if they fly at a person mid-gibbing or whatever
									var/list/flipLine = getline(src, M)
									for (var/turf/T in flipLine)
										if (!istype(src.loc, /turf) || T.density || LinkBlockedWithAccess(src.loc, T))
											message = "<span style=\"color:red\"><B>[src]</b> does a flying flip...into the ground.  Like a big doofus.</span>"
											src.weakened = 5
											. = 0
											break
										else
											src.set_loc(T)

								src.emote("scream")
								src.on_chair = 0

								if (!iswrestler(src) && src.traitHolder && !src.traitHolder.hasTrait("glasscannon"))
									src.remove_stamina(STAMINA_FLIP_COST)
									src.stamina_stun()

								if (.)
									playsound(src.loc, "sound/effects/fleshbr1.ogg", 75, 1)
									message = "<span style=\"color:red\"><B>[src]</B> does a flying flip into [M]!</span>"
									logTheThing("combat", src, M, "[src] chairflips into %target%, [showCoords(M.x, M.y, M.z)].")
									M.lastattacker = src
									M.lastattackertime = world.time

									if (iswrestler(src))
										if (prob(33))
											M.ex_act(3)
										else
											random_brute_damage(M, 25)
											M.weakened = max(M.weakened, 3)
											M.stunned = max(M.stunned, 5)
									else
										random_brute_damage(M, 10)
										M.weakened = max(M.weakened, 2)
										M.stunned = max(M.stunned, 3)
										src.weakened = max(src.weakened, 1)
										src.stunned = max(src.weakened, 2)

							if (!src.reagents.has_reagent("fliptonium"))
								if (prob(50))
									animate_spin(src, "R", 1, 0)
								else
									animate_spin(src, "L", 1, 0)

						break
					if ((!istype(src.loc, /turf/space)) && (!src.on_chair))
						if (!src.lying)
							if ((src.restrained()) || (src.reagents && src.reagents.get_reagent_amount("ethanol") > 30) || (src.bioHolder.HasEffect("clumsy")))
								message = pick("<B>[src]</B> tries to flip, but stumbles!", "<B>[src]</B> slips!")
								src.weakened += 4
								src.TakeDamage("head", 8, 0, 0, DAMAGE_BLUNT)
							if (src.bioHolder.HasEffect("fat"))
								message = pick("<B>[src]</B> tries to flip, but stumbles!", "<B>[src]</B> collapses under their own weight!")
								src.weakened += 2
								src.TakeDamage("head", 4, 0, 0, DAMAGE_BLUNT)
							else
								message = "<B>[src]</B> does a flip!"
							if (!src.reagents.has_reagent("fliptonium"))
								if (prob(50))
									animate_spin(src, "R", 1, 0)
								else
									animate_spin(src, "L", 1, 0)
							for (var/obj/table/T in oview(1, null))
								if ((!istype(usr.equipped(), /obj/item/grab)) && (src.dir == get_dir(src, T)))
									if (iswrestler(src))
										T.density = 0
										if (LinkBlockedWithAccess(src.loc, T.loc))
											T.density = 1
											continue
										T.density = 1
										var/turf/newloc = T.loc
										src.set_loc(newloc)
										message = "<B>[src]</B> flips onto [T]!"
							for (var/mob/living/M in view(1, null))
								var/obj/item/grab/G = usr.equipped()
								if (M == src)
									continue
								if (istype(usr.equipped(), /obj/item/grab))
									if (G.state >= 1)
										var/turf/newloc = src.loc
										G.affecting.set_loc(newloc)
										if (!G.affecting.reagents.has_reagent("fliptonium"))
											if (prob(50))
												animate_spin(G.affecting, "R", 1, 0)
											else
												animate_spin(G.affecting, "R", 1, 0)

										if (!iswrestler(src) && src.traitHolder && !src.traitHolder.hasTrait("glasscannon"))
											src.remove_stamina(STAMINA_FLIP_COST)
											src.stamina_stun()

										src.emote("scream")
										message = "<span style=\"color:red\"><B>[src]</B> suplexes [G.affecting]!</span>"
										logTheThing("combat", src, G.affecting, "suplexes %target%")
										M.lastattacker = src
										M.lastattackertime = world.time
										if (iswrestler(src))
											if (prob(50))
												M.ex_act(3) // this is hilariously overpowered, but WHATEVER!!!
											else
												G.affecting.stunned += 4
												G.affecting.weakened += 4
												G.affecting.TakeDamage("head", 10, 0, 0, DAMAGE_BLUNT)
											playsound(src.loc, "sound/effects/fleshbr1.ogg", 75, 1)
/*										if (src.bioHolder.HasEffect("hulk"))
											playsound(src.loc, "sound/effects/splat.ogg", 75, 1)
											G.affecting.gib()
*/
										else
											if (!iswrestler(src))
												src.weakened += 3
												if (client && client.hellbanned)
													src.weakened += 4
											G.affecting.weakened += 4
											G.affecting.TakeDamage("head", 10, 0, 0, DAMAGE_BLUNT)
											playsound(src.loc, "sound/effects/fleshbr1.ogg", 75, 1)
									if (G.state < 1)
										var/turf/oldloc = src.loc
										var/turf/newloc = G.affecting.loc
										src.set_loc(newloc)
										G.affecting.set_loc(oldloc)
										message = "<B>[src]</B> flips over [G.affecting]!"
								else if (src.reagents && src.reagents.get_reagent_amount("ethanol") > 10)
									if (!iswrestler(src) && src.traitHolder && !src.traitHolder.hasTrait("glasscannon"))
										src.remove_stamina(STAMINA_FLIP_COST)
										src.stamina_stun()

									message = "<span style=\"color:red\"><B>[src]</B> flips into [M]!</span>"
									logTheThing("combat", src, M, "flips into %target%")
									src.weakened += 4
									src.TakeDamage("head", 4, 0, 0, DAMAGE_BLUNT)
									M.weakened += 2
									M.TakeDamage("head", 2, 0, 0, DAMAGE_BLUNT)
									playsound(src.loc, pick(sounds_punch), 100, 1)
									var/turf/newloc = M.loc
									src.set_loc(newloc)
								else
									message = "<B>[src]</B> flips in [M]'s general direction."
								break
					if (src.lying)
						message = "<B>[src]</B> flops on the floor like a fish."

			if ("scream")
				if (src.emote_check(voluntary, 50))
					if (!muzzled)
						message = "<B>[src]</B> screams!"
						m_type = 2
						if (narrator_mode)
							playsound(src.loc, 'sound/vox/scream.ogg', 80, 0, 0, src.get_age_pitch())
						else if (src.sound_list_scream && src.sound_list_scream.len)
							playsound(src.loc, pick(src.sound_list_scream), 80, 0, 0, src.get_age_pitch())
						else
							if (src.gender == MALE)
								playsound(get_turf(src), src.sound_malescream, 80, 0, 0, src.get_age_pitch())
							else
								playsound(get_turf(src), src.sound_femalescream, 80, 0, 0, src.get_age_pitch())
						spawn(5)
							var/possumMax = 15
							for (var/obj/critter/opossum/responsePossum in range(4, src))
								if (!responsePossum.alive)
									continue
								if (possumMax-- < 0)
									break
								responsePossum.CritterDeath() // startled into playing dead!
					else
						message = "<B>[src]</B> makes a very loud noise."
						m_type = 2

			if ("burp")
				if (src.emote_check(voluntary))
					if ((src.charges >= 1) && (!muzzled))
						for (var/mob/O in viewers(src, null))
							O.show_message("<B>[src]</B> burps.")
						for (var/mob/M in oview(1))
							var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
							s.set_up(3, 1, src)
							s.start()
							boutput(M, "<span style=\"color:blue\">BZZZZZZZZZZZT!</span>")
							M.TakeDamage("chest", 0, 20, 0, DAMAGE_BURN)
							src.charges -= 1
							if (narrator_mode)
								playsound(src.loc, "sound/vox/bloop.ogg", 100, 0, 0, src.get_age_pitch())
							else
								playsound(get_turf(src), src.sound_burp, 100, 0, 0, src.get_age_pitch())
							return
					else if ((src.charges >= 1) && (muzzled))
						for (var/mob/O in viewers(src, null))
							O.show_message("<B>[src]</B> vomits in \his own mouth a bit.")
						src.TakeDamage("head", 0, 50, 0, DAMAGE_BURN)
						src.charges -=1
						return
					else if ((src.charges < 1) && (!muzzled))
						message = "<B>[src]</B> burps."
						m_type = 2
						if (narrator_mode)
							playsound(src.loc, "sound/vox/bloop.ogg", 100, 0, 0, src.get_age_pitch())
						else
							playsound(get_turf(src), src.sound_burp, 100, 0, 0, src.get_age_pitch())
					else
						message = "<B>[src]</B> vomits in \his own mouth a bit."
						m_type = 2

			if ("fart")
				if (src.emote_check(voluntary) && farting_allowed && (!src.reagents || !src.reagents.has_reagent("anti_fart")))
					if (src.organHolder && !src.organHolder.butt)
						m_type = 1
						message = "<B>[src]</B> grunts for a moment. Nothing happens."
					else
						m_type = 2
						var/fart_on_other = 0
						for (var/mob/living/M in src.loc)
							if (M == src || !M.lying)
								continue
							message = "<span style=\"color:red\"><B>[src]</B> farts in [M]'s face!</span>"
							if (sims)
								sims.affectMotive("fun", 4)
							fart_on_other = 1
							break
						for (var/obj/item/storage/bible/B in src.loc)
							B.suicide(src)
							fart_on_other = 1
							break
						for (var/obj/item/book_kinginyellow/K in src.loc)
							K.suicide(src)
							fart_on_other = 1
							break
						if (!fart_on_other)
							switch(rand(1, 42))
								if (1) message = "<B>[src]</B> lets out a girly little 'toot' from \his butt."
								if (2) message = "<B>[src]</B> farts loudly!"
								if (3) message = "<B>[src]</B> lets one rip!"
								if (4) message = "<B>[src]</B> farts! It sounds wet and smells like rotten eggs."
								if (5) message = "<B>[src]</B> farts robustly!"
								if (6) message = "<B>[src]</B> farted! It smells like something died."
								if (7) message = "<B>[src]</B> farts like a muppet!"
								if (8) message = "<B>[src]</B> defiles the station's air supply."
								if (9) message = "<B>[src]</B> farts a ten second long fart."
								if (10) message = "<B>[src]</B> groans and moans, farting like the world depended on it."
								if (11) message = "<B>[src]</B> breaks wind!"
								if (12) message = "<B>[src]</B> expels intestinal gas through the anus."
								if (13) message = "<B>[src]</B> release an audible discharge of intestinal gas."
								if (14) message = "<B>[src]</B> is a farting motherfucker!!!"
								if (15) message = "<B>[src]</B> suffers from flatulence!"
								if (16) message = "<B>[src]</B> releases flatus."
								if (17) message = "<B>[src]</B> releases methane."
								if (18) message = "<B>[src]</B> farts up a storm."
								if (19) message = "<B>[src]</B> farts. It smells like Soylent Surprise!"
								if (20) message = "<B>[src]</B> farts. It smells like pizza!"
								if (21) message = "<B>[src]</B> farts. It smells like George Melons' perfume!"
								if (22) message = "<B>[src]</B> farts. It smells like the kitchen!"
								if (23) message = "<B>[src]</B> farts. It smells like medbay in here now!"
								if (24) message = "<B>[src]</B> farts. It smells like the bridge in here now!"
								if (25) message = "<B>[src]</B> farts like a pubby!"
								if (26) message = "<B>[src]</B> farts like a goone!"
								if (27) message = "<B>[src]</B> sharts! That's just nasty."
								if (28) message = "<B>[src]</B> farts delicately."
								if (29) message = "<B>[src]</B> farts timidly."
								if (30) message = "<B>[src]</B> farts very, very quietly. The stench is OVERPOWERING."
								if (31) message = "<B>[src]</B> farts egregiously."
								if (32) message = "<B>[src]</B> farts voraciously."
								if (33) message = "<B>[src]</B> farts cantankerously."
								if (34) message = "<B>[src]</B> fart in \he own mouth. A shameful [src]."
								if (35) message = "<B>[src]</B> farts out pure plasma! <span style=\"color:red\"><B>FUCK!</B></span>"
								if (36) message = "<B>[src]</B> farts out pure oxygen. What the fuck did \he eat?"
								if (37) message = "<B>[src]</B> breaks wind noisily!"
								if (38) message = "<B>[src]</B> releases gas with the power of the gods! The very station trembles!!"
								if (39) message = "<B>[src] <span style=\"color:red\">f</span><span style=\"color:blue\">a</span>r<span style=\"color:red\">t</span><span style=\"color:blue\">s</span>!</B>"
								if (40) message = "<B>[src]</B> laughs! \His breath smells like a fart."
								if (41) message = "<B>[src]</B> farts. You can faintly hear a harmonica..."
								if (42) message = "<b>[src]</B> farts. It might have been the Citizen Kane of farts."
						if (src.bioHolder && src.bioHolder.HasEffect("toxic_farts"))
							message = "<span style=\"color:red\"><B>[src] [pick("unleashes","rips","blasts")] \a [pick("truly","utterly","devastatingly","shockingly")] [pick("hideous","horrendous","horrific","heinous","horrible")] fart!</B></span>"
							spawn(0)
								new /obj/effects/fart_cloud(get_turf(src),src)
						if (iscluwne(src))
							playsound(src.loc, 'sound/misc/Poo.ogg', 50, 1)
						else if (src.organHolder && src.organHolder.butt && istype(src.organHolder.butt, /obj/item/clothing/head/butt/cyberbutt))
							playsound(src.loc, 'sound/misc/poo2_robot.ogg', 100, 1, 0, src.get_age_pitch())
						else
							if (narrator_mode)
								playsound(src.loc, 'sound/vox/fart.ogg', 100, 0, 0, src.get_age_pitch())
							else
								playsound(get_turf(src), src.sound_fart, 100, 0, 0, src.get_age_pitch())

						for(var/mob/living/carbon/human/M in viewers(src, null))
							if(!M.stat && M.get_brain_damage() >= 60)
								spawn(10)
									if(prob(20))
										switch(pick(1,2,3))
											if(1)
												M.say("[M == src ? "i" : src.name] made a fart!!")
											if(2)
												M.emote("giggle")
											if(3)
												M.emote("clap")

						src.remove_stamina(STAMINA_DEFAULT_FART_COST)
						src.stamina_stun()
		#ifdef DATALOGGER
						game_stats.Increment("farts")
		#endif

			if ("pee", "piss", "urinate")
				if (src.emote_check(voluntary))
					if (sims)
						var/bladder = sims.getValue("bladder")
						var/obj/item/storage/toilet/toilet = locate() in src.loc
						if (bladder > 75)
							boutput(src, "<span style=\"color:blue\">You don't need to go right now.</span>")
							return
						else if (bladder > 50)
							if (!toilet)
								if (wear_suit || w_uniform)
									boutput(src, "<span style=\"color:red\">You don't feel desperate enough to piss into your [w_uniform ? "uniform" : "suit"].</span>")
								else
									boutput(src, "<span style=\"color:red\">You don't feel desperate enough to piss on the floor.</span>")
								return
							else
								if (wear_suit || w_uniform)
									message = "<B>[src]</B> unzips their pants and pees in the toilet."
								else
									message = "<B>[src]</B> pees in the toilet."
								toilet.clogged += 0.10
								sims.affectMotive("bladder", 100)
								sims.affectMotive("hygiene", -5)
						else if (bladder > 25)
							if ((wear_suit || w_uniform) && !toilet)
								boutput(src, "<span style=\"color:red\">You don't feel desperate enough to piss into your [w_uniform ? "uniform" : "suit"].</span>")
								return
							else if (toilet)
								if (wear_suit || w_uniform)
									message = "<B>[src]</B> unzips their pants and pees in the toilet."
								else
									message = "<B>[src]</B> pees in the toilet."
								toilet.clogged += 0.10
								sims.affectMotive("bladder", 100)
								sims.affectMotive("hygiene", -5)
							else
								message = "<B>[src]</B> pisses all over the floor!"
								src.urinate()
								sims.affectMotive("bladder", 100)
								sims.affectMotive("hygiene", -50)
						else
							if (toilet)
								if (wear_suit || w_uniform)
									message = "<B>[src]</B> unzips their pants and pees in the toilet."
								else
									message = "<B>[src]</B> pees in the toilet."
								toilet.clogged += 0.10
								sims.affectMotive("bladder", 100)
								sims.affectMotive("hygiene", -5)
							else
								if (wear_suit || w_uniform)
									message = "<B>[src]</B> pisses all over themselves!"
									sims.affectMotive("bladder", 100)
									sims.affectMotive("hygiene", -100)
									if (w_uniform)
										w_uniform.name = "piss-soaked [initial(w_uniform.name)]"
									else
										wear_suit.name = "piss-soaked [initial(wear_suit.name)]"
								else
									message = "<B>[src]</B> pisses all over the floor!"
									src.urinate()
									sims.affectMotive("bladder", 100)
									sims.affectMotive("hygiene", -50)
					else if (src.urine < 1)
						message = "<B>[src]</B> pees themselves a little bit."
					else if ((locate(/obj/item/storage/toilet) in src.loc) && (src.buckled != null) && (src.urine >= 2))
						for (var/obj/item/storage/toilet/T in src.loc)
							message = pick("<B>[src]</B> unzips their pants and pees in the toilet.", "<B>[src]</B> empties their bladder.", "<span style=\"color:blue\">Ahhh, sweet relief.</span>")
							src.urine = 0
							T.clogged += 0.10
							break
					else
						message = pick("<B>[src]</B> unzips their pants and pees on the floor.", "<B>[src]</B> pisses all over the floor!", "<B>[src]</B> makes a big piss puddle on the floor.")
						src.urine--
						src.urinate()
					for(var/mob/living/carbon/human/M in viewers(src, null))
						if(!M.stat && M.get_brain_damage() >= 60)
							spawn(10)
								if(prob(20))
									switch(pick(1,2,3))
										if(1) M.say("[M == src ? "i" : src.name] made pee pee, heeheeheeeeeeee!")
										if(2) M.emote("giggle")
										if(3) M.emote("clap")

			if ("poo", "poop", "shit", "crap")
				if (src.emote_check(voluntary))
					message = "<B>[src]</B> grunts for a moment. [prob(1) ? "Something" : "Nothing"] happens."

			if ("monologue")
				m_type = 2
				if (src.mind && src.mind.assigned_role == "Detective")
					if (istype(src.l_hand, /obj/item/grab))
						if (istype(src.l_hand:affecting, /mob/living/carbon/human))
							message = "<B>[src]</B> says, \"I'll stare the bastard in the face as he screams to God, and I'll laugh harder when he whimpers like a baby. And when [src.l_hand:affecting]'s eyes go dead, the hell I send him to will seem like heaven after what I've done to him.\""
					else if (istype(src.r_hand, /obj/item/grab))
						if (istype(src.r_hand:affecting, /mob/living/carbon/human))
							message = "<B>[src]</B> says, \"I'll stare the bastard in the face as he screams to God, and I'll laugh harder when he whimpers like a baby. And when [src.r_hand:affecting]'s eyes go dead, the hell I send him to will seem like heaven after what I've done to him.\""
					else if (istype(src.loc.loc, /area/station/security/detectives_office))
						message = "<B>[src]</B> says, \"As I looked out the door of my office, I realised it was a night when you didn't know your friends but strangers looked familiar. A night like this, the smartest thing to do is nothing: stay home. It was like the wind carried people along with it. But I had to get out there.\""
					else if (istype(src.loc.loc, /area/station/maintenance))
						message = "<B>[src]</B> says, \"The dark maintenance corridoors of this place were always the same, home to the most shady characters you could ever imagine. Walk down the right back alley in [station_name()], and you can find anything.\""
					else if (istype(src.loc.loc, /area/station/hydroponics))
						message = "<B>[src]</b> says, \"A gang of space farmers growing psilocybin mushrooms, cannabis, and of course those goddamned george melons. A shady bunch, whose wiles had earned them the trust of many. The Chef. The Barman. But not me. No, their charms don't work on a man of values and principles.\""
					else if (istype(src.loc.loc, /area/station/mailroom))
						message = "<B>[src]</b> says, \"The post office, an unused room habited by a brainless monkey, a cynical postman, and now, me. I've never trusted postal workers, with their crisp blue suits and their peaked caps. There's never any mail sent, excepting the ticking packages I gotta defuse up in the bridge.\""
					else if (istype(src.loc.loc, /area/centcom))
						message = "<B>[src]</B> says, \"Central Command. I was tired as hell but I could afford to be tired now... I needed it to be morning. I wanted to hear doors opening, cars start, and human voices talking about the Space Olympics. I wanted to make sure there were still folks out there facing life with nothing up their sleeves but their arms. They didn't know it yet, but they had a better shot at happiness and a fair shake than they did yesterday.\""
					else if (istype(src.loc.loc, /area/station/chapel))
						message = "<B>[src]</B> says, \"The self-pontificating bastard who calls himself our chaplain conducts worship here. If you can call the summoning of an angry god who pelts us with toolboxes, bolts of lightning, and occasionally rips our bodies in twain 'worship'.\""
					else if (istype(src.loc.loc, /area/station/bridge))
						message = "<B>[src]</B> says, \"The bridge. The home of the Captain and Head of Personnel. I tried to tell myself I was the sturdy leg in our little triangle. I was worried it was true.\""
					else if (istype(src.loc.loc, /area/station/security/main))
						message = "<B>[src]</B> says, \"I had dreams of being security before I got into the detective game. I wanted to meet stimulating and interesting people of an ancient space culture, and kill them. I wanted to be the first kid on my ship to get a confirmed kill.\""
					else if (istype(src.loc.loc, /area/station/crew_quarters/bar))
						message = "<B>[src]</B> says, \"The station bar, full of the best examples of lowlifes and drunks I'll ever find. I need a drink though, and there are no better places to find a beer than here.\""
					else if (istype(src.loc.loc, /area/station/medical))
						message = "<B>[src]</B> says, \"Medical. In truth it's full of the biggest bunch of cut throats on the station, most would rather cut you up than sow you up, but if I've got a slug in my ass, I don't have much choice.\""
					else if (istype(src.loc.loc, /area/station/hallway/primary/))
						message = "<B>[src]</B> says, \"The halls of the station assault my nostrils like a week old meal left festering in the sink. A thug around every corner, and reason enough themselves to keep my gun in my hand.\""
					else if (istype(src.loc.loc, /area/station/hallway/secondary/exit))
						message = "<B>[src]</B> says, \"The only way off this hellhole and it's the one place I don't want to be, but sometimes you have to show your friends that you're worth a damn. Sometimes that means dying, sometimes it means killing a whole lot of people to escape alive.\""
					else if (istype(src.loc.loc, /area/station/hallway/secondary/entry))
						message = "<B>[src]</B> says, \"The entrance to [station_name()]. You will never find a more wretched hive of scum and villainy. I must be cautious.\""
					else if (istype(src.loc.loc, /area/station/engine/))
						message = "<B>[src]</B> says, \"The churning, hellish heart of the station that just can't help missing the beat. Full of the dregs of society, and not the right place to be caught unwanted. I better watch my back.\""
					else if (istype(src.loc.loc, /area/station/maintenance/disposal))
						message = "<B>[src]</B> says, \"Disposal. Usually bloodied, full of grey-suited corpses and broken windows. Down here, you can hear the quiet moaning of the station itself. It's like it's mourning. Mourning better days long gone, like assistants through these pipes.\""
					else if (istype(src.loc.loc, /area/station/crew_quarters/cafeteria))
						message = "<B>[src]</B> says, \"A place to eat, but not an appealing one. I've heard rumours about this place, and if there's one thing I know, it's that it's not normal to eat people.\""
					else if (istype(src.wear_mask, /obj/item/clothing/mask/cigarette))
						message = "<B>[src]</B> takes a drag on \his cigarette, surveying the scene around them carefullly."
					else
						message = "<B>[src]</B> looks uneasy, like [src.gender == MALE ? "" : "s"]he's missing a vital part of h[src.gender == MALE ? "im" : "er"]self. [src.gender == MALE ? "H" : "Sh"]e needs a smoke badly."

				else
					message = "<B>[src]</B> tries to say something clever, but just can't pull it off looking like that."

			if ("miranda")
				if (src.emote_check(voluntary, 50))
					if (src.mind && (src.mind.assigned_role in list("Captain", "Head of Personnel", "Head of Security", "Security Officer", "Detective", "Vice Officer", "Regional Director", "Inspector")))
						src.recite_miranda()
			else
				src.show_text("Unusable emote '[act]'. 'Me help' for a list.", "blue")
				return

	showmessage
	if (message)
		logTheThing("say", src, null, "EMOTE: [message]")
		if (m_type & 1)
			for (var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
		else if (!isturf(src.loc))
			var/atom/A = src.loc
			for (var/mob/O in A.contents)
				O.show_message(message, m_type)

/mob/living/carbon/human/get_desc()

	if (src.bioHolder && src.bioHolder.HasEffect("examine_stopper"))
		return "<br><span style=\"color:red\">You can't seem to make yourself look at [src.name] long enough to observe anything!</span>"

	if (src.simple_examine || isghostdrone(usr))
		return

	. = ""
	if (usr.stat == 0)
		. += "<br><span style=\"color:blue\">You look closely at <B>[src.name]</B>.</span>"
		var/distance = get_dist(usr, src)
		sleep(distance + 1)
	if (!istype(usr, /mob/dead/target_observer))
		if (get_dist(usr, src) > 7 && (!usr.client || !usr.client.holder || usr.client.holder.state != 2))
			return "[.]<br><span style=\"color:red\"><B>[src.name]</B> is too far away to see clearly.</span>"


	. +=  "<br><span style=\"color:blue\">*---------*</span>"
	//. +=  "<br><span style=\"color:blue\">This is <B>[src.name]</B>!</span>"

	// crappy hack because you can't do \his[src] etc
	var/t_his = his_or_her(src)
	var/t_him = him_or_her(src)
/*	if (src.gender == MALE)
		t_his = "his"
		t_him = "him"
	else if (src.gender == FEMALE)
		t_his = "her"
		t_him = "her"
*/
	var/datum/ailment_data/found = src.find_ailment_by_type(/datum/ailment/disability/memetic_madness)
	if (found)
		if (!ishuman(usr))
			. += "<br><span style=\"color:red\">You can't focus on [t_him], it's like looking through smoked glass.</span>"
			return
		else
			var/mob/living/carbon/human/H = usr
			var/datum/ailment_data/memetic_madness/MM = H.find_ailment_by_type(/datum/ailment/disability/memetic_madness)
			if (istype(MM) && istype(MM.master,/datum/ailment/disability/memetic_madness))
				H.contract_memetic_madness(MM.progenitor)
				return

			. += "<br><span style=\"color:blue\">A servant of His Grace...</span>"

	if (src.w_uniform)
		if (src.w_uniform.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] is wearing a[src.w_uniform.blood_DNA ? " bloody " : " "][bicon(src.w_uniform)] [src.w_uniform.name]!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] is wearing a [bicon(src.w_uniform)] [src.w_uniform.name].</span>"

	if (src.handcuffed)
		. +=  "<br><span style=\"color:blue\">[src.name] is [bicon(src.handcuffed)] handcuffed!</span>"

	if (src.wear_suit)
		if (src.wear_suit.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has a[src.wear_suit.blood_DNA ? " bloody " : " "][bicon(src.wear_suit)] [src.wear_suit.name] on!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.wear_suit)] [src.wear_suit.name] on.</span>"

	if (src.ears)
		. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.ears)] [src.ears.name] by [t_his] mouth.</span>"

	if (src.head)
		if (src.head.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has a[src.head.blood_DNA ? " bloody " : " "][bicon(src.head)] [src.head.name] on [t_his] head!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.head)] [src.head.name] on [t_his] head.</span>"

	if (src.wear_mask)
		if (src.wear_mask.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has a[src.wear_mask.blood_DNA ? " bloody " : " "][bicon(src.wear_mask)] [src.wear_mask.name] on [t_his] face!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.wear_mask)] [src.wear_mask.name] on [t_his] face.</span>"

	if (src.glasses)
		if (((src.wear_mask && src.wear_mask.see_face) || !src.wear_mask) && ((src.head && src.head.see_face) || !src.head))
			if (src.glasses.blood_DNA)
				. += "<br><span style=\"color:red\">[src.name] has a[src.glasses.blood_DNA ? " bloody " : " "][bicon(src.wear_mask)] [src.glasses.name] on [t_his] face!</span>"
			else
				. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.glasses)] [src.glasses.name] on [t_his] face.</span>"

	if (src.l_hand)
		if (src.l_hand.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has a[src.l_hand.blood_DNA ? " bloody " : " "][bicon(src.l_hand)] [src.l_hand.name] in [t_his] left hand!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.l_hand)] [src.l_hand.name] in [t_his] left hand.</span>"

	if (src.r_hand)
		if (src.r_hand.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has a[src.r_hand.blood_DNA ? " bloody " : " "][bicon(src.r_hand)] [src.r_hand.name] in [t_his] right hand!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.r_hand)] [src.r_hand.name] in [t_his] right hand.</span>"

	if (src.belt)
		if (src.belt.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has a[src.belt.blood_DNA ? " bloody " : " "][bicon(src.belt)] [src.belt.name] on [t_his] belt!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.belt)] [src.belt.name] on [t_his] belt.</span>"

	if (src.gloves)
		if (src.gloves.blood_DNA)
			. += "<br><span style=\"color:red\">[src.name] has bloody [bicon(src.gloves)] [src.gloves.name] on [t_his] hands!</span>"
		else
			. += "<br><span style=\"color:blue\">[src.name] has [bicon(src.gloves)] [src.gloves.name] on [t_his] hands.</span>"
	else if (src.blood_DNA)
		. += "<br><span style=\"color:red\">[src.name] has[src.blood_DNA ? " bloody " : " "]hands!</span>"

	if (src.back)
		. += "<br><span style=\"color:blue\">[src.name] has a [bicon(src.back)] [src.back.name] on [t_his] back.</span>"

	if (src.wear_id)
		if (istype(src.wear_id, /obj/item/card/id))
			if (src.wear_id:registered != src.real_name && in_range(src, usr) && prob(10))
				. += "<br><span style=\"color:red\">[src.name] is wearing [bicon(src.wear_id)] [src.wear_id.name] yet doesn't seem to be that person!!!</span>"
			else
				. += "<br><span style=\"color:blue\">[src.name] is wearing [bicon(src.wear_id)] [src.wear_id.name].</span>"
		else if (istype(src.wear_id, /obj/item/device/pda2) && src.wear_id:ID_card)
			if (src.wear_id:ID_card:registered != src.real_name && in_range(src, usr) && prob(10))
				. += "<br><span style=\"color:red\">[src.name] is wearing [bicon(src.wear_id)] [src.wear_id.name] with [bicon(src.wear_id:ID_card)] [src.wear_id:ID_card:name] in it yet doesn't seem to be that person!!!</span>"
			else
				. += "<br><span style=\"color:blue\">[src.name] is wearing [bicon(src.wear_id)] [src.wear_id.name] with [bicon(src.wear_id:ID_card)] [src.wear_id:ID_card:name] in it.</span>"

	if (src.is_jittery)
		switch(src.jitteriness)
			if (300 to INFINITY)
				. += "<br><span style=\"color:red\">[src] is violently convulsing.</span>"
			if (200 to 300)
				. += "<br><span style=\"color:red\">[src] looks extremely jittery.</span>"
			if (100 to 200)
				. += "<br><span style=\"color:red\">[src] is twitching ever so slightly.</span>"
	if (src.organHolder)
		var/datum/organHolder/oH = src.organHolder
		if (oH.brain)
			if (oH.brain.op_stage > 0.0)
				. += "<br><span style=\"color:red\"><B>[src.name] has an open incision on [t_his] head!</B></span>"
		else if (!oH.brain && oH.skull && oH.head)
			. += "<br><span style=\"color:red\"><B>[src.name]'s head has been cut open and [t_his] brain is gone!</B></span>"
		else if (!oH.skull && oH.head)
			. += "<br><span style=\"color:red\"><B>[src.name] no longer has a skull in [t_his] head, [t_his] face is just empty skin mush!</B></span>"
		else if (!oH.head)
			. += "<br><span style=\"color:red\"><B>[src.name] has been decapitated!</B></span>"

		if (oH.head)
			if (((src.wear_mask && src.wear_mask.see_face) || !src.wear_mask) && ((src.head && src.head.see_face) || !src.head))
				if (!oH.right_eye)
					. += "<br><span style=\"color:red\"><B>[src.name]'s right eye is missing!</B></span>"
				if (!oH.left_eye)
					. += "<br><span style=\"color:red\"><B>[src.name]'s left eye is missing!</B></span>"

		if (src.organHolder.heart)
			if (src.organHolder.heart.op_stage > 0.0)
				. += "<br><span style=\"color:red\"><B>[src.name] has an open incision on [t_his] chest!</B></span>"
		else
			. += "<br><span style=\"color:red\"><B>[src.name]'s chest is cut wide open; [t_his] heart has been removed!</B></span>"

		if (src.butt_op_stage > 0)
			if (src.butt_op_stage >= 4)
				. += "<br><span style=\"color:red\"><B>[src.name]'s butt seems to be missing!</B></span>"
			else
				. += "<br><span style=\"color:red\"><B>[src.name] has an open incision on [t_his] butt!</B></span>"

		if (src.limbs)
			if (!src.limbs.l_arm)
				. += "<br><span style=\"color:red\"><B>[src.name]'s left arm is completely severed!</B></span>"
			else if (istype(src.limbs.l_arm, /obj/item/parts/human_parts/arm/left/item))
				if (src.limbs.l_arm:remove_object)
					. += "<br><span style=\"color:blue\">[src.name] has [src.limbs.l_arm.remove_object] attached as a left arm!</span>"
			if (!src.limbs.r_arm)
				. += "<br><span style=\"color:red\"><B>[src.name]'s right arm is completely severed!</B></span>"
			else if (istype(src.limbs.r_arm, /obj/item/parts/human_parts/arm/right/item))
				if (src.limbs.r_arm:remove_object)
					. += "<br><span style=\"color:blue\">[src.name] has [src.limbs.r_arm.remove_object] attached as a right arm!</span>"
			if (!src.limbs.l_leg)
				. += "<br><span style=\"color:red\"><B>[src.name]'s left leg is completely severed!</B></span>"
			if (!src.limbs.r_leg)
				. += "<br><span style=\"color:red\"><B>[src.name]'s right leg is completely severed!</B></span>"

	if (src.bleeding && src.stat != 2)
		switch (src.bleeding)
			if (1 to 2)
				. += "<br><span style=\"color:red\">[src.name] is bleeding a little bit.</span>"
			if (3 to 5)
				. += "<br><span style=\"color:red\"><B>[src.name] is bleeding!</B></span>"
			if (6 to 8)
				. += "<br><span style=\"color:red\"><B>[src.name] is bleeding a lot!</B></span>"
			if (9 to INFINITY)
				. += "<br><span style=\"color:red\"><B>[src.name] is bleeding very badly!</B></span>"

	if (!isvampire(src) && (src.blood_volume < 500)) // Added a check for vampires (Convair880).
		switch (src.blood_volume)
			if (-INFINITY to 100)
				. += "<br><span style=\"color:red\"><B>[src.name] is extremely pale!</B></span>"
			if (101 to 300)
				. += "<br><span style=\"color:red\"><B>[src.name] is pale!</B></span>"
			if (301 to 400)
				. += "<br><span style=\"color:red\">[src.name] is a little pale.</span>"

	var/changeling_fakedeath = 0
	var/datum/abilityHolder/changeling/C = get_ability_holder(/datum/abilityHolder/changeling)
	if (C && C.in_fakedeath)
		changeling_fakedeath = 1

	if ((src.stat == 2 /*&& !src.reagents.has_reagent("montaguone") && !src.reagents.has_reagent("montaguone_extra")*/) || changeling_fakedeath || (src.reagents.has_reagent("capulettium") && src.paralysis) || (src.reagents.has_reagent("capulettium_plus") && src.weakened))
		if (!src.decomp_stage)
			. += "<br><span style=\"color:red\">[src] is limp and unresponsive, a dull lifeless look in [t_his] eyes.</span>"
	else
		var/brute = src.get_brute_damage()
		if (brute)
			if (brute < 30)
				. += "<br><span style=\"color:red\">[src.name] looks slightly injured!</span>"
			else
				. += "<br><span style=\"color:red\"><B>[src.name] looks severely injured!</B></span>"

		var/burn = src.get_burn_damage()
		if (burn)
			if (burn < 30)
				. += "<br><span style=\"color:red\">[src.name] looks slightly burned!</span>"
			else
				. += "<br><span style=\"color:red\"><B>[src.name] looks severely burned!</B></span>"

		if (src.stat > 0)// && src.reagents.has_reagent("montaguone")))
			. += "<br><span style=\"color:red\">[src.name] doesn't seem to be responding to anything around [t_him], [t_his] eyes closed as though asleep.</span>"
		else
			if (src.get_brain_damage() >= 60)
				. += "<br><span style=\"color:red\">[src.name] has a stupid expression on [his_or_her(src)] face.</span>"

			if (!src.client)
				. += "<br>[src.name] seems to be staring blankly into space."

	switch (src.decomp_stage)
		if (1)
			. += "<br><span style=\"color:red\">[src] looks bloated and smells a bit rotten!</span>"
		if (2)
			. += "<br><span style=\"color:red\">[src]'s flesh is starting to rot away from [t_his] bones!</span>"
		if (3)
			. += "<br><span style=\"color:red\">[src]'s flesh is almost completely rotten away, revealing parts of [t_his] skeleton!</span>"
		if (4)
			. += "<br><span style=\"color:red\">[src]'s remains are completely skeletonized.</span>"

	if(usr.traitHolder && (usr.traitHolder.hasTrait("observant") || istype(usr, /mob/dead/observer)))
		if(src.traitHolder && src.traitHolder.traits.len)
			. += "<br><span style=\"color:blue\">[src] has the following traits:</span>"
			for(var/X in src.traitHolder.traits)
				var/obj/trait/T = getTraitById(X)
				. += "<br><span style=\"color:blue\">[T.cleanName]</span>"
		else
			. += "<br><span style=\"color:blue\">[src] does not appear to possess any special traits.</span>"

	if (src.juggling())
		var/items = ""
		var/count = 0
		for (var/obj/O in src.juggling)
			count ++
			if (src.juggling.len > 1 && count == src.juggling.len)
				items += " and [O]"
				continue
			items += ", [O]"
		items = copytext(items, 3)
		. += "<br><span style=\"color:blue\">[src] is juggling [items]!</span>"

	. += "<br><span style=\"color:blue\">*---------*</span>"

	if (get_dist(usr, src) < 4 && ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if (istype(H.glasses, /obj/item/clothing/glasses/healthgoggles))
			var/obj/item/clothing/glasses/healthgoggles/G = H.glasses
			if (G.scan_upgrade && G.health_scan)
				. += "<br><span style='color: red'>Your ProDocs analyze [src]'s vitals.</span><br>[scan_health(src, 0, 0)]"
			update_medical_record(src)

/mob/living/carbon/human/movement_delay()
	var/tally = 0

	if (src.slowed)
		tally += 10
	if (src.reagents && src.reagents.has_reagent("methamphetamine"))
		if (!src.bioHolder || !src.bioHolder.HasEffect("revenant"))
			return -1
	if (src.nodamage)
		return -1

	var/health_deficiency = (src.max_health - src.health) // cogwerks // let's treat this like pain
	if (src.reagents)
		if (src.reagents.has_reagent("morphine"))
			health_deficiency -= 50
		if (src.reagents.has_reagent("salicylic_acid"))
			health_deficiency -= 25
	if (health_deficiency >= 30) tally += (health_deficiency / 25)

	if (src.wear_suit)
		switch(src.wear_suit.type)
			if (/obj/item/clothing/suit/straight_jacket)
				tally += 15
			if (/obj/item/clothing/suit/fire)	//	firesuits slow you down a bit
				tally += 1.3
			if (/obj/item/clothing/suit/fire/heavy)	//	firesuits slow you down a bit
				tally += 1.7
			if (/obj/item/clothing/suit/space)
				if (!istype(src.loc, /turf/space))		//	space suits slow you down a bit unless in space;
					tally += 0.7
			if (/obj/item/clothing/suit/space/captain)
				tally -=0.1
			if (/obj/item/clothing/suit/armor/heavy)
				tally += 3.5
			if (/obj/item/clothing/suit/armor/EOD)
				tally += 2
			if (/obj/item/clothing/suit/armor/ancient) // cogwerks - new evil armor thing
				tally += 2
			if (/obj/item/clothing/suit/space/emerg)
				if (!istype(src.loc, /turf/space))
					tally += 3.0 // cogwerks - lowered this from 10
			if (/obj/item/clothing/suit/space/suv)
				tally += 1.0

	var/missing_legs = 0
	if (src.limbs && !src.limbs.l_leg) missing_legs++
	if (src.limbs && !src.limbs.r_leg) missing_legs++
	switch(missing_legs)
		if (0)
			if (istype(src.shoes, /obj/item/clothing/shoes))
				if (src.shoes.chained)
					tally += 15
				else if (istype(src.shoes.type,/obj/item/clothing/shoes/industrial)) // miner boots, split off from the suit
					tally -= 4.0
				else
					tally -= 1.0
			else
				if (shoes)
					tally -= 1.0
		if (1)
			tally += 7
			if (istype(src.shoes, /obj/item/clothing/shoes))
				if (istype(src.shoes.type,/obj/item/clothing/shoes/industrial)) // miner boots, split off from the suit
					tally -= 2.0 //less effect if there's only one i guess
				else
					tally -= 0.5
		if (2)
			tally += 15
			var/missing_arms = 0
			if (src.limbs && !src.limbs.l_arm) missing_arms++
			if (src.limbs && !src.limbs.r_arm) missing_arms++
			switch(missing_arms)
				if (1)
					tally += 15 //can't pull yourself along too well
				if (2)
					tally += 300 //haha good luck

	if (src.mutantrace)
		tally += src.mutantrace.movement_delay()
	if (src.bioHolder)
		if (src.bioHolder.HasEffect("fat"))
			tally += 1.5
		if (src.bodytemperature < src.base_body_temp - (src.temp_tolerance * 2) && !src.is_cold_resistant())
			tally += min( ((((src.base_body_temp - (src.temp_tolerance * 2)) - src.bodytemperature) / 10) * 1.75), 10)


		if (src.limbs && istype(src.limbs.l_leg, /obj/item/parts/robot_parts/leg/left/treads) && istype(src.limbs.r_leg, /obj/item/parts/robot_parts/leg/right/treads)) //Treads speed you up a bunch
			tally -= 0.5

		else if (src.limbs && istype(src.limbs.l_leg, /obj/item/parts/robot_parts/leg) && istype(src.limbs.r_leg, /obj/item/parts/robot_parts/leg)) //robot legs speed you up a little
			tally -= 0.4



	for (var/obj/item/I in get_equipped_items())
		tally += I.movement_speed_mod

	if (src.reagents)
		if (src.reagents.has_reagent("energydrink"))
			if (tally > 6)
				tally /= 2
			else
				tally -= 3

	if (src.bioHolder && src.bioHolder.HasEffect("revenant"))
		tally = max(tally, 3)

	return tally

/mob/living/carbon/human/Stat()
	..()
	statpanel("Status")
	if (src.client.statpanel == "Status")
		if (src.client)
			stat("Time Until Payday:", wagesystem.get_banking_timeleft())

		stat(null, " ")
		if (src.mind)
			if (src.mind.objectives && istype(src.mind.objectives, /list))
				for (var/datum/objective/O in src.mind.objectives)
					if (istype(O, /datum/objective/specialist/stealth))
						stat("Stealth Points:", "[O:score] / [O:min_score]")

		if (src.internal)
			if (!src.internal.air_contents)
				qdel(src.internal)
			else
				stat("Internal Atmosphere Info:", src.internal.name)
				stat("Tank Pressure:", src.internal.air_contents.return_pressure())
				stat("Distribution Pressure:", src.internal.distribute_pressure)

/mob/living/carbon/human/u_equip(obj/item/W as obj)
	if (!W)
		return

	hud.remove_item(W) // eh
	if (W == src.wear_suit)
		src.wear_suit = null
		W.unequipped(src)
		src.update_clothing()
		src.update_hair_layer()
	else if (W == src.w_uniform)
		W.unequipped(src)
		W = src.r_store
		if (W)
			u_equip(W)
			if (W)
				W.set_loc(src.loc)
				W.dropped(src)
				W.layer = initial(W.layer)
		W = src.l_store
		if (W)
			u_equip(W)
			if (W)
				W.set_loc(src.loc)
				W.dropped(src)
				W.layer = initial(W.layer)
		W = src.wear_id
		if (W)
			u_equip(W)
			if (W)
				W.set_loc(src.loc)
				W.dropped(src)
				W.layer = initial(W.layer)
		W = src.belt
		if (W)
			u_equip(W)
			if (W)
				W.set_loc(src.loc)
				W.dropped(src)
				W.layer = initial(W.layer)
		src.w_uniform = null
		src.update_clothing()
	else if (W == src.gloves)
		W.unequipped(src)
		src.gloves = null
		src.update_clothing()
	else if (W == src.glasses)
		W.unequipped(src)
		src.glasses = null
		src.update_clothing()
	else if (W == src.head)
		W.unequipped(src)
		src.head = null
		src.update_clothing()
		src.update_hair_layer()
	else if (W == src.ears)
		W.unequipped(src)
		src.ears = null
		src.update_clothing()
	else if (W == src.shoes)
		W.unequipped(src)
		src.shoes = null
		src.update_clothing()
	else if (W == src.belt)
		W.unequipped(src)
		src.belt = null
		src.update_clothing()
	else if (W == src.wear_mask)
		W.unequipped(src)
		if (internal)
			if (src.internals)
				src.internals.icon_state = "internal0"
			for (var/obj/ability_button/tank_valve_toggle/T in internal.ability_buttons)
				T.icon_state = "airoff"
			internal = null
		src.wear_mask = null
		src.update_clothing()
	else if (W == src.wear_id)
		W.unequipped(src)
		src.wear_id = null
		src.update_clothing()
	else if (W == src.r_store)
		src.r_store = null
	else if (W == src.l_store)
		src.l_store = null
	else if (W == src.back)
		W.unequipped(src)
		src.back = null
		src.update_clothing()
	else if (W == src.handcuffed)
		src.handcuffed = null
		src.update_clothing()
	else if (W == src.r_hand)
		src.r_hand = null
		W.dropped(src)
		src.update_inhands()
	else if (W == src.l_hand)
		src.l_hand = null
		W.dropped(src)
		src.update_inhands()

/mob/living/carbon/human/action(num)
	if(src.abilityHolder)
		if(!src.abilityHolder.actionKey(num)) //If none of the keys were used as ability hotkeys, use it for intents instead.
			switch (num)
				if (1)
					src.a_intent = INTENT_HELP
					hud.update_intent()
				if (2)
					src.a_intent = INTENT_DISARM
					hud.update_intent()
				if (3)
					src.a_intent = INTENT_GRAB
					hud.update_intent()
				if (4)
					src.a_intent = INTENT_HARM
					hud.update_intent()

///mob/living/carbon/human/click(atom/target, params)

///mob/living/carbon/human/Stat()

/mob/living/carbon/human/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/human/proc/throw_mode_off()
	src.in_throw_mode = 0
	src.update_cursor()
	hud.update_throwing()

/mob/living/carbon/human/proc/throw_mode_on()
	src.in_throw_mode = 1
	src.update_cursor()
	hud.update_throwing()

/mob/living/carbon/human/proc/throw_item(atom/target)
	src.throw_mode_off()
	if (usr.stat)
		return

	var/atom/movable/item = src.equipped()

	if (istype(item, /obj/item) && item:cant_self_remove)
		return

	if (!item) return

	if (istype(item, /obj/item/grab))
		var/obj/item/grab/grab = item
		var/mob/M = grab.affecting
		if (istype(M))
			if (grab.state < 1 && !(M.paralysis || M.weakened || M.stat))
				src.visible_message("<span style=\"color:red\">[M] stumbles a little!</span>")
				u_equip(grab)
				return
			M.lastattacker = src
			M.lastattackertime = world.time
			u_equip(grab)
			item = M

	u_equip(item)

	item.set_loc(src.loc)

	// u_equip() already calls item.dropped()
	//if (istype(item, /obj/item))
		//item:dropped(src) // let it know it's been dropped

	//actually throw it!
	if (item)
		item.layer = initial(item.layer)
		src.visible_message("<span style=\"color:red\">[src] throws [item].</span>")
		if (iscarbon(item))
			var/mob/living/carbon/C = item
			logTheThing("combat", src, C, "throws %target% at [log_loc(src)].")
			if ( ishuman(C) )
				C.weakened = max(src.weakened, 1)
		else
			// Added log_reagents() call for drinking glasses. Also the location (Convair880).
			logTheThing("combat", src, null, "throws [item] [item.is_open_container() ? "[log_reagents(item)]" : ""] at [log_loc(src)].")
		if (istype(src.loc, /turf/space)) //they're in space, move em one space in the opposite direction
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)
		if (istype(item.loc, /turf/space) && istype(item, /mob))
			var/mob/M = item
			M.inertia_dir = get_dir(src,target)
		item.throw_at(target, item.throw_range, item.throw_speed)

/mob/living/carbon/human/click(atom/target, list/params)
	if (src.in_throw_mode || params.Find("shift"))
		src.throw_item(target)
		return
	return ..()

/mob/living/carbon/human/update_cursor()
	if ((src.client && src.client.check_key("shift")) || src.in_throw_mode)
		src.set_cursor('icons/cursors/throw.dmi')
		return
	return ..()
/*
/mob/living/carbon/human/key_down(key)
	if (key == "shift")
		update_cursor()
	..()

/mob/living/carbon/human/key_up(key)
	if (key == "shift")
		update_cursor()
	..()
*/
/mob/living/carbon/human/meteorhit(O as obj)
	if (stat == 2) src.gib()
	src.visible_message("<span style=\"color:red\">[src] has been hit by [O]</span>")
	if (src.nodamage) return
	if (src.health > 0)
		var/dam_zone = pick("chest", "head")
		if (istype(src.organs[dam_zone], /obj/item/organ))
			var/obj/item/organ/temp = src.organs[dam_zone]

			var/reduction = 0
			if (src.energy_shield) reduction = src.energy_shield.protect()
			if (src.spellshield)
				reduction = 30
				boutput(src, "<span style=\"color:red\"><b>Your Spell Shield absorbs some damage!</b></span>")

			temp.take_damage((istype(O, /obj/newmeteor/small) ? max(15-reduction,0) : max(25-reduction,0)), max(20-reduction,0))
			src.UpdateDamageIcon()
		src.updatehealth()
	else if (prob(20))
		src.gib()

	return

/mob/living/carbon/human/deliver_move_trigger(ev)
	for (var/obj/O in contents)
		if (O.move_triggered)
			O.move_trigger(src, ev)

/mob/living/carbon/human/Move(a, b, flag)
	if (src.buckled && src.buckled.anchored)
		return

	if (src.traitHolder && prob(5) && src.traitHolder.hasTrait("leftfeet") && !src.handcuffed)
		spawn(10)
			if(src)
				step(src,pick(turn(b, 90),turn(b, -90)))

	if (src.restrained() && src.pulling)
		src.pulling = null
		hud.update_pulling()

	var/t7 = 1
	if (src.restrained())
		for (var/mob/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null

	if (last_move_trigger + 10 <= ticker.round_elapsed_ticks)
		last_move_trigger = ticker.round_elapsed_ticks
		deliver_move_trigger(m_intent)

	if ((t7 && (src.pulling && ((get_dist(src, src.pulling) <= 1 || src.pulling.loc == src.loc) && (src.client && src.client.moving)))))
		var/turf/T = src.loc
		. = ..()

		if (src.pulling && src.pulling.loc)
			if (!( isturf(src.pulling.loc) ))
				src.pulling = null
				hud.update_pulling()
				return
			else
				if (Debug)
					diary <<"src.pulling disappeared? at [__LINE__] in mob.dm - src.pulling = [src.pulling]"
					diary <<"REPORT THIS"

		/////
		if (src.pulling && src.pulling.anchored)
			src.pulling = null
			return

		if (!src.restrained())
			var/diag = get_dir(src, src.pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, src.pulling) > 1 || diag))
				if (ismob(src.pulling))
					var/mob/M = src.pulling
					var/ok = 1
					if (locate(/obj/item/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/grab))
								M.visible_message("<span style=\"color:red\">[G.affecting] has been pulled from [G.assailant]'s grip by [src]</span>")
								//G = null
								qdel(G)
						else
							ok = 0
						if (locate(/obj/item/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/t = M.pulling
						M.pulling = null
						if (emergency_shuttle.location == 1)
							var/shuttle = locate(/area/shuttle/escape/station)
							var/loc = src.pulling.loc
							if ( (M.stat == 2) && ( loc in shuttle ) )
								src.unlock_medal("Leave no man behind!", 1)


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

/mob/living/carbon/human/UpdateName()
	if ((src.wear_mask && !(src.wear_mask.see_face)) || (src.head && !(src.head.see_face))) // can't see the face
		if (istype(src.wear_id) && src.wear_id:registered)
			src.name = "[src.name_prefix(null, 1)][src.wear_id:registered][src.name_suffix(null, 1)]"
		else
			src.unlock_medal("Suspicious Character", 1)
			src.name = "[src.name_prefix(null, 1)]Unknown[src.name_suffix(null, 1)]"
	else
		if (istype(src.wear_id) && src.wear_id:registered != src.real_name)
			if (src.decomp_stage > 2)
				src.name = "[src.name_prefix(null, 1)]Unknown (as [src.wear_id:registered])[src.name_suffix(null, 1)]"
			else
				src.name = "[src.name_prefix(null, 1)][src.real_name] (as [src.wear_id:registered])[src.name_suffix(null, 1)]"
		else
			if (src.decomp_stage > 2)
				src.name = "[src.name_prefix(null, 1)]Unknown[src.wear_id ? " (as [src.wear_id:registered])" : ""][src.name_suffix(null, 1)]"
			else
				src.name = "[src.name_prefix(null, 1)][src.real_name][src.name_suffix(null, 1)]"

/mob/living/carbon/human/find_in_equipment(var/eqtype)
	if (istype(w_uniform, eqtype))
		return w_uniform
	if (istype(wear_id, eqtype))
		return wear_id
	if (istype(gloves, eqtype))
		return gloves
	if (istype(shoes, eqtype))
		return shoes
	if (istype(wear_suit, eqtype))
		return wear_suit
	if (istype(back, eqtype))
		return back
	if (istype(glasses, eqtype))
		return glasses
	if (istype(ears, eqtype))
		return ears
	if (istype(wear_mask, eqtype))
		return wear_mask
	if (istype(head, eqtype))
		return head
	if (istype(belt, eqtype))
		return belt
	if (istype(l_store, eqtype))
		return l_store
	if (istype(r_store, eqtype))
		return r_store
	return null

/mob/living/carbon/human/find_in_hands(var/eqtype)
	if (istype(l_hand, eqtype))
		return l_hand
	if (istype(r_hand, eqtype))
		return r_hand
	return null

/mob/living/carbon/human/is_in_hands(var/obj/O)
	if (l_hand == O || r_hand == O)
		return 1
	return 0


// Marquesas: I'm literally adding an extra parameter here so I don't have to port a metric shitton of code elsewhere.
// These calculations really should be doable via another proc.
/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M as mob)
	if (!M || !src) //Apparently M could be a meatcube and this causes HELLA runtimes.
		return

	if (!ticker)
		boutput(M, "You cannot interact with other people before the game has started.")
		return

	actions.interrupt(src, INTERRUPT_ATTACKED)

	if (!ishuman(M))
		if (hascall(M, "melee_attack_human"))
			call(M, "melee_attack_human")(src)
		return

	M.viral_transmission(src,"Contact",1)

	if (M.gloves && M.gloves.material)
		M.gloves.material.triggerOnAttack(M.gloves, M, src)
		for (var/atom/A in src)
			if (A.material)
				A.material.triggerOnAttacked(A, M, src, M.gloves)

	switch(M.a_intent)
		if (INTENT_HELP)
			var/datum/limb/L = M.equipped_limb()
			if (!L)
				return
			L.help(src, M)

		if (INTENT_DISARM)
			if (M.is_mentally_dominated_by(src))
				boutput(M, "<span style=\"color:red\">You cannot harm your master!</span>")
				return

			var/datum/limb/L = M.equipped_limb()
			if (!L)
				return
			L.disarm(src, M)

		if (INTENT_GRAB)
			if (M == src)
				M.grab_self()
				return
			var/datum/limb/L = M.equipped_limb()
			if (!L)
				return
			L.grab(src, M)
			message_admin_on_attack(M, "grabs")

		if (INTENT_HARM)
			if (M.is_mentally_dominated_by(src))
				boutput(M, "<span style=\"color:red\">You cannot harm your master!</span>")
				return

			M.violate_hippocratic_oath()
			message_admin_on_attack(M, "punches")
			if (src.shrunk == 2)
				M.visible_message("<span style=\"color:red\">[M] squashes [src] like a bug.</span>")
				src.gib()
				return

			if (M.gloves && (M.gloves.can_be_charged && M.gloves.stunready && M.gloves.uses >= 1))
				M.stun_glove_attack(src)
				return

			M.melee_attack(src)

	return

/mob/living/carbon/human/restrained()
	if (src.handcuffed)
		return 1
	if (istype(src.wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	if (src.limbs && (src.hand ? !src.limbs.l_arm : !src.limbs.r_arm))
		return 1
	/*if (src.limbs && (src.hand ? !src.limbs.l_arm:can_hold_items : !src.limbs.r_arm:can_hold_items)) // this was fucking stupid and broke item limbs, I mean really, how do you restrain someone whos arm is a goddamn CHAINSAW
		return 1*/



/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75

/obj/equip_e/human/process()
	if (src.item)
		src.item.add_fingerprint(src.source)
	if (!src.item)
		switch(src.place)
			if ("mask")
				if (!( src.target.wear_mask ) || !src.target.wear_mask.handle_other_remove(src.source, src.target))
					//SN src = null
					qdel(src)
					return
			if ("l_hand")
				if (!( src.target.l_hand ) || !(src.target.l_hand.handle_other_remove(src.source, src.target)))
					//SN src = null
					qdel(src)
					return
				/* TODO - DONE
				else if (istype(src.target.l_hand, /obj/item/staff) && prob(75))
					src.source.show_message(text("<span style=\"color:red\">The [src.target.l_hand] is too slippery to hold on to!</span>"), 1)
					qdel(src)
					return
				*/
			if ("r_hand")
				if (!( src.target.r_hand ) || !(src.target.r_hand.handle_other_remove(src.source, src.target)))
					//SN src = null
					qdel(src)
					return
				/* TODO - DONE
				else if (istype(src.target.r_hand, /obj/item/staff) && prob(75))
					src.source.show_message(text("<span style=\"color:red\">The [src.target.r_hand] is too slippery to hold on to!</span>"), 1)
					qdel(src)
					return
				*/
			if ("suit")
				if (!( src.target.wear_suit ) || !src.target.wear_suit.handle_other_remove(src.source, src.target))
					//SN src = null
					qdel(src)
					return
				/* TODO - DONE
				else if (istype(src.target.wear_suit, /obj/item/clothing/suit/wizrobe) && prob(75))
					src.source.show_message(text("<span style=\"color:red\">The [src.target.wear_suit] writhes in your hands as though it is alive!</span>"), 1)
					qdel(src)
					return
				*/
			if ("uniform")
				if (!( src.target.w_uniform ) || !src.target.w_uniform.handle_other_remove(src.source, src.target))
					//SN src = null
					qdel(src)
					return
			if ("back")
				if (!( src.target.back ) || !src.target.back.handle_other_remove(src.source, src.target))
					//SN src = null
					qdel(src)
					return
			if ("handcuff")
				if (!src.target.handcuffed )
					//SN src = null
					if (!istype(src.source, /mob/living/silicon/robot))
						qdel(src)
					return
			if ("id")
				if ((!( src.target.wear_id ) || !( src.target.w_uniform ) || !( src.target.wear_id.handle_other_remove(src.source, src.target) )))
					//SN src = null
					qdel(src)
					return
			if ("internal")
				if ((!( (istype(src.target.wear_mask, /obj/item/clothing/mask) && istype(src.target.back, /obj/item/tank) && !( src.target.internal )) ) && !( src.target.internal )))
					//SN src = null
					qdel(src)
					return
			if ("gloves")
				if (!( src.target.gloves ) || !src.target.gloves.handle_other_remove(src.source, src.target))
					//SN src = null
					qdel(src)
					return
			if ("shoes")
				if (!( src.target.shoes ) || !src.target.shoes.handle_other_remove(src.source, src.target))
				//SN src = null
					qdel(src)
					return
				/* TODO - DONE
				else if (istype(src.target.shoes, /obj/item/clothing/shoes/sandal) && prob(75))
					src.source.show_message(text("<span style=\"color:red\">The [src.target.shoes] seem to be part of the feet!</span>"), 1)
					qdel(src)
					return
				*/
			if ("head")
				if (!( src.target.head ) || !src.target.head.handle_other_remove(src.source, src.target))
					qdel(src)
					return
				/* TODO - DONE
				else if (istype(src.target.head, /obj/item/clothing/head/wizard) && prob(75))
					src.source.show_message(text("<span style=\"color:red\">The [src.target.shoes] won't come off!</span>"), 1)
					qdel(src)
					return
				*/
				/* TODO - DONE
				else if (istype(src.target.head, /obj/item/clothing/head/butt) && src.target.head:stapled )
					src.source.show_message(text("<span style=\"color:red\"><B>[src.source.name] rips out the staples from \the [src.target.head.name]!</B></span>"), 1)
					src.target.head:unstaple()
					new /obj/decal/cleanable/blood(src.target.loc)
					playsound(src.target.loc, "sound/effects/splat.ogg", 50, 1)
					src.target.emote("scream")
					src.target.TakeDamage("head", rand(8, 16), 0)
				*/
	var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel")
	if (istype(src.target) && istype(src.target.mutantrace, /datum/mutantrace/abomination))
		src.target.visible_message("<span style=\"color:red\"><B>[src.source] is trying to put \a [src.item] on [src.target], and is failing miserably!</B></span>")
		return
	if ((src.item && !( L.Find(src.place) )))
		src.target.visible_message("<span style=\"color:red\"><B>[src.source] is trying to put \a [src.item] on [src.target]</B></span>")
	else
		if (src.place == "syringe")
			src.target.visible_message("<span style=\"color:red\"><B>[src.source] is trying to inject [src.target]!</B></span>")
		else
			if (src.place == "pill")
				src.target.visible_message("<span style=\"color:red\"><B>[src.source] is trying to force [src.target] to swallow [src.item]!</B></span>")
			else
				if (src.place == "fuel")
					src.target.visible_message("<span style=\"color:red\">[src.source] is trying to force [src.target] to eat the [src.item:content]!</span>")
				else
					if (src.place == "drink")
						src.target.visible_message("<span style=\"color:red\"><B>[src.source] is trying to force [src.target] to swallow a gulp of [src.item]!</B></span>")
					else
						if (src.place == "dnainjector")
							src.target.visible_message("<span style=\"color:red\"><B>[src.source] is trying to inject [src.target] with the [src.item]!</B></span>")
						else
							var/message = null
							switch(src.place)
								if ("mask")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off \a [src.target.wear_mask] from [src.target]'s head!</B></span>"
								if ("l_hand")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off \a [src.target.l_hand] from [src.target]'s left hand!</B></span>"
								if ("r_hand")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off \a [src.target.r_hand] from [src.target]'s right hand!</B></span>"
								if ("gloves")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off the [src.target.gloves] from [src.target]'s hands!</B></span>"
								if ("eyes")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off the [src.target.glasses] from [src.target]'s eyes!</B></span>"
								if ("ears")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off the [src.target.ears] from [src.target]'s ears!</B></span>"
								if ("head")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off the [src.target.head] from [src.target]'s head!</B></span>"
								if ("shoes")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off the [src.target.shoes] from [src.target]'s feet!</B></span>"
								if ("belt")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off the [src.target.belt] from [src.target]'s belt!</B></span>"
								if ("suit")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off \a [src.target.wear_suit] from [src.target]'s body!</B></span>"
								if ("back")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off \a [src.target.back] from [src.target]'s back!</B></span>"
								if ("handcuff")
									message = "<span style=\"color:red\"><B>[src.source] is trying to unhandcuff [src.target]!</B></span>"
								if ("uniform")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off \a [src.target.w_uniform] from [src.target]'s body!</B></span>"
								if ("pockets")
									for (var/obj/item/mousetrap/MT in  list(src.target.l_store, src.target.r_store))
										if (MT.armed)
											for (var/mob/O in AIviewers(src.target, null))
												if (O == src.source)
													O.show_message("<span style=\"color:red\"><B>You reach into the [src.target]'s pockets, but there was a live mousetrap in there!</B></span>", 1)
												else
													O.show_message("<span style=\"color:red\"><B>[src.source] reaches into [src.target]'s pockets and sets off a hidden mousetrap!</B></span>", 1)
											src.target.u_equip(MT)
											MT.set_loc(src.source.loc)
											MT.triggered(src.source, src.source.hand ? "l_hand" : "r_hand")
											MT.layer = OBJ_LAYER
											return
									message = "<span style=\"color:red\"><B>[src.source] is trying to empty [src.target]'s pockets!!</B></span>"
								if ("id")
									message = "<span style=\"color:red\"><B>[src.source] is trying to take off [src.target.wear_id] from [src.target]'s uniform!</B></span>"
								if ("internal")
									if (src.target.internal)
										message = "<span style=\"color:red\"><B>[src.source] is trying to remove [src.target]'s internals</B></span>"
									else
										message = "<span style=\"color:red\"><B>[src.source] is trying to set on [src.target]'s internals.</B></span>"
								else
							src.target.visible_message(message)
	if (do_mob(src.source, src.target, 40))
		src.done()
	return

/obj/equip_e/human/done()
	#define equip_e_slot(slot_name) var/obj/item/W = src.target.get_slot(src.target.slot_name); if (W) { if (!W.handle_other_remove(src.source, src.target)) return; src.target.u_equip(W); if (W) { W.set_loc(src.target.loc); W.dropped(src.target); W.layer = initial(W.layer); W.add_fingerprint(src.source) } } else if (src.target.can_equip(src.item, src.target.slot_name)) { src.source.u_equip(src.item); src.target.force_equip(src.item, src.target.slot_name) }
	if (!src.source || !src.target)						return
	if (src.source.loc != src.s_loc)						return
	if (src.target.loc != src.t_loc)						return
	if (LinkBlocked(src.s_loc,src.t_loc))				return
	if (!istype(src.source, /mob/living/silicon/robot))
		if (src.item && src.source.equipped() != src.item)	return
	if ((src.source.restrained() || src.source.stat))	return
	switch(src.place)
		if ("mask")
			equip_e_slot(slot_wear_mask)
		if ("gloves")
			equip_e_slot(slot_gloves)
		if ("eyes")
			equip_e_slot(slot_glasses)
		if ("belt")
			equip_e_slot(slot_belt)
		if ("head")
			equip_e_slot(slot_head)
		if ("ears")
			equip_e_slot(slot_ears)
		if ("shoes")
			equip_e_slot(slot_shoes)
		if ("l_hand")
			equip_e_slot(slot_l_hand)
		if ("r_hand")
			equip_e_slot(slot_r_hand)
		if ("uniform")
			equip_e_slot(slot_w_uniform)
		if ("suit")
			equip_e_slot(slot_wear_suit)
		if ("id")
			equip_e_slot(slot_wear_id)
		if ("back")
			equip_e_slot(slot_back)
		if ("handcuff")
			logTheThing("combat", src.source, src.target, "handcuffs %target%")
			if (src.target.handcuffed)
				var/obj/item/W = src.target.handcuffed
				src.target.u_equip(W)
				actions.stopId("handcuffs", src.target)
				if (istype(W,/obj/item/handcuffs/tape))
					qdel(W)
				if (W)
					W.set_loc(src.target.loc)
					W.dropped(src.target)
					W.layer = initial(W.layer)
					W.add_fingerprint(src.source)
			else if (istype(src.item, /obj/item/handcuffs/tape_roll))
				src.target.drop_from_slot(src.target.r_hand)
				src.target.drop_from_slot(src.target.l_hand)
				src.target.drop_juggle()
				src.item:amount -= 1
				if (src.item:amount <=0)
					src.source.drop_item()
					qdel(src.item)
				var/obj/item/handcuffs/tape/C = new/obj/item/handcuffs/tape()
				src.target.handcuffed = C
				C.set_loc(src.target)
			else if (istype(src.item, /obj/item/handcuffs))
				src.target.drop_from_slot(src.target.r_hand)
				src.target.drop_from_slot(src.target.l_hand)
				src.source.drop_item()
				src.target.drop_juggle()
				src.target.handcuffed = src.item
				src.item.set_loc(src.target)
		if ("pockets")
			if (src.target.l_store)
				var/obj/item/W = src.target.l_store
				src.target.u_equip(W)
				if (W)
					W.set_loc(src.target.loc)
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
			if (src.target.r_store)
				var/obj/item/W = src.target.r_store
				src.target.u_equip(W)
				if (W)
					W.set_loc(src.target.loc)
					W.dropped(src.target)
					W.layer = initial(W.layer)
				W.add_fingerprint(src.source)
		if ("internal")
			logTheThing("combat", src.source, src.target, "switches %target%'s internals")
			if (src.target.internal)
				src.target.internal.add_fingerprint(src.source)
				for (var/obj/ability_button/tank_valve_toggle/T in src.target.internal.ability_buttons)
					T.icon_state = "airoff"
				src.target.internal = null
			else
				if (src.target.internal)
					src.target.internal = null
					for (var/obj/ability_button/tank_valve_toggle/T in src.target.internal.ability_buttons)
						T.icon_state = "airoff"
				if (!( istype(src.target.wear_mask, /obj/item/clothing/mask) ))
					return
				else
					if (istype(src.target.back, /obj/item/tank))
						src.target.internal = src.target.back
						for (var/obj/ability_button/tank_valve_toggle/T in src.target.internal.ability_buttons)
							T.icon_state = "airon"

						for (var/mob/M in AIviewers(src.target, 1))
							M.show_message(text("[] is now running on internals.", src.target), 1)
						src.target.internal.add_fingerprint(src.source)
		else
	if (src.source)
		src.source.set_clothing_icon_dirty()
	if (src.target)
		src.target.set_clothing_icon_dirty()
	//SN src = null
	qdel(src)
	return
	#undef equip_e_slot

// new damage icon system
// now constructs damage icon for each organ from mask * damage field


/mob/living/carbon/human/proc/show_inv(mob/user as mob)
	user.machine = src
	var/dat = {"
	<B><HR><FONT size=3>[src.name]</FONT></B>
	<BR><HR>
	<B>Head:</B> <A href='?src=\ref[src];varname=head;slot=[src.slot_head];item=head'>[(src.head ? src.head : "Nothing")]</A>
	<BR><B>Mask:</B> <A href='?src=\ref[src];varname=wear_mask;slot=[src.slot_wear_mask];item=mask'>[(src.wear_mask ? src.wear_mask : "Nothing")]</A>
	<BR><B>Eyes:</B> <A href='?src=\ref[src];varname=glasses;slot=[src.slot_glasses];item=eyes'>[(src.glasses ? src.glasses : "Nothing")]</A>
	<BR><B>Ears:</B> <A href='?src=\ref[src];varname=ears;slot=[src.slot_ears];item=ears'>[(src.ears ? src.ears : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];varname=l_hand;slot=[src.slot_l_hand];item=l_hand'>[(src.l_hand ? src.l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];varname=r_hand;slot=[src.slot_r_hand];item=r_hand'>[(src.r_hand ? src.r_hand : "Nothing")]</A>
	<BR><B>Gloves:</B> <A href='?src=\ref[src];varname=gloves;slot=[src.slot_gloves];item=gloves'>[(src.gloves ? src.gloves : "Nothing")]</A>
	<BR><B>Shoes:</B> <A href='?src=\ref[src];varname=shoes;slot=[src.slot_shoes];item=shoes'>[(src.shoes ? src.shoes : "Nothing")]</A>
	<BR><B>Belt:</B> <A href='?src=\ref[src];varname=belt;slot=[src.slot_belt];item=belt'>[(src.belt ? src.belt : "Nothing")]</A>
	<BR><B>Uniform:</B> <A href='?src=\ref[src];varname=w_uniform;slot=[src.slot_w_uniform];item=uniform'>[(src.w_uniform ? src.w_uniform : "Nothing")]</A>
	<BR><B>Outer Suit:</B> <A href='?src=\ref[src];varname=wear_suit;slot=[src.slot_wear_suit];item=suit'>[(src.wear_suit ? src.wear_suit : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];varname=back;slot=[src.slot_back];item=back'>[(src.back ? src.back : "Nothing")]</A> [((istype(src.wear_mask, /obj/item/clothing/mask) && istype(src.back, /obj/item/tank) && !( src.internal )) ? text(" <A href='?src=\ref[];item=internal;slot=internal'>Set Internal</A>", src) : "")]
	<BR><B>ID:</B> <A href='?src=\ref[src];varname=wear_id;slot=[src.slot_wear_id];item=id'>[(src.wear_id ? src.wear_id : "Nothing")]</A>
	<BR><B>Left Pocket:</B> <A href='?src=\ref[src];varname=l_store;slot=[src.slot_l_store];item=pockets'>[(src.l_store ? "Something" : "Nothing")]</A>
	<BR><B>Right Pocket:</B> <A href='?src=\ref[src];varname=r_store;slot=[src.slot_r_store];item=pockets'>[(src.r_store ? "Something" : "Nothing")]</A>
	<BR>[(src.handcuffed ? text("<A href='?src=\ref[src];slot=handcuff;item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff;slot=handcuff'>Not Handcuffed</A>"))]
	<BR>[(src.internal ? text("<A href='?src=\ref[src];slot=internal;item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?action=mach_close&window=mob[src.name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[src.name];size=340x480"))
	onclose(user, "mob[src.name]")
	return
	//	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>

/mob/living/carbon/human/MouseDrop(mob/M as mob)
	..()
	if (M != usr) return
	if (usr == src) return
	if (get_dist(usr,src) > 1) return
	if (!M.can_strip()) return
	if (LinkBlocked(usr.loc,src.loc)) return
	src.show_inv(usr)

/mob/living/carbon/human/verb/fuck()
	set hidden = 1
	alert("Go play HellMOO if you wanna do that.")

// called when something steps onto a human
// this could be made more general, but for now just handle mulebot
/mob/living/carbon/human/HasEntered(var/atom/movable/AM)
	var/obj/machinery/bot/mulebot/MB = AM
	if (istype(MB))
		MB.RunOver(src)

/mob/living/carbon/human/Topic(href, href_list)
	if (istype(usr.loc,/obj/dummy/spell_invis/) || istype(usr, /mob/living/silicon/ghostdrone))
		return
	if (!usr.stat && usr.canmove && !usr.restrained() && in_range(src, usr) && ticker && usr.can_strip())
		if (href_list["slot"] == "handcuff")
			actions.start(new/datum/action/bar/icon/handcuffRemovalOther(src), usr)
		else if (href_list["slot"] == "internal")
			actions.start(new/datum/action/bar/icon/internalsOther(src), usr)
		else if (href_list["item"])
			actions.start(new/datum/action/bar/icon/otherItem(usr, src, usr.equipped(), text2num(href_list["slot"])) , usr)

	return //HURP DURP OLD CODE PATH BELOW

/*	if (href_list["item"] && !usr.stat && usr.canmove && !usr.restrained() && in_range(src, usr) && ticker)
		var/obj/equip_e/human/O = new /obj/equip_e/human(  )
		O.source = usr
		O.target = src
		O.item = usr.equipped()
		O.s_loc = usr.loc
		O.t_loc = src.loc
		O.place = href_list["item"]
		spawn( 0 )
			O.process()
			return
	..()
	return*/

/mob/living/carbon/human/get_valid_target_zones()
	var/list/ret = list()
	for (var/organName in src.organs)
		if (istype(src.organs[organName], /obj/item))
			ret += organName
	return ret

/proc/random_brute_damage(var/mob/themob, var/damage, var/disallow_limb_loss) // do brute damage to a random organ
	if (!themob || !ismob(themob))
		return //???
	var/list/zones = themob.get_valid_target_zones()
	if (!zones || !zones.len)
		themob.TakeDamage("All", damage, 0, 0, DAMAGE_BLUNT)
	else
		if (prob(100 / zones.len + 1))
			themob.TakeDamage("All", damage, 0, 0, DAMAGE_BLUNT)
		else
			themob.TakeDamage(pick(zones), damage, 0, 0, DAMAGE_BLUNT)

/proc/random_burn_damage(var/mob/themob, var/damage) // do burn damage to a random organ
	if (!themob || !ismob(themob))
		return //???
	var/list/zones = themob.get_valid_target_zones()
	if (!zones || !zones.len)
		themob.TakeDamage("All", 0, damage, 0, DAMAGE_BURN)
	else
		if (prob(100 / zones.len + 1))
			themob.TakeDamage("All", 0, damage, 0, DAMAGE_BURN)
		else
			themob.TakeDamage(pick(zones), 0, damage, 0, DAMAGE_BURN)

/* ----------------------------------------------------------------------------------------------------------------- */

/mob/living/carbon/human
	var/life_context = "begin"

/mob/living/carbon/human/Life(datum/controller/process/mobs/parent)
	set invisibility = 0
	if (..(parent))
		return 1

	if (src.transforming)
		return

	if (!bioHolder)
		bioHolder = new/datum/bioHolder(src)

	parent.setLastTask("update_item_abilities", src)
	update_item_abilities()

	parent.setLastTask("update_item_abilities", src)
	update_objectives()

	// Jewel's attempted fix for: null.return_air()
	// These objects should be garbage collected the next tick, so it's not too bad if it's not breathing I think? I might be totallly wrong here.
	if (loc)
		var/datum/gas_mixture/environment = loc.return_air()

		if (src.stat != 2) //still breathing

			parent.setLastTask("handle_material_triggers", src)
			for (var/obj/item/I in src)
				if (!I.material) continue
				I.material.triggerOnLife(src, I)

			//Chemicals in the body
			parent.setLastTask("handle_chemicals_in_body", src)
			handle_chemicals_in_body()

			//Mutations and radiation
			parent.setLastTask("handle_mutations_and_radiation", src)
			handle_mutations_and_radiation()

			//special (read: stupid) manual breathing stuff. weird numbers are so that messages don't pop up at the same time as manual blinking ones every time
			if (manualbreathing)
				breathtimer++
				switch(breathtimer)
					if (34)
						boutput(src, "<span style=\"color:red\">You need to breathe!</span>")
					if (35 to 51)
						if (prob(5)) emote("gasp")
					if (52)
						boutput(src, "<span style=\"color:red\">Your lungs start to hurt. You really need to breathe!</span>")
					if (53 to 61)
						hud.update_oxy_indicator(1)
						take_oxygen_deprivation(breathtimer/12)
					if (62)
						hud.update_oxy_indicator(1)
						boutput(src, "<span style=\"color:red\">Your lungs are burning and the need to take a breath is almost unbearable!</span>")
						take_oxygen_deprivation(10)
					if (63 to INFINITY)
						hud.update_oxy_indicator(1)
						take_oxygen_deprivation(breathtimer/6)

			//First, resolve location and get a breath

			if (air_master.current_cycle%2==1 && breathtimer < 15)
				//Only try to take a breath every 4 seconds, unless suffocating
				parent.setLastTask("breathe", src)
				spawn(0) breathe()

			else //Still give containing object the chance to interact
				if (istype(loc, /obj/))
					parent.setLastTask("handle_internal_lifeform", src)
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)

		else if (src.stat == 2)
			parent.setLastTask("handle_decomposition", src)
			handle_decomposition()

		//Apparently, the person who wrote this code designed it so that
		//blinded get reset each cycle and then get activated later in the
		//code. Very ugly. I dont care. Moving this stuff here so its easy
		//to find it.
		src.blinded = null

		parent.setLastTask("handle_mutantrace_life", src)
		if (src.mutantrace) src.mutantrace.onLife()
		//Disease Check
		parent.setLastTask("handle_virus_updates", src)
		handle_virus_updates()

		//Handle temperature/pressure differences between body and environment
		parent.setLastTask("handle_environment", src)
		handle_environment(environment)

		//stuff in the stomach
		parent.setLastTask("handle_stomach", src)
		handle_stomach()

		//Disabilities
		parent.setLastTask("handle_disabilities", src)
		handle_disabilities()

	handle_burning()
	//Status updates, death etc.
	clamp_values()
	parent.setLastTask("handle_regular_status_updates", src)
	handle_regular_status_updates(parent)

	parent.setLastTask("handle_stuns_lying", src)
	handle_stuns_lying(parent)

	if (src.stat != 2) // Marq was here, breaking everything.
		parent.setLastTask("handle_blood", src)
		handle_blood()

		parent.setLastTask("handle_organs", src)
		handle_organs()

		parent.setLastTask("sims", src)
		if (src.sims)
			sims.Life()

		if (prob(1) && prob(5))
			parent.setLastTask("handle_random_emotes", src)
			handle_random_emotes()

	parent.setLastTask("handle pathogens", src)
	handle_pathogens()

	if (client)
		parent.setLastTask("handle_regular_hud_updates", src)
		handle_regular_hud_updates()
		parent.setLastTask("handle_regular_sight_updates", src)
		handle_regular_sight_updates()

	//Being buckled to a chair or bed
	parent.setLastTask("check_if_buckled", src)
	check_if_buckled()

	// Yup.
	parent.setLastTask("update_canmove", src)
	update_canmove()

	clamp_values()

	if (health_mon)
		var/health_prc = (health / max_health) * 100
		if (src.bioHolder.HasEffect("dead_scan"))
			health_mon.icon_state = "-1"
		else
			switch(health_prc)
				if (98 to 100) //100
					health_mon.icon_state = "100"
				if (81 to 97) //80
					health_mon.icon_state = "80"
				if (75 to 80) //75
					health_mon.icon_state = "75"
				if (50 to 74) //50
					health_mon.icon_state = "50"
				if (25 to 49) //25
					health_mon.icon_state = "25"
				if (1 to 24) //10
					health_mon.icon_state = "10"
				if (-1000 to 0) //0
					if (stat == 1 || stat == 0)
						health_mon.icon_state = "0"
					else if (stat == 2)
						health_mon.icon_state = "-1"

	//Regular Trait updates
	if(src.traitHolder)
		for(var/T in src.traitHolder.traits)
			var/obj/trait/O = getTraitById(T)
			O.onLife(src)

	// Icons
	parent.setLastTask("update_icons", src)
	update_icons_if_needed()

	if (src.client) //ov1
		// overlays
		parent.setLastTask("update_screen_overlays", src)
		src.updateOverlaysClient(src.client)
		src.antagonist_overlay_refresh(0, 0)

	if (src.observers.len)
		for (var/mob/x in src.observers)
			if (x.client)
				src.updateOverlaysClient(x.client)

	// Grabbing
	for (var/obj/item/grab/G in src)
		parent.setLastTask("obj/item/grab.process() for [G]")
		G.process()

	if (!can_act(M=src,include_cuffs=0)) actions.interrupt(src, INTERRUPT_STUNNED)

/mob/living/carbon/human
	proc/clamp_values()

		stunned = max(min(stunned, 15),0)
		paralysis = max(min(paralysis, 20), 0)
		weakened = max(min(weakened, 15), 0)
		slowed = max(min(slowed, 15), 0)
		sleeping = max(min(sleeping, 20), 0)
		stuttering = max(stuttering, 0)
		losebreath = max(min(losebreath,25),0) // stop going up into the thousands, goddamn
		burning = max(min(burning, 100),0)
//		bleeding = max(min(bleeding, 10),0)
//		blood_volume = max(blood_volume, 0)

	proc/handle_burning()
		if (src.burning)
			var/damage = 0
			//Normal equip gives you around ~212. Spacesuits ~362. Firesuits ~863.
			var/damage_reduction = (round(add_fire_protection(0) / 100) - 2) //normal equip = 0, spacesuits = 1, firesuits = 6
			if (src.burning <= 33)
				damage = max(3-damage_reduction,0.75)
			else if (src.burning > 33 && src.burning <= 66)
				damage = max(4-damage_reduction,1.50)
			else if (src.burning > 66)
				damage = max(5-damage_reduction,2.00)

			if (isturf(src.loc))
				var/turf/location = src.loc
				location.hotspot_expose(T0C + 100 + src.burning * 3, 400)

			for (var/atom/A in src.contents)
				if (A.material)
					A.material.triggerTemp(A, T0C + 100 + src.burning * 3)

			if (!src.is_heat_resistant())
				src.TakeDamage("chest", 0, damage, 0, DAMAGE_BURN)

			if(src.traitHolder && src.traitHolder.hasTrait("burning"))
				if(prob(50)) src.update_burning(-1)
			else
				src.update_burning(-1)

	proc/handle_decomposition()
		var/turf/T = get_turf_loc(src)
		if (!T) return
		if (src.stat != 2 || src.mutantrace || src.reagents.has_reagent("formaldehyde"))
			return

		var/env_temp = 0
		if (istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			return
		if (istype(loc, /obj/morgue))
			return
		// cogwerks note: both the cryo cell and morgue things technically work, but the corpse rots instantly when removed
		// if it has been in there longer than the next decomp time that was initiated before the corpses went in. fuck!
		// will work out a fix for that soon, too tired right now
		else
			var/datum/gas_mixture/environment = T.return_air()
			env_temp = environment.temperature
		src.next_decomp_time -= min(30, max(round((env_temp - T20C)/10), -60))
		if (world.time > src.next_decomp_time) // advances every 4-10 game minutes
			src.decomp_stage = min(src.decomp_stage + 1, 4)
			src.update_body()
			src.update_face()
			src.next_decomp_time = world.time + rand(240,600)*10

	proc/stink()
		if (prob(15))
			for (var/mob/living/carbon/C in view(6,get_turf(src)))
				if (C == src || !C.client)
					continue
				boutput(C, "<span style=\"color:red\">[stinkString()]</span>")
				if (prob(30))
					new/obj/decal/cleanable/vomit(C.loc)
					C.stunned += 2
					boutput(C, "<span style=\"color:red\">[stinkString()]</span>")

	proc/handle_disabilities()

		// moved drowsy, confusion and such from handle_chemicals because it seems better here
		if (src.drowsyness)
			src.drowsyness--
			src.change_eye_blurry(2)
			if (prob(5))
				src.sleeping = 1
				src.paralysis = 5

		if (misstep_chance > 0)
			switch(misstep_chance)
				if (50 to INFINITY)
					change_misstep_chance(-2)
				else
					change_misstep_chance(-1)

		// The value at which this stuff is capped at can be found in mob.dm
		if (resting)
			dizziness = max(0, dizziness - 5)
			jitteriness = max(0, jitteriness - 5)
		else
			dizziness = max(0, dizziness - 2)
			jitteriness = max(0, jitteriness - 2)

		if (!isnull(src.mind) && isvampire(src))
			if (istype(get_area(src), /area/station/chapel) && src.check_vampire_power(3) != 1)
				if (prob(33))
					boutput(src, "<span style=\"color:red\">The holy ground burns you!</span>")
				src.TakeDamage("chest", 0, 10, 0, DAMAGE_BURN)
			if (src.loc && istype(src.loc, /turf/space))
				if (prob(33))
					boutput(src, "<span style=\"color:red\">The starlight burns you!</span>")
				src.TakeDamage("chest", 0, 2, 0, DAMAGE_BURN)

		if (src.loc && isarea(src.loc.loc))
			if (src.loc.loc:irradiated)
				if (src.wear_suit && src.wear_suit:radproof)
					if (istype(wear_suit, /obj/item/clothing/suit/rad) && prob(33))
						boutput(src, "<span style=\"color:red\">Your geiger counter ticks...</span>")
					return
				else
					src.irradiate(src.loc.loc:irradiated * 10)
					return

		//GENETIC INSTABILITY FUN STUFF
		if (src.is_changeling())
			return

		var/genetic_stability = 100
		if (src.bioHolder)
			genetic_stability = src.bioHolder.genetic_stability

		if (src.reagents && src.reagents.has_reagent("mutadone"))
			genetic_stability = 100

		if (src.traitHolder && src.traitHolder.hasTrait("robustgenetics"))
			genetic_stability += 20

		if (genetic_stability < 51)
			if (prob(1) && genetic_stability < 16) //Oh no!
				src.visible_message("<span style=\"color:red\"><b>[src.name] bubbles and degenerates into a pile of living slop!</b></span>")
				src.transforming = 1
				src.invisibility = 101

				var/bdna = null // For forensics (Convair880).
				var/btype = null
				if (src.bioHolder.Uid && src.bioHolder.bloodType)
					bdna = src.bioHolder.Uid
					btype = src.bioHolder.bloodType
				gibs(get_turf(src), null, null, bdna, btype)

				var/obj/critter/blobman/sucker = new (get_turf(src))
				sucker.name = src.real_name
				sucker.desc = "Science really HAS gone too far this time!"
				if (prob(30))
					sucker.atkcarbon = 0
					sucker.atksilicon = 0

				src.ghostize()
				qdel(src)
				return
				//src.make_meatcube(60)

			if (prob(5) && genetic_stability < 31)
				boutput(src, "<span style=\"color:red\">Some of your skin bubbles right off. Eugh!</span>")
				src.TakeDamage("chest", 10, 0, 0, DAMAGE_BURN)
			if (prob(5) && genetic_stability < 31)
				boutput(src, "<span style=\"color:red\">Some of your skin melts off. Gross!</span>")
				bleed(src, rand(8,14), 5)
			if (prob(2) && genetic_stability < 31)
				boutput(src, "<span style=\"color:red\">You feel grody as hell!</span>")
				src.take_toxin_damage(5)

		//	if (prob(2))                 //maybe let's not bake in something that makes people go blind if they're fat
		//		boutput(src, "<span style=\"color:red\">Your flesh bubbles and writhes!</span>")
		//		src.bioHolder.RandomEffect("bad",1)
			if (prob(5))
				src.take_toxin_damage(1)
			if (prob(5))
				src.take_brain_damage(1)

	proc/update_objectives()
		if (!src.mind)
			return
		if (!src.mind.objectives)
			return
		if (!istype(src.mind.objectives, /list))
			return
		for (var/datum/objective/O in src.mind.objectives)
			spawn(0)
				if (istype(O, /datum/objective/specialist/stealth))
					var/turf/T = get_turf_loc(src)
					if (T && isturf(T) && (istype(T, /turf/space) || T.loc.name == "Space" || T.z != 1))
						O:score = max(0, O:score - 1)
						if (prob(20))
							boutput(src, "<span style=\"color:red\"><B>Being away from the station is making you lose your composure...</B></span>")
						src << sound('sound/effects/env_damage.ogg')
						continue
					if (T && isturf(T) && T.RL_GetBrightness() < 0.2)
						O:score++
					else
						var/spotted_by_mob = 0
						for (var/mob/living/M in oviewers(src, 5))
							if (M.client && M.sight_check(1))
								O:score = max(0, O:score - 5)
								spotted_by_mob = 1
								break
						if (!spotted_by_mob)
							O:score++


	proc/handle_pathogens()
		if (src.stat == 2)
			if (src.pathogens.len)
				for (var/uid in src.pathogens)
					if (prob(5))
						src.cured(src.pathogens[uid])
			return
		for (var/uid in src.pathogens)
			var/datum/pathogen/P = src.pathogens[uid]
			P.disease_act()

	proc/handle_mutations_and_radiation()
		if (src.radiation)
			switch(src.radiation)
				if (1 to 49)
					src.irradiate(-1)
					if (prob(25))
						src.take_toxin_damage(1)
						src.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
						src.updatehealth()

				if (50 to 74)
					src.irradiate(-2)
					src.take_toxin_damage(1)
					src.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
					if (prob(5))
						src.radiation -= 5
						if (src.bioHolder && !src.bioHolder.HasEffect("revenant"))
							src.weakened = 3
							boutput(src, "<span style=\"color:red\">You feel weak.</span>")
							emote("collapse")
					src.updatehealth()

				if (75 to 100)
					src.irradiate(-2)
					src.take_toxin_damage(2)
					src.TakeDamage("chest", 0, 2, 0, DAMAGE_BURN)
					var/mutChance = 2
					if (src.traitHolder && src.traitHolder.hasTrait("stablegenes"))
						mutChance = 1
					if (prob(mutChance) && (src.bioHolder && !src.bioHolder.HasEffect("revenant")))
						boutput(src, "<span style=\"color:red\">You mutate!</span>")
						src:bioHolder:RandomEffect("bad")
					src.updatehealth()

				if (101 to 150)
					src.irradiate(-3)
					src.take_toxin_damage(2)
					src.TakeDamage("chest", 0, 3, 0, DAMAGE_BURN)
					var/mutChance = 4
					if (src.traitHolder && src.traitHolder.hasTrait("stablegenes"))
						mutChance = 2
					if (prob(mutChance) && (src.bioHolder && !src.bioHolder.HasEffect("revenant")))
						boutput(src, "<span style=\"color:red\">You mutate!</span>")
						src:bioHolder:RandomEffect("bad")
					src.updatehealth()

				if (151 to INFINITY)
					// only goes up to 200 but we might as well catch exceptions just in case
					src.irradiate(-3)
					src.take_toxin_damage(2)
					src.TakeDamage("chest", 0, 3, 0, DAMAGE_BURN)
					var/mutChance = 6
					if (src.traitHolder && src.traitHolder.hasTrait("stablegenes"))
						mutChance = 3
					if (src.bioHolder && !src.bioHolder.HasEffect("revenant"))
						src.drowsyness = max(src.drowsyness, 5)
						if (prob(mutChance))
							boutput(src, "<span style=\"color:red\">You mutate!</span>")
							src:bioHolder:RandomEffect("bad")
					src.updatehealth()

		if (bioHolder) bioHolder.OnLife()

		if (src.bomberman == 1)
			spawn(10)
				new /obj/bomberman(get_turf(src))

	proc/breathe()
		if (!loc)
			return
		if (src.reagents)
			if (src.reagents.has_reagent("lexorin")) return
		if (istype(loc, /mob/living/object)) return // no breathing inside possessed objects
		if (istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return
		//if (istype(loc, /obj/machinery/clonepod)) return
		if (src.bioHolder && src.bioHolder.HasEffect("breathless")) return

		// Changelings generally can't take OXY/LOSEBREATH damage...except when they do.
		// And because they're excluded from the breathing procs, said damage didn't heal
		// on its own, making them essentially mute and perpetually gasping for air.
		// Didn't seem like a feature to me (Convair880).
		if (src.is_changeling())
			if (src.losebreath)
				src.losebreath = 0
			if (src.get_oxygen_deprivation())
				src.take_oxygen_deprivation(-50)
			return

		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/air_group/breath
		// HACK NEED CHANGING LATER
		//if (src.oxymax == 0 || (breathtimer > 15))
		if (breathtimer > 15)
			src.losebreath++

		if (losebreath>0) //Suffocating so do not take a breath
			src.losebreath--
			if (prob(75)) //High chance of gasping for air
				spawn emote("gasp")
			if (istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)
		else
			//First, check for air from internal atmosphere (using an air tank and mask generally)
			breath = get_breath_from_internal(BREATH_VOLUME)

			//No breath from internal atmosphere so get breath from location
			if (!breath)
				if (istype(loc, /obj/))
					var/obj/location_as_object = loc
					breath = location_as_object.handle_internal_lifeform(src, BREATH_VOLUME)
				else if (istype(loc, /turf/))
					var/breath_moles = environment.total_moles()*BREATH_PERCENTAGE

					breath = loc.remove_air(breath_moles)

			else //Still give containing object the chance to interact
				if (istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)

		handle_breath(breath)

		if (breath)
			loc.assume_air(breath)


	proc/get_breath_from_internal(volume_needed)
		if (internal)
			if (!contents.Find(src.internal))
				internal = null
			if (!wear_mask || !(wear_mask.c_flags & MASKINTERNALS) )
				internal = null
			if (internal)
				if (src.internals)
					src.internals.icon_state = "internal1"
				for (var/obj/ability_button/tank_valve_toggle/T in internal.ability_buttons)
					T.icon_state = "airon"
				return internal.remove_air_volume(volume_needed)
			else
				if (src.internals)
					src.internals.icon_state = "internal0"
		return null

	proc/update_canmove()
		if (paralysis || stunned || weakened)
			canmove = 0
			return

		var/datum/abilityHolder/changeling/C = get_ability_holder(/datum/abilityHolder/changeling)
		if (C && C.in_fakedeath)
			canmove = 0
			return

		if (buckled && buckled.anchored)
			canmove = 0
			return

		canmove = 1

	proc/handle_breath(datum/gas_mixture/breath)
		if (src.nodamage) return

		// Looks like we're in space
		// or with recent atmos changes, in a room that's had a hole in it for any amount of time, so now we check src.loc
		if (!breath || (breath.total_moles() == 0))
			if (istype(src.loc, /turf/space))
				take_oxygen_deprivation(10)
			else
				take_oxygen_deprivation(5)
			hud.update_oxy_indicator(1)

			return 0

		if (src.health < 0) //We aren't breathing.
			return 0

		var/safe_oxygen_min = 17 // Minimum safe partial pressure of O2, in kPa
		//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
		var/safe_co2_max = 9 // Yes it's an arbitrary value who cares?
		var/safe_toxins_max = 0.4
		var/SA_para_min = 1
		var/SA_sleep_min = 5
		var/oxygen_used = 0
		var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

		//Partial pressure of the O2 in our breath
		var/O2_pp = (breath.oxygen/breath.total_moles())*breath_pressure
		// Same, but for the toxins
		var/Toxins_pp = (breath.toxins/breath.total_moles())*breath_pressure
		// And CO2, lets say a PP of more than 10 will be bad (It's a little less really, but eh, being passed out all round aint no fun)
		var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*breath_pressure

		if (O2_pp < safe_oxygen_min) 			// Too little oxygen
			if (prob(20))
				spawn(0) emote("gasp")
			if (O2_pp > 0)
				var/ratio = round(safe_oxygen_min/(O2_pp + 0.1))
				take_oxygen_deprivation(min(5*ratio, 5)) // Don't fuck them up too fast (space only does 7 after all!)
				oxygen_used = breath.oxygen*ratio/6
			else
				take_oxygen_deprivation(5)
			hud.update_oxy_indicator(1)
		else 									// We're in safe limits
			take_oxygen_deprivation(-5)
			oxygen_used = breath.oxygen/6
			hud.update_oxy_indicator(0)

		breath.oxygen -= oxygen_used
		breath.carbon_dioxide += oxygen_used

		if (CO2_pp > safe_co2_max)
			if (!co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
				co2overloadtime = world.time
			else if (world.time - co2overloadtime > 120)
				src.paralysis = max(src.paralysis, 3)
				take_oxygen_deprivation(5) // Lets hurt em a little, let them know we mean business
				if (world.time - co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
					take_oxygen_deprivation(15)
			if (prob(20)) // Lets give them some chance to know somethings not right though I guess.
				spawn(0) emote("cough")

		else
			co2overloadtime = 0

		if (Toxins_pp > safe_toxins_max) // Too much toxins
			var/ratio = breath.toxins/safe_toxins_max
			take_toxin_damage(ratio * 325,15)
			hud.update_tox_indicator(1)
		else
			hud.update_tox_indicator(0)

		if (breath.trace_gases && breath.trace_gases.len)	// If there's some other shit in the air lets deal with it here.
			for (var/datum/gas/sleeping_agent/SA in breath.trace_gases)
				var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure
				if (SA_pp > SA_para_min) // Enough to make us paralysed for a bit
					src.paralysis = max(src.paralysis, 3) // 3 gives them one second to wake up and run away a bit!
					if (SA_pp > SA_sleep_min) // Enough to make us sleep as well
						src.sleeping = max(src.sleeping, 2)
				else if (SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
					if (prob(20))
						spawn(0) emote(pick("giggle", "laugh"))
			for (var/datum/gas/rad_particles/RV in breath.trace_gases)
				src.irradiate(RV.moles/10,1)

		if (breath.temperature > (T0C+66) && !src.is_heat_resistant()) // Hot air hurts :(
			if (prob(20))
				boutput(src, "<span style=\"color:red\">You feel a searing heat in your lungs!</span>")
			TakeDamage("chest", 0, min((breath.temperature - (T0C+66)) / 3,10) + 6, 0, DAMAGE_BURN)
			hud.update_fire_indicator(1)
			if (prob(4))
				boutput(src, "<span style=\"color:red\">Your lungs hurt like hell! This can't be good!</span>")
				//src.contract_disease(new/datum/ailment/disability/cough, 1, 0) // cogwerks ailment project - lung damage from fire
		else
			hud.update_fire_indicator(0)


		//Temporary fixes to the alerts.

		return 1

	proc/handle_environment(datum/gas_mixture/environment)
		if (!environment)
			return
		var/environment_heat_capacity = environment.heat_capacity()
		var/loc_temp = T0C
		if (istype(loc, /turf/space))
			environment_heat_capacity = loc:heat_capacity
			loc_temp = 2.7
		else if (istype(src.loc, /obj/machinery/vehicle))
			var/obj/machinery/vehicle/ship = src.loc
			if (ship.life_support)
				if (ship.life_support.active)
					loc_temp = ship.life_support.tempreg
				else
					loc_temp = environment.temperature
		// why am i repeating this shit?
		else if (istype(src.loc, /obj/vehicle))
			var/obj/vehicle/V = src.loc
			if (V.sealed_cabin)
				loc_temp = T20C // hardcoded honkytonk nonsense
		else if (istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			loc_temp = loc:air_contents.temperature
		else if (istype(loc, /obj/machinery/colosseum_putt))
			loc_temp = T20C
		else
			loc_temp = environment.temperature

		var/thermal_protection
		if (stat < 2)
			src.bodytemperature = adjustBodyTemp(src.bodytemperature,src.base_body_temp,1,src.thermoregulation_mult)
		if (loc_temp < src.base_body_temp) // a cold place -> add in cold protection
			if (src.is_cold_resistant())
				return
			thermal_protection = get_cold_protection()
		else // a hot place -> add in heat protection
			if (src.is_heat_resistant())
				return
			thermal_protection = get_heat_protection()
		var/thermal_divisor = (100 - thermal_protection) * 0.01
		src.bodytemperature = adjustBodyTemp(src.bodytemperature,loc_temp,thermal_divisor,src.innate_temp_resistance)

		if (istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			return

		// lets give them a fair bit of leeway so they don't just start dying
		//as that may be realistic but it's no fun
		if ((src.bodytemperature > src.base_body_temp + (src.temp_tolerance * 2) && environment.temperature > src.base_body_temp + (src.temp_tolerance * 2)) || (src.bodytemperature < src.base_body_temp - (src.temp_tolerance * 2) && environment.temperature < src.base_body_temp - (src.temp_tolerance * 2)))
			var/transfer_coefficient

			transfer_coefficient = 1
			if (head && (head.body_parts_covered & HEAD) && (environment.temperature < head.protective_temperature))
				transfer_coefficient *= head.heat_transfer_coefficient
			if (wear_mask && (wear_mask.body_parts_covered & HEAD) && (environment.temperature < wear_mask.protective_temperature))
				transfer_coefficient *= wear_mask.heat_transfer_coefficient
			if (wear_suit && (wear_suit.body_parts_covered & HEAD) && (environment.temperature < wear_suit.protective_temperature))
				transfer_coefficient *= wear_suit.heat_transfer_coefficient

			handle_temperature_damage(HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)

			transfer_coefficient = 1
			if (wear_suit && (wear_suit.body_parts_covered & TORSO) && (environment.temperature < wear_suit.protective_temperature))
				transfer_coefficient *= wear_suit.heat_transfer_coefficient
			if (w_uniform && (w_uniform.body_parts_covered & TORSO) && (environment.temperature < w_uniform.protective_temperature))
				transfer_coefficient *= w_uniform.heat_transfer_coefficient

			handle_temperature_damage(TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

			transfer_coefficient = 1
			if (wear_suit && (wear_suit.body_parts_covered & LEGS) && (environment.temperature < wear_suit.protective_temperature))
				transfer_coefficient *= wear_suit.heat_transfer_coefficient
			if (w_uniform && (w_uniform.body_parts_covered & LEGS) && (environment.temperature < w_uniform.protective_temperature))
				transfer_coefficient *= w_uniform.heat_transfer_coefficient

			handle_temperature_damage(LEGS, environment.temperature, environment_heat_capacity*transfer_coefficient)

			transfer_coefficient = 1
			if (wear_suit && (wear_suit.body_parts_covered & ARMS) && (environment.temperature < wear_suit.protective_temperature))
				transfer_coefficient *= wear_suit.heat_transfer_coefficient
			if (w_uniform && (w_uniform.body_parts_covered & ARMS) && (environment.temperature < w_uniform.protective_temperature))
				transfer_coefficient *= w_uniform.heat_transfer_coefficient

			handle_temperature_damage(ARMS, environment.temperature, environment_heat_capacity*transfer_coefficient)

			for (var/atom/A in src.contents)
				if (A.material)
					A.material.triggerTemp(A, environment.temperature)

		// decoupled this from environmental temp - this should be more for hypothermia/heatstroke stuff
		//if (src.bodytemperature > src.base_body_temp || src.bodytemperature < src.base_body_temp)

		//Account for massive pressure differences
		return //TODO: DEFERRED

	proc/get_cold_protection()
		// calculate 0-100% insulation from cold environments
		if (!src)
			return 0

		// Sealed space suit? If so, consider it to be full protection
		if (src.protected_from_space())
			return 100

		var/thermal_protection = 10 // base value

		// Resistance from Bio Effects
		if (src.bioHolder)
			if (src.bioHolder.HasEffect("fat"))
				thermal_protection += 10
			if (src.bioHolder.HasEffect("dwarf"))
				thermal_protection += 10

		// Resistance from Clothing
		for (var/obj/item/clothing/C in src.get_equipped_items())
			thermal_protection += C.cold_resistance

		// Resistance from covered body parts
		if (w_uniform && (w_uniform.body_parts_covered & TORSO))
			thermal_protection += 10

		if (wear_suit)
			if (wear_suit.body_parts_covered & TORSO)
				thermal_protection += 10
			if (wear_suit.body_parts_covered & LEGS)
				thermal_protection += 10
			if (wear_suit.body_parts_covered & ARMS)
				thermal_protection += 10

		thermal_protection = max(0,min(thermal_protection,100))
		return thermal_protection

	proc/get_heat_protection()
		// calculate 0-100% insulation from cold environments
		if (!src)
			return 0

		var/thermal_protection = 10 // base value

		// Resistance from Bio Effects
		if (src.bioHolder)
			if (src.bioHolder.HasEffect("dwarf"))
				thermal_protection += 10

		// Resistance from Clothing
		for (var/obj/item/clothing/C in src.get_equipped_items())
			thermal_protection += C.heat_resistance

		// Resistance from covered body parts
		if (w_uniform && (w_uniform.body_parts_covered & TORSO))
			thermal_protection += 10

		if (wear_suit)
			if (wear_suit.body_parts_covered & TORSO)
				thermal_protection += 10
			if (wear_suit.body_parts_covered & LEGS)
				thermal_protection += 10
			if (wear_suit.body_parts_covered & ARMS)
				thermal_protection += 10

		thermal_protection = max(0,min(thermal_protection,100))
		return thermal_protection

	proc/add_fire_protection(var/temp)
		var/fire_prot = 0
		if (head)
			if (head.protective_temperature > temp)
				fire_prot += (head.protective_temperature/10)
		if (wear_mask)
			if (wear_mask.protective_temperature > temp)
				fire_prot += (wear_mask.protective_temperature/10)
		if (glasses)
			if (glasses.protective_temperature > temp)
				fire_prot += (glasses.protective_temperature/10)
		if (ears)
			if (ears.protective_temperature > temp)
				fire_prot += (ears.protective_temperature/10)
		if (wear_suit)
			if (wear_suit.protective_temperature > temp)
				fire_prot += (wear_suit.protective_temperature/10)
		if (w_uniform)
			if (w_uniform.protective_temperature > temp)
				fire_prot += (w_uniform.protective_temperature/10)
		if (gloves)
			if (gloves.protective_temperature > temp)
				fire_prot += (gloves.protective_temperature/10)
		if (shoes)
			if (shoes.protective_temperature > temp)
				fire_prot += (shoes.protective_temperature/10)

		return fire_prot

	proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
		if (exposed_temperature > src.base_body_temp && src.is_heat_resistant())
			return
		if (exposed_temperature < src.base_body_temp && src.is_cold_resistant())
			return
		var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1)

		switch(body_part)
			if (HEAD)
				TakeDamage("head", 0, 2.5*discomfort, 0, DAMAGE_BURN)
			if (TORSO)
				TakeDamage("chest", 0, 2.5*discomfort, 0, DAMAGE_BURN)
			if (LEGS)
				TakeDamage("l_leg", 0, 0.6*discomfort, 0, DAMAGE_BURN)
				TakeDamage("r_leg", 0, 0.6*discomfort, 0, DAMAGE_BURN)
			if (ARMS)
				TakeDamage("l_arm", 0, 0.4*discomfort, 0, DAMAGE_BURN)
				TakeDamage("r_arm", 0, 0.4*discomfort, 0, DAMAGE_BURN)

	proc/handle_chemicals_in_body()
		if (src.nodamage) return

//			var/datum/reagent/blood/blood = null
		if (reagents)
			reagents.temperature_reagents(src.bodytemperature-30, 100)
			if (blood_system && reagents.get_reagent("blood"))
				var/blood2absorb = min(src.blood_absorption_rate, src.reagents.get_reagent_amount("blood"))
				reagents.remove_reagent("blood", blood2absorb)
				if (src.blood_volume <= (500 - blood2absorb))
					src.blood_volume += blood2absorb
			reagents.metabolize(src)
//				blood = reagents.get_reagent("blood")

		if (src.nutrition > 0)
			src.nutrition--

		src.updatehealth()

		return //TODO: DEFERRED

	proc/handle_blood() // hopefully this won't cause too much lag?
		if (!blood_system) // I dunno if this'll do what I want but hopefully it will
			return

		if (src.stat == 2 || src.nodamage || !src.can_bleed || isvampire(src)) // if we're dead or immortal or have otherwise been told not to bleed, don't bother
			if (src.bleeding)
				src.bleeding = 0 // also stop bleeding if we happen to be doing that
			return

		if (src.blood_volume < 500 && src.blood_volume > 0) // if we're full or empty, don't bother v
			if (prob(66))
				src.blood_volume ++ // maybe get a little blood back ^

		if (src.bleeding)
			var/fluff = pick("better", "like they're healing a bit", "a little better", "itchy", "less tender", "less painful", "like they're closing", "like they're closing up a bit", "like they're closing up a little")
			if (src.bleeding <= 3 && prob(2)) // blood does clot and all, but we want bleeding to maybe not stop entirely on its own TOO easily
				src.bleeding --
				boutput(src, "<span style=\"color:blue\">Your wounds feel [fluff].</span>")
			else if (src.bleeding >= 4 && src.bleeding <= 7 && prob(5)) // higher bleeding gets a better chance to drop down
				src.bleeding --
				boutput(src, "<span style=\"color:blue\">Your wounds feel [fluff].</span>")
			else if (src.bleeding >= 8 && prob(2)) // but there's only so much clotting can do when all your blood is falling out at once
				src.bleeding --
				boutput(src, "<span style=\"color:blue\">Your wounds feel [fluff].</span>")

		if (!src.bleeding && src.get_surgery_status())
			src.bleeding ++

		if (src.bleeding && src.blood_volume)

			var/final_bleed = minmax(src.bleeding, 0, 10) // still don't want this above 10

			if (prob(max(0, min(final_bleed, 10)) * 5)) // up to 50% chance to make a big bloodsplatter
				bleed(src, final_bleed, 5)

			else
				switch (src.bleeding)
					if (1 to 2)
						bleed(src, final_bleed, 1) // this proc creates a bloodsplatter on src's tile
					if (3 to 4)
						bleed(src, final_bleed, 2) // it takes care of removing blood, and transferring reagents, color and ling status to the blood
					if (5 to 7)
						bleed(src, final_bleed, 3) // see blood_system.dm for the proc
					if (8 to 10)
						bleed(src, final_bleed, 4)

		if (!src.is_changeling())

			switch (src.blood_volume)

				if (-INFINITY to 0)
					src.take_oxygen_deprivation(1)
					src.take_brain_damage(2)
					src.losebreath ++
					src.drowsyness = max(src.drowsyness, 4)
					if (prob(10))
						src.change_misstep_chance(3)
					if (prob(10))
						src.emote(pick("faint", "collapse", "pale", "shudder", "shiver", "gasp", "moan"))
					if (prob(18))
						var/extreme = pick("", "really ", "very ", "extremely ", "terribly ", "insanely ")
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("[extreme]ill", "[extreme]sick", "[extreme]numb", "[extreme]cold", "[extreme]dizzy", "[extreme]out of it", "[extreme]confused", "[extreme]off-balance", "[extreme]terrible", "[extreme]awful", "like death", "like you're dying", "[extreme]tingly", "like you're going to pass out", "[extreme]faint")]!</b></span>")
						src.weakened +=4
					src.contract_disease(/datum/ailment/disease/shock, null, null, 1) // if you have no blood you're gunna be in shock

				if (1 to 100)
					src.take_oxygen_deprivation(1)
					src.take_brain_damage(1)
					src.losebreath ++
					src.drowsyness = max(src.drowsyness, 3)
					if (prob(6))
						src.change_misstep_chance(2)
					if (prob(8))
						src.emote(pick("faint", "collapse", "pale", "shudder", "shiver", "gasp", "moan"))
					if (prob(14))
						var/extreme = pick("", "really ", "very ", "extremely ", "terribly ", "insanely ")
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("[extreme]ill", "[extreme]sick", "[extreme]numb", "[extreme]cold", "[extreme]dizzy", "[extreme]out of it", "[extreme]confused", "[extreme]off-balance", "[extreme]terrible", "[extreme]awful", "like death", "like you're dying", "[extreme]tingly", "like you're going to pass out", "[extreme]faint")]!</b></span>")
						src.weakened +=3
					if (prob(25))
						src.contract_disease(/datum/ailment/disease/shock, null, null, 1)

				if (101 to 200)
					src.drowsyness = max(src.drowsyness, 2)
					if (prob(4))
						src.change_misstep_chance(1)
					if (prob(6))
						src.emote(pick("faint", "collapse", "pale", "shudder", "shiver"))
					if (prob(10))
						var/extreme = pick("", "really ", "very ", "extremely ", "terribly ", "insanely ")
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("[extreme]ill", "[extreme]sick", "[extreme]numb", "[extreme]cold", "[extreme]dizzy", "[extreme]out of it", "[extreme]confused", "[extreme]off-balance", "[extreme]terrible", "[extreme]awful", "like death", "like you're dying", "[extreme]tingly", "like you're going to pass out", "[extreme]faint")]!</b></span>")
						src.weakened +=2
					if (prob(25))
						src.contract_disease(/datum/ailment/disease/shock, null, null, 1)

				if (201 to 300)
					src.drowsyness = max(src.drowsyness, 1)
					if (prob(4))
						src.emote(pick("pale", "shudder", "shiver"))
					if (prob(7))
						var/extreme = pick("", "really ", "very ", "quite ", "sorta ")
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("[extreme]ill", "[extreme]sick", "[extreme]numb", "[extreme]cold", "[extreme]dizzy", "[extreme]out of it", "[extreme]confused", "[extreme]off-balance", "[extreme]tingly", "[extreme]faint")]!</b></span>")
						src.weakened +=1
					if (prob(10))
						src.contract_disease(/datum/ailment/disease/shock, null, null, 1)

				if (301 to 400)
					if (prob(2))
						src.emote(pick("pale", "shudder", "shiver"))
					if (prob(5))
						var/extreme = pick("", "kinda ", "a little ", "sorta ", "a bit ")
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("[extreme]ill", "[extreme]sick", "[extreme]numb", "[extreme]cold", "[extreme]dizzy", "[extreme]out of it", "[extreme]confused", "[extreme]off-balance", "[extreme]tingly", "[extreme]faint")]!</b></span>")
					if (prob(5))
						src.contract_disease(/datum/ailment/disease/shock, null, null, 1)

	proc/handle_organs() // is this even where this should go???  ??????  haine gud codr

		if (src.ignore_organs)
			return

		if (!src.organHolder)
			src.organHolder = new(src)
			sleep(10)

		if (!src.organHolder.head && !src.nodamage)
			src.death()

		if (!src.organHolder.skull && !src.nodamage) // look okay it's close enough to an organ and there's no other place for it right now shut up
			if (src.organHolder.head)
				src.death()
				src.visible_message("<span style=\"color:red\"><b>[src]</b>'s head collapses into a useless pile of skin mush with no skull to keep it in its proper shape!</span>",\
				"<span style=\"color:red\">Your head collapses into a useless pile of skin mush with no skull to keep it in its proper shape!</span>")
		else
			if (src.organHolder.skull.loc != src)
				src.organHolder.skull = null

		if (!src.organHolder.brain && !src.nodamage)
			/*var/obj/item/organ/brain/myBrain = locate(/obj/item/organ/brain) in src
			if (myBrain)
				src.brain = myBrain
			else*/
			src.death()
		else
			if (src.organHolder.brain.loc != src)
				src.organHolder.brain = null

		if (!src.organHolder.heart && !src.nodamage)
			/*var/obj/item/organ/heart/myHeart = locate(/obj/item/organ/heart) in src
			if (myHeart)
				src.heart = myHeart
			else */
			if (!src.is_changeling())
				if (src.get_oxygen_deprivation())
					src.take_brain_damage(3)
				else if (prob(10))
					src.take_brain_damage(1)

				src.weakened = max(src.weakened, 5)
				src.losebreath += 20
				src.take_oxygen_deprivation(20)
				src.updatehealth()
		else
			if (src.organHolder.heart.loc != src)
				src.organHolder.heart = null
			else if (src.organHolder.heart.robotic && src.organHolder.heart.emagged && !src.organHolder.heart.broken)
				src.drowsyness = max (src.drowsyness - 8, 0)
				if (src.paralysis) src.paralysis -= 2
				if (src.stunned) src.stunned -= 2
				if (src.weakened) src.weakened -= 2
				if (src.sleeping) src.sleeping = 0
			else if (src.organHolder.heart.robotic && !src.organHolder.heart.broken)
				src.drowsyness = max (src.drowsyness - 4, 0)
				if (src.paralysis) src.paralysis -= 1
				if (src.stunned) src.stunned -= 1
				if (src.weakened) src.weakened -= 1
				if (src.sleeping) src.sleeping = 0
			else if (src.organHolder.heart.broken)
				if (src.get_oxygen_deprivation())
					src.take_brain_damage(3)
				else if (prob(10))
					src.take_brain_damage(1)

				src.weakened = max(src.weakened, 5)
				src.losebreath += 20
				src.take_oxygen_deprivation(20)
				src.updatehealth()

		// lungs are skipped until they can be removed/whatever
		if (!src.organHolder.left_eye && src.organHolder.right_eye) // we have no left eye, but we also don't have the blind overlay (presumably)
			if (!src.hasOverlayComposition(/datum/overlayComposition/blinded))
				src.addOverlayComposition(/datum/overlayComposition/blinded_l_eye)
				src.removeOverlayComposition(/datum/overlayComposition/blinded_r_eye)

		else if (!src.organHolder.right_eye && src.organHolder.left_eye) // we have no right eye, but we also don't have the blind overlay (presumably)
			if (!src.hasOverlayComposition(/datum/overlayComposition/blinded))
				src.addOverlayComposition(/datum/overlayComposition/blinded_r_eye)
				src.removeOverlayComposition(/datum/overlayComposition/blinded_l_eye)

		else
			src.removeOverlayComposition(/datum/overlayComposition/blinded_r_eye)
			src.removeOverlayComposition(/datum/overlayComposition/blinded_l_eye)

	proc/handle_regular_status_updates(datum/controller/process/mobs/parent)

		health = max_health - (get_oxygen_deprivation() + get_toxin_damage() + get_burn_damage() + get_brute_damage())

		// I don't think the revenant needs any of this crap - Marq
		if (src.bioHolder && src.bioHolder.HasEffect("revenant") || src.stat == 2) //You also don't need to do a whole lot of this if the dude's dead.
			return

		if (stamina == STAMINA_NEG_CAP)
			paralysis = max(paralysis, 10)

		//maximum modifiers.
		stamina_max = max((STAMINA_MAX + src.get_stam_mod_max()), 0)
		stamina = min(stamina, stamina_max)

		//Modify stamina.
		var/final_mod = (src.stamina_regen + src.get_stam_mod_regen())
		if (final_mod > 0)
			src.add_stamina(abs(final_mod))
		else if (final_mod < 0)
			src.remove_stamina(abs(final_mod))

		parent.setLastTask("status_updates implant check", src)
		for (var/obj/item/implant/I in src.implant)
			if (istype(I, /obj/item/implant/robust))
				var/obj/item/implant/robust/R = I
				if (src.health < 0)
					R.inactive = 1
					src.reagents.add_reagent("salbutamol", 20) // changed this from dexP // cogwerks
					src.reagents.add_reagent("inaprovaline", 15)
					src.reagents.add_reagent("omnizine", 25)
					src.reagents.add_reagent("teporone", 20)
					if (src.mind) boutput(src, "<span style=\"color:blue\">Your Robusttec-Implant uses all of its remaining energy to save you and deactivates.</span>")
					src.implant -= I
				else if (src.health < 40 && !R.inactive)
					if (!src.reagents.has_reagent("omnizine", 10))
						src.reagents.add_reagent("omnizine", 10)
					R.inactive = 1
					spawn(300) R.inactive = 0

			if (istype(I, /obj/item/implant/health))
				if (!src.mini_health_hud)
					src.mini_health_hud = 1
				var/obj/item/implant/health/H = I
				var/datum/data/record/probably_my_record = null
				for (var/datum/data/record/R in data_core.medical)
					if (R.fields["name"] == src.real_name)
						probably_my_record = R
						break
				if (probably_my_record)
					probably_my_record.fields["h_imp"] = "[H.sensehealth()]"
				if (src.health <= 0 && !H.reported_health)
					DEBUG("[src] calling to report crit")
					H.health_alert()

				if (src.health > 0 && H.reported_health) // we're out of crit, let our implant alert people again
					H.reported_health = 0
				if (src.stat != 2 && H.reported_death) // we're no longer dead, let our implant alert people again
					H.reported_death = 0

		//parent.setLastTask("status_updates max value calcs", src)

		parent.setLastTask("status_updates sleep and paralysis calcs", src)
		if (src.asleep) src.sleeping = 4

		if (src.sleeping)
			src.paralysis = max(src.paralysis, 3)
			if (prob(10) && (health > 0)) spawn(0) emote("snore")
			if (!src.asleep) src.sleeping--

		if (src.resting)
			src.weakened = max(src.weakened, 2)

		parent.setLastTask("status_updates health calcs", src)
		var/is_chg = is_changeling()
		//if (src.brain_op_stage == 4.0) // handled above in handle_organs() now
			//death()
		if (src.get_brain_damage() >= 120 || (src.health + (src.get_oxygen_deprivation() / 2)) <= -500) //-200) a shitty test here // let's lower the weight of oxy
			if (!is_chg)
				death()
			else if (src.suiciding)
				death()

		if (src.get_brain_damage() >= 100) // braindeath
			if (!is_chg)
				src.losebreath+=10
				src.weakened = 30
		if (src.health <= -100)
			var/deathchance = min(99, ((src.get_brain_damage() * -5) + (src.health + (src.get_oxygen_deprivation() / 2))) * -0.01)
			if (prob(deathchance))
				death()

		/////////////////////////////////////////////
		//// cogwerks - critical health rewrite /////
		/////////////////////////////////////////////
		//// goal: make crit a medical emergency ////
		//// instead of game over black screen time /
		/////////////////////////////////////////////


		if (src.health < 0 && src.stat != 2)
			if (prob(5))
				src.emote(pick("faint", "collapse", "cry","moan","gasp","shudder","shiver"))
			if (src.stuttering <= 5)
				src.stuttering+=5
			if (src.get_eye_blurry() <= 5)
				src.change_eye_blurry(5)
			if (prob(7))
				src.change_misstep_chance(2)
			if (prob(5))
				src.paralysis = max(src.paralysis, 2)
			switch(src.health)
				if (-INFINITY to -100)
					src.take_oxygen_deprivation(1)
					/*if (src.reagents)
						if (!src.reagents.has_reagent("inaprovaline"))
							src.take_oxygen_deprivation(1)*/
					if (prob(src.health * -0.1))
						src.contract_disease(/datum/ailment/disease/flatline,null,null,1)
						//boutput(world, "\b LOG: ADDED FLATLINE TO [src].")
					if (prob(src.health * -0.2))
						src.contract_disease(/datum/ailment/disease/heartfailure,null,null,1)
						//boutput(world, "\b LOG: ADDED HEART FAILURE TO [src].")
					if (src.stat == 0)
						sleep(0)
						if (src && src.mind)
							src.lastgasp() // if they were ok before dropping below zero health, call lastgasp() before setting them unconscious
					if (src.stat != 2)
						src.stat = 1
					//src.paralysis = max(src.paralysis, 5)
					// losebreath can handle this part
				if (-99 to -80)
					src.take_oxygen_deprivation(1)
					/*if (src.reagents)
						if (!src.reagents.has_reagent("inaprovaline"))
							src.take_oxygen_deprivation(1)*/
					if (prob(4))
						boutput(src, "<span style=\"color:red\"><b>Your chest hurts...</b></span>")
						src.paralysis++
						src.contract_disease(/datum/ailment/disease/heartfailure,null,null,1)
				if (-79 to -51)
					/*if (src.reagents)
						if (!src.reagents.has_reagent("inaprovaline")) src.take_oxygen_deprivation(1)*/
					if (prob(10)) // shock added back to crit because it wasn't working as a bloodloss-only thing
						src.contract_disease(/datum/ailment/disease/shock,null,null,1)
						//boutput(world, "\b LOG: ADDED SHOCK TO [src].")
					if (prob(src.health * -0.08))
						src.contract_disease(/datum/ailment/disease/heartfailure,null,null,1)
						//boutput(world, "\b LOG: ADDED HEART FAILURE TO [src].")
					if (prob(6))
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("horrible pain", "awful", "like shit", "absolutely awful", "like death", "like you are dying", "nothing", "warm", "sweaty", "tingly", "really, really bad", "horrible")]</b>!</span>")
						src.weakened +=3
					if (prob(3))
						src.paralysis++
				if (-50 to 0)
					src.take_oxygen_deprivation(1)
					/*if (src.reagents)
						if (!src.reagents.has_reagent("inaprovaline") && prob(50))
							src.take_oxygen_deprivation(1)*/
					if (prob(3))
						src.contract_disease(/datum/ailment/disease/shock,null,null,1)
						//boutput(world, "\b LOG: ADDED SHOCK TO [src].")
					if (prob(5))
						boutput(src, "<span style=\"color:red\"><b>You feel [pick("terrible", "awful", "like shit", "sick", "numb", "cold", "sweaty", "tingly", "horrible")]!</b></span>")
						src.weakened +=3

		parent.setLastTask("status_updates blindness checks", src)
		if (istype(src.glasses, /obj/item/clothing/glasses/))
			var/obj/item/clothing/glasses/G = src.glasses
			if (G.block_vision)
				src.blinded = 1

		//A ghost costume without eyeholes is a bad idea.
		if (istype(src.wear_suit, /obj/item/clothing/suit/bedsheet))
			var/obj/item/clothing/suit/bedsheet/B = src.wear_suit
			if (!B.eyeholes && !B.cape)
				src.blinded = 1

		else if (istype(src.wear_suit, /obj/item/clothing/suit/cardboard_box))
			var/obj/item/clothing/suit/cardboard_box/B = src.wear_suit
			if (!B.eyeholes)
				src.blinded = 1

		if (manualblinking)
			var/showmessages = 1
			var/tempblind = src.get_eye_damage(1)

			if (src.find_ailment_by_type(/datum/ailment/disability/blind))
				showmessages = 0

			src.blinktimer++
			switch(src.blinktimer)
				if (20)
					if (showmessages) boutput(src, "<span style=\"color:red\">Your eyes feel slightly uncomfortable!</span>")
				if (30)
					if (showmessages) boutput(src, "<span style=\"color:red\">Your eyes feel quite dry!</span>")
				if (40)
					if (showmessages) boutput(src, "<span style=\"color:red\">Your eyes feel very dry and uncomfortable, it's getting difficult to see!</span>")
					src.change_eye_blurry(3, 3)
				if (41 to 59)
					src.change_eye_blurry(3, 3)
				if (60)
					if (showmessages) boutput(src, "<span style=\"color:red\">Your eyes are so dry that you can't see a thing!</span>")
					src.take_eye_damage(max(0, min(3, 3 - tempblind)), 1)
				if (61 to 99)
					src.take_eye_damage(max(0, min(3, 3 - tempblind)), 1)
				if (100) //blinking won't save you now, buddy
					if (showmessages) boutput(src, "<span style=\"color:red\">You feel a horrible pain in your eyes. That can't be good.</span>")
					src.contract_disease(/datum/ailment/disability/blind,null,null,1)

			if (src.blinkstate) src.take_eye_damage(max(0, min(1, 1 - tempblind)), 1)

		if (src.get_eye_damage(1)) // Temporary blindness.
			src.take_eye_damage(-1, 1)
			src.blinded = 1

		// drsingh :wtc: why was there a runtime error about comparing "" to 50 here? varedit or something?
		// welp thisll fix it
		parent.setLastTask("status_updates disability checks", src)
		src.stuttering = isnum(src.stuttering) ? min(src.stuttering, 50) : 0
		if (src.stuttering) src.stuttering--

		if (src.get_ear_damage(1)) // Temporary deafness.
			src.take_ear_damage(-1, 1)

		if (src.get_ear_damage() && (src.get_ear_damage() <= src.get_ear_damage_natural_healing_threshold()))
			src.take_ear_damage(-0.05)

		if (src.get_eye_blurry())
			src.change_eye_blurry(-1)

		if (src.druggy > 0)
			src.druggy--
			src.druggy = max(0, src.druggy)

		if (src.nodamage)
			parent.setLastTask("status_updates nodamage reset", src)
			src.HealDamage("All", 10000, 10000)
			src.take_toxin_damage(-5000)
			src.take_oxygen_deprivation(-5000)
			src.take_brain_damage(-120)
			src.irradiate(-100)
			src.paralysis = 0
			src.weakened = 0
			src.stunned = 0
			src.stuttering = 0
			src.take_ear_damage(-INFINITY)
			src.take_ear_damage(-INFINITY, 1)
			src.change_eye_blurry(-INFINITY)
			src.druggy = 0
			src.blinded = null

		return 1

	proc/handle_stuns_lying(datum/controller/process/mobs/parent)
		parent.setLastTask("status_updates lying/standing checks")
		var/tmp/lying_old = src.lying
		var/cant_lie = (src.limbs && istype(src.limbs.l_leg, /obj/item/parts/robot_parts/leg/left/treads) && istype(src.limbs.r_leg, /obj/item/parts/robot_parts/leg/right/treads) && !locate(/obj/table, src.loc) && !locate(/obj/machinery/optable, src.loc))

		var/must_lie = (!cant_lie && src.limbs && !src.limbs.l_leg && !src.limbs.r_leg) //hasn't got a leg to stand on... haaa

		var/changeling_fakedeath = 0
		var/datum/abilityHolder/changeling/C = get_ability_holder(/datum/abilityHolder/changeling)
		if (C && C.in_fakedeath)
			changeling_fakedeath = 1

		if (src.stat != 2) //Alive.
			if (src.paralysis || src.stunned || src.weakened || changeling_fakedeath || src.slowed) //Stunned etc.
				parent.setLastTask("status_updates lying/standing checks stun calcs")
				var/setStat = src.stat
				var/oldStat = src.stat
				if (src.stunned > 0)
					src.stunned--
					setStat = 0
				if (src.slowed > 0)
					src.slowed--
					setStat = 0
				if (src.weakened > 0 && !src.fakedead)
					src.weakened--
					if (!cant_lie) src.lying = 1
					setStat = 0
				if (src.paralysis > 0)
					src.paralysis--
					src.blinded = 1
					if (!cant_lie) src.lying = 1
					setStat = 1
				if (src.stat == 0 && setStat == 1)
					parent.setLastTask("status_updates lying/standing checks last gasp")
					sleep(0)
					if (src && src.mind) src.lastgasp() // calling lastgasp() here because we just got knocked out
				if (must_lie)
					src.lying = 1

				src.stat = setStat

				parent.setLastTask("status_updates lying/standing checks item dropping")
				var/h = src.hand
				src.hand = 0
				drop_item()
				src.hand = 1
				drop_item()
				src.hand = h
				if (src.juggling())
					src.drop_juggle()

				parent.setLastTask("status_updates lying/standing checks recovery checks")
				if (world.time - last_recovering_msg >= 60 || last_recovering_msg == 0)
					if ( ((paralysis && paralysis <= 3) && stunned <= paralysis && weakened <= paralysis) || ((stunned && stunned <= 3) && paralysis <= stunned && weakened <= stunned) || ((weakened && weakened <= 3) && paralysis <= weakened && stunned <= weakened) )
						last_recovering_msg = world.time
						if (src.mind && !src.asleep)
							if (src.resting)
								boutput(src, "<span style=\"color:green\">You are resting. Click 'rest' to toggle back to stand.</span>")
							else
								boutput(src, "<span style=\"color:green\">You begin to recover.</span>")
				//		for (var/mob/V in viewers(7,src))
				//			boutput(V, "<span style=\"color:red\">[name] begins to recover.</span>")
				else if ((oldStat == 1) && (!paralysis && !stunned && !src.weakened && !changeling_fakedeath))
					parent.setLastTask("status updates lying/standing checks wakeup ogg")
					src << sound('sound/misc/molly_revived.ogg', volume=50)

			else	//Not stunned.
				if (must_lie) src.lying = 1
				else src.lying = 0
				src.stat = 0

		else //Dead.
			if ((src.reagents && src.reagents.has_reagent("montaguone_extra")) || cant_lie) src.lying = 0
			else src.lying = 1
			src.blinded = 1
			src.stat = 2

		if (src.lying != lying_old)
			// Update clothing - Taken out of Life() to reduce icon overhead
			parent.setLastTask("status_updates lying/standing checks update clothing")
			update_clothing()
			src.density = !( src.lying )


	proc/handle_regular_sight_updates()

////Mutrace and normal sight
		if (src.stat != 2)
			src.sight &= ~SEE_TURFS
			src.sight &= ~SEE_MOBS
			src.sight &= ~SEE_OBJS

			if (src.mutantrace)
				src.mutantrace.sight_modifier()
			else
				if(src.traitHolder && src.traitHolder.hasTrait("cateyes"))
					src.see_in_dark = SEE_DARK_HUMAN + 2
				else
					src.see_in_dark = SEE_DARK_HUMAN
				src.see_invisible = 0

			if (isvampire(src))
				var/turf/T = get_turf(src)
				if (src.check_vampire_power(2) == 1 && (T && !isrestrictedz(T.z)))
					src.sight |= SEE_MOBS
					src.sight |= SEE_TURFS
					src.sight |= SEE_OBJS
					src.see_in_dark = SEE_DARK_FULL
					src.see_invisible = 2

				else
					if (src.check_vampire_power(1) == 1 && !isrestrictedz(src.z))
						src.sight |= SEE_MOBS
						src.see_invisible = 2

////Dead sight
		var/turf/T = src.eye ? get_turf(src.eye) : get_turf(src) //They might be in a closet or something idk
		if ((src.stat == 2 ||( src.bioHolder && src.bioHolder.HasEffect("xray"))) && (T && !isrestrictedz(T.z)))
			src.sight |= SEE_TURFS
			src.sight |= SEE_MOBS
			src.sight |= SEE_OBJS
			src.see_in_dark = SEE_DARK_FULL
			if (client && client.adventure_view)
				src.see_invisible = 21
			else
				src.see_invisible = 2
			return

////Ship sight
		if (istype(src.loc, /obj/machinery/vehicle))
			var/obj/machinery/vehicle/ship = src.loc
			if (ship.sensors)
				if (ship.sensors.active)
					src.sight |= ship.sensors.sight
					src.see_in_dark = ship.sensors.see_in_dark
					if (client && client.adventure_view)
						src.see_invisible = 21
					else
						src.see_invisible = ship.sensors.see_invisible
					return

		if (src.traitHolder && src.traitHolder.hasTrait("infravision"))
			if (see_infrared < 1)
				src.see_infrared = 1

////Glasses
		if ((istype(src.glasses, /obj/item/clothing/glasses/meson) || src.eye_istype(/obj/item/organ/eye/cyber/meson)) && !isrestrictedz(T.z))
			src.sight |= SEE_TURFS
			if (see_in_dark < initial(see_in_dark) + 1)
				see_in_dark++
			if (see_invisible < 1)
				src.see_invisible = 1
			if (see_infrared < 1)
				src.see_infrared = 1

		else if (istype(src.glasses, /obj/item/clothing/glasses/construction) && !isrestrictedz(T.z))
			if (see_in_dark < initial(see_in_dark) + 1)
				see_in_dark++
			if (see_invisible < 8)
				src.see_invisible = 8

		else if ((istype(src.glasses, /obj/item/clothing/glasses/thermal) || src.eye_istype(/obj/item/organ/eye/cyber/thermal)) && !isrestrictedz(T.z))
			//src.sight |= SEE_MOBS
			if (see_in_dark < initial(see_in_dark) + 4)
				see_in_dark += 4
			if (see_invisible < 2)
				src.see_invisible = 2
			if (see_infrared < 1)
				src.see_infrared = 1

		else if (istype(src.wear_mask, /obj/item/clothing/mask/predator) && !isrestrictedz(T.z))
			src.sight |= SEE_MOBS // Predators kinda need proper thermal vision, I've found in playtesting (Convair880).
			if (see_in_dark < SEE_DARK_FULL)
				src.see_in_dark = SEE_DARK_FULL
			if (see_invisible < 2)
				src.see_invisible = 2

		else if (istype(src.glasses, /obj/item/clothing/glasses/regular/ecto) || eye_istype(/obj/item/organ/eye/cyber/ecto))
			if (see_in_dark != 1)
				see_in_dark = 1
			if (see_invisible < 15)
				src.see_invisible = 15

////Reagents
		if (src.reagents.has_reagent("green_goop") && !isrestrictedz(T.z))
			if (see_in_dark != 1)
				see_in_dark = 1
			if (see_invisible < 15)
				src.see_invisible = 15

		if (client && client.adventure_view)
			src.see_invisible = 21

	proc/handle_regular_hud_updates()
		if (src.stamina_bar) src.stamina_bar.update_value(src)
		//hud.update_indicators()
		hud.update_health_indicator()
		hud.update_temp_indicator()
		hud.update_blood_indicator()
		hud.update_pulling()

		var/color_mod_r = 255
		var/color_mod_g = 255
		var/color_mod_b = 255
		if (istype(src.glasses, /obj/item/clothing/glasses/thermal) || src.eye_istype(/obj/item/organ/eye/cyber/thermal))
			color_mod_g *= 0.8 // red tint
			color_mod_b *= 0.8
		if (istype(src.wear_mask, /obj/item/clothing/mask/gas))
			color_mod_r *= 0.8 // green tint
			color_mod_b *= 0.8
		if (istype(src.glasses, /obj/item/clothing/glasses/sunglasses) || src.eye_istype(/obj/item/organ/eye/cyber/sunglass))
			color_mod_r *= 0.95 // darken a little
			color_mod_g *= 0.95
			color_mod_b *= 0.9
		if (istype(src.head, /obj/item/clothing/head/helmet/welding) && !src.head:up)
			color_mod_r *= 0.3 // darken
			color_mod_g *= 0.3
			color_mod_b *= 0.3
		if (src.druggy)
			vision.animate_color_mod(rgb(rand(0, 255), rand(0, 255), rand(0, 255)), 15)
		else
			vision.set_color_mod(rgb(color_mod_r, color_mod_g, color_mod_b))

		if (istype(src.glasses, /obj/item/clothing/glasses/visor))
			vision.set_scan(1)
		else
			vision.set_scan(0)

		if (istype(src.glasses, /obj/item/clothing/glasses/healthgoggles))
			var/obj/item/clothing/glasses/healthgoggles/G = src.glasses
			if (src.client && !(G.assigned || G.assigned == src.client))
				G.assigned = src.client
				if (!(G in processing_items))
					processing_items.Add(G)
				//G.updateIcons()

		else if (src.organHolder && istype(src.organHolder.left_eye, /obj/item/organ/eye/cyber/prodoc))
			var/obj/item/organ/eye/cyber/prodoc/G = src.organHolder.left_eye
			if (src.client && !(G.assigned || G.assigned == src.client))
				G.assigned = src.client
				if (!(G in processing_items))
					processing_items.Add(G)
				//G.updateIcons()
		else if (src.organHolder && istype(src.organHolder.right_eye, /obj/item/organ/eye/cyber/prodoc))
			var/obj/item/organ/eye/cyber/prodoc/G = src.organHolder.right_eye
			if (src.client && !(G.assigned || G.assigned == src.client))
				G.assigned = src.client
				if (!(G in processing_items))
					processing_items.Add(G)
				//G.updateIcons()

		if (!src.sight_check(1) && src.stat != 2)
			src.addOverlayComposition(/datum/overlayComposition/blinded) //ov1
		else
			src.removeOverlayComposition(/datum/overlayComposition/blinded) //ov1
		vision.animate_dither_alpha(src.get_eye_blurry() / 10 * 255, 15) // animate it so that it doesnt "jump" as much
		return 1

	proc/handle_random_events()
		if (prob(1) && prob(2))
			spawn(0)
				emote("sneeze")
				return

	proc/handle_virus_updates()
		if (prob(40))
			for (var/mob/living/carbon/M in oviewers(4, src))
				M.viral_transmission(src,"Airborne",0)

			for (var/obj/decal/cleanable/blood/B in view(4, src))
				for (var/datum/ailment_data/disease/virus in B.diseases)
					if (virus.spread == "Airborne")
						src.contract_disease(null,null,virus,0)
		if (prob(40))
			for (var/mob/living/carbon/M in oviewers(6, src))
				if (prob(10))
					M.viral_transmission(src, "Sight", 0)

		if (src.stat != 2)
			for (var/datum/ailment_data/am in src.ailments)
				am.stage_act()

	proc/check_if_buckled()
		if (src.buckled)
			if (src.buckled.loc != src.loc)
				src.buckled = null
				return
			src.lying = istype(src.buckled, /obj/stool/bed) || istype(src.buckled, /obj/machinery/conveyor)
			if (src.lying)
				src.drop_item()
			src.density = 1
		else
			src.density = !src.lying

	proc/handle_stomach()
		spawn(0)
			for (var/mob/M in stomach_contents)
				if (M.loc != src)
					stomach_contents.Remove(M)
					continue
				if (iscarbon(M) && src.stat != 2)
					if (M.stat == 2)
						M.death(1)
						stomach_contents.Remove(M)
						if (M.client)
							var/mob/dead/observer/newmob = new(M)
							M:client:mob = newmob
							M.mind.transfer_to(newmob)
						qdel(M)
						emote("burp")
						playsound(src.loc, "sound/misc/burp.ogg", 50, 1)
						continue
					if (air_master.current_cycle%3==1)
						if (!M.nodamage)
							M.TakeDamage("chest", 5, 0)
						src.nutrition += 10

	proc/handle_random_emotes()
		if (!islist(src.random_emotes) || !src.random_emotes.len || src.stat)
			return
		var/emote2do = pick(src.random_emotes)
		src.emote(emote2do)

/mob/living/carbon/human/Login()
	..()

	update_clothing()

	if (ai_active)
		ai_active = 0
	if (src.organHolder && src.organHolder.brain && src.mind)
		src.organHolder.brain.setOwner(src.mind)
	return

/mob/living/carbon/human/Logout()
	..()
	if (!ai_active && is_npc)
		ai_active = 1
	return

/mob/living/carbon/human/get_heard_name()
	var/alt_name = ""
	if (src.name != src.real_name)
		if (src.wear_id && src.wear_id:registered && src.wear_id:registered != src.real_name)
			alt_name = " (as [src.wear_id:registered])"
		else if (!src.wear_id)
			alt_name = " (as Unknown)"

	var/rendered
	if (src.is_npc)
		rendered = "<span class='name'>"
	else
		rendered = "<span class='name' data-ctx='\ref[src.mind]'>"
	if (src.wear_mask && src.wear_mask.vchange)//(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		if (src.wear_id)
			rendered += "[src.wear_id:registered]</span>"
		else
			rendered += "Unknown</span>"
	else
		rendered += "[src.real_name]</span>[alt_name]"

	return rendered

/mob/living/carbon/human/say(var/message)
	if (mutantrace && mutantrace.override_language)
		say_language = mutantrace.override_language

	message = copytext(message, 1, MAX_MESSAGE_LEN)

	if (src.fakedead)
		var/the_verb = pick("wails","moans","laments")
		boutput(src, "<span class='game deadsay'><span class='prefix'>DEAD:</span> [src.get_heard_name()] [the_verb], <span class='message'>\"[message]\"</span></span>")
		return

	if (dd_hasprefix(message, "*") || src.stat == 2)
		..(message)
		return

	if (src.bioHolder.HasEffect("revenant"))
		src.visible_message("<span style=\"color:red\">[src] makes some [pick("eldritch", "eerie", "otherworldly", "netherly", "spooky", "demonic", "haunting")] noises!</span>")
		return

	if (src.stamina < STAMINA_WINDED_SPEAK_MIN)
		src.emote(pick("gasp", "choke", "cough"))
		//boutput(src, "<span style=\"color:red\">You are too exhausted to speak.</span>")
		return


	if (src.robot_talk_understand)
		if (length(message) >= 2)
			if (copytext(lowertext(message), 1, 3) == ":s")
				message = copytext(message, 3)
				src.robot_talk(message)
				return

	message = process_accents(src,message)

	for (var/uid in src.pathogens)
		var/datum/pathogen/P = src.pathogens[uid]
		P.onsay(src, message)

	..(message)

/*/mob/living/carbon/human/say_understands(var/other)
	if (src.mutantrace)
		return src.mutantrace.say_understands(other)
	if (istype(other, /mob/living/silicon/ai))
		return 1
	if (istype(other, /mob/living/silicon/robot))
		return 1
	if (istype(other, /mob/living/silicon/hivebot))
		return 1
	if (istype(other, /mob/living/silicon/hive_mainframe))
		return 1
	if (ishuman(other) && (!other:mutantrace || !other:mutantrace.exclusive_language))
		return 1*/

/mob/living/carbon/human/say_quote(var/text)
	if (src.mutantrace)
		if (src.mutantrace.voice_message)
			src.voice_name = src.mutantrace.voice_name
			src.voice_message = src.mutantrace.voice_message
		if (text == "" || !text)
			return src.mutantrace.say_verb()
		return "[src.mutantrace.say_verb()], \"[text]\""
	else
		src.voice_name = initial(src.voice_name)
		src.voice_message = initial(src.voice_message)

	return ..(text)

//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	if (src.bioHolder.HasEffect("revenant"))
		return src.say(message)
	var/message_mode = null
	var/secure_headset_mode = null
	if (src.get_brain_damage() >= 60 && prob(50))
		message_mode = "headset"
	// Special message handling
	else if (copytext(message, 1, 2) == ";")
		message_mode = "headset"
		message = copytext(message, 2)

	if (src.stamina < STAMINA_WINDED_SPEAK_MIN)
		src.emote(pick("gasp", "choke", "cough"))
		//boutput(src, "<span style=\"color:red\">You are too exhausted to speak.</span>")
		return

	if (src.oxyloss > 10)
		src.emote("gasp")
		return

	else if ((length(message) >= 2) && (copytext(message,1,2) == ":"))
		switch (lowertext( copytext(message,2,4) ))
			if ("rh")
				message_mode = "right hand"
				message = copytext(message, 4)

			if ("lh")
				message_mode = "left hand"
				message = copytext(message, 4)

			if ("in")
				message_mode = "intercom"
				message = copytext(message, 4)

			else
				if (ishuman(src))
					message_mode = "secure headset"
					secure_headset_mode = lowertext(copytext(message,2,3))
				message = copytext(message, 3)

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if (!message)
		return

	logTheThing("diary", src, null, "(WHISPER): [message]", "whisper")
	logTheThing("whisper", src, null, "SAY: [message] (Whispered)")

	if (src.client && !src.client.holder && url_regex && url_regex.Find(message))
		boutput(src, "<span style=\"color:blue\"><b>Web/BYOND links are not allowed in ingame chat.</b></span>")
		boutput(src, "<span style=\"color:red\">&emsp;<b>\"[message]</b>\"</span>")
		return

	if (src.client && src.client.ismuted())
		boutput(src, "You are currently muted and may not speak.")
		return

	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return

	var/alt_name = ""
	if (ishuman(src) && src.name != src.real_name)
		if (src:wear_id && src:wear_id:registered && src:wear_id:registered != src.real_name)
			alt_name = " (as [src:wear_id:registered])"
		else if (!src:wear_id)
			alt_name = " (as Unknown)"

	// Mute disability
	if (src.bioHolder.HasEffect("mute"))
		boutput(src, "<span style=\"color:red\">You seem to be unable to speak.</span>")
		return

	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle))
		boutput(src, "<span style=\"color:red\">Your muzzle prevents you from speaking.</span>")
		return

	var/italics = 1
	var/message_range = 1
	var/forced_language = null
	forced_language = get_special_language(secure_headset_mode)

	message = process_accents(src,message)
	var/list/messages = process_language(message, forced_language)
	var/lang_id = get_language_id(forced_language)

	switch (message_mode)
		if ("headset", "secure headset", "right hand", "left hand")
			talk_into_equipment(message_mode, messages, secure_headset_mode, lang_id)
			message_range = 0
			italics = 1

		if ("intercom")
			for (var/obj/item/device/radio/intercom/I in view(1, null))
				I.talk_into(src, messages, null, src.real_name, lang_id)

			message_range = 0
			italics = 1

	var/list/eavesdropping = hearers(2, src)
	eavesdropping -= src
	var/list/watching  = viewers(5, src)
	watching -= src
	watching -= eavesdropping

	var/list/heard_a = list() // understood us
	var/list/heard_b = list() // didn't understand us

	var/rendered = null

	if (message_range)
		var/heardname = src.real_name
		for (var/obj/O in view(message_range, src))
			spawn (0)
				if (O)
					O.hear_talk(src, messages, heardname, lang_id)

		var/list/listening = all_hearers(message_range, src)
		eavesdropping -= listening

		for (var/mob/M in listening)
			if (M.say_understands(src))
				heard_a += M
			else
				heard_b += M

	for (var/mob/M in watching)
		if (M.say_understands(src))
			rendered = "<span class='game say'><span class='name'>[src.name]</span> whispers something.</span>"
		else
			rendered = "<span class='game say'><span class='name'>[src.voice_name]</span> whispers something.</span>"
		M.show_message(rendered, 2)

	var/list/olocs = list()
	var/thickness = 0
	if (!isturf(loc))
		olocs = obj_loc_chain(src)
		for (var/atom/movable/AM in olocs)
			thickness += AM.soundproofing
	var/list/processed = list()

	if (length(heard_a))
		processed = saylist(messages[1], heard_a, olocs, thickness, italics, processed)

	if (length(heard_b))
		processed = saylist(messages[2], heard_b, olocs, thickness, italics, processed, 1)

	message = messages[1]
	for (var/mob/M in eavesdropping)
		if (M.say_understands(src, lang_id))
			var/message_c = stars(message)

			if (!istype(src, /mob/living/carbon/human))
				rendered = "<span class='game say'><span class='name'>[src.name]</span> whispers, <span class='message'>\"[message_c]\"</span></span>"
			else
				if (src.wear_mask && src.wear_mask.vchange)//(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
					if (src.wear_id)
						rendered = "<span class='game say'><span class='name'>[src.wear_id:registered]</span> whispers, <span class='message'>\"[message_c]\"</span></span>"
					else
						rendered = "<span class='game say'><span class='name'>Unknown</span> whispers, <span class='message'>\"[message_c]\"</span></span>"
				else
					rendered = "<span class='game say'><span class='name'>[src.real_name]</span>[alt_name] whispers, <span class='message'>\"[message_c]\"</span></span>"

		else
			rendered = "<span class='game say'><span class='name'>[src.voice_name]</span> whispers something.</span>"

		M.show_message(rendered, 2)

	if (italics)
		message = "<i>[message]</i>"

	if (!istype(src, /mob/living/carbon/human))
		rendered = "<span class='game say'><span class='name'>[src.name]</span> <span class='message'>[message]</span></span>"
	else
		if (src.wear_mask && src.wear_mask.vchange)//(istype(src:wear_mask, /obj/item/clothing/mask/gas/voice))
			if (src.wear_id)
				rendered = "<span class='game say'><span class='name'>[src.wear_id:registered]</span> <span class='message'>[message]</span></span>"
			else
				rendered = "<span class='game say'><span class='name'>Unknown</span> <span class='message'>[message]</span></span>"
		else
			rendered = "<span class='game say'><span class='name'>[src.real_name]</span>[alt_name] <span class='message'>[message]</span></span>"

	for (var/mob/M in mobs)
		if (istype(M, /mob/new_player))
			continue
		if (M.stat > 1 && !(M in heard_a) && !istype(M, /mob/dead/target_observer))
			M.show_message(rendered, 2)

/mob/living/carbon/human/var/const
	slot_back = 1
	slot_wear_mask = 2
	slot_l_hand = 4
	slot_r_hand = 5
	slot_belt = 6
	slot_wear_id = 7
	slot_ears = 8
	slot_glasses = 9
	slot_gloves = 10
	slot_head = 11
	slot_shoes = 12
	slot_wear_suit = 13
	slot_w_uniform = 14
	slot_l_store = 15
	slot_r_store = 16
//	slot_w_radio = 17
	slot_in_backpack = 18
	slot_in_belt = 19

/mob/living/carbon/human/put_in_hand(obj/item/I, hand)
	if (!istype(I))
		return 0
	if (src.equipped() && istype(src.equipped(), /obj/item/magtractor))
		var/obj/item/magtractor/M = src.equipped()
		if (M.pickupItem(I, src))
			actions.start(new/datum/action/magPickerHold(M), src)
			return 1
		return 0
	if (isnull(hand))
		if (src.put_in_hand(I, src.hand))
			return 1
		if (src.put_in_hand(I, !src.hand))
			return 1
		return 0
	else
		if (hand)
			if (!src.l_hand)
				if (I == src.r_hand && I.cant_self_remove)
					return 0
				if (src.limbs && (!src.limbs.l_arm || istype(src.limbs.l_arm, /obj/item/parts/human_parts/arm/left/item)))
					return 0
				src.l_hand = I
				I.pickup(src)
				I.add_fingerprint(src)
				I.set_loc(src)
				src.update_inhands()
				hud.add_object(I, HUD_LAYER+2, ui_lhand)
				return 1
			else
				return 0
		else
			if (!src.r_hand)
				if (I == src.l_hand && I.cant_self_remove)
					return 0
				if (src.limbs && (!src.limbs.r_arm || istype(src.limbs.r_arm, /obj/item/parts/human_parts/arm/right/item)))
					return 0
				src.r_hand = I
				I.pickup(src)
				I.add_fingerprint(src)
				I.set_loc(src)
				src.update_inhands()
				hud.add_object(I, HUD_LAYER+2, ui_rhand)
				return 1
			else
				return 0

/mob/living/carbon/human/proc/get_slot(slot)
	switch(slot)
		if (slot_back)
			return src.back
		if (slot_wear_mask)
			return src.wear_mask
		if (slot_l_hand)
			return src.l_hand
		if (slot_r_hand)
			return src.r_hand
		if (slot_belt)
			return src.belt
		if (slot_wear_id)
			return src.wear_id
		if (slot_ears)
			return src.ears
		if (slot_glasses)
			return src.glasses
		if (slot_gloves)
			return src.gloves
		if (slot_head)
			return src.head
		if (slot_shoes)
			return src.shoes
		if (slot_wear_suit)
			return src.wear_suit
		if (slot_w_uniform)
			return src.w_uniform
		if (slot_l_store)
			return src.l_store
		if (slot_r_store)
			return src.r_store

/mob/living/carbon/human/proc/force_equip(obj/item/I, slot)
	//warning: icky code
	var/equipped = 0
	switch(slot)
		if (slot_back)
			if (!src.back)
				src.back = I
				hud.add_object(I, HUD_LAYER+2, ui_back)
				I.equipped(src, "back")
				equipped = 1
		if (slot_wear_mask)
			if (!src.wear_mask && src.organHolder && src.organHolder.head)
				src.wear_mask = I
				hud.add_other_object(I, ui_mask)
				I.equipped(src, "mask")
				equipped = 1
		if (slot_l_hand)
			equipped = src.put_in_hand(I, 1)
		if (slot_r_hand)
			equipped = src.put_in_hand(I, 0)
		if (slot_belt)
			if (!src.belt)
				src.belt = I
				hud.add_object(I, HUD_LAYER+2, ui_belt)
				I.equipped(src, "belt")
				equipped = 1
		if (slot_wear_id)
			if (!src.wear_id)
				src.wear_id = I
				hud.add_other_object(I, ui_id)
				I.equipped(src, "id")
				equipped = 1
		if (slot_ears)
			if (!src.ears && src.organHolder && src.organHolder.head)
				src.ears = I
				hud.add_other_object(I, ui_ears)
				I.equipped(src, "ears")
				equipped = 1
		if (slot_glasses)
			if (!src.glasses && src.organHolder && src.organHolder.head)
				src.glasses = I
				hud.add_other_object(I, ui_glasses)
				I.equipped(src, "eyes")
				equipped = 1
		if (slot_gloves)
			if (!src.gloves)
				src.gloves = I
				hud.add_other_object(I, ui_gloves)
				I.equipped(src, "gloves")
				equipped = 1
		if (slot_head)
			if (!src.head && src.organHolder && src.organHolder.head)
				src.head = I
				hud.add_other_object(I, ui_head)
				I.equipped(src, "head")
				equipped = 1
				src.update_hair_layer()
		if (slot_shoes)
			if (!src.shoes)
				src.shoes = I
				hud.add_other_object(I, ui_shoes)
				I.equipped(src, "shoes")
				equipped = 1
		if (slot_wear_suit)
			if (!src.wear_suit)
				src.wear_suit = I
				hud.add_other_object(I, ui_suit)
				I.equipped(src, "o_clothing")
				equipped = 1
				src.update_hair_layer()
		if (slot_w_uniform)
			if (!src.w_uniform)
				src.w_uniform = I
				hud.add_other_object(I, ui_clothing)
				I.equipped(src, "i_clothing")
				equipped = 1
		if (slot_l_store)
			if (!src.l_store)
				src.l_store = I
				hud.add_object(I, HUD_LAYER+2, ui_storage1)
				equipped = 1
		if (slot_r_store)
			if (!src.r_store)
				src.r_store = I
				hud.add_object(I, HUD_LAYER+2, ui_storage2)
				equipped = 1
		if (slot_in_backpack)
			if (src.back && istype(src.back, /obj/item/storage))
				I.set_loc(src.back)
				equipped = 1
		if (slot_in_belt)
			if (src.belt && istype(src.belt, /obj/item/storage))
				I.set_loc(src.belt)
				equipped = 1

	if (equipped)
		if (slot != slot_in_backpack && slot != slot_in_belt)
			I.set_loc(src)
		if (I.ability_buttons.len)
			I.set_mob(src)
			if (slot != slot_in_backpack && slot != slot_in_belt)
				I.show_buttons()
		src.update_clothing()

/mob/living/carbon/human/proc/can_equip(obj/item/I, slot)
	switch (slot)
		if (slot_l_store, slot_r_store)
			if (I.w_class <= 2 && src.w_uniform)
				return 1
		if (slot_l_hand, slot_r_hand)
			return 1
		if (slot_belt)
			if ((I.flags & ONBELT) && src.w_uniform)
				return 1
		if (slot_wear_id)
			if (istype(I, /obj/item/card/id) && src.w_uniform)
				return 1
			if (istype(I, /obj/item/device/pda2) && I:ID_card && src.w_uniform)
				return 1
		if (slot_back)
			if (I.flags & ONBACK)
				return 1
		if (slot_wear_mask) // It's not pretty, but the mutantrace check will do for the time being (Convair880).
			if (istype(I, /obj/item/clothing/mask))
				var/obj/item/clothing/M = I
				if ((src.mutantrace && !src.mutantrace.uses_human_clothes && !M.compatible_species.Find(src.mutantrace.name)) || (!ismonkey(src) && M.monkey_clothes))
					//DEBUG("[src] can't wear [I].")
					return 0
				else
					return 1
		if (slot_ears)
			if (istype(I, /obj/item/clothing/ears) || istype(I,/obj/item/device/radio/headset))
				return 1
		if (slot_glasses)
			if (istype(I, /obj/item/clothing/glasses))
				return 1
		if (slot_gloves)
			if (istype(I, /obj/item/clothing/gloves))
				return 1
		if (slot_head)
			if (istype(I, /obj/item/clothing/head))
				var/obj/item/clothing/H = I
				if ((src.mutantrace && !src.mutantrace.uses_human_clothes && !H.compatible_species.Find(src.mutantrace.name)) || (!ismonkey(src) && H.monkey_clothes))
					//DEBUG("[src] can't wear [I].")
					return 0
				else
					return 1
		if (slot_shoes)
			if (istype(I, /obj/item/clothing/shoes))
				var/obj/item/clothing/SH = I
				if ((src.mutantrace && !src.mutantrace.uses_human_clothes && !SH.compatible_species.Find(src.mutantrace.name)) || (!ismonkey(src) && SH.monkey_clothes))
					//DEBUG("[src] can't wear [I].")
					return 0
				else
					return 1
		if (slot_wear_suit)
			if (istype(I, /obj/item/clothing/suit))
				var/obj/item/clothing/SU = I
				if ((src.mutantrace && !src.mutantrace.uses_human_clothes && !SU.compatible_species.Find(src.mutantrace.name)) || (!ismonkey(src) && SU.monkey_clothes))
					//DEBUG("[src] can't wear [I].")
					return 0
				else
					return 1
		if (slot_w_uniform)
			if (istype(I, /obj/item/clothing/under))
				var/obj/item/clothing/U = I
				if ((src.mutantrace && !src.mutantrace.uses_human_clothes && !U.compatible_species.Find(src.mutantrace.name)) || (!ismonkey(src) && U.monkey_clothes))
					//DEBUG("[src] can't wear [I].")
					return 0
				else
					return 1
		if (slot_in_backpack) // this slot is stupid
			if (src.back && istype(src.back, /obj/item/storage))
				var/obj/item/storage/S = src.back
				if (S.contents.len < 7 && I.w_class <= 3)
					return 1
		if (slot_in_belt) // this slot is also stupid
			if (src.belt && istype(src.belt, /obj/item/storage))
				var/obj/item/storage/S = src.belt
				if (S.contents.len < 7 && I.w_class <= 3)
					return 1
	return 0

/mob/living/carbon/human/proc/equip_if_possible(obj/item/I, slot)
	if (can_equip(I, slot))
		force_equip(I, slot)
		return 1
	else
		return 0

/mob/living/carbon/human/swap_hand(var/specify=-1)
	if (specify >= 0)
		src.hand = specify
	else
		src.hand = !src.hand
	hud.update_hands()

/mob/living/carbon/human/emp_act()
	boutput(src, "<span style=\"color:red\"><B>Your equipment malfunctions.</B></span>")

	if (src.organHolder && src.organHolder.heart && src.organHolder.heart.robotic)
		src.organHolder.heart.broken = 1
		boutput(src, "<span style=\"color:red\"><B>Your cyberheart malfunctions and shuts down!</B></span>")
		src.contract_disease(/datum/ailment/disease/flatline,null,null,1)

	var/list/L = src.get_all_items_on_mob()
	if (L && L.len)
		for (var/obj/O in L)
			O.emp_act()
	boutput(src, "<span style=\"color:red\"><B>BZZZT</B></span>")

/mob/living/carbon/human/verb/consume(mob/M as mob in oview(0))
	set hidden = 1
	var/mob/living/carbon/human/H = M
	if (!istype(H))
		return

	if (!H.stat)
		boutput(usr, "You can't eat [H] while they are conscious!")
		return

	if (H.bioHolder.HasEffect("consumed"))
		boutput(usr, "There's nothing left to consume!")
		return

	if(src.emote_check(1, 50, 0))	//spam prevention
		usr.visible_message("<span style=\"color:red\">[usr] starts [pick("taking bites out of","chomping","chewing","biting","eating","gnawing")] [H]. [pick("What a [pick("psychopath","freak","weirdo","lunatic","creep","rude dude","nutter","jerk","nerd")]!","Holy shit!","What the [pick("hell","fuck","christ","shit","heck")]?","Oh [pick("no","dear","god")]!")]</span>")

		var/loc = usr.loc

		spawn(50)
			if (usr.loc != loc || H.loc != loc)
				boutput(usr, "<span style=\"color:red\">Your consumption of [H] was interrupted!</span>")
				return

			usr.visible_message("<span style=\"color:red\">[usr] finishes [pick("taking bites out of","chomping","chewing","biting","eating","gnawing")] [H]. That was [pick("gross","horrific","disturbing","weird","horrible","funny","strange","odd","creepy","bloody","gory","shameful","awkward","unusual")]!</span>")

			if (prob(10) && !H.mutantrace)
				usr.reagents.add_reagent("prions", 10)
				spawn(rand(20,50)) boutput(usr, "<span style=\"color:red\">You don't feel so good.</span>")

			H.TakeDamage("chest", rand(30,50), 0, 0, DAMAGE_STAB)
			if (H.stat != 2 && prob(50))
				H.emote("scream")
			H.bioHolder.AddEffect("consumed")
			take_bleeding_damage(H, null, rand(15,30), DAMAGE_STAB)
	else
		src.show_text("You're not done eating the last piece yet.", "red")

/mob/living/carbon/human/verb/numbers()
	set name = "7848(2)9(1)"
	set hidden = 1

	boutput(src, "<span style=\"color:red\">You have no idea what to do with that.</span>")
	boutput(src, "<span style=\"color:red\">This statement is universally true because if you did you probably wouldn't be desperate enough to see this message.</span>")

/mob/living/carbon/human/full_heal()
	blinded = 0
	bleeding = 0
	blood_volume = 500

	if (!src.limbs)
		src.limbs = new /datum/human_limbs(src)
	src.limbs.mend()
	if (!src.organHolder)
		src.organHolder = new(src)
	src.organHolder.create_organs()

	if (src.get_stamina() != (STAMINA_MAX + src.get_stam_mod_max()))
		src.set_stamina(STAMINA_MAX + src.get_stam_mod_max())

	..()

	if (src.bioHolder)
		bioHolder.RemoveAllEffects(effectTypeDisability)
	if (implant)
		for (var/obj/item/implant/I in implant)
			if (istype(I, /obj/item/implant/projectile))
				boutput(src, "[I] falls out of you!")
				I.on_remove(src)
				implant.Remove(I)
				//del(I)
				I.set_loc(get_turf(src))
				continue

	update_body()
	update_face()
	return

/mob/living/carbon/human/get_equipped_ore_scoop()
	if (istype(src.l_hand,/obj/item/ore_scoop))
		return src.l_hand
	else if (istype(src.r_hand,/obj/item/ore_scoop))
		return src.r_hand
	else
		return null

/mob/living/carbon/human/infected(var/datum/pathogen/P)
	if (src.stat == 2)
		return
	if (ischangeling(src) || isvampire(src)) // Vampires were missing here. They're immune to old-style diseases too (Convair880).
		return 0
	if (P.pathogen_uid in src.immunities)
		return 0
	if (!(P.pathogen_uid in src.pathogens))
		var/datum/pathogen/Q = unpool(/datum/pathogen)
		Q.setup(0, P, 1)
		pathogen_controller.mob_infected(Q, src)
		src.pathogens += Q.pathogen_uid
		src.pathogens[Q.pathogen_uid] = Q
		Q.infected = src
		logTheThing("pathology", src, null, "is infected by [Q].")
		return 1
	else
		var/datum/pathogen/C = src.pathogens[P.pathogen_uid]
		if (C.generation < P.generation)
			var/datum/pathogen/Q = unpool(/datum/pathogen)
			Q.setup(0, P, 1)
			logTheThing("pathology", src, null, "'s pathogen mutation [C] is replaced by mutation [Q] due to a higher generation number.")
			pathogen_controller.mob_infected(Q, src)
			Q.stage = min(C.stage, Q.stages)
			pool(C)
			src.pathogens[Q.pathogen_uid] = Q
			Q.infected = src
			return 1
	return 0

/mob/living/carbon/human/cured(var/datum/pathogen/P)
	if (P.pathogen_uid in src.pathogens)
		pathogen_controller.mob_cured(src.pathogens[P.pathogen_uid], src)
		var/datum/pathogen/Q = src.pathogens[P.pathogen_uid]
		var/pname = Q.name
		src.pathogens -= P.pathogen_uid
		var/datum/microbody/M = P.body_type
		if (M.auto_immunize)
			immunity(P)
		pool(Q)
		logTheThing("pathology", src, null, "is cured of [pname].")

/mob/living/carbon/human/remission(var/datum/pathogen/P)
	if (src.stat == 2)
		return
	if (P.pathogen_uid in src.pathogens)
		var/datum/pathogen/Q = src.pathogens[P.pathogen_uid]
		Q.remission()
		logTheThing("pathology", src, null, "'s pathogen [Q] enters remission.")

/mob/living/carbon/human/immunity(var/datum/pathogen/P)
	if (src.stat == 2)
		return
	if (!(P.pathogen_uid in src.immunities))
		src.immunities += P.pathogen_uid
		logTheThing("pathology", src, null, "gains immunity to pathogen [P].")

/mob/living/carbon/human/shock(var/atom/origin, var/wattage, var/zone = "chest", var/stun_multiplier = 1, var/ignore_gloves = 0)
	if (!wattage)
		return 0
	var/prot = 1
	var/obj/item/clothing/gloves/G = src.gloves
	if (G && !ignore_gloves)
		prot = G.siemens_coefficient
	if (prot == 0)
		return 0

	var/shock_damage = 0
	if (wattage > 7500)
		shock_damage = (max(rand(10,20), round(wattage * 0.00004)))*prot
	else if (wattage > 5000)
		shock_damage = 15 * prot
	else if (wattage > 2500)
		shock_damage = 5 * prot
	else
		shock_damage = 1 * prot

	for (var/uid in src.pathogens)
		var/datum/pathogen/P = src.pathogens[uid]
		shock_damage = P.onshocked(shock_damage, wattage)
		if (!shock_damage)
			return 0

	if (src.bioHolder.HasEffect("resist_electric") == 2)
		var/healing = 0
		healing = shock_damage / 3
		src.HealDamage("All", healing, healing)
		src.take_toxin_damage(0 - healing)
		boutput(src, "<span style=\"color:blue\">You absorb the electrical shock, healing your body!</span>")
		return 0
	else if (src.bioHolder.HasEffect("resist_electric") == 1)
		boutput(src, "<span style=\"color:blue\">You feel electricity course through you harmlessly!</span>")
		return 0

	switch(shock_damage)
		if (0 to 25)
			playsound(src.loc, "sound/effects/electric_shock.ogg", 50, 1)
		if (26 to 59)
			playsound(src.loc, "sound/effects/elec_bzzz.ogg", 50, 1)
		if (60 to 99)
			playsound(src.loc, "sound/effects/elec_bigzap.ogg", 50, 1)  // begin the fun arcflash
			boutput(src, "<span style=\"color:red\"><b>[origin] discharges a violent arc of electricity!</b></span>")
			src.apply_flash(60, 0, 10)
			if (istype(src, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = src
				H.cust_one_state = pick("xcom","bart","zapped")
				H.set_face_icon_dirty()
		if (100 to INFINITY)  // cogwerks - here are the big fuckin murderflashes
			playsound(src.loc, "sound/effects/elec_bigzap.ogg", 50, 1)
			playsound(src.loc, "explosion", 50, 1)
			src.flash(60)
			if (istype(src, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = src
				H.cust_one_state = pick("xcom","bart","zapped")
				H.set_face_icon_dirty()

			var/turf/T = get_turf(src)
			if (T)
				T.hotspot_expose(5000,125)
				explosion(origin, T, -1,-1,1,2)
			if (istype(src, /mob/living/carbon/human))
				if (prob(20))
					boutput(src, "<span style=\"color:red\"><b>[origin] vaporizes you with a lethal arc of electricity!</b></span>")
					if (src.shoes)
						src.drop_from_slot(src.shoes)
					new /obj/decal/cleanable/ash(src.loc)
					spawn(1)
						src.elecgib()
				else
					boutput(src, "<span style=\"color:red\"><b>[origin] blasts you with an arc flash!</b></span>")
					if (src.shoes)
						src.drop_from_slot(src.shoes)
					var/atom/targetTurf = get_edge_target_turf(src, get_dir(src, get_step_away(src, origin)))
					src.throw_at(targetTurf, 200, 4)
	shock_cyberheart(shock_damage)
	TakeDamage(zone, 0, shock_damage, 0, DAMAGE_BURN)
	src.updatehealth()
	boutput(src, "<span style=\"color:red\"><B>You feel a [wattage > 7500 ? "powerful" : "slight"] shock course through your body!</B></span>")
	src.unlock_medal("HIGH VOLTAGE", 1)
	src.Virus_ShockCure(min(wattage / 500, 100))
	sleep(1)
	if (src.stunned < 12)
		src.stunned = min((shock_damage/5), 12) * stun_multiplier
	if (src.weakened < 8)
		src.weakened = min((shock_damage/6), 8) * prot * stun_multiplier

	return shock_damage

/mob/living/carbon/human/emag_act(mob/user, obj/item/card/emag/E)

	if (prob(1)) //Magnet healing!
		src.HealDamage("All", 3, 3)
		src.show_text("The electromagnetic field seems to make your joints feel less stiff! Maybe...", "blue")
		if (user) user.show_text("You pass \the [E] over [src]'s body, thinking positive thoughts. They look a little better. <BR><B>You have the gift!</B>", "blue")
		return 1
	else
		if (user && user != src && E)
			user.show_text("You poke [src] with \the [E].", "red")
			src.show_text("<B>[user]</B> pokes you with \an [E]. [prob(25)?"What a weirdo.":null]", "red")
		else if (user)
			if (!emagged)
				emagged = 1
				user.show_text("You poke yourself with \the [E]! [pick_string("descriptors.txt","emag_self")]", "red")
			else
				user.show_text("You poke yourself with \the [E]! It does nothing. What did you expect?","red")
	return 0

/mob/living/carbon/human/proc/resist()
	if (src.last_resist > world.time)
		if(src.burning) src.dir = pick(NORTH, SOUTH, EAST, WEST)
		return
	src.last_resist = world.time + 20
	if (!src.stat && src.lying)
		if (src.burning)
			src.last_resist = world.time + 25
			for (var/mob/O in AIviewers(src))
				O.show_message("<span style=\"color:red\"><B>[src] rolls around on the floor, trying to extinguish the flames.</B></span>", 1)

			src.unlock_medal("Through the fire and flames", 1)
			src.dir = pick(NORTH, SOUTH, EAST, WEST)
			if(src.traitHolder && src.traitHolder.hasTrait("burning")) src.update_burning(-8)
			else src.update_burning(-4)

	// Added this here (Convair880).
	if (!src.stat && !src.restrained() && (src.shoes && src.shoes.chained))
		if (ishuman(src))
			var/obj/item/clothing/shoes/SH = src.shoes
			if (ischangeling(src))
				src.u_equip(SH)
				SH.set_loc(get_turf(src))
				src.update_clothing()
				src.show_text("You briefly shrink your legs to remove the shackles.", "blue")
			else if (src.bioHolder.HasEffect("hulk") || ispredator(src) || iswerewolf(src))
				src.visible_message("<span style=\"color:red\">[src] rips apart the shackles with pure brute strength!</b></span>", "<span style=\"color:blue\">You rip apart the shackles.</span>")
				var/obj/item/clothing/shoes/NEW = new SH.type
				// Fallback if type is chained by default. Don't think we can check without spawning a pair first.
				if (NEW.chained)
					qdel(NEW)
					NEW = new /obj/item/clothing/shoes/brown
				src.u_equip(SH)
				src.equip_if_possible(NEW, slot_shoes)
				src.update_clothing()
				qdel(SH)
			else if (src.limbs && (istype(src.limbs.l_leg, /obj/item/parts/robot_parts) && !istype(src.limbs.l_leg, /obj/item/parts/robot_parts/leg/left/light)) && (istype(src.limbs.r_leg, /obj/item/parts/robot_parts) && !istype(src.limbs.r_leg, /obj/item/parts/robot_parts/leg/right/light))) // Light cyborg legs don't count.
				src.visible_message("<span style=\"color:red\">[src] rips apart the shackles with pure machine-like strength!</b></span>", "<span style=\"color:blue\">You rip apart the shackles.</span>")
				var/obj/item/clothing/shoes/NEW2 = new SH.type
				if (NEW2.chained)
					qdel(NEW2)
					NEW2 = new /obj/item/clothing/shoes/brown
				src.u_equip(SH)
				src.equip_if_possible(NEW2, slot_shoes)
				src.update_clothing()
				qdel(SH)
			else
				src.last_resist = world.time + 100
				var/time = 450
				src.show_text("You attempt to remove your shackles. (This will take around [round(time / 10)] seconds and you need to stand still.)", "red")
				actions.start(new/datum/action/bar/private/icon/shackles_removal(time), src)

	if (!src.stat && src.canmove && !src.restrained())
		for (var/obj/item/grab/G in src.grabbed_by)
			if (G.state == 0)
				qdel(G)
			else
				if (G.state == 1)
					if (prob(25))
						for (var/mob/O in AIviewers(src, null))
							O.show_message(text("<span style=\"color:red\">[] has broken free of []'s grip!</span>", src, G.assailant), 1)
						qdel(G)
				else
					if (G.state == 2)
						if (prob(5))
							for (var/mob/O in AIviewers(src, null))
								O.show_message(text("<span style=\"color:red\">[] has broken free of []'s headlock!</span>", src, G.assailant), 1)
							qdel(G)
		for (var/mob/O in AIviewers(src, null))
			O.show_message(text("<span style=\"color:red\"><B>[] resists!</B></span>", src), 1)

	if (src.handcuffed)
		if (ishuman(src))
			if (src.is_changeling())
				boutput(src, "<span style=\"color:blue\">You briefly shrink your hands to remove your handcuffs.</span>")
				src.handcuffed:set_loc(src.loc)
				src.handcuffed.unequipped(src)
				src.handcuffed = null
				src.update_clothing()
				return
			if (ispredator(src) || iswerewolf(src))
				for (var/mob/O in AIviewers(src))
					O.show_message(text("<span style=\"color:red\"><B>[] rips apart the handcuffs with pure brute strength!</B></span>", src), 1)
				boutput(src, "<span style=\"color:blue\">You rip apart your handcuffs.</span>")

				if (src.handcuffed:material) //This is a bit hacky.
					src.handcuffed:material:triggerOnAttacked(src.handcuffed, src, src, src.handcuffed)

				qdel(src.handcuffed)
				src.handcuffed = null
				src.update_clothing()
				return
		if (src.bioHolder.HasEffect("hulk"))
			for (var/mob/O in AIviewers(src))
				O.show_message(text("<span style=\"color:red\"><B>[] rips apart the handcuffs with pure brute strength!</B></span>", src), 1)
			boutput(src, "<span style=\"color:blue\">You rip apart your handcuffs.</span>")

			if (src.handcuffed:material) //This is a bit hacky.
				src.handcuffed:material:triggerOnAttacked(src.handcuffed, src, src, src.handcuffed)
				qdel(src.handcuffed)
			src.handcuffed = null
			src.update_clothing()
		else if ( src.limbs && (istype(src.limbs.l_arm, /obj/item/parts/robot_parts) && !istype(src.limbs.l_arm, /obj/item/parts/robot_parts/arm/left/light)) && (istype(src.limbs.r_arm, /obj/item/parts/robot_parts) && !istype(src.limbs.r_arm, /obj/item/parts/robot_parts/arm/right/light))) //Gotta be two standard borg arms
			for (var/mob/O in AIviewers(src))
				O.show_message(text("<span style=\"color:red\"><B>[] rips apart the handcuffs with machine-like strength!</B></span>", src), 1)
			boutput(src, "<span style=\"color:blue\">You rip apart your handcuffs.</span>")

			if (src.handcuffed:material) //This is a bit hacky.
				src.handcuffed:material:triggerOnAttacked(src.handcuffed, src, src, src.handcuffed)

			qdel(src.handcuffed)
			src.handcuffed = null
			src.update_clothing()
		else
			src.last_resist = world.time + 100
			var/calcTime = src.handcuffed.material ? max((src.handcuffed.material.getProperty(PROP_HARDNESS) + src.handcuffed.material.getProperty(PROP_TOUGHNESS)) * 10, 200) : (src.canmove ? rand(400,500) : rand(600,750))
			boutput(src, "<span style=\"color:red\">You attempt to remove your handcuffs. (This will take around [round(calcTime / 10)] seconds and you need to stand still)</span>")
			if (src.handcuffed:material) //This is a bit hacky.
				src.handcuffed:material:triggerOnAttacked(src.handcuffed, src, src, src.handcuffed)
			actions.start(new/datum/action/bar/private/icon/handcuffRemoval(calcTime), src)

	return 0

/mob/living/carbon/human/proc/spidergib()
	if (istype(src, /mob/dead))
		var/list/virus = src.ailments
		gibs(src.loc, virus)
		return
#ifdef DATALOGGER
	game_stats.Increment("violence")
#endif

	src.death(1)
	var/atom/movable/overlay/animation = null
	src.transforming = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 101

	if (ishuman(src))
		animation = new(src.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("spidergib", animation)
		src.visible_message("<span style=\"color:red\"><font size=4><B>A swarm of spiders erupts from [src]'s mouth and devours them! OH GOD!</B></font></span>", "<span style=\"color:red\"><font size=4><B>A swarm of spiders erupts from your mouth! OH GOD!</B></font></span>", "<span style=\"color:red\">You hear a vile chittering sound.</span>")
		playsound(src.loc, 'sound/effects/blobattack.ogg', 100, 1)
		spawn(10)
			new /obj/decal/cleanable/vomit/spiders(src.loc)
			for (var/I = 0, I < 4, I++)
				new /obj/critter/spider/baby(src.loc)



	if (src.mind || src.client)
		ghostize()

	spawn(15)
		qdel(src)

/mob/living/carbon/human/get_equipped_items()
	. = ..()
	if (src.belt) . += src.belt
	if (src.glasses) . += src.glasses
	if (src.gloves) . += src.gloves
	if (src.head) . += src.head
	if (src.shoes) . += src.shoes
	if (src.wear_id) . += src.wear_id
	if (src.wear_suit) . += src.wear_suit
	if (src.w_uniform) . += src.w_uniform

/mob/living/carbon/human/protected_from_space()
	var/space_suit = 0
	if (wear_suit && (wear_suit.c_flags & SPACEWEAR))
		space_suit++
	if (w_uniform && (w_uniform.c_flags & SPACEWEAR))
		space_suit++
	if (head && (head.c_flags & SPACEWEAR))
		space_suit++
	//if (wear_mask && (wear_mask.c_flags & SPACEWEAR))
		//space_suit++

	if (space_suit >= 2)
		return 1
	else
		return 0

/mob/living/carbon/human/list_ejectables()
	var/list/ret = list()
	var/list/processed = list()
	if (limbs)
		if (limbs.l_arm && prob(75) && limbs.l_arm.loc == src)
			ret += limbs.l_arm
			processed += limbs.l_arm
		if (limbs.r_arm && prob(75) && limbs.r_arm.loc == src)
			ret += limbs.r_arm
			processed += limbs.r_arm
		if (limbs.l_leg && prob(75) && limbs.l_leg.loc == src)
			ret += limbs.l_leg
			processed += limbs.l_leg
		if (limbs.r_leg && prob(75) && limbs.r_leg.loc == src)
			ret += limbs.r_leg
			processed += limbs.r_leg
	if (src.organHolder)
		if (organHolder.chest)
			processed += organHolder.chest
		if (organHolder.heart)
			processed += organHolder.heart
			if (prob(50) && organHolder.heart.loc == src)
				ret += organHolder.heart
		if (organHolder.skull)
			processed += organHolder.skull
		if (organHolder.brain)
			processed += organHolder.brain
		if (organHolder.head)
			processed += organHolder.head
		if (prob(40))
			if (prob(15) && organHolder.head && organHolder.head.loc == src)
				ret += organHolder.drop_organ("head", src)
			else
				if (organHolder.skull && organHolder.skull.loc == src)
					ret += organHolder.skull
				if (prob(15) && organHolder.brain && organHolder.brain.loc == src)
					ret += organHolder.brain
		if (organHolder.left_eye)
			processed += organHolder.left_eye
			if (prob(25) && organHolder.left_eye.loc == src)
				ret += organHolder.left_eye
		if (organHolder.right_eye)
			processed += organHolder.right_eye
			if (prob(25) && organHolder.right_eye.loc == src)
				ret += organHolder.right_eye
		if (organHolder.left_lung)
			processed += organHolder.left_lung
			if (prob(25) && organHolder.left_lung.loc == src)
				ret += organHolder.left_lung
		if (organHolder.right_lung)
			processed += organHolder.right_lung
			if (prob(25) && organHolder.right_lung.loc == src)
				ret += organHolder.right_lung
		if (prob(50))
			var/obj/item/clothing/head/wig/W = create_wig()
			if (W)
				processed += W
				ret += W
		if (organHolder.butt)
			processed += organHolder.butt
			if (prob(50) && organHolder.butt.loc == src)
				ret += organHolder.butt

	for (var/atom/movable/A in contents)
		if (A in processed)
			continue
		if (istype(A, /obj/screen)) // maybe people will stop gibbing out their stamina bars now  :|
			continue
		if (prob(dump_contents_chance))
			ret += A
	return ret

/mob/living/carbon/human/proc/create_wig()
	if (!src.bioHolder || !src.bioHolder.mobAppearance)
		return null
	var/obj/item/clothing/head/wig/W = new(src)
	W.name = "[real_name]'s hair"
/* commenting this out and making it an overlay to fix issues with colors stacking
	W.icon = 'icons/mob/human_hair.dmi'
	W.icon_state = cust_one_state
	W.color = src.bioHolder.mobAppearance.customization_first_color
	W.wear_image_icon = 'icons/mob/human_hair.dmi'
	W.wear_image = image(W.wear_image_icon, W.icon_state)
	W.wear_image.color = src.bioHolder.mobAppearance.customization_first_color*/

	if (src.bioHolder.mobAppearance.customization_first != "None")
		var/image/h_image = image('icons/mob/human_hair.dmi', cust_one_state)
		h_image.color = src.bioHolder.mobAppearance.customization_first_color
		W.overlays += h_image
		W.wear_image.overlays += h_image

	if (src.bioHolder.mobAppearance.customization_second != "None")
		var/image/f_image = image('icons/mob/human_hair.dmi', cust_two_state)
		f_image.color = src.bioHolder.mobAppearance.customization_second_color
		W.overlays += f_image
		W.wear_image.overlays += f_image

	if (src.bioHolder.mobAppearance.customization_third != "None")
		var/image/d_image = image('icons/mob/human_hair.dmi', cust_three_state)
		d_image.color = src.bioHolder.mobAppearance.customization_third_color
		W.overlays += d_image
		W.wear_image.overlays += d_image
	return W


/mob/living/carbon/human/set_eye()
	..()
	src.handle_regular_sight_updates()

/mob/living/carbon/human/heard_say(var/mob/other)
	if (!sims)
		return
	if (other != src)
		sims.affectMotive("social", 5)

/mob/living/carbon/human/proc/lose_limb(var/limb)
	if (!src.limbs)
		return
	if(!limb in list("l_arm","r_arm","l_leg","r_leg")) return

	//not exactly elegant, but fuck it, src.vars[limb].remove() didn't want to work :effort:
	if(limb == "l_arm" && src.limbs.l_arm) src.limbs.l_arm.remove()
	else if(limb == "r_arm" && src.limbs.r_arm) src.limbs.r_arm.remove()
	else if(limb == "l_leg" && src.limbs.l_leg) src.limbs.l_leg.remove()
	else if(limb == "r_leg" && src.limbs.r_leg) src.limbs.r_leg.remove()

/mob/living/carbon/human/proc/sever_limb(var/limb)
	if (!src.limbs)
		return
	if(!limb in list("l_arm","r_arm","l_leg","r_leg")) return

	//not exactly elegant, but fuck it, src.vars[limb].sever() didn't want to work :effort:
	if(limb == "l_arm" && src.limbs.l_arm) src.limbs.l_arm.sever()
	else if(limb == "r_arm" && src.limbs.r_arm) src.limbs.r_arm.sever()
	else if(limb == "l_leg" && src.limbs.l_leg) src.limbs.l_leg.sever()
	else if(limb == "r_leg" && src.limbs.r_leg) src.limbs.r_leg.sever()

/mob/living/carbon/human/proc/has_limb(var/limb)
	if (!src.limbs)
		return
	if(!limb in list("l_arm","r_arm","l_leg","r_leg")) return

	if(limb == "l_arm" && src.limbs.l_arm) return 1
	else if(limb == "r_arm" && src.limbs.r_arm) return 1
	else if(limb == "l_leg" && src.limbs.l_leg) return 1
	else if(limb == "r_leg" && src.limbs.r_leg) return 1

/mob/living/carbon/human/hand_attack(atom/target)
	if (mutantrace && mutantrace.override_attack)
		mutantrace.custom_attack(target)
	else
		var/obj/item/parts/arm = null
		if (limbs) //Wire: fix for null.r_arm and null.l_arm
			arm = hand ? limbs.l_arm : limbs.r_arm // I'm so sorry I couldent kill all this shitcode at once
		if (arm)
			arm.limb_data.attack_hand(target, src, can_reach(src, target))

/mob/living/carbon/human/proc/was_harmed(var/mob/M as mob, var/obj/item/weapon as obj)
	return

/mob/living/carbon/human/attack_hand(mob/M)
	..()
	if (M.a_intent in list(INTENT_HARM,INTENT_DISARM,INTENT_GRAB))
		src.was_harmed(M)

/mob/living/carbon/human/attackby(obj/item/W, mob/M)
	var/tmp/oldbloss = get_brute_damage()
	var/tmp/oldfloss = get_burn_damage()
	..()
	var/tmp/newbloss = get_brute_damage()
	var/tmp/damage = ((newbloss - oldbloss) + (get_burn_damage() - oldfloss))
	if (reagents)
		reagents.physical_shock((newbloss - oldbloss) * 0.15)
	if ((damage > 0) || W.force)
		src.was_harmed(M, W)

/mob/living/carbon/human/understands_language(var/langname)
	if (mutantrace)
		if ((langname == "" || langname == "english") && !mutantrace.override_language)
			. = 1
		else if (mutantrace.override_language == langname)
			. = 1
		else if (langname in mutantrace.understood_languages)
			. = 1
		else
			. = 0
	else
		. = ..()
	if ((langname == "silicon" || langname == "binary") && (locate(/obj/item/implant/robotalk) in implant || src.traitHolder.hasTrait("roboears")))
		return 1
	return .

/mob/living/carbon/human/get_special_language(var/secure_mode)
	if (secure_mode == "s" && (locate(/obj/item/implant/robotalk) in implant || src.traitHolder.hasTrait("roboears")))
		return "silicon"
	return null

/mob/living/carbon/human/HealBleeding(var/amt)
	bleeding = max(bleeding - amt, 0)

/mob/living/carbon/human/proc/juggling()
	if (islist(src.juggling) && src.juggling.len)
		return 1
	return 0

/mob/living/carbon/human/proc/drop_juggle()
	if (!src.juggling())
		return
	src.visible_message("<span style=\"color:red\"><b>[src]</b> drops everything they were juggling!</span>")
	for (var/obj/O in src.juggling)
		O.set_loc(src.loc)
		O.layer = initial(O.layer)
		if (prob(25))
			O.throw_at(get_step(src, pick(alldirs)), 1, 1)
		src.juggling -= O
	src.drop_from_slot(src.r_hand)
	src.drop_from_slot(src.l_hand)
	src.update_body()
	logTheThing("combat", src, null, "drops the items they were juggling")

/mob/living/carbon/human/proc/add_juggle(var/obj/thing as obj)
	if (!thing || src.stat)
		return
	if (istype(thing, /obj/item/grab))
		return
	src.u_equip(thing)
	if (thing.loc != src)
		thing.set_loc(src)
	if (src.juggling())
		var/items = ""
		var/count = 0
		for (var/obj/O in src.juggling)
			count ++
			if (src.juggling.len > 1 && count == src.juggling.len)
				items += " and [O]"
				continue
			items += ", [O]"
		items = copytext(items, 3)
		src.visible_message("<b>[src]</b> adds [thing] to the [items] [he_or_she(src)]'s already juggling!")
	else
		src.visible_message("<b>[src]</b> starts juggling [thing]!")
	src.juggling += thing
	if (isitem(thing))
		var/obj/item/i = thing
		i.on_spin_emote(src)
	src.update_body()
	logTheThing("combat", src, null, "juggles [thing]")

/mob/living/carbon/human/does_it_metabolize()
	return 1

/mob/living/carbon/human/canRideMailchutes()
	if (ismonkey(src)) // Why not, I guess?
		return 1
	else if (src.w_uniform && istype(src.w_uniform, /obj/item/clothing/under/misc/mail/syndicate))
		return 1
	else
		return 0

/mob/living/carbon/human/choose_name(var/retries = 3, var/what_you_are = null, var/default_name = null)
	var/newname
	for (retries, retries > 0, retries--)
		newname = input(src, "[what_you_are ? "You are \a [what_you_are]. " : null]Would you like to change your name to something else?", "Name Change", default_name ? default_name : src.real_name) as null|text
		if (!newname)
			return
		else
			newname = strip_html(newname, 32, 1)
			if (!length(newname) || copytext(newname,1,2) == " ")
				src.show_text("That name was too short after removing bad characters from it. Please choose a different name.", "red")
				continue
			else
				if (alert(src, "Use the name [newname]?", newname, "Yes", "No") == "Yes")
					var/datum/data/record/B = FindBankAccountByName(src.real_name)
					if (B && B.fields["name"])
						B.fields["name"] = newname

					if (istype(src.wear_id, /obj/item/card/id))
						var/obj/item/card/id/ID = src.wear_id
						ID.registered = newname
						ID.update_name()
					else if (istype(src.wear_id, /obj/item/device/pda2) && src.wear_id:ID_card)
						src.wear_id:registered = newname
						src.wear_id:ID_card:registered = newname
					for (var/obj/item/device/pda2/PDA in src.contents)
						PDA.owner = src.real_name
						PDA.name = "PDA-[src.real_name]"
					src.real_name = newname
					src.name = newname
					return 1
				else
					continue
	if (!newname)
		if (default_name)
			src.real_name = default_name
		else if (src.client && src.client.preferences && src.client.preferences.real_name)
			src.real_name = src.client.preferences.real_name
		else
			src.real_name = random_name(src.gender)
		src.name = src.real_name


/mob/living/carbon/human/set_mutantrace(var/mutantrace_type)

	//Clean up the old mutantrace
	if (src.organHolder && src.organHolder.head && src.organHolder.head.donor == src)
		src.organHolder.head.donor_mutantrace = null
	src.mutantrace = null

	if(ispath(mutantrace_type, /datum/mutantrace) )	//Set a new mutantrace only if passed one
		src.mutantrace = new mutantrace_type(src)
		. = 1

	if(.) //If the mutantrace was changed do all the usual icon updates
		if(src.organHolder && src.organHolder.head && src.organHolder.head.donor == src)
			src.organHolder.head.donor_mutantrace = src.mutantrace
			src.organHolder.head.update_icon()
		src.set_face_icon_dirty()
		src.set_body_icon_dirty()
		src.update_clothing()

/mob/living/carbon/human/verb/change_hud_style()
	set name = "Change HUD Style"
	set desc = "Selects what style HUD you would like to use."
	set category = "Commands"

	if (!src.hud) // uh?
		return src.show_text("<b>Somehow you have no HUD! Please alert a coder!</b>", "red")

	var/selection = input(usr, "What style HUD style would you like?", "Selection") as null|anything in hud_style_selection
	if (!selection)
		return

	src.force_hud_style(selection)

/mob/living/carbon/human/proc/force_hud_style(var/selection)
	if (!selection)
		return

	if (src.client && src.client.preferences) // there's bits and bobs that are created/destroyed that check prefs to see how they should look
		src.client.preferences.hud_style = selection

	var/icon/new_style = hud_style_selection[selection]

	src.hud.change_hud_style(new_style)

	if (src.zone_sel)
		src.zone_sel.change_hud_style(new_style)

	var/obj/item/R = src.find_type_in_hand(/obj/item/grab, "right") // same with grabs
	if (R)
		R.icon = new_style

	var/obj/item/L = src.find_type_in_hand(/obj/item/grab, "left") // same for the other hand
	if (L)
		L.icon = new_style

	if (src.sims) // saaaaame with sims motives
		src.sims.updateHudIcons(new_style)
	return