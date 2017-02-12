#define TOUCH 1
#define INGEST 2

//CIGARETTES BY NORI
/obj/item/weapon/paper/rolling_paper
	name = "rolling paper"
	desc = "Perfect for when you need to roll your own."
	icon = 'items.dmi'
	icon_state = "rollingpaper"

/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "Tasty"
	icon_state = "cigoff"
	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/icon_butt = "cigbutt"
	throw_speed = 0.5
	item_state = "cigoff"
	var/lastHolder = null
	var/volume = 20
	var/smoketime = 300
	w_class = 1
	body_parts_covered = null

	New()
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src

/obj/item/clothing/mask/cigarette/nicotine/New()
	..()
	reagents.add_reagent("tobacco",16)
	reagents.add_reagent("nicotine",4)

/obj/item/clothing/mask/cigarette/marijuana/New()
	..()
	name = pick("joint","doobie","spliff","roach","blunt","roll","fatty","reefer")
	reagents.add_reagent("thc", 20)

/obj/item/clothing/mask/cigarette/shroom/New()
	..()
	reagents.add_reagent("psilocybin", 15)
	reagents.add_reagent("cryptobiolin", 5)

/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "Only for the best of space travelers."
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	icon_butt = "cigarbutt"
	throw_speed = 0.5
	item_state = "cigaroff"
	volume = 30
	smoketime = 500

	New()
		..()
		reagents.add_reagent("tobacco",22)
		reagents.add_reagent("nicotine",8)

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "cohiba cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	icon_butt = "cigarbutt"

	New()
		..()
		reagents.add_reagent("tobacco",18)
		reagents.add_reagent("nicotine",8)
		reagents.add_reagent("chloromydride",2)

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "havana cigar"
	desc = "There is absolutely nothing more you could want from a cigar. In fact, people have been reported to beg for less."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	icon_butt = "cigarbutt"
	volume = 210
	smoketime = 300

	New()
		..()
		reagents.add_reagent("tobacco",120)
		reagents.add_reagent("nicotine",48)
		reagents.add_reagent("dongoprazine",24)
		reagents.add_reagent("chloromydride",6)
		reagents.add_reagent("nutriment",3) //everything but the kitchen sink included!
		reagents.add_reagent("cum",6)
		reagents.add_reagent("space_drugs",1)
		reagents.add_reagent("singulo",2)

//END CIGARETTES BY ERIKAT
