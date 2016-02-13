# Code originally created by the awesome members of Ubersicht community.
# I stole from so many I can't remember who you are, thank you so much everyone!
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

command: "osascript 'Sidebar.widget/Time Elapsed.widget/Time Elapsed.applescript'"

refreshFrequency: '1h'

style: """
  white1 = rgba(white,1)
  white05 = rgba(white,0.5)
  white02 = rgba(white,0.2)
  black02 = rgba(black,0.2)

  width 176px
  overflow hidden
  white-space nowrap

  *, *:before, *:after
    box-sizing border-box

  .wrapper
    position: relative
    font-size 8pt
    line-height 11pt
    color white
    padding 8px
    align-items center
    display flex

  .box
    width 33%
    float left
    text-align center
    color white05

  .box span
    display block

  .box span:first-of-type
    font-weight 700
    color white
"""

render: (output) ->

  # Get our pieces.
  values = output.split(" ")

  # Initialize our HTML.
  elapsedHTML = ''

  # Create the DIVs for each piece of data.
  elapsedHTML = "
    <div class='wrapper'>
      <div class='box'>
        <span>" + values[0] + "</span>
        <span>" + values[1] + "</span>
      </div>
      <div class='box'>
        <span>" + values[2] + "</span>
        <span>" + values[3] + "</span>
      </div>
      <div class='box'>
        <span>" + values[4] + "</span>
        <span>" + values[5] + "</span>
      </div>
    </div>"
  return elapsedHTML

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)

  # Get our pieces.
  values = output.slice(0,-1).split(" ")

  # Initialize our HTML.
  elapsedHTML = ''

  # Sort out flex-box positioning.
  $(domEl).parent('div').css('order', '4')
  $(domEl).parent('div').css('flex', '0 1 auto')