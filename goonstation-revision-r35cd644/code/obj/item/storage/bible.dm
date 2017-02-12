
var/list/bible_contents = list()

/obj/item/storage/bible
	name = "bible"
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	max_wclass = 2
	flags = FPRINT | TABLEPASS | NOSPLASH
	var/mob/affecting = null
	var/heal_amt = 10

	proc/bless(mob/M as mob)
		if (isvampire(M) || istype(M, /mob/wraith) || M.bioHolder.HasEffect("revenant"))
			M.visible_message("<span style=\"color:red\"><B>[M] burns!</span>", 1)
			var/zone = "chest"
			if (usr.zone_sel)
				zone = usr.zone_sel.selecting
			M.TakeDamage(zone, 0, heal_amt)
		else
			M.HealDamage("All", heal_amt, heal_amt)

	attackby(var/obj/item/W, var/mob/user)
		if (istype(W, /obj/item/storage/bible))
			user.show_text("You try to put \the [W] in \the [src]. It doesn't work. You feel dumber.", "red")
		else
			..()

	attack(mob/M as mob, mob/user as mob)
		var/chaplain = 0
		if (user.bioHolder && user.bioHolder.HasEffect("training_chaplain"))
			chaplain = 1
		if (!chaplain)
			boutput(user, "<span style=\"color:red\">The book sizzles in your hands.</span>")
			user.TakeDamage(user.hand == 1 ? "l_arm" : "r_arm", 0, 10)
			return
		if (user.bioHolder && user.bioHolder.HasEffect("clumsy") && prob(50))
			user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles and drops [src] on \his foot.</span>")
			random_brute_damage(user, 10)
			user.stunned += 3
			return

	//	if(..() == BLOCKED)
	//		return

		if (istype(M, /mob/wraith) || (M.bioHolder && M.bioHolder.HasEffect("revenant")))
			M.visible_message("<span style=\"color:red\"><B>[user] smites [M] with the [src]!</B></span>")
			bless(M)
			boutput(M, "<span_style=\"color:red\"><B>IT BURNS!</B></span>")
			if (narrator_mode)
				playsound(src.loc, "sound/vox/hit.ogg", 25, 1, -1)
			else
				playsound(src.loc, "punch", 25, 1, -1)
			logTheThing("combat", user, M, "was biblically smote by %target%")

		else if (M.stat != 2)
			var/mob/H = M
			// ******* Check
			if ((istype(H, /mob/living/carbon/human) && prob(60)))
				bless(M)
				M.visible_message("<span style=\"color:red\"><B>[user] heals [M] with the power of Christ!</B></span>")
				boutput(M, "<span style=\"color:red\">May the power of Christ compel you to be healed!</span>")
				if (narrator_mode)
					playsound(src.loc, "sound/vox/hit.ogg", 25, 1, -1)
				else
					playsound(src.loc, "punch", 25, 1, -1)
				logTheThing("combat", user, M, "was biblically healed by %target%")
			else
				if (ishuman(M) && !istype(M:head, /obj/item/clothing/head/helmet))
					M.take_brain_damage(10)
					boutput(M, "<span style=\"color:red\">You feel dazed from the blow to the head.</span>")
				logTheThing("combat", user, M, "was biblically injured by %target%")
				M.visible_message("<span style=\"color:red\"><B>[user] beats [M] over the head with [src]!</B></span>")
				if (narrator_mode)
					playsound(src.loc, "sound/vox/hit.ogg", 25, 1, -1)
				else
					playsound(src.loc, "punch", 25, 1, -1)
		else if (M.stat == 2)
			M.visible_message("<span style=\"color:red\"><B>[user] smacks [M]'s lifeless corpse with [src].</B></span>")
			if (narrator_mode)
				playsound(src.loc, "sound/vox/hit.ogg", 25, 1, -1)
			else
				playsound(src.loc, "punch", 25, 1, -1)
		return

	attack_hand(var/mob/user as mob)
		if (isvampire(user) || user.bioHolder.HasEffect("revenant"))
			user.visible_message("<span style=\"color:red\"><B>[user] tries to take the [src], but their hand bursts into flames!</B></span>", "<span style=\"color:red\"><b>Your hand bursts into flames as you try to take the [src]! It burns!</b></span>")
			user.TakeDamage(user.hand == 1 ? "l_arm" : "r_arm", 0, 25)
			user.stunned += 15
			user.weakened += 15
			return
		return ..()

	get_contents()
		return bible_contents

	get_all_contents()
		var/list/L = list()
		L += bible_contents
		for (var/obj/item/storage/S in bible_contents)
			L += S.get_all_contents()
		return L

	add_contents(obj/item/I)
		bible_contents += I
		I.set_loc(null)
		for (var/obj/item/storage/bible/bible in world)
			bible.hud.update() // fuck bibles

	suicide(var/mob/user as mob)
		if (!farting_allowed)
			return 0
		user.visible_message("<span style=\"color:red\">[user] farts on the bible.<br><b>A mysterious force smites [user]!</b></span>")
		user.u_equip(src)
		src.layer = initial(src.layer)
		src.set_loc(user.loc)
		user.gib()
		return 1

/obj/item/storage/bible/evil
	name = "frayed bible"

	HasEntered(atom/movable/AM as mob)
		..()
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.emote("fart")

/obj/item/storage/bible/mini
	//Grif
	name = "O.C. Bible"
	desc = "For when you don't want the good book to take up too much space in your life."
	icon_state = "minibible"
	w_class = 2