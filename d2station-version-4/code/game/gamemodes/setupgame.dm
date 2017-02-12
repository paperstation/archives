/proc/setupgenetics()

	if (prob(50))
		BLOCKADD = rand(-300,300)
	if (prob(75))
		DIFFMUT = rand(0,20)

	var/list/avnums = new/list()
	var/tempnum

	avnums.Add(2)
	avnums.Add(12)
	avnums.Add(10)
	avnums.Add(8)
	avnums.Add(4)
	avnums.Add(11)
	avnums.Add(13)
	avnums.Add(6)
	avnums.Add(9)
	avnums.Add(1)
	avnums.Add(3)
	avnums.Add(5)
	avnums.Add(7)
	avnums.Add(14)
	avnums.Add(15)
	avnums.Add(16)
	avnums.Add(17)
	avnums.Add(18)
	avnums.Add(19)
	avnums.Add(20)
	avnums.Add(21)
	avnums.Add(22)
	avnums.Add(23)
	avnums.Add(24)
	avnums.Add(25)

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	HULKBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	TELEBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	FIREBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	XRAYBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	CLUMSYBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	FAKEBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	DEAFBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	BLINDBLOCK = tempnum



	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	HEADACHEBLOCK = tempnum



	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	COUGHBLOCK = tempnum


	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	TWITCHBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	NERVOUSBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	NOBREATHBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	REMOTEVIEWBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	REGENERATEBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	INCREASERUNBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	REMOTETALKBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	MORPHBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	BLENDBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	HALLUCINATIONBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	NOPRINTSBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	SHOCKIMMUNITYBLOCK = tempnum

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	SMALLSIZEBLOCK = tempnum

/* This was used for something before, I think, but is not worth the effort to process now.
/proc/setupcorpses()
	for (var/obj/landmark/A in world)
		if (A.name == "Corpse")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			del(A)
			continue
		if (A.name == "Corpse-Engineer")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_if_possible(new /obj/item/device/radio/headset/headset_eng(M), M.slot_ears)
			M.equip_if_possible(new /obj/item/device/pda/engineering(M), M.slot_belt)
			M.equip_if_possible(new /obj/item/clothing/under/rank/engineer(M), M.slot_w_uniform)
			M.equip_if_possible(new /obj/item/clothing/shoes/orange(M), M.slot_shoes)
		//	M.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(M), M.slot_l_hand)
			M.equip_if_possible(new /obj/item/clothing/gloves/yellow(M), M.slot_gloves)
			M.equip_if_possible(new /obj/item/device/t_scanner(M), M.slot_r_store)
			//M.equip_if_possible(new /obj/item/device/radio/headset(M), M.slot_ears)
			M.equip_if_possible(new /obj/item/weapon/storage/backpack(M), M.slot_back)
			if (prob(50))
				M.equip_if_possible(new /obj/item/clothing/mask/gas(M), M.slot_wear_mask)
			if (prob(50))
				M.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(M), M.slot_head)
			else
				if (prob(50))
					M.equip_if_possible(new /obj/item/clothing/head/helmet/welding(M), M.slot_head)
			del(A)
			continue
		if (A.name == "Corpse-Engineer-Space")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_if_possible(new /obj/item/device/radio/headset/headset_eng(M), M.slot_ears)
			M.equip_if_possible(new /obj/item/weapon/tank/emergency_oxygen(M), M.slot_belt)
			M.equip_if_possible(new /obj/item/clothing/under/rank/engineer(M), M.slot_w_uniform)
			M.equip_if_possible(new /obj/item/clothing/shoes/orange(M), M.slot_shoes)
			M.equip_if_possible(new /obj/item/clothing/suit/space(M), M.slot_wear_suit)
		//	M.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(M), M.slot_l_hand)
			M.equip_if_possible(new /obj/item/clothing/gloves/yellow(M), M.slot_gloves)
			M.equip_if_possible(new /obj/item/device/t_scanner(M), M.slot_r_store)
			M.equip_if_possible(new /obj/item/weapon/storage/backpack(M), M.slot_back)
			M.equip_if_possible(new /obj/item/clothing/mask/gas(M), M.slot_wear_mask)
			if (prob(50))
				M.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(M), M.slot_head)
			else
				if (prob(50))
					M.equip_if_possible(new /obj/item/clothing/head/helmet/welding(M), M.slot_head)
				else
					M.equip_if_possible(new /obj/item/clothing/head/helmet/space(M), M.slot_head)
			del(A)
			continue
		if (A.name == "Corpse-Engineer-Chief")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_if_possible(new /obj/item/device/radio/headset/headset_eng(M), M.slot_ears)
			M.equip_if_possible(new /obj/item/weapon/storage/utilitybelt(M), M.slot_belt)
			M.equip_if_possible(new /obj/item/clothing/under/rank/chief_engineer(M), M.slot_w_uniform)
			M.equip_if_possible(new /obj/item/clothing/shoes/orange(M), M.slot_shoes)
		//	M.equip_if_possible(new /obj/item/weapon/storage/toolbox/mechanical(M), M.slot_l_hand)
			M.equip_if_possible(new /obj/item/clothing/gloves/yellow(M), M.slot_gloves)
			M.equip_if_possible(new /obj/item/device/t_scanner(M), M.slot_r_store)
			M.equip_if_possible(new /obj/item/weapon/storage/backpack(M), M.slot_back)
			if (prob(50))
				M.equip_if_possible(new /obj/item/clothing/mask/gas(M), M.slot_wear_mask)
			if (prob(50))
				M.equip_if_possible(new /obj/item/clothing/head/helmet/hardhat(M), M.slot_head)
			else
				if (prob(50))
					M.equip_if_possible(new /obj/item/clothing/head/helmet/welding(M), M.slot_head)
			del(A)
			continue
		if (A.name == "Corpse-Syndicate")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_if_possible(new /obj/item/device/radio/headset(M), M.slot_ears)
			//M.equip_if_possible(new /obj/item/weapon/gun/revolver(M), M.slot_belt)
			M.equip_if_possible(new /obj/item/clothing/under/syndicate(M), M.slot_w_uniform)
			M.equip_if_possible(new /obj/item/clothing/shoes/black(M), M.slot_shoes)
			M.equip_if_possible(new /obj/item/clothing/gloves/swat(M), M.slot_gloves)
			M.equip_if_possible(new /obj/item/weapon/tank/jetpack(M), M.slot_back)
			M.equip_if_possible(new /obj/item/clothing/mask/gas(M), M.slot_wear_mask)
			if (prob(50))
				M.equip_if_possible(new /obj/item/clothing/suit/space/syndicate(M), M.slot_wear_suit)
				if (prob(50))
					M.equip_if_possible(new /obj/item/clothing/head/helmet/swat(M), M.slot_head)
				else
					M.equip_if_possible(new /obj/item/clothing/head/helmet/space/syndicate(M), M.slot_head)
			else
				M.equip_if_possible(new /obj/item/clothing/suit/armor/vest(M), M.slot_wear_suit)
				M.equip_if_possible(new /obj/item/clothing/head/helmet/swat(M), M.slot_head)
			del(A)
			continue
*/

