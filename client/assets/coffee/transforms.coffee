SwanKiosk.Interpreter.Transforms =
  center: (dictionary) ->
    dictionary =
      class:    'grid-container'
      contents: dictionary
    dictionary

  verticalCenter: (dictionary) ->
    dictionary.class ?= ''
    dictionary.class += ' grid-block vertical align-center'
    SwanKiosk.Interpreter.Transforms.center dictionary
