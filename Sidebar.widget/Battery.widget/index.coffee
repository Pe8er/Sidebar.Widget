# Code originally created by the awesome members of Ubersicht community.
# I stole from so many I can't remember who you are, thank you so much everyone!
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

options =
  # Easily enable or disable the widget.
  widgetEnable: true

  # Choose color theme.
  widgetTheme: "dark"                   # dark | light

command: "osascript 'Sidebar.widget/Battery.widget/battery.applescript'"

refreshFrequency: '1s'

style: """

  if #{options.widgetTheme} == dark
    fColor = white
    bgColor = black
  else
    fColor = black
    bgColor = white

  fColor1 = rgba(fColor,1.0)
  fColor08 = rgba(fColor,0.8)
  fColor05 = rgba(fColor,0.5)
  fColor02 = rgba(fColor,0.2)
  bgColor1 = rgba(bgColor,1.0)
  bgColor08 = rgba(bgColor,0.7)
  bgColor05 = rgba(bgColor,0.5)
  bgColor02 = rgba(bgColor,0.2)

  width 176px
  overflow hidden
  white-space nowrap
  opacity 0
  background-color bgColor02

  *, *:before, *:after
    box-sizing border-box

  .wrapper
    font-size 8pt
    line-height 11pt
    margin 2px
    height 20px
    opacity 1
    position relative

  .bar
    background-color fColor02
    height 20px
    min-width 1%
    max-width 100%
    z-index 1
    position absolute
    top 0
    left 0

  .box
    width 100%
    position absolute
    z-index 2
    text-align center

  .time
    display block
    background none
    width auto
    max-width 30%
    min-width 10%
    margin 0 auto
    color fColor1
    font-weight 700
    line-height 20px

"""

options : options

render: (output) ->
  # Initialize our HTML.
  batteryHTML = ''

  # Create the DIVs for each piece of data.
  batteryHTML = "
    <div class='wrapper'>
      <div class='bar'></div>
      <div class='box'>
        <span class='time'>No Data</span>
      </div>
     </div>"
  return batteryHTML

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)

  if @options.widgetEnable
    # Get our pieces.
    values = output.slice(0,-1).split(" ")

    # Initialize our HTML.
    batteryHTML = ''
    div.find('.bar').css('width', values[0])
    div.find('.time').html(values[1])

    if values[0] != "NA"
      div.animate({ opacity: 1 }, 250)
      if parseInt(values[0]) < 10
        div.find('.bar').css('background-color', 'rgba(255,0,0,0.5)')
      else
        div.find('.bar').css('background-color', '')

      if values[2] == 'charging'
        div.find('.time').css('background', 'url(Sidebar.widget/battery.widget/Bolt.svg) left center no-repeat')
      else
        div.find('.time').css('background', 'none')
    else
      div.animate({ opacity: 0 }, 250)
      div.parent('div').css('margin-top', '-1px')

    # Sort out flex-box positioning.
    div.parent('div').css('order', '7')
    div.parent('div').css('flex', '0 1 auto')
  else
    div.remove()
