SwanKiosk.Layout.handledAttributes.visible = (expression, element, dictionary) ->
  dictionary.style ?= {}
  unless eval(expression)
    dictionary.style.display = 'none'
