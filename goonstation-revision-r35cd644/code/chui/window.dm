var/testes = 0
#define CHUI_FLAG_SIZABLE 1
#define CHUI_FLAG_MOVABLE 2
#define CHUI_FLAG_FADEIN 4

chui/window
	//The windows name is what is displayed in the titlebar.
	//It does not need to be unique, and is just a utility.
	var/name = "Untitled Window"

	//This is a list of people that have the window currently open.
	//It is preferable you use verify first.
	var/list/client/subscribers = new

	//This is the desired theme. Make sure it is set to a text string.
	//It is automatically changed to the datum type in New()
	var/chui/theme/theme = "base"

	//This is the atom the window is attached to. Can be set in New()
	//If set, Chui will use it to determine whether or not the viewer
	//is both in range and is fully conscious to be using the window and
	//for receiving updates.
	var/atom/theAtom

	//This is the active template. The template engine is currently incomplete.
	//However, you can set this to a text string (or file; it'll load the file into the var
	//required) to have the panel's body set to it when necessary. Preferable to automatic
	//generation as to not pollute the string table.
	var/chui/template/template = null

	//A list of sections. Will eventually work by being an associative list of templates.
	//You will be able to call .SetSection( name ) or set the section via code.
	//It will allow you to split up your window into multiple HTML files/code.
	var/list/sections = list()        //Section system, is a TODO.

	//The list of Chui flags. Not currently used to its full potential.
	//CHUI_FLAG_SIZABLE -> Allows the window to be resized.
	//CHUI_FLAG_MOVABLE -> Allows the window to be moved.
	var/flags = CHUI_FLAG_SIZABLE | CHUI_FLAG_MOVABLE

	//If overriden, be sure to call ..()
	New()
		theme = chui.GetTheme( theme )

	//Override this if you have a DM defined window.
	//Returns the HTML the window will have.
	proc/GetBody()
		if( template )
			if( isfile( template ) )
				template = file2text( template )
				return template
			else if( istext( template ) )
				return template
			return template.Generate()
		return "Untemplated Window."


	//Do not call directly.
	//Called to generate HTML for a client and desired body text.
	proc/generate(var/client/victim, var/body)
		var/list/params = list( "js" = list(), "css" = list(), "title" = src.name, data = list( "ref" = "\ref[src]", "flags" = flags ) )//todo, better this.
		return theme.generateHeader(params) + theme.generateBody( body, params ) + theme.generateFooter()

	//Subscribe a client to use this window.
	//Chui will open the window on their client and have its content set appropriately.
	//The window ref is the \ref[src] of the window.
	proc/Subscribe( var/client/who )
		CDBG1( "[who] subscribed to [name]" )
		subscribers += who
		//theme.streamToClient( who )
		who << browse( src.generate(who, src.GetBody()), "window=\ref[src];titlebar=0;can_close=0;can_resize=0;can_scroll=0;border=0" )
		winset( who, "\ref[src]", "on-close \".chui-close \ref[src]\"" )


	//Returns true if the client is subscribed.
	//Will also perform a validation check and unsubscribe those who don't pass it.
	//Use of this is preferable to using the subscribers var; but is appropriately slower.
	proc/IsSubscribed( var/client/whom )
		var/actuallySubbed = (whom in subscribers)
		if( actuallySubbed && Validate( whom ) )
			return 1
		else if( actuallySubbed )
			Unsubscribe( whom )
		return 0


	//Unsubscribes a client from the window.
	//Will also close the window.
	proc/Unsubscribe( client/who )
		CDBG1( "[who] unsubscribed to [name]" )
		subscribers -= who
		who << browse( null, "window=\ref[src]" )

	//See /client/proc/Browse instead.
	proc/bbrowse( client/who, var/body, var/options )
		var/list/config = params2list( options )
		var/name = config[ "window" ]
		if( isnull( body ) )
			usr << browse( null, options )
			return
		if( !name )
			CRASH( "No window name given" )
		var/flags = CHUI_FLAG_MOVABLE
		if( isnull(config["can_resize"]) || text2num(config["can_resize"]) )
			flags |= CHUI_FLAG_SIZABLE
		if( config["fade_in"] && text2num( config["fade_in"] ) )
			flags |= CHUI_FLAG_FADEIN
		var/title = config["title"]
		var/list/built = list( "js" = list(), "css" = list(), "title" = (title || "1-800 Coder"), data = list( "ref" = name, "flags" = flags ) )//todo, better this.
		who << browse( theme.generateHeader(built) + theme.generateBody( body, built ) + theme.generateFooter(), "titlebar=0;can_close=0;can_resize=0;can_scroll=0;border=0;[options]" )
		winset( who, "\ref[src]", "on-close \".chui-close \ref[src]\"" )
		//theme.streamToClient( who )

	//Check if a client should actually be subscribed.
	//Can be used to check if someone is subscribed without unsubscribing them
	//if they don't check out.
	proc/Validate( client/cli )
		if( !cli )
			return 0
		//if( !victim.stat && !(panel.flags & chui_FLAG_USEDEAD) ) return -1
		if( !(cli in subscribers) )
			//wow this is some jerk.. i blame spacenaba
			CDBG2( "Validation failed for [cli] -- Not subscribed." )
			return 0
		if( winget( cli, "\ref[src]", "is-visible" ) == "false" )
			CDBG2( "Validation failed for [cli] -- Not visible." )
			return 0
		if( theAtom && get_dist( cli.mob.loc, theAtom.loc ) > 2 )
			CDBG2( "Validation failed for [cli] -- Too far." )
			return 0
		return 1

	//Calls a Javascript function with a set number of arguments on everyone subscribed.
	//For prediction, you can include a client to exclude from this.
	proc/CallJSFunction( var/fname, var/list/arguments, var/client/exclude )
		for( var/client/c in subscribers )
			if( !Validate( c ) )
				Unsubscribe( c )
		for( var/i = 1, i <= subscribers.len, i++ )
			subscribers[ i ] << output( "[list2params( arguments )]", "\ref[src].browser:[fname]" )

	//Called when a template variable changes.
	//
	proc/OnVar( var/name, var/value, var/setFromDM )

	//A list of template vars
	var/list/templateVars = new

	//Sets a template var and displays it.
	proc/SetVar( var/name, var/value )
		templateVars[ name ] = value
		CallJSFunction( "chui.templateSet", list( name, value ) )
		OnVar( name, value, 1 )

	//Gets a template var
	proc/GetVar( var/name )
		return templateVars[ name ]

	//Generates a template var; use it for cases of inline HTML.
	proc/template( var/name, var/value )
		if( !templateVars[ name ] )
			templateVars[ name ] = value
		return "<span id='chui-tmpl-[name]'>[templateVars[ name ] || "please wait..."]</span>"
	//UNUSED..
	/*
	proc/_transfer( var/largebodyoftext )
		if( 1 )
			CallJSFunction( "chui.onReceive", list( largebodyoftext ) )
			return
		var/chunkCount = length( largebodyoftext ) / CHUNK_SIZE
		var/id = ++src.xferID
		callJSFunction( "chui._setupReceive", list( "chunkcount" = chunkCount, "finalLength" = length( largebodyoftext ), list( "id" = id ) )
		for( var/i = 1, i <= chunkCount, i++ )
			callJSFunction( "chui._chunk", list( "id" = id, "chunk" = copytext( largebodyoftext, i * CHUNK_SIZE, (i+1) * CHUNK_SIZE )
		callJSFunction( "chui._finishReceive", list( "id" = id )*/

	//Override this instead of Topic()
	proc/OnTopic( href, href_list[] )
	//Called when a theme button is clicked.
	proc/OnClick( var/id )
	//Called when Javascript sends a request; return with data to be given back to JS.
	proc/OnRequest( var/method, var/list/data )
		return template.OnRequest( method, data )
	Topic( href, href_list[] )
		if( !IsSubscribed( usr.client ) )
			usr << browse( null, "window=\ref[src]" )
			return
		var/action = href_list[ "_cact" ]
		if( !isnull( action ) )
			if( action == "section" && !isnull( href_list[ "section" ] ) && href_list[ "section" ] in sections )
				if( !hascall( src, href_list[ "section" ] + "Section" ) )
					boutput( src, "<span style='color: #f00'>Call 1-800 CODER.</span>" )
					throw EXCEPTION( "1-800 Coder: you allowed a section that doesn't exist!!! RAAHHHH" )
				call( href_list[ "section" ], src )( href_list )
			else if( action == "request" )
				var/method = href_list[ "_path" ]
				var/id = href_list[ "_id" ]
				if( isnull( method ) || isnull( id ) )
					world << "FATAL: Null ID/Method for BYREQ."
					return
				//TODO: When JSON is included. callJSFunction( "chui.reqReturn",
			else if( action == "click" && href_list["id"] )
				OnClick( usr.client, href_list["id"] )
			else
				OnTopic( usr.client, href, href_list )
		else
			OnTopic( href, href_list )


//Called when the close button is clicked on both
/client/verb/chuiclose( var/window as text )
	set name = ".chui-close"
	set hidden = 1
	var/chui/window/win = locate( window )

	//istype( win ) && win.Unsubscrbe( src )
	if( istype( win ) )
		win.Unsubscribe( src )
	else
		src << browse( null, "window=[window]" )//Might not be a standard chui window but we'll play along.

//A chui substitute for usr << browse()
//Mostly the same syntax.
client/proc/Browse( var/html, var/opts )
	chui.staticinst.bbrowse( src, html, opts )

mob/proc/Browse( var/html, var/opts )
	if( src.client )
		chui.staticinst.bbrowse( src.client, html, opts )

//#define browse #error Use --.Browse() instead.