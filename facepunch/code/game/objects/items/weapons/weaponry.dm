var/global/minions
var/global/sword

/obj/item/weapon/banhammer
	desc = "A banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	attack_verb = list("banned")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life.</b>"
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)

/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of Nar-Sie's followers."
	icon_state = "nullrod"
	item_state = "nullrod"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = DAMAGE_HIGH
	w_class = 1

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 0
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hit_sound = 'sound/weapons/bladeslice.ogg'

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)


/obj/item/weapon/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 40
	forcetype = SLASH
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hit_sound = 'sound/weapons/bladeslice.ogg'

	IsShield()
		return 1

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)


/obj/item/weapon/katana
	name = "katana"
	desc = "Woefully overpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 25
	forcetype = SLASH
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hit_sound = 'sound/weapons/bladeslice.ogg'

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>"
		return(BRUTELOSS)

	IsShield()
		return 1



/obj/item/weapon/katana/samurai
	name = "samurai katana"
	var/blood
	var/reward = 0 //The stage of the rewards
	var/mob/living/person
	var/fullupgrade = 0
	force = 13
/*
	afterattack(atom/A, mob/user as mob)
		if(istype(A,/mob/living/carbon/human))
			var/mob/living/S = A
			if(!person)
				person = user
			if(user == person)
				if(!S.stat == 0)
					if(!fullupgrade)
						person << "There is no honor in bathing your blade in a dead opponent's blood!"
						return
					else
						if(S.client)
							var/mob/living/simple_animal/hostile/skel/X = new/mob/living/simple_animal/hostile/skel
							X.loc = S.loc
							X.client = S.client
							X << "You now serve [user.name] as a skeletal minion. Do as they say."
							minions += 1
							del(S)
						else
							user << "This will not work on this person."

				blood += rand(5,200)
				if(blood >= 600 && blood <= 1200 && reward == 0)
					person << "Your katanas thirst for blood gives you the 'Charge!' ability!"
					var/obj/effect/proc_holder/spell/samurai/targeted/samurai_jump/X = new /obj/effect/proc_holder/spell/samurai/targeted/samurai_jump
					person.spell_list += X
					reward = 1
				if(blood >= 1101 && blood <= 2000 && reward == 1)
					person << "Your katanas thirst for blood coats your blade in Poisoned Sake!"
					reward = 2
				if(blood >= 2201 && blood <= 3000 && reward == 3)
					person << "Your katanas thirst for blood gives you the 'Inspiration' ability!"
					var/obj/effect/proc_holder/spell/samurai/targeted/samurai_banner/C = new /obj/effect/proc_holder/spell/samurai/targeted/samurai_banner
					person.spell_list += C
					reward = 3
				if(blood >= 3101 && blood <= 4000 && reward == 4)
					person << "Your katana heats up from the amount of blood on it increasing its damage!"
					reward = 4
					force = 40
				if(blood >= 4101 && blood <= 5000 && reward == 5)
					person << "Your katana's thirst for blood gives it the ability to seal a person's soul!"
					reward = 5
				if(blood >= 7101 && blood <= 8000 && reward == 6)
					person << "Your katana is fully powered and will now anyone you kill as a skeletal minion."
					reward = 6
					fullupgrade = 1
					sword = 1

	////////////Sword effects
				if(reward >= 2)
					S.reagents.add_reagent("toxin", 1)
				if(reward >=5)
					if(!locate(NOCLONE, S.mutations))
						S.mutations |= NOCLONE
						S << "You feel your soul shattered"
	process()
		if(blood >= 200)
			blood -= rand(5,15)
*/
/obj/item/weapon/sord/skana
	name = "Skana"
	desc = "This piece of ancient Orokin technology is so unbelievably shitty you're having a hard time holding it."
	icon = 'icons/obj/warframe_objs.dmi'
	icon_state = "skana"
	force = 2