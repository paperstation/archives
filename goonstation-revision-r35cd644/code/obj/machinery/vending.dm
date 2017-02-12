/datum/data/vending_product
	var/product_name = "generic"
	var/atom/product_path = null

	var/product_cost
	var/product_amount
	var/product_hidden
	var/product_display_color

	var/static/list/product_name_cache = list()

	New(productpath, amount=0, cost=0, hidden=0)
		src.product_path = text2path(productpath)

		var/name_check = product_name_cache[productpath]
		if (name_check)
			src.product_name = name_check
		else
			//var/obj/temp = new src.product_path(src)
			var/p_name = initial(product_path.name)
			src.product_name = capitalize(p_name)
			product_name_cache[productpath] = src.product_name
			//qdel(temp)

		product_display_color = pick("red", "blue", "green")

		src.product_amount = amount
		src.product_cost = cost
		src.product_hidden = hidden

/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	anchored = 1
	density = 1
	mats = 20
	var/obj/item/card/id/scan = null

	var/image/panel_image = null

	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 5 //How long does it take to vend?

	//Keep track of lists
	var/list/slogan_list = list()//new() //List of strings
	var/list/product_list = new() //List of datum/data/vending_product
	var/glitchy_slogans = 0 // do they come out aLL FunKY lIKe THIs?

	//Replies when buying
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0

	//Slogans
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 600 //How long until we can pitch again?
	var/slogan_chance = 5

	//Icons
	var/icon_panel = "generic-panel"
	var/icon_vend //Icon for vending
	var/icon_deny //Icon when denying vend (wrong access)

	var/emagged = 0 //Ignores if somebody doesn't have card access to that machine.

	//Malfunctioning machine
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/shoot_inventory_chance = 5

	var/extended_inventory = 0 //can we access the hidden inventory?
	var/can_fall = 1 //Can this machine be knocked over?

	var/panel_open = 0 //Hacking that vending machine. Gonna get a free candy bar.
	var/wires = 15

	// Paid vendor variables
	var/pay = 0 // Does this vending machine require money?
	var/acceptcard = 1 // does the machine accept ID swiping?
	var/credit = 0 //How much money is currently in the machine?
	var/profit = 0.50 // cogwerks: how much of a cut should the QMs get from the sale, expressed as a percent

	var/HTML = null // guh
	var/vending_HTML = null // buh
	var/wire_HTML = null // duh
	var/list/vendwires = list() // fuh
	var/datum/data/vending_product/paying_for = null // zuh

	var/datum/light/light

	power_usage = 50

	New()
		src.create_products()
		mechanics = new(src)
		mechanics.master = src
		mechanics.addInput("vend", "vendinput")
		light = new /datum/light/point
		light.attach(src)
		light.set_brightness(0.6)
		light.set_height(1.5)
		..()
		src.panel_image = image(src.icon, src.icon_panel)

	proc/vendinput(var/datum/mechanicsMessage/inp)
		throw_item()
		return

	// just making this proc so we don't have to override New() for every vending machine, which seems to lead to bad things
	// because someone, somewhere, always forgets to use a ..()
	proc/create_products()
		return

/obj/machinery/vending/coffee
	name = "coffee machine"
	desc = "A Robust Coffee vending machine."
	pay = 1
	vend_delay = 15
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	icon_panel = "coffee-panel"

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/coffee", 25, cost=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/tea", 10, cost=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/xmas", 10, cost=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/chickensoup", 10, cost=3)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/weightloss_shake", 10, cost=5)

		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/cola", rand(1, 6), hidden=1)

/obj/machinery/vending/snack
	name = "snack machine"
	desc = "Tasty treats for crewman eats."
	pay = 1
	icon_state = "snack"
	icon_panel = "snack-panel"
	slogan_list = list("Try our new nougat bar!",
	"Twice the calories for half the price!",
	"Fill the gap in your stomach right now!",
	"A fresh delight is only a bite away!",
	"We feature Discount Dan's Noodle Soups!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/candy", 20, cost=2)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/chips", 20, cost=2)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/donut", 20, cost=3)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/fries", 20, cost=3)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/noodlecup", 20, cost=2)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/burrito", 20, cost=3)
        // Go away, every flavor beans...
		//product_list += new/datum/data/vending_product("/obj/item/kitchen/everyflavor_box", 20, cost=15)

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style"
	pay = 1
	vend_delay = 10
	icon_state = "cigs"
	icon_panel = "cigs-panel"
	slogan_list = list("Space cigs taste good like a cigarette should!",
	"I'd rather toolbox than switch.",
	"Smoke!",
	"Don't believe the reports - smoke today!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/cigpacket", 20, cost=10)
		product_list += new/datum/data/vending_product("/obj/item/cigpacket/nicofree", 20, cost=15)
		product_list += new/datum/data/vending_product("/obj/item/cigpacket/propuffs", 20, cost=20)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/nicotine", 20, cost=15)
		product_list += new/datum/data/vending_product("/obj/item/matchbook", 15, cost=5)
		product_list += new/datum/data/vending_product("/obj/item/zippo", 5, cost=35)

		product_list += new/datum/data/vending_product("/obj/item/device/igniter", rand(1, 6), hidden=1)
		//product_list += new/datum/data/vending_product("/obj/item/cigpacket/random", rand(0, 1), hidden=1, cost=45) // A mass-produceable source of every reagent in the game is just a bad idea (compare with snack machine & beans).

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_panel = "med-panel"
	icon_deny = "med-deny"
	req_access_txt = "5"
	mats = 10
	acceptcard = 0

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/syringe", 12)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/bruise", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/burn", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/antitoxin", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/epinephrine", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/morphine", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/antihistamine", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/aspirin", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/antirad", 3)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/saline", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/atropine", 3)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/eyedrops", 2)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/syringe/antiviral", 6)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/syringe/insulin", 6)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/syringe/calomel", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/pill/salbutamol", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/pill/mannitol", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/pill/mutadone", 5)
		product_list += new/datum/data/vending_product("/obj/item/bandage", 4)
		product_list += new/datum/data/vending_product("/obj/item/device/healthanalyzer", 4)
		product_list += new/datum/data/vending_product("/obj/item/device/healthanalyzer_upgrade", 4)

		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/sulfonal", rand(1, 2), hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/pancuronium", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/LSD", rand(1, 6), hidden=1)

/obj/machinery/vending/medical_public
	name = "Public MiniMed"
	desc = "Medical supplies for everyone! Almost nearly as good as what the professionals use, kinda!"
	pay = 1
	vend_delay = 10
	icon_state = "pubmed"
	icon_panel = "pubmed-panel"
	slogan_list = list("It pays to be safe!",
	"It's safest to pay!",
	"We've gone green! Now using 100% recycled materials!",
	"Address all complaints about Public MiniMed services to FILE NOT FOUND for a swift response.",
	"Now 80% sterilized!",
	"There is a 1000 credit fine for bleeding on this machine.",
	"Are you or a loved one currently dying? Consider Discount Dan's burial solutions!",
	"ERROR: Item \"Stimpack\" not found!",
	"Please, be considerate! Do not block access to the machine with your bloodied carcass.",
	"Please contact your insurance provider for details on reduced payment options for this machine!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/mini/bruise", 5, cost=50)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/mini/burn", 5, cost=50)
		product_list += new/datum/data/vending_product("/obj/item/device/healthanalyzer", 2, cost=80)
		product_list += new/datum/data/vending_product("/obj/item/bandage", 5, cost=45)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/emergency_injector/charcoal", 5, cost=75)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/pill/epinephrine", 5, cost=130)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/emergency_injector/spaceacillin", 2, cost=110)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/emergency_injector/antihistamine", 2, cost=70)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/pill/salicylic_acid", 10, cost=65)

		product_list += new/datum/data/vending_product("/obj/item/device/healthanalyzer_upgrade", rand(0, 2), hidden=1, cost=25)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/patch/mini/synthflesh", rand(0, 5), hidden=1, cost=95)
		if (prob(5))
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/pill/bathsalts", 1, hidden=1, cost=140)

		if (prob(15))
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/coffee", rand(1,5), hidden=1, cost=2)
		else
			slogan_list += "ERROR: OUT OF COFFEE!"

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor"
	icon_state = "sec"
	icon_panel = "sec-panel"
	icon_deny = "sec-deny"
	req_access_txt = "1"
	acceptcard = 0

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/handcuffs", 8)
		product_list += new/datum/data/vending_product("/obj/item/chem_grenade/flashbang", 5)
		product_list += new/datum/data/vending_product("/obj/item/device/flash", 4)
		product_list += new/datum/data/vending_product("/obj/item/clothing/head/helmet", 4)
		product_list += new/datum/data/vending_product("/obj/item/device/pda2/security", 2)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/a38/stun", 2)
		if (map_setting == "DESTINY")
			product_list += new/datum/data/vending_product("/obj/item/paper/book/space_law", 1)

		product_list += new/datum/data/vending_product("/obj/item/device/flash/turbo", rand(1, 6), hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/a38", rand(1, 2), hidden=1) // Obtaining a backpack full of lethal ammo required no effort whatsoever, hence why nobody ordered AP speedloaders from the Syndicate (Convair880).

/obj/machinery/vending/security_ammo
	name = "AmmoTech"
	desc = "A restricted ammunition vendor"
	icon_state = "sec"
	icon_panel = "sec-panel"
	icon_deny = "sec-deny"
	req_access_txt = "37"
	acceptcard = 0
	is_syndicate = 1 // okay enough piles of spacker ammo for any mechanic

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/abg", 6)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/a38", 2)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/a38/stun", 3)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/flare", 3)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/smoke", 3)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/tranq_darts", 3)
		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/tranq_darts/anti_mutant", 3)

		product_list += new/datum/data/vending_product("/obj/item/ammo/bullets/a12", 1, hidden=1) // this may be a bad idea, but it's only one box

/obj/machinery/vending/cola
	name = "soda machine"
	pay = 1

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/cola", rand(1, 6), hidden = 1)

	red
		icon_state = "robust"
		icon_panel = "robust-panel"
		slogan_list = list("Drink Robust-Eez, the classic robustness tonic!",
		"A Dr. Pubber a day keeps the boredom away!",
		"Cool, refreshing Lime-Aid - it's good for you!",
		"Grones Soda! Where has your bottle been today?",
		"Decirprevo. The sophisticate's bottled water.")

		create_products()
			..()
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/red", 20, cost=2)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/pink", 20, cost=2)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/lime", 20, cost=5)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/grones", 20, cost=5)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/bottledwater", 20, cost=10)

	blue
		icon_state = "grife"
		icon_panel = "grife-panel"
		slogan_list = list("Grife-O - the soda of a space generation!",
		"The taste of nature!",
		"Spooky Dan's - it's altogether ooky!",
		"Everyone can see Orange-Aid is best!",
		"Decirprevo. The sophisticate's bottled water.")

		create_products()
			..()
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/blue", 20, cost=2)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/orange", 20, cost=5)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/spooky", 20, cost=2)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/spooky2",20, cost=2)
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/bottledwater", 20, cost=10)

/obj/machinery/vending/electronics
	name = "ElecTek Vendomaticotron"
	desc = "Dispenses electronics equipment."
	icon_state = "generic"
	icon_panel = "generic-panel"
	acceptcard = 0
	slogan_list = list("Stop fussing about in boxes, use ElecTek!",
	"Now with boards 100% of the time!",
	"No carbs!",
	"Now with 50% extra inventory!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/electronics/battery", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/board", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/fuse", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/switc", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/keypad", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/screen", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/capacitor", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/buzzer", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/resistor", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/bulb", 30)
		product_list += new/datum/data/vending_product("/obj/item/electronics/relay", 30)

/obj/machinery/vending/mechanics
	name = "MechComp Dispenser"
	desc = "Dispenses electronics equipment."
	icon_state = "generic"
	icon_panel = "generic-panel"
	acceptcard = 0
	pay = 0

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/paper/book/mechanicbook", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/accelerator", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/pausecomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/andcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/orcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/relaycomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/synthcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/trigger/pressureSensor", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/trigger/button", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/gunholder", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/gunholder/recharging", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/ledcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/telecomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/togglecomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/selectcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/sigcheckcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/wificomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/sigbuilder", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/regfind", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/regreplace", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/wifisplit", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/mc14500", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/miccomp", 30)
		product_list += new/datum/data/vending_product("/obj/disposalconstruct/mechanics", 10)
		product_list += new/datum/data/vending_product("/obj/disposalconstruct/mechanics_sensor", 10)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/thprint", 10)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/pscan", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/hscan", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/cashmoney", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/flushcomp", 30)
		product_list += new/datum/data/vending_product("/obj/item/mechanics/networkcomp", 30)

/obj/machinery/vending/computer3
	name = "CompTech"
	desc = "A computer equipment vendor."
	icon_state = "comp"
	icon_panel = "standard-panel"
	acceptcard = 0

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/motherboard", 8)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/fixed_disk", 8)
		//product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/computer3boot", 4)
		product_list += new/datum/data/vending_product("/obj/item/peripheral/card_scanner", 8)
		product_list += new/datum/data/vending_product("/obj/item/peripheral/network/powernet_card", 4)

		product_list += new/datum/data/vending_product("/obj/item/peripheral/drive", rand(1, 6), hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/peripheral/drive/cart_reader", rand(1, 6), hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/peripheral/prize_vendor", rand(1, 6), hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/peripheral/network/radio", rand(1, 6), hidden=1)

//cogwerks- adding a floppy disk vendor
/obj/machinery/vending/floppy
	name = "SoftTech"
	desc = "A computer software vendor."
	icon_state = "software"
	icon_panel = "standard-panel"
	pay = 1
	acceptcard = 1
	slogan_list = list("Remember to read the EULA!",
	"Don't copy that floppy!",
	"Welcome to the information age!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/computer3boot", 6, cost=60)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/read_only/terminal_os", 6, cost=40)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/read_only/network_progs", 4, cost=100)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/read_only/medical_progs", 2, cost=35)

		product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/read_only/security_progs", 2, cost=100, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/floppy/read_only/communications", 2, cost=200, hidden=1)

/obj/machinery/vending/pda //cogwerks: vendor to clean up the pile of PDA carts a bit
	name = "CartyParty"
	desc = "A PDA cartridge vendor."
	icon_state = "pda"
	icon_panel = "standard-panel"
	pay = 1
	acceptcard = 1
	slogan_list = list("Convenient and feature-packed!",
	"For the busy jet-setting businessperson on the go!",
	"-CHECKSUM FAILURE | STACK OVERFLOW - CONSULT YOUR TECHN-WONK")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/device/pda2", 10, cost=100)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/atmos", 2, cost=40)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/medical", 2, cost=40)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/toxins", 2, cost=50)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/botanist", 2, cost=40)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/diagnostics", 2, cost=70)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/game_codebreaker", 4, cost=25)
		product_list += new/datum/data/vending_product("/obj/item/device/pda_module/flashlight/high_power", 2, cost=100)

		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/security", 1, cost=80, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/head", 1, cost=100, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/disk/data/cartridge/clown", 1, cost=200, hidden=1)

/obj/machinery/vending/book //cogwerks: eventually this oughta have some of the wiki job guides available in it
	name = "Books4u"
	desc = "A printed text vendor."
	icon_state = "books"
	icon_panel = "standard-panel"
	pay = 1
	acceptcard = 1
	slogan_list = list("Read a book today!",
	"Educate thyself!",
	"Book Club meeting in the Chapel, every Thursday!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/paper/engine", 2, cost=20)
		product_list += new/datum/data/vending_product("/obj/item/paper/Toxin", 2, cost=20)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/cookbook", 2, cost=30)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/dwainedummies", 2, cost=60)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/guardbot_guide", 2, cost=50)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/hydroponicsguide", 2, cost=40)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/monster_manual", 2, cost=30)
		product_list += new/datum/data/vending_product("/obj/item/paper/Cloning", 2, cost=30)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/medical_guide", 2, cost=30)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/minerals", 2, cost=10)

		product_list += new/datum/data/vending_product("/obj/item/paper/book/the_trial", 1, cost=80, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/paper/book/critter_compendium", 1, cost=100, hidden=1)

/obj/machinery/vending/kitchen
	name = "FoodTech"
	desc = "Food storage unit."
	icon_state = "food"
	icon_panel = "standard-panel"
	req_access_txt = "28"
	acceptcard = 0

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/clothing/head/chefhat", 2)
		product_list += new/datum/data/vending_product("/obj/item/clothing/under/rank/chef", 2)
		product_list += new/datum/data/vending_product("/obj/item/clothing/suit/apron",2)
		product_list += new/datum/data/vending_product("/obj/item/clothing/head/souschefhat", 2)
		product_list += new/datum/data/vending_product("/obj/item/clothing/under/misc/souschef", 2)
		product_list += new/datum/data/vending_product("/obj/item/kitchen/utensil/fork", 10)
		product_list += new/datum/data/vending_product("/obj/item/kitchen/utensil/knife", 10)
		product_list += new/datum/data/vending_product("/obj/item/kitchen/utensil/spoon", 10)
		product_list += new/datum/data/vending_product("/obj/item/kitchen/rollingpin", 2)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bowl", 10)
		product_list += new/datum/data/vending_product("/obj/item/plate", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/ice_cream_cone", 20)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/ingredient/oatmeal", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/ingredient/peanutbutter", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/ingredient/flour", 20)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/ingredient/sugar", 20)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/ingredient/spaghetti", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/meatball", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/condiment/syrup", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/condiment/mayo", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/condiment/ketchup", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/plant/tomato", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/plant/apple", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/plant/lettuce", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/plant/potato", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/plant/corn", 10)

		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/breakfast", rand(2, 4), hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/snack_cake", rand(1, 3), hidden=1)

/obj/machinery/vending/monkey
	name = "ValuChimp"
	desc = "More fun than a barrel of monkeys! Monkeys may or may not be synthflesh replicas, may or may not contain partially-hydrogenated banana oil."
	icon_state = "monkey"
	icon_panel = "standard-panel"
	acceptcard = 0
	mats = 0 // >:I

	create_products()
		..()
		product_list += new/datum/data/vending_product("/mob/living/carbon/human/npc/monkey", rand(10, 15))

		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/snacks/plant/banana", rand(1,20), hidden=1)

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	acceptcard = 0
	slogan_list = list("Sling spells the proper way with MagiVend!",
	"Be your own Houdini! Use MagiVend!")

	vend_delay = 15
	vend_reply = "Have an enchanted evening!"

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/clothing/head/wizard", 1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/suit/wizrobe", 1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/shoes/sandal", 1)
		product_list += new/datum/data/vending_product("/obj/item/staff", 2)

		product_list += new/datum/data/vending_product("/obj/item/clothing/head/wizard/red", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/suit/wizrobe/red", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/head/wizard/purple", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/suit/wizrobe/purple", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/head/wizard/necro", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/clothing/suit/wizrobe/necro", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/staff/crystal", 1)

/obj/machinery/vending/standard
	desc = "A standard vending machine."
	icon_state = "standard"
	icon_panel = "standard-panel"
	acceptcard = 0
	slogan_list = list("Please make your selection.")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/device/prox_sensor", 8)
		product_list += new/datum/data/vending_product("/obj/item/device/igniter", 8)
		product_list += new/datum/data/vending_product("/obj/item/device/radio/signaler", 8)
		product_list += new/datum/data/vending_product("/obj/item/wirecutters", 1)
		product_list += new/datum/data/vending_product("/obj/item/device/timer", 8)

		product_list += new/datum/data/vending_product("/obj/item/device/flashlight", rand(1, 6), hidden=1)
		//product_list += new/datum/data/vending_product("/obj/item/device/timer", rand(1, 6), hidden=1)

/obj/machinery/vending/hydroponics
	name = "GardenGear"
	desc = "A vendor for Hydroponics related equipment."
	acceptcard = 0

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/wateringcan", 5)
		product_list += new/datum/data/vending_product("/obj/item/plantanalyzer", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/compostbag", 5)
		product_list += new/datum/data/vending_product("/obj/item/saw", 3)
		product_list += new/datum/data/vending_product("/obj/item/satchel/hydro", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/beaker", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/weedkiller", 10)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/mutriant", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/groboost", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/topcrop", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/powerplant", 5)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/glass/bottle/fruitful", 5)

		product_list += new/datum/data/vending_product("/obj/item/seedplanter/hidden", 1, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/seed/grass", rand(3, 6), hidden=1)
		if (prob(25))
			product_list += new/datum/data/vending_product("/obj/item/seed/alien", 1, hidden=1)

/obj/machinery/vending/hydroponics/mean_solarium_bullshit
	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/device/key/cheget",1, 954, 1)

/obj/machinery/vending/fortune
	name = "Zoldorf"
	desc = "A horrid old fortune-telling machine."
	icon_state = "fortuneteller"
	icon_vend = "fortuneteller-vend"
	pay = 1
	acceptcard = 1
	slogan_list = list("Ha ha ha ha ha!",
	"I am the great wizard Zoldorf!",
	"Learn your fate!")

	var/sound_riff = 'sound/machines/fortune_riff.ogg'
	var/sound_riff_broken = 'sound/machines/fortune_riff_broken.ogg'
	var/sound_greeting = 'sound/machines/fortune_greeting.ogg'
	var/sound_greeting_broken = 'sound/machines/fortune_greeting_broken.ogg'
	var/sound_laugh = 'sound/machines/fortune_laugh.ogg'
	var/sound_laugh_broken = 'sound/machines/fortune_laugh_broken.ogg'
	var/sound_ding = 'sound/machines/ding.ogg'
	var/list/sounds_working = list('sound/misc/automaton_spaz.ogg','sound/machines/mixer.ogg')
	var/list/sounds_broken = list('sound/machines/glitch1.ogg','sound/machines/glitch2.ogg','sound/machines/glitch3.ogg','sound/machines/glitch4.ogg','sound/machines/glitch5.ogg')

	New()
		..()
		light.set_color(0.8, 0.4, 1)

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/paper/thermal/fortune", 25, cost=10)
		product_list += new/datum/data/vending_product("/obj/item/playing_cards/tarot", 5, cost=25)
		product_list += new/datum/data/vending_product("/obj/item/paper/card_manual", 5, cost=1)

	prevend_effect()
		if(src.seconds_electrified)
			src.visible_message("<span style=\"color:blue\">[src] wakes up!</span>")
			playsound(src.loc, sound_riff_broken, 60, 1)
			sleep(20)
			playsound(src.loc, sound_greeting_broken, 65, 1)
			if (src.icon_vend)
				flick(src.icon_vend,src)
			speak("F*!@$*(9HZZZZ9**###!")
			sleep(25)
			src.visible_message("<span style=\"color:blue\">[src] spasms violently!</span>")
			playsound(src.loc, pick(sounds_broken), 40, 1)
			if (src.icon_vend)
				flick(src.icon_vend,src)
			sleep(10)
			src.visible_message("<span style=\"color:blue\">[src] makes an obscene gesture!</b></span>")
			playsound(src.loc, pick(sounds_broken), 40, 1)
			if (src.icon_vend)
				flick(src.icon_vend,src)
			sleep(15)
			playsound(src.loc, sound_laugh_broken, 65, 1)
			speak("AHHH#######!")

		else
			src.visible_message("<span style=\"color:blue\">[src] wakes up!</span>")
			playsound(src.loc, sound_riff, 60, 1)
			sleep(20)
			playsound(src.loc, sound_greeting, 65, 1)
			if (src.icon_vend)
				flick(src.icon_vend,src)
			speak("The great wizard Zoldorf is here!")
			sleep(25)
			src.visible_message("<span style=\"color:blue\">[src] rocks back and forth!</span>")
			playsound(src.loc, pick(sounds_working), 40, 1)
			if (src.icon_vend)
				flick(src.icon_vend,src)
			sleep(10)
			src.visible_message("<span style=\"color:blue\">[src] makes a mystical gesture!</b></span>")
			playsound(src.loc, pick(sounds_working), 40, 1)
			if (src.icon_vend)
				flick(src.icon_vend,src)
			sleep(15)
			playsound(src.loc, sound_laugh, 65, 1)
			speak("Ha ha ha ha ha!")

		return

	postvend_effect()
		playsound(src.loc, sound_ding, 50, 1)
		return

	fall(mob/living/carbon/victim)
		playsound(src.loc, sound_laugh, 65, 1)
		speak("Ha ha ha ha ha!")
		..()
		return

	electrocute(mob/user, netnum)
		..()
		playsound(src.loc, sound_laugh, 65, 1)
		speak("Ha ha ha ha ha!")
		return

/obj/machinery/vending/alcohol
	name = "Cap'n Bubs' Booze-O-Mat"
	desc = "A vending machine filled with various kinds of alcoholic beverages and things for fancying up drinks."
	icon_state = "capnbubs"
	icon_panel = "capnbubs-panel"
	slogan_list = list("hm hm",
	"Liquor - get it in ya!",
	"I am the liquor",
	"I don't always drink, but when I do, I sell the rights to my likeness")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/beer", 6)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/fancy_beer", 6)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/vodka", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/tequila", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/wine", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/cider", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/mead", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/gin", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/rum", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/champagne", 4)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/bojackson", 1)
		product_list += new/datum/data/vending_product("/obj/item/storage/box/cocktail_umbrellas", 4)
		product_list += new/datum/data/vending_product("/obj/item/storage/box/cocktail_doodads", 4)
		product_list += new/datum/data/vending_product("/obj/item/storage/box/fruit_wedges", 1)
		product_list += new/datum/data/vending_product("/obj/item/shaker/salt", 1)

		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/hobo_wine", 2, hidden=1)
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/food/drinks/bottle/thegoodstuff", 1, hidden=1)

/obj/machinery/vending/chem
	name = "ChemDepot"
	desc = "Some odd machine that dispenses little vials and packets of chemicals for exorbitant amounts of money. Is this thing even working right?"
	icon_state = "chem"
	icon_panel = "standard-panel"
	glitchy_slogans = 1
	pay = 1
	acceptcard = 1
	slogan_list = list("Hello!",
	"Please state the item you wish to purchase.",
	"Many goods at reasonable prices.",
	"Please step right up!",
	"Greetings!",
	"Thank you for your interest in VENDOR NAME's goods!")

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/vending/vial/random", 1, cost = rand(1000, 10000))
		var/lock1 = rand(1, 9)
		for (var/i = 0, i < lock1, i++) // this entire thing is just random luck
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/vending/vial/random", 1, cost = rand(1000, 10000))

		product_list += new/datum/data/vending_product("/obj/item/reagent_containers/vending/bag/random", 1, cost = rand(1000, 10000))
		var/lock2 = rand(1, 9)
		for (var/i = 0, i < lock2, i++) // so we'll add a random amount to each machine
			product_list += new/datum/data/vending_product("/obj/item/reagent_containers/vending/bag/random", 1, cost = rand(1000, 10000))

		product_list += new/datum/data/vending_product("/obj/item/cigpacket/random", 1, cost = rand(1000, 10000), hidden=1)
		var/lock3 = rand(1, 9)
		for (var/i = 0, i < lock3, i++)
			product_list += new/datum/data/vending_product("/obj/item/cigpacket/random", 1, cost = rand(1000, 10000), hidden=1)

/obj/machinery/vending/cards
	name = "card machine"
	desc = "A machine that sells various kinds of cards, noteably Spacemen the Grifening trading cards!"
	pay = 1
	vend_delay = 10
	icon_state = "card"
	icon_panel = "card-panel"

	create_products()
		..()
		product_list += new/datum/data/vending_product("/obj/item/paper/card_manual", 10, cost=1)
		product_list += new/datum/data/vending_product("/obj/item/card_box/trading", 5, cost=60)
		product_list += new/datum/data/vending_product("/obj/item/card_box/booster", 20, cost=20)
		product_list += new/datum/data/vending_product("/obj/item/card_box/suit", 10, cost=15)
		product_list += new/datum/data/vending_product("/obj/item/card_box/tarot", 5, cost=25)

//obj/machinery/vending
/	var/const
#define WIRE_EXTEND 1
#define WIRE_SCANID 2
#define WIRE_SHOCK 3
#define WIRE_SHOOTINV 4

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				spawn(0)
					src.malfunction()
					return
				return
			else if (prob(25))
				spawn(0)
					src.fall()
					return
		else
	return

/obj/machinery/vending/blob_act(var/power)
	if (prob(power * 1.25))
		spawn(0)
			if (prob(power / 3) && can_fall == 2)
				for (var/i = 0, i < rand(4,7), i++)
					src.malfunction()
				qdel(src)
			if (prob(50) || can_fall == 2)
				src.malfunction()
			else
				src.fall()
		return

	return

/obj/machinery/vending/emag_act(var/mob/user, var/obj/item/card/emag/E)
	if (!src.emagged)
		src.emagged = 1
		if(user)
			boutput(user, "You short out the product lock on [src]")
		return 1
	return 0

/obj/machinery/vending/demag(var/mob/user)
	if (!src.emagged)
		return 0
	if (user)
		user.show_text("You repair the product lock on [src].")
	src.emagged = 0
	return 1

/obj/machinery/vending/proc/scan_card(var/obj/item/card/id/card as obj, var/mob/user as mob)
	if (!card || !user || !src.acceptcard)
		return
	boutput(user, "<span style=\"color:blue\">You swipe [card].</span>")
	var/datum/data/record/account = null
	account = FindBankAccountByName(card.registered)
	if (account)
		var/enterpin = input(user, "Please enter your PIN number.", "Enter PIN", 0) as null|num
		if (enterpin == card.pin)
			boutput(user, "<span style=\"color:blue\">Card authorized.</span>")
			src.scan = card
		else
			boutput(user, "<span style=\"color:red\">Pin number incorrect.</span>")
			src.scan = null
	else
		boutput(user, "<span style=\"color:red\">No bank account associated with this ID found.</span>")
		src.scan = null

/obj/machinery/vending/proc/generate_HTML(var/update_vending = 0, var/update_wire = 0)
	src.HTML = ""

	if (!src.wire_HTML || update_wire)
		src.generate_wire_HTML()
	if (src.panel_open)
		src.HTML += src.wire_HTML

	if (!src.vending_HTML || update_vending)
		src.generate_vending_HTML()
	src.HTML += src.vending_HTML

	src.updateUsrDialog()

/obj/machinery/vending/proc/generate_vending_HTML()
	src.vending_HTML = "<TT><b>Welcome!</b><br>"

	if (src.paying_for && (!istype(src.paying_for, /datum/data/vending_product) || !src.pay))
		src.paying_for = null

	if (src.pay && src.acceptcard)
		if (src.paying_for && !src.scan)
			src.vending_HTML += "<B>You have selected the following item:</b><br>"
			src.vending_HTML += "&emsp;<font color = '[src.paying_for.product_display_color]'><b>[src.paying_for.product_name]</b></font><br>"
			src.vending_HTML += "Please swipe your card to authorize payment.<br>"
			src.vending_HTML += "<B>Current ID:</B> None<BR>"
		else if (src.scan)
			if (src.paying_for)
				src.vending_HTML += "<B>You have selected the following item for purchase:</b><br>"
				src.vending_HTML += "&emsp;[src.paying_for.product_name]<br>"
				src.vending_HTML += "<B>Please swipe your card to authorize payment.</b><br>"
			var/datum/data/record/account = null
			account = FindBankAccountByName(src.scan.registered)
			src.vending_HTML += "<B>Current ID:</B> <a href='byond://?src=\ref[src];logout=1'><u>([src.scan])</u></A><BR>"
			src.vending_HTML += "<B>Credits on Account: [account.fields["current_money"]] Credits</B> <BR>"
		else
			src.vending_HTML += "<B>Current ID:</B> None<BR>"

	if (src.product_list.len == 0)
		src.vending_HTML += "<font color = 'red'>No product loaded!</font>"

	else if (src.paying_for)
		src.vending_HTML += "<a href='byond://?src=\ref[src];vend=\ref[src.paying_for]'><u><b>Continue</b></u></a>"
		src.vending_HTML += " | <a href='byond://?src=\ref[src];cancel_payfor=1;logout=1'><u><b>Cancel</b></u></a>"

	else
		for (var/datum/data/vending_product/R in src.product_list)
			if (R.product_hidden && !src.extended_inventory)
				continue
			src.vending_HTML += "<FONT color = '[R.product_display_color]'><B>[R.product_name]</B>:"
			src.vending_HTML += " [R.product_amount] </font>"

			if (R.product_amount > 0)
				src.vending_HTML += "<a href='byond://?src=\ref[src];vend=\ref[R]'>Vend[(src.pay && R.product_cost) ? " ($[R.product_cost])" : null]</A>"
			else
				src.vending_HTML += "<font color = 'red'>SOLD OUT</font>"
			src.vending_HTML += "<br>"

		if (src.pay)
			src.vending_HTML += "<BR><B>Available Credits:</B> $[src.credit] <a href='byond://?src=\ref[src];return_credits=1'>Return Credits</A>"
			if (!src.acceptcard)
				src.vending_HTML += "<BR>This machine only takes credit bills."

		src.vending_HTML += "</TT>"

/obj/machinery/vending/proc/generate_wire_HTML()
	src.vendwires = list("Violet" = 1,\
		"Orange" = 2,\
		"Goldenrod" = 3,\
		"Green" = 4,)
	src.wire_HTML = "<TT><B>The Access Panel is open:</B><br>"
	src.wire_HTML += "<table border=\"1\" style=\"width:100%\"><tbody><tr><td><small>"
	for (var/wiredesc in vendwires)
		var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
		src.wire_HTML += "[wiredesc] wire: "
		if (!is_uncut)
			src.wire_HTML += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
		else
			src.wire_HTML += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
			src.wire_HTML += "<a href='?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
		src.wire_HTML += "<br>"

	src.wire_HTML += "<br>"
	src.wire_HTML += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
	src.wire_HTML += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
	src.wire_HTML += "The green light is [src.extended_inventory ? "on" : "off"].<BR>"
	src.wire_HTML += "The [(src.wires & WIRE_SCANID) ? "purple" : "yellow"] light is on."
	src.wire_HTML += "</small></td></tr></tbody></table></TT><br>"

/obj/machinery/vending/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/spacecash))
		if (src.pay)
			src.credit += W.amount
			W.amount = 0
			boutput(user, "<span style=\"color:blue\">You insert [W].</span>")
			user.u_equip(W)
			W.dropped()
			qdel( W )
			src.generate_HTML(1)
			return
		else
			boutput(user, "<span style=\"color:red\">This machine does not accept cash.</span>")
			return
	if (istype(W, /obj/item/device/pda2) && W:ID_card)
		W = W:ID_card
	if (istype(W, /obj/item/card/id))
		if (src.acceptcard)
			src.scan_card(W, user)
			src.generate_HTML(1)
			return
			/*var/amount = input(usr, "How much money would you like to deposit?", "Deposit", 0) as null|num
			if(amount <= 0)
				return
			if(amount > W:money)
				boutput(user, "<span style=\"color:red\">Insufficent funds. [W] only has [W:money] credits.</span>")
				return
			src.credit += amount
			W:money -= amount
			boutput(user, "<span style=\"color:blue\">You deposit [amount] credits. [W] now has [W:money] credits.</span>")
			src.updateUsrDialog()
			return()*/
		else
			boutput(user, "<span style=\"color:red\">This machine does not accept ID cards.</span>")
			return
	else if(istype(W, /obj/item/screwdriver))
		src.panel_open = !src.panel_open
		boutput(user, "You [src.panel_open ? "open" : "close"] the maintenance panel.")
		src.UpdateOverlays(src.panel_open ? src.panel_image : null, "panel")
		src.generate_HTML(0, 1)
		return
	else if (istype(W, /obj/item/device/t_scanner) || (istype(W, /obj/item/device/pda2) && istype(W:module, /obj/item/device/pda_module/tray)))
		if (src.seconds_electrified != 0)
			boutput(user, "<span style=\"color:red\">[bicon(W)] <b>WARNING</b>: Abnormal electrical response received from access panel.</span>")
		else
			if (stat & NOPOWER)
				boutput(user, "<span style=\"color:red\">[bicon(W)] No electrical response received from access panel.</span>")
			else
				boutput(user, "<span style=\"color:blue\">[bicon(W)] Regular electrical response received from access panel.</span>")
		return
	else if (istype(W, /obj/item/device/multitool))
		return src.attack_hand(user)

	else
		..()
		if (W && W.force >= 5 && prob(4 + (W.force - 5)))
			src.fall(user)

/obj/machinery/vending/hitby(M as mob|obj)
	if (iscarbon(M) && M:throwing && prob(25))
		src.fall(M)
		return

	..()

/obj/machinery/vending/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user as mob)
	if (stat & (BROKEN|NOPOWER))
		return
	user.machine = src

	if (src.seconds_electrified != 0)
		if (src.shock(user, 100))
			return

	if (!src.HTML)
		src.generate_HTML()
	else
		if (src.HTML && !src.vending_HTML)
			src.generate_HTML(1)
		if (src.HTML && src.panel_open && !src.wire_HTML)
			src.generate_HTML(0, 1)

	user << browse(src.HTML, "window=vending")
	onclose(user, "vending")
	return

/obj/machinery/vending/Topic(href, href_list)
	if (stat & (BROKEN|NOPOWER))
		return
	if (usr.stat || usr.restrained())
		return

	if (isAI(usr))
		boutput(usr, "<span style=\"color:red\">The vending machine refuses to interface with you, as you are not in its target demographic!</span>")
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.machine = src
		src.add_fingerprint(usr)
		if ((href_list["vend"]) && (src.vend_ready))

			if ((!src.allowed(usr, req_only_one_required)) && (!src.emagged) && (src.wires & WIRE_SCANID)) //For SECURE VENDING MACHINES YEAH
				boutput(usr, "<span style=\"color:red\">Access denied.</span>") //Unless emagged of course
				flick(src.icon_deny,src)
				return

			src.vend_ready = 0 //One thing at a time!!

			var/datum/data/vending_product/R = locate(href_list["vend"])

			if (!R || !istype(R))
				src.vend_ready = 1
				return

			var/product_path = R.product_path

			if (istext(product_path))
				product_path = text2path(product_path)

			if (!product_path)
				src.vend_ready = 1
				return

			if (R.product_amount <= 0)
				src.vend_ready = 1
				return

			//Wire: Fix for href exploit allowing for vending of arbitrary items
			if (!(R in src.product_list))
				src.vend_ready = 1
				return

			var/datum/data/record/account = null
			if (src.pay)
				if (src.acceptcard && src.scan)
					account = FindBankAccountByName(src.scan.registered)
					if (!account)
						boutput(usr, "<span style=\"color:red\">No bank account associated with ID found.</span>")
						flick(src.icon_deny,src)
						src.vend_ready = 1
						src.paying_for = R
						src.generate_HTML(1)
						return
					if (account.fields["current_money"] < R.product_cost)
						boutput(usr, "<span style=\"color:red\">Insufficient funds in account. To use machine credit, log out.</span>")
						flick(src.icon_deny,src)
						src.vend_ready = 1
						src.paying_for = R
						src.generate_HTML(1)
						return
				else

					if (src.credit < R.product_cost)
						boutput(usr, "<span style=\"color:red\">Insufficient Credit.</span>")
						flick(src.icon_deny,src)
						src.vend_ready = 1
						src.paying_for = R
						src.generate_HTML(1)
						return

			if (((src.last_reply + (src.vend_delay + 200)) <= world.time) && src.vend_reply)
				spawn(0)
					src.speak(src.vend_reply)
					src.last_reply = world.time

			use_power(10)
			if (src.icon_vend) //Show the vending animation if needed
				flick(src.icon_vend,src)

			src.prevend_effect()
			spawn(src.vend_delay)
				if (!pay || (src.credit >= R.product_cost) || (account && account.fields["current_money"] >= R.product_cost)) //Conor12: Prevents credit hitting negative numbers if multiple items are bought at once.
					R.product_amount--
					if (ispath(product_path))
						new product_path(get_turf(src))
					else if (isicon(R.product_path))
						var/icon/welp = icon(R.product_path)
						if (welp.Width() > 32 || welp.Height() > 32)
							welp.Scale(32, 32)
							R.product_path = welp // if scaling is required reset the product_path so it only happens the first time
						var/obj/dummy = new /obj/item(get_turf(src))
						dummy.name = R.product_name
						dummy.desc = "?!"
						dummy.icon = welp
					else if (isfile(R.product_path))
						var/S = sound(R.product_path)
						if (S)
							playsound(src.loc, S, 50, 0)

					if (src.pay)
						if (src.acceptcard && src.scan && account)
							account.fields["current_money"] -= R.product_cost
						else
							src.credit -= R.product_cost
						wagesystem.shipping_budget += round(R.product_cost * profit) // cogwerks - maybe money shouldn't just vanish into the aether idk

					src.postvend_effect()

					if (mechanics)
						mechanics.fireOutgoing(mechanics.newSignal("productDispensed"))

				src.generate_HTML(1)

			if (src.paying_for)
				src.paying_for = null
				src.scan = null
			src.generate_HTML(1)
			src.vend_ready = 1

		if (href_list["logout"])
			src.scan = null
			src.generate_HTML(1)

		if (href_list["cancel_payfor"])
			src.paying_for = null
			src.generate_HTML(1)

		if (href_list["return_credits"])
			spawn(src.vend_delay)
				if (src.credit > 0)
					var/obj/item/spacecash/returned = new /obj/item/spacecash(get_turf(src), src.credit)
					src.credit = 0
					boutput(usr, "<span style=\"color:blue\">You receive [returned].</span>")
					src.generate_HTML(1)

		if ((href_list["cutwire"]) && (src.panel_open))
			var/twire = text2num(href_list["cutwire"])
			if (!( istype(usr.equipped(), /obj/item/wirecutters) ))
				boutput(usr, "You need wirecutters!")
				return
			else if (src.isWireColorCut(twire))
				src.mend(twire)
			else
				src.cut(twire)

		if ((href_list["pulsewire"]) && (src.panel_open))
			var/twire = text2num(href_list["pulsewire"])
			if (!istype(usr.equipped(), /obj/item/device/multitool))
				boutput(usr, "You need a multitool!")
				return
			else if (src.isWireColorCut(twire))
				boutput(usr, "You can't pulse a cut wire.")
				return
			else
				src.pulse(twire)
	else
		usr << browse(null, "window=vending")
		return
	return

/obj/machinery/vending/process()
	if (stat & BROKEN)
		return
	..()
	if (stat & NOPOWER)
		return

	if (!src.active)
		return

	if (src.seconds_electrified > 0)
		src.seconds_electrified--

	//Pitch to the people!  Really sell it!
	if (prob(src.slogan_chance) && ((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0))
		var/slogan = pick(src.slogan_list)
		src.speak(slogan)
		src.last_slogan = world.time

	if ((prob(shoot_inventory_chance)) && (src.shoot_inventory))
		src.throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if (stat & NOPOWER)
		return

	if (!message)
		return

	for (var/mob/O in hearers(src, null))
		if (src.glitchy_slogans)
			O.show_message("<span class='game say'><span class='name'>[src]</span> beeps,</span> \"[voidSpeak(message)]\"", 2)
		else
			O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"</span>", 2)

	return

/obj/machinery/vending/proc/prevend_effect()
	return

/obj/machinery/vending/proc/postvend_effect()
	return

/obj/machinery/vending/power_change()
	if (can_fall == 2)
		icon_state = "[initial(icon_state)]-fallen"
		light.disable()
		return

	if (stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		light.disable()
	else
		if ( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
			light.enable()
		else
			spawn(rand(0, 15))
				src.icon_state = "[initial(icon_state)]-off"
				stat |= NOPOWER
				light.disable()

/obj/machinery/vending/proc/fall(mob/living/carbon/victim)
	if (can_fall != 1)
		return
	can_fall = 2
	stat |= BROKEN
	var/turf/vicTurf = get_turf(victim)
	src.icon_state = "[initial(icon_state)]-fallen"
//	spawn(0)
//		src.icon_state = "[initial(icon_state)]-fall"
//		spawn(20)
//			src.icon_state = "[initial(icon_state)]-fallen"
	if (istype(victim) && vicTurf && (get_dist(vicTurf, src) <= 1))
		victim.weakened = 30
		src.visible_message("<b><font color=red>[src.name] tips over onto [victim]!</font></b>")
		victim.lying = 1
		victim.set_loc(vicTurf)
		if (src.layer < victim.layer)
			src.layer = victim.layer+1
		src.set_loc(vicTurf)
		random_brute_damage(victim, rand(30,50))
	else
		src.visible_message("<b><font color=red>[src.name] tips over!</font></b>")

	src.power_change()
	src.anchored = 0
	return

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/data/vending_product/R in src.product_list)
		if (R.product_amount <= 0) //Try to use a record that actually has something to dump.
			continue

		var/dump_path = null
		if (ispath(R.product_path))
			dump_path = R.product_path
		else if (istext(R.product_path))
			dump_path = text2path(R.product_path)
			if (isnull(dump_path))
				continue
		else
			continue

		while(R.product_amount>0)
			new dump_path(src.loc)
			R.product_amount--
		break

	stat |= BROKEN
	power_change()
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/data/vending_product/R in src.product_list)
		if (R.product_amount <= 0) //Try to use a record that actually has something to dump.
			continue

		if (!prob(100/src.product_list.len)) //don't always use the top thing
			continue

		if (ispath(R.product_path))
			var/dump_path = R.product_path
			throw_item = new dump_path(src.loc)
			if (throw_item)
				R.product_amount--
				break
		else if (istext(R.product_path))
			var/dump_path = text2path(R.product_path)
			if (dump_path)
				throw_item = new dump_path(src.loc)
			if (throw_item)
				R.product_amount--
				break
		else if (isicon(R.product_path))
			var/icon/welp = icon(R.product_path)
			if (welp.Width() > 32 || welp.Height() > 32)
				welp.Scale(32, 32)
				R.product_path = welp // if scaling is required reset the product_path so it only happens the first time
			var/obj/dummy = new /obj/item(get_turf(src))
			dummy.name = R.product_name
			dummy.desc = "?!"
			dummy.icon = welp
			throw_item = dummy
			if (throw_item)
				R.product_amount--
				break
		else if (isfile(R.product_path))
			var/sound/S = sound(R.product_path)
			if (S)
				R.product_amount--
				spawn(0)
					playsound(src.loc, S, 50, 0)
					src.visible_message("<span style=\"color:red\"><b>[src] launches [R.product_name] at [target.name]!</b></span>")
					src.generate_HTML(1)
				return 1

	spawn(0)
		if (throw_item)
			throw_item.throw_at(target, 16, 3)
			src.visible_message("<span style=\"color:red\"><b>[src] launches [throw_item.name] at [target.name]!</b></span>")
	return 1

/obj/machinery/vending/proc/isWireColorCut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/vending/proc/isWireCut(var/wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/vending/proc/cut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	src.wires &= ~wireFlag
	switch(wireIndex)
		if(WIRE_EXTEND)
			src.extended_inventory = 0
			src.generate_HTML(1)
		if(WIRE_SHOCK)
			src.seconds_electrified = -1
		if (WIRE_SHOOTINV)
			if(!src.shoot_inventory)
				src.shoot_inventory = 1
	src.generate_HTML(0, 1)

/obj/machinery/vending/proc/mend(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	src.wires |= wireFlag
	switch(wireIndex)
//		if(WIRE_SCANID)
		if(WIRE_SHOCK)
			src.seconds_electrified = 0
		if (WIRE_SHOOTINV)
			src.shoot_inventory = 0
	src.generate_HTML(0, 1)

/obj/machinery/vending/proc/pulse(var/wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch (wireIndex)
		if (WIRE_EXTEND)
			src.extended_inventory = !src.extended_inventory
			src.generate_HTML(1)
//		if (WIRE_SCANID)
		if (WIRE_SHOCK)
			src.seconds_electrified = 30
		if (WIRE_SHOOTINV)
			src.shoot_inventory = !src.shoot_inventory
	src.generate_HTML(0, 1)

//"Borrowed" airlock shocking code.
/obj/machinery/vending/proc/shock(mob/user, prb)
	if (!prob(prb))
		return 0

	if (stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0

	if (src.electrocute(user, 1))
		return 1
	else
		return 0

/obj/machinery/vending/electrocute(mob/user, netnum)
	if (!netnum)		// unconnected cable is unpowered
		return 0

	var/datum/powernet/PN			// find the powernet
	if (powernets && powernets.len >= netnum)
		PN = powernets[netnum]

	var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
	s.set_up(5, 1, src)
	s.start()

	if (user.shock(src, PN.avail, user.hand == 1 ? "l_arm" : "r_arm", 1, 0))
		for (var/mob/M in AIviewers(src))
			if (M == user)	continue
			M.show_message("<span style=\"color:red\">[user.name] was shocked by the [src.name]!</span>", 3, "<span style=\"color:red\">You hear a heavy electrical crack</span>", 2)
		return 1
	return 0

#undef WIRE_EXTEND
#undef WIRE_SCANID
#undef WIRE_SHOCK
#undef WIRE_SHOOTINV