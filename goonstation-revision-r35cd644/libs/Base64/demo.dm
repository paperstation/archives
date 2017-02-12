client/verb
	StrB64()
		set name = "String To Base64"
		set category = "String"

		var/str = input(src, "Input a text string:") as null|text
		if(str)
			src << strbase64(str)

	HexB64()
		set name = "Hex To Base64"
		set category = "Hex"

		var/hex = input(src, "Input a hexadecimal string:") as null|text
		if(hex)
			if(!(length(hex) % 2))
				src << hexbase64(hex)
			else CRASH("Invalid input.")

	BinB64()
		set name = "Binary To Base64"
		set category = "Binary"

		var/bin = input(src, "Input a binary string:") as null|text
		if(bin)
			if(!(length(bin) % 8))
				src << binbase64(bin)
			else CRASH("Invalid input.")

	B64Str()
		set name = "Base64 To String"
		set category = "Base64"

		var/b64 = input(src, "Input a Base64 string:") as null|text
		if(b64)
			src << base64str(b64)

	B64Hex()
		set name = "Base64 To Hex"
		set category = "Base64"

		var/b64 = input(src, "Input a Base64 string:") as null|text
		if(b64)
			src << base64hex(b64)

	B64Bin()
		set name = "Base64 To Binary"
		set category = "Base64"

		var/b64 = input(src, "Input a Base64 string:") as null|text
		if(b64)
			src << base64bin(b64)