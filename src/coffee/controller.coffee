class SwanKiosk.Controller
  @defaultAction: 'index'

  constructor: (params = {}) ->
    @params = params
    @_route params.action || @constructor.defaultAction

  _route: (action) ->
    if action in @_getRoutes()
      this[action]()
    else
      console.error "No route found for #{action}"

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
