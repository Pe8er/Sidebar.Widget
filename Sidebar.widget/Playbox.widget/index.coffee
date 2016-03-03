# Code originally created by the awesome members of Ubersicht community.
# I stole from so many I can't remember who you are, thank you so much everyone!
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

command: "sh 'Sidebar.widget/Playbox.widget/playbox.sh'"

refreshFrequency: '1s'

style: """

  white1 = rgba(white,1)
  white05 = rgba(white,0.5)
  white02 = rgba(white,0.2)
  black02 = rgba(black,0.2)

  width 176px
  overflow hidden
  white-space nowrap
  opacity 0

  .wrapper
    font-size 8pt
    line-height 11pt
    color white
    padding 8px

  .art
    width 44px
    height @width
    background-size cover
    float left
    margin 0 8px 0 0
    border-radius 50%

  .text
    foat left

  .progress
    width: @width
    height: 2px
    background: white1
    position: absolute
    bottom: 0
    left: 0

  .wrapper, .album, .artist, .song
    overflow: hidden
    text-overflow: ellipsis

  .song
    font-weight: 700

  .album
    color white05

"""

render: (output) ->

  # Get our pieces.
  values = output.split(" ~ ")

  # Initialize our HTML.
  medianowHTML = ''

  # Progress bar things.
  tDuration = values[4].replace(',','.')
  tPosition = values[5].replace(',','.')
  player = values[6]
  tArtwork = values[7]

  # Create the DIVs for each piece of data.
  medianowHTML = "
    <div class='wrapper'>
      <div class='art' style='background-image: url(Sidebar.widget/Playbox.widget/as/default.png)'></div>
      <div class='text'>
        <div class='song'>" + values[1] + "</div>
        <div class='artist'>" + values[0] + "</div>
        <div class='album'>" + values[2]+ "</div>
      </div>
      <div class='progress'></div>
    </div>"

  return medianowHTML

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)

  # Get our pieces.
  values = output.slice(0,-1).split(" ~ ")

  # Initialize our HTML.
  medianowHTML = ''

  # Progress bar things.
  tDuration = values[4].replace(',','.')
  tPosition = values[5].replace(',','.')
  player = values[6]
  tArtwork = values[7]
  tWidth = $(domEl).width();
  tCurrent = (tPosition / tDuration) * tWidth

  currArt = $(domEl).find('.art').css('background-image').split('/').pop().slice(0,-1)

  if values[0] == 'NA'
    $(domEl).animate({ opacity: 0 }, 250)
  else
    $(domEl).animate({ opacity: 1 }, 250)
    $(domEl).find('.song').html(values[1])
    $(domEl).find('.artist').html(values[0])
    $(domEl).find('.album').html(values[2])
    $(domEl).find('.progress').css width: tCurrent
    if tArtwork isnt currArt
      $(domEl).find('.art').css('background-image', 'url(Sidebar.widget/Playbox.widget/as/'+tArtwork+')')

  # Sort out flex-box positioning.
  $(domEl).parent('div').css('order', '7')
  $(domEl).parent('div').css('flex', '0 1 auto')