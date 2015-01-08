SwanKiosk.Layout.handledAttributes.visible = (expression, element, dictionary) ->
  dictionary.style ?= {}
  expression = eval expression
  expression = expression.call(this) if typeof expression == 'function'
  unless expression
    dictionary.style.display = 'none'
    SwanKiosk.Layout.handleAttribute 'style', element, dictionary
