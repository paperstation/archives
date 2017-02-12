/obj/item/paper/book
	name = "book"
	desc = "A book.  I wonder how many of these there are here, it's not like there would be a library on a space station or something."
	icon_state = "book0"
	item_state = "paper"
	layer = OBJ_LAYER
	//cogwerks - burn vars
	burn_point = 400
	burn_output = 1100
	burn_possible = 1
	health = 30
	//
	stamina_damage = 2
	stamina_cost = 2
	stamina_crit_chance = 0

	attack_self(mob/user as mob)
		return src.examine()

	attackby(obj/item/P as obj, mob/user as mob)
		src.add_fingerprint(user)
		return

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] attempts to cut \himself with the book. What an idiot!</b></span>")
		user.suiciding = 0
		return 1

/obj/item/paper/book/materials
	name = "Dummies guide to material science"
	desc = "An explanation of how to work materials and their properties."
	info = "The information in this piece of crap book is horribly outdated, making it useless. Let's hope centcom buys the new edition soon."
	/*
	info = {"
	<BIG><B>Materials</B></BIG>
	<br>
	<br>This book is meant to give you a brief overview and explanation of the materials, their properties and how to work them.
	<br>
	<br>
	<br><B>General information:</B>
	<br>
	<br>Under normal circumstances a material can only have one additive used on it - any further additives are lost.
	<br>However, there might be certain chemicals or materials that allow to work materials beyond this limit.
	<br>
	<br>Additives can have all kinds of effects on materials.
	<br>Some will change the stats of a material while others will give it special or unique effects.
	<br>
	<br>Some combinations of materials and/or additives might produce unique alloys / materials.
	<br>These fixed recipes and their resulting materials will usually have a special ability, use or just good stats.
	<br>
	<br>Different departments have different manufacturers, each with different recipes.
	<br>You might sometimes be able to find blueprints for manufacturers while exploring.
	<br>These blueprints will add a new item to the craftable objects of manufacturer when used on it.
	<br>
	<br>
	<br><B>Material properties:</B>
	<br>
	<br><B>Siemens coefficient:</B>
	<br>How well a material conducts electricity.
	<br>Values range from 0 = Non-conductive to 1 = Perfectly conductive.
	<br>
	<br>
	<br><B>Heat transfer coefficient:</B>
	<br>How well heat can transfer through a material - how insulating it is.
	<br>Values range from 0 = Perfect insulation to 1 = Heat transfers without loss.
	<br>A common spacesuit will have a value below/around 0.1.
	<br>
	<br>
	<br><B>Protective temperature:</B>
	<br>How high of a temperature this material can shield something from.
	<br>Higher is better.
	<br>
	<br>
	<br><B>Thermal conductivity:</B>
	<br>How well heat can transfer through this.
	<br>Only applies to walls and such. See Heat transfer coefficient
	<br>
	<br>
	<br><B>Heat capacity:</B>
	<br>(Honestly, who even knows anymore? This atmos code is a mess)
	<br>(Fairly sure this does SOMETHING)
	<br>
	<br>
	<br><B>Permeability coefficient:</B>
	<br>How well chemicals can penetrate this material.
	<br>Values range from 0 = Can not penetrate to 1 = Goes right through
	<br>
	<br>
	<br><B>Disease resistance:</B>
	<br>How well this material can shield a person from diseases.
	<br>Values range from 0 = No protection to 100 = Complete protection.
	<br>
	<br>
	<br><B>Melee Protection:</B>
	<br>How well this material will protect from melee attacks.
	<br>Reduces both damage and stamina damage. Higher is better.
	<br>
	<br>
	<br><B>Bullet Protection:</B>
	<br>How well this material will protect from bullets.
	<br>Bullet damage will be divided by this. Higher is better.
	<br>
	<br>
	<br><B>Explosion resistance:</B>
	<br>If applied to a wall or another solid object this
	<br>determines how well that object will shield objects behind it from an explosion.
	<br>Higher is better.
	<br>
	<br>
	<br><B>Explosion protection:</B>
	<br>How well this material will protect from explosions.
	<br>Reduces both severity and damage from explosions.
	<br>
	<br>
	<br><B>Radiation Protection:</B>
	<br>How well does this protects against radiation. More is better.
	<br>
	<br>
	<br><B>Magical:</B>
	<br>Does this material allow wizards to channel magic?
	<br>
	<br>
	<br><B>Value:</B>
	<br>How valuable this material is.
	<br>Higher is better.
	<br>
	<br>
	<br><B>Damage:</B>
	<br>How damaging this material is when used on items.
	<br>Higher is better.
	<br>
	<br>
	<br><B>Quality:</B>
	<br>Determines the quality of items made using this.
	<br>This can have many different effect but higher is always better.
	<br>
	<br>
	<br><B>Durability:</B>
	<br>How durable objects made from this are.
	<br>More durability means that the objects can take more damage.
	<br>
	<br>
	<br><B>Hardness:</B>
	<br>How hard objects made from this are.
	<br>Can have different effects depending on the object.
	<br>What value you want depends on the item.
	<br>
	<br>
	<br><B>Autoignition temperature:</B>
	<br>At which temperature this material will ignite.
	<br>
	<br>
	<br><B>Burn output:</B>
	<br>How much energy this material outputs while burning.
	<br>
	<br>
	<br><B>Instability:</B>
	<br>How likely it is that the material fails during manufacturing and possibly use. Higher is worse.
	<br>
	<br>
	"}
	*/

/obj/item/paper/book/mechanicbook
	name = "Mechanic components and you"
	desc = "A Book on how to use the wireless Components of the Mechanic's lab"
	info = {"
	<BIG><B>Quick-start Guide</B></BIG>
	<br>
	<br>To connect Components to each other you use drag and drop.
	<br>For this to work the components need to be secured into place by means of a Wrench.
	<br>You need to be holding a multi-Tool to be able to change Connections and Options of Components.
	<br>
	<br>A basic construction would look something like :
	<br><I>Wrench a Button Component into Place.</I>
	<br><I>Wrench a Graviton Accelerator into Place.</I>
	<br><I>Drag the Button onto the Accelerator and drop.</I>
	<br><I>Set the Button as Trigger.</I>
	<br><I>Select the only existing target input on the Accelerator.</I>
	<br>
	<br>Using the Button will now activate the Accelerator.
	<br>
	<br>You can see the Connections between Components when they are not covered by Tiles.
	<br>Just use a Crowbar to reveal the Plating and you'll be able to see what's connected to what.
	<br>
	<br>The Components can also be connected to some Machines and Gadgets around the Station.
	<br>You could try messing around with Doors or vending Machines.
	<br>If you want to connect two non-component objects together - say two Doors,
	<br>you will have to use a Component between the two Objects. Relays are easily used for this.
	<br>You would connect the Relay to Door 1 as Reciever and then connect the Relay to Door 2 as Trigger.
	<br>
	<br>Most Components offer additional Options in their right-Click Menu when you are standing right next to them.
	<br>These Options can range from Rotation to setting the output Signal and such Things.
	<br>
	<br><I>Information about the specific Components follows below.</I>
	<br>
	<hr>
	<br><BIG><B>Component specific Information</B></BIG>
	<br>
	<br><B>AND Component:</B>
	<br>Sends specified signal when both inputs recieve a Signal within a specified Time Frame.
	<br>
	<br>
	<br><B>Button:</B>
	<br>Sends set Signal when used.
	<br>
	<br>
	<br><B>Delay Component:</B>
	<br>Delays an incoming signal a certain amount of time before sending it to its connections.
	<br>
	<br>
	<br><B>Graviton Accelerator:</B>
	<br>Accelerates objects on it into a given direction for 3 seconds after being activated.
	<br>
	<br>
	<br><B>Gun Component:</B>
	<br>Shoots a Gun in the given Direction.
	<br>Needs to have a Gun installed before it can be used. Simply use the Gun on the Component.
	<br>
	<br>
	<br><B>E-Gun Component:</B>
	<br>Shoots a Gun in the given Direction.
	<br>Needs to have a Gun installed before it can be used. Simply use the Gun on the Component.
	<br>This Component only works for Energy based Guns with Power Cells in them.
	<br>Can recharge the Gun inside it at the Cost of temporarily deactivating itself.
	<br>Additionally, there is a short cooldown Period between Shots.
	<br>
	<br>
	<br><B>LED Component:</B>
	<br>Provides light when triggered.
	<br>The \"set rgb\" Input takes a Color in the HTML Color Code Format, for Example: #FF1200 .
	<br>
	<br>
	<br><B>Microphone Component:</B>
	<br>Forwards nearby speech as signal.
	<br>The "Toggle Show-Source" option determines whether the component adds the source's name to the signal or not.
	<br>
	<br>
	<br><B>OR Component:</B>
	<br>Sends a specified Signal when it recieves a specified Signal in one of its Inputs.
	<br>
	<br>
	<br><B>Pressure Sensor:</B>
	<br>Detects Pressure and dispatches Signal.
	<br>
	<br>
	<br><B>RegEx Find Component:</B>
	<br>Attempts to find an expression within a String. If found it can either forward the found String as Signal or send its own Signal.
	<br>The type of RegEx used is PCRE. Look-ahead or look-behind assertions are not supported.
	<br>
	<br>
	<br><B>RegEx Replace Component:</B>
	<br>Attempts to find an expression within a String and then replaces it. Forwards the modified String as Signal. Also has an Input that lets you set the Expression.
	<br>The type of RegEx used is PCRE. Look-ahead or look-behind assertions are not supported.
	<br>
	<br>
	<br><B>Relay Component:</B>
	<br>Forwards an input signal to another Target. If Signal changing is enabled, the Component will change the incoming Signal to its own before relaying it.
	<br>
	<br>
	<br><B>Selection Component:</B>
	<br>Holds a List of Signals that can be manipulated, browsed and sent.
	<br>Can be set to randomly select Items for sending or triggered to send a random Item once.
	<br>
	<br>
	<br><B>Signal Builder Component:</B>
	<br>Builds a String out of incoming Signals until it is triggered to send whats in the Buffer at which point the accumulated String will be sent and the Buffer cleared.
	<br>The starting/ending String Settings allow you to define a String that will be put at the Beginning or End of each String.
	<br>
	<br>
	<br><B>Signal Check Component:</B>
	<br>Sends either its own Signal or the input Signal when it recieves a Signal that has the set Trigger String in it somewhere.  Can be toggled to trigger when it does NOT find the specified string.
	<br>For Example: Trigger -> cat, Incoming Signal -> \"catswithhats\" -> the Component activates. This is not case-sensitive.
	<br>
	<br>
	<br><B>Sound Synthesizer:</B>
	<br>Speaks whatever Signal it recieves out loud. Rate-limited to 2 Seconds.
	<br>
	<br>
	<br><B>Teleport Component:</B>
	<br>To link Pads set the ID to the same string on both Pads. If there are more than 2 Pads with the same ID, Destinations will be picked at random.
	<br>Has an Input that allows a message to change the ID of the Pad and through that its Destination.
	<br>Individual Pads can be set to send only Mode - in this Mode they can not be the Target Location of other Pads with the same ID.
	<br>This is useful if you want to have several Pads teleport to one exit Pad.
	<br>
	<br>
	<br><B>Toggle Component:</B>
	<br>Can be turned on, off or be toggled. Outputs 2 different Signals depending on its new State - one for on and one for off.
	<br>Can also be triggered to just output the appropriate Signal without doing anything else.
	<br>
	<br>
	<br><B>Wifi Component:</B>
	<br>The "send radio message" Command accepts Messages in the Format of command=herp&data=derp which will then be sent on the set Frequency.
	<br>The Component can recieve a sendmsg Radio Signal that will send the Data in the \"data\" Portion of the Signal to the Outputs of this Component.
	<br>Following the previous Syntax a sendmsg Signal would look like this : address_1=WIFICompoAddHere&command=sendmsg&data=MyCompoCommand
	<br>Normal PDA Messages can also be used to trigger the Component.
	<br>The frequency can be changed wirelessly as well by using the setfreq Command : address_1=WIFICompoAddHere&command=setfreq&data=1419
	<br>If you enable the forward all option, the Component will forward any Radio Messages it recieves, unprocessed and in the above format, to its Outputs.
	<br>By disabling NetID filtering you can make the Component react to any and all Radio Messages on its frequency.
	<br>The Component will blink green when it recieves a wireless Message and blink red when it sends a wireless Message."
	<br>
	<br>
	<br><B>Wifi Signal Splitter Component:</B>
	<br>Returns the value of a field within a Radio signal. The components Trigger Field is the Field you want the Value of.
	<br>For example: Set the Trigger Field to \"user_id\". When a Signal with \"user_id=captain\" arrives the Component forwards \"captain\"
	"}

/obj/item/paper/book/cookbook
	name = "To Serve Man"
	desc = "A culinary guide on how to best serve man"
	info = {"<h1>To Serve Man</h1>
	<p><i>Disclaimer: At the time of writing, all information in this book is correct. However, over time, the information may become out of date.</i></p>
	<p><i>It is also important to remember that every oven works differently and the cooking times for these recipes might not be optimal.</i></p>
	<hr>
	<p>This is meant as a basic guide for cooking with some common recipes. However, if you want to become a true chef, you must willing to experiment and try new things.
	Only someone who is not afraid of failure can become a master chef!</p>
	<hr>
	<h2>Burger</h2>
	<h3>Ingredients</h3>
	<div class = "burger">
	<li>1-3 Pieces of Meat
	<li>1 Dough
	</div>
	<div class ="burgersteps">
	<li>Cook the ingredients in the oven for 6 seconds on high
	</div>

	<hr>
	<h2>Cake Batter</h2>
	<h3>Ingredients</h3>
	<div class = "cakebatter">
	<li>1 Sweet Dough
	<li>2 Eggs
	</div>
	<h3>Steps</h3>
	<div class = "cakebattersteps">
	<li>Mix the ingredients together
	</div>

	<hr>
	<h2>Cake</h2>
	<h3>Ingredients</h3>
	<div class = "cake">
	<li>1 Cake Batter
	<li>1 Food Item of Your Choice
	<li>Icing Tube Full of a Reagent of Your Choice
	</div>
	<h3>Steps</h3>
	<div class = "cakesteps">
	<li>Mix the first two ingredients together (Use the mixer)
	<li>Cook the cake in the oven for 9 seconds on low.
	<li>Use the icing tube on the cake.
	<li>Cut the cake.
	</div>

	<hr>
	<h2>Cream of Mushroom</h2>
	<h3>Ingredients</h3>
	<div class = "creamofmush">
	<li>1 Mushroom
	<li>1 Milk
	</div>
	<h3>Steps</h3>
	<div class = "creamofmushsteps">
	<li> Mix the ingredients together
	<li>Cook the ingredients in the oven for 7 seconds on low
	</div>

	<hr>
	<h2>Donut</h2>
	<h3>Ingredients</h3>
	<div class = "donut">
	<li>1 Dough
	<li>1 Flour
	</div>
	<h3>Steps</h3>
	<div class = "donutsteps">
	<li>Cook the ingredients in the oven for 3 seconds on low
	</div>

	<hr>
	<h2>Dough</h2>
	<h3>Ingredients</h3>
	<div class = "dough">
	<li>1 Flour
	</div>
	<h3>Steps</h3>
	<div class = "doughsteps">
	<li>Add water to the flour via a sink
	</div>

	<hr>
	<h2>Mashed Potatoes</h2>
	<h3>Ingredients</h3>
	<div class = "mash">
	<li>3 Potatoes
	</div>
	<h3>Steps</h3>
	<div class = "mashsteps">
	<li>Mash the potatoes in the mixer until at desired consistency.
	</div>

	<hr>
	<h2>Omelette</h2>
	<h3>Ingredients</h3>
	<div class = "omelette">
	<li>2 Eggs
	<li>1 Piece of Meat
	<li>1 Cheese
	</div>
	<h3>Steps</h3>
	<div class = "omelettesteps">
	<li>Cook the Omelette in the oven for 7 seconds on high
	</div>

	<hr>
	<h2>Pancakes</h2>
	<h3>Ingredients</h3>
	<li>2 Eggs
	<li>1 Milk
	<li>1 Sweet Dough
	</div>
	<h3>Steps</h3>
	<div class ="pancakesteps">
	<li>Mix the ingredients together
	<li>Cook the batter in the oven for 4 seconds on high
	</div>

	<hr>
	<h2>Pizza</h2>
	<h3>Ingredients</h3>
	<div class = "pizza">
	<li>1 Dough
	<li>1 Ketchup
	<li>1 Cheese
	<li>Topping of your choice (Optional)
	</div>
	<h3>Steps</h3>
	<div class = "pizzasteps">
	<li>Roll out the dough with a rolling pin
	<li>Apply ketchup to the Pizza
	<li>Sprinkle cheese on the pizza
	<li>Apply the topping of your choice to the pizza
	<li>Cook the pizza in the oven for 9 seconds on high
	</div>

	<hr>
	<h2>Meatpaste</h2>
	<h3>Ingredients</h3>
	<div class = "meatpaste">
	<li>1 Piece of Meat
	</div>
	<h3>Steps</h3>
	<div class = "meatpastesteps">
	<li>Mix the meat in the mixer
	</div>

	<hr>
	<h2>Wontons</h2>
	<h3>Ingredients</h3>
	<div class = "wontons">
	<li> 1 Egg
	<li> 1 Package Flour
	</div>
	<h3>Steps</h3>
	<div class = "wontonssteps">
	<li>Mix egg and flour together
	<li>Place filling of choice into wrapper and wrap
	<li>Place wrapped wonton into deep fryer, fry until fully cooked
	</div>

	<hr>
	<h2>Steak</h2>
	<div class = "steak">
	<li>1 Piece of Meat
	</div>
	<h3>Steps</h3>
	<div class = "steaksteps">
	<li>Cook the meat in the oven for 9 seconds on low
	</div>

	<hr>
	<h2>Sloppy Joe</h2>
	<h3>Ingredients</h3>
	<div class = "sloppy">
	<li>1 Meatpaste
	<li>1 Dough
	</div>
	<h3>Steps</h3>
	<div class = "sloppysteps">
	<li>Cook the ingredients in the oven for 8 seconds on high
	</div>

	<hr>
	<h2>Sweet Dough</h2>
	<h3>Ingredients</h3>
	<div class = "sweetdough">
	<li>1 Dough
	<li>1 Sugar
	</div>
	<h3>Steps</h3>
	<div class = "sweetdoughsteps">
	<li>Knead the sugar and dough together with your hands.
	</div>

	<h3>
	<h2>Nougat Bar</h2>
	<h3>Ingredients</h3>
	<div class = "nougatbar">
	<li>1 Honey Blob
	<li>1 Sugar
	</div>
	<h3>Steps</h3>
	<div class = "nougatbarsteps">
	<li>Cook the ingredients in the oven for 5 seconds on low.
	</div>

	<h3>
	<h2>Granola Bar</h2>
	<h3>Ingredients</h3>
	<div class = "granolabar">
	<li>1 Honey Blob
	<li>1 Oatmeal
	</div>
	<h3>Steps</h3>
	<div class = "granolabarsteps">
	<li>Cook the ingredients in the oven for 5 seconds on low.
	</div>
	"}

/obj/item/paper/book/monster_manual
	name = "Creature Conspectus"
	desc = "A large book detailing many creatures of myth and legend. Nerds."
	icon_state = "book3"

	info = {"
	<b>Agent</b>, syndicate
	<br>
	<br>Frequency: Rare
	<br>NO. Appearing: 1-5
	<br>Armor Class: 5
	<br>Move: 5"
	<br>Hit Dice: 1 + 1
	<br>% in Lair: 0%
	<br>Treasure Type: See below
	<br>NO. of Attacks: 1
	<br>Damage/Attack: 4-8
	<br>Special Attacks: Casts Fireball on death.
	<br>Special Defenses: Nil
	<br>Void Resistance: Variable (See below)
	<br>Intelligence: Average
	<br>Alignment: Lawful Maladjusted
	<br>Size: M
	<br>Psionic Ability: Telepathic communication with other Agents.
	<hr>
	<b>Greysuit</b>, armored
	<br>
	<br>Frequency: Uncommon
	<br>NO. Appearing: 1-3
	<br>Armor Class: 6
	<br>Move: 5"
	<br>Hit Dice: 1 + 1
	<br>% in Lair: 0%
	<br>Treasure Type: See below
	<br>NO. of Attacks: 1
	<br>Damage/Attack: 4-8
	<br>Special Attacks: 50% likely to adminhelp
	<br>Special Defenses: Nil
	<br>Void Resistance: Nil
	<br>Intelligence: Low
	<br>Alignment: Chaotic Maladjusted
	<br>Size: M
	<br>Psionic Ability: Nil
	<p>This lesser humanoid, native to the deepest caverns of Maynnetince, is a variant of the common greysuit exhibiting a series of peculiar
	defensive mutations.  Firstly, the torso of the creature is a encased in a thick hide of a notably darker hue than that of an ordinary greysuit.
	Secondly, the head of the beast differs significantly from their unarmored brethren, with a large done of protective grey bone encasing much of the skull.
	The armored greysuit's eyes also receive a limited degree of protection from a translucent manner of tertiary eyelid attached directly to the skull case.
	The true danger of the armored greysuit, however, comes from its choice of weapon: many (65% chance) wield a fearsome shockmace into combat.<br>
	The corpse of this fiend may yield its namesake armor (For details, see pg 289).</p>
	<hr>
"}

/obj/item/diary
	name = "Beepsky's private journal"
	icon = 'icons/obj/writing.dmi'
	icon_state = "book0"
	item_state = "paper"
	layer = OBJ_LAYER

	examine()
		set src in view()
		if (!issilicon(usr))
			boutput(usr, "What...what is this? It's written entirely in barcodes or something, cripes. You can't make out ANY of this.")
			var/mob/living/carbon/jerk = usr
			if (!istype(jerk))
				return

			for(var/datum/data/record/R in data_core.general)
				if(R.fields["name"] == jerk.real_name)
					for (var/datum/data/record/S in data_core.security)
						if (S.fields["id"] == R.fields["id"])
							S.fields["criminal"] = "*Arrest*"
							S.fields["mi_crim"] = "Reading highly-confidential private information."

			return

		else
			boutput(usr, "It appears to be heavily encrypted information.")

/obj/item/storage/photo_album/beepsky
	name = "Beepsky's photo album"

	New()
		..()
		new /obj/item/photo/beepsky1(src)
		new /obj/item/photo/beepsky2(src)

		var/endi = rand(1,3)
		for (var/i = 0, i < endi, i++)
			var/obj/item/photo/P = new /obj/item/photo/beepsky2(src)
			switch(i)
				if (0)
					P.name = "another [P.name]"
				if (1)
					P.name = "yet another [P.name]"
				if (2)
					P.name = "an additional [P.name]"
					P.desc = "Beepsky is fucking weird."

/obj/item/photo/beepsky1
	name = "photo of a securitron and some objects"
	desc = "You can see a securitron on the photo.  Looks like an older model.  It appears to be holding a \"#1 Dad\" mug.  Is...is that moustache?"
	icon_state = "photo-beepsky1"

/obj/item/photo/beepsky2
	name = "photo of the handcuffs"
	desc = "You can see handcuffs in this photo.  Just handcuffs.  By themselves."
	icon_state = "photo-beepsky2"

/obj/item/photo/heisenbee
	name = "Heisenbee baby photo"
	desc = "Heisenbee as a wee larva.  Heisenbee was a little premature.  Or is that BEEmature???  HA Ha haa..."
	icon_state = "photo-heisenbee"

/obj/item/paper/book/dwainedummies
	name = "DWAINE for Dummies"
	icon_state = "book4"
	info = {"<html>
<head>
<style type="text/css">
div.code
{
padding:5px;
border:1px solid black;
margin:1px;
font-family:"courier";
font-size:12px;
background-color:lightgray;
}
div.tips
{
padding:10px;
border:5px solid gray;
margin:0px;
font-family:"Arial";
font-size:12px;
font-weight:bold;
}
body
{
color:black;
background-color:white;
}
h1
{
font-family:"Arial Black";
text-align:center;
font-size:24px;
font-weight:bold;
}
h2
{
font-family:"Arial Black";
text-align:left;
font-size:18px;
}
p
{
font-family:"Arial";
font-size:14px;
}
</style>
</head>

<body>

<h1>DWAINE for Dummies!</h1>
<p><i>Disclaimer: At the time of writing, all information in this book is correct. However, over time, the information may become out of date.<br>
Point your browser to <a href=http://wiki.ss13.co/TermOS>http://wiki.ss13.co/TermOS</a> if anything seems amiss.</i>
<h2>Introduction</h2>
<p>If you're reading this book, it is likely that you have bought a DWAINE System Vi mainframe - but have no idea how to use it! Luckily for you, this book is here to teach you the basics.</p>

<h2>How to Use this Book</h2>
<p>First off, for some bizarre reason you need to know how a book works.
Basically it's this thing with two covers and words inside. You open it and read
the words.<br>
Sometimes in the middle of the words there are pictures, but not in this book.
Pictures are for losers and babies.</p>
<p>Now and again I'll give you advanced tips, which will appear in boxes like this one:
<div class="tips">
<li>Words are great!</div>
<p>And when I need to write code, it will appear in boxes like this:</p>
<div class="code">$: ls /butts</div>
<br><br>
<h2>Chapter 1: The Terminal</h2>
<p>Operating a DWAINE mainframe is done solely through a terminal interface - graphics and icons and things are unnecessary and also are for tiny children with no understanding of REAL COMPUTERS.</p>
<p>So, let's get started! After logging in, you will be presented with a prompt - usually following this format:</p>
<div class="code">
]GMelons@DWAINE - 12:00 03/04/52
</div>
<p>When you type in text and push the Enter key, you will notice your command is sent like this:</P>
<div class="code">
>things i typed
</div>
<p>This book will show commands you should enter as beginning with <i>">"</i>.
<div class="tips">
<li> Remember! The most important command is <i>"help"!</i>
</div>
<br><br>
<h2>Chapter 1: Logging On</h2>
<p>Before we can do anything, we need to log onto the network. This guide assumes you aren't already synched to your DWAINE mainframe.<br>
Insert your ID into the ID card slot of your terminal.<br>
Then, type
<div class="code">
>term_ping
</div>
<p>and push enter to get a list of networked devices. Find the device labeled PNET_MAINFRAME and take a note of its net_id.
<br>
Then, type
<div class="code">
>connect 0200xxxx
</div>
<p>where 0200xxxx is the term_id of the PNET_MAINFRAME.<br>
Then, with your ID inserted, simply type
<div class="code">
>term_login
</div>
<p> to log into the system.
<div class="tips">
<li> When logged in, you can log off by typing <i>"logout" OR "logoff"</i>.
<li> You can disconnect by typing <i>"disconnect"</i>.
<li> You can restart by typing <i>"restart"</i>.
</div>
<h2>Chapter 2: Basic Concepts</h2>
<p>
The first thing you need to know about DWAINE is the Filesystem.<br>
There are no drives in DWAINE, no specific devices. Everything is a folder in DWAINE.
</p><p>
The structure works like a tree, with everything starting at the "root" folder,
and expanding outwards from there. A typical file path in DWAINE would look like
this:<br>
<div class="code">
/home/GMelons/Pictures/pr0n_jpg
</div><p>
You might be wondering what the name of the root folder is, since it doesn't
seem to be immediately obvious in that filepath. The system root is referred to
as <i>"/"</i>. So, if we expand this path, we get this:
<div class="code"><pre>/
	home/
		GMelons/
			Pictures/
				pr0n_jpg
				butt_png
			Music/
				fart_ogg
		JGrife/
			Documents/</pre>
</div>
<p>
So, if we wanted to listen to something, we would use this path:<br>
<div class="code">
/home/GMelons/Music/fart_ogg
</div>
<p>
Simple, right? Well.
</p>
<br>
<h2>Chapter 3: Simple Commands</h2>
<p>First, let's discuss listing directories.<br>
You can find out what is in the current directory by typing
<div class="code">
>ls</div>
<p> and hitting Enter.<br>
This will show you a list of files and directories inside the folder!<br>
You can also give <i>ls</i> a directory path to look at instead: so if you wanted to snoop on JGrife's stuff, you would type:
<div class="code">
>ls /home/JGrife
</div>
<div class="tips">
<li> Sometimes you won't be able to look at files in a directory! See Chapter 6 for details!
<li> Additionally there may be hidden directories on the system, which contain special system files!</div>
<p>
Now, let's discuss changing directories.<br>
To change which directory you are in, just type
<div class="code">
>cd
</div>
<p>
followed by the path you want to change to.<br>
<p>
So, let's say we want to go to our Pictures directory.
<div class="code">
>cd /home/GMelons/Pictures
</div>
<p>
And here we are! If you want to move one space up the file path, back to
GMelons, you would write
<div class="code">
>cd ..
</div>
<p>
instead. Note that using ".." as a file path works with other commands too.<br>
If you were in GMelons and you wanted to go to Pictures, you could also
just type
<div class="code">
>cd Pictures
</div>
<p>
and you would go there.
<br>
<br>
Next, let's try copying files around!<br>
The copy command is:
<div class="code">
>cp
</div>
<p>
Followed by the original file, and then the destination. Pour éxample:
<div class="code">
>cp /home/GMelons/Pictures/butt_png /home/JGrife/Documents
</div>
<p>
This would copy the file "butt_png" to /home/JGrife/Documents.<br>
However, you can copy and give the destination file a new name, like this:
<div class="code">
cp /home/GMelons/Pictures/butt_png /home/JGrife/Documents/importantfile_txt
</div>
<p>
So now, JGrife sees he has an important file to open! OH NO! Butt!<br>
<br>
Okay, let's discuss moving files now.<br>
The move command is:
<div class="code">
>mv
</div>
<p>
Followed by the original file, and then the destination - exactly like copy,
except the original is moved from one location to the other. Good for stealing
data, like nuclear authentication codes! Or, uh. Cute pictures of duckies.
<br>
<br>
<h2>Reading, Writing, and Deleting</h2>
<p>
"But HOW DO I MAKE FILES OR SEE WHAT'S IN THEM AAAA"<br>
 <br>
Stop that! Stop it! Stop!<br>
You're a bad person.<br>
<br>
To read the contents of a file, use:
<div class="code">
>cat
</div>
<p>
Followed by the path to the file. Here we go!
<div class="code">
>cat /home/JGrife/secret_stuff
I like to read trashy romance novels!!!
</div>
<div class="tips">
<li> Not all files can be read - some do not contain text, but are actually programs!
<li> Run these by typing their name in the terminal.
<li> Programs on a Research Station are usually kept in <i>/mnt/control</i> - the location of the control database.</div>
<p>
What a shocker, eh?
<br>
Writing files is a little bit different. At the time of writing this guide,
no text editor existed for DWAINE so we have to make do with the
<div class="code">
>echo
</div>
<p>
command.<br>
Echo just repeats whatever you type after it back to you. That sounds useless,
right?<br>
Well, there's a little thing called <i>"output redirection"</i>. This means we can take
what comes out of a command and put it somewhere else. Here's an example:
<div class="code">
>echo I like big smelly butts! ^/home/JGrife/my_secrets
</div>
<p>
What this will do is write the text "I like big smelly butts!" into a file called "my_secrets" in JGrife's folder. The redirection is done with the
<div class="code">
>^
</div>
<p>
symbol. Anything immediately after the symbol is where the output
from echo will go.
<br>
Hooray! Hmm, we might need to organise our things better. How about we make
a new folder?
<div class="code">
>mkdir name_of_folder
</div>
<p>
Will do it! Just navigate to where you want the new folder to be, and use mkdir
with the name of the new folder and it shall appear.
<br>
To delete a file, use the
<div class="code">
>rm
</div>
<p>
command.
<div class="tips">
<li> Remember that every command has an associated help entry!
<li> Type <i>"help rm"</i> for advanced help on deleting files.</div>
<br><br>
<h2>Printing & Backups</h2>
<p>
Let's take a moment to go over devices in DWAINE.<br>
There is no "print" function in DWAINE. Why? Because DWAINE stores devices as
folders, using drivers to communicate with them. Storage drives and printers
appear in the <i>/mnt</i> folder in DWAINE.
<br>
So, let's say we want to print off JGrife's embarrasing secrets and share them
around the Research Sector - how do we do that?
<br>
Well, DWAINE's default printer driver works like this: if you move or copy a
file into the printer's folder, the printer reads the file and prints it off.
Pretty simple, really!
<div class="code">
>cp /home/JGrife/secret_stuff /mnt/printer_name
</div>
<p>
And out it comes! Printer names are usually prefixed with "lp-" by the way, so
that you know they are printers and not storage drives.
<br>
To copy a file to a storage drive, simply do the following:
<div class="code">
>cp /home/GMelons/Pictures/pr0n_jpg /mnt/drive_name
</div>
<p>
Easy!
<br><br>
<h2>Chapter 6: Advanced Usage</h2>
<p>
Sometimes you want to stop people looking at your files. Nobody likes a snooper!
<br>
To protect your files, you will want to use the
<div class="code">
>chmod
</div>
<p>
command.
<br>
Usage of the chmod command is complicated: chmod takes an Octal number as its
second parameter, usually formatted as a 3-digit number.
<div class="code">
>chmod 777 file_name
</div>
<p>
For an example.
<br>
The number means this:
The first digit sets what kind of access the Owner of the file has.
<br>
The second digit sets what kind of access the Group that the owner belongs to
has.
<br>
The third digit sets what kind of access everybody else has.
<br>
Access digits are as follows:<br>
<div class="tips">
<li>7 - Full Access
<li>6 - Read and Write
<li>5 - Read and Modify
<li>4 - Read Only
<li>3 - Write and Modify
<li>2 - Write Only
<li>1 - Modify Only
<li>0 - None
</div>
<p>
So, to prevent absolutely anyone except yourself from reading your files, use
<div class="code">
>chmod 700 file_name
</div>
<p>
You'll get the hang of it.<br>
Of course, an alternate method presents itself: make that file hidden!<br>
To make a file hidden, simply make its name begin with an underscore "_".
<div class="code">
>mv mysecret _mysecret
</div>
<p>
To see hidden files, you must use <i>"-l"</i> (not -1) when giving the ls command:
<div class="code">
>ls -l /path
</div>
<p>
ls -l will also show you the read,write,execute(run) status of each file, along
with the owner.

What if you want to change who owns a file?
<br>
Simple! Use the chown command.
<div class="code">
>chown user_name file
</div>
<p>
The specified user now owns that file.
<br>
That's it folks! That's the end of this book! Captains, Research Directors, all honest members of Nanotrasen crew, do not turn the next page!<br>
It is terribly boring and does not contain any useful information whatsoever!
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

Still reading? Good. I'm a member of the syndicate, and I'm here to teach you how to steal data.<br>
<div class="code">
>su -
</div>
<p>
Will elevate your priveleges to administrator level. This will let you use the <i>ls</i> command in the root directory to view hidden system files and folders.<br>
It's possible to steal things like login credentials and session keys, enabling you to gain access as another user even if you're not authorized - and frame them for theft. <br>
Unfortunately, the <i>su</i> command requires an administrator-level ID card. But this should not prove a challenge to a fellow agent.<br>
<br>
STEAL DATA. STEAL DATA. STEAL DATA.

<div class="tips">
<li> Good luck!</div>


</body>
</html>

"}

//todo-finish this
/obj/item/paper/book/guardbot_guide
	name = "The Buddy Book"
	icon_state = "book5"

	info = {"
<html>
<head>
<style type="text/css">
div.code
{
padding:5px;
border:1px solid black;
margin:1px;
font-family:"courier";
font-size:12px;
background-color:lightgray;
}
body
{
color:black;
background-color:white;
}
h1
{
font-family:"Arial Black";
text-align:center;
font-size:24px;
font-weight:bold;
}
h2
{
font-family:"Arial Black";
text-align:left;
font-size:18px;
}
p
{
font-family:"Arial";
font-size:14px;
}
</style>
</head>

<body>
<h1>The Robuddy Book</h1>

<h2>Introduction</h2>
<p>Since their introduction twenty years ago, the PR (For Personal Robot) Robuddy series has grown to become the most popular robotics platform produced by Thinktronic Data Systems.
The Model 6 is the most recent version at the time of this writing, largely acting as a refinement of the PR-5.  The PR-6 has a number of submodels, covering fields ranging from medical care (The PR-6RN), security (PR-6S), and engineering (PR-6E) </p>
<h2>Charge Dock</h2>
<p>Though it features the longest standard battery life of all Robuddy models, the PR-6 still requires a periodic recharge in the provided docking station.
The dock serves as more than just a battery charger, however: It is also allows new software (Tasks) to be uploaded, or the unit's current task software to be cleared.</p>
<h2>Tasks</h2>
<ul>
<li><b>GUARD:</b> This will direct the Robuddy to serve as a trusty bodyguard, exacting buddy-vengence on anyone attempting to harm their charge.</li>
<li><b>SYNC:</b> The sync task is employed when the Robuddy has been instructed to connect to a charge dock.  It directs the unit through radio identification of a free dock and then guides it there.</li>
<li><b>SECURE:</b> In this mode, the Robuddy will remain stationary and scan its surrounding environment for hostile agents, based on the same criteria as the "Securitron" series.</li>
<li><b>PATROL:</b> Identical to the Secure task, with one exception: The Robuddy will patrol a set path based on navigational radio beacons.</li>
</ul>
<h2>Buddy Configuration</h2>
<p>As previously stated, the PR-6 is configured and programmed through its charge dock, which is itself typically controlled by a networked Thinktronic mainframe running the DWAINE operating system.
"PRMAN" control software, with accompanying control driver and support scripts, is supplied with a standard Robuddy installation.
PRMAN requires system operator privileges to operate, which may be granted through use of the "su" command.
</p>
For example, if the provided tape was mounted at the default databank "control"
<div class="code">
cd /mnt/control<br>
su<br>
prman list
</div>
This would list all connected units by the 8-digit system IDs of their current docks.

<p><b>Checking a Robuddy's Status:</b><br>
PRMAN's "stat" command will list the current task, equipment, and charge information for a Robuddy. To check a Robuddy with example ID 02001122:
<div class="code">
prman stat 02001122
</div>
</p>

<p><b>Bodyguarding:</b><br>
If it was desired to program a buddy with ID "02001122" to guard someone named (As stated on their company ID) "Dr. Roger Tuppkins," the provided guard script could be employed in this manner:
<div class="code">
guard_script 02001122 drrogertuppkins
</div>
If successful, a message will appear indicating that the unit has been deployed.
</p>
<p><b>Patrolling:</b><br>
Use of the included patrol script is also straightforward:
<div class="code">
patrol_script 02001122
</div>
This would wake the unit and send them trundling off to patrol their environment.
</p>
<p><b>Waking and Recalling Robuddies:</b><br>
Waking a docked Robuddy is very simple.
<div class="code">
prman wake 02001122
</div>
PRMAN is also able to recall deployed buddies to docks, though not necessarily the same dock they initially deployed from.
Both the ID of the buddy itself and that of its last dock (Provided no other buddies have since used it) may be used.
<div class="code">
prman recall 02001122
</div>
Units may be recalled en masse by using "all" in place of the ID
<div class="code">
prman recall all
</div>
</p>
</body>
</html>
"}

/obj/item/paper/book/hydroponicsguide
	name = "The Helpful Hydroponics Handbook"
	icon_state = "book3"
	info = {"<html>
<head>
<style type="text/css">
div.code
{
padding:5px;
border:1px solid black;
margin:1px;
font-family:"courier";
font-size:12px;
background-color:lightgray;
}
div.tips
{
padding:10px;
border:5px solid gray;
margin:0px;
font-family:"Arial";
font-size:12px;
font-weight:bold;
}
body
{
color:black;
background-color:white;
}
h1
{
font-family:"Arial Black";
text-align:center;
font-size:24px;
font-weight:bold;
}
h2
{
font-family:"Arial Black";
text-align:left;
font-size:18px;
}
p
{
font-family:"Arial";
font-size:14px;
}
</style>
</head>

<body>

<h1>The Helpful Hydroponics Handbook</h1>
<p><i>Disclaimer: At the time of writing, all information in this book is correct. However, over time, the information may become out of date.<br>
<h2>Introduction</h2>
<p>Hello! Do you have QUESTIONS about PROBLEMS? Are those problems of a gardening and plants nature? Well boy howdy is this the book for you! It's time to put an end to those plant woes!</p>

<h2>The Target Demographic</h2>
<p>Obviously, this book is targeted mainly at Botanists, Gardeners and other plant-growing folks.<br>
Of course if you are not one of these people there's no reason you can't try your hand anyway!
Gardening is awesome, easy and fun! I hope you like the smell of dirt!</p>
<p>If you're already an experienced gardener, keep an eye out for advanced tips, which look like this:
<div class="tips">
<li>This is a tip! Get the hint?</div>
<br><br>
<h2>Chapter 1: Basic Gardening</h2>
<p>So, you've got an empty Hydroponics tray, some seeds and a burning desire to grow some goddamn plants. The next step should be obvious: Plant that seed in the tray!</p>
<p>If you're using one of the standard issue Hydroponics growing trays, the plant should begin to grow almost immediatley. Most issues with the plant will be taken care of automatically by the tray.</p>
<p>However, you will need to ensure that the tray is kept filled with water - but not too much! Apart from this, simply tend to the plant until it becomes ready to harvest, as will be indicated by a green light.</p>
<p>Now, I know what you're thinking. "It can't be that simple, surely!" Well you're wrong! If all you want to do is simply plant, grow and harvest, this is literally all you need to do. Even a prehistoric hunter-gatherer can do it!</p>
<p>However, there are other things you can do to ensure a much better harvest and gardening experience. For example, you can add compost and other nutrients to the plant's solution to ensure the plant becomes and stays very healthy.</p>
<p>A healthy plant is a happy plant, and a happy plant will grow more viable produce!</p>
<p>Also, consider regularly checking the plant by hand - this will alert you to any issues with the tray or the plant that require correction.</p>
<div class="tips">
<li> Keep an eye on the LED displays on your Hydroponics tray. Green means a harvest is ready, Red means the plant is in poor condition. The bar on the side shows you how much water you have - aim for green!
<li> If trays are kept empty, eventually strange weeds may start to grow in them. Even keeping a dead plant in a tray will prevent weeds! Some weeds can be rather bad to have around!
</div>
<br><br>
<h2>Chapter 2: Tools of the Trade</h2>
<p>Well, now you know how to grow a plant and harvest it all well and good. You may find yourself asking however, what do I use to go about doing this?! What is all the stuff in here!? Slow down junior. We'll get to that.</p>
<p>A good Botanist is provided with many different tools to perform their work. Most likely, you'll be able to find an assortment of these tools in either a supplied set of lockers, or in a hydroponics tool vending machine.</p>
<p>First of all, we have the humble and iconic Watering Can. A symbol for any gardener! Standard watering cans can hold quite a lot of reagents, but you'll mostly just want to keep water in it. Most often botanists will be supplied with a high-capacity water tank.</p>
<p>The water tank holds a LOT of water inside - just attach the Watering Can to the spigot, give it a turn, and you'll have a lot of water to feed your plants! The tank will automatically fill the can as full as it can get, so don't worry about spills.</p>
<p>Bags of Compost are another item that should be used often and well. These familiar old brown bags contain a lot of nutritious mulch that will make your plants healthy. Specifics will be covered later.</p>
<p>There is also the trusty green and brown Compost Bin! This device not only stores quite a lot of compost mulch for refilling your bags, but it can also convert any unwanted produce into more mulch! Just place the produce inside and the process is automatic.</p>
<p>A good Botanist is also advised to make a lot of use of Produce Satchels. These handy little bags can hold a lot of food, plants, and seeds. Anything that's related to hydroponics and/or cooking can go in one of these bags! They hold a lot of stuff!</p>
<p>Sometimes though, there's times where plants decide to be a pain. Getting annoyed at Creepers killing your plants? Radweed giving you a nasty case of poisoning? This is where you'll want to use your trusty Chainsaw! Just hack up the plant and it's as good as gone!</p>
<p>If the Chainsaw doesn't work, try Weedkiller. Weedkiller solution has an extremely toxic effect on undesirable weed-like plants, while being completely harmless to regular plants. This is especially good against pesky Lasher plants!</p>
<p>The Plant Analyzer isn't neccessary if you're just doing basic planting and harvesting, but it's a must-have if you want to get into botanical genetic engineering. This will be covered in a later chapter.</p>
<p>The Seed Fabricator is the large, vending machine-like object that you can't take with you (unless you want to be crushed I guess), but it's vital - without it, you wouldn't be able to get any plant seeds! Any seeds obtained from this will have a completely clean genetic slate, also.</p>
<p>The Reagent Extractor accepts various produce, and extracts valuable reagents from them. This is especially important if you want to farm herbs!</p>
<p>Finally, we have the PlantMaster Mk3 plant genetics manipulator, seed extractor and seed infuser! This is the piece de resistance if you want to engage in genetic engineering - but that's a complicated subject we'll tackle later!</p>
<div class="tips">
<li> Other common objects can come in handy, too. Beakers can be inserted in the Reagent Extractor and PlantMaster, and screwdrivers can be used to bolt down trays so they don't get knocked around.
</div>
<h2>Chapter 3: Nutrient Solutions</h2>
<p>So, now we know the basics of plant maintenance, growing, and harvesting. What can we do to become better at our craft?</p>
<p>As was mentioned before, adding nutrients and other additives to the soil is a good idea - they encourage growth and good health in your plants, which is better for your harvests.</p>
<p>However, there are many different kinds of additives, some good and some bad. Obviously adding bad things like toxins or chlorine to the soil won't do you much good at all!</p>
<p>So what can we add? Most Botanists are equipped by standard with compost bags and weedkiller bottles. Weedkiller is harmless to normal plants, but will destroy undesirable plants such as Creepers or Lashers.</p>
<p>Compost is a very basic additive which will slowly make a plant healthier as it absorbs the nutrients. There are no drawbacks - however, it is not very quick or efficient! Ammonia, if available, will have a similar effect to compost.</p>
<p>Phosphorus and Diethylamine, if available, will encourage the plant to grow quicker by offering more stimulating nutrients. Again however, they are not the most efficient of additives.</p>
<p>There exist other additive solutions - they are very efficient, but often come with drawbacks. Unfortunately, the recipes for these are closely guarded formulas. All we can tell you is that they all use plant nutrients as a base!</p>
<p>Due to the high availability of these additives however, Botanists are often supplied with one or two bottles of each. After that, it is up to the botanist to experiment with chemistry and see if they can find how to make more!</p>
<div class="tips">
<li> Mutagenic Formula encourages the plant to mutate wildly. However, it does cause some damage to the plant as well as stunted growth.
<li> Ammonia encourages very rapid plant growth, but will cause the tray to dry out much faster than usual.
<li> Potash encourages large harvests. However, it has been known to shorten the plant's lifespan.
<li> Saltpetre can help create much more potent produce, but it can result in smaller crop yields.
<li> Mutadone Formula is a healthy plant solution that aims to rectify genetic problems. Sadly, plant growth will be slowed to near-zero while it is present in the solution.
</div>
<h2>Chapter 4: Gladly Grow Genetically Great Goods</h2>
<p>So, you're finally rolling in the brassicas, huh? Growing large batches of well-tended and healthy crops, supplying everyone with more food and medicine than they can possibly eat. This is the life, huh?</p>
<p>What if I told you there's more. That's right! You've only glimpsed a tiny bit of the potential inherent in Hydroponics! Through manipulating the genes of plants, you can create new strains of plant that live longer, produce more, produce better, and ARE better for everyone!</p>
<p>I'm sure you're just jonesing to sign up for some mad science. Well you're in luck! Remember the Plant Analyzer and PlantMaster Mk3 mentioned back in chapter two of this handbook? This is where those two tools come in - your gateway to genetic engineering!</p>
<p>Plant Analyzers can be used on growing plants, fruit, and seeds. When used, the analyzer will give a readout of every useful gene in the plant's genetic structure, as well as detailing the plant's species and a few other things.</p>
<p>Maturation Rate is the gene that influences how long a plant takes to grow from a small sapling into an adult plant. With this gene, a lower readout is better as it means a quicker growth cycle.</p>
<p>Production Rate is the gene dealing with how long it takes an adult plant to produce viable crops. Again, lower is better. Essentially, every time a plant is harvested it is returned to the beginning of the adult stage of its growth cycle -
 a plant could take a long time to grow but produce new batches of crop relatively quickly between harvests thanks to this gene.</p>
<p>The Lifespan gene differs somewhat in function between fruits and other plants. In fruits, it controls how many harvests a plant can produce before it will die. In other plants it is not quite as useful, but still important - the gene controls how healthy a plant will generally be
when it is first planted. A poor Lifespan gene in a non-fruit plant will result in a sickly plant that requires a lot of care to nurse it back to health. So keep this one high irregardless!</p>
<p>The Yield gene simply influences how much viable produce a plant can generate per harvest. If the yield gene falls too low, a plant may not produce anything at all!</p>
<p>Potency mainly comes into play when producing herbs, but it can also affect certain other crops. Generally speaking, the more potent a plant is, the more concentrated the reagent it produces will be within the leaves, fruits or what-have-you that you harvest. If you're growing
 medicinal herbs, this is a very important gene as it allows you to squeeze more reagent out of each herb!</p>
<p>Endurance deals with the plant's ability to resist damage from various sources. Generally speaking, drought and poison are the most commonly resisted types of damage. Fire and physical damage usually are too much for a plant to resist, and thus this gene will do nothing against them.</p>
<p>The Analyzer will also display any genetic strains that are present - these are mutant strains that can affect various things about a plant. Known strains will be covered in an addendum. This section will also show if abnormal genetic strains are present - these are rare mutations that
drastically affect a plant's crop production. Most often these will also be directly visible by observing the plant itself - mutated plants often manifest strange alterations to their appearance!</p>
<p>Next to each gene (and the species) you will see either "D" or "r". This denotes whether that gene is Dominant or Recessive - this will be important later!</p>
<p>Several different things cause a plant's genes to mutate. Plants will mutate somewhat naturally whenever they are first planted in a tray. Exposure to mutagens or radiation will also cause mutations of varying severity - the stronger the source, the more drastic the mutation.</p>
<p>In addition to the nutrient tonics mentioned earlier, the PlantMaster Mk3 allows you much more control over this wild and wacky process they call genetic development! Firstly, the PlantMaster features a seed extractor - this simply maximises the amount of seeds you have to work with
by extracting as many as it can from a piece of produce. All seeds within a single piece of produce will share the same genetic makeup too, so you'll have a lot more room for error!</p>
<p>Secondly, the PlantMaster allows you to splice two seeds together to create a new hybrid seed. This is where dominance and recession comes into play! Select two seeds, and you'll be told their chances of successfully splicing - the chances will be much higher if you use two seeds
from species that are similar, such as two fruits, or two herbs. You can splice seeds between species lines, but it will be much more difficult.</p>
<p>When two seeds are successfully spliced, the genes will be mixed. Dominant genes will take precedence over recessive genes! If you have a seed with a bad dominant yield gene and one with a good recessive yield gene, think twice before you splice! The resultant hybrid seed will
take the bad gene, because it's dominant! If your two seeds are both dominant or recessive in one gene however, what will happen most often is that the hybrid's gene will be an average of the two genes. This does not apply to the species gene however - try as we might, we still can't
grow those sweet, sweet corn melon hybrids. So don't try and fuse two species together! It won't work!</p>
<p>Through splicing, you can potentially take a seed with good genes in one area, splice it with a seed that covers the weak genes or adds further advantages, and end up with a seed that has the benefits of both and drawbacks of neither! There are other benefits to splicing seeds, too -
genetic strains that normally only manifest in one species of plant will be shared in the new hybrid. That prized Immortality strain in your Cannabis plant can finally be a reality!</p>
<p>The PlantMaster is also capable of performing infusions. Infusion is a process whereby a reagent is injected into paticular parts of a seed, hopefully without killing it, in order to forcibly induce genetic changes. You will need at least ten units of a reagent to perform this process,
and a beaker of course! Also a seed. That's important too. Different species can react differently to different kinds of reagent, but some have a universal effect on all plants. For instance, infusing a seed with one of the plant nutrient tonics is most likely a great idea - they are designed
to stimulate genes, and what better way to do that than by injecting it directly into the seed's genes? You might not want to infuse a seed with acid, though. That tends to just dissolve it.</p>
<p>Of course, due to the physical damage involved in injecting a seed full of stuff, infusion will always damage the seed a little - certain reagents might cause a lot of damage in addition to this! In some cases, infusions can also trigger drastic mutations in a plant - try infusing a wheat
seed with iron and see what happens. We love that one! Don't be afraid to experiment - you don't have to use your best genetically engineered seeds for infusing, after all. That's what science is all about!</p>
<p>Now you've learned most of what we know. We hope this handbook has been of great use to you! Don't forget to check the addendums for further information!</p>
<div class="tips">
<li> Don't infuse a single seed too much - in addition to the risk of destroying it, damaged seeds tend to grow unhealthy plants. You'll have to nurse any plant growing from a damaged seed back to good health before it'll produce much in the way of crops.
</div>
<h2>Addendum 1: Common Weeds</h2>
<p><b>Spaceborne Fungus</b> (<i>metafungi</i>)</p>
<p>It is not known whether terrestrial mushroom spores were accidentally brought into space or smuggled deliberately, but they now propagate quite rapidly in many space stations, the ventilation systems helping their spores to get around most of the stations.
A subspecies of these mushrooms are often found as a mold growing in damp, dark and poorly travelled places aboard space stations. Mostly harmless.</p>
<p><b>Space Grass</b> (<i>metagraminoidae</i>)</p>
<p>Often humorously termed "Astro Turf", this spaceborne grass is of terrestrial origin and has adapted so well to space that it can grow harmlessly on nearly any surface if seeds of this plant are scattered upon it.</p>
<p><b>Lasher Brambles</b> (<i>metasalsola lividium</i>)</p>
<p>A strange, space-borne mutation of the terrestrial tumbleweed, Lashers are a thorny, bright cyan plant known to be sensitive to nearby motion. They often "lash out" at nearby lifeforms, cutting them with thorny vines. Extermination recommended.</p>
<p><b>Creeper Vine</b> (<i>metahedera pervasis</i>)</p>
<p>These fuschia roots and vines are known for their rapid growth and displacement of other plant species. If a tray is contaminated by Creepers and cannot be disinfected, keep it away from other nearby trays. The creeper vine has been known to actively seek other plants
to attack them and replace them with more instances of itself.</p>
<p><b>Radiator Weed</b> (<i>xenocuries nauseus</i>)</p>
<p>One of the first non-terrestrial plants discovered, spores of this fungus-like plant are often found floating dormantly in space. Unfortunately, it is rather dangerous - the main "bulb" of the plant has been known to emit dangerous levels of ionizing radiation.
The plant takes a while to reach this stage - when the green bulb begins glowing, the plant should be considered a health hazard. It can induce radiation poisoning in humans, and mutations and damage to nearby plants.</p>
<p><b>Toxic Slurry Pod</b> (<i>xenobulba putrescens</i>)</p>
<p>A more recently discovered alien plant, it is sadly no less dangerous or pervasive than the Radiator Weed. The main body of the plant is a green fleshy mass which contains a putrid sludge of unknown function - this sludge is known to be very toxic and can have significant
negative effects on human and plant health. The main body of the plant has been known to fill itself with this sludge to such a degree that it reaches an internal pressure it is no longer capable of withstanding and bursts, splattering the sludge across a large radius. Hardened
globules of this sludge can be harvested from the plant however - with proper processing to remove the toxins, the "slurryfruit" has caught on in some colonies as a delicacy.</p>
<h2>Addendum 2: Known Gene Strains</h2>
<p><b>Fast Metabolism</b>: This strain accelerates a plant's growth, but causes it to drain reagents from its environment more quickly.</p>
<p><b>Slow Metabolism</b>: This strain causes a plant to grow more slowly but also use less reagents.</p>
<p><b>Toxin Immunity</b>: Any kind of toxin or poison will not harm a plant carrying this strain.</p>
<p><b>Drought Resistance</b>: When no water is available, plants with this strain will deteriorate a lot slower.</p>
<p><b>Enhanced Yield</b>: Harvests from plants with this strain will be much more bountiful.</p>
<p><b>Stunted Yield</b>: The harvest yield from plants with this strain will be poor.</p>
<p><b>Immortal</b>: A highly desirable strain that ensures a fruiting plant will never die from being harvested.</p>
<p><b>Unstable</b>: Plants carrying this strain will continually mutate by themselves.</p>
<p><b>Rapid Growth</b>: A very desirable strain that causes the plant to grow far faster than usual.</p>
<p><b>Stunted Growth</b>: This strain will cause the plant to grow much more slowly.</p>
<p><b>Poor Health</b>: The condition of plants carrying this strain will deteriorate over time.</p>
<p><b>Seedless</b>: A very negative strain that prevents the host plant from reproducing at all.</p>
</body>
</html>

"}


/obj/item/paper/book/medical_guide
	name = "Pharmacopia"
	desc = "A listing of basic medicines and their uses."
	info = {"<h1>NT MEDICAL DIVISION</h1>
		<p><i>Disclaimer: At the time of writing, all information in this book is correct. However, over time, the information may become out of date.</i></p>
		<h2>ESSENTIAL MEDICINES LIST FOR NANOTRASEN FACILITIES</h2>
		<br>
		<hr>
		<h2>PHYSICAL TRAUMA</h2>
		<hr>
		<h3>Styptic Powder</h3>
		<div class ="styptic">
		<li>Aluminium Sulfate helps control bleeding and heal physical wounds.
		<li>This compound can be prepared by combining Aluminium Hydroxide with Sulfuric Acid.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Synthflesh (topical)
		<li>Cryoxadone (cryogenics)
		<li>Omnizine (systemic)
		</div>
		<br>
		<hr>
		<h2>BURNS</h2>
		<hr>
		<h3>Silver Sulfadiazine</h3>
		<div class ="sulfa">
		<li>This antibacterial compound is used to treat burn victims.
		<li>Prepare a sulfonyl group with sulfur, oxygen and chlorine.
		<li>React with ammonia for sulfonamide, and combine with silver.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Synthflesh (topical)
		<li>Cryoxadone (cryogenics)
		<li>Omnizine (systemic)
		</div>
		<br>
		<hr>
		<h2>POISONINGS</h2>
		<hr>
		<h3>Activated Charcoal</h3>
		<div class ="charcoal">
		<li>Activated Charcoal helps to absorb toxins from the body and heal moderate toxin damage.
		<li>Heat ashes together with salt to produce activated charcoal.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Pentetic Acid: A potent chelating agent, structurally quite similar to EDTA.
		</div>
		<h3>Calomel</h3>
		<div class = "calomel">
		<li>Calomel, or Mercurous Chloride, is a rapid purgative that will remove other reagents from the body. It is quite toxic.
		<li>It should be used only when the the poisons in your patient are worse than Calomel itself.
		<li>Preparation: heat Mercury and Chlorine together.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Pentetic Acid
		</div>
		<br>
		<hr>
		<h2>RADIATION</h2>
		<hr>
		<h3>Potassium Iodide</h3>
		<div class ="antirad">
		<li>Potassium Iodide is a medicinal drug used to counter the effects of radiation poisoning.
		<li>React Potassium with Iodine. All done!
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Pentetic Acid
		</div>
		<br>
		<hr>
		<h2>CRITICAL HEALTH CRISES</h2>
		<hr>
		<h3>Saline-Glucose Solution</h3>
		<div class ="saline">
		<li>This saline and glucose solution can help ward off shock and promote healing.
		<li>It is a simple mixture of salt, water and sugar.
		</div>
		<h3>Epinephrine</h3>
		<div class ="epinephrine">
		<li>Epinephrine is a potent neurotransmitter, used in medical emergencies to halt anaphylactic shock and prevent cardiac arrest.
		<li>It can be synthesized by combining hydroxylated phenol with chloroacetyl chloride and methylamine,
		<li>In the event that your station lacks these precursors... well, make do with something similar.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Atropine
		</div>
		<br>
		<hr>
		<h2>PAIN</h2>
		<hr>
		<h3>Salicylic Acid</h3>
		<div class="salicylic acid">
		<li>This is a is a standard salicylate pain reliever and fever reducer. It will help relieve slowed movement from injuries.
		<li>Synthesis: treat Sodium Phenolate with Carbon Dioxide, then acidify with Sulfuric Acid.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Morphine (HIGHLY ADDICTIVE. HIGH DOSES MAY LEAD TO SEDATION OR COMA.)
		</div>
		<br>
		<hr>
		<h2>SUFFOCATION</h2>
		<hr>
		<h3>Salbutamol</h3>
		<div class = "salbutamol">
		<li>Salbutamol is a common bronchodilation medication for asthmatics. It may help with other breathing problems as well.
		<li>Synthesis: treat Salicylic Acid with bromine, ammonia, and lithium aluminium hydride.
		<br>
		<h4><i>Advanced:</i></h4>
		<li>Perfluorodecalin (liquid breathing)
		<li>Cryoxadone (cryogenics)
		<li>Omnizine
		</div>
		<br>
		<hr>
		<h2>VARIOUS OTHER PROBLEMS</h2>
		<hr>
		<h3>Diphenhydramine</h3>
		<div class ="diphenhydramine">
		<li>Anti-allergy medication. May cause drowsiness.
		<li>Synthesis route involves Benzhydryl bromide and 2-dimethylaminoethanol.
		</div>
		<h3>Spaceacillin</h3>
		<div class = "spaceacillin">
		<li>An all-purpose antibiotic agent extracted from space fungus.
		<li>Combine spage fungus with ethanol as a solvent.
		</div>
		<h3>Mannitol</h3>
		<div class ="mannitol">
		<li>Mannitol is a sugar alcohol that can help alleviate cranial swelling.
		<li>Hydrolyze sucrose towards fructose, hydrogenate to yield mannitol sugar.
		</div>
		<h3>Oculine</h3>
		<div class ="oculine">
		<li>Oculine is a combined eye and ear medication with antibiotic effects.
		</div>
		<h3>Haloperidol</h3>
		<div class ="haloperidol">
		<li>Haloperidol is a powerful antipsychotic and sedative. Will help control psychiatric problems, but may cause brain damage.
		</div>
		<h3>Mutadone</h3>
		<div class ="mutadone">
		<li>Mutadone is an experimental bromide that can cure genetic abnomalities.
		</div>
		<br>
		<hr>
		<i>This is not a complete list of all available medications. Further research and development efforts by NT Medical and Science divisions are strongly encouraged.</i>
		"}

/obj/item/paper/book/minerals
	name = "Mineralogy 101"
	icon_state = "book5"
	info = {"<html>
<head>
<style type="text/css">
div.code
{
padding:5px;
border:1px solid black;
margin:1px;
font-family:"courier";
font-size:12px;
background-color:lightgray;
}
div.tips
{
padding:10px;
border:5px solid gray;
margin:0px;
font-family:"Arial";
font-size:12px;
font-weight:bold;
}
body
{
color:black;
background-color:white;
}
h1
{
font-family:"Arial Black";
text-align:center;
font-size:24px;
font-weight:bold;
}
h2
{
font-family:"Arial Black";
text-align:left;
font-size:18px;
}
p
{
font-family:"Arial";
font-size:14px;
}
</style>
</head>

<body>

<h1>Mineralogy 101</h1>
<p><i>Disclaimer: At the time of writing, all information in this book is correct. However, over time, the information may become out of date.<br>
<h2>Introduction</h2>
<p>The distinction between minerals in a mining and/or manufacturing environment can sometimes get rather confusing.
Over the course of this handbook, we hope to give you at least a rudimentary education on the various minerals most commonly
found in a space environment, and what they should be used for. This is especially helpful if you are trying to understand
the recent (as of the time of writing) changes made to the NanoTrasen \"AutoArtisan\" standard-issue Manufacturing Units.</p>

<h2>Mauxite</h2>
<p>Classification: Sturdy Metal</p>
<p>Mauxite is a common metal alloy, characterised by its dull reddish-brown color and mild coppery smell. It is commonly used
in construction projects due to being very durable while still rather easy to work with, no doubt due to it being an alloy
comprised mostly of naturally occurring steel with elements of copper and zinc also present among other elements.
It tends to be rather easy to find in space due to its abundance, and poses little risk during extraction or refinement.</p>

<h2>Pharosium</h2>
<p>Classification: Metal, Conductor</p>
<p>Easily recognizable due to its distinct bright orange hue, Pharosium is a conductive metal found in plentiful quantity
and as such is generally considered an industry standard. It finds most common use in electrical wiring and circuit boards.
Often, basic electronics are comprised mostly of Pharosium and Mauxite in their construction.
</p>

<h2>Molitz</h2>
<p>Classification: Crystal</p>
<p>Somewhat similar to both Quartz and glass found on Earth, Molitz is a crystal formation that bears the best qualities of
both, being durable enough to withstand significant shock, and at the same time easy to work with due to its abundance and
malleability. It most often finds use in glass installations on space stations, most often affixed into place as a fine
sealant and durable enough to not pose a potential atmospheric hazard in everyday circumstances.
</p>

<h2>Char</h2>
<p>Classification: Not Construction Grade Material</p>
<p>Char is a black, flaky substance mostly comprised of carbon, and bears a significant similarity to coal. While it is not
generally used in construction projects due to its brittle and weak structure, it does often find use as a fuel source for
basic combustion power systems. It can also be used in chemistry, as a means of acquiring large amounts of carbon and other
trace elements. The origin of this mineral is unknown, as the process of creating coal could not feasibly occur in deep space.
</p>

<h2>Cobryl</h2>
<p>Classification: Metal</p>
<p>While it rarely finds use in industrial and construction projects, Cobryl nevertheless finds itself as a notable material
due to its popularity with industries that deal in luxury. It is light blue in coloration, and when properly treated and
cleaned displays a unique lustre not seen in other materials. It has marginal strength as a metal and as such can be used in
small-scale constructions, but it should not be used for anything that requires significant sturdiness.
</p>

<h2>Cytine</h2>
<p>Classification: Crystal</p>
<p>Cytines are small gemstones of varying color. While no stronger than Molitz at best, they are prized by jewel collectors
and luxury goods traders for their compact shapes, light weight and highly varied color.
</p>

<h2>Fibrilith</h2>
<p>Classification: Not Construction Grade Material</p>
<p>Fibrilith is a highly strange mineral known for both its unusual threaded molecular structure and its extreme softness for
a mineral substance. While it is not paticularly useful in any kind of construction project, it has been successfully woven
into a fabric highly similar to linen. As such, it is prized by textile industries and used in clothing.
</p>

<h2>Bohrum</h2>
<p>Classification: Dense Metal, Dense Matter</p>
<p>Well known among the scientific community for its bizarre chemical makeup, Bohrum is equally well known among the
construction industry for its incredible resilience to damage. It is known to be an alloy of iron, titanium, krypton, xenon,
silver and lead, as well as several previously undiscovered chemical elements which are subject to intense research. While
the noble gases have been formed into compounds in laboratory settings, having them occur naturally with such complexity was
previously considered unthinkable. In spite of these unknown qualities, Bohrum as has yet proven to be an incredibly safe
material to work with and possesses immense strength as a construction material, though its high density makes it very heavy
and thus it is not suited to certain structural projects.
</p>

<h2>Claretine</h2>
<p>Classification: High Energy Conductor</p>
<p>A mineral salt of a brilliant bright red coloration, Claretine is a high-end electrical conductor, able to conduct immense
amounts of electricity without suffering any damage at all. At paticularly high energy states, Pharosium and other lower
grade conductors have been known to lose efficiency due to heat and eventually break down and melt - Claretine appears to
have an incredible resistance to heat in general, and thus is spun into wire spools and used for electrical wiring in
paticularly high-energy systems. It is not common however, and should be used resourcefully.
</p>

<h2>Telecrystal</h2>
<p>Classification: Crystal, High Energy Power Source</p>
<p>With its deep purple coloration and constantly shimmering lustre, one may be prone to mistaking Telecrystal as any other
kind of gemstone - beautiful, but ultimately of little practical use. This is not the case; Telecrystal is well known among
industries and science for its extremely unusual spatial warping properties. Though it is generally not able to transmit
large amounts of matter reliably, it has seen some use in experimental (often illegal) technology, particularly by smugglers
and terrorists dealing in articles of contraband. However, despite its use as a matter transmitter and potent energy source,
Telecrystal is generally not established as a safe material, and caution should be exercised when handling and using it.
Research continues on this mineral to this day.
</p>

<h2>Miracle Matter</h2>
<p>Classification: Anomalous</p>
<p>Extremely unusual in every regard, Miracle Matter is largely considered a chameleon among minerals, well known for
arbitrarily mimicing the molecular structure and chemical composition of other minerals under highly specific conditions.
While research continues on the subject, it is suspected that subjecting Miracle Matter to a high degree of shock in the
presence of dust or regolith from other minerals will cause it to mimic the structure of whatever mineral dust first touches
it after the Miracle Matter is \"activated\", so to speak.
</p>

<h2>Uqill</h2>
<p>Classification: High Density Matter</p>
<p>Uqill is an extremely dense and heavy mineral, known for its dull jet black appearance. While extremely difficult to work
with due to its profound resilience, Uqill is generally used when large amounts of raw matter are needed in a compressed
space, such as the industry standard Dyna*Tech Rapid Construction Device (known more coloquially as \"RCD\". It also finds
use in drills and other materials that require a great deal of robustness.
</p>

<h2>Cerenkite</h2>
<p>Classification: Metal, Power Source</p>
<p>Cerenkite is a light blue highly radioactive soft metal that is used as a power source in various industries. While the
dangers of mining radioactive minerals are already well known, Cerenkite poses its own particular hazard in that it is
notoriously prone to accumulating regolith (a fine mineral dust) which is easily disturbed and dispersed into the air when
the mineral is handled. As such, miners risk being exposed both externally and internally to the radiation if the proper
precautions are not taken when handling Cerenkite.
</p>

<h2>Plasmastone</h2>
<p>Classification: Crystal, Power Source</p>
<p>One of the physical naturally occurring forms of the scientifically nebulous \"Plasma\" substance that almost exclusively
powers modern space travel and industry. This is plasma in a crystalline form - care should be taken when handling it, as it
will explode if exposed to high temperatures or flames, though not to the same degree as the far more violent Erebite (which
can sometimes be found in plasmastone seams). Plasmastone of course has many of the same properties as plasma in other matter
states and such can find use as a power source for certain devices.
</p>

<h2>Syreline</h2>
<p>Classification: Metal</p>
<p>Syreline is of immense value to the luxury commodity industry, being an alloy of several precious metals and having
beautiful light refracting and reflecting properties in its natural state. While it is soft and a poor choice for building
materials, the prices it commands on the mineral market more than make up for its physical weakness.
</p>

<h2>Erebite</h2>
<p>Classification: Power Source</p>
Erebite is an infamously dangerous and volatile mineral that has become increasingly rare in space mining as of late,
no doubt due to its propensity to violently explode if exposed to even mild amounts of heat or shock. Several high profile
industrial accidents have been caused by improper erebite handling. In spite of its hostile and deadly nature however,
erebite has unique energy-altering properties that make it invaluable as an internal power source, or as explosives.
<p>
</p>

<h2>Starstone</h2>
<p>Classification: Crystal</p>
<p>Starstone is a highly rare mineral not found in the vast majority of mining areas. While not paticularly useful as a
construction grade material (being only as strong as mid-grade Molitz at best), the unusual star-shaped crystal lattices
making up this jewel make the few instances of it found by astrogeologists highly prized collectors items. Sapient members
of the Rock Snake race in paticular tend to buy these for high prices, as even a small five gram crystal is able to provide
several months worth of nutrients for them.
</p>
"}

/obj/item/paper/book/critter_compendium
	name = "Critter Compendium"
	desc = "The definite guide to critters you might come across in the wild."
	icon_state = "bookcc"
	info = {"
			<head>
				<style>
					body {
						background-color:#f6f291;
					}
					h1 {
						font-family: "verdana", sans-serif;
					}

					h2 {
						font-family: sans-serif;
						margin: 5px 0px 5px 0px;
						border-bottom: 1px solid black;
					}

					.critter_name {
						font-weight:bold;
						font-size:18px;
					}
					.location {
						font-size:12px;
					}
					.science_name {
						font-style:italic;
					}
					.disclaimer {
						font-weight:bold;
					}

				</style>
			</head>

			<body>
				<h1>CRITTER COMPENDIUM</h1>
				<p class="authors">
					Written by Adam Gaslight<br>
					Edited by Hullabaloo Skiddoo
				</p>
				<h3>Preface</h3>
				<p class="preface">
					What follows is a study on the various space-fauna one is able to find throughout space, though if you're looking for an explanation on why everything is a SPACE bee or a SPACE bear or a SPACE whatever the hell, move along, you're not going to find an answer to that here.  I should also say that those fancy latin species names are by no means universally accepted by the scientific community, nor are they necessarily accepted at all in the scientific community.  Each entry in this Compendium is the result of multiple months of procedural research, careful examination, and poking stuff with a stick, as well as the possibly-willing sacrifice of multiple test subjects to the maw of incredibly dangerous creatures.  Some of these sacrifices may or may not have been human.<br><br>

					<span class="disclaimer">DISCLAIMER: No domestic space-bees were harmed during the making of this Compendium.</span>
				</p>

				<h2>Passive</h2>
				<p class="subtitle">Critters that make no attempt at harm under any circumstance.  Usually.</p>
				<p>
					<span class="critter_name">Cockroach (<span class="science_name">Periplaneta brunnea</span>)</span><br>
					<span class="location"><B>Location:</B> Maintenance shafts</span>
				</p>
				<p class="description">Small insects that do nothing except crawl around being cockroaches.  They cannot attack, are easily killed by brute force, and serve no purpose other than to be cockroaches.  Strangely enough, it is important to note that these are not specified as space cockroaches: They are completely normal cockroaches, identical to those from Earth.  Just goes to show how resilient the bastards are.</p>

				<p>
				<span class="critter_name">Space seal pup (<span class="science_name">Arctocephalus gazella peur spatium</span>)</span><BR>
				<span class="location"><B>Location:</B> Pool</span>
				</p>
				<p class="description">The actual most adorable things in existence.  The only specimens that one will be able to find are in Space Station 13's pool.  They never seem to age due to a quirk in their genetic code that seems to be incompatible with any other species.  Anyone who attacks them is clearly an immoral monster and are to be lynched with utmost haste.</p>

				<p>
					<span class="critter_name">Meat cube (<span class="science_name">Carnis cubus</span>)</span><br>
					<span class="location"><B>Location:</B> Artificially created by science or anomalous energies</span>
				</p>

				<p class="description">Grotesque, animate amalgamations of flesh and meat that are alive and sentient due to varying factors, such as horrendous scientific experiments, supernatural phenomena, or perhaps the will of an angry god.  They have only been observed to flop around uselessly and pop into a burst of gibs upon expiration.</p>

				<p>
					<span class="critter_name">Lesser horned owl (<span class="science_name">Bubo magellanicus</span>)</span><br>
					<span class="location"><B>Location:</B> SS13 Owlery</span>
				</p>
				<p class="description">Members of these species, with varying degrees of physical attractiveness, inhabit the station's Owlery.  Some say they hold a great treasure which will allow you to join their ranks as an extremely attractive owl.</p>

				<p>
					<span class="critter_name">Plasma spore (<span class="science_name">Crepitus globum</span>)</span><br>
					<span class="location"><B>Location:</B> Deep space</span>
				</p>
				<p>These sentient conglomerates have no notable behavior patterns other than to aimlessly float around.  The creatures that make up these spores subsist entirely on plasma, which is filtered through the air as the spore floats.  This plasma is metabolized in a manner that gives the spore the energy to control its local gravitational pull, letting it freely float without any apparent means of propulsion.  However, the volatility and density of this energy makes the plasma spores very dangerous creatures, for any considerable amount of force will cause the plasma spore to burst, with the stored plasma igniting upon contact with the air and the energy shooting outwards milliseconds later, which is all an incredibly fancy way of saying that it blows the fuck up if you hit it with something.</p>


				<h2>Neutral</h2>
				<p class="subtitle">Critters that do not actively hunt others, but will retaliate if provoked.</p>
				<p>
					<span class="critter_name">Human (<span class="science_name">Homo sapiens</span>)</span><br>
					<span class="subtitle"><B>Location:</B> Absolutely everywhere</span>
				</p>
				<p class="description">
					A terrifying creature that destroys almost everything it comes in contact with.  While they don't possess many natural weapons, they seem to use tools often, usually seen wielding a welding tool, a toolbox, or a fire extinguisher.<br>

					There are reports of scientists that have been able to create human beings through the use of carefully-calculated chemical reactions.  The resulting humans have been reported as exhibiting one of two behaviors: Either they are catatonic and effectively braindead, or violent and incredibly aggressive.  The second type of produced human being has been shown to exhibit a surprising amount of robustness.  Observation of precise behavioral characteristics is pending.
				</p>

				<p>
					<span class="critter_name">Greater domestic space-bee (<span class="science_name">Pseudoapidae nanotracaceus venerandus</span>)</span><br>
					<span class="location"><B>Location:</B> Domestic space-bee eggs, kept as pets throughout all of space
				</p>
				<p class="description">
				Truly the greatest and most venerable of these critters in all the universe, as well as one of the very few good things to come out of the NT labs, the humble domestic space-bee is hatched by the mere activation of a space-bee egg.  You can even name the bee by writing its name on the egg before hatching!  Domestic space-bees are, as their name implies, domestic by nature, and will not attack a single living soul unless directly provoked by a terrible, terrible person.  When provoked, they will nibble and sting their attacker.  Contrary to terrestrial bees, the greater domestic space-bee does not die upon issuing a sting, and can sting as many times as it wishes.  Greater domestic space-bees are also fiercely protective of their owners, and will swarm anyone who directly attacks them.  For unknown reasons, the DNA of all greater domestic space-bees is comprised of 1% cat DNA.
				</p>
				<p>
				<span class="critter_name">Space-mouse (<span class="science_name">Mus spatium</span>)</span><br>
				<span class="location"><B>Location:</B> Maintenance shafts</span>
				</p>
				<p class="description">
					Tiny little rodents that scamper around and eat any food they see on sight.  Easily deterred by mousetraps.  Tend to be very aggressive if provoked.  May have rabies.  If you see any frothing at the mouth, covered in battle scars, or trying to eat itself, either bring it to the attention of the proper station personnel or deal with it yourself.  Hopefully the former, to keep the Janitor from making the floors a slippy slidey water world.
				</p>

				<p>
					<span class="critter_name">Space walrus (<span class="science_name">Odobenus rosmarus spatium</span>)</span><br>
					<span class="location"><B>Location:</B> SS13 Pool</span>
				</p>
				<p class="description">
					One of these tusked tubs of lard lazes about in the pool and does nothing other than leisurely wander around...unless you punch it, in which case it will run up to you, lunge at you to knock you down, and gore you with its tusks before resuming its lazing.  Other than that interesting little oddity, the space walrus does absolutely nothing useful aside from serving as a wall of flab.  Honestly, I have no idea why we keep one of these things on the station.
				</p>


				<p>
					<span class="critter_name">Jungle owlet (<span class="science_name">Glaucidium radiatum</span>)</span><br>
					<span class="location"><B>Location:</B> SS13 Owlery</span>
				</p>
				<p class="description">
					Space Station 13 has had a long history of keeping at least one member of this species of owls on station, the reason for which is completely unknown to the vast majority of Nanotrasen employees.  It's rumored that one can turn themselves into an owl of this species through use of a mysterious artifact that has also been kept in the station's Owlery, though this is fiercely denied by just about any NT official you ask.
				</p>
				<p>
					<span class="critter_name">Space pig (<span class="science_name">Sus spatium</span>)</span><br>
					<span class="location"><B>Location:</B> Deep space</span>
				</p>
				<p class="description">
					A source of delicious bacon.  They tend to collect in great heaps if your telescience managers are being idiots, which is unfortunately common.
				</p>

				<p>
					<span class="critter_name">Space goose (<span class="science_name">Branta canadensis spatium</span>)</span>
					<span class="location"><B>Location:</B> Unknown</span>
				</p>
				<p class="description">
					Geese in space.  More specifically, a species of goose specifically made for life in space.  They are inexplicably able to open airlocks, and will relentlessly chase down and beat any motherfucker that provokes them.  There's a theory that these honking death machines were being mass-produced by the Syndicate for utilization in combat, but Syndicate officials claim to know nothing about the true origins of the space goose, leaving the matter as a mystery.
				</p>

				<p>
					<span class="critter_name">Magma crab (<span class="science_name">Carabus petrum</span>)</span><br>
					<span class="location"><B>Location:</B> Lava moon</span>
				</p>
				<p class="description">
					Denizens of what is referred to as the “lava moon” that do not move or take action towards most stimuli.  Research had been remarkably inconclusive as to the behavioral patterns of these species, with a hypothesis being proposed that they weren't even creatures at all, and were instead conspicuously-shaped rocks.  That is, until one scientist, in a fit of anger, kicked a magma crab in the face during on-station testing, and was promptly pinched directly in the ankle.  After the scientist in question hid behind a bush to escape the creature, the magma crab returned to its previous state of immobility.
				</p>

				<p>
					<span class="critter_name">B-33 "BeeBuddy" (<span class="science_name">Pseudoapidae nanotracaceus machina</span>)</span><br>
					<span class="location"><B>Location:</B> Unknown</span>
				</p>
				<p>
					Somehow, through some crazy genetics shit, a hybrid of the greater domestic space-bee and the PR-6 Robuddy exists.  We don't know how those two things are capable of reproducing with one another, and to be perfectly honest, we really don't want to know.  Tests still need to be run to determine which characteristics of both species these “BeeBuddies” possess.
				</p>

				<p>
					<span class="critter_name">&#1050;&#1086;&#1089;&#1084;&#1086;&#1089; &#1055;&#1095;&#1077;&#1083;&#1072; (<span class="science_name">Kocmoc pchela</span>)</span><br>
					<span class="location"><B>Location:</B> A russian ship in deep space</span>
				</p>
				<p class="description">
					A manufactured, fake excuse of a bee.  Hovers around being a horrible facsimile and spouting communist propaganda.  May know nuclear launch codes.
				</p>

				<p>
					<span class="critter_name">Bombini</span><br>
					<span class="location"><B>Location:</B> His ship, out in space</span>
				</p>
				<p class="description">
					This bee puts the "great" in "greater domestic space-bee", as Bombini is a distinguished member of the bee family, and separates himself from the common bee with his advanced intellect, his swanky outfit, his sweet goods, and his conversational savvy.  He regularly hangs out with Snoop Dogg, Tupac, Biggie Smalls, and anyone else you care to name because he's cooler than you.  As a side business, he sells off his surplus of eggs for damn good deals out in the diner asteroid fields.  What a nice guy.  Truly, the greatest pimp that beekind has ever known.
				</p>

				<p>
					<span class="critter_name">Heartbee (<span class="science_name">Pseudoapidae nanotracaceus organi</span>)</span><br>
					<span class="location"><B>Location:</B> Created by a chemical reaction</span>
				<p>
				<p class="description">
					Giving an entirely new meaning to the term "butterflies in your chest", these creatures are human hearts that have been transformed into bees through the use of a highly dangerous and experimental chemical.  It is unknown to what extent these creatures function like bees.
				</p>

				<p>
					<span class="critter_name">The Overbee (<span class="science_name">Pseudoapidae nanotracaceus rex</span>)</span><br>
					<span class="location"><B>Location:</B> Purportedly, a giant beehive in space.</span>
				</p>
				<p class="description">
					Rumored to live in the depths of space, the Overbee is a variant on the greater domestic space-bee with a wild variety of superpowers.  Fortunately, it is observed to be friendly in nature...but no researchers have been able to report back with their findings after setting out to test the creature's behavior when provoked.
				</p>
			</body>

		"}

/obj/item/paper/book/the_trial
	name = "The Trial of Heisenbee"
	desc = "Some kinda children's book. What's that doing here?"
	icon_state = "booktth"
	//Well, fuck knows why this ends up looking like arse, but it does.
	info = {"
		<font face=Georgia color=black size='3'> THE TRIAL OF HEISENBEE<BR>
A children&#39;s book by F. Briner:<BR>
<BR>
Heisenbee had done a very bad crime in the animal courtroom, he stung Albert the Monkey without warning and that made Albert very sad.<BR>
<BR>
Albert the Monkey had asked the owl police, which was headed by Hooty McJudgementowl, to arrest Heisenbee, which is a very mean thing to do to a bee!<BR>
<BR>
The owl jury stood silent as Heisenbee&#39;s lawyer, a fresh-faced monkey by the name of Tanhony and a voice the sound of horses running wild entered the courtroom.<BR>
<BR>
Heisenbee buzzed questioningly at the judge! The judge, his Honor Muggles screeched back Heisenbee&#39;s terrible and awful crimes! Tanhony asked Heisenbee to remain quiet.<BR>
<BR>
The mammalian Jury grew restless, Jones the cat hissed at the mouse, who was taking notes of the proceedings. Tanhony gave his appeal to the animal Jury.<BR>
<BR>
The brothers gnome, Chompski and Chompski, were not convinced and voted Heisenbee guilty of attempted murder! Which was very bad for Heisenbee!<BR>
<BR>
The owls stood silent, which as we a </font><font face=Georgia color=black size='3'> ll know means that they knew in their hearts of hearts that Heisenbee was guilty.<BR>
<BR>
The mammalian jury was silent, having just convinced the cockroach that Heisenbee was not like other bugs and was in fact guilty.<BR>
<BR>
Heisenbee buzzed in panic, and buzzed angrily at Tanhony! He was led off the premises by Franklin Briner the Chief Engineer. THE END </font>
		"}