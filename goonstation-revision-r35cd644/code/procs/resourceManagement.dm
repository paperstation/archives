
/*********************************
* GENERIC HELPERS FOR BOTH SYSTEMS
*********************************/


//Generates file paths for browser resources when used in html tags e.g. <img>
/proc/resource(file)
	if (!file) return

	var/path
	if (CDN_ENABLED && cdn && config.env == "prod") //Or local tester with internet...
		path = "[cdn]/[file]"
	else
		if (findtext(file, "/"))
			var/list/parts = dd_text2list(file, "/")
			file = parts[parts.len]
		path = file

	return path


//Returns the file contents for storage in memory or further processing during runtime (e.g. many html files)
/proc/grabResource(path)
	if (!path) return 0

	var/file

	//File exists in cache, just return that
	if (!disableResourceCache && cachedResources[path])
		file = cachedResources[path]
	//Not in cache, go grab it
	else
		if (CDN_ENABLED && cdn && config.env == "prod") //Or local tester with internet...
			//Actually get the file contents from the CDN
			var/http[] = world.Export("[cdn]/[path]")
			if (!http || !http["CONTENT"])
				CRASH("CDN DEBUG: No file found for path: [path]")
				return ""
			file = file2text(http["CONTENT"])
		else //No CDN, grab from local directory
			file = parseAssetLinks(file("browserassets/[path]"))

		if (!disableResourceCache)
			cachedResources[path] = file

	return file


/proc/debugResourceCacheItem(path)
	if (cachedResources[path])
		return html_encode(cachedResources[path])
	else
		return "Not found"


/client/proc/debugResourceCache()
	set category = "Debug"
	set name = "Debug Resource Cache"
	set hidden = 1
	admin_only

	var/msg = "Resource cache contents:"
	for (var/r in cachedResources)
		msg += "<br>[r]"
	out(src, msg)


/client/proc/toggleResourceCache()
	set category = "Toggles"
	set name = "Toggle Resource Cache"
	set desc = "Enable or disable the resource cache system"
	admin_only

	disableResourceCache = !disableResourceCache
	boutput(usr, "<span style=\"color:blue\">Toggled the resource cache [disableResourceCache ? "off" : "on"]</span>")
	logTheThing("admin", usr, null, "toggled the resource cache [disableResourceCache ? "off" : "on"]")
	logTheThing("diary", usr, null, "toggled the resource cache [disableResourceCache ? "off" : "on"]", "admin")
	message_admins("[key_name(usr)] toggled the resource cache [disableResourceCache ? "off" : "on"]")


/*********************************
* CDN PROCS FOR LIVE SERVERS
*********************************/

//aint shit

/*********************************
* PROCS FOR LOCAL SERVER FALLBACK
*********************************/


//Replace placeholder tags with the raw filename (minus any subdirs), only for localservers
/proc/doAssetParse(path)
	if (findtext(path, "/"))
		var/list/parts = dd_text2list(path, "/")
		path = parts[parts.len]
	return path


//Converts placeholder tags to filepaths appropriate for local-hosting offline (absolute, no subdirs)
/proc/parseAssetLinks(file, path)
	if (!file) return 0

	//Get file extension
	if (path)
		var/list/parts = dd_text2list(path, ".")
		var/ext = parts[parts.len]
		ext = lowertext(ext)
		//Is this file a binary thing
		if (ext in list("jpg", "jpeg", "png", "svg", "bmp", "gif", "eot", "woff", "woff2", "ttf", "otf"))
			return 0

	//Look for resource placeholder tags. {{resource("path/to/file")}}
	var/fileText = file
	if (isfile(file))
		fileText = file2text(file)
	if (fileText && findtext(fileText, "{{resource"))
		var/regex/R = new("/\\{\\{resource\\(\"(.*?)\"\\)\\}\\}/\[resource($1)\]/ige")
		var/newtxt = R.Replace(fileText)
		while(newtxt)
			fileText = newtxt
			newtxt = R.ReplaceNext(fileText)

	return fileText


//Puts all files in a directory into a list
/proc/recursiveFileLoader(dir)
	for(var/i in flist(dir))
		//logTheThing("wiredebug", "<b>LOADER:</b> [i]")
		if (copytext(i, -1) == "/") //Is Directory
			if (i == "unused/" || i == "html/")
				continue
			else
				recursiveFileLoader(dir + i)
		else //Is file
			if (dir == "browserassets/") //skip files in base dir (hardcoding dir name here because im lazy ok)
				continue
			else
				localResources["[dir][i]"] = file("[dir][i]")


//#LongProcNames #yolo
/client/proc/loadResourcesFromList(list/rscList)
	for (var/r in rscList) //r is a file path
		var/fileRef = file(r)
		var/parsedFile = parseAssetLinks(fileRef, r)
		if (parsedFile) //file is text and has been parsed for filepaths
			var/newPath = "data/resources/[r]"
			if (copytext(newPath, -1) != "/" && fexists(newPath)) //"server" already has this file? apparently that causes ~problems~
				fdel(newPath)
			if (text2file(parsedFile, newPath)) //make a new file with the parsed text because byond fucking sucks at sending text as anything besides html
				src << browse(file(newPath), "file=[r];display=0")
			else
				world.log << "RESOURCE ERROR: Failed to convert text in '[r]' to a temporary file"
		else //file is binary just throw it at the client as is
			src << browse(fileRef, "file=[r];display=0")

	return 1


//A thing for coders locally testing to use (as they might be offline = can't reach the CDN)
/client/proc/loadResources()
	if ((CDN_ENABLED && config.env == "prod") || src.resourcesLoaded) return 0
	boutput(src, "<span style='color: blue;'><b>Resources are now loading, browser windows will open normally when complete.</b></span>")

	src.loadResourcesFromList(localResources)

	var/s = {"<html>
			<head></head>
			<body>
			<script type="text/javascript">
				window.location='byond://?src=\ref[src];action=resourcePreloadComplete';
			</script>
			</body
			</html>
			"}

	src << browse(s, "window=resourcePreload;titlebar=0;size=1x1;can_close=0;can_resize=0;can_scroll=0;border=0")
	src.resourcesLoaded = 1
	return 1