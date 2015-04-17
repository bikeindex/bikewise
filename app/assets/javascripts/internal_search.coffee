appendIncidents = (data) ->
  $("#incidents_list").html(Mustache.render(incidents_list, data))
  if $('#dev_display').length > 0
    $("#body_display").text(JSON.stringify(data,undefined,2))
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
  params = $('#internal_incident_search').serialize()
  url = $('#internal_incident_search').attr('data-target') + "?#{params}"
  url += "&per_page=#{per_page}" unless url.match('per_page')
  $.ajax
    type: "GET"
    url: url
    success: (data, textStatus, jqXHR) ->
      appendIncidents(data)
    error: (data) ->
      console.log(data)
  if $('#dev_display').length > 0
    $('#url_display').text(url)
    $('#url_parameters').text('')
    for param in params.split('&')
      if param.split('=')[1].length > 0
        dparam = decodeURI(param).replace('=', ' = ')
        $('#url_parameters').append(dparam + "\n") 

$(document).ready ->
  if $('#internal_incident_search').length > 0 
    getResults(5)
    $('#internal_incident_search').submit (e) ->
      e.preventDefault()
      getResults()
    picker = new Pikaday(field: $("#occurred_before")[0])


incidents_list = """
  <div class="total-count">{{meta.total_count}} matching incidents</div>

  <ul>
    {{#incidents}}
      <li>
        <h4><a href="{{source.html_url}}" target="_blank">{{title}}</a> - <span class="ts2process">{{occurred_at}}</span></h4>
        <p>{{description}}</p>
        <p>
          {{address}}
          <span class='less-strong'>first reported on {{source.name}}</span>
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
