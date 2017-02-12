/datum/parse_result
	var/string = ""
	var/chars_used = 0

/datum/text_roamer
	var/string = ""
	var/curr_char_pos = 0
	var/curr_char = ""
	var/prev_char = ""
	var/next_char = ""
	var/next_next_char = ""
	var/next_next_next_char = ""

	New(var/str)
		if(isnull(str))	qdel(src)
		string = str
		curr_char_pos = 1
		curr_char = copytext(string,curr_char_pos,curr_char_pos+1)
		if(length(string) > 1) next_char = copytext(string,curr_char_pos+1,curr_char_pos+2)
		if(length(string) > 2) next_next_char = copytext(string,curr_char_pos+2,curr_char_pos+3)
		if(length(string) > 3) next_next_next_char = copytext(string,curr_char_pos+3,curr_char_pos+4)
	proc

		in_word()
			if(prev_char != "" && prev_char != " " && next_char != "" && next_char != " ") return 1
			else return 0

		end_of_word()
			if(prev_char != "" && prev_char != " " && (next_char == "" || next_char == " ") ) return 1
			else return 0

		alone()
			if((prev_char == "" || prev_char == " ") && (next_char == "" || next_char == " ") ) return 1
			else return 0

		update()
			curr_char = copytext(string,curr_char_pos,curr_char_pos+1)

			if(curr_char_pos + 1 <= length(string))
				next_char = copytext(string,curr_char_pos+1,curr_char_pos+2)
			else
				next_char = ""

			if(curr_char_pos + 2 <= length(string))
				next_next_char = copytext(string,curr_char_pos+2,curr_char_pos+3)
			else
				next_next_char = ""

			if(curr_char_pos + 3 <= length(string))
				next_next_next_char = copytext(string,curr_char_pos+3,curr_char_pos+4)
			else
				next_next_next_char = ""

			if(curr_char_pos - 1  >= 1)
				prev_char = copytext(string,curr_char_pos-1,curr_char_pos)
			else
				prev_char = ""

			return

		next()
			if(curr_char_pos + 1 <= length(string))
				curr_char_pos++

			curr_char = copytext(string,curr_char_pos,curr_char_pos+1)

			if(curr_char_pos + 1 <= length(string))
				next_char = copytext(string,curr_char_pos+1,curr_char_pos+2)
			else
				next_char = ""

			if(curr_char_pos + 2 <= length(string))
				next_next_char = copytext(string,curr_char_pos+2,curr_char_pos+3)
			else
				next_next_char = ""

			if(curr_char_pos + 3 <= length(string))
				next_next_next_char = copytext(string,curr_char_pos+3,curr_char_pos+4)
			else
				next_next_next_char = ""

			if(curr_char_pos - 1  >= 1)
				prev_char = copytext(string,curr_char_pos-1,curr_char_pos)
			else
				prev_char = ""

			return

		prev()

			if(curr_char_pos - 1 >= 1)
				curr_char_pos--

			curr_char = copytext(string,curr_char_pos,curr_char_pos+1)

			if(curr_char_pos + 1 <= length(string))
				next_char = copytext(string,curr_char_pos+1,curr_char_pos+2)
			else
				next_char = ""

			if(curr_char_pos + 2 <= length(string))
				next_next_char = copytext(string,curr_char_pos+2,curr_char_pos+3)
			else
				next_next_char = ""

			if(curr_char_pos + 3 <= length(string))
				next_next_next_char = copytext(string,curr_char_pos+3,curr_char_pos+4)
			else
				next_next_next_char = ""

			if(curr_char_pos - 1  >= 1)
				prev_char = copytext(string,curr_char_pos-1,curr_char_pos)
			else
				prev_char = ""

			return

/proc/elvis_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(R.curr_char)
		if("t")
			if(R.next_char == "i" && R.next_next_char == "o" && R.next_next_next_char == "n")
				new_string = "shun"
				used = 4
			else if(R.next_char == "h" && R.next_next_char == "e")
				new_string = "tha"
				used = 3
			else if(R.next_char == "h" && (R.next_next_char == " " || R.next_next_char == "," || R.next_next_char == "." || R.next_next_char == "-"))
				new_string = "t" + R.next_next_char
				used = 3
		if("T")
			if(R.next_char == "I" && R.next_next_char == "O" && R.next_next_next_char == "N")
				new_string = "SHUN"
				used = 4
			else if(R.next_char == "H" && R.next_next_char == "E")
				new_string = "THA"
				used = 3
			else if(R.next_char == "H" && (R.next_next_char == " " || R.next_next_char == "," || R.next_next_char == "." || R.next_next_char == "-"))
				new_string = "T" + R.next_next_char
				used = 3

		if("u")
			if (R.prev_char != " " || R.next_char != " ")
				new_string = "uh"
				used = 2
		if("U")
			if (R.prev_char != " " || R.next_char != " ")
				new_string = "UH"
				used = 2

		if("o")
			if (R.next_char == "w"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "aw"
				used = 2
			else if (R.prev_char != " " || R.next_char != " ")
				new_string = "ah"
				used = 1
		if("O")
			if (R.next_char == "W"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "AW"
				used = 2
			else if (R.prev_char != " " || R.next_char != " ")
				new_string = "AH"
				used = 1

		if("i")
			if (R.next_char == "r"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "ahr"
				used = 2
			else if(R.next_char == "n" && R.next_next_char == "g")
				new_string = "in'"
				used = 3
		if("I")
			if (R.next_char == "R"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "AHR"
				used = 2
			else if(R.next_char == "N" && R.next_next_char == "G")
				new_string = "IN'"
				used = 3

		if("e")
			if (R.next_char == "n"  && R.next_next_char == " ")
				new_string = "un "
				used = 3
			if (R.next_char == "r"  && R.next_next_char == " ")
				new_string = "ah "
				used = 3
			else if (R.next_char == "w"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "yew"
				used = 2
			else if(R.next_char == " " && R.prev_char == " ") ///!!!
				new_string = "ee"
				used = 1
		if("E")
			if (R.next_char == "N"  && R.next_next_char == " ")
				new_string = "UN "
				used = 3
			if (R.next_char == "R"  && R.next_next_char == " ")
				new_string = "AH "
				used = 3
			else if (R.next_char == "W"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "YEW"
				used = 2
			else if(R.next_char == " " && R.prev_char == " ") ///!!!
				new_string = "EE"
				used = 1

		if("a")
			if (R.next_char == "u")
				new_string = "ah"
				used = 2
			else if (R.next_char == "n")
				new_string = "ain"
				used =  (R.next_next_char == "d" ? 3 : 2)
		if("A")
			if (R.next_char == "U")
				new_string = "AH"
				used = 2
			else if (R.next_char == "N")
				new_string = "AIN"
				used =  (R.next_next_char == "D" ? 3 : 2)

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

/proc/borkborkbork_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(R.curr_char)
		if("f")
			if(R.prev_char != " " || R.next_char != " ")
				new_string = "ff"
				used = 1
		if("F")
			if(R.prev_char != " " || R.next_char != " ")
				new_string = "FF"
				used = 1

		if("w")
			new_string = "v"
			used = 1
		if("W")
			new_string = "V"
			used = 1

		if("v")
			new_string = "f"
			used = 1
		if("V")
			new_string = "F"
			used = 1

		if("t")
			if(R.next_char == "i" && R.next_next_char == "o" && R.next_next_next_char == "n")
				new_string = "shun"
				used = 4
			else if(R.next_char == "h" && R.next_next_char == "e")
				new_string = "zee"
				used = 3
			else if(R.next_char == "h" && (R.next_next_char == " " || R.next_next_char == "," || R.next_next_char == "." || R.next_next_char == "-"))
				new_string = "t" + R.next_next_char
				used = 3
		if("T")
			if(R.next_char == "I" && R.next_next_char == "O" && R.next_next_next_char == "N")
				new_string = "SHUN"
				used = 4
			else if(R.next_char == "H" && R.next_next_char == "E")
				new_string = "ZEE"
				used = 3
			else if(R.next_char == "H" && (R.next_next_char == " " || R.next_next_char == "," || R.next_next_char == "." || R.next_next_char == "-"))
				new_string = "T" + R.next_next_char
				used = 3

		if("u")
			if (R.prev_char != " " || R.next_char != " ")
				new_string = "oo"
				used = 1
		if("U")
			if (R.prev_char != " " || R.next_char != " ")
				new_string = "OO"
				used = 1

		if("o")
			if (R.next_char == "w"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "oo"
				used = 2
			else if (R.prev_char != " " || R.next_char != " ")
				new_string = "u"
				used = 1
			else if(R.next_char == " " && R.prev_char == " ") ///!!!
				new_string = "oo"
				used = 1
		if("O")
			if (R.next_char == "W"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "OO"
				used = 2
			else if (R.prev_char != " " || R.next_char != " ")
				new_string = "U"
				used = 1
			else if(R.next_char == " " && R.prev_char == " ") ///!!!
				new_string = "OO"
				used = 1

		if("i")
			if (R.next_char == "r"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "ur"
				used = 2
			else if(R.prev_char != " " || R.next_char != " ")
				new_string = "ee"
				used = 1
		if("I")
			if (R.next_char == "R"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "UR"
				used = 2
			else if(R.prev_char != " " || R.next_char != " ")
				new_string = "EE"
				used = 1

		if("e")
			if (R.next_char == "n"  && R.next_next_char == " ")
				new_string = "ee "
				used = 3
			else if (R.next_char == "w"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "oo"
				used = 2
			else if ((R.next_char == " " || R.next_char == "," || R.next_char == "." || R.next_char == "-") && R.prev_char != " ")
				new_string = "e-a" + R.next_char
				used = 2
			else if(R.next_char == " " && R.prev_char == " ") ///!!!
				new_string = "i"
				used = 1
		if("E")
			if (R.next_char == "N"  && R.next_next_char == " ")
				new_string = "EE "
				used = 3
			else if (R.next_char == "W"  && (R.prev_char != " " || R.next_next_char != " "))
				new_string = "OO"
				used = 2
			else if ((R.next_char == " " || R.next_char == "," || R.next_char == "." || R.next_char == "-")  && R.prev_char != " ")
				new_string = "E-A" + R.next_char
				used = 2
			else if(R.next_char == " " && R.prev_char == " ") ///!!!
				new_string = "i"
				used = 1

		if("a")
			if (R.next_char == "u")
				new_string = "oo"
				used = 2
			else if (R.next_char == "n")
				new_string = "un"
				used = 2
			else
				new_string = "e" //{WC} ?
				used = 1
		if("A")
			if (R.next_char == "U")
				new_string = "OO"
				used = 2
			else if (R.next_char == "N")
				new_string = "UN"
				used = 2
			else
				new_string = "E" //{WC} ?
				used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P

/proc/tommy_parse(var/datum/text_roamer/R)
	var/S = R.curr_char
	var/new_string = ""
	var/used = 1

	switch(S)
		if("a")
			new_string = "ah"
			used = 1
		if("A")
			new_string = "AH"
			used = 1
		if("e")
			switch(rand(1,2))
				if(1)
					new_string = "ee"
				if(2)
					new_string = "ea"
			used = 1
		if("E")
			switch(rand(1,2))
				if(1)
					new_string = "EE"
				if(2)
					new_string = "EA"
			used = 1
		if("i")
			new_string = "ii"
			used = 1
		if("I")
			new_string = "II"
			used = 1
		if("o")
			if(R.next_char == "u")
				new_string = "oou"
				used = 1
			else
				new_string = "oe"
				used = 1
		if("O")
			if(R.next_char == "U")
				new_string = "OOU"
				used = 1
			else
				new_string = "OE"
				used = 1
		if("u")
			if(R.next_char == " " || R.next_char == "." || R.next_char == "!" || R.next_char == "?" || R.next_char == ",")
				new_string = "ue"
				used = 1
			else if(prob(50))
				new_string = "uu"
				used = 1
		if("U")
			if(R.next_char == " " || R.next_char == "." || R.next_char == "!" || R.next_char == "?" || R.next_char == ",")
				new_string = "UE"
				used = 1
			else if(prob(50))
				new_string = "UU"
				used = 1
		if("h")
			if(R.next_char == "y")
				new_string = "hai"
				used = 2
		if("H")
			if(R.next_char == "Y")
				new_string = "HAI"
				used = 2
		if("r")
			if(R.next_char != "h")
				new_string = "wh"
				used = 2
			else if(R.prev_char != "h")
				new_string = "hw"
				used = 2
			else
				new_string = "w"
				used = 1
		if("R")
			if(R.next_char != "H")
				new_string = "WH"
				used = 2
			else if(R.prev_char != "H")
				new_string = "HW"
				used = 2
			else
				new_string = "W"
				used = 1

	if(!new_string)
		new_string = R.curr_char
		used = 1
	else if(prob(10))
		new_string = uppertext(new_string)

	var/datum/parse_result/P = new
	P.string = new_string
	P.chars_used = used
	return P


/proc/tommify(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = tommy_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	if(copytext(string, length(string)) == "!")
		modded = uppertext(modded) + "!!"
	else if(prob(50) && (copytext(string, length(string)) == "?"))
		modded = uppertext(modded) + "?[ prob(50) ? " HUH!?" : null]"
	return modded

/proc/borkborkbork(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = borkborkbork_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	if(prob(15))
		modded += " Bork Bork Bork!"
	if(prob(5))
		modded += " Bork."

	return modded

/proc/elvisfy(var/string)
	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = elvis_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	if(prob(15)) modded += pick(", uh huh.", ", alright?", ", mmhmm.", ", y'all.");

	return modded

/proc/voidSpeak(var/message) // sharing the creepiness with everyone!!
	if (!message)
		return

	var/fontSize = 1
	var/fontIncreasing = 1
	var/fontSizeMax = 3
	var/fontSizeMin = -3
	var/messageLen = length(message)
	var/processedMessage = ""

	for (var/i = 1, i <= messageLen, i++)
		processedMessage += "<font size=[fontSize]>[copytext(message, i, i+1)]</font>"
		if (fontIncreasing)
			fontSize = min(fontSize+1, fontSizeMax)
			if (fontSize >= fontSizeMax)
				fontIncreasing = 0
		else
			fontSize = max(fontSize-1, fontSizeMin)
			if (fontSize <= fontSizeMin)
				fontIncreasing = 1


	return "<i><b>[processedMessage]</b></i>"

// zalgo text proc, borrowed from eeemo.net

//those go UP
var/list/zalgo_up = list(
	"&#x030d;", 		"&#x030e;", 		"&#x0304;", 		"&#x0305;", 
	"&#x033f;", 		"&#x0311;", 		"&#x0306;", 		"&#x0310;", 
	"&#x0352;", 		"&#x0357;", 		"&#x0351;", 		"&#x0307;", 
	"&#x0308;", 		"&#x030a;", 		"&#x0342;", 		"&#x0343;", 
	"&#x0344;", 		"&#x034a;", 		"&#x034b;", 		"&#x034c;", 
	"&#x0303;", 		"&#x0302;", 		"&#x030c;", 		"&#x0350;", 
	"&#x0300;", 		"&#x0301;", 		"&#x030b;", 		"&#x030f;", 
	"&#x0312;", 		"&#x0313;", 		"&#x0314;", 		"&#x033d;", 
	"&#x0309;", 		"&#x0363;", 		"&#x0364;", 		"&#x0365;", 
	"&#x0366;", 		"&#x0367;", 		"&#x0368;", 		"&#x0369;", 
	"&#x036a;", 		"&#x036b;", 		"&#x036c;", 		"&#x036d;", 
	"&#x036e;", 		"&#x036f;", 		"&#x033e;", 		"&#x035b;", 
	"&#x0346;", 		"&#x031a;" 
)

//those go DOWN
var/list/zalgo_down = list(
	"&#x0316;", 		"&#x0317;", 		"&#x0318;", 		"&#x0319;", 
	"&#x031c;", 		"&#x031d;", 		"&#x031e;", 		"&#x031f;", 
	"&#x0320;", 		"&#x0324;", 		"&#x0325;", 		"&#x0326;", 
	"&#x0329;", 		"&#x032a;", 		"&#x032b;", 		"&#x032c;", 
	"&#x032d;", 		"&#x032e;", 		"&#x032f;", 		"&#x0330;", 
	"&#x0331;", 		"&#x0332;", 		"&#x0333;", 		"&#x0339;", 
	"&#x033a;", 		"&#x033b;", 		"&#x033c;", 		"&#x0345;", 
	"&#x0347;", 		"&#x0348;", 		"&#x0349;", 		"&#x034d;", 
	"&#x034e;", 		"&#x0353;", 		"&#x0354;", 		"&#x0355;", 
	"&#x0356;", 		"&#x0359;", 		"&#x035a;", 		"&#x0323;" 
)

//those always stay in the middle
var/list/zalgo_mid = list(
	"&#x0315;", 		"&#x031b;", 		"&#x0340;", 		"&#x0341;", 
	"&#x0358;", 		"&#x0321;", 		"&#x0322;", 		"&#x0327;", 
	"&#x0328;", 		"&#x0334;", 		"&#x0335;", 		"&#x0336;", 
	"&#x034f;", 		"&#x035c;", 		"&#x035d;", 		"&#x035e;", 
	"&#x035f;", 		"&#x0360;", 		"&#x0362;", 		"&#x0338;", 
	"&#x0337;", 		"&#x0361;", 		"&#x0489;" 		
)

/proc/zalgoify(var/message, var/up, var/mid, var/down)
	if(!message)
		return
	
	var/new_string = ""
		
	for (var/i = 1, i <= length(message), i++)
		var/char = copytext(message, i, i+1)
		new_string += char
		for(var/j = 0, j < up, j++)
			new_string += pick(zalgo_up)
		for(var/j = 0, j < mid, j++)
			new_string += pick(zalgo_mid)
		for(var/j = 0, j < down, j++)
			new_string += pick(zalgo_down)
	
	return new_string
