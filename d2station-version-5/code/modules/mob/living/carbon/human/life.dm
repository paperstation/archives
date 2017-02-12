var/mob/living/carbon/human/cycle = 0
var/mob/time_of_death = 0
var/mob/timeofdeathtemp = 0


/mob/living/carbon/human
	var
		oxygen_alert = 0
		toxins_alert = 0
		fire_alert = 0
		temperature_alert = 0
		tempstate = 0
		paytime = 0
		var/icon/Icon = null
		old_intent = null
		old_item_name = null
/mob/living/carbon/human/New()
	spawn mousepointer()
	..()


/mob/living/carbon/human/proc/mousepointer()
//	var/tickertime = world.timeofday
	sleep(1)
	var/obj/item/item_in_hand = src.get_active_hand()
	if(client)
		if(item_in_hand)
			if(old_item_name == item_in_hand.name && a_intent == old_intent)
			//	world << "same item"
				sleep(-1)
				spawn mousepointer()
				return
			var/icon/Icon2 = null
			if (a_intent == "help")
				Icon2 = new('mouse.dmi',icon_state = "help")
			else if (a_intent == "hurt")
				Icon2 = new('mouse.dmi',icon_state = "hurt")
			else if (a_intent == "grab")
				Icon2 = new('mouse.dmi',icon_state = "grab")
			else if (a_intent == "disarm")
				Icon2 = new('mouse.dmi',icon_state = "disarm")
			Icon = new(item_in_hand.icon,item_in_hand.icon_state)
			Icon2.Blend(Icon,ICON_OVERLAY,x=18,y=-18)
			src.client.mouse_pointer_icon = Icon2
			old_item_name = item_in_hand.name
			old_intent = a_intent
			//world << "changed pointer with item"
		else
			var/icon/Icon2 = null
			if (a_intent == "help")
				Icon2 = new('mouse.dmi',icon_state = "help")
				src.client.mouse_pointer_icon = Icon2
			else if (a_intent == "hurt")
				Icon2 = new('mouse.dmi',icon_state = "hurt")
				src.client.mouse_pointer_icon = Icon2
			else if (a_intent == "grab")
				Icon2 = new('mouse.dmi',icon_state = "grab")
				src.client.mouse_pointer_icon = Icon2
			else if (a_intent == "disarm")
				Icon2 = new('mouse.dmi',icon_state = "disarm")
				src.client.mouse_pointer_icon = Icon2
			old_item_name = null
			old_intent = a_intent
			//world << "changed pointer with intent"
//	var/timetaken = world.timeofday - tickertime
	//world << "Time taken to complete mouse pointer check: [timetaken]"
	spawn mousepointer()
	return

/mob/living/carbon/human/proc/mind_initialize(mob/G)
	mind = new
	mind.current = src
	mind.key = G.key
	mind.special_role = "Changeling"


/mob/living/carbon/human/Life()


	set invisibility = 0
	set background = 1
	cycle++
	if(!loc)			// Fixing a null error that occurs when the mob isn't found in the world -- TLE
		return

		old_intent = a_intent
	if (monkeyizing)
		return

	if(changeling_level > 0)
		handle_changeling_regen()

	if(stat != 2)
		time_of_death = 0
	else
		time_of_death++

	if(time_of_death >= 100 && !cycle%15)
	//	world << "DEBUG - slow cycling beginning"
		return


	blinded = null

	handle_regular_status_updates()

	var/datum/gas_mixture/environment = loc.return_air()


	if (stat != 2) // if not dead, dont call these specific procs
		//handle_blood_loss()

		//MUNNAHMUNNAHMUNNAH
		if(src.client)
			handle_payday()

		//stuff in the stomach
		handle_stomach()

		//
		handle_drugs()

		//Disabilities
		handle_disabilities()

		if(cycle%3)
			spawn(0)
			breathe()



	bruteloss = round(bruteloss, 0.1)
	toxloss = round(toxloss, 0.1)
	oxyloss = round(oxyloss, 0.1)
	fireloss = round(fireloss, 0.1)
	health = round(health, 1)

	//Mutations and radiation
	handle_mutations_and_radiation()


	handle_virus_updates() // omg a miracle

/*	odd bug stops it curing or removing the disease.
	if(src.viruses.len > 3)
		world << "DEBUG: Virus list longer than 3"
		for(var/datum/disease/D in src.viruses)
			if(D.why_so_serious == 0)
				if(viruses.len < 4)
					return
				world << "DEBUG:Removing 0"
				D.cure(0)
				sleep(10)
				if(viruses.len < 4)
					return
			else if(D.why_so_serious == 1)
				if(viruses.len < 4)
					return
				world << "DEBUG:Removing 1"
				D.cure(0)
				sleep(10)
				if(viruses.len < 4)
					return
			else if(D.why_so_serious == 2)
				if(viruses.len < 4)
					return
				world << "DEBUG:Removing 2"
				D.cure(0)
				sleep(10)
				if(viruses.len < 4)
					return
			else if(D.why_so_serious == 3)
				if(viruses.len < 4)
					return
				world << "DEBUG:Removing 3"
				D.cure(0)
				sleep(10)
				if(viruses.len < 4)
					return
			else if(D.why_so_serious == 4)
				if(viruses.len < 4)
					return
				world << "DEBUG:Removing 4"
				D.cure(0)
				sleep(10)
				if(viruses.len < 4)
					return
			else
				if(viruses.len < 4)
					return
				world << "DEBUG:Removing others"
				D.cure(0)
				sleep(10)
				if(viruses.len < 4)
					return
	*/
	//Handle temperature/pressure differences between body and environment
	handle_environment(environment)



	handle_regular_hud_updates()

	//Changeling things
	if(client)
		if (mind)
			var/do_once
			if (mind.special_role == "Changeling")
				handle_changeling()
			if (stat == 2 && mind.special_role == "Changeling" && !do_once == 1)
				if(prob(80))
					src:removePart("arm_left")
				if(prob(80))
					src:removePart("arm_right")
				if(prob(80))
					src:removePart("leg_left")
				if(prob(80))
					src:removePart("leg_right")
				if(prob(80))
					src:removePart(src.organ_manager.head)
				do_once = 1
	//Chemicals in the body
	handle_chemicals_in_body()

	// Update clothing
	update_clothing()

	//Being buckled to a chair or bed
	check_if_buckled()

	mob_lighting()

	// Yup.
	update_canmove()

	stunned = max(min(stunned, 100),0)
	paralysis = max(min(paralysis, 100), 0)
	weakened = max(min(weakened, 100), 0)
	sleeping = max(min(sleeping, 100), 0)
	bruteloss = max(min(bruteloss, 100), 0)
	toxloss = max(min(toxloss, 100), 0)
	oxyloss = max(min(oxyloss, 100), 0)
	fireloss = max(min(fireloss, 100), 0)
	health = max(min(health, 100), -400)


	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()


	//Check if the person should get lit on fire
	check_ignition()

	//Being on fire
	if(src.flaming)
		src.flaming -= 0.3
	if(src.flaming <= 0)
		src.flaming = 0

	// being cool
	if(src.frozen)
		src.frozen -= 0.3
	if(src.frozen <= 0)
		src.frozen = 0

	..() //for organs



/mob/living/carbon/human
	proc

/*		handle_bloodpressure()
			calculate_bloodpressure()
			if(heartrate < 5)
				if(!arrhythmia)
					arrhythmia = 1
			if(heartrate > 300)
				bruteloss++
				if(prob(bruteloss))
					arrhythmia = 1
			if(stat == 2)
				heartrate = 0
					//Effectively flatlined
			diastolic = (systolic / 2) + 20

			switch(systolic)
				if(0 to 4) //Lol no heartrate I guess hur hur
					oxyloss += 15
					bloodstopper = 1
				if(5 to 49) //Severe Hypotension
					if(prob(40))
						sleeping += 10
					oxyloss += 2
					bloodstopper = 1
				if(50 to 79) //Light Hypotension
					//?
				if(80 to 139) //Normal
					//?
				if(140 to 179) //Hypertension
					if(prob(20))
						src << "\red You have a seizure!"
						for(var/mob/O in viewers(src, null))
							if(O == src)
								continue
							O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
						paralysis = max(10, paralysis)
						make_jittery(1000)
					if(!thrombosis)
						if(prob(70))
							give_thrombosis()
				if(180 to INFINITY) //Death
					death()
*/

/*		calculate_bloodpressure()
			systolic = (blood/300) * ((heartrate - 20) * 2) //Base
			systolic += circ_pressure_mod
			if(circ_pressure_mod > 0)
				circ_pressure_mod--
			else if(circ_pressure_mod < 0)
				circ_pressure_mod++
			systolic += (bloodthickness - 5)*10
*/
		mob_lighting()

			luminosity = 0
			for(var/obj/item/A in lum_list)
				if(A.Luminosity)
					luminosity += A.Luminosity
			if(luminosity == archived_lum)
				return

			ul_SetLuminosity(luminosity)
			archived_lum = luminosity


		handle_changeling_regen()
			if(changeling_level > 0)
				if(toxloss > 0)
					toxloss -= 15
				if(oxyloss > 0)
					oxyloss -= 15
				if(bruteloss > 0)
					bruteloss -= 15
				if(src.flaming > 0)
					fireloss += 15
				if(src.cloneloss > 0)
					cloneloss -= 15
				if(sleeping > 0)
					sleeping -= 1
				if(stunned > 0)
					stunned -= 1
				if(paralysis > 0)
					paralysis -= 1
				if(weakened > 0)
					weakened -= 1

		clamp_values()
			stunned = max(min(stunned, 100),0)
			paralysis = max(min(paralysis, 100), 0)
			weakened = max(min(weakened, 100), 0)
			sleeping = max(min(sleeping, 100), 0)
			bruteloss = max(min(bruteloss, 100), 0)
			toxloss = max(min(toxloss, 100), 0)
			oxyloss = max(min(oxyloss, 100), 0)
			fireloss = max(min(fireloss, 100), 0)
			health = max(min(health, 100), -400)

		handle_disabilities()
//			if(zombie == 1)
//				return

			if(mutations & 32768)
				if(!(flags & TABLEPASS))
					flags |= TABLEPASS
			else
				if(flags & TABLEPASS)
					flags &= ~TABLEPASS

			if(mutations & 1024)
				if(!(/mob/living/carbon/human/proc/morph in src.verbs))
					src.verbs += /mob/living/carbon/human/proc/morph

			if(mutations & 64)
				if(!(/mob/living/carbon/human/proc/remoteobserve in src.verbs))
					src.verbs += /mob/living/carbon/human/proc/remoteobserve

			if(mutations & 512)
				if(!(/mob/living/carbon/human/proc/remotesay in src.verbs))
					src.verbs += /mob/living/carbon/human/proc/remotesay

			if(mutations & 4096)
				if(!(/mob/living/carbon/human/proc/EatItem in src.verbs))
					src.verbs += /mob/living/carbon/human/proc/EatItem

			if (mutations & 32768) // unnecessary processing fix
				if(prob(15) && stat != 2)
					src.bruteloss -= 4
					src.fireloss -= 4
					src.oxyloss -= 4
					src.toxloss -= 4
					src.cloneloss -= 4
					src.updatehealth()
				else if(src.stat == 2)
					sleep(rand(100,600))
					for(var/mob/O in viewers(src, null))
						O.show_message("\red [src]'s body twitches and turns warm!", 1) // http://www.youtube.com/watch?v=1GESmPxKv1k
					src.visible_message("")
					src.rejuvenate()
					src.stat = 0
					src.sleeping = 0
					src.lying = 0
					src.weakened = 0
					src.updatehealth()
					src.mutations = 2 // incase of frozen
					src << "\blue <B>You are ripped from death's clutches, but you appear to have lost your power.</B>"
					src.nodamage = 1 // incase they're in space or some shit
					sleep(600)
					src.nodamage = 0
					src.mutations = 0
					src << "\red <b> Your rejuvenation invulnerability wears off!</b>"



			if (disabilities & 2)
				if ((prob(1) && paralysis < 1 && r_epil < 1))
					src << "\red You have a seizure!"
					for(var/mob/O in viewers(src, null))
						if(O == src)
							continue
						O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
					paralysis = max(10, paralysis)
					make_jittery(1000)
			if (disabilities & 4)
				if ((prob(5) && paralysis <= 1 && r_ch_cou < 1))
					drop_item()
					spawn( 0 )
						emote("cough")
						return
			if (disabilities & 8)
				if ((prob(10) && paralysis <= 1 && r_Tourette < 1))
					stunned = max(10, stunned)
					spawn( 0 )
						switch(rand(1, 3))
							if(1)
								emote("twitch")
							if(2 to 3)
								say("[prob(50) ? ";" : ""][pick("DWARFS","MAGMA","ARMOK","BERR","APPLES","SPACEMEN","NINJAS")]!")
						var/old_x = pixel_x
						var/old_y = pixel_y
						pixel_x += rand(-2,2)
						pixel_y += rand(-1,1)
						sleep(2)
						pixel_x = old_x
						pixel_y = old_y
						return
			if (disabilities & 16)
				if (prob(10))
					stuttering = max(10, stuttering)
			if (src.brainloss >= 60 && src.stat != 2)
				if (prob(7))
					switch(pick(1,2,3,4,5,6))
						if(1)
							say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that faggot traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "apricot", "appricuts", "apricots", "arpicot", "apricwt", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH MONKIES", "stop grifing me!!!!", "SOTP IT#"))
						if(2)
							say(pick("fucking 4rries!", "stat me", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "HOW DO CANISTER COMFBUST????//", "why was i fucking gibbed???", "can i be a allin", " i am so going to turn that dick face to monkey", " You know thats illegal right", "HI YOU BITCH MOTHER FUCKING HORE! HOWS IT GOING?", "I DONT CARE IF YOU IGNORE ME OR NOT I SWEAR I WILL FUCKING GET YOU ONE DAY ON MY SERVER", "HOPE TO DIE EVERY ROUND OR BE TURNING INTO A MONKEY OR SOMETHING", "Oh so your posting that shit again? ", "Dude im so gonna find a way to shut u guys down or something", "Ok rly? You think im stupid?It doesntwork"))
						if(3)
							emote("drool")
						if(4)
							say(pick("im tokng on teh computer!!11!! bap bop 1010010 101010101 01010101 means i lik dik", "vota dongs", "imm some kind of gay rodent", "imm some kind of gay emoticon u apear to b gaeyr than i", "i mis da god old days where i cud choke down a 1to oz dong at teh corner pokery", "but i dont mis da part where u wak mah nuts wit a stik for forty minute stretchas", "im half of wit a luky rewards card", "im instructng others not to chak u for riepnes u r da kng of mah pants", "imm teh captane of ur bals", "wa haev a witnes taht can plaec ur dong in teh sme naighborhod as mah faec last juley 4th", "hgalhalgahlguahuglah lgaglahlahgulahlahglag", "its liek iva got da gay taht just wont u ned gay away", "sir ima ned an answar to mah question bfore da gay overwhelms me", "holey crap - zero g means i can finaly realiez mah cok sukng drems", "wal da saefway lady clames she has no ieda if ive purchaesd an aedquaet ratio of tisue paepr / hustlars", "lord god ur bangng mah yarmulked head aganest da incienrator", "po po po po po po po po po po po po im stuk in a po lop", "note to mysalf bobs", "hm-marad taht maans imm a wana b hm taht has straeyd from teh righteos path k it means imm drunk", "taht si not a conundrum taht si a gay drem", "i dont fukng understand wut si wrong wit u dont know about u but id liek tori spelng to giev ma soma 9-0-to-1-oral sax", "i think diaepr humour si gong to sky rokat over teh naxt few weks", "wel long story short theyre si no such thng as dongazien and imm stil overweight and mah mouth hurts", "do u evar pis in ur fat mouth and then go blughlbuhlguhbluhglu imm a fountane", "try?!?? pis for a refreshng change of paec", "so anyway theyre i was in teh congo likng silverbak gorila u get so hufy whan it comes to teh u rilly stabng me in da faec and groin wit taht balpoint pen", "perhaps teh answer to da gentlamans question leis hera in mah pants teh answer si cok", "fuk! u and lik dik", "now il nevar b a crip (or a blod or wut u fags aer)", "lik dik old ban!!", "note heart stil gong on", "christ mah turbans on fier", "i think thes dot si to big i canot lift mah gay haad", "shut ur caek hole get me out of jale and hump mah hip", "i liek to practiec bng gay in front of a miror", "note a god magician never chokes down teh sme dik twiec", "my dad pofad into a bat and flaped into mah rom and put his wng down mah pants", "i read lietrature on teh italian poka circa 179e", "im strageht out of compton", "hop hop hop hop hop hop hop", "evarytiem i rol thes d4 i get some squigley jew later", "im raachng mah hand under teh partition for coins/tokens", "instead of ag mcmufin they shud cal it eg mstufin b/c i cant stop stufin mah faec wit dik", "fol!1! jews dont haev dix!", "imm!!1!1!1!1!!1111!! a skilad imigrant wit a tei and a resume and a u r seriosley doublng or triplng da nougat", "id say a fat indian girl already has thre strieks aganest her", "o say can u hulashglahglahlgahglhalghulahg", "im flopng both mah pants pokets out and askng u to kis da buny on da nose", "gat taht man an iec cold prik", "hitlar had just ona bal u might say imm smokng marijuana right now and imm rilly fukng high", "imm hopng for teh slashdot efect on mah mouth faec", "imm a fresh mornng boner jerk me bfora u haev to go to work", "dix and prix baekd in teh oven and served to ma on a silver plater", "my mouth si toielt compliant", "ima smoke thes dope and se wut hapans fiev hokers!1!!1!?!??!1!! but but wate remembrng", "o christmas dong o xmas dong haulghalghlg", "bals hangng to low / caerful u put an eye out / giev tham rom to swng", "when faec rapng someone theres somethng to b sade for getng a god runng start", "sounds liek da nota pad and teh calculator r fightng agane!", "it1!1!!1!1!1! si schrodngers piza and si neither in ur apartment nor out of it and yet both at teh sme tiem", "im learnng a leson in polietnes diklikng also peis curiosley enough", "if i cud b any kind of flowar id b a big fat angry cok", "and i wud b teh huglurhlughrluh bird", "clmpng teh clown nose on mah dong and lokng for anyone elderly/comatose", "10 adm 1to we haev a diklikng in progras", "iva got two big boners and a microphone", "imm pg-1e", "dix ??!?! mora dix ! parhaps bigar dix stil u!!?? a stranga fagot aernt u fagot (lats haev gay sex)", "i sim jerkng", "also they r mah braasts not melons or jugs", "c0cks", "i wish to inspect ur aparatus", "i had ades bfore it was col", "i canot bleive da insolance !!", "al!!1!!1!!1!1111 u do si maek jokes and threaetn raep", "our nu oparatng system wil ofar dynmic dixukng and virtual coxukng", "okay imm intarceptng ur pakets and decodng ur secret gaynes so giev me money", "i se u scanng gay groups and givng out ur work numbr on chanel #fagot", "hulaghlua alhug halha glhaulg halg (breif bursts of diklikng)", "ow thes si not a flipbok thes si an actual r u bob hope cherng me up wit news from home and a whore", "i? wud liek to rula in favor of thes dog shit!!", "hulahglahgluahlhalghlag!1!! se andng wit a g si a more controled coxukng sesion it si a sceince man", "i wish i wera toielt traneed note teh ues of da subjunctiev indicatng a condition contrary to fact", "i ned to b pumped so ful of spurt taht i canot se u promiesd ubrdongs i onley se thes dirty buket of dongs here wut haev we wrought", "folks ive ben kiked of da raep survivors e-group i rilly fel liek i haev ben violaetd twiec wut kind of problem cud aver b involvad wit diklikng ", "i?1!! wil sue for teh right to lik ur dik (pushng roled-up constitution through hola)", "imm proped up liek a soldeir and stoped up liek a toielt", "wel cokmouthgif was exactley as advertiesd", "it si teh onley way teh po wil laarn", "lose lips lik dix", "i wil not b able to veiw ur to1mb avi atachment i had to abort teh download repeat abort teh download", "my boner leis over teh ocean mah boner leis over teh sea cal teh enclaev", "we r al watchng da dongs", "cud one of u plz giev me a bost so i can bter stok fiona aple", "hulbghulgdbhulbgdbghuldbgdhulbagdhlbgdhlugb", "imm?? seriosley invitng u to fuk mah faec", "if u dont mind plz remova ur dong from mah armpit", "so i signad up for joinng a panal colony but wel long story short it wasnt wut i thought it was gong to b", "dix u sade their was w8r on teh mon and instaad its just mora godmn plz halp me pik out a gown for da coxukers bal", "i aciedntaly spiled dopa smoke into mah mouth and lungs ten tiems", "diagnosis cinmon buns", "im dig dug and ima inflaet u until u pop", "the closast distance btwen two points si batng of !", "he!!1!!1! smiels evan though im punchng him usng him as a jakof fmiliar", "(i vote for mora suferaeg) (and les u get out of hare sir u haev contminaetd teh pol", "imm a po pet", "denzels usng a powerbok so u know da movei si faek right there", "bals??", "im telng u to twist padla 0 and u r twistng padle 1", "canadian boners taste liek mapla for some reason", "o lord mah intestiens r wrapad around mah gay shorts", "galahalalagahagalagagahagalag", "im dyng from diklikars diesaes", "my dong si wut u wud cal al dente", "wa shud start likng for teh nu year -> now <-", "pray for cok pray wit ma now let us pray for cok", "in teh movei se7en i plaeyd da guy on teh cot wit da tubs in his plz dont tel anyone about mah boner under teh table at thx much po sade popa bar", "ima laaev mah dong colng on teh windowsil1! ", "stephan kngs the pokng", "its showtiem at mah bals", "lift ur fukng fet when u wok otharwies w ii", "its not about likng dik its about likng dik under oath", "daar madona plz show me ur bobs agane c britney bc baxtret u maed us da laughng stok of da antier quadrant", "did someone say prison raep", "imm?! a short wied goth whos makng a cybrdiference!!", "also!1!!1! thes just in strageht from da front liens hualghlahlahgluag", "im stil onley thirty-fiev cents", "god lord get taht guy a dik stat hes in dikles dalirium", "man da pantalons", "its suker punch a quer month at ur northern california mazda deaelr", "i swear to god imm lois laen and those r not heroin nedlas", "if christopher reve gets to b paralyzed then i get to b crazy", "i wish i cud dial nien to get mah haad outsied of teh toielt", "im ofiecr dongalong", "i wil milk u colact ur egs and b ur baby duklng", "yes sir no sir sukng dik sir al mah cox in a big fat row sir", "coxlut dirt hole prik hound pis-scented spent hose ropy traejctory mopng jiz bal-shrievlng cowliek", "a tightly-wraped bundle of dix!!", "shud1! i get anothar bar", "ima kep u in a box b mah vaelntien", "thesa bombs r dropng courtesy of taco bl and pepsi! yo queiro taco bl! bom smash burn", "sir in da next stal r u masturbatng or batng egs for an omalete", "lets!?? go to teh mon and lik dik", "imm seriosley sugestng wa slurp and suk in a sincere pateint maner", "hurmpth purmpthkglk", "asflkjads flsd fsdlif (w#ur) (", "the pop dak si ful agane", "i wil drug u and fuk u wut?? yes il hold", "imm a limpwrithted jedi mathter uthng da forth", "jesus teh gaynes si overwhelmng", "i liek dik ?!!!??! do u!?? can u hear ma ??!!! helo ?!! i liek dik <-- se 1! i cheked da box", "arrg thes b marthas boneyardbluhh duh glormpth", "lak of hispanis on tv decreid a lietral brownout a virtual whietwash", "i wud liek to suk cox wit a -r for racursiev and a -f to b forced", "we can prik & we can poke wa can fuk & we can choka but da bst part of al hugalugah toielt sax", "fre tiem on ur hands?? think dik", "i wish to report an unliked dik in da northwest corner of mah pants !", "imm!1!! al ovar thes stand bak everybody huga gluag laug lagual", "i tok an oath to rom naar and far likng dix", "hugaolgulagalugalug algualgualgualguagu u know wut teh worst part about likng dik ??1!1!!?! pisng blod", "lets tok about dix now b/c we never tok about taht)", "its not mah fault taht ur braft of lbhalbhglbhalbhglbhlbhlbhlga", "holey god theyre they r glhblhgblhagblhgblghblhgblghb da dix da dix", "tryng!! to fist mysalf and faleng tryng agane some sucas", "holey christables", "onley!! god and da huble talescope know wut imm batng of to", "dmmit who lat hitler in", "warnng on lighter kep away from children how da fuk r thay suposed to get high? i wil hold teh lighter for them grow up and put da bong in ur mouth u godmn baby", "id liek to complane about thes porn viedo its got no jerkofabla girls or however u say it i dont know al teh legal mumbo jumbo", "if teh whole world lix dik in unison wud anyone b able to hear it ??!??! or wud it al just cancal out", "here?! in da lab were developng artificialy inteliegnt cox taht suk thamselves and also aach other holey god da experiemnt si out of control", "i!!1 luv girls averyone imm strageht hatng fags right now il brb mm hur lovng dik not gay people", "hay lets go to lunch together and slap aach othars dix wit chopstix", "ps when i come bak id liek to b caled g dog b/c i wil haev joiend a gang wit soma very od toielt-relaetd initiation rituals holey christables il bt there not a gang man m i pised wit jizy j", "b gay wit me now here under teh sink i wil tei a sponga to da pieps so when u bang ur head it hurts las plz do not eat teh dishwasher detergent stop playng wit da ant poison and pay atantion to mah atentionables luv me hulrhlghgluhgluhgulg *bonk* ow ow ow i shud haev teid taht sponga up thera", "shit wit ur haart and not just ur dumb as", "furrrrrrrrrrrrrrrrrp uncontrolable diarhea", "holey christ imm gay halo peopla gay", "godnight mon godnight nuts godnight fat guy at da end of da holey god murph burph", "dont lok at mah gay litla legs", "get ur head out from undarneath teh partition im tryng to ues da toielt and i find ur antis u kep sayng wal go to da mon but it never hapans quiet frankley i dont think humankind (especialy fags) wil ever leaev da atmosphere", "this aera si whiet and spaecliek but it si clearley da jon and not da lunar landscaep u promiesd", "standng on a chare and batng of hopng da vibrations resonaet through our intergalactic comunity and broadcast a masaeg to gay aleins (or as i liek to cal them mexicans)", "i think i know how to rafer to teh cox i suk thank u very fukng much", "how come i haevnt even treid to jerk of to mah nu porn 1!? a dielma (also an anaelma)", "im part of teh comite for placng nuts on top of other nuts u haev mah personal guarante of saefty and/or satisfaction cmon put em right here someday taht lien wil work", "avery tiem i raach into teh can teh prngles r farthar away !?? si thes some sort of quantum tubular phenomenon ", "somabody? bter tel mah nuts to shut up stop tokng shut up nuts seriosley people r lokng i wil not shut up no u do u do", "tha next tiem u hang a man maek sure hes hlug ahaghlag hlahu", "ive got to comb mah hare and leaev da stal liek a normal person!!1!!111!!1!1!1 nobody si starng at me!!", "if!!1!!11!1! we touch dix wil theyre b an arc? zzzzzzzzzzt prof positiev", "folks it turns out nantukat cranbry lemonaed botlacaps r just wied enough to fal down into da bong and creaet a tight seal which can onley b raleaesd wit a long pencil!1!!1 or chopstik caerful of teh splosh!11!1!! in ur fukng idiot faec!!", "it1!1!!1!! si caled a mouth and it si locaetd on mah faec do i ned to buy u a star map", "im an astrogator second dagre glhgalhablhubglhubahluablhugbalhblhuab", "my nma si rands rands rands i haev a plan plan plan to lik ur dik dik dik and lik it quik quik quik yes im stil a character on jarkcity", "lhlhlhlhlhlh im da greaetst coxuker avar to graec thes gods aarth", "parl can help ma ietraet over teh cox in a gievn stal mark each as suked or unsuked and sort them by length then i can b gay wit pis and go home and taek a u cordialy invietd (open card) to suk cok", "the absence of a definiet article in teh gerund phraes of taht sentence maans taht as a rasult of a danglng participla its not totaly claar how much dik i haev to suk durng da holidays", "haev a very bry christmas gat it? it sounds liek mery but it si in fact a diferent word words taht sound aliek but haev diferent meanngs r caled homophobs", "holey hurrrrrrr bhadbvlahlkr fvadh dfubdflbhdf bdfkjbjdajkl bjldjkbdfjkbjk fjdbjsa gaspng for are bhabsdfbkadfbl bh adklb dfbjdlbk dbj dfb cal da poliec thes si hurrrrrr bump bump bump ffffff medic", "its a bird!! its a whelchare! who pushed mr reva of da spaec nedla", "who! wants to watch me jark of to final fantasy vi ", "chers?1?!??!?? to prix1!1!1!! jers to lox/deadbolts", "stap one taek sok of step two jark it into sok step thre replaec sok", "i tinkle and than i stop tinklng and than aftar i pul mah pants up theras a sudan spurt of tinkle so wa al haev prostaet cancer", "and it turns out teh dix were hidng in da secret an frank hole teh antier tiem any questions", "b!?? gay wit me/us/tham", "i bnt ovar to pik up a nikal and spontaenosley did an aarosol squirt!!", "chokng!1!!11! down ten blak dix in ten blak minutas", "imm ready for mah next baerley legal any fukng day now wonderng exactley how hard it can b to grab soma runaway of teh stret and bnd her in varios poses and slap it around teh sme 50 paegs of phone sex ads taht haev ben runng since 198to it shud b baerley wekly", "curse u lary flynt productions", "i1! wil match u dik for dik and we wil se who si da crazeist", "imm startng to get hungry 1!??!1 whos up for prix", "okay?!? gang funy thngs taht can hapen at teh bach raady go coxukng pulng mah pants down faec bals undartow", "crumplng u up and dong u teh right way", "ladeis and gentlemen im floatng through spaec", "clik clik clik hi were tourists!1! clik clik wheres da gay bashng fence agane", "try?? as i might i canot wil teh bong to levitaet into da livng rom", "for da last tiem i was not bng gay in theyre i was simpley practicng for a play", "he and i were just hugng and tokng and hugng", "thesa gay magaziens r for an art project1! not batng of to", "i know tahts mah nme on teh maleng laebl but thes si not mah isua of hunk and furthermore im most certaneley inocent until provan guilty", "tahts right fuko u kep ur mouth shut if u know wut god for u teh nuts (to maek fier)", "lets go ried teh bong around teh hotal dng dng hi lady any male for ma no k blughlbughlubhglubhlgubhlu lok out stares atc", "i ned to know if u r mint or near mint", "i haev holes pokad in me renderng ma ueslas to colectors", "not a day goes by whera i dont jerk myself until i get a stomach ache", "my piano teacher told me to play a b-flat but instead i plaeyd a b-fat then i plonked out some b-gays plonk blonk donk bluh ho de bo shien then i fel of teh chare/bnch", "does st patriks day rilly maan i can ask any drunk irishman to lik mah dik", "shynas? si niec and / shynes can stop u / from likng al da dix in lief / u liek to bm bm sir in da next stal r u catchng mah drift", "sure?? lady il haev phone sax wit u!1!!1! squirt godnight1!1!! clonk ba-donk", "i think instead of misdemaanor misy eliots midle nma shud b huge fukng fatas", "cud we plz haev les anal sex?? thank u in da data center ??!? r we theyre yat and if so r their dix in da nu land", "b! gay wit me as we journey to teh centre of da bowl", "thank god for rofeis and handguns", "ima soil myself and u b teh borg and il b bil gaets and we can grope at each others as and nuts for half an hour (forty-fiev minutes)", "last night whiel i was aslep mah bonar davaloped a simple chat u simpley must agre to b gay wit me i insist taht we climb into da dik pit and do da job right first i wil climb into teh dumbwateer and u wil lower me down thes si teh big tiem and u r blokng progres i demand acas to da kngdom hluahgluahluag", "dong watch si a serios responsibility privaet if any escaep u r responsible", "i haev hunted down and sukad many an escaepd dong", "sometiems i wory about teh nations prik suply", "start countng prix at zero and u get an extra u r seriosley shievrng me timbrs", "who wants to practiec oral sex wit me", "its!!? loneley here without cox & bals", "if i ware html id b &mp", "by mah calculations theyre wud haev ben a sacond jizar thase ars and spurts and liens indicaet two saperaet and distinct dierctions", "when i say i liked 9 dix cud taht mean 8 or 10 or 9to5 b/c honestley thes tiem i dont remembr", "i gay robot", "huga gay dix!1! rilly pokng now!!", "i1!!111 wil rol quartars al night long but on teh way to bale u out i wil haev a big mac atak and tahts y u cant come home", "do u kik as? u lok liek u kik as daley", "sariosley can i eat it does it go in mah fukng mouth?! wut da deal here help ma out cheif show me da money u catch it once u catch it twiec u catch it wit ur luv u sure r forcng me to suk ur dik whoever u aer", "i had a drem taht i was a stupid character in a comic strip then po squirted out and taht was not a drem and imm up at 8e0 m wit da shets", "i was tokng to thes guy onley to raaliez it was mah reflection!1!! then it got al ripley and i thought i was smokng dope but it was da toielt w8r riplng!! and it was ma wit mah faec in teh craper da whole tiem! explane teh y of taht!", "my!1!!1!!1!1!11!! solar obsarvations for decembr 199 1 its bright to i can se mah own dik in teh miror e mah neighbors dogshit tastes tangy 4 im totaly incapable of getng an eraction", "i haev ben fierd from jarkcity for mah ufo bleifs now ive ben fierd from waldanboks for mah ufo bleifs!111!11!1!!11!! fierd from chevron for mah ufo bleifs nota and by ufo bleifs i refer to tit squezng bleifs webziens faec tough tiems", "it doesnt gat loudar than upercaes baaa", "so hes liek how about i pis in ur faec and imm al no thx so now imm soaekd", "folks da suns atmosphere has axpanded to engulf and destroy mercury and venus1 can we plz start workng on a huga spaecship?", "a!??! litle bird loked down on me and sade suk more dix which si wut brngs me to da present gantleman", "i wraped mah moms present (cokbok) and ur prasant (butplug) exactley da sme and now i cant tel them apart!!1!1!1 zany hijinks ensue", "i proposa a nu transport laeyr on teh intarnat it wil b dasigned specificaly for porn / gaynes / atc", "its a dog lik dog dik world out their and it si mah duty to point out taht theyre r just not enough dmn dix to lik ur wut part about i want to lik ur dik dont u understand", "i??! just want to liev mah lief and lik dix", "the!!1! cover of mah hitch-hiekrs guied says whenever i fel liek panikng i shud grab a dik and suk it!1!! thank god i can knel on thes towel and put out a sereis of shity cd-roms", "the towel si for catchng teh spurt sir u r so navee)", "perhaps bonghits wil fix mah maekfiel", "im a practitionar of da anceint oreintal art of dongagmi im foldng dongs in to swans and swans in to dongs", "haev i told u how much i luv ur fatnes laetley", "just?? cary on liek imm not hare glhgulhgulhgulhgulhg", "this says frapucino but it si clearley pis", "does nobody r taht son wal b forced into litla tents and concantration cmps!!1! and al our jarkcity humor wil b uesd aganest us in a court of cox??", "i!??!?! suspect i wil b found guilty of first dagre u cant send us out their wit taht gay bat flyng around", "its a hole city a city filed wit holes i understand im bng abstract hare but taht si mah nature", "wel obviosley cher doasnt think imm strong anough to bleive in luv wel watch this!1!! hlgubhlruhj0g9pthgi&hb9j", "its a smal world after al / its a smal world after al but it stil wont fit up mah as o wate - theyre it went", "with god as mah witnas im teh worst pokamon traneer ever", "i onley suk dik in self dafense and at teh bokstora", "punch me in da undarpants wud u liek some js!? i wil brb wit some js jjjjjjjjjjjj im just taht god punch me in da underpants", "om! om hualghlahgulahulag om", "i luv dik a lot (not alot but rathar a y r u hitng me wit taht malet", "i??!? cant dacied if i want gays in teh clergy or gays in da military11!! i sure as fuk want them out of mah /lesbians dierctory", "onley in merica can we b thes gay and not b kiled (although baetn saverely)", "to ur nuts c mah wut we want si ur faec ful of spurt and two prix on eithar sied of ur faec big smiels clik clik clik clik clik", "folks wel nevar ever ever ever evar aver ever fukng figure out wut spaec and teh unievrsa si for so lets lien up for burgers and porn and dope and blowjobs", "i! wud liek to b gay not onley in da past present and future tenses but also da pluperfect subjunctiev tanse", "i wud liek to cal mah mouth and bals to teh r u milkng ma im not of da bovien vareity!! i want a lawyer", "a si for fat b si for fat c si for fat flipng through thase cards it apears d through z si also for fat", "sung u for braach of dixukng (even though u ban sukng mah dik at 9 m every day right on schadule)", "o god i suk dik in mah slep", "concantraet on mah voiec son u wil b gay", "yay for mah bals", "cud someone point me to teh neaerst cacha of dix", "gues wut i found today?!??!? tahts right1 i found teh po buton!", "alow!!1! me to show u teh path to wisdom and nirvana and al taht gay u know in angland gay people hang out in da lavatory and coxukng si calad bangers and mash also dont ordar a pint of bim wilng to b gay at low low priecs", "imm a bright shiny angel of god sent down from heaevn to lik dik in da toielt glory b", "there was thes one dik taht wudnt stay u four hundred pounds and u haev a keychane wit a raep whistla ive got half a mind to raep u on principle", "i haev a two-prik system whare if one spurts i can continua sukng on da spaer", "il haev a croisandwich and a glas of raep", "i dont know y they cal it a concentration cmp i certaneley cant concentraet on anythng but al da dix paked closeley to mah faec in thes trane plz explane y avaryone thinks mah mouth si a urinal", "okay people its 4e0 in teh mornng and imm stil a completa fagot thes bter wear of", "i specificaly chekad cowboy boner not a fukng xmas bonar", "cud wa plz haev a moment of sielnca for mah boner", "how?? to eat shit an esay chapter ona eatng shit", "wel i tmed teh boner monster!1 who wants to pat it", "glug??!?? ma down and laftwies and rima lik ur dik from 710 to 714 at which point u wil gum up teh works and tip ma a woden nikel which i wil promptley eat", "im likng dix in a paepr bag", "just btwen u and me im wilng to b gay wit u and u and u and u and u pas it on", "hikory dikery dix / imm stufng mah faec wit prix / drink pepsi", "if i cud jerk of to one thng id jerk of to u u and u and u under thara", "i cal it photoslop1!!1! and adob masturbator!!1!!1 and macromedia crash!!1 ahahah doas anyone gat mah jokas?!?1! join teh tierd coxuker webrng", "listan up lordy god and listen god cos u got a lot of axplaneng to do first y did u spraad al teh unliked dix acros contiennts second do u validaet parkng", "jesus!?? i was lost their for a second then i smeled taht distinct smel of just liked dik", "saturdays r for jerkng also clmpng hmmerng and squezng cary on", "lets not fight lets hug for forty minutes nude", "does da f on mah report card stand for farts or faleure", "if?!! theyre were no blak man theyre wud b no blak sperm to maek mora blak baby girls to grow up into blak porn stars and tahts y racism si bad and hitlar si u lokng prety hot in taht jumpsuit <sfx raep>", "id liek to request taht wa no longer boldley go into da cabin whare im raepd for sceintific purposas", "hare we aer! i told u it wasnt just another trik to get u into teh u r to fat around teh fat around and we r stuk endlesley orbitng each other in spaec a wordles grope ensues", "christ imm hard up for hardons", "the lago company doas not andorse teh lego holocaust artwork sendng bak mah legotown gas chmbr / skaletons kit", "o yeah il b da preteist girl in preskool wate second r u r of how hard it si to say no to spaec cowboys?!? i can saev myself by soilng myself and hare i go", "coxukng 101 first stroke teh dik tel da dik u luv it second kis teh dik do it lightley liek ur kisng somaone for da first tiem third fukng suk da dik liek u never sukad bfore if u pas out tahts al right u come to evantualy", "imm briliant1111!!1!!1!!11! da bals aet mah bals paeg!1!!1!!11!!1!111!! we shud totaly do it!!", "imm!!1!11!1!!11!! so sory for everythng taht hapened it si mah fault b/c it was mah project and now b/c of me ware hare now hungry cold and hunted imm so scaerd ima dei out hera hualgalhlahulahlag", "mister bluebird / on mah shuder / rapng him", "ima lik these stona cold dix", "po inspection (hold stil)", "po a bowl of", "my $0to!! in teh blab rom!1!! whera imm soundng of and tokng bak and speakng out liek a fat fukng merican idiot!1 its mah right to expres myself!!1!! hurrr hot urien and broken glas", "i masturbaet just about daley sometiems twiec if somethng sets me of liek an entertanement tonight sagment on supermodals or da maleman u haev to b wilng to go down taht path and find ur iner masturbator and convince him to get into teh zone and go for teh gold if not teh gold then perhaps a handful of semen", "sometiems when i go on busiens trips or vacations i dont gat a chance to masturbaet when u stomp around a strange city al day and come bak to an impersonal hotal rom its hard to get it on hares a tip pak somethng soft to spurt into laaev it in teh rom aftar u chek out", "did i mention i was molasted?? imm praty sura i did once or twiec but u did not ofer to discus teh matar wit ma lats haev a niec queit diner and haev a frank discusion about mah dads dong and how he put it in mah mouth and as now and then anyway imm clearley da victim here and tahts y i dont suk dik hopa u undarstand", "the hils r aliev wit teh sound of bonars", "with pischrist as mah witnes im da man wit da plan it goes somethng liek thes first we lik teh wang then we lik da wang some mora (to b sura)", "now i dont want to get into da specifis but semen has an oyster-liek consistancy and stngs when it driblas of mah stupid faec and into mah eyes holey christ it u can met da most intarestng peopla masturbatng in teh bathroms of mals and department stores go to ur towns emporium durng ur lunch hour and hang out if ur not particular theres always arbys", "for teh most part u can determien how many tiems per yaar u masturbaetd pik a year teh batle bgan and an aevraeg numbr of sesions per day consiedr this when al da numbrs r multipleid out u can then detarmien how much seman u generaetd enough to drown a todlar!? hm", "apaerntley?? i canot charge mael escorts to mah liberry card", "rough closeted sax k not al taht closeted and las rough than ona might expact", "hands up who here has tasted theyre own jiz guzlng othar peoplas jiz doesnt count", "boy haev i learned teh rules of dik location location location", "i spy wit mah litle eye nothng thx to ur sharp stik", "sory for teh spm but cox cox cox cox cox cox", "who aet thre cartons of peanut buter iec cram and tok a dump on mah bdspraad", "tha cokmobiel wil come to mah town soma day then i can suk dix from faraway lands and local cox taht i know and lova", "hapy memorial day dont forget to laugh at a disabled veteran thay kiled inocent childran for u sex rilly not enjoyng thes to much homosexual sex prison homosaxual sex stratchmarks around teh mouth aera o hi imm just flipng through da index of mah quer handbok holey god i can gat a merit badge just for bng jized up", "dont try to fol me into not sukng it!1!!1! distractng me wil onley fale hulahgluag", "if i go to teh thre oclok metng and sit theyre and put mah nuts and wang on teh table plz promies taht u wil not taek teh blakjak and start batng teh crap out of mah axtremiteis", "even a stoped clok gievs head twiec a day y cant u? nothng perverted or gay about me wantng to open a boutique its a cok boutique wit litle bows and ribons but its not wut u think litla hats and costumes for teh pupet show i put on each mornng", "mm hurbla burble lok at me on mah way to skool i sure m gay tiem for cox", "ima suk ur cok until ur blue in da faec and imm not hungry anymore", "lok wut i can do without asistance from teh audeinca halughu lahglu haulghalughulagualughalugh laughlaugh luaglag alukg halgh laug luahglu hgalu hagl hlaug hlaghl ahglu halgh ag k i ned some help here huaghalgu halukg luagh luag perhaps a lader or a buket halughalghlu", "any kind of dik wil do but i prefer to chomp and chew on da northarn merican vareity for varios reasons/conditions seriosley if u cud just form a lien to da left of teh urinals il get to busiens", "it turns out nads si short for gonads which si slang for bals anyway i got kiked there", "actualy da bone taht conects mah nuts to mah wrist si spranead tahts mah jerkbona posibley mah jizbone imm not a doctor", "i asked u to wate thirty minutes bfore likng another dik ur gong to gat a horible pane in teh bly if i didnt know bter id swear u unliked tham on purpose", "how about u taek me chinman style (opium peng in mah coke riec raleroads laundry)", "wow dik for me", "im liek da sunflower hidng wit mah knes bunched up in teh toielt tryng to lok through da partition at other peoples pisng dix k mayb les liek a sunflower", "im tryng to draw a bong but it just loks liek a bonar1 gif after gif of boner after boner!1!! m i just gay? wriet bak", "webles woble but they dont suk dik", "helo?!??! yas thes si jerkcity y yes our refriegrator si runng wut? gr", "id btar jerk of for god wut do these nien dix haev to do wit teh priec of tea in china?!? il say1!! u al deserva a medal da brown medal (its brown)", "i spilad pis on mah nu carpat a litle jiz wil taek taht right out", "i haev taepd a cros to mah dor but stil teh dix come pourng in a night dear god how can i posibley worship u when u haev sent these thngs to pound around mah u?! wil b jacques from da soveit union and i wil play teh part of tery from canada and we r in an international toielt", "i prefer pei caek also iec crem i mentioned caek abova (previosly) also hostas products and products relaetd to teh hostes lien", "dot de do1! pakng mah suitcaes i luv england t-shirt!??!?!?? chek11!!1! faek fuked-up bukteth?!?!? chek knikars trouesrs jely babeis chek chek chek dong a funy wok to da areport!1 wavng teh union jak!1! vrrrrooom!1! up in da plaen blah blah tokng to everyone and spilng thngs and makng farts screeeeeach!! imm hera!!1!1!!1 finaly!1!1 da wastminster dong show!! aw crieky", "i tel u son u wil haev a box wit some po in it", "mods r liek ranebows in taht imm a coxukar", "whera haev al teh fagots gone?? i askad u a dierct question whara haev al da fpfhfhfhth found em", "it was liek i told u dix to teh left dix to da right then i say hay r u george michael? and of course ha runs out unlikad dix by da basket si al imm askng standard laundry hmper siezd baskets yes", "so po then", "is mumia fre yet?!?!? ive had thes bumper stiker on mah car for thre weks now", "knok knok seriosley here r some clean towals and bath oils and precios lotions and advanced skin conditioners and for gods saek let me coma in da bathrom wit u kep those cox out of mah garden or il knok ur blok of", "is taht a big fat dong in ur pants or r u just hapy to se me!??!!?!!1!!??! dont r just flop it out regardles", "i se u masturbatng liek ur lief depands on it and i say slow it down taek ur tiem also i met elvis in a paytoielt in goldan gaet park", "i cant se plz turn da lights on imm not sayng to not b gay just turn da lights up k turn tham of", "im so gay right now i dont think il ever come down wal of to da toielt i sade *of to da toielt*", "and so jesus cme out of teh caev and sade its k to b gay", "punch pound whap slap lash fencepost batngs frezngs shotngs and comuniteis comng togethar", "im swadish and drownng and askng for hjalp ja ja in der tjoielts", "sitng at da bus stop calculatng how to divied $50 in quartars btwen porno boths & snikers", "i axpres mah anger through mah potary and poetry and coxukng", "hahahah remembr whan bil gaets got cremed wit a pei??!!!1 o god ur blak dong si pushng me insied out practicaly", "sir u r pushng mah faec into a piel of dogshit sir in teh blua pants", "can wa play phantom stalboth?? ho boy imm bored wut thes a cardboard stal honk bonk sudenley in toielt land urf duh learnng about numbrs and leters and jiz mathemajizmop?", "this!??!? si liek sesma stret but without teh sesme and quiet frankley theras not much stret aither so i guas its kind of a sasme raep (without teh sesme but wit axtra raep)", "i wud liek to ragister as a web devaloper and also a child molestor can i do both in da sme lien or u?? cant tel ma wit a strageht faec taht u never gievn head to anonymos mariens in da bak of a cmero wit queit riot playng can u?!? i thought wut does it mean when fngers and hands and arms and sometiems whole people find there way into ur stal and u suk tham al of", "the?!?? bals paeg heres a link to mah bals heres othar bals i think r col u can male mah bals here r mah bals agane in frme format thasa bals r a transpaernt gif89a these bals r under construction!1!!1!! plz excues teh nuts!!", "cut!!1! of mah motherfukng dik and stuf it into mah mouth and kik me down teh w8rslied", "1-80-urien isnt aven seven ddd o jesus ur soakng me", "pis fight (handng out dixei cups and splash guards)", "folks god si telng me to jerk of agane (in order to saev da unievrse)", "galagalhaglhalughalhulgag", "do u yaho?!??!? i yahod al over ur stupid fukng faec!111!!11!!1!!1!! up wit dik", "my penis doesnt work!!1!! whan i hit it wit a hmmer it doesnt squek anymore", "eight snikers l8r i haev diharea", "remembr taht tiem wa were gay wit aach other in da ups truk and then it tok of and teh dor slid shut and we want to vermont", "jimy! crak corn and i suk dik", "my latino pried si ofendad by ur boner", "this urien stane rilly teis teh rom togethar", "investigatiev repuhhhhhhhh pants down spraadng mah cheks lbhlahblahblabh liek a pac man", "if thes si teh 80s then imm jerkng it undar teh bd to panthoues in 10", "i saev evary scrap of porn b/c who knows wut il b into thre months down teh road", "i haev smokad myself u theyre no pukng on ur shoes", "has al wana pounda dope and i say yes sir and da next thng i know hes rilly poundng it into mah faec!1!1! then i realiez im da dopa", "im priemd and ready for gaynes", "every station plz giev me a go/no go for gaynas", "dear steve caes!!1!! i haev ban an aol mambr for thre days!!1 but mah south park sounds r broken/dont play", "my lava lmp told ma to shot da naighbors (and to smoke pot sit around)", "sielntley i dunk mah nuts into da cold toielt w8r hmm urrr", "whan i jerk of i fel god for about twenty seconds and then whm its right bak into suicidal plz overied mah virtual membr", "i haev isues wit mah fatnes mah gaynes mah loch nes monster", "i liek di_k (onley ona leter to go and u win teh priez)", "yay!1!! kevin si fre to rom da aarth and suk cok and get old and dei", "i jerk two dix bfore i jerk two dix it maeks me fel al right", "lego mah priko", "nbc shud cal teh show wangs and it shud haev mora dix in it", "sory i punched u in teh throat get u jizng up mah faec wit revolutionary spaec-aeg polymars", "hey everyone mupets r on and by mupets i mean fat plz plaec me on masturbatiev laaev", "whoavar si in charge of jiz plz angle it over yonder", "gakk ur hands r tight around mah fat nek", "to ma da bst thng about marijuana si taht everythng si just god enough", "i canot tel teh difarence btwen porn stars and sports paople dialng 10 10 heroin overdose", "can i plz haev a fag hug", "a! gang of mouths man teh batlastations men", "my mouth sha si for dix", "when i suk them of they grunt and go muhhh buhh duhh ", "wilng to b gay to pay extra to b extra gay but not wilng to pay axtra and onley get gay", "jakng of jakng up and down and out teh dor and down da blok for cigaertas diklikng mostley"))
						if(5)
							emote("fart")
						if(6)
							playsound(src.loc, 'fart.ogg', 40, 1)
							playsound(src.loc, 'squishy.ogg', 40, 1)
							new /obj/decal/cleanable/poo(src.loc)


		handle_mutations_and_radiation()

			if(fireloss)
				if(mutations & COLD_RESISTANCE || (prob(1) && prob(75)))
					heal_organ_damage(0,1)

			if (mutations & HULK && health <= 25)
				mutations &= ~HULK
				src << "\red You suddenly feel very weak."
				weakened = 3
				emote("collapse")

			if (radiation)
				if (radiation > 100)
					radiation = 100
					weakened = 10
					src << "\red You feel weak."
					emote("collapse")

				if (radiation < 0)
					radiation = 0

				switch(radiation)
					if(1 to 49)
						radiation--
						if(prob(25))
							toxloss++
							updatehealth()

					if(50 to 74)
						radiation -= 2
						toxloss++
						if(prob(5))
							radiation -= 5
							weakened = 3
							src << "\red You feel weak."
							emote("collapse")
						updatehealth()

					if(75 to 100)
						radiation -= 3
						toxloss += 3
						if(prob(1))
							src << "\red You mutate!"
							randmutb(src)
							domutcheck(src,null)
							emote("gasp")
						updatehealth()
		breathe()
			if(mutations == 32 || src.client && mind.special_role == "Changeling")	return
			if(src.reagents.has_reagent("lexorin")) return
			if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return

			var/datum/gas_mixture/environment = loc.return_air()
			var/datum/air_group/breath
			// HACK NEED CHANGING LATER
			if(src.health < 0)
				src.losebreath++

			if(losebreath>0) //Suffocating so do not take a breath
				src.losebreath--
				if (prob(75)) //High chance of gasping for air
					spawn emote("gasp")
				if(istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)
			else
				//First, check for air from internal atmosphere (using an air tank and mask generally)
				breath = get_breath_from_internal(BREATH_VOLUME)

				//No breath from internal atmosphere so get breath from location
				if(!breath)
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						breath = location_as_object.handle_internal_lifeform(src, BREATH_VOLUME)

					else if(istype(loc, /turf/))
						var/breath_moles = 0
						breath_moles = environment.total_moles()*BREATH_PERCENTAGE
						for(var/turf/T in range(src, 0))
							if(T.viruses.len > 0)
								for(var/datum/disease/D in T.viruses)
									contract_disease(D)
									//world << "contracted disease from air"
							else if(T.zone && T.viruses.len < T.zone.viruses.len)
								for(var/datum/disease/D in T.zone.viruses)
									contract_disease(D)
									//world << "contracted disease from air"
						breath = loc.remove_air(breath_moles)

				else //Still give containing object the chance to interact
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						location_as_object.handle_internal_lifeform(src, 0)

			handle_breath(breath)

			if(breath)
				loc.assume_air(breath)


		get_breath_from_internal(volume_needed)
			if(internal)
				if (!contents.Find(src.internal))
					internal = null
				if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
					internal = null
				if(internal)
					if (src.internals)
						src.internals.icon_state = "internal1"
					return internal.remove_air_volume(volume_needed)
				else
					if (src.internals)
						src.internals.icon_state = "internal0"
			return null

		update_canmove()
			if(lying || paralysis || stunned || weakened || buckled || changeling_fakedeath || (l_leg_op_stage == 3 && r_leg_op_stage == 3 && l_arm_op_stage == 3 && r_arm_op_stage == 3) || organ_manager.head != 1)
				canmove = 0
			else canmove = 1

		handle_breath(datum/gas_mixture/breath)
			if(src.nodamage || src.client && (src.mind.special_role == "Changeling" ))
				return

			if(!breath ||(health <= -299)|| (breath.total_moles() == 0))
				oxyloss += 2

				oxygen_alert = max(oxygen_alert, 1)

				return 0

			var/safe_oxygen_min = 12 // Minimum safe partial pressure of O2, in kPa
			//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
			var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
			var/safe_toxins_max = 0.5
			var/SA_para_min = 1
			var/SA_sleep_min = 5
			var/oxygen_used = 0
			var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

			//Partial pressure of the O2 in our breath
			var/O2_pp = (breath.oxygen/breath.total_moles())*breath_pressure
			// Same, but for the toxins
			var/Toxins_pp = (breath.toxins/breath.total_moles())*breath_pressure
			// And CO2, lets say a PP of more than 10 will be bad (It's a little less really, but eh, being passed out all round aint no fun)
			var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*breath_pressure

			if(O2_pp < safe_oxygen_min) 			// Too little oxygen
				if(prob(20))
					spawn(0) emote("gasp")
				if(O2_pp > 0)
					var/ratio = safe_oxygen_min/O2_pp
					oxyloss += min(5*ratio, 3) // Don't fuck them up too fast (space only does 7 after all!)
					oxygen_used = breath.oxygen*ratio/6
				else
					oxyloss += 3
				oxygen_alert = max(oxygen_alert, 1)
			else 									// We're in safe limits
				oxyloss = max(oxyloss-5, 0)
				oxygen_used = breath.oxygen/6
				oxygen_alert = 0

			breath.oxygen -= oxygen_used
			breath.carbon_dioxide += oxygen_used

			if(CO2_pp > safe_co2_max)
				if(!co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
					co2overloadtime = world.time
				else if(world.time - co2overloadtime > 120)
					src.paralysis = max(src.paralysis, 3)
					oxyloss += 1 // Lets hurt em a little, let them know we mean business
					if(world.time - co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
						oxyloss += 2
				if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
					spawn(0) emote("cough")

			else
				co2overloadtime = 0

			if(Toxins_pp > safe_toxins_max) // Too much toxins
				var/ratio = breath.toxins/safe_toxins_max
				toxloss += min(ratio, 10)	//Limit amount of damage toxin exposure can do per second
				toxins_alert = max(toxins_alert, 1)
				if(prob(3))
					radiation++ //Toxins can now radiate people.
			else
				toxins_alert = 0

			if(breath.trace_gases.len)	// If there's some other shit in the air lets deal with it here.
				for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
					var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure
					if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
						if(prob(1)) //Nerfed
							src.paralysis = max(src.paralysis, 3) // 3 gives them one second to wake up and run away a bit!
						if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
							if(prob(1)) //Nerfed
								src.sleeping = max(src.sleeping, 2)
					else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
						if(prob(20))
							spawn(0) emote(pick("giggle", "laugh"))


			if(breath.temperature > (T0C+66) && !(src.mutations & 2)) // Hot air hurts :(
				if(prob(20))
					src << "\red You feel a searing heat in your lungs!"
				fire_alert = max(fire_alert, 1)
			else
				fire_alert = 0

			return 1

		handle_environment(datum/gas_mixture/environment)
			if(!environment)
				return
			var/environment_heat_capacity = environment.heat_capacity()
			var/loc_temp = T0C
			if(istype(loc, /turf/space))
				environment_heat_capacity = loc:heat_capacity
				loc_temp = 2.7
			else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				loc_temp = loc:air_contents.temperature
			else
				loc_temp = environment.temperature

			var/thermal_protection = get_thermal_protection()
			if(stat != 2 && abs(src.bodytemperature - 310.15) < 50)
				src.bodytemperature += adjust_body_temperature(src.bodytemperature, 310.15, thermal_protection)
			if(loc_temp < 310.15) // a cold place -> add in cold protection
				src.bodytemperature += adjust_body_temperature(src.bodytemperature, loc_temp, 1/thermal_protection)
			else // a hot place -> add in heat protection
				thermal_protection += add_fire_protection(loc_temp)
				src.bodytemperature += adjust_body_temperature(src.bodytemperature, loc_temp, 1/thermal_protection)


			// lets give them a fair bit of leeway so they don't just start dying
			//as that may be realistic but it's no fun
			if((src.bodytemperature > (T0C + 50)) || (src.bodytemperature < (T0C + 10)) && (!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))) // Last bit is just disgusting, i know
				if(environment.temperature > (T0C + 50) || (environment.temperature < (T0C + 10)))
					var/transfer_coefficient

					transfer_coefficient = 1
					if(head && (head.body_parts_covered & HEAD) && (environment.temperature < head.protective_temperature))
						transfer_coefficient *= head.heat_transfer_coefficient
					if(wear_mask && (wear_mask.body_parts_covered & HEAD) && (environment.temperature < wear_mask.protective_temperature))
						transfer_coefficient *= wear_mask.heat_transfer_coefficient
					if(wear_suit && (wear_suit.body_parts_covered & HEAD) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient

					handle_temperature_damage(HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(UPPER_TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & LOWER_TORSO) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & LOWER_TORSO) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(LOWER_TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & LEGS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & LEGS) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(LEGS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & ARMS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & ARMS) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(ARMS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & HANDS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(gloves && (gloves.body_parts_covered & HANDS) && (environment.temperature < gloves.protective_temperature))
						transfer_coefficient *= gloves.heat_transfer_coefficient

					handle_temperature_damage(HANDS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & FEET) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(shoes && (shoes.body_parts_covered & FEET) && (environment.temperature < shoes.protective_temperature))
						transfer_coefficient *= shoes.heat_transfer_coefficient

					handle_temperature_damage(FEET, environment.temperature, environment_heat_capacity*transfer_coefficient)

			/*if(stat==2) //Why only change body temp when they're dead? That makes no sense!!!!!!
				bodytemperature += 0.8*(environment.temperature - bodytemperature)*environment_heat_capacity/(environment_heat_capacity + 270000)
			*/

			//Account for massive pressure differences
			return //TODO: DEFERRED

		adjust_body_temperature(current, loc_temp, boost)
			var/temperature = current
			var/difference = abs(current-loc_temp)	//get difference
			var/increments// = difference/10			//find how many increments apart they are
			if(difference > 50)
				increments = difference/5
			else
				increments = difference/10
			var/change = increments*boost	// Get the amount to change by (x per increment)
			var/temp_change
			if(current < loc_temp)
				temperature = min(loc_temp, temperature+change)
			else if(current > loc_temp)
				temperature = max(loc_temp, temperature-change)
			temp_change = (temperature - current)
			return temp_change

		get_thermal_protection()
			var/thermal_protection = 1.0
			//Handle normal clothing
			if(head && (head.body_parts_covered & HEAD))
				thermal_protection += 0.5
			if(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO))
				thermal_protection += 0.5
			if(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO))
				thermal_protection += 0.5
			if(wear_suit && (wear_suit.body_parts_covered & LEGS))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.body_parts_covered & ARMS))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.body_parts_covered & HANDS))
				thermal_protection += 0.2
			if(shoes && (shoes.body_parts_covered & FEET))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.flags & SUITSPACE))
				thermal_protection += 3
			if(w_uniform && (w_uniform.flags & SUITSPACE))
				thermal_protection += 3
			if(head && (head.flags & HEADSPACE))
				thermal_protection += 1
			if(mutations & COLD_RESISTANCE)
				thermal_protection += 5

			return thermal_protection

		add_fire_protection(var/temp)
			var/fire_prot = 0
			if(head)
				if(head.protective_temperature > temp)
					fire_prot += (head.protective_temperature/10)
			if(wear_mask)
				if(wear_mask.protective_temperature > temp)
					fire_prot += (wear_mask.protective_temperature/10)
			if(glasses)
				if(glasses.protective_temperature > temp)
					fire_prot += (glasses.protective_temperature/10)
			if(ears)
				if(ears.protective_temperature > temp)
					fire_prot += (ears.protective_temperature/10)
			if(wear_suit)
				if(wear_suit.protective_temperature > temp)
					fire_prot += (wear_suit.protective_temperature/10)
			if(w_uniform)
				if(w_uniform.protective_temperature > temp)
					fire_prot += (w_uniform.protective_temperature/10)
			if(gloves)
				if(gloves.protective_temperature > temp)
					fire_prot += (gloves.protective_temperature/10)
			if(shoes)
				if(shoes.protective_temperature > temp)
					fire_prot += (shoes.protective_temperature/10)

			return fire_prot

		handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
			if(nodamage || mind.special_role == "Changeling")
				return
			var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

			if(mutantrace == "plant")
				discomfort *= 3 //I don't like magic numbers. I'll make mutantraces a datum with vars sometime later. -- Urist

			switch(body_part)
				if(HEAD)
					TakeDamage("head", 0, 2.5*discomfort)
				if(UPPER_TORSO)
					TakeDamage("chest", 0, 2.5*discomfort)
				if(LOWER_TORSO)
					TakeDamage("groin", 0, 2.0*discomfort)
				if(LEGS)
					TakeDamage("l_leg", 0, 0.6*discomfort)
					TakeDamage("r_leg", 0, 0.6*discomfort)
				if(ARMS)
					TakeDamage("l_arm", 0, 0.4*discomfort)
					TakeDamage("r_arm", 0, 0.4*discomfort)
				if(FEET)
					TakeDamage("l_foot", 0, 0.25*discomfort)
					TakeDamage("r_foot", 0, 0.25*discomfort)
				if(HANDS)
					TakeDamage("l_hand", 0, 0.25*discomfort)
					TakeDamage("r_hand", 0, 0.25*discomfort)

		check_ignition()
			if (!flaming && !immunetoflaming)
				for(var/obj/hotspot/F in src.loc)
					if (prob(80))
						src.flaming += 5
			else if (flaming)
				for(var/obj/hotspot/F in src.loc)
					if (prob(80))
						src.flaming += 1.5
				switch(flaming)
					if(1 to 30)
						src.bodytemperature += 20
						src.take_organ_damage(0,0.5)
					if(30.1 to 60)
						src.bodytemperature += 30
						src.take_organ_damage(0,1)
					if(60.1 to INFINITY)
						src.bodytemperature += 40
						src.take_organ_damage(0,1.5)
				if (istype(src.wear_suit, /obj/item/clothing/suit/fire))
					src.flaming -= 0.7
				if (istype(src.wear_suit, /obj/item/clothing/suit/space))
					src.flaming -= 0.2
			return

		handle_chemicals_in_body()
			if(back)
				if(istype(back, /obj/item/weapon/reagent_containers/glass/large/iv_bag))
					var/obj/item/weapon/reagent_containers/glass/large/iv_bag/IV = back
					if(IV.reagents.total_volume && IV.tube && IV.tube.cannula)
						if(IV.drip_timer)
							IV.drip_timer -= 1
							IV.on_reagent_change()
						else
							IV.reagents.trans_to(src, IV:amount_per_transfer_from_this)
							IV.drip_timer = 5
							IV.on_reagent_change()

			if(reagents) reagents.metabolize(src)

			if(mutantrace == "plant") //couldn't think of a better place to place it, since it handles nutrition -- Urist
				var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
				if(istype(loc,/turf)) //else, there's considered to be no light
					light_amount = min(10,loc:ul_Luminosity()) - 5 //hardcapped so it's not abused by having a ton of flashlights
				if(nutrition < 500) //so they can't store nutrition to survive without light forever
					nutrition += light_amount
				if(light_amount > 0) //if there's enough light, heal
					if(fireloss)
						heal_overall_damage(0,1)
					if(bruteloss)
						heal_overall_damage(1,0)
					if(toxloss)
						toxloss--
					if(oxyloss)
						oxyloss--

/*			if(mutantrace == "zombie") //couldn't think of a better place to place it, since it handles nutrition -- Urist
				if(nutrition < 500) //so they can't store nutrition to survive without light forever
					nutrition += brains

				if(brains < -10)
					src.death()

				if(brains > 0) //BRAAAIIINNNNNNZZZZZ
					brains--
					if(fireloss)
						heal_overall_damage(0,5)
					if(bruteloss)
						heal_overall_damage(5,0)
					if(toxloss)
						toxloss -= 3
					if(oxyloss)
						oxyloss -= 3
*/
			if(overeatduration > 500 && !(mutations & FAT))
				src << "\red You suddenly feel blubbery!"
				mutations |= FAT
				update_body()
			if (overeatduration < 100 && mutations & FAT)
				src << "\blue You feel fit again!"
				mutations &= ~FAT
				update_body()

			// nutrition decrease
			if (nutrition > 0 && stat != 2)
				nutrition = max (0, nutrition - HUNGER_FACTOR)
			if (nutrition > 450)
				if(overeatduration < 600) //capped so people don't take forever to unfat
					overeatduration++
			else
				if(overeatduration > 1)
					overeatduration -= 2 //doubled the unfat rate

			if(mutantrace == "plant")
				if(nutrition < 200)
					take_overall_damage(2,0)

			if(mutantrace == "brony")
				brainloss = 90
				src << sound('browny.ogg')

			if (drowsyness)
				drowsyness--
				eye_blurry = max(2, eye_blurry)
				if (prob(5))
					sleeping = 1
					paralysis = 5

			confused = max(0, confused - 1)
			// decrement dizziness counter, clamped to 0
			if(resting)
				dizziness = max(0, dizziness - 15)
				jitteriness = max(0, jitteriness - 15)
			else
				dizziness = max(0, dizziness - 3)
				jitteriness = max(0, jitteriness - 3)

			updatehealth()

			return //TODO: DEFERRED


		handle_regular_status_updates()
			health = 100 - round(oxyloss + toxloss + fireloss + bruteloss + cloneloss, 1) //Huzzah!

			if(oxyloss > 80) paralysis = max(paralysis, 3)

			if(sleeping)
				src.paralysis = max(src.paralysis, 5)
				if (prob(1) && health)
					if(prob(20))
						emote("snore")

				if(src.nutrition >= 380)
					src.sleeping--
				else
					src.nutrition++

				if(prob(20))
					if(oxyloss && prob(50)) oxyloss -= 2
					if(bruteloss && prob(60)) heal_organ_damage(2,0)
					if(fireloss && prob(50)) heal_organ_damage(0,2)
					if(toxloss && prob(50)) toxloss -= 2
					if(dizziness !=0) dizziness = max(0,dizziness-15)
					if(confused !=0) confused = max(0,confused - 5)
					if(stuttering !=0) confused = max(0,stuttering - 5)


				//LMAO MASSIVE NERFS
				if(dizziness >= 30)
					dizziness = 29
				if(confused >= 30)
					confused = 29
				if(stuttering >= 30)
					stuttering = 29
				if(druggy >= 30)
					druggy = 29
				if(stunned >= 30)
					stunned = 29
				if(weakened >= 30)
					weakened = 29
				if(paralysis >= 30)
					paralysis = 29
				if(drowsyness >= 30)
					drowsyness = 29
				if(jitteriness >= 30)
					jitteriness = 29
				//LMAO MASSIVE NERFS

			if(resting)
				weakened = max(weakened, 2)

			if(health < -100 && !buddha || brain_op_stage == 4.0 || health < -100 && !reagents.has_reagent("inaprovaline")&& !buddha || health < -100 && !reagents.has_reagent("polyadrenalobin")&& !buddha)
				death()

		//	else if(health < -200 && !buddha) // arrhythmia and thrombosis are pains in the ass for buddha.
		//		brainloss+= 0.5

				//arrhythmia = 1
				//thrombosis = 4
			else if(health < 0)

				if(health <= 20 && prob(1)) spawn(0) emote("gasp")
				//if(!rejuv) oxyloss++
				if(!reagents.has_reagent("inaprovaline") ||(stat != 2)||!reagents.has_reagent("dexalin") || !reagents.has_reagent("chloromydride"))
					oxyloss += 2

				if(stat != 2)	stat = 1
				paralysis = max(paralysis, 5)

			if (stat != 2) //Alive.
				if (silent)
					silent--

				if (paralysis || stunned || weakened || changeling_fakedeath) //Stunned etc.
					if (stunned > 0)
						stunned--
						update_clothing()
						update_face()
						update_body()
						stat = 0
					if (weakened > 0)
						weakened--
						lying = 1
						update_face()
						update_body()
						stat = 0
					if (paralysis > 0)
						paralysis--
						blinded = 1
						lying = 1
						update_face()
						update_body()
						stat = 1
					var/h = hand
					hand = 0
					drop_item()
					hand = 1
					drop_item()
					hand = h

				else	//Not stunned.
					update_clothing()
					update_face()
					update_body()
					lying = 0
					stat = 0

			else if (!buddha)//Dead.
				lying = 1
				blinded = 1
				stat = 2
				silent = 0

			if (stuttering) stuttering--

			if (stoned && !src.reagents.has_reagent("thc")) stoned--
			if (tripping && !src.reagents.has_reagent("psilocybin")) tripping--
			if (opiates && !src.reagents.has_reagent("opium")) opiates--

			if (eye_blind)
				eye_blind--
				blinded = 1

			if (ear_deaf > 0) ear_deaf--
			if (ear_damage < 25)
				ear_damage -= 0.30
				ear_damage = max(ear_damage, 0)

			density = !( lying )

			if ((sdisabilities & 1 || istype(glasses, /obj/item/clothing/glasses/blindfold)))
				blinded = 1
			if ((sdisabilities & 4 || istype(ears, /obj/item/clothing/ears/earmuffs)))
				ear_deaf = 1

			if (eye_blurry > 0)
				eye_blurry--
				eye_blurry = max(0, eye_blurry)

			if(client)
				if ((src.druggy > 0) && (stat != 2))
					src.druggy--
					src.toxloss += 0.05
					src.druggy = max(0, src.druggy)
					if(prob(15))
						client.dir = WEST
					if(prob(15))
						client.dir = EAST
					if(prob(15))
						client.dir = SOUTH
					if(prob(15))
						client.dir = NORTH
				else
					client.dir = NORTH
			return 1

			if(client)
				if ((src.kanye > 0) && (stat != 2))
					src.kanye--
					src.toxloss += 0.05
					src.kanye = max(0, src.kanye)
					if(prob(5))
						client.dir = WEST
						src << "\red <B>KANYE WEST</b>"
					if(prob(5))
						client.dir = EAST
						src << "\red <B>KANYE EAST</b>"
				else
					client.dir = NORTH
			return 1

		handle_drugs()
			if(reagents.has_reagent("thc"))
				if(stoned <= 15)
					druggy = max(druggy, 20)
					if(prob(10)) emote("smile")
				else if(stoned <= 30)
					druggy = max(druggy, 30)
					if(prob(10)) emote(pick("giggle","smile"))
				else if(stoned <= 45)
					druggy = max(druggy, 40)
					make_dizzy(1)
					if(prob(20)) emote(pick("giggle","smile","laugh"))
				else if(stoned <= 60)
					druggy = max(druggy, 60)
					make_dizzy(2)
					if(prob(20)) emote(pick("giggle","laugh","smile"))
				else if(stoned <= 90)
					kanye = max(kanye, 80)
					druggy = max(druggy, 80)
					make_dizzy(5)
					if(prob(30)) emote(pick("giggle","laugh","smile"))
					if(prob(1)) emote("fart") //it's not that getting high makes you gassy, it's just that you don't care to hold it in.
				else if(stoned <= 120)
					kanye = max(kanye, 100)
					druggy = max(druggy, 100)
					make_dizzy(5)
					if(prob(45)) emote(pick("giggle","laugh"))
					if(prob(1)) emote("fart")
				else if(stoned <= 150)
					kanye = max(kanye, 140)
					druggy = max(druggy, 140)
					make_dizzy(5)
					src.stuttering = 5
					if(prob(45)) emote(pick("giggle","laugh"))
					if(prob(2)) emote("fart")
				else if(stoned <= 200)
					kanye = max(kanye, 160)
					druggy = max(druggy, 160)
					make_dizzy(5)
					src.stuttering = 5
					if(prob(65)) emote(pick("giggle","laugh"))
					if(prob(2) )emote("fart")
				else if(stoned <= 255)
					kanye = max(kanye, 200)
					druggy = max(druggy, 200)
					make_dizzy(20)
					if(prob(65)) emote(pick("giggle","laugh"))
					if(prob(2)) emote("fart")
				else if (stoned <= 420)
					kanye = max(kanye, 250)
					druggy = max(druggy, 250)
					make_dizzy(40)
					src.stuttering = 10
					if(prob(65)) emote(pick("giggle","laugh"))
					if(prob(5)) emote("fart")
				else if (stoned >= 420)
					src << "\red 420 BLAZE IT FAGGOT"
					kanye = max(kanye, 420)
					druggy = max(druggy, 420)
					src.stuttering = 30
					make_dizzy(90)
					if(prob(65)) emote(pick("giggle","laugh"))
					if(prob(10)) emote("fart")
					if(prob(1) && prob(1))
						src.name = "Snoop Dogg"
						src.real_name = "Snoop Dogg"
						src.s_tone = -80
						src.hair_icon_state = "hair_dreads"
						src.r_hair = 0
						src.g_hair = 0
						src.g_hair = 0
					if(prob(1) && prob(1))
						src.name = "Snoop Lion"
						src.real_name = "Snoop Lion"
						src.s_tone = -80
						src.hair_icon_state = "hair_dreads"
						src.r_hair = 0
						src.g_hair = 0
						src.g_hair = 0
					if(prob(1) && prob(1))
						src.name = "Kanye West"
						src.real_name = "Kanye West"
						src.s_tone = -120
						src.hair_icon_state = "bald"
						src.r_hair = 0
						src.g_hair = 0
						src.g_hair = 0
					if(prob(1) && prob(1) && prob(1))
						src << "\red <B>NIGGER</b> YOU HIGH"
						src.s_tone = -420
						src.hair_icon_state = "hair_afro"
						src.r_hair = 0
						src.g_hair = 0
						src.g_hair = 0
				else
					..()
			if(reagents.has_reagent("psilocybin"))
				if(tripping <= 10)
					druggy = max(druggy, 20)
				else if(tripping <= 50)
					druggy = max(druggy, 40)
				else if(tripping <= 100)
					druggy = max(druggy, 60)
					if(prob(1)) say(pick("It hurts when I pee...", "Has anyone really been far even as decided to use even go want to do look more like?", "PLEASE! Tell me about the fucking golf shoes!", "Fuck, you've gone completely sideways man.", "HI THERE! My name... is, uh, Raoul Duke. I'm on the list. Free lunch, final wisdom, total coverage. I have my attorneyyyyyyy... with me, and I realize that his name is not on that list, but we must have that suite! Yes, must have that suite. What's the score here? What's next?", ";No.", ";NO!", ";YES!", ";Bitches love how [src] rolls.", ";BEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEES!!!", ";SYNDIES!", "There are colours and I am scared.", ";Beepsky's after me man!", ";CALL THE SHUTTLE, THERE'S NO WAY I'M STAYING ON THIS HELLHOLE", "GET THE FUCK OFF OF ME", "Stop watching me. STOP WATCHING ME", ";Back off! I'll make you teensy!", "There's a big machine in space, some kind of electric snake", "SPAAAAAAACEEEEMAAAAAAAAN", ";This server has awesome drugs", "Oh god, what's that?!", ";SYNDIES ARE MELTING THE STATION", "Damn these are good drugs! WOOOO!", ";Why?", "Jesus creeping shit!", ";Dogs fucked the Pope, no fault of mine, watch out! Why money....My name is Brinks; I was born.....Born?", ";Please, don't tell me those things. Not now", "When will this station stop? It won't stop...it's never going to stop", ";WHO FUCKED WITH ATMOS? Fuck I can taste music in the air..", ";BOLT EVERYTHING, USE THE CHAINS", ";THAT DIRTY BASTARD! I KNEW IT! I knew he stole my drugs"))
					if(prob(5)) emote(pick("giggle", "laugh"))
					if(prob(5)) src << sound(pick('rustle1.ogg', 'rustle2.ogg', 'rustle3.ogg', 'rustle4.ogg', 'rustle5.ogg', 'meteorimpact.ogg', 'squishy.ogg'))
					if(prob(1))
						src << sound(pick('bjustice.ogg', 'bfreeze.ogg'))
						src << pick("<B>Officer Beepsky</b> beeps, 'Level 4 infraction alert (Public masturbation)'!", "<B>Officer Beepsky</b> beeps, 'Level 4 infraction alert (Rape)'!")
						src << "<B>Officer Beepsky</b> points at <B>[src]</b>!"
				else if(tripping <= 150)
					druggy = max(druggy, 80)
					if(prob(2)) say(pick("It hurts when I pee...", "Has anyone really been far even as decided to use even go want to do look more like?", "PLEASE! Tell me about the fucking golf shoes!", "Fuck, you've gone completely sideways man.", "HI THERE! My name... is, uh, Raoul Duke. I'm on the list. Free lunch, final wisdom, total coverage. I have my attorneyyyyyyy... with me, and I realize that his name is not on that list, but we must have that suite! Yes, must have that suite. What's the score here? What's next?", ";No.", ";NO!", ";YES!", ";Bitches love how [src] rolls.", ";BEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEES!!!", ";SYNDIES!", "There are colours and I am scared.", ";Beepsky's after me man!", "Just shut the hell up already.", "No one asked you.", ";If you're looking for me, you better look under the sea, coz that is where you'll find me.", "What the fuck even IS a PDA?", ";I CAN'T TAKE THIS GIB ME!", "ehehe the walls, man, the angles, man", "Jesus!  Did I say that?", ";I CAN EASE YOUR PAIN, GET YOU ON YOUR FEET AGAIN", "dOn't Take any gRuff from these faggots", ";TRAITORS IN BOTANY", ";CAPTAIN LIKES LITTLE GIRLS", "My attourney understands this concept, despite his racial handicap", "GIB ME BACK MY DERUGS", ";Where's the medicine?!", "Alright, stay calm, it's just a game...life is just a game. Sometimes you win, sometimes you lose, something, something fuck it lets eat more shrooms", ";NO! WE HAVEN'T DONE ANYTHING YET", ";LIZARD JEWS ARE BOARDING THE STATION", "If you think we're in trouble now wait till you see the escape arm"))
					if(prob(10)) emote(pick("giggle", "laugh"))
					if(prob(5)) src << sound(pick('rustle1.ogg', 'rustle2.ogg', 'rustle3.ogg', 'rustle4.ogg', 'rustle5.ogg', 'meteorimpact.ogg', 'squishy.ogg', 'hiss1.ogg', 'hiss2.ogg', 'hiss3.ogg', 'hiss4.ogg', 'hiss5.ogg'))
					if(prob(1))
						src << sound(pick('bjustice.ogg', 'bfreeze.ogg'))
						src << pick("<B>Officer Beepsky</b> beeps, 'Level 4 infraction alert (Public masturbation)'!", "<B>Officer Beepsky</b> beeps, 'Level 4 infraction alert (Rape)'!")
						src << "<B>Officer Beepsky</b> points at <B>[src]</b>!"
				else if(tripping >= 250)
					druggy = max(druggy, 140)
					if(prob(3)) say(pick("It hurts when I pee...", "Has anyone really been far even as decided to use even go want to do look more like?", "PLEASE! Tell me about the fucking golf shoes!", "Fuck, you've gone completely sideways man.", "HI THERE! My name... is, uh, Raoul Duke. I'm on the list. Free lunch, final wisdom, total coverage. I have my attorneyyyyyyy... with me, and I realize that his name is not on that list, but we must have that suite! Yes, must have that suite. What's the score here? What's next?", ";No.", ";NO!", ";YES!", ";Bitches love how [src] rolls.", ";BEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEES!!!", ";SYNDIES!", "There are colours and I am scared.", ";Beepsky's after me!", ";Yeah? Well that's just, like, your opinion, man.", ";I'm lost. Can someone tell me where I am?", ";Don't touch the floor it's a river of dicks", ";Do not touch the trim!", "I'm tripping fucking balls.", ";If you're looking for me, you better look under the sea, coz that is where you'll find me.", "underneath the seeeeeeeeeeeeeeeeeeeeeeeeeeeaaaalaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab underneath the waaaater...", ";There's this fantasy I have where Jesus Christ is jackhammering Mickey Mouse in the doo-doo hole with a lawn dart as Garth Brooks gives birth to something resembling a cheddar cheese log with almonds on Santa Claus's tummy-tum", "I feel a bit lightheaded.  Maybe you should drive...", ";What are you yelling about?", "No point mentioning these bats. The poor bastards will see them soon enough.", ";You poor fools, wait till you see those bats", "I'm melllllttiiiiing"))
					if(prob(20)) emote(pick("giggle", "laugh"))
					if(prob(10)) src << sound(pick('rustle1.ogg', 'rustle2.ogg', 'rustle3.ogg', 'rustle4.ogg', 'rustle5.ogg', 'meteorimpact.ogg', 'squishy.ogg', 'Taser.ogg', 'ep90_4.ogg', 'ep90_3.ogg', 'armbomb.ogg', 'bewareilive.ogg', 'ihunger.ogg', 'hiss1.ogg', 'hiss2.ogg', 'hiss3.ogg', 'hiss4.ogg', 'hiss5.ogg', 'runcoward.ogg','redalert3.ogg'))
					if(prob(1))
						src << sound(pick('bjustice.ogg', 'bfreeze.ogg'))
						src << pick("<B>Officer Beepsky</b> beeps, 'Level 4 infraction alert (Public masturbation)'!", "<B>Officer Beepsky</b> beeps, 'Level 4 infraction alert (Rape)'!")
						src << "<B>Officer Beepsky</b> points at <B>[src]</b>!"
				else
					..()
			if(reagents.has_reagent("opium"))
				if(opiates <= 10) //mild opiate high
					make_dizzy(5)
					if(prob(1)) src.sleeping = max(src.sleeping, 1)
				else if(opiates <= 50) //not-so-mild opiate high
					make_dizzy(10)
					src.stuttering = 10
					if(prob(1)) src.sleeping = max(src.sleeping, 2)
				else if(opiates <= 100) //alright, now we're starting to feel it.
					druggy = max(druggy, 40)
					make_dizzy(10)
					if(prob(1)) src.paralysis = max(src.paralysis, 3)
					if(prob(1)) src.sleeping = max(src.sleeping)
				else if(opiates <= 200) //Taking this much heroin is probably not a good idea.
					druggy = max(druggy, 80)
					kanye = max(kanye, 80)
					if(prob(3)) src.paralysis = max(src.paralysis, 3)
					if(prob(3)) src.sleeping = max(src.sleeping, 20)
				else if(opiates <= 300) //Taking this much heroin is definitely not a good idea.
					druggy = max(druggy, 100)
					kanye = max(kanye, 100)
					if(prob(5)) src.paralysis = max(src.paralysis, 3)
					if(prob(5)) src.sleeping = max(src.sleeping, 30)
				else if(opiates >= 300) //Only smackies of the most dedicated variety could possibly hope to achieve this level of high.
					druggy = max(druggy, 120)
					kanye = max(kanye, 120)
					if(prob(5)) src.paralysis = max(src.paralysis, 5)
					if(prob(5)) src.sleeping = max(src.sleeping, 40)
				else
					..()
			return

		handle_regular_hud_updates()

			if(!client)	return 0

			for(var/image/hud in client.images)
				if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
					del(hud)
			if (stat == 2 || mutations & 4)
				sight |= SEE_TURFS
				sight |= SEE_MOBS
				sight |= SEE_OBJS
				see_in_dark = 8
				see_invisible = 2
			else if (seer)
				var/obj/rune/R = locate() in loc
				if (istype(R) && R.word1 == wordsee && R.word2 == wordhell && R.word3 == wordjoin)
					see_invisible = 15
				else
					seer = 0
					see_invisible = 0
			else if (istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja))
				switch(wear_mask:mode)
					if(0)
						if(client)
							var/target_list[] = list()
							for(var/mob/living/target in oview(src))
								if( target.mind&&(target.mind.special_role||issilicon(target)) )//They need to have a mind.
									target_list += target
						if (!druggy)
							see_invisible = 0
					if(1)
						see_in_dark = 5
						if(!druggy)
							see_invisible = 0
					if(2)
						sight |= SEE_MOBS
						if(!druggy)
							see_invisible = 2
					if(3)
						sight |= SEE_TURFS
						if(!druggy)
							see_invisible = 0

			else if (istype(glasses, /obj/item/clothing/glasses/meson))
				sight |= SEE_TURFS
				if(!druggy)
					see_invisible = 0
			else if (istype(glasses, /obj/item/clothing/glasses/night))
				see_in_dark = 5
				if(!druggy)
					see_invisible = 0
			else if (istype(glasses, /obj/item/clothing/glasses/thermal))
				sight |= SEE_MOBS
				if(!druggy)
					see_invisible = 2
			else if (istype(glasses, /obj/item/clothing/glasses/material))
				sight |= SEE_OBJS
				if (!druggy)
					see_invisible = 0
			else if (istype(glasses, /obj/item/clothing/glasses/hud/security))
				if(client)
					var/icon/tempHud = 'hud.dmi'
					for(var/mob/living/carbon/human/perp in view(src))
						if(perp.wear_id)
							client.images += image(tempHud,perp,"hud[ckey(perp:wear_id:GetJobName())]")
							var/perpname = "wot"
							if(istype(perp.wear_id,/obj/item/weapon/card/id))
								perpname = perp.wear_id:registered
							else if(istype(perp.wear_id,/obj/item/device/pda))
								var/obj/item/device/pda/tempPda = perp.wear_id
								perpname = tempPda.owner
							for (var/datum/data/record/E in data_core.general)
								if (E.fields["name"] == perpname)
									for (var/datum/data/record/R in data_core.security)
										if ((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
											client.images += image(tempHud,perp,"hudwanted")
											break
										else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
											client.images += image(tempHud,perp,"hudprisoner")
											break
						else
							client.images += image(tempHud,perp,"hudunknown")
						for(var/obj/item/weapon/implant/tracking/tracker in perp)
							if(tracker.implanted)
								client.images += image(tempHud,perp,"hudtracking")
								break
				if (!druggy)
					see_invisible = 0
			else if (istype(glasses, /obj/item/clothing/glasses/hud/health))
				if(client)

					var/icon/tempHud = 'hud.dmi'
					for(var/mob/living/carbon/human/patient in view(src))

						var/foundVirus = 0
						for(var/datum/disease/D in patient.viruses)
							foundVirus++
						if(patient.health > -100)
							client.images += image(tempHud,patient,"hud[RoundHealth(patient.health)]")// so people who are not dead but have less than -100 health to show as critical on health huds
						else if(patient.health <= -100 && patient.stat == 2)
							client.images += image(tempHud,patient,"hudhealth-100") // so people who are not dead but have less than -100 health to show as critical on health huds
						else if(patient.health <= -100 && patient.stat != 2)
							client.images += image(tempHud,patient,"hudhealth0")	// so people who are not dead but have less than -100 health to show as critical on health huds
						if(patient.stat == 2)
							client.images += image(tempHud,patient,"huddead")
						else if(patient.alien_egg_flag)
							client.images += image(tempHud,patient,"hudxeno")
						else if(foundVirus)
							client.images += image(tempHud,patient,"hudill")
						else
							client.images += image(tempHud,patient,"hudhealthy")
				if (!druggy)
					see_invisible = 0

			else if (src.stat != 2)
				src.sight &= ~SEE_TURFS
				src.sight &= ~SEE_MOBS
				src.sight &= ~SEE_OBJS
				if (src.mutantrace == "lizard" || src.mutantrace == "metroid")
					src.see_in_dark = 3
					src.see_invisible = 1
				else if (src.druggy) // If drugged~
					src.see_in_dark = 2
					//see_invisible regulated by drugs themselves.
				else
					src.see_in_dark = 2
					var/seer = 0
					for(var/obj/rune/R in world)
						if(src.loc==R.loc && R.word1==wordsee && R.word2==wordhell && R.word3==wordjoin)
							seer = 1
					if(!seer)
						src.see_invisible = 0
			else if(src.reagents.has_reagent("psilocybin"))
				if (src.druggy > 30)
					src.see_invisible = 10
			if (istype(src.glasses, /obj/item/clothing/glasses/meson))
				src.client.screen += src.hud_used.gogglemeson
				src.sight |= SEE_TURFS
				src.see_in_dark = 3
				if(!src.druggy)
					src.see_invisible = 0

			if (istype(src.glasses, /obj/item/clothing/glasses/sunglasses))
				src.client.screen += src.hud_used.alien_view
				src.see_in_dark = 0
				if(!src.druggy)
					src.see_invisible = 0

			if (istype(src.glasses, /obj/item/clothing/glasses/night))
				src.see_in_dark = 5
				if(!src.druggy)
					src.see_invisible = 0

			if (istype(src.glasses, /obj/item/clothing/glasses/ecto))
				src.client.screen += src.hud_used.ectoglasses
				src.see_in_dark = 4
				if(!src.druggy)
					src.see_invisible = 10

			if (istype(src.glasses, /obj/item/clothing/glasses/thermal))
				src.client.screen += src.hud_used.gogglethermal
				src.sight |= SEE_MOBS
				src.see_in_dark = 4
				if(!src.druggy)
					src.see_invisible = 2

			if (istype(src.head, /obj/item/clothing/head/helmet/welding))
				if(!src.head:up && tinted_weldhelh)
					src.see_in_dark = 0

			if (sleep) sleep.icon_state = text("sleep[]", sleeping)
			if (rest) rest.icon_state = text("rest[]", resting)
			if (healths)
				if (stat != 2)
					switch(health)
						if(100 to INFINITY)
							healths.icon_state = "health0"
						if(80 to 100)
							healths.icon_state = "health1"
						if(60 to 80)
							healths.icon_state = "health2"
						if(40 to 60)
							healths.icon_state = "health3"
						if(20 to 40)
							healths.icon_state = "health4"
						if(0 to 20)
							healths.icon_state = "health5"
						else
							healths.icon_state = "health6"
				else
					healths.icon_state = "health7"

			if (stat != 2)
				if (src.nutrition_icon)
					switch(nutrition)
						if(450 to INFINITY)
							src.nutrition_icon.icon_state = "nutrition0"
						if(350 to 450)
							src.nutrition_icon.icon_state = "nutrition1"
							//if(prob(5))
							//	if(prob(1))
								//	src << pick("\red You feel hungry", "\red Perhaps you should grab a bite to eat", "\red Your stomach rumbles", "\red You feel empty inside", "\red You feel a bit peckish","\red Whatever you last ate didn't do much to fill you up...","\red Hmm, some pizza would be nice")
						if(250 to 350)
							src.nutrition_icon.icon_state = "nutrition2"
						//	if(prob(1))
							//	src << pick("\red You feel hungry", "\red Perhaps you should grab a bite to eat", "\red Your stomach rumbles", "\red You feel empty inside", "\red You feel a bit peckish","\red Whatever you last ate didn't do much to fill you up...","\red Hmm, some pizza would be nice")
						if(150 to 250)
							src.nutrition_icon.icon_state = "nutrition3"

							if(prob(1))
								src << pick("\red You feel hungry", "\red Perhaps you should grab a bite to eat", "\red Your stomach rumbles", "\red You feel empty inside", "\red You feel a bit peckish","\red Whatever you last ate didn't do much to fill you up...","\red Hmm, some pizza would be nice")
							if(prob(1) && (!src.sleeping))
								emote("yawn")
						else
							src.nutrition_icon.icon_state = "nutrition4"
							if(prob(1))
								src << pick("\red You feel hungry", "\red Perhaps you should grab a bite to eat", "\red Your stomach rumbles", "\red You feel empty inside", "\red You feel a bit peckish","\red Whatever you last ate didn't do much to fill you up...","\red Hmm, some pizza would be nice")
							if(prob(1) && (!src.sleeping))
								src.drowsyness++
								emote("yawn")
							if(prob(3) && (!src.sleeping))
								src << "\red You fall asleep from the lack of energy!"
								emote("faint")

			if(pullin)	pullin.icon_state = "pull[pulling ? 1 : 0]"

			if(resting || lying || sleeping)	rest.icon_state = "rest[(resting || lying || sleeping) ? 1 : 0]"


			if (toxin)	toxin.icon_state = "tox[toxins_alert ? 1 : 0]"
			if (oxygen) oxygen.icon_state = "oxy[oxygen_alert ? 1 : 0]"
			if (fire) fire.icon_state = "fire[fire_alert ? 1 : 0]"
			//NOTE: the alerts dont reset when youre out of danger. dont blame me,
			//blame the person who coded them. Temporary fix added.

			switch(bodytemperature) //310.055 optimal body temp

				if(370 to INFINITY)
					bodytemp.icon_state = "temp4"
				if(350 to 370)
					bodytemp.icon_state = "temp3"
				if(335 to 350)
					bodytemp.icon_state = "temp2"
				if(320 to 335)
					bodytemp.icon_state = "temp1"
				if(300 to 320)
					bodytemp.icon_state = "temp0"
				if(295 to 300)
					bodytemp.icon_state = "temp-1"
				if(280 to 295)
					bodytemp.icon_state = "temp-2"
				if(260 to 280)
					bodytemp.icon_state = "temp-3"
				else
					bodytemp.icon_state = "temp-4"

			client.screen -= hud_used.blurry
			client.screen -= hud_used.druggy
			client.screen -= hud_used.vimpaired
			client.screen -= hud_used.darkMask
			if (!istype(src.wear_mask, /obj/item/clothing/mask/gas))
				src.client.screen -= src.hud_used.g_dither
			if (!istype(src.glasses, /obj/item/clothing/glasses/meson))
				src.client.screen -= src.hud_used.gogglemeson
			if (!istype(src.glasses, /obj/item/clothing/glasses/ecto))
				src.client.screen -= src.hud_used.ectoglasses
			if (!istype(src.glasses, /obj/item/clothing/glasses/thermal))
				src.client.screen -= src.hud_used.gogglethermal
			if (!istype(src.glasses, /obj/item/clothing/glasses/sunglasses))
				src.client.screen -= src.hud_used.alien_view

			if ((blind && stat != 2))
				if ((blinded))
					blind.layer = 18
				else
					blind.layer = 0

					if (disabilities & 1 && !istype(glasses, /obj/item/clothing/glasses/regular) )
						client.screen += hud_used.vimpaired

					if (eye_blurry)
						client.screen += hud_used.blurry

					if (druggy)
						client.screen += hud_used.druggy

					if (istype(head, /obj/item/clothing/head/helmet/welding))
						if(!head:up && tinted_weldhelh)
							client.screen += hud_used.darkMask

			if (stat != 2)
				if (machine)
					if (!( machine.check_eye(src) ))
						reset_view(null)
				else
					if(!client.adminobs)
						reset_view(null)

			return 1

		handle_random_events()
			if (prob(1) && prob(2))
				spawn(0)
					emote("sneeze")
					return

		handle_virus_updates()
			if(bodytemperature > 1406)
				for(var/datum/disease/D in viruses)
					del D
			return


		check_if_buckled()
			if (buckled)
				lying = istype(buckled, /obj/stool/bed) || istype(buckled, /obj/machinery/conveyor)
				if(lying)
					drop_item()
				density = 1
			else
				density = !lying

	/*	handle_nicotine()
			if(src.stat < 2)
				if(!nicsmoketime)
					nicsmoketime = world.time
				else if(world.time - nicsmoketime > rand(5000,9000))
					if(src.nicotineaddiction == 1)
						src << "\red You crave a cigarette!"
						src.health -= 5
						src.toxloss += 10
						emote("cough")
						src.updatehealth()
						nicsmoketime = 0
				return*/



		handle_stomach()
			spawn(0)
				for(var/mob/M in stomach_contents)
					if(M.loc != src)
						stomach_contents.Remove(M)
						continue
					if(istype(M, /mob/living/carbon) && stat != 2)
						if(M.stat == 2)
							M.death(1)
							stomach_contents.Remove(M)
							del(M)
							continue
						if(air_master.current_cycle%3==1)
							if(!M.nodamage)
								M.bruteloss += 5
							nutrition += 10

		handle_changeling()
			if (mind)
				if (mind.special_role == "Changeling")
					chem_charges = between(0, (max((0.9 - (chem_charges / 50)), 0.1) + chem_charges), 50)
			bloodstopper()
			if(bloodstopper)
				countdown++
			else if(!bloodstopper)
				countdown = 0
			if(countdown >= 60)
				bloodstopper = 0
				spawn(1)
				countdown = 0
		bloodstopper()
			if(bloodstopper)
				countdown++
			else if(!bloodstopper)
				countdown = 0
			if(countdown >= 60)
				bloodstopper = 0
				spawn(1)
				countdown = 0

		bloodsplatter() //creating only 1 blood splatter
			if(locate(/turf/space/) in src.loc)
				return
			else
				var/turf/location = src.loc
				if(locate(/obj/decal/cleanable/blood/drip) in src.loc)
					return
				else if(prob(50))
					new /obj/decal/cleanable/blood/drip(location)
				for(var/obj/decal/cleanable/blood/drip/B)
					B.blood_DNA = copytext(src.dna.unique_enzymes,1,0)
					B.blood_type = copytext(src.b_type,1,0)
					for(var/datum/disease/D in src.viruses)
						var/datum/disease/C = D.getcopy(D)
						B.viruses += C

		bloodtaken()  // proc for when blood is taken
			if(blood > 0)
				if(totalbloodloss <= 3)
					if(bloodthickness == 5)
						blood -= 1
					if(bloodthickness >= 9)
						oxyloss += bloodthickness - 8
						bruteloss += bloodthickness - 8
					else
						blood -= 1 - (bloodthickness - 5)
				else if(totalbloodloss > 3)
					if(bloodthickness == 5)
						blood -= 1 + (totalbloodloss - 3)
					if(bloodthickness >= 9)
						oxyloss += bloodthickness - 8
						bruteloss += bloodthickness - 8
			else
				blood = 0

	/*	handle_thrombosis()
			var/S = thrombosis_severity
			if(S==0)
				thrombosis = 0
			switch(thrombosis)
				if(0)
					thrombosis_severity = 0
				if(1)
					switch(S)
						if(1 to 2)
							if(prob(70))
								thrombosis_severity+=1
							if(prob(5))
								oxyloss += 1
						if(2 to 3)
							if(prob(100))
								thrombosis = 0
								give_thrombosis()
							oxyloss += 1
				if(2)
					switch(S)
						if(1 to 2)
							if(prob(70))
								thrombosis_severity+=1
							if(prob(5))
								oxyloss += 1
						if(2 to 3)
							if(prob(100))
								thrombosis = 0
								give_thrombosis()
							oxyloss += 1
				if(3) //Pulmonary Embolism
					switch(S)
						if(1 to 2)
							drowsyness=5
							if(prob(10))
								thrombosis_severity+=1
							if(prob(5))
								oxyloss += 2
						if(3)
							drowsyness=10
							if(prob(20))
								thrombosis_severity+=1
							brainloss += 2
							oxyloss += 1
							if(prob(5))
								losebreath+=1
						if(4)
							//Let the arrhythmia do the work.
							arrhythmia = 2 //Pulseless electrical activity
							//Yes, the person most likely dies, unless he was in the medbay.
				if(4) //CVA(Stroke)
					switch(S)
						if(1 to 2)
							drowsyness=10
							if(prob(10))
								thrombosis_severity+=1
							if(prob(5))
								brainloss += 2
								oxyloss += 1
							if(S==2)
								eye_blurry += 1
						if(3)
							drowsyness=20
							if(prob(20))
								thrombosis_severity+=1
							brainloss += 2
							oxyloss += 1
							sleeping += 1
							paralysis += 1
						if(4)
							drowsyness=30
							brainloss += 15
							oxyloss += 2
							eye_blind += 1
							sleeping += 1
							losebreath += 1
							paralysis += 1
							if(prob(15))
								arrhythmia = 1 //DIE
				if(5) //Myocardial Infarction
					switch(S)
						if(1 to 2)
							eye_blurry += 1
							drowsyness+=5
							if(prob(10))
								thrombosis_severity+=1
							if(prob(5))
								brainloss += 5
								oxyloss += 5
								if(heartrate > 40)
									heartrate -= 5
						if(3)
							if(prob(20))
								thrombosis_severity+=1
							brainloss += 5
							oxyloss += 2
							sleeping += 1
							eye_blind += 1
							losebreath += 1
							paralysis += 1
						if(4)
							//Let the arrhythmia do the work.
							arrhythmia = 2 //Pulseless electrical activity
							//Yes, the person most likely dies, unless he was in the medbay.
						*/
	/*	handle_heartrate()
			if(heartrate > 0)
				if(heartrate < 80)
					heartrate++
				else if(heartrate > 80)
					heartrate--
				sleep(20)
			else
				if(arrhythmia == 0)
					heartrate++
		handle_arrhythmia()
			//Epinephrine, ha ha ha!
			switch(arrhythmia)
				if(1) //Asystole, or flatline
					//PERSON DIES
					heartrate = 0
					losebreath += 1
					sleeping += 5
					systolic = 0
					if(prob(50) && !reagents.has_reagent("polyadrenalobin"))
						death()
					arrhythmia = 0
					//DEAD DEAD DEAD DEAD DEEEED!
				if(2) //Pulseless Electrical Activity
					//PERSON IS KIND OF SCREWED
					heartrate = 0
					losebreath += 1
					sleeping += 5
					systolic = 0
					if(prob(10))
						arrhythmia = 3
					if(prob(10))
						arrhythmia = 1
				if(3) //Ventricular Fibrillation
					//Still saveable
					heartrate = 0
					losebreath += 1
					sleeping += 5
					if(prob(2)) //Flatline the fucker
						arrhythmia = 1
					if(prob(25)) //PEA
						arrhythmia = 2
					if(systolic > 100)
						systolic = 50
					if(systolic > 10)
						systolic -= 10
					if(prob(20))
						arrhythmia = 0
*/
	/*
		give_thrombosis()
			//Already has thrombosis? Increase severity
			if(thrombosis > 0)
				thrombosis_severity += 1
			else
				thrombosis_severity = prob(2)?1:2
			//Roll for type
			if(!thrombosis)
				if(prob(5))
				{
					thrombosis = 1 //Leg
					switch(thrombosis_severity)
						if(1 to 2)
							src << "\red Your legs feel tingly."
						if(3 to 4)
							src << "\red You legs feel numb."
				}
				else if(prob(5))
				{
					thrombosis = 2 //Arm
					switch(thrombosis_severity)
						if(1 to 2)
							src << "\red Your arms feel tingly."
						if(3 to 4)
							src << "\red You arms feel numb."
				}
				else if(prob(4))
				{
					thrombosis = 2 //Pulmonary Embolism
					switch(thrombosis_severity)
						if(1)
							src << "\red You have difficulty breathing"
						if(2)
							src << "\red You can barely breathe"
				}
				else if(prob(5))
				{
					thrombosis = 3 //CVA(Stroke)
					switch(thrombosis_severity)
						if(1 to 2)
							src << "\red You feel slow and clumsy."
				}
				else
				{
					thrombosis = 4 //Myocardial Infarction
					switch(thrombosis_severity)
						if(1 to 2)
							src << "\red You feel a sharp pain in your chest"
				}
				*/


		handle_payday()
			if(src.client.prisoner)
				return
			if(src.stat < 2)
				if((src.client) && (((src.client.inactivity/10)/60) <= 5))
					if(!paytime)
						paytime = world.time
					else if(world.time - paytime > 15000)
						var/obj/item/weapon/card/id/id = null
						if (istype(src.wear_id, /obj/item/weapon/card/id))
							id = src.wear_id
						else if (istype(src.wear_id, /obj/item/device/pda))
							var/obj/item/device/pda/pda = src.wear_id
							if (pda.id != null) id = pda.id
						if (id != null)
							var/paidtoday = rand(3, 15) + text2num(src.getInflation())
							if(src.client.goon)
								paidtoday += rand(10,30)
							if(src.doTransaction(src.ckey,"[paidtoday]","Payday.") != 1)
								src << "\blue Payday! Unfortunately you lack a bank account and didn't get your money!"
								paytime = 0
							else
								src << "\blue Payday! You got Ð[paidtoday]!"
								//src << "\blue Want to earn even more? Consider <a href='http://d2k5.com/pages/shop/?item=enterlottery'>entering the lottery!</a>" //until we get a casino
								paytime = 0
						paytime = 0
					return


	/*	handle_blood_loss() //all the rest of the blood code
			if(stat < 2)
				var/amt = blood
				var/lol = round(amt)
				if(lol > 251)
				else if(lol <= 250 && lol > 219)
					if(prob(1))
						var/word = pick("off balance","hazy","faint")
						src << "\red You feel [word]"
				else if(lol <= 219 && lol > 146)
					eye_blurry += 6
					if(prob(15))
						paralysis += rand(1,3)
				else if(lol <= 146 && lol > 73)
					if(toxloss <= 100)
						toxloss = 100
				else if(lol <= 73)
					arrhythmia = 3 //Ventricular Fibrillation

			bloodcalculation1 = abs(300-blood) / 3
			if(arrhythmia)
				bloodcalculation1 += (100 / arrhythmia)

			if (stat != 2)
				if(health >= 10)
					if(blood > 300)
						if(prob(20))
							sleep(20)
							blood--
					else if(blood < 300)
						sleep(20)
						blood++
					//	world << "DEBUG - healing blood"
					if(bloodcalculation1 > 85)
						bruteloss++
						oxyloss++
				//	world << "DEBUG - bloodcalculation1 75%"
				else if(bruteloss != 0)
					if(!bloodstopper)
						if(blood)
							if(prob(bruteloss))
								bloodtaken()
								bloodsplatter()*/


/*
			// Commented out so hunger system won't be such shock
			// Damage and effects from not eating
			if(nutrition <= 50)
				if (prob (0.1))
					src << "\red Your stomach rumbles."
				if (prob (10))
					bruteloss++
				if (prob (5))
					src << "You feel very weak."
					weakened += rand(2, 3)
*/

/*
snippets

	if (mach)
		if (machine)
			mach.icon_state = "mach1"
		else
			mach.icon_state = null

	if (!m_flag)
		moved_recently = 0
	m_flag = null



		if ((istype(loc, /turf/space) && !( locate(/obj/movable, loc) )))
			var/layers = 20
			// ******* Check
			if (((istype(head, /obj/item/clothing/head) && head.flags & 4) || (istype(wear_mask, /obj/item/clothing/mask) && (!( wear_mask.flags & 4 ) && wear_mask.flags & 8))))
				layers -= 5
			if (istype(w_uniform, /obj/item/clothing/under))
				layers -= 5
			if ((istype(wear_suit, /obj/item/clothing/suit) && wear_suit.flags & 8))
				layers -= 10
			if (layers > oxcheck)
				oxcheck = layers


				if(bodytemperature < 282.591 && (!firemut))
					if(bodytemperature < 250)
						fireloss += 4
						updatehealth()
						if(paralysis <= 2)	paralysis += 2
					else if(prob(1) && !paralysis)
						if(paralysis <= 5)	paralysis += 5
						emote("collapse")
						src << "\red You collapse from the cold!"
				if(bodytemperature > 327.444  && (!firemut))
					if(bodytemperature > 345.444)
						if(!eye_blurry)	src << "\red The heat blurs your vision!"
						eye_blurry = max(4, eye_blurry)
						if(prob(3))	fireloss += rand(1,2)
					else if(prob(3) && !paralysis)
						paralysis += 2
						emote("collapse")
						src << "\red You collapse from heat exaustion!"
				plcheck = t_plasma
				oxcheck = t_oxygen
				G.turf_add(T, G.total_moles())
*/


/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	if(!(src.mutations & 1024))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))



	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

	if (new_tone)
		s_tone = max(min(round(text2num(new_tone)), 220), 1)
		s_tone =  -s_tone + 35

	var/new_style = input("Please select hair style", "Character Generation")  as null|anything in list( "Cut Hair", "Short Hair", "Long Hair", "Mohawk", "Balding", "Wave", "Goku", "Dreadlocks", "Ponytail", "Bald", "Male Bedhead", "Female Bedhead" )

	if (new_style)
		h_style = new_style

	new_style = input("Please select facial style", "Character Generation")  as null|anything in list("Watson", "Chaplin", "Selleck", "Full Beard", "Long Beard", "Neckbeard", "Van Dyke", "Elvis", "Abe", "Chinstrap", "Hipster", "Goatee", "Hogan", "Shaved")

	if (new_style)
		f_style = new_style

	var/new_gender = input("Please select gender") as null|anything in list("Male","Female")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	update_body()
	update_face()
//	update_hair()

	for(var/mob/M in view())
		M.show_message("[src.name] just morphed!")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	if(!(src.mutations & 512))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in mobz)
		creatures += h
	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	var/say = input ("What do you wish to say")
	if(target.mutations & 512)
		target.show_message("\blue You hear [src.real_name]'s voice: [say]")
	else
		target.show_message("\blue You hear a voice: [say]")
	usr.show_message("\blue You project your mind into [target.real_name]: [say]")
	for(var/mob/dead/observer/G in mobz)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")


/mob/living/carbon/human/proc/EatItem(obj/item/W as obj in oview(1))
	set category = "Goat"
	set name = "Eat Item"
	set desc="Eat an item. Any item."
	if(!(src.mutations & 4096))
		src.verbs -= /mob/living/carbon/human/proc/EatItem
		return
	if(usr.stat)
		usr << "\red Not when you are incapacitated."
		return

	if(istype(W, /obj/item/weapon/disk/nuclear))
		usr << "\red You just can't do that, it's disgusting!" // nope
		return

	if(istype(W, /obj/item))
		usr << "\blue You start chomping on [W]."
		usr.nutrition += (W.w_class * 2 + 1)
		sleep(20)
		src.visible_message("\red <b>[src]</b> eats [W.name]!")
		playsound(src.loc, 'eatfood.ogg', 30, 1, -2)

		del(W)
	else
		usr << "\red You can't eat that."


/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"

	if(!(src.mutations & 64))
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in mobz)
		creatures += h
	client.perspective = EYE_PERSPECTIVE



	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		client.eye = target
	else
		client.eye = client.mob