var/datum/telescope_manager/tele_man
var/list/special_places = list() //associative List of name=/datum/computer/file/coords that can not be reached normally. For use with the telescope
//Problem: JS fails to load content into the middle frame sometimes. clicking the computer again while window is open will show map for a second before it disappears again - together with the content. is it because we clear the html before setting new? clear it manually.
//TODO: Hidden locations. dont show up as unknown signals in list. can be found without being tracked.

/obj/lrteleporter
	name = "Experimental long-range teleporter"
	desc = "Well this looks somewhat unsafe."
	icon = 'icons/misc/32x64.dmi'
	icon_state = "lrport"
	density = 0
	anchored = 1
	var/busy = 0
	layer = 2

	attack_ai(mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		var/link_html = "<br>"

		if(special_places.len)
			for(var/A in special_places)
				var/datum/computer/file/coords/C = special_places[A]
				link_html += {"[A] <a href='?src=\ref[src];send=\ref[C]'><small>(Send)</small></a> <a href='?src=\ref[src];recieve=\ref[C]'><small>(Recieve)</small></a><br>"}
		else
			link_html = "<br>No co-ordinates available.<br>"

		var/html = {"<!doctype html>
			<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
			<html>
			<head>
			<title>Long-range teleporter</title>
			</head>
			<body style="overflow:auto;background-color: #eeeeee;">
			<p>Long-range destinations:</p><br>
			[link_html]
			</body>
			"}

		user.machine = src
		add_fingerprint(user)
		user << browse(html, "window=lrporter;size=250x380;can_resize=0;can_minimize=0;can_close=1")
		onclose(user, "lrporter", src)

	Topic(href, href_list)
		if(busy) return
		if(get_dist(usr, src) > 1 || usr.z != src.z) return

		if(href_list["send"])
			var/datum/computer/file/coords/C = locate(href_list["send"])
			var/turf/target = locate(C.destx, C.desty, C.destz)
			if(target)
				busy = 1
				flick("lrport1", src)
				playsound(src, 'sound/machines/lrteleport.ogg', 60, 1)
				for(var/atom/movable/M in src.loc)
					if(M.anchored) continue
					animate_teleport(M)
					if(ismob(M))
						var/mob/O = M
						O.stunned += 2
					spawn(6) M.set_loc(target)
				spawn(10) busy = 0

		if(href_list["recieve"])
			var/datum/computer/file/coords/C = locate(href_list["recieve"])
			var/turf/target = locate(C.destx, C.desty, C.destz)
			if(target)
				busy = 1
				flick("lrport1", src)
				playsound(src, 'sound/machines/lrteleport.ogg', 60, 1)
				for(var/atom/movable/M in target)
					if(M.anchored) continue
					animate_teleport(M)
					if(ismob(M))
						var/mob/O = M
						O.stunned += 2
					spawn(6) M.set_loc(src.loc)
				spawn(10) busy = 0

/datum/telescope_manager
	var/list/events_inactive = list()
	var/list/events_active = list()
	var/list/events_found = list()

	proc/setup()
		var/types = (typesof(/datum/telescope_event) - /datum/telescope_event)
		for(var/x in types)
			var/datum/telescope_event/R = new x(src)
			events_inactive.Add(R.id)
			events_inactive[R.id] = R
			if(!R.fixed_location)
				R.loc_x = rand(0, 600)
				R.loc_y = rand(0, 400)
		return

	proc/tick()
		return

	proc/onScan() //TBI update event list of all telecomps
		if(events_active.len < 3)
			if(events_inactive.len)
				var/picked = pick(events_inactive)
				var/datum/telescope_event/T = events_inactive[picked]
				events_active.Add(picked)
				events_active[picked] = T
				events_inactive.Remove(picked)
		return

/datum/telescope_event/sosvaliant
	name = "SS Valiant distress signal"
	name_undiscovered = "Unknown signal 23.23"
	desc = "This is a distress signal sent by the spaceship 'Valiant'.<br>The ship is not responding to hails.<br>It seems like there is currently no way to contact them."
	id = "valiantdistress"
	icon = "valiant.png"
	size = 10
	contact_verb = "CONTACT"
	contact_image = "audio.png" //Alternative image of the object for the contact screen. otherwise icon is used.

	onActivate(var/obj/machinery/computer/telescope/T)
		..()
		return

/datum/telescope_event/chainedpen
	name = "Weak transmission"
	name_undiscovered = "Weak signal"
	desc = "The transmission is very weak and the video signal is heavily degraded.<br>It's nearly impossible to make out what's going on.<br>There is no audio and there seems to be some sort of object in the foreground.<br>The background seems strangely empty."
	id = "thepen"
	icon = "secret.png"
	size = 10
	contact_verb = "VIEW"
	contact_image = "thesecretkey.png" //Alternative image of the object for the contact screen. otherwise icon is used.

	onActivate(var/obj/machinery/computer/telescope/T)
		..()
		playsound(T.loc, "sound/voice/femvox.ogg", 100, 0)
		return

/datum/telescope_event/geminorum
	name = "5604 Geminorum V"
	name_undiscovered = "Unknown beacon A23V"
	desc = "There appears to be some sort of signal beacon in a cave on this planet.<br>Scans show that the planet is strangely devoid of any sentient life despite it's lush vegetation.<br>An expedition would be required to find out more about this place.<br>Co-ordinates have been uploaded to the long-range teleporter."
	id = "geminorum"
	icon = "planet3.png"
	size = 15
	contact_verb = "SCAN"
	contact_image = "blueplanet.png" //Alternative image of the object for the contact screen. otherwise icon is used.

	onActivate(var/obj/machinery/computer/telescope/T)
		..()
		if(!special_places.Find(name))
			special_places.Add(name)
			var/datum/computer/file/coords/C = new()
			C.destx = 255
			C.desty = 3
			C.destz = 2
			special_places[name] = C
		return

/datum/telescope_event
	var/name = ""			   //Name which is shown after discovery
	var/name_undiscovered = "" //Name which is shown when you haven't found this event yet.
	var/desc = ""
	var/id = ""
	var/icon = ""
	//TBI Add rarity controls
	var/fixed_location = 0
	var/loc_x = 0
	var/loc_y = 0

	var/size = 10 			//The size of the spot you need to hit.

	var/contact_verb = "PING"
	var/contact_image = ""

	proc/onActivate(var/obj/machinery/computer/telescope/T)
		return

/obj/machinery/computer/telescope
	name = "quantum telescope"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_generic"

	var/mob/using = null

	var/tracking_id = "" //id of the event we're tracking/targeting.

	New()
		..()

	attack_ai(mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & (BROKEN|NOPOWER))
			return

		if(using && (!using.client || using.client.inactivity >= 1200 || get_dist(src, using) > 1))
			using << browse(null, "window=materials")
			using = null

		if(using && using != user)
			boutput(user, "<span style=\"color:red\">Somebody is already using that machine.</span>")
			return

		using = user

		//MAKE THE STATIC FLOAT SO STUFF CAN GO UNDER IT. POSITION ABSOLUTE ETC

		user.machine = src
		add_fingerprint(user)
		user << browse(grabResource("html/quantumTelescope.html"), "window=telescope;size=800x435;can_resize=0;can_minimize=0;can_close=1")
		onclose(user, "telescope", src)

		spawn(10)
			callJsFunc(usr, "setRef", list("\ref[src]")) //This is shit but without it, it calls the JS before the window is open and doesn't work.
			loadContent("Starmap", "#contentInner")
		return

	proc/loadContent(var/content, var/divId)
		var/newHtml = ""

		switch(content)
			if("EventList")
				if(tele_man)
					for(var/A in tele_man.events_active)
						var/datum/telescope_event/E = tele_man.events_active[A]
						newHtml += "<div id=\"event[E.id]\" style=\"margin:1px;border: 1px solid;border-color: #ccc;background-color: [A == tracking_id?"#444":"#000"];\">[E.name_undiscovered]</div>"
						newHtml += {"<script>$(function(){$( "#event[E.id]" ).click(function() {if(window.scanRunning){return;} callByond("trackId", \["id=[E.id]"\]);});});</script>"}

					for(var/A in tele_man.events_found)
						var/datum/telescope_event/E = tele_man.events_found[A]
						newHtml += "<div id=\"event[E.id]\" style=\"color:white;margin:1px;border: 1px solid;border-color: #ccc;background-color: [A == tracking_id?"#229922":"#004400"];\">[E.name]</div>"
						newHtml += {"<script>$(function(){$( "#event[E.id]" ).click(function() {if(window.scanRunning){return;} callByond("trackId", \["id=[E.id]"\]);});});</script>"}
			if("Starmap")
				var/foundlocs = ""
				if(tele_man && tele_man.events_found.len)
					for(var/A in tele_man.events_found)
						var/datum/telescope_event/E = tele_man.events_found[A] //Clicking on the icons doesnt work.
						foundlocs += {"<div id="iconclick[E.id]" style="z-index:4;border: [A == tracking_id ? "2px":"0px"] solid;border-color: #ffffff;width:32px;height:32px;position: absolute;left:[E.loc_x-16]px;top:[E.loc_y-16]px;padding:0px;margin:0px;"><img src="[resource("images/radioTelescope/[E.icon]")]" style="padding:0px;margin:0px;border:0px;"></div>"}

				newHtml = {"
				<div id="starmap" style="z-index:1;width:600px;height:400px;padding:0px;margin:0px;border:0px;overflow:hidden;background: url('[resource("images/radioTelescope/starmap.png")]');">
					<div id="scanner" class="tight" style="z-index:2;position:fixed;width:51px;height:51px;background: url('[resource("images/radioTelescope/scanner.png")]');"></div>
					<div id="scannertooltip" class="tight" style="z-index:2;position:fixed;width:85px;height:15px;background-color:black;color:green;border: 1px solid;border-color: #ffffff;"></div>
					<div id="scan" class="tight" style="z-index:2;display:none;position:fixed;top:0;left:0;width:20px;height:400px;background: url('[resource("images/radioTelescope/scan.png")]');"></div>
					<div id="static" class="tight" style="z-index:4;position:absolute;top:0;left:0;width:600px;height:400px;background: url('[resource("images/radioTelescope/static.gif")]');opacity: 0.05;filter: alpha(opacity=5);"></div>
					<div id="screen" class="tight" style="z-index:5;position:absolute;top:0;left:0;width:600px;height:400px;background: url('[resource("images/radioTelescope/screenoverlay.png")]');"></div>
					[foundlocs]
				</div>

				<script type="text/javascript">
					$(function(){
						$("#starmap").click(function(event) {
							if(window.scanRunning){
								return;
							}

					        var posX = $(this).position().left,
					            posY = $(this).position().top;

					        setHtmlId("#scannertooltip", "X: " + ((event.pageY - posY) - 25).toString() + " Y:" + ((event.pageX - posX) - 25).toString());

							$("#scannertooltip").offset({ top: (event.pageY - posY) + 18, left: (event.pageX - posX) + 30});
					        $("#scanner").offset({ top: (event.pageY - posY) - 25, left: (event.pageX - posX) - 25});
						});
					});
				</script>
				"}

		if(length(newHtml) && divId)
			callJsFunc(usr, "setHtmlId", list(divId, newHtml))

	Topic(href, href_list)
		//boutput(world, href)
		if(!using || get_dist(using, src) > 1)
			using << browse(null, "window=telescope")
			using = null
			return

		if(href_list["close"])
			using = null
		else if(href_list["jscall"])
			switch(href_list["jscall"])
				if("contact")
					if(tele_man.events_found.Find(tracking_id))
						var/datum/telescope_event/E = tele_man.events_found[tracking_id]
						var/html = ""
						html += {"<br><img src="[resource("images/radioTelescope/[length(E.contact_image) ? E.contact_image : E.icon]")]"style="padding:0px;margin:0px;border:0px;"> [E.name] @ [E.loc_x]-[E.loc_y]"}
						html += {"<p>[E.desc]</p>"}
						callJsFunc(usr, "setHtmlId", list("#contentInspect", html))
						callJsFunc(usr, "showContact", list())

				if("trackId")
					tracking_id = href_list["id"]
					loadContent("EventList", "#contentSide")
					if(tele_man && tracking_id)
						if(tele_man.events_active.Find(tracking_id))
							var/datum/telescope_event/E = tele_man.events_active[tracking_id]
							callJsFunc(usr, "setHtmlId", list("#statusText", "Now tracking: [E.name_undiscovered]"))
							callJsFunc(usr, "setHtmlId", list("#contentContact", ""))
						else if(tele_man.events_found.Find(tracking_id))
							var/datum/telescope_event/E = tele_man.events_found[tracking_id]
							callJsFunc(usr, "setHtmlId", list("#statusText", "Now targeting: [E.name]"))
							callJsFunc(usr, "setHtmlId", list("#contentContact", "[E.contact_verb]"))

						loadContent("Starmap", "#contentInner")

				if("scanComplete")
					if(tele_man)
						tele_man.onScan()
						if(tracking_id)
							if(tele_man.events_active.Find(tracking_id))
								var/datum/telescope_event/E = tele_man.events_active[tracking_id]
								var/posx = text2num(href_list["posx"])
								var/posy = text2num(href_list["posy"])
								var/distx = abs(posx - E.loc_x)
								var/disty = abs(posy - E.loc_y)

								if(distx + disty <= E.size) //REVERT CONDITION TO NORMAL AFTER TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									E.onActivate(src)
									tele_man.events_active.Remove(tracking_id)
									tele_man.events_found.Add(tracking_id)
									tele_man.events_found[tracking_id] = E
									tracking_id = ""
									loadContent("Starmap", "#contentInner")

								callJsFunc(usr, "setHtmlId", list("#statusText", "Distance: [distx + disty] LY"))

					loadContent("EventList", "#contentSide")
				if("closeWindow")
					usr << browse(null, "window=telescope")
					using = null
				if("loadContent")
					var/contentName = href_list["name"]
					var/targetCont = href_list["target"]
					loadContent(contentName, targetCont)

		src.add_fingerprint(usr)
		callJsFunc(usr, "setRef", list("\ref[src]"))
		return


	proc/callJsFunc(var/client, var/funcName, var/list/params)
		var/paramsJS = list2params(params)
		client << output(paramsJS,"telescope.browser:[funcName]")
		return