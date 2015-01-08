SwanKiosk.Layout.handledAttributes.style = (style, element) ->
  style = _(style).map((value, key) ->
    "#{SwanKiosk.Utils.dasherize key}: #{value};"
  ).join ''
  element.setAttribute 'style', style
