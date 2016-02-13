try
	set rawOutput to do shell script "/usr/local/bin/icalBuddy -npn -nc -iep 'title,datetime' -ps ' ^ ' -po 'datetime,title' -df '' -eed -b '' -n -ea eventsToday"
on error
	return "You need to install icalBuddy. \"brew install ical-buddy\" seems like a good idea.^^"
end try

set eventList to {}
set now to time of (current date)
set startTimes to {}
set meta to 0

repeat with myEvent in paragraphs of rawOutput
	set myEvent to myEvent as list
	try
		set startTime to time of date (item 1 of myEvent)
		if startTime > now then copy myEvent to end of eventList
	end try
end repeat

repeat with myEvent in eventList
	set myEvent to myEvent as string
	set AppleScript's text item delimiters to "^"
	copy text item 1 of myEvent to end of startTimes
	set AppleScript's text item delimiters to ""
end repeat

try
	set nextEvent to item 1 of eventList
	set nextEvent to nextEvent as string
	set AppleScript's text item delimiters to "^"
	set startTime to time of date (text item 1 of nextEvent)
	set eventName to text item 2 of nextEvent
	set AppleScript's text item delimiters to ""
	set hrs to (startTime - now) div hours
	set mins to (startTime - now) mod hours div minutes as string
	if (count of characters in mins) is 1 then set mins to 0 & mins
	
	set remainingTime to hrs & ":" & mins as string
	
	set subsequentEvents to (count of items of eventList) - 1
	set multipleEvents to count_matches(startTimes, item 1 of startTimes) - 1
	
	if subsequentEvents ³ 1 then
		set meta to "+" & subsequentEvents & " later"
	else
		set meta to 0
	end if
	if multipleEvents > 1 then
		set plural to "s"
	else
		set plural to ""
	end if
	if multipleEvents is not 0 then set meta to "+" & multipleEvents & " conflict" & plural
	
	return remainingTime & "^" & eventName & "^" & meta
on error
	set nextEvent to "No Events"
end try

on count_matches(this_list, this_item)
	set the match_counter to 0
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then Â
			set the match_counter to the match_counter + 1
	end repeat
	return the match_counter
end count_matches