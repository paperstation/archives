/obj/window
	name = "window"
	icon = 'icons/obj/window.dmi'
	icon_state = "window"
	desc = "A window."
	density = 1
	dir = 5 //full tile
	flags = FPRINT | USEDELAY | ON_BORDER
	var/health = 30
	var/health_max = 30
	var/health_multiplier = 1
	var/ini_dir = null
	var/state = 2
	var/hitsound = 'sound/effects/Glasshit.ogg'
	var/shattersound = "shatter"
	var/datum/material/reinforcement = null
	var/blunt_resist = 0
	var/cut_resist = 0
	var/stab_resist = 0
	var/corrode_resist = 0
	var/temp_resist = 0
	var/default_material = "glass"
	var/default_reinforcement = null
	var/reinf = 0 // cant figure out how to remove this without the map crying aaaaa - ISN
	var/deconstruct_time = 0//20
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1

	New()
		..()
		if (map_setting == "COG2")
			layer = COG2_WINDOW_LAYER
		src.ini_dir = src.dir
		update_nearby_tiles(need_rebuild=1)
		var/datum/material/M
		if (default_material)
			M = getCachedMaterial(default_material)
			src.setMaterial(M)
		if (default_reinforcement)
			src.reinforcement = getCachedMaterial(default_reinforcement)
		onMaterialChanged()

		// The health multiplier var wasn't implemented at all, apparently (Convair880)?
		if (src.health_multiplier != 1 && src.health_multiplier > 0)
			src.health_max = src.health_max * src.health_multiplier
			src.health = src.health_max
			//DEBUG ("[src.name] [log_loc(src)] has [health] health / [health_max] max health ([health_multiplier] multiplier).")

		return

	disposing()
		density = 0
		update_nearby_tiles()
		..()

	Move()
		update_nearby_tiles(need_rebuild=1)

		..()

		src.dir = src.ini_dir
		update_nearby_tiles(need_rebuild=1)

		return

	onMaterialChanged()
		..()

		name = initial(name)

		if (istype(src.material))
			health_max = material.hasProperty(PROP_TOUGHNESS) ? material.getProperty(PROP_TOUGHNESS) : health
			health = health_max
			cut_resist = material.hasProperty(PROP_SHEAR) ? material.getProperty(PROP_SHEAR) : cut_resist
			blunt_resist = material.hasProperty(PROP_COMPRESSIVE) ? material.getProperty(PROP_COMPRESSIVE) : blunt_resist
			stab_resist = material.hasProperty(PROP_HARDNESS) ? material.getProperty(PROP_HARDNESS) : stab_resist
			if (blunt_resist != 0) blunt_resist /= 2
			corrode_resist = material.hasProperty(PROP_CORROSION) ? material.getProperty(PROP_CORROSION) : corrode_resist
			temp_resist = material.hasProperty(PROP_MELTING) ? material.getProperty(PROP_MELTING) : temp_resist

			if (material.alpha > 220)
				opacity = 1 // useless opaque window
			else
				opacity = 0

			name = "[getQualityName(material.quality)] [material.name] " + name

		if (istype(reinforcement))
			if(reinforcement.hasProperty(PROP_TOUGHNESS))
				health_max += reinforcement.hasProperty(PROP_TOUGHNESS) ? round(reinforcement.getProperty(PROP_TOUGHNESS) / 2) : 0
				health = health_max
			else
				health_max += 30
				health = health_max
			cut_resist += reinforcement.hasProperty(PROP_SHEAR) ? round(reinforcement.getProperty(PROP_SHEAR) / 2) : 0
			blunt_resist += reinforcement.hasProperty(PROP_COMPRESSIVE) ? round(reinforcement.getProperty(PROP_COMPRESSIVE) / 2) : 0
			stab_resist += reinforcement.hasProperty(PROP_HARDNESS) ? round(reinforcement.getProperty(PROP_HARDNESS) / 2) : 0
			corrode_resist += reinforcement.hasProperty(PROP_CORROSION) ? round(reinforcement.getProperty(PROP_CORROSION) / 2) : 0

			name = "[reinforcement.name]-reinforced " + name

	proc/set_reinforcement(var/datum/material/M)
		if (!M)
			return
		reinforcement = M
		onMaterialChanged()

	damage_blunt(var/amount)
		if (!isnum(amount) || amount <= 0)
			return

		var/armor = 0

		if (src.material)
			armor = blunt_resist

			if (src.material.getProperty(PROP_COMPRESSIVE) >= 25)
				armor += round(src.material.getProperty(PROP_COMPRESSIVE) / 10)
			else if (src.material.hasProperty(PROP_COMPRESSIVE) && src.material.getProperty(PROP_COMPRESSIVE) < 10)
				amount += rand(1,3)

		amount = get_damage_after_percentage_based_armor_reduction(armor,amount)

		src.health = max(0,min(src.health - amount,src.health_max))

		if (src.health == 0)
			smash()

	damage_slashing(var/amount)
		if (!isnum(amount))
			return

		amount = get_damage_after_percentage_based_armor_reduction(cut_resist,amount)
		if (src.quality < 10)
			amount += rand(1,3)

		if (amount <= 0)
			return

		src.health = max(0,min(src.health - amount,src.health_max))
		if (src.health == 0)
			smash()

	damage_piercing(var/amount)
		if (!isnum(amount))
			return

		amount = get_damage_after_percentage_based_armor_reduction(stab_resist,amount)
		if (src.quality < 10)
			amount += rand(1,3)

		if (amount <= 0)
			return

		src.health = max(0,min(src.health - amount,src.health_max))
		if (src.health == 0)
			smash()

	damage_corrosive(var/amount)
		if (!isnum(amount) || amount <= 0)
			return

		amount = get_damage_after_percentage_based_armor_reduction(corrode_resist,amount)
		if (amount <= 0)
			return
		src.health = max(0,min(src.health - amount,src.health_max))
		if (src.health == 0)
			smash()

	damage_heat(var/amount)
		if (!isnum(amount) || amount <= 0)
			return

		if (src.material)
			if (amount * 100000 <= temp_resist)
				// Not applying enough heat to melt it
				return

		if (amount <= 0)
			return
		src.health = max(0,min(src.health - amount,src.health_max))
		if (src.health == 0)
			smash()

	ex_act(severity)
		switch(severity)
			if(1)
				src.damage_blunt(40)
				src.damage_heat(40)
			if(2)
				src.damage_blunt(15)
				src.damage_heat(15)
			if(3)
				src.damage_blunt(7)
				src.damage_heat(7)

	meteorhit(var/obj/M)
		if (istype(M, /obj/newmeteor/massive))
			smash()
			return
		src.damage_blunt(20)

	blob_act(var/power)
		src.damage_blunt(power * 1.25)

	bullet_act(var/obj/projectile/P)
		var/damage = 0
		if (!P || !istype(P.proj_data,/datum/projectile/))
			return
		damage = round((P.power*P.proj_data.ks_ratio), 1.0)
		if (damage < 1)
			return

		if(src.material) src.material.triggerOnAttacked(src, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))
		for(var/atom/A in src)
			if(A.material)
				A.material.triggerOnAttacked(A, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))

		switch(P.proj_data.damage_type)
			if(D_KINETIC)
				damage_blunt(damage)
			if(D_PIERCING)
				damage_piercing(damage)
			if(D_ENERGY)
				damage_heat(damage / 6)
		return

	reagent_act(var/reagent_id,var/volume)
		if (..())
			return
		// windows are good at resisting corrosion and heat
		switch(reagent_id)
			if("acid")
				damage_corrosive(volume / 4)
			if("pacid")
				damage_corrosive(volume / 2)
			if("napalm")
				damage_heat(volume / 4)
			if("infernite")
				damage_heat(volume / 2)
			if("foof")
				damage_heat(volume)

	get_desc()
		var/the_text = ""
		switch(src.state)
			if(0)
				if (!src.anchored)
					the_text += "It seems to be completely loose. You could probably slide it around."
				else
					the_text += "It seems to have been pried out of the frame."
			if(1)
				the_text += "It doesn't seem to be properly fastened down."
		if (opacity)
			the_text += " ...you can't see through it at all. What kind of idiot made this?"
		return the_text

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(istype(mover, /obj/projectile))
			var/obj/projectile/P = mover
			if(P.proj_data.window_pass)
				return 1
		if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST)
			return 0 //full tile window, you can't move into it!
		if(get_dir(loc, target) == dir)

			return !density
		else
			return 1

	CheckExit(atom/movable/O as mob|obj, target as turf)
		if (!src.density)
			return 1
		if(istype(O, /obj/projectile))
			var/obj/projectile/P = O
			if(P.proj_data.window_pass)
				return 1
		if (get_dir(O.loc, target) == src.dir)
			return 0
		return 1

	hitby(AM as mob|obj)
		..()
		src.visible_message("<span style=\"color:red\"><B>[src] was hit by [AM].</B></span>")
		playsound(src.loc, src.hitsound , 100, 1)
		if (ismob(AM))
			damage_blunt(15)
		else
			var/obj/O = AM
			damage_blunt(O.throwforce)
		if (src && src.health <= 2 && !reinforcement)
			src.anchored = 0
			step(src, get_dir(AM, src))
		..()
		return

	attack_hand(mob/user as mob)
		if (user.a_intent == "harm")
			if (user.bioHolder && user.bioHolder.HasEffect("hulk"))
				user.visible_message("<span style=\"color:red\"><b>[user]</b> punches the window.</span>")
				playsound(src.loc, src.hitsound, 100, 1)
				src.damage_blunt(10)
				return
			else
				src.visible_message("<span style=\"color:red\"><b>[user]</b> beats [src] uselessly!</span>")
				playsound(src.loc, src.hitsound, 100, 1)
				return
		else
			if (istype(usr, /mob/living/carbon/human))
				src.visible_message("<span style=\"color:red\"><b>[usr]</b> knocks on [src].</span>")
				playsound(src.loc, src.hitsound, 100, 1)
				sleep(3)
				playsound(src.loc, src.hitsound, 100, 1)
				sleep(3)
				playsound(src.loc, src.hitsound, 100, 1)
				return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/screwdriver))
			if (state == 10)
				return
			else if (state >= 1)
				playsound(src.loc, "sound/items/Screwdriver.ogg", 75, 1)
				if (deconstruct_time)
					user.show_text("You begin to [state == 1 ? "fasten the window to" : "unfasten the window from"] the frame...", "red")
					if (!do_after(user, deconstruct_time))
						boutput(user, "<span style=\"color:red\">You were interrupted.</span>")
						return
				state = 3 - state
				user.show_text("You have [state == 1 ? "unfastened the window from" : "fastened the window to"] the frame.", "blue")
			else if (state == 0)
				playsound(src.loc, "sound/items/Screwdriver.ogg", 75, 1)
				if (deconstruct_time)
					user.show_text("You begin to [src.anchored ? "unfasten the frame from" : "fasten the frame to"] the floor...", "red")
					if (!do_after(user, deconstruct_time))
						boutput(user, "<span style=\"color:red\">You were interrupted.</span>")
						return
				src.anchored = !(src.anchored)
				user.show_text("You have [src.anchored ? "fastened the frame to" : "unfastened the frame from"] the floor.", "blue")
				return 1
			else
				playsound(src.loc, "sound/items/Screwdriver.ogg", 75, 1)
				if (deconstruct_time)
					user.show_text("You begin to [src.anchored ? "unfasten the window from" : "fasten the window to"] the floor...", "red")
					if (!do_after(user, deconstruct_time))
						boutput(user, "<span style=\"color:red\">You were interrupted.</span>")
						return
				src.anchored = !(src.anchored)
				user.show_text("You have [src.anchored ? "fastened the window to" : "unfastened the window from"] the floor.", "blue")
				return 1

		else if (istype(W, /obj/item/crowbar))
			if (state <= 1)
				playsound(src.loc, "sound/items/Crowbar.ogg", 75, 1)
				if (deconstruct_time)
					user.show_text("You begin to [src.state ? "pry the window out of" : "pry the window into"] the frame...", "red")
					if (!do_after(user, deconstruct_time))
						boutput(user, "<span style=\"color:red\">You were interrupted.</span>")
						return
				state = 1 - state
				user.show_text("You have [src.state ? "pried the window into" : "pried the window out of"] the frame.", "blue")

		else if (istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if (ishuman(G.affecting) && get_dist(G.affecting, src) <= 1)
				src.visible_message("<span style=\"color:red\"><B>[user] slams [G.affecting]'s head into [src]!</B></span>")
				logTheThing("combat", user, G.affecting, "slams %target%'s head into [src]")
				playsound(src.loc, src.hitsound , 100, 1)
				G.affecting:TakeDamage("head", 0, 5)
				qdel(W)
				src.damage_blunt(2)
		else
			playsound(src.loc, src.hitsound , 75, 1)
			src.damage_blunt(W.force)
			if (src.health <= 2)
				src.anchored = 0
				step(src, get_dir(user, src))
			..()
		return

	proc/smash()
		var/atom/A
		// catastrophic event litter reduction
		if(limiter.canISpawn(/obj/item/raw_material/shard))
			A = new/obj/item/raw_material/shard(src.loc)
			if(src.material)
				A.setMaterial(src.material)
			else
				var/datum/material/M = getCachedMaterial("glass")
				A.setMaterial(M)
		if(reinforcement && limiter.canISpawn(/obj/item/rods))
			A = new /obj/item/rods(src.loc)
			A.setMaterial(reinforcement)
		playsound(src, src.shattersound, 70, 1)
		qdel(src)

	proc/update_nearby_tiles(need_rebuild)
		if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/target = get_step(source,dir)

		if(need_rebuild)
			if(istype(source)) //Rebuild/update nearby group geometry
				if(source.parent)
					air_master.queue_update_group(source.parent)
				else
					air_master.queue_update_tile(source)
			if(istype(target))
				if(target.parent)
					air_master.queue_update_group(target.parent)
				else
					air_master.queue_update_tile(target)
		else
			if(istype(source)) air_master.queue_update_tile(source)
			if(istype(target)) air_master.queue_update_tile(target)

		return 1

	verb/rotate()
		set name = "Rotate Window"
		set src in oview(1)
		set category = "Local"

		if (!(src.dir in cardinal))
			return
		if (src.anchored)
			boutput(usr, "It is fastened to the floor; therefore, you can't rotate it!")
			return 0

		update_nearby_tiles(need_rebuild=1) //Compel updates before

		var/action = input(usr,"Rotate it which way?","Window Rotation",null) in list("Clockwise ->","Anticlockwise <-","180 Degrees")
		if (!action) return

		switch(action)
			if ("Clockwise ->") src.dir = turn(src.dir, -90)
			if ("Anticlockwise <-") src.dir = turn(src.dir, 90)
			if ("180 Degrees") src.dir = turn(src.dir, 180)

		update_nearby_tiles(need_rebuild=1)

		src.ini_dir = src.dir
		return

/obj/window/reinforced
	icon_state = "rwindow"
	default_reinforcement = "steel"
	health = 50
	health_max = 50
	//deconstruct_time = 30

/obj/window/crystal
	default_material = "plasmaglass"
	hitsound = 'sound/effects/crystalhit.ogg'
	shattersound = 'sound/effects/crystalshatter.ogg'
	health = 80
	health_max = 80
	//deconstruct_time = 40

/obj/window/crystal/reinforced
	icon_state = "rwindow"
	default_reinforcement = "steel"
	health = 100
	health_max = 100
	//deconstruct_time = 50

//an unbreakable window
/obj/window/bulletproof
	name = "bulletproof window"
	desc = "A specially made, heavily reinforced window. Trying to break or shoot through this would be a waste of time."
	icon_state = "rwindow"
	default_material = "uqillglass"
	health_multiplier = 100
	//deconstruct_time = 100

/obj/window/supernorn
	icon = 'icons/Testing/newicons/obj/NEWstructures.dmi'
	dir = 5

	attackby() // TODO: need to be able to smash them, this is a hack
	rotate()
		set hidden = 1

	New()
		for (var/turf/simulated/wall/auto/T in orange(1))
			T.update_icon()

/obj/window/north
	dir = NORTH

/obj/window/east
	dir = EAST

/obj/window/west
	dir = WEST

/obj/window/south
	dir = SOUTH

/obj/window/crystal/north
	dir = NORTH

/obj/window/crystal/east
	dir = EAST

/obj/window/crystal/west
	dir = WEST

/obj/window/crystal/south
	dir = SOUTH

/obj/window/crystal/reinforced/north
	dir = NORTH

/obj/window/crystal/reinforced/east
	dir = EAST

/obj/window/crystal/reinforced/west
	dir = WEST

/obj/window/crystal/reinforced/south
	dir = SOUTH

/obj/window/reinforced/north
	dir = NORTH

/obj/window/reinforced/east
	dir = EAST

/obj/window/reinforced/west
	dir = WEST

/obj/window/reinforced/south
	dir = SOUTH

/obj/window/bulletproof/north
	dir = NORTH

/obj/window/bulletproof/east
	dir = EAST

/obj/window/bulletproof/west
	dir = WEST

/obj/window/bulletproof/south
	dir = SOUTH

/obj/window/auto
	icon = 'icons/obj/window_pyro.dmi'
	icon_state = "mapwin"
	dir = 5
	//deconstruct_time = 20
	var/mod = null
	var/list/connects_to = list(/turf/simulated/wall/auto/supernorn, /turf/simulated/wall/auto/reinforced/supernorn,
	/turf/simulated/shuttle/wall, /turf/simulated/shuttle/wall/escape, /obj/machinery/door,
	/obj/window)

	New()
		..()
		src.verbs -= /obj/window/verb/rotate
		spawn(0)
			src.update_icon()

	proc/update_icon()
		if (!src.anchored)
			icon_state = "[mod]0"
			return

		var/builtdir = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (T.type in connects_to)
				builtdir |= dir
			else if (connects_to)
				for (var/i=1, i <= connects_to.len, i++)
					var/atom/A = locate(connects_to[i]) in T
					if (!isnull(A))
						if (istype(A, /atom/movable))
							var/atom/movable/M = A
							if (!M.anchored)
								continue
						builtdir |= dir
						break
		src.icon_state = "[mod][builtdir]"

	attackby(obj/item/W as obj, mob/user as mob)
		if (..(W, user))
			src.update_icon()

/obj/window/auto/reinforced
	icon_state = "mapwin_r"
	mod = "R"
	default_reinforcement = "steel"
	health = 50
	health_max = 50
	//deconstruct_time = 30

/obj/window/auto/crystal
	default_material = "plasmaglass"
	hitsound = 'sound/effects/crystalhit.ogg'
	shattersound = 'sound/effects/crystalshatter.ogg'
	health = 80
	health_max = 80
	//deconstruct_time = 40

/obj/window/auto/crystal/reinforced
	icon_state = "mapwin_r"
	mod = "R"
	default_reinforcement = "steel"
	health = 100
	health_max = 100
	//deconstruct_time = 50

/obj/window/auto/bulletproof
	name = "bulletproof window"
	desc = "A specially made, heavily reinforced window. Trying to break or shoot through this would be a waste of time."
	icon_state = "mapwin_r"
	default_material = "uqillglass"
	health_multiplier = 100
	//deconstruct_time = 100

/obj/wingrille_spawn
	name = "window grille spawner"
	icon = 'icons/obj/window.dmi'
	icon_state = "wingrille"
	density = 1
	anchored = 1.0
	invisibility = 101
	//layer = 99
	pressure_resistance = 4*ONE_ATMOSPHERE
	var/win_path = "/obj/window"
	var/full_win = 0 // adds a full window as well

	New()
		spawn(1)
			src.set_up()
			spawn(10)
				qdel(src)

	proc/set_up()
		if (!locate(/obj/grille/steel) in get_turf(src))
			new /obj/grille/steel(src.loc)
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (!locate(/obj/wingrille_spawn) in T)
				var/obj/window/new_win = text2path("[src.win_path]/[dir2text(dir)]")
				new new_win(src.loc)
		if (src.full_win)
			if (!locate(text2path(src.win_path)) in get_turf(src))
				var/obj/window/new_win = text2path(src.win_path)
				new new_win(src.loc)

	full
		icon_state = "wingrille_f"
		full_win = 1

	reinforced
		name = "reinforced window grille spawner"
		icon_state = "r-wingrille"
		win_path = "/obj/window/reinforced"

		full
			icon_state = "r-wingrille_f"
			full_win = 1

	crystal
		name = "crystal window grille spawner"
		icon_state = "p-wingrille"
		win_path = "/obj/window/crystal"

		full
			icon_state = "p-wingrille_f"
			full_win = 1

	reinforced_crystal
		name = "reinforced crystal window grille spawner"
		icon_state = "pr-wingrille"
		win_path = "/obj/window/crystal/reinforced"

		full
			icon_state = "pr-wingrille_f"
			full_win = 1

	bulletproof
		name = "bulletproof window grille spawner"
		icon_state = "br-wingrille"
		win_path = "/obj/window/bulletproof"

		full
			icon_state = "b-wingrille_f"
			full_win = 1
