/*
Tooltips v1.1 - 22/10/15
Developed by Wire (#goonstation on irc.synirc.net)
- Added support for screen_loc pixel offsets. Should work. Maybe.
- Added init function to more efficiently send base vars

Configuration:
- Set control to the correct skin element (remember to actually place the skin element)
- Set file to the correct path for the .html file (remember to actually place the html file)
- Attach the datum to the user client on login, e.g.
	/client/New()
		src.tooltips = new /datum/tooltip(src)

Usage:
- Define mouse event procs on your (probably HUD) object and simply call the show and hide procs respectively:
	/obj/screen/hud
		MouseEntered(location, control, params)
			usr.client.tooltip.show(src, params, title = src.name, content = src.desc)

		MouseExited()
			usr.client.tooltip.hide()
- You may use flags defined below this comment block to tweak the tooltip. For example to align it centered:
	usr.client.tooltip.show(src, params, title = src.name, content = src.desc, flags = TOOLTIP_CENTERED)

Customization:
- Theming can be done by passing the theme var to show() and using css in the html file to change the look
- For your convenience some pre-made themes are included

Notes:
- You may have noticed 90% of the work is done via javascript on the client. Gotta save those cycles man.
- This is entirely untested in any other codebase besides goonstation so I have no idea if it will port nicely. Good luck!
*/

//Alignment around the turf. Any can be combined with center (top and bottom for horizontal centering, left and right for vertical).
#define TOOLTIP_BOTTOM 0
#define TOOLTIP_TOP 1
#define TOOLTIP_RIGHT 2
#define TOOLTIP_LEFT 4
#define TOOLTIP_CENTER 8

/datum/tooltip
	var
		client/owner
		control = "mainwindow.tooltip"
		file = "html/tooltip.html"
		showing = 0
		queueHide = 0
		init = 0


	New(client/C)
		if (C)
			src.owner = C

			//For local-testing fallback
			if (!CDN_ENABLED || config.env == "dev")
				var/list/tooltipResources = list(
					"browserassets/js/jquery.min.js",
					"browserassets/js/tooltip.js",
					"browserassets/css/tooltip.css"
				)
				src.owner.loadResourcesFromList(tooltipResources)

			src.owner << browse(grabResource(src.file), "window=[src.control]")

		..()


	proc/show(atom/movable/thing, params = null, title = null, content = null, theme = "default", special = "none", flags = 0)
		if (!thing || !params || (!title && !content) || !src.owner || !isnum(flags)) return 0
		if (!src.init)
			//Initialize some vars
			src.init = 1
			src.owner << output(list2params(list(world.icon_size, src.control)), "[src.control]:tooltip.init")

		src.showing = 1

		if (title && content)
			title = "<h1>[title]</h1>"
			content = "<p>[content]</p>"
		else if (title && !content)
			title = "<p>[title]</p>"
		else if (!title && content)
			content = "<p>[content]</p>"

		if (theme == "default" && "tooltipTheme" in thing.vars)
			theme = thing.vars["tooltipTheme"]

		if (special == "none" && "tooltipSpecial" in thing.vars)
			special = thing.vars["tooltipSpecial"]

		//Dumb special case handling that I can't think of a better solution for
		if (src.owner.mob && (istype(src.owner.mob.loc, /obj/machinery/vehicle/pod_smooth) || istype(src.owner.mob.loc, /obj/machinery/vehicle/miniputt) || istype(src.owner.mob.loc, /obj/machinery/colosseum_putt)))
			special = "pod"

		//Make our dumb param object
		var/extra = "\["
		if (flags)
			if (flags & TOOLTIP_TOP)
				extra += "\"top\","
			if (flags & TOOLTIP_RIGHT)
				extra += "\"right\","
			if (flags & TOOLTIP_LEFT)
				extra += "\"left\","
			if (flags & TOOLTIP_CENTER)
				extra += "\"center\","
		extra = "[(flags ? copytext(extra, 1, -1) : extra)]\]"
		params = {"{ "cursor": "[params]", "screenLoc": "[thing.screen_loc]", "flags": [extra] }"}

		//out(src.owner, "Params: [params]. Theme: [theme]. Special: [special]") //DEBUG

		//Send stuff to the tooltip
		src.owner << output(list2params(list(params, src.owner.view, "[title][content]", theme, special)), "[src.control]:tooltip.update")

		//If a hide() was hit while we were showing, run hide() again to avoid stuck tooltips
		src.showing = 0
		if (src.queueHide)
			src.hide()

		return 1


	proc/hide()
		if (src.queueHide)
			spawn(1)
				winshow(src.owner, src.control, 0)
		else
			winshow(src.owner, src.control, 0)

		src.queueHide = src.showing ? 1 : 0

		return 1

/*
// DEBUG
/client/verb/reloadTooltip()
	set name = "Reload Tooltip"

	src.tooltip = null
	src.tooltip = new(src)

	out(src, "Reloaded")
*/