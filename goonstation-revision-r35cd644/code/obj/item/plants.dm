
// Inedible Produce

/obj/item/plant/
	name = "plant"
	desc = "You shouldn't be able to see this item ingame!"
	icon = 'icons/obj/hydroponics/hydromisc.dmi'
	var/brewable = 0 // will hitting a still with it do anything?
	var/brew_result = null // what will it make if it's brewable?
	rand_pos = 1

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src

/obj/item/plant/herb
	name = "herb base"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/spacecash))
			boutput(user, "<span style=\"color:red\">You roll up [W] into a cigarette.</span>")
			var/obj/item/clothing/mask/cigarette/custom/P = new(user.loc)
			P.name = "[W.amount]-credit [pick("joint","doobie","spliff","roach","blunt","roll","fatty","reefer")]"
			P.reagents.maximum_volume = src.reagents.total_volume
			src.reagents.trans_to(P, src.reagents.total_volume)
			qdel (W)
			qdel (src)
		else if (istype(W, /obj/item/paper/))
			boutput(user, "<span style=\"color:red\">You roll up [W] into a cigarette.</span>")
			var/obj/item/clothing/mask/cigarette/custom/P = new(user.loc)
			P.name = pick("joint","doobie","spliff","roach","blunt","roll","fatty","reefer")
			P.reagents.maximum_volume = src.reagents.total_volume
			src.reagents.trans_to(P, src.reagents.total_volume)
			qdel (W)
			qdel (src)

/obj/item/plant/herb/cannabis/
	name = "cannabis leaf"
	desc = "Leafs for reefin'!"
	icon = 'icons/obj/hydroponics/hydromisc.dmi'
	icon_state = "cannabisleaf"
	brewable = 1
	brew_result = "THC"
	module_research = list("vice" = 10)
	module_research_type = /obj/item/plant/herb/cannabis

/obj/item/plant/herb/cannabis/spawnable
	New()
		..()
		var/datum/reagents/R = new/datum/reagents(85)
		reagents = R
		R.my_atom = src
		R.add_reagent("THC", 80)

/obj/item/plant/herb/cannabis/mega
	name = "cannabis leaf"
	desc = "Is it supposed to be glowing like that...?"
	icon_state = "megaweedleaf"
	brew_result = list("THC", "LSD")

/obj/item/plant/herb/cannabis/mega/spawnable
	New()
		..()
		var/datum/reagents/R = new/datum/reagents(85)
		reagents = R
		R.my_atom = src
		R.add_reagent("THC", 40)
		R.add_reagent("LSD", 40)

/obj/item/plant/herb/cannabis/black
	name = "cannabis leaf"
	desc = "Looks a bit dark. Oh well."
	icon_state = "blackweedleaf"
	brew_result = list("THC", "cyanide")

/obj/item/plant/herb/cannabis/black/spawnable
	New()
		..()
		var/datum/reagents/R = new/datum/reagents(85)
		reagents = R
		R.my_atom = src
		R.add_reagent("THC", 40)
		R.add_reagent("cyanide", 40)

/obj/item/plant/herb/cannabis/white
	name = "cannabis leaf"
	desc = "It feels smooth and nice to the touch."
	icon_state = "whiteweedleaf"
	brew_result = list("THC", "omnizine")

/obj/item/plant/herb/cannabis/white/spawnable
	New()
		..()
		var/datum/reagents/R = new/datum/reagents(85)
		reagents = R
		R.my_atom = src
		R.add_reagent("THC", 40)
		R.add_reagent("omnizine", 40)

/obj/item/plant/herb/cannabis/omega
	name = "glowing cannabis leaf"
	desc = "You feel dizzy looking at it. What the fuck?"
	icon_state = "Oweedleaf"
	brew_result = list("THC", "LSD", "suicider", "space_drugs", "mercury", "lithium", "atropine", "haloperidol", "methamphetamine",\
	"capsaicin", "psilocybin", "hairgrownium", "ectoplasm", "bathsalts", "itching", "crank", "krokodil", "catdrugs", "histamine")

/obj/item/plant/herb/cannabis/omega/spawnable
	New()
		..()
		var/datum/reagents/R = new/datum/reagents(800)
		reagents = R
		R.my_atom = src
		R.add_reagent("THC", 40)
		R.add_reagent("LSD", 40)
		R.add_reagent("suicider", 40)
		R.add_reagent("space_drugs", 40)
		R.add_reagent("mercury", 40)
		R.add_reagent("lithium", 40)
		R.add_reagent("atropine", 40)
		R.add_reagent("haloperidol", 40)
		R.add_reagent("methamphetamine", 40)
		R.add_reagent("THC", 40)
		R.add_reagent("capsaicin", 40)
		R.add_reagent("psilocybin", 40)
		R.add_reagent("hairgrownium", 40)
		R.add_reagent("ectoplasm", 40)
		R.add_reagent("bathsalts", 40)
		R.add_reagent("itching", 40)
		R.add_reagent("crank", 40)
		R.add_reagent("krokodil", 40)
		R.add_reagent("catdrugs", 40)
		R.add_reagent("histamine", 40)

/obj/item/plant/wheat
	name = "wheat"
	desc = "Never eat shredded wheat."
	icon_state = "wheat"
	brewable = 1
	brew_result = "beer"

/obj/item/plant/wheat/metal
	name = "steelwheat"
	desc = "Never eat iron filings."
	icon_state = "metalwheat"
	brew_result = list("beer", "iron")

/obj/item/plant/sugar/
	name = "sugar cane"
	desc = "Grown lovingly in our space plantations."
	icon_state = "sugarcane"
	brewable = 1
	brew_result = "rum"

/obj/item/plant/herb/contusine
	name = "contusine leaves"
	desc = "Dry, bitter leaves known for their wound-mending properties."
	icon_state = "contusine"

/obj/item/plant/herb/nureous
	name = "nureous leaves"
	desc = "Chewy leaves often manufactured for use in radiation treatment medicine."
	icon_state = "nureous"

/obj/item/plant/herb/asomna
	name = "asomna bark"
	desc = "Often regarded as a delicacy when used for tea, Asomna also has stimulant properties."
	icon_state = "asomna"
	brewable = 1
	brew_result = "tea"

/obj/item/plant/herb/commol
	name = "commol root"
	desc = "A tough and waxy root. It is well-regarded as an ingredient in burn salve."
	icon_state = "commol"

/obj/item/plant/herb/venne
	name = "venne fibers"
	desc = "Fibers from the stem of a Venne vine. Though tasting foul, it has remarkable anti-toxic properties."
	icon_state = "venne"

/obj/item/plant/herb/venne/toxic
	name = "black venne fibers"
	desc = "It's black and greasy. Kinda gross."
	icon_state = "venneT"

/obj/item/plant/herb/venne/curative
	name = "dawning venne fibers"
	desc = "It has a lovely sunrise coloration to it."
	icon_state = "venneC"

/obj/item/plant/herb/catnip
	name = "nepeta cataria"
	desc = "Otherwise known as catnip or catswort.  Cat drugs."
	icon_state = "catnip"
	brewable = 1
	brew_result = "catdrugs"
	module_research = list("vice" = 3)
	module_research_type = /obj/item/plant/herb/cannabis
