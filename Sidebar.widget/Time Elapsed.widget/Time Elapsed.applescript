--http://www.mathcats.com/explore/elapsedtime.html

on run (argument)
	set theDate to date (item 1 of argument)
	set {year:y, month:m, day:d} to theDate
	set {year:cy, month:cm, day:cd} to current date
	
	set aYear to cy - y
	
	set aMonth to cm - m
	
	set aDay to cd - d
	
	if aDay is less than 0 then
		set aDay to aDay + daysinmonth(theDate)
		set aMonth to aMonth - 1
		if aMonth is less than 0 then
			--set aDay to aDay - 1
			set aMonth to aMonth + 12
			set aYear to aYear - 1
		end if
	end if
	
	if aYear = 1 then
		set yLabel to "year"
	else
		set yLabel to "years"
	end if
	
	
	if aMonth = 1 then
		set mLabel to "month"
	else
		set mLabel to "months"
	end if
	
	if aDay = 1 then
		set dLabel to "day"
	else
		set dLabel to "days"
	end if
	
	return aYear & space & yLabel & space & aMonth & space & mLabel & space & aDay & space & dLabel as string
end run

on daysinmonth(theDate)
	copy theDate to d
	set d's day to 32
	return (d - (d's day) * days)'s day
end daysinmonth