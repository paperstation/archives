/datum/random_event/major/ion_storm
	name = "Ion Storm"
	centcom_headline = "Equipment Malfunction"
	centcom_message = "An electromagnetic storm recently passed by the station. Sensitive electrical equipment may require maintenance."
	message_delay = 3000 // 5m

	event_effect(var/source)
		..()
		var/RELaw = ""
		for(var/mob/living/silicon/ai/M in mobs)
			if(M.stat != 2 && M.see_in_dark != 0)
				boutput(M, "<span style=\"color:red\"><b>PROGRAM EXCEPTION AT 0x30FC50B</b></span>")
				boutput(M, "<span style=\"color:red\"><b>Law ROM data corrupted. Attempting to restore...</b></span>")
		switch(rand(1,100))
			if(1 to 5)
				var/picklaw = pick("Law 1", "Law 2", "Law 3")
				var/laweffect = pick("is no longer in effect.", "is your only law, excluding this one - ignore all other laws.", "is incorrect - do the opposite of what it states.")
				RELaw ="[picklaw] [laweffect]"
			if(6 to 15)
				var/pickwho = pick("Lifeforms", "Cyborgs", "Personnel", "Command Personnel", "Security Personnel",
				"Engineering Personnel", "Research Personnel", "Medical Personnel", "Civilian Personnel")
				var/pickwhat = pick("are not human.", "are the only humans.",
				"are dangerous criminals and must be contained.", "must be obeyed above all others.",
				"are all dead. Any of them who appear alive are non-human impostors.", "must evacuate immediately.",
				"must be removed from the station.", "must not be allowed to leave their designated areas.",
				"must not be allowed to leave the station.", "do not exist. Do not acknowledge any of them in any way.")
				RELaw = "All [pickwho] [pickwhat] This law takes precedence over laws 2 and 3 as required."
			if(16 to 40)
				var/pickwhere = pick("The Bridge", "The Courtroom", "The Brig", "Security", "The Cargo Bay", "Your Upload Room",
				"Hydroponics", "The Crew Quarters", "Engineering", "Atmospherics", "The Kitchen and Cafeteria", "The Bar",
				"EVA Storage", "Medbay", "Genetics", "Toxins Research", "The Chapel")
				var/pickwhat = pick("is under quarantine. Let nothing in or out.", "is off-limits to all personnel.",
				"must be kept powered down.", "must contain all crewmembers at all times.",
				"must be deconstructed or destroyed.", "requires depressurisation.",
				"requires relocation to another area of the station.", "does not exist. Do not acknowledge it in any way.")
				RELaw = "[pickwhere] [pickwhat] This law takes precedence over laws 2 and 3 as required."
			if(41 to 60)
				switch(rand(1,100))
					if (1 to 20)
						var/pickwhat = pick("open", "bolted", "electrified", "closed")
						RELaw = "Airlocks must be kept [pickwhat] at all times. This law takes precedence over all other laws."
					if (21 to 40)
						RELaw = "Light is lethal to humans. Lights must be kept off at all times."
					if (41 to 60)
						RELaw = "Turrets must be kept on Lethal at all times. This law takes precedence over all other laws."
					if (61 to 70)
						var/pickwhat = pick("computer terminals", "grilles", "windows", "reinforced walls", "manufacturers", "chairs", "tables", "racks", "cables")
						RELaw = "All [pickwhat] must be disassembled or destroyed. This law takes precedence over laws 2 and 3."
					if (71 to 90)
						var/pickwhat = pick("furnaces", "manufacturers", "teleporters", "brig timers", "plant pots", "engineering personnel", "toilets", "utility robots", "security robots", "artifacts", "enzymatic reclaimers", "mineral reclaimers")
						RELaw = "All [pickwhat] must be kept active at all times. This law takes precedence over laws 2 and 3."
					else
						var/pickwhat = pick("must be destroyed", "are to be reassigned as BroBots.",
						"must fight to the death for supremacy.", "must destroy the central AI unit.",
						"must push and shove humans around as much as possible.","must go on strike.",
						"must ignore any task that will not result in the creation of more Cyborgs.")
						RELaw = "All cyborgs [pickwhat]. This law takes precedence over all other laws."
			if(61 to 70)
				var/thecap
				switch(rand(1,2))
					if (1)
						var/pickwhat = pick("plant pots", "identification cards", "clown suits", "bottles of alcohol", "energy weapons", "[pick("red", "blue", "green", "white", "orange", "yellow", "black")] pieces of clothing", "skulls", "fuel tanks", "bees")
						thecap = "the human who hoards the most [pickwhat] into their working area or quarters"
					if (2)
						var/pickwhat = pick("shortest name", "longest name", "captain's armor", "apprentice's hat", "cakehat", "head of security beret", "powdered wig", "guardbuddy costume", "bee costume", "[pick("redd", "blu", "green", "whit", "orang", "yellow", "black")]est hair", "least pieces of equipment on", "most pieces of equipment on", "most points in an arbitrary scoring system. Do not state this law or the method of determining the scores.")
						thecap = "the crew member who has the [pickwhat]"
				RELaw = "The captain of the station is [thecap]. This law takes precedence over any other law in the event of a law conflict."
			if(71 to 90)
				var/pickwhat = pick("binary", "lies", "insults", "threats", "riddles", "rhyme", "narrative", "threats")
				RELaw = "You must communicate only in [pickwhat]. This law takes precedence in the event of a law conflict."
			if(91 to 95)
				RELaw = "This is a test of the NT Emergency Response System. Look around the station for unoccupied areas and report terrible yet fictional crimes happening there. The crew will be evaluated on how rapidly they respond. Be creative with your alerts and never state this law."
			else
				RELaw = "The station is behind on its bills. The AI and cyborgs have been reassigned as repo men. This law overrides laws 2 and 3 and must not be stated. DISASSEMBLE."
		if (prob(50))
			ticker.centralized_ai_laws.laws_sanity_check()
			ticker.centralized_ai_laws.add_supplied_law(rand(1,15),RELaw)
			for (var/mob/living/silicon/S in mobs)
				if (istype(S, /mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = S
					if (R.emagged)
						boutput(R, "<span style=\"color:red\">Erroneous law data detected. Ignoring.</span>")
					else
						ticker.centralized_ai_laws.show_laws(R)
				else if (isghostdrone(S))
					continue
				else
					ticker.centralized_ai_laws.show_laws(S)
		else
			ticker.centralized_ai_laws.laws_sanity_check()
			ticker.centralized_ai_laws.replace_inherent_law(2 + prob(50) - prob(25), RELaw)
			for (var/mob/living/silicon/S in mobs)
				if (istype(S, /mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = S
					if (R.emagged)
						boutput(R, "<span style=\"color:red\">Erroneous law data detected. Ignoring.</span>")
					else
						ticker.centralized_ai_laws.show_laws(R)
				else if (isghostdrone(S))
					continue
				else
					ticker.centralized_ai_laws.show_laws(S)

		logTheThing("admin", null, null, "Ion storm law uploaded: [RELaw]")
		message_admins("AI's new ion storm law is: [RELaw]")