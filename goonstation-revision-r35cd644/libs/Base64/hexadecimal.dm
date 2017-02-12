proc
	hexbase64(hex)
		var/buffer, char1, char2, len = length(hex)
		hex = uppertext(hex)
		for(var/i in 1 to len step 6)
			char1 = text2ascii(hex, i)
			char1 = (char1 < 65 ? char1 - 48 : char1 - 55) << 4
			char2 = text2ascii(hex, i+1)
			char1 += (char2 < 65 ? char2 - 48 : char2 - 55)
			buffer = char1 << 4

			if(len-i > 1)
				char1 = text2ascii(hex, i+2)
				char1 = (char1 < 65 ? char1 - 48 : char1 - 55) << 4
				char2 = text2ascii(hex, i+3)
				char1 += (char2 < 65 ? char2 - 48 : char2 - 55)
				buffer |= char1 >> 4
				. += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
					ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))
				buffer = (char1 & 0xF) << 8
				if(len-i > 3)
					char1 = text2ascii(hex, i+4)
					char1 = (char1 < 65 ? char1 - 48 : char1 - 55) << 4
					char2 = text2ascii(hex, i+5)
					char1 += (char2 < 65 ? char2 - 48 : char2 - 55)
					buffer |= char1
					. += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
						ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))
				else . += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + "="
			else . += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
				ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F))) + \
				"=="

	base64hex(b64)
		var/buffer, char, hex, len = length(b64)
		for(var/i in 1 to len step 4)
			buffer = (findtextEx(_base64AlphaStr, ascii2text(text2ascii(b64, i)))-1) << 2
			char = findtextEx(_base64AlphaStr, ascii2text(text2ascii(b64, i+1)))-1
			buffer |= char >> 4
			hex = buffer % 16
			buffer >>= 4
			. += (buffer < 10 ? num2text(buffer) : ascii2text(buffer + 55)) + \
				(hex < 10 ? num2text(hex) : ascii2text(hex + 55))
			buffer = (char & 0xF) << 4
			char = text2ascii(b64, i+2)
			if(char != 61)	// char != "="
				char = findtextEx(_base64AlphaStr, ascii2text(char))-1
				buffer |= char >> 2
				hex = buffer % 16
				buffer >>= 4
				. += (buffer < 10 ? num2text(buffer) : ascii2text(buffer + 55)) + \
					(hex < 10 ? num2text(hex) : ascii2text(hex + 55))
				buffer = (char & 0x3) << 6
				char = text2ascii(b64, i+3)
				if(char != 61)	// char != "="
					buffer |= findtextEx(_base64AlphaStr, ascii2text(char)) - 1
					hex = buffer % 16
					buffer >>= 4
					. += (buffer < 10 ? num2text(buffer) : ascii2text(buffer + 55)) + \
						(hex < 10 ? num2text(hex) : ascii2text(hex + 55))
				else break
			else break