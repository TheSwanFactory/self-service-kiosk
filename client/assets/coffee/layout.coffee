class SwanKiosk.Layout
  @build: (layout) ->
    "<#{layout.tag}>#{layout.contents}</#{layout.tag}>"

module?.exports = SwanKiosk.Layout
