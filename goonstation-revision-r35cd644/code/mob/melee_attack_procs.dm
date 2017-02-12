// Contains:
// - Help procs
// - Grab procs
// - Disarm procs
// - Harm procs
// - Helper procs:
// -- attackResult datum [This is where the magic happens.]
// -- Targeting checks
// -- Calculate damage
// -- Target damage modifiers
// -- After attack

///////////////////////////////////////////////// Help intent //////////////////////////////////////////////

/mob/proc/do_help(var/mob/living/M)
	if (!istype(M))
		return
	if (M.health <= 0 && src.health >= -75.0)
		if (src == M && src.is_bleeding())
			src.staunch_bleeding(M) // if they've got SOMETHING to do let's not just harass them for trying to do CPR on themselves
		else
			src.administer_CPR(M)
	else if (src.is_bleeding())
		src.staunch_bleeding(M)
	else if (src.health > 0)
		src.shake_awake(M)

/mob/proc/shake_awake(var/mob/living/target)
	if (!src || !target)
		return 0

	if (istype(target,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = target
		if (H)
			H.add_fingerprint(src) // Just put 'em on the mob itself, like pulling does. Simplifies forensic analysis a bit (Convair880).

	target.asleep = 0
	target.sleeping = 0
	target.resting = 0

	target.paralysis = max(0,target.paralysis - 3)
	target.paralysis = max(0,target.stunned - 3)
	target.paralysis = max(0,target.weakened - 3)

	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	src.visible_message("<span style=\"color:blue\">[src] shakes [target], trying to wake them up!</span>")
	target.hit_twitch()

/mob/proc/administer_CPR(var/mob/living/carbon/human/target)
	boutput(src, "<span style=\"color:red\">You have no idea how to perform CPR.</span>")
	return

/mob/living/carbon/human/administer_CPR(var/mob/living/carbon/human/target)
	if (!src || !target)
		return 0

	if (src == target) // :I
		boutput(src, "<span style=\"color:red\">You desperately try to think of a way to do CPR on yourself, but it's just not logically possible!</span>")
		return

	if (target.head && (target.head.c_flags & 4))
		boutput(src, "<span style=\"color:blue\">You need to take off their headgear before you can give CPR!</span>")
		return

	if (target.wear_mask && !(target.wear_mask.c_flags & 32))
		boutput(src, "<span style=\"color:blue\">You need to take off their facemask before you can give CPR!</span>")
		return

	if (src.head && (src.head.c_flags & 4))
		boutput(src, "<span style=\"color:blue\">You need to take off your headgear before you can give CPR!</span>")
		return

	if (src.wear_mask && !(src.wear_mask.c_flags & 32))
		boutput(src, "<span style=\"color:blue\">You need to take off your facemask before you can give CPR!</span>")
		return

	if (target.cpr_time >= world.time + 3)
		return

	src.visible_message("<span style=\"color:red\"><B>[src] is trying to perform CPR on [target]!</B></span>")
	if (do_mob(src, target, 40))
		if (target.cpr_time >= world.time + 30)
			return
		if (target.health < 0)
			target.cpr_time = world.time
			target.take_oxygen_deprivation(-15)
			target.losebreath = 0
			target.paralysis--

			/*if(prob(50)) // this doesn't work yet
				for(var/datum/ailment/disability/D in src.target.ailments)
					if(istype(D,/datum/ailment/disease/heartfailure))
						src.target.resistances += D.type
						src.target.ailments -= D
						boutput(world, "<span style=\"color:red\">CURED [D] in [src.target]</span>")
					if(istype(D,/datum/ailment/disease/flatline))
						src.target.resistances += D.type
						src.target.ailments -= D
						boutput(world, "<span style=\"color:red\">CURED [D] in [src.target]</span>")*/

			src.updatehealth()

			if (src)
				src.visible_message("<span style=\"color:red\">[src] performs CPR on [target]!</span>")

///////////////////////////////////////////// Grab intent //////////////////////////////////////////////////////////

/mob/living/carbon/proc/grab_self()
	if (!src)
		return

	if(istype(src.wear_mask,/obj/item/clothing/mask/moustache))
		src.visible_message("<span style=\"color:red\"><B>[src] twirls [his_or_her(src)] moustache and laughs [pick_string("tweak_yo_self.txt", "moustache")]!</B></span>")
	else
		src.visible_message("<span style=\"color:red\"><B>[src] tweaks [his_or_her(src)] own nipples! That's [pick_string("tweak_yo_self.txt", "tweakadj")] [pick_string("tweak_yo_self.txt", "tweak")]!</B></span>")

/mob/living/proc/grab_other(var/mob/living/carbon/human/target, var/suppress_final_message = 0)
	if(!src || !target)
		return 0

	var/mob/living/carbon/human/H = src

	if (istype(H))
		if (H.sims)
			var/mult = H.sims.getMoodActionMultiplier()
			if (mult < 0.5)
				if (prob((0.5 - mult) * 200))
					boutput(src, pick("<span style=\"color:red\">You're not in the mood to grab that.</span>", "<span style=\"color:red\">You don't feel like doing that.</span>"))
					return

	logTheThing("combat", src, target, "grabs %target% at [log_loc(src)].")

	if (target)
		target.add_fingerprint(src) // Just put 'em on the mob itself, like pulling does. Simplifies forensic analysis a bit (Convair880).

	if (check_target_immunity(target) == 1)
		playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		target.visible_message("<span style=\"color:red\"><B>[src] tries to grab [target], but can't get a good grip!</B></span>")
		return

	if (istype(H))
		if(H.traitHolder && !H.traitHolder.hasTrait("glasscannon"))
			H.process_stamina(STAMINA_GRAB_COST)

		if (!target.stat && !target.weakened && !target.stunned && !target.paralysis && target.a_intent == "disarm" && target.stamina > STAMINA_DEFAULT_BLOCK_COST && prob(STAMINA_GRAB_BLOCK_CHANCE) && !target.equipped())
			src.visible_message("<span style=\"color:red\"><B>[target] blocks [src]'s attempt to grab [him_or_her(target)]!</span>")
			playsound(target.loc, 'sound/weapons/punchmiss.ogg', 25, 1, 1)

			target.remove_stamina(STAMINA_DEFAULT_BLOCK_COST)
			target.stamina_stun()
			return

	if (istype(H))
		for (var/uid in H.pathogens)
			var/datum/pathogen/P = H.pathogens[uid]
			P.ongrab(target)

	var/obj/item/grab/G = new /obj/item/grab(src)
	G.assailant = src
	src.put_in_hand(G, src.hand)
	G.affecting = target
	target.grabbed_by += G

	playsound(target.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if (suppress_final_message != 1) // Melee-focused roles (resp. their limb datums) grab the target aggressively (Convair880).
		target.visible_message("<span style=\"color:red\">[src] grabs hold of [target]!</span>")

///////////////////////////////////////////////////// Disarm intent ////////////////////////////////////////////////

/mob/proc/disarm(var/mob/living/target, var/extra_damage = 0, var/suppress_flags = 0, var/damtype = DAMAGE_BLUNT)
	if (!src || !ismob(src) || !target || !ismob(target))
		return

	if (!isnum(extra_damage))
		extra_damage = 0

	if (target.melee_attack_test(src, null, null, 1) != 1)
		return

	var/obj/item/affecting = target.get_affecting(src)
	var/datum/attackResults/disarm/msgs = calculate_disarm_attack(target, affecting, 0, 0, extra_damage)
	msgs.damage_type = damtype
	msgs.flush(suppress_flags)
	return

// I needed a harm intent-like attack datum for some limbs (Convair880).
/mob/proc/calculate_disarm_attack(var/mob/target, var/obj/item/affecting, var/base_damage_low = 0, var/base_damage_high = 0, var/extra_damage = 0)
	var/datum/attackResults/disarm/msgs = new(src)
	msgs.clear(target)
	msgs.valid = 1
	msgs.disarm = 1

	var/def_zone = null
	if (istype(affecting, /obj/item/organ))
		var/obj/item/organ/O = affecting
		def_zone = O.organ_name
		msgs.affecting = affecting
	else if (istype(affecting, /obj/item/parts))
		var/obj/item/parts/P = affecting
		def_zone = P.slot
		msgs.affecting = affecting
	else if (zone_sel)
		def_zone = zone_sel.selecting
		msgs.affecting = def_zone
	else
		def_zone = "All"
		msgs.affecting = def_zone

	var/damage = rand(base_damage_low, base_damage_high) * extra_damage
	var/mult = 1

	if (damage > 0)
		def_zone = target.check_target_zone(def_zone)

		var/armor_mod = 0
		if (def_zone == "head")
			armor_mod = target.get_head_armor_modifier()
		else if (def_zone == "chest")
			armor_mod = target.get_chest_armor_modifier()
		damage -= armor_mod
		msgs.stamina_target -= max((STAMINA_DISARM_COST * 2.5) - armor_mod, 0)

		var/attack_resistance = target.check_attack_resistance()
		if (attack_resistance)
			damage = 0
			if (istext(attack_resistance))
				msgs.show_message_target(attack_resistance)
		msgs.damage = max(damage, 0)

	if (ishuman(target))
		var/mob/living/carbon/human/HT = target

		if (ishuman(src))
			var/mob/living/carbon/human/H = src
			if (H.sims)
				mult = H.sims.getMoodActionMultiplier()

			var/stampart = round( ((STAMINA_MAX - HT.stamina) / 3) )
			if (prob((stampart + 10) * mult))
				for (var/uid in H.pathogens)
					var/datum/pathogen/P = H.pathogens[uid]
					var/ret = P.ondisarm(target, 1)
					if (!ret)
						msgs.base_attack_message = "<span style=\"color:red\"><B>[src] shoves [target]!</B></span>"
						return msgs
				msgs.base_attack_message = "<span style=\"color:red\"><B>[src] shoves [target] to the ground!</B></span>"
				msgs.played_sound = 'sound/weapons/thudswoosh.ogg'
				msgs.disarm_RNG_result = "shoved_down"
				return msgs

	var/obj/item/I = target.equipped()
	if (I)
		if (I.cant_other_remove)
			msgs.played_sound = 'sound/weapons/punchmiss.ogg'
			msgs.base_attack_message = "<span style=\"color:red\"><B>[src] vainly tries to knock [I] out of [target]'s hand!</B></span>"
			msgs.show_self.Add("<span style=\"color:red\">Something is binding [I] to [target]. You won't be able to disarm [him_or_her(target)].</span>")
			msgs.show_target.Add("<span style=\"color:red\">Something is binding [I] to you. It cannot be knocked out of your hands.</span>")

		else if (prob(30 * mult))
			if (ishuman(src))
				var/mob/living/carbon/human/H2 = src
				for (var/uid in H2.pathogens)
					var/datum/pathogen/P = H2.pathogens[uid]
					var/ret = P.ondisarm(target, 1)
					if (!ret)
						msgs.base_attack_message = "<span style=\"color:red\"><B>[src] tries to knock [I] out of [target]'s hand!</B></span>"
						return msgs
			msgs.base_attack_message = "<span style=\"color:red\"><B>[src] knocks [I] out of [target]'s hand!</B></span>"
			msgs.played_sound = 'sound/weapons/thudswoosh.ogg'
			msgs.disarm_RNG_result = "drop_item"
		else
			msgs.base_attack_message = "<span style=\"color:red\"><B>[src] tries to knock [I] out of [target]'s hand!</B></span>"
			msgs.played_sound = 'sound/weapons/punchmiss.ogg'
	else
		msgs.base_attack_message = "<span style=\"color:red\"><B>[src] shoves [target]!</B></span>"
		msgs.played_sound = 'sound/weapons/thudswoosh.ogg'

	return msgs

/mob/proc/check_block()
	if (!stat && !weakened && !stunned && !paralysis && a_intent == "disarm" && prob(STAMINA_BLOCK_CHANCE) && !equipped())
		return 1
	return 0

/mob/living/carbon/human/check_block()
	if (!stat && !weakened && !stunned && !paralysis && a_intent == "disarm" && stamina > STAMINA_DEFAULT_BLOCK_COST && prob(STAMINA_BLOCK_CHANCE) && !equipped())
		return 1
	return 0

/mob/proc/do_block(var/mob/attacker)
	if (check_block())
		visible_message("<span style=\"color:red\"><B>[src] blocks [attacker]'s attack!</span>")
		playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1, 1)

		remove_stamina(STAMINA_DEFAULT_BLOCK_COST)
		stamina_stun()
		return 1
	return 0

/////////////////////////////////////////////////// Harm intent ////////////////////////////////////////////////////////

/mob/living/carbon/human/proc/stun_glove_attack(var/mob/living/target)
	if (!src || !target || !src.gloves)
		return 0

	if (src.gloves.uses > 0)
		src.lastattacked = target
		target.lastattacker = src
		target.lastattackertime = world.time
		logTheThing("combat", src, target, "touches %target% with stun gloves at [log_loc(src)].")
		target.add_fingerprint(src) // Some as the other 'empty hand' melee attacks (Convair880).
		src.unlock_medal("High Five!", 1)

		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(5, 1, target.loc)
		s.start()

		src.gloves.uses = max(0, src.gloves.uses - 1)
		if (src.gloves.uses < 1)
			src.gloves.icon_state = "yellow"
			src.gloves.item_state = "ygloves"
			src.update_clothing() // Was missing (Convair880).

		if (src.gloves.uses <= 0)
			src.show_text("The gloves are no longer electrically charged.", "red")
		else
			src.show_text("The gloves have [src.gloves.uses]/[src.gloves.max_uses] charges left!", "red")

		target.visible_message("<span style=\"color:red\"><B>[src] touches [target] with the stun gloves!</B></span>")
		if (check_target_immunity(target) == 1)
			target.visible_message("<span style=\"color:red\"><B>...but it has no effect whatsoever!</B></span>")
			return

		target.weakened = max(target.weakened,3)
		target.stuttering = max(target.stuttering,5)
		target.stunned = max(target.stunned,3)

	else
		boutput(src, "<span style=\"color:red\">The stun gloves don't have enough charge!</span>")
		return

/mob/living/carbon/human/proc/melee_attack(var/mob/living/carbon/human/target)
	var/datum/limb/L = equipped_limb()
	if (!L)
		return
	L.harm(target, src) // Calls melee_attack_normal if limb datum doesn't override anything.

/mob/proc/melee_attack_normal(var/mob/living/carbon/human/target, var/extra_damage = 0, var/suppress_flags = 0, var/damtype = DAMAGE_BLUNT)
	if(!src || !target)
		return 0

	if(!isnum(extra_damage))
		extra_damage = 0

	if (!target.melee_attack_test(src))
		return

	var/obj/item/affecting = target.get_affecting(src)
	var/datum/attackResults/msgs = calculate_melee_attack(target, affecting, 2, 9, extra_damage)
	msgs.damage_type = damtype
	attack_effects(target, affecting)
	msgs.flush(suppress_flags)

/mob/proc/calculate_melee_attack(var/mob/target, var/obj/item/affecting, var/base_damage_low = 2, var/base_damage_high = 9, var/extra_damage = 0)
	var/datum/attackResults/msgs = new(src)
	msgs.clear(target)
	msgs.valid = 1

	var/def_zone = null
	if (istype(affecting, /obj/item/organ))
		var/obj/item/organ/O = affecting
		def_zone = O.organ_name
		msgs.affecting = affecting
	else if (istype(affecting, /obj/item/parts))
		var/obj/item/parts/P = affecting
		def_zone = P.slot
		msgs.affecting = affecting
	else if (zone_sel)
		def_zone = zone_sel.selecting
		msgs.affecting = def_zone
	else
		def_zone = "All"
		msgs.affecting = def_zone

	var/punchmult = get_base_damage_multiplier(def_zone)
	var/punchedmult = target.get_taken_base_damage_multiplier(src, def_zone)

	if (!punchedmult)
		if (narrator_mode)
			msgs.played_sound = 'sound/vox/hit.ogg'
		else
			msgs.played_sound = 'sound/weapons/punch1.ogg'
		msgs.visible_message_self("<span style=\"color:red\"><B>[src] [src.punchMessage] [target], but it does absolutely nothing!</B></span>")
		return

	if (!punchmult)
		msgs.played_sound = 'sound/effects/snap.ogg'
		msgs.visible_message_self("<span style=\"color:red\"><B>[src] hits [target] with a ridiculously feeble attack!</B></span>")
		return

	var/damage = rand(base_damage_low, base_damage_high) * punchedmult * punchmult + extra_damage + calculate_bonus_damage(msgs)

	if (!target.canmove && target.lying)
		msgs.played_sound = 'sound/weapons/genhit1.ogg'
		msgs.base_attack_message = "<span style=\"color:red\"><B>[src] [src.kickMessage] [target]!</B></span>"
		msgs.logs = list("[src.kickMessage] %target%")

		if(STAMINA_LOW_COST_KICK)
			msgs.stamina_self += STAMINA_HTH_COST / 3
	else
		msgs.base_attack_message = "<span style=\"color:red\"><B>[src] [src.punchMessage] [target]!</B></span>"
		msgs.played_sound = "punch"

		if (src != target && iswrestler(src) && prob(66))
			msgs.base_attack_message = "<span style=\"color:red\"><B>[src]</b> winds up and delivers a backfist to [target], sending them flying!</span>"
			damage += 4
			msgs.after_effects += /proc/wrestler_backfist

		def_zone = target.check_target_zone(def_zone)

		var/armor_mod = 0
		if (def_zone == "head")
			armor_mod = target.get_head_armor_modifier()
		else if (def_zone == "chest")
			armor_mod = target.get_chest_armor_modifier()
		damage -= armor_mod
		msgs.stamina_target -= max(STAMINA_HTH_DMG - armor_mod, 0)

		if (prob(STAMINA_CRIT_CHANCE))
			msgs.stamina_crit = 1
			msgs.played_sound = "sound/misc/critpunch.ogg"
			msgs.visible_message_target("<span style=\"color:red\"><B><I>... and lands a devastating hit!</B></I></span>")

	var/attack_resistance = target.check_attack_resistance()
	if (attack_resistance)
		damage = 0
		if (istext(attack_resistance))
			msgs.show_message_target(attack_resistance)
	msgs.damage = max(damage, 0)

	return msgs

// This is used by certain limb datums (werewolf, shambling abomination) (Convair880).
/proc/special_attack_silicon(var/mob/target, var/mob/living/user)
	if (!target || !issilicon(target) || !user || !isliving(user))
		return

	if (check_target_immunity(target) == 1)
		playsound(user.loc, "punch", 50, 1, 1)
		user.visible_message("<span style=\"color:red\"><B>[user]'s attack bounces off [target] uselessly!</B></span>")
		return

	var/damage = 0
	var/send_flying = 0 // 1: a little bit | 2: across the room

	if (isrobot(target))
		var/mob/living/silicon/robot/BORG = target
		if (!BORG.part_head)
			user.visible_message("<span style=\"color:red\"><B>[user] smashes [BORG.name] to pieces!</B></span>")
			playsound(user.loc, "sound/effects/wbreak.wav", 70, 1)
			BORG.gib()
		else
			if (BORG.part_head.ropart_get_damage_percentage() >= 85)
				user.visible_message("<span style=\"color:red\"><B>[user] grabs [BORG.name]'s head and wrenches it right off!</B></span>")
				playsound(user.loc, "sound/effects/wbreak.wav", 70, 1)
				BORG.compborg_lose_limb(BORG.part_head)
			else
				user.visible_message("<span style=\"color:red\"><B>[user] pounds on [BORG.name]'s head furiously!</B></span>")
				playsound(user.loc, "sound/effects/metal_bang.ogg", 50, 1)
				BORG.part_head.ropart_take_damage(rand(20,40),0)
				if (!BORG.anchored && prob(30))
					user.visible_message("<span style=\"color:red\"><B>...and sends them flying!</B></span>")
					send_flying = 2

	else if (isAI(target))
		user.visible_message("<span style=\"color:red\"><B>[user] [pick("wails", "pounds", "slams")] on [target]'s terminal furiously!</B></span>")
		playsound(user.loc, "sound/effects/metal_bang.ogg", 50, 1)
		damage = 10

	else
		user.visible_message("<span style=\"color:red\"><B>[user] smashes [target] furiously!</B></span>")
		playsound(user.loc, "sound/effects/metal_bang.ogg", 50, 1)
		damage = 10
		if (!target.anchored && prob(30))
			user.visible_message("<span style=\"color:red\"><B>...and sends them flying!</B></span>")
			send_flying = 2

	if (send_flying == 2)
		wrestler_backfist(user, target)
	else if (send_flying == 1)
		wrestler_knockdown(user, target)

	if (damage > 0)
		random_brute_damage(target, damage)
		target.updatehealth()
		target.UpdateDamageIcon()

	logTheThing("combat", user, target, "punches %target% at [log_loc(user)].")
	return

/////////////////////////////////////////////////////// attackResult datum ////////////////////////////////////////

/datum/attackResults
	var/mob/owner
	var/mob/target
	var/list/visible_self = list()
	var/list/visible_target = list()
	var/list/show_self = list()
	var/list/show_target = list()
	var/list/logs = list("punches %target%")
	var/list/after_effects = list()

	// the message to play to the target
	var/base_attack_message = null

	// a sound to play when this attack is flushed
	var/played_sound = null

	var/stamina_self = 0
	var/stamina_target = 0
	var/stamina_crit = 0
	var/damage = 0
	var/damage_type = DAMAGE_BLUNT
	var/obj/item/affecting = null
	var/valid = 0
	var/disarm = 0 // Is this a disarm as opposed to harm attack?
	var/disarm_RNG_result = null // Blocked, shoved down etc.

	New(var/mob/M)
		owner = M

	proc/clear(var/mob/M)
		target = M
		visible_self = list()
		visible_target = list()
		show_self = list()
		show_target = list()
		if (istype(src, /datum/attackResults/disarm))
			logs = list("disarms %target%")
		else
			logs = list("punches %target%")
		played_sound = null
		base_attack_message = null
		stamina_self = 0
		stamina_target = 0
		stamina_crit = 0
		damage = 0
		damage_type = DAMAGE_BLUNT
		affecting = null
		valid = 0
		disarm = 0
		disarm_RNG_result = null
		after_effects = list()

	proc/show_message_self(var/message)
		show_self += message

	proc/show_message_target(var/message)
		show_target += message

	proc/visible_message_self(var/message)
		visible_self += message

	proc/visible_message_target(var/message)
		visible_target += message

	proc/logc(var/message)
		logs += message

	// I worked disarm into this because I needed a more detailed disarm proc and didn't want to reinvent the wheel or repeat a bunch of code (Convair880).
	proc/flush(var/suppress = 0)
		if (!target)
			clear(null)
			logTheThing("debug", owner, null, "<b>Marquesas/Melee Attack Refactor:</b> NO TARGET FLUSH! EMERGENCY!")
			return

		if (!affecting)
			clear(null)
			logTheThing("debug", owner, null, "<b>Marquesas/Melee Attack Refactor:</b> NO AFFECTING FLUSH! WARNING!")
			return

		if (!(suppress & SUPPRESS_SOUND) && played_sound)
			playsound(owner.loc, played_sound, 50, 1, -1)

		if (!(suppress & SUPPRESS_BASE_MESSAGE) && base_attack_message)
			owner.visible_message(base_attack_message)

		if (!(suppress & SUPPRESS_SHOWN_MESSAGES))
			for (var/message in show_self)
				owner.show_message(message)

			for (var/message in visible_self)
				owner.visible_message(message)

		if (!(suppress & SUPPRESS_SHOWN_MESSAGES))
			for (var/message in visible_target)
				target.visible_message(message)

			for (var/message in show_target)
				target.show_message(message)

		if (!(suppress & SUPPRESS_LOGS))
			for (var/message in logs)
				logTheThing("combat", owner, target, "[message] at [log_loc(owner)].")

		if (stamina_self)
			if (stamina_self > 0)
				owner.add_stamina(stamina_self)
			else
				owner.remove_stamina(-stamina_self)

		if (src.disarm == 1)
			target.add_fingerprint(owner)

			if (owner.traitHolder && !owner.traitHolder.hasTrait("glasscannon"))
				owner.process_stamina(STAMINA_DISARM_COST)

			if (!isnull(src.disarm_RNG_result))
				switch (src.disarm_RNG_result)
					if ("drop_item")
						target.deliver_move_trigger("bump")
						target.drop_item()

					if ("shoved_down")
						target.deliver_move_trigger("pushdown")
						target.drop_item()
						target.weakened = 2
			else
				target.deliver_move_trigger("bump")

		else
			if (owner.traitHolder && !owner.traitHolder.hasTrait("glasscannon"))
				owner.process_stamina(STAMINA_HTH_COST)

#ifdef DATALOGGER
			game_stats.Increment("violence")
#endif
			owner.lastattacked = target
			target.lastattacker = owner
			target.lastattackertime = world.time
			target.add_fingerprint(owner)

		if (damage > 0 || src.disarm == 1)
			if (src.disarm == 1 && damage <= 0)
				goto process_stamina

			// important
			target.abuse_clown()

			if (damage_type == DAMAGE_BLUNT && prob(25 + (damage * 2)) && damage >= 8)
				damage_type = DAMAGE_CRUSH

			if (damage_type == DAMAGE_BURN)
				if (istype(affecting))
					affecting.take_damage(0, damage, 0, damage_type)
				else if (affecting)
					target.TakeDamage(affecting, 0, damage, 0, damage_type)
				else
					target.TakeDamage("chest", 0, damage, 0, damage_type)
			else
				if (istype(affecting))
					affecting.take_damage(damage, 0, 0, damage_type)
				else if (affecting)
					target.TakeDamage(affecting, damage, 0, 0, damage_type)
				else
					target.TakeDamage("chest", damage, 0, 0, damage_type)
				if (damage_type & (DAMAGE_CUT | DAMAGE_STAB))
					take_bleeding_damage(target, owner, damage, damage_type)
					target.spread_blood_clothes(target)
					owner.spread_blood_hands(target)
					if (prob(15))
						owner.spread_blood_clothes(target)

			for (var/P in after_effects)
				call(P)(owner, target)

			process_stamina
			if (stamina_target)
				if (stamina_target > 0)
					target.add_stamina(stamina_target)
				else
					var/prev_stam = target.get_stamina()
					target.remove_stamina(-stamina_target)
					target.stamina_stun()
					if(prev_stam > 0 && target.get_stamina() <= 0) //We were just knocked out.
						target.set_clothing_icon_dirty()
						target.lastgasp()
						if (istype(ticker.mode, /datum/game_mode/revolution))
							var/datum/game_mode/revolution/R = ticker.mode
							R.remove_revolutionary(target.mind)

			if (stamina_crit)
				target.handle_stamina_crit()

			if (src.disarm != 1)
				owner.attack_finished(target)
				target.attackby_finished(owner)
			target.UpdateDamageIcon()
			target.updatehealth()
		clear(null)

/datum/attackResults/disarm
	logs = list("disarms %target%")

////////////////////////////////////////////////////////// Targeting checks ////////////////////////////////////

/mob/proc/melee_attack_test(var/mob/attacker, var/obj/item/I, var/def_zone, var/disarm_check = 0)
	if (check_target_immunity(src) == 1)
		playsound(loc, "punch", 50, 1, 1)
		src.visible_message("<span style=\"color:red\"><B>[attacker]'s attack bounces off [src] uselessly!</B></span>")
		return 0

	if (disarm_check == 1 && (ishuman(src) && src.lying == 1))
		src.visible_message("<span style=\"color:red\"><B>[attacker]</B> makes a threatening gesture at [src]!</span>")
		return 0

	return 1

/mob/living/silicon/robot/melee_attack_test(var/mob/attacker, var/obj/item/I, var/def_zone, var/disarm_check = 0)
	if (!..())
		return 0

	if (I)
		var/hit_chance = 50
		if (def_zone == "chest")
			hit_chance = 90
		else if (def_zone == "head")
			hit_chance = 70
		if(!client || stat || paralysis || stunned || weakened)
			hit_chance = 100
		if (!prob(hit_chance))
			playsound(loc, "sound/weapons/punchmiss.ogg", 50, 1, 1)
			src.visible_message("<span style=\"color:red\"><b>[attacker] swings at [src] with [I], but misses!</b></span>")
			return 0

	return 1

/mob/living/carbon/human/melee_attack_test(var/mob/attacker, var/obj/item/I, var/def_zone, var/disarm_check = 0)
	if (!..())
		return 0

	if (src.do_block(attacker))
		return 0

	return 1

/mob/proc/get_affecting(mob/attacker, def_zone = null)
	if (def_zone)
		return def_zone
	var/t = pick("head", "chest")
	if(attacker.zone_sel)
		t = attacker.zone_sel.selecting
	return t

/mob/living/carbon/human/get_affecting(mob/attacker, def_zone = null)
	var/t = pick("head", "chest")
	if(def_zone)
		t = def_zone
	else if(attacker.zone_sel)
		t = attacker.zone_sel.selecting
	var/r_zone = ran_zone(t)
	var/obj/item/affecting = organs["chest"]

	if (organs[text("[]", r_zone)])
		affecting = organs[text("[]", r_zone)]
	return affecting

/mob/proc/check_target_zone(var/def_zone)
	return def_zone

/mob/living/carbon/human/check_target_zone(var/def_zone)
	if (limbs && !limbs.l_arm && def_zone == "l_arm")
		return "chest"
	if (limbs && !limbs.r_arm && def_zone == "r_arm")
		return "chest"
	return def_zone

////////////////////////////////////////////////////// Calculate damage //////////////////////////////////////////

/mob/proc/get_base_damage_multiplier()
	return 1

/mob/living/carbon/human/get_base_damage_multiplier(var/def_zone)
	var/punchmult = 1

	for (var/uid in src.pathogens)
		var/datum/pathogen/P = src.pathogens[uid]
		punchmult *= P.onpunch(target, def_zone)

	if (sims)
		punchmult *= sims.getMoodActionMultiplier()

	return punchmult

/mob/proc/get_taken_base_damage_multiplier()
	return 1

/mob/living/carbon/human/get_taken_base_damage_multiplier(var/mob/attacker, var/def_zone)
	var/punchedmult = 1

	for (var/uid in src.pathogens)
		var/datum/pathogen/P = src.pathogens[uid]
		punchedmult *= P.onpunched(attacker, def_zone)

	return punchedmult

/mob/proc/calculate_bonus_damage(var/datum/attackResults/msgs)
	return 0

/mob/living/carbon/human/calculate_bonus_damage(var/datum/attackResults/msgs)
	var/damage = 0
	if (src.gloves)
		damage += src.gloves.damage_bonus()

	if (src.reagents && (src.reagents.get_reagent_amount("ethanol") >= 100) && prob(40))
		damage += rand(3,5)
		if (msgs)
			msgs.show_message_self("<span style=\"color:red\">You drunkenly throw a brutal punch!</span>")

	if (src.bioHolder.HasEffect("hulk"))
		damage += 5

	return damage

/////////////////////////////////////////////////////// Target damage modifiers //////////////////////////////////

/mob/proc/check_attack_resistance(var/obj/item/I)
	return null

/mob/living/silicon/robot/check_attack_resistance(var/obj/item/I)
	if (!I)
		return "<span style=\"color:red\">Sensors indicate no damage from external impact.</span>"
	return null

/mob/living/carbon/human/check_attack_resistance(var/obj/item/I)
	if (reagents.get_reagent_amount("ethanol") >= 100 && prob(40) && (!I || I.force <= 15))
		return "<span style=\"color:red\">You drunkenly shrug off the blow!</span>"
	return null

/mob/proc/get_head_armor_modifier()
	return 0

/mob/living/carbon/human/get_head_armor_modifier()
	if (client && client.hellbanned)
		return 0
	if ((head && head.body_parts_covered & HEAD) || (wear_mask && wear_mask.body_parts_covered & HEAD))
		if (head && !wear_mask)
			return max(0, head.armor_value_melee)
		else if (!head && wear_mask)
			return max(0, wear_mask.armor_value_melee)
		else if (head && wear_mask)
			return max(0, max(head.armor_value_melee, wear_mask.armor_value_melee))
	return 0

/mob/proc/get_chest_armor_modifier()
	return 0

/mob/living/carbon/human/get_chest_armor_modifier()
	if (client && client.hellbanned)
		return 0
	if ((wear_suit && wear_suit.body_parts_covered & TORSO) || (w_uniform && w_uniform.body_parts_covered & TORSO))
		if (wear_suit && !w_uniform)
			return max(0, wear_suit.armor_value_melee)
		else if (!wear_suit && w_uniform)
			return max(0, w_uniform.armor_value_melee)
		else if (wear_suit && w_uniform)
			return max(0, max(w_uniform.armor_value_melee, wear_suit.armor_value_melee))
	return 0

/////////////////////////////////////////////////////////// After attack ////////////////////////////////////////////

/mob/proc/attack_effects(var/target, var/obj/item/affecting)
	return

/mob/living/carbon/human/attack_effects(var/mob/target, var/obj/item/affecting)
	if (src.bioHolder.HasEffect("hulk"))
		spawn(0)
			target.stunned += 1
			step_away(target,src,15)
			sleep(3)
			step_away(target,src,15)

	if (src.bioHolder.HasEffect("revenant"))
		var/datum/bioEffect/hidden/revenant/R = src.bioHolder.GetEffect("revenant")
		if (R.ghoulTouchActive)
			R.ghoulTouch(target, affecting)

/proc/wrestler_knockdown(var/mob/H, var/mob/T)
	if (!H || !ismob(H) || !T || !ismob(T))
		return

	T.weakened += rand(2,3)
	spawn(0)
		step_away(T, H, 15)

	return

/proc/wrestler_backfist(var/mob/H, var/mob/T)
	if (!H || !ismob(H) || !T || !ismob(T))
		return

	T.weakened += rand(5,6)
	var/turf/throwpoint = get_edge_target_turf(H, get_dir(H, T))
	if (throwpoint && isturf(throwpoint))
		spawn(0)
			T.throw_at(throwpoint, 10, 2)

	return

/mob/proc/attack_finished(var/mob/target)
	return

/mob/living/carbon/human/attack_finished(var/mob/target)
	if (sims)
		sims.affectMotive("fun", 5)

/mob/proc/attackby_finished(var/mob/attacker)
	return

/mob/living/carbon/human/attackby_finished(var/mob/attacker)
	if (sims)
		if (istype(gloves, /obj/item/clothing/gloves/boxing))
			sims.affectMotive("fun", 2.5)