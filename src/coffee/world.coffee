class SwanKiosk.World
  constructor: (@dictionary = {}) ->
  get: ->
    @dictionary
  pipe: (next) ->
    next @get()
