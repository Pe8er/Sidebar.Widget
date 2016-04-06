# Code originally created by Chris Johnson.
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

options =

  # Enter locations to set up world clocks.
  locations           :           "US/Pacific,Europe/Warsaw"

  # Optional custom labels for cities. If you leave them out, make sure to keep the quotes ("").
  cityNames           :           "Cupertino,Wroclaw"

  # 12 or 24 hour time format.
  timeFormat          :         "12"

command: "osascript Sidebar.widget/WorldClock.widget/WorldClock.applescript '#{options.locations}' '#{options.cityNames}' #{options.timeFormat}"

refreshFrequency: '1s'

style: """
  .wrapper
    text-align center
    font-size 8pt
    line-height 11pt
    width 176px
    align-items center
    display flex

  .box
    width auto
    max-width 50%
    margin 0 auto
    padding 8px
    overflow hidden

  .time
    color white
    font-weight 700

  .timezone
    color: rgba(white,0.5)
    white-space nowrap
    overflow hidden
    text-overflow ellipsis

"""

render: -> """
"""

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)

  # Get our timezones and times.
  zones=output.split(";")

  # Initialize our HTML.
  timeHTML = ''

  # Loop through each of the time zones.
  for zone, idx in zones

    # If the zone is not empty (e.g. the last newline), let's add it to the HTML.
    if zone != ''

      # Split the timezone from the time.
      values = zone.split("~")

      # Create the DIVs for each timezone/time. The last item is unique in that we don't want to display the border.
      # if idx < zones.length - 2
      timeHTML = timeHTML + "<div class='box'><div class='time'>" + values[1] + "</div><div class='timezone'>" + values[0] + "</div></div>"
      # else
        #timeHTML = timeHTML + "<div class='lastbox'><div class='time'>" + values[1] + "</div><div class='timezone'>" + values[0] + "</div></div>"

  # Set the HTML of our main DIV.
  div.html("<div class='wrapper'>" + timeHTML + "</div>")
  # div.html("<div class='wrapper'>" + output + "</div>")

  # Sort out flex-box positioning.
  div.parent('div').css('order', '3')
  div.parent('div').css('flex', '0 1 auto')