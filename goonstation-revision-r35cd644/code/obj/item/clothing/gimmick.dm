
// -------------------- VR --------------------
/obj/item/clothing/under/virtual
	name = "virtual jumpsuit"
	desc = "These clothes are unreal."
	wear_image_fat = "virtual"
	icon_state = "virtual"
	item_state = "virtual"

/obj/item/clothing/shoes/virtual
	name = "virtual shoes"
	desc = "How can you simulate the sole?"
	icon_state = "virtual"
// --------------------------------------------

// -------------------- Predator --------------------
/obj/item/clothing/mask/predator
	name = "Predator Mask"
	desc = "It has some kind of heat tracking and voice modulation equipment built into it."
	icon_state = "predator"
	item_state = "bogloves"
	c_flags = COVERSMOUTH | COVERSEYES | MASKINTERNALS
	see_face = 0

	New()
		..()
		src.vchange = new(src) // Built-in voice changer (Convair880).

/obj/item/clothing/under/gimmick/predator
	name = "Predator Suit"
	desc = "Fishnets, bandoliers and plating? What the hell?"
	icon_state = "predator"
	item_state = "predator"

/obj/item/clothing/shoes/cowboy/predator
	name = "Space Cowboy Boots"
	desc = "Fashionable alien footwear. The sole appears to be rubberized,  preventing slipping on wet surfaces."
	c_flags = NOSLIP // Don't slip on gibs all the time, d'oh (Convair880).
// --------------------------------------------------

/obj/item/clothing/head/helmet/space/santahat
	name = "2k13 vintage santa hat"
	desc = "Uhh, how long has this even been here? It looks kinda grubby and, uhh, singed. Wait, is that blood?"
	icon_state = "santa"
	item_state = "santa"

/obj/item/clothing/suit/space/santa
	name = "santa suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'

/obj/item/clothing/mask/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"
	see_face = 0.0

	suicide(var/mob/user as mob)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (istype(H.w_uniform, /obj/item/clothing/under/gimmick/owl) && !(user.stat || user.paralysis))
				user.visible_message("<span style=\"color:red\"><b>[user] hoots loudly!</b></span>")
				user.owlgib()
				return 1
			else
				user.visible_message("[user] hoots softly.")
				user.suiciding = 0
				return 0
		else
			return 0

/obj/item/clothing/under/gimmick/owl
	name = "owl suit"
	desc = "Twoooo!"
	icon_state = "owl"
	item_state = "owl"
	compatible_species = list("human", "monkey")

	suicide(var/mob/user as mob)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (istype(H.head, /obj/item/clothing/mask/owl_mask) && !(user.stat || user.paralysis))
				user.visible_message("<span style=\"color:red\"><b>[user] hoots loudly!</b></span>")
				user.owlgib()
				return 1
			else
				user.visible_message("[user] hoots softly.")
				user.suiciding = 0
				return 0
		else
			return 0

/obj/item/clothing/mask/smile
	name = "Smiling Face"
	desc = ":)"
	icon_state = "smiles"
	see_face = 0.0

/obj/item/clothing/under/gimmick/waldo
	name = "striped shirt and jeans"
	desc = "A very distinctive outfit."
	icon_state = "waldo"
	item_state = "waldo"

/obj/item/clothing/under/gimmick/odlaw
	name = "yellow-striped shirt and jeans"
	desc = "A rather sinister outfit."
	icon_state = "odlaw"
	item_state = "odlaw"

/obj/item/clothing/under/gimmick/fake_waldo
	name = "striped shirt and jeans"
	desc = "A very odd outfit."
	icon_state = "waldont1"
	item_state = "waldont1"
	New()
		..()
		icon_state = "waldont[rand(1,6)]"
		item_state = "waldont[rand(1,6)]"

/obj/item/clothing/head/waldohat
	name = "Bobble Hat and Glasses"
	desc = "A funny-looking hat and glasses."
	icon_state = "waldo"
	item_state = "santahat"

/obj/item/clothing/head/odlawhat
	name = "Black-striped Bobble Hat and Glasses"
	desc = "An evil-looking hat and glasses."
	icon_state = "odlaw"
	item_state = "o_shoes"

/obj/item/clothing/head/fake_waldohat
	name = "Bobble Hat and Glasses"
	desc = "An odd-looking hat and glasses."
	icon_state = "waldont1"
	item_state = "santahat"
	New()
		..()
		icon_state = "waldont[rand(1,5)]"

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	icon_state = "boots"

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg costume"
	desc = "A costume of a standard-weight NanoTrasen cyborg unit. Suspiciously accurate."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_armor.dmi'
	icon_state = "cyborg"
	item_state = "cyborg"
	flags = FPRINT | TABLEPASS | CONDUCT

/obj/item/clothing/under/gimmick/johnny
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"

/obj/item/clothing/suit/johnny_coat
	name = "Johnny~~"
	desc = "Johnny~~"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "johnny"
	item_state = "johnny"
	flags = FPRINT | TABLEPASS

// UNUSED COLORS

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/under/gimmick/police
	name = "police uniform"
	desc = "Move along, nothing to see here."
	icon_state = "police"
	item_state = "police"

/obj/item/clothing/head/helmet/bobby
	name = "constable's helmet"
	desc = "Heh. Lookit dat fukken helmet."
	icon_state = "policehelm"
	item_state = "helmet"

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flat_cap"
	item_state = "detective"

// NASSA

/obj/item/clothing/head/helmet/space/blackstronaut
	name = "NASSA space helmet"
	desc = "A helmet with a self-contained pressurized environment. Kinda resembles a motorcycle helmet."
	icon_state = "EOD"

/obj/item/clothing/under/gimmick/blackstronaut
	name = "NASSA space suit"
	desc = "A space activity suit embroidered with the NASSA logo. Space is one cold muthafucka."
	icon_state = "nassa"
	item_state = "nassa"
	c_flags = SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02

// Duke Nukem

/obj/item/clothing/under/gimmick/duke
	name = "the duke's suit"
	desc = "You have come here to chew bubblegum and kick ass...and you're all out of bubblegum."
	icon_state = "duke"
	item_state = "duke"

/obj/item/clothing/suit/armor/vest/abs
	name = "the duke's armor"
	desc = "Always bet on Duke. Just don't expect the bet to pay off anytime soon. Or at all, really."
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	icon_state = "dukeabs"
	item_state = "dukeabs"

/obj/item/clothing/head/biker_cap
	name = "Biker Cap"
	desc = "It looks pretty fabulous, to be honest."
	icon_state = "bikercap"
	item_state = "bgloves"

// Batman

/obj/item/clothing/suit/armor/batman
	name = "batsuit"
	desc = "THE SYMBOL ON MY CHEST IS THAT OF A BAT"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "batsuit"
	item_state = "batsuit"

/obj/item/clothing/mask/batman
	name = "batmask and batcape"
	desc = "I'M THE GODDAMN BATMAN."
	icon_state = "batman"
	item_state = "bl_suit"

/obj/item/clothing/head/helmet/batman
	name = "batcowl"
	desc = "I AM THE BAT"
	icon_state = "batcowl"
	item_state = "batcowl"

// see procitizen.dm for batman verbs

/// Cluwne

/obj/item/clothing/mask/cursedclown_hat
	name = "cursed clown mask"
	desc = "This is a very, very odd looking mask."
	icon_state = "cursedclown"
	item_state = "cclown_hat"
	cant_self_remove = 1
	cant_other_remove = 1

/obj/item/clothing/mask/cursedclown_hat/equipped(var/mob/user, var/slot)
	var/mob/living/carbon/human/Victim = user
	if(istype(Victim) && slot == "mask")
		boutput(user, "<span style=\"color:red\"><B> The mask grips your face!</B></span>")
		src.desc = "This is never coming off... oh god..."
		// Mostly for spawning a cluwne car and clothes manually.
		// Clown's Revenge and Cluwning Around take care of every other scenario (Convair880).
		if (user.mind)
			user.mind.assigned_role = "Cluwne"
		src.cant_self_remove = 1
		src.cant_other_remove = 1
	return

/obj/item/clothing/mask/cursedclown_hat/suicide(var/mob/user, var/slot)
	user.visible_message("<span style=\"color:red\"><b>[user] gazes into the eyes of the [src.name]. The [src.name] gazes back!</b></span>") //And when you gaze long into an abyss, the abyss also gazes into you.
	spawn(10)
		playsound(src.loc, "sound/effects/chanting.ogg", 25, 0, 0)
		playsound(src.loc, pick("sound/voice/cluwnelaugh1.ogg","sound/voice/cluwnelaugh2.ogg","sound/voice/cluwnelaugh3.ogg"), 25, 0, 0)
		spawn(15)
			user.emote("scream")
			spawn(15)
				user.implode()
	return 1

/obj/item/clothing/shoes/cursedclown_shoes
	name = "cursed clown shoes"
	desc = "Moldering clown flip flops. They're neon green for some reason."
	icon_state = "cursedclown"
	item_state = "cclown_shoes"
	cant_self_remove = 1
	cant_other_remove = 1

/obj/item/clothing/under/gimmick/cursedclown
	name = "cursed clown suit"
	desc = "It wasn't already?"
	icon_state = "cursedclown"
	item_state = "cursedclown"
	cant_self_remove = 1
	cant_other_remove = 1

/obj/item/clothing/gloves/cursedclown_gloves
	name = "cursed white gloves"
	desc = "These things smell terrible, and they're all lumpy. Gross."
	icon_state = "latex"
	item_state = "lgloves"
	cant_self_remove = 1
	cant_other_remove = 1
	material_prints = "greasy polymer fibers"

// blue clown thing
// it was called the blessed clown for the like half week it existed before

/obj/item/clothing/mask/clown_hat/blue
	name = "blue clown mask"
	desc = "Hey, still looks pretty happy for being so blue."
	icon_state = "blessedclown"
	item_state = "bclown_hat"

/obj/item/clothing/under/misc/clown/blue
	name = "blue clown suit"
	desc = "Proof that if you truly believe in yourself, you can accomplish anything. Honk."
	icon = 'icons/obj/clothing/uniforms/item_js_gimmick.dmi'
	wear_image_icon = 'icons/mob/jumpsuits/worn_js_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/jumpsuit/hand_js_gimmick.dmi'
	icon_state = "blessedclown"
	item_state = "blessedclown"

/obj/item/clothing/shoes/clown_shoes/blue
	name = "blue clown shoes"
	desc = "Normal clown shoes, just blue instead of red."
	icon_state = "blessedclown"
	item_state = "bclown_shoes"

// SHAMONE

/obj/item/clothing/under/gimmick/mj_clothes
	name = "Smooth Criminal's Jumpsuit"
	desc = "You probably shouldn't wear this around small children."
	icon_state = "moonwalker"
	item_state = "moonwalker"

/obj/item/clothing/suit/mj_suit
	name = "Smooth Criminal's Suit"
	desc = "You've been struck by..."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "mjsuit"
	item_state = "mjsuit"

/obj/item/clothing/head/mj_hat
	name = "Smooth Criminal's Hat"
	desc = "Suave."
	icon_state = "mjhat"

/obj/item/clothing/shoes/mj_shoes
	name = "Moonwalkers"
	desc = "The perfect shoes if you want to moonwalk like a champ."
	icon_state = "mjshoes"

// Vikings

/obj/item/clothing/under/gimmick/viking
	name = "Viking Hauberk"
	desc = "A shirt of mail armor commonly utilized by space vikings."
	icon_state = "viking"
	item_state = "viking"

/obj/item/clothing/head/helmet/viking
	name = "Viking Helmet"
	desc = "A helmet, but for space vikings."
	icon_state = "viking"
	item_state = "viking"

/obj/item/device/energy_shield/viking
	name = "Space Viking energy-shield"
	icon = 'icons/obj/items.dmi'
	icon_state = "viking_shield"
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "vshield"
	throwforce = 7.0
	w_class = 3.0

	turn_off()
		if(user)
			user.underlays -= shield_overlay
			user.energy_shield = null
			shield_overlay = null
		user = null
		active = 0

	turn_on(var/mob/user2)

		if(user2.energy_shield)
			boutput(user2, "<span style=\"color:red\">Cannot activate more than one shield.</span>")
			return

		user = user2
		if(!can_use())
			turn_off()
			return
		user.energy_shield = src
		shield_overlay = image('icons/effects/effects.dmi',user,"enshield",MOB_LAYER+1)
		user.underlays += shield_overlay
		active = 1

// Merchant

/obj/item/clothing/under/gimmick/merchant
	name = "Salesman's Uniform"
	desc = "A thrifty outfit for mercantile individuals."
	icon_state = "merchant"
	item_state = "merchant"

/obj/item/clothing/suit/merchant
	name = "Salesman's Jacket"
	desc = "Delightfully tacky."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "merchant"
	item_state = "merchant"

/obj/item/clothing/head/merchant_hat
	name = "Salesman's Hat"
	desc = "A big funny-looking sombrero."
	icon_state = "merchant"
	item_state = "chefhat"

/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "Hold hostages, rob a bank, shoot up an airport, the primitive yet flexible balaclava does it all!"
	icon_state = "balaclava"
	item_state = "balaclava"
	see_face = 0

// Sweet Bro and Hella Jeff

/obj/item/clothing/under/gimmick/sbahj
	name = "<font face='Comic Sans MS' size='3'><span style=\"color:blue\">blue janpsuit...</font>"
	desc = "<font face='Comic Sans MS' size='3'>looks like somethein to wear.........<br><br>in spca</font>"
	icon_state = "sbahjB"
	item_state = "sbahjB"

	red
		name = "<font face='Comic Sans MS' size='3'><span style=\"color:red\"><b><u>read</u></b></span><span style=\"color:blue\"> jumsut</span></font>"
		desc = "<font face='Comic Sans MS' size='3'>\"samething to ware for <span style=\"color:red\"><i><u>studid fuckasses</u></i></span></font>"
		icon_state = "sbahjR"
		item_state = "sbahjR"

	yellow
		name = "<font face='Comic Sans MS' size='3'><span style=\"color:yellow\"><strike>yello  jamsuuit</strike><b><u><i>GEROMY</i></u></b></span></font>"
		desc = "<font face='Comic Sans MS' size='3'>the big man HASS the jumpsiut</font>"
		icon_state = "sbahjY"
		item_state = "sbahjY"

// Spiderman

/obj/item/clothing/mask/spiderman
	name = "spider-man mask"
	desc = "WARNING: Provides no protection from falling bricks."
	icon_state = "spiderman"
	item_state = "bogloves"
	see_face = 0.0

/obj/item/clothing/under/gimmick/spiderman
	name = "spider-man Suit"
	desc = "FAPPO!"
	icon_state = "spiderman"
	item_state = "spiderman"
	see_face = 0.0

/obj/item/clothing/mask/horse_mask
	name = "horse mask"
	desc = "Neigh."
	icon_state = "horse"
	c_flags = SPACEWEAR | COVERSMOUTH | COVERSEYES | MASKINTERNALS
	see_face = 0.0

/obj/item/clothing/head/genki
	name = "super happy funtime cat head"
	desc = "This cat head was built to the highest ethical standards.  50% less child labor used in production than competing novelty cat heads."
	icon_state = "genki"
	permeability_coefficient = 0.01
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH | MASKINTERNALS

//birdman for nieks

/obj/item/clothing/head/birdman
	name = "birdman helmet"
	desc = "bird bird bird"
	icon_state = "birdman"
	see_face = 0
	c_flags = SPACEWEAR | COVERSEYES | COVERSMOUTH | MASKINTERNALS

/obj/item/clothing/under/gimmick/birdman
	name = "birdman suit"
	desc = "It has wings!"
	icon_state = "birdman"
	item_state = "birdman"

//WARHAMS STUFF

/obj/item/clothing/mask/gas/inquis
	name = "inquisitor mask"
	desc = "MY WARHAMS"
	icon_state = "inquis"
	item_state = "swat_hel"

/obj/item/clothing/suit/adeptus
	name = "adeptus mechanicus robe"
	desc = "A robe of a member of the adeptus mechanicus."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	icon_state = "adeptus"
	item_state = "adeptus"
	permeability_coefficient = 0.50
	body_parts_covered = TORSO|LEGS|ARMS

//power armor

/obj/item/clothing/suit/power
	name = "unpainted cardboard space marine armor"
	desc = "Wow, what kind of dork fields an unpainted army? Gauche."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_armor.dmi'
	icon_state = "unp_armor"
	item_state = "unp_armor"

/obj/item/clothing/suit/power/ultramarine
	name = "cardboard ultramarine armor"
	desc = "Oh sure, Ultramarines. That's real creative. Nerd."
	icon_state = "um_armor"
	item_state = "um_armor"

/obj/item/clothing/head/power/ultramarine
	name = "plastic ultramarine helmet"
	desc = "Darth Vader is feeling a bit blue today apparently."
	icon_state = "um_helm"

/obj/item/storage/backpack/ultramarine
	name = "novelty ultramarine backpack"
	desc = "How is this janky piece of shit supposed to work anyway?"
	icon_state = "um_back"

/obj/item/clothing/suit/power/noisemarine
	name = "cardboard noise marine armor"
	desc = "Slaanesh is for fucking freaks, man."
	icon_state = "nm_armor"
	item_state = "nm_armor"

/obj/item/clothing/head/power/noisemarine
	name = "plastic noise marine helmet"
	desc = "A bright pink space mans helmet. Whether it's more or less tacky than a fedora is indeterminable at this time."
	icon_state = "nm_helm"

/obj/item/storage/backpack/noisemarine
	name = "novelty noise marine backpack"
	desc = "Shame this doesn't have real loudspeakers built into it."
	icon_state = "nm_back"

/obj/item/clothing/under/gimmick/dawson
	name = "Aged hipster clothes"
	desc = "A worn-out brown coat with acid-washed jeans and a yellow-stained shirt. The previous owner must've been a real klutz."
	icon_state = "dawson"
	item_state = "dawson"
	cant_self_remove = 1
	cant_other_remove = 1
	equipped(var/mob/user, var/slot)
		if(slot == "i_clothing" && ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.shoes != null)
				var/obj/item/clothing/shoes/c = H.shoes
				if(!istype(c, /obj/item/clothing/shoes/white))
					H.u_equip(c)
					if(c)
						c.set_loc(H.loc)
						c.dropped(H)
						c.layer = initial(c.layer)
			var/obj/item/clothing/shoes/white/newshoes = new /obj/item/clothing/shoes/white(H)
			newshoes.cant_self_remove = 1
			newshoes.cant_other_remove = 1
			newshoes.name = "Dirty sneakers"
			newshoes.desc = "A pair of dirty white sneakers. Fortunately they don't have any blood stains."
			H.equip_if_possible(newshoes, H.slot_shoes)

			boutput(H, "<span style=\"color:red\"><b>You suddenly feel whiny and ineffectual.</b></span>")
			H.real_name = "Mike Dawson"
			H.bioHolder.mobAppearance.customization_first = "Bedhead"
			H.bioHolder.mobAppearance.customization_second = "Selleck"
			H.cust_one_state = "bedhead"
			H.cust_two_state = "selleck"
			H.bioHolder.mobAppearance.e_color = "#321E14"
			H.bioHolder.mobAppearance.customization_first_color = "#412819"
			H.bioHolder.mobAppearance.customization_second_color = "#412819"
			H.bioHolder.mobAppearance.s_tone = 0
			H.bioHolder.AddEffect("clumsy")
			H.set_face_icon_dirty()
			H.set_body_icon_dirty()

/obj/item/clothing/under/gimmick/chav
	name = "blue tracksuit"
	desc = "Looks good on yew innit?"
	icon_state = "chav1"
	item_state = "chav1"
	New()
		..()
		desc = pick("Looks good on yew innit?", "Aww yeah that jackets sick m8")
		if(prob(50))
			name = "Burberry plaid jacket"
			icon_state = "chav2"
			item_state = "lb_suit"

/obj/item/clothing/head/chav
	name = "burberry cap"
	desc = "Sick flatbrims m8"
	icon_state = "chavcap"
	item_state = "caphat"

/obj/item/clothing/under/gimmick/safari
	name = "safari clothing"
	desc = "'ello gents! Cracking time to hunt an elephant!"
	icon_state = "safari"
	item_state = "safari"

/obj/item/clothing/head/safari
	name = "safari hat"
	desc = "Keeps you cool in the hot savannah."
	icon_state = "safari"
	item_state = "caphat"

/obj/item/clothing/mask/skull
	name = "skull mask"
	desc = "A spooky skull mask. You're getting the heebie-jeebies just looking at it!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "skull"
	item_state = "death"
	see_face = 0.0

/obj/item/clothing/suit/robuddy
	name = "guardbuddy costume"
	desc = "A costume that loosely resembles the PR-6 Guardbuddy. How adorable!"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "robuddy"
	item_state = "robuddy"
	body_parts_covered = TORSO|LEGS|ARMS

/obj/item/clothing/suit/bee
	name = "bee costume"
	desc = "A costume that loosely resembles a domestic space bee. Buzz buzz!"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "bee"
	item_state = "bee"
	body_parts_covered = TORSO|ARMS

/obj/item/clothing/suit/monkey
	name = "monkey costume"
	desc = "A costume that loosely resembles a monkey. Ook Ook!"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "monkey"
	item_state = "monkey"
	body_parts_covered = TORSO|LEGS|ARMS
	c_flags = COVERSMOUTH | COVERSEYES | SPACEWEAR

/obj/item/clothing/mask/niccage
	name = "Nicolas Cage mask"
	desc = "An eerily realistic mask of 20th century film actor Nicolas Cage."
	icon_state = "niccage"
	c_flags = SPACEWEAR | COVERSMOUTH | COVERSEYES | MASKINTERNALS
	see_face = 0.0

/obj/item/clothing/mask/waltwhite
	name = "meth scientist mask"
	desc = "A crappy looking mask that you swear you've seen a million times before. 'Spook*Corp Costumes' is embedded on the side of it. "
	icon_state = "waltwhite"
	c_flags = SPACEWEAR | COVERSMOUTH | COVERSEYES | MASKINTERNALS
	see_face = 0.0

/obj/item/clothing/suit/gimmick/light_borg //YJHGHTFH's light borg costume
	name = "Light Cyborg Costume"
	desc = "A costume that looks like a light-body cyborg. Suprisingly, it's quite comfortable!"
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	icon_state = "light_borg"
	item_state = "light_borg"
	body_parts_covered = TORSO|LEGS|ARMS
	c_flags = COVERSMOUTH | COVERSEYES | SPACEWEAR
	see_face = 0.0

/obj/item/clothing/under/gimmick/utena //YJHTGHTFH's utena suit
	name = "revolutionary suit"
	desc = "May give you the power to revolutionize the world! Probably not, though."
	icon_state = "utena"
	item_state = "utena"

/obj/item/clothing/shoes/utenashoes //YJHGHTFH's utena shoes
	name = "revolutionary shoes"
	desc = "Have you done some stretches today?  You should do some stretches."
	icon_state = "utenashoes"
	item_state = "utenashoes"

/obj/item/clothing/under/gimmick/anthy //AffableGiraffe's anthy dress
	name = "revolutionary dress"
	desc = "If you experience unexpected magical swords appearing from your body, please see a doctor."
	icon_state = "anthy"
	item_state = "anthy"

/obj/item/clothing/suit/armor/sneaking_suit
	name = "sneaking suit"
	desc = "I spy with my little eye..."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_armor.dmi'
	icon_state = "sneakmans"
	item_state = "sneakmans"

/obj/item/clothing/suit/bio_suit/beekeeper
	name = "apiculturist's suit"
	desc = "A suit that protects against bees. Not space bees, but like the tiny, regular kind. This thing doesn't do <i>shit</i> to protect you from space bees."

/obj/item/clothing/head/bio_hood/beekeeper
	name = "apiculturist's hood"
	desc = "This hood has a special mesh on it to keep bees from your eyes and other face stuff."
	icon_state = "beekeeper"
	item_state = "beekeeper"

/obj/item/clothing/under/rank/beekeeper
	name = "apiculturist's overalls"
	desc = "Really, they're just regular overalls, but they have a little bee patch on them. Aww."
	icon_state = "beekeeper"
	item_state = "beekeeper"
	permeability_coefficient = 0.50

/obj/item/clothing/under/gimmick/butler
	name = "butler suit"
	desc = "Tea, sir?"
	icon_state = "butler"
	item_state = "butler"

/obj/item/clothing/under/gimmick/maid
	name = "maid dress"
	desc = "Tea, ma'am?"
	icon_state = "maid"
	item_state = "maid"

/obj/item/clothing/head/maid
	name = "maid headwear"
	desc = "A little ruffle with lace, to wear on the head. It gives you super cleaning powers*!<br><small>*Does not actually bestow any powers.</small>"
	icon_state = "maid"
	item_state = "maid"

/obj/item/clothing/under/gimmick/kilt
	name = "kilt"
	desc = "Traditional Scottish clothing. A bit drafty in here, isn't it?"
	icon_state = "kilt"
	item_state = "kilt"
