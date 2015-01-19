World = Swan.World

class CharWorld extends World
  constructor: (contents = '', @_up = null) ->
    super()
    @_body = contents.split('')[0]


Swan.CharWorld = CharWorld
