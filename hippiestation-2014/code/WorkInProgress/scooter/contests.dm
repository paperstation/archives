var/global/datum/contest/currentcontest

client
	var/datum/contest/contest

/datum/contest
	var/name
	var/desc
	var/objective
	var/points

/datum/contest/New()
	if(!currentcontest.objective)
		objective = currentcontest.objective
	else
		return
	points = rand(1,5)
	..()

/proc/contestender()
	var/list/datum/contest/finalize
	for(var/datum/contest/G in world)
		finalize.Add(G)
	if(finalize)
		var/pmax = max(finalize.points)
		var/pmin = min(finalize.points)
		world << "Highest points:[pmax]"
		world << "Lowest points: [pmin]"
/proc/createcontest()
	for(var/client/G in world)
		G.contest = new/datum/contest