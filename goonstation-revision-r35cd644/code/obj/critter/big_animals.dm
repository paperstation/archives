/obj/critter/bear
	name = "space bear"
	desc = "WOORGHHH"
	icon_state = "abear"
	health = 60
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	butcherable = 1
	var/loveometer = 0

	var/left_arm_stage = 0
	var/right_arm_stage = 0
	var/obj/item/parts/human_parts/arm/left/bear/left_arm
	var/obj/item/parts/human_parts/arm/right/bear/right_arm

	skinresult = /obj/item/material_piece/cloth/leather
	max_skins = 2

	New()
		..()
		src.left_arm = new /obj/item/parts/human_parts/arm/left/bear(src)
		src.right_arm = new /obj/item/parts/human_parts/arm/right/bear(src)

	on_revive()
		if (!src.left_arm)
			src.left_arm = new /obj/item/parts/human_parts/arm/left/bear(src)
			src.left_arm_stage = 0
			src.visible_message("<span style=\"color:red\">[src]'s left arm regrows!</span>")
		if (!src.right_arm)
			src.right_arm = new /obj/item/parts/human_parts/arm/right/bear(src)
			src.right_arm_stage = 0
			src.visible_message("<span style=\"color:red\">[src]'s right arm regrows!</span>")
		..()

	CritterDeath()
		if (!alive)
			return
		..()
		src.update_dead_icon()

	proc/update_dead_icon()
		if (src.alive)
			return
		. = initial(icon_state)
		if (!src.left_arm)
			. += "-l"
		if (!src.right_arm)
			. += "-r"
		. += "-dead"
		icon_state = .

	attackby(obj/item/W as obj, mob/living/user as mob)
		if (!src.alive)
			// TODO: tie this into surgery()
			if (istype(W, /obj/item/scalpel))
				if (user.zone_sel.selecting == "l_arm")
					if (src.left_arm_stage == 0)
						user.visible_message("<span class='combat'>[user] slices through the skin and flesh of [src]'s left arm with [W].</span>", "<span style=\"color:red\">You slice through the skin and flesh of [src]'s left arm with [W].</span>")
						src.left_arm_stage++
					else if (src.left_arm_stage == 2)
						user.visible_message("<span class='combat'>[user] cuts through the remaining strips of skin holding [src]'s left arm on with [W].</span>", "<span style=\"color:red\">You cut through the remaining strips of skin holding [src]'s left arm on with [W].</span>")
						src.left_arm_stage++

						var/turf/location = get_turf(src)
						if (location)
							src.left_arm.set_loc(location)
							src.left_arm = null
						src.update_dead_icon()

				else if (user.zone_sel.selecting == "r_arm")
					if (src.right_arm_stage == 0)
						user.visible_message("<span class='combat'>[user] slices through the skin and flesh of [src]'s right arm with [W].</span>", "<span style=\"color:red\">You slice through the skin and flesh of [src]'s right arm with [W].</span>")
						src.right_arm_stage++
					else if (src.right_arm_stage == 2)
						user.visible_message("<span class='combat'>[user] cuts through the remaining strips of skin holding [src]'s right arm on with [W].</span>", "<span style=\"color:red\">You cut through the remaining strips of skin holding [src]'s right arm on with [W].</span>")
						src.right_arm_stage++

						var/turf/location = get_turf(src)
						if (location)
							src.right_arm.set_loc(location)
							src.right_arm = null
						src.update_dead_icon()

			else if (istype(W, /obj/item/circular_saw))
				if (user.zone_sel.selecting == "l_arm")
					if (src.left_arm_stage == 1)
						user.visible_message("<span class='combat'>[user] saws through the bone of [src]'s left arm with [W].</span>", "<span style=\"color:red\">You saw through the bone of [src]'s left arm with [W].</span>")
						src.left_arm_stage++
				else if (user.zone_sel.selecting == "r_arm")
					if (src.right_arm_stage == 1)
						user.visible_message("<span class='combat'>[user] saws through the bone of [src]'s right arm with [W].</span>", "<span style=\"color:red\">You saw through the bone of [src]'s right arm with [W].</span>")
						src.right_arm_stage++
			else
				..()
			return
		else
			..()

	CritterAttack(mob/M)
		if(ismob(M))
			src.attacking = 1
			src.visible_message("<span class='combat'><B>[src]</B> claws at [src.target]!</span>")
			if(ishuman(target))
				random_brute_damage(src.target, rand(6,18))
			else if (isrobot(target))
				target:compborg_take_critter_damage(null, rand(4,8))
			spawn(10)
				src.attacking = 0

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> mauls [M]!</span>")
		playsound(src.loc, pick("sound/voice/MEraaargh.ogg"), 40, 0)
		M.weakened += rand(2,4)
		M.stunned += rand(1,3)
		random_brute_damage(M, rand(2,5))

obj/critter/bear/care
	name = "space carebear"
	desc = "I love you!"
	icon_state = "carebear"

	New()
		..()
		src.name = pick("Lovealot Bear", "Stuffums", "World Destroyer", "Pookie", "Colonel Sanders", "Hugbeast", "Lovely Bear", "HUG ME", "Empathy Bear", "Steve", "Mr. Pants")

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> snuggles [M]!</span>")
		playsound(src.loc, pick("sound/misc/babynoise.ogg"), 50, 0)
		M.weakened += rand(2,4)
		M.stunned += rand(1,3)
		random_brute_damage(M, rand(2,5))

/obj/critter/yeti
	name = "space yeti"
	desc = "Well-known as the single most aggressive, dangerous and hungry thing in the universe."
	icon_state = "yeti"
	density = 1
	health = 75
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	firevuln = 3
	brutevuln = 1
	angertext = "starts chasing" // comes between critter name and target name
	butcherable = 1

	skinresult = /obj/item/material_piece/cloth/leather
	max_skins = 2

	New()
		..()
		src.seek_target()

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in hearers(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (iscarbon(C)) src.attack = 1
			if (istype(C, /mob/living/silicon/)) src.attack = 1
			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [src.target]!</span>")
				playsound(src.loc, pick("sound/voice/YetiGrowl.ogg"), 40, 0)
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> punches out [M]!</span>")
		playsound(src.loc, "sound/effects/bang.ogg", 40, 1, -1)
		M.stunned = 10
		M.weakened = 10

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> devours [M] in one bite!</span>")
		logTheThing("combat", M, null, "was devoured by [src] at [log_loc(src)].") // Some logging for instakill critters would be nice (Convair880).
		playsound(src.loc, "sound/items/eatfood.ogg", 30, 1, -2)
		M.death(1)
		var/atom/movable/overlay/animation = null
		M.transforming = 1
		M.canmove = 0
		M.icon = null
		M.invisibility = 101
		if(ishuman(M))
			animation = new(src.loc)
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = src
		if (M.client)
			var/mob/dead/observer/newmob
			newmob = new/mob/dead/observer(M)
			M.client:mob = newmob
			M.mind.transfer_to(newmob)
		qdel(M)
		src.task = "thinking"
		src.seek_target()
		src.attacking = 0
		playsound(src.loc, pick("sound/misc/burp_alien.ogg"), 50, 0)

		sleeping = 1

/obj/critter/shark
	name = "space shark"
	desc = "This is the third most terrifying thing you've ever laid eyes on."
	icon = 'icons/misc/banshark.dmi'
	icon_state = "banshark1"
	density = 1
	health = 75
	aggressive = 1
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 1
	atksilicon = 1
	firevuln = 3
	brutevuln = 1
	angertext = "swims after" // comes between critter name and target name
	generic = 0
	var/recentsound = 0
	butcherable = 1

	CritterDeath()
		..()
		src.reagents.add_reagent("shark_dna", 50, null)
		return

	New()
		..()
		src.seek_target()

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in hearers(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (iscarbon(C)) src.attack = 1
			if (istype(C, /mob/living/silicon/)) src.attack = 1
			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [src.target]!</span>")
				if(!recentsound)
					playsound(src.loc, pick("sound/misc/jaws.ogg"), 50, 0)
					recentsound = 1
					spawn(600) recentsound = 0
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> bashes into [M]!</span>")
		playsound(src.loc, "sound/effects/bang.ogg", 50, 1, -1)
		M.stunned = 10
		M.weakened = 10

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> gibs [M] in one bite!</span>")
		logTheThing("combat", M, null, "was gibbed by [src] at [log_loc(src)].") // Some logging for instakill critters would be nice (Convair880).
		playsound(src.loc, "sound/items/eatfood.ogg", 30, 1, -2)
		M.gib()
		src.task = "thinking"
		src.seek_target()
		src.attacking = 0
		spawn(30) playsound(src.loc, pick("sound/misc/burp_alien.ogg"), 50, 0)

		sleeping = 1

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/shark
	name = "shark egg"
	critter_type = /obj/critter/shark
	warm_count = 50

/obj/critter/bat
	name = "bat"
	desc = "skreee!"
	icon_state = "bat"
	density = 1
	health = 5
	aggressive = 0
	defensive = 1
	wanderer = 1
	opensdoors = 0
	atkcarbon = 0
	atksilicon = 0
	firevuln = 1
	brutevuln = 1

	CritterDeath()
		..()
		src.reagents.add_reagent("woolofbat", 50, null)
		return

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> bites [src.target]!</span>")
		random_brute_damage(src.target, 1)
		spawn(10)
			src.attacking = 0

	Move()
		if(prob(15))
			playsound(src.loc, "rustle", 10, 1)
		..()

/obj/critter/bat/doctor
	name = "Dr. Acula"
	desc = "If you ask nicely he might even write you a preskreeeption!"
	icon_state = "batdoctor"
	health = 30
	generic = 0

// A slightly scarier (but still cute) bat for vampires

/obj/critter/bat/buff
	name = "angry bat"
	desc = "It doesn't look too happy!"
	icon_state = "scarybat"
	health = 25
	aggressive = 1
	defensive = 1
	wanderer = 1
	atkcarbon = 1
	atksilicon = 1
	brutevuln = 0.7
	opensdoors = 0
	seekrange = 5
	density = 1 // so lasers can hit them
	angertext = "screeches at"

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in hearers(src.seekrange,src))
			if (src.target)
				src.task = "chasing"
				break
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100)) continue
			if (iscarbon(C) && !src.atkcarbon) continue
			if (istype(C, /mob/living/silicon/) && !src.atksilicon) continue
			if (C.health < 0) continue
			if (C in src.friends) continue
			if (isvampire(C)) continue
			if (C.name == src.attacker) src.attack = 1
			if (iscarbon(C) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)
				src.target = C
				src.oldtarget_name = C.name
				src.visible_message("<span class='combat'><b>[src]</b> [src.angertext] [C.name]!</span>")
				src.task = "chasing"
				break
			else
				continue

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><B>[src]</B> hits [M]!</span>")
		if (prob(30)) M.weakened += rand(1,2)

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span class='combat'><B>[src]</B> bites and claws at [src.target]!</span>")
		random_brute_damage(src.target, rand(3,5))
		spawn(10)
			src.attacking = 0

/obj/item/reagent_containers/food/snacks/ingredient/egg/critter/bat
	name = "bat egg"
	critter_type = /obj/critter/bat

/obj/critter/lion
	name = "lion"
	desc = "Oh christ"
	icon_state = "lion"
	density = 1
	health = 20
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	atcritter = 1
	firevuln = 0.5
	brutevuln = 0.5
	butcherable = 1
	death_text = "%src% gives up the ghost!"

	CritterAttack(mob/M)
		src.attacking = 1
		M.visible_message("<span class='combat'><b>[src]</b> savagely bites [src.target]!</span>")
		random_brute_damage(M, rand(8,16))

		spawn(10)
			src.attacking = 0

	ChaseAttack(mob/M)
		src.visible_message("<span class='combat'><b>[src]</b> lunges upon [M]!</span>")
		if(iscarbon(M))
			if(prob(50)) M.stunned += rand(2,4)
		random_brute_damage(M, rand(4,8))
