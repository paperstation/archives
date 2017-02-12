/obj/decal
	var/list/random_icon_states = list()
	var/random_dir = 0

	New()
		..()
		if (random_icon_states && length(src.random_icon_states) > 0)
			src.icon_state = pick(src.random_icon_states)
		if (src.random_dir)
			if (random_dir >= 8)
				src.dir = pick(alldirs)
			else
				src.dir = pick(cardinal)

		if (!real_name)
			real_name = name

	meteorhit(obj/M as obj)
		if (src.z == 2)
			return
		else
			return ..()

	ex_act(severity)
		if (src.z == 2)
			return
		else
			return ..()

/obj/decal/poster
	desc = "A piece of paper with an image on it. Clearly dealing with incredible technology here."
	name = "poster"
	icon = 'icons/obj/items.dmi'
	icon_state = "poster"
	anchored = 1
	opacity = 0
	density = 0
	var/imgw = 600
	var/imgh = 400
	var/popup_win = 1
	layer = EFFECTS_LAYER_BASE

	examine()
		if (usr.client && src.popup_win)
			src.show_popup_win(usr)
		else
			return ..()

	proc/show_popup_win(var/client/C)
		if (!C || !src.popup_win)
			return
		C << browse(grabResource("html/traitorTips/wizardTips.html"),"window=antagTips;titlebar=1;size=[imgw]x[imgh];can_minimize=0;can_resize=0")

	wallsign
		desc = "A sign, on a wall. Wow!"
		icon = 'icons/obj/decals.dmi'
		popup_win = 0
		var/pixel_var = 0

		New()
			..()
			if (src.pixel_var)
				src.pixel_y += rand(-4,4)
				src.pixel_x += rand(-4,4)


		stencil // font: "space frigate", free and adapted by cogwerks
			name = "stencil"
			desc = ""
			icon = 'icons/obj/stencils.dmi'
			alpha = 200
			pixel_y = 9
			mouse_opacity = 0
			icon_state = "a"


			// splitting this shit up into children seems easier than assigning them all in the mapmaker with varediting.
			// it'll make it way easier to assemble stencils while maintaining controlled spacing
			// this is not a monospaced font so manual adjustments are necessary after laying out text
			// should be a close-enough estimate for starters though
			// characters may fit as dublets or triplets on one turf
			// i suppose it would have been more sensical to just dump out a bunch of full words from gimp
			// instead of hand-setting a typeface inside a fucking spaceman game
			// but fuck it, this will let other mappers write whatever hull stencils they want from it. have fun?
			// going piece by piece should also make damage look more realistic, no floating words over a breach
			// i'm aligning stencils against corners, so stencils on opposite sides of an airbridge will be either l or r aligned


			left
				pixel_x = -3 //fine-tune from this offset

				a
					name = "a"
					icon_state = "a"
				b
					name = "b"
					icon_state = "b"
				c
					name = "c"
					icon_state = "c"
				d
					name = "d"
					icon_state = "d"
				e
					name = "e"
					icon_state = "e"
				f
					name = "f"
					icon_state = "f"
				g
					name = "g"
					icon_state = "g"
				h
					name = "h"
					icon_state = "h"
				i
					name = "i"
					icon_state = "i"
				j
					name = "j"
					icon_state = "j"
				k
					name = "k"
					icon_state = "k"
				l
					name = "l"
					icon_state = "l"
				m
					name = "m"
					icon_state = "m"
				n
					name = "n"
					icon_state = "n"
				o
					name = "o"
					icon_state = "o"
				p
					name = "p"
					icon_state = "p"
				q
					name = "q"
					icon_state = "q"
				r
					name = "r"
					icon_state = "r"
				s
					name = "s"
					icon_state = "s"
				t
					name = "t"
					icon_state = "t"
				u
					name = "u"
					icon_state = "u"
				v
					name = "v"
					icon_state = "v"
				w
					name = "w"
					icon_state = "w"
				x
					name = "x"
					icon_state = "x"
				y
					name = "y"
					icon_state = "y"
				z
					name = "z"
					icon_state = "z"
				one
					name = "one"
					icon_state = "1"
				two
					name = "two"
					icon_state = "2"
				three
					name = "three"
					icon_state = "3"
				four
					name = "four"
					icon_state = "4"
				five
					name = "five"
					icon_state = "5"
				six
					name = "six"
					icon_state = "6"
				seven
					name = "seven"
					icon_state = "7"
				eight
					name = "eight"
					icon_state = "8"
				nine
					name = "nine"
					icon_state = "9"
				zero
					name = "zero"
					icon_state = "0"


			right
				pixel_x = 11 // fine-tune from this offset

				a
					name = "a"
					icon_state = "a"
				b
					name = "b"
					icon_state = "b"
				c
					name = "c"
					icon_state = "c"
				d
					name = "d"
					icon_state = "d"
				e
					name = "e"
					icon_state = "e"
				f
					name = "f"
					icon_state = "f"
				g
					name = "g"
					icon_state = "g"
				h
					name = "h"
					icon_state = "h"
				i
					name = "i"
					icon_state = "i"
				j
					name = "j"
					icon_state = "j"
				k
					name = "k"
					icon_state = "k"
				l
					name = "l"
					icon_state = "l"
				m
					name = "m"
					icon_state = "m"
				n
					name = "n"
					icon_state = "n"
				o
					name = "o"
					icon_state = "o"
				p
					name = "p"
					icon_state = "p"
				q
					name = "q"
					icon_state = "q"
				r
					name = "r"
					icon_state = "r"
				s
					name = "s"
					icon_state = "s"
				t
					name = "t"
					icon_state = "t"
				u
					name = "u"
					icon_state = "u"
				v
					name = "v"
					icon_state = "v"
				w
					name = "w"
					icon_state = "w"
				x
					name = "x"
					icon_state = "x"
				y
					name = "y"
					icon_state = "y"
				z
					name = "z"
					icon_state = "z"
				one
					name = "one"
					icon_state = "1"
				two
					name = "two"
					icon_state = "2"
				three
					name = "three"
					icon_state = "3"
				four
					name = "four"
					icon_state = "4"
				five
					name = "five"
					icon_state = "5"
				six
					name = "six"
					icon_state = "6"
				seven
					name = "seven"
					icon_state = "7"
				eight
					name = "eight"
					icon_state = "8"
				nine
					name = "nine"
					icon_state = "9"
				zero
					name = "zero"
					icon_state = "0"


		chsl
			name = "CLEAN HANDS SAVE LIVES"
			desc = "A poster that reads 'CLEAN HANDS SAVE LIVES'."
			icon_state = "chsl"

		chsc
			name = "CLEAN HANDS SAVE CASH"
			desc = "A poster that reads 'CLEAN HANDS SAVE CASH: Today's unwashed palm is tomorrow's class action suit!'."
			icon_state = "chsc"

		danger_highvolt
			name = "Danger: High Voltage"
			icon_state = "shock"

		medbay
			name = "Medical Bay"
			icon_state = "wall_sign_medbay"

		space
			name = "VACUUM AREA"
			desc = "A warning sign which reads 'EXTERNAL AIRLOCK'."
			icon_state = "space"

		construction
			name = "CONSTRUCTION AREA"
			desc = "A warning sign which reads 'CONSTRUCTION AREA'."
			icon_state = "wall_sign_danger"

		pool
			name = "Pool"
			icon_state = "pool"

		fire
			name = "FIRE HAZARD"
			desc = "A warning sign which reads 'FIRE HAZARD'."
			icon_state = "wall_sign_fire"

		biohazard
			name = "BIOHAZARD"
			desc = "A warning sign which reads 'BIOHAZARD'."
			icon_state = "bio"

		gym
			name = "Barkley Ballin' Gym"
			icon_state = "gym"

		barber
			name = "The Snip"
			icon = 'icons/obj/barber_shop.dmi'
			icon_state = "thesnip"

		bar
			name = "Bar"
			icon = 'icons/obj/stationobjs.dmi'
			icon_state = "barsign"

		magnet
			name = "ACTIVE MAGNET AREA"
			desc = "A warning sign. I guess this area is dangerous."
			icon_state = "wall_sign_mag"

		cdnp
			name = "CRIME DOES NOT PAY"
			desc = "A warning sign which suggests that you reconsider your poor life choices."
			icon_state = "crime"

		dont_panic
			name = "DON'T PANIC"
			desc = "A sign which suggests that you remain calm, as everything is surely just fine."
			icon_state = "centcomfail"
			New()
				..()
				icon_state = pick("centcomfail", "centcomfail2")

		fudad
			name = "Arthur Muggins Memorial Jazz Lounge"
			desc = "In memory of Arthur \"F. U. Dad\" Muggins, the bravest, toughest Vice Cop SS13 has ever known. Loved by all. R.I.P."
			icon_state = "rip"

		escape
			name = "ESCAPE"
			desc = "Follow this to find Escape! Or fire. Or death. One of those."
			icon_state = "wall_escape"

		escape_left
			name = "ESCAPE"
			desc = "Follow this to find Escape! Or fire. Or death. One of those."
			icon_state = "wall_escape_arrow_l"

		escape_right
			name = "ESCAPE"
			desc = "Follow this to find Escape! Or fire. Or death. One of those."
			icon_state = "wall_escape_arrow_r"

		medbay_text
			name = "MEDICAL BAY"
			desc = "Follow this to find Medbay! Or fire. Or death. One of those."
			icon_state = "wall_medbay"

		medbay_left
			name = "MEDICAL BAY"
			desc = "Follow this to find Medbay! Or fire. Or death. One of those."
			icon_state = "wall_medbay_arrow_l"

		medbay_right
			name = "MEDICAL BAY"
			desc = "Follow this to find Medbay! Or fire. Or death. One of those."
			icon_state = "wall_medbay_arrow_r"

		hazard_stripe
			name = "hazard stripe"
			desc = ""
			icon_state = "stripe"

		hazard_caution
			name = "CAUTION"
			icon_state = "wall_caution"

		hazard_danger
			name = "DANGER"
			icon_state = "wall_danger"

		hazard_bio
			name = "BIOHAZARD"
			icon_state = "wall_biohazard"

		hazard_rad
			name = "RADIATION"
			icon_state = "wall_radiation"

		hazard_exheat
			name = "EXTREME HEAT"
			icon_state = "wall_extremeheat"

		hazard_electrical
			name = "ELECTRICAL HAZARD"
			icon_state = "wall_electricalhazard"

		hazard_hotloop
			name = "HOT LOOP"
			icon_state = "wall_hotloop"

		hazard_coldloop
			name = "COLD LOOP"
			icon_state = "wall_coldloop"

		poster_hair
			name = "Fabulous Hair!"
			desc = "There's a bunch of ladies with really fancy hair pictured on this."
			icon_state = "wall_poster_hair"

		poster_cool
			name = "cool poster"
			desc = "There's a couple people pictured on this poster, looking pretty cool."
			icon_state = "wall_poster_cool3"
			random_icon_states = list("wall_poster_cool", "wall_poster_cool2", "wall_poster_cool3")

		poster_human
			name = "poster"
			desc = "There's a person pictured on this poster. Some sort of celebrity."
			icon_state = "wall_poster_human"
			//todo: implement procedural celebrities

		poster_borg
			name = "poster"
			desc = "There's a cyborg pictured on this poster, but you aren't really sure what the message is. Is it trying to advertise something?"
			icon_state = "wall_poster_borg"

		poster_sol
			name = "poster"
			desc = "There's a star and the word 'SOL' pictured on this poster."
			icon_state = "wall_poster_sol"

		poster_clown
			name = "poster"
			desc = "There's a clown pictured on this poster."
			icon_state = "wall_poster_clown"

		poster_nt
			name = "\improper NanoTrasen poster"
			desc = "A cheerful-looking version of the NT corporate logo."
			icon_state = "wall_poster_nt"

		poster_ptoe
			name = "periodic table of elements"
			desc = "A chart listing all known chemical elements."
			icon_state = "ptoe"

		poster_y4nt
			name = "\improper NanoTrasen poster"
			desc = "A huge poster that reads 'I want YOU for NT!'"
			icon_state = "you_4_nt"

		poster_rand
			name = "poster"
			desc = "You aren't really sure what the message is. Is it trying to advertise something?"
			icon_state = "wall_poster_cool3"
			pixel_var = 1
			random_icon_states = list("wall_poster_cool", "wall_poster_cool2", "wall_poster_cool3", "wall_poster_hair", "wall_poster_human", "wall_poster_borg", "wall_poster_sol", "wall_poster_clown")

////////////////
// CLEANABLES //
////////////////

/obj/decal/cleanable
	density = 0
	anchored = 1
	var/can_sample = 0
	var/sampled = 0
	var/sample_amt = 10
	var/sample_reagent = "water"
	var/sample_verb = "scoop"
	var/list/diseases = list()
	var/slippery = 0 // set it to the probability that you want people to slip in the stuff, ie urine's slippery is 80 so you have an 80% chance to slip on it
	var/slipped_in_blood = 0 // self explanitory hopefully
	var/can_dry = 0
	var/dry = 0 // if it's slippery to start, is it dry now?

	flags = NOSPLASH
	layer = DECAL_LAYER

	New(var/loc,var/list/viral_list)
		src.real_name = src.name
		if (viral_list && viral_list.len > 0)
			for (var/datum/ailment_data/AD in viral_list)
				src.diseases += AD
		if (src.can_dry)
			src.Dry()
		..()
		var/area/Ar = get_area(src)
		if (Ar)
			Ar.sims_score = max(Ar.sims_score - 6, 0)

	HasEntered(AM as mob|obj)
		..()
		if (!src.slippery || src.dry)
			return
		if (istype(src, /obj/decal/cleanable/blood/dynamic))
			var/obj/decal/cleanable/blood/dynamic/D = src
			if (D.blood_volume <= 2)
				return
		if (istype(src.loc, /turf/space))
			return
		if (iscarbon(AM))
			var/mob/M =	AM
			if (!M.can_slip())
				return
			if (prob(src.slippery))
				M.pulling = null
				M.visible_message("<span style=\"color:red\"><b>[M]</b> slips on [src]!</span>",\
				"<span style=\"color:red\">You slip on [src]!</span>")
				playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
				M.stunned = 2
				M.weakened = 2
				if (src.slipped_in_blood)
					M.add_blood()

	attackby(obj/item/W, mob/user)
		if (src.can_sample && W.is_open_container() && W.reagents)
			src.Sample(W, user)
		else
			return ..()

	proc/Dry(var/time = rand(600,1000))
		if (!src.can_dry || src.dry)
			return 0
		spawn(time)
			qdel(src)
			return 1

	proc/Sample(var/obj/item/W as obj, var/mob/user as mob)
		if (!src.can_sample || !W.reagents)
			return 0
		if (src.sampled)
			user.show_text("There's not enough left of [src] to [src.sample_verb] into [W].", "red")
			return 0

		if (src.reagents)
			if (W.reagents.total_volume >= W.reagents.maximum_volume - (src.reagents.total_volume - 1))
				user.show_text("[W] is too full!", "red")
				return 0
			else
				if (src.reagents.total_volume)
					src.reagents.trans_to(W, src.reagents.total_volume)
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> [src.sample_verb]s some of [src] into [W].</span>",\
				"<span style=\"color:blue\">You [src.sample_verb] some of [src] into [W].</span>")
				W.reagents.handle_reactions()
				src.sampled = 1
				return 1

		else if (src.sample_amt && src.sample_reagent)
			if (W.reagents.total_volume >= W.reagents.maximum_volume - (src.sample_amt - 1))
				user.show_text("[W] is too full!", "red")
				return 0
			else
				W.reagents.add_reagent(src.sample_reagent, src.sample_amt)
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> [src.sample_verb]s some of [src] into [W].</span>",\
				"<span style=\"color:blue\">You [src.sample_verb] some of [src] into [W].</span>")
				W.reagents.handle_reactions()
				src.sampled = 1
				return 1

	dispose()
		..()
		var/area/Ar = get_area(src)
		if (Ar)
			Ar.sims_score = min(Ar.sims_score + 6, 100)

/obj/decal/cleanable/blood
	name = "blood"
	desc = "It's red."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	var/ling_blood = 0
	var/blood_volume = 0
	color = DEFAULT_BLOOD_COLOR
	slippery = 10
	slipped_in_blood = 1
	can_sample = 1
	sample_reagent = "blood"
	can_dry = 1

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(10) // 9u is the max since we wanna leave at least 1u of blood in the blood puddle
		reagents = R
		R.my_atom = src
		if (ling_blood)
			src.reagents.add_reagent("bloodc", 10)
			src.sample_reagent = "bloodc"
		else
			src.reagents.add_reagent("blood", 10)

	Dry(var/time = rand(200,500))
		if (!src.can_dry || src.dry)
			return 0
		spawn(time)
			src.dry = 1
			src.name = "dried [src.real_name]"
			src.desc = "It's all flakey and dry now."
			return 1

	disposing()
		diseases = list()
		var/obj/decal/bloodtrace/B = new /obj/decal/bloodtrace(src.loc)
		if(B.blood_DNA)
			B.blood_DNA = src.blood_DNA
		if(B.blood_type)
			B.blood_type = src.blood_type
		..()

/*
/obj/decal/cleanable/blood/burn(fi_amount)
	if(fi_amount > 900000.0)
		src.virus = null
	sleep(11)
	qdel(src)
	return
*/

/obj/decal/cleanable/blood/dynamic
	desc = "It's blood."
	icon_state = "blank" // if you make any more giant white cumblobs all over my nice blood decals
	random_icon_states = null // I swear to god I will fucking end you
	var/low_icon_states = list("drip1a", "drip1b", "drip1c", "drip1d", "drip1e", "drip1f") // these'll change eventually, for now they're good enough
	var/med_icon_states = list("drip2a", "drip2b", "drip2c", "drip2d", "drip2e", "drip2f")
	var/high_icon_states = list("drip3a", "drip3b", "drip3c", "drip3d", "drip3e", "drip3f")
	var/max_icon_states = list("drip4a", "drip4b", "drip4c", "drip4d", "drip5a", "drip5b", "drip5c", "drip5d")
	var/violent_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")
	blood_volume = 0
	color = "#FFFFFF"

	proc/add_volume(var/add_color, var/amount = 1)
	// add_color passes the blood's color to the overlays
	// amount should only be 1-5 if you want anything to happen
		src.blood_volume ++
		if (src.reagents.maximum_volume < 100)
			src.reagents.maximum_volume += 10
		if (src.blood_volume >= 10)
			return
		switch (amount)
			if (-INFINITY to 0)
				return
			if (1)
				create_overlay(src.low_icon_states, add_color)
			if (2)
				create_overlay(src.med_icon_states, add_color)
			if (3)
				create_overlay(src.high_icon_states, add_color)
			if (4)
				create_overlay(src.max_icon_states, add_color)
			if (5)
				create_overlay(src.violent_icon_states, add_color) // for when you wanna create a BIG MESS
			if (6 to INFINITY)
				return

	proc/create_overlay(var/icons_to_choose, var/add_color)
		if (icons_to_choose && length(icons_to_choose) > 0)
			var/blood_addition = pick(icons_to_choose)
			var/image/blood_overlay = image('icons/effects/blood.dmi', blood_addition)
			blood_overlay.transform = turn(blood_overlay.transform, pick(0, 180)) // gets funky with 0,90,180,-90
			blood_overlay.pixel_x += rand(-4,4)
			blood_overlay.pixel_y += rand(-4,4)
			if (add_color)
				blood_overlay.color = add_color
			src.overlays += blood_overlay

/obj/decal/cleanable/blood/drip
	New()
		..()
		src.pixel_y += rand(0,16)

/obj/decal/cleanable/blood/drip/low
	random_icon_states = list("drip1a", "drip1b", "drip1c", "drip1d", "drip1e", "drip1f")
/obj/decal/cleanable/blood/drip/med
	random_icon_states = list("drip2a", "drip2b", "drip2c", "drip2d", "drip2e", "drip2f")
/obj/decal/cleanable/blood/drip/high
	random_icon_states = list("drip3a", "drip3b", "drip3c", "drip3d", "drip3e", "drip3f")

/obj/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/decal/cleanable/blood/tracks
	icon_state = "tracks"
	random_icon_states = null
	color = "#FFFFFF"

/obj/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "Grisly..."
	anchored = 0
	layer = OBJ_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	color = "#FFFFFF"
	slippery = 5
	can_dry = 0

	attack_hand(var/mob/user as mob)
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if (H.job == "Chef")
				user.visible_message("<span style=\"color:blue\"><b>[H]</b> starts rifling through [src] with their hands. What a weirdo.</span>",\
				"<span style=\"color:blue\">You rake through the gibs with your bare hands.</span>")
				playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
				if (H.gloves)
					H.gloves.blood_DNA = src.blood_DNA
				else
					H.blood_DNA = src.blood_DNA
				if (src.sampled)
					H.show_text("You didn't find anything useful. Now your hands are all bloody for nothing!", "red")
				else
					H.show_text("You find some... salvageable... meat.. you guess?", "blue")
					H.unlock_medal("Sheesh!", 1)
					new /obj/item/reagent_containers/food/snacks/ingredient/meat/mysterymeat(src.loc)
					src.sampled = 1
			else
				return ..()
		else
			return ..()

	proc/streak(var/list/directions)
		spawn (0)
			var/direction = pick(directions)
			for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
				sleep(3)
				if (i > 0)
					var/obj/decal/cleanable/blood/b = new /obj/decal/cleanable/blood/splatter(src.loc)
					if (src.diseases)
						b.diseases += src.diseases
					if (src.blood_DNA && src.blood_type) // For forensics (Convair880).
						b.blood_DNA = src.blood_DNA
						b.blood_type = src.blood_type
				if (step_to(src, get_step(src, direction), 0))
					break

/obj/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/decal/cleanable/glitter //WE'RE TRYING THIS NOW
	name = "glitter"
	desc = "You can try to clean it up, but there'll always be a little bit left."
	icon = 'icons/effects/glitter.dmi'
	icon_state = "glitter"
	random_dir = 4
	random_icon_states = list("glitter-1", "glitter-2", "glitter-3", "glitter-4", "glitter-5", "glitter-6", "glitter-7", "glitter-8", "glitter-9", "glitter-10")
	can_sample = 1
	sample_reagent = "glitter"
	sample_verb = "scrape"

/obj/decal/cleanable/paper
	name = "paper"
	desc = "Ripped up little flecks of paper."
	icon = 'icons/obj/decals.dmi'
	icon_state = "paper"
	random_dir = 4
	can_sample = 1
	sample_reagent = "paper"
	sample_verb = "scrape"

	New()
		..()
		pixel_y += rand(-4,4)
		pixel_x += rand(-4,4)
		return

/obj/decal/cleanable/rust
	name = "rust"
	desc = "That sure looks safe."
	icon = 'icons/obj/decals.dmi'
	icon_state = "rust1"
	random_icon_states = list("rust1", "rust2", "rust3","rust4","rust5")
	can_sample = 1
	sample_reagent = "iron"
	sample_verb = "scrape"

/obj/decal/cleanable/balloon
	name = "balloon"
	desc = "The remains of a balloon."
	icon = 'icons/obj/balloon.dmi'
	icon_state = "balloon_white_pop"

/obj/decal/cleanable/writing
	name = "writing"
	desc = "Someone's scribbled something here."
	layer = TURF_LAYER + 1
	icon = 'icons/obj/writing.dmi'
	icon_state = "writing1"
	color = "#000000"
	random_icon_states = list("writing1", "writing2", "writing3", "writing4", "writing5", "writing6", "writing7")
	var/words = "Nothing."
	var/font = null
	var/webfont = 0
	var/font_color = "#000000"

	get_desc(dist)
		. = "<br><span style='color: blue'>It says:</span><br><span style='color: [src.font_color]'>[words]</span>"
		//. = "[src.webfont ? "<link href='http://fonts.googleapis.com/css?family=[src.font]' rel='stylesheet' type='text/css'>" : null]<span style='color: blue'>It says:</span><br><span style='[src.font ? "font-family: [src.font][src.webfont ? ", cursive" : null];" : null]color: [src.font_color]'>[words]</span>"

/obj/decal/cleanable/writing/infrared
	name = "infrared writing"
	desc = "Someone's scribbled something here, with infrared ink. Ain't that spiffy?"
	icon_state = "IRwriting1"
	color = "#D20040"
	random_icon_states = list("IRwriting1", "IRwriting2", "IRwriting3", "IRwriting4", "IRwriting5", "IRwriting6", "IRwriting7")
	infra_luminosity = 4
	invisibility = 1
	font_color = "#D20040"

/obj/decal/cleanable/writing/postit
	name = "sticky note"
	desc = "Someone's stuck a little note here."
	icon_state = "postit"
	random_icon_states = list()
	layer = EFFECTS_LAYER_BASE - 1
	color = null
	words = ""
	var/max_message = 128

	New()
		..()
		pixel_y += rand(-12,12)
		pixel_x += rand(-12,12)

	attackby(obj/item/W as obj, mob/living/user as mob)
		if (istype(W, /obj/item/pen))
			var/obj/item/pen/pen = W
			pen.in_use = 1
			var/t = input(user, "What do you want to write?", null, null) as null|text
			if (!t)
				pen.in_use = 0
				return
			if ((length(src.words) + length(t)) > src.max_message)
				user.show_text("All that won't fit on [src]!", "red")
				pen.in_use = 0
				return
			logTheThing("station", user, null, "writes on [src] with [pen] at [showCoords(src.x, src.y, src.z)]: [t]")
			t = copytext(html_encode(t), 1, MAX_MESSAGE_LEN)
			if (pen.font_color)
				src.color = pen.font_color
			if (pen.uses_handwriting && user && user.mind && user.mind.handwriting)
				src.font = user.mind.handwriting
				src.webfont = 1
			else if (pen.font)
				src.font = pen.font
				if (pen.webfont)
					src.webfont = 1
			if (src.words)
				src.words += "<br>"
			var/search_t = lowertext(t)
			if (copytext(search_t, 1, 4) == "no ")
				src.icon_state = "postit-no"
			else if (copytext(search_t, -1) == "?")
				src.icon_state = "postit-quest"
			else if (copytext(search_t, -1) == "!")
				src.icon_state = "postit-excl"
			else if (findtext(search_t, " wrong "))
				src.icon_state = "postit-x"
			else
				src.icon_state = "postit-writing"
			src.words += "[t]"
			pen.in_use = 0
		else
			return ..()

/obj/decal/cleanable/water
	name = "water"
	desc = "Water, on the floor. Amazing!"
	icon = 'icons/effects/water.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3")
	can_dry = 1
	slippery = 90
	can_sample = 1
	sample_reagent = "water"

	Crossed(atom/movable/O)
		if (istype(O, /obj/item/clothing/under/towel))
			var/obj/item/clothing/under/towel/T = O
			T.dry_turf(get_turf(src))
			return
		else
			return ..()

/obj/decal/cleanable/urine
	name = "urine"
	desc = "It's yellow, and it smells."
	icon = 'icons/effects/urine.dmi'
	icon_state = "floor1"
	blood_DNA = null
	blood_type = null
	random_icon_states = list("floor1", "floor2", "floor3")
	var/thrice_drunk = 0
	can_dry = 1
	slippery = 80
	can_sample = 1

	Crossed(atom/movable/O)
		if (istype(O, /obj/item/clothing/under/towel))
			var/obj/item/clothing/under/towel/T = O
			T.dry_turf(get_turf(src))
			return
		else
			return ..()

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		if (!src.can_sample)
			return 0

		if (W.is_open_container() && W.reagents)
			if (W.reagents.total_volume >= W.reagents.maximum_volume - 2)
				user.show_text("[W] is too full!", "red")
				return

			else
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> is splashing the urine puddle into \the [W]. How singular.</span>",\
				"<span style=\"color:blue\">You splash a little urine into \the [W].</span>")

				switch (thrice_drunk)
					if (0)
						W.reagents.add_reagent("urine", 1)
					if (1)
						W.reagents.add_reagent("urine", 1)
						W.reagents.add_reagent("toeoffrog", 1)
					if (2)
						W.reagents.add_reagent("urine", 1)
						W.reagents.add_reagent("woolofbat", 1)
					if (3)
						W.reagents.add_reagent("urine", 1)
						W.reagents.add_reagent("tongueofdog", 1)
					if (4)
						W.reagents.add_reagent("triplepiss",1)

				if (prob(20))
					qdel(src)

				W.reagents.handle_reactions()
				return 1

/obj/decal/cleanable/vomit
	name = "pool of vomit"
	desc = "Someone lost their lunch."
	icon = 'icons/effects/vomit.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3")
	slippery = 30
	can_dry = 1
	can_sample = 1
	sample_amt = 5
	sample_reagent = "vomit"
	sample_verb = "scrape"

	Dry(var/time = rand(200,500))
		if (!src.can_dry || src.dry)
			return 0
		spawn(time)
			src.dry = 1
			src.name = "dried [src.real_name]"
			src.desc = "It's all gummy. Ew."

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		if (!src.can_sample || !W.reagents)
			return 0
		if (src.sampled)
			user.show_text("There's not enough left of [src] to [src.sample_verb] into [W].", "red")
			return 0

		if (src.sample_amt && src.sample_reagent)
			if (W.reagents.total_volume >= W.reagents.maximum_volume - (src.sample_amt - 1))
				user.show_text("[W] is too full!", "red")
				return 0
			else
				W.reagents.add_reagent(src.sample_reagent, src.sample_amt)
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> is sticking their fingers into [src] and pushing it into [W]. It's probably best not to ask.</span>",\
				"<span style=\"color:blue\">You [src.sample_verb] some of the puke into [W]. You are absolutely disgusting.</span>")
				W.reagents.handle_reactions()
				playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
				src.sampled = 1
				return 1

/obj/decal/cleanable/vomit/spiders
	desc = "Someone lost their lunch. Oh god their lunch was spiders?!"
	random_icon_states = list("spiders1", "spiders2", "spiders3")

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		if (!src.can_sample || !W.reagents)
			return 0
		if (src.sampled)
			user.show_text("There's not enough left of [src] to [src.sample_verb] into [W].", "red")
			return 0

		if (W.reagents.total_volume >= W.reagents.maximum_volume - (src.sample_amt - 1))
			user.show_text("[W] is too full!", "red")
			return 0
		else
			W.reagents.add_reagent("vomit", 2)
			W.reagents.add_reagent("black_goop", 2)
			W.reagents.add_reagent("spiders", 1)

			var/fluff = pick("twitches", "wriggles", "wiggles", "skitters")
			var/fluff2
			if (prob(10))
				fluff2 = ""
			else // I only code good & worthwhile things  :D
				var/swear1 = pick("Oh", "Holy[pick("", " fucking")]", "Fucking", "Goddamn[pick("", " fucking")]", "Mother of[pick("", " fucking")]", "Jesus[pick("", " fucking")]")
				var/swear2 = pick("shit", "fuck", "hell", "heck", "hellfarts", "piss")
				var/that_is = " that is the [pick("worst", "most vile", "most utterly horrendous", "grodiest", "most horrific")] thing you've seen[pick(" in your entire life", " this week", " today", "", "!")]"
				fluff2 = " [swear1] [swear2][prob(50) ? "[that_is]" : null][pick(".", "!", "!!")]"

			user.visible_message("<span style=\"color:blue\"><b>[user]</b> is sticking their fingers into [src] and pushing it into [W].<span style=\"color:red\">It [fluff] a bit.[fluff2]</span></span>",\
			"<span style=\"color:blue\">You [src.sample_verb] some of the puke into [W].<span style=\"color:red\">It [fluff] a bit.[fluff2]</span></span>")
			W.reagents.handle_reactions()
			playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
			src.sampled = 1
			return 1

/obj/decal/cleanable/greenpuke
	name = "green vomit"
	desc = "That's just wrong."
	density = 0
	anchored = 1
	icon = 'icons/effects/vomit.dmi'
	icon_state = "green1"
	var/dried = 0
	random_icon_states = list("green1", "green2", "green3")
	can_dry = 1
	slippery = 35
	can_sample = 1
	sample_amt = 5
	sample_reagent = "gvomit"
	sample_verb = "scrape"

	Dry(var/time = rand(200,500))
		if (!src.can_dry)
			return 0
		spawn(time)
			src.dry = 1
			src.name = "dried [src.real_name]"
			src.desc = "It's all gummy. Ew."


	Sample(var/obj/item/W as obj, var/mob/user as mob)
		if (!src.can_sample || !W.reagents)
			return 0
		if (src.sampled)
			user.show_text("There's not enough left of [src] to [src.sample_verb] into [W].", "red")
			return 0

		if (src.sample_amt && src.sample_reagent)
			if (W.reagents.total_volume >= W.reagents.maximum_volume - (src.sample_amt - 1))
				user.show_text("[W] is too full!", "red")
				return 0
			else
				W.reagents.add_reagent(src.sample_reagent, src.sample_amt)
				user.show_text("You scoop some of the sticky, slimy, stringy green puke into [W]. You are absolutely horrifying.", "blue")
				for (var/mob/O in AIviewers(user, null))
					if (O != user)
						O.show_message("<span style=\"color:blue\"><b>[user]</b> is sticking their fingers into [src] and pushing it into [W]. It's all slimy and stringy. Oh god.</span>", 1)
						if (prob(33) && ishuman(O))
							O.show_message("<span style=\"color:red\">You feel ill from watching that.</span>")
							for (var/mob/V in viewers(O, null))
								V.show_message("<span style=\"color:red\">[O] pukes all over \himself. Thanks, [user].</span>", 1)
								playsound(O.loc, "sound/effects/splat.ogg", 50, 1)
								new /obj/decal/cleanable/vomit(O.loc)

				W.reagents.handle_reactions()
				playsound(src.loc, "sound/effects/splat.ogg", 50, 1)
				src.sampled = 1
				return 1

/obj/decal/cleanable/tomatosplat
	name = "ruined tomato"
	desc = "Gallows humour."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	color = "#FF0000"
	slippery = 10
	can_sample = 1
	sample_reagent = "juice_tomato"

/obj/decal/cleanable/eggsplat
	name = "smashed egg"
	desc = "Chickens will be none too pleased about this."
	icon = 'icons/effects/water.dmi'
	icon_state = "egg1"
	random_icon_states = list("egg1", "egg2", "egg3")
	slippery = 5
	can_sample = 1
	sample_amt = 5
	sample_reagent = "egg"

/obj/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	can_sample = 1
	sample_reagent = "ash"
	sample_verb = "scrape"

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		..()
		qdel(src)

	attack_hand(mob/user as mob)
		user.show_text("The ashes slip through your fingers.", "blue")
		dispose()
		return

/obj/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	layer = TURF_LAYER
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	icon = 'icons/obj/decals.dmi'
	icon_state = "dirt"
	random_dir = 1

/obj/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Someone should remove that."
	layer = MOB_LAYER+1
	icon = 'icons/obj/decals.dmi'
	icon_state = "cobweb1"

/obj/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "huh."
	layer = OBJ_LAYER
	icon = 'icons/obj/chemical.dmi'
	icon_state = "molten"

/obj/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Someone should remove that."
	layer = MOB_LAYER+1
	icon = 'icons/obj/decals.dmi'
	icon_state = "cobweb2"

/obj/decal/cleanable/fungus
	name = "space fungus"
	desc = "A fungal growth. Looks pretty nasty."
	icon = 'icons/obj/decals.dmi'
	icon_state = "fungus1"
	var/amount = 1
	can_sample = 1
	sample_reagent = "space_fungus"
	sample_verb = "scrape"

	New()
		if (prob(5))
			src.amount += rand(1,2)
			src.update_icon()
		..()
		return

	proc/update_icon()
		src.icon_state = "fungus[max(1,min(3, amount))]"

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		if (!src.can_sample || !W.reagents)
			return 0

		else if (src.sample_amt && src.sample_reagent)
			if (W.reagents.total_volume >= W.reagents.maximum_volume - (src.sample_amt - 1))
				user.show_text("[W] is too full!", "red")
				return 0
			else
				W.reagents.add_reagent(src.sample_reagent, src.sample_amt)
				user.visible_message("<span style=\"color:blue\"><b>[user]</b> [src.sample_verb]s some of [src] into [W].</span>",\
				"<span style=\"color:blue\">You [src.sample_verb] some of [src] into [W].</span>")
				W.reagents.handle_reactions()
				playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
				src.amount--
				if (src.amount <= 0)
					qdel(src)
				src.update_icon()
				return 1

/obj/decal/cleanable/machine_debris
	name = "twisted shrapnel"
	desc = "A chunk of broken and melted scrap metal."
	anchored = 0
	layer = OBJ_LAYER
	icon = 'icons/mob/robots.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")

	proc/streak(var/list/directions)
		spawn (0)
			var/direction = pick(directions)
			for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
				sleep(3)
				if (i > 0)
					if (prob(10))
						var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
						s.set_up(3, 1, src)
						s.start()
				if (step_to(src, get_step(src, direction), 0))
					break

/obj/decal/cleanable/robot_debris
	name = "robot debris"
	desc = "Useless heap of junk."
	anchored = 0
	layer = OBJ_LAYER
	icon = 'icons/mob/robots.dmi'
	icon_state = "gib1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")

	proc/streak(var/list/directions)
		spawn (0)
			var/direction = pick(directions)
			for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
				sleep(3)
				if (i > 0)
					if (prob(40))
						/*var/obj/decal/cleanable/oil/o =*/
						new /obj/decal/cleanable/oil/streak(src.loc)
					else if (prob(10))
						var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
						s.set_up(3, 1, src)
						s.start()
				if (step_to(src, get_step(src, direction), 0))
					break

/obj/decal/cleanable/robot_debris/limb
	random_icon_states = list("gibarm", "gibleg")

/obj/decal/cleanable/oil
	name = "motor oil"
	desc = "It's black."
	icon = 'icons/effects/oil.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	slippery = 70
	can_sample = 1
	sample_reagent = "oil"

/obj/decal/cleanable/oil/streak
	random_icon_states = list("streak1", "streak2", "streak3", "streak4", "streak5")

/obj/decal/cleanable/greenglow
	name = "green glow"
	desc = "Eerie."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(0.4)
		light.set_height(0.5)
		light.set_color(0.2, 1, 0.2)
		light.attach(src)
		light.enable()

		spawn(1200)		// 2 minutes
			qdel(src)

/obj/decal/cleanable/saltpile
	name = "salt pile"
	desc = "Bad luck, that."
	icon = 'icons/effects/salt.dmi'
	icon_state = "0"
	can_sample = 1
	sample_reagent = "salt"
	sample_verb = "scrape"

	New()
		..()
		src.updateIcon()
		updateSurroundingSalt(get_turf(src))


	HasEntered(AM as mob|obj)
		..()

		if(!(isliving(AM) || isobj(AM) || isintangible(AM))) return
		var/mob/M = AM
		var/oopschance = 5
		if(ismob(AM))
			if (M.m_intent != "walk") // walk, don't run
				oopschance += 28
			if (prob(oopschance))
				M.visible_message("<span style=\"color:red\">[M.name] accidentally scuffs a foot across the [src], scattering it everywhere! [pick("Fuck!", "Shit!", "Damnit!", "Welp.")]</span>")
				qdel(src)

	disposing()
		var/turf/T = get_turf(src)
		..()
		updateSurroundingSalt(T)

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		..()
		qdel(src)

	proc/updateIcon()
		var/dirs = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			var/obj/decal/cleanable/saltpile/S = T.getSaltHere()
			if (S)
				dirs |= dir
		icon_state = num2text(dirs)

/obj/decal/cleanable/magnesiumpile
	name = "magnesium pile"
	desc = "Uh-oh."
	icon = 'icons/effects/salt.dmi'
	icon_state = "0"
	can_sample = 1
	sample_reagent = "magnesium"
	sample_verb = "scrape"
	var/on_fire = null
	var/burn_time = 4

	New()
		..()
		src.updateIcon()
		updateSurroundingMagnesium(get_turf(src))

	disposing()
		var/turf/T = get_turf(src)
		..()
		updateSurroundingMagnesium(T)

	Sample(var/obj/item/W as obj, var/mob/user as mob)
		..()
		qdel(src)

	proc/updateIcon()
		var/dirs = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			var/obj/decal/cleanable/magnesiumpile/S = locate(/obj/decal/cleanable/magnesiumpile) in T
			if (S)
				dirs |= dir
		icon_state = num2text(dirs)

	proc/ignite()
		if (on_fire)
			return
		on_fire = image('icons/effects/fire.dmi', "2old")
		visible_message("<span style='color:red'>[src] ignites!</span>")
		src.overlays += on_fire
		spawn(0)
			var/turf/T = get_turf(src)
			while (burn_time > 0)
				if (loc == T && !disposed && on_fire)
					fireflash_sm(T, 0, T0C + 3100, 0, 1, 0)
					if (burn_time <= 2)
						for (var/D in cardinal)
							var/turf/Q = get_step(T, D)
							var/obj/decal/cleanable/magnesiumpile/M = locate() in Q
							if (M)
								M.ignite()
						if (src.loc && src.loc.reagents && src.loc.reagents.total_volume)
							for (var/i = 0, i < 10, i++)
								src.loc.reagents.temperature_reagents(T0C + 3100, 10)
						if (src.loc)
							for (var/obj/O in src.loc)
								if (O != src && O.reagents && O.reagents.total_volume)
									for (var/i = 0, i < 10, i++)
										O.reagents.temperature_reagents(T0C + 3100, 10)
					sleep(5)
				else
					return
				burn_time--
			qdel(src)

	reagent_act(id, volume)
		if (disposed)
			return
		if (id == "water")
			if (on_fire)
				if (volume >= 10)
					explosion_new(src, get_turf(src), 1)
					qdel(src)
				else
					overlays -= on_fire
					on_fire = null
					burn_time = initial(burn_time)
		else if (id == "ff-foam")
			if (on_fire)
				overlays -= on_fire
				on_fire = null
				burn_time = initial(burn_time)

	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if (exposed_temperature >= T0C + 473)
			ignite()
		..()

/turf/proc/getSaltHere()
	for (var/obj/decal/cleanable/saltpile/S in src.contents)
		return S

/proc/updateSurroundingSalt(var/turf/T)
	if (!istype(T)) return
	for (var/obj/decal/cleanable/saltpile/S in orange(1,T))
		S.updateIcon()

/proc/updateSurroundingMagnesium(var/turf/T)
	if (!istype(T)) return
	for (var/obj/decal/cleanable/magnesiumpile/S in orange(1,T))
		S.updateIcon()

/obj/decal/cleanable/nitrotriiodide
	name = "gooey mess"
	desc = "Someone should DEFINITELY clean that up"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nitrotri_wet"
	color = "#cb5e97"
	can_dry = 1

	HasEntered(AM as mob|obj)
		if( !src.dry || !(isliving(AM) || isobj(AM)) ) return
		src.bang()

	attackby(var/obj/item/W, var/mob/user)
		if (src.dry)
			src.bang()
			return
		return ..()

	attack_hand(var/mob/user)
		if (src.dry)
			src.bang()
		else
			boutput(user, "<span style=\"color:blue\">You poke the mess. It's slightly viscous and smells strange. [prob(25) ? pick("Ew.", "Grody.", "Weird.") : null]</span>")

	proc/bang()
		src.visible_message("<b>The dust emits a loud bang!</b>")
		if(prob(20))
			var/datum/effects/system/bad_smoke_spread/smoke = new /datum/effects/system/bad_smoke_spread()
			smoke.set_up(5, 0, src.loc, ,"#cb5e97")
			smoke.start()
		/*
		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(5, 1, src.loc)
		s.start()
		*/
		explosion(src, src.loc, -1, -1, -1, 1)
		qdel(src)

	Dry(var/time = 200 + 20 * rand(0,20))
		if (!src.can_dry || src.dry)
			return 0
		spawn(time)
			src.dry = 1
			name = "dusty powder"
			desc = "Janitor's clearly not doing his job properly, sigh."
			icon_state = "nitrotri_dry"
			if (prob(25)) //This emulates the effect of air randomly passing over the stuff
				spawn(10 * rand(11,1200)) //At least 11 seconds, at most 20 minutes
					src.bang()
			return 1

////////////
// OTHERS //
////////////

/obj/decal/skeleton
	name = "skeleton"
	desc = "The remains of a human."
	opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/effects/3dimension.dmi'
	icon_state = "skeleton_l"

/obj/decal/skeleton/cap
	name = "remains of the captain"
	desc = "The remains of the captain of this station ..."
	opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/effects/3dimension.dmi'
	icon_state = "skeleton_l"

/obj/decal/floatingtiles
	name = "floating tiles"
	desc = "These tiles are just floating around in the void."
	opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/effects/3dimension.dmi'
	icon_state = "floattiles1"

/obj/decal/implo
	name = "implosion"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "dimplo"
	layer = EFFECTS_LAYER_BASE
	opacity = 0
	anchored = 1
	pixel_y = -16
	pixel_x = -16
	mouse_opacity = 0
	New(var/atom/location)
		src.loc = location
		spawn(20) del(src)
		return ..(location)

/obj/decal/shockwave
	name = "shockwave"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "explocom"
	layer = EFFECTS_LAYER_BASE
	opacity = 0
	anchored = 1
	pixel_y = -16
	pixel_x = -16
	mouse_opacity = 0
	New(var/atom/location)
		src.loc = location
		spawn(20) del(src)
		return ..(location)

/obj/decal/point
	name = "point"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "arrow"
	layer = EFFECTS_LAYER_1
	anchored = 1

/obj/decal/jukebox
	name = "Old Jukebox"
	icon = 'icons/obj/decoration.dmi'
	icon_state = "jukebox"
	desc = "This doesn't seem to be working anymore."
	layer = OBJ_LAYER
	anchored = 1
	density = 1

/obj/decal/pole
	name = "Barber Pole"
	icon = 'icons/obj/decoration.dmi'
	icon_state = "pole"
	anchored = 1
	density = 0
	desc = "Barber poles historically were signage used to convey that the barber would perform services such as blood letting and other medical procedures, with the red representing blood, and the white representing the bandaging. In America, long after the time when blood-letting was offered, a third colour was added to bring it in line with the colours of their national flag. This one is in space."
	layer = OBJ_LAYER

/obj/decal/oven
	name = "Oven"
	desc = "An old oven."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "oven_off"
	anchored = 1
	density = 1
	layer = OBJ_LAYER

/obj/decal/sink
	name = "Sink"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "sink"
	desc = "The sink doesn't appear to be connected to a waterline."
	anchored = 1
	density = 1
	layer = OBJ_LAYER

obj/decal/fakeobjects
	layer = OBJ_LAYER

obj/decal/fakeobjects/cargopad
	name = "Cargo Pad"
	desc = "Used to recieve objects transported by a Cargo Transporter."
	icon = 'icons/obj/objects.dmi'
	icon_state = "cargopad"
	anchored = 1

/obj/decal/fakeobjects/robot
	name = "Inactive Robot"
	desc = "The robot looks to be in good condition."
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"

/obj/decal/fakeobjects/apc_broken
	name = "broken APC"
	desc = "A smashed local power unit."
	icon = 'icons/obj/power.dmi'
	icon_state = "apc-b"
	anchored = 1

obj/decal/fakeobjects/teleport_pad
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pad0"
	name = "teleport pad"
	anchored = 1
	layer = FLOOR_EQUIP_LAYER1
	desc = "A pad used for scientific teleportation."

/obj/decal/fakeobjects/firealarm_broken
	name = "broken fire alarm"
	desc = "This fire alarm is burnt out, ironically."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "firex"
	anchored = 1

/obj/decal/fakeobjects/firelock_broken
	name = "rusted firelock"
	desc = "Rust has rendered this firelock useless."
	icon = 'icons/obj/doors/door_fire2.dmi'
	icon_state = "door0"
	anchored = 1

/obj/decal/fakeobjects/lighttube_broken
	name = "shattered light tube"
	desc = "Something has broken this light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-broken"
	anchored = 1

/obj/decal/fakeobjects/lightbulb_broken
	name = "shattered light bulb"
	desc = "Something has broken this light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-broken"
	anchored = 1

/obj/decal/fakeobjects/airmonitor_broken
	name = "broken air monitor"
	desc = "Something has broken this air monitor."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarmx"
	anchored = 1

/obj/decal/fakeobjects/shuttlethruster
	name = "propulsion unit"
	desc = "A small impulse drive that moves the shuttle."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "propulsion"
	anchored = 1
	density = 1
	opacity = 0

/obj/decal/fakeobjects/pipe
	name = "rusted pipe"
	desc = "Good riddance."
	icon = 'icons/obj/atmospherics/pipes/regular_pipe.dmi'
	icon_state = "intact"
	anchored = 1

	heat
		icon = 'icons/obj/atmospherics/pipes/heat_pipe.dmi'

/obj/decal/fakeobjects/oldcanister
	name = "old gas canister"
	desc = "All the gas in it seems to be long gone."
	icon = 'icons/misc/evilreaverstation.dmi'
	icon_state = "old_oxy"
	anchored = 0
	density = 1


	plasma
		name = "old plasma canister"
		icon_state = "old_plasma"
		desc = "This used to be the most feared piece of equipment on the station, don't you believe it?"

/obj/decal/fakeobjects/shuttleengine
	name = "engine unit"
	desc = "A generator unit that uses complex technology."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "heater"
	anchored = 1
	density = 1
	opacity = 0

/obj/decal/bloodtrace
	name = "blood trace"
	desc = "Oh my!!"
	icon = 'icons/effects/blood.dmi'
	icon_state = "lum"
	invisibility = 101
	blood_DNA = null
	blood_type = null

/obj/decal/boxingrope
	name = "Boxing Ropes"
	desc = "Do not exit the ring."
	density = 1
	anchored = 1
	icon = 'icons/obj/decoration.dmi'
	icon_state = "ringrope"
	layer = OBJ_LAYER

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0) // stolen from window.dm
		if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST || src.dir == SOUTH || src.dir == NORTH)
			return 0
		if(get_dir(loc, target) == dir)

			return !density
		else
			return 1

	CheckExit(atom/movable/O as mob|obj, target as turf)
		if (!src.density)
			return 1
		if (get_dir(O.loc, target) == src.dir)
			return 0
		return 1

/obj/decal/boxingropeenter
	name = "Ring entrance"
	desc = "Do not exit the ring."
	density = 0
	anchored = 1
	icon = 'icons/obj/decoration.dmi'
	icon_state = "ringrope"
	layer = OBJ_LAYER

/obj/decal/tile_edge
	name = "edge"
	mouse_opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/obj/decals.dmi'
	icon_state = "tile_edge"
	layer = TURF_LAYER + 0.1 // it should basically be part of a turf
	var/merge_with_turf = 1

	New()
		if (src.merge_with_turf)
			var/turf/T = get_turf(src)
			if (!T)
				return ..()
			var/image/I = image(src.icon, T, src.icon_state, src.layer, src.dir)
			if (src.color)
				I.color = src.color
			if (T.UpdateOverlays(I, "tile_edge\ref[src]"))
				qdel(src)
			else
				return ..()
		else
			return ..()

	Move()
		return 0

/obj/decal/tile_edge/stripe
	name = "hazard stripe"
	icon = 'icons/obj/hazard_stripes.dmi'
	icon_state = "stripe-edge"

/obj/decal/tile_edge/stripe/big
	icon_state = "bigstripe-edge"

/obj/decal/tile_edge/stripe/extra_big
	icon_state = "xtra_bigstripe-edge"

/obj/decal/tile_edge/line
	icon = 'icons/obj/line.dmi'
	icon_state = "linefull"

	white // the default white of these things is brighter than the white tiles, this color matches those
		color = "#E4E4E4"
	grey
		color = "#8D8C8C"
	black
		color = "#474646"

	red
		color = "#BC6B72"
	orange
		color = "#E7C88C"
	yellow
		color = "#BC9F6B"
	green
		color = "#90B672"
	blue
		color = "#6CA3BB"
	purple
		color = "#AB8CB0"

/obj/decal/stage_edge
	name = "stage"
	icon = 'icons/obj/decals.dmi'
	icon_state = "curtainthing"
	density = 1
	anchored = 1
	dir = NORTH

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if (istype(mover, /obj/projectile))
			return 1
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1

	CheckExit(atom/movable/O as mob|obj, target as turf)
		if (!src.density)
			return 1
		if (istype(O, /obj/projectile))
			return 1
		if (get_dir(O.loc, target) == src.dir)
			return 0
		return 1

/obj/decal/alienflower
	name = "strange alien flower"
	desc = "Is it going to eat you if you get too close?"
	icon = 'icons/obj/decals.dmi'
	icon_state = "alienflower"
	random_dir = 8

	New()
		..()
		src.dir = pick(alldirs)
		src.pixel_y += rand(-8,8)
		src.pixel_x += rand(-8,8)

/obj/decal/cleanable/alienvine
	name = "strange alien vine"
	icon = 'icons/obj/decals.dmi'
	icon_state = "avine_l1"
	random_icon_states = list("avine_l1", "avine_l2", "avine_l3")
	New()
		..()
		src.dir = pick(cardinal)
		if (prob(20))
			new /obj/decal/alienflower(src.loc)

/obj/decal/icefloor
	name = "ice"
	desc = "Slippery!"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "icefloor"
	density = 0
	opacity = 0
	anchored = 1

/obj/decal/icefloor/HasEntered(var/atom/movable/AM)
	if (iscarbon(AM))
		var/mob/M =	AM
		// drsingh fix for undefined variable mob/living/carbon/monkey/var/shoes
		if (!M.can_slip(0))
			return

		M.pulling = null
		boutput(M, "<span style=\"color:red\">You slipped on [src]!</span>")
		playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
		M.stunned = 2
		M.weakened = 1
		if (prob(5))
			M.TakeDamage("head", 5, 0, 0, DAMAGE_BLUNT)
			M.visible_message("<span style=\"color:red\"><b>[M]</b> hits their head on [src]!</span>")
			playsound(src.loc, "sound/weapons/genhit1.ogg", 50, 1)

/obj/decal/cleanable/gangtag
	name = "gang tag"
	desc = "A spraypainted gang tag."
	density = 0
	anchored = 1
	layer = OBJ_LAYER
	icon = 'icons/obj/decals.dmi'
	icon_state = "gangtag0"
	var/datum/gang/owners = null

	proc/delete_same_tags()
		for(var/obj/decal/cleanable/gangtag/T in get_turf(src))
			if(T.owners == src.owners && T != src) T.dispose()

/*	New()
		var/highlayer = 4
		for(var/obj/decal/cleanable/gangtag/T in get_turf(src))
			if(T.layer > highlayer) highlayer = T.layer
		src.layer = highlayer + 1*/

	disposing(var/uncapture = 1)
		var/area/tagarea = get_area(src)
		if(tagarea.gang_owners == src.owners && uncapture)
			tagarea.gang_owners = null
			var/turf/T = get_turf(src)
			T.tagged = 0
		..()

// These used to be static turfs derived from the standard grey floor tile and thus didn't always blend in very well (Convair880).
/obj/decal/mule
	name = "Don't spawn me"
	mouse_opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/obj/decals.dmi'
	icon_state = "blank"
	layer = TURF_LAYER + 0.1 // Should basically be part of a turf.

	beacon
		name = "MULE delivery destination"
		icon_state = "mule_beacon"
		var/auto_dropoff_spawn = 1

		New()
			..()
			var/turf/T = get_turf(src)
			if (T && isturf(T) && src.auto_dropoff_spawn == 1)
				for (var/obj/machinery/navbeacon/mule/NB in T.contents)
					if (!isnull(NB.codes_txt))
						var/turf/TD = null
						switch (NB.codes_txt)
							if ("delivery;dir=1")
								TD = locate(T.x, T.y + 1, T.z)
							if ("delivery;dir=4")
								TD = locate(T.x + 1, T.y, T.z)
							if ("delivery;dir=2")
								TD = locate(T.x, T.y - 1, T.z)
							if ("delivery;dir=8")
								TD = locate(T.x - 1, T.y, T.z)
							else
								return

						if (TD && isturf(TD) && !TD.density)
							new /obj/decal/mule/dropoff(TD)
							if (!isnull(NB.location))
								src.name = "[src.name] ([NB.location])"
							break
			return

		no_auto_dropoff_spawn
			auto_dropoff_spawn = 0

	dropoff
		name = "MULE cargo dropoff point"
		icon_state = "mule_dropoff"