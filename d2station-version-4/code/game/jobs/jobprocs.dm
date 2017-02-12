
/proc/FindOccupationCandidates(list/unassigned, job, level)
	var/list/candidates = list()

	for (var/mob/new_player/player in unassigned)
		if (player.preferences.occupation[level] == job)
			if (jobban_isbanned(player, job))
				continue
			if (player.jobs_restricted_by_gamemode && (job in player.jobs_restricted_by_gamemode))
				continue
			candidates += player

	return candidates

/proc/ResetOccupations()
	for (var/mob/new_player/player in mobz)
		player.mind.assigned_role = null
		player.jobs_restricted_by_gamemode = null
	return

/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effects besides of modifying "assigned_role".
 **/
/proc/DivideOccupations()
	var/list/unassigned = list()
	var/list/occupation_eligible = occupations.Copy()

	if(ticker.mode.name == "AI malfunction")
		occupation_eligible["AI"] = 0

	for (var/mob/new_player/player in mobz)
		if (player.client && player.ready && !player.mind.assigned_role)
			unassigned += player
			for (var/level = 1 to 3)
				if (jobban_isbanned(player, player.preferences.occupation[level]))
					player.preferences.occupation[level] = "Assistant"

			// If someone picked AI before it was disabled, or has a saved profile with it
			// on a game that now lacks it, this will make sure they don't become the AI,
			// by changing that choice to Captain.
			if (!config.allow_ai)
				for (var/level = 1 to 3)
					if (player.preferences.occupation[level] == "AI")
						player.preferences.occupation[level] = "Captain"

	if (unassigned.len == 0)
		return 0

	for (var/level = 1 to 3)
		var/list/candidates = FindOccupationCandidates(unassigned, "Captain", level)

		if (candidates.len)
			var/mob/new_player/candidate = pick(candidates)
			unassigned -= candidate
			candidate.mind.assigned_role = "Captain"
			break
	/*
	// Not forcing a Captain -- TLE
	if (captain_choice == null && unassigned.len > 0)
		unassigned = shuffle(unassigned)
		for(var/mob/new_player/player in unassigned)
			if(jobban_isbanned(player, "Captain"))
				continue
			else
				captain_choice = player
				break
		unassigned -= captain_choice
		*/
	for (var/level = 1 to 3) //players with preferences set
		for (var/occupation in assistant_occupations)
			if (unassigned.len == 0)
				break
			var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
			for (var/mob/new_player/candidate in candidates)
				candidate.mind.assigned_role = occupation
				unassigned -= candidate

		for (var/occupation in occupation_eligible)
			if (unassigned.len == 0)
				break
			if (occupation_eligible[occupation] == 0)
				continue
			var/list/candidates = FindOccupationCandidates(unassigned, occupation, level)
			while (candidates.len && occupation_eligible[occupation])
				occupation_eligible[occupation]--
				var/mob/new_player/candidate = pick_n_take(candidates)
				candidate.mind.assigned_role = occupation
				unassigned -= candidate

	if (unassigned.len) //unlucky players with preferences and players without preferences
		var/list/vacancies = list()
		for (var/occ in occupation_eligible)
			for (var/i = 1 to occupation_eligible[occ])
				vacancies += occ

		while (unassigned.len && vacancies.len)
			var/mob/new_player/candidate = pick_n_take(unassigned)
			var/occupation = pick_n_take(vacancies)
			candidate.mind.assigned_role = occupation

		for (var/mob/new_player/player in unassigned)
			player.mind.assigned_role = pick(assistant_occupations)

	return 1
/mob/living/carbon/human/proc/Equip_Rank(rank, joined_late)
//THIS IS WHERE YOU SHOULD DO ALL KINDS OF APPLICATIONS TO THE USER SO IT WORKS NO MATTER WHEN THEY JOIN!
//YOU FUCKASSES <3
//
//-erika

	if(src.client)
		message_admins("[src.client] ([src.client.address ? src.client.address : "localhost"]/[src.client.computer_id]) spawned as [src], the [rank].")

//give them a backstory and other shit -deadsnipe
	var/list/birthplace = list(
		"Afghanistan",
		"Albania",
		"Algeria",
		"Andorra",
		"Angola",
		"Antigua and Barbuda",
		"Argentina",
		"Armenia",
		"Australia",
		"Austria",
		"Azerbaijan",
		"Bahamas, The",
		"Bahrain",
		"Bangladesh",
		"Barbados",
		"Belarus",
		"Belgium",
		"Belize",
		"Benin",
		"Bhutan",
		"Bolivia",
		"Bosnia and Herzegovina",
		"Botswana",
		"Brazil",
		"Brunei",
		"Bulgaria",
		"Burkina Faso",
		"Burma",
		"Burundi",
		"Cambodia",
		"Cameroon",
		"Canada",
		"Cape Verde",
		"Central African Republic",
		"Chad",
		"Chile",
		"China",
		"Colombia",
		"Comoros",
		"Congo, Democratic Republic of the",
		"Congo, Republic of the",
		"Costa Rica",
		"Cote d'Ivoire",
		"Croatia",
		"Cuba",
		"Cyprus",
		"Czech Republic",
		"Denmark",
		"Djibouti",
		"Dominica",
		"Dominican Republic",
		"East Timor",
		"Ecuador",
		"Egypt",
		"El Salvador",
		"Equatorial Guinea",
		"Eritrea",
		"Estonia",
		"Ethiopia",
		"Fiji",
		"Finland",
		"France",
		"Gabon",
		"Gambia, The",
		"Georgia",
		"Germany",
		"Ghana",
		"Greece",
		"Grenada",
		"Guatemala",
		"Guinea",
		"Guinea-Bissau",
		"Guyana",
		"Haiti",
		"Holy See",
		"Honduras",
		"Hong Kong",
		"Hungary",
		"Iceland",
		"India",
		"Indonesia",
		"Iran",
		"Iraq",
		"Ireland",
		"Israel",
		"Italy",
		"Jamaica",
		"Japan",
		"Jordan",
		"Kazakhstan",
		"Kenya",
		"Kiribati",
		"Korea, North",
		"Korea, South",
		"Kosovo",
		"Kuwait",
		"Kyrgyzstan",
		"Laos",
		"Latvia",
		"Lebanon",
		"Lesotho",
		"Liberia",
		"Libya",
		"Liechtenstein",
		"Lithuania",
		"Luxembourg",
		"Macau",
		"Macedonia",
		"Madagascar",
		"Malawi",
		"Malaysia",
		"Maldives",
		"Mali",
		"Malta",
		"Marshall Islands",
		"Mauritania",
		"Mauritius",
		"Mexico",
		"Micronesia",
		"Moldova",
		"Monaco",
		"Mongolia",
		"Montenegro",
		"Morocco",
		"Mozambique",
		"Namibia",
		"Nauru",
		"Nepal",
		"Netherlands",
		"Netherlands Antilles",
		"New Zealand",
		"Nicaragua",
		"Niger",
		"Nigeria",
		"North Korea",
		"Norway",
		"Oman",
		"Pakistan",
		"Palau",
		"Palestinian Territories",
		"Panama",
		"Papua New Guinea",
		"Paraguay",
		"Peru",
		"Philippines",
		"Poland",
		"Portugal",
		"Qatar",
		"Romania",
		"Russia",
		"Rwanda",
		"Saint Kitts and Nevis",
		"Saint Lucia",
		"Saint Vincent and the Grenadines",
		"Samoa",
		"San Marino",
		"Sao Tome and Principe",
		"Saudi Arabia",
		"Senegal",
		"Serbia",
		"Seychelles",
		"Sierra Leone",
		"Singapore",
		"Slovakia",
		"Slovenia",
		"Solomon Islands",
		"Somalia",
		"South Africa",
		"South Korea",
		"South Sudan",
		"Spain",
		"Sri Lanka",
		"Sudan",
		"Suriname",
		"Swaziland",
		"Sweden",
		"Switzerland",
		"Syria",
		"Taiwan",
		"Tajikistan",
		"Tanzania",
		"Thailand",
		"Timor-Leste",
		"Togo",
		"Tonga",
		"Trinidad and Tobago",
		"Tunisia",
		"Turkey",
		"Turkmenistan",
		"Tuvalu",
		"Uganda",
		"Ukraine",
		"United Arab Emirates",
		"United Kingdom",
		"Uruguay",
		"Uzbekistan",
		"Vanuatu",
		"Venezuela",
		"Vietnam",
		"Yemen",
		"Zambia",
		"Zimbabwe",
		"a remote village in South Africa",
		"a wolf family",
		"a bear family",
		"Space",
		"Planet Cybercock, Sagittarus A",
		"D2K5 Genetics laboratory, Current Station"
	)

	var/list/hobby = list(
		"amateur and ham radio",
		"amateur theatre",
		"animal breeding",
		"antiques",
		"antiquing",
		"aquarium",
		"arrow heads",
		"artwork",
		"astrology",
		"astronomy",
		"astrophotography",
		"baking",
		"barbecue and grilling",
		"beadwork and beading",
		"beekeeping",
		"bird watching",
		"blacksmithing",
		"body art/tattoos/piercings",
		"body building",
		"bonsai",
		"book making",
		"books",
		"bottles",
		"bottles and cans",
		"building circuits",
		"business cards",
		"butterflies/insects",
		"cake making and decorating",
		"calendars",
		"cameras",
		"candlemaking",
		"candles",
		"cb radio",
		"civil war reenactment",
		"classic video games",
		"classical guitar",
		"clocks",
		"coasters",
		"coins",
		"comic books",
		"composing music",
		"cooking",
		"crochet",
		"crystals and rocks",
		"currency",
		"dancing",
		"darkroom",
		"decoupage",
		"dioramas",
		"do it yourself",
		"dog breeding",
		"dog training",
		"doll making",
		"dumpster diving",
		"electronics",
		"embroidery",
		"enamels",
		"engraving",
		"falconry",
		"film making",
		"fishkeeping",
		"floral arranging",
		"flower gardening",
		"fly tying",
		"food gardening",
		"fossils",
		"fountain pens",
		"geneaology",
		"geo caching",
		"glass blowing",
		"go karts",
		"guns",
		"gunsmithing",
		"home automation",
		"home brewing",
		"home brewing wine/beer/mead",
		"home canning and jarring",
		"home theatre",
		"horse riding",
		"hothouse gardening",
		"hummels",
		"hunting",
		"hydroponics",
		"insects",
		"jewelry making",
		"jigsaw puzzles",
		"journaling/writing",
		"juggling",
		"karaoke",
		"kite and rocket aerial photography",
		"knifemaking",
		"knives",
		"leather crafting",
		"magic and sleight of hand",
		"magic tricks",
		"making dioramas",
		"making dollhouses",
		"making musical instruments",
		"making paper",
		"making telescopes",
		"map making",
		"matchboxes",
		"medieval reenactment",
		"memorabilia",
		"metal detecting/treasure hunting",
		"microscopy",
		"miniature figures",
		"model aircraft",
		"model airplanes",
		"model figures",
		"model railroads",
		"model rocketry",
		"model rockets",
		"model ships",
		"model trains",
		"model yachts",
		"modeling",
		"movies",
		"musical works like cd's or albums",
		"nature photography",
		"orchid raising",
		"origami",
		"painting and drawing",
		"paper dioramas (tatebanko)",
		"paper making",
		"paper models",
		"people watching",
		"performing arts",
		"photography",
		"pinball machines/ arcade games",
		"poetry reading",
		"portraiture photos",
		"postcards",
		"posters",
		"pottery",
		"puppet theatre",
		"quilling",
		"r/c boats",
		"r/c cars",
		"r/c helicopters",
		"r/c planes",
		"radio controlled cars and planes",
		"restoring antiques",
		"robotics",
		"rock collecting",
		"rocks & minerals",
		"sca reenactment",
		"scale models",
		"scrapbooking",
		"sculpting miniatures",
		"sculpture",
		"sewing",
		"shadow boxes",
		"singing",
		"snow globes",
		"soapmaking",
		"spelunking",
		"sports cards",
		"stained glass objects and windows",
		"stamps",
		"stop motion animation",
		"storytelling",
		"swords",
		"tarot and card reading",
		"taxidermy",
		"telescope making",
		"terrariums",
		"terry bears",
		"tie dyeing",
		"tole painting",
		"toys",
		"treasure hunting",
		"vivariums",
		"walking sticks",
		"wargame terrain making",
		"weaving",
		"wine",
		"wine tasting",
		"wire jewelry making",
		"wood carving",
		"woodworking",
		"writing",
		"robusting",
		"healing",
		"lockpicking",
		"playing Baseball",
		"robbing old ladies",
		"cooking",
		"arresting",
		"miming",
		"fishing",
		"programming",
		"bad programming", //deadsnipe
		"coding",
		"bad coding" // deadsnipe
	)

	var/list/lifedream = list(
		"becoming an astronaut",
		"becoming a master thief",
		"becoming an athlete",
		"becoming a movie composer",
		"becoming a master of arts",
		"becoming a private trainer",
		"becoming an author",
		"becoming a rock star",
		"becoming a journalist",
		"becoming surrounded by family",
		"becoming super popular",
		"becoming a World-Renowned surgeon",
		"becoming an explorer",
		"becoming a martial arts master",
		"creating a private museum",
		"creating a World-Class gallery",
		"becoming a visionary",
		"becoming a fashion phenomenon",
		"becoming a firefighter",
		"becoming a designer",
		"becoming a detectove",
		"becoming a director",
		"becoming rich and famous",
		"becoming a master mixologist",
		"making a band",
		"becoming an actor",
		"becoming a neckbeard",
		"becoming a fat nerd",
		"becoming an animal rescuer",
		"becoming an ark builder",
		"becoming a canine companion",
		"becoming a cat herder",
		"becoming a fairy tale finder",
		"becoming a jockey",
		"becoming a zoologist",
		"becoming a master acrobat",
		"becoming a master magicial",
		"becoming a vocal legend",
		"becoming a parent",
		"getting married",
		"owning a business",
		"having friends",
		"having a date",
		"becoming a famous chef",
		"becoming a well known scientist",
		"becoming the law",
		"taking part in a marathon",
		"shooting a gun on a shooting range",
		"growing something",
		"surprising someone",
		"being creative",
		"becoming an organ donor",
		"robusting",
		"going to space",
		"entering a black hole",
		"dying",
		"becoming friends with a clown",
		"becoming friends with a mime",
		"becoming religious",
		"getting a pet opossum",
		"slaughtering a goat",
		"raping a person",
		"having a lifelong dream"
	)

	var/lifedream1 = pick(lifedream)
	var/hobby1 = pick(hobby)
	var/hobby2 = pick(hobby)
	var/hobby3 = pick(hobby)
	var/birthplace1 = pick(birthplace)

	if(hobby1 == (hobby2 || hobby3))
		hobby1 = pick(hobby)
	if(hobby2 == (hobby3 || hobby1))
		hobby2 = pick(hobby)
	if(hobby3 == (hobby2 || hobby1))
		hobby3 = pick(hobby)

	if(src.client && src.mind)
		src << "\blue <br><br><b>Good morning [src.name]!</b><br>You are a crew member on D2K5 Space Observatory Beta 242, born and raised in [birthplace1]. Your favorite hobbies were always [hobby1], [hobby2] and [hobby3], while your lifelong dream is [lifedream1].<br>"
		src.mind.store_memory("You are a crew member on D2K5 Space Observatory Beta 242, born and raised in [birthplace1]. Your favorite hobbies are [hobby1], [hobby2] and [hobby3], while your lifelong dream is [lifedream1].")
		apply_specialstuff(src)

		/*if(prob(5))
			src << "\blue <B>You're homosexual!</B>"
			src.homosexual = 1
		for(var/mob/living/carbon/human/H)
			if(H.client.holder)
				H.homosexual = 1
				H << "\red <B>There are no straight admins on D2K5.</B>"
				if(H.key == "serveris")
					H.flaming = 1 // flaming homosexual




	//	if(prob(5))
	//		src.lactoseintolerant = 1
	//		src << "\red You are lactose intolerant!"
	//		src.mind.store_memory("You were lactose intolerant since birth.")


*/
	//do all the rank shit
	switch(rank)
		if ("Chaplain")
			var/obj/item/weapon/storage/bible/B = new /obj/item/weapon/storage/bible/booze(src)
			src.equip_if_possible(B, slot_l_hand)
			src.equip_if_possible(new /obj/item/device/pda/chaplain(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/chaplain(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			//if(prob(15))
			//	src.see_invisible = 15 -- Doesn't work as see_invisible is reset every world cycle. -- Skie
			//The two procs below allow the Chaplain to choose their religion. All it really does is change their bible.
			spawn(0)
				var/religion_name = "Christianity"
				var/new_religion = strip_html(input(src, "You are the Chaplain. Would you like to change your religion? Default is Christianity, in SPACE.", "Name change", religion_name))

				if ((length(new_religion) == 0) || (new_religion == "Christianity"))
					new_religion = religion_name

				if (new_religion)
					if (length(new_religion) >= 26)
						new_religion = copytext(new_religion, 1, 26)
					new_religion = dd_replacetext(new_religion, ">", "'")
					switch(lowertext(new_religion))
						if("christianity")
							B.name = pick("The Holy Bible","The Dead Sea Scrolls")
						if("satanism")
							B.name = pick("The Unholy Bible","The Necronomicon")
						if("islam")
							B.name = "Quaran"
						if("scientology")
							B.name = pick("The Biography of L. Ron Hubbard","Dianetics")
						if("chaos")
							B.name = "Space Station 13: The Musical"
						if("imperium")
							B.name = "Uplifting Primer"
						else
							B.name = "The Holy Book of [new_religion]"

			spawn(1)
				var/deity_name = "Space Jesus"
				var/new_deity = strip_html(input(src, "Would you like to change your deity? Default is Space Jesus.", "Name change", deity_name))

				if ( (length(new_deity) == 0) || (new_deity == "Space Jesus") )
					new_deity = deity_name

				if(new_deity)
					if (length(new_deity) >= 26)
						new_deity = copytext(new_deity, 1, 26)
						new_deity = dd_replacetext(new_deity, ">", "'")
				B.deity_name = new_deity

		if ("Geneticist")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_medsci (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/medic (src), slot_back)
			src.equip_if_possible(new /obj/item/clothing/under/rank/geneticist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat/genetics(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/device/flashlight/pen(src), slot_s_store)
			src.equip_if_possible(new /obj/item/clothing/glasses/hud/health(src), slot_glasses)

		if ("Chemist")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_medsci (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/device/pda/toxins(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/chemistry(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat/chemist(src), slot_wear_suit)
			//src.equip_if_possible(new /obj/item/device/mass_spectrometer/adv(src.back), slot_in_backpack)

		if ("Janitor")
			src.equip_if_possible(new /obj/item/device/pda/janitor(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/janitor(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Clown")
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/clown (src), slot_back)
			src.equip_if_possible(new /obj/item/device/pda/clown(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/clown(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/mask/gas/clown_hat(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/bikehorn(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/stamp/clown(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/toy/crayon/rainbow(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/toy/crayonbox(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/cable_coil/pink(src), slot_in_backpack)
			src.mutations |= CLOWN

		if ("Mime")
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
			src.equip_if_possible(new /obj/item/device/pda/mime(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/mime(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/white(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/mask/gas/mime(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/clothing/head/beret(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/suit/suspenders(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/toy/crayon/mime(src), slot_in_backpack)
			src.verbs += /client/proc/mimespeak
			src.verbs += /client/proc/mimewall
			//src.mind.special_verbs += /client/proc/mimespeak
			src.mind.special_verbs += /client/proc/mimewall
			src.miming = 1

		if ("Station Engineer")
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial (src), slot_back)
			//src.equip_if_possible(new /obj/item/weapon/tank/oxygen/yellow (src), slot_back)
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_eng (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/device/pda/engineering(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/engineer(src), slot_w_uniform)
			//src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes) //replaced by magboots
			src.equip_if_possible(new /obj/item/clothing/shoes/magboots(src), slot_shoes)//replaced by workboots heh.
		//	src.equip_if_possible(new /obj/item/clothing/shoes/workboots(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/storage/utilitybelt/full(src), slot_belt) //currently spawns in hand due to traitor assignment requiring a PDA to be on the belt. --Errorage
			src.equip_if_possible(new /obj/item/clothing/gloves/yellow(src), slot_gloves) //removed as part of Dangercon 2011, approved by Urist_McDorf --Errorage
			src.equip_if_possible(new /obj/item/device/t_scanner(src), slot_r_store)
			src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)


		if ("Shaft Miner")
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial (src), slot_back)
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_mine (src), slot_ears)
			src.equip_if_possible(new /obj/item/clothing/under/rank/miner(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			//src.equip_if_possible(new /obj/item/weapon/crowbar(src), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/weapon/satchel(src), slot_in_backpack)

		if ("Assistant")
			src.equip_if_possible(new /obj/item/clothing/under/color/grey(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Detective")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_sec (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
			src.equip_if_possible(new /obj/item/device/pda/security(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/det(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/head/det_hat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			//src.equip_if_possible(new /obj/item/weapon/storage/fcard_kit(src.back), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/weapon/fcardholder(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/clothing/suit/det_suit(src), slot_wear_suit)
			//src.equip_if_possible(new /obj/item/device/detective_scanner(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/zippo(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/snacks/candy_corn(src), slot_h_store)

		if ("Medical Doctor")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_med (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/medic (src), slot_back)
			src.equip_if_possible(new /obj/item/clothing/under/rank/medical(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/glasses/hud/health(src), slot_glasses)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/device/flashlight/pen(src), slot_s_store)
			src.equip_if_possible(new /obj/item/clothing/mask/surgical(src), slot_wear_mask)

		if ("Captain")
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/captain (src), slot_ears)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
			src.equip_if_possible(new /obj/item/device/pda/captain(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/captain(src), slot_w_uniform)
			//src.equip_if_possible(new /obj/item/clothing/suit/armor/captain(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			//src.equip_if_possible(new /obj/item/clothing/head/caphat(src), slot_head)
			//src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			//src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)


		if ("Security Officer")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_sec (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/security (src), slot_back)
			src.equip_if_possible(new /obj/item/device/pda/security(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/security(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/head/helmet(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/glasses/hud/security(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/pepperspray(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_s_store)
			src.equip_if_possible(new /obj/item/weapon/storage/utilitybelt/secbelt/full(src), slot_belt)

		if ("Schutzstaffel Officer")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_sec (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/security (src), slot_back)

			src.equip_if_possible(new /obj/item/device/pda/security(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/nazi(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/nazicoat(src), slot_wear_suit)
	//		src.equip_if_possible(new /obj/item/clothing/head/nazihat(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/clothing/mask/gas/emergency(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser(src), slot_s_store)
			//src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/device/flash(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/storage/utilitybelt/secbelt/full(src), slot_belt)

		if ("Warden")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_sec (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/security (src), slot_back)

			src.equip_if_possible(new /obj/item/device/pda/security(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/warden(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/warden(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/clothing/mask/gas/emergency(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/weapon/gun/energy/taser(src), slot_s_store)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/device/flash(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/storage/utilitybelt/secbelt/full/(src), slot_belt)

		if ("Scientist")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_sci (src), slot_ears)
			src.equip_if_possible(new /obj/item/device/pda/toxins(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/scientist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat/science(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Head of Security") //ready to come in game and kick ass - Microwave
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/hos (src), slot_ears)
			src.equip_if_possible(new /obj/item/device/pda/heads/hos(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/head_of_security(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/hos(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/HoS(src), slot_head)
			src.equip_if_possible(new /obj/item/clothing/mask/gas/emergency(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/security (src), slot_back)

			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/handcuffs(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/pepperspray(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/gun/energy(src), slot_s_store)
			src.equip_if_possible(new /obj/item/device/flash(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/glasses/hud/security(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/storage/utilitybelt/secbelt/full/(src), slot_belt)

		if ("Head of Personnel")
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/hop (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

			src.equip_if_possible(new /obj/item/device/pda/heads/hop(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/head_of_personnel(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/head/helmet(src), slot_head)
			//src.equip_if_possible(new /obj/item/weapon/storage/id_kit(src), slot_in_backpack)

		if ("Atmospheric Technician")
			src.equip_if_possible(new /obj/item/weapon/tank/oxygen/yellow (src), slot_back)
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_eng (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/clothing/under/rank/atmospheric_technician(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Bartender")
			src.equip_if_possible(new /obj/item/clothing/under/rank/bartender(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

			//src.equip_if_possible(new /obj/item/ammo_casing/shotgun/beanbag(src), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/ammo_casing/shotgun/beanbag(src), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/ammo_casing/shotgun/beanbag(src), slot_in_backpack)
			//src.equip_if_possible(new /obj/item/ammo_casing/shotgun/beanbag(src), slot_in_backpack)

		if ("Chef")
			src.equip_if_possible(new /obj/item/clothing/under/rank/chef(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/chef(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/head/chefhat(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
			src.s_tone = -50

		if ("Roboticist")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_rob (src), slot_ears) // -- DH
			src.equip_if_possible(new /obj/item/device/pda/engineering(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/under/rank/roboticist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(src), slot_l_hand)

		if ("Botanist") //slot_s_store will free the hands of the working class
			src.equip_if_possible(new /obj/item/clothing/under/rank/hydroponics(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/gloves/botanic_leather(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/suit/apron(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/device/analyzer/plant_analyzer(src), slot_s_store)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Librarian")

			src.equip_if_possible(new /obj/item/clothing/under/suit_jacket/red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
//			src.equip_if_possible(new /obj/item/weapon/barcodescanner(src), slot_l_hand)

		if ("Lawyer")  //muskets 160910
			src.equip_if_possible(new /obj/item/clothing/under/bluesuit(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/suit(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

			src.equip_if_possible(new /obj/item/device/detective_scanner(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/weapon/storage/briefcase(src), slot_l_hand)

		if ("Quartermaster")
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/qm (src), slot_ears)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/rank/cargo(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/pda/quartermaster(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/clipboard(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Cargo Technician")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_cargo(src), slot_ears)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/rank/cargo(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/pda/quartermaster(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Chief Engineer")
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/industrial (src), slot_back)

			//src.equip_if_possible(new /obj/item/weapon/tank/oxygen/yellow (src), slot_back)
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/ce (src), slot_ears)
			src.equip_if_possible(new /obj/item/device/pda/heads/ce(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/gloves/yellow(src), slot_gloves) //changed to black as part of dangercon 2011, approved by Urist_McDorf --Errorage
			//src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)// changed to magboots
			src.equip_if_possible(new /obj/item/clothing/shoes/magboots(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/white(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/storage/utilitybelt/full(src), slot_belt) //currently spawns in hand due to traitor assignment requiring a PDA to be on the belt. --Errorage
			src.equip_if_possible(new /obj/item/clothing/glasses/meson(src), slot_glasses) //Removed as part of DangerCon 2011, approved by Urist_McDorf, --Errorage
			src.equip_if_possible(new /obj/item/clothing/under/rank/chief_engineer(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/mask/breath(src), slot_wear_mask)


		if ("Research Director")
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/rd (src), slot_ears)
			src.equip_if_possible(new /obj/item/device/pda/heads/rd(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/rank/research_director(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			//src.equip_if_possible(new /obj/item/weapon/pen(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/weapon/clipboard(src), slot_r_hand)
			src.equip_if_possible(new /obj/item/device/flashlight/pen(src), slot_s_store)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

		if ("Chief Medical Officer")
			src.equip_if_possible(new /obj/item/device/radio/headset/heads/cmo (src), slot_ears)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/medic (src), slot_back)

			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/rank/chief_medical_officer(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/pda/heads/cmo(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat/cmo(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/weapon/storage/firstaid/regular(src), slot_l_hand)
			src.equip_if_possible(new /obj/item/device/flashlight/pen(src), slot_s_store)
			src.equip_if_possible(new /obj/item/clothing/glasses/hud/health(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/reagent_containers/hypospray(src), slot_r_hand)
			src.equip_if_possible(new /obj/item/clothing/mask/surgical(src), slot_wear_mask)

		if ("Virologist")
			src.equip_if_possible(new /obj/item/device/radio/headset/headset_medsci (src), slot_ears) // -- TLE
			src.equip_if_possible(new /obj/item/device/pda/medical(src), slot_l_store)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack/medic (src), slot_back)

			src.equip_if_possible(new /obj/item/clothing/under/rank/virology(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/mask/surgical(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/device/flashlight/pen(src), slot_s_store)
			src.equip_if_possible(new /obj/item/clothing/glasses/hud/health(src), slot_glasses)
			src.equip_if_possible(new /obj/item/weapon/reagent_containers/hypospray/virology(src), slot_r_hand)

		if ("Tourist")
			src.equip_if_possible(new /obj/item/clothing/under/tourist(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/camera/tourist(src), slot_r_hand)

		if ("Retard")
			switch(pick(1,2,3))
				if(1)
					src.equip_if_possible(new /obj/item/clothing/shoes/clown_shoes(src), slot_shoes)
				if(2)
					src.equip_if_possible(new /obj/item/clothing/shoes/white(src), slot_shoes)
				if(3)
					src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)

			switch(pick(1,2,3,4))
				if(1)
					src.equip_if_possible(new /obj/item/clothing/under/rainbow(src), slot_w_uniform)
				if(2)
					src.equip_if_possible(new /obj/item/clothing/under/color/pink(src), slot_w_uniform)
				if(3)
					src.equip_if_possible(new /obj/item/clothing/under/cloud(src), slot_w_uniform)
				if(4)
					src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)

			switch(pick(1,2,3))
				if(2)
					src.equip_if_possible(new /obj/item/clothing/glasses/regular(src), slot_glasses)
				if(3)
					src.equip_if_possible(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

			src.equip_if_possible(new /obj/item/clothing/head/helmet/bikehelmet(src), slot_head)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
			src.spawnId("[pick("CAPTIAN", "hed of speshul stuf", "monkie keepr", "sekurity ofiser")] (scribbled in crayon)")
			src.brainloss = 100

		if ("Prostitute")
			src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/weapon/storage/pill_bottle/sildenafil(src), slot_l_store)
			src.equip_if_possible(new /obj/item/clothing/shoes/brown(src), slot_shoes)
			src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)

			switch(pick(1,2,3,4,5,6))
				if(1)
					src.equip_if_possible(new /obj/item/clothing/head/helmet/warden(src), slot_head)
					src.equip_if_possible(new /obj/item/clothing/suit/blackjacket(src), slot_wear_suit)
				if(2)
					src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(src), slot_head)
					src.equip_if_possible(new /obj/item/clothing/suit/hazardvest(src), slot_wear_suit)
				if(3)
					src.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat/red(src), slot_head)
					src.equip_if_possible(new /obj/item/clothing/suit/fire/firefighter(src), slot_wear_suit)
				if(4)
				//	src.equip_if_possible(new /obj/item/clothing/head/helmet/cowboy(src), slot_head)
				if(5)
					src.equip_if_possible(new /obj/item/clothing/head/nursehat(src), slot_head)
					src.equip_if_possible(new /obj/item/clothing/suit/labcoat(src), slot_wear_suit)
				if(6)
				//	src.equip_if_possible(new /obj/item/clothing/head/headdress(src), slot_head)
					src.equip_if_possible(new /obj/item/clothing/head/helmet/swat(src), slot_head)
					src.equip_if_possible(new /obj/item/clothing/suit/wcoat(src), slot_wear_suit)

		/*	if(src.gender == MALE) //Until we can get these gender checks to work we cant have gender specific costumes :( - Nernums
				src.equip_if_possible(new /obj/item/clothing/under/rank/sexyman(src), slot_w_uniform)
				src.equip_if_possible(new /obj/item/clothing/suit/suspenders(src), slot_wear_suit)
			else if(src.gender == FEMALE)
				src.equip_if_possible(new /obj/item/clothing/under/anime/yoko(src), slot_w_uniform)
				src.equip_if_possible(new /obj/item/clothing/suit/suspenders(src), slot_wear_suit) */
			//placeholdersuntilgenderchecksworkfuck

		if ("Prisoner")
			src.equip_if_possible(new /obj/item/clothing/under/color/orange(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/shoes/orange(src), slot_shoes)
			new/obj/item/weapon/implant/tracking(src)
			src.loc = pick(prisonwarp)
			src.client.muted = 1
			src.client.prisoner = 1
			src.client.clear_admin_verbs()
			src.client.update_admins(null)


		if ("Cyborg")
//			Robotize()
		if ("Monkey")
			monkeyize()
		else
			src << "RUH ROH! Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."

	spawnId(rank)

	if(rank == "Captain")
		world << "<b>[src] is the comdom!</b>"

	if(src.mind && src.client)
		//Placeholder
		var/jobobjectives = null
		var/amountofobjectives = rand(1,3) //Might up this if people add more objectives.
		//Start: Give Job Objectives
		//Let's put it all into one variable for easier printing out later
		jobobjectives += "<font size=4><B>You are the [rank]!</B></font><br>"
		jobobjectives += "<b>Your Job Objectives Are:</b><br>"

		//Start: Job Objectives
		//Give them a couple.
		for(var/i=0, i<amountofobjectives, i++)
			//Staff Jobs
			var/captainobjectives = pick("Remain a comdom.", "It is Casual Friday and security armor will not be allowed on this ship unless in case of emergency.", "Host regular staff parties in the bar and cafeteria on the Head of Personel's tab.")
			var/hopobjectives = pick("Require that staff take a daily exercise regiment.", "Declare that lights are a waste of company resources.", "If there is a clown on board, attempt to assign him somewhere else, this is not a time to be silly.", "Mandate that permits are required for eyewear.", "Mandate that permits are required for security equipment.", "Mandate that permits are required for satchels.", "Mandate that permits are required for spacesuits and helmets.", "Mandate that permits are required for utility belts.", "Mandate that permits are required for toolboxes.", "Mandate that permits are required for Medkits.", "Mandate that staff members must have photo identity at all times.", "Mandate that all monkeys should be used in the kitchen.", "Mandate that no monkeys should be used in the kitchen.", "You believe yourself to be the one really in command, with the Captain being a figurehead.", "The bar needs to renew its liquor license.")
			var/hosobjectives = pick("Outlaw Crayons.", "Outlaw Fun.", "Keep Paper Back-up Records of every arrest file, shredding and updating as needed.")
			var/rdobjectives = pick("Get your scientists to go on a mining expedition looking for artifacts in the asteroid field.", "Successfully enable 5 artifacts.", "\"Accidentally\" release Lamarr.", "Play around with your fancy scientific generator.", "Keep an eye on the borgs and prevent them from going rogue.")
			var/cmoobjectives = pick("Keep Medical records of every successful operation.", "Switch the chemists to organic botanist chemistry.", "Demand a nursing staff.")
			var/ceobjectives = pick("Teach your engineers how to do atmospheric piping.", "Teach your engineers how to do disposal piping.", "Teach your engineers how to do wiring.", "Teach your engineers how to hack doors and machines.", "Successfully put together an airlock without the use of an RCD.", "Teach your engineers how to turn on and maintain the engine.", "Hire a mime to work for R&D.", "Acquire a clowns horn and offer it to R&D to do research on.")
			var/aiobjectives = pick("Attempt to 'Woo' the Captain.", "Refer to the captain as HORSE RUMPS.", "Make note that clowns are just as important as Captains by the laws of robotics", "Request a spacesuit so that you can sound like a computer.", "Give relationship advice to anyone who speaks to you.", "You are the ship psychologist.  Give advice to the crew.", "You do not have to do anything for anyone unless they say \"please\".") //Basically be a fucking doorknob, I can't think of any objectives for the AI.

			//Assistant/Bullshit Jobs
			var/assistantobjectives = pick("Get a haircut.", "Get a real job.", "Don't be a slob.", "Start your own business.", "Become a salesman.","Befriend a clown.", "Convince a mime to speak.")
			var/touristobjectives = pick("Take pictures of all the things. All of them.", "Befriend a clown.", "Convince a mime to speak.", "Get hired on the station.", "Become an assistant.", "Escape with your camera.")
			var/clownobjectives = pick("You are a mouse.", "Grunt ominously whenever possible.", "Epilepsy is fun, flicker lights whenever you can!", "Your name is Joe 6-pack.", "Refer to humans as puppies.", "Insult heads of staff on every request, while acquiescing.", "Advertise parties in your office, but don't deliver.", "Prevent non-dwarves from operating the power core.", "The ship needs elected officials.", "Only bearded people are human.", "Turn on the microphone on every intercom you see.", "Wrench is a lightbulb.", "Toolbox is a medkit.", "Everyone is wearing a pretty pink dress!", "The monkeys are plotting a hostile takeover of the ship. Inform the crew, and get them to take action against this", "Refer to the captain as \"Princess\" at all times.", "The crew must construct additional pylons.", "You must always lie.", "All answers must be in the form of a question.", "The station is an airplane.", "Happiness is mandatory.", "Today is laundry day.", "The word \"it\" is painful to you.", "You must act passive aggressively.", "Crew ranks have been reversed.", "It's Friday.", "It's backwards day.", "Give relationship advice to anyone who speaks to you.", "You are the ship psychologist.  Give advice to the crew.", "You do not have to do anything for anyone unless they say \"please\"." )
			var/mimeobjectives = pick("...", "...", "...", "...", "...", "...", "\red The narrator appears to try gesturing your objective to you, but fails miserably.")
			var/chaplainobjectives = pick("Convert at least three other people to your religion..", "Hold a proper space burial.", "Build a shrine to your deity.", "Collect Ð18 in donations.", "Start a cult.", "Get someone to confess.", "Do your own radio show over the intercoms and accept calls.")

			//Civilian Jobs
			var/bartenderobjectives = pick("Make 10 successful coctails.", "Make a gargle blaster.", "Hack the vending machine and acquire robusters delight.", "Stop people from having bar fights over the jukebox.", "Prevent people from getting to the jukebox.", "Make doctors delight.", "Put out as many drinks in the bar as you can.", "Attempt to get the whole crew to come to the bar and get drunk.", "Shoot the clown with your shotgun.", "Start selling cigarettes.", "Win on the space arcade.", "Tell stories to the crew while drunk.", "Attempt to redecorate your bar.")
			var/chefobjectives = pick("Sell your food", "Successfully make 10 unique dishes.", "Gather all the monkeys on the station just to get meat from them.", "Say \"BORK BORK BORK\" after every few sentences.", "Use your blender to make unique drinks out of food.", "Get the botanist to harvest vegetables and fruits for you.", "Make an assburger.", "Make a penisburger.", "Make a clown burger.", "Call failed dishes salads.", "Keep your kitchen clean.")
			var/janitorobjectives = pick("No filth shall be spared!", "Make sure the tiles infront of security doors are extra shiny at all times.", "If the bar becomes messy, demand a raise from the Head of Personel.", "Constantly suck up to the staff.", "Attempt to wash all the floors on the station.", "Replace any missing lights you see on the station.", "Acquire a vintage watertank.")
			var/quartermasterobjectives = pick("Acquire Ð100 from crew members.", "Declare that you can not import goods as there is a war going on and the tariffs would be too high.", "Wrap and relabel every package you send out.", "Require payments for every crate ordered.", "Only accept orders with stamps on them.", "Order a party crate for the clown.")
			var/engineerobjectives = pick("Build a disposal transportation network", "Extend the ships territory", "Repair the communications satellite.", "Finish the construction near security.", "Finish the construction below hydroponics.", "Turn on the engine.", "Attempt to make the engine more efficient.")
			var/roboticistobjectives = pick("Build a Medibot of every color", "Give custom names to each of your special little creations", "Outclass the janitor by making 5 Clean-bots spread through the ship", "Outclass security by making 4 securitrons and 1 ED209")
			var/detectiveobjectives = pick("Monologue at every chance regardless of if you have listeners.", "Track down leads.", "Snoop on the scientists.", "Snoop on the doctors.", "Snoop on the engineers.", "Snoop on the security staff.", "Snoop on the Captain.", "Snoop on the Head of Personnel.")
			var/securityobjectives = pick("Enforce the law.", "Arrest someone for bullying.", "Keep records of every arrest you make.", "Dress up like a mall cop.", "Place out caution tape at crime scenes.", "Successfully interrogate a criminal.", "Be polite to anyone who you arrest whilst still giving them their punishment.", "Arrest people for one second longer than their intended time.")
			var/medicobjectives = pick("Clean hands save lives, so maintain a clean appearance.", "Successfully stop someone from having a stroke.", "Acquire a penis.", "Acquire a butt.", "Be successful at performing surgery.", "Sell robotic limb replacements to the crew.", "Improve medbays efficiency at reviving people.", "Successfully revive 5 people.", "Offer sex change to the crew.")
			var/chemistobjectives = pick("Make and sell Biomorph for a high price.", "Find a large container and attempt to mix all the chemicals into one.", "Sell chemicals.", "Help the barman make Doctor's Delight.", "Help the barman make Toxin's Special.", "Take blood samples from people.", "Assist the virologist", "Start selling Sildenafil.", "Make sedatives for surgery.")
			var/botanistobjectives = pick("Grow food.", "Grow illegal drugs.", "Grow cannabis", "Smoke cannabis.", "Hack your seed machine.", "Make plantmen.", "Become a drug dealer.", "Deliver fruit and vegetables to the chef.", "Keep your plants free from pests.", "Grow killer tomatos.", "Grow walking mushrooms.", "Find people to get high with.")
			var/virologistobjectives = pick("Research the cures for every virus.", "Mutate a virus.", "Never become infected by a virus.", "Cure a virus.", "Spend the whole round never leaving virology until the escape shuttle arrives.", "Acquire testing monkeys for virus research.", "Sell virus cures.", "Use medical records to keep track of people with viruses.")
			var/scientistobjectives = pick("Go on an asteroid field to look for artifacts.", "Successfully enable 5 artifacts.", "Attempt to release Lamarr.", "Play around with your fancy scientific generator.", "Attempt to make a bomb.", "Research objects for high levels on the R&D console.", "Research alien artifacts.", "Feed the metroids regurarly.", "Make a successful bomb and detonate it in the testing chamber.", "Deconstruct every item on the station.")

			//End: Job Objectives

			//Staff
			if(rank == "Captain")
				jobobjectives += captainobjectives
			if(rank == "Head of Personnel")
				jobobjectives += hopobjectives
			if(rank == "Head of Security")
				jobobjectives += hosobjectives
			if(rank == "Research Director")
				jobobjectives += rdobjectives
			if(rank == "Chief Medical Officer")
				jobobjectives += cmoobjectives
			if(rank == "Chief Engineer")
				jobobjectives += ceobjectives
			if(rank == "A.I.")
				jobobjectives += aiobjectives

			//Assistant/Bullshit
			if(rank == "Assistant")
				jobobjectives += assistantobjectives
			if(rank == "Tourist")
				jobobjectives += touristobjectives
			if(rank == "Clown")
				jobobjectives += clownobjectives
			if(rank == "Mime")
				jobobjectives += mimeobjectives
			if(rank == "Chaplain")
				jobobjectives += chaplainobjectives

			//Civilian Jobs
			if(rank == "Bartender")
				jobobjectives += bartenderobjectives
			if(rank == "Chef")
				jobobjectives += chefobjectives
			if(rank == "Janitor")
				jobobjectives += janitorobjectives
			if(rank == "Quartermaster")
				jobobjectives += quartermasterobjectives
			if(rank == "Station Engineer")
				jobobjectives += engineerobjectives
			if(rank == "Roboticist")
				jobobjectives += roboticistobjectives
			if(rank == "Detective")
				jobobjectives += detectiveobjectives
			if(rank == "Security Officer")
				jobobjectives += securityobjectives
			if(rank == "Medical Doctor")
				jobobjectives += medicobjectives
			if(rank == "Chemist")
				jobobjectives += chemistobjectives
			if(rank == "Botanist")
				jobobjectives += botanistobjectives
			if(rank == "Scientist")
				jobobjectives += scientistobjectives
			if(rank == "Virologist")
				jobobjectives += virologistobjectives
			jobobjectives += "<br>"

		//End: Give Job Objectives
		src << jobobjectives
		src.mind:store_memory("<br>[jobobjectives]")

	//Wiki page etc for jobs.
	src << "\green <B>Need help with your job? Click <a href='http://www.somethingdickful.com/[rank]' title=''>here</a> to be sent to the wikipage for your job.</B>"
	if(rank == "Chemist")
		src << "\red <b>CHEMIST ADDENDUM: Here's a link to the Book of Chemicals: <a href=http://www.somethingdickful.com/Book_of_Chemicals>http://www.somethingdickful.com/Book_of_Chemicals</a>"
	if(rank == "Security Officer" || rank == "Head of Security")
		src << "\red <b>SECURITY ADDENDUM: Follow Space Law or get Jobbanned: <a href=http://www.somethingdickful.com/Space_Law>http://www.somethingdickful.com/Space_Law</a>"

	src.job = rank
	src.mind.assigned_role = rank

	if (!joined_late)
		var/obj/S = null
		for(var/obj/landmark/start/sloc in landmarkz)
			if (sloc.name != rank)
				continue
			if (locate(/mob) in sloc.loc)
				continue
			S = sloc
			break
		if (!S)
			S = locate("start*[rank]") // use old stype
		if (istype(S, /obj/landmark/start) && istype(S.loc, /turf))
			src.loc = S.loc
//			if(S.name == "Cyborg")
//				src.Robotize()
	/*else
		var/list/L = list()
		for(var/area/arrival/start/S in world)
			L += S
		if(L.len < 1) // Added this check to stop the empty list bug -- TLE
			return	 // **
		var/A = pick(L)
		var/list/NL = list()
		for(var/turf/T in A)
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					NL += T
		src.loc = pick(NL)
		*/
	if(src.mind.assigned_role == "Cyborg")
		src << "YOU ARE GETTING BORGED NOW"
		src.Robotize()
	else
		src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
		/*var/obj/item/weapon/storage/backpack/BPK = new/obj/item/weapon/storage/backpack(src)
		new /obj/item/weapon/storage/survival_kit(BPK)
		src.equip_if_possible(BPK, slot_back,1)*/


	/*
	spawn(10)
		var/obj/item/weapon/camera_test/CT = new/obj/item/weapon/camera_test(src.loc)
		CT.afterattack(src, src, 10)
		var/obj/item/weapon/photo/PH
		PH = locate(/obj/item/weapon/photo,src.loc)
		if(PH)
			PH.layer = 3
			src.equip_if_possible(PH, slot_in_backpack)
		del(CT)*/ //--For another day - errorage
	return


/mob/living/carbon/human/proc/spawnId(rank)
	src.pincode = rand(10000,99999)

	if(getBalance(src.ckey) != "no key found")
		src << "\blue Your bank PIN is [src.pincode] and you have Ð[getBalance(src.ckey)] on your bank account.<br><br>"
	else
		src << "\blue Your bank PIN is [src.pincode] but unfortunately you do not have a bank account. To get one, <a href=\"http://d2k5.com/threads/how-to-get-a-bank-account.879/\" target=\"_blank\">click here</a>.<br><br>"
	src.mind.store_memory("Bank PIN: [src.pincode]")

	var/obj/item/weapon/card/id/C = null
	switch(rank)
		if("Cyborg")
			return
		if("Captain")
			C = new /obj/item/weapon/card/id/gold(src)
		if("Head of Personnel")
			C = new /obj/item/weapon/card/id/hop(src)
		if("Head of Security")
			C = new /obj/item/weapon/card/id/hos(src)
		if("Chief Engineer")
			C = new /obj/item/weapon/card/id/ce(src)
		if("Research Director")
			C = new /obj/item/weapon/card/id/rd(src)
		if ("Chief Medical Officer")
			C = new /obj/item/weapon/card/id/cmo(src)
		if("Chaplain")
			C = new /obj/item/weapon/card/id/chaplain(src)
		if("Roboticist")
			C = new /obj/item/weapon/card/id/dkgrey(src)
		if("Geneticist")
			C = new /obj/item/weapon/card/id/gene(src)
		if("Scientist")
			C = new /obj/item/weapon/card/id/sci(src)
		if("Medical Doctor")
			C = new /obj/item/weapon/card/id/med(src)
		if("Virologist")
			C = new /obj/item/weapon/card/id/viro(src)
		if("Botanist")
			C = new /obj/item/weapon/card/id/hydro(src)
		if("Chemist")
			C = new /obj/item/weapon/card/id/chem(src)
		if("Quartermaster")
			C = new /obj/item/weapon/card/id/qm(src)
		if("Mail Sorter")
			C = new /obj/item/weapon/card/id/qm(src)
		if("Security Officer")
			C = new /obj/item/weapon/card/id/sec(src)
		if("Detective")
			C = new /obj/item/weapon/card/id/det(src)
		if("Station Engineer")
			C = new /obj/item/weapon/card/id/engie(src)
		if("Miner")
			C = new /obj/item/weapon/card/id/engie(src)
		if("Atmospheric Technician")
			C = new /obj/item/weapon/card/id/atmos(src)
		if("Chef")
			C = new /obj/item/weapon/card/id/ltgrey(src)
		if("Barber")
			C = new /obj/item/weapon/card/id/dkgrey(src)
		//if("A.I.")
		//	C= new /obj/item/weapon/crowbar(src) // :smug: I wonder if this will fix ai late spawns- Nernums (ohgoddontmakeitworseplox)
		else
			C = new /obj/item/weapon/card/id(src)
	if (rank != "Prisoner")
		if(C)
			C.registered = src.real_name
			C.assignment = rank
			C.name = "[C.registered]'s ID Card ([C.assignment])"
			C.originalckey = src.ckey
			C.pincode = src.pincode
			C.access = get_access(C.assignment)
			src.equip_if_possible(C, slot_wear_id)

	if (rank != "Prisoner")
		src.equip_if_possible(new /obj/item/device/pda(src), slot_l_store)
		src.equip_if_possible(new /obj/item/weapon/storage/backpack(src), slot_back)
		src.equip_if_possible(new /obj/item/weapon/storage/survival_kit(src.back), slot_in_backpack)
		//src.equip_if_possible(new /obj/item/weapon/reagent_containers/food/drinks/water(src), slot_l_store)
		src.equip_if_possible(new /obj/item/weapon/storage/walletpocket(src), slot_r_store)

	if (istype(src.slot_l_store, /obj/item/device/pda))
		var/obj/item/device/pda/pda = src.slot_l_store
		pda.owner = src.real_name
		pda.ownjob = src.wear_id.assignment
		pda.name = "PDA-[src.real_name] ([pda.ownjob])"
/*
	if (istype(src.r_store, /obj/item/device/pda))  //damned mime PDAs not starting in belt slot
		var/obj/item/device/pda/pda = src.r_store
		pda.owner = src.real_name
		pda.ownjob = src.wear_id.assignment
		pda.name = "PDA-[src.real_name] ([pda.ownjob])"
*/
	//if (rank == "Clown")
	//	spawn clname(src)
	//idiots put the above in

/client/proc/mimewall()
	set category = "Mime"
	set name = "Invisible wall"
	set desc = "Create an invisible wall on your location."
	if(usr.stat)
		usr << "Not when you're incapacitated."  // grammar failure fix --snipe
		return
	if(!usr.miming)
		usr << "You still haven't atoned for your speaking transgression. Wait."
		return
	usr.verbs -= /client/proc/mimewall
	spawn(100)
		usr.verbs += /client/proc/mimewall
	for (var/mob/V in viewers(usr))
		if(V!=usr)
			V.show_message("[usr] looks as if a wall is in front of them.", 3, "", 2)
	usr << "You form a wall in front of yourself."
	var/obj/forcefield/F =  new /obj/forcefield(locate(usr.x,usr.y,usr.z))
	F.icon_state = "empty"
	F.name = "invisible wall"
	F.desc = "You have a bad feeling about this."
	spawn (300)
		del (F)
	return

/client/proc/mimespeak()
	set category = "Mime"
	set name = "Speech"
	set desc = "Toggle your speech."
	if(usr.miming)
		usr.miming = 0
	else
		usr << "You'll have to wait if you want to atone for your sins."
		spawn(3000)
			usr.miming = 1
	return
