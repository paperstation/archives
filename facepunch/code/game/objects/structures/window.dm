
/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/glass.dmi'
	density = 1
	layer = 3.6//Just above doors use 3.3
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	health = 14
	max_health = 14
	dir = 2
	damage_sound = 'sound/effects/Glasshit.ogg'
	var/id = 0//Windows of a diff ID will NOT merge when the icons update
	var/state = 0
	var/reinf = 0


	New(Loc,re=0)
		..()
		if(re)	reinf = re
		if(reinf)
			icon_state = "rwindow"
			desc = "A reinforced window."
			name = "reinforced window"
			state = 2*anchored
			health = 40
			max_health = 40
			if(opacity)
				icon_state = "twindow"
		else
			icon_state = "window"
		dir = 2
		update_nearby_tiles(need_rebuild=1)
		update_nearby_icons()
		return


	Del()
		anchored = 0
		density = 0
		update_nearby_tiles()
		update_nearby_icons()
		..()
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(istype(mover) && mover.checkpass(PASSGLASS))
			return 1
		return !density


	hitby(AM as mob|obj)
		..()
		visible_message("<span class='danger'>[src] was hit by [AM].</span>")
		var/tforce = 0
		if(ismob(AM))
			tforce = 20
		else if(isobj(AM))
			var/obj/item/I = AM
			tforce = (I.force/2)
		damage(tforce)
		return


	attack_hand(mob/user as mob)
		if(HULK in user.mutations)
			if(prob(20))
				user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
			user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
			destroy()
			return
		user.visible_message("<span class='notice'>[user] knocks on [src].</span>")
		playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
		return


	attack_paw(mob/user as mob)
		return attack_hand(user)


	proc/attack_generic(mob/user as mob, damage = 0)	//used by attack_alien, attack_animal, and attack_slime
		damage(damage)
		user.visible_message("<span class='danger'>[user] smashes into the [src]!</span>")
		return


	attack_alien(mob/user as mob)
		if(islarva(user)) return
		attack_generic(user, 15)


	attack_animal(mob/user as mob)
		if(!isanimal(user)) return
		var/mob/living/simple_animal/M = user
		if(M.melee_damage_upper <= 0) return
		attack_generic(M, M.melee_damage_upper)


	attack_slime(mob/user as mob)
		if(!isslimeadult(user)) return
		attack_generic(user, rand(10, 15))


	attackby(obj/item/W as obj, mob/user as mob)
		if(!istype(W)) return
		if(user.a_intent == "hurt")
			..()
			return
		if(istype(W, /obj/item/weapon/screwdriver))
			if(reinf && state >= 1)
				state = 3 - state
				playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
				user << (state == 1 ? "<span class='notice'>You have unfastened the window from the frame.</span>" : "<span class='notice'>You have fastened the window to the frame.</span>")
				return
			else if(reinf && state == 0)
				anchored = !anchored
				update_nearby_icons()
				playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
				user << (anchored ? "<span class='notice'>You have fastened the frame to the floor.</span>" : "<span class='notice'>You have unfastened the frame from the floor.</span>")
				return
			else if(!reinf)
				anchored = !anchored
				update_nearby_icons()
				playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
				user << (anchored ? "<span class='notice'>You have fastened the window to the floor.</span>" : "<span class='notice'>You have unfastened the window.</span>")
				return
		else if(istype(W, /obj/item/weapon/crowbar) && reinf && state <= 1)
			state = 1 - state
			playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
			user << (state ? "<span class='notice'>You have pried the window into the frame.</span>" : "<span class='notice'>You have pried the window out of the frame.</span>")
			return
		..()
		return


	ex_act(severity)//Overloaded due to not wanting to make a sound when we break, makes explosions take longer to process
		switch(severity)
			if(1.0)
				del(src)
			if(2.0)
				if(prob(50))
					del(src)
				else
					destroy(0)
			if(3.0)
				destroy(0)
		return


	destroy(var/use_sound = 1)
		if(use_sound)
			playsound(src, "shatter", 70, 1)
		new /obj/item/weapon/shard(loc)
		if(reinf) new /obj/item/stack/rods(loc)
		del(src)
		return


	Move()
		update_nearby_tiles(need_rebuild=1)
		..()
		update_nearby_tiles(need_rebuild=1)
		update_icon()//Will fix odd looking grillewindows when not on a grille, should not cost much due to being unanchored 99% of the time this is ran
		return


//This proc has to do with airgroups and atmos, it has nothing to do with smoothwindows, that's update_nearby_icons().
	proc/update_nearby_tiles(need_rebuild)
		if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/target = get_step(source,dir)

		if(need_rebuild)
			if(istype(source)) //Rebuild/update nearby group geometry
				if(source.parent)
					air_master.groups_to_rebuild += source.parent
				else
					air_master.tiles_to_update += source
			if(istype(target))
				if(target.parent)
					air_master.groups_to_rebuild += target.parent
				else
					air_master.tiles_to_update += target
		else
			if(istype(source)) air_master.tiles_to_update += source
			if(istype(target)) air_master.tiles_to_update += target

		return 1


//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
	proc/update_nearby_icons()
		update_icon()
		for(var/direction in cardinal)
			for(var/obj/structure/window/W in get_step(src,direction) )
				W.update_icon()


//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
	update_icon()
		spawn(2)//Wait untill other windows finish doing things like deling or moving
			if(!src) return
			var/junction = 0 //will be used to determine from which side the window is connected to other windows
			if(anchored)
				for(var/obj/structure/window/W in orange(src,1))
					if(W.anchored && W.density && W.id == id) //Only counts anchored, not-destroyed windows, with the same ID
						if(abs(x-W.x)-abs(y-W.y) ) 		//doesn't count windows, placed diagonally to src
							junction |= get_dir(src,W)

			if(opacity)
				icon_state = "twindow[junction]"
				return

			if(reinf)//Only reinforced currently have grille sprites
				var/obj/structure/grille/G = (locate(/obj/structure/grille) in src.loc)
				if(G && G.density)//Needs to exist and be intact
					icon_state = "hwindow[junction]"
					return
				else
					icon_state = "rwindow[junction]"
			else
				icon_state = "window[junction]"
			return


	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if(exposed_temperature > T0C + 800)
			damage(round(exposed_volume / 100), 0)
		..()



/obj/structure/window/basic
	icon_state = "window"

/obj/structure/window/reinforced
	name = "reinforced window"
	icon_state = "rwindow"
	reinf = 1

/obj/structure/window/reinforced/tinted//This window is bad and just blocks sight.
	name = "tinted window"
	icon_state = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	icon_state = "fwindow"
