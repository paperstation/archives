
/obj/item/reagent_containers/food/snacks/plant/
	name = "fruit or vegetable"
	icon = 'icons/obj/foodNdrink/food_produce.dmi'
	var/datum/plant/planttype = null
	var/datum/plantgenes/plantgenes = null
	edible = 1     // Can this just be eaten as-is?
	var/generation = 0 // For genetics tracking.
	var/plant_reagent = null

	New()
		..()
		var/datum/plant/species = HY_get_species_from_path(src.planttype)
		if (species)
			src.planttype = species
		else
			if (ispath(src.planttype))
				src.planttype = new src.planttype(src)
			else
				qdel(src)
				return
		src.plantgenes = new /datum/plantgenes(src)

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (src.edible == 0)
			if (user == M)
				boutput(user, "<span style=\"color:red\">You can't just cram that in your mouth, you greedy beast!</span>")
				user.visible_message("<b>[user]</b> stares at [src] in a confused manner.")
			else
				user.visible_message("<span style=\"color:red\"><b>[user]</b> futilely attempts to shove [src] into [M]'s mouth!</span>")
			return
		..()

	streak(var/list/directions)
		spawn (0)
			var/direction = pick(directions)
			for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
				sleep(3)
				if (step_to(src, get_step(src, direction), 0))
					break
			throw_impact(get_turf(src))

/obj/item/reagent_containers/food/snacks/plant/tomato/
	name = "tomato"
	desc = "You say tomato, I toolbox you."
	icon_state = "tomato"
	planttype = /datum/plant/tomato
	amount = 1
	heal_amt = 1
	throwforce = 0
	force = 0
	plant_reagent = "juice_tomato"

	throw_impact(var/turf/T)
		..()
		src.visible_message("<span style=\"color:red\">[src] splats onto the floor messily!</span>")
		playsound(src.loc, "sound/effects/splat.ogg", 100, 1)
		new /obj/decal/cleanable/tomatosplat(T)
		qdel(src)

/obj/item/reagent_containers/food/snacks/plant/tomato/explosive
	name = "tomato"
	desc = "You say tomato, I toolbox you."
	var/lit = 0
	proc/ignite()
		if(src.lit) return
		src.lit = 1
		src.visible_message("<span style=\"color:red\">[src] catches fire!</span>")
		icon_state = "tomato-fire"
		sleep(rand(30,60))
		src.visible_message("<span style=\"color:red\">[src] explodes violently!</span>")
		playsound(src.loc, "sound/effects/splat.ogg", 100, 1)
		var/turf/T = get_turf(src) // we might have moved during the sleep, so figure out where we are
		if (T)
			new /obj/decal/cleanable/tomatosplat(T)
			T.hotspot_expose(700,125)
			explosion(src, T, -1, -1, 0, 1)
			qdel (src)

	throw_impact(var/turf/T)
		..()
		ignite()

	ex_act()
		..()
		ignite() //Griff

/obj/item/reagent_containers/food/snacks/plant/corn
	name = "corn cob"
	desc = "The assistants call it maize."
	icon_state = "corn"
	planttype = /datum/plant/corn
	amount = 3
	heal_amt = 1
	throwforce = 0
	force = 0
	food_color = "#FFFF00"
	plant_reagent = "cornstarch"
	var/popping = 0
	brewable = 1
	brew_result = "bourbon"

	temperature_expose(datum/gas_mixture/air, temperature, volume)
		if ((temperature > T0C + 232) && prob(50)) //Popcorn pops at about 232 degrees celsius.
			src.pop()
		return

	proc/pop() //Pop that corn!!
		if (popping)
			return

		popping = 1
		src.visible_message("<span style=\"color:red\">[src] pops violently!</span>")
		playsound(src.loc, "sound/effects/pop.ogg", 50, 1)
		flick("cornsplode", src)
		spawn(10)
			new /obj/item/reagent_containers/food/snacks/popcorn(get_turf(src))
			qdel(src)

/obj/item/reagent_containers/food/snacks/plant/soy
	name = "soybean pod"
	desc = "These soybeans are as close as two beans in a pod. Probably because they are literally beans in a pod."
	planttype = /datum/plant/soy
	icon_state = "soy"
	amount = 3
	heal_amt = 1
	throwforce = 0
	force = 0
	food_color = "#4A7402"
	plant_reagent = "grease"

/obj/item/reagent_containers/food/snacks/plant/soylent
	name = "soylent chartreuse"
	desc = "Contains high-energy plankton!"
	planttype = /datum/plant/soy
	icon_state = "soylent"
	amount = 3
	heal_amt = 2
	throwforce = 0
	force = 0
	food_color = "#BBF33D"

/obj/item/reagent_containers/food/snacks/plant/orange/
	name = "orange"
	desc = "Bitter."
	icon_state = "orange"
	planttype = /datum/plant/orange
	amount = 3
	heal_amt = 1
	food_color = "#FF8C00"
	plant_reagent = "juice_orange"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/food/snacks/ingredient/meat/synthmeat))
			boutput(user, "<span style=\"color:blue\">You combine the [src] and [W] to create a Synthorange!</span>")
			var/obj/item/reagent_containers/food/snacks/plant/orange/synth/P = new(W.loc)
			user.u_equip(W)
			user.put_in_hand_or_drop(P)
			var/datum/plantgenes/DNA = src.plantgenes
			var/datum/plantgenes/PDNA = P.plantgenes
			HYPpassplantgenes(DNA,PDNA)
			qdel(W)
			qdel(src)
		else if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher) && !istype (src, /obj/item/reagent_containers/food/snacks/plant/orange/wedge))
			if (istype (src, /obj/item/reagent_containers/food/snacks/plant/orange/wedge))
				boutput(user, "<span style=\"color:red\">You can't cut wedges into wedges! What kind of insanity is that!?</span>")
				return
			var/turf/T = get_turf(src)
			user.visible_message("[user] cuts [src] into slices.", "You cut [src] into slices.")
			var/makeslices = 6
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/plant/orange/wedge/P = new(T)
				var/datum/plantgenes/DNA = src.plantgenes
				var/datum/plantgenes/PDNA = P.plantgenes
				HYPpassplantgenes(DNA,PDNA)
				makeslices -= 1
			qdel (src)
		..()

/obj/item/reagent_containers/food/snacks/plant/orange/wedge
	name = "orange wedge"
	icon = 'icons/obj/drink.dmi'
	icon_state = "old-orange"
	initial_volume = 6
	throwforce = 0
	w_class = 1.0
	amount = 1

	New()
		..()
		reagents.add_reagent("juice_orange",5)

/obj/item/reagent_containers/food/snacks/plant/orange/clockwork
	name = "clockwork orange"
	desc = "You probably shouldn't eat this, unless you happen to be able to eat metal."
	icon_state = "orange-clockwork"

	get_desc()
		. += "[pick("The time is", "It's", "It's currently", "It reads", "It says")] [o_clock_time()]."

	heal(var/mob/living/M)
		..()
		boutput(M, "<span style=\"color:red\">Eating that was a terrible idea!</span>")
		random_brute_damage(M, rand(5, 15))
		M.updatehealth()

/obj/item/reagent_containers/food/snacks/plant/orange/synth
	name = "synthorange"
	desc = "Bitter. Moreso."
	icon_state = "orange"
	amount = 3
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/plant/grape/
	name = "grapes"
	desc = "Not the green ones."
	icon_state = "grapes"
	planttype = /datum/plant/grape
	amount = 5
	heal_amt = 1
	food_color = "#FF00FF"
	brewable = 1
	brew_result = "wine"

/obj/item/reagent_containers/food/snacks/plant/grape/green
	name = "grapes"
	desc = "Not the purple ones."
	icon_state = "Ggrapes"
	amount = 5
	heal_amt = 2
	food_color = "#AAFFAA"
	brew_result = "white_wine"

/obj/item/reagent_containers/food/snacks/plant/melon/
	name = "melon"
	desc = "You should cut it into slices first!"
	icon_state = "melon"
	planttype = /datum/plant/melon
	throwforce = 8
	w_class = 3.0
	edible = 0
	food_color = "#7FFF00"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			var/turf/T = get_turf(src)
			user.visible_message("[user] cuts [src] into slices.", "You cut [src] into slices.")
			var/makeslices = 6
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/plant/melonslice/P = new(T)
				var/datum/plantgenes/DNA = src.plantgenes
				var/datum/plantgenes/PDNA = P.plantgenes
				HYPpassplantgenes(DNA,PDNA)
				makeslices -= 1
			qdel (src)
		..()

/obj/item/reagent_containers/food/snacks/plant/melonslice/
	name = "melon slice"
	desc = "That's better!"
	icon_state = "melon_slice"
	planttype = /datum/plant/melon
	throwforce = 0
	w_class = 1.0
	amount = 1
	heal_amt = 2
	food_color = "#7FFF00"

/obj/item/reagent_containers/food/snacks/plant/melon/george
	name = "rainbow melon"
	desc = "Sometime in the year 2472 these melons were required to have their name legally changed to protect the not-so-innocent. Also for tax evasion reasons."
	icon_state = "george_melon"
	throwforce = 0
	w_class = 3.0
	edible = 0
	initial_volume = 60

	New()
		..()
		reagents.add_reagent("george_melonium",50)

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			var/turf/T = get_turf(src)
			user.visible_message("[user] cuts [src] into slices.", "You cut [src] into slices.")
			var/makeslices = 6
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/plant/melonslice/george/P = new(T)
				var/datum/plantgenes/DNA = src.plantgenes
				var/datum/plantgenes/PDNA = P.plantgenes
				HYPpassplantgenes(DNA,PDNA)
				makeslices -= 1
			qdel (src)
		..()

	throw_impact(atom/hit_atom)
		..()
		if (ismob(hit_atom) && prob(50))
			var/mob/M = hit_atom
			hit_atom.visible_message("<span style=\"color:red\">[src] explodes from the sheer force of the blow!</span>")
			playsound(src.loc, "sound/effects/bang.ogg", 100, 1)
			random_brute_damage(M, 10)
			if (istype(M, /mob/living/carbon/))
				M.paralysis += 2
				M.stunned += 6
				M.take_brain_damage(15)
			qdel (src)

/obj/item/reagent_containers/food/snacks/plant/melonslice/george
	name = "rainbow melon slice"
	desc = "A slice of a particularly special melon. Previously went by a different name but then it got married or something THIS IS HOW MELON NAMES WORK OKAY"
	icon_state = "george_melon_slice"
	throwforce = 5
	w_class = 1.0
	amount = 1
	heal_amt = 2
	plant_reagent = "george_melonium"
	initial_volume = 30

	New()
		..()
		reagents.add_reagent("george_melonium",25)


/obj/item/reagent_containers/food/snacks/plant/chili/
	name = "chili pepper"
	desc = "Caution: May or may not be red hot."
	icon_state = "chili"
	planttype = /datum/plant/chili
	w_class = 1.0
	amount = 1
	heal_amt = 2
	plant_reagent = "capsaicin"
	initial_volume = 100

	New()
		..()
		var/datum/plantgenes/DNA = src.plantgenes
		reagents.add_reagent("capsaicin", DNA.potency)

/obj/item/reagent_containers/food/snacks/plant/chili/chilly
	name = "chilly pepper"
	desc = "It's cold to the touch."
	icon_state = "chilly"
	//planttype = /datum/plant/chili
	w_class = 1.0
	amount = 1
	heal_amt = 2
	food_color = "#00CED1"
	plant_reagent = "cryostylane"
	initial_volume = 100

	New()
		..()
		var/datum/plantgenes/DNA = src.plantgenes
		reagents.add_reagent("cryostylane", DNA.potency)

	heal(var/mob/M)
		M:emote("shiver")
		var/datum/plantgenes/DNA = src.plantgenes
		M.bodytemperature -= DNA.potency
		boutput(M, "<span style=\"color:red\">You feel cold!</span>")

/obj/item/reagent_containers/food/snacks/plant/chili/ghost_chili
	name = "ghostlier chili"
	desc = "Naga Jolokia, or Ghost Chili, is a chili pepper previously recognized by Guinness World Records as the hottest pepper in the world. This one, found in space, is even hotter."
	icon_state = "ghost_chili"
	//planttype = /datum/plant/chili
	w_class = 1.0
	amount = 1
	heal_amt = 1
	food_color = "#FFFF00"
	plant_reagent = "ghostchilijuice"
	initial_volume = 30

	New()
		..()
		reagents.add_reagent("ghostchilijuice",25)

	heal(var/mob/M)
		M:emote("twitch")
		var/datum/plantgenes/DNA = src.plantgenes
		boutput(M, "<span style=\"color:red\">Fuck! Your mouth feels like it's on fire!</span>")
		M.bodytemperature += (DNA.potency * 5)


/obj/item/reagent_containers/food/snacks/plant/lettuce/
	name = "lettuce leaf"
	desc = "Not spinach at all. Nope. Nuh-uh."
	icon_state = "spinach"
	planttype = /datum/plant/lettuce
	w_class = 1.0
	amount = 1
	heal_amt = 1
	food_color = "#008000"

/obj/item/reagent_containers/food/snacks/plant/cucumber/
	name = "cucumber"
	desc = "A widely-cultivated gourd, often served on sandwiches or pickled.  Not actually known for saving any kingdoms."
	icon_state = "cucumber"
	planttype = /datum/plant/cucumber
	w_class = 1
	amount = 2
	heal_amt = 1
	food_color = "#008000"

/obj/item/reagent_containers/food/snacks/plant/strawberry/
	name = "strawberry"
	desc = "A freshly picked strawberry."
	icon_state = "strawberry"
	planttype = /datum/plant/strawberry
	amount = 1
	heal_amt = 1
	food_color = "#FF2244"
	plant_reagent = "juice_strawberry"

/obj/item/reagent_containers/food/snacks/plant/apple/
	name = "apple"
	desc = "Implied by folklore to repel medical staff."
	icon_state = "apple"
	planttype = /datum/plant/apple
	amount = 3
	heal_amt = 1
	brewable = 1
	brew_result = "cider"

	heal(var/mob/M)
		M.HealDamage("All", src.heal_amt, src.heal_amt)
		M.take_toxin_damage(0 - src.heal_amt)
		M.take_oxygen_deprivation(0 - src.heal_amt)
		M.take_brain_damage(0 - src.heal_amt)

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/rods))
			boutput(user, "<span style=\"color:blue\">You create an apple on a stick...</span>")
			new/obj/item/reagent_containers/food/snacks/plant/apple/stick(get_turf(src))
			W:amount--
			if(!W:amount) qdel(W)
			qdel(src)
		else ..()

//Apple on a stick
/obj/item/reagent_containers/food/snacks/plant/apple/stick
	name = "apple on a stick"
	desc = "An apple on a stick."
	icon_state = "apple stick"

/obj/item/reagent_containers/food/snacks/plant/banana
	name = "unpeeled banana"
	desc = "Cavendish, of course."
	icon_state = "banana"
	planttype = /datum/plant/banana
	amount = 2
	heal_amt = 2
	food_color = "#FFFF00"
	plant_reagent = "potassium"

	heal(var/mob/M)
		if (src.icon_state == "banana")
			M.visible_message("<span style=\"color:red\">[M] eats [src] without peeling it. What a dumb beast!</span>")
			M.take_toxin_damage(5)
			qdel (src)

	attack_self(var/mob/user as mob)
		if (src.icon_state == "banana")
			if(user.bioHolder.HasEffect("clumsy") && prob(50))
				user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles and pokes \himself in the eye with [src].</span>")
				user.change_eye_blurry(5)
				user.weakened = max(3, user.weakened)
				return
			boutput(user, "<span style=\"color:blue\">You peel [src].</span>")
			src.name = "banana"
			src.icon_state = "banana-fruit"
			new /obj/item/bananapeel(user.loc)

/obj/item/reagent_containers/food/snacks/plant/carrot
	name = "carrot"
	desc = "Think of how many snowmen were mutilated to power the carrot industry."
	icon_state = "carrot"
	planttype = /datum/plant/carrot
	w_class = 1.0
	amount = 3
	heal_amt = 1
	food_color = "#FF9900"

/obj/item/reagent_containers/food/snacks/plant/pumpkin
	name = "pumpkin"
	desc = "Spooky!"
	planttype = /datum/plant/pumpkin
	icon_state = "pumpkin"
	edible = 0
	food_color = "#CC6600"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			user.visible_message("[user] carefully and creatively carves [src].", "You carefully and creatively carve [src]. Spooky!")
			new /obj/item/clothing/head/pumpkin(user.loc)
			qdel (src)

/obj/item/clothing/head/pumpkin
	name = "carved pumpkin"
	desc = "Spookier!"
	icon_state = "pumpkin"
	c_flags = COVERSEYES | COVERSMOUTH
	see_face = 0.0
	item_state = "pumpkin"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/device/flashlight))
			user.visible_message("[user] adds [W] to [src].", "You add [W] to [src].")
			W.name = "pumpkin lantern"
			W.desc = "Spookiest!"
			W.icon = 'icons/misc/halloween.dmi'
			W.icon_state = "flight[W:on]"
			W.item_state = "pumpkin"
			qdel (src)
		else
			..()

/obj/item/reagent_containers/food/snacks/plant/lime
	name = "lime"
	desc = "A very sour green fruit."
	icon_state = "lime"
	planttype = /datum/plant/lime
	amount = 2
	heal_amt = 1
	food_color = "#008000"
	plant_reagent = "juice_lime"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			if (istype (src, /obj/item/reagent_containers/food/snacks/plant/lime/wedge))
				boutput(user, "<span style=\"color:red\">You can't cut wedges into wedges! What kind of insanity is that!?</span>")
				return
			var/turf/T = get_turf(src)
			user.visible_message("[user] cuts [src] into slices.", "You cut [src] into slices.")
			var/makeslices = 6
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/plant/lime/wedge/P = new(T)
				var/datum/plantgenes/DNA = src.plantgenes
				var/datum/plantgenes/PDNA = P.plantgenes
				HYPpassplantgenes(DNA,PDNA)
				makeslices -= 1
			qdel (src)
		..()

/obj/item/reagent_containers/food/snacks/plant/lime/wedge
	name = "lime wedge"
	icon = 'icons/obj/drink.dmi'
	icon_state = "old-lime"
	throwforce = 0
	w_class = 1.0
	amount = 1
	initial_volume = 6

	New()
		..()
		reagents.add_reagent("juice_lime",5)

/obj/item/reagent_containers/food/snacks/plant/lemon/
	name = "lemon"
	desc = "Suprisingly not a commentary on the station's workmanship."
	icon_state = "lemon"
	planttype = /datum/plant/lemon
	amount = 2
	heal_amt = 1
	food_color = "#FFFF00"
	plant_reagent = "juice_lemon"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/axe) || istype(W, /obj/item/circular_saw) || istype(W, /obj/item/kitchen/utensil/knife) || istype(W, /obj/item/scalpel) || istype(W, /obj/item/sword) || istype(W,/obj/item/saw) || istype(W,/obj/item/knife_butcher))
			if (istype (src, /obj/item/reagent_containers/food/snacks/plant/lemon/wedge))
				boutput(user, "<span style=\"color:red\">You can't cut wedges into wedges! What kind of insanity is that!?</span>")
				return
			var/turf/T = get_turf(src)
			user.visible_message("[user] cuts [src] into slices.", "You cut [src] into slices.")
			var/makeslices = 6
			while (makeslices > 0)
				var/obj/item/reagent_containers/food/snacks/plant/lemon/wedge/P = new(T)
				var/datum/plantgenes/DNA = src.plantgenes
				var/datum/plantgenes/PDNA = P.plantgenes
				HYPpassplantgenes(DNA,PDNA)
				makeslices -= 1
			qdel (src)
		..()

/obj/item/reagent_containers/food/snacks/plant/lemon/wedge
	name = "lemon wedge"
	icon = 'icons/obj/drink.dmi'
	icon_state = "old-lemon"
	throwforce = 0
	w_class = 1.0
	amount = 1
	initial_volume = 6

	New()
		..()
		reagents.add_reagent("juice_lemon",5)

/obj/item/reagent_containers/food/snacks/plant/slurryfruit/
	name = "slurrypod"
	desc = "An extremely poisonous, bitter fruit.  The slurrypod fruit is regarded as a delicacy in some outer colony worlds."
	icon_state = "slurry"
	planttype = /datum/plant/slurrypod
	amount = 1
	heal_amt = -1
	food_color = "#008000"
	plant_reagent = "toxic_slurry"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("toxic_slurry", rand(10,50))

/obj/item/reagent_containers/food/snacks/plant/slurryfruit/omega
	name = "omega slurrypod"
	desc = "An extremely poisonous, bitter fruit.  A strange light pulses from within."
	icon_state = "slurrymut"
	amount = 1
	heal_amt = -1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("toxic_slurry", rand(30,45))
		if(prob(50))
			reagents.add_reagent("omega_mutagen",5)

/obj/item/reagent_containers/food/snacks/plant/peanuts
	name = "peanuts"
	desc = "A pile of peanuts."
	icon_state = "peanuts"
	planttype = /datum/plant/peanut
	amount = 1
	heal_amt = 2
	food_color = "#D2691E"

	/* drsingh todo: peanut shells and requiring roasting shelling
	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/kitchen/utensil/knife) || istype(W,/obj/item/knife_butcher))
			if (src.icon_state == "potato")
				user.visible_message("[user] peels [src].", "You peel [src].")
				src.icon_state = "potato-peeled"
				src.desc = "It needs to be cooked."
			else if (src.icon_state == "potato-peeled")
				user.visible_message("[user] chops up [src].", "You chop up [src].")
				new /obj/item/reagent_containers/food/snacks/ingredient/chips(get_turf(src))
				qdel (src)
		else ..()
	*/

/obj/item/reagent_containers/food/snacks/plant/potato/
	name = "potato"
	desc = "It needs peeling first."
	icon_state = "potato"
	planttype = /datum/plant/potato
	amount = 1
	heal_amt = 0
	food_color = "#F0E68C"
	brewable = 1
	brew_result = "vodka"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/kitchen/utensil/knife) || istype(W,/obj/item/knife_butcher))
			if (src.icon_state == "potato")
				user.visible_message("[user] peels [src].", "You peel [src].")
				src.icon_state = "potato-peeled"
				src.desc = "It needs to be cooked."
			else if (src.icon_state == "potato-peeled")
				user.visible_message("[user] chops up [src].", "You chop up [src].")
				new /obj/item/reagent_containers/food/snacks/ingredient/chips(get_turf(src))
				qdel (src)
		else ..()

	heal(var/mob/M)
		boutput(M, "<span style=\"color:red\">Raw potato tastes pretty nasty...</span>")

/obj/item/reagent_containers/food/snacks/plant/onion
	name = "onion"
	desc = "A yellow onion bulb. This little bundle of fun tends to irritate eyes when cut as a result of a fascinating chemical reaction."
	icon_state = "onion"
	planttype = /datum/plant/onion
	food_color = "#FF9933"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/kitchen/utensil/knife) || istype(W,/obj/item/knife_butcher))
			user.visible_message("[user] chops up [src].", "You chop up [src].")
			for (var/mob/living/carbon/M in range(user, 2))
				if (prob(50) && M.stat != 2)
					M.emote("cry")

			var/x = rand(3,5)
			var/turf/T = get_turf(user)
			while (x-- > 0)
				new /obj/item/reagent_containers/food/snacks/onion_slice(T)

			qdel(src)
		else
			..()

/obj/item/reagent_containers/food/snacks/onion_slice
	name = "onion ring"
	desc = "A sliced ring of onion. When fried, makes a side dish perfectly suited to being overlooked in favor of french fries."
	icon = 'icons/obj/foodNdrink/food_snacks.dmi'
	icon_state = "onion_ring"
	food_color = "#B923EB"
	amount = 1

/obj/item/reagent_containers/food/snacks/plant/garlic
	name = "garlic"
	desc = "The natural enemy of the common Dracula (H. Sapiens Lugosi)."
	icon_state = "garlic"
	planttype = /datum/plant/garlic
	food_color = "#FEFEFE"
	initial_volume = 10

	New()
		..()
		reagents.add_reagent("water_holy", 10)

/obj/item/reagent_containers/food/snacks/plant/avocado
	name = "avocado"
	desc = "The immense berry of a Mexican tree, the avocado is rich in monounsaturated fat, fiber, and potassium.  It is also poisonous to birds and horses."
	icon_state = "avocado"
	planttype = /datum/plant/avocado
	food_color = "#007B1C"
	heal_amt = 2

/obj/item/reagent_containers/food/snacks/plant/eggplant
	name = "eggplant"
	desc = "A close relative of the tomato and potato, the eggplant is notable for being large and purple."
	icon_state = "eggplant"
	planttype = /datum/plant/eggplant
	food_color = "#420042"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("nicotine", 4.58) //EGGPLANT FACT: They contain about 1.1% the nicotine of a cigarette per 100g.

/obj/item/reagent_containers/food/snacks/plant/lashberry/
	name = "lashberry"
	desc = "Not nearly as violent as the plant it came from."
	icon_state = "lashberry"
	planttype = /datum/plant/lasher
	amount = 4
	heal_amt = 2
	food_color = "#FF00FF"

// Weird alien fruit

/obj/item/reagent_containers/food/snacks/plant/purplegoop
	name = "wad of purple goop"
	desc = "Um... okay then."
	icon_state = "yuckpurple"
	planttype = /datum/plant/artifact/dripper
	amount = 1
	heal_amt = 0
	food_color = "#9865c5"
	initial_volume = 25

	New()
		..()
		reagents.add_reagent("yuck", 20)

/obj/item/reagent_containers/food/snacks/plant/glowfruit
	name = "glowing fruit"
	desc = "This might be a handy light source."
	icon_state = "glowfruit"
	planttype = /datum/plant/artifact/litelotus
	amount = 4
	heal_amt = 1
	luminosity = 3
	food_color = "#ccccff"
