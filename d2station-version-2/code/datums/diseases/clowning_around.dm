/*
[23:20] <@Showtime> 6:15 PM - Something angry!: I have already stated all of my decent ideas for the hour so I guess it's time for clown disease
[23:20] <@Showtime> 6:17 PM - Something angry!: Stage 1: The patient honks when hit and begins to exhibit signs of clumsiness
[23:20] <@Showtime> 6:18 PM - Something angry!: Stage 2: The patient's hair turns orange and forms into a goofy style
[23:20] <@Showtime> 6:18 PM - Something angry!: Stage 3: The subject sprouts full clown gear.  At this point there is no cure
[23:20] <@Showtime> 6:18 PM - [LLJK] Mr. Showtime: I support that
[23:20] <@Showtime> 6:19 PM - Something angry!: Make it transmitted by banana peels or something
*/

/datum/disease/clowning_around
	name = "Clowning Around"
	max_stages = 4
	spread = "Syringe"
	spread_type = SPECIAL
	cure = "None"
	affected_species = list("Human")

/datum/disease/clowning_around/stage_act()
	..()
	switch(stage)
		if(1 || 2)
			if(prob(8))
				playsound(affected_mob.loc, 'bikehorn.ogg', 50, 1)
				affected_mob.show_message(text("\red [] makes a strange honking sound!", affected_mob), 1)
			if(prob(8))
				affected_mob << "\red You feel your feet straining!"
			if(prob(8))
				affected_mob << "\red Peels... gotta get me some peels..."
			if(prob(8))
				affected_mob.say("HONK!")
		if(3)
			if(prob(8))
				affected_mob.say("HONK HONK!!")
			if(prob(8))
				affected_mob.say("Orange you glad I didn't say banana!")
			if(prob(10))
				affected_mob.inertia_dir = affected_mob.last_move
				step(affected_mob, affected_mob.inertia_dir)
				affected_mob.stunned = 2
				affected_mob.weakened = 2
				affected_mob << "\red You feel clumsy and suddenly slip!"
			if(prob(10))
				playsound(affected_mob.loc, 'bikehorn.ogg', 50, 1)
			if(prob(10))
				if(affected_mob:wear_mask != null)
					var/c = affected_mob:wear_mask
					if(!istype(affected_mob:wear_mask, /obj/item/clothing/mask/gas/clown_hat))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)
				var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(affected_mob)
				clownmask.cursed = 1
				affected_mob:equip_if_possible( clownmask, affected_mob:slot_wear_mask) //Hope you like your new mask sucka!!!!!
		if(4)
			if(prob(10))
				if(affected_mob:wear_mask != null)
					var/c = affected_mob:wear_mask
					if(!istype(affected_mob:wear_mask, /obj/item/clothing/mask/gas/clown_hat))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)

				var/obj/item/clothing/mask/gas/clown_hat/clownmask = new /obj/item/clothing/mask/gas/clown_hat(affected_mob)
				clownmask.cursed = 1
				affected_mob:equip_if_possible( clownmask, affected_mob:slot_wear_mask)
			if(prob(10))
				if(affected_mob:w_uniform != null)
					var/c = affected_mob:w_uniform

					if(!istype(affected_mob:w_uniform, /obj/item/clothing/under/rank/clown))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)
				var/obj/item/clothing/under/rank/clown/clownsuit = new /obj/item/clothing/under/rank/clown(affected_mob)
				clownsuit.cursed = 1
				affected_mob:equip_if_possible( clownsuit, affected_mob:slot_w_uniform)
			if(prob(10))
				if(affected_mob:shoes != null)
					var/c = affected_mob:shoes
					if(!istype(affected_mob:shoes, /obj/item/clothing/shoes/clown_shoes))
						affected_mob.u_equip(c)
						if(affected_mob.client)
							affected_mob.client.screen -= c
						if(c)
							c:loc = affected_mob.loc
							c:dropped(affected_mob)
							c:layer = initial(c:layer)
				var/obj/item/clothing/shoes/clown_shoes/clownshoes = new /obj/item/clothing/shoes/clown_shoes(affected_mob)
				clownshoes.cursed = 1
				affected_mob:equip_if_possible( clownshoes, affected_mob:slot_shoes)
			if(prob(8))
				playsound(affected_mob.loc, 'bikehorn.ogg', 50, 1)
				affected_mob.show_message(text("\red [] makes a strange honking sound!", affected_mob), 1)
			if(prob(8))
				affected_mob.inertia_dir = affected_mob.last_move
				step(affected_mob, affected_mob.inertia_dir)
				affected_mob.stunned = 2
				affected_mob.weakened = 2
				affected_mob << "\red You feel clumsy and suddenly slip!"
