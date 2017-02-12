/datum/computer/file/computer_program/atm
	name = "automated teller"
	size = 32.0
	program_screen_icon = "atm"
	resolution = "atmframe"
	var/authenticated = 0
	var/pinauthed = 0
	var/moneyinserted = 0
	var/rank
	var/screen
	var/datum/data/record/active1
	var/datum/data/record/active2
	var/temp
	var/balance = 0

/datum/computer/file/computer_program/atm/return_text()
	if(..())
		return
	var/dat
	if (src.temp)
		dat = text("<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' /><TT>[src.temp]</TT><BR><BR><A href='?src=\ref[src];logout=1'>Log Out</A><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>")
	else
		dat = text("<link rel='stylesheet' href='http://lemon.d2k5.com/ui.css' />Card: <A href='?src=\ref[];id=auth'>[]</A><HR>", master, (src.master.authid ? text("[]", src.master.authid.name) : "----------"))
		if (src.authenticated)
			dat += text("PIN: <A href='?src=\ref[];id=pincode'>[]</A><HR>", master, (src.master.pincode ? text("[]", src.master.pincode) : "-----"))
		if (src.authenticated && src.pinauthed)
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
		src.pinauthed = null
		src.master.pincode = null
		src.screen = null
		src.active1 = null
		src.active2 = null
		src.temp = null
	else if (href_list["login"])
		if (istype(src.master.authid, /obj/item/weapon/card/id))
			src.active1 = null
			src.active2 = null
			if (src.check_access(src.master.authid))
				src.authenticated = src.master.authid.registered
				src.rank = src.master.authid.assignment
				src.screen = 1
				if(src.master.pincode == src.master.authid.pincode)
					src.pinauthed = 1
	if (src.authenticated && src.pinauthed)
		if(src.master.pincode != src.master.authid.pincode)
			src.temp = text("ERROR: PIN incorrect.")
			return
		//verify existence of bank account
		//world << "\green [src.getBalance(src.master.authid.originalckey)]"
		if(src.getBalance(src.master.authid.originalckey))
			//world << "\red [balance]"
			//world << "\blue [src.master.moneyinserted]"
			balance = src.getBalance(src.master.authid.originalckey)
			src.master.moneyinserted = text2num(src.master.moneyinserted)
		else
			src.temp = text("ERROR: Bank account does not exist.")
			return

		if("[balance]" == "ERROR")
			src.temp = text("ERROR: Bank account does not exist.")
			return

		if (href_list["balance"])
			src.temp = text("You have Ð[balance] on your account.<br>There is Ð[src.master.moneyinserted] in the ATM ready to be deposited.<br>")

		if (href_list["withdraw"])
			var/mvalidate = input("How much money would you like to withdraw?", "ATM - Withdraw", null) as num
			if(mvalidate > 0)
				if (src.doTransaction(src.master.authid.originalckey,"-[mvalidate]","ATM Withdrawal") != 1)
					src.temp = text("Error: Insufficient funds or bank account nonexistent.")
				else
					balance = src.getBalance(src.master.authid.originalckey)
					src.temp = text("Withdrawal of Ð[mvalidate] successful.<br>You now have Ð[balance] on your account.<br>")
					playsound(src.master.loc, 'atm_01.ogg', 55, 0)
					sleep(10)

					var/obj/item/weapon/money/spacecash = new /obj/item/weapon/money(src.master.loc)
					spacecash.name = "Ð[mvalidate]"
					spacecash.value = text2num(mvalidate)
					spacecash.currency = "Ð"

		if (href_list["deposit"])
			if(src.master.moneyinserted != 0)
				src.doTransaction(src.master.authid.originalckey,text2num(src.master.moneyinserted),"ATM Deposit")
				balance = src.getBalance(src.master.authid.originalckey)
				src.temp = text("Deposit of Ð[src.master.moneyinserted] successful.<br>You now have Ð[balance] on your account.<br>")
				src.master.moneyinserted = 0
			else
				src.temp = text("Please insert some money into the machine first.<br>")

	src.master.add_fingerprint(usr)
	src.master.updateUsrDialog()
	return