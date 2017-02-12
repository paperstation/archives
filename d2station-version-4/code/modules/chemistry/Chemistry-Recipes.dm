///////////////////////////////////////////////////////////////////////////////////
datum
	chemical_reaction
		var/name = null
		var/id = null
		var/result = null
		var/list/required_reagents = new/list()
		var/list/required_catalysts = new/list()
		var/list/required_stabilizers = new/list()
		// Both of these variables are mostly going to be used with Metroid cores - but if you want to, you can use them for other things
		var/atom/required_container = null // the container required for the reaction to happen
		var/required_other = 0 // an integer required for the reaction to happen
		var/volatility = 0 // KEEP THIS BELOW 10 FFS! 1 is 10% chance per mixing it will explode / 10 is a 100% chance, tho there is a random explosion size based on this.
		var/result_amount = 0

		proc
			on_reaction(var/datum/reagents/holder, var/created_volume)
				return


		explosion_potassium
			name = "Explosion"
			id = "explosion_potassium"
			result = null
			required_reagents = list("water" = 1, "potassium" = 1)
			result_amount = 3 //a bit hacky, but w/e
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				var/datum/effects/system/reagents_explosion/e = new()
				e.set_up(round (created_volume/10, 1), location, 0, 0)
				e.start()

				holder.clear_reagents()
				return


/*
		activewaterpotassium //wip
			name = "Explosion"
			id = "activewaterpotassium"
			result = "mynoglobin"
			required_reagents = list("water" = 1, "potassium" = 1) // << required chemicals to make a reaction to become this chemical
			volatility = 8 //<< how unstable and how much of a chance the substance has to explode + influences explosion size
			result_amount = 1
*/
		stoxin
			name = "Sleep Toxin"
			id = "stoxin"
			result = "stoxin"
			required_reagents = list("potassium" = 1, "ethanol" = 1, "oxygen" = 1)
			result_amount = 3

		ryetalynplus
			name = "Ryetalyn Plus"
			id = "ryetalynplus"
			required_reagents = list("ryetalyn" = 1, "chloromydride" = 1)
			result_amount = 2

		lanthinine
			name = "Lanthinine"
			id = "lanthinine"
			result = "lanthinine"
			required_reagents = list("water" = 1, "space_drugs" = 1, "tricordrazine" = 1)
			result_amount = 3

		epinephrine
			name = "Epinephrine"
			id = "epinephrine"
			result = "epinephrine"
			required_reagents = list("water" = 1, "hydrogen" = 1, "inaprovaline" = 1)
			result_amount = 3

		atropine
			name = "Atropine"
			id = "atropine"
			result = "atropine"
			required_reagents = list("water" = 1, "nitrogen" = 1, "tricordrazine" = 1, "acid" = 1)
			result_amount = 4

		water
			name = "Water" //why the fuck wasn't this coded in yet?
			id = "water"
			result = "water"
			required_reagents = list("oxygen" = 1, "hydrogen" = 2)
			result_amount = 3

		vomit
			name = "Vomit" //why the fuck wasn't this coded in yet?
			id = "vomit"
			result = "vomit"
			required_reagents = list("sacid" = 1, "poo" = 2)
			result_amount = 3

		ketaminol
			name = "2-Cycleketaminol" //Heavy drug. Use in small quantities.
			id = "ketaminol"
			result = "ketaminol"
			required_reagents = list("kayoloprovaline" = 1, "kayolane" = 1, "ethanol" = 1)
			result_amount = 3
			//on_reaction(var/datum/reagents/holder, var/created_volume)
			//	holder.temperature += 300

		liquid_nitrogen
			name = "Liquid Nitrogen"
			id = "liquid_nitrogen"
			result = "liquid_nitrogen"
			required_reagents = list("ethanol" = 1, "water" = 1, "nitrogen" = 1)
			required_catalysts = list("plasma" = 1)
			result_amount = 5
//			on_reaction(var/datum/reagents/holder, var/created_volume)
//				holder.temperature -= 300

		liquid_oxygen
			name = "Liquid Oxygen"
			id = "liquid_oxygen"
			result = "liquid_oxygen"
			required_reagents = list("ethanol" = 1, "water" = 1, "oxygen" = 1)
			required_catalysts = list("plasma" = 1)
			result_amount = 5
//			on_reaction(var/datum/reagents/holder, var/created_volume)
//				holder.temperature -= 300

		cardamine
			name = "Cardamine"
			id = "cardamine"
			result = "cardamine"
			required_reagents = list("space_drugs" = 1, "water" = 1, "liquid_nitrogen" = 1)
			result_amount = 5

		silicate
			name = "Silicate"
			id = "silicate"
			result = "silicate"
			required_reagents = list("aluminum" = 1, "silicon" = 1, "oxygen" = 1)
			result_amount = 3

		sterilizine
			name = "Sterilizine"
			id = "sterilizine"
			result = "sterilizine"
			required_reagents = list("ethanol" = 1, "anti_toxin" = 1, "chlorine" = 1)
			result_amount = 3

		inaprovaline
			name = "Inaprovaline"
			id = "inaprovaline"
			result = "inaprovaline"
			required_reagents = list("oxygen" = 1, "carbon" = 1, "sugar" = 1)
			result_amount = 3

		hemoprovaline
			name = "Hemoprovaline"
			id = "hemoprovaline"
			result = "hemoprovaline"
			required_reagents = list("hemoline" = 1, "inaprovaline" = 1)
			result_amount = 2

		hemoline
			name = "Hemoline"
			id = "hemoline"
			result = "hemoline"
			required_reagents = list("blood" = 1, "sugar" = 1, "anti_toxin" = 1)
			result_amount = 3

		chloromydride
			name = "Chloromydride"
			id = "chloromydride"
			result = "chloromydride"
			required_reagents = list("oxygen" = 1, "inaprovaline" = 1, "dexalin" = 1)
			result_amount = 3

		corophizine
			name = "Corophizine"
			id = "corophizine"
			result = "corophizine"
			required_reagents = list("tricordrazine" = 1, "inaprovaline" = 1, "dexalin" = 1)
			result_amount = 3

		cytoglobin
			name = "Cytoglobin"
			id = "cytoglobin"
			result = "cytoglobin"
			required_reagents = list("tricordrazine" = 1, "corophizine" = 1)
			required_catalysts = list("chloromydride" = 2)
			result_amount = 3






/////////////////////////////////////////////////example of unstable chemical, so stop your unprofessional shit. //////////////////////////////////////////


		mynoglobin
			name = "Mynoglobin"
			id = "mynoglobin"
			result = "mynoglobin"
			required_reagents = list("tricordrazine" = 1, "sugar" = 1) // << required chemicals to make a reaction to become this chemical
			required_catalysts = list("chloromydride" = 2) // << required to make reaction happen but not used up
			required_stabilizers = list("silver" = 2) // << required reagent to stabilize the reaction
			volatility = 2 //<< how unstable and how much of a chance the substance has to explode + influences explosion size
			result_amount = 2


/////////////////////////////////////////////////example of unstable chemical, so stop your unprofessional shit. //////////////////////////////////////////






		polyadrenalobin
			name = "Polyadrenalobin"
			id = "polyadrenalobin"
			result = "polyadrenalobin"
			required_reagents = list("inaprovaline" = 1, "chloromydride" = 1)
			required_stabilizers = list("silver" = 1, "stabilizer" = 1)
			result_amount = 3
			volatility = 1

		stabilizer
			name = "Chemical Stabilizer"
			id = "stabilizer"
			result = "stabilizer"
			required_reagents = list("mutagen" = 1, "toxin" = 1, "radium" = 1)
			result_amount = 3

		biomorph
			name = "Biomorphic Serum"
			id = "biomorph"
			result = "biomorph"
			required_reagents = list("cum" = 1, "mynoglobin" = 1, "mutagen" = 1, "blood" = 1)
			required_catalysts = list("silver" = 1, "chloromydride" = 1)
			required_stabilizers = list("stabilizer" = 1)
			volatility = 8 //a giant fuck you to deadsnipe and everything he stands for
			result_amount = 2

		nitroglycerin
			name = "Nitroglycerin"
			id = "nitroglycerin"
			result = "nitroglycerin"
			required_reagents = list("glycerol" = 1, "pacid" = 1, "acid" = 1)
			required_stabilizers = list("stabilizer" = 1)
			volatility = 4
			result_amount = 2

		oleoresincapsicumn
			name = "Oleoresin Capsicum"
			id = "oleoresincapsicumn"
			result = "oleoresincapsicumn"
			required_reagents = list("capsaicin" = 1, "water" = 1)
			result_amount = 2

		ketaminol
			name = "2-Cycloketaminol" //Heavy drug. Use in small quantities.
			id = "ketaminol"
			result = "ketaminol"
			required_reagents = list("kayoloprovaline" = 1, "kayolane" = 1, "ethanol" = 1)
			result_amount = 2

		kayolane
			name = "Kayolane"
			id = "kayolane"
			result = "kayolane"
			required_reagents = list("stoxin" = 1, "carbon" = 1, "nitrogen" = 1)
			result_amount = 3

		kayoloprovaline
			name = "Kayoloprovaline"
			id = "kayoloprovaline"
			result = "kayoloprovaline"
			required_reagents = list("kayolane" = 1, "inaprovaline" = 1)
			result_amount = 3

		anti_toxin
			name = "Anti-Toxin (Dylovene)"
			id = "anti_toxin"
			result = "anti_toxin"
			required_reagents = list("silicon" = 1, "potassium" = 1, "nitrogen" = 1)
			result_amount = 3

		ethylene_oxide
			name = "Ethylene Oxide"
			id = "ethylene_oxide"
			result = "ethylene_oxide"
			required_reagents = list("ethanol" = 1, "oxygen" = 1)
			result_amount = 2

		pelihewanum
			name = "Pelihewanum"
			id = "pelihewanum"
			result = "pelihewanum"
			required_reagents = list("glycerol" = 1, "ryetalin" = 1, "polyadrenalobin" = 1)
			required_catalysts = list("plasma" = 1)
			result_amount = 3

		peli1
			name = "peli1"
			id = "peli1"
			result = "water"
			required_reagents = list("pelihewanum" = 1, "acid" = 10)
			result_amount = 1

		peli2
			name = "peli2"
			id = "peli2"
			result = "water"
			required_reagents = list("pelihewanum" = 1, "pacid" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/turf/location = get_turf(holder.my_atom.loc)
				for(var/turf/simulated/floor/target_tile in range(0,location))
					if(target_tile.parent && target_tile.parent.group_processing)
						target_tile.parent.suspend_group_processing()

					var/datum/gas_mixture/napalm = new

					napalm.toxins = created_volume
					napalm.temperature = 400+T0C

					target_tile.assume_air(napalm)
					spawn (0) target_tile.hotspot_expose(700, 400)

		peli3
			name = "peli3"
			id = "peli3"
			result = "water"
			required_reagents = list("pelihewanum" = 1, "limejuice" = 50)
			result_amount = 1

		peli4
			name = "peli4"
			id = "peli4"
			result = "water"
			required_reagents = list("pelihewanum" = 1, "lemonjuice" = 40)
			result_amount = 1

		mutagen
			name = "Unstable mutagen"
			id = "mutagen"
			result = "mutagen"
			required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
			result_amount = 3

		fixer
			name = "Fixer"
			id = "fixer"
			result = "fixer"
			required_reagents = list("inaprovaline" = 1, "corophizine" = 1, "oxygen" = 1)
			required_catalysts = list("potassium" = 1, "hydrogen" = 2)
			result_amount = 1

		//cyanide
		//	name = "Cyanide"
		//	id = "cyanide"
		//	result = "cyanide"
		//	required_reagents = list("hydrogen" = 1, "carbon" = 1, "nitrogen" = 1)
		//	result_amount = 1

		thermite
			name = "Thermite"
			id = "thermite"
			result = "thermite"
			required_reagents = list("aluminum" = 1, "iron" = 1, "oxygen" = 1)
			result_amount = 3

		lexorin
			name = "Lexorin"
			id = "lexorin"
			result = "lexorin"
			required_reagents = list("plasma" = 1, "hydrogen" = 1, "nitrogen" = 1)
			result_amount = 3

		space_drugs
			name = "Space Drugs"
			id = "space_drugs"
			result = "space_drugs"
			required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
			result_amount = 3

		sacid
			name = "Salicylic Acid"
			id = "sacid"
			result = "sacid"
			required_reagents = list("sodlum" = 1, "carbon" = 1, "oxygen" = 2)
			required_catalysts = list("acid" = 1)
			result_amount = 3

		jenkem
			name = "Jenkem"
			id = "jenkem"
			result = "jenkem"
			required_reagents = list("urine" = 1, "poo" = 1)
			result_amount = 3

		orlistat
			name = "Orlistat"
			id = "orlistat"
			result = "orlistat"
			required_reagents = list("water" = 1, "lithium" = 1, "sugar" = 1, "iron" = 1)
			result_amount = 3

		sildenafil
			name = "Sildenafil"
			id = "sildenafil"
			result = "sildenafil"
			required_reagents = list("lube" = 1, "sugar" = 1, "iron" = 1)
			result_amount = 2

		lube
			name = "Space Lube"
			id = "lube"
			result = "lube"
			required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
			result_amount = 4

		cryostylane
			name = "cryostylane"
			id = "cryostylane"
			result = "cryostylane"
			required_reagents = list("pacid" = 1, "water" = 1, "kelotane" = 1)
			result_amount = 3

		pacid
			name = "Polytrinic acid"
			id = "pacid"
			result = "pacid"
			required_reagents = list("acid" = 1, "chlorine" = 1, "potassium" = 1)
			result_amount = 3

		synaptizine
			name = "Synaptizine"
			id = "synaptizine"
			result = "synaptizine"
			required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)
			result_amount = 3

		hyronalin
			name = "Hyronalin"
			id = "hyronalin"
			result = "hyronalin"
			required_reagents = list("radium" = 1, "anti_toxin" = 1)
			result_amount = 2

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			result = "arithrazine"
			required_reagents = list("hyronalin" = 1, "hydrogen" = 1)
			result_amount = 2

		impedrezene
			name = "Impedrezene"
			id = "impedrezene"
			result = "impedrezene"
			required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
			result_amount = 2

		kelotane
			name = "Kelotane"
			id = "kelotane"
			result = "kelotane"
			required_reagents = list("silicon" = 1, "carbon" = 1)
			result_amount = 2

		leporazine
			name = "Leporazine"
			id = "leporazine"
			result = "leporazine"
			required_reagents = list("silicon" = 1, "copper" = 1)
			required_catalysts = list("plasma" = 5)
			result_amount = 2

		cryptobiolin
			name = "Cryptobiolin"
			id = "cryptobiolin"
			result = "cryptobiolin"
			required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
			result_amount = 3

		tricordrazine
			name = "Tricordrazine"
			id = "tricordrazine"
			result = "tricordrazine"
			required_reagents = list("inaprovaline" = 1, "anti_toxin" = 1)
			result_amount = 2

		alkysine
			name = "Alkysine"
			id = "alkysine"
			result = "alkysine"
			required_reagents = list("chlorine" = 1, "nitrogen" = 1, "anti_toxin" = 1)
			result_amount = 2

		dexalin
			name = "Dexalin"
			id = "dexalin"
			result = "dexalin"
			required_reagents = list("oxygen" = 2)
			required_catalysts = list("plasma" = 5)
			result_amount = 1

		dermaline
			name = "Dermaline"
			id = "dermaline"
			result = "dermaline"
			required_reagents = list("oxygen" = 1, "phosphorus" = 1, "kelotane" = 1)
			result_amount = 3

		dexalinp
			name = "Dexalin Plus"
			id = "dexalinp"
			result = "dexalinp"
			required_reagents = list("dexalin" = 1, "carbon" = 1, "iron" = 1)
			result_amount = 3

		bicaridine
			name = "Bicaridine"
			id = "bicaridine"
			result = "bicaridine"
			required_reagents = list("inaprovaline" = 1, "carbon" = 1)
			result_amount = 2

		hyperzine
			name = "Hyperzine"
			id = "hyperzine"
			result = "hyperzine"
			required_reagents = list("sugar" = 1, "phosphorus" = 1, "sulfur" = 1,)
			result_amount = 3

		hulkazine
			name = "Hulkazine"
			id = "hulkazine"
			result = "hulkazine"
			required_reagents = list("radium" = 1, "chloromydride" = 1, "hyperzine" = 1,)
			result_amount = 3

		ryetalyn
			name = "Ryetalyn"
			id = "ryetalyn"
			result = "ryetalyn"
			required_reagents = list("arithrazine" = 1, "carbon" = 1)
			result_amount = 2

		cryoxadone
			name = "Cryoxadone"
			id = "cryoxadone"
			result = "cryoxadone"
			required_reagents = list("dexalin" = 1, "water" = 1, "oxygen" = 1)
			result_amount = 3

		clonexadone
			name = "Clonexadone"
			id = "clonexadone"
			result = "clonexadone"
			required_reagents = list("cryoxadone" = 1, "sodium" = 1)
			required_catalysts = list("plasma" = 5)
			result_amount = 2

		spaceacillin
			name = "Spaceacillin"
			id = "spaceacillin"
			result = "spaceacillin"
			required_reagents = list("cryptobiolin" = 1, "inaprovaline" = 1)
			result_amount = 2

		albiniser
			name = "Albiniser"
			id = "albiniser"
			required_reagents = list("bleach" = 1, "blood" = 1, "sodium" = 1)
			result_amount = 2

		antdazoline
			name = "Antdazoline"
			id = "antdazoline"
			result = "antdazoline"
			required_reagents = list("imidazoline" = 1, "mutagen" = 1, "chlorine" = 1)
			result_amount = 1

		imidazoline
			name = "Imidazoline"
			id = "imidazoline"
			result = "imidazoline"
			required_reagents = list("carbon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
			result_amount = 2

		ethylredoxrazine
			name = "Ethylredoxrazine"
			id = "ethylredoxrazine"
			result = "ethylredoxrazine"
			required_reagents = list("oxygen" = 1, "anti_toxin" = 1, "carbon" = 1)
			result_amount = 3

		ethanoloxidation
			name = "ethanoloxidation"	//Kind of a placeholder in case someone ever changes it so that chemicals
			id = "ethanoloxidation"		//	react in the body. Also it would be silly if it didn't exist.
			result = "water"
			required_reagents = list("ethylredoxrazine" = 1, "ethanol" = 1)
			result_amount = 2

		glycerol
			name = "Glycerol"
			id = "glycerol"
			result = "glycerol"
			required_reagents = list("cornoil" = 3, "acid" = 1)
			result_amount = 1 //nitroglycerin moved to poly and biomorph for easier access

		sodiumchloride
			name = "Sodium Chloride"
			id = "sodiumchloride"
			result = "sodiumchloride"
			required_reagents = list("sodium" = 1, "chlorine" = 1)
			result_amount = 2

		flash_powder
			name = "Flash powder"
			id = "flash_powder"
			result = null
			required_reagents = list("aluminum" = 1, "potassium" = 1, "sulfur" = 1 )
			result_amount = null
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				var/datum/effects/system/spark_spread/s = new /datum/effects/system/spark_spread
				s.set_up(2, 1, location)
				s.start()
				for(var/mob/living/carbon/M in viewers(world.view, location))
					switch(get_dist(M, location))
						if(0 to 3)
							if(hasvar(M, "glasses"))
								if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
									continue

							flick("e_flash", M.flash)
							M.weakened = 15

						if(4 to 5)
							if(hasvar(M, "glasses"))
								if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
									continue

							flick("e_flash", M.flash)
							M.stunned = 5

		napalm
			name = "Napalm"
			id = "napalm"
			result = null
			required_reagents = list("aluminum" = 1, "plasma" = 1, "acid" = 1 )
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/turf/location = get_turf(holder.my_atom.loc)
				for(var/turf/simulated/floor/target_tile in range(0,location))
					if(target_tile.parent && target_tile.parent.group_processing)
						target_tile.parent.suspend_group_processing()

					var/datum/gas_mixture/napalm = new

					napalm.toxins = created_volume
					napalm.temperature = 400+T0C

					target_tile.assume_air(napalm)
					spawn (0) target_tile.hotspot_expose(700, 400)
				holder.del_reagent("napalm")
				return

		s_napalm
			name = "Napalm"
			id = "s_napalm"
			result = "s_napalm"
			required_reagents = list("aluminum" = 1, "plasma" = 1, "sulfur" = 1 )
			required_stabilizers = list("fluorosurfacant" = 1, "hydrogen" = 1)
			volatility = 6
			result_amount = 1   //the purpose of all this is to make a form of napalm that fits into grenades better, see below

		s_napalm2
			name = "Napalm"
			id = "s_napalm2"
			result = null
			required_reagents = list("s_napalm" = 1, "oxygen" = 1)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/turf/location = get_turf(holder.my_atom.loc)
				for(var/turf/simulated/floor/target_tile in range(0,location))
					if(target_tile.parent && target_tile.parent.group_processing)
						target_tile.parent.suspend_group_processing()

					var/datum/gas_mixture/napalm = new

					napalm.toxins = created_volume
					napalm.temperature = 400+T0C

					target_tile.assume_air(napalm)
					spawn (0) target_tile.hotspot_expose(700, 400)
				holder.del_reagent("napalm")
				return

		smoke
			name = "Smoke"
			id = "smoke"
			result = null
			required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1 )
			result_amount = null
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				var/datum/effects/system/bad_smoke_spread/S = new /datum/effects/system/bad_smoke_spread
				S.attach(location)
				S.set_up(10, 0, location)
				playsound(location, 'smoke.ogg', 50, 1, -3)
				spawn(0)
					S.start()
					sleep(10)
					S.start()
					sleep(10)
					S.start()
					sleep(10)
					S.start()
					sleep(10)
					S.start()
				return

		chloralhydrate
			name = "Chloral Hydrate"
			id = "chloralhydrate"
			result = "chloralhydrate"
			required_reagents = list("ethanol" = 1, "chlorine" = 3, "water" = 1)
			result_amount = 1

		zombiepowder
			name = "Zombie Powder"
			id = "zombiepowder"
			result = "zombiepowder"
			required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
			result_amount = 2

///////////////////////////////////////////////////////////////////////////////////

// foam and foam precursor

		surfactant
			name = "Foam surfactant"
			id = "foam surfactant"
			result = "fluorosurfactant"
			required_reagents = list("fluorine" = 2, "carbon" = 2, "acid" = 1)
			result_amount = 5


		foam
			name = "Foam"
			id = "foam"
			result = null
			required_reagents = list("fluorosurfactant" = 1, "water" = 1)
			result_amount = 2

			on_reaction(var/datum/reagents/holder, var/created_volume)


				var/location = get_turf(holder.my_atom)
				for(var/mob/M in viewers(5, location))
					M << "\red The solution violently bubbles!"

				location = get_turf(holder.my_atom)

				for(var/mob/M in viewers(5, location))
					M << "\red The solution spews out foam!"

				//world << "Holder volume is [holder.total_volume]"
				//for(var/datum/reagent/R in holder.reagent_list)
				//	world << "[R.name] = [R.volume]"

				var/datum/effects/system/foam_spread/s = new()
				s.set_up(created_volume, location, holder, 0)
				s.start()
				holder.clear_reagents()
				return

		metalfoam
			name = "Metal Foam"
			id = "metalfoam"
			result = null
			required_reagents = list("aluminum" = 3, "foaming_agent" = 1, "pacid" = 1)
			result_amount = 5

			on_reaction(var/datum/reagents/holder, var/created_volume)


				var/location = get_turf(holder.my_atom)

				for(var/mob/M in viewers(5, location))
					M << "\red The solution spews out a metalic foam!"

				var/datum/effects/system/foam_spread/s = new()
				s.set_up(created_volume/0.4, location, holder, 1)
				s.start()
				return

		ironfoam
			name = "Iron Foam"
			id = "ironlfoam"
			result = null
			required_reagents = list("iron" = 3, "foaming_agent" = 1, "pacid" = 1)
			result_amount = 5

			on_reaction(var/datum/reagents/holder, var/created_volume)


				var/location = get_turf(holder.my_atom)

				for(var/mob/M in viewers(5, location))
					M << "\red The solution spews out a metalic foam!"

				var/datum/effects/system/foam_spread/s = new()
				s.set_up(created_volume/0.4, location, holder, 2)
				s.start()
				return



		foaming_agent
			name = "Foaming Agent"
			id = "foaming_agent"
			result = "foaming_agent"
			required_reagents = list("lithium" = 1, "hydrogen" = 1)
			result_amount = 1

		// Synthesizing these three chemicals is pretty complex in real life, but fuck it, it's just a game!
		ammonia
			name = "Ammonia"
			id = "ammonia"
			result = "ammonia"
			required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
			result_amount = 3

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			result = "diethylamine"
			required_reagents = list ("ammonia" = 1, "ethanol" = 1)
			result_amount = 2

		space_cleaner
			name = "Space cleaner"
			id = "cleaner"
			result = "cleaner"
			required_reagents = list("ammonia" = 1, "water" = 1)
			result_amount = 2

		plantbgone
			name = "Plant-B-Gone"
			id = "plantbgone"
			result = "plantbgone"
			required_reagents = list("toxin" = 1, "water" = 4)
			result_amount = 5


/////////////////////////////////////METROID CORE REACTIONS///////////////////////////////

		metroid_explosion
			name = "Explosion"
			id = "m_explosion"
			result = null
			required_reagents = list("water" = 1)
			result_amount = 2
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				var/datum/effects/system/reagents_explosion/e = new()
				e.set_up(round (created_volume/10, 1), location, 0, 0)
				e.start()

				holder.clear_reagents()
				return

		metroidjam
			name = "Metroid Jam"
			id = "m_jam"
			result = "metroid"
			required_reagents = list("nutriment" = 1)
			result_amount = 1
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore

		metroidsynthi
			name = "Metroid Synthetic Flesh"
			id = "m_flesh"
			result = null
			required_reagents = list("blood" = 1, "enzyme" = 1)
			result_amount = 1
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/weapon/synthflesh(location)
				return

		metroidenzyme
			name = "Metroid Enzyme"
			id = "m_enzyme"
			result = "enzyme"
			required_reagents = list("poo" = 1, "m_jam" = 1)
			result_amount = 2
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore

		metroidplasma
			name = "Metroid Plasma"
			id = "m_plasma"
			result = "plasma"
			required_reagents = list("sugar" = 1, "m_jam" = 2)
			result_amount = 2
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore

/*		metroidvirus			HAHA NO
			name = "Metroid Virus"
			id = "m_virus"
			result = null
			required_reagents = list("sugar" = 1, "acid" = 1)
			result_amount = 2
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			required_other = 3
			on_reaction(var/datum/reagents/holder, var/created_volume)
				holder.clear_reagents()

				var/virus = pick(/datum/disease/flu, /datum/disease/cold, \
				 /datum/disease/pierrot_throat, /datum/disease/fake_gbs, \
				 /datum/disease/brainrot, /datum/disease/wizarditis, \
				 /datum/disease/magnitis)


				var/datum/disease/F = new virus(0)
				var/list/data = list("viruses"= list(F))
				holder.add_reagent("blood", 20, data)

				holder.add_reagent("cyanide", rand(1,10))

				var/location = get_turf(holder.my_atom)
				var/datum/effects/system/bad_smoke_spread/S = new /datum/effects/system/bad_smoke_spread
				S.attach(location)
				S.set_up(10, 0, location)
				playsound(location, 'smoke.ogg', 50, 1, -3)
				spawn(0)
					S.start()
					sleep(10)
					S.start()
					sleep(10)
					S.start()
					sleep(10)
					S.start()
					sleep(10)
					S.start()
				return
*/

		metroidchloral
			name = "Metroid Chloral"
			id = "m_bunch"
			result = "chloralhydrate"
			required_reagents = list("blood" = 1, "ethanol" = 2)
			result_amount = 2
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore

		metroidxeno
			name = "Metroid Xeno"
			id = "m_xeno"
			result = "xenomicrobes"
			required_reagents = list("sugar" = 1, "blood" = 1)
			result_amount = 1
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore

		metroidfoam
			name = "Metroid Foam"
			id = "m_foam"
			result = null
			required_reagents = list("fluorosurfacant" = 1, "sugar" = 1)
			result_amount = 2
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore

			on_reaction(var/datum/reagents/holder, var/created_volume)


				var/location = get_turf(holder.my_atom)
				for(var/mob/M in viewers(5, location))
					M << "\red The solution violently bubbles!"

				location = get_turf(holder.my_atom)

				for(var/mob/M in viewers(5, location))
					M << "\red The solution spews out foam!"

				//world << "Holder volume is [holder.total_volume]"
				//for(var/datum/reagent/R in holder.reagent_list)
				//	world << "[R.name] = [R.volume]"

				var/datum/effects/system/foam_spread/s = new()
				s.set_up(created_volume, location, holder, 0)
				s.start()
				holder.clear_reagents()
				return

		paint_rainbow
			name = "paint_rainbow"
			id = "paint_rainbow"
			result = null
			required_reagents = list("rainbow_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/weapon/paint/anycolor(location)
				return

		donut
			name = "donut"
			id = "donut"
			result = null
			required_reagents = list("frostoil" = 1, "xenomicrobes" = 1, "amatoxin" = 1)
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/mob/M in viewers(5, location))
					M << "\red The solution violently expands!"
				new /obj/item/weapon/reagent_containers/food/snacks/jellydonut(location)
				return

		frostoil
			name = "frostoil"
			id = "frostoil"
			result = "frostoil"
			required_reagents = list("ice" = 2, "m_jam" = 1)
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			result_amount = 1

		coco
			name = "coco"
			id = "coco"
			result = "coco"
			required_reagents = list("poo" = 2, "m_jam" = 1)
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			result_amount = 1

		amatoxin
			name = "amatoxin"
			id = "amatoxin"
			result = "amatoxin"
			required_reagents = list("toxin" = 1)
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			result_amount = 1

		arprinium
			name = "arprinium"
			id = "arprinium"
			result = "arprinium"
			required_reagents = list("copper" = 1, "plasma" = 1, "mutagen" = 1)
			required_container = /obj/item/weapon/reagent_containers/glass/metroidcore
			result_amount = 2

		arpriemp
			name = "arpriemp"
			id = "arpriemp"
			result = null
			required_reagents = list("arprinium" = 1, "plasma" = 1)
			result_amount = 3
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				empulse(location, round(created_volume/10, 1), round(created_volume/5, 1), 1)
				for(var/mob/M in viewers(5, location))
					M << "\red The solution turns into pure energy!"
					M.radiation += 15
				holder.clear_reagents()
				return

/////////////////////////////////////CRAYONS AND OTHER CRAP///////////////////////////////

		enzyme
			name = "enzyme"
			id = "enzyme"
			result = "enzyme"
			required_reagents = list("poo" = 1, "acid" = 1, "stabilizer" = 1) //only on ss13 shit, deadly acid and green goo makes a quality food additive
			result_amount = 3

		synthpoo_1
			name = "synthpoo_1"
			id = "synthpoo_1"
			result = "synthpoo"
			required_reagents = list("nutriment" = 1, "sacid" = 1, "sodiumchloride" = 1)
			result_amount = 3

		synthpoo_2
			name = "synthpoo_2"
			id = "synthpoo_2"
			result = "poo"
			required_reagents = list("synthpoo" = 1, "lube" = 1, "iron" = 1)
			result_amount = 3

		red_dye
			name = "red_dye"
			id = "red_dye"
			result = "red_dye"
			required_reagents = list("blood" = 1, "hemoline" = 1, "stabilizer" = 1)
			result_amount = 2

		blue_dye
			name = "blue_dye"
			id = "blue_dye"
			result = "blue_dye"
			required_reagents = list("copper" = 1, "pacid" = 1, "stabilizer" = 1)
			result_amount = 2

		green_dye
			name = "green_dye"
			id = "green_dye"
			result = "green_dye"
			required_reagents = list("radium" = 1, "potassium" = 1, "stabilizer" = 1)
			result_amount = 2

		orange_dye
			name = "orange_dye"
			id = "orange_dye"
			result = "orange_dye"
			required_reagents = list("red_dye" = 1, "white_dye" = 1)
			result_amount = 2

		purple_dye
			name = "purple_dye"
			id = "purple_dye"
			result = "purple_dye"
			required_reagents = list("red_dye" = 1, "blue_dye" = 1)
			result_amount = 2

		yellow_dye
			name = "yellow_dye"
			id = "yellow_dye"
			result = "yellow_dye"
			required_reagents = list("red_dye" = 1, "green_dye" = 1)
			result_amount = 2

		white_dye
			name = "white_dye"
			id = "white_dye"
			result = "white_dye"
			required_reagents = list("sodiumchloride" = 1, "ammonia" = 1)
			result_amount = 2

		black_dye
			name = "black_dye"
			id = "black_dye"
			result = "black_dye"
			required_reagents = list("orange_dye" = 1, "purple_dye" = 1)
			result_amount = 2

		rainbow_dye
			name = "rainbow_dye"
			id = "rainbow_dye"
			result = "rainbow_dye"
			required_reagents = list("banana" = 1, "white_dye" = 1, "stabilizer" = 1)
			result_amount = 1

		nutriment
			name = "nutriment"
			id = "nutriment"
			result = "nutriment"
			required_reagents = list("poo" = 1, "enzyme" = 1, "ammonia" = 1)
			result_amount = 3

		dongoprazine
			name = "dongoprazine"
			id = "dongoprazine"
			result = "dongoprazine"
			required_reagents = list("blood" = 1, "cum" = 1, "poo" = 1,  "vomit" = 1)
			result_amount = 2

		crayon_red
			name = "crayon_red"
			id = "crayon_red"
			result = null
			required_reagents = list("red_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/red(location)
				return

		crayon_blue
			name = "crayon_blue"
			id = "crayon_blue"
			result = null
			required_reagents = list("blue_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/blue(location)
				return

		crayon_orange
			name = "crayon_orange"
			id = "crayon_orange"
			result = null
			required_reagents = list("orange_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/orange(location)
				return

		crayon_yellow
			name = "crayon_yellow"
			id = "crayon_yellow"
			result = null
			required_reagents = list("yellow_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/yellow(location)
				return

		crayon_purple
			name = "crayon_purple"
			id = "crayon_purple"
			result = null
			required_reagents = list("purple_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/purple(location)
				return

		crayon_green
			name = "crayon_green"
			id = "crayon_green"
			result = null
			required_reagents = list("green_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/green(location)
				return

		crayon_mime
			name = "crayon_mime"
			id = "crayon_mime"
			result = null
			required_reagents = list("black_dye" = 8, "white_dye" = 8, "rainbow_dye" = 8)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/mime(location)
				return

		crayon_rainbow
			name = "crayon_rainbow"
			id = "crayon_rainbow"
			result = null
			required_reagents = list("rainbow_dye" = 25)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/toy/crayon/rainbow(location)
				return

		soap
			name = "soap"
			id = "soap"
			result = null
			required_reagents = list("lube" = 10, "nutriment" = 10, "plasma" = 5)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/weapon/soap/nanotrasen(location)
				return

//////////////////////////////////////////FOOD MIXTURES////////////////////////////////////

		tofu
			name = "Tofu"
			id = "tofu"
			result = null
			required_reagents = list("soymilk" = 10)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/tofu(location)
				return

		icecream
			name = "Icecream"
			id = "icecream1"
			result = null
			required_reagents = list("milk" = 10)
			required_catalysts = list("ice" = 5, "sodiumchloride" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/icecream(location)
				return
		richicecream
			name = "Rich Icecream"
			id = "icecream2"
			result = null
			required_reagents = list("cream" = 10)
			required_catalysts = list("ice" = 5, "sodiumchloride" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/richicecream(location)
				return

		tofuicecream
			name = "Vegan Icecream"
			id = "icecream3"
			result = null
			required_reagents = list("soymilk" = 10)
			required_catalysts = list("ice" = 5, "sodiumchloride" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/tofuicecream(location)
				return
		pooicecream
			name = "Chocolate Icecream"
			id = "icecream4"
			result = null
			required_reagents = list("poo" = 10)
			required_catalysts = list("ice" = 5, "sodiumchloride" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/pooicecream(location)
				return

		chocolate_bar
			name = "Chocolate Bar"
			id = "chocolate_bar"
			result = null
			required_reagents = list("soymilk" = 2, "coco" = 2, "sugar" = 2)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)
				return

		chocolate_bar2
			name = "Chocolate Bar"
			id = "chocolate_bar"
			result = null
			required_reagents = list("milk" = 2, "coco" = 2, "sugar" = 2)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				for(var/i = 1, i <= created_volume, i++)
					new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)
				return

		hot_coco
			name = "Hot Coco"
			id = "hot_coco"
			result = "hot_coco"
			required_reagents = list("water" = 5, "coco" = 1)
			result_amount = 5

		soysauce
			name = "Soy Sauce"
			id = "soysauce"
			result = "soysauce"
			required_reagents = list("soymilk" = 4, "acid" = 1)
			result_amount = 5

		cheesewheel
			name = "Cheesewheel"
			id = "cheesewheel"
			result = null
			required_reagents = list("milk" = 40)
			required_catalysts = list("enzyme" = 5)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel(location)
				return

		synthflesh
			name = "synthflesh"
			id = "synthflesh"
			result = null
			required_reagents = list("blood" = 5, "clonexadone" = 1)
			result_amount = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				new /obj/item/weapon/synthflesh(location)
				return

		hot_ramen
			name = "Hot Ramen"
			id = "hot_ramen"
			result = "hot_ramen"
			required_reagents = list("water" = 1, "dry_ramen" = 3)
			result_amount = 3

		hell_ramen
			name = "Hell Ramen"
			id = "hell_ramen"
			result = "hell_ramen"
			required_reagents = list("capsaicin" = 1, "hot_ramen" = 6)
			result_amount = 6


////////////////////////////////////////// COCKTAILS //////////////////////////////////////

		goldschlager
			name = "Goldschlager"
			id = "goldschlager"
			result = "goldschlager"
			required_reagents = list("vodka" = 10, "gold" = 1)
			result_amount = 10

		patron
			name = "Patron"
			id = "patron"
			result = "patron"
			required_reagents = list("tequilla" = 10, "silver" = 1)
			result_amount = 10

		bilk
			name = "Bilk"
			id = "bilk"
			result = "bilk"
			required_reagents = list("milk" = 1, "beer" = 1)
			result_amount = 2

		icetea
			name = "Iced Tea"
			id = "icetea"
			result = "icetea"
			required_reagents = list("ice" = 1, "tea" = 3)
			result_amount = 4

		icecoffee
			name = "Iced Coffee"
			id = "icecoffee"
			result = "icecoffee"
			required_reagents = list("ice" = 1, "coffee" = 3)
			result_amount = 4

		moonshine
			name = "Moonshine"
			id = "moonshine"
			result = "moonshine"
			required_reagents = list("nutriment" = 10)
			required_catalysts = list("enzyme" = 5)
			result_amount = 10

		wine
			name = "Wine"
			id = "wine"
			result = "wine"
			required_reagents = list("berryjuice" = 10)
			required_catalysts = list("enzyme" = 5)
			result_amount = 10

		vodka
			name = "Vodka"
			id = "vodka"
			result = "vodka"
			required_reagents = list("potato" = 10)
			required_catalysts = list("enzyme" = 5)
			result_amount = 10

		kahlua
			name = "Kahlua"
			id = "kahlua"
			result = "kahlua"
			required_reagents = list("coffee" = 5, "sugar" = 5)
			required_catalysts = list("enzyme" = 5)
			result_amount = 5

		cokalua
			name = "Cokahlua"
			id = "cokahlua"
			result = "cokahlua"
			required_reagents = list("hot_coco" = 1, "kalua" = 1)
			//required_catalysts = list("enzyme" = 5)
			result_amount = 5

		gin_tonic
			name = "Gin and Tonic"
			id = "gintonic"
			result = "gintonic"
			required_reagents = list("gin" = 2, "tonic" = 1)
			result_amount = 3

		cuba_libre
			name = "Cuba Libre"
			id = "cubalibre"
			result = "cubalibre"
			required_reagents = list("rum" = 2, "cola" = 1)
			result_amount = 3

		fortran_fanta
			name = "FORTRAN Fanta"
			id = "fortranfanta"
			result = "fortranfanta"
			required_container = /obj/item/weapon/reagent_containers/food/drinks/shaker
			required_reagents = list("robustersdelight" = 3, "Robustmins_cola" = 1)
			required_catalysts = list("singulo" = 2, "berryjuice" = 2, "sugar" = 2)
			required_stabilizers = list("bananium" = 2)
			volatility = 4
			result_amount = 1 //this is meant to be ultrapurified robustness for adminbus purposes only, so don't be bitching it's so hard to mix up --soyuz

		martini
			name = "Classic Martini"
			id = "martini"
			result = "martini"
			required_reagents = list("gin" = 2, "vermouth" = 1)
			result_amount = 3

		vodkamartini
			name = "Vodka Martini"
			id = "vodkamartini"
			result = "vodkamartini"
			required_reagents = list("vodka" = 2, "vermouth" = 1)
			result_amount = 3


		white_russian
			name = "White Russian"
			id = "whiterussian"
			result = "whiterussian"
			required_reagents = list("vodka" = 3, "cream" = 1, "kahlua" = 1)
			result_amount = 5

		gay_russian
			name = "Gay Russian"
			id = "gayrussian"
			result = "gayrussian"
			required_reagents = list("vodka" = 3, "cum" = 1, "kahlua" = 1)
			result_amount = 5

		whiskey_cola
			name = "Whiskey Cola"
			id = "whiskeycola"
			result = "whiskeycola"
			required_reagents = list("whiskey" = 2, "cola" = 1)
			result_amount = 3

		screwdriver
			name = "Screwdriver"
			id = "screwdrivercocktail"
			result = "screwdrivercocktail"
			required_reagents = list("vodka" = 2, "orangejuice" = 1)
			result_amount = 3

		bloody_mary
			name = "Bloody Mary"
			id = "bloodymary"
			result = "bloodymary"
			required_reagents = list("vodka" = 1, "tomatojuice" = 2, "limejuice" = 1)
			result_amount = 4

		gargle_blaster
			name = "Pan-Galactic Gargle Blaster"
			id = "gargleblaster"
			result = "gargleblaster"
			required_reagents = list("vodka" = 1, "gin" = 1, "whiskey" = 1, "cognac" = 1, "limejuice" = 1)
			result_amount = 5

		brave_bull
			name = "Brave Bull"
			id = "bravebull"
			result = "bravebull"
			required_reagents = list("tequilla" = 2, "kahlua" = 1)
			result_amount = 3

		tequilla_sunrise
			name = "Tequilla Sunrise"
			id = "tequillasunrise"
			result = "tequillasunrise"
			required_reagents = list("tequilla" = 2, "orangejuice" = 1)
			result_amount = 3

		toxins_special
			name = "Toxins Special"
			id = "toxinsspecial"
			result = "toxinsspecial"
			required_reagents = list("rum" = 2, "vermouth" = 1, "plasma" = 2)
			result_amount = 5

		beepsky_smash
			name = "Beepksy Smash"
			id = "beepksysmash"
			result = "beepskysmash"
			required_reagents = list("limejuice" = 2, "whiskey" = 2, "iron" = 1)
			result_amount = 4

		doctor_delight
			name = "The Doctor's Delight"
			id = "doctordelight"
			result = "doctorsdelight"
			required_reagents = list("limejuice" = 1, "tomatojuice" = 1, "orangejuice" = 1, "cream" = 1)
			result_amount = 4

		irish_cream
			name = "Irish Cream"
			id = "irishcream"
			result = "irishcream"
			required_reagents = list("whiskey" = 2, "cream" = 1)
			result_amount = 3

		manly_dorf
			name = "The Manly Dorf"
			id = "manlydorf"
			result = "manlydorf"
			required_reagents = list ("beer" = 1, "ale" = 1)
			result_amount = 2

		hooch
			name = "Hooch"
			id = "hooch"
			result = "hooch"
			required_reagents = list ("sugar" = 1, "ethanol" = 2, "fuel" = 1)
			result_amount = 3

		irish_coffee
			name = "Irish Coffee"
			id = "irishcoffee"
			result = "irishcoffee"
			required_reagents = list("irishcream" = 1, "coffee" = 1)
			result_amount = 2

		b52
			name = "B-52"
			id = "b52"
			result = "b52"
			required_reagents = list("irishcream" = 1, "kahlua" = 1, "cognac" = 1)
			result_amount = 3

		atomicbomb
			name = "Atomic Bomb"
			id = "atomicbomb"
			result = "atomicbomb"
			required_reagents = list("b52" = 10, "uranium" = 1)
			result_amount = 10

		margarita
			name = "Margarita"
			id = "margarita"
			result = "margarita"
			required_reagents = list("tequilla" = 2, "limejuice" = 1)
			result_amount = 3

		longislandicedtea
			name = "Long Island Iced Tea"
			id = "longislandicedtea"
			result = "longislandicedtea"
			required_reagents = list("vodka" = 1, "gin" = 1, "tequilla" = 1, "cubalibre" = 1)
			result_amount = 4

		threemileisland
			name = "Three Mile Island Iced Tea"
			id = "threemileisland"
			result = "threemileisland"
			required_reagents = list("longislandicedtea" = 10, "uranium" = 1)
			result_amount = 10

		whiskeysoda
			name = "Whiskey Soda"
			id = "whiskeysoda"
			result = "whiskeysoda"
			required_reagents = list("whiskey" = 2, "sodawater" = 1)
			result_amount = 3

		black_russian
			name = "Black Russian"
			id = "blackrussian"
			result = "blackrussian"
			required_reagents = list("vodka" = 3, "kahlua" = 2)
			result_amount = 5

		manhattan
			name = "Manhattan"
			id = "manhattan"
			result = "manhattan"
			required_reagents = list("whiskey" = 2, "vermouth" = 1)
			result_amount = 3

		manhattan_proj
			name = "Manhattan Project"
			id = "manhattan_proj"
			result = "manhattan_proj"
			required_reagents = list("manhattan" = 10, "uranium" = 1)
			result_amount = 10

		vodka_tonic
			name = "Vodka and Tonic"
			id = "vodkatonic"
			result = "vodkatonic"
			required_reagents = list("vodka" = 2, "tonic" = 1)
			result_amount = 3

		gin_fizz
			name = "Gin Fizz"
			id = "ginfizz"
			result = "ginfizz"
			required_reagents = list("gin" = 2, "sodawater" = 1, "limejuice" = 1)
			result_amount = 4

		bahama_mama
			name = "Bahama mama"
			id = "bahama_mama"
			result = "bahama_mama"
			required_reagents = list("rum" = 2, "orangejuice" = 2, "limejuice" = 1, "ice" = 1)
			result_amount = 6

		sbiten
			name = "Sbiten"
			id = "sbiten"
			result = "sbiten"
			required_reagents = list("vodka" = 10, "capsaicin" = 1)
			result_amount = 10

		red_mead
			name = "Red Mead"
			id = "red_mead"
			result = "red_mead"
			required_reagents = list("blood" = 1, "mead" = 1)
			result_amount = 2

		mead
			name = "Mead"
			id = "mead"
			result = "mead"
			required_reagents = list("sugar" = 1, "water" = 1)
			required_catalysts = list("enzyme" = 5)
			result_amount = 2

		iced_beer
			name = "Iced Beer"
			id = "iced_beer"
			result = "iced_beer"
			required_reagents = list("beer" = 10, "frostoil" = 1)
			result_amount = 10

		iced_beer2
			name = "Iced Beer"
			id = "iced_beer"
			result = "iced_beer"
			required_reagents = list("beer" = 5, "ice" = 1)
			result_amount = 6

		grog
			name = "Grog"
			id = "grog"
			result = "grog"
			required_reagents = list("rum" = 1, "water" = 1)
			result_amount = 2

		nuka_cola
			name = "Nuka Cola"
			id = "nuka_cola"
			result = "nuka_cola"
			required_reagents = list("uranium" = 1, "cola" = 5)
			result_amount = 5

		soy_latte
			name = "Soy Latte"
			id = "soy_latte"
			result = "soy_latte"
			required_reagents = list("coffee" = 1, "soymilk" = 1)
			result_amount = 2

		cafe_latte
			name = "Cafe Latte"
			id = "cafe_latte"
			result = "cafe_latte"
			required_reagents = list("coffee" = 1, "milk" = 1)
			result_amount = 2

		acidspit
			name = "Acid Spit"
			id = "acidspit"
			result = "acidspit"
			required_reagents = list("acid" = 1, "wine" = 5)
			result_amount = 6

		amasec
			name = "Amasec"
			id = "amasec"
			result = "amasec"
			required_reagents = list("iron" = 1, "wine" = 5, "vodka" = 5)
			result_amount = 10

		neurotoxin
			name = "Neurotoxin"
			id = "neurotoxin"
			result = "neurotoxin"
			required_reagents = list("gargleblaster" = 1, "stoxin" = 1)
			result_amount = 2

		hippiesdelight
			name = "Hippies Delight"
			id = "hippiesdelight"
			result = "hippiesdelight"
			required_reagents = list("psilocybin" = 1, "gargleblaster" = 1)
			result_amount = 2

		bananahonk
			name = "Banana Honk"
			id = "bananahonk"
			result = "bananahonk"
			required_reagents = list("banana" = 1, "cream" = 1, "sugar" = 1)
			result_amount = 3

		singulo
			name = "Singulo"
			id = "singulo"
			result = "singulo"
			required_reagents = list("vodka" = 5, "radium" = 1, "plasma" = 1, "wine" = 5)
			result_amount = 10


//disinfecting of foods

		saltkillbacteria
			name = "saltkillbacteria"
			id = "saltkillbacteria"
			result = "saltkillbacteria"
			required_reagents = list("bad_bacteria" = 1, "sodium" = 1 )
			result_amount = null

		tabsaltkillbacteria
			name = "tabsaltkillbacteria"
			id = "tabsaltkillbacteria"
			result = "tabsaltkillbacteria"
			required_reagents = list("bad_bacteria" = 1, "sodiumchloride" = 1 )
			result_amount = null

		alckillbacteria
			name = "alckillbacteria"
			id = "alckillbacteria"
			result = "alckillbacteria"
			required_reagents = list("bad_bacteria" = 1)
			required_catalysts = list("ethanol" = 5)
			result_amount = null

		sterkillbacteria
			name = "sterkillbacteria"
			id = "sterkillbacteria"
			result = "sterkillbacteria"
			required_reagents = list("bad_bacteria" = 1)
			required_catalysts = list("sterilizine" = 1)
			result_amount = null

		lemonjuicekillbacteria //citric acid is apparently bad for bacteria, I was informed that fish can be preserved using lime juice, so lemons work too. Oranges aren't as acidic so I'm leaving them out.
			name = "lemonjuicekillbacteria"
			id = "lemonjuicekillbacteria"
			result = "lemonjuicekillbacteria"
			required_reagents = list("bad_bacteria" = 1, "lemonjuice" = 1 )
			result_amount = null

		limejuicekillbacteria
			name = "limejuicekillbacteria"
			id = "limejuicekillbacteria"
			result = "limejuicekillbacteria"
			required_reagents = list("bad_bacteria" = 1, "limejuice" = 1 )
			result_amount = null
