#define CDBG1(msg)
#define CDBG2(msg)
#define CDBG3(msg)
#ifdef DEBUG
#define CHUI_VERBOSITY 2

#define CDBG(verbosity, msg) world << "<b>chui <u>[verbosity]</u></b>: [msg]"

#if CHUI_VERBOSITY >= 1
#define CDBG1(msg) CDBG( "(INFO)", msg )
#if CHUI_VERBOSITY >= 2
#define CDBG2(msg) CDBG( "(DEBUG)", msg )
#if CHUI_VERBOSITY >= 3
#define CDBG3(msg) CDBG( "(VERBOSE)", msg )
#endif
#endif
#endif

#endif

chui/engine
	var/global/list/chui/theme/themes = list()
	var/chui/window/staticinst

	New()
		if( themes.len == 0 )
			for( var/thm in typesof( "/chui/theme" ) )
				themes += new thm()
		spawn(0)
			staticinst = new
		//staticinst.theme = themes[1]//fart

	proc/GetTheme( var/name )
		for( var/i = 1, i < themes.len, i++ )
			var/chui/theme/theme = themes[ i ]
			if( theme.name == name )
				return theme
		return themes[1]

	/*
	proc/RscStream( var/client/victim, var/list/resources )
		CDBG2( "Transfering resources..." )
		for( var/rsc in resources )
			rsc = file("[rsc]")
			CDBG3( "Transfering [rsc]" )
			victim << browse( rsc, "display=0" )
		CDBG2( "Complete." )
	*/

var/global/chui/engine/chui
world/New()
	. = ..()
	chui = new()