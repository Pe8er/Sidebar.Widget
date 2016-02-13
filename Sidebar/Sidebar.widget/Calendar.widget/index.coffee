# Code originally created by Adam Vaughan (https://github.com/adamvaughan)
# Haphazardly adjusted and mangled by Pe8er (https://github.com/Pe8er)

sundayFirstCalendar = 'cal && date'

mondayFirstCalendar =  'cal | awk \'{ print " "$0; getline; print "Mo Tu We Th Fr Sa Su"; \
getline; if (substr($0,1,2) == " 1") print "                    1 "; \
do { prevline=$0; if (getline == 0) exit; print " " \
substr(prevline,4,17) " " substr($0,1,2) " "; } while (1) }\' && date'

command: mondayFirstCalendar

refreshFrequency: '1h'

style: """
  white1 = rgba(white,1)
  white05 = rgba(white,0.5)
  white02 = rgba(white,0.2)
  black02 = rgba(black,0.2)

  width 176px
  height auto
  overflow hidden

  .wrapper
    height 100%
    color white1
    position relative
    padding 8px
    align-items center
    display flex

  .wrapper table
    border-collapse: collapse
    table-layout: fixed
    margin 0 auto

  td
    text-align center
    padding 4px

  thead tr
    &:first-child td
      font-size 12pt
      font-weight 200
      color white1

    &:last-child td
      font-size 7.5pt
      padding-bottom 8px
      font-weight 500
      color white05

  tbody td
    font-size 7.5pt

  .today
    font-weight bold
    background white02
    border-radius 50%
    width 24px
    height 24px
    margin 0
    padding 0
"""

render: -> """

  <div class='wrapper'>
    <table>
      <thead>
      </thead>
      <tbody>
      </tbody>
    </table>
  </div>
"""

updateHeader: (rows, table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[0]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[1].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  tbody = table.find("tbody")
  tbody.empty()

  rows.splice 0, 2
  rows.pop()
  today = rows.pop().split(/\s+/)[2]

  for week, i in rows
    days = week.split(/\s+/).filter (day) -> day.length > 0
    tableRow = $("<tr></tr>").appendTo(tbody)

    if i == 0 and days.length < 7
      for j in [days.length...7]
        tableRow.append "<td></td>"

    for day in days
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day == today

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table

  # Sort out flex-box positioning.
  $(domEl).parent('div').css('order', '1')
  $(domEl).parent('div').css('flex', '0 1 auto')