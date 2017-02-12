/obj/item/device/hashtagger
	name = "Hashtagger"
	desc = "Encrypts a single message."
	icon = 'icons/scooterstuff.dmi'
	icon_state = "hashtagger"
	var/md5hash = null
	var/message = null
	var/md5hashrev = null
	attack_self()
		if(!md5hash)
			md5hash = input(usr,"What would you like to set the hash as?","#")
			if(md5hash)
				md5hashrev = md5(md5hash)
				message = input(usr,"What would you like to say?","Anything")
				usr << "Your hash has been generated: [md5hashrev]"
				usr << "Do not lose it."
		else if(md5hashrev && message)
			var/temp = input(usr,"Please input the hash.")
			if(temp == md5hashrev)
				usr << "[message]"