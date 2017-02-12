//This file contains stuff that is still *mostly* my code.
/*
/atom/verb/textureTest()
	set src in view()
	src.setTexture("damaged", BLEND_MULTIPLY, "damaged")
	src.setTexture("shiny", BLEND_ADD, "shiny")
*/
//
/datum/admins/proc/pixelexplosion()
	set category = "Debug"
	set name = "Pixel animation mode"
	set desc="Enter pixel animation mode"
	alert("Due to me being a lazy fuck you have to close & reopen your client to exit this mode. ITS A DEBUG THING OKAY")
	pixelmagic()

/datum/targetable/pixelpicker
	target_anything = 1
	targeted = 1
	max_range = 3000

	castcheck(var/mob/M)
		if (M.client && M.client.holder)
			return 1

	handleCast(var/atom/selected)
		dothepixelthing(selected)
		var/mob/M = usr
		var/datum/targetable/pixelpicker/R = new()
		M.targeting_spell = R
		M.update_cursor()
		return 1

/proc/pixelmagic()
	var/mob/M = usr
	var/datum/targetable/pixelpicker/R = new()
	M.targeting_spell = R
	M.update_cursor()

/proc/dothepixelthing(var/atom/A)
	//var/list/pixels = list()
	var/icon/I = icon(A.icon, A.icon_state, A.dir)
	var/atom/movable/AT = A.loc
	playsound(AT, 'sound/effects/splat.ogg', 75, 1)
	for(var/y = 1, y <= 32, y++)
		for(var/x = 1, x <= 32, x++)
			var/color = I.GetPixel(x, y)
			if(color != null)
				var/actX = A.pixel_x + x - 1
				var/actY = A.pixel_y + y - 1
				var/obj/apixel/P = new/obj/apixel(A.loc)
				P.pixel_x = actX
				P.pixel_y = actY
				P.color = color
				P.layer = 15
				//pixels.Add(P)
				animate_melt_pixel(P)
	qdel(A)
	//playsound(AT, 'sound/effects/pixelexplosion.ogg', 75, 1)
	//for(var/obj/apixel/P in pixels)
	//	spawn(rand(1,2))
	//		animate_explode_pixel(P)
	//	spawn(10) qdel(P)

	return

/obj/apixel
	name = ""
	desc = "this is a single pixel. wow."
	icon = 'icons/effects/1x1.dmi'
	icon_state = "pixel"
	anchored = 1
	density = 0
	opacity = 0

/obj/item/craftedmelee/spear
	name = "spear"
	desc = "it's an improvised spear."
	icon = null

	rebuild()
		..()
		name = "[core.name]-[head.name] spear"
		desc = "It's an improvised spear. The handle is made from \a [core.name] and the head is \a [head.name]."
		//literally turning the used items into the parts of the spear. Im not sure what i will use this for.
		core.icon = icon('icons/obj/crafting.dmi',"spearbody")
		head.icon = icon('icons/obj/crafting.dmi',"spearhead")

		core.pixel_x = 0
		core.pixel_y = 0

		head.pixel_x = 0
		head.pixel_y = 0

		src.overlays.Cut()
		src.overlays.Add(image(icon = core,loc = src, layer = HUD_LAYER+2)) //This will cause the item to draw above the ui even when its on the ground. That's crap
		src.overlays.Add(image(icon = head,loc = src, layer = HUD_LAYER+2)) //But if i don't set it the item disappears under the inventory slots because it's purely overlays. :gonk:

		src.material = head.material
		return

	attack(mob/M as mob, mob/user as mob) //TBI
		return ..(M,user)

/obj/item/craftedmelee
	name = "melee weapon"
	desc = "this appears to be an improvised melee weapon."
	var/obj/item/core = null
	var/obj/item/head = null

	proc/rebuild() //will rebuild the icon and properties of the weapon based on its materials.
		return

/obj/item/craftedcrap
	name = "???"
	desc = "this appears to be a taped-together mess of random crap."
	var/obj/item/item1 = null
	var/obj/item/item2 = null

	proc/rebuild() //will rebuild the icon and properties of the weapon based on its materials.
		var/icon/crapicon = icon(item1.icon, item1.icon_state)
		crapicon.Blend(icon(item2.icon, item2.icon_state), ICON_OVERLAY)
		icon = crapicon
		setTexture(pick("tape1", "tape2"), ICON_OVERLAY , "tape")
		var/part1 = copytext(item1.name, 1, round(length(item1.name) / 2))
		var/part2 = copytext(item2.name, round(length(item2.name) / 2), 0)
		name = "[part1][part2]"
		desc = "Someone taped together \a [item1.name] and \a [item2.name]. Great."
		return

	attack(mob/M as mob, mob/user as mob)
		if(!item1 || !item2)
			del(src)
			return

		if(prob(50))
			return item1.attack(M, user)
		else
			return item2.attack(M, user)


/proc/makeshittyweapon()
	var/path1
	var/path2
	var/sel1 = alert("Select item 1 type",,"Random","Enter Path")
	switch(sel1)
		if("Random")
			path1 = pick(typesof(/obj/item))
		else
			path1 = text2path(input(usr,"Enter Path:","path","/obj/item") as text)

	var/sel2 = alert("Select item 2 type",,"Random","Enter Path")
	switch(sel2)
		if("Random")
			path2 = pick(typesof(/obj/item))
		else
			path2 = text2path(input(usr,"Enter Path:","path","/obj/item") as text)

	if(!ispath(path1) || !ispath(path2)) return

	var/obj/item/item1 = new path1(usr.loc)
	var/obj/item/item2 = new path2(usr.loc)
	var/obj/item/craftedcrap/tube = new/obj/item/craftedcrap(usr.loc)
	tube.item1 = item1
	tube.item2 = item2
	item1.set_loc(tube)
	item2.set_loc(tube)
	tube.rebuild()
	return tube

/obj/item/ghostboard
	name = "Ouija board"
	desc = "A wooden board that allows for communication with spirits and such things. Or that's what the company that makes them claims, at least."
	icon = 'icons/obj/items.dmi'
	icon_state = "lboard"
	item_state = "clipboard"
	w_class = 3.0
	var/ready = 1
	var/list/users = list()
	var/use_delay = 30

	Click(location,control,params)
		if(istype(usr, /mob/dead) || istype(usr, /mob/wraith))

			if(!users.Find(usr))
				users[usr] = 0

			if((world.time - users[usr]) >= use_delay)
				var/list/words = list()
				for(var/i=0, i<rand(5, 10), i++)
					var/picked = pick(strings("ouija_board.txt", "ouija_board_words"))
					if(!words.Find(picked)) words.Add(picked)

				if(words.len)
					var/selected = input(usr, "Select a word:", src.name) as null|anything in words
					if(!selected) return

					if((world.time - users[usr]) < use_delay)
						usr.show_text("Please wait a moment before using the board again.", "red")
						return

					users[usr] = world.time

					spawn(0)
						if(src && selected)
							animate_float(src, 1, 5, 1)
							for (var/mob/O in observersviewers(7, src))
								O.show_message("<B><span style=\"color:blue\">The board spells out a message ... \"[selected]\"</span></B>", 1)
			else
				usr.show_text("Please wait a moment before using the board again.", "red")
		else
			return ..(location,control,params)

/proc/fartes()
	for(var/imageToLoad in flist("images/"))
		usr << browse_rsc(file("images/[imageToLoad]"))
		boutput(world, "[imageToLoad] - [file("images/[imageToLoad]")]")
	return

/obj/largetest
	name = "test"
	desc = ""
	anchored = 1
	density = 1
	opacity = 0
	icon = 'icons/misc/512x512.dmi'
	icon_state = "0,0"

/obj/peninscription
	name = "mysterious inscription"
	desc = "It's some form of inscription. It reads 'nij ud-bi-ta la-ba-jal-la: ki-sikil tur ur dam-ma-na-ka ce nu-ub-dur-re'. There is a small pictogram below it."
	anchored = 1
	density = 0
	opacity = 0
	icon = 'icons/obj/decals.dmi'
	icon_state = "pen"

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/device/key))
			boutput(user, "[W] disappears suddenly as you bring it close to the inscription ... huh")
			del(W)
		if(istype(W,/obj/item/pen))
			boutput(user, "A terrible noise fills the air as the inscription seemingly rejects [W].")
			playsound(src.loc, "hellhorn_12.ogg", 100, 1)
		return

/obj/burning_barrel
	name = "burning barrel"
	desc = "cozy."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "barrel1"
	density = 1
	anchored = 1
	opacity = 0

	var/datum/particleSystem/barrelSmoke/particles
	var/datum/light/light

	New()
		particles = particleMaster.SpawnSystem(new /datum/particleSystem/barrelSmoke(src))
		light = new /datum/light/point
		light.attach(src)
		light.set_brightness(1)
		light.set_color(0.5, 0.3, 0)
		light.enable()

		..()

	Del()
		particleMaster.RemoveSystem(/datum/particleSystem/barrelSmoke, src)
		..()

/obj/hh_portal_exit
	icon = 'icons/misc/exploration.dmi'
	icon_state = "riftexit"
	name = "???"
	desc = ""
	anchored = 1
	density = 1
	opacity = 0

	Bumped(atom/movable/AM)
		if(!ismob(AM)) return
		var/mob/M = AM

		if(M.adventure_variables.hh_energy < 3)
			boutput(M, "<span style=\"color:red\">You can't seem to pass through the energy ... </span>")
			return

		var/mob/dead/hhghost/H = new(AM.loc)
		H.client = M.client
		H.original = M
		M.set_loc(H)

		AM = H

		var/area/srcar = AM.loc.loc
		srcar.Exited(AM)

		var/obj/target = locate(/obj/landmark/hh_exit)

		if (!istype(target))
			return

		var/turf/trg_turf = target.loc

		var/area/trgar = trg_turf.loc
		trgar.Entered(AM, AM.loc)

		AM.set_loc(trg_turf)

/obj/hh_portal_entry
	icon = 'icons/misc/exploration.dmi'
	icon_state = "atear"
	name = "???"
	desc = ""
	anchored = 1
	density = 1
	opacity = 0

	Bumped(atom/movable/AM)
		if(!AM.reagents) return
		if(!ismob(AM)) return

		if(AM.reagents.has_reagent("anima") && !AM.reagents.has_reagent("anima", 10))
			boutput(AM, "<span style=\"color:red\">The portal briefly glows as you get near but quickly dulls again. It seems like you have done SOMETHING correctly but it isn't quite enough.</span>")
			return

		if(!AM.reagents.has_reagent("anima"))
			boutput(AM, "<span style=\"color:red\">The strange energy in front of you becomes solid as you approach ...</span>")
			return

		AM.reagents.del_reagent("anima")

		var/area/srcar = AM.loc.loc
		srcar.Exited(AM)

		var/obj/target = locate(/obj/landmark/hh_entry)

		if (!istype(target))
			return

		var/turf/trg_turf = target.loc

		var/area/trgar = trg_turf.loc
		trgar.Entered(AM, AM.loc)

		AM.set_loc(trg_turf)

		return

/obj/landmark/hh_exit
	name = "hh_exit"
	//tag = "hh_exit"

/obj/landmark/hh_entry
	name = "hh_entry"
	//tag = "hh_entry"

/obj/hh_sfrag
	name = "soul fragment"
	desc = "a small portion of someones life energies ..."
	icon = 'icons/misc/exploration.dmi'
	icon_state = "empty"
	anchored = 1
	density = 0
	opacity = 0
	invisibility = 100
	var/image/oimage = null

	New()
		oimage = image('icons/misc/exploration.dmi',src,"sfrag")
		orbicons.Add(oimage)
		return ..()

	Del()
		orbicons.Remove(oimage)
		del(oimage)
		..()

	HasEntered(atom/A)
		if(!istype(A,/mob/dead/hhghost)) return
		var/mob/dead/hhghost/M = A
		M.adventure_variables.hh_soul += 1
		particleMaster.SpawnSystem(new /datum/particleSystem/elecburst(M))

		if(M.adventure_variables.hh_soul > 15)
			M.original.set_loc(src.loc)
			M.original.client = M.client
			del(M)

		del(src)
		return

/obj/hh_energyorb
	name = "scintilating energy"
	desc = "..."
	icon = 'icons/misc/exploration.dmi'
	icon_state = "eorb"
	anchored = 1
	density = 0
	opacity = 0

	HasEntered(atom/A)
		if(!ismob(A) || !istype(A,/mob/living)) return
		qdel(src)
		var/mob/living/M = A
		M.adventure_variables.hh_energy += 1
		particleMaster.SpawnSystem(new /datum/particleSystem/energysp(M))
		return

/obj/decal/nothing
	name = "nothing"
	icon = 'icons/obj/decals.dmi'
	icon_state = "blank"
	anchored = 1
	density = 0
	opacity = 0

/obj/decal/nothingplug
	name = "nothing"
	icon = 'icons/obj/decals.dmi'
	icon_state = "blank-plug"
	anchored = 1
	density = 0
	opacity = 0

/obj/decal/hfireplug
	name = "fire"
	icon = 'icons/obj/decals.dmi'
	icon_state = "hfireplug"
	anchored = 1
	density = 0
	opacity = 0

/obj/decal/hfire
	name = "fire"
	icon = 'icons/obj/decals.dmi'
	icon_state = "hfire"
	anchored = 1
	density = 0
	opacity = 0

/obj/decal/tileswish
	name = "nothing"
	icon = 'icons/obj/decals.dmi'
	icon_state = "tileswish"
	anchored = 1
	density = 0
	opacity = 0

/obj/decal/swirlthing
	name = "vortex"
	desc = "a swirling blue vortex"
	icon = 'icons/effects/effects.dmi'
	icon_state = "swirlthing"
	anchored = 1
	density = 0
	opacity = 0

/obj/item/teslacannon
	desc = "An experimental piece of syndicate technology."
	name = "Tesla cannon"
	icon = 'icons/obj/gun.dmi'
	icon_state = "teslacannon"
	item_state = "gun"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 1.0
	var/firing = 0

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		shoot(target, user)
		return

	proc/shoot(var/atom/target, var/mob/user)
		if(firing) return
		firing = 1
		user.canmove = 0
		var/turf/current = get_turf(user)
		var/turf/trg_loc = get_turf(target)
		var/list/sounds = list('sound/effects/elec_bigzap.ogg','sound/effects/elec_bzzz.ogg','sound/effects/electric_shock.ogg')
		while(current != trg_loc)
			playsound(get_turf(user), pick(sounds), 15, 1)
			current = get_step(current, get_dir(current, trg_loc))
			user.dir = get_dir(user, current)
			var/obj/beam_dummy/B = showLine(get_turf(user), current, "lght", 5)
			var/list/affected = B.affected
			for(var/turf/T in affected)
				animate_flash_color_fill(T,"#aaddff",1,5)
				for(var/mob/M in T)
					M.weakened += 2
					random_burn_damage(M, 10)

				if(istype(T, /turf/simulated/floor))
					if(!T:broken)
						if(T:burnt)
							T:break_tile()
						else
							T:burn_tile()
			spawn(6) qdel(B)
			sleep(3)
		sleep(1)

		user.canmove = 1
		firing = 0
		return


//Fix portal creation for areas and such.
//Test with explosion proc
/obj/proctrigger		  //Oh boy. This thing calls a proc of or on an object when an object enter it's tile. It's a bit difficult to explain, best not touch this.
	name = "ProcTrigger"
	desc = "If you see this and you're not an admin then that's sorta bad."
	density = 0
	anchored = 1
	opacity = 0
	invisibility = 100
	icon = 'icons/effects/ULIcons.dmi'
	icon_state = "7-3-0"
	var
		procName = null   //Name of the proc being called.
		procTarget = null //Owner of the proc being called.
		list/turf/procArgs = list()
		procCooldown = 0
		canTrigger = 1

	proc/copy_to(var/turf/T)
		if(!T) return
		var/obj/proctrigger/P = new/obj/proctrigger(T)
		P.procName = src.procName
		P.procTarget = src.procTarget
		P.procArgs = src.procArgs.Copy()
		P.procCooldown = src.procCooldown
		return

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		var/turf/trgTurf = get_turf(over_object)
		if(istype(trgTurf))
			switch(alert("Do you want to create a copy of the trigger on this tile?",,"Yes","No"))
				if("Yes")
					copy_to(trgTurf)
					boutput(usr, "<span style=\"color:green\">*** All done ***</span>")
				if("No")
					return
		return

	Crossed(atom/movable/O)
		if(!canTrigger) return
		canTrigger = 0
		spawn(procCooldown) canTrigger = 1

		if(length(procName))
			var/list/modList = list()

			for(var/x in procArgs)
				if(x == "***trigger***")
					modList += O
				else
					modList += x

			if (procTarget)
				if(procTarget == "***trigger***")
					if(hascall(O, procName))
						call(O,procName)(arglist(modList))
				else
					if(hascall(procTarget, procName))
						call(procTarget,procName)(arglist(modList))
			else
				call(procName)(arglist(modList))
		return

	Click()
		if(!usr.client.holder) return //basic admin check
		var/target = null

		switch(alert("Proc owned by obj?",,"Yes","No"))
			if("Yes")
				switch(alert("Proc owned by triggering object?",,"Yes","No"))
					if("Yes")
						target = "***trigger***"
					if("No")
						target = input("Select target:","Target",null) as obj|mob|area|turf in world
			if("No")
				target = null

		var/procname = input("Procpath","path:", null) as text
		var/argnum = input("Number of arguments:","Number", 0) as num
		var/list/listargs = list()

		for(var/i=0, i<argnum, i++)
			var/class = input("Type of Argument #[i]","Variable Type", null) in list("text","num","type","reference","mob reference", "icon","file", "*triggering object*","cancel")
			switch(class)
				if("-cancel-")
					return

				if("*triggering object*")
					listargs += "***trigger***"

				if("text")
					listargs += input("Enter new text:","Text",null) as text

				if("num")
					listargs += input("Enter new number:","Num", 0) as num

				if("type")
					listargs += input("Enter type:","Type", null) in typesof(/obj,/mob,/area,/turf)

				if("reference")
					listargs += input("Select reference:","Reference", null) as mob|obj|turf|area in world

				if("mob reference")
					listargs += input("Select reference:","Reference", null) as mob in world

				if("file")
					listargs += input("Pick file:","File", null) as file

				if("icon")
					listargs += input("Pick icon:","Icon", null) as icon

		procArgs = listargs
		procName = procname
		procTarget = target
		boutput(usr, "<span style=\"color:green\">*** All done ***</span>")

		return

	ex_act()
		return

/obj/objspawner			   //Thing that continously spawns objects. For event's or something. I wouldn't use this on the actual map. It's not very efficient.
	name = "ObjSpawner"
	desc = "If you see this and you're not an admin then that's sorta bad."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	density = 0
	anchored = 1
	opacity = 0
	invisibility = 100
	var/spawn_rate = 100 	   //Time before a new object spaws after the previous is gone.
	var/spawn_check_rate = 10  //How often we check if we need to spawn something.
	var/spawn_type = null	   //Type to spawn

	proc/runIt()
		if(istext(spawn_type))
			spawn_type = text2path(spawn_type)
		if(ispath(spawn_type))
			if(!(locate(spawn_type) in src.loc))
				sleep(spawn_rate)
				new spawn_type(src.loc)
		spawn(spawn_check_rate)
			runIt()
		return

	Click()
		if(!usr.client.holder) return //basic admin check
		var/nSpawn = input(usr, "Select spawn type") in typesof(/obj)
		var/nCheck = input(usr, "Spawn check delay") as num
		var/nRate = input(usr, "Spawn check delay") as num
		if(nSpawn && nCheck && nRate)
			spawn_rate = nRate
			spawn_check_rate = nCheck
			spawn_type = nSpawn
			boutput(usr, "<span style=\"color:green\">*** All done ***</span>")
		return

	New()
		spawn(0) runIt()
		return ..()

	ex_act()
		return

/proc/gobuzz()
	if(buzztile)
		usr.loc = buzztile
	return

/obj/item/beamtest
	desc = "beamtest thingamobob"
	name = "beamtest thingamobob"
	icon = 'icons/effects/alch.dmi'
	icon_state = "pstone"
	item_state = "injector"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 1.0

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		var/obj/beam_dummy/B = showLine(get_turf(src), get_turf(target), "beam", 10)
		sleep(30)
		qdel(B)
		return

/obj/beam_dummy
	name = "beam"
	desc = ""
	icon = 'icons/effects/lines.dmi'
	icon_state = "lght"
	density = 0
	anchored = 1
	opacity = 0
	layer = NOLIGHT_EFFECTS_LAYER_BASE
	pixel_y = -16
	var/list/affected = list() //List of crossed tiles.
	var/origin_angle = -1
	var/atom/origin = null
	var/atom/target = null

/obj/fireworksbox
	name = "Box of Fireworks"
	desc = "The Label simply reads : \"Firwerks fun is having total family. Made in Spacechina\""
	density = 0
	anchored = 0
	opacity = 0
	icon = 'icons/obj/objects.dmi'
	icon_state = "fireworksbox"
	var/fireworking = 0

	attack_hand(mob/user as mob)
		if(fireworking) return
		fireworking = 1
		boutput(user, "<span style=\"color:red\">The fireworks go off as soon as you touch the box. This is some high quality stuff.</span>")
		anchored = 1

		spawn(0)
			for(var/i=0, i<rand(30,40), i++)
				particleMaster.SpawnSystem(new /datum/particleSystem/fireworks(src.loc))
				sleep(rand(2, 15))

			for(var/mob/O in oviewers(world.view, src))
				O.show_message("<span style=\"color:blue\">The box of fireworks magically disappears.</span>", 1)

			qdel(src)
		return

/obj/candle_light_2spoopy
	icon = 'icons/effects/alch.dmi'
	icon_state = "candle"
	name = "spooky candle"
	desc = "It's a big candle. It's also floating."
	density = 0
	anchored = 1
	opacity = 0
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_brightness(0.7)
		light.set_color(0.5, 0.3, 0)
		light.attach(src)
		light.enable()

		var/spoopydegrees = rand(5, 20)

		spawn(rand(1,10))
			animate(src, pixel_y = 32, transform = matrix(spoopydegrees, MATRIX_ROTATE), time = 20, loop = -1, easing = SINE_EASING)
			animate(pixel_y = 0, transform = matrix(-1 * spoopydegrees, MATRIX_ROTATE), time = 20, loop = -1, easing = SINE_EASING)


//Really sorry about the shitty code below. I couldn't be arsed to do it properly.
/obj/candle_light
	icon = 'icons/effects/alch.dmi'
	icon_state = "candle"
	name = "candle"
	desc = "It's a big candle"
	density = 0
	anchored = 1
	opacity = 0

	var/datum/light/point/light

	New()
		..()
		light = new
		light.set_brightness(0.7)
		light.set_color(1, 0.6, 0)
		light.set_height(0.75)
		light.attach(src)
		light.enable()

/obj/item/alchemy/stone
	desc = "A blood red stone. It pulses ever so slightly when you hold it."
	name = "philosopher's stone"
	icon = 'icons/effects/alch.dmi'
	icon_state = "pstone"
	item_state = "injector"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 1.0
	var/datum/light/light

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(get_dist(target,user) > 1)
			return
		return

	attack()
		return

	New()
		..()
		src.visible_message("<span style=\"color:blue\"><b>[src] appears out of thin air!</b></span>")
		new /obj/effects/shockwave {name = "mystical energy";} (src.loc)
		light = new /datum/light/point
		light.attach(src)
		light.set_color(1,0.5,0.5)
		light.set_height(0.2)
		light.set_brightness(0.4)
		light.enable()

/obj/item/alchemy/powder
	desc = "A little purple pouch filled with a white powder."
	name = "purple pouch"
	icon = 'icons/effects/alch.dmi'
	icon_state = "powder"
	item_state = "injector"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 1.0

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(get_dist(target,user) > 1 && !istype(target, /obj/alchemy/circle))
			return
		if(target == loc) return
		boutput(user, "<span style=\"color:blue\">Your sprinkle some powder on \the [target].</span>")
		if(istype(target, /obj/alchemy/circle))
			target:activate()
		return

	attack()
		return

/obj/item/paper/alchemy
	name = "notebook page 1"
	desc = "a page torn from a notebook"
	info = "... blood is the catalyst ... the arcane powder the key..."

/obj/item/paper/alchemy/north
	name = "notebook page 2"
	New()
		spawn(100)
			info = "... [alchemy_symbols["north"]] stands above all else ..."

/obj/item/paper/alchemy/southeast
	name = "notebook page 3"
	New()
		spawn(100)
			info = "... in the place the sun rises, [alchemy_symbols["southeast"]] is required ..."

/obj/item/paper/alchemy/southwest
	name = "notebook page 4"
	New()
		spawn(100)
			info = "... [alchemy_symbols["southwest"]] where light fades ..."

/obj/item/alchemy/symbol
	name = "Symbol"
	desc = "Some sort of alchemical Symbol on a Scroll."
	icon = 'icons/effects/alch.dmi'
	var/info = ""

/var/list/alchemy_symbols = new/list()

/obj/item/alchemy/symbol/water
	icon_state = "alch_water"
	info = "Water"

/obj/item/alchemy/symbol/fire
	icon_state = "alch_fire"
	info = "Fire"

/obj/item/alchemy/symbol/air
	icon_state = "alch_air"
	info = "Air"

/obj/item/alchemy/symbol/earth
	icon_state = "alch_earth"
	info = "Earth"

/obj/item/alchemy/symbol/connect
	icon_state = "alch_con"
	info = "Connection"

/obj/item/alchemy/symbol/distill
	icon_state = "alch_distill"
	info = "Distillation"

/obj/item/alchemy/symbol/incin
	icon_state = "alch_incin"
	info = "Incineration"

/obj/item/alchemy/symbol/life
	icon_state = "alch_life"
	info = "Life"

/obj/item/alchemy/symbol/proj
	icon_state = "alch_proj"
	info = "Projection"

/obj/item/alchemy/symbol/salt
	icon_state = "alch_salt"
	info = "Salt"

/obj/alchemy/empty
	name = "Empty Circle"
	desc = "An Empty Circle, waiting to be filled"
	anchored = 1
	density = 0
	opacity= 0
	icon = 'icons/effects/alch.dmi'
	icon_state = "alch_empty"
	var/obj/item/alchemy/symbol = null
	var/requiredType = null

	attack_hand(mob/user as mob)
		if(symbol != null)
			symbol.loc = src.loc
			symbol = null
			overlays.Cut()
			boutput(usr, "<span style=\"color:blue\">You remove the Symbol.</span>")
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/alchemy/symbol) && symbol == null)
			user.drop_item()
			symbol = W
			symbol.loc = src
			overlays += symbol
			boutput(usr, "<span style=\"color:blue\">You put the Symbol in the Circle.</span>")
		return

/obj/alchemy/circle
	name = "Alchemy Circle"
	desc = "A bizzare looking mass of lines and circles is drawn onto the floor here."
	anchored = 1
	density = 0
	opacity= 0
	layer = FLOOR_EQUIP_LAYER1
	icon = 'icons/effects/160x160.dmi'
	icon_state = "alchcircle"
	var/activated = 0

	var/obj/alchemy/empty/north = null
	var/obj/alchemy/empty/southwest = null
	var/obj/alchemy/empty/southeast = null
	var/target_id = "alchemy"

	proc/activate()
		if(activated) return
		if((north.symbol && istype(north.symbol,north.requiredType)) && (southwest.symbol && istype(southwest.symbol,southwest.requiredType)) && (southeast.symbol && istype(southeast.symbol,southeast.requiredType)))
			var/turf/middle = locate(src.x + 2, src.y + 2, src.z)
			var/blood = 0
			for(var/atom/A in range(2, middle))
				if(istype(A, /obj/decal/cleanable/blood))
					blood = 1
					break
			if(blood == 1)
				activated = 1
				boutput(usr, "<span style=\"color:green\">The Circle begins to vibrate and glow.</span>")
				playsound(src.loc, "sound/effects/chanting.ogg", 50, 1)
				sleep(10)
				shake_camera(usr, 15, 1, 0.2)
				sleep(10)
				for(var/turf/T in range(2,middle))
					new/obj/decal/cleanable/greenglow(T)
				sleep(10)
				world << sound('sound/effects/mag_pandroar.ogg', volume=60) // heh
				shake_camera(usr, 15, 1, 0.5)
				new/obj/item/alchemy/stone(middle)
				sleep(2)
				var/obj/graveyard/loose_rock/R = locate("loose_rock_[target_id]")
				if(istype(R))
					spawn(1)
						R.crumble()
				var/area/the_catacombs = get_area(src)
				for (var/mob/living/M in the_catacombs)
					if (M.stat == 2)
						continue

					M.unlock_medal("Illuminated", 1)

			else
				boutput(usr, "<span style=\"color:blue\">The Circle glows faintly before returning to normal. Maybe something is missing.</span>")
			return
		else
			boutput(usr, "<span style=\"color:red\">The Circle remains silent ...</span>")

	attackby(obj/item/W as obj, mob/user as mob)
		if(activated) return


	New(var/location)
		var/list/types = new/list()
		var/obj/item/alchemy/symbol/S = null

		for(var/A in typesof(/obj/item/alchemy/symbol) - /obj/item/alchemy/symbol)
			types += A

		loc = location
		north = new(locate(src.loc.x + 2, src.loc.y + 3, src.loc.z))
		var/ntype = pick(types)

		S = new ntype()
		alchemy_symbols["north"] = S.info

		types -= ntype
		north.requiredType = ntype

		southwest = new(locate(src.loc.x + 1, src.loc.y + 1, src.loc.z))
		southwest.pixel_y = 16
		var/swtype = pick(types)

		S = new swtype()
		alchemy_symbols["southwest"] = S.info

		types -= swtype
		southwest.requiredType = swtype

		southeast = new(locate(src.loc.x + 3, src.loc.y + 1, src.loc.z))
		southeast.pixel_y = 16
		var/setype = pick(types)

		S = new setype()
		alchemy_symbols["southeast"] = S.info

		types -= setype
		southeast.requiredType = setype

		return

/obj/line_obj/elec
	name = "electricity"
	desc = ""
	anchored = 1
	density = 0
	opacity = 0

/obj/elec_trg_dummy
	name = ""
	desc = ""
	anchored = 1
	density = 0
	opacity = 0
	invisibility = 99
/*
/obj/item/rpg_rocket_shuttle
	name = "MPRT rocket"
	desc = "A rocket-propelled grenade with a HEAT warhead."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "rpg_rocket"
	item_state = "chips"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	flags = FPRINT | TABLEPASS | CONDUCT
	var/state = 0
	var/yo = null
	var/xo = null
	var/current = null

	New()
		..()

	proc
		explode()
			var/turf/T = get_turf(src.loc)

			if(T)
				//explosion(src, turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, var/lagreducer = 0)
				explosion(src, T, -1, -1, 1, 2)
			qdel(src)

	process()
		if ((!( src.current ) || src.loc == src.current))
			src.current = locate(min(max(src.x + src.xo, 1), world.maxx), min(max(src.y + src.yo, 1), world.maxy), src.z)
		if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			//SN src = null
			qdel(src)
			return
		step_towards(src, src.current)
		spawn( 1 )
			process()
			return
		return

	Bump(atom/movable/AM as mob|obj)
		if(!state)
			..()
			return
		explode()

/obj/shuttle_cannon
	name = "Shuttle Cannon"
	desc = "Pew Pew"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "shuttlecannonthing"
	anchored = 1
	density = 1
	var/ready = 1

	verb/enter()
		set src in view(1)
		set name = "Enter"

		if(src.contents.len)
			boutput(usr, "Someone is already using this.")
			return

		usr.client.view = 11
		usr.see_in_dark = 11

		usr.set_loc(src)

	verb/exit()
		set src in view(1)
		set name = "Exit"

		if(!(usr in src.contents))
			boutput(usr, "You are not using this.")
			return

		usr.client.view = world.view
		usr.see_in_dark = initial(usr.see_in_dark)

		usr.set_loc(src.loc)

	relaymove(mob/user, direction)
		if(!ready) return
		ready = 0
		if(direction == turn(src.dir, 180))
			ready = 1
			return
		var/turf/fire_target_tile = get_step(get_step(get_step(get_step(src, src.dir), src.dir), direction), direction)

		spawn(1)
			playsound(src, "sound/weapons/rocket.ogg", 50, 1)

			var/obj/item/rpg_rocket/R = new

			R.set_loc(get_step(src, src.dir))
			R.density = 1
			R.state = 1
			R.current = fire_target_tile
			R.yo = fire_target_tile.y - src.y
			R.xo = fire_target_tile.x - src.x

			R.process()

		spawn(25) ready = 1
*/

/obj/movable_area_controler
	name = "controler"
	desc = "Don't move this thing or you're gonna have a bad time."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1
	density = 0
	var/areasize = ""
	var/moving = 0
	var/usable = 0

	verb/setup_area()
		set src in view(1)
		set name = "Setup"
		src.verbs -= /obj/movable_area_controler/verb/setup_area

		var/width = input(usr,"Width:","Setup",7) as num
		var/height = input(usr,"Height:","Setup",5) as num

		areasize = "[width]x[height]"

		for(var/turf/T in range(areasize, src))
			if(!isturf(T)) continue
			new/turf/unsimulated/floor(T)

		usable = 1

	verb/enter()
		set src in view(1)
		set name = "Enter"

		if(src.contents.len)
			boutput(usr, "Someone is already using this.")
			return

		usr.client.view = 12
		usr.see_in_dark = 12

		src.overlays += usr
		usr.set_loc(src)

	verb/exit()
		set src in view(1)
		set name = "Exit"

		if(!(usr in src.contents))
			boutput(usr, "You are not using this.")
			return

		usr.client.view = world.view
		usr.see_in_dark = initial(usr.see_in_dark)

		src.overlays.Cut()
		usr.set_loc(src.loc)

	relaymove(mob/user, direction)
		if(moving || !usable) return
		moving = 1

		var/turf/new_loc = get_step(src, direction)

		var/list/oldareaturfs = new/list()
		var/list/newareaturfs = new/list()

		var/list/objects_to_move = new/list()

		for(var/turf/T in range(areasize, src))
			if(!isturf(T)) continue
			oldareaturfs += T
			for(var/atom/movable/A in T)
				objects_to_move += A

		for(var/turf/T in range(areasize, new_loc))
			if(!isturf(T)) continue
			newareaturfs += T

		if(newareaturfs.len < oldareaturfs.len) //Out of bounds. Fucking byond.
			moving = 0
			return

		//Oh man. Dont ask what im doing here. It's Craaaazy
		var/list/commonturfs = oldareaturfs & newareaturfs

		var/list/newturfs = newareaturfs ^ commonturfs
		var/list/discardedturfs = oldareaturfs ^ commonturfs

		for(var/turf/T in newturfs)
			if(!movable_area_check(T))
				moving = 0
				return

		for(var/turf/T in newturfs)
			T.movable_area_prev_type = T.type
			for(var/atom/movable/A in T)
				A.set_loc(get_step(A.loc, direction))

		for(var/turf/T in newareaturfs)
			if(!isturf(T)) continue
			var/turf/prev_turf = get_step(T, turn(direction, 180))
			T.movable_area_next_type = prev_turf.type

		for(var/turf/T in newareaturfs)
			if(!isturf(T)) continue

			var/oldtype = T.movable_area_prev_type

			var/turf/tnew = new T.movable_area_next_type (T)

			tnew.movable_area_prev_type = oldtype

		for(var/turf/T in discardedturfs)
			if(!isturf(T)) continue
			if(T.movable_area_prev_type != null)
				new T.movable_area_prev_type (T)
			else
				new/turf/space(T)

		for(var/atom/movable/A in objects_to_move)
			A.animate_movement = 0
			A.set_loc(get_step(A.loc, direction))

		moving = 0

/proc/infestation_custom()
	var/turf/T = get_turf(usr)
	var/typepathstr = input(usr, "Typepath:")
	var/num_spread = input(usr, "Max spreads (-1 for infinite):") as num
	var/num_delay = input(usr, "Delay between spread in sec:") as num
	var/num_gens = input(usr, "Max Generations per spawn (-1 for infinite):") as num
	var/typepath = text2path(typepathstr)

	if(!ispath(typepath)) return

	var/atom/A = new typepath (T)

	var/list/active_spread = new/list()

	active_spread += A
	active_spread[A] = num_gens

	spawn(0)
		while(num_spread > 0 || num_spread == -1)
			for(var/atom/curr in active_spread)
				var/can_spread = null
				for(var/dir in cardinal)
					var/atom/next = get_turf(get_step(curr,dir))
					if(is_free(next) && !istype(next, typepath) && !locate(typepath) in next)
						can_spread = next
				if(can_spread == null)
					if(active_spread[curr] > 0 || active_spread[curr] == -1)
						if(active_spread[curr] > 0) active_spread[curr]--
					else
						active_spread -= curr
				else
					var/atom/newspawn = new typepath (can_spread)
					active_spread += newspawn
					active_spread[newspawn] = num_gens
			sleep(10 * num_delay)
			if(num_spread > 0) num_spread--


/proc/is_free(var/atom/A)
	if(!A) return
	if(A.density) return 0
	for(var/atom/curr in A)
		if(curr.density) return 0
	if(istype(A, /turf/space)) return 0
	return 1

/obj/dfissure_to
	name = "dimensional fissure"
	desc = "a rip in time and space"
	opacity = 0
	density = 1
	anchored = 1
	icon = 'icons/effects/3dimension.dmi'
	icon_state = "fissure"

	Bumped(atom/movable/AM)
		var/area/srcar = AM.loc.loc
		srcar.Exited(AM)

		var/obj/source = locate(/obj/dfissure_from)
		if (!istype(source))
			qdel(src)
			return
		var/turf/trg = source.loc

		var/area/trgar = trg.loc
		trgar.Entered(AM, AM.loc)

		AM.set_loc(trg)

/obj/dfissure_from
	name = "dimensional fissure"
	desc = "a rip in time and space"
	opacity = 0
	density = 1
	anchored = 1
	icon = 'icons/effects/3dimension.dmi'
	icon_state = "fissure"

	Bumped(atom/movable/AM)
		var/area/srcar = AM.loc.loc
		srcar.Exited(AM)

		var/obj/source = locate(/obj/dfissure_to)
		if (!istype(source))
			qdel(src)
			return
		var/turf/trg = source.loc

		var/area/trgar = trg.loc
		trgar.Entered(AM, AM.loc)

		AM.set_loc(trg)

/turf/unsimulated/wall/void
	name = "dense void"
	icon = 'icons/turf/floors.dmi'
	icon_state = "darkvoid"
	desc = "It seems solid..."
	opacity = 1
	density = 1

/turf/unsimulated/floor/void
	name = "void"
	icon = 'icons/turf/floors.dmi'
	icon_state = "void"
	desc = "A strange shifting void ..."

/turf/simulated/wall/void
	name = "dense void"
	icon = 'icons/turf/floors.dmi'
	icon_state = "darkvoid"
	desc = "It seems solid..."
	opacity = 1
	density = 1

	ex_act()
		return

	ex_act(severity)
		return

	blob_act(var/power)
		return

	attack_hand(mob/user as mob)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return


/turf/simulated/floor/void
	name = "void"
	icon = 'icons/turf/floors.dmi'
	icon_state = "void"
	desc = "A strange shifting void ..."

	ex_act()
		return

	ex_act(severity)
		return

	blob_act(var/power)
		return

	attack_hand(mob/user as mob)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return

/area/otherdimesion
	requires_power = 0
	luminosity = 1
	RL_Lighting = 0
	name = "Somewhere"
	icon_state = "shuttle2"

/area/crunch
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/voidambi.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 60
		S.priority = 255
		S.status = SOUND_UPDATE
		spawn(10) process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		var/sound/S = null
		var/sound_delay = 0
		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)
			if (ticker.current_state == GAME_STATE_PLAYING)
				if(prob(10))
					S = sound(file=pick('sound/ambience/voidfx1.ogg','sound/ambience/voidfx2.ogg','sound/ambience/voidfx3.ogg','sound/ambience/voidfx4.ogg'), volume=100)
					sound_delay = rand(0, 50)
				else
					S = null
					continue

				for(var/mob/living/carbon/human/H in src)
					if(H.client)
						mysound.status = SOUND_UPDATE
						H << mysound
						if(S)
							spawn(sound_delay)
								H << S

/proc/zombies()
	var/list/eligible = new/list()

	for(var/mob/living/carbon/human/H in mobs)
		if(H.z == 1 && H.stat != 2 && H.client)
			eligible.Add(H)

	var/mob/living/carbon/human/picked1
	if(eligible.len > 0)
		picked1 = pick(eligible)
		eligible -= picked1

	var/mob/living/carbon/human/picked2
	if(eligible.len > 0)
		picked2 = pick(eligible)

	if(picked1)
		picked1.zombify()

	if(picked2)
		picked2.zombify()

	for(var/turf/T in wormholeturfs)
		if(prob(3))
			new/obj/item/plank(T)
			new/obj/item/plank(T)
		else if(prob(1) && prob(40))
			new/obj/item/gun/kinetic/spacker(T)
			new/obj/item/ammo/bullets/a12(T)
			new/obj/item/ammo/bullets/a12(T)

		else if(prob(1) && prob(40))
			new/obj/item/gun/kinetic/flaregun(T)
			new/obj/item/ammo/bullets/flare(T)
			new/obj/item/ammo/bullets/flare(T)

/mob/living/carbon/human/proc/zombify()
	var/datum/ailment_data/disease/ZOM = contract_disease(/datum/ailment/disease/necrotic_degeneration, null, null, 1)
	if (!istype(ZOM,/datum/ailment/disease/))
		return
	ZOM.stage = 5
	boutput(src, "<span style=\"color:red\">########################################</span>")
	boutput(src, "<span style=\"color:red\">You have turned into a zombie.</span>")
	boutput(src, "<span style=\"color:red\">To infect other players, you must knock</span>")
	boutput(src, "<span style=\"color:red\">them down and then attack them with your</span>")
	boutput(src, "<span style=\"color:red\">bare hands and the harm intent.</span>")
	boutput(src, "<span style=\"color:red\">########################################</span>")

/obj/item/boomerang
	name = "Boomerang"
	desc = "A Boomerang."
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	item_state = "boomerang"

	density = 0
	opacity = 0
	anchored = 1

	icon = 'icons/obj/weapons.dmi'
	icon_state = "boomerang"
	item_state = "boomerang"

	//throwforce = 10
	throw_range = 10
	throw_speed = 1
	throw_return = 1

	var/prob_clonk = 0

	throw_begin(atom/target)
		icon_state = "boomerang1"
		playsound(src.loc, "rustle", 50, 1)
		return ..(target)

	throw_impact(atom/hit_atom)
		icon_state = "boomerang"
		if(hit_atom == usr)
			if(prob(prob_clonk))
				var/mob/living/carbon/human/user = usr
				user.visible_message("<span style=\"color:red\"><B>[user] fumbles the catch and is clonked on the head!</B></span>")
				playsound(user.loc, 'sound/effects/fleshbr1.ogg', 50, 1)
				user.stunned += 5
				user.weakened += 3
				user.paralysis += 2
			else
				src.attack_hand(usr)
			return
		else
			if(ishuman(hit_atom))
				var/mob/living/carbon/human/user = usr
				var/safari = (istype(user.w_uniform, /obj/item/clothing/under/gimmick/safari) && istype(user.head, /obj/item/clothing/head/safari))
				if(safari)
					var/mob/living/carbon/human/H = hit_atom
					H.stunned+=4
					H.weakened+=2
					//H.paralysis++
					playsound(H.loc, "swing_hit", 50, 1)

				prob_clonk = min(prob_clonk + 5, 40)
				spawn(20)
					prob_clonk = max(prob_clonk - 5, 0)

		return ..(hit_atom)

/proc/mod_color(var/atom/A)
	set category = null
	set name = "Modify Icon"
	set popup_menu = 0
	var/list/options = list("Tint", "Invert Colors", "Change Alpha")
	var/input = input(usr,"Select mode:","Mode") in options
	switch(input)
		if("Tint")
			var/r = input(usr,"Enter Value:","RED") as num
			if (!r)
				return

			var/g = input(usr,"Enter Value:","GREEN") as num
			if (!g)
				return

			var/b = input(usr,"Enter Value:","BLUE") as num
			if (!b)
				return

			A.color = rgb(r,g,b)

		if("Invert Colors")
			var/icon/newicon = icon(A.icon)
			newicon.MapColors(-1,0,0, 0,-1,0, 0,0,-1, 1,1,1)
			A.icon = newicon

		if( "Change Alpha")
			var/a = input(usr,"Enter Value:","ALPHA (multiplicative 0-255)") as num
			if (a)
				A.alpha = a

/verb/create_portal(var/turf/T as turf in world)
	set category = null
	set name = "Create Portal Here"
	var/obj/perm_portal/P = null
	switch(alert("Target selection type:",,"By reference","To turf"))
		if("By reference")
			var/input = input(usr,"Select Target:","Target") in world
			if(!input) return
			P = new/obj/perm_portal(T)
			P.target = input
		if("To turf")
			alert("Please move to the target location and then press OK.")
			var/atom/trg = get_turf(usr)
			if(trg)
				P = new/obj/perm_portal(T)
				P.target = trg

/obj/perm_portal
	icon = 'icons/misc/old_or_unused.dmi'
	icon_state = "portal1"
	anchored = 1
	density = 1
	opacity = 0
	var/atom/target = null
	var/target_tag = null
	var/datum/light/light

	New()
		..()
		light = new /datum/light/point
		light.set_color(0.3, 0.6, 0.8)
		light.set_brightness(0.5)
		light.attach(src)
		light.enable()
		spawn(6)
			if (target_tag)
				target = locate(target_tag)

	Bumped(atom/movable/AM)
		if(target && istype(target))
			AM.set_loc(get_turf(target))


////////////////////////////////////////////////////////////////////////////////////////
/* var/list/raisinlist = new/list()

/proc/for_no_raisin(var/mob/M, text)
	if(findtext(text,"for no raisin"))
		if(M.client)
			if(!(M.client in raisinlist) && istype(M,/mob/living))
				boutput(M, "<span style=\"color:red\">A raisin mysteriously materializes right next to your feet...</span>")
				new/obj/item/reagent_containers/food/snacks/raisin(get_turf(M))
				raisinlist += M.client
	return

/obj/item/reagent_containers/food/snacks/raisin
	name = "raisin"
	desc = "A single raisin..."
	icon_state = "raisin"
	amount = 1
	heal_amt = 5

	attack(mob/M as mob, mob/user as mob, def_zone)
		if(istype(M, /mob/living/carbon/human))
			if(M == user)
				M.nutrition += src.heal_amt * 10
				M.poo += 1
				src.heal(M)
				playsound(M.loc,"sound/items/eatfood.ogg", rand(10,50), 1)
				boutput(user, "<span style=\"color:red\">You eat the raisin and shed a single tear as you realise that you now have no raisin.</span>")
				qdel(src)
				return 1
			else
				for(var/mob/O in viewers(world.view, user))
					O.show_message("<span style=\"color:red\">[user] attempts to feed [M] [src].</span>", 1)
				if(!do_mob(user, M)) return
				for(var/mob/O in viewers(world.view, user))
					O.show_message("<span style=\"color:red\">[user] feeds [M] [src].</span>", 1)
				src.amount--
				M.nutrition += src.heal_amt * 10
				M.poo += 1
				src.heal(M)
				playsound(M.loc, "sound/items/eatfood.ogg", rand(10,50), 1)
				boutput(user, "<span style=\"color:red\">[M] eats the raisin.</span>")
				qdel(src)
				return 1
		return 0 */

/obj/fire_foam
	name = "Fire fighting foam"
	desc = "It's foam."
	opacity = 0
	density = 0
	anchored = 1
	icon = 'icons/effects/fire.dmi'
	icon_state = "foam"
	animate_movement = SLIDE_STEPS
	mouse_opacity = 0
	var/my_dir=1

	Move(NewLoc,Dir=0)
		..(NewLoc,Dir)
		src.dir = my_dir

	unpooled(var/poolname)
		..()
		spawn(1)
			var/atom/myloc = loc
			if(myloc && !istype(myloc,/turf/space))
				my_dir = pick(alldirs)
				src.dir = my_dir

/obj/shifting_wall
	name = "r wall"
	desc = ""
	opacity = 1
	density = 1
	anchored = 1

	icon = 'icons/turf/walls.dmi'
	icon_state = "r_wall"

	New()
		update()

	proc/update()
		var/list/possible = new/list()

		for(var/A in cardinal)
			var/turf/current = get_step(src,A)
			if(current.density) continue
			if(is_blocked_turf(current)) continue
			possible +=  current

		if(!possible.len)
			spawn(30) update()
			return

		var/turf/picked = pick(possible)
		if(src.loc.invisibility) src.loc.invisibility = 0
		src.set_loc(picked)
		spawn(5) picked.invisibility = 100

		spawn(rand(50,80)) update()

/obj/shifting_wall/sneaky

	var/sightrange = 8
	pixel_step_size = 7

	proc/find_suitable_tiles()
		var/list/possible = new/list()

		for(var/A in cardinal)
			var/turf/current = get_step(src,A)
			if(current.density) continue
			if(is_blocked_turf(current)) continue
			if(someone_can_see(current)) continue
			possible +=  current

		return possible

	proc/someone_can_see(var/atom/A)
		for(var/mob/living/L in view(sightrange,A))
			if(!L.sight_check(1)) continue
			if(A in view(sightrange,L)) return 1
		return 0

	proc/someone_can_see_me()
		for(var/mob/living/L in view(sightrange,src))
			if(L.sight_check(1)) continue
			if(src in view(sightrange,L)) return 1
		return 0

	update()
		if(someone_can_see_me()) //Award for the most readable code GOES TO THIS LINE.
			spawn(rand(50,80)) update()
			return

		var/list/possible = find_suitable_tiles()

		if(!possible.len)
			spawn(30) update()
			return

		var/turf/picked = pick(possible)
		if(src.loc.invisibility) src.loc.invisibility = 0
		if(src.loc.opacity) src.loc.opacity = 0

		src.set_loc(picked)

		spawn(5)
			picked.invisibility = 100
			picked.opacity = 1

		spawn(rand(50,80)) update()


/obj/pool
	name = "pool"
	density = 1
	anchored = 1
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pool"

/obj/pool_springboard
	name = "springboard"
	density = 0
	anchored = 1
	layer = EFFECTS_LAYER_UNDER_2
	pixel_x = -16
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "springboard"
	var/in_use = 0
	var/suiciding = 0
	var/deadly = 0

	attackby(obj/item/W as obj, mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		if(in_use)
			boutput(user, "<span style=\"color:red\">Its already in use - wait a bit.</span>")
			return
		else
			in_use = 1
			user.transforming = 1
			var/range = pick(25;1,2,3)
			var/turf/target = src.loc
			for(var/i = 0, i<range, i++)
				if(!suiciding && !deadly) target = get_step(target,WEST)
				else target = get_step(target,EAST)
			if(!suiciding && !deadly) user.dir = WEST
			else user.dir = EAST
			user.pixel_y = 15
			user.layer = EFFECTS_LAYER_UNDER_1
			user.set_loc(src.loc)
			sleep(3)
			user.pixel_x = -3
			sleep(3)
			user.pixel_x = -6
			sleep(3)
			user.pixel_x = -9
			sleep(3)
			user.pixel_x = -12
			playsound(user, "sound/effects/spring.ogg", 60, 1)
			sleep(3)
			user.pixel_y = 25
			sleep(5)
			user.pixel_y = 15
			playsound(user, "sound/effects/spring.ogg", 60, 1)
			sleep(5)
			user.pixel_y = 25
			sleep(5)
			user.pixel_y = 15
			playsound(user, "sound/effects/spring.ogg", 60, 1)
			sleep(5)
			user.pixel_y = 25
			playsound(user, "sound/effects/brrp.ogg", 15, 1)
			sleep(2)
			if(range == 1) boutput(user, "<span style=\"color:red\">You slip...</span>")
			user.layer = MOB_LAYER
			user.throw_at(target, 5, 1)
			user:weakened += 2
			if(suiciding || deadly)
				src.visible_message("<span style=\"color:red\"><b>[user.name] dives headfirst at the [target.name]!</b></span>")
				spawn(3) //give them time to land
					user.TakeDamage("head", 200, 0)
					user.updatehealth()
					playsound(src.loc, "sound/effects/snap.ogg", 50, 1)
			user.pixel_y = 0
			user.pixel_x = 0
			playsound(user, "sound/effects/splash.ogg", 60, 1)
			in_use = 0
			suiciding = 0
			user.transforming = 0

	suicide(var/mob/user as mob)
		if(in_use) return 0
		suiciding = 1 //reset in attack_hand() at the same time as in_use
		attack_hand(user)

		spawn(100)
			if (src)
				src.suiciding = 0
		return 1

//1.5 would be 50% slower, 2.0 would be 100% slower etc.
var/const/lag_average_size = 20			 //Number of samples the average is based on.

var/lag_string = "Yes"//"none"

var/average_tenth = 1
var/list/lag_list = new/list()

/proc/add_and_average(var/value)
	lag_list.Insert(1,value)
	if(lag_list.len > lag_average_size) lag_list.Cut(lag_average_size+1,0)
	var/tempnum = 0
	for(var/a in lag_list)
		tempnum += a
	if(lag_list.len >= lag_average_size) average_tenth = (tempnum / lag_list.len)

	switch( ((average_tenth * world.cpu) / 100) )
		if(0 to 0.100)
			lag_string = "Minimal"
		if(0.101 to 0.180)
			lag_string = "Normal"
		if(0.181 to 0.350)
			lag_string = "High"
		if(0.351 to 0.500)
			lag_string = "Very High"
		if(0.501 to INFINITY)
			lag_string = "Oh Sh*t"

/proc/lag_loop()
	var/before = world.timeofday
	sleep(1)
	add_and_average( (world.timeofday - before) )
	spawn(5) lag_loop()

/proc/get_lag_average()
	boutput(usr, "<span style=\"color:green\">[average_tenth] at [lag_list.len] samples.</span>")


/obj/mirror
	//Expect those to be laggy as fuck.
	name = "Mirror"
	desc = "Its a mirror."
	density = 0
	anchored = 1
	pixel_y = 32
	var/icon/base
	var/broken = 0
	var/health = 3
	var/list/spooky = new/list()
	var/spooked = 0
	var/spooking = 0

	proc/hear_once(var/mob/M)
		if(broken) return
		if(!M in spooky)
			spooky += M
			spooky[M] = 1
		else
			spooky[M]++
		if(spooky[M] >= 3)
			do_it(M)

	proc/do_it(var/mob/M)
		if(spooking || broken) return
		spooking = 1
		break_it()
		playsound(src, "sound/effects/Glassbr3.ogg", 75, 0)
		M:transforming = 1
		sleep(30)
		var/obj/screen/creepy = new /obj/screen()
		creepy.name = "GARHLGHARLHGARHGL"
		creepy.icon = icon('icons/creepy.png')
		creepy.screen_loc = "SOUTH,WEST"
		creepy.mouse_opacity = 0
		if(!M) return
		var/client/the_client = M.client
		creepy.add_to_client(the_client)
		playsound(src, "sound/effects/ghost2.ogg", 100, 0)
		sleep(5)
		if(!M)
			the_client.screen -= creepy
			return
		M:gib()
		sleep(5)
		the_client.screen -= creepy
		sleep(30)

	New()
		build_base()
		update()

	HasEntered(atom/A)
		if(ismob(A)) rebuild_icon()
		return

	attackby(obj/item/W as obj, mob/user as mob)
		..()

		if(W.force <= 1 || broken)
			playsound(src, "sound/weapons/Genhit.ogg", 25, 0)
			return

		health--
		if(health <= 0)
			break_it()
			boutput(user, "<span style=\"color:red\">You break the mirror ...</span>")
			playsound(src, "sound/effects/Glassbr3.ogg", 75, 0)
		else
			playsound(src, "sound/effects/Glasshit.ogg", 75, 0)

	ex_act()
		playsound(src, "sound/effects/Glassbr3.ogg", 75, 0)
		break_it()

	hitby(atom/movable/AM as mob|obj)
		playsound(src, "sound/effects/Glassbr3.ogg", 75, 0)
		break_it()

	proc

		break_it()
			if(broken) return
			broken = 1
			build_base()
			rebuild_icon()
			new /obj/item/raw_material/shard/glass( src.loc )
			new /obj/item/raw_material/shard/plasmacrystal( src.loc )

		build_base()
			var/turf/T = src.loc
			var/icon/composite = icon(T.icon, T.icon_state, T.dir)
			composite.Flip(NORTH)
			composite.Blend(icon('icons/misc/old_or_unused.dmi', "mirror"), ICON_OVERLAY)
			if(broken) composite.Blend(icon('icons/misc/old_or_unused.dmi', "mirror_broken"), ICON_OVERLAY)
			composite.Crop(7,8,26,31)
			composite.Crop(1,1,32,32)
			composite.Shift(NORTH,7)
			composite.Shift(EAST,6)
			base = composite

		rebuild_icon()

			src.icon = base
			pixel_y = 0
			var/turf/T = src.loc
			var/icon/composite = icon(T.icon, T.icon_state, T.dir)
			composite.Flip(NORTH)
			var/the_dir

			for(var/atom/C in T)
				var/icon/curr

				if(hasvar(C, "body_standing"))
					if(!C:lying)
						if(C.dir == NORTH || C.dir == SOUTH)
							the_dir = turn(C.dir,180)
							curr = icon(C:body_standing, dir=turn(C.dir,180))
						else
							the_dir = C.dir
							curr = icon(C:body_standing, dir=C.dir)
					else
						continue
				else
					if(C.dir == NORTH || C.dir == SOUTH)
						the_dir = turn(C.dir,180)
						curr = icon(C.icon, C.icon_state, turn(C.dir,180))
					else
						the_dir = C.dir
						curr = icon(C.icon, C.icon_state, C.dir)

				if(!curr || C.invisibility) continue

				composite.Blend(curr, ICON_OVERLAY)

				for(var/O in C.overlays)
					var/image/I = O
					var/icon/II = icon(I.icon, I.icon_state, the_dir)
					composite.Blend(II, ICON_OVERLAY)

			composite.Blend(icon('icons/misc/old_or_unused.dmi', "mirror"), ICON_OVERLAY)
			if(broken) composite.Blend(icon('icons/misc/old_or_unused.dmi', "mirror_broken"), ICON_OVERLAY)
			composite.Crop(7,8,26,31)
			composite.Crop(1,1,32,32) //UNCROP - http://www.youtube.com/watch?v=KUFkb0d1kbU
			composite.Shift(NORTH,7)
			composite.Shift(EAST,6)

			src.icon = composite
			pixel_y = 32

		update()
			rebuild_icon()
			spawn(5) update()

/obj/spook
	var/active = 0
	invisibility = 100
	anchored = 1
	density = 0
	icon = 'icons/misc/hstation.dmi'
	icon_state = "null"
	desc = "What ... what is this?"
	name = "apparition"
	var/turf/startloc

	New()
		startloc = get_turf(src)
		loop()
		return ..()

	proc/loop()

		if(active)
			spawn(30) loop()
			return


		for(var/mob/living/L in hearers(world.view, src))
			if(prob(20)) spook(L)
			break

		spawn(20) loop()

	proc/spook(var/mob/living/L)
		if (narrator_mode)
			playsound(L, 'sound/vox/ghost.ogg', 75, 0)
		else
			playsound(L, 'sound/effects/ghost.ogg', 75, 0)
		sleep(3)
		active = 1
		walk_towards(src,L,3)
		src.invisibility = 0
		flick("apparition",src)
		sleep(15)
		src.invisibility = 100
		src.set_loc(startloc)
		walk(src,0)
		spawn(100) active = 0


/datum/engibox_mode
	var/name = ""
	var/desc = ""
	var/requires_input = 0
	var/saved_var = null
	proc/used(atom/user, atom/target)
		return

/datum/engibox_mode/spawmmetal
	name = "Spawn 100 Metal"
	desc = "Spawns 100 Metal sheets."
	used(atom/user, atom/target)
		var/obj/item/sheet/steel/M = new/obj/item/sheet/steel(get_turf(target))
		M.amount = 100
		return

/datum/engibox_mode/spawmglass
	name = "Spawn 100 Glass"
	desc = "Spawns 100 Metal sheets."
	used(atom/user, atom/target)
		var/obj/item/sheet/glass/M = new/obj/item/sheet/glass(get_turf(target))
		M.amount = 100
		return

/datum/engibox_mode/spawmtool
	name = "Spawn Toolbox"
	desc = "Spawns a Toolbox."
	used(atom/user, atom/target)
		new/obj/item/storage/toolbox/mechanical(get_turf(target))
		return

/datum/engibox_mode/construct
	name = "Construct"
	desc = "Construct walls and floor."
	used(atom/user, atom/target)
		if(istype(target, /turf/space))
			target:ReplaceWithFloor()
			return
		if(istype(target, /turf/simulated/floor))
			target:ReplaceWithWall()
			return
		if(istype(target, /turf/simulated/wall))
			target:ReplaceWithRWall()
			return
		return

/datum/engibox_mode/deconstruct
	name = "Deconstruct"
	desc = "Deconstruct walls and floor."
	used(atom/user, atom/target)
		if(istype(target, /turf/simulated/floor))
			target:ReplaceWithSpace()
			return
		if(istype(target, /turf/simulated/wall))
			target:ReplaceWithFloor()
			return
		return

/datum/engibox_mode/remove
	name = "Remove Objects"
	desc = "Removes Objects you placed."
	used(atom/user, atom/target)
		if(isobj(target)) qdel(target)
		return

/datum/engibox_mode/setid
	name = "Link Objects"
	desc = "Allows you to link buttons & machines by setting their group-id. Objects need to be in the same group to affect each other (i.e. a door and a button)."
	requires_input = 1
	used(atom/user, atom/target)
		if(hasvar(target,"id"))
			target:id = saved_var
			boutput(usr, "<span style=\"color:blue\">Done.</span>")
		else
			boutput(usr, "<span style=\"color:red\">Not a linkabled object.</span>")
		return

/datum/engibox_mode/reqacc
	name = "Set Required Access"
	desc = "Allows you to set the required Access-level of most objects."
	used(atom/user, atom/target)
		if(istype(target, /obj/machinery/door))
			if(hasvar(target, "req_access"))
				target:req_access = get_access(input(usr) in get_all_jobs() + "Club member")
				boutput(usr, "<span style=\"color:blue\">Done.</span>")
			else
				boutput(usr, "<span style=\"color:red\">Invalid object.</span>")
		return

/datum/engibox_mode/spawnid
	name = "Spawn ID card"
	desc = "Allows you to spawn an id card with a certain access level."
	used(atom/user, atom/target)
		var/obj/item/card/id/blank_deluxe/D = new/obj/item/card/id/blank_deluxe(get_turf(target))
		D.access = get_access(input(usr) in get_all_jobs() + "Club member")
		return

/datum/engibox_mode/fwall
	name = "Construct False Wall"
	desc = "Construct a False Wall."
	used(atom/user, atom/target)
		var/turf/targ = get_turf(target)
		new/turf/simulated/wall/false_wall(targ)
		return

/datum/engibox_mode/airlock
	name = "Place Airlock"
	desc = "Places an Airlock."
	used(atom/user, atom/target)
		new/obj/machinery/door/airlock(get_turf(target))
		return

/datum/engibox_mode/airlockglass
	name = "Place glass Airlock"
	desc = "Places a glass Airlock."
	used(atom/user, atom/target)
		new/obj/machinery/door/airlock/glass(get_turf(target))
		return

/datum/engibox_mode/light
	name = "Place Light"
	desc = "Places a Light - facing the direction you are facing."
	used(atom/user, atom/target)
		var/obj/machinery/light/small/L = new/obj/machinery/light/small(get_turf(target))
		L.dir = user:dir
		L.on = 1
		L.update()
		return

/datum/engibox_mode/buttonpod
	name = "Place Button"
	desc = "Places a Button that can control mass-drivers & pod-doors."
	used(atom/user, atom/target)
		var/obj/machinery/driver_button/L = new/obj/machinery/driver_button(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/buttonconvey
	name = "Place Conveyor switch"
	desc = "Places a Conveyor switch that can control a conveyor belt."
	used(atom/user, atom/target)
		var/obj/machinery/conveyor_switch/L = new/obj/machinery/conveyor_switch(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/conveyor
	name = "Place Conveyor belt"
	desc = "Places a Conveyor belt - facing the direction you are facing."
	used(atom/user, atom/target)
		var/obj/machinery/conveyor/L = new/obj/machinery/conveyor(get_turf(target))
		L.dir = user:dir
		L.basedir = L.dir
		return

/datum/engibox_mode/poddoor
	name = "Place Pod-Door"
	desc = "Places a Pod-Door."
	used(atom/user, atom/target)
		var/obj/machinery/door/poddoor/L = new/obj/machinery/door/poddoor(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/driver
	name = "Place Mass-Driver"
	desc = "Places a Mass-Driver - facing the direction you are facing."
	used(atom/user, atom/target)
		var/obj/machinery/mass_driver/L = new/obj/machinery/mass_driver(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/cam
	name = "Place Security Camera"
	desc = "Places a Security Camera - using your direction."
	used(atom/user, atom/target)
		var/obj/machinery/camera/L = new/obj/machinery/camera(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/window
	name = "Place Window"
	desc = "Places a reinforced window."
	used(atom/user, atom/target)
		if (map_setting && map_setting == "COG2")
			new /obj/window/auto/reinforced(get_turf(target))
		else
			new /obj/window/reinforced(get_turf(target))
		return

/datum/engibox_mode/grille
	name = "Place Grille"
	desc = "Places a Grille."
	used(atom/user, atom/target)
		var/obj/grille/L = new/obj/grille(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/table
	name = "Place Reinforced Table"
	desc = "Places a Reinforced Table."
	used(atom/user, atom/target)
		var/obj/table/reinforced/L = new/obj/table/reinforced(get_turf(target))
		L.dir = user:dir
		return

/datum/engibox_mode/paint
	name = "Spawn paint can"
	desc = "Spawn a paint can."
	used(atom/user, atom/target)
		var/paint_color = null
		var/col_new = F_Color_Selector.Get_Color(user, paint_color)
		if(col_new)
			var/obj/item/paint_can/P = new/obj/item/paint_can(get_turf(target))
			P.paint_color = col_new
			paint_color = col_new
			P.generate_icon()
			P.uses = 9999
		return

/datum/engibox_mode/replicate
	name = "Replicate Object"
	desc = "Allows you to replicate objects. First use selects Object to clone, further clicks place copies. Un- or Re-select mode to clear set object."
	var/obj_path = null
	used(atom/user, atom/target)
		if(obj_path)
			var/atom/A = new obj_path(get_turf(target))
			boutput(usr, "<span style=\"color:blue\">Placed: [A.name]</span>")
		else
			obj_path = target.type
			boutput(usr, "<span style=\"color:blue\">Now replicating: [target.name]s</span>")
		return

/datum/engibox_mode/transmute
	name = "Change material"
	desc = "Changes the material of the targeted object."
	var/mat_id = "gold"
	used(atom/user, atom/target)
		target.setMaterial(getCachedMaterial(mat_id))
		return

/datum/engibox_mode/density
	name = "Toggle density"
	desc = "Toggles the density of an object."
	used(atom/user, atom/target)
		target.density = !target.density
		boutput(usr, "<span style=\"color:blue\">Target density now: [target.density]</span>")
		return

/datum/engibox_mode/opacity
	name = "Toggle opacity"
	desc = "Toggles the opacity of an object."
	used(atom/user, atom/target)
		target.opacity = !target.opacity
		boutput(usr, "<span style=\"color:blue\">Target opacity now: [target.opacity]</span>")
		return

/obj/item/engibox
	name = "Engineer-in-a-box"
	desc = "The concentrated power of a whole team of engineers. In a box."
	icon = 'icons/obj/storage.dmi'
	icon_state = "engi"
	var/list/modes = new/list()
	var/datum/engibox_mode/active_mode = null
	var/ckey_lock = null
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 1.0
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(ckey_lock && usr.ckey != ckey_lock)
			boutput(user, "<span style=\"color:red\">You are not authorized to use this item.</span>")
			return
		if(get_dist(target,user) > 1)
			boutput(user, "<span style=\"color:red\">You are too far away.</span>")
			return
		if(target == loc) return
		if(active_mode)
			active_mode.used(user, target)
		return

	attack()
		return

	attack_self(mob/user as mob)
		if(ckey_lock && usr.ckey != ckey_lock)
			boutput(user, "<span style=\"color:red\">You are not authorized to use this item.</span>")
			return
		var/dat = "Engie-box modes:<BR><BR>"
		for(var/datum/engibox_mode/D in modes)
			dat += "<A href='?src=\ref[src];set_mode=\ref[D]'>[D.name]</A> [active_mode == D ? "<<<" : ""]<BR>"
			dat += "[D.desc]<BR><BR>"
		user << browse(dat, "window=engibox;can_minimize=0;can_resize=0;size=250x600")
		onclose(user, "window=engibox")
		return

	Topic(href, href_list)
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return
		usr.machine = src
		if (href_list["set_mode"])
			active_mode = locate(href_list["set_mode"])

			if(active_mode.requires_input)
				active_mode.saved_var = input(usr,"Enter ID","ID","MyId") as text
				if(!active_mode.saved_var || isnull(active_mode.saved_var)) active_mode = null

			if(istype(active_mode,/datum/engibox_mode/transmute)) //You only have yourself to blame for this. This shitty code is the fault of whoever changed this!!!
				active_mode:mat_id = input(usr,"Select material","material","gold") in list("gold", "steel", "mauxite", "pharosium","cobryl","bohrum","cerenkite","syreline","glass","molitz","claretine","erebite","plasmastone","plasmaglass","quartz","uqill","telecrystal","miraclium","starstone","flesh","char","koshmarite","viscerite","beeswax","latex","synthrubber","wendigohide","cotton","fibrilith")

			if(istype(active_mode,/datum/engibox_mode/replicate))
				active_mode:obj_path = null

			src.attack_self(usr)
			return
		src.attack_self(usr)
		src.add_fingerprint(usr)
		return

	New()
		for(var/D in typesof(/datum/engibox_mode) - /datum/engibox_mode)
			modes += new D


/obj/signpost
	icon = 'icons/misc/old_or_unused.dmi'
	icon_state = "signpost"
	anchored = 1
	density = 1

	attackby(obj/item/W as obj, mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		switch(alert("Travel back to ss13?",,"Yes","No"))
			if("Yes")
				user.loc.loc.Exited(user)
				user.set_loc(pick(latejoin))
			if("No")
				return

/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	RL_Lighting = 0
	requires_power = 0
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/shore.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		spawn(10) process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		..()
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		var/sound/S = null
		var/sound_delay = 0
		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)
			if (ticker.current_state == GAME_STATE_PLAYING)
				if(prob(10))
					S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
					sound_delay = rand(0, 50)
				else
					S = null
					continue

				for(var/mob/living/carbon/human/H in src)
					if(H.client)
						mysound.status = SOUND_UPDATE
						H << mysound
						if(S)
							spawn(sound_delay)
								H << S

/obj/item/beach_ball
	icon = 'icons/misc/beach.dmi'
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
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed)
