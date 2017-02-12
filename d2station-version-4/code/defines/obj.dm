/obj
	//var/datum/module/mod		//not used
	var/m_amt = 0	// metal
	var/g_amt = 0	// glass
	var/w_amt = 0	// waster amounts
	var/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/explosionstrength = 0
	var/datum/marked_datum
	proc
		handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
			//Return: (NONSTANDARD)
			//		null if object handles breathing logic for lifeform
			//		datum/air_group to tell lifeform to process using that breath return
			//DEFAULT: Take air from turf to give to have mob process
			if(breath_request>0)
				return remove_air(breath_request)
			else
				return null

		initialize()

/obj/signpost
	icon = 'stationobjs.dmi'
	icon_state = "signpost"
	anchored = 1
	density = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		switch(alert("Travel back to ss13?",,"Yes","No"))
			if("Yes")
				user.loc.loc.Exited(user)
				user.loc = pick(latejoin)
			if("No")
				return

	telepad
		icon = 'tutorial.dmi'
		icon_state = "telepad"

		New()
			src.overlays += icon('tutorial.dmi', "telepad_overlay")

/obj/boxingring
	icon = 'stationobjs.dmi'
	icon_state = "boxingring"
	anchored = 1
	density = 0
	layer = 4

/obj/chesspiece
	icon = 'chesspieces.dmi'
	icon_state = "pawn"
	anchored = 0
	density = 1

/obj/blob
		name = "magma"
		icon = 'blob.dmi'
		icon_state = "bloba0"
		var/health = 40
		density = 1
		opacity = 0
		anchored = 1

/obj/blob/idle
		name = "magma"
		desc = "it looks... tasty"
		icon_state = "blobidle0"

/obj/mark
		var/mark = ""
		icon = 'mark.dmi'
		icon_state = "blank"
		anchored = 1
		layer = 99
		mouse_opacity = 0
		unacidable = 1//Just to be sure.

/obj/admins
	name = "admins"
	var/rank = null
	var/owner = null
	var/state = 1
	//state = 1 for playing : default
	//state = 2 for observing

/obj/bhole
	name = "black hole"
	icon = 'objects.dmi'
	desc = "FUCK FUCK FUCK AAAHHH"
	icon_state = "bhole2"
	opacity = 0
	unacidable = 1
	density = 0
	anchored = 1

/obj/beam
	name = "beam"
	unacidable = 1//Just to be sure.
	var/def_zone
	pass_flags = PASSTABLE

/obj/beam/i_beam
	name = "i beam"
	icon = 'projectiles.dmi'
	icon_state = "ibeam"
	var/obj/beam/i_beam/next = null
	var/obj/item/device/infra/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	anchored = 1.0
	flags = TABLEPASS


/obj/bedsheetbin
	name = "linen bin"
	desc = "A bin for containing bedsheets. It looks rather cosy."
	icon = 'items.dmi'
	icon_state = "bedbin"
	var/amount = 23.0
	anchored = 1.0

/obj/begin
	name = "begin"
	icon = 'stationobjs.dmi'
	icon_state = "begin"
	anchored = 1.0
	unacidable = 1

/obj/datacore
	name = "datacore"
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
//	var/bank[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()

/obj/equip_e
	name = "equip e"
	var/mob/source = null
	var/s_loc = null
	var/t_loc = null
	var/obj/item/item = null
	var/place = null

/obj/equip_e/human
	name = "human"
	var/mob/living/carbon/human/target = null

/obj/equip_e/monkey
	name = "monkey"
	var/mob/living/carbon/monkey/target = null

/obj/grille
	desc = "A piece of metal with evenly spaced gridlike holes in it. Blocks large object but lets small items, gas, or energy beams through. Strangely enough these grilles also lets meteors pass through them, whether they be small or huge station breaking death stones."
	name = "grille"
	icon = 'structures.dmi'
	icon_state = "grille"
	density = 1
	var/health = 10.0
	var/destroyed = 0.0
	anchored = 1.0
	flags = FPRINT | CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 2.9

/obj/sign
	icon = 'decals.dmi'
	anchored = 1
	density = 0

/obj/sign/departments/library
	desc = "Library"
	name = "Library"
	icon_state = "library"

/obj/sign/departments/lounge
	desc = "The Lounge"
	name = "The Lounge"
	icon_state = "lounge"

/obj/sign/departments/Storage
	desc = "Storage"
	name = "Storage"
	icon_state = "Storage"

/obj/sign/departments/AI
	desc = "AI"
	name = "AI"
	icon_state = "AI"

/obj/sign/departments/kitchen
	desc = "Kitchen"
	name = "Kitchen"
	icon_state = "kitchen"

/obj/sign/departments/bar
	desc = "Bar"
	name = "Bar"
	icon_state = "bar"

/obj/sign/departments/medbay
	desc = "Medbay"
	name = "Medbay"
	icon_state = "medbay"

/obj/sign/departments/hydroponics
	desc = "Hydroponics"
	name = "Hydroponics"
	icon_state = "hydroponics"

/obj/sign/departments/engineering
	desc = "Engineering"
	name = "Engineering"
	icon_state = "engineering"

/obj/sign/departments/bridge
	desc = "Bridge"
	name = "Bridge"
	icon_state = "bridge"

/obj/sign/departments/brig
	desc = "Brig"
	name = "Brig"
	icon_state = "brig"

/obj/sign/departments/atmos
	desc = "Atmospherics"
	name = "Atmospherics"
	icon_state = "atmos"

/obj/sign/departments/crew
	desc = "Dormitory"
	name = "Dormitory"
	icon_state = "crew"
/obj/sign/departments/tele
	desc = "Teleporter"
	name = "Teleporter"
	icon_state = "Teleporter"

/obj/sign/departments/qm
	desc = "Quatermaster"
	name = "Quatermaster"
	icon_state = "Quatermaster"

/obj/sign/departments/gas
	desc = "Gas Storage"
	name = "Gas Storage"
	icon_state = "Gas Storage"
/obj/sign/sign_silenceplease
	desc = "A sign which indicates 'Silence Please'"
	name = "Silence Please"
	icon_state = "silenceplease"

/obj/sign/sign_noshitlers
	desc = "A sign which reads 'No shitlers allowed'"
	name = "No shitlers allowed"
	icon_state = "noshitlers"

/obj/sign/sign_cleanhands
	desc = "A sign which reads 'Clean hands save lives'"
	name = "Clean hands save lives"
	icon_state = "cleanhands"

/obj/sign/sign_stabilizer
	desc = "A sign which reads 'IF IN DOUBT, ADD MORE STABILIZER'"
	name = "Always more stabilizer"
	icon_state = "secureareaOLD"

/obj/sign/airtunnel
	desc = "A sign which reads 'IF IN DOUBT, ADD MORE STABILIZER'"
	name = "Always more stabilizer"
	icon = 'walls.dmi'
	icon_state = "secureareaOLD"

/obj/sign/nsm1
	desc = "Punch-out!!"
	name = "Punch-out!!"
	icon_state = "nsm1"

/obj/sign/nsm2
	desc = "Punch-out!!"
	name = "Punch-out!!"
	icon_state = "nsm2"

/obj/sign/nofuckingshit
	desc = "NO SHIT"
	name = "Public Announcement"
	icon_state = "noshit"

/obj/sign/sign_securearea
	desc = "A warning sign which reads 'SECURE AREA'"
	name = "SECURE AREA"
	icon_state = "securearea"

/obj/sign/sign_fire
	desc = "A warning sign which reads 'COMBUSTIBLE MATERIALS'"
	name = "COMBUSTIBLE MATERIALS"
	icon_state = "fire"

/obj/sign/sign_bio
	desc = "A warning sign which reads 'BIOLOGICAL HAZARD AREA'"
	name = "BIOLOGICAL HAZARD AREA"
	icon_state = "bio"

/obj/sign/sign_redcross
	desc = "A sign that marks an area, Medical Bay in this case."
	name = "Medical"
	icon_state = "redcross"

/obj/sign/sign_examroom
	desc = "A sign that marks an area, Exam Room in this case."
	name = "EXAM"
	icon = 'decals.dmi'
	icon_state = "examroom"
	anchored = 1.0

/obj/sign/goldenplaque
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	name = "The Most Robust Men Award for Robustness"
	icon_state = "goldenplaque"

/obj/item/weapon/plaque_assembly
	desc = "Put this on a wall and engrave an epitaph"
	name = "Plaque Assembly"
	icon = 'decals.dmi'
	icon_state = "goldenplaque"

/obj/item/weapon/plaque_assembly/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	if(istype(A,/turf/simulated/wall) || istype(A,/turf/simulated/shuttle/wall) || istype(A,/turf/unsimulated/wall))
		var/epitaph = strip_html(input("What would you like to engrave", null))
		if(epitaph)
			var/obj/sign/goldenplaque/gp = new/obj/sign/goldenplaque(A)
			gp.name = epitaph
			gp.layer = 2.9
			del(src)

/obj/sign/sign_shock
	desc = "A warning sign which reads 'ELECTRICAL HAZARD AREA'"
	name = "ELECTRICAL HAZARD AREA"
	icon_state = "shock"

/obj/sign/sign_nosmoking
	desc = "A warning sign which reads 'NO SMOKING'"
	name = "NO SMOKING"
	icon_state = "nosmoking"

/obj/sign/sign_nosmoking2
	desc = "A warning sign which reads 'NO SMOKING'"
	name = "NO SMOKING"
	icon_state = "nosmoking2"

/obj/sign/sign_space
	desc = "A warning sign which reads 'EXTERNAL ACCESS'"
	name = "EXTERNAL ACCESS"
	icon_state = "space"

/obj/sign/sign_restricted
	desc = "A warning sign which reads 'NO ACCESS'"
	name = "NO ACCESS"
	icon_state = "Restricted"

/obj/sign/sign_inputport
	desc = "A sign which indicates an air input port."
	name = "CANISTER INPUT"
	icon_state = "input_port"

/obj/sign/sign_outputport
	desc = "A sign which indicates an air output port."
	name = "CANISTER OUTPUT"
	icon_state = "output_port"

/obj/sign/sign_bio
	desc = "A warning sign which reads 'BIOLOGICAL HAZARD AREA'"
	name = "BIOLOGICAL HAZARD AREA"
	icon_state = "bio"

/obj/sign/sign_securearea
	desc = "A warning sign which reads 'SECURE AREA'"
	name = "SECURE AREA"
	icon_state = "securearea"

/obj/sign/sign_shock
	desc = "A warning sign which reads 'ELECTRICAL HAZARD AREA'"
	name = "ELECTRICAL HAZARD AREA"
	icon = 'decals.dmi'
	icon_state = "shock"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/sign_examroom
	desc = "A guidance sign which reads 'EXAM ROOM'"
	name = "EXAM"
	icon = 'decals.dmi'
	icon_state = "examroom"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/sign_vacuum
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	name = "HARD VACUUM AHEAD"
	icon = 'decals.dmi'
	icon_state = "space"
	anchored = 1.0
	opacity = 0
	density = 0
	pixel_x = -1
	pixel_y = -1


/obj/sign/street
	desc = "street sign"
	name = "street sign"
	icon = 'miscobj.dmi'
	icon_state = "stop"
	anchored = 1.0
	opacity = 0
	density = 0
	pixel_x = -1
	pixel_y = -1

/obj/sign/maltesefalcon1         //The sign is 64x32, so it needs two tiles. ;3
	desc = "The Maltese Falcon, Space Bar and Grill. Now with added monkey."
	name = "The Maltese Falcon"
	icon = 'decals.dmi'
	icon_state = "maltesefalcon1"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/rapemonger
	desc = "The Rapemonger, Bar and Grill. Limbs not guaranteed."
	name = "The Rapemonger"
	icon = 'barsigns.dmi'
	icon_state = "rapemonger"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/laundromat
	desc = "The Laundromat"
	name = "Laundromat"
	icon = 'barsigns.dmi'
	icon_state = "laundromat"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/maltesefalcon2
	desc = "The Maltese Falcon, Space Bar and Grill. Now with added monkey."
	name = "The Maltese Falcon"
	icon = 'decals.dmi'
	icon_state = "maltesefalcon2"
	anchored = 1.0
	opacity = 0
	density = 0

/obj/sign/pipemarker/no2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "nitrous oxide pipeline"
	icon_state = "pipemark_no2"

/obj/sign/pipemarker/o2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "oxygen pipeline"
	icon_state = "pipemark_o2"

/obj/sign/pipemarker/co2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "carbon dioxide pipeline"
	icon_state = "pipemark_co2"

/obj/sign/pipemarker/pl
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "plasma pipeline"
	icon_state = "pipemark_pl"

/obj/sign/pipemarker/air
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "mixed-air pipeline"
	icon_state = "pipemark_air"

/obj/sign/pipemarker/n2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "nitrogen pipeline"
	icon_state = "pipemark_n2"

/obj/sign/tutorial
	icon = 'tutorial.dmi'

/obj/sign/tutorial/wasd
	desc = "Use the directional keys to navigate."
	name = "Use the directional keys to navigate."
	icon_state = "wasd"

/obj/sign/tutorial/info
	desc = "Click me!"
	name = "Tutorial sign"
	icon_state = "tutsign"

/obj/mapboard
	name = "Map of Space Station 13"
	icon = 'stationobjs.dmi'
	icon_state = "mapboard"
	flags = FPRINT
	desc = "A map of the station. Click to view it."
	density = 0
	anchored = 1

/obj/mapboard/New()
	spawn(-1)
		name = "Map of [station_name]"
		desc = "A map of [station_name]. Click to view it."

/obj/hud
	name = "hud"
	unacidable = 1
	var/mob/mymob = null
	var/list/adding = null
	var/list/other = null
	var/list/intents = null
	var/list/mov_int = null
	var/list/mon_blo = null
	var/list/m_ints = null
	var/obj/screen/druggy = null
	var/vimpaired = null
	var/obj/screen/alien_view = null
	var/obj/screen/g_dither = null
	var/obj/screen/blurry = null
	var/obj/screen/gogglemeson = null
	var/obj/screen/gogglethermal = null
	var/obj/screen/ectoglasses = null
	var/list/darkMask = null
	var/obj/screen/station_explosion = null

	var/h_type = /obj/screen

/obj/item
	name = "item"
	icon = 'items.dmi'
	var/icon_old = null//For when weapons get bloodied this saves their old icon.
	var/abstract = 0.0
	var/force = null
	var/item_state = null
	var/damtype = "brute"
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = null
	var/w_class = 3.0
	var/wielded = 0
	var/twohanded = 0 ///Two handed and wielded off by default, nyoro~n -Agouri
	var/force_unwielded = 0
	var/force_wielded = 0
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	pressure_resistance = 50
	var/obj/item/master = null

/obj/item/device
	icon = 'device.dmi'

/obj/item/device/detective_scanner
	name = "Scanner"
	desc = "Used to scan objects for DNA and fingerprints."
	icon_state = "forensic0"
	var/amount = 20.0
	var/printing = 0.0
	w_class = 3.0
	item_state = "electronic"
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT | USEDELAY


/obj/item/device/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
	icon_state = "flash"
	var/l_time = 1.0
	var/shots = 5.0
	throwforce = 5
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT
	item_state = "electronic"
	var/status = 1
	origin_tech = "magnets=2;combat=1"

/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon_state = "flight0"
	var/on = 0
	var/brightness_on = null //luminosity when on
	var/icon_on = "flight1"
	var/icon_off = "flight0"
	var/obj/item/weapon/cell/power = null
	w_class = 2
	item_state = "flight"
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	m_amt = 50
	g_amt = 20
	var/max_lum

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light. It shines as well as a flashlight."
	icon_state = "plight0"
	flags = FPRINT | TABLEPASS | CONDUCT
	item_state = ""
	icon_on = "plight1"
	icon_off = "plight0"
	brightness_on = 3

/obj/item/device/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "analyzer"
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	m_amt = 30
	g_amt = 20
	origin_tech = "magnets=1;engineering=1"

/obj/item/device/rd_analyzer
	desc = "A hand-held scanner which reports technology levels."
	name = "analyzer"
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = 2.0
	flags = FPRINT | TABLEPASS| CONDUCT | ONBELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	m_amt = 30
	g_amt = 20
	origin_tech = "magnets=4;engineering=4"

/obj/item/device/healthanalyzer
	name = "Health Analyzer"
	icon_state = "health"
	item_state = "analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	m_amt = 200
	origin_tech = "magnets=1;biotech=1"

/obj/item/device/healthanalyzer/tricorder
	name = "Advanced Health Analyzer"
	icon_state = "tricorder_0"
	item_state = "analyzer"
	desc = "An advanced hand-held body scanner able to distinguish vital signs of the subject."
	flags = FPRINT | ONBELT | TABLEPASS | CONDUCT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	m_amt = 200
	origin_tech = "magnets=4;biotech=4"
	var/results
	var/DNA
	var/list/Resistances = list()
	var/bloodtype
	var/list/tempchem
	var/list/temp_chem = list()
	var/dat
	var/obj/item/weapon/reagent_containers/hypospray/hypospray = null
/*
/obj/item/device/healthanalyzer/tricorder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/reagent_containers/hypospray) && src.hypospray == null)
		src.hypospray = W
		user << "You insert [W]."
		del(W)
		icon_state = "tricorder_1"
		spawn(3)
		return
*/
/obj/item/device/healthanalyzer/tricorder/attack_self(mob/user as mob)
	user.machine = src
	var/temp_text = ""
	if(!hypospray)
		user << "\red No hypospray is connected."
		return
	temp_text = "Hypospray Interface achieved..<BR>"
	temp_text = "Currently loaded with [hypospray.hyposprayvial.reagents.get_master_reagent_name()]<BR>"

	var/dat = {"[temp_text]
	<a href="?src=\ref[src]&tricordrazine=1">M</a><br>
	<a href="?src=\ref[src]&epinephrine=1">M</a><br>
	<a href="?src=\ref[src]&chloromydride=1">M</a><br>
	<a href="?src=\ref[src]&mynoglobin=1">M</a><br>
	"}

	user << browse(dat, "window=tricorder;size=450x300")
	onclose(user, "tricorder")


/obj/item/device/healthanalyzer/tricorder/Topic(href, href_list)
	src.add_fingerprint(usr)
	if(href_list["tricordrazine"])
		hypospray.reagents.add_reagent("tricordrazine", 5) //uncomment this to make it start with stuff in
		spawn(5)
		hypospray.icon_state = "hypocolor"
		hypospray.main_reagent = hypospray.reagents.get_master_reagent_reference()
		var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
		hypoc.Blend(rgb(hypospray.main_reagent:color_r, hypospray.main_reagent:color_g, hypospray.main_reagent:color_b), ICON_ADD)
		hypospray.overlays += hypoc
		hypospray.main_reagent = ""

		for(var/mob/living/user in src.loc)
			user << "\blue You remove the hypospray"
			if(user.hand)
				user.l_hand = hypospray
			else
				user.r_hand = hypospray
		src.hypospray = null
		icon_state = "tricorder_0"
		spawn(3)
		return
	if(href_list["epinephrine"])
		hypospray.reagents.add_reagent("epinephrine", 5) //uncomment this to make it start with stuff in
		spawn(5)
		hypospray.icon_state = "hypocolor"
		hypospray.main_reagent = hypospray.reagents.get_master_reagent_reference()
		var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
		hypoc.Blend(rgb(hypospray.main_reagent:color_r, hypospray.main_reagent:color_g, hypospray.main_reagent:color_b), ICON_ADD)
		hypospray.overlays += hypoc
		hypospray.main_reagent = ""

		for(var/mob/living/user in src.loc)
			user << "\blue You remove the hypospray"
			if(user.hand)
				user.l_hand = hypospray
			else
				user.r_hand = hypospray
		src.hypospray = null
		icon_state = "tricorder_0"
		spawn(3)
		return
	if(href_list["chloromydride"])
		hypospray.reagents.add_reagent("chloromydride", 5) //uncomment this to make it start with stuff in
		spawn(5)
		hypospray.icon_state = "hypocolor"
		hypospray.main_reagent = hypospray.reagents.get_master_reagent_reference()
		var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
		hypoc.Blend(rgb(hypospray.main_reagent:color_r, hypospray.main_reagent:color_g, hypospray.main_reagent:color_b), ICON_ADD)
		hypospray.overlays += hypoc
		hypospray.main_reagent = ""

		for(var/mob/living/user in src.loc)
			user << "\blue You remove the hypospray"
			if(user.hand)
				user.l_hand = hypospray
			else
				user.r_hand = hypospray
		src.hypospray = null
		icon_state = "tricorder_0"
		spawn(3)
		return
	if(href_list["mynoglobin"])
		hypospray.reagents.add_reagent("mynoglobin", 5) //uncomment this to make it start with stuff in
		spawn(5)
		hypospray.icon_state = "hypocolor"
		hypospray.main_reagent = hypospray.reagents.get_master_reagent_reference()
		var/icon/hypoc = new/icon("icon" = 'chemical.dmi', "icon_state" = "hypocolormod")
		hypoc.Blend(rgb(hypospray.main_reagent:color_r, hypospray.main_reagent:color_g, hypospray.main_reagent:color_b), ICON_ADD)
		hypospray.overlays += hypoc
		hypospray.main_reagent = ""

		for(var/mob/living/user in src.loc)
			user << "\blue You remove the hypospray"
			if(user.hand)
				user.l_hand = hypospray
			else
				user.r_hand = hypospray
		src.hypospray = null
		icon_state = "tricorder_0"
		spawn(3)
		return
	return
/obj/item/device/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances. Does not function well as a lighter."
	icon_state = "igniter"
	var/status = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	m_amt = 100
	throwforce = 5
	w_class = 1.0
	throw_speed = 3
	throw_range = 10
	origin_tech = "magnets=1"

/obj/item/device/infra
	name = "Infrared Beam (Security)"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared0"
	var/obj/beam/i_beam/first = null
	var/state = 0.0
	var/visible = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	item_state = "electronic"
	m_amt = 150
	origin_tech = "magnets=2"

/obj/item/device/infra_sensor
	name = "Infrared Sensor"
	desc = "Scans for infrared beams in the vicinity."
	icon_state = "infra_sensor"
	var/passive = 1.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	m_amt = 150
	origin_tech = "magnets=2"

/obj/item/device/t_scanner
	name = "T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-ray0"
	var/on = 0
	flags = FPRINT|ONBELT|TABLEPASS
	w_class = 2
	item_state = "electronic"
	m_amt = 150
	origin_tech = "magnets=3;engineering=3"

//portable jammer
/obj/item/device/radio/portajammer
	name = "signal jammer"
	desc = "Used for jamming signals in a small radius."
	icon = 'device.dmi'
	icon_state = "portajammer"
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	m_amt = 50
	g_amt = 20
	var/on = 0
	origin_tech = "magnets=3;engineering=3"

/obj/item/device/signalermotion
	name = "proximity sensor and signaler assembly"
	desc = "Used for detecting signals"
	icon_state = "signalermotion"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	m_amt = 50
	g_amt = 20
	origin_tech = "engineering=5"

/obj/item/device/radio/signaler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/device/prox_sensor/))
		var/obj/item/device/prox_sensor/S = W
		var/obj/item/device/signalermotion/R = new /obj/item/device/signalermotion( user )
		S.loc = R
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)
		src << "\red You attach the signaler to the proximity sensor"

/obj/item/device/signalermotion/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/device/radio/headset/))
		var/obj/item/device/prox_sensor/S = W
		var/obj/item/device/radio/portajammer/R = new /obj/item/device/radio/portajammer( user )
		S.loc = R
		S.layer = initial(S.layer)
		if (user.client)
			user.client.screen -= S
		if (user.r_hand == S)
			user.u_equip(S)
			user.r_hand = R
		else
			user.u_equip(S)
			user.l_hand = R
		S.master = R
		src.master = R
		src.layer = initial(src.layer)
		user.u_equip(src)
		if (user.client)
			user.client.screen -= src
		src.loc = R
		R.layer = 20
		R.loc = user
		src.add_fingerprint(user)
		src << "\red You attach the headset to the proximity sensor and signaler assembly"

/obj/item/device/radio/portajammer/Topic(href, href_list)
	//..()
	if (usr.stat || usr.restrained())
		return
	if (((istype(usr, /mob/living/carbon/human) && ((!( ticker ) || (ticker && ticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(src.master) || (in_range(src, usr) && istype(src.loc, /turf)))))
		usr.machine = src
		if (href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		else
			if (href_list["power"])
				src.on = !( src.on )
		if (!( src.master ))
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(308)
		else
			if (istype(src.master.loc, /mob))
				src.attack_self(src.master.loc)
			else
				for(var/mob/M in viewers(1, src.master))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(384)
	else
		usr << browse(null, "window=jammer")
		return
	return

/obj/item/device/radio/portajammer/attack_self(mob/user as mob, flag1)

	if (!( istype(user, /mob/living/carbon/human) ))
		return
	user.machine = src
	var/dat = {"<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><TT>
<A href='?src=\ref[src];power=1'>Turn [src.on ? "Off" : "On"]</A><BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
</TT>"}
	user << browse(dat, "window=jammer")
	onclose(user, "jammer")
	return
//end portable jammer

/obj/item/device/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut. Not recommended by doctors."
	icon_state = "multitool"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	m_amt = 50
	g_amt = 20
	origin_tech = "magnets=2;engineering=2"


/obj/item/device/prox_sensor
	name = "Proximity Sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "motion0"
	var/state = 0.0
	var/timing = 0.0
	var/time = null
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	item_state = "electronic"
	m_amt = 300
	origin_tech = "magnets=1"


/obj/item/device/shield
	name = "shield"
	desc = "This is an item which is specially crafted to shield you. It is much like a visible version of the outdated cloaking device."
	icon_state = "shield0"
	var/active = 0.0
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

/obj/item/device/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer0"
	item_state = "electronic"
	var/timing = 0.0
	var/time = null
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 2.0
	m_amt = 100

/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There's stamp \"Classified\" and several coffee stains on it."
	icon = 'items.dmi'
	icon_state = "blueprints"

/obj/item/apc_frame
	name = "APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'apc_repair.dmi'
	icon_state = "apc_frame"
	flags = FPRINT | TABLEPASS| CONDUCT

/obj/landmark
	name = "landmark"
	icon = 'screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1

/obj/landmark/New()
	landmarkz += src

/obj/landmark/alterations
	name = "alterations"

/obj/laser
	name = "laser"
	desc = "IT BURNS!!!"
	icon = 'projectiles.dmi'
	var/damage = 0.0
	var/range = 10.0

/obj/lattice
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	layer = 2.3 //under pipes
	//	flags = 64.0

/obj/lattice/New()
	..()
//	if(!(istype(src.loc, /turf/space)))
//		del(src)
	for(var/obj/lattice/LAT in src.loc)
		if(LAT != src)
			del(LAT)
	if(icon_state == "latticefull")
		icon = 'smoothlattice.dmi'
		icon_state = "latticeblank"
		updateOverlays()
		for (var/dir in cardinal)
			var/obj/lattice/L
			if(locate(/obj/lattice, get_step(src, dir)))
				L = locate(/obj/lattice, get_step(src, dir))
				L.updateOverlays()

/obj/lattice/Del()
	for (var/dir in cardinal)
		var/obj/lattice/L
		if(locate(/obj/lattice, get_step(src, dir)))
			L = locate(/obj/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	..()

/obj/lattice/proc/updateOverlays()
	if(icon == 'smoothlattice.dmi')
		//if(!(istype(src.loc, /turf/space)))
		//	del(src)
		spawn(1)
			overlays = list()

			var/dir_sum = 0

			for (var/direction in cardinal)
				if(locate(/obj/lattice, get_step(src, direction)))
					dir_sum += direction
				else
					if(!(istype(get_step(src, direction), /turf/space)))
						dir_sum += direction

			icon_state = "lattice[dir_sum]"
			return

			/*
			overlays += icon(icon,"lattice-middlebar") //the nw-se bar in the cneter
			for (var/dir in cardinal)
				if(locate(/obj/lattice, get_step(src, dir)))
					src.overlays += icon(icon,"lattice-[dir2text(dir)]")
				else
					src.overlays += icon(icon,"lattice-nc-[dir2text(dir)]") //t for turf
					if(!(istype(get_step(src, dir), /turf/space)))
						src.overlays += icon(icon,"lattice-t-[dir2text(dir)]") //t for turf

			//if ( !( (locate(/obj/lattice, get_step(src, SOUTH))) || (locate(/obj/lattice, get_step(src, EAST))) ))
			//	src.overlays += icon(icon,"lattice-c-se")
			if ( !( (locate(/obj/lattice, get_step(src, NORTH))) || (locate(/obj/lattice, get_step(src, WEST))) ))
				src.overlays += icon(icon,"lattice-c-nw")
			if ( !( (locate(/obj/lattice, get_step(src, NORTH))) || (locate(/obj/lattice, get_step(src, EAST))) ))
				src.overlays += icon(icon,"lattice-c-ne")
			if ( !( (locate(/obj/lattice, get_step(src, SOUTH))) || (locate(/obj/lattice, get_step(src, WEST))) ))
				src.overlays += icon(icon,"lattice-c-sw")

			if(!(overlays))
				icon_state = "latticefull"
			*/

/obj/thinwall
	name = "wall"
	icon = 'structures.dmi'
	icon_state = "thinwall"
	desc = "Looks simply like a thin version of a metal wall."
	density = 0
	opacity = 1
	var/ini_dir = null
	var/state = 0
	var/health = 200
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER

/obj/thinwall/north
	dir = NORTH

/obj/thinwall/east
	dir = EAST

/obj/thinwall/west
	dir = WEST

/obj/thinwall/south
	dir = SOUTH

/obj/thinwall/glass
	opacity = 0

/obj/list_container
	name = "list container"

/obj/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'stationobjs.dmi'
	icon_state = "morguet"
	density = 1
	layer = 2.0
	var/obj/morgue/connected = null
	anchored = 1.0

/obj/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'stationobjs.dmi'
	icon_state = "cremat"
	density = 1
	layer = 2.0
	var/obj/crematorium/connected = null
	anchored = 1.0





/obj/cable
	level = 1
	anchored =1
	var/netnum = 0
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer. Comes in clown colors now."
	icon = 'power_cond_red.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	layer = 2.5
	var/colour="red"

/obj/cable/yellow
	colour="yellow"
	icon = 'power_cond_yellow.dmi'

/obj/cable/green
	colour="green"
	icon = 'power_cond_green.dmi'

/obj/cable/blue
	colour="blue"
	icon = 'power_cond_blue.dmi'

/obj/cable/pink
	colour="red"
	icon = 'power_cond_pink.dmi'

/obj/manifest
	name = "manifest"
	icon = 'screen1.dmi'
	icon_state = "x"
	unacidable = 1//Just to be sure.

/obj/morgue
	name = "morgue"
	desc = "Used to keep bodies in untill someone fetches them."
	icon = 'stationobjs.dmi'
	icon_state = "morgue1"
	density = 1
	var/obj/m_tray/connected = null
	anchored = 1.0

/obj/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'stationobjs.dmi'
	icon_state = "crema1"
	density = 1
	var/obj/c_tray/connected = null
	anchored = 1.0
	var/cremating = 0
	var/id = 1
	var/locked = 0

/obj/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	layer = 3
	icon = 'weapons.dmi'
	icon_state = "uglymine"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0

/obj/mine/dnascramble
	name = "Radiation Mine"
	icon_state = "uglymine"
	triggerproc = "triggerrad"

/obj/mine/plasma
	name = "Plasma Mine"
	icon_state = "uglymine"
	triggerproc = "triggerplasma"

/obj/mine/kick
	name = "Kick Mine"
	icon_state = "uglymine"
	triggerproc = "triggerkick"

/obj/mine/n2o
	name = "N2O Mine"
	icon_state = "uglymine"
	triggerproc = "triggern2o"

/obj/mine/stun
	name = "Stun Mine"
	icon_state = "uglymine"
	triggerproc = "triggerstun"

/obj/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='beam.dmi'
	icon_state="b_beam"
	var/tmp/atom/BeamSource
	New()
		..()
		spawn(10) del src

/obj/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0

/obj/projection
	name = "Projection"
	desc = "This looks like a projection of something."
	anchored = 1.0

/obj/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'objects.dmi'
	icon_state = "rack"
	density = 1
	flags = FPRINT
	anchored = 1.0

/obj/screen
	name = "screen"
	icon = 'screen1.dmi'
	layer = 20.0
	unacidable = 1
	var/id = 0.0
	var/obj/master

/obj/screen/close
	name = "close"
	master = null

/obj/screen/grab
	name = "grab"
	master = null

/obj/screen/storage
	name = "storage"
	master = null

/obj/screen/zone_sel
	name = "Damage Zone"
	icon = 'zone_sel.dmi'
	icon_state = "blank"
	var/selecting = "chest"
	screen_loc = "EAST+1,NORTH"

/obj/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )

/obj/landmark/start
	name = "start"
	icon = 'screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/brigbed
	name = "bed"
	desc = "A prison bed."
	icon = 'objects.dmi'
	icon_state = "bed"
	flags = FPRINT
	pressure_resistance = 3*ONE_ATMOSPHERE

/obj/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'objects.dmi'
	icon_state = "stool"
	flags = FPRINT
	pressure_resistance = 3*ONE_ATMOSPHERE

/obj/stool/bar
	name = "stool"
	desc = "Apply butt."
	icon = 'objects.dmi'
	icon_state = "barstool"
	flags = FPRINT
	pressure_resistance = 3*ONE_ATMOSPHERE

/obj/stool/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon_state = "bed"
	anchored = 1.0
	var/list/buckled_mobs = list(  )

/obj/stool/chair
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"
	var/status = 0.0
	anchored = 1
	var/list/buckled_mobs = list(  )

/obj/stool/chair/e_chair
	name = "electrified chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "e_chair0"
	anchored = 1
	var/atom/movable/overlay/overl = null
	var/on = 0.0
	var/obj/item/assembly/shock_kit/part1 = null
	var/last_time = 1.0

/obj/table
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'structures.dmi'
	icon_state = "table"
	density = 1
	anchored = 1.0
	layer = 2.8

	New()
		..()
		for(var/obj/table/T in src.loc)
			if(T != src)
				del(T)
		update_icon()
		for(var/direction in list(1,2,4,8,5,6,9,10))
			if(locate(/obj/table,get_step(src,direction)))
				var/obj/table/T = locate(/obj/table,get_step(src,direction))
				T.update_icon()

	Del()
		for(var/direction in list(1,2,4,8,5,6,9,10))
			if(locate(/obj/table,get_step(src,direction)))
				var/obj/table/T = locate(/obj/table,get_step(src,direction))
				T.update_icon()
		..()

	update_icon()
		spawn(2) //So it properly updates when deleting
			var/dir_sum = 0
			for(var/direction in cardinal)
				var/skip_sum = 0
				for(var/obj/window/W in src.loc)
					if(W.dir == direction) //So smooth tables don't go smooth through windows
						skip_sum = 1
						continue
				var/inv_direction //inverse direction
				switch(direction)
					if(1)
						inv_direction = 2
					if(2)
						inv_direction = 1
					if(4)
						inv_direction = 8
					if(8)
						inv_direction = 4
				for(var/obj/window/W in get_step(src,direction))
					if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
						skip_sum = 1
						continue
				if(!skip_sum) //means there is a window between the two tiles in this direction
					if(locate(/obj/table,get_step(src,direction)))
						dir_sum += direction

			//dir_sum:
			//  1,2,4,8 = endtable
			//  3,12 = streight 1 tile thick table
			//  5,6,9,10 = corner, if it finds a table in get_step(src,dir_sum) then it's a full corner table, else it's a 1 tile chick corner table
			//  7,11,13,14 = three way intersection = full side table piece (north ,south, east or west)
			//  15 = four way intersection = center (aka middle) table piece
			//
			//table_type:
			//  0 = stand-alone table
			//  1 = end table (1 tile thick, 1 connection)
			//  2 = 1 tile thick table (1 tile thick, 2 connections)
			//  3 = full table (full, 3 connections)
			//  4 = middle table (full, 4 connections)

			var/table_type = 0 //stand_alone table
			if(dir_sum in cardinal)
				table_type = 1 //endtable
			if(dir_sum in list(3,12))
				table_type = 2 //1 tile thick, streight table
				if(dir_sum == 3) //3 doesn't exist as a dir
					dir_sum = 2
				if(dir_sum == 12) //12 doesn't exist as a dir.
					dir_sum = 4
			if(dir_sum in list(5,6,9,10))
				if(locate(/obj/table,get_step(src.loc,dir_sum)))
					table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
				else
					table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
			if(dir_sum in list(13,14,7,11)) //Three-way intersection
				table_type = 3 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations
				switch(dir_sum)
					if(7)
						dir_sum = 4
					if(11)
						dir_sum = 8
					if(13)
						dir_sum = 1
					if(14)
						dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
			if(dir_sum == 15)
				table_type = 4 //4-way intersection, the 'middle' table sprites will be used.

			if(istype(src,/obj/table/reinforced/wood))
				switch(table_type)
					if(0)
						icon_state = "reinfwood_table"
					if(1)
						icon_state = "reinfwood_1tileendtable"
					if(2)
						icon_state = "reinfwood_1tilethick"
					if(3)
						icon_state = "reinfwood_tabledir"
					if(4)
						icon_state = "reinfwood_middle"
			else if(istype(src,/obj/table/reinforced))
				switch(table_type)
					if(0)
						icon_state = "reinf_table"
					if(1)
						icon_state = "reinf_1tileendtable"
					if(2)
						icon_state = "reinf_1tilethick"
					if(3)
						icon_state = "reinf_tabledir"
					if(4)
						icon_state = "reinf_middle"
			else if(istype(src,/obj/table/woodentable))
				switch(table_type)
					if(0)
						icon_state = "wood_table"
					if(1)
						icon_state = "wood_1tileendtable"
					if(2)
						icon_state = "wood_1tilethick"
					if(3)
						icon_state = "wood_tabledir"
					if(4)
						icon_state = "wood_middle"
			else if(istype(src,/obj/table/tutorial))
				return
			else if(istype(src,/obj/table/shelf))
				return
			else
				switch(table_type)
					if(0)
						icon_state = "table"
					if(1)
						icon_state = "table_1tileendtable"
					if(2)
						icon_state = "table_1tilethick"
					if(3)
						icon_state = "tabledir"
					if(4)
						icon_state = "table_middle"
			if (dir_sum in list(1,2,4,8,5,6,9,10))
				dir = dir_sum
			else
				dir = 2

/obj/table/reinforced
	name = "reinforced table"
	desc = "A version of the four legged table. It is stronger."
	icon_state = "reinf_table"
	var/status = 2

/obj/table/reinforced/wood
	name = "reinforced table"
	desc = "A version of the four legged table. It is stronger."
	icon_state = "reinfwood_table"
	status = 2

/obj/table/woodentable
	name = "wooden table"
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon_state = "wood_table"

/obj/table/tutorial
	name = "virtual table"
	desc = "If you're holding something, and you click a table while standing next to it, you'll set your item on the table."
	icon = 'tutorial.dmi'
	icon_state = "table"
	density = 1
	anchored = 1.0
	layer = 2.8

/obj/table/shelf
	name = "shelving unit"
	desc = "An efficient surface area management system. It can not move."
	icon_state = "metalshelf"
/*
	proc
		addbottle(var/obj/item/weapon/book/b)
			for(var/i=1,i<=14,i++)
				if(!stored_books[1][i])
					stored_books[1][i]=b
					generateBook(i)
					return 1
			return 0
		removebottle(var/obj/item/weapon/book/b)
			for(var/i=1,i<=14,i++)
				if(stored_books[1][i]==b)
					stored_books[1][i]=null
					stored_books[2][i]=null
					updateIcons()

		generatebottle(var/i)
			var/icon/shelf_icon = new/icon("icon" = initial(icon), "icon_state" = "shelf_book")
			var/colour_min=0
			var/colour_max=50
			shelf_icon.Blend(rgb(rand(colour_min,colour_max), rand(colour_min,colour_max), rand(colour_min,colour_max)), ICON_ADD)
			var/icon/shelf_band = new/icon("icon" = initial(icon), "icon_state" = "shelf_band[rand(0,5)]")
			colour_min=50
			colour_max=150
			shelf_band.Blend(rgb(rand(colour_min,colour_max), rand(colour_min,colour_max), rand(colour_min,colour_max)), ICON_ADD)
			shelf_icon.Blend(shelf_band, ICON_OVERLAY)
			//NORTH 2||14
			var/north_shift=2
			if(i%2)north_shift=14
			var/east_shift=2+( (i+(i%2))*1.5 )
			shelf_icon.Shift(NORTH,north_shift)
			shelf_icon.Shift(EAST,east_shift)
			stored_books[2][i]=shelf_icon
			updateIcons()

		updateIcons()
			var/icon/bookshelf_icon=new/icon("icon" = initial(icon), "icon_state" = initial(icon_state))
			for(var/i=1,i<=14,i++)
				if(stored_books[2][i])
					bookshelf_icon.Blend(stored_books[2][i],ICON_OVERLAY)
			icon=bookshelf_icon
*/
/obj/mopbucket
	desc = "Fill it with water, but don't forget a mop!"
	name = "mop bucket"
	icon = 'janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	flags = FPRINT
	pressure_resistance = ONE_ATMOSPHERE
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

/obj/kitchenspike
	name = "a meat spike"
	icon = 'kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals"
	density = 1
	anchored = 1
	var/meat = 0
	var/occupied = 0
	var/meattype = 0 // 0 - Nothing, 1 - Monkey, 2 - Xeno

/obj/displaycase
	name = "Display Case"
	icon = 'stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	var/health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/showcase
	name = "Showcase"
	icon = 'stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

//BEGIN BRAINS=====================================================
/obj/item/brain
	name = "brain"
	desc = "A piece of juicy meat found in a persons head."
	icon = 'surgery.dmi'
	icon_state = "brain2"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "biotech=3"

	var
		mob/living/carbon/brain/brainmob = null

	New()
		..()
		//Shifting the brain "mob" over to the brain object so it's easier to keep track of. --NEO
		//WASSSSSUUUPPPP /N
		spawn(5)
			if(brainmob&&brainmob.client)
				brainmob.client.screen.len = null //clear the hud

	proc
		transfer_identity(var/mob/living/carbon/human/H)
			name = "[H]'s brain"
			brainmob = new(src)
			brainmob.name = H.real_name
			brainmob.real_name = H.real_name
			brainmob.dna = H.dna
			if(H.mind)
				H.mind.transfer_to(brainmob)
			brainmob << "\blue You might feel slightly disoriented. That's normal when your brain gets cut out."
			return

//END BRAINS=====================================================



// Basically this Metroid Core catalyzes reactions that normally wouldn't happen anywhere
/obj/item/metroid_core
	name = "metroid core"
	desc = "A very slimy and tender part of a Metroid. They also legended to have \"magical powers\"."
	icon = 'surgery.dmi'
	icon_state = "metroid core"
	flags = TABLEPASS
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 6
	origin_tech = "biotech=4"
	var/POWERFLAG = 0 // sshhhhhhh
	var/Flush = 30

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		POWERFLAG = rand(1,10)
		//flags |= NOREACT

		spawn()
			Life()

	proc/Life()
		while(src)
			sleep(10)
			Flush--
			if(Flush <= 0)
				reagents.clear_reagents()
				Flush = 30




/obj/noticeboard
	name = "Notice Board"
	icon = 'stationobjs.dmi'
	icon_state = "nboard00"
	flags = FPRINT
	desc = "A board for pinning important notices upon."
	density = 0
	anchored = 1
	var/notices = 0

/obj/deskclutter
	name = "desk clutter"
	icon = 'items.dmi'
	icon_state = "deskclutter"
	desc = "Some clutter the detective has accumalated over the years..."
	anchored = 1

/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/item/mechadoll
	name = "doll"
	icon = 'items.dmi'
	desc = "A mecha doll, straight from one of your Japanese animes!"

	New()
		pixel_y = rand(-5,5)
		pixel_x = rand(-5,5)

/obj/item/mechadoll/durand
	icon_state = "duranddoll"

/obj/item/mechadoll/ripley
	icon_state = "ripleydoll"

/obj/item/mechadoll/gygax
	icon_state = "gygaxdoll"

/obj/item/mechadoll/marauder
	icon_state = "marauderdoll"

/obj/item/mechadoll/mining
	icon_state = "miningrigdoll"


// TODO: robust mixology system! (and merge with beakers, maybe)
/obj/item/weapon/glass
	name = "empty glass"
	desc = "Emptysville."
	icon = 'kitchen.dmi'
	icon_state = "glass_empty"
	item_state = "beaker"
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/datum/substance/inside = null
	throwforce = 5
	g_amt = 100
	New()
		..()
		src.pixel_x = rand(-5, 5)
		src.pixel_y = rand(-5, 5)

/obj/item/weapon/storage
	icon = 'storage.dmi'
	name = "storage"
	var/list/can_hold = new/list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = new/list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/max_w_class = 2 //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	var/storage_slots = 7 //The number of storage slots in this container.
	var/obj/screen/storage/boxes = null
	var/obj/screen/close/closer = null
	w_class = 3.0
	New()
		..()
		src.pixel_x = rand(-3.0, 3)
		src.pixel_y = rand(-3.0, 3)


/obj/item/weapon/storage/glasswarebox
	name = "Glassware Box"
	icon_state = "glassware"
	item_state = "syringe_kit"

/obj/item/weapon/storage/glasswarebox/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )
	new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass( src )

/obj/item/weapon/storage/cupbox
	name = "Paper-cup Box"
	icon_state = "box"
	item_state = "syringe_kit"
	New()
		..()
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )
		new /obj/item/weapon/reagent_containers/food/drinks/papercup( src )

/obj/item/weapon/storage/silverwarebox
	name = "Silverware"
	icon_state = "silverware"
	item_state = "syringe_kit"

/obj/item/weapon/storage/silverwarebox/New()
	new /obj/item/weapon/kitchen/utensil/fork( src )
	new /obj/item/weapon/kitchen/utensil/fork( src )
	new /obj/item/weapon/kitchen/utensil/fork( src )
	new /obj/item/weapon/kitchen/utensil/spoon( src )
	new /obj/item/weapon/kitchen/utensil/spoon( src )
	new /obj/item/weapon/kitchen/utensil/knife( src )
	new /obj/item/weapon/kitchen/utensil/knife( src )
	..()
	return

/obj/falsewall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'walls.dmi'
	icon_state = ""
	density = 1
	opacity = 1
	anchored = 1

/obj/falserwall
	name = "r wall"
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon = 'walls.dmi'
	icon_state = "r_wall"
	density = 1
	opacity = 1
	anchored = 1

/obj/nanowall
	name = "r wall"
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon = 'walls.dmi'
	icon_state = "r_wall"
	density = 1
	opacity = 1
	anchored = 1

/obj/item/stack
	var/singular_name
	var/amount = 1.0
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount

/obj/item/stack/rods
	name = "metal rods"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 3.0
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	m_amt = 1875
	max_amount = 60

/obj/item/stack/sheet
	name = "sheet"
//	var/const/length = 2.5 //2.5*1.5*0.01*100000 == 3750 == m_amt
//	var/const/width = 1.5
//	var/const/height = 0.01
	flags = FPRINT | TABLEPASS
	w_class = 3.0
	max_amount = 50
	var/perunit = 3750

/obj/item/stack/sheet/wood
	name = "Wood Planks"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "wood plank"
	icon_state = "sheet-wood"
	force = 5.0
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	origin_tech = "materials=1;biotech=1"

/obj/item/stack/sheet/sandstone
	name = "Sandstone Bricks"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	force = 5.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	origin_tech = "materials=1"

/obj/item/stack/sheet/glass
	name = "glass"
	desc = "HOLY HELL! That is a lot of glass."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	force = 5.0
	g_amt = 3750
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	origin_tech = "materials=1"

/obj/item/stack/sheet/glass/m50
	amount = 50

/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	desc = "Glass which seems to have rods or something stuck in them."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	force = 6.0
	g_amt = 3750
	m_amt = 1875
	throwforce = 5
	throw_speed = 3
	throw_range = 3
	origin_tech = "materials=2"

/obj/item/stack/sheet/metal
	name = "metal"
	desc = "Sheets made out off metal. It has been dubbed Metal Sheets."
	singular_name = "metal sheet"
	icon_state = "sheet-metal"
	force = 5.0
	m_amt = 3750
	throwforce = 14.0
	throw_speed = 1
	throw_range = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "materials=1"

/obj/item/stack/sheet/metal/m50
	amount = 50

/obj/item/stack/sheet/r_metal
	name = "reinforced metal"
	singular_name = "reinforced metal sheet"
	desc = "A very heavy sheet of metal."
	icon_state = "sheet-r_metal"
	item_state = "sheet-metal"
	force = 5.0
	m_amt = 7500
	throwforce = 15.0
	throw_speed = 1
	throw_range = 4
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "materials=2"

/obj/item/stack/tile/steel
	name = "Steel floor tile"
	singular_name = "Steel floor tile"
	desc = "Those could work as a pretty decent close range throwing weapon"
	icon_state = "tile"
	w_class = 3.0
	force = 6.0
	m_amt = 937.5
	throwforce = 15.0
	throw_speed = 3
	throw_range = 10
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

/obj/item/stack/tile/grass
	name = "Grass tile"
	singular_name = "Grass floor tile"
	desc = "A patch of grass like they often use on golf courses"
	icon_state = "tile_grass"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	origin_tech = "biotech=1"

/obj/item/stack/light_w
	name = "Wired glass tile"
	singular_name = "Wired glass tile"
	desc = "A glass tile, which is wired, somehow."
	icon_state = "glass_wire"
	w_class = 3.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		..()
		if(istype(O,/obj/item/weapon/wirecutters))
			var/obj/item/weapon/cable_coil/CC = new/obj/item/weapon/cable_coil(user.loc)
			CC.amount = 5
			amount--
			new/obj/item/stack/sheet/glass(user.loc)
			if(amount <= 0)
				user.u_equip(src)
				del(src)

		if(istype(O,/obj/item/stack/sheet/metal))
			var/obj/item/stack/sheet/metal/M = O
			M.amount--
			if(M.amount <= 0)
				user.u_equip(M)
				del(M)
			amount--
			new/obj/item/stack/tile/light(user.loc)
			if(amount <= 0)
				user.u_equip(src)
				del(src)

/obj/item/stack/tile/light
	name = "Light floor tile"
	singular_name = "Light floor tile"
	desc = "A floor tile, made out off glass. It produces light."
	icon_state = "tile_e"
	w_class = 3.0
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 20
	flags = FPRINT | TABLEPASS | CONDUCT
	max_amount = 60
	var/on = 1
	var/state //0 = fine, 1 = flickering, 2 = breaking, 3 = broken

	New()
		..()
		if(prob(5))
			state = 3 //broken
		else if(prob(5))
			state = 2 //breaking
		else if(prob(10))
			state = 1 //flickering occasionally
		else
			state = 0 //fine

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		..()
		if(istype(O,/obj/item/weapon/crowbar))
			new/obj/item/stack/sheet/metal(user.loc)
			amount--
			new/obj/item/stack/light_w(user.loc)
			if(amount <= 0)
				user.u_equip(src)
				del(src)


/obj/item/weapon/beach_ball
	icon = 'beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "clown"
	density = 0
	anchored = 0
	w_class = 1.0
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	flags = FPRINT | USEDELAY | TABLEPASS | CONDUCT
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed)

