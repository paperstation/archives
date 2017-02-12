for(var/mob/living/carbon/human/H in mobz)
	var/list/viruses = list("fake gbs","gbs","cold","flu")
						var/V = input("Choose the virus to spread") in viruses
						viral_outbreak(V)
						message_admins("[key_name_admin(usr)] has triggered a virus outbreak of [V]", 1)