/obj/item/clothing/head/rabbitears
	name = "Rabbit Ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon_state = "bunny"
	flags = FPRINT | TABLEPASS | HEADSPACE

/obj/item/clothing/head/cowears
	name = "Cow Ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon_state = "cow"
	flags = FPRINT | TABLEPASS | HEADSPACE
	var/icon/mob
	var/icon/mob2

	update_icon(var/mob/living/carbon/human/user)
		if(!istype(user)) return
		mob = new/icon("icon" = 'head.dmi', "icon_state" = "cow")
		mob2 = new/icon("icon" = 'head.dmi', "icon_state" = "cow2")
		mob.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)
		mob2.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)

		var/icon/earbit = new/icon("icon" = 'head.dmi', "icon_state" = "cowinner")
		var/icon/earbit2 = new/icon("icon" = 'head.dmi', "icon_state" = "cowinner2")
		mob.Blend(earbit, ICON_OVERLAY)
		mob2.Blend(earbit2, ICON_OVERLAY)

/obj/item/clothing/head/kitty
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

/obj/item/clothing/head/bunnyhood
	name = "Bunny Hood"
	desc = "the fuck is this"
	icon_state = "bunnyhood"
	flags = FPRINT | TABLEPASS | HEADSPACE | HEADCOVERSHAIR

/obj/item/clothing/head/kittyhood
	name = "Kitty Hood"
	desc = "the fuck is this"
	icon_state = "kittyhood"
	flags = FPRINT | TABLEPASS | HEADSPACE | HEADCOVERSHAIR

/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"

/obj/item/clothing/head/stockingcap
	name = "stocking cap"
	desc = "Don we now our gay apparel~"
	icon_state = "stockingcap"

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 1
	var/airflowprot = 0
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL | SUITSPACE


// the raper
/obj/item/clothing/under/reaper
	name = "reaper uniform"
	desc = "A sharp garment for the discerning rapist."
	icon_state = "reaper"
	item_state = "reaper"
	colour = "reaper"

/obj/item/clothing/suit/bedsheet/reapercape
	name = "reaper cape"
	desc = "A simple device, used to provide flight to the user. Also can be used to make butthole fortress of solitude."
	icon = 'suits.dmi'
	icon_state = "reapercape"
	item_state = "reapercape"
	layer = 5
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/shoes/reaper
	name = "reaper boots"
	icon_state = "reaper-boot"
	flags = NOSLIP
	slowdown = 0
	airflowprot = 1

/obj/item/clothing/gloves/reaper
	desc = "beep boop borp"
	name = "reaper gloves"
	icon_state = "reaper-glove"
	item_state = "reaper-glove"

/obj/item/clothing/head/reaperhelmet
	name = "reaper helmet"
	desc = "gay apparel~"
	icon_state = "reaper-helmet"


/obj/item/clothing/mask/reaper
	name = "reaper mask"
	desc = "oooo!"
	icon_state = "reaper-mask"
//end raper

/obj/item/clothing/head/e_officerhat
	name = "Enclave Officer's Hat"
	desc = "The favored headwear of many an officer under the command of President Eden."
	icon_state = "e_officerhat"

/obj/item/clothing/under/e_officer
	name = "Enclave Officer Uniform"
	desc = "A sharp garment for the discerning Enclave Officer."
	icon_state = "e_officer"
	item_state = "lb_suit"
	colour = "e_officer"


/obj/item/clothing/shoes
	var/airflowprot = 0
/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"

/obj/item/clothing/shoes/sanic
	name = "sanic the hegedog shoes"
	icon_state = "sanic"
	flags = NOSLIP
	slowdown = -30
	airflowprot = 1

/obj/item/clothing/shoes/brown_blackstockings
	name = "Brown Shoes w/ Black Stockings"
	icon_state = "brown_blackstockings"

/obj/item/clothing/shoes/brown_whitestockings
	name = "Brown Shoes w/ White Stockings"
	icon_state = "brown_whitestockings"

/obj/item/clothing/shoes/red_whitestockings
	name = "Red Shoes w/ White Stockings"
	icon_state = "red_whitestockings"

/obj/item/clothing/shoes/jag
	name = "Brown Shoes w/ Pink and Black Stockings"
	icon_state = "jagboots"

/obj/item/clothing/shoes/vans
	name = "Vans"
	icon_state = "vans"

/obj/item/clothing/mask/owl_mask
	name = "Owl mask"
	desc = "Twoooo!"
	icon_state = "owl"

/obj/item/clothing/under/owl
	name = "Owl uniform"
	desc = "Twoooo!"
	icon_state = "owl"
	colour = "owl"

/obj/item/clothing/under/tutuniform
	name = "virtual uniform"
	desc = "With this in your hand, click the part of your HUD that looks like a small box with a uniform inside to don this clothing."
	icon_state = "tutuniform"
	colour = "tutuniform"

/obj/item/clothing/under/tutuniform/attack_hand(mob/user as mob)
	var/obj/item/clothing/under/tutuniform/T = new /obj/item/clothing/under/tutuniform (src.loc)
	if (user.hand)
		user.l_hand = T
	else
		user.r_hand = T
	T.loc = user
	T.layer = 20

/obj/item/clothing/under/tutuniform/dropped(mob/user as mob)
	spawn(300)
		if(!istype(src.loc, /mob/living/carbon/human/))
			del(src)

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "boots"

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	item_state = "death"
	flags = FPRINT | TABLEPASS | CONDUCT
	fire_resist = T0C+5200

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

/obj/item/clothing/head/nazihat
	name = "Nazi hat"
	desc = "SIEG HEIL!"
	icon_state = "nazihat"

/obj/item/clothing/under/jag
	name = "Black Shirt and Red Skirt"
	desc = "A black shirt and red skirt."
	icon_state = "jag"
	colour = "jag"

/obj/item/clothing/gloves/jag
	desc = "pink and black armwarmers"
	name = "pink and black armwarmers"
	icon_state = "jagwarmers"
	item_state = "jagwarmers"

/obj/item/clothing/under/nazi
	name = "Nazi uniform"
	desc = "SIEG HEIL!"
	icon_state = "nazi"
	colour = "nazi"

/obj/item/clothing/under/nazifem
	name = "Nazi uniform"
	desc = "SIEG HEIL!"
	icon_state = "nazifem"
	colour = "nazifem"

/obj/item/clothing/suit/nazicoat
	name = "Nazi trenchcoat"
	desc = "SIEG HEIL!"
	icon_state = "nazicoat"
	item_state = "nazicoat"
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 50, bullet = 30, laser = 40, taser = 10, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/suit/nazicoat/erika
	name = "Nazi trenchcoat"
	desc = "SIEG HEIL!"
	icon_state = "nazicoat"
	item_state = "nazicoat"
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 100, bullet = 100, laser = 100, taser = 200, bomb = 100, bio = 500, rad = 200)

/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A Nazi great coat"
	icon_state = "nazi"
	item_state = "nazi"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/johnny
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	colour = "johnny"

/obj/item/clothing/suit/johnny_coat
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"
	flags = FPRINT | TABLEPASS


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

/*/obj/item/clothing/under/yay
	name = "yay"
	desc = "Yay!"
	icon_state = "yay"
	colour = "yay"*/ // no sprite --errorage

// UNUSED colourS

/obj/item/clothing/under/psyche
	name = "psychedelic"
	desc = "Groovy!"
	icon_state = "psyche"
	colour = "psyche"

/*
/obj/item/clothing/under/maroon
	name = "maroon"
	desc = "maroon"
	icon_state = "maroon"
	colour = "maroon"*/ // no sprite -- errorage

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

/obj/item/clothing/glasses/hip_glasses
	desc = "Look really stupid. Do people really wear things like this?"
	name = "hip glasses"
	icon_state = "hip_glasses"
	item_state = "sunglasses"

// STEAMPUNK STATION

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "Captain's Suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	colour = "green_suit"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "Head of Personnel's Suit"
	desc = "A black suit and red tie. Very formal. An authoritative yet tacky ensemble."
	icon_state = "black_suit"
	item_state = "bl_suit"
	colour = "black_suit"

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

/obj/item/clothing/under/blackskirt
	name = "Black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	colour = "blackskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	colour = "schoolgirl"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/gimmick/rank/police
	name = "Police Uniform"
	desc = "Move along, nothing to see here."
	icon_state = "police"
	item_state = "b_suit"
	colour = "police"

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flat_cap"
	item_state = "detective"

/obj/item/clothing/under/overalls
	name = "Laborer's Overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	colour = "overalls"

/obj/item/weapon/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10

/obj/item/clothing/under/pirate
	name = "Pirate Outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	colour = "pirate"

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"

/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana"
	item_state = "bandana"

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

/obj/item/clothing/head/collectable			//Hat Station 13
	name = "Collectable Hat"
	desc = "A rare collectable hat."

/obj/item/clothing/head/collectable/chef
	name = "Collectable Chef's Hat"
	desc = "A rare chef's hat meant for hat collectors."
	icon_state = "chef"
	item_state = "chef"

/obj/item/clothing/head/collectable/paper
	name = "Collectable Paper Hat"
	desc = "What looks like an ordinary paper hat, is actually a rare and valuable collector's edition paper hat. Keep away from water."
	icon_state = "paper"

/obj/item/clothing/head/collectable/swat
	name = "Collectable SWAT Helmet"
	desc = "Has a tag on the inside 'A genuine Collector's SWAT Helmet. Not for use as protective headgear.'"
	icon_state = "swat"
	item_state = "swat"

/obj/item/clothing/head/collectable/tophat
	name = "Collectable Top Hat"
	desc = "A top hat worn by only the most prestigious hat collectors."
	icon_state = "tophat"
	item_state = "that"

/obj/item/clothing/head/collectable/captain
	name = "Collectable Captain's Hat"
	desc = "A Collectable Hat that'll make you look just like a real comdom!"
	icon_state = "captain"
	item_state = "caphat"

/obj/item/clothing/head/collectable/centcom
	name = "Collectable Centcom Hat"
	desc = "A Collectable replica of a centcom official's hat."
	icon_state = "centcom"
	item_state = "centhat"

/obj/item/clothing/head/collectable/police
	name = "Collectable Police Officer's Hat"
	desc = "A Collectable Police Officer's Hat. This hat emphasizes that you are THE LAW."
	icon_state = "policehelm"

/obj/item/clothing/head/collectable/beret
	name = "Collectable Beret"
	desc = "A Collectable red beret."
	icon_state = "beret"

/obj/item/clothing/head/collectable/welding
	name = "Collectable Welding Helmet"
	desc = "A Collectable Welding Helmet. Now with 80% less lead! Not for actual welding."
	icon_state = "welding"
	item_state = "welding"

//obj/item/clothing/head/collectable

/obj/item/clothing/mask/gas/combine
	name ="elite combine helmet"
	icon_state = "gas_alt"
	item_state = "gas_comb_elite"

/obj/item/clothing/mask/gas/revan
	name ="mandalorian mask"
	icon_state = "gas_revan"
	item_state = "gas_revan"

/obj/item/clothing/head/revanhood
	name = "revan's coat hood"
	icon_state = "revanhood"
	item_state = "revanhood"

/obj/item/clothing/suit/revancoat
	name = "revan's coat"
	icon_state = "revancoat"
	item_state = "revancoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/* no left/right sprites
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
*/

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid"
	icon_state = "kilt"
	item_state = "kilt"
	colour = "kilt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET

/obj/item/clothing/head/bowler
	name = "bowler-hat"
	desc = "Gentleman, elite aboard!"
	icon_state = "bowler"
	item_state = "bowler"
	flags = FPRINT | TABLEPASS | HEADSPACE

//Erika's custom outfits

/obj/item/clothing/under/schoolgirl2
	name = "schoolgirl uniform"
	desc = "A schoolgirl outfit..."
	icon_state = "schoolgirl2"
	item_state = "schoolgirl2"
	colour = "schoolgirl2"

/obj/item/clothing/under/scratch
	name = "You try to be the scratch outfit, but fail to be the scratch outfit. No one can be the scratch outfit except for the scratch outfit."
	icon_state = "scratch"
	item_state = "scratch"
	colour = "scratch"

/obj/item/clothing/suit/scratch
	name = "Scratch Jacket"
	icon_state = "scratchjacket"
	item_state = "scratchjacket"

/obj/item/clothing/under/vriska
	name = "vriska uniform"
	desc = "Vriska's outfit..."
	icon_state = "vriska"
	item_state = "vriska"
	colour = "vriska"

/obj/item/clothing/suit/medicaltunic
	name = "female medical tunic"
	desc = "A medical tunic for females."
	permeability_coefficient = 0.80
	icon_state = "medicskirt"
	item_state = "medicskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

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


//shoes
/obj/item/clothing/shoes/boots_wstockings
	name = "Boots w/ Black Stockings"
	icon_state = "boots_wstockings"

/obj/item/clothing/shoes/brown_blackstockings
	name = "Brown Shoes w/ Black Stockings"
	icon_state = "brown_blackstockings"

/obj/item/clothing/shoes/brown_whitestockings
	name = "Brown Shoes w/ White Stockings"
	icon_state = "brown_whitestockings"

/obj/item/clothing/shoes/red_whitestockings
	name = "Red Shoes w/ White Stockings"
	icon_state = "red_whitestockings"

//End Custom Outfits


/obj/item/clothing/under/anime/lucy
	name = "Lucy's Attire"
	icon_state = "lucy"
	colour = "lucy"
	desc = "Watch out for the Vectors."

/obj/item/clothing/under/anime/nyu
	name = "Nyu's Attire"
	icon_state = "nyu"
	colour = "nyu"
	desc = "Making amnesia look GOOD!"

/obj/item/clothing/under/anime/yoko
	name = "Yoko's Clothing"
	icon_state = "yoko"
	colour = "yoko"
	desc = "Good thing you wear it in a desert!"

/obj/item/clothing/under/anime/kamina
	name = "Kamina's Attire"
	icon_state = "kamina"
	colour = "kamina"
	desc = "Nice tattoos, Bro."

/obj/item/clothing/under/anime/kenshiro
	name = "Kenshiro's Suit"
	icon_state = "kenshiro"
	colour = "kenshiro"
	desc = "Anata wa sudeni shinde iru"	//You are already dead

/obj/item/clothing/under/anime/haruko
	name = "Haruko's Vespa Gear"
	icon_state = "haruko"
	colour = "haruko"
	desc = "Everything you need to... Ride a vespa..."

/obj/item/clothing/under/anime/tiny_miniskirt_blue
	name = "Blue Tiny Miniskirt"
	icon_state = "miniskirtb"
	colour = "miniskirtb"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/anime/tiny_miniskirt_red
	name = "Red Tiny Miniskirt"
	icon_state = "miniskirtr"
	colour = "miniskirtr"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/anime/tiny_miniskirt_green
	name = "Green Tiny Miniskirt"
	icon_state = "miniskirtg"
	colour = "miniskirtg"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/anime/tiny_miniskirt_yellow
	name = "Yellow Tiny Miniskirt"
	icon_state = "miniskirty"
	colour = "miniskirty"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/anime/tiny_miniskirt_pink
	name = "Pink Tiny Miniskirt"
	icon_state = "miniskirtp"
	colour = "miniskirtp"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/suit/fursuit
	name = "fursuit"
	icon_state = "fursuit"
	item_state = "s_suit"
	desc = "Now everyone will want to burn you with plasma fires."
	w_class = 3
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/toy)

/obj/item/clothing/suit/fursuit/narky
	name = "giant furfag suit"
	icon_state = "narkysuit"
	desc = "You are the bringer of fur faggotry"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL

/obj/item/clothing/suit/fursuit/xenosuit
	name = "Xenomorph Costume"
	icon_state = "xenosuit"

/obj/item/clothing/suit/fursuit/lxmsuit
	name = "Xenomorph Maid Costume"
	icon_state = "lxmsuit"

/obj/item/clothing/suit/fursuit/xenosciencesuit
	name = "Xenomorph Scientist Costume"
	icon_state = "xenobiosuit"
