
/obj/item/spacecash
	name = "1 Credit"
	desc = "You gotta have money."
	icon = 'icons/obj/items.dmi'
	icon_state = "cashgreen"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 8
	w_class = 1.0
	burn_point = 400
	burn_possible = 1
	burn_output = 750
	health = 10
	amount = 1
	max_stack = 1000000
	stack_type = /obj/item/spacecash // so all cash types can stack iwth each other
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 1
	module_research = list("efficiency" = 1)
	module_research_type = /obj/item/spacecash

	New(var/atom/loc, var/amt = 1 as num)
		..(loc)
		amount = amt
		update_stack_appearance()

	update_stack_appearance()
		name = "[amount == max_stack ? "1000000" : amount] Credit[amount > 1 ? "s" : ""]"
		if (amount >= 1 && amount < 10)
			icon_state = "cashgreen"
		else if (amount >= 10 && amount < 50)
			icon_state = "spacecash"
		else if (amount >= 50 && amount < 500)
			icon_state = "cashblue"
		else if (amount >= 500 && amount < 1000)
			icon_state = "cashindi"
		else if (amount >= 1000 && amount < 1000000)
			icon_state = "cashpurp"
		else
			icon_state = "cashrbow"

	before_stack(atom/movable/O as obj, mob/user as mob)
		user.visible_message("<span style=\"color:blue\">[user] is stacking cash!</span>")

	after_stack(atom/movable/O as obj, mob/user as mob, var/added)
		boutput(user, "<span style=\"color:blue\">You finish stacking cash.</span>")

	failed_stack(atom/movable/O as obj, mob/user as mob, var/added)
		boutput(user, "<span style=\"color:red\">You need another stack!</span>")

	attackby(var/obj/item/I as obj, mob/user as mob)
		if (istype(I, /obj/item/spacecash) && src.amount < src.max_stack)
			if (istype(I, /obj/item/spacecash/buttcoin))
				boutput(user, "Your transaction will complete anywhere within 10 to 10e27 minutes from now.")
				return

			user.visible_message("<span style=\"color:blue\">[user] stacks some cash.</span>")
			stack_item(I)
		else
			..(I, user)

	attack_hand(mob/user as mob)
		if ((user.l_hand == src || user.r_hand == src) && user.equipped() != src)
			var/amt = round(input("How much cash do you want to take from the stack?") as num)
			if (amt && src.loc == user && !user.equipped())
				if (amt > amount || amt < 1)
					boutput(user, "<span style=\"color:red\">You wish!</span>")
					return
				change_stack_amount( 0 - amt )
				var/obj/item/spacecash/young_money = new(user.loc, amt)
				young_money.attack_hand(user)
		else
			..(user)

//	attack_self(mob/user as mob)
//		user.visible_message("fart")

/obj/item/spacecash/five
	New(var/atom/loc)
		..(loc)
		amount = 5
		update_stack_appearance()

/obj/item/spacecash/ten
	New(var/atom/loc)
		..(loc)
		amount = 10
		update_stack_appearance()

/obj/item/spacecash/twenty
	New(var/atom/loc)
		..(loc)
		amount = 20
		update_stack_appearance()

/obj/item/spacecash/fifty
	New(var/atom/loc)
		..(loc)
		amount = 50
		update_stack_appearance()

/obj/item/spacecash/hundred
	New(var/atom/loc)
		..(loc)
		amount = 100
		update_stack_appearance()

/obj/item/spacecash/fivehundred
	New(var/atom/loc)
		..(loc)
		amount = 500
		update_stack_appearance()

/obj/item/spacecash/thousand
	New(var/atom/loc)
		..(loc)
		amount = 1000
		update_stack_appearance()

/obj/item/spacecash/million
	New(var/atom/loc)
		..(loc)
		amount = 1000000
		update_stack_appearance()

/obj/item/spacecash/random
	New(var/atom/loc)
		..(loc)
		amount = rand(1,1000000)
		update_stack_appearance()

// That's what tourists spawn with.
/obj/item/spacecash/random/tourist
	New(var/atom/loc)
		..(loc)
		amount = rand(2500,6500)
		update_stack_appearance()

/obj/item/spacecash/buttcoin
	name = "buttcoin"
	desc = "The crypto-currency of the future (If you don't pay for your own electricity and got in early and don't lose the file and don't want transactions to be faster than half an hour and . . .)"
	icon_state = "cashblue"

	New()
		..()
		if (!(src in processing_items))
			processing_items.Add(src)

	update_stack_appearance()
		return

	process()
		src.amount = rand(1, 1000) / rand(10, 1000)
		if (prob(25))
			src.amount *= (rand(1,100)/100)

		if (prob(5))
			src.amount *= 10000

		name = "[amount] [pick("bit","butt","cosby ","bart", "bat", "bet", "bot")]coin[amount > 1 ? "s" : ""]"

	attack_hand(mob/user as mob)
		if ((user.l_hand == src || user.r_hand == src) && user.equipped() != src)
			var/amt = round(input("How much cash do you want to take from the stack?") as num)
			if (amt)
				if (amt > amount || amt < 1)
					boutput(user, "<span style=\"color:red\">You wish!</span>")
					return

				boutput(user, "Your transaction will complete anywhere within 10 to 10e27 minutes from now.")
		else
			..()

	attackby(var/obj/item/I as obj, mob/user as mob)
		if (istype(I, /obj/item/spacecash) && src.amount < src.max_stack)
			boutput(user, "Your transaction will complete anywhere within 10 to 10e27 minutes from now.")
		else
			..(I, user)

	disposing()
		processing_items.Remove(src)
		..()
