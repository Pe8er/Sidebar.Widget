# Code originally created by the awesome members of Ubersicht community.
# I stole from so many I can't remember who you are, thank you so much everyone!
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

command: "osascript 'Sidebar.widget/Next Event.widget/Next Event.applescript'"

refreshFrequency: '1m'

style: """
  white05 = rgba(white,0.5)
  white02 = rgba(white,0.2)

  width 176px

  .wrapper
    position: relative
    font-size 8pt
    line-height 11pt
    color white
    height 48px

  .time
    float left
    font-size 10pt
    font-weight 700
    text-align center
    position relative
    top 50%
    -webkit-transform translateY(-50%)
    width auto
    margin auto 8px

  .text
    position relative
    top 50%
    -webkit-transform translateY(-50%)
    width auto
    margin-right 8px
    text-align left
    overflow hidden

  .eventName, .meta
    display block
    text-align left
    white-space nowrap
    overflow hidden
    text-overflow ellipsis

  .meta, .noEvents
    color white05
"""

render: (output) ->

  # Get our pieces.
  values = output.split("^")

  # Initialize our HTML.
  NextEventHTML = ''

  # Create the DIVs for each piece of data.
  NextEventHTML = "
    <div class='wrapper'>
      <div class='time'>" + values[0] + "</div>
      <div class='text'>
        <span class='eventName'>" + values[1] + "</span>
        <span class='meta'>" + values[2] + "</span>
      </div>
    </div>"
  return NextEventHTML

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)

  # Get our pieces.
  values = output.slice(0,-1).split("^")

  # Initialize main HTML.
  NextEventHTML = ''
  $(domEl).find('.time').html(values[0])
  $(domEl).find('.eventName').html(values[1])
  $(domEl).find('.meta').html(values[2])

  if values[0] == 'No Events'
    $(domEl).find('.wrapper').css('height', '0')
    $(domEl).parent('div').css('margin-top', '-1px')
  else
    $(domEl).find('.wrapper').css('height', '48px')

  if parseInt(values[2]) != 0
    $(domEl).find('.meta').css('height', 'auto')
  else
    $(domEl).find('.meta').css('height', '0')

  # Sort out flex-box positioning.
  $(domEl).parent('div').css('order', '2')
  $(domEl).parent('div').css('flex', '0 1 auto')