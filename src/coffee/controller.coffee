class SwanKiosk.Controller
  defaultAction: 'index'
  bodySelector:  'body'
  rendered:      false
  layout:        false

  constructor: (@params = {}) ->

  # Routing

  _route: (action) ->
    action = action || @params.action

    if action in @_getRoutes()
      action = this[action]
    else if @show?
      @params.id = @params.action
      action = @show
    else if !action?
      action = this[@defaultAction]
    else
      throw new Error "No route found for #{@constructor.name}##{action}"

    @_render action.call(this)

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

  _getBody: ->
    @_body ?= $(@bodySelector)

  _render: (contents) ->
    return false if @rendered || !contents?
    @rendered = true
    contents = contents.get() if contents instanceof SwanKiosk.World
    if @layout
      contents = @layout contents
    contents._context = this
    contents = SwanKiosk.Layout.build contents
    @_getBody().html ''
    @_getBody().get(0).appendChild contents

  _renderPlain: (contents) ->
    return false if @rendered
    @rendered = true
    @_getBody().html contents
