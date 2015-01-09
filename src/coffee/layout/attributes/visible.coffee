utils = SwanKiosk.Utils

SwanKiosk.Layout.handle 'visible', (expression, element, dictionary) ->
  dictionary.style ?= {}
  expression = utils.getFunction expression, this, true
  unless expression
    dictionary.style.display = 'none'
    SwanKiosk.Layout.handleAttribute 'style', element, dictionary
