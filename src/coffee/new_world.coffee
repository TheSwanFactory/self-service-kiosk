# Properties
# - named
# - enunerated
# Scope
# Callable
# .- call or apply
# Magic properties
# - up (data)
# - get (method)
# - sub (method)
# - subs (data)
# - each (method: subs)
# - each_prop (method: Object.keys - magic)
# -do (method)
# - done (method)
# - out (data)
# plus who can see or change various values

Swan = {}
GOD  =
  get: -> null

class Swan.World
  constructor: (contents = {}, @_up = null) ->
    @_subs = []
    @_body = []
    @_out  = null
    @_fold = null
    @set(property, value) for property, value of contents

  up: ->
    @_up || GOD

  out: ->
    @_out

  # Invocation

  do: (world, args) =>
    @sub.apply this, arguments

  done: ->

  # properties

  set: (property, value) ->
    this[property] = value

  has: (property) ->
    this[property]?

  get: (property) ->
    if @has property
      if typeof this[property] == 'function'
        this[property](this)
      else
        this[property]
    else
      @up().get property

  fold: ->
    @_fold

  # body

  body: ->
    @_body

  push: (value) =>
    @_body.push value

  unshift: (value) =>
    @_body.unshift value

  update: (array) =>
    @_body = array

  # subs

  sub: (contents) ->
    @sub_push new @constructor(contents, this)

  sub_push: (contents) ->
    @subs().push contents

  subs: ->
    @_subs

  @array_sub: (array) ->
    world = new this array

  # Enumeration

  each: (world) =>
    return unless world instanceof @constructor

    for sub in @subs()
      world.do this, sub

    @done()

  each_prop: (world) =>
    return unless world instanceof @constructor

    for property in Object.keys(this)
      world.do this, property

    @done()
