/obj/item/weapon/throwweapon
	icon = 'throwingweapons.dmi'
	icon_state = "throwingstar4point"
	name = "throwitemdefault"
	item_state = "throwingstar4point"
	density = 0
	anchored = 0
	w_class = 1.0
	force = 0.0
	throwforce = 10.0
	throw_speed = 3
	throw_range = 30
	flags = FPRINT | USEDELAY | TABLEPASS | CONDUCT
	dir = NORTH//this way southern aimed throws can still look southern, as south is default item state for all.
	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed)


/obj/item/weapon/throwweapon/throwstar
	icon_state = "throwingstar4point"
	name = "Throwing Star"
	item_state = "throwingstar4point"
	throwforce = 15.0
	throw_speed = 3
	throw_range = 30

/obj/item/weapon/throwweapon/throwstar/batarang
	icon_state = "batarang"
	name = "Batarang"
	item_state = "batarang"
	throwforce = 15.0
	throw_speed = 3
	throw_range = 30
	dir = SOUTH // the bottom of them strike, so they look best as this default


//wizard spells
/obj/item/weapon/spell
	icon = 'throwingweapons.dmi'
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 30
	flags = FPRINT | USEDELAY | TABLEPASS | CONDUCT
	dir = NORTH


/obj/item/weapon/spell/fireball //its all handled in throwing.dm -Nernums
	force = 10.0 //sure why not, although I should really make it do -burn- damage
	throwforce = 0.0
	icon_state = "fireball"
	name = "ONI SOMA"
	item_state = "fireball"
	throw_speed = 1
	//spawn(800)
	//	del(src)

/obj/item/weapon/spell/einath //its all handled in throwing.dm -Nernums
	throwforce = 0.0
	icon_state = "einath"
	name = "EI NATH"
	item_state = "einath"
	throw_speed = 1
	throw_range = 2
//	spawn(800)
	//	del(src)
/obj/item/weapon/spell/magicm //its all handled in throwing.dm -Nernums
	throwforce = 0.0
	icon_state = "magicm"
	name = "FORTI GY AMA"
	item_state = "magicm"
	throw_speed = 1
//	spawn(800)
	//	del(src)
/obj/item/weapon/spell/blind //its all handled in throwing.dm -Nernums
	throwforce = 0.0
	icon_state = "blind"
	name = "STI KALY"
	item_state = "blind"
	throw_speed = 1
//	spawn(300)
	//	del(src)
/obj/item/weapon/spell/forcewall //its all handled in throwing.dm -Nernums
	throwforce = 0.0
	icon_state = "forcewall"
	name = "TARCOL MINTI ZHERI"
	item_state = "forcewall"
	throw_speed = 1
//	spawn(100)
	//	del(src)
/*/obj/item/weapon/throwweapon/magicmissle //its all handled in throwing.dm -Nernums
	throwforce = 0.0
	icon_state = "magicmissle"
	name = "FORTI GY AMA"
	item_state = "magicmissle"
	throw_speed = 1*/