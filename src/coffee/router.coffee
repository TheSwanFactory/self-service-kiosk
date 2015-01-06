SwanKiosk.Router =
  init: (options = {}) ->
    @reset()
    @bindEvents()

  reset: ->
    @routes = []

  bindEvents: ->
    $(window).on 'hashchange', @hashChange

  currentPath: ->
    location.hash.split('#')[1] || ''

  hashChange: ->

  add: (route, func) ->
    unless _.isString(route) || _.isRegExp(route)
      throw new Error('route must be a string or regular expression')

    @routes.push route: route, func: func

  route: (path) ->
    route = @findRoute path

  findRoute: (path) ->
    for route in @routes
      console.log route

