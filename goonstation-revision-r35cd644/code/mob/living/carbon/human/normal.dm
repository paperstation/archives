/mob/living/carbon/human/normal/female
	New()
		..()
		spawn(0)
			bioHolder.mobAppearance.gender = "female"
			bioHolder.mobAppearance.customization_first = "Bedhead"
			src.real_name = pick(first_names_female)+" "+pick(last_names)

		spawn(10)
			bioHolder.mobAppearance.UpdateMob()
			set_clothing_icon_dirty()

/mob/living/carbon/human/normal/female/assistant
	New()
		..()
		spawn(0)
			JobEquipSpawned("Staff Assistant")

/mob/living/carbon/human/normal/female/syndicate
	New()
		..()
		spawn(0)
			JobEquipSpawned("Syndicate")

/mob/living/carbon/human/normal/female/captain
	New()
		..()
		spawn(0)
			JobEquipSpawned("Captain")

/mob/living/carbon/human/normal/female/headofpersonnel
	New()
		..()
		spawn(0)
			JobEquipSpawned("Head of Personnel")

/mob/living/carbon/human/normal/female/chiefengineer
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chief Engineer")

/mob/living/carbon/human/normal/female/researchdirector
	New()
		..()
		spawn(0)
			JobEquipSpawned("Research Director")

/mob/living/carbon/human/normal/female/headofsecurity
	New()
		..()
		spawn(0)
			JobEquipSpawned("Head of Security")

/mob/living/carbon/human/normal/female/securityofficer
	New()
		..()
		spawn(0)
			JobEquipSpawned("Security Officer")

/mob/living/carbon/human/normal/female/detective
	New()
		..()
		spawn(0)
			JobEquipSpawned("Detective")

/mob/living/carbon/human/normal/female/clown
	New()
		..()
		spawn(0)
			JobEquipSpawned("Clown")

/mob/living/carbon/human/normal/female/chef
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chef")

/mob/living/carbon/human/normal/female/chaplain
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chaplain")

/mob/living/carbon/human/normal/female/barman
	New()
		..()
		spawn(0)
			JobEquipSpawned("Barman")

/mob/living/carbon/human/normal/female/botanist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Botanist")

/mob/living/carbon/human/normal/female/janitor
	New()
		..()
		spawn(0)
			JobEquipSpawned("Janitor")

/mob/living/carbon/human/normal/female/mechanic
	New()
		..()
		spawn(0)
			JobEquipSpawned("Mechanic")

/mob/living/carbon/human/normal/female/engineer
	New()
		..()
		spawn(0)
			JobEquipSpawned("Engineer")

/mob/living/carbon/human/normal/female/miner
	New()
		..()
		spawn(0)
			JobEquipSpawned("Miner")

/mob/living/carbon/human/normal/female/quartermaster
	New()
		..()
		spawn(0)
			JobEquipSpawned("Quartermaster")

/mob/living/carbon/human/normal/female/medicaldoctor
	New()
		..()
		spawn(0)
			JobEquipSpawned("Medical Doctor")

/mob/living/carbon/human/normal/female/geneticist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Geneticist")

/mob/living/carbon/human/normal/female/roboticist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Roboticist")

/mob/living/carbon/human/normal/female/chemist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chemist")

/mob/living/carbon/human/normal/female/scientist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Scientist")

/mob/living/carbon/human/normal/male
	New()
		..()
		spawn(0)
			src.mind = new
			if(src.key)
				src.mind.key = src.key
			src.mind.current = src
			bioHolder.mobAppearance.gender = "male"
			src.cust_one_state = "short"
			src.real_name = pick(first_names_male)+" "+pick(last_names)

		spawn(10)
			bioHolder.mobAppearance.UpdateMob()
			set_clothing_icon_dirty()

/mob/living/carbon/human/normal/male/assistant
	New()
		..()
		spawn(0)
			JobEquipSpawned("Staff Assistant")

/mob/living/carbon/human/normal/male/syndicate
	New()
		..()
		spawn(0)
			JobEquipSpawned("Syndicate")

/mob/living/carbon/human/normal/male/captain
	New()
		..()
		spawn(0)
			JobEquipSpawned("Captain")

/mob/living/carbon/human/normal/male/headofpersonnel
	New()
		..()
		spawn(0)
			JobEquipSpawned("Head of Personnel")

/mob/living/carbon/human/normal/male/chiefengineer
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chief Engineer")

/mob/living/carbon/human/normal/male/researchdirector
	New()
		..()
		spawn(0)
			JobEquipSpawned("Research Director")

/mob/living/carbon/human/normal/male/headofsecurity
	New()
		..()
		spawn(0)
			JobEquipSpawned("Head of Security")

/mob/living/carbon/human/normal/male/securityofficer
	New()
		..()
		spawn(0)
			JobEquipSpawned("Security Officer")

/mob/living/carbon/human/normal/male/detective
	New()
		..()
		spawn(0)
			JobEquipSpawned("Detective")

/mob/living/carbon/human/normal/male/clown
	New()
		..()
		spawn(0)
			JobEquipSpawned("Clown")

/mob/living/carbon/human/normal/male/chef
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chef")

/mob/living/carbon/human/normal/male/chaplain
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chaplain")

/mob/living/carbon/human/normal/male/barman
	New()
		..()
		spawn(0)
			JobEquipSpawned("Barman")

/mob/living/carbon/human/normal/male/botanist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Botanist")

/mob/living/carbon/human/normal/male/janitor
	New()
		..()
		spawn(0)
			JobEquipSpawned("Janitor")

/mob/living/carbon/human/normal/male/mechanic
	New()
		..()
		spawn(0)
			JobEquipSpawned("Mechanic")

/mob/living/carbon/human/normal/male/engineer
	New()
		..()
		spawn(0)
			JobEquipSpawned("Engineer")

/mob/living/carbon/human/normal/male/miner
	New()
		..()
		spawn(0)
			JobEquipSpawned("Miner")

/mob/living/carbon/human/normal/male/quartermaster
	New()
		..()
		spawn(0)
			JobEquipSpawned("Quartermaster")

/mob/living/carbon/human/normal/male/medicaldoctor
	New()
		..()
		spawn(0)
			JobEquipSpawned("Medical Doctor")

/mob/living/carbon/human/normal/male/geneticist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Geneticist")

/mob/living/carbon/human/normal/male/roboticist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Roboticist")

/mob/living/carbon/human/normal/male/chemist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Chemist")

/mob/living/carbon/human/normal/male/scientist
	New()
		..()
		spawn(0)
			JobEquipSpawned("Scientist")

/mob/living/carbon/human/normal/male/wizard
	New()
		..()
		spawn(0)
			if (src.gender && src.gender == "female")
				src.real_name = pick(wiz_female)
			else
				src.real_name = pick(wiz_male)

			equip_wizard(src, 1)
		return

/mob/living/carbon/human/normal/meteor_rescue
	New()
		..()
		spawn(0)
			src.equip_if_possible(new /obj/item/clothing/shoes/red(src), slot_shoes)
			src.equip_if_possible(new /obj/item/clothing/under/color/red(src), slot_w_uniform)
			src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
			src.equip_if_possible(new /obj/item/storage/backpack(src), slot_back)
			src.equip_if_possible(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
			src.equip_if_possible(new /obj/item/clothing/mask/gas(src), slot_wear_mask)
			src.equip_if_possible(new /obj/item/clothing/gloves/black(src), slot_gloves)
			src.equip_if_possible(new /obj/item/clothing/glasses/meson(src), slot_glasses)
			src.spawnId("Rescue Worker")

			if (prob(50))
				bioHolder.mobAppearance.gender = "male"
				src.cust_one_state = "short"
				src.real_name = pick(first_names_male)+" "+pick(last_names)
			else
				bioHolder.mobAppearance.gender = "female"
				bioHolder.mobAppearance.customization_first = "Bedhead"
				src.real_name = pick(first_names_female)+" "+pick(last_names)


			sleep(10)
			bioHolder.mobAppearance.UpdateMob()
			set_clothing_icon_dirty()