/obj/decal/ash
	name = "Ashes"
	desc = "Ashes to ashes, dust to dust."
	icon = 'objects.dmi'
	icon_state = "ash"
	anchored = 1

/obj/decal/remains/human
	name = "remains"
	desc = "These remains have a strange sense about them..."
	icon = 'blood.dmi'
	icon_state = "remains"
	anchored = 1

/obj/decal/remains/xeno
	name = "remains"
	desc = "These remains have a strange sense about them..."
	icon = 'blood.dmi'
	icon_state = "remainsxeno"
	anchored = 1

/obj/decal/remains/robot
	name = "remains"
	desc = "These remains have a strange sense about them..."
	icon = 'robots.dmi'
	icon_state = "remainsrobot"
	anchored = 1

/obj/decal/point
	name = "point"
	icon = 'screen1.dmi'
	icon_state = "arrow"
	layer = 16.0
	anchored = 1

/obj/decal/cleanable
	var/list/random_icon_states = list()
	var/decaltype = null

//HUMANS

/obj/decal/cleanable/blood
	name = "Blood"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/datum/disease/virus = null
	blood_DNA = null
	blood_type = null

	Del()
		if(virus)
			virus.cure(0)
		..()

/obj/decal/cleanable/blood/smear
	name = "Blood"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "smear1"
	random_icon_states = null

/obj/decal/cleanable/blood/jail
	name = "Blood Writing"
	desc = "It's easy getting ink, if you know how.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "prison1"
	random_icon_states = null

/obj/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/decal/cleanable/blood/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "Grisly..."
	density = 0
	anchored = 0
	layer = 2
	icon = 'blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")

/obj/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

//ALIENS

/obj/decal/cleanable/xenoblood
	name = "xeno blood"
	desc = "It's green."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")
	var/datum/disease/virus = null

	Del()
		if(virus)
			virus.cure(0)
		..()

/obj/decal/cleanable/xenoblood/xsplatter
	random_icon_states = list("xgibbl1", "xgibbl2", "xgibbl3", "xgibbl4", "xgibbl5")

/obj/decal/cleanable/xenoblood/xgibs
	name = "xeno gibs"
	desc = "Gnarly..."
	icon = 'blood.dmi'
	icon_state = "xgib1"
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6")

/obj/decal/cleanable/xenoblood/xgibs/body
	random_icon_states = list("xgibhead", "xgibtorso")

/obj/decal/cleanable/xenoblood/xgibs/limb
	random_icon_states = list("xgibleg", "xgibarm")

/obj/decal/cleanable/xenoblood/xgibs/core
	random_icon_states = list("xgibmid1", "xgibmid2", "xgibmid3")

/obj/decal/cleanable/blood/xtracks
	icon_state = "xtracks"
	random_icon_states = null

//ROBOTS

/obj/decal/cleanable/robot_debris
	name = "robot debris"
	desc = "Useless heap of junk."
	density = 0
	anchored = 0
	layer = 2
	icon = 'robots.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")

/obj/decal/cleanable/robot_debris/limb
	random_icon_states = list("gibarm", "gibleg")

/obj/decal/cleanable/oil
	name = "motor oil"
	desc = "It's black."
	density = 0
	anchored = 1
	layer = 2
	icon = 'robots.dmi'
	icon_state = "floor1"
	var/datum/disease/virus = null
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")

	Del()
		if(virus)
			virus.cure(0)
		..()

/obj/decal/cleanable/oil/streak
	random_icon_states = list("streak1", "streak2", "streak3", "streak4", "streak5")

//OTHER

/obj/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	density = 0
	anchored = 1
	layer = 2
	icon = 'objects.dmi'
	icon_state = "shards"

/obj/decal/cleanable/tomatosplat
	name = "Splattered tomato"
	desc = "What a mess."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")

/obj/decal/cleanable/eggsplat
	name = "Splattered egg"
	desc = "What a mess."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "eggsplat"

/obj/decal/cleanable/poo
	name = "Poo stain"
	desc = "It's a poo stain..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "shitfloor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")
	var/datum/disease/virus = null
	var/dried = 0
	decaltype = "poo"
	blood_DNA = null
	blood_type = null

/obj/decal/cleanable/urine
	name = "Urine puddle"
	desc = "Someone couldn't hold it.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "pee1"
	random_icon_states = list("pee1", "pee2", "pee3")
	var/datum/disease/virus = null
	decaltype = "urine"
	blood_DNA = null
	blood_type = null

/obj/decal/cleanable/cum
	name = "cum"
	desc = "Uh oh, better clean this up..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "cum1"
	random_icon_states = list("cum1", "cum2", "cum3", "cum4", "cum5")
	var/datum/disease/virus = null
	decaltype = "cum"
	blood_DNA = null
	blood_type = null

/obj/decal/cleanable/vomit
	name = "vomit"
	desc = "Looks like someone's been really drunk again."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "vomit1"
	random_icon_states = list("vomit1", "vomit2", "vomit3")
	var/datum/disease/virus = null
	decaltype = "vomit"
	blood_DNA = null
	blood_type = null

/obj/decal/cleanable/hair
	name = "hair"
	desc = "Looks like someone has had their hair cut."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "hair1"
	random_icon_states = list("hair1", "hair2", "hair3")
	var/datum/disease/virus = null
	decaltype = "hair"
	blood_DNA = null
	blood_type = null

/obj/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	density = 0
	anchored = 1
	layer = 2
	icon = 'old_or_unused.dmi'
	icon_state = "dirt"
	decaltype = "carbon"
	mouse_opacity = 0

/obj/decal/cleanable/greenglow
	name = "green glow"
	desc = "Eerie."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "greenglow"
	decaltype = "radium"

/obj/decal/cleanable/foam
	name = "foam"
	desc = "It's foam, dumbshit."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "foam"
	decaltype = "foam"

/obj/decal/cleanable/chemical
	name = "spill"
	desc = "Holy fucking shit!"
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "blankicon"
	decaltype = "blankicon"

/obj/decal/cleanable/chemical/New()
	spawn(600)
	del(src)

/obj/decal/cleanable/foam/New()
	spawn(180)
	del(src)

/obj/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Someone should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'old_or_unused.dmi'
	icon_state = "cobweb1"

/obj/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "huh."
	density = 0
	anchored = 1
	layer = 3
	icon = 'chemical.dmi'
	icon_state = "molten"

/obj/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Someone should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'old_or_unused.dmi'
	icon_state = "cobweb2"

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/decal/spraystill
	density = 0
	anchored = 1
	layer = 50

/obj/decal/cleanable/poo/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(5) src.reagents.add_reagent("poo",5)
	spawn(400)
		src.dried = 1

/obj/decal/cleanable/poo/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				var/obj/decal/cleanable/poo/b = new /obj/decal/cleanable/poo(src.loc)
				if (src.virus)
					b.virus = src.virus
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/decal/cleanable/poo/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon) && src.dried == 0)
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		M.pulling = null
		M << "\blue You slipped on the wet poo stain!"
		M.achievement_give("Oh Shit!", 18, 50)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 10
		M.weakened = 8

/obj/decal/cleanable/urine/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		M.pulling = null
		M << "\blue You slipped in the urine puddle!"
		M.achievement_give("Pissed!", 17, 30)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/decal/cleanable/urine/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
	..()
	spawn(800)
		del(src)

/obj/decal/cleanable/cum/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
	..()
	spawn(800)
		del(src)