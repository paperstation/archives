/obj/structure/closet/secure_closet/armorysafe
	name = "Emergency Gun Safe"
	desc = "BLAM BLAM BLAM."
	icon = 'icons/obj/closet.dmi'
	icon_state = "emergarm"
	density = 1
	opened = 0
	locked = 1
	broken = 0
	icon_closed = "emergarm"
	icon_opened = "emergarmopen"
	icon_locked = "emergarm"
	icon_broken = "amergarmopen"
	icon_off = "emergarm"
	health = 400
	anchored = 1


/*

/proc/emergency_guns()
	for(var/obj/structure/armorysafe/A in world)
		if(A.z == 1)
			if(A.used == 0)
				A.used = 1
				new /obj/item/weapon/gun/projectile/mp80(A.loc)
				new /obj/item/weapon/gun/projectile/mp80(A.loc)
				new /obj/item/weapon/gun/projectile/mp80(A.loc)
				A.visible_message("\red Several guns slide out of the Emergency Armory Safe!")
				A.icon_state = "emergarmopen"
			else
				return


/obj/structure/armorysafe/attackby(obj/item/weapon/W as obj, mob/user as mob) //tators gonna emag
	if(istype(W, /obj/item/weapon/card/emag))
		emergency_guns()

*/

/obj/structure/closet/secure_closet/armorysafe/togglelock(mob/user as mob)
	user << "<span class='notice'>Access Denied: Two members of staff with Armory access must swipe their cards on the side panels to open this safe.</span>"

/obj/structure/closet/secure_closet/armorysafe/proc/unlock()
	locked = 0
	src.visible_message("\red The Emergency Armory Safe clicks open!")
	icon_opened = "emergarmopen"

/obj/structure/closet/secure_closet/armorysafe/can_close()
	if(opened)
		return 0