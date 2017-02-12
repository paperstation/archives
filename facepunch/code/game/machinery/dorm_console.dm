/obj/machinery/dorms_console
	name = "Dorm Console"
	desc = "Used to reserve dorms."
	anchored = 1 //WHY DID YOU PUT THIS IN SPACE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_available"
	var/owner = null //owners name
	var/job = null //owners job
	var/used = 0 //If it has an owner
	var/access = null
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/takemoney = 0
	var/joke = 0 //haha

//For the themes
	var/thememed = 0
	var/themewood = 0
	var/themescience = 0
	var/themetator
	var/chosentheme = 0 //One console; one theme
	var/doorstatus = 0
	var/money = 0 //money money money, for buying things!



/obj/machinery/dorms_console/power_change()
	..()
	update_icon()

/obj/machinery/dorms_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "dorm_off")
			icon_state = "dorm_off"
		else
			if(icon_state == "dorm_off")
				icon_state = "dorm_available"



/obj/machinery/dorms_console/attack_hand(mob/living/user as mob)
	if(owner == user.real_name)
		var/dat = "<B>Your New Room Device:</B><BR>"
		dat += "Owner: [owner]<BR>"
		dat += "Job: [job]<BR>"
		if(doorstatus == 0)
			dat += "<A href='byond://?src=\ref[src];op=doorbolt'>Door Bolt Status: Unlocked</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=doorunbolt'>Door Bolt Status: Locked</A><BR>"
		dat += "<B>Please refer to the paper that was printed by this device.</B><BR>"
		dat += "<br>"
		dat += "<br>"
		if(money >= 10)
			dat += "Space Cash Deals!"
			dat += "<br>"
			dat += "Points: [money]"
			dat += "<br>"
			dat += "<A href='byond://?src=\ref[src];op=bluesheet'>Blue Sheet (10 Points)</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=redsheet'>Red Sheet (10 Points)</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=greensheet'>Green Sheet (10 Points)</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=yellowsheet'>Yellow Sheet (10 Points)</A><BR>"
		dat += "<br>"
		if(chosentheme == 0)
			dat += "<A href='byond://?src=\ref[src];op=asstheme'>Assistant Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=shuttheme'>Shuttle Theme</A><BR>"
	//	if(thememed & chosentheme == 0)
			dat += "<A href='byond://?src=\ref[src];op=medtheme'>Medical Theme</A><BR>"
	//	if(themewood & chosentheme == 0)
			dat += "<A href='byond://?src=\ref[src];op=themewood'>Wood Theme</A><BR>"
	//	if(themescience & chosentheme == 0)
			dat += "<A href='byond://?src=\ref[src];op=themescience'>Science Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=themesec'>Security Theme</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=themeai'>Green Circuit Theme</A><BR>"
			if(Holiday == "Christmas")
				dat += "<A href='byond://?src=\ref[src];op=themchristmas'>Christmas Theme</A><BR>"
			if(emagged)
				dat += "<A href='byond://?src=\ref[src];op=themetraitor'>Sneaky Syndicate Theme</A><BR>"
		dat += "<br>"
		dat += "<br><b><u>Remember! Style is the key to the future! Also remember that your chosen theme is final!</b></u><HR> "
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return

	else
		if(used == 0)
			user << "You check the computer to see that the room is vacant. Swipe your ID to bind it to you!"
		else
			user << "You check the computer to see that the room is owned by [owner], the [job]."
	return
/obj/machinery/dorms_console/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		var/area/A = get_area(src.loc)
		var/list/L = A.get_contents()
		if(!A)return
		switch(href_list["op"])
			if("bluesheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/blue( src.loc )
					money += -10
			if("redsheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/red( src.loc )
					money += -10
			if("greensheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/green( src.loc )
					money += -10
			if("yellowsheet")
				if(money >= 10)
					new /obj/item/weapon/bedsheet/yellow( src.loc )
					money += -10
			if("asstheme")
				chosentheme = 1
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "plating"
			if("shuttheme")
				chosentheme = 1
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "shuttlefloor"
			if("themewood")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "wood"
				chosentheme = 1
			if("themescience")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "whitepurplefull"
				chosentheme = 1
			if("themetraitor")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "whitepurplefull"
				chosentheme = 1
			if("themesec")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "redfull"
				chosentheme = 1
			if("themeai")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "gcircuit"
				chosentheme = 1
			if("themesanta")
				for(var/turf/simulated/floor/T in L)
					T.icon_state = "redgreenfull"
				chosentheme = 1
			if("doorbolt")
				for(var/obj/machinery/door/airlock/D in L)
					if(doorstatus == 0)
						D.locked = 1
						D.update_icon()
						doorstatus = 1
			if("doorunbolt")
				for(var/obj/machinery/door/airlock/D in L)
					if(doorstatus == 1)
						D.locked = 0
						D.update_icon()
						doorstatus = 0
		attack_hand(usr)
		return


/obj/machinery/dorms_console/attackby(obj/item/I as obj, mob/living/user as mob)
	if (!(src.stat & (BROKEN | NOPOWER)))
		if(istype(I,/obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/ID = I
			if(used == 0)
				user << "You bind your self to the [name] console! Please refer to the now printed out instruction paper!"
				used = 1
				owner = ID.registered_name
				job = ID.assignment
				Report()
			else
				user << "The console rejects your ID card because it has already been bound to someone!"
	/*	if(istype(I,/obj/item/stack/tile/wood))
			if(themewood == 0)
				themewood = 1
				user << "The console scans your item; uploading the 'Wood' design to its theme database."
		if(istype(I,/obj/item/device/assembly/igniter))
			if(themescience == 0)
				themescience = 1
				user << "The console scans your item; uploading the 'Science' design to its theme database."
		if(istype(I,/obj/item/weapon/storage/firstaid))
			if(thememed == 0)
				thememed = 1
				user << "The console scans your item; uploading the 'Medical' design to its theme database."
	*/
		if(istype(I, /obj/item/device/multitool))
			user << "\blue You hold up the multitool to the console. This will take some time to wipe its settings!"
			if(do_after(user, 200))
				user << "\blue After some time; you short out the magnetic ID strip on the console; reseting it to factory default."
				owner = null
				job = null
				used = 0

		if(istype(I, /obj/item/weapon/spacecash/c10))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 1
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c20))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 2
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c50))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 5
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c100))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 10
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c200))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 20
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0

		if(istype(I, /obj/item/weapon/spacecash/c500))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue You insert the space cash and wait for the machine to recognize it."
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 50
							user << "The space cash is recognized by the machine and increases the total credits."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; you should try it again."
							takemoney = 0


		if(istype(I, /obj/item/weapon/spacecash/c1000))
			if(takemoney == 0)
				takemoney = 1
				user << "\blue Hahahaha, theres no such thing as a 1000 space cash bill; but you insert it anyway!"
				if(do_after(user, 25))
					switch(rand(1,11))
						if(3 to 11 )
							user.drop_item()
							I.loc = src
							money += 100
							user << "The space cash is recognized by the machine and increases the total credits; but your money is fake so why question it."
							takemoney = 0
						if(1 to 2)
							user << "The space cash is pushed out of the slot; obviously your fake money won't work, so you should try it again anyway."
							takemoney = 0

	else
		user << "The machine isn't functioning correctly."




//Autoname
/obj/machinery/dorms_console/New()
	..()
	spawn(10)
		var/area/A = get_area(src)
		if(A)
			for(var/obj/machinery/dorms_console/C in world)
				if(C == src) continue
			name = "[A.name] Dorm Computer"
			if(!A)return


//How-to-guide
/obj/machinery/dorms_console/proc/Report()
	if (!(src.stat & (BROKEN | NOPOWER)))
		var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( src.loc )
		intercept.name = "paper- 'Your New Room Guide!'"
		intercept.info = "<h1>Welcome [owner], the [job]</h1><p>This quick guide will show you the tips and tricks to <i>YOUR NEW ROOM</i>. You ever wanted to try something new but no one else cared? Good news for you; now you wont need to! Yes the tips and tricks here are all real and all the time!.</p><p>Lets start with our first tips! You can change the floor of your room. How you might ask? Its so so simple; just press a button!  <b>Just remember though; you can only have one theme. Once you choose is permanent.</b></p><p>Of course these current models are low end models that do not contain the advanced features that are the finished product! Yes thats right; you too can spend space cash in the future on upgrades0</p>!"

/datum/voucherrewards
	var/name = "voucher"
	var/cost = 0
/datum/voucherrewards/C
	name = "test"
	cost = 3
var/global/vouchers = 0 //So badmins can't change this

/obj/machinery/voucher
	name = "Voucher Console"
	desc = "Used to spend vouchers."
	anchored = 1 //WHY DID YOU PUT THIS IN SPACE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "redeem"
	var/screenstate = 0
	var/tempname = null
	var/special = 0
	var/tempreason = null
	var/research = 0

	var/list/voucher_rewards = list()
	var/tempcode = null
	New()//At the start of the game, checks the consistent.txt file for the amount of vouchers
		var/list/Lines = file2list("data/consistent.ini")//Grabs the value from
		if(Lines.len)
			if(Lines[1])
				var/temp = text2num(Lines[1])
				if(temp >= 20)
					vouchers = 20
				else if(temp <= 0)
					vouchers = 0
				else
					vouchers = temp

	attackby(obj/item/I as obj, mob/living/user as mob)
		if (!(src.stat & (BROKEN | NOPOWER)))
			if(istype(I,/obj/item/weapon/card/emag))
				if(!emagged)
					emagged = 1
					user << "You emag the voucher machine."

	attack_hand(mob/living/user as mob)
		src.add_fingerprint(user)
		var/dat = "<B>Voucher Dispenser 301</B><BR>"
		dat += "<br><B>Number of Vouchers</b>: [vouchers]<br>"
		switch(screenstate)
			if(0)
				dat += "<A href='byond://?src=\ref[src];op=makevoucher'>Create a Voucher</A><BR>"
				dat += "<A href='byond://?src=\ref[src];op=order'>Obtaining Vouchers</A><BR>"
			if(1)
				if(vouchers >= 10)
					dat += "<A href='byond://?src=\ref[src];op=buycode'>Away Mission Code (15)</A><BR>"
				if(vouchers >= 10)
					dat += "<A href='byond://?src=\ref[src];op=smes'>Power all SMES (10)</A><BR>"
				if(vouchers >= 7 && !research)
					dat += "<A href='byond://?src=\ref[src];op=res'>Research Jump Start (5)</A><BR>"
				if(emagged && vouchers >= 10)
					dat += "<A href='byond://?src=\ref[src];op=emag'>Syndicate Bunker (15)</A><BR>"
				dat += "<A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
			if(2)
				dat += "Central Command has assessed that the average crew morale rate is 10% of its current rate. Therefore Central Command, with help from the Space Bounty Hunters, have ordained the use of a new reward system. Each quote 'antagonist' you bring to Central Command inside of the shuttle brig will result in a voucher being saved for future use up to a max of 20. Vouchers are spent at this console on rewards that benefit the entire station. Please note abuse will not be tolerated. Also note Central Command can not change the amount of vouchers."
				dat += "<A href='byond://?src=\ref[src];op=mm'>Main Menu</A><BR>"
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return
	Topic(href, href_list)
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			switch(href_list["op"])
				if("makevoucher")
					screenstate = 1
				if("order")
					screenstate = 2
				if("namevoucher")
					var/input = input("Who is the recipient?.",,"")
					if(input)
						tempname = input
				if("reasonvoucher")
					var/input = input("What is the reason for this voucher?.",,"")
					if(input)
						tempreason = input
				if("createvoucher")
					new/obj/item/bodybag(src.loc)
					tempreason = null
					tempname = null
				if("mm")
					screenstate = 0
				if("res")
					research = 1
					new/obj/item/weapon/research/mini(src.loc)
					vouchers -= 7
					command_alert("Attention. A research jumpstart item has been purchased with vouchers and been approved. Destroy it in the Destructive Analyzer. Do not depend on this.")
					message_admins("([usr.key]/[usr.real_name]) has purchased a research jumpstart with vouchers.")
				if("buycode")
					getcode()
					command_alert("Attention. An away mission opportunity has been purchased with vouchers and been approved. Please enter [tempcode] to your gateway computer. This code will not be repeated. Proceed with caution. Additionally memorize the gateway code listed on your main computer so you can return to the station.")
					message_admins("([usr.key]/[usr.real_name]) has purchased an away mission code with vouchers.")
					vouchers -= 10
				if("smes")
					command_alert("Attention. A powering of all SMES oppurtunity has been purchased with vouchers and been approved. Do not slack off in the future.")
					vouchers -= 10
					message_admins("([usr.key]/[usr.real_name]) has purchased refilled SMES with vouchers.")
					power_restore_quick()
				if("emag")
					special = 1
					getcode()
					usr << "We have received and approved of your request. Please enter [tempcode] into the gateway computer. This will be told only once. Additionally memorize the gateway code listed on the main gateway computer so you can return to the station."
					message_admins("([usr.key]/[usr.real_name]) has purchased a syndicate hiding spot with vouchers.")
					vouchers -= 10
		attack_hand(usr)
		return


/obj/machinery/voucher/proc/getcode()//They will never, EVER get this twice per round.
	var/list/L = new/list()
	if(special)
		for(var/obj/machinery/stargate/center/special/gate in world)
			if(gate.station)	continue
			L.Add(gate)
		if(!L.len)	return
		var/obj/machinery/stargate/center/P = pick(L)
		if(P)
			tempcode = P.code
			special = 0
	else
		for(var/obj/machinery/stargate/center/gate in world)
			if(gate.type == /obj/machinery/stargate/center/special) continue
			if(gate.station)	continue
			L.Add(gate)
		if(!L.len)	return
		var/obj/machinery/stargate/center/P = pick(L)
		if(P)
			tempcode = P.code



/obj/machinery/pointshop
	name = "Shop-O-Tron 5000"
	desc = "Used to spend your monopoly space cash.."
	anchored = 1
	icon = 'icons/obj/vending.dmi'
	icon_state = "casino"
	var/list/records
	var/datum/preferences/loggedin = 0
	density = 1

	attack_hand(mob/living/user)
		interact(user)

	interact(user)
		var/dat
		if( (in_range(src, user) && isturf(loc)) || istype(user, /mob/living/silicon) )
			dat = "<B>Shop-O-Tron 5000</B><BR>"

			if(loggedin)
				dat += "<a href='?src=\ref[src];op=logout'>\[Logout\]</a><br>"

				dat += "<br><B>Number of Points</b>: [loggedin.points]<br>"

				dat += "<A href='?src=\ref[src];buy=1'>Bear Pelt Hat - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=2'>Festive Crown - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=3'>Xeno Hat - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=4'>Xeno Suit - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=5'>Ian shirt - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=6'>Bronze Heart Medal - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=7'>Point Gift - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=8'>Space Cash - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=9'>Pig Mask - 1 Point</A><BR>"
				dat += "<A href='?src=\ref[src];buy=10'>Lipstick - 1 Point</A><BR>"

			else
				dat += "<a href='?src=\ref[src];op=login'>\[Login - Biometric Scan\]</a><br>"

		user << browse(dat, "window=pointshop")
		return

	Topic(href, href_list)
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			switch(href_list["op"])
				if("login","logout")
					if(loggedin)
						loggedin = null
					else
						loggedin = usr.client.prefs
			if(loggedin && loggedin.points >= 1)
				var/buynum = text2num(href_list["buy"])

				switch(buynum)
					if(1)	new /obj/item/clothing/head/bearpelt(loc)
					if(2)	new /obj/item/clothing/head/festive(loc)
					if(3)	new /obj/item/clothing/head/xenos(loc)
					if(4)	new /obj/item/clothing/suit/xenos(loc)
					if(5)	new /obj/item/clothing/suit/ianshirt(loc)
					if(6)	new /obj/item/clothing/tie/medal/conduct(loc)
					if(7)	new /obj/item/token(loc)
					if(8)	new /obj/item/weapon/spacecash/c10(loc)
					if(9)	new /obj/item/clothing/mask/pig(loc)
					if(10)	new /obj/item/weapon/lipstick/random(loc)
					else	return

				--loggedin.points
				loggedin.save_preferences()

			interact(usr)

	attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
		if (!(src.stat & (BROKEN | NOPOWER)))
			if(istype(I,/obj/item/token))
				if(loggedin)
					++loggedin.points
					user << "<span class='notice'>You insert the token to get a point.</span>"
					user.drop_item(I)
					del(I)
					loggedin.save_preferences()
					interact(user)
				else
					user << "<span class='notice'>Please login before inserting tokens.</span>"
