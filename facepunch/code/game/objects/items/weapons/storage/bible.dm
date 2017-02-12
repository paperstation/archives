/obj/item/weapon/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	w_class = 3.0
	flags = FPRINT | TABLEPASS
	var/mob/affecting = null
	var/deity_name = "Christ"


	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is sacrificing \him self to the space gods! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is sacrificing \him self to Narsie! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)


/obj/item/weapon/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

/obj/item/weapon/storage/bible/booze/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/beer(src)
	new /obj/item/weapon/reagent_containers/food/drinks/beer(src)
	new /obj/item/weapon/spacecash(src)
	new /obj/item/weapon/spacecash(src)
	new /obj/item/weapon/spacecash(src)

/obj/item/weapon/storage/bible/proc/bless(mob/living/carbon/M as mob)
	M.deal_overall_damage(-5,-5)
	return

/obj/item/weapon/storage/bible/attack(mob/living/M as mob, mob/living/user as mob)
	var/chaplain = 0
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		chaplain = 1


	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")

	if((CLUMSY in user.mutations) && prob(50))
		user << "\red The [src] slips out of your hand and hits your head."
		user.deal_damage(10, BRUTE, IMPACT, "head")
		user.deal_damage(10, PARALYZE, IMPACT, "head")
		return

	if(!chaplain)
		user.visible_message("\red <B>[user] slaps [M] with [src].</B>")
		playsound(src.loc, "punch", 25, 1, -1)
		return

	if(M.stat == 2)
		user.visible_message("\red <B>[user] smacks [M]'s lifeless corpse with [src].</B>")
		playsound(src.loc, "punch", 25, 1, -1)
		return

	if(M == user)
		user << "\red You can't heal yourself!"
		return

	if(istype(M, /mob/living/carbon/human))
		bless(M)
		user.visible_message("\red <B>[user] heals [M] with the power of [src.deity_name]!</B>")
		M << "\red May the power of [src.deity_name] compel you to be healed!"
		playsound(src.loc, "punch", 25, 1, -1)
		if(prob(50))
			user.deal_damage(10, OXY)
			user << "\blue You feel tired."
	return

/obj/item/weapon/storage/bible/afterattack(atom/A, mob/user as mob)
	if (istype(A, /turf/simulated/floor))
		user << "\blue You hit the floor with the bible."
		if(user.mind && (user.mind.assigned_role == "Chaplain"))
			call(/obj/effect/rune/proc/revealrunes)(src)
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			user << "\blue You bless [A]."
			var/water2holy = A.reagents.get_reagent_amount("water")
			A.reagents.del_reagent("water")
			A.reagents.add_reagent("holywater",water2holy)

/obj/item/weapon/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()




/obj/item/weapon/storage/bible/special
	var/faith = 0
	var/relic = 1
	var/obj/item/relic/dietyitem = null
	var/dietyitemname = null
	var/choosewhat
	var/chant = null
	var/list/effects = list("Holy Blessing", "Touch of Hope", "Seven Deadly Sins")

/obj/item/weapon/storage/bible/special/attack_self(mob/user as mob)
	var/dat = "<center>[ticker.Bible_name] <br> Proclaimed by the blessed [ticker.Bible_deity_name]</center>"
	if(relic == 3)
		dat += "<center>Relic: [dietyitemname]</center>"
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		switch(relic)
			if(1)
				dat += "<A href='byond://?src=\ref[src];op=relic'>Assign Holy Relic</A><BR>"
			if(3)
				dat += "<A href='byond://?src=\ref[src];op=effect'>Set Relic Effect</A><BR>"

		dat += "<A href='byond://?src=\ref[src];op=chant'>Add Chant/Prayer</A><BR>"
/*		if(dietyitem)
			if(dietyitem.followers)
				dat += "<A href='byond://?src=\ref[src];op=followers'>Restrict use to: No one</A><BR>"
			else
				dat += "<A href='byond://?src=\ref[src];op=followers'>Restrict use to: Followers</A><BR>"
				*/
//	user.attack_self()
		dat += "<A href='byond://?src=\ref[src];op=close'>Shut Book</A><BR>"
	else
		dat += "<center>Chants: [dietyitem.recorded]</center>"
	user << browse(dat, "window=scroll;size=400x444;border=1;can_resize=1;can_close=0;can_minimize=0")
	onclose(user, "scroll")
	return

/obj/item/weapon/storage/bible/special/Topic(href, href_list)
	usr.set_machine(src)
	switch(href_list["op"])
		if("relic")
			if(relic == 3)return
			choosewhat = 1
			usr << "Use the item you wish to represent [ticker.Bible_deity_name]'s faith onto this [ticker.Bible_name]."
			relic = 2
			usr.unset_machine()
			usr << browse(null, "window=scroll")
		if("chant")
			if(dietyitem && dietyitem.recorded)
				var/tempchant = copytext(stripped_input(usr, "Enter your deity's chant or prayer."),1,MAX_NAME_LEN)
				if(!tempchant)return
				chant = tempchant
				dietyitem.recorded.Add("[chant]")
/*		if("followers")
			if(dietyitem.followers)
				dietyitem.followers = 0
				usr << "You make it so anyone may chant at this relic."
			else
				dietyitem.followers = 1
				usr << "You make it so only followers may chant at this relic."*/
		if("effect")
			if(dietyitem)
				var/A = input(usr, "Pick an effect.", "Pick an effect") in effects
				if(A)
					religion = A
					dietyitem.on = 1
		if("close")//Self explanatory
			usr.unset_machine()
			usr << browse(null, "window=scroll")
			return
/obj/item/weapon/storage/bible/special/attackby(obj/item/W as obj, mob/living/user as mob)
	switch(choosewhat)
		if(1)
			switch(relic)
				if(0)
					playsound(src.loc, "rustle", 50, 1, -5)
					..()
				if(2)
					relic = 3
					if(W in traitoritemlist)
						usr.unlock_achievement("Dead Giveaway", 0)
					usr << "You have chosen the [W.name] as your deity's holy relic, a holy duplicate falls out of the bible."
					var/obj/item/relic/C = new/obj/item/relic
					C.name = "Relic of [ticker.Bible_deity_name]"
					C.desc = "An divine icon of [ticker.Bible_deity_name]."
					C.icon = W.icon
					C.icon_state = W.icon_state
					dietyitem = C
					dietyitemname = W.name
					C.loc = usr.loc
					dietyitem.seed = user.tox_damage + user.get_fire_loss() + user.get_brute_loss() + user.oxy_damage
					C.chaplain = usr

var/global/religion

/obj/item/relic
	var/list/recorded = list()
	var/on = 0
	var/seed = 0
	var/list/chanted = list()
	var/followers = 0
	var/randcount = 0
	var/pro = 0
	var/pro2 = 25
	var/mob/living/carbon/human/chaplain = null //WHAT DID YOU SAY!?!?!


//Nothing goes here because it is defined when the item is created.
	hear_talk(mob/living/M as mob, msg)//Hearing
		if(on == 1)//Relic is on
			if(recorded)
				if(findtext(msg, recorded))//Mob says something
					if(msg in recorded)//Make sure msg is in recorded
						if(prob(pro))//First prob check. Increases with each chant
							if(prob(pro2))//Lowers with each use until it is 5 and 10.
								pro = 0 //Reset the prob to 0 if the chant goes through
								pro2--//Remove one from prob2 to decrease the chance of it happening.
								if(pro2 <= 5)//So it never hits 0
									pro2 = 6
								switch(religion)//Controlled by bible/special
									if("Holy Blessing")
										var/x = rand(1,3)//1 and 2 are always good. 3 is nothing.
										switch(x)
											if(1)
												M.contract_disease(new/datum/symptom/booster, 0)
												M << "You feel fit as a fiddle."
											if(2)
												M << "You feel a jolt of lightning throughout your body."
												M.reagents.add_reagent("electrozene", 15)
											if(3)
												M.contract_disease(new/datum/symptom/damage_converter, 0)
												M << "You feel your body changing."
											if(4)
												M << "You feel strange..."
												M.contract_disease(new/datum/disease/fake_gbs, 0)

										return
									if("Touch of Hope")
										var/x = rand(1,3)
										switch(x)
											if(1)
												M.reagents.add_reagent("imidazoline", 15)
												M << "A divine light shows the way."
											if(2)
												M << "A divine light removes all obstructions in the mind."
												M.reagents.add_reagent("serotrotium", 15)
											if(3)
												return
									if("Seven Deadly Sins")
										var/x = rand(1,3)
										switch(x)
											if(1)//Greed, Envy, Lust
												M.deal_damage(10, OXY)
												var/obj/item/chestkey/D = new/obj/item/chestkey
												D.loc = M.loc
												D.style = 1
												M << "The souls of the dead convert a chunk of your lifeforce into an object."
											if(2)//Sloth (this is a bad one)
												for(var/obj/item/clothing/under/C in M)
													C.slowdown = 2
												M << "The souls of the dead give you a heavy conviction..."
											if(3)
												M.deal_damage(10, OXY)
												var/obj/item/chestkey/D = new/obj/item/chestkey
												D.loc = M.loc
												D.style = 2
												M << "The souls of the dead convert a chunk of your lifeforce into an object."
												return

								cooldown()
							else
								pro++

						else

							pro++
		else
			var/rendered = "<span class='game say'><span class='name'>unidentifiable voice</span> says \"[msg]\"</span>"
			chaplain.show_message(rendered, 2)



	Topic(href, href_list)
		usr.set_machine(src)
		switch(href_list["op"])
			if("followers")
				if(followers)
					followers = 0
					usr << "You make it so anyone may chant at this relic."
				else
					followers = 1
					usr << "You make it so only followers may chant at this relic."

/obj/item/relic/proc/cooldown()
	on = 0
	spawn(1000)
		on = 1