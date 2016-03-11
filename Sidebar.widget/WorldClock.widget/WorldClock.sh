#!/bin/sh

# Set the time format to 12 or 24 hours.
timeformat=12

if [ $timeformat = 12 ] ; then
  setformat="+%-l:%M %p"
else
  setformat="+%H:%M"
fi

# echo "Hawaii;`export TZ='Pacific/Honolulu';date "$setformat";unset TZ`"
# echo "Alaska;`export TZ='America/Anchorage';date "$setformat";unset TZ`"
echo "Cupertino;`export TZ='US/Pacific';date "$setformat";unset TZ`"
# echo "Mountain;`export TZ='US/Mountain';date "$setformat";unset TZ`"
# echo "Central;`export TZ='US/Central';date "$setformat";unset TZ`"
# echo "Eastern;`export TZ='US/Eastern';date "$setformat";unset TZ`"
echo "Wrocław;`export TZ='Europe/Warsaw';date "$setformat";unset TZ`"
# echo "Wrocław;`export TZ='Europe/Warsaw';date "$setformat";unset TZ`"
# echo "Paris;`export TZ='Europe/Paris';date "$setformat";unset TZ`"
# echo "Moscow;`export TZ='Europe/Moscow';date "$setformat";unset TZ`"
# echo "India;`export TZ='Asia/Kolkata';date "$setformat";unset TZ`"
# echo "Shanghai;`export TZ='Asia/Shanghai';date "$setformat";unset TZ`"