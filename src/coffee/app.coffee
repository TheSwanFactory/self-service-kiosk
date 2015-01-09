# Initialize all namespaces
class SwanKiosk
  @Interpreters: {}
  @Components:   {}
  @Config:       {}
  @Store:        {}
  @Controllers:
    _find: (name) ->
      _.find this, (value, key) ->
        key.split('Controller')[0].toLowerCase() == name.toLowerCase()

  @create: (klass, args) ->
    new klass args

  _instances = {}
  @singleton: (klass, args) ->
    _instances[klass.name] ?= @create(klass, args)

  @init: ->
    page hashbang: true # setup router
    $('.tooltip').tooltipster
      theme: 'tooltipster-light'

# on page load
$ SwanKiosk.init

$.ajax(
  url: '/assets/config/kiosk-config.json'
  async: false
).done (data) ->
  SwanKiosk.Config = data
