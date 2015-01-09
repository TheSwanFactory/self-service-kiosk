class SwanKiosk.Controller
  defaultAction: 'index'
  bodySelector:  'body'
  rendered:      false
  layout:        false

  constructor: (@params = {}) ->
    @_afterInitialize() if @_afterInitialize?

  # Callbacks

  _afterInitialize: ->

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

    @_beforeAction() if @_beforeAction?
    @_render action.call(this)

  _getRoute: (route) ->
    if @_getRoutes().indexOf
      console.log

  # Get routes for this controller. Can be defined manually, or router will
  # follow javascript convention and only return functions that do not start
  # with an underscore (meaning private)
  _getRoutes: ->
    return @routes if @routes?

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
    @_getBody().empty()
    @_getBody().append contents

  _renderPlain: (contents) ->
    return false if @rendered
    @rendered = true
    @_getBody().html contents
