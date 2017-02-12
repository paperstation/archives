/obj/item/weapon/barber/comb
	name = "Barber's comb"
	desc = "For combing down your scrawny neckbeard."
	icon = 'icons/obj/barber.dmi'
	icon_state = "comb"
	item_state = "combhand"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 0
	throwforce = 0
	w_class = 1
	origin_tech = "combat=2"
	attack_verb = list("combed", "straightened", "slicked over", "combed over")
	hitsound = 'sound/weapons/punchmiss.ogg'

/obj/item/weapon/barber/scissors
	name = "Barber's scissors"
	desc = "Stop running!"
	icon = 'icons/obj/barber.dmi'
	icon_state = "smallscissors"
	item_state = "combhand"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 3
	throwforce = 0
	w_class = 1
	origin_tech = "combat=3"
	attack_verb = list("chopped", "trimmed", "buzzed", "clipped","snipped")
	hitsound = 'sound/weapons/pierce.ogg'