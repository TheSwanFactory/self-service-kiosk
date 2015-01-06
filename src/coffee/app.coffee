# Initialize all namespaces
SwanKiosk =
  Interpreters: {}
  Components:   {}
  Controllers:
    _find: (name) ->
      _.find this, (value, key) ->
        key.split('Controller')[0].toLowerCase() == name

  create: (klass, args) ->
    new klass args

  init: ->
    page hashbang: true # setup router

# on page load
$ SwanKiosk.init
