class SwanKiosk.World
  self = null
  constructor: (@value = {}) ->
    self = this
  call: ->
    @value
  pipe: (out) ->
    new SwanKiosk.Pipeline this, out

class SwanKiosk.Transform extends SwanKiosk.World
  call: (context, dictionary) ->
    @value context, dictionary

class SwanKiosk.Pipeline
  constructor: (@world, transform) ->
    @sequence = [transform]

  pipe: (method) ->
    @sequence.push method
    this

  call: ->
    out = @world.value
    for transform in @sequence
      out = transform.call @world, out
    out

