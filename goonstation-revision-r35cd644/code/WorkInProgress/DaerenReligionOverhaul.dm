/obj/screen/ability/chaplain
	clicked(params)
		var/datum/targetable/chaplain/spell = owner
		if (!istype(spell))
			return
		if (!spell.holder)
			return
		if (!isturf(usr.loc))
			return
		if (spell.targeted)
			if (world.time < spell.last_cast)
				return
			usr:targeting_spell = owner
			usr.update_cursor()
		else
			spawn
				spell.handleCast()

/datum/abilityHolder/religious
	usesPoints = 0
	regenRate = 0
	tabName = "Miracles"
	var/god_fullname = null
	var/god_name = null
	var/god_epithet = null
	var/god_domain = null
	var/atheist = 0

	New()
		..()
		src.addAbility(/datum/targetable/chaplain/chooseReligion)


/datum/targetable/chaplain
	name = "OOPS SOMETHING BROKE"
	desc = "for real if you can see this tell a coder"
	icon = 'icons/mob/wraith_ui.dmi'
	icon_state = "template"
	cooldown = 0
	last_cast = 0
	targeted = 1
	target_anything = 1
	var/disabled = 0

	New()
		var/obj/screen/ability/chaplain/B = new /obj/screen/ability/chaplain(null)
		B.icon = src.icon
		B.icon_state = src.icon_state
		B.owner = src
		B.name = src.name
		B.desc = src.desc
		src.object = B

	proc/incapacitationCheck()
		var/mob/living/M = holder.owner
		return M.restrained() || M.stat || M.paralysis || M.stunned || M.weakened

	castcheck()
		if (incapacitationCheck())
			boutput(holder.owner, "<span style=\"color:red\">You can't do that while you're incapacitated.</span>")
			return 0
		if (disabled)
			boutput(holder.owner, "<span style=\"color:red\">You cannot use that ability at this time.</span>")
			return 0
		return 1

	cast(atom/target)
		. = ..()
		actions.interrupt(holder.owner, INTERRUPT_ACT)

	doCooldown()
		if (!holder)
			return
		last_cast = world.time + cooldown
		holder.updateButtons()
		spawn(cooldown + 5)
			holder.updateButtons()

/proc/assemble_name(var/datum/abilityHolder/religious/religiousHolder)
	var/list/god_adjective = strings("gods.txt", "adjective")
	var/list/god_noun = strings("gods.txt", "noun")
	var/list/namebegin = strings("gods.txt", "namebegin")
	var/list/nameend = strings("gods.txt", "nameend")
	religiousHolder.god_fullname = ""
	if (religiousHolder.atheist == 1) // dweeb detected
		religiousHolder.god_name = religiousHolder.owner.real_name
		religiousHolder.god_epithet = "Smug Bastard"
	else
		religiousHolder.god_name = "[pick(namebegin)][pick(nameend)]"
		religiousHolder.god_epithet = ""
		religiousHolder.god_epithet += "[capitalize(pick(god_adjective))] "
		religiousHolder.god_epithet += "[capitalize(pick(god_noun))]"
	religiousHolder.god_fullname += "[religiousHolder.god_name] the [religiousHolder.god_epithet], "
	if (religiousHolder.atheist == 1)
		if (religiousHolder.owner.gender == MALE)
			religiousHolder.god_fullname += "'God'"
		else
			religiousHolder.god_fullname += "'Goddess'"
	else
		religiousHolder.god_fullname += pick("God", "Goddess")
	religiousHolder.god_fullname += " of [religiousHolder.god_domain]"

	boutput(religiousHolder.owner, "<span style=\"color:blue\">You are now a priest of [religiousHolder.god_fullname]!</span>")
	return

/datum/targetable/chaplain/chooseReligion
	name = "Choose Religion"
	desc = "What flavor of crazy street preacher do you feel like being today?"
	cooldown = 0
	targeted = 0
	target_anything = 0
	icon_state = "absorbcorpse"
	var/static/list/domains = list("Atheism" = 1, "Order" = 2, "Chaos" = 3, "Light" = 4, "Darkness" = 5, "Life" = 6, "Death" = 7, "Machinery" = 8, "Nature" = 9, "Surprise me!" = 10)
	//var/static/list/domainsForNerds = list("Atheism" = 1, "Order" = 2, "Chaos" = 3, "Light" = 4, "Darkness" = 5, "Life" = 6, "Death" = 7, "Machinery" = 8, "Nature" = 9, "Sol Invictus" = 10, "the Void" = 11, "Surprise me!" = 12)

	cast()
		var/datum/abilityHolder/religious/religiousHolder = src.holder
		if (..())
			return 1
		var/domainChoice = input("Which domain?", "Domain", "Surprise me!") in domains

		if (domainChoice  == "Surprise me!")
			domainChoice = rand(1, 9)
		else
			domainChoice = domains[domainChoice]
		switch (domainChoice)
			if (1)
				religiousHolder.atheist = 1
				religiousHolder.god_domain = "Atheism"
				assemble_name(religiousHolder)
			if (2)
				religiousHolder.god_domain = "Order"
				assemble_name(religiousHolder)
			if (3)
				religiousHolder.god_domain = "Chaos"
				assemble_name(religiousHolder)
			if (4)
				religiousHolder.god_domain = "Light"
				assemble_name(religiousHolder)
			if (5)
				religiousHolder.god_domain = "Darkness"
				assemble_name(religiousHolder)
			if (6)
				religiousHolder.god_domain = "Life"
				assemble_name(religiousHolder)
			if (7)
				religiousHolder.god_domain = "Death"
				assemble_name(religiousHolder)
			if (8)
				religiousHolder.god_domain = "Machinery"
				usr.robot_talk_understand = 1
				religiousHolder.addAbility(/datum/targetable/chaplain/chaplainDemag)
				religiousHolder.addAbility(/datum/targetable/chaplain/sootheMachineSpirits)
				assemble_name(religiousHolder)
			if (9)
				religiousHolder.god_domain = "Nature"
				religiousHolder.addAbility(/datum/targetable/chaplain/blessWeed)
				religiousHolder.addAbility(/datum/targetable/chaplain/fortifySeed)
				assemble_name(religiousHolder)

		religiousHolder.removeAbility(/datum/targetable/chaplain/chooseReligion)
		return

//*************** ATHEISM *****************

//100% worthless gimmick shit, free fedora, supersmug emote, immunity to fedora gib?

//*************** ORDER *****************

//Clean everything in an aoe
//??? move demag here, give machinery a repair power???

//*************** CHAOS *****************

//Xom bullshit, Pandemonium, etc

//*************** LIGHT *****************

//Flash immunity
//Photokinesis
//Glowy

//*************** DARKNESS *****************

//Erebokinesis
//Ignore all darkness

//*************** LIFE *****************

//stabilize someone in shock/heart attack, long cd
//self-regen/heal

//*************** DEATH *****************

//passively sense when deaths occur
//????
//Animate meatcubes maybe???

//*************** NATURE *****************


/datum/targetable/chaplain/blessWeed
	name = "Bless Weed"
	desc = "Make some herb into sacred herbs."
	cooldown = 150
	targeted = 1
	target_anything = 1
	icon_state = "absorbcorpse"

	cast(atom/T)
		var/datum/abilityHolder/religious/religiousHolder = src.holder
		if (..())
			return 1

		if (!istype(T, /obj/item/plant/herb/cannabis))
			boutput(holder.owner, "<span style=\"color:red\">That ain't weed, you dingus!</span>")
			return 1

		if (istype(T,/obj/item/plant/herb/cannabis/black))
			boutput(holder.owner, "<span style=\"color:blue\">You purify the toxins in [T]!</span>")
			new/obj/item/plant/herb/cannabis/spawnable(T.loc)
			qdel(T)
			return 0
		if (istype(T, /obj/item/plant/herb/cannabis/mega))
			boutput(holder.owner, "<span style=\"color:blue\">You bestow [religiousHolder.god_name]'s blessing upon [T]!</span>")
			new/obj/item/plant/herb/cannabis/omega/spawnable(T.loc)
			qdel(T)
			return 0
		if (istype(T, /obj/item/plant/herb/cannabis/white))
			boutput(holder.owner, "<span style=\"color:red\">No need to bless what's already blessed.</span>")
			return 1
		if (istype(T, /obj/item/plant/herb/cannabis/omega))
			boutput(holder.owner, "<span style=\"color:red\">Look, this shit could glue [religiousHolder.god_name] to the couch already. Making it any more dank might cause some sort of weedularity.</span>")
			return 1
		else
			boutput(holder.owner, "<span style=\"color:blue\">You bestow [religiousHolder.god_name]'s blessing upon [T]!</span>")
			new/obj/item/plant/herb/cannabis/white/spawnable(T.loc)
			qdel(T)
			return 0

/datum/targetable/chaplain/fortifySeed
	name = "Fortify Seed"
	desc = "Blesses a seed, giving small, random improvements to all of its traits."
	cooldown = 450
	targeted = 1
	target_anything = 1
	icon_state = "absorbcorpse"

	proc/fortify(var/obj/item/seed/S)
		var/datum/plantgenes/DNA = S.plantgenes
		DNA.growtime -= rand(0,8)
		DNA.harvtime -= rand(0,5)
		DNA.cropsize += rand(0,4)
		DNA.harvests += rand(0,1)
		DNA.potency += rand(0,6)
		DNA.endurance += rand(0,3)

	cast(atom/T)
		if (..())
			return 1

		if (istype(T, /obj/item/seed))
			fortify(T)
			return 0
		else
			boutput(holder.owner, "<span style=\"color:red\">This only works on seeds!</span>")
			return 1


//*************** MACHINES *****************

/datum/targetable/chaplain/chaplainDemag
	name = "Demag"
	desc = "Repairs damage to sensitive electronics due to electromagnetic scrambling. Note: cyborg circuitry is too complex for this to work."
	cooldown = 1800
	targeted = 1
	target_anything = 1
	icon_state = "absorbcorpse"

	cast(atom/T)
		if (..())
			return 1

		if (!istype(T, /obj))
			boutput(holder.owner, "<span style=\"color:red\">You cannot try to repair this!</span>")
			return 1

		var/obj/O = T
		// go to jail, do not pass src, do not collect pushed messages
		if (O.demag())
			boutput(usr, "<span style=\"color:blue\">You repair the damage to [O].</span>")
			return 0
		else
			boutput(usr, "<span style=\"color:red\">It doesn't seem like this needs fixing.</span>")
			return 1

/datum/targetable/chaplain/sootheMachineSpirits
	name = "Soothe Machine Spirits"
	desc = "NT-model thermoelectric engines tend to be...tempermental. You're able to calm them down better than most."
	cooldown = 900
	targeted = 1
	target_anything = 1
	max_range = 1
	icon_state = "absorbcorpse"

	cast(atom/T)
		if (..())
			return 1

		if (get_dist(usr, T) > src.max_range)
			boutput(usr, __red("[T] is too far away."))
			return 1

		if (!istype(T, /obj/machinery/power/generatorTemp))
			boutput(usr, "<span style=\"color:red\">You can only use this on the engine's core!</span>")
			return 1

		var/obj/machinery/power/generatorTemp/E = T
		usr.visible_message("<span style=\"color:blue\">[usr] places a hand on the [E] and mumbles something.</span>")
		playsound(usr.loc, "sound/effects/heavenly.ogg", 50, 1)
		spawn(30)
		E.grump = 0
		E.visible_message("<span style=\"color:blue\"><b>The [E] suddenly seems very chill!</b></span>")

		return 0


//*************** SOL INVICTUS? *****************


//*************** THE VOID? *****************