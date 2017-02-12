/obj/item/raw_material/
	name = "construction materials"
	desc = "placeholder item!"
	icon = 'icons/obj/materials.dmi'
	force = 4
	throwforce = 6
	var/material_name = "Ore" //text to display for this ore in manufacturers
	var/metal = 0  // what grade of metal is it?
	var/conductor = 0
	var/dense = 0
	var/crystal = 0
	var/powersource = 0
	var/scoopable = 1
	burn_type = 1
	var/wiggle = 6 // how much we want the sprite to be deviated fron center

	New()
		..()
		src.pixel_x = rand(0 - wiggle, wiggle)
		src.pixel_y = rand(0 - wiggle, wiggle)

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/satchel/mining/))
			if (W:contents.len < W:maxitems)
				src.set_loc(W)
				var/oreamt = W:contents.len
				boutput(user, "<span style=\"color:blue\">You put [src] in [W].</span>")
				src.desc = "A leather bag. It holds [oreamt]/[W:maxitems] [W:itemstring]."
				if (oreamt == W:maxitems) boutput(user, "<span style=\"color:blue\">[W] is now full!</span>")
				W:satchel_updateicon()
			else
				boutput(user, "<span style=\"color:red\">[W] is full!</span>")
		else ..()

	HasEntered(AM as mob|obj)
		if (istype(AM,/mob/dead/))
			return
		else if (istype(AM,/mob/living/))
			var/mob/living/H = AM
			var/obj/item/ore_scoop/S = H.get_equipped_ore_scoop()
			if (S && S.satchel && S.satchel.contents.len < S.satchel.maxitems && src.scoopable)
				src.loc = S.satchel
				S.satchel.satchel_updateicon()
				if (S.satchel.contents.len >= S.satchel.maxitems)
					boutput(H, "<span style=\"color:red\">Your ore scoop's satchel is full!</span>")
					playsound(get_turf(H), "sound/machines/chime.ogg", 20, 1)
		else if (istype(AM,/obj/machinery/vehicle/))
			var/obj/machinery/vehicle/V = AM
			if (istype(V.sec_system,/obj/item/shipcomponent/secondary_system/orescoop))
				var/obj/item/shipcomponent/secondary_system/orescoop/SCOOP = V.sec_system
				if (SCOOP.contents.len >= SCOOP.capacity || !src.scoopable)
					return
				src.loc = SCOOP
				if (SCOOP.contents.len >= SCOOP.capacity)
					boutput(V.pilot, "<span style=\"color:red\">Your pod's ore scoop hold is full!</span>")
					playsound(V.loc, "sound/machines/chime.ogg", 20, 1)
			return
		else
			return

	MouseDrop(over_object, src_location, over_location)
		if (istype(usr,/mob/dead/))
			boutput(usr, "<span style=\"color:red\">Quit that! You're dead!</span>")
			return

		if (get_dist(usr,src) > 1)
			boutput(usr, "<span style=\"color:red\">You're too far away from it to do that.</span>")
			return

		if (get_dist(usr,over_object) > 1)
			boutput(usr, "<span style=\"color:red\">You're too far away from it to do that.</span>")
			return

		if (isturf(over_object))
			var/turf/T = over_object
			usr.visible_message("<span style=\"color:blue\">[usr.name] begins sorting [src] into a pile!</span>")
			var/staystill = usr.loc
			for(var/obj/item/I in view(1,usr))
				if (!I)
					continue
				if (src.name != I.name)
					continue
				if (I.loc == usr)
					continue
				I.set_loc(T)
				sleep(0.5)
				if (usr.loc != staystill) break
			boutput(usr, "<span style=\"color:blue\">You finish sorting [src]!</span>")

		else
			..()

/obj/item/raw_material/rock
	name = "rock"
	desc = "It's plain old space rock. Pretty worthless!"
	icon_state = "rock1"
	force = 8
	throwforce = 10
	scoopable = 0

	New()
		..()
		src.icon_state = pick("rock1","rock2","rock3")

/obj/item/raw_material/mauxite
	name = "mauxite ore"
	desc = "A chunk of Mauxite, a sturdy common metal."
	icon_state = "mauxite"
	material_name = "Mauxite"
	metal = 2

	New()
		src.material = getCachedMaterial("mauxite")
		return ..()

/obj/item/raw_material/molitz
	name = "molitz crystal"
	desc = "A crystal of Molitz, a common crystalline substance."
	icon_state = "molitz"
	material_name = "Molitz"
	crystal = 1

	New()
		src.material = getCachedMaterial("molitz")
		return ..()

/obj/item/raw_material/pharosium
	name = "pharosium ore"
	desc = "A chunk of Pharosium, a conductive metal."
	icon_state = "pharosium"
	material_name = "Pharosium"
	metal = 1
	conductor = 1

	New()
		src.material = getCachedMaterial("pharosium")
		return ..()

/obj/item/raw_material/cobryl // relate this to precursors
	name = "cobryl ore"
	desc = "A chunk of Cobryl, a somewhat valuable metal."
	icon_state = "cobryl"
	material_name = "Cobryl"
	metal = 1

	New()
		src.material = getCachedMaterial("cobryl")
		return ..()

/obj/item/raw_material/char
	name = "char ore"
	desc = "A heap of Char, a fossil energy source similar to coal."
	icon_state = "char"
	material_name = "Char"
	//cogwerks - burn vars
	burn_point = 450
	burn_output = 1600
	burn_possible = 1
	health = 20

	New()
		src.material = getCachedMaterial("char")
		return ..()

/obj/item/raw_material/claretine // relate this to wizardry somehow
	name = "claretine ore"
	desc = "A heap of Claretine, a highly conductive salt."
	icon_state = "claretine"
	material_name = "Claretine"
	conductor = 2

	New()
		src.material = getCachedMaterial("claretine")
		return ..()

/obj/item/raw_material/bohrum
	name = "bohrum ore"
	desc = "A chunk of Bohrum, a heavy and highly durable metal."
	icon_state = "bohrum"
	material_name = "Bohrum"
	metal = 3
	dense = 1

	New()
		src.material = getCachedMaterial("bohrum")
		return ..()

/obj/item/raw_material/syreline
	name = "syreline ore"
	desc = "A chunk of Syreline, an extremely valuable and coveted metal."
	icon_state = "syreline"
	material_name = "Syreline"
	metal = 1

	New()
		src.material = getCachedMaterial("syreline")
		return ..()

/obj/item/raw_material/erebite
	name = "erebite ore"
	desc = "A chunk of Erebite, an extremely volatile high-energy mineral."
	icon_state = "erebite"
	var/exploded = 0
	material_name = "Erebite"
	powersource = 2

	New()
		src.material = getCachedMaterial("erebite")
		return ..()

	ex_act(severity)
		if(exploded)
			return
		exploded = 1
		for(var/obj/item/raw_material/erebite/E in get_turf(src))
			if(E == src) continue
			qdel(E)

		for(var/obj/item/raw_material/erebite/E in range(4,src))
			if (E == src) continue
			qdel(E)

		switch(severity)
			if(1)
				explosion(src, src.loc, 1, 2, 3, 4, 1)
			if(2)
				explosion(src, src.loc, 0, 1, 2, 3, 1)
			if(3)
				explosion(src, src.loc, 0, 0, 1, 2, 1)
			else
				return
		// if not on mining z level
		if (src.z != MINING_Z)
			var/turf/bombturf = get_turf(src)
			if (bombturf)
				var/bombarea = bombturf.loc.name
				logTheThing("combat", null, null, "Erebite detonated by an explosion in [bombarea] ([showCoords(bombturf.x, bombturf.y, bombturf.z)]). Last touched by: [src.fingerprintslast]")
				message_admins("Erebite detonated by an explosion in [bombarea] ([showCoords(bombturf.x, bombturf.y, bombturf.z)]). Last touched by: [src.fingerprintslast]")

		qdel(src)

	temperature_expose(null, temp, volume)

		for(var/obj/item/raw_material/erebite/E in range(6,src))
			if (E == src) continue
			qdel(E)

		explosion(src, src.loc, 1, 2, 3, 4, 1)

		// if not on mining z level
		if (src.z != MINING_Z)
			var/turf/bombturf = get_turf(src)
			var/bombarea = istype(bombturf) ? bombturf.loc.name : "a blank, featureless void populated only by your own abandoned dreams and wasted potential"

			logTheThing("combat", null, null, "Erebite detonated by heat in [bombarea]. Last touched by: [src.fingerprintslast]")
			message_admins("Erebite detonated by heat in [bombarea]. Last touched by: [src.fingerprintslast]")

		qdel(src)

/obj/item/raw_material/cerenkite
	name = "cerenkite ore"
	desc = "A chunk of Cerenkite, a highly radioactive mineral."
	icon_state = "cerenkite"
	material_name = "Cerenkite"
	metal = 1
	powersource = 1

	New()
		src.material = getCachedMaterial("cerenkite")
		return ..()

/obj/item/raw_material/plasmastone
	name = "plasmastone"
	desc = "A piece of plasma in its solid state."
	icon_state = "plasmastone"
	material_name = "Plasmastone"
	//cogwerks - burn vars
	burn_point = 1000
	burn_output = 10000
	burn_possible = 1
	health = 40
	powersource = 1
	crystal = 1

	New()
		src.material = getCachedMaterial("plasmastone")
		return ..()

/obj/item/raw_material/gemstone
	name = "gem"
	desc = "A gemstone. It's probably pretty valuable!"
	icon_state = "gem"
	material_name = "Gem"
	force = 1
	throwforce = 3
	crystal = 1

	New()
		..()
		var/picker = rand(1,100)
		var/list/picklist
		switch(picker)
			if(1 to 10)
				picklist = list("diamond","ruby","topaz","emerald","sapphire","amethyst")
			if(11 to 40)
				picklist = list("jasper","garnet","peridot","malachite","lapislazuli","alexandrite")
			else
				picklist = list("onyx","rosequartz","citrine","jade","aquamarine","iolite")

		var/datum/material/M = getCachedMaterial(pick(picklist))
		src.setMaterial(M)

/obj/item/raw_material/uqill // relate this to ancients
	name = "uqill nugget"
	desc = "A nugget of Uqill, a rare and very dense stone."
	icon_state = "uqill"
	material_name = "Uqill"
	dense = 2

	New()
		src.material = getCachedMaterial("uqill")
		return ..()


/obj/item/raw_material/fibrilith
	name = "fibrilith"
	desc = "A compressed chunk of Fibrilith, an odd mineral known for its high tensile strength."
	icon_state = "fibrilith"
	material_name = "Fibrilith"

	New()
		src.material = getCachedMaterial("fibrilith")
		return ..()

/obj/item/raw_material/telecrystal
	name = "telecrystal"
	desc = "A large unprocessed telecrystal, a gemstone with space-warping properties."
	icon_state = "telecrystal"
	material_name = "Telecrystal"
	crystal = 1
	powersource = 2

	New()
		src.material = getCachedMaterial("telecrystal")
		return ..()

/obj/item/raw_material/miracle
	name = "miracle matter"
	desc = "Miracle Matter is a bizarre substance known to metamorphosise into other minerals when processed."
	icon_state = "miracle"
	material_name = "Miracle Matter"

	New()
		src.material = getCachedMaterial("miracle")
		return ..()

/obj/item/raw_material/starstone
	name = "starstone"
	desc = "An extremely rare jewel. Highly prized by collectors and lithovores."
	icon_state = "starstone"
	material_name = "Starstone"
	crystal = 1

	New()
		src.material = getCachedMaterial("starstone")
		return ..()

/obj/item/raw_material/eldritch
	name = "koshmarite ore"
	desc = "An unusual dense pulsating stone. You feel uneasy just looking at it."
	icon_state = "eldritch"
	material_name = "Koshmarite"
	crystal = 1
	dense = 2

	New()
		src.material = getCachedMaterial("koshmarite")
		return ..()

/obj/item/raw_material/martian
	name = "viscerite lump"
	desc = "A disgusting flesh-like material. Ugh. What the hell is this?"
	icon_state = "martian"
	material_name = "Viscerite"
	dense = 2

	New()
		src.material = getCachedMaterial("viscerite")
		var/datum/reagents/R = new/datum/reagents(25)
		reagents = R
		R.my_atom = src
		src.reagents.add_reagent("synthflesh", 25)
		return ..()

/obj/item/raw_material/gold
	name = "gold nugget"
	desc = "A chunk of pure gold. Damn son."
	icon_state = "gold"
	material_name = "Gold"
	dense = 2

	New()
		src.material = getCachedMaterial("gold")
		return ..()

// Misc building material

/obj/item/raw_material/fabric
	name = "fabric"
	desc = "Some spun cloth. Useful if you want to make clothing."
	icon_state = "fabric"
	material_name = "Fabric"
	scoopable = 0

	New()
		src.material = getCachedMaterial("fibrilith")
		return ..()

/obj/item/raw_material/cotton/
	name = "cotton wad"
	desc = "It's a big puffy white thing. Most likely not a cloud though."
	icon_state = "cotton"

	New()
		src.material = getCachedMaterial("cotton")
		return ..()

/obj/item/raw_material/ice
	name = "ice chunk"
	desc = "A chunk of ice. It's pretty cold."
	icon_state = "ice"
	material_name = "Ice"
	crystal = 1
	scoopable = 0

	New()
		src.material = getCachedMaterial("ice")
		return ..()

/obj/item/raw_material/scrap_metal
	// this should only be spawned by the game, spawning it otherwise would just be dumb
	name = "scrap"
	desc = "Some twisted and ruined metal. It could probably be smelted down into something more useful."
	icon_state = "scrap"
	burn_possible = 0

	New()
		..()
		icon_state += "[rand(1,5)]"

/obj/item/raw_material/shard
	// same deal here
	name = "shard"
	desc = "A jagged piece of broken crystal or glass. It could probably be smelted down into something more useful."
	icon_state = "shard"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "shard-glass"
	w_class = 3.0
	hit_type = DAMAGE_CUT
	hitsound = 'sound/effects/bloody_stab.ogg'
	force = 5.0
	throwforce = 15.0
	g_amt = 3750
	burn_type = 1
	stamina_damage = 5
	stamina_cost = 15
	stamina_crit_chance = 35
	burn_possible = 0
	var/sound_stepped = 'sound/misc/glass_step.ogg'

	New()
		..()
		icon_state += "[rand(1,3)]"

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(!scalpel_surgery(M,user)) return ..()
		else return

	HasEntered(AM as mob|obj)
		if(ismob(AM))
			var/mob/M = AM
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(istype(H.mutantrace, /datum/mutantrace/abomination))
					return
				if(!H.shoes)
					boutput(H, "<span style=\"color:red\"><B>You step on [src] barefoot! Ouch!</B></span>")
					playsound(src.loc, src.sound_stepped, 50, 1)
					var/obj/item/affecting = H.organs[pick("l_leg", "r_leg")]
					H.weakened = max(3, H.weakened)
					var/shard_damage = force
					affecting.take_damage(shard_damage, 0)
					H.UpdateDamageIcon()
					H.updatehealth()
		..()

	suicide(var/mob/usr as mob)
		usr.visible_message("<span style=\"color:red\"><b>[usr] slashes \his own throat with [src]!</b></span>")
		blood_slash(usr, 25)
		usr.TakeDamage("head", 150, 0)
		usr.updatehealth()
		spawn(100)
			if (usr)
				usr.suiciding = 0
		return 1

	glass

		New()
			..()
			var/datum/material/M = getCachedMaterial("glass")
			src.setMaterial(M)

	plasmacrystal

		New()
			..()
			var/datum/material/M = getCachedMaterial("plasmaglass")
			src.setMaterial(M)

// bars, tied into the new material system

/obj/item/material_piece/mauxite
	desc = "A processed bar of Mauxite, a sturdy common metal."
	default_material = "mauxite"

/obj/item/material_piece/molitz
	desc = "A cut block of Molitz, a common crystalline substance."
	default_material = "molitz"

/obj/item/material_piece/pharosium
	desc = "A processed bar of Pharosium, a conductive metal."
	default_material = "pharosium"

/obj/item/material_piece/cobryl
	desc = "A processed bar of Cobryl, a somewhat valuable metal."
	default_material = "cobryl"

/obj/item/material_piece/claretine
	desc = "A compressed Claretine, a highly conductive salt."
	default_material = "claretine"

/obj/item/material_piece/bohrum
	desc = "A processed bar of Bohrum, a heavy and highly durable metal."
	default_material = "bohrum"

/obj/item/material_piece/syreline
	desc = "A processed bar of Syreline, an extremely valuable and coveted metal."
	default_material = "syreline"

/obj/item/material_piece/plasmastone
	desc = "A cut block of Plasmastone."
	default_material = "plasmastone"

/obj/item/material_piece/uqill
	desc = "A cut block of Uqill. It is quite heavy."
	default_material = "uqill"

/obj/item/material_piece/koshmarite
	desc = "A cut block of an unusual dense stone. It seems similar to obsidian."
	default_material = "koshmarite"

/obj/item/material_piece/viscerite
	desc = "A cut block of a disgusting flesh-like material. Grody."
	default_material = "viscerite"

/obj/item/material_piece/gold
	desc = "Dag."
	default_material = "gold"

/obj/item/material_piece/ice
	desc = "Uh. What's the point in this? Is someone planning to make an igloo?"
	default_material = "ice"

// Material-related Machinery

/obj/machinery/portable_reclaimer
	name = "portable reclaimer"
	desc = "A sophisticated piece of machinery that quickly processes minerals into bars."
	icon = 'icons/obj/scrap.dmi'
	icon_state = "reclaimer"
	anchored = 0
	density = 1
	var/active = 0
	var/smelt_interval = 5
	var/sound/sound_load = sound('sound/items/Deconstruct.ogg')
	var/sound/sound_process = sound('sound/effects/pop.ogg')
	var/sound/sound_grump = sound('sound/machines/buzz-two.ogg')
	var/atom/output_location = null

	/*onMaterialChanged()
		..()
		if (istype(src.material))*/

	attack_hand(var/mob/user as mob)
		if (active)
			boutput(user, "<span style=\"color:red\">It's already working! Give it a moment!</span>")
			return
		if (src.contents.len < 1)
			boutput(user, "<span style=\"color:red\">There's nothing inside to reclaim.</span>")
			return
		user.visible_message("<b>[user.name]</b> switches on [src].")
		active = 1
		anchored = 1
		icon_state = "reclaimer-on"

		var/reject_counter = 0
		for (var/obj/item/M in src.contents)
			if (istype(M,/obj/item/cable_coil))
				// haaaaaaaaaaaaaaack
				continue
			if (!istype(M.material))
				M.set_loc(get_output_location())
				reject_counter++
				continue
			if (!(M.material.material_flags & MATERIAL_CRYSTAL) && !(M.material.material_flags & MATERIAL_METAL))
				M.set_loc(get_output_location())
				reject_counter++
				continue

		if (reject_counter > 0)
			src.visible_message("<b>[src]</b> emits an angry buzz and rejects some unsuitable materials!")
			playsound(src.loc, sound_grump, 40, 1)

		for (var/obj/item/raw_material/M in src.contents)
			output_bar_from_item(M)
			qdel(M)
			sleep(smelt_interval)

		var/insufficient_counter = 0
		for (var/obj/item/sheet/S in src.contents)
			while(S.amount >= 10)
				output_bar_from_item(S)
				S.amount -= 10
				sleep(smelt_interval)
			if (!S.amount)
				qdel(S)
			else
				insufficient_counter += S.amount
				S.set_loc(get_output_location())

		for (var/obj/item/rods/R in src.contents)
			while(R.amount >= 20)
				output_bar_from_item(R)
				R.amount -= 20
				sleep(smelt_interval)
			if (!R.amount)
				qdel(R)
			else
				insufficient_counter += R.amount
				R.set_loc(get_output_location())

		for (var/obj/item/tile/T in src.contents)
			while(T.amount >= 40)
				output_bar_from_item(T)
				T.amount -= 40
				sleep(smelt_interval)
			if (!T.amount)
				qdel(T)
			else
				insufficient_counter += T.amount
				T.set_loc(get_output_location())

		for (var/obj/item/wizard_crystal/W in src.contents)
			W.create_bar(src)
			qdel(W)
			sleep(smelt_interval)

		var/list/cable_materials = list()
		var/list/quality_sum = list()
		for (var/obj/item/cable_coil/C in src.contents)
			if (!(C.conductor.mat_id in cable_materials))
				cable_materials += C.conductor.mat_id
				cable_materials[C.conductor.mat_id] = 0
				quality_sum += C.conductor.mat_id
				quality_sum[C.conductor.mat_id] = 0
			if (!(C.insulator.mat_id in cable_materials))
				cable_materials += C.insulator.mat_id
				cable_materials[C.insulator.mat_id] = 0
				quality_sum += C.insulator.mat_id
				quality_sum[C.insulator.mat_id] = 0
			cable_materials[C.conductor.mat_id] += C.amount
			quality_sum[C.conductor.mat_id] += C.amount * C.quality
			cable_materials[C.insulator.mat_id] += C.amount
			quality_sum[C.insulator.mat_id] += C.amount * C.quality
			qdel(C)

		var/bad_flag = 0
		for (var/mat_id in cable_materials)
			var/total = cable_materials[mat_id]
			while(cable_materials[mat_id] >= 30)
				output_bar_with_quality(quality_sum[mat_id] / total, mat_id)
				cable_materials[mat_id] -= 30
				sleep(smelt_interval)
				if (cable_materials[mat_id] < 30)
					bad_flag = 1

		if (bad_flag)
			src.visible_message("<b>[src]</b> emits a grumpy buzz.")
			playsound(src.loc, sound_grump, 40, 1)

		if (insufficient_counter > 0)
			src.visible_message("<b>[src]</b> emits a grumpy buzz and ejects some leftovers.")
			playsound(src.loc, sound_grump, 40, 1)

		active = 0
		anchored = 0
		icon_state = "reclaimer"
		src.visible_message("<b>[src]</b> finishes working and shuts down.")

	proc/output_bar_with_quality(var/quality,var/default_material)
		var/datum/material/MAT = null
		if (istext(default_material))
			MAT = getCachedMaterial(default_material)
			if (!MAT)
				return null
		else
			return null

		var/bar_type = getProcessedMaterialForm(MAT)
		var/obj/item/material_piece/BAR = new bar_type(get_output_location())

		BAR.quality = quality
		BAR.name += getQualityName(quality)
		BAR.setMaterial(MAT)
		playsound(src.loc, sound_process, 40, 1)

		return BAR

	proc/output_bar_from_item(var/obj/O,var/default_material)
		if (!O)
			return null

		var/datum/material/MAT = O.material
		if (!O.material)
			if (istext(default_material))
				MAT = getCachedMaterial(default_material)
				spawn(0)
					if (!O.material)
						return null
			else
				return null

		var/bar_type = getProcessedMaterialForm(MAT)
		var/obj/item/material_piece/BAR = new bar_type(get_output_location())

		BAR.quality = O.quality
		BAR.name += getQualityName(O.quality)
		BAR.setMaterial(MAT)
		playsound(src.loc, sound_process, 40, 1)

		return BAR

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W,/obj/item/raw_material/) || istype(W,/obj/item/sheet/) || istype(W,/obj/item/rods/) || istype(W,/obj/item/tile/) || istype(W,/obj/item/cable_coil))
			boutput(user, "You load [W] into [src].")
			W.set_loc(src)
			user.u_equip(W)
			W.dropped()
			playsound(get_turf(src), sound_load, 40, 1)
		else
			..()
			return

	MouseDrop(over_object, src_location, over_location)
		if(!istype(usr,/mob/living/))
			boutput(usr, "<span style=\"color:red\">Get your filthy dead fingers off that!</span>")
			return

		if(over_object == src)
			output_location = null
			boutput(usr, "<span style=\"color:blue\">You reset the reclaimer's output target.</span>")
			return

		if(get_dist(over_object,src) > 1)
			boutput(usr, "<span style=\"color:red\">The reclaimer is too far away from the target!</span>")
			return

		if(get_dist(over_object,usr) > 1)
			boutput(usr, "<span style=\"color:red\">You are too far away from the target!</span>")
			return

		if (istype(over_object,/obj/storage/crate/))
			var/obj/storage/crate/C = over_object
			if (C.locked || C.welded)
				boutput(usr, "<span style=\"color:red\">You can't use a currently unopenable crate as an output target.</span>")
			else
				src.output_location = over_object
				boutput(usr, "<span style=\"color:blue\">You set the reclaimer to output to [over_object]!</span>")

		else if (istype(over_object,/obj/machinery/manufacturer/))
			var/obj/machinery/manufacturer/M = over_object
			if (M.stat & BROKEN || M.stat & NOPOWER || M.dismantle_stage > 0)
				boutput(usr, "<span style=\"color:red\">You can't use a non-functioning manufacturer as an output target.</span>")
			else
				src.output_location = M
				boutput(usr, "<span style=\"color:blue\">You set the reclaimer to output to [over_object]!</span>")

		else if (istype(over_object,/obj/table/) && istype(over_object,/obj/rack/))
			var/obj/O = over_object
			src.output_location = O.loc
			boutput(usr, "<span style=\"color:blue\">You set the reclaimer to output on top of [O]!</span>")

		else if (istype(over_object,/turf/simulated/floor/))
			src.output_location = over_object
			boutput(usr, "<span style=\"color:blue\">You set the reclaimer to output to [over_object]!</span>")

		else

			boutput(usr, "<span style=\"color:red\">You can't use that as an output target.</span>")
		return

	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		if (!O || !user)
			return

		if(!istype(user,/mob/living/))
			boutput(user, "<span style=\"color:red\">Only living mobs are able to use the reclaimer's quick-load feature.</span>")
			return

		if (!istype(O,/obj/))
			boutput(user, "<span style=\"color:red\">You can't quick-load that.</span>")
			return

		if(get_dist(O,user) > 1)
			boutput(user, "<span style=\"color:red\">You are too far away!</span>")
			return

		if (istype(O, /obj/storage/crate/))
			user.visible_message("<span style=\"color:blue\">[user] uses [src]'s automatic loader on [O]!</span>", "<span style=\"color:blue\">You use [src]'s automatic loader on [O].</span>")
			var/amtload = 0
			for (var/obj/item/raw_material/M in O.contents)
				M.set_loc(src)
				amtload++
			if (amtload) boutput(user, "<span style=\"color:blue\">[amtload] materials loaded from [O]!</span>")
			else boutput(user, "<span style=\"color:red\">No material loaded!</span>")

		else if (istype(O, /obj/item/raw_material/) || istype(O, /obj/item/sheet/) || istype(O, /obj/item/rods/) || istype(O, /obj/item/tile/))
			quickload(user,O)
		else
			..()

	proc/quickload(var/mob/living/user,var/obj/item/O)
		if (!user || !O)
			return
		user.visible_message("<span style=\"color:blue\">[user] begins quickly stuffing [O] into [src]!</span>")
		var/staystill = user.loc
		for(var/obj/item/M in view(1,user))
			if (!M)
				continue
			if (M.name != O.name)
				continue
			if (!istype(M.material))
				continue
			if (M.material.material_flags & MATERIAL_CRYSTAL || M.material.material_flags & MATERIAL_METAL)
				M.set_loc(src)
				playsound(get_turf(src), sound_load, 40, 1)
				sleep(0.5)
			if (user.loc != staystill) break
		boutput(user, "<span style=\"color:blue\">You finish stuffing [O] into [src]!</span>")
		return

	proc/get_output_location()
		if (isnull(output_location))
			return src.loc

		if (get_dist(src.output_location,src) > 1)
			output_location = null
			return src.loc

		if (istype(output_location,/obj/machinery/manufacturer))
			var/obj/machinery/manufacturer/M = output_location
			if (M.stat & NOPOWER || M.stat & BROKEN | M.dismantle_stage > 0)
				return M.loc
			return M

		else if (istype(output_location,/obj/storage/crate))
			var/obj/storage/crate/C = output_location
			if (C.locked || C.welded || C.open)
				return C.loc
			return C

		return output_location