/proc/check_svnrevlist()
	var/text = file2text("data/svnrev.txt")
	if (text)
		var/list/lines = dd_text2list(text, "\n")
		if (lines[1])
			return lines[1]
			diary << "Server revision is r'[master_mode]'"
