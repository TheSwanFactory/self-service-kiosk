class SwanKiosk.World
  @new: (klass, args) ->
    -> new klass args
  constructor: (@dictionary = {}) ->
  get: ->
    @dictionary
  pipe: (next) ->
    next @get()
