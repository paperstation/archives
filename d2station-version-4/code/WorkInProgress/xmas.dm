// Xmas gimmicks

// jingle bells - bikehorn replacement

/obj/item/weapon/jingle_bells
	name = "Jingle Bells"
	desc = "Jingle all the way."
	icon = 'items.dmi'
	icon_state = "jinglebells"
	item_state = "jinglebells"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0

/obj/item/weapon/jingle_bells/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'jinglebells.ogg', 50, 0)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

// snowball - custard pie replacement

/obj/item/weapon/reagent_containers/food/snacks/snowball
	name = "snowball"
	desc = "A snowball. Made of snow."
	icon_state = "snowball"
	item_state = "snowball"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

// called when thrown snowball hits a mob
/obj/item/weapon/reagent_containers/food/snacks/snowball/throw_impact(var/mob/living/L)
	L.stunned += rand(0,1)
	L.eye_blind = 2
	L.eye_blurry += 25
	L << "\red You suddenly feel cold."
	give_disease(L)
	return 1


/obj/item/weapon/reagent_containers/food/snacks/snowball/attack(mob/M as mob, mob/user as mob)
	if ((usr.mutations & 16) && prob(50))
		usr << "\red You plaster the snowball over your face."
		M.stunned += rand(0,1)
		M.eye_blind = 2
		M.eye_blurry += 25
		give_disease(M)
		return
	src.add_fingerprint(user)

	if ((user.a_intent == "hurt") && (!src.reagents))
		if (M == user)
			user << "\red <B>Stop hitting yourself! There's no snow left!</b>"
		else if ((user != M && istype(M, /mob/living/carbon)))
			user << "\red <B>You try to smush snow into [M]s face, but there is none left!</b>"
			M << "\red <B>[user] tries to smush a snowball in your face, but there's none left!</b>"
		del(src)
	else if (user.a_intent == "hurt")
		if (M == user)
			user << "\red <B>You smush the snowball into your face!</b>"
		else if ((user != M && istype(M, /mob/living/carbon)))
			user << "\red <B>You smush the snowball into [M]s face!</b>"
			M << "\red <B>[user] smushes a snowball in your face!</b>"
		M.stunned += rand(0,1)
		M.eye_blind = 2
		M.eye_blurry += 25
//		src.amount -= 1
		give_disease(M)

/obj/item/weapon/reagent_containers/food/snacks/snowball/proc/give_disease(mob/target)
	target.contract_disease(new /datum/disease/xmas_cheer)
	return

/obj/item/weapon/reagent_containers/food/snacks/snowball/On_Consume(mob/living/carbon/M as mob)
	if(!istype(M))
		M << "\blue You do not have a digestive system!"
		return 0

	if(world.timeofday < (M.last_eating+2*2))
		M << "\blue Chew your snowball like a big kid first."
		return 0

	M.last_eating = world.timeofday

//	src.amount--
	if(istype(M, /mob/living/carbon/human))
		playsound(M.loc, 'eatfood.ogg', rand(5,60), 1)

		if(prob(50))
			M << "Ugh! Brain freeze!"
			M.next_move = world.time + 15

	give_disease(M)
	if (!src.reagents)
		del(src)
	return 1


/obj/item/weapon/reagent_containers/food/snacks/candy_cane
	name = "candy cane"
	desc = "Festive and delicious!"
	icon_state = "candycane"
	item_state = "candycane"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/candy_cane/On_Consume(mob/living/carbon/M)
	. = ..(M)		// call parent proc
	if(. && prob(50))
		M.contract_disease(new /datum/disease/xmas_cheer)


/obj/item/weapon/reagent_containers/food/snacks/candy_cane/humbug
	name = "humbug"
	desc = "BAH! brand humbugs. Anti-festive and delicious!"
	icon_state = "humbug"
	item_state = "humbug"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/candy_cane/humbug/On_Consume(mob/living/carbon/M)
	. = ..(M)		// call parent proc
	if(.)
		if(M.virus && istype(M.virus, /datum/disease/xmas_cheer))
			M.resistances += M.virus.type
			M.virus = null
			M << "It's beginning to feel a lot less like Christmas."

/obj/mountainwall
	name = "wall"
	icon = 'xmas.dmi'
	icon_state = "caveroof"
	density = 1
	opacity = 1

/obj/mountainwall/Del()
	var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
	smoke.set_up(5, 0, src.loc)
	smoke.attach(src)
	smoke.start()
	src.icon_state = ""
	src.density = 0
	src.opacity = 0
	if(prob(50))
		new /obj/item/weapon/ore/slag(src.loc)
	playsound(src.loc, 'Explosion1.ogg', 50, 1, -3)
	..()

/obj/item/clothing/head/party
	name = "party hat"
	desc = "Party hat!"
	icon_state = "partyhat-red"

	red
		icon_state = "partyhat-red"
		item_state = "partyhat-red"

	blue
		icon_state = "partyhat-blue"
		item_state = "partyhat-blue"

	green
		icon_state = "partyhat-green"
		item_state = "partyhat-green"

	orange
		icon_state = "partyhat-orange"
		item_state = "partyhat-orange"

	purple
		icon_state = "partyhat-purple"
		item_state = "partyhat-purple"


/obj/decoration
	icon = 'xmas.dmi'
	name = "decoration"
	desc = "Deck the halls."

/obj/decoration/tree
	density = 1
	anchored = 1
	name = "Christmas tree"
	desc = "O Christmas tree, How richly God has decked thee!"

	icon_state = "tree"

/obj/decoration/tinsel/blue
	icon_state = "tinsel-blue"
/obj/decoration/tinsel/green
	icon_state = "tinsel-green"
/obj/decoration/tinsel/silver
	icon_state = "tinsel-silver"
/obj/decoration/tinsel/yellow
	icon_state = "tinsel-yellow"

/obj/decoration/lights
	icon_state = "lights"

/obj/decoration/banner
	icon_state = "banner"