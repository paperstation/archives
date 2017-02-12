var/maniac_active = 0
var/maniac_previous_victim = "Unknown"
//maniac
//A psycho chef that sometimes appears when you go through doors on the evilreaver derelict, similar to that *ANIMEE* game Ao Oni

/obj/chaser/maniac
	name = "?"
	icon = 'icons/misc/evilreaverstation.dmi'
	icon_state = "chaser"
	desc = "We all go a little mad sometimes, haven't you?"
	density = 1
	anchored = 1
	var/mob/target = null
	var/sound/aaah = sound('sound/misc/chefsong.ogg',channel=7)
	var/targeting = 0


	New()
		spawn(1) process()
		name = maniac_previous_victim
		..()

	proc/process()
		if(target)
			if (get_dist(src, src.target) <= 1)
				if(prob(40))
					src.visible_message("<span style=\"color:red\"><B>[src] slices through [target.name] with the axe!</B></span>")
					playsound(src.loc, 'sound/effects/bloody_stab.ogg', 50, 1)
					target.change_eye_blurry(10)
					boutput(target, "Help... help...")
					spawn(5)
						var/victimkey = target.ckey
						var/victimname = target.name
						boutput(target, "Connection axed.")
						target.ckey = "" // disconnect the player so they rejoin wondering what the hell happened
						sleep(0)
						var/mob/dead/observer/ghost = new/mob/dead/observer
						for (var/obj/landmark/A in world)
							if (A.name == "evilchef_corpse")
								ghost.set_loc(A.loc)
								var/obj/item/reagent_containers/food/snacks/ingredient/meat/humanmeat/meat = new /obj/item/reagent_containers/food/snacks/ingredient/meat/humanmeat(A.loc)
								meat.name = "[victimname] meat"
						ghost.ckey = victimkey
						ghost.name = victimname // should've added this sooner
						ghost.real_name = victimname
						maniac_previous_victim = victimname
						maniac_active &= ~1
						qdel(target)
						qdel(src)


				else
					src.visible_message("<span style=\"color:red\"><B>[src] swings at [target.name] with the axe!</B></span>")
					playsound(src.loc, 'sound/weapons/punchmiss.ogg', 50, 1)

			if(!targeting)
				targeting = 1
				target<< 'sound/misc/chefsong_start.ogg'
				spawn(80)
					aaah.repeat = 1
					target << aaah
					spawn(rand(100,400))
						if(target)	target << sound('sound/misc/chefsong_end.ogg',channel=7)
						qdel(src)
				walk_towards(src, src.target, 3)
				sleep(10)
			spawn(5)
				process()



/obj/chaser/trigger
	name = "evil maniac trigger"
	icon = 'icons/misc/evilreaverstation.dmi'
	icon_state = "chaser"
	invisibility = 101
	anchored = 1
	density = 0
	var/obj/chaser/master/master = null


	HasEntered(atom/movable/AM as mob|obj)
		if(!(maniac_active & 1))
			if(isliving(AM))
				if(AM:client)
					if(prob(75))
						maniac_active |= 1
						spawn(600) maniac_active &= ~1
						spawn(rand(10,30))
							var/obj/chaser/maniac/C = new /obj/chaser/maniac(src.loc)
							C.target = AM


////////////////////////////////////////

//The PR1 Guardbuddy//



/obj/machinery/checkpointbot
	name = "PR-1 Automated Checkpoint"
	desc = "The great-great-great-great-great grandfather of the PR-6 Guardbuddy, and it's almost in mint condition!"
	icon = 'icons/misc/evilreaverstation.dmi'
	icon_state = "pr1_0"
	anchored = 1
	density = 1
	var/alert = 0
	var/id = "evilreaverbridge"

	HasProximity(atom/movable/AM as mob|obj)
		if(!alert)
			if(iscarbon(AM))
				alert = 1
				playsound(src.loc, 'sound/machines/whistlealert.ogg', 50, 1)
				icon_state = "pr1_1"
				flick("pr1_a",src)
				for(var/obj/machinery/door/poddoor/P)
					if (P.id == src.id)
						if (!P.density)
							spawn( 0 )
								P.close()
				sleep(50)
				if(id == "evilreaverbridge")
					playsound(src.loc, 'sound/machines/driveclick.ogg', 50, 1)
					var/obj/item/paper/PA = new /obj/item/paper(src.loc)
					PA.info = "<center>YOU DO NOT BELONG HERE<BR><font size=30>LEAVE NOW</font></center>" //rude!
					PA.name = "Paper - PR1-OUT"

				icon_state = "pr1_0"
				spawn(300) 	alert = 0



////////////
/area/hollowasteroid/
	name = "Forgotten Subterranean Wreckage"
	icon_state = "derelict"
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/evilr_d_ambi.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
				Obj << sound('sound/ambience/shipambience.ogg', repeat = 0, wait = 0, volume = 0, channel = 2)
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound
				var/mob/living/AM = Obj
				AM << sound('sound/ambience/shipambience.ogg', repeat = 1, wait = 0, volume = 50, channel = 2)

/area/evilreaver
	name = "Forgotten Station"
	icon_state = "derelict"
	teleport_blocked = 1
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/evilr_d_ambi.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
				Obj << sound('sound/ambience/shipambience.ogg', repeat = 0, wait = 0, volume = 0, channel = 2)
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound
				var/mob/living/AM = Obj
				AM << sound('sound/ambience/shipambience.ogg', repeat = 1, wait = 0, volume = 50, channel = 2)



/area/evilreaver/medical
	icon_state = "medbay"
	name = "Forgotten Medical Bay"

/area/evilreaver/genetics
	icon_state = "medbay"
	name = "Forgotten Medical Research"

/area/evilreaver/storage
	icon_state = "storage"

/area/evilreaver/storage/engineering
	name = "Forgotten Engineering Storage"

/area/evilreaver/storage/tools
	name = "Forgotten Tools Storage"


/area/evilreaver/storage/emergency
	name = "Forgotten Emergency Storage A"

/area/evilreaver/storage/fire
	name = "Forgotten Emergency Storage B"

/area/evilreaver/atmospherics
	icon_state = "atmos"
	name = "Forgotten Atmospherics"

/area/evilreaver/security
	icon_state = "brigcell"
	name = "Forgotten Security"

/area/evilreaver/toxins
	icon_state = "toxlab"
	name = "Forgotten Toxins"

/area/evilreaver/chapel
	icon_state = "chapel"
	name = "Forgotten Chapel"
/area/evilreaver/bar
	icon_state = "bar"
	name = "Forgotten Bar"

/area/evilreaver/crew
	icon_state = "crewquarters"
	name = "Forgotten Crew Quarters"

/area/evilreaver/bridge
	icon_state = "bridge"
	name = "Forgotten Bridge"

//// Jam Mansion 3.0
/area/crypt/sigma
	name = "Research Facility Sigma"
	icon_state = "derelict"
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/evilr_d_ambi.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
				Obj << sound('sound/ambience/shipambience.ogg', repeat = 0, wait = 0, volume = 0, channel = 2)
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound
				var/mob/living/AM = Obj
				AM << sound('sound/ambience/shipambience.ogg', repeat = 1, wait = 0, volume = 50, channel = 2)

/area/crypt/sigma/mainhall
	icon_state = "chapel"
	name = "Research Facility Sigma"

/area/crypt/sigma/rd
	icon_state = "bridge"
	name = "Director's Quarters"

/area/crypt/sigma/lab
	icon_state = "toxlab"
	name = "Laboratory"

/area/crypt/sigma/crew
	icon_state = "crewquarters"
	name = "Crew Quarters"

/area/crypt/sigma/kitchen
	icon_state = "kitchen"
	name = "Kitchen"

/area/crypt/sigma/storage
	icon_state = "storage"
	name = "Storage Rooms"

///////////////////////////

/obj/item/clothing/suit/space/old
	name = "obsolete space suit"
	desc = "You probably wouldn't be able to fit into this."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "space_old"
	item_state = "space_old"
	cant_self_remove = 1

	equipped(var/mob/user, var/slot)
		boutput(user, "<span style=\"color:red\">Uh oh..</span>")
		..()

/obj/item/clothing/head/helmet/space/old
	name = "obsolete space helmet"
	desc = "This looks VERY uncomfortable!"
	icon_state = "space_old"
