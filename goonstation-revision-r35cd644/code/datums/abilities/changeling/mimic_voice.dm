/datum/targetable/changeling/mimic_voice
	name = "Mimic Voice"
	desc = "Sound like someone else!"
	icon_state = "mimicvoice"
	cooldown = 0
	targeted = 0
	target_anything = 0
	human_only = 1
	can_use_in_container = 1
	var/last_mimiced_name = ""
	cast(atom/target)
		if (..())
			return 1
		var/mimic_name = input("Choose a name to mimic:","Mimic Target.",last_mimiced_name) as null|text

		if (!mimic_name)
			return 1
		last_mimiced_name = mimic_name //A little qol, probably.

		var/mimic_message = input("Choose something to say:","Mimic Message.","") as null|text

		if (!mimic_message)
			return 1

		logTheThing("say", holder.owner, mimic_name, "[mimic_message] (<b>Mimicing (%target%)</b>)")
		var/original_name = holder.owner.real_name
		holder.owner.real_name = copytext(html_encode(mimic_name), 1, 32)
		holder.owner.say(mimic_message)
		holder.owner.real_name = original_name
		return 0