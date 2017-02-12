
/obj/item/device/radio/headset
	name = "\improper Radio Headset"
	icon_state = "headset"
	item_state = "headset"
	rand_pos = 0
	var/protective_temperature = 0
	speaker_range = 0
	var/allow_deaf_hearing = 0
	desc = "A standard-issue device that can be worn on a crewmember's ear to allow hands-free communication with the rest of the crew."
	flags = FPRINT | TABLEPASS | CONDUCT

/obj/item/device/radio/headset/command
	name = "\improper Command Headset"
	desc = "A radio headset capable of communicating over additional, secure frequencies"
	icon_state = "command headset"
	secure_frequencies = list("h" = R_FREQ_COMMAND)
	secure_colors = list("h" = RADIOC_COMMAND)

/obj/item/device/radio/headset/command/captain
	secure_frequencies = list("h" = R_FREQ_COMMAND,\
	"g" = R_FREQ_SECURITY,\
	"e" = R_FREQ_ENGINEERING,\
	"r" = R_FREQ_RESEARCH,\
	"m" = R_FREQ_MEDICAL,\
	"c" = R_FREQ_CIVILIAN)
	secure_colors = list("h" = RADIOC_COMMAND,\
	"g" = RADIOC_SECURITY,\
	"e" = RADIOC_ENGINEERING,\
	"r" = RADIOC_RESEARCH,\
	"m" = RADIOC_MEDICAL,\
	"c" = RADIOC_CIVILIAN)

/obj/item/device/radio/headset/command/hos
	secure_frequencies = list("h" = R_FREQ_COMMAND,\
	"g" = R_FREQ_SECURITY)
	secure_colors = list("h" = RADIOC_COMMAND,\
	"g" = RADIOC_SECURITY)

/obj/item/device/radio/headset/command/hop
	secure_frequencies = list("h" = R_FREQ_COMMAND,\
	/*"g" = R_FREQ_SECURITY,\*/
	"c" = R_FREQ_CIVILIAN)
	secure_colors = list("h" = RADIOC_COMMAND,\
	/*"g" = RADIOC_SECURITY,\*/
	"c" = RADIOC_CIVILIAN)

/obj/item/device/radio/headset/command/rd
	secure_frequencies = list("h" = R_FREQ_COMMAND,\
	"r" = R_FREQ_RESEARCH,\
	"m" = R_FREQ_MEDICAL)
	secure_colors = list("h" = RADIOC_COMMAND,\
	"r" = RADIOC_RESEARCH,\
	"m" = RADIOC_MEDICAL)

/obj/item/device/radio/headset/command/md
	secure_frequencies = list("h" = R_FREQ_COMMAND,\
	"r" = R_FREQ_RESEARCH,\
	"m" = R_FREQ_MEDICAL)
	secure_colors = list("h" = RADIOC_COMMAND,\
	"r" = RADIOC_RESEARCH,\
	"m" = RADIOC_MEDICAL)

/obj/item/device/radio/headset/command/ce
	secure_frequencies = list("h" = R_FREQ_COMMAND,\
	"e" = R_FREQ_ENGINEERING)
	secure_colors = list("h" = RADIOC_COMMAND,\
	"e" = RADIOC_ENGINEERING)

/obj/item/device/radio/headset/security
	name = "\improper Security Headset"
	desc = "A radio headset capable of communicating over a second, secure frequency."
	icon_state = "sec headset"
	secure_frequencies = list("h" = R_FREQ_SECURITY)
	secure_colors = list("h" = RADIOC_SECURITY)

/obj/item/device/radio/headset/engineer
	name = "\improper Engineering Headset"
	desc = "A radio headset capable of communicating over a second, secure frequency."
	icon_state = "engine headset"
	secure_frequencies = list("h" = R_FREQ_ENGINEERING)
	secure_colors = list("h" = RADIOC_ENGINEERING)

/obj/item/device/radio/headset/medical
	name = "\improper Medical Headset"
	desc = "A radio headset capable of communicating over a second, secure frequency."
	icon_state = "med headset"
	secure_frequencies = list("h" = R_FREQ_MEDICAL)
	secure_colors = list("h" = RADIOC_MEDICAL)

/obj/item/device/radio/headset/research
	name = "\improper Research Headset"
	desc = "A radio headset capable of communicating over a second, secure frequency."
	icon_state = "research headset"
	secure_frequencies = list("h" = R_FREQ_RESEARCH)
	secure_colors = list("h" = RADIOC_RESEARCH)

/obj/item/device/radio/headset/civilian
	name = "\improper Civilian Headset"
	desc = "A radio headset capable of communicating over a second, secure frequency."
	icon_state = "civ headset"
	secure_frequencies = list("h" = R_FREQ_CIVILIAN)
	secure_colors = list("h" = RADIOC_CIVILIAN)

/obj/item/device/radio/headset/shipping
	name = "\improper Shipping Headset"
	desc = "A radio headset capable of communicating over additional, secure frequencies."
	icon_state = "shipping headset"
	secure_frequencies = list("h" = R_FREQ_ENGINEERING,\
	"c" = R_FREQ_CIVILIAN)
	secure_colors = list("h" = RADIOC_ENGINEERING,\
	"c" = RADIOC_CIVILIAN)
//	secure_colors = list("#ff6600")

/obj/item/device/radio/headset/syndicate
	name = "\improper Radio Headset"
	desc = "A radio headset capable of communicating over a second, secure frequency."
	icon_state = "headset"
	secure_frequencies = list("h" = R_FREQ_SYNDICATE)
	secure_colors = list(RADIOC_SYNDICATE)
	protected_radio = 1

/obj/item/device/radio/headset/deaf
	name = "\improper Auditory Headset"
	desc = "A radio headset that interfaces with the ear canal, allowing the deaf to hear."
	icon_state = "deaf headset"
	item_state = "headset"
	allow_deaf_hearing = 1

/obj/item/device/radio/headset/gang
	name = "\improper Gang Headset"
	desc = "A radio headset to communicate privately with your fellow gang members."
	secure_frequencies = list("g" = R_FREQ_GANG) //placeholder so it sets up right
	secure_colors = list(RADIOC_OTHER)
	protected_radio = 1

/obj/item/device/radio/headset/multifreq
	name = "\improper Multi-frequency Headset"
	desc = "A radio headset capable of communicating over a second, customisable frequency."
	icon_state = "multi headset"
	secure_frequencies = list("h" = R_FREQ_MULTI)
	secure_colors = list(RADIOC_OTHER)

/obj/item/device/radio/headset/multifreq/attack_self(mob/user as mob)
	user.machine = src
	var/t1
	if (src.b_stat)
		t1 = {"
-------<BR>
Green Wire: <A href='byond://?src=\ref[src];wires=4'>[src.wires & 4 ? "Cut" : "Mend"] Wire</A><BR>
Red Wire:   <A href='byond://?src=\ref[src];wires=2'>[src.wires & 2 ? "Cut" : "Mend"] Wire</A><BR>
Blue Wire:  <A href='byond://?src=\ref[src];wires=1'>[src.wires & 1 ? "Cut" : "Mend"] Wire</A><BR>"}
	else
		t1 = "-------"
	var/dat = {"
<TT>
Microphone: [src.broadcasting ? "<A href='byond://?src=\ref[src];talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];talk=1'>Disengaged</A>"]<BR>
Speaker: [src.listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A>
[format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
Secure Frequency:
<A href='byond://?src=\ref[src];sfreq=-10'>-</A>
<A href='byond://?src=\ref[src];sfreq=-2'>-</A>
[format_frequency(src.secure_frequencies["h"])]
<A href='byond://?src=\ref[src];sfreq=2'>+</A>
<A href='byond://?src=\ref[src];sfreq=10'>+</A><BR>
[t1]
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/device/radio/headset/multifreq/Topic(href, href_list)
	if (usr.stat)
		return
	if ((usr.contents.Find(src) || in_range(src, usr) && istype(src.loc, /turf)) || (usr.loc == src.loc) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if (href_list["sfreq"])
			var/new_frequency = sanitize_frequency(text2num("[secure_frequencies["h"]]") + text2num(href_list["sfreq"]))
			set_secure_frequency("h", new_frequency)
	return ..(href, href_list)
