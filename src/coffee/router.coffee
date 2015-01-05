SwanKiosk.Router =
  init: ->

  currentPath: ->
    location.hash.split('#')[1] || ''
