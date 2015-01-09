class SwanKiosk.World
  self = null
  constructor: (@value = {}) ->
    self = this
  call: ->
    @value
  pipe: (out) ->
    -> out.call self, self.value

class SwanKiosk.Transform extends SwanKiosk.World
  call: (context, dictionary) ->
    @value context, dictionary
