/datum/plant/wheat
	name = "Wheat"
	category = "Miscellaneous"
	seedcolor = "#FFFF88"
	crop = /obj/item/plant/wheat
	starthealth = 15
	growtime = 40
	harvtime = 80
	cropsize = 5
	harvests = 1
	isgrass = 1
	endurance = 0
	genome = 10
	mutations = list(/datum/plantmutation/wheat/steelwheat)
	commuts = list(/datum/plant_gene_strain/growth_fast,/datum/plant_gene_strain/health_poor)

	HYPinfusionP(var/obj/item/seed/S,var/reagent)
		..()
		var/datum/plantgenes/DNA = S.plantgenes
		if (!DNA) return
		if (reagent == "iron")
			DNA.mutation = HY_get_mutation_from_path(/datum/plantmutation/wheat/steelwheat)

/datum/plant/rice
	name = "Rice"
	category = "Miscellaneous"
	seedcolor = "#FFFFAA"
	crop = /obj/item/reagent_containers/food/snacks/ingredient/rice
	starthealth = 20
	growtime = 30
	harvtime = 70
	cropsize = 4
	harvests = 1
	isgrass = 1
	endurance = 0
	genome = 8
	vending = 0
	commuts = list(/datum/plant_gene_strain/yield,/datum/plant_gene_strain/health_poor)

/datum/plant/beans
	name = "Bean"
	category = "Miscellaneous"
	seedcolor = "#AA7777"
	crop = /obj/item/reagent_containers/food/snacks/ingredient/bean
	starthealth = 40
	growtime = 50
	harvtime = 130
	cropsize = 4
	harvests = 5
	endurance = 0
	genome = 6
	vending = 0
	commuts = list(/datum/plant_gene_strain/immunity_toxin,/datum/plant_gene_strain/metabolism_slow)

/datum/plant/corn
	name = "Corn"
	category = "Miscellaneous"
	seedcolor = "#FFFF00"
	crop = /obj/item/reagent_containers/food/snacks/plant/corn
	starthealth = 20
	growtime = 60
	harvtime = 110
	cropsize = 3
	harvests = 3
	endurance = 2
	genome = 10
	commuts = list(/datum/plant_gene_strain/photosynthesis,/datum/plant_gene_strain/splicing/bad)
	assoc_reagents = list("cornstarch")

/datum/plant/synthmeat
	name = "Synthmeat"
	category = "Miscellaneous"
	seedcolor = "#550000"
	crop = /obj/item/reagent_containers/food/snacks/ingredient/meat/synthmeat
	starthealth = 5
	growtime = 60
	harvtime = 120
	cropsize = 3
	harvests = 2
	endurance = 3
	force_seed_on_harvest = 1
	genome = 7
	special_proc = 1
	assoc_reagents = list("synthflesh")
	mutations = list(/datum/plantmutation/synthmeat/butt,/datum/plantmutation/synthmeat/limb,/datum/plantmutation/synthmeat/organ)
	commuts = list(/datum/plant_gene_strain/yield,/datum/plant_gene_strain/unstable)

	HYPinfusionP(var/obj/item/seed/S,var/reagent)
		..()
		var/datum/plantgenes/DNA = S.plantgenes
		if (!DNA) return
		if (reagent == "nanites" && (DNA.mutation && istype(DNA.mutation,/datum/plantmutation/synthmeat/butt)))
			DNA.mutation = HY_get_mutation_from_path(/datum/plantmutation/synthmeat/butt/buttbot)

/obj/item/clothing/head/butt/synth
	name = "synthetic butt"
	desc = "Why would you even grow this. What the fuck is wrong with you?"

/obj/machinery/bot/buttbot/synth
	name = "Organic Buttbot"
	desc = "What part of this even makes any sense."

/datum/plant/sugar
	name = "Sugar"
	category = "Miscellaneous"
	seedcolor = "#BBBBBB"
	crop = /obj/item/plant/sugar
	starthealth = 10
	growtime = 30
	harvtime = 60
	cropsize = 7
	harvests = 1
	isgrass = 1
	endurance = 0
	genome = 8
	commuts = list(/datum/plant_gene_strain/quality,/datum/plant_gene_strain/terminator)
	assoc_reagents = list("sugar")

/datum/plant/soy
	name = "Soybean"
	category = "Miscellaneous"
	seedcolor = "#CCCC88"
	crop = /obj/item/reagent_containers/food/snacks/plant/soy
	starthealth = 15
	growtime = 60
	harvtime = 105
	cropsize = 4
	harvests = 3
	endurance = 1
	genome = 7
	commuts = list(/datum/plant_gene_strain/metabolism_fast,/datum/plant_gene_strain/quality/inferior)
	assoc_reagents = list("grease")
	mutations = list(/datum/plantmutation/soy/soylent)

/datum/plant/peanut
	name = "Peanut"
	category = "Miscellaneous"
	seedcolor = "#999900"
	crop = /obj/item/reagent_containers/food/snacks/plant/peanuts
	starthealth = 40
	growtime = 80
	harvtime = 160
	cropsize = 4
	harvests = 1
	isgrass = 1
	endurance = 10
	genome = 6

/datum/plant/cotton
	name = "Cotton"
	category = "Miscellaneous"
	seedcolor = "#FFFFFF"
	crop = /obj/item/raw_material/cotton
	starthealth = 10
	growtime = 40
	harvtime = 150
	cropsize = 4
	harvests = 4
	endurance = 0
	genome = 5
	force_seed_on_harvest = 1
	commuts = list(/datum/plant_gene_strain/immunity_radiation,/datum/plant_gene_strain/metabolism_slow)

/datum/plant/tree // :effort:
	name = "Tree"
	category = "Miscellaneous"
	seedcolor = "#9C5E13"
	crop = /obj/item/plank
	starthealth = 40
	growtime = 200
	harvtime = 260
	cropsize = 3
	harvests = 10
	endurance = 5
	genome = 20
	force_seed_on_harvest = 1
	vending = 1
	mutations = list(/datum/plantmutation/tree/money)
	commuts = list(/datum/plant_gene_strain/metabolism_fast,/datum/plant_gene_strain/metabolism_slow,/datum/plant_gene_strain/resistance_drought)