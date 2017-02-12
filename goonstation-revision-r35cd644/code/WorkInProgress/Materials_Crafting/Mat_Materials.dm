/datum/trigger_delegate
	var/datum/owner = null
	var/procname = null

	New(var/datum/D, var/name)
		owner = D
		procname = name

/datum/material
	var/atom/owner = null
	var/mat_id = "ohshitium" //used to retrieve instances of these base materials from the cache.
	var/name = "Youshouldneverseemeium"
	var/desc = "This is a custom material."
	var/list/parent_materials = list() //Holds the parent materials.
	var/list/properties = list()

	var/generation = 0 //Compound generation

	var/canMix = 1 						//Can this be mixed with other materials?
	var/material_flags = 0				//Various flags. See defines in _setup.dm.

	var/list/prefixes = list() //goes before the name
	var/list/suffixes = list() //and after it.

	var/texture = null //if not null, texture will be set when mat is applied.
	var/texture_blend = ICON_MULTIPLY //How to blend the texture.

		//properties
	var/color 					   = "#FFFFFF" //The color of the material
	var/alpha 					   = 255 //The "transparency" of the material. Kept as alpha for logical reasons. Displayed as percentage ingame.
	var/quality                    = 0 //Overall quality affects max caps of properties. -100 to 100, higher is better. Inherent quality overrides asteroid quality if higher and non-zero. This means that if you define a non-zero positive quality for a material you will never mine it at a quality below the one defined here.
	//Other

	proc/getAdjustedMax(var/property)
		if(properties.Find(property))
			var/datum/material_property/P = properties[property]
			return max(P.value_max + round(P.value_max * (quality / 100)), P.value_min)
		return

	proc/getProperty(var/property, var/type = VALUE_CURRENT)
		if(properties.Find(property))
			var/datum/material_property/P = properties[property]
			switch(type)
				if(VALUE_CURRENT)
					P.value = min(getAdjustedMax(property), P.value) //This makes sure that no values are over their maximum bounds. This can happen when quality changes after the material was created since no further maximum bound checking happens after creation (unless setProperty is used). It's not pretty but it will do.
					return P.value
				if(VALUE_MIN)
					return P.value_min
				if(VALUE_MAX)
					return getAdjustedMax(property)
		else return 0

	proc/adjustProperty(var/property, var/value)
		if(properties.Find(property))
			var/datum/material_property/P = properties[property]
			if(value) P.value = min(max(P.value + value, P.value_min),  getAdjustedMax(property))
		else
			setProperty(property, value)
		return

	proc/setProperty(var/property, var/value, var/value_min, var/value_max) //Man overloading would be sweet.
		if(istype(property, /datum/material_property))
			var/datum/material_property/mt = property
			properties[mt.name] = property
			mt.value = min( max(mt.value, mt.value_min), getAdjustedMax(mt.name) )
		else if(istext(property))
			if(properties.Find(property))
				var/datum/material_property/P = properties[property]

				if(value_min) P.value_min = value_min

				if(value_max) P.value_max = value_max

				if(value) P.value = min(max(value, P.value_min),  getAdjustedMax(property))
			else
				properties.Add(property)
				var/datum/material_property/P = new/datum/material_property()

				P.name = property

				if(value_min) P.value_min = value_min
				else P.value_min = 1

				if(value_max) P.value_max = value_max
				else P.value_max = 100

				if(value) P.value = min(max(value, P.value_min), getAdjustedMax(property))
				else P.value = 1

				properties[property] = P
		return

	proc/hasProperty(var/property)
		return properties.Find(property)

		//properties

	proc/addDelegate(var/list/L, var/datum/materialProc/D)
		//POOLING: CREATE COPY OF MATERIAL BEFORE MODIFICATION HERE
		for(var/datum/materialProc/P in L)
			if(P.type == D.type) return 0
		L.Add(D)
		L[D] = 0
		//if(L == triggersOnAdd) D.execute(owner) //Run onadd procs when they are
		return

	proc/fail()
		del(owner)
		return

	var/list/triggersFail = list()  //Called when the material fails due to instability.
	var/list/triggersTemp = list()  //Called when exposed to temperatures.
	var/list/triggersChem = list()	//Called when exposed to chemicals
	var/list/triggersPickup = list()//Called when owning object is picked up
	var/list/triggersDrop = list()	//Called when owning object is dropped
	var/list/triggersExp = list()	//Called when exposed to explosions
	var/list/triggersOnAdd = list()	//Called when the material is added to an object
	var/list/triggersOnLife = list()//Called when the life proc of a mob that has the owning item equipped runs
	var/list/triggersOnAttack = list()//Called when the owning object is used to attack something or someone.
	var/list/triggersOnAttacked = list()//Called when a mob wearing the owning object is attacked.
	var/list/triggersOnEntered = list()//Called when *something* enters a turf with the material assigned.

	proc/triggerOnFail(var/atom/owner)
		for(var/datum/materialProc/X in triggersFail)
			call(X,  "execute")(owner)
		fail()
		return

	proc/triggerOnEntered(var/atom/owner, var/atom/entering)
		for(var/datum/materialProc/X in triggersOnEntered)
			call(X,  "execute")(owner, entering)
		return

	proc/triggerOnAttacked(var/obj/item/owner, var/mob/attacker, var/mob/attacked, var/atom/weapon)
		for(var/datum/materialProc/X in triggersOnAttacked)
			call(X,  "execute")(owner, attacker, attacked, weapon)
		return

	proc/triggerOnAttack(var/obj/item/owner, var/mob/attacker, var/mob/attacked)
		for(var/datum/materialProc/X in triggersOnAttack)
			call(X,  "execute")(owner, attacker, attacked)
		return

	proc/triggerOnLife(var/mob/M, var/obj/item/I)
		for(var/datum/materialProc/X in triggersOnLife)
			call(X,  "execute")(M, I)
		return

	proc/triggerOnAdd(var/location)
		for(var/datum/materialProc/X in triggersOnAdd)
			call(X,  "execute")(location)
		return

	proc/triggerChem(var/location, var/chem, var/amount)
		for(var/datum/materialProc/X in triggersChem)
			call(X,  "execute")(location, chem, amount)
		return

	proc/triggerPickup(var/mob/M)
		for(var/datum/materialProc/X in triggersPickup)
			call(X,  "execute")(M)
		return

	proc/triggerDrop(var/mob/M)
		for(var/datum/materialProc/X in triggersDrop)
			call(X,  "execute")(M)
		return

	proc/triggerTemp(var/location, var/temp)
		for(var/datum/materialProc/X in triggersTemp)
			call(X,  "execute")(location, temp)
		return

	proc/triggerExp(var/location, var/sev)
		for(var/datum/materialProc/X in triggersExp)
			call(X,  "execute")(location, sev)
		return

// Metals

/datum/material/metal
	material_flags = MATERIAL_METAL
	color = "#8C8C8C"

/datum/material/metal/electrum
	mat_id = "electrum"
	name = "electrum"
	desc = "Solid energy."
	color = "#44ACAC"
	material_flags = MATERIAL_METAL
	quality = 5

	New()
		setProperty(new/datum/material_property/electrical{ value = 80 }())
		setProperty(new/datum/material_property/hardness{ value = 10 }())
		setProperty(new/datum/material_property/toughness{ value = 5 }())
		setProperty(new/datum/material_property/energy{ value = 45 }())
		return ..()

/datum/material/metal/steel
	mat_id = "steel"
	name = "steel"
	desc = "Terrestrial steel from Earth."
	color = "#8C8C8C"
	material_flags = MATERIAL_METAL

/datum/material/metal/mauxite
	mat_id = "mauxite"
	name = "mauxite"
	desc = "Mauxite is a sturdy common metal."
	color = "#574846"
	New()
		setProperty(new/datum/material_property/hardness{ value = 15 }())
		setProperty(new/datum/material_property/shear{ value = 33 }())
		setProperty(new/datum/material_property/compressive{ value = 33 }())
		setProperty(new/datum/material_property/tensile{ value = 33 }())
		return ..()

/datum/material/metal/pharosium
	mat_id = "pharosium"
	name = "pharosium"
	desc = "Pharosium is a conductive metal."
	color = "#E39362"
	New()
		setProperty(new/datum/material_property/electrical{ value = 75 }())
		setProperty(new/datum/material_property/dielectric{ value = 65 }())
		setProperty(new/datum/material_property/permittivity{ value = 25 }())
		return ..()

/datum/material/metal/cobryl
	mat_id = "cobryl"
	name = "cobryl"
	desc = "Cobryl is a somewhat valuable metal."
	color = "#84D5F0"
	New()
		setProperty(new/datum/material_property/value{ value = 4000 }())
		setProperty(new/datum/material_property/shear{ value = 1 }())
		setProperty(new/datum/material_property/compressive{ value = 1 }())
		return ..()

/datum/material/metal/bohrum
	mat_id = "bohrum"
	name = "bohrum"
	desc = "Bohrum is a heavy and highly durable metal."
	color = "#3D692D"
	New()
		setProperty(new/datum/material_property/melting{ value = T0C + 4000 }())
		setProperty(new/datum/material_property/hardness{ value = 45 }())
		setProperty(new/datum/material_property/toughness{ value = 50 }())
		return ..()

/datum/material/metal/cerenkite
	mat_id = "cerenkite"
	name = "cerenkite"
	desc = "Cerenkite is a highly radioactive metal."
	color = "#CDBDFF"
	material_flags = MATERIAL_ENERGY | MATERIAL_METAL

	New()
		setProperty(new/datum/material_property/melting{ value = T0C + 500 }())
		setProperty(new/datum/material_property/hardness{ value = 5 }())
		setProperty(new/datum/material_property/toughness{ value = 5 }())
		setProperty(new/datum/material_property/energy{ value = 50 }())
		setProperty(new/datum/material_property/radioactivity{ value = 50 }())
		addDelegate(triggersPickup, new /datum/materialProc/cerenkite_pickup())
		addDelegate(triggersOnLife, new /datum/materialProc/cerenkite_life())
		addDelegate(triggersOnAdd, new /datum/materialProc/cerenkite_add())
		addDelegate(triggersOnEntered, new /datum/materialProc/generic_radiation_onenter())
		return ..()

/datum/material/metal/syreline
	mat_id = "syreline"
	name = "syreline"
	desc = "Syreline is an extremely valuable and coveted metal."
	color = "#FAF5D4"
	quality = 30

	New()
		setProperty(new/datum/material_property/value{ value = 10000 }())
		setProperty(new/datum/material_property/hardness{ value = 1 }())
		addDelegate(triggersOnAdd, new /datum/materialProc/gold_add())
		return ..()

/datum/material/metal/gold
	mat_id = "gold"
	name = "gold"
	desc = "A somewhat valuable and conductive metal."
	color = "#F5BE18"
	quality = 30

	New()
		setProperty(new/datum/material_property/value{ value = 3000 }())
		setProperty(new/datum/material_property/hardness{ value = 10 }())
		setProperty(new/datum/material_property/toughness{ value = 1 }())
		setProperty(new/datum/material_property/electrical{ value = 75 }())
		addDelegate(triggersOnAdd, new /datum/materialProc/gold_add())
		return ..()

/datum/material/metal/silver
	mat_id = "silver"
	name = "silver"
	desc = "A slightly valuable and conductive metal."
	color = "#C1D1D2"
	quality = 5

	New()
		setProperty(new/datum/material_property/value{ value = 100 }())
		setProperty(new/datum/material_property/hardness{ value = 15 }())
		setProperty(new/datum/material_property/toughness{ value = 5 }())
		setProperty(new/datum/material_property/electrical{ value = 75 }())
		return ..()

// Special Metals

/datum/material/metal/slag
	mat_id = "slag"
	name = "slag"
	desc = "A by-product left over after material has been processed."
	color = "#26170F"
	quality = -50

	New()
		setProperty(new/datum/material_property/instability{ value = 75 }())
		setProperty(new/datum/material_property/hardness{ value = 1 }())
		setProperty(new/datum/material_property/toughness{ value = 1 }())
		setProperty(new/datum/material_property/shear{ value = 1 }())
		setProperty(new/datum/material_property/compressive{ value = 1 }())
		setProperty(new/datum/material_property/tensile{ value = 1 }())
		return ..()

/datum/material/metal/spacelag
	mat_id = "spacelag"
	name = "spacelag"
	desc = "*BUFFERING*"
	color = "#0F0A08"

	New()
		setProperty(new/datum/material_property/instability{ value = 33 }())
		setProperty(new/datum/material_property/toughness{ value = 50 }())
		setProperty(new/datum/material_property/tensile{ value = 90 }())
		return ..()

/datum/material/metal/iridiumalloy
	mat_id = "iridiumalloy"
	name = "iridium-alloy"
	canMix = 1 //Can not be easily modified.
	desc = "Some sort of advanced iridium alloy."
	color = "#756596"
	material_flags = MATERIAL_METAL | MATERIAL_CRYSTAL
	quality = 60

	New()
		setProperty(new/datum/material_property/toughness{ value = 90 }())
		setProperty(new/datum/material_property/melting{ value = T0C + 10000 }())
		return ..()

//GIVE THIS STATS AND SPECIAL EFFECTS.
/datum/material/metal/soulsteel
	mat_id = "soulsteel"
	name = "soulsteel"
	desc = "A metal imbued with souls. Creepy."
	color = "#73DFF0"
	material_flags = MATERIAL_METAL | MATERIAL_ENERGY

	New()
		setProperty(new/datum/material_property/electrical{ value = 25 }())
		setProperty(new/datum/material_property/dielectric{ value = 65 }())
		setProperty(new/datum/material_property/energy{ value = 60 }())
		return ..()

// Crystals
/datum/material/crystal
	material_flags = MATERIAL_CRYSTAL
	color = "#A3DCFF"

/datum/material/crystal/glass
	mat_id = "glass"
	name = "glass"
	desc = "Terrestrial glass. Inferior to Molitz."
	color = "#A3DCFF"
	alpha = 180

/datum/material/crystal/molitz
	mat_id = "molitz"
	name = "molitz"
	desc = "Molitz is a common crystalline substance."
	color = "#FFFFFF"
	alpha = 180

	New()
		setProperty(new/datum/material_property/hardness{ value = 40 }())
		setProperty(new/datum/material_property/toughness{ value = 40 }())
		return ..()

/datum/material/crystal/claretine
	mat_id = "claretine"
	name = "claretine"
	desc = "Claretine is a highly conductive salt."
	color = "#C2280A"

	New()
		setProperty(new/datum/material_property/electrical{ value = 85 }())
		setProperty(new/datum/material_property/permittivity{ value = 20 }())
		setProperty(new/datum/material_property/dielectric{ value = 5 }())
		return ..()

/datum/material/crystal/erebite
	mat_id = "erebite"
	name = "erebite"
	desc = "Erebite is an extremely volatile high-energy mineral."
	color = "#FF3700"
	material_flags = MATERIAL_CRYSTAL | MATERIAL_ENERGY

	New()
		setProperty(new/datum/material_property/electrical{ value = 95 }())
		setProperty(new/datum/material_property/dielectric{ value = 95 }())
		setProperty(new/datum/material_property/energy{ value = 95 }())
		setProperty(new/datum/material_property/instability{ value = 50 }())
		addDelegate(triggersFail, new /datum/materialProc/fail_explosive(100))
		addDelegate(triggersOnAdd, new /datum/materialProc/erebite_flash())
		addDelegate(triggersTemp, new /datum/materialProc/erebite_temp())
		addDelegate(triggersExp, new /datum/materialProc/erebite_exp())
		addDelegate(triggersOnAttack, new /datum/materialProc/generic_explode_attack(33))
		addDelegate(triggersOnAttacked, new /datum/materialProc/generic_explode_attack(33))
		return ..()

/datum/material/crystal/plasmastone
	mat_id = "plasmastone"
	name = "plasmastone"
	desc = "Plasma in its solid state."
	color = "#A114FF"
	material_flags = MATERIAL_CRYSTAL | MATERIAL_ENERGY

	New()
		setProperty(new/datum/material_property/flammability{ value = 75 }())
		setProperty(new/datum/material_property/energy{ value = 35 }())
		setProperty(new/datum/material_property/hardness{ value = 15 }())
		addDelegate(triggersTemp, new /datum/materialProc/plasmastone())
		addDelegate(triggersExp, new /datum/materialProc/plasmastone())
		return ..()

/datum/material/crystal/plasmaglass
	mat_id = "plasmaglass"
	name = "plasma glass"
	desc = "Crystallized plasma that has been rendered inert. Very hard and prone to making extremely sharp edges."
	color = "#A114FF"
	alpha = 150

	New()
		setProperty(new/datum/material_property/hardness{ value = 65 }())
		setProperty(new/datum/material_property/toughness{ value = 20 }())
		setProperty(new/datum/material_property/compressive{ value = 5 }())
		setProperty(new/datum/material_property/shear{ value = 5 }())
		setProperty(new/datum/material_property/tensile{ value = 5 }())
		return ..()

/datum/material/crystal/gemstone
	mat_id = "quartz"
	name = "quartz"
	desc = "Quartz is somewhat valuable but not paticularly useful."
	color = "#BBBBBB"
	quality = 50
	alpha = 100
	var/gem_tier = 3

	New()
		switch(gem_tier)
			if(1)
				setProperty(new/datum/material_property/hardness{ value = 95 }())
				setProperty(new/datum/material_property/value{ value = 5000 }())
				addDelegate(triggersOnAdd, new /datum/materialProc/gold_add())
			if(2)
				setProperty(new/datum/material_property/hardness{ value = 60 }())
				setProperty(new/datum/material_property/value{ value = 2500 }())
			if(3)
				setProperty(new/datum/material_property/hardness{ value = 30 }())
				setProperty(new/datum/material_property/value{ value = 1000 }())
		return ..()

	diamond
		mat_id = "diamond"
		name = "diamond"
		color = "#FFFFFF"
		quality = 100
		gem_tier = 1

	onyx
		mat_id = "onyx"
		name = "onyx"
		color = "#000000"

	ruby
		mat_id = "ruby"
		name = "ruby"
		color = "#D00000"
		quality = 100
		gem_tier = 1

	rose_quartz
		mat_id = "rosequartz"
		name = "rose quartz"
		color = "#FFC9E8"

	jasper
		mat_id = "jasper"
		name = "jasper"
		color = "#FF7A21"
		quality = 75
		gem_tier = 2

	garnet
		mat_id = "garnet"
		name = "garnet"
		color = "#DB8412"
		quality = 75
		gem_tier = 2

	topaz
		mat_id = "topaz"
		name = "topaz"
		color = "#EBB028"
		quality = 100
		gem_tier = 1

	citrine
		mat_id = "citrine"
		name = "citrine"
		color = "#F5F11B"

	peridot
		mat_id = "peridot"
		name = "peridot"
		color = "#9CC748"
		quality = 75
		gem_tier = 2

	emerald
		mat_id = "emerald"
		name = "emerald"
		color = "#3AB818"
		quality = 100
		gem_tier = 1

	jade
		mat_id = "jade"
		name = "jade"
		color = "#3C8F4D"

	malachite
		mat_id = "malachite"
		name = "malachite"
		color = "#1DF091"
		quality = 75
		gem_tier = 2

	aquamarine
		mat_id = "aquamarine"
		name = "aquamarine"
		color = "#68F7D8"

	sapphire
		mat_id = "sapphire"
		name = "sapphire"
		color = "#2789F2"
		quality = 100
		gem_tier = 1

	lapis
		mat_id = "lapislazuli"
		name = "lapis lazuli"
		color = "#1719BD"
		quality = 75
		gem_tier = 2

	iolite
		mat_id = "iolite"
		name = "iolite"
		color = "#D5A8FF"

	amethyst
		mat_id = "amethyst"
		name = "amethyst"
		color = "#BD0FDB"
		quality = 100
		gem_tier = 1

	alexandrite
		mat_id = "alexandrite"
		name = "alexandrite"
		color = "#EB2FA9"
		quality = 75
		gem_tier = 2

/datum/material/crystal/uqill //Ancients
	mat_id = "uqill"
	name = "uqill"
	desc = "Uqill is a rare and very dense stone."
	color = "#0F0A08"
	alpha = 255

	transparent // For bulletproof windows.
		mat_id = "uqillglass"
		name = "transparent uqill"
		desc = "Uqill-derived material developed for usage as transparent armor."
		color = "#615757"
		alpha = 110

	New()
		setProperty(new/datum/material_property/corrosion { value = 30 }())
		setProperty(new/datum/material_property/hardness{ value = 15 }())
		setProperty(new/datum/material_property/toughness{ value = 80 }())
		setProperty(new/datum/material_property/compressive{ value = 50 }())
		setProperty(new/datum/material_property/shear{ value = 5 }())
		setProperty(new/datum/material_property/tensile{ value = 5 }())
		return ..()

/datum/material/crystal/telecrystal
	mat_id = "telecrystal"
	name = "telecrystal"
	desc = "Telecrystal is a gemstone with space-warping properties."
	color = "#4C14F5"
	material_flags = MATERIAL_CRYSTAL | MATERIAL_ENERGY
	alpha = 100

	New()
		setProperty(new/datum/material_property/scattering { value = 15 }())
		setProperty(new/datum/material_property/reflectivity { value = 1 }())
		setProperty(new/datum/material_property/energy { value = 40 }())
		addDelegate(triggersOnLife, new /datum/materialProc/telecrystal_life())
		addDelegate(triggersOnEntered, new /datum/materialProc/telecrystal_entered())
		return ..()

/datum/material/crystal/miracle
	mat_id = "miracle"
	name = "miraclium"
	desc = "Miraclium is a bizarre substance that can have a wide variety of effects."
	color = "#FFFFFF"

	New()
		addDelegate(triggersOnAdd, new /datum/materialProc/miracle_add())
		quality = rand(-50, 100)
		alpha = rand(20, 255)
		return..()

/datum/material/crystal/starstone
	mat_id = "starstone"
	name = "starstone"
	desc = "An extremely rare jewel."
	color = "#B5E0FF"
	alpha = 80
	quality = 45

	New()
		setProperty(new/datum/material_property/corrosion { value = 50 }())
		setProperty(new/datum/material_property/scattering { value = 8 }())
		setProperty(new/datum/material_property/reflectivity { value = 8 }())
		setProperty(new/datum/material_property/instability { value = 1 }())
		addDelegate(triggersOnAdd, new /datum/materialProc/gold_add())
		return ..()

/datum/material/crystal/ice
	mat_id = "ice"
	name = "ice"
	desc = "The frozen state of water."
	color = "#E8F2FF"
	alpha = 100

	New()
		setProperty(new/datum/material_property/scattering { value = 20 }())
		setProperty(new/datum/material_property/reflectivity { value = 20 }())
		setProperty(new/datum/material_property/compressive { value = 1 }())
		setProperty(new/datum/material_property/instability { value = 20 }())
		addDelegate(triggersOnLife, new /datum/materialProc/ice_life())
		addDelegate(triggersOnAttack, new /datum/materialProc/slippery_attack())
		addDelegate(triggersOnEntered, new /datum/materialProc/slippery_entered())
		return ..()

/datum/material/crystal/wizard
	quality				   = 50
	alpha = 100

	New()
		setProperty(new/datum/material_property/hardness { value = 75 }())
		setProperty(new/datum/material_property/toughness { value = 55 }())
		setProperty(new/datum/material_property/energy { value = 20 }())
		setProperty(new/datum/material_property/value { value = 15000 }())
		setProperty(new/datum/material_property/luminosity { value = 3 }())
		return ..()

	quartz // basically wizard glass
		mat_id = "wiz_quartz"
		name = "enchanted quartz"
		color = "#A3DCFF"

	topaz
		mat_id = "wiz_topaz"
		name = "enchanted topaz"
		color = "#FFC87C"

	ruby
		mat_id = "wiz_ruby"
		name = "enchanted ruby"
		color = "#991933"

	amethyst
		mat_id = "wiz_amethyst"
		name = "enchanted amethyst"
		color = "#9966FF"

	emerald
		mat_id = "wiz_emerald"
		name = "enchanted emerald"
		color = "#4CCC66"

	sapphire
		mat_id = "wiz_sapphire"
		name = "enchanted sapphire"
		color = "#1966B3"

// Organics

/datum/material/organic
	color = "#555555"
	material_flags = MATERIAL_ORGANIC
	alpha 				   = 255
	quality				   = 0

/datum/material/organic/blob
	mat_id = "blob"
	name = "blob"
	desc = "The material of the feared giant space amobea."
	color = "#44cc44"
	material_flags = MATERIAL_ORGANIC | MATERIAL_CRYSTAL | MATERIAL_CLOTH
	alpha = 180
	quality = 2

	New()
		setProperty(new/datum/material_property/toughness { value = 33 }())
		setProperty(new/datum/material_property/electrical { value = 15 }())
		setProperty(new/datum/material_property/thermal { value = 90 }())
		setProperty(new/datum/material_property/corrosion { value = 40 }())
		setProperty(new/datum/material_property/permeability { value = 85 }())
		setProperty(new/datum/material_property/flammability { value = 85 }())
		setProperty(new/datum/material_property/melting { value = T0C+200 }())
		return ..()


/datum/material/organic/flesh
	mat_id = "flesh"
	name = "flesh"
	desc = "Meat from a carbon-based lifeform."
	color = "#574846"
	material_flags = MATERIAL_ORGANIC | MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/toughness { value = 25 }())
		return ..()

	butt
		mat_id = "butt"
		name = "butt"
		desc = "...it's butt flesh. Why is this here. Why do you somehow know it's butt flesh. Fuck."

/datum/material/organic/char
	mat_id = "char"
	name = "char"
	desc = "Char is a fossil energy source similar to coal."
	color = "#555555"

	New()
		setProperty(new/datum/material_property/energy { value = 35 }())
		setProperty(new/datum/material_property/hardness { value = 1 }())
		setProperty(new/datum/material_property/tensile { value = 15 }())
		setProperty(new/datum/material_property/compressive { value = 15 }())
		setProperty(new/datum/material_property/shear { value = 15 }())
		return ..()

/datum/material/organic/koshmarite
	mat_id = "koshmarite"
	name = "koshmarite"
	desc = "An unusual dense pulsating stone. You feel uneasy just looking at it."
	color = "#600066"
	material_flags = MATERIAL_ORGANIC | MATERIAL_CRYSTAL

	New()
		setProperty(new/datum/material_property/reflectivity { value = 90 }())
		setProperty(new/datum/material_property/scattering { value = 50 }())
		setProperty(new/datum/material_property/hardness { value = 50 }())
		setProperty(new/datum/material_property/toughness { value = 50 }())
		return ..()

/datum/material/organic/viscerite
	mat_id = "viscerite"
	name = "viscerite"
	desc = "A disgusting flesh-like material. Ugh. What the hell is this?"
	color = "#D04FFF"
	material_flags = MATERIAL_ORGANIC | MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/corrosion { value = 60 }())
		setProperty(new/datum/material_property/permeability { value = 60 }())
		setProperty(new/datum/material_property/hardness { value = 5 }())
		setProperty(new/datum/material_property/toughness { value = 15 }())
		return ..()

/datum/material/organic/bone
	mat_id = "bone"
	name = "bone"
	desc = "Bone is pretty spooky stuff."
	color = "#DDDDDD"
	material_flags = MATERIAL_ORGANIC // i guess, whatever

	New()
		setProperty(new/datum/material_property/tensile { value = 40 }())
		setProperty(new/datum/material_property/compressive { value = 40 }())
		setProperty(new/datum/material_property/shear { value = 40 }())
		setProperty(new/datum/material_property/hardness { value = 15 }())
		setProperty(new/datum/material_property/toughness { value = 25 }())
		return ..()

/datum/material/organic/chitin
	mat_id = "chitin"
	name = "chitin"
	desc = "Chitin is an organic material found in the exoskeletons of insects."
	color = "#118800"
	material_flags = MATERIAL_ORGANIC // i guess, whatever

	New()
		setProperty(new/datum/material_property/tensile { value = 45 }())
		setProperty(new/datum/material_property/compressive { value = 45 }())
		setProperty(new/datum/material_property/shear { value = 20 }())
		setProperty(new/datum/material_property/hardness { value = 25 }())
		setProperty(new/datum/material_property/toughness { value = 15 }())
		return ..()

/datum/material/organic/beeswax
	mat_id = "beeswax"
	name = "beeswax"
	desc = "An organic material consisting of pollen and space-bee secretions.  Mind your own."
	color = "#C8BB62"
	material_flags = MATERIAL_ORGANIC

	New()
		setProperty(new/datum/material_property/flammability { value = 75 }())
		setProperty(new/datum/material_property/compressive { value = 5 }())
		setProperty(new/datum/material_property/melting { value = T0C + 50 }())
		setProperty(new/datum/material_property/hardness { value = 5 }())
		setProperty(new/datum/material_property/toughness { value = 65 }())
		return ..()
// Fabrics

/datum/material/fabric
	material_flags = MATERIAL_CLOTH
	quality				   = 5

/datum/material/fabric/cloth
	mat_id = "cloth"
	name = "cloth"
	desc = "Generic cloth. Not very special."
	material_flags = MATERIAL_CLOTH

/datum/material/fabric/latex
	mat_id = "latex"
	name = "latex"
	desc = "A type of synthetic rubber. Conducts electricity poorly."
	color = "#DDDDDD" //"#FF0000" idgaf ok I want red cables back. no haine, this stuff isnt red.
	material_flags = MATERIAL_RUBBER

	New()
		setProperty(new/datum/material_property/hardness { value = 1 }())
		setProperty(new/datum/material_property/toughness { value = 25 }())
		setProperty(new/datum/material_property/electrical { value = 20 }())
		return ..()

/datum/material/fabric/synthrubber
	mat_id = "synthrubber"
	name = "synthrubber"
	desc = "A type of synthetic rubber. Conducts electricity poorly."
	color = "#FF0000" //But this is red okay.
	material_flags = MATERIAL_RUBBER

/datum/material/fabric/cloth/leather
	mat_id = "leather"
	name = "leather"
	desc = "Leather is a flexible material derived from processed animal skins."
	color = "#8A3B11"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 25 }())
		setProperty(new/datum/material_property/toughness { value = 25 }())
		setProperty(new/datum/material_property/tensile { value = 30 }())
		return ..()

/datum/material/fabric/cloth/synthleather
	mat_id = "synthleather"
	name = "synthleather"
	desc = "Synthleather is an artificial leather."
	color = "#BB3B11"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 25 }())
		setProperty(new/datum/material_property/toughness { value = 25 }())
		setProperty(new/datum/material_property/tensile { value = 25 }())
		return ..()

/datum/material/fabric/cloth/wendigohide
	mat_id = "wendigohide"
	name = "wendigo hide"
	desc = "The hide of a fearsome wendigo!"
	color = "#CCCCCC"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 25 }())
		setProperty(new/datum/material_property/toughness { value = 35 }())
		setProperty(new/datum/material_property/tensile { value = 35 }())
		setProperty(new/datum/material_property/compressive { value = 35 }())
		setProperty(new/datum/material_property/shear { value = 35 }())
		setProperty(new/datum/material_property/thermal { value = 20 }())
		return ..()

/datum/material/fabric/cloth/wendigohide/king
	mat_id = "kingwendigohide"
	name = "king wendigo hide"
	desc = "The hide of a terrifying wendigo king!!!"
	color = "#EFEEEE"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 65 }())
		setProperty(new/datum/material_property/toughness { value = 65 }())
		setProperty(new/datum/material_property/tensile { value = 65 }())
		setProperty(new/datum/material_property/compressive { value = 65 }())
		setProperty(new/datum/material_property/shear { value = 65 }())
		setProperty(new/datum/material_property/thermal { value = 10 }())
		setProperty(new/datum/material_property/flammability { value = 1 }())
		setProperty(new/datum/material_property/melting { value = T0C + 4000 }())
		return ..()

/datum/material/fabric/cloth/cotton
	mat_id = "cotton"
	name = "cotton"
	desc = "Cotton is a soft and fluffy material obtained from certain plants."
	color = "#FFFFFF"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 1 }())
		setProperty(new/datum/material_property/toughness { value = 20 }())
		setProperty(new/datum/material_property/shear { value = 15 }())
		setProperty(new/datum/material_property/thermal { value = 20 }())
		setProperty(new/datum/material_property/flammability { value = 85 }())
		setProperty(new/datum/material_property/melting { value = T0C + 300 }())
		return ..()

/datum/material/fabric/cloth/fibrilith
	mat_id = "fibrilith"
	name = "fibrilith"
	desc = "Fibrilith is an odd fibrous crystal known for its high tensile strength. Seems a bit similar to asbestos."
	color = "#E0FFF6"
	material_flags = MATERIAL_CLOTH | MATERIAL_CRYSTAL

	New()
		setProperty(new/datum/material_property/hardness { value = 50 }())
		setProperty(new/datum/material_property/toughness { value = 45 }())
		setProperty(new/datum/material_property/tensile { value = 70 }())
		setProperty(new/datum/material_property/thermal { value = 20 }())
		setProperty(new/datum/material_property/flammability { value = 5 }())
		return ..()

	New()
		addDelegate(triggersOnLife, new /datum/materialProc/generic_itchy_onlife())
		return ..()

/datum/material/fabric/cloth/spidersilk
	mat_id = "spidersilk"
	name = "spider silk"
	desc = "Spider silk is a protein fiber spun by space spiders."
	color = "#CCCCCC"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 33 }())
		setProperty(new/datum/material_property/tensile { value = 15 }())
		setProperty(new/datum/material_property/compressive { value = 15 }())
		setProperty(new/datum/material_property/shear { value = 70 }())
		setProperty(new/datum/material_property/thermal { value = 35 }())
		return ..()

/datum/material/fabric/cloth/carbonfibre
	mat_id = "carbonfibre"
	name = "carbon nanofiber"
	desc = "Carbon Nanofibers are highly graphitic carbon nanomaterials with excellent mechanical properties, electrical conductivity and thermal conductivity."
	color = "#333333"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 40 }())
		setProperty(new/datum/material_property/toughness { value = 40 }())
		setProperty(new/datum/material_property/tensile { value = 40 }())
		setProperty(new/datum/material_property/compressive { value = 40 }())
		setProperty(new/datum/material_property/shear { value = 40 }())
		setProperty(new/datum/material_property/electrical { value = 20 }())
		setProperty(new/datum/material_property/thermal { value = 75 }())
		return ..()

/datum/material/fabric/cloth/ectofibre
	mat_id = "ectofibre"
	name = "ectofibre"
	desc = "Ectoplasmic fibres. Sort of transparent. Seems to be rather strong yet flexible."
	color = "#ffffff"
	material_flags = MATERIAL_CLOTH | MATERIAL_ENERGY | MATERIAL_CRYSTAL
	alpha = 128

	New()
		setProperty(new/datum/material_property/hardness { value = 15 }())
		setProperty(new/datum/material_property/toughness { value = 65 }())
		setProperty(new/datum/material_property/shear { value = 20 }())
		setProperty(new/datum/material_property/electrical { value = 20 }())
		setProperty(new/datum/material_property/corrosion { value = 35 }())
		addDelegate(triggersOnLife, new /datum/materialProc/generic_itchy_onlife())
		return ..()

/datum/material/fabric/cloth/dyneema
	mat_id = "dyneema"
	name = "dyneema"
	desc = "A blend of carbon nanofibres and space spider silk. Highly versatile."
	color = "#333333"
	material_flags = MATERIAL_CLOTH

	New()
		setProperty(new/datum/material_property/hardness { value = 15 }())
		setProperty(new/datum/material_property/compressive { value = 75 }())
		setProperty(new/datum/material_property/corrosion { value = 25 }())
		return ..()
// TODO: THESE
/*
/datum/material/wax

/datum/material/plastic

/datum/material/cardboard

*/

