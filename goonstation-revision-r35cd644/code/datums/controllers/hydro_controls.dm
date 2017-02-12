var/datum/hydroponics_controller/hydro_controls

/datum/hydroponics_controller/
	// global variable name is currently "hydro_controls"
	var/max_harvest_cap = 10          // How many items can be harvested at once.
	var/delay_between_harvests = 300  // How long between harvests, in spawn() ticks.
	var/list/plant_species = list()
	var/list/mutations = list()
	var/list/strains = list()

	var/image/pot_death_display = null
	var/image/pot_health_display = null
	var/image/pot_harvest_display = null

	proc/set_up()
		pot_death_display = image('icons/obj/hydroponics/hydroponics.dmi', "led-dead")
		pot_health_display = image('icons/obj/hydroponics/hydroponics.dmi', "led-health")
		pot_harvest_display = image('icons/obj/hydroponics/hydroponics.dmi', "led-harv")

		for (var/B in typesof(/datum/plantmutation))
			if (B == /datum/plantmutation)
				continue
			src.mutations += new B(src)

		for (var/C in typesof(/datum/plant_gene_strain))
			if (C == /datum/plant_gene_strain)
				continue
			src.strains += new C(src)

		// You need to do plants after the others or they won't set up properly due to mutations and strains
		// not having been set up yet
		for (var/A in typesof(/datum/plant))
			if (A == /datum/plant)
				continue
			src.plant_species += new A(src)

		spawn(0)
			for (var/datum/plant/P in src.plant_species)
				for (var/X in P.mutations)
					if (ispath(X))
						P.mutations += HY_get_mutation_from_path(X)
						P.mutations -= X

				for (var/X in P.commuts)
					if (ispath(X))
						P.commuts += HY_get_strain_from_path(X)
						P.commuts -= X

/proc/HY_get_species_from_path(var/species_path)
	if (!hydro_controls)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Attempt to find species before controller setup")
		return null
	if (!species_path)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Attempt to find species with null path in controller")
		return null
	if (!hydro_controls.plant_species.len)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Cant find species due to empty species list in controller")
		return null
	for (var/datum/plant/P in hydro_controls.plant_species)
		if (species_path == P.type)
			return P
	logTheThing("debug", null, null, "<b>Hydro Controller:</b> Species \"[species_path]\" not found")
	return null

/proc/HY_get_mutation_from_path(var/mutation_path)
	if (!hydro_controls)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Attempt to find mutation before controller setup")
		return null
	if (!mutation_path)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Attempt to find mutation with null path in controller")
		return null
	if (!hydro_controls.mutations.len)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Cant find mutation due to empty mutation list in controller")
		return null
	for (var/datum/plantmutation/M in hydro_controls.mutations)
		if (mutation_path == M.type)
			return M
	logTheThing("debug", null, null, "<b>Hydro Controller:</b> Mutation \"[mutation_path]\" not found")
	return null

/proc/HY_get_strain_from_path(var/strain_path)
	if (!hydro_controls)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Attempt to find strain before controller setup")
		return null
	if (!strain_path)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Attempt to find strain with null path in controller")
		return null
	if (!hydro_controls.strains.len)
		logTheThing("debug", null, null, "<b>Hydro Controller:</b> Cant find strain due to empty strain list in controller")
		return null
	for (var/datum/plant_gene_strain/S in hydro_controls.strains)
		if (strain_path == S.type)
			return S
	logTheThing("debug", null, null, "<b>Hydro Controller:</b> Strain \"[strain_path]\" not found")
	return null