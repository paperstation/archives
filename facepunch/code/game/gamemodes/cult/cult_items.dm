/obj/item/weapon/melee/cultblade
	name = "Cult Blade"
	desc = "An arcane weapon wielded by the followers of Nar-Sie"
	icon_state = "cultblade"
	item_state = "cultblade"
	flags = FPRINT | TABLEPASS
	w_class = 4
	force = DAMAGE_EXTREME
	forcetype = PIERCE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")


	attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
		if(iscultist(user))
			playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
			return ..()
		else
			user.deal_damage(4, WEAKEN)
			user.deal_damage(10, BURN, SLASH, "arms")
			user << "\red An unexplicable force powerfully repels the sword from [target]!"
		return

	pickup(mob/living/user as mob)
		if(!iscultist(user))
			user << "\red An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly."
		return

/obj/item/clothing/head/culthood
	name = "cult hood"
	icon_state = "cult_helmet"
	desc = "A hood worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)


/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie"
	icon_state = "cult_armour"
	item_state = "cult_armour"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	body_parts_covered = CHEST|LEGS|ARMS
	allowed = list(/obj/item/weapon/tome,/obj/item/weapon/melee/cultblade)
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/head/magus
	name = "magus helm"
	icon_state = "magus"
	item_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE
	flags = FPRINT|TABLEPASS|HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)

/obj/item/clothing/suit/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie"
	icon_state = "magusred"
	item_state = "magusred"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	body_parts_covered = CHEST|LEGS|ARMS
	allowed = list(/obj/item/weapon/tome,/obj/item/weapon/melee/cultblade)
	armor = list(impact = 0.4, slash = 0.4, pierce = 0.2, bomb = 0.4, bio = 0.0, rad = 0.0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT