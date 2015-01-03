SwanKiosk.Components =
  center: (dictionary) ->
    dictionary =
      class:    'grid-container'
      contents: dictionary
    dictionary

  verticalCenter: (dictionary) ->
    dictionary.class ?= ''
    dictionary.class += ' grid-block vertical align-center'
    @center dictionary

  link: (contents, href = '#', options = {}) ->
    if _.isPlainObject(href) and _.isEqual(options, {})
      options = href
      href    = '#'
    _.extend({
      tag:      'a'
      contents: contents
      href:     href
    }, options)
