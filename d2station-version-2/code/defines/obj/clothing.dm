// All currently in-game clothing. Gimmicks moved to obj\clothing\gimmick.dm for all of your gay fantasy roleplay dress-up shenanigans.

/obj/item/clothing
	name = "clothing"
//	var/obj/item/clothing/master = null

	var/see_face = 1.0
	var/colour = null
	var/poop_covering = 0
	var/cursed = 0
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	var/protective_temperature = 0
	var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/radiation_protection = 0.0 //percentage of radiation it will absorb

// EARS

/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	icon_state = "earmuffs"
	protective_temperature = 500
	item_state = "earmuffs"

// GLASSES

/obj/item/clothing/glasses
	name = "glasses"
	icon = 'glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	var/list/random_icon_states = list()

/obj/item/clothing/glasses/blindfold
	name = "blindfold"
	icon_state = "blindfold"
	item_state = "blindfold"

/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "glasses"
	origin_tech = "magnets=2"

/obj/item/clothing/glasses/night
	name = "Night Vision Goggles"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = "magnets=2"

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	icon_state = "glasses"
	random_icon_states = list("glasses", "hglasses")
	item_state = "glasses"

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "Sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	protective_temperature = 1300
	var/already_worn = 0

/obj/item/clothing/glasses/hip_glasses
	desc = "Look really stupid. Do people really wear things like this?"
	name = "hip glasses"
	icon_state = "hip_glasses"
	item_state = "sunglasses"

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	icon_state = "thermal"
	item_state = "glasses"
	origin_tech = "magnets=4"

/obj/item/clothing/glasses/thermal/monocle
	name = "Thermoncle"
	icon_state = "thermoncle"

/obj/item/clothing/glasses/opticlink
	name = "neuro-link visor"
	desc = "An artificial eye system for the blind."
	icon_state = "opticlink"
	item_state = "opticlink"
	origin_tech = "magnets=3"

/obj/item/clothing/glasses/ecto
	name = "Ecto Goggles"
	desc = "Experimental goggles that can track forces of life (and death)."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "A medical eye covering."
	icon_state = "eyepatch"
	item_state = "eyepatch"

// Belt slot clothing (only suspenders for now, because utility belt is a storage item)
/obj/item/clothing/belt
	name = "belt"
	icon = 'belts.dmi'
	flags = FPRINT | TABLEPASS | ONBELT

/obj/item/clothing/belt/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play." //Meh -- Urist
	icon_state = "suspenders"

// NO GLOVES NO LOVES

/obj/item/clothing/gloves
	name = "gloves"
	w_class = 2.0
	icon = 'gloves.dmi'
	protective_temperature = 400
	heat_transfer_coefficient = 0.25
	siemens_coefficient = 0.50
	var/elecgen = 0
	var/uses = 0
	body_parts_covered = HANDS

/obj/item/clothing/gloves/black
	desc = "These gloves are fire-resistant."
	name = "Black Gloves"
	icon_state = "black"
	item_state = "bgloves"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanic leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.9
	protective_temperature = 400
	heat_transfer_coefficient = 0.70

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/latex
	name = "Latex Gloves"
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.01
	protective_temperature = 310
	heat_transfer_coefficient = 0.90

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.30
	protective_temperature = 1100
	heat_transfer_coefficient = 0.05

/obj/item/clothing/gloves/space_ninja
	desc = "These nano-enhanced gloves insulate from electricity and provide fire resistance."
	name = "ninja gloves"
	icon_state = "s-ninja"
	item_state = "swat_gl"
	siemens_coefficient = 0
	protective_temperature = 1100
	heat_transfer_coefficient = 0.05

/obj/item/clothing/gloves/stungloves/
	name = "Stungloves"
	desc = "These gloves are electrically charged."
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0.30
	elecgen = 1
	uses = 10

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/gloves/yellow
	desc = "These gloves are electrically insulated."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	protective_temperature = 1000
	heat_transfer_coefficient = 0.01

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanic leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.9
	protective_temperature = 400
	heat_transfer_coefficient = 0.70

/obj/item/clothing/gloves/boxinggloves
	name = "Boxing Gloves"
	icon_state = "boxinggloves"
	item_state = "boxgloves"
	siemens_coefficient = 0.90
	permeability_coefficient = 0.01
	protective_temperature = 310
	heat_transfer_coefficient = 0.90

/obj/item/clothing/gloves/specops
	desc = "Made of a slightly more resilient material for longer durability."
	name = "Special Ops Gloves"
	icon_state = "ntgloves"
	item_state = "ntgloves"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/gloves/fingerless
	desc = "Fingers on your gloves? Who needs 'em!"
	name = "Fingerless Gloves"
	icon_state = "fingerless"
	item_state = "fingerless"

// HATS. OH MY WHAT A FINE CHAPEAU, GOOD SIR.

/obj/item/clothing/head
	name = "head"
	icon = 'hats.dmi'
	body_parts_covered = HEAD
	var/list/allowed = list(/obj/item/weapon/pen)

/obj/item/clothing/head/beret
	name = "beret"
	desc = "A mime's beret"
	icon_state = "beret"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flat_cap"
	item_state = "detective"

/obj/item/clothing/head/radiation
	name = "Radiation Hood"
	icon_state = "rad"
	radiation_protection = 0.35
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH

/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	icon_state = "bombsuit"
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH

/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	item_state = "bombsuitsec"

/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	permeability_coefficient = 0.01
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH

/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"

/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/head/bio_hood/security
	icon_state = "bio_security"

/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/head/thermal_hood
	name = "thermal hood"
	icon_state = "thermalhood"
	item_state = "thermalhood"
	permeability_coefficient = 0.01
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES|HEADCOVERSMOUTH
	gas_transfer_coefficient = 0.02
	protective_temperature = 7500

/obj/item/clothing/head/cakehat
	name = "cakehat"
	desc = "It is a cakehat"
	icon_state = "cake0"
	var/onfire = 0.0
	var/status = 0
	flags = FPRINT|TABLEPASS|HEADSPACE|HEADCOVERSEYES
	var/fire_resist = T0C+1300	//this is the max temp it can stand before you start to cook. although it might not burn away, you take damage

/obj/item/clothing/head/caphat
	name = "Captain's hat"
	icon_state = "captain"
	flags = FPRINT|TABLEPASS
	item_state = "caphat"

/obj/item/clothing/head/centhat
	name = "Cent. Comm. hat"
	icon_state = "centcom"
	flags = FPRINT|TABLEPASS
	item_state = "centhat"

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"

/obj/item/clothing/head/revanhood
	name = "revan's coat hood"
	icon_state = "revanhood"
	item_state = "revanhood"

/obj/item/clothing/head/nursehat
	name = "nurse's hat"
	desc = ""
	icon_state = "nurse"
	item_state = "nurse"

/obj/item/clothing/head/det_hat
	name = "hat"
	desc = "Someone who wears this will look very smart"
	icon_state = "detective"
	allowed = list(/obj/item/weapon/reagent_containers/food/snacks/candy_corn, /obj/item/weapon/pen)

/obj/item/clothing/head/stockingcap
	name = "stocking cap"
	desc = "Don we now our gay apparel~"
	icon_state = "stockingcap"

/obj/item/clothing/head/e_officerhat
	name = "Enclave Officer's Hat"
	desc = "The favored headwear of many an officer under the command of President Eden."
	icon_state = "e_officerhat"

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig"
	icon_state = "pwig"
	item_state = "pwig"

/obj/item/clothing/head/helmet/bobby
	name = "Custodian Helmet"
	desc = "Heh. Lookit dat fukken helmet."
	icon_state = "policehelm"
	item_state = "helmet"

/obj/item/clothing/head/that
	name = "Top hat"
	desc = "An amish looking hat"
	icon_state = "tophat"
	item_state = "that"
	flags = FPRINT|TABLEPASS|HEADSPACE

/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "It has WIZARD written across it in sequins."
	icon_state = "wizard"

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "It has WIZARD written across it in sequins."
	icon_state = "redwizard"

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARDE written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"

/obj/item/clothing/head/wizard/black
	name = "wizard hat"
	desc = "A dark hood."
	icon_state = "revanhood"

/obj/item/clothing/head/wizard/marisa
	name = "Witch Hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "marisa"

/obj/item/clothing/head/chefhat
	name = "Chef's hat"
	icon_state = "chef"
	item_state = "chef"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/head/plaguedoctorhat
	name = "Plague doctor's hat"
	icon_state = "plaguedoctor"
	flags = FPRINT | TABLEPASS | HEADSPACE
	permeability_coefficient = 0.01

/obj/item/clothing/head/beret
	name = "beret"
	desc = "A mime's beret"
	icon_state = "beret"
	flags = FPRINT | TABLEPASS | HEADSPACE

/obj/item/clothing/head/rabbitears
	name = "Bunny Ears"
	desc = "Cute bunny ears"
	icon_state = "bunny"
	flags = FPRINT | TABLEPASS | HEADSPACE

/obj/item/clothing/head/bunnyhood
	name = "Bunny Hood"
	desc = "the fuck is this"
	icon_state = "bunnyhood"
	flags = FPRINT | TABLEPASS | HEADSPACE

/obj/item/clothing/head/kittyhood
	name = "Kitty Hood"
	desc = "the fuck is this"
	icon_state = "kittyhood"
	flags = FPRINT | TABLEPASS | HEADSPACE

/obj/item/clothing/head/kittyears
	name = "Kitty Ears"
	desc = "Meow?"
	icon_state = "kitty"
	flags = FPRINT | TABLEPASS | HEADSPACE
	var/icon/mob
	var/icon/mob2

	update_icon(var/mob/living/carbon/human/user)
		if(!istype(user)) return
		mob = new/icon("icon" = 'head.dmi', "icon_state" = "kitty")
		mob2 = new/icon("icon" = 'head.dmi', "icon_state" = "kitty2")
		mob.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)
		mob2.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)
		var/icon/earbit = new/icon("icon" = 'head.dmi', "icon_state" = "kittyinner")
		var/icon/earbit2 = new/icon("icon" = 'head.dmi', "icon_state" = "kittyinner2")
		mob.Blend(earbit, ICON_OVERLAY)
		mob2.Blend(earbit2, ICON_OVERLAY)


/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana"
	item_state = "bandana"

// CHUMP HELMETS: COOKING THEM DESTROYS THE CHUMP HELMET SPAWN.

/obj/item/clothing/head/helmet
	name = "helmet"
	icon_state = "helmet"
	flags = FPRINT|TABLEPASS|SUITSPACE|HEADCOVERSEYES
	item_state = "helmet"

	protective_temperature = 500
	heat_transfer_coefficient = 0.10

/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "space"
	flags = FPRINT | TABLEPASS | HEADSPACE | HEADCOVERSEYES | HEADCOVERSMOUTH
	see_face = 0.0
	item_state = "space"
	permeability_coefficient = 0.01

/obj/item/clothing/head/helmet/space/prototype_sp_helm
	name = "prototype space helmet"
	icon_state = "prototype_sp_helmet"
	item_state = "prototype_sp_helmet"
	permeability_coefficient = 0.01
	gas_transfer_coefficient = 0.02
	see_face = 1

/obj/item/clothing/head/helmet/space/rig
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	name = "rig helmet"
	icon_state = "rig"
	item_state = "rig_helm"

/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndicate"

/obj/item/clothing/head/syndicatefake
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "A plastic replica of an agent of the Syndicate's space helmet, you'll look just like a real murderous Syndicate agent in this!"
	see_face = 0.0

/obj/item/clothing/head/helmet/space/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"

/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	icon_state = "santahat"
	item_state = "santahat"

/obj/item/clothing/head/helmet/swat
	name = "swat helmet"
	icon_state = "swat"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADSPACE | HEADCOVERSEYES
	item_state = "swat"

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	icon_state = "riothelm"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	item_state = "riothelm"

/obj/item/clothing/head/helmet/thunderdome
	name = "Thunderdome helmet"
	icon_state = "thunderdome"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADSPACE | HEADCOVERSEYES
	item_state = "thunderdome"

/obj/item/clothing/head/helmet/hardhat
	name = "hard hat"
	icon_state = "hardhat0"
	flags = FPRINT | TABLEPASS | SUITSPACE
	item_state = "hardhat0"
	var/on = 0
	var/brightness_on = 4 //luminosity when on

/obj/item/clothing/head/helmet/bikehelmet
	name = "bike helmet"
	icon_state = "bikehelmet"
	flags = FPRINT | TABLEPASS
	item_state = "bikehelmet"

/obj/item/clothing/head/helmet/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES
	see_face = 0.0
	item_state = "welding"
	var/up = 0
	protective_temperature = 1300
	m_amt = 3000
	g_amt = 1000

/obj/item/clothing/head/helmet/HoS
	name = "HoS helmet"
	icon_state = "hoscap"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES

// MASK WAS THAT MOVIE WITH THAT GUY WITH THE MESSED UP FACE. WHAT'S HIS NAME . . . JIM CARREY, I THINK.

/obj/item/clothing/mask
	name = "mask"
	icon = 'masks.dmi'
	var/vchange = 0
	body_parts_covered = HEAD

/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "gas_mask"
	flags = FPRINT|TABLEPASS|SUITSPACE|MASKCOVERSMOUTH|MASKCOVERSEYES
	w_class = 3.0
	see_face = 0.0
	item_state = "gas_mask"
	protective_temperature = 500
	heat_transfer_coefficient = 0.01
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01

/obj/item/clothing/mask/gas/plaguedoctor
	name = "Plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out toxins but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "gas_mask"

/obj/item/clothing/mask/gas/emergency
	name = "emergency gas mask"
	icon_state = "gas_alt"
	item_state = "gas_alt"

/obj/item/clothing/mask/gas/swat
	name = "SWAT Mask"
	desc = "A close-fitting tactical mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "swat"

/obj/item/clothing/mask/gas/combine
	name ="elite combine helmet"
	icon_state = "gas_alt"
	item_state = "gas_comb_elite"

/obj/item/clothing/mask/gas/revan
	name ="mandalorian mask"
	icon_state = "gas_revan"
	item_state = "gas_revan"

/obj/item/clothing/mask/gas/space_ninja
	name = "ninja mask"
	desc = "A close-fitting mask that acts both as an air filter and a post-modern fashion statement. Can disguise your voice."
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	vchange = 1

/obj/item/clothing/mask/owl_mask
	name = "Owl mask"
	desc = "Twoooo!"
	icon_state = "owl"
	item_state = "owl"

/obj/item/clothing/mask/gas/voice
	name = "gas mask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "gas_mask"
	vchange = 1

/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply but does not work very well in hard vacuum."
	name = "Breath Mask"
	icon_state = "breath"
	item_state = "breath"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADSPACE | MASKCOVERSMOUTH
	w_class = 2
	protective_temperature = 420
	heat_transfer_coefficient = 0.90
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "You're gay for even considering wearing this."
	icon_state = "clown"
	item_state = "clown_hat"

/obj/item/clothing/mask/medical
	desc = "This mask does not work very well in low pressure environments."
	name = "Medical Mask"
	icon_state = "medical"
	item_state = "medical"
	flags = FPRINT|TABLEPASS|SUITSPACE|HEADSPACE|MASKCOVERSMOUTH
	w_class = 3
	protective_temperature = 420
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.10

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/mask/muzzle
	name = "muzzle"
	icon_state = "muzzle"
	item_state = "muzzle"
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/surgical
	name = "Sterile Mask"
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 1
	flags = FPRINT|TABLEPASS|HEADSPACE|MASKCOVERSMOUTH
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.05

/obj/item/clothing/mask/cigarette
	name = "Cigarette"
	icon_state = "cigoff"
	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/icon_butt = "cigbutt"
	throw_speed = 0.5
	item_state = "cigoff"
	var/lastHolder = null
	var/smoketime = 300
	w_class = 1

/obj/item/clothing/mask/cigarette/cigar
	name = "Premium Cigar"
	desc = "Only for the best of space travelers."
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	icon_butt = "cigarbutt"
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "Cohiba Cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	icon_butt = "cigarbutt"

/obj/item/clothing/mask/mime
	name = "mime mask"
	desc = "It looks a little creepy"
	icon_state = "mime"
	throw_speed = 0.5
	var/lastHolder = null
	var/smoketime = 300
	w_class = 1

// OMG SHOES

/obj/item/clothing/shoes
	name = "shoes"
	icon = 'shoes.dmi'

	body_parts_covered = FEET

	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN

/obj/item/clothing/shoes/black
	name = "Black Shoes"
	icon_state = "black"

	protective_temperature = 1500
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/brown
	name = "Brown Shoes"
	icon_state = "brown"

/obj/item/clothing/shoes/brown_blackstockings
	name = "Brown Shoes w/ Black Stockings"
	icon_state = "brown_blackstockings"

/obj/item/clothing/shoes/brown_whitestockings
	name = "Brown Shoes w/ White Stockings"
	icon_state = "brown_whitestockings"

/obj/item/clothing/shoes/red_whitestockings
	name = "Red Shoes w/ White Stockings"
	icon_state = "red_whitestockings"

/obj/item/clothing/shoes/vans
	name = "Vans"
	icon_state = "vans"

/obj/item/clothing/shoes/cock
	name = "Cock"
	icon_state = "cock"

/obj/item/clothing/shoes/orange
	name = "Orange Shoes"
	icon_state = "orange"
	var/chained = 0

/obj/item/clothing/shoes/red
	name = "red shoes"
	icon_state = "red"

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	icon_state = "boots"

/obj/item/clothing/shoes/workboots
	name = "work boots"
	icon_state = "workboots"
	protective_temperature = 1500
	heat_transfer_coefficient = 0.70

/obj/item/clothing/shoes/swat
	name = "SWAT shoes"
	icon_state = "swat"
	slowdown = 0

/obj/item/clothing/shoes/boots
	name = "Boots"
	icon_state = "boots"
	heat_transfer_coefficient = 0.80

/obj/item/clothing/shoes/white
	name = "White Shoes"
	icon_state = "white"
	permeability_coefficient = 0.25

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "Magic Shoes"
	icon_state = "black"

/obj/item/clothing/shoes/touristsandal
	name = "socks and sandals"
	desc = "A favorite footwear combination for visitors to temperate climates."
	icon_state = "tourist"

/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots"
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	flags = NOSLIP
	slowdown = 0

/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	protective_temperature = 800
	heat_transfer_coefficient = 0.01
	var/magpulse = 0
//	flags = NOSLIP //disabled by default

/obj/item/clothing/shoes/clown_shoes
	desc = "Damn, thems some big shoes."
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = 0

/obj/item/clothing/shoes/fireboots
	desc = "Won't burn your feet on fire with these!"
	name = "fire boots"
	icon_state = "fireboots"
	item_state = "fireboots"
	protective_temperature = 800
	heat_transfer_coefficient = 0.01

/obj/item/clothing/shoes/skates
	desc = "Won't slip around on ice with these!"
	name = "skates"
	icon_state = "skates"
	item_state = "skates"

/obj/item/clothing/shoes/flippers
	desc = "You wouldn't be able to swim in that deep water without these!"
	name = "swimming flippers"
	icon_state = "flippers"
	item_state = "flippers"
// SUITS

/obj/item/clothing/suit
	icon = 'suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	flags = FPRINT | TABLEPASS
	var/list/allowed = list(/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	item_state = "bio_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.30
	slowdown = 0.5

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/security
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "Plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	item_state = "bio_suit"

/obj/item/clothing/suit/det_suit
	name = "coat"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/gun/detectiverevolver,/obj/item/weapon/ammo/a38,/obj/item/weapon/cigpacket,/obj/item/weapon/zippo,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)

/obj/item/clothing/suit/hobojacket
	name = "coat"
	desc = "What a ragged, smelly coat."
	icon_state = "hobocoat"
	item_state = "hobocoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/revancoat
	name = "revan's coat"
	icon_state = "revancoat"
	item_state = "revancoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/blackjacket
	name = "black jacket"
	desc = "A black jacket."
	icon_state = "blackjacket"
	item_state = "blackjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/cigpacket,/obj/item/weapon/zippo)

/obj/item/clothing/suit/trenchcoat
	name = "trenchcoat"
	desc = "A long, black coat."
	icon_state = "trenchcoat"
	item_state = "trenchcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/cigpacket,/obj/item/weapon/zippo)

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/cigpacket,/obj/item/weapon/spacecash)

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.30
	slowdown = 1

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	item_state = "bombsuitsec"
	allowed = list(/obj/item/weapon/baton,/obj/item/weapon/handcuffs)

/obj/item/clothing/suit/radiation
	name = "Radiation suit"
	desc = "A suit that protects against radiation."
	icon_state = "rad"
	item_state = "rad_suit"
	//w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 1
	radiation_protection = 0.65
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1.3
	protective_temperature = 4500
	heat_transfer_coefficient = 0.01
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/bedsheet
	name = "bedsheet"
	desc = "A simple device, used to reflect heat from the user, to the user. Also can be used to make epic forts."
	icon = 'items.dmi'
	icon_state = "sheet"
	item_state = "sheet"
	layer = 5
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/bedsheet/captain
	icon_state = "sheet_cap"
	item_state = "sheet_cap"

/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.25
	heat_transfer_coefficient = 0.75
	allowed = list(/obj/item/device/analyzer,/obj/item/weapon/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer)

/obj/item/clothing/suit/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen"
	item_state = "labgreen"

/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
	desc = "A suit that totally restrains an individual"
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = null

/obj/item/clothing/suit/wcoat
	name = "waistcoat"
	icon_state = "vest"
	item_state = "wcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = null

/obj/item/clothing/suit/apron
	name = "apron"
	icon_state = "apron"
	item_state = "apron"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (/obj/item/weapon/plantbgone,/obj/item/device/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/nutrient,/obj/item/weapon/minihoe)

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	icon_state = "death"
	item_state = "death"
	flags = FPRINT | TABLEPASS | CONDUCT
	fire_resist = T0C+5200

/obj/item/clothing/suit/chefcoat
	name = "chef's jacket"
	desc = "Stand above the inferior chefs in your iconic double-breasted chef's jacket! Also provides minor protection against spills."
	permeability_coefficient = 0.80
	icon_state = "chef"
	item_state = "chef"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/medicaltunic
	name = "female medical tunic"
	desc = "A medical tunic for females."
	permeability_coefficient = 0.80
	icon_state = "medicskirt"
	item_state = "medicskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A Nazi great coat"
	icon_state = "nazi"
	item_state = "nazi"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificant, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	heat_transfer_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/teleportation_scroll)

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe one could probably find in Space-Walmart."
	icon_state = "wizard-fake"
	item_state = "wizrobe"

/obj/item/clothing/suit/wizrobe/black
	name = "wizard robe"
	desc = "A sexy wizard robe."
	icon_state = "bwizard"
	item_state = "wizrobe"

/obj/item/clothing/suit/wizrobe/marisa
	name = "Witch Robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"

/obj/item/clothing/suit/johnny_coat
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/hazardvest
	name = "hazard vest"
	desc = "A vest designed to make one more noticable. It's not very good at it though"
	icon_state = "hazard"
	item_state = "hazard"

// ARMOR

/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/baton,/obj/item/weapon/handcuffs)

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/armor/vest/riot
	name = "riot armor"
	desc = "An armored vest with added plating to help protect the wearer's arms and legs."
	icon_state = "riotarmor"
	item_state = "riotarmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/armor/hos
	name = "armored coat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style."
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/armor/a_i_a_ptank
	desc = "A wearable bomb with a health analyzer attached"
	name = "Analyzer/Igniter/Armor/Plasmatank Assembly"
	icon_state = "bomb"
	item_state = "bombvest"
	var/obj/item/device/healthanalyzer/part1 = null
	var/obj/item/device/igniter/part2 = null
	var/obj/item/weapon/tank/plasma/part4 = null
	var/obj/item/clothing/suit/armor/vest/part3 = null
	var/status = 0
	flags = FPRINT | TABLEPASS | CONDUCT | ONESIZEFITSALL
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	desc = "Wearing this armor exemplifies who is in charge. You are in charge."
	icon_state = "caparmor"
	item_state = "caparmor"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/armor/centcomm
	name = "Cent. Com. armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/armor/yellowjacket
	name = "Armored Jacket"
	desc = "A yellow ballistic vest of armor covered by a black jacket."
	icon_state = "armorjacket"
	item_state = "armorjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/armor/spessmarine
	name = "Space Marine Suit"
	desc = "A tank's worth of heavy armor, fitted to be worn by elite assault personnel."
	icon_state = "spacemarinearmour"
	item_state = "space_suit_syndicate"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS|HEAD|HEADCOVERSEYES|HEADCOVERSMOUTH

	/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 2

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome/red
	name = "Thunderdome suit (red)"
	icon_state = "tdred"
	item_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "Thunderdome suit (green)"
	icon_state = "tdgreen"
	item_state = "tdgreen"

/obj/item/clothing/suit/armor/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "heavy"
	item_state = "heavy"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1.5
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/ammo,/obj/item/weapon/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/armor/deathcommando
	name = "Death Commando Suit"
	desc = "Get the hell out of the way of anyone who's wearing this"
	icon_state = "deathcom"
	item_state = "deathcom"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags = FPRINT | TABLEPASS | SUITSPACE

/obj/item/clothing/suit/armor/rig
	name = "rig suit"
	desc = "A special armored suit that protects against hazardous, low pressure environments."
	icon_state = "rigsuit"
	item_state = "rigsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags = FPRINT | TABLEPASS | SUITSPACE
// FIRE SUITS

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "fire"
	item_state = "fire_suit"
	//w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 0.3

	protective_temperature = 4500
	heat_transfer_coefficient = 0.01
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"
	item_state = "firefighter"

/obj/item/clothing/suit/fire/heavy
	name = "thermal protection suit"
	desc = "A specialized firesuit equipped with an internal cooling system. Can protect the user from more than four times the amount of heat a standard firesuit can."
	icon_state = "thermal"
	item_state = "thermal"
	//w_class = 4//bulky item
	protective_temperature = 20000
	heat_transfer_coefficient = 0.01
	slowdown = 1

// SPACE SUITS

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low-pressure environments."
	icon_state = "space"
	gas_transfer_coefficient = 0.01
	item_state = "s_suit"
	w_class = 4 //bulky item
	flags = FPRINT | TABLEPASS | SUITSPACE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1
	radiation_protection = 0.10

/obj/item/clothing/suit/space/rig
	name = "rig suit"
	desc = "A special suit that protects against hazardous, null-pressure environments."
	icon_state = "rigsuitOLD"
	item_state = "rigsuitOLD"
	slowdown = 1
	radiation_protection = 0.40

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/ammo,/obj/item/weapon/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1

/obj/item/clothing/suit/syndicatefake
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A plastic replica of the Syndicate space suit, you'll look just like a real murderous agent of the Syndicate in this!"
	w_class = 2
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)

/obj/item/clothing/suit/space/csavoid
	name = "CSA Voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "A high tech, Centcom Space Administration-approved dark red space suit."
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1.3

/obj/item/clothing/suit/space/space_ninja
	name = "ninja suit"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for Spider-Clan assassins."
	icon_state = "s-ninja"
	item_state = "s-ninja_suit"
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/ammo,/obj/item/weapon/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = -2

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"

/obj/item/clothing/suit/space/blackblue
	name = "space suit"
	icon_state = "space_blackblue"
	item_state = "space_blackblue"

/obj/item/clothing/suit/space/blackred
	name = "space suit"
	icon_state = "space_blackred"
	item_state = "space_blackred"

/obj/item/clothing/suit/space/darkblue
	name = "space suit"
	icon_state = "space_darkblue"
	item_state = "space_darkblue"

/obj/item/clothing/suit/space/darkgreen
	name = "space suit"
	icon_state = "space_darkgreen"
	item_state = "space_darkgreen"

/obj/item/clothing/suit/space/green
	name = "space suit"
	icon_state = "space_green"
	item_state = "space_green"

/obj/item/clothing/suit/space/engie
	name = "space suit"
	icon_state = "space_engie"
	item_state = "space_engie"

/obj/item/clothing/suit/space/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"

// UNDERS AND BY THAT, NATURALLY I MEAN UNIFORMS/JUMPSUITS

/obj/item/clothing/under
	icon = 'uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	protective_temperature = T0C + 50
	heat_transfer_coefficient = 0.30
	permeability_coefficient = 0.90
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/

/obj/item/clothing/under/chameleon
//starts off as black
	name = "Black Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	colour = "black"
	desc = null
	var/list/clothing_choices = list()

/obj/item/clothing/under/chameleon/all

/obj/item/clothing/under/color/black
	name = "Black Jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	colour = "black"

/obj/item/clothing/under/color/blue
	name = "Blue Jumpsuit"
	icon_state = "blue"
	item_state = "b_suit"
	colour = "blue"

/obj/item/clothing/under/color/green
	name = "Green Jumpsuit"
	icon_state = "green"
	item_state = "g_suit"
	colour = "green"

/obj/item/clothing/under/color/grey
	name = "Grey Jumpsuit"
	icon_state = "grey"
	item_state = "gy_suit"
	colour = "grey"

/obj/item/clothing/under/color/orange
	name = "Orange Jumpsuit"
	icon_state = "orange"
	item_state = "o_suit"
	colour = "orange"

/obj/item/clothing/under/color/pink
	name = "Pink Jumpsuit"
	icon_state = "pink"
	item_state = "p_suit"
	colour = "pink"

/obj/item/clothing/under/color/red
	name = "Red Jumpsuit"
	icon_state = "red"
	item_state = "r_suit"
	colour = "red"

/obj/item/clothing/under/color/white
	desc = "Made of a special fiber that gives special protection against biohazards."
	name = "White Jumpsuit"
	icon_state = "white"
	item_state = "w_suit"
	colour = "white"
	permeability_coefficient = 0.50

/obj/item/clothing/under/color/yellow
	name = "Yellow Jumpsuit"
	icon_state = "yellow"
	item_state = "y_suit"
	colour = "yellow"

// RANKS

/obj/item/clothing/under/rank

/obj/item/clothing/under/rank/atmospheric_technician
	desc = "It has an Atmospherics rank stripe on it."
	name = "Atmospherics Jumpsuit"
	icon_state = "atmos"
	item_state = "y_suit"
	colour = "atmos"

/obj/item/clothing/under/rank/captain
	desc = "It has a Captains rank stripe on it."
	name = "Captain Jumpsuit"
	icon_state = "captain"
	item_state = "captain"
	colour = "captain"

/obj/item/clothing/under/rank/chaplain
	desc = "It has a Chaplain rank stripe on it."
	name = "Chaplain Jumpsuit"
	icon_state = "chaplain"
	item_state = "bl_suit"
	colour = "chapblack"

/obj/item/clothing/under/rank/engineer
	desc = "It has an Engineering rank stripe on it."
	name = "Engineering Jumpsuit"
	icon_state = "engine"
	item_state = "y_suit"
	colour = "engine"

/obj/item/clothing/under/rank/forensic_technician
	desc = "It has a Forensics rank stripe on it."
	name = "Forensics Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	colour = "forensicsred"

/obj/item/clothing/under/rank/warden
	desc = "It has a Warden rank stripe on it."
	name = "Warden Jumpsuit"
	icon_state = "darkred"
	item_state = "r_suit"
	colour = "darkred"

/obj/item/clothing/under/rank/geneticist
	desc = "Made of a special fiber that gives special protection against biohazards. Has a genetics rank stripe on it."
	name = "Genetics Jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	colour = "geneticswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It has a Head of Personnel rank stripe on it."
	name = "Head of Personnel Jumpsuit"
	icon_state = "hop"
	item_state = "b_suit"
	colour = "hop"

/obj/item/clothing/under/rank/centcom_officer
	desc = "It has a CentCom officer rank stripe on it."
	name = "CentCom Officer Jumpsuit"
	icon_state = "officer"
	item_state = "g_suit"
	colour = "officer"

/obj/item/clothing/under/rank/centcom_commander
	desc = "It has a CentCom commander rank stripe on it."
	name = "CentCom Officer Jumpsuit"
	icon_state = "centcom"
	item_state = "dg_suit"
	colour = "centcom"

/obj/item/clothing/under/rank/head_of_security
	desc = "It has a Head of Security rank stripe on it."
	name = "Head of Security Jumpsuit"
	icon_state = "black_suit"
	item_state = "hosred"
	colour = "hosred"

/obj/item/clothing/under/rank/chief_engineer
	desc = "It has a Chief Engineer rank stripe on it."
	name = "Chief Engineer Jumpsuit"
	icon_state = "chiefengineer"
	item_state = "g_suit"
	colour = "chief"

/obj/item/clothing/under/rank/research_director
	desc = "It has a Research Director rank stripe on it."
	name = "Research Director Jumpsuit"
	icon_state = "director"
	item_state = "g_suit"
	colour = "director"

/obj/item/clothing/under/rank/janitor
	desc = "Official clothing of the station's poopscooper."
	name = "Janitor's Jumpsuit"
	icon_state = "janitor"
	colour = "janitor"

/obj/item/clothing/under/rank/scientist
	desc = "Made of a special fiber that gives special protection against biohazards. Has a toxins rank stripe on it."
	name = "Scientist's Jumpsuit"
	icon_state = "toxins"
	item_state = "w_suit"
	colour = "toxinswhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/pathology
	desc = "Made of a special fiber that gives special protection against biohazards. Has a virology rank stripe on it."
	name = "Virologist's Jumpsuit"
	icon_state = "pathology"
	item_state = "w_suit"
	colour = "pathologywhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/chemistry
	desc = "Made of a special fiber that gives special protection against biohazards. Has a chemistry rank stripe on it."
	name = "Chemist's Jumpsuit"
	icon_state = "chemistry"
	item_state = "w_suit"
	colour = "chemistrywhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/heatlab
	desc = "Made of a special fiber that gives special protection against biohazards. Has a heat-lab rank stripe on it."
	name = "Heat Scientist's Jumpsuit"
	icon_state = "heatlab"
	item_state = "w_suit"
	colour = "heatlabwhite"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/medical
	desc = "Made of a special fiber that gives special protection against biohazards. Has a medical rank stripe on it."
	name = "Medical Doctor's Jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	colour = "medical"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/cmo
	name = "Officer's Uniform"
	desc = "A sharp garment for the Chief Medical Officer."
	icon_state = "cmo"
	item_state = "cmo"
	colour = "cmo"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/hydroponics
	desc = "Made of a special fiber that gives special protection against biohazards. Has a Hydroponics rank stripe on it."
	name = "Hydroponics Jumpsuit"
	icon_state = "hydroponics"
	item_state = "g_suit"
	colour = "hydroponics"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/bartender
	desc = "It looks like it could use more flair."
	name = "Bartender's Uniform"
	icon_state = "ba_suit"
	item_state = "ba_suit"
	colour = "ba_suit"

/obj/item/clothing/under/rank/barskirt
	desc = "It looks like it could use more flair."
	name = "Female Bartender's Uniform"
	icon_state = "bt_skirt"
	item_state = "bt_skirt"
	colour = "bt_skirt"

/obj/item/clothing/under/rank/startrek1
	desc = "FUCK YOUR SHIT"
	name = "Star Trek Blue"
	icon_state = "st1"
	item_state = "st1"
	colour = "st1"

/obj/item/clothing/under/rank/startrek2
	desc = "FUCK YOUR SHIT"
	name = "Star Trek Yellow"
	icon_state = "st2"
	item_state = "st2"
	colour = "st2"

/obj/item/clothing/under/rank/strider
	desc = "Strider"
	name = "Strider"
	icon_state = "strider"
	item_state = "strider"
	colour = "strider"

/obj/item/clothing/under/rank/medicskirt
	desc = "It's a female medic uniform."
	name = "Female Medic Uniform"
	icon_state = "female_medic"
	item_state = "female_medic"
	colour = "female_medic"

/obj/item/clothing/under/rank/sexyman
	desc = "Sexy mans uniform"
	name = "Sexy Mans Uniform"
	icon_state = "sexyman"
	item_state = "sexyman"
	colour = "sexyman"

/obj/item/clothing/under/rank/clown
	name = "clown suit"
	desc = "Wearing this, all the children love you, for all the wrong reasons."
	icon_state = "clown"
	colour = "clown"

/obj/item/clothing/under/rank/chef
	desc = "Issued only to the most hardcore chefs in space."
	name = "Chef's Uniform"
	icon_state = "chef"
	colour = "chef"

/obj/item/clothing/under/rank/det
	name = "Hard worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	colour = "detective"

/obj/item/clothing/under/rank/lawyer
	desc = "Slick threads."
	name = "Lawyer suit"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/rank/lawyer/black
	icon_state = "lawyer_black"
	item_state = "lawyer_black"
	colour = "lawyer_black"

/obj/item/clothing/under/rank/lawyer/red
	icon_state = "lawyer_red"
	item_state = "lawyer_red"
	colour = "lawyer_red"

/obj/item/clothing/under/rank/lawyer/blue
	icon_state = "lawyer_blue"
	item_state = "lawyer_blue"
	colour = "lawyer_blue"


/obj/item/clothing/under/sl_suit
	desc = "A very amish looking suit."
	name = "Amish Suit"
	icon_state = "sl_suit"
	colour = "sl_suit"

/obj/item/clothing/under/rank/cargo
	name = "Quartermaster's Jumpsuit"
	desc = "What can brown do for you?"
	icon_state = "lightbrown"
	item_state = "lb_suit"
	colour = "cargo"

/obj/item/clothing/under/rank/overalls
	name = "Laborer's Overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	colour = "overalls"

/obj/item/clothing/under/syndicate
	name = "Tactical Turtleneck"
	desc = "Non-descript, slightly suspicious civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"
	colour = "syndicate"
	has_sensor = 0

/obj/item/clothing/under/syndicate/tacticool
	name = "Tacticool Turtleneck"
	desc = "Wearing this makes you feel like buying an SKS, going into the woods, and operating."
	icon_state = "tactifool"
	item_state = "bl_suit"
	colour = "tactifool"

/obj/item/clothing/under/blackskirt
	name = "Black skirt"
	desc = "A black skirt"
	icon_state = "blackskirt"
	colour = "blackskirt"


/obj/item/clothing/under/ISE
	name = "ISE Uniform"
	desc = "International Space Exploration uniform."
	icon_state = "ISE"
	item_state = "bl_suit"
	colour = "ISE"

/obj/item/clothing/under/ISE2
	name = "ISE Uniform"
	desc = "International Space Exploration uniform."
	icon_state = "ISE2"
	item_state = "bl_suit"
	colour = "ISE2"

/obj/item/clothing/under/rank/police
	name = "Police Uniform"
	desc = "Move along, nothing to see here."
	icon_state = "police"
	item_state = "b_suit"
	colour = "police"

/obj/item/clothing/under/pirate
	name = "Pirate Outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	colour = "pirate"

/obj/item/clothing/under/suit_jacket
	name = "Black Suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	colour = "black_suit"

/obj/item/clothing/under/suit_jacket/red
	name = "Red Suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	colour = "red_suit"

/obj/item/clothing/under/suit_jacket/captain
	name = "Captain's Suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	colour = "green_suit"

/obj/item/clothing/under/suit_jacket/head_of_personnel
	name = "Head of Personnel's Suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	colour = "teal_suit"

/obj/item/clothing/under/Nazi
	name = "Nazi Uniform"
	desc = "A historically-accurate replica uniform."
	icon_state = "nazi"
	item_state = "nazi"

/obj/item/clothing/under/rank/librarian
	name = "Sensible Suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	item_state = "red_suit"
	colour = "red_suit"

/obj/item/clothing/under/mime
	name = "Mime Outfit"
	desc = "It's not very colourful."
	icon_state = "mime"
	item_state = "mime"
	colour = "mime"

/obj/item/clothing/under/e_officer
	name = "Enclave Officer Uniform"
	desc = "A sharp garment for the discerning Enclave Officer."
	icon_state = "e_officer"
	item_state = "lb_suit"
	colour = "e_officer"

/obj/item/clothing/under/e_officer2
	name = "Officer's Uniform"
	desc = "A sharp garment for the head of Personnel."
	icon_state = "e_officer"
	item_state = "lb_suit"
	colour = "e_officer"

/obj/item/clothing/under/subjectsuit
	name = "Subject Jumpsuit"
	desc = "A very plain orange t-shirt and jeans."
	icon_state = "subjectsuit"
	item_state = "o_suit"
	colour = "civilian_clothes2"

/obj/item/clothing/under/tourist
	name = "Hawaiian shirt and shorts"
	desc = "The simple garb of a professional sightseer"
	icon_state = "tourist"
	item_state = "centcom"
	colour = "tourist"

/obj/item/clothing/under/rank/prototype_sp_suit
	name = "prototype space suit"
	desc = ""
	icon_state = "protosuit"
	gas_transfer_coefficient = 0.01
	item_state = "s_suit"
	colour = "prototype_sp_suit"
	flags = FPRINT | TABLEPASS | SUITSPACE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02

// Athletic shorts.. heh
/obj/item/clothing/under/shorts
	name = "athletic shorts"
	desc = "95% Polyester, 5% Spandex!"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/shorts/red
	icon_state = "redshorts"
	colour = "redshorts"

/obj/item/clothing/under/shorts/green
	icon_state = "greenshorts"
	colour = "greenshorts"

/obj/item/clothing/under/shorts/blue
	icon_state = "blueshorts"
	colour = "blueshorts"

/obj/item/clothing/under/shorts/black
	icon_state = "blackshorts"
	colour = "blackshorts"

/obj/item/clothing/under/shorts/grey
	icon_state = "greyshorts"
	colour = "greyshorts"

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "A schoolgirl outfit..."
	icon_state = "schoolgirl2"
	item_state = "schoolgirl2"
	colour = "schoolgirl2"

/obj/item/clothing/under/vriska
	name = "vriska uniform"
	desc = "Vriska's outfit..."
	icon_state = "vriska"
	item_state = "vriska"
	colour = "vriska"

/obj/item/clothing/under/scratch
	name = "You try to be the scratch outfit, but fail to be the scratch outfit. No one can be the scratch outfit except for the scratch outfit."
	icon_state = "scratch"
	item_state = "scratch"
	colour = "scratch"

/obj/item/clothing/suit/scratch
	name = "Scratch Jacket"
	icon_state = "scratchjacket"
	item_state = "scratchjacket"

/obj/item/clothing/under/schoolgirl_old
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	colour = "schoolgirl"

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "soviet"
	colour = "soviet"

/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"

/obj/item/clothing/under/mario
	name = "Mario costume"
	desc = "Worn by Italian plumbers everywhere.  Probably."
	icon_state = "mario"
	item_state = "mario"
	colour = "mario"

/obj/item/clothing/under/luigi
	name = "Mario costume"
	desc = "Player two.  Couldn't you get the first controller?"
	icon_state = "luigi"
	item_state = "luigi"
	colour = "luigi"

/obj/item/clothing/suit/indian
	name = "indian suit"
	desc = "Hope you got reservations."
	icon_state = "indian"
	item_state = "indian"

/obj/item/clothing/under/cosby
	name = "Cosby sweater"
	desc = "Symbol of a legendary 80's sitcom dad."
	flags = FPRINT | TABLEPASS
	icon_state = "cosby1"
	colour = "cosby1"
	New()
		colour = "cosby[pick(1,2,3)]"
		icon_state = "cosby[pick(1,2,3)]"
		..()

/obj/item/clothing/under/owl
	name = "Owl uniform"
	desc = "Twoooo!"
	icon_state = "owl"
	colour = "owl"

/obj/item/clothing/under/johnny
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	colour = "johnny"

/obj/item/clothing/under/rainbow
	name = "rainbow"
	desc = "rainbow"
	icon_state = "rainbow"
	colour = "rainbow"

/obj/item/clothing/under/cloud
	name = "cloud"
	desc = "cloud"
	icon_state = "cloud"
	colour = "cloud"

/obj/item/clothing/under/yay
	name = "yay"
	desc = "Yay!"
	icon_state = "yay"
	colour = "yay"

// UNUSED COLORS

/obj/item/clothing/under/psyche
	name = "psychedelic"
	desc = "Groovy!"
	icon_state = "psyche"
	colour = "psyche"

/obj/item/clothing/under/maroon
	name = "maroon"
	desc = "maroon"
	icon_state = "maroon"
	colour = "maroon"

/obj/item/clothing/under/lightblue
	name = "lightblue"
	desc = "lightblue"
	icon_state = "lightblue"
	colour = "lightblue"

/obj/item/clothing/under/aqua
	name = "aqua"
	desc = "aqua"
	icon_state = "aqua"
	colour = "aqua"

/obj/item/clothing/under/purple
	name = "purple"
	desc = "purple"
	icon_state = "purple"
	colour = "purple"

/obj/item/clothing/under/lightpurple
	name = "lightpurple"
	desc = "lightpurple"
	icon_state = "lightpurple"
	colour = "lightpurple"

/obj/item/clothing/under/lightgreen
	name = "lightgreen"
	desc = "lightgreen"
	icon_state = "lightgreen"
	colour = "lightgreen"

/obj/item/clothing/under/lightblue
	name = "lightblue"
	desc = "lightblue"
	icon_state = "lightblue"
	colour = "lightblue"

/obj/item/clothing/under/lightbrown
	name = "lightbrown"
	desc = "lightbrown"
	icon_state = "lightbrown"
	colour = "lightbrown"

/obj/item/clothing/under/brown
	name = "brown"
	desc = "brown"
	icon_state = "brown"
	colour = "brown"

/obj/item/clothing/under/yellowgreen
	name = "yellowgreen"
	desc = "yellowgreen"
	icon_state = "yellowgreen"
	colour = "yellowgreen"

/obj/item/clothing/under/darkblue
	name = "darkblue"
	desc = "darkblue"
	icon_state = "darkblue"
	colour = "darkblue"

/obj/item/clothing/under/lightred
	name = "lightred"
	desc = "lightred"
	icon_state = "lightred"
	colour = "lightred"

/obj/item/clothing/under/darkred
	name = "darkred"
	desc = "darkred"
	icon_state = "darkred"
	colour = "darkred"