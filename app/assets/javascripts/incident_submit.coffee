selectIncidentType = (incident_type) ->
  if incident_type == 'theft'
    $('#bw-int-wrap #int-occur').fadeOut 'fast', ->
      $('#bw-int-wrap #binx-expl').fadeIn()
    unless $('#bw-int-wrap #binx_embed iframe').length > 0
      $('#bw-int-wrap #binx_embed').append('<iframe src="https://bikeindex.org/organizations/bikewise/embed?stolen=true"></iframe>')
    $('#bw-int-wrap #binx_embed').slideDown()  
  else
    $('#bw-int-wrap #binx_embed').slideUp()
    if incident_type? && incident_type.length > 0
      setNonTheft(incident_type)
    else
      $('#bw-int-wrap .scndary-group').fadeOut()
      $('#bw-int-wrap #int_fields').slideUp()

setNonTheft = (incident_type) ->
  incident_name = incident_type.replace('_', ' ')
  $('#bw-int-wrap #int-occur').attr('data-int', incident_type)
  $('#bw-int-wrap .scndary-group').fadeOut('fast').promise().done ->
    if incident_type == 'crash'
      occur = "When did this crash happen?"
    else
      occur = "When did you first notice this #{incident_name}"
    $('#bw-int-wrap #int-occur label').text(occur)
    $('#bw-int-wrap #int-occur').fadeIn()

  $('#bw-int-wrap #int_fields').slideDown()

validReport = ->
  form = $('#bw_int_form')
  incident = 
    address: form.find('#address').val()
    occurred_at: form.find('#occurred_at').val()
    incident_type: form.find('#incident_type').val()
    # latitude: form.find('#latitude').val()
    # longitude: form.find('#longitude').val()
    # create_open311_report: form.find('#create_open311_report').val()
    description: form.find('#description').val()
    title: form.find('#title').val()
    media:
      image_url: ""
      image_url_thumb: ""

reportSuccess = (report_type) ->
  html = "<h3>#{report_type} submitted successfully</h3><p>Thank you!</p>"
  $('#int_fields').fadeOut 400, ->
    $('#bw-int-wrap').append(html)

reportError = ->
  $('#bw-int-wrap').append("We're sorry, there was an error submitting your report")  

window.addIncident = ->
  report = validReport()
  if report?
    $.ajax
      type: "POST"
      url: $('#bw_int_form').attr('data-target')
      data: 
        incident:
          JSON.stringify(report)
      success: (data, textStatus, jqXHR) ->
        reportSuccess(report.incident_type)
      error: (data, textStatus, jqXHR) ->
        reportError()
        # console.log(textStatus)

$(document).ready ->
  # $('#bw-int-wrap #incident_type').selectize({
  #     sortField: 'text'
  # });
  $('#bw-int-wrap #incident_type').on 'change', ->
    selectIncidentType($('#bw-int-wrap #incident_type').val())

  $('#bw_int_form').submit (e) ->
    e.preventDefault()
    addIncident()
