
//The traitor item list. If its on this list, it can be freely spawned
var/global/list/traitoritemlist = list(
/obj/item/weapon/gun/projectile,
/obj/item/ammo_magazine/a357,
/obj/item/weapon/gun/energy/crossbow,
/obj/item/weapon/melee/energy/sword,
/obj/item/weapon/storage/box/syndicate,
/obj/item/weapon/storage/box/emps,
/obj/item/weapon/pen/paralysis,
/obj/item/weapon/soap/syndie,
/obj/item/weapon/cartridge/syndicate/tracking,
/obj/item/clothing/under/chameleon,
/obj/item/clothing/shoes/syndigaloshes,
/obj/item/weapon/card/id/syndicate,
/obj/item/clothing/mask/gas/voice,
/obj/item/device/chameleon,
/obj/item/weapon/card/emag,
/obj/item/weapon/storage/toolbox/syndicate,
/obj/item/weapon/storage/box/syndie_kit/space,
/obj/item/clothing/glasses/thermal/syndi,
/obj/item/device/encryptionkey/binary,
/obj/item/weapon/aiModule/syndicate,
/obj/item/weapon/plastique,
/obj/item/device/powersink,
/obj/item/device/radio/beacon/syndicate,
/obj/item/weapon/circuitboard/teleporter,
/obj/item/weapon/gun/energy/disabler,
/obj/item/weapon/storage/box/syndie_kit/imp_freedom,
/obj/item/weapon/storage/box/syndie_kit/imp_uplink,
/obj/item/weapon/storage/box/syndie_kit/imp_explode,
/obj/item/toy/syndicateballoon,
/obj/item/device/soulstone,
/obj/item/weapon/storage/box/realammo,
/obj/item/weapon/storage/firstaid/evil,
/obj/item/seeds/alienplantseed,
/obj/item/clothing/glasses/thermal/librarian,
/obj/item/weapon/storage/pill_bottle/assx,
/obj/item/device/speaker/traitor,
/obj/item/weapon/storage/box/slip,
/obj/item/weapon/disk/chefupgrade,
/obj/item/device/flash
	)


//Sneaky sneaky fuckers
//In theory anyone who spawns these from a PDA gets gibbed
var/global/list/badlist = list(
/obj/machinery/singularity/narsie,
/obj/machinery/singularity/narsie/large,
/obj/item/clothing/under/psyche,
/obj/item/weapon/storage/backpack/holding,
/obj/machinery/singularity,
/obj/machinery/syndicate_beacon,
/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	)


/*
A list of items and costs is stored under the datum of every game mode, alongside the number of crystals, and the welcoming message.
However note the job specific items are all here
*/

/obj/item/device/uplink
	var/welcome 					// Welcoming menu message
	var/items						// List of items
	var/item_data					// raw item text
	var/list/ItemList				// Parsed list of items
	var/uses 						// Numbers of crystals
	var/job_items_allowed			// Set at new, if false it will not add any special items
	var/list/special_items = list() // Job Specific Items List
	//var/sec_code					// Might stop href fuckery
	// List of items not to shove in their hands.
	var/list/NotInHand = list(/obj/machinery/singularity_beacon/syndicate)



	New()
		welcome = ticker.mode.uplink_welcome
		job_items_allowed = ticker.mode.uplink_special_items
		if(!item_data)
			items = replacetext(ticker.mode.uplink_items, "\n", "")	// Getting the text string of items
		else
			items = replacetext(item_data)
		ItemList = text2list(src.items, ";")	// Parsing the items text string
		uses = ticker.mode.uplink_uses
		//sec_code = rand(99999)//Sets the code at spawn, in theory should be random


	//Checks the user's mind for a job and then adds any special items to the special_items list
	proc/setup_job_items(var/mob/user)
		if(!user) return
		if(!job_items_allowed) return
		special_items = new/list()//Setting up the list
		special_items += "Whitespace:Seperator"
		special_items += "Job Specific Items"// Catagory Title
		switch("[user.mind.assigned_role]")
			if("Bartender")//User job, all newly added items and jobs shoud be set up as the following
				special_items += "/obj/item/weapon/storage/box/realammo:3:Real Shotgun Rounds"// Item path : cost# : Displayed name
				special_items += "Whitespace:Seperator" //Whitespace:Seperator for a blank line
			if("Chaplain")
				special_items += "/obj/item/device/soulstone:6:Soulstone"
				special_items += "Whitespace:Seperator"
			//if("Station Engineer")
			//	special_items += "/obj/item/weapon/storage/box/syndie_kit/rig:4:RIG Suit"
			//	special_items += "Whitespace:Seperator"
			if("Medical Doctor")
				special_items += "/obj/item/weapon/storage/firstaid/evil:3:Anti-Healing Kit"
				special_items += "Whitespace:Seperator"
			if("Botanist")
				special_items += "/obj/item/seeds/alienplantseed:6:Man Eating Plant Seeds!"
				special_items += "Whitespace:Seperator"
			if("Librarian")
				special_items += "/obj/item/clothing/glasses/thermal/librarian:3:Thermal Prescription Glasses"
				special_items += "Whitespace:Seperator"
			if("Chemist")
				special_items += "/obj/item/weapon/storage/pill_bottle/assx:6:ASS-X Pills"
				special_items += "Whitespace:Seperator"
			if("Mime")
				special_items += "/obj/item/device/speaker/traitor:6:Modified Text-To-Speech Device"
//				special_items += "/obj/item/weapon/gun/energy/silentgun:3:Voice Silencer Gun"
				special_items += "Whitespace:Seperator"
			if("Janitor")
				special_items += "/obj/item/weapon/storage/box/slip:4:Slip Signs"
				special_items += "Whitespace:Seperator"
			if("Chef")
				special_items += "/obj/item/weapon/disk/chefupgrade:4:Gibber Upgrade"
				special_items += "Whitespace:Seperator"
		return


	//Takes the ItemList and special_items and builds a buy menu
	proc/generate_menu()
		var/cost
		var/item
		var/name
		var/path_obj
		var/path_text
		var/category_items = 1 //To prevent stupid :P

		var/dat = "<B>[src.welcome]</B><BR>"
		dat += "Tele-Crystals left: [src.uses]<BR>"
		dat += "<HR>"
		dat += "<B>Request item:</B><BR>"
		dat += "<I>Each item costs a number of tele-crystals as indicated by the number following their name.</I><br><BR>"

		for(var/D in ItemList + special_items)
			var/list/O = stringsplit(D, ":")
			if(O.len != 3)	//If it is not an actual item, make a break in the menu.
				if(O.len == 1)	//If there is one item, it's probably a title
					dat += "<b>[O[1]]</b><br>"
					category_items = 0
				else	//Else, it's a white space.
					if(category_items < 1)	//If there were no itens in the last category...
						dat += "<i>We apologize, as you could not afford anything from this category.</i><br>"
					dat += "<br>"
				continue

			path_text = O[1]
			cost = text2num(O[2])

			if(cost>uses)
				continue

			path_obj = text2path(path_text)

			// Because we're using strings, this comes up if item paths change.
			// Failure to handle this error borks uplinks entirely.  -Sayu
			if(!path_obj)
				error("Syndicate item is not a valid path: [path_text]")
			else
				item = new path_obj()
				name = O[3]
				del item

				dat += "<A href='byond://?src=\ref[src];buy_item=[path_text];cost=[cost]'>[name]</A> ([cost])<BR>"
				category_items++

		//dat += "<A href='byond://?src=\ref[src];buy_item=random'>Random Item (??)</A><br>"
		dat += "<HR>"
		return dat

	Topic(href, href_list)
		/*if(!href_list["code"])
			message_admins("[usr] is attempting to call an uplink's topic without a code!")
			return 0
		if(href_list["code"] != sec_code)
			message_admins("[usr] is attempting to call an uplink's topic with the wrong code!")
			return 0*/
		if(href_list["buy_item"]).
			var/path_obj = text2path(href_list["buy_item"])
			if(path_obj in badlist)
				message_admins("Href Warning: [usr] has attempted to spawn something bad via an uplink (Do not ignore this)")
				log_admin("Href Warning: [usr] has attempted to spawn something bad via an uplink")
				usr << "Nice try"//Gloat at them
				spawn(0)
					usr.ghostize()
					usr.death(1)
					del(usr)//Delete them because they were exploiting the game.
				return 1
			if(path_obj in traitoritemlist)//Checks if its a traitor item, occurs after the badlist
				if(text2num(href_list["cost"]) > uses) // Not enough crystals for the item
					return 0
				uses -= text2num(href_list["cost"])
				return 1
			else//Lets us know if they try to spawn something not in the traitor item list, but isn't on the bad list.
				message_admins("[usr] has attempted to spawn something via PDA hrefs!")
				log_admin("[usr] has attempted to spawn something via PDA hrefs")
				del(src)//Deletes the uplink because they were not going to have any good intentions anyway

		return 0


// HIDDEN UPLINK - Can be stored in anything but the host item has to have a trigger for it.
/* How to create an uplink in 3 easy steps!

 1. All obj/item 's have a hidden_uplink var. By default it's null. Give the item one with "new(src)", it must be in it's contents. Feel free to add "uses".

 2. Code in the triggers. Use check_trigger for this, I recommend closing the item's menu with "usr << browse(null, "window=windowname") if it returns true.
 The var/value is the value that will be compared with the var/target. If they are equal it will activate the menu.

 3. If you want the menu to stay until the users locks his uplink, add an active_uplink_check(mob/user as mob) in your interact/attack_hand proc.
 Then check if it's true, if true return. This will stop the normal menu appearing and will instead show the uplink menu.
*/

/obj/item/device/uplink/hidden
	name = "Hidden Uplink."
	desc = "There is something wrong if you're examining this."
	var/active = 0
	var/list/purchase_log = list()

// The hidden uplink MUST be inside an obj/item's contents.
	New()
		spawn(2)
			if(!istype(src.loc, /obj/item))
				del(src)
		..()
		return

	// Toggles the uplink on and off. Normally this will bypass the item's normal functions and go to the uplink menu, if activated.
	proc/toggle()
		active = !active

// Directly trigger the uplink. Turn on if it isn't already.
	proc/trigger(mob/user as mob)
		if(!active)
			toggle()
		interact(user)
		return

// Checks to see if the value meets the target. Like a frequency being a traitor_frequency, in order to unlock a headset.
// If true, it accesses trigger() and returns 1. If it fails, it returns false. Use this to see if you need to close the
// current item's menu.
	proc/check_trigger(mob/user as mob, var/value, var/target)
		if(value == target)
			trigger(user)
			return 1
		return 0

// Interaction code. Gathers a list of items purchasable from the paren't uplink and displays it. It also adds a lock button.
	interact(mob/user as mob)
		var/dat = "<body link='yellow' alink='white' bgcolor='#601414'><font color='white'>"
		setup_job_items(user)
		dat += src.generate_menu()
		dat += "<A href='byond://?src=\ref[src];lock=1'>Lock</a>"
		dat += "</font></body>"
		user << browse(dat, "window=hidden")
		onclose(user, "hidden")
		return


// The purchasing code.
	Topic(href, href_list)
		if (usr.stat || usr.restrained())
			return

		if (!( istype(usr, /mob/living/carbon/human)))
			return 0

		if ((usr.contents.Find(src.loc) || (in_range(src.loc, usr) && istype(src.loc.loc, /turf))))
			usr.set_machine(src)
			if(href_list["lock"])
				toggle()
				usr << browse(null, "window=hidden")
				return 1

			if(..(href, href_list) == 1)
				var/path_obj = text2path(href_list["buy_item"])
				if(path_obj in badlist)
					message_admins("Href Warning: [usr] has attempted to spawn something bad via an uplink (Do not ignore this)")
					log_admin("Href Warning: [usr] has attempted to spawn something bad via an uplink")
					usr << "Nice try"//Gloat at them
					spawn(0)
						usr.ghostize()
						usr.death(1)
						del(usr)//Delete them because they were exploiting the game.
					return 1
				if(path_obj in traitoritemlist)
					var/obj/I = new path_obj(get_turf(usr))
					if(ishuman(usr))
						var/mob/living/carbon/human/A = usr
						A.put_in_any_hand_if_possible(I)
					purchase_log += "[usr] ([usr.ckey]) bought [I]."
				else
					message_admins("[usr] has attempted to spawn something via HREFs!")
		interact(usr)
		return

// I placed this here because of how relevant it is.
// You place this in your uplinkable item to check if an uplink is active or not.
// If it is, it will display the uplink menu and return 1, else it'll return false.
// If it returns true, I recommend closing the item's normal menu with "user << browse(null, "window=name")"
/obj/item/proc/active_uplink_check(mob/user as mob)
	// Activates the uplink if it's active
	if(src.hidden_uplink)
		if(src.hidden_uplink.active)
			src.hidden_uplink.trigger(user)
			return 1
	return 0

// PRESET UPLINKS
// A collection of preset uplinks.
//
// Includes normal radio uplink, multitool uplink,
// implant uplink (not the implant tool) and a preset headset uplink.

/obj/item/device/radio/uplink/New()
	hidden_uplink = new(src)
	icon_state = "radio"

/obj/item/device/radio/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/multitool/uplink/New()
	hidden_uplink = new(src)

/obj/item/device/multitool/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/radio/headset/uplink
	traitor_frequency = 1445

/obj/item/device/radio/headset/uplink/New()
	..()
	hidden_uplink = new(src)
	hidden_uplink.uses = 10


/*

/obj/item/device/uplink/proc/handleStatTracking(var/boughtItem)
//For stat tracking, sorry for making it so ugly
	if(!boughtItem) return

	switch(boughtItem)
		if("/obj/item/weapon/circuitboard/teleporter")

		if("/obj/item/toy/syndicateballoon")

		if("/obj/item/weapon/storage/box/syndie_kit/imp_uplink")

		if("/obj/item/weapon/storage/box/syndicate")

		if("/obj/item/weapon/aiModule/syndicate")

		if("/obj/item/device/radio/beacon/syndicate")

		if("/obj/item/weapon/gun/projectile")

		if("/obj/item/weapon/gun/energy/crossbow")

		if("/obj/item/device/powersink")

		if("/obj/item/weapon/melee/energy/sword")

		if("/obj/item/clothing/mask/gas/voice")

		if("/obj/item/device/chameleon")

		if("/obj/item/weapon/storage/box/emps")

		if("/obj/item/weapon/pen/paralysis")

		if("/obj/item/weapon/cartridge/syndicate")

		if("/obj/item/clothing/under/chameleon")

		if("/obj/item/weapon/card/id/syndicate")

		if("/obj/item/weapon/card/emag")

		if("/obj/item/weapon/storage/box/syndie_kit/space")

		if("/obj/item/device/encryptionkey/binary")

		if("/obj/item/weapon/storage/box/syndie_kit/imp_freedom")

		if("/obj/item/clothing/glasses/thermal/syndi")

		if("/obj/item/ammo_magazine/a357")

		if("/obj/item/clothing/shoes/syndigaloshes")

		if("/obj/item/weapon/plastique")

		if("/obj/item/weapon/soap/syndie")

		if("/obj/item/weapon/storage/toolbox/syndicate")



*/
