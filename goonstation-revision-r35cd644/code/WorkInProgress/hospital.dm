
var/list/hospital_fx_sounds = list('sound/ambience/hospital_fx1.ogg', 'sound/ambience/hospital_fx2.ogg', 'sound/ambience/hospital_fx3.ogg',
	'sound/ambience/hospital_fx4.ogg', 'sound/ambience/hospital_fx5.ogg', 'sound/ambience/hospital_fx6.ogg', 'sound/ambience/hospital_amb2.ogg', 'sound/ambience/hospital_amb3.ogg')

/area/hospital
	name = "Ainley Staff Retreat Center"
	icon_state = "purple"
	luminosity = 0
	RL_AmbientRed = 0.5
	RL_AmbientGreen = 0.5
	RL_AmbientBlue = 0.5

	var/sound/ambientSound = 'sound/ambience/hospital_amb1.ogg'
	var/list/fxlist = null
	var/list/soundSubscribers = null

	New()
		..()
		fxlist = hospital_fx_sounds
		if (ambientSound)

			spawn (60)
				var/sound/S = new/sound()
				S.file = ambientSound
				S.repeat = 0
				S.wait = 0
				S.channel = 123
				S.volume = 60
				S.priority = 255
				S.status = SOUND_UPDATE
				ambientSound = S

				soundSubscribers = list()
				process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ambientSound && ismob(Obj))
			if (!soundSubscribers:Find(Obj))
				soundSubscribers += Obj

		return

	proc/process()
		if (!soundSubscribers)
			return

		var/sound/S = null
		var/sound_delay = 0


		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)

			if(prob(10) && fxlist)
				S = sound(file=pick(fxlist), volume=50)
				sound_delay = rand(0, 50)
			else
				S = null
				continue

			for(var/mob/living/H in soundSubscribers)
				var/area/mobArea = get_area(H)
				if (!istype(mobArea) || mobArea.type != src.type)
					soundSubscribers -= H
					if (H.client)
						ambientSound.status = SOUND_PAUSED | SOUND_UPDATE
						ambientSound.volume = 0
						H << ambientSound
					continue

				if(H.client)
					ambientSound.status = SOUND_UPDATE
					ambientSound.volume = 60
					H << ambientSound
					if(S)
						spawn(sound_delay)
							H << S


/area/hospital/underground
	name = "utility tunnels"
	icon_state = "green"

/area/hospital/somewhere
	name = "forest"

/turf/unsimulated/wall/setpieces/hospital
	name = "panel wall"
	desc = ""
	icon = 'icons/misc/hospital.dmi'
	icon_state = "panelwall"

/turf/unsimulated/wall/setpieces/hospital/window
	name = "panel window"
	desc = ""
	icon_state = "panelwindow"
	opacity = 0

/turf/unsimulated/wall/setpieces/hospital/cavern
	name = "asteroid"
	desc = ""
	icon_state = "cavern1"

/turf/unsimulated/floor/setpieces/hospital/cavern
	name = "asteroid floor"
	desc = ""
	icon = 'icons/misc/hospital.dmi'
	icon_state = "crust"

/obj/stool/bed/moveable/hospital
	name = "gurney"
	desc = "A sturdy hospital gurney."
	density = 1

/obj/stool/bed/moveable/hospital/halloween
	desc = "A sturdy hospital gurney.  With skeletal remains in a straightjacket tied to it.  And tooth marks on the straps.   u h h"
	security = 1
	icon = 'icons/misc/hospital.dmi'
	icon_state = "gurney"

/obj/chaser/hospital_trigger
	name = "malevolent thing trigger"
	icon = 'icons/misc/hospital.dmi'
	icon_state = "specter"
	invisibility = 101
	anchored = 1
	density = 0
	var/obj/chaser/master/master = null


	HasEntered(atom/movable/AM as mob|obj)
		if(!maniac_active)
			if(isliving(AM))
				if(AM:client)
					if(prob(75))
						maniac_active |= 2
						spawn(600) maniac_active &= ~2
						spawn(rand(10,30))
							var/obj/chaser/hospital/C = new /obj/chaser/hospital(src.loc)
							C.target = AM


/obj/chaser/hospital
	name = "? ? ?"
	icon = 'icons/misc/hospital.dmi'
	icon_state = "specter"
	desc = "&#9617;????&#9617;&#9617;&#9617;&#9617;"
	density = 1
	anchored = 1
	var/mob/target = null
	var/sound/aaah = sound('sound/ambience/static_horror_loop.ogg',channel=7)
	var/targeting = 0


	New()
		..()
		spawn(1)
			process()

	proc/process()
		if(target)
			if (get_dist(src, src.target) <= 1)
				if(prob(40))
					src.visible_message("<span style=\"color:red\"><B>[src] passes its arm through [target]!</B></span>")
					//playsound(src.loc, 'sound/effects/bloody_stab.ogg', 50, 1)
					target.change_eye_blurry(10)
					boutput(target, "<span><B>no no no no no no no no no no no no non&#9617;NO&#9617;NNnNNO</B></span>")
					target.vaporize(,1)
					maniac_active &= ~1
					qdel(src)


				//else
					//need some awful static shriek for here ???
					//playsound(src.loc, 'sound/weapons/punchmiss.ogg', 50, 1)

			if(!targeting)
				targeting = 1
				//target<< 'sound/misc/chefsong_start.ogg'
				spawn(80)
					aaah.repeat = 1
					target << aaah
					spawn(rand(100,400))
						if(target)
							target << sound('sound/ambience/static_horror_end.ogg',channel=7)
						qdel(src)
				walk_towards(src, src.target, 3)
				sleep(10)
			spawn(5)
				process()

/obj/gurney_trap
	icon = 'icons/misc/mark.dmi'
	icon_state = "x4"
	invisibility = 101
	anchored = 1
	density = 0
	var/ready = 1

	HasEntered(atom/movable/AM as mob|obj)
		if(ready && ismob(AM) && istype(AM, /mob/living))
			if(AM:client)
				ready = 0
				//Some kinda better noise could go here ???
				playsound(AM.loc, 'sound/effects/ghost.ogg', 50, 1)
				var/turf/spawnloc = src.loc
				var/turf/tempTurf
				var/step_over_counter = 8
				while (step_over_counter--)
					tempTurf = get_step(spawnloc, EAST)
					if (!isturf(tempTurf) || tempTurf.density)
						break

					spawnloc = tempTurf

				var/obj/stool/bed/gurney = new /obj/stool/bed/moveable/hospital/halloween (spawnloc)
				playsound(src, 'sound/machines/squeaky_rolling.ogg', 40, 0) //Maybe a squeaky wheel metal noise??

				gurney.throw_at(get_edge_target_turf(src, WEST), 20, 1)

/obj/item/reagent_containers/food/drinks/bottle/hospital
	name = "Ham Brandy"
	desc = "Uh.   Uhh"
	icon = 'icons/obj/drink.dmi'
	icon_state = "whiskey"
	bottle_style = "whiskey"
	fluid_style = "whiskey"
	label = "brandy"
	heal_amt = 1
	g_amt = 60
	initial_volume = 250
	module_research = list("vice" = 10)

	New()
		..()
		reagents.add_reagent("porktonium", 30)
		reagents.add_reagent("ethanol", 30)

/obj/item/storage/secure/ssafe/hospital
	configure_mode = 0
	code = "55555"

	New()
		..()

		new /obj/item/reagent_containers/food/drinks/bottle/hospital (src)
		new /obj/item/device/audio_log/hospital_01 (src)

/obj/item/device/audio_log/hospital_01

	New()
		..()
		src.tape = new /obj/item/audio_tape/hospital_01(src)

/obj/item/audio_tape/hospital_01
	New()
		..()
		speakers = list("Female voice","Male voice","Female voice","Male voice","Female voice", "???", "Male voice", "Female voice", "Female voice", "Male voice", "Male voice", "Male voice", "Female voice", "Male voice", "Male voice")
		messages = list("Who the hell do you think you are?",

"Excuse me?",

"I know what you're doing to the patients.",

"And what, exactly, is it that I am doing?",

"Don't play dumb!  You are testing drugs on them!  Give me just one reason not to report you to Oakland.",

"...",
"Well, for one, he already knows.",

"He....what?",
"No.  Wayne Oakland is a professional.  And a good man.  He wouldn't violate the trust-",

"Perhaps you do not know him as well as you think.",
"Did you know that his wife is dying of a rare cancer?  Did you know that FAAE may be instrumental in finding a cure?",
"And even if it isn't, it is still what is paying for treatment.  And your salary.",

"That doesn't make this right.",

"The company disagrees.",
"As they control all transportation and communication lines here, I would advise against doing anything...rash.")

/obj/item/device/audio_log/hospital_02

	New()
		..()
		src.tape = new /obj/item/audio_tape/hospital_02(src)

/obj/item/audio_tape/hospital_02
	New()
		..()
		speakers = list("Male voice", "Male voice", "Male voice", "Distant voice", "Male voice", "Distant voice (Sir ?)", "Male Voice", "Distant voice that isn't really distant but relative to a really little, bad microphone it is", "Male voice", "Distant voice", "Male voice", "Male voice", "Male voice", "Male voice")
		messages = list("*panicked breaths*",
		"...ffuck.   ffffuckk.",
		"Sir!  No, no, most systems are still down.",
		"...",
		"Whatever it was, it crippled reactor two, we were forced to SCRAM it.  Reactor one was still down for service--",
		"...",
		"No, I don't know how long until we can get either of them online.  We've also had to shed as many non-critical loads as possible--",
		"...",
		"I understand, but...I'll report as soon as anything develops.  Thank you sir.",
		"...",
		"Jesus christ.  What an ass...hole...",
		"aw fuck, you're kidding me.",
		"Did I record over my goddamn mixtape?",
		"Holy sht, fuck these stupid fucking tape players, goddamn, the record button is supposed to be harder to press than play")


/obj/item/device/audio_log/hospital_03

	New()
		..()
		src.tape = new /obj/item/audio_tape/hospital_03(src)

/obj/item/audio_tape/hospital_03
	New()
		..()
		speakers = list("Female voice", "Dr. Barnet",  "Patient",  "Dr. Barnet", "Patient", "Patient", "Patient", "Dr. Barnet", "Patient", "Patient", "Dr. Barnet", "Patient", "Patient", "Dr. Barnet", "Patient", "Dr. Barnet", "Patient", "Patient", "Patient", "Patient", "Patient"  )
		messages = list("Hello, my name is Dr. Barnet. I am a psychiatrist.  I am here to determine how we can best help you.",
		"How are you feeling?",

		"I feel good.  I'm feeling good.",

		"Do you know why you are here?",

		"I was doing my job and I told the captain that I was willing to, you know",
		"Do some administration for him, because I wanted to give back to station ten and...",
		"And he was saying no but I don't think he was listening so I was explaining and, listen, like,",


		"Mr. Torres, do you know why you left station ten?",

		"No I wasn't angry at him, I mean, I know that I'm a threat to his job but I wasn't going to try anything",
		"I just wanted to help and really I was just waiting and I mean, I wasn't going to melt anyone,",

		"Mr. Torres, do you know what happened to station ten?",

		"Yes!  I mean, yes but I think you're in a different timeline? So maybe no but I could walk back and look.",
		"I really think the captain will give me a chance if I just explain it well enough.",

		"Mr. Torres, why would Captain Wilson be afraid of you melting someone?",

		"I already told you that.  I already told you about how powerful I am now. We're you listening?",

		"I apologize, but I do not remember you saying any-",

		"NO no no no no not with your ears no.  Don't pretend you can't hear me! That's rude, just like the captain,",
		"You know that uh, that nanotrasen can control the weather now right? I mean, not now but they will, I just need to talk to the captain again...",
		"I mean, if you aren't going to listen to me, then, well, then.",
		"*laughter*",
		"Then you're just like the captain!  You even look like him, you know, like you both kinda glow the same,")

/obj/item/device/audio_log/hospital_04

	New()
		..()
		src.tape = new /obj/item/audio_tape/hospital_04(src)

/obj/item/audio_tape/hospital_04
	New()
		..()
		src.speakers = list("Male voice","Different male voice", "Myron Roberts", "Myron Roberts",
		"Myron Roberts", "Myron Roberts", "Myron Roberts", "Myron Roberts", "???","Tape cut",
		"Myron Roberts", "Jerry", "Myron Roberts", "Myron Roberts, loudly whispering",
		"Jerry", "Myron Roberts, loudly whispering", "?????", "Myron Roberts", "Myron Roberts", "Jerry", "Jerry", "?????", "???")
		src.messages = list("Welcome, horror fans to GHOST WATCH, with your host, Myron Roberts!",
		"It's not really a ghost \"watch\" if it's just audio, now is it?",

		"...I told you, Jerry, it's for my cassette magazine.",
		"It's not my fault they don't have any video tapes here....",
		"Today, we are seeking out the AINLEY PHANTOM, the cruel spirit haunting the halls of the Ainley Staff Retreat Center!",
		"As the legend goes, back during the construction of the asylum, when it was still going to be a military base, a contractor was DRIVEN MAD by the strange voices in the void!",
		"He then killed everyone else there before committing suicide, and that is the real reason the US government ceased construction and sold the site to Nanotrasen.",
		"Don't believe the line that they just wanted to focus resources on the other site!",
		"...",
		"*click*",
		"It's only a matter of time until the phantom reveals itself!  This is its hour!",
		"You said that an hour ago.  Don't you have work to do?",
		"Finishing won't take long, jeez, just give a little longer and we're bound to--",
		"Do you see that?  I think it's the phantom!  Down the hall!",
		"It's probably just a patient going to take a leak. Christ, you're going to scare the guy.",
		"SSH, Jerry, its--",
		"*Horrible static*",
		"Jesus fuck, did the recorder break, what the hell",
		"Jerry?",

		"That",
		"That isn't a patient",
		"*Horrible static*",
		"*tape hiss*")

/obj/item/device/key/hospital
	desc = "What does this go to?"
	name = "niobium key"
	item_state = ""
	icon = null


/obj/storage/crate/freezer/hospital
	var/keySpawned = 0

	open()
		if (!keySpawned)
			var/obj/item/device/key/hospital/theKey = new (src)
			keySpawned = 1
			var/image/O = image(icon = 'icons/misc/aprilfools.dmi', loc = theKey, icon_state = "key", layer = 20)
			usr << O


		..()

/obj/trigger/spooky_emote
	var/last_emote_time = 0
	on_trigger(var/mob/living/somebody)
		if (!istype(somebody))
			return

		if (last_emote_time && (last_emote_time + 300 > world.time))
			return

		if (prob(5))
			var/list/stuff_around = list()
			for (var/obj/a_thing in view(somebody))
				stuff_around += a_thing

			if (!stuff_around.len)
				return

			boutput(somebody, "<b>[pick(stuff_around)]</b> [pick("whimpers!", "whispers...","cries!","gently sings.", "stares.","shrieks!","shakes.","shudders.","laughs.","mutters.")]")

			last_emote_time = world.time
