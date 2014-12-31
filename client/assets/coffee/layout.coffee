class SwanKiosk.Layout
  # Top level function for turning an object into HTML
  @build: (layout) ->
    @buildTag layout

  @buildContents: (options) ->
    contents = options.contents
    if Array.isArray(contents)
      contents = @buildArray contents
    else
      contents = _.escape(contents) unless options.rawHtml

    contents

  @buildArray: (array) ->
    array.map(@buildTag, this).join('')

  @buildTag: (options) ->
    "<#{options.tag}>#{@buildContents options}</#{options.tag}>"


