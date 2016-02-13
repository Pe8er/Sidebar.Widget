--http://www.mathcats.com/explore/elapsedtime.html

set quitDate to date "Monday, October 29, 2012 at 8:00:00 AM"
set {year:y, month:m, day:d} to quitDate
set {year:cy, month:cm, day:cd} to current date

set aYear to cy - y

set aMonth to cm - m

set aDay to cd - d

if aDay is less than 0 then
	set aDay to aDay + daysinmonth(quitDate)
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

on daysinmonth(theDate)
	copy theDate to d
	set d's day to 32
	return (d - (d's day) * days)'s day
end daysinmonth