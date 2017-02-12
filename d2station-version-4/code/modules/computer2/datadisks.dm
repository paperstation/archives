/obj/item/weapon/disk/data
	var/datum/computer/folder/root = null
	var/file_amount = 32.0
	var/file_used = 0.0
	var/portable = 1
	var/title = "data disk"
	name = "data disk"
	icon = 'cloning.dmi'
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	item_state = "card-id"
	w_class = 1.0

	New()
		src.root = new /datum/computer/folder
		src.root.holder = src
		src.root.name = "root"
		var/diskcolor = pick(0,1,2,3)
		src.icon_state = "datadisk[diskcolor]"

/obj/item/weapon/disk/data/fixed_disk
	name = "storage drive"
	icon_state = "harddisk"
	title = "Storage Drive"
	file_amount = 80.0
	portable = 0

	attack_self(mob/user as mob)
		return

	New()
		..()
		icon_state = "harddisk"

/obj/item/weapon/disk/data/computer2test
	name = "programme diskette"
	icon_state = "datadisk3"
	file_amount = 628.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/arcade(src))
		src.root.add_file( new /datum/computer/file/computer_program/med_data(src))
		src.root.add_file( new /datum/computer/file/computer_program/airlock_control(src))
		src.root.add_file( new /datum/computer/file/computer_program/messenger(src))
		src.root.add_file( new /datum/computer/file/computer_program/progman(src))
		src.root.add_file( new /datum/computer/file/computer_program/sec_data(src))
		src.root.add_file( new /datum/computer/file/computer_program/crew(src))
		src.root.add_file( new /datum/computer/file/computer_program/idcard(src))
		src.root.add_file( new /datum/computer/file/computer_program/securitycam(src))
//		src.root.add_file( new /datum/computer/file/computer_program/power(src))
		src.root.add_file( new /datum/computer/file/computer_program/atm(src))

/obj/item/weapon/disk/data/progman
	name = "file manager programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/progman(src))


/obj/item/weapon/disk/data/medicalrecords
	name = "medical records programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/med_data(src))

/obj/item/weapon/disk/data/arcade
	name = "arcade programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/arcade(src))

/obj/item/weapon/disk/data/messenger
	name = "messenger programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/messenger(src))

/obj/item/weapon/disk/data/atm
	name = "ATM programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/atm(src))

/obj/item/weapon/disk/data/crew
	name = "crew monitoring programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/crew(src))

/*
/obj/item/weapon/disk/data/power
	name = "power programme diskette"
	icon_state = "datadisk3"
	file_amount = 80.0
	New()
		..()
		src.root.add_file( new /datum/computer/file/computer_program/power(src))
*/