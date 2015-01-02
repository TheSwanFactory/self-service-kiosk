SwanKiosk.Interpreters = {}
SwanKiosk.Interpreter =
  interpret: (dictionary = {}) ->
    # look for interpreters
    # if not found
    dictionary

SwanKiosk.Interpreters.Question =
  interpret: (dictionary) ->
    [
      {
        class:    'header'
        contents: [contents: dictionary.title]
      }
    ]


