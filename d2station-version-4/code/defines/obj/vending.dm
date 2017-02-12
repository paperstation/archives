/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'vending.dmi'
	icon_state = "generic"
	layer = 2.9
	anchored = 1
	density = 1
	var///product_cost = 0
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/product_paths = "" //String of product paths separated by semicolons. No spaces!
	var/product_amounts = "" //String of product amounts separated by semicolons, must have amount for every path in product_paths
	var/product_slogans = "" //String of slogans separated by semicolons, optional
	var/product_hidden = "" //String of products that are hidden unless hacked.
	var/product_hideamt = "" //String of hidden product amounts, separated by semicolons. Exact same as amounts. Must be left blank if hidden is.
	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/slogan_list = list()
	var/list/product_prices = list()
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 600 //How long until we can pitch again?
	var/icon_vend //Icon_state when vending!
	var/icon_deny //Icon_state when vending!
	var/emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/extended_inventory = 0 //can we access the hidden inventory?
	var/panel_open = 0 //Hacking that vending machine. Gonna get a free candy bar.
	var/wires = 15
	var/inflation = 0
	var/obj/item/weapon/money = null

/*
ALRIGHT HELLO FUCKERS
EACH ITEM NEEDS TO HAVE AN EQUAL AMOUNT OF PATHS, AMOUNTS, PRICES AND SAME FOR HIDDEN PATHS AND AMOUNTS.
HIDDEN ITEMS ARE FREE BY DEFAULT BECAUSE I AM A LAZY SHIT AND THEY ARE NOT VERY IMPORTANT

-- ERIKAT
*/

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/bottle/gin;/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey;/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla;/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka;/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth;/obj/item/weapon/reagent_containers/food/drinks/bottle/rum;/obj/item/weapon/reagent_containers/food/drinks/bottle/wine;/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac;/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua;/obj/item/weapon/reagent_containers/food/drinks/beer;/obj/item/weapon/reagent_containers/food/drinks/ale;/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice;/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice;/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice;/obj/item/weapon/reagent_containers/food/drinks/bottle/cream;/obj/item/weapon/reagent_containers/food/drinks/tonic;/obj/item/weapon/reagent_containers/food/drinks/cola;/obj/item/weapon/reagent_containers/food/drinks/sodawater;/obj/item/weapon/reagent_containers/food/drinks/drinkingglass;/obj/item/weapon/reagent_containers/food/drinks/wineglass;/obj/item/weapon/reagent_containers/food/drinks/ice"
	product_amounts = "5;5;5;5;5;5;5;5;5;6;6;4;4;4;4;8;8;8;30;30;10"
	product_prices = "0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0"
	vend_delay = 15
	//product_cost = 0
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/coffee;/obj/item/weapon/reagent_containers/food/drinks/tea;/obj/item/weapon/reagent_containers/food/drinks/bottle/robustersdelight;/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate"
	product_hideamt = "10;10;3;3"
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"

/obj/machinery/vending/virology
	name = "Plague-Mate"
	desc = "After complaints of virologists not having syringes and other materials, this was sent to D2K5 Space Observatory with a complimentary 'Shut the fuck up' note."
	icon_state = "viro"
	product_paths = "/obj/item/weapon/reagent_containers/glass/bottle/antitoxin;/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline;/obj/item/weapon/reagent_containers/glass/bottle/toxin;/obj/item/weapon/reagent_containers/syringe/antiviral;/obj/item/weapon/reagent_containers/syringe;/obj/item/device/healthanalyzer;/obj/item/weapon/reagent_containers/glass/beaker;/obj/item/weapon/storage/testtubebox;/obj/item/weapon/reagent_containers/bottle/corophizine;/obj/item/weapon/tank/oxygen/yellow;/obj/item/clothing/mask/gas"
	product_amounts = "4;4;4;4;12;5;4;5;4;7;7"
	product_prices = "0;0;0;0;0;0;0;0;0;0;0"
	vend_delay = 15
	product_hidden = "/obj/item/clothing/mask/gas/plaguedoctor" // I'VE GOT FRESH CAUGHT LEECHES TODAY! COME, AMICI!
	product_hideamt = "1"
	product_slogans = "Virologist supplies! Git your virology supplies!;Doctor said I'm sterile. Wonderful news!;I may be ugly, but i have a wonderful personality!"

/obj/machinery/vending/assist
	product_amounts = "5;5;4;1;4"
	product_prices = "0;0;0;0;0"
	product_hidden = "/obj/item/toy/crayonbox;/obj/item/weapon/bikehorn"
	product_paths = "/obj/item/device/prox_sensor;/obj/item/device/timer;/obj/item/device/radio/signaler;/obj/item/device/flashlight;/obj/item/weapon/cartridge/signal"
	product_hideamt = "1;1"
	//product_cost = 1

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/coffee;/obj/item/weapon/reagent_containers/food/drinks/tea;/obj/item/weapon/reagent_containers/food/drinks/h_chocolate"
	product_amounts = "25;25;25"
	product_prices = "0.10;0.20;0.30"
	vend_delay = 34
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/ice"
	product_hideamt = "10"
	//product_cost = 0.20

/obj/machinery/vending/coffee/lounge
	name = "MechaButler 9000"
	desc = "A machine which dispenses drinks."
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/coffee;/obj/item/weapon/reagent_containers/food/drinks/tea;/obj/item/weapon/reagent_containers/food/drinks/wineglass/wine"
	product_amounts = "25;25;25"
	product_prices = "0.10;0.20;0.50"
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/ice"
	product_hideamt = "10"
	//product_cost = 0.30

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars"
	icon_state = "snack"
	product_paths = "/obj/item/weapon/reagent_containers/food/snacks/candy;/obj/item/weapon/reagent_containers/food/drinks/dry_ramen;/obj/item/weapon/reagent_containers/food/snacks/chips;/obj/item/weapon/reagent_containers/food/snacks/sosjerky;/obj/item/weapon/reagent_containers/food/snacks/no_raisin;/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie;/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers"
	product_amounts = "10;10;10;10;10;10;10"
	product_prices = "0.10;0.30;0.10;0.20;0.10;0.15;0.20"
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_hidden = "/obj/item/weapon/reagent_containers/food/snacks/syndicake;/obj/item/weapon/monkeycube_box"
	product_hideamt = "10;1"
	//product_cost = 0.10

/obj/machinery/vending/cupdispenser
	name = "plastic cup dispenser"
	desc = "Plastic cups!"
	icon_state = "cupdispenser"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/papercup"
	product_amounts = "20"
	product_prices = "0"
	//product_cost = 0.01
	density = 0

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/cola;/obj/item/weapon/reagent_containers/food/drinks/space_mountain_wind;/obj/item/weapon/reagent_containers/food/drinks/dr_gibb;/obj/item/weapon/reagent_containers/food/drinks/starkist;/obj/item/weapon/reagent_containers/food/drinks/space_up;/obj/item/weapon/reagent_containers/food/drinks/water"
	product_amounts = "10;10;10;10;10;10"
	product_prices = "0.50;0.20;0.20;0.20;0.30;0.10"
	product_slogans = "Robust Softdrinks: More robust then a toolbox to the head!"
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/thirteenloko;/obj/item/weapon/reagent_containers/food/drinks/robust_cola"
	product_hideamt = "5;5"
	//product_cost = 0.30

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style"
	icon_state = "cigs"
	product_paths = "/obj/item/weapon/storage/cigpack;/obj/item/weapon/storage/matchbox;/obj/item/weapon/storage/rollingpapers;/obj/item/device/igniter;/obj/item/weapon/zippo"
	product_amounts = "10;10;10;5;5"
	product_prices = "5;0;0.10;4;10"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!;Smoked by Pilcrow for ages!"
	vend_delay = 34
	product_hidden = "/obj/item/clothing/mask/cigarette/cigar/havana;/obj/item/clothing/mask/cigarette/cigar/cohiba;/obj/item/weapon/reagent_containers/cigs/medicalcannabis"
	product_hideamt = "3;3;3"
	//product_cost = 5

/obj/machinery/vending/cigarette/lounge
	name = "Gentleman's Cigar Dispenser"
	desc = "A fine piece of machinery handcrafted by Sir Apricots, Esq. for the enjoyment of many a Gentleman."
	product_paths = "/obj/item/weapon/storage/cigars;/obj/item/clothing/mask/cigarette/cigar;/obj/item/clothing/mask/cigarette/cigar/cohiba;/obj/item/weapon/storage/matchbox;/obj/item/clothing/mask/cigarette/marijuana"
	product_amounts = "10;12;6;12;12"
	product_prices = "20;0.5;1;0;1.5"
	product_slogans = "If you want to get cancer, might as well do it in style.;I would rather partake in the act of having a toolbox repeatedly applied to my cranium than to switch my brand preferences.;Smoke!;Don't believe the fools and their reports - smoke today!"
	product_hidden = "/obj/item/clothing/mask/cigarette/cigar/havana;/obj/item/weapon/zippo"
	product_hideamt = "5;5"

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	req_access_txt = "5"
	product_paths = "/obj/item/weapon/reagent_containers/glass/bottle/antitoxin;/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline;/obj/item/weapon/reagent_containers/glass/bottle/stoxin;/obj/item/weapon/reagent_containers/glass/bottle/toxin;/obj/item/weapon/reagent_containers/syringe/antiviral;/obj/item/weapon/reagent_containers/syringe;/obj/item/device/healthanalyzer;/obj/item/weapon/reagent_containers/glass/beaker"
	product_amounts = "4;4;4;4;4;12;5;4"
	product_prices = "0;0;0;0;0;0;0;0"
	product_hidden = "/obj/item/weapon/reagent_containers/pill/tox;/obj/item/weapon/reagent_containers/pill/stox;/obj/item/weapon/reagent_containers/pill/antitox"
	product_hideamt = "3;4;6"
	//product_cost = 0

/obj/machinery/vending/medical/blood
	name = "BloodBank Pro"
	desc = "Blood dispenser."
	icon_state = "medblood"
	icon_deny = "medblood-deny"
	req_access_txt = "5"
	product_paths = "/obj/item/weapon/reagent_containers/glass/bottle/hemoline;/obj/item/weapon/reagent_containers/glass/bottle/heparin;/obj/item/weapon/reagent_containers/glass/large/iv_bag;/obj/item/weapon/reagent_containers/glass/large/iv_bag/blood;/obj/item/weapon/surgicaltube"
	product_amounts = "4;4;6;10;5"
	product_prices = "0;0;0;0;0"
	product_hidden = "/obj/item/weapon/reagent_containers/pill/tox;/obj/item/weapon/reagent_containers/pill/stox;/obj/item/weapon/reagent_containers/pill/antitox"
	product_hideamt = "3;4;6"
	//product_cost = 0

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access_txt = "1"
	product_paths = "/obj/item/weapon/handcuffs;/obj/item/weapon/chem_grenade/flashbang;/obj/item/device/flash;/obj/item/weapon/reagent_containers/food/snacks/donut"
	product_amounts = "8;2;5;12"
	product_prices = "0;0;0;0"
	//product_amounts = "8;5;4" Old totals
	product_hidden = "/obj/item/clothing/glasses/sunglasses;/obj/item/kitchen/donut_box"
	product_hideamt = "2;2"
	//product_cost = 0

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor"
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	product_paths = "/obj/item/nutrient/ez;/obj/item/nutrient/l4z;/obj/item/nutrient/rh;/obj/item/weapon/pestspray;/obj/item/weapon/reagent_containers/syringe"
	product_amounts = "35;25;15;20;5"
	product_prices = "0;0;0;0;0"
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_hidden = "/obj/item/weapon/reagent_containers/glass/bottle/ammonia;/obj/item/weapon/reagent_containers/glass/bottle/diethylamine"
	product_hideamt = "10;5"
	//product_cost = 0

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_state = "seeds"
	product_paths = "/obj/item/seeds/bananaseed;/obj/item/seeds/berryseed;/obj/item/seeds/carrotseed;/obj/item/seeds/chantermycelium;/obj/item/seeds/chiliseed;/obj/item/seeds/cornseed;/obj/item/seeds/eggplantseed;/obj/item/seeds/potatoseed;/obj/item/seeds/replicapod;/obj/item/seeds/soyaseed;/obj/item/seeds/sunflowerseed;/obj/item/seeds/tomatoseed;/obj/item/seeds/towermycelium;/obj/item/seeds/wheatseed;/obj/item/seeds/appleseed;/obj/item/seeds/poppyseed;/obj/item/seeds/ambrosiavulgarisseed;/obj/item/seeds/whitebeetseed;/obj/item/seeds/watermelonseed;/obj/item/seeds/limeseed;/obj/item/seeds/lemonseed;/obj/item/seeds/orangeseed;/obj/item/seeds/grassseed;/obj/item/seeds/sugarcaneseed;/obj/item/seeds/cocoapodseed;/obj/item/seeds/cabbageseed;/obj/item/seeds/grapeseed;/obj/item/seeds/pumpkinseed"
	product_amounts = "3;2;2;2;2;2;2;2;3;2;2;2;2;2;3;5;4;3;3;3;3;3;3;3;3;3;3;3"
	product_prices = "0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_hidden = "/obj/item/seeds/amanitamycelium;/obj/item/seeds/glowshroom;/obj/item/seeds/libertymycelium;/obj/item/seeds/nettleseed;/obj/item/seeds/plumpmycelium"
	product_hideamt = "2;2;2;2;2"
	//product_cost = 0

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_amounts = "1;1;1;1;1;2"
	product_prices = "0;0;0;0;0;0"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	product_paths = "/obj/item/clothing/head/wizard;/obj/item/clothing/suit/wizrobe;/obj/item/clothing/head/wizard/red;/obj/item/clothing/suit/wizrobe/red;/obj/item/clothing/shoes/sandal;/obj/item/weapon/staff"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_hidden = "/obj/item/weapon/reagent_containers/glass/bottle/wizarditis" //No one can get to the machine to hack it anyways
	product_hideamt = "1" //Just one, for the lulz, not like anyone can get it - Microwave
	//product_cost = 0

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor"
	icon_state = "dinnerware"
	product_paths = "/obj/item/weapon/tray;/obj/item/weapon/kitchen/utensil/fork;/obj/item/weapon/kitchenknife;/obj/item/weapon/reagent_containers/food/drinks/drinkingglass"
	product_amounts = "6;4;2;15"
	product_prices = "0;0;0;0"
	//product_amounts = "8;5;4" Old totals
	product_hidden = "/obj/item/weapon/kitchen/utensil/spoon;/obj/item/weapon/kitchen/utensil/knife;/obj/item/weapon/kitchen/rollingpin"
	product_hideamt = "2;2;2"
	//product_cost = 0


/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "Old sweet water vending machine"
	icon_state = "sovietsoda"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda"
	product_amounts = "30"
	product_prices = "0.5"
	//product_amounts = "8;5;4" Old totals
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola"
	product_hideamt = "20"
	//product_cost = 0.50

/obj/machinery/vending/drugs
	name = "StonerStyle Drug Vendor"
	desc = "Drugs! What else could you want?"
	icon_state = "seeds"
	product_paths = "/obj/item/weapon/reagent_containers/syringe/drugs;/obj/item/weapon/reagent_containers/psilocybin"
	product_amounts = "15;5"
	product_prices = "10;20"
	product_hidden = "/obj/item/weapon/reagent_containers/jenkem"
	product_hideamt = "5"
	//product_cost = 10
