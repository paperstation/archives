/*
 * Instruments
 */


/obj/item/weapon/Accordion
	name = "Accordion"
	desc = "A jolly accordion."
	icon = 'icons/obj/items.dmi'
	icon_state = "accordion"
	item_state = "accordion"
	throwforce = 10
	hitsound = null //To prevent tap.ogg playing, as the item lacks of force
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	attack_verb = list("Smacked")
	var/spam_flag = 0

/obj/item/weapon/bikehorn/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/items/bikehorn.ogg', 50, 1, -1) //plays instead of tap.ogg!
	return ..()

/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return
