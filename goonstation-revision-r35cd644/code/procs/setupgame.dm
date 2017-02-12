/proc/setupgenetics()

	//if (prob(50))
	//	BLOCKADD = rand(150,300)

	if (prob(75))
		DIFFMUT = rand(0,20)

	var/list/avnums = new/list()
	var/tempnum

	avnums.Add(2)
	avnums.Add(12)
	avnums.Add(10)
	avnums.Add(8)
	avnums.Add(4)
	avnums.Add(11)
	avnums.Add(13)
	avnums.Add(6)

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	HULKBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	TELEBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	FIREBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	XRAYBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	CLUMSYBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	FAKEBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	DEAFBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	BLINDBLOCK = tempnum



/proc/setup_radiocodes()
	var/list/codewords = list("Alpha","Beta","Gamma","Zeta","Omega", "Bravo", "Epsilon", "Jeff", "Delta")
	var/tempword = null

	tempword = pick(codewords)
	netpass_heads = "[rand(1111,9999)] [tempword]-[rand(111,999)]"
	codewords -= tempword

	tempword = pick(codewords)
	netpass_security = "[rand(1111,9999)] [tempword]-[rand(111,999)]"
	codewords -= tempword

	tempword = pick(codewords)
	netpass_medical = "[rand(1111,9999)] [tempword]-[rand(111,999)]"
	codewords -= tempword

	tempword = pick(codewords)
	netpass_banking = "[rand(1111,9999)] [tempword]-[rand(111,999)]"
	codewords -= tempword

	tempword = pick(codewords)
	netpass_cargo = "[rand(1111,9999)] [tempword]-[rand(111,999)]"
	codewords -= tempword

	tempword = pick(codewords)
	netpass_syndicate = "[rand(111,999)]DET[tempword]=[rand(1111,9999)]"
	codewords -= tempword

	//boutput(world, "debug:<br>head: [netpass_heads] <br> med: [netpass_medical] <br> sec: [netpass_security]<br> atm: [netpass_banking]<br> cargo: [netpass_cargo]")