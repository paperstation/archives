/mob/living/carbon/slime/say(var/message)
	if (silent)
		return
	else
		return ..()

/mob/living/carbon/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "asks, \"[text]\"";
	else if (ending == "!")
		return "cries, \"[text]\"";

	return "chirps, \"[text]\"";

/mob/living/carbon/slime/say_understands(var/other)
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

