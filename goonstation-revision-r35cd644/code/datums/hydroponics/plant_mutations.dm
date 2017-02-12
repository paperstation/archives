/datum/plantmutation/
	var/name = null // If this is set, plants will use this instead of regular plant name
	var/crop = null // What crop does it give?
	var/special_dmi = null // same as in base plant thing really
	var/iconmod = null // name of the sprite files in hydro_mutants.dmi
	var/harvest_override = 0 // If 1, you can harvest it irregardless of the plant's base harvestability
	var/harvested_proc_override = 0
	var/special_proc_override = 0
	// If 0, just use the base plant's settings
	// If 1, use the mutation's special_proc instead
	// If anything else, use both the base and the mutant procs

	// Ranges various genes have to be in to get the mutation to appear - lower and upper bound
	var/list/GTrange = list(null,null) // null means there is no limit so an upper bound of 25
	var/list/HTrange = list(null,null) // and no lower bound means the mutation will occur when
	var/list/HVrange = list(null,null) // the plant is below 25 in that gene, but can be as low
	var/list/CZrange = list(null,null) // as it wants otherwise with no consideration
	var/list/PTrange = list(null,null)
	var/list/ENrange = list(null,null)
	var/commut = null // is a paticular common mutation required for this? (keeping it to 1 for now)
	var/chance = 8 // How likely out of 100% is this mutation to appear when conditions are met?
	var/list/assoc_reagents = list() // Used for extractions, harvesting, etc

	var/lasterr = 0

	proc/HYPharvested_proc_M(var/obj/machinery/plantpot/POT, var/mob/user)
		lasterr = 0
		if (!POT || !user) return 301
		if (POT.dead || !POT.current) return 302
		if (lasterr)
			logTheThing("debug", null, null, "<b>Plant HYP</b> [src] in pot [POT] failed with error [.]")
			harvested_proc_override = 0
			return lasterr

	proc/HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		lasterr = 0
		if (!POT) lasterr = 401
		if (POT.dead || !POT.current) lasterr = 402
		if (lasterr)
			logTheThing("debug", null, null, "<b>Plant HYP</b> [src] in pot [POT] failed with error [.]")
			special_proc_override = 0
		return lasterr

// Tomato Mutations

/datum/plantmutation/tomato/explosive
	name = "Seething Tomato"
	crop = /obj/item/reagent_containers/food/snacks/plant/tomato/explosive
	iconmod = "exptom"

	HYPharvested_proc_M(var/obj/machinery/plantpot/POT, var/mob/user)
		. = ..()
		if (.)
			return .
		if (prob(5) || (user.client && user.client.hellbanned && prob(50)))
			boutput(user, "<span style='color:red'>A tomato explodes as you pick it off the plant!</span>")
			explosion_new(POT, get_turf(user), 10, 1)
			return 399
		return 0

/datum/plantmutation/tomato/killer
	name = "Suspicious Tomato"
	crop = /obj/critter/killertomato
	iconmod = "kiltom"

// Grape Mutations

/datum/plantmutation/grapes/green
	crop = /obj/item/reagent_containers/food/snacks/plant/grape/green
	iconmod = "Ggrape"

// Orange Mutations

/datum/plantmutation/orange/blood
	name = "Blood Orange"
	assoc_reagents = list("bloodc") // heh

/datum/plantmutation/orange/clockwork
	name = "Clockwork Orange"
	crop = /obj/item/reagent_containers/food/snacks/plant/orange/clockwork
	assoc_reagents = list("iron")
	ENrange = list(30,null)
	chance = 20

// Melon Mutations

/datum/plantmutation/melon/george
	name = "Rainbow Melons"
	crop = /obj/item/reagent_containers/food/snacks/plant/melon/george
	assoc_reagents = list("george_melonium")

// Chili Mutations

/datum/plantmutation/chili/chilly
	name = "chilly"
	iconmod = "chilly"
	crop = /obj/item/reagent_containers/food/snacks/plant/chili/chilly
	assoc_reagents = list("cryostylane")

/datum/plantmutation/chili/ghost
	name = "fiery chili"
	iconmod = "ghost"
	crop = /obj/item/reagent_containers/food/snacks/plant/chili/ghost_chili
	PTrange = list(75,null)
	chance = 10
	assoc_reagents = list("ghostchilijuice")

// Eggplant Mutations

/datum/plantmutation/eggplant/literal
	name = "free range eggplant"
	iconmod = "eggs"
	crop = /obj/item/reagent_containers/food/snacks/ingredient/egg

// Wheat Mutations

/datum/plantmutation/wheat/steelwheat
	name = "steelwheat"
	iconmod = "steelwheat"
	crop = /obj/item/plant/wheat/metal

// Synthmeat Mutations

/datum/plantmutation/synthmeat/butt
	name = "Synthbutt"
	iconmod = "butts"
	crop = /obj/item/clothing/head/butt/synth
	special_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		var/fart_prob = max(0,min(100,DNA.potency))

		if (POT.growth > (P.growtime + DNA.growtime) && prob(fart_prob))
			POT.visible_message("<span style=\"color:red\"><b>[POT]</b> farts!</span>")
			playsound(POT.loc, "sound/misc/poo2.ogg", 50, 1)
			// coder.Life()
			// whoops undefined proc

/datum/plantmutation/synthmeat/limb
	name = "Synthlimb"
	iconmod = "limbs" // haine has farted up a shitty recolored sprite for these, everyone rejoice
	crop = list(/obj/item/parts/human_parts/arm/left/synth, /obj/item/parts/human_parts/arm/right/synth,
	            /obj/item/parts/human_parts/leg/left/synth, /obj/item/parts/human_parts/leg/right/synth,
	            /obj/item/parts/human_parts/arm/left/synth/bloom, /obj/item/parts/human_parts/arm/right/synth/bloom,
	            /obj/item/parts/human_parts/leg/left/synth/bloom, /obj/item/parts/human_parts/leg/right/synth/bloom)

/datum/plantmutation/synthmeat/organ
	name = "Synthorgan"
	iconmod = "limbs"
	crop = list(/obj/item/organ/heart/synth, /obj/item/organ/brain/synth, /obj/item/organ/eye/synth) // Just slap your new organ in there.

/datum/plantmutation/synthmeat/butt/buttbot
	name = "Synthbuttbot"
	iconmod = "butts"
	crop = /obj/machinery/bot/buttbot

// Soy Mutations

/datum/plantmutation/soy/soylent
	name = "Strange soybean"
	crop = /obj/item/reagent_containers/food/snacks/plant/soylent
	iconmod = "soylent"

// Contusine Mutations

/datum/plantmutation/contusine/shivering
	name = "Shivering Contusine"
	iconmod = "shivercon"
	assoc_reagents = list("salbutamol")
	chance = 20

/datum/plantmutation/contusine/quivering
	name = "Quivering Contusine"
	iconmod = "shivercon"
	assoc_reagents = list("curare")
	chance = 10

// Nureous Mutations

/datum/plantmutation/nureous/fuzzy
	name = "Fuzzy Nureous"
	assoc_reagents = list("hairgrownium")

// Asomna Mutations

/datum/plantmutation/asomna/robust
	name = "Robust Asomna"
	iconmod = "AsomnaR"
	assoc_reagents = list("methamphetamine")
	chance = 10

// Commol Mutations

/datum/plantmutation/commol/burning
	name = "Burning Commol"
	iconmod = "CommolB"
	assoc_reagents = list("napalm")
	chance = 10

// Venne Mutations

/datum/plantmutation/venne/toxic
	name = "Black Venne"
	iconmod = "venneT"
	crop = /obj/item/plant/herb/venne/toxic
	assoc_reagents = list("atropine")
	chance = 10

/datum/plantmutation/venne/curative
	name = "Sunrise Venne"
	iconmod = "venneC"
	crop = /obj/item/plant/herb/venne/curative
	assoc_reagents = list("oculine","mannitol","mutadone")
	chance = 5

// Cannabis Mutations

/datum/plantmutation/cannabis/rainbow
	name = "Rainbow Weed"
	iconmod = "megaweed"
	crop = /obj/item/plant/herb/cannabis/mega
	assoc_reagents = list("LSD")

/datum/plantmutation/cannabis/death
	name = "Deathweed"
	iconmod = "deathweed"
	crop = /obj/item/plant/herb/cannabis/black
	PTrange = list(null,30)
	ENrange = list(10,30)
	chance = 20
	assoc_reagents = list("cyanide")

/datum/plantmutation/cannabis/white
	name = "Lifeweed"
	iconmod = "lifeweed"
	crop = /obj/item/plant/herb/cannabis/white
	PTrange = list(30,null)
	ENrange = list(30,50)
	chance = 20
	assoc_reagents = list("omnizine")

/datum/plantmutation/cannabis/ultimate
	name = "Omega Weed"
	iconmod = "Oweed"
	crop = /obj/item/plant/herb/cannabis/omega
	PTrange = list(420,null)
	chance = 100
	assoc_reagents = list("LSD","suicider","space_drugs","mercury","lithium",
	"atropine", "ephedrine", "haloperidol","methamphetamine","THC","capsaicin","psilocybin","hairgrownium",
	"ectoplasm","bathsalts","itching","crank","krokodil","catdrugs","histamine")

// Fungus Mutations

/datum/plantmutation/fungus/psilocybin
	name = "Magic Mushroom"
	iconmod = "magmush"
	crop = /obj/item/reagent_containers/food/snacks/mushroom/psilocybin
	assoc_reagents = list("psilocybin")

/datum/plantmutation/fungus/amanita
	name = "White Fungus"
	iconmod = "deathcap"
	crop = /obj/item/reagent_containers/food/snacks/mushroom/amanita
	ENrange = list(null,10)
	PTrange = list(30,null)
	chance = 20
	assoc_reagents = list("amanitin")

// Lasher Mutations

/datum/plantmutation/lasher/berries
	name = "Blooming Lasher"
	iconmod = "lashberry"
	harvest_override = 1
	crop = /obj/item/reagent_containers/food/snacks/plant/lashberry/
	chance = 20

// Radweed Mutations

/datum/plantmutation/radweed/safeweed
	name = "White Radweed"
	iconmod = "whiterad"
	special_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.harvtime + DNA.harvtime) && prob(10))
			var/obj/overlay/B = new /obj/overlay( POT.loc )
			B.icon = 'icons/obj/hydroponics/hydromisc.dmi'
			B.icon_state = "radpulse"
			B.name = "radioactive pulse"
			B.anchored = 1
			B.density = 0
			B.layer = 5 // TODO what layer should this be on?
			spawn(20)
				qdel(B)
			var/radrange = 1
			switch (POT.health)
				if (60 to 159)
					radrange = 2
				if (160 to INFINITY)
					radrange = 3
			for (var/obj/machinery/plantpot/C in range(radrange,POT))
				var/datum/plant/growing = C.current
				if (istype(growing,/datum/plant/radweed)) continue
				if (growing) C.HYPmutateplant(radrange * 2)

/datum/plantmutation/radweed/redweed
	name = "Smoldering Radweed"
	iconmod = "redweed"
	assoc_reagents = list("napalm")

// Slurrypod Mutations

/datum/plantmutation/slurrypod/omega
	name = "Glowing Slurrypod"
	iconmod = "omegaS"
	crop = /obj/item/reagent_containers/food/snacks/plant/slurryfruit/omega
	assoc_reagents = list("omega_mutagen")

// Rock Plant Mutations

/datum/plantmutation/rocks/syreline
	crop = /obj/item/raw_material/syreline
	chance = 40

/datum/plantmutation/rocks/bohrum
	crop = /obj/item/raw_material/bohrum
	chance = 20

/datum/plantmutation/rocks/mauxite
	crop = /obj/item/raw_material/mauxite
	chance = 10

/datum/plantmutation/rocks/erebite
	crop = /obj/item/raw_material/erebite
	chance = 5

// trees. :effort:

/datum/plantmutation/tree/money
	name = "Money Tree"
	iconmod = "Cash"
	crop = /obj/item/spacecash
	chance = 20