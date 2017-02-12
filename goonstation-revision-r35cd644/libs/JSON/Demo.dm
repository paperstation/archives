
mob
	verb/ReadJson(txt as message)
		usr<<list2json(json2list(txt))

	verb/ToJson(txt as message)
		var/list/L = params2list(txt)
		for(var/k in L)
			var/val = text2num(L[k])
			if(!isnull(val))
				L[k] = val

		usr<<list2json(L)