class SwanKiosk.Store.LocalStorage extends SwanKiosk.Store
  set: (key, value) ->
    return @setMany(key) if typeof key == 'object'

    value = JSON.stringify(value) if typeof value == 'object'

    localStorage[key] = value

  setMany: (properties) ->
    @set(key, value) for key, value of properties

  get: (key) ->
    return @getMany(key) if _.isArray key

    value = localStorage[key]

    return null unless value?

    switch
      when value == 'true'         then true
      when value == 'false'        then false
      when value.match /^\d+$/     then parseInt value, 10
      when value.match /^[\d\.]+$/ then parseFloat value, 10
      else value

  getMany: (keys) ->
    values = []
    values.push(@get key) for key in keys
    values

  getObject: (key) ->
    try
      JSON.parse @get(key)
    catch
      undefined
