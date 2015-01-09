class SwanKiosk.World
  constructor: (@value = {}) ->
  call: ->
    @value
  pipe: (out) ->
    out.call this, @value
    this

class SwanKiosk.Transform extends SwanKiosk.World
  call: (context, dictionary) ->
    @value context, dictionary
