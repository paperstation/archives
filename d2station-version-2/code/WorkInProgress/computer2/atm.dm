/datum/computer/file/computer_program/atm
	name = "ATM"
	size = 32.0
	active_icon = "dna"
	var/authenticated = 0
	var/moneyinserted = 0
	var/rank
	var/screen
	var/datum/data/record/active1
	var/datum/data/record/active2
	var/temp

/datum/computer/file/computer_program/atm/return_text()
	if(..())
		return
	src.master.icon_state = "computer_atm"
	var/dat
	if (src.temp)
		dat = text("<TT>[src.temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>")
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];id=auth'>[]</A><HR>", master, (src.master.authid ? text("[]", src.master.authid.name) : "----------"))
		if (src.authenticated)
			switch(src.screen)
				if(1.0)
					dat += {"
<A href='?src=\ref[src];balance=1'>View Balance</A>
<BR><A href='?src=\ref[src];withdraw=2'>Withdraw</A>
<BR><A href='?src=\ref[src];deposit=1'>Deposit</A><BR>
<BR><A href='?src=\ref[src];logout=1'>Log Out</A><BR>
"}

		else
			dat += text("<A href='?src=\ref[];login=1'>Log In</A>", src)
			//dat += "<br><a href='byond://?src=\ref[src];quit=1'>{Quit}</a>" //we don't want them quitting the program

	return dat

/datum/computer/file/computer_program/atm/Topic(href, href_list)
	if(..())
		return
	if (!( data_core.general.Find(src.active1) ))
		src.active1 = null
	if (!( data_core.medical.Find(src.active2) ))
		src.active2 = null
	if (href_list["temp"])
		src.temp = null
	else if (href_list["logout"])
		src.authenticated = null
		src.screen = null
		src.active1 = null
		src.active2 = null
	else if (href_list["login"])
		if (istype(src.master, /mob/living/silicon))
			src.active1 = null
			src.active2 = null
			src.authenticated = 1
			src.rank = "AI"
			src.screen = 1
		else if (istype(src.master.authid, /obj/item/weapon/card/id))
			src.active1 = null
			src.active2 = null
			if (src.check_access(src.master.authid))
				src.authenticated = src.master.authid.registered
				src.rank = src.master.authid.assignment
				src.screen = 1
	if (src.authenticated)
		if (href_list["balance"])
			if(src.master.authid.credit < 1)
				src.temp = text("You have 0 space euros on your credit card.<br>")
			else
				src.temp = text("You have [src.master.authid.credit] space euros on your credit card.<br>")
		if (href_list["withdraw"])
			var/mvalidate = input("How much money would you like to withdraw?", "ATM - Withdraw", null) as num

			if (mvalidate > src.master.authid.credit)
				src.temp = text("You don't have that much money on your credit card.")
			else if (mvalidate <= 0)
				src.temp = text("You can't withdraw a negative amount.")
			else

				src.master.authid.credit -= mvalidate
				if(src.master.authid.credit < 1)
					src.temp = text("You now have 0 space euros on your credit card.<br>")
				else
					src.temp = text("You now have [src.master.authid.credit] space euros on your credit card.<br>")
				playsound(src.master.loc, 'atm_01.ogg', 55, 0)
				sleep(10)

				var/obj/item/weapon/spacecash = new /obj/item/weapon/spacecash(src.master.loc)
				spacecash.name = "[mvalidate] space euros"
				spacecash.moneyvalue = mvalidate

		if (href_list["deposit"])
			src.temp = text("NOT YET IMPLEMENTED!<br>")

			if(src.master.authid.credit < 1)
				src.temp = text("You now have 0 space euros on your credit card.<br>")
			else
				src.temp = text("You now have [src.master.authid.credit] space euros on your credit card.<br>")

	src.master.add_fingerprint(usr)
	src.master.updateUsrDialog()
	return