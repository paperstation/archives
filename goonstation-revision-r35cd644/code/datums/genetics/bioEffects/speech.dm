/datum/bioEffect/speech
	name = "Frontal Gyrus Alteration Type-N"
	desc = "Hinders nerve transmission to and from the speech center of the brain, resulting in faltering speech."
	id = "stutter"
	probability = 40
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "Y-you f.. feel a.. a bit n-n-nervous."
	msgLose = "You don't feel nervous anymore."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	proc/OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = stutter(message)
		return message

/datum/bioEffect/speech/smile
	name = "Frontal Gyrus Alteration Type-S"
	desc = "Causes the speech center of the subject's brain to produce large amounts of seratonin when engaged."
	id = "accent_smiling"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel like you want to smile and smile and smile forever :)"
	msgLose = "You don't feel like smiling anymore. :("
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = smilify(message)
		return message

/datum/bioEffect/speech/elvis
	name = "Frontal Gyrus Alteration Type-E"
	desc = "Forces the language center of the subject's brain to drawl out sentences in a funky manner."
	id = "accent_elvis"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel funky."
	msgLose = "You feel a little less conversation would be great."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = elvisfy(message)
		return message

/datum/bioEffect/speech/chav
	name = "Frontal Gyrus Alteration Type-C"
	desc = "Forces the language center of the subject's brain to construct sentences in a more rudimentary manner."
	id = "accent_chav"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "Ye feel like a reet prat like, innit?"
	msgLose = "You no longer feel like being rude and sassy."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = chavify(message)
		return message

/datum/bioEffect/speech/swedish
	name = "Frontal Gyrus Alteration Type-B"
	desc = "Forces the language center of the subject's brain to construct sentences in a vaguely norse manner."
	id = "accent_swedish"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel Swedish, however that works."
	msgLose = "The feeling of Swedishness passes."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = borkborkbork(message)
		return message

/datum/bioEffect/speech/tommy
	name = "Frontal Gyrus Alteration Type-T"
	desc = "Forces the langua.... what!? What the fuck is this? What happened here!? Gods have mercy on our souls."
	id = "accent_tommy"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel torn apart!"
	msgLose = "You pull yourself together."
	reclaim_fail = 10

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = tommify(message)
		return message

/datum/bioEffect/speech/comic
	name = "Frontal Gyrus Alteration Type-CS"
	desc = "Causes the speech center of the subject's brain to become, uh. Well, <i>something</i> happens to it."
	id = "accent_comic"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "<font face='Comic Sans MS'>You feel great!!</font>"
	msgLose = "You feel okay."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("T","A")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		return message
		// just let this one handle itself for now

/datum/bioEffect/speech/slurring
	name = "Frontal Gyrus Alteration Type-D"
	desc = "Causes the subject to have impaired control over their oral muscles, resulting in malformed speech."
	id = "slurring"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "You feel like your tongue's made out of lead."
	msgLose = "You feel less tongue-tied."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("T","A")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = say_drunk(message)
		return message

/datum/bioEffect/speech/unintelligable
	name = "Frontal Gyrus Alteration Type-X"
	desc = "Heavily corrupts the part of the brain responsible for forming spoken sentences."
	id = "unintelligable"
	isBad = 1
	effectType = effectTypeDisability
	blockCount = 4
	blockGaps = 4
	msgGain = "You can't seem to form any coherent thoughts!"
	msgLose = "Your mind feels more clear."
	reclaim_fail = 10
	stability_loss = -10
	lockProb = 75
	lockedGaps = 4
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = say_superdrunk(message)
		return message

/datum/bioEffect/speech/vowelitis
	name = "Frontal Gyrus Alteration Type-O"
	desc = "Causes the language center of the brain to have difficulty processing vowels."
	id = "vowelitis"
	effectType = effectTypePower
	msgGain = "You feel a bit tongue-tied."
	msgLose = "You no longer feel tongue-tied."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3
	var/vowel_lower = "a"
	var/vowel_upper = "A"

	New()
		..()
		var/picker = rand(1,5)
		switch(picker)
			if(1)
				vowel_lower = "a"
				vowel_upper = "A"
			if(2)
				vowel_lower = "e"
				vowel_upper = "E"
			if(3)
				vowel_lower = "i"
				vowel_upper = "I"
			if(4)
				vowel_lower = "o"
				vowel_upper = "O"
			if(5)
				vowel_lower = "u"
				vowel_upper = "U"
			else
				vowel_lower = ""
				vowel_upper = ""

	OnSpeak(var/message)
		if (!istext(message))
			return ""

		message = dd_replaceText(message, "a", vowel_lower)
		message = dd_replaceText(message, "e", vowel_lower)
		message = dd_replaceText(message, "i", vowel_lower)
		message = dd_replaceText(message, "o", vowel_lower)
		message = dd_replaceText(message, "u", vowel_lower)
		message = dd_replaceText(message, "A", vowel_upper)
		message = dd_replaceText(message, "E", vowel_upper)
		message = dd_replaceText(message, "I", vowel_upper)
		message = dd_replaceText(message, "O", vowel_upper)
		message = dd_replaceText(message, "U", vowel_upper)

		return message

/datum/bioEffect/speech/loud_voice
	name = "High-Pressure Larynx"
	desc = "Vastly increases airflow speed and capacity through the subject's larynx."
	id = "loud_voice"
	effectType = effectTypePower
	msgGain = "YOU SUDDENLY FEEL LIKE SHOUTING A WHOLE LOT!!!"
	msgLose = "You no longer feel the need to raise your voice."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""

		message = dd_replaceText(message, "!", "!!!")
		message = dd_replaceText(message, ".", "!!!")
		message = dd_replaceText(message, "?", "???")
		message = uppertext(message)
		message += "!!!"

		return message

/datum/bioEffect/speech/reversed_speech
	name = "Frontal Gyrus Alteration Type-R"
	desc = "Causes the language center of the brain to process speech in reverse."
	id = "reversed_speech"
	effectType = effectTypePower
	msgGain = ".sdrawkcab tib a leef uoY"
	msgLose = "You feel the right way around."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""

		message = reverse_text(message)

		return message

/datum/bioEffect/speech/quiet_voice
	name = "Constricted Larynx"
	desc = "Decreases airflow speed and capacity through the subject's larynx."
	id = "quiet_voice"
	effectType = effectTypePower
	msgGain = "...you feel like being quiet..."
	msgLose = "You no longer feel the need to keep your voice down."
	reclaim_fail = 10
	lockProb = 25
	lockedGaps = 2
	lockedDiff = 2
	lockedChars = list("G","C")
	lockedTries = 3

	OnSpeak(var/message)
		if (!istext(message))
			return ""

		message = dd_replaceText(message, "!", "...")
		message = dd_replaceText(message, "?", "..?")
		message = lowertext(message)
		message += "..."

		return message

/datum/bioEffect/monkey_speak
	name = "Monkey Speak"
	desc = "Causes the subject to understand monkeys."
	id = "monkey_speak"
	probability = 0
	msgGain = "You feel one with the jungle!"
	msgLose = "You feel less primal."

/datum/bioEffect/speech/zalgo
	name = "Eldritch Speech"
	desc = "The subject's larynx is channeling a chaotic dimension of elder beings."
	id = "accent_zalgo"
	effectType = effectTypeDisability
	isBad = 1
	msgGain = "HE COMES"
	msgLose = "You feel sane again."
	probability = 0
	occur_in_genepools = 0 // Probably shouldn't look like this? http://f.666kb.com/i/d2iqlzm1qa2gk6dqs.png

	New()
		src.msgGain = zalgoify(src.msgGain, 8, 2, 8)
		..()

	OnSpeak(var/message)
		if (!istext(message))
			return ""
		message = zalgoify(message, 8, 2, 8)
		return message