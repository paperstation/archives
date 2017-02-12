/proc/command_alert(var/text, var/title = "")
	boutput(world, "<h1 class='alert'>[command_name()] Update</h1>")

	if (title && length(title) > 0)
		boutput(world, "<h2 class='alert'>[sanitize(title)]</h2>")

	boutput(world, "<span class='alert'>[sanitize(text)]</span>")
	boutput(world, "<br>")

/proc/command_announcement(var/text, var/title) //Slightly less conspicuous, but requires a title.
	if(!title || !text) return

	boutput(world, "<h2 class='alert'>[sanitize(title)]</h2>")

	boutput(world, "<span class='alert'>[sanitize(text)]</span>")
	boutput(world, "<br>")

/proc/advanced_command_alert(var/text, var/title="")
	if(!text) return 0
	var/list/mob/mob_list = list()

	for(var/mob/M in world)
		if(M.client)
			mob_list+=M

	var/mob/rand_mob_single = pick(mob_list) //A single randomly selected player


	for(var/mob/M in mob_list)
		spawn(0)
			if(M.client)
				var/mob/rand_mob_mult = pick(mob_list) //A randomly selected player that's different to each viewer

				var/atom/A = get_turf(M.loc)
				if(A) A = A.loc

				if(title != "")
					title = dd_replacetext(title, "%name%", M.real_name)
					title = dd_replacetext(title, "%key%", M.key)
					title = dd_replacetext(title, "%job%", M.job ? M.job : "space hobo")
					title = dd_replacetext(title, "%area_name%", A ? A.name : "some unknown place")
					title = dd_replacetext(title, "%srand_name%", rand_mob_single.name)
					title = dd_replacetext(title, "%srand_job%", rand_mob_single.job ? rand_mob_single.job : "space hobo" )
					title = dd_replacetext(title, "%mrand_name%", rand_mob_mult.name)
					title = dd_replacetext(title, "%mrand_job%", rand_mob_mult.job)

					title = sanitize(title)

				text = dd_replacetext(text, "%name%", M.real_name)
				text = dd_replacetext(text, "%key%", M.key)
				text = dd_replacetext(text, "%job%", M.job ? M.job : "space hobo")
				text = dd_replacetext(text, "%area_name%", A ? A.name : "some unknown place")
				text = dd_replacetext(text, "%srand_name%", rand_mob_single.name)
				text = dd_replacetext(text, "%srand_job%", rand_mob_single.job ? rand_mob_single.job : "space hobo" )
				text = dd_replacetext(text, "%mrand_name%", rand_mob_mult.name)
				text = dd_replacetext(text, "%mrand_job%", rand_mob_mult.job)

				text = sanitize(text)

				boutput(M, "<h1 class='alert'>[command_name()] Update</h1>")
				if(title != "") boutput(M, "<h2 class='alert'>[title]</h2>")
				boutput(M, "<span class='alert'>[text]</span><br>")

	return 1

