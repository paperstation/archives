#define MAX_DICE_GROUP 6
#define ROLL_WAIT_TIME 30

/obj/item/dice
	name = "die"
	desc = "A six-sided die."
	icon = 'icons/obj/items.dmi'
	icon_state = "dice"
	throwforce = 0
	w_class = 1.0
	stamina_damage = 2
	stamina_cost = 2
	var/sides = 6
	var/last_roll = null
	var/last_roll_time = null
	var/list/dicePals = list() // for combined dice rolls, up to 9 in a stack
	var/sound_roll = 'sound/misc/dicedrop.ogg'
	module_research = list("vice" = 5)
	module_research_type = /obj/item/dice
	rand_pos = 1

	get_desc()
		if (src.last_roll && !src.dicePals.len)
			if (isnum(src.last_roll))
				. += "<br>[src] currently shows [get_english_num(src.last_roll)]."
			else
				. += "<br>[src] currently shows [src.last_roll]."

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] attempts to swallow [src] and chokes on it.</b></span>")
		user.take_oxygen_deprivation(160)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

	proc/roll_dat_thang() // fine if I can't use proc/roll() then we'll all just have to suffer this
		if (src.last_roll_time && world.time < (src.last_roll_time + ROLL_WAIT_TIME))
			return
		var/roll_total = null

		if (src.sound_roll)
			playsound(get_turf(src), src.sound_roll, 100, 1)

		src.set_loc(get_turf(src))
		src.pixel_y = rand(-8,8)
		src.pixel_x = rand(-8,8)

		src.name = initial(src.name)
		src.desc = initial(src.desc)
		src.overlays = null

		if (src.sides && isnum(src.sides))
			src.last_roll = rand(1, src.sides)
			roll_total = src.last_roll
			src.visible_message("[src] shows [get_english_num(src.last_roll)].")

#ifdef HALLOWEEN
			if (last_roll == 13 && prob(5))
				var/turf/T = get_turf(src)
				for (var/obj/machinery/power/apc/apc in get_area(T))
					apc.overload_lighting()

				playsound(T, 'sound/effects/ghost.ogg', 75, 0)
				new /obj/critter/bloodling(T)
#endif

		else if (src.sides && islist(src.sides) && src.sides:len)
			src.last_roll = pick(src.sides)
			src.visible_message("[src] shows <i>[src.last_roll]</i>.")
		else
			src.last_roll = null
			src.visible_message("[src] shows... um. Something. It hurts to look at. [pick("What the fuck?", "You should probably find the chaplain.")]")

		if (src.dicePals.len)
			shuffle(src.dicePals) // so they don't all roll in the same order they went into the pile
			for (var/obj/item/dice/D in src.dicePals)
				D.set_loc(get_turf(src))
				if (prob(75))
					step_rand(D)
				roll_total += D.roll_dat_thang()
			src.dicePals = list()
			src.visible_message("<b>The total of all the dice is [roll_total < 999999 ? "[get_english_num(roll_total)]" : "[roll_total]"].</b>")
		return roll_total

	proc/addPal(var/obj/item/dice/Pal, var/mob/user as mob)
		if (!Pal || Pal == src || !istype(Pal, /obj/item/dice) || (src.dicePals.len + Pal.dicePals.len) >= MAX_DICE_GROUP)
			return 0
		if (istype(Pal.loc, /obj/item/storage))
			return 0

		src.dicePals += Pal

		if (Pal.dicePals.len)

			for (var/obj/item/dice/D in Pal.dicePals)
				if (istype(D.loc, /obj/item/storage))
					Pal.dicePals -= D
					continue
				if (ismob(D.loc))
					D.loc:u_equip(D)
				D.set_loc(src)

			src.dicePals |= Pal.dicePals // |= adds things to lists that aren't already present
			Pal.dicePals = list()

		if (ismob(Pal.loc))
			Pal.loc:u_equip(Pal)
		Pal.set_loc(src)

		var/image/die_overlay = image(Pal.icon, Pal.icon_state)
		die_overlay.pixel_y = Pal.pixel_y
		die_overlay.pixel_x = Pal.pixel_x
		src.overlays += die_overlay
		src.name = "bunch of dice"
		src.desc = "Some dice, bunched up together and ready to be thrown."
		return 1

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/dice))
			if (src.addPal(W, user))
				user.show_text("You add [W] to [src].")
		else
			return ..()

	attack_self(mob/user as mob)
		user.u_equip(src)
		src.roll_dat_thang()

	throw_impact(var/turf/T)
		..()
		src.roll_dat_thang()

	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		if (istype(O, /obj/item/dice))
			if (src.addPal(O, user))
				user.visible_message("<b>[user]</b> gathers up some dice.",\
				"You gather up some dice.")
				spawn(2)
					for (var/obj/item/dice/D in range(1, user))
						if (D == src)
							continue
						if (!src.addPal(D, user))
							break
						else
							sleep(2)
					return
		else
			return ..()

/obj/item/dice/coin // dumb but it helped test non-numeric rolls
	name = "coin"
	desc = "A little coin that will probably vanish into a couch eventually."
	icon_state = "coin-silver"
	sides = list("heads", "tails")
	sound_roll = 'sound/misc/coindrop.ogg'

/obj/item/dice/magic8ball // farte
	name = "magic 8 ball"
	desc = "Think of a yes-or-no question, shake it, and it'll tell you the answer! You probably shouldn't use it for playing an actual game of pool."
	icon_state = "8ball"
	sides = list("It is certain",\
	"It is decidedly so",\
	"Without a doubt",\
	"Yes definitely",\
	"You may rely on it",\
	"As I see it, yes",\
	"Most likely",\
	"Outlook good",\
	"Yes",\
	"Signs point to yes",\
	"Reply hazy try again",\
	"Ask again later",\
	"Better not tell you now",\
	"Cannot predict now",\
	"Concentrate and ask again",\
	"Don't count on it",\
	"My reply is no",\
	"My sources say no",\
	"Outlook not so good",\
	"Very doubtful")
	sound_roll = 'sound/items/liquid_shake.ogg'

	addPal()
		return 0

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] drop kicks the [src], but it barely moves!</b></span>")
		user.visible_message("[src] shows <i>[pick("Goodbye","You done fucked up now","Time to die","Outlook terrible","That was a mistake","You should not have done that","Foolish","Very well")]</i>.")
		user.u_equip(src)
		src.set_loc(user.loc)
		spawn(10)
			user.visible_message("<span style=\"color:red\"><b>[user] is crushed into a bloody ball by an unseen force, and vanishes into nothingness!</b></span>")
			user.implode()
		return 1

/obj/item/dice/d4
	name = "\improper D4"
	desc = "A tetrahedral die informally known as a D4."
	icon_state = "d4"
	sides = 4

/obj/item/dice/d10
	name = "\improper D10"
	desc = "A decahedral die informally known as a D10."
	icon_state = "d20"
	sides = 10

/obj/item/dice/d12
	name = "\improper D12"
	desc = "A dodecahedral die informally known as a D12."
	icon_state = "d20"
	sides = 12

/obj/item/dice/d20
	name = "\improper D20"
	desc = "An icosahedral die informally known as a D20."
	icon_state = "d20"
	sides = 20

/obj/item/dice/d100
	name = "\improper D100"
	desc = "It's not so much a die as much as it is a ball with numbers on it."
	icon_state = "d100"
	sides = 100

/obj/item/dice/d1
	name = "\improper D1"
	desc = "Uh. It has... one side? I guess? Maybe?"
	icon_state = "dice"
	sides = 1

/obj/item/dice_bot
	name = "Probability Cube"
	desc = "A device for the calculation of random probabilities. Especially ones between one and six."
	icon = 'icons/obj/items.dmi'
	icon_state = "dice"
	w_class = 1.0
	var/sides = 6
	var/last_roll = null

	New()
		..()
		name = "[initial(name)] (d[sides])"

	proc/roll_dat_thang()
		playsound(get_turf(src), "sound/misc/dicedrop.ogg", 100, 1)
		if (src.sides && isnum(src.sides))
			src.last_roll = get_english_num(rand(1, src.sides))
			src.visible_message("[src] shows [src.last_roll].")
		else
			src.last_roll = null
			src.visible_message("[src] shows... um. This isn't a number. It hurts to look at. [pick("What the fuck?", "You should probably find the chaplain.")]")

	attack_self(var/mob/user as mob)
		src.roll_dat_thang()

	d4
		icon_state = "d4"
		sides = 4
	d10
		icon_state = "d20"
		sides = 10
	d12
		icon_state = "d20"
		sides = 12
	d20
		icon_state = "d20"
		sides = 20
	d100
		icon_state = "d100"
		sides = 100

#undef MAX_DICE_GROUP