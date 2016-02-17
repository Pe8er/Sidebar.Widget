set musicapp to item 1 of my appCheck()
set playerstate to item 2 of my appCheck()

tell application "Finder" to set myPath to POSIX path of (container of (path to me) as alias)

if musicapp is "iTunes" then
	tell application "iTunes"
		if (count of artwork of current track) > 0 then
			set filename to "cover-" & id of current track & ".jpg"
			tell application "Finder" to if (exists ({myPath & filename} as string) as POSIX file) then
				set myExists to true
			else
				set myExists to false
			end if
			if myExists is not true then
				set coverTarget to open for access (text 1 thru -32 of (path to me as text) & filename as text) with write permission
				set coverData to data of artwork 1 of current track
				write coverData to coverTarget
				close access coverTarget
			end if
			return filename
		else
			return "default.png"
		end if
	end tell
else if musicapp is "Spotify" then
	-- https://community.spotify.com/t5/Help-Desktop-Linux-Windows-Web/Applescript-Bugs/m-p/1199299#M138316
	(* tell application "Spotify"
		set d to artwork of current track
		set idTrack to my replace_chars(id of current track, ":", "-")
	end tell *)
	return "spotify.png"
else
	return "default.png"
end if

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