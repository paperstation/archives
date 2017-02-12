/obj/decal/New()
	..()
	src.pixel_x = rand(-3.0, 3)
	src.pixel_y = rand(-3.0, 3)
	/*
	var/decalcount = 0
	if(locate(/obj/decal/) in src.loc)
		for(var/obj/decal/g in src.loc)
			if(decalcount >= 3)
				spawn(5)
					del(g)
			decalcount++
	*/

/obj/decal/ash
	name = "Ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
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
	desc = "It is an arrow hanging in mid-air. There may be a wizard about."
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
	desc = "It's red. Its Gooye. It is the chefs cooking perhaps."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/list/viruses = list()
	blood_DNA = null
	blood_type = null
	var/mob/blood_owner = null
/*
	Del()
		for(var/datum/disease/D in viruses)
			D.cure(0)
		..()*/

/obj/decal/cleanable/blood/proc/bloodspread(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(3, 200; 4, 150; 5, 50; 6), i++)
			sleep(3)
//			if (i > 0)
//				var/obj/decal/cleanable/blood/b = new /obj/decal/cleanable/blood(src.loc)
//				if (src.virus)
//					b.virus = src.virus
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's red."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "drip1"
	random_icon_states = list("drip1", "drip2", "drip3", "drip4", "drip5")
	blood_DNA = null
	blood_type = null

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
	desc = "Grisly...and not the good kind neither."
	density = 0
	anchored = 0
	layer = 2
	icon = 'blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")

/obj/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/decal/cleanable/generic
	name = "Ashes"
	icon = 'objects.dmi'

//ALIENS

/obj/decal/cleanable/xenoblood
	name = "xeno blood"
	desc = "It's green. Must be more of the chefs cooking."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")
	var/list/viruses = list()

	Del()
		for(var/datum/disease/D in viruses)
			D.cure(0)
		..()

/obj/decal/cleanable/xenoblood/xsplatter
	random_icon_states = list("xgibbl1", "xgibbl2", "xgibbl3", "xgibbl4", "xgibbl5")

/obj/decal/cleanable/xenoblood/xgibs
	name = "xeno gibs"
	desc = "Gnarly..."
	icon = 'blood.dmi'
	icon_state = "xgib1"
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6")

/obj/decal/cleanable/xenoblood/xgibs/up
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibup1","xgibup1","xgibup1")

/obj/decal/cleanable/xenoblood/xgibs/down
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibdown1","xgibdown1","xgibdown1")

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
	desc = "Useless heap of junk...or is it..."
	density = 0
	anchored = 0
	layer = 2
	icon = 'robots.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")

/obj/decal/cleanable/robot_debris/limb
	random_icon_states = list("gibarm", "gibleg")

/obj/decal/cleanable/robot_debris/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7","gibup1","gibup1") //2:7 is close enough to 1:4

/obj/decal/cleanable/robot_debris/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7","gibdown1","gibdown1") //2:7 is close enough to 1:4

/obj/decal/cleanable/oil
	name = "motor oil"
	desc = "It's black. Beepsky made another mess."
	density = 0
	anchored = 1
	layer = 2
	icon = 'robots.dmi'
	icon_state = "floor1"
	var/viruses = list()
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
/*
	Del()
		for(var/datum/disease/D in viruses)
			D.cure(0)
		..()*/

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
	name = "poo"
	desc = "It's a poo stain..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")
//	var/datum/disease/virus = null
	var/dried = 0
	decaltype = "poo"
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/poo/New()
	src.icon = 'pooeffect.dmi'
	src.icon_state = pick(src.random_icon_states)
//	spawn(5) src.reagents.add_reagent("poo",5)
	spawn(400)
		src.dried = 1

/obj/decal/cleanable/poo/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/decal/cleanable/poo/drip
	name = "drips of poo"
	desc = "It's brown."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "drip1"
	random_icon_states = list("drip1", "drip2", "drip3", "drip4", "drip5")
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/poo/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			//if (i > 0)
			//	var/obj/decal/cleanable/poo/b = new /obj/decal/cleanable/poo(src.loc)
			//	if (src.virus)
			//		b.virus = src.virus
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/decal/cleanable/poo/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon) && src.dried == 0)
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		M.pulling = null
		M << "\blue You slipped on the wet poo stain!"
		M.achievement_give("Oh Shit!", 68)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 6
		M.weakened = 5

/obj/decal/cleanable/poo/tracks/HasEntered(AM as mob|obj)
	return

/obj/decal/cleanable/poo/drip/HasEntered(AM as mob|obj)
	return

/obj/decal/cleanable/urine
	name = "Urine puddle"
	desc = "Someone couldn't hold it.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "pee1"
	random_icon_states = list("pee1", "pee2", "pee3")
//	var/datum/disease/virus = null
	decaltype = "urine"
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/urine/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		M.pulling = null
		M << "\blue You slipped in the urine puddle!"
		M.achievement_give("Pissed!", 69)
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 8
		M.weakened = 5

/obj/decal/cleanable/urine/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
//	..()
	spawn(800)
		del(src)

/obj/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "dirt"

/obj/decal/cleanable/greenglow
	name = "green glow"
	desc = "Eerie. This makes you feel creepy."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "greenglow"

/obj/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Someone should remove that."
	density = 0
	anchored = 1
	layer = 3
	icon = 'effects.dmi'
	icon_state = "cobweb1"

/obj/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "Huh. Creepy..."
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
	icon = 'effects.dmi'
	icon_state = "cobweb2"

// Used for spray that you spray at walls, tables, hydrovats etc
/obj/decal/spraystill
	density = 0
	anchored = 1
	layer = 50

/obj/decal/cleanable/foam
	name = "foam"
	desc = "It's foam, dumbshit."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "foam"

/obj/decal/cleanable/foam/New()
	spawn(80)
	del(src)

/obj/decal/cleanable/cum
	name = "cum"
	desc = "Uh oh, better clean this up..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "cum1"
	random_icon_states = list("cum1", "cum2", "cum3", "cum4", "cum5")
//	var/datum/disease/virus = null
	decaltype = "cum"
//	blood_DNA = null
//	blood_type = null

/obj/decal/cleanable/cum/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
//	..()
//	spawn(800)
//		del(src)

/obj/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	density = 0
	anchored = 1
	layer = 2
	icon = 'blood.dmi'
	icon_state = "vomit1"
	decaltype = "vomit"
	random_icon_states = list("vomit1", "vomit2", "vomit3")
	/*var/list/viruses = list()

	Del()
		for(var/datum/disease/D in viruses)
			D.cure(0)
		..()*/

// ITT DECAL SCRAPING WITH CLOTHES
/obj/decal/cleanable/attackby(var/obj/item/I as obj, var/mob/user as mob)
	..()
	if(istype(I, /obj/item/clothing/))
		I:name = "[src.name] covered [I:name]"
		del(src)

#define SOLID 1
#define LIQUID 2
#define GAS 3

/obj/decal/cleanable/chemical
	name = "spill"
	desc = "A chemical spill."
	density = 0
	anchored = 1
	layer = 2
	icon = 'effects.dmi'
	icon_state = "blankicon"
	var/datum/reagent/reagent_primary
	var/datum/reagent/reagent_secondary
	var/age = 0.0

/obj/decal/cleanable/chemical/New()
	spawn(10)
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		if(reagents)
			if(reagents.total_volume)
				update_icon()
				process()
			else
				del(src)

/obj/decal/cleanable/chemical/proc/process()
	if(reagents)
		if(reagents.total_volume)
			reagent_primary = reagents.get_master_reagent_reference()
			if(reagents.reagent_list.len > 1)
				reagent_secondary = reagents.get_secondary_reagent_reference()
				var/obj/decal/cleanable/chemical/C = new /obj/decal/cleanable/chemical
				C.loc = loc
				reagents.trans_id_to(C, reagent_secondary, reagent_secondary.volume)
			for(var/obj/decal/cleanable/chemical/S in src.loc)
				if(type == S.type)
					if(reagents.get_master_reagent_name() == S.reagents.get_master_reagent_name())
						S.reagents.trans_to(src, S.reagents.total_volume)
						del(S)
			if(isturf(src.loc))
				temperature_expose(null, src.loc:temperature, null)
				update_icon()
			spawn(20)
				checkevaporation()
				if(src)
					process()
		else
			del(src)

/obj/decal/cleanable/chemical/proc/checkevaporation()
	age += 10
	if(reagent_primary.reagent_state == SOLID)
		return
	if((reagent_primary.reagent_state == LIQUID) && age >= 600)
		del(src)
	if((reagent_primary.reagent_state == GAS) && age >= 60)
		del(src)
	else
		del(src)

/obj/decal/cleanable/chemical/update_icon()
	if(reagent_primary.reagent_state == SOLID)
		icon_state = "chemicalsolid"
	if(reagent_primary.reagent_state == LIQUID)
		icon_state = "chemicalliquid"
	if(reagent_primary.reagent_state == GAS)
		icon_state = "chemicalgas"

/obj/decal/cleanable/chemical/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/))
		if(reagent_primary.reagent_state == SOLID)
			if(reagents.total_volume)
				reagents.trans_to(I, src.reagents.total_volume)
				for(var/mob/O in viewers(world.view, src))
					O.show_message(text("\blue [user] scoops up the [src.name] with the [I.name]!"), 1)
				if(!reagents.total_volume)
					del(src)