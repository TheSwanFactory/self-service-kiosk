# Initialize all namespaces
SwanKiosk =
  Interpreters: {}
  Components:   {}
  Controllers:
    _find: (name) ->
      _.find this, (value, key) -> key.toLowerCase() == name
  Create: (klass, args) ->
    new klass args
