//The weird name of this file is due to its very specific place in compiling.

//These exist solely to make sure people don't mis-spell some property somewhere and then have trouble finding the bug.
#define PROP_TENSILE "Tensile strength"
#define PROP_COMPRESSIVE "Compressive strength"
#define PROP_SHEAR "Shear Strength"
#define PROP_HARDNESS "Hardness"
#define PROP_TOUGHNESS "Toughness"
#define PROP_REFLECT "Reflectivity"
#define PROP_SCATTER "Scattering"
#define PROP_LUMINOSITY "Luminosity"
#define PROP_FLAMMABILITY "Flammability"
#define PROP_THERMAL "Thermal conductivity"
#define PROP_MELTING "Melting point"
#define PROP_CRITTEMP "Critical temperature"
#define PROP_ELECTRICAL "Electrical conductivity"
#define PROP_DIELECTRIC "Dielectric strength"
#define PROP_PERMITTIVITY "Permittivity"
#define PROP_CORROSION "Corrosion resistance"
#define PROP_RADIOACTIVITY "Radioactivity"
#define PROP_VALUE "Value modifier"
#define PROP_INSTABILITY "Instability"
#define PROP_PERMEABILITY "Permeability"
#define PROP_ENERGY "Inherent energy"

#define VALUE_CURRENT 1
#define VALUE_MAX 2
#define VALUE_MIN 4

/datum/material_property
	var/name = "prop"
	var/value = 0
	var/value_max = 100
	var/value_min = 1	//Never 0, 0 being returned means that the material doesnt have the property.

//Default, crappy, properties below. These exist as a point of reference for the value ranges and for easily setting up default material properties.
/datum/material_property/tensile
	name = PROP_TENSILE
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/compressive
	name = PROP_COMPRESSIVE
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/shear
	name = PROP_SHEAR
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/hardness
	name = PROP_HARDNESS
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/toughness
	name = PROP_TOUGHNESS
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/reflectivity
	name = PROP_REFLECT
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/scattering
	name = PROP_SCATTER
	value = 30
	value_max = 100
	value_min = 1

/datum/material_property/luminosity
	name = PROP_LUMINOSITY
	value = 1
	value_max = 10
	value_min = 1

/datum/material_property/flammability
	name = PROP_FLAMMABILITY
	value = 50
	value_max = 100
	value_min = 1

/datum/material_property/thermal
	name = PROP_THERMAL
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/melting
	name = PROP_MELTING
	value = T0C + 1000
	value_max = INFINITY
	value_min = 1

/datum/material_property/crittemp
	name = PROP_CRITTEMP
	value = T0C - 269
	value_max = INFINITY
	value_min = -INFINITY

/datum/material_property/electrical
	name = PROP_ELECTRICAL
	value = 50
	value_max = 100
	value_min = 1

/datum/material_property/dielectric
	name = PROP_DIELECTRIC
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/permittivity
	name = PROP_PERMITTIVITY
	value = 10
	value_max = 100
	value_min = 1

/datum/material_property/corrosion
	name = PROP_CORROSION
	value = 1
	value_max = 100
	value_min = 1

/datum/material_property/radioactivity
	name = PROP_RADIOACTIVITY
	value = 1
	value_max = 100
	value_min = 1

/datum/material_property/value
	name = PROP_VALUE
	value = 1
	value_max = INFINITY
	value_min = -INFINITY

/datum/material_property/instability
	name = PROP_INSTABILITY
	value = 1
	value_max = 100
	value_min = 1

/datum/material_property/permeability
	name = PROP_PERMEABILITY
	value = 75
	value_max = 100
	value_min = 1

/datum/material_property/energy
	name = PROP_ENERGY
	value = 10
	value_max = 100
	value_min = 1