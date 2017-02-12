/obj/item/artifact/melee_weapon
	name = "artifact melee weapon"
	artifact = 1
	associated_datum = /datum/artifact/melee
	module_research_no_diminish = 1

	attack(mob/M as mob, mob/user as mob)
		if (!src.ArtifactSanityCheck())
			return
		var/datum/artifact/A = src.artifact
		if (A.activated)
			A.effect_melee_attack(src,user,M)
			src.ArtifactFaultUsed(user)
			src.ArtifactFaultUsed(M)
		else
			..()

/datum/artifact/melee
	associated_object = /obj/item/artifact/melee_weapon
	rarity_class = 2
	validtypes = list("ancient","martian","wizard","eldritch","precursor")
	react_xray = list(14,95,95,7,"DENSE")
	var/damtype = "brute"
	var/dmg_amount = 5
	var/stun_time = 0
	var/KO_time = 0
	var/deadly = 0
	var/sound/hitsound = null
	examine_hint = "It seems to have a handle you're supposed to hold it by."
	module_research = list("weapons" = 8, "miniaturization" = 8)
	module_research_insight = 1

	New()
		..()
		src.damtype = pick("brute", "fire", "toxin")
		src.dmg_amount = rand(3,6)
		src.dmg_amount *= rand(1,5)
		if (prob(5))
			src.dmg_amount *= rand(1,5)
		if (prob(40))
			src.stun_time = rand(3,12)
		if (prob(15))
			src.KO_time = rand(3,12)
		if (prob(1))
			src.deadly = 1
		src.hitsound = pick('sound/effects/bang.ogg','sound/effects/zhit.ogg','sound/effects/exlow.ogg','sound/effects/mag_magmisimpact.ogg','sound/effects/shieldhit2.ogg',
		'sound/effects/snap.ogg','sound/machines/mixer.ogg','sound/misc/meteorimpact.ogg','sound/weapons/ACgun2.ogg','sound/weapons/Egloves.ogg','sound/weapons/flashbang.ogg',
		'sound/weapons/grenade.ogg','sound/weapons/railgun.ogg')

	effect_melee_attack(var/obj/O,var/mob/living/user,var/mob/living/target)
		if (..())
			return
		if (!istype(user,/mob/living/) || !istype(target,/mob/living/))
			return
		user.visible_message("<span style=\"color:red\"><b>[user.name]</b> attacks [target.name] with [O]!</span>")
		var/turf/T = get_turf(user)
		playsound(T, hitsound, 50, 1, -1)
		if (src.deadly)
			user.visible_message("<span style=\"color:red\"><b>[target] is utterly destroyed!</b></span>")
			target.gib()
		else
			switch(damtype)
				if ("brute")
					random_brute_damage(target, dmg_amount)
				if ("fire")
					random_burn_damage(target, dmg_amount)
				if ("toxin")
					if (ishuman(target))
						var/mob/living/carbon/human/H = target
						H.toxloss += rand(1, dmg_amount)
			if (src.stun_time)
				target.stunned = src.stun_time
			if (src.KO_time)
				target.paralysis = src.KO_time