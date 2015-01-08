class SwanKiosk.Layout
  @defaultTag        = 'div'
  @specialAttributes = ['contents', 'tag', 'rawHtml', '_context']
  @handledAttributes = {}
  @handledKeys: -> Object.keys @handledAttributes

  @registerAttribute: (attribute, func) ->

  # Top level function for turning an object into HTML
  @build: (layout = {}) =>
    @context = layout._context || this
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
    @buildHandledAttributes element, options
    _(Object.keys options)
      .difference(@specialAttributes.concat(@handledKeys()))
      .map(@buildSingleAttribute(element, options), this)

  @buildHandledAttributes: (element, options) ->
    keys = _.intersection @handledKeys(), Object.keys(options)
    @handleAttribute(key, element, options) for key in keys

  @handleAttribute: (key, element, options) ->
    @handledAttributes[key].call @context, options[key], element, options

  @buildSingleAttribute: (element, options) ->
    (attribute) ->
      key   = SwanKiosk.Utils.dasherize attribute
      value = options[attribute]
      if _.isObject value
        value = JSON.stringify value
      element.setAttribute key, value

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

