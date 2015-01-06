class SwanKiosk.Controller
  defaultAction: 'index'
  # selector for rendering
  bodySelector: 'body'

  constructor: (@params = {}) ->

  # Routing

  _route: (action) ->
    action = @params.action || @defaultAction unless action?

    if action in @_getRoutes()
      action = this[action]
    else if @show?
      @params.id = @params.action
      action = @show
    else
      throw new Error "No route found for #{@constructor.name}##{action}"

    @_render action()

  _getRoute: (route) ->
    if @_getRoutes().indexOf
      console.log

  _getRoutes: ->
    routes = []
    for route of this
      unless route == 'constructor' or
             route.match(/^_/) or # private
             typeof this[route] isnt 'function'
        routes.push route
    routes

  # Rendering

  _render: (contents) ->
    $(@bodySelector).html contents
