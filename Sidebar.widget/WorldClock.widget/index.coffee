# Code originally created by Chris Johnson.
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

command: "Sidebar.widget/WorldClock.widget/WorldClock.sh"

refreshFrequency: '1s'

style: """
  white1 = rgba(white,1)
  white05 = rgba(white,0.5)
  white02 = rgba(white,0.2)
  black02 = rgba(black,0.2)

  white-space nowrap
  text-overflow ellipsis
  overflow hidden

  .wrapper
    text-align center
    font-size 8pt
    line-height 11pt
    width 176px
    align-items center
    display flex
    padding 8px 0

  .box
    width: 50%
    float left

  .time
    color white
    font-weight 700

  .timezone
    color: white05

"""

render: -> """
"""

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)

  # Get our timezones and times.
  zones=output.split("\n")

  # Initialize our HTML.
  timeHTML = ''

  # Loop through each of the time zones.
  for zone, idx in zones

    # If the zone is not empty (e.g. the last newline), let's add it to the HTML.
    if zone != ''

      # Split the timezone from the time.
      values = zone.split(";")

      # Create the DIVs for each timezone/time. The last item is unique in that we don't want to display the border.
      # if idx < zones.length - 2
      timeHTML = timeHTML + "<div class='box'><div class='time'>" + values[1] + "</div><div class='timezone'>" + values[0] + "</div></div>"
      # else
        #timeHTML = timeHTML + "<div class='lastbox'><div class='time'>" + values[1] + "</div><div class='timezone'>" + values[0] + "</div></div>"

  # Set the HTML of our main DIV.
  div.html("<div class='wrapper'>" + timeHTML + "</div>")

  # Sort out flex-box positioning.
  $(domEl).parent('div').css('order', '3')
  $(domEl).parent('div').css('flex', '0 1 auto')