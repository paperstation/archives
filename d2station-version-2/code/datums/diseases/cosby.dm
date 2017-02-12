/datum/disease/cosby
	name = "Cosborrhea"
	max_stages = 4
	spread = "Syringe"
	cure = "Unknown"
	curable = 0
	affected_species = list("Human")
	var/cosby_transformed = 0
	var/old_name = null
	var/old_uni_identity = null
	var/list/cosby_sounds = list('cosby1.ogg', 'cosby2.ogg', 'cosby3.ogg', 'cosby4.ogg', 'cosby5.ogg')


/datum/disease/cosby/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(4))
				affected_mob << "\blue You start craving Jell-O pudding pops."
		if(2)
			if(prob(8))
				for(var/mob/M in viewers(affected_mob, null))
					if(M.client)
						M.show_message("\red <B>[affected_mob]</B> starts rambling incoherently!")
				playsound(affected_mob.loc, pick(cosby_sounds), 50, 1)
			if(prob(4))
				affected_mob << "\red You have the strong urge to lecture people about jazz music!"
			if(prob(4))
				affected_mob << "\red You REALLY crave Jell-O pudding!"
		if(3)
			if(prob(8))
				for(var/mob/M in viewers(affected_mob, null))
					if(M.client)
						M.show_message("\red <B>[affected_mob]</B> starts rambling incoherently!")
				playsound(affected_mob.loc, pick(cosby_sounds), 50, 1)
			if(prob(4))
				affected_mob << "\red You have the strong urge to lecture people about jazz music!"
			if(prob(4))
				affected_mob << "\red You REALLY crave Jell-O pudding!"
		if(4)
			if(!src.cosby_transformed)
				src.cosby_transformed = 1
				if(affected_mob.mutations & 32)
					affected_mob.nutrition = -100000
					affected_mob.mutations &= ~32
					affected_mob:update_body()
				affected_mob << "\red You suddenly feel different.."
				src.old_uni_identity = affected_mob.dna.uni_identity
				src.old_name = affected_mob.real_name
				affected_mob.dna.uni_identity = "02802802800000000000000000000240107B385"
				updateappearance(affected_mob, affected_mob.dna.uni_identity)
				affected_mob.real_name = "Bill Cosby"
				if(affected_mob:w_uniform != null)
					var/c = affected_mob:w_uniform
					if(!istype(affected_mob:w_uniform, /obj/item/clothing/under/cosby))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)
				var/obj/item/clothing/under/cosby/C = new /obj/item/clothing/under/cosby(affected_mob)
				C.cursed = 1
				affected_mob:equip_if_possible( C, affected_mob:slot_w_uniform )
			if(prob(10))
				for(var/mob/M in viewers(affected_mob, null))
					if(M.client)
						M.show_message("\red <B>[affected_mob]</B> starts rambling incoherently!")
				playsound(affected_mob.loc, pick(cosby_sounds), 50, 1)
			if(prob(4))
				affected_mob << "\red You have the strong urge to lecture people about jazz music!"
			if(prob(4))
				affected_mob << "\red You REALLY crave Jell-O pudding!"


/datum/disease/cosby/Del()
	affected_mob.dna.uni_identity = src.old_uni_identity
	var/obj/item/clothing/under/cosby/C = affected_mob:w_uniform
	affected_mob.real_name = src.old_name
	updateappearance(affected_mob, affected_mob.dna.uni_identity)
	if(affected_mob:w_uniform != null)
		if(istype(affected_mob:w_uniform, /obj/item/clothing/under/cosby))
			C.cursed = 0
	affected_mob << "\blue You feel like yourself again."
	..()