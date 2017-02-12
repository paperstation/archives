/turf/unsimulated/floor/cave
	name = "cave floor"
	icon_state = "cave-medium"
	RL_Ignore = 0

/turf/unsimulated/wall/cave
	name = "cave wall"
	icon_state = "cave-dark"
	RL_Ignore = 0

////// cogwerks - lava turf

/turf/unsimulated/floor/lava
	name = "Lava"
	desc = "The floor is lava. Oh no."
	icon_state = "lava"
	var/deadly = 1
	RL_Ignore = 0
	pathable = 0
	can_replace_with_stuff = 1

	Entered(atom/movable/O)
		..()
		if(src.deadly)
			if (istype(O, /obj/critter) && O:flying)
				return

			if (istype(O, /obj/projectile))
				return

			if (istype(O, /obj/overlay/tile_effect))
				return

			if (O.throwing && !istype(O, /mob/living))
				spawn(8)
					if (O && O.loc == src)
						melt_away(O)
				return

			melt_away(O)


	proc/melt_away(atom/movable/O)
		if (istype(O, /mob))
			if (istype(O, /mob/living))
				var/mob/living/M = O
				var/mob/living/carbon/human/H = M
				if (istype(H))
					H.unkillable = 0
				if(!M.stat) M.emote("scream")
				src.visible_message("<span style=\"color:red\"><B>[M]</B> falls into the [src] and melts away!</span>")
				M.firegib() // thanks ISN!
		else
			src.visible_message("<span style=\"color:red\"><B>[O]</B> falls into the [src] and melts away!</span>")
			qdel(O)

	ex_act(severity)
		return

/obj/decal/lightshaft
	name = "light"
	desc = "There's light coming through a hole in the ceiling."
	density = 0
	anchored = 1
	opacity = 0
	layer = NOLIGHT_EFFECTS_LAYER_BASE
	icon = 'icons/effects/64x64.dmi'
	icon_state = "lightshaft"
	luminosity = 2

/obj/decal/stalagtite
	name = "stalactite" // c, not g! c as in ceiling, g as in ground. dang!
	desc = "It's a stalactite."
	density = 0
	anchored = 1
	opacity = 0
	layer = EFFECTS_LAYER_BASE
	icon = 'icons/misc/exploration.dmi'
	icon_state = "stal1"

/obj/decal/stalagmite
	name = "stalagmite"
	desc = "It's a stalagmite."
	density = 1
	anchored = 1
	opacity = 0
	layer = EFFECTS_LAYER_BASE
	icon = 'icons/misc/exploration.dmi'
	icon_state = "stal2"

/obj/decal/snowbits
	name = "snow"
	desc = "A bit of snow."
	density = 0
	anchored = 1
	opacity = 0
	layer = OBJ_LAYER
	icon = 'icons/misc/exploration.dmi'
	icon_state = "snowbits"

/obj/decal/runemarks
	name = "runes"
	desc = "A set of dimly glowing runes is carved into the rock here."
	density = 0
	anchored = 1
	opacity = 0
	layer = OBJ_LAYER
	icon = 'icons/misc/exploration.dmi'
	icon_state = "runemarks"

/obj/decal/cliff
	name = "cliff"
	desc = "The edge of a cliff."
	density = 0
	anchored = 1
	opacity = 0
	layer = OBJ_LAYER
	icon = 'icons/misc/exploration.dmi'
	icon_state = "cliff"

/obj/decal/statue
	name = "statue"
	desc = "A statue of some humanoid being."
	density = 1
	anchored = 1
	opacity = 0
	layer = OBJ_LAYER
	icon = 'icons/misc/exploration.dmi'
	icon_state = "stat1"

/obj/decal/statue/monkey1
	desc = "A statue of a monkey of some sort."
	icon_state = "stat2"

/obj/decal/statue/monkey2
	desc = "A statue of a monkey of some sort."
	icon_state = "stat3"

/obj/decal/statue/monkey3
	desc = "A statue of a monkey of some sort."
	icon_state = "stat4"

/obj/decal/woodclutter
	name = "pieces of wood"
	desc = "Theres bits and pieces of wood all over the place."
	density = 0
	anchored = 1
	opacity = 0
	layer = OBJ_LAYER
	icon = 'icons/misc/exploration.dmi'
	icon_state = "woodclutter4"

/obj/decal/mushrooms
	name = "mushroom"
	desc = "Some sort of mushroom."
	density = 0
	anchored = 1
	opacity = 0
	layer = OBJ_LAYER
	icon = 'icons/misc/exploration.dmi'
	icon_state = "mushroom7"

/obj/decal/mushrooms/type1
	icon_state = "mushroom1"

/obj/decal/mushrooms/type2
	icon_state = "mushroom2"

/obj/decal/mushrooms/type3
	icon_state = "mushroom3"

/obj/decal/mushrooms/type4
	icon_state = "mushroom4"

/obj/decal/mushrooms/type5
	icon_state = "mushroom5"

/obj/decal/mushrooms/type6
	icon_state = "mushroom6"

/obj/decal/mushrooms/type7
	icon_state = "mushroom7"

/obj/shifting_wall/sneaky/cave
	name = "strange wall"
	desc = "This wall seems strangely out-of-place."
	icon_state = "cave-dark"
	icon = 'icons/turf/walls.dmi'

	var/active = 0

	proc/do_move(var/direction)
		if(active) return
		var/turf/tile = get_step(src,direction)
		if(tile.density) return
		if(is_blocked_turf(tile)) return
		if(locate(/obj/decal/runemarks) in tile) return

		active = 1

		if(src.loc.invisibility) src.loc.invisibility = 0
		if(src.loc.opacity) src.loc.opacity = 0

		src.set_loc(tile)

		spawn(5)
			tile.invisibility = 100
			tile.opacity = 1
			active = 0

	find_suitable_tiles()
		var/list/possible = new/list()

		for(var/A in cardinal)
			var/turf/current = get_step(src,A)
			if(current.density) continue
			if(is_blocked_turf(current)) continue
			if(someone_can_see(current)) continue
			if(locate(/obj/decal/runemarks) in current) continue
			possible +=  current

		return possible

	update()
		if(active) return
		if(someone_can_see_me())
			spawn(rand(50,80)) update()
			return

		var/list/possible = find_suitable_tiles()

		if(!possible.len)
			spawn(30) update()
			return

		active = 1
		if(prob(25)) // don't let all of them spam the noise at once
			spawn(rand(1,10))
				playsound(src.loc, 'sound/effects/rockscrape.ogg', 40, 1)

		var/turf/picked = pick(possible)
		if(src.loc.invisibility) src.loc.invisibility = 0
		if(src.loc.opacity) src.loc.opacity = 0

		src.set_loc(picked)

		spawn(5)
			picked.invisibility = 100
			picked.opacity = 1
			active = 0

		//spawn(rand(100,200)) update() // raised delay

/obj/line_obj/whip
	name = "Whip"
	desc = ""
	anchored = 1
	density = 0
	opacity = 0

/obj/whip_trg_dummy
	name = ""
	desc = ""
	anchored = 1
	density = 0
	opacity = 0
	invisibility = 99

/obj/item/whip
	name = "whip"
	desc = "a sturdy whip."
	icon = 'icons/misc/exploration.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	icon_state = "whip"
	item_state = "c_tube"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 2.0

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		if(target == usr) return

		if(get_dist(usr, target) > 5)
			boutput(usr, "<span style=\"color:red\">That is too far away!</span>")
			return

		var/atom/target_r = target

		if(isturf(target))
			target_r = new/obj/whip_trg_dummy(target)

		playsound(src, 'sound/effects/snap.ogg', 40, 1)

		var/list/affected = DrawLine(src.loc, target_r, /obj/line_obj/whip ,'icons/obj/projectiles.dmi',"WholeWhip",1,1,"HalfStartWhip","HalfEndWhip",OBJ_LAYER,1)

		for(var/obj/O in affected)
			O.anchored = 1 //Proc wont spawn the right object type so lets do that here.
			O.name = "Whip"

			var/turf/T = O.loc

			if(locate(/obj/decal/stalagmite) in T)
				boutput(usr, "<span style=\"color:red\">You pull yourself to the stalagmite using the whip.</span>")
				usr.set_loc(T)
			else if(locate(/obj/decal/stalagtite) in T)
				boutput(usr, "<span style=\"color:red\">You pull yourself to the stalagtite using the whip.</span>")
				usr.set_loc(T)

			spawn(2) pool(O)

		if(istype(target_r, /obj/whip_trg_dummy)) qdel(target_r)

		return

/obj/boulder_trap_boulder
	icon = 'icons/misc/exploration.dmi'
	icon_state = "boulder"
	density = 1
	anchored = 1
	opacity = 0

	New(var/atom/sloc)
		src.set_loc(sloc)
		spawn(0) go()

	proc/go()
		while(!disposed)
			sleep(2)
			var/turf/next = get_step(src, SOUTH)
			if(prob(30))
				playsound(src.loc, 'sound/effects/rockscrape.ogg', 60, 1) // having some noise might be rad

			if(!next || next.density)
				playsound(src.loc, 'sound/effects/Explosion2.ogg', 40, 1)
				new/obj/item/raw_material/rock(src.loc)
				new/obj/item/raw_material/rock(src.loc)
				new/obj/item/raw_material/rock(src.loc)
				new/obj/item/raw_material/rock(src.loc)
				spawn(0)
					dispose()
				return
			else
				src.set_loc(next)
				for(var/mob/living/carbon/C in next)
					C.TakeDamage("chest", 33, 0)
					if(hasvar(C, "weakened"))
						C:weakened += 5


/obj/boulder_trap/respawning
	resets = 10

/obj/boulder_trap
	icon = 'icons/misc/mark.dmi'
	icon_state = "x4"
	invisibility = 101
	anchored = 1
	density = 0
	var/ready = 1
	var/resets = 0

	HasEntered(atom/movable/AM as mob|obj)
		if(!ready) return
		if(ismob(AM))
			if(AM:client)
				ready = 0
				playsound(src, 'sound/effects/exlow.ogg', 40, 0)
				var/turf/spawnloc = get_step(get_step(get_step(src, NORTH), NORTH), NORTH)
				new/obj/boulder_trap_boulder(spawnloc)
				playsound(src.loc, 'sound/effects/rockscrape.ogg', 40, 1)

				if(resets)
					spawn(resets) ready = 1

/obj/item/runetablet
	name = "Runic Tablet"
	desc = "A Tablet with several runes engraved upon its surface."
	icon = 'icons/misc/exploration.dmi'
	icon_state = "runetablet"

	attack_self()

		var/dat = ""
		dat += "<b>There's several runes inscribed here ...</b><BR><BR>"
		dat += "<A href='?src=\ref[src];north=1'>Touch the first rune</A><BR>"
		dat += "<A href='?src=\ref[src];east=1'>Touch the second rune</A><BR>"
		dat += "<A href='?src=\ref[src];south=1'>Touch the third rune</A><BR>"
		dat += "<A href='?src=\ref[src];west=1'>Touch the fourth rune</A><BR>"

		usr.machine = src
		usr << browse("[dat]", "window=rtab;size=400x300")
		onclose(usr, "rtab")
		return

	Topic(href, href_list)
		if (..(href, href_list))
			return

		var/movedir = null

		if (href_list["north"])
			boutput(usr, "<span style=\"color:blue\">The rune glows softly...</span>")
			movedir = NORTH
			playsound(src.loc, 'sound/machines/ArtifactEld1.ogg', 30, 1)
			playsound(src.loc, 'sound/effects/rockscrape.ogg', 40, 1)
		else if (href_list["east"])
			boutput(usr, "<span style=\"color:blue\">The rune glows softly...</span>")
			movedir = EAST
			playsound(src.loc, 'sound/machines/ArtifactEld1.ogg', 30, 1)
			playsound(src.loc, 'sound/effects/rockscrape.ogg', 40, 1)
		else if (href_list["south"])
			boutput(usr, "<span style=\"color:blue\">The rune glows softly...</span>")
			movedir = SOUTH
			playsound(src.loc, 'sound/machines/ArtifactEld1.ogg', 30, 1)
			playsound(src.loc, 'sound/effects/rockscrape.ogg', 40, 1)
		else if (href_list["west"])
			boutput(usr, "<span style=\"color:blue\">The rune glows softly...</span>")
			movedir = WEST
			playsound(src.loc, 'sound/machines/ArtifactEld1.ogg', 30, 1)
			playsound(src.loc, 'sound/effects/rockscrape.ogg', 40, 1)

		if(movedir != null)
			for(var/obj/shifting_wall/sneaky/cave/C in orange(3, usr))
				C.do_move(movedir)

		usr << browse(null, "window=rtab")
		src.updateUsrDialog()
		return


// cogwerks - wall shift trigger

/obj/sneaky_wall_trigger
	icon = 'icons/misc/mark.dmi'
	icon_state = "ydn"
	invisibility = 101
	anchored = 1
	density = 0
	var/active = 0
	HasEntered(atom/movable/AM as mob|obj)
		if(active) return
		if(ismob(AM))
			if(AM:client)
				if(prob(75))
					active = 1
					for(var/obj/shifting_wall/sneaky/cave/C in orange(7, usr))
						C.update()
					spawn(100) active = 0

//////// cogwerks - reward item, based on the old cyborg suit

/obj/item/clothing/suit/armor/ancient
	name = "ancient armor"
	desc = "It belongs in a museum. Or maybe a laboratory. What the hell is this?"
	icon_state = "death"
	item_state = "death"
	// stole some shit from the welder's apron
	flags = FPRINT | TABLEPASS | SPACEWEAR
	body_parts_covered = TORSO|LEGS|ARMS
	fire_resist = T0C+5200
	permeability_coefficient = 0.02
	protective_temperature = 1000
	heat_transfer_coefficient = 0.02
	cant_self_remove = 1
	cant_other_remove = 1
	w_class = 3.0
	var/processing = 0


// scare the everliving fuck out of the player when they equip it
// what else should this thing do? idk yet. maybe some crazy hallucinations with an ancient blood reagent or something? something like the obsidian crown?
// spookycoders are welcome to contribute to this thing

/obj/item/clothing/suit/armor/ancient/equipped(var/mob/user, var/slot)
	boutput(user, "<span style=\"color:blue\">The armor plates creak oddly as you put on [src].</span>")
	playsound(src.loc, 'sound/machines/ArtifactEld2.ogg', 30, 1)
	user.reagents.add_reagent("itching", 10)
	take_bleeding_damage(user, null, 0, DAMAGE_STAB, 0)
	bleed(user, 5, 5)
	src.desc = "This isn't coming off... oh god..."
	if (!src.processing)
		src.processing++
		if (!(src in processing_items))
			processing_items.Add(src)
	spawn(50)
		boutput(user, "<span style=\"color:blue\">The [src] feels like it's getting tighter. Ouch! Seems to have a lot of sharp edges inside.</span>")
		random_brute_damage(user, 5)
		take_bleeding_damage(user, null, 0, DAMAGE_STAB, 0)
		bleed(user, 5, 5)
		spawn(90)
			user.visible_message("<span style=\"color:red\"><b>[src] violently contracts around [user]!</B></span>")
			playsound(user.loc, 'sound/effects/bloody_stab.ogg', 50, 1, -1)
			random_brute_damage(user, 15)
			user.emote("scream")
			take_bleeding_damage(user, null, 0, DAMAGE_STAB, 0)
			bleed(user, 5, 1)
			spawn(50)
				user.visible_message("<span style=\"color:red\"><b>[src] digs into [user]!</B></span>")
				playsound(user.loc, 'sound/effects/bloody_stab.ogg', 50, 1, -1)
				random_brute_damage(user, 15)
				user.emote("scream")
				take_bleeding_damage(user, null, 0, DAMAGE_STAB, 0)
				bleed(user, 5, 5)
				spawn(50)
					var/mob/living/carbon/human/H = user
					playsound(user.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
					H.visible_message("<span style=\"color:red\"><b>[src] absorbs some of [user]'s skin!</b></span>")
					random_brute_damage(user, 30)
					H.emote("scream")
					if (!H.decomp_stage)
						H.bioHolder.AddEffect("eaten") //gross
					take_bleeding_damage(user, null, 0, DAMAGE_CUT, 0)
					bleed(user, 15, 5)
					user.emote("faint")
					user.reagents.add_reagent("ectoplasm", 50)
	return


/obj/item/clothing/suit/armor/ancient/process()
	var/mob/living/host = src.loc
	if (!istype(host))
		processing_items.Remove(src)
		processing = 0
		return

	if(prob(30) && istype(host,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = host
		M.bioHolder.age++
		if(prob(10)) boutput(M, "<span style=\"color:red\">You feel [pick("old", "strange", "frail", "peculiar", "odd")].</span>")
		if(prob(4)) M.emote("scream")
	return

///////////////////////////////
