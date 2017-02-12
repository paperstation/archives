// GIFTS

/obj/item/wrapping_paper
	name = "wrapping paper"
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper-r"
	amount = 20.0
	desc = "Used for wrapping gifts. Its got a neat design!"
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 1
	var/style = "r"

	New()
		..()
		src.style = pick("r", "rs", "g", "gs")
		src.icon_state = "wrap_paper-[src.style]"

/obj/item/wrapping_paper/attackby(obj/item/W as obj, mob/user as mob)
	if (!( locate(/obj/table, src.loc) ))
		boutput(user, "<span style=\"color:blue\">You MUST put the paper on a table!</span>")
		return
	if (W.w_class < 4)
		if (user.find_type_in_hand(/obj/item/wirecutters) || user.find_type_in_hand(/obj/item/scissors))
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				boutput(user, "<span style=\"color:blue\">You need more paper!</span>")
				return
			else
				src.amount -= a_used
				user.drop_item()
				var/obj/item/gift/G = new /obj/item/gift(src.loc)
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = "gift[minmax(G.size, 1, 3)]-[src.style]"
				G.gift = W
				W.set_loc(G)
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
				modify_christmas_cheer(1)
				user.put_in_hand_or_drop(G)
			if (src.amount <= 0)
				user.u_equip(src)
				var/obj/item/c_tube/C = new /obj/item/c_tube(src.loc)
				user.put_in_hand_or_drop(C)
				qdel(src)
				return
		else
			boutput(user, "<span style=\"color:blue\">You need something to cut [src] with!</span>")
	else
		boutput(user, "<span style=\"color:blue\">The object is FAR too large!</span>")
	return

/obj/item/wrapping_paper/get_desc(dist)
	if (dist > 2)
		return
	. += "There is about [src.amount] square units of paper left!"

/obj/item/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!ishuman(target))
		return
	if (target.stat == 2)
		if (src.amount > 2)
			var/obj/spresent/present = new /obj/spresent (target.loc)
			present.icon_state = "strange-[src.style]"
			src.amount -= 2

			target.set_loc(present)
		else
			boutput(user, "<span style=\"color:blue\">You need more paper.</span>")
	else
		boutput(user, "They're moving around too much.")

/obj/item/gift
	desc = "For me!?"
	name = "gift"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2-r"
	item_state = "gift"
	var/size = 3.0
	var/obj/item/gift = null
	w_class = 4.0
	stamina_damage = 1
	stamina_cost = 1
	stamina_crit_chance = 0

/obj/item/gift/attack_self(mob/user as mob)
	if(!src.gift)
		boutput(user, "<span style=\"color:blue\">The gift was empty!</span>")
		qdel(src)
		return
	user.u_equip(src)
	user.put_in_hand_or_drop(src.gift)
	modify_christmas_cheer(2)
	qdel(src)
	return

/obj/item/a_gift
	name = "gift"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2-r"
	item_state = "gift"
	pressure_resistance = 70
	desc = "I wonder what's inside!?"
	var/list/giftpaths = list()

	New()
		..()
		src.icon_state = "gift[rand(1,3)]-[pick("r", "rs", "g", "gs")]"

	dangerous
		giftpaths = list(/obj/item/device/flash, /obj/item/gun/energy/taser_gun, /obj/item/sword, /obj/item/axe, /obj/item/knife_butcher, /obj/item/old_grenade/light_gimmick)

	festive
		giftpaths = list(/obj/item/basketball, /obj/item/clothing/head/cakehat, /obj/item/clothing/mask/melons, /obj/item/old_grenade/banana,
						/obj/item/bikehorn, /obj/item/luggable_computer, /obj/item/horseshoe, /obj/item/clothing/suit/sweater/red, /obj/item/clothing/suit/sweater,
						/obj/item/clothing/suit/sweater/green, /obj/item/clothing/glasses/monocle)

	easter
		name = "easter egg"
		icon_state = "easter_egg"
		giftpaths = list(/obj/item/bikehorn, /obj/item/vuvuzela, /obj/item/horseshoe, /obj/item/clothing/glasses/monocle, /obj/item/coin, /obj/item/clothing/gloves/fingerless,
						/obj/item/clothing/mask/spiderman, /obj/item/clothing/shoes/flippers, /obj/item/clothing/under/gimmick/cosby, /obj/item/clothing/head/waldohat, /obj/item/emeter, /obj/item/football,
						/obj/item/skull, /obj/racing_clowncar/kart, /obj/item/old_grenade/moustache, /obj/item/implanter/microbomb, /obj/item/reagent_containers/food/snacks/cereal_box, /obj/item/reagent_containers/food/snacks/candy/wrapped_pbcup)

		New()
			return

	easter/duck
		giftpaths = list(/obj/item/bikehorn, /obj/item/vuvuzela, /obj/item/horseshoe, /obj/item/clothing/glasses/monocle, /obj/item/coin, /obj/item/clothing/gloves/fingerless, /obj/item/saxophone, /obj/item/clothing/mask/cursedclown_hat, /obj/item/clothing/mask/spiderman, /obj/item/clothing/shoes/flippers, /obj/item/clothing/under/gimmick/cosby, /obj/item/clothing/head/waldohat, /obj/item/emeter,
						/obj/item/skull, /obj/item/reagent_containers/food/snacks/cereal_box, /obj/item/reagent_containers/food/snacks/candy/wrapped_pbcup)

/obj/item/a_gift/attack_self(mob/M as mob)
	if (!giftpaths.len)
		boutput(M, "<span style=\"color:blue\">The gift was empty!</span>")
		qdel(src)
		return

	var/prizepath = pick(giftpaths)
	var/obj/item/prize = new prizepath
	if (!istype(prize) && prize)
		prize.set_loc(get_turf(M))
		qdel(src)
		return

	M.u_equip(src)
	M.put_in_hand_or_drop(prize)
	modify_christmas_cheer(2)
	qdel(src)

/obj/item/a_gift/ex_act()
	qdel(src)
	return

/obj/spresent // bandaid fix for presents having no icon or name other than "spresent"
	name = "present"
	desc = "What could it be?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strange-r"

/obj/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	boutput(user, "<span style=\"color:blue\">You can't move.</span>")

/obj/spresent/attackby(obj/item/W as obj, mob/user as mob)

	if (!istype(W, /obj/item/wirecutters))
		boutput(user, "<span style=\"color:blue\">I need wirecutters for that.</span>")
		return

	boutput(user, "<span style=\"color:blue\">You cut open the present.</span>")

	for(var/mob/M in src) //Should only be one but whatever.
		M.set_loc(src.loc)

	qdel(src)