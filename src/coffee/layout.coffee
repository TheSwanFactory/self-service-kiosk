class SwanKiosk.Layout
  @specialAttributes = ['contents', 'tag', 'rawHtml', '_context']
  @defaultTag        = 'div'
  # Top level function for turning an object into HTML
  @build: (layout = {}) =>
    @context = layout._context || null
    @setDefaults layout
    @buildTag layout

  @setDefaults: (layout) ->
    if _.isArray(layout) or _.isString(layout)
      layout = {contents: layout}
    layout.tag ?= @defaultTag
    layout

  @buildTag: (parent, options) ->
    unless options? || parent instanceof HTMLElement
      options = parent
      parent = null
    options  = @setDefaults options
    element  = @buildElement options

    @buildAttributes element, options
    @buildContents element, options

    if parent?
      parent.appendChild(element)
    else
      element

  @buildElement: (options) ->
    document.createElement options.tag

  @buildOpenTag: (options) ->
    attributes = @buildAttributes options
    attributes = ' ' + attributes if attributes.length
    "<#{options.tag}#{attributes}>"

  @buildAttributes: (element, options) ->
    _(Object.keys options)
      .difference(@specialAttributes) # remove specialAttributes
      .map(@buildSingleAttribute(element, options), this)

  @buildSingleAttribute: (element, options) ->
    (attribute) ->
      key   = SwanKiosk.Utils.dasherize attribute
      value = options[attribute]
      if _.isObject value
        if key == 'style'
          value = @buildStyleAttribute value
        else if key == 'events'
          return @addEventListeners element, value
        else
          value = JSON.stringify value
      element.setAttribute key, value

  @addEventListeners: (element, events) ->
    context = @context || this
    for name, func of events
      if typeof func != 'function'
        str = "this.#{func}"
        func = (event) -> eval(str).call(this, element, event)
      element.addEventListener name, func.bind(context)

  @buildStyleAttribute: (style) ->
    _(style).map((value, key) ->
      "#{SwanKiosk.Utils.dasherize key}: #{value};"
    ).join ''

  @buildContents: (element, options) ->
    contents = options.contents || ''
    if _.isPlainObject(contents)
      contents = [contents]
    return @buildArray element, contents if _.isArray(contents)

    if !(contents instanceof HTMLElement)
      contents = contents.toString()
      contents = _.escape(contents) unless options.rawHtml
      contents = document.createTextNode contents
    element.appendChild contents
    contents

  @buildArray: (element, array) ->
    array.map @buildTagFactory(element), this

  @buildTagFactory: (element) ->
    (contents) -> @buildTag element, contents

  @buildCloseTag: (options) ->
    "</#{options.tag}>"

