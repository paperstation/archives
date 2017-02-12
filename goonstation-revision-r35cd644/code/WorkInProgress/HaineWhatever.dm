// hey look at me I'm changing a file

/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-ADMIN-STUFF-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/atom/proc/add_star_effect(var/remove = 0)
	if (remove)
		if (particleMaster.CheckSystemExists(/datum/particleSystem/warp_star, src))
			particleMaster.RemoveSystem(/datum/particleSystem/warp_star, src)
	else if (!particleMaster.CheckSystemExists(/datum/particleSystem/warp_star, src))
		particleMaster.SpawnSystem(new /datum/particleSystem/warp_star(src))

/proc/toggle_clones_for_cash()
	if (!wagesystem)
		return
	wagesystem.clones_for_cash = !(wagesystem.clones_for_cash)
	logTheThing("admin", usr, null, "toggled monetized cloning [wagesystem.clones_for_cash ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled monetized cloning [wagesystem.clones_for_cash ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled monetized cloning [wagesystem.clones_for_cash ? "on" : "off"]")
	boutput(world, "<b>Cloning now [wagesystem.clones_for_cash ? "requires" : "does not require"] money.</b>")

/area/haine_party_palace
	name = "haine's rad hangout place"
	icon_state = "purple"
	requires_power = 0
	sound_environment = 4

var/global/debug_messages = 0
var/global/narrator_mode = 0
var/global/disable_next_click = 0

/client/proc/toggle_next_click()
	set name = "Toggle next_click"
	set desc = "Removes most click delay. Don't know what this is? Probably shouldn't touch it."
	set category = "Toggles (Server)"
	admin_only

	disable_next_click = !(disable_next_click)
	logTheThing("admin", usr, null, "toggled next_click [disable_next_click ? "off" : "on"].")
	logTheThing("diary", usr, null, "toggled next_click [disable_next_click ? "off" : "on"].", "admin")
	message_admins("[key_name(usr)] toggled next_click [disable_next_click ? "off" : "on"]")

/client/proc/debug_messages()
	set desc = "Toggle debug messages."
	set name = "HDM" // debug ur haines
	set hidden = 1
	admin_only

	debug_messages = !(debug_messages)
	logTheThing("admin", usr, null, "toggled debug messages [debug_messages ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled debug messages [debug_messages ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled debug messages [debug_messages ? "on" : "off"]")

/client/proc/narrator_mode()
	set name = "Narrator Mode"
	set desc = "Toggle narrator mode on or off."
	admin_only

	narrator_mode = !(narrator_mode)

	logTheThing("admin", usr, null, "toggled narrator mode [narrator_mode ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled narrator mode [narrator_mode ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled narrator mode [narrator_mode ? "on" : "off"]")

/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-GHOST-DRONE-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/obj/machinery/ghost_catcher
	name = "ghost catcher"
	desc = "it catches ghosts!! read the name gosh I shouldn't have to explain everything to you"
	anchored = 1
	density = 1
	icon = 'icons/mob/ghost_drone.dmi'
	icon_state = "ghostcatcher0"
	mats = 0
	var/id = "ghostdrone"

	Crossed(atom/movable/O)
		if (!istype(O, /mob/dead/observer))
			return ..()
		var/mob/dead/observer/G = O
		if (available_ghostdrones.len)
			G.visible_message("[src] scoops up [G]!",\
			"You feel yourself being torn away from the afterlife and into [src]!")
			droneize(G, 1)
		else
			G.show_text("There are currently no empty drones available for use, please wait for another to be built.", "red")
			return ..()

	process()
		..()
		if (available_ghostdrones.len)
			src.icon_state = "ghostcatcher1"
			var/list/ghost_candidates = list()
			for (var/mob/dead/observer/O in get_turf(src))
				if (assess_ghostdrone_eligibility(O))
					ghost_candidates += O
			if (ghost_candidates.len)
				var/mob/dead/observer/O = pick(ghost_candidates)
				if (O)
					O.visible_message("[src] scoops up [O]!",\
					"You feel yourself being torn away from the afterlife and into [src]!")
					droneize(O, 1)
		else
			src.icon_state = "ghostcatcher0"

/proc/assess_ghostdrone_eligibility(var/mob/dead/observer/G)
	if (!istype(G))
		return 0
	if (!G.client)
		return 0
	if (G.mind && G.mind.dnr)
		return 0
	return 1

#define GHOSTDRONE_BUILD_INTERVAL 3000
var/global/ghostdrone_factory_working = 0
var/global/last_ghostdrone_build_time = 0
var/global/list/available_ghostdrones = list()

/obj/machinery/ghostdrone_factory
	name = "drone factory"
	desc = "A slightly mysterious looking factory that spits out weird looking drones every so often. Why not."
	anchored = 1
	density = 0
	icon = 'icons/mob/ghost_drone.dmi'
	icon_state = "factory10"
	layer = 5 // above mobs hopefully
	mats = 0
	var/factory_section = 1 // can be 1 to 3
	var/id = "ghostdrone" // the belts through the factory should be set to the same as the factory pieces so they can control them
	var/obj/item/ghostdrone_assembly/current_assembly = null
	var/list/conveyors = list()
	var/working = 0 // are we currently doing something to a drone piece?
	var/work_time = 50 // how long do_work()'s animation and sound effect loop runs
	var/worked_time = 0 // how long the current work cycle has run

	New()
		..()
		src.icon_state = "factory[src.factory_section][src.working]"
		spawn(10)
			src.update_conveyors()

	proc/update_conveyors()
		if (src.conveyors.len)
			for (var/obj/machinery/conveyor/C in src.conveyors)
				if (C.id != src.id)
					src.conveyors -= C
		for (var/obj/machinery/conveyor/C in machines)
			if (C.id == src.id)
				if (C in src.conveyors)
					continue
				src.conveyors += C

	disposing()
		..()
		if (src.current_assembly)
			pool(src.current_assembly)
		if (src.conveyors.len)
			src.conveyors.len = 0

	Cross(atom/movable/O)
		if (!istype(O, /obj/item/ghostdrone_assembly))
			return ..()
		if (src.current_assembly) // we're full
			return 0 // thou shall not pass
		else // we're not full
			return 1 // thou shall pass

	Crossed(atom/movable/O)
		if (src.factory_section == 1 || !istype(O, /obj/item/ghostdrone_assembly))
			return ..()
		var/obj/item/ghostdrone_assembly/G = O
		if (G.stage != (src.factory_section - 1) || src.current_assembly)
			return ..()
		src.start_work(G)

	process()
		..()
		if (working && src.current_assembly)
			worked_time ++
			if (work_time - worked_time <= 0)
				src.stop_work()
				return

			if (prob(40))
				src.shake(rand(4,6))
				playsound(get_turf(src), pick("sound/effects/zhit.ogg", "sound/effects/bang.ogg"), 30, 1, -3)
			if (prob(40))
				var/list/sound_list = pick(ghostly_sounds, sounds_engine, sounds_enginegrump, sounds_sparks)
				if (!sound_list.len)
					return
				var/chosen_sound = pick(sound_list)
				if (!chosen_sound)
					return
				playsound(get_turf(src), chosen_sound, rand(20,40), 1)

		else if (!ghostdrone_factory_working)
			if (src.factory_section == 1)
				if (!ticker) // game ain't started
					return
				if (world.timeofday >= (last_ghostdrone_build_time + GHOSTDRONE_BUILD_INTERVAL))
					src.start_work()
			else
				var/obj/item/ghostdrone_assembly/G = locate() in get_turf(src)
				if (G && G.stage == (src.factory_section - 1))
					src.start_work(G)

	proc/start_work(var/obj/item/ghostdrone_assembly/G)
		var/emptySpot = 0
		for (var/obj/machinery/drone_recharger/factory/C in machines)
			if (!C.occupant)
				emptySpot = 1
				break
		if (!emptySpot)
			return

		if (G && !src.current_assembly && G.stage == (src.factory_section - 1))
			src.visible_message("[src] scoops up [G]!")
			G.set_loc(src)
			src.current_assembly = G
			src.working = 1
			src.icon_state = "factory[src.factory_section]1"

		else if (src.factory_section == 1 && !ghostdrone_factory_working && !src.current_assembly)
			src.current_assembly = unpool(/obj/item/ghostdrone_assembly)
			if (!src.current_assembly)
				src.current_assembly = new(src)
			src.current_assembly.set_loc(src)
			ghostdrone_factory_working = src.current_assembly // if something happens to the assembly, for whatever, reason this should become null, I guess?
			src.working = 1
			src.icon_state = "factory[src.factory_section]1"
			last_ghostdrone_build_time = world.timeofday

		if (!src.current_assembly)
			src.working = 0
			src.icon_state = "factory[src.factory_section]0"
			return

		for (var/obj/machinery/conveyor/C in src.conveyors)
			C.operating = 0
			C.setdir()

	proc/stop_work()
		src.worked_time = 0
		src.working = 0
		src.icon_state = "factory[src.factory_section]0"

		if (src.current_assembly)
			src.current_assembly.stage = src.factory_section
			src.current_assembly.icon_state = "drone-stage[src.factory_section]"
			src.current_assembly.set_loc(get_turf(src))
			playsound(get_turf(src), "sound/machines/warning-buzzer.ogg", 50, 1)
			src.visible_message("[src] ejects [src.current_assembly]!")
			src.current_assembly = null

		for (var/obj/machinery/conveyor/C in src.conveyors)
			C.operating = 1
			C.setdir()

	proc/shake(var/amt = 5)
		var/orig_x = src.pixel_x
		var/orig_y = src.pixel_y
		for (amt, amt>0, amt--)
			src.pixel_x = rand(-2,2)
			src.pixel_y = rand(-2,2)
			sleep(1)
		src.pixel_x = orig_x
		src.pixel_y = orig_y
		return 1

/obj/machinery/ghostdrone_factory/part2
	icon_state = "factory20"
	factory_section = 2

/obj/machinery/ghostdrone_factory/part3
	icon_state = "factory30"
	factory_section = 3

/obj/item/ghostdrone_assembly
	name = "drone assembly"
	desc = "an incomplete floaty robot"
	icon = 'icons/mob/ghost_drone.dmi'
	icon_state = "drone-stage1"
	mats = 0
	var/stage = 1

	pooled()
		..()
		if (ghostdrone_factory_working == src)
			ghostdrone_factory_working = 0
		stage = 1

	unpooled()
		..()
		src.icon_state = "drone-stage[src.stage]"

/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=-DESTINY-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

var/global/list/valid_target_arrival_pads = list()

/proc/get_random_station_turf()
	var/list/areas = get_areas(/area/station)
	if (!areas.len)
		return
	var/area/A = pick(areas)
	if (!A)
		return
	var/list/turfs = get_area_turfs(A, 1)
	if (!turfs.len)
		return
	var/turf/T = pick(turfs)
	if (!T)
		return
	return T

/obj/dummy_pad
	name = "teleport pad"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pad0"
	anchored = 1
	density = 0

	New()
		..()
		valid_target_arrival_pads += src

/obj/arrivals_pad
	name = "teleport pad"
	desc = "Click me to teleport to the station!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pad0"
	anchored = 1
	density = 0
	var/HTML = null
	var/obj/dummy_pad/target_pad = null
	var/emergency = 0 // turned on if there's nothing in valid_target_arrival_pads or it isn't a list

	Topic(href, href_list[])
		if (..() || !usr)
			return

		if (href_list["set_target"])
			var/obj/dummy_pad/D = locate(href_list["set_target"])
			if (!istype(D))
				return
			src.target_pad = D
			src.display_window(usr)
			return

		else if (href_list["teleport"])
			if (usr.loc != get_turf(src))
				boutput(usr, "<span style='color:red'>You have to be standing on [src] to teleport!</span>")
				return
			if (!src.target_pad && !src.emergency)
				boutput(usr, "<span style='color:red'>No target specified to teleport to!</span>")
				return
			else if (src.emergency)
				//teleport to somewhere (hopefully with air?)
				var/turf/T = get_random_station_turf()
				if (!istype(T) || T.z != 1)
					for (var/i=3, i>0, i--)
						T = get_random_station_turf()
						if (istype(T) && T.z == 1)
							break
				if (T)
					if (get_turf(usr) != get_turf(src))
						boutput(usr, "<span style='color:red'>You have to be standing on [src] to teleport!</span>")
						return
					src.teleport_user(usr, T)
				return
			else if (src.target_pad && alert(usr, "Teleport to [target_pad.x],[target_pad.y],[target_pad.x] in [get_area(target_pad)]?", "Confirmation", "Yes", "No") == "Yes")
				if (get_turf(usr) != get_turf(src))
					boutput(usr, "<span style='color:red'>You have to be standing on [src] to teleport!</span>")
					return
				src.teleport_user(usr, get_turf(target_pad))
				return

	proc/teleport_user(var/mob/user, var/turf/target)
		if (!user || !target)
			return
		if (!isturf(target))
			target = get_turf(target)
		showswirl(target)
		leaveresidual(target)
		showswirl(get_turf(src))
		leaveresidual(get_turf(src))
		boutput(usr, "<span style='color:green'>Now teleporting to [target.x],[target.y],[target.x] in [get_area(target)].</span>")
		user.set_loc(target)
		user << browse(null, "window=[src]")
		if (map_setting == "DESTINY")
			if (user.mind && user.mind.assigned_role)
				for (var/obj/machinery/computer/announcement/A in machines)
					if (!A.stat && A.announces_arrivals)
						A.announce_arrival(user.real_name, user.mind.assigned_role)

	proc/generate_html()
		HTML = ""
		if (!islist(valid_target_arrival_pads) || !valid_target_arrival_pads.len)
			src.emergency = 1
			HTML += "<center><span style='color:red;font-weight:bold'>ERROR: EMERGENCY MODE (No valid targets available)</span></center>"
			HTML += "<center><a href='?src=\ref[src];teleport=1'>\[Emergency Teleport\]</a></center>"
		else
			src.emergency = 0
			HTML += "<b>TARGET</b>:<br>"
			if (target_pad)
				HTML += "[target_pad.x],[target_pad.y],[target_pad.x] in [get_area(target_pad)]<br>"
				HTML += "<b>Scan Results</b>:<br>[scan_atmospheric(get_turf(target_pad), 0, 1)]<br>"
				HTML += "<a href='?src=\ref[src];teleport=1'>\[Teleport\]</a><hr>"
			else
				HTML += "<span style='color:red'>No Target Specified</span><hr>"
			HTML += "<b>Available Targets</b>:<br>"
			for (var/obj/dummy_pad/D in valid_target_arrival_pads)
				HTML += "<br>[D.x],[D.y],[D.z] in [get_area(D)]: <a href='?src=\ref[src];set_target=\ref[D]'>\[Select\]</a>"

	proc/display_window(var/mob/user)
		if (!user)
			return
		src.generate_html()
		user << browse(src.HTML, "window=[src];size=400x480")

	attack_hand(mob/user)
		src.display_window(user)

	attackby(obj/item/W, mob/user)
		src.display_window(user)

/client/proc/cmd_rp_rules()
	set name = "RP Rules"
	set category = "Commands"

	src.Browse( {"<center><h2>Goonstation RP Server Guidelines and Rules - Test Drive Edition</h2></center><hr>
	Welcome to the NSS Destiny! Now, since as this server is intended for roleplay, there are some guidelines, rules and tips to make your time fun for everyone!<hr>
	<ul style='list-style-type:disc'>
		<li>Roleplay and have fun!
			<ul style='list-style-type:circle'>
				<li>Try to have fun with other players too, and try not to be too much of a jerk if you're not a traitor. Accidents may happen, but do not intentionally damage or destroy the station as a non-traitor, the game should be fun for all!</li>
				<li>In the end, we want people to get into character and just try to have fun pretending to be a farty spaceman on a weird ship. This won't be "no silliness allowed" or anything, you don't have to have a believable irl person as a character. Just try to play along with things and have fun interacting and talking to the people around you, create some drama, instead of trying to figure out how to most efficiently win the round, or whatever. If someone is clearly an antag, threatening the ship with a bomb, play along with them instead of trying to immediately beat their face in. Things like that.</li>
			</ul>
		</li>
		<li>If you are a traitor, you make the fun!
			<ul style='list-style-type:circle'>
				<li>Treat your role as an interesting challenge and not an excuse to destroy other peoples' game experience. Your actions should make the game more fun, more exciting and more enjoyable for everyone, don't try to go on a homicidal rampage unless your objectives require you to do so! Try a fun new gimmick, or ask one of the admins!</li>
				<li>You should try to have a plan for something that will be fun for you and your victims. At the very least, interaction between antags and non-antags should be more than a c-saber being applied to the face repeatedly! Some of the objectives already come with added gimmick ideas/suggestions, try using them!</li>
			</ul>
		</li>
		<li>Don't be an awful person.
			<ul style='list-style-type:circle'>
				<li>Hate speech, bigoted language, discrimination, harassment, or sexual content such as, but not limited to ERP and sexual assault will not be tolerated at all and may be considered grounds for immediate banning.</li>
				<li>We're all here to have a good time! Going out of your way to seriously negatively impact or end the round for someone with little to no justification is against the rules. Legitimate conflicts where people get upset do happen however, these conflicts should escalate properly and retribution must be proportionate, roleplaying someone with a mental illness is not a legitimate reason.</li>
			</ul>
		</li>
		<li>Remember that this game relies on trickery, sneakiness, and some suspension of disbelief.
			<ul style='list-style-type:circle'>
				<li>Do not cheat by using multiple accounts or by coordinating with other players through out-of-game communication means</li>
			</ul>
		</li>
		<li>Play out your role believably.
			<ul style='list-style-type:circle'>
				<li>Don't exploit glitches, out-of-character (OOC) knowledge, or knowledge of the game system to give your character advantages that they would not possess otherwise (e.g: a Security Guard probably knows basic first aid, but they wouldn't know how to perform advanced surgery, etc.) you will be expected to try and do your jobs, This won't be so strict that, if a botanist wanders out of hydroponics, they'll get in trouble for being out-of-character, or anything like that. Just that you should be trying to play a character to some degree, and trying to stick to doing what you were presumably on the ship to do.</li>
				<li>Chain-of-command and security are important. The head of your department is your boss and they can fire you, security officers can arrest you for stealing or breaking into places. The preference would be that unless they're doing something unreasonable, such as spacing you for writing on the walls, you shouldn't freak out over being punished for doing something that would, in reality, get you fired or arrested.</li>
				<li><b><i>When you aren't a traitor, you should respect the chain of command, respect Security, and avoid vigilantism!</i></b></li>
			</ul>
		</li>
		<li>Keep IC and OOC separate.
			<ul style='list-style-type:circle'>
				<li>Do not use the OOC channel to spoil IC (In character) events, like the identity of a traitor/changeling. Likewise, do not treat IC chat like OOC (saying things like ((this round sucks)) over radio, etc)</li>
			</ul>
		</li>
		<li>Listen to the administrators.
			<ul style='list-style-type:circle'>
				<li>If an admin asks you to explain your actions or asks you to stop doing something, you probably ought to do so. If you think someone is breaking the rules or ruining the game for everyone else somehow, use the <b>ADMINHELP</b> verb to give us a shout. If you just want tips on how to play the game, try <b>MENTORHELP</b>. Do not log out when an admin is speaking with you.</li>
			</ul>
		</li>
		<li>Real life takes precedence!
			<ul style='list-style-type:circle'>
				<li>If you are the AI or a head position and have to log off, PLEASE adminhelp a quick message. You do not need to wait for a response, but it really helps to know as it can seriously hamstring the station if you just disappear or go AFK.</li>
			</ul>
		</li>
	</ul>"}, "window=rprules;title=RP+Rules;fade_in=1" )

/obj/item/paper/book/space_law
	name = "Space Law"
	desc = "A book explaining the laws of space. Well, this section of space, at least."
	icon_state = "book7"
	info = {"<center><h2>Frontier Justice on the NSS Destiny: A Treatise on Space Law</h2></center>
	<h3>A Brief Summary of Space Law</h3><hr>
	As a Security Officer, the zeroth Space Law that you should probably always obey is to use your common sense. If it is a crime in real life, then it is a crime in this video game. Remember to use your best judgement when arresting criminals, and don't get discouraged if they complain.<br><br>
	For certain crimes, the accused's intent is important. The difference between Assault and Attempted Murder can be very hard to ascertain, and, when in doubt, you should default to the less serious crime. It is important to note though, that Assault and Attempted Murder are mutually exclusive. You cannot be charged with Assault and Attempted Murder from the same crime as the intent of each is different. Likewise, 'Assault With a Deadly Weapon' and 'Assaulting an Officer' are also crimes that exclude others. Pay careful attention to the requirements of each law and select the one that best fits the crime when deciding sentence.<br><br>
	Security roles and their superiors can read the Miranda warning to suspects by using the Recite Miranda Rights verb or *miranda emote. The wording is also customizable via Set Miranda Rights.<br><br>
	Additionally: It is <b><i>highly illegal</i></b> for Nanotrasen personnel to make use of Syndicate devices. Do not use traitor gear as a non-traitor, even to apprehend traitors.<hr>
	Here's a guideline for how you should probably treat suspects by each particular crime.
	<h4>Minor Crimes:</h4>
	<i>No suspect may be sentenced for more than five minutes in the Brig for Minor Crimes. Minor Crime sentences are not cumulative (e.g: max five minutes for committing multiple Minor Crimes).</i>
	<ul style='list-style-type:disc'>
		<li>Assault
			<ul style='list-style-type:circle'>
				<li>To use physical force against someone without the apparent intent to kill them.</li>
			</ul>
		</li>
		<li>Theft
			<ul style='list-style-type:circle'>
				<li>To take items from areas one does not have access to or to take items belonging to others or the ship as a whole.</li>
			</ul>
		</li>
		<li>Fraud</li>
		<li>Breaking and Entering
			<ul style='list-style-type:circle'>
				<li>To deliberately damage the ship without malicious intent.</li>
				<li>To be in an area which a person does not have access to. This counts for general areas of the ship, and trespass in restricted areas is a more serious crime.</li>
			</ul>
		</li>
		<li>Resisting Arrest
			<ul style='list-style-type:circle'>
				<li>To not cooperate with an officer who attempts a proper arrest.</li>
			</ul>
		</li>
		<li>Escaping from the Brig
			<ul style='list-style-type:circle'>
				<li>To escape from a brig cell, or custody.</li>
			</ul>
		</li>
		<li>Assisting or Abetting Criminals
			<ul style='list-style-type:circle'>
				<li>To act as, or knowingly aid, an enemy of Nanotrasen.</li>
			</ul>
		</li>
		<li>Drug Possession
			<ul style='list-style-type:circle'>
				<li>To possess space drugs or other narcotics by unauthorized personnel.</li>
			</ul>
		</li>
		<li>Narcotics Distribution
			<ul style='list-style-type:circle'>
				<li>To distribute narcotics and other controlled substances.</li>
			</ul>
		</li>
	</ul>
	<h4>Major Crime:</h4>
	<i>For Major Crimes, a suspect may be sentenced for more than five minutes, but no more than fifteen. Like above, multiple Major Crime sentences are not cumulative.</i><br>
	<ul style='list-style-type:disc'>
		<li>Murder
			<ul style='list-style-type:circle'>
				<li>To maliciously kill someone.</li>
				<li><b><i>Unauthorised executions are classed as Murder.</i></b></li>
			</ul>
		</li>
		<li>Manslaughter
			<ul style='list-style-type:circle'>
				<li>To unintentionally kill someone through negligent, but not malicious, actions.</li>
				<li>Intent is important. Accidental deaths caused by negligent actions, such as creating workplace hazards (e.g. gas leaks), tampering with equipment, excessive force, and confinement in unsafe conditions are examples of Manslaughter.</li>
			</ul>
		</li>
		<li>Sabotage
			<ul style='list-style-type:circle'>
				<li>To engage in maliciously destructive actions, seriously threatening crew or ship.</li>
				<li>Bombing, arson, releasing viruses, deliberately exposing areas to space, physically destroying machinery or electrifying doors all count as Grand Sabotage.</li>
			</ul>
		</li>
		<li>Enemy of Nanotrasen
			<ul style='list-style-type:circle'>
				<li>To act as, or knowingly aid, an enemy of Nanotrasen.</li>
			</ul>
		</li>
		<li>Creating a Workplace Hazard
			<ul style='list-style-type:circle'>
				<li>To endanger the crew or ship through negligent or irresponsible, but not deliberately malicious, actions.</li>
				<li>Possession of Explosives</li>
			</ul>
		</li>
	</ul>
	<i>Suspects guilty of committing Major Crimes might also be sentenced to death, or perma-brigging, under specific circumstances listed below.</i><br>
	Execution, permabrigging, poisoning, or anything else resulting in death or massive frustration requires:
	<ol type="1">
		<li>Solid evidence of a major crime</li>
		<li>Permission of the following Heads:
			<ol type="i">
				<li>the Head of Security</li>
				<li>the Captain</li>
				<li>the Head of Personnel</li>
			</ol>
		</li>
	</ol>
	Please note that the ruling of the HoS supercedes that of the Captain in criminal matters, and likewise, the Captain with the HoP. Execution should only be used in grievous circumstances.<bt>
	<b><i>The execution of criminals without Command authority, or evidence, is tantamount to murder.</i></b>
	<h3>Standard Security Operating Practice</h3><hr>
	As a Security Officer, you are expected to practice a modicum of due process in detaining, searching, and arresting people. Suspects still have rights, and treating people like scum will usually just turn into more crime and bring about a swift end to your existence. Never use lethal force when nonlethal force will do!<br>
	<ul style='list-style-type:disc'>
		<li>Detain the suspect with minimum force.</li>
		<li>Handcuff the suspect and restrain them by pulling them. If their crime requires a brig time, bring them into the office, preferably via Port-a-Brig.</li>
		<li>In the brig, tell them you're going to search them before doing so. Empty their pockets and remove their backpack. Look through everything. Be sure to open containers inside containers, such as boxes inside backpacks. Be sure to replace all items in the containers when you're done. <b><i>Don't strip them in the hallways!</i></b></li>
		<li>If you need to brig them you can feed them into the little chute next to the brig. Remember to set the timer!</li>
		<li>Confiscate any contraband and/or stolen items, as well as any tools that may be used for future crimes, these need to be placed in a proper evidence locker, or crate and should not be left on the brig floor, or used for personal use, if stolen, return the items to their rightful owners.</li>
		<li>Update their security record if needed.</li>
	</ul>
	"}

/obj/machinery/shield_generator
	name = "shield generator"
	desc = "Some kinda thing what generates a big ol' shield around everything."
	//icon = 'icons/obj/meteor_shield.dmi'
	icon = 'icons/obj/32x96.dmi'
	icon_state = "shieldgen0"
	anchored = 1
	density = 1
	bound_height = 96
	var/obj/machinery/power/data_terminal/link = null
	var/net_id = null
	var/list/shields = list()
	var/active = 0
	var/image/image_active = null
	var/image/image_shower_dir = null
	//var/last_noise_time = 0
	//var/last_noise_length = 0
	//var/sound_loop_interrupt = 0
	var/sound_startup = 'sound/machines/shieldgen_startup.ogg' // 40
	//var/sound_loop = 'sound/machines/shieldgen_mainloop.ogg' // 75
	var/sound_shutoff = 'sound/machines/shieldgen_shutoff.ogg' // 35

	New()
		..()
		src.update_icon()
		spawn(6)
			if (!src.link)
				var/turf/T = get_turf(src)
				var/obj/machinery/power/data_terminal/test_link = locate() in T
				if (test_link && !test_link.is_valid_master(test_link.master))
					src.link = test_link
					src.link.master = src
			src.net_id = generate_net_id(src)

	proc/update_icon()
		if (stat & (NOPOWER|BROKEN))
			src.icon_state = "shieldgen0"
			src.UpdateOverlays(null, "top_lights")
			src.UpdateOverlays(null, "meteor_dir1")
			src.UpdateOverlays(null, "meteor_dir2")
			src.UpdateOverlays(null, "meteor_dir3")
			src.UpdateOverlays(null, "meteor_dir4")
			return

		if (src.active)
			src.icon_state = "shieldgen-anim"
			if (!src.image_active)
				src.image_active = image(src.icon, "shield-top_anim")
			src.UpdateOverlays(src.image_active, "top_lights")
		else
			src.icon_state = "shieldgen1"
			src.UpdateOverlays(null, "top_lights")

		if (meteor_shower_active)
			if (!src.image_shower_dir)
				src.image_shower_dir = image(src.icon, "shield-D[meteor_shower_active]")
			src.image_shower_dir.icon_state = "shield-D[meteor_shower_active]"
			src.UpdateOverlays(src.image_shower_dir, "meteor_dir[meteor_shower_active]")
		else
			src.UpdateOverlays(null, "meteor_dir1")
			src.UpdateOverlays(null, "meteor_dir2")
			src.UpdateOverlays(null, "meteor_dir3")
			src.UpdateOverlays(null, "meteor_dir4")

	process()
		//src.update_icon()
		if (stat & BROKEN)
			src.deactivate()
			return
		..()
		if (stat & NOPOWER)
			src.deactivate()
			return
		src.use_power(250)
		if (src.shields.len)
			src.use_power(5*src.shields.len)
/*
	proc/sound_loop()
		if (sound_loop_interrupt)
			sound_loop_interrupt = 0
			return
		if (active && (last_noise_time + last_noise_length <= ticker.round_elapsed_ticks))
			playsound(src.loc, src.sound_loop, 30)
			src.last_noise_length = 75
			src.last_noise_time = ticker.round_elapsed_ticks
		sleep(2)
		src.sound_loop()
*/
	disposing()
		src.remove_shield()
		src.link = null
		src.image_active = null
		src.image_shower_dir = null
		..()

	receive_signal(datum/signal/signal)
		if (stat & (NOPOWER|BROKEN) || !src.link)
			return
		if (!signal || !src.net_id || signal.encryption)
			return

		if (signal.transmission_method != TRANSMISSION_WIRE) //No radio for us thanks
			return

		var/target = signal.data["sender"]

		//They don't need to target us specifically to ping us.
		//Otherwise, ff they aren't addressing us, ignore them
		if (signal.data["address_1"] != src.net_id)
			if ((signal.data["address_1"] == "ping") && signal.data["sender"])
				spawn(5) //Send a reply for those curious jerks
					src.post_status(target, "command", "ping_reply", "device", "PNET_SHIELD_GEN", "netid", src.net_id)
			return

		var/sigcommand = lowertext(signal.data["command"])
		if (!sigcommand || !signal.data["sender"])
			return

		switch (sigcommand)
			if ("activate")
				if (src.active)
					src.post_reply("SGEN_ACT", target)
					return
				src.activate()
				src.post_reply("SGEN_ACTVD", target)

			if ("deactivate")
				if (!src.active)
					src.post_reply("SGEN_NACT", target)
					return
				src.deactivate()
				src.post_reply("SGEN_DACTVD", target)

	// for testing atm
	attack_hand(mob/user as mob)
		user.show_text("You flip the switch on [src].")
		if (src.active)
			src.deactivate()
		else
			src.activate()
		message_admins("<span style=\"color:blue\">[key_name(user)] [src.active ? "activated" : "deactivated"] shields</span>")
		logTheThing("station", null, null, "[key_name(user)] [src.active ? "activated" : "deactivated"] shields")

	proc/post_status(var/target_id, var/key, var/value, var/key2, var/value2, var/key3, var/value3)
		if (!src.link || !target_id)
			return

		var/datum/signal/signal = get_free_signal()
		signal.source = src
		signal.transmission_method = TRANSMISSION_WIRE
		signal.data[key] = value
		if (key2)
			signal.data[key2] = value2
		if (key3)
			signal.data[key3] = value3

		signal.data["address_1"] = target_id
		signal.data["sender"] = src.net_id

		src.link.post_signal(src, signal)

	proc/post_reply(error_text, target_id)
		if (!error_text || !target_id)
			return
		spawn(3)
			src.post_status(target_id, "command", "device_reply", "status", error_text)
		return

	proc/create_shield()
		var/area/shield_loc = locate(/area/station/shield_zone)
		for (var/turf/T in shield_loc)
			if (!(locate(/obj/forcefield/meteorshield) in T))
				var/obj/forcefield/meteorshield/MS = new /obj/forcefield/meteorshield(T)
				MS.deployer = src
				src.shields += MS

	proc/remove_shield()
		for (var/obj/forcefield/meteorshield/MS in src.shields)
			MS.deployer = null
			src.shields -= MS
			qdel(MS)

	proc/activate()
		if (src.active)
			return
		src.active = 1
		src.create_shield()
		src.update_icon()
		playsound(src.loc, src.sound_startup, 75)
		//src.last_noise_length = 40
		//src.last_noise_time = ticker.round_elapsed_ticks
		//src.sound_loop_interrupt = 0
		//src.sound_loop()

	proc/deactivate()
		if (!src.active)
			return
		src.active = 0
		src.remove_shield()
		src.update_icon()
		playsound(src.loc, src.sound_shutoff, 75)
		//src.last_noise_length = 0
		//src.last_noise_time = ticker.round_elapsed_ticks
		//src.sound_loop_interrupt = 1

/obj/machinery/computer3/generic/shield_control
	name = "shield control computer"
	icon_state = "engine"
	base_icon_state = "engine"
	setup_drive_size = 48

	setup_starting_peripheral1 = /obj/item/peripheral/network/powernet_card
	//setup_starting_peripheral2 = /obj/item/peripheral/network/radio/locked/pda
	setup_starting_program = /datum/computer/file/terminal_program/shield_control

/datum/computer/file/terminal_program/shield_control
	name = "ShieldControl"
	size = 10
	req_access = list(access_engineering_engine)
	var/tmp/authenticated = null //Are we currently logged in?
	var/datum/computer/file/user_data/account = null
	var/obj/item/peripheral/network/powernet_card/pnet_card = null
	var/tmp/gen_net_id = null //The net id of our linked generator
	var/tmp/reply_wait = -1 //How long do we wait for replies? -1 is not waiting.

	var/setup_acc_filepath = "/logs/sysusr"//Where do we look for login data?

	initialize()
		src.authenticated = null
		src.master.temp = null
		if (!src.find_access_file()) //Find the account information, as it's essentially a ~digital ID card~
			src.print_text("<b>Error:</b> Cannot locate user file.  Quitting...")
			src.master.unload_program(src) //Oh no, couldn't find the file.
			return

		src.pnet_card = locate() in src.master.peripherals
		if (!pnet_card || !istype(src.pnet_card))
			src.pnet_card = null
			src.print_text("<b>Warning:</b> No network adapter detected.")

		if (!src.check_access(src.account.access))
			src.print_text("User [src.account.registered] does not have needed access credentials.<br>Quitting...")
			src.master.unload_program(src)
			return

		src.reply_wait = -1
		src.authenticated = src.account.registered

		var/intro_text = {"<b>ShieldControl</b>
		<br>Emergency Defense Shield System
		<br><b>Commands:</b>
		<br>(Link) to link with a shield generator.
		<br>(Activate) to activate shields.
		<br>(Deactivate) to deactivate shields.
		<br>(Clear) to clear the screen.
		<br>(Quit) to exit ShieldControl."}
		src.print_text(intro_text)

	input_text(text)
		if (..())
			return

		var/list/command_list = parse_string(text)
		var/command = command_list[1]
		command_list -= command_list[1] //Remove the command we are now processing.

		switch (lowertext(command))

			if ("link")
				if (!src.pnet_card) //can't do this ~fancy network stuff~ without a network card.
					src.print_text("<b>Error:</b> Network card required.")
					src.master.add_fingerprint(usr)
					return

				src.print_text("Now scanning for shield generator...")
				src.detect_generator()

			if ("activate")
				if (!src.pnet_card)
					src.print_text("<b>Error:</b> Network card required.")
					src.master.add_fingerprint(usr)
					return

				if (!src.gen_net_id)
					src.detect_generator()
					sleep(8)
					if (!src.gen_net_id)
						src.print_text("<b>Error:</b> Unable to detect generator.  Please check network cabling.")
						return
				else
					src.print_text("Transmitting activation request...")
					generate_signal(gen_net_id, "command", "activate")

			if ("deactivate")
				if (!src.pnet_card)
					src.print_text("<b>Error:</b> Network card required.")
					src.master.add_fingerprint(usr)
					return

				if (!src.gen_net_id)
					src.detect_generator()
					sleep(8)
					if (!src.gen_net_id)
						src.print_text("<b>Error:</b> Unable to detect generator.  Please check network cabling.")
						return
				else
					src.print_text("Transmitting deactivation request...")
					generate_signal(gen_net_id, "command", "deactivate")

			if ("help")
				var/help_text = {"<br><b>ShieldControl</b>
				<br>Emergency Defense Shield System
				<br><b>Commands:</b>
				<br>(Link) to link with a shield generator.
				<br>(Activate) to activate shields.
				<br>(Deactivate) to deactivate shields.
				<br>(Clear) to clear the screen.
				<br>(Quit) to exit ShieldControl."}
				src.print_text(help_text)

			if ("clear")
				src.master.temp = null
				src.master.temp_add = "Workspace cleared.<br>"

			if ("quit")
				src.master.temp = ""
				print_text("Now quitting...")
				src.master.unload_program(src)
				return

			else
				print_text("Unknown command : \"[copytext(strip_html(command), 1, 16)]\"")

		src.master.add_fingerprint(usr)
		src.master.updateUsrDialog()
		return

	process()
		if (..())
			return

		if (src.reply_wait > 0)
			src.reply_wait--
			if (src.reply_wait == 0)
				src.print_text("Timed out on generator. Please rescan and retry.")
				src.gen_net_id = null

	receive_command(obj/source, command, datum/signal/signal)
		if ((..()) || (!signal))
			return

		//If we don't have a generator net_id to use, set one.
		switch (signal.data["command"])
			if ("ping_reply")
				if (src.gen_net_id)
					return
				if ((signal.data["device"] != "PNET_SHIELD_GEN") || !signal.data["netid"])
					return

				src.gen_net_id = signal.data["netid"]
				src.print_text("Shield generator detected.")

			if ("device_reply")
				if (!src.gen_net_id || signal.data["sender"] != src.gen_net_id)
					return

				src.reply_wait = -1

				switch (lowertext(signal.data["status"]))
					if ("sgen_act")
						src.print_text("<b>Alert:</b> Shield generator is already active.")

					if ("sgen_nact")
						src.print_text("<b>Alert:</b> Shield generator is already inactive.")

					if ("sgen_actvd")
						src.print_text("<b>Alert:</b> Shield generator activated.")
						if (master && master.current_user)
							message_admins("<span style=\"color:blue\">[key_name(master.current_user)] activated shields</span>")
							logTheThing("station", null, null, "[key_name(master.current_user)] activated shields")

					if ("sgen_dactvd")
						src.print_text("<b>Alert:</b> Shield generator deactivated.")
						if (master && master.current_user)
							message_admins("<span style=\"color:blue\">[key_name(master.current_user)] deactivated shields</span>")
							logTheThing("station", null, null, "[key_name(master.current_user)] deactivated shields")
				return
		return

	proc/find_access_file() //Look for the whimsical account_data file
		var/datum/computer/folder/accdir = src.holder.root
		if (src.master.host_program) //Check where the OS is, preferably.
			accdir = src.master.host_program.holder.root

		var/datum/computer/file/user_data/target = parse_file_directory(setup_acc_filepath, accdir)
		if (target && istype(target))
			src.account = target
			return 1

		return 0

	proc/detect_generator() //Send out a ping signal to find a comm dish.
		if (!src.pnet_card)
			return //The card is kinda crucial for this.

		var/datum/signal/newsignal = get_free_signal()
		//newsignal.encryption = "\ref[src.pnet_card]"

		src.gen_net_id = null
		src.reply_wait = -1
		src.peripheral_command("ping", newsignal, "\ref[src.pnet_card]")

	proc/generate_signal(var/target_id, var/key, var/value, var/key2, var/value2, var/key3, var/value3)
		if (!src.pnet_card || !gen_net_id)
			return

		var/datum/signal/signal = get_free_signal()
		//signal.encryption = "\ref[src.pnet_card]"
		signal.data["address_1"] = target_id
		signal.data[key] = value
		if (key2)
			signal.data[key2] = value2
		if (key3)
			signal.data[key3] = value3

		src.reply_wait = 5
		src.peripheral_command("transmit", signal, "\ref[src.pnet_card]")

/area/station/shield_zone
	icon_state = "shield_zone"

/area/station/aviary
	name = "Aviary"
	icon_state = "aviary"
	sound_environment = 15

/area/station/medical/medbay/cloner
	name = "Cloning"
	icon_state = "cloner"

/area/station/medical/medbay/pharmacy
	name = "Pharmacy"
	icon_state = "chem"

/area/station/medical/medbay/treatment1
	name = "Treatment Room 1"
	icon_state = "treat1"

/area/station/medical/medbay/treatment2
	name = "Treatment Room 2"
	icon_state = "treat2"

/area/station/bridge/captain
	name = "Captain's Office"
	icon_state = "CAPN"

/area/station/bridge/hos
	name = "Head of Personnel's Office"
	icon_state = "HOP"

/area/station/crew_quarters/hos
	name = "Head of Security's Quarters"
	icon_state = "HOS"
	sound_environment = 4

/area/station/crew_quarters/md
	name = "Medical Director's Quarters"
	icon_state = "MD"
	sound_environment = 4

/area/station/crew_quarters/ce
	name = "Chief Engineer's Quarters"
	icon_state = "CE"
	sound_environment = 4

/area/station/engine/engineering/ce
	name = "Chief Engineer's Office"
	icon_state = "CE"

/area/station/crew_quarters/quarters_fore
	name = "Fore Crew Quarters"
	icon_state = "crewquarters"
	sound_environment = 3

/area/station/crew_quarters/quarters_port
	name = "Port Crew Quarters"
	icon_state = "crewquarters"
	sound_environment = 3

/area/station/crew_quarters/quarters_star
	name = "Starboard Crew Quarters"
	icon_state = "crewquarters"
	sound_environment = 3

/area/station/crew_quarters/lounge
	name = "Crew Lounge"
	icon_state = "crew_lounge"
	sound_environment = 2

/area/station/crew_quarters/lounge_port
	name = "Port Crew Lounge"
	icon_state = "crew_lounge"
	sound_environment = 2

/area/station/crew_quarters/lounge_starboard
	name = "Starboard Crew Lounge"
	icon_state = "crew_lounge"
	sound_environment = 2

/area/station/mining
	name = "Mining"
	icon_state = "mining"
	sound_environment = 10

/area/station/mining/refinery
	name = "Mining Refinery"
	icon_state = "miningg"

/area/station/mining/magnet
	name = "Mining Magnet Control Room"
	icon_state = "miningp"

/*
/obj/airlock_door
	icon = 'icons/obj/doors/destiny.dmi'
	icon_state = "gen-left"
	density = 0
	opacity = 0
	var/obj/machinery/door/door = null

	attackby(obj/item/W, mob/M)
		if (src.door)
			src.door.attackby(W, M)

	attack_hand(mob/M)
		if (src.door)
			src.door.attack_hand(M)

	attack_ai(mob/user)
		if (src.door)
			src.door.attack_ai(user)

/obj/machinery/door/airlock/gannets
	icon = 'icons/obj/doors/destiny.dmi'
	icon_state = "track"
	var/obj/airlock_door/d_left = null
	var/d_left_state = "gen-left"
	var/obj/airlock_door/d_right = null
	var/d_right_state = "right"

	New()
		..()
		src.d_right = new(src.loc)
		src.d_right.icon_state = src.d_right_state
		src.d_right.door = src
		// make left after right so it's on top
		src.d_left = new(src.loc)
		src.d_left.icon_state = src.d_left_state
		src.d_left.door = src

	update_icon()
		src.icon_state = "track"
		return
/*
		if (density)
			if (locked)
				icon_state = "[icon_base]_locked"
			else
				icon_state = "[icon_base]_closed"
			if (p_open)
				if (!src.panel_image)
					src.panel_image = image(src.icon, src.panel_icon_state)
				src.UpdateOverlays(src.panel_image, "panel")
			else
				src.UpdateOverlays(null, "panel")
			if (welded)
				if (!src.welded_image)
					src.welded_image = image(src.icon, src.welded_icon_state)
				src.UpdateOverlays(src.welded_image, "weld")
			else
				src.UpdateOverlays(null, "weld")
		else
			src.UpdateOverlays(null, "panel")
			src.UpdateOverlays(null, "weld")
			icon_state = "[icon_base]_open"
		return
*/
	play_animation(animation)
		switch (animation)
			if ("opening")
				animate(src.d_left, time = src.operation_time, pixel_x = -18, easing = BACK_EASING)
				animate(src.d_right, time = src.operation_time, pixel_x = 18, easing = BACK_EASING)
			if ("closing")
				animate(src.d_left, time = src.operation_time, pixel_x = 0, easing = ELASTIC_EASING)
				animate(src.d_right, time = src.operation_time, pixel_x = 0, easing = ELASTIC_EASING)
			if ("spark")
				flick("[d_left_state]_spark", d_left)
				flick("[d_right_state]_spark", d_right)
			if ("deny")
				flick("[d_left_state]_deny", d_left)
				flick("[d_right_state]_deny", d_right)
		return
*/
// TODO:
// - mailputt
// - mailputt pickup port

/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=PAINTBALL=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
/*
/obj/item/gun/kinetic/paintball
	name = "kinetic weapon"
	item_state = "paintball-"
	m_amt = 2000
	ammo = null
	max_ammo_capacity = 10

	auto_eject = 0
	casings_to_eject = 0

	add_residue = 0

/datum/projectile/special/paintball
	name = "red paintball"
	icon_state = "paintball-r"
	icon_turf_hit = "paint-r"
	power = 1
	cost = 1
	dissipation_rate = 1
	dissipation_delay = 0
	ks_ratio = 1.0
	sname = "red"
	shot_sound = 'sound/weapons/Genhit.ogg'
	shot_number = 1
	damage_type = D_KINETIC
	hit_type = DAMAGE_BLUNT
	hit_ground_chance = 50

/obj/item/ammo/bullets/paintball
	sname = "paintball"
	name = "paintball jug"
	icon_state = "357-2"
	amount_left = 4.0
	max_amount = 4.0
	ammo_type = new/datum/projectile/special/paintball
	caliber = 42069
	icon_dynamic = 1
	icon_short = "paintball"
	icon_empty = "paintball-0"

	update_icon()
		if (src.amount_left < 0)
			src.amount_left = 0

		src.desc = "There are [src.amount_left] paintball\s left!"

		if (src.amount_left > 0)
			if (src.icon_dynamic && src.icon_short)
				src.icon_state = "[src.icon_short]1"
		else
			if (src.icon_empty)
				src.icon_state = src.icon_empty
		return
*/
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=BLACKJACK=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
/*
/obj/submachine/blackjack
	name = "blackjack machine"
	desc = "Gambling for the antisocial."
	icon = 'icons/obj/objects.dmi'
	icon_state = "BJ1"
	anchored = 1
	density = 1
	mats = 9
	var/on = 1
	var/plays = 0
	var/working = 0
	var/current_bet = 10
	var/obj/item/card/id/ID = null

	var/list/cards = list() // cards in the deck
	var/list/removed_cards = list() // cards already used, to be moved back to src.cards on a new round
	var/list/hand_player = list()
	var/list/hand_dealer = list()

	var/image/overlay_light = null
	var/image/overlay_id = null

	New()
		..()
		var/datum/playing_card/Card
		var/list/card_suits = list("hearts", "diamonds", "clubs", "spades")
		var/list/card_numbers = list("ace" = 1, "two" = 2, "three" = 3, "four" = 4, "five" = 5, "six" = 6, "seven" = 7, "eight" = 8, "nine" = 9, "ten" = 10, "jack" = 10, "queen" = 10, "king" = 10)

		for (var/suit in card_suits)
			for (var/num in card_numbers)
				Card = new()
				Card.card_name = "[num] of [suit]"
				Card.card_face = "large-[suit]-[num]"
				Card.card_data = card_numbers[num]
				src.cards += Card
		src.cards = shuffle(src.cards)

	proc/deal()
		var/datum/playing_card/Card = pick(src.cards)
		src.cards -= Card
		return Card

	proc/reset_cards()
		for (var/datum/playing_card/Card in src.removed_cards)
			src.cards += Card
			src.removed_cards -= Card
		for (var/datum/playing_card/Card in src.hand_player)
			src.cards += Card
			src.hand_player -= Card
		for (var/datum/playing_card/Card in src.hand_dealer)
			src.cards += Card
			src.hand_dealer -= Card
		src.cards = shuffle(src.cards)

	proc/update_icon()
		if (!src.overlay_light)
			src.overlay_light = image('icons/obj/objects.dmi', "BJ-light")
		src.overlays -= src.overlay_light
		src.overlays -= src.overlay_id
		if (src.ID && src.ID.icon_state)
			src.overlay_id = image(src.icon, "BJ-[src.ID.icon_state]")
			src.overlays += src.overlay_id
		if (src.on)
			if (src.working)
				src.icon_state = "BJ-card2"
			else
				src.icon_state = "BJ-card1"
		else
			src.icon_state = "BJ0"
*/
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-+BARTENDER+-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/mob/living/carbon/human/npc/diner_bartender
	var/im_mad = 0
	var/obj/machinery/chem_dispenser/alcohol/booze = null
	var/obj/machinery/chem_dispenser/soda/soda = null
	var/last_dispenser_search = null
	var/list/glassware = list()

	New()
		..()
		spawn(0)
			randomize_look(src)
			src.equip_if_possible(new /obj/item/clothing/shoes/black(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/rank/bartender(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/clothing/suit/wcoat(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/glasses/thermal/orange, slot_glasses)
			src.equip_if_possible(new /obj/item/gun/kinetic/riotgun(src), slot_in_backpack)
			src.equip_if_possible(new /obj/item/storage/box/glassbox(src), slot_in_backpack)
			for (var/obj/item/reagent_containers/food/drinks/drinkingglass/glass in src)
				src.glassware += glass
			// add a random accent
			var/my_mutation = pick("accent_elvis", "stutter", "accent_chav", "accent_swedish", "accent_tommy", "unintelligable", "slurring")
			src.bioHolder.AddEffect(my_mutation)

	was_harmed(var/mob/M as mob, var/obj/item/weapon as obj)
		src.protect_from(M, null, weapon)

	proc/protect_from(var/mob/M as mob, var/mob/customer as mob, var/obj/item/weapon as obj)
		if (!M)
			return

		if (weapon) // someone got hit by something that hurt
			src.im_mad += 50
			if (!customer || customer == src) // they're doing shit to us
				src.im_mad += 50 // we're double mad

		else if (M.a_intent == INTENT_DISARM) // they're shoving someone around
			src.im_mad += 5
			if (!customer || customer == src) // they're doing shit to us
				src.im_mad += 5 // we're double mad

		else if (M.a_intent == INTENT_GRAB) // they're grabbin' up on someone
			src.im_mad += 20
			src.ai_check_grabs()
			if (!customer || customer == src) // they're doing shit to us
				src.im_mad += 20 // we're double mad

		else if (M.a_intent == INTENT_HARM)
			src.im_mad += 50
			if (!customer || customer == src) // they're doing shit to us
				src.im_mad += 50 // we're double mad

		spawn(rand(10, 30))
			src.yell_at(M, customer)

	proc/yell_at(var/mob/M as mob, var/mob/customer as mob) // blatantly stolen from NPC assistants and then hacked up
		if (!M)
			return
		var/tmp/target_name = M.name
		var/area/current_loc = get_area(src)
		var/tmp/where_I_am = "here"
		if (copytext(current_loc.name, 1, 6) == "Diner")
			where_I_am = "my bar"
		var/tmp/complaint
		if (src.im_mad < 100)
			var/tmp/insult = pick("fucker", "fuckhead", "shithead", "shitface", "shitass", "asshole")
			var/tmp/targ = pick("", ", [target_name]", ", [insult]", ", you [insult]")
			complaint = pick("Hey[targ]!", "Knock it off[targ]!", "What d'you think you're doing[targ]?", "Fuck off[targ]!", "Go fuck yourself[targ]!", "Cut that shit out[targ]!")

			if (customer && (customer != src)  && prob(10))
				complaint += " [customer.name] is [pick("my best customer", "a good customer", "a fucking [pick("idiot", "asshole")], but I still like 'em better than your stupid ass")][pick(", and I ain't lettin' no shithead like you fuck with 'em", "")]!"

		else if (src.im_mad >= 100 && M.health > 0)
			complaint = pick("[target_name], [pick("", "you [pick("better", "best")] ")]get [pick("your ass ", "your ugly [pick("face", "mug")] ", "")]the fuck out of [where_I_am][pick("", " before I make you")]!",\
			"I don't put up with this [pick("", "kinda ")][pick("", "horse", "bull")][pick("shit", "crap")] in [where_I_am], [target_name]!",\
			"I hope you don't like how your face looks, [target_name], cause it's about to get rearranged!",\
			"I told you to [pick("stop that shit", "cut that shit out")], and you [pick("ain't", "didn't", "didn't listen")]! [pick("So now", "It's time", "And now", "Ypu best not be suprised that")] you're gunna [pick("reap what you sewed", "get it", "get what's yours", "get what's comin' to you")]!")
			src.target = M
			src.ai_state = 2
			src.ai_threatened = world.timeofday
			src.ai_target = M
			src.im_mad = 0

			if (customer && (customer != src) && prob(75))
				complaint += " [customer.name] is [pick("my best customer", "a good customer", "a fucking [pick("idiot", "asshole")], but I still like 'em better than your [pick("stupid ass", "ugly [pick("face", "mug")]")]")][pick(", and I ain't lettin' no shithead like you fuck with 'em", "")]!"

		src.say(complaint)

	proc/done_with_you(var/mob/M as mob)
		if (!M)
			return 0

		var/tmp/target_name = M.name
		var/area/current_loc = get_area(src)
		var/tmp/where_I_am = "here"
		if (copytext(current_loc.name, 1, 6) == "Diner")
			where_I_am = "my bar"

		if (M.health <= 10)
			var/tmp/insult = pick("fucker", "fuckhead", "shithead", "shitface", "shitass", "asshole")
			var/tmp/targ = pick("", ", [target_name]", ", [insult]", ", you [insult]")
			var/tmp/punct = pick(".", "!")

			var/tmp/kicked_their_ass = pick("Damn right, you stay down[targ][punct]",\
			"Try it again[targ], and next time you'll be hurting even more[punct]",\
			"Goddamn [insult][punct]")
			src.say(kicked_their_ass)

			src.target = null
			src.ai_state = 0
			src.ai_target = null
			src.im_mad = 0
			walk_towards(src,null)
			return 1

		else if (src.health <= 10)
			var/tmp/kicked_my_ass = pick("Get away from me!",\
			"I give, leave me [pick("", "the hell ", "the fuck ")]alone!",\
			"Fuck, stop!",\
			"No more!",\
			"Enough, please!")
			src.say(kicked_my_ass)

			src.target = null
			src.ai_state = 0
			src.ai_target = null
			src.im_mad = 0
			walk_towards(src,null)
			return 1

		else if (get_dist(src, M) >= 5)
			var/tmp/insult = pick("fucker", "fuckhead", "shithead", "shitface", "shitass", "asshole")
			var/tmp/targ = pick("", ", [target_name]", ", [insult]", ", you [insult]")

			var/tmp/got_away = pick("Yeah, get the fuck outta [where_I_am][targ]!",\
			"Don't [pick("bother coming back", "[pick("", "ever ")]show your [pick("", "ugly ", "stupid ")][pick("face", "mug")] in [where_I_am] again")]",\
			"If I ever catch you in [where_I_am] again, you[pick("'ll regret it", "'ll be diggin' your own grave", "'d best stop by that fancy cloner you fuckers got, first", " won't be leaving in one piece")]!")
			src.say(got_away)

			src.target = null
			src.ai_state = 0
			src.ai_target = null
			src.im_mad = 0
			walk_towards(src,null)
			return 1
		else
			return 0

	ai_action()
		src.ai_check_grabs()
		if (src.ai_state == 2 && src.done_with_you(src.ai_target))
			return
		else
			return ..()

	proc/ai_check_grabs()
		for (var/mob/living/carbon/human/H in all_viewers(7, src))
			var/obj/item/grab/G = H.find_type_in_hand(/obj/item/grab)
			if (!G)
				return 0
/*
			if (G.affecting in npc_protected_mobs)
				if (G.state == 1)
					src.im_mad += 5
				else if (G.state == 2)
					src.im_mad += 20
				else if (G.state == 3)
					src.im_mad += 50
				return 1
*/
			if (G.affecting == src) // we won't put up with shit being done to us nearly as much as we'll put up with it for others
				if (G.state == 1)
					src.im_mad += 20
				else if (G.state == 2)
					src.im_mad += 60
				else if (G.state == 3)
					src.im_mad += 100
				return 1

			return 0
/*
	proc/ai_find_my_bar()
		if (src.booze && src.soda)
			return
		if (ticker.elapsed_ticks < (src.last_dispenser_search + 50))
			return
		src.last_dispenser_search = ticker.elapsed_ticks
		if (!src.booze)
			var/obj/machinery/chem_dispenser/alcohol/new_booze = locate() in view(7, src)
			if (new_booze)
				src.booze = new_booze
		if (!src.soda)
			var/obj/machinery/chem_dispenser/soda/new_soda = locate() in view(7, src)
			if (new_soda)
				src.soda = new_soda

	proc/ai_tend_bar() // :D
		if (!src.booze || !src.soda) // we don't have a place to make drinks  :(
			src.ai_find_my_bar() // look for some dispensers
			if (!src.booze || !src.soda) // we didn't find any!  <:(
				return 0 // let's give up I guess (for now)  :'(
		if (src.booze && src.soda)
*/
/*
/mob/living/carbon/human/attack_hand(mob/M)
	if (src.protected_by_npcs)
		..()
		if (M.a_intent in list(INTENT_HARM,INTENT_DISARM,INTENT_GRAB))
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)
	else
		..()

/mob/living/carbon/human/attackby(obj/item/W, mob/M)
	if (src.protected_by_npcs)
		var/tmp/oldbloss = get_brute_damage()
		var/tmp/oldfloss = get_burn_damage()
		..()
		var/tmp/damage = ((get_brute_damage() - oldbloss) + (get_burn_damage() - oldfloss))
		if ((damage > 0) || W.force)
			for (var/mob/living/carbon/human/npc/diner_bartender/BT in all_viewers(7, src))
				BT.protect_from(M, src)
	else
		..()
*/
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-+MISCSTUFF+-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
/*
datum/reagent/medical/heparin
	name = "heparin"
	id = "heparin"
	description = "An anticoagulant used in heart surgeries, and in the treatment of thrombosis."
	reagent_state = LIQUID
	fluid_r = 252
	fluid_g = 252
	fluid_b = 224
	transparency = 80
	depletion_rate = 0.2
*/
/*
/obj/item // if I accidentally commit this uncommented PLEASE KILL ME tia <3
	var/adj1 = 1
	var/adj2 = 100

/obj/item/scalpel
	attack_self(mob/user as mob)
		..()
		var/new_adj1 = input(user, "adj1", "adj1", src.adj1) as null|num
		var/new_adj2 = input(user, "adj2", "adj2", src.adj2) as null|num
		if (new_adj1)
			src.adj1 = new_adj1
		if (new_adj2)
			src.adj2 = new_adj2

/obj/item/circular_saw
	attack_self(mob/user as mob)
		..()
		var/new_adj1 = input(user, "adj1", "adj1", src.adj1) as null|num
		var/new_adj2 = input(user, "adj2", "adj2", src.adj2) as null|num
		if (new_adj1)
			src.adj1 = new_adj1
		if (new_adj2)
			src.adj2 = new_adj2
*/
/*
	var/num1 = "#FFFFFF"
	var/hexnum = copytext(num1, 2)
	var/num2 = num2hex(hex2num(hexnum) - 554040)
*/

/turf/simulated/floor/plating/random
	New()
		..()
		if (prob(20))
			src.icon_state = pick("panelscorched", "platingdmg1", "platingdmg2", "platingdmg3")
		if (prob(10))
			new /obj/decal/cleanable/dirt(src)
		else if (prob(2))
			var/obj/C = pick(/obj/decal/cleanable/paper, /obj/decal/cleanable/fungus, /obj/decal/cleanable/dirt, /obj/decal/cleanable/ash,\
			/obj/decal/cleanable/molten_item, /obj/decal/cleanable/machine_debris, /obj/decal/cleanable/oil, /obj/decal/cleanable/rust)
			new C (src)
		else if ((locate(/obj) in src) && prob(3))
			var/obj/C = pick(/obj/item/cable_coil/cut/small, /obj/item/brick, /obj/item/cigbutt, /obj/item/scrap, /obj/item/raw_material/scrap_metal,\
			/obj/item/spacecash, /obj/item/tile/steel, /obj/item/weldingtool, /obj/item/screwdriver, /obj/item/wrench, /obj/item/wirecutters, /obj/item/crowbar)
			new C (src)
		else if (prob(1) && prob(2)) // really rare. not "three space things spawn on destiny during first test with just prob(1)" rare.
			var/obj/C = pick(/obj/item/space_thing, /obj/item/sticker/gold_star, /obj/item/sticker/banana, /obj/item/sticker/heart,\
			/obj/item/reagent_containers/vending/bag/random, /obj/item/reagent_containers/vending/vial/random, /obj/item/clothing/mask/cigarette/random)
			new C (src)
		return

/turf/simulated/floor/plating/airless/random
	New()
		..()
		if (prob(20))
			src.icon_state = pick("panelscorched", "platingdmg1", "platingdmg2", "platingdmg3")

/turf/simulated/floor/grass/random
	name = "grass"
	icon_state = "grass1"
	var/list/random_icons = list("grass1", "grass2", "grass3", "grass4")
	New()
		..()
		src.icon_state = pick(random_icons)

/turf/simulated/tempstuff
	name = "floor"
	icon = 'icons/misc/HaineSpriteDump.dmi'
	icon_state = "gooberything_small"

/obj/item/postit_stack
	name = "stack of sticky notes"
	desc = "A little stack of notepaper that you can stick to things."
	icon = 'icons/obj/writing.dmi'
	icon_state = "postit_stack"
	force = 1
	throwforce = 1
	w_class = 1
	amount = 10
	burn_point = 220
	burn_output = 200
	burn_possible = 1
	health = 2

	afterattack(var/atom/A as mob|obj|turf, var/mob/user as mob)
		if (!A)
			return
		if (isarea(A))
			return
		if (src.amount < 0)
			qdel(src)
			return
		var/turf/T = get_turf(A)
		var/obj/decal/cleanable/writing/postit/P = new (T)
		user.visible_message("<b>[user]</b> sticks a sticky note to [T].",\
		"You stick a sticky note to [T].")
		var/obj/item/pen/pen = user.find_type_in_hand(/obj/item/pen)
		if (pen)
			P.attackby(pen, user)
		src.amount --
		if (src.amount < 0)
			qdel(src)
			return

/obj/item/blessed_ball_bearing
	name = "blessed ball bearing" // fill claymores with them for all your nazi-vampire-protection needs
	desc = "How can you tell it's blessed? Well, just look at it! It's so obvious!"
	icon = 'icons/misc/HaineSpriteDump.dmi'
	icon_state = "ballbearing"
	w_class = 1
	force = 7
	throwforce = 5
	stamina_damage = 25
	stamina_cost = 15
	stamina_crit_chance = 5
	rand_pos = 1

	attack(mob/M as mob, mob/user as mob) // big ol hackery here
		if (M && isvampire(M))
			src.force = (src.force * 2)
			src.stamina_damage = (src.stamina_damage * 2)
			src.stamina_crit_chance = (src.stamina_crit_chance * 2)
			..(M, user)
			src.force = (src.force / 2)
			src.stamina_damage = (src.stamina_damage / 2)
			src.stamina_crit_chance = (src.stamina_crit_chance / 2)
		else
			return ..()

	throw_impact(atom/hit_atom)
		if (hit_atom && isvampire(hit_atom))
			src.force = (src.force * 2)
			src.stamina_damage = (src.stamina_damage * 2)
			src.stamina_crit_chance = (src.stamina_crit_chance * 2)
			..(hit_atom)
			src.force = (src.force / 2)
			src.stamina_damage = (src.stamina_damage / 2)
			src.stamina_crit_chance = (src.stamina_crit_chance / 2)
		else
			return ..()

/obj/item/space_thing
	name = "space thing"
	desc = "Some kinda thing, from space. In space. A space thing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "thing"
	flags = FPRINT | CONDUCT | TABLEPASS
	w_class = 1.0
	force = 10
	throwforce = 7
	mats = 50
	contraband = 1
	stamina_damage = 40
	stamina_cost = 30
	stamina_crit_chance = 10

/obj/test_knife_switch_switch
	name = "knife switch switch"
	desc = "This is an object that's just for testing the knife switch art. Don't use it!"
	icon = 'icons/obj/knife_switch.dmi'
	icon_state = "knife_switch1-throw"
	anchored = 1

	verb/change_icon()
		set name = "Change Switch Icon"
		set category = "Debug"
		set src in oview(1)

		var/list/switch_icons = list("switch1", "switch2", "switch3", "switch4", "switch5")

		var/switch_select = input("Switch Icon") as null|anything in switch_icons

		if (!switch_select)
			return
		src.icon_state = "[switch_select]-throw"

	attack_hand(mob/user as mob)
		src.change_icon()
		return

/obj/test_knife_switch_board
	name = "knife switch board"
	desc = "This is an object that's just for testing the knife switch art. Don't use it!"
	icon = 'icons/obj/knife_switch.dmi'
	icon_state = "knife_base1"
	anchored = 1

	verb/change_icon()
		set name = "Change Board Icon"
		set category = "Debug"
		set src in oview(1)

		var/list/board_icons = list("board1", "board2", "board3", "board4", "board5")

		var/board_select = input("Board Icon") as null|anything in board_icons

		if (!board_select)
			return
		src.icon_state = "[board_select]"

	attack_hand(mob/user as mob)
		src.change_icon()
		return

// tOt I ain't agree to no universal corgi ban
// and no one's gunna get it if they just see George and Blair okay!!
// and I can't just rename the pug!!!
/obj/critter/dog/george/orwell
	name = "Orwell"
	icon_state = "corgi"
	doggy = "corgi"

/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=+KALI-MA+=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
// shit be all janky and broken atm, gunna come back to it later
/*
Bali Mangthi Kali Ma.
Sacrifice is what Mother Kali desires.
Shakthi Degi Kali Ma.
Power is what Mother Kali will grant.
Kali ma...
Mother Kali...
Kali ma...
Mother Kali...
Kali ma, shakthi deh!
Mother Kali, give me power!
Ab, uski jan meri mutti me hai! AB, USKI JAN MERI MUTTI ME HAI!
Now, his life is in my fist! NOW, HIS LIFE IS IN MY FIST!

/obj/item/clothing/under/mola_ram
	name = "mola ram thing"
	desc = "kali ma motherfuckers"
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/jumpsuit/hand_js_gimmick.dmi'
	wear_image_icon = 'icons/mob/jumpsuits/worn_js_gimmick.dmi'
	icon_state = "bedsheet"
	item_state = "bedsheet"
	body_parts_covered = TORSO|LEGS|ARMS
	contraband = 8

	equipped(var/mob/user)
		user.verbs += /mob/proc/kali_ma

	unequipped(var/mob/user)
		user.verbs -= /mob/proc/kali_ma
		user.verbs -= /mob/proc/kali_ma_placeholder

/mob/proc/kali_ma_placeholder(var/mob/living/M in grabbing())
	set category = "Sacrifice"
	set name = "Throw (c)"
	set desc = "Spin a grabbed opponent around and throw them."

	boutput(usr, "<span style=\"color:red\">Kali Ma is appeased for the moment!</span>")
	return

/mob/proc/kali_ma(var/mob/living/M in grabbing())
	set category = "Sacrifice"
	set name = "Throw"
	set desc = "Spin a grabbed opponent around and throw them."

	spawn(0)

		if(!src.stat && !src.transforming && M)
			if(src.paralysis > 0 || src.weakened > 0 || src.stunned > 0)
				boutput(src, "You can't do that while incapacitated!")
				return

			if(src.restrained())
				boutput(src, "You can't do that while restrained!")
				return

			else
				for(var/obj/item/grab/G in src)

					if(!G)
						boutput(src, "You must be grabbing someone for this to work!")
						return
					if(istype(G.affecting, /mob/living))
						src.verbs += /mob/proc/kali_ma_placeholder
						src.verbs -= /mob/proc/kali_ma
						src.say("Bali Mangthi Kali Ma.")
						sleep(10)
						var/mob/living/H = G.affecting
						if(H.lying)
							H.lying = 0
							H.paralysis = 0
							H.weakened = 0
							H.set_clothing_icon_dirty()
						H.transforming = 1
						src.transforming = 1
						src.dir = get_dir(src, H)
						H.dir = get_dir(H, src)
						src.visible_message("<span style=\"color:red\"><B>[src] menacingly grabs [H] by the neck!</B></span>")
						src.say("Shakthi Degi Kali Ma.")
						var/dir_offset = get_dir(src, H)
						switch(dir_offset)
							if(NORTH)
								H.pixel_y = -24
								H.layer = src.layer - 1
							if(SOUTH)
								H.pixel_y = 24
								H.layer = src.layer + 1
							if(EAST)
								H.pixel_x = -24
								H.layer = src.layer - 1
							if(WEST)
								H.pixel_x = 24
								H.layer = src.layer - 1
						for(var/i = 0, i < 5, i++)
							H.pixel_y += 2
							sleep(3)
						src.say("Kali Ma...")
						sleep(20)
						src.say("Kali Ma...")
						sleep(20)
						if (istype(H,/mob/living/carbon/human/))
							var/mob/living/carbon/human/HU = H
							src.visible_message("<span style=\"color:red\"><B>[src] shoves \his hand into [H]'s chest!</B></span>")
							src.say("Kali ma, shakthi deh!")
							if(HU.heart_op_stage <= 3.0)
								HU:heart_op_stage = 4.0
								HU.contract_disease(/datum/ailment/disease/noheart,null,null,1)
								var/obj/item/organ/heart/heart = new /obj/item/organ/heart(src.loc)
								heart.donor = HU
								playsound(src.loc, "sound/misc/loudcrunch2.ogg", 75)
								HU.emote("scream")
								sleep(20)
								src.say("Ab, uski jan meri mutti me hai! AB, USKI JAN MERI MUTTI ME HAI!")
							else
								playsound(src.loc, "sound/misc/loudcrunch2.ogg", 75)
								HU.emote("scream")
								src.visible_message("<span style=\"color:red\"><B>[src] finds no heart in [H]'s chest! [src] looks kinda [pick(</span>"embarassed", "miffed", "annoyed", "confused", "baffled")]!</B>")
								sleep(20)
							HU.stunned += 10
							HU.weakened += 12
							var/turf/target = get_edge_target_turf(src, src.dir)
							spawn(0)
								playsound(src.loc, "swing_hit", 40, 1)
								src.visible_message("<span style=\"color:red\"><B>[src] casually tosses [H] away!</B></span>")
								HU.throw_at(target, 10, 2)
							HU.pixel_x = 0
							HU.pixel_y = 0
							HU.transforming = 0

						var/cooldown = max(100,(300-src.jitteriness))
						spawn(cooldown)
							src.verbs -= /mob/proc/kali_ma_placeholder
							if (istype(src:w_uniform, /obj/item/clothing/under/mola_ram))
								src.verbs += /mob/proc/kali_ma
								boutput(src, "<span style=\"color:red\">Kali Ma desires more!</span>")

						return
*/

/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=+COCAINE+=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
/*
// http://en.wikipedia.org/wiki/Cocaine
// http://en.wikipedia.org/wiki/Cocaine_paste
// http://en.wikipedia.org/wiki/Crack_cocaine

/datum/overlayComposition/cocaine
	New()
		var/datum/overlayDefinition/zero = new()
		zero.d_icon_state = "beamout"
		zero.d_blend_mode = 2 //add
		zero.customization_third_color = "#08BFC2"
		zero.d_alpha = 50
		definitions.Add(zero)
/*		var/datum/overlayDefinition/spot = new()
		spot.d_icon_state = "knockout"
		spot.d_blend_mode = 3 //sub
		definitions.Add(spot) */
		return ..()

/datum/overlayComposition/cocaine_minor_od
	New()
		var/datum/overlayDefinition/zero = new()
		zero.d_icon_state = "beamout"
		zero.d_blend_mode = 2
		zero.customization_third_color = "#FFFFFF"
		zero.d_alpha = 50
		definitions.Add(zero)
/*		var/datum/overlayDefinition/spot = new()
		spot.d_icon_state = "knockout"
		spot.d_blend_mode = 3 //sub
		definitions.Add(spot) */
		return ..()

/datum/overlayComposition/cocaine_major_od
	New()
		var/datum/overlayDefinition/zero = new()
		zero.d_icon_state = "beamout"
		zero.d_blend_mode = 2
		zero.customization_third_color = "#C20B08"
		zero.d_alpha = 50
		definitions.Add(zero)
/*		var/datum/overlayDefinition/spot = new()
		spot.d_icon_state = "knockout"
		spot.d_blend_mode = 3 //sub
		definitions.Add(spot) */
		return ..()

/datum/reagent/drug/cocaine_paste
	name = "cocaine paste"
	id = "cocaine_paste"
	description = "A close precursor to cocaine, produced from the leaves of the coca plant. It's not very good for you. Cocaine isn't either, I mean, but at least it's better than this stuff."
	reagent_state = SOLID
	fluid_r = 210
	fluid_g = 220
	fluid_b = 210
	transparency = 255
	addiction_prob = 80
	overdose = 5
	var/remove_buff = 0

/datum/reagent/drug/cocaine
	name = "cocaine"
	id = "cocaine"
	description = "A powerful, dangerous stimulant produced from leaves of the coca plant. It's a fine white powder."
	reagent_state = SOLID
	fluid_r = 250
	fluid_g = 250
	fluid_b = 250
	transparency = 255
	addiction_prob = 75
	overdose = 15
	var/remove_buff = 0

// highly addictive, excellent stimulant.  makes you feel awesome, on top of the world, euphoric, etc.  numbs you a bit.
// as it leaves your system: paranoia, anxiety, restlessness.
// minor OD: paranoid delusions, itching, hallucinations, tachycardia
// major OD: hyperthermia, tremors, convulsions, arrythmia, and sudden cardiac death
// bubs idea (bubdea): medal for injecting someone with epinephrine while they have coke in their system, "Mrs. Wallace"
// <bubs> put the leaves in a thing with some welding fuel
// <bubs> and something analogous to paint thinner
// <bubs> to get cocaine paste
// <bubs> then combine the cocaine paste with sulfuric acid
// <bubs> then for additional fun combine it with baking soda in the kitchen
// <bubs> baking soda, dropper, cocaine in oven makes crack

	on_add()
		if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
			holder.my_atom:add_stam_mod_regen("consumable_good", 200)
		if(hascall(holder.my_atom,"addOverlayComposition"))
			holder.my_atom:addOverlayComposition(/datum/overlayComposition/cocaine)
		return
	on_remove()
		if(remove_buff)
			if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
				holder.my_atom:remove_stam_mod_regen("consumable_good")
		if(hascall(holder.my_atom,"removeOverlayComposition"))
			holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine)
			holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine_minor_od)
			holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine_major_od)
		return

// grabbing shit from meth, crank and bathsalts for now, cause they do some stuff close to what I want

	on_mob_life(var/mob/M)
		if(!M) M = holder.my_atom
		M.drowsyness = max(M.drowsyness-15, 0)
		if(M.paralysis) M.paralysis-=3
		if(M.stunned) M.stunned-=3
		if(M.weakened) M.weakened-=3
		if(M.sleeping) M.sleeping = 0
		if(prob(15)) M.emote(pick("grin", "smirk", "blink", "blink_r", "nod", "twitch", "twitch_v", "laugh", "chuckle", "stare", "leer", "scream"))
		if(prob(10))
			boutput(M, pick("<span style=\"color:red\"><b>You [pick(</span>"feel", "are")] [pick("", "totally ", "utterly ", "completely ", "absolutely ")]fucking [pick("awesome", "rad", "great")]!</b>", "<span style=\"color:red\"><b>[pick(</span>"Fuck", "Fucking", "Hell")] [pick("yeah", "yes")]!</b>", "<span style=\"color:red\"><b>[pick(</span>"Yes", "YES")]!</b>", "<span style=\"color:red\"><b>You've got this shit in the BAG!</b></span>", "<span style=\"color:red\"><b>I said god DAMN!!!</b></span>"))
			M.emote(pick("grin", "smirk", "nod", "laugh", "chuckle", "scream"))
/*		if(prob(6))
			boutput(M, "<span style=\"color:red\"><b>You feel warm.</b></span>")
			M.bodytemperature += rand(1,10)
		if(prob(4))
			boutput(M, "<span style=\"color:red\"><b>You feel kinda awful!</b></span>")
			M.take_toxin_damage(1)
			M.updatehealth()
			M.make_jittery(30)
			M.emote(pick("groan", "moan")) */
		..(M)
		return

	do_overdose(var/severity, var/mob/M)
		var/effect = ..(severity, M)
		if (severity == 1)
			if(hascall(holder.my_atom,"removeOverlayComposition"))
				holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine)
				holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine_major_od)
			if(hascall(holder.my_atom,"addOverlayComposition"))
				holder.my_atom:addOverlayComposition(/datum/overlayComposition/cocaine_minor_od)
			if (effect <= 2)
				M.visible_message("<span style=\"color:red\"><b>[M.name]</b> looks confused!</span>", "<span style=\"color:red\"><b>Fuck, what was that?!</b></span>")
				M.change_misstep_chance(33)
				M.make_jittery(20)
				M.emote(pick("blink", "blink_r", "twitch", "twitch_v", "stare", "leer"))
			else if (effect <= 4)
				M.visible_message("<span style=\"color:red\"><b>[M.name]</b> is all sweaty!</span>", "<span style=\"color:red\"><b>Did it get way fucking hotter in here?</b></span>")
				M.bodytemperature += rand(10,30)
				M.brainloss++
				M.take_toxin_damage(1)
				M.updatehealth()
			else if (effect <= 7)
				M.make_jittery(30)
				M.emote(pick("blink", "blink_r", "twitch", "twitch_v", "stare", "leer"))
		else if (severity == 2)
			if(hascall(holder.my_atom,"removeOverlayComposition"))
				holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine)
				holder.my_atom:removeOverlayComposition(/datum/overlayComposition/cocaine_minor_od)
			if(hascall(holder.my_atom,"addOverlayComposition"))
				holder.my_atom:addOverlayComposition(/datum/overlayComposition/cocaine_major_od)
			if (effect <= 2)
				M.visible_message("<span style=\"color:red\"><b>[M.name]</b> is sweating like a pig!</span>", "<span style=\"color:red\"><b>Fuck, someone turn on the AC!</b></span>")
				M.bodytemperature += rand(20,100)
				M.take_toxin_damage(5)
				M.updatehealth()
			else if (effect <= 4)
				M.visible_message("<span style=\"color:red\"><b>[M.name]</b> starts freaking the fuck out!</span>", "<span style=\"color:red\"><b>Holy shit, what the fuck was that?!</b></span>")
				M.make_jittery(100)
				M.take_toxin_damage(2)
				M.brainloss += 8
				M.updatehealth()
				M.weakened += 3
				M.change_misstep_chance(40)
				M.emote("scream")
			else if (effect <= 7)
				M.emote("scream")
				M.visible_message("<span style=\"color:red\"><b>[M.name]</b> nervously scratches at their skin!</span>", "<span style=\"color:red\"><b>Fuck, so goddamn itchy!</b></span>")
				M.make_jittery(10)
				random_brute_damage(M, 5)
				M.emote(pick("blink", "blink_r", "twitch", "twitch_v", "stare", "leer"))


/* ----------Info from wikipedia----------
Cocaine is a powerful nervous system stimulant.
Its effects can last from fifteen to thirty minutes, to an hour.
That is all depending on the amount of the intake dosage and the route of administration.
Cocaine can be in the form of fine white powder, bitter to the taste.
When inhaled or injected, it causes a numbing effect.
"Crack" cocaine is a smokeable form of cocaine made into small "rocks" by processing cocaine with sodium bicarbonate (baking soda) and water.

Cocaine increases alertness, feelings of well-being and euphoria, energy and motor activity, feelings of competence and sexuality.
Anxiety, paranoia and restlessness can also occur, especially during the comedown.
With excessive dosage, tremors, convulsions and increased body temperature are observed.
Severe cardiac adverse events, particularly sudden cardiac death, become a serious risk at high doses due to cocaine's blocking effect on cardiac sodium channels.

With excessive or prolonged use, the drug can cause itching, tachycardia, hallucinations, and paranoid delusions.
Overdoses cause hyperthermia and a marked elevation of blood pressure, which can be life-threatening, arrhythmias, and death.
   --------------------------------------- */
*/
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-MEDICALPROBLEMS-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
/*
From Ali0en's thread here: http://forum.ss13.co/viewtopic.php?f=6&t=4732
note: I'm gunna dump a bunch more info than needed in here so it's gunna SOUND like I want to simulate all of these to hell and back
I don't though, simplification of this stuff is important for goonstation, I just like having the info around because I'm a mild medical nerd (fyi (I kno u r shoked))

- Seizures: Makes people flop around like a fish or, in minor cases, stare off into space

- Aneurisms: Some chems to relax veins or surgery to install shunts/grafts. Causes internal bleeding, vomiting, and seizures

- Embolisms: Cause blood problems due to poor circulation

- Internal bleeding: Bleeding inside

- Strokes: Disables use of one side of the body (arms and leg, just as if amputated) until remedied, can be temporary and rather harmless or lethal. Bad cases should give players the mutant face to simulate facial droop
http://en.wikipedia.org/wiki/Stroke
http://en.wikipedia.org/wiki/Transient_ischemic_attack
"Stroke, also known as cerebrovascular accident (CVA), cerebrovascular insult (CVI), or brain attack" lol
two kinds:
	ischemic, due to lack of blood to the brain (due to thromboses, embolisms, general decrease in blood in the body - ex shock)
		types:
			total anterior (TACI)
			partial anterior (PACI)
			lacunar (LACI)
			posterior (POCI)
			all of which have similar but slightly different symptoms
		"Users of stimulant drugs such as cocaine and methamphetamine are at a high risk for ischemic strokes."
	hemorrhagic, due to too much blood accumulating in one place (usually due to injuries to the head)
		major types:
			intra-axial (cerebral hemorrhage/hematoma) (blood in the brain tissue itself)
			extra-axial (intracranial hemorrhage) (blood within the skull, outside the brain)
				epidural (between skull and dura mater)
				subdural (between dura mater and brain)
				subarachnoid (between arachnoid mater and pia mater) (may be considered a subtype of subdural?  may not, not entirely clear on this)
				(I'm sure there's all sorts of combos of meninges for these things but these are the notable ones, apparently)
		"Anticoagulant therapy, as well as disorders with blood clotting can heighten the risk that an intracranial hemorrhage will occur."
		"Factors increasing the risk of a subdural hematoma include very young or very old age."
		"Other risk factors for subdural bleeds include taking blood thinners (anticoagulants), long-term alcohol abuse, and dementia."
"The main risk factor for stroke is high blood pressure."
"Other risk factors include tobacco smoking, obesity, high blood cholesterol, diabetes, previous TIA, and atrial fibrillation among others."
symptoms:
	inability to move or feel on one side of the body
	problems understanding or speaking
	feeling like the world is spinning
	loss of one vision to one side
thoughts: a old-style disease with some vars to determine the kind - ischemic/hemorrhagic, which side it affects, etc.
	don't need to get real involved with the types or anything but maybe minor differences in symptoms
treatments:
	ischemic: aspirin (salicylic acid in our case) helps break down clots, if caused by lack of blood in general a transfusion would help
	hemorrhagic: surgery to drain the blood seems to be about it

- Congestive heart failure: Vomiting blood (or pink vomit) and oxy damage. Requires a new heart (I think something like that is already in but expand on it)

- Type 1 Diabetes: Patient needs insulin injections whenever they eat, make some pumps for advanced robotics stuff

- Pacemakers: Make them implants that auto-defib someone for a limited time, or at a weak amount
*/