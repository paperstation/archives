proc
	binbase64(bin)
		var/buffer, char, len = length(bin)
		for(var/i in 1 to len step 24)
			char = (text2ascii(bin, i) - 48) << 7
			char |= (text2ascii(bin, i+1) - 48) << 6
			char |= (text2ascii(bin, i+2) - 48) << 5
			char |= (text2ascii(bin, i+3) - 48) << 4
			char |= (text2ascii(bin, i+4) - 48) << 3
			char |= (text2ascii(bin, i+5) - 48) << 2
			char |= (text2ascii(bin, i+6) - 48) << 1
			char |= text2ascii(bin, i+7) - 48
			buffer = char << 4
			if(len-i > 7)
				char = (text2ascii(bin, i+8) - 48) << 7
				char |= (text2ascii(bin, i+9) - 48) << 6
				char |= (text2ascii(bin, i+10) - 48) << 5
				char |= (text2ascii(bin, i+11) - 48) << 4
				char |= (text2ascii(bin, i+12) - 48) << 3
				char |= (text2ascii(bin, i+13) - 48) << 2
				char |= (text2ascii(bin, i+14) - 48) << 1
				char |= text2ascii(bin, i+15) - 48
				buffer |= char >> 4
				. += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
					ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))
				buffer = (char & 0xF) << 8
				if(len-i > 15)
					buffer |= (text2ascii(bin, i+16) - 48) << 7
					buffer |= (text2ascii(bin, i+17) - 48) << 6
					buffer |= (text2ascii(bin, i+18) - 48) << 5
					buffer |= (text2ascii(bin, i+19) - 48) << 4
					buffer |= (text2ascii(bin, i+20) - 48) << 3
					buffer |= (text2ascii(bin, i+21) - 48) << 2
					buffer |= (text2ascii(bin, i+22) - 48) << 1
					buffer |= text2ascii(bin, i+23) - 48
					. += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
						ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))
				else . += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + "="
			else . += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
				ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F))) + \
				"=="


	base64bin(b64)
		var/buffer, char, bin, len = length(b64)
		for(var/i in 1 to len step 4)
			buffer = (findtextEx(_base64AlphaStr, ascii2text(text2ascii(b64, i)))-1)<<2
			char = findtextEx(_base64AlphaStr, ascii2text(text2ascii(b64, i+1)))-1
			buffer |= char >> 4
			bin = num2text(buffer % 2)
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			buffer >>= 1
			bin = num2text(buffer % 2) + bin
			. += bin
			bin = null
			buffer = (char & 0xF) << 4
			char = text2ascii(b64, i+2)
			if(char != 61)	// char != "="
				char = findtextEx(_base64AlphaStr, ascii2text(char))-1
				buffer |= char >> 2
				bin = num2text(buffer % 2)
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				buffer >>= 1
				bin = num2text(buffer % 2) + bin
				. += bin
				bin = null
				buffer = (char & 0x3) << 6
				char = text2ascii(b64, i+3)
				if(char != 61)	// char != "="
					buffer |= findtextEx(_base64AlphaStr, ascii2text(char))-1
					bin = num2text(buffer % 2)
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					buffer >>= 1
					bin = num2text(buffer % 2) + bin
					. += bin
					bin = null
				else break
			else break