/datum/disease/xmas_cheer
	name = "Xmas cheer"
	max_stages = 4
	spread = SPECIAL
	cure = "Unknown"
	curable = 0
	affected_species = list("Human")
	stage_prob = 3

/datum/disease/xmas_cheer/stage_act()
	..()
	switch(stage)
		if(1 || 2)
			if(prob(5))
				playsound(affected_mob.loc, 'jinglebells.ogg', 50, 0)
				affected_mob.show_message(text("\red [] makes a strange tinkling sound!", affected_mob), 1)
			if(prob(5))
				affected_mob << "\red You're beginning to feel a lot like Christmas!"
			if(prob(5))
				affected_mob << "\red Chestnuts roasting on an open fire..."
			if(prob(5))
				affected_mob.say("HO HO HO!")
		if(3)
			if(prob(5))
				affected_mob.say("HO HO HO!")
			if(prob(5))
				affected_mob.say("Merry Christmas one and all!")
			if(prob(10))
				playsound(affected_mob.loc, 'jinglebells.ogg', 50, 0)
		if(4)
			if(prob(10))
				if(affected_mob:wear_suit != null)
					var/c = affected_mob:wear_suit
					if(!istype(affected_mob:wear_suit, /obj/item/clothing/suit/space/santa))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)

				var/obj/item/clothing/suit/space/santa/S = new(affected_mob)
				affected_mob:equip_if_possible( S, affected_mob:slot_wear_suit)

			if(prob(10))
				if(affected_mob:head != null)
					var/c = affected_mob:head

					if(!istype(affected_mob:head, /obj/item/clothing/head/helmet/space/santahat))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)
				var/obj/item/clothing/head/helmet/space/santahat/H = new (affected_mob)
				affected_mob:equip_if_possible( H, affected_mob:slot_head)


			if(prob(8))
				if( affected_mob:head && istype(affected_mob:head, /obj/item/clothing/head/helmet/space/santahat) \
				&& affected_mob:wear_suit && istype(affected_mob:wear_suit, /obj/item/clothing/suit/space/santa))
					if(!locate(/obj/item/weapon/reagent_containers/food/snacks/snowball) in affected_mob.loc)
						new/obj/item/weapon/reagent_containers/food/snacks/snowball(affected_mob.loc)

				playsound(affected_mob.loc, 'jinglebells.ogg', 50, 0)
				affected_mob.show_message(text("\red [] makes a strange tinkling sound!", affected_mob), 1)
