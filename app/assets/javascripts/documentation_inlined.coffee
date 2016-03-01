# This coffeescript is the js that is inlined on the swagger index page
$ ->  
  url = "#{window.base_url}/api/v2/swagger_doc"
  window.swaggerUi = new SwaggerUi(
    url: url
    dom_id: "swagger-ui-container"
    supportedSubmitMethods: [
      "get"
      "post"
      "put"
      "delete"
    ]
    onComplete: (swaggerApi, swaggerUi) ->
      $("pre code").each (i, e) ->
        hljs.highlightBlock e
        return

      return

    onFailure: (data) ->
      log "Unable to Load SwaggerUI"
      return

    docExpansion: "none"
    sorter: "alpha"
  )

  window.swaggerUi.load()
  