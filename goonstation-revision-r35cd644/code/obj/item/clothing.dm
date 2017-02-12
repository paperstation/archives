/obj/item/clothing
	name = "clothing"
	//var/obj/item/clothing/master = null
	w_class = 2.0

	var/see_face = 1

	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	var/c_flags = null // these don't need to be in the general flags when they only apply to clothes  :I

	var/protective_temperature = 0
	var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/magical = 0 // for wizard item spell power check

	var/radproof = 0           // can this item completely shield you from radiation?
	var/disease_resistance = 0 // how much does this protect you from diseases? (of a 100% chance)

	var/list/compatible_species = list("human") // allow monkeys/mutantraces to wear certain garments

	var/armor_value_melee = 0
	var/armor_value_bullet = 0
	var/armor_value_explosion = 0
	var/cold_resistance = 0
	var/heat_resistance = 0

	var/fallen_offset_x = 1
	var/fallen_offset_z = -6
	/// we want to use Z rather than Y incase anything gets rotated, it would look all jank
	var/monkey_clothes = 0
	// it's clothes specifically for monkeys please don't plaster it to their chest with an offset

	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 0

	flags = FPRINT | TABLEPASS

	onMaterialChanged()
		..()
		if(istype(src.material))
			protective_temperature = material.hasProperty(PROP_MELTING) ? material.getProperty(PROP_MELTING) : protective_temperature
			protective_temperature -= material.getProperty(PROP_FLAMMABILITY) * 10

			heat_transfer_coefficient = material.hasProperty(PROP_THERMAL) ? material.getProperty(PROP_THERMAL) / 100 : heat_transfer_coefficient
			permeability_coefficient = material.hasProperty(PROP_PERMEABILITY) ? material.getProperty(PROP_PERMEABILITY) / 100 : permeability_coefficient
			siemens_coefficient = material.hasProperty(PROP_ELECTRICAL) ? material.getProperty(PROP_ELECTRICAL) / 100 : siemens_coefficient
			disease_resistance = material.hasProperty(PROP_PERMEABILITY) ? (100 - material.getProperty(PROP_PERMEABILITY)) / 2 : 0
			disease_resistance += material.getProperty(PROP_RADIOACTIVITY)
			armor_value_melee = material.hasProperty(PROP_COMPRESSIVE) ? max((material.getProperty(PROP_COMPRESSIVE) - 50) / 3, 0) : armor_value_melee
			armor_value_bullet = material.hasProperty(PROP_SHEAR) ? max((material.getProperty(PROP_SHEAR) - 50) / 25) + 1 : armor_value_bullet
			armor_value_explosion = max(round((material.getProperty(PROP_COMPRESSIVE) + material.getProperty(PROP_TENSILE) - 50) / 20), 0)
		return

/*
/obj/item/clothing/fire_burn(obj/fire/raging_fire, datum/air_group/environment)
	if(raging_fire.internal_temperature > src.s_fire)
		spawn( 0 )
			var/t = src.icon_state
			src.icon_state = ""
			src.icon = 'b_items.dmi'
			flick(text("[]", t), src)
			spawn(14)
				qdel(src)
				return
			return
		return 0
	return 1
*/ //TODO FIX