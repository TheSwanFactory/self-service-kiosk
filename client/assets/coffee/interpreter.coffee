SwanKiosk.Interpreter.interpret = (dictionary = {}) ->
  # look for interpreters
  # if not found
  dictionary

SwanKiosk.Interpreters.Question = (dictionary) ->
  why = 'Why are we asking this question?'

  questionOption = (option) ->
    {tag: 'a', class: 'answer', contents: option}

  [
    {
      class:    'header'
      contents: [{
        class: 'question'
        contents: {tag: 'h1', contents: dictionary.title}
      }, SwanKiosk.Interpreter.Components.verticalCenter({
        class:    'why-wrapper',
        contents: {tag: 'a', class: 'why', contents: @why, title: dictionary.why}
      })]
    },
    {
      class:    'body'
      contents: SwanKiosk.Interpreter.Components.center(_.map dictionary.select, questionOption)
    },
    {
      class:    'navigation',
      contents: [{
        class:    'start-over'
        contents: {tag: 'a', contents: 'Start Over'}
      }, {
        class:    'change-page',
        contents: [
          SwanKiosk.Interpreter.Components.link('Previous', class: 'previous')
          SwanKiosk.Interpreter.Components.link('Next',     class: 'next')
        ]
      }]
    }
  ]
