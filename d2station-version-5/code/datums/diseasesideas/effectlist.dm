/datum/disease/effect/alien_ambryo1
	name = "Alien Embryo"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob << "\red You feel something tearing its way out of your stomach..."
		mob.toxloss += 10
		mob.updatehealth()
		if(prob(40))
			ASSERT(gibbed == 0)
			var/list/candidates = list() // Picks a random ghost in the world to shove in the larva -- TLE
			for(var/mob/dead/observer/G in mobz)
				if(G.client)
					if(G.client.be_alien)
						if(((G.client.inactivity/10)/60) <= 5)
							if(G.corpse) //hopefully will make adminaliums possible --Urist
								if(G.corpse.stat==2)
									candidates.Add(G)
							if(!G.corpse) //hopefully will make adminaliums possible --Urist
								candidates.Add(G)
			if(candidates.len)
				var/mob/dead/observer/G = pick(candidates)
				G.client.mob = new/mob/living/carbon/alien/larva(mob.loc)
			else
				if(mob.client)
					mob.client.mob = new/mob/living/carbon/alien/larva(mob.loc)
			mob.gib()
			src.cure(0)
			gibbed = 1

/datum/disease/effect/alzheimers1
	name = "Alzheimer's Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			if(prob(20))
				mob << "\red You pee yourself uncontrollably."
				new /obj/decal/cleanable/urine(mob.loc)
		if(prob(3))
			if(prob(20))
				mob << "\red You feel forgetful."
		if(prob(2))
			if(prob(20))
				mob << "\red Your muscles feel weak."
		if(prob(2))
			if(prob(20))
				mob << "\red You forget where you are."
				mob.paralysis = rand(2,4)
				teleport()
		if(prob(5) && mob.brainloss<=98)
			if(prob(20))
				mob.brainloss += 1

/datum/disease/effect/birdflu1
	name = "H5N1 Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(3))
			mob.emote("sneeze")
		if(prob(3))
			mob.emote("cough")
		if(prob(2))
			mob.emote("gasp")
		if(prob(3))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(3))
			mob << "\red Your feel tired."
			if(prob(25))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
			if(prob(15))
				mob.paralysis = rand(3,5)
		if(prob(3))
			mob << "\red Your stomach hurts."
			if(prob(25))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()

/datum/disease/effect/birdflu2
	name = "H5N1"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(3))
			mob.emote("sneeze")
		if(prob(3))
			mob.emote("cough")
		if(prob(2))
			mob.emote("gasp")
		if(prob(3))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(3))
			mob << "\red Your feel tired."
			if(prob(25))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
			if(prob(15))
				mob.paralysis = rand(3,5)
		if(prob(3))
			mob << "\red Your stomach hurts."
			if(prob(25))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
		if(prob(1))
			if(prob(5))
				playsound(mob.loc, 'poo2.ogg', 50, 1)
				for(var/mob/O in viewers(mob, null))
					O.show_message(text("\red [] has an uncontrollable diarrhea!", mob), 1)
				new /obj/item/weapon/reagent_containers/food/snacks/poo(mob.loc)
				new /obj/decal/cleanable/poo(mob.loc)

/datum/disease/effect/brainrot1
	name = "Brainrot Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob.emote("blink")
		if(prob(2))
			mob.emote("yawn")
		if(prob(2))
			mob << "\red Your don't feel quite like yourself."
		if(prob(5))
			mob.brainloss +=1
			mob.updatehealth()

/datum/disease/effect/brainrot2
	name = "Brainrot"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob.emote("stare")
		if(prob(2))
			mob.emote("drool")
		if(prob(10) && mob.brainloss<=98)//shouldn't retard you to death now
			mob.brainloss += 2
			mob.updatehealth()
			if(prob(2))
				mob << "\red Your try to remember something important...but can't."
		if(prob(10))
			mob.toxloss +=1
			mob.updatehealth()
			if(prob(2))
				mob << "\red Your head hurts."

/datum/disease/effect/brainrot3
	name = "Brainrot Final"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob.emote("stare")
		if(prob(2))
			mob.emote("drool")
		if(prob(15))
			mob.toxloss +=4
			mob.updatehealth()
			if(prob(2))
				mob << "\red Your head hurts."
		if(prob(15) && mob.brainloss<=98) //shouldn't retard you to death now
			mob.brainloss +=3
			mob.updatehealth()
			if(prob(2))
				mob << "\red Strange buzzing fills your head, removing all thoughts."
		if(prob(3))
			mob << "\red You lose consciousness..."
			for(var/mob/O in viewers(mob, null))
				O.show_message("[mob] suddenly collapses", 1)
			mob.paralysis = rand(5,10)
			if(prob(1))
				mob.emote("snore")
		if(prob(15))
			mob.stuttering += 3

/datum/disease/effect/clowning_around1
	name = "Clowning Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(8))
			playsound(mob.loc, 'bikehorn.ogg', 50, 1)
			mob.show_message(text("\red [] makes a strange honking sound!", mob), 1)
		if(prob(8))
			mob << "\red You feel your feet straining!"
		if(prob(8))
			mob << "\red Peels... gotta get me some peels..."
		if(prob(8))
			mob.say("HONK!")

/datum/disease/effect/clowning_around2
	name = "Clowning Around"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(8))
			mob.say("HONK HONK!!")
		if(prob(8))
			mob.say("Orange you glad I didn't say banana!")
		if(prob(10))
			mob.inertia_dir = mob.last_move
			step(mob, mob.inertia_dir)
			mob.stunned = 2
			mob.weakened = 2
			mob << "\red You feel clumsy and suddenly slip!"
		if(prob(10))
			playsound(mob.loc, 'bikehorn.ogg', 50, 1)
		if(prob(10))
			if(mob:wear_mask != null)
				var/c = mob:wear_mask
				if(!istype(mob:wear_mask, /obj/item/clothing/mask/gas/clown_hat))
					mob.u_equip(c)
					if(mob.client)
						mob.client.screen -= c
					if(c)
						c:loc = mob.loc
						c:dropped(mob)
						c:layer = initial(c:layer)
			var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(mob)
			clownmask.cursed = 1
			mob:equip_if_possible( clownmask, mob:slot_wear_mask) //Hope you like your new mask sucka!!!!!

/datum/disease/effect/clowning_around3
	name = "Clowning Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(10))
			if(mob:wear_mask != null)
				var/c = mob:wear_mask
				if(!istype(mob:wear_mask, /obj/item/clothing/mask/gas/clown_hat))
					mob.u_equip(c)
					if(mob.client)
						mob.client.screen -= c
					if(c)
						c:loc = mob.loc
						c:dropped(mob)
						c:layer = initial(c:layer)

			var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(mob)
			clownmask.cursed = 1
			mob:equip_if_possible( clownmask, mob:slot_wear_mask)
		if(prob(10))
			if(mob:w_uniform != null)
				var/c = mob:w_uniform

				if(!istype(mob:w_uniform, /obj/item/clothing/under/rank/clown))
					mob.u_equip(c)
					if(mob.client)
						mob.client.screen -= c
					if(c)
						c:loc = mob.loc
						c:dropped(mob)
						c:layer = initial(c:layer)
			var/obj/item/clothing/under/rank/clown/clownsuit = new /obj/item/clothing/under/rank/clown(mob)
			clownsuit.cursed = 1
			mob:equip_if_possible( clownsuit, mob:slot_w_uniform)
		if(prob(10))
			if(mob:shoes != null)
				var/c = mob:shoes
				if(!istype(mob:shoes, /obj/item/clothing/shoes/clown_shoes))
					mob.u_equip(c)
					if(mob.client)
						mob.client.screen -= c
					if(c)
						c:loc = mob.loc
						c:dropped(mob)
						c:layer = initial(c:layer)
			var/obj/item/clothing/shoes/clown_shoes/clownshoes = new /obj/item/clothing/shoes/clown_shoes(mob)
			clownshoes.cursed = 1
			mob:equip_if_possible( clownshoes, mob:slot_shoes)
		if(prob(8))
			playsound(mob.loc, 'bikehorn.ogg', 50, 1)
			mob.show_message(text("\red [] makes a strange honking sound!", mob), 1)
		if(prob(8))
			mob.inertia_dir = mob.last_move
			step(mob, mob.inertia_dir)
			mob.stunned = 2
			mob.weakened = 2
			mob << "\red You feel clumsy and suddenly slip!"

/datum/disease/effect/cold1
	name = "Cold Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("sneeze")
		if(prob(5))
			mob.emote("cough")
		if(prob(10))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(10))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.updatehealth()
/*
/datum/disease/effect/dna_spread1
	name = "Retrovirus"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if ((!strain_data["name"]) || (!strain_data["UI"]) || (!strain_data["SE"]))
			del(mob.virus)
			return
		//Save original dna for when the disease is cured.
		src.original_dna["name"] = mob.real_name
		src.original_dna["UI"] = mob.dna.uni_identity
		src.original_dna["SE"] = mob.dna.struc_enzymes
		mob << "\red You don't feel like yourself.."
		mob.dna.uni_identity = strain_data["UI"]
		updateappearance(mob, mob.dna.uni_identity)
		mob.dna.struc_enzymes = strain_data["SE"]
		mob.real_name = strain_data["name"]
		domutcheck(mob)
		src.transformed = 1
*/
/datum/disease/effect/donkvirus1
	name = "Donk Onset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		ticker.mode.equip_traitor(mob)
		ticker.mode.traitors += mob.mind
		mob.mind.special_role = "traitor"
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = mob.mind
		steal_objective.target_name = "nuclear authentication disk"
		steal_objective.steal_target = /obj/item/weapon/disk/nuclear
		steal_objective.explanation_text = "Steal a [steal_objective.target_name]."
		mob.mind.objectives += steal_objective
		var/datum/objective/hijack/hijack_objective = new
		hijack_objective.owner = mob.mind
		mob.mind.objectives += hijack_objective
		mob << "<B>You are the traitor.</B>"
		var/obj_count = 1
		for(var/datum/objective/OBJ in mob.mind.objectives)
			mob << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
			obj_count++
		new /obj/item/weapon/pinpointer(mob.loc)

/datum/disease/effect/ebola1
	name = "Ebola Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
		if(prob(1))
			mob << "\red You feel weak."
		if(prob(10))
			mob.bruteloss += 10
			mob.bodytemperature += 3
			mob.fireloss++
			mob.updatehealth()
		if(prob(1))
			mob << "\red Your muscles ache."
			if(prob(10))
				mob.toxloss += 1
				mob.updatehealth()

/datum/disease/effect/ebola2
	name = "Ebola"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
		if(prob(1))
			mob << "\red Your muscles ache."
		if(prob(3))
			mob.bruteloss += 20
			mob.updatehealth()
		if(prob(5))
			mob.stunned += rand(1,2)
			mob.weakened += rand(1,2)
			mob.bodytemperature += 20
			mob.fireloss++
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 5
				mob.updatehealth()
		if(prob(7))
			new /obj/decal/cleanable/blood(mob.loc)

/datum/disease/effect/ebola3
	name = "Ebola Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(10))
			mob.bruteloss += 65
			mob.toxloss += 10
			mob.updatehealth()
		if(prob(10))
			mob.bodytemperature += 100
			mob.fireloss++
			mob.updatehealth()

/datum/disease/effect/fake_gbs1
	name = "GBS Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
		else if(prob(5))
			mob.emote("gasp")
		if(prob(10))
			mob << "\red You're starting to feel very weak..."

/datum/disease/effect/flu1
	name = "H13N1 Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("sneeze")
		if(prob(5))
			mob.emote("cough")
		if(prob(5))
			mob << "\red Your throat feels sore."
		if(prob(5))
			mob << "\red Mucous runs down the back of your throat."

/datum/disease/effect/gastric_ejections1
	name = "Gastric Ejection Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(6))
			mob << "You feel your stomach rumble."
		else if (prob(5))
			mob.emote("shiver")

/datum/disease/effect/gastric_ejections2
	name = "Gastric Ejections"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(8))
			mob.emote("shiver")
		else if (prob(10))
			playsound(mob.loc, 'poo2.ogg', 50, 1)
			for(var/mob/O in viewers(mob, null))
				O.show_message(text("\red [] lets out a foul-smelling fart!", mob), 1)

/datum/disease/effect/gastric_ejections3
	name = "Gastric Ejections Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(10))
			mob.emote("groan")
		else if (prob(8))
			playsound(mob.loc, 'poo2.ogg', 50, 1)
			for(var/mob/O in viewers(mob, null))
				O.show_message(text("\red [] farts, leaking diarrhea down their legs!", mob), 1)
			new /obj/decal/cleanable/poo(mob.loc)
		else if (prob(2))
			for(var/mob/O in viewers(mob, null))
				O.show_message(text("\red [] keels over in pain!", mob), 1)
			mob.toxloss += 1
			mob.updatehealth()
			mob.stunned += rand(1,3)
			mob.weakened += rand(1,3)

/datum/disease/effect/gastric_ejections4
	name = "Gastric Ejections Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(8))
			playsound(mob.loc, 'poo2.ogg', 50, 1)
			for(var/mob/O in viewers(mob, null))
				O.show_message(text("\red []'s [] explodes violently with diarrhea!", mob, pick("butt", "ass", "behind", "hindquarters")), 1)
			new /obj/decal/cleanable/poo(mob.loc)
		else if (prob(2))
			for(var/mob/O in viewers(mob, null))
				O.show_message(text("\red [] keels over in pain!", mob), 1)
			mob.toxloss += 1
			mob.updatehealth()
			mob.stunned += rand(2,4)
			mob.weakened += rand(2,4)

/datum/disease/effect/gay1
	name = "The Serious Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob:l_hand, /obj/item/weapon))
			if(!mob:l_hand.gay)
				mob:l_hand.gay = 1
		if(istype(mob:r_hand, /obj/item/weapon))
			if(!mob:r_hand.gay)
				mob:r_hand.gay = 1

		if(mob.stat >= 1)
			return

		if(mob:w_uniform == null)
			var/area/partay = mob.loc.loc
			if(partay.party || partay.name == "Space")
				return
			partay.party = 1
			partay.updateicon()
			partay.mouse_opacity = 0
			mob.say(pick(phrases))

			spawn(100)
				partay.party = 0
				partay.updateicon()

			for(var/mob/M in partay)
				if(istype(M.virus, /datum/disease/gay && prob(5))) //cuts down on spam
					M.say(pick(gayphrases))

			if(prob(5))
				if(mob:w_uniform != null)
					var/c = mob:w_uniform
					if(c)
						mob.u_equip(c)
						if(mob.client)
							mob.client.screen -= c
						if(c)
							c:loc = mob.loc
							c:layer = initial(c:layer)
				if(prob(25))
					mob.say("DEBATE ON")
				else if(prob(25))
					mob.say(":gay:")

			if(prob(20))
				for(var/mob/M in range(2, mob))
					if (M.virus != null && M.virus == /datum/disease/gay)
						if(mob:w_uniform != null)
							var/c = mob:w_uniform
							mob.u_equip(c)
							if(mob.client)
								mob.client.screen -= c
							if(c)
								c:loc = mob.loc
						if(M:w_uniform != null)
							var/c = M:w_uniform
							M.u_equip(c)
							if(M.client)
								M.client.screen -= c
							if(M:w_uniform)
								c:loc = mob.loc
						mob.say("You're so thexy, [M]!")
						M.say("Nice chetht, [mob]!")

/datum/disease/effect/gbs1
	name = "GBS+ Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(45))
			mob.toxloss += 5
			mob.updatehealth()
		if(prob(1))
			mob.emote("sneeze")

/datum/disease/effect/gbs2
	name = "GBS+"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
		else if(prob(5))
			mob.emote("gasp")
		if(prob(10))
			mob << "\red You're starting to feel very weak..."
/*
/datum/disease/effect/gbs3()
	name = "GBS+ Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.emote("cough")
		mob.toxloss += 5
		mob.updatehealth()
*/
/datum/disease/effect/gbs4
	name = "GBS+ Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob << "\red Your body feels as if it's trying to rip itself open..."
		if(prob(50))
			mob.gib()

/datum/disease/effect/inhalational_anthrax1
	name = "Anthrax Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob.emote("sneeze")
		if(prob(1))
			mob.emote("cough")
		if(prob(1))
			mob << "\red Your body aches."
		if(prob(5))
			mob.bruteloss += 2
			mob.bodytemperature += 3
			mob.fireloss++
			mob.updatehealth()
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(10))
				mob.toxloss += 5
				mob.updatehealth()

/datum/disease/effect/inhalational_anthrax2
	name = "Anthrax Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob.emote("sneeze")
			new /obj/decal/cleanable/blood(mob.loc)
		if(prob(1))
			mob.emote("cough")
			new /obj/decal/cleanable/blood(mob.loc)
		if(prob(1))
			mob << "\red Your muscles ache."
		if(prob(10))
			mob.bruteloss += 20
			mob.updatehealth()
		if(prob(5))
			mob.stunned += rand(2,5)
			mob.weakened += rand(2,5)
			mob.bodytemperature += 20
			mob.fireloss++
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 10
				mob.updatehealth()

/datum/disease/effect/inhalational_anthrax3
	name = "Anthrax Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(10))
			mob.bruteloss += 65
			mob.toxloss += 10
			mob.bodytemperature += 50
			mob.fireloss++
			mob.updatehealth()

/datum/disease/effect/magnitis1
	name = "Magnitis Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob << "\red You feel a slight shock course through your body."
		if(prob(2))
			for(var/obj/M in orange(2,mob))
				if(!M.anchored && (M.flags & CONDUCT))
					step_towards(M,mob)
			for(var/mob/living/silicon/S in orange(2,mob))
				if(istype(S, /mob/living/silicon/ai)) continue
				step_towards(S,mob)

/datum/disease/effect/magnitis2
	name = "Magnitis Major"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob << "\red You feel a strong shock course through your body."
		if(prob(2))
			mob << "\red You feel like clowning around."
		if(prob(4))
			for(var/obj/M in orange(4,mob))
				if(!M.anchored && (M.flags & CONDUCT))
					var/i
					var/iter = rand(1,2)
					for(i=0,i<iter,i++)
						step_towards(M,mob)
			for(var/mob/living/silicon/S in orange(4,mob))
				if(istype(S, /mob/living/silicon/ai)) continue
				var/i
				var/iter = rand(1,2)
				for(i=0,i<iter,i++)
					step_towards(S,mob)

/datum/disease/effect/magnitis3
	name = "Magnitis Outset"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob << "\red You feel a powerful shock course through your body."
		if(prob(2))
			mob << "\red You query upon the nature of miracles."
		if(prob(8))
			for(var/obj/M in orange(6,mob))
				if(!M.anchored && (M.flags & CONDUCT))
					var/i
					var/iter = rand(1,3)
					for(i=0,i<iter,i++)
						step_towards(M,mob)
			for(var/mob/living/silicon/S in orange(6,mob))
				if(istype(S, /mob/living/silicon/ai)) continue
				var/i
				var/iter = rand(1,3)
				for(i=0,i<iter,i++)
					step_towards(S,mob)

/datum/disease/effect/mochashakah1
	name = "B14K Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob.emote("sneeze")
		if(prob(1))
			mob.emote("cough")
		if(prob(1))
			mob.emote("gasp")
		if(prob(1))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your feel tired."
			if(prob(20))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
			if(prob(10))
				mob.paralysis = rand(3,5)
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()

/datum/disease/effect/mochashakah2
	name = "B14K Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob.emote("sneeze")
		if(prob(1))
			mob.emote("cough")
		if(prob(1))
			mob.emote("gasp")
		if(prob(1))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your head hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your feel tired."
			if(prob(20))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
			if(prob(10))
				mob.paralysis = rand(3,5)
		if(prob(1))
			mob << "\red You feel like rapping."
		if(prob(1))
			mob << "\red You feel like playing basketball."
		if(prob(1))
			mob << "\red You feel like listening to rap music."
		if(prob(1))
			mob << "\red You have an unusual craving for Kool-Aid."
		if(prob(1))
			mob << "\red You have an unusual craving for fried chicken."
		if(prob(1))
			mob << "\red You have an unusual craving for watermelon."
		if(prob(50))
			mob:s_tone--
			mob:update_body()

/datum/disease/effect/mochashakah3
	name = "B14K Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(20))
			mob:s_tone = -200
			mob:update_body()
		if(prob(1))
			if(prob(20))
				mob.say(pick("thug life!", "i'm black y'all", "that's racist, fool", "sup bitches", "what up yo", "mofo", "sup dawg", "them hoes yo"))

/datum/disease/effect/pierrot_throat1
	name = "Pierrot's Throat Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5)) mob.say("HONK!")

/datum/disease/effect/plague1
	name = "Plague Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(45))
			mob.toxloss += 5
			mob.updatehealth()
		if(prob(10))
			mob << "\red You feel swollen..."

/datum/disease/effect/plague2
	name = "Plague Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
		else if(prob(5))
			mob.emote("gasp")
		if(prob(3))
			mob.emote("sneeze")
		if(prob(1))
			mob << "\red You feel very sick..."

/datum/disease/effect/plague3
	name = "Plague Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(2))
			mob.emote("cough")
		else if(prob(5))
			mob.emote("gasp")
		if(prob(3))
			mob.emote("sneeze")
		if(prob(4))
			mob.emote("cough")
			mob.toxloss += 5
			mob.bruteloss += 5
			mob.updatehealth()

/datum/disease/effect/plague4
	name = "Plague Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
			new /obj/decal/cleanable/blood(mob.loc)
			mob.bruteloss += 5
		else if(prob(5))
			mob.emote("gasp")
		if(prob(1))
			mob.emote("sneeze")
		if(prob(5))
			mob.emote("sneeze")
		if(prob(5))
			mob.bruteloss += 30
			mob.toxloss += 30
			mob.stunned += rand(2,4)
			mob.weakened += rand(2,4)
			mob.updatehealth()

/datum/disease/effect/rhumba_beat1
	name = "Rhumba Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(45))
			mob.toxloss += 3
			mob.updatehealth()
		if(prob(1))
			mob << "\red You feel strange..."

/datum/disease/effect/rhumba_beat2
	name = "Rhumba Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob << "\red You feel the urge to dance..."
		else if(prob(5))
			mob.emote("gasp")
		else if(prob(10))
			mob << "\red You feel the need to chick chicky boom..."

/datum/disease/effect/rhumba_beat3
	name = "Rhumba Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(10))
			mob.emote("gasp")
			mob << "\red You feel a burning beat inside..."
		if(prob(20))
			mob.toxloss += 5
			mob.updatehealth()

/datum/disease/effect/rhumba_beat4
	name = "Rhumba Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob << "\red Your body is unable to contain the Rhumba Beat..."
		if(prob(50))
			mob.gib()

/datum/disease/effect/robotic_transformation1
	name = "RoboTransform Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(8))
			mob << "Your joints feel stiff."
			mob.bruteloss += 1
			mob.updatehealth()
		if (prob(9))
			mob << "\red Beep...boop.."
		if (prob(9))
			mob << "\red Bop...beeep..."

/datum/disease/effect/robotic_transformation2
	name = "RoboTransform Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(8))
			mob << "\red Your joints feel very stiff."
			mob.bruteloss += 1
			mob.updatehealth()
		if (prob(8))
			mob.say(pick("Beep, boop", "beep, beep!", "Boop...bop"))
		if (prob(10))
			mob << "Your skin feels loose."
			mob.bruteloss += 5
			mob.updatehealth()
		if (prob(4))
			mob << "\red You feel a stabbing pain in your head."
			mob.paralysis += 2
		if (prob(4))
			mob << "\red You can feel something move...inside."

/datum/disease/effect/robotic_transformation3
	name = "RoboTransform Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(10))
			mob << "\red Your skin feels very loose."
			mob.bruteloss += 8
			mob.updatehealth()
		if (prob(20))
			mob.say(pick("beep, beep!", "Boop bop boop beep.", "kkkiiiill mmme", "I wwwaaannntt tttoo dddiiieeee..."))
		if (prob(8))
			mob << "\red You can feel... something...inside you."

/datum/disease/effect/robotic_transformation4
	name = "RoboTransform Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob <<"\red Your skin feels as if it's about to burst off..."
		mob.toxloss += 10
		mob.updatehealth()
		if(prob(40)) //So everyone can feel like robot Seth Brundle
			ASSERT(src.gibbed == 0)
			var/turf/T = find_loc(mob)
			gibs(T)
			src.cure(0)
			gibbed = 1
			mob:Robotize()

/datum/disease/effect/squirts1
	name = "Squirts Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(3))
			mob.emote("shiver")

/datum/disease/effect/squirts2
	name = "Squirts Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(3))
			mob.emote("shiver")
			new /obj/decal/cleanable/blood/splatter(mob.loc)

/datum/disease/effect/squirts3
	name = "Squirts Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(3))
			mob.emote("shiver")
			new /obj/decal/cleanable/blood/splatter(mob.loc)
		else if (prob(3))
			mob.emote("twitch")
			new /obj/decal/cleanable/blood(mob.loc)

/datum/disease/effect/squirts4
	name = "Squirts Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(3))
			mob.emote("twitch")
			new /obj/decal/cleanable/blood(mob.loc)
			mob.toxloss += 1
			mob.updatehealth()

/datum/disease/effect/swineflu1
	name = "H1N1 Onset"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob.emote("sneeze")
		if(prob(1))
			mob.emote("cough")
		if(prob(1))
			mob.emote("gasp")
		if(prob(1))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your feel tired."
			if(prob(20))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
			if(prob(10))
				mob.paralysis = rand(3,5)
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()

/datum/disease/effect/swineflu2
	name = "H1N1 Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob.emote("sneeze")
		if(prob(1))
			mob.emote("cough")
		if(prob(1))
			mob.emote("gasp")
		if(prob(1))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.bruteloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your head hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 1
				mob.updatehealth()
		if(prob(1))
			mob << "\red Your feel tired."
			if(prob(20))
				mob.toxloss += 1
				mob.bodytemperature += 1
				mob.updatehealth()
			if(prob(10))
				mob.paralysis = rand(3,5)
		if(prob(1))
			if(prob(3))
				playsound(mob.loc, 'poo2.ogg', 50, 1)
				for(var/mob/O in viewers(mob, null))
					O.show_message(text("\red [] has an uncontrollable diarrhea!", mob), 1)
				new /obj/item/weapon/reagent_containers/food/snacks/poo(mob.loc)
				new /obj/decal/cleanable/poo(mob.loc)

/datum/disease/effect/tvirus1
	name = "Tyrant Minor"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(1))
			mob << "\red You feel hungry."
		if(prob(5))
			mob.bruteloss += 3
			mob.bodytemperature += 1
			mob.fireloss++
			mob.updatehealth()
		if(prob(1))
			mob << "\red Your muscles ache."
			if(prob(20))
				mob.toxloss += 1
				mob.updatehealth()

/datum/disease/effect/tvirus2
	name = "Tyrant Major"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.emote("cough")
		if(prob(1))
			mob << "\red Your muscles ache."
		if(prob(4))
			mob.bruteloss += 10
			mob.updatehealth()
		if(prob(8))
			mob.bodytemperature += 5
			mob.fireloss++
		if(prob(1))
			mob << "\red Your stomach hurts."
			if(prob(20))
				mob.toxloss += 5
				mob.updatehealth()
		if(prob(50))
			new /obj/livestock/zombie(mob.loc)
			mob.gib()

/datum/disease/effect/wizarditis1
	name = "Wizarditis Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(4))
			mob.say(pick("You shall not pass!", "Expeliarmus!", "By Merlins beard!", "Feel the power of the Dark Side!"))
		if(prob(2))
			mob << "\red You feel [pick("that you don't have enough mana.", "that the winds of magic are gone.", "an urge to summon a familiar.")]"

/datum/disease/effect/wizarditis2
	name = "Wizarditis Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		spawn_wizard_clothes(5)
		if(prob(4))
			mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!", "STI KALY!", "TARCOL MINTI ZHERI!"))
		if(prob(2))
			mob << "\red You feel [pick("the magic bubbling in your veins","that this location gives you a +1 to INT","an urge to summon a familiar.")]."

/datum/disease/effect/wizarditis3
	name = "Wizarditis Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		spawn_wizard_clothes(10)
		if(prob(4))
			mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!","STI KALY!","EI NATH!"))
			return
		if(prob(2))
			mob << "\red You feel [pick("the tidal wave of raw power building inside","that this location gives you a +2 to INT and +1 to WIS","an urge to teleport")]."
		if(prob(2))
			teleport()

/datum/disease/spawn_wizard_clothes(var/chance=5)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		if(prob(chance))
			if(!istype(H.head, /obj/item/clothing/head/wizard))
				if(H.head)
					H.drop_from_slot(H.head)
				H.head = new /obj/item/clothing/head/wizard(H)
				H.head.layer = 20
			return
		if(prob(chance))
			if(!istype(H.wear_suit, /obj/item/clothing/suit/wizrobe))
				if(H.wear_suit)
					H.drop_from_slot(H.wear_suit)
				H.wear_suit = new /obj/item/clothing/suit/wizrobe(H)
				H.wear_suit.layer = 20
			return
		if(prob(chance))
			if(!istype(H.shoes, /obj/item/clothing/shoes/sandal))
				if(H.shoes)
					H.drop_from_slot(H.shoes)
				H.shoes = new /obj/item/clothing/shoes/sandal(H)
				H.shoes.layer = 20
			return
	else
		var/mob/living/carbon/H = mob
		if(prob(chance))
			if(!istype(H.r_hand, /obj/item/weapon/staff))
				if(H.r_hand)
					H.drop_from_slot(H.r_hand)
				H.r_hand = new /obj/item/weapon/staff(H)
				H.r_hand.layer = 20
			return
	return

/datum/disease/teleport()
	var/list/theareas = new/list()
	for(var/area/AR in orange(80, mob))
		if(theareas.Find(AR) || AR.name == "Space") continue
		theareas += AR
	if(!theareas)
		return
	var/area/thearea = pick(theareas)
	var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
	smoke.set_up(5, 0, mob.loc)
	smoke.attach(mob)
	smoke.start()
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		if(T.z != mob.z) continue
		if(T.name == "space") continue
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T
	if(!L)
		return
	mob.say("SCYAR NILA [uppertext(thearea.name)]!")
	mob.loc = pick(L)
	smoke.start()
	return

/datum/disease/effect/xeno_transformation1
	name = "XenoMorph Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(8))
			mob << "Your throat feels scratchy."
			mob.bruteloss += 1
			mob.updatehealth()
		if (prob(9))
			mob << "\red Kill..."
		if (prob(9))
			mob << "\red Kill..."

/datum/disease/effect/xeno_transformation2
	name = "XenoMorph Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(8))
			mob << "\red Your throat feels very scratchy."
			mob.bruteloss += 1
			mob.updatehealth()
		if (prob(10))
			mob << "Your skin feels tight."
			mob.bruteloss += 5
			mob.updatehealth()
		if (prob(4))
			mob << "\red You feel a stabbing pain in your head."
			mob.paralysis += 2
		if (prob(4))
			mob << "\red You can feel something move...inside."

/datum/disease/effect/xeno_transformation3
	name = "XenoMorph Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(10))
			mob << pick("\red Your skin feels very tight.", "\red Your blood boils!")
			mob.bruteloss += 8
			mob.updatehealth()
		if (prob(20))
			mob.say(pick("You look delicious.", "Going to... devour you...", "Hsssshhhhh!"))
		if (prob(8))
			mob << "\red You can feel... something...inside you."

/datum/disease/effect/xeno_transformation4
	name = "XenoMorph Outset"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob <<"\red Your skin feels impossibly calloused..."
		mob.toxloss += 10
		mob.updatehealth()
		if(prob(40))
			ASSERT(gibbed == 0)
			var/turf/T = find_loc(mob)
			gibs(T)
			src.cure(0)
			gibbed = 1
			mob:Alienize()

/datum/disease/effect/xmas_cheer1
	name = "XMas Cheer Onset"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			playsound(mob.loc, 'jinglebells.ogg', 50, 0)
			mob.show_message(text("\red [] makes a strange tinkling sound!", mob), 1)
		if(prob(5))
			mob << "\red You're beginning to feel a lot like Christmas!"
		if(prob(5))
			mob << "\red Chestnuts roasting on an open fire..."
		if(prob(5))
			mob.say("HO HO HO!")

/datum/disease/effect/xmas_cheer2
	name = "XMas Cheer Minor"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(5))
			mob.say("HO HO HO!")
		if(prob(5))
			mob.say("Merry Christmas one and all!")
		if(prob(10))
			playsound(mob.loc, 'jinglebells.ogg', 50, 0)

/datum/disease/effect/xmas_cheer3
	name = "XMas Cheer Major"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(prob(10))
			if(mob:wear_suit != null)
				var/c = mob:wear_suit
				if(!istype(mob:wear_suit, /obj/item/clothing/suit/space/santa))
					mob.u_equip(c)
					if(mob.client)
						mob.client.screen -= c
					if(c)
						c:loc = mob.loc
						c:dropped(mob)
						c:layer = initial(c:layer)
			var/obj/item/clothing/suit/space/santa/S = new(mob)
			mob:equip_if_possible( S, mob:slot_wear_suit)
		if(prob(10))
			if(mob:head != null)
				var/c = mob:head
				if(!istype(mob:head, /obj/item/clothing/head/helmet/space/santahat))
					mob.u_equip(c)
					if(mob.client)
						mob.client.screen -= c
					if(c)
						c:loc = mob.loc
						c:dropped(mob)
						c:layer = initial(c:layer)
			var/obj/item/clothing/head/helmet/space/santahat/H = new (mob)
			mob:equip_if_possible( H, mob:slot_head)
		if(prob(8))
			if( mob:head && istype(mob:head, /obj/item/clothing/head/helmet/space/santahat) \
			&& mob:wear_suit && istype(mob:wear_suit, /obj/item/clothing/suit/space/santa))
				if(!locate(/obj/item/weapon/reagent_containers/food/snacks/snowball) in mob.loc)
					new/obj/item/weapon/reagent_containers/food/snacks/snowball(mob.loc)
			playsound(mob.loc, 'jinglebells.ogg', 50, 0)
			mob.show_message(text("\red [] makes a strange jingling sound!", mob), 1)

/datum/disease/effect/gibbingtons
	name = "Gibbingtons Syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.gib()

/datum/disease/effect/radian
	name = "Radian's syndrome"
	stage = 4
	maxm = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.radiation += (2*multiplier)

/datum/disease/effect/toxins
	name = "Hyperacid Syndrome"
	stage = 3
	maxm = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.toxloss += (2*multiplier)

/datum/disease/effect/scream
	name = "Random screaming syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*scream")

/datum/disease/effect/drowsness
	name = "Automated sleeping syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.drowsyness += 10

/datum/disease/effect/shakey
	name = "World Shaking syndrome"
	stage = 3
	maxm = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		shake_camera(mob,5*multiplier)

/datum/disease/effect/deaf
	name = "Hard of hearing syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.ear_deaf += 20

/datum/disease/effect/invisible
	name = "Waiting Syndrome"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		return

/datum/disease/effect/telepathic
	name = "Telepathy Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.mutations |= 512

/datum/disease/effect/noface
	name = "Identity Loss syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.real_name = "Unknown"

/datum/disease/effect/monkey
	name = "Monkism syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob,/mob/living/carbon/human))
			var/mob/living/carbon/human/h = mob
			h.monkeyize()

/datum/disease/effect/sneeze
	name = "Coldingtons Effect"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*sneeze")

/datum/disease/effect/gunck
	name = "Flemmingtons"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob << "\red Mucous runs down the back of your throat."

/datum/disease/effect/killertoxins
	name = "Toxification syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.toxloss += 15

/datum/disease/effect/hallucinations
	name = "Hallucinational Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
//		mob.hallucination += 25

/datum/disease/effect/sleepy
	name = "Resting syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*collapse")

/datum/disease/effect/mind
	name = "Lazy mind syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.brainloss += 20

/datum/disease/effect/suicide
	name = "Suicidal syndrome"
	stage = 4
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(mob) << "\red <b>[mob.name] is holding \his breath. It looks like \he's trying to commit suicide.</b>"
		mob.oxyloss = max(75 - mob.toxloss - mob.fireloss - mob.bruteloss, mob.oxyloss)
		mob.updatehealth()
		spawn(200) //in case they get revived by cryo chamber or something stupid like that, let them suicide again in 20 seconds
			mob.suiciding = 0