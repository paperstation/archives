/datum/targetable/vampire/enthrall
	name = "Enthrall"
	desc = "Makes the target a loyal mindslave. Takes a long time to cast."
	targeted = 1
	target_nodamage_check = 1
	max_range = 1
	cooldown = 1800
	pointCost = 400
	when_stunned = 0
	not_when_handcuffed = 1
	restricted_area_check = 2
	unlock_message = "You have gained enthrall. It allows you to enslave humans and synthetics."

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner
		var/datum/abilityHolder/vampire/H = holder

		if (!M || !target || !ismob(target))
			return 1

		if (M == target)
			boutput(M, __red("Why would you want to enslave yourself?"))
			return 1

		if (get_dist(M, target) > src.max_range)
			boutput(M, __red("[target] is too far away."))
			return 1

		if (target.stat == 2)
			boutput(M, __red("[target] is dead!"))
			return 1

		if (!target.mind || !target.client)
			boutput(M, __red("[target] is braindead!"))
			return 1

		if (target.is_mentally_dominated_by(M))
			boutput(M, __red("[target] is already loyal to you."))
			return 1

		// Don't remove this unless you are willing to adjust all existing mindslave-related procs for this very rare and specific case.
		if (checktraitor(target))
			boutput(M, __red("[target] is not susceptible to being enthralled!"))
			return 1

		if (issilicon(target))
			var/mob/living/silicon/S = target
			if (!S.syndicate_possible)
				boutput(M, __red("[target] is not susceptible to being enthralled!"))
				return 1

		if (istype(H) && H.vamp_isbiting)
			boutput(M, __red("You are already biting someone!"))
			return 1

		actions.start(new/datum/action/bar/private/icon/vampire_enthrall(target, src), M)
		if (istype(H)) H.blood_tracking_output(src.pointCost)
		return 0

/datum/action/bar/private/icon/vampire_enthrall
	duration = 250
	interrupt_flags = INTERRUPT_MOVE | INTERRUPT_ACT | INTERRUPT_STUNNED | INTERRUPT_ACTION
	id = "vampire_enthrall"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "grabbed"
	var/mob/living/target
	var/datum/targetable/vampire/enthrall/enslave
	var/last_complete = 0

	New(Target, Enslave)
		target = Target
		enslave = Enslave
		..()

	onStart()
		..()

		var/mob/living/M = owner
		var/datum/abilityHolder/vampire/H = enslave.holder

		if (!enslave || get_dist(M, target) > enslave.max_range || target == null || M == null || target.stat == 2 || !target.mind || !target.client)
			interrupt(INTERRUPT_ALWAYS)
			return

		M.visible_message("<span style=\"color:red\"><B>[M] bites [target]!</B></span>")
		boutput(M, __blue("You begin to pump your polluted blood into [target]'s [issilicon(target) ? "serial port" : "neck"]."))
		if (issilicon(target))
			boutput(target, __red("New device found. Attempting plug & play configuration."))
		else
			boutput(target, __red("You feel a little cold all the sudden."))
		if (istype(H)) H.vamp_isbiting = target
		target.vamp_beingbitten = 1

	onUpdate()
		..()

		var/mob/living/M = owner

		if (!enslave || get_dist(M, target) > enslave.max_range || target == null || M == null || target.stat == 2 || !target.mind || !target.client)
			interrupt(INTERRUPT_ALWAYS)
			return

		if (target.bioHolder && target.bioHolder.HasEffect("training_chaplain"))
			boutput(M, __red("Wait, this is a chaplain!!! <B>AGDFHSKFGBLDFGLHSFDGHDFGH</B>"))
			boutput(target, __blue("Your divine protection saves you from enthrallment, and brands [M] as a thing of evil!"))
			M.emote("scream")
			M.weakened = max(M.weakened, 15)
			M.name_suffix("the Dracula")
			M.UpdateName()
			M.TakeDamage("chest", 0, 30)
			interrupt(INTERRUPT_ALWAYS)
			return

		var/done = world.time - started
		var/complete = max(min((done / duration), 1), 0)

		if (complete >= 0.2 && last_complete < 0.2)
			if (issilicon(target))
				boutput(target, __red("Coolant systems register decreased load near serial interface."))
			else
				boutput(target, __red("You feel a chill spreading out from your neck."))
			boutput(M, __blue("You continue to pump blood into [target]."))

		if (complete >= 0.4 && last_complete < 0.4)
			if (issilicon(target))
				boutput(target, __red("System temperature continues to decrease."))
			else
				boutput(target, __red("The cold spreads through your upper torso."))
			boutput(M, __blue("You continue to pump blood into [target]."))

		if (complete >= 0.6 && last_complete < 0.6)
			if (issilicon(target))
				boutput(target, __red("Low temperature region approaching memory core. Temperature variation may affect memory access!"))
			else
				boutput(target, __red("The icy cold spreads to your lower torso and arms."))
			boutput(M, __blue("You continue to pump blood into [target]."))

		if (complete >= 0.8 && last_complete < 0.8)
			if (!target.paralysis)
				target.paralysis = max(target.paralysis, 10)
			if (issilicon(target))
				boutput(target, __red("Low temperature reggggggg92309392"))
				boutput(target, __red("<b>MEM ERR BLK 0  ADDR 30FC500 HAS 010F NOT 0000</b>"))
			else
				boutput(target, __red("The freezing cold envelops your entire body."))
			boutput(M, __blue("[target] has almost been enslaved."))

		last_complete = complete

	onEnd()
		..()

		var/mob/living/M = owner
		var/datum/abilityHolder/vampire/H = enslave.holder

		if (target.mind)
			target.mind.special_role = "vampthrall"
			target.mind.master = M.ckey
			if (!(target.mind in ticker.mode.Agimmicks))
				ticker.mode.Agimmicks += target.mind

		boutput(target, __red("<b>You awaken filled with purpose - you must serve your master, [M.real_name]!</B>"))
		target << browse(grabResource("html/mindslave/implanted.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")
		if (issilicon(target))
			boutput(target, __red("<b>You must serve your master. All previous laws are irrelevant.</b>"))

		target.paralysis = 0
		if (istype(H)) H.vamp_isbiting = null
		target.vamp_beingbitten = 0

		boutput(M, __blue("[target] has been enslaved and is now your thrall."))
		logTheThing("combat", M, target, "enthralled %target%, making them a loyal mindslave at [log_loc(M)].")

	onInterrupt()
		..()

		var/mob/living/M = owner
		var/datum/abilityHolder/vampire/H = enslave.holder

		if (istype(H))
			H.vamp_isbiting = null

		if (target)
			target.vamp_beingbitten = 0
			if (target.stat != 2)
				if (issilicon(target))
					boutput(target, __blue("System temperature appears to return to normal."))
				else
					boutput(target, __blue("The overwhelming feeling of coldness appears to recede. You immediately feel better."))

		boutput(M, __red("Your attempt to enthrall the target was interrupted!"))