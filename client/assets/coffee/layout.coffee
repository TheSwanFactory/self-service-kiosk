class SwanKiosk.Layout
  @specialAttributes = ['contents', 'tag', 'rawHtml']
  # Top level function for turning an object into HTML
  @build: (@layout) ->
    @buildTag @layout

  @buildContents: (options) ->
    contents = options.contents
    if _.isArray(contents)
      contents = @buildArray contents
    else
      contents = _.escape(contents) unless options.rawHtml

    contents

  @buildArray: (array) ->
    array.map(@buildTag, this).join('')

  @buildTag: (options) ->
    openTag  = @buildOpenTag options
    contents = @buildContents options
    closeTag = @buildCloseTag options
    "#{openTag}#{contents}#{closeTag}"

  @buildOpenTag: (options) ->
    attributes = @buildAttributes options
    attributes = ' ' + attributes if attributes.length
    "<#{options.tag}#{attributes}>"

  @buildAttributes: (options) ->
    _(Object.keys options)
      .difference(@specialAttributes) # remove specialAttributes
      .map(@buildSingleAttribute(options), this)
      .join ' '

  @buildSingleAttribute: (options) ->
    (attribute) ->
      key   = SwanKiosk.Utils.dasherize attribute
      value = options[attribute]
      if _.isObject value
        if key == 'style'
          value = @buildStyleAttribute value
        else
          value = JSON.stringify value
      "#{key}=\"#{value}\""

  @buildStyleAttribute: (style) ->
    _(style).map((value, key) ->
      "#{SwanKiosk.Utils.dasherize key}: #{value};"
    ).join ''

  @buildCloseTag: (options) ->
    "</#{options.tag}>"

