global musicapp, artistName, songName, albumName, apiKey, songMetaFile

set apiKey to "2e8c49b69df3c1cf31aaa36b3ba1d166"
tell application "Finder" to set mypath to POSIX path of (container of (path to me) as alias)
set songMetaFile to (mypath & "songMeta.plist" as string)

if my isMusicPlaying() is true then
	my getSongMeta()
	if my didSongChange() is true then my coverURLGrab()
	my readSongMeta("coverURL")
else
	return "NA"
end if



------------------------------------------------
---------------SUBROUTINES GALORE---------------
------------------------------------------------

on isMusicPlaying()
	set apps to {"iTunes", "Spotify"}
	set musicapp to {}
	set myResult to false
	repeat with i in apps
		tell application "System Events" to set state to (name of processes) contains i
		if state is true then
			try
				using terms from application "iTunes"
					tell application i
						if player state is playing then
							set musicapp to (i as string)
							set myResult to true
						else
							set myResult to false
						end if
					end tell
				end using terms from
			on error e
				my logEvent(e)
			end try
		end if
	end repeat
	return myResult
end isMusicPlaying

on getSongMeta()
	try
		using terms from application "iTunes"
			tell application musicapp to set {artistName, songName, albumName} to {artist, name, album} of current track
		end using terms from
	on error e
		my logEvent(e)
	end try
end getSongMeta

on didSongChange()
	try
		set currentSongMeta to artistName & songName
		set savedSongMeta to my readSongMeta("artistName") & my readSongMeta("songName")
		if currentSongMeta is not savedSongMeta then
			set currentSongMeta to artistName & "_" & albumName
			set savedSongMeta to (my readSongMeta("artistName")) & "_" & (my readSongMeta("albumName"))
			if currentSongMeta is not savedSongMeta then
				set myResult to true
			else
				if my readSongMeta("coverURL") is "" then
					set myResult to true
				else
					set myResult to false
				end if
			end if
			set keys to {"artistName" & "##" & artistName, "albumName" & "##" & albumName, "songName" & "##" & songName}
			my writeSongMeta(songMetaFile, keys)
		else
			if my readSongMeta("coverURL") is "" then
				set myResult to true
			else
				set myResult to false
			end if
		end if
		return myResult
	on error e
		my logEvent(e)
	end try
end didSongChange

on coverURLGrab()
	repeat 5 times
		try
			set rawXML to (do shell script "curl 'http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=" & quoted form of (my encodeText(artistName, true, false, 1)) & "&album=" & quoted form of (my encodeText(albumName, true, false, 1)) & "&api_key=" & apiKey & "'")
			delay 2
			set AppleScript's text item delimiters to "large\">"
			try
				set processingXML to text item 2 of rawXML
				set AppleScript's text item delimiters to "</image>"
				set currentCoverURL to text item 1 of processingXML
				set AppleScript's text item delimiters to ""
				if currentCoverURL is "" then
					my logEvent(rawXML)
					set currentCoverURL to "NA"
				end if
				set coverDownloaded to true
			on error e
				my logEvent(e & return & rawXML)
				set currentCoverURL to "NA"
				set coverDownloaded to true
			end try
		on error e
			my logEvent(e & return & rawXML)
			set currentCoverURL to "NA"
			set coverDownloaded to false
		end try
		if coverDownloaded is true then exit repeat
	end repeat
	
	set keys to {"coverURL" & "##" & currentCoverURL}
	set savedCoverURL to my readSongMeta("coverURL")
	if savedCoverURL is not currentCoverURL then
		my writeSongMeta(songMetaFile, keys)
	end if
end coverURLGrab

on readSongMeta(keyName)
	tell application "System Events" to tell property list file songMetaFile to tell contents
		try
			value of property list item keyName
		on error e
			my logEvent(e)
			my writeSongMeta(songMetaFile, {keyName & "##" & "NA"})
			value of property list item keyName
		end try
	end tell
end readSongMeta

on writeSongMeta(songMetaFile, keys)
	tell application "System Events"
		
		if my checkFile(songMetaFile) is false then
			-- create an empty property list dictionary item
			set the parent_dictionary to make new property list item with properties {kind:record}
			-- create new property list file using the empty dictionary list item as contents
			set this_plistfile to Â
				make new property list file with properties {contents:parent_dictionary, name:songMetaFile}
		end if
		
		try
			repeat with aKey in keys
				set AppleScript's text item delimiters to "##"
				set keyName to text item 1 of aKey
				set keyValue to text item 2 of aKey
				set AppleScript's text item delimiters to ""
				make new property list item at end of property list items of contents of property list file songMetaFile Â
					with properties {kind:string, name:keyName, value:keyValue}
			end repeat
		on error e
			my logEvent(e)
		end try
	end tell
end writeSongMeta

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
	do shell script "echo '" & (current date) & space & e & "' >> ~/Library/Logs/Playbox-Widget.log"
end logEvent

on checkFile(myfile)
	tell application "Finder" to if (exists (myfile as string) as POSIX file) then
		return true
	else
		return false
	end if
end checkFile