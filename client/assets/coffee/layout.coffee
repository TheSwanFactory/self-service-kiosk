class SwanKiosk.Layout
  # Top level function for turning an object into HTML
  @build: (layout) ->
    @recursiveBuild layout

  @recursiveBuild: (layout) ->
    if Array.isArray(layout.contents)
      layout.contents = @buildArray layout.contents

    @buildTag layout

  @buildArray: (array) ->
    array.map(@recursiveBuild, this).join('')

  @buildTag: (options) ->
    "<#{options.tag}>#{options.contents}</#{options.tag}>"


