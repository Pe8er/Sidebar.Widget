global musicapp, mypath, aname, alname, apiKey, filename
set musicapp to my appCheck()
set apiKey to "2e8c49b69df3c1cf31aaa36b3ba1d166"
set filename to "default.png"
tell application "Finder" to set mypath to POSIX path of (container of (path to me) as alias)

if musicapp is "iTunes" then
	tell application "iTunes"
		set filename to my setFileName()
		if my checkFile(filename) is false then
			if (count of artwork of current track) > 0 then
				set coverTarget to open for access (text 1 thru -32 of (path to me as text) & filename as text) with write permission
				set coverData to data of artwork 1 of current track
				write coverData to coverTarget
				close access coverTarget
			else
				set filename to my lastfmGrab(filename)
			end if
		end if
	end tell
	
else if musicapp is "Spotify" then
	tell application "Spotify" to set filename to my setFileName()
	if my checkFile(filename) is false then set filename to my lastfmGrab(filename)
end if

if filename is "" then set filename to "default.png"
return filename

------------------------------------------------
---------------SUBROUTINES GALORE---------------
------------------------------------------------

on setFileName()
	try
		using terms from application "iTunes"
			tell application musicapp
				set {aname, alname} to {artist, album} of current track
				my encodeText(aname & "-" & alname & ".png", true, false, 2)
			end tell
		end using terms from
	on error e
		my logEvent(e)
		set filename to "default.png"
	end try
end setFileName

on lastfmGrab(filename)
	try
		set rawXML to (do shell script "curl -s -m 2 'http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=" & quoted form of (my encodeText(aname, true, false, 1)) & "&album=" & quoted form of (my encodeText(alname, true, false, 1)) & "&api_key=" & apiKey & "'")
		set AppleScript's text item delimiters to "large\">"
		set rawXML to text item 2 of rawXML
		set AppleScript's text item delimiters to "</image>"
		set coverURL to text item 1 of rawXML
		set AppleScript's text item delimiters to ""
	on error e
		my logEvent(e)
		set filename to "default.png"
	end try
	try
		--do shell script "curl -s -o " & quoted form of (mypath & filename) & space & coverURL
		set filename to coverURL
	on error e
		my logEvent(e)
		set filename to "default.png"
	end try
end lastfmGrab

on deleteoldcovers(filename)
	do shell script "find '" & mypath & "' -name '*.png' ! -name 'default*' ! -name " & quoted form of filename & " -exec rm {} \\;"
end deleteoldcovers

on checkFile(filename)
	tell application "Finder" to if (exists ({mypath & filename} as string) as POSIX file) then
		return true
	else
		my deleteoldcovers(filename)
		return false
	end if
end checkFile

on appCheck()
	set apps to {"iTunes", "Spotify"}
	set activeApp to {}
	repeat with i in apps
		tell application "System Events" to set state to (name of processes) contains i
		if state is true then
			try
				using terms from application "iTunes"
					tell application i
						if player state is playing then
							set activeApp to (i as string)
							exit repeat
						end if
					end tell
				end using terms from
			on error e
				my logEvent(e)
			end try
		end if
	end repeat
	return activeApp
end appCheck

on encodeText(this_text, encode_URL_A, encode_URL_B, method)
	--http://www.macosxautomation.com/applescript/sbrt/sbrt-08.html
	set the standard_characters to "abcdefghijklmnopqrstuvwxyz0123456789"
	set the URL_A_chars to "$+!'/?;&@=#%><{}[]\"~`^\\|*"
	set the URL_B_chars to ".-_:"
	set the acceptable_characters to the standard_characters
	if encode_URL_A is false then set the acceptable_characters to the acceptable_characters & the URL_A_chars
	if encode_URL_B is false then set the acceptable_characters to the acceptable_characters & the URL_B_chars
	set the encoded_text to ""
	repeat with this_char in this_text
		if this_char is in the acceptable_characters then
			set the encoded_text to (the encoded_text & this_char)
		else
			set the encoded_text to (the encoded_text & encode_char(this_char, method)) as string
		end if
	end repeat
	return the encoded_text
end encodeText

on encode_char(this_char, method)
	set the ASCII_num to (the ASCII number this_char)
	set the hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	set x to item ((ASCII_num div 16) + 1) of the hex_list
	set y to item ((ASCII_num mod 16) + 1) of the hex_list
	if method is 1 then
		return ("%" & x & y) as string
	else if method is 2 then
		return "_" as string
	end if
end encode_char

on logEvent(e)
	do shell script "echo '" & (current date) & ": Found " & e & "' >> ~/Library/Logs/Playbox-Widget.log"
end logEvent