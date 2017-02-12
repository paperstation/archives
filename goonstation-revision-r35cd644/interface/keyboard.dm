datum
	proc
		// You can override the key_down and key_up procs
		// to add new commands. k is the name of the key
		// that was pressed (or released/repeated) and c
		// is the name of the client who triggered the event.
		key_up(k, client/c)
		key_down(k, client/c)

		// The key repeat and click event handling can be
		// disabled by defining these flags. They're enabled
		// by default, which means that the game client will
		// catch these events and notify the server. If you
		// never use these events in your game this communication
		// is unnecessary.
		#ifndef NO_KEY_REPEAT
		key_repeat(k, client/c)
		#endif

		#ifndef NO_CLICK
		click(object, client/c)
		#endif

var
	const
		ARROWS = "|west|east|north|south|"
		NUMPAD = "|west|east|north|south|northeast|southeast|northwest|southwest|center|numpad0|numpad1|numpad2|numpad3|numpad4|numpad5|numpad6|numpad7|numpad8|numpad9|divide|multiply|subtract|add|decimal|"
		EXTENDED = "|space|shift|ctrl|alt|escape|return|tab|back|delete|insert|"
		PUNCTUATION = "|`|-|=|\[|]|;|'|,|.|/|\\|"
		FUNCTION = "|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|"
		LETTERS = "|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|"
		NUMBERS = "|0|1|2|3|4|5|6|7|8|9|"

		ALL_KEYS = NUMPAD + EXTENDED + FUNCTION + LETTERS + NUMBERS + PUNCTUATION

client
	var
		// at compile time the keys var is a pipe-delimited list of
		// keys that will be macroed. At runtime, this is converted
		// to an associative list where keys[k] is zero or one, zero
		// if the key isn't being held and one if it is.
		list/keys = ALL_KEYS

		// whether or not input is locked. when input is
		// locked, the key_up/down/repeat procs aren't
		// called. an alternative is to just set the client's
		// focus to null isntead of locking input.
		input_lock = 0

		// the object that receives keyboard and mosue events.
		// when a keyboard event (press, release, or repeat)
		// occurs, the key_up/down/repeat proc is called for
		// the object referred to by the focus var.
		datum/focus

		use_numpad = 1

		// 1 = translate numpad4 to 4
		// 0 = leave numpad4 as "numpad4"
		translate_numpad_to_numbers = 1

		list/__numpad_mappings = list("numpad0" = "0", "numpad1" = "1", "numpad2" = "2", "numpad3" = "3", "numpad4" = "4", "numpad5" = "5", "numpad6" = "6", "numpad7" = "7", "numpad8" = "8", "numpad9" = "9", "divide" = "/", "multiply" = "*", "subtract" = "-", "add" = "+", "decimal" = ".")

	proc
		// While input is locked the KeyUp/Down/Repeat verbs still get called
		// but they don't call the key_up/down/repeat procs. While input is
		// locked the keys list gets updated, but only to indicate that keys
		// have been released.
		lock_input()
			input_lock = 1

		unlock_input()
			input_lock = 0

		clear_input(unlock_input = 1)
			if(unlock_input)
				unlock_input()

			for(var/k in keys)
				keys[k] = 0

	// These verbs are called for all key press, release, and repeat events.
	verb
		KeyDown(k as text)
			set hidden = 1
			set instant = 1

			// if input is locked, we do nothing.
			if(input_lock) return

			if(!use_numpad)
				if(k == "northeast")
					k = "page up"
				else if(k == "southeast")
					k = "page down"
				else if(k == "northwest")
					k = "home"
				else if(k == "southwest")
					k = "end"

			// convert numpad keys to their actual symbols
			if(translate_numpad_to_numbers)
				if(k in __numpad_mappings)
					k = __numpad_mappings[k]

			keys[k] = 1

			if(focus)
				if(hascall(focus, "key_down"))
					focus.key_down(k, src)
				else
					CRASH("'[focus]' does not have a key_down proc.")

		KeyUp(k as text)
			set hidden = 1
			set instant = 1

			if(!use_numpad)
				if(k == "northeast")
					k = "page up"
				else if(k == "southeast")
					k = "page down"
				else if(k == "northwest")
					k = "home"
				else if(k == "southwest")
					k = "end"

			// convert numpad keys to their actual symbols
			if(translate_numpad_to_numbers)
				if(k in __numpad_mappings)
					k = __numpad_mappings[k]

			// if input is locked, we still update the keys
			// list but that's it.
			keys[k] = 0
			if(input_lock) return

			if(focus)
				if(hascall(focus, "key_up"))
					focus.key_up(k, src)
				else
					CRASH("'[focus]' does not have a key_up proc.")

		#ifndef NO_KEY_REPEAT
		KeyRepeat(k as text)
			set hidden = 1
			set instant = 1

			// if input is locked we do nothing.
			if(input_lock) return

			if(focus)
				if(hascall(focus, "key_repeat"))
					focus.key_repeat(k, src)
				else
					CRASH("'[focus]' does not have a key_repeat proc.")
		#endif

	New()
		// by default, keyboard and mouse events are processed by the client
		focus = src

		// this will call mob.Login()
		..()

		// define the macros needed to capture all keyboard events
		set_macros()

	#ifndef NO_CLICK
	Click(object)
		..()

		if(focus)
			if(hascall(focus, "click"))
				focus.click(object, src)
			else
				CRASH("'[focus]' does not have a click proc.")
	#endif

	proc
		set_macros()
			// this should get us the list of all macro sets that
			// are used by all windows in the interface.
			var/macros = params2list(winget(src, null, "macro"))

			// if the keys var is a string, split it into key names
			if(istext(keys))
				keys = split(keys, "|")

			// define three macros (key press, release, and repeat)
			// for every key in every macro set.
			for(var/m in macros)
				for(var/k in keys)

					// It's possible to get empty strings in the list if the keys
					// var was set to ARROWS+NUMBERS, there may be "||" in the string
					// which turns into "" when split.
					if(!k) continue

					// By default the key isn't being held
					keys[k] = 0

					var/escaped = list2params(list("[k]"))

					// Create the necessary macros for this key.
					winset(src, "[m][k]Down", "parent=[m];name=[escaped];command=KeyDown+[escaped]")
					winset(src, "[m][k]Up", "parent=[m];name=[escaped]+UP;command=KeyUp+[escaped]")

					#ifndef NO_KEY_REPEAT
					winset(src, "[m][k]Repeat", "parent=[m];name=[escaped]+REP;command=KeyRepeat+\"[escaped]\"")
					#endif
