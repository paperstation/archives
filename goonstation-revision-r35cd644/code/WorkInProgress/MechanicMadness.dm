//TODO:
// - Stun and ghost checks for the verbs
// - Buttons can be picked up with the hands full. Woops.
// - Message Datum pooling and recycling.
// - Check if something is already connected and prevent from double connecting.

//Important Notes:
//
//Please try to always re-use incoming signals for your outgoing signals.
//Just modify the message of the incoming signal and send it along.
//This is important because each message keeps track of which nodes it traveled trough.
//It's through that list that we can prevent infinite loops. Or at least try to.
//(People can probably still create infinite loops somehow. They always manage)
//Always use the newSignal proc of the mechanics holder of the sending object when creating a new message.

#define MECHFAILSTRING "You must be holding a Multitool to change Connections or Options."

//Global list of telepads so we don't have to loop through the entire world aaaahhh.
var/list/mechanics_telepads = new/list()

/datum/mechanicsMessage
	var/signal = "1"
	var/list/nodes = list()

	proc/addNode(var/datum/mechanics_holder/H)
		nodes.Add(H)

	proc/removeNode(var/datum/mechanics_holder/H)
		nodes.Remove(H)

	proc/hasNode(var/datum/mechanics_holder/H)

		return nodes.Find(H)

	proc/isTrue() //Thanks for not having bools , byond.
		if(istext(signal))
			if(lowertext(signal) == "true" || lowertext(signal) == "1" || lowertext(signal) == "one") return 1
		else if (isnum(signal))
			if(signal == 1) return 1
		return 0

/datum/mechanics_holder
	var/atom/master = null
	var/list/connected_outgoing = list()
	var/list/connected_incoming = list()
	var/list/inputs = list()

	var/outputSignal = "1"
	var/triggerSignal = "1"

	//Adds an input "slot" to the holder /w a proc mapping.
	proc/addInput(var/name, var/toCall)
		if(inputs.Find(name)) inputs.Remove(name)
		inputs.Add(name)
		inputs[name] = toCall
		return

	//Fire given input by names with the message as argument.
	proc/fireInput(var/name, var/datum/mechanicsMessage/msg)
		if(!inputs.Find(name)) return
		var/path = inputs[name]
		spawn(1) call(master, path)(msg)
		return

	//Fire an outgoing connection with given value. Try to re-use incoming messages for outgoing signals whenever possible!
	//This reduces load AND preserves the node list which prevents infinite loops.
	proc/fireOutgoing(var/datum/mechanicsMessage/msg)

		//If we're already in the node list we will not send the signal on.
		if(!msg.hasNode(src))
			msg.addNode(src)
		else
			return

		for(var/atom/M in connected_outgoing)
			if(M.mechanics)
				M.mechanics.fireInput(connected_outgoing[M], cloneMessage(msg))
		return

	//Used to copy a message because we don't want to pass a single message to multiple components which might end up modifying it both at the same time.
	proc/cloneMessage(var/datum/mechanicsMessage/msg)
		var/datum/mechanicsMessage/msg2 = newSignal(msg.signal)
		msg2.nodes = msg.nodes.Copy()
		return msg2

	//ALWAYS use this to create new messages!!!
	proc/newSignal(var/sig)
		var/datum/mechanicsMessage/ret = new/datum/mechanicsMessage
		ret.signal = sig
		return ret

	//Delete all incoming connections
	proc/wipeIncoming()
		for(var/atom/M in connected_incoming)
			if(M.mechanics)
				M.mechanics.connected_outgoing.Remove(master)
			connected_incoming.Remove(M)
		return

	//Delete all outgoing connections.
	proc/wipeOutgoing()
		for(var/atom/M in connected_outgoing)
			if(M.mechanics) M.mechanics.connected_incoming.Remove(master)
			connected_outgoing.Remove(M)
		return

	//Helper proc to check if a mob is allowed to change connections. Right now you only need a multitool.
	proc/allowChange(var/mob/M)
		if(hasvar(M, "l_hand") && istype(M:l_hand, /obj/item/device/multitool)) return 1
		if(hasvar(M, "r_hand") && istype(M:r_hand, /obj/item/device/multitool)) return 1
		if(hasvar(M, "module_states"))
			for(var/atom/A in M:module_states)
				if(istype(A, /obj/item/device/multitool))
					return 1
		return 0

	//Called when a component is dragged onto another one.
	proc/dropConnect(obj/O, null, var/src_location, var/control_orig, var/control_new, var/params)
		if(O == master || !O.mechanics) return

		var/typesel = input(usr, "Use [master] as:", "Connection Type") in list("Trigger", "Receiver", "*CANCEL*")
		if(typesel == "*CANCEL*") return
		switch(typesel)

			if("Trigger")
				if(O.mechanics.connected_outgoing.Find(master))
					boutput(usr, "<span style=\"color:red\">Can not create a direct loop between 2 components.</span>")
					return

				if(O.mechanics.inputs.len)
					var/selected_input = input(usr, "Select \"[O]\" Input", "Input Selection") in O.mechanics.inputs + "*CANCEL*"
					if(selected_input == "*CANCEL*") return
					connected_outgoing.Add(O)
					connected_outgoing[O] = selected_input
					O.mechanics.connected_incoming.Add(master)
					boutput(usr, "<span style=\"color:green\">You connect the [master.name] to the [O.name].</span>")
				else
					boutput(usr, "<span style=\"color:red\">[O] has no input slots. Can not connect [master] as Trigger.</span>")

			if("Receiver")
				if(O.mechanics.connected_incoming.Find(master))
					boutput(usr, "<span style=\"color:red\">Can not create a direct loop between 2 components.</span>")
					return

				if(inputs.len)
					var/selected_input = input(usr, "Select \"[master]\" Input", "Input Selection") in inputs + "*CANCEL*"
					if(selected_input == "*CANCEL*") return
					O.mechanics.connected_outgoing.Add(master)
					O.mechanics.connected_outgoing[master] = selected_input
					connected_incoming.Add(O)
					boutput(usr, "<span style=\"color:green\">You connect the [master.name] to the [O.name].</span>")
				else
					boutput(usr, "<span style=\"color:red\">[master] has no input slots. Can not connect [O] as Trigger.</span>")

			if("*CANCEL*")
				return
		return

/obj/item/mechanics
	name = "testhing"
	icon = 'icons/misc/mechanicsExpansion.dmi'
	icon_state = "comp_unk"
	item_state = "swat_suit"
	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 1.0
	level = 2
	var/under_floor = 0
	var/list/particles = new/list()

	New()
		mechanics = new(src)
		mechanics.master = src
		if (!(src in processing_items))
			processing_items.Add(src)
		return ..()

	proc/cutParticles()
		if(particles.len)
			for(var/datum/particleSystem/mechanic/M in particles)
				M.Die()
			particles.Cut()
		return

	process()
		if(level == 2 || under_floor)
			cutParticles()
			return

		if(particles.len != mechanics.connected_outgoing.len)
			cutParticles()
			for(var/atom/X in mechanics.connected_outgoing)
				particles.Add(particleMaster.SpawnSystem(new /datum/particleSystem/mechanic(src.loc, X.loc)))

		return

	attack_hand(mob/user as mob)
		if(level == 1) return
		if(issilicon(user)) return
		else return ..(user)

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W,/obj/item/wrench))
			switch(level)
				if(1) //Level 1 = wrenched into place
					boutput(user, "You detach the [src] from the underfloor and deactivate it.")
					level = 2
					anchored = 0
				if(2) //Level 2 = loose
					if(!isturf(src.loc))
						boutput(usr, "<span style=\"color:red\">[src] needs to be on the ground for that to work.</span>")
						return 0
					boutput(user, "You attach the [src] to the underfloor and activate it.")
					logTheThing("station", user, src, "placed a %target% at [showCoords(src.x, src.y, src.z)]")
					level = 1
					anchored = 1

			var/turf/T = src.loc
			if(isturf(T))
				hide(T.intact)
			else
				hide()

			mechanics.wipeIncoming()
			mechanics.wipeOutgoing()
			return 1
		return 0

	pickup()
		if(level == 1) return
		mechanics.wipeIncoming()
		mechanics.wipeOutgoing()
		return ..()

	dropped()
		mechanics.wipeIncoming()
		mechanics.wipeOutgoing()
		return ..()

	MouseDrop(obj/O, null, var/src_location, var/control_orig, var/control_new, var/params)

		if(!istype(usr, /mob/living))
			return

		if(level == 2 || (istype(O, /obj/item/mechanics) && O.level == 2))
			boutput(usr, "<span style=\"color:red\">Both components need to be secured into place before they can be connected.</span>")
			return

		if(usr.stat)
			return

		if(!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		mechanics.dropConnect(O, null, src_location, control_orig, control_new, params)
		return ..()

	proc/componentSay(var/string)
		string = trim(sanitize(html_encode(string)), 1)
		for(var/mob/O in all_hearers(7, src.loc))
			O.show_message("<span class='game radio'><span class='name'>[src]</span><b> [bicon(src)] [pick("squawks", "beeps", "boops", "says", "screeches")], </b> <span class='message'>\"[string]\"</span></span>",2)

	verb/wipe()
		set src in view(1)
		set name = "\[Disconnect All\]"
		set desc = "Disconnects all devices connected to this device."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		mechanics.wipeIncoming()
		mechanics.wipeOutgoing()
		boutput(usr, "<span style=\"color:blue\">You disconnect [src].</span>")
		return

	verb/setvalue()
		set src in view(1)
		set name = "\[Set Send-Signal\]"
		set desc = "Sets the signal that is sent when this device is triggered."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Signal:","Signal setting","1") as text
		inp = trim(adminscrub(inp), 1)
		if(length(inp))
			mechanics.outputSignal = inp
			boutput(usr, "Signal set to [inp]")
		return

	hide(var/intact)
		under_floor = (intact && level==1)
		updateIcon()
		return

	proc/updateIcon()
		return

/obj/item/mechanics/cashmoney
	name = "Payment component"
	desc = ""
	icon_state = "comp_money"
	density = 0
	var/price = 100
	var/code = null
	var/collected = 0
	var/current_buffer = 0
	var/ready = 1

	var/thank_string = ""

	get_desc()
		. += {"<br><span style=\"color:blue\">Collected money: [collected]<br>
		Current price: [price] credits</span>"}

	New()
		..()
		mechanics.addInput("eject money", "emoney")
		return


	proc/emoney(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input)
			if(input.signal == code)
				ejectmoney()
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(..(W, user)) return
		else if (istype(W, /obj/item/spacecash) && ready)
			ready = 0
			spawn(30) ready = 1
			current_buffer += W.amount
			if (src.price <= 0)
				src.price = initial(src.price)
			if(current_buffer >= price)
				if(length(thank_string))
					componentSay("[thank_string]")

				if(current_buffer > price)
					componentSay("Here is your change!")
					var/obj/item/spacecash/C = new /obj/item/spacecash(user.loc, current_buffer - price)
					user.put_in_hand_or_drop(C)

				collected += price
				current_buffer = 0

				usr.drop_item()
				del(W)

				var/datum/mechanicsMessage/msg = mechanics.newSignal(mechanics.outputSignal)
				mechanics.fireOutgoing(msg)
				flick("comp_money1", src)
		return


	proc/ejectmoney()
		if(collected)
			new /obj/item/spacecash(get_turf(src), collected)
			collected = 0
		return

	verb/setprice()
		set src in view(1)
		set name = "\[Set Price\]"
		set desc = "Sets the price."

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		if(code)
			var/codecheck = strip_html(input(usr,"Please enter current code:","Code check","") as text)
			if(codecheck != code)
				boutput(usr, "<span style=\"color:red\">[bicon(src)]: Incorrect code entered.</span>")
				return

		var/inp = input(usr,"Enter new price:","Price setting", price) as num
		if(inp)
			if (inp < 0)
				usr.show_text("You cannot set a negative price.", "red") // Infinite credits exploit.
				return
			if (inp == 0)
				usr.show_text("Please set a price higher than zero.", "red")
				return
			if (inp > 1000000) // ...and just to be on the safe side. Should be plenty.
				inp = 1000000
				usr.show_text("[src] is not designed to handle such large transactions. Input has been set to the allowable limit.", "red")
			price = inp
			boutput(usr, "Price set to [inp]")
		return

	verb/ejectmoneyverb()
		set src in view(1)
		set name = "\[Eject money\]"
		set desc = "Ejects the collected money."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return

		if(code)
			var/codecheck = strip_html(input(usr,"Please enter current code:","Code check","") as text)
			if(codecheck != code)
				boutput(usr, "<span style=\"color:red\">[bicon(src)]: Incorrect code entered.</span>")
				return

		ejectmoney()

		return

	verb/setcode()
		set src in view(1)
		set name = "\[Set Code\]"
		set desc = "Sets code that is required to eject money and set prices."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		if(code)
			var/codecheck = adminscrub(input(usr,"Please enter current code:","Code check","") as text)
			if(codecheck != code)
				boutput(usr, "<span style=\"color:red\">[bicon(src)]: Incorrect code entered.</span>")
				return

		var/inp = adminscrub(input(usr,"Please enter new code:","Code setting","dosh") as text)
		if(length(inp))
			code = inp
			boutput(usr, "Code set to [inp]")
		return

	verb/setthankstr()
		set src in view(1)
		set name = "\[Set Thank-string\]"
		set desc = "Sets the Thank-string."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		thank_string = adminscrub(input(usr,"Please enter string:","string","Thanks for using this mechcomp service!") as text)
		return

/obj/item/mechanics/flushcomp
	name = "Flusher component"
	desc = ""
	icon_state = "comp_flush"

	var/ready = 1
	var/obj/disposalpipe/trunk/trunk = null
	var/datum/gas_mixture/air_contents

	New()
		. = ..()
		verbs -= /obj/item/mechanics/verb/setvalue
		mechanics.addInput("flush", "flushp")

	disposing()
		if(air_contents)
			pool(air_contents)
			air_contents = null
		trunk = null
		..()

	attackby(obj/item/W as obj, mob/user as mob)
		if(..(W, user))
			if(src.level == 1) //wrenched down
				trunk = locate() in src.loc
				if(trunk)
					trunk.linked = src
					air_contents = unpool(/datum/gas_mixture)
			else if (src.level == 2) //loose
				trunk.linked = null
				if(air_contents)
					pool(air_contents)
				air_contents = null
				trunk = null
		return

	proc/flushp(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input && input.signal && ready && trunk)
			ready = 0
			for(var/atom/movable/M in src.loc)
				if(M == src || M.anchored) continue
				M.set_loc(src)
			flushit()
			spawn(20) ready = 1
		return

	proc/flushit()
		if(!trunk) return
		var/obj/disposalholder/H = new()

		H.init(src)

		air_contents.zero()

		flick("comp_flush1", src)
		sleep(10)
		playsound(src, "sound/machines/disposalflush.ogg", 50, 0, 0)

		H.start(src) // start the holder processing movement
		return

	proc/expel(var/obj/disposalholder/H)

		var/turf/target
		playsound(src, "sound/machines/hiss.ogg", 50, 0, 0)
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.set_loc(src.loc)
			AM.pipe_eject(0)
			spawn(1)
				if(AM)
					AM.throw_at(target, 5, 1)

		H.vent_gas(loc)
		qdel(H)

/obj/item/mechanics/thprint
	name = "Thermal printer"
	desc = ""
	icon_state = "comp_tprint"
	var/ready = 1
	var/paper_name = "thermal paper"

	New()
		..()
		mechanics.addInput("print", "print")
		return

	proc/print(var/datum/mechanicsMessage/input)
		if(level == 2 || !ready) return
		if(input)
			ready = 0
			spawn(50) ready = 1
			flick("comp_tprint1",src)
			playsound(src.loc, "sound/machines/printer_thermal.ogg", 60, 0)
			var/obj/item/paper/thermal/P = new/obj/item/paper/thermal(src.loc)
			P.info = strip_html(html_decode(input.signal))
			P.name = paper_name
		return

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(level == 2 && get_dist(src, target) == 1)
			if(isturf(target) && target.density)
				user.drop_item()
				src.loc = target
		return

	verb/setthprintstr()
		set src in view(1)
		set name = "\[Set paper name\]"
		set desc = "Sets the name of the printed paper."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter name:","name setting", paper_name) as text
		paper_name = adminscrub(inp)
		boutput(usr, "String set to [paper_name]")
		return

/obj/item/mechanics/pscan
	name = "Paper scanner"
	desc = ""
	icon_state = "comp_pscan"
	var/del_paper = 1
	var/thermal_only = 1
	var/ready = 1

	New()
		..()
		return

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(level == 2 && get_dist(src, target) == 1)
			if(isturf(target) && target.density)
				user.drop_item()
				src.loc = target
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(..(W, user)) return
		else if (istype(W, /obj/item/paper) && ready)
			if(thermal_only && !istype(W, /obj/item/paper/thermal))
				boutput(user, "<span style=\"color:red\">This scanner only accepts thermal paper.</span>")
				return
			ready = 0
			spawn(30) ready = 1
			flick("comp_pscan1",src)
			playsound(src.loc, "sound/machines/twobeep2.ogg", 90, 0)
			var/obj/item/paper/P = W
			var/saniStr = strip_html(sanitize(html_encode(P.info)))
			var/datum/mechanicsMessage/msg = mechanics.newSignal(saniStr)
			mechanics.fireOutgoing(msg)
			if(del_paper)
				del(W)
		return

	verb/togglepsdel()
		set src in view(1)
		set name = "\[Toggle Paper consumption\]"
		set desc = "Sets whether the scanner consumes the paper used on it or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		del_paper = !del_paper
		boutput(usr, "[del_paper ? "Now consuming paper":"Now NOT consuming paper"]")
		return

	verb/togglepstherm()
		set src in view(1)
		set name = "\[Toggle thermal paper mode\]"
		set desc = "Sets whether the scanner only accepts thermal paper or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		thermal_only = !thermal_only
		boutput(usr, "[thermal_only ? "Now accepting only thermal paper":"Now accepting any paper"]")
		return

/obj/item/mechanics/hscan
	name = "Hand scanner"
	desc = ""
	icon_state = "comp_hscan"
	var/send_name = 0
	var/ready = 1

	New()
		..()
		return

	attack_hand(mob/user as mob)
		if(level != 2 && ready)
			if(istype(user, /mob/living/carbon/human) && user.bioHolder)
				ready = 0
				spawn(30) ready = 1
				flick("comp_hscan1",src)
				playsound(src.loc, "sound/machines/twobeep2.ogg", 90, 0)
				var/sendstr = (send_name ? user.real_name : md5(user.bioHolder.Uid))
				var/datum/mechanicsMessage/msg = mechanics.newSignal(sendstr)
				mechanics.fireOutgoing(msg)
			else
				boutput(user, "<span style=\"color:red\">The hand scanner can only be used by humanoids.</span>")
				return
		else return ..(user)

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		if(level == 2 && get_dist(src, target) == 1)
			if(isturf(target) && target.density)
				user.drop_item()
				src.loc = target
		return

	verb/togglehssig()
		set src in view(1)
		set name = "\[Toggle Signal type\]"
		set desc = "Toggles between the different signal modes."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		send_name = !send_name
		boutput(usr, "[send_name ? "Now sending user NAME":"Now sending user FINGERPRINT"]")
		return


/obj/item/mechanics/accelerator
	name = "Graviton accelerator"
	desc = ""
	icon_state = "comp_accel"
	var/active = 0

	New()
		..()
		mechanics.addInput("activate", "activateproc")
		return

	proc/drivecurrent()
		if(level == 2) return
		var/count = 0
		for(var/atom/movable/M in src.loc)
			if(M.anchored) continue
			count++
			if(M == src) continue
			throwstuff(M)
			if(count > 50) return

	proc/activateproc(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input)
			if(active) return
			particleMaster.SpawnSystem(new /datum/particleSystem/gravaccel(src.loc, src.dir))
			spawn(0)
				if(src)
					icon_state = "[under_floor ? "u":""]comp_accel1"
					active = 1
					spawn(0) drivecurrent()
					spawn(5) drivecurrent()
				sleep(30)
				if(src)
					icon_state = "[under_floor ? "u":""]comp_accel"
					active = 0
		return

	proc/throwstuff(atom/movable/AM as mob|obj)
		if(level == 2 || AM.anchored || AM == src) return
		if(AM.throwing) return
		var/atom/target = get_edge_target_turf(AM, src.dir)
		spawn(0) AM.throw_at(target, 50, 1)
		return

	HasEntered(atom/movable/AM as mob|obj)
		if(level == 2) return
		if(active)
			throwstuff(AM)
		return

	verb/setdir()
		set src in view(1)
		set name = "\[Rotate\]"
		set desc = "Rotates the object"
		set category = "Local"
		if (usr.stat)
			return
		src.dir = turn(src.dir, 90)
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_accel"
		return

/obj/item/mechanics/pausecomp
	name = "Delay Component"
	desc = ""
	icon_state = "comp_wait"
	var/active = 0
	var/delay = 10

	get_desc()
		. += "<br><span style=\"color:blue\">Current Delay: [delay]</span>"

	New()
		..()
		mechanics.addInput("delay", "delayproc")
		return

	proc/delayproc(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input)
			if(active) return
			spawn(0)
				if(src)
					icon_state = "[under_floor ? "u":""]comp_wait1"
					active = 1
				sleep(delay)
				if(src)
					mechanics.fireOutgoing(input)
					icon_state = "[under_floor ? "u":""]comp_wait"
					active = 0
		return

	verb/setdelay()
		set src in view(1)
		set name = "\[Set Delay\]"
		set desc = "Sets the delay"
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr, "Enter delay in 10ths of a second:", "Set delay", 10) as num
		inp = max(inp, 10)
		if(inp)
			delay = inp
			boutput(usr, "Set delay to [inp]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_wait"
		return

/obj/item/mechanics/andcomp
	name = "AND Component"
	desc = ""
	icon_state = "comp_and"
	var/timeframe = 30
	var/inp1 = 0
	var/inp2 = 0

	get_desc()
		. += "<br><span style=\"color:blue\">Current Time Frame: [timeframe]</span>"

	New()
		..()
		mechanics.addInput("input 1", "fire1")
		mechanics.addInput("input 2", "fire2")
		return

	proc/fire1(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(inp1) return

		inp1 = 1

		if(inp2)
			input.signal = mechanics.outputSignal
			mechanics.fireOutgoing(input)
			inp1 = 0
			inp2 = 0
			return

		spawn(timeframe)
			inp1 = 0

		return

	proc/fire2(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(inp2) return

		inp2 = 1

		if(inp1)
			input.signal = mechanics.outputSignal
			mechanics.fireOutgoing(input)
			inp1 = 0
			inp2 = 0
			return

		spawn(timeframe)
			inp2 = 0

		return

	verb/settframe()
		set src in view(1)
		set name = "\[Set Time Frame\]"
		set desc = "Sets the Time Frame during which the second Signal needs to arrive."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr, "Enter Time Frame in 10ths of a second:", "Set Time Frame", timeframe) as num
		if(inp)
			timeframe = inp
			boutput(usr, "Set Time Frame to [inp]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_and"
		return

/obj/item/mechanics/orcomp
	name = "OR Component"
	desc = ""
	icon_state = "comp_or"

	New()
		..()
		mechanics.addInput("input 1", "fire")
		mechanics.addInput("input 2", "fire")
		mechanics.addInput("input 3", "fire")
		mechanics.addInput("input 4", "fire")
		mechanics.addInput("input 5", "fire")
		mechanics.addInput("input 6", "fire")
		mechanics.addInput("input 7", "fire")
		mechanics.addInput("input 8", "fire")
		mechanics.addInput("input 9", "fire")
		mechanics.addInput("input 10", "fire")
		return

	proc/fire(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input.signal == mechanics.triggerSignal)
			input.signal = mechanics.outputSignal
			mechanics.fireOutgoing(input)
		return

	verb/settvalue()
		set src in view(1)
		set name = "\[Set Trigger-Signal\]"
		set desc = "Sets the signal that causes this component to fire."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Signal:","Signal setting","1") as text
		if(length(inp))
			inp = strip_html(html_decode(inp))
			mechanics.triggerSignal = inp
			boutput(usr, "Signal set to [inp]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_or"
		return

/obj/item/mechanics/wifisplit
	name = "Wifi Signal Splitter Component"
	desc = ""
	icon_state = "comp_split"

	get_desc()
		. += "<br><span style=\"color:blue\">Current Trigger Field: [mechanics.triggerSignal]</span>"

	New()
		..()
		mechanics.addInput("split", "split")
		return

	proc/split(var/datum/mechanicsMessage/input)
		if(level == 2) return
		var/list/converted = params2list(input.signal)
		if(converted.len)
			if(converted.Find(mechanics.triggerSignal))
				input.signal = converted[mechanics.triggerSignal]
				mechanics.fireOutgoing(input)
		return

	verb/settvalue2()
		set src in view(1)
		set name = "\[Set Trigger Field\]"
		set desc = "Sets the Trigger Field that causes this component to forward the Value of that Field."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Trigger Field:","Trigger Field setting","1") as text
		if(length(inp))
			inp = strip_html(html_decode(inp))
			mechanics.triggerSignal = inp
			boutput(usr, "Trigger Field set to [inp]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_split"
		return

/obj/item/mechanics/regreplace
	name = "RegEx Replace Component"
	desc = ""
	icon_state = "comp_regrep"
	var/expression = "/original/replacement/g"

	get_desc()
		. += "<br><span style=\"color:blue\">Current Expression: [sanitize(html_encode(expression))]</span>"

	New()
		..()
		mechanics.addInput("replace string", "checkstr")
		return

	proc/checkstr(var/datum/mechanicsMessage/input)
		if(level == 2 || !length(expression)) return
		var/regex/R = new(expression)

		if(!R) return

		var/mod = R.Replace(input.signal)
		mod = strip_html(sanitize(html_encode(mod)))

		if(mod)
			input.signal = mod
			mechanics.fireOutgoing(input)

		return

	verb/setregexr()
		set src in view(1)
		set name = "\[Set Regular Expression\]"
		set desc = "Sets the expression for searching and replacing"
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Expression:","Expression setting", expression) as text
		if(length(inp))
			var/regex/R = new(inp)
			if(R.error)
				boutput(usr, "<span style=\"color:red\">[R.error]</span>")
			else
				inp = sanitize(html_encode(inp))
				expression = inp
				boutput(usr, "Expression set to [inp]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_regrep"
		return

/obj/item/mechanics/regfind
	name = "RegEx Find Component"
	desc = ""
	icon_state = "comp_regfind"
	var/replacesignal = 0
	var/expression = "/\[a-Z\]*/"

	get_desc()
		. += {"<br><span style=\"color:blue\">Current Expression: [sanitize(html_encode(expression))]<br>
		Replace Signal is [replacesignal ? "on.":"off."]</span>"}

	New()
		..()
		mechanics.addInput("check string", "checkstr")
		return

	proc/checkstr(var/datum/mechanicsMessage/input)
		if(level == 2 || !length(expression)) return
		var/regex/R = new(expression)

		if(!R) return

		if(R.Find(input.signal))
			if(replacesignal)
				input.signal = mechanics.outputSignal
			else
				input.signal = copytext(input.signal, R.match, R.index)
			mechanics.fireOutgoing(input)

		return

	verb/setregexf()
		set src in view(1)
		set name = "\[Set Regular Expression\]"
		set desc = "Sets the expression that the component will look for."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Expression:","Expression setting", expression) as text
		if(length(inp))
			var/regex/R = new(inp)
			if(R.error)
				boutput(usr, "<span style=\"color:red\">[R.error]</span>")
			else
				expression = inp
				inp = sanitize(html_encode(inp))
				boutput(usr, "Expression set to [inp]")
		return

	verb/toggleregfrep()
		set src in view(1)
		set name = "\[Toggle Signal replacing\]"
		set desc = "Toggles whether the component will send its own signal or the found string."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		replacesignal = !replacesignal
		boutput(usr, "[replacesignal ? "Now forwarding own Signal":"Now forwarding found String"]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_regfind"
		return

/obj/item/mechanics/sigcheckcomp
	name = "Signal-Check Component"
	desc = ""
	icon_state = "comp_check"
	var/not = 0
	var/changesig = 0

	get_desc()
		. += {"<br><span style=\"color:blue\">[not ? "Component triggers when Signal is NOT found.":"Component triggers when Signal IS found."]<br>
		Replace Signal is [changesig ? "on.":"off."]<br>
		Currently checking for: [sanitize(html_encode(mechanics.triggerSignal))]</span>"}

	New()
		..()
		mechanics.addInput("check string", "checkstr")
		return

	proc/checkstr(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(findtext(input.signal, mechanics.triggerSignal))
			if(!not)
				if(changesig) input.signal = mechanics.outputSignal
				mechanics.fireOutgoing(input)
		else
			if(not)
				if(changesig) input.signal = mechanics.outputSignal
				mechanics.fireOutgoing(input)
		return

	verb/setscsig()
		set src in view(1)
		set name = "\[Set Trigger-String\]"
		set desc = "Sets the string that causes this component to fire."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter String:","String setting","1") as text
		if(length(inp))
			inp = adminscrub(inp)
			mechanics.triggerSignal = inp
			boutput(usr, "String set to [inp]")
		return

	verb/togglenot()
		set src in view(1)
		set name = "\[Invert Trigger\]"
		set desc = "Switches between triggering on a Match or triggering when it can NOT find the string."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		not = !not
		boutput(usr, "[not ? "Component will now trigger when the String is NOT found.":"Component will now trigger when the String IS found."]")
		return

	verb/togglesigchange2()
		set src in view(1)
		set name = "\[Toggle Replace Signal\]"
		set desc = "Toggles whether the Component will change the Signal to its own or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		changesig = !changesig
		boutput(usr, "Signal changing now [changesig ? "on":"off"]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_check"
		return

/obj/item/mechanics/sigbuilder
	name = "Signal Builder Component"
	desc = ""
	icon_state = "comp_builder"
	var/buffer = ""
	var/bstr = ""
	var/astr = ""

	get_desc()
		. += {"<br><span style=\"color:blue\">Current Buffer Contents: [html_encode(sanitize(buffer))]<br>"
		Current starting String: [html_encode(sanitize(bstr))]<br>"
		Current ending String: [html_encode(sanitize(astr))]</span>"}

	New()
		..()
		mechanics.addInput("add to string", "addstr")
		mechanics.addInput("add to string + send", "addstrsend")
		mechanics.addInput("send", "sendstr")
		mechanics.addInput("clear buffer", "clrbff")
		return

	proc/clrbff(var/datum/mechanicsMessage/input)
		if(level == 2) return
		buffer = ""
		return

	proc/sendstr(var/datum/mechanicsMessage/input)
		if(level == 2) return
		var/finished = "[bstr][buffer][astr]"
		finished = strip_html(sanitize(finished))
		input.signal = finished
		mechanics.fireOutgoing(input)
		buffer = ""
		return

	proc/addstr(var/datum/mechanicsMessage/input)
		if(level == 2) return
		buffer = "[buffer][input.signal]"
		return

	proc/addstrsend(var/datum/mechanicsMessage/input)
		if(level == 2) return
		buffer = "[buffer][input.signal]"
		sendstr(input)
		return

	verb/setbdefbuild()
		set src in view(1)
		set name = "\[Set starting String\]"
		set desc = "Sets an optional string that will be put at the beginning of each new String before everything else."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter String:","String setting", bstr) as text
		inp = strip_html(inp)
		bstr = inp
		boutput(usr, "String set to [inp]")
		return

	verb/setadefbuild()
		set src in view(1)
		set name = "\[Set ending String\]"
		set desc = "Sets an optional string that will be put at the end of each String before sending it."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter String:","String setting", astr)
		inp = strip_html(inp)
		astr = inp
		boutput(usr, "String set to [inp]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_builder"
		return

/obj/item/mechanics/relaycomp
	name = "Relay Component"
	desc = ""
	icon_state = "comp_relay"
	var/ready = 1
	var/changesig = 0

	get_desc()
		. += "<br><span style=\"color:blue\">Replace Signal is [changesig ? "on.":"off."]</span>"

	New()
		..()
		mechanics.addInput("relay", "relay")
		return

	proc/relay(var/datum/mechanicsMessage/input)
		if(level == 2 || !ready) return
		ready = 0
		spawn(30) ready = 1
		flick("[under_floor ? "u":""]comp_relay1", src)
		if(changesig)
			input.signal = mechanics.outputSignal
		spawn(0)
			mechanics.fireOutgoing(input)
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_relay"
		return

	verb/togglesigchange()
		set src in view(1)
		set name = "\[Toggle Signal changing\]"
		set desc = "Toggles whether the relay component will change the Signal to its own or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		changesig = !changesig
		boutput(usr, "Signal changing now [changesig ? "on":"off"]")
		return

/obj/item/mechanics/wificomp
	name = "Wifi Component"
	desc = ""
	icon_state = "comp_radiosig"
	var/ready = 1
	var/send_full = 0
	var/only_directed = 1

	var/net_id = null //What is our ID on the network?
	var/last_ping = 0
	var/range = 0

	var/frequency = 1419
	var/datum/radio_frequency/radio_connection

	get_desc()
		. += {"<br><span style=\"color:blue\">[send_full ? "Sending full unprocessed Signals.":"Sending only processed sendmsg and pda Message Signals."]<br>
		[only_directed ? "Only reacting to Messages directed at this Component.":"Reacting to ALL Messages received."]<br>
		Current Frequency: [frequency]<br>
		Current NetID: [net_id]</span>"}

	New()
		..()
		mechanics.addInput("send radio message", "send")
		mechanics.addInput("set frequency", "setfreq")

		if(radio_controller)
			set_frequency(frequency)

		src.net_id = format_net_id("\ref[src]")

		return

	proc/setfreq(var/datum/mechanicsMessage/input)
		var/newfreq = text2num(input.signal)
		if(!newfreq) return
		set_frequency(newfreq)
		return

	proc/send(var/datum/mechanicsMessage/input)
		if(level == 2) return
		var/list/converted = params2list(input.signal)
		if(!converted.len || !ready) return

		ready = 0
		spawn(30) ready = 1

		var/datum/signal/sendsig = get_free_signal()

		sendsig.source = src
		sendsig.data["sender"] = src.net_id
		sendsig.transmission_method = TRANSMISSION_RADIO

		for(var/X in converted)
			sendsig.data["[X]"] = "[converted[X]]"

		spawn(0) src.radio_connection.post_signal(src, sendsig, src.range)

		animate_flash_color_fill(src,"#FF0000",2, 2)
		return

	receive_signal(datum/signal/signal)
		if(!signal || signal.encryption || level == 2)
			return

		if((only_directed && signal.data["address_1"] == src.net_id) || !only_directed || (signal.data["address_1"] == "ping"))

			if(send_full)
				var/datum/mechanicsMessage/msg = mechanics.newSignal(html_decode(list2params_noencode(signal.data)))
				mechanics.fireOutgoing(msg)
				animate_flash_color_fill(src,"#00FF00",2, 2)
				return

			if((signal.data["address_1"] == "ping") && signal.data["sender"])
				var/datum/signal/pingsignal = get_free_signal()
				pingsignal.source = src
				pingsignal.data["device"] = "COMP_WIFI"
				pingsignal.data["netid"] = src.net_id
				pingsignal.data["address_1"] = signal.data["sender"]
				pingsignal.data["command"] = "ping_reply"
				pingsignal.data["data"] = "Wifi Component"
				pingsignal.transmission_method = TRANSMISSION_RADIO

				spawn(5) //Send a reply for those curious jerks
					src.radio_connection.post_signal(src, pingsignal, src.range)

			else if(signal.data["command"] == "sendmsg" && signal.data["data"])
				var/datum/mechanicsMessage/msg = mechanics.newSignal(html_decode(signal.data["data"]))
				mechanics.fireOutgoing(msg)
				animate_flash_color_fill(src,"#00FF00",2, 2)

			else if(signal.data["command"] == "text_message" && signal.data["message"])
				var/datum/mechanicsMessage/msg = mechanics.newSignal(html_decode(signal.data["message"]))
				mechanics.fireOutgoing(msg)
				animate_flash_color_fill(src,"#00FF00",2, 2)

			else if(signal.data["command"] == "setfreq" && signal.data["data"])
				var/newfreq = text2num(signal.data["data"])
				if(!newfreq) return
				set_frequency(newfreq)
				animate_flash_color_fill(src,"#00FF00",2, 2)

		return

	proc/set_frequency(new_frequency)
		if(!radio_controller) return
		new_frequency = max(1000, min(new_frequency, 1500))
		radio_controller.remove_object(src, "[frequency]")
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, "[frequency]")

	verb/setfreqv()
		set src in view(1)
		set name = "\[Set Frequency\]"
		set desc = "Sets the frequency."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Frequency:","Frequency setting", frequency) as num
		if(inp)
			set_frequency(inp)
			boutput(usr, "Frequency set to [inp]")
		return


	verb/toggleidf()
		set src in view(1)
		set name = "\[Toggle NetID filtering\]"
		set desc = "Toggles whether the Component will only react to Radio Messages directed at it or to *all* Messages on the Frequency."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		only_directed = !only_directed
		boutput(usr, "[only_directed ? "Now only reacting to Messages directed at this Component":"Now reacting to ALL Messages."]")
		return

	verb/togglefall()
		set src in view(1)
		set name = "\[Toggle Forward All\]"
		set desc = "Toggles whether the Component will forward ALL radio Messages without processing them or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		send_full = !send_full
		boutput(usr, "[send_full ? "Now forwarding all Radio Messages as they are.":"Now processing only sendmsg and normal PDA messages."]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_radiosig"
		return


/obj/item/mechanics/selectcomp
	name = "Selection Component"
	desc = ""
	icon_state = "comp_selector"
	var/list/signals = new/list()
	var/current_index = 1
	var/announce = 0
	var/random = 0

	get_desc()
		. += {"<br><span style=\"color:blue\">[random ? "Sending random Signals.":"Sending selected Signals."]<br>
		[announce ? "Announcing Changes.":"Not announcing Changes."]<br>
		Current Selection: [(!current_index || current_index > signals.len ||!signals.len) ? "Empty":"[current_index] -> [signals[current_index]]"]<br>
		Currently contains [signals.len] Items:<br></span>"}
		for (var/x in signals)
			. += "- [x]<br>[(signals[signals.len] == x) ? "</span>" : null]"

	New()
		..()
		mechanics.addInput("add item", "additem")
		mechanics.addInput("remove item", "remitem")
		mechanics.addInput("remove all items", "remallitem")
		mechanics.addInput("select item", "selitem")
		mechanics.addInput("next", "next")
		mechanics.addInput("previous", "previous")
		mechanics.addInput("next + send", "nextplus")
		mechanics.addInput("previous + send", "previousplus")
		mechanics.addInput("send selected", "sendCurrent")
		mechanics.addInput("send random", "sendRand")
		verbs -= /obj/item/mechanics/verb/setvalue
		return

	proc/selitem(var/datum/mechanicsMessage/input)
		if(!input) return

		if(signals.Find(input.signal))
			current_index = signals.Find(input.signal)

		if(announce)
			componentSay("Current Selection : [signals[current_index]]")
		return

	proc/remitem(var/datum/mechanicsMessage/input)
		if(!input) return

		if(signals.Find(input.signal))
			signals.Remove(input.signal)
			if(announce)
				componentSay("Removed : [input.signal]")

		return

	proc/remallitem(var/datum/mechanicsMessage/input)
		if(!input) return

		for(var/s in signals)
			signals.Remove(s)

		if(announce)
			componentSay("Removed all signals.")

		return

	proc/additem(var/datum/mechanicsMessage/input)
		if(!input) return

		signals.Add(input.signal)
		if(announce)
			componentSay("Added : [input.signal]")

		return

	proc/sendRand(var/datum/mechanicsMessage/input)
		if(!input) return
		//I feel bad for doing this.
		var/orig = random
		random = 1
		sendCurrent(input)
		random = orig
		return

	proc/sendCurrent(var/datum/mechanicsMessage/input)
		if(!input) return
		if(!current_index || current_index > signals.len ||!signals.len) return

		if(random) input.signal = pick(signals)
		else input.signal = signals[current_index]

		spawn(0)
			mechanics.fireOutgoing(input)
		return

	proc/next(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(!signals.len) return
		if((current_index + 1) > signals.len)
			current_index = 1
		else
			current_index++

		if(announce)
			componentSay("Current Selection : [signals[current_index]]")
		return

	proc/nextplus(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(!signals.len) return
		if((current_index + 1) > signals.len)
			current_index = 1
		else
			current_index++

		if(announce)
			componentSay("Current Selection : [signals[current_index]]")

		sendCurrent(input)
		return

	proc/previous(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(!signals.len) return
		if((current_index - 1) < 1)
			current_index = signals.len
		else
			current_index--

		if(announce)
			componentSay("Current Selection : [signals[current_index]]")
		return

	proc/previousplus(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(!signals.len) return
		if((current_index - 1) < 1)
			current_index = signals.len
		else
			current_index--

		if(announce)
			componentSay("Current Selection : [signals[current_index]]")

		sendCurrent(input)
		return

	verb/setsignals()
		set src in view(1)
		set name = "\[Set Signal List\]"
		set desc = "Defines the List of Signals to be used by this Component."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/numsig = input(usr,"How many Signals would you like to define?","# Signals:", 3) as num
		numsig = round(numsig)
		if(numsig > 10) //Needs a limit because nerds are nerds
			boutput(usr, "<span style=\"color:red\">This component can't handle more than 10 signals!</span>")
			return
		if(numsig)
			signals.Cut()
			boutput(usr, "Defining [numsig] Signals ...")
			for(var/i=0, i<numsig, i++)
				var/signew = input(usr,"Content of Signal #[i]","Content:", "signal[i]") as text
				signew = adminscrub(signew) //SANITIZE THAT SHIT! FUCK!!!!
				if(length(signew))
					signals.Add(signew)
				else
					signals.Cut()
					return
			boutput(usr, "Set [numsig] Signals!")
			for(var/a in signals)
				boutput(usr, a)
		return

	verb/toggleannouncement()
		set src in view(1)
		set name = "\[Toggle Announcements\]"
		set desc = "Toggles wether the Component will say its selected item out loud or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		announce = !announce
		boutput(usr, "Announcements now [announce ? "on":"off"]")
		return

	verb/togglerndsel()
		set src in view(1)
		set name = "\[Toggle random\]"
		set desc = "Toggles whether the Component will pick an Item at random or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		random = !random
		boutput(usr, "[random ? "Now picking Items at random.":"Now using selected Items."]")
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_selector"
		return

/obj/item/mechanics/togglecomp
	name = "Toggle Component"
	desc = ""
	icon_state = "comp_toggle"
	var/on = 0
	var/signal_on = "1"
	var/signal_off = "0"

	get_desc()
		. += {"<br><span style=\"color:blue\">Currently [on ? "ON":"OFF"].<br>
		Current ON Signal: [signal_on]<br>
		Current OFF Signal: [signal_off]</span>"}

	New()
		..()
		mechanics.addInput("activate", "activate")
		mechanics.addInput("deactivate", "deactivate")
		mechanics.addInput("toggle", "toggle")
		mechanics.addInput("output state", "state")
		verbs -= /obj/item/mechanics/verb/setvalue
		return

	proc/activate(var/datum/mechanicsMessage/input)
		if(level == 2) return
		on = 1
		input.signal = signal_on
		updateIcon()
		spawn(0)
			mechanics.fireOutgoing(input)
		return

	proc/deactivate(var/datum/mechanicsMessage/input)
		if(level == 2) return
		on = 0
		input.signal = signal_off
		updateIcon()
		spawn(0)
			mechanics.fireOutgoing(input)
		return

	proc/toggle(var/datum/mechanicsMessage/input)
		if(level == 2) return
		on = !on
		input.signal = (on ? signal_on : signal_off)
		updateIcon()
		spawn(0)
			mechanics.fireOutgoing(input)
		return

	proc/state(var/datum/mechanicsMessage/input)
		if(level == 2) return
		input.signal = (on ? signal_on : signal_off)
		spawn(0)
			mechanics.fireOutgoing(input)
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_toggle[on ? "1":""]"
		return

	verb/setsignalon()
		set src in view(1)
		set name = "\[Set On-Signal\]"
		set desc = "Sets the Signal that is sent when the Component is on."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Signal:","Signal setting",signal_on) as text
		if(length(inp))
			inp = adminscrub(inp)
			signal_on = inp
			boutput(usr, "On-Signal set to [inp]")
		return

	verb/setsignaloff()
		set src in view(1)
		set name = "\[Set Off-Signal\]"
		set desc = "Sets the Signal that is sent when the Component is off."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Signal:","Signal setting",signal_off) as text
		if(length(inp))
			inp = adminscrub(inp)
			signal_off = inp
			boutput(usr, "Off-Signal set to [inp]")
		return

/obj/item/mechanics/telecomp
	name = "Teleport Component"
	desc = ""
	icon_state = "comp_tele"
	var/ready = 1
	var/teleID = "tele1"
	var/send_only = 0

	get_desc()
		. += {"<br><span style=\"color:blue\">Current ID: [teleID].<br>
		Send only Mode: [send_only ? "On":"Off"].</span>"}

	New()
		..()
		mechanics_telepads.Add(src)
		mechanics.addInput("activate", "activate")
		mechanics.addInput("setID", "setidmsg")
		return

	proc/setidmsg(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input.signal)
			teleID = input.signal
 		componentSay("ID Changed to : [input.signal]")
		return

	proc/activate(var/datum/mechanicsMessage/input)
		if(level == 2 || !ready) return
		ready = 0
		spawn(30) ready = 1
		flick("[under_floor ? "u":""]comp_tele1", src)
		particleMaster.SpawnSystem(new /datum/particleSystem/tpbeam(get_turf(src.loc)))
		playsound(src.loc, "sound/mksounds/boost.ogg", 50, 1)
		var/list/destinations = new/list()

		for(var/obj/item/mechanics/telecomp/T in mechanics_telepads)
			if(T == src || T.level == 2 || !isturf(T.loc) || T.z != src.z  || isrestrictedz(T.z)|| T.send_only) continue
			if(T.teleID == src.teleID)
				destinations.Add(T)

		if(destinations.len)
			var/atom/picked = pick(destinations)
			particleMaster.SpawnSystem(new /datum/particleSystem/tpbeam(get_turf(picked.loc)))
			for(var/atom/movable/M in src.loc)
				if(M == src || M.invisibility || M.anchored) continue
				M.set_loc(get_turf(picked.loc))

		spawn(0)
			mechanics.fireOutgoing(input)
		return

	Del()
		mechanics_telepads.Remove(src)
		return ..()

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_tele"
		return

	verb/setid()
		set src in view(1)
		set name = "\[Set Teleporter ID\]"
		set desc = "Sets the ID of the Telepad."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter ID:","ID setting",teleID) as text
		if(length(inp))
			inp = adminscrub(inp)
			teleID = inp
			boutput(usr, "ID set to [inp]")

		return

	verb/togglesendonly()
		set src in view(1)
		set name = "\[Toggle Send-only Mode\]"
		set desc = "Toggles Send-only Mode."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		send_only = !send_only

		if(send_only)
			src.overlays += image('icons/misc/mechanicsExpansion.dmi', icon_state = "comp_teleoverlay")
		else
			src.overlays.Cut()

		boutput(usr, "Send-only Mode now [send_only ? "on":"off"]")
		return

/obj/item/mechanics/ledcomp
	name = "LED Component"
	desc = ""
	icon_state = "comp_led"
	var/light_level = 2
	var/active = 0
	var/selcolor = "#FFFFFF"
	var/datum/light/light
	color = "#AAAAAA"

	get_desc()
		. += "<br><span style=\"color:blue\">Current Color: [selcolor].</span>"

	New()
		..()
		mechanics.addInput("toggle", "toggle")
		mechanics.addInput("activate", "turnon")
		mechanics.addInput("deactivate", "turnoff")
		mechanics.addInput("set rgb", "setrgb")
		verbs -= /obj/item/mechanics/verb/setvalue
		light = new /datum/light/point
		light.attach(src)
		return

	pickup()
		active = 0
		light.disable()
		src.color = "#AAAAAA"
		return ..()

	proc/setrgb(var/datum/mechanicsMessage/input)

		if(length(input.signal) == 7 && copytext(input.signal, 1, 2) == "#")
			if(active)
				color = input.signal
			selcolor = input.signal
			spawn(0) light.set_color(GetRedPart(selcolor) / 255, GetGreenPart(selcolor) / 255, GetBluePart(selcolor) / 255)

	proc/turnon(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if (usr && usr.stat)
			return
		active = 1
		light.enable()
		src.color = selcolor
		return

	proc/turnoff(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if (usr && usr.stat)
			return
		active = 0
		light.disable()
		src.color = "#AAAAAA"
		return

	proc/toggle(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if (usr && usr.stat)
			return
		if(active)
			turnoff(input)
		else
			turnon(input)
		return

	verb/setcolor()
		set src in view(1)
		set name = "\[Set Color\]"
		set desc = "Sets the color of the light."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/red = input(usr,"Red Color (0.0 - 1.0):","Color setting", 1.0) as num
		red = max(red, 0.0)
		red = min(red, 1.0)

		var/green = input(usr,"Green Color (0.0 - 1.0):","Color setting", 1.0) as num
		green = max(green, 0.0)
		green = min(green, 1.0)

		var/blue = input(usr,"Blue Color (0.0 - 1.0):","Color setting", 1.0) as num
		blue = max(blue, 0.0)
		blue = min(blue, 1.0)

		selcolor = rgb(red * 255, green * 255, blue * 255)

		light.set_color(red, green, blue)

		return

	verb/setrange()
		set src in view(1)
		set name = "\[Set Range\]"
		set desc = "Sets the range of the light."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		var/inp = input(usr,"Please enter Range (1 - 7):","Range setting", light_level) as num
		if (get_dist(usr, src) > 1 || usr.stat)
			return

		inp = round(inp)
		inp = max(inp, 1)
		inp = min(inp, 7)

		boutput(usr, "Range set to [inp]")

		light.set_brightness(inp / 7)

		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_led"
		return

/obj/item/mechanics/miccomp
	name = "Microphone Component"
	desc = ""
	icon_state = "comp_mic"
	var/add_sender = 0

	New()
		..()
		return

	hear_talk(mob/M as mob, msg, real_name, lang_id)
		if(level == 2) return
		var/message = msg[2]
		if(lang_id in list("english", ""))
			message = msg[1]
		message = strip_html( html_decode(message) )
		var/heardname = M.name
		if (real_name)
			heardname = real_name
		var/datum/mechanicsMessage/sigmsg = mechanics.newSignal((add_sender ? "[heardname] : [message]":"[message]"))
		mechanics.fireOutgoing(sigmsg)
		animate_flash_color_fill(src,"#00FF00",2, 2)
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_mic"
		return

	verb/togglesender()
		set src in view(1)
		set name = "\[Toggle Show-Source\]"
		set desc = "Toggles whether the component adds the source of the message to the Signal or not."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		add_sender = !add_sender

		boutput(usr, "Show-Source now [add_sender ? "on":"off"]")
		return

/obj/item/mechanics/synthcomp
	name = "Sound Synthesizer"
	desc = ""
	icon_state = "comp_synth"
	var/ready = 1

	New()
		..()
		mechanics.addInput("input", "fire")
		return

	proc/fire(var/datum/mechanicsMessage/input)
		if(level == 2 || !ready) return
		ready = 0
		spawn(20) ready = 1
		if(input)
			componentSay("[input.signal]")
		return

	updateIcon()
		icon_state = "comp_synth"
		return

/obj/item/mechanics/trigger/pressureSensor
	name = "Pressure Sensor"
	desc = ""
	icon_state = "comp_pressure"
	var/tmp/limiter = 0

	Crossed(atom/movable/AM as mob|obj)
		if (level == 2)
			return
		if (istype(AM, /mob/dead))
			return
		if (limiter && (ticker.round_elapsed_ticks < limiter))
			return

		limiter = ticker.round_elapsed_ticks + 10
		mechanics.fireOutgoing(mechanics.newSignal(mechanics.outputSignal))
		return

	updateIcon()
		icon_state = "[under_floor ? "u":""]comp_pressure"
		return

/obj/item/mechanics/trigger/button
	name = "Button"
	desc = ""
	icon_state = "comp_button"
	density = 1

	get_desc()
		. += "<br><span style=\"color:blue\">Current Signal: [html_encode(sanitize(mechanics.outputSignal))].</span>"

	attack_hand(mob/user as mob)
		if(level == 1)
			flick("comp_button1", src)
			mechanics.fireOutgoing(mechanics.newSignal(mechanics.outputSignal))
		else
			..(user)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(..(W, user)) return
		attack_hand(user)
		return

	updateIcon()
		icon_state = "comp_button"
		return

// Updated these things for pixel bullets. Also improved user feedback and added log entries here and there (Convair880).
/obj/item/mechanics/gunholder
	name = "Gun Component"
	desc = ""
	icon_state = "comp_gun"
	density = 0
	var/obj/item/gun/Gun = null
	var/compatible_guns = /obj/item/gun/kinetic

	get_desc()
		. += "<br><span style=\"color:blue\">Current Gun: [Gun ? "[Gun] [Gun.canshoot() ? "(ready to fire)" : "(out of [istype(Gun, /obj/item/gun/energy) ? "charge)" : "ammo)"]"]" : "None"]</span>"

	New()
		..()
		mechanics.addInput("fire", "fire")
		return

	proc/getTarget()
		var/atom/trg = get_turf(src)
		for(var/mob/living/L in trg)
			return get_turf_loc(L)
		for(var/i=0, i<7, i++)
			trg = get_step(trg, src.dir)
			for(var/mob/living/L in trg)
				return get_turf_loc(L)
		return get_edge_target_turf(src, src.dir)

	proc/fire(var/datum/mechanicsMessage/input)
		if(level == 2) return
		if(input && Gun)
			if(Gun.canshoot())
				var/atom/target = getTarget()
				if(target)
					//DEBUG("Target: [log_loc(target)]. Src: [src]")
					Gun.shoot(target, get_turf(src), src)
			else
				src.visible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"The [Gun.name] has no [istype(Gun, /obj/item/gun/energy) ? "charge" : "ammo"] remaining.\"</span>")
				playsound(src.loc, "sound/machines/buzz-two.ogg", 50, 0)
		else
			src.visible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"No gun installed.\"</span>")
			playsound(src.loc, "sound/machines/buzz-two.ogg", 50, 0)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(..(W, user)) return
		else if (istype(W, src.compatible_guns))
			if(!Gun)
				boutput(usr, "You put the [W] inside the [src].")
				logTheThing("station", usr, null, "adds [W] to [src] at [log_loc(src)].")
				usr.drop_item()
				Gun = W
				Gun.loc = src
			else
				boutput(usr, "There is already a [Gun] inside the [src]")
		else
			user.show_text("The [W.name] isn't compatible with this component.", "red")
		return

	updateIcon()
		icon_state = "comp_gun"
		return

	verb/removegun()
		set src in view(1)
		set name = "\[Remove Gun\]"
		set desc = "Removes the gun."
		set category = "Local"

		if (!istype(usr, /mob/living))
			return
		if (usr.stat)
			return
		if (!mechanics.allowChange(usr))
			boutput(usr, "<span style=\"color:red\">[MECHFAILSTRING]</span>")
			return

		if(Gun)
			logTheThing("station", usr, null, "removes [Gun] from [src] at [log_loc(src)].")
			Gun.loc = get_turf(src)
			Gun = null
		else
			boutput(usr, "<span style=\"color:red\">There is no gun inside this component.</span>")
		return

	verb/setdir()
		set src in view(1)
		set name = "\[Rotate\]"
		set desc = "Rotates the object"
		set category = "Local"
		if (usr.stat)
			return
		src.dir = turn(src.dir, 90)
		return

/obj/item/mechanics/gunholder/recharging
	name = "E-Gun Component"
	desc = ""
	icon_state = "comp_gun2"
	density = 0
	compatible_guns = /obj/item/gun/energy
	var/charging = 0
	var/ready = 1

	get_desc()
		. = ..() // Please don't remove this again, thanks.
		. += charging ? "<br><span style=\"color:blue\">Component is charging.</span>" : null

	New()
		..()
		mechanics.addInput("recharge", "recharge")
		return

	process()
		..()
		if(level == 2)
			if(charging) charging = 0
			return

		if(!Gun && charging)
			charging = 0
			updateIcon()

		if(!istype(Gun, /obj/item/gun/energy) || !charging)
			return

		var/obj/item/gun/energy/E = Gun

		// Can't recharge the crossbow. Same as the other recharger.
		if (!E.rechargeable)
			src.visible_message("<span class='game say'><span class='name'>[src]</span> beeps, \"This gun cannot be recharged manually.\"</span>")
			playsound(src.loc, "sound/machines/buzz-two.ogg", 50, 0)
			charging = 0
			updateIcon()
			return

		if (E.cell)
			if (E.cell.charge(15) != 1) // Same as other recharger.
				src.charging = 0
				src.updateIcon()

		E.update_icon()
		return

	proc/recharge(var/datum/mechanicsMessage/input)
		if(charging || !Gun || level == 2) return
		if(!istype(Gun, /obj/item/gun/energy)) return
		charging = 1
		updateIcon()
		return ..()

	fire(var/datum/mechanicsMessage/input)
		if(charging || !ready) return
		ready = 0
		spawn(30) ready = 1
		return ..()

	updateIcon()
		icon_state = charging ? "comp_gun2x" : "comp_gun2"
		return

/obj/mecharrow
	name = ""
	icon = 'icons/misc/mechanicsExpansion.dmi'
	icon_state = "connectionArrow"