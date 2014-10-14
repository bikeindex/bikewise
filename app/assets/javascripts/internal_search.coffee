appendIncidents = (data) ->
  $("#incidents_list").html(Mustache.render(incidents_list, data))
  if $('#body_display').length > 0
    $("#body_display").text(JSON.stringify(data,undefined,2))
  # $("#incidents_list").fadeIn('fast')
  # $("#incidents_list").append(JSON.stringify(data.incidents[0],undefined,2))
  formatDates()

formatDates = ->
  # Make dates human readable (and shorter)
  today = new Date()
  yesterday = new Date()
  yesterday.setDate(today.getDate() - 1)
  yesterday = yesterday.toString().split(/\d{2}:/)[0]
  today = today.toString().split(/\d{2}:/)[0]

  for ds in $(".ts2process")
    ds = $(ds)
    sdate = new Date(ds.text().trim()*1000)
    date = sdate.toString().split(/\d{2}:/)[0]
    date = 'Today' if date == today
    date = 'Yesterday' if date == yesterday
    ds.text(date)
    ds.removeClass('.ts2process')

getResults = (per_page=10) ->
  params = $('#home_search').serialize()
  url = $('#home_search').attr('data-target') + "?#{params}"
  url += "&per_page=#{per_page}" unless url.match('per_page')
  $.ajax
    type: "GET"
    url: url
    success: (data, textStatus, jqXHR) ->
      appendIncidents(data)
    error: ->
      console.log(data)
  $('#url_display').text(url) if $('#url_display').length > 0

$(document).ready ->
  getResults(5)
  $('#home_search').submit (e) ->
    e.preventDefault()
    # $("#incidents_list").fadeOut('fast')
    getResults()
  picker = new Pikaday(field: $("#occurred_before")[0])


incidents_list = """
  <ul>
    {{#incidents}}
      <li>
        <h4><span class="ts2process">{{occurred_at}}</span> - {{title}}</h4>
        <p>{{description}}</p>
        <p>
          {{address}}
          <em>First reported on
          <a href="{{source.html_url}}" target="_blank">{{source.name}}</a></em>
        </p>
        <img src="{{media.image_url_thumb}}">
      </li>
    {{/incidents}}
  </ul>
  {{^incidents}}
    <div class="no-incidents">
      <h2>We're sorry, no incidents were found!</h2>
    </div>
  {{/incidents}}
"""
