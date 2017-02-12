
/client/proc/wireTest()
	set name = "WireTest"
	set hidden = 1
	admin_only

	//src.chui.reload()
	src.Browse(grabResource("html/wireTest.html"), "window=wireTest;size=500x650;title=Wire Test;")
	//src.mob.deathConfetti()


//Proc for parsing data returned by the bans API (as well as whatever else in the future)
//Expects a base64 encoded url parameter query string. Yes I know how weird that sounds.
/proc/parseCallbackData(data)
	if (copytext(data, 1, 2) == "{") //we got fed json instead (probably) whoops
		var/error[] = new()
		error["error"] = "Parsing error (JSON provided)"
		return error

	data = base64str(data)
	var/list/ldata = params2list(url_decode(data))
	var/parsedList[] = new()
	var/regex/R = new("/(^\\d{1,2})/i")

	for (var/e = 1, e <= ldata.len, e++) //each field in the format index[fieldkey]=field
		var/index = ldata[e]
		var/num

		if (R.Find(index))
			do
				num = R.GroupText(1) //grab the index number e.g. the 1 from 1[ckey]=blah
			while(R.FindNext(index))

		if (!num) //no num found, we're assuming this was an error message response (or any kind of message really)
			ldata[index] = base64str(ldata[index])
			return ldata

		var/field = copytext(index, lentext(num)+1, 0) //grab the field name e.g. [ckey]
		field = copytext(field, 2, -1) //convert [ckey] to ckey
		var/val = base64str(ldata[index]) //the actual value e.g. blah

		if (!parsedList[num]) //if a list of this num doesnt exist, create it e.g. parsedList(1 => list())
			parsedList[num] = new/list()
		parsedList[num][field] = val //shove data in appropriate list e.g. parsedList(1 => list("ckey" => "blah"))
		//boutput(world, "Index: [index]. Num: [num]. Field: [field]. Val: [val]") //DEBUG

	return parsedList


//Silly little thing that the bans panel calls on refresh
/proc/getWorldMins()
	var/CMinutes = num2text((world.realtime / 10) / 60, 99) //fuck you byond scientific notation
	if (centralConn)
		var/list/returnData = new()
		returnData["cminutes"] = CMinutes
		return list2json(returnData)
	else
		return CMinutes


/**
 * Constructs a query to send to the goonhub web API
 *
 * @route (string) requested route e.g. bans/check
 * @query (list) query arguments to be passed along to route
 * @forceResponse (boolean) will force the API server to return the requested data from the route rather than hitting hubCallback later on
 * @return (list|boolean) list containing parsed data response from api, 1 if forceResponse is false, 0 if error
 *
 */
/proc/queryAPI(route, query, forceResponse = 0)
	set background = 1
	if (!route) return 0

	var/list/data = new()

	if (centralConn)

		var/uri = "http://goonhub.com/ss13" //TODO: Config option
		var/req = "[uri]/[route]/?[query ? "[list2params(query)]&" : ""]" //Necessary
		req += "[forceResponse ? "bypass=1&" : ""]" //Force a response RIGHT NOW y/n
		req += "data_server=[(world.port % 1000) / 100]&" //Append server number
		req += "auth=[md5(config.extserver_token)]" //Append auth code

		var/response[] = world.Export(req)
		if(!response)
			logTheThing("debug", null, null, "<b>API Error</b>: No response from server during query to <b>[req]</b>. Try count is: <b>[centralConnTries]</b>")
			logTheThing("diary", null, null, "API Error: No response from server during query to [req]. Try count is [centralConnTries]", "debug")
			//if (centralConnTries >= 5)
			//	centralConn = 0
			//	logTheThing("debug", null, null, "<b>Critical API Error</b>: <b>Max remote API tries exceeded, switching to local fallback system.</b>")
			//	logTheThing("diary", null, null, "Critical API Error: Max remote API tries exceeded, switching to local fallback system.", "debug")
			//else
			//	centralConnTries++
			return 0

		if (forceResponse)
			var/key
			var/contentExists = 0
			for (key in response)
				if (key == "CONTENT")
					contentExists = 1

			if (!contentExists)
				logTheThing("debug", null, null, "<b>API Error</b>: Malformed response from server during <b>[req]</b>")
				logTheThing("diary", null, null, "API Error: Malformed response from server during [req]", "debug")
				return 0

			//Parse the response
			data = parseCallbackData(file2text(response["CONTENT"]))


	var/theProc = null
	if (findtext(route, "bans/"))
		route = copytext(route, 6)
		//Ban routes we don't run locally if centralConn is UP
		if (centralConn)
			if (route == "check")
				return data
		//Ban routes we don't run locally regardless of anything
		if (route == "parity" || route == "updateLocal" || route == "updateRemote")
			return (centralConn ? data : 0)
		theProc = "/proc/" + route + "BanApiFallback"

	if (!theProc)
		/* Wire note: This gets a little spammy with procs we don't care about local fallbacks for e.g. numbers station
		logTheThing("debug", null, null, "<b>Local API Error</b> - No proc specified for route: <b>[route]</b>")
		logTheThing("diary", null, null, "<b>Local API Error</b> - No proc specified for route: [route]", "debug")
		*/
		return (centralConn ? data : 0)

	var/localData = call(theProc)(query)
	if (!localData)
		logTheThing("debug", null, null, "<b>Local API Error</b> - Nothing returned from <b>[theProc]</b>")
		logTheThing("diary", null, null, "<b>Local API Error</b> - Nothing returned from [theProc]", "debug")
		return (centralConn ? data : 0)

	if (istype(localData, /list))
		var/list/ldata = localData
		if (ldata["error"])
			logTheThing("debug", null, null, "<b>Local API Error</b> - Callback failed in <b>[theProc]</b> with message: <b>[ldata["error"]]</b>")
			logTheThing("diary", null, null, "<b>Local API Error</b> - Callback failed in [theProc] with message: [ldata["error"]]", "debug")
			if (ldata["showAdmins"])
				message_admins("<span style=\"color:blue\"><b>Failed for route [route]BanApiFallback</b>: [ldata["error"]]</span>")

	return (centralConn ? data : localData)


/* Death confetti yayyyyyyy */
#ifdef XMAS
var/global/deathConfettiActive = 1
#else
var/global/deathConfettiActive = 0
#endif

/mob/proc/deathConfetti()
	particleMaster.SpawnSystem(new /datum/particleSystem/confetti(src.loc))
	spawn(10)
		playsound(src.loc, "sound/effects/yayyy.ogg", 50, 1)

/client/proc/toggle_death_confetti()
	set popup_menu = 0
	set category = "Toggles"
	set name = "Toggle Death Confetti"
	set desc = "Toggles the fun confetti effect and sound whenever a mob dies"
	admin_only

	deathConfettiActive = !deathConfettiActive

	logTheThing("admin", src, null, "toggled Death Confetti [deathConfettiActive ? "on" : "off"]")
	logTheThing("diary", src, null, "toggled Death Confetti [deathConfettiActive ? "on" : "off"]", "admin")
	message_admins("[key_name(src)] toggled Death Confetti [deathConfettiActive ? "on" : "off"]")
