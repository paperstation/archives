//CONTENTS:
//Halloween spooky thing spawn landmark
//Reader's death plaque.
//Bloody crate
//Unkillable power source thing.
//Spooky tombstone.
//Mind switching gizmo
//The spooky data of Dr. Horace Jam
//Factory data.
//Old outpost data.
//Haunted camera.
//Haunted television.
//~beepsky's diary~
//A stocking.  OKAY SO THAT IS CHRISTMAS AND NOT HALLOWEEN
//A button that kills you if you press it.  Used to log out of VR. And definitely not rude varedit trickery.
//A locker that traps folks.  I guess it's haunted.
//A spooky outer-space EVIL robuddy.  I guess that makes it...a roBADDY!
//A light that tends to die when powered.
//A decal that glows after spawning.
//Mainframe Stuff for H7 spacejunk
//Aberration critter for H7 spacejunk.
//Audiolog for H7
//The stupid artifact crown that started the whole H7 mess.
//A paint machine that can totally be repaired. For real.
//Cubicle walls.
//Old RCD prototypes that...don't work so well.
//A thing that makes pressure out of nothing. I guess it's magic!!

/*
 *	HALLOWEEN LANDMARK
 */
/obj/landmark/halloween
	name = "halloween spawn"

	New()
		..()
		if(istype(src.loc, /turf))
			halloweenspawn.Add(src.loc)
		qdel(src)

/*
 *	DEATH PLAQUE
 */

/obj/joeq/spooky
	name = "Memorial Plaque"

	examine()
		set src in view()
		boutput(usr, "Here lies [usr:real_name]. Loved by all. R.I.P.")
		return



/*
 *	UNKILLABLE shield. It makes dudes unkillable, it is not unkillable itself.
 */

/obj/item/unkill_shield
	name = "Shield of Souls"
	desc = "It appears to be a metal shield with blue LEDs glued to it."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "magic"

	pickup(mob/user)
		var/mob/living/carbon/human/H = user
		if(istype(H))
			boutput(user, "<i><b><font face = Tempus Sans ITC>EI NATH</font></b></i>")

			//EI NATH!!
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(4, 1, user)
			s.start()

			H.unkillable = 1
			H.gib(1)
			qdel(src)

/*
 *	Spooky TOMBSTONE.  It is a tombstone.
 */

/obj/tombstone
	name = "Tombstone"
	desc = "Here lies Tango N. Vectif, killed by a circus bear.  RIP."
	icon = 'icons/misc/halloween.dmi'
	icon_state = "tombstone"
	anchored = 1
	density = 1
	var/robbed = 0
	var/special = null //The path of whatever special loot is robbed from this grave.

/*
 *	Some sort of bizarre mind gizmo!
 */

/obj/submachine/mind_switcher
	name = "Jukebox"
	desc = "A classic 20th century jukebox. Ayyy!"
	icon = 'icons/obj/decoration.dmi'
	icon_state = "jukebox"
	anchored = 1
	density = 1
	var/last_switch = 0
	var/list/to_transfer = list() //List of mobs waiting to be shuffled back.
	var/teleport_next_switch = 0 //Should we hop somewhere else next switch?

	attack_ai(mob/user as mob)
		if(get_dist(src, user) <= 1)
			return attack_hand(user)
		else
			boutput(user, "This jukebox is too old to be controlled remotely.")
		return

	attack_hand(mob/user as mob)
		//This dude is no Fonz
		if (user.a_intent == "harm")
			user.visible_message("<span class='combat'><b>[user]</b> punches the [src]!</span>","You punch the [src].  Your hand hurts.")
			playsound(src.loc, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'), 100, 1)
			user.TakeDamage(user.hand == 1 ? "l_arm" : "r_arm", 0, rand(1, 4))
			return
		else
			src.visible_message("<b>[user]</b> thumps the [src]!  Ayy!")
			if(last_switch && ((last_switch + 1200) >= world.time))
				boutput(user, "Nothing happens.  What a ripoff!")
				return
			else
				last_switch = world.time
				src.mindswap()

		return

	proc/mindswap()
		src.visible_message("<span style=\"color:red\">The [src] activates!</span>")
		playsound(src.loc,"sound/effects/ghost2.ogg", 100, 1)

		var/list/transfer_targets = list()
		for(var/mob/living/M in view(6))
			if(M.loc == src) continue //Don't add the jerk trapped souls.
			if(M.key) //Okay cool, we have a player to transfer.
				var/mob/living/carbon/wall/holder = new
				holder.set_loc(src)
				if(M.mind)
					M.mind.transfer_to(holder)
				else
					holder.key = M.key

				holder.name = "Trapped Soul"
				holder.real_name = holder.name
				to_transfer.Add(holder)

			if(M.stat != 2 && M.loc != src) //No transferring to dead dudes.
				transfer_targets.Add(M)

			M.weakened = max(M.weakened, 3)

		if(!src.to_transfer.len || src.to_transfer.len == 1)
			src.visible_message("The [src] buzzes.")
			src.last_switch = 0
			if(src.teleport_next_switch)
				teleport_next_switch = 0
				src.telehop()
			return

		for(var/mob/living/M in src.to_transfer)
			if(!transfer_targets.len) //Welp, sucks for you dudes!
				src.visible_message("The [src] whirrs.  A small cry comes from within.")
				src.last_switch = max(0,src.last_switch - 60) //Reduce the wait a bit.

				if(src.teleport_next_switch)
					teleport_next_switch = 0
					src.telehop()

				return

			var/mob/living/new_body = pick(transfer_targets)
			if(!new_body || new_body.key || new_body.stat) //Oh no, it's been claimed/killed!
				continue

			if(M.client)
				new_body.lastKnownIP = M.client.address
				new_body.computer_id = M.client.computer_id
				M.lastKnownIP = null
				M.computer_id = null

			if(M.mind)
				M.mind.transfer_to(new_body)
			else
				new_body.key = M.key

			transfer_targets.Remove(new_body)
			blink(new_body)

			to_transfer.Remove(M)
			qdel(M)

		if(src.teleport_next_switch)
			teleport_next_switch = 0
			src.telehop()

		return

	proc/telehop()
		var/turf/T = pick(blobstart)
		if(T)
			src.visible_message("<span style=\"color:red\">[src] disappears!</span>")
			playsound(src.loc,"sound/effects/singsuck.ogg", 100, 1)
			src.set_loc(T)
		return

	disposing()
		for(var/mob/M in src.to_transfer)
			M.gib(1)
		to_transfer = null
		..()

/*
 *	The Dr. Horace Jam mystery notes
 */

/obj/item/reagent_containers/glass/beaker/strange_reagent
	name = "beaker-'Property of H. Jam'"
	desc = "A beaker labled 'Property of H. Jam'.  Can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker0"
	item_state = "beaker"

	New()
		..() // CALL YOUR GODDAMN PARENTS GODDAMNIT JESUS FUCKING CHRIST
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		R.add_reagent("strange_reagent", 50)

/obj/item/storage/secure/ssafe/hjam
	name = "Gun Storage"
	desc = "For Emergency Use Only"
	configure_mode = 0
	code = "54321"

	New()
		..()
/*
		new /obj/item/gun/fiveseven/hjam(src)
		new /obj/item/ammo/a57(src)
		new /obj/item/ammo/a57(src)
		new /obj/item/ammo/a57(src)

/obj/item/gun/fiveseven/hjam
	name = "SMRZ Six-seveN"
	desc = "A cheap Martian knock-off of a SM 0RZ Six-seveN. Uses 5.7mm rounds."
	weapon_lock = 0
*/
/obj/machinery/computer3/generic/hjam
	name = "Dr. Jam's Console"
	setup_starting_peripheral1 = /obj/item/peripheral/network/powernet_card
	setup_starting_peripheral2 = /obj/item/peripheral/printer
	setup_drive_type = /obj/item/disk/data/fixed_disk/hjam_rdrive

/obj/item/disk/data/fixed_disk/hjam_rdrive
	title = "HJam_HDD"

	New()
		..()
		//First off, create the directory for logging stuff
		var/datum/computer/folder/newfolder = new /datum/computer/folder(  )
		newfolder.name = "logs"
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/record/c3help(src))
		newfolder.add_file( new /datum/computer/file/text/hjam_passlog(src))
		//This is the bin folder. For various programs I guess sure why not.
		newfolder = new /datum/computer/folder
		newfolder.name = "bin"
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/terminal_program/writewizard(src))
		//new
		newfolder = new /datum/computer/folder
		newfolder.name = "research"
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/text/hjam_rlog_1(src))
		newfolder.add_file( new /datum/computer/file/text/hjam_rlog_2(src))
		newfolder.add_file( new /datum/computer/file/text/hjam_rlog_3(src))



//Old outpost stuff
/obj/machinery/computer3/generic/outpost1
	name = "VR Research Console"
	setup_starting_peripheral1 = /obj/item/peripheral/network/powernet_card
	setup_starting_peripheral2 = /obj/item/peripheral/printer
	setup_drive_type = /obj/item/disk/data/fixed_disk/outpost_rdrive

/obj/item/disk/data/fixed_disk/outpost_rdrive
	title = "VR_HDD"

	New()
		..()
		//First off, create the directory for logging stuff
		var/datum/computer/folder/newfolder = new /datum/computer/folder(  )
		newfolder.name = "logs"
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/record/c3help(src))
		//newfolder.add_file( new /datum/computer/file/text/hjam_passlog(src))
		//This is the bin folder. For various programs I guess sure why not.
		newfolder = new /datum/computer/folder
		newfolder.name = "bin"
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/terminal_program/writewizard(src))

		src.root.add_file( new /datum/computer/file/text/outpost_rlog_1(src))
		src.root.add_file( new /datum/computer/file/text/outpost_rlog_2(src))
		//src.root.add_file( new /datum/computer/file/text/hjam_rlog_3(src))

//Haunted camera. It's also broken.
/*
/obj/item/camera_test/haunted
	name = "rusty camera"


	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if (!can_use || !pictures_left || ismob(target.loc)) return

		var/turf/the_turf = get_turf(target)

		var/icon/photo = icon('icons/obj/items.dmi',"photo")

		var/icon/turficon = build_composite_icon(the_turf)
		turficon.Scale(22,20)

		photo.Blend(turficon,ICON_OVERLAY,6,8)

		var/mob_title = null
		var/mob_detail = null

		var/item_title = null
		var/item_detail = null

		var/list/cursed_mobs = list()
		var/list/ignore_statues = list()

		var/itemnumber = 0
		for(var/atom/A in the_turf)
			if(A.invisibility || istype(A, /obj/overlay/tile_effect)) continue
			if(A in ignore_statues) continue
			if(ismob(A))
				var/icon/X = build_composite_icon(A)
				X.Scale(22,20)
				photo.Blend(X,ICON_OVERLAY,6,8)
				qdel(X)

				if(!mob_title)
					mob_title = "[A]"
				else
					mob_title += " and [A]"

				var/mob/living/M = A
				if(istype(M) && M.key) //This poor bozo is going into a photo.
					var/mob/living/carbon/wall/halloween/holder = new
					holder.set_loc(src)
					holder.oldbody = M
					if(M.mind)
						M.mind.transfer_to(holder)
					else
						holder.key = M.key

					holder.name = "Trapped Soul"
					holder.real_name = holder.name
					cursed_mobs += holder

					blink(M)

					//Some cockatrice action
					var/obj/overlay/stoneman = new /obj/overlay(M.loc)
					ignore_statues += stoneman
					M.set_loc(stoneman)
					stoneman.name = "statue of [M.name]"
					stoneman.desc = "A really dumb looking statue. Very well carved, though."
					stoneman.anchored = 0
					stoneman.density = 1
					stoneman.layer = MOB_LAYER

					var/icon/composite = icon(M.icon, M.icon_state, M.dir, 1)
					for(var/O in M.overlays)
						var/image/I = O
						composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
					composite.ColorTone( rgb(188,188,188) )
					stoneman.icon = composite

				if(!mob_detail)

					var/holding = null
					if(iscarbon(A))
						var/mob/living/carbon/temp = A
						if(temp.l_hand || temp.r_hand)
							if(temp.l_hand) holding = "They are holding \a [temp.l_hand]"
							if(temp.r_hand)
								if(holding)
									holding += " and \a [temp.r_hand]."
								else
									holding = "They are holding \a [temp.r_hand]."

					if(!mob_detail)
						mob_detail = "You can see [A] on the photo - They seem to be screaming."
					else
						mob_detail += "You can also see [A] on the photo - They seem to be screaming"

			else
				if(itemnumber < 5)
					var/icon/X = build_composite_icon(A)
					X.Scale(22,20)
					photo.Blend(X,ICON_OVERLAY,6,8)
					qdel(X)
					itemnumber++

					if(!item_title)
						item_title = " \a [A]"
					else
						item_title = " some objects"

					if(!item_detail)
						item_detail = "\a [A]"
					else
						item_detail += " and \a [A]"

		var/finished_title = null
		var/finished_detail = null

		if(!item_title && !mob_title)
			finished_title = "boring photo"
			finished_detail = "This is a pretty boring photo of \a [the_turf]."
		else
			if(mob_title)
				finished_title = "photo of [mob_title][item_title ? " and[item_title]":""]"
				finished_detail = "[mob_detail][item_detail ? " Theres also [item_detail].":"."]"
			else if(item_title)
				finished_title = "photo of[item_title]"
				finished_detail = "You can see [item_detail]"

		var/obj/item/photo/haunted/P = new/obj/item/photo/haunted( get_turf(src) )

		P.icon = photo
		P.name = finished_title
		P.desc = finished_detail
		if(cursed_mobs.len)
			for(var/mob/cursed in cursed_mobs)
				cursed.set_loc(P)

		playsound(src.loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 75, 1, -3)

		pictures_left--
		if(pictures_left <= 0)
			pictures_left = initial(src.pictures_left)
		src.desc = "A one use - polaroid camera. [pictures_left] photos left."
		boutput(user, "<span style=\"color:blue\">[pictures_left] photos left.</span>")
		can_use = 0
		spawn(50) can_use = 1
*/

/mob/living/carbon/wall/halloween
	var/mob/oldbody = null

/mob/living/carbon/wall/horror
	say_quote(var/text)
		if(src.emote_allowed)
			if(!(src.client && src.client.holder))
				src.emote_allowed = 0

			if(src.gender == MALE) playsound(get_turf(src), "sound/voice/male_scream.ogg", 100, 0, 0, 0.91)
			else playsound(get_turf(src), "sound/voice/female_scream.ogg", 100, 0, 0, 0.9)
			spawn(50)
				src.emote_allowed = 1
			return "screams!"
		else
			return pick("gurgles.","shivers.","twitches.","shakes.","squirms.", "cries.")

/obj/item/photo/haunted
	attack_self(mob/user as mob)
		user.visible_message("<span class='combat'>[user] tears the photo to shreds!</span>","<span class='combat'>You tear the photo to shreds!</span>")
		qdel(src)
		return

	disposing()
		for(var/mob/living/carbon/wall/halloween/W in src)
			if(W.oldbody && !W.oldbody.key)
				if(W.mind)
					W.mind.transfer_to(W.oldbody)
				else
					W.oldbody.key = W.key

				var/obj/overlay/shell = W.oldbody.loc
				if(istype(shell))
					W.oldbody.set_loc(get_turf(W.oldbody))
					qdel(shell)


			W.gib()

		..()
		return

//Haunted television
/obj/haunted_television
	name = "Television"
	desc = "The television, that insidious beast, that Medusa which freezes a billion people to stone every night, staring fixedly, that Siren which called and sang and promised so much and gave, after all, so little."
	icon = 'icons/obj/computer.dmi'
	icon_state = "security_det"
	anchored = 1
	density = 1

	attack_hand(mob/user as mob)
		boutput(user, "<span class='combat'>The knobs are fixed in place.  Might as well sit back and watch, I guess?</span>")

	examine()
		set src in oview()
		if (ishuman(usr) && !usr.stat)
			var/mob/living/carbon/human/M = usr

			M.visible_message("<span class='combat'>[M] stares blankly into [src], \his eyes growing duller and duller...</span>","<span class='combat'>You stare deeply into [src].  You...can't look away.  It's mesmerizing.  Sights, sounds, colors, shapes.  They blur together into a phantasm of beauty and wonder.</span>")
			var/mob/living/carbon/wall/halloween/holder = new
			holder.set_loc(src)
			holder.oldbody = M
			if(M.mind)
				M.mind.transfer_to(holder)
			else
				holder.key = M.key

			holder.name = "Trapped Soul"
			holder.real_name = holder.name

			blink(M)

			//Some more cockatrice action
			var/obj/overlay/stoneman = new /obj/overlay(M.loc)
			M.set_loc(stoneman)
			stoneman.name = "statue of [M.name]"
			stoneman.desc = "A really dumb looking statue. Very well carved, though."
			stoneman.anchored = 0
			stoneman.density = 1
			stoneman.layer = MOB_LAYER

			var/icon/composite = icon(M.icon, M.icon_state, M.dir, 1)
			for(var/O in M.overlays)
				var/image/I = O
				composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
			composite.ColorTone( rgb(188,188,188) )
			stoneman.icon = composite

			holder.set_loc(stoneman)
			stoneman.dir = get_dir(stoneman, src)

		else
			boutput(usr, desc)
			return

// the critters are now in the critter files because NOT EVERYTHING NEEDS TO BE IN HERE OKAY

// also /obj/item/storage/nerd_kit/New() is in storage.dm with /obj/item/storage/nerd_kit instead of RANDOMLY FLOATING AROUND IN HERE WHAT IS WRONG WITH YOU PEOPLE

/obj/stocking
	name = "stocking"
	desc = "The most festive kind of sock!"
	icon = 'icons/misc/xmas.dmi'
	icon_state = "stocking_red"
	anchored = 1
	var/list/giftees = list()
	var/list/gift_paths = list(/obj/item/basketball, /obj/item/clothing/head/cakehat, /obj/item/clothing/mask/melons, /obj/item/old_grenade/banana,
						/obj/item/bikehorn, /obj/item/vuvuzela, /obj/item/horseshoe, /obj/item/clothing/suit/sweater/red, /obj/item/clothing/suit/sweater,
						/obj/item/clothing/suit/sweater/green, /obj/item/clothing/glasses/monocle, /obj/item/coin, /obj/item/clothing/gloves/fingerless,
						/obj/item/clothing/mask/spiderman, /obj/item/clothing/shoes/flippers, /obj/item/clothing/under/gimmick/cosby)
	var/list/questionable_gift_paths = list(/obj/item/engibox, /obj/item/relic, /obj/item/gun/energy/bfg, /obj/item/stimpack, /obj/item/old_grenade/light_gimmick)
	var/danger_chance = 1
	var/booby_trapped = 0

	New()
		..()
		if(prob(50))
			icon_state = "stocking_green"
		if (map_setting == "DESTINY")
			questionable_gift_paths -= /obj/item/engibox
			questionable_gift_paths -= /obj/item/gun/energy/bfg
			questionable_gift_paths -= /obj/item/old_grenade/light_gimmick
		return

	attack_hand(mob/user as mob)
		if (..())
			return

		if (user.key in giftees)
			boutput(user, "<span class='combat'>You've already gotten something from here, don't be greedy!</span>")
			boutput(user, "<span class='combat'><font size=1>Note: If this message is in error, please call 1-555-BAD-GIFT.</font></span>")
			return

		giftees += user.key

		if (src.booby_trapped)
			boutput(user, "<span style=\"color:red\">There is a pissed off snake in the stocking! It bites you! What the hell?!</span>")
			modify_christmas_cheer(-5)
			if (user.reagents)
				user.reagents.add_reagent("venom", 5)
		else
			modify_christmas_cheer(2)
			var/dangerous = 0
			var/giftpath
			if (prob(danger_chance))
				dangerous = 1
				giftpath = pick(questionable_gift_paths)
			else
				giftpath = pick(gift_paths)

			var/obj/item/gift = new giftpath
			user.put_in_hand_or_drop(gift)

			if (dangerous)
				user.visible_message("<span class='combat'><b>[user.name]</b> takes [gift] out of [src]!</span>", "<span class='combat'>You take [gift] out of [src]!<br>This looks dangerous...</span>")
			else
				user.visible_message("<span style=\"color:blue\"><b>[user.name]</b> takes [gift] out of [src]!</span>", "<span style=\"color:blue\">You take [gift] out of [src]!</span>")
		return

//A button that kills you if you press it. That's pretty much the gist of it.
/obj/death_button
	name = "button that will kill you if you press it"
	desc = "A button.  One that kills you (if you press it)."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	layer = EFFECTS_LAYER_UNDER_1
	anchored = 1

	attack_hand(mob/user as mob)
		if (!user.stat)
			user.death()
		return

//A closet that traps you when you step onto it!
//obj/closet/haunted
/obj/storage/closet/haunted
	var/throw_strength = 100

	New()
		..()
		src.open()
		return

	HasEntered(atom/movable/A as mob|obj, atom/OldLoc)
		if (!src.open || src.welded || !isliving(A))
			return ..()

		A.throwing = 0
		A.set_loc(src) //Get them for sure!
		if (!src.close())
			A.set_loc(get_turf(src))//or not, welp
			return

		src.welded = 1
		A.set_loc(src) //Stay in there, jerk!!

		var/mob/living/M = A
		if (!istype(M) || M.loc != src)
			return

		if (M.throw_count || istype(OldLoc, /turf/space) || (M.m_intent != "walk"))
			var/flingdir = turn(get_dir(src.loc, OldLoc), 180)
			src.throw_at(get_edge_target_turf(src, flingdir), throw_strength, 1)
		return

//A robuddy that has gone mad. plum loco. unhinged. cabin crazy
/obj/machinery/bot/guardbot/bad
	name = "Secbuddy"
	desc = "An early sub-model of the popular PR-6S Guardbuddy line. It seems to be in rather poor shape, both physically and otherwise"
	icon = 'icons/misc/hstation.dmi'

	control_freq = 1089
	beacon_freq = 1431

	no_camera = 1
	flashlight_red = 0.4
	flashlight_green = 0.1
	flashlight_blue = 0.1

	setup_charge_maximum = 800
	setup_default_startup_task = /datum/computer/file/guardbot_task/security/crazy
	setup_default_tool_path = /obj/item/device/guardbot_tool/taser
	no_camera = 1

	New()
		..()
		req_access = list(8088)

	speak(var/message)
		if((!src.on) || (src.idle) || (!message))
			return

		var/scramblemode = rand(1,10)
		switch(scramblemode)
			if (5)
				var/list/stutterList = dd_text2list(message, " ")
				if (stutterList.len > 1)
					var/stutterPoint = rand( round(stutterList.len/2), stutterList.len )
					stutterList.len = stutterPoint
					message = ""

					var/endPoint = stutterList.len + rand(1,3)
					for (var/i = 1, i <= endPoint, i++)
						if (i <= stutterList.len)
							message += "[stutterList[i]] "
						else
							message += "-[uppertext(stutterList[stutterList.len])]"

			if (6)
				var/list/bzztList = dd_text2list(message, " ")
				if (bzztList.len > 1)
					for (var/i = 1, i <= bzztList.len, i++)
						if (prob( min(5*i, 20) ))
							bzztList[i] = pick("*BZZT*","*ERRT*","*WONK*", "*ZORT*", "*BWOP*", "BWEET")

					message = dd_list2text(bzztList, " ")

			if (7)
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='combat'><b>[src]'s speaker crackles oddly!</b></span>", 2)
				return

			if (8)
				message = uppertext(message)

		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"",2)
		return


//Older lighting that doesn't power up so well anymore.
/obj/machinery/light/worn
	desc = "A rather old-looking lighting fixture."
	brightness = 1
	switchcount = 50 //break probability is (50*50*0.01) = 25%

//Decals that glow.
/obj/decal/glow
	var/brightness = 0
	var/color_r = 0.36
	var/color_g = 0.35
	var/color_b = 0.21
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.attach(src)
		light.set_color(src.color_r, src.color_g, src.color_b)
		light.set_brightness(src.brightness / 5)
		light.enable()

//Decals that float.
/obj/decal/float
	New()
		..()
		.= rand(5, 20)

		spawn(rand(1,10))
			animate(src, pixel_y = 32, transform = matrix(., MATRIX_ROTATE), time = 20, loop = -1, easing = SINE_EASING)
			animate(pixel_y = 0, transform = matrix(-1 * ., MATRIX_ROTATE), time = 20, loop = -1, easing = SINE_EASING)


	clock
		name = "floating clock"
		desc = "That's unusual."
		icon = 'icons/misc/worlds.dmi'
		icon_state = "ghostclock0"

		New()
			..()
			icon_state += pick("", "1","2")

//Mainframe stuff for the H7 spacejunk.
/obj/machinery/networked/mainframe/h7
	setup_drive_type = /obj/item/disk/data/memcard/h7


/obj/item/disk/data/memcard/h7
	file_amount = 1024

	New()
		..()
		var/datum/computer/folder/newfolder = new /datum/computer/folder(  )
		newfolder.name = "sys"
		newfolder.metadata["permission"] = COMP_HIDDEN
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/mainframe_program/os/kernel(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/shell(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/login(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/h7init(src) )

		var/datum/computer/folder/subfolder = new /datum/computer/folder
		subfolder.name = "drvr" //Driver prototypes.
		newfolder.add_file( subfolder )
		//subfolder.add_file ( new FILEPATH GOES HERE )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/mountable/databank(src) )
		//subfolder.add_file( new /datum/computer/file/mainframe_program/driver/mountable/printer(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/nuke(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/mountable/guard_dock(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/mountable/radio(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/secdetector(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/apc(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/hept_emitter(src) )
		subfolder.add_file( new /datum/computer/file/mainframe_program/driver/mountable/user_terminal(src) )

		newfolder = new /datum/computer/folder
		newfolder.name = "bin" //Applications available to all users.
		newfolder.metadata["permission"] = COMP_ROWNER|COMP_RGROUP|COMP_ROTHER
		src.root.add_file( newfolder )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/cd(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/ls(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/rm(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/cat(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/mkdir(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/ln(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/chmod(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/chown(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/su(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/cp(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/mv(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/utility/mount(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/hept_interface(src) )
		newfolder.add_file( new /datum/computer/file/mainframe_program/guardbot_interface(src) )

		newfolder = new /datum/computer/folder
		newfolder.name = "mnt"
		newfolder.metadata["permission"] = COMP_ROWNER|COMP_RGROUP|COMP_ROTHER
		src.root.add_file( newfolder )

		newfolder = new /datum/computer/folder
		newfolder.name = "conf"
		newfolder.metadata["permission"] = COMP_ROWNER|COMP_RGROUP|COMP_ROTHER
		src.root.add_file( newfolder )

		var/datum/computer/file/record/testR = new
		testR.name = "motd"
		testR.fields += "Welcome to DWAINE System VI!"
		testR.fields += "Hemera Research System Distribution"
		newfolder.add_file( testR )

		newfolder.add_file( new /datum/computer/file/record/dwaine_help(src) )

		newfolder = new /datum/computer/folder
		newfolder.name = "etc"
		newfolder.metadata["permission"] = COMP_ROWNER|COMP_RGROUP|COMP_ROTHER
		src.root.add_file( newfolder )

		newfolder.add_file( new /datum/computer/file/guardbot_task/bodyguard(src) )
		newfolder.add_file( new /datum/computer/file/guardbot_task/security(src) )

		return

/obj/item/disk/data/tape/h7_logs
	name = "ThinkTape-'Logs'"
	desc = "A reel of magnetic data tape containing various log files."

	New()
		..()
		src.root.add_file( new /datum/computer/file/record/h7_analysislog(src) )
		src.root.add_file( new /datum/computer/file/record/h7_memo1(src) )
		src.root.add_file( new /datum/computer/file/record/h7_memo2(src) )
		src.root.add_file( new /datum/computer/file/record/h7_memo3(src) )

//
/datum/computer/file/record/h7_analysislog
	name = "analysis_log"

	New()
		..()
		src.fields = list("-----------------|HEAD|-----------------",
"Object Analysis Log - TH JUN 09 2050",
"SITE: 1801-VM HEMERA VII",
"SUBJECT: 1801-VM MA-1",
"-------------|TEST RESULTS|-------------",
"FALD-MS: Inconclusive",
"EBSD: Orientation recorded in doc 3901-A",
"Electroanalysis: Insulative.",
"GOOD LOOK-OVER: Sorta resembles a crown.",
"HEPT: Scheduled JUN 11 2050",
"--------------|MISC NOTES|--------------",
"1801-VM MA-1 resembles a black crown, it",
"looks almost manufactured, but the odd",
"properties it exhibits and the relative",
"complexity of design fully elimate the",
"possibility of it having been fabricated",
"by the miners here.",
"Analysis results thus far have been",
"frustratingly inconclusive, though it is",
"speculated that it is similar in compos-",
"ition to highly-refined FAAE composites.",
"----------------------------------------")

/datum/computer/file/record/h7_memo1
	name = "1281"

	New()
		..()
		src.fields = list("-----------------|HEAD|-----------------",
"MEMORANDUM 1.281 - MO MAY 30 2050",
"TO: H7 Research Staff",
"FROM: Jack Tott, Stations Manager",
"SUBJECT: Settling In",
"-----------------|BODY|-----------------",
"Good Morning, Team! I'm sure that by now",
"you've settled into your new workspace.",
"I'm sure you'll find the analysis lab",
"well-stocked and accomodating. A rather",
"fascinating object has revealed itself,",
"and I trust no-one more with uncovering",
"its worth than you.",
"",
"HARC put the telecrystal to work, I have",
"no doubt you can do the same here!",
"----------------------------------------")

/datum/computer/file/record/h7_memo2
	name = "1306"

	New()
		..()
		src.fields = list("-----------------|HEAD|-----------------",
"MEMORANDUM 1.306 - WE JUN 08 2050",
"TO: H7 Research Staff",
"FROM: Jack Tott, Stations Manager",
"SUBJECT: Urgency",
"-----------------|BODY|-----------------",
"Though I personally have only the utmost",
"faith in your collective abilities to",
"study this rare and fantastic find in",
"materials science, I must stress the",
"importance of determining a profitable",
"application for the 1801 artifact for",
"the Hemera Astral Research Corporation.",
"Nanotrasen's recent developments in the",
"way of matter transposition are, though",
"greatly inferior to our own telecrystal",
"products, alarmingly competitive w/r/t",
"unit cost.",
"",
"I do not mean to imply that a failure to",
"quickly find a use for this could leave",
"us all unemployed, but",
"well no that is exactly it. Good luck.",
"----------------------------------------")

/datum/computer/file/record/h7_memo3
	name = "1307"

	New()
		..()
		src.fields = list("-----------------|HEAD|-----------------",
"MEMORANDUM 1.307 - WE JUN 08 2050",
"TO: Doug Welker",
"FROM: Jack Tott, Stations Manager",
"SUBJECT: Promotion!",
"-----------------|BODY|-----------------",
"Congratulations, Doug! I am ecstatic to",
"say that your years of dedication to the",
"company have not gone unnoticed, and as",
"such, you have been assigned as the lead",
"manager for the Advertising and Design",
"division!",
"The first department project under your",
"lead is as follows: Creation of print ad",
"and associated campaign for our new Mk15",
"Rapid-Construction Device! The Mk15 is",
"being released on the tenth anniversary",
"of the release of our flagship RCD line.",
"(Should probably work that in!)",
"The contact information for the rest of",
"the department will be appended to this",
"memo! Good luck!",
"-------------|CONTACTS|-----------------",
"ERR 2 - No Other Personnel in Dept.",
"----------------------------------------")

//H7 Audiolog
/obj/item/device/audio_log/h7
	audiolog_messages = list("*harsh static*",
"-bringing the emitter online...now. Raising it up to full power. The crown is in position.",
"Can't call it that, Jack, go by the book.",
"Right, right, fine. Eighteen-Oh-One Vee-Em Em-Ay-One is in position. That better?",
"Alright, crown. Crissakes, Jack.",
"*harsh static*",
"I'm getting some bad harmonics on the readout here, either the sensors are out or-",
"*electrical crackle*",
"holy mother of God, what is th-",
"*static*")
	audiolog_speakers = list("???",
"Unknown Man",
"Other Man",
"Jack",
"Other Man",
"???",
"Jack",
"???",
"Jack",
"???")

/obj/item/paper/hept_qr
	name = "paper- 'HEPT Quick-Reference'"
	info = {"<center><h3>HEPT Interface Quick Reference</h3></center><hr>
<h4>Basics</h4>
<ul>
<li>HEPT Interface Program "HEPTMAN" is located in the /bin directory, as such, it is treated as basic command and may be invoked from any position in the filesystem.</li>
<li>"HEPTMAN STATUS" will list activation status of emitter.</li>
<li>"HEPTMAN ACTIVATE" will send activation signal to emitter.</li>
<li>"HEPTMAN DEACTIVATE" will send deactivation signal to emitter.</li>
</ul>
<hr>
<h4>Activation Procedure</h4>
<ol>
<li>Insert 1-5 <b>Precut Telecrystal Modules</b> into inactive HEPT emitter.</li>
<li>Confirm that analysis equipment is in place and all emission lines are evacuated of personnel.</li>
<li>Log in to mainframe system on local terminal.</li>
<li>Enter command "HEPTMAN ACTIVATE"</li>
<li>Record results, etc.</li>
<li>Enter command "HEPTMAN DEACTIVATE"</li>
</ol>"}

//This is the Obsidian Crown. It just wants to be your friend and protect you :)
//Unfortunately, the crazy void energy or whatever it emits is lethal.
/obj/item/clothing/head/void_crown
	name = "obsidian crown"
	desc = "A crown, apparently made of obsidian, and also apparently very bad news."
	icon_state = "obcrown"

	magical = 1
	var/processing = 0
	var/armor_paired = 0
	var/max_damage = 0

	equipped(var/mob/user, var/slot)
		cant_self_remove = 1
		cant_other_remove = 1
		if (!src.processing)
			src.processing++
			if (!(src in processing_items))
				processing_items.Add(src)

		if (istype(user.reagents)) //Protect them from poisions! (And coincidentally healing chems OH WELL)
			user.reagents.maximum_volume = 0

		hear_voidSpeak("Hello, friend.")
		hear_voidSpeak("Your world is so dangerous! Let me help you.")

	process()
		var/mob/living/host = src.loc
		if (!istype(host))
			processing_items.Remove(src)
			processing = 0
			return

		if (armor_paired)
			if (prob(15) && armor_paired < 3)
				switch (armor_paired++)
					if (1)
						hear_voidSpeak("Greetings, new traveler!  My Friend and I, not wishing to pry, wonder what has brought you to our jolly band!")
					if (1)
						hear_voidSpeak("How wonderous!  Our newest friend shares our appetite for adventure!  I dub thee \"Journeyman.\"")
					if (2)
						hear_voidSpeak("How lucky you are, Friend, how truly blessed!  Companions guarding your form entirely from the risks of the material!")


		else if (ishuman(host) && istype(host:wear_suit, /obj/item/clothing/suit/armor/ancient))
			armor_paired = 1
			hear_voidSpeak("My, my, my, who is this?  A new companion on our pilgrimage?")

		var/obj/item/storage/toolbox/memetic/that_jerk = locate(/obj/item/storage/toolbox/memetic) in host
		if (istype(that_jerk)) //We do not like His Grace!!
			hear_voidSpeak("Oh dear, Friend! Why would you associate with such a Beast as that?  Let me help you--that Fiend seeks only your destruction!")
			host.u_equip(that_jerk)
			if (that_jerk)
				that_jerk.dropped(host)
				that_jerk.layer = initial(that_jerk.layer)
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(4, 1, host)
				s.start()
				var/list/randomturfs = new/list()
				for(var/turf/T in orange(host, 25))
					if(T.density)
						continue
					randomturfs.Add(T)
				boutput(host, "<span class='combat'>[that_jerk] is warped away!</span>")
				playsound(host.loc, "sound/effects/mag_warp.ogg", 25, 1, -1)
				that_jerk.set_loc(pick(randomturfs))

		if (host.get_damage() < 0)
			src.abandonHost()
			return
		else if (prob(4) && (host.get_damage() < 50))
			hear_voidSpeak( pick("Carry on through the pain, Friend! Carry on through the pain! I shall protect always!","Have no fear, Friend! No fear, for only a fool would raise their hand against you!","Why do you slow, Friend? We still have much to see!") )
		else if (prob(4))
			hear_voidSpeak( pick("Be spry, Friend, be nimble! We shall visit all there is to visit and do all there is to do!","Let no ache delay you, for pain is transient! Luminous beings are not held back by such mortal things!","How fantastic this space is! I had grown so tired of immaterial things.") )

		//The crown takes retribution on attackers -- while slowly killing the host.
		if (host.lastattacker && (host.lastattackertime + 40) >= world.time)
			if(host.lastattacker != host)
				hear_voidSpeak( pick("I shall aid, Friend!","No fear, Friend, no fear! I shall assist!","No need to raise your hand, I shall defend!") )

				var/mob/M = host.lastattacker
				if (!istype(M))
					return

				host.lastattacker = null
				var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
				s.set_up(4, 1, M)
				s.start()
				var/list/randomturfs = new/list()

				. = isrestrictedz(host.z)
				for(var/turf/T in orange(M, 25))
					if(T.density)
						continue
					if (. && T.loc != get_area(M)) //If we're in a telesci area and this is a change in area.
						continue

					randomturfs.Add(T)

				boutput(M, "<span style=\"color:blue\">You are caught in a magical warp field!</span>")
				M.visible_message("<span class='combat'>[M] is warped away!</span>")
				playsound(M.loc, "sound/effects/mag_warp.ogg", 25, 1, -1)
				M.set_loc(pick(randomturfs))

		if (armor_paired != -1 && prob(50) && host.max_health > 10)
			host.max_health--
			//Away with ye, all hope of healing.
			//random_brute_damage(host, 1)

		host.stunned = 0
		host.weakened = 0
		host.paralysis = 0
		host.dizziness = max(0,host.dizziness-10)
		host.drowsyness = max(0,host.drowsyness-10)
		host.sleeping = 0

		host.updatehealth()
		return

	proc/hear_voidSpeak(var/message)
		if (!message)
			return
		var/mob/wearer = src.loc
		if (!istype(wearer))
			return
		var/voidMessage = voidSpeak(message)
		if (voidMessage)
			boutput(wearer, "[voidMessage]")
		return

	proc/abandonHost()
		var/mob/living/host = src.loc
		if (!istype(host))
			return

		if (armor_paired != 0 && ishuman(host))
			if (armor_paired != -1)
				armor_paired = -1
				host.ghostize()
				if (istype(host.ghost))
					var/mob/dead/observer/theGhost = host.ghost
					theGhost.corpse = null
					host.ghost = null

			var/mob/living/carbon/human/humHost = host

			humHost.HealDamage("All", 1000, 1000)
			humHost.take_toxin_damage(-INFINITY)
			humHost.take_oxygen_deprivation(-INFINITY)
			humHost.paralysis = 0
			humHost.stunned = 0
			humHost.weakened = 0
			humHost.radiation = 0
			humHost.take_eye_damage(-INFINITY)
			humHost.take_ear_damage(-INFINITY)
			humHost.take_ear_damage(-INFINITY, 1)
			humHost.health = 100
			humHost.buckled = initial(humHost.buckled)
			humHost.handcuffed = initial(humHost.handcuffed)
			humHost.bodytemperature = humHost.base_body_temp

			humHost.stat=0

			humHost.full_heal()

			humHost.decomp_stage = 4
			humHost.bioHolder.RemoveEffect("eaten")
			humHost.updatehealth()
			humHost.set_body_icon_dirty()
			humHost.set_face_icon_dirty()

			if (!humHost.is_npc)
				humHost.is_npc = 1
				humHost.ai_init()

			return

		hear_voidSpeak("Time to leave already? Shame, shame, but what a time we had!")

		for(var/mob/N in viewers(host, null))
			N.flash(30)
			if(N.client)
				shake_camera(N, 6, 4)
				N.show_message("<span class='combat'><b>A blinding light envelops [host]!</b></span>")

		playsound(src.loc, "sound/weapons/flashbang.ogg", 50, 1)

		src.set_loc(get_turf(host))
		processing_items.Remove(src)
		processing = 0
		cant_self_remove = 1
		cant_other_remove = 1

		host.vaporize()

		return


//This is me being mean to the players.
/obj/machinery/vending/paint/broken
	name = "Broken Paint Dispenser"
	desc = "Would dispense paint, if it were not broken."
	icon = 'icons/obj/vending.dmi'
	icon_state = "paint-vend"
	anchored = 1
	density = 1
	var/repair_stage = 0
	var/paint_needed = 20

	attack_hand(mob/user as mob)
		boutput(user, "<span style=\"color:red\">This must be repaired before it can be used!</span>")
		add_fingerprint(user)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (!W || !user)
			return

		if(istype(W,/obj/item/paint_can))
			if (repair_stage == 4)
				var/obj/item/paint_can/can = W
				if (!can.uses)
					boutput(user, "The can is empty.")
					return

				can.uses--
				paint_needed--
				if (!paint_needed)
					user.visible_message("[user] pours some paint into [src]. The \"check paint cartridge\" light goes out.", "You pour some paint into [src], filling it up!")
					src.repair_stage = 5
					src.name = "Very-Nearly-Functional Paint Dispenser"
					desc = "Would dispense paint, if only the service module was resecured and the panel was replaced."
					return

				user.visible_message("[user] pours some paint into [src].", "You pour some paint into [src]. ([paint_needed] units still needed)")
			else
				boutput(user, "<span style=\"color:red\">You need to repair the machine first!</span>")
			return

		else
			switch(repair_stage)
				if (0)
					if (istype(W, /obj/item/screwdriver))
						user.visible_message("[user] begins to unscrew the maintenance panel.","You begin to unscrew the maintenance panel.")
						playsound(user, "sound/items/Screwdriver2.ogg", 65, 1)
						if (!do_after(user, 20) || repair_stage)
							return
						repair_stage = 1
						user.visible_message("[user] finishes unscrewing the maintenance panel.")
						src.desc = "Would dispense paint, if it were not broken. The maintenance panel has been unscrewed."
					else
						boutput(user, "<span style=\"color:red\">The maintenance panel needs to be unscrewed first!</span>")
						return

				if (1)
					if (istype(W, /obj/item/crowbar))
						user.visible_message("[user] begins to pry off the maintenance panel.","You begin to pry off the maintenance panel.")
						playsound(user, "sound/items/Crowbar.ogg", 65, 1)
						if (!do_after(user, 20) || (repair_stage != 1))
							return
						repair_stage = 2
						user.visible_message("[user] pries open the maintenance panel, exposing the service module!")
						var/obj/item/tile/steel/panel = new /obj/item/tile/steel(src.loc)
						panel.name = "maintenance panel"
						panel.desc = "A panel that is clearly from a paint dispenser. Obviously."

						src.desc = "Would dispense paint, if it were not broken. The maintenance panel has been removed."
					else
						boutput(user, "<span style=\"color:red\">The maintenance panel needs to be pried open first!</span>")
						return

				if (2)
					if (istype(W, /obj/item/wrench))
						user.visible_message("[user] begins to loosen the service module bolts.","You begin to loosen the service module bolts.")
						playsound(user, "sound/items/Ratchet.ogg", 65, 1)
						if (!do_after(user, 30) || (repair_stage != 2))
							return
						repair_stage = 3
						user.visible_message("[user] looses the service module bolts, exposing the burnt wiring within.")

						src.desc = "Would dispense paint, if it were not broken. The maintenance panel has been removed and the service module has been loosened."
					else
						boutput(user, "<span style=\"color:red\">The bolts on the service module must be loosened first!</span>")
						return

				if (3)
					if (istype(W, /obj/item/cable_coil))
						var/obj/item/cable_coil/coil = W
						if (W.amount < 20)
							boutput(user, "<span style=\"color:red\">You do not have enough cable to replace all of the burnt wires! (20 units required)</span>")
							return
						user.visible_message("[user] begins to replace the burnt wires.","You begin to replace the burnt wires.")
						playsound(user, "sound/items/Deconstruct.ogg", 65, 1)
						if (!do_after(user, 100) || (repair_stage != 3))
							return

						coil.use(20)
						repair_stage = 4
						user.visible_message("[user] replaces the burnt wiring in [src]. A \"check paint cartridge\" light begins to blink.")

						src.name = "Partially-Repaired Paint Dispenser"
						src.desc = "Would dispense paint, if it were not broken. The maintenance panel has been removed and the wiring has been replaced. A \"check paint cartridge\" light is blinking."
					else
						boutput(user, "<span style=\"color:red\">The wiring on the service module must be replaced first!</span>")
						return

				if (5)
					if (istype(W, /obj/item/wrench))
						user.visible_message("[user] begins to tighten the service module bolts.","You begin to tighten the service module bolts.")
						playsound(user, "sound/items/Ratchet.ogg", 65, 1)
						if (!do_after(user, 30) || (repair_stage != 5))
							return
						repair_stage = 6
						user.visible_message("[user] tightens the service module bolts.")

						src.name = "Almost Fully Repaired and Properly Serviced Paint Dispenser"
						src.desc = "Would dispense paint, if only the maintenance panel was replaced."
					else
						boutput(user, "<span style=\"color:red\">The bolts on the service module must be secured first!</span>")
						return

				if (6)
					if (istype(W, /obj/item/tile))
						if (W.name != "maintenance panel")
							user.visible_message("[user] tries to use a common floor tile in place of the maintenance panel! How silly!", "<span style=\"color:red\">That is a floor tile, not a maintenance panel! It doesn't even fit!</span>")
							return
						user.visible_message("[user] begins to replace the maintenance panel.","You begin to replace the maintenance panel.")
						playsound(user, "sound/items/Deconstruct.ogg", 65, 1)
						if (!do_after(user, 50) || (repair_stage != 6))
							return
						repair_stage = 7
						qdel(W)
						user.visible_message("[user] replaces the maintenace panel.")

						src.name = "One-Step-Away-from-Being-Fully-Repaired Paint Dispenser"
						src.desc = "Would dispense paint, if only the maintenance panel was secured so as to allow operation."
					else
						boutput(user, "<span style=\"color:red\">The service panel must be replaced first!</span>")
						return

				if (7)
					if (istype(W, /obj/item/screwdriver))
						user.visible_message("[user] begins to secure the maintenance panel..","You begin to secure the maintenance panel.")
						playsound(user, "sound/items/Screwdriver2.ogg", 65, 1)
						if (!do_after(user, 100) || (repair_stage != 7))
							return
						repair_stage = 8
						if (prob(5))
							user.visible_message("[user] secures the maintenance panel!", "You secure the maintenance panel.")
							new /obj/machinery/vending/paint(src.loc)
							qdel(src)
							return
						user.visible_message("<span style=\"color:red\"><b>[user] slips, knocking the paint dispenser over!.</b></span>")
						boutput(user, "<b><font color=red>OH FUCK</font></b>")

						src.name = "Irreparably Destroyed Paint Dispenser"
						src.desc = "Damaged beyond all repair, this will never dispense paint ever again."

						flick("vendbreak", src)
						spawn(8)
							src.icon_state = "fallen"
							sleep(70)
							playsound(src.loc, "sound/effects/Explosion2.ogg", 100, 1)

							var/obj/effects/explosion/delme = new /obj/effects/explosion(src.loc)
							delme.fingerprintslast = src.fingerprintslast

							invisibility = 100
							density = 0
							sleep(150)
							qdel(delme)
							qdel(src)
							return

					else
						boutput(user, "<span style=\"color:red\">The service panel must be secured first!</span>")
						return





//Cubicle walls! Also for the crunch.
/obj/window/cubicle
	name = "cubicle panel"
	desc = "The bland little uniform panels that make up the modern office place. It is within them that you will spend your adult life.  It is within them that you will die."
	icon = 'icons/obj/structures.dmi'
	icon_state = "cubicle"
	opacity = 1
	hitsound = 'sound/effects/grillehit.ogg'
	shattersound = 'sound/effects/grillehit.ogg'

	New()
		return

	examine()
		set src in oview()
		boutput(usr, desc)

	smash()
		if(health <= 0)
			qdel(src)

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/screwdriver))
			src.anchored = !( src.anchored )
			playsound(src.loc, "sound/items/Screwdriver.ogg", 75, 1)
			user << (src.anchored ? "You have fastened the cubicle panel to the floor." : "You have unfastened the cubicle panel.")
			return

		else
			..()

//Broken RCDs.  Attempting to use them is...ill advised.
/obj/item/broken_rcd
	name = "prototype rapid-construction-device (RCD)"
	desc = "A device used to rapidly build walls/floor."
	icon = 'icons/obj/items.dmi'
	icon_state = "bad_rcd0"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "rcd"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	m_amt = 50000
	var/mode = 1
	var/broken = 0 //Fully broken, that is.
	var/datum/effects/system/spark_spread/spark_system

	New()
		..()
		src.icon_state = "bad_rcd[rand(0,2)]"
		src.spark_system = unpool(/datum/effects/system/spark_spread)
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/rcd_ammo))
			boutput(user, "The RCD slot is not compatible with this cartridge.")
			return

	attack_self(mob/user as mob)
		if (src.broken)
			boutput(user, "<span style=\"color:red\">It's broken!</span>")
			return

		playsound(src.loc, "sound/effects/pop.ogg", 50, 0)
		if (mode)
			mode = 0
			boutput(user, "Changed mode to 'Deconstruct'")
			src.spark_system.start()
			return
		else
			mode = 1
			boutput(user, "Changed mode to 'Floor & Walls'")
			src.spark_system.start()
			return

	afterattack(atom/A, mob/user as mob)
		if (src.broken > 1)
			boutput(user, "<span style=\"color:red\">It's broken!</span>")
			return

		if (!(istype(A, /turf) || istype(A, /obj/machinery/door/airlock)))
			return
		if ((istype(A, /turf/space) || istype(A, /turf/simulated/floor)) && mode)
			if (src.broken)
				boutput(user, "<span style=\"color:red\">Insufficient charge.</span>")
				return

			boutput(user, "Building [istype(A, /turf/space) ? "Floor (1)" : "Wall (3)"]...")

			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user, 20))
				if (src.broken)
					return

				src.broken++
				spark_system.set_up(5, 0, src)
				src.spark_system.start()
				playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)

				for (var/turf/T in orange(1,user))
					T.ReplaceWithWall()


				boutput(user, "<span style=\"color:red\">The RCD shorts out!</span>")
				return

		else if (!mode)
			boutput(user, "Deconstructing ??? ([rand(1,8)])...")

			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			if(do_after(user,50))
				if (src.broken)
					return

				src.broken++
				spark_system.set_up(5,0,src)
				src.spark_system.start()
				playsound(src.loc, "sound/items/Deconstruct.ogg", 100, 1)

				boutput(user, "<span class='combat'>The RCD shorts out!</span>")

				logTheThing("combat", user, null, "manages to vaporize \[[showCoords(A.x, A.y, A.z)]] with a halloween RCD.")

				new /obj/effects/void_break(A)
				if (user)
					user.gib()

/turf/unsimulated/floor/void/crunch
	RL_Ignore = 0

/turf/unsimulated/wall/void/crunch
	RL_Ignore = 0

/obj/effects/void_break
	invisibility = 101
	anchored = 1
	var/lifespan = 4
	var/rangeout = 0

	New()
		..()
		lifespan = rand(2,4)
		rangeout = lifespan
		spawn(5)
			void_shatter()
			void_loop()

	proc/void_shatter()
		playsound(src.loc, "sound/misc/meteorimpact.ogg", 80, 1)
		for (var/atom/A in range(lifespan, src))
			if (istype(A, /turf/simulated))
				A.pixel_x = rand(-4,4)
				A.pixel_y = rand(-4,4)
			else if (istype(A, /mob/living))
				shake_camera(A, 8, 3)
				A.ex_act( get_dist(src, A) > 1 ? 3 : 1 )

			else if (istype(A, /obj) && (A != src))

				if ((get_dist(src, A) <= 2) || prob(10))
					A.ex_act(1)
				else if (prob(5))
					A.ex_act(3)

				continue

		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(3, 1, src)
		s.start()

	proc/void_loop()
		if (lifespan-- < 0)
			qdel(src)
			return

		for (var/turf/simulated/T in range(src, (rangeout-lifespan)))
			if (prob(5 + lifespan) && limiter.canISpawn(/obj/effects/sparks))
				var/obj/sparks = unpool(/obj/effects/sparks)
				sparks.set_loc(T)
				spawn(20) if (sparks) pool(sparks)

			T.ex_act((rangeout-lifespan) < 2 ? 1 : 2)

		spawn(15)
			void_loop()
		return

/////////////////////////////////////////////////////////////////

//It pressurizes areas.
/obj/effects/pressurizer
	invisibility = 100

	New()
		..()
		spawn(1)
			src.do_pressurize()
			sleep(10)
			qdel(src)

	proc/do_pressurize()
		var/turf/simulated/T = src.loc
		if (!istype(T))
			return

		var/datum/gas_mixture/GM = T.return_air()
		if (!istype(GM))
			return

		GM.oxygen *= 1000
		GM.nitrogen *= 1000
		T.process_cell()

var/list/timewarp_interior_sounds = list('sound/ambience/timeship_fx1.ogg','sound/ambience/timeship_fx2.ogg','sound/ambience/timeship_fx3.ogg','sound/ambience/timeship_fx4.ogg','sound/ambience/timeship_fx5.ogg')

/area/timewarp
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0
	name = "Strange Place"
	icon_state = "shuttle2"
	var/sound/ambientSound = 'sound/ambience/timeship_amb1.ogg'
	var/list/fxlist = null
	var/list/soundSubscribers = null

	New()
		..()
		//fxlist =
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

/area/timewarp/ship
	name = "Strange Craft"
	icon_state = "shuttle"
	RL_Lighting = 1
	ambientSound = 'sound/ambience/timeship_amb2.ogg'

	New()
		..()
		fxlist = timewarp_interior_sounds

/turf/unsimulated/floor/void/timewarp
	name = "time-space breach"
	desc = "Uhh.  UHHHH.  uh."
	RL_Ignore = 0
	icon = 'icons/misc/worlds.dmi'
	icon_state = "timehole"

/obj/decal/timeplug
	name = "time-space breach"
	desc = "Uhh.  UHHH.  uh!!"
	icon = 'icons/misc/worlds.dmi'
	icon_state = "timehole_edge"
	anchored = 1

/obj/machinery/bot/guardbot/future
	name = "Wally-392"
	desc = "A PR-7 Robuddy!  Whoa, these don't even exist yet!  Why does this one look so old then?"
	icon = 'icons/misc/newbots.dmi'
	health = 50
	setup_unique_name = 1
	hat_x_offset = -6
	setup_no_costumes = 1
	no_camera = 1
	flashlight_red = 0.1
	flashlight_green = 0.1
	flashlight_blue = 0.4

	setup_charge_maximum = 800
	setup_default_startup_task = /datum/computer/file/guardbot_task/future
	setup_default_tool_path = /obj/item/device/guardbot_tool/taser

	New()
		..()

	turn_on()
		if(!src.cell || src.cell.charge <= 0)
			return
		src.on = 1
		src.idle = 0
		src.moving = 0
		src.task = null
		src.wakeup_timer = 0
		src.last_dock_id = null
		icon_needs_update = 1
		if(!warm_boot)
			src.scratchpad.len = 0
			src.speak("Guardbuddy V2.9 Online.")
			if (src.health < initial(src.health))
				src.speak("Self-check indicates [src.health < (initial(src.health) / 2) ? "severe" : "moderate"] structural damage!")

			if(!src.tasks.len && (src.model_task || src.setup_default_startup_task))
				if(!src.model_task)
					src.model_task = new src.setup_default_startup_task

				src.tasks.Add(src.model_task.copy_file())
			src.warm_boot = 1

		src.wakeup()

	wakeup()
		if (src.on)
			playsound(src.loc, 'sound/machines/futurebuddy_beep.ogg', 50, 1)
			return ..()

	interact(mob/user as mob)
		var/dat = "<tt><B>PR-7 Robuddy v2.9</B></tt><br><br>"

		var/power_readout = null
		var/readout_color = "#000000"
		if(!src.cell)
			power_readout = "NO CELL"
		else
			var/charge_percentage = round((cell.charge/cell.maxcharge)*100)
			power_readout = "[charge_percentage]%"
			switch(charge_percentage)
				if(0 to 10)
					readout_color = "#F80000"
				if(11 to 25)
					readout_color = "#FFCC00"
				if(26 to 50)
					readout_color = "#CCFF00"
				if(51 to 75)
					readout_color = "#33CC00"
				if(76 to 100)
					readout_color = "#33FF00"


		dat += {"Power: <table border='1' style='background-color:[readout_color]'>
				<tr><td><font color=white>[power_readout]</font></td></tr></table><br>"}

		dat += "Current Tool: [src.tool ? src.tool.tool_id : "NONE"]<br>"

		if(src.locked)

			dat += "Status: [src.on ? "On" : "Off"]<br>"

		else

			dat += "Status: <a href='?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</a><br>"

		dat += "<br>Network ID: <b>\[[uppertext(src.net_id)]]</b><br>"

		user << browse("<head><title>Robuddy v2.9 controls</title></head>[dat]", "window=guardbot")
		onclose(user, "guardbot")
		return

	explode()
		if(src.exploding) return
		src.exploding = 1
		var/death_message = pick("It is now safe to shut off your buddy.","I regret nothing, but I am sorry I am about to leave my friends.","Malfunction!","I had a good run.","Es lebe die Freiheit!","Life was worth living.","It's time to split!")
		speak(death_message)
		src.visible_message("<span class='combat'><b>[src] blows apart!</b></span>")
		var/turf/T = get_turf(src)
		if(src.mover)
			src.mover.master = null
			qdel(src.mover)

		src.invisibility = 100
		var/obj/overlay/Ov = new/obj/overlay(T)
		Ov.anchored = 1
		Ov.name = "Explosion"
		Ov.layer = NOLIGHT_EFFECTS_LAYER_BASE
		Ov.pixel_x = -17
		Ov.icon = 'icons/effects/hugeexplosion.dmi'
		Ov.icon_state = "explosion"

		src.tool.set_loc(get_turf(src))
/*
		var/obj/item/guardbot_core/old/core = new /obj/item/guardbot_core/old(T)
		core.created_name = src.name
		core.created_default_task = src.setup_default_startup_task
		core.created_model_task = src.model_task
*/
		var/list/throwparts = list()
		throwparts += new /obj/item/parts/robot_parts/arm/left(T)
		throwparts += new /obj/item/device/flash(T)
		//throwparts += core
		throwparts += src.tool
		if(src.hat)
			throwparts += src.hat
			src.hat.set_loc(T)
		//throwparts += new /obj/item/guardbot_frame/old(T)
		for(var/obj/O in throwparts) //This is why it is called "throwparts"
			var/edge = get_edge_target_turf(src, pick(alldirs))
			O.throw_at(edge, 100, 4)

		spawn(0) //Delete the overlay when finished with it.
			src.on = 0
			sleep(15)
			qdel(Ov)
			qdel(src)

		T.hotspot_expose(800,125)
		explosion(src, T, -1, -1, 2, 3)

		return

//Wally dialog flags
#define WD_HELLO 1
#define WD_SLEEPER_WARNING 2
#define WD_SLEEPER_SCREAM 4
#define WD_SOLARIUM 8

/datum/computer/file/guardbot_task/future
	name = "wally"
	task_id = "1STMATE"

	var/dialogChecklist = 0

	var/static/list/greet_strings = list("Oh, hello!  You really need to leave, it's not safe here!  Something awful has happened!",
		"Oh, you're new! Hi! You, um, should probably get as far away from here as possible. It's sorta dangerous.",
		"Hello, UNKNOWN INDIVIDUAL!  You picked a bad time to show up, there is a bit of a time crisis going on right now.")

	var/static/list/idle_dialog_strings = list("So... seen any good films lately?  I have, but I guess anything I say would be a spoiler, huh?",
		"Nanotrasen, huh?  That's...interesting.",
		"What's the past like?  Do you really ride dinosaurs?",
		"Hey, um, I don't want to accidentally commit a time crime or make a paradox or something, but you probably should stay away from Discount Dan soups produced between November seventh, 2054 and February first, 2055.")

	task_act()
		if (..())
			return

		var/mob/living/somebody_to_talk_to = null
		for (var/mob/living/maybe_that_somebody in view(7, master)) //We don't want to talk to the dead.
			if (istype(maybe_that_somebody, /mob/living/carbon/human/future))
				if (!(dialogChecklist & WD_SLEEPER_SCREAM))
					dialogChecklist |= WD_SLEEPER_SCREAM

					src.master.speak("Oh no oh no oh no no no no")
					src.master.visible_message( "<span style=\"color:red\">[src.master] points repeatedly at [maybe_that_somebody]![prob(50) ? "  With both arms, no less!" : null]</span>")
					src.master.set_emotion("screaming")
					spawn (40)
						if (src.master)
							src.master.set_emotion("sad")
					return

			if (!maybe_that_somebody.stat && !somebody_to_talk_to)	//Not even the PR-7 has a seance mode, ok?
				somebody_to_talk_to = maybe_that_somebody

		if (somebody_to_talk_to)
			if(!(dialogChecklist & WD_HELLO))
				dialogChecklist |= WD_HELLO

				src.master.speak( pick(greet_strings) )
				return

			else if (!(dialogChecklist & WD_SLEEPER_WARNING) && (locate(/obj/machinery/sleeper/future) in range(somebody_to_talk_to, 1)))
				dialogChecklist |= WD_SLEEPER_WARNING

				src.master.speak("Aaa! Please stay away from there! You can't wake him up, okay? It's not safe!")
				spawn(15)
					src.master.speak("I mean, for him.  Sleepers slow down aging, but it turns out that DNA or whatever still ages really, really slowly.")
					sleep(10)
					src.master.speak("And um, it's been so long that when the cell tries to divide it...doesn't work.")

				return

			else if (prob(2))
				src.master.speak( pick(idle_dialog_strings) )

		if (istype(get_area(src.master), /area/solarium) && !(dialogChecklist & WD_SOLARIUM))
			dialogChecklist |= WD_SOLARIUM

			src.master.speak( "Oh, this place is familiar!  It looks like a ship, a model...um...")
			spawn(10)
				src.master.speak("I'm sorry, I don't recognize this ship!  Maybe I can interface with its onboard computer though?")
				sleep(20)
				src.master.speak("Okay, it's yelling at me in a language I do not understand!  Weird!")
				sleep(20)
				src.master.speak("...and now it's not responding. So much for that!")

			return

		return

#undef WD_HELLO
#undef WD_SLEEPER_WARNING
#undef WD_SLEEPER_SCREAM
#undef WD_SOLARIUM

/obj/machinery/sleeper/future
	desc = "This sleeper pod looks futuristic, but also really old.  Kinda like, um, a scifi novel from the 1890s suggesting we'd all be riding time blimps by now."


	dead_man_sleeping
		New()
			..()
			spawn (10)
				src.occupant = new /mob/living/carbon/human/future (src)
				src.icon_state = "sleeper_1"

//todo: poor future-past man stumbles out of sleeper and promptly falls apart.
//like, literally, not emotionally.
/mob/living/carbon/human/future
	real_name = "ill-looking fellow"
	gender = MALE
	var/death_countdown = 5
	var/had_thought = 0

	New()
		..()

		spawn(0)
			bioHolder.mobAppearance.customization_second = "Tramp"
			bioHolder.mobAppearance.underwear = "briefs"
			bioHolder.age = 3500
			gender = "male"
			sleep(5)
			bioHolder.mobAppearance.UpdateMob()
			bioHolder.AddEffect("psy_resist") // Heh
			src.equip_if_possible(new /obj/item/clothing/shoes/red(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/color/white(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/key {name = "futuristic key"; desc = "It appears to be made of some kind of space-age material.  Like really fancy aluminium or something.";} (src), slot_l_store)

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1
		if(!src.stat && !istype(src.loc, /obj/machinery/sleeper))
			if (prob(40) || !death_countdown)
				say( pick("Buhh...", "I'm...awake? No...", "I can't be awake...", "Who are you?  Where am I?", "Who--nghh. It...hurts..") )

			if(src.ckey && !had_thought && !death_countdown)
				//7848(2)9(1) = 7848b9a = hex for 126127002 = 126 127 002 = coordinates to cheget key
				//A fucker is me
				src.show_text("<B><I>A foreign thought flashes into your mind... <font color=red>Rem..e...mbe...r 78... 4... 8(2)... 9... (1) alw..a...ys...</font></I></B>")
				had_thought = 1

			if (death_countdown-- < 0)
				src.emote("scream")
				src.gib()


	death(var/gibbed)
		if(!gibbed)
			src.gib()
		else
			..()


var/helldrone_awake = 0
var/sound/helldrone_awake_sound = null
var/sound/helldrone_wakeup_sound = null

/proc/helldrone_wakeup()
	if (helldrone_awake == 2)
		return

	for (var/area/helldrone/drone_zone in world)
		helldrone_awake = 2
		for (var/mob/M in drone_zone)
			M << helldrone_wakeup_sound

		for (var/obj/decal/fakeobjects/drone_eye in drone_zone)
			if (drone_eye.icon_state == "eye_array")
				drone_eye.icon_state = "eye_array_on"

			else if (drone_eye.icon_state == "server0")
				drone_eye.desc = "A large rack of server modules."
				drone_eye.icon_state = "server"

		for (var/obj/critter/ancient_repairbot/helldrone_guard/grump_guard in drone_zone)
			grump_guard.wakeup()

	if (helldrone_awake != 2)
		logTheThing("debug", null, null, "<b>Halloween Event Error</b>: Unable to locate helldrone areas.")
		return

	return


/obj/critter/ancient_repairbot/helldrone_guard
	name = "weird machine"
	desc = "A machine, of some sort.  It's probably off."
	icon = 'icons/misc/worlds.dmi'
	icon_state = "drone_service_bot"
	density = 1
	health = 35
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	atcritter = 0
	firevuln = 0.5
	brutevuln = 0.5
	sleeping_icon_state = "drone_service_bot_off"
	flying = 0
	generic = 0

	var/activated = 0

	New()
		..()
		spawn(20)
			if (!activated)
				src.icon_state = sleeping_icon_state

				src.name = initial(src.name)


	process()
		if (!activated)
			sleeping = 10
			on_sleep()
			if (sleeping_icon_state)
				src.icon_state = sleeping_icon_state
			task = "sleeping"
			return

		else
			return ..()

	attackby(obj/item/W as obj, mob/user as mob)
		if (!activated)
			return

		return ..()

	proc/wakeup()
		if (src.activated)
			return

		src.activated = 1
		src.icon_state = initial(src.icon_state)
		src.sleeping = 0
		src.task = "thinking"
		src.desc = "A machine.  Of some sort.  It looks mad"

		src.visible_message("<span class='combat'>[src] seems to power up!</span>")


/area/helldrone
	var/list/soundSubscribers = list()

	New()
		..()

		spawn (60)
			if (!helldrone_awake_sound)
				helldrone_awake_sound = new/sound()
				helldrone_awake_sound.file = 'sound/machines/giantdrone_loop.ogg'
				helldrone_awake_sound.repeat = 0
				helldrone_awake_sound.wait = 0
				helldrone_awake_sound.channel = 122
				helldrone_awake_sound.volume = 60
				helldrone_awake_sound.priority = 255
				helldrone_awake_sound.status = SOUND_UPDATE

			if (!helldrone_wakeup_sound)
				helldrone_wakeup_sound = new/sound()
				helldrone_wakeup_sound.file = 'sound/machines/giantdrone_startup.ogg'
				helldrone_wakeup_sound.repeat = 0
				helldrone_wakeup_sound.wait = 0
				helldrone_wakeup_sound.channel = 122
				helldrone_wakeup_sound.volume = 60
				helldrone_wakeup_sound.priority = 255
				helldrone_wakeup_sound.status = SOUND_UPDATE

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if (!soundSubscribers:Find(Obj))
				soundSubscribers += Obj

		return

	core
		Entered(atom/movable/O)
			..()
			if (istype(O, /mob/living) && !helldrone_awake)
				helldrone_awake = 1
				spawn (20)
					helldrone_wakeup()
					src.process()

	proc/process()
		if (!soundSubscribers || !helldrone_awake)
			return

		var/sound/S = null
		var/sound_delay = 0


		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)
/*
			if(prob(10) && fxlist)
				S = sound(file=pick(fxlist), volume=50)
				sound_delay = rand(0, 50)
			else
				S = null
				continue
*/
			for(var/mob/living/H in soundSubscribers)
				var/area/mobArea = get_area(H)
				if (!istype(mobArea) || mobArea.type != src.type)
					soundSubscribers -= H
					if (H.client)
						helldrone_awake_sound.status = SOUND_PAUSED | SOUND_UPDATE
						helldrone_awake_sound.volume = 0
						H << helldrone_awake_sound
					continue

				if(H.client)
					helldrone_awake_sound.status = SOUND_UPDATE
					helldrone_awake_sound.volume = 60
					H << helldrone_awake_sound
					if(S)
						spawn(sound_delay)
							H << S

/obj/item/audio_tape/timewarp_00
	New()
		..()
		messages = list("been so long, I think the recorder is overwriting itself at this point.",
	"God, like it even matters.  Like any of this even matters.",
	"*static*",
	"This is Darrell Warsaw, checking in again.  Expedition log, uhh, 173.  Effective Earth Date is April 3, 2065.",
	"The discharges outside have been growing more severe.  Nothing has directly affected the ship, but we're all on edge.",
	"I know I said it was beautiful last time, but that was before it followed us for five days.",
	"None of the sensors have shed any light on it.  It's blue, it looks like arcs, and God knows if it has any recognizable spectra.",
	"Kowalski and Nie are still in suspension.  If this lasts any longer, I'll have Wally wake them and we'll see if we can figure something out.")
		speakers = list("Male voice", "Male voice", "???", "Male voice", "Darrell Warsaw", "Darrell Warsaw", "Darrell Warsaw", "Darrell Warsaw")

/obj/item/device/audio_log/timewarp_00

	New()
		..()
		src.tape = new /obj/item/audio_tape/timewarp_00(src)

/obj/item/audio_tape/timewarp_01
	New()
		..()
		messages = list("we can conclude that the shift in observed space cannot be explained through normal travel.",
						"Teleportation?  God, I hope not.  I think we'd all be dead already if that was the case.",
						"It might be some new form? Uhh",
						"*low static*",
						"...",
						"...",
						"hurts ...")
		speakers = list("Male voice", "Male voice", "Male voice", "???","???","???","Faint voice")

/obj/item/device/audio_log/timewarp_01

	New()
		..()
		src.tape = new /obj/item/audio_tape/timewarp_01(src)

/obj/item/audio_tape/timewarp_02
	New()
		..()

		messages = list("I've already tried that.  I don't think we can just fly out of this field. Not without burning most of our fuel.",
	"What about the probes?",
	"They all stopped responding a few meters out.",
	"And they exploded!",
	"Yes...",
	"Darrell, I'm not seeing a way out of this.",
	"*static*",
	"*static*",
	"a great ring of a million linked arms, carrying swords forged not of steel but of lightning and fire",
	"it called out in a voice of multitudes, speaking of vengence and justice and war and the voice of the sun",
	"*static*")

		speakers = list("Female voice", "Male voice", "Female voice","Synthesized voice","Female voice","Female voice (distorted)","???","???","???","???","???")

/obj/item/toy/halloween2014spellbook
	name = "Book of Spells"
	desc = "An old spooky tome full of horrific eldritch magic. What insane mortal dares open it? Is it me?? Is it him??? Is it... yoooooooouuuuuu??????"
	icon = 'icons/obj/items.dmi'
	icon_state = "sbook"
	var/uses = 1

	attack_self(var/mob/user as mob)
		var/list/choices = list("Y OWL GO SIP KEGS","FERAL TOFU GAPS","NULL MOSS NOOK","ONION SLUG CANDY","HOT SIGMA")
		var/pick = input("This old book looks like it could crumble away at any moment... which spell will you read?","Book of Spells") as null|anything in choices
		var/used = 1

		if (!src)
			return

		switch(pick)
			if("Y OWL GO SIP KEGS")
				for (var/atom/A in range(4,user))
					if (isarea(A))
						continue
					if (ismob(A))
						var/mob/M = A
						M.show_text("Uh oh! Everything's going all wiggly! NOW YOU KNOW TRUE HOOOORROOOOR!!!!!","#8218A8")
					animate_wiggle_then_reset(A,5,50)
			if("FERAL TOFU GAPS")
				for (var/mob/living/carbon/C in range(4,user))
					if (C.reagents)
						C.reagents.add_reagent("egg",25)
						C.reagents.add_reagent("fartonium",25)
						user.show_text("You feel a spooky rumbling in your guts! Maybe you ate a ghoooooost?!","#8218A8")
					if (C.bioHolder)
						C.bioHolder.age += 125
						spawn(600)
							C.bioHolder.age -= 125
			if("NULL MOSS NOOK")
				particleMaster.SpawnSystem(new /datum/particleSystem/skull_rain(get_turf(user)))
				user.show_text("You hear something rattling above you!","#8218A8")
			if("ONION SLUG CANDY")
				particleMaster.SpawnSystem(new /datum/particleSystem/spooky_mist(get_turf(user)))
				user.show_text("A cold and spooky wind begins to blow!","#8218A8")
				playsound(get_turf(user), 'sound/ambience/coldwind2.ogg', 50, 1, 5)
			if("HOT SIGMA")
				user.blend_mode = 2
				user.alpha = 150
				user.show_text("You feel extra spooky!","#8218A8")
				spawn(1200)
					user.blend_mode = 0
					user.alpha = 255
			else
				boutput(user, "You decide to leave the book alone for now.")
				used = 0

		if (used)
			user.visible_message("<span class='combat'><b>[user.name]</b> reads a spell from the book!</span>")
			src.uses--
			if (uses == 0)
				boutput(user, "<span class='combat'>The book crumbles away into dust! How spooooooky!</span>")
				src.dropped()
				qdel(src)

		return

/datum/particleSystem/skull_rain
	New(var/atom/location = null)
		..(location, "skull_rain", 100)

	Run()
		if (state != 2 && ..())
			for(var/i, i < 50, i++)
				SpawnParticle()
				sleep(0.5)
			Die()

/datum/particleType/skull_rain
	name = "skull_rain"
	icon = 'icons/effects/particles.dmi'
	icon_state = "skull3"

	MatrixInit()
		first = matrix(rand(-60,60), MATRIX_ROTATE)
		second = matrix()

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 1
			par.color = "#FFFFFF"
			par.pixel_x = rand(-128,128)
			par.pixel_y = 320

			second.Turn(rand(-60,60))

			animate(par, transform = second, time = 20, pixel_y = rand(-128,128), alpha = 255, easing = BOUNCE_EASING)
			animate(time = 60, alpha = 1, easing = LINEAR_EASING)

/datum/particleSystem/spooky_mist
	New(var/atom/location = null)
		..(location, "spooky_mist", 300)

	Run()
		if (state != 2 && ..())
			for(var/i, i < 125, i++)
				SpawnParticle()
				sleep(3)
			Die()

/datum/particleType/spooky_mist
	name = "spooky_mist"
	icon = 'icons/effects/particles.dmi'
	icon_state = "mistcloud1"

	MatrixInit()
		first = matrix(15, MATRIX_SCALE)

	Apply(var/obj/particle/par)
		if(..())
			par.alpha = 60
			par.color = "#FFFFFF"
			par.pixel_x = 480
			par.pixel_y = rand(-240,240)
			par.transform = first

			//animate(par, time = 10, alpha = 60, easing = LINEAR_EASING)
			animate(par, time = 280, pixel_x = par.pixel_x * -1, easing = SINE_EASING)
			//animate(time = 10, alpha = 1, easing = LINEAR_EASING)