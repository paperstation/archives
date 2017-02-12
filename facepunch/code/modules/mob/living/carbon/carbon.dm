/mob/living/carbon/New()
	..()
	internal_organs += new /obj/item/organ/appendix
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/brain


/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			src.nutrition -= HUNGER_FACTOR/10
			if(src.m_intent == "run")
				src.nutrition -= HUNGER_FACTOR/10
		if((FAT in src.mutations) && src.m_intent == "run" && src.bodytemperature <= 360)
			src.bodytemperature += 2


/mob/living/carbon/relaymove(var/mob/user, direction)
	if(user in src.stomach_contents)
		if(prob(40))
			visible_message("\red You hear something rumbling inside [src]'s stomach...")
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				deal_damage(I.force/2, I.damtype, I.forcetype, "chest")
				visible_message("\red <B>[user] attacks [src]'s stomach wall with the [I.name]!")
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(get_brute_loss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()


/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		visible_message("\red <B>[M] bursts out of [src]!</B>")
	. = ..()


/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return

	for(var/datum/disease/D in viruses)

		if(D.spread_by_touch())

			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)

		if(D.spread_by_touch())

			contract_disease(D, 0, 1, CONTACT_HANDS)

	return


/mob/living/carbon/attack_paw(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)
	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)
	return


/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0

	if(src.reagents.has_reagent("electrozene", 10)) //One creations worth
		src.visible_message("You feel a tingle of electricity go through your body followed by a strange reaction inside of you.")
		src.reagents.remove_reagent("Electrozene", 10)
		return


	src.visible_message(
		"\red [src] was shocked by the [source]!", \
		"\red <B>You feel a powerful shock course through your body!</B>", \
		"\red You hear a heavy electrical crack." \
	)

	//Here starts the list
	if(src.reagents.has_reagent("fuel", 100)) //morecommon
		src.visible_message("The reagents inside of you react to the shock!")
		src.gib()
		return
	if(src.reagents.has_reagent("beer", 130)) //beer isn't as flammable as volitile fuel
		src.visible_message("The reagents inside of you react to the shock!")
		src.gib()
		return
	if(src.reagents.has_reagent("ale", 130)) //beer isn't as flammable as volitile fuel
		src.visible_message("The reagents inside of you react to the shock!")
		src.gib()
		return
	if(src.reagents.has_reagent("ethanol", 130)) //beer isn't as flammable as volitile fuel
		src.visible_message("The reagents inside of you react to the shock!")
		src.gib()
		return

	deal_overall_damage(0,shock_damage)
	deal_damage(max(0, 10*siemens_coeff), WEAKEN)
	return shock_damage


/mob/living/carbon/proc/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(istype(item_in_hand,/obj/item/weapon/twohanded))
			if(item_in_hand:wielded == 1)
				usr << "<span class='warning'>Your other hand is too busy holding the [item_in_hand.name]</span>"
				return
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	/*if (!( src.hand ))
		src.hands.dir = NORTH
	else
		src.hands.dir = SOUTH*/
	return

/mob/living/carbon/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

	if(selhand == "right" || selhand == "r")
		selhand = 0
	if(selhand == "left" || selhand == "l")
		selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/proc/help_shake_act(mob/living/M)
	if(health >= 0)
		if(src == M && istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src

			if(SKELETON in H.mutations && !H.w_uniform && !H.wear_suit)
				if(H.play_xylophone())
					return

			visible_message( \
				"<span class='notice'>[src] examines \himself.", \
				"<span class='notice'>You check yourself for injuries.</span>")
			self_check_zone("head")
			self_check_zone("arms")
			self_check_zone("chest")
			self_check_zone("legs")

		else
			if(istype(src, /mob/living/carbon/human) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			if(lying)
				sleeping = max(0, sleeping - 5)
				if(sleeping == 0)
					resting = 0

			deal_damage(-3, PARALYZE)
			deal_damage(-3, WEAKEN)

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			M.visible_message( \
					"<span class='notice'>[M] shakes [src] trying to wake \him up!</span>", \
					"<span class='notice'>You shake [src] trying to wake \him up!</span>")
	return


//Used when you help intent yourself
/mob/living/proc/self_check_zone(var/zone)
	var/brutedamage = 0
	var/burndamage = 0

	switch(zone)
		if("chest")
			brutedamage = brute_chest
			burndamage = fire_chest
		if("head")
			brutedamage = brute_head
			burndamage = fire_head
		if("arms")
			brutedamage = brute_arms
			burndamage = fire_arms
		if("legs")
			brutedamage = brute_legs
			burndamage = fire_legs

	var/status = ""
	if(brutedamage > 0)
		status = "bruised"
	if(brutedamage > 20)
		status = "bleeding"
	if(brutedamage > 40)
		status = "mangled"
	if(brutedamage > 0 && burndamage > 0)
		status += " and "
	if(burndamage > 40)
		status += "peeling away"

	else if(burndamage > 10)
		status += "blistered"
	else if(burndamage > 0)
		status += "numb"
	if(status == "")
		status = "OK"
	src << "\t [status == "OK" ? "\blue" : "\red"] My [zone] appear\s to be [status]."
	return


/mob/living/carbon/eyecheck()
	return 0


/mob/living/carbon/earcheck()
	return 0


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/proc/handle_ventcrawl()
	if(stat)
		src << "You must be conscious to do this!"
		return
	if(lying)
		src << "You can't vent crawl while you're stunned!"
		return

	#ifdef NEWMAP
	var/obj/machinery/atmospherics/local_vent/vent_found
	for(var/obj/machinery/atmospherics/local_vent/V in range(1,src))
		if(!V.welded)
			vent_found = V
	#else
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	for(var/obj/machinery/atmospherics/unary/vent_pump/V in range(1,src))
		if(!V.welded)
			vent_found = V
	#endif

	if(!vent_found)
		src << "You must be standing on or beside an open air vent to enter it."
		return
	var/turf/startloc = loc

	#ifdef NEWMAP
	if(!vent_found.lac_vent)
		src << "This vent is not connected to anything."
		return
	if(!vent_found.lac_vent.vents.len)
		src << "This vent is not connected to anything."
		return
	var/obj/machinery/atmospherics/local_vent/list/open_vents = new/list()
	for(var/obj/machinery/atmospherics/local_vent/temp_vent in vent_found.lac_vent.vents)
		//if(temp_vent.loc == loc)
		//	continue
		if(temp_vent.welded)
			continue
		open_vents += temp_vent
	var/obj/machinery/atmospherics/local_vent/target_vent = input("Select a destination.", "Duct System") as null|anything in sortList(open_vents)
	#else
	if(!vent_found.network)
		src << "This vent is not connected to anything."
		return
	if(!vent_found.network.normal_members.len)
		src << "This vent is not connected to anything."
		return
	var/list/vents[0]
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in vent_found.network.normal_members)
		if(temp_vent.loc == loc)
			continue
		if(temp_vent.welded)
			continue
		var/turf/T = get_turf(temp_vent)

		if(!T || T.z != loc.z)
			continue

		var/i = 1
		var/index = "[T.loc.name]\[[i]\]"
		while(index in vents)
			i++
			index = "[T.loc.name]\[[i]\]"
		vents[index] = temp_vent

	var/obj/selection = input("Select a destination.", "Duct System") as null|anything in sortList(vents)
	if(!selection)	return
	var/obj/machinery/atmospherics/unary/vent_pump/target_vent = vents[selection]
	#endif

	if(!target_vent)
		src << "Vent does not exist."
		return

	if(loc != startloc)
		src << "You need to remain still while entering a vent."
		return

	if(contents.len)//Check to see if we are holding things
		for(var/obj/item/carried_item in contents)
			if(!istype(carried_item, /obj/item/weapon/implant) && !istype(carried_item, /obj/item/clothing/mask/facehugger))//If it's not a facehugger or implant which is inside you
				src << "\red You can't be carrying items or have items equipped when vent crawling!"
				return

	visible_message("<B>[src] scrambles into the [target_vent]!</B>")
	loc = target_vent

	var/travel_time = round(get_dist(loc, target_vent.loc) / 2)
	spawn(travel_time)

	if(!target_vent)
		src << "\red Target does not exist."
		return
	for(var/mob/O in hearers(target_vent,null))
		O.show_message("You hear something squeezing through the ventilation ducts.",2)

	sleep(travel_time)

	if(!target_vent)
		src << "\red Target does not exist!"
		return
	if(target_vent.welded)			//the vent can be welded while alien scrolled through the list or travelled.
		target_vent = vent_found 	//travel back. No additional time required.
		src << "\red The vent you were heading to appears to be welded."
	loc = target_vent.loc
	var/area/new_area = get_area(loc)
	if(new_area)
		new_area.Entered(src)
	return


/mob/living/carbon/clean_blood()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.gloves)
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)
		else
			if(H.bloody_hands)
				H.bloody_hands = 0
				H.bloody_hands_mob = null
				H.update_inv_gloves(0)
	update_icons()	//apply the now updated overlays to the mob


//Throwing stuff

/mob/living/carbon/proc/toggle_throw_mode()
	var/obj/item/W = get_active_hand()
	if( !W )//Not holding anything
		if( client && (TK in mutations) )
			var/obj/item/tk_grab/O = new(src)
			put_in_active_hand(O)
			O.host = src
		return

	if( istype(W,/obj/item/tk_grab) )
		if(hand)	del(l_hand)
		else		del(r_hand)
		return

	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/proc/throw_mode_off()
	src.in_throw_mode = 0
	src.throw_icon.icon_state = "act_throw_off"

/mob/living/carbon/proc/throw_mode_on()
	src.in_throw_mode = 1
	src.throw_icon.icon_state = "act_throw_on"

/mob/living/carbon/proc/throw_item(atom/target)
	src.throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /obj/screen) return

	var/atom/movable/item = src.get_active_hand()

	if(!item) return

	if (istype(item, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = item
		item = G.throw() //throw the person instead of the grab
		if(ismob(item))
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been thrown by [usr.name] ([usr.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>")

	if(!item) return //Grab processing has a chance of returning null

	u_equip(item)
	update_icons()
	if(src.client)
		src.client.screen -= item

	item.loc = src.loc

	if(istype(item, /obj/item))
		item:dropped(src) // let it know it's been dropped

	//actually throw it!
	if (item)
		item.layer = initial(item.layer)
		src.visible_message("\red [src] has thrown [item].")

		if(!src.lastarea)
			src.lastarea = get_area(src.loc)
		if((istype(src.loc, /turf/space)) || (src.lastarea.has_gravity == 0))
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)


/*
		if(istype(src.loc, /turf/space) || (src.flags & NOGRAV)) //they're in space, move em one space in the opposite direction
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)
*/



		item.throw_at(target, 7, 2)//Use to be throw_range and throw_speed but we removed those vars and went with 10/2

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT+10)

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && !istype(buckled, /obj/structure/stool/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if(handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0
	else if (W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()
	else
	 ..()

	return

/mob/living/carbon/show_inv(mob/living/carbon/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

/mob/living/carbon/attackby(obj/item/I, mob/user)
	if(islist(surgeries) && surgeries.len)
		var/success = 0
		for(var/datum/surgery/S in surgeries)
			if(S.next_step(user, src))
				success = 1
		if(success)
			return

	..()
	return

/mob/living/carbon/proc/handle_stomach()
	spawn(0)
		for(var/mob/living/M in stomach_contents)
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
					if(!(status_flags & GODMODE))
						M.deal_damage(5, BRUTE)
					nutrition += 10