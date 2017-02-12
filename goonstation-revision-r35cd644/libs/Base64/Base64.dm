/*
		Base64 Library
		-	Conversions to/from Base64 in various forms
		-	Copyright ©2007 Zac Stringham, a.k.a. "Hiead"

	Purpose:

		Conversions to and from Base64 are often slow and painful,
	especially in the DM language. My goal was to make such conversions
	a little easier, and a little faster than most implementations that
	get tossed around here. I'm not sure if I succeeded in either;
	what seems "easier" to me often has the opposite effect on others
	(and doubly so for what seems "easier" to them), and I came up with
	all of the functions in here without searching for any high-powered
	algorithms previously---what you see here is purely from my own design
	based on what I know about various number bases and the DM language; if
	you have any suggestions as to what you feel might speed up a particular
	method, do let me know at xhiead@gmail.com, and I will consider it.

		Also, I didn't do any error-checking within the procs (it is your
	responsibility to assure that anything passed to the procs is formatted
	correctly).

	Usage:

	_base64AlphaStr var
		- A constant string variable containing the Base64 "alphabet"

	strbase64 proc
		Format:		strbase64(str)
		Returns:	A Base64-encoded text string
		Args:		str - A text string

		Converts the input string into Base64 and returns the result.

	base64str proc
		Format:		base64str(b64)
		Returns:	A text string
		Args:		b64 - A Base64-encoded string

		Converts the Base64 input string into an unencoded text string and returns
		the result.

	hexbase64 proc
		Format:		hexbase64(hex)
		Returns:	A Base64-encoded text string
		Args:		hex	- A hexadecimal text string

		Converts a hexadecimal input string into a Base64 string and returns the
		result. The length of the input string should be divisible by 2.

	base64hex proc
		Format:		base64hex(b64)
		Returns:	A hexadecimal text string
		Args:		b64 - A Base64-encoded text string

		Converts a Base64 input string into a hexadecimal string and returns the
		result.

	binbase64 proc
		Format:		binbase64(bin)
		Returns:	A Base64-encoded text string
		Args:		bin - A binary text string

		Converts a binary input string into a Base64 string and returns the result.
		The length of the input string should be divisible by 8.

	base64bin proc
		Format:		base64bin(b64)
		Returns:	A binary text string
		Args:		b64 - A Base64-encoded text string

		Converts a Base64 input string into a binary string and returns the result.

*/

var
	const/_base64AlphaStr = \
		"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"