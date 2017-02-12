var/datum/materialResearchHolder/materialsResearch

/datum/materialResearchHolder
	var/list/research = list()
	var/list/completed = list()
	var/running = 0    //Amount of currently running research projects.
	var/max_running = 1//Max amount of running research allowed.

	proc/isComplete(var/researchId)
		return completed.Find(researchId)

	proc/setup()
		var/types = (typesof(/datum/materialResearch) - /datum/materialResearch) - /datum/materialResearch/scanner
		for(var/x in types)
			var/datum/materialResearch/R = new x(src)
			research.Add(R.id)
			research[R.id] = R
		return

/obj/machinery/matscanner
	name = "Scanner"
	desc = "A piece of machinery used to scan various materials and objects for research purposes."
	icon = 'icons/obj/crafting.dmi'
	icon_state = "matscanner0"
	anchored = 1
	density = 1
	var/active = 0

	New()
		..()

	attackby(obj/item/W as obj, mob/user as mob)
		if(active)
			boutput(usr, "<span style=\"color:red\">The scanner is busy.</span>")
			return

		active = 1
		flick("matscanner1", src)
		playsound(src.loc, "sound/machines/ArtifactPre1.ogg", 50, 0)

		for(var/x in materialsResearch.research)
			var/datum/materialResearch/R = materialsResearch.research[x]
			R.onScan(W)
			if(istype(R, /datum/materialResearch/scanner))
				var/datum/materialResearch/scanner/R2 = R
				for(var/datum/materialResearchScan/S in R2.requiredScans)
					if(S.completed) continue
					S.checkCompletion(W)

		spawn(10) active = 0

	ex_act(severity)
		return

/datum/materialResearchScan
	var/name = ""
	var/desc = "" //Quick description of whats needed for this scan.
	var/completed = 0

	proc/checkCompletion(var/atom/scanned) //This proc checks if a scanned object fits this scan. Simply do you check and set completed to 1 if the scan fits this profile.
		completed = 0
		return

/datum/materialResearch
	var/name = ""
	var/desc = ""  //Shown when not researched.
	var/r_desc = ""//Shown when researched. If not set, normal desc will be shown.
	var/id = ""	   //Unique id
	var/researchCost = 0
	var/researchTime = 0 //in 1/10 of a second in BYOND TIME
	var/hidden = 0	//1 = research is hidden and can not be researched.

	var/startTime = 0
	var/completed = 0
	var/prcComplete = 0
	var/statusString = "error"

	proc/canShow() //Use this to check for certain conditions like only showing this research when another one has been completed.
		if(hidden) return 0
		return 1

	proc/beginResearch()
		if(canStart()) return canStart()
		if(materialsResearch.running >= materialsResearch.max_running) return "Maximum amount of concurrently running research reached."
		if(!canShow()) return "Internal error: Attempting to start hidden research. Report this please."
		if(researchCost) wagesystem.research_budget -= researchCost
		startTime = world.time
		materialsResearch.running++
		return 0 //Again, 0 means everything is good.

	proc/canStart()
		if(researchCost && wagesystem.research_budget < researchCost)
			return "Not enough research budget."

		if(completed) return "Research already completed."
		return 0 //0 means "yes, we can start this". This is so we can return a string when we CAN'T.

	proc/onComplete()
		return

	proc/onScan(var/atom/scanned) //Called when something is scanned. In case you want to make hidden research that shows up after scanning something.
		return

	proc/process()
		if(!startTime) statusString = "Not researched"
		if(completed || !startTime) return

		var/finishTime = (startTime + researchTime)
		var/remaining = finishTime - world.time

		if(remaining <= 0)
			completed = 1
			statusString = "Complete"
			prcComplete = 100
			materialsResearch.running--
			onComplete()
		else
			var/done = world.time - startTime
			prcComplete = round((done / researchTime) * 100)
			statusString = "[prcComplete]% ([round(remaining / 10)]s)"
		return

/datum/materialResearchScan/wendigoHide
	name = "Wendigo Hide"
	desc = "We need to scan the fur of a wendigo."

	checkCompletion(var/atom/scanned)
		if(completed) return
		if(scanned.material && scanned.material.mat_id == "wendigohide")
			completed = 1
		return

/datum/materialResearchScan/wendigoKingHide
	name = "Wendigo King Hide"
	desc = "We need to scan the fur of a wendigo King."

	checkCompletion(var/atom/scanned)
		if(completed) return
		if(scanned.material && scanned.material.mat_id == "kingwendigohide")
			completed = 1
		return

/datum/materialResearchScan/iridiumAlloy
	name = "Iridium alloy"
	desc = "We need to scan the iridium alloy rumored to be used in certain high-end battle drones."

	checkCompletion(var/atom/scanned)
		if(completed) return
		if(scanned.material && scanned.material.mat_id == "iridiumalloy")
			completed = 1
		return

///////////////////////////////////////////////////////////////////////////////

/datum/materialResearch/supernatural1
	name = "Supernatural materials"
	desc = "Our scans of supernatural materials have shown strange properties that could be useful. We could focus on researching this."
	r_desc = "<span style=\"color:#078C00;\">Our first round of research has shown that cobryl appears to be an excellent conductor for spiritual energy, we should try infusing it with ectoplasm.</span>"
	id = "supernatural1"
	researchTime = 1200
	researchCost = 1000
	hidden = 1

	onScan(var/atom/scanned)
		if(scanned.reagents)
			if(scanned.reagents.has_reagent("ectoplasm")) hidden = 0
			else if(istype(scanned, /obj/item/reagent_containers/food/snacks/ectoplasm)) hidden = 0
		return

/datum/materialResearch/supernatural2
	name = "Supernatural enhancement"
	desc = "We believe that it could be possible to imbue materials with certain properties exhibited by apparitions and spirits but more research is needed."
	r_desc = "<span style=\"color:#078C00;\">Through our research we have discovered a process to make materials ethereal, allowing matter to pass through them.</span>"
	id = "supernatural2"
	researchTime = 3000
	researchCost = 6000

	canShow()
		if(!..()) return 0
		if(materialsResearch.completed.Find("supernatural1")) return 1
		return 0

/datum/materialResearch/efficientresearch
	name = "Efficient research methods"
	desc = "Researching this would allow us to more efficiently research future projects, leading to a reduction in cost."
	r_desc = "<span style=\"color:#078C00;\">Our improved research methods have resulted in a 1000c research cost reduction.</span>"
	id = "effresearch"
	researchTime = 1200
	researchCost = 1000

	onComplete()
		for(var/x in materialsResearch.research)
			var/datum/materialResearch/R = materialsResearch.research[x]
			R.researchCost = max(R.researchCost - 1000, 0)
		return

/datum/materialResearch/fastresearch
	name = "Fast research"
	desc = "Streamlining of our research methods will allow us to complete future research faster."
	r_desc = "<span style=\"color:#078C00;\">Our improved research methods have resulted in a 15% reduction in research time.</span>"
	id = "fstresearch"
	researchTime = 1800
	researchCost = 3000

	canShow()
		if(!..()) return 0
		if(materialsResearch.completed.Find("effresearch")) return 1
		return 0

	onComplete()
		for(var/x in materialsResearch.research)
			var/datum/materialResearch/R = materialsResearch.research[x]
			R.researchTime = round(R.researchTime - (R.researchTime * 0.15))
		return
/*
/datum/materialResearch/reconditioning1
	name = "Material reconditioning"
	desc = "It may be possible to customize materials beyond their normal limits - this will require some research, however."
	r_desc = "<span style=\"color:#078C00;\">We have discovered a process that allows us to recondition materials. However, this greatly strains and damages the materials.</span>"
	id = "recondition1"
	researchTime = 1200
	researchCost = 4000

	canShow()
		if(!..()) return 0
		if(materialsResearch.completed.Find("fstresearch")) return 1
		return 0

/datum/materialResearch/scanner/reconditioning2
	name = "Advanced material reconditioning"
	desc = "Analysis of certain iridium alloys might help us find new ways to re-condition materials far beyond their normal limits."
	r_desc = "<span style=\"color:#078C00;\">We were able to develop a new method of material re-conditioning that no longer damages the materials used.</span>"
	id = "recondition2"
	researchTime = 1200
	researchCost = 2000

	New()
		requiredScans.Add(new/datum/materialResearchScan/iridiumAlloy(src))

	canShow()
		if(!..()) return 0
		if(materialsResearch.completed.Find("recondition1")) return 1
		return 0
*/

/datum/materialResearch/scanner/wendigo
	name = "Wendigo research"
	desc = "We need to closely analyze a sample of wendigo fur so that we can replicate their remarkable resistance to cold climates."
	r_desc = "<span style=\"color:#078C00;\">Our research into wendigo fur has resulted in a process that increases thermal insulation of materials.</span>"
	id = "wendigo"
	researchTime = 800
	researchCost = 1500

	New()
		requiredScans.Add(new/datum/materialResearchScan/wendigoHide(src))

/datum/materialResearch/scanner/wendigoking
	name = "Wendigo King research"
	desc = "We should closely analyze the fur of a wendigo King to discover what exactly makes it different from a normal wendigo."
	r_desc = "<span style=\"color:#078C00;\">Our research shows that in addition to the remarkable resistance to cold, the wendigo King can also keep it's body's temperature constant. We should be able to replicate this.</span>"
	id = "wendigoking"
	researchTime = 1000
	researchCost = 5500

	canShow()
		if(!..()) return 0
		if(materialsResearch.completed.Find("wendigo")) return 1
		return 0

	New()
		requiredScans.Add(new/datum/materialResearchScan/wendigoKingHide(src))

/datum/materialResearch/scanner //This subtype of research required certain scanned things to allow research.
	var/list/requiredScans = list()

	canStart()
		if(!..())
			var/completeCount = 0
			for(var/datum/materialResearchScan/x in requiredScans)
				if(x.completed == 1) completeCount++

			if(completeCount < requiredScans.len)
				return "Can not start research - [requiredScans.len - completeCount] Scan(s) missing."
			else
				return 0
		else return ..()