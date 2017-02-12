/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	//Icon info
	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	//Communication
	var/list/speak = list()
	var/list/speak_emote = list()//	Emotes while speaking IE: Ian [emote], [text] -- Ian barks, "WOOF!". Spoken text is generated from the speak variable.
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	universal_speak = 1//Can it understand others and be understood

	//Movement
	var/turns_per_move = 1
	var/turns_since_move = 0
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1 // Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.
	var/speed = 0 //Higher is slower lower is faster

	//Death meat production
	var/meat_amount = 0
	var/meat_type

	//Interaction
	var/response_help   = "attempts to help"
	var/response_disarm = "attempts to disarm"
	var/response_harm   = "attempts to hurt"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/temp_damage = 3//Damage if bodytemp is out of params

	//Atmos effect, 0 means disabled, things not here are trace gasses and not really worth having
	var/atmos_immune = 0//If this is set on then no atmos calcs are ran
	var/min_oxy = 5
	var/max_oxy = 0
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above


	//Attacking vars
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacks"
	var/attack_sound = null
	var/friendly = "nuzzles" //If the mob does no damage with it's attack
	var/wall_smash = 0 //if they can smash walls


	New()
		..()//This makes them get added to the mob lists
		verbs -= /mob/verb/observe//Why is this here
		return


	Login()
		if(src && src.client)
			src.client.screen = null
		..()
		return


	Life()
		//Health
		if(stat == DEAD)
			if(health > 0)
				icon_state = icon_living
				dead_mob_list -= src
				living_mob_list += src
				stat = CONSCIOUS
				density = 1
			return 0


		if(health < 1)
			Die()

		if(health > maxHealth)
			health = maxHealth

		if(weakened)
			deal_damage(-1, WEAKEN)
		if(paralysis)
			deal_damage(-1, PARALYZE)

		if(!client)
			speech()
			wander()

		//Atmos
		process_environment()

		return 1

	proc/process_environment()
		if(atmos_immune)
			return 0
		var/atmos_suitable = 1

		var/atom/A = src.loc
		if(isturf(A))
			var/turf/T = A
			var/areatemp = T.temperature
			if( abs(areatemp - bodytemperature) > 40 )
				var/diff = areatemp - bodytemperature
				diff = diff / 5
				//world << "changed from [bodytemperature] by [diff] to [bodytemperature + diff]"
				bodytemperature += diff

			if(istype(T,/turf/simulated))
				var/turf/simulated/ST = T
				if(ST.air)
					var/tox = ST.air.toxins
					var/oxy = ST.air.oxygen
					var/n2  = ST.air.nitrogen
					var/co2 = ST.air.carbon_dioxide

					if(min_oxy)
						if(oxy < min_oxy)
							atmos_suitable = 0
					if(max_oxy)
						if(oxy > max_oxy)
							atmos_suitable = 0
					if(min_tox)
						if(tox < min_tox)
							atmos_suitable = 0
					if(max_tox)
						if(tox > max_tox)
							atmos_suitable = 0
					if(min_n2)
						if(n2 < min_n2)
							atmos_suitable = 0
					if(max_n2)
						if(n2 > max_n2)
							atmos_suitable = 0
					if(min_co2)
						if(co2 < min_co2)
							atmos_suitable = 0
					if(max_co2)
						if(co2 > max_co2)
							atmos_suitable = 0
		//Atmos effect
		if((bodytemperature < minbodytemp) || (bodytemperature > maxbodytemp))
			deal_damage(temp_damage, BRUTE)

		if(!atmos_suitable)
			deal_damage(unsuitable_atoms_damage, BRUTE)
		return 1

	proc/speech()
		if(!prob(speak_chance))
			return 0
		if(speak && speak.len)
			if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
				var/length = speak.len
				if(emote_hear && emote_hear.len)
					length += emote_hear.len
				if(emote_see && emote_see.len)
					length += emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= speak.len)
					say(pick(speak))
				else
					randomValue -= speak.len
					if(emote_see && randomValue <= emote_see.len)
						emote(pick(emote_see),1)
					else
						emote(pick(emote_hear),2)
			else
				say(pick(speak))
			return 1

		if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
			var/length = emote_hear.len + emote_see.len
			var/pick = rand(1,length)
			if(pick <= emote_see.len)
				emote(pick(emote_see),1)
			else
				emote(pick(emote_hear),2)
			return 1

		if(emote_see && emote_see.len)
			emote(pick(emote_see),1)
			return 1
		if(emote_hear && emote_hear.len)
			emote(pick(emote_hear),2)
			return 1
		return 0


	proc/wander()
		if(stop_automated_movement || !wander)
			return 0
		if(!isturf(src.loc) || resting || buckled || !canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			return 0
		turns_since_move++
		if(turns_since_move < turns_per_move)
			return 0
		if((stop_automated_movement_when_pulled && pulledby)) //Soma animals don't move when pulled
			return 0
		Move(get_step(src,pick(cardinal)))
		turns_since_move = 0
		return 1


	Bumped(AM as mob|obj)
		if(!AM) return

		if(resting || buckled)
			return

		if(isturf(src.loc))
			if(ismob(AM))
				var/newamloc = src.loc
				src.loc = AM:loc
				AM:loc = newamloc
			else
				..()
		return


	gib()
		if(icon_gib)
			flick(icon_gib, src)
		if(meat_amount && meat_type)
			for(var/i = 0; i < meat_amount; i++)
				new meat_type(src.loc)
		..()
		return


	say_quote(var/text)
		if(speak_emote && speak_emote.len)
			var/emote = pick(speak_emote)
			if(emote)
				return "[emote], \"[text]\""
		return "says, \"[text]\"";


	emote(var/act)
		if(act)
			// animals can screem too if(act == "scream")	act = "makes a loud and pained whimper" //ugly hack to stop animals screaming when crushed :P
			visible_message("<B>[src]</B> [act].")


	attack_hand(mob/living/carbon/human/M as mob)
		..()
		switch(M.a_intent)
			if("help")
				if (health > 0)
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message("\blue [M] [response_help] [src]")

			if("grab")
				if (M == src)
					return
				if (!(status_flags & CANPUSH))
					return

				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M, M, src )
				M.put_in_active_hand(G)

				grabbed_by += G
				G.synch()
				LAssailant = M

				visible_message("\red [M] has grabbed [src] passively!")

			if("hurt", "disarm")
				var/damage = harm_intent_damage
				if(HULK in M.mutations)
					damage += 10
				deal_damage(damage, BRUTE, IMPACT, M.zone_sel.selecting)
				visible_message("\red [M] [response_harm] [src]")
		return


	attackby(var/obj/item/O as obj, var/mob/living/user as mob)  //Marker -Agouri
		if(istype(O, /obj/item/stack/medical))
			if(stat == DEAD)
				user << "\blue this [src] is dead, medical items won't bring it back to life."
				return

			var/obj/item/stack/medical/MED = O
			if(health < maxHealth)
				if(MED.amount >= 1)
					deal_damage(-MED.heal_brute, BRUTE, null, user.zone_sel.selecting)
					MED.amount -= 1
					if(MED.amount <= 0)
						del(MED)
					visible_message("\blue [user] applies the [MED] on [src]")
			return

		if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
			if(istype(O, /obj/item/weapon/kitchenknife) || istype(O, /obj/item/weapon/butch))
				new meat_type (get_turf(src))
				if(prob(95))
					del(src)
					return
				gib()
			return

		if(O.force)
			deal_damage(O.force, O.damtype, O.forcetype, user.get_zone())
			visible_message("\red \b [src] has been attacked with the [O.name] by [user].")
		else
			usr << "\red This weapon is ineffective, it does no damage."
			visible_message("\red [user] taps [src] with the [O.name].")
		return


	movement_delay()
		var/tally = 0 //Incase I need to add stuff other than "speed" later
		tally = speed
		return tally+config.animal_delay


	Stat()
		..()
		statpanel("Status")
		stat(null, "Health: [round((health / maxHealth) * 100)]%")


	proc/Die()
		living_mob_list -= src
		dead_mob_list += src
		icon_state = icon_dead
		stat = DEAD
		density = 0
		return


	proc/SA_attackable(target_mob)
		if (isliving(target_mob))
			var/mob/living/L = target_mob
			if(!L.stat)
				return (0)
		if (istype(target_mob,/obj/mecha))
			var/obj/mecha/M = target_mob
			if (M.occupant)
				return (0)
		return (1)