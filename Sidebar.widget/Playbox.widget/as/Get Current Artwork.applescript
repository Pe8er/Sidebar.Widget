global mypath
set musicapp to item 1 of my appCheck()
set playerstate to item 2 of my appCheck()
set apiKey to "2e8c49b69df3c1cf31aaa36b3ba1d166"
set filename to "default.png"

tell application "Finder" to set mypath to POSIX path of (container of (path to me) as alias)

if musicapp is "iTunes" then
	tell application "iTunes" to if player state is playing then
		if (count of artwork of current track) > 0 then
			set filename to "cover-" & id of current track & ".jpg"
			set myexists to my checkFile(filename)
			
			if myexists is false then
				set coverTarget to open for access (text 1 thru -32 of (path to me as text) & filename as text) with write permission
				set coverData to data of artwork 1 of current track
				write coverData to coverTarget
				close access coverTarget
				my deleteoldcovers(filename)
			end if
			return filename
		else
			return "default.png"
		end if
	end if
else if musicapp is "Spotify" then
	try
		tell application "Spotify" to if player state is playing then
			set {aname, alname} to {artist, album} of current track
			set filename to my encode_text(aname & "-" & alname & ".png" as string, true, false)
			set myexists to my checkFile(filename)
			
			if myexists is false then
				try
					set rawXML to (do shell script "curl -m 2 'http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=" & quoted form of (my encode_text(aname, true, false)) & "&album=" & quoted form of (my encode_text(alname, true, false)) & "&api_key=" & apiKey & "'")
					try
						set AppleScript's text item delimiters to "extralarge\">"
						set rawXML to text item 2 of rawXML
						set AppleScript's text item delimiters to "</image>"
						set coverURL to text item 1 of rawXML
						set AppleScript's text item delimiters to ""
					on error e
						display dialog e with title "Last.fm metadata processing failed"
					end try
				on error e
					display dialog e with title "Last.fm metadata curl failed"
				end try
				if coverURL is not "" then
					try
						do shell script "curl -o " & quoted form of (mypath & filename) & space & coverURL
					on error e
						display dialog e with title "Cover download curl failed"
					end try
					my deleteoldcovers(filename)
				end if
			end if
		end if
	on error e
		display dialog e with title "Last.fm metadata curl and conversion failed"
	end try
	
	
	return filename
end if
(* 
	Maybe Spotify fixes cover art retrieval somedayÉ
	
	https://community.spotify.com/t5/Help-Desktop-Linux-Windows-Web/Applescript-Bugs/m-p/1199299#M138316
	tell application "Spotify"
		set d to artwork of current track
		set idTrack to my replace_chars(id of current track, ":", "-")
	end tell
	return "spotify.png"
	*)

on deleteoldcovers(filename)
	do shell script "find '" & mypath & "' -name '*.png' ! -name 'spotify*' ! -name 'default*' ! -name " & quoted form of filename & " -exec rm {} \\;"
end deleteoldcovers

on checkFile(filename)
	tell application "Finder" to if (exists ({mypath & filename} as string) as POSIX file) then
		set myexists to true
	else
		set myexists to false
	end if
end checkFile

on appCheck()
	set apps to {"iTunes", "Spotify"}
	set playerstate to {}
	set activeApp to {}
	repeat with i in apps
		tell application "System Events" to set state to (name of processes) contains i
		if state is true then
			set activeApp to (i as string)
			try
				using terms from application "iTunes"
					tell application i
						if player state is playing then
							set playerstate to "Playing"
							exit repeat
						else
							set playerstate to "Paused"
						end if
					end tell
				end using terms from
			end try
		else
			set activeApp to ""
		end if
	end repeat
	return {activeApp, playerstate}
end appCheck

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on encode_text(this_text, encode_URL_A, encode_URL_B)
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
			set the encoded_text to (the encoded_text & encode_char(this_char)) as string
		end if
	end repeat
	return the encoded_text
end encode_text

on encode_char(this_char)
	set the ASCII_num to (the ASCII number this_char)
	set the hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	set x to item ((ASCII_num div 16) + 1) of the hex_list
	set y to item ((ASCII_num mod 16) + 1) of the hex_list
	return ("%" & x & y) as string
end encode_char