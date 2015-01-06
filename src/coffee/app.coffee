# Initialize all namespaces
SwanKiosk =
  Interpreters: {}
  Components:   {}
  Config:       {}
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

$.ajax(
  url: '/assets/config/kiosk-config.json'
  async: false
).done (data) ->
  SwanKiosk.Config = data
