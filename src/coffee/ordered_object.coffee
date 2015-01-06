class OrderedObject

  constructor: (object = {}) ->
    throw new Error('only plain objects allowed') unless isPlainObject(object)

    @set object

  reset: ->
    @_keys   = []
    @_values = []

  # Add/Remove

  push: (key, value) =>
    @remove key if @has key
    @_keys.push key
    @_values.push value

  unshift: (key, value) =>
    @remove key if @has key
    @_keys.unshift key
    @_values.unshift value

  remove: (key) =>
    return unless @has key

    index = @indexOf key
    @_keys.splice index, 1
    @_values.splice index, 1

  set: (object) ->
    @reset()
    @push(key, value) for key, value of object

  # Get

  get: (key) =>
    return undefined unless @has(key)

    @_values[@indexOf(key)]

  has: (key) ->
    @indexOf(key) > -1

  indexOf: (key) ->
    @_keys.indexOf key

  # Iterate

  forEach: (cb) ->
    cb(key, @_values[i]) for key, i in @_keys

  # Export

  toObject: ->
    object = {}
    @forEach (key, value) -> object[key] = value
    object

isPlainObject = (obj) ->
  !!obj && typeof(obj) == 'object' && obj.constructor == Object
